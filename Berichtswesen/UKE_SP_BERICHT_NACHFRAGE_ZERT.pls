create or replace PROCEDURE UKE_SP_BERICHT_NACHFRAGE_ZERT
(
  P_FULLNAME_ARZT IN VARCHAR2 ,
  P_IS_TEST in NUMBER ,--default TRUE,
  P_BERICHTSNAME varchar2,
  P_BENUTZER varchar2,
  P_ERSTANFRAGESTICHTAG IN DATE , -- f�r alle mit Status "offen" �lter / gleich datum
  P_VERSCHICKTSTICHTAG IN DATE , -- f�r alle mit Status 'VerschickT' �lter /gleich Datum
  P_ABSCHLUSSSTICHTAG IN DATE, -- f�r alle mit Status 'Erinnerung' �lter /gleich Datum
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
    P_FK_QUALITATIVE_ID QUALITATIVER_BEFUND.FK_QUALITATIVE_ID%TYPE,
    P_TAG_DER_MESSUNG QUALITATIVER_BEFUND.TAG_DER_MESSUNG%TYPE , 
    P_BEMERKUNG       QUALITATIVER_BEFUND.BEMERKUNG%TYPE ,
    P_AUSPRAEGUNG     QUALITATIVE_AUSPRAEGUNG.AUSPRAEGUNG%TYPE,
    P_AUSPRAEGUNG_TEXT  QUALITATIVE_AUSPRAEGUNG.BESCHREIBUNG%TYPE,
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
    p_indiv2 r_indiv;
    p_intrec SYS_REFCURSOR;
    p_enddata SYS_REFCURSOR;
    --p_num number; --Zum testen
BEGIN



UKE_SP_GET_NACHFRAGE_ZERT_DATA(P_FULLNAME_ARZT => P_FULLNAME_ARZT,
                      P_ERSTANFRAGESTICHTAG =>P_ERSTANFRAGESTICHTAG,
                      P_VERSCHICKTSTICHTAG=>P_VERSCHICKTSTICHTAG,
                      P_ABSCHLUSSSTICHTAG =>NULL,
                      P_NACHFRAGEDATEN => P_RESULTSET);
if (P_IS_TEST=0) then
  --BEGIN
    UKE_SP_GET_NACHFRAGE_ZERT_DATA(P_FULLNAME_ARZT => P_FULLNAME_ARZT,
                      P_ERSTANFRAGESTICHTAG =>P_ERSTANFRAGESTICHTAG,
                      P_VERSCHICKTSTICHTAG=>P_VERSCHICKTSTICHTAG,
                      P_ABSCHLUSSSTICHTAG =>P_ABSCHLUSSSTICHTAG ,
                      P_NACHFRAGEDATEN => p_intrec);
    LOOP
      FETCH p_intrec into p_indiv;
      exit when p_intrec%NOTFOUND;
        
        --Erstellung des Berichst in Tabelle BERICHT loggen (nur f�r offene und verschickte)
        if p_indiv.P_FK_QUALITATIVE_ID in (1,2) then
          UKE_SP_INSERT_BERICHT(p_indiv.P_GTDS_ID, p_indiv.P_TUMOR_ID,P_BERICHTSNAME,p_indiv.P_DATENART,p_indiv.P_LFDNR,P_BENUTZER,'UKE');   
          -- Erstellung des Berichts in Tabelle UKE_EVENT_LOG loggen
          UKE_SP_INSERT_EVENT(p_indiv.P_GTDS_ID,p_indiv.P_TUMOR_ID,p_indiv.P_DATENART,p_indiv.P_LFDNR,SYSDATE,'BERICHTE',
                              'UKE_'||P_BERICHTSNAME,'erstellt',NULL,'Erstanfrage: ' ||P_ERSTANFRAGESTICHTAG||'|'|| 'Erinnerung: ' ||P_VERSCHICKTSTICHTAG||'|'||'Abschluss: ' ||P_ABSCHLUSSSTICHTAG,P_BENUTZER);
        end if;
        --Update Qualitativer Befund Merkmal "ANfrage  Zertifizierung" auf Status "verschickt (2)" sowie "Erinnerung (4)"
        -- und "unvollst�ndig erledigt(5)" setzen 
        update QUALITATIVER_BEFUND
        set FK_QUALITATIVE_ID=case when p_indiv.P_FK_QUALITATIVE_ID =1 then 2 -- "offen" wird auf "Verschickt" gesetzt
                                    when  p_indiv.P_FK_QUALITATIVE_ID =2 then 4 --"verschickt" wird auf "Erinnerung" gesetzt
                                    when  p_indiv.P_FK_QUALITATIVE_ID =4 then 5 --"Erinnerung" wird auf "unvollst�ndig erledigt" gesetzt
                                    end
            ,TAG_DER_MESSUNG=SYSDATE,FK_BENUTZERBENUTZE=P_BENUTZER
            where FK_VORHANDENE_DFK=p_indiv.P_GTDS_ID and 
            FK_VORHANDENE_DLFD=p_indiv.P_LFDNR and
            FK_VORHANDENE_DDAT=p_indiv.P_DATENART
            and FK_QUALITATIVE_FK=84;
      -- Logging der Merkmals�nderung in Event-Tabelle
      UKE_SP_INSERT_EVENT(p_indiv.P_GTDS_ID,p_indiv.P_TUMOR_ID,p_indiv.P_DATENART,p_indiv.P_LFDNR,SYSDATE,'MERKMAL',
                              'Anfrage Zertifizierung','update',case when p_indiv.P_FK_QUALITATIVE_ID =1 then 'verschickt' -- "offen" wird auf "Verschickt" gesetzt
                                    when  p_indiv.P_FK_QUALITATIVE_ID =2 then 'Erinnerung' --"verschickt" wird auf "Erinnerung" gesetzt
                                    when  p_indiv.P_FK_QUALITATIVE_ID =4 then 'unvollst�ndig erledigt' --"Erinnerung" wird auf "unvollst�ndig erledigt" gesetzt
                                    end,p_indiv.P_ANSPRECH_NAME||', '||p_indiv.P_ANSPRECH_VORNAME||'|'||p_indiv.P_KUERZEL||'|'||
                               'Stichtag: '||case when p_indiv.P_FK_QUALITATIVE_ID =1 then P_ERSTANFRAGESTICHTAG
                                    when  p_indiv.P_FK_QUALITATIVE_ID =2 then P_VERSCHICKTSTICHTAG
                                    when  p_indiv.P_FK_QUALITATIVE_ID =4 then P_ABSCHLUSSSTICHTAG end         ,P_BENUTZER);
       -- p_num:=1;
    END LOOP;
    
    -- Update der bisher noch nicht beantworteten Erinnerungs-Daten auf Status "unvollst�ndig erledigt
--    UKE_SP_GET_NACHFRAGE_ZERT_DATA(P_FULLNAME_ARZT => P_FULLNAME_ARZT,
--                      P_EINNERUNGSTICHTAG =>P_ABSCHLUSSSTICHTAG,
--                      P_STATUSID=>4,
--                      P_NACHFRAGEDATEN =>  p_enddata);
--    LOOP
--      FETCH p_enddata into p_indiv2;
--      exit when p_enddata%NOTFOUND;
--        
--        --Update Qualitativer Befund Merkmal "ANfrage" auf Status "unvollst�ndig erledigt" setzen
--        -- Das muss hier in eine seperate abfrage ausgelagert werden, da die UKE_SP_GET_NACHFRAGE_ZERT_DATA Prozedur
--        -- nur f�r die Daten des Berichts zust�ndig ist
--        update QUALITATIVER_BEFUND
--        set FK_QUALITATIVE_ID=5,TAG_DER_MESSUNG=SYSDATE,FK_BENUTZERBENUTZE=P_BENUTZER
--        where FK_VORHANDENE_DFK=p_indiv2.P_GTDS_ID and 
--        FK_VORHANDENE_DLFD=p_indiv2.P_LFDNR and
--        FK_VORHANDENE_DDAT=p_indiv2.P_DATENART
--        and FK_QUALITATIVE_FK=79;
--        
--       -- p_num:=1;
--    END LOOP;
    commit;
  --END;
end if;



END UKE_SP_BERICHT_NACHFRAGE_ZERT;