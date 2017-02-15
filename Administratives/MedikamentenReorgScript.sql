--doppelte Medis löschen
-- tabelle der doppelten erstellen
 create table tmp_medi_reorg (
   MedID_Cur varchar2(25),
   MedID_Del varchar2(25)
);
insert into tmp_medi_reorg values('6','114');
insert into tmp_medi_reorg values('6','146');
insert into tmp_medi_reorg values('43','23');
insert into tmp_medi_reorg values('140','77');
insert into tmp_medi_reorg values('11','67');
insert into tmp_medi_reorg values('59','40');
insert into tmp_medi_reorg values('8','26');
insert into tmp_medi_reorg values('16','35');
insert into tmp_medi_reorg values('2','53');
insert into tmp_medi_reorg values('61','13');
insert into tmp_medi_reorg values('52','47');
insert into tmp_medi_reorg values('52','60');
insert into tmp_medi_reorg values('52','10');
insert into tmp_medi_reorg values('52','75');
insert into tmp_medi_reorg values('97','NIVOLUMAB');

declare cursor c_medi is select * from tmp_medi_reorg;
begin
  for r_match in c_medi loop
  
  --einzelmedis updaten
    update
    ZYKLUS_GESAMT_MEDI 
    set FK_MEDIKAMENTABDA =r_match.MedID_Cur
    where FK_MEDIKAMENTABDA=r_match.MedID_Del;
  -- Protokolle updaten
    update PROTOKOLL_MEDIKAMENT
    set FK_MEDIKAMENTMEDIK=r_match.MedID_Cur where FK_MEDIKAMENTMEDIK=r_match.MedID_Del;
   -- altes medikament löschen
   delete from MEDIKAMENT where ABDA_NUMMER=r_match.MedID_Del;
   end loop; 
end;

--truncate table TMP_MEDI_REORG ;


-- Barta-Liste mit eigenen Medis Matchen und dann in schleife ersetzen
  create table tmp_medi_match
  as
  select M.ABDA_NUMMER,M.GENERIC_NAME,M.EIGENE_BEZEICHNUNG,tmp.ATC_CODE,tmp.SUBSTANZ,tmp.HANDELSNAME,tmp.ART,tmp.INDIKATION
  from MEDIKAMENT M
  inner join TMP_SUBSTANZEN_HKR tmp 
  on ('%'||M.GENERIC_NAME||'%' like '%'||tmp.SUBSTANZ||'%' 
  or '%'||M.EIGENE_BEZEICHNUNG||'%' like '%'||tmp.SUBSTANZ||'%')
  and M.ABDA_NUMMER!=tmp.ATC_CODE
  and tmp.SUBSTANZ!='Methotrexat'
  order by tmp.SUBSTANZ; 

--jetzt mal ordentlich durchschleifen und aktualisieren, was so geht
  declare cursor c_match is select * from tmp_medi_match;
  v_atcnum number; 
  begin
    for r_match in c_match loop
    -- zunächst prüfen, ob wir den zugewiesenen ATC-Code schon in der DB haben
     select count(*) into v_atcnum from MEDIKAMENT where ABDA_NUMMER=r_match.ATC_CODE;
     IF (v_atcnum>0) THEN 
      update MEDIKAMENT
        set EIGENE_BEZEICHNUNG=SUBSTR(r_match.HANDELSNAME,0,30),ADTGEKID_ART=r_match.ART,INFORMATION=case when (INFORMATION is null) then r_match.INDIKATION else INFORMATION end
          where ABDA_NUMMER= r_match.ATC_CODE;
     ELSE
        insert into MEDIKAMENT (ABDA_NUMMER,GENERIC_NAME,EIGENE_BEZEICHNUNG,ADTGEKID_ART,INFORMATION) 
          values(r_match.ATC_CODE,r_match.SUBSTANZ,substr(r_match.HANDELSNAME,0,30),r_match.ART,r_match.INDIKATION) ; 
     END IF;
    --einzelmedis updaten
      update
      ZYKLUS_GESAMT_MEDI 
      set FK_MEDIKAMENTABDA =r_match.ATC_CODE
      where FK_MEDIKAMENTABDA=r_match.ABDA_NUMMER;
    -- Protokolle updaten
      update PROTOKOLL_MEDIKAMENT
      set FK_MEDIKAMENTMEDIK=r_match.ATC_CODE where FK_MEDIKAMENTMEDIK=r_match.ABDA_NUMMER;
     -- altes medikament löschen
     delete from MEDIKAMENT where ABDA_NUMMER=r_match.ABDA_NUMMER;
     end loop; 
  end;


select * from MEDIKAMENT;
rollback;

commit;