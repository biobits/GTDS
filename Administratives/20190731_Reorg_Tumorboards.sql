select distinct Ort from Konsil order by ORT;
select * from eigene_merkmale  where merkmal='KONSIL.ORT' order by beschreibung;

--Pflege ASV Tumorboard
update KOnsil
set Ort='ASV Tumorboard'
where upper(Ort) like 'ASV%';

--Pflege GI Tumorboard
update KOnsil
set Ort='GI Tumorboard'
where upper(Ort) like 'GI%' or upper(Ort) like '%GI%';

--Pflege CHIR Tumorboard
update KOnsil
set Ort='CHIR Tumorboard'
where upper(Ort) like 'CHIR%' or upper(Ort) like '%CHIR%';

--Pflege Gyn Tumorboard
update KOnsil
set Ort='GYN Tumorboard'
where upper(Ort) like 'GYN%';

--Pflege Derma Tumorboard
update KOnsil
set Ort='DERMA Tumorboard'
where upper(Ort) like 'DERMA%';

--Pflege Molekulares  Tumorboard
update KOnsil
set Ort='Molekulares Tumorboard'
where upper(Ort) like 'MOLEK%' or upper(Ort) like '%MOLEK%';

--PflegeMyelom  Tumorboard
update KOnsil
set Ort='Lymphom- und Myelomboard'
where upper(Ort) like '%MYELOM%' or upper(Ort) like 'MYELOM%' or upper(Ort) like 'LYMPHO%';

--Pflege Neuro Tumorboard
update KOnsil
set Ort='NEURO Tumorboard'
where upper(Ort) like 'NEURO%' ;

--Pflege Int. Onko. Tumorboard
update KOnsil
set Ort='ONKO Tumorboard'
where upper(Ort) like '%ONKO%' or upper(Ort) like 'ONKO%';

--Pflege Thorax Tumorboard
update KOnsil
set Ort='THORAX Tumorboard'
where upper(Ort) like 'THORAX%' ;

--Pflege Leber Tumorboard
update KOnsil
set Ort='LEBER Tumorboard'
where upper(Ort) like 'LEBER%' or  upper(Ort) like '%LEBER%' ;

--Pflege Leukämie Tumorboard
update KOnsil
set Ort='Leukämie Tumorboard'
where upper(Ort) like 'LEUKÄMIE%' ;

--Pflege Inter.Therapie Empf. Tumorboard -ALT
update KOnsil
set Ort='Inter.Therapie Empf.'
where upper(Ort) like '%EMPFEHLUNG%' ;

--Pflege Tele Tumorboard
update KOnsil
set Ort='TELE Tumorboard'
where upper(Ort) like 'TELE%' ;

--Pflege Net Tumorboard
update KOnsil
set Ort='NET Tumorboard'
where upper(Ort) like 'NET%' ;

--Pflege Uro Tumorboard
update KOnsil
set Ort='Urologie Tumorboard'
where upper(Ort) like 'URO%' ;

--Pflege Sarkom Tumorboard
update KOnsil
set Ort='Sarkom Tumorboard'
where upper(Ort) like 'SARKOM%' ;

--Pflege Prostata Tumorboard
update KOnsil
set Ort='Prostata Tumorboard'
where upper(Ort) like 'PROSTATA%' ;

--Pflege Kopf-Hals Tumorboard
update KOnsil
set Ort='Kopf-Hals Tumorboard'
where upper(Ort) like 'KOPF-HALS%' ;

--Pflege Extern Tumorboard
update KOnsil
set Ort='EXTERN Tumorboard'
where upper(Ort) like 'EXTERN%' or upper(Ort) like '%EXTERN%'  ;

--rollback;
--commit; 