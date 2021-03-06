create or replace PROCEDURE UKE_SP_BERICHT_NACHFRAGE 
(
  P_FULLNAME_ARZT IN VARCHAR2 ,
  P_IS_TEST in NUMBER ,--default TRUE,
  P_BERICHTSNAME varchar2,
  P_BENUTZER varchar2,
  P_STARTDATUM IN DATE,
  P_ENDDATUM IN DATE,
  P_RESULTSET OUT SYS_REFCURSOR
) AS 
   type r_indiv is record(
    P_UKE_ID          PATIENT.PATIENTEN_ID%TYPE ,
    P_GTDS_ID         VORHANDENE_DATEN.FK_PATIENTPAT_ID%TYPE ,
    P_GEBURTSDATUM    PATIENT.GEBURTSDATUM%TYPE ,
    P_NAME            PATIENT.NAME%TYPE,
    P_VORNAME         PATIENT.VORNAME%TYPE,
    P_TUMOR_ID        VORHANDENE_DATEN.TUMOR_ID%TYPE ,
    P_DATENART        VORHANDENE_DATEN.DATENART%TYPE ,
    P_LFDNR           VORHANDENE_DATEN.LFDNR%TYPE,
    P_DATUM_DOKUMENT  VORHANDENE_DATEN.DATUM%TYPE ,
    P_TAG_DER_MESSUNG QUALITATIVER_BEFUND.TAG_DER_MESSUNG%TYPE , 
    P_BEMERKUNG       QUALITATIVER_BEFUND.BEMERKUNG%TYPE ,
    P_ABTEILUNG       ABTEILUNG.ABTEILUNG%TYPE ,
    P_KUERZEL         ABTEILUNG.KUERZEL%TYPE ,
    P_ANSPRECH_NAME   ABTEILUNG.ANSPRECH_NAME%TYPE ,
    P_ANSPRECH_VORNAME ABTEILUNG.ANSPRECH_VORNAME%TYPE,
    P_ANSPRECH_TITEL  ABTEILUNG.ANSPRECH_TITEL%TYPE,
    P_ANSPRECH_GESCHLECHT ABTEILUNG.ANSPRECH_GESCHLECHT%TYPE,
    P_DIAGNOSEDATUM   AUSWERTUNG_UCCH.DIAGNOSEDATUM%TYPE ,
    P_DIAGNOSETEXT    AUSWERTUNG_UCCH.DIAGNOSETEXT%TYPE ,
    P_ICD10           AUSWERTUNG_UCCH.ICD10%TYPE ,	
    P_ENTITAET        Tumor_Entitaet.Bezeichnung%TYPE ,
    P_BESCHREIBUNG    VORHANDENE_DATEN.BESCHREIBUNG%TYPE ,
    P_DOKUMENTAR      varchar2(30),
    P_DOK_NAME            BENUTZER.NAME%TYPE,
    P_DOK_VORNAME         BENUTZER.VORNAME%TYPE,
    P_TELEFON         BENUTZER.TELEFON%TYPE,
    P_EMAIL           BENUTZER.EMAIL%TYPE,
    P_TITEL           BENUTZER.TITEL%TYPE  );
    p_indiv r_indiv;
    p_intrec SYS_REFCURSOR;
    p_num number; --Zum testen
BEGIN



UKE_SP_GET_NACHFRAGE_DATA(P_FULLNAME_ARZT => P_FULLNAME_ARZT,
                      P_STARTDATUM => P_STARTDATUM ,
                      P_ENDDATUM => P_ENDDATUM  ,
                      P_NACHFRAGEDATEN => P_RESULTSET);
if (P_IS_TEST=0) then
  --BEGIN
    UKE_SP_GET_NACHFRAGE_DATA(P_FULLNAME_ARZT => P_FULLNAME_ARZT,
                      P_STARTDATUM => P_STARTDATUM ,
                      P_ENDDATUM => P_ENDDATUM  ,
                      P_NACHFRAGEDATEN => p_intrec);
    LOOP
      FETCH p_intrec into p_indiv;
      exit when p_intrec%NOTFOUND;
        
        --Erstellung des Berichst in Tabelle BERICHT loggen
        UKE_SP_INSERT_BERICHT(p_indiv.P_GTDS_ID, p_indiv.P_TUMOR_ID,P_BERICHTSNAME,p_indiv.P_DATENART,p_indiv.P_LFDNR,P_BENUTZER,'UKE');   
        -- Erstellung des Berichts in Tabelle UKE_EVENT_LOG loggen
          UKE_SP_INSERT_EVENT(p_indiv.P_GTDS_ID,p_indiv.P_TUMOR_ID,p_indiv.P_DATENART,p_indiv.P_LFDNR,SYSDATE,'BERICHTE',
                              'UKE_'||P_BERICHTSNAME,'erstellt',NULL,'Startdatum: ' ||P_STARTDATUM||'|'|| 'Enddatum: ' ||P_ENDDATUM,P_BENUTZER);
        --Update Qualitativer Befund Merkmal "ANfrage" auf Status "Verschickt" setzen
        update QUALITATIVER_BEFUND
        set FK_QUALITATIVE_ID=2,TAG_DER_MESSUNG=SYSDATE,FK_BENUTZERBENUTZE=P_BENUTZER
        where FK_VORHANDENE_DFK=p_indiv.P_GTDS_ID and 
        FK_VORHANDENE_DLFD=p_indiv.P_LFDNR and
        FK_VORHANDENE_DDAT=p_indiv.P_DATENART
        and FK_QUALITATIVE_FK=79;
        -- Logging der Merkmalsänderung in Event-Tabelle
      UKE_SP_INSERT_EVENT(p_indiv.P_GTDS_ID,p_indiv.P_TUMOR_ID,p_indiv.P_DATENART,p_indiv.P_LFDNR,SYSDATE,'MERKMAL',
                              'Anfrage','update','verschickt',p_indiv.P_ANSPRECH_NAME||', '||p_indiv.P_ANSPRECH_VORNAME||'|'||p_indiv.P_KUERZEL||'|'||
                               'Startdatum: ' ||P_STARTDATUM||'|'|| 'Enddatum: ' ||P_ENDDATUM ,P_BENUTZER);
       -- p_num:=1;
    END LOOP;
    commit;
  --END;
end if;

--27734, 25051
--CLOSE p_recordset;


END UKE_SP_BERICHT_NACHFRAGE;