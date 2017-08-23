
  SELECT
       pa.pat_id,pa.vorname,pa.name,pa.geburtsdatum,pa.strasse,pa.plz,pa.Ort,aus.LETZTER_STATUS_DATUM,aus.LETZTER_STATUS_DATENART,
       aus.LETZTE_INFO_DATUM,aus.LETZTE_INFO_DATENART,aus.DIAGNOSEDATUM,aus.DIAGNOSETEXT,aus.ICD10,
        nvl(de.TEXT30,'nicht zugeordnet') Dokumentar
      ,be.NAME DOK_NAME,be.VORNAME DOK_VORNAME,be.TELEFON,be.EMAIL,be.TITEL,
      nvl(ak.ZAEHLDAT,aus.DIAGNOSEDATUM) as Zaehldatum
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
       where aus.sterbedatum is null
       and aus.VORGANG_ID=0
        AND NOT EXISTS (select * from vorhandene_daten ch where
             datenart = 'Abschluss' and
             ch.FK_PATIENTPAT_ID = aus.PAT_ID and
             ch.DATUM           >= aus.LETZTER_STATUS_DATUM )
        and Exists  (SELECT * FROM Abteilung_Patient WHERE aus.Pat_ID =FK_PATIENTPAT_ID and Fk_AbteilungAbteil IN (:FollowUpZentrum))
        and exists (select *  FROM QUALITATIVER_BEFUND qb 
                  WHERE aus.Pat_ID = qb.Fk_Vorhandene_DFK
                  AND aus.TUMOR_ID = qb.Fk_Vorhandene_DLFD
                  AND qb.Fk_Qualitative_Fk = 28          -- Merkmal ist Primärfall
                  AND qb.Fk_Vorhandene_DDAT = 'Diagnose'
                  and qb.FK_QUALITATIVE_ID = 1)--"Ja")
      and aus.KKR_EINWILLIGUNG<>'N'
        and aus.LETZTER_STATUS_DATUM<=trunc(to_date(:FollowUpStichtag))
 and (:FollowUpZaehljahrStart is null or (EXTRACT(YEAR FROM nvl(ak.ZAEHLDAT,aus.DIAGNOSEDATUM)))>=:FollowUpZaehljahrStart)
  and (:FollowUpZaehljahrEnd is null or (EXTRACT(YEAR FROM nvl(ak.ZAEHLDAT,aus.DIAGNOSEDATUM)))<=:FollowUpZaehljahrEnd  )  
        order by pa.pat_id desc;