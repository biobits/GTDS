

 --Medikamente hinterlegt. Beispiel an Doublette 114 Irinotecan
select * from INTERNISTISCHE_THERAPIE
where FK_PATIENTPAT_ID=1651;


--select * from ZYKLUS where FK_VORHANDENE_DFK=1651;
select * from ZYKLUS_GESAMT_MEDI order by ERSTELLUNGSDATUM desc;
 
 --Medikamente hinterlegt. Beispiel an Doublette 114 Irinotecan
select * from ZYKLUS_GESAMT_MEDI where FK_MEDIKAMENTABDA='114';
select * from  PROTOKOLL_MEDIKAMENT where FK_MEDIKAMENTMEDIK='114';
--Tabellen SCHMERZ_MEDIKATION ,PROTOKOLL_TAGESDOSIS,NEBENWIRKUNG,MEDIKAMENT_TAGESDO; --> erhalten keine Medikamentdaten ->keine Daten vorhanden

--Import der Liste des HKR
select * from TMP_SUBSTANZEN_HKR order by substanz;
--Doppelte Substanzen
select count(*) as anz, SUBSTANZ from TMP_SUBSTANZEN_HKR
group by SUBSTANZ having count(*) >1;
--delete from TMP_SUBSTANZEN_HKR;

--welche medis gibt es bereits in unserer liste (vergleich mit barta-liste)
select M.ABDA_NUMMER,M.GENERIC_NAME,M.EIGENE_BEZEICHNUNG,tmp.ATC_CODE,tmp.SUBSTANZ,tmp.HANDELSNAME,tmp.ART,tmp.INDIKATION
--select count(M.ABDA_NUMMER)-- anz,tmp.ATC_CODE,tmp.SUBSTANZ
from MEDIKAMENT M
inner join TMP_SUBSTANZEN_HKR tmp 
on ('%'||M.GENERIC_NAME||'%' like '%'||tmp.SUBSTANZ||'%' 
or '%'||M.EIGENE_BEZEICHNUNG||'%' like '%'||tmp.SUBSTANZ||'%')
and M.ABDA_NUMMER!=tmp.ATC_CODE
and tmp.SUBSTANZ!='Methotrexat'
--group by tmp.ATC_CODE,tmp.SUBSTANZ order by anz desc;
order by tmp.SUBSTANZ; 
/*
Irinotecan
Nivolumab
*/



select * from INTERNISTISCHE_THERAPIE where FK_PROTOKOLLPROTOK=427;
select distinct p.PROTOKOLL_ID,p.LANG_BEZEICHNUNG,p.AKTIV,m.ABDA_NUMMER,m.GENERIC_NAME,m.EIGENE_BEZEICHNUNG
from PROtokoll p
inner Join PROTOKOLL_MEDIKAMENT pm
on p.PROTOKOLL_ID=pm.FK_PROTOKOLLPROTOK
inner join MEDIKAMENT m
on m.ABDA_NUMMER=pm.FK_MEDIKAMENTMEDIK
where p.LANG_BEZEICHNUNG like '%Irinot%'

order by p.PROTOKOLL_ID;

