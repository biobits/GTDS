/*
Prüfung auf Medikamente, die noch nicht genutzt werden
select * from MEDIKAMENT order by ABDA_NUMMER;
where not exists (select * from PROTOKOLL_MEDIKAMENT P where P.FK_MEDIKAMENTMEDIK=M.ABDA_NUMMER)
and not exists (select * from ZYKLUS_GESAMT_MEDI Z where Z.FK_MEDIKAMENTABDA=M.ABDA_NUMMER);

*/
--- select * from MEDIKAMENT order by ABDA_NUMMER;
--- select * from TMP_SUBSTANZEN_HKR;


--## Zunächst alte Medikamente, und Zuordnungstabellen Sichern

create table TMP_MEDIKAMENT_BAK
as
select * from MEDIKAMENT;

create table TMP_ZYKLUS_GESAMT_MEDI_BAK
as select * from ZYKLUS_GESAMT_MEDI; 

create table TMP_PROTOKOLL_MEDIKAMENT_BAK
as select * from PROTOKOLL_MEDIKAMENT;


--## doppelte Medis löschen
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
insert into tmp_medi_reorg values('94','102');

commit;

--## Update der Protokolle und der bereits dokumentierten Substanzen sowie abschliesendes löschen der doppelten Substanz
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
   commit;
   end loop; 
end;

drop table TMP_MEDI_REORG ;

--## Doppelte Substanz ENDE


-- Barta-Liste mit eigenen Medis Matchen und dann die erolgreich identifizierten in schleife ersetzen
  create table tmp_medi_match
  as
  select M.ABDA_NUMMER,M.GENERIC_NAME,M.EIGENE_BEZEICHNUNG,M.DIMENSION,M.INFORMATION,tmp.ATC_CODE,tmp.SUBSTANZ,tmp.HANDELSNAME,tmp.ART,tmp.INDIKATION
  from MEDIKAMENT M
  inner join TMP_SUBSTANZEN_HKR tmp 
  on ('%'||M.GENERIC_NAME||'%' like '%'||tmp.SUBSTANZ||'%' 
  or '%'||M.EIGENE_BEZEICHNUNG||'%' like '%'||tmp.SUBSTANZ||'%')
  and M.ABDA_NUMMER!=tmp.ATC_CODE
  and tmp.SUBSTANZ!='Methotrexat'
  order by tmp.SUBSTANZ; 
commit;
-- select * from tmp_medi_match order by SUBSTANZ;
-- drop table tmp_medi_match;
--jetzt mal ordentlich durchschleifen und aktualisieren, was so geht
  declare cursor c_match is select * from tmp_medi_match;
  v_atcnum number; 
  begin
    for r_match in c_match loop
    -- zunächst prüfen, ob wir den zugewiesenen ATC-Code schon in der DB haben
     select count(*) into v_atcnum from MEDIKAMENT where ABDA_NUMMER=r_match.ATC_CODE;
     IF (v_atcnum>0) THEN 
      update MEDIKAMENT
        set EIGENE_BEZEICHNUNG=SUBSTR(r_match.HANDELSNAME,0,30),ADTGEKID_ART=r_match.ART,INFORMATION=case when (r_match.INFORMATION is null) then r_match.INDIKATION else r_match.INFORMATION||'; '||r_match.INDIKATION end
          where ABDA_NUMMER= r_match.ATC_CODE;
     ELSE
        insert into MEDIKAMENT (ABDA_NUMMER,GENERIC_NAME,EIGENE_BEZEICHNUNG,ADTGEKID_ART,INFORMATION,DIMENSION) 
          values(r_match.ATC_CODE,r_match.SUBSTANZ,substr(r_match.HANDELSNAME,0,30),r_match.ART,
            case when (r_match.INFORMATION is null) then r_match.INDIKATION else r_match.INFORMATION||'; '||r_match.INDIKATION end,r_match.DIMENSION) ; 
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
     commit;
     end loop; 
  end;


drop table tmp_medi_match;

--## BARTA Liste ende


--##Einfügen der neuen Medikamente


/* Für suche nach dubletten in Barta Liste
create table tmp_medi_test (
   ATC varchar2(25),
   SUBSTANZ varchar2(30)
);
insert into tmp_medi_test ...
select ATC,count(*) as anz from tmp_Medi_test group by ATC order by anz desc;
*/
insert into MEDIKAMENT (ABDA_NUMMER,GENERIC_NAME,EIGENE_BEZEICHNUNG,INFORMATION,ADTGEKID_ART)
select  ts.ATC_CODE,ts.SUBSTANZ,SUBSTR(ts.HANDELSNAME,0,30),ts.INDIKATION,ts.ART 
from TMP_SUBSTANZEN_HKR ts
where ts.ATC_CODE not in (select ME.ABDA_NUMMER from MEDIKAMENT ME);
commit;


--## Restliche Medikamente abarbeiten

select count(*) from TMP_SUBSTANZEN_HKR ;
select count(*) from Medikament order by abda_nummer;

--## Nochmaliges abarbeiten doppelter Substanzen
 create table tmp_medi_reorg (
   MedID_Cur varchar2(25),
   MedID_Del varchar2(25)
);
insert into tmp_medi_reorg values('M05BA03','37');
insert into tmp_medi_reorg values('M05BA08','22');
insert into tmp_medi_reorg values('L01XC08','140');
insert into tmp_medi_reorg values('L03AX03','14');
insert into tmp_medi_reorg values('L01XB01','39');
insert into tmp_medi_reorg values('V03AF03','48');
insert into tmp_medi_reorg values('L01DA01','71');
insert into tmp_medi_reorg values('L01BC02','8');
insert into tmp_medi_reorg values('L01AD04','106');
insert into tmp_medi_reorg values('L01CB01','16');
insert into tmp_medi_reorg values('L01BA01','36');
commit;
-- mit cursor alle Medis aktualiseren /löschen
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
   commit;
   end loop; 
end;

drop table TMP_MEDI_REORG ;

--## Ende abschließendes Ersetzen doppelter Substanzen

-- # Prüfen, welche Medikamente noch mit "alter" ID vorhanden sind. Diese müssen per Hand aktualisiert werden
 select * from MEDIKAMENT order by ABDA_NUMMER;

/* zurückspielen der Daten
truncate table MEDIKAMENT;
insert into MEDIKAMENT
select * from TMP_MEDIKAMENT_BAK;

truncate table ZYKLUS_GESAMT_MEDI;
insert into ZYKLUS_GESAMT_MEDI
select * from TMP_ZYKLUS_GESAMT_MEDI_BAK;

truncate table PROTOKOLL_MEDIKAMENT;
Insert into PROTOKOLL_MEDIKAMENT 
select * from TMP_PROTOKOLL_MEDIKAMENT_BAK; 
commit;

*/

--## Abschließende Prüfung auf verwaiste EInträge
select * from PROTOKOLL_MEDIKAMENT P where  exists (select * from MEDIKAMENT M where P.FK_MEDIKAMENTMEDIK=M.ABDA_NUMMER);

select * from ZYKLUS_GESAMT_MEDI Z  where not  exists(select * from  MEDIKAMENT M where Z.FK_MEDIKAMENTABDA=M.ABDA_NUMMER);

