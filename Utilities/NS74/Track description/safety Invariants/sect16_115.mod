IMPLEMENTATION MODULE Specific;

(*$S- *)
(*$T- *)

(******************************************************************************
*   SANTIAGO - LIGNE 2 - Secteur 16
*  =============================
*  Version : 1.0.1
*  Date    : 17/04/1997
*  Auteur  : Marc Plywacz
*  Premiere Version
******************************************************************************)
(* FC: le 20/08/1997 : correction suite a demande du site; prb de
	franchissement de la frontiere secteur 16 -> 15 dans emission des TSR *)

(* !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! *
 * ATTENTION : l'etat du PtArrCdvOVA12 est   *
 * calcule mais pas utilise.                 *
 * ATTENTION : l'etat du PtArrCdvOVA22 est   *
 * calcule mais pas utilise.                 *
 * ATTENTION : le CdvOVA20 est ajoute sur    *
 * l'entree 44.                              *
 * !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! *)

(* Version 1.0.2 : auteur F. Chanier
   nature : Eq Developpement
   date : 30/09/1997                  *)             
                                       
(* Version 1.0.3 : auteur F. Chanier
   nature : Eq Developpement - detection des defaillances d'ampli
		+ 
	    Mise en place de l'EP PtArrCdvOVA12 et emission dans troncon 2;
            calcul (OVA12 et (OVA 13 ou AigOVA23deviee))
   date : 23/1/1998                  *)             
                                       
(* Version 1.0.4 : auteur F. Chanier
   nature : Eq Developpement 
		+ 
   Mise en place d'un EP sur V1 a Ciudad del Nino
   date : 6/4/1998                  *)             
