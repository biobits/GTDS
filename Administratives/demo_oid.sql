DEFINE skriptname=demo_oid
 /*
 
 */

PROMPT &skriptname

SET LINESIZE 9999
SET PAGESIZE 9999
SET TRIMSPOOL ON
SET ARRAYSIZE 1
SET SERVEROUTPUT ON SIZE 1000000
COLUMN zeitstempel NEW_VALUE zeitstempel

SELECT to_char(sysdate, 'yyyymmddhh24miss') zeitstempel FROM Dual
/

SPOOL &skriptname._&zeitstempel..txt

COLUMN Komplett  FORMAT A55
COLUMN Root      FORMAT A35
COLUMN Ohne_Root FORMAT A20
SELECT * FROM (
SELECT 
   pat_id,
   substr(oid.hole_OIDExtension_GTDS('PATIENT', to_char(p.Pat_ID)), length(oid.gtdsroot)+2) Ohne_Root,
   oid.hole_OIDExtension_GTDS('PATIENT', to_char(p.Pat_ID)) Komplett,
   oid.gtdsroot Root
  FROM patient p
 WHERE oid.hole_OIDExtension_GTDS('PATIENT', to_char(p.Pat_ID)) is not null
 )
 WHERE rownum <= 20
/

SPOOL OFF
