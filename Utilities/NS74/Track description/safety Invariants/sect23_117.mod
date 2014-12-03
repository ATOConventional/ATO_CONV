IMPLEMENTATION MODULE Specific;

(*$S- *)
(*$T- *)

(******************************************************************************
*   SANTIAGO - LIGNE 1 - Secteur 23
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
(* Date : 23/10/1997, Auteur: F. Chanier, Origine : -                        *)
(*                                                                           *)
(* Version 1.1.1                                                             *)
(* Date : 28/10/1997, Auteur: P. Hog    , Origine : Equipe dev.              *)
(*   Correction des anticipations et des damtc.                              *)
(*                                                                           *)
(* Version 1.1.2                                                             *)
(* Date : 23/01/1998, Auteur: F. Chanier , Origine : Equipe dev.             *)
(*   Detection des defaillances d'ampli.                                     *)   
(*                                                                           *)
(* Version 1.1.3                                                             *)
(* Date : 12/03/1998, Auteur: F. Chanier , Origine : Equipe dev.             *)
(*   mise en place des marches-type.                                         *)   
(*---------------------------------------------------------------------------*)

(*****************************************************************************)
(***            AJOUT DE LA NUMEROTATION SCCS DES VERSIONS                ****)
(*---------------------------------------------------------------------------*)
(* Version 1.1.4  =====================                                      *)
(* Version 1.6 DU SERVEUR SCCS =====================                         *)
(* Date :         10/09/1998                                                 *)
(* Auteur:        H. Le Roy                                                  *)
(* Modification : Fiche d'anomalie ba040998                                  *)
(*                Suite a un changement de vitesses maximales, mise a jour   *)
(*                des marches types                                          *)
(*---------------------------------------------------------------------------*)
(* Version 1.1.5  =====================                                      *)
(* Version 1.7 DU SERVEUR SCCS =====================                         *)
(* Date :         19/04/1999                                                 *)
(* Auteur:        H. Le Roy                                                  *)
(* Modification : Adaptation et modification de la configuration des amplis  *)
(*                 pour detecter les pannes de fusibles.Suppression de       *)
(*                 parties de code inutiles concernant les DAMTC.            *)
(*---------------------------------------------------------------------------*)
(* Version 1.1.6  =====================                                      *)
(* Version 1.8 DU SERVEUR SCCS =====================                         *)
(* Date :         06/06/2000                                                 *)
(* Auteur:        H. Le Roy                                                  *)
(* Modification : Am165 : modification des marches types                     *)
(*---------------------------------------------------------------------------*)
(* Version 1.1.7 =====================                                       *)
(* Version 1.9 DU SERVEUR SCCS =====================                         *)
(* Date :         07/08/2006                                                 *)
(* Auteur:        Rudy Nsiona                                                *)
(* Modification : Nouveau Train NS2004                                       *)
(* Procédure CONFIGURATION DES TRONCONS TSR                                  *)
(*                ancienne valeur 1 , nouvelle 2                             *)

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
             		Ampli15, Ampli16, Ampli17, Ampli18, Ampli1A, 
              		Ampli21, Ampli22, Ampli23, Ampli24,
              		Ampli25, Ampli26, Ampli27, Ampli28, Ampli2A,
 
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

    L0124  = 1024*24;    (* numero Secteur aval voie impaire decale de 2**10 *)

    L0123  = 1024*23;    (* numero Secteur local decale de 2**10 *)

    L0122  = 1024*22;    (* numero Secteur amont voie impaire decale de 2**10 *)


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
    noBouclecen = 00; 
    noBouclerej = 01; 
    noBouclefi = 02;
    noBoucle1 = 03;
    noBoucle2 = 04;

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

(* DECLARATION DES SINGULARITES DU SECTEUR 23 : dans les deux sens confondus *)


(* Declaration des variables correspondant a des entrees securitaires  *)
(*   - CDV et signaux                                                  *)
    CdvPDG11A,     (* entree  1, soit entree 0 de CES 02  *)
    CdvPDG11B,     (* entree  2, soit entree 1 de CES 02  *)
    CdvPDG12,      (* entree  3, soit entree 2 de CES 02  *)
    CdvPDG13,      (* entree  4, soit entree 3 de CES 02  *)
    CdvPDG14,      (* entree  5, soit entree 4 de CES 02  *)
    CdvUSA11,      (* entree  6, soit entree 5 de CES 02  *)
    CdvUSA12,      (* entree  7, soit entree 6 de CES 02  *)
    CdvUSA13,      (* entree  8, soit entree 7 de CES 02  *)

    CdvUSA23,      (* entree  9, soit entree 1 de CES 04  *)
    CdvUSA22,      (* entree 10, soit entree 2 de CES 04  *)
    CdvUSA21,      (* entree 11, soit entree 3 de CES 04  *)
    CdvPDG23,      (* entree 12, soit entree 6 de CES 04  *)
    CdvPDG22,      (* entree 13, soit entree 7 de CES 04  *)
    CdvPDG21B,     (* entree 14, soit entree 0 de CES 05  *)
    CdvPDG21A,     (* entree 15, soit entree 4 de CES 04  *)
    CdvPDG20       (* entree 16, soit entree 5 de CES 04  *)
             : BoolD;

(*   - aiguilles                                                       *)
    (* pas d'aiguille *)



(* Variables ne correspondant pas a une entree securitaire *)
(* Point d'arret *)
    PtArrCdvPDG11,
    PtArrCdvPDG12,
    PtArrCdvPDG13,
    PtArrCdvPDG14,
    PtArrCdvUSA11,
    PtArrCdvUSA12,
    PtArrCdvUSA13,

    PtArrCdvUSA23,
    PtArrCdvUSA22,
    PtArrCdvUSA21,
    PtArrCdvPDG23,
    PtArrCdvPDG22,
    PtArrCdvPDG21,
    PtArrCdvPDG20   : BoolD;

(* Variants anticipes *)
    PtAntCdvCEN10,
    PtAntSigCEN10,
    PtAntCdvECU22,
    PtAntCdvECU23   : BoolD;

(* Copie des entrees dans des variables fonctionnelles pour la regulation *)
    CdvPDG12Fonc,
    CdvPDG22Fonc,
    CdvUSA12Fonc,
    CdvUSA22Fonc     : BOOLEAN;

(** Voie d'emission SOL-TRAIN : deux sens confondus**)
    te11s23t01,
    te15s23t02           :TyEmissionTele;

(** Voie d'emission Inter-secteur deux voies confondues **)
    teL0124,
    teL0122	          :TyEmissionTele;

(** Voie de reception Inter-secteur deux voies confondues **)
    trL0124,
    trL0122               :TyCaracEntSec;


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
    ProcEntreeIntrins(  1, CdvPDG11A);
    ProcEntreeIntrins(  2, CdvPDG11B);
    ProcEntreeIntrins(  3, CdvPDG12);
    ProcEntreeIntrins(  4, CdvPDG13);
    ProcEntreeIntrins(  5, CdvPDG14);
    ProcEntreeIntrins(  6, CdvUSA11);
    ProcEntreeIntrins(  7, CdvUSA12);
    ProcEntreeIntrins(  8, CdvUSA13);
    ProcEntreeIntrins(  9, CdvUSA23);
    ProcEntreeIntrins( 10, CdvUSA22);
    ProcEntreeIntrins( 11, CdvUSA21);
    ProcEntreeIntrins( 12, CdvPDG23);
    ProcEntreeIntrins( 13, CdvPDG22);
    ProcEntreeIntrins( 14, CdvPDG21B);
    ProcEntreeIntrins( 15, CdvPDG21A);
    ProcEntreeIntrins( 16, CdvPDG20);


(* CONFIGURATION POUR LA MAINTENANCE de la transmission continue *)
   ConfigurerBoucle(Boucle1, 1);
   ConfigurerBoucle(Boucle2, 2);

   ConfigurerAmpli(Ampli11, 1, 1, 154, 11, FALSE);
   ConfigurerAmpli(Ampli12, 1, 2, 155, 12, FALSE);
   ConfigurerAmpli(Ampli13, 1, 3, 156, 12, FALSE); 
   ConfigurerAmpli(Ampli14, 1, 4, 157, 12, TRUE);
   ConfigurerAmpli(Ampli15, 1, 5, 158, 13, FALSE);
   ConfigurerAmpli(Ampli16, 1, 6, 159, 13, FALSE); 
   ConfigurerAmpli(Ampli17, 1, 7, 192, 13, TRUE);
   ConfigurerAmpli(Ampli18, 1, 8, 193, 14, FALSE); 
   ConfigurerAmpli(Ampli1A, 1, 10, 195, 14, TRUE); 

   ConfigurerAmpli(Ampli21, 2, 1, 196, 15, FALSE);
   ConfigurerAmpli(Ampli22, 2, 2, 197, 16, FALSE);
   ConfigurerAmpli(Ampli23, 2, 3, 198, 16, FALSE); 
   ConfigurerAmpli(Ampli24, 2, 4, 199, 16, TRUE);
   ConfigurerAmpli(Ampli25, 2, 5, 200, 17, FALSE);
   ConfigurerAmpli(Ampli26, 2, 6, 201, 17, FALSE); 
   ConfigurerAmpli(Ampli27, 2, 7, 202, 17, TRUE);
   ConfigurerAmpli(Ampli28, 2, 8, 203, 18, FALSE); 
   ConfigurerAmpli(Ampli2A, 2, 10, 205, 18, TRUE); 

 (** cartes CES **)
   ConfigurerCES(CarteCes1, 01);
   ConfigurerCES(CarteCes2, 02);


(** Liaisons Inter-Secteur **)

   ConfigurerIntsecteur(Intersecteur1, 01, trL0124, trL0122);


(* Initialisations des variables ne correspondant pas a des entrees secu *)
(* Point d'arret *)
    AffectBoolD( BoolRestrictif, PtArrCdvPDG11);
    AffectBoolD( BoolRestrictif, PtArrCdvPDG12);
    AffectBoolD( BoolRestrictif, PtArrCdvPDG13);
    AffectBoolD( BoolRestrictif, PtArrCdvPDG14);
    AffectBoolD( BoolRestrictif, PtArrCdvUSA11);
    AffectBoolD( BoolRestrictif, PtArrCdvUSA12);
    AffectBoolD( BoolRestrictif, PtArrCdvUSA13);
    AffectBoolD( BoolRestrictif, PtArrCdvUSA23);
    AffectBoolD( BoolRestrictif, PtArrCdvUSA22);
    AffectBoolD( BoolRestrictif, PtArrCdvUSA21);
    AffectBoolD( BoolRestrictif, PtArrCdvPDG23);
    AffectBoolD( BoolRestrictif, PtArrCdvPDG22);
    AffectBoolD( BoolRestrictif, PtArrCdvPDG21);
    AffectBoolD( BoolRestrictif, PtArrCdvPDG20);

(* Variants anticipes *)
    AffectBoolD( BoolRestrictif, PtAntCdvCEN10);
    AffectBoolD( BoolRestrictif, PtAntSigCEN10);
    AffectBoolD( BoolRestrictif, PtAntCdvECU22);
    AffectBoolD( BoolRestrictif, PtAntCdvECU23);

(* Copie des entrees dans des variables fonctionnelles pour la regulation *)
    CdvPDG12Fonc := FALSE;
    CdvPDG22Fonc := FALSE;
    CdvUSA12Fonc := FALSE;
    CdvUSA22Fonc := FALSE;

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

   ConfigEmisTeleSolTrain ( te11s23t01,
                            noBoucle1,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te15s23t02,
                            noBoucle2,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);


(* CONFIGURATION POUR LA REGULATION *)
   ConfigQuai ( 6, 64, CdvPDG12Fonc, te11s23t01, 0, 5, 10,  6,  7, 13, 14, 15);
   ConfigQuai ( 6, 69, CdvPDG22Fonc, te15s23t02, 0, 9, 11, 10,  6, 13, 14, 15);
   ConfigQuai ( 7, 74, CdvUSA12Fonc, te11s23t01, 0, 8,  3,  4, 11, 13, 14, 15);
   ConfigQuai ( 7, 79, CdvUSA22Fonc, te15s23t02, 0, 10, 6,  7,  7, 13, 14, 15);

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
   ProcEmisSolTrain( te11s23t01.EmissionSensUp, (2*noBoucle1), 
                     LigneL01+ L0123+ TRONC*01,

              PtArrCdvPDG11,
              PtArrCdvPDG12,
              PtArrCdvPDG13,
              PtArrCdvPDG14,
              PtArrCdvUSA11,
              PtArrCdvUSA12,
              PtArrCdvUSA13,
              BoolRestrictif,
(* Variants Anticipes *)
              PtAntCdvCEN10,
              PtAntSigCEN10,
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
              BoolPermissif,
              BaseSorVar);
(*  *)
(* variants troncon 2   voie 1 --> si  *)
   ProcEmisSolTrain( te15s23t02.EmissionSensUp, (2*noBoucle2), 
                     LigneL01+ L0123+ TRONC*02,

              PtArrCdvUSA23,
              PtArrCdvUSA22,
              PtArrCdvUSA21,
              PtArrCdvPDG23,
              PtArrCdvPDG22,
              PtArrCdvPDG21,
              PtArrCdvPDG20,
              BoolRestrictif,
(* Variants Anticipes *)
              PtAntCdvECU23,
              PtAntCdvECU22,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
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
(*  *)

(* reception du secteur 24 -aval- *)

   ProcReceptInterSecteur(trL0124, noBouclecen, LigneL01+ L0124+ TRONC*01,
                  PtAntCdvCEN10,
                  PtAntSigCEN10,
                  BoolRestrictif,         (* aspect croix *)
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
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

(* reception du secteur 22 -amont- *)

   ProcReceptInterSecteur(trL0122, noBouclerej, LigneL01+ L0122+ TRONC*04,

                  PtAntCdvECU23,
                  PtAntCdvECU22,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
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
(* emission vers le secteur 24 -aval- *)

   ProcEmisInterSecteur (teL0124, noBouclecen, LigneL01+ L0123+ TRONC*02,
			noBouclecen,
                  PtArrCdvUSA23,
                  PtArrCdvUSA22,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
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

(* emission vers le secteur 22 -amont- *)

   ProcEmisInterSecteur (teL0122, noBouclerej, LigneL01+ L0123+ TRONC*01,
			noBouclerej,
                  PtArrCdvPDG11,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
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
            

 (** Emission invariants vers secteur 24 aval L0124 **)

   EmettreSegm(LigneL01+ L0123+ TRONC*02+ SEGM*00, noBouclecen, SensUp);
   EmettreSegm(LigneL01+ L0123+ TRONC*02+ SEGM*01, noBouclecen, SensUp);
                 
 (** Emission invariants vers secteur 22 amont L0122 **)

   EmettreSegm(LigneL01+ L0123+ TRONC*01+ SEGM*00, noBouclerej, SensUp);
   EmettreSegm(LigneL01+ L0123+ TRONC*01+ SEGM*01, noBouclerej, SensUp);


 (** Boucle 1 **)
   EmettreSegm(LigneL01+ L0123+ TRONC*01+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL01+ L0123+ TRONC*01+ SEGM*01, noBoucle1, SensUp);
   EmettreSegm(LigneL01+ L0124+ TRONC*01+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL01+ L0124+ TRONC*02+ SEGM*00, noBoucle1, SensUp);

 (** Boucle 2 **)
   EmettreSegm(LigneL01+ L0123+ TRONC*02+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL01+ L0123+ TRONC*02+ SEGM*01, noBoucle2, SensUp);
   EmettreSegm(LigneL01+ L0122+ TRONC*04+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL01+ L0122+ TRONC*05+ SEGM*00, noBoucle2, SensUp);

(*  *)

(************************* CONFIGURATION DES TRONCONS TSR **************************)

   ConfigurerTroncon(Tronc0, LigneL01 + L0123 + TRONC*01, 2,2,2,2);  (* troncon 23-1 *)
   ConfigurerTroncon(Tronc1, LigneL01 + L0123 + TRONC*02, 2,2,2,2);  (* troncon 23-2 *)


(************************************* EMISSION DES TSR **************************************)



(** Emission des TSR vers le secteur aval 24 L0124 **)

   EmettreTronc(LigneL01+ L0123+ TRONC*02, noBouclecen, SensUp);


(** Emission des TSR vers le secteur amont 22 L0122 **)

   EmettreTronc(LigneL01+ L0123+ TRONC*01, noBouclerej, SensUp);


 (** Emission des TSR sur les troncons du secteur courant **)

   EmettreTronc(LigneL01+ L0123+ TRONC*01, noBoucle1, SensUp); (* troncon 23-1 *)
   EmettreTronc(LigneL01+ L0124+ TRONC*01, noBoucle1, SensUp);
   EmettreTronc(LigneL01+ L0124+ TRONC*02, noBoucle1, SensUp);


   EmettreTronc(LigneL01+ L0123+ TRONC*02, noBoucle2, SensUp); (* troncon 23-2 *)
   EmettreTronc(LigneL01+ L0122+ TRONC*04, noBoucle2, SensUp);
   EmettreTronc(LigneL01+ L0122+ TRONC*05, noBoucle2, SensUp);


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
    StockAdres( ADR( CdvPDG11A));
    StockAdres( ADR( CdvPDG11B));
    StockAdres( ADR( CdvPDG12));
    StockAdres( ADR( CdvPDG13));
    StockAdres( ADR( CdvPDG14));
    StockAdres( ADR( CdvUSA11));
    StockAdres( ADR( CdvUSA12));
    StockAdres( ADR( CdvUSA13));
    StockAdres( ADR( CdvUSA23));
    StockAdres( ADR( CdvUSA22));
    StockAdres( ADR( CdvUSA21));
    StockAdres( ADR( CdvPDG23));
    StockAdres( ADR( CdvPDG22));
    StockAdres( ADR( CdvPDG21A));
    StockAdres( ADR( CdvPDG21B));
    StockAdres( ADR( CdvPDG20));

    StockAdres( ADR( PtArrCdvPDG11));
    StockAdres( ADR( PtArrCdvPDG12));
    StockAdres( ADR( PtArrCdvPDG13));
    StockAdres( ADR( PtArrCdvPDG14));
    StockAdres( ADR( PtArrCdvUSA11));
    StockAdres( ADR( PtArrCdvUSA12));
    StockAdres( ADR( PtArrCdvUSA13));
    StockAdres( ADR( PtArrCdvUSA23));
    StockAdres( ADR( PtArrCdvUSA22));
    StockAdres( ADR( PtArrCdvUSA21));
    StockAdres( ADR( PtArrCdvPDG23));
    StockAdres( ADR( PtArrCdvPDG22));
    StockAdres( ADR( PtArrCdvPDG21));
    StockAdres( ADR( PtArrCdvPDG20));

    StockAdres( ADR( PtAntCdvCEN10));
    StockAdres( ADR( PtAntSigCEN10));
    StockAdres( ADR( PtAntCdvECU22));
    StockAdres( ADR( PtAntCdvECU23));

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

            ConfigurerTroncon(Tronc2,  0, 0,0,0,0) ;
            ConfigurerTroncon(Tronc3,  0, 0,0,0,0) ;
            ConfigurerTroncon(Tronc4,  0, 0,0,0,0) ;
            ConfigurerTroncon(Tronc5,  0, 0,0,0,0) ;
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
   CdvPDG12Fonc := CdvPDG12.F = Vrai.F;
   CdvPDG22Fonc := CdvPDG22.F = Vrai.F;
   CdvUSA12Fonc := CdvUSA12.F = Vrai.F;
   CdvUSA22Fonc := CdvUSA22.F = Vrai.F;



(*  *)
(******************************* FILTRAGE DES AIGUILLES *******************************)

  (* pas d'aiguille *)

(************************** Gerer les point d'arrets **************************)

   EtDD(        CdvPDG11A,    CdvPDG11B,    PtArrCdvPDG11);
   AffectBoolD( CdvPDG12,                   PtArrCdvPDG12);
   AffectBoolD( CdvPDG13,                   PtArrCdvPDG13);
   AffectBoolD( CdvPDG14,                   PtArrCdvPDG14);
   AffectBoolD( CdvUSA11,                   PtArrCdvUSA11);
   AffectBoolD( CdvUSA12,                   PtArrCdvUSA12);
   AffectBoolD( CdvUSA13,                   PtArrCdvUSA13);

   AffectBoolD( CdvUSA23,                   PtArrCdvUSA23);
   AffectBoolD( CdvUSA22,                   PtArrCdvUSA22);
   AffectBoolD( CdvUSA21,                   PtArrCdvUSA21);
   AffectBoolD( CdvPDG23,                   PtArrCdvPDG23);
   AffectBoolD( CdvPDG22,                   PtArrCdvPDG22);
   EtDD(        CdvPDG21B,    CdvPDG21A,    PtArrCdvPDG21);
   AffectBoolD( CdvPDG20,                   PtArrCdvPDG20);


(*** lecture des entrees de regulation ***)

   LireEntreesRegul;

END ExeSpecific;
END Specific.
