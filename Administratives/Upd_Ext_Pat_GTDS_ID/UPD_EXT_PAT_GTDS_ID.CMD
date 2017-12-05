SETLOCAL

REM CD - Befehl muß angepaßt werden.

set tab=	

set INFO=Update %tab%%date%%tab%%time%

REM CD  /D  C:\gtds\Maintainance_GTDS\Upd_Ext_Pat_GTDS_ID
CD  /D  E:\gtds\Maintainance_GTDS\Upd_Ext_Pat_GTDS_ID
 
ECHO %INFO% >> Upd_Ext_Pat_GTDS_ID.TXT

IF NOT EXIST upd_ext_pat_gtds_id_batch.sql EXIT 1

SQLPLUS.EXE  OPS$TUMSYS/ucch3fast4U@XE @upd_ext_pat_gtds_id_batch


