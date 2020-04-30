CREATE OR REPLACE PROCEDURE UKE_SP_GET_FU_TUMPAT_DATA 
(
  P_PATID IN varchar2 ,
  P_FollowUpStichtag IN DATE,
  P_FU_DATEN IN OUT SYS_REFCURSOR
) AS 
BEGIN
  open P_FU_DATEN for
 select distinct pa.pat_id,pa.vorname,pa.name,pa.geburtsdatum,pa.geschlecht,pa.sterbedatum
  ,pa.strasse,pa.plz,pa.Ort,pa.VORWAHL Patient_Vorwahl,pa.TELEFON as Patient_Telefon,
     aus.LETZTER_STATUS_DATUM,
     aus.LETZTER_STATUS_DATENART,
     aus.TUMOR_ID,aus.DIAGNOSEDATUM,aus.ICD10,aus.DIAGNOSETEXT,
     nvl(e.TEXT30,'KKR') Zentrum,
        nvl(de.TEXT30,'nicht zugeordnet') Dokumentar
      ,be.NAME DOK_NAME,be.VORNAME DOK_VORNAME,be.TELEFON,be.EMAIL,
      a.Name Arzt_Name, a.Vorname Arzt_Vorname, a.titel Arzt_Titel, a.Institution Arzt_Institution, a.Geschlecht Arzt_Geschlecht
      , a.Strasse Arzt_Strasse, a.PLZ Arzt_PLZ, a.Ort Arzt_Ort,a.ARZT_ID
      ,a.VORWAHL Arzt_Vorwahl,a.TELEFON Arzt_Telefon
      ,ap.BERICHTSBEGINN,ap.BERICHTSENDE,ap.HAUSARZT
       ,(Select LISTAGG(fa.BEZEICHNUNG,', ') WITHIN GROUP (ORDER BY fa.BEZEICHNUNG) from BEZEICHNET_GEBIET_DES gd inner join FACHRICHTUNGEN fa on fa.GEBIET_ID=gd.FK_FACHRICHTUNGGEB 
          where gd.FK_ARZTARZT_ID=a.ARZT_ID) as Fachgebiete
      ,(select case when count(*)>0 then 1 else 0 end from FACHRICHTUNGEN fa inner join BEZEICHNET_GEBIET_DES gd  on fa.GEBIET_ID=gd.FK_FACHRICHTUNGGEB
          inner join AW_KLASSE aw on fa.BEZEICHNUNG=aw.TEXT255
          inner join AW_KLASSENBEDINGUNG awk on awk.KLASSIERUNG_ID=aw.KLASSIERUNG_ID
          and awk.CODE=aw.CODE and aw.KLASSIERUNG_QUELLE=awk.KLASSIERUNG_QUELLE
          where awk.KLASSIERUNG_ID=12 and awk.KLASSIERUNG_QUELLE='UKE'
          and aus.ICD10 like awk.LIKE_KRITERIUM
          and gd.FK_ARZTARZT_ID=a.ARZT_ID) as Facharzt_fuer_Diagnose
      ,qb.BEMERKUNG as Follow_Up_Info,qb.TAG_DER_MESSUNG as Info_Datum
      ,ab.KURZBEZEICHNUNG as Zentrumsname
      ,ab.ABTEILUNG_ID as ZENT_ID  
      ,ab.ANSPRECH_TITEL||' '||ab.ANSPRECH_VORNAME||' '||ab.ANSPRECH_NAME as Zent_Leitung
      ,ab.STRASSE as Zent_Strasse 
      ,REGEXP_SUBSTR(ab.BEMERKUNG, '#Gebaeude:(.+?)#', 1, 1, 'm', 1) as Zent_Gebaeude 
      ,ab.PLZ||' '||ab.ORT as Zent_ORT
      ,ab.IBAN as Zent_LOGO
      ,REGEXP_SUBSTR(ab.BEMERKUNG, '#Nachsorgetext:(.+?)#', 1, 1, 'm', 1) as Zent_Betreff
      FROM AUSWERTUNG aus inner join Patient pa
       on pa.PAT_ID=aus.PAT_ID            
      left outer join "OPS$TUMSYS"."AW_Dokumentarsentitaeten_UKE" de
        on aus.ICD10 like de.LIKE_KRITERIUM
      left outer join BENUTZER be
        on be.BENUTZER_ID=de.TEXT30
      left outer join arzt_patient_beziehung ap 
      on  ap.Fk_PatientPat_ID = pa.Pat_ID 
      and ap.NachfrageAdressat = 'J' 
      left outer join arzt a 
      on a.Arzt_ID  = ap.Fk_ArztArzt_ID
      and a.AKTIV='A'
      -- OZ via ID
      left outer join ABTEILUNG ab
      on aus.ZENTKENN =ab.ABTEILUNG_ID
      -- Follow-Up Info
      left outer join QUALITATIVER_BEFUND qb 
      on qb.FK_VORHANDENE_DDAT='Diagnose'
      and qb.FK_VORHANDENE_DFK=pa.PAT_ID
      and qb.FK_VORHANDENE_DLFD=aus.TUMOR_ID
      and qb.FK_QUALITATIVE_FK=80
       --Organzentrum via ICD10
       left outer join AW_KLASSENBEDINGUNG b
      on aus.ICD10 like b.LIKE_KRITERIUM
      and b.KLASSIERUNG_ID=2
      and b.KLASSIERUNG_QUELLE='UKE'
      left outer join AW_KLASSE e
      on e.KLASSIERUNG_ID=b.KLASSIERUNG_ID
        and e.KLASSIERUNG_QUELLE=b.KLASSIERUNG_QUELLE
        and e.CODE=b.CODE
        
      inner join (Select to_number(trim(regexp_substr(str, '[^_]+', 1,1))) as PAT_ID,
                trim(regexp_substr(str, '_(.+)',1, 1, 'x', 1)) as TUMOR_ID
                from(
                WITH DATA AS
                          ( SELECT P_PATID str FROM dual
                          )
                        SELECT trim(regexp_substr(str, '[^,]+', 1, LEVEL)) str
                        FROM DATA
                        CONNECT BY instr(str, ',', 1, LEVEL - 1) > 0
                        )) XP
        on XP.PAT_ID=pa.PAT_ID
        and XP.TUMOR_ID=aus.TUMOR_ID
       where aus.VORGANG_ID=0
       /*and (aus.sterbedatum is null or (aus.sterbedatum is not null and exists
                (select 1  FROM QUALITATIVER_BEFUND qb 
                  WHERE aus.Pat_ID = qb.Fk_Vorhandene_DFK
                  AND aus.TUMOR_ID = qb.Fk_Vorhandene_DLFD
                  AND qb.Fk_Qualitative_Fk = 80         -- Merkmal ist Follow-Up Info
                  AND qb.Fk_Vorhandene_DDAT = 'Diagnose'
                  and qb.FK_QUALITATIVE_ID = 2))
                  ) -- Ausprägung ist "Postmortale Anfrage
       
        AND NOT EXISTS (select * from vorhandene_daten ch where
             datenart = 'Abschluss' and
             ch.FK_PATIENTPAT_ID = aus.PAT_ID and
             ch.DATUM           >= aus.LETZTER_STATUS_DATUM )
      
        and exists (select *  FROM QUALITATIVER_BEFUND qb 
                  WHERE aus.Pat_ID = qb.Fk_Vorhandene_DFK
                  AND aus.TUMOR_ID = qb.Fk_Vorhandene_DLFD
                  AND qb.Fk_Qualitative_Fk = 28          -- Merkmal ist Primärfall
                  AND qb.Fk_Vorhandene_DDAT = 'Diagnose'
                  and qb.FK_QUALITATIVE_ID = 1)--"Ja")*/
     -- and aus.KKR_EINWILLIGUNG<>'N'
       and (aus.LETZTER_STATUS_DATUM is null or aus.LETZTER_STATUS_DATUM<=trunc(to_date(P_FollowUpStichtag)))
         

;
    
END UKE_SP_GET_FU_TUMPAT_DATA  ;