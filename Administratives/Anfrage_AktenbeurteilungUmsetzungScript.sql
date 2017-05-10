/*
Umsetzung des Merkmals Aktenbeurteilung-> fehlende Daten auf das Merkmal Anfrage

*/
/*
create table qual_bef_siebzig
as
select * from QUALITATIVER_BEFUND
where FK_QUALITATIVE_FK=70
and FK_QUALITATIVE_ID=2;
*/

--## Update der Protokolle und der bereits dokumentierten Substanzen sowie abschliesendes löschen der doppelten Substanz
declare cursor c_qual is select * from QUALITATIVER_BEFUND
                            where FK_QUALITATIVE_FK=70
                            and FK_QUALITATIVE_ID=2;
 lf_nr number;
begin
  for r_match in c_qual loop
  
  --laufende nr des pat bestimmen
  select max(lfdnr) into lf_nr  from QUALITATIVER_BEFUND where FK_VORHANDENE_DFK=r_match.FK_VORHANDENE_DFK;
  
  --für jeden datensatz eine neuer Eintrag mit Merkmal Anfrage
    insert into qualitativer_befund (BEMERKUNG,TAG_DER_MESSUNG,FK_QUALITATIVE_FK,FK_QUALITATIVE_ID,FK_PATIENTPAT_ID,FK_VORHANDENE_DFK,FK_VORHANDENE_DLFD
                               ,FK_VORHANDENE_DDAT,ARZTBRIEF ,FK_BENUTZERBENUTZE ,LFDNR,AENDERUNGSDATUM,ERSTELLUNGSDATUM )
    values(r_match.BEMERKUNG,r_match.TAG_DER_MESSUNG,79,1,r_match.FK_PATIENTPAT_ID,r_match.FK_VORHANDENE_DFK,r_match.FK_VORHANDENE_DLFD
                               ,r_match.FK_VORHANDENE_DDAT,r_match.ARZTBRIEF ,r_match.FK_BENUTZERBENUTZE,lf_nr+1,r_match.AENDERUNGSDATUM,r_match.ERSTELLUNGSDATUM);
    
  -- Aktenbeurteilung löschen
    delete from QUALITATIVER_BEFUND where 
    FK_QUALITATIVE_FK = r_match.FK_QUALITATIVE_FK and
    FK_QUALITATIVE_ID= r_match.FK_QUALITATIVE_ID and
    FK_VORHANDENE_DFK= r_match.FK_VORHANDENE_DFK and
    FK_VORHANDENE_DLFD= r_match.FK_VORHANDENE_DLFD and
    FK_VORHANDENE_DDAT= r_match.FK_VORHANDENE_DDAT
    and LFDNR =r_match.LFDNR 
    ;
   
   end loop; 
   
end;
-- commit;
-- rollback;




