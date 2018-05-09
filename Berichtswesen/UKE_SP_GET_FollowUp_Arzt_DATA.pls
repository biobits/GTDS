CREATE OR REPLACE PROCEDURE UKE_SP_GET_FU_ARZT_DATA 
(
  P_FollowUpZentrum IN NUMBER ,
  P_FollowUpStichtag IN DATE,
  P_FollowUpZaehljahrStart IN Number, 
  P_FollowUpZaehljahrEnd in NUMBER,
  P_FU_DATEN IN OUT SYS_REFCURSOR
) AS 
BEGIN
  open P_FU_DATEN for
 select distinct pa.pat_id,pa.vorname,pa.name,pa.geburtsdatum,pa.geschlecht
  ,pa.strasse,pa.plz,pa.Ort,pa.VORWAHL Patient_Vorwahl,pa.TELEFON as Patient_Telefon,
     aus.LETZTER_STATUS_DATUM,
     aus.LETZTER_STATUS_DATENART,
     aus.TUMOR_ID,aus.DIAGNOSEDATUM,aus.ICD10,aus.DIAGNOSETEXT,
        nvl(de.TEXT30,'nicht zugeordnet') Dokumentar
      ,be.NAME DOK_NAME,be.VORNAME DOK_VORNAME,be.TELEFON,be.EMAIL,
      a.Name Arzt_Name, a.Vorname Arzt_Vorname, a.titel Arzt_Titel, a.Institution Arzt_Institution, a.Geschlecht Arzt_Geschlecht
      , a.Strasse Arzt_Strasse, a.PLZ Arzt_PLZ, a.Ort Arzt_Ort,a.ARZT_ID
      ,a.VORWAHL Arzt_Vorwahl,a.TELEFON Arzt_Telefon
      ,ap.BERICHTSBEGINN,ap.BERICHTSENDE,ap.HAUSARZT
      ,qb.BEMERKUNG as Follow_Up_Info,qb.TAG_DER_MESSUNG as Info_Datum
      FROM AUSWERTUNG aus inner join Patient pa
       on pa.PAT_ID=aus.PAT_ID            
      left outer join "OPS$TUMSYS"."AW_Dokumentarsentitaeten_UKE" de
        on aus.ICD10 like de.LIKE_KRITERIUM
      left outer join BENUTZER be
        on be.BENUTZER_ID=de.TEXT30
        left outer join AUSWERTUNG_KOLOREKT ak
        on ak.PAt_ID=aus.PAt_Id
        and ak.Tumor_ID = aus.Tumor_id
        and ak.VORG_ID=0
      left outer join arzt_patient_beziehung ap 
      on  ap.Fk_PatientPat_ID = pa.Pat_ID 
      and ap.NachfrageAdressat = 'J' 
      left outer join arzt a 
      on a.Arzt_ID  = ap.Fk_ArztArzt_ID
      and a.AKTIV='A'
      left outer join QUALITATIVER_BEFUND qb 
      on qb.FK_VORHANDENE_DDAT='Diagnose'
      and qb.FK_VORHANDENE_DFK=pa.PAT_ID
      and qb.FK_VORHANDENE_DLFD=aus.TUMOR_ID
      and qb.FK_QUALITATIVE_FK=80-- Follow-Up Info
       where (aus.sterbedatum is null or (aus.sterbedatum is not null and exists
                (select 1  FROM QUALITATIVER_BEFUND qb 
                  WHERE aus.Pat_ID = qb.Fk_Vorhandene_DFK
                  AND aus.TUMOR_ID = qb.Fk_Vorhandene_DLFD
                  AND qb.Fk_Qualitative_Fk = 80         -- Merkmal ist Follow-Up Info
                  AND qb.Fk_Vorhandene_DDAT = 'Diagnose'
                  and qb.FK_QUALITATIVE_ID = 2))
                  ) -- Ausprägung ist "Postmortale Anfrage
       and aus.VORGANG_ID=0
        AND NOT EXISTS (select * from vorhandene_daten ch where
             datenart = 'Abschluss' and
             ch.FK_PATIENTPAT_ID = aus.PAT_ID and
             ch.DATUM           >= aus.LETZTER_STATUS_DATUM )
       -- and Exists  (SELECT * FROM Abteilung_Patient WHERE aus.Pat_ID =FK_PATIENTPAT_ID and Fk_AbteilungAbteil IN (P_FollowUpZentrum))
        and EXISTS (
         SELECT *
         from Assoziation
         WHERE aus.Pat_ID   = ASSOZIATION.VON_ID1
           AND aus.Tumor_ID = ASSOZIATION.VON_ID2
           and ASSOZIATION.TYP='PRIMAERFALL_ORGANZENTRUM'
           and Assoziation.zu_ID1 = P_FollowUpZentrum
        
        )
        and exists (select *  FROM QUALITATIVER_BEFUND qb 
                  WHERE aus.Pat_ID = qb.Fk_Vorhandene_DFK
                  AND aus.TUMOR_ID = qb.Fk_Vorhandene_DLFD
                  AND qb.Fk_Qualitative_Fk = 28          -- Merkmal ist Primärfall
                  AND qb.Fk_Vorhandene_DDAT = 'Diagnose'
                  and qb.FK_QUALITATIVE_ID = 1)--"Ja")
      and aus.KKR_EINWILLIGUNG<>'N'
        and aus.LETZTER_STATUS_DATUM<=trunc(to_date(P_FollowUpStichtag))
 and (P_FollowUpZaehljahrStart is null or (EXTRACT(YEAR FROM nvl(ak.ZAEHLDAT,aus.DIAGNOSEDATUM)))>=P_FollowUpZaehljahrStart)
  and (P_FollowUpZaehljahrEnd is null or (EXTRACT(YEAR FROM nvl(ak.ZAEHLDAT,aus.DIAGNOSEDATUM)))<=P_FollowUpZaehljahrEnd  ) 

   -- where  (a.ANSPRECH_NAME ||', '||a.ANSPRECH_VORNAME=P_FULLNAME_ARZT or (NVL(P_FULLNAME_ARZT,'ZZZ')='ZZZ' and NVL(a.ANSPRECH_NAME,'ZZZ')='ZZZ'))
  --  and trunc(qb.TAG_DER_MESSUNG) between trunc(to_date(P_STARTDATUM)) and trunc(to_date(P_ENDDATUM))
;
    
END UKE_SP_GET_FU_ARZT_DATA ;