
SET PAGESIZE 0


spool MeldeanlaesseBereitsExportiert.txt


PROMPT --#########################################
PROMPT --# DIAGNOSE
PROMPT --#########################################

PROMPT TYP | ID1 | ID2
select distinct ZUORDNUNG_TYP||' | '|| ZUORDNUNG_ID1||' | '||ZUORDNUNG_ID2 Dokument
from
EXPORT_DATENSATZ ed inner join Tumor
  on TUMOR.Tumor_Id= ed.ZUORDNUNG_ID2 and TUMOR.FK_PATIENTPAT_ID=ed.ZUORDNUNG_ID1 
where EXPORT_TYP='GKR_EXPORT' and EXPORTDATUM is not null and ZUORDNUNG_TYP='TUMOR' and TUMOR.MELDEANLASS is null

/

merge into TUMOR
  using (select distinct ZUORDNUNG_ID1,ZUORDNUNG_ID2 from EXPORT_DATENSATZ  where ZUORDNUNG_TYP='TUMOR' and EXPORTDATUM is not null
  and EXPORT_TYP='GKR_EXPORT')ed
  on (TUMOR.Tumor_Id= ed.ZUORDNUNG_ID2 and TUMOR.FK_PATIENTPAT_ID=ed.ZUORDNUNG_ID1 )
  when matched then update set MELDEANLASS='keine_meldung'
  where TUMOR.MELDEANLASS is null
  
/
 
PROMPT --#########################################
PROMPT --# OPERATION
PROMPT --#########################################

PROMPT TYP | ID1 | ID2
select distinct ZUORDNUNG_TYP||' | '|| ZUORDNUNG_ID1||' | '||ZUORDNUNG_ID2 Dokument
from
EXPORT_DATENSATZ ed inner join OPERATION
on OPERATION.OP_NUMMER= ed.ZUORDNUNG_ID2 and OPERATION.FK_TUMORFK_PATIENT=ed.ZUORDNUNG_ID1
where EXPORT_TYP='GKR_EXPORT' and EXPORTDATUM is not null and ZUORDNUNG_TYP='OPERATION' and OPERATION.MELDEANLASS is null

/

merge into OPERATION
  using (select distinct ZUORDNUNG_ID1,ZUORDNUNG_ID2 from EXPORT_DATENSATZ  where ZUORDNUNG_TYP='OPERATION' and EXPORTDATUM is not null
  and EXPORT_TYP='GKR_EXPORT')ed
  on (OPERATION.OP_NUMMER= ed.ZUORDNUNG_ID2 and OPERATION.FK_TUMORFK_PATIENT=ed.ZUORDNUNG_ID1 )
  when matched then update set MELDEANLASS='keine_meldung'
  where OPERATION.MELDEANLASS is null

/
 
PROMPT --#########################################
PROMPT --# BESTRAHLUNG
PROMPT --#########################################

PROMPT TYP | ID1 | ID2
select distinct ZUORDNUNG_TYP||' | '|| ZUORDNUNG_ID1||' | '||ZUORDNUNG_ID2 Dokument
from
EXPORT_DATENSATZ ed inner join BESTRAHLUNG
on BESTRAHLUNG.LFDNR= ed.ZUORDNUNG_ID2 and BESTRAHLUNG.FK_TUMORFK_PATIENT=ed.ZUORDNUNG_ID1
where EXPORT_TYP='GKR_EXPORT' and EXPORTDATUM is not null and ZUORDNUNG_TYP='BESTRAHLUNG' and BESTRAHLUNG.MELDEANLASS is null

/

merge into BESTRAHLUNG
  using (select distinct ZUORDNUNG_ID1,ZUORDNUNG_ID2 from EXPORT_DATENSATZ  where ZUORDNUNG_TYP='BESTRAHLUNG' and EXPORTDATUM is not null
  and EXPORT_TYP='GKR_EXPORT')ed
  on (BESTRAHLUNG.LFDNR= ed.ZUORDNUNG_ID2 and BESTRAHLUNG.FK_TUMORFK_PATIENT=ed.ZUORDNUNG_ID1 )
  when matched then update set MELDEANLASS='keine_meldung'
  where BESTRAHLUNG.MELDEANLASS is null
/



PROMPT --#########################################
PROMPT --# VERLAUF
PROMPT --#########################################

PROMPT TYP | ID1 | ID2
select distinct ZUORDNUNG_TYP||' | '|| ZUORDNUNG_ID1||' | '||ZUORDNUNG_ID2 Dokument
from
EXPORT_DATENSATZ ed inner join VERLAUF
on VERLAUF.LFDNR= ed.ZUORDNUNG_ID2 and VERLAUF.FK_TUMORFK_PATIENT=ed.ZUORDNUNG_ID1
where EXPORT_TYP='GKR_EXPORT' and EXPORTDATUM is not null and ZUORDNUNG_TYP='VERLAUF' and  VERLAUF.MELDEANLASS is null

/
  
merge into VERLAUF
  using (select distinct ZUORDNUNG_ID1,ZUORDNUNG_ID2 from EXPORT_DATENSATZ  where ZUORDNUNG_TYP='VERLAUF' and EXPORTDATUM is not null
  and EXPORT_TYP='GKR_EXPORT')ed
  on (VERLAUF.LFDNR= ed.ZUORDNUNG_ID2 and VERLAUF.FK_TUMORFK_PATIENT=ed.ZUORDNUNG_ID1 )
  when matched then update set MELDEANLASS='keine_meldung'
  where VERLAUF.MELDEANLASS is null
  
/

PROMPT --#########################################
PROMPT --# ABSCHLUSS
PROMPT --#########################################

PROMPT TYP | ID1 | ID2
select distinct ZUORDNUNG_TYP||' | '|| ZUORDNUNG_ID1||' | '||ZUORDNUNG_ID2 Dokument
from
EXPORT_DATENSATZ ed inner join ABSCHLUSS
 on ABSCHLUSS.LFDNR= ed.ZUORDNUNG_ID2 and ABSCHLUSS.FK_PATIENTPAT_ID=ed.ZUORDNUNG_ID1 
where EXPORT_TYP='GKR_EXPORT' and EXPORTDATUM is not null and ZUORDNUNG_TYP='ABSCHLUSS' and ABSCHLUSS.MELDEANLASS is null

/
  
merge into ABSCHLUSS
  using (select distinct ZUORDNUNG_ID1,ZUORDNUNG_ID2 from EXPORT_DATENSATZ  where ZUORDNUNG_TYP='ABSCHLUSS' and EXPORTDATUM is not null
  and EXPORT_TYP='GKR_EXPORT')ed
  on (ABSCHLUSS.LFDNR= ed.ZUORDNUNG_ID2 and ABSCHLUSS.FK_PATIENTPAT_ID=ed.ZUORDNUNG_ID1 )
  when matched then update set MELDEANLASS='keine_meldung'
  where ABSCHLUSS.MELDEANLASS is null
  
/
 

spool off;  

rollback;