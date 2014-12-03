IMPLEMENTATION MODULE Specific;

(*$S- *)
(*$T- *)

(******************************************************************************
*   SANTIAGO - LIGNE 1 - Secteur 22
*  =============================
*  Version : SCCS 1.0
*  Date    : 17/09/1997
*  Auteur  : Marc Plywacz
*  Premiere Version
******************************************************************************)

(*---------------------------------------------------------------------------*)
(* Modifications :                                                           *)
(* -------------                                                             *)
(*                                                                           *)
(* Version 1.1.0 ==== 1ere version livree a la validation ================== *)
(* Date : 28/10/1997, Auteur: P. Hog    , Origine : Equipe dev.              *)
(*   Correction des anticipations et des damtc.                              *)
(*                                                                           *)  
(* Version 1.1.1 =====================					     *)
(* Date : 05/12/1997, Auteur: F. Chanier, Origine : Fiche Gauvin 74          *)
(*   ajout de l'emission de segment et LTV 22.5.0 vers le secteur 23.        *)
(*                                                                           *)  
(* Version 1.1.2 =====================					     *)
(* Date : 23/01/1998, Auteur: F. Chanier, Origine : eq. dev.                 *)
(*   detection des defaillances d'ampli.                                     *)
(*                                                                           *)
(* Version 1.1.3 =====================                                       *)
(* Date : 12/03/1998, Auteur: F. Chanier, Origine : Eq. dev                  *)
(*   mise en place des marches-type                                          *)  
(*---------------------------------------------------------------------------*)

(*****************************************************************************)
(***              AJOUT DE LA NUMEROTATION DES VERSIONS SCCS              ****)
(*---------------------------------------------------------------------------*)
(* Version 1.1.4  =====================                                      *)
(* Version 1.5 DU SERVEUR SCCS =====================                         *)
(* Date :         10/09/1998                                                 *)
(* Auteur:        H. Le Roy                                                  *)
(* Modification : Fiche d'anomalie ba040998                                  *)
(*                Suite a un changement de vitesses maximales, mise a jour   *)
(*                des marches types                                          *)
(*---------------------------------------------------------------------------*)
(* Version 1.1.5  =====================                                      *)
(* Version 1.6 DU SERVEUR SCCS =====================                         *)
(* Date :         19/04/1999                                                 *)
(* Auteur:        H. Le Roy                                                  *)
(* Modification : Adaptation et modification de la configuration des amplis  *)
(*                 pour detecter les pannes de fusibles.Suppression de       *)
(*                 parties de code inutiles concernant les DAMTC.            *)
(*---------------------------------------------------------------------------*)
(* Version 1.1.6  =====================                                      *)
(* Version 1.7 DU SERVEUR SCCS =====================                         *)
(* Date :         06/06/2000                                                 *)
(* Auteur:        H. Le Roy                                                  *)
(* Modification : Am165 : Modification des marches types                     *)
(*---------------------------------------------------------------------------*)
(* Version 1.1.7  =====================                                      *)
(* Version 1.8 DU SERVEUR SCCS =====================                         *)
(* Date :         07/08/2006                                                 *)
(* Auteur:        Rudy Nsiona                                                *)
(* Modification : Nouveau Train NS2004                                       *)
(* Procédure CONFIGURATION DES TRONCONS TSR                                  *)
(*                ancienne valeur 1 , nouvelle 2                             *)
(******************************  IMPORTATIONS  *******************************)
(* Version 1.1.8  =====================                                      *)
(* Version 1.9 DU SERVEUR SCCS =====================                         *)
(* Date :         26/02/2008                                                 *)
(* Auteur:        Patrick Amsellem                                           *)
(* Modification : Segment 22.5.0 inhibition du tivcom quand l'aiguille       *)
(*                est en position normale                                    *)
(*                AffectBoolD( AigREJ24kv.PosNormaleFiltree, TivComREJ24)    *)
(*                remplaçer par AffectBoolD( AigREJ13.PosNormaleFiltree,     *)
(*                TivComREJ24)                                               *)
(*---------------------------------------------------------------------------*)


(*---------------------------------------------------------------------------*)
(* Version 1.2.0  =====================                                      *)
(* Version 1.11  DU SERVEUR SCCS =====================                       *)
(* Date :         03/04/2009                                                 *)
(* Auteur:        Marc Plywacz                                               *)
(* Modifications : :[ Prolongement 1                                         *)
(* ajout trans segment 22.1.1 : nouveau segment                              *)
(*                                                                           *)
(*---------------------------------------------------------------------------*)
(* Version 1.2.1  =====================                                      *)
(* Version 1.12  DU SERVEUR SCCS =====================                       *)
(* Date :         05/06/2009                                                 *)
(* Auteur:        Marc Plywacz                                               *)
(* Modifications : :[ Prolongement 1                                         *)
(* ajout trans segment 22.1.1 : nouveau segment vers sect 21                 *)
(*                                                                           *)
(*---------------------------------------------------------------------------*)
(* Version 1.2.2  =====================                                      *)
(* Version 1.13  DU SERVEUR SCCS =====================                       *)
(* Date :         07/08/2009                                                 *)
(* Auteur:        Marc Plywacz                                               *)
(* Modifications : :[ Prolongement 1   (phase 3 Pajari)                      *)
(* ajout trans segment 22.6.1 : nouveau segment                              *)
(* modifs ConfigurerAmpli  suivant nouvelle repartitions trans dans les PTCs *)
(*                                                                           *)
(*---------------------------------------------------------------------------*)
(* Version 1.2.3  =====================                                      *)
(* Version 1.14  DU SERVEUR SCCS =====================                       *)
(* Date :         16/11/2009                                                 *)
(* Auteur:        Marc Plywacz                                               *)
(* Modifications : :[ Prolongement 1   (phase 3 Pajari)                      *)
(* modifs ConfigurerAmpli                                                    *)
(*---------------------------------------------------------------------------*)
(* Version 1.2.4  =====================                                      *)
(* Version 1.15  DU SERVEUR SCCS =====================                       *)
(* Date :         22/01/2010                                                 *)
(* Auteur:        Marc Plywacz                                               *)
(* Modifications : :[ Prolongement 1   (phase 4 Pajari)                      *)
(* ajout nouveaux points d'arrets v1, v2 et voie Z                           *)
(*---------------------------------------------------------------------------*)
(* Version 1.2.5  =====================                                      *)
(* Version 1.16  DU SERVEUR SCCS =====================                       *)
(* Date :         05/02/2010                                                 *)
(* Auteur:        Ph. Hog                                                    *)
(* Modifications : :[ Prolongement 1   (phase 4 Pajari)                      *)
(*   Inversion des entrées des cdv 12A et 12B de Pajaritos :                 *)
(*        cdv PAJ12A, ancien CES06 ES0, nouveau CES02 ES1                    *)
(*        cdv PAJ12B, ancien CES02 ES1, nouveau CES06 ES0                    *)
(*---------------------------------------------------------------------------*)
(* Version 1.2.6  =====================                                      *)
(* Version 1.17  DU SERVEUR SCCS =====================                       *)
(* Date :         12/03/2010                                                 *)
(* Auteur:        Ph. Hog                                                    *)
(* Modifications : :[ Prolongement 1   (phase 4 Pajari)                      *)
(*   ALPHA 00172773, Initialisation de la variable PtArrSigPAJ22             *)
(*   ALPHA 00172775, Suite au changement de PTC, les variables te11s22t01 et *)
(*                   te21s22t04 sont renommées te31s22t01 et te36s22t04.     *)
(*---------------------------------------------------------------------------*)
(* Version 1.2.7  =====================                                      *)
(* Version NA    DU SERVEUR SCCS =====================                       *)
(* Date :         28/09/2010                                                 *)
(* Auteur:        Marc Plywacz                                               *)
(* Modifications : :[ Prolongement 1   (phase 4 Pajari)                      *)
(* Ajustement des marches type voies 1-2 / PJ <-> LR /  NP <-  PJ            *)
(*---------------------------------------------------------------------------*)

(******************************  IMPORTATIONS  *******************************)


FROM SYSTEM     IMPORT ADR;

FROM Opel       IMPORT StockAdres, AffectBoolD, AffectBoolC, BoolC, BoolD, EtDD, CodeD, NonD,
		       Tvrai, FinBranche, FinArbre, AffectC, OuDD;

FROM ConstCode  IMPORT BoolPermissif, BoolRestrictif, Vrai, Faux;

FROM BibAig     IMPORT TyAig, FiltrerAiguille,
                       EntreeAiguille;

FROM NouvRegul IMPORT  TyQuai,
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
                       AssocRecIntSorTel,
                       ProcReceptInterSecteur;

FROM BibEnregDam  IMPORT
(* Types *)

     TyBoucle, TyAmpli,

 Ampli11, Ampli12, Ampli13, Ampli14, Ampli15,Ampli16,Ampli17,Ampli18,Ampli19,Ampli1A,Ampli1B,Ampli1C,
          Ampli21, Ampli22, Ampli23, Ampli24, Ampli25,
          Ampli31, Ampli32, Ampli33, Ampli34, Ampli35, Ampli36,
          Ampli41, Ampli42, Ampli43, Ampli44,
          Ampli51, Ampli52, Ampli53, Ampli54, Ampli55, Ampli56,
 Ampli61, Ampli62, Ampli63, Ampli64, Ampli65,Ampli66,Ampli67,Ampli68,Ampli69,Ampli6A,Ampli6B,





(* variables *)
                       Boucle1, Boucle2, Boucle3, Boucle4, Boucle5, Boucle6, BoucleFictive,
		       CarteCes1,  CarteCes2,  CarteCes3, CarteCes4, CarteCes5, CarteCes6,


                       Intersecteur1, 
(* procedures *)
                       ConfigurerBoucle,
			ConfigurerAmpli,
                       ConfigurerIntsecteur,
                       DeclarerVersionSpecific,
                       ConfigurerCES;


FROM BibTsr      IMPORT
(* Types *)
                       TyTsrTroncon,
(* variables *)
                       Tronc0,  Tronc1,  Tronc2,  Tronc3,  Tronc4,  Tronc5,
                       Tronc6,  Tronc7,  Tronc8,  Tronc9,  Tronc10, Tronc11,
                       Tronc12, Tronc13, Tronc14, Tronc15,
(* procedures *)
                       ConfigurerTroncon;


FROM ESbin     	 IMPORT 
		       TyEntreeFonctio,

		       ProcEntreeIntrins,
		       ProcEntreeFonctio;
(*  *)
(*****************************  CONSTANTES  ***********************************)

CONST

(** No ligne, No secteur, ....**)

    LigneL01 = 16384*00; (* numero de ligne decale de 2**14 *)

    L0123  = 1024*23;    (* numero Secteur aval voie impaire decale de 2**10 *)

    L0122  = 1024*22;    (* numero Secteur local decale de 2**10 *)

    L0121  = 1024*21;    (* numero Secteur amont voie impaire decale de 2**10 *)


    TRONC  = 64;         (* decalage de 2**6 pour numero de troncon *)

    SEGM   = 16;         (* decalage de 2**4 pour numero de segment *)


(** Constantes de configuration des emissions en absence d'entrees de commutation **)
    VariantsSurEntree = FALSE;
    VariantsContinus  = TRUE;
    CommutDifferee    = FALSE;
    CommutAnticipee   = TRUE;

(** Indication  de positionnement d'aiguille **)
    PosNormale = TRUE;
    PosDeviee = FALSE;

(** indication de sens **)
    SensUp = TRUE;

(** No de Voie d'emissions SOL-Train, d'emission/reception inter-secteur **)
    noBouclepdg = 00; 
    noBouclepab = 01; 
    noBouclefi = 02;
    noBoucle1 = 03;
    noBoucle2 = 04;
    noBoucle3 = 05;
    noBoucle4 = 06;
    noBoucle5 = 07;
    noBoucle6 = 08;

(* numero de version *)
    noVersion = 01;

(** Base pour les tables de compensation **)
    BaseEntVar	= 500 	;
    BaseSorVar	= 600 	;
    BaseExeAig	= 1280	;
    BaseExeChainage = 1360 ;
    BaseExeSpecific = 1950 ;

(*  *)
(************************ DECLARATION DES TYPES *****************************)
TYPE
 TyAigNonLue = RECORD  (* Structure de donnees associee a une aiguille dont *
                        * l'etat n'est pas lu sur des entrees de carte CES  *
                        * (aiguille fictive ou anticipee)                   *)
                  PosNormale  : BoolD ;   (* position normale calculee *)
                  PosDeviee   : BoolD ;   (* position deviee calculee  *)
                END;


(***************** DECLARATION DES VARIABLES GENERALES **********************)
 VAR


(* DECLARATION DES SINGULARITES DU SECTEUR 22 : dans les deux sens confondus *)


(* Declaration des variables correspondant a des entrees securitaires  *)
(*   - CDV et signaux                                                  *)
    CdvPAJ10,      (* entree  1, soit entree 0 de CES 02  *)
    CdvPAJ12A,     (* entree  2, soit entree 1 de CES 02  *)
    CdvPAJ13A,     (* entree  3, soit entree 2 de CES 02  *)
    CdvREJ10,      (* entree  4, soit entree 3 de CES 02  *)
    CdvREJ11,      (* entree  5, soit entree 4 de CES 02  *)
    CdvREJ12,      (* entree  6, soit entree 5 de CES 02  *)
    CdvREJ13,      (* entree  7, soit entree 6 de CES 02  *)
    CdvREJ14,      (* entree  8, soit entree 7 de CES 02  *)
    CdvECU11,      (* entree  9, soit entree 0 de CES 03  *)
    CdvECU12,      (* entree 10, soit entree 1 de CES 03  *)
    CdvECU13,      (* entree 11, soit entree 2 de CES 03  *)
    CdvECU14,      (* entree 12, soit entree 3 de CES 03  *)

    CdvECU23,      (* entree 13, soit entree 4 de CES 03  *)
    CdvECU22,      (* entree 14, soit entree 5 de CES 03  *)
    CdvECU21,      (* entree 15, soit entree 6 de CES 03  *)
    CdvREJ24,      (* entree 16, soit entree 7 de CES 03  *)
    CdvREJ23,      (* entree 17, soit entree 0 de CES 04  *)
    CdvREJ22,      (* entree 18, soit entree 1 de CES 04  *)
    CdvREJ21,      (* entree 19, soit entree 2 de CES 04  *)
    CdvREJ20,      (* entree 20, soit entree 3 de CES 04  *)
    CdvPAJ23,      (* entree 21, soit entree 4 de CES 04  *)
    CdvPAJ22A,     (* entree 22, soit entree 5 de CES 04  *)
    CdvPAJ21,      (* entree 23, soit entree 6 de CES 04  *)
    CdvPAJ18,      (* entree 24, soit entree 7 de CES 04  *)

    SigREJ10,      (* entree 25, soit entree 0 de CES 05  *)
    SigREJ12,      (* entree 26, soit entree 1 de CES 05  *)
    SigREJ24kv,    (* entree 27, soit entree 2 de CES 05  *)
    SigREJ24kj,    (* entree 28, soit entree 3 de CES 05  *)

    CdvPAJ11A,     (* entree 31, soit entree 6 de CES 05  *)
    CdvPAJ11B,     (* entree 32, soit entree 7 de CES 05  *)
    CdvPAJ12B,     (* entree 33, soit entree 0 de CES 06  *)
    CdvPAJ13B,     (* entree 34, soit entree 1 de CES 06  *)
    CdvPAJ22B,     (* entree 35, soit entree 2 de CES 06  *)
    CdvPAJ20 ,     (* entree 36, soit entree 3 de CES 06  *)
    CdvPAJ19 ,     (* entree 37, soit entree 4 de CES 06  *)
    CdvPAJZA ,     (* entree 38, soit entree 5 de CES 06  *)
    CdvPAJZ  ,     (* entree 39, soit entree 6 de CES 06  *)
    SigPAJ10 ,     (* entree 40, soit entree 7 de CES 06  *)

    SigPAJ11kv,    (* entree 41, soit entree 0 de CES 07  *)
    SigPAJ11kj,    (* entree 42, soit entree 1 de CES 07  *)

    SigPAJ22 ,     (* entree 44, soit entree 3 de CES 07  *)
    SigPAJZ        (* entree 45, soit entree 4 de CES 07  *)

             : BoolD;

(*   - aiguilles                                                       *)
    AigREJ13,      (* entrees 29 et 30, soit entrees 4 et 5 de CES 05  *)
    AigPAJ21       (* entrees 46 et 47, soit entrees 5 et 6 de CES 07  *)
             :TyAig;



(* Variables ne correspondant pas a une entree securitaire *)
(* Point d'arret *)
    PtArrCdvPAJ10,
    PtArrSigPAJ10,
    PtArrSpePAJ11,
    PtArrCdvPAJ13B,
    PtArrSigPAJZ,

    PtArrCdvREJ10,
    PtArrSigREJ10,
    PtArrSigREJ12,
    PtArrCdvECU12,
    PtArrCdvECU13,
    PtArrCdvECU14,

    PtArrCdvECU23,
    PtArrCdvECU22,
    PtArrCdvECU21,
    PtArrCdvREJ24,
    PtArrSigREJ24,
    PtArrSpeREJ22,   (* Nv pt arret entree quai voie 2 *)
    PtArrCdvREJ20,

    PtArrCdvPAJ23,
    PtArrCdvPAJ22B,
    PtArrSpePAJ22A,
    PtArrSigPAJ22,
    PtArrCdvPAJ19,
    PtArrCdvPAJ18
                          : BoolD;

(* Tiv Com non lies a une aiguille *)
    TivComREJ24    : BoolD;

(* Variants anticipes *)
    PtAntCdvPDG11,
    PtAntCdvPAB07   : BoolD;

(* Copie des entrees dans des variables fonctionnelles pour la regulation *)
    CdvPAJ12Fonc,
    CdvPAJ22Fonc,
    CdvREJ12Fonc,
    CdvREJ22Fonc,
    CdvECU12Fonc,
    CdvECU22Fonc     : BOOLEAN;

(** Voie d'emission SOL-TRAIN : deux sens confondus**)
    te31s22t01,
    te14s22t02,
    te16s22t03,
    te36s22t04,
    te23s22t05,
    te26s22t06           :TyEmissionTele;

(** Voie d'emission Inter-secteur deux voies confondues **)
    teL0123,
    teL0121	          :TyEmissionTele;

(** Voie de reception Inter-secteur deux voies confondues **)
    trL0123,
    trL0121               :TyCaracEntSec;


   V1, V2, V3, V4, V5, V6 : BOOLEAN;


(*  *)
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

(* CONFIGURATION DES ENTREES CNP2, CNP1 ET VERSION *) 

DeclarerVersionSpecific (35);


(* CONFIGURATIONS DIVERSES ****************************************************)

(* CONFIGURATION DES AIGUILLES, POUR LES DEUX VOIES *)
   EntreeAiguille( AigREJ13, 30, 29);   (* kag D = pos normale *)
   EntreeAiguille( AigPAJ21, 47, 46);   (* kag D = pos normale *)

(* Configuration des entrees *)
    ProcEntreeIntrins(  1, CdvPAJ10);
    ProcEntreeIntrins(  2, CdvPAJ12A);
    ProcEntreeIntrins(  3, CdvPAJ13A);
    ProcEntreeIntrins(  4, CdvREJ10);
    ProcEntreeIntrins(  5, CdvREJ11);
    ProcEntreeIntrins(  6, CdvREJ12);
    ProcEntreeIntrins(  7, CdvREJ13);
    ProcEntreeIntrins(  8, CdvREJ14);
    ProcEntreeIntrins(  9, CdvECU11);
    ProcEntreeIntrins( 10, CdvECU12);
    ProcEntreeIntrins( 11, CdvECU13);
    ProcEntreeIntrins( 12, CdvECU14);
    ProcEntreeIntrins( 13, CdvECU23);
    ProcEntreeIntrins( 14, CdvECU22);
    ProcEntreeIntrins( 15, CdvECU21);
    ProcEntreeIntrins( 16, CdvREJ24);
    ProcEntreeIntrins( 17, CdvREJ23);
    ProcEntreeIntrins( 18, CdvREJ22);
    ProcEntreeIntrins( 19, CdvREJ21);
    ProcEntreeIntrins( 20, CdvREJ20);
    ProcEntreeIntrins( 21, CdvPAJ23);
    ProcEntreeIntrins( 22, CdvPAJ22A);
    ProcEntreeIntrins( 23, CdvPAJ21);
    ProcEntreeIntrins( 24, CdvPAJ18);
    ProcEntreeIntrins( 25, SigREJ10);
    ProcEntreeIntrins( 26, SigREJ12);
    ProcEntreeIntrins( 27, SigREJ24kv);
    ProcEntreeIntrins( 28, SigREJ24kj);

    ProcEntreeIntrins( 31, CdvPAJ11A);
    ProcEntreeIntrins( 32, CdvPAJ11B);
    ProcEntreeIntrins( 33, CdvPAJ12B);
    ProcEntreeIntrins( 34, CdvPAJ13B);
    ProcEntreeIntrins( 35, CdvPAJ22B);
    ProcEntreeIntrins( 36, CdvPAJ20);
    ProcEntreeIntrins( 37, CdvPAJ19);
    ProcEntreeIntrins( 38, CdvPAJZA);
    ProcEntreeIntrins( 39, CdvPAJZ);
    ProcEntreeIntrins( 40, SigPAJ10);
    ProcEntreeIntrins( 41, SigPAJ11kv);
    ProcEntreeIntrins( 42, SigPAJ11kj);

    ProcEntreeIntrins( 44, SigPAJ22);
    ProcEntreeIntrins( 45, SigPAJZ);


(* CONFIGURATION POUR LA MAINTENANCE de la transmission continue *)
   ConfigurerBoucle(Boucle1, 1);
   ConfigurerBoucle(Boucle2, 2);
   ConfigurerBoucle(Boucle3, 3);
   ConfigurerBoucle(Boucle4, 4);
   ConfigurerBoucle(Boucle5, 5);
   ConfigurerBoucle(Boucle6, 6);

ConfigurerAmpli(Ampli11, 1, 1, 154, 31, FALSE);
ConfigurerAmpli(Ampli12, 1, 2, 155, 32, FALSE);
ConfigurerAmpli(Ampli13, 1, 3, 222, 32, FALSE);
ConfigurerAmpli(Ampli14, 1, 4, 223, 32, TRUE);
ConfigurerAmpli(Ampli15, 1, 5, 256, 33, FALSE);
ConfigurerAmpli(Ampli16, 1, 6, 158, 33, FALSE);
ConfigurerAmpli(Ampli17, 1, 7, 157, 33, TRUE);
ConfigurerAmpli(Ampli18, 1, 8, 257, 34, FALSE);
ConfigurerAmpli(Ampli19, 1, 9, 156, 34, FALSE);
ConfigurerAmpli(Ampli1A, 1, 10, 258, 34, TRUE);
ConfigurerAmpli(Ampli1B, 1, 11, 259, 35, FALSE);
ConfigurerAmpli(Ampli1C, 1, 12, 260, 35, TRUE);

ConfigurerAmpli(Ampli21, 2, 1, 159, 14, FALSE);
ConfigurerAmpli(Ampli22, 2, 2, 192, 15, FALSE);
ConfigurerAmpli(Ampli23, 2, 3, 193, 15, FALSE);
ConfigurerAmpli(Ampli24, 2, 4, 194, 15, TRUE);

ConfigurerAmpli(Ampli31, 3, 1, 196, 16, FALSE);
ConfigurerAmpli(Ampli32, 3, 2, 197, 17, FALSE);
ConfigurerAmpli(Ampli33, 3, 3, 198, 17, FALSE);
ConfigurerAmpli(Ampli34, 3, 4, 199, 17, TRUE);
ConfigurerAmpli(Ampli35, 3, 5, 195, 13, FALSE);
ConfigurerAmpli(Ampli36, 3, 6, 200, 13, TRUE);

ConfigurerAmpli(Ampli41, 4, 1, 201, 36, FALSE);
ConfigurerAmpli(Ampli42, 4, 2, 202, 37, FALSE);
ConfigurerAmpli(Ampli43, 4, 3, 203, 37, FALSE);
ConfigurerAmpli(Ampli44, 4, 4, 204, 37, TRUE);

ConfigurerAmpli(Ampli51, 5, 1, 205, 23, FALSE);
ConfigurerAmpli(Ampli52, 5, 2, 206, 24, FALSE);
ConfigurerAmpli(Ampli53, 5, 3, 207, 24, FALSE);
ConfigurerAmpli(Ampli54, 5, 4, 208, 24, TRUE);
ConfigurerAmpli(Ampli55, 5, 5, 209, 25, FALSE);
ConfigurerAmpli(Ampli56, 5, 6, 210, 25, FALSE);

ConfigurerAmpli(Ampli61, 6, 1, 211, 26, FALSE);
ConfigurerAmpli(Ampli62, 6, 2, 212, 27, FALSE);
ConfigurerAmpli(Ampli63, 6, 3, 213, 27, FALSE);
ConfigurerAmpli(Ampli64, 6, 4, 214, 27, TRUE);
ConfigurerAmpli(Ampli65, 6, 5, 215, 25, TRUE);
ConfigurerAmpli(Ampli66, 6, 6, 216, 28, FALSE);
ConfigurerAmpli(Ampli67, 6, 7, 217, 28, FALSE);
ConfigurerAmpli(Ampli68, 6, 8, 218, 28, TRUE);
ConfigurerAmpli(Ampli69, 6, 9, 219, 22, FALSE);
ConfigurerAmpli(Ampli6A, 6, 10, 220, 22, FALSE);
ConfigurerAmpli(Ampli6B, 6, 11, 221, 22, TRUE);


 (** cartes CES **)
   ConfigurerCES(CarteCes1, 01);
   ConfigurerCES(CarteCes2, 02);
   ConfigurerCES(CarteCes3, 03);
   ConfigurerCES(CarteCes4, 04);
   ConfigurerCES(CarteCes5, 05);
   ConfigurerCES(CarteCes6, 06);


(** Liaisons Inter-Secteur **)

   ConfigurerIntsecteur(Intersecteur1, 01, trL0123, trL0121);


(* Initialisations des variables ne correspondant pas a des entrees secu *)
(* Point d'arret *)
    AffectBoolD( BoolRestrictif, PtArrCdvPAJ10);
    AffectBoolD( BoolRestrictif, PtArrSigPAJ10);
    AffectBoolD( BoolRestrictif, PtArrSpePAJ11);
    AffectBoolD( BoolRestrictif, PtArrCdvPAJ13B);
    AffectBoolD( BoolRestrictif, PtArrSigPAJZ);
    AffectBoolD( BoolRestrictif, PtArrCdvREJ10);
    AffectBoolD( BoolRestrictif, PtArrSigREJ10);
    AffectBoolD( BoolRestrictif, PtArrSigREJ12);
    AffectBoolD( BoolRestrictif, PtArrCdvECU12);
    AffectBoolD( BoolRestrictif, PtArrCdvECU13);
    AffectBoolD( BoolRestrictif, PtArrCdvECU14);

    AffectBoolD( BoolRestrictif, PtArrCdvECU23);
    AffectBoolD( BoolRestrictif, PtArrCdvECU22);
    AffectBoolD( BoolRestrictif, PtArrCdvECU21);
    AffectBoolD( BoolRestrictif, PtArrCdvREJ24);
    AffectBoolD( BoolRestrictif, PtArrSigREJ24);
    AffectBoolD( BoolRestrictif, PtArrSpeREJ22);
    AffectBoolD( BoolRestrictif, PtArrCdvREJ20);
    AffectBoolD( BoolRestrictif, PtArrCdvPAJ23);
    AffectBoolD( BoolRestrictif, PtArrCdvPAJ22B);
    AffectBoolD( BoolRestrictif, PtArrSpePAJ22A);
    AffectBoolD( BoolRestrictif, PtArrSigPAJ22);
    AffectBoolD( BoolRestrictif, PtArrCdvPAJ19);
    AffectBoolD( BoolRestrictif, PtArrCdvPAJ18);

(* Tiv Com non lies a une aiguille *)
    AffectBoolD( BoolRestrictif, TivComREJ24);

(* Variants anticipes *)
    AffectBoolD( BoolRestrictif, PtAntCdvPDG11);
    AffectBoolD( BoolRestrictif, PtAntCdvPAB07);

(* Copie des entrees dans des variables fonctionnelles pour la regulation *)
    CdvPAJ12Fonc := FALSE;
    CdvPAJ22Fonc := FALSE;
    CdvREJ12Fonc := FALSE;
    CdvREJ22Fonc := FALSE;
    CdvECU12Fonc := FALSE;
    CdvECU22Fonc := FALSE;

END InitSpecDivers;
(*  *)
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

(***************** CONFIGURATION DES VOIES D'EMISSION *****************)

   ConfigEmisTeleSolTrain ( te31s22t01,
                            noBoucle1,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te14s22t02,
                            noBoucle2,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te16s22t03,
                            noBoucle3,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te36s22t04,
                            noBoucle4,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te23s22t05,
                            noBoucle5,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te26s22t06,
                            noBoucle6,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);


(* CONFIGURATION POUR LA REGULATION *)
   ConfigQuai ( 3, 74, CdvPAJ12Fonc, te31s22t01, 0, 3,  4,  5, 10, 13, 14, 15);
   ConfigQuai ( 3, 79, CdvPAJ22Fonc, te26s22t06, 0,12,  2,  3, 10, 13, 14, 15);
   ConfigQuai ( 4, 64, CdvREJ12Fonc, te14s22t02, 0, 9, 11,  5,  6, 13, 14, 15);
   ConfigQuai ( 4, 69, CdvREJ22Fonc, te23s22t05, 0, 5, 10,  6,  7, 13, 14, 15);
   ConfigQuai ( 5, 84, CdvECU12Fonc, te16s22t03, 0, 3,  4,  5, 10, 13, 14, 15);
   ConfigQuai ( 5, 89, CdvECU22Fonc, te36s22t04, 0, 9, 11,  5,  6, 13, 14, 15);

END InitSpecConfMess;
(*  *)
(*----------------------------------------------------------------------------*)
PROCEDURE InSpecMessVar ;
(*----------------------------------------------------------------------------*)
(*
 * Fonction :
 * Cette procedure definit les messages de variants emis vers le TRAIN et 
 * ceux emis et recus sur les liaisons Inter-secteur sur Voie Paire.
 *
 * Condition d'appel : Appelee par InitSpecific a l'initialisation du logiciel
 *
 *)
(*----------------------------------------------------------------------------*)
BEGIN (* InSpecMessVar *)

(* CONFIGURATION DES EMISSIONS DE VARIANTS SOL-TRAIN vers VOIE *************)

(* variants troncon 1   voie 1 --> si *)
   ProcEmisSolTrain( te31s22t01.EmissionSensUp, (2*noBoucle1), 
                     LigneL01+ L0122+ TRONC*01,

              PtArrCdvPAJ10,
              PtArrSigPAJ10,
              BoolRestrictif,             (* aspect croix *)
              PtArrSpePAJ11,
              PtArrCdvPAJ13B,
              PtArrCdvREJ10,
              PtArrSigPAJZ,
              BoolRestrictif,             (* aspect croix *)
(* Variants Anticipes *)
              PtArrSigREJ10,
              BoolRestrictif,             (* aspect croix *)
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
              BaseSorVar);
(*  *)
(* variants troncon 2   voie 1 --> si  *)
   ProcEmisSolTrain( te14s22t02.EmissionSensUp, (2*noBoucle2), 
                     LigneL01+ L0122+ TRONC*02,

              PtArrSigREJ10,
              BoolRestrictif,             (* aspect croix *)
              PtArrSigREJ12,
              BoolRestrictif,             (* aspect croix *)
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
(* Variants Anticipes *)
              PtArrCdvECU12,
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
              BaseSorVar + 30);


(* variants troncon 3    voie 1  ---> si  *)
   ProcEmisSolTrain( te16s22t03.EmissionSensUp, (2*noBoucle3), 
                     LigneL01+ L0122+ TRONC*03,

              PtArrCdvECU12,
              PtArrCdvECU13,
              PtArrCdvECU14,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
(* Variants Anticipes *)
              PtAntCdvPDG11,
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

(*  *)
(* variants troncon 4  voie 2 <-- sp *)
   ProcEmisSolTrain( te36s22t04.EmissionSensUp, (2*noBoucle4), 
                     LigneL01+ L0122+ TRONC*04,

              PtArrCdvECU23,
              PtArrCdvECU22,
              PtArrCdvECU21,
              PtArrCdvREJ24,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
(* Variants Anticipes *)
              PtArrSigREJ24,
              BoolRestrictif,             (* aspect croix *)
              TivComREJ24,
              AigREJ13.PosReverseFiltree,
              AigREJ13.PosNormaleFiltree,
              PtArrSpeREJ22,
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

(* variants du troncon 5 voie 2 <-- sp *)
   ProcEmisSolTrain( te23s22t05.EmissionSensUp, (2*noBoucle5), 
                     LigneL01+ L0122+ TRONC*05,

              PtArrSigREJ24,
              BoolRestrictif,             (* aspect croix *)
              TivComREJ24,
              AigREJ13.PosReverseFiltree,
              AigREJ13.PosNormaleFiltree,
              PtArrSpeREJ22,
              PtArrCdvREJ20,
              BoolRestrictif,             (* sig Fict rouge fix REJ12A *)
              BoolRestrictif,             (* aspect croix *)
(* Variants Anticipes *)
              PtArrCdvPAJ23,
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

(*  *)
(* variants du troncon 6 voie 2 <-- sp *)
   ProcEmisSolTrain( te26s22t06.EmissionSensUp, (2*noBoucle6), 
                     LigneL01+ L0122+ TRONC*06,

              PtArrCdvPAJ23,
              PtArrCdvPAJ22B,
              PtArrSpePAJ22A,
              PtArrSigPAJ22,
              BoolRestrictif,             (* aspect croix *)
              AigPAJ21.PosReverseFiltree,
              AigPAJ21.PosNormaleFiltree,
              BoolRestrictif,             (* sig Fict rouge fix voie Z *)
              BoolRestrictif,             (* aspect croix *)
              PtArrCdvPAJ19,
              PtArrCdvPAJ18,
              BoolRestrictif,
(* Variants Anticipes *)
              PtAntCdvPAB07,
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

(*  *)
(* reception du secteur 23 -aval- *)

   ProcReceptInterSecteur(trL0123, noBouclepdg, LigneL01+ L0123+ TRONC*01,
                  PtAntCdvPDG11,
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
                  BoolRestrictif,
                  BaseEntVar,
                  V1,
		  V2,
                  V3,
		  V4,
                  V5,
		  V6,
		  BaseEntVar + 1);
(*  *)

(* reception du secteur 21 -amont- *)

   ProcReceptInterSecteur(trL0121, noBouclepab, LigneL01+ L0121+ TRONC*03,

                  PtAntCdvPAB07,
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
                  BoolRestrictif,
                  BaseEntVar + 5,
		  V1,
                  V2,
                  V3,
                  V4,
                  V5,
		  V6,
		  BaseEntVar + 6);


(*  *)
(* emission vers le secteur 23 -aval- *)

   ProcEmisInterSecteur (teL0123, noBouclepdg, LigneL01+ L0122+ TRONC*04,
			noBouclepdg,
                  PtArrCdvECU23,
                  PtArrCdvECU22,
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
		  BaseSorVar + 180);


(*  *)

(* emission vers le secteur 21 -amont- *)

   ProcEmisInterSecteur (teL0121, noBouclepab, LigneL01+ L0122+ TRONC*01,
			noBouclepab,
                  PtArrCdvPAJ10,
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
                  BoolRestrictif,
 		  V1,
                  V2,
                  V3,
                  V4,
                  V5,
		  V6,
		  BaseSorVar + 210);


END InSpecMessVar;
(*  *)
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

(********* CONFIGURATION DES EMISSION DES INVARIANTS SECURITAIRES ********)

(* Tous les sens doivent etre a SensUp ; il n'y a pas de commutation *)
            

 (** Emission invariants vers secteur 23 aval L0123 **)

   EmettreSegm(LigneL01+ L0122+ TRONC*04+ SEGM*00, noBouclepdg, SensUp);
   EmettreSegm(LigneL01+ L0122+ TRONC*05+ SEGM*00, noBouclepdg, SensUp);
                 
 (** Emission invariants vers secteur 21 amont L0121 **)

   EmettreSegm(LigneL01+ L0122+ TRONC*01+ SEGM*00, noBouclepab, SensUp);
   EmettreSegm(LigneL01+ L0122+ TRONC*01+ SEGM*01, noBouclepab, SensUp);

 (** Boucle 1 **)
   EmettreSegm(LigneL01+ L0122+ TRONC*01+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL01+ L0122+ TRONC*01+ SEGM*01, noBoucle1, SensUp);
   EmettreSegm(LigneL01+ L0122+ TRONC*01+ SEGM*02, noBoucle1, SensUp);
   EmettreSegm(LigneL01+ L0122+ TRONC*02+ SEGM*00, noBoucle1, SensUp);

 (** Boucle 2 **)
   EmettreSegm(LigneL01+ L0122+ TRONC*02+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL01+ L0122+ TRONC*03+ SEGM*00, noBoucle2, SensUp);

 (** Boucle 3 **)
   EmettreSegm(LigneL01+ L0122+ TRONC*03+ SEGM*00, noBoucle3, SensUp);
   EmettreSegm(LigneL01+ L0123+ TRONC*01+ SEGM*00, noBoucle3, SensUp);
   EmettreSegm(LigneL01+ L0123+ TRONC*01+ SEGM*01, noBoucle3, SensUp);

 (** Boucle 4 **)
   EmettreSegm(LigneL01+ L0122+ TRONC*04+ SEGM*00, noBoucle4, SensUp);
   EmettreSegm(LigneL01+ L0122+ TRONC*05+ SEGM*00, noBoucle4, SensUp);
   EmettreSegm(LigneL01+ L0122+ TRONC*05+ SEGM*01, noBoucle4, SensUp);

 (** Boucle 5 **)
   EmettreSegm(LigneL01+ L0122+ TRONC*05+ SEGM*00, noBoucle5, SensUp);
   EmettreSegm(LigneL01+ L0122+ TRONC*05+ SEGM*01, noBoucle5, SensUp);
   EmettreSegm(LigneL01+ L0122+ TRONC*06+ SEGM*00, noBoucle5, SensUp);
   EmettreSegm(LigneL01+ L0122+ TRONC*06+ SEGM*01, noBoucle5, SensUp);

   EmettreSegm(LigneL01+ L0122+ TRONC*02+ SEGM*00, noBoucle5, SensUp);
  
 (** Boucle 6 **)
  (* EmettreSegm(LigneL01+ L0122+ TRONC*06+ SEGM*00, noBoucle6, SensUp); *)
   EmettreSegm(LigneL01+ L0122+ TRONC*06+ SEGM*01, noBoucle6, SensUp);

   EmettreSegm(LigneL01+ L0121+ TRONC*03+ SEGM*00, noBoucle6, SensUp);
   EmettreSegm(LigneL01+ L0121+ TRONC*03+ SEGM*01, noBoucle6, SensUp);
   EmettreSegm(LigneL01+ L0122+ TRONC*01+ SEGM*02, noBoucle6, SensUp);
   EmettreSegm(LigneL01+ L0122+ TRONC*01+ SEGM*01, noBoucle6, SensUp);

(*  *)

(************************* CONFIGURATION DES TRONCONS TSR **************************)

   ConfigurerTroncon(Tronc0, LigneL01 + L0122 + TRONC*01, 2,2,2,2);  (* troncon 22-1 *)
   ConfigurerTroncon(Tronc1, LigneL01 + L0122 + TRONC*02, 2,2,2,2);  (* troncon 22-2 *)
   ConfigurerTroncon(Tronc2, LigneL01 + L0122 + TRONC*03, 2,2,2,2);  (* troncon 22-3 *)
   ConfigurerTroncon(Tronc3, LigneL01 + L0122 + TRONC*04, 2,2,2,2);  (* troncon 22-4 *)
   ConfigurerTroncon(Tronc4, LigneL01 + L0122 + TRONC*05, 2,2,2,2);  (* troncon 22-5 *)
   ConfigurerTroncon(Tronc5, LigneL01 + L0122 + TRONC*06, 2,2,2,2);  (* troncon 22-6 *)


(************************************* EMISSION DES TSR **************************************)



(** Emission des TSR vers le secteur aval 23 L0123 **)

   EmettreTronc(LigneL01+ L0122+ TRONC*04, noBouclepdg, SensUp);
   EmettreTronc(LigneL01+ L0122+ TRONC*05, noBouclepdg, SensUp);

(** Emission des TSR vers le secteur amont 21 L0121 **)

   EmettreTronc(LigneL01+ L0122+ TRONC*01, noBouclepab, SensUp);


 (** Emission des TSR sur les troncons du secteur courant **)

   EmettreTronc(LigneL01+ L0122+ TRONC*01, noBoucle1, SensUp); (* troncon 22-1 *)
   EmettreTronc(LigneL01+ L0122+ TRONC*02, noBoucle1, SensUp);


   EmettreTronc(LigneL01+ L0122+ TRONC*02, noBoucle2, SensUp); (* troncon 22-2 *)
   EmettreTronc(LigneL01+ L0122+ TRONC*03, noBoucle2, SensUp);


   EmettreTronc(LigneL01+ L0122+ TRONC*03, noBoucle3, SensUp); (* troncon 22-3 *)
   EmettreTronc(LigneL01+ L0123+ TRONC*01, noBoucle3, SensUp);


   EmettreTronc(LigneL01+ L0122+ TRONC*04, noBoucle4, SensUp); (* troncon 22-4 *)
   EmettreTronc(LigneL01+ L0122+ TRONC*05, noBoucle4, SensUp);


   EmettreTronc(LigneL01+ L0122+ TRONC*05, noBoucle5, SensUp); (* troncon 22-5 *)
   EmettreTronc(LigneL01+ L0122+ TRONC*06, noBoucle5, SensUp);
   EmettreTronc(LigneL01+ L0122+ TRONC*02, noBoucle5, SensUp);


   EmettreTronc(LigneL01+ L0122+ TRONC*06, noBoucle6, SensUp); (* troncon 22-6 *)
   EmettreTronc(LigneL01+ L0121+ TRONC*03, noBoucle6, SensUp);
   EmettreTronc(LigneL01+ L0122+ TRONC*01, noBoucle6, SensUp);


END InSpecMessInv ;

(*  *)
(*----------------------------------------------------------------------------*)
PROCEDURE StockerAdresse;
(*----------------------------------------------------------------------------*)
(*
 * Fonction :
 * 	Cette procedure stocke l'adresse de toutes les variables securitaires.
 *
 * Condition d'appel : Appelee par InitSpecific a l'initialisation du logiciel
 *
 *)
(*----------------------------------------------------------------------------*)
BEGIN (* StockerAdresse *)

(* VARIABLES *)
    StockAdres( ADR( CdvPAJ10));
    StockAdres( ADR( CdvPAJ12A));
    StockAdres( ADR( CdvPAJ13A));
    StockAdres( ADR( CdvREJ10));
    StockAdres( ADR( CdvREJ11));
    StockAdres( ADR( CdvREJ12));
    StockAdres( ADR( CdvREJ13));
    StockAdres( ADR( CdvREJ14));
    StockAdres( ADR( CdvECU11));
    StockAdres( ADR( CdvECU12));
    StockAdres( ADR( CdvECU13));
    StockAdres( ADR( CdvECU14));

    StockAdres( ADR( CdvECU23));
    StockAdres( ADR( CdvECU22));
    StockAdres( ADR( CdvECU21));
    StockAdres( ADR( CdvREJ24));
    StockAdres( ADR( CdvREJ23));
    StockAdres( ADR( CdvREJ22));
    StockAdres( ADR( CdvREJ21));
    StockAdres( ADR( CdvREJ20));
    StockAdres( ADR( CdvPAJ23));
    StockAdres( ADR( CdvPAJ22A));
    StockAdres( ADR( CdvPAJ21));
    StockAdres( ADR( CdvPAJ18));

    StockAdres( ADR( SigREJ10));
    StockAdres( ADR( SigREJ12));
    StockAdres( ADR( SigREJ24kv));
    StockAdres( ADR( SigREJ24kj));

    StockAdres( ADR( CdvPAJ11A));
    StockAdres( ADR( CdvPAJ11B));
    StockAdres( ADR( CdvPAJ12B));
    StockAdres( ADR( CdvPAJ13B));
    StockAdres( ADR( CdvPAJ22B));
    StockAdres( ADR( CdvPAJ20));
    StockAdres( ADR( CdvPAJ19));
    StockAdres( ADR( CdvPAJZA));
    StockAdres( ADR( CdvPAJZ));
    StockAdres( ADR( SigPAJ10));
    StockAdres( ADR( SigPAJ11kv));
    StockAdres( ADR( SigPAJ11kj));
    StockAdres( ADR( SigPAJ22));
    StockAdres( ADR( SigPAJZ));

    StockAdres( ADR( AigREJ13));
    StockAdres( ADR( AigPAJ21));



    StockAdres( ADR( PtArrCdvPAJ10));
    StockAdres( ADR( PtArrSigPAJ10));
    StockAdres( ADR( PtArrSpePAJ11));
    StockAdres( ADR( PtArrCdvPAJ13B));
    StockAdres( ADR( PtArrSigPAJZ));

    StockAdres( ADR( PtArrCdvREJ10));
    StockAdres( ADR( PtArrSigREJ10));
    StockAdres( ADR( PtArrSigREJ12));
    StockAdres( ADR( PtArrCdvECU12));
    StockAdres( ADR( PtArrCdvECU13));
    StockAdres( ADR( PtArrCdvECU14));

    StockAdres( ADR( PtArrCdvECU23));
    StockAdres( ADR( PtArrCdvECU22));
    StockAdres( ADR( PtArrCdvECU21));
    StockAdres( ADR( PtArrCdvREJ24));
    StockAdres( ADR( PtArrSigREJ24));
    StockAdres( ADR( PtArrSpeREJ22));
    StockAdres( ADR( PtArrCdvREJ20));

    StockAdres( ADR( PtArrCdvPAJ23));
    StockAdres( ADR( PtArrCdvPAJ22B));
    StockAdres( ADR( PtArrSpePAJ22A));
    StockAdres( ADR( PtArrSigPAJ22));
    StockAdres( ADR( PtArrCdvPAJ19));
    StockAdres( ADR( PtArrCdvPAJ18));

    StockAdres( ADR( TivComREJ24));

    StockAdres( ADR( PtAntCdvPDG11));
    StockAdres( ADR( PtAntCdvPAB07));

END StockerAdresse ;
(*  *)
(*----------------------------------------------------------------------------*)
PROCEDURE InitInutil ;
(*----------------------------------------------------------------------------*)
(*
 * Fonction :
 * 	Cette procedure permet l'initialisation des variables de troncons et 
 *	d'interstations du standard qui ne font pas partie de la configuration
 *  	reelle du secteur.
 *
 * Condition d'appel : Appelee par InitSpecific a l'initialisation du logiciel
 *
 *)
(*----------------------------------------------------------------------------*)
BEGIN (* InitInutil *)

	(* Configuration des troncons *)

            ConfigurerTroncon(Tronc6,  0, 0,0,0,0) ;
            ConfigurerTroncon(Tronc7,  0, 0,0,0,0) ;
            ConfigurerTroncon(Tronc8,  0, 0,0,0,0) ;
            ConfigurerTroncon(Tronc9,  0, 0,0,0,0) ;
            ConfigurerTroncon(Tronc10, 0, 0,0,0,0) ;
            ConfigurerTroncon(Tronc11, 0, 0,0,0,0) ;
            ConfigurerTroncon(Tronc12, 0, 0,0,0,0) ;
            ConfigurerTroncon(Tronc13, 0, 0,0,0,0) ;
            ConfigurerTroncon(Tronc14, 0, 0,0,0,0) ;
            ConfigurerTroncon(Tronc15, 0, 0,0,0,0) ;

END InitInutil ;
(*  *)
(*----------------------------------------------------------------------------*)
PROCEDURE InitSpecific ;
(*----------------------------------------------------------------------------*)
(*
 * Fonction :
 * Cette procedure appelle : InitSpecDivers, InitSpecConfMess
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

(**** 	CONFIGURATION DES VARIABLES DU STANDARD NON UTILISEES *************)
   InitInutil ;

(****   Stockage des adresses *****)
   StockerAdresse ;

END InitSpecific;

(*  *)
(*------------------------------------------------------------------------------*)
PROCEDURE ExeSpecific ;
(*------------------------------------------------------------------------------*)
(*
 * Fonction :
 * Cette procedure Traite la reconfiguration CdV, les caracteristiques
 * commutable (Zone d'arret d'urgence, FOD...) et fait le chainage des
 * portions de voie.
 *
 * Condition d'appel : Appelee par Applicati a chaque cycle du logiciel
 *
 *)
(*------------------------------------------------------------------------------*)
BEGIN (* ExeSpecific *)

(* Affectation des "constantes" utilisees dans la construction des messages emis    *)
(* et recus sur les boucles de transmission continue et sur les liens intersecteur. *)
(* Cette reaffectation est necessaire a chaque cycle pour la mise en securite.      *)
   AffectBoolC(Vrai, BoolPermissif)  ;
   AffectBoolC(Faux, BoolRestrictif) ;

(* regulation *)
   CdvPAJ12Fonc := (CdvPAJ12A.F = Vrai.F) AND (CdvPAJ12B.F = Vrai.F);
   CdvPAJ22Fonc := (CdvPAJ22B.F = Vrai.F) AND (CdvPAJ22A.F = Vrai.F);
   CdvREJ12Fonc := CdvREJ12.F = Vrai.F;
   CdvREJ22Fonc := CdvREJ22.F = Vrai.F;
   CdvECU12Fonc := CdvECU12.F = Vrai.F;
   CdvECU22Fonc := CdvECU22.F = Vrai.F;


(*  *)
(******************************* FILTRAGE DES AIGUILLES *******************************)

   FiltrerAiguille( AigREJ13, BaseExeAig);
   FiltrerAiguille( AigPAJ21, BaseExeAig+2);

(************************** Gerer les point d'arrets **************************)

   AffectBoolD( CdvPAJ10,                   PtArrCdvPAJ10);
   AffectBoolD( SigPAJ10,                   PtArrSigPAJ10);
   OuDD(        SigPAJ11kv,   SigPAJ11kj,   PtArrSpePAJ11);

   AffectBoolD( CdvPAJ13B,                  PtArrCdvPAJ13B);
   AffectBoolD( CdvREJ10,                   PtArrCdvREJ10);
   AffectBoolD( SigREJ10,                   PtArrSigREJ10);
   AffectBoolD( SigREJ12,                   PtArrSigREJ12);
   AffectBoolD( CdvECU12,                   PtArrCdvECU12);
   AffectBoolD( CdvECU13,                   PtArrCdvECU13);
   AffectBoolD( CdvECU14,                   PtArrCdvECU14);

   AffectBoolD( CdvECU23,                   PtArrCdvECU23);
   AffectBoolD( CdvECU22,                   PtArrCdvECU22);
   AffectBoolD( CdvECU21,                   PtArrCdvECU21);
   AffectBoolD( CdvREJ24,                   PtArrCdvREJ24);
   OuDD(        SigREJ24kv,   SigREJ24kj,   PtArrSigREJ24);
   EtDD(        CdvREJ22,     CdvREJ21,     PtArrSpeREJ22);

   AffectBoolD( CdvREJ20,                   PtArrCdvREJ20);
   AffectBoolD( CdvPAJ23,                   PtArrCdvPAJ23);
   EtDD(        CdvPAJ22B,     CdvPAJ22A,   PtArrCdvPAJ22B);
   EtDD(        CdvPAJ22A,     CdvPAJ21,    PtArrSpePAJ22A);
   
   AffectBoolD( SigPAJ22,                   PtArrSigPAJ22);
   AffectBoolD( CdvPAJ19,                   PtArrCdvPAJ19);
   AffectBoolD( CdvPAJ18,                   PtArrCdvPAJ18);

   AffectBoolD( SigPAJZ,                    PtArrSigPAJZ);

   AffectBoolD( AigREJ13.PosNormaleFiltree, TivComREJ24);


(*** lecture des entrees de regulation ***)

   LireEntreesRegul;

END ExeSpecific;
END Specific.
