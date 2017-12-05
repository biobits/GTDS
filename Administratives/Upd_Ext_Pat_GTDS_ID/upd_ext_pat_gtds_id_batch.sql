SPOOL Upd_Ext_Pat_GTDS_ID.TXT append
PROMPT upd_ext_pat_gtds_id_batch.sql Version Dezember 2017
PROMPT
PROMPT Update Tabelle Externer_Patient -> Patienten ohne Link ins GTDS
PROMPT

merge into EXTERNER_PATIENT 
	using patient
	on (EXTERNER_PATIENT.PATIENTEN_ID = PATIENT.PATIENTEN_ID)
	when matched then update set EXTERNER_PATIENT.PAT_ID = PATIENT.PAT_ID
	where EXTERNER_PATIENT.PAT_ID is null
/
commit;
SPOOL OFF
EXIT 
