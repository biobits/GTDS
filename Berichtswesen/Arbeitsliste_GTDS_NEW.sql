/*
-- Abfrage zur Arbeitsliste im GTDS
-- 
-- Codes mit ausnahmebedingungen
-- 250 : Rest
-- 240 : ALLE
-- 140 : Metastasen
-- 200 : Prostata
--Änderungen:
  20180525: Zeitpunkt der neusten Meldungen parametriert  
  20180801: Zusatzbedingungen für Prostataca -> Filter auf ausschließliche Martiniklinik Aufenthalte, Patienten mit Stammdatenupdate >01.01.2018 und
              ohne Patienten die als alleinige (zusätzliche) Abteilung die UR KERN aufweisen
  20181106: Todesmeldungen ergänzt
  20181217: Externe Metastasen ergänzt via left outer join einer subquery
  20181220: Zweiter Melanomfilter für Patienten, die mind. einen Aufenthalt in der HT Kern oder Haut-Ambulanz hatten (Filter 290)

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

(select max(qb.TAG_DER_MESSUNG) from 
QUALITATIVER_BEFUND qb 
where qb.FK_VORHANDENE_DFK=EXTERNER_PATIENT.PAT_ID
and qb.FK_VORHANDENE_DDAT='Diagnose'
and qb.FK_QUALITATIVE_FK=19) as Letzte_Bearbeitung,

case when EXTERNER_PATIENT.PAT_ID is null and p.pat_id is not null then 1 else 0 end Link_Missing,
case when p.pat_id is not null then 1 else 0 end Im_GTDS,
/* (
	SELECT LISTAGG(Fk_IcdIcd,' | ') WITHIN GROUP (order by Fk_IcdIcd) as X  FROM 
  (select distinct ED.Fk_Externe_Patienten_ID,ED.Fk_IcdIcd from EXTERNE_DIAGNOSE ED
	WHERE (ED.FK_ICDICD like 'C%' or ED.FK_ICDICD like 'D%')
  ) where Fk_Externe_Patienten_ID = EXTERNER_PATIENT.Patienten_ID 
  
	) as Externe_Diagnosen,*/
  qay.Diagnosen_Ext as Externe_Diagnosen,
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
  
 (select max(Datum) from 
(select ED.DATUM as Datum,'Diag.' as Typ,ED.FK_EXTERNE_PATIENTEN_ID PATIENTEN_ID,ED.IMPORT_QUELLE  from EXTERNE_DIAGNOSE ED 
  union all
  select EP.DATUM,'Proz.',EP.FK_EXTERNE_PATIENTEN_ID,EP.IMPORT_QUELLE from EXTERNE_PROZEDUR EP  
  union all
  select IB.BEFUND_DATUM,'Einw.',IB.PATIENTEN_ID,IB.IMPORT_QUELLE from IMPORT_QUALITATIVER_BEFUND IB where IB.EXTERNE_BEFUNDART_ID='EINWILLIGUNG_KKR'
  union all
  select apb.BEGINN,'Aufe.',FK_EXTERNE_PATIENTEN_ID,apb.IMPORT_QUELLE from ABTEILUNG_PATIENT_BEZIEHUNG apb where apb.BEGINN<=SYSDATE ) XT
  where XT.PATIENTEN_ID =EXTERNER_PATIENT.PATIENTEN_ID and XT.IMPORT_QUELLE='UKE'
  and XT.DATUm is not null
  
  ) as MAX_EXT_DAT
