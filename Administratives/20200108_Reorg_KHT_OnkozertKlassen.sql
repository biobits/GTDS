
--Prüfung

select kb.* from 
aw_klassenbedingung kb inner join aw_klasse k
on k.klassierung_quelle=kb.klassierung_quelle
and k.code=kb.code
and k.klassierung_id=kb.klassierung_id
where k.KLASSierung_QUELLE='UKE'
and k.klassierung_id=8
and k.CODE=40;
/*
select Code from AW_KLASSE k where k.KLASSierung_QUELLE='UKE'
and k.klassierung_id=8 order by to_number(Code) desc; 
*/

--Neue KLasse für Larynx einfügen
insert into aw_klasse (KLASSIERUNG_ID,CODE,TEXT255,KLASSIERUNG_QUELLE)
values(8,210,'Larynx','UKE');

commit;
--Transfer der Larynxlokalisationen
update aw_klassenbedingung 
set code=210
where klassierung_id=8
and klassierung_quelle='UKE'
and CODE=40
and like_kriterium in ('32%');
commit;

--Nicht vergessen: Larynx/Pharynx in "Rachen" umbenennen (manuell in GTDS)