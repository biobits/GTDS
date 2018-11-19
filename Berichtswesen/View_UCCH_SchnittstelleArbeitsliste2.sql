/*
View für die simultane Abfrage der Externen Schnittstellen Daten sowie jener Patienten die das Markmel Arbeitsliste 

Author Stefan Bartels
20181016: Initiale View

*/

CREATE OR REPLACE FORCE VIEW "OPS$TUMSYS"."UCCHSchnittstelleArbeitsliste2"
as
select Q.Typ,Q.Patienten_ID,q.GTDS_ID,Q.Im_GTDS,Q.EXTERNE_DIAGNOSEN,
NVL(b.KLASSE_KURZ,'Rest') Schnittstellen_Filter,
--Q.Schnittstellen_Filter,
Q.Diagnose_Tumor,Q.DIAGNOSEDATUM,
EXTRACT(year FROM Q.DIAGNOSEDATUM) as Diagnosejahr
,Q.Arbeittsliste_Datum,Q.Arbeitsliste_Tumor,Q.Arbeitsliste_Bemerkung,
  ( case when (select count (*) from VORHANDENE_DATEN where FK_PATIENTPAT_ID=Q.GTDS_ID 
                 and TUMOR_ID=Q.Tumor_ID and DATENART in ('Bestrahlung','Innere','Operation')
                  and ERFASSUNG_ABGESCHL<>'V'
                  and DATUM between '01.01.2017' and '31.12.2017')>0 then 'Ja' else 'Nein' end ) as Therapie_2017,
  ( case when (select count (*) from VORHANDENE_DATEN where FK_PATIENTPAT_ID=Q.GTDS_ID 
                  and TUMOR_ID=Q.Tumor_ID and DATENART in ('Bestrahlung','Innere','Operation')
                  and ERFASSUNG_ABGESCHL<>'V'
                  and DATUM between '01.01.2018' and '31.12.2018')>0 then 'Ja' else 'Nein' end ) as Therapie_2018,                  

   (select qa.AUSPRAEGUNG
    FROM QUALITATIVER_BEFUND qb 
    inner join QUALITATIVE_AUSPRAEGUNG qa
    on qb.FK_QUALITATIVE_ID=qa.ID and qb.Fk_Qualitative_Fk=qa.FK_QUALITATIVESID
    inner join Qualitatives_Merkmal qm
    on qm.ID=qb.FK_QUALITATIVE_FK
          WHERE 
          Q.TUMOR_ID=qb.FK_VORHANDENE_DLFD
          and Q.GTDS_ID=qb.FK_VORHANDENE_DFK
            AND qb.Fk_Qualitative_Fk =74  
            -- Merkmale für Bearbeitet in 83,74,69,55
            AND qb.Fk_Vorhandene_DDAT = 'Diagnose' ) as Behandelt_In_2017, 
     (select qa2.AUSPRAEGUNG
    FROM QUALITATIVER_BEFUND qb2 
    inner join QUALITATIVE_AUSPRAEGUNG qa2
    on qb2.FK_QUALITATIVE_ID=qa2.ID and qb2.Fk_Qualitative_Fk=qa2.FK_QUALITATIVESID
    inner join Qualitatives_Merkmal qm2
    on qm2.ID=qb2.FK_QUALITATIVE_FK
          WHERE 
          Q.TUMOR_ID=qb2.FK_VORHANDENE_DLFD
          and Q.GTDS_ID=qb2.FK_VORHANDENE_DFK
            AND qb2.Fk_Qualitative_Fk =83  
            -- Merkmale für Bearbeitet in 83,74,69,55
            AND qb2.Fk_Vorhandene_DDAT = 'Diagnose' ) as Behandelt_In_2018,
	 (select max(Datum) from 
	(select ED.DATUM as Datum,'Diag.' as Typ,ED.FK_EXTERNE_PATIENTEN_ID PATIENTEN_ID,ED.IMPORT_QUELLE  from EXTERNE_DIAGNOSE ED 
	  union all
	  select EP.DATUM,'Proz.',EP.FK_EXTERNE_PATIENTEN_ID,EP.IMPORT_QUELLE from EXTERNE_PROZEDUR EP  
	  union all
	  select IB.BEFUND_DATUM,'Einw.',IB.PATIENTEN_ID,IB.IMPORT_QUELLE from IMPORT_QUALITATIVER_BEFUND IB where IB.EXTERNE_BEFUNDART_ID='EINWILLIGUNG_KKR'
	  union all
	  select apb.BEGINN,'Aufe.',FK_EXTERNE_PATIENTEN_ID,apb.IMPORT_QUELLE from ABTEILUNG_PATIENT_BEZIEHUNG apb where apb.BEGINN<=SYSDATE ) XT
	  where XT.PATIENTEN_ID =Q.PATIENTEN_ID and XT.IMPORT_QUELLE='UKE'
	  and XT.DATUm is not null  ) as MAX_EXT_DAT,
	  1 as Anzahl
from
(
select  'Schnittstelle' as Typ,  EXTERNER_PATIENT.PATIENTEN_ID ,
p.pat_id GTDS_ID,
case when p.pat_id is not null then 1 else 0 end Im_GTDS,
  exd.FK_ICDICD as Externe_Diagnosen,
  --nvl(b.KLASSE_KURZ,'Rest') as Schnittstellen_Filter,
  T.ICD10 as Diagnose_Tumor,
  T.TUMOR_ID,
  T.DIAGNOSEDATUM,
  qba.TAG_DER_MESSUNG as Arbeittsliste_Datum,
  qaa.Auspraegung  Arbeitsliste_Tumor ,
  qba.BEMERKUNG as Arbeitsliste_Bemerkung  
 from 
EXTERNER_PATIENT 
left outer join 
patient  p 
on p.pat_id=EXTERNER_PATIENT.pat_id
or p.PATIENTEN_ID= EXTERNER_PATIENT.PATIENTEN_ID
inner join (select distinct Fk_Externe_Patienten_ID,STATUS,FK_ICDICD from EXTERNE_DIAGNOSE) exd
on exd.Fk_Externe_Patienten_ID = EXTERNER_PATIENT.Patienten_ID 
          /*    inner join 
            AW_KLASSEN_ALLE b
               on exd.FK_ICDICD like b.Like_Kriterium  

           and b.klassierung_id=5 
           and b.KLASSIERUNG_QUELLE='UKE'
              and b.KLASSE_CODE<>240 -- code für klasse Alle*/
             and (exd.STATUS not in ('V','B') or exd.STATUS is null)
left outer join TUMOR T on 
T.FK_PATIENTPAT_ID=EXTERNER_PATIENT.pat_id
  /*and exists(select 1 from 
    AW_KLASSEN_ALLE b2
        where T.ICD10 like b2.Like_Kriterium
        and b2.klassierung_id=5 
            and b2.KLASSIERUNG_QUELLE='UKE'
            and b2.KLASSE_CODE=b.KLASSE_CODE) */-- soll die Zugewiesene Tumordiagnose auf die ICD der externen diagnose mappen
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
 ( 
  (
    ((qba.TAG_DER_MESSUNG is null or qba.TAG_DER_MESSUNG<EXTERNER_PATIENT.AENDERUNGSDATUM) and EXTERNER_PATIENT.AENDERUNGSDATUM <= sysdate-7
      )
  or ((qba.TAG_DER_MESSUNG is null or qba.TAG_DER_MESSUNG<EXTERNER_PATIENT.IMPORT_DATUM) and EXTERNER_PATIENT.IMPORT_DATUM <= sysdate-7
      )
  )
  or exists
    (select 1 from EXTERNE_DIAGNOSE ED where ED.FK_EXTERNE_PATIENTEN_ID =EXTERNER_PATIENT.PATIENTEN_ID and ED.IMPORT_QUELLE='UKE' and ED.DATUM <= sysdate-7
     and (qba.TAG_DER_MESSUNG is null or qba.TAG_DER_MESSUNG<ED.DATUM) and (ED.STATUS not in ('V','B') or ED.STATUS is null) ) --EIne Externe Diagnose im Zeitraum
  or exists
    (select 1 from EXTERNE_PROZEDUR EP where EP.FK_EXTERNE_PATIENTEN_ID =EXTERNER_PATIENT.PATIENTEN_ID and EP.IMPORT_QUELLE='UKE' and EP.DATUM <= sysdate-7
      and (qba.TAG_DER_MESSUNG is null or qba.TAG_DER_MESSUNG<EP.DATUM) and (EP.STATUS not in ('V','B') or EP.STATUS is null)) --EIne Externe Prozedur im Zeitraum
  or exists
    (select 1 from IMPORT_QUALITATIVER_BEFUND IB where IB.PATIENTEN_ID =EXTERNER_PATIENT.PATIENTEN_ID and IB.IMPORT_QUELLE='UKE' and IB.EXTERNE_BEFUNDART_ID='EINWILLIGUNG_KKR' and IB.BEFUND_DATUM <= sysdate-7 
      and (qba.TAG_DER_MESSUNG is null or qba.TAG_DER_MESSUNG<IB.BEFUND_DATUM)) --EIne EInwilligung für das KKR im Zeitraum
  or exists
    (select 1 from ABTEILUNG_PATIENT_BEZIEHUNG AB where AB.FK_EXTERNE_PATIENTEN_ID =EXTERNER_PATIENT.PATIENTEN_ID and AB.IMPORT_QUELLE='UKE'
      and (qba.TAG_DER_MESSUNG is null or qba.TAG_DER_MESSUNG<AB.BEGINN) and AB.BEGINN<= sysdate-7) --Einen aktuellen Aufenthalt
)

or p.PAT_ID is null
)
union 
select 'Arbeistliste' as Typ, pa.PATIENTEN_ID,pa.PAT_ID as GTDS_ID,--null as LETZTE_BEARBEITUNG,
1 as IM_GTDS,t.ICD10 as EXTERNE_DIAGNOSE,
--NVL(b.KLASSE_KURZ,'Rest') Schnittstellen_Filter,
t.ICD10 as Diagnose_Tumor,t.TUMOR_ID, t.DIAGNOSEDATUM,qba.TAG_DER_MESSUNG as Arbeittsliste_Datum,qaa.AUSPRAEGUNG as Merkmal_Arbeistliste, 
 qba.BEMERKUNG as Arbeitsliste_Bemerkung

from Tumor t inner join PAtient pa

on pa.PAT_ID=t.FK_PATIENTPAT_ID

inner join QUALITATIVER_BEFUND qba --Arbeitslisteninfos   
on T.FK_PATIENTPAT_ID=qba.FK_VORHANDENE_DFK
and T.TUMOR_ID=qba.FK_VORHANDENE_DLFD
and qba.FK_VORHANDENE_DDAT='Diagnose'
and qba.FK_QUALITATIVE_FK=19
and qba.Fk_Qualitative_ID not in (1,2,3,10)
left outer join QUALITATIVE_AUSPRAEGUNG qaa
  on qba.Fk_Qualitative_Fk = qaa.Fk_QualitativesID -- Merkmal
            AND qba.Fk_Qualitative_ID = qaa.ID
/*left outer join      AW_KLASSEN_ALLE b

               on t.ICD10 like b.Like_Kriterium
               and b.klassierung_id=5 
              and b.KLASSIERUNG_QUELLE='UKE'
              and b.KLASSE_CODE<>240*/
    where not exists (

    

 select 1 from    EXTERNER_PATIENT  

inner join 

patient  p 

on p.pat_id=EXTERNER_PATIENT.pat_id

or p.PATIENTEN_ID= EXTERNER_PATIENT.PATIENTEN_ID

inner join (select distinct Fk_Externe_Patienten_ID,STATUS,FK_ICDICD from EXTERNE_DIAGNOSE) exd

on exd.Fk_Externe_Patienten_ID = EXTERNER_PATIENT.Patienten_ID 

              inner join 

               AW_KLASSEN_ALLE b

               on exd.FK_ICDICD like b.Like_Kriterium

              

              and b.klassierung_id=5 

              and b.KLASSIERUNG_QUELLE='UKE'

              and b.KLASSE_CODE<>240 -- code für klasse Alle

             and (exd.STATUS not in ('V','B') or exd.STATUS is null)

left outer join TUMOR T on 

T.FK_PATIENTPAT_ID=EXTERNER_PATIENT.pat_id

  and exists(select 1 from 

    AW_KLASSEN_ALLE b2

        where T.ICD10 like b2.Like_Kriterium

        and b2.klassierung_id=5 

            and b2.KLASSIERUNG_QUELLE='UKE'

            and b2.KLASSE_CODE=b.KLASSE_CODE) /**/-- soll die Zugewiesene Tumordiagnose auf die ICD der externen diagnose mappen

  left outer join QUALITATIVER_BEFUND qba --Arbeitslisteninfos   

on T.FK_PATIENTPAT_ID=qba.FK_VORHANDENE_DFK

and T.TUMOR_ID=qba.FK_VORHANDENE_DLFD

and qba.FK_VORHANDENE_DDAT='Diagnose'

and qba.FK_QUALITATIVE_FK=19

left outer join QUALITATIVE_AUSPRAEGUNG qaa

  on qba.Fk_Qualitative_Fk = qaa.Fk_QualitativesID -- Merkmal

            AND qba.Fk_Qualitative_ID = qaa.ID

where 

pa.PAT_ID=p.PAT_ID

and

EXTERNER_PATIENT.HAUPT_VERS_NAME='TUMORPATIENT'

and EXTERNER_PATIENT.Import_Quelle = 'UKE'

AND MONTHS_BETWEEN(SYSDATE, EXTERNER_PATIENT.Geburtsdatum)/12 >= 17.5



and

--Filterbedingung Änderungszeitraum

( 

    

 ( 

  (

    ((qba.TAG_DER_MESSUNG is null or qba.TAG_DER_MESSUNG<EXTERNER_PATIENT.AENDERUNGSDATUM) and EXTERNER_PATIENT.AENDERUNGSDATUM <= sysdate-7

      )
  or ((qba.TAG_DER_MESSUNG is null or qba.TAG_DER_MESSUNG<EXTERNER_PATIENT.IMPORT_DATUM) and EXTERNER_PATIENT.IMPORT_DATUM <= sysdate-7
      )
  )
  or exists
    (select 1 from EXTERNE_DIAGNOSE ED where ED.FK_EXTERNE_PATIENTEN_ID =EXTERNER_PATIENT.PATIENTEN_ID and ED.IMPORT_QUELLE='UKE' and ED.DATUM <= sysdate-7
     and (qba.TAG_DER_MESSUNG is null or qba.TAG_DER_MESSUNG<ED.DATUM) and (ED.STATUS not in ('V','B') or ED.STATUS is null) ) --EIne Externe Diagnose im Zeitraum
  or exists
    (select 1 from EXTERNE_PROZEDUR EP where EP.FK_EXTERNE_PATIENTEN_ID =EXTERNER_PATIENT.PATIENTEN_ID and EP.IMPORT_QUELLE='UKE' and EP.DATUM <= sysdate-7
      and (qba.TAG_DER_MESSUNG is null or qba.TAG_DER_MESSUNG<EP.DATUM) and (EP.STATUS not in ('V','B') or EP.STATUS is null)) --EIne Externe Prozedur im Zeitraum
  or exists
    (select 1 from IMPORT_QUALITATIVER_BEFUND IB where IB.PATIENTEN_ID =EXTERNER_PATIENT.PATIENTEN_ID and IB.IMPORT_QUELLE='UKE' and IB.EXTERNE_BEFUNDART_ID='EINWILLIGUNG_KKR' and IB.BEFUND_DATUM <= sysdate-7 
      and (qba.TAG_DER_MESSUNG is null or qba.TAG_DER_MESSUNG<IB.BEFUND_DATUM)) --EIne EInwilligung für das KKR im Zeitraum
  or exists
    (select 1 from ABTEILUNG_PATIENT_BEZIEHUNG AB where AB.FK_EXTERNE_PATIENTEN_ID =EXTERNER_PATIENT.PATIENTEN_ID and AB.IMPORT_QUELLE='UKE'
      and (qba.TAG_DER_MESSUNG is null or qba.TAG_DER_MESSUNG<AB.BEGINN) and AB.BEGINN<= sysdate-7) --Einen aktuellen Aufenthalt

)

)

)) Q
inner join 
            AW_KLASSEN_ALLE b
               on Q.EXTERNE_DIAGNOSEN like b.Like_Kriterium  

           and b.klassierung_id=5 
           and b.KLASSIERUNG_QUELLE='UKE'
              and b.KLASSE_CODE<>240 -- code für klasse Alle
 /* where
   exists(select 1 from 
    AW_KLASSEN_ALLE b2
        where Q.Diagnose_Tumor like b2.Like_Kriterium
        and b2.klassierung_id=5 
            and b2.KLASSIERUNG_QUELLE='UKE'
            and b2.KLASSE_CODE=b.KLASSE_CODE) */;