/*(Select XB.Datum||' ('||XB.Typ||')' from (select XT.* ,
ROW_NUMBER() OVER (partition by XT.Patienten_ID order by XT.Datum desc) rno
from (select ED.DATUM as Datum,'Diag.' as Typ,ED.FK_EXTERNE_PATIENTEN_ID PATIENTEN_ID,ED.IMPORT_QUELLE  from EXTERNE_DIAGNOSE ED 
  union all
  select EP.DATUM,'Proz.',EP.FK_EXTERNE_PATIENTEN_ID,EP.IMPORT_QUELLE from EXTERNE_PROZEDUR EP  
  union all
  select IB.BEFUND_DATUM,'Einw.',IB.PATIENTEN_ID,IB.IMPORT_QUELLE from IMPORT_QUALITATIVER_BEFUND IB where IB.EXTERNE_BEFUNDART_ID='EINWILLIGUNG_KKR'
  union all
  select apb.BEGINN,'Aufe.',FK_EXTERNE_PATIENTEN_ID,apb.IMPORT_QUELLE from ABTEILUNG_PATIENT_BEZIEHUNG apb where apb.BEGINN<=SYSDATE ) XT
  where  XT.IMPORT_QUELLE='UKE' 
  and XT.DATUm is not null)XB where XB.PATIENTEN_ID =EXTERNER_PATIENT.PATIENTEN_ID and XB.rno=1) as MAX_EXT_DAT*/
, case when (EXTERNER_PATIENT.STerbedatum is not null and p.Sterbedatum is null) then 'J' else null end as Sterbemeldung
,EXTERNER_PATIENT.STerbedatum 
from 
EXTERNER_PATIENT 
left outer join 
patient  p 
on p.pat_id=EXTERNER_PATIENT.pat_id
or p.PATIENTEN_ID= EXTERNER_PATIENT.PATIENTEN_ID
left outer join TUMOR T on 
T.FK_PATIENTPAT_ID=EXTERNER_PATIENT.pat_id
  and (:FILTERCODE=250 or exists(select 1 from 
    AW_KLASSEN_ALLE b
        where T.ICD10 like b.Like_Kriterium
        and b.klassierung_id=5 
            and b.KLASSIERUNG_QUELLE='UKE'
            and b.KLASSE_CODE=:FILTERCODE))/**/
  left outer join QUALITATIVER_BEFUND qba --Arbeitslisteninfos   
on T.FK_PATIENTPAT_ID=qba.FK_VORHANDENE_DFK
 and T.TUMOR_ID=qba.FK_VORHANDENE_DLFD
and qba.FK_VORHANDENE_DDAT='Diagnose'
and qba.FK_QUALITATIVE_FK=19
left outer join QUALITATIVE_AUSPRAEGUNG qaa
  on qba.Fk_Qualitative_Fk = qaa.Fk_QualitativesID -- Merkmal
            AND qba.Fk_Qualitative_ID = qaa.ID

left outer join (select LISTAGG(ED.Fk_IcdIcd,' | ') WITHIN GROUP (order by ED.Fk_IcdIcd) as Diagnosen_Ext,
    LISTAGG(case when substr(ED.Fk_IcdIcd,1,3) in ('C76','C77','C78','C79','C97') then ED.Fk_IcdIcd
                when ED.Fk_IcdIcd in ('D09.7','D09.9')then ED.Fk_IcdIcd else Null end,' | ') WITHIN GROUP (order by ED.Fk_IcdIcd) Metastasen_EXT,
    ED.Fk_Externe_Patienten_ID   from (select distinct Fk_Externe_Patienten_ID, Fk_IcdIcd from  EXTERNE_DIAGNOSE extd
      WHERE (extd.FK_ICDICD like 'C%' or extd.FK_ICDICD like 'D%'))ED group by ED.Fk_Externe_Patienten_ID )qay on qay.Fk_Externe_Patienten_ID = EXTERNER_PATIENT.Patienten_ID 
  
