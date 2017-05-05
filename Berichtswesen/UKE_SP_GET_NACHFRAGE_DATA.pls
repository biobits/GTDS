CREATE OR REPLACE PROCEDURE UKE_SP_GET_NACHFRAGE_DATA 
(
  P_FULLNAME_ARZT IN VARCHAR2 ,
  P_STARTDATUM IN DATE,
  P_ENDDATUM IN DATE, 
  P_NACHFRAGEDATEN IN OUT SYS_REFCURSOR
) AS 
BEGIN
  open P_NACHFRAGEDATEN for
  select p.PATIENTEN_ID UKE_ID, V.FK_PATIENTPAT_ID GTDS_ID,p.GEBURTSDATUM,p.NAME,p.VORNAME
    ,V.TUMOR_ID,V.DATENART,V.LFDNR,V.DATUM DATUM_DOKUMENT,
    qb.TAG_DER_MESSUNG,qb.BEMERKUNG,A.ABTEILUNG,A.KUERZEL,
    A.ANSPRECH_NAME,A.ANSPRECH_VORNAME , A.ANSPRECH_TITEL,A.ANSPRECH_GESCHLECHT
    ,t.DIAGNOSEDATUM,t.DIAGNOSETEXT,t.ICD10,	
    e.Bezeichnung Entitaet,V.BESCHREIBUNG
    ,nvl(de.TEXT30,'nicht zugeordnet') Dokumentar
    ,be.NAME DOK_NAME,be.VORNAME DOK_VORNAME,be.TELEFON,be.EMAIL,be.TITEL
    from 
    PATIENT p inner join 
    VORHANDENE_DATEN V
    on p.PAT_ID=V.FK_PATIENTPAT_ID
    inner join QUALITATIVER_BEFUND qb
    on qb.FK_VORHANDENE_DDAT=V.DATENART
    and V.LFDNR=qb.FK_VORHANDENE_DLFD
    and V.FK_PATIENTPAT_ID=qb.FK_VORHANDENE_DFK
    and qb.FK_QUALITATIVE_FK = 79--Qualitatives_MErkmal Aktenbeurteilung
    and qb.FK_QUALITATIVE_ID =1 -- Qualitative_AUspraegung
    left outer join ABTEILUNG A
    on A.ABTEILUNG_ID=V.FK_ABTEILUNG_ID
    left outer join AUSWERTUNG_UCCH t
    on t.TUMOR_ID=V.TUMOR_ID
    and t.GTDS_ID=V.FK_PATIENTPAT_ID
    left outer join Entitaet_Beschreibung b
    on t.ICD10              LIKE b.Like_Kriterium || '%'
       AND b.Schluesselart      = 'ICD'
       AND b.Auflage            = '10'
      left outer join Tumor_Entitaet e
     on e.Quelle             = b.Fk_EntitaetQuelle
       AND e.LfdNr              = b.Fk_EntitaetLfdNr
     left outer join "OPS$TUMSYS"."AW_Dokumentarsentitaeten_UKE" de
    on t.ICD10 like de.LIKE_KRITERIUM
    left outer join BENUTZER be
    on be.BENUTZER_ID=de.TEXT30
    where  (a.ANSPRECH_NAME ||', '||a.ANSPRECH_VORNAME=P_FULLNAME_ARZT or (NVL(P_FULLNAME_ARZT,'ZZZ')='ZZZ' and NVL(a.ANSPRECH_NAME,'ZZZ')='ZZZ'))
    and qb.TAG_DER_MESSUNG between P_STARTDATUM and P_ENDDATUM
    order by V.FK_PATIENTPAT_ID desc;
    
END UKE_SP_GET_NACHFRAGE_DATA;