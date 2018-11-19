select distinct 
de.TEXT30 Dokumentar,b.EMAIL
/*,qb.FK_VORHANDENE_DDAT Dokument ,qm.MERKMAL Merkmal,qb.FK_QUALITATIVE_FK,qb.FK_QUALITATIVE_ID
,qa.AUSPRAEGUNG||case when qa.BESCHREIBUNG is not null then '['||qa.BESCHREIBUNG||']' else qa.BESCHREIBUNG end Auspraegung,
qb.BEMERKUNG Bemerkung,qb.TAG_DER_MESSUNG,a.KUERZEL,
a.ABTEILUNG || ' ('||a.KUERZEL||')' Abteilung,
vd.BESCHREIBUNG as Dokument_Text
,vd.DATUM as Dokument_Datum*/

from --patient  p inner join 
QUALITATIVER_BEFUND qb --on qb.FK_VORHANDENE_DFK=p.PAT_ID
inner join QUALITATIVES_MERKMAL qm
on qb.FK_QUALITATIVE_FK=qm.ID
left outer join QUALITATIVE_AUSPRAEGUNG qa
on qa.FK_QUALITATIVESID=qb.FK_QUALITATIVE_FK
and qa.ID=qb.FK_QUALITATIVE_ID
left outer join VORHANDENE_DATEN vd 
on vd.DATENART=qb.FK_VORHANDENE_DDAT
 and vd.FK_PATIENTPAT_ID=qb.FK_VORHANDENE_DFK
 and vd.LFDNR=qb.FK_VORHANDENE_DLFD
 left outer join Abteilung a
 on a.ABTEILUNG_ID=vd.FK_ABTEILUNG_ID
left outer join TUMOR t
 on t.FK_PATIENTPAT_ID=vd.FK_PATIENTPAT_ID
 and t.Tumor_Id= vd.TUMOR_ID
 left outer join "OPS$TUMSYS"."AW_Dokumentarsentitaeten_UKE" de
on t.ICD10 like de.LIKE_KRITERIUM
left outer join BENUTZER b
on b.BENUTZER_ID=de.TEXT30



where
qb.FK_QUALITATIVE_FK in (79,84) 
and qb.FK_QUALITATIVE_ID not in (3,5) --"erledigt" und "unvollständig erledigt" werden nicht abgefragt
 and
 --(nvl(de.TEXT30,'Rest') =:Dokumentar or :Dokumentar ='0')
 --and(qb.FK_QUALITATIVE_ID=:IdAuspraegung or :IdAuspraegung=0)
-- and (qb.TAG_DER_MESSUNG >=:startdatum or :startdatum is null)
-- and (qb.TAG_DER_MESSUNG <=:enddatum or :enddatum is null)
-- and (a.ANSPRECH_NAME ||', '||a.ANSPRECH_VORNAME=:P_FULLNAME_ARZT or :P_FULLNAME_ARZT is null)
 a.ANSPRECH_NAME ||', '||a.ANSPRECH_VORNAME=', '
;