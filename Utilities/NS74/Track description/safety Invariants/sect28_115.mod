IMPLEMENTATION MODULE Specific;

(*$S- *)
(*$T- *)

(******************************************************************************
*   SANTIAGO - LIGNE 1 - Secteur 28
*  =============================
*  Version : SCCS 1.0
*  Date    : 02/09/1997
*  Auteur  : Marc Plywacz
*  Premiere Version
******************************************************************************)

(*---------------------------------------------------------------------------*)
(* Modifications :                                                           *)
(* -------------                                                             *)
(*                                                                           *)
(*  Date : 11/09/1997, Auteur: P. HOG    , Origine : equipe developpement    *)
(*    Correction des emissions inter-secteur.                                *)
(*                                                                           *)
(*  Date : 17/09/1997, Auteur : P. HOG     , Origine : Equipe developpement  *)
(*    Suppression des variables de boucles inter-secteur (inutiles).         *)
(*                                                                           *)
(*  Version 1.0.2                                                            *)
(*  Date : 24/09/1997, Auteur : P. HOG     , Origine : Equipe developpement  *)
(*    Modification des anticipations suite aux changements de vitesse.       *)
(*                                                                           *)
(*  Version 1.1.0                                                            *)
(*  Date : 29/09/1997, Auteur : P. HOG     , Origine : Equipe developpement  *)
(*    Correction de l'inversion des variants anticipes sur le troncon 1.     *)
(*                                                                           *)
(* ========= Version 1.1.0 du 01/10/1997 ===(1ere version validee)========== *)
(*                                                                           *)
(*  Version 1.1.1                                                            *)
(*  Date : 23/01/1998, Auteur : F. Chanier , Origine : Equipe developpement  *)
(*    Modification de la detection des pannes d'ampli.                       *)
(*  Date : 13/02/1998, Auteur : F. Chanier, Origine : Eq. de DEV             *)
(*    Modification des marches types.                                        *)
(*---------------------------------------------------------------------------*)
(*****************************************************************************)
(***            AJOUT DE LA NUMEROTATION SCCS DES VERSIONS                ****)
(*---------------------------------------------------------------------------*)
(* Version 1.1.2  =====================                                      *)
(* Version 1.6 DU SERVEUR SCCS =====================                         *)
(* Date :         10/09/1998                                                 *)
(* Auteur:        H. Le Roy                                                  *)
(* Modification : Fiche d'anomalie ba040998                                  *)
(*                Suite a un changement de vitesses maximales, mise a jour   *)
(*                des marches types                                          *)
(*---------------------------------------------------------------------------*)
(* Version 1.1.3  =====================                                      *)
(* Version 1.7 DU SERVEUR SCCS =====================                         *)
(* Date :         19/04/1999                                                 *)
(* Auteur:        H. Le Roy                                                  *)
(* Modification : Adaptation et modification de la configuration des amplis  *)
(*                 pour detecter les pannes de fusibles.Suppression de       *)
(*                 parties de code inutiles concernant les DAMTC.            *)
(*---------------------------------------------------------------------------*)
(* Version 1.1.4  =====================                                      *)
(* Version 1.8 DU SERVEUR SCCS =====================                         *)
(* Date :         19/06/2000                                                 *)
(* Auteur:        H. Le Roy                                                  *)
(* Modification : Am165 : Modification des marches types                     *)
(*                                                                           *)
(*---------------------------------------------------------------------------*)
(* Version 1.1.5  =====================                                      *)
(* Version 1.9 DU SERVEUR SCCS =====================                         *)
(* Date :         08/08/2006                                                 *)
(* Auteur:        Rudy Nsiona                                                *)
(* Modification : Nouveau Train NS2004                                       *)
(* Procédure CONFIGURATION DES TRONCONS TSR                                  *)
(*                ancienne valeur 1 , nouvelle 2                             *)
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

              		Ampli11, Ampli12, Ampli13, Ampli14, 
              		Ampli21, Ampli22, Ampli23, Ampli24,
              		Ampli31, Ampli32, Ampli33, Ampli34,
              		Ampli41, Ampli42, Ampli43, Ampli44,
              		Ampli51, Ampli52, Ampli53, Ampli54,
              		Ampli61, Ampli62, Ampli63, Ampli64, Ampli65,
    
(* variables *)
                       Boucle1, Boucle2, Boucle3, Boucle4, Boucle5, Boucle6, BoucleFictive,
		       CarteCes1,  CarteCes2,  CarteCes3, CarteCes4,
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
                       Tronc0,  Tronc1,  Tronc2,  Tronc3 , Tronc4,  Tronc5,
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

    L0129  = 1024*29;    (* numero Secteur aval voie impaire decale de 2**10 *)

    L0128  = 1024*28;    (* numero Secteur local decale de 2**10 *)

    L0127  = 1024*27;    (* numero Secteur amont voie impaire decale de 2**10 *)


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
    noBoucletob = 00; 
    noBouclebaq = 01; 
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

(* DECLARATION DES SINGULARITES DU SECTEUR 28 : dans les deux sens confondus *)


(* Declaration des variables correspondant a des entrees securitaires  *)
(*   - CDV et signaux                                                  *)
    CdvSAL11,      (* entree  1, soit entree 0 de CES 02  *)
    CdvSAL12,      (* entree  2, soit entree 1 de CES 02  *)
    CdvSAL13,      (* entree  3, soit entree 2 de CES 02  *)
    CdvSAL14A,     (* entree  4, soit entree 3 de CES 02  *)
    CdvSAL14B,     (* entree  5, soit entree 4 de CES 02  *)
    CdvMON11,      (* entree  6, soit entree 5 de CES 02  *)
    CdvMON12,      (* entree  7, soit entree 6 de CES 02  *)
    CdvMON13,      (* entree  8, soit entree 7 de CES 02  *)
    CdvMON14,      (* entree  9, soit entree 0 de CES 03  *)
    CdvPDV11,      (* entree 10, soit entree 1 de CES 03  *)
    CdvPDV12,      (* entree 11, soit entree 2 de CES 03  *)
    CdvPDV13,      (* entree 12, soit entree 3 de CES 03  *)
    CdvPDV14,      (* entree 13, soit entree 4 de CES 03  *)

    CdvPDV23,      (* entree 14, soit entree 5 de CES 03  *)
    CdvPDV22,      (* entree 15, soit entree 6 de CES 03  *)
    CdvPDV21,      (* entree 16, soit entree 7 de CES 03  *)
    CdvPDV20,      (* entree 17, soit entree 0 de CES 04  *)
    CdvMON23,      (* entree 18, soit entree 1 de CES 04  *)
    CdvMON22,      (* entree 19, soit entree 2 de CES 04  *)
    CdvMON21,      (* entree 20, soit entree 3 de CES 04  *)
    CdvMON20B,     (* entree 21, soit entree 4 de CES 04  *)
    CdvMON20A,     (* entree 22, soit entree 5 de CES 04  *)
    CdvSAL23,      (* entree 23, soit entree 6 de CES 04  *)
    CdvSAL22,      (* entree 24, soit entree 7 de CES 04  *)
    CdvSAL21       (* entree 25, soit entree 0 de CES 05  *)
             : BoolD;

(*   - aiguilles                                                       *)
    (* pas d'aiguille *)



(* Variables ne correspondant pas a une entree securitaire *)
(* Point d'arret *)
    PtArrCdvSAL11,
    PtArrCdvSAL12,
    PtArrCdvSAL13,
    PtArrCdvSAL14,
    PtArrCdvMON11,
    PtArrCdvMON12,
    PtArrCdvMON13,
    PtArrCdvMON14,
    PtArrCdvPDV11,
    PtArrCdvPDV12,
    PtArrCdvPDV13,
    PtArrCdvPDV14,

    PtArrCdvPDV23,
    PtArrCdvPDV22,
    PtArrCdvPDV21,
    PtArrCdvPDV20,
    PtArrCdvMON23,
    PtArrCdvMON22,
    PtArrCdvMON21,
    PtArrCdvMON20,
    PtArrCdvSAL23,
    PtArrCdvSAL22,
    PtArrCdvSAL21   : BoolD;

(* Variants anticipes *)
    PtAntCdvLEO11,
    PtAntCdvLEO12,
    PtAntCdvBAQ24,
    PtAntSigBAQ24   : BoolD;

(* Copie des entrees dans des variables fonctionnelles pour la regulation *)
    CdvSAL12Fonc,
    CdvSAL22Fonc,
    CdvMON12Fonc,
    CdvMON22Fonc,
    CdvPDV12Fonc,
    CdvPDV22Fonc     : BOOLEAN;

(** Voie d'emission SOL-TRAIN : deux sens confondus**)
    te11s28t01,
    te14s28t02,
    te16s28t03,
    te21s28t04,
    te24s28t05,
    te26s28t06           :TyEmissionTele;

(** Voie d'emission Inter-secteur deux voies confondues **)
    teL0129,
    teL0127	          :TyEmissionTele;

(** Voie de reception Inter-secteur deux voies confondues **)
    trL0129,
    trL0127               :TyCaracEntSec;


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
   (* pas d'aiguille *)

(* Configuration des entrees *)
    ProcEntreeIntrins(  1, CdvSAL11);
    ProcEntreeIntrins(  2, CdvSAL12);
    ProcEntreeIntrins(  3, CdvSAL13);
    ProcEntreeIntrins(  4, CdvSAL14A);
    ProcEntreeIntrins(  5, CdvSAL14B);
    ProcEntreeIntrins(  6, CdvMON11);
    ProcEntreeIntrins(  7, CdvMON12);
    ProcEntreeIntrins(  8, CdvMON13);
    ProcEntreeIntrins(  9, CdvMON14);
    ProcEntreeIntrins( 10, CdvPDV11);
    ProcEntreeIntrins( 11, CdvPDV12);
    ProcEntreeIntrins( 12, CdvPDV13);
    ProcEntreeIntrins( 13, CdvPDV14);
    ProcEntreeIntrins( 14, CdvPDV23);
    ProcEntreeIntrins( 15, CdvPDV22);
    ProcEntreeIntrins( 16, CdvPDV21);
    ProcEntreeIntrins( 17, CdvPDV20);
    ProcEntreeIntrins( 18, CdvMON23);
    ProcEntreeIntrins( 19, CdvMON22);
    ProcEntreeIntrins( 20, CdvMON21);
    ProcEntreeIntrins( 21, CdvMON20B);
    ProcEntreeIntrins( 22, CdvMON20A);
    ProcEntreeIntrins( 23, CdvSAL23);
    ProcEntreeIntrins( 24, CdvSAL22);
    ProcEntreeIntrins( 25, CdvSAL21);


(* CONFIGURATION POUR LA MAINTENANCE de la transmission continue *)
   ConfigurerBoucle(Boucle1, 1);
   ConfigurerBoucle(Boucle2, 2);
   ConfigurerBoucle(Boucle3, 3);
   ConfigurerBoucle(Boucle4, 4);
   ConfigurerBoucle(Boucle5, 5);
   ConfigurerBoucle(Boucle6, 6);

   ConfigurerAmpli(Ampli11, 1, 1, 154, 11, FALSE);
   ConfigurerAmpli(Ampli12, 1, 2, 155, 12, FALSE);
   ConfigurerAmpli(Ampli13, 1, 3, 156, 12, FALSE);
   ConfigurerAmpli(Ampli14, 1, 4, 157, 12, TRUE);

   ConfigurerAmpli(Ampli21, 2, 1, 158, 14, FALSE);
   ConfigurerAmpli(Ampli22, 2, 2, 159, 15, FALSE);
   ConfigurerAmpli(Ampli23, 2, 3, 192, 15, FALSE);
   ConfigurerAmpli(Ampli24, 2, 4, 193, 15, TRUE);     

   ConfigurerAmpli(Ampli31, 3, 1, 194, 16, FALSE);
   ConfigurerAmpli(Ampli32, 3, 2, 195, 17, FALSE);
   ConfigurerAmpli(Ampli33, 3, 3, 196, 17, FALSE);
   ConfigurerAmpli(Ampli34, 3, 4, 197, 17, TRUE);     

   ConfigurerAmpli(Ampli41, 4, 1, 198, 21, FALSE);
   ConfigurerAmpli(Ampli42, 4, 2, 199, 22, FALSE);
   ConfigurerAmpli(Ampli43, 4, 3, 200, 22, FALSE);
   ConfigurerAmpli(Ampli44, 4, 4, 201, 22, TRUE);   

   ConfigurerAmpli(Ampli51, 5, 1, 202, 24, FALSE);
   ConfigurerAmpli(Ampli52, 5, 2, 203, 25, FALSE);
   ConfigurerAmpli(Ampli53, 5, 3, 204, 25, FALSE);
   ConfigurerAmpli(Ampli54, 5, 4, 205, 25, TRUE);   
                                                  
   ConfigurerAmpli(Ampli61, 6, 1, 202, 26, FALSE);
   ConfigurerAmpli(Ampli62, 6, 2, 203, 27, FALSE);
   ConfigurerAmpli(Ampli63, 6, 3, 204, 27, TRUE);
   ConfigurerAmpli(Ampli64, 6, 4, 205, 27, TRUE);   
   ConfigurerAmpli(Ampli65, 6, 5, 211, 28, FALSE);                                                  

 (** cartes CES **)
   ConfigurerCES(CarteCes1, 01);
   ConfigurerCES(CarteCes2, 02);
   ConfigurerCES(CarteCes3, 03);
   ConfigurerCES(CarteCes4, 04);


(** Liaisons Inter-Secteur **)

   ConfigurerIntsecteur(Intersecteur1, 01, trL0129, trL0127);


(* Initialisations des variables ne correspondant pas a des entrees secu *)
(* Point d'arret *)
    AffectBoolD( BoolRestrictif, PtArrCdvSAL11);
    AffectBoolD( BoolRestrictif, PtArrCdvSAL12);
    AffectBoolD( BoolRestrictif, PtArrCdvSAL13);
    AffectBoolD( BoolRestrictif, PtArrCdvSAL14);
    AffectBoolD( BoolRestrictif, PtArrCdvMON11);
    AffectBoolD( BoolRestrictif, PtArrCdvMON12);
    AffectBoolD( BoolRestrictif, PtArrCdvMON13);
    AffectBoolD( BoolRestrictif, PtArrCdvMON14);
    AffectBoolD( BoolRestrictif, PtArrCdvPDV11);
    AffectBoolD( BoolRestrictif, PtArrCdvPDV12);
    AffectBoolD( BoolRestrictif, PtArrCdvPDV13);
    AffectBoolD( BoolRestrictif, PtArrCdvPDV14);
    AffectBoolD( BoolRestrictif, PtArrCdvPDV23);
    AffectBoolD( BoolRestrictif, PtArrCdvPDV22);
    AffectBoolD( BoolRestrictif, PtArrCdvPDV21);
    AffectBoolD( BoolRestrictif, PtArrCdvPDV20);
    AffectBoolD( BoolRestrictif, PtArrCdvMON23);
    AffectBoolD( BoolRestrictif, PtArrCdvMON22);
    AffectBoolD( BoolRestrictif, PtArrCdvMON21);
    AffectBoolD( BoolRestrictif, PtArrCdvMON20);
    AffectBoolD( BoolRestrictif, PtArrCdvSAL23);
    AffectBoolD( BoolRestrictif, PtArrCdvSAL22);
    AffectBoolD( BoolRestrictif, PtArrCdvSAL21);

(* Variants anticipes *)
    AffectBoolD( BoolRestrictif, PtAntCdvLEO11);
    AffectBoolD( BoolRestrictif, PtAntCdvLEO12);
    AffectBoolD( BoolRestrictif, PtAntCdvBAQ24);
    AffectBoolD( BoolRestrictif, PtAntSigBAQ24);

(* Copie des entrees dans des variables fonctionnelles pour la regulation *)
    CdvSAL12Fonc := FALSE;
    CdvSAL22Fonc := FALSE;
    CdvMON12Fonc := FALSE;
    CdvMON22Fonc := FALSE;
    CdvPDV12Fonc := FALSE;
    CdvPDV22Fonc := FALSE;

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

   ConfigEmisTeleSolTrain ( te11s28t01,
                            noBoucle1,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te14s28t02,
                            noBoucle2,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te16s28t03,
                            noBoucle3,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te21s28t04,
                            noBoucle4,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te24s28t05,
                            noBoucle5,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te26s28t06,
                            noBoucle6,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);


(* CONFIGURATION POUR LA REGULATION *)
   ConfigQuai (17, 74, CdvSAL12Fonc, te11s28t01, 0,  8,  3, 11, 10, 13, 14, 15);
   ConfigQuai (17, 79, CdvSAL22Fonc, te26s28t06, 0,  2,  8,  9,  4, 13, 14, 15);
   ConfigQuai (18, 64, CdvMON12Fonc, te14s28t02, 0,  3,  4,  5, 10, 13, 14, 15);
   ConfigQuai (18, 69, CdvMON22Fonc, te24s28t05, 0,  2,  8,  9,  4, 13, 14, 15);
   ConfigQuai (19, 84, CdvPDV12Fonc, te16s28t03, 0,  4, 11, 10,  6, 13, 14, 15);
   ConfigQuai (19, 89, CdvPDV22Fonc, te21s28t04, 0, 12,  8,  3,  9, 13, 14, 15);

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
   ProcEmisSolTrain( te11s28t01.EmissionSensUp, (2*noBoucle1), 
                     LigneL01+ L0128+ TRONC*01,

              PtArrCdvSAL12,
              PtArrCdvSAL13,
              PtArrCdvSAL14,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
(* Variants Anticipes *)
              PtArrCdvMON11,
              PtArrCdvMON12,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
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
   ProcEmisSolTrain( te14s28t02.EmissionSensUp, (2*noBoucle2), 
                     LigneL01+ L0128+ TRONC*02,

              PtArrCdvMON11,
              PtArrCdvMON12,
              PtArrCdvMON13,
              PtArrCdvMON14,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
(* Variants Anticipes *)
              PtArrCdvPDV11,
              PtArrCdvPDV12,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
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
   ProcEmisSolTrain( te16s28t03.EmissionSensUp, (2*noBoucle3), 
                     LigneL01+ L0128+ TRONC*03,

              PtArrCdvPDV11,
              PtArrCdvPDV12,
              PtArrCdvPDV13,
              PtArrCdvPDV14,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
(* Variants Anticipes *)
              PtAntCdvLEO11,
              PtAntCdvLEO12,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
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
   ProcEmisSolTrain( te21s28t04.EmissionSensUp, (2*noBoucle4), 
                     LigneL01+ L0128+ TRONC*04,

              PtArrCdvPDV23,
              PtArrCdvPDV22,
              PtArrCdvPDV21,
              PtArrCdvPDV20,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
(* Variants Anticipes *)
              PtArrCdvMON23,
              PtArrCdvMON22,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
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

(* variants du troncon 5 voie 2 <-- sp *)
   ProcEmisSolTrain( te24s28t05.EmissionSensUp, (2*noBoucle5), 
                     LigneL01+ L0128+ TRONC*05,

              PtArrCdvMON23,
              PtArrCdvMON22,
              PtArrCdvMON21,
              PtArrCdvMON20,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
(* Variants Anticipes *)
              PtArrCdvSAL23,
              PtArrCdvSAL22,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
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
   ProcEmisSolTrain( te26s28t06.EmissionSensUp, (2*noBoucle6), 
                     LigneL01+ L0128+ TRONC*06,

              PtArrCdvSAL23,
              PtArrCdvSAL22,
              PtArrCdvSAL21,
              PtAntCdvBAQ24,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
(* Variants Anticipes *)
              PtAntSigBAQ24,
              BoolRestrictif,       (* aspect croix *)
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
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
(* reception du secteur 29 -aval- *)

   ProcReceptInterSecteur(trL0129, noBoucletob, LigneL01+ L0129+ TRONC*01,
                  PtAntCdvLEO11,
                  PtAntCdvLEO12,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
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

(* reception du secteur 27 -amont- *)

   ProcReceptInterSecteur(trL0127, noBouclebaq, LigneL01+ L0127+ TRONC*03,

                  PtAntCdvBAQ24,
                  PtAntSigBAQ24,
                  BoolRestrictif,       (* aspect croix *)
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
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
(* emission vers le secteur 29 -aval- *)

   ProcEmisInterSecteur (teL0129, noBoucletob, LigneL01+ L0128+ TRONC*04,
			noBoucletob,
                  PtArrCdvPDV23,
                  PtArrCdvPDV22,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
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

(* emission vers le secteur 27 -amont- *)

   ProcEmisInterSecteur (teL0127, noBouclebaq, LigneL01+ L0128+ TRONC*01,
			noBouclebaq,
                  PtArrCdvSAL11,
                  PtArrCdvSAL12,
                  PtArrCdvSAL13,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
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
            

 (** Emission invariants vers secteur 29 aval L0129 **)

   EmettreSegm(LigneL01+ L0128+ TRONC*04+ SEGM*00, noBoucletob, SensUp);
                 
 (** Emission invariants vers secteur 27 amont L0127 **)

   EmettreSegm(LigneL01+ L0128+ TRONC*01+ SEGM*00, noBouclebaq, SensUp);
   EmettreSegm(LigneL01+ L0128+ TRONC*02+ SEGM*00, noBouclebaq, SensUp);


 (** Boucle 1 **)
   EmettreSegm(LigneL01+ L0128+ TRONC*01+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL01+ L0128+ TRONC*02+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL01+ L0128+ TRONC*03+ SEGM*00, noBoucle1, SensUp);

 (** Boucle 2 **)
   EmettreSegm(LigneL01+ L0128+ TRONC*02+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL01+ L0128+ TRONC*03+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL01+ L0129+ TRONC*01+ SEGM*00, noBoucle2, SensUp);

 (** Boucle 3 **)
   EmettreSegm(LigneL01+ L0128+ TRONC*03+ SEGM*00, noBoucle3, SensUp);
   EmettreSegm(LigneL01+ L0129+ TRONC*01+ SEGM*00, noBoucle3, SensUp);
   EmettreSegm(LigneL01+ L0129+ TRONC*02+ SEGM*00, noBoucle3, SensUp);

 (** Boucle 4 **)
   EmettreSegm(LigneL01+ L0128+ TRONC*04+ SEGM*00, noBoucle4, SensUp);
   EmettreSegm(LigneL01+ L0128+ TRONC*05+ SEGM*00, noBoucle4, SensUp);
   EmettreSegm(LigneL01+ L0128+ TRONC*06+ SEGM*00, noBoucle4, SensUp);

 (** Boucle 5 **)
   EmettreSegm(LigneL01+ L0128+ TRONC*05+ SEGM*00, noBoucle5, SensUp);
   EmettreSegm(LigneL01+ L0128+ TRONC*06+ SEGM*00, noBoucle5, SensUp);
   EmettreSegm(LigneL01+ L0128+ TRONC*06+ SEGM*01, noBoucle5, SensUp);
   EmettreSegm(LigneL01+ L0127+ TRONC*03+ SEGM*00, noBoucle5, SensUp);
  
 (** Boucle 6 **)
   EmettreSegm(LigneL01+ L0128+ TRONC*06+ SEGM*00, noBoucle6, SensUp);
   EmettreSegm(LigneL01+ L0128+ TRONC*06+ SEGM*01, noBoucle6, SensUp);
   EmettreSegm(LigneL01+ L0127+ TRONC*03+ SEGM*00, noBoucle6, SensUp);
   EmettreSegm(LigneL01+ L0127+ TRONC*04+ SEGM*00, noBoucle6, SensUp);

(*  *)

(************************* CONFIGURATION DES TRONCONS TSR **************************)

   ConfigurerTroncon(Tronc0, LigneL01 + L0128 + TRONC*01, 2,2,2,2);  (* troncon 28-1 *)
   ConfigurerTroncon(Tronc1, LigneL01 + L0128 + TRONC*02, 2,2,2,2);  (* troncon 28-2 *)
   ConfigurerTroncon(Tronc2, LigneL01 + L0128 + TRONC*03, 2,2,2,2);  (* troncon 28-3 *)
   ConfigurerTroncon(Tronc3, LigneL01 + L0128 + TRONC*04, 2,2,2,2);  (* troncon 28-4 *)
   ConfigurerTroncon(Tronc4, LigneL01 + L0128 + TRONC*05, 2,2,2,2);  (* troncon 28-5 *)
   ConfigurerTroncon(Tronc5, LigneL01 + L0128 + TRONC*06, 2,2,2,2);  (* troncon 28-6 *)


(************************************* EMISSION DES TSR **************************************)



(** Emission des TSR vers le secteur aval 29 L0129 **)

   EmettreTronc(LigneL01+ L0128+ TRONC*04, noBoucletob, SensUp);


(** Emission des TSR vers le secteur amont 27 L0127 **)

   EmettreTronc(LigneL01+ L0128+ TRONC*01, noBouclebaq, SensUp);
   EmettreTronc(LigneL01+ L0128+ TRONC*02, noBouclebaq, SensUp);


 (** Emission des TSR sur les troncons du secteur courant **)

   EmettreTronc(LigneL01+ L0128+ TRONC*01, noBoucle1, SensUp); (* troncon 28-1 *)
   EmettreTronc(LigneL01+ L0128+ TRONC*02, noBoucle1, SensUp);
   EmettreTronc(LigneL01+ L0128+ TRONC*03, noBoucle1, SensUp);


   EmettreTronc(LigneL01+ L0128+ TRONC*02, noBoucle2, SensUp); (* troncon 28-2 *)
   EmettreTronc(LigneL01+ L0128+ TRONC*03, noBoucle2, SensUp);
   EmettreTronc(LigneL01+ L0129+ TRONC*01, noBoucle2, SensUp);


   EmettreTronc(LigneL01+ L0128+ TRONC*03, noBoucle3, SensUp); (* troncon 28-3 *)
   EmettreTronc(LigneL01+ L0129+ TRONC*01, noBoucle3, SensUp);
   EmettreTronc(LigneL01+ L0129+ TRONC*02, noBoucle3, SensUp);


   EmettreTronc(LigneL01+ L0128+ TRONC*04, noBoucle4, SensUp); (* troncon 28-4 *)
   EmettreTronc(LigneL01+ L0128+ TRONC*05, noBoucle4, SensUp);
   EmettreTronc(LigneL01+ L0128+ TRONC*06, noBoucle4, SensUp);


   EmettreTronc(LigneL01+ L0128+ TRONC*05, noBoucle5, SensUp); (* troncon 28-5 *)
   EmettreTronc(LigneL01+ L0128+ TRONC*06, noBoucle5, SensUp);
   EmettreTronc(LigneL01+ L0127+ TRONC*03, noBoucle5, SensUp);


   EmettreTronc(LigneL01+ L0128+ TRONC*06, noBoucle6, SensUp); (* troncon 28-6 *)
   EmettreTronc(LigneL01+ L0127+ TRONC*03, noBoucle6, SensUp);
   EmettreTronc(LigneL01+ L0127+ TRONC*04, noBoucle6, SensUp);


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
    StockAdres( ADR( CdvSAL11));
    StockAdres( ADR( CdvSAL12));
    StockAdres( ADR( CdvSAL13));
    StockAdres( ADR( CdvSAL14A));
    StockAdres( ADR( CdvSAL14B));
    StockAdres( ADR( CdvMON11));
    StockAdres( ADR( CdvMON12));
    StockAdres( ADR( CdvMON13));
    StockAdres( ADR( CdvMON14));
    StockAdres( ADR( CdvPDV11));
    StockAdres( ADR( CdvPDV12));
    StockAdres( ADR( CdvPDV13));
    StockAdres( ADR( CdvPDV14));
    StockAdres( ADR( CdvPDV23));
    StockAdres( ADR( CdvPDV22));
    StockAdres( ADR( CdvPDV21));
    StockAdres( ADR( CdvPDV20));
    StockAdres( ADR( CdvMON23));
    StockAdres( ADR( CdvMON22));
    StockAdres( ADR( CdvMON21));
    StockAdres( ADR( CdvMON20B));
    StockAdres( ADR( CdvMON20A));
    StockAdres( ADR( CdvSAL23));
    StockAdres( ADR( CdvSAL22));
    StockAdres( ADR( CdvSAL21));

    StockAdres( ADR( PtArrCdvSAL11));
    StockAdres( ADR( PtArrCdvSAL12));
    StockAdres( ADR( PtArrCdvSAL13));
    StockAdres( ADR( PtArrCdvSAL14));
    StockAdres( ADR( PtArrCdvMON11));
    StockAdres( ADR( PtArrCdvMON12));
    StockAdres( ADR( PtArrCdvMON13));
    StockAdres( ADR( PtArrCdvMON14));
    StockAdres( ADR( PtArrCdvPDV11));
    StockAdres( ADR( PtArrCdvPDV12));
    StockAdres( ADR( PtArrCdvPDV13));
    StockAdres( ADR( PtArrCdvPDV14));
    StockAdres( ADR( PtArrCdvPDV23));
    StockAdres( ADR( PtArrCdvPDV22));
    StockAdres( ADR( PtArrCdvPDV21));
    StockAdres( ADR( PtArrCdvPDV20));
    StockAdres( ADR( PtArrCdvMON23));
    StockAdres( ADR( PtArrCdvMON22));
    StockAdres( ADR( PtArrCdvMON21));
    StockAdres( ADR( PtArrCdvMON20));
    StockAdres( ADR( PtArrCdvSAL23));
    StockAdres( ADR( PtArrCdvSAL22));
    StockAdres( ADR( PtArrCdvSAL21));

    StockAdres( ADR( PtAntCdvLEO11));
    StockAdres( ADR( PtAntCdvLEO12));
    StockAdres( ADR( PtAntCdvBAQ24));
    StockAdres( ADR( PtAntSigBAQ24));

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
   CdvSAL12Fonc := CdvSAL12.F = Vrai.F;
   CdvSAL22Fonc := CdvSAL22.F = Vrai.F;
   CdvMON12Fonc := CdvMON12.F = Vrai.F;
   CdvMON22Fonc := CdvMON22.F = Vrai.F;
   CdvPDV12Fonc := CdvPDV12.F = Vrai.F;
   CdvPDV22Fonc := CdvPDV22.F = Vrai.F;


(*  *)
(******************************* FILTRAGE DES AIGUILLES *******************************)

  (* pas d'aiguille *)

(************************** Gerer les point d'arrets **************************)

   AffectBoolD( CdvSAL11,                   PtArrCdvSAL11);
   AffectBoolD( CdvSAL12,                   PtArrCdvSAL12);
   AffectBoolD( CdvSAL13,                   PtArrCdvSAL13);
   EtDD(        CdvSAL14B,    CdvSAL14A,    PtArrCdvSAL14);
   AffectBoolD( CdvMON11,                   PtArrCdvMON11);
   AffectBoolD( CdvMON12,                   PtArrCdvMON12);
   AffectBoolD( CdvMON13,                   PtArrCdvMON13);
   AffectBoolD( CdvMON14,                   PtArrCdvMON14);
   AffectBoolD( CdvPDV11,                   PtArrCdvPDV11);
   AffectBoolD( CdvPDV12,                   PtArrCdvPDV12);
   AffectBoolD( CdvPDV13,                   PtArrCdvPDV13);
   AffectBoolD( CdvPDV14,                   PtArrCdvPDV14);

   AffectBoolD( CdvPDV23,                   PtArrCdvPDV23);
   AffectBoolD( CdvPDV22,                   PtArrCdvPDV22);
   AffectBoolD( CdvPDV21,                   PtArrCdvPDV21);
   AffectBoolD( CdvPDV20,                   PtArrCdvPDV20);
   AffectBoolD( CdvMON23,                   PtArrCdvMON23);
   AffectBoolD( CdvMON22,                   PtArrCdvMON22);
   AffectBoolD( CdvMON21,                   PtArrCdvMON21);
   EtDD(        CdvMON20A,    CdvMON20B,    PtArrCdvMON20);
   AffectBoolD( CdvSAL23,                   PtArrCdvSAL23);
   AffectBoolD( CdvSAL22,                   PtArrCdvSAL22);
   AffectBoolD( CdvSAL21,                   PtArrCdvSAL21);


(*** lecture des entrees de regulation ***)

   LireEntreesRegul;

END ExeSpecific;
END Specific.
