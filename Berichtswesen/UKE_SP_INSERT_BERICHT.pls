CREATE OR REPLACE PROCEDURE UKE_SP_INSERT_BERICHT 
(
  PATID IN NUMBER 
, TUMID IN VARCHAR2 
, BERICHTSNAME IN VARCHAR2
, DATENART IN VARCHAR2 
, LFDNR IN NUMBER 
, BENUTZER IN VARCHAR2 
, BERICHTSTYP IN VARCHAR2 default 'UKE'
) AS 
BEGIN
  insert into BERICHTE (Pat_ID,TUMOR_ID,DATUM,ART_DES_BRIEFES,DATENART,DOKUMENTLFDNR,FK_BENUTZER_ID)
  values (PATID,TUMID,SYSDATE,BERICHTSTYP||'_'||BERICHTSNAME,DATENART,LFDNR,BENUTZER)
  ;
  --commit; -- WICHTIG ist das commit der aufrufenden Prizedur/Funktion zu setzten!!
END UKE_SP_INSERT_BERICHT;
