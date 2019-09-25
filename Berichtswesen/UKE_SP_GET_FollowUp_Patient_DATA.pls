CREATE OR REPLACE PROCEDURE UKE_SP_GET_FU_Patient_DATA 
(
  P_FollowUpZentrum IN NUMBER ,
  P_FollowUpStichtag IN DATE,
  P_FollowUpZaehljahrStart IN Number, 
  P_FollowUpZaehljahrEnd in NUMBER,
  P_FU_DATEN IN OUT SYS_REFCURSOR
) AS 
BEGIN
  open P_FU_DATEN for
  select distinct pa.pat_id,pa.titel,pa.vorname,pa.name,pa.geburtsdatum,pa.geschlecht
  ,pa.strasse,pa.plz,pa.Ort,
     aus.LETZTER_STATUS_DATUM,
     aus.LETZTER_STATUS_DATENART,
     aus.TUMOR_ID,aus.DIAGNOSEDATUM,aus.ICD10,aus.DIAGNOSETEXT,
        cast(nvl(de.TEXT30,'nicht zugeordnet') as varchar2(30)) Dokumentar
      ,be.NAME DOK_NAME,be.VORNAME DOK_VORNAME,be.TELEFON,be.EMAIL
    ,qaa.auspraegung FU_Info_Auspraegung,qaa.beschreibung FU_Info_Text ,qb.bemerkung FU_Info_Bemerkung
    ,qaa2.auspraegung Arbeitsliste_Auspraegung,qaa2.beschreibung Arbeitsliste_Text ,qb2.bemerkung Arbeitsliste_Bemerkung
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
left outer join QUALITATIVER_BEFUND qb 
                  on aus.Pat_ID = qb.Fk_Vorhandene_DFK
                  AND aus.TUMOR_ID = qb.Fk_Vorhandene_DLFD
                  AND qb.Fk_Qualitative_Fk = 80          -- Merkmal Follow-Up Info
                  AND qb.Fk_Vorhandene_DDAT = 'Diagnose'
  left outer join QUALITATIVE_AUSPRAEGUNG qaa
  on qb.Fk_Qualitative_Fk = qaa.Fk_QualitativesID -- Merkmal
            AND qb.Fk_Qualitative_ID = qaa.ID
  left outer join QUALITATIVER_BEFUND qb2 
                  on aus.Pat_ID = qb2.Fk_Vorhandene_DFK
                  AND aus.TUMOR_ID = qb2.Fk_Vorhandene_DLFD
                  AND qb2.Fk_Qualitative_Fk = 19          -- Merkmal Arbeitsliste
                  AND qb2.Fk_Vorhandene_DDAT = 'Diagnose'
  left outer join QUALITATIVE_AUSPRAEGUNG qaa2
  on qb2.Fk_Qualitative_Fk = qaa2.Fk_QualitativesID -- Merkmal
            AND qb2.Fk_Qualitative_ID = qaa2.ID                
where aus.sterbedatum is null
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
        and exists (select 1  FROM QUALITATIVER_BEFUND qb 
                  WHERE aus.Pat_ID = qb.Fk_Vorhandene_DFK
                  AND aus.TUMOR_ID = qb.Fk_Vorhandene_DLFD
                  AND qb.Fk_Qualitative_Fk = 28          -- Merkmal ist Primärfall
                  AND qb.Fk_Vorhandene_DDAT = 'Diagnose'
                  and qb.FK_QUALITATIVE_ID = 1)--"Ja")
        and not exists (select 1  FROM QUALITATIVER_BEFUND qb 
                  WHERE aus.Pat_ID = qb.Fk_Vorhandene_DFK
                  AND aus.TUMOR_ID = qb.Fk_Vorhandene_DLFD
                  AND qb.Fk_Qualitative_Fk = 80          -- Merkmal Follow-Up Info
                  AND qb.Fk_Vorhandene_DDAT = 'Diagnose'
                  and (qb.FK_QUALITATIVE_ID = 3 or qb.FK_QUALITATIVE_ID = 4))--"Keine Anfrage an Patient")
      and (aus.KKR_EINWILLIGUNG<>'N' or aus.KKR_EINWILLIGUNG is null)  --Am 02.09.2019 wieder aktiviert
      ---Nachsorgezustimmung: Wenn 'Nein' dann keine FU-ANfrage
      and not exists(Select 1 from Tumor tu where tu.fk_patientpat_id = aus.pat_id and tu.tumor_id=aus.tumor_id and tu.nachsorgezustimmun='N') 
      
        and aus.LETZTER_STATUS_DATUM<=trunc(to_date(P_FollowUpStichtag))
 and (P_FollowUpZaehljahrStart is null or (EXTRACT(YEAR FROM nvl(ak.ZAEHLDAT,aus.DIAGNOSEDATUM)))>=P_FollowUpZaehljahrStart)
  and (P_FollowUpZaehljahrEnd is null or (EXTRACT(YEAR FROM nvl(ak.ZAEHLDAT,aus.DIAGNOSEDATUM)))<=P_FollowUpZaehljahrEnd  ) 

   -- where  (a.ANSPRECH_NAME ||', '||a.ANSPRECH_VORNAME=P_FULLNAME_ARZT or (NVL(P_FULLNAME_ARZT,'ZZZ')='ZZZ' and NVL(a.ANSPRECH_NAME,'ZZZ')='ZZZ'))
  --  and trunc(qb.TAG_DER_MESSUNG) between trunc(to_date(P_STARTDATUM)) and trunc(to_date(P_ENDDATUM))
;
    
END UKE_SP_GET_FU_Patient_DATA ;