create or replace PROCEDURE UKE_SP_WORKLIST
(
  P_FILTERCODE IN NUMBER,
  P_STARTDATUM IN DATE,
  P_ENDDATUM IN DATE,
  P_DIAGNOSEJAHR IN Number, 
  P_PRIMFALL in NUMBER,
  P_RESULTSET IN OUT SYS_REFCURSOR
) AS 
   type r_indiv is record(
   
    P_PATIENTEN_ID              EXTERNER_PATIENT.PATIENTEN_ID%TYPE ,
    P_PAT_ID                    EXTERNER_PATIENT.PAT_ID%TYPE,
    P_GTDS_ID                   PATIENT.PAT_ID%TYPE ,
    P_VORNAME                   EXTERNER_PATIENT.VORNAME%TYPE,
    P_NAME                      EXTERNER_PATIENT.NAME%TYPE,
    P_GEBURTSDATUM              EXTERNER_PATIENT.GEBURTSDATUM%TYPE ,
    P_GESCHLECHT                EXTERNER_PATIENT.GESCHLECHT%TYPE,
    P_IMPORTDATUM               EXTERNER_PATIENT.IMPORT_DATUM%TYPE,
    P_AENDERUNGSDATUM           EXTERNER_PATIENT.AENDERUNGSDATUM%TYPE,
    P_STAMMDATENCHECK           VARCHAR2(250),
    P_LETZTE_BEARBEITUNG        DATE,
    P_LINK_MISSING              BOOLEAN,
    P_IM_GTDS                   BOOLEAN,
    P_EXTERNE_DIAGNOSEN         VARCHAR2(500),
    P_DIAGNOSEN                 VARCHAR2 (100),
    P_ICD10                     TUMOR.ICD10%TYPE,
    P_DIAGNOSEDATUM             DATE,
    P_TAG_DER_MESSUNG           DATE,
    P_ARBEITSLISTE_TUMOR        VARCHAR2(500),
    P_KORREKTUR_DATUM          DATE,
    P_PRIMFALL_KKR              VARCHAR2(25),
    P_MAX_EXT_DATE              DATE);
    --p_indiv r_indiv;
    --p_intrec IN OUT SYS_REFCURSOR
   
BEGIN

open P_RESULTSET for
select distinct  EXTERNER_PATIENT.PATIENTEN_ID ,EXTERNER_PATIENT.PAT_ID,
p.pat_id GTDS_ID,EXTERNER_PATIENT.AENDERUNGSDATUM,EXTERNER_PATIENT.IMPORT_DATUM,
EXTERNER_PATIENT.NAME,EXTERNER_PATIENT.VORNAME,EXTERNER_PATIENT.GEBURTSDATUM,EXTERNER_PATIENT.GESCHLECHT,
case when EXTERNER_PATIENT.NAME<>p.NAME and p.Name is not null then 'Nachname prüfen; ' else null end ||
case when EXTERNER_PATIENT.VORNAME<>p.VORNAME and p.VORNAME is not null then 'Vorname prüfen; ' else null end ||
case when EXTERNER_PATIENT.STRASSE<>p.STRASSE and p.STRASSE is not null then 'Strasse prüfen; ' else null end ||
case when EXTERNER_PATIENT.ORT<>p.ORT and p.ORT is not null then 'Ort prüfen; ' else null end ||
case when EXTERNER_PATIENT.PLZ<>p.PLZ and p.PLZ is not null then 'PLZ prüfen; ' else null end ||
case when EXTERNER_PATIENT.GEBURTSDATUM<>p.GEBURTSDATUM and p.GEBURTSDATUM is not null then 'Geb.-Dat. prüfen; ' else null end ||
case when EXTERNER_PATIENT.FK_LEISTUNGSTRAEINS<>p.FK_LEISTUNGSTRAEINS and p.FK_LEISTUNGSTRAEINS is not null then 'ggf. Versicherung prüfen; ' else null end
as Stammdatencheck,

(select max(qb.TAG_DER_MESSUNG) from 
QUALITATIVER_BEFUND qb 
where qb.FK_VORHANDENE_DFK=EXTERNER_PATIENT.PAT_ID
and qb.FK_VORHANDENE_DDAT='Diagnose'
and qb.FK_QUALITATIVE_FK=19) as Letzte_Bearbeitung,

