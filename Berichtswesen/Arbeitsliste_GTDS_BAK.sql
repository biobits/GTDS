select distinct  EXTERNER_PATIENT.PATIENTEN_ID ,EXTERNER_PATIENT.PAT_ID,
p.pat_id GTDS_ID,EXTERNER_PATIENT.AENDERUNGSDATUM,EXTERNER_PATIENT.IMPORT_DATUM,
EXTERNER_PATIENT.NAME,EXTERNER_PATIENT.VORNAME,EXTERNER_PATIENT.GEBURTSDATUM,EXTERNER_PATIENT.GESCHLECHT,
(select max(qb.TAG_DER_MESSUNG) from 
QUALITATIVER_BEFUND qb 
where qb.FK_VORHANDENE_DFK=EXTERNER_PATIENT.PAT_ID
and qb.FK_VORHANDENE_DDAT='Diagnose'
and qb.FK_QUALITATIVE_FK=19) as Letzte_Bearbeitung,

(select max(qb.TAG_DER_MESSUNG) from 
QUALITATIVER_BEFUND qb  inner join Tumor T
on T.TUMOR_ID=qb.FK_VORHANDENE_DLFD
and T.FK_PATIENTPAT_ID=qb.FK_VORHANDENE_DFK
inner join AW_KLASSEN_ALLE b
        on T.ICD10 like b.Like_Kriterium
where qb.FK_VORHANDENE_DFK=EXTERNER_PATIENT.PAT_ID
and qb.FK_VORHANDENE_DDAT='Diagnose'
and qb.FK_QUALITATIVE_FK=19
 and b.klassierung_id=5 
            and b.KLASSIERUNG_QUELLE='UKE'
            and b.KLASSE_CODE=:FILTERCODE) as Letzte_Bearbeitung_Tumor,

