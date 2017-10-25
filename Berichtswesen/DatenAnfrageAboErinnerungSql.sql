/*
Übermittlungsoptionen: 	An, Cc, Bcc, Antwort an, Bericht einschließen, Renderformat, Priorität, Betreff, Kommentar, Link einschließen,
Berichtsparameter: 	FULLNAME_ARZT, benutzer, testlauf, P_EINNERUNGSTICHTAG, P_ABSCHLUSSSTICHTAG
*/
select distinct
'st.bartels@uke.de' as An, 
NULL as Cc, 
NULL as Bcc, 
'krebsregister@uke.de' as "Antwort an", 
'True' as "Bericht einschließen", 
'Word' as Renderformat, 
'normal' as Priorität, 
'Test Fr. Schlüter: Datenanfrage Klinisches Krebsregister an '||a.ANSPRECH_NAME ||', '||a.ANSPRECH_VORNAME as Betreff, 
'<div style="font-family: "Calibri", sans-serif; color:#333333; font-size:11px;"><br/>Sehr geehrte Damen und Herren,<br/>anbei finden Sie <span style="text-decoration:underline;">Erinnerungen</span> zu Ihren Behandlungsfällen, die leider bis heute nicht bei uns eingegangen sind. Wir bitten erneut um schnellstmögliche Bearbeitung und würden die Fälle nach einer weiteren Frist von zwei Wochen abschließen.<br/>Mit freundlichen Grüßen<br/><br/>Ihr Team des Klinischen Krebsregisters am UKE
<br/><br/><br/><br/><b><span style="color: rgb(0, 82, 155);">Universitätsklinikum Hamburg-Eppendorf</span></b><br/>Klinisches Krebsregister<br/><br/>Martinistraße 52<br/>Gebäude West 37<br/>20246 Hamburg<br/>
Fax: +49 (0)040 7410-57934<br/>krebsregister@uke.de<br/>www.uke.de</div>' as Kommentar, 
'False' as "Link einschließen",
a.ANSPRECH_NAME ||', '||a.ANSPRECH_VORNAME as FULLNAME_ARZT,
1 as testlauf, 
to_char(sysdate-14,'dd.MM.RR') as EINNERUNGSTICHTAG, 
to_char(sysdate-28,'dd.MM.RR')  as ABSCHLUSSSTICHTAG,
'BARTELS' as benutzer
,a.ANSPRECH_TITEL,a.ANSPRECH_GESCHLECHT--,a.EMAIL
from ABteilung a
where a.ANSPRECH_NAME is not null
and a.EMAIL is not null
and a.ANSPRECH_NAME like 'P%'
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