case when EXTERNER_PATIENT.PAT_ID is null and p.pat_id is not null then 1 else 0 end Link_Missing,
case when p.pat_id is not null then 1 else 0 end Im_GTDS,
 (
	SELECT LISTAGG(Fk_IcdIcd,' | ') WITHIN GROUP (order by Fk_IcdIcd) as X  FROM 
  (select distinct ED.Fk_Externe_Patienten_ID,ED.Fk_IcdIcd from EXTERNE_DIAGNOSE ED
	WHERE (ED.FK_ICDICD like 'C%' or ED.FK_ICDICD like 'D%')
  ) where Fk_Externe_Patienten_ID = EXTERNER_PATIENT.Patienten_ID 
  
	) as Externe_Diagnosen,
 (
	SELECT LISTAGG(ICD10,' | ') WITHIN GROUP (order by T.DIAGNOSEDATUM desc) from TUMOR T
	 where t.FK_PATIENTPAT_ID = P.Pat_ID 
  	) as Diagnosen,

  T.ICD10 as Diagnose_Tumor,
  T.DIAGNOSEDATUM,
  qba.TAG_DER_MESSUNG as Letzte_Bearbeitung_Tumor,
  case when qba.BEMERKUNG is null then qaa.Auspraegung else qaa.Auspraegung ||' - '||qba.BEMERKUNG end Arbeitsliste_Tumor ,
  T.KORREKTUR_DATUM,

             (select case when max(qb.Fk_Qualitative_Fk) is null then 'kein Merkmal' 
    when max(qa.AUSPRAEGUNG) is null then 'N.D.' else max(qa.AUSPRAEGUNG) end
    FROM QUALITATIVER_BEFUND qb 
    left outer join QUALITATIVE_AUSPRAEGUNG qa
    on qb.FK_QUALITATIVE_ID=qa.ID and qb.Fk_Qualitative_Fk=qa.FK_QUALITATIVESID
          WHERE 
          T.TUMOR_ID=qb.FK_VORHANDENE_DLFD
          and T.FK_PATIENTPAT_ID=qb.FK_VORHANDENE_DFK
            AND qb.Fk_Qualitative_Fk = 28          -- Merkmal ist Primärfall
            AND qb.Fk_Vorhandene_DDAT = 'Diagnose' ) as PRIMFALL_KKR,
  
(select max(Datum) from 
(select ED.DATUM as Datum,ED.FK_EXTERNE_PATIENTEN_ID PATIENTEN_ID,ED.IMPORT_QUELLE  from EXTERNE_DIAGNOSE ED 
  union all
  select EP.DATUM,EP.FK_EXTERNE_PATIENTEN_ID,EP.IMPORT_QUELLE from EXTERNE_PROZEDUR EP  
  union all
  select IB.BEFUND_DATUM,IB.PATIENTEN_ID,IB.IMPORT_QUELLE from IMPORT_QUALITATIVER_BEFUND IB 
  union all
  select apb.BEGINN,FK_EXTERNE_PATIENTEN_ID,apb.IMPORT_QUELLE from ABTEILUNG_PATIENT_BEZIEHUNG apb ) XT
  where XT.PATIENTEN_ID =EXTERNER_PATIENT.PATIENTEN_ID and XT.IMPORT_QUELLE='UKE'
  
  ) as MAX_EXT_DAT
  
from 
EXTERNER_PATIENT 
left outer join 
patient  p 
on p.pat_id=EXTERNER_PATIENT.pat_id
or p.PATIENTEN_ID= EXTERNER_PATIENT.PATIENTEN_ID
left outer join TUMOR T on 
T.FK_PATIENTPAT_ID=EXTERNER_PATIENT.pat_id
  and exists(select 1 from 
    AW_KLASSEN_ALLE b
        where T.ICD10 like b.Like_Kriterium
        and b.klassierung_id=5 
            and b.KLASSIERUNG_QUELLE='UKE'
            and b.KLASSE_CODE=P_FILTERCODE)/**/
  left outer join QUALITATIVER_BEFUND qba --Arbeitslisteninfos   
on T.FK_PATIENTPAT_ID=qba.FK_VORHANDENE_DFK
 and T.TUMOR_ID=qba.FK_VORHANDENE_DLFD
and qba.FK_VORHANDENE_DDAT='Diagnose'
and qba.FK_QUALITATIVE_FK=19
left outer join QUALITATIVE_AUSPRAEGUNG qaa
  on qba.Fk_Qualitative_Fk = qaa.Fk_QualitativesID -- Merkmal
            AND qba.Fk_Qualitative_ID = qaa.ID
