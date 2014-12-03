IMPLEMENTATION MODULE Specific;

(*$S- *)
(*$T- *)

(*****************************************************************************)
(*   SANTIAGO - Ligne 5 - Secteur 9 - VICENTE VALDES                         *)
(*  =============================                                            *)
(*                                                                           *)
(* Version  1.0.0  =====================                                     *)
(* Version  1.1 DU SERVEUR SCCS =====================                        *)
(* Date :          01/03/2005                                                *)
(* Auteur :        M. Plywacz                                                *)
(* Modification :  Version initiale                                          *)
(*---------------------------------------------------------------------------*)
(*                                                                           *)
(*---------------------------------------------------------------------------*)
(* Version 1.0.1  =====================                                      *)
(* Version 1.2 DU SERVEUR SCCS =====================                         *)
(* Date    :      08/07/2005                                                 *)
(* Auteur  :      Marc PLYWACZ                                               *)
(* Modification : inversion des entrees aiguilles                            *)
(*                EntreeAiguille(AigVIC11_21,  9, 10) devient                *)
(*                EntreeAiguille(AigVIC11_21, 10,  9)                        *)
(*---------------------------------------------------------------------------*)
(* Version 1.0.2  =====================                                      *)
(* Version 1.3 DU SERVEUR SCCS =====================                         *)
(* Date    :      13/07/2005                                                 *)
(* Auteur  :      Marc PLYWACZ                                               *)
(* Modification : inversion des numeros des voies de trans                   *)
(*                noBoucle2 = 05 devient   noBoucle2 = 04                    *)
(*                noBoucle3 = 04 devient   noBoucle2 = 05                    *)
(*---------------------------------------------------------------------------*)
(* Version 1.0.3  =====================                                      *)
(* Version 1.4 DU SERVEUR SCCS =====================                         *)
(* Date    :      24/08/2005                                                 *)
(* Auteur  :      Marc PLYWACZ                                               *)
(* Modification : Ajustement marches types                                   *)
(*                                                                           *)
(*---------------------------------------------------------------------------*)
(* Version 1.0.4  =====================                                      *)
(* Version 1.4 DU SERVEUR SCCS =====================                         *)
(* Date    :      03/12/2012                                                 *)
(* Auteur  :      X raby                                                     *)
(* Modification : Ajustement suite tests sur voies                           *)
(*                division du secteur 9.3.0                                  *)
(*---------------------------------------------------------------------------*)

(*****************************************************************************)


(******************************  IMPORTATIONS  ********************************)

FROM SYSTEM     IMPORT ADR;

FROM Opel       IMPORT StockAdres, AffectBoolD, AffectBoolC, BoolC, BoolD, BoolLD, EtDD, CodeD,
		       EtatD, Tvrai, FinBranche, FinArbre, AffectC, AffectEtatC, OuDD, NonD;

FROM ConstCode  IMPORT BoolPermissif, BoolRestrictif, Vrai, Faux ;

FROM BibAig     IMPORT TyAig, FiltrerAiguille,
		       EntreeAiguille;

FROM NouvRegul IMPORT  
(* procedures *)
		       LireEntreesRegul,
		       ConfigQuai;

FROM SorTel    IMPORT
(* types *)
		       TyEmissionTele,
(* procedures *)
		       EmettreSegm,
		       EmettreTronc,
		       ProcEmisSolTrain,
		       ProcEmisInterSecteur,
		       ConfigEmisTeleSolTrain;

FROM EntSec    IMPORT
(* types *)
		       TyCaracEntSec,
(* procedures *)
		       ProcReceptInterSecteur;

FROM BibEnregDam  IMPORT
(* Types *)
		       TyBoucle,
(* variables *)
		       Boucle1, Boucle2, Boucle3,
		       CarteCes1,  CarteCes2,  CarteCes3,  CarteCes4,
		       Intersecteur1,

		       Ampli11, Ampli12, Ampli13, Ampli14, Ampli15, Ampli16, Ampli17,

	             Ampli21, Ampli22, Ampli23, Ampli24, Ampli25, Ampli26, Ampli27,
                   Ampli28, Ampli29, Ampli2A,

	             Ampli31, Ampli32, Ampli33, Ampli34, Ampli35, Ampli36, Ampli37,
                   

   (* procedures *)
		       ConfigurerBoucle,
		       ConfigurerIntsecteur,
		       ConfigurerCES,
		       ConfigurerAmpli;

