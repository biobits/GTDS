create or replace PROCEDURE UKE_SP_BERICHT_FOLLOWUP 
(
  P_FollowUpZentrum IN NUMBER,
  P_IS_TEST in NUMBER ,--default TRUE,
  P_BERICHTSNAME varchar2,
  P_BENUTZER varchar2,
  P_FollowUpStichtag IN DATE,
  P_FollowUpZaehljahrStart IN Number, 
  P_FollowUpZaehljahrEnd in NUMBER,
  P_RESULTSET OUT SYS_REFCURSOR
) AS 
   type r_indiv is record(
    P_GTDS_ID                   PATIENT.PAT_ID%TYPE ,
    P_TITEL                     PATIENT.TITEL%TYPE ,
    P_VORNAME                   PATIENT.VORNAME%TYPE,
    P_NAME                      PATIENT.NAME%TYPE,
    P_GEBURTSDATUM              PATIENT.GEBURTSDATUM%TYPE ,
    P_GESCHLECHT                PATIENT.GESCHLECHT%TYPE,
    P_STRASSE                   PATIENT.STRASSE%TYPE,
    P_PLZ                       PATIENT.PLZ%TYPE,
    P_ORT                       PATIENT.ORT%TYPE,
    P_LETZTER_STATUS_DATUM      AUSWERTUNG.LETZTER_STATUS_DATUM%TYPE,
    P_LETZTER_STATUS_DATENART   AUSWERTUNG.LETZTER_STATUS_DATENART%TYPE,
    P_TUMOR_ID                  AUSWERTUNG.TUMOR_ID%TYPE,
    P_DIAGNOSEDATUM             AUSWERTUNG.DIAGNOSEDATUM%TYPE ,
    P_ICD10                     AUSWERTUNG.ICD10%TYPE ,	
    P_DIAGNOSETEXT              AUSWERTUNG.DIAGNOSETEXT%TYPE ,
    P_DOKUMENTAR                varchar2(30),
    P_DOK_NAME                  BENUTZER.NAME%TYPE,
    P_DOK_VORNAME               BENUTZER.VORNAME%TYPE,
    P_TELEFON                   BENUTZER.TELEFON%TYPE,
    P_EMAIL                     BENUTZER.EMAIL%TYPE ,
    P_FU_Info_Auspraegung       QUALITATIVE_AUSPRAEGUNG.auspraegung%TYPE,
    P_FU_Info_Text              QUALITATIVE_AUSPRAEGUNG.beschreibung%TYPE ,
    P_FU_Info_Bemerkung         QUALITATIVER_BEFUND.bemerkung%TYPE,
    P_Arbeitsliste_Auspraegung  QUALITATIVE_AUSPRAEGUNG.auspraegung%TYPE,
    P_Arbeitsliste_Text         QUALITATIVE_AUSPRAEGUNG.beschreibung%TYPE ,
    P_Arbeitsliste_Bemerkung    QUALITATIVER_BEFUND.bemerkung%TYPE
    );
    p_indiv r_indiv;
    p_intrec SYS_REFCURSOR;
    p_num number; --Zum testen
BEGIN



UKE_SP_GET_FU_Patient_DATA(P_FollowUpZentrum => P_FollowUpZentrum,
                      P_FollowUpStichtag => P_FollowUpStichtag ,
                      P_FollowUpZaehljahrStart => P_FollowUpZaehljahrStart  ,
                      P_FollowUpZaehljahrEnd => P_FollowUpZaehljahrEnd,
                      P_FU_DATEN => P_RESULTSET);
if (P_IS_TEST=0) then
  --BEGIN
    UKE_SP_GET_FU_Patient_DATA(P_FollowUpZentrum => P_FollowUpZentrum,
                      P_FollowUpStichtag => P_FollowUpStichtag ,
                      P_FollowUpZaehljahrStart => P_FollowUpZaehljahrStart  ,
                      P_FollowUpZaehljahrEnd => P_FollowUpZaehljahrEnd,
                      P_FU_DATEN => p_intrec);
    LOOP
      FETCH p_intrec into p_indiv;
      exit when p_intrec%NOTFOUND;
        
        --Erstellung des Berichst in Tabelle BERICHT loggen
        UKE_SP_INSERT_BERICHT(p_indiv.P_GTDS_ID, p_indiv.P_TUMOR_ID,P_BERICHTSNAME,NULL,NULL,P_BENUTZER,'UKE');   
        
        
       -- p_num:=1;
    END LOOP;
    commit;
  --END;
end if;

--27734, 25051
--CLOSE p_recordset;


END UKE_SP_BERICHT_FOLLOWUP;