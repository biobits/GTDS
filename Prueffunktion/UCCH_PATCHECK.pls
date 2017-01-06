--------------------------------------------------------------------------------------
-- Hauseigene Prüffunktion für Dokumentationen im GTDS.
-- Initial zur Prüfung von Items des GKR-Exportes
-- 20161219: Initiale Version
-- 20170103: Operationen und Innere Prüfung
-- 20170106: Bestrahlung/Verlauf und Abschluss

-- Parameter:
-- PATID -> Die GTDS-ID des Patienten
-- TUMID -> Die Lfdnr der Tumorerkrankung
-- NUREIGENEDOKU -> Schalter zur optionalen Prüfung von Dokumentationen externer Herkunft (Abteilungs ID=1)

---------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION UCCH_PATCHECK 
(
  PATID IN NUMBER
, TUMID IN VARCHAR2 
, NUREIGENEDOKU IN NUMBER :=0 --1=Nur eigene Dokumentationen werden geprüft 
) RETURN VARCHAR2 AS 

-- Variablen allg
V_NL varchar2(2); --Newline für Windows

--VAriablen PAtient;
V_GEBURTSDATUM date null;
V_GESCHLECHT varchar2(1) null;
V_PATIENTEN_ID VARCHAR2(30) null; --UKE-ID
V_STERBEDATUM date null;
V_TUMORTOD	VARCHAR2(1) null; --Tod Tumorbedingt
--Variablen zur Prüfung
V_COUNTER number null;
V_COUNTER2 number null;
V_COUNTER3 number null;
V_COUNTER4 number null;
V_COUNTER5 number null;
V_ERGEBNIS varchar2(4000) null;

--Diagnose Parameter
V_ICD varchar2(10) null; --ICD10
V_DIAG_ABT number null; -- Durchfuehrende Abt. der Diagnose
V_DIAG_DATUM date null; --DIagnosedatum
V_DIAG_SICH varchar2(10) null;--DIagnosesicherung
V_DIAG_LEISTUNG varchar2(4) null; --Leistungszustand
--KLassifikation
V_pT varchar2(5)null;
V_pN varchar2(5)null;
V_pM varchar2(5)null;
V_T varchar2(20)null;
V_N varchar2(20)null;
V_M varchar2(20)null;
V_Sonst_Stadium varchar2(10) null;
--OPERATION
--V_OPDATUM date null;
--V_OPINTENTION varchar2(1) null;
V_OP_C_TNM number null; --Counter für TNM die mit einer OP assoziiert sind 
--Syst.-Therapie
V_THER_C_SUB number null; --Counter für Substanzen die mit einer Int. Therapie assoziiert sind 
--Bestrahlung
V_RT_C_ZIEL number null; --Counter für Zielgebiete die mit einer Bestrahlung assoziiert sind 
V_RT_C_TEIL number null; --Counter für Teilbestrahlungen die mit einer Bestrahlung assoziiert sind 

BEGIN
select '' into  V_ERGEBNIS from DUAL;
select  chr(13)||chr(10) into V_NL from DUAL;
---------------------------------------------------------------------
-- PATIENT
---------------------------------------------------------------------

select p.GEBURTSDATUM,p.GESCHLECHT,p.PATIENTEN_ID,p.STERBEDATUM,p.TUMORTOD into V_GEBURTSDATUM,V_GESCHLECHT ,V_PATIENTEN_ID ,V_STERBEDATUM ,V_TUMORTOD
  from PATIENT p where PAT_ID =PATID;
---------------------------------------------------------------------
-- DIAGNOSE
---------------------------------------------------------------------
--ICD10 ermitteln
select ICD10,DURCHFUEHRENDE_ABT_ID,DIAGNOSEDATUM into V_ICD,V_DIAG_ABT,V_DIAG_DATUM from Tumor where FK_PATIENTPAT_ID=PATID and Tumor_id=TUMID;

if V_ICD is null then
  select V_ERGEBNIS||'ICD-10 Diagnose fehlt;'||V_NL into V_ERGEBNIS from DUAL;
end if;

if V_DIAG_DATUM is null then
  select V_ERGEBNIS||'Diagnosedatum fehlt;'||V_NL into V_ERGEBNIS from DUAL;
end if;

