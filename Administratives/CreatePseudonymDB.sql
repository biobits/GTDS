REM
REM Datenbankänderung
REM
CREATE TABLESPACE gtdspseudo 
       DATAFILE 'C:\Data\ORADATA\gtds\gtdspseudo.dat' SIZE 1000 M 
       AUTOEXTEND ON NEXT 50 M MAXSIZE unlimited;
/* rOLLEN WERDEN VERM: NICHT BENÖTIGT; DA SCHON VORHANDEN       
REM
REM Rollen
REM
PROMPT Anlegen der Rollen 
PROMPT r_normal_sys (Connect und Alter Session)
CREATE ROLE r_normal_sys 
;
GRANT	ALTER SESSION, 
	CREATE SESSION 
TO r_normal_sys
;


PROMPT r_super (Datenbankverwaltungsfunktionen für OPS$TUMSYS)
CREATE ROLE r_super
;
GRANT r_normal_sys TO r_super WITH ADMIN OPTION
/
GRANT 	CREATE PUBLIC SYNONYM,
	DROP   PUBLIC SYNONYM,
	CREATE ROLE, 
	CREATE TABLESPACE,
	ALTER  TABLESPACE,
	CREATE USER, 
	DROP   USER,
	ALTER  USER
TO r_super
/
GRANT SELECT ON Dba_Roles TO r_super
/
GRANT SELECT ON Dba_Role_Privs TO r_super
/
GRANT SELECT ON Role_Role_Privs TO r_super
/
GRANT SELECT ON Role_Sys_Privs TO r_super
/
GRANT SELECT ON Role_Tab_Privs TO r_super
/
GRANT SELECT ON Dba_Users TO r_super
/
PROMPT r_normal_obj_s (SELECT-Rechte auf OPS$TUMSYS-Objekte)
CREATE ROLE r_normal_obj_s 
/
GRANT r_normal_obj_s TO r_super WITH ADMIN OPTION
/
PROMPT r_normal_obj_du_meist (Datenänderungsrechte für OPS$TUMSYS-Tabellen mit Arbeitsdaten und EXECUTE für PROZEDUREN)
CREATE ROLE r_normal_obj_du_meist
/
GRANT r_normal_obj_du_meist TO r_super WITH ADMIN OPTION
/
PROMPT r_normal_obj_du_mind (Minimale Datenänderungsrechte für OPS$TUMSYS-Tabellen mit Arbeitsdaten und EXECUTE für PROZEDUREN)
CREATE ROLE r_normal_obj_du_mind
/
GRANT r_normal_obj_du_mind TO r_super WITH ADMIN OPTION
/
PROMPT r_normal_obj_du_klassi (Datenänderungsrechte für OPS$TUMSYS-Tabellen mit Klassifikationen)
CREATE ROLE r_normal_obj_du_klassi
/
GRANT r_normal_obj_du_klassi TO r_super WITH ADMIN OPTION
/
PROMPT r_normal_obj_du_verwalt (Datenänderungsrechte für OPS$TUMSYS-Tabellen mit Klassifikationen)
CREATE ROLE r_normal_obj_du_verwalt 
/
GRANT r_normal_obj_du_verwalt TO r_super WITH ADMIN OPTION
/
PROMPT r_normal_obj_du_sonst (Datenänderungsrechte für bestimmte sonstige OPS$TUMSYS-Tabellen)
CREATE ROLE r_normal_obj_du_sonst
/
GRANT r_normal_obj_du_sonst TO r_super WITH ADMIN OPTION
*/
REM
REM Initiale Benutzer
REM
PROMPT Anlegen des Benutzers ops$tumsys 
CREATE USER ops$pseudosys IDENTIFIED BY ncc1701
       DEFAULT TABLESPACE gtdspseudo QUOTA UNLIMITED ON gtdspseudo
       TEMPORARY TABLESPACE temp
;
PROMPT Rollenzuweisung für Benutzer ops$tumsys 
GRANT imp_full_database, exp_full_database  TO ops$pseudosys
;
GRANT r_super TO ops$pseudosys
;
GRANT EXECUTE ON dbms_crypto TO ops$pseudosys WITH GRANT OPTION
;
