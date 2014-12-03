IMPLEMENTATION MODULE Specific;

(*$S- *)
(*$T- *)

(******************************************************************************
*   SANTIAGO - LIGNE 1 - Secteur 29
*  =============================
*  Version : SCCS 1.1.1
*  Date    : 16/07/1997
*  Auteur  : Marc Plywacz
*  Premiere Version
******************************************************************************)

(*---------------------------------------------------------------------------*)
(* Modifications :                                                           *)
(* -------------                                                             *)
(*                                                                           *)
(*  Date : 08/09/1997, Auteur: F. CHANIER, Origine : eq. dev suppre. damtc15 *)
(*                                                                           *)
(*  Date : 11/09/1997, Auteur: P. HOG    , Origine : equipe developpement    *)
(*    Correction des emissions inter-secteur.                                *)
(*    Modification de la commande de l'aiguille fictive "AigFictTOB14".      *)
(*                                                                           *)
(*  Date : 17/09/1997, Auteur : P. HOG     , Origine : Equipe developpement  *)
(*    Suppression des variables de boucles inter-secteur (inutiles).         *)
(*                                                                           *)
(* ========= Version 1.1.0 du 18/09/1997 =================================== *)
(*                                                                           *)
(* ========= Version 1.1.1 ================================================= *)
(*  Date : 24/09/1997, Auteur : P. HOG     , Origine : Equipe developpement  *)
(*    Modification des anticipations suite aux changements de vitesse.       *)
(*                                                                           *)
(* ========= version 1.1.2 du 13/10/1997 =================================== *)
(*  date : 13/10/1997, Auteur : F. Chanier, origine : fiche Gauvin 23        *)
(* correction des configurations de quai                                     *)
(*                                                                           *)
(* ========= version 1.1.3 du 23/01/1997 =================================== *)
(*  date : 23/01/1997, Auteur : F. Chanier, origine : eq.dev.                *)
(*    modification des detections de panne d'ampli                           *)
(*  date : 19/02/1997, Auteur : P. Hog    , origine : eq.dev.                *)
(*    Modification des marches types.                                        *)
(*    Ajout d'un point d'arret EP entree du quai Tobalaba voie1.             *)
(*    PtArrCdvTOB12 = CdvTOB12 ET ( CdvTOB13 OU aiguille deviee).            *)
(*---------------------------------------------------------------------------*)
(*****************************************************************************)
(***            AJOUT DE LA NUMEROTATION SCCS DES VERSIONS                ****)
(*---------------------------------------------------------------------------*)
(* Version 1.1.4  =====================                                      *)
(* Version 1.8 DU SERVEUR SCCS =====================                         *)
(* Date :         10/09/1998                                                 *)
(* Auteur:        H. Le Roy                                                  *)
(* Modification : Fiche d'anomalie ba040998                                  *)
(*                Suite a un changement de vitesses maximales, mise a jour   *)
(*                des marches types                                          *)
(*---------------------------------------------------------------------------*)
(* Version 1.1.5  =====================                                      *)
(* Version 1.9 DU SERVEUR SCCS =====================                         *)
(* Date :         19/04/1999                                                 *)
(* Auteur:        H. Le Roy                                                  *)
(* Modification : Adaptation et modification de la configuration des amplis  *)
(*                 pour detecter les pannes de fusibles.Suppression de       *)
(*                 parties de code inutiles concernant les DAMTC.            *)
(*---------------------------------------------------------------------------*)
(* Version 1.1.6  =====================                                      *)
(* Version 1.10 DU SERVEUR SCCS =====================                        *)
(* Date :         28/03/2000                                                 *)
(* Auteur:        H. Le Roy                                                  *)
(* Modification : Am dev032000-1 : Modif. de la gestion du SP : Ajout d'un   *)
(*                   point d'arret specifique entierement dedie au SP1,      *)
(*                   auparavant gere par le point d'arret sub. du 21A. Ce    *)
(*                   dernier devient inutile, car le cdv21A est deja gere,   *)
(*                   au niveau secu, par l'arret sub du 21B                  *)
(*---------------------------------------------------------------------------*)
(* Version 1.1.7  =====================                                      *)
(* Version 1.11 DU SERVEUR SCCS =====================                        *)
(* Date :         16/06/2000                                                 *)
(* Auteur:        H. Le Roy                                                  *)
(* Modification : Om Dev062000-2 : M.A.J technique de gestion des Sp         *)
(*        Suppression de l'aiguille fictive et son traitement. Ajout d'une   *)
(*          entree secu associee aux cdv 14, d'un point d'arret specifique,  *)
(*          et introduction d'une logique de bascule dans le traitement des  *)
(*          Sp afin de compenser la suppression de l'aiguille fictive.       *)
(*                                                                           *)
(*                Om Bo042000-2                                              *)
(*        Ajout d'une entree secu. associee aux cdv 15 de Tobalaba, et d'un  *)
(*          point d'arret subcantonne pour le proteger, suite a la           *)
(*          modification de decoupage et de signalisation.                   *)
(*                                                                           *)
(*                Am165                                                      *)
(*        Modification des marches types.                                    *)
(*                                                                           *)
(*---------------------------------------------------------------------------*)
(* Version 1.1.8  =====================                                      *)
(* Version 1.12 DU SERVEUR SCCS =====================                        *)
(* Date :         08/08/2006                                                 *)
(* Auteur:        Rudy Nsiona                                                *)
(* Modification : Nouveau Train NS2004                                       *)
(* Procédure CONFIGURATION DES TRONCONS TSR                                  *)
(*                ancienne valeur 1 , nouvelle 2                             *)
(*---------------------------------------------------------------------------*)
(* Version 1.1.9  =====================                                      *)
(* Version 1.13 DU SERVEUR SCCS =====================                        *)
(* Date :         18/12/2007                                                 *)
(* Auteur:        P.amsellem                                                 *)
(* Modification : tronçon 4                                                  *)
(* ajout variant PtArrSigTOB24,   tivcom = sigTOb24                          *)
(*---------------------------------------------------------------------------*)

(******************************  IMPORTATIONS  *******************************)

FROM SYSTEM     IMPORT ADR;

FROM Opel       IMPORT StockAdres, AffectBoolD, AffectBoolC, BoolC, BoolD, EtDD, CodeD, NonD,
		       Tvrai, FinBranche, FinArbre, AffectC, OuDD, BoolLD, FinsiSecu;

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
              		Ampli21, Ampli22, Ampli23,
              		Ampli31, Ampli32, Ampli33, Ampli34, Ampli35,
	                Ampli36, Ampli37, Ampli38,
          		Ampli41, Ampli42, Ampli43, Ampli44,
              		Ampli51, Ampli52, Ampli53, Ampli54, Ampli55,
              		Ampli61, Ampli62, Ampli63, Ampli64,
              		Ampli71, Ampli72, Ampli73, 

(* variables *)
                       Boucle1, Boucle2, Boucle3, Boucle4, Boucle5, Boucle6, Boucle7, BoucleFictive,
		       CarteCes1,  CarteCes2,  CarteCes3, CarteCes4, CarteCes5,
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

    L0130  = 1024*30;    (* numero Secteur aval voie impaire decale de 2**10 *)

    L0129  = 1024*29;    (* numero Secteur local decale de 2**10 *)

    L0128  = 1024*28;    (* numero Secteur amont voie impaire decale de 2**10 *)


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
    noBoucleesc = 00; 
    noBouclemon = 01; 
    noBouclefi = 02;
    noBoucle1 = 03;
    noBoucle2 = 04;
    noBoucle3 = 05;
    noBoucle4 = 06;
    noBoucle5 = 07;
    noBoucle6 = 08;
    noBoucle7 = 09;

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

(***************** DECLARATION DES VARIABLES GENERALES **********************)
 VAR

(* DECLARATION DES SINGULARITES DU SECTEUR 29 : dans les deux sens confondus *)


(* Declaration des variables correspondant a des entrees securitaires  *)
(*   - CDV et signaux                                                  *)
    CdvLEO11,      (* entree  1, soit entree 0 de CES 02  *)
    CdvLEO12,      (* entree  2, soit entree 1 de CES 02  *)
    CdvLEO13,      (* entree  3, soit entree 2 de CES 02  *)
    CdvTOB10,      (* entree  4, soit entree 3 de CES 02  *)
    SigTOB10,      (* entree  5, soit entree 4 de CES 02  *)
    SigTOB12kv,    (* entree  6, soit entree 5 de CES 02  *)
    SigTOB12kj,    (* entree  7, soit entree 6 de CES 02  *)
    CdvGOL11,      (* entree  8, soit entree 7 de CES 02  *)
    CdvGOL12,      (* entree  9, soit entree 0 de CES 03  *)
    CdvGOL13,      (* entree 10, soit entree 1 de CES 03  *)
    CdvGOL14,      (* entree 11, soit entree 2 de CES 03  *)
    CdvGOL24,      (* entree 12, soit entree 3 de CES 03  *)
    CdvGOL23,      (* entree 13, soit entree 4 de CES 03  *)
    CdvGOL22,      (* entree 14, soit entree 5 de CES 03  *)
    CdvGOL21,      (* entree 15, soit entree 6 de CES 03  *)
    CdvTOB24,      (* entree 16, soit entree 7 de CES 03  *)
    SigTOB24,      (* entree 17, soit entree 0 de CES 04  *)
    CdvTOB21B,     (* entree 18, soit entree 1 de CES 04  *)
    CdvTOB21A,     (* entree 19, soit entree 2 de CES 04  *)
    CdvTOB20,      (* entree 20, soit entree 3 de CES 04  *)
    CdvLEO23,      (* entree 21, soit entree 4 de CES 04  *)
    CdvLEO22,      (* entree 22, soit entree 5 de CES 04  *)
    CdvLEO21,      (* entree 23, soit entree 6 de CES 04  *)
    CdvLEO20,      (* entree 24, soit entree 7 de CES 04  *)
    Sp1TOB,        (* entree 25, soit entree 0 de CES 05  *)
    Sp2TOB,        (* entree 26, soit entree 1 de CES 05  *)
 (* pas utilisee *) (* entree 27, soit entree 2 de CES 05  *)
    SigTOB14,      (* entree 28, soit entree 3 de CES 05  *)
    SigTOB22,      (* entree 31, soit entree 6 de CES 05  *)
    CdvTOB11,      (* entree 32, soit entree 7 de CES 05  *)
    CdvTOB13,      (* entree 33, soit entree 0 de CES 06  *)
    CdvTOB23,      (* entree 34, soit entree 1 de CES 06  *)
    CdvTOB12,      (* entree 35, soit entree 2 de CES 06  *)
    CdvTOB22,      (* entree 36, soit entree 3 de CES 06  *)
    CdvTOB14,      (* entree 37, soit entree 4 de CES 06  *)
    CdvTOB15       (* entree 38, soit entree 5 de CES 06  *)
             : BoolD;

(*   - aiguilles                                                       *)
    AigTOB13       (* entrees 29 et 30, soit entrees 4 et 5 de CES 05  *)
             :TyAig;



(* Variables ne correspondant pas a une entree securitaire *)
(* Point d'arret *)
    PtArrCdvLEO11,
    PtArrCdvLEO12,
    PtArrCdvLEO13,
    PtArrCdvTOB10,
    PtArrSigTOB10,
    PtArrCdvTOB12,
    PtArrSigTOB12,
    PtArrCdvTOB15,
    PtArrSpeTOB15,
    PtArrCdvGOL11,
    PtArrCdvGOL12,
    PtArrCdvGOL13,
    PtArrCdvGOL14,

    PtArrCdvGOL24,
    PtArrCdvGOL23,
    PtArrCdvGOL22,
    PtArrCdvGOL21,
    PtArrCdvTOB24,
    PtArrSigTOB24,
    PtArrCdvTOB21,
 (* modif. du 28/3/2000 : modif. de la gestion du SP1 *)
    PtArrSpec21B,
 (*    PtArrCdvTOB21A, *)
    PtArrCdvTOB20,
    PtArrCdvLEO23,
    PtArrCdvLEO22,
    PtArrCdvLEO21,
    PtArrCdvLEO20,

    PtArrSigTOB14,
    PtArrSigTOB22  : BoolD;

(* Tiv Com non lies a une aiguille *)
    TivComTOB12    : BoolD;

(* Variants anticipes *)
    PtAntCdvALC11,
    PtAntCdvPDV23,
    PtAntCdvPDV22  : BoolD;

(* Copie des entrees dans des variables fonctionnelles pour la regulation *)
    CdvTOB12Fonc,
    CdvTOB22Fonc,
    CdvLEO12Fonc,
    CdvLEO22Fonc,
    CdvGOL12Fonc,
    CdvGOL22Fonc     : BOOLEAN;

(** Variables de memorisation des etats precedents des **)
(** cdv14 et SP2 de Tobalaba pour la gestion des Sp    **)
    NonCdv14old,
    Sp2old                : BoolD;

(** Voie d'emission SOL-TRAIN : deux sens confondus**)
    te11s29t01,
    te13s29t02,
    te15s29t03,
    te21s29t04,
    te23s29t05,
    te26s29t06,
    te31s29t07           :TyEmissionTele;

(** Voie d'emission Inter-secteur deux voies confondues **)
    teL0130,
    teL0128	          :TyEmissionTele;

(** Voie de reception Inter-secteur deux voies confondues **)
    trL0130,
    trL0128               :TyCaracEntSec;


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

DeclarerVersionSpecific (21);


(***************************** CONFIGURATIONS DIVERSES ****************************)

(* CONFIGURATION DES AIGUILLES, POUR LES DEUX VOIES *)
   EntreeAiguille( AigTOB13, 29, 30);   (* kag G = pos normale *)

(* Configuration des entrees *)
    ProcEntreeIntrins (  1, CdvLEO11);
    ProcEntreeIntrins (  2, CdvLEO12);
    ProcEntreeIntrins (  3, CdvLEO13);
    ProcEntreeIntrins (  4, CdvTOB10);
    ProcEntreeIntrins (  5, SigTOB10);
    ProcEntreeIntrins (  6, SigTOB12kv);
    ProcEntreeIntrins (  7, SigTOB12kj);
    ProcEntreeIntrins (  8, CdvGOL11);
    ProcEntreeIntrins (  9, CdvGOL12);
    ProcEntreeIntrins ( 10, CdvGOL13);
    ProcEntreeIntrins ( 11, CdvGOL14);
    ProcEntreeIntrins ( 12, CdvGOL24);
    ProcEntreeIntrins ( 13, CdvGOL23);
    ProcEntreeIntrins ( 14, CdvGOL22);
    ProcEntreeIntrins ( 15, CdvGOL21);
    ProcEntreeIntrins ( 16, CdvTOB24);
    ProcEntreeIntrins ( 17, SigTOB24);
    ProcEntreeIntrins ( 18, CdvTOB21B);
    ProcEntreeIntrins ( 19, CdvTOB21A);
    ProcEntreeIntrins ( 20, CdvTOB20);
    ProcEntreeIntrins ( 21, CdvLEO23);
    ProcEntreeIntrins ( 22, CdvLEO22);
    ProcEntreeIntrins ( 23, CdvLEO21);
    ProcEntreeIntrins ( 24, CdvLEO20);
    ProcEntreeIntrins ( 25, Sp1TOB);
    ProcEntreeIntrins ( 26, Sp2TOB);
    ProcEntreeIntrins ( 28, SigTOB14);
    ProcEntreeIntrins ( 31, SigTOB22);
    ProcEntreeIntrins ( 32, CdvTOB11);
    ProcEntreeIntrins ( 33, CdvTOB13);
    ProcEntreeIntrins ( 34, CdvTOB23);
    ProcEntreeIntrins ( 35, CdvTOB12);
    ProcEntreeIntrins ( 36, CdvTOB22);
    ProcEntreeIntrins ( 37, CdvTOB14);
    ProcEntreeIntrins ( 38, CdvTOB15);

(* CONFIGURATION POUR LA MAINTENANCE de la transmission continue *)
   ConfigurerBoucle(Boucle1, 1);
   ConfigurerBoucle(Boucle2, 2);
   ConfigurerBoucle(Boucle3, 3);
   ConfigurerBoucle(Boucle4, 4);
   ConfigurerBoucle(Boucle5, 5);
   ConfigurerBoucle(Boucle6, 6);
   ConfigurerBoucle(Boucle7, 7);

   ConfigurerAmpli(Ampli11, 1, 1, 154, 11, FALSE);
   ConfigurerAmpli(Ampli12, 1, 2, 155, 12, FALSE);
   ConfigurerAmpli(Ampli13, 1, 3, 156, 12, FALSE);
   ConfigurerAmpli(Ampli14, 1, 4, 157, 12, TRUE);  
   
   ConfigurerAmpli(Ampli21, 2, 1, 158, 13, FALSE);
   ConfigurerAmpli(Ampli22, 2, 2, 159, 14, FALSE);
   ConfigurerAmpli(Ampli23, 2, 3, 192, 14, TRUE);

   ConfigurerAmpli(Ampli31, 3, 1, 193, 15, FALSE);
   ConfigurerAmpli(Ampli32, 3, 2, 194, 16, FALSE);
   ConfigurerAmpli(Ampli33, 3, 3, 195, 16, FALSE);
   ConfigurerAmpli(Ampli34, 3, 4, 196, 16, TRUE);    
   ConfigurerAmpli(Ampli35, 3, 5, 197, 17, FALSE);
   ConfigurerAmpli(Ampli36, 3, 6, 198, 17, TRUE);
   ConfigurerAmpli(Ampli37, 3, 7, 199, 17, TRUE);
   ConfigurerAmpli(Ampli38, 3, 8, 200, 18, FALSE);  

   ConfigurerAmpli(Ampli41, 4, 1, 201, 21, FALSE);
   ConfigurerAmpli(Ampli42, 4, 2, 202, 22, FALSE);
   ConfigurerAmpli(Ampli43, 4, 3, 203, 22, FALSE);
   ConfigurerAmpli(Ampli44, 4, 4, 204, 22, TRUE);    

   ConfigurerAmpli(Ampli51, 5, 1, 205, 23, FALSE);
   ConfigurerAmpli(Ampli52, 5, 2, 206, 24, FALSE);
   ConfigurerAmpli(Ampli53, 5, 3, 207, 24, TRUE);
   ConfigurerAmpli(Ampli54, 5, 4, 208, 24, TRUE);        
   ConfigurerAmpli(Ampli55, 5, 5, 209, 25, FALSE);

   ConfigurerAmpli(Ampli61, 6, 1, 210, 26, FALSE);
   ConfigurerAmpli(Ampli62, 6, 2, 211, 27, FALSE);
   ConfigurerAmpli(Ampli63, 6, 3, 212, 27, FALSE);      
   ConfigurerAmpli(Ampli64, 6, 4, 213, 27, TRUE);        

   ConfigurerAmpli(Ampli71, 7, 1, 214, 31, FALSE);
   ConfigurerAmpli(Ampli72, 7, 2, 215, 32, FALSE);
   ConfigurerAmpli(Ampli73, 7, 3, 216, 32, TRUE);      


 (** cartes CES **)
   ConfigurerCES(CarteCes1, 01);
   ConfigurerCES(CarteCes2, 02);
   ConfigurerCES(CarteCes3, 03);
   ConfigurerCES(CarteCes4, 04);
   ConfigurerCES(CarteCes5, 05);


(** Liaisons Inter-Secteur **)

   ConfigurerIntsecteur(Intersecteur1, 01, trL0130, trL0128);


(* Initialisations des variables ne correspondant pas a des entrees secu *)
(* Point d'arret *)
    AffectBoolD( BoolRestrictif, PtArrCdvLEO11);
    AffectBoolD( BoolRestrictif, PtArrCdvLEO12);
    AffectBoolD( BoolRestrictif, PtArrCdvLEO13);
    AffectBoolD( BoolRestrictif, PtArrCdvTOB10);
    AffectBoolD( BoolRestrictif, PtArrSigTOB10);
    AffectBoolD( BoolRestrictif, PtArrCdvTOB12);
    AffectBoolD( BoolRestrictif, PtArrSigTOB12);
    AffectBoolD( BoolRestrictif, PtArrCdvTOB15);
    AffectBoolD( BoolPermissif, PtArrSpeTOB15);
    AffectBoolD( BoolRestrictif, PtArrCdvGOL11);
    AffectBoolD( BoolRestrictif, PtArrCdvGOL12);
    AffectBoolD( BoolRestrictif, PtArrCdvGOL13);
    AffectBoolD( BoolRestrictif, PtArrCdvGOL14);

    AffectBoolD( BoolRestrictif, PtArrCdvGOL24);
    AffectBoolD( BoolRestrictif, PtArrCdvGOL23);
    AffectBoolD( BoolRestrictif, PtArrCdvGOL22);
    AffectBoolD( BoolRestrictif, PtArrCdvGOL21);
    AffectBoolD( BoolRestrictif, PtArrCdvTOB24);
    AffectBoolD( BoolRestrictif, PtArrSigTOB24);
    AffectBoolD( BoolRestrictif, PtArrCdvTOB21);
 (* modif. du 28/3/2000 : modif. de la gestion du SP1 *)
    AffectBoolD( BoolPermissif,  PtArrSpec21B);
 (*   AffectBoolD( BoolRestrictif, PtArrCdvTOB21A); *)
    AffectBoolD( BoolRestrictif, PtArrCdvTOB20);
    AffectBoolD( BoolRestrictif, PtArrCdvLEO23);
    AffectBoolD( BoolRestrictif, PtArrCdvLEO22);
    AffectBoolD( BoolRestrictif, PtArrCdvLEO21);
    AffectBoolD( BoolRestrictif, PtArrCdvLEO20);

    AffectBoolD( BoolRestrictif, PtArrSigTOB14);
    AffectBoolD( BoolRestrictif, PtArrSigTOB22);

(* Tiv Com non lies a une aiguille *)
    AffectBoolD( BoolRestrictif, TivComTOB12);

(* Variants anticipes *)
    AffectBoolD( BoolRestrictif, PtArrCdvGOL24);
    AffectBoolD( BoolRestrictif, PtArrCdvGOL23);

(* Copie des entrees dans des variables fonctionnelles pour la regulation *)
    CdvTOB12Fonc := FALSE;
    CdvTOB22Fonc := FALSE;
    CdvLEO12Fonc := FALSE;  
    CdvLEO22Fonc := FALSE;
    CdvGOL12Fonc := FALSE;
    CdvGOL22Fonc := FALSE;

(** Variables de memorisation des etats precedents des **)
(** cdv14 et SP2 de Tobalaba pour la gestion des Sp    **)
    AffectBoolD( BoolPermissif, NonCdv14old);
    AffectBoolD( BoolPermissif, Sp2old);

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

   ConfigEmisTeleSolTrain ( te11s29t01,
                            noBoucle1,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te13s29t02,
                            noBoucle2,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te15s29t03,
                            noBoucle3,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te21s29t04,
                            noBoucle4,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te23s29t05,
                            noBoucle5,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te26s29t06,
                            noBoucle6,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te31s29t07,
                            noBoucle7,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);


(* CONFIGURATION POUR LA REGULATION *)
(* FC : modif quai le 13/10/1997 *)

   ConfigQuai (20, 74, CdvLEO12Fonc, te11s29t01, 0, 12,  8,  3,  9, 13, 14, 15);
   ConfigQuai (20, 79, CdvLEO22Fonc, te26s29t06, 0, 12,  2,  3,  3, 13, 14, 15);
   ConfigQuai (21, 64, CdvTOB12Fonc, te13s29t02, 0,  9, 11,  5,  6, 13, 14, 15);
   ConfigQuai (21, 69, CdvTOB22Fonc, te23s29t05, 0, 12,  8,  3,  9, 13, 14, 15);
   ConfigQuai (22, 84, CdvGOL12Fonc, te15s29t03, 0,  3,  4, 11,  5, 13, 14, 15);
   ConfigQuai (22, 89, CdvGOL22Fonc, te21s29t04, 0, 12,  8,  3,  9, 13, 14, 15);

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

(************ CONFIGURATION DES EMISSIONS DE VARIANTS SOL-TRAIN ************)

(* variants troncon 1   voie 1 --> si *)
   ProcEmisSolTrain( te11s29t01.EmissionSensUp, (2*noBoucle1), 
                     LigneL01+ L0129+ TRONC*01,

              PtArrCdvLEO11,
              PtArrCdvLEO12,
              PtArrCdvLEO13,
              PtArrCdvTOB10,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
(* Variants Anticipes *)
              PtArrSigTOB10,
              BoolRestrictif,             (* aspect croix *)
              PtArrCdvTOB12,
              BoolRestrictif,
              BoolRestrictif,
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
   ProcEmisSolTrain( te13s29t02.EmissionSensUp, (2*noBoucle2), 
                     LigneL01+ L0129+ TRONC*02,

              PtArrSigTOB10,
              BoolRestrictif,             (* aspect croix *)
              PtArrCdvTOB12,
              PtArrSigTOB12,
              BoolRestrictif,             (* aspect croix *)
              TivComTOB12,              (* tivcom *)
              BoolRestrictif,
              BoolRestrictif,
(* Variants Anticipes *)
              PtArrCdvTOB15,
              PtArrSpeTOB15,
              PtArrCdvGOL11,
              PtArrCdvGOL12,
              BoolRestrictif,
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


(* variants troncon 3    voie 1+2  ---> si  *)
   ProcEmisSolTrain( te15s29t03.EmissionSensUp, (2*noBoucle3), 
                     LigneL01+ L0129+ TRONC*03,

              PtArrCdvTOB15,
              PtArrSpeTOB15,
              PtArrCdvGOL11,
              PtArrCdvGOL12,
              PtArrCdvGOL13,
              PtArrCdvGOL14,
              PtArrSigTOB22,            (* seg 29.3.2 *)
              BoolRestrictif,             (* aspect croix *)
(* Variants Anticipes *)
              PtAntCdvALC11,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
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
   ProcEmisSolTrain( te21s29t04.EmissionSensUp, (2*noBoucle4), 
                     LigneL01+ L0129+ TRONC*04,
  
              PtArrCdvGOL23,
              PtArrCdvGOL22,
              PtArrCdvGOL21,
              PtArrSigTOB24,   (* tivcom = sigTOb24  *)
              PtArrCdvTOB24,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
(* Variants Anticipes *)
              PtArrSigTOB24,
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
              BaseSorVar + 90);


(* variants troncon 5  voie 2 <-- sp *)
   ProcEmisSolTrain( te23s29t05.EmissionSensUp, (2*noBoucle5), 
                     LigneL01+ L0129+ TRONC*05,

              PtArrSigTOB24,
              BoolRestrictif,             (* aspect croix *)
              PtArrCdvTOB21,
              PtArrSpec21B,
              PtArrCdvTOB20,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
(* Variants Anticipes *)
              PtArrCdvLEO23,
              PtArrCdvLEO22,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
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
(* variants troncon 6  voie 2 <-- sp *)
   ProcEmisSolTrain( te26s29t06.EmissionSensUp, (2*noBoucle6), 
                     LigneL01+ L0129+ TRONC*06,

              PtArrCdvLEO23,
              PtArrCdvLEO22,
              PtArrCdvLEO21,
              PtArrCdvLEO20,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
(* Variants Anticipes *)
              PtAntCdvPDV23,
              PtAntCdvPDV22,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
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


(* variants troncon 7  voie 2 <-- sp *)
   ProcEmisSolTrain( te31s29t07.EmissionSensUp, (2*noBoucle7), 
                     LigneL01+ L0129+ TRONC*07,

              PtArrSigTOB14,
              BoolRestrictif,             (* aspect croix *)
              AigTOB13.PosReverseFiltree,
              AigTOB13.PosNormaleFiltree,
              BoolRestrictif,            (* signal rouge fix2 fictif TOB2sig*)
              BoolRestrictif,             (* aspect croix *)
              BoolRestrictif,
              BoolRestrictif,
(* Variants Anticipes *)
              PtArrCdvTOB21,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
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

(*  *)
(* reception du secteur 30 -aval- *)

   ProcReceptInterSecteur(trL0130, noBoucleesc, LigneL01+ L0130+ TRONC*01,
                  PtAntCdvALC11,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
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

(* reception du secteur 28 -amont- *)

   ProcReceptInterSecteur(trL0128, noBouclemon, LigneL01+ L0128+ TRONC*04,

                  PtAntCdvPDV23,
                  PtAntCdvPDV22,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
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
(* emission vers le secteur 30 -aval- *)

   ProcEmisInterSecteur (teL0130, noBoucleesc, LigneL01+ L0129+ TRONC*04,
			noBoucleesc,
                  PtArrCdvGOL24,
                  PtArrCdvGOL23,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
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


(*  *)

(* emission vers le secteur 28 -amont- *)

   ProcEmisInterSecteur (teL0128, noBouclemon, LigneL01+ L0129+ TRONC*01,
			noBouclemon,
                  PtArrCdvLEO11,
                  PtArrCdvLEO12,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
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

(*********** CONFIGURATION DES EMISSION DES INVARIANTS SECURITAIRES ***********)

(* Tous les sens doivent etre a SensUp ; il n'y a pas de commutation *)


 (** Emission invariants vers secteur 30 aval L0130 **)

   EmettreSegm(LigneL01+ L0129+ TRONC*04+ SEGM*00, noBoucleesc, SensUp);
   EmettreSegm(LigneL01+ L0129+ TRONC*05+ SEGM*00, noBoucleesc, SensUp);

 (** Emission invariants vers secteur 28 amont L0128 **)

   EmettreSegm(LigneL01+ L0129+ TRONC*01+ SEGM*00, noBouclemon, SensUp);
   EmettreSegm(LigneL01+ L0129+ TRONC*02+ SEGM*00, noBouclemon, SensUp);


 (** Boucle 1 **)
   EmettreSegm(LigneL01+ L0129+ TRONC*01+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL01+ L0129+ TRONC*02+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL01+ L0129+ TRONC*03+ SEGM*00, noBoucle1, SensUp);

 (** Boucle 2 **)
   EmettreSegm(LigneL01+ L0129+ TRONC*02+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL01+ L0129+ TRONC*03+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL01+ L0129+ TRONC*03+ SEGM*01, noBoucle2, SensUp);
   EmettreSegm(LigneL01+ L0130+ TRONC*01+ SEGM*00, noBoucle2, SensUp);

 (** Boucle 3 **)
   EmettreSegm(LigneL01+ L0129+ TRONC*03+ SEGM*00, noBoucle3, SensUp);
   EmettreSegm(LigneL01+ L0129+ TRONC*03+ SEGM*01, noBoucle3, SensUp);
   EmettreSegm(LigneL01+ L0129+ TRONC*03+ SEGM*02, noBoucle3, SensUp);
   EmettreSegm(LigneL01+ L0129+ TRONC*07+ SEGM*00, noBoucle3, SensUp);
   EmettreSegm(LigneL01+ L0130+ TRONC*01+ SEGM*00, noBoucle3, SensUp);
   EmettreSegm(LigneL01+ L0130+ TRONC*01+ SEGM*01, noBoucle3, SensUp);

 (** Boucle 4 **)
   EmettreSegm(LigneL01+ L0129+ TRONC*04+ SEGM*00, noBoucle4, SensUp);
   EmettreSegm(LigneL01+ L0129+ TRONC*05+ SEGM*00, noBoucle4, SensUp);
   EmettreSegm(LigneL01+ L0129+ TRONC*05+ SEGM*01, noBoucle4, SensUp);
   EmettreSegm(LigneL01+ L0129+ TRONC*06+ SEGM*00, noBoucle4, SensUp);

 (** Boucle 5 **)
   EmettreSegm(LigneL01+ L0129+ TRONC*05+ SEGM*00, noBoucle5, SensUp);
   EmettreSegm(LigneL01+ L0129+ TRONC*05+ SEGM*01, noBoucle5, SensUp);
   EmettreSegm(LigneL01+ L0129+ TRONC*05+ SEGM*02, noBoucle5, SensUp);
   EmettreSegm(LigneL01+ L0129+ TRONC*06+ SEGM*00, noBoucle5, SensUp);
   EmettreSegm(LigneL01+ L0129+ TRONC*06+ SEGM*01, noBoucle5, SensUp);
   EmettreSegm(LigneL01+ L0129+ TRONC*03+ SEGM*02, noBoucle5, SensUp);
   EmettreSegm(LigneL01+ L0128+ TRONC*04+ SEGM*00, noBoucle5, SensUp);

 (** Boucle 6 **)
   EmettreSegm(LigneL01+ L0129+ TRONC*06+ SEGM*01, noBoucle6, SensUp);
   EmettreSegm(LigneL01+ L0128+ TRONC*04+ SEGM*00, noBoucle6, SensUp);

 (** Boucle 7 **)
   EmettreSegm(LigneL01+ L0129+ TRONC*07+ SEGM*00, noBoucle7, SensUp);
   EmettreSegm(LigneL01+ L0129+ TRONC*05+ SEGM*00, noBoucle7, SensUp);
   EmettreSegm(LigneL01+ L0129+ TRONC*05+ SEGM*01, noBoucle7, SensUp);
   EmettreSegm(LigneL01+ L0129+ TRONC*05+ SEGM*02, noBoucle7, SensUp);
   EmettreSegm(LigneL01+ L0129+ TRONC*02+ SEGM*00, noBoucle7, SensUp);

(*  *)

(*************************** CONFIGURATION DES TRONCONS TSR **************************)

   ConfigurerTroncon(Tronc0, LigneL01 + L0129 + TRONC*01, 2,2,2,2);  (* troncon 29-1 *)
   ConfigurerTroncon(Tronc1, LigneL01 + L0129 + TRONC*02, 2,2,2,2);  (* troncon 29-2 *)
   ConfigurerTroncon(Tronc2, LigneL01 + L0129 + TRONC*03, 2,2,2,2);  (* troncon 29-3 *)
   ConfigurerTroncon(Tronc3, LigneL01 + L0129 + TRONC*04, 2,2,2,2);  (* troncon 29-4 *)
   ConfigurerTroncon(Tronc4, LigneL01 + L0129 + TRONC*05, 2,2,2,2);  (* troncon 29-5 *)
   ConfigurerTroncon(Tronc5, LigneL01 + L0129 + TRONC*06, 2,2,2,2);  (* troncon 29-6 *)
   ConfigurerTroncon(Tronc6, LigneL01 + L0129 + TRONC*07, 2,2,2,2);  (* troncon 29-7 *)


(************************************** EMISSION DES TSR *************************************)



(** Emission des TSR vers le secteur aval 30 L0130 **)

   EmettreTronc(LigneL01+ L0129+ TRONC*04, noBoucleesc, SensUp);
   EmettreTronc(LigneL01+ L0129+ TRONC*05, noBoucleesc, SensUp);


(** Emission des TSR vers le secteur amont 28 L0128 **)

   EmettreTronc(LigneL01+ L0129+ TRONC*01, noBouclemon, SensUp);
   EmettreTronc(LigneL01+ L0129+ TRONC*02, noBouclemon, SensUp);



 (** Emission des TSR sur les troncons du secteur courant **)

   EmettreTronc(LigneL01+ L0129+ TRONC*01, noBoucle1, SensUp); (* troncon 29-1 *)
   EmettreTronc(LigneL01+ L0129+ TRONC*02, noBoucle1, SensUp);
   EmettreTronc(LigneL01+ L0129+ TRONC*03, noBoucle1, SensUp);


   EmettreTronc(LigneL01+ L0129+ TRONC*02, noBoucle2, SensUp); (* troncon 29-2 *)
   EmettreTronc(LigneL01+ L0129+ TRONC*03, noBoucle2, SensUp);
   EmettreTronc(LigneL01+ L0130+ TRONC*01, noBoucle2, SensUp);


   EmettreTronc(LigneL01+ L0129+ TRONC*03, noBoucle3, SensUp); (* troncon 29-3 *)
   EmettreTronc(LigneL01+ L0129+ TRONC*07, noBoucle3, SensUp);
   EmettreTronc(LigneL01+ L0130+ TRONC*01, noBoucle3, SensUp);


   EmettreTronc(LigneL01+ L0129+ TRONC*04, noBoucle4, SensUp); (* troncon 29-4 *)
   EmettreTronc(LigneL01+ L0129+ TRONC*05, noBoucle4, SensUp);
   EmettreTronc(LigneL01+ L0129+ TRONC*06, noBoucle4, SensUp);


   EmettreTronc(LigneL01+ L0129+ TRONC*05, noBoucle5, SensUp); (* troncon 29-5 *)
   EmettreTronc(LigneL01+ L0129+ TRONC*06, noBoucle5, SensUp);
   EmettreTronc(LigneL01+ L0129+ TRONC*03, noBoucle5, SensUp);
   EmettreTronc(LigneL01+ L0128+ TRONC*04, noBoucle5, SensUp);


   EmettreTronc(LigneL01+ L0129+ TRONC*06, noBoucle6, SensUp); (* troncon 29-6 *)
   EmettreTronc(LigneL01+ L0128+ TRONC*04, noBoucle6, SensUp);


   EmettreTronc(LigneL01+ L0129+ TRONC*07, noBoucle7, SensUp); (* troncon 29-7 *)
   EmettreTronc(LigneL01+ L0129+ TRONC*05, noBoucle7, SensUp);
   EmettreTronc(LigneL01+ L0129+ TRONC*02, noBoucle7, SensUp);


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
    StockAdres( ADR( CdvLEO11));
    StockAdres( ADR( CdvLEO12));
    StockAdres( ADR( CdvLEO13));
    StockAdres( ADR( CdvTOB10));
    StockAdres( ADR( SigTOB10));
    StockAdres( ADR( SigTOB12kv));
    StockAdres( ADR( SigTOB12kj));
    StockAdres( ADR( CdvGOL11));
    StockAdres( ADR( CdvGOL12));
    StockAdres( ADR( CdvGOL13));
    StockAdres( ADR( CdvGOL14));
    StockAdres( ADR( CdvGOL24));
    StockAdres( ADR( CdvGOL23));
    StockAdres( ADR( CdvGOL22));
    StockAdres( ADR( CdvGOL21));
    StockAdres( ADR( CdvTOB24));
    StockAdres( ADR( SigTOB24));
    StockAdres( ADR( CdvTOB21B));
    StockAdres( ADR( CdvTOB21A));
    StockAdres( ADR( CdvTOB20));
    StockAdres( ADR( CdvLEO23));
    StockAdres( ADR( CdvLEO22));
    StockAdres( ADR( CdvLEO21));
    StockAdres( ADR( CdvLEO20));
    StockAdres( ADR( Sp1TOB));
    StockAdres( ADR( Sp2TOB));
    StockAdres( ADR( SigTOB14));
    StockAdres( ADR( SigTOB22));
    StockAdres( ADR( CdvTOB11));
    StockAdres( ADR( CdvTOB13));
    StockAdres( ADR( CdvTOB23));
    StockAdres( ADR( CdvTOB12));
    StockAdres( ADR( CdvTOB22));
    StockAdres( ADR( CdvTOB14));
    StockAdres( ADR( CdvTOB15));

    StockAdres( ADR( AigTOB13));

    StockAdres( ADR( PtArrCdvLEO11));
    StockAdres( ADR( PtArrCdvLEO12));
    StockAdres( ADR( PtArrCdvLEO13));
    StockAdres( ADR( PtArrCdvTOB10));
    StockAdres( ADR( PtArrSigTOB10));
    StockAdres( ADR( PtArrCdvTOB12));
    StockAdres( ADR( PtArrSigTOB12));
    StockAdres( ADR( PtArrCdvTOB15));
    StockAdres( ADR( PtArrSpeTOB15));
    StockAdres( ADR( PtArrCdvGOL11));
    StockAdres( ADR( PtArrCdvGOL12));
    StockAdres( ADR( PtArrCdvGOL13));
    StockAdres( ADR( PtArrCdvGOL14));
    StockAdres( ADR( PtArrCdvGOL24));
    StockAdres( ADR( PtArrCdvGOL23));
    StockAdres( ADR( PtArrCdvGOL22));
    StockAdres( ADR( PtArrCdvGOL21));
    StockAdres( ADR( PtArrCdvTOB24));
    StockAdres( ADR( PtArrSigTOB24));
    StockAdres( ADR( PtArrCdvTOB21));
 (* modif. du 28/3/2000 : modif. de la gestion du SP1 *)
    StockAdres( ADR( PtArrSpec21B));
 (*    StockAdres( ADR( PtArrCdvTOB21A));*)
    StockAdres( ADR( PtArrCdvTOB20));
    StockAdres( ADR( PtArrCdvLEO23));
    StockAdres( ADR( PtArrCdvLEO22));
    StockAdres( ADR( PtArrCdvLEO21));
    StockAdres( ADR( PtArrCdvLEO20));
    StockAdres( ADR( PtArrSigTOB14));
    StockAdres( ADR( PtArrSigTOB22));

    StockAdres( ADR( TivComTOB12));

    StockAdres( ADR( PtAntCdvALC11));
    StockAdres( ADR( PtAntCdvPDV23));
    StockAdres( ADR( PtAntCdvPDV22));

    StockAdres( ADR( NonCdv14old));
    StockAdres( ADR( Sp2old));

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
VAR BoolTr,
    Reset, Set, NonReset  : BoolLD;

BEGIN (* ExeSpecific *)

(* Affectation des "constantes" utilisees dans la construction des messages emis    *)
(* et recus sur les boucles de transmission continue et sur les liens intersecteur. *)
(* Cette reaffectation est necessaire a chaque cycle pour la mise en securite.      *)
   AffectBoolC(Vrai, BoolPermissif)  ;
   AffectBoolC(Faux, BoolRestrictif) ;

(* regulation *)
  CdvTOB12Fonc := CdvTOB12.F = Vrai.F;
  CdvTOB22Fonc := CdvTOB22.F = Vrai.F;
  CdvLEO12Fonc := CdvLEO12.F = Vrai.F;
  CdvLEO22Fonc := CdvLEO22.F = Vrai.F;
  CdvGOL12Fonc := CdvGOL12.F = Vrai.F;
  CdvGOL22Fonc := CdvGOL22.F = Vrai.F;



(*  *)
(*********************************** FILTRAGE DES AIGUILLES ******************************)

   FiltrerAiguille( AigTOB13, BaseExeAig);

(******************* Gerer les Tiv Com non lies a une aiguille ****************)

   AffectBoolD( SigTOB12kv,                 TivComTOB12);

(************************** Gerer les point d'arrets **************************)

(* V1 *)
   AffectBoolD( CdvLEO11,                   PtArrCdvLEO11);
   AffectBoolD( CdvLEO12,                   PtArrCdvLEO12);
   AffectBoolD( CdvLEO13,                   PtArrCdvLEO13);
   AffectBoolD( CdvTOB10,                   PtArrCdvTOB10);
   AffectBoolD( SigTOB10,                   PtArrSigTOB10);

   OuDD(        CdvTOB13, AigTOB13.PosReverseFiltree, BoolTr);
   EtDD(        BoolTr,   CdvTOB12,         PtArrCdvTOB12);

   OuDD(        SigTOB12kv,   SigTOB12kj,   PtArrSigTOB12);
   AffectBoolD( CdvTOB15,                   PtArrCdvTOB15);
   AffectBoolD( CdvGOL11,                   PtArrCdvGOL11);
   AffectBoolD( CdvGOL12,                   PtArrCdvGOL12);
   AffectBoolD( CdvGOL13,                   PtArrCdvGOL13);
   AffectBoolD( CdvGOL14,                   PtArrCdvGOL14);

(* V2 *)
   AffectBoolD( CdvGOL24,                   PtArrCdvGOL24);
   AffectBoolD( CdvGOL23,                   PtArrCdvGOL23);
   AffectBoolD( CdvGOL22,                   PtArrCdvGOL22);
   AffectBoolD( CdvGOL21,                   PtArrCdvGOL21);
   AffectBoolD( CdvTOB24,                   PtArrCdvTOB24);
   AffectBoolD( SigTOB24,                   PtArrSigTOB24);
   EtDD(        CdvTOB21B,    CdvTOB21A,    PtArrCdvTOB21);
   AffectBoolD( CdvTOB20,                   PtArrCdvTOB20);
   AffectBoolD( CdvLEO23,                   PtArrCdvLEO23);
   AffectBoolD( CdvLEO22,                   PtArrCdvLEO22);
   AffectBoolD( CdvLEO21,                   PtArrCdvLEO21);
   AffectBoolD( CdvLEO20,                   PtArrCdvLEO20);

(* Sp *)
(*  modif du 28/3/2000 : modif. de la gestion du SP1           *)
   NonD(        Sp1TOB,       PtArrSpec21B);   
(*   NonD(        Sp1TOB,       BoolTr);                       *)
(*   EtDD(        CdvTOB21A,    BoolTr,       PtArrCdvTOB21A); *)

 (* Reset = Cdv14*Sp2 + Cdv14*Sp1*Aig13R                      *)
 (* Le point d'arret est demande restrictif si le cdv14 est   *)
 (* libre et le Sp2 est demande, ou si le cdv14 est libre et  *)
 (* le Sp1 est est demande et l'aiguille est passe en reverse *)
   EtDD(  AigTOB13.PosReverseFiltree,   Sp1TOB,     Reset );
   OuDD(  Reset,                        Sp2TOB,     Reset );
   EtDD(  Reset,                        CdvTOB14,   Reset );


 (* Set = Cdv14*non(Cdv14Prec) + Cdv14*Sp2Prec*non(Sp2)      *)
 (* Le point d'arret est demande permissif si le cdv14 est   *)
 (* libere, ou si le Sp2 est abandonne et le cdv14 est libre *)
   NonD(  Sp2TOB,   Set );
   EtDD(  Set,      Sp2old,      Set );
   OuDD(  Set,      NonCdv14old, Set );
   EtDD(  Set,      CdvTOB14,    Set );


 (* EtatArrSpe14 = EtatArrSpe14Prec*non(Reset) + Set             *)
 (* Set demande la mise a permissif du point d'arret.            *)
 (* Reset demande la mise a restrictif du point d'arret.         *)
 (* Set et Reset peuvent prendre la meme valeur. Cette equation  *)
 (* permet de regler ces conflits ou indeterminations :          *)
 (* - Si Set=Reset=1, le Set est prioritaire et le point d'arret *)
 (*   reste ou devient permissif.                                *)
 (* - Si Set=Reset=0, le point d'arret conserve le meme etat     *)
 (*   qu'au cycle precedent.                                     *) 
   NonD(  Reset,           NonReset );
   EtDD(  PtArrSpeTOB15,   NonReset,       PtArrSpeTOB15);
   OuDD(  PtArrSpeTOB15,   Set,            PtArrSpeTOB15);

 (* On memorise certains etats pour les calculs au cycle suivant *)
   NonD( CdvTOB14, NonCdv14old );
   AffectBoolD( Sp2TOB, Sp2old );

(* Contresens *)
   AffectBoolD( SigTOB14,                   PtArrSigTOB14);
   AffectBoolD( SigTOB22,                   PtArrSigTOB22);


(*** lecture des entrees de regulation ***)

   LireEntreesRegul;

END ExeSpecific;
END Specific.
