IMPLEMENTATION MODULE Specific;

(*$S- *)
(*$T- *)

(*****************************************************************************)
(*   SANTIAGO - Ligne 2 - Secteur 20                                         *)
(*  =============================                                            *)
(*                                                                           *)
(* Version  1.0.0  =====================                                     *)
(* Version  1.1 DU SERVEUR SCCS =====================                        *)
(* Date :          02/08/2005                                                *)
(* Auteur :        P. Amsellem                                               *)
(* Modification :  Version initiale (prolongement 2 de la ligne 2)           *)
(*                                                                           *)
(*---------------------------------------------------------------------------*)
(*                                                                           *)
(*****************************************************************************)
(*                                                                           *)
(* Version 1.0.1  =====================                                      *)
(* Version 1.2 DU SERVEUR SCCS =====================                         *)
(* Date :         10/05/06                                                   *)
(* Auteur:        P. Amsellem                                                *)
(* Modification : Prise en compte remarque validation AM 42 / OM 3           *)
(*                ProcEmisSolTrain(te11s20t01.EmissionSensUp, (2*noBoucle1)  *)
(*                erreur de nom PtArrCdvVES19 au lieu de PtArrCdvVES09       *)
(* Modification : Prise en compte remarque OM 5                              *)
(*                suppresion des invariants securitaires 4.0 et 4.1 boucle 4 *)
(*****************************************************************************)
(*                                                                           *)
(* Version 1.0.2  =====================                                      *)
(* Version 1.3 DU SERVEUR SCCS =====================                         *)
(* Date :         18/09/06                                                   *)
(* Auteur:        P. Amsellem                                                *)
(* Modification : Prise en compte remarque thierry Massez                    *)
(*                tronçon 20.5 : 4 variants anticipés au lieu de 7           *)
(*                suppresion des variants pa_cdv12 et signal 12              *)
(*****************************************************************************)
(*                                                                           *)
(* Version 1.0.3  =====================                                      *)
(* Version 1.4 DU SERVEUR SCCS =====================                         *)
(* Date :         17/10/06                                                   *)
(* Auteur:        P. Hog                                                     *)
(* Modification : Affectation du PtArrSigVES24A.                             *)
(*****************************************************************************)
(*                                                                           *)
(* Version 1.0.4  =====================                                      *)
(* Version 1.5 DU SERVEUR SCCS =====================                         *)
(* Date :         18/10/06                                                   *)
(* Auteur:        P. Amsellem                                                *)
(* Modification : ProcEmisInterSecteur vers le secteur 19 modifiée           *)
(*                tronçon 2 au lieu de 3                                     *)
(*			variants repositionné  dans le bon ordre                   *)
(*		  PtArrCdvZAP21,                                                 *)
(*		  PtArrCdvZAP22,                                                 *)
(*		  PtArrCdvZAP23,                                                 *)
(*****************************************************************************)
(*                                                                           *)
(* Version 1.0.5  =====================                                      *)
(* Version 1.6 DU SERVEUR SCCS =====================                         *)
(* Date :         24/11/2006                                                 *)
(* Auteur:        P. Amsellem                                                *)
(* Modification : correction des marches types PA                            *)
(*                                                                           *)
(*                                                                           *)
(*****************************************************************************)
(*                                                                           *)
(* Version 1.0.6  =====================                                      *)
(* Version 1.7 DU SERVEUR SCCS =====================                         *)
(* Date :         17/01/2007                                                 *)
(* Auteur:        P. Amsellem                                                *)
(* Modification : correction des marches types PA                            *)
(*                                                                           *)
(*                                                                           *)
(*****************************************************************************)
(* Version 1.0.7  =====================                                      *)
(* Version 1.8 DU SERVEUR SCCS =====================                         *)
(* Date :         07/03/2007                                                 *)
(* Auteur:        P. Amsellem                                                *)
(* Modification : Nouveau Train NS2004                                       *)
(* Procédure CONFIGURATION DES TRONCONS TSR                                  *)
(*                ancienne valeur 1 , nouvelle 2                             *)
(*****************************************************************************)
(* Version 1.0.8  =====================                                      *)
(* Version 1.9 DU SERVEUR SCCS =====================                         *)
(* Date :         13/09/2007                                                 *)
(* Auteur:        P. Amsellem                                                *)
(* Modification : Arrière gare de Vespucio                                   *)
(* ajout signaux 16A et 26A boucle 1                                         *)
(* ajout transmission cdv 16 et cdv 26 :ampli 19                             *)
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
		       Boucle1, Boucle2, Boucle3,  Boucle4, Boucle5,
		       CarteCes1,  CarteCes2,  CarteCes3,  CarteCes4,  CarteCes5,
		       Intersecteur1,

		       Ampli11, Ampli12, Ampli13, Ampli14, Ampli15, Ampli16, Ampli17,
		       Ampli18,Ampli19,Ampli1A,
	               Ampli21, Ampli22, Ampli23, Ampli24, Ampli25, Ampli26, Ampli27, Ampli28, Ampli29, Ampli2A,
	               Ampli31, Ampli32, Ampli33, Ampli34, Ampli35, Ampli36, Ampli37, Ampli38, Ampli3A,
 	               Ampli41, Ampli42, Ampli43, Ampli44,
 		       Ampli51, Ampli52, Ampli53, Ampli54, Ampli55, Ampli56, Ampli57, 


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

    LigneL02 = 16384*00; (* numero de ligne decale de 2**14 *)

    L0219  = 1024*19; (* numero Secteur aval decale de 2**10 *)

    L0220  = 1024*20; (* numero Secteur local decale de 2**10 *)

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
    noBoucleEin = 00;
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

(* DECLARATION DES SINGULARITES DU SECTEUR 20 : dans les deux sens confondus *)

(* Declaration des variables correspondant a des entrees securitaires       *)
(*   - CDV et signaux                                                       *)

   SigVES10kv,     (* entree  1, soit entree 0 de CES 02  *)
   SigVES10kj,     (* entree  2, soit entree 1 de CES 02  *)
   SigVES12,     	 (* entree  3, soit entree 2 de CES 02  *)
   (*SigVES12B,      entree  4, soit entree 3 de CES 02  *)
   SigVES14A,      (* entree  5, soit entree 4 de CES 02  *)
   SigVES14B,      (* entree  6, soit entree 5 de CES 02  *)
   SigVES16A,      (* entree  7, soit entree 6 de CES 02  *)
   SigVES22A,      (* entree  8, soit entree 7 de CES 02  *)

   SigVES22B,      (* entrees 09 , soit entree 0 de CES 03 *) 
   SigVES23, 	 (* entrees 10 , soit entrees 1 de CES 03 *) 
   SigVES24A, 	 (* entrees 11 , soit entrees 2 de CES 03 *) 
   SigVES24B, 	 (* entrees 12, soit entrees 3 de CES 03 *) 
   SigVES26A, 	 (* entree 13, soit entree 4 de CES 03  *)
   (*CdvVES14,        entree 14, soit entree 5 de CES 03  *)

   (*CdvVES15,        entree 19, soit entree 2 de CES 04  *)
   CdvVES09, 	 (* entree 20, soit entree 3 de CES 04  *)
   CdvVES10, 	 (* entree 21, soit entree 4 de CES 04  *)
   CdvVES11, 	 (* entree 22, soit entree 5 de CES 04  *)
   CdvVES12, 	 (* entree 23, soit entree 6 de CES 04  *)
   CdvVES13, 	 (* entree 24, soit entree 7 de CES 04  *)

   CdvVES19,       (* entree 25, soit entree 0 de CES 05  *)
   CdvVES20,	 (* entree 26, soit entree 1 de CES 05  *)
   CdvVES21, 	 (* entree 27, soit entree 2 de CES 05  *)
   CdvVES22A,      (* entree 28, soit entree 3 de CES 05  *)
   CdvVES22B, 	 (* entree 29, soit entree 4 de CES 05  *)
   CdvVES23A,      (* entree 30, soit entree 5 de CES 05  *)
   (*CdvVES24,  	  entree 31, soit entree 6 de CES 05  *)
   (*CdvVES25,  	  entree 32, soit entree 7 de CES 05  *)

   CdvZAP11,       (* entree 33, soit entree 0 de CES 06  *)
   CdvZAP12,	 (* entree 34, soit entree 1 de CES 06  *)
   CdvZAP13, 	 (* entree 35, soit entree 2 de CES 06  *)
   CdvZAP21,       (* entree 36, soit entree 3 de CES 06  *)
   CdvZAP22, 	 (* entree 37, soit entree 4 de CES 06  *)
   CdvZAP23       (* entree 38, soit entree 5 de CES 06  *)
   (* CdvVES23B	  entree 39, soit entree 6 de CES 06  *)
  (*pas utilisee*) (* entree 40, soit entree 7 de CES 06  *)

             : BoolD;

    AigVES11_21,     (* entrees 15 & 16, soit entrees 6 & 7 de CES 03 *) 
    AigVES13_23      (* entrees 17 & 18, soit entrees 0 & 1 de CES 04 *) 
             : TyAig; 


(* variants lies a une commutation d'aiguille *)
    com1troncon1,
    com2troncon1,
    com3troncon1,
    com4troncon1,
    com5troncon1,
    com6troncon1,
    com7troncon1 : BoolD; 


(***********************************************************)
(* Variables ne correspondant pas a une entree securitaire *)
(* Points d'arret *)

    PtArrSigVES16A,
    PtArrSigVES26A,
    PtArrSigVES14A,
    PtArrSigVES14B, 
    PtArrSigVES24A,
    PtArrSigVES24B,
    PtArrSpeVES23,
    PtArrSigVES22A,
    PtArrCdvVES20,
    PtArrCdvVES19,
    PtArrCdvZAP11,
    PtArrCdvZAP12,
    PtArrCdvZAP13,
    PtArrCdvZAP21,
    PtArrCdvZAP22,
    PtArrCdvZAP23,
    PtArrCdvVES09,
    PtArrCdvVES10,
    PtArrSigVES10,
    PtArrCdvVES12,
    PtArrSigVES12,
    PtArrSigVES22B            : BoolD;

 (* Variants anticipes *)

    PtAntCdvEIN11,
    PtAntCdvEIN12,
    PtAntCdvEIN13             : BoolD;


(***********************************************************)
(* Copie des entrees dans des variables fonctionnelles pour la regulation   *)
 
 (*CdvVES12Fonc,*)
 CdvVES22Fonc,
 CdvZAP12Fonc,
 CdvZAP22Fonc           : BOOLEAN;

(** Voie d'emission SOL-TRAIN : deux sens confondus**)

    te11s20t01,
    te31s20t02,
    te21s20t03,
    te16s20t04,
    te25s20t05     :TyEmissionTele;

(** Voie d'emission Inter-secteur deux voies confondues **)
    teL0219,
    teL02fi        :TyEmissionTele;

(** Voie de reception Inter-secteur deux voies confondues **)
    trL0219,
    trL02fi        :TyCaracEntSec;

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

   EntreeAiguille(AigVES13_23, 17, 18); (* Aig --> Gauche = Branch Normale *)
   EntreeAiguille(AigVES11_21, 16, 15 ); (* Aig --> Droite = Branch Normale *) 


(* Configuration des entrees *)
   ProcEntreeIntrins ( 1, SigVES10kv );
   ProcEntreeIntrins ( 2, SigVES10kj );
   ProcEntreeIntrins ( 3, SigVES12  );
   (*ProcEntreeIntrins ( 4, SigVES12B );*)
   ProcEntreeIntrins ( 5, SigVES14A);
   ProcEntreeIntrins ( 6, SigVES14B );
   ProcEntreeIntrins ( 7, SigVES16A );
   ProcEntreeIntrins ( 8, SigVES22A );

   ProcEntreeIntrins ( 9, SigVES22B );
   ProcEntreeIntrins ( 10, SigVES23 );
   ProcEntreeIntrins ( 11, SigVES24A );
   ProcEntreeIntrins ( 12, SigVES24B );
   ProcEntreeIntrins (13, SigVES26A );
   (*ProcEntreeIntrins (14, CdvVES14  );*)

   (*ProcEntreeIntrins (19, CdvVES15   );*)
   ProcEntreeIntrins (20, CdvVES09   );
   ProcEntreeIntrins (21, CdvVES10   );
   ProcEntreeIntrins (22, CdvVES11   );
   ProcEntreeIntrins (23, CdvVES12   );
   ProcEntreeIntrins (24, CdvVES13   );
   
   ProcEntreeIntrins (25, CdvVES19   );
   ProcEntreeIntrins (26, CdvVES20   );
   ProcEntreeIntrins (27, CdvVES21   );
   ProcEntreeIntrins (28, CdvVES22A  );
   ProcEntreeIntrins (29, CdvVES22B   );
   ProcEntreeIntrins (30, CdvVES23A   );
   (*ProcEntreeIntrins (31, CdvVES24   );*)
   (*ProcEntreeIntrins (32, CdvVES25   );*)

   ProcEntreeIntrins (33, CdvZAP11   );
   ProcEntreeIntrins (34, CdvZAP12   );
   ProcEntreeIntrins (35, CdvZAP13   );
   ProcEntreeIntrins (36, CdvZAP21   );
   ProcEntreeIntrins (37, CdvZAP22   );
   ProcEntreeIntrins (38, CdvZAP23   );
   (*ProcEntreeIntrins (39, CdvVES23B   );*)
 

(* CONFIGURATION POUR LA MAINTENANCE de la transmission continue *)
   ConfigurerBoucle(Boucle1, 1);
   ConfigurerBoucle(Boucle2, 2);
   ConfigurerBoucle(Boucle3, 3);
   ConfigurerBoucle(Boucle4, 4);
   ConfigurerBoucle(Boucle5, 5);


   ConfigurerAmpli(Ampli11, 1, 1, 154, 11, FALSE);
   ConfigurerAmpli(Ampli12, 1, 2, 155, 12, FALSE);
   ConfigurerAmpli(Ampli13, 1, 3, 156, 12, FALSE);
   ConfigurerAmpli(Ampli14, 1, 4, 157, 12, TRUE);
   ConfigurerAmpli(Ampli15, 1, 5, 158, 13, FALSE);
   ConfigurerAmpli(Ampli16, 1, 6, 159, 13, FALSE);
   ConfigurerAmpli(Ampli17, 1, 7, 192, 13, TRUE);
   ConfigurerAmpli(Ampli18, 1, 8, 193, 14, FALSE);
   ConfigurerAmpli(Ampli19, 1, 9, 194, 14, FALSE);
   
   ConfigurerAmpli(Ampli1A, 1, 10, 195, 14, TRUE);

   ConfigurerAmpli(Ampli41, 4, 1, 199, 16, FALSE);
   ConfigurerAmpli(Ampli42, 4, 2, 200, 17, FALSE);
   ConfigurerAmpli(Ampli43, 4, 3, 201, 17, FALSE);
   ConfigurerAmpli(Ampli44, 4, 4, 202, 17, TRUE);
   (*ConfigurerAmpli(Ampli45, 4, 5, 203, 18, FALSE);*)
   (*ConfigurerAmpli(Ampli47, 4, 7, 205, 18, TRUE);*)

   ConfigurerAmpli(Ampli31, 3, 1, 206, 21, FALSE);
   ConfigurerAmpli(Ampli32, 3, 2, 207, 22, FALSE);
   ConfigurerAmpli(Ampli33, 3, 3, 208, 22, FALSE);
   ConfigurerAmpli(Ampli34, 3, 4, 209, 22, TRUE);
   ConfigurerAmpli(Ampli35, 3, 5, 210, 23, FALSE);
   ConfigurerAmpli(Ampli36, 3, 6, 211, 23, FALSE);
   ConfigurerAmpli(Ampli37, 3, 7, 212, 23, TRUE);
   ConfigurerAmpli(Ampli38, 3, 8, 213, 24, FALSE);

   ConfigurerAmpli(Ampli3A, 3, 10, 215, 24, TRUE);
 
   ConfigurerAmpli(Ampli51, 4, 1, 216, 25, FALSE);
   ConfigurerAmpli(Ampli52, 4, 2, 217, 26, FALSE);
   ConfigurerAmpli(Ampli53, 4, 3, 218, 26, FALSE);
   ConfigurerAmpli(Ampli54, 4, 4, 219, 26, TRUE);
   ConfigurerAmpli(Ampli55, 4, 5, 220, 27, FALSE);
   ConfigurerAmpli(Ampli56, 4, 6, 221, 27, FALSE);
   ConfigurerAmpli(Ampli57, 4, 7, 222, 27, TRUE);
   (*ConfigurerAmpli(Ampli58, 4, 8, 223, 28, FALSE);*)

   (*ConfigurerAmpli(Ampli5A, 4, 10, 225, 28, TRUE);*)

   ConfigurerAmpli(Ampli21, 5, 1, 258, 31, FALSE);
   ConfigurerAmpli(Ampli22, 5, 2, 259, 32, FALSE);
   ConfigurerAmpli(Ampli23, 5, 3, 260, 32, FALSE);
   ConfigurerAmpli(Ampli24, 5, 4, 261, 32, TRUE);
   ConfigurerAmpli(Ampli25, 5, 5, 262, 33, FALSE);
   ConfigurerAmpli(Ampli26, 5, 6, 263, 33, FALSE);
   ConfigurerAmpli(Ampli27, 5, 7, 264, 33, TRUE);
   ConfigurerAmpli(Ampli28, 5, 8, 265, 34, FALSE);
   ConfigurerAmpli(Ampli29, 5, 9, 266, 34, FALSE);

   ConfigurerAmpli(Ampli2A, 4, 10, 267, 34, TRUE);

 
(** cartes CES **)
   ConfigurerCES(CarteCes1, 01);
   ConfigurerCES(CarteCes2, 02);
   ConfigurerCES(CarteCes3, 03);
   ConfigurerCES(CarteCes4, 04);
   ConfigurerCES(CarteCes5, 05);


(** Liaisons Inter-Secteur **)
(*  pas de liaison intersecteur vers amont *)
   ConfigurerIntsecteur(Intersecteur1, 01, trL0219, trL02fi);


(* Initialisations des variables ne correspondant pas a des entrees secu *)

(* Affectation a l'etat restrictif des variants commutes *)
   AffectBoolD(BoolRestrictif, com1troncon1) ;
   AffectBoolD(BoolRestrictif, com2troncon1) ;
   AffectBoolD(BoolRestrictif, com3troncon1) ;
   AffectBoolD(BoolRestrictif, com4troncon1) ;
   AffectBoolD(BoolRestrictif, com5troncon1) ;
   AffectBoolD(BoolRestrictif, com6troncon1) ;
   AffectBoolD(BoolRestrictif, com7troncon1) ;

(* Point d'arret *)
 
   AffectBoolD( BoolRestrictif, PtArrSigVES16A  );
   AffectBoolD( BoolRestrictif, PtArrSigVES26A  );
   AffectBoolD( BoolRestrictif, PtArrSigVES14A  );
   AffectBoolD( BoolRestrictif, PtArrSigVES14B  );
   AffectBoolD( BoolRestrictif, PtArrSigVES24A  );
   AffectBoolD( BoolRestrictif, PtArrSigVES24B  );
   AffectBoolD( BoolRestrictif, PtArrSpeVES23   );
   AffectBoolD( BoolRestrictif, PtArrSigVES22A  );
   AffectBoolD( BoolRestrictif, PtArrCdvVES20   );
   AffectBoolD( BoolRestrictif, PtArrCdvVES19   );


   AffectBoolD( BoolRestrictif, PtArrCdvZAP11   );
   AffectBoolD( BoolRestrictif, PtArrCdvZAP12   );
   AffectBoolD( BoolRestrictif, PtArrCdvZAP13   );

   AffectBoolD( BoolRestrictif, PtArrCdvZAP21   );
   AffectBoolD( BoolRestrictif, PtArrCdvZAP22   );
   AffectBoolD( BoolRestrictif, PtArrCdvZAP23   );
   AffectBoolD( BoolRestrictif, PtArrCdvVES09   );

   AffectBoolD( BoolRestrictif, PtArrCdvVES10   );
   AffectBoolD( BoolRestrictif, PtArrSigVES10   );
   AffectBoolD( BoolRestrictif, PtArrCdvVES12   );
   AffectBoolD( BoolRestrictif, PtArrSigVES12   );
   AffectBoolD( BoolRestrictif, PtArrSigVES22B  );



(* Variants anticipes *)
   AffectBoolD( BoolRestrictif, PtAntCdvEIN11   );
   AffectBoolD( BoolRestrictif, PtAntCdvEIN12   );
   AffectBoolD( BoolRestrictif, PtAntCdvEIN13   );


(* Regulation *)
 (* CdvVES12Fonc := FALSE; *) 
 CdvVES22Fonc := FALSE;
 CdvZAP12Fonc := FALSE;
 CdvZAP22Fonc := FALSE;
 
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

   ConfigEmisTeleSolTrain (te11s20t01,
			    noBoucle1,
			    BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain (te31s20t02,
			    noBoucle2,
			    BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain (te21s20t03,
			    noBoucle3,
			    BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain (te16s20t04,
			    noBoucle4,
			    BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain (te25s20t05,
			    noBoucle5,
			    BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

(* CONFIGURATION POUR LA REGULATION *)

  

   ConfigQuai(82, 64, CdvVES22Fonc, te11s20t01, 0, 2, 3,4, 11,  13,14,15);


   ConfigQuai(81, 74, CdvZAP12Fonc, te21s20t03, 1,  9, 5,10, 6,  13,14,15);



   ConfigQuai(81, 79, CdvZAP22Fonc, te31s20t02, 0,  9,11,6, 7,  13,14,15);


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

   ProcEmisSolTrain(te11s20t01.EmissionSensUp, (2*noBoucle1),
		     LigneL02+ L0220+ TRONC*01,
              PtArrSigVES16A,
 		  BoolRestrictif, (* AspectCroix *)
 		  PtArrSigVES14A,
 		  BoolRestrictif, (* AspectCroix *)
 		  PtArrSigVES26A,
 		  BoolRestrictif, (* AspectCroix *)
              PtArrSigVES24A,
 		  BoolRestrictif, (* AspectCroix *)
 		  PtArrSpeVES23,
		  PtArrSigVES22A,
		  BoolRestrictif, (* AspectCroix *)
  (* Variants Anticipes *)
		  PtArrCdvVES19, 
		  PtArrCdvZAP11,
    		  PtArrCdvZAP12,
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

   ProcEmisSolTrain(te21s20t03.EmissionSensUp, (2*noBoucle3),
		     LigneL02+ L0220+ TRONC*03,
		
		  PtArrCdvVES19,
   		  PtArrCdvZAP11,
   		  PtArrCdvZAP12,
  		  PtArrCdvZAP13,
		  PtAntCdvEIN11,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,	
   (* Variants Anticipes *)
		  PtAntCdvEIN12,
    		  PtAntCdvEIN13, 
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

   ProcEmisSolTrain(te31s20t02.EmissionSensUp, (2*noBoucle2),
		     LigneL02+ L0220+ TRONC*02,

		  PtArrCdvZAP22,
    		  PtArrCdvZAP21,
		  PtArrCdvVES09,
    		  PtArrCdvVES10,
		  PtArrSigVES10,
		  BoolRestrictif,  (* AspectCroix *)
		  AigVES11_21.PosNormaleFiltree,   (* TIV Com *)
		  AigVES11_21.PosReverseFiltree,
		  AigVES11_21.PosNormaleFiltree,
		  BoolRestrictif,
(* Variants Anticipes *)
		  com1troncon1,		  
		  com2troncon1,
		  com3troncon1,
		  com4troncon1,
		  com5troncon1,
		  com6troncon1,
		  com7troncon1,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolPermissif,
		  BaseSorVar + 60);


(* variants troncon 4 *)

   ProcEmisSolTrain(te16s20t04.EmissionSensUp, (2*noBoucle4),
		     LigneL02+ L0220+ TRONC*04,

		  PtArrCdvVES12,
		  PtArrSigVES12,
		  BoolRestrictif  (* AspectCroix *),
		  PtArrSigVES14B,
		  BoolRestrictif  (* AspectCroix *),
		  BoolRestrictif, (* rouge fixe *)
		  BoolRestrictif  (* AspectCroix *),
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

   ProcEmisSolTrain(te25s20t05.EmissionSensUp, (2*noBoucle5),
		     LigneL02+ L0220+ TRONC*05,

		  PtArrSigVES22B,
		  BoolRestrictif  (* AspectCroix *),
		  AigVES13_23.PosReverseFiltree,
		  AigVES13_23.PosNormaleFiltree,
		  PtArrSigVES24B,
		  BoolRestrictif  (* AspectCroix *),
		  BoolRestrictif, (* rouge fixe *)
		  BoolRestrictif, (* AspectCroix *)
(* Variants Anticipes *)
		  PtArrSigVES14B,
		  BoolRestrictif  (* AspectCroix *),
		  BoolRestrictif, (* rouge fixe *)
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
		  BoolPermissif,
		  BaseSorVar + 120);



(* reception du secteur 19 aval *)
   ProcReceptInterSecteur(trL0219, noBoucleEin, LigneL02+ L0219+ TRONC*01,

		  PtAntCdvEIN11,
    		  PtAntCdvEIN12,
   		  PtAntCdvEIN13, 
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


(* emission vers le secteur 19 aval *)
   ProcEmisInterSecteur (teL0219, noBoucleEin, LigneL02+ L0220+ TRONC*02,
			noBoucleEin,
		  PtArrCdvZAP21,
		  PtArrCdvZAP22,
		  PtArrCdvZAP23,
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

 (** Emission invariants vers secteur aval L0219 **)
   EmettreSegm(LigneL02+ L0220+ TRONC*02+ SEGM*00, noBoucleEin, SensUp);
   EmettreSegm(LigneL02+ L0220+ TRONC*02+ SEGM*01, noBoucleEin, SensUp);


 (** Boucle 1 **)
   EmettreSegm(LigneL02+ L0220+ TRONC*01+ SEGM*01, noBoucle1, SensUp);
   EmettreSegm(LigneL02+ L0220+ TRONC*01+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL02+ L0220+ TRONC*03+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL02+ L0220+ TRONC*03+ SEGM*01, noBoucle1, SensUp);
   EmettreSegm(LigneL02+ L0220+ TRONC*05+ SEGM*00, noBoucle1, SensUp);

 (** Boucle 2 **)
   EmettreSegm(LigneL02+ L0220+ TRONC*02+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL02+ L0220+ TRONC*02+ SEGM*01, noBoucle2, SensUp);
   EmettreSegm(LigneL02+ L0220+ TRONC*04+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL02+ L0220+ TRONC*04+ SEGM*01, noBoucle2, SensUp);
   EmettreSegm(LigneL02+ L0220+ TRONC*05+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL02+ L0220+ TRONC*05+ SEGM*01, noBoucle2, SensUp);

  (** Boucle 3 **)
   EmettreSegm(LigneL02+ L0220+ TRONC*03+ SEGM*00, noBoucle3, SensUp);  
   EmettreSegm(LigneL02+ L0220+ TRONC*03+ SEGM*01, noBoucle3, SensUp);  
   EmettreSegm(LigneL02+ L0219+ TRONC*01+ SEGM*00, noBoucle3, SensUp);  
   EmettreSegm(LigneL02+ L0219+ TRONC*03+ SEGM*00, noBoucle3, SensUp);  
   EmettreSegm(LigneL02+ L0219+ TRONC*03+ SEGM*01, noBoucle3, SensUp);  

 (** Boucle 4 **)
   EmettreSegm(LigneL02+ L0220+ TRONC*01+ SEGM*01, noBoucle4, SensUp); 
   EmettreSegm(LigneL02+ L0220+ TRONC*01+ SEGM*00, noBoucle4, SensUp); 

 (** Boucle 5 **)
   EmettreSegm(LigneL02+ L0220+ TRONC*05+ SEGM*00, noBoucle5, SensUp); 
   EmettreSegm(LigneL02+ L0220+ TRONC*05+ SEGM*01, noBoucle5, SensUp); 
   EmettreSegm(LigneL02+ L0220+ TRONC*04+ SEGM*00, noBoucle5, SensUp); 
   EmettreSegm(LigneL02+ L0220+ TRONC*04+ SEGM*01, noBoucle5, SensUp); 
   EmettreSegm(LigneL02+ L0220+ TRONC*01+ SEGM*00, noBoucle5, SensUp); 

(* CONFIGURATION DES TRONCONS TSR *********************************)

   ConfigurerTroncon(Tronc0, LigneL02 + L0220 + TRONC*01, 2,2,2,2);  (* troncon 20-1 *)
   ConfigurerTroncon(Tronc1, LigneL02 + L0220 + TRONC*02, 2,2,2,2);  (* troncon 20-2 *)
   ConfigurerTroncon(Tronc2, LigneL02 + L0220 + TRONC*03, 2,2,2,2);  (* troncon 20-3 *)
   ConfigurerTroncon(Tronc3, LigneL02 + L0220 + TRONC*04, 2,2,2,2);  (* troncon 20-4 *)
   ConfigurerTroncon(Tronc4, LigneL02 + L0220 + TRONC*05, 2,2,2,2);  (* troncon 20-5 *)

(* EMISSION DES TSR SUR VOIE 1 ***********************************************)

 (** Emission des TSR vers le secteur aval L0219 **)
   EmettreTronc(LigneL02+ L0220+ TRONC*02, noBoucleEin, SensUp);


 (** Emission des TSR sur les troncons du secteur courant **)
   EmettreTronc(LigneL02+ L0220+ TRONC*01, noBoucle1, SensUp); (* troncon 20-1 *)
   EmettreTronc(LigneL02+ L0220+ TRONC*03, noBoucle1, SensUp);
   EmettreTronc(LigneL02+ L0220+ TRONC*05, noBoucle1, SensUp);

   EmettreTronc(LigneL02+ L0220+ TRONC*02, noBoucle2, SensUp); (* troncon 20-2 *)
   EmettreTronc(LigneL02+ L0220+ TRONC*04, noBoucle2, SensUp);
   EmettreTronc(LigneL02+ L0220+ TRONC*05, noBoucle2, SensUp);

   EmettreTronc(LigneL02+ L0220+ TRONC*03, noBoucle3, SensUp); (* troncon 20-3 *)
   EmettreTronc(LigneL02+ L0219+ TRONC*01, noBoucle3, SensUp);
   EmettreTronc(LigneL02+ L0219+ TRONC*03, noBoucle3, SensUp);
   (*EmettreTronc(LigneL02+ L0219+ TRONC*05, noBoucle3, SensUp);*)

   EmettreTronc(LigneL02+ L0220+ TRONC*04, noBoucle4, SensUp); (* troncon 20-4 *)
   EmettreTronc(LigneL02+ L0220+ TRONC*01, noBoucle4, SensUp);

   EmettreTronc(LigneL02+ L0220+ TRONC*05, noBoucle5, SensUp); (* troncon 20-5 *)
   EmettreTronc(LigneL02+ L0220+ TRONC*04, noBoucle5, SensUp);
   EmettreTronc(LigneL02+ L0220+ TRONC*01, noBoucle5, SensUp);


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

   StockAdres( ADR(SigVES10kv ));
   StockAdres( ADR(SigVES10kj ));
   StockAdres( ADR(SigVES12  ));
   StockAdres( ADR(SigVES14A ));
   StockAdres( ADR(SigVES14B ));
   StockAdres( ADR(SigVES16A ));
   StockAdres( ADR(SigVES22A ));

   StockAdres( ADR(SigVES22B ));
   StockAdres( ADR(SigVES23  ));

   StockAdres( ADR(SigVES24A ));
   StockAdres( ADR(SigVES24B ));
   StockAdres( ADR(SigVES26A ));
   
   StockAdres( ADR(CdvVES09   ));
   StockAdres( ADR(CdvVES10   ));
   StockAdres( ADR(CdvVES11   ));
   StockAdres( ADR(CdvVES13   ));

   StockAdres( ADR(CdvVES19   ));
   StockAdres( ADR(CdvVES20   ));
   StockAdres( ADR(CdvVES21   ));
   StockAdres( ADR(CdvVES22A ));
   StockAdres( ADR(CdvVES22B ));
   StockAdres( ADR(CdvVES23A ));
   
   StockAdres( ADR(CdvZAP11   ));
   StockAdres( ADR(CdvZAP12   ));
   StockAdres( ADR(CdvZAP13 ));
   StockAdres( ADR(CdvZAP21 ));
   StockAdres( ADR(CdvZAP22 ));
   StockAdres( ADR(CdvZAP23   ));
   
   StockAdres( ADR(AigVES13_23 )); 
   StockAdres( ADR(AigVES11_21 )); 

   StockAdres( ADR(com1troncon1));
   StockAdres( ADR(com2troncon1));
   StockAdres( ADR(com3troncon1));
   StockAdres( ADR(com4troncon1));
   StockAdres( ADR(com5troncon1));
   StockAdres( ADR(com6troncon1));
   StockAdres( ADR(com7troncon1));


(* Points d'arret *)

   StockAdres( ADR(PtArrSigVES16A ));
   StockAdres( ADR(PtArrSigVES26A ));
   StockAdres( ADR(PtArrSigVES14A ));
   StockAdres( ADR(PtArrSigVES24A ));
   StockAdres( ADR(PtArrSigVES24B ));
   StockAdres( ADR(PtArrSpeVES23  ));
   StockAdres( ADR(PtArrSigVES22A ));

   StockAdres( ADR(PtArrCdvVES20   ));
   StockAdres( ADR(PtArrCdvVES19   ));
   StockAdres( ADR(PtArrCdvZAP11   ));

   StockAdres( ADR(PtArrCdvZAP12   ));
   StockAdres( ADR(PtArrCdvZAP13   ));
   StockAdres( ADR(PtArrCdvZAP21   ));
   StockAdres( ADR(PtArrCdvZAP22   ));

   StockAdres( ADR(PtArrCdvZAP23   ));
   StockAdres( ADR(PtArrCdvVES09   ));
   StockAdres( ADR(PtArrCdvVES10   ));
   StockAdres( ADR(PtArrSigVES10   ));
   StockAdres( ADR(PtArrCdvVES12   ));
   StockAdres( ADR(PtArrSigVES12  ));
   StockAdres( ADR(PtArrSigVES22B ));

   StockAdres( ADR(PtAntCdvEIN11   ));
   StockAdres( ADR(PtAntCdvEIN12   ));
   StockAdres( ADR(PtAntCdvEIN13   ));


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
VAR BoolTr : BoolLD;

BEGIN (* ExeSpecific *)

(* Affectation des "constantes" utilisees dans la construction des messages emis        *)
(* et recus sur les boucles de transmission continue et sur les liens intersecteur.     *)
(* Cette reaffectation est necessaire a chaque cycle pour la mise en securite.          *)
   AffectBoolC(Vrai, BoolPermissif)  ;
   AffectBoolC(Faux, BoolRestrictif) ;

 (* regulation *)

 CdvVES22Fonc := CdvVES22A.F = Vrai.F;
 (*CdvVES12Fonc := CdvVES12.F = Vrai.F;*)
 CdvZAP22Fonc := CdvZAP22.F = Vrai.F;
 CdvZAP12Fonc := CdvZAP12.F = Vrai.F;




(**** FILTRAGE DES AIGUILLES **************************************************)

  FiltrerAiguille(AigVES13_23, BaseExeAig ) ;
  FiltrerAiguille(AigVES11_21, BaseExeAig + 2) ;


(**** DETERMINATION DES POINTS D'ARRET ****************************************)
 
   AffectBoolD( SigVES16A, PtArrSigVES16A );
   AffectBoolD( SigVES26A, PtArrSigVES26A );   
   AffectBoolD( SigVES14A, PtArrSigVES14A );
   AffectBoolD( SigVES14B, PtArrSigVES14B );
   AffectBoolD( SigVES24A, PtArrSigVES24A );
   AffectBoolD( SigVES24B, PtArrSigVES24B );
   AffectBoolD( SigVES23, PtArrSpeVES23 );
   AffectBoolD( SigVES22A, PtArrSigVES22A );
   AffectBoolD( CdvVES20, PtArrCdvVES20  );
   AffectBoolD( CdvVES19, PtArrCdvVES19  );
   AffectBoolD( CdvZAP11, PtArrCdvZAP11  );

   AffectBoolD( CdvZAP12, PtArrCdvZAP12  );
   AffectBoolD( CdvZAP13, PtArrCdvZAP13  );
   AffectBoolD( CdvZAP21, PtArrCdvZAP21  );
   AffectBoolD( CdvZAP22, PtArrCdvZAP22  );
   AffectBoolD( CdvZAP23, PtArrCdvZAP23  );
   
   AffectBoolD( CdvVES09, PtArrCdvVES09  );
   AffectBoolD( CdvVES10, PtArrCdvVES10  );

   OuDD( SigVES10kv,  SigVES10kj, PtArrSigVES10 );

   OuDD( CdvVES13, AigVES13_23.PosReverseFiltree, BoolTr);        
   EtDD( BoolTr,   CdvVES12, PtArrCdvVES12 );

   AffectBoolD( SigVES12, PtArrSigVES12  );
   AffectBoolD( SigVES22B, PtArrSigVES22B );



(*** lecture des entrees de regulation ***)
   LireEntreesRegul;

(* commutation des variants troncon 1 *)
(* en fonction de la position de l'aiguille 11_21 *)

IF Tvrai (AigVES11_21.PosNormaleFiltree) THEN
	AffectBoolD (PtArrCdvVES12 , com1troncon1);
	AffectBoolD (PtArrSigVES12 , com2troncon1);
	AffectBoolD (BoolRestrictif, com3troncon1);
	AffectBoolD (PtArrSigVES14B, com4troncon1);
	AffectBoolD (BoolRestrictif, com5troncon1);
	AffectBoolD (BoolRestrictif, com6troncon1);
	AffectBoolD (BoolRestrictif, com7troncon1);
	FinBranche(1);  
   ELSE
	IF Tvrai (AigVES11_21.PosReverseFiltree) THEN
		AffectBoolD (PtArrSigVES22B, com1troncon1);
		AffectBoolD (BoolRestrictif, com2troncon1);
		AffectBoolD (BoolRestrictif, com3troncon1);
		AffectBoolD (BoolRestrictif, com4troncon1);
		AffectBoolD (BoolRestrictif, com5troncon1);
		AffectBoolD (BoolRestrictif, com6troncon1);
		AffectBoolD (BoolRestrictif, com7troncon1);
		FinBranche(2);
	ELSE 
	  	AffectBoolD (BoolRestrictif, com1troncon1);
	  	AffectBoolD (BoolRestrictif, com2troncon1);
	  	AffectBoolD (BoolRestrictif, com3troncon1);
	  	AffectBoolD (BoolRestrictif, com4troncon1);
		AffectBoolD (BoolRestrictif, com5troncon1);
		AffectBoolD (BoolRestrictif, com6troncon1);
	  	AffectBoolD (BoolRestrictif, com7troncon1);
	  	FinBranche(3);
	END;
END;
FinArbre(BaseExeSpecific);


END ExeSpecific;
END Specific.


















