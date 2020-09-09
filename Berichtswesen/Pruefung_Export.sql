select distinct p.pat_id GTDS_ID,p.PATIENTEN_ID,pe.kennung
,t.ICD10,de.TEXT30 Dokumentar,pe.text,t.TUMOR_ID,
'' Bemerkung,
(select qa.AUSPRAEGUNG||' | '||q.BEMERKUNG from Qualitativer_Befund q left outer join QUALITATIVE_AUSPRAEGUNG qa
  on qa.FK_QUALITATIVESID=q.FK_QUALITATIVE_FK
  and qa.ID=q.FK_QUALITATIVE_ID
inner join vorhandene_daten v on v.DATENART=q.FK_VORHANDENE_DDAT and q.FK_VORHANDENE_DLFD=v.LFDNR
and q.FK_VORHANDENE_DFK=v.FK_PATIENTPAT_ID
where q.FK_QUALITATIVE_FK=19 and q.FK_VORHANDENE_DFK=p.pat_id and v.TUMOR_ID=t.TUMOR_ID) ArbeitslistenInfo
,(select qa.AUSPRAEGUNG||' | '||q.BEMERKUNG from Qualitativer_Befund q left outer join QUALITATIVE_AUSPRAEGUNG qa
  on qa.FK_QUALITATIVESID=q.FK_QUALITATIVE_FK
  and qa.ID=q.FK_QUALITATIVE_ID
inner join vorhandene_daten v on v.DATENART=q.FK_VORHANDENE_DDAT and q.FK_VORHANDENE_DLFD=v.LFDNR
and q.FK_VORHANDENE_DFK=v.FK_PATIENTPAT_ID
where q.FK_QUALITATIVE_FK=102 and q.FK_VORHANDENE_DFK=p.pat_id and v.TUMOR_ID=t.TUMOR_ID) DokustandInfo
from patient  p inner join 
EXPORT_DATENSATZ ed on ed.ZUORDNUNG_ID1=p.PAT_ID
left outer join VORHANDENE_DATEN vd 
on UPPER(vd.DATENART)=case when ed.ZUORDNUNG_TYP='INTERNISTISCHE_THERAPIE' then 'INNERE'
 when ed.ZUORDNUNG_TYP='TUMOR' then 'DIAGNOSE'
 else ed.ZUORDNUNG_TYP end
 and vd.FK_PATIENTPAT_ID=ed.ZUORDNUNG_ID1
 and vd.LFDNR=ed.ZUORDNUNG_ID2
inner join
pruef_ergebnis   pe
on pe.pat_id=p.pat_id and pe.ID1=p.PAT_ID
and (vd.Datenart=pe.Datenart or pe.Datenart='Patient')
and vd.FK_PATIENTPAT_ID=pe.pat_id
and (vd.LFDNR=pe.LFDNR or pe.Datenart='Patient')
left outer join TUMOR t
 on t.FK_PATIENTPAT_ID=ed.ZUORDNUNG_ID1
 and t.Tumor_Id= vd.TUMOR_ID
 left outer join "OPS$TUMSYS"."AW_Dokumentarsentitaeten_UKE" de
on t.ICD10 like de.LIKE_KRITERIUM

where ed.EXPORT_ID=:IDExport
and (nvl(de.TEXT30,'Rest') =:Dokumentar or :Dokumentar is null)
and pe.LESEZEIT is null
union 
select distinct p.pat_id GTDS_ID,p.PATIENTEN_ID,'Meldeanlass'

,t.ICD10,de.TEXT30 Dokumentar,
case when 
ed.ZUORDNUNG_TYP='TUMOR' then (select NVL(MELDEANLASS,'Meldeanlass Diagnose fehlt (Lfdnr: '||ed.Zuordnung_ID2||')') from TUMOR where FK_PATIENTPAT_ID=ed.ZUORDNUNG_ID1 and TUMOR_ID=ed.ZUORDNUNG_ID2)
--ed.ZUORDNUNG_TYP='TUMOR' then (select NVL(MELDEANLASS,'Meldeanlass Diagnose fehlt') from TUMOR where FK_PATIENTPAT_ID=ed.ZUORDNUNG_ID1 and TUMOR_ID=ed.ZUORDNUNG_ID2)
when 
ed.ZUORDNUNG_TYP='OPERATION' then (select NVL(MELDEANLASS,'Meldeanlass Operation fehlt (Lfdnr: '||ed.Zuordnung_ID2||')') from OPERATION o where o.FK_TUMORFK_PATIENT=ed.ZUORDNUNG_ID1 and o.OP_NUMMER=ed.ZUORDNUNG_ID2)
when 
ed.ZUORDNUNG_TYP='INTERNISTISCHE_THERAPIE' then (select NVL(MELDEANLASS,'Meldeanlass Therapie (Intern.) fehlt (Lfdnr: '||ed.Zuordnung_ID2||')') from INTERNISTISCHE_THERAPIE it where it.FK_PATIENTPAT_ID=ed.ZUORDNUNG_ID1 and it.LFDNR=ed.ZUORDNUNG_ID2)
when 
ed.ZUORDNUNG_TYP='ABSCHLUSS' then (select NVL(MELDEANLASS,'Meldeanlass Tod (Abschluss) fehlt (Lfdnr: '||ed.Zuordnung_ID2||')') from ABSCHLUSS ab where ab.FK_PATIENTPAT_ID=ed.ZUORDNUNG_ID1 and ab.LFDNR=ed.ZUORDNUNG_ID2)
when 
ed.ZUORDNUNG_TYP='BESTRAHLUNG' then (select NVL(MELDEANLASS,'Meldeanlass Therapie (Bestrahlung) fehlt (Lfdnr: '||ed.Zuordnung_ID2||')') from BESTRAHLUNG be where be.FK_TUMORFK_PATIENT=ed.ZUORDNUNG_ID1 and be.LFDNR=ed.ZUORDNUNG_ID2)
when 
ed.ZUORDNUNG_TYP='VERLAUF' then (select NVL(MELDEANLASS,'Meldeanlass bei Verlauf fehlt (Lfdnr: '||ed.Zuordnung_ID2||')') from VERLAUF ve where ve.FK_TUMORFK_PATIENT=ed.ZUORDNUNG_ID1 and ve.LFDNR=ed.ZUORDNUNG_ID2)
end text,
t.TUMOR_ID,null,'' ArbeitslistenInfo,'' DokustandInfo
from patient  p inner join 
EXPORT_DATENSATZ ed on ed.ZUORDNUNG_ID1=p.PAT_ID
left outer join VORHANDENE_DATEN vd 
on UPPER(vd.DATENART)=case when ed.ZUORDNUNG_TYP='INTERNISTISCHE_THERAPIE' then 'INNERE'
 when ed.ZUORDNUNG_TYP='TUMOR' then 'DIAGNOSE'
 else ed.ZUORDNUNG_TYP end
 and vd.FK_PATIENTPAT_ID=ed.ZUORDNUNG_ID1
 and vd.LFDNR=ed.ZUORDNUNG_ID2
left outer join TUMOR t
 on t.FK_PATIENTPAT_ID=ed.ZUORDNUNG_ID1
 and t.Tumor_Id= vd.TUMOR_ID
 left outer join "OPS$TUMSYS"."AW_Dokumentarsentitaeten_UKE" de
on t.ICD10 like de.LIKE_KRITERIUM

where ed.EXPORT_ID=:IDExport
and (nvl(de.TEXT30,'Rest') =:Dokumentar or :Dokumentar is null)
and 'ZZ'=
case when 
ed.ZUORDNUNG_TYP='TUMOR' then NVL((select MELDEANLASS from TUMOR where FK_PATIENTPAT_ID=ed.ZUORDNUNG_ID1 and TUMOR_ID=ed.ZUORDNUNG_ID2),'ZZ')
when 
ed.ZUORDNUNG_TYP='OPERATION' then NVL((select o.MELDEANLASS from OPERATION o where o.FK_TUMORFK_PATIENT=ed.ZUORDNUNG_ID1 and o.OP_NUMMER=ed.ZUORDNUNG_ID2),'ZZ')
when 
ed.ZUORDNUNG_TYP='INTERNISTISCHE_THERAPIE' then NVL((select it.MELDEANLASS from INTERNISTISCHE_THERAPIE it where it.FK_PATIENTPAT_ID=ed.ZUORDNUNG_ID1 and it.LFDNR=ed.ZUORDNUNG_ID2),'ZZ')
when 
ed.ZUORDNUNG_TYP='ABSCHLUSS' then NVL((select ab.MELDEANLASS from ABSCHLUSS ab where ab.FK_PATIENTPAT_ID=ed.ZUORDNUNG_ID1 and ab.LFDNR=ed.ZUORDNUNG_ID2),'ZZ')
when 
ed.ZUORDNUNG_TYP='BESTRAHLUNG' then NVL((select be.MELDEANLASS from BESTRAHLUNG be where be.FK_TUMORFK_PATIENT=ed.ZUORDNUNG_ID1 and be.LFDNR=ed.ZUORDNUNG_ID2),'ZZ')
when 
ed.ZUORDNUNG_TYP='VERLAUF' then NVL((select ve.MELDEANLASS from VERLAUF ve where ve.FK_TUMORFK_PATIENT=ed.ZUORDNUNG_ID1 and ve.LFDNR=ed.ZUORDNUNG_ID2),'ZZ')
end 
union 
select distinct p.pat_id GTDS_ID,p.PATIENTEN_ID,'Mehrfachmeldung',t.ICD10,de.TEXT30 Dokumentar,
case when count(ed.ZUORDNUNG_ID1)>1 then 
ed.ZUORDNUNG_TYP||' (Lfdnr: '||ed.ZUORDNUNG_ID2|| ') wird mehrfach gemeldet' end text,
t.TUMOR_ID,nvl(an.Freitext,'') Bemerkung,'' ArbeitslistenInfo,'' DokustandInfo
from patient  p inner join 
EXPORT_DATENSATZ ed on ed.ZUORDNUNG_ID1=p.PAT_ID
left outer join VORHANDENE_DATEN vd 
on UPPER(vd.DATENART)=case when ed.ZUORDNUNG_TYP='INTERNISTISCHE_THERAPIE' then 'INNERE'
 when ed.ZUORDNUNG_TYP='TUMOR' then 'DIAGNOSE'
 else ed.ZUORDNUNG_TYP end
 and vd.FK_PATIENTPAT_ID=ed.ZUORDNUNG_ID1
 and vd.LFDNR=ed.ZUORDNUNG_ID2
 left outer join Anmerkung an
 on an.zuordnung_typ='VORHANDENE_DATEN'
 and an.liste_merkmal='ANMERKUNG_KREBSREGISTERMELDUNG'
 and an.Zuordnung_ID1=vd.FK_PATIENTPAT_ID
 and an.Zuordnung_ID3=vd.LFDNR
 and an.Zuordnung_ID2=vd.Datenart
left outer join TUMOR t
 on t.FK_PATIENTPAT_ID=ed.ZUORDNUNG_ID1
 and t.Tumor_Id= vd.TUMOR_ID
 left outer join "OPS$TUMSYS"."AW_Dokumentarsentitaeten_UKE" de
on t.ICD10 like de.LIKE_KRITERIUM
inner join 
EXPORT_DATENSATZ ed2 on ed.ZUORDNUNG_TYP=ed2.ZUORDNUNG_TYP and ed.ZUORDNUNG_ID1 =ed2.ZUORDNUNG_ID1
and ed.ZUORDNUNG_ID2 =ed2.ZUORDNUNG_ID2 and ed2.ExportDatum is not null
where ed.EXPORT_ID=:IDExport
and ed.Zuordnung_TYP in ('VERLAUF','TUMOR','OPERATION','ABSCHLUSS')
and TO_NUMBER(ed.EXPORT_ID)>TO_NUMBER(ed2.EXPORT_ID)
and (nvl(de.TEXT30,'Rest') =:Dokumentar or :Dokumentar is null)
group by p.pat_id ,p.PATIENTEN_ID,'Mehrfachmeldung',nvl(an.Freitext,''),ed.ZUORDNUNG_TYP,ed.ZUORDNUNG_ID1,ed.ZUORDNUNG_ID2,t.ICD10,de.TEXT30 ,t.TUMOR_ID,'' 
having count(ed.ZUORDNUNG_ID1)>1