(select LISTAGG(case when X1.BEMERKUNG is null then X1.Auspraegung else X1.Auspraegung ||' - '||X1.BEMERKUNG end,' | ') WITHIN GROUP (order by X1.TAG_DER_MESSUNG desc) from 
 (select distinct qb.BEMERKUNG ,qa.Auspraegung , qb.TAG_DER_MESSUNG ,qb.FK_VORHANDENE_DFK
  from QUALITATIVER_BEFUND qb  
  INNER JOIN QUALITATIVE_AUSPRAEGUNG qa
  on qb.Fk_Qualitative_Fk = qa.Fk_QualitativesID -- Merkmal
            AND qb.Fk_Qualitative_ID = qa.ID                -- Auspraegung
  inner join Tumor T
on T.TUMOR_ID=qb.FK_VORHANDENE_DLFD
and T.FK_PATIENTPAT_ID=qb.FK_VORHANDENE_DFK
inner join AW_KLASSEN_ALLE b
        on T.ICD10 like b.Like_Kriterium 
        where qb.FK_VORHANDENE_DDAT='Diagnose'
and qb.FK_QUALITATIVE_FK=19
 and b.klassierung_id=5 
            and b.KLASSIERUNG_QUELLE='UKE'
            and b.KLASSE_CODE=:FILTERCODE) X1
            where X1.FK_VORHANDENE_DFK=EXTERNER_PATIENT.PAT_ID

) as Arbeitsliste_Tumor,

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
  (select max(T1.ICD10) from TUMOR T1 
   Inner join 
    AW_KLASSEN_ALLE b
        on T1.ICD10 like b.Like_Kriterium
  where  T1.FK_PATIENTPAT_ID=EXTERNER_PATIENT.pat_id
  and b.klassierung_id=5 
            and b.KLASSIERUNG_QUELLE='UKE'
            and b.KLASSE_CODE=:FILTERCODE
  ) as Diagnose_Kontext,
  
  (select case when max(qb.Fk_Qualitative_Fk) is null then 'kein Merkmal' 
    when max(qa.AUSPRAEGUNG) is null then 'N.D.' else max(qa.AUSPRAEGUNG) end
    FROM QUALITATIVER_BEFUND qb inner join Tumor T
      on T.TUMOR_ID=qb.FK_VORHANDENE_DLFD
      and T.FK_PATIENTPAT_ID=qb.FK_VORHANDENE_DFK
      inner join AW_KLASSEN_ALLE b
        on T.ICD10 like b.Like_Kriterium
    left outer join QUALITATIVE_AUSPRAEGUNG qa
    on qb.FK_QUALITATIVE_ID=qa.ID and qb.Fk_Qualitative_Fk=qa.FK_QUALITATIVESID
          WHERE EXTERNER_PATIENT.PAT_ID= qb.Fk_Vorhandene_DFK
            and b.klassierung_id=5 
            and b.KLASSIERUNG_QUELLE='UKE'
            and b.KLASSE_CODE=:FILTERCODE
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

where 
EXTERNER_PATIENT.HAUPT_VERS_NAME='TUMORPATIENT'
and EXTERNER_PATIENT.Import_Quelle = 'UKE'
AND MONTHS_BETWEEN(SYSDATE, EXTERNER_PATIENT.Geburtsdatum)/12 >= 17.5
and
--Filterbedingung Änderungszeitraum
( 
  EXTERNER_PATIENT.AENDERUNGSDATUM between :startdatum and :enddatum
  or EXTERNER_PATIENT.IMPORT_DATUM between :startdatum and :enddatum
  or exists -- EIne Externe Diagnose neuer als das letzte Arbeitslistendatum
  (
    select 1 from 
    QUALITATIVER_BEFUND qb 
    where qb.FK_VORHANDENE_DFK=EXTERNER_PATIENT.PAT_ID
    and qb.FK_VORHANDENE_DDAT='Diagnose'
    and qb.FK_QUALITATIVE_FK=19
    and qb.TAG_DER_MESSUNG< (select max(ED.DATUM) from EXTERNE_DIAGNOSE ED where ED.FK_EXTERNE_PATIENTEN_ID =EXTERNER_PATIENT.PATIENTEN_ID and ED.IMPORT_QUELLE='UKE')
  )
 or exists  -- EIne Externe Prozedur neuer als das letzte Arbeitslistendatum
  (
    select 1 from 
    QUALITATIVER_BEFUND qb 
    where qb.FK_VORHANDENE_DFK=EXTERNER_PATIENT.PAT_ID
    and qb.FK_VORHANDENE_DDAT='Diagnose'
    and qb.FK_QUALITATIVE_FK=19
    and qb.TAG_DER_MESSUNG< (select max(EP.DATUM) from EXTERNE_PROZEDUR EP where EP.FK_EXTERNE_PATIENTEN_ID =EXTERNER_PATIENT.PATIENTEN_ID and EP.IMPORT_QUELLE='UKE')
  )
  or exists  -- EIne EInwilligung für das KKR neuer als das letzte Arbeitslistendatum
  (
    select 1 from 
    QUALITATIVER_BEFUND qb 
    where qb.FK_VORHANDENE_DFK=EXTERNER_PATIENT.PAT_ID
    and qb.FK_VORHANDENE_DDAT='Diagnose'
    and qb.FK_QUALITATIVE_FK=19
    and qb.TAG_DER_MESSUNG< (select max(IB.BEFUND_DATUM) from IMPORT_QUALITATIVER_BEFUND IB where IB.PATIENTEN_ID =EXTERNER_PATIENT.PATIENTEN_ID and IB.IMPORT_QUELLE='UKE' and IB.EXTERNE_BEFUNDART_ID='EINWILLIGUNG_KKR')
  )
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
  and b.KLASSE_CODE=:FILTERCODE
  and qb.FK_VORHANDENE_DFK=EXTERNER_PATIENT.PAT_ID
  and qb.FK_VORHANDENE_DDAT='Diagnose'
  and qb.FK_QUALITATIVE_FK=19
and (qb.TAG_DER_MESSUNG<:enddatum or qb.TAG_DER_MESSUNG is null)
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
  and b.KLASSE_CODE=:FILTERCODE
  and qb.FK_VORHANDENE_DFK=EXTERNER_PATIENT.PAT_ID
  and qb.FK_VORHANDENE_DDAT='Diagnose'
  and qb.FK_QUALITATIVE_FK=19
  )

)
---Filterbedingung für Entität
AND EXISTS (
	SELECT 1 FROM EXTERNE_DIAGNOSE ED
  inner join 
   AW_KLASSEN_ALLE b
   on ED.FK_ICDICD like b.Like_Kriterium
   WHERE ED.Fk_Externe_Patienten_ID = EXTERNER_PATIENT.Patienten_ID
  and b.klassierung_id=5 
  and b.KLASSIERUNG_QUELLE='UKE'
  and b.KLASSE_CODE=:FILTERCODE
                      )