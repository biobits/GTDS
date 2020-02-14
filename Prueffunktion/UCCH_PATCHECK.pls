--------------------------------------------------------------------------------------
-- Hauseigene Prüffunktion für Dokumentationen im GTDS.
-- Initial zur Prüfung von Items des GKR-Exportes
-- 20161219: Initiale Version
-- 20170103: Operationen und Innere Prüfung
-- 20170106: Bestrahlung/Verlauf und Abschluss
-- 20170116: Korrekturen nested Cursor
-- 20170120: Anpassung an Meldeanlässe
-- 20170123: Berücksichtigung Meldeanlass statusmeldung bei Verlauf/ pTNM Prüfung nur bei r_op.ZIEL_PRIMAERTUMOR in ('J','R') und OP keine Nachresektion
-- 20170124: Syst. Therapie-> es muss entweder ein Protokoll od. Substanzen vorhanden sein (EInzeln werden Items nicht mehr abgefragt) / Sonderabfrage f. Weichteiltumore
-- 20170125: Berücksichtigung der Diagnosen , bei denen keine Klassifikation erhoben wird im Parameter V_DiagOhneKlass
-- 20170126: Berücksichtigung bei ED und OP am gleichen Tag: Klassifikationm dann nur bei OP; C44: keine Prüfung TNM
-- 20170330: Mitgliedsnummer wird geprüft
-- 20170419: SV Nummer prüfung; Hausnummer Regex
-- 20170615: C90% Patienten Klassifikastionen zugeordnet -> Holger
-- 20180621: Teilbestrahlung wird auf korrekte EInheiten gemäß ADT V2 geprüft
-- 20191121: ICD-O Lokalisation Prüfung auf Hauptlokalisation und Seitenangabe; Zielgebiete der Teilbestrahlung: Prüfung auf Codierung und Seitenangabe
--              Fehler bei Angabe von Gesamtdosis bzw. Grund des Abruchs (Vorgehen) ohne ein Enddatum der Bestrahlung.
-- 20200211: ICD-O Lokalisation wird auf HKR Konformität geprüft; Integration der "Teiloperationen" -> prüfung

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
, NUREIGENEDOKU IN NUMBER :=0 --1=Nur eigene Dokumentationen werden geprüft 
, NURMELDEANLAESSE IN NUMBER :=0 -- 1=Nur Dokumente mit Meldeanlass =leer oder  Meldeanlass <> "Keine Meldung" werden geprüft
) RETURN VARCHAR2 AS 

-- Variablen allg
V_NL varchar2(2); --Newline für Windows

--VAriablen PAtient;
V_GEBURTSDATUM date null;
V_GESCHLECHT varchar2(1) null;
V_PATIENTEN_ID VARCHAR2(30) null; --UKE-ID
V_STERBEDATUM date null;
V_TUMORTOD	VARCHAR2(1) null; --Tod Tumorbedingt
V_SV_NUMMER varchar2(20);
V_MITGLIEDSNUMMER varchar2(30);
V_IKNR VARCHAR2(15)null;
V_KK_TYP varchar2(1) null;
V_STRASSE  varchar2(50) null;
V_HAUSNUMMER varchar2(30) null;
--Variablen zur Prüfung
V_COUNTER number null;
V_COUNTER2 number null;
V_COUNTER3 number null;
V_COUNTER4 number null;
V_COUNTER5 number null;
V_WeichteilCounter number null; -- Sonderfall Weichteil tumor
V_DiagOhneKlass number null; --COunter für jene Diagnosen, bei denen keine Klassifikation erhoben werden kann.
V_ERGEBNIS varchar2(4000) null;

--Diagnose Parameter
V_ICD varchar2(10) null; --ICD10
V_DIAG_ABT number null; -- Durchfuehrende Abt. der Diagnose
V_DIAG_DATUM date null; --DIagnosedatum
V_DIAG_SICH varchar2(10) null;--DIagnosesicherung
V_DIAG_LEISTUNG varchar2(4) null; --Leistungszustand
V_DIAG_MELDEANLASS varchar(255) null ;--Meldeanlass
-- LOkalisation
V_Lok_Code varchar2(5) null; -- Lokalisatiomsschlüssel ICD-O
V_Lok_Seite varchar2(1) null; ---Seitenangabe (Pflicht für HKR)
--KLassifikation
V_pT varchar2(5)null;
V_pN varchar2(5)null;
V_pM varchar2(5)null;
V_T varchar2(20)null;
V_N varchar2(20)null;
V_M varchar2(20)null;
V_Sonst_Stadium varchar2(10) null;
V_AnnArbor varchar2(10) null;
V_C_SonstStad number null; --Counter f. Sonstige Stadien
V_C_AnnArbor number null; --Counter AnnArbor Stadien
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

