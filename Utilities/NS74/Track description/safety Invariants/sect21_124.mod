IMPLEMENTATION MODULE Specific;

(*$S- *)
(*$T- *)

(******************************************************************************
*   SANTIAGO - LIGNE 1 - Secteur 21
*  =============================
*  Version : SCCS 1.0
*  Date    : 29/04/1997
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
(* Version 1.1.1 =====================                                       *)
(* Date : 05/12/1997, Auteur: F. Chanier, Origine : Fiche gauvin 69          *)
(*   ajout de l'emission des segments et LTV 21.2.3 et 22.1.0 dans boucle 1. *)
(*                                                                           *)
(* Version 1.1.2 =====================                                       *)
(* Date : 24/12/1997, Auteur: F. Chanier, Origine : Equipe developpement     *)
(*   rajout de l'emission sur tronc. 4 et utilisation de PtArrCdvPAB12.      *)
(*  Calcul de son etat comme un OU(de l'aiguille 23 deviee et de PAB13) puis *)
(*  un ET entre cette derniere et le cdvPAB12                                *)
(*                                                                           *)
(* Version 1.1.3 =====================                                       *)
(* Date : 23/01/1998, Auteur: F. Chanier, Origine : Equipe developpement     *)
(*   detection des defaillances d'ampli.                                     *)
(*                                                                           *)
(* Version 1.1.4 =====================                                       *)
(* Date : 12/03/1998, Auteur: F. Chanier, Origine : Eq. dev                  *)
(* mise en place des marches type                                            *)  
(*                                                                           *)
(* Version 1.1.5 =====================                                       *)
(* Date : 15/06/1998, Auteur: F. Chanier, Origine : Eq. dev                  *)
(* tivcom sur signal 10 commande suivnat la position de la'iguille 11        *)
(*---------------------------------------------------------------------------*)
(*****************************************************************************)

(*****************************************************************************)
(***            AJOUT DE LA NUMEROTATION SCCS DES VERSIONS                ****)
(*---------------------------------------------------------------------------*)
(* Version 1.1.6  =====================                                      *)
(* Version 1.7 DU SERVEUR SCCS =====================                         *)
(* Date :         09/09/1998                                                 *)
(* Auteur:        H. Le Roy                                                  *)
(* Modification : Fiche d'anomalie ba040998                                  *)
(*                Suite a un changement de vitesses maximales, mise a jour   *)
(*                des marches types                                          *)
(*---------------------------------------------------------------------------*)
(* Version 1.1.7  =====================                                      *)
(* Version 1.8 DU SERVEUR SCCS =====================                         *)
(* Date :         03/12/1998                                                 *)
(* Auteur:        H. Le Roy                                                  *)
(* Modification : Emission segment 21.6.0 et troncon 21.6 pour retournement  *)
(*                 14-22-24                                                  *)
(*---------------------------------------------------------------------------*)
(* Version 1.1.8  =====================                                      *)
(* Version 1.9 DU SERVEUR SCCS =====================                         *)
(* Date :         16/04/1999                                                 *)
(* Auteur:        H. Le Roy                                                  *)
(* Modification : Adaptation et modification de la configuration des amplis  *)
(*                 pour detecter les pannes de fusibles.Suppression de       *)
(*                 parties de code inutiles concernant les DAMTC.            *)
(*---------------------------------------------------------------------------*)
(* Version 1.1.9  =====================                                      *)
(* Version 1.10 DU SERVEUR SCCS =====================                        *)
(* Date :         27/06/2000                                                 *)
(* Auteur:        H. Le Roy                                                  *)
(* Modification : AM165 : Configuration des marches types                    *)
(*---------------------------------------------------------------------------*)
(* Version 1.2.0  =====================                                      *)
(* Version 1.11 DU SERVEUR SCCS =====================                        *)
(* Date :         05/07/2001                                                 *)
(* Auteur:        S. Perea                                                   *)
(* Modification : Modif pour diminuer le temps de retournement en terminus   *)
(* Le segment 21.1.1 doit etre inclus dans le message du troncon 21.4        *)
(*---------------------------------------------------------------------------*)
(* Version 1.2.1  =====================                                      *)
(* Version 1.12 DU SERVEUR SCCS =====================                        *)
(* Date :         08/08/2006                                                 *)
(* Auteur:        Rudy Nsiona                                                *)
(* Modification : Nouveau Train NS2004                                       *)
(* Procédure CONFIGURATION DES TRONCONS TSR                                  *)
(*                ancienne valeur 1 , nouvelle 2                             *)
(*---------------------------------------------------------------------------*)
(* Version 1.2.2  =====================                                      *)
(* Version 1.13 DU SERVEUR SCCS =====================                        *)
(* Date :         07/05/2009                                                 *)
(* Auteur:        Ph. Hog                                                    *)
(* Modification : Modification de l'entrée aux ateliers de Neptuno.          *)
(* Procédure "InitSpecDivers"                                                *)
(*                Ajout des ampli des 2 nouvelles CEF                        *)
(* Procédure "ExecSecifique"                                                 *)
(*   inhibition du TIVCom PAB20 quand l'aiguille 19B est en position normale *)
(*---------------------------------------------------------------------------*)
(* Version 1.2.3  =====================                                      *)
(* Version 1.14 DU SERVEUR SCCS =====================                        *)
(* Date :         04/06/2009                                                 *)
(* Auteur:        Marc plywacz                                               *)
(* Modification : sortie des ateliers de Neptuno.                            *)
(* ajout aiguille 19B dans les variants du troncon 22.5                      *)
(* modification des conditions des "PtArrSigPAB38A" et "PtArrSigPAB38A"      *)
(* ajout EmettreSegm 22.1.1 sur noBoucle2                                    *)
(*---------------------------------------------------------------------------*)
(* Version 1.2.4  =====================                                      *)
(* Version 1.15 DU SERVEUR SCCS =====================                        *)
(* Date :         02/07/2010                                                 *)
(* Auteur:        Ph. Hog                                                    *)
(* Modification : sortie des ateliers de Neptuno.                            *)
(*   ALPHA 00172785, Remplacement de la varianble PtAntCdvPAJ11 par la       *)
(*                   variable PtAntCdvPAJ10                                  *)
(*   Correction de la surveillance des emetteurs (DamTc)                     *)
(*---------------------------------------------------------------------------*)

(******************************  IMPORTATIONS  *******************************)

FROM SYSTEM     IMPORT ADR;

FROM Opel       IMPORT StockAdres, AffectBoolD, AffectBoolC, BoolC, BoolD, EtDD, CodeD, NonD,
		       Tvrai, FinBranche, FinArbre, AffectC, OuDD, BoolLD;

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

                   Ampli11, Ampli12, Ampli13, Ampli14, Ampli15, Ampli16, Ampli17,
                   Ampli21, Ampli22, Ampli23, Ampli24, Ampli25, Ampli26, Ampli27,
                   Ampli28, (* Ampli29, *) Ampli2A,
        	       Ampli31, Ampli32, Ampli33, Ampli34, Ampli35,
        	       Ampli41, Ampli42, Ampli43, Ampli44, Ampli45,
        	       Ampli51, Ampli52, Ampli53, Ampli54, Ampli55, Ampli56, Ampli57,
                   (* Ampli58, *) Ampli59,
        	       Ampli61, Ampli62, Ampli63, Ampli64, Ampli65,



(* variables *)
                       Boucle1, Boucle2, Boucle3, Boucle4, Boucle5, Boucle6,
		       BoucleFictive,
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

    L0122  = 1024*22;    (* numero Secteur aval voie impaire decale de 2**10 *)

    L0121  = 1024*21;    (* numero Secteur local decale de 2**10 *)

 (*   L01xx  = 1024*xx; *)   (* numero Secteur amont voie impaire decale de 2**10 *)

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
    noBouclepaj = 00; 
 (*   noBouclexxx = 01; *)
    noBouclefi = 02; (* boucle fictive *)
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

(* DECLARATION DES SINGULARITES DU SECTEUR 21 : dans les deux sens confondus *)

(* Declaration des variables correspondant a des entrees securitaires  *)
(*   - CDV et signaux                                                  *)
    SigPAB24,      (* entree  1, soit entree 0 de CES 02  *)
    SigPAB14,      (* entree  2, soit entree 1 de CES 02  *)
    SigPAB22A,     (* entree  5, soit entree 4 de CES 02  *)
    SigPAB20kv,    (* entree  6, soit entree 5 de CES 02  *)
    SigPAB20kj,    (* entree  7, soit entree 6 de CES 02  *)
    CdvPAB17,      (* entree 10, soit entree 1 de CES 03  *)
    CdvPAB16,      (* entree 11, soit entree 2 de CES 03  *)
    CdvPAB07,      (* entree 12, soit entree 3 de CES 03  *)
    CdvPAB08,      (* entree 13, soit entree 4 de CES 03  *)
    SigPAB08kv,    (* entree 14, soit entree 5 de CES 03  *)
    SigPAB08kj,    (* entree 15, soit entree 6 de CES 03  *)
    SigPAB09,      (* entree 18, soit entree 1 de CES 04  *)
    SigPAB10kv,    (* entree 19, soit entree 2 de CES 04  *)
    SigPAB10kj,    (* entree 20, soit entree 3 de CES 04  *)
    SigPAB12,      (* entree 23, soit entree 6 de CES 04  *)
 (* res R.Fix v2 *) (* entree 24, soit entree 7 de CES 04  *)
    SigPAB22B,     (* entree 25, soit entree 0 de CES 05  *)
 (* res R.Fix v1 *) (* entree 26, soit entree 1 de CES 05  *)
    SigPABzA,      (* entree 27, soit entree 2 de CES 05  *)
    SigPABzB,      (* entree 28, soit entree 3 de CES 05  *)
    CdvPAB09,      (* entree 29, soit entree 4 de CES 05  *)
    CdvPAB13,      (* entree 30, soit entree 5 de CES 05  *)
    SigPAB38A,     (* entree 31, soit entree 6 de CES 05  *)
    SigPAB58A,     (* entree 32, soit entree 7 de CES 05  *)
    SigPAB38B,     (* entree 35, soit entree 2 de CES 06  *)
    SigPAB58B,     (* entree 36, soit entree 3 de CES 06  *)
    CdvPAB22,      (* entree 37, soit entree 4 de CES 06  *)
    CdvPAB12,      (* entree 38, soit entree 5 de CES 06  *)
    CdvPAB18       (* entree 39, soit entree 6 de CES 06  *)
             : BoolD;

(*   - aiguilles                                                       *)
    AigPAB23,      (* entrees  3 et  4, soit entrees 2 et 3 de CES 02  *)
    AigPAB19B,     (* entrees  8 et  9, soit entrees 7 et 0 de CES 02 et 03 *)
    AigPAB09,      (* entrees 16 et 17, soit entrees 7 et 0 de CES 03 et 04 *)
    AigPAB11,      (* entrees 21 et 22, soit entrees 4 et 5 de CES 04  *)
    AigPAB19C      (* entrees 33 et 34, soit entrees 0 et 1 de CES 06  *)
             :TyAig;



(* Variables ne correspondant pas a une entree securitaire *)
(* Point d'arret *)
    PtArrSigPAB14,
    PtArrSigPAB24,
    PtArrSigPAB22A,
    PtArrSigPAB20,
    PtArrCdvPAB17,
    PtArrCdvPAB16,
    PtArrSigPABzA,

    PtArrCdvPAB07,
    PtArrCdvPAB08,
    PtArrSigPAB08,
    PtArrSigPAB09,
    PtArrSigPAB10,
    PtArrCdvPAB12,
    PtArrSigPAB12,
    PtArrSigPAB22B,
    PtArrSigPABzB,

    PtArrSigPAB38A,
    PtArrSigPAB58A : BoolD;

(* Tiv Com non lies a une aiguille *)
    TivComPAB20,
    TivComPAB08    : BoolD;
(*    TivComPAB10    : BoolD; *)

(* Variants anticipes *)
    PtAntCdvPAJ10  : BoolD;

(* Copie des entrees dans des variables fonctionnelles pour la regulation *)
    CdvPAB22Fonc,
    CdvPAB18Fonc,
    CdvPAB08Fonc     : BOOLEAN;

(** Voie d'emission SOL-TRAIN : deux sens confondus**)
    te11s21t01,
    te15s21t02,
    te21s21t03,
    te24s21t04,
    te31s21t05,
    te34s21t06           :TyEmissionTele;
    	 			


(** Voie d'emission Inter-secteur deux voies confondues **)
    teL0122,
(*    teL0120, *)
    teL01fi	          :TyEmissionTele;

(** Voie de reception Inter-secteur deux voies confondues **)
    trL0122,
 (*   trL0120, *)
    trL01fi               :TyCaracEntSec;


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
    EntreeAiguille( AigPAB23,   3,  4);  (* kag G = pos normale *)
    EntreeAiguille( AigPAB19B,  8,  9);  (* kag G = pos normale *)
    EntreeAiguille( AigPAB09,  17, 16);  (* kag D = pos normale *)
    EntreeAiguille( AigPAB11,  22, 21);  (* kag D = pos normale *)
    EntreeAiguille( AigPAB19C,  33, 34);  (* kag G = pos normale *)

(* Configuration des entrees *)
    ProcEntreeIntrins(  1, SigPAB24);
    ProcEntreeIntrins(  2, SigPAB14);
    ProcEntreeIntrins(  5, SigPAB22A);
    ProcEntreeIntrins(  6, SigPAB20kv);
    ProcEntreeIntrins(  7, SigPAB20kj);
    ProcEntreeIntrins( 10, CdvPAB17);
    ProcEntreeIntrins( 11, CdvPAB16);
    ProcEntreeIntrins( 12, CdvPAB07);
    ProcEntreeIntrins( 13, CdvPAB08);
    ProcEntreeIntrins( 14, SigPAB08kv);
    ProcEntreeIntrins( 15, SigPAB08kj);
    ProcEntreeIntrins( 18, SigPAB09);
    ProcEntreeIntrins( 19, SigPAB10kv);
    ProcEntreeIntrins( 20, SigPAB10kj);
    ProcEntreeIntrins( 23, SigPAB12);
    ProcEntreeIntrins( 25, SigPAB22B);
    ProcEntreeIntrins( 27, SigPABzA);
    ProcEntreeIntrins( 28, SigPABzB);
    ProcEntreeIntrins( 29, CdvPAB09);
    ProcEntreeIntrins( 30, CdvPAB13);
    ProcEntreeIntrins( 31, SigPAB38A);
    ProcEntreeIntrins( 32, SigPAB58A);
    ProcEntreeIntrins( 35, SigPAB38B);
    ProcEntreeIntrins( 36, SigPAB58B);
    ProcEntreeIntrins( 37, CdvPAB22);
    ProcEntreeIntrins( 38, CdvPAB12);
    ProcEntreeIntrins( 39, CdvPAB18);


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
   ConfigurerAmpli(Ampli15, 1, 5, 158, 13, FALSE);
   ConfigurerAmpli(Ampli16, 1, 6, 159, 13, FALSE);
   ConfigurerAmpli(Ampli17, 1, 7, 192, 13, TRUE);   

   ConfigurerAmpli(Ampli21, 2, 1, 193, 15, FALSE);
   ConfigurerAmpli(Ampli22, 2, 2, 194, 16, FALSE);
   ConfigurerAmpli(Ampli23, 2, 3, 195, 16, FALSE);   
   ConfigurerAmpli(Ampli24, 2, 4, 196, 16, TRUE);
   ConfigurerAmpli(Ampli25, 2, 5, 197, 17, FALSE); 
   ConfigurerAmpli(Ampli26, 2, 6, 198, 17, FALSE); 
   ConfigurerAmpli(Ampli27, 2, 7, 199, 17, TRUE);  
   ConfigurerAmpli(Ampli28, 2, 8, 256, 18, FALSE);
   ConfigurerAmpli(Ampli2A, 2, 9, 258, 18, TRUE);

   ConfigurerAmpli(Ampli31, 3, 1, 200, 21, FALSE);
   ConfigurerAmpli(Ampli32, 3, 2, 201, 22, FALSE);
   ConfigurerAmpli(Ampli33, 3, 3, 202, 22, FALSE);   
   ConfigurerAmpli(Ampli34, 3, 4, 203, 22, TRUE);
   ConfigurerAmpli(Ampli35, 3, 5, 204, 23, FALSE); 
                                               
   ConfigurerAmpli(Ampli41, 4, 1, 205, 24, FALSE);
   ConfigurerAmpli(Ampli42, 4, 2, 206, 25, FALSE);
   ConfigurerAmpli(Ampli43, 4, 3, 207, 25, TRUE);   
   ConfigurerAmpli(Ampli44, 4, 4, 208, 25, TRUE);
   ConfigurerAmpli(Ampli45, 4, 5, 209, 23, FALSE); 

   ConfigurerAmpli(Ampli51, 5, 1, 210, 31, FALSE);
   ConfigurerAmpli(Ampli52, 5, 2, 211, 32, FALSE);
   ConfigurerAmpli(Ampli53, 5, 3, 212, 32, FALSE);   
   ConfigurerAmpli(Ampli54, 5, 4, 213, 32, TRUE);
   ConfigurerAmpli(Ampli55, 5, 5, 214, 33, FALSE); 
   ConfigurerAmpli(Ampli56, 5, 6, 215, 33, FALSE); 
   ConfigurerAmpli(Ampli57, 5, 7, 259, 36, FALSE);
   ConfigurerAmpli(Ampli59, 5, 8, 261, 36, TRUE);

   ConfigurerAmpli(Ampli61, 6, 1, 216, 34, FALSE);
   ConfigurerAmpli(Ampli62, 6, 2, 217, 35, FALSE);
   ConfigurerAmpli(Ampli63, 6, 3, 218, 35, FALSE);   
   ConfigurerAmpli(Ampli64, 6, 4, 219, 35, TRUE);
   ConfigurerAmpli(Ampli65, 6, 5, 220, 33, TRUE); 

(* Ampli29 indiqué pour mémoire. La sortie DAMTC82 est raccordée    *)
(* à la CID 3 mais les amplis 2 et 3 de la CEF ne sont pas utilisés *)
   ConfigurerAmpli(Ampli28, 2, 8, 256, 18, FALSE);
(*   ConfigurerAmpli(Ampli29, 2, 9, 257, 18, FALSE); *)
   ConfigurerAmpli(Ampli2A, 2, 10, 258, 18, TRUE);  

(* Ampli58 indiqué pour mémoire. La sortie DAMTC62 est raccordée    *)
(* à la CID 3 mais les amplis 2 et 3 de la CEF ne sont pas utilisés *)
   ConfigurerAmpli(Ampli57, 5, 7, 259, 36, FALSE);
(*   ConfigurerAmpli(Ampli58, 5, 8, 260, 36, FALSE); *)
   ConfigurerAmpli(Ampli59, 5, 9, 261, 36, TRUE);  

 (** cartes CES **)
   ConfigurerCES(CarteCes1, 01);
   ConfigurerCES(CarteCes2, 02);
   ConfigurerCES(CarteCes3, 03);
   ConfigurerCES(CarteCes4, 04);
   ConfigurerCES(CarteCes5, 05);


(** Liaisons Inter-Secteur **)

   ConfigurerIntsecteur(Intersecteur1, 01, trL0122, trL01fi);


(* Initialisations des variables ne correspondant pas a des entrees secu *)
(* Point d'arret *)
    AffectBoolD( BoolRestrictif, PtArrSigPAB14);
    AffectBoolD( BoolRestrictif, PtArrSigPAB24);
    AffectBoolD( BoolRestrictif, PtArrSigPAB22A);
    AffectBoolD( BoolRestrictif, PtArrSigPAB20);
    AffectBoolD( BoolRestrictif, PtArrCdvPAB17);
    AffectBoolD( BoolRestrictif, PtArrCdvPAB16);
    AffectBoolD( BoolRestrictif, PtArrSigPABzA);
    AffectBoolD( BoolRestrictif, PtArrCdvPAB07);
    AffectBoolD( BoolRestrictif, PtArrCdvPAB08);
    AffectBoolD( BoolRestrictif, PtArrSigPAB08);
    AffectBoolD( BoolRestrictif, PtArrSigPAB09);
    AffectBoolD( BoolRestrictif, PtArrSigPAB10);
    AffectBoolD( BoolRestrictif, PtArrCdvPAB12);
    AffectBoolD( BoolRestrictif, PtArrSigPAB12);
    AffectBoolD( BoolRestrictif, PtArrSigPAB22B);
    AffectBoolD( BoolRestrictif, PtArrSigPABzB);
    AffectBoolD( BoolRestrictif, PtArrSigPAB38A);
    AffectBoolD( BoolRestrictif, PtArrSigPAB58A);

(* Tiv Com non lies a une aiguille *)
    AffectBoolD( BoolRestrictif, TivComPAB20);
    AffectBoolD( BoolRestrictif, TivComPAB08);
(*    AffectBoolD( BoolRestrictif, TivComPAB10); *)

(* Variants anticipes *)
    AffectBoolD( BoolRestrictif, PtAntCdvPAJ10);

(* regulation *)
    CdvPAB22Fonc := FALSE;
    CdvPAB18Fonc := FALSE;
    CdvPAB08Fonc := FALSE;

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

(********************* CONFIGURATION DES VOIES D'EMISSION *********************)

   ConfigEmisTeleSolTrain ( te11s21t01,
                            noBoucle1,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te15s21t02,
                            noBoucle2,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te21s21t03,
                            noBoucle3,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te24s21t04,
                            noBoucle4,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te31s21t05,
                            noBoucle5,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te34s21t06,
                            noBoucle6,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);


(* CONFIGURATION POUR LA REGULATION *)
   ConfigQuai ( 1, 64, CdvPAB22Fonc, te11s21t01, 0,  5, 10,  6, 7, 13, 14, 15);
   ConfigQuai ( 2, 74, CdvPAB18Fonc, te15s21t02, 0,  8,  9, 11, 5, 13, 14, 15);
   ConfigQuai ( 2, 79, CdvPAB08Fonc, te21s21t03, 0, 12,  6,  7, 7, 13, 14, 15);

END InitSpecConfMess;
(* *)
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

(************** CONFIGURATION DES EMISSIONS DE VARIANTS SOL-TRAIN *************)


(* variants troncon 1   voies 2 - 1 --> si *)
   ProcEmisSolTrain( te11s21t01.EmissionSensUp, (2*noBoucle1),
                     LigneL01+ L0121+ TRONC*01,

                  PtArrSigPAB14,
                  BoolRestrictif,             (* aspect croix *)
                  PtArrSigPAB24,
                  BoolRestrictif,             (* aspect croix *)
                  PtArrSigPAB22A,
                  BoolRestrictif,             (* aspect croix *)
                  BoolRestrictif,
                  BoolRestrictif,
(* Variants Anticipes *)
                  PtArrSigPAB20,
                  BoolRestrictif,             (* aspect croix *)
                  TivComPAB20,                (* TivCom *)
                  AigPAB19B.PosReverseFiltree,
                  AigPAB19B.PosNormaleFiltree,
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
   ProcEmisSolTrain( te15s21t02.EmissionSensUp, (2*noBoucle2), 
                     LigneL01+ L0121+ TRONC*02,

                  PtArrSigPAB20,
                  BoolRestrictif,             (* aspect croix *)
                  TivComPAB20,                (* TivCom *)
                  AigPAB19B.PosReverseFiltree,
                  AigPAB19B.PosNormaleFiltree,
                  PtArrCdvPAB17,
                  PtArrCdvPAB16,
                  PtArrSigPABzA,
                  BoolRestrictif,             (* aspect croix *)
                  AigPAB19C.PosReverseFiltree,
                  AigPAB19C.PosNormaleFiltree,
                  BoolRestrictif,     (* Signal 58B considere rouge fix *)
                  BoolRestrictif,             (* aspect croix *)
                  BoolRestrictif,     (* Signal 38B considere rouge fix *)
                  BoolRestrictif,             (* aspect croix *)
(* Variants Anticipes *)
                  PtAntCdvPAJ10,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolPermissif,
                  BaseSorVar + 30);


(* variants troncon 3    voie 2  sp  *)
   ProcEmisSolTrain( te21s21t03.EmissionSensUp, (2*noBoucle3), 
                     LigneL01+ L0121+ TRONC*03,

                  PtArrCdvPAB07,
                  PtArrCdvPAB08,
                  PtArrSigPAB08,
                  BoolRestrictif,             (* aspect croix *)
                  TivComPAB08,                (* TivCom *)
                  AigPAB09.PosReverseFiltree,
                  AigPAB09.PosNormaleFiltree,
                  PtArrSigPAB09,
                  BoolRestrictif,             (* aspect croix *)
(* Variants Anticipes *)
                  PtArrSigPAB10,
                  BoolRestrictif,             (* aspect croix *)
                  AigPAB11.PosNormaleFiltree,                (* TivCom *)
                  AigPAB11.PosReverseFiltree,
                  AigPAB11.PosNormaleFiltree,
                  PtArrSigPABzB,
                  BoolRestrictif,             (* aspect croix *)
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
   ProcEmisSolTrain( te24s21t04.EmissionSensUp, (2*noBoucle4), 
                     LigneL01+ L0121+ TRONC*04,

                  PtArrSigPAB10,
                  BoolRestrictif,             (* aspect croix *)
                  AigPAB11.PosNormaleFiltree,                (* TivCom *)
                  AigPAB11.PosReverseFiltree,
                  AigPAB11.PosNormaleFiltree,
		  PtArrCdvPAB12,
                  PtArrSigPAB12,
                  BoolRestrictif,             (* aspect croix *)
                  BoolRestrictif,             (* sig Rouge fix V2 *)
                  BoolRestrictif,             (* aspect croix *)
(* Variants Anticipes *)
                  PtArrSigPAB22B,
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
                  BoolPermissif,
                  BaseSorVar + 90);


(* variants du troncon 5 voie 1 <-- sp *)
   ProcEmisSolTrain( te31s21t05.EmissionSensUp, (2*noBoucle5), 
                     LigneL01+ L0121+ TRONC*05,

                  PtArrSigPAB58A,
                  BoolRestrictif,             (* aspect croix *)
                  PtArrSigPAB38A,
                  BoolRestrictif,             (* aspect croix *)
                  AigPAB19B.PosReverseFiltree,
                  AigPAB19B.PosNormaleFiltree,
                  PtArrSigPABzB,
                  BoolRestrictif,             (* aspect croix *)
(* Variants Anticipes *)
                  PtArrSigPAB10,
                  BoolRestrictif,             (* aspect croix *)
                  AigPAB11.PosNormaleFiltree,                (* TivCom *)
                  AigPAB11.PosReverseFiltree,
                  AigPAB11.PosNormaleFiltree,
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
(* variants troncon 6  voie 1 <-- sp *)
   ProcEmisSolTrain( te34s21t06.EmissionSensUp, (2*noBoucle6), 
                     LigneL01+ L0121+ TRONC*06,

                  PtArrSigPAB22B,
                  BoolRestrictif,             (* aspect croix *)
                  AigPAB23.PosReverseFiltree,
                  AigPAB23.PosNormaleFiltree,
                  BoolRestrictif,             (* sig Rouge fix V1 *)
                  BoolRestrictif,             (* aspect croix *)
                  BoolRestrictif,
                  BoolRestrictif,
(* Variants Anticipes *)
                  BoolRestrictif,             (* sig Rouge fix V2 *)
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
                  BaseSorVar + 150);

(* *)
(* reception du secteur 22 -aval- *)

   ProcReceptInterSecteur(trL0122, noBouclepaj, LigneL01+ L0122+ TRONC*01,
                  PtAntCdvPAJ10,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
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


(* reception du secteur 20 -amont- inexistant *)

(* *)
(* emission vers le secteur 22 -aval- *)

   ProcEmisInterSecteur (teL0122, noBouclepaj, LigneL01+ L0121+ TRONC*03,
                        noBouclepaj,
                  PtArrCdvPAB07,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
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

(* emission vers le secteur 20 -amont- inexistant *)


END InSpecMessVar;
(* *)
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


 (** Emission invariants vers secteur 22 aval L0122 **)

   EmettreSegm(LigneL01+ L0121+ TRONC*03+ SEGM*00, noBouclepaj, SensUp);
   EmettreSegm(LigneL01+ L0121+ TRONC*03+ SEGM*01, noBouclepaj, SensUp);

 (** Emission invariants vers secteur 20 amont L0120 **)

 (* pas de secteur amont *)


 (** Boucle 1 **)
   EmettreSegm(LigneL01+ L0121+ TRONC*01+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL01+ L0121+ TRONC*01+ SEGM*01, noBoucle1, SensUp);
   EmettreSegm(LigneL01+ L0121+ TRONC*02+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL01+ L0121+ TRONC*02+ SEGM*01, noBoucle1, SensUp);
(* version 1.1.1 du 5/12/1997 - FC *)
   EmettreSegm(LigneL01+ L0121+ TRONC*02+ SEGM*03, noBoucle1, SensUp);
   EmettreSegm(LigneL01+ L0122+ TRONC*01+ SEGM*00, noBoucle1, SensUp);
(* fin du rajout *)
   EmettreSegm(LigneL01+ L0121+ TRONC*06+ SEGM*00, noBoucle1, SensUp);

 (** Boucle 2 **)
   EmettreSegm(LigneL01+ L0121+ TRONC*02+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL01+ L0121+ TRONC*02+ SEGM*01, noBoucle2, SensUp);
   EmettreSegm(LigneL01+ L0121+ TRONC*02+ SEGM*02, noBoucle2, SensUp);
   EmettreSegm(LigneL01+ L0121+ TRONC*02+ SEGM*03, noBoucle2, SensUp);
   EmettreSegm(LigneL01+ L0122+ TRONC*01+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL01+ L0122+ TRONC*01+ SEGM*01, noBoucle2, SensUp);

 (** Boucle 3 **)
   EmettreSegm(LigneL01+ L0121+ TRONC*03+ SEGM*00, noBoucle3, SensUp);
   EmettreSegm(LigneL01+ L0121+ TRONC*03+ SEGM*01, noBoucle3, SensUp);
   EmettreSegm(LigneL01+ L0121+ TRONC*05+ SEGM*02, noBoucle3, SensUp);
   EmettreSegm(LigneL01+ L0121+ TRONC*04+ SEGM*00, noBoucle3, SensUp);
   EmettreSegm(LigneL01+ L0121+ TRONC*04+ SEGM*01, noBoucle3, SensUp);

 (** Boucle 4 **)
   EmettreSegm(LigneL01+ L0121+ TRONC*04+ SEGM*00, noBoucle4, SensUp);
   EmettreSegm(LigneL01+ L0121+ TRONC*04+ SEGM*01, noBoucle4, SensUp);
   EmettreSegm(LigneL01+ L0121+ TRONC*04+ SEGM*02, noBoucle4, SensUp);
   EmettreSegm(LigneL01+ L0121+ TRONC*04+ SEGM*03, noBoucle4, SensUp);
   EmettreSegm(LigneL01+ L0121+ TRONC*06+ SEGM*00, noBoucle4, SensUp);
   EmettreSegm(LigneL01+ L0121+ TRONC*06+ SEGM*01, noBoucle4, SensUp);
   EmettreSegm(LigneL01+ L0121+ TRONC*01+ SEGM*00, noBoucle4, SensUp);
   EmettreSegm(LigneL01+ L0121+ TRONC*01+ SEGM*01, noBoucle4, SensUp);

 (** Boucle 5 **)
   EmettreSegm(LigneL01+ L0121+ TRONC*05+ SEGM*00, noBoucle5, SensUp);
   EmettreSegm(LigneL01+ L0121+ TRONC*05+ SEGM*01, noBoucle5, SensUp);
   EmettreSegm(LigneL01+ L0121+ TRONC*05+ SEGM*02, noBoucle5, SensUp);
   EmettreSegm(LigneL01+ L0121+ TRONC*04+ SEGM*00, noBoucle5, SensUp);
   EmettreSegm(LigneL01+ L0121+ TRONC*04+ SEGM*01, noBoucle5, SensUp);
   EmettreSegm(LigneL01+ L0121+ TRONC*04+ SEGM*02, noBoucle5, SensUp);
   EmettreSegm(LigneL01+ L0121+ TRONC*06+ SEGM*00, noBoucle5, SensUp);
   EmettreSegm(LigneL01+ L0121+ TRONC*02+ SEGM*02, noBoucle5, SensUp);

 (** Boucle 6 **)
   EmettreSegm(LigneL01+ L0121+ TRONC*06+ SEGM*00, noBoucle6, SensUp);
   EmettreSegm(LigneL01+ L0121+ TRONC*06+ SEGM*01, noBoucle6, SensUp);
   EmettreSegm(LigneL01+ L0121+ TRONC*04+ SEGM*01, noBoucle6, SensUp);
   EmettreSegm(LigneL01+ L0121+ TRONC*04+ SEGM*03, noBoucle6, SensUp);
   EmettreSegm(LigneL01+ L0121+ TRONC*01+ SEGM*01, noBoucle6, SensUp);

 (* *)
(************************** CONFIGURATION DES TRONCONS TSR ***************************)

   ConfigurerTroncon(Tronc0, LigneL01 + L0121 + TRONC*01, 2,2,2,2);  (* troncon 21-1 *)
   ConfigurerTroncon(Tronc1, LigneL01 + L0121 + TRONC*02, 2,2,2,2);  (* troncon 21-2 *)
   ConfigurerTroncon(Tronc2, LigneL01 + L0121 + TRONC*03, 2,2,2,2);  (* troncon 21-3 *)
   ConfigurerTroncon(Tronc3, LigneL01 + L0121 + TRONC*04, 2,2,2,2);  (* troncon 21-4 *)
   ConfigurerTroncon(Tronc4, LigneL01 + L0121 + TRONC*05, 2,2,2,2);  (* troncon 21-5 *)
   ConfigurerTroncon(Tronc5, LigneL01 + L0121 + TRONC*06, 2,2,2,2);  (* troncon 21-6 *)


(******************************** EMISSION DES TSR ***********************************)

(** Emission des TSR vers le secteur aval 22 L0122 **)

   EmettreTronc(LigneL01+ L0121+ TRONC*03, noBouclepaj, SensUp);


(** Emission des TSR vers le secteur amont 20 L0120 **)

 (* pas de secteur amont *)


 (** Emission des TSR sur les troncons du secteur courant **)

   EmettreTronc(LigneL01+ L0121+ TRONC*01, noBoucle1, SensUp); (* troncon 21-1 *)
   EmettreTronc(LigneL01+ L0121+ TRONC*02, noBoucle1, SensUp);
(* version 1.1.1 du 5/12/1997 - FC *)
   EmettreTronc(LigneL01+ L0122+ TRONC*01, noBoucle1, SensUp);
(* fin du rajout *)
   EmettreTronc(LigneL01+ L0121+ TRONC*06, noBoucle1, SensUp); (* troncon 21-1 *)

   EmettreTronc(LigneL01+ L0121+ TRONC*02, noBoucle2, SensUp); (* troncon 21-2 *)
   EmettreTronc(LigneL01+ L0122+ TRONC*01, noBoucle2, SensUp);


   EmettreTronc(LigneL01+ L0121+ TRONC*03, noBoucle3, SensUp); (* troncon 21-3 *)
   EmettreTronc(LigneL01+ L0121+ TRONC*05, noBoucle3, SensUp);
   EmettreTronc(LigneL01+ L0121+ TRONC*04, noBoucle3, SensUp);


   EmettreTronc(LigneL01+ L0121+ TRONC*04, noBoucle4, SensUp); (* troncon 21-4 *)
   EmettreTronc(LigneL01+ L0121+ TRONC*06, noBoucle4, SensUp);
   EmettreTronc(LigneL01+ L0121+ TRONC*01, noBoucle4, SensUp);


   EmettreTronc(LigneL01+ L0121+ TRONC*05, noBoucle5, SensUp); (* troncon 21-5 *)
   EmettreTronc(LigneL01+ L0121+ TRONC*04, noBoucle5, SensUp);
   EmettreTronc(LigneL01+ L0121+ TRONC*06, noBoucle5, SensUp);
   EmettreTronc(LigneL01+ L0121+ TRONC*02, noBoucle5, SensUp);


   EmettreTronc(LigneL01+ L0121+ TRONC*06, noBoucle6, SensUp); (* troncon 21-6 *)
   EmettreTronc(LigneL01+ L0121+ TRONC*04, noBoucle6, SensUp);
   EmettreTronc(LigneL01+ L0121+ TRONC*01, noBoucle6, SensUp);


END InSpecMessInv ;

(* *)
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
    StockAdres( ADR( SigPAB24));
    StockAdres( ADR( SigPAB14));
    StockAdres( ADR( SigPAB22A));
    StockAdres( ADR( SigPAB20kv));
    StockAdres( ADR( SigPAB20kj));
    StockAdres( ADR( CdvPAB17));
    StockAdres( ADR( CdvPAB16));
    StockAdres( ADR( CdvPAB07));
    StockAdres( ADR( CdvPAB08));
    StockAdres( ADR( SigPAB08kv));
    StockAdres( ADR( SigPAB08kj));
    StockAdres( ADR( SigPAB09));
    StockAdres( ADR( SigPAB10kv));
    StockAdres( ADR( SigPAB10kj));
    StockAdres( ADR( SigPAB12));
    StockAdres( ADR( SigPAB22B));
    StockAdres( ADR( SigPABzA));
    StockAdres( ADR( SigPABzB));
    StockAdres( ADR( CdvPAB09));
    StockAdres( ADR( CdvPAB13));
    StockAdres( ADR( SigPAB38A));
    StockAdres( ADR( SigPAB58A));
    StockAdres( ADR( SigPAB38B));
    StockAdres( ADR( SigPAB58B));
    StockAdres( ADR( CdvPAB22));
    StockAdres( ADR( CdvPAB12));
    StockAdres( ADR( CdvPAB18));

    StockAdres( ADR( AigPAB23));
    StockAdres( ADR( AigPAB19B));
    StockAdres( ADR( AigPAB09));
    StockAdres( ADR( AigPAB11));
    StockAdres( ADR( AigPAB19C));

    StockAdres( ADR( PtArrSigPAB14));
    StockAdres( ADR( PtArrSigPAB24));
    StockAdres( ADR( PtArrSigPAB22A));
    StockAdres( ADR( PtArrSigPAB20));
    StockAdres( ADR( PtArrCdvPAB17));
    StockAdres( ADR( PtArrCdvPAB16));
    StockAdres( ADR( PtArrSigPABzA));

    StockAdres( ADR( PtArrCdvPAB07));
    StockAdres( ADR( PtArrCdvPAB08));
    StockAdres( ADR( PtArrSigPAB08));
    StockAdres( ADR( PtArrSigPAB09));
    StockAdres( ADR( PtArrSigPAB10));
    StockAdres( ADR( PtArrCdvPAB12));
    StockAdres( ADR( PtArrSigPAB12));
    StockAdres( ADR( PtArrSigPAB22B));
    StockAdres( ADR( PtArrSigPABzB));

    StockAdres( ADR( PtArrSigPAB38A));
    StockAdres( ADR( PtArrSigPAB58A));

    StockAdres( ADR( TivComPAB20));
    StockAdres( ADR( TivComPAB08));
(*    StockAdres( ADR( TivComPAB10)); *)

    StockAdres( ADR( PtAntCdvPAJ10));

END StockerAdresse ;
(* *)
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

(**** CONFIGURATION DES VARIABLES DU STANDARD NON UTILISEES *************)
   InitInutil ;

(****   Stockage des adresses *****)
   StockerAdresse ;

END InitSpecific;

(* *)
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
VAR BoolTr : BoolLD;

BEGIN (* ExeSpecific *)

(* Affectation des "constantes" utilisees dans la construction des messages emis    *)
(* et recus sur les boucles de transmission continue et sur les liens intersecteur. *)
(* Cette reaffectation est necessaire a chaque cycle pour la mise en securite.      *)
   AffectBoolC(Vrai, BoolPermissif)  ;
   AffectBoolC(Faux, BoolRestrictif) ;

(* regulation *)
  CdvPAB22Fonc := CdvPAB22.F = Vrai.F;
  CdvPAB18Fonc := CdvPAB18.F = Vrai.F;
  CdvPAB08Fonc := CdvPAB08.F = Vrai.F;	


(*  *)
(****************************** FILTRAGE DES AIGUILLES *******************************)

  FiltrerAiguille( AigPAB23,  BaseExeAig);
  FiltrerAiguille( AigPAB19B, BaseExeAig+2);
  FiltrerAiguille( AigPAB09,  BaseExeAig+4);
  FiltrerAiguille( AigPAB11,  BaseExeAig+6);
  FiltrerAiguille( AigPAB19C, BaseExeAig+8);

(******************* Gerer les Tiv Com non lies a une aiguille ****************)

   AffectBoolD( AigPAB19B.PosNormaleFiltree, TivComPAB20);
   AffectBoolD( SigPAB08kv,                 TivComPAB08);
(*    AffectBoolD( SigPAB10kv,                 TivComPAB10); *)

(************************** Gerer les point d'arrets **************************)

   AffectBoolD( SigPAB14,                   PtArrSigPAB14);
   AffectBoolD( SigPAB24,                   PtArrSigPAB24);
   AffectBoolD( SigPAB22A,                  PtArrSigPAB22A);
   OuDD(        SigPAB20kv,   SigPAB20kj,   PtArrSigPAB20);
   AffectBoolD( CdvPAB17,                   PtArrCdvPAB17);
   AffectBoolD( CdvPAB16,                   PtArrCdvPAB16);
   AffectBoolD( SigPABzA,                   PtArrSigPABzA);

   AffectBoolD( CdvPAB07,                   PtArrCdvPAB07);
   EtDD(        CdvPAB08,     CdvPAB09,     PtArrCdvPAB08);
   OuDD(        SigPAB08kv,   SigPAB08kj,   PtArrSigPAB08);
   AffectBoolD( SigPAB09,                   PtArrSigPAB09);
   OuDD(        SigPAB10kv,   SigPAB10kj,   PtArrSigPAB10);
   OuDD(	CdvPAB13,  AigPAB23.PosReverseFiltree, BoolTr);        
   EtDD(	CdvPAB12,     BoolTr,	    PtArrCdvPAB12);
   AffectBoolD( SigPAB12,                   PtArrSigPAB12);
   AffectBoolD( SigPAB22B,                  PtArrSigPAB22B);
   AffectBoolD( SigPABzB,                   PtArrSigPABzB);

  (* AffectBoolD( SigPAB38A,                  PtArrSigPAB38A); *)
  (* AffectBoolD( SigPAB58A,                  PtArrSigPAB58A); *)

   EtDD( SigPAB38A, AigPAB19B.PosReverseFiltree, PtArrSigPAB38A);
   EtDD( SigPAB58A, AigPAB19B.PosReverseFiltree, PtArrSigPAB58A);

(*** lecture des entrees de regulation ***)

   LireEntreesRegul;

END ExeSpecific;
END Specific.
