select distinct
--Bericht
qb.FK_VORHANDENE_DFK as PAT_ID,v.TUMOR_ID,qb.FK_VORHANDENE_DLFD as  DOKUMENTLFDNR,qb.FK_VORHANDENE_DDAT as DATENART,b.DATUM as Anfrage_Datum,extract(YEAR from b.Datum) as Anfrage_Jahr,
--(extract(YEAR from b.Datum)||'_'||extract(QUARTER from b.Datum) )as Anfrage_QuartalJahr,
to_char(b.Datum,'YYYY_Q')as Anfrage_QuartalJahr,
to_char(b.Datum,'YYYY_MM')as Anfrage_MonatJahr,
extract(MONTH from b.Datum) as Anfrage_Monat
,b.ART_DES_BRIEFES,
 --Anfrage
 qb.TAG_DER_MESSUNG ,qa.ID as Auspraegung_Id,qa.AUSPRAEGUNG,qa.BESCHREIBUNG,qb.BEMERKUNG,
 case when qa.ID =1 then 1 else 0 end as Anfrage_Offen,
 case when qa.ID>1 then 1 else 0 end as Anfrage_InProzess,
 case when qa.ID =2 then 1 else 0 end as Anfrage_Verschickt,
 case when qa.ID =4 then 1 else 0 end as Anfrage_Erinnert,
 case when qa.ID in (4,2) then 1 else 0 end as Anfrage_bei_Arzt,
 case when qa.ID =3 then 1 else 0 end as Anfrage_Erledigt,
  case when qa.ID =5 then 1 else 0 end as Anfrage_Unvoll_Erledigt,
  case when qa.ID in (3,5) then 1 else 0 end as Anfrage_Abgeschlossen,
 qb.ERSTELLUNGSDATUM as Erstellung_Merkmal,qb.FK_BENUTZERBENUTZE
 --Abteilung
 ,ab.ABTEILUNG,ab.ABTEILUNG_ID,ab.ANSPRECH_NAME,ab.ANSPRECH_NAME ||', '||ab.ANSPRECH_VORNAME as FULLNAME_ARZT,
 --Calculations
 case when qa.ID=3 then TO_DATE(qb.TAG_DER_MESSUNG)-TO_DATE(qb.ERSTELLUNGSDATUM) else null end as Tage_Erstellung_bis_Erledigt,
 1 as ANZ
from QUALITATIVER_BEFUND qb
left outer join Berichte b
on qb.FK_VORHANDENE_DDAT=b.DATENART
and qb.FK_VORHANDENE_DFK=b.PAT_ID
and qb.FK_VORHANDENE_DLFD=b.DOKUMENTLFDNR
and qb.FK_QUALITATIVE_FK=79
and (b.ART_DES_BRIEFES='UKE_KKR_Datenanfrage' or b.ART_DES_BRIEFES='UKE_KKR_Datenanfrage_Erinnerung')
inner join QUALITATIVE_AUSPRAEGUNG qa
on qa.ID=qb.FK_QUALITATIVE_ID
and qa.FK_QUALITATIVESID=qb.FK_QUALITATIVE_FK
inner join VORHANDENE_DATEN v
on v.DATENART=qb.FK_VORHANDENE_DDAT
and v.FK_PATIENTPAT_ID=qb.FK_VORHANDENE_DFK
--and v.TUMOR_ID=b.TUMOR_ID
and v.LFDNR=qb.FK_VORHANDENE_DLFD
inner join ABTEILUNG ab
on ab.ABTEILUNG_ID=v.FK_ABTEILUNG_ID

where 
 qb.FK_QUALITATIVE_FK=79
-- order by b.DATUM desc;
--order by qb.FK_VORHANDENE_DFK desc;