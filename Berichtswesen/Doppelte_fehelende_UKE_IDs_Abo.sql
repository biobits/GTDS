select distinct 'krebsregister@uke.de' as AN, 'ACHTUNG - Doppelte oder fehlende UKE-ID im GTDS' as Betreff
from (select PAT_ID, NAME,VORNAME,GEBURTSDATUM,PATIENTEN_ID,AENDERBENUTZER,FK_BENUTZERBENUTZE

from Patient where (PATIENTEN_ID
in (select PA.PATIENTEN_ID
from PATIENT PA
group by  PA.PATIENTEN_ID
having count(distinct PA.Pat_id)>1))

union
select PAT_ID, NAME,VORNAME,GEBURTSDATUM,PATIENTEN_ID,AENDERBENUTZER,FK_BENUTZERBENUTZE

from Patient where
  (PATIENT.PATIENTEN_ID is null and PATIENT.NAME<>'anonym') )Q;

