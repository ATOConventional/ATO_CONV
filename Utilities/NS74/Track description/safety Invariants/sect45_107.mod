IMPLEMENTATION MODULE Specific;

(*$S- *)
(*$T- *)

(******************************************************************************
*   SANTIAGO - LIGNE 5 - Secteur 45
*  =============================
*  Version : SCCS 1.0.0
*  Date    : 16/10/2009
*  Auteur  : Patrick Amsellem
*  Premiere Version
******************************************************************************)
(* Version 1.0.1  =====================                                      *)
(* Date :         20/01/2010                                                 *)
(* Auteur:        Patrick Amsellem                                           *)
(* Modification : supression ligne EtDD( SigPLM22B,                          *)
(* Modification : AigPLM13_23.PosReverseFiltree, BoolTr)                     *)
(* Modification : reprise equation du PtArrSpePLM12 AM165722                 *)
(* Modification : CONFIGURATION DES TRONCONS TSR 1 au lieu de 2 AM165735     *)
(* Modification : Boucle 5 nombre de variants anticipés AM165729             *)
(*****************************************************************************)
(* Version 1.0.2  =====================                                      *)
(* Date :         25/10/2010                                                 *)
(* Auteur:        Ph. Hog                                                    *)
(* Modification : Tronçon 45.3: suppression de l'emission du segment 45.3.0  *)
(*                Tronçon 45.4: suppression de l'emission du segment 45.4.0  *)
(*                              ajout de l'emission du segment 45.1.0        *)
(*                Tronçon 45.5: suppression de l'emission du segment 45.4.0  *)
(*                              suppression de l'emission du segment 45.1.0  *)
(*                              ajout de l'emission du segment 45.1.1        *)
(*******************************************************************************)
(* Version 1.0.3  =====================                                        *)
(* Date :         29/10/2010                                                   *)
(* Auteur:        M. Plywacz                                                   *)
(* Modification : Tronçon 45.5: dans l'equation du PtArrSigPLM22B ajout aig 13 *)
(*******************************************************************************)
(* Version 1.0.4  =====================                                        *)
(* Date :         15/11/2010                                                   *)
(* Auteur:        Ph. Hog                                                      *)
(* Modification : Suppression des DamTc des ampli inutilisés.                  *)
(*******************************************************************************)
(* Version 1.0.5  =====================                                        *)
(* Date :         17/11/2010                                                   *)
(* Auteur:        M. Plywacz                                                   *)
(* Modification : Tronçon 45.5: l'equation du PtArrSigPLM22B = BoolRestrictif  *)
(*******************************************************************************)
(* Version 1.0.6  =====================                                        *)
(* Date :         18/11/2010                                                   *)
(* Auteur:        M. Plywacz                                                   *)
(* Modification : Suppression des DamTc des ampli inutilisés.                  *)
(*******************************************************************************)
(* Version 1.0.7  =====================                                        *)
(* Date :         25/05/2011                                                   *)
(* Auteur:        I. ISSA                                                      *)
(* Modification : Marches types ConfigQuai                                     *)
(*******************************************************************************)


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
		       Boucle1, Boucle2, Boucle3,  Boucle4, Boucle5,BoucleFictive,
		       CarteCes1,  CarteCes2,  CarteCes3,  CarteCes4,  CarteCes5,
		       Intersecteur1,

		       Ampli11, Ampli12, Ampli13, Ampli14, Ampli15, Ampli16, Ampli17,
		       Ampli18,Ampli19,Ampli1A,Ampli1B,Ampli1C,Ampli1D,
	             Ampli21, Ampli22, Ampli23, Ampli24, Ampli25, Ampli26, Ampli27, Ampli28, Ampli29, Ampli2A,
	             Ampli31, Ampli32, Ampli33, Ampli34, Ampli35, Ampli36, Ampli37, Ampli38, Ampli39,Ampli3A,
 	             Ampli41, Ampli42, Ampli43, Ampli44,Ampli45, Ampli46, Ampli47,
 		       Ampli51, Ampli52, Ampli53, Ampli54, Ampli55, Ampli56, Ampli57,Ampli58, Ampli59, Ampli5A, 


   (* procedures *)
		       ConfigurerBoucle,
		       ConfigurerIntsecteur,
		       ConfigurerCES,
		       ConfigurerAmpli;

FROM BibTsr      IMPORT
   (* variables *)
		       Tronc0, Tronc1, Tronc2, Tronc3, Tronc4, (* utilises *)
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

    L0544  = 1024*44; (* numero Secteur aval decale de 2**10 *)

    L0545  = 1024*45; (* numero Secteur local decale de 2**10 *)

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
    noBoucleMoT = 00;
    noBouclefi  = 01;
    noBoucle1 = 03;
    noBoucle2 = 04;
    noBoucle3 = 05;
    noBoucle4 = 06;
    noBoucle5 = 07;


(** Base pour les tables de compensation **)
    BaseEntVar  = 500   ;
    BaseSorVar  = 600   ;
    BaseExeAig  = 1280  ;
    BaseExeChainage = 1360 ;
    BaseExeSpecific = 1950 ;



(******************** DECLARATION DES VARIABLES GENERALES ********************)
 VAR

(* DECLARATION DES SINGULARITES DU SECTEUR 45 : dans les deux sens confondus *)

(* Declaration des variables correspondant a des entrees securitaires       *)
(*   - CDV et signaux                                                       *)

   SigPLM10kv,     (* entree  1, soit entree 0 de CES 02  *)
   SigPLM10kj,     (* entree  2, soit entree 1 de CES 02  *)
   SigPLM12,     	 (* entree  3, soit entree 2 de CES 02  *)
   (*SigVES12B,      entree  4, soit entree 3 de CES 02  *)
   SigPLM14A,      (* entree  5, soit entree 4 de CES 02  *)
   SigPLM14B,      (* entree  6, soit entree 5 de CES 02  *)
   SigPLM16,       (* entree  7, soit entree 6 de CES 02  *)
   SigPLM22A,      (* entree  8, soit entree 7 de CES 02  *)
   SigPLM22B,      (* entrees 09 , soit entree 0 de CES 03 *) 

   SigPLM23, 	 (* entrees 10 , soit entrees 1 de CES 03 *) 
   SigPLM24A, 	 (* entrees 11 , soit entrees 2 de CES 03 *) 
   SigPLM24B, 	 (* entrees 12, soit entrees 3 de CES 03 *) 
   SigPLM26, 	 (* entree 13, soit entree 4 de CES 03  *)
   (*CdvVES14,        entree 14, soit entree 5 de CES 03  *)

   (*CdvVES15,        entree 19, soit entree 2 de CES 04  *)
   CdvPLM09, 	 (* entree 20, soit entree 3 de CES 04  *)
   CdvPLM10, 	 (* entree 21, soit entree 4 de CES 04  *)
   CdvPLM11, 	 (* entree 22, soit entree 5 de CES 04  *)
   CdvPLM12A, 	 (* entree 23, soit entree 6 de CES 04  *)
   CdvPLM12B, 	 (* entree 24, soit entree 7 de CES 04  *)

   CdvPLM13,       (* entree 25, soit entree 0 de CES 05  *)
   CdvPLM19,	 (* entree 26, soit entree 1 de CES 05  *)
   CdvPLM20, 	 (* entree 27, soit entree 2 de CES 05  *)
   CdvPLM21,       (* entree 28, soit entree 3 de CES 05  *)
   CdvPLM22A, 	 (* entree 29, soit entree 4 de CES 05  *)
   CdvPLM22B,      (* entree 30, soit entree 5 de CES 05  *)
   CdvPLM23A,  	 (* entree 31, soit entree 6 de CES 05  *)
   CdvPLM23B,  	 (* entree 32, soit entree 7 de CES 05  *)

   CdvSAB11,       (* entree 33, soit entree 0 de CES 06  *)
   CdvSAB12,	 (* entree 34, soit entree 1 de CES 06  *)
   CdvSAB13, 	 (* entree 35, soit entree 2 de CES 06  *)
   CdvSAB21,       (* entree 36, soit entree 3 de CES 06  *)
   CdvSAB22, 	 (* entree 37, soit entree 4 de CES 06  *)
   CdvSAB23       (* entree 38, soit entree 5 de CES 06  *)
   (* CdvVES23B	  entree 39, soit entree 6 de CES 06  *)
  (*pas utilisee*) (* entree 40, soit entree 7 de CES 06  *)

             : BoolD;

    AigPLM11_21,     (* entrees 15 & 16, soit entrees 6 & 7 de CES 03 *) 
    AigPLM13_23      (* entrees 17 & 18, soit entrees 0 & 1 de CES 04 *) 
             : TyAig; 


(* variants lies a une commutation d'aiguille *)
    com1troncon1,
    com2troncon1,
    com3troncon1,
    com4troncon1,   
    com5troncon1 : BoolD; 


(***********************************************************)
(* Variables ne correspondant pas a une entree securitaire *)
(* Points d'arret *)

    
    
    PtArrSigPLM14A,
    PtArrSigPLM14B,
    PtArrSigPLM24A,
    PtArrSigPLM24B,
    PtArrSigPLM16,
    PtArrSigPLM26,
    PtArrSpePLM23,
    PtArrSigPLM22A,

    PtArrSpePLM12,
    
    PtArrCdvPLM19,
    PtArrCdvSAB11,
    PtArrCdvSAB12,
    PtArrCdvSAB13,
    PtArrCdvSAB21,
    PtArrCdvSAB22,
    PtArrCdvSAB23,
    PtArrCdvPLM09,
    PtArrCdvPLM10,
    PtArrSigPLM10,
    PtArrSigPLM12,
    PtArrSigPLM22B            : BoolD;

 (* Variants anticipes *)

    PtAntCdvDS11,
    PtAntCdvDS12,
    PtAntCdvDS13             : BoolD;


(***********************************************************)
(* Copie des entrees dans des variables fonctionnelles pour la regulation   *)
 
 (* CdvVES12Fonc, *)
 CdvPLM22Fonc,
 CdvSAB12Fonc,
 CdvSAB22Fonc           : BOOLEAN;

(** Voie d'emission SOL-TRAIN : deux sens confondus**)

    te11s45t01,
    te31s45t02,
    te21s45t03,
    te16s45t04,
    te25s45t05     :TyEmissionTele;

(** Voie d'emission Inter-secteur deux voies confondues **)
    teL0544,
    teL05fi        :TyEmissionTele;

(** Voie de reception Inter-secteur deux voies confondues **)
    trL0544,
    trL05fi        :TyCaracEntSec;

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

   EntreeAiguille(AigPLM13_23, 17, 18); (* Aig --> Gauche = Branch Normale *)
   EntreeAiguille(AigPLM11_21, 16, 15 ); (* Aig --> Droite = Branch Normale *) 

(* Configuration des entrees *)
   ProcEntreeIntrins ( 1, SigPLM10kv );
   ProcEntreeIntrins ( 2, SigPLM10kj );
   ProcEntreeIntrins ( 3, SigPLM12  );
   (*ProcEntreeIntrins ( 4, SigVES12B );*)
   ProcEntreeIntrins ( 5, SigPLM14A);
   ProcEntreeIntrins ( 6, SigPLM14B );
   ProcEntreeIntrins ( 7, SigPLM16 );
   ProcEntreeIntrins ( 8, SigPLM22A );

   ProcEntreeIntrins ( 9, SigPLM22B );
   ProcEntreeIntrins ( 10, SigPLM23 );
   ProcEntreeIntrins ( 11, SigPLM24A );
   ProcEntreeIntrins ( 12, SigPLM24B );
   ProcEntreeIntrins (13, SigPLM26 );
   (*ProcEntreeIntrins (14, CdvPLM14  );*)

   (*ProcEntreeIntrins (19, CdvPLM15   );*)
   ProcEntreeIntrins (20, CdvPLM09   );
   ProcEntreeIntrins (21, CdvPLM10   );
   ProcEntreeIntrins (22, CdvPLM11   );
   ProcEntreeIntrins (23, CdvPLM12A   );
   ProcEntreeIntrins (24, CdvPLM12B   );
   ProcEntreeIntrins (25, CdvPLM13   );
   
   ProcEntreeIntrins (26, CdvPLM19   );
   ProcEntreeIntrins (27, CdvPLM20   );
   ProcEntreeIntrins (28, CdvPLM21   );
   ProcEntreeIntrins (29, CdvPLM22A  );
   ProcEntreeIntrins (30, CdvPLM22B   );
   ProcEntreeIntrins (31, CdvPLM23A   );
   ProcEntreeIntrins (32, CdvPLM23B   );
   (*ProcEntreeIntrins (31, CdvPLM24   );*)
   (*ProcEntreeIntrins (32, CdvPLM25   );*)

   ProcEntreeIntrins (33, CdvSAB11   );
   ProcEntreeIntrins (34, CdvSAB12   );
   ProcEntreeIntrins (35, CdvSAB13   );
   ProcEntreeIntrins (36, CdvSAB21   );
   ProcEntreeIntrins (37, CdvSAB22   );
   ProcEntreeIntrins (38, CdvSAB23   );
   (*ProcEntreeIntrins (39, CdvPLM23B   );*)
 

(* CONFIGURATION POUR LA MAINTENANCE de la transmission continue *)
   ConfigurerBoucle(Boucle1, 1);
   ConfigurerBoucle(Boucle2, 2);
   ConfigurerBoucle(Boucle3, 3);
   ConfigurerBoucle(Boucle4, 4);
   ConfigurerBoucle(Boucle5, 5);

   ConfigurerAmpli(Ampli11, 1, 1, 154, 11, FALSE);
   ConfigurerAmpli(Ampli12, 1, 2, 155, 12, FALSE);
   (* ConfigurerAmpli(Ampli13, 1, 3, 156, 12, FALSE); *r cdv 24 et *r1 *)
   ConfigurerAmpli(Ampli14, 1, 4, 157, 12, TRUE);
   ConfigurerAmpli(Ampli15, 1, 5, 158, 13, FALSE);
   ConfigurerAmpli(Ampli16, 1, 6, 159, 13, FALSE);
   ConfigurerAmpli(Ampli17, 1, 7, 192, 13, TRUE);
   ConfigurerAmpli(Ampli18, 1, 8, 193, 14, FALSE);
   (* ConfigurerAmpli(Ampli19, 1, 9, 194, 14, FALSE);  *r cdv 16 et 15 *)
   ConfigurerAmpli(Ampli1A, 1, 10, 195, 14, TRUE);
   (* ConfigurerAmpli(Ampli1B, 1, 11, 196, 15, FALSE); *r cdv 26 *)
   (* ConfigurerAmpli(Ampli1C, 1, 12, 197, 15, FALSE); *r cdv 25 et *r2 *)
   (* ConfigurerAmpli(Ampli1D, 1, 13, 198, 15, TRUE);   Fus 5.3  *)
   ConfigurerAmpli(Ampli41, 4, 1, 199, 16, FALSE);
   ConfigurerAmpli(Ampli42, 4, 2, 200, 17, FALSE);
   ConfigurerAmpli(Ampli43, 4, 3, 201, 17, FALSE);
   ConfigurerAmpli(Ampli44, 4, 4, 202, 17, TRUE);
   (* ConfigurerAmpli(Ampli45, 4, 5, 203, 18, FALSE);  *r cdv 15 *)
   (* ConfigurerAmpli(Ampli46, 4, 6, 204, 18, FALSE);  *r cdv 16 et *r3*)
   (* ConfigurerAmpli(Ampli47, 4, 7, 205, 18, TRUE);    Fus 8.3  *)
   ConfigurerAmpli(Ampli31, 3, 1, 206, 21, FALSE);
   ConfigurerAmpli(Ampli32, 3, 2, 207, 22, FALSE);
   ConfigurerAmpli(Ampli33, 3, 3, 208, 22, FALSE);
   ConfigurerAmpli(Ampli34, 3, 4, 209, 22, TRUE);
   ConfigurerAmpli(Ampli35, 3, 5, 210, 23, FALSE);
   ConfigurerAmpli(Ampli36, 3, 6, 211, 23, FALSE);
   ConfigurerAmpli(Ampli37, 3, 7, 212, 23, TRUE);
   ConfigurerAmpli(Ampli38, 3, 8, 213, 24, FALSE);
   (* ConfigurerAmpli(Ampli39, 3, 9, 214, 24, FALSE);  *r4 et r5 *)
   ConfigurerAmpli(Ampli3A, 3, 10, 215, 24, TRUE);
   ConfigurerAmpli(Ampli51, 5, 1, 216, 25, FALSE);
   ConfigurerAmpli(Ampli52, 5, 2, 217, 26, FALSE);
   ConfigurerAmpli(Ampli53, 5, 3, 218, 26, FALSE);
   ConfigurerAmpli(Ampli54, 5, 4, 219, 26, TRUE);
   (* ConfigurerAmpli(Ampli55, 5, 5, 220, 27, FALSE); *)
   (* ConfigurerAmpli(Ampli56, 5, 6, 221, 27, FALSE);  *r cdv 24 et 25 *)
   (* ConfigurerAmpli(Ampli57, 5, 7, 222, 27, TRUE);  *)
   (* ConfigurerAmpli(Ampli58, 5, 8, 223, 28, FALSE);  *r cdv 26 *)
   (* ConfigurerAmpli(Ampli59, 5, 9, 256, 28, FALSE);  *r7 et r8 *)
   (* ConfigurerAmpli(Ampli5A, 5, 10, 257, 28, TRUE);   Fus 8.3  *)
   ConfigurerAmpli(Ampli21, 2, 1, 258, 31, FALSE);
   ConfigurerAmpli(Ampli22, 2, 2, 259, 32, FALSE);
   ConfigurerAmpli(Ampli23, 2, 3, 260, 32, FALSE);
   ConfigurerAmpli(Ampli24, 2, 4, 261, 32, TRUE);
   ConfigurerAmpli(Ampli25, 2, 5, 262, 33, FALSE);
   ConfigurerAmpli(Ampli26, 2, 6, 263, 33, FALSE);
   ConfigurerAmpli(Ampli27, 2, 7, 264, 33, TRUE);
   ConfigurerAmpli(Ampli28, 2, 8, 265, 34, FALSE);
   ConfigurerAmpli(Ampli29, 2, 9, 266, 34, FALSE);
   ConfigurerAmpli(Ampli2A, 2, 10, 267, 34, TRUE);

   

 
(** cartes CES **)
   ConfigurerCES(CarteCes1, 01);
   ConfigurerCES(CarteCes2, 02);
   ConfigurerCES(CarteCes3, 03);
   ConfigurerCES(CarteCes4, 04);
   ConfigurerCES(CarteCes5, 05);


(** Liaisons Inter-Secteur **)
(*  pas de liaison intersecteur vers amont *)
   ConfigurerIntsecteur(Intersecteur1, 01, trL0544, trL05fi);


(* Initialisations des variables ne correspondant pas a des entrees secu *)

(* Affectation a l'etat restrictif des variants commutes *)
   AffectBoolD(BoolRestrictif, com1troncon1) ;
   AffectBoolD(BoolRestrictif, com2troncon1) ;
   AffectBoolD(BoolRestrictif, com3troncon1) ;
   AffectBoolD(BoolRestrictif, com4troncon1) ;
   AffectBoolD(BoolRestrictif, com5troncon1) ;
   

(* Point d'arret *)

 
   AffectBoolD( BoolRestrictif, PtArrSigPLM14A  );
   AffectBoolD( BoolRestrictif, PtArrSigPLM14B  );
   AffectBoolD( BoolRestrictif, PtArrSigPLM24A  );
   AffectBoolD( BoolRestrictif, PtArrSigPLM24B  );
   AffectBoolD( BoolRestrictif, PtArrSigPLM16  );
   AffectBoolD( BoolRestrictif, PtArrSigPLM26  );
   AffectBoolD( BoolRestrictif, PtArrSpePLM23  );

   AffectBoolD( BoolRestrictif, PtArrSigPLM22A  );
   AffectBoolD( BoolRestrictif, PtArrSpePLM12  );
   AffectBoolD( BoolRestrictif, PtArrCdvPLM19  );
   AffectBoolD( BoolRestrictif, PtArrCdvSAB11  );
   AffectBoolD( BoolRestrictif, PtArrCdvSAB12   );
   AffectBoolD( BoolRestrictif, PtArrCdvSAB13  );
   AffectBoolD( BoolRestrictif, PtArrCdvSAB21   );
   AffectBoolD( BoolRestrictif, PtArrCdvSAB22   );


   AffectBoolD( BoolRestrictif, PtArrCdvSAB23   );
   AffectBoolD( BoolRestrictif, PtArrCdvPLM09   );
   AffectBoolD( BoolRestrictif, PtArrCdvPLM10   );

   AffectBoolD( BoolRestrictif, PtArrSigPLM10   );
   AffectBoolD( BoolRestrictif, PtArrSigPLM12   );
   AffectBoolD( BoolRestrictif, PtArrSigPLM22B   );
   


(* Variants anticipes *)
   AffectBoolD( BoolRestrictif, PtAntCdvDS11   );
   AffectBoolD( BoolRestrictif, PtAntCdvDS12   );
   AffectBoolD( BoolRestrictif, PtAntCdvDS13   );


(* Regulation *)
 (* CdvVES12Fonc := FALSE; *) 
 CdvPLM22Fonc := FALSE;
 CdvSAB12Fonc := FALSE;
 CdvSAB22Fonc := FALSE;
 
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

   ConfigEmisTeleSolTrain (te11s45t01,
			    noBoucle1,
			    BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain (te31s45t02,
			    noBoucle2,
			    BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain (te21s45t03,
			    noBoucle3,
			    BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain (te16s45t04,
			    noBoucle4,
			    BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain (te25s45t05,
			    noBoucle5,
			    BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

(* CONFIGURATION POUR LA REGULATION *)

  

   ConfigQuai(92, 64, CdvPLM22Fonc, te11s45t01, 0, 8, 9,4, 11,  13,14,15);
   (* ConfigQuai(92, 69, CdvPM12Fonc, te16s45t04, 0, 2, 3,4, 11,  13,14,15); *)

   ConfigQuai(91, 74, CdvSAB12Fonc, te21s45t03, 0, 8, 9,11, 5,  13,14,15);
   ConfigQuai(91, 79, CdvSAB22Fonc, te31s45t02, 0, 9,11,5, 10,  13,14,15);


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

   ProcEmisSolTrain(te11s45t01.EmissionSensUp, (2*noBoucle1),
		     LigneL05+ L0545+ TRONC*01,
              PtArrSigPLM14A,
 		  BoolRestrictif, (* AspectCroix *)
 		  PtArrSpePLM23,
 		  PtArrSigPLM22A, 
 		  BoolRestrictif, (* AspectCroix *)
 		  BoolRestrictif, 
              BoolRestrictif,
 		  BoolRestrictif, 
  (* Variants Anticipes *)
		  PtArrCdvPLM19, 
		  PtArrCdvSAB11,
    		  PtArrCdvSAB12,
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
		  BaseSorVar);



(* variants troncon 3 *)

   ProcEmisSolTrain(te21s45t03.EmissionSensUp, (2*noBoucle3),
		     LigneL05+ L0545+ TRONC*03,
		
		  PtArrCdvPLM19,
   		  PtArrCdvSAB11,
   		  PtArrCdvSAB12,
  		  PtArrCdvSAB13,
		  PtAntCdvDS11,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,	
   (* Variants Anticipes *)
		  PtAntCdvDS12,
    		  PtAntCdvDS13, 
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
		  BaseSorVar + 30);


(* variants troncon 2 *)

   ProcEmisSolTrain(te31s45t02.EmissionSensUp, (2*noBoucle2),
		     LigneL05+ L0545+ TRONC*02,

		  PtArrCdvSAB22,
    		  PtArrCdvSAB21,
		  PtArrCdvPLM09,
    		  PtArrCdvPLM10,
		  PtArrSigPLM10,
		  BoolRestrictif,  (* AspectCroix *)
		  AigPLM11_21.PosNormaleFiltree,   (* TIV Com *)
		  AigPLM11_21.PosReverseFiltree,
		  AigPLM11_21.PosNormaleFiltree,
		  BoolRestrictif,
(* Variants Anticipes *)
		  com1troncon1,		  
		  com2troncon1,
		  com3troncon1,
		  com4troncon1,
		  com5troncon1,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolPermissif,
		  BaseSorVar + 60);


(* variants troncon 4 *)

   ProcEmisSolTrain(te16s45t04.EmissionSensUp, (2*noBoucle4),
		     LigneL05+ L0545+ TRONC*04,

		  PtArrSpePLM12,
		  PtArrSigPLM12,
		  BoolRestrictif,  (* AspectCroix *)
		  BoolRestrictif,  (* rouge fixe *)
		  BoolRestrictif,  (* AspectCroix *)
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
		  BaseSorVar + 90);



(* variants troncon 5 *)

   ProcEmisSolTrain(te25s45t05.EmissionSensUp, (2*noBoucle5),
		     LigneL05+ L0545+ TRONC*05,

		  PtArrSigPLM22B,
		  BoolRestrictif,  (* AspectCroix *)
		  AigPLM13_23.PosReverseFiltree,
		  AigPLM13_23.PosNormaleFiltree,
		  BoolRestrictif, (* rouge fixe *)
		  BoolRestrictif, (* AspectCroix *)
		  BoolRestrictif, 
		  BoolRestrictif, 
(* Variants Anticipes *)
		  BoolRestrictif,  (* rouge fixe *)
		  BoolRestrictif,  (* AspectCroix *)
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
		  BaseSorVar + 120);



(* reception du secteur 44 aval *)
   ProcReceptInterSecteur(trL0544, noBoucleMoT, LigneL05+ L0544+ TRONC*01,

		  PtAntCdvDS11,
    		  PtAntCdvDS12,
   		  PtAntCdvDS13, 
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


(* emission vers le secteur 44 aval *)
   ProcEmisInterSecteur (teL0544, noBoucleMoT, LigneL05+ L0545+ TRONC*02,
			noBoucleMoT,
		  PtArrCdvSAB23,
		  PtArrCdvSAB22,
		  PtArrCdvSAB21,
		  PtArrCdvPLM09,
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

 (** Emission invariants vers secteur aval L0544 **)
   EmettreSegm(LigneL05+ L0545+ TRONC*02+ SEGM*00, noBoucleMoT, SensUp);
   EmettreSegm(LigneL05+ L0545+ TRONC*02+ SEGM*01, noBoucleMoT, SensUp);


 (** Boucle 1 **)
   EmettreSegm(LigneL05+ L0545+ TRONC*01+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL05+ L0545+ TRONC*01+ SEGM*01, noBoucle1, SensUp);
   EmettreSegm(LigneL05+ L0545+ TRONC*03+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL05+ L0545+ TRONC*03+ SEGM*01, noBoucle1, SensUp);
   EmettreSegm(LigneL05+ L0545+ TRONC*05+ SEGM*00, noBoucle1, SensUp);

 (** Boucle 2 **)
   EmettreSegm(LigneL05+ L0545+ TRONC*02+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL05+ L0545+ TRONC*02+ SEGM*01, noBoucle2, SensUp);
   EmettreSegm(LigneL05+ L0545+ TRONC*04+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL05+ L0545+ TRONC*04+ SEGM*01, noBoucle2, SensUp);
   EmettreSegm(LigneL05+ L0545+ TRONC*05+ SEGM*00, noBoucle2, SensUp);

  (** Boucle 3 **)
  (* EmettreSegm(LigneL05+ L0545+ TRONC*03+ SEGM*00, noBoucle3, SensUp); *)
   EmettreSegm(LigneL05+ L0545+ TRONC*03+ SEGM*01, noBoucle3, SensUp);
   EmettreSegm(LigneL05+ L0544+ TRONC*01+ SEGM*00, noBoucle3, SensUp);
   EmettreSegm(LigneL05+ L0544+ TRONC*03+ SEGM*00, noBoucle3, SensUp);

 (** Boucle 4 **)
  (* EmettreSegm(LigneL05+ L0545+ TRONC*04+ SEGM*00, noBoucle4, SensUp); *)
   EmettreSegm(LigneL05+ L0545+ TRONC*04+ SEGM*01, noBoucle4, SensUp);
   EmettreSegm(LigneL05+ L0545+ TRONC*01+ SEGM*00, noBoucle4, SensUp);
   EmettreSegm(LigneL05+ L0545+ TRONC*01+ SEGM*01, noBoucle4, SensUp);

 (** Boucle 5 **)
   EmettreSegm(LigneL05+ L0545+ TRONC*05+ SEGM*00, noBoucle5, SensUp);
   EmettreSegm(LigneL05+ L0545+ TRONC*04+ SEGM*01, noBoucle5, SensUp);
   EmettreSegm(LigneL05+ L0545+ TRONC*01+ SEGM*01, noBoucle5, SensUp);

(* CONFIGURATION DES TRONCONS TSR *********************************)

   ConfigurerTroncon(Tronc0, LigneL05 + L0545 + TRONC*01, 1,1,1,1);  (* troncon 45-1 *)
   ConfigurerTroncon(Tronc1, LigneL05 + L0545 + TRONC*02, 1,1,1,1);  (* troncon 45-2 *)
   ConfigurerTroncon(Tronc2, LigneL05 + L0545 + TRONC*03, 1,1,1,1);  (* troncon 45-3 *)
   ConfigurerTroncon(Tronc3, LigneL05 + L0545 + TRONC*04, 1,1,1,1);  (* troncon 45-4 *)
   ConfigurerTroncon(Tronc4, LigneL05 + L0545 + TRONC*05, 1,1,1,1);  (* troncon 45-5 *)

(* EMISSION DES TSR SUR VOIE 1 ***********************************************)

 (** Emission des TSR vers le secteur aval L0544 **)
   EmettreTronc(LigneL05+ L0545+ TRONC*02, noBoucleMoT, SensUp);


 (** Emission des TSR sur les troncons du secteur courant **)
   EmettreTronc(LigneL05+ L0545+ TRONC*01, noBoucle1, SensUp); (* troncon 45-1 *)
   EmettreTronc(LigneL05+ L0545+ TRONC*03, noBoucle1, SensUp);
   EmettreTronc(LigneL05+ L0545+ TRONC*05, noBoucle1, SensUp);

   EmettreTronc(LigneL05+ L0545+ TRONC*02, noBoucle2, SensUp); (* troncon 45-2 *)
   EmettreTronc(LigneL05+ L0545+ TRONC*04, noBoucle2, SensUp);
   EmettreTronc(LigneL05+ L0545+ TRONC*05, noBoucle2, SensUp);

   EmettreTronc(LigneL05+ L0545+ TRONC*03, noBoucle3, SensUp); (* troncon 45-3 *)
   EmettreTronc(LigneL05+ L0544+ TRONC*01, noBoucle3, SensUp);
   EmettreTronc(LigneL05+ L0544+ TRONC*03, noBoucle3, SensUp);

   EmettreTronc(LigneL05+ L0545+ TRONC*04, noBoucle4, SensUp); (* troncon 45-4 *)
   EmettreTronc(LigneL05+ L0545+ TRONC*01, noBoucle4, SensUp);

   EmettreTronc(LigneL05+ L0545+ TRONC*05, noBoucle5, SensUp); (* troncon 45-5 *)
   EmettreTronc(LigneL05+ L0545+ TRONC*04, noBoucle5, SensUp);
   EmettreTronc(LigneL05+ L0545+ TRONC*01, noBoucle5, SensUp);


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


   StockAdres( ADR(SigPLM10kv ));
   StockAdres( ADR(SigPLM10kj ));
   StockAdres( ADR(SigPLM12  ));
   StockAdres( ADR(SigPLM14A ));
   StockAdres( ADR(SigPLM14B ));
   StockAdres( ADR(SigPLM16 ));
   StockAdres( ADR(SigPLM22A ));
   StockAdres( ADR(SigPLM23  ));
   StockAdres( ADR(SigPLM22B ));
   

   StockAdres( ADR(SigPLM24A ));
   StockAdres( ADR(SigPLM24B ));
   StockAdres( ADR(SigPLM26 ));
   
   StockAdres( ADR(CdvPLM09   ));
   StockAdres( ADR(CdvPLM10   ));
   StockAdres( ADR(CdvPLM11   ));
   StockAdres( ADR(CdvPLM12A   ));
   StockAdres( ADR(CdvPLM12B   ));

   StockAdres( ADR(CdvPLM13   ));

   StockAdres( ADR(CdvPLM19   ));
   StockAdres( ADR(CdvPLM20   ));
   StockAdres( ADR(CdvPLM21   ));
   StockAdres( ADR(CdvPLM22A ));
   StockAdres( ADR(CdvPLM22B ));
   StockAdres( ADR(CdvPLM23A ));
   StockAdres( ADR(CdvPLM23B ));
   
   StockAdres( ADR(CdvSAB11   ));
   StockAdres( ADR(CdvSAB12   ));
   StockAdres( ADR(CdvSAB13 ));
   StockAdres( ADR(CdvSAB21 ));
   StockAdres( ADR(CdvSAB22 ));
   StockAdres( ADR(CdvSAB23   ));
   
   StockAdres( ADR(AigPLM13_23 )); 
   StockAdres( ADR(AigPLM11_21 )); 

   StockAdres( ADR(com1troncon1));
   StockAdres( ADR(com2troncon1));
   StockAdres( ADR(com3troncon1));
   StockAdres( ADR(com4troncon1));
   StockAdres( ADR(com5troncon1));
   
   


(* Points d'arret *)


   StockAdres( ADR(PtArrSigPLM14A ));
   StockAdres( ADR(PtArrSigPLM14B ));
   StockAdres( ADR(PtArrSigPLM24A ));
   StockAdres( ADR(PtArrSigPLM24B ));
   StockAdres( ADR(PtArrSigPLM16 ));
   StockAdres( ADR(PtArrSigPLM26 ));
   StockAdres( ADR(PtArrSpePLM23 ));

   StockAdres( ADR(PtArrSigPLM22A ));
   StockAdres( ADR(PtArrSpePLM12 ));
   StockAdres( ADR(PtArrCdvPLM19 ));
   StockAdres( ADR(PtArrCdvSAB11  ));
   StockAdres( ADR(PtArrCdvSAB12 ));

   StockAdres( ADR(PtArrCdvSAB13   ));
   StockAdres( ADR(PtArrCdvSAB21   ));
   StockAdres( ADR(PtArrCdvSAB22   ));

   StockAdres( ADR(PtArrCdvSAB23   ));
   StockAdres( ADR(PtArrCdvPLM09   ));
   StockAdres( ADR(PtArrCdvPLM10   ));
   StockAdres( ADR(PtArrSigPLM10   ));

   StockAdres( ADR(PtArrSigPLM12   ));
   StockAdres( ADR(PtArrSigPLM22B   ));
   

   StockAdres( ADR(PtAntCdvDS11   ));
   StockAdres( ADR(PtAntCdvDS12   ));
   StockAdres( ADR(PtAntCdvDS13   ));


END StockerAdresse ;

(* Saut de page *)
(*----------------------------------------------------------------------------*)
PROCEDURE InitInutil ;
(*--------------------------------------------------------------------------*)
(*
 * Fonction :
 *      Cette procedure permet l'initialisation des variables de troncons et
 *      d'interstations du standard qui ne font pas partie de la configuration
 *      reelle du secteur.
 *
 * Condition d'appel : Appelee par InitSpecific a l'initialisation du logiciel
 *
 *)
(*----------------------------------------------------------------------------*)
BEGIN (* InitInutil *)

(* Configuration des troncons TSR inutilisees *)

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
VAR BoolTr , BoolTr1 , BoolTr2 : BoolLD;

BEGIN (* ExeSpecific *)

(* Affectation des "constantes" utilisees dans la construction des messages emis        *)
(* et recus sur les boucles de transmission continue et sur les liens intersecteur.     *)
(* Cette reaffectation est necessaire a chaque cycle pour la mise en securite.          *)
   AffectBoolC(Vrai, BoolPermissif)  ;
   AffectBoolC(Faux, BoolRestrictif) ;

 (* regulation *)

 CdvPLM22Fonc := CdvPLM22A.F = Vrai.F;
 (*CdvVES12Fonc := CdvVES12.F = Vrai.F;*)
 CdvSAB22Fonc := CdvSAB22.F = Vrai.F;
 CdvSAB12Fonc := CdvSAB12.F = Vrai.F;




(**** FILTRAGE DES AIGUILLES **************************************************)

  FiltrerAiguille(AigPLM13_23, BaseExeAig ) ;
  FiltrerAiguille(AigPLM11_21, BaseExeAig + 2) ;


(**** DETERMINATION DES POINTS D'ARRET ****************************************)

   
   AffectBoolD( SigPLM14A, PtArrSigPLM14A );
   AffectBoolD( SigPLM14B, PtArrSigPLM14B );
   AffectBoolD( SigPLM24A, PtArrSigPLM24A );
   AffectBoolD( SigPLM24B, PtArrSigPLM24B );
   AffectBoolD( SigPLM16, PtArrSigPLM16 );
   AffectBoolD( SigPLM26, PtArrSigPLM26 );
   AffectBoolD( SigPLM23, PtArrSpePLM23 );
   AffectBoolD( SigPLM22A, PtArrSigPLM22A );
   AffectBoolD( CdvPLM19, PtArrCdvPLM19  );
   AffectBoolD( CdvSAB11, PtArrCdvSAB11  );
   AffectBoolD( CdvSAB12, PtArrCdvSAB12  );
   AffectBoolD( CdvSAB13, PtArrCdvSAB13  );
   AffectBoolD( CdvSAB21, PtArrCdvSAB21  );
   AffectBoolD( CdvSAB22, PtArrCdvSAB22  );
   AffectBoolD( CdvSAB23, PtArrCdvSAB23  ); 
   AffectBoolD( CdvPLM09, PtArrCdvPLM09  );
   AffectBoolD( CdvPLM10, PtArrCdvPLM10  );
   AffectBoolD( SigPLM12, PtArrSigPLM12  );

   OuDD( SigPLM10kv,  SigPLM10kj, PtArrSigPLM10 );


   OuDD( CdvPLM13, AigPLM13_23.PosReverseFiltree, BoolTr1); 
   EtDD( CdvPLM12A, CdvPLM12B, BoolTr2); 
   EtDD( BoolTr1, BoolTr2, PtArrSpePLM12); 
     
   
   AffectBoolD( BoolRestrictif, PtArrSigPLM22B );
 (* AffectBoolD( SigPLM22B, PtArrSigPLM22B ); *)



(*** lecture des entrees de regulation ***)
   LireEntreesRegul;

(* commutation des variants troncon 1 *)
(* en fonction de la position de l'aiguille 11_21 *)

IF Tvrai (AigPLM11_21.PosNormaleFiltree) THEN
	AffectBoolD (PtArrSpePLM12 , com1troncon1);
	AffectBoolD (PtArrSigPLM12 , com2troncon1);
	AffectBoolD (BoolRestrictif, com3troncon1); (* AspectCroix *)
	AffectBoolD (BoolRestrictif, com4troncon1); (* rouge fixe *)
	AffectBoolD (BoolRestrictif, com5troncon1); (* AspectCroix *)
	FinBranche(1);  
   ELSE
	IF Tvrai (AigPLM11_21.PosReverseFiltree) THEN
		AffectBoolD (PtArrSigPLM22B,  com1troncon1);
		AffectBoolD (BoolRestrictif,  com2troncon1); (* AspectCroix *)
		AffectBoolD (BoolRestrictif,  com3troncon1);
		AffectBoolD (BoolRestrictif,  com4troncon1);
		AffectBoolD (BoolRestrictif,  com5troncon1);
		FinBranche(2);
	ELSE 
	  	AffectBoolD (BoolRestrictif, com1troncon1);
	  	AffectBoolD (BoolRestrictif, com2troncon1);
	  	AffectBoolD (BoolRestrictif, com3troncon1);
	  	AffectBoolD (BoolRestrictif, com4troncon1);
		AffectBoolD (BoolRestrictif, com5troncon1);
	  	FinBranche(3);
	END;
END;
FinArbre(BaseExeSpecific);


END ExeSpecific;
END Specific.


















