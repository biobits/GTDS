--EXTERNE PROZEDUR

alter Table EXTERNE_PROZEDUR enable Row Movement
;
alter Table EXTERNE_PROZEDUR shrink Space compact
;
alter Table EXTERNE_PROZEDUR shrink Space cascade
;
alter Index I_EXTPROZ_PATIENTEN_ID rebuild
;
alter Index I_EXTPROZ_Import rebuild
;
alter Table EXTERNE_PROZEDUR disable Row Movement
;
commit;
---EXTERNE_DIAGNOSE
alter Table EXTERNE_DIAGNOSE enable Row Movement
;
alter Table EXTERNE_DIAGNOSE shrink Space compact
;
alter Table EXTERNE_DIAGNOSE shrink Space cascade
;
alter Index I_EXTDIAG_IMPORT rebuild
;
alter Index I_EXTDIAG_PATIENTEN_ID rebuild
;
alter Index I_EXTD_PATIENTEN_ID_QU rebuild
;
alter Table EXTERNE_DIAGNOSE disable Row Movement
;
commit;
---ABTEILUNG_PATIENT_BEZIEHUNG
alter Table ABTEILUNG_PATIENT_BEZIEHUNG enable Row Movement
;
alter Table ABTEILUNG_PATIENT_BEZIEHUNG shrink Space compact
;
alter Table ABTEILUNG_PATIENT_BEZIEHUNG shrink Space cascade
;
alter Index APB_LFDNR rebuild
;
alter Index I_APB_AENDERUNG rebuild
;
alter Index I_APB_EP_EINW_ABT rebuild
;
alter Index I_APB_EP_EINW_ARZT rebuild
;
alter Index I_APB_EP_HAUSARZT rebuild
;
alter Index I_APB_EP_KHABT rebuild
;
alter Index I_APB_FALL_NUMMER rebuild
;
alter Index I_APB_PATIENTEN_ID rebuild
;
alter Table ABTEILUNG_PATIENT_BEZIEHUNG disable Row Movement
;
commit;
---EXTERNER_PATIENT 

alter Table EXTERNER_PATIENT enable Row Movement
;
alter Table EXTERNER_PATIENT shrink Space compact
;
alter Table EXTERNER_PATIENT shrink Space cascade
;
alter Index I_PAKET_EXTERNER_PATIENT rebuild
;
alter Index I_EXTP_PATIENTEN_ID rebuild
;
alter Index EPAPID rebuild
;
alter Index EPANV rebuild
;
alter Index EPAIMPORT rebuild
;
alter Index EPAGDSNAM rebuild
;
alter Index EPAGDPNAM rebuild
;
alter Index EPAGDNAM rebuild
;
alter Index EPAEPID rebuild
;
alter Index EPAAENDERUNG rebuild
;
alter Table EXTERNER_PATIENT disable Row Movement
;
commit;
