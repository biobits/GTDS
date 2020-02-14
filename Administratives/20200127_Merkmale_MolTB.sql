select * from qualitatives_merkmal
order by id desc;

insert into qualitatives_merkmal (ID,MERKMAL,BESCHREIBUNG,Arztbrief_DEFAULT,FK_Merkmalsklassecode,Aktiv)
Values (148,'Genmutation','Molekularpathologisch via Panel ermittelte Genmutationen','N','BEF','J');
--insert into qualitatives_merkmal (ID,MERKMAL,BESCHREIBUNG,Arztbrief_DEFAULT,FK_Merkmalsklassecode,Aktiv)
--Values (147,'Genamplifikation','Molekularpathologisch via Panel ermittelte Genmutationen','N','BEF','J');
insert into qualitatives_merkmal (ID,MERKMAL,BESCHREIBUNG,Arztbrief_DEFAULT,FK_Merkmalsklassecode,Aktiv)
Values (149,'Chromosomale Translokation','Molekularpathologisch via Panel ermittelte Genmutationen','N','BEF','J');
insert into qualitatives_merkmal (ID,MERKMAL,BESCHREIBUNG,Arztbrief_DEFAULT,FK_Merkmalsklassecode,Aktiv)
Values (150,'Evidenzlevel','Stufe der Evidenz einer empfohlenen Therapie','N','BEF','J');
insert into qualitatives_merkmal (ID,MERKMAL,BESCHREIBUNG,Arztbrief_DEFAULT,FK_Merkmalsklassecode,Aktiv)
Values (151,'Therapiesetting','Einordnung der Therapie','N','BEF','J');
insert into qualitatives_merkmal (ID,MERKMAL,BESCHREIBUNG,Arztbrief_DEFAULT,FK_Merkmalsklassecode,Aktiv)
Values (152,'Empfehlungsumsetzung','Angabe zur Umsetzung einer Therapieempfehlung aus Tumorboard','N','BEF','J');
insert into qualitatives_merkmal (ID,MERKMAL,BESCHREIBUNG,Arztbrief_DEFAULT,FK_Merkmalsklassecode,Aktiv)
Values (153,'Diagnostikplattform','Merkmal für molekulare Platform (Panel)','N','BEF','J');
insert into qualitatives_merkmal (ID,MERKMAL,BESCHREIBUNG,Arztbrief_DEFAULT,FK_Merkmalsklassecode,Aktiv)
Values (154,'Gewebeursprung','Ursprung des Gewebes für die molekulare Diagnostik','N','BEF','J');

commit;

insert into qualitative_auspraegung (ID,auspraegung,fk_qualitativesid) values();