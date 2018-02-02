DECLARE
  P_FULLNAME_ARZT VARCHAR2(200);
  P_ERSTANFRAGESTICHTAG DATE;
  P_VERSCHICKTSTICHTAG DATE;
  P_ABSCHLUSSSTICHTAG DATE;
  P_NACHFRAGEDATEN SYS_REFCURSOR;
BEGIN
  P_FULLNAME_ARZT := 'Prieske, Katharina';
  P_ERSTANFRAGESTICHTAG := to_date('2018-01-23','yyyy-MM-dd');
  P_VERSCHICKTSTICHTAG := to_date('2018-01-20','yyyy-MM-dd');
  P_ABSCHLUSSSTICHTAG := NULL;--to_date('2018-01-10','yyyy-MM-dd');
  P_NACHFRAGEDATEN := NULL;

  UKE_SP_GET_NACHFRAGE_ZERT_DATA(
    P_FULLNAME_ARZT => P_FULLNAME_ARZT,
    P_ERSTANFRAGESTICHTAG => P_ERSTANFRAGESTICHTAG,
    P_VERSCHICKTSTICHTAG => P_VERSCHICKTSTICHTAG,
    P_ABSCHLUSSSTICHTAG => P_ABSCHLUSSSTICHTAG,
    P_NACHFRAGEDATEN => P_NACHFRAGEDATEN
  );
  /* Legacy output: 
DBMS_OUTPUT.PUT_LINE('P_NACHFRAGEDATEN = ' || P_NACHFRAGEDATEN);
*/ 
  :P_NACHFRAGEDATEN := P_NACHFRAGEDATEN; --<-- Cursor
--rollback; 
END;