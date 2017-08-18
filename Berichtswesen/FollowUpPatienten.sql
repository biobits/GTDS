  select  distinct  DAT.vorname,
       DAT.name,
       DAT.geburtsdatum,
       DAT.pat_id,
      -- DAT.Name || ', ' || DAT.Vorname || ', ' || to_char(DAT.geburtsdatum, 'dd.mm.yyyy') Patient,
      -- DAT.strasse,
       --DAT.plz,
      -- DAT.Ort,
       DAT.Datum Datum_Follow_Up,
      tu.LETZTE_INFO_DATUM,
       tu.LETZTE_INFO_DATENART,
       tu.LETZTER_STATUS_DATUM,
       tu.LETZTER_STATUS_DATENART,/* */
       vdat.TUMOR_ID
       ,tu.DIAGNOSEDATUM,tu.DIAGNOSETEXT,tu.ICD10,	
      
      --vdat.BESCHREIBUNG
      nvl(de.TEXT30,'nicht zugeordnet') Dokumentar
      ,be.NAME DOK_NAME,be.VORNAME DOK_VORNAME,be.TELEFON,be.EMAIL,be.TITEL
       from (
  SELECT
       pa.vorname,pa.name,pa.geburtsdatum,pa.pat_id,pa.strasse,pa.plz,pa.Ort,max(vh.datum) Datum
       FROM patient pa inner join vorhandene_daten vh
       on pa.pat_id=vh.fk_patientpat_id
        where vh.DATENART != 'Abschluss'
        and vh.DATENART != 'Konsil'
        AND (nvl(vh.erfassung_abgeschl,'X') != 'V' or
                 vh.erfassung_abgeschl is null )
        AND pa.sterbedatum is null
        AND NOT EXISTS (select * from vorhandene_daten ch where
             datenart = 'Abschluss' and
             ch.FK_PATIENTPAT_ID = vh.FK_PATIENTPAT_ID and
             ch.DATUM           >= vh.DATUM )
        and Exists  (SELECT * FROM Abteilung_Patient WHERE pa.Pat_ID =FK_PATIENTPAT_ID and Fk_AbteilungAbteil IN (5))
        and exists (select *  FROM QUALITATIVER_BEFUND qb 
                  WHERE pa.Pat_ID = qb.Fk_Vorhandene_DFK
                  AND vh.TUMOR_ID = qb.Fk_Vorhandene_DLFD
                  AND qb.Fk_Qualitative_Fk = 28          -- Merkmal ist Primärfall
                  AND qb.Fk_Vorhandene_DDAT = 'Diagnose'
                  and qb.FK_QUALITATIVE_ID = 1)--"Ja")
  
        GROUP BY
          pa.vorname, pa.name,pa.geburtsdatum,pa.pat_id,pa.strasse,pa.plz,pa.Ort
        having max(vh.datum)<trunc(to_date(:FollowUpStichtag))) DAT 
      left outer join VORHANDENE_DATEN vdat on vdat.FK_PATIENTPAT_ID=DAT.pat_id and DAT.Datum=vdat.DATUM
      left outer join AUSWERTUNG tu on tu.PAT_ID=DAT.pat_id and tu.TUMOR_ID=vdat.TUMOR_ID
      left outer join "OPS$TUMSYS"."AW_Dokumentarsentitaeten_UKE" de
        on tu.ICD10 like de.LIKE_KRITERIUM
      left outer join BENUTZER be
        on be.BENUTZER_ID=de.TEXT30
       -- left outer join AUSWERTUNG tu on tu.PAT_ID=DAT.pat_id and aus.TUMOR_ID =vdat.Tumor_ID
        order by dat.pat_id desc;