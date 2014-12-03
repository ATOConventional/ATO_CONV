 IMPLEMENTATION MODULE Specific;

(*$S- *)
(*$T- *)


(*****************************************************************************)
(*   SANTIAGO - Ligne 2 - Secteur 18                                         *)
(*  =============================                                            *)
(*                                                                           *)
(* Version  1.0.1  =====================                                     *)
(* Version  1.1 DU SERVEUR SCCS =====================                        *)
(* Date :          11/05/2004                                                *)
(* Auteur :        M. Plywacz                                                *)
(* Modification :  Version pour prolongement 2                               *)
(*---------------------------------------------------------------------------*)
(*                                                                           *)
(*****************************************************************************)
(* Version 1.0.2  =====================                                      *)
(* Version 1.2 DU SERVEUR SCCS =====================                         *)
(* Date :         09/07/2004                                                 *)
(* Auteur:        Marc Plywacz                                               *)
(* Modification : Supprim .  dans Tr 18.4 :  PtArrCdvCEB11                   *)
(*                Supprim .  emissions seg sur Tr 18.1 ; 18.2 ; 18.4         *)
(*                decale rang 1er var ant  sur Tr 18.1                       *)
(*                Supprim .  configurerAmpli(Ampli43 ....                    *)
(*                                                                           *)
(*****************************************************************************)
(* Version 1.0.3  =====================                                      *)
(* Version 1.3 DU SERVEUR SCCS =====================                         *)
(* Date :         17/08/2004                                                 *)
(* Auteur:        Marc Plywacz                                               *)
(* Modification : Ajustement marches types                                   *)
(*                                                                           *)
(*****************************************************************************)
(* Version 1.0.4  =====================                                      *)
(* Version 1.4 DU SERVEUR SCCS =====================                         *)
(* Date :         20/06/2005                                                 *)
(* Auteur:        Marc Plywacz                                               *)
(* Modification : Prolongement 2 raccordement au secteur 19                  *)
(*                                                                           *)
(*****************************************************************************)
(* Version 1.0.5  =====================                                      *)
(* Version 1.5 DU SERVEUR SCCS =====================                         *)
(* Date :         08/08/2005                                                 *)
(* Auteur:        Marc Plywacz                                               *)
(* Modification : Prise en compte remarques validation  ; Ajouts             *)
(*                Variants troncon 1 : tivcom + aiguille 13/23               *)
(*                StockAdres( ADR( PtArrCdvCEB21   ))                        *) 
(*                ConfigurerAmpli(Ampli15 , 17                               *)
(*                ConfigurerAmpli(Ampli61                                    *)
(*                                                                           *)
(*****************************************************************************)
(* Version 1.0.6  =====================                                      *)
(* Version 1.6 DU SERVEUR SCCS =====================                         *)
(* Date :         14/10/2005                                                 *)
(* Auteur:        Ph HOG                                                     *)
(* Modification : Prise en compte remarques site                             *)
(*                Le cdv REC11 et les variables associées deviennent REC13   *)
(*                Le cdv CEB15 et les variables associées deviennent REC11   *)
(*                Reprise des entrées selon le doc de basculement 1.0.1      *)
(*                Suppression du point d'arrêt PtArrCdvCEB22                 *)
(*                         (troncon 6 et et anticipation sur troncon 3)      *)
(*                                                                           *)
(*****************************************************************************)
(* Version 1.0.7  =====================                                      *)
(* Version 1.7 DU SERVEUR SCCS =====================                         *)
(* Date :         03/11/2005                                                 *)
(* Auteur:        P Amsellem                                                 *)
(* Modification : correction des marches types PA                            *)
(*                                                                           *)
(*****************************************************************************)
(* Version 1.0.8  =====================                                      *)
(* Version 1.8 DU SERVEUR SCCS =====================                         *)
(* Date :         14/11/2005                                                 *)
(* Auteur:        Ph. Hog                                                    *)
(* Modification : correction de l'initialisation des entrées securitaires    *)
(*                CdvCEB22 et CdvCEB14                                       *)
(*****************************************************************************)
(* Version 1.0.9  =====================                                      *)
(* Version 1.9 DU SERVEUR SCCS =====================                         *)
(* Date :         07/08/2006                                                 *)
(* Auteur:        Rudy Nsiona                                                *)
(* Modification : Nouveau Train NS2004                                       *)
(* Procédure CONFIGURATION DES TRONCONS TSR                                   *)
(*                ancienne valeur 1 , nouvelle 2                             *)


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
		       Boucle1, Boucle2, Boucle3, Boucle4, Boucle5, Boucle6,
		       CarteCes1,  CarteCes2,  CarteCes3,
		       Intersecteur1,

		       Ampli11, Ampli12, Ampli13, Ampli14, Ampli15, Ampli17,
	               Ampli21, Ampli22, Ampli23, Ampli24,
	               Ampli31, Ampli32, Ampli33, Ampli34, Ampli35, Ampli37,
 	               Ampli41, Ampli42,          Ampli44,
 	               Ampli51, Ampli52,          Ampli54,
	               Ampli61, Ampli62, Ampli63, Ampli64,


   (* procedures *)
		       ConfigurerBoucle,
		       ConfigurerIntsecteur,
		       ConfigurerCES,
		       ConfigurerAmpli;

FROM BibTsr      IMPORT
   (* variables *)
		       Tronc0, Tronc1, Tronc2, Tronc3, Tronc4, Tronc5, 
		       Tronc6, Tronc7, Tronc8, Tronc9,
		       Tronc10,Tronc11,Tronc12,Tronc13,Tronc14,Tronc15, (* inutilises *)
   (* procedures *)
	               ConfigurerTroncon;

FROM ESbin       IMPORT
   (* procedures *)
		       ProcEntreeIntrins;

(*****************************  CONSTANTES  ***********************************)

CONST

(** No ligne, No secteur, ....**)


    LigneL02 = 16384*00; (* numero de ligne decale de 2**14 *)

    L0219  = 1024*19;    (* numero Secteur aval voie impaire decale de 2**10 *)

    L0218  = 1024*18;    (* numero Secteur local decale de 2**10 *)

    L0211  = 1024*11;    (* numero Secteur amont voie impaire decale de 2**10 *)

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
    noBoucleCal = 00;
    noBoucleEin = 01;
    noBoucle1 = 03;
    noBoucle2 = 04;
    noBoucle3 = 05;
    noBoucle4 = 06;
    noBoucle5 = 07;
    noBoucle6 = 08;


(** Base pour les tables de compensation **)
    BaseEntVar  = 500   ;
    BaseSorVar  = 600   ;
    BaseExeAig  = 1280  ;
    BaseExeChainage = 1360 ;
    BaseExeSpecific = 1950 ;



(******************** DECLARATION DES VARIABLES GENERALES ********************)
 VAR

(* DECLARATION DES SINGULARITES DU SECTEUR 18 : dans les deux sens confondus *)

(* Declaration des variables correspondant a des entrees securitaires       *)
(*   - CDV et signaux                                                       *)

   CdvCEB10,       (* entree  1, soit entree 0 de CES 02  *)
   CdvCEB11,       (* entree  2, soit entree 1 de CES 02  *)
   CdvCEB12,       (* entree  3, soit entree 2 de CES 02  *)
   CdvCEB13,       (* entree  4, soit entree 3 de CES 02  *)

   (* entree 5 = CdvCEB14 + CdvREC11 pour ancien SACEM *)
   (* pas utilisé *)(* entree  5, soit entree 4 de CES 02  *)

   SigCEB10,       (* entree  8, soit entree 7 de CES 02  *)

   SigCEB12kv,     (* entree  9, soit entree 0 de CES 03  *)
   SigCEB12kj,     (* entree 10, soit entree 1 de CES 03  *)
   SigCEB24kv,     (* entree 11, soit entree 2 de CES 03  *)
   SigCEB24kj,     (* entree 12, soit entree 3 de CES 03  *)
   SigCEB26,       (* entree 13, soit entree 4 de CES 03  *)
   CdvCEB25,       (* entree 14, soit entree 5 de CES 03  *)
   CdvCEB24,       (* entree 15, soit entree 6 de CES 03  *)
   CdvCEB23,       (* entree 16, soit entree 7 de CES 03  *)

   CdvREC12,       (* entree 17, soit entree 0 de CES 04  *)
   CdvREC13,       (* entree 18, soit entree 1 de CES 04  *)
   CdvCEB22,       (* entree 19, soit entree 2 de CES 04  *)
   CdvREC26,       (* entree 20, soit entree 3 de CES 04  *)
   CdvREC22,       (* entree 21, soit entree 4 de CES 04  *)
   CdvREC11,       (* entree 22, soit entree 5 de CES 04  *)
   CdvCEB21,       (* entree 23, soit entree 6 de CES 04  *)
   CdvCEB14        (* entree 24, soit entree 7 de CES 04  *)
             : BoolD;

   AigCEB13_23     (* entrees 6 & 7, soit entrees 5 & 6 de CES 02 *) 
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

    PtArrCdvCEB10,
    PtArrSigCEB10,
    PtArrSigCEB12,
    PtArrCdvREC11,

    PtArrCdvREC12,
    PtArrCdvREC13,

    PtArrCdvREC22,
    PtArrCdvREC26,
    PtArrSigCEB26,
    PtArrSigCEB24,
    PtArrCdvCEB21            : BoolD;

 (* Tiv Com *)
    TivComSigCEB24           : BoolD;


 (* Variants anticipes *)

    PtAntCdvCEM21,
    PtAntCdvCEM22,
    PtAntCdvCEM23,
    PtAntCdvCAL10,
    PtAntSigCAL10            : BoolD;


(***********************************************************)
(* Copie des entrees dans des variables fonctionnelles pour la regulation   *)
 
 CdvCEB12Fonc,
 CdvCEB22Fonc,
 CdvREC12Fonc,
 CdvREC22Fonc           : BOOLEAN;

(** Voie d'emission SOL-TRAIN : deux sens confondus**)

    te11s18t01,
    te14s18t03,
    te17s18t05,
    te26s18t06,
    te21s18t02,
    te24s18t04     :TyEmissionTele;

(** Voie d'emission Inter-secteur deux voies confondues **)
    teL0211,
    teL0219        :TyEmissionTele;

(** Voie de reception Inter-secteur deux voies confondues **)
    trL0211,
    trL0219        :TyCaracEntSec;

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

   EntreeAiguille(AigCEB13_23,  7, 6 ); (* Aig --> Droite = Branch Normale *) 


(* Configuration des entrees *)
   ProcEntreeIntrins ( 1,   CdvCEB10   );
   ProcEntreeIntrins ( 2,   CdvCEB11   );
   ProcEntreeIntrins ( 3,   CdvCEB12   );
   ProcEntreeIntrins ( 4,   CdvCEB13   );
   (* Entree 5 pas utilisee *)

   ProcEntreeIntrins ( 8,   SigCEB10   );

   ProcEntreeIntrins ( 9,   SigCEB12kv  );
   ProcEntreeIntrins (10,   SigCEB12kj  );
   ProcEntreeIntrins (11,   SigCEB24kv  );
   ProcEntreeIntrins (12,   SigCEB24kj  );
   ProcEntreeIntrins (13,   SigCEB26    );
   ProcEntreeIntrins (14,   CdvCEB25    );
   ProcEntreeIntrins (15,   CdvCEB24    );
   ProcEntreeIntrins (16,   CdvCEB23    );

   ProcEntreeIntrins (17,   CdvREC12    );
   ProcEntreeIntrins (18,   CdvREC13    );
   ProcEntreeIntrins (19,   CdvCEB22    );
   ProcEntreeIntrins (20,   CdvREC26   );
   ProcEntreeIntrins (21,   CdvREC22   );
   ProcEntreeIntrins (22,   CdvREC11   );
   ProcEntreeIntrins (23,   CdvCEB21   );
   ProcEntreeIntrins (24,   CdvCEB14   );



(* CONFIGURATION POUR LA MAINTENANCE de la transmission continue *)
   ConfigurerBoucle(Boucle1, 1);
   ConfigurerBoucle(Boucle2, 2);
   ConfigurerBoucle(Boucle3, 3);
   ConfigurerBoucle(Boucle4, 4);
   ConfigurerBoucle(Boucle5, 5);
   ConfigurerBoucle(Boucle6, 6);

(* PTC 1 *)
   ConfigurerAmpli(Ampli11, 1, 1, 154, 11, FALSE);
   ConfigurerAmpli(Ampli12, 1, 2, 155, 12, FALSE);
   ConfigurerAmpli(Ampli13, 1, 3, 156, 12, FALSE);
   ConfigurerAmpli(Ampli14, 1, 4, 157, 12, TRUE);
   ConfigurerAmpli(Ampli15, 1, 5, 158, 13, FALSE);
   ConfigurerAmpli(Ampli17, 1, 7, 192, 13, TRUE);

   ConfigurerAmpli(Ampli31, 3, 1, 193, 14, FALSE);
   ConfigurerAmpli(Ampli32, 3, 2, 194, 15, FALSE);
   ConfigurerAmpli(Ampli33, 3, 3, 195, 15, FALSE);
   ConfigurerAmpli(Ampli34, 3, 4, 196, 15, TRUE);
   ConfigurerAmpli(Ampli35, 3, 5, 197, 16, FALSE);
   ConfigurerAmpli(Ampli37, 3, 7, 199, 16, TRUE);

   ConfigurerAmpli(Ampli51, 5, 1, 200, 17, FALSE);
   ConfigurerAmpli(Ampli52, 5, 2, 201, 18, FALSE);
   ConfigurerAmpli(Ampli54, 5, 4, 203, 18, TRUE);


(* PTC 2 *)
   ConfigurerAmpli(Ampli21, 2, 1, 204, 21, FALSE);
   ConfigurerAmpli(Ampli22, 2, 2, 205, 22, FALSE);
   ConfigurerAmpli(Ampli23, 2, 3, 206, 22, FALSE);
   ConfigurerAmpli(Ampli24, 2, 4, 207, 22, TRUE);

   ConfigurerAmpli(Ampli41, 4, 1, 211, 24, FALSE);
   ConfigurerAmpli(Ampli42, 4, 2, 212, 25, FALSE);
   ConfigurerAmpli(Ampli44, 4, 4, 214, 25, TRUE);

   ConfigurerAmpli(Ampli61, 6, 1, 215, 26, FALSE);
   ConfigurerAmpli(Ampli62, 6, 2, 216, 27, FALSE);
   ConfigurerAmpli(Ampli63, 6, 3, 217, 27, FALSE);
   ConfigurerAmpli(Ampli64, 6, 4, 218, 27, TRUE);


 
(** cartes CES **)
   ConfigurerCES(CarteCes1, 01);
   ConfigurerCES(CarteCes2, 02);
   ConfigurerCES(CarteCes3, 03);

(** Liaisons Inter-Secteur **)

   ConfigurerIntsecteur(Intersecteur1, 01, trL0211, trL0219);


(* Initialisations des variables ne correspondant pas a des entrees secu *)

(* Affectation a l'etat restrictif des variants commutes *)
   AffectBoolD(BoolRestrictif, com1troncon1) ;
   AffectBoolD(BoolRestrictif, com2troncon1) ;
   AffectBoolD(BoolRestrictif, com3troncon1) ;
   AffectBoolD(BoolRestrictif, com4troncon1) ;
   AffectBoolD(BoolRestrictif, com5troncon1) ;

(* Point d'arret *)

   AffectBoolD( BoolRestrictif, PtArrCdvCEB10   );
   AffectBoolD( BoolRestrictif, PtArrSigCEB10   );
   AffectBoolD( BoolRestrictif, PtArrSigCEB12   );
   AffectBoolD( BoolRestrictif, PtArrCdvREC11   );

   AffectBoolD( BoolRestrictif, PtArrCdvREC12   );
   AffectBoolD( BoolRestrictif, PtArrCdvREC13   );

   AffectBoolD( BoolRestrictif, PtArrCdvREC22   );
   AffectBoolD( BoolRestrictif, PtArrCdvREC26   );
   AffectBoolD( BoolRestrictif, PtArrSigCEB26   );
   AffectBoolD( BoolRestrictif, PtArrSigCEB24   );
   AffectBoolD( BoolRestrictif, PtArrCdvCEB21   );



(* Variants anticipes *)
   AffectBoolD( BoolRestrictif, PtAntCdvCAL10   );
   AffectBoolD( BoolRestrictif, PtAntSigCAL10   );

   AffectBoolD( BoolRestrictif, PtAntCdvCEM21   );
   AffectBoolD( BoolRestrictif, PtAntCdvCEM22   );
   AffectBoolD( BoolRestrictif, PtAntCdvCEM23   );


(* Regulation *)
 CdvCEB12Fonc := FALSE;
 CdvCEB22Fonc := FALSE;
 CdvREC12Fonc := FALSE;
 CdvREC22Fonc := FALSE;

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

   ConfigEmisTeleSolTrain ( te11s18t01,
			    noBoucle1,
			    BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te14s18t03,
			    noBoucle3,
			    BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te17s18t05,
			    noBoucle5,
			    BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);


   ConfigEmisTeleSolTrain ( te21s18t02,
			    noBoucle2,
			    BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te24s18t04,
			    noBoucle4,
			    BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te26s18t06,
			    noBoucle6,
			    BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);


(* CONFIGURATION POUR LA REGULATION *)

   ConfigQuai(47, 64, CdvCEB12Fonc, te11s18t01, 0,  4, 5,10, 6,  13,14,15);

   ConfigQuai(47, 69, CdvCEB22Fonc, te26s18t06, 0, 8,9, 11, 5,  13,14,15);

   ConfigQuai(46, 74, CdvREC12Fonc, te21s18t02, 0,  3, 9,11, 5,  13,14,15);

   ConfigQuai(46, 79, CdvREC22Fonc, te14s18t03, 0,  9, 11, 5, 6,  13,14,15);


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

   ProcEmisSolTrain( te11s18t01.EmissionSensUp, (2*noBoucle1),
		     LigneL02+ L0218+ TRONC*01,

 		  PtArrSigCEB10,
 		  BoolRestrictif, (* AspectCroix *)
 		  PtArrSigCEB12,
 		  BoolRestrictif, (* AspectCroix *)
		  AigCEB13_23.PosNormaleFiltree,   (* TIV Com *)
		  AigCEB13_23.PosReverseFiltree,
		  AigCEB13_23.PosNormaleFiltree,
 		  BoolRestrictif,
(* Variants Anticipes *)
		  PtArrCdvREC11,
 		  PtArrCdvREC12,
 		  PtArrCdvREC13,
 		  PtAntCdvCAL10,
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



(* variants troncon 2 *)

   ProcEmisSolTrain( te21s18t02.EmissionSensUp, (2*noBoucle2),
		     LigneL02+ L0218+ TRONC*02,

		  PtArrCdvREC11,
 		  PtArrCdvREC12,
 		  PtArrCdvREC13,
 		  PtAntCdvCAL10,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,		  
		  BoolRestrictif,
(* Variants Anticipes *)
		  PtAntSigCAL10,
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
		  BoolRestrictif,
		  BoolPermissif,
		  BaseSorVar + 30);


(* variants troncon 3 *)

   ProcEmisSolTrain( te14s18t03.EmissionSensUp, (2*noBoucle3),
		     LigneL02+ L0218+ TRONC*03,

		  PtArrCdvREC26,
		  PtArrSigCEB26,
		  BoolRestrictif,  (* AspectCroix *)
		  PtArrSigCEB24,
		  BoolRestrictif,  (* AspectCroix *)
		  AigCEB13_23.PosNormaleFiltree,   (* TIV Com *)
		  AigCEB13_23.PosReverseFiltree,
		  AigCEB13_23.PosNormaleFiltree,
(* Variants Anticipes *)
		  BoolRestrictif,
		  BoolRestrictif,
		  PtArrCdvCEB21,
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


(* variants troncon 4 *)

   ProcEmisSolTrain( te24s18t04.EmissionSensUp, (2*noBoucle4),
		     LigneL02+ L0218+ TRONC*04,

		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
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
		  BaseSorVar + 90);


(* variants troncon 5 *)

   ProcEmisSolTrain( te17s18t05.EmissionSensUp, (2*noBoucle5),
		     LigneL02+ L0218+ TRONC*05,

		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
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
		  BaseSorVar + 120);


(* variants troncon 6 *)

   ProcEmisSolTrain( te26s18t06.EmissionSensUp, (2*noBoucle6),
		     LigneL02+ L0218+ TRONC*06,

		  PtArrCdvCEB21,
		  PtAntCdvCEM23,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
(* Variants Anticipes *)
		  PtAntCdvCEM22,
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
		  BaseSorVar + 150);



(* reception du secteur 11 aval *)
   ProcReceptInterSecteur(trL0211, noBoucleCal, LigneL02+ L0211+ TRONC*01,
		  PtAntCdvCAL10,
		  PtAntSigCAL10,
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


(* reception du secteur 19 amont *)
   ProcReceptInterSecteur(trL0219, noBoucleEin, LigneL02+ L0219+ TRONC*02,
		  PtAntCdvCEM21,
		  PtAntCdvCEM22,
		  PtAntCdvCEM23,
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
		  BaseEntVar + 5,
		  V1,
		  V2,
		  V3,
		  V4,
		  V5,
		  V6,
		  BaseEntVar + 6);



(* emission vers le secteur 11 aval *)
   ProcEmisInterSecteur (teL0211, noBoucleCal, LigneL02+ L0218+ TRONC*03,
			noBoucleCal,
		  PtArrCdvREC22,
		  PtArrCdvREC26,
		  PtArrSigCEB26,
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


(* emission vers le secteur 19 amont *)
   ProcEmisInterSecteur (teL0219, noBoucleEin, LigneL02+ L0218+ TRONC*01,
			noBoucleEin,
		  PtArrCdvCEB10,
		  PtArrSigCEB10,
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
		  V1,
		  V2,
		  V3,
		  V4,
		  V5,
		  V6,
		  BaseSorVar + 240);


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

 (** Emission invariants vers secteur aval L0211 **)
   EmettreSegm(LigneL02+ L0218+ TRONC*03+ SEGM*00, noBoucleCal, SensUp);
   EmettreSegm(LigneL02+ L0218+ TRONC*03+ SEGM*01, noBoucleCal, SensUp);

 (** Emission invariants vers secteur amont L0219 **)
   EmettreSegm(LigneL02+ L0218+ TRONC*01+ SEGM*00, noBoucleEin, SensUp);
   EmettreSegm(LigneL02+ L0218+ TRONC*02+ SEGM*00, noBoucleEin, SensUp);


 (** Boucle 1 **)
   EmettreSegm(LigneL02+ L0218+ TRONC*01+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL02+ L0218+ TRONC*02+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL02+ L0218+ TRONC*02+ SEGM*01, noBoucle1, SensUp);
   EmettreSegm(LigneL02+ L0218+ TRONC*05+ SEGM*00, noBoucle1, SensUp);

 (** Boucle 2 **)
   (* EmettreSegm(LigneL02+ L0218+ TRONC*02+ SEGM*00, noBoucle2, SensUp); *)
   (* EmettreSegm(LigneL02+ L0218+ TRONC*02+ SEGM*01, noBoucle2, SensUp); *)
   EmettreSegm(LigneL02+ L0211+ TRONC*01+ SEGM*01, noBoucle2, SensUp);
   EmettreSegm(LigneL02+ L0211+ TRONC*01+ SEGM*02, noBoucle2, SensUp);

 (** Boucle 3 **)
   EmettreSegm(LigneL02+ L0218+ TRONC*03+ SEGM*00, noBoucle3, SensUp);  
   EmettreSegm(LigneL02+ L0218+ TRONC*03+ SEGM*01, noBoucle3, SensUp);  
   EmettreSegm(LigneL02+ L0218+ TRONC*04+ SEGM*00, noBoucle3, SensUp);  
   EmettreSegm(LigneL02+ L0218+ TRONC*06+ SEGM*00, noBoucle3, SensUp); 
   EmettreSegm(LigneL02+ L0219+ TRONC*02+ SEGM*00, noBoucle3, SensUp); 

 (** Boucle 4 **)
   (* EmettreSegm(LigneL02+ L0218+ TRONC*04+ SEGM*00, noBoucle4, SensUp); *)
   EmettreSegm(LigneL02+ L0218+ TRONC*01+ SEGM*00, noBoucle4, SensUp); 

 (** Boucle 5 **)
   EmettreSegm(LigneL02+ L0218+ TRONC*03+ SEGM*01, noBoucle5, SensUp); 
   EmettreSegm(LigneL02+ L0218+ TRONC*06+ SEGM*00, noBoucle5, SensUp); 

 (** Boucle 6 **)
   EmettreSegm(LigneL02+ L0219+ TRONC*02+ SEGM*00, noBoucle6, SensUp); 
   EmettreSegm(LigneL02+ L0219+ TRONC*02+ SEGM*01, noBoucle6, SensUp); 



(* CONFIGURATION DES TRONCONS TSR *********************************)

   ConfigurerTroncon(Tronc0, LigneL02 + L0218 + TRONC*01, 2,2,2,2);  (* troncon 18-1 *)
   ConfigurerTroncon(Tronc1, LigneL02 + L0218 + TRONC*02, 2,2,2,2);  (* troncon 18-2 *)
   ConfigurerTroncon(Tronc2, LigneL02 + L0218 + TRONC*03, 2,2,2,2);  (* troncon 18-3 *)
   ConfigurerTroncon(Tronc3, LigneL02 + L0218 + TRONC*04, 2,2,2,2);  (* troncon 18-4 *)
   ConfigurerTroncon(Tronc4, LigneL02 + L0218 + TRONC*05, 2,2,2,2);  (* troncon 18-5 *)
   ConfigurerTroncon(Tronc5, LigneL02 + L0218 + TRONC*06, 2,2,2,2);  (* troncon 18-6 *)


(* EMISSION DES TSR SUR VOIE 1 ***********************************************)

 (** Emission des TSR vers le secteur aval L0218 **)
   EmettreTronc(LigneL02+ L0218+ TRONC*03, noBoucleCal, SensUp);

 (** Emission des TSR vers le secteur amont L0219 **)
   EmettreTronc(LigneL02+ L0218+ TRONC*01, noBoucleEin, SensUp);
   EmettreTronc(LigneL02+ L0218+ TRONC*02, noBoucleEin, SensUp);

 (** Emission des TSR sur les troncons du secteur courant **)
   EmettreTronc(LigneL02+ L0218+ TRONC*01, noBoucle1, SensUp); (* troncon 18-1 *)
   EmettreTronc(LigneL02+ L0218+ TRONC*02, noBoucle1, SensUp);
   EmettreTronc(LigneL02+ L0218+ TRONC*05, noBoucle1, SensUp);

   EmettreTronc(LigneL02+ L0218+ TRONC*02, noBoucle2, SensUp); (* troncon 18-2 *)
   EmettreTronc(LigneL02+ L0211+ TRONC*01, noBoucle2, SensUp);

   EmettreTronc(LigneL02+ L0218+ TRONC*03, noBoucle3, SensUp); (* troncon 18-3 *)
   EmettreTronc(LigneL02+ L0218+ TRONC*04, noBoucle3, SensUp);
   EmettreTronc(LigneL02+ L0218+ TRONC*06, noBoucle3, SensUp);
   EmettreTronc(LigneL02+ L0219+ TRONC*02, noBoucle3, SensUp);

   EmettreTronc(LigneL02+ L0218+ TRONC*04, noBoucle4, SensUp); (* troncon 18-4 *)
   EmettreTronc(LigneL02+ L0218+ TRONC*01, noBoucle4, SensUp);

   EmettreTronc(LigneL02+ L0218+ TRONC*05, noBoucle5, SensUp); (* troncon 18-5 *)
   EmettreTronc(LigneL02+ L0218+ TRONC*06, noBoucle5, SensUp);
   EmettreTronc(LigneL02+ L0218+ TRONC*03, noBoucle5, SensUp);

   EmettreTronc(LigneL02+ L0218+ TRONC*06, noBoucle6, SensUp); (* troncon 18-6 *)
   EmettreTronc(LigneL02+ L0219+ TRONC*02, noBoucle6, SensUp);


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


   StockAdres( ADR(CdvCEB10   ));
   StockAdres( ADR(CdvCEB11   ));
   StockAdres( ADR(CdvCEB12   ));
   StockAdres( ADR(CdvCEB13   ));
   StockAdres( ADR(CdvCEB14   ));
   StockAdres( ADR(CdvREC11   ));

   StockAdres( ADR(SigCEB10   ));

   StockAdres( ADR(SigCEB12kv ));
   StockAdres( ADR(SigCEB12kj ));
   StockAdres( ADR(SigCEB24kv ));
   StockAdres( ADR(SigCEB24kj ));
   StockAdres( ADR(SigCEB26   ));
   StockAdres( ADR(CdvCEB25   ));
   StockAdres( ADR(CdvCEB24   ));
   StockAdres( ADR(CdvCEB23   ));

   StockAdres( ADR(CdvCEB22   ));
   StockAdres( ADR(CdvCEB21   ));

   StockAdres( ADR(CdvREC12   ));
   StockAdres( ADR(CdvREC13   ));
   StockAdres( ADR(CdvREC26   ));
   StockAdres( ADR(CdvREC22   ));


   StockAdres( ADR( AigCEB13_23 )); 

   StockAdres( ADR(com1troncon1));
   StockAdres( ADR(com2troncon1));
   StockAdres( ADR(com3troncon1));
   StockAdres( ADR(com4troncon1));
   StockAdres( ADR(com5troncon1));


(* Points d'arret *)
   StockAdres( ADR( PtArrCdvCEB10   ));
   StockAdres( ADR( PtArrSigCEB10   ));
   StockAdres( ADR( PtArrSigCEB12   ));
   StockAdres( ADR( PtArrCdvREC11   ));

   StockAdres( ADR( PtArrCdvREC12   ));
   StockAdres( ADR( PtArrCdvREC13   ));

   StockAdres( ADR( PtArrCdvREC22   ));
   StockAdres( ADR( PtArrCdvREC26   ));
   StockAdres( ADR( PtArrSigCEB26   ));

   StockAdres( ADR( PtArrSigCEB24   ));
   StockAdres( ADR( PtArrCdvCEB21   ));


   StockAdres( ADR( PtAntCdvCAL10   ));
   StockAdres( ADR( PtAntSigCAL10   ));

   StockAdres( ADR( PtAntCdvCEM21 ));
   StockAdres( ADR( PtAntCdvCEM22 ));
   StockAdres( ADR( PtAntCdvCEM23 ));


END StockerAdresse ;

(* Saut de page *)
(*----------------------------------------------------------------------------*)
PROCEDURE InitInutil ;
(*----------------------------------------------------------------------------*)
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
 CdvCEB22Fonc := CdvCEB22.F = Vrai.F;
 CdvCEB12Fonc := CdvCEB12.F = Vrai.F;
 CdvREC12Fonc := CdvREC12.F = Vrai.F;
 CdvREC22Fonc := CdvREC22.F = Vrai.F;




(**** FILTRAGE DES AIGUILLES **************************************************)

  FiltrerAiguille(AigCEB13_23, BaseExeAig ) ;
 (* FiltrerAiguille(AigCEB11_21, BaseExeAig + 2) ; *)


(**** DETERMINATION DES POINTS D'ARRET ****************************************)

   
   AffectBoolD( CdvCEB10,    PtArrCdvCEB10  );
   AffectBoolD( SigCEB10,    PtArrSigCEB10  );
   
   AffectBoolD( CdvREC11,    PtArrCdvREC11  );

   AffectBoolD( CdvREC12,    PtArrCdvREC12  );
   AffectBoolD( CdvREC13,    PtArrCdvREC13  );
   

   AffectBoolD( CdvREC22,    PtArrCdvREC22  );
   AffectBoolD( CdvREC26,    PtArrCdvREC26  );
   
   AffectBoolD( SigCEB26,    PtArrSigCEB26  );

   
   OuDD( SigCEB24kv,  SigCEB24kj,  PtArrSigCEB24 );
   
   OuDD( SigCEB12kv,  SigCEB12kj,  PtArrSigCEB12 );
   
   AffectBoolD( CdvCEB21,    PtArrCdvCEB21  );


(*** lecture des entrees de regulation ***)
   LireEntreesRegul;

END ExeSpecific;
END Specific.
