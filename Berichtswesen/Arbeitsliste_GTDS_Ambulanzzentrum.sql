/*
-- Abfrage zur Arbeitsliste des Ambulanzzentrums im GTDS
-- 

--Änderungen:
  20200609: ZErstellung  


*/
---Arbeistliste
select  /*+ OPT_PARAM('_OPTIMIZER_USE_FEEDBACK' 'FALSE') */  EXTERNER_PATIENT.PATIENTEN_ID ,EXTERNER_PATIENT.PAT_ID,
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
AB.BEGINN as AmbulanzAufenthaltBeginn,
ab.fall_nummer as AmbulanzFallnummer,
(select max(qb.TAG_DER_MESSUNG) from 
QUALITATIVER_BEFUND qb 
where qb.FK_VORHANDENE_DFK=EXTERNER_PATIENT.PAT_ID
and qb.FK_VORHANDENE_DDAT='Diagnose'
and qb.FK_QUALITATIVE_FK=19) as Letzte_Bearbeitung,

case when EXTERNER_PATIENT.PAT_ID is null and p.pat_id is not null then 1 else 0 end Link_Missing,
case when p.pat_id is not null then 1 else 0 end Im_GTDS,
  qay.Diagnosen_Ext as Externe_Diagnosen,
/*  qay.Metastasen_Ext as Externe_Metastasen,
 (
	SELECT LISTAGG(ICD10,' | ') WITHIN GROUP (order by T.DIAGNOSEDATUM desc) from TUMOR T
	 where t.FK_PATIENTPAT_ID = P.Pat_ID 
  	) as Diagnosen,
    */

  T.ICD10 as Diagnose_Tumor,
  T.DIAGNOSEDATUM,
  qba.TAG_DER_MESSUNG as Letzte_Bearbeitung_Tumor,
  case when qba.BEMERKUNG is null then qaa.Auspraegung else qaa.Auspraegung ||' - '||qba.BEMERKUNG end Arbeitsliste_Tumor ,
  
  qby.TAG_DER_MESSUNG as Letzte_Bearbeitung_Ambulanz,
  case when qby.BEMERKUNG is null then qaz.Auspraegung else qaz.Auspraegung ||' - '||qby.BEMERKUNG end Ambulanz_Tumor ,
(select NVL(to_char(max(tb.BEGINN)),'Keine RT') from teilbestrahlung tb
            inner join BESTRAHLUNG b
            on tb.fk_bestrahlungfk_0=b.fk_tumorfk_patient
            and tb.fk_bestrahlunglfdn=b.lfdnr
            where b.fk_abteilungabteil in (26775, 267750)
            and tb.fk_bestrahlungfk_0 = p.pat_id ) as Letzte_RT,

case when (EXTERNER_PATIENT.STerbedatum is not null and p.Sterbedatum is null) then 'J' else null end as Sterbemeldung
,EXTERNER_PATIENT.STerbedatum 
,             (select case when max(qb.Fk_Qualitative_Fk) is null then 'kein Merkmal' 
    when max(qa.AUSPRAEGUNG) is null then 'N.D.' else max(qa.AUSPRAEGUNG) end
    FROM QUALITATIVER_BEFUND qb 
    left outer join QUALITATIVE_AUSPRAEGUNG qa
    on qb.FK_QUALITATIVE_ID=qa.ID and qb.Fk_Qualitative_Fk=qa.FK_QUALITATIVESID
          WHERE 
          T.TUMOR_ID=qb.FK_VORHANDENE_DLFD
          and T.FK_PATIENTPAT_ID=qb.FK_VORHANDENE_DFK
            AND qb.Fk_Qualitative_Fk = 102          -- Merkmal ist Dokumentationsstand
            AND qb.Fk_Vorhandene_DDAT = 'Diagnose' ) as Dokustand
from 
EXTERNER_PATIENT 
left outer join 
patient  p 
on p.pat_id=EXTERNER_PATIENT.pat_id
or p.PATIENTEN_ID= EXTERNER_PATIENT.PATIENTEN_ID
left outer join TUMOR T on 
T.FK_PATIENTPAT_ID=EXTERNER_PATIENT.pat_id
  left outer join QUALITATIVER_BEFUND qba --Arbeitslisteninfos   
on T.FK_PATIENTPAT_ID=qba.FK_VORHANDENE_DFK
 and T.TUMOR_ID=qba.FK_VORHANDENE_DLFD
and qba.FK_VORHANDENE_DDAT='Diagnose'
and qba.FK_QUALITATIVE_FK=19
left outer join QUALITATIVE_AUSPRAEGUNG qaa
  on qba.Fk_Qualitative_Fk = qaa.Fk_QualitativesID -- Merkmal
            AND qba.Fk_Qualitative_ID = qaa.ID

 left outer join QUALITATIVER_BEFUND qby --Ambulanzzen   
on T.FK_PATIENTPAT_ID=qby.FK_VORHANDENE_DFK
 and T.TUMOR_ID=qby.FK_VORHANDENE_DLFD
and qby.FK_VORHANDENE_DDAT='Diagnose'
and qby.FK_QUALITATIVE_FK=155
left outer join QUALITATIVE_AUSPRAEGUNG qaz
  on qby.Fk_Qualitative_Fk = qaz.Fk_QualitativesID -- Merkmal
            AND qby.Fk_Qualitative_ID = qaz.ID

left outer join (select LISTAGG(ED.Fk_IcdIcd,' | ') WITHIN GROUP (order by ED.Fk_IcdIcd) as Diagnosen_Ext,
    LISTAGG(case when substr(ED.Fk_IcdIcd,1,3) in ('C76','C77','C78','C79','C97') then ED.Fk_IcdIcd
                when ED.Fk_IcdIcd in ('D09.7','D09.9')then ED.Fk_IcdIcd else Null end,' | ') WITHIN GROUP (order by ED.Fk_IcdIcd) Metastasen_EXT,
    ED.Fk_Externe_Patienten_ID   from (select distinct Fk_Externe_Patienten_ID, Fk_IcdIcd from  EXTERNE_DIAGNOSE extd
      WHERE (extd.FK_ICDICD like 'C%' or extd.FK_ICDICD like 'D%'))ED group by ED.Fk_Externe_Patienten_ID )qay
      on qay.Fk_Externe_Patienten_ID = EXTERNER_PATIENT.Patienten_ID 
 
 inner join  ABTEILUNG_PATIENT_BEZIEHUNG AB
 on  AB.FK_EXTERNE_PATIENTEN_ID =EXTERNER_PATIENT.PATIENTEN_ID and AB.IMPORT_QUELLE='UKE'
        and AB.fk_abteilungabteil = 26775
where 
EXTERNER_PATIENT.HAUPT_VERS_NAME='TUMORPATIENT' and 
EXTERNER_PATIENT.Import_Quelle = 'UKE'
AND MONTHS_BETWEEN(SYSDATE, EXTERNER_PATIENT.Geburtsdatum)/12 >= 17.5
and AB.BEGINN<= :enddatum and AB.BEGINN>= :startdatum
and
--Filterbedingung Änderungszeitraum
(   ((qba.TAG_DER_MESSUNG is null or qba.TAG_DER_MESSUNG<AB.BEGINN) )
  /*exists
    (select 1 from ABTEILUNG_PATIENT_BEZIEHUNG AB where AB.FK_EXTERNE_PATIENTEN_ID =EXTERNER_PATIENT.PATIENTEN_ID and AB.IMPORT_QUELLE='UKE'
        and AB.fk_abteilungabteil = 26775
      and (qba.TAG_DER_MESSUNG is null or qba.TAG_DER_MESSUNG<AB.BEGINN) and AB.BEGINN<= :enddatum) --Einen aktuellen Aufenthalt
)*/

or 
p.PAT_ID is null
)
--Filterbedingung Abulanzzentrum: nur in Abteilungen des Ambulanzzentrums
and 
(p.PAT_ID is null or AB.BEGINN>NVL((select max(tb.BEGINN) from teilbestrahlung tb
            inner join BESTRAHLUNG b
            on tb.fk_bestrahlungfk_0=b.fk_tumorfk_patient
            and tb.fk_bestrahlunglfdn=b.lfdnr
            where b.fk_abteilungabteil in (26775, 267750)
            and tb.fk_bestrahlungfk_0 = ab.fk_patientpat_id ),'01-01-1900')
            )
 /*  EXISTS(
    SELECT 1
    FROM ABTEILUNG_PATIENT_BEZIEHUNG ABP1
    WHERE ABP1.Fk_Externe_Patienten_ID = EXTERNER_PATIENT.Patienten_ID
    AND ABP1.fk_abteilungabteil = 26775
    and (abp1.fk_patientpat_id is null or ABP1.BEGINN>(select max(tb.BEGINN) from teilbestrahlung tb
            inner join BESTRAHLUNG b
            on tb.fk_bestrahlungfk_0=b.fk_tumorfk_patient
            and tb.fk_bestrahlunglfdn=b.lfdnr
            where b.fk_abteilungabteil in (26775, 267750)
            and tb.fk_bestrahlungfk_0 = abp1.fk_patientpat_id ) -- Aufenthalt nach der letztem Bestraglungsbeginn
        )
    )*/
order by ab.beginn 
;
