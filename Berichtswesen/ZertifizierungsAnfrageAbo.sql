select distinct
'stefan.bartels@uke.de' as An, 
-- a.EMAIL as An,
NULL as Cc, 
'krebsregister@uke.de' as Bcc, 
'krebsregister@uke.de' as "Antwort an", 
'True' as "Bericht einschließen", 
'Word' as Renderformat, 
'normal' as Priorität, 
'Datenanfrage zur Zertifizierung - Klinisches Krebsregister ' as Betreff, 
'<div style="font-family: "Calibri", sans-serif; color:#333333; font-size:11px;"><br/>'||case when UPPER(a.ANSPRECH_GESCHLECHT)='W' then 'Sehr geehrte Frau ' else 'Sehr geehrter Herr ' end ||RPAD(TRIM(a.ANSPRECH_TITEL), LENGTH(TRIM(a.ANSPRECH_TITEL))+1, ' ')||a.ANSPRECH_NAME||',<br/>anbei finden Sie Datenanfragen zu zertifizierungsrelevanten med. Parametern Ihrer Behandlungsfälle, die wir anhand der Patientenakte nicht klären können. Wir möchten Sie um eine zeitnahe Bearbeitung der Anfrage bitten.<br/> Vielen Dank.<br/>Bei Fragen stehen wir Ihnen gerne zur Verfügung.<br/><br/>Mit freundlichen Grüßen<br/><br/>Ihr Team des Klinischen Krebsregisters am UKE
<br/><br/><br/><br/><b><span style="color: rgb(0, 82, 155);">Universitätsklinikum Hamburg-Eppendorf</span></b><br/>Klinisches Krebsregister<br/><br/>Martinistraße 52<br/>Gebäude West 37<br/>20246 Hamburg<br/>
Fax: +49 (0)040 7410-57934<br/>krebsregister@uke.de<br/>www.uke.de</div>' as Kommentar, 
'False' as "Link einschließen",
a.ANSPRECH_NAME ||', '||a.ANSPRECH_VORNAME as FULLNAME_ARZT,
1 as testlauf, 
to_char(sysdate,'dd.MM.RR') as ErstAnfrageSTICHTAG, 
to_char(sysdate-14,'dd.MM.RR') as EINNERUNGSTICHTAG, 
to_char(sysdate-28,'dd.MM.RR')  as ABSCHLUSSSTICHTAG,
'BARTELS' as benutzer
,a.ANSPRECH_TITEL,a.ANSPRECH_GESCHLECHT,a.EMAIL
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
        and qb.FK_QUALITATIVE_FK = 84--
        and qb.FK_QUALITATIVE_ID in (1,2) -- 
        --and trunc(qb.TAG_DER_MESSUNG) <= trunc(to_date(sysdate-14)) 
        and trunc(qb.TAG_DER_MESSUNG) <= trunc(to_date(sysdate)) 
        );