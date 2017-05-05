select p.PATIENTEN_ID UKE_ID, V.FK_PATIENTPAT_ID GTDS_ID,p.GEBURTSDATUM,V.TUMOR_ID,V.DATENART,V.DATUM DATUM_DOKUMENT,
qb.TAG_DER_MESSUNG,qb.BEMERKUNG,A.ABTEILUNG,A.KUERZEL,A.ANSPRECH_NAME,t.DIAGNOSEDATUM,t.DIAGNOSETEXT,t.ICD10,	
	e.Bezeichnung Entitaet,V.BESCHREIBUNG

from 
PATIENT p inner join 
VORHANDENE_DATEN V
on p.PAT_ID=V.FK_PATIENTPAT_ID
inner join QUALITATIVER_BEFUND qb
on qb.FK_VORHANDENE_DDAT=V.DATENART
and V.LFDNR=qb.FK_VORHANDENE_DLFD
and V.FK_PATIENTPAT_ID=qb.FK_VORHANDENE_DFK
and qb.FK_QUALITATIVE_FK = 70--Qualitatives_MErkmal Aktenbeurteilung
and qb.FK_QUALITATIVE_ID =2 -- Qualitative_AUspraegung
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
where  (a.ANSPRECH_NAME ||', '||a.ANSPRECH_VORNAME=:FULLNAME_ARZT or (NVL(:FULLNAME_ARZT,'ZZZ')='ZZZ' and NVL(a.ANSPRECH_NAME,'ZZZ')='ZZZ'))
--and qb.TAG_DER_MESSUNG between :startdatum and :enddatum
order by V.FK_PATIENTPAT_ID desc;