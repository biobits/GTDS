--Nele zu Jule
update QUALITATIVER_BEFUND
set FK_QUALITATIVE_ID= 4
where FK_QUALITATIVE_FK=19
and FK_QUALITATIVE_ID=12
and exists( select 1 from 
tumor t 
where t.FK_PATIENTPAT_ID =QUALITATIVER_BEFUND.FK_VORHANDENE_DFK
and QUALITATIVER_BEFUND.FK_VORHANDENE_DDAT='Diagnose'
and QUALITATIVER_BEFUND.FK_VORHANDENE_DLFD=t.TUMOR_ID
and (t.ICD10 like 'C33%'
    or t.ICD10 like 'C34%'
));

--Evis F�lle

update QUALITATIVER_BEFUND
set FK_QUALITATIVE_ID= 14
where FK_QUALITATIVE_FK=19
and FK_QUALITATIVE_ID=6
and exists( select 1 from 
tumor t 
where t.FK_PATIENTPAT_ID =QUALITATIVER_BEFUND.FK_VORHANDENE_DFK
and QUALITATIVER_BEFUND.FK_VORHANDENE_DDAT='Diagnose'
and QUALITATIVER_BEFUND.FK_VORHANDENE_DLFD=t.TUMOR_ID
and (t.ICD10 like 'C48%'
    or t.ICD10 like 'C60%'
    or t.ICD10 like 'C61%'
    or t.ICD10 like 'C62%'
    or t.ICD10 like 'C64%'
    or t.ICD10 like 'C65%'
    or t.ICD10 like 'C66%'
    or t.ICD10 like 'C67%'
    or t.ICD10 like 'C68%'
    or t.ICD10 like 'C74%'
    or t.ICD10 like 'D07.4'
    or t.ICD10 like 'D07.6'
    or t.ICD10 like 'D09.0'
    or t.ICD10 like 'D09.1'
));

--Sarahs Gastros zu Jana
update QUALITATIVER_BEFUND
set FK_QUALITATIVE_ID= 13
where FK_QUALITATIVE_FK=19
and FK_QUALITATIVE_ID=11
and exists( select 1 from 
tumor t 
where t.FK_PATIENTPAT_ID =QUALITATIVER_BEFUND.FK_VORHANDENE_DFK
and QUALITATIVER_BEFUND.FK_VORHANDENE_DDAT='Diagnose'
and QUALITATIVER_BEFUND.FK_VORHANDENE_DLFD=t.TUMOR_ID
and (t.ICD10 like 'C15%'
    or t.ICD10 like 'C16%'
    or t.ICD10 like 'C17%'
    or t.ICD10 like 'C21%'
    or t.ICD10 like 'C25%'
    or t.ICD10 like 'C26%'
));

-- C44 jana zu annlena

update QUALITATIVER_BEFUND
set FK_QUALITATIVE_ID= 15
where FK_QUALITATIVE_FK=19
and FK_QUALITATIVE_ID=13
and exists( select 1 from 
tumor t 
where t.FK_PATIENTPAT_ID =QUALITATIVER_BEFUND.FK_VORHANDENE_DFK
and QUALITATIVER_BEFUND.FK_VORHANDENE_DDAT='Diagnose'
and QUALITATIVER_BEFUND.FK_VORHANDENE_DLFD=t.TUMOR_ID
and (t.ICD10 like 'C44%'

));

-- C43 Jule zu annlena

update QUALITATIVER_BEFUND
set FK_QUALITATIVE_ID= 15
where FK_QUALITATIVE_FK=19
and FK_QUALITATIVE_ID=4
and exists( select 1 from 
tumor t 
where t.FK_PATIENTPAT_ID =QUALITATIVER_BEFUND.FK_VORHANDENE_DFK
and QUALITATIVER_BEFUND.FK_VORHANDENE_DDAT='Diagnose'
and QUALITATIVER_BEFUND.FK_VORHANDENE_DLFD=t.TUMOR_ID
and (t.ICD10 like 'C43%'

));
commit; 