CREATE OR REPLACE PROCEDURE UKE_SP_GET_NACHFRAGE_ZERT_DATA 
(
  P_FULLNAME_ARZT IN VARCHAR2 ,
  P_ERSTANFRAGESTICHTAG IN DATE , -- für alle mit Status "offen" älter / gleich datum
  P_VERSCHICKTSTICHTAG IN DATE , -- für alle mit Status 'VerschickT' älter /gleich Datum
  P_ABSCHLUSSSTICHTAG IN DATE, ---- für alle mit Status 'Erinnerung' älter /gleich Datum, kann NULL sein, wenn daten nicht benötigt
  P_NACHFRAGEDATEN IN OUT SYS_REFCURSOR
) AS 
BEGIN

  open P_NACHFRAGEDATEN for
  select p.PATIENTEN_ID UKE_ID, V.FK_PATIENTPAT_ID GTDS_ID,p.GEBURTSDATUM,p.NAME,p.VORNAME
    ,V.TUMOR_ID,V.DATENART,V.LFDNR,V.DATUM DATUM_DOKUMENT,
    qb.FK_QUALITATIVE_ID,qb.TAG_DER_MESSUNG,qb.BEMERKUNG,qa.AUSPRAEGUNG,qa.BESCHREIBUNG AUSPRAEGUNG_TEXT
    ,A.ABTEILUNG,A.KUERZEL,A.ANSPRECH_NAME,A.ANSPRECH_VORNAME , A.ANSPRECH_TITEL,A.ANSPRECH_GESCHLECHT
    ,t.DIAGNOSEDATUM,t.DIAGNOSETEXT,t.ICD10,	
    nvl(e.TEXT255,'Sonstige') Entitaet,V.BESCHREIBUNG
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
    left outer join QUALITATIVE_AUSPRAEGUNG qa
    on qa.FK_QUALITATIVESID=qb.FK_QUALITATIVE_FK 
    and qa.ID=qb.FK_QUALITATIVE_ID
    
    left outer join ABTEILUNG A
    on A.ABTEILUNG_ID=V.FK_ABTEILUNG_ID
     left outer join TUmor t
    on t.TUMOR_ID=V.TUMOR_ID
    and t.FK_PATIENTPAT_ID=V.FK_PATIENTPAT_ID
    left outer join AW_KLASSENBEDINGUNG b
      on t.ICD10 like b.LIKE_KRITERIUM
      and b.KLASSIERUNG_ID=4
      and b.KLASSIERUNG_QUELLE='UKE'
      left outer join AW_KLASSE e
      on e.KLASSIERUNG_ID=b.KLASSIERUNG_ID
        and e.KLASSIERUNG_QUELLE=b.KLASSIERUNG_QUELLE
        and e.CODE=b.CODE
     left outer join "OPS$TUMSYS"."AW_Dokumentarsentitaeten_UKE" de
    on t.ICD10 like de.LIKE_KRITERIUM
    left outer join BENUTZER be
    on be.BENUTZER_ID=de.TEXT30
    where  (a.ANSPRECH_NAME ||', '||a.ANSPRECH_VORNAME=P_FULLNAME_ARZT or (NVL(P_FULLNAME_ARZT,'ZZZ')='ZZZ' and NVL(a.ANSPRECH_NAME,'ZZZ')='ZZZ'))
    and qb.FK_QUALITATIVE_FK = 84--Qualitatives_MErkmal Anfrage Zertifizierung
    and (
          (qb.FK_QUALITATIVE_ID =1 -- Ausprägung "offen"
              and  (trunc(qb.TAG_DER_MESSUNG) <= trunc(to_date(P_ERSTANFRAGESTICHTAG))))
          or
          (qb.FK_QUALITATIVE_ID =2 -- Ausprägung "verschickt"
              and  (trunc(qb.TAG_DER_MESSUNG) <= trunc(to_date(P_VERSCHICKTSTICHTAG))))
          or
          (
            --NVL2(P_ABSCHLUSSSTICHTAG,1,0)=0 or --funktioniert irgendwie nicht -fck ora
            (qb.FK_QUALITATIVE_ID =4 -- Ausprägung "Erinnerung"
              and  (trunc(qb.TAG_DER_MESSUNG) <= trunc(to_date(P_ABSCHLUSSSTICHTAG))))
          )
        )

  --  order by V.FK_PATIENTPAT_ID desc
  ;
    
END UKE_SP_GET_NACHFRAGE_ZERT_DATA  ;