union 

select distinct p.pat_id GTDS_ID,p.PATIENTEN_ID,'UCCH-Pruefung'

,t.ICD10,de.TEXT30 Dokumentar,

UCCH_PATCHECK(p.pat_id,t.TUMOR_ID,1,1) text,
t.TUMOR_ID,
(select max(q.BEMERKUNG) from Qualitativer_Befund q  inner join vorhandene_daten v on v.DATENART=q.FK_VORHANDENE_DDAT and q.FK_VORHANDENE_DLFD=v.LFDNR
and q.FK_VORHANDENE_DFK=v.FK_PATIENTPAT_ID
where q.FK_QUALITATIVE_ID=2 and q.FK_QUALITATIVE_FK=70 and q.FK_VORHANDENE_DFK=p.pat_id and v.TUMOR_ID=t.TUMOR_ID) Bemerkung,
(select qa.AUSPRAEGUNG||' | '||q.BEMERKUNG from Qualitativer_Befund q left outer join QUALITATIVE_AUSPRAEGUNG qa
  on qa.FK_QUALITATIVESID=q.FK_QUALITATIVE_FK
  and qa.ID=q.FK_QUALITATIVE_ID
inner join vorhandene_daten v on v.DATENART=q.FK_VORHANDENE_DDAT and q.FK_VORHANDENE_DLFD=v.LFDNR
and q.FK_VORHANDENE_DFK=v.FK_PATIENTPAT_ID
where q.FK_QUALITATIVE_FK=19 and q.FK_VORHANDENE_DFK=p.pat_id and v.TUMOR_ID=t.TUMOR_ID) ArbeitslistenInfo
,(select qa.AUSPRAEGUNG||' | '||q.BEMERKUNG from Qualitativer_Befund q left outer join QUALITATIVE_AUSPRAEGUNG qa
  on qa.FK_QUALITATIVESID=q.FK_QUALITATIVE_FK
  and qa.ID=q.FK_QUALITATIVE_ID
inner join vorhandene_daten v on v.DATENART=q.FK_VORHANDENE_DDAT and q.FK_VORHANDENE_DLFD=v.LFDNR
and q.FK_VORHANDENE_DFK=v.FK_PATIENTPAT_ID
where q.FK_QUALITATIVE_FK=102 and q.FK_VORHANDENE_DFK=p.pat_id and v.TUMOR_ID=t.TUMOR_ID) DokustandInfo
from patient  p inner join 
EXPORT_DATENSATZ ed on ed.ZUORDNUNG_ID1=p.PAT_ID
left outer join VORHANDENE_DATEN vd 
on UPPER(vd.DATENART)=case when ed.ZUORDNUNG_TYP='INTERNISTISCHE_THERAPIE' then 'INNERE'
 when ed.ZUORDNUNG_TYP='TUMOR' then 'DIAGNOSE'
 else ed.ZUORDNUNG_TYP end
 and vd.FK_PATIENTPAT_ID=ed.ZUORDNUNG_ID1
 and vd.LFDNR=ed.ZUORDNUNG_ID2
left outer join TUMOR t
 on t.FK_PATIENTPAT_ID=ed.ZUORDNUNG_ID1
 and t.Tumor_Id= vd.TUMOR_ID
 left outer join "OPS$TUMSYS"."AW_Dokumentarsentitaeten_UKE" de
on t.ICD10 like de.LIKE_KRITERIUM
where ed.EXPORT_ID=:IDExport
and (nvl(de.TEXT30,'Rest') =:Dokumentar or :Dokumentar is null)
and UCCH_PATCHECK(p.pat_id,t.TUMOR_ID,1,1)<>'O.K.'

order by GTDS_ID desc