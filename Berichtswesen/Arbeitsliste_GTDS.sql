--Anzahl Patienten ohne LInk --9303
select count(*) from EXTERNER_PATIENT EP
inner join  PATIENT P
on P.PATIENTEN_ID = EP.PATIENTEN_ID
WHERE EP.PAT_ID is null
and EP.IMPORT_QUELLE='UKE';

-- Update der Pat-ID's bei vorhandenen Patienten
MERGE INTO EXTERNER_PATIENT EP
USING (
    SELECT PAT_ID,PATIENTEN_ID
    FROM PATIENT 
) P
    ON (P.PATIENTEN_ID = EP.PATIENTEN_ID)
WHEN MATCHED THEN UPDATE
    SET EP.PAT_ID = P.PAT_ID
WHERE EP.PAT_ID is null
and EP.IMPORT_QUELLE='UKE'
;
commit;


---Arbeistliste
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
inner join (select column_value from THE ( select  cast( in_list(:ICDLIST) as
strTableType ) from dual ) a) X
  on T.ICD10 like X.column_value
where qb.FK_VORHANDENE_DFK=EXTERNER_PATIENT.PAT_ID
and qb.FK_VORHANDENE_DDAT='Diagnose'
and qb.FK_QUALITATIVE_FK=19) as Letzte_Bearbeitung_Tumor,


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
   inner join (select column_value from THE ( select  cast( in_list(:ICDLIST) as strTableType ) from dual ) a) X
  on T1.ICD10 like X.column_value
  where  T1.FK_PATIENTPAT_ID=EXTERNER_PATIENT.pat_id) as Diagnose_Kontext,
  (select case when max(qb.Fk_Qualitative_Fk) is null then 'kein Merkmal' 
    when max(qa.AUSPRAEGUNG) is null then 'N.D.' else max(qa.AUSPRAEGUNG) end
    FROM QUALITATIVER_BEFUND qb inner join Tumor T
      on T.TUMOR_ID=qb.FK_VORHANDENE_DLFD
      and T.FK_PATIENTPAT_ID=qb.FK_VORHANDENE_DFK
      inner join (select column_value from THE ( select  cast( in_list(:ICDLIST) as
      strTableType ) from dual ) a) X
        on T.ICD10 like X.column_value
    left outer join QUALITATIVE_AUSPRAEGUNG qa
    on qb.FK_QUALITATIVE_ID=qa.ID and qb.Fk_Qualitative_Fk=qa.FK_QUALITATIVESID
          WHERE EXTERNER_PATIENT.PAT_ID= qb.Fk_Vorhandene_DFK
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
--AND MONTHS_BETWEEN(SYSDATE, EXTERNER_PATIENT.Geburtsdatum)/12 >= 17.5
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
   AW_KLASSENBEDINGUNG b
   on T.ICD10 like b.Like_Kriterium
  inner join AW_KLASSE k
  on k.code=b.code
  and k.klassierung_id=b.KLASSIERUNG_ID
  and b.KLASSIERUNG_QUELLE=k.KLASSIERUNG_QUELLE
  WHERE 
  k.klassierung_id=5 
  and K.KLASSIERUNG_QUELLE='UKE'
  and k.CODE=:FILTERCODE
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
   AW_KLASSENBEDINGUNG b
   on T.ICD10 like b.Like_Kriterium
  inner join AW_KLASSE k
  on k.code=b.code
  and k.klassierung_id=b.KLASSIERUNG_ID
  and b.KLASSIERUNG_QUELLE=k.KLASSIERUNG_QUELLE
  WHERE k.klassierung_id=5 
  and K.KLASSIERUNG_QUELLE='UKE'
  and k.CODE=:FILTERCODE
  and qb.FK_VORHANDENE_DFK=EXTERNER_PATIENT.PAT_ID
  and qb.FK_VORHANDENE_DDAT='Diagnose'
  and qb.FK_QUALITATIVE_FK=19
  )

)
---Filterbedingung für Entität
AND EXISTS (
	SELECT 1 FROM EXTERNE_DIAGNOSE ED
  inner join 
   AW_KLASSENBEDINGUNG b
   on ED.FK_ICDICD like b.Like_Kriterium
  inner join AW_KLASSE k
  on k.code=b.code
  and k.klassierung_id=b.KLASSIERUNG_ID
  and b.KLASSIERUNG_QUELLE=k.KLASSIERUNG_QUELLE
  WHERE ED.Fk_Externe_Patienten_ID = EXTERNER_PATIENT.Patienten_ID
  and k.klassierung_id=5 
  and K.KLASSIERUNG_QUELLE='UKE'
  and k.CODE=:FILTERCODE
	/*AND 	(ED.Fk_IcdIcd LIKE 'C50%' OR 		ED.Fk_IcdIcd LIKE 'D05%')*/
                      )
order by COALESCE(EXTERNER_PATIENT.AENDERUNGSDATUM,EXTERNER_PATIENT.IMPORT_DATUM) desc
;


-- Filter Query  für Report
select BEZEICHNUNG,WHEREBEDINGUNG from ABFRAGE
where TABELLENLISTE='EXTERNER_PATIENT'
and QUELLE = 'UKE'
union
Select 'Alle','0=0' from DUal;

--- AW_KLASSEN
select distinct b.LIKE_KRITERIUM,k.CODE,k.TEXT30,k.TEXT255,k.BESCHREIBUNG,k.KLASSIERUNG_QUELLE,a.KURZBEZEICHNUNG ,a.BEZEICHNUNG
from  AW_KLASSENBEDINGUNG b

inner join AW_KLASSE k
on k.code=b.code
and k.klassierung_id=b.KLASSIERUNG_ID
and b.KLASSIERUNG_QUELLE=k.KLASSIERUNG_QUELLE

inner join AW_KLASSIERUNG A
on a.ID=k.KLASSIERUNG_ID

where 
 a.ID=5 
 and a.QUELLE='UKE';