--nur EIgene Diagnose?
if (NUREIGENEDOKU =0 or V_DIAG_ABT>1) then
  --DIAGNOSESICHERHEIT

  --KLASSIFIKATION
  --SOnstige Klassifikation (hämatologisch, Hirntumor)
  select count(column_value) into v_COUNTER from table(sys.dbms_debug_vc2coll('C81%','C82%','C83%','C84%','C85%','C86','C88%','C9%','C7%','D32%','D33%','D35%','D36%')) where V_ICD like column_value;
  --FIGO Benötigt?
  select count(column_value) into v_COUNTER2 from table(sys.dbms_debug_vc2coll('C53%','C56%','C57%')) where V_ICD like column_value;
  if (V_COUNTER2>0) then
    -- FIGO abfragen
  
    select max(FK_STADIENEINTESTA) into V_Sonst_Stadium  from SONSTIGE_KLASSIFIK where FK_TUMORFK_PATIENT=PATID and to_number(FK_TUMORTUMOR_ID)=TUMID and HERKUNFT='D' and FK_STADIENEINTEFK in (18,23);
    if (V_Sonst_Stadium is null) then 
        select V_ERGEBNIS||'FIGO-Stadium bei Diagnose fehlt;'||V_NL into V_ERGEBNIS from DUAL;
    end if;
  elsif (V_COUNTER>0) then
    -- Klassifikation xyz
    select max(FK_STADIENEINTESTA) into V_Sonst_Stadium  from SONSTIGE_KLASSIFIK where FK_TUMORFK_PATIENT=PATID and FK_TUMORTUMOR_ID=to_number(TUMID) and HERKUNFT='D' ;
    if (V_Sonst_Stadium is null) then 
        select V_ERGEBNIS||'Klassifikation bei Diagnose fehlt;'||V_NL into V_ERGEBNIS from DUAL;
    end if;
  else --TNM checken
      select max(t1.T),max(t1.N),max(t1.Met) into V_T,V_N,V_M from TNM t1 where t1.FK_TUMORFK_PATIENT=PATID and t1.FK_TUMORTUMOR_ID=TUMID and t1.Herkunft='D';
      if (V_T is null or V_N is null or V_M is null) then 
        select V_ERGEBNIS||'TNM-Status bei Diagnose unvollständig;'||V_NL into V_ERGEBNIS from DUAL;
      end if;
   end if;
   
   --LEISTUNGSZUSTAND
   select  ECOG into V_DIAG_LEISTUNG from LEISTUNGSZUSTAND le where le.HERKUNFT='D' and le.FK_PATIENTPAT_ID=PATID and le.FK_TUMORTUMOR_ID=TUMID;
   if (V_DIAG_LEISTUNG is null) then
      select V_ERGEBNIS||'Leistungszustand bei Diagnose fehlt;'||V_NL into V_ERGEBNIS from DUAL;
    end if;
   
   
end if;

---------------------------------------------------------------------
-- OP 
---------------------------------------------------------------------
declare cursor c_operation is select * from OPERATION
   where FK_TUMORFK_PATIENT =PATID and FK_TUMORTUMOR_ID=TUMID;

begin
  for r_op in c_operation loop
  if (NUREIGENEDOKU =0 or r_op.DURCHFUEHRENDE_ABT_ID>1) then
      -- OP ohne OP-Intention vorhanden?
      if (r_op.INTENTION is null) then
         select V_ERGEBNIS||'OP['||r_op.OP_NUMMER||']: OP-Intention fehlt;'||V_NL into V_ERGEBNIS from DUAL;
      end if;
      
      -- OP (kurativ/palliativ) 
      if (r_op.INTENTION ='K' or r_op.INTENTION='P') then
        --ohne TNM vorhanden?
        select count(*) into V_OP_C_TNM from TNM where tnm.FK_TUMORFK_PATIENT=PATID and FK_TUMORTUMOR_ID=TUMID and HERKUNFT='O' and LFDNR_TUMOR=r_op.OP_NUMMER;
         if ( V_OP_C_TNM=0) then
            select V_ERGEBNIS||'OP['||r_op.OP_NUMMER||']: pTNM zu OP fehlt;'||V_NL into V_ERGEBNIS from DUAL;
         end if;
         -- ohne Lokalen lokalen Residualstatus
         if (r_op.R_KLASSIFIKATION_LOKAL is null) then
          select V_ERGEBNIS||'OP['||r_op.OP_NUMMER||']: Lokaler R-Status fehlt;'||V_NL into V_ERGEBNIS from DUAL;
         end if;
      end if; 
  end if;
  end loop;
END;

---------------------------------------------------------------------
-- Syst. Therapie
---------------------------------------------------------------------
declare cursor c_ther is select * from INTERNISTISCHE_THERAPIE 
   where FK_PATIENTPAT_ID =PATID and FK_TUMORTUMOR_ID=TUMID;

