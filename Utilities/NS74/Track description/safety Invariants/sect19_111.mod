IMPLEMENTATION MODULE Specific;

(*$S- *)
(*$T- *)


(*****************************************************************************)
(*   SANTIAGO - Ligne 2 - Secteur 19                                         *)
(*  =============================                                            *)
(*                                                                           *)
(* Version  1.0.0  =====================                                     *)
(* Version  1.1 DU SERVEUR SCCS =====================                        *)
(* Date :          11/05/2005                                                *)
(* Auteur :        M. Plywacz                                                *)
(* Modification :  Version initiale (prolongement 2 de la ligne 2)           *)
(*---------------------------------------------------------------------------*)
(*                                                                           *)
(*****************************************************************************)
(*                                                                           *)
(* Version 1.0.1  =====================                                      *)
(* Version 1.2 DU SERVEUR SCCS =====================                         *)
(* Date :         09/08/2005                                                 *)
(* Auteur:        Marc Plywacz                                               *)
(* Modification : Prise en compte remarques validation                       *)
(*                Ajouts  .  Equation PtArrSigEIN22                          *)
(*                Supprim .  emissions seg 19.9.0 sur Tr 19.4                *)
(*                Inversion entrees aiguilles : AigEIN13_23 , AigEIN11_21    *)
(*                                                                           *)
(*****************************************************************************)
(*                                                                           *)
(* Version 1.0.2  =====================                                      *)
(* Version 1.3 DU SERVEUR SCCS =====================                         *)
(* Date :         17/10/2005                                                 *)
(* Auteur:        Ph. Hog                                                    *)
(* Modification : Le point d'arret EP voie 1 a Einstein devient un arret Spe *)
(*                donc la variable PtArrCdvEIN12 est renomee en PtArrSpeEIN12*)
(*                                                                           *)
(*****************************************************************************)
(*                                                                           *)
(* Version 1.0.3  =====================                                      *)
(* Version 1.4 DU SERVEUR SCCS =====================                         *)
(* Date :         20/10/2005                                                 *)
(* Auteur:        Ph. Hog                                                    *)
(* Modification : Le point d'arret EP voie 2 a Einstein devient un arret Spe *)
(*                donc la variable PtArrCdvEIN22 est renomee en PtArrSpeEIN22*)
(*                                                                           *)
(*****************************************************************************)
(*                                                                           *)
(* Version 1.0.4  =====================                                      *)
(* Version 1.5 DU SERVEUR SCCS =====================                         *)
(* Date :         21/10/2005                                                 *)
(* Auteur:        Ph. Hog                                                    *)
(* Modification : Initialisation et StockAdres des variables des points      *)
(*                d'arrêt anticipés du secteur18.                            *)
(*                                                                           *)
(*****************************************************************************)
(*                                                                           *)
(* Version 1.0.5  =====================                                      *)
(* Version 1.6 DU SERVEUR SCCS =====================                         *)
(* Date :         03/11/2005                                                 *)
(* Auteur:        P. Amsellem                                                *)
(* Modification : correction des marches types PA                            *)
(*                                                                           *)
(*                                                                           *)
(*****************************************************************************)
(*                                                                           *)
(* Version 1.0.6  =====================                                      *)
(* Version 1.7 DU SERVEUR SCCS =====================                         *)
(* Date :         07/11/2005                                                 *)
(* Auteur:        P. Amsellem                                                *)
(* Modification : correction des marches types PA                            *)
(*                                                                           *)
(*                                                                           *)
(*****************************************************************************)
(*                                                                           *)
(* Version 1.0.7  =====================                                      *)
(* Version 1.8 DU SERVEUR SCCS =====================                         *)
(* Date :         13/12/2005                                                 *)
(* Auteur:        P. Amsellem                                                *)
(* Modification : correction des marches types PA (interstation CE-CB)       *)
(*                                                                           *)
(*                                                                           *)
(*****************************************************************************)
(*                                                                           *)
(* Version 1.0.8  =====================                                      *)
(* Version 1.9 DU SERVEUR SCCS =====================                         *)
(* Date :         27/10/2006                                                 *)
(* Auteur:        P. Amsellem                                                *)
(* Modification : emission du segment 4.1 dans la boucle 4                    *)
(*                                                                           *)
(*                                                                           *)
(*****************************************************************************)
(*                                                                           *)
(* Version 1.0.9  =====================                                      *)
(* Version 1.10 DU SERVEUR SCCS =====================                        *)
(* Date :         24/11/2006                                                 *)
(* Auteur:        P. Amsellem                                                *)
(* Modification : correction des marches types PA                            *)
(*                                                                           *)
(*                                                                           *)
(*****************************************************************************)
(*                                                                           *)
(* Version 1.1.0  =====================                                      *)
(* Version 1.11 DU SERVEUR SCCS =====================                        *)
(* Date :         17/01/2007                                                 *)
(* Auteur:        P. Amsellem                                                *)
(* Modification : correction des marches types PA                            *)
(*                                                                           *)
(*                                                                           *)
(*****************************************************************************)
(* Version 1.1.1  =====================                                      *)
(* Version 1.12 DU SERVEUR SCCS =====================                         *)
(* Date :         07/03/2007                                                 *)
(* Auteur:        P. Amsellem                                                *)
(* Modification : Nouveau Train NS2004                                       *)
(* Procédure CONFIGURATION DES TRONCONS TSR                                  *)
(*                ancienne valeur 1 , nouvelle 2                             *)
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
		       Boucle1, Boucle2, Boucle3,  Boucle4, Boucle5, Boucle6,
		       Boucle7, Boucle8, Boucle9,  

		       CarteCes1,  CarteCes2,  CarteCes3,  CarteCes4,  CarteCes5,
		       Intersecteur1,

		       Ampli11, Ampli12, Ampli13, Ampli14,
	               Ampli21, Ampli22, Ampli23, Ampli24, Ampli25, Ampli26, Ampli27,
	               Ampli31, Ampli32, Ampli33, Ampli34, Ampli35,          Ampli37,
 	               Ampli41, Ampli42, Ampli43, Ampli44, Ampli45,          Ampli47,
	               Ampli51, Ampli52, Ampli53, Ampli54, Ampli55, Ampli56, Ampli57,
		       Ampli61, Ampli62, Ampli63, Ampli64,
		       Ampli71, Ampli72,          Ampli74,
		       Ampli81, Ampli82, Ampli83, Ampli84, Ampli85, Ampli86, Ampli87,
		    (*   Ampli91, Ampli92, Ampli93, Ampli94, *)

   (* procedures *)
		       ConfigurerBoucle,
		       ConfigurerIntsecteur,
		       ConfigurerCES,
		       ConfigurerAmpli;

FROM BibTsr      IMPORT
   (* variables *)
		       Tronc0, Tronc1, Tronc2, Tronc3,  
		       Tronc4, Tronc5, Tronc6, Tronc7, Tronc8, Tronc9,
		       Tronc10, Tronc11, Tronc12, Tronc13, Tronc14, Tronc15,
   (* procedures *)
	               ConfigurerTroncon;

FROM ESbin       IMPORT
   (* procedures *)
		       ProcEntreeIntrins;

(*****************************  CONSTANTES  ***********************************)

CONST

(** No ligne, No secteur, ....**)


    LigneL02 = 16384*00; (* numero de ligne decale de 2**14 *)

    L0218  = 1024*18;    (* numero Secteur aval voie impaire decale de 2**10 *)

    L0219  = 1024*19;    (* numero Secteur local decale de 2**10 *)

    L0220  = 1024*20;    (* numero Secteur amont voie impaire decale de 2**10 *)

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
    noBoucleCeb = 00;
    noBoucleVes = 01;
    noBoucle1 = 03;
    noBoucle2 = 04;
    noBoucle3 = 05;
    noBoucle4 = 06;
    noBoucle5 = 07;
    noBoucle6 = 08;
    noBoucle7 = 09;
    noBoucle8 = 10;
    noBoucle9 = 11;


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

   CdvCEM11,       (* entree  1, soit entree 0 de CES 02  *)
   CdvCEM12,       (* entree  2, soit entree 1 de CES 02  *)
   CdvCEM13,       (* entree  3, soit entree 2 de CES 02  *)
   CdvCEM21,       (* entree  4, soit entree 3 de CES 02  *)
   CdvCEM22,       (* entree  5, soit entree 4 de CES 02  *)
   CdvCEM23,       (* entree  6, soit entree 5 de CES 02  *)
   Sp1EIN,         (* entree  7, soit entree 6 de CES 02  *)
   Sp2EIN,         (* entree  8, soit entree 7 de CES 02  *)

   CdvEIN10,       (* entree  9, soit entree 0 de CES 03  *)
   CdvEIN11,       (* entree 10, soit entree 1 de CES 03  *)
   CdvEIN12,       (* entree 11, soit entree 2 de CES 03  *)
   CdvEIN13,       (* entree 12, soit entree 3 de CES 03  *)
   CdvEIN14,       (* entree 13, soit entree 4 de CES 03  *)
   CdvEIN20,       (* entree 14, soit entree 5 de CES 03  *)
   CdvEIN21,       (* entree 15, soit entree 6 de CES 03  *)
   CdvEIN22,       (* entree 16, soit entree 7 de CES 03  *)

   CdvEIN23,       (* entree 17, soit entree 0 de CES 04  *)
   CdvEIN24,       (* entree 18, soit entree 1 de CES 04  *)
   CdvEIN26,       (* entree 19, soit entree 2 de CES 04  *)
  (* aig *)        (* entree 20, soit entree 3 de CES 04  *)
  (* aig *)        (* entree 21, soit entree 4 de CES 04  *)
  (* aig *)        (* entree 22, soit entree 5 de CES 04  *)
  (* aig *)        (* entree 23, soit entree 6 de CES 04  *)
   SigEIN10kv,     (* entree 24, soit entree 7 de CES 04  *)

   SigEIN12Bkj,    (* entree 25, soit entree 0 de CES 05  *)
   SigEIN12Akv,    (* entree 26, soit entree 1 de CES 05  *)
   SigEIN12Akj,    (* entree 27, soit entree 2 de CES 05  *)
   SigEIN20kj,     (* entree 28, soit entree 3 de CES 05  *)
   SigEIN22kv,     (* entree 29, soit entree 4 de CES 05  *)
   SigEIN22kj,     (* entree 30, soit entree 5 de CES 05  *)
   SigEIN24kv,     (* entree 31, soit entree 6 de CES 05  *)
   SigEIN24kj,     (* entree 32, soit entree 7 de CES 05  *)

   SigEIN26kv,     (* entree 33, soit entree 0 de CES 06  *)
   CdvDOR11,       (* entree 34, soit entree 1 de CES 06  *)
   CdvDOR12,       (* entree 35, soit entree 2 de CES 06  *)
   CdvDOR13,       (* entree 36, soit entree 3 de CES 06  *)
   CdvDOR21,       (* entree 37, soit entree 4 de CES 06  *)
   CdvDOR22,       (* entree 38, soit entree 5 de CES 06  *)
   CdvDOR23        (* entree 39, soit entree 6 de CES 06  *)
             : BoolD;

   AigEIN11_21,    (* entrees 20 & 21, soit entrees 3 & 4 de CES 04 *) 
   AigEIN13_23     (* entrees 22 & 23, soit entrees 5 & 6 de CES 04 *) 
             : TyAig;


(* variants lies a une commutation d'aiguille *)
    com1troncon2,
    com2troncon2,
    com3troncon2,
    com4troncon2,
    com5troncon2 : BoolD; 


(***********************************************************)
(* Variables ne correspondant pas a une entree securitaire *)
(* Points d'arret *)

    PtArrSigEIN10,
    PtArrSigEIN12B,
    PtArrSigEIN12A,
    PtArrSigEIN20,
    PtArrSigEIN22,
    PtArrSigEIN24,
    PtArrSigEIN26,

PtArrSpeEIN20,

    PtArrCdvDOR11,
    PtArrCdvDOR12,
    PtArrCdvDOR13,
    PtArrCdvDOR21,
    PtArrCdvDOR22,
    PtArrCdvDOR23,

    PtArrCdvCEM11,
    PtArrCdvCEM12,
    PtArrCdvCEM13,

    PtArrCdvCEM21,
    PtArrCdvCEM22,
    PtArrCdvCEM23,

    PtArrCdvEIN10,
    PtArrSpeEIN12,
    PtArrSpeEIN22,
    PtArrCdvEIN26            : BoolD;

 (* Tiv Com *)

    TivComSigEIN22,
    TivComSigEIN24           : BoolD;


 (* Variants anticipes *)

    PtAntCdvZAP23,
    PtAntCdvZAP22,
    PtAntCdvZAP21,

    PtAntCdvCEB10,
    PtAntSigCEB10            : BoolD;


(***********************************************************)
(* Copie des entrees dans des variables fonctionnelles pour la regulation   *)
 
 CdvCEM12Fonc,
 CdvCEM22Fonc,
 CdvDOR12Fonc,
 CdvDOR22Fonc,
 CdvEIN12Fonc,
 CdvEIN22Fonc           : BOOLEAN;

(** Voie d'emission SOL-TRAIN : deux sens confondus**)

    te11s19t02,
    te14s19t04,
    te17s19t06,
    
    te21s19t05,
    te24s19t03,
    te27s19t07,

    te31s19t01,
    te34s19t08,
    te37s19t09     :TyEmissionTele;
         

(** Voie d'emission Inter-secteur deux voies confondues **)
    teL0218,
    teL0220        :TyEmissionTele;

(** Voie de reception Inter-secteur deux voies confondues **)
    trL0218,
    trL0220        :TyCaracEntSec;

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

   EntreeAiguille(AigEIN13_23, 23,22 ); (* Aig --> Droite = Branch Normale *) 
   EntreeAiguille(AigEIN11_21, 20,21 ); (* Aig --> Gauche = Branch Normale *) 


(* Configuration des entrees *)
   ProcEntreeIntrins ( 1,   CdvCEM11   );
   ProcEntreeIntrins ( 2,   CdvCEM12   );
   ProcEntreeIntrins ( 3,   CdvCEM13   );
   ProcEntreeIntrins ( 4,   CdvCEM21   );
   ProcEntreeIntrins ( 5,   CdvCEM22   );
   ProcEntreeIntrins ( 6,   CdvCEM23   );
   ProcEntreeIntrins ( 7,   Sp1EIN     );
   ProcEntreeIntrins ( 8,   Sp2EIN     );


   ProcEntreeIntrins ( 9,   CdvEIN10  );
   ProcEntreeIntrins (10,   CdvEIN11  );
   ProcEntreeIntrins (11,   CdvEIN12  );
   ProcEntreeIntrins (12,   CdvEIN13  );
   ProcEntreeIntrins (13,   CdvEIN14    );
   ProcEntreeIntrins (14,   CdvEIN20    );
   ProcEntreeIntrins (15,   CdvEIN21    );
   ProcEntreeIntrins (16,   CdvEIN22    );

   ProcEntreeIntrins (17,   CdvEIN23    );
   ProcEntreeIntrins (18,   CdvEIN24    );
   ProcEntreeIntrins (19,   CdvEIN26    );

   ProcEntreeIntrins (24,   SigEIN10kv   );

   ProcEntreeIntrins (25,   SigEIN12Bkj  );
   ProcEntreeIntrins (26,   SigEIN12Akv  );
   ProcEntreeIntrins (27,   SigEIN12Akj  );
   ProcEntreeIntrins (28,   SigEIN20kj  );
   ProcEntreeIntrins (29,   SigEIN22kv  );
   ProcEntreeIntrins (30,   SigEIN22kj  );
   ProcEntreeIntrins (31,   SigEIN24kv  );
   ProcEntreeIntrins (32,   SigEIN24kj  );

   ProcEntreeIntrins (33,   SigEIN26kv  );
   ProcEntreeIntrins (34,   CdvDOR11  );
   ProcEntreeIntrins (35,   CdvDOR12  );
   ProcEntreeIntrins (36,   CdvDOR13  );
   ProcEntreeIntrins (37,   CdvDOR21  );
   ProcEntreeIntrins (38,   CdvDOR22  );
   ProcEntreeIntrins (39,   CdvDOR23  );

(* CONFIGURATION POUR LA MAINTENANCE de la transmission continue *)
   ConfigurerBoucle(Boucle1, 1);
   ConfigurerBoucle(Boucle2, 2);
   ConfigurerBoucle(Boucle3, 3);
   ConfigurerBoucle(Boucle4, 4);
   ConfigurerBoucle(Boucle5, 5);
   ConfigurerBoucle(Boucle6, 6);
   ConfigurerBoucle(Boucle7, 7);
   ConfigurerBoucle(Boucle8, 8);
   ConfigurerBoucle(Boucle9, 9);

(* PTC 1 *)
   ConfigurerAmpli(Ampli21, 2, 1, 154, 11, FALSE);
   ConfigurerAmpli(Ampli22, 2, 2, 155, 12, FALSE);
   ConfigurerAmpli(Ampli23, 2, 3, 156, 12, FALSE);
   ConfigurerAmpli(Ampli24, 2, 4, 157, 12, TRUE);
   ConfigurerAmpli(Ampli25, 2, 5, 158, 13, FALSE);
   ConfigurerAmpli(Ampli26, 2, 6, 159, 13, FALSE);
   ConfigurerAmpli(Ampli27, 2, 7, 192, 13, TRUE);

   ConfigurerAmpli(Ampli41, 4, 1, 193, 14, FALSE);
   ConfigurerAmpli(Ampli42, 4, 2, 194, 15, FALSE);
   ConfigurerAmpli(Ampli43, 4, 3, 195, 15, FALSE);
   ConfigurerAmpli(Ampli44, 4, 4, 196, 15, TRUE);
   ConfigurerAmpli(Ampli45, 4, 5, 197, 16, FALSE);
   ConfigurerAmpli(Ampli47, 4, 7, 199, 16, TRUE);

   ConfigurerAmpli(Ampli61, 6, 1, 200, 17, FALSE);
   ConfigurerAmpli(Ampli62, 6, 2, 201, 18, FALSE);
   ConfigurerAmpli(Ampli63, 6, 3, 202, 18, FALSE);
   ConfigurerAmpli(Ampli64, 6, 4, 203, 18, TRUE);

(* PTC 2 *)
   ConfigurerAmpli(Ampli51, 5, 1, 204, 21, FALSE);
   ConfigurerAmpli(Ampli52, 5, 2, 205, 22, FALSE);
   ConfigurerAmpli(Ampli53, 5, 3, 206, 22, FALSE);
   ConfigurerAmpli(Ampli54, 5, 4, 207, 22, TRUE);  
   ConfigurerAmpli(Ampli55, 5, 5, 208, 23, FALSE);
   ConfigurerAmpli(Ampli56, 5, 6, 209, 23, FALSE);             
   ConfigurerAmpli(Ampli57, 5, 7, 210, 23, TRUE);             

   ConfigurerAmpli(Ampli31, 3, 1, 211, 24, FALSE);
   ConfigurerAmpli(Ampli32, 3, 2, 212, 25, FALSE);
   ConfigurerAmpli(Ampli33, 3, 3, 213, 25, FALSE);
   ConfigurerAmpli(Ampli34, 3, 4, 214, 25, TRUE);
   ConfigurerAmpli(Ampli35, 3, 5, 215, 26, FALSE);
   ConfigurerAmpli(Ampli37, 3, 7, 217, 26, TRUE);

   ConfigurerAmpli(Ampli71, 7, 1, 218, 27, FALSE);
   ConfigurerAmpli(Ampli72, 7, 2, 219, 28, FALSE);
   ConfigurerAmpli(Ampli74, 7, 4, 221, 28, TRUE);

(* PTC 3 *)
   ConfigurerAmpli(Ampli11, 1, 1, 222, 31, FALSE);
   ConfigurerAmpli(Ampli12, 1, 2, 223, 32, FALSE);
   ConfigurerAmpli(Ampli13, 1, 3, 256, 32, FALSE);
   ConfigurerAmpli(Ampli14, 1, 4, 257, 32, TRUE);

   ConfigurerAmpli(Ampli81, 8, 1, 261, 34, FALSE);
   ConfigurerAmpli(Ampli82, 8, 2, 262, 35, FALSE);
   ConfigurerAmpli(Ampli83, 8, 3, 263, 35, FALSE);
   ConfigurerAmpli(Ampli84, 8, 4, 264, 35, TRUE);
   ConfigurerAmpli(Ampli85, 8, 5, 265, 36, FALSE);
   ConfigurerAmpli(Ampli86, 8, 6, 266, 36, FALSE);
   ConfigurerAmpli(Ampli87, 8, 7, 267, 36, TRUE);



(*   ConfigurerAmpli(Ampli91, 9, 1, 268, 37, FALSE);
   ConfigurerAmpli(Ampli92, 9, 2, 269, 38, FALSE);
   ConfigurerAmpli(Ampli93, 9, 3, 270, 38, FALSE);
   ConfigurerAmpli(Ampli94, 9, 4, 271, 38, TRUE); *)

 
(** cartes CES **)
   ConfigurerCES(CarteCes1, 01);
   ConfigurerCES(CarteCes2, 02);
   ConfigurerCES(CarteCes3, 03);
   ConfigurerCES(CarteCes4, 04);
   ConfigurerCES(CarteCes5, 05);

(** Liaisons Inter-Secteur **)

   ConfigurerIntsecteur(Intersecteur1, 01, trL0218, trL0220);


(* Initialisations des variables ne correspondant pas a des entrees secu *)

(* Affectation a l'etat restrictif des variants commutes *)
   AffectBoolD(BoolRestrictif, com1troncon2) ;
   AffectBoolD(BoolRestrictif, com2troncon2) ;
   AffectBoolD(BoolRestrictif, com3troncon2) ;
   AffectBoolD(BoolRestrictif, com4troncon2) ;
   AffectBoolD(BoolRestrictif, com5troncon2) ;


(* Point d'arret *)
   AffectBoolD( BoolRestrictif, PtArrSigEIN10   );
   AffectBoolD( BoolRestrictif, PtArrSigEIN12B   );
   AffectBoolD( BoolRestrictif, PtArrSigEIN12A   );
   AffectBoolD( BoolRestrictif, PtArrSigEIN20   );

   AffectBoolD( BoolRestrictif, PtArrSigEIN22   );
   AffectBoolD( BoolRestrictif, PtArrSigEIN24   );
   AffectBoolD( BoolRestrictif, PtArrSigEIN26   );

   AffectBoolD( BoolRestrictif, PtArrSpeEIN20   );

   AffectBoolD( BoolRestrictif, PtArrCdvDOR11   );
   AffectBoolD( BoolRestrictif, PtArrCdvDOR12   );
   AffectBoolD( BoolRestrictif, PtArrCdvDOR13   );
   AffectBoolD( BoolRestrictif, PtArrCdvDOR21   );
   AffectBoolD( BoolRestrictif, PtArrCdvDOR22   );
   AffectBoolD( BoolRestrictif, PtArrCdvDOR23   );

   AffectBoolD( BoolRestrictif, PtArrCdvCEM11   );
   AffectBoolD( BoolRestrictif, PtArrCdvCEM12   );
   AffectBoolD( BoolRestrictif, PtArrCdvCEM13   );
   AffectBoolD( BoolRestrictif, PtArrCdvCEM21   );
   AffectBoolD( BoolRestrictif, PtArrCdvCEM22   );
   AffectBoolD( BoolRestrictif, PtArrCdvCEM23   );

   AffectBoolD( BoolRestrictif, PtArrCdvEIN10   );
   AffectBoolD( BoolRestrictif, PtArrSpeEIN12   );
   AffectBoolD( BoolRestrictif, PtArrSpeEIN22   );
   AffectBoolD( BoolRestrictif, PtArrCdvEIN26   );

(* Tiv Com *)

   AffectBoolD( BoolRestrictif, TivComSigEIN22   );
   AffectBoolD( BoolRestrictif, TivComSigEIN24   );


(* Variants anticipes *)
   AffectBoolD( BoolRestrictif, PtAntCdvZAP23   );
   AffectBoolD( BoolRestrictif, PtAntCdvZAP22   );
   AffectBoolD( BoolRestrictif, PtAntCdvZAP21   );

   AffectBoolD( BoolRestrictif, PtAntCdvCEB10   );
   AffectBoolD( BoolRestrictif, PtAntSigCEB10   );


(* Regulation *)

 CdvCEM12Fonc := FALSE;
 CdvCEM22Fonc := FALSE;
 CdvEIN12Fonc := FALSE;
 CdvEIN22Fonc := FALSE;
 CdvDOR12Fonc := FALSE;
 CdvDOR22Fonc := FALSE;

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

   ConfigEmisTeleSolTrain ( te31s19t01,
			    noBoucle1,
			    BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te11s19t02,
			    noBoucle2,
			    BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te24s19t03,
			    noBoucle3,
			    BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te14s19t04,
			    noBoucle4,
			    BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te21s19t05,
			    noBoucle5,
			    BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);


   ConfigEmisTeleSolTrain ( te17s19t06,
			    noBoucle6,
			    BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te27s19t07,
			    noBoucle7,
			    BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te34s19t08,
			    noBoucle8,
			    BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

  (* ConfigEmisTeleSolTrain ( te37s19t09,
			    noBoucle9,
			    BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee); *)



(* CONFIGURATION POUR LA REGULATION *)

   ConfigQuai(49, 64, CdvEIN12Fonc, te24s19t03, 0,  11, 10,6, 7,  13,14,15);
   ConfigQuai(49, 69, CdvEIN22Fonc, te14s19t04, 0, 8,4, 11, 10,  13,14,15);

   ConfigQuai(48, 84, CdvCEM12Fonc, te21s19t05, 0,  2, 8,3, 9,  13,14,15);
   ConfigQuai(48, 89, CdvCEM22Fonc, te11s19t02, 0,  3, 4, 5, 10,  13,14,15);

   ConfigQuai(50, 74, CdvDOR12Fonc, te31s19t01, 0,  4, 5,10, 6,  13,14,15);
   ConfigQuai(50, 79, CdvDOR22Fonc, te34s19t08, 1,  4, 5, 10, 6,  13,14,15);


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

   ProcEmisSolTrain( te31s19t01.EmissionSensUp, (2*noBoucle1),
		     LigneL02+ L0219+ TRONC*01,

 		  PtArrCdvDOR12,
 		  PtArrCdvDOR13,
 		  PtArrCdvEIN10,
 		  BoolRestrictif,
 		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
 		  BoolRestrictif,
(* Variants Anticipes *)
		  PtArrSigEIN10,
		  BoolRestrictif, (* AspectCroix *)
 		  PtArrSpeEIN12,
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



(* variants troncon 2 *)

   ProcEmisSolTrain( te11s19t02.EmissionSensUp, (2*noBoucle2),
		     LigneL02+ L0219+ TRONC*02,

		  PtArrCdvCEM22,
		  PtArrCdvCEM21,
		  PtArrCdvEIN26,
		  PtArrSigEIN26,
		  BoolRestrictif, (* AspectCroix *)
		  BoolRestrictif,
		  BoolRestrictif,		  
		  BoolRestrictif,
(* Variants Anticipes *)
		  PtArrSigEIN24,
		  BoolRestrictif, (* AspectCroix *)
		  AigEIN13_23.PosNormaleFiltree,   (* TIV Com *)
		  AigEIN13_23.PosReverseFiltree,
		  AigEIN13_23.PosNormaleFiltree,
		  com1troncon2,
		  com2troncon2,
		  com3troncon2,
		  com4troncon2,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolPermissif,
		  BaseSorVar + 30);


(* variants troncon 3 *)

   ProcEmisSolTrain( te24s19t03.EmissionSensUp, (2*noBoucle3),
		     LigneL02+ L0219+ TRONC*03,

		  PtArrSigEIN10,
		  BoolRestrictif, (* AspectCroix *)
 		  PtArrSpeEIN12,
		  PtArrSigEIN12A,
		  BoolRestrictif,  (* AspectCroix *)
		  AigEIN13_23.PosNormaleFiltree,   (* TIV Com *)
		  AigEIN13_23.PosReverseFiltree,
		  AigEIN13_23.PosNormaleFiltree,
(* Variants Anticipes *)
		  PtArrCdvCEM11,
		  PtArrCdvCEM12,
		  PtArrCdvCEM13,
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

   ProcEmisSolTrain( te14s19t04.EmissionSensUp, (2*noBoucle4),
		     LigneL02+ L0219+ TRONC*04,

		  PtArrSigEIN24,
		  BoolRestrictif, (* AspectCroix *)
		  AigEIN13_23.PosNormaleFiltree,   (* TIV Com *)
		  AigEIN13_23.PosReverseFiltree,
		  AigEIN13_23.PosNormaleFiltree,
		  PtArrSpeEIN22,
		  PtArrSigEIN22,
		  BoolRestrictif, (* AspectCroix *)
		  TivComSigEIN22,
		  PtArrSpeEIN20,
		  PtArrCdvDOR23,
(* Variants Anticipes *)
		  PtArrCdvDOR22,
		  PtArrCdvDOR21,
		  PtArrSigEIN12B,
		  BoolRestrictif, (* AspectCroix *)
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

   ProcEmisSolTrain( te21s19t05.EmissionSensUp, (2*noBoucle5),
		     LigneL02+ L0219+ TRONC*05,

		  PtArrCdvCEM11,
		  PtArrCdvCEM12,
		  PtArrCdvCEM13,
		  PtAntCdvCEB10,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
(* Variants Anticipes *)
		  PtAntSigCEB10,
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
		  BaseSorVar + 120);


(* variants troncon 6 *)

   ProcEmisSolTrain( te17s19t06.EmissionSensUp, (2*noBoucle6),
		     LigneL02+ L0219+ TRONC*06,

		  PtArrSigEIN12B,
		  BoolRestrictif, (* AspectCroix *)
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
(* Variants Anticipes *)
		  PtArrSpeEIN20,
		  PtArrCdvDOR23,
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


(* variants troncon 7 *)

   ProcEmisSolTrain( te27s19t07.EmissionSensUp, (2*noBoucle7),
		     LigneL02+ L0219+ TRONC*07,

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
		  BaseSorVar + 180);


(* variants troncon 8 *)

   ProcEmisSolTrain( te34s19t08.EmissionSensUp, (2*noBoucle8),
		     LigneL02+ L0219+ TRONC*08,

		  PtArrCdvDOR22,
		  PtArrCdvDOR21,
		  PtAntCdvZAP23,
		  PtArrSigEIN20,
		  BoolRestrictif, (* AspectCroix *)
		  AigEIN11_21.PosReverseFiltree,
		  AigEIN11_21.PosNormaleFiltree,
		  BoolRestrictif,
(* Variants Anticipes *)
		  PtAntCdvZAP22,
		  BoolRestrictif,
		  BoolRestrictif,
		  PtArrSpeEIN12,
		  PtArrSigEIN12A,
		  BoolRestrictif, (* AspectCroix *)
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolPermissif,
		  BaseSorVar + 210);


(* variants troncon 9 *)

 (*  ProcEmisSolTrain( te37s19t09.EmissionSensUp, (2*noBoucle9),
		     LigneL02+ L0219+ TRONC*09,

		  PtArrSigEIN20,
		  BoolRestrictif, (* AspectCroix *)
		  AigEIN11_21.PosReverseFiltree,
		  AigEIN11_21.PosNormaleFiltree,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
(* Variants Anticipes *)
		  PtArrSpeEIN12,
		  PtArrSigEIN12A,
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
		  BaseSorVar + 240); *)



(* emission vers le secteur 18 aval *)
   ProcEmisInterSecteur (teL0218, noBoucleCeb, LigneL02+ L0219+ TRONC*02,
			noBoucleCeb,
		  PtArrCdvCEM21,
		  PtArrCdvCEM22,
		  PtArrCdvCEM23,
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
		  BaseSorVar + 270);

(* emission vers le secteur 20 amont *)
   ProcEmisInterSecteur (teL0220, noBoucleVes, LigneL02+ L0219+ TRONC*01,
			noBoucleVes,
		  PtArrCdvDOR11,
		  PtArrCdvDOR12,
		  PtArrCdvDOR13,
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
		  BaseSorVar + 300);


(* reception du secteur 18 aval *)
   ProcReceptInterSecteur(trL0218, noBoucleCeb, LigneL02+ L0218+ TRONC*01,

		  PtAntCdvCEB10,
		  PtAntSigCEB10,
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

(* reception du secteur 20 amont *)
   ProcReceptInterSecteur(trL0220, noBoucleVes, LigneL02+ L0220+ TRONC*02,

		  PtAntCdvZAP21,
		  PtAntCdvZAP22,
		  PtAntCdvZAP23,
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

 (** Emission invariants vers secteur aval L0218 **)
   EmettreSegm(LigneL02+ L0219+ TRONC*02+ SEGM*00, noBoucleCeb, SensUp);
   EmettreSegm(LigneL02+ L0219+ TRONC*02+ SEGM*01, noBoucleCeb, SensUp);

(** Emission invariants vers secteur amont L0220 **)
   EmettreSegm(LigneL02+ L0219+ TRONC*01+ SEGM*00, noBoucleVes, SensUp);
   
   
 (** Boucle 1 **)
   EmettreSegm(LigneL02+ L0219+ TRONC*01+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL02+ L0219+ TRONC*03+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL02+ L0219+ TRONC*03+ SEGM*01, noBoucle1, SensUp);
   EmettreSegm(LigneL02+ L0219+ TRONC*05+ SEGM*00, noBoucle1, SensUp);

 (** Boucle 2 **)
   EmettreSegm(LigneL02+ L0219+ TRONC*02+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL02+ L0219+ TRONC*02+ SEGM*01, noBoucle2, SensUp);
   EmettreSegm(LigneL02+ L0219+ TRONC*04+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL02+ L0219+ TRONC*04+ SEGM*01, noBoucle2, SensUp);
   EmettreSegm(LigneL02+ L0219+ TRONC*06+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL02+ L0219+ TRONC*08+ SEGM*00, noBoucle2, SensUp);

 (** Boucle 3 **)
   (* EmettreSegm(LigneL02+ L0219+ TRONC*03+ SEGM*00, noBoucle3, SensUp); *)
   (* EmettreSegm(LigneL02+ L0219+ TRONC*03+ SEGM*01, noBoucle3, SensUp); *) 
   EmettreSegm(LigneL02+ L0219+ TRONC*05+ SEGM*00, noBoucle3, SensUp);  
   EmettreSegm(LigneL02+ L0219+ TRONC*05+ SEGM*01, noBoucle3, SensUp);
   EmettreSegm(LigneL02+ L0219+ TRONC*07+ SEGM*00, noBoucle3, SensUp);  
   EmettreSegm(LigneL02+ L0219+ TRONC*06+ SEGM*00, noBoucle3, SensUp);

 (** Boucle 4 **)
   EmettreSegm(LigneL02+ L0219+ TRONC*04+ SEGM*01, noBoucle4, SensUp); 
   (* EmettreSegm(LigneL02+ L0219+ TRONC*01+ SEGM*00, noBoucle4, SensUp); *)
   EmettreSegm(LigneL02+ L0219+ TRONC*06+ SEGM*00, noBoucle4, SensUp);
   EmettreSegm(LigneL02+ L0219+ TRONC*08+ SEGM*00, noBoucle4, SensUp);
   EmettreSegm(LigneL02+ L0219+ TRONC*08+ SEGM*01, noBoucle4, SensUp);

 (** Boucle 5 **)
   EmettreSegm(LigneL02+ L0219+ TRONC*05+ SEGM*00, noBoucle5, SensUp);
   EmettreSegm(LigneL02+ L0219+ TRONC*05+ SEGM*01, noBoucle5, SensUp);
   EmettreSegm(LigneL02+ L0218+ TRONC*01+ SEGM*00, noBoucle5, SensUp);
   EmettreSegm(LigneL02+ L0218+ TRONC*02+ SEGM*00, noBoucle5, SensUp);

 (** Boucle 6 **)
   EmettreSegm(LigneL02+ L0219+ TRONC*04+ SEGM*01, noBoucle6, SensUp);
   EmettreSegm(LigneL02+ L0219+ TRONC*03+ SEGM*01, noBoucle6, SensUp);

 (** Boucle 7 **)
   EmettreSegm(LigneL02+ L0219+ TRONC*04+ SEGM*00, noBoucle7, SensUp);

 (** Boucle 8 **)
   EmettreSegm(LigneL02+ L0220+ TRONC*02+ SEGM*00, noBoucle8, SensUp);
   EmettreSegm(LigneL02+ L0219+ TRONC*04+ SEGM*00, noBoucle8, SensUp);
   EmettreSegm(LigneL02+ L0219+ TRONC*04+ SEGM*01, noBoucle8, SensUp);
   EmettreSegm(LigneL02+ L0219+ TRONC*03+ SEGM*00, noBoucle8, SensUp);
   EmettreSegm(LigneL02+ L0219+ TRONC*03+ SEGM*01, noBoucle8, SensUp);

 (** Boucle 9 **)
 (*  EmettreSegm(LigneL02+ L0219+ TRONC*04+ SEGM*00, noBoucle9, SensUp);
   EmettreSegm(LigneL02+ L0219+ TRONC*04+ SEGM*01, noBoucle9, SensUp);
   EmettreSegm(LigneL02+ L0219+ TRONC*03+ SEGM*00, noBoucle9, SensUp);
   EmettreSegm(LigneL02+ L0219+ TRONC*03+ SEGM*01, noBoucle9, SensUp); *)


(* CONFIGURATION DES TRONCONS TSR *********************************)

   ConfigurerTroncon(Tronc0, LigneL02 + L0219 + TRONC*01, 2,2,2,2);  (* troncon 19-1 *)
   ConfigurerTroncon(Tronc1, LigneL02 + L0219 + TRONC*02, 2,2,2,2);  (* troncon 19-2 *)
   ConfigurerTroncon(Tronc2, LigneL02 + L0219 + TRONC*03, 2,2,2,2);  (* troncon 19-3 *)
   ConfigurerTroncon(Tronc3, LigneL02 + L0219 + TRONC*04, 2,2,2,2);  (* troncon 19-4 *)
   ConfigurerTroncon(Tronc4, LigneL02 + L0219 + TRONC*05, 2,2,2,2);  (* troncon 19-5 *)
   ConfigurerTroncon(Tronc5, LigneL02 + L0219 + TRONC*06, 2,2,2,2);  (* troncon 19-6 *)
   ConfigurerTroncon(Tronc6, LigneL02 + L0219 + TRONC*07, 2,2,2,2);  (* troncon 19-7 *)
   ConfigurerTroncon(Tronc7, LigneL02 + L0219 + TRONC*08, 2,2,2,2);  (* troncon 19-8 *)
 (*  ConfigurerTroncon(Tronc8, LigneL02 + L0219 + TRONC*09, 1,1,1,1); *) (* troncon 19-9 *)


(* EMISSION DES TSR SUR VOIE 1 ***********************************************)

 (** Emission des TSR vers le secteur aval L0218 **)
   EmettreTronc(LigneL02+ L0219+ TRONC*02, noBoucleCeb, SensUp);

 (** Emission des TSR vers le secteur amont L0220 **)
   EmettreTronc(LigneL02+ L0219+ TRONC*01, noBoucleVes, SensUp);

 (** Emission des TSR sur les troncons du secteur courant **)
   EmettreTronc(LigneL02+ L0219+ TRONC*01, noBoucle1, SensUp); (* troncon 1-1 *)
   EmettreTronc(LigneL02+ L0219+ TRONC*03, noBoucle1, SensUp);
   EmettreTronc(LigneL02+ L0219+ TRONC*05, noBoucle1, SensUp);

   EmettreTronc(LigneL02+ L0219+ TRONC*02, noBoucle2, SensUp); (* troncon 1-2 *)
   EmettreTronc(LigneL02+ L0219+ TRONC*04, noBoucle2, SensUp);
   EmettreTronc(LigneL02+ L0219+ TRONC*06, noBoucle2, SensUp);
   EmettreTronc(LigneL02+ L0219+ TRONC*08, noBoucle2, SensUp);

   EmettreTronc(LigneL02+ L0219+ TRONC*03, noBoucle3, SensUp); (* troncon 1-3 *)
   EmettreTronc(LigneL02+ L0219+ TRONC*05, noBoucle3, SensUp);
   EmettreTronc(LigneL02+ L0219+ TRONC*06, noBoucle3, SensUp);
   EmettreTronc(LigneL02+ L0219+ TRONC*07, noBoucle3, SensUp);

   EmettreTronc(LigneL02+ L0219+ TRONC*04, noBoucle4, SensUp); (* troncon 1-4 *)
   EmettreTronc(LigneL02+ L0219+ TRONC*06, noBoucle4, SensUp);
   EmettreTronc(LigneL02+ L0219+ TRONC*08, noBoucle4, SensUp);
 (*  EmettreTronc(LigneL02+ L0219+ TRONC*09, noBoucle4, SensUp); *)

   EmettreTronc(LigneL02+ L0219+ TRONC*05, noBoucle5, SensUp); (* troncon 1-5 *)
   EmettreTronc(LigneL02+ L0218+ TRONC*01, noBoucle5, SensUp);
   EmettreTronc(LigneL02+ L0218+ TRONC*02, noBoucle5, SensUp);

   EmettreTronc(LigneL02+ L0219+ TRONC*06, noBoucle6, SensUp); (* troncon 1-6 *)
   EmettreTronc(LigneL02+ L0219+ TRONC*03, noBoucle6, SensUp);
   EmettreTronc(LigneL02+ L0219+ TRONC*04, noBoucle6, SensUp);

   EmettreTronc(LigneL02+ L0219+ TRONC*07, noBoucle7, SensUp); (* troncon 1-7 *)
   EmettreTronc(LigneL02+ L0219+ TRONC*04, noBoucle7, SensUp);

   EmettreTronc(LigneL02+ L0219+ TRONC*08, noBoucle8, SensUp); (* troncon 1-8 *)
   EmettreTronc(LigneL02+ L0220+ TRONC*02, noBoucle8, SensUp);
   EmettreTronc(LigneL02+ L0219+ TRONC*03, noBoucle8, SensUp);
   EmettreTronc(LigneL02+ L0219+ TRONC*04, noBoucle8, SensUp);


(*   EmettreTronc(LigneL02+ L0219+ TRONC*09, noBoucle9, SensUp); (* troncon 1-9 *)
   EmettreTronc(LigneL02+ L0219+ TRONC*03, noBoucle9, SensUp);
   EmettreTronc(LigneL02+ L0219+ TRONC*04, noBoucle9, SensUp); *)



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

   StockAdres( ADR(CdvCEM11   ));
   StockAdres( ADR(CdvCEM12   ));
   StockAdres( ADR(CdvCEM13   ));
   StockAdres( ADR(CdvCEM21   ));
   StockAdres( ADR(CdvCEM22   ));
   StockAdres( ADR(CdvCEM23   ));

   StockAdres( ADR(Sp1EIN   ));
   StockAdres( ADR(Sp2EIN   ));

   StockAdres( ADR(CdvEIN10 ));
   StockAdres( ADR(CdvEIN11 ));
   StockAdres( ADR(CdvEIN12 ));
   StockAdres( ADR(CdvEIN13 ));
   StockAdres( ADR(CdvEIN14   ));
   StockAdres( ADR(CdvEIN20   ));
   StockAdres( ADR(CdvEIN21   ));
   StockAdres( ADR(CdvEIN22   ));

   StockAdres( ADR(CdvEIN23   ));
   StockAdres( ADR(CdvEIN24   ));
   StockAdres( ADR(CdvEIN26   ));
   StockAdres( ADR(SigEIN10kv   ));
   StockAdres( ADR(SigEIN12Bkj   ));
   StockAdres( ADR(SigEIN12Akv   ));
   StockAdres( ADR(SigEIN12Akj   ));
   StockAdres( ADR(SigEIN20kj   ));
   StockAdres( ADR(SigEIN22kv   ));
   StockAdres( ADR(SigEIN22kj   ));
   StockAdres( ADR(SigEIN24kv   ));
   StockAdres( ADR(SigEIN24kj   ));
   StockAdres( ADR(SigEIN26kv   ));

   StockAdres( ADR(CdvDOR11   ));
   StockAdres( ADR(CdvDOR12   ));
   StockAdres( ADR(CdvDOR13   ));
   StockAdres( ADR(CdvDOR21   ));
   StockAdres( ADR(CdvDOR22   ));
   StockAdres( ADR(CdvDOR23   ));

   StockAdres( ADR( AigEIN11_21 )); 
   StockAdres( ADR( AigEIN13_23 )); 

   StockAdres( ADR(com1troncon2));
   StockAdres( ADR(com2troncon2));
   StockAdres( ADR(com3troncon2));
   StockAdres( ADR(com4troncon2));
   StockAdres( ADR(com5troncon2));


(* Points d'arret *)
   StockAdres( ADR( PtArrSigEIN10   ));
   StockAdres( ADR( PtArrSigEIN12B   ));
   StockAdres( ADR( PtArrSigEIN12A   ));
   StockAdres( ADR( PtArrSigEIN20   ));

   StockAdres( ADR( PtArrSigEIN22   ));
   StockAdres( ADR( PtArrSigEIN24   ));
   StockAdres( ADR( PtArrSigEIN26   ));

   StockAdres( ADR( PtArrSpeEIN20   ));

   StockAdres( ADR( PtArrCdvDOR11   ));
   StockAdres( ADR( PtArrCdvDOR12   ));
   StockAdres( ADR( PtArrCdvDOR13   ));
   StockAdres( ADR( PtArrCdvDOR21   ));
   StockAdres( ADR( PtArrCdvDOR22   ));
   StockAdres( ADR( PtArrCdvDOR23   ));

   StockAdres( ADR( PtArrCdvCEM11   ));
   StockAdres( ADR( PtArrCdvCEM12   ));
   StockAdres( ADR( PtArrCdvCEM13   ));
   StockAdres( ADR( PtArrCdvCEM21   ));
   StockAdres( ADR( PtArrCdvCEM22   ));
   StockAdres( ADR( PtArrCdvCEM23   ));

   StockAdres( ADR( PtArrCdvEIN10   ));
   StockAdres( ADR( PtArrSpeEIN12   ));
   StockAdres( ADR( PtArrSpeEIN22   ));
   StockAdres( ADR( PtArrCdvEIN26   ));

   StockAdres( ADR( TivComSigEIN22  ));
   StockAdres( ADR( TivComSigEIN24  ));

   StockAdres( ADR( PtAntCdvZAP23   ));
   StockAdres( ADR( PtAntCdvZAP22   ));
   StockAdres( ADR( PtAntCdvZAP21   ));

   StockAdres( ADR( PtAntCdvCEB10   ));
   StockAdres( ADR( PtAntSigCEB10   ));


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
VAR BoolTr1, BoolTr2 : BoolLD;

BEGIN (* ExeSpecific *)

(* Affectation des "constantes" utilisees dans la construction des messages emis        *)
(* et recus sur les boucles de transmission continue et sur les liens intersecteur.     *)
(* Cette reaffectation est necessaire a chaque cycle pour la mise en securite.          *)
   AffectBoolC(Vrai, BoolPermissif)  ;
   AffectBoolC(Faux, BoolRestrictif) ;

 (* regulation *)

 CdvCEM12Fonc := CdvCEM12.F = Vrai.F;
 CdvCEM22Fonc := CdvCEM22.F = Vrai.F;
 CdvEIN12Fonc := CdvEIN12.F = Vrai.F;
 CdvEIN22Fonc := CdvEIN22.F = Vrai.F;
 CdvDOR12Fonc := CdvDOR12.F = Vrai.F;
 CdvDOR22Fonc := CdvDOR22.F = Vrai.F;




(**** FILTRAGE DES AIGUILLES **************************************************)

  FiltrerAiguille(AigEIN11_21, BaseExeAig ) ;
  FiltrerAiguille(AigEIN13_23, BaseExeAig + 2) ;

(*coucou*)

(**** DETERMINATION DES POINTS D'ARRET ****************************************)

   
   AffectBoolD( CdvDOR11,    PtArrCdvDOR11  );
   AffectBoolD( CdvDOR12,    PtArrCdvDOR12  );
   AffectBoolD( CdvDOR13,    PtArrCdvDOR13  );

   AffectBoolD( CdvEIN10,    PtArrCdvEIN10  );

   AffectBoolD( SigEIN10kv,  PtArrSigEIN10  );

   AffectBoolD( SigEIN20kj,  PtArrSigEIN20  );

   EtDD( CdvEIN12,    CdvEIN13,    PtArrSpeEIN12 ); 
   
   NonD( Sp2EIN,                   BoolTr1 );
   OuDD( SigEIN12Akv, SigEIN12Akj, BoolTr2 );
   EtDD( BoolTr1    , BoolTr2    , PtArrSigEIN12A );


   AffectBoolD( CdvCEM11,    PtArrCdvCEM11  );
   AffectBoolD( CdvCEM12,    PtArrCdvCEM12  );
   AffectBoolD( CdvCEM13,    PtArrCdvCEM13  );

   AffectBoolD( CdvCEM23,    PtArrCdvCEM23  );
   AffectBoolD( CdvCEM22,    PtArrCdvCEM22  );
   AffectBoolD( CdvCEM21,    PtArrCdvCEM21  );

   AffectBoolD( CdvEIN26,    PtArrCdvEIN26  );

   AffectBoolD( SigEIN26kv,  PtArrSigEIN26  );
   AffectBoolD( SigEIN12Bkj, PtArrSigEIN12B );

   
   OuDD( SigEIN24kv,  SigEIN24kj,  PtArrSigEIN24 );

   OuDD( SigEIN22kv,  SigEIN22kj,  PtArrSigEIN22 );

   OuDD( CdvEIN21, AigEIN11_21.PosReverseFiltree, BoolTr1);        
   EtDD( BoolTr1,  CdvEIN22,               PtArrSpeEIN22 );

   NonD( Sp1EIN,   PtArrSpeEIN20 );

   AffectBoolD( CdvDOR23,    PtArrCdvDOR23  );
   AffectBoolD( CdvDOR22,    PtArrCdvDOR22  );
   AffectBoolD( CdvDOR21,    PtArrCdvDOR21  );


(* Tiv Com *)

   AffectBoolD( SigEIN22kv,  TivComSigEIN22 );


(*** lecture des entrees de regulation ***)
   LireEntreesRegul;


(* commutation des variants troncon 2 *)
(* en fonction de la position de l'aiguille 13_23 *)

IF Tvrai (AigEIN13_23.PosNormaleFiltree) THEN
	AffectBoolD (PtArrSpeEIN22 , com1troncon2);
	AffectBoolD (PtArrSigEIN22 , com2troncon2);
      AffectBoolD (BoolRestrictif, com3troncon2);
      AffectBoolD (SigEIN22kv    , com4troncon2);  (* Tiv Com *)
	FinBranche(1);  
   ELSE
	IF Tvrai (AigEIN13_23.PosReverseFiltree) THEN
            AffectBoolD (PtArrSigEIN12B, com1troncon2);
		AffectBoolD (BoolRestrictif, com2troncon2);
            AffectBoolD (BoolRestrictif, com3troncon2);
		AffectBoolD (BoolRestrictif, com4troncon2);
		FinBranche(2);
	ELSE 
	  AffectBoolD (BoolRestrictif, com1troncon2);
	  AffectBoolD (BoolRestrictif, com2troncon2);
        AffectBoolD (BoolRestrictif, com3troncon2);
        AffectBoolD (BoolRestrictif, com4troncon2);
	  FinBranche(3);
	END;
END;
FinArbre(BaseExeSpecific);

END ExeSpecific;
END Specific.

















