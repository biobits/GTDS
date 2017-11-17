/*
‹bermittlungsoptionen: 	An, Cc, Bcc, Antwort an, Bericht einschlieﬂen, Renderformat, Priorit‰t, Betreff, Kommentar, Link einschlieﬂen,
Berichtsparameter: 	FULLNAME_ARZT, benutzer, testlauf, P_EINNERUNGSTICHTAG, P_ABSCHLUSSSTICHTAG
*/
select distinct
 a.EMAIL as An, 
case when a.EMAIL='k.prieske@uke.de' then 'k.steffens@uke.de'
  when a.EMAIL='mrink@uke.de' then 'ch.meyer@uke.de'
  else null end  as Cc, 
'krebsregister@uke.de' as Bcc, 
'krebsregister@uke.de' as "Antwort an", 
'True' as "Bericht einschlieﬂen", 
'Word' as Renderformat, 
'normal' as Priorit‰t, 
'Datenanfrage Klinisches Krebsregister - Erinnerung' as Betreff, 
'<div style="font-family: "Calibri", sans-serif; color:#333333; font-size:11px;"><br/>'||case when UPPER(a.ANSPRECH_GESCHLECHT)='W' then 'Sehr geehrte Frau ' else 'Sehr geehrter Herr ' end ||RPAD(TRIM(a.ANSPRECH_TITEL), LENGTH(TRIM(a.ANSPRECH_TITEL))+1, ' ')||a.ANSPRECH_NAME||',<br/>anbei finden Sie <span style="text-decoration:underline;">Erinnerungen</span> zu Ihren Behandlungsf‰llen, die leider bis heute nicht bei uns eingegangen sind. Wir bitten erneut um schnellstmˆgliche Bearbeitung und w¸rden die F‰lle nach einer weiteren Frist von zwei Wochen abschlieﬂen.<br/>Mit freundlichen Gr¸ﬂen<br/><br/>Ihr Team des Klinischen Krebsregisters am UKE
<br/><br/><br/><br/><b><span style="color: rgb(0, 82, 155);">Universit‰tsklinikum Hamburg-Eppendorf</span></b><br/>Klinisches Krebsregister<br/><br/>Martinistraﬂe 52<br/>Geb‰ude West 37<br/>20246 Hamburg<br/>
Fax: +49 (0)040 7410-57934<br/>krebsregister@uke.de<br/>www.uke.de</div>' as Kommentar, 
'False' as "Link einschlieﬂen",
a.ANSPRECH_NAME ||', '||a.ANSPRECH_VORNAME as FULLNAME_ARZT,
1 as testlauf, 
to_char(sysdate-14,'dd.MM.RR') as EINNERUNGSTICHTAG, 
to_char(sysdate-28,'dd.MM.RR')  as ABSCHLUSSSTICHTAG,
'BARTELS' as benutzer
,a.ANSPRECH_TITEL,a.ANSPRECH_GESCHLECHT,a.EMAIL
,case when a.EMAIL='k.prieske@uke.de' then 'k.steffens@uke.de'
  when a.EMAIL='mrink@uke.de' then 'ch.meyer@uke.de'
  else null end as EMAIL2
from ABteilung a
where a.ANSPRECH_NAME is not null
and a.EMAIL is not null

and exists
(select 1 from
      VORHANDENE_DATEN V
      inner join
      QUALITATIVER_BEFUND qb
        on qb.FK_VORHANDENE_DDAT=V.DATENART
        and V.LFDNR=qb.FK_VORHANDENE_DLFD
        and V.FK_PATIENTPAT_ID=qb.FK_VORHANDENE_DFK
        inner join ABTEILUNG Ab
        on ab.ABTEILUNG_ID=V.FK_ABTEILUNG_ID
        where ab.ABTEILUNG_ID=a.ABTEILUNG_ID
        and qb.FK_QUALITATIVE_FK = 79--Qualitatives_MErkmal Aktenbeurteilung
        and qb.FK_QUALITATIVE_ID =2 -- Qualitative_AUspraegung
        and trunc(qb.TAG_DER_MESSUNG) <= trunc(to_date(sysdate-14)) 
        )

;