where 
EXTERNER_PATIENT.HAUPT_VERS_NAME='TUMORPATIENT'
and EXTERNER_PATIENT.Import_Quelle = 'UKE'
AND MONTHS_BETWEEN(SYSDATE, EXTERNER_PATIENT.Geburtsdatum)/12 >= 17.5
and
--Filterbedingung Änderungszeitraum
( 
    
 ( 
  (
    ((qba.TAG_DER_MESSUNG is null or qba.TAG_DER_MESSUNG<EXTERNER_PATIENT.AENDERUNGSDATUM) and EXTERNER_PATIENT.AENDERUNGSDATUM <= :enddatum
      )
  or ((qba.TAG_DER_MESSUNG is null or qba.TAG_DER_MESSUNG<EXTERNER_PATIENT.IMPORT_DATUM) and EXTERNER_PATIENT.IMPORT_DATUM <= :enddatum
      )
  )
  or exists
    (select 1 from EXTERNE_DIAGNOSE ED where ED.FK_EXTERNE_PATIENTEN_ID =EXTERNER_PATIENT.PATIENTEN_ID and ED.IMPORT_QUELLE='UKE' and ED.DATUM <= :enddatum
     and (qba.TAG_DER_MESSUNG is null or qba.TAG_DER_MESSUNG<ED.DATUM) and (ED.STATUS not in ('V','B') or ED.STATUS is null) ) --EIne Externe Diagnose im Zeitraum
  or exists
    (select 1 from EXTERNE_PROZEDUR EP where EP.FK_EXTERNE_PATIENTEN_ID =EXTERNER_PATIENT.PATIENTEN_ID and EP.IMPORT_QUELLE='UKE' and EP.DATUM <= :enddatum
      and (qba.TAG_DER_MESSUNG is null or qba.TAG_DER_MESSUNG<EP.DATUM) and (EP.STATUS not in ('V','B') or EP.STATUS is null)) --EIne Externe Prozedur im Zeitraum
  or exists
    (select 1 from IMPORT_QUALITATIVER_BEFUND IB where IB.PATIENTEN_ID =EXTERNER_PATIENT.PATIENTEN_ID and IB.IMPORT_QUELLE='UKE' and IB.EXTERNE_BEFUNDART_ID='EINWILLIGUNG_KKR' and IB.BEFUND_DATUM <= :enddatum 
      and (qba.TAG_DER_MESSUNG is null or qba.TAG_DER_MESSUNG<IB.BEFUND_DATUM)) --EIne EInwilligung für das KKR im Zeitraum
  or exists
    (select 1 from ABTEILUNG_PATIENT_BEZIEHUNG AB where AB.FK_EXTERNE_PATIENTEN_ID =EXTERNER_PATIENT.PATIENTEN_ID and AB.IMPORT_QUELLE='UKE'
      and (qba.TAG_DER_MESSUNG is null or qba.TAG_DER_MESSUNG<AB.BEGINN) and AB.BEGINN<= :enddatum) --Einen aktuellen Aufenthalt
)

or p.PAT_ID is null
)
---Filterbedingung für Entität
AND ( :FILTERCODE=250 --Restefilter wird so ausgeschlossen 
      or
      :FILTERCODE=140 --Metastasenfilter wird so ausgeschlossen 
      or
      EXISTS (
              SELECT 1 FROM EXTERNE_DIAGNOSE ED
              inner join 
               AW_KLASSEN_ALLE b
               on ED.FK_ICDICD like b.Like_Kriterium
               WHERE ED.Fk_Externe_Patienten_ID = EXTERNER_PATIENT.Patienten_ID
              and b.klassierung_id=5 
              and b.KLASSIERUNG_QUELLE='UKE'
              and b.KLASSE_CODE=:FILTERCODE  and (ED.STATUS not in ('V','B') or ED.STATUS is null)
              ) --STATUS dient dem aussortieren unerwünschter / falscher Diagnosen
       )
  
--FIlterbedingung Primärfall
and (exists
  (
     (select 1 FROM QUALITATIVER_BEFUND qb 
          WHERE 
          T.TUMOR_ID=qb.FK_VORHANDENE_DLFD
          and T.FK_PATIENTPAT_ID=qb.FK_VORHANDENE_DFK
            AND qb.Fk_Qualitative_Fk = 28          -- Merkmal ist Primärfall
            and qb.FK_QUALITATIVE_ID=:primfall
            AND qb.Fk_Vorhandene_DDAT = 'Diagnose' )
  ) or nvl(:primfall,0)=0
)
and (EXTRACT(YEAR FROM t.DIAGNOSEDATUM) = :gtdsdiagjahr or nvl(:gtdsdiagjahr,0)=0)

