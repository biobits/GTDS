

select * from ABTEILUNG order by ABTEILUNG_ID;

select * 
    FROM QUALITATIVER_BEFUND qb
          WHERE a.Pat_ID = qb.Fk_Vorhandene_DFK
            AND a.Tumor_ID = qb.Fk_Vorhandene_DLFD
            AND qb.Fk_Qualitative_Fk = 28          -- Merkmal ist Primärfall
            AND qb.Fk_Vorhandene_DDAT = 'Diagnose';

select --count(*)--1144
t.FK_PATIENTPAT_ID,t.TUMOR_ID,t.ICD10,t.DIAGNOSEDATUM,a.ZU_TABELLE,a.ZU_ID1
from Tumor t
left outer join Assoziation a
on t.FK_PATIENTPAT_ID= a.VON_ID1
and t.TUMOR_ID=a.VON_ID2
and a.TYP='PRIMAERFALL_ORGANZENTRUM'
where (SUBSTR(t.ICD10,0,3) in ('C60','C62','C63','C64','C65','C66','C67','C68','C74')
or t.ICD10 in ('D07.4','D09.0','D09.1'))
and exists (select 1
    FROM QUALITATIVER_BEFUND qb
          WHERE t.FK_PATIENTPAT_ID = qb.Fk_Vorhandene_DFK
            AND t.Tumor_ID = qb.Fk_Vorhandene_DLFD
            AND qb.Fk_Qualitative_Fk = 28  -- Merkmal ist Primärfall
            and qb.FK_QUALITATIVE_ID=1 -- Ausprägung ist 'Ja'
            AND qb.Fk_Vorhandene_DDAT = 'Diagnose');

--Update via Merge

Merge Into Assoziation a
using ( select FK_PATIENTPAT_ID,TUMOR_ID,ICD10
from Tumor  where (substr(ICD10,0,3) in ('C60','C62','C63','C64','C65','C66','C67','C68','C74')
or ICD10 in ('D07.4','D09.0','D09.1'))and exists (select 1
    FROM QUALITATIVER_BEFUND qb
          WHERE TUMOR.FK_PATIENTPAT_ID = qb.Fk_Vorhandene_DFK
            AND TUMOR.TUMOR_ID = qb.Fk_Vorhandene_DLFD
            AND qb.Fk_Qualitative_Fk = 28  -- Merkmal ist Primärfall
            and qb.FK_QUALITATIVE_ID=1 -- Ausprägung ist 'Ja'
            AND qb.Fk_Vorhandene_DDAT = 'Diagnose')) t
on (t.FK_PATIENTPAT_ID= a.VON_ID1
and t.TUMOR_ID=a.VON_ID2 and a.TYP='PRIMAERFALL_ORGANZENTRUM')
WHEN MATCHED THEN
  UPDATE SET a.ZU_ID1 = '10'
   WHERE a.ZU_ID1 != '10'
WHEN NOT MATCHED THEN 
INSERT (a.VON_TABELLE,a.VON_ID1,a.VON_ID2,a.TYP,a.ZENTRAL_JN,a.ZU_TABELLE,a.ZU_ID1,a.AENDERUNGSDATUM,a.ERSTELLUNGSDATUM,a.FK_BENUTZERBENUTZE)
VALUES ('TUMOR',t.FK_PATIENTPAT_ID,t.TUMOR_ID,'PRIMAERFALL_ORGANZENTRUM','J','ABTEILUNG','10',sysdate,sysdate,'OPS$TUMSYS');

--rollback 