where 
EXTERNER_PATIENT.HAUPT_VERS_NAME='TUMORPATIENT'
and EXTERNER_PATIENT.Import_Quelle = 'UKE'
AND MONTHS_BETWEEN(SYSDATE, EXTERNER_PATIENT.Geburtsdatum)/12 >= 17.5
and
--Filterbedingung Änderungszeitraum
( 
  EXTERNER_PATIENT.AENDERUNGSDATUM between P_STARTDATUM and P_ENDDATUM
  or EXTERNER_PATIENT.IMPORT_DATUM between P_STARTDATUM and P_ENDDATUM
  or exists
    (select 1 from EXTERNE_DIAGNOSE ED where ED.FK_EXTERNE_PATIENTEN_ID =EXTERNER_PATIENT.PATIENTEN_ID and ED.IMPORT_QUELLE='UKE' and ED.DATUM between P_STARTDATUM and P_ENDDATUM) --EIne Externe Diagnose im Zeitraum
  or exists
    (select 1 from EXTERNE_PROZEDUR EP where EP.FK_EXTERNE_PATIENTEN_ID =EXTERNER_PATIENT.PATIENTEN_ID and EP.IMPORT_QUELLE='UKE' and EP.DATUM between P_STARTDATUM and P_ENDDATUM) --EIne Externe Prozedur im Zeitraum
  or exists
    (select 1 from IMPORT_QUALITATIVER_BEFUND IB where IB.PATIENTEN_ID =EXTERNER_PATIENT.PATIENTEN_ID and IB.IMPORT_QUELLE='UKE' and IB.EXTERNE_BEFUNDART_ID='EINWILLIGUNG_KKR' 
      and IB.BEFUND_DATUM between P_STARTDATUM and P_ENDDATUM) --EIne EInwilligung für das KKR im Zeitraum
  
)
--Filterbedingung: Wenn letzte Bearbeitung kleiner ENdatum des Änderungszeitraumes oder Patient nicht im GTDS
and (  exists -- Merkmal Arbeistliste mit Datum kleiner Enddatum
(select 1 from 
  QUALITATIVER_BEFUND qb  inner join Tumor T
  on T.TUMOR_ID=qb.FK_VORHANDENE_DLFD
  and T.FK_PATIENTPAT_ID=qb.FK_VORHANDENE_DFK
  inner join 
   AW_KLASSEN_ALLE b
  on T.ICD10 like b.Like_Kriterium
  WHERE 
  b.klassierung_id=5 
  and b.KLASSIERUNG_QUELLE='UKE'
  and b.KLASSE_CODE=P_FILTERCODE
  and qb.FK_VORHANDENE_DFK=EXTERNER_PATIENT.PAT_ID
  and qb.FK_VORHANDENE_DDAT='Diagnose'
  and qb.FK_QUALITATIVE_FK=19
and (qb.TAG_DER_MESSUNG<P_ENDDATUM or qb.TAG_DER_MESSUNG is null)
) 

or p.PAT_ID is null
or not exists ( -- Kein Merkmal Arbeistliste für diesen Tumortyp (ICD-Bereich) vorhanden
  select 1 from 
  QUALITATIVER_BEFUND qb  inner join Tumor T
  on T.TUMOR_ID=qb.FK_VORHANDENE_DLFD
  and T.FK_PATIENTPAT_ID=qb.FK_VORHANDENE_DFK
  inner join 
   AW_KLASSEN_ALLE b
   on T.ICD10 like b.Like_Kriterium
   WHERE b.klassierung_id=5 
  and b.KLASSIERUNG_QUELLE='UKE'
  and b.KLASSE_CODE=P_FILTERCODE
  and qb.FK_VORHANDENE_DFK=EXTERNER_PATIENT.PAT_ID
  and qb.FK_VORHANDENE_DDAT='Diagnose'
  and qb.FK_QUALITATIVE_FK=19
  )

)
---Filterbedingung für Entität
AND ( P_FILTERCODE=250 --Restefilter wird so ausgeschlossen 
      or
      EXISTS (
              SELECT 1 FROM EXTERNE_DIAGNOSE ED
              inner join 
               AW_KLASSEN_ALLE b
               on ED.FK_ICDICD like b.Like_Kriterium
               WHERE ED.Fk_Externe_Patienten_ID = EXTERNER_PATIENT.Patienten_ID
              and b.klassierung_id=5 
              and b.KLASSIERUNG_QUELLE='UKE'
              and b.KLASSE_CODE=P_FILTERCODE )
     
      )
  

--FIlterbedingung Primärfall
and (exists
  (
     (select 1 FROM QUALITATIVER_BEFUND qb 
          WHERE 
          T.TUMOR_ID=qb.FK_VORHANDENE_DLFD
          and T.FK_PATIENTPAT_ID=qb.FK_VORHANDENE_DFK
            AND qb.Fk_Qualitative_Fk = 28          -- Merkmal ist Primärfall
            and qb.FK_QUALITATIVE_ID=P_PRIMFALL
            AND qb.Fk_Vorhandene_DDAT = 'Diagnose' )
  ) or P_PRIMFALL=0
)
and (EXTRACT(YEAR FROM t.DIAGNOSEDATUM) = P_DIAGNOSEJAHR or P_DIAGNOSEJAHR=0)

--Filterbedingung Rest
and (
  P_FILTERCODE<>250
 or (
      not EXISTS (
      SELECT 1 FROM EXTERNE_DIAGNOSE ED
      inner join 
       AW_KLASSEN_ALLE b
       on ED.FK_ICDICD like b.Like_Kriterium
       WHERE ED.Fk_Externe_Patienten_ID = EXTERNER_PATIENT.Patienten_ID
      and b.klassierung_id=5 
      and b.KLASSIERUNG_QUELLE='UKE'
      and (b.KLASSE_CODE<>240 --Code für alle C und D-Diagnosen
          or b.KLASSE_CODE<>250) --Code für SST-Rest
                      )
                      and p.PATIENTEN_ID=EXTERNER_PATIENT.PATIENTEN_ID
                      ) 
)
/**/
;

END UKE_SP_WORKLIST;