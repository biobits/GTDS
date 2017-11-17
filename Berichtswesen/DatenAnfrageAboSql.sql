/*
Übermittlungsoptionen: 	An, Cc, Bcc, Antwort an, Bericht einschließen, Renderformat, Priorität, Betreff, Kommentar, Link einschließen,
Berichtsparameter: 	FULLNAME_ARZT, testlauf, startdatum, enddatum, benutzer
*/
select distinct
 a.EMAIL as An, 
case when a.EMAIL='k.prieske@uke.de' then 'k.steffens@uke.de'
  when a.EMAIL='mrink@uke.de' then 'ch.meyer@uke.de'
  else null end  as Cc, 
'krebsregister@uke.de' as Bcc, 
'krebsregister@uke.de' as "Antwort an", 
'True' as "Bericht einschließen", 
'WORD' as Renderformat, 
'normal' as Priorität, 
'Datenanfrage Klinisches Krebsregister' as Betreff, 
'<div style="font-family: "Calibri", sans-serif; color:#333333; font-size:11px;"><br/>'||case when UPPER(a.ANSPRECH_GESCHLECHT)='W' then 'Sehr geehrte Frau ' else 'Sehr geehrter Herr ' end ||RPAD(TRIM(a.ANSPRECH_TITEL), LENGTH(TRIM(a.ANSPRECH_TITEL))+1, ' ')||a.ANSPRECH_NAME||',<br/><br/>anbei finden Sie die aktuellen Fragen zu Ihren Behandlungsfällen, die wir anhand der Patientenakte nicht klären können. Bitte verteilen Sie diese ggf. auf Ihr Team oder „benachbarte“ Abteilungen,
damit wir schnellstmöglich eine Rückantwort erhalten. Vielen Dank.<br/>Bei Fragen stehen wir Ihnen gerne zur Verfügung.<br/><br/>Mit freundlichen Grüßen<br/><br/>Ihr Team des Klinischen Krebsregisters am UKE
<br/><br/><br/><br/><b><span style="color: rgb(0, 82, 155);">Universitätsklinikum Hamburg-Eppendorf</span></b><br/>Klinisches Krebsregister<br/><br/>Martinistraße 52<br/>Gebäude West 37<br/>20246 Hamburg<br/>
Fax: +49 (0)040 7410-57934<br/>krebsregister@uke.de<br/>www.uke.de</div>' as Kommentar, 
'False' as "Link einschließen",
a.ANSPRECH_NAME ||', '||a.ANSPRECH_VORNAME as FULLNAME_ARZT,
1 as testlauf, 
trunc(to_date('01.01.17')) as startdatum, 
to_char(sysdate,'dd.MM.RR')  as enddatum,--trunc(to_date(sysdate,'dd.MM.RR')) as enddatum,
'BARTELS' as benutzer
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
        and qb.FK_QUALITATIVE_ID =1 -- Qualitative_AUspraegung
        and trunc(qb.TAG_DER_MESSUNG) between trunc(to_date('01.01.2017')) and trunc(SYSDATE) 
        )

;


