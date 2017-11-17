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
  	) as Diagnosen
from 
EXTERNER_PATIENT 
left outer join 
patient  p 
on p.pat_id=EXTERNER_PATIENT .pat_id
or p.PATIENTEN_ID= EXTERNER_PATIENT.PATIENTEN_ID
where 
EXTERNER_PATIENT.HAUPT_VERS_NAME='TUMORPATIENT'
and EXTERNER_PATIENT.Import_Quelle = 'UKE'
--AND MONTHS_BETWEEN(SYSDATE, EXTERNER_PATIENT.Geburtsdatum)/12 >= 17.5
and
--Filterbedingung Änderungszeitraum
COALESCE(EXTERNER_PATIENT.AENDERUNGSDATUM,EXTERNER_PATIENT.IMPORT_DATUM) between :startdatum and :enddatum
--Filterbedingung: Wenn letzte Bearbeitung nicht größer gleich ENdatum des Änderungszeitraumes oder Patient nicht im GTDS
and ( not exists 
(select 1 from 
QUALITATIVER_BEFUND qb 
where qb.FK_VORHANDENE_DFK=EXTERNER_PATIENT.PAT_ID
and qb.FK_VORHANDENE_DDAT='Diagnose'
and qb.FK_QUALITATIVE_FK=19
and qb.TAG_DER_MESSUNG>=:enddatum
) or p.PAT_ID is null
)
---Filterbedingung für Entität
AND EXISTS (
	SELECT 1 FROM EXTERNE_DIAGNOSE ED
	WHERE ED.Fk_Externe_Patienten_ID = EXTERNER_PATIENT.Patienten_ID
	AND 	(ED.Fk_IcdIcd LIKE 'C50%' OR 
		ED.Fk_IcdIcd LIKE 'D05%'
		)
                      )
order by COALESCE(EXTERNER_PATIENT.AENDERUNGSDATUM,EXTERNER_PATIENT.IMPORT_DATUM) desc
;

select BEZEICHNUNG,WHEREBEDINGUNG from ABFRAGE
where TABELLENLISTE='EXTERNER_PATIENT'
and QUELLE = 'UKE'
union
Select 'Alle','0=0' from DUal;



