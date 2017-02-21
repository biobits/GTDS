--------------------------------------------------------
--  DDL for Table TMP_SUBSTANZEN_HKR
--------------------------------------------------------
drop table  "OPS$TUMSYS"."TMP_SUBSTANZEN_HKR" ;

  CREATE TABLE "OPS$TUMSYS"."TMP_SUBSTANZEN_HKR" 
   (	"ATC_CODE" VARCHAR2(26 BYTE), 
	"SUBSTANZ" VARCHAR2(128 BYTE), 
	"HANDELSNAME" VARCHAR2(256 BYTE), 
	"ART" VARCHAR2(128 BYTE), 
	"INDIKATION" VARCHAR2(256 BYTE)
   ) ;

SET DEFINE OFF

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01DB04', 'Aclarubicin', 'Aclacin, Aclacinomycine, Aclacinon, Aclaplastin, Jaclacin', 'C', 'Experimentelle Krebstherapie');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01DA01', 'Actinomycin D', 'Actinomycin D, Cosmegen Lyovac', 'C', 'Ewing Sarkom, Weichteilsarkome');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XX44', 'Aflibercept', 'Zaltrap', 'C', 'mCRC');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XX22', 'Alitretinoin', 'Toctino', 'C', 'Kaposi-Sarkom');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XX03', 'Altretamin', 'Hexalen', 'C', 'Ovar');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XD04', 'Aminolevulinsäure', 'Ameluz, Alacare, Gliolan', 'C', 'Haut, Glioblastom');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01DB10', 'Amrubicin', 'Calsed', 'C', 'SCLC');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XX01', 'Amsacrin', 'Amsidyl', 'C', 'AML, ALL ');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XX35', 'Anagrelid', 'Xagrid, Agrylin, Thromboreductin', 'C', 'MPN (PV, ET, CML, OMF)');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XX27', 'Arsentrioxid', 'Trisenox', 'C', 'APL');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XX02', 'Asparaginase', 'Asparaginase medac, Erwinase, Kidrolase', 'C', 'ALL');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XE17', 'Axitinib', 'Inlyta', 'Z', 'NCC');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01BC07', 'Azacitidin', 'Vidaza, Azacytidin, 5-Azacytidin', 'C', 'AML, MDS');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01AA09', 'Bendamustin', 'Ribomustin, Levact', 'C', 'NHLs, MCL, CLL, MM,  aggressive HDs, Mamma, SCLC');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XX25', 'Bexaroten', 'Targretin, Cephalon, Targretin', 'C', 'T-NHL, kutanen T-Zell-Lymphoms');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01DC01', 'Bleomycin', 'Bleomycin Hexal, Bleomedac, Bleocin, Bleo-cell', 'C', 'Keimzell (Hoden), Hodgkin, NHL, Melanom');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XE14', 'Bosutinib', 'Bosulif', 'C', 'CML');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01AB01', 'Busulfan', 'Myleran, Busilvex', 'C', 'CML, Konditionierungstherapie vor Stammzelltransplantation');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01CD04', 'Cabazitaxel', 'Jevtana', 'C', 'Prostata');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01BC06', 'Capecitabin', 'Xeloda', 'C', 'endokrine Pankreas, Mamma, Neuroendokrine-GIT, mCRC');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XA02', 'Carboplatin', 'Paraplatin, Axicarb, Carbo-cell, Carbomedac, Haemato-carb, Neocarbo, Ribocarbo ', 'C', 'NSCLC, Mesotheliome, Kopf-Hals, Ovar + Tuben, Zervix, Weichteilsarkome, Mamma, Hoden');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01AC03', 'Carboquon', NULL, 'C', 'Lunge');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01BC04', 'Carmofur', NULL, 'C', 'Mamma, CRC');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01AD01', 'Carmustin ', 'Carmubris, BCNU, Bis-Chlorethyl-Nitroso-Urea, Gliadel (Implantat)', 'C', 'Gliome (Camustin-Implantat), ZNS-Lymphome, MM, Lymphsystem-NPLs, GI-NPLs');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01AA02', 'Chlorambucil', 'Leukeran', 'C', 'MCL, FL, CLL');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01AA05', 'Chlormethin', 'Mechlorethamin', 'C', 'HD, Lymphosarkom, Bronchial, CML, CLL');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XA01', 'Cisplatin', 'Sinplatin, Platidiam, Platinex, Cis-GRY', 'C', 'Harnblase, NSCLC, SCLC, Mesotheliome, HCC/CCC, endokrine Pankreas, Medulloblastom, Osteosarkom, Nasopharynx, Kopf-Hals, Keimzell, Vulva, Zervix, Melanom, Neuroendokrine-GIT, Weichteilsarkome, Hodgkin');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01BB04', 'Cladribin', 'Leustatin, Litak 10', 'C', 'HCL, B-CLL, FL');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01BB06', 'Clofarabin', 'Clofarabinum, Evoltra', 'C', 'ALL');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XE16', 'Crizotinib', 'Xalkori', 'Z', 'Bronchial (nur ALK-positiven NSCLC) ');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01AA01', 'Cyclophosphamid', 'Cyclo-Mob-1d, Cyclo-Mob-2d, Endoxan, Ind1Cyclo', 'C', 'Weichteilsarkome, Mamma, Ewing Sarkom, ALL, AML, HD, NHLs, Konitionierungstherapie vor allogener Stammzelltransplantation, Mobilisierung von Stammzellen zur Stammzellapherese');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01BC01', 'Cytarabin', 'Alexan,  Cytosin-Arabinosid, Cytarabin, Depocyte, Cytosar', 'C', 'ALL, AML, MDS, NHLs');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01AX04', 'Dacarbazin', 'Detimedac, DTIC mono', 'C', 'Melanom, Weichteilsarkome, HD, ');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XE06', 'Dasatinib', 'Sprycel', 'Z', 'CML, ALL');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01DB02', 'Daunorubicin', 'Daunoblastin, DNR, Rubidomycin, DA', 'C', 'ALL, AML');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01BC08', 'Decitabin', 'Dacogen', 'C', 'AML');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01CC01', 'Demecolcin', 'KaryoMAX', 'C', 'Leukämie');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XX29', 'Denileukin diftitox', 'Ontak', 'C', 'T-NHL');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01CD02', 'Docetaxel', 'Taxotere, Docetax, Taxol', 'C', 'Magen + AEG, NSCLC, Kopf-Hals, Mamma, Prostata, Weichteilsarkome');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01DB01', 'Doxorubicin ', 'Adriamycin, Caelyx, Myocet, DXR, Adriamycin, ADR', 'C', 'Harnblase (intravesikal), HCC/CCC, endokrine Pankreas, Osteosarkom, Mamma, Ewing Sarkom, Neuroendokrine-GIT, Schilddrüse, Weichteilsarkome, ALL, Hodgkin, Ovarial + Tuben, Karposi Sarkom');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XD06', 'Efaproxiral', NULL, 'C', 'Hirnmetastasen');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01DB03', 'Epirubicin', 'Farmorubicin, Epilem, Episindan, Axirubicin-e, Bendaepi, Epi-cell, Riboepi', 'C', 'Mamma, NHLs, Sarkome, Magen etc.');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XX41', 'Eribulin', 'Halaven', 'C', 'Mamma');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XE03', 'Erlotinib', 'Tarceva', 'Z', 'NSCLC, Pankreas');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XX11', 'Estramustin', 'Estracyt, Medactin', 'C', 'Prostata');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01AG01', 'Etoglucid', NULL, 'C', 'Blase, GI');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01CB01', 'Etoposid ', 'Vepesid K, Etoposidphosphat, Etomedac, Riboposid, Etosid, Lastet, VP 16', 'C', 'SCLC, endokrine Pankreas, Ewing Sarkom, Keimzell, Neuroendokrine-GIT, Weichteilsarkome, Hodgkin, NHLs');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01BB05', 'Fludarabin', 'Fludara', 'C', 'NHLs, CLL, Leukämien, Konitionierungstherapie vor allogener Stammzelltransplantation');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01BC02', 'Fluorouracil', '5-FU, Ribofluor, Efudix, Verrumal, Fluorouracil 5, Fluorouracil Accor ', 'C', 'exokrine Pankreas, endokrine Pankreas, Kopf-Hals, Vulva, Neuroendokrine-GIT');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01AD05', 'Fotemustin', 'Muphoran', 'C', 'mMelanom');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XE02', 'Gefitinib', 'Iressa', 'C', 'NSCLC (mit EGFR-Mutation)');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01BC05', 'Gemcitabin', 'Gemzar', 'C', 'NSCLC, Mesotheliome, exokrine Pankreas, Ovarial + Tuben, Mamma, Keimzell, Weichteilsarkome');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XX05', 'Hydroxycarbamid ', 'Litalir, Syrea, Hydrea, Hydroxyurea, Hydroxyharnstoff', 'C', 'MPN (CML, PV, ET, CML, OMF)');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XE27', 'Ibrutinib', 'Imbruvica', 'C', 'B-NHL, CLL');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01DB06', 'Idarubicin', 'Zavedos ', 'C', 'AML, APL');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XX47', 'Idelalisib', 'Zydelig', 'C', 'CLL, FL');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01AA06', 'Ifosfamid', 'Holoxan', 'C', 'Osteosarkom, Ewing Sarkom, Keimzell, Weichteilsarkome');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XE01', 'Imatinib', 'Glivec', 'Z', 'GIST, Weichteilsarkome, ALL, CML');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('D06BB10', 'Imiquimod', 'Aldara', 'C', 'Basalzell');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XX19', 'Irinotecan', 'Axinotecan, Campto, Arinotec ', 'C', 'Kolon, experimentelle Krebstherapie (Zervix, Ösophagus, Magen etc.)');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01DC04', 'Ixabepilon', 'Ixempra', 'C', 'mMamma');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XE07', 'Lapatinib', 'Tyverb, Tykerb', 'C', 'Mamma (HER2/neu positiv)');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01CA02', 'liposomales Vincristin', 'Marqibo, Oncovin, Vincasar,  Vincrex', 'C', 'B-NHL, ALL');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01AD02', 'Lomustin', 'Cecenu, CCNU, CCUN, Chlorethyl-Cyclohexyl-Nitroso-Urea', 'C', 'Medulloblastom, Melanom');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XX07', 'Lonidamin', NULL, 'C', 'NSCLC');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01AB03', 'Mannosulfan', NULL, 'C', 'Experimentelle Krebstherapie');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XX10', 'Masoprocol', NULL, 'C', 'Experimentelle Krebstherapie (Tyrosininhibitor für IGF-1R und c-erbB2/HER2/neu)');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01AA03', 'Melphalan', 'Alkeran', 'C', 'Ewing Sarkom, MM, Ovar, Mamma, Melanom, Weichteilsarkom der Extremitäten, Polycythaemia rubra vera, Konditionierung zur Stammzelltransplantation');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01BB02', 'Mercaptopurin', 'Puri Nethol, Purinethol', 'C', 'ALL, APL, AML');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01BA01', 'Methotrexat', 'MTX, Metex, Lantarel', 'C', 'Osteosarkom, Kopf-Hals, ALL, APL, ZNS-LymphomeUrothel der Harnblase, Mamma, Medulloblastom, Ependymom, NHLs');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XD07', 'Methoxsalen', 'Methoxsalen-Creme', 'C', 'kutanes T-Zell-Lymphom');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XD03', 'Methylaminolevulinat', 'Metvix', 'C', 'Basaliom, Morbus Bowen');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XX09', 'Miltefosin', 'Miltex', 'C', 'maligne Hautveränderungen Mamma');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01AX01', 'Mitobronitol', NULL, 'C', 'Experimentelle Krebstherapie');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XX16', 'Mitoguazon', NULL, 'C', 'HD, NHLs');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01DC03', 'Mitomycin', 'Mitomycin C, Ametycine, Mitem, Urocin, MitoF-medac', 'C', 'Harnblasen-/Nierenbecken-/Ureterkarzinome (intravesikal), Kopf-Hals, Osteosarkom, GI, Lunge, Pankreas, CRC (Anal), Mamma, Leberzell, Zervix, Ösophagus');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XX23', 'Mitotan', NULL, 'C', 'NNR');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01DB07', 'Mitoxantron', 'Novantron, Onkotrone', 'C', 'AML, MCL, FL');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01CD01', 'Nab-Paclitaxel', 'Abraxane', 'C', 'mPankreas, mMamma, mNSCLC');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01BB07', 'Nelarabin', 'Atriance', 'C', 'T-ALL, T-LBL');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XE08', 'Nilotinib', 'Tasigna', 'Z', 'GIST, ALL, CML');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01AD06', 'Nimustin ', 'ACNU', 'C', 'maligne Gliome');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XX36', 'Oblimersen', 'Genasense', 'C', 'CLL, B-Zell-Lymphom, Mamma');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XX40', 'Omacetaxin mepesuccinat', 'Tekinex', 'C', 'CML ');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XA03', 'Oxaliplatin', 'Eloxatin, Oxalatoplatin, Oxaliplatin Actav', 'C', 'Keimzell, Kolon, Magen');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01CD01', 'Paclitaxel', 'Taxol, Sindaxel, Genexol, Pacliteva, Paclitaxin', 'C', 'NSCLC, Kopf-Hals; Mamma, Keimzell (Ovarial), Zervix, Melanom, Weichteilsarkome');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01CD03', 'Paclitaxel poliglumex', 'Opaxio, Xyotax', 'C', 'NSCLC');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XE11', 'Pazopanib', 'Votrient', 'Z', 'mNCC ');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XX24', 'Peg-Asparginase', 'Oncaspar', 'C', 'ALL');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01DB01', 'pegyliert-liposomales Doxorubicin', 'Caelyx', 'C', 'Ovarial + Tuben, Karposi Sarkom');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01BA04', 'Pemetrexed', 'Alimta', 'C', 'NSCLC, Mesotheliome');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XX08', 'Pentostatin', 'Nipent', 'C', 'HCL');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01AX02', 'Pipobroman', 'Vercite, Vercyte', 'C', 'ET');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01DB08', 'Pirarubicin', NULL, 'C', 'analog Doxorubicin');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01DB11', 'Pixantron', 'Pixuvri', 'C', 'B-NHL');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01DC02', 'Plicamycin', 'Mithracin', 'C', 'CML, Hoden, Morbus Paget');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XA05', 'Polyplatillen', NULL, 'C', 'Experimentelle Krebstherapie');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XE24', 'Ponatinib', 'Iclusig', 'C', 'CML, ALL');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XD01', 'Porfimer natrium', 'PhotoBarr (nicht länger zugelassen)', 'C', 'zur Abtragung von hochgradigen Dysplasien;  wird in Kombination mit kaltem, rotem Laserlicht verwendet (photodynamische Therapie)');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01AA08', 'Prednimustin', NULL, 'C', 'Experimentelle Krebstherapie');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XB01', 'Procarbazin', 'Natulan', 'C', 'Hodgkin');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01BA03', 'Raltitrexed', 'Tomudex', 'C', 'mCRC');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01AD07', 'Ranimustin', NULL, 'C', 'T-Zell-Lymphom');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XE21', 'Regorafenib', 'Stivarga', 'Z', 'M-Kolon, GIST, CRC');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XX39', 'Romidepsin', NULL, 'C', 'T-Zell-Lymphom');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XE18', 'Ruxolitinib', 'Jakafi, Jakavi', 'Z', 'ALL, PV, MF');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XA04', 'Satraplatin', NULL, 'C', 'mProstata');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01AD03', 'Semustin', NULL, 'C', 'ZNS-Metastasen bei Melanom');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XX37', 'Sitimagen ceradenovec', 'Cerepro', 'C', 'Gliome');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XE05', 'Sorafenib', 'Nexavar', 'Z', 'Schilddrüse, Weichteilsarkome, GIST, HCC');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XE04', 'Sunitinib', 'Sutent', 'Z', 'Schilddrüse, Weichteilsarkome, GIST, mNCC, pNET');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01BC53', 'Tegafur, Kombination', 'UFT, Teysuno', 'C', 'mMamma, mMagen, mDarm');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XD05', 'Temoporfin', 'Foscan', 'C', 'Plattenepithelkarzinomen im Kopf- und Nackenbereich');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01AX03', 'Temozolomid', 'Temodal, Temomedac', 'C', 'Gliome, Melanom, Weichteilsarkome');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01CB02', 'Teniposid', 'Vumon, VM26', 'C', 'ALL');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01AC01', 'Thiotepa', 'Tepadina', 'C', 'ZNS-Lymphome');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XX18', 'Tiazofurin', NULL, 'C', 'Leukämie');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01BB03', 'Tioguanin', 'Lanvis', 'C', 'ALL, AML, CML');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XX17', 'Topotecan', 'Hycamtin', 'C', 'SCLC, Ovarial + Tuben, Zervix, Weichteilsarkome');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01CX01', 'Trabectedin ', 'Yondelis, Ecteinascidin, ET-743', 'C', 'Weichteilsarkome');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01AB02', 'Treosulfan', 'Ovastat', 'C', 'Ovarial + Tuben, Ewing Sarkom, Melanom');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XX14', 'Tretinoin', 'Vesanoid, all-trans-Retinsäure', 'C', 'APL');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01AC02', 'Triaziquon', NULL, 'C', 'Experimentelle renale Krebstherapie');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01AA07', 'Trofosfamid', 'Ixoten', 'C', 'Weichteilsarkome, CLL, CML, NHLs (Lymphosarkom, Retikulosarkom usw.), Plasmozytom, M. Waldenström, Ovarial, Mamma, SCLC, Seminom');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01DB09', 'Valrubicin', 'Valstar', 'C', 'Harnblase (intravesikal)');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XE12', 'Vandetanib', 'Caprelsa', 'C', 'Schilddrüse');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XE15', 'Vemurafenib', 'Zelboraf', 'Z', 'Melanom');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01CA01', 'Vinblastin', 'Velbe, Cytoblastin', 'C', 'Keimzell, Hodgkin, NHLs, HCL, mMamma, Weichteilsarkome');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01CA02', 'Vincristin', 'Cellcristin, Cytocristin', 'C', 'Medulloblastom, Ewing Sarkom, Melanom, ALL, Hodgkin, NHLs');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01CA03', 'Vindesin', 'Eldisine', 'C', 'Melanom, AML, Blastenschub bei CML, Lymphome, NSCLC');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01CA05', 'Vinflunin', 'Javlor', 'C', 'Harnblase (Urothel)');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01CA04', 'Vinorelbin', 'Bendarelbin, Navelbine, Vinorelbin ebewe, Vinorelbin Actavis, N', 'C', 'NSCLC, Mesotheliome, Mamma, Weichteilsarkome');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XX38', 'Vorinostat', 'Zolinza', 'C', 'kutanes T-Zell-Lymphom, Darm');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01DB05', 'Zorubicin', NULL, 'C', 'Experimentelle Krebstherapie');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L02BX01', 'Abarelix', 'Plenaxis', 'H', 'mProstata');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L02BX03', 'Abirateron', 'Abirateronacetat, Zytiga', 'H', 'Prostata (kastrationsresistent)');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L02BG01', 'Aminoglutethimid', 'Orimeten', 'H', 'Mamma');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L02BG03', 'Anastrozol', 'Arimidex, Anaromat, Anadex, Anablock', 'H', 'Mamma');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L02BB03', 'Bicalutamid', 'Casodex, Bicalutin, Bicusan', 'H', 'Prostata');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L02AE01', 'Buserelin', 'Profact Depot, Suprefact, Metrelef, Buserelinacetat ', 'H', 'Prostata');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('G03HA01', 'Cyproteron', 'Androcur, Virilit, Cyproteronacetat', 'H', 'Prostata');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L02BX02', 'Degarelix', 'Firmagon', 'H', 'Prostata');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L02BB04', 'Enzalutamid', 'Xtandi', 'H', 'Prostata');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L02BG06', 'Exemestan', 'Aromasin, Exemedac, Exestan', 'H', 'Mamma');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('G04CB01', 'Finasterid', 'Alof?n, Androfin, Crinormin, FinaHAIR, Finamed, Finascar, Finastad, Finasterax, Finural, Prezepa, Propecia, Proscar, Prosmin, zahlreiche Generika', 'H', 'Prostata (benigne BPH)');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L02BB01', 'Flutamid', 'Flumid, Fugerel, Flucinom, Flutasin', 'H', 'Prostata');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L02BG02', 'Formestan', 'Lenterol', 'H', 'Mamma');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L02AA04', 'Fosfestrol', 'Honvan', 'H', 'Prostata');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L02BA03', 'Fulvestrant', 'Faslodex', 'H', 'Mamma');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L02AB03', 'Gestonoron', 'Depostat', 'H', 'Mamma, Endometrium, Prostata');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L02AE03', 'Goserelin', 'Zoladex', 'H', 'Prostata, Mamma');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L02AE05', 'Histrelin', 'Vantas', 'H', 'Prostata, Leiomyome');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('G01AF11', 'Ketoconazol', 'Nizoral', 'H', 'Prostata');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('H01CB03', 'Lanreotid', 'Somatuline', 'H', 'endokrine Pankreas, Neuroendokrine-GIT');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L02BG04', 'Letrozol', 'Femara, Letrozol Nucleus, Letromedac, Letrohexal, Letroblock', 'H', 'Mamma');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L02AE02', 'Leuprorelin', 'Trenantone, Enantone, Sixantone, Eligard, Leupron, Lucrin depot, Leuprorelinacetat', 'H', 'Prostata, Mamma');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('H03AA51', 'Levothyroxin', 'L-Thyroxin', 'H', 'Schilddrüse');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('G03AC02', 'Lynestrenol', 'Ovostat', 'H', 'Endometrium');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('G03DA02', 'Medroxyprogesteron', 'Farlutal', 'H', 'Mamma, Endometrium, Prostata, NCC');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L02AB02', 'Medroxyprogesteronacetat', 'MPA, Medroxyprogesteron', 'H', 'Endometrium, Prostata, Mamma');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L02AB01', 'Megestrol', 'Megestat, Megace, Megestrolacetat', 'H', 'Endometrium, Mamma');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L02BB02', 'Nilutamid', 'Anandron, Nilandron ', 'H', 'Prostata');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('H01CB02', 'Octreotid', 'Sandostatin', 'H', 'endokrine Pankreas, Neuroendokrine-GIT');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L02AA02', 'Polyestradiolphosphat', 'Estradurin', 'H', 'Prostata');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('H02AB07', 'Prednison', 'Decortin, Predni Tablinen, Rectodelt, diverse Generika', 'H', 'Tumortherapie');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('G03XC01', 'Raloxifen', 'Evista, Optruma', 'H', 'Mamma');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L02BA01', 'Tamoxifen', 'Nolvadex, Istubal, Valodex, Tamox, Tamifen, Tam 20', 'H', 'Endometrium, Mamma');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('G04CA02', 'Tamsulosin', 'Tam, Aglandin, Alna, Flomax, Omnic, Omix, Pradif, Prostacure, Prostadil, Prostalitan, Stichtulosin, Tadin, zahlreiche Generika', 'H', 'Prostata (benigne BPH)');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L02BA02', 'Toremifen', 'Fareston', 'H', 'Mamma post Menopause');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L02AE04', 'Triptorelin', 'Decapeptyl, Diphereline, Diphereline SR, Pamorelin', 'H', 'Prostata');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L02BG05', 'Vorozol', 'Rivizor', 'H', 'Mamma post Menopause');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('V10XX02', '[90Y]Ibritumomab tiuxetan', 'Zevalin', 'I', 'B-Zell-Lymphom');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L04AA24', 'Abatacept', 'Orencia', 'I', 'Experimentelle Krebstherapie;  (in Kombination mit Methotrexat)');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L04AA22', 'Abetimus', NULL, 'I', 'Experimentelle Krebstherapie');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L04AB04', 'Adalimumab', 'Humira', 'I', 'Experimentelle Krebstherapie');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L04AB03', 'Afelimomab', NULL, 'I', 'Experimentelle Krebstherapie');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L03AC01', 'Aldesleukin', 'Proleukin S, IL-2, Interleukin-2', 'I', 'mNiere');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L04AA15', 'Alefacept', NULL, 'I', 'kutane T-Zell-Lymphome + T-NHLS');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XC04', 'Alemtuzumab', 'MabCampath', 'I', 'CLL');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L04AC03', 'Anakinra', 'Kineret', 'I', 'Experimentelle Krebstherapie');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L04AA03', 'Antilymphozyt. Immunglobulin', 'ATG', 'I', 'GvHD-Prophylaxe/-Behandlung (Leukämien, Lymphome, MM)');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L04AX01', 'Azathioprin', 'Imurek', 'I', 'Transplantatabstoßung ');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L04AC02', 'Basiliximab', 'Simulect', 'I', 'Transplantatabstoßung ');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L03AX03', 'BCG (Bacill. Calmette-Guérin)', 'Tice', 'I', 'Harnblase');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L04AA28', 'Belatacept', 'Nulojix', 'I', 'Transplantatabstoßung ');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L04AA26', 'Belimumab', NULL, 'I', 'ALL');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XC07', 'Bevacizumab', 'Avastin', 'I', 'NCC, NSCLC, endokrine Pankreas, Mamma, Gliome, Neuroendokrine-GIT');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XX32', 'Bortezomib', 'Velcade', 'I', 'MM');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XC12', 'Brentuximab vedotin', 'Adcetris', 'I', 'Hodgkin');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L04AC09', 'Briakinumab', NULL, 'I', 'Experimentelle Krebstherapie');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L04AC08', 'Canakinumab', NULL, 'I', 'Experimentelle Krebstherapie');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XX45', 'Carfilzomib', 'Kyprolis', 'I', 'MM');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XC09', 'Catumaxomab', 'Removab', 'I', 'malignem Aszites bei Krebs');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L04AB05', 'Certolizumab pegol', 'Cimzia', 'I', 'mBlase');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XC06', 'Cetuximab ', 'Erbitux', 'I', 'Kopf-Hals, CRC');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L04AD01', 'Ciclosporin', 'Cyclosporin, Cicloral, Immunosporin, SandimmunOptoral', 'I', 'Transplantatabstoßung ');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XE23', 'Dabrafenib', 'Tafinlar', 'I', 'Melanom, HCL');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L04AC01', 'Daclizumab', 'Zenapax', 'I', 'Transplantatabstoßung ');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('M05BX04', 'Denosumab', 'Prolia, Xgeva', 'I', 'Mamma');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L04AA25', 'Eculizumab', 'Soliris', 'I', 'Experimentelle Krebstherapie');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XC01', 'Edrecolomab', 'Panorex ', 'I', 'CRC');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L04AA21', 'Efalizumab', NULL, 'I', 'Experimentelle Krebstherapie');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L04AB01', 'Etanercept', 'Enbrel', 'I', 'Experimentelle Krebstherapie');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L04AA18', 'Everolimus', 'Certican, Zortress, Afinitor', 'I', 'NCC, Mamma, Hodgkin');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L04AA27', 'Fingolimod', 'Gilenya', 'I', 'Transplantatabstoßung ');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XC05', 'Gemtuzumab-Ozogamicin', 'Mylotarg', 'I', 'AML');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L04AB06', 'Golimumab', NULL, 'I', 'Experimentelle Krebstherapie');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L04AA19', 'Gusperimus', NULL, 'I', 'Experimentelle Krebstherapie');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('J06BA', 'Immunglobuline, normal human', 'Kiovig, Privigen', 'I', 'CLL, MM, Stammzelltransplantation');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L04AB02', 'Infliximab', 'Remicade', 'I', 'Experimentelle Krebstherapie');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L03AB01', 'Interferon alpha natürlich', 'Roferon A ', 'I', 'NCC, Neuroendokrine-GIT, PV, ET, HCL, mMelanom ');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L03AB04', 'Interferon alpha-2a', NULL, 'I', 'Stimulation der T-Lymphozyten');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L03AB05', 'Interferon alpha-2b', 'Realdiron, Intron A', 'I', 'Stimulation der T-Lymphozyten');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L03AB03', 'Interferon gamma', 'Imukin', 'I', 'Stimulation der T-Lymphozyten');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XC11', 'Ipilimumab', 'Yervoy', 'I', 'Melanom');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XX50', 'Ixazomib', NULL, 'I', 'MM');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L04AA13', 'Leflunomid', 'Leflunomid Winthrop', 'I', 'Experimentelle Krebstherapie');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L04AX04', 'Lenalidomid', 'Revlimid', 'I', 'MM, B-CLL');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L04AC06', 'Mepolizumab', 'Nucala', 'I', 'Experimentelle Krebstherapie');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L04AX03', 'Methotrexat', 'MTX', 'I', 'ZNS-Lymphome, ALL, Mamma, NHL, Urothel, Medulloblastom, Ependymom, Osteosarkom');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L03AX15', 'Mifamurtid', 'Mepact', 'I', 'Osteosarkom (Immunstimulans)');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L04AA02', 'Muromonab-CD3', 'Orthoclone-OKT3 ', 'I', 'Transplantatabstoßung ');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L04AA06', 'Mycophenolsäure', 'Myfortic', 'I', 'Transplantatabstoßung ');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L04AA23', 'Natalizumab', 'Tysabri', 'I', 'Experimentelle Krebstherapie');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XC17', 'Nivolumab', 'Opdivo', 'I', 'NCC, NSCLC, Melanom, Hodgkin');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XC15', 'Obinutuzumab', 'Gazyvaro, GA101', 'I', 'CLL, NHL');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XC10', 'Ofatumumab', 'Arzerra', 'I', 'CLL, DBCL, FL');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XC08', 'Panitumumab', 'Vectibix', 'I', 'mCRC, ');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L03AB10', 'Peginterferon alpha-2b', 'Pegasys, PegIntron', 'I', 'Melanom');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XC18', 'Pembrolizumab', 'Keytruda', 'I', 'Melanom');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XC13', 'Pertuzumab', 'Perjeta', 'I', 'Mamma');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L04AX05', 'Pirfenidon ', 'Esbriet', 'I', 'Experimentelle Krebstherapie');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L04AX06', 'Pomalidomid', 'Imnovid, Pomalyst', 'I', 'MM');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XC21', 'Ramucirumab', 'Cyramza', 'I', 'Magen, Ösophagus');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L04AC04', 'Rilonacept', 'Arcalyst', 'I', '?');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XC02', 'Rituximab', 'MabThera', 'I', 'ALL, B-NHL, Lymphome, CLL');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L04AA10', 'Sirolimus', 'Rapamune, Rapamycin', 'I', 'Transplantatabstoßung ');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L04AD02', 'Tacrolimus', 'FK506, FK-506', 'I', 'Transplantatabstoßung ');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L03AX11', 'Tasonermin', 'Beromun', 'I', 'Weichtelsarkom');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XE09', 'Temsirolimus', 'Torisel', 'I', 'NCC, NHL, MCL, NCC');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L04AX02', 'Thalidomid', 'Contergan, Softenon', 'I', 'MM, NHL, Lymphome');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L04AC07', 'Tocilizumab', 'RoActemra', 'I', 'Experimentelle Krebstherapie');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XE25', 'Trametinib', NULL, 'I', 'mMelanom');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XE38', 'Cobimetinib', NULL, 'I', 'Advanced melanoma with a BRAF V600E or V600K mutation');
  	 
INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XC03', 'Trastuzumab', 'Herceptin, Emtansine, Kadcyla', 'I', 'Magen + AEG, Mamma');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XX43', 'Vismodegib', 'Erivedge', 'I', 'mBasalzell');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L04AD03', 'Voclosporin', 'Luveniq', 'I', 'Transplantatabstoßung ');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('M05BA04', 'Alendronsäure', 'Fosamax, Alendronsäure', 'S', 'Osteolysen');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('M05BA02', 'Clodronsäure', 'Ostac, Bonefos, Sindronat', 'S', 'Osteolysen');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('B03XA02', 'Darbepoetin alfa', 'Aranesp', 'S', 'rekombinantes EPO, stimuliert die Bildung roter Blutkörperchen');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('H02AB02', 'Dexamethason', 'Dexamethason, Dexaven, Prednisolon F', 'S', 'ALL, Hodgkin, MM, NHL');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('B03XA01', 'Erythropoietin', 'Neo Recormon, Eprex', 'S', 'EPO, stimuliert die Bildung roter Blutkörperchen');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('M05BA01', 'Etidronsäure', 'Didronel, Diphos', 'S', 'Osteolysen');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L03AA02', 'Filgrastim', 'Neupogen, Tevagrastim', 'S', 'AML, ALL, Hodgkin,');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('V03AF03', 'Folinsäure', 'Leukovorin', 'S', 'Osteosarkom, Kopf-Hals');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('A04AA02', 'Granisetron', 'Kytril, Rasetron', 'S', 'Antiemetikum (CINV)');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L03AX14', 'Histamin dihydrochlorid', 'Ceplene', 'S', 'AML (während der ersten Remission [post Chemo])');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('M05BA06', 'Ibandronsäure', 'Bondronat ', 'S', 'Osteolysen');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L03AA10', 'Lenograstim', 'Granocyte', 'S', 'ALL, AML, Hodgkin');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('B03XA03', 'Meth.-Polyethylengl.-Epoetin b', 'Mircera', 'S', 'EPO, stimuliert die Bildung roter Blutkörperchen');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('H02AB04', 'Methylprednisolon', 'Methyprednisolon sophar, Solu Medrol, Depo Medrol, Medrol, Methyprednisolon cortic, Methylprednisolon', 'S', 'Krebstherapie');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L03AA03', 'Molgramostim', 'Leucomax', 'S', 'GM-CSF (granulocyte-macrophage colony stimulating factor)');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('A04AA01', 'Ondansetron', 'Zofran, Zondaron', 'S', 'Antiemetikum (CINV)');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('A04AA05', 'Palonosetron', 'Aloxi', 'S', 'Antiemetikum (CINV)');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('M05BA03', 'Pamidronsäure', 'Aredia, Pamitor', 'S', 'Osteolysen');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L03AA13', 'Pegfilgrastim', 'Neulasta, Neupopen', 'S', 'G-CSF, ALL, AML, Hodgkin');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L03AX16', 'Plerixafor', 'Mozobil', 'S', 'Stammzellmobilisierung vor Apherese');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01BA05', 'Pralatrexat', 'Folotyn (nicht länger zugelassen)', 'S', 'T-Zell-Lymphom');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('H02AB06', 'Prednisolon', 'Prednisolon Cortic, Prednisolon', 'S', 'Krebstherapie');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('M05BA07', 'Risedronsäure', 'Actonel', 'S', 'Osteolysen');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('M05BA05', 'Tiludronsäure', 'Skelid', 'S', 'Osteolysen');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('A04AA03', 'Tropisetron', 'Navoban', 'S', 'Antiemetikum (CINV)');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('M05BA08', 'Zoledronsäure', 'Zometa', 'S', 'Osteolysen');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01AD04', 'Streptozocin', 'Zanosar', 'C', 'Zytostatikum ; endokrine Pankreas, Neuroendokrine-GIT');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XX46', 'Olaparib', 'AZD-2281, Lynparza', 'Z', 'Ovar; Olaparib acts as an inhibitor of the enzyme poly ADP ribose polymerase (PARP), and is termed a PARP inhibitor');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XE31', 'Nintedanib', 'Ofev, Vargatef', 'Z', 'Tyrosinkinase-Inhibitor; NSCLC');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XC19', 'Blinatumomab', ' Blincyto', 'I', 'Monoklonaler Antikörper; ALL ');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XE35', 'Osimertinib', 'Tagrisso', 'Z', 'Tyrosinkinase-Inhibitor; NSCLC');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('S01AD02', 'Trifluridin', 'Tipiracil', 'C', 'Nukleosidanaloga ');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XE28', 'Ceritinib', ' Zykadia', 'Z', 'Zytostatikum; NSCLC ');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XE33', 'Palbociclib', 'Ibrance', 'Z', 'CDK-Inhibitor; ER+ MammaCa');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XE13', 'Afatinib', 'Giotrif', 'Z', 'Tyrosinkinase-Inhibitor; NSCLC');

INSERT INTO TMP_SUBSTANZEN_HKR (ATC_CODE, SUBSTANZ, HANDELSNAME, ART, INDIKATION) 
VALUES ('L01XE36', 'Alectinib', ' Alecensa', 'Z', 'ALK-Inhibitor; NSCLC ');


commit;

-- Import Data into table TMP_SUBSTANZEN_HKR from file C:\Users\Administrator\Desktop\160926_Liste Barta_Chemo.xlsx . Task successful and sent to worksheet.
