
-- EIntrag des Merkmals
Insert into Qualitatives_Merkmal (ID, MERKMAL, Beschreibung,FK_MERKMALSKLASSECODE,AKTIV)
  values(129,'DKTK-Export','Merkmal für die Indentifizierung von Patienten mit EInwilligung zum Forschungsdatenaustausch','BEF','J')
;
Insert into QUALITATIVE_AUSPRAEGUNG (FK_QUALITATIVESID,ID,AUSPRAEGUNG,BESCHREIBUNG)
  values (129,1,'J','Ja');
Insert into QUALITATIVE_AUSPRAEGUNG (FK_QUALITATIVESID,ID,AUSPRAEGUNG,BESCHREIBUNG)
  values (129,2,'N','Nein');
commit;

--3 Testpatienten für den Export
-- 25506 Mamma-ca
-- 23714 Ovar-Ca
-- 27286 Lymphom

insert into QUALITATIVER_BEFUND (FK_QUALITATIVE_FK,FK_QUALITATIVE_ID,FK_PATIENTPAT_ID,FK_VORHANDENE_DFK,FK_VORHANDENE_DLFD,FK_VORHANDENE_DDAT,LFDNR )
  values(129,1,25506,25506,1,'Diagnose',99);
insert into QUALITATIVER_BEFUND (FK_QUALITATIVE_FK,FK_QUALITATIVE_ID,FK_PATIENTPAT_ID,FK_VORHANDENE_DFK,FK_VORHANDENE_DLFD,FK_VORHANDENE_DDAT,LFDNR )
  values(129,1,23714,23714,1,'Diagnose',99);
insert into QUALITATIVER_BEFUND (FK_QUALITATIVE_FK,FK_QUALITATIVE_ID,FK_PATIENTPAT_ID,FK_VORHANDENE_DFK,FK_VORHANDENE_DLFD,FK_VORHANDENE_DDAT,LFDNR )
  values(129,1,27286,27286,1,'Diagnose',99)
;
commit;
--select * from Qualitativer_befund where FK_VORHANDENE_DFK=25506 ;



Select * from
AUSWERTUng
where 
 exists
  (select 1 FROM QUALITATIVER_BEFUND qb 
          WHERE 
          AUSWERTUNG.TUMOR_ID=qb.FK_VORHANDENE_DLFD
          and AUSWERTUng.PAT_ID =qb.FK_VORHANDENE_DFK
            AND qb.Fk_Qualitative_Fk = 129 --28        -- Merkmal ist Primärfall
            and qb.FK_QUALITATIVE_ID=1
            AND qb.Fk_Vorhandene_DDAT = 'Diagnose' )
            
--and icd10 like 'C50%'
order by PAT_ID desc
;
--34348,35460,36707
--- Neues Merkmal: "DKTK-Einwilligung" Text: "Einwilligung zum Forschungsdatenaustausch mit DKTK" ID:129 Ja=1