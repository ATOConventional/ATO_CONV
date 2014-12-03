IMPLEMENTATION MODULE Specific;

(*$S- *)
(*$T- *)

(******************************************************************************
*   SANTIAGO - LIGNE 2 - Secteur 12
*  =============================
*  Version : 1.0.1
*  Date    : 17/03/1997
*  Auteur  : Marc Plywacz
*  Premiere Version
******************************************************************************)

(* !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! *
 * ATTENTION : l'etat du PtArrCdvHEB12 est   *
 * calcule mais pas utilise.                 *
 * !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! *)
(*---------------------------------------------------------------------------*)
(* Modifications :                                                           *)
(* -------------                                                             *)
(*                                                                           *)
(*  Version : 1.0.2
    Auteur : F. Chanier
    Date : 11/09/1997
    Origine : erreur dans la configuration de la boucle 3 (fiche Gauvin 0008 *)
(*                                                                           *)
(* version 1.0.3                                                             *)
(* Date : 29/10/1997, Auteur: P. Hog    , origine : Fax F264                 *)
(*  Ajout d'un TivCom a 25 sur le segment 12.6.0.                            *)
(*  Prise en compte de l'etat de SP1 dans le calcul du signal20A.            *) 
(*                                                                           *)
(* version 1.0.4                                                             *)
(* Date : 23/01/1998, Auteur: F. Chanier , origine : eq dev.                 *)
(* modification liee a la detection des pannes d'ampli                       *)
(*                                                                           *)
(* version 1.0.5                                                             *)
(* Date : 16/03/1998, Auteur : F. Chanier, Origine : Eq. dev                 *)
(* rajout d'un EP sur le cdv HEB22 troncon 6                                 *)
(*                                                                           *)
(* version 1.0.6                                                             *)
(* Date : 02/07/1998, Auteur : P. Hog    , origine : Eq. dev                 *)
(*  Prise en compte de l'etat de Sp2 et de l'aiguille 21 dans le calcul du   *)
(*  signal20A (PtArrSigHEB20A).                                              *) 
(*---------------------------------------------------------------------------*)
(*****************************************************************************)
(***            AJOUT DE LA NUMEROTATION SCCS DES VERSIONS                ****)
(*---------------------------------------------------------------------------*)
(* Version 1.0.7  =====================                                      *)
(* Version 1.7 DU SERVEUR SCCS =====================                         *)
(* Date :         21/09/1998                                                 *)
(* Auteur:        H. Le Roy                                                  *)
(* Modification : Fiche d'anomalie ba040998                                  *)
(*                Suite a un changement de vitesses maximales, mise a jour   *)
(*                des marches types                                          *)
(*****************************************************************************)
(* Version 1.0.8  =====================                                      *)
(* Version 1.8 DU SERVEUR SCCS =====================                         *)
(* Date :         09/12/1998                                                 *)
(* Auteur:        H. Le Roy                                                  *)
(* Modification : Origine  am ba091298-2                                     *)
(*                 Modif. de la logique de commmande des SP                  *)
(*                 Ajout d'une entree secu pour le cdv 20                    *)
(*****************************************************************************)
(* Version 1.0.9  =====================                                      *)
(* Version 1.9 DU SERVEUR SCCS =====================                         *)
(* Date :         18/12/1998                                                 *)
(* Auteur :       H. Le Roy                                                  *)
(* Modification : Origine am ba181298-1                                      *)
(*                 Correction de la logique de com. des SP de la version 1.8 *)
(*****************************************************************************)
(* Version 1.1.0  =====================                                      *)
(* Version 1.10 DU SERVEUR SCCS =====================                        *)
(* Date :         14/04/1999                                                 *)
(* Auteur :       H. Le Roy                                                  *)
(* Modification : Adaptation de la configuration des amplis au standard      *)
(*                 1.3.3. Ajout d'entrees pour fusibles. Suppression de      *)
(*                 parties de code inutiles concernant les DAMTC.            *)
(*****************************************************************************)
(* Version 1.1.1  =====================                                      *)
(* Version 1.11 DU SERVEUR SCCS =====================                        *)
(* Date :         10/09/1999                                                 *)
(* Auteur :       H. Le Roy                                                  *)
(* Modification : Adaptations pour l'extension de la ligne 5 : ajout de la   *)
(*                 liaison intersecteur avec le secteur 7                    *)
(*                                                                           *)
(*****************************************************************************)
(* Version 1.1.2  =====================                                      *)
(* Version 1.12 DU SERVEUR SCCS =====================                        *)
(* Date :         14/01/2000                                                 *)
(* Auteur :       H. Le Roy                                                  *)
(* Modification : Modification de l'attribution des numero de boucles pour   *)
(*                  cause d'incompatibilite avec le standard                 *)
(*                                                                           *)
(*****************************************************************************)
(* Version 1.1.3  =====================                                      *)
(* Version 1.13 DU SERVEUR SCCS =====================                        *)
(* Date :         16/02/2000                                                 *)
(* Auteur :       H. Le Roy                                                  *)
(* Modification : Dans l'ATP Bord, le buffer qui stocke les invariants est   *)
(*      sature sur le troncon 3. Le nombre de branches a anticiper est trop  *)
(*      eleve. En consequence, la description de certains segments proches   *)
(*      est ecrasee momentanement au benefice de segments plus lointains,    *)
(*      jusqu'a nouvelle reception de ces segments. Et cela provoque des FU. *)
(*      On supprime donc sur le troncon 3 l'emission des descriptions de     *)
(*      segments facultatives                                                *) 
(*                                                                           *)
(*****************************************************************************)
(* Version 1.1.4  =====================                                      *)
(* Version 1.14 DU SERVEUR SCCS =====================                        *)
(* Date :         22/02/2000                                                 *)
(* Auteur :       H. Le Roy                                                  *)
(* Modification : AM dev022000-1 : Emission du 12.4.0 sur le troncon 1 et    *)
(*                  vers le secteur 7 pour permettre le retournement correct *)
(*                  du train en cas d'itineraire 08-44-42 et 42-44-18.       *)
(*                Suppression de l'emission des segments 12.1.2 et 12.1.3    *)
(*                  sur le troncon 1 pour eviter la saturation de l'ATP Bord *)
(*****************************************************************************)
(* Version 1.1.5  =====================                                      *)
(* Version 1.15 DU SERVEUR SCCS =====================                        *)
(* Date :         25/02/2000                                                 *)
(* Auteur :       H. Le Roy                                                  *)
(* Modification : AM hlr022000-4 : Correction suite a un oubli dans la modif.*)
(*                  precedente. Emission du troncon 12.4 vers le secteur 7   *)
(*****************************************************************************)
(* Version 1.1.6  =====================                                      *)
(* Version 1.16 DU SERVEUR SCCS =====================                        *)
(* Date :         08/03/2000                                                 *)
(* Auteur :       H. Le Roy                                                  *)
(* Modification : AM dev032000-1 : Modif. de la gestion du SP2 : Le SP2 ne   *)
(*        conditionne plus le point d'arret secu associe au cdv 13B, mais un *)
(*        point d'arret specifique place a 2m de la fin du quai. Ce dernier  *)
(*        remplace le premier devenu inutile, car le cdv13B de Los Heroes    *)
(*        est deja protege par le point d'arret associe au cdv13A            *)
(*****************************************************************************)
(* Version 1.1.7  =====================                                      *)
(* Version 1.17 DU SERVEUR SCCS =====================                        *)
(* Date :         14/03/2000                                                 *)
(* Auteur :       H. Le Roy                                                  *)
(* Modification : Am dev022000-1 : Les variants associes a l'aiguille 09     *)
(*                 sont emis vers le secteur 11                              *) 
(*****************************************************************************)
(* Version 1.1.8  =====================                                      *)
(* Version 1.18 DU SERVEUR SCCS =====================                        *)
(* Date :         19/06/2000                                                 *)
(* Auteur :       H. Le Roy                                                  *)
(* Modification : Am165 : modification des marches types                     *)
(*                                                                           *)
(*                Am Dev062000-3 : Le premier emetteur de la carte 4 du PTC3 *)
(*                  n'est pas utilise, donc pas teste par le DAM.            *)
(*                                                                           *)
(* Version 1.1.9  =====================                                      *)
(* Version 1.19 DU SERVEUR SCCS =====================                        *)
(* Date :         08/08/2006                                                 *)
(* Auteur:        Rudy Nsiona                                                *)
(* Modification : Nouveau Train NS2004                                       *)
(* Procédure CONFIGURATION DES TRONCONS TSR                                  *)
(*                ancienne valeur 1 , nouvelle 2                             *)
(* Version 1.2.0  =====================                                      *)
(* Version 1.20 DU SERVEUR SCCS =====================                        *)
(* Date :         04/10/2012                                                 *)
(* Auteur:        Raby Xavier                                                *)
(* Modification : modifs suite tests en voies                                *)
(*                devision de secteurs                                       *)
(*                                                                           *)
(*****************************  IMPORTATIONS  ********************************)

FROM SYSTEM     IMPORT ADR;

FROM Opel       IMPORT StockAdres, AffectBoolD, AffectBoolC, BoolC, BoolLD, BoolD, EtDD, CodeD, NonD,
		       Tvrai, FinBranche, FinArbre, AffectC, OuDD;

FROM ConstCode  IMPORT BoolPermissif, BoolRestrictif, Vrai, Faux;

FROM ConstIntf	IMPORT Map1 ;

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
              	        Ampli11, Ampli12, Ampli13, Ampli14, Ampli15, Ampli16, 
	                Ampli17, Ampli18, Ampli19, Ampli1A,
              		Ampli21, Ampli22, Ampli23, Ampli24, Ampli25,          Ampli27,
              		Ampli31, Ampli32, Ampli33, Ampli34,
              		Ampli41, Ampli42, Ampli43, Ampli44,
	      		Ampli51, Ampli52, Ampli53, Ampli54, Ampli55, Ampli56, Ampli57,
	      		Ampli61, Ampli62, Ampli63, Ampli64, Ampli65, Ampli66,
	      		Ampli67, Ampli68, Ampli69, Ampli6A, Ampli6B, Ampli6C, Ampli6D,


(* variables *)
                       Boucle1, Boucle2, Boucle3, Boucle4, Boucle5, Boucle6, BoucleFictive,
		       CarteCes1,  CarteCes2,  CarteCes3, CarteCes4, CarteCes5, CarteCes6,
                       Intersecteur1, Intersecteur2,

(* PROCEDURES *)       
                       ConfigurerBoucle,
			ConfigurerAmpli,
                       ConfigurerIntsecteur,
                       ConfigurerCES;


FROM BibTsr      IMPORT
   (* TYPE *)
                       TyTsrTroncon,
   (* VARIABLES *)
 Tronc0,  Tronc1,  Tronc2,  Tronc3 , Tronc4,  Tronc5,
 Tronc6,  Tronc7,  Tronc8,  Tronc9,  Tronc10, Tronc11,
 Tronc12, Tronc13, Tronc14, Tronc15,

   (* PROCEDURE *)
                       ConfigurerTroncon;


FROM ESbin     	 IMPORT 
			TyEntreeFonctio,

			ProcEntreeIntrins,
			ProcEntreeFonctio;

(*****************************  CONSTANTES  ***********************************)

CONST

(** No ligne, No secteur, ....**)


    LigneL01 = 16384*00;

    LigneL02 = 16384*00; (* numero de ligne decale de 2**14 *)

    LigneL05 = 16384*00; (* numero de ligne decale de 2**14 *)

    L0213  = 1024*13;     (* numero Secteur aval voie impaire decale de 2**10 *)

    L0212  = 1024*12;    (* numero Secteur local decale de 2**10 *)

    L0211  = 1024*11;    (* numero Secteur amont voie impaire decale de 2**10 *)

    L0507  = 1024*07;    (* numero Secteur adjacent LIGNE 5 decale de 2**10 *)

    L0125  = 1024*25;    (* numero Secteur adjacent LIGNE 1 decale de 2**10 *)

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

(** No des stations du secteur 12 **)
(* ligne 1: 1,2 ; ligne 2: 3,4; ligne 5: 5,6 *)
    noHEBv1 = 3*32 + 3;
    noHEBv2 = 4*32 + 11;
    noTOEv1 = 3*32 + 4;
    noTOEv2 = 4*32 + 10;

(** indication de sens **)
    SensUp = TRUE;

(** No de Voie d'emissions SOL-Train, d'emission/reception inter-secteur **)
    noBouclehig = 00; 
    noBouclecal = 01; 
    noBouclehea = 02;
    noBoucleana = 03;

    noBoucle1 = 09;
    noBoucle2 = 04;
    noBoucle3 = 05;
    noBoucle4 = 06;
    noBoucle5 = 07;
    noBoucle6 = 08;


(** Base pour les tables de compensation **)
    BaseEntVar	= 500 	;
    BaseSorVar	= 600 	;
    BaseExeAig	= 1280	;
    BaseExeChainage = 1360 ;
    BaseExeSpecific = 1950 ;

(*  *)
TYPE
 TyAigNonLue = RECORD  (* Structure de donnees associee a une aiguille dont *
                        * l'etat n'est pas lu sur des entrees de carte CES  *
                        * (aiguille fictive ou anticipee)                   *)
                  PosNormale  : BoolD ;   (* position normale calculee *)
                  PosDeviee   : BoolD ;   (* position deviee calculee  *)
                END;


(***************** DECLARATION DES VARIABLES GENERALES **********************)
 VAR

(* DECLARATION DES SINGULARITES DU SECTEUR 12 : dans les deux sens confondus *)

(* Declaration des variables correspondant a des entrees securitaires  *)
(*   - CDV et signaux                                                  *)
    CdvHEB08,      (* entree  1, soit entree 0 de CES 02  *)
    SigHEB08kv,    (* entree  2, soit entree 1 de CES 02  *)
    SigHEB08kj,    (* entree  3, soit entree 2 de CES 02  *)
    SigHEB10,      (* entree  6, soit entree 5 de CES 02  *)
    CdvHEB13A,     (* entree  7, soit entree 6 de CES 02  *)
    CdvHEB13B,     (* entree  8, soit entree 7 de CES 02  *)
    CdvHEB14,      (* entree  9, soit entree 0 de CES 02  *)
    CdvTOE11,      (* entree 10, soit entree 1 de CES 03  *)
    CdvTOE12,      (* entree 11, soit entree 2 de CES 03  *)
    CdvTOE13,      (* entree 12, soit entree 3 de CES 03  *)
    CdvTOE14,      (* entree 13, soit entree 4 de CES 03  *)
    CdvTOE23,      (* entree 14, soit entree 5 de CES 03  *)
    CdvTOE22,      (* entree 15, soit entree 6 de CES 03  *)
    CdvTOE21,      (* entree 16, soit entree 7 de CES 03  *)
    CdvHEB24,      (* entree 17, soit entree 0 de CES 04  *)
    SigHEB24,      (* entree 18, soit entree 1 de CES 04  *)
 (* pas utilisee *) (* entree 19, soit entree 2 de CES 04  *)
    SigHEB22kv,    (* entree 20, soit entree 3 de CES 04  *)
    SigHEB22kj,    (* entree 21, soit entree 4 de CES 04  *)
    SigHEB20Akv,   (* entree 22, soit entree 5 de CES 04  *)
    SigHEB20Akj,   (* entree 23, soit entree 6 de CES 04  *)
    Sp1HEB,        (* entree 26, soit entree 1 de CES 05  *)
    Sp2HEB,        (* entree 27, soit entree 2 de CES 05  *)
    SigHEB12,      (* entree 28, soit entree 3 de CES 05  *)
    SigHEB20B,     (* entree 31, soit entree 6 de CES 05  *)
    SigHEB44A,     (* entree 32, soit entree 7 de CES 05  *)
    SigHEB44B,     (* entree 33, soit entree 0 de CES 06  *)
    SigHEB46A,     (* entree 36, soit entree 3 de CES 06  *)
    SigHEB46B,     (* entree 37, soit entree 4 de CES 06  *)
 (* res R.Fix fi *) (* entree 38, soit entree 5 de CES 06  *)
 (* res R.Fix fi *) (* entree 39, soit entree 6 de CES 06  *)
    CdvHEB09,      (* entree 40, soit entree 7 de CES 06  *)
    CdvHEB21,      (* entree 41, soit entree 0 de CES 07  *)
    CdvHEB23B,     (* entree 42, soit entree 1 de CES 07  *)
    CdvHEB25,      (* entree 43, soit entree 2 de CES 07  *)
    CdvHEB45,      (* entree 44, soit entree 3 de CES 07  *)
    CdvHEB12,      (* entree 45, soit entree 4 de CES 07  *)
    CdvHEB22,      (* entree 46, soit entree 5 de CES 07  *)
    CdvHEB18,      (* entree 47, soit entree 6 de CES 07  *)
    CdvHEB20       (* entree 48, soit entree 7 de ces 07  *)
             : BoolD;

(*   - aiguilles                                                       *)
    AigHEB09B,     (* entrees  4 et  5, soit entrees 3 et 4 de CES 02  *)
    AigHEB19B,     (* entrees 24 et 25, soit entrees 7 et 0 de CES 04 et 05 *)
    AigHEB21,      (* entrees 29 et 30, soit entrees 4 et 5 de CES 05  *)
    AigHEB45       (* entrees 34 et 35, soit entrees 1 et 2 de CES 06  *)
             :TyAig;



(* Variables ne correspondant pas a une entree securitaire *)
(* Point d'arret *)
    PtArrCdvHEB08,
    PtArrSigHEB08,
    PtArrSigHEB10,
    PtArrCdvHEB12,
    PtArrCdvHEB13A,
(*  modif du 08/03/2000 : modif. de la gestion du SP2 *)
    PtArrSpec13A,
(*    PtArrCdvHEB13B,                                 *)
    PtArrCdvHEB14,
    PtArrCdvTOE11,
    PtArrCdvTOE12,
    PtArrCdvTOE13,
    PtArrCdvTOE14,

    PtArrCdvTOE23,
    PtArrCdvTOE22,
    PtArrCdvTOE21,
    PtArrCdvHEB24,
    PtArrSigHEB24,
    PtArrSigHEB22,
    PtArrSigHEB20A,
    PtArrCdvHEB18,

(* rajout FC du 16/03/1998 *)
    PtArrCdvHEB22,

    PtArrSigHEB44A,
    PtArrSigHEB44B,
    PtArrSigHEB46A,
    PtArrSigHEB46B,

    PtArrSigHEB12,
    PtArrSigHEB20B : BoolD;

(* Tiv Com non lies a une aiguille *)
    TivComHEB22    : BoolD;

(* Variants anticipes *)
    PtAntCdvHIG11,
    PtAntCdvANA22,
    PtAntCdvANA21, (* Stations St ANA dans sect 7 et 11 => sect7 : ANB *)
    PtAntSigANB42A  : BoolD;
    AigAntHEA24       : TyAigNonLue;

(* Copie des entrees dans des variables fonctionnelles pour la regulation *)
    CdvHEB12Fonc,
    CdvHEB22Fonc,
    CdvTOE12Fonc,
    CdvTOE22Fonc : BOOLEAN;

(** Voie d'emission SOL-TRAIN : deux sens confondus**)
    te11s12t01,
    te15s12t02,
    te21s12t03,
    te23s12t04,
    te26s12t05,
    te31s12t06           :TyEmissionTele;
	 			
(** Voie d'emission Inter-secteur deux voies confondues **)
    teL0213,
    teL0211,
    teL0125,
    teL0507	         :TyEmissionTele;

(** Voie de reception Inter-secteur deux voies confondues **)
    trL0213,
    trL0211,
    trL0125,
    trL0507               :TyCaracEntSec;
    	 
(* boucle en amont des 3 voies *)
    BoucleAmv1,
    BoucleAmv2,
    BoucleAmvE            :TyBoucle;

(* 14/12/98 : variable de memorisation des etats precedents des cdv20 et SP1 *)
(* 18/12/98 : memorisation etats de la bascule                               *)
    EtatBasc,
    EtatBascPrec,
    CdvHEB20prec,
    Sp1HEBprec  : BoolD;

   V1, V2, V3, V4, V5, V6 : BOOLEAN;


(*  *)
(*****************************  PROCEDURES  ***********************************)

(*----------------------------------------------------------------------------*)
PROCEDURE InitSpecDivers1;
(*----------------------------------------------------------------------------*)
(*
 * Fonctions : InitSpecDiversX ou X est un chiffre
 * Ces procedures configurent les singularites diverses telles que : Aiguilles, 
 * Stations, Inter-stations
 * Ainsi que les entrees CNP1, CNP2, Maintenance
 *
 * Condition d'appel : Appelee par InitSpecific a l'initialisation du logiciel
 *
 *)
(*----------------------------------------------------------------------------*)

BEGIN

(* CONFIGURATION DES ENTREES CNP2, CNP1 ET VERSION *) 


(******************** CONFIGURATIONS DIVERSES ***********************)

(* CONFIGURATION DES AIGUILLES, POUR LES DEUX VOIES *)
    EntreeAiguille( AigHEB09B,  4,  5);  (* kag G = pos normale *)
    EntreeAiguille( AigHEB21,  29, 30);  (* kag G = pos normale *)
    EntreeAiguille( AigHEB45,  35, 34);  (* kag D = pos normale *)
    EntreeAiguille( AigHEB19B, 25, 24);  (* kag D = pos normale *)

(* Configuration des entrees *)
    ProcEntreeIntrins (  1, CdvHEB08);
    ProcEntreeIntrins (  2, SigHEB08kv);
    ProcEntreeIntrins (  3, SigHEB08kj);
    ProcEntreeIntrins (  6, SigHEB10);
    ProcEntreeIntrins (  7, CdvHEB13A);
    ProcEntreeIntrins (  8, CdvHEB13B);
    ProcEntreeIntrins (  9, CdvHEB14);
    ProcEntreeIntrins ( 10, CdvTOE11);
    ProcEntreeIntrins ( 11, CdvTOE12);
    ProcEntreeIntrins ( 12, CdvTOE13);
    ProcEntreeIntrins ( 13, CdvTOE14);
    ProcEntreeIntrins ( 14, CdvTOE23);
    ProcEntreeIntrins ( 15, CdvTOE22);
    ProcEntreeIntrins ( 16, CdvTOE21);
    ProcEntreeIntrins ( 17, CdvHEB24);
    ProcEntreeIntrins ( 18, SigHEB24);
    ProcEntreeIntrins ( 20, SigHEB22kv);
    ProcEntreeIntrins ( 21, SigHEB22kj);
    ProcEntreeIntrins ( 22, SigHEB20Akv);
    ProcEntreeIntrins ( 23, SigHEB20Akj);
    ProcEntreeIntrins ( 26, Sp1HEB);
    ProcEntreeIntrins ( 27, Sp2HEB);
    ProcEntreeIntrins ( 28, SigHEB12);
    ProcEntreeIntrins ( 31, SigHEB20B);
    ProcEntreeIntrins ( 32, SigHEB44A);
    ProcEntreeIntrins ( 33, SigHEB44B);
    ProcEntreeIntrins ( 36, SigHEB46A);
    ProcEntreeIntrins ( 37, SigHEB46B); (* C- : 22/8 remarque Th. Massez F169/97 *)
    ProcEntreeIntrins ( 40, CdvHEB09);
    ProcEntreeIntrins ( 41, CdvHEB21);
    ProcEntreeIntrins ( 42, CdvHEB23B);
    ProcEntreeIntrins ( 43, CdvHEB25);
    ProcEntreeIntrins ( 44, CdvHEB45);
    ProcEntreeIntrins ( 45, CdvHEB12);
    ProcEntreeIntrins ( 46, CdvHEB22);
    ProcEntreeIntrins ( 47, CdvHEB18);
    ProcEntreeIntrins ( 48, CdvHEB20);

(* CONFIGURATION POUR LA MAINTENANCE de la transmission continue *)
   ConfigurerBoucle(Boucle1, 1);
   ConfigurerBoucle(Boucle2, 2);
(* C+ : modif fiche Gauvin n 0008 *)
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
   ConfigurerAmpli(Ampli18, 1, 8, 193, 14, FALSE);
   ConfigurerAmpli(Ampli19, 1, 9, 194, 14, FALSE);
   ConfigurerAmpli(Ampli1A, 1, 10, 195, 14, TRUE);


   ConfigurerAmpli(Ampli21, 2, 1, 196, 15, FALSE);
   ConfigurerAmpli(Ampli22, 2, 2, 197, 16, FALSE);
   ConfigurerAmpli(Ampli23, 2, 3, 198, 16, FALSE);
   ConfigurerAmpli(Ampli24, 2, 4, 199, 16, TRUE);       
   ConfigurerAmpli(Ampli25, 2, 5, 200, 17, FALSE);

   ConfigurerAmpli(Ampli27, 2, 7, 202, 17, TRUE);

   ConfigurerAmpli(Ampli31, 3, 1, 203, 21, FALSE);
   ConfigurerAmpli(Ampli32, 3, 2, 204, 22, FALSE);
   ConfigurerAmpli(Ampli33, 3, 3, 205, 22, FALSE);
   ConfigurerAmpli(Ampli34, 3, 4, 206, 22, TRUE);       

   ConfigurerAmpli(Ampli41, 4, 1, 207, 23, FALSE);
   ConfigurerAmpli(Ampli42, 4, 2, 208, 24, FALSE);
   ConfigurerAmpli(Ampli43, 4, 3, 209, 24, FALSE);
   ConfigurerAmpli(Ampli44, 4, 4, 210, 24, TRUE);       
      
   ConfigurerAmpli(Ampli51, 5, 1, 211, 26, FALSE);
   ConfigurerAmpli(Ampli52, 5, 2, 212, 27, FALSE);
   ConfigurerAmpli(Ampli53, 5, 3, 213, 27, FALSE);
   ConfigurerAmpli(Ampli54, 5, 4, 214, 27, TRUE);
   ConfigurerAmpli(Ampli55, 5, 5, 215, 28, FALSE);
   ConfigurerAmpli(Ampli56, 5, 6, 216, 28, FALSE);       
   ConfigurerAmpli(Ampli57, 5, 7, 217, 28, TRUE);       

   ConfigurerAmpli(Ampli61, 6, 1, 218, 31, FALSE);
   ConfigurerAmpli(Ampli62, 6, 2, 219, 32, FALSE);
   ConfigurerAmpli(Ampli63, 6, 3, 220, 32, FALSE);
   ConfigurerAmpli(Ampli64, 6, 4, 221, 32, TRUE);
   ConfigurerAmpli(Ampli65, 6, 5, 222, 33, FALSE);
   ConfigurerAmpli(Ampli66, 6, 6, 223, 33, FALSE);  
   ConfigurerAmpli(Ampli67, 6, 7, 256, 33, TRUE);

   ConfigurerAmpli(Ampli69, 6, 9, 258, 34, FALSE);
   ConfigurerAmpli(Ampli6A, 6, 10, 259, 34, TRUE);
   ConfigurerAmpli(Ampli6B, 6, 11, 260, 35, FALSE);
   ConfigurerAmpli(Ampli6C, 6, 12, 261, 35, FALSE);     
   ConfigurerAmpli(Ampli6D, 6, 13, 262, 35, TRUE);     
 

 (** cartes CES **)
   ConfigurerCES(CarteCes1, 01);
   ConfigurerCES(CarteCes2, 02);
   ConfigurerCES(CarteCes3, 03);
   ConfigurerCES(CarteCes4, 04);
   ConfigurerCES(CarteCes5, 05);
   ConfigurerCES(CarteCes6, 06);

END InitSpecDivers1;

PROCEDURE InitSpecDivers2;

BEGIN

(** Liaisons Inter-Secteur **)

   ConfigurerIntsecteur(Intersecteur1, 01, trL0213, trL0211);
   ConfigurerIntsecteur(Intersecteur2, 02, trL0125, trL0507);


(* Initialisations des variables ne correspondant pas a des entrees secu *)
(* Point d'arret *)
    AffectBoolD( BoolRestrictif, PtArrCdvHEB08);
    AffectBoolD( BoolRestrictif, PtArrSigHEB08);
    AffectBoolD( BoolRestrictif, PtArrSigHEB10);
    AffectBoolD( BoolRestrictif, PtArrCdvHEB12);
    AffectBoolD( BoolRestrictif, PtArrCdvHEB13A);
(*  modif du 08/03/2000 : modif. de la gestion du SP2 *)
    AffectBoolD( BoolPermissif, PtArrSpec13A);
(*    AffectBoolD( BoolRestrictif, PtArrCdvHEB13B);   *)
    AffectBoolD( BoolRestrictif, PtArrCdvHEB14);
    AffectBoolD( BoolRestrictif, PtArrCdvTOE11);
    AffectBoolD( BoolRestrictif, PtArrCdvTOE12);
    AffectBoolD( BoolRestrictif, PtArrCdvTOE13);
    AffectBoolD( BoolRestrictif, PtArrCdvTOE14);

    AffectBoolD( BoolRestrictif, PtArrCdvTOE23);
    AffectBoolD( BoolRestrictif, PtArrCdvTOE22);
    AffectBoolD( BoolRestrictif, PtArrCdvTOE21);
    AffectBoolD( BoolRestrictif, PtArrCdvHEB24);
    AffectBoolD( BoolRestrictif, PtArrSigHEB24);
    AffectBoolD( BoolRestrictif, PtArrSigHEB22);
    AffectBoolD( BoolRestrictif, PtArrSigHEB20A);
    AffectBoolD( BoolRestrictif, PtArrCdvHEB18);

    AffectBoolD( BoolRestrictif, PtArrSigHEB44A);
    AffectBoolD( BoolRestrictif, PtArrSigHEB44B);
    AffectBoolD( BoolRestrictif, PtArrSigHEB46A);
    AffectBoolD( BoolRestrictif, PtArrSigHEB46B);

    AffectBoolD( BoolRestrictif, PtArrSigHEB12);
    AffectBoolD( BoolRestrictif, PtArrSigHEB20B);

(* FC - rajout du 16/3/1998 EP sur HEB22 *)
    AffectBoolD( BoolRestrictif, PtArrCdvHEB22);

(* Tiv Com non lies a une aiguille *)
    AffectBoolD( BoolRestrictif, TivComHEB22);


(* Variants anticipes *)
    AffectBoolD( BoolRestrictif, PtAntCdvHIG11);
    AffectBoolD( BoolRestrictif, PtAntCdvANA22);
    AffectBoolD( BoolRestrictif, PtAntCdvANA21);
    AffectBoolD( BoolRestrictif, PtAntSigANB42A);
    AffectBoolD( BoolRestrictif, AigAntHEA24.PosNormale);
    AffectBoolD( BoolRestrictif, AigAntHEA24.PosDeviee);

(* Regulation *)
    CdvHEB12Fonc := FALSE;
    CdvHEB22Fonc := FALSE;
    CdvTOE12Fonc := FALSE;
    CdvTOE22Fonc := FALSE;

(* Variables de memorisation des etats precedents de cdv20 de HEB et SP1 *)
(* et etats de la bascule                                                *)
    AffectBoolD(BoolPermissif, EtatBasc);
    AffectBoolD(BoolPermissif, EtatBascPrec);
    AffectBoolD(BoolPermissif, CdvHEB20prec);
    AffectBoolD(BoolRestrictif, Sp1HEBprec);

END InitSpecDivers2;

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
   
(************************* CONFIGURATION DES VOIES D'EMISSION ************************)

   ConfigEmisTeleSolTrain ( te11s12t01,
                            noBoucle1,         
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);


   ConfigEmisTeleSolTrain ( te15s12t02,
                            noBoucle2,         
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);
   

     
   ConfigEmisTeleSolTrain ( te21s12t03,
                            noBoucle3,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);


   ConfigEmisTeleSolTrain ( te23s12t04,
                            noBoucle4,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);
 
   ConfigEmisTeleSolTrain ( te26s12t05,
                            noBoucle5,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);
  
   ConfigEmisTeleSolTrain ( te31s12t06,
                            noBoucle6,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);


(* CONFIGURATION POUR LA REGULATION *)
   ConfigQuai (33, 64, CdvHEB12Fonc, te11s12t01, 0, 8, 3,  4,  5, 13, 14, 15);
   ConfigQuai (33, 69, CdvHEB22Fonc, te31s12t06, 0, 3, 9, 11,  5, 13, 14, 15);
   ConfigQuai (34, 74, CdvTOE12Fonc, te15s12t02, 0, 3, 4, 11, 10, 13, 14, 15);
   ConfigQuai (34, 79, CdvTOE22Fonc, te26s12t05, 0, 2, 8,  3,  9, 13, 14, 15);

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

(********* CONFIGURATION DES EMISSIONS DE VARIANTS SOL-TRAIN  *********)

(* variants troncon 1   voie 1 --> si *)
   ProcEmisSolTrain( te11s12t01.EmissionSensUp, (2*noBoucle1), 
                     LigneL02+ L0212+ TRONC*01,     

              PtArrSigHEB08,
              BoolRestrictif,             (* aspect croix *)
              AigHEB09B.PosNormaleFiltree,     (* tivcom *)
              AigHEB09B.PosReverseFiltree,
	      AigHEB09B.PosNormaleFiltree,			
              PtArrSigHEB10,
              BoolRestrictif,             (* aspect croix *)
    	      PtArrCdvHEB13A,
    	      PtArrSpec13A,
              PtArrSigHEB20B,                (* seg 12.1.3 _v2 *)
              BoolRestrictif,             (* aspect croix *)
              AigHEB21.PosReverseFiltree,
	      AigHEB21.PosNormaleFiltree,
              BoolRestrictif,             (* rouge fix fictif v2 *)
              BoolRestrictif,             (* aspect croix *)
(* Variants Anticipes *)
    	      PtArrCdvHEB14,
              PtArrSigHEB44B,
              BoolRestrictif,             (* aspect croix *)
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
	      BoolRestrictif,
              BoolPermissif,
              BaseSorVar);
(*  *)

(* variants troncon 2   voie 1 --> si  *)
   ProcEmisSolTrain( te15s12t02.EmissionSensUp, (2*noBoucle2), 
                     LigneL02+ L0212+ TRONC*02,     

    	      PtArrCdvHEB14,
    	      PtArrCdvTOE11,
    	      PtArrCdvTOE12,
              PtArrCdvTOE13,
              PtArrCdvTOE14,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
                  
	      (* Variants Anticipes *)
	      PtAntCdvHIG11,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
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


(* variants troncon 3    voie E  ---> si  *)
   ProcEmisSolTrain( te21s12t03.EmissionSensUp, (2*noBoucle3), 
                     LigneL02+ L0212+ TRONC*03,     

              PtArrSigHEB44B,
              BoolRestrictif,             (* aspect croix *)
              AigHEB45.PosReverseFiltree,
	      AigHEB45.PosNormaleFiltree,
              PtArrSigHEB46A,
              BoolRestrictif,             (* aspect croix *)
              BoolRestrictif, 
              BoolRestrictif,                     
(* Variants Anticipes *)
              PtArrSigHEB10,
              BoolRestrictif,             (* aspect croix *)
	      AigAntHEA24.PosDeviee,       (* secteur 25 *)      
	      AigAntHEA24.PosNormale,             
              BoolRestrictif,
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
	 
(* variants troncon 4  voie E <-- sp *)
   ProcEmisSolTrain( te23s12t04.EmissionSensUp, (2*noBoucle4), 
                     LigneL02+ L0212+ TRONC*04,     
  
	      PtArrSigHEB46B,
              BoolRestrictif,             (* aspect croix *)
	      PtArrSigHEB44A,
              BoolRestrictif,             (* aspect croix *)
              AigHEB09B.PosReverseFiltree,
              AigHEB09B.PosNormaleFiltree,
              BoolRestrictif,
              BoolRestrictif,
(* Variants Anticipes *)
	      PtArrCdvHEB18,
              BoolRestrictif,
              PtAntSigANB42A,
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



(* variants du troncon 5 voie 2 <-- sp *)
   ProcEmisSolTrain( te26s12t05.EmissionSensUp, (2*noBoucle5), 
                     LigneL02+ L0212+ TRONC*05,     

              PtArrCdvTOE23,
              PtArrCdvTOE22,
              PtArrCdvTOE21,
              PtArrCdvHEB24,
              PtArrSigHEB24,
              BoolRestrictif,             (* aspect croix *)
              BoolRestrictif,
              BoolRestrictif,
(* Variants Anticipes *)
(* rajout de l'EP sur cdv HEB22 le 16/3/1998 FC *)
              PtArrCdvHEB22,
              PtArrSigHEB22,
              BoolRestrictif,             (* aspect croix *)
              TivComHEB22,
              BoolRestrictif,
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
   ProcEmisSolTrain( te31s12t06.EmissionSensUp, (2*noBoucle6), 
                     LigneL02+ L0212+ TRONC*06, 

(* rajout de l'EP HEB 22 - FC 16/3/1998 *)
              PtArrCdvHEB22,
              PtArrSigHEB22,
              BoolRestrictif,              (* aspect croix *)
              TivComHEB22,
              PtArrSigHEB20A,
              BoolRestrictif,              (* aspect croix *)
              AigHEB19B.PosNormaleFiltree, (* tivcom *)
              AigHEB19B.PosReverseFiltree,
              AigHEB19B.PosNormaleFiltree,			
              PtArrCdvHEB18,
              PtArrSigHEB12,
              BoolRestrictif,              (* aspect croix *)
(* Variants Anticipes *)
(* 12 *)      PtAntCdvANA22,
              PtAntCdvANA21,
(* 14 *)      PtArrSigHEB44A,
              BoolRestrictif,              (* aspect croix *)
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolPermissif,
              BaseSorVar + 150);

(*  *)
 
(* reception du secteur 13 -aval- *)

   ProcReceptInterSecteur(trL0213, noBouclehig, LigneL02+ L0213+ TRONC*01,
                  PtAntCdvHIG11,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif, 
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
                  BoucleAmv2.PanneTrans,
		  V4,
                  V5, 
		  V6,
		  BaseEntVar + 1); 
(*  *)

(* reception du secteur 11 -amont- *)

   ProcReceptInterSecteur(trL0211, noBouclecal, LigneL02+ L0211+ TRONC*03,

                  PtAntCdvANA22,
                  PtAntCdvANA21,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif, 
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
                  BoucleAmv1.PanneTrans,
                  V4,
                  V5, 
		  V6,
		  BaseEntVar + 6);

(*  *)

(* reception du secteur 25 -adjacent- ligne 1 *)

   ProcReceptInterSecteur(trL0125, noBouclehea, LigneL01+ L0125+ TRONC*03,
	          AigAntHEA24.PosDeviee,             
	          AigAntHEA24.PosNormale,             
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif, 
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BaseEntVar + 10,
		  V1,
                  V2,
                  BoucleAmvE.PanneTrans,
                  V4,
                  V5, 
		  V6,
		  BaseEntVar + 11);

(* reception du secteur 07 -adjacent- ligne 5 *)

   ProcReceptInterSecteur(trL0507, noBoucleana, LigneL05+ L0507+ TRONC*05,
	          PtAntSigANB42A,
	          BoolRestrictif,             
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif, 
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BaseEntVar + 15,
		  V1,
                  V2,
                  V3,
                  V4,
                  V5, 
		  V6,
		  BaseEntVar + 16);

(*  *)

(* emission vers le secteur 13 -aval- *)

   ProcEmisInterSecteur (teL0213, noBouclehig, LigneL02+ L0212+ TRONC*05,
			noBouclehig,
                  PtArrCdvTOE23,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif, 
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
                  Boucle5.PanneTrans,
		  V4,
                  V5, 
		  V6,
		  BaseSorVar + 180);


(*  *)

(* emission vers le secteur 11 -amont- *)

   ProcEmisInterSecteur (teL0211, noBouclecal, LigneL02+ L0212+ TRONC*01,
			noBouclecal,
                  PtArrCdvHEB08,
                  PtArrSigHEB08,
                  AigHEB09B.PosNormaleFiltree,     (* tivcom *)
                  AigHEB09B.PosReverseFiltree,
                  AigHEB09B.PosNormaleFiltree,			
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif, 
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
                  Boucle1.PanneTrans,
                  V4,
                  V5,
		  V6,
		  BaseSorVar + 210);

(*  *)

(* emission vers le secteur 25 -adjacent- ligne 1 *)

   ProcEmisInterSecteur (teL0125, noBouclehea, LigneL02+ L0212+ TRONC*04,
			noBouclehea,
                  PtArrSigHEB46B,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif, 
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
                  Boucle4.PanneTrans,
                  V4,
                  V5,
		  V6,
		  BaseSorVar + 240);

(* emission vers le secteur 07 -adjacent- ligne 5 *)

   ProcEmisInterSecteur (teL0507, noBoucleana, LigneL02+ L0212+ TRONC*03,
			noBoucleana,
                  PtArrSigHEB44B,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif, 
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
            

 (** Emission invariants vers secteur 13 aval L0213 **)

   EmettreSegm(LigneL02+ L0212+ TRONC*05+ SEGM*00, noBouclehig, SensUp);
   EmettreSegm(LigneL02+ L0212+ TRONC*05+ SEGM*01, noBouclehig, SensUp);

 (** Emission invariants vers secteur 11 amont L0211 **)

   EmettreSegm(LigneL02+ L0212+ TRONC*01+ SEGM*00, noBouclecal, SensUp);
   EmettreSegm(LigneL02+ L0212+ TRONC*01+ SEGM*01, noBouclecal, SensUp);
   EmettreSegm(LigneL02+ L0212+ TRONC*03+ SEGM*00, noBouclecal, SensUp);
   EmettreSegm(LigneL02+ L0212+ TRONC*03+ SEGM*02, noBouclecal, SensUp);

 (** Emission invariants vers secteur 25 adjacent L0125 **)

   EmettreSegm(LigneL02+ L0212+ TRONC*04+ SEGM*00, noBouclehea, SensUp);
   EmettreSegm(LigneL02+ L0212+ TRONC*04+ SEGM*02, noBouclehea, SensUp);

 (** Emission invariants vers secteur 07 adjacent L0507 **)

   EmettreSegm(LigneL02+ L0212+ TRONC*03+ SEGM*00, noBoucleana, SensUp);
   EmettreSegm(LigneL02+ L0212+ TRONC*03+ SEGM*02, noBoucleana, SensUp);
   EmettreSegm(LigneL02+ L0212+ TRONC*03+ SEGM*01, noBoucleana, SensUp);
   EmettreSegm(LigneL02+ L0212+ TRONC*04+ SEGM*00, noBoucleana, SensUp);
   EmettreSegm(LigneL02+ L0212+ TRONC*04+ SEGM*02, noBouclehea, SensUp);


 (** Boucle 1 **)        
   EmettreSegm(LigneL02+ L0212+ TRONC*01+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL02+ L0212+ TRONC*01+ SEGM*01, noBoucle1, SensUp);
   EmettreSegm(LigneL02+ L0212+ TRONC*02+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL02+ L0212+ TRONC*03+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL02+ L0212+ TRONC*03+ SEGM*02, noBoucle1, SensUp);
   EmettreSegm(LigneL02+ L0212+ TRONC*04+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL02+ L0212+ TRONC*04+ SEGM*02, noBoucle1, SensUp);
   EmettreSegm(LigneL02+ L0212+ TRONC*06+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL02+ L0212+ TRONC*06+ SEGM*02, noBoucle1, SensUp);

 (** Boucle 2 **)        
   EmettreSegm(LigneL02+ L0212+ TRONC*02+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL02+ L0213+ TRONC*01+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL02+ L0213+ TRONC*01+ SEGM*01, noBoucle2, SensUp);

 (** Boucle 3 **)  
   EmettreSegm(LigneL02+ L0212+ TRONC*01+ SEGM*00, noBoucle3, SensUp);
   EmettreSegm(LigneL02+ L0212+ TRONC*01+ SEGM*02, noBoucle3, SensUp);
   EmettreSegm(LigneL01+ L0125+ TRONC*03+ SEGM*01, noBoucle3, SensUp);
   EmettreSegm(LigneL01+ L0125+ TRONC*03+ SEGM*02, noBoucle3, SensUp);
   EmettreSegm(LigneL01+ L0125+ TRONC*04+ SEGM*00, noBoucle3, SensUp);

 (** Boucle 4 **)  
   EmettreSegm(LigneL02+ L0212+ TRONC*04+ SEGM*00, noBoucle4, SensUp);
   EmettreSegm(LigneL02+ L0212+ TRONC*04+ SEGM*02, noBoucle4, SensUp);
   EmettreSegm(LigneL02+ L0212+ TRONC*04+ SEGM*01, noBoucle4, SensUp);
   EmettreSegm(LigneL02+ L0212+ TRONC*06+ SEGM*01, noBoucle4, SensUp);
   EmettreSegm(LigneL02+ L0212+ TRONC*06+ SEGM*03, noBoucle4, SensUp);
   EmettreSegm(LigneL02+ L0212+ TRONC*03+ SEGM*00, noBoucle4, SensUp);
   EmettreSegm(LigneL02+ L0212+ TRONC*03+ SEGM*02, noBoucle4, SensUp);
   EmettreSegm(LigneL02+ L0211+ TRONC*03+ SEGM*00, noBoucle4, SensUp);
   EmettreSegm(LigneL05+ L0507+ TRONC*05+ SEGM*00, noBoucle4, SensUp);

 (** Boucle 5 **) 
   EmettreSegm(LigneL02+ L0212+ TRONC*05+ SEGM*00, noBoucle5, SensUp);
   EmettreSegm(LigneL02+ L0212+ TRONC*05+ SEGM*01, noBoucle5, SensUp);
   EmettreSegm(LigneL02+ L0212+ TRONC*06+ SEGM*00, noBoucle5, SensUp);
   EmettreSegm(LigneL02+ L0212+ TRONC*06+ SEGM*01, noBoucle5, SensUp);
  
 (** Boucle 6 **)        
   EmettreSegm(LigneL02+ L0212+ TRONC*06+ SEGM*00, noBoucle6, SensUp);
   EmettreSegm(LigneL02+ L0212+ TRONC*06+ SEGM*01, noBoucle6, SensUp);
   EmettreSegm(LigneL02+ L0212+ TRONC*06+ SEGM*02, noBoucle6, SensUp);
   EmettreSegm(LigneL02+ L0212+ TRONC*06+ SEGM*03, noBoucle6, SensUp);
   EmettreSegm(LigneL02+ L0212+ TRONC*04+ SEGM*00, noBoucle6, SensUp);
   EmettreSegm(LigneL02+ L0212+ TRONC*04+ SEGM*02, noBoucle6, SensUp);
   EmettreSegm(LigneL02+ L0212+ TRONC*04+ SEGM*01, noBoucle6, SensUp);
   EmettreSegm(LigneL02+ L0212+ TRONC*01+ SEGM*03, noBoucle6, SensUp);
   EmettreSegm(LigneL02+ L0211+ TRONC*03+ SEGM*00, noBoucle6, SensUp);
   EmettreSegm(LigneL02+ L0211+ TRONC*03+ SEGM*01, noBoucle6, SensUp);

(*  *) 

(************************* CONFIGURATION DES TRONCONS TSR ****************************)

   ConfigurerTroncon(Tronc0, LigneL02 + L0212 + TRONC*01, 2,2,2,2);  (* troncon 12-1 *)
   ConfigurerTroncon(Tronc1, LigneL02 + L0212 + TRONC*02, 2,2,2,2);  (* troncon 12-2 *)
   ConfigurerTroncon(Tronc2, LigneL02 + L0212 + TRONC*03, 2,2,2,2);  (* troncon 12-3 *)
   ConfigurerTroncon(Tronc3, LigneL02 + L0212 + TRONC*04, 2,2,2,2);  (* troncon 12-4 *)
   ConfigurerTroncon(Tronc4, LigneL02 + L0212 + TRONC*05, 2,2,2,2);  (* troncon 12-5 *)
   ConfigurerTroncon(Tronc5, LigneL02 + L0212 + TRONC*06, 2,2,2,2);  (* troncon 12-6 *)


(******************************* EMISSION DES TSR ************************************)



(** Emission des TSR vers le secteur aval 13 L0213 **)

   EmettreTronc(LigneL02+ L0212+ TRONC*05, noBouclehig, SensUp);


(** Emission des TSR vers le secteur amont 11 L0211 **)

   EmettreTronc(LigneL02+ L0212+ TRONC*01, noBouclecal, SensUp);
   EmettreTronc(LigneL02+ L0212+ TRONC*03, noBouclecal, SensUp);


(** Emission des TSR vers le secteur adjacent 25 L0125 **)

   EmettreTronc(LigneL02+ L0212+ TRONC*04, noBouclehea, SensUp);

(** Emission des TSR vers le secteur adjacent 07 L0507 **)

   EmettreTronc(LigneL02+ L0212+ TRONC*03, noBoucleana, SensUp);
   EmettreTronc(LigneL02+ L0212+ TRONC*04, noBoucleana, SensUp);


 (** Emission des TSR sur les troncons du secteur courant **)

   EmettreTronc(LigneL02+ L0212+ TRONC*01, noBoucle1, SensUp); (* troncon 12-1 *)
   EmettreTronc(LigneL02+ L0212+ TRONC*02, noBoucle1, SensUp);
   EmettreTronc(LigneL02+ L0212+ TRONC*03, noBoucle1, SensUp);
   EmettreTronc(LigneL02+ L0212+ TRONC*04, noBoucle1, SensUp);
   EmettreTronc(LigneL02+ L0212+ TRONC*06, noBoucle1, SensUp);


   EmettreTronc(LigneL02+ L0212+ TRONC*02, noBoucle2, SensUp); (* troncon 12-2 *)
   EmettreTronc(LigneL02+ L0213+ TRONC*01, noBoucle2, SensUp);


   EmettreTronc(LigneL02+ L0212+ TRONC*01, noBoucle3, SensUp);
   EmettreTronc(LigneL01+ L0125+ TRONC*03, noBoucle3, SensUp);
   EmettreTronc(LigneL01+ L0125+ TRONC*04, noBoucle3, SensUp);


   EmettreTronc(LigneL02+ L0212+ TRONC*04, noBoucle4, SensUp); (* troncon 12-4 *)
   EmettreTronc(LigneL02+ L0212+ TRONC*06, noBoucle4, SensUp);
   EmettreTronc(LigneL02+ L0212+ TRONC*03, noBoucle4, SensUp);
   EmettreTronc(LigneL02+ L0211+ TRONC*03, noBoucle4, SensUp);
   EmettreTronc(LigneL05+ L0507+ TRONC*05, noBoucle4, SensUp);


   EmettreTronc(LigneL02+ L0212+ TRONC*05, noBoucle5, SensUp); (* troncon 12-5 *)
   EmettreTronc(LigneL02+ L0212+ TRONC*06, noBoucle5, SensUp);

 
   EmettreTronc(LigneL02+ L0212+ TRONC*06, noBoucle6, SensUp); (* troncon 12-6 *)
   EmettreTronc(LigneL02+ L0212+ TRONC*04, noBoucle6, SensUp);
   EmettreTronc(LigneL02+ L0212+ TRONC*01, noBoucle6, SensUp);
   EmettreTronc(LigneL02+ L0211+ TRONC*03, noBoucle6, SensUp);


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
    StockAdres( ADR( CdvHEB08));
    StockAdres( ADR( SigHEB08kv));
    StockAdres( ADR( SigHEB08kj));
    StockAdres( ADR( SigHEB10));
    StockAdres( ADR( CdvHEB13A));
    StockAdres( ADR( CdvHEB13B));
    StockAdres( ADR( CdvHEB14));
    StockAdres( ADR( CdvTOE11));
    StockAdres( ADR( CdvTOE12));
    StockAdres( ADR( CdvTOE13));
    StockAdres( ADR( CdvTOE14));
    StockAdres( ADR( CdvTOE23));
    StockAdres( ADR( CdvTOE22));
    StockAdres( ADR( CdvTOE21));
    StockAdres( ADR( CdvHEB24));
    StockAdres( ADR( SigHEB24));
    StockAdres( ADR( SigHEB22kv));
    StockAdres( ADR( SigHEB22kj));
    StockAdres( ADR( SigHEB20Akv));
    StockAdres( ADR( SigHEB20Akj));
    StockAdres( ADR( Sp1HEB));
    StockAdres( ADR( Sp2HEB));
    StockAdres( ADR( CdvHEB12));
    StockAdres( ADR( SigHEB20B));
    StockAdres( ADR( SigHEB44A));
    StockAdres( ADR( SigHEB44B));
    StockAdres( ADR( SigHEB46A));
    StockAdres( ADR( SigHEB46B));
    StockAdres( ADR( CdvHEB09));
    StockAdres( ADR( CdvHEB21));
    StockAdres( ADR( CdvHEB23B));
    StockAdres( ADR( CdvHEB25));
    StockAdres( ADR( CdvHEB45));
    StockAdres( ADR( SigHEB12));
    StockAdres( ADR( CdvHEB22));
    StockAdres( ADR( CdvHEB18));
    StockAdres( ADR( CdvHEB20));

    StockAdres( ADR( AigHEB09B));
    StockAdres( ADR( AigHEB19B));
    StockAdres( ADR( AigHEB21));
    StockAdres( ADR( AigHEB45));

    StockAdres( ADR( PtArrCdvHEB08));
    StockAdres( ADR( PtArrSigHEB08));
    StockAdres( ADR( PtArrSigHEB10));
    StockAdres( ADR( PtArrCdvHEB12));
    StockAdres( ADR( PtArrCdvHEB13A));
(*  modif du 08/03/2000 : modif. de la gestion du SP2 *)
    StockAdres( ADR( PtArrSpec13A));
(*    StockAdres( ADR( PtArrCdvHEB13B));              *)
    StockAdres( ADR( PtArrCdvHEB14));
    StockAdres( ADR( PtArrCdvTOE11));
    StockAdres( ADR( PtArrCdvTOE12));
    StockAdres( ADR( PtArrCdvTOE13));
    StockAdres( ADR( PtArrCdvTOE14));
    StockAdres( ADR( PtArrCdvTOE23));
    StockAdres( ADR( PtArrCdvTOE22));
    StockAdres( ADR( PtArrCdvTOE21));
    StockAdres( ADR( PtArrCdvHEB24));
    StockAdres( ADR( PtArrSigHEB24));
    StockAdres( ADR( PtArrSigHEB22));
    StockAdres( ADR( PtArrSigHEB20A));
    StockAdres( ADR( PtArrCdvHEB18));
    StockAdres( ADR( PtArrSigHEB44A));
    StockAdres( ADR( PtArrSigHEB44B));
    StockAdres( ADR( PtArrSigHEB46A));
    StockAdres( ADR( PtArrSigHEB46B));
    StockAdres( ADR( PtArrSigHEB12));
    StockAdres( ADR( PtArrSigHEB20B));

(* FC du 16/3/1998 - rajout de l'EP sur cdv HEB22 *)
    StockAdres( ADR( PtArrCdvHEB22));

    StockAdres( ADR( TivComHEB22));

    StockAdres( ADR( PtAntCdvHIG11));
    StockAdres( ADR( PtAntCdvANA22));
    StockAdres( ADR( PtAntCdvANA21));
    StockAdres( ADR( PtAntSigANB42A));
    StockAdres( ADR( AigAntHEA24));

(* Memorisation des etats precedents de cdvHEB20 et SP1 et bascule *)
    StockAdres( ADR( EtatBasc));
    StockAdres( ADR( EtatBascPrec));
    StockAdres( ADR( CdvHEB20prec));
    StockAdres( ADR( Sp1HEBprec));

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
   InitSpecDivers1;
   InitSpecDivers2;

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
VAR BoolTr, BoolSp,
    BoolReset, BoolSet, BoolReel,
    TmpCdv20p, TmpReset            : BoolLD;
BEGIN (* ExeSpecific *)

(* Affectation des "constantes" utilisees dans la construction des messages emis    *)
(* et recus sur les boucles de transmission continue et sur les liens intersecteur. *)
(* Cette reaffectation est necessaire a chaque cycle pour la mise en securite.      *)
   AffectBoolC(Vrai, BoolPermissif)  ;
   AffectBoolC(Faux, BoolRestrictif) ;

(* regulation *)
  CdvHEB12Fonc := CdvHEB12.F = Vrai.F;
  CdvHEB22Fonc := CdvHEB22.F = Vrai.F;
  CdvTOE12Fonc := CdvTOE12.F = Vrai.F;
  CdvTOE22Fonc := CdvTOE22.F = Vrai.F;

(*  *)
(******************************* FILTRAGE DES AIGUILLES **********************************)

  FiltrerAiguille( AigHEB09B, BaseExeAig);
  FiltrerAiguille( AigHEB19B, BaseExeAig+2);
  FiltrerAiguille( AigHEB21,  BaseExeAig+4);
  FiltrerAiguille( AigHEB45,  BaseExeAig+6);

(******************* Gerer les Tiv Com non lies a une aiguille ****************)

   AffectBoolD( SigHEB22kv,                 TivComHEB22);

(************************** Gerer les point d'arrets **************************)

   AffectBoolD( CdvHEB08,                   PtArrCdvHEB08);
   OuDD(        SigHEB08kv,   SigHEB08kj,   PtArrSigHEB08);
   AffectBoolD( SigHEB10,                   PtArrSigHEB10);
   EtDD(        CdvHEB12,     CdvHEB13A,    PtArrCdvHEB12);
   EtDD(        CdvHEB13A,    CdvHEB13B,    PtArrCdvHEB13A);
   
(*  modif du 08/03/2000 : modif. de la gestion du SP2         *)
   NonD(        Sp2HEB,                     PtArrSpec13A);
(*   NonD( Sp2HEB, BoolTr);                                   *)
(*   EtDD(        CdvHEB13B,    BoolTr,       PtArrCdvHEB13B);*)

   
   AffectBoolD( CdvHEB14,                   PtArrCdvHEB14);
   AffectBoolD( CdvTOE11,                   PtArrCdvTOE11);
   AffectBoolD( CdvTOE12,                   PtArrCdvTOE12);
   AffectBoolD( CdvTOE13,                   PtArrCdvTOE13);
   AffectBoolD( CdvTOE14,                   PtArrCdvTOE14);

   AffectBoolD( CdvTOE23,                   PtArrCdvTOE23);
   AffectBoolD( CdvTOE22,                   PtArrCdvTOE22);
   AffectBoolD( CdvTOE21,                   PtArrCdvTOE21);
   AffectBoolD( CdvHEB24,                   PtArrCdvHEB24);
   AffectBoolD( SigHEB24,                   PtArrSigHEB24);
   OuDD(        SigHEB22kv,   SigHEB22kj,   PtArrSigHEB22);

(* annule le 14/12/98 :
  * PtArrSigHEB20A = (kv ou kj) et non Sp1 et non (Sp2 et Aig deviee) *
   OuDD(        SigHEB20Akv,  SigHEB20Akj,  PtArrSigHEB20A);
   NonD( Sp1HEB, BoolTr);
   EtDD(        PtArrSigHEB20A, BoolTr,     PtArrSigHEB20A);
   EtDD(        Sp2HEB, AigHEB21.PosReverseFiltree, BoolTr);
   NonD( BoolTr, BoolTr);
   EtDD(        PtArrSigHEB20A, BoolTr,     PtArrSigHEB20A); *)

(* ajout le 14/12/98 : *)
   EtDD( AigHEB21.PosReverseFiltree, Sp2HEB,   BoolReset );
   OuDD( BoolReset,                  Sp1HEB,   BoolReset );
   EtDD( BoolReset,                  CdvHEB20, BoolReset );

   NonD( Sp1HEB,       BoolSet   );
   EtDD( Sp1HEBprec,   BoolSet,    BoolSet);
   NonD( CdvHEB20prec, TmpCdv20p );
   OuDD( BoolSet,      TmpCdv20p,  BoolSet );
   EtDD( CdvHEB20,     BoolSet,    BoolSet );

   OuDD( SigHEB20Akv, SigHEB20Akj, BoolReel );

   NonD( BoolReset,     TmpReset );
   EtDD( TmpReset,      EtatBascPrec,   EtatBasc );
   OuDD( EtatBasc,  BoolSet,        EtatBasc );
   EtDD( EtatBasc,  BoolReel,       PtArrSigHEB20A );

   AffectBoolD( CdvHEB20, CdvHEB20prec );
   AffectBoolD( Sp1HEB, Sp1HEBprec );
   AffectBoolD( EtatBasc, EtatBascPrec);

   AffectBoolD( CdvHEB18,                   PtArrCdvHEB18);

(* rajout du 16/3/1998 - EP sur HEB22 *)
   OuDD( CdvHEB21, AigHEB21.PosReverseFiltree, BoolSp);
   EtDD( BoolSp, CdvHEB22, PtArrCdvHEB22); 

   AffectBoolD( SigHEB44A,                  PtArrSigHEB44A);
   AffectBoolD( SigHEB44B,                  PtArrSigHEB44B);
   AffectBoolD( SigHEB46A,                  PtArrSigHEB46A);
   AffectBoolD( SigHEB46B,                  PtArrSigHEB46B);

   AffectBoolD( SigHEB12,                   PtArrSigHEB12);
   AffectBoolD( SigHEB20B,                  PtArrSigHEB20B);


(*** lecture des entrees de regulation ***)

   LireEntreesRegul;

END ExeSpecific;
END Specific.
