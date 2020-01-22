update QUALITATIVER_BEFUND qba --Arbeitslisteninfos  
set qba.tag_der_messung=to_date('06.01.2020')
where  qba.FK_VORHANDENE_DDAT='Diagnose'
and qba.FK_QUALITATIVE_FK=19
and qba.FK_VORHANDENE_DFK in(

);
commit;
select to_date('06.01.2020') from dual;