FROM BibTsr      IMPORT
   (* variables *)
		       Tronc0, Tronc1, Tronc2, Tronc3, Tronc4,
		       Tronc5, Tronc6, Tronc7, Tronc8, Tronc9, (* inutilises *)
		       Tronc10, Tronc11, Tronc12, Tronc13, Tronc14, Tronc15, (* inutilises *)
   (* procedures *)
	               ConfigurerTroncon;

FROM ESbin       IMPORT
   (* procedures *)
		       ProcEntreeIntrins;

(*****************************  CONSTANTES  ***********************************)

CONST

(** No ligne, No secteur, ....**)

    LigneL05 = 16384*00; (* numero de ligne decale de 2**14 *)

    L0506  = 1024*06; (* numero Secteur amont decale de 2**10 *)

    L0509  = 1024*09; (* numero Secteur local decale de 2**10 *)

    TRONC  = 64; (* decalage de 2**6 pour numero de troncon *)

    SEGM   = 16; (* decalage de 2**4 pour numero de segment *)


(** Constantes de configuration des emissions en absence d'entrees de commutation **)
    VariantsContinus  = TRUE;
    CommutDifferee    = FALSE;

(** Indication  de positionnement d'aiguille **)
    PosNormale = TRUE;
    PosDeviee = FALSE;

(** indication de sens **)
    SensUp = TRUE;

(** No de Voie d'emissions SOL-Train, d'emission/reception inter-secteur **)
    noBouclefi = 00;
    noBoucleFlo = 01;
    noBoucle1 = 03;
    noBoucle2 = 04;
    noBoucle3 = 05;


(** Base pour les tables de compensation **)
    BaseEntVar  = 500   ;
    BaseSorVar  = 600   ;
    BaseExeAig  = 1280  ;
    BaseExeChainage = 1360 ;
    BaseExeSpecific = 1950 ;



(******************** DECLARATION DES VARIABLES GENERALES ********************)
 VAR

(* DECLARATION DES SINGULARITES DU SECTEUR 09 : dans les deux sens confondus *)

(* Declaration des variables correspondant a des entrees securitaires       *)
(*   - CDV et signaux                                                       *)

   CdvVIC10A,      (* entree  1, de la CES  *)
   CdvVIC10B,      (* entree  2, de la CES  *)
   CdvVIC11,       (* entree  3, de la CES  *)
   CdvVIC12,       (* entree  4, de la CES  *)
   CdvVIC13,       (* entree  5, de la CES  *)
   CdvVIC14,       (* entree  6, de la CES  *)
   SigVIC10kv,     (* entree  7, de la CES  *)
   SigVIC10kj,     (* entree  8, de la CES  *)

   SigVIC12,       (* entree 11, de la CES  *)
   SigVIC22B,      (* entree 13, de la CES  *)


   SigVIC14,       (* entree 17, de la CES  *)
   SigVIC24,       (* entree 18, de la CES  *)
   SigVIC23,       (* entree 19, de la CES  *)
   SigVIC22A,      (* entree 20, de la CES  *)

   CdvVIC23B,      (* entree 21, de la CES  *)
   CdvVIC23A,      (* entree 22, de la CES  *)
   CdvVIC22A,      (* entree 23, de la CES  *)
   CdvVIC22B,      (* entree 24, de la CES  *)
   CdvVIC21,       (* entree 25, de la CES  *)
   CdvVIC20        (* entree 26, de la CES  *)
             : BoolD;

    AigVIC11_21,     (* entrees 09 & 10, de la CES  *) 
    AigVIC13_23      (* entrees 14 & 15, de la CES  *) 
             : TyAig; 


(* variants lies a une commutation d'aiguille *)
(*    com1troncon1,
    com2troncon1,
    com3troncon1,
    com4troncon1,
    com5troncon1 : BoolD; *)


(***********************************************************)
(* Variables ne correspondant pas a une entree securitaire *)
(* Points d'arret *)

    PtArrCdvVIC10A,
    PtArrCdvVIC10B,
    PtArrSigVIC14,
    PtArrSigVIC24,
    PtArrSigVIC22A,
    PtArrSigVIC22B,

    PtArrSigVIC10,
    PtArrCdvVIC12,
    PtArrSigVIC12,
    PtArrSpeVIC23             : BoolD;

 (* Variants anticipes recus *)

    PtAntCdvFLO24,
    PtAntSigFLO24             : BoolD;


(***********************************************************)
(* Copie des entrees dans des variables fonctionnelles pour la regulation   *)
 
 CdvVIC22Fonc           : BOOLEAN;

(** Voie d'emission SOL-TRAIN : deux sens confondus**)

    te11s09t01,
    te15s09t03,
    te21s09t02     :TyEmissionTele;

(** Voie d'emission Inter-secteur deux voies confondues **)
    teL05fi,
    teL0506        :TyEmissionTele;

(** Voie de reception Inter-secteur deux voies confondues **)
    trL05fi,
    trL0506        :TyCaracEntSec;

  V1, V2, V3, V4, V5, V6   : BOOLEAN;



(*****************************  PROCEDURES  ***********************************)

(*----------------------------------------------------------------------------*)
PROCEDURE InitSpecDivers;
(*----------------------------------------------------------------------------*)
(*
 * Fonction :
 * Cette procedure configure les singularites diverses telles que : Aiguilles,
 * Stations, Inter-stations
 * Ainsi que les entrees CNP1, CNP2, Maintenance
 *
 * Condition d'appel : Appelee par InitSpecific a l'initialisation du logiciel
 *
 *)
(*----------------------------------------------------------------------------*)

BEGIN


(********************** CONFIGURATIONS DIVERSES ******************************)

(* CONFIGURATION DES AIGUILLES, POUR LES DEUX VOIES *)

   EntreeAiguille(AigVIC13_23, 14, 15);  (* Aig --> Gauche = Branch Normale *)
   EntreeAiguille(AigVIC11_21, 10,  9);  (* Aig --> Droite = Branch Normale *) 


(* Configuration des entrees *)
   ProcEntreeIntrins ( 1,   CdvVIC10A   );
   ProcEntreeIntrins ( 2,   CdvVIC10B   );
   ProcEntreeIntrins ( 3,   CdvVIC11    );
   ProcEntreeIntrins ( 4,   CdvVIC12  );
   ProcEntreeIntrins ( 5,   CdvVIC13   );
   ProcEntreeIntrins ( 6,   CdvVIC14 );
   ProcEntreeIntrins ( 7,   SigVIC10kv   );
   ProcEntreeIntrins ( 8,   SigVIC10kj   );

   ProcEntreeIntrins (11,   SigVIC12  );
   ProcEntreeIntrins (13,   SigVIC22B  );

   ProcEntreeIntrins (17,   SigVIC14  );
   ProcEntreeIntrins (18,   SigVIC24  );
   ProcEntreeIntrins (19,   SigVIC23   );
   ProcEntreeIntrins (20,   SigVIC22A  );

   ProcEntreeIntrins (21,   CdvVIC23B   );
   ProcEntreeIntrins (22,   CdvVIC23A   );
   ProcEntreeIntrins (23,   CdvVIC22A   );
   ProcEntreeIntrins (24,   CdvVIC22B   );
   ProcEntreeIntrins (25,   CdvVIC21   );
   ProcEntreeIntrins (26,   CdvVIC20   );



(* CONFIGURATION POUR LA MAINTENANCE de la transmission continue *)
   ConfigurerBoucle(Boucle1, 1);
   ConfigurerBoucle(Boucle2, 2);
   ConfigurerBoucle(Boucle3, 3);


   ConfigurerAmpli(Ampli11, 1, 1, 154, 11, FALSE);
   ConfigurerAmpli(Ampli12, 1, 2, 155, 12, FALSE);
   ConfigurerAmpli(Ampli13, 1, 3, 156, 12, FALSE);
   ConfigurerAmpli(Ampli14, 1, 4, 157, 12, TRUE);
   ConfigurerAmpli(Ampli15, 1, 5, 158, 13, FALSE);
   ConfigurerAmpli(Ampli16, 1, 6, 159, 13, FALSE);
   ConfigurerAmpli(Ampli17, 1, 7, 192, 13, TRUE);

   ConfigurerAmpli(Ampli31, 2, 1, 196, 15, FALSE);
   ConfigurerAmpli(Ampli32, 2, 2, 197, 16, FALSE);
   ConfigurerAmpli(Ampli33, 2, 3, 198, 16, FALSE);
   ConfigurerAmpli(Ampli34, 2, 4, 199, 16, TRUE);
   ConfigurerAmpli(Ampli35, 2, 2, 200, 17, FALSE);
   ConfigurerAmpli(Ampli36, 2, 3, 201, 17, FALSE);
   ConfigurerAmpli(Ampli37, 2, 4, 202, 17, TRUE);


   ConfigurerAmpli(Ampli21, 3, 1, 206, 21, FALSE);
   ConfigurerAmpli(Ampli22, 3, 2, 207, 22, FALSE);
   ConfigurerAmpli(Ampli23, 3, 3, 208, 22, FALSE);
   ConfigurerAmpli(Ampli24, 3, 4, 209, 22, TRUE);
   ConfigurerAmpli(Ampli25, 3, 5, 210, 23, FALSE);
   ConfigurerAmpli(Ampli26, 3, 5, 211, 23, FALSE);
   ConfigurerAmpli(Ampli27, 3, 7, 212, 23, TRUE);
   ConfigurerAmpli(Ampli28, 3, 5, 213, 24, FALSE);
   ConfigurerAmpli(Ampli29, 3, 5, 214, 24, FALSE);
   ConfigurerAmpli(Ampli2A, 3, 7, 215, 24, TRUE);



 
(** cartes CES **)
   ConfigurerCES(CarteCes1, 01);
   ConfigurerCES(CarteCes2, 02);
   ConfigurerCES(CarteCes3, 03);
   ConfigurerCES(CarteCes4, 04);

(** Liaisons Inter-Secteur **)
(*  pas de liaison intersecteur vers aval *)
   ConfigurerIntsecteur(Intersecteur1, 01, trL05fi, trL0506);


(* Initialisations des variables ne correspondant pas a des entrees secu *)

(* Affectation a l'etat restrictif des variants commutes *)
(*   AffectBoolD(BoolRestrictif, com1troncon1) ;
   AffectBoolD(BoolRestrictif, com2troncon1) ;
   AffectBoolD(BoolRestrictif, com3troncon1) ;
   AffectBoolD(BoolRestrictif, com4troncon1) ;
   AffectBoolD(BoolRestrictif, com5troncon1) ;  *)

(* Point d'arret *)
   AffectBoolD( BoolRestrictif, PtArrSigVIC14   );
   AffectBoolD( BoolRestrictif, PtArrSigVIC24   );
   AffectBoolD( BoolRestrictif, PtArrSigVIC22A   );
   AffectBoolD( BoolRestrictif, PtArrSigVIC22B  );

   AffectBoolD( BoolRestrictif, PtArrSigVIC10  );
   AffectBoolD( BoolRestrictif, PtArrCdvVIC12   );
   AffectBoolD( BoolRestrictif, PtArrSigVIC12   );
   AffectBoolD( BoolRestrictif, PtArrSpeVIC23   );





(* Variants anticipes *)
   AffectBoolD( BoolRestrictif, PtAntCdvFLO24   );
   AffectBoolD( BoolRestrictif, PtAntSigFLO24   );


(* Regulation *)
 CdvVIC22Fonc := FALSE;

END InitSpecDivers;



(*----------------------------------------------------------------------------*)
PROCEDURE InitSpecConfMess;
(*----------------------------------------------------------------------------*)
(*
 * Fonction :
 * Cette procedure configure les VoiesRetour, la voie d'emission SOL-Train et
 * Inter-secteur. Elle indique aussi le nombre de messages en inter-PCS.
 *
 * Condition d'appel : Appelee par InitSpecific a l'initialisation du logiciel
 *
 *)
(*----------------------------------------------------------------------------*)

BEGIN

(* CONFIGURATION DES VOIES D'EMISSION **************************)

   ConfigEmisTeleSolTrain ( te11s09t01,
			    noBoucle1,
			    BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te15s09t03,
			    noBoucle3,
			    BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te21s09t02,
			    noBoucle2,
			    BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);


(* CONFIGURATION POUR LA REGULATION *)

   ConfigQuai(69, 69, CdvVIC22Fonc, te21s09t02, 0, 5,10,6,7,  13,14,15);



END InitSpecConfMess;


(*----------------------------------------------------------------------------*)
PROCEDURE InSpecMessVar ;
(*----------------------------------------------------------------------------*)
(*
 * Fonction :
 * Cette procedure definit les messages de variants emis vers le TRAIN et
 * ceux emis et recus sur les liaisons Inter-secteurs.
 *
 * Condition d'appel : Appelee par InitSpecific a l'initialisation du logiciel
 *
 *)
(*----------------------------------------------------------------------------*)
BEGIN (* InSpecMessVar *)

(* CONFIGURATION DES EMISSIONS DE VARIANTS SOL-TRAIN VERS la VOIE *************)

(* variants troncon 1 *)

   ProcEmisSolTrain( te11s09t01.EmissionSensUp, (2*noBoucle1),
		     LigneL05+ L0509+ TRONC*01,

 		  PtArrCdvVIC10B,
              PtArrSigVIC10,
 		  BoolRestrictif,               (* AspectCroix *)
 		  AigVIC11_21.PosNormaleFiltree,(* TivCom *)
 		  AigVIC11_21.PosReverseFiltree,
 		  AigVIC11_21.PosNormaleFiltree,
		  PtArrCdvVIC12,
 		  PtArrSigVIC12,
 		  BoolRestrictif,               (* AspectCroix *)
 		  BoolRestrictif,               (* R Fix voie 1 *)
 		  BoolRestrictif,               (* AspectCroix *)

(* Variants Anticipes *)
		  PtArrSigVIC22B,
 		  BoolRestrictif,               (* AspectCroix *)
 		  BoolRestrictif,
 		  BoolRestrictif,
 		  BoolRestrictif,
 		  BoolRestrictif,
		  BoolRestrictif,
 		  BoolRestrictif,
 		  BoolRestrictif,
 		  BoolRestrictif,
 		  BoolRestrictif,
		  BoolPermissif,
		  BaseSorVar);



(* variants troncon 2 *)

   ProcEmisSolTrain( te21s09t02.EmissionSensUp, (2*noBoucle2),
		     LigneL05+ L0509+ TRONC*02,

		  PtArrSigVIC14,
		  BoolRestrictif, (* AspectCroix *)
		  PtArrSigVIC24,
		  BoolRestrictif, (* AspectCroix *)
		  PtArrSpeVIC23,
		  PtArrSigVIC22A,
		  BoolRestrictif, (* AspectCroix *)
              PtAntCdvFLO24,
		  BoolRestrictif,

(* Variants Anticipes *)
		  PtAntSigFLO24,
		  BoolRestrictif, (* AspectCroix *)
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolPermissif,
		  BaseSorVar + 30);


(* variants troncon 3 *)

   ProcEmisSolTrain( te15s09t03.EmissionSensUp, (2*noBoucle3),
		     LigneL05+ L0509+ TRONC*03,

		  PtArrSigVIC22B,
		  BoolRestrictif,  (* AspectCroix *)
		  AigVIC13_23.PosReverseFiltree,
		  AigVIC13_23.PosNormaleFiltree,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
(* Variants Anticipes *)
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolPermissif,
		  BaseSorVar + 60);





(* reception du secteur 6 amont *)
   ProcReceptInterSecteur(trL0506, noBoucleFlo, LigneL05+ L0506+ TRONC*04,

		  PtAntCdvFLO24,
		  PtAntSigFLO24,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BaseEntVar,
		  V1,
		  V2,
		  V3,
		  V4,
		  V5,
		  V6,
		  BaseEntVar + 1);


(* emission vers le secteur 6 amont *)
   ProcEmisInterSecteur (teL0506, noBoucleFlo, LigneL05+ L0509+ TRONC*01,
			noBoucleFlo,
		  PtArrCdvVIC10A,
		  PtArrCdvVIC10B,
		  PtArrSigVIC10,
		  AigVIC11_21.PosReverseFiltree,
		  AigVIC11_21.PosNormaleFiltree,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  V1,
		  V2,
		  V3,
		  V4,
		  V5,
		  V6,
		  BaseSorVar + 210);


END InSpecMessVar;

(*----------------------------------------------------------------------------*)
PROCEDURE InSpecMessInv ;
(*----------------------------------------------------------------------------*)
(*
 * Fonction :
 * Cette procedure definit les messages d'Invariants securitaires et de TSR 
 *
 * Condition d'appel : Appelee par InitSpecific a l'initialisation du logiciel
 *
 *)
(*----------------------------------------------------------------------------*)
BEGIN (* InSpecMessInv *)

(* CONFIGURATION DES EMISSION DES INVARIANTS SECURITAIRES VOIE UP *************)

(* Tous les sens doivent etre a SensUp ; il n'y a pas de commutation *)

 (** Emission invariants vers secteur aval L0506 **)
   EmettreSegm(LigneL05+ L0509+ TRONC*01+ SEGM*00, noBoucleFlo, SensUp);
   EmettreSegm(LigneL05+ L0509+ TRONC*01+ SEGM*01, noBoucleFlo, SensUp);
   EmettreSegm(LigneL05+ L0509+ TRONC*03+ SEGM*00, noBoucleFlo, SensUp);
   EmettreSegm(LigneL05+ L0509+ TRONC*03+ SEGM*01, noBoucleFlo, SensUp);


 (** Boucle 1 **)
   EmettreSegm(LigneL05+ L0509+ TRONC*01+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL05+ L0509+ TRONC*01+ SEGM*01, noBoucle1, SensUp);
   EmettreSegm(LigneL05+ L0509+ TRONC*03+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL05+ L0509+ TRONC*03+ SEGM*01, noBoucle1, SensUp);
   EmettreSegm(LigneL05+ L0509+ TRONC*02+ SEGM*00, noBoucle1, SensUp);

 (** Boucle 2 **)
   EmettreSegm(LigneL05+ L0509+ TRONC*02+ SEGM*01, noBoucle2, SensUp);
   EmettreSegm(LigneL05+ L0509+ TRONC*03+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL05+ L0509+ TRONC*03+ SEGM*01, noBoucle2, SensUp);
   EmettreSegm(LigneL05+ L0506+ TRONC*04+ SEGM*01, noBoucle2, SensUp);
   EmettreSegm(LigneL05+ L0506+ TRONC*05+ SEGM*00, noBoucle2, SensUp);

 (** Boucle 3 **)
   EmettreSegm(LigneL05+ L0509+ TRONC*01+ SEGM*01, noBoucle3, SensUp);
   EmettreSegm(LigneL05+ L0509+ TRONC*02+ SEGM*01, noBoucle3, SensUp);
   EmettreSegm(LigneL05+ L0509+ TRONC*02+ SEGM*00, noBoucle3, SensUp);



(* CONFIGURATION DES TRONCONS TSR *********************************)

   ConfigurerTroncon(Tronc0, LigneL05 + L0509 + TRONC*01, 1,1,1,1);  (* troncon 9-1 *)
   ConfigurerTroncon(Tronc1, LigneL05 + L0509 + TRONC*02, 1,1,1,1);  (* troncon 9-2 *)
   ConfigurerTroncon(Tronc2, LigneL05 + L0509 + TRONC*03, 1,1,1,1);  (* troncon 9-3 *)

(* EMISSION DES TSR SUR VOIE 1 ***********************************************)

 (** Emission des TSR vers le secteur aval L0506 **)
   EmettreTronc(LigneL05+ L0509+ TRONC*01, noBoucleFlo, SensUp);
   EmettreTronc(LigneL05+ L0509+ TRONC*03, noBoucleFlo, SensUp);
   

 (** Emission des TSR sur les troncons du secteur courant **)
   EmettreTronc(LigneL05+ L0509+ TRONC*01, noBoucle1, SensUp); (* troncon 9-1 *)
   EmettreTronc(LigneL05+ L0509+ TRONC*02, noBoucle1, SensUp);
   EmettreTronc(LigneL05+ L0509+ TRONC*03, noBoucle1, SensUp);

   EmettreTronc(LigneL05+ L0509+ TRONC*02, noBoucle2, SensUp); (* troncon 9-2 *)
   EmettreTronc(LigneL05+ L0509+ TRONC*03, noBoucle2, SensUp);
   EmettreTronc(LigneL05+ L0506+ TRONC*04, noBoucle2, SensUp);
   EmettreTronc(LigneL05+ L0506+ TRONC*05, noBoucle2, SensUp);

   EmettreTronc(LigneL05+ L0509+ TRONC*03, noBoucle3, SensUp); (* troncon 9-3 *)
   EmettreTronc(LigneL05+ L0509+ TRONC*02, noBoucle3, SensUp);
   EmettreTronc(LigneL05+ L0509+ TRONC*01, noBoucle3, SensUp);


END InSpecMessInv ;

(* Saut de page *)
(*----------------------------------------------------------------------------*)
PROCEDURE StockerAdresse;
(*----------------------------------------------------------------------------*)
(*
 * Fonction :
 *      Cette procedure stocke l'adresse de toutes les variables securitaires.
 *
 * Condition d'appel : Appelee par InitSpecific a l'initialisation du logiciel
 *
 *)
(*----------------------------------------------------------------------------*)
BEGIN (* StockerAdresse *)

(* VARIABLES *)

   StockAdres( ADR(CdvVIC10A   ));
   StockAdres( ADR(CdvVIC10B   ));
   StockAdres( ADR(CdvVIC11  ));
   StockAdres( ADR(CdvVIC12  ));
   StockAdres( ADR(CdvVIC13 ));
   StockAdres( ADR(CdvVIC14 ));
   StockAdres( ADR(SigVIC10kv   ));
   StockAdres( ADR(SigVIC10kj   ));

   StockAdres( ADR(SigVIC12  ));
   StockAdres( ADR(SigVIC22B  ));

   StockAdres( ADR(SigVIC14  ));
   StockAdres( ADR(SigVIC24  ));
   StockAdres( ADR(SigVIC23   ));
   StockAdres( ADR(SigVIC22A   ));

   StockAdres( ADR(CdvVIC23B   ));
   StockAdres( ADR(CdvVIC23A   ));
   StockAdres( ADR(CdvVIC22A   ));
   StockAdres( ADR(CdvVIC22B   ));
   StockAdres( ADR(CdvVIC21   ));
   StockAdres( ADR(CdvVIC20   ));


   StockAdres( ADR( AigVIC13_23 )); 
   StockAdres( ADR( AigVIC11_21 )); 



(* Points d'arret *)
   StockAdres( ADR( PtArrSigVIC14   ));
   StockAdres( ADR( PtArrSigVIC24   ));
   StockAdres( ADR( PtArrSigVIC22A   ));
   StockAdres( ADR( PtArrSigVIC22B  ));

   StockAdres( ADR( PtArrSigVIC10   ));
   StockAdres( ADR( PtArrCdvVIC12   ));
   StockAdres( ADR( PtArrSigVIC12   ));
   StockAdres( ADR( PtArrSpeVIC23   ));


   StockAdres( ADR( PtAntCdvFLO24   ));
   StockAdres( ADR( PtAntSigFLO24   ));


END StockerAdresse ;

(* Saut de page *)
(*----------------------------------------------------------------------------*)
PROCEDURE InitInutil ;
(*----------------------------------------------------------------------------*)
(*
 * Fonction :
 *      Cette procedure permet l'initialisation des variables de troncons et
 *      d'interstations du standard VIC ne font pas partie de la configuration
 *      reelle du secteur.
 *
 * Condition d'appel : Appelee par InitSpecific a l'initialisation du logiciel
 *
 *)
(*----------------------------------------------------------------------------*)
BEGIN (* InitInutil *)

(* Configuration des troncons TSR inutilisees *)

	ConfigurerTroncon(Tronc3, 0, 0,0,0,0) ;
      ConfigurerTroncon(Tronc4, 0, 0,0,0,0) ;
      ConfigurerTroncon(Tronc5, 0, 0,0,0,0) ;
	ConfigurerTroncon(Tronc6, 0, 0,0,0,0) ;
	ConfigurerTroncon(Tronc7, 0, 0,0,0,0) ;
	ConfigurerTroncon(Tronc8, 0, 0,0,0,0) ;
	ConfigurerTroncon(Tronc9, 0, 0,0,0,0) ;
	ConfigurerTroncon(Tronc10, 0, 0,0,0,0) ;
	ConfigurerTroncon(Tronc11, 0, 0,0,0,0) ;
	ConfigurerTroncon(Tronc12, 0, 0,0,0,0) ;
	ConfigurerTroncon(Tronc13, 0, 0,0,0,0) ;
	ConfigurerTroncon(Tronc14, 0, 0,0,0,0) ;
	ConfigurerTroncon(Tronc15, 0, 0,0,0,0) ;

END InitInutil ;


(* Saut de page *)
(*----------------------------------------------------------------------------*)
PROCEDURE InitSpecific ;
(*----------------------------------------------------------------------------*)
(*
 * Fonction :
 * Cette procedure appelle : InitSpecDivers, InitSpecPv, InitSpecConfMess
 *                           InSpecMessVarUp et Dn, InSpecMessInvUp et Dn
 *
 * Condition d'appel : Appelee par Applicati a l'initialisation du logiciel
 *
 *)
(*----------------------------------------------------------------------------*)
BEGIN (* InitSpecific *)


(**** CONFIGURATION DES SINGULARITES DIVERSES ****)
   InitSpecDivers;

(**** CONFIGURATION DES VOIES RETOUR ET VOIES D'EMISSION ****)
   InitSpecConfMess;

(**** CONFIGURATION DES MESSAGES DE VARIANTS SOL-TRAIN ET INTERSECTEUR ****)
   InSpecMessVar;

(**** CONFIGURATION DES MESSAGES D'INVARIANTS SOL-TRAIN ET INTERSECTEUR ***)
   InSpecMessInv;

(****   CONFIGURATION DES VARIABLES DU STANDARD NON UTILISEES *************)
   InitInutil;

(****   Stockage des adresses *****)
   StockerAdresse ;

END InitSpecific;

(* Saut de page *)
(*----------------------------------------------------------------------------*)
PROCEDURE ExeSpecific ;
(*----------------------------------------------------------------------------*)
(*
 * Fonction :
 * Cette procedure Traite la reconfiguration CdV, les caracteristiques
 * commutable (Zone d'arret d'urgence, FOD...) et fait le chainage des
 * portions de voie.
 *
 * Condition d'appel : Appelee par Applicati a chaque cycle du logiciel
 *
 *)
(*----------------------------------------------------------------------------*)
VAR BoolTr : BoolLD;

BEGIN (* ExeSpecific *)

(* Affectation des "constantes" utilisees dans la construction des messages emis        *)
(* et recus sur les boucles de transmission continue et sur les liens intersecteur.     *)
(* Cette reaffectation est necessaire a chaque cycle pour la mise en securite.          *)
   AffectBoolC(Vrai, BoolPermissif)  ;
   AffectBoolC(Faux, BoolRestrictif) ;

 (* regulation *)
 CdvVIC22Fonc := CdvVIC22A.F = Vrai.F;





(**** FILTRAGE DES AIGUILLES **************************************************)

  FiltrerAiguille(AigVIC13_23, BaseExeAig ) ;
  FiltrerAiguille(AigVIC11_21, BaseExeAig + 2) ;


(**** DETERMINATION DES POINTS D'ARRET ****************************************)

   OuDD( SigVIC10kv,  SigVIC10kj,  PtArrSigVIC10 );

   AffectBoolD( SigVIC14,    PtArrSigVIC14  );
   AffectBoolD( SigVIC24,    PtArrSigVIC24  );
   AffectBoolD( SigVIC22A,   PtArrSigVIC22A );
   AffectBoolD( SigVIC22B,   PtArrSigVIC22B );

   AffectBoolD( CdvVIC10A,   PtArrCdvVIC10A );
   AffectBoolD( CdvVIC10B,   PtArrCdvVIC10B );

   OuDD( CdvVIC13, AigVIC13_23.PosReverseFiltree, BoolTr);        
   EtDD( BoolTr,   CdvVIC12,       PtArrCdvVIC12 );

   AffectBoolD( SigVIC12,    PtArrSigVIC12  );
   AffectBoolD( SigVIC23,    PtArrSpeVIC23  );



(*** lecture des entrees de regulation ***)
   LireEntreesRegul;



END ExeSpecific;
END Specific.

















