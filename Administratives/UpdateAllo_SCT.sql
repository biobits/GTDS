--Update der allogenen STammzelltheraie als KMT

select * from THERAPIE_SCHRITT where
BEZEICHNUNG like '%Allo%'and
OPERATION='N' and  CHEMO='N' and BESTRAHLUNG='N' and HORMON='N' and IMMUN='N' and KMT='N' and SONSTIGE='N'


;

update THERAPIE_SCHRITT
set KMT='J'
where
BEZEICHNUNG like '%Allo%' and 
OPERATION='N' and CHEMO='N' and BESTRAHLUNG='N' and HORMON='N' and IMMUN='N' and KMT='N' and SONSTIGE='N';
commit;

select * from THERAPIE_SCHRITT where
--BEZEICHNUNG like '%Allo%'and
 OPERATION='N' and CHEMO='N' and BESTRAHLUNG='N' and HORMON='N' and IMMUN='N' and KMT='N' and SONSTIGE='N';