(*---------------------------------------------------------------------------*)
(*****************************************************************************)
(***            AJOUT DE LA NUMEROTATION SCCS DES VERSIONS                ****)
(*---------------------------------------------------------------------------*)
(* Version 1.0.5  =====================                                      *)
(* Version 1.6 DU SERVEUR SCCS =====================                         *)
(* Date :         21/09/1998                                                 *)
(* Auteur:        H. Le Roy                                                  *)
(* Modification : Fiche d'anomalie ba040998                                  *)
(*                Suite a un changement de vitesses maximales, mise a jour   *)
(*                des marches types                                          *)
(*****************************************************************************)
(* Version 1.0.6  =====================                                      *)
(* Version 1.7 DU SERVEUR SCCS =====================                         *)
(* Date :         27/11/1998                                                 *)
(* Auteur:        H. Le Roy                                                  *)
(* Modification : Demande Eq Dvt                                             *)
(*                 mise a jour d'emission d'invariants et troncons pour le   *)
(*                 retournement 14-22-24                                     *)
(*****************************************************************************)
(* Version 1.0.7  =====================                                      *)
(* Version 1.8 DU SERVEUR SCCS =====================                         *)
(* Date :         15/04/1999                                                 *)
(* Auteur:        H. Le Roy                                                  *)
(* Modification : Adaptation de la configuration des amplis au standard      *)
(*                 1.3.3. Suppression de parties de code inutiles concernant *)
(*                 les DAMTC.                                                *)
(*****************************************************************************)
(* Version 1.0.8  =====================                                      *)
(* Version 1.9 DU SERVEUR SCCS =====================                         *)
(* Date :         05/07/1999                                                 *)
(* Auteur:        H. Le Roy                                                  *)
(* Modification : Configuration des entrees associees a des fusible          *)
(*****************************************************************************)
(* Version 1.0.9  =====================                                      *)
(* Version 1.10 DU SERVEUR SCCS =====================                        *)
(* Date :         27/06/2000                                                 *)
(* Auteur:        H. Le Roy                                                  *)
(* Modification : Am 165 : Configuration des marches types                   *)
(*                                                                           *)
(*****************************************************************************)
(* Version 1.1.0  =====================                                      *)
(* Version 1.11 DU SERVEUR SCCS =====================                        *)
(* Date :         18/03/2004                                                 *)
(* Auteur:        Marc Plywacz                                               *)
(* Modification : Prolongement 1 de la ligne 2.                              *)
(*                                                                           *)
(*****************************************************************************)
(* Version 1.1.1  =====================                                      *)
(* Version 1.12 DU SERVEUR SCCS =====================                        *)
(* Date :         28/10/2004                                                 *)
(* Auteur:        Marc Plywacz                                               *)
(* Modifications : data checking prolongement 1.                             *)
(* troncon 16.2 supprime trans seg 16.2.3                                    *)
(* troncon 16.4 supprime trans seg 16.2.3                                    *)
(* troncon 16.2 supprime PtArrCdvOVA12                                       *)
(* troncon 16.5 remplace PtArrCdvOVA18 par PtArrCdvNIN22                     *)
(* troncon 16.6 supprime PtArrCdvOVA18                                       *)
(*                                                                           *)
(*****************************************************************************)
(* Version 1.1.2  =====================                                      *)
(* Version 1.13 DU SERVEUR SCCS =====================                        *)
(* Date :         09/11/2004                                                 *)
(* Auteur:        Ph. Hog                                                    *)
(* Modifications : data checking prolongement 1.                             *)
(* Inversion des entrees du signal OVA12 :                                   *)
(* SigOVA12kv passe de l'entree 12 a l'entree 14                             *)
(* SigOVA12kj passe de l'entree 14 a l'entree 12                             *)
(*                                                                           *)
(*****************************************************************************)
(* Version 1.1.3  =====================                                      *)
(* Version 1.14 DU SERVEUR SCCS =====================                        *)
(* Date :         17/11/2004                                                 *)
(* Auteur:        Ph. Hog                                                    *)
(* Modifications : data checking prolongement 1.                             *)
(* Changement de nom des entrées suivantes :                                 *)
(*    Sp1OVA renomee en AxCIv2                                               *)
(*    Sp2OVA renomee en CIsp1D                                               *)
(* Ajout de l'entree CdvOVA19B sur l'entree 19                               *)
(* Ajout de l'affectation du PtArrCdvOVA24, = CdvOVA24                       *)
(* Ajout de l'affectation du PtArrSigOVA22, = SigOVA22                       *)
(* Changement d'affectation des entrées suivantes :                          *)
(*    PtArrSpeOVA14F devient NON AxCIv2 au lieu de "Sp2OVA" (CIsp1D)         *)
(*    PtArrSpeOVA20  devient NON CIsp1D ET CdvOVA20 ET CdvOVA19B             *)
(*                                      au lieu de "Sp1OVA" (AxCIv2)         *)
(*    PtArrCdvOVA22  devient CdvOVA22B ET CdvOVA22A ET Cdv OVA20             *)
(*                                      au lieu de CdvOVA22A ET Cdv OVA20    *)
(*                                                                           *)
(*****************************************************************************)
(* Version 1.1.4  =====================                                      *)
(* Version 1.15 DU SERVEUR SCCS =====================                        *)
(* Date :         03/12/2004                                                 *)
(* Auteur:        Marc Plywacz                                               *)
(* Modifications : data checking prolongement 1.                             *)
(* Decalage rang variants :                                                  *)
(*   Troncon 16.5 : rang variants anticipees = 5 (pos 13) au lieu de 4       *)
(* Modif PtArrCdvOVA22 :                                                     *)
(*   anciennes conditions = CdvOVA22B ET CdvOVA22A ET Cdv OVA20              *)
(*   nouvelles conditions = CdvOVA22A ET Cdv OVA20                           *)
(* Ajustement marches Types                                                  *)
(*****************************************************************************)
(* Version 1.1.5  =====================                                      *)
(* Version 1.16 DU SERVEUR SCCS =====================                        *)
(* Date :         07/08/2006                                                 *)
(* Auteur:        Rudy Nsiona                                                *)
(* Modification : Nouveau Train NS2004                                       *)
(* Procédure CONFIGURATION DES TRONCONS TSR                                  *)
(*                ancienne valeur 1 , nouvelle 2                             *)


(******************************  IMPORTATIONS  *******************************)

FROM SYSTEM     IMPORT ADR;

FROM Opel       IMPORT StockAdres, AffectBoolD, AffectBoolC, BoolC, BoolD, EtDD, CodeD, NonD,
		       Tvrai, FinBranche, FinArbre, AffectC, OuDD, BoolLD;

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

              		Ampli11, Ampli12, Ampli13, Ampli14, Ampli15, 
              		Ampli21, Ampli22, Ampli23, Ampli24, Ampli25, Ampli26, 
       			Ampli27,Ampli28,
              		Ampli31, Ampli32, Ampli33, Ampli34, Ampli35, Ampli36,
              		Ampli41, Ampli42, Ampli43, Ampli44, Ampli45, Ampli46,
              		Ampli51, Ampli52, Ampli53, Ampli54, Ampli55, Ampli56,
              		Ampli57, Ampli58, Ampli59, Ampli5A,
              		Ampli61, Ampli62, Ampli63, Ampli64, Ampli65, Ampli66,
            		Ampli67, Ampli68, Ampli69, Ampli6A,     

(* variables *)
                       Boucle1, Boucle2, Boucle3, Boucle4, Boucle5, Boucle6, BoucleFictive,
		       CarteCes1,  CarteCes2,  CarteCes3, CarteCes4, CarteCes5, CarteCes6,
                       Intersecteur1,

(* PROCEDURES *)       
                       ConfigurerBoucle,
                       ConfigurerAmpli,
                       ConfigurerIntsecteur,
                       DeclarerVersionSpecific,
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
(*  *)
(*****************************  CONSTANTES  ***********************************)

CONST

(** No ligne, No secteur, ....**)


    LigneL02 = 16384*00; (* numero de ligne decale de 2**14 *)

    L0217  = 1024*17;    (* numero Secteur aval voie impaire decale de 2**10 *)

    L0216  = 1024*16;    (* numero Secteur local decale de 2**10 *)

    L0215  = 1024*15;    (* numero Secteur amont voie impaire decale de 2**10 *)


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

(** No des stations du secteur 16 **)
(* ligne 1: 1,2 ; ligne 2: 3,4; ligne 5: 5,6 *)
    noNINv1 = 3*32 + 12;
    noNINv2 = 3*32 + 2;
    noOVAv1 = 3*32 + 13;
    noOVAv2 = 3*32 + 1;

(** indication de sens **)
    SensUp = TRUE;

(** No de Voie d'emissions SOL-Train, d'emission/reception inter-secteur **)
    
    noBoucleCit = 00; 
    noBoucleVia = 01; 
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
(***************** DECLARATION DES VARIABLES GENERALES **********************)
 VAR
          (*    Bouclehig, *) Bouclevia, Bouclefi : TyBoucle;


(* DECLARATION DES SINGULARITES DU SECTEUR 16: dans les deux sens confondus *)


(* Declaration des variables correspondant a des entrees securitaires  *)
(*   - CDV et signaux                                                  *)
    CdvOVA06,        (* entree  1, soit entree 0 de CES 02  *)
    CdvOVA07,        (* entree  2, soit entree 1 de CES 02  *)
    SigOVA07kv,      (* entree  3, soit entree 2 de CES 02  *)
    SigOVA07kj,      (* entree  4, soit entree 3 de CES 02  *)
    SigOVA08,        (* entree  7, soit entree 6 de CES 02  *)
    SigOVA10kv,      (* entree  8, soit entree 7 de CES 02  *)
 (* res  SigOVA10kj,*)   (* entree  9, soit entree 0 de CES 03  *)
    SigOVA12kj,      (* entree 12, soit entree 3 de CES 03  *)
 (* res SigOVA14B,  *)   (* entree 13, soit entree 4 de CES 03  *)
    SigOVA12kv,      (* entree 14, soit entree 5 de CES 03  *)
    SigOVA22,       (* entree 15, soit entree 6 de CES 03  *)
 (* res  SigOVA24B, *)   (* entree 18, soit entree 1 de CES 04  *)
    CdvOVA19B,       (* entree 19, soit entree 2 de CES 04  *)
 (* res  SigOVA15,  *)   (* entree 20, soit entree 3 de CES 04  *)
    SigOVA14,        (* entree 21, soit entree 4 de CES 04  *)
 (* res  SigOVA25,  *)   (* entree 22, soit entree 5 de CES 04  *)
    SigOVA24,        (* entree 23, soit entree 6 de CES 04  *)
 (* res  SigOVA22A, *)   (* entree 24, soit entree 7 de CES 04  *)
    SigOVA20kv,      (* entree 25, soit entree 0 de CES 05  *)
    SigOVA20kj,      (* entree 26, soit entree 1 de CES 05  *)
    CdvOVA18,        (* entree 29, soit entree 4 de CES 05  *)
    CdvNIN22,        (* entree 30, soit entree 5 de CES 05  *)
    CdvNIN21,        (* entree 31, soit entree 6 de CES 05  *)
    CdvNIN20,        (* entree 32, soit entree 7 de CES 05  *)

    SigOVAZB,        (* entree 33, soit entree 0 de CES 06  *)
 (* res  SigOVAZA,  *)   (* entree 34, soit entree 1 de CES 06  *)
    SigOVA38B,       (* entree 35, soit entree 2 de CES 06  *)
    CdvOVA08,        (* entree 38, soit entree 5 de CES 06  *)
    CdvOVA13,        (* entree 39, soit entree 6 de CES 06  *)
 (* res  CdvOVA15V1,*)   (* entree 40, soit entree 7 de CES 06  *)

    CdvOVA12,      (* entree 41, soit entree 0 de CES 07  *)
    CdvOVA22A,     (* entree 42, soit entree 1 de CES 07  *)
    SigOVA38A,     (* entree 43, soit entree 2 de CES 07  *)
    CdvOVA20,      (* entree 44, soit entree 3 de CES 07  *)
    AxCIv2,        (* entree 45, soit entree 4 de CES 07  *)
    CIsp1D,        (* entree 46, soit entree 5 de CES 07  *)
    CdvOVA22B,     (* entree 47, soit entree 1 de CES 07  *)
    CdvOVA24       (* entree 48, soit entree 1 de CES 07  *)
             : BoolD;

(*   - aiguilles                                                       *)
    AigOVA08,      (* entrees  5 et  6, soit entrees 4 et 5 de CES 02  *)
  (*  AigOVA11, *)     (* entrees 10 et 11, soit entrees 1 et 2 de CES 03  *)
    AigOVA23,      (* entrees 16 et 17, soit entrees 7 et 0 de CES 03 et 04 *)
    AigOVA19A,     (* entrees 27 et 28, soit entrees 2 et 3 de CES 05  *)
    AigOVA09       (* entrees 36 et 37, soit entrees 3 et 4 de CES 06  *)
             :TyAig;



(* Variables ne correspondant pas a une entree securitaire *)
(* Point d'arret *)
    PtArrCdvOVA06,
    PtArrCdvOVA07,
    PtArrSigOVA07,
    PtArrSigOVA08,
    PtArrSigOVA10,
    PtArrCdvOVA12,
    PtArrSigOVA12,
    PtArrSpeOVA14F,
    PtArrSigOVAZB,
    PtArrSigOVA22,
    PtArrCdvOVA24,

    PtArrSigOVA14,
    PtArrSigOVA24,
    PtArrCdvOVA22,
    PtArrSpeOVA20,
    PtArrSigOVA20,
    PtArrSigOVA38B,
    PtArrCdvOVA18,
    PtArrCdvNIN22,
    PtArrCdvNIN21,
    PtArrCdvNIN20  : BoolD;

(* Variants anticipes *)

    PtAntCdvPAR11,
    PtAntCdvPAR12,
    PtAntCdvDEP23  : BoolD;

 (* Tiv Com *)

    TivComSigOVA12kv          : BoolD;

(* Copie des entrees dans des variables fonctionnelles pour la regulation *)
    CdvOVA22Fonc,
    CdvOVA12Fonc,
    CdvOVA07Fonc,
    CdvNIN22Fonc     : BOOLEAN;

(** Voie d'emission SOL-TRAIN : deux sens confondus**)
    te11s16t01,
    te14s16t02,
    te21s16t03,
    te24s16t04,
    te31s16t05,
    te35s16t06           :TyEmissionTele;
	 			
(** Voie d'emission Inter-secteur deux voies confondues **)
    teL02fi, 
    teL0217,
    teL0215	          :TyEmissionTele;

(** Voie de reception Inter-secteur deux voies confondues **)
    trL02fi, 
    trL0217,
    trL0215               :TyCaracEntSec;
    	 


(* boucle en amont des  voies *)
    BoucleAmv1,
    BoucleAmv2            :TyBoucle;


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

DeclarerVersionSpecific (33);


(******************** CONFIGURATIONS DIVERSES ***********************)

(* CONFIGURATION DES AIGUILLES, POUR LES DEUX VOIES *)
    EntreeAiguille( AigOVA08,   6,  5);  (* kag D = pos normale *)
  (*  EntreeAiguille( AigOVA11,  11, 10); *) (* kag D = pos normale *)
    EntreeAiguille( AigOVA23,  16, 17);  (* kag G = pos normale *)
    EntreeAiguille( AigOVA19A, 28, 27);  (* kag D = pos normale *)
    EntreeAiguille( AigOVA09,  36, 37);  (* kag G = pos normale *)

(* Configuration des entrees *)
    ProcEntreeIntrins (  1, CdvOVA06);
    ProcEntreeIntrins (  2, CdvOVA07);
    ProcEntreeIntrins (  3, SigOVA07kv);
    ProcEntreeIntrins (  4, SigOVA07kj);
    ProcEntreeIntrins (  7, SigOVA08);
    ProcEntreeIntrins (  8, SigOVA10kv);
  (*  ProcEntreeIntrins (  9, SigOVA10kj); *)
    ProcEntreeIntrins ( 12, SigOVA12kj);
  (*  ProcEntreeIntrins ( 13, SigOVA14B);  *)
    ProcEntreeIntrins ( 14, SigOVA12kv);
    ProcEntreeIntrins ( 15, SigOVA22);
  (*  ProcEntreeIntrins ( 18, SigOVA24B);  *)
    ProcEntreeIntrins ( 19, CdvOVA19B);
  (*  ProcEntreeIntrins ( 20, SigOVA15);   *)
    ProcEntreeIntrins ( 21, SigOVA14);
  (*  ProcEntreeIntrins ( 22, SigOVA25);   *)
    ProcEntreeIntrins ( 23, SigOVA24);
  (*  ProcEntreeIntrins ( 24, SigOVA22A);  *)
    ProcEntreeIntrins ( 25, SigOVA20kv);
    ProcEntreeIntrins ( 26, SigOVA20kj);
    ProcEntreeIntrins ( 29, CdvOVA18);
    ProcEntreeIntrins ( 30, CdvNIN22);
    ProcEntreeIntrins ( 31, CdvNIN21);
    ProcEntreeIntrins ( 32, CdvNIN20);

    ProcEntreeIntrins ( 33, SigOVAZB);
  (*  ProcEntreeIntrins ( 34, SigOVAZA); *)
    ProcEntreeIntrins ( 35, SigOVA38B);
    ProcEntreeIntrins ( 38, CdvOVA08);
    ProcEntreeIntrins ( 39, CdvOVA13);
  (* ProcEntreeIntrins ( 40, CdvOVA15V1); *)
    ProcEntreeIntrins ( 41, CdvOVA12);
    ProcEntreeIntrins ( 42, CdvOVA22A);
    ProcEntreeIntrins ( 43, SigOVA38A);
    ProcEntreeIntrins ( 44, CdvOVA20);
    ProcEntreeIntrins ( 45, AxCIv2);
    ProcEntreeIntrins ( 46, CIsp1D);
    ProcEntreeIntrins ( 47, CdvOVA22B);
    ProcEntreeIntrins ( 48, CdvOVA24);


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

   ConfigurerAmpli(Ampli21, 2, 1, 193, 14, FALSE);
   ConfigurerAmpli(Ampli22, 2, 2, 194, 15, FALSE);
   ConfigurerAmpli(Ampli23, 2, 3, 195, 15, FALSE);
   ConfigurerAmpli(Ampli24, 2, 4, 196, 15, TRUE);
   ConfigurerAmpli(Ampli25, 2, 5, 197, 16, FALSE);    
   ConfigurerAmpli(Ampli26, 2, 6, 198, 16, FALSE);     
   ConfigurerAmpli(Ampli27, 2, 7, 199, 16, TRUE);
   ConfigurerAmpli(Ampli28, 2, 8, 200, 13, TRUE);    

   ConfigurerAmpli(Ampli31, 3, 1, 203, 21, FALSE);
   ConfigurerAmpli(Ampli32, 3, 2, 204, 22, FALSE);
   ConfigurerAmpli(Ampli33, 3, 3, 205, 22, FALSE);
   ConfigurerAmpli(Ampli34, 3, 4, 206, 22, TRUE);
   ConfigurerAmpli(Ampli35, 3, 5, 207, 23, FALSE);
   ConfigurerAmpli(Ampli36, 3, 6, 208, 23, TRUE);

   ConfigurerAmpli(Ampli41, 4, 1, 210, 24, FALSE);
   ConfigurerAmpli(Ampli42, 4, 2, 211, 25, FALSE);
   ConfigurerAmpli(Ampli43, 4, 3, 212, 25, FALSE);
   ConfigurerAmpli(Ampli44, 4, 4, 213, 25, TRUE);
(*  ConfigurerAmpli(Ampli45, 4, 5, 214, 26, FALSE);    
    ConfigurerAmpli(Ampli46, 4, 6, 215, 26, TRUE);     *)
     
   ConfigurerAmpli(Ampli51, 5, 1, 218, 31, FALSE);
   ConfigurerAmpli(Ampli52, 5, 2, 219, 32, FALSE);
   ConfigurerAmpli(Ampli53, 5, 3, 220, 32, FALSE);
   ConfigurerAmpli(Ampli54, 5, 4, 221, 32, TRUE);
   ConfigurerAmpli(Ampli55, 5, 5, 222, 33, FALSE);    
   ConfigurerAmpli(Ampli56, 5, 6, 223, 33, FALSE);     
   ConfigurerAmpli(Ampli57, 5, 7, 256, 33, TRUE);
   ConfigurerAmpli(Ampli58, 5, 8, 257, 34, FALSE);   
   ConfigurerAmpli(Ampli59, 5, 9, 258, 34, FALSE);
   ConfigurerAmpli(Ampli5A, 5, 10, 259, 34, TRUE);
                                                 
   ConfigurerAmpli(Ampli61, 6, 1, 260, 35, FALSE);
   ConfigurerAmpli(Ampli62, 6, 2, 261, 36, FALSE);
   ConfigurerAmpli(Ampli63, 6, 3, 262, 36, FALSE);
   ConfigurerAmpli(Ampli64, 6, 4, 263, 36, TRUE);
   ConfigurerAmpli(Ampli65, 6, 5, 264, 37, FALSE);    
   ConfigurerAmpli(Ampli66, 6, 6, 265, 37, FALSE);
   ConfigurerAmpli(Ampli67, 6, 7, 266, 37, TRUE);     
   ConfigurerAmpli(Ampli68, 6, 8, 267, 38, FALSE);   
   ConfigurerAmpli(Ampli69, 6, 9, 268, 38, FALSE);
   ConfigurerAmpli(Ampli6A, 6, 10, 269, 38, TRUE);
                                                
 (** cartes CES **)
   ConfigurerCES(CarteCes1, 01);
   ConfigurerCES(CarteCes2, 02);
   ConfigurerCES(CarteCes3, 03);
   ConfigurerCES(CarteCes4, 04);
   ConfigurerCES(CarteCes5, 05);
   ConfigurerCES(CarteCes6, 06);


(** Liaisons Inter-Secteur **)

   ConfigurerIntsecteur(Intersecteur1, 01, trL0217, trL0215);


(* Initialisations des variables ne correspondant pas a des entrees secu *)
(* Point d'arret *)
    AffectBoolD( BoolRestrictif, PtArrCdvOVA06);
    AffectBoolD( BoolRestrictif, PtArrCdvOVA07);
    AffectBoolD( BoolRestrictif, PtArrSigOVA07);
    AffectBoolD( BoolRestrictif, PtArrSigOVA08);
    AffectBoolD( BoolRestrictif, PtArrSigOVA10);
    AffectBoolD( BoolRestrictif, PtArrCdvOVA12);
    AffectBoolD( BoolRestrictif, PtArrSigOVA12);
    AffectBoolD( BoolRestrictif, PtArrSpeOVA14F);
    AffectBoolD( BoolRestrictif, PtArrSigOVAZB);
    AffectBoolD( BoolRestrictif, PtArrSigOVA22);
    AffectBoolD( BoolRestrictif, PtArrCdvOVA24);
    AffectBoolD( BoolRestrictif, PtArrSigOVA14);
    AffectBoolD( BoolRestrictif, PtArrSigOVA24);
    AffectBoolD( BoolRestrictif, PtArrCdvOVA22);
    AffectBoolD( BoolRestrictif, PtArrSpeOVA20);
    AffectBoolD( BoolRestrictif, PtArrSigOVA20);
    AffectBoolD( BoolRestrictif, PtArrSigOVA38B);
    AffectBoolD( BoolRestrictif, PtArrCdvOVA18);
    AffectBoolD( BoolRestrictif, PtArrCdvNIN22);
    AffectBoolD( BoolRestrictif, PtArrCdvNIN21);
    AffectBoolD( BoolRestrictif, PtArrCdvNIN20);

(* Variants anticipes *)
    AffectBoolD( BoolRestrictif, PtAntCdvPAR11);
    AffectBoolD( BoolRestrictif, PtAntCdvPAR12);
    AffectBoolD( BoolRestrictif, PtAntCdvDEP23);

 (* Tiv Com *)
   AffectBoolD( BoolRestrictif, TivComSigOVA12kv );

(* regulation *)
    CdvOVA22Fonc := FALSE;
    CdvOVA12Fonc := FALSE;
    CdvOVA07Fonc := FALSE;
    CdvNIN22Fonc := FALSE;

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
   
(* CONFIGURATION DES VOIES D'EMISSION **************************)

   ConfigEmisTeleSolTrain ( te11s16t01,
                            noBoucle1,         
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te14s16t02,
                            noBoucle2,         
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);
   
   ConfigEmisTeleSolTrain ( te21s16t03,
                            noBoucle3,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te24s16t04,
                            noBoucle4,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);
 
   ConfigEmisTeleSolTrain ( te31s16t05,
                            noBoucle5,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);
  
   ConfigEmisTeleSolTrain ( te35s16t06,
                            noBoucle6,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

(* CONFIGURATION POUR LA REGULATION *)
   ConfigQuai (42, 74, CdvOVA07Fonc, te11s16t01, 0, 4,  7,  7,  7, 13, 14, 15);  (* voie 1 C. d. NINO *)
   ConfigQuai (42, 79, CdvNIN22Fonc, te35s16t06, 0, 3,  4, 11,  5, 13, 14, 15);  (* voie 2 C. d. NINO *)
   ConfigQuai (43, 69, CdvOVA22Fonc, te31s16t05, 0, 9, 11,  5,  6, 13, 14, 15);
   ConfigQuai (43, 64, CdvOVA12Fonc, te14s16t02, 0, 8,  4, 11, 10, 13, 14, 15);

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
   ProcEmisSolTrain( te11s16t01.EmissionSensUp, (2*noBoucle1), 
                     LigneL02+ L0216+ TRONC*01,     

              PtArrCdvOVA06,
              PtArrCdvOVA07,
              PtArrSigOVA07,
              BoolRestrictif,             (* aspect croix *)
              AigOVA08.PosNormaleFiltree,     (* tivcom *)
              AigOVA08.PosReverseFiltree,
              AigOVA08.PosNormaleFiltree,			
              PtArrSigOVA08,
              BoolRestrictif,             (* aspect croix *)
(* Variants Anticipes *)
              PtArrSigOVA10,
              BoolRestrictif,
              PtArrSigOVAZB,
              BoolRestrictif,
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
   ProcEmisSolTrain( te14s16t02.EmissionSensUp, (2*noBoucle2), 
                     LigneL02+ L0216+ TRONC*02,     

              PtArrSigOVA10,
              BoolRestrictif,             (* aspect croix *)
              PtArrSigOVA12,
              BoolRestrictif,             (* aspect croix *)
              TivComSigOVA12kv,   (* tivcom *)
              PtArrSpeOVA14F,
              PtAntCdvPAR11,
              BoolRestrictif,
	      (* Variants Anticipes *)
              PtAntCdvPAR12,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
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


(* variants troncon 3    voies Z+ E  ---> si  *)
   ProcEmisSolTrain( te21s16t03.EmissionSensUp, (2*noBoucle3), 
                     LigneL02+ L0216+ TRONC*03,     

              PtArrSigOVAZB,
              BoolRestrictif,             (* aspect croix *)
              AigOVA09.PosReverseFiltree,
              AigOVA09.PosNormaleFiltree,
              BoolRestrictif,     (* Signal 38A considere rouge fix *)
              BoolRestrictif,             (* aspect croix *)
              BoolRestrictif, 
              BoolRestrictif,                     
(* Variants Anticipes *)
              PtArrSigOVA10,
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
              BaseSorVar + 60);

(*  *)
	 
(* variants troncon 4  voie 2 --> si *)
   ProcEmisSolTrain( te24s16t04.EmissionSensUp, (2*noBoucle4), 
                     LigneL02+ L0216+ TRONC*04,     
  
	      PtArrSigOVA22,
            BoolRestrictif,             (* aspect croix *)
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,

(* Variants Anticipes *)
              PtArrSpeOVA14F,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
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
   ProcEmisSolTrain( te31s16t05.EmissionSensUp, (2*noBoucle5), 
                     LigneL02+ L0216+ TRONC*05,     

              PtArrSigOVA24,
              BoolRestrictif,             (* aspect croix *)
              PtArrCdvOVA22,
              PtArrSpeOVA20,
              PtArrSigOVA20,
              BoolRestrictif,             (* aspect croix *)
              AigOVA19A.PosNormaleFiltree,     (* tivcom *)
              PtArrSigOVA14,
              BoolRestrictif,             (* aspect croix *)
              AigOVA23.PosReverseFiltree,
              AigOVA23.PosNormaleFiltree,	
              BoolRestrictif,             (* r_fix *)
              BoolRestrictif,             (* aspect croix *)

(* Variants Anticipes *)
              AigOVA19A.PosReverseFiltree,
              AigOVA19A.PosNormaleFiltree,			
              PtArrCdvNIN22,
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
   ProcEmisSolTrain( te35s16t06.EmissionSensUp, (2*noBoucle6), 
                     LigneL02+ L0216+ TRONC*06,     

              PtArrSigOVA38B,
              BoolRestrictif,              (* aspect croix *)
              AigOVA19A.PosReverseFiltree,
              AigOVA19A.PosNormaleFiltree,			
              BoolRestrictif,     (* rouge fix vZ *)
              BoolRestrictif,             (* aspect croix *)
              PtArrCdvNIN22,
              PtArrCdvNIN21,
              PtArrCdvNIN20,
(* Variants Anticipes *)
               BoolRestrictif,
               PtAntCdvDEP23,
               BoolRestrictif,
               BoolRestrictif,
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


(* reception du secteur 17 -aval- *)

   ProcReceptInterSecteur(trL0217, noBoucleCit, LigneL02+ L0217+ TRONC*01,

                  PtAntCdvPAR11,
                  PtAntCdvPAR12,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif, 
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


(* reception du secteur 15 -amont- *)

   ProcReceptInterSecteur(trL0215, noBoucleVia, LigneL02+ L0215+ TRONC*04,

                  PtAntCdvDEP23,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif, 
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

(* emission vers le secteur 17 -aval- *)

   ProcEmisInterSecteur (teL0217, noBoucleCit, LigneL02+ L0216+ TRONC*05,
			noBoucleCit,
                  PtArrCdvOVA24,
                  PtArrSigOVA24,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif, 
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


(* emission vers le secteur 15 -amont- *)

   ProcEmisInterSecteur (teL0215, noBoucleVia, LigneL02+ L0216+ TRONC*01,
			noBoucleVia,
                  PtArrCdvOVA06,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif, 
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
            

 (** Emission invariants vers secteur 17 aval L0217 **)
   EmettreSegm(LigneL02+ L0216+ TRONC*05+ SEGM*00, noBoucleCit, SensUp);
   EmettreSegm(LigneL02+ L0216+ TRONC*05+ SEGM*01, noBoucleCit, SensUp);


 (** Emission invariants vers secteur 15 amont L0215 **)
   EmettreSegm(LigneL02+ L0216+ TRONC*01+ SEGM*00, noBoucleVia, SensUp);
   EmettreSegm(LigneL02+ L0216+ TRONC*01+ SEGM*01, noBoucleVia, SensUp);

 (** Boucle 1 **)        
   EmettreSegm(LigneL02+ L0216+ TRONC*01+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL02+ L0216+ TRONC*01+ SEGM*01, noBoucle1, SensUp);
   EmettreSegm(LigneL02+ L0216+ TRONC*02+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL02+ L0216+ TRONC*02+ SEGM*01, noBoucle1, SensUp);
   EmettreSegm(LigneL02+ L0216+ TRONC*03+ SEGM*00, noBoucle1, SensUp);

 (** Boucle 2 **)        
   EmettreSegm(LigneL02+ L0216+ TRONC*02+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL02+ L0216+ TRONC*02+ SEGM*01, noBoucle2, SensUp);
   EmettreSegm(LigneL02+ L0216+ TRONC*02+ SEGM*02, noBoucle2, SensUp);
   EmettreSegm(LigneL02+ L0216+ TRONC*05+ SEGM*02, noBoucle2, SensUp);
   EmettreSegm(LigneL02+ L0217+ TRONC*01+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL02+ L0217+ TRONC*01+ SEGM*01, noBoucle2, SensUp);


 (** Boucle 3 **)  
   EmettreSegm(LigneL02+ L0216+ TRONC*03+ SEGM*00, noBoucle3, SensUp);
   EmettreSegm(LigneL02+ L0216+ TRONC*02+ SEGM*00, noBoucle3, SensUp);
   EmettreSegm(LigneL02+ L0216+ TRONC*02+ SEGM*02, noBoucle3, SensUp);

 (** Boucle 4 **)  
   EmettreSegm(LigneL02+ L0216+ TRONC*04+ SEGM*00, noBoucle4, SensUp);
   EmettreSegm(LigneL02+ L0216+ TRONC*02+ SEGM*01, noBoucle4, SensUp);
   EmettreSegm(LigneL02+ L0216+ TRONC*05+ SEGM*02, noBoucle4, SensUp);

 (** Boucle 5 **) 
   EmettreSegm(LigneL02+ L0216+ TRONC*05+ SEGM*00, noBoucle5, SensUp);
   EmettreSegm(LigneL02+ L0216+ TRONC*05+ SEGM*01, noBoucle5, SensUp);
   EmettreSegm(LigneL02+ L0216+ TRONC*05+ SEGM*02, noBoucle5, SensUp);
   EmettreSegm(LigneL02+ L0216+ TRONC*06+ SEGM*01, noBoucle5, SensUp);
   EmettreSegm(LigneL02+ L0216+ TRONC*06+ SEGM*02, noBoucle5, SensUp);
   EmettreSegm(LigneL02+ L0216+ TRONC*04+ SEGM*00, noBoucle5, SensUp);
  
 (** Boucle 6 **)        
   EmettreSegm(LigneL02+ L0216+ TRONC*06+ SEGM*00, noBoucle6, SensUp);
   EmettreSegm(LigneL02+ L0216+ TRONC*06+ SEGM*01, noBoucle6, SensUp);
   EmettreSegm(LigneL02+ L0216+ TRONC*06+ SEGM*02, noBoucle6, SensUp);
   EmettreSegm(LigneL02+ L0216+ TRONC*03+ SEGM*00, noBoucle6, SensUp);
   EmettreSegm(LigneL02+ L0215+ TRONC*04+ SEGM*00, noBoucle6, SensUp);

(*  *) 

(************************* CONFIGURATION DES TRONCONS TSR ****************************)

   ConfigurerTroncon(Tronc0, LigneL02 + L0216 + TRONC*01, 2,2,2,2);  (* troncon 16-1 *)
   ConfigurerTroncon(Tronc1, LigneL02 + L0216 + TRONC*02, 2,2,2,2);  (* troncon 16-2 *)
   ConfigurerTroncon(Tronc2, LigneL02 + L0216 + TRONC*03, 2,2,2,2);  (* troncon 16-3 *)
   ConfigurerTroncon(Tronc3, LigneL02 + L0216 + TRONC*04, 2,2,2,2);  (* troncon 16-4 *)
   ConfigurerTroncon(Tronc4, LigneL02 + L0216 + TRONC*05, 2,2,2,2);  (* troncon 16-5 *)
   ConfigurerTroncon(Tronc5, LigneL02 + L0216 + TRONC*06, 2,2,2,2);  (* troncon 16-6 *)


(******************************* EMISSION DES TSR ************************************)

 (** Emission des TSR vers le secteur aval 17 L02017 **)

   EmettreTronc(LigneL02+ L0216+ TRONC*05, noBoucleCit, SensUp);

(** Emission des TSR vers le secteur amont 15 L0215 **)

   EmettreTronc(LigneL02+ L0216+ TRONC*01, noBoucleVia, SensUp);

 (** Emission des TSR sur les troncons du secteur courant **)

   EmettreTronc(LigneL02+ L0216+ TRONC*01, noBoucle1, SensUp); (* troncon 16-1 *)
   EmettreTronc(LigneL02+ L0216+ TRONC*02, noBoucle1, SensUp);
   EmettreTronc(LigneL02+ L0216+ TRONC*03, noBoucle1, SensUp);


   EmettreTronc(LigneL02+ L0216+ TRONC*02, noBoucle2, SensUp); (* troncon 16-2 *)
   EmettreTronc(LigneL02+ L0216+ TRONC*05, noBoucle2, SensUp);
   EmettreTronc(LigneL02+ L0217+ TRONC*01, noBoucle2, SensUp);


   EmettreTronc(LigneL02+ L0216+ TRONC*03, noBoucle3, SensUp); (* troncon 16-3 *)
   EmettreTronc(LigneL02+ L0216+ TRONC*02, noBoucle3, SensUp);


   EmettreTronc(LigneL02+ L0216+ TRONC*04, noBoucle4, SensUp); (* troncon 16-4 *)
   EmettreTronc(LigneL02+ L0216+ TRONC*02, noBoucle4, SensUp);
   EmettreTronc(LigneL02+ L0216+ TRONC*05, noBoucle4, SensUp);


   EmettreTronc(LigneL02+ L0216+ TRONC*05, noBoucle5, SensUp); (* troncon 16-5 *)
   EmettreTronc(LigneL02+ L0216+ TRONC*06, noBoucle5, SensUp);
   EmettreTronc(LigneL02+ L0216+ TRONC*04, noBoucle5, SensUp); (* troncon 16-4 *)

 
   EmettreTronc(LigneL02+ L0216+ TRONC*06, noBoucle6, SensUp); (* troncon 16-6 *)
   EmettreTronc(LigneL02+ L0216+ TRONC*03, noBoucle6, SensUp);
(* FC : le 20/8/1997 : correction du numero de troncon passe de 15.1 a 15.4,
	suite a remarque du site *)
   EmettreTronc(LigneL02+ L0215+ TRONC*04, noBoucle6, SensUp); 


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
    StockAdres( ADR( CdvOVA06));
    StockAdres( ADR( CdvOVA07));
    StockAdres( ADR( SigOVA07kv));
    StockAdres( ADR( SigOVA07kj));
    StockAdres( ADR( SigOVA08));
    StockAdres( ADR( SigOVA10kv));
 (*  StockAdres( ADR( SigOVA10kj)); *)
    StockAdres( ADR( SigOVA12kv));
    StockAdres( ADR( SigOVA12kj));
 (*  StockAdres( ADR( SigOVA14B));  *)
    StockAdres( ADR( SigOVA22));
    StockAdres( ADR( CdvOVA19B));
 (*  StockAdres( ADR( SigOVA15));   *)
    StockAdres( ADR( SigOVA14));
 (*  StockAdres( ADR( SigOVA25));   *)
    StockAdres( ADR( SigOVA24));
 (*  StockAdres( ADR( SigOVA22A));  *)
    StockAdres( ADR( SigOVA20kv));
    StockAdres( ADR( SigOVA20kj));
    StockAdres( ADR( CdvOVA18));
    StockAdres( ADR( CdvNIN22));
    StockAdres( ADR( CdvNIN21));
    StockAdres( ADR( CdvNIN20));
    StockAdres( ADR( SigOVAZB));
 (*  StockAdres( ADR( SigOVAZA)); *)
    StockAdres( ADR( SigOVA38B));
    StockAdres( ADR( CdvOVA08));
    StockAdres( ADR( CdvOVA13));
 (*   StockAdres( ADR( CdvOVA15V1)); *)
    StockAdres( ADR( CdvOVA12));
    StockAdres( ADR( CdvOVA22A));
    StockAdres( ADR( SigOVA38A));
    StockAdres( ADR( CdvOVA20));
    StockAdres( ADR( AxCIv2  ));
    StockAdres( ADR( CIsp1D  ));
    StockAdres( ADR( CdvOVA22B));
    StockAdres( ADR( CdvOVA24));

    StockAdres( ADR( AigOVA08));
 (*  StockAdres( ADR( AigOVA11)); *)
    StockAdres( ADR( AigOVA23));
    StockAdres( ADR( AigOVA19A));
    StockAdres( ADR( AigOVA09));

    StockAdres( ADR( PtArrCdvOVA06));
    StockAdres( ADR( PtArrCdvOVA07));
    StockAdres( ADR( PtArrSigOVA07));
    StockAdres( ADR( PtArrSigOVA08));
    StockAdres( ADR( PtArrSigOVA10));
    StockAdres( ADR( PtArrCdvOVA12));
    StockAdres( ADR( PtArrSigOVA12));
    StockAdres( ADR( PtArrSpeOVA14F));
    StockAdres( ADR( PtArrSigOVAZB));
    StockAdres( ADR( PtArrSigOVA22));
    StockAdres( ADR( PtArrCdvOVA24));
    StockAdres( ADR( PtArrSigOVA14));
    StockAdres( ADR( PtArrSigOVA24));
    StockAdres( ADR( PtArrCdvOVA22));
    StockAdres( ADR( PtArrSpeOVA20));
    StockAdres( ADR( PtArrSigOVA20));
    StockAdres( ADR( PtArrSigOVA38B));
    StockAdres( ADR( PtArrCdvOVA18));
    StockAdres( ADR( PtArrCdvNIN22));
    StockAdres( ADR( PtArrCdvNIN21));
    StockAdres( ADR( PtArrCdvNIN20));

    StockAdres( ADR( TivComSigOVA12kv ));

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
  CdvOVA22Fonc := CdvOVA22A.F = Vrai.F;
  CdvOVA12Fonc := CdvOVA12.F = Vrai.F;
  CdvOVA07Fonc := CdvOVA07.F = Vrai.F;
  CdvNIN22Fonc := CdvNIN22.F = Vrai.F;

(*  *)
(******************************* FILTRAGE DES AIGUILLES **********************************)

   FiltrerAiguille( AigOVA08,  BaseExeAig);
   FiltrerAiguille( AigOVA09,  BaseExeAig+2);
 (*  FiltrerAiguille( AigOVA11,  BaseExeAig+4); *)
   FiltrerAiguille( AigOVA23,  BaseExeAig+6);
   FiltrerAiguille( AigOVA19A, BaseExeAig+8);

(************************** Gerer les point d'arrets **************************)

   AffectBoolD( CdvOVA06,                   PtArrCdvOVA06);
(* retire le 6/4/1998   AffectBoolD( CdvOVA07, PtArrCdvOVA07); *)
(* ajoute le 6/4/1998 : nouveau calcul du point d'arret CIU07 = EP *)
   EtDD( CdvOVA07, CdvOVA08, PtArrCdvOVA07);
(* fin du rajout *)
   OuDD(        SigOVA07kv,   SigOVA07kj,   PtArrSigOVA07);
   AffectBoolD( SigOVA08,                   PtArrSigOVA08);
   AffectBoolD( SigOVA10kv,                 PtArrSigOVA10);

   OuDD( CdvOVA13, AigOVA23.PosReverseFiltree, BoolTr);
   EtDD( BoolTr  , CdvOVA12                  , PtArrCdvOVA12);
   OuDD( SigOVA12kv, SigOVA12kj              , PtArrSigOVA12);

   NonD( AxCIv2,                            PtArrSpeOVA14F);

   AffectBoolD( SigOVA14,                   PtArrSigOVA14);

(* voie 2 *)
   AffectBoolD( CdvOVA24,                   PtArrCdvOVA24);
   AffectBoolD( SigOVA24,                   PtArrSigOVA24);

   EtDD( CdvOVA20,          CdvOVA22A    ,  PtArrCdvOVA22);

   NonD( CIsp1D,                            PtArrSpeOVA20);
   EtDD( CdvOVA20,          PtArrSpeOVA20,  PtArrSpeOVA20);
   EtDD( CdvOVA19B,         PtArrSpeOVA20,  PtArrSpeOVA20);

   OuDD(        SigOVA20kv,   SigOVA20kj,   PtArrSigOVA20);

   AffectBoolD( SigOVAZB,                   PtArrSigOVAZB);
   AffectBoolD( SigOVA38B,                  PtArrSigOVA38B);

   AffectBoolD( CdvOVA18,                   PtArrCdvOVA18);
   AffectBoolD( CdvNIN22,                   PtArrCdvNIN22);
   AffectBoolD( CdvNIN21,                   PtArrCdvNIN21);
   AffectBoolD( CdvNIN20,                   PtArrCdvNIN20);

   AffectBoolD( SigOVA22,                   PtArrSigOVA22);

(* Determine les TIV COM *)

   AffectBoolD (SigOVA12kv,     TivComSigOVA12kv);

(*** lecture des entrees de regulation ***)

   LireEntreesRegul;

END ExeSpecific;
END Specific.