begin
  for r_th in c_ther loop
  if (NUREIGENEDOKU =0 or r_th.DURCHFUEHRENDE_ABT_ID>1) then
      -- Therapie ohne Anfangsdatum
      if(r_th.BEGINN is null) then
         select V_ERGEBNIS||'Sys_Ther['||r_th.LFDNR||']: Anfangsdatum fehlt;'||V_NL into V_ERGEBNIS from DUAL;
      end if;
      -- Therapie ohne Intention
     if(r_th.INTENTION is null) then
         select V_ERGEBNIS||'Sys_Ther['||r_th.LFDNR||']: Intention fehlt;'||V_NL into V_ERGEBNIS from DUAL;
      end if;
      -- Therapie ohne Intention
       if(r_th.STELLUNG_PLANUNG is null) then
         select V_ERGEBNIS||'Sys_Ther['||r_th.LFDNR||']: Stellung der Therapie fehlt;'||V_NL into V_ERGEBNIS from DUAL;
      end if;/* */
     -- Therapie ohne Art der Therapie
      if(r_th.FK_PROTOKOLLPROTOK is null) then
         select V_ERGEBNIS||'Sys_Ther['||r_th.LFDNR||']: Kein Protokoll angegeben;'||V_NL into V_ERGEBNIS from DUAL;
      end if;
      --Therapie ohne Substanzen?
      select count(*) into V_THER_C_SUB  from ZYKLUS_GESAMT_MEDI where FK0ZYKLUSFK_INTERN=PATID and FK_ZYKLUSFK_INTERN=r_th.LFDNR;
      if (V_THER_C_SUB=0) then
        select V_ERGEBNIS||'Sys_Ther['||r_th.LFDNR||']: Keine Substanz(en) angegeben;'||V_NL into V_ERGEBNIS from DUAL;
      end if;
      -- Bei vorliegendem Therapieende: Ist Grund des Therapieendes angegeben?
      if(r_th.ENDE is not null) then
        if (r_th.ENDE_STATUS is null) then
          select V_ERGEBNIS||'Sys_Ther['||r_th.LFDNR||']: Kein Status des Therapieendes (Grund) angegeben;'||V_NL into V_ERGEBNIS from DUAL;
        end if;
      end if;
  end if;
  end loop;
END;
---------------------------------------------------------------------
-- Bestrahlung
---------------------------------------------------------------------
declare 
  cursor c_bestr is select * from BESTRAHLUNG 
    where FK_TUMORFK_PATIENT =PATID and FK_TUMORTUMOR_ID=TUMID;
  cursor c_teil (cin_PATID NUMBER,cin_LFDNR NUMBER) is select * from TEILBESTRAHLUNG te
    where te.FK_BESTRAHLUNGFK_0=cin_PATID and te.FK_BESTRAHLUNGLFDN=cin_LFDNR;
begin
  for r_rt in c_bestr loop
  if (NUREIGENEDOKU =0 or r_rt.DURCHFUEHRENDE_ABT_ID>1) then
      -- Therapie ohne Intention
      if(r_rt.INTENTION is null) then
         select V_ERGEBNIS||'Bestr['||r_rt.LFDNR||']: Intention fehlt;'||V_NL into V_ERGEBNIS from DUAL;
      end if; 
      --Bestrahlung ohne Zielgebiete?
      select count(*) into V_RT_C_ZIEL  from ZIELGEBIET zi inner join TEILBESTRAHLUNG te
      on te.FK_BESTRAHLUNGFK_0=zi.FK_STRAHLENTHERFK0
      and zi.FK_STRAHLENTHERFK1=te.FK_BESTRAHLUNGLFDN
      and te.LFDNR=zi.FK_STRAHLENTHERLFD
      where te.FK_BESTRAHLUNGFK_0=PATID and te.FK_BESTRAHLUNGLFDN=r_rt.LFDNR and FK_ZIELGEBIET_SZIE is not null;
      if (V_RT_C_ZIEL=0) then
        select V_ERGEBNIS||'Bestr['||r_rt.LFDNR||']: Kein(e) Zielgebiet(e) angegeben;'||V_NL into V_ERGEBNIS from DUAL;
      end if;
      -- Pruefung Teilbestrahlung
      for r_teil in c_teil(PATID ,r_rt.LFDNR) loop
          --Teil-Bestrahlung ohne Applikationsart?
             if (r_teil.APPLIKATIONSART is null) then
                  select V_ERGEBNIS||'Bestr['||r_rt.LFDNR||']: Teilbestrahlung['||r_teil.LFDNR||'] ohne Applikationsart;'||V_NL into V_ERGEBNIS from DUAL;
             end if;
          --Bei vorhandenem Enddatum Gesamtdosis und Grund Therapieende (Vorgehen) prüfen
            if (r_Teil.ENDE is not null) then
              if(r_teil.GESAMTDOSIS is null) then
                 select V_ERGEBNIS||'Bestr['||r_rt.LFDNR||']: Teilbestrahlung['||r_teil.LFDNR||'] ohne Gesamtdosis;'||V_NL into V_ERGEBNIS from DUAL;
              end if;
              if (r_teil.VORGEHEN is null) then
                  select V_ERGEBNIS||'Bestr['||r_rt.LFDNR||']: Teilbestrahlung['||r_teil.LFDNR||'] ohne weiteres Vorgehen(Grund f. Therapiende);'||V_NL into V_ERGEBNIS from DUAL;
              end if;
            end if;
        end loop;

  end if;
  end loop;
END;


---------------------------------------------------------------------
-- Verlauf
---------------------------------------------------------------------
declare 
  cursor c_verlauf is select * from VERLAUF 
    where FK_TUMORFK_PATIENT =PATID and FK_TUMORTUMOR_ID=TUMID;
  --Leistungszustand zum Verlauf  
  cursor c_leist (cin_PATID number,cin_TUMID string,cin_LFDNR NUMBER)is select * from LEISTUNGSZUSTAND le 
    where le.HERKUNFT='V' and le.FK_PATIENTPAT_ID=cin_PATID and le.FK_TUMORTUMOR_ID=cin_TUMID and le.FK_VERLAUFLFDNR=cin_LFDNR;
  r_leist LEISTUNGSZUSTAND%rowtype;   
begin
  for r_ve in c_verlauf loop
  if (NUREIGENEDOKU =0 or r_ve.DURCHFUEHRENDE_ABT_ID>1) then
    -- STatus Primärtumor im Verlauf
    if(r_ve.PRIMAERTUMOR is null) then
      select V_ERGEBNIS||'Verlauf['||r_ve.LFDNR||']: Kein Status des Primärtumors angegeben;'||V_NL into V_ERGEBNIS from DUAL;
    end if;
    -- Gesamtbeurteilung und ECOG aus LEistungszustand
    open c_leist(PATID,TUMID,r_ve.LFDNR);
    loop
    fetch c_leist into r_leist;
    if (c_leist%notfound) then
            select V_ERGEBNIS||'Verlauf['||r_ve.LFDNR||']: Gesamtbeurteilung / Leistungszustand fehlt;'||V_NL into V_ERGEBNIS from DUAL;
          end if;
    exit when c_leist%notfound;
          
          --Gesamtbeurteilung vorhanden?
             if (r_leist.GESAMTBEURTEILUNG is null) then
                  select V_ERGEBNIS||'Verlauf['||r_ve.LFDNR||']: Gesamtbeurteilung fehlt;'||V_NL into V_ERGEBNIS from DUAL;
             end if;
          -- Auf ECOG / Karnofski prüfen
            if (r_leist.ECOG is null) then
                    select V_ERGEBNIS||'Verlauf['||r_ve.LFDNR||']: Leistungszustand fehlt;'||V_NL into V_ERGEBNIS from DUAL;
              end if;
     
      end loop;
      close c_leist;
 
  end if;
  end loop;
    
        
END;
---------------------------------------------------------------------
-- Abschluss
---------------------------------------------------------------------

declare 
  cursor c_ab is select * from ABSCHLUSS 
    where FK_PATIENTPAT_ID =PATID and (TUMOR_ID=TUMID or TUMOR_ID is null or TUMOR_ID='A');
begin
  for r_ab in c_ab loop
      -- Grund des Abschluss vorhanden? 
      if(r_ab.GRUND is null) then
        select V_ERGEBNIS||'ABSCHLUSS['||r_ab.LFDNR||']: Abschluss Grund fehlt;'||V_NL into V_ERGEBNIS from DUAL;
      end if;
      --Wenn PAtient Tod auch EIntrag ob Tod Tumorbedingt?
      if(V_STERBEDATUM is not null and V_TUMORTOD is null) then
        select V_ERGEBNIS||'ABSCHLUSS['||r_ab.LFDNR||']: Angabe zum tumorbedingten Tod fehlt;'||V_NL into V_ERGEBNIS from DUAL;
      end if;
  end loop;
END;
---------------------------------------------------------------------
-- Konsil
---------------------------------------------------------------------

if (V_ERGEBNIS='' or V_ERGEBNIS is null ) then
 select 'O.K.' into V_ERGEBNIS from DUAL;
end if;

  RETURN V_ERGEBNIS;
END UCCH_PATCHECK;