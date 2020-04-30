create or replace PROCEDURE UKE_SP_BERICHT_FOLLOWUP_TUMPAT
(
  P_PATID IN varchar2,
  P_IS_TEST in NUMBER ,--default TRUE,
  P_BERICHTSNAME varchar2,
  P_BENUTZER varchar2,
  P_FollowUpStichtag IN DATE,
  P_RESULTSET OUT SYS_REFCURSOR
) AS 
   type r_indiv is record(
    P_GTDS_ID                   PATIENT.PAT_ID%TYPE ,
    P_VORNAME                   PATIENT.VORNAME%TYPE,
    P_NAME                      PATIENT.NAME%TYPE,
    P_GEBURTSDATUM              PATIENT.GEBURTSDATUM%TYPE ,
    P_GESCHLECHT                PATIENT.GESCHLECHT%TYPE,
    P_STERBEDATUM               PATIENT.STERBEDATUM%TYPE,
    P_STRASSE                   PATIENT.STRASSE%TYPE,
    P_PLZ                       PATIENT.PLZ%TYPE,
    P_ORT                       PATIENT.ORT%TYPE,
    P_Patient_Vorwahl           PATIENT.VORWAHL%TYPE,
    P_Patient_Telefon           PATIENT.TELEFON%TYPE,
    P_LETZTER_STATUS_DATUM      AUSWERTUNG.LETZTER_STATUS_DATUM%TYPE,
    P_LETZTER_STATUS_DATENART   AUSWERTUNG.LETZTER_STATUS_DATENART%TYPE,
    P_TUMOR_ID                  AUSWERTUNG.TUMOR_ID%TYPE,
    P_DIAGNOSEDATUM             AUSWERTUNG.DIAGNOSEDATUM%TYPE ,
    P_ICD10                     AUSWERTUNG.ICD10%TYPE ,	
    P_DIAGNOSETEXT              AUSWERTUNG.DIAGNOSETEXT%TYPE ,
    P_ZENTRUM                   varchar2(30),
    P_DOKUMENTAR                varchar2(30),
    P_DOK_NAME                  BENUTZER.NAME%TYPE,
    P_DOK_VORNAME               BENUTZER.VORNAME%TYPE,
    P_TELEFON                   BENUTZER.TELEFON%TYPE,
    P_EMAIL                     BENUTZER.EMAIL%TYPE,
    P_Arzt_Name                 ARZT.Name%Type ,
    P_Arzt_Vorname              ARZT.Vorname%Type ,
    P_Arzt_Titel                ARZT.titel%Type ,
    P_Arzt_Institution          ARZT.Institution%Type ,
    P_Arzt_Geschlech            ARZT.Geschlecht%Type ,
    P_Arzt_Strasse              ARZT.Strasse%Type ,
    P_Arzt_PLZ                  ARZT.PLZ%Type ,
    P_Arzt_Ort                  ARZT.Ort%Type ,
    P_Arzt_Id                   ARZT.ARZT_ID%Type,
    P_Arzt_Vorwahl              ARZT.VORWAHL%TYPE,
    P_Arzt_Telefon              ARZT.TELEFON%TYpe,
    P_BERICHTSBEGINN            ARZT_PATIENT_BEZIEHUNG.BERICHTSBEGINN%TYPE,
    P_BERICHTSENDE              ARZT_PATIENT_BEZIEHUNG.BERICHTSENDE%TYPE,
    P_HAUSARZT                  ARZT_PATIENT_BEZIEHUNG.HAUSARZT%TYPE,
    P_FACHGEBIETE               varchar2(500) ,
    P_FACHARZT_FUER_DIAGNOSE    number,
    P_Follow_Up_Info            QUALITATIVER_BEFUND.BEMERKUNG%TYPE,
    P_Info_Datum                QUALITATIVER_BEFUND.TAG_DER_MESSUNG%TYPE,
    Zentrumsname                varchar2(100),
    P_ZENT_ID                   ABTEILUNG.ABTEILUNG_ID%TYPE,
    P_ZENT_LEITUNG              varchar2(100),
    P_ZENT_STRASSE              varchar2(100),
    P_ZENT_GEBAEUDE             varchar2(30),
    P_ZENT_ORT                  varchar2(100),
    P_ZENT_LOGO                 varchar2(30),
    P_ZENT_BETREFF              varchar2(250)
    );
    
    p_indiv r_indiv;
    p_intrec SYS_REFCURSOR;
    p_num number; --Zum testen
BEGIN



UKE_SP_GET_FU_TUMPAT_DATA (P_PATID => P_PATID,
                      P_FollowUpStichtag => P_FollowUpStichtag ,
                      P_FU_DATEN => P_RESULTSET);
if (P_IS_TEST=0) then
  --BEGIN
    UKE_SP_GET_FU_TUMPAT_DATA (P_PATID => P_PATID,
                      P_FollowUpStichtag => P_FollowUpStichtag ,
                      P_FU_DATEN => p_intrec);
    LOOP
      FETCH p_intrec into p_indiv;
      exit when p_intrec%NOTFOUND;
        
        --Erstellung des Berichst in Tabelle BERICHT loggen
        UKE_SP_INSERT_BERICHT(p_indiv.P_GTDS_ID, p_indiv.P_TUMOR_ID,P_BERICHTSNAME,NULL,NULL,P_BENUTZER,'UKE');   
         -- Erstellung des Berichts in Tabelle UKE_EVENT_LOG loggen
        UKE_SP_INSERT_EVENT(p_indiv.P_GTDS_ID,p_indiv.P_TUMOR_ID,'Diagnose',p_indiv.P_TUMOR_ID,SYSDATE,'BERICHTE',
                              'UKE_'||P_BERICHTSNAME,'erstellt',NULL,'FU_Zentrum: ' ||p_indiv.P_ZENTRUM||'|'|| 'FU_Stichtag: ' ||P_FollowUpStichtag||'|',P_BENUTZER);
        
        
       -- p_num:=1;
    END LOOP;
    commit;
  --END;
end if;

--27734, 25051
--CLOSE p_recordset;


END UKE_SP_BERICHT_FOLLOWUP_TUMPAT;