

--Jana xy- Fälle zum Joker

update QUALITATIVER_BEFUND
set FK_QUALITATIVE_ID= 17 --JOKER
where FK_QUALITATIVE_FK=19
and FK_QUALITATIVE_ID=13 --Stripling
and exists( select 1 from 
tumor t 
where t.FK_PATIENTPAT_ID =QUALITATIVER_BEFUND.FK_VORHANDENE_DFK
and QUALITATIVER_BEFUND.FK_VORHANDENE_DDAT='Diagnose'
and QUALITATIVER_BEFUND.FK_VORHANDENE_DLFD=t.TUMOR_ID
and (t.ICD10 like 'C15%'
    or t.ICD10 like '16%'
    or t.ICD10 like 'C21%'
));

--rollback;
commit; 