select p.GEBURTSDATUM,p.GESCHLECHT,p.PATIENTEN_ID,p.SV_NUMMER,p.MITGLIEDSNUMMER,p.STERBEDATUM,p.TUMORTOD,l.IKNR,l.KRANKENKASSEN_TYP,p.STRASSE,p.HAUSNUMMER
into V_GEBURTSDATUM,V_GESCHLECHT ,V_PATIENTEN_ID,V_SV_NUMMER,V_MITGLIEDSNUMMER ,V_STERBEDATUM ,V_TUMORTOD,V_IKNR,V_KK_TYP,V_STRASSE,V_HAUSNUMMER
  from PATIENT p left outer join LEISTUNGSTRAEGER l on p.FK_LEISTUNGSTRAEINS=l.INSTITUTIONSKENNZE
  where PAT_ID =PATID;
-- Hausnummer prüfen, wenn nicht seperat eingetragen
if(V_HAUSNUMMER is null) then
  if (length(regexp_replace(V_STRASSE, '^(.+?)([-,0-9]+?)([-a-zA-Z ]*?|[-0-9 ]*?)$','\2\3')))>5 then
    select V_ERGEBNIS||'Hausnummer evtl. fehlerhaft;'||V_NL into V_ERGEBNIS from DUAL;
  end if;
end if;
--Versicherungsdaten
if V_MITGLIEDSNUMMER like 'OK Update%' then 
  select V_ERGEBNIS||'Mitgliedsnummer fehlerhaft;'||V_NL into V_ERGEBNIS from DUAL;
end if;

--IKNR des Leistungstraegers
if (V_IKNR is null or V_IKNR like 'keine%') then
  select V_ERGEBNIS||'IKNR des Leistungstragers fehlt;'||V_NL into V_ERGEBNIS from DUAL;

--Fehlende SV-Nummer bei gesetzlicher KK  
end if;
if (V_SV_NUMMER is null) and (V_IKNR not in ('970000011','970001001','970100001','970000022','970000099') and V_KK_TYP!='P' )then
 select V_ERGEBNIS||'Versichertennummer fehlt;'||V_NL into V_ERGEBNIS from DUAL;
end if;

--SV Nummer zu lang
/*if (length(V_SV_NUMMER)>10) then
  select V_ERGEBNIS||'Versichertennummer zu lang;'||V_NL into V_ERGEBNIS from DUAL;
end if;*/

--SV NUMMER nicht korrekt
if (V_SV_NUMMER is not null and not REGEXP_LIKE(V_SV_NUMMER, '^[a-zA-Z]{1}[0-9]{9}$')) then
  select V_ERGEBNIS||'Versichertennummer nicht korrekt;'||V_NL into V_ERGEBNIS from DUAL;
end if;
---------------------------------------------------------------------
-- DIAGNOSE
---------------------------------------------------------------------
--ICD10 ermitteln
select ICD10,DURCHFUEHRENDE_ABT_ID,DIAGNOSEDATUM,MELDEANLASS into V_ICD,V_DIAG_ABT,V_DIAG_DATUM,V_DIAG_MELDEANLASS from Tumor where FK_PATIENTPAT_ID=PATID and Tumor_id=TUMID;

if V_ICD is null then 
  select V_ERGEBNIS||'ICD-10 Diagnose fehlt;'||V_NL into V_ERGEBNIS from DUAL;
end if;

if V_DIAG_DATUM is null then
  select V_ERGEBNIS||'Diagnosedatum fehlt;'||V_NL into V_ERGEBNIS from DUAL;
end if;

--LOkalisation auslesen
select FK_LOKALISATIONLOK,SEITE into  V_Lok_Code ,V_Lok_Seite from LOKALISATION where fk_tumorfk_patient=PATID and FK_TUMORTUMOR_ID=TUMID and HAUPT_NEBEN='H';
    --Keine Hauptlokalisation Vorhanden
    if V_Lok_Code is null then
        select V_ERGEBNIS||'ICD-O Hauptlokalisation fehlt;'||V_NL into V_ERGEBNIS from DUAL;
    end if;   
    --Keine Seitenlokalisation vorhanden
    if V_Lok_Code is not null and V_Lok_Seite is null then
        select V_ERGEBNIS||'ICD-O Seitenangabe fehlt;'||V_NL into V_ERGEBNIS from DUAL;
    end if;  
    --Keine korrekt (im HKR Sinn) Seitenlokalisation vorhanden
    if V_Lok_Code is not null and V_Lok_Seite not in ('R','L','B','M','T') then
        select V_ERGEBNIS||'ICD-O Seitenangabe nicht HKR-konform;'||V_NL into V_ERGEBNIS from DUAL;
    end if;  
--nur EIgene Diagnose und gültige Meldeanlässe?
if ((NUREIGENEDOKU =0 or V_DIAG_ABT>1)and (V_DIAG_MELDEANLASS is null or V_DIAG_MELDEANLASS <>'keine_meldung' or NURMELDEANLAESSE=0))  then
  -- SONDEFÄLLE --Bestimmte Parameter setzen für SOnderfälle
  -------------------------------------------
  -- DIagnose = Weichteiltumor?
  select count(column_value) into V_WeichteilCounter from table(sys.dbms_debug_vc2coll('C38.1','C38.2','C38.3','C47%','C48.0','C49%')) where V_ICD like column_value;
  -- Diagnosen ohne Klassifikationen
  select count(column_value) into V_DiagOhneKlass from table(sys.dbms_debug_vc2coll('D35%','C44%','C91%','C96%')) where V_ICD like column_value;
  
  
  --KLASSIFIKATION
  --SOnstige Klassifikation (hämatologisch, Hirntumor)
  select count(column_value) into v_COUNTER from table(sys.dbms_debug_vc2coll('C81%','C82%','C83%','C84%','C85%','C86%','C88%','C90%','C92%','C93%','C94%','C95%','C69%','C70%','C71%','C72%','D32%','D33%','D35%','D36%','D42%','D43%','D46%','C22.0')) where V_ICD like column_value;
  --FIGO Benötigt?
  select count(column_value) into v_COUNTER2 from table(sys.dbms_debug_vc2coll('C53%','C56%','C57%')) where V_ICD like column_value;
  -- Sonderfall DIagnose und OP am gleichen Tag und pTNM dann bei OP
  if(V_DiagOhneKlass=0) then
    select count(*) into V_DiagOhneKlass from TNM where TNM.ERSTELLT=V_DIAG_DATUM and TNM.HERKUNFT='O' and FK_TUMORFK_PATIENT=PATID and FK_TUMORTUMOR_ID=TUMID; 
  end if;
  -- Klassifikation prüfen
  if(V_DiagOhneKlass=0) then
      if (V_COUNTER2>0) then
        -- FIGO abfragen
      
        select max(FK_STADIENEINTESTA) into V_Sonst_Stadium  from SONSTIGE_KLASSIFIK where FK_TUMORFK_PATIENT=PATID and to_number(FK_TUMORTUMOR_ID)=TUMID and HERKUNFT='D' and FK_STADIENEINTEFK in (18,23);
        if (V_Sonst_Stadium is null) then 
            select V_ERGEBNIS||'FIGO-Stadium bei Diagnose fehlt;'||V_NL into V_ERGEBNIS from DUAL;
        end if;
      elsif (V_COUNTER>0) then
        -- Klassifikation xyz
        select max(FK_STADIENEINTESTA) into V_Sonst_Stadium  from SONSTIGE_KLASSIFIK where FK_TUMORFK_PATIENT=PATID and FK_TUMORTUMOR_ID=to_number(TUMID) and HERKUNFT='D' ;
        select max(STADIUM) into V_AnnArbor  from ANN_ARBOR where FK_TUMORFK_PATIENT=PATID and FK_TUMORTUMOR_ID=to_number(TUMID) and HERKUNFT='D' ;
        if (V_Sonst_Stadium is null and V_AnnArbor is null) then 
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
   
end if;

---------------------------------------------------------------------
-- OP 
---------------------------------------------------------------------
declare cursor c_operation is select * from OPERATION
   where FK_TUMORFK_PATIENT =PATID and FK_TUMORTUMOR_ID=TUMID;

begin
  for r_op in c_operation loop
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
         --Prüfeung Teiloperationen
         declare cursor c_teiloperation is select * from TEILOPERATION
            where FK_OPERATIONFK_TU0 =PATID and FK_OPERATIONOP_NUM=r_OP.OP_NUMMER;
            begin
                for r_teil in c_teiloperation loop
                    -- Prüfung ob OPS Version vorhanden
                    if (r_teil.FK_OPERATIONSSCAUF is null) then
                      select V_ERGEBNIS||'OP['||r_op.OP_NUMMER||']: Angabe der OPS-Auflage fehlt;'||V_NL into V_ERGEBNIS from DUAL;
                    end if;
                end loop;
            end;
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
   cursor c_ziel (cin_PATID NUMBER,cin_LFDNR NUMBER,cin_TEIL_Nr NUMBER) is select * from ZIELGEBIET zi
    where zi.FK_STRAHLENTHERFK0=cin_PATID and zi.FK_STRAHLENTHERFK1=cin_LFDNR and zi.FK_STRAHLENTHERLFD=cin_TEIL_Nr;
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
      
          --Prüfung Zielgebiete
            for r_ziel in c_ziel(PATID ,r_rt.LFDNR,r_teil.LFDNR) loop
                -- Kein Zielgebiet angegebn
                if (r_ziel.FK_ZIELGEBIET_SZIE is null) then
                      select V_ERGEBNIS||'Bestr['||r_rt.LFDNR||']: Teilbestrahlung['||r_teil.LFDNR||'] ohne Zielgebietsschluessel;'||V_NL into V_ERGEBNIS from DUAL;
                 end if;
                 -- Keine Seitenangabe bei Zielgebiet angegebn
                if (r_ziel.FK_ZIELGEBIET_SZIE is not null and r_ziel.SEITE is null) then
                      select V_ERGEBNIS||'Bestr['||r_rt.LFDNR||']: Teilbestrahlung['||r_teil.LFDNR||'] ohne Seitenangabe bei Zielgebiet;'||V_NL into V_ERGEBNIS from DUAL;
                 end if;
            end loop;
          -- Prüfung Zielgebiete ENDE
          --Teil-Bestrahlung ohne Applikationsart?
             if (r_teil.APPLIKATIONSART is null) then
                  select V_ERGEBNIS||'Bestr['||r_rt.LFDNR||']: Teilbestrahlung['||r_teil.LFDNR||'] ohne Applikationsart;'||V_NL into V_ERGEBNIS from DUAL;
             end if;
          -- Teil-Bestrahlung ohne EInheit (ADT V2)
          if (r_teil.GY_GBQ is null) then
                  select V_ERGEBNIS||'Bestr['||r_rt.LFDNR||']: Teilbestrahlung['||r_teil.LFDNR||'] ohne Einheit;'||V_NL into V_ERGEBNIS from DUAL;
             end if;
          -- Teil-Bestrahlung falsche EInheit (ADT V2)
          if (r_teil.GY_GBQ is not null and r_teil.GY_GBQ not in ('Gy','GBq')) then
                  select V_ERGEBNIS||'Bestr['||r_rt.LFDNR||']: Teilbestrahlung['||r_teil.LFDNR||'] ohne korrekte Einheit (Gy,GBq);'||V_NL into V_ERGEBNIS from DUAL;
             end if;
          
          -- Gesamtdosis vorhanden obwohl kein Enddatum eingetragen?
           if (r_Teil.ENDE is null and r_teil.GESAMTDOSIS is not null) then
                select V_ERGEBNIS||'Bestr['||r_rt.LFDNR||']: Teilbestrahlung['||r_teil.LFDNR||'] Gesamtdosis trotz fehlendem Enddatum angegeben;'||V_NL into V_ERGEBNIS from DUAL;
           end if;
           -- Vorgehen (Grund für Abbruch) vorhanden obwohl kein Enddatum eingetragen?
           if (r_Teil.ENDE is null and r_teil.VORGEHEN is not null) then
                select V_ERGEBNIS||'Bestr['||r_rt.LFDNR||']: Teilbestrahlung['||r_teil.LFDNR||'] Vorgehen trotz fehlendem Enddatum angegeben;'||V_NL into V_ERGEBNIS from DUAL;
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