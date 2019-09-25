/*
-- Abfrage zur Arbeitsliste im GTDS
-- 
-- Codes mit ausnahmebedingungen
-- 250 : Rest
-- 240 : ALLE
-- 140 : Metastasen
-- 200 : Prostata
-- 270 : Prostata Onko
--Änderungen:
  20180525: Zeitpunkt der neusten Meldungen parametriert  
  20180801: Zusatzbedingungen für Prostataca -> Filter auf ausschließliche Martiniklinik Aufenthalte, Patienten mit Stammdatenupdate >01.01.2018 und
              ohne Patienten die als alleinige (zusätzliche) Abteilung die UR KERN aufweisen
  20181106: Todesmeldungen ergänzt
  20181217: Externe Metastasen ergänzt via left outer join einer subquery
  20181220: Zweiter Melanomfilter für Patienten, die mind. einen Aufenthalt in der HT Kern oder Haut-Ambulanz hatten (Filter 290)
  20190627: Prostata Onko Filter nur für Onkoambulanz ('8975') und nicht der ganze Onko Bereich ('8975','12973','8982','14972')

*/

/*declare startdatum  date;
declare enddatum  date;
BEGIN
  startdatum:='01-01-2018';
  enddatum='31-12-2018';*/

    
---Arbeistliste
WITH DKHVar AS
    (SELECT :startdatum AS startdate,:enddatum as enddate FROM dual)
    ,DKH as(
select  /*+ OPT_PARAM('_OPTIMIZER_USE_FEEDBACK' 'FALSE') */  EXTERNER_PATIENT.PATIENTEN_ID ,--EXTERNER_PATIENT.PAT_ID,
p.pat_id GTDS_ID,EXTERNER_PATIENT.AENDERUNGSDATUM,EXTERNER_PATIENT.IMPORT_DATUM,
EXTERNER_PATIENT.NAME,EXTERNER_PATIENT.VORNAME,EXTERNER_PATIENT.GEBURTSDATUM,EXTERNER_PATIENT.GESCHLECHT,


(select max(qb.TAG_DER_MESSUNG) from 
QUALITATIVER_BEFUND qb 
where qb.FK_VORHANDENE_DFK=EXTERNER_PATIENT.PAT_ID
and qb.FK_VORHANDENE_DDAT='Diagnose'
and qb.FK_QUALITATIVE_FK=19) as Letzte_Bearbeitung,

case when p.pat_id is not null then 1 else 0 end Im_GTDS,

  qay.Diagnosen_Ext as Externe_Diagnosen,
  icx.fk_icdicd as Aktuellste_Ext_Diagnose,
  qay.Metastasen_Ext as Externe_Metastasen,
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
  
  
 
 (select Datum||' - '||Typ from
(select ED.DATUM as Datum,'Diag.' as Typ,ED.FK_EXTERNE_PATIENTEN_ID PATIENTEN_ID,ED.IMPORT_QUELLE  from EXTERNE_DIAGNOSE ED
  union all
  select EP.DATUM,'Proz.',EP.FK_EXTERNE_PATIENTEN_ID,EP.IMPORT_QUELLE from EXTERNE_PROZEDUR EP 
  union all
  select IB.BEFUND_DATUM,'Einw.',IB.PATIENTEN_ID,IB.IMPORT_QUELLE from IMPORT_QUALITATIVER_BEFUND IB where IB.EXTERNE_BEFUNDART_ID='EINWILLIGUNG_KKR'
  union all
  select apb.BEGINN,'Aufe.',FK_EXTERNE_PATIENTEN_ID,apb.IMPORT_QUELLE from ABTEILUNG_PATIENT_BEZIEHUNG apb where apb.BEGINN<=SYSDATE
  union all
  select nvl(ep1.AENDERUNGSDATUM,ep1.IMPORT_DATUM) as Datum,'Stamm.' as Typ,PATIENTEN_ID,Import_Quelle from EXTERNER_PATIENT ep1
  order by 1 desc  ) XT 
  where XT.PATIENTEN_ID =EXTERNER_PATIENT.PATIENTEN_ID and XT.IMPORT_QUELLE='UKE'
  and XT.DATUm is not null and ROWNUM=1
  )as MAX_EXT_DAT

, case when (EXTERNER_PATIENT.STerbedatum is not null and p.Sterbedatum is null) then 'J' else null end as Sterbemeldung
,EXTERNER_PATIENT.STerbedatum 
,(select count(*) from EXTERNE_PROZEDUR EP where EP.FK_EXTERNE_PATIENTEN_ID =EXTERNER_PATIENT.PATIENTEN_ID and EP.IMPORT_QUELLE='UKE' and EP.DATUM between to_date(DKHVar.startdate) and to_date(DKHVar.enddate)
        and (ep.fk_opschluessel like '8-5%' or ep.fk_opschluessel like '5-%')) as Anzahl_OPS_Zeitraum
,(select count(*) from EXTERNE_DIAGNOSE ED where ED.FK_EXTERNE_PATIENTEN_ID =EXTERNER_PATIENT.PATIENTEN_ID and ED.IMPORT_QUELLE='UKE' and ED.DATUM between to_date(DKHVar.startdate) and to_date(DKHVar.enddate)
     and (ed.FK_ICDICD like 'C%' or ed.FK_ICDICD like 'D%') and (ED.STATUS not in ('V','B') or ED.STATUS is null) ) as Anzahl_Diagnosen_Zeitraum
,(select count(*) from ABTEILUNG_PATIENT_BEZIEHUNG AB where AB.FK_EXTERNE_PATIENTEN_ID =EXTERNER_PATIENT.PATIENTEN_ID and AB.IMPORT_QUELLE='UKE'
      and AB.BEGINN between to_date(DKHVar.startdate) and to_date(DKHVar.enddate)) as Anzahl_Aufenthalte_Zeitraum
,NVL((select max(b.KLASSE_KURZ) from AW_KLASSEN_ALLE b
       where coalesce(T.ICD10,icx.fk_icdicd) like b.Like_Kriterium
      and b.klassierung_id=5 
      and b.klassierung_kurz='Schnittstellen-Filter'
      and b.KLASSIERUNG_QUELLE='UKE'
      and (b.KLASSE_CODE not in (240,250,270,290))),'Rest') as Zuordnung
from 
EXTERNER_PATIENT 
inner join DKHVar on 1=1
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

left outer join (select LISTAGG(ED.Fk_IcdIcd,' | ') WITHIN GROUP (order by null) as Diagnosen_Ext,
    
    LISTAGG(case when substr(ED.Fk_IcdIcd,1,3) in ('C76','C77','C78','C79','C97') then ED.Fk_IcdIcd
                when ED.Fk_IcdIcd in ('D09.7','D09.9')then ED.Fk_IcdIcd else Null end,' | ') WITHIN GROUP (order by ED.Fk_IcdIcd) Metastasen_EXT,
    ED.Fk_Externe_Patienten_ID   
    
    from (select distinct Fk_Externe_Patienten_ID, Fk_IcdIcd
        from  EXTERNE_DIAGNOSE extd
      WHERE (extd.FK_ICDICD like 'C%' or extd.FK_ICDICD like 'D%')and (extd.STATUS not in ('V','B') or extd.STATUS is null))ED group by ED.Fk_Externe_Patienten_ID )qay on qay.Fk_Externe_Patienten_ID = EXTERNER_PATIENT.Patienten_ID 
  
left outer join (select  Fk_Externe_Patienten_ID, Fk_IcdIcd,datum,row_number() over (partition by Fk_Externe_Patienten_ID order by datum desc) rn
        from  EXTERNE_DIAGNOSE extd where extd.import_quelle='UKE'  and (extd.FK_ICDICD like 'C%' or extd.FK_ICDICD like 'D%') and (extd.STATUS not in ('V','B') or extd.STATUS is null)
        order by Fk_Externe_Patienten_ID) ICX on rn=1 and icx.fk_externe_patienten_id  =EXTERNER_PATIENT.Patienten_ID
  
where 
EXTERNER_PATIENT.HAUPT_VERS_NAME='TUMORPATIENT'
and EXTERNER_PATIENT.Import_Quelle = 'UKE'
AND MONTHS_BETWEEN(SYSDATE, EXTERNER_PATIENT.Geburtsdatum)/12 >= 17.5
and
--Filterbedingung Änderungszeitraum
( 
    
 ( 
  (
    ((qba.TAG_DER_MESSUNG is null or qba.TAG_DER_MESSUNG<EXTERNER_PATIENT.AENDERUNGSDATUM) and EXTERNER_PATIENT.AENDERUNGSDATUM >=to_date(DKHVar.startdate) and EXTERNER_PATIENT.AENDERUNGSDATUM <=to_date(DKHVar.enddate)
      )
  or ((qba.TAG_DER_MESSUNG is null or qba.TAG_DER_MESSUNG<EXTERNER_PATIENT.IMPORT_DATUM) and EXTERNER_PATIENT.IMPORT_DATUM between to_date(DKHVar.startdate) and to_date(DKHVar.enddate)
      )
  )
  or exists
    (select 1 from EXTERNE_DIAGNOSE ED where ED.FK_EXTERNE_PATIENTEN_ID =EXTERNER_PATIENT.PATIENTEN_ID and ED.IMPORT_QUELLE='UKE' and ED.DATUM between to_date(to_date(DKHVar.startdate)) and to_date(DKHVar.enddate)
     and (qba.TAG_DER_MESSUNG is null or qba.TAG_DER_MESSUNG<ED.DATUM) and (ED.STATUS not in ('V','B') or ED.STATUS is null) ) --EIne Externe Diagnose im Zeitraum
  or exists
    (select 1 from EXTERNE_PROZEDUR EP where EP.FK_EXTERNE_PATIENTEN_ID =EXTERNER_PATIENT.PATIENTEN_ID and EP.IMPORT_QUELLE='UKE' and EP.DATUM between to_date(DKHVar.startdate) and to_date(DKHVar.enddate)
        and (ep.fk_opschluessel like '8-5%' or ep.fk_opschluessel like '5-%')
      and (qba.TAG_DER_MESSUNG is null or qba.TAG_DER_MESSUNG<EP.DATUM) and (EP.STATUS not in ('V','B') or EP.STATUS is null)) --EIne Externe Prozedur im Zeitraum
  or exists
    (select 1 from ABTEILUNG_PATIENT_BEZIEHUNG AB where AB.FK_EXTERNE_PATIENTEN_ID =EXTERNER_PATIENT.PATIENTEN_ID and AB.IMPORT_QUELLE='UKE'
      and (qba.TAG_DER_MESSUNG is null or qba.TAG_DER_MESSUNG<AB.BEGINN) and AB.BEGINN between to_date(DKHVar.startdate) and to_date(DKHVar.enddate)) --Einen aktuellen Aufenthalt
)

--or p.PAT_ID is null
)
) 
select /*count(*)*/ d.patienten_id,d.gtds_id,
d.Name,d.Vorname,d.geburtsdatum
,d.letzte_bearbeitung
,d.im_gtds
,d.externe_diagnosen
,d.aktuellste_ext_diagnose
,d.diagnose_tumor as diagnose_gtds
,d.diagnosedatum as diagnosedatum_gtds
,d.letzte_bearbeitung_tumor
,d.arbeitsliste_tumor
,d.max_ext_dat
,d.sterbemeldung
,d.sterbedatum
,case when d.anzahl_ops_zeitraum>0 and d.anzahl_diagnosen_zeitraum=0 then 'Prozeduren'
    when d.anzahl_ops_zeitraum>0 and d.anzahl_diagnosen_zeitraum>0 then 'Prozeduren und Diagnosen'
    when d.anzahl_ops_zeitraum=0 and d.anzahl_diagnosen_zeitraum>0 then 'Diagnosen'
    when d.anzahl_ops_zeitraum=0 and d.anzahl_diagnosen_zeitraum=0 and d.anzahl_aufenthalte_zeitraum=0 then 'Kein Event'
    when d.anzahl_ops_zeitraum=0 and d.anzahl_diagnosen_zeitraum=0 and d.anzahl_aufenthalte_zeitraum>0 then 'nur Aufenthalt'
    else null end as Events_Im_Zeitraum
,case when d.letzte_bearbeitung_tumor < to_date(v.startdate) then 'Ja' else 'Nein' end as Bearbeitet_vor_Zeitraum
,d.zuordnung
from DKH d,
DKHVar v
;

