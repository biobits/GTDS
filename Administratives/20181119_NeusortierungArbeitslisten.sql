--20181119 Lymphome von Holger zu Lym Arbeitsliste
 
update QUALITATIVER_BEFUND
set FK_QUALITATIVE_ID= 21 --Lym
where FK_QUALITATIVE_FK=19
and FK_QUALITATIVE_ID=8 --Holger
and exists( select 1 from 
tumor t 
where t.FK_PATIENTPAT_ID =QUALITATIVER_BEFUND.FK_VORHANDENE_DFK
and QUALITATIVER_BEFUND.FK_VORHANDENE_DDAT='Diagnose'
and QUALITATIVER_BEFUND.FK_VORHANDENE_DLFD=t.TUMOR_ID
and (t.ICD10 like 'C81%'
    or t.ICD10 like 'C82%'
    or t.ICD10 like 'C83%'
    or t.ICD10 like 'C84%'
    or t.ICD10 like 'C85%'
    or t.ICD10 like 'C86%'
));
--Behn zu Zimmermann
update QUALITATIVER_BEFUND
set FK_QUALITATIVE_ID= 18
where FK_QUALITATIVE_FK=19
and FK_QUALITATIVE_ID=15
;   

--Sarah GallenCA Fälle zum Joker

update QUALITATIVER_BEFUND
set FK_QUALITATIVE_ID= 17 --JOKER
where FK_QUALITATIVE_FK=19
and FK_QUALITATIVE_ID=11
and exists( select 1 from 
tumor t 
where t.FK_PATIENTPAT_ID =QUALITATIVER_BEFUND.FK_VORHANDENE_DFK
and QUALITATIVER_BEFUND.FK_VORHANDENE_DDAT='Diagnose'
and QUALITATIVER_BEFUND.FK_VORHANDENE_DLFD=t.TUMOR_ID
and (t.ICD10 like 'C22%'
    or t.ICD10 like 'C23%'
    or t.ICD10 like 'C24%'
));

--Jules Lungen Ca zu Olaf
update QUALITATIVER_BEFUND
set FK_QUALITATIVE_ID= 19 --Olaf
where FK_QUALITATIVE_FK=19
and FK_QUALITATIVE_ID=4
and exists( select 1 from 
tumor t 
where t.FK_PATIENTPAT_ID =QUALITATIVER_BEFUND.FK_VORHANDENE_DFK
and QUALITATIVER_BEFUND.FK_VORHANDENE_DDAT='Diagnose'
and QUALITATIVER_BEFUND.FK_VORHANDENE_DLFD=t.TUMOR_ID
and (t.ICD10 like 'C33%'
    or t.ICD10 like 'C34%'
    or t.ICD10 like 'C37%'
    or t.ICD10 like 'C38%'
    or t.ICD10 like 'C39%'
    or t.ICD10 = 'D02.1'
    or t.ICD10 = 'D02.2'
    or t.ICD10 = 'D02.4'
));

--Jules Prostatan Ca zu Dörte
update QUALITATIVER_BEFUND
set FK_QUALITATIVE_ID= 14 --Dörthe
where FK_QUALITATIVE_FK=19
and FK_QUALITATIVE_ID=4
and exists( select 1 from 
tumor t 
where t.FK_PATIENTPAT_ID =QUALITATIVER_BEFUND.FK_VORHANDENE_DFK
and QUALITATIVER_BEFUND.FK_VORHANDENE_DDAT='Diagnose'
and QUALITATIVER_BEFUND.FK_VORHANDENE_DLFD=t.TUMOR_ID
and (t.ICD10 like 'C61%'

    or t.ICD10 = 'D07.5'
));

--JOKER Lungen Ca zu Olaf
update QUALITATIVER_BEFUND
set FK_QUALITATIVE_ID= 19 --Olaf
where FK_QUALITATIVE_FK=19
and FK_QUALITATIVE_ID=17
and exists( select 1 from 
tumor t 
where t.FK_PATIENTPAT_ID =QUALITATIVER_BEFUND.FK_VORHANDENE_DFK
and QUALITATIVER_BEFUND.FK_VORHANDENE_DDAT='Diagnose'
and QUALITATIVER_BEFUND.FK_VORHANDENE_DLFD=t.TUMOR_ID
and (t.ICD10 like 'C33%'
    or t.ICD10 like 'C34%'
    or t.ICD10 like 'C37%'
    or t.ICD10 like 'C38%'
    or t.ICD10 like 'C39%'
    or t.ICD10 = 'D02.1'
    or t.ICD10 = 'D02.2'
    or t.ICD10 = 'D02.4'
));
--rollback;
commit; 