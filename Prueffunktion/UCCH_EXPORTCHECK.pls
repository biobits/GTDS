--------------------------------------------------------------------------------------
-- Hauseigene Prüffunktion für HKR-Exporte im GTDS.
-- 
-- 20170419: Initiale Version


-- Parameter:
-- PATID -> Die GTDS-ID des Patienten
-- TUMID -> Die Lfdnr der Tumorerkrankung
-- NUREIGENEDOKU -> Schalter zur optionalen Prüfung von Dokumentationen externer Herkunft (Abteilungs ID=1)
-- NURMELDEANLAESSE -> Schalter zur optionalen Beschränkung der Prüfung auf Meldeanlässe
---------------------------------------------------------------------------------------
CREATE OR REPLACE FUNCTION UCCH_PATCHECK 
(
  PATID IN NUMBER
, TUMID IN VARCHAR2 
, DATENART IN VARCHAR2  
, LFDNR IN NUMBER 
, EXPORTID in NUMBER
) RETURN VARCHAR2 AS 

-- Variablen allg
V_NL varchar2(2); --Newline für Windows
V_ERGEBNIS varchar2(4000) null;
V_C_1 number null; --Counter für bedarfsfäll 

BEGIN
select '' into  V_ERGEBNIS from DUAL;
select  chr(13)||chr(10) into V_NL from DUAL;


---------------------------------------------------------------------
-- INTERNISTISCHE THERAPIE
---------------------------------------------------------------------
if(DATENART='INTERNISTISCHE_THERAPIE') then
  declare cursor c_it is select * from Internistische_THerapie
     where FK_PATIENTPAT_ID =PATID and FK_TUMORTUMOR_ID=TUMID
     and LFDNR=LFDNR;

  begin
    for r_it in c_it loop
    select count(*) into V_C_1 from export_datensatz  where EXPORT_ID<EXPORTID and ZUORDNUNG_TYP=DATENART 
      and ZUORDNUNG_ID1=PATID and ZUORDNUNG_ID2=LFDNR and 
    if ((NUREIGENEDOKU =0 or r_op.DURCHFUEHRENDE_ABT_ID>1) and (NURMELDEANLAESSE=0 or r_op.MELDEANLASS is null or r_op.MELDEANLASS<>'keine_meldung')) then
        -- OP ohne OP-Intention vorhanden?
        if (r_op.INTENTION is null) then
           select V_ERGEBNIS||'OP['||r_op.OP_NUMMER||']: OP-Intention fehlt;'||V_NL into V_ERGEBNIS from DUAL;
        end if;
      
      -- OP (kurativ/palliativ) Prüfung nur bei Rezisiv oder Primätrtumor-OP sowie nicht bei NAchresektionen
      if ((r_op.INTENTION ='K' or r_op.INTENTION='P') and r_op.ZIEL_PRIMAERTUMOR in ('J','R') and (r_op.NACHRESEKTION is null or r_op.NACHRESEKTION <>'J') ) then 
        --KLASSIFIKATIONEN abfragen
        if (V_DIagOhneKlass=0) then
            if (V_COUNTER>0) then
            -- Klassifikation xyz (ACHTUNG!!! Hier wird noch der Verlauf geprüft, da zuordnung von Sonst. Klass. nur zum Verlauf erfolgen kann. Sollte aber zuk. zur OP erfolgen
            -- Muss nach Änderung von Altmann angepasst werden
               select count(*) into V_OP_C_TNM from SONSTIGE_KLASSIFIK where FK_TUMORFK_PATIENT=PATID and FK_TUMORTUMOR_ID=to_number(TUMID) and HERKUNFT='V' and LFDNR_TUMOR=r_op.FK_VERLAUFLFDNR;
                 --Prüfung vorerst deaktiviert
                /* if ( V_OP_C_TNM=0) then
                    select V_ERGEBNIS||'OP['||r_op.OP_NUMMER||']: kein Verlauf mit postoperativer Klassifikation vorhanden;'||V_NL into V_ERGEBNIS from DUAL;
                 end if;*/
    
            else
            --ohne TNM vorhanden?(Gilt auch für Pat mit FIGO, da nach op auch pTNM vorhandne sein muss -- Vorerst generelle Ausnahme bei Weichteilca's.
              select count(*) into V_OP_C_TNM from TNM where tnm.FK_TUMORFK_PATIENT=PATID and FK_TUMORTUMOR_ID=TUMID and HERKUNFT='O' and LFDNR=r_op.OP_NUMMER;
                 if ( V_OP_C_TNM=0 and V_WeichteilCounter=0) then
                    select V_ERGEBNIS||'OP['||r_op.OP_NUMMER||']: pTNM zu OP fehlt;'||V_NL into V_ERGEBNIS from DUAL;
                 end if;
            end if;
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
  if ((NUREIGENEDOKU =0 or r_th.DURCHFUEHRENDE_ABT_ID>1) and (NURMELDEANLAESSE=0 or r_th.MELDEANLASS is null or r_th.MELDEANLASS<>'keine_meldung')) then
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
     -- Therapie ohne Art der Therapie : Info: Einzelabfrage deaktiviert, da unten melderelevant nach Substanz oder Protokoll abgefragt wird. bei bedarf reaktivieren
      --if(r_th.FK_PROTOKOLLPROTOK is null) then
      --   select V_ERGEBNIS||'Sys_Ther['||r_th.LFDNR||']: Kein Protokoll angegeben;'||V_NL into V_ERGEBNIS from DUAL;
      --end if;
      
      --Therapie ohne Substanzen und Protokoll?
      select count(*) into V_THER_C_SUB  from ZYKLUS_GESAMT_MEDI where FK0ZYKLUSFK_INTERN=PATID and FK_INTERNISTISCLFD=r_th.LFDNR;
      if (V_THER_C_SUB=0 and r_th.FK_PROTOKOLLPROTOK is null) then
        select V_ERGEBNIS||'Sys_Ther['||r_th.LFDNR||']: Weder Protokoll noch Substanz(en) angegeben;'||V_NL into V_ERGEBNIS from DUAL;
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
  if ((NUREIGENEDOKU =0 or r_rt.DURCHFUEHRENDE_ABT_ID>1) and (NURMELDEANLAESSE=0 or r_rt.MELDEANLASS is null or r_rt.MELDEANLASS<>'keine_meldung')) then
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
  r_leist_count number :=0; --Zählt die Anzahl an Leistungsbeurteilungen um zusammen mit c_leist%notfound klar zu determinieren, dass kein Leistungszustand vorhanden ist
begin
  for r_ve in c_verlauf loop
  if ((NUREIGENEDOKU =0 or r_ve.DURCHFUEHRENDE_ABT_ID>1) and (NURMELDEANLAESSE=0 or r_ve.MELDEANLASS is null or r_ve.MELDEANLASS not in('keine_meldung','statusmeldung'))) then
    -- STatus Primärtumor im Verlauf
    if(r_ve.PRIMAERTUMOR is null) then
      select V_ERGEBNIS||'Verlauf['||r_ve.LFDNR||']: Kein Status des Primärtumors angegeben;'||V_NL into V_ERGEBNIS from DUAL;
    end if;
    -- Gesamtbeurteilung und ECOG aus LEistungszustand
    open c_leist(PATID,TUMID,r_ve.LFDNR);
    loop
    fetch c_leist into r_leist;
    if (c_leist%notfound and r_leist_count=0) then
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
          r_leist_count:=r_leist_count+1;
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
    if ((NUREIGENEDOKU =0 or r_ab.DURCHFUEHRENDE_ABT_ID>1) and (NURMELDEANLAESSE=0 or r_ab.MELDEANLASS is null or r_ab.MELDEANLASS<>'keine_meldung')) then
      -- Grund des Abschluss vorhanden? 
      if(r_ab.GRUND is null) then
        select V_ERGEBNIS||'ABSCHLUSS['||r_ab.LFDNR||']: Abschluss Grund fehlt;'||V_NL into V_ERGEBNIS from DUAL;
      end if;
      --Wenn PAtient Tod auch EIntrag ob Tod Tumorbedingt?
      if(V_STERBEDATUM is not null and V_TUMORTOD is null) then
        select V_ERGEBNIS||'ABSCHLUSS['||r_ab.LFDNR||']: Angabe zum tumorbedingten Tod fehlt;'||V_NL into V_ERGEBNIS from DUAL;
      end if;
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