--Filterbedingung Rest
and (
  :FILTERCODE<>250
 or (
      (-- Filterung anhand des Ausschlusses aller anderen DIagnosen
      
      (qba.Fk_Qualitative_ID is null or qba.Fk_Qualitative_ID in (1,2,3,10))
      and
      not EXISTS ( -- Alle ICD Codes der anderen Filter ausser der Generelle "Alles"-Filter (240) werden ausgeschlossen
      SELECT 1 FROM EXTERNE_DIAGNOSE ED
      inner join 
       AW_KLASSEN_ALLE b
       on ED.FK_ICDICD like b.Like_Kriterium
       WHERE ED.Fk_Externe_Patienten_ID = EXTERNER_PATIENT.Patienten_ID
      and b.klassierung_id=5 
      and b.KLASSIERUNG_QUELLE='UKE'
      and (b.KLASSE_CODE<>240 --Code für alle C und D-Diagnosen
          and b.KLASSE_CODE<>250) --Code für SST-Rest
                 )
      and
     exists (
            SELECT Fk_Externe_Patienten_ID
             FROM ABTEILUNG_PATIENT_BEZIEHUNG ABP1
             WHERE ABP1.Fk_Externe_Patienten_ID = EXTERNER_PATIENT.Patienten_ID
             AND ABP1.Fk_AbteilungAbteil  IN ('12973','8975','8977','8982','21602','21626'
             --,'26775','267750' -- STrahlenambulanz
             --,'26780','267800' -- AZ Derm
             --,'266910','126148','266710','266730','266920','26672'--Martiniklinik
             )
            ) 
        )
       or
        (--Filterung des Sonderfalls, wenn keine externe diagnose vorhanden ist und der Patien schon im GTDS vorhanden
        p.PAT_ID is not null and not exists ( SELECT 1 FROM EXTERNE_DIAGNOSE ED
                                      WHERE ED.Fk_Externe_Patienten_ID = EXTERNER_PATIENT.Patienten_ID)
                                      and (qba.Fk_Qualitative_ID is null or qba.Fk_Qualitative_ID in (1,2,3,10))  -- Arbeitsliste soll keinem Dokumentar zugeordnet sein
        )
    )
  )
--Filterbedingung Metastasen
and (
  :FILTERCODE<>140
 or (
      not EXISTS ( --- Alle ICD Codes der anderen Filter aus der Generelle "Alles"-Filter (240) werden ausgeschlossen
      SELECT 1 FROM EXTERNE_DIAGNOSE ED
      inner join 
       AW_KLASSEN_ALLE b
       on ED.FK_ICDICD like b.Like_Kriterium
       WHERE ED.Fk_Externe_Patienten_ID = EXTERNER_PATIENT.Patienten_ID
      and b.klassierung_id=5 
      and b.KLASSIERUNG_QUELLE='UKE'
      and (b.KLASSE_CODE<>240 --Code für alle C und D-Diagnosen
          and b.KLASSE_CODE<>250 and b.KLASSE_CODE <>:FILTERCODE) --Code für SST-Rest
                      )
                   --   and p.PATIENTEN_ID=EXTERNER_PATIENT.PATIENTEN_ID
                      
      and EXISTS (  -- Alle Metastasencodes werden eingeschlossen
              SELECT 1 FROM EXTERNE_DIAGNOSE ED
              inner join 
               AW_KLASSEN_ALLE b
               on ED.FK_ICDICD like b.Like_Kriterium
               WHERE ED.Fk_Externe_Patienten_ID = EXTERNER_PATIENT.Patienten_ID
              and b.klassierung_id=5 
              and b.KLASSIERUNG_QUELLE='UKE'
              and b.KLASSE_CODE=:FILTERCODE  and (ED.STATUS not in ('V','B') or ED.STATUS is null)
              )
      )
)
--Filterbedingung Prostata Martiniklinik
and (
 :FILTERCODE <>200
 or (
 ( (EXTERNER_PATIENT.AENDERUNGSDATUM is null and EXTERNER_PATIENT.IMPORT_DATUM>'01.01.2018') or EXTERNER_PATIENT.AENDERUNGSDATUM>'01.01.2018') -- Nur Patienten ab 01.01.2018
 and
 EXISTS(
    SELECT 1
    FROM ABTEILUNG_PATIENT_BEZIEHUNG ABP1
    WHERE ABP1.Fk_Externe_Patienten_ID = EXTERNER_PATIENT.Patienten_ID
    AND ABP1.Fk_AbteilungAbteil not IN ('266910','26691','266920','26692','126148','266710','26671','266730','26673','267750','26775','26672')

    )
 and not exists( -- Patienten die in der Martiniklinik einen Aufenthalt hatten und zudem nur (!) in der Abt. UR KERN
    SELECT 1
     FROM ABTEILUNG_PATIENT_BEZIEHUNG ABP1
     WHERE ABP1.Fk_Externe_Patienten_ID = EXTERNER_PATIENT.Patienten_ID
     AND ABP1.Fk_AbteilungAbteil IN ('266910','26691','266920','26692','126148','266710','26671','266730','26673','26672')
       and exists  (select 1 from ABTEILUNG_PATIENT_BEZIEHUNG ABP2 where ABP1.Fk_Externe_Patienten_ID=ABP2.Fk_Externe_Patienten_ID 
                      and ABP2.Fk_AbteilungAbteil  = '25971' --UR Kern
                      )
       and not exists  (select 1 from ABTEILUNG_PATIENT_BEZIEHUNG ABP3 where ABP1.Fk_Externe_Patienten_ID=ABP3.Fk_Externe_Patienten_ID 
                      and ABP3.Fk_AbteilungAbteil not IN ('266910','26691','266920','26692','126148','266710','26671','266730','26673','25971','26672')
                      )               
  )
 
 )
)

--Filterbedingung Prostata nur in Abteilungen der Onko
and (
 :FILTERCODE <>270
 or (
 ( (EXTERNER_PATIENT.AENDERUNGSDATUM is null and EXTERNER_PATIENT.IMPORT_DATUM>'01.01.2018') or EXTERNER_PATIENT.AENDERUNGSDATUM>'01.01.2018') -- Nur Patienten ab 01.01.2018
 and
 EXISTS(
    SELECT 1
    FROM ABTEILUNG_PATIENT_BEZIEHUNG ABP1
    WHERE ABP1.Fk_Externe_Patienten_ID = EXTERNER_PATIENT.Patienten_ID
    AND ABP1.Fk_AbteilungAbteil IN ('8975','12973','8982','14972')

    )

 
 )
)
--Filterbedingung Melanome nur in Abteilungen der Hautklinik /Ambulanz
and (
 :FILTERCODE <>290
 or(
 /* ( (EXTERNER_PATIENT.AENDERUNGSDATUM is null and EXTERNER_PATIENT.IMPORT_DATUM>'01.01.2018') or EXTERNER_PATIENT.AENDERUNGSDATUM>'01.01.2018') -- Nur Patienten ab 01.01.2018
 and*/
 EXISTS(
    SELECT 1
    FROM ABTEILUNG_PATIENT_BEZIEHUNG ABP1
    WHERE ABP1.Fk_Externe_Patienten_ID = EXTERNER_PATIENT.Patienten_ID
    AND ABP1.Fk_AbteilungAbteil IN ('5971','267800 ','26780')

    )

 
 )
)

;
