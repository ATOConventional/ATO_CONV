IMPLEMENTATION MODULE Specific;

(*$S- *)
(*$T- *)

(******************************************************************************
*   SANTIAGO - LIGNE 1 - Secteur 26
*  =============================
*  Version : SCCS 1.0
*  Date    : 26/09/1997
*  Auteur  : Marc Plywacz - FC
*  Premiere Version
******************************************************************************)

(*---------------------------------------------------------------------------*)
(* Modifications :                                                           *)
(* -------------                                                             *)
(*  Version 1.0.1                                                            *)
(*  Date : 02/10/1997, Auteur : F. Chanier, Origine : Eq. DEV - modif antici.*)
(*                                                                           *)
(* Version 1.1.0                                                             *)
(* Date : 06/10/1997, Auteur : P. Hog    , Origine : relecture equip. dev.   *)
(*   Correction de la configuration de la boucle 3.                          *)
(*   Emission du segment 25.4.0 et des LTV du troncon 25.4 sur le troncon 5. *)
(*                                                                           *)
(* ========= Version 1.1.0 du 06/10/1997 ===(1ere version validee)========== *)
(*                                                                           *)    
(* ========= Version 1.1.1 du 16/01/1998 =================================== *)
(* Date : 16/01/1998, Auteur : F. Chanier    , Origine : Equipe de dev       *)
(*  modification provisoire de l'emission des LTV pour cause de delocal.     *)  
(*  en attendant que le bord puisse memoriser plus de 6 LTV                  *)
(*                                                                           *)
(* ========= Version 1.1.2 du 23/01/1998 =================================== *)
(* Date : 23/01/1998, Auteur : F. Chanier    , Origine : Equipe de dev       *)
(*  modification pour la detection des defaillances d'ampli.                 *)
(* date : 20/02/1997, Auteur : P. Hog    , origine : eq.dev.                 *)
(*    Modification des marches types.                                        *)
(*    Ajout d'un point d'arret EP entree du quai U. de Chile voie1.          *)
(*    PtArrCdvUDC12 = CdvUDC12 ET ( CdvUDC13 OU aiguille deviee).            *)
(*---------------------------------------------------------------------------*)

(* !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! *
 * ATTENTION : le CdvOVA14 est ajoute sur    *
 * l'entree 44.                              *
 * !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! *)
(*****************************************************************************)
(***            AJOUT DE LA NUMEROTATION SCCS DES VERSIONS                ****)
(*---------------------------------------------------------------------------*)
(* Version 1.1.3  =====================                                      *)
(* Version 1.6 DU SERVEUR SCCS =====================                         *)
(* Date :         10/09/1998                                                 *)
(* Auteur:        H. Le Roy                                                  *)
(* Modification : Fiche d'anomalie ba040998                                  *)
(*                Suite a un changement de vitesses maximales, mise a jour   *)
(*                des marches types                                          *)
(*---------------------------------------------------------------------------*)
(* Version 1.1.4  =====================                                      *)
(* Version 1.7 DU SERVEUR SCCS =====================                         *)
(* Date :         20/04/1999                                                 *)
(* Auteur:        H. Le Roy                                                  *)
(* Modification : Adaptation et modification de la configuration des amplis  *)
(*                 pour detecter les pannes de fusibles.Suppression de       *)
(*                 parties de code inutiles concernant les DAMTC.            *)
(*---------------------------------------------------------------------------*)
(* Version 1.1.5  =====================                                      *)
(* Version 1.8 DU SERVEUR SCCS =====================                         *)
(* Date :         19/06/2000                                                 *)
(* Auteur:        H. Le Roy                                                  *)
(* Modification : Am165 : modification des marches types                     *)
(*---------------------------------------------------------------------------*)
(* Version 1.1.6  =====================                                      *)
(* Version 1.9 DU SERVEUR SCCS =====================                         *)
(* Date :         07/08/2006                                                 *)
(* Auteur:        Rudy Nsiona                                                *)
(* Modification : Nouveau Train NS2004                                       *)
(* Procédure CONFIGURATION DES TRONCONS TSR                                  *)
(*                ancienne valeur 1 , nouvelle 2                             *)
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

              		Ampli11, Ampli12, Ampli13, Ampli14, Ampli15,
              		Ampli21, Ampli22, Ampli23, Ampli24, Ampli25, Ampli26, Ampli27,
                        Ampli28, Ampli29,
              		Ampli31, Ampli32,          Ampli34,
              		Ampli41, Ampli42, Ampli43, Ampli44, Ampli45,
              		Ampli51, Ampli52, Ampli53, Ampli54, Ampli55, Ampli56,
              		Ampli61, Ampli62, Ampli63,
  
(* variables *)
                       Boucle1, Boucle2, Boucle3, Boucle4, Boucle5, Boucle6, BoucleFictive,
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

    L0127  = 1024*27;    (* numero Secteur aval voie impaire decale de 2**10 *)

    L0126  = 1024*26;    (* numero Secteur local decale de 2**10 *)

    L0125  = 1024*25;    (* numero Secteur amont voie impaire decale de 2**10 *)


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
    noBouclebaq = 00; 
    noBouclehea = 01; 
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

(* DECLARATION DES SINGULARITES DU SECTEUR 26 : dans les deux sens confondus *)


(* Declaration des variables correspondant a des entrees securitaires  *)
(*   - CDV et signaux                                                  *)
    CdvLAM11,      (* entree  1, soit entree 0 de CES 02  *)
    CdvLAM12,      (* entree  2, soit entree 1 de CES 02  *)
    CdvUDC10,      (* entree  3, soit entree 2 de CES 02  *)
    SigUDC10kv,    (* entree  4, soit entree 4 de CES 02  *)
    SigUDC10kj,    (* entree  5, soit entree 5 de CES 02  *)
    SigUDC12kv,    (* entree  8, soit entree 7 de CES 02  *)
    SigUDC12kj,    (* entree  9, soit entree 0 de CES 03  *)
    CdvLUC11,      (* entree 10, soit entree 1 de CES 03  *)
    CdvLUC12,      (* entree 11, soit entree 2 de CES 03  *)
    CdvLUC13,      (* entree 12, soit entree 3 de CES 03  *)
    CdvLUC14,      (* entree 13, soit entree 4 de CES 03  *)

    CdvLUC23,      (* entree 14, soit entree 5 de CES 03  *)
    CdvLUC22,      (* entree 15, soit entree 6 de CES 03  *)
    CdvUDC24B,     (* entree 16, soit entree 7 de CES 03  *)
    CdvUDC24A,     (* entree 17, soit entree 0 de CES 04  *)
    SigUDC24,      (* entree 18, soit entree 1 de CES 04  *)
    SigUDC22Akv,   (* entree 19, soit entree 2 de CES 04  *)
    SigUDC22Akj,   (* entree 20, soit entree 3 de CES 04  *)
    CdvLAM22,      (* entree 21, soit entree 4 de CES 04  *)

    Sp1UDC,        (* entree 22, soit entree 5 de CES 04  *)
    Sp2UDC,        (* entree 23, soit entree 6 de CES 04  *)
 (* pas utilisee *) (* entree 24, soit entree 7 de CES 04  *)
    SigUDC14,      (* entree 25, soit entree 0 de CES 05  *)
    SigUDC22B,     (* entree 28, soit entree 3 de CES 05  *)
    CdvUDC11,      (* entree 29, soit entree 4 de CES 05  *)
    CdvUDC13,      (* entree 30, soit entree 5 de CES 05  *)
    CdvUDC23,      (* entree 31, soit entree 6 de CES 05  *)
    CdvUDC21B,     (* entree 32, soit entree 7 de CES 05  *)
    SigUDC20,      (* entree 33, soit entree 0 de CES 06  *)
    ItiUDC22_42,   (* entree 34, soit entree 1 de CES 06  *)
    CdvUDC12,      (* entree 35, soit entree 2 de CES 06  *)
    CdvUDC22,      (* entree 36, soit entree 3 de CES 06  *)
    CdvUDC14       (* entree 37, soit entree 4 de CES 06  *)
             : BoolD;

(*   - aiguilles                                                       *)
    AigUDC11,      (* entrees  6 et  7, soit entrees 5 et 6 de CES 02  *)
    AigUDC13       (* entrees 26 et 27, soit entrees 1 et 2 de CES 05  *)
             :TyAig;



(* Variables ne correspondant pas a une entree securitaire *)
(* Point d'arret *)
    PtArrCdvLAM11,
    PtArrCdvLAM12,
    PtArrCdvUDC10,
    PtArrSigUDC10,
    PtArrCdvUDC12,
    PtArrSigUDC12,
    PtArrCdvLUC11,
    PtArrCdvLUC12,
    PtArrCdvLUC13,
    PtArrCdvLUC14,

    PtArrCdvLUC23,
    PtArrCdvLUC22,
    PtArrCdvUDC24,
    PtArrSigUDC24,
    PtArrCdvUDC22,   (* point d'arret pour section tampon sur Sig 22 *)
    PtArrSigUDC22A,
    PtArrCdvLAM22,

    PtArrSigUDC14,
    PtArrSigUDC20,
    PtArrSigUDC22B : BoolD;

(* Aiguilles fictives *)
    AigFictUDC14,
    AigFictUDC20     : TyAigNonLue;

(* Tiv Com non lies a une aiguille *)
    TivComUDC10,
    TivComUDC12,
    TivComUDC22    : BoolD;

(* Variants anticipes *)
    PtAntCdvCAT11,
    PtAntCdvCAT12,
    PtAntCdvHEA28,
    PtAntSigHEA28,
    PtAntCdvHEA26  : BoolD;

(* Copie des entrees dans des variables fonctionnelles pour la regulation *)
    CdvLAM12Fonc,
    CdvLAM22Fonc,
    CdvUDC12Fonc,
    CdvUDC22Fonc,
    CdvLUC12Fonc,
    CdvLUC22Fonc     : BOOLEAN;

(** Voie d'emission SOL-TRAIN : deux sens confondus**)
    te11s26t01,
    te14s26t02,
    te17s26t03,
    te21s26t04,
    te24s26t05,
    te26s26t06           :TyEmissionTele;

(** Voie d'emission Inter-secteur deux voies confondues **)
    teL0127,
    teL0125	          :TyEmissionTele;

(** Voie de reception Inter-secteur deux voies confondues **)
    trL0127,
    trL0125               :TyCaracEntSec;


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
   EntreeAiguille( AigUDC11,  7,  6);   (* kag D = pos normale *)
   EntreeAiguille( AigUDC13, 26, 27);   (* kag G = pos normale *)

(* Configuration des entrees *)
    ProcEntreeIntrins (  1, CdvLAM11);
    ProcEntreeIntrins (  2, CdvLAM12);
    ProcEntreeIntrins (  3, CdvUDC10);
    ProcEntreeIntrins (  4, SigUDC10kv);
    ProcEntreeIntrins (  5, SigUDC10kj);
    ProcEntreeIntrins (  8, SigUDC12kv);
    ProcEntreeIntrins (  9, SigUDC12kj);
    ProcEntreeIntrins ( 10, CdvLUC11);
    ProcEntreeIntrins ( 11, CdvLUC12);
    ProcEntreeIntrins ( 12, CdvLUC13);
    ProcEntreeIntrins ( 13, CdvLUC14);

    ProcEntreeIntrins ( 14, CdvLUC23);
    ProcEntreeIntrins ( 15, CdvLUC22);
    ProcEntreeIntrins ( 16, CdvUDC24B);
    ProcEntreeIntrins ( 17, CdvUDC24A);
    ProcEntreeIntrins ( 18, SigUDC24);
    ProcEntreeIntrins ( 19, SigUDC22Akv);
    ProcEntreeIntrins ( 20, SigUDC22Akj);
    ProcEntreeIntrins ( 21, CdvLAM22);

    ProcEntreeIntrins ( 22, Sp1UDC);
    ProcEntreeIntrins ( 23, Sp2UDC);
    ProcEntreeIntrins ( 25, SigUDC14);
    ProcEntreeIntrins ( 28, SigUDC22B);
    ProcEntreeIntrins ( 29, CdvUDC11);
    ProcEntreeIntrins ( 30, CdvUDC13);
    ProcEntreeIntrins ( 31, CdvUDC23);
    ProcEntreeIntrins ( 32, CdvUDC21B);
    ProcEntreeIntrins ( 33, SigUDC20);
    ProcEntreeIntrins ( 34, ItiUDC22_42);
    ProcEntreeIntrins ( 35, CdvUDC12);
    ProcEntreeIntrins ( 36, CdvUDC22);
    ProcEntreeIntrins ( 37, CdvUDC14);

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

   ConfigurerAmpli(Ampli21, 2, 1, 159, 14, FALSE);
   ConfigurerAmpli(Ampli22, 2, 2, 192, 15, FALSE);  
   ConfigurerAmpli(Ampli23, 2, 3, 193, 15, FALSE);
   ConfigurerAmpli(Ampli24, 2, 4, 194, 15, TRUE);
   ConfigurerAmpli(Ampli25, 2, 5, 195, 16, FALSE);
   ConfigurerAmpli(Ampli26, 2, 6, 196, 16, FALSE);
   ConfigurerAmpli(Ampli27, 2, 7, 197, 16, TRUE);
   ConfigurerAmpli(Ampli28, 2, 8, 198, 13, FALSE);
   ConfigurerAmpli(Ampli29, 2, 9, 199, 13, TRUE);

   ConfigurerAmpli(Ampli31, 3, 1, 200, 17, FALSE);
   ConfigurerAmpli(Ampli32, 3, 2, 201, 18, FALSE);  
   ConfigurerAmpli(Ampli34, 3, 4, 203, 18, TRUE);  

   ConfigurerAmpli(Ampli41, 4, 1, 204, 21, FALSE);
   ConfigurerAmpli(Ampli42, 4, 2, 205, 22, FALSE);  
   ConfigurerAmpli(Ampli43, 4, 3, 206, 22, FALSE);
   ConfigurerAmpli(Ampli44, 4, 4, 207, 22, TRUE);
   ConfigurerAmpli(Ampli45, 4, 5, 208, 23, FALSE);    

   ConfigurerAmpli(Ampli51, 5, 1, 209, 24, FALSE);
   ConfigurerAmpli(Ampli52, 5, 2, 210, 25, FALSE);  
   ConfigurerAmpli(Ampli53, 5, 3, 211, 25, FALSE);
   ConfigurerAmpli(Ampli54, 5, 4, 212, 25, TRUE);
   ConfigurerAmpli(Ampli55, 5, 5, 213, 23, FALSE);
   ConfigurerAmpli(Ampli56, 5, 6, 214, 23, TRUE);    

   ConfigurerAmpli(Ampli61, 6, 1, 215, 26, FALSE);
   ConfigurerAmpli(Ampli62, 6, 2, 216, 27, FALSE);  
   ConfigurerAmpli(Ampli63, 6, 3, 217, 27, TRUE);

 (** cartes CES **)
   ConfigurerCES(CarteCes1, 01);
   ConfigurerCES(CarteCes2, 02);
   ConfigurerCES(CarteCes3, 03);
   ConfigurerCES(CarteCes4, 04);
   ConfigurerCES(CarteCes5, 05);


(** Liaisons Inter-Secteur **)

   ConfigurerIntsecteur(Intersecteur1, 01, trL0127, trL0125);


(* Initialisations des variables ne correspondant pas a des entrees secu *)
(* Point d'arret *)
    AffectBoolD( BoolRestrictif, PtArrCdvLAM11);
    AffectBoolD( BoolRestrictif, PtArrCdvLAM12);
    AffectBoolD( BoolRestrictif, PtArrCdvUDC10);
    AffectBoolD( BoolRestrictif, PtArrSigUDC10);
    AffectBoolD( BoolRestrictif, PtArrCdvUDC12);
    AffectBoolD( BoolRestrictif, PtArrSigUDC12);
    AffectBoolD( BoolRestrictif, PtArrCdvLUC11);
    AffectBoolD( BoolRestrictif, PtArrCdvLUC12);
    AffectBoolD( BoolRestrictif, PtArrCdvLUC13);
    AffectBoolD( BoolRestrictif, PtArrCdvLUC14);

    AffectBoolD( BoolRestrictif, PtArrCdvLUC23);
    AffectBoolD( BoolRestrictif, PtArrCdvLUC22);
    AffectBoolD( BoolRestrictif, PtArrCdvUDC24);
    AffectBoolD( BoolRestrictif, PtArrSigUDC24);
    AffectBoolD( BoolRestrictif, PtArrCdvUDC22);
    AffectBoolD( BoolRestrictif, PtArrSigUDC22A);
    AffectBoolD( BoolRestrictif, PtArrCdvLAM22);

    AffectBoolD( BoolRestrictif, PtArrSigUDC14);
    AffectBoolD( BoolRestrictif, PtArrSigUDC20);
    AffectBoolD( BoolRestrictif, PtArrSigUDC22B);

(* Aiguilles fictives *)
    AffectBoolD( BoolRestrictif, AigFictUDC14.PosNormale);
    AffectBoolD( BoolRestrictif, AigFictUDC14.PosDeviee);
    AffectBoolD( BoolRestrictif, AigFictUDC20.PosNormale);
    AffectBoolD( BoolRestrictif, AigFictUDC20.PosDeviee);

(* Tiv Com non lies a une aiguille *)
    AffectBoolD( BoolRestrictif, TivComUDC10);
    AffectBoolD( BoolRestrictif, TivComUDC12);
    AffectBoolD( BoolRestrictif, TivComUDC22);

(* Variants anticipes *)
    AffectBoolD( BoolRestrictif, PtAntCdvCAT11);
    AffectBoolD( BoolRestrictif, PtAntCdvCAT12);
    AffectBoolD( BoolRestrictif, PtAntCdvHEA28);
    AffectBoolD( BoolRestrictif, PtAntCdvHEA26);
    AffectBoolD( BoolRestrictif, PtAntSigHEA28);

(* Copie des entrees dans des variables fonctionnelles pour la regulation *)
    CdvLAM12Fonc := FALSE;
    CdvLAM22Fonc := FALSE;
    CdvUDC12Fonc := FALSE;
    CdvUDC22Fonc := FALSE;
    CdvLUC12Fonc := FALSE;
    CdvLUC22Fonc := FALSE;

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

   ConfigEmisTeleSolTrain ( te11s26t01,
                            noBoucle1,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te14s26t02,
                            noBoucle2,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te17s26t03,
                            noBoucle3,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te21s26t04,
                            noBoucle4,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te24s26t05,
                            noBoucle5,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te26s26t06,
                            noBoucle6,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);


(* CONFIGURATION POUR LA REGULATION *)
   ConfigQuai (12, 74, CdvLAM12Fonc, te11s26t01, 0,  8,  3,  4, 11, 13, 14, 15);
   ConfigQuai (12, 79, CdvLAM22Fonc, te24s26t05, 0,  8,  9,  4,  5, 13, 14, 15);
   ConfigQuai (13, 64, CdvUDC12Fonc, te14s26t02, 0, 10,  6,  7,  7, 13, 14, 15);
   ConfigQuai (13, 69, CdvUDC22Fonc, te24s26t05, 0,  6,  7,  7,  7, 13, 14, 15);
   ConfigQuai (14, 84, CdvLUC12Fonc, te14s26t02, 0,  4, 11,  5,  6, 13, 14, 15);
   ConfigQuai (14, 89, CdvLUC22Fonc, te21s26t04, 0,  4, 11,  5, 10, 13, 14, 15);

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
   ProcEmisSolTrain( te11s26t01.EmissionSensUp, (2*noBoucle1), 
                     LigneL01+ L0126+ TRONC*01,

              PtArrCdvLAM11,
              PtArrCdvLAM12,
              PtArrCdvUDC10,
              PtArrSigUDC10,
              BoolRestrictif,           (* aspect croix *)
              TivComUDC10,
              AigUDC11.PosReverseFiltree,
              AigUDC11.PosNormaleFiltree,
              PtArrCdvUDC12,
(* Variants Anticipes *)
              PtArrSigUDC12,
              BoolRestrictif,           (* aspect croix *)
              TivComUDC12,           
              AigFictUDC14.PosDeviee,           
              AigFictUDC14.PosNormale,
              BoolRestrictif,           (* signal rouge fix fictif SIGUDC42 *)
              BoolRestrictif,           (* aspect croix *)
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolPermissif,
              BaseSorVar);
(*  *)
(* variants troncon 2   voie 1 et 2 --> si  *)
   ProcEmisSolTrain( te14s26t02.EmissionSensUp, (2*noBoucle2), 
                     LigneL01+ L0126+ TRONC*02,

              PtArrSigUDC12,
              BoolRestrictif,           (* aspect croix *)
              TivComUDC12,              (* tivcom *)
              AigFictUDC14.PosDeviee,   (* aiguille fictive pos. reverse *)
              AigFictUDC14.PosNormale,  (* aiguille fictive pos. normale *)
              BoolRestrictif,           (* signal rouge fix fictif SigUDC14B *)
              BoolRestrictif,           (* aspect croix *)
              PtArrCdvLUC11,
              PtArrCdvLUC12,
              PtArrCdvLUC13,
              PtArrCdvLUC14,
              PtArrSigUDC22B,
              BoolRestrictif,           (* aspect croix *)
(* Variants Anticipes *)
              PtAntCdvCAT11,
              PtAntCdvCAT12,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolPermissif,
              BaseSorVar + 30);


(* variants troncon 3    voie 2  ---> sp  *)
   ProcEmisSolTrain( te17s26t03.EmissionSensUp, (2*noBoucle3), 
                     LigneL01+ L0126+ TRONC*03,

              PtArrSigUDC20,
              BoolRestrictif,           (* aspect croix *)
              BoolRestrictif,           (* signal rouge fix fictif SigUDC42 *)
              BoolRestrictif,           (* aspect croix *)
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
              BaseSorVar + 60);

(*  *)
(* variants troncon 4  voie 2 <-- sp *)
   ProcEmisSolTrain( te21s26t04.EmissionSensUp, (2*noBoucle4), 
                     LigneL01+ L0126+ TRONC*04,
  
              PtArrCdvLUC23,
              PtArrCdvLUC22,
              PtArrCdvUDC24,
              PtArrSigUDC24,
              BoolRestrictif,           (* aspect croix *)
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
(* Variants Anticipes *)
              PtArrCdvUDC22,
              PtArrSigUDC22A,
              BoolRestrictif,           (* aspect croix *)
              TivComUDC22,
              BoolRestrictif,
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
   ProcEmisSolTrain( te24s26t05.EmissionSensUp, (2*noBoucle5), 
                     LigneL01+ L0126+ TRONC*05,

              PtArrCdvUDC22,
              PtArrSigUDC22A,
              BoolRestrictif,           (* aspect croix *)
              TivComUDC22,              (* tivcom *)
              AigFictUDC20.PosDeviee,   (* aiguille fictive pos. reverse *)
              AigFictUDC20.PosNormale,  (* aiguille fictive pos. normale *)
              BoolRestrictif,           (* signal rouge fix fictif SigUDC20A *)
              BoolRestrictif,           (* aspect croix *)
              PtArrCdvLAM22,
              PtAntCdvHEA28,
(* Variants Anticipes *)
              PtAntSigHEA28,
              BoolRestrictif,           (* aspect croix *)
              PtAntCdvHEA26,
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
   ProcEmisSolTrain( te26s26t06.EmissionSensUp, (2*noBoucle6), 
                     LigneL01+ L0126+ TRONC*06,
  
              PtArrSigUDC14,
              BoolRestrictif,           (* aspect croix *)
              AigUDC13.PosReverseFiltree,
              AigUDC13.PosNormaleFiltree,
              BoolRestrictif,           (* signal rouge fix fictif SigUDC12A *)
              BoolRestrictif,           (* aspect croix *)
              BoolRestrictif,
              BoolRestrictif,
(* Variants Anticipes *)
              PtArrCdvUDC22,
              PtArrSigUDC22A,
              BoolRestrictif,           (* aspect croix *)
              BoolRestrictif,
              BoolRestrictif,
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
(* reception du secteur 27 -aval- *)

   ProcReceptInterSecteur(trL0127, noBouclebaq, LigneL01+ L0127+ TRONC*01,
                  PtAntCdvCAT11,
                  PtAntCdvCAT12,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
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

(* reception du secteur 25 -amont- *)

   ProcReceptInterSecteur(trL0125, noBouclehea, LigneL01+ L0125+ TRONC*03,

                  PtAntCdvHEA28,
                  PtAntSigHEA28,
                  BoolRestrictif,           (* aspect croix *)
                  PtAntCdvHEA26,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
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
(* emission vers le secteur 27 -aval- *)

   ProcEmisInterSecteur (teL0127, noBouclebaq, LigneL01+ L0126+ TRONC*04,
			noBouclebaq,
                  PtArrCdvLUC23,
                  PtArrCdvLUC22,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
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

(* emission vers le secteur 25 -amont- *)

   ProcEmisInterSecteur (teL0125, noBouclehea, LigneL01+ L0126+ TRONC*01,
			noBouclehea,
                  PtArrCdvLAM11,
                  PtArrCdvLAM12,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
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


 (** Emission invariants vers secteur 27 aval L0127 **)

   EmettreSegm(LigneL01+ L0126+ TRONC*04+ SEGM*00, noBouclebaq, SensUp);
   EmettreSegm(LigneL01+ L0126+ TRONC*04+ SEGM*01, noBouclebaq, SensUp);
   EmettreSegm(LigneL01+ L0126+ TRONC*05+ SEGM*00, noBouclebaq, SensUp);

 (** Emission invariants vers secteur 25 amont L0125 **)

   EmettreSegm(LigneL01+ L0126+ TRONC*01+ SEGM*00, noBouclehea, SensUp);
   EmettreSegm(LigneL01+ L0126+ TRONC*01+ SEGM*01, noBouclehea, SensUp);


 (** Boucle 1 **)
   EmettreSegm(LigneL01+ L0126+ TRONC*01+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL01+ L0126+ TRONC*01+ SEGM*01, noBoucle1, SensUp);
   EmettreSegm(LigneL01+ L0126+ TRONC*02+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL01+ L0126+ TRONC*02+ SEGM*01, noBoucle1, SensUp);
   EmettreSegm(LigneL01+ L0126+ TRONC*02+ SEGM*02, noBoucle1, SensUp);
   EmettreSegm(LigneL01+ L0126+ TRONC*03+ SEGM*01, noBoucle1, SensUp);

 (** Boucle 2 **)
   EmettreSegm(LigneL01+ L0126+ TRONC*02+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL01+ L0126+ TRONC*02+ SEGM*01, noBoucle2, SensUp);
   EmettreSegm(LigneL01+ L0126+ TRONC*02+ SEGM*02, noBoucle2, SensUp);
   EmettreSegm(LigneL01+ L0126+ TRONC*02+ SEGM*03, noBoucle2, SensUp);
   EmettreSegm(LigneL01+ L0126+ TRONC*06+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL01+ L0127+ TRONC*01+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL01+ L0127+ TRONC*01+ SEGM*01, noBoucle2, SensUp);

 (** Boucle 3 **)
   EmettreSegm(LigneL01+ L0126+ TRONC*03+ SEGM*00, noBoucle3, SensUp);
   EmettreSegm(LigneL01+ L0126+ TRONC*03+ SEGM*01, noBoucle3, SensUp);

 (** Boucle 4 **)
   EmettreSegm(LigneL01+ L0126+ TRONC*04+ SEGM*00, noBoucle4, SensUp);
   EmettreSegm(LigneL01+ L0126+ TRONC*04+ SEGM*01, noBoucle4, SensUp);
   EmettreSegm(LigneL01+ L0126+ TRONC*05+ SEGM*00, noBoucle4, SensUp);
   EmettreSegm(LigneL01+ L0126+ TRONC*05+ SEGM*01, noBoucle4, SensUp);
   EmettreSegm(LigneL01+ L0125+ TRONC*03+ SEGM*00, noBoucle4, SensUp);

 (** Boucle 5 **)
   EmettreSegm(LigneL01+ L0126+ TRONC*05+ SEGM*02, noBoucle5, SensUp);
   EmettreSegm(LigneL01+ L0126+ TRONC*02+ SEGM*03, noBoucle5, SensUp);
   EmettreSegm(LigneL01+ L0126+ TRONC*03+ SEGM*00, noBoucle5, SensUp);
   EmettreSegm(LigneL01+ L0125+ TRONC*03+ SEGM*00, noBoucle5, SensUp);
   EmettreSegm(LigneL01+ L0125+ TRONC*03+ SEGM*01, noBoucle5, SensUp);
   EmettreSegm(LigneL01+ L0125+ TRONC*04+ SEGM*00, noBoucle5, SensUp);

 (** Boucle 6 **)
   EmettreSegm(LigneL01+ L0126+ TRONC*06+ SEGM*00, noBoucle6, SensUp);
   EmettreSegm(LigneL01+ L0126+ TRONC*02+ SEGM*00, noBoucle6, SensUp);
   EmettreSegm(LigneL01+ L0126+ TRONC*05+ SEGM*00, noBoucle6, SensUp);
   EmettreSegm(LigneL01+ L0126+ TRONC*05+ SEGM*01, noBoucle6, SensUp);
   EmettreSegm(LigneL01+ L0126+ TRONC*05+ SEGM*02, noBoucle6, SensUp);

(*  *)

(*************************** CONFIGURATION DES TRONCONS TSR **************************)

   ConfigurerTroncon(Tronc0, LigneL01 + L0126 + TRONC*01, 2,2,2,2);  (* troncon 26-1 *)
   ConfigurerTroncon(Tronc1, LigneL01 + L0126 + TRONC*02, 2,2,2,2);  (* troncon 26-2 *)
   ConfigurerTroncon(Tronc2, LigneL01 + L0126 + TRONC*03, 2,2,2,2);  (* troncon 26-3 *)
   ConfigurerTroncon(Tronc3, LigneL01 + L0126 + TRONC*04, 2,2,2,2);  (* troncon 26-4 *)
   ConfigurerTroncon(Tronc4, LigneL01 + L0126 + TRONC*05, 2,2,2,2);  (* troncon 26-5 *)
   ConfigurerTroncon(Tronc5, LigneL01 + L0126 + TRONC*06, 2,2,2,2);  (* troncon 26-6 *)


(************************************** EMISSION DES TSR *************************************)



(** Emission des TSR vers le secteur aval 27 L0127 **)

   EmettreTronc(LigneL01+ L0126+ TRONC*04, noBouclebaq, SensUp);
   EmettreTronc(LigneL01+ L0126+ TRONC*05, noBouclebaq, SensUp);


(** Emission des TSR vers le secteur amont 25 L0125 **)

   EmettreTronc(LigneL01+ L0126+ TRONC*01, noBouclehea, SensUp);


 (** Emission des TSR sur les troncons du secteur courant **)

   EmettreTronc(LigneL01+ L0126+ TRONC*01, noBoucle1, SensUp); (* troncon 26-1 *)
   EmettreTronc(LigneL01+ L0126+ TRONC*02, noBoucle1, SensUp);
(*   EmettreTronc(LigneL01+ L0126+ TRONC*03, noBoucle1, SensUp); *)


   EmettreTronc(LigneL01+ L0126+ TRONC*02, noBoucle2, SensUp); (* troncon 26-2 *)
   EmettreTronc(LigneL01+ L0126+ TRONC*06, noBoucle2, SensUp);
   EmettreTronc(LigneL01+ L0127+ TRONC*01, noBoucle2, SensUp);


   EmettreTronc(LigneL01+ L0126+ TRONC*03, noBoucle3, SensUp); (* troncon 26-3 *)


   EmettreTronc(LigneL01+ L0126+ TRONC*04, noBoucle4, SensUp); (* troncon 26-4 *)
   EmettreTronc(LigneL01+ L0126+ TRONC*05, noBoucle4, SensUp);
   EmettreTronc(LigneL01+ L0125+ TRONC*03, noBoucle4, SensUp);


   EmettreTronc(LigneL01+ L0126+ TRONC*05, noBoucle5, SensUp); (* troncon 26-5 *)
   EmettreTronc(LigneL01+ L0126+ TRONC*02, noBoucle5, SensUp);
   EmettreTronc(LigneL01+ L0126+ TRONC*03, noBoucle5, SensUp);
   EmettreTronc(LigneL01+ L0125+ TRONC*03, noBoucle5, SensUp);
   EmettreTronc(LigneL01+ L0125+ TRONC*04, noBoucle5, SensUp);


   EmettreTronc(LigneL01+ L0126+ TRONC*06, noBoucle6, SensUp); (* troncon 26-6 *)
   EmettreTronc(LigneL01+ L0126+ TRONC*02, noBoucle6, SensUp);
   EmettreTronc(LigneL01+ L0126+ TRONC*05, noBoucle6, SensUp);

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
    StockAdres( ADR( CdvLAM11));
    StockAdres( ADR( CdvLAM12));
    StockAdres( ADR( CdvUDC10));
    StockAdres( ADR( SigUDC10kv));
    StockAdres( ADR( SigUDC10kj));
    StockAdres( ADR( SigUDC12kv));
    StockAdres( ADR( SigUDC12kj));
    StockAdres( ADR( CdvLUC11));
    StockAdres( ADR( CdvLUC12));
    StockAdres( ADR( CdvLUC13));
    StockAdres( ADR( CdvLUC14));
    StockAdres( ADR( CdvLUC23));
    StockAdres( ADR( CdvLUC22));
    StockAdres( ADR( CdvUDC24B));
    StockAdres( ADR( CdvUDC24A));
    StockAdres( ADR( SigUDC24));
    StockAdres( ADR( SigUDC22Akv));
    StockAdres( ADR( SigUDC22Akj));
    StockAdres( ADR( CdvLAM22));
    StockAdres( ADR( Sp1UDC));
    StockAdres( ADR( Sp2UDC));
    StockAdres( ADR( SigUDC14));
    StockAdres( ADR( SigUDC22B));
    StockAdres( ADR( CdvUDC11));
    StockAdres( ADR( CdvUDC13));
    StockAdres( ADR( CdvUDC23));
    StockAdres( ADR( CdvUDC21B));
    StockAdres( ADR( SigUDC20));
    StockAdres( ADR( ItiUDC22_42));
    StockAdres( ADR( CdvUDC12));
    StockAdres( ADR( CdvUDC22));
    StockAdres( ADR( CdvUDC14));

    StockAdres( ADR( AigUDC11));
    StockAdres( ADR( AigUDC13));

    StockAdres( ADR( PtArrCdvLAM11));
    StockAdres( ADR( PtArrCdvLAM12));
    StockAdres( ADR( PtArrCdvUDC10));
    StockAdres( ADR( PtArrSigUDC10));
    StockAdres( ADR( PtArrCdvUDC12));
    StockAdres( ADR( PtArrSigUDC12));
    StockAdres( ADR( PtArrCdvLUC11));
    StockAdres( ADR( PtArrCdvLUC12));
    StockAdres( ADR( PtArrCdvLUC13));
    StockAdres( ADR( PtArrCdvLUC14));
    StockAdres( ADR( PtArrCdvLUC23));
    StockAdres( ADR( PtArrCdvLUC22));
    StockAdres( ADR( PtArrCdvUDC24));
    StockAdres( ADR( PtArrSigUDC24));
    StockAdres( ADR( PtArrCdvUDC22));
    StockAdres( ADR( PtArrSigUDC22A));
    StockAdres( ADR( PtArrCdvLAM22));
    StockAdres( ADR( PtArrSigUDC14));
    StockAdres( ADR( PtArrSigUDC20));
    StockAdres( ADR( PtArrSigUDC22B));

    StockAdres( ADR( AigFictUDC14));
    StockAdres( ADR( AigFictUDC20));
    StockAdres( ADR( TivComUDC10));
    StockAdres( ADR( TivComUDC12));
    StockAdres( ADR( TivComUDC22));

    StockAdres( ADR( PtAntCdvCAT11));
    StockAdres( ADR( PtAntCdvCAT12)); 
    StockAdres( ADR( PtAntCdvHEA28));
    StockAdres( ADR( PtAntCdvHEA26));
    StockAdres( ADR( PtAntSigHEA28));

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
VAR BoolTr : BoolLD;

BEGIN (* ExeSpecific *)

(* Affectation des "constantes" utilisees dans la construction des messages emis    *)
(* et recus sur les boucles de transmission continue et sur les liens intersecteur. *)
(* Cette reaffectation est necessaire a chaque cycle pour la mise en securite.      *)
   AffectBoolC(Vrai, BoolPermissif)  ;
   AffectBoolC(Faux, BoolRestrictif) ;

(* regulation *)
  CdvLAM12Fonc := CdvLAM12.F = Vrai.F;
  CdvLAM22Fonc := CdvLAM22.F = Vrai.F;
  CdvUDC12Fonc := CdvUDC12.F = Vrai.F;
  CdvUDC22Fonc := CdvUDC22.F = Vrai.F;
  CdvLUC12Fonc := CdvLUC12.F = Vrai.F;
  CdvLUC22Fonc := CdvLUC22.F = Vrai.F;



(*  *)
(*********************************** FILTRAGE DES AIGUILLES ******************************)

   FiltrerAiguille( AigUDC11, BaseExeAig);
   FiltrerAiguille( AigUDC13, BaseExeAig + 2);

(************************** Gerer les aiguilles non lues **********************)

   EtDD( AigUDC13.PosReverseFiltree, Sp1UDC, BoolTr);
   OuDD( BoolTr, Sp2UDC, AigFictUDC14.PosNormale);        (* position normale *)
   NonD( AigFictUDC14.PosNormale, AigFictUDC14.PosDeviee);(* position reverse *)

   AffectBoolD( ItiUDC22_42, AigFictUDC20.PosNormale);    (* position normale *)
   NonD( AigFictUDC20.PosNormale, AigFictUDC20.PosDeviee);(* position reverse *)

(******************* Gerer les Tiv Com non lies a une aiguille ****************)

   AffectBoolD( SigUDC10kv,                  TivComUDC10);
   AffectBoolD( SigUDC12kv,                  TivComUDC12);
   AffectBoolD( SigUDC22Akv,                 TivComUDC22);

(************************** Gerer les point d'arrets **************************)

   AffectBoolD( CdvLAM11,                    PtArrCdvLAM11);
   AffectBoolD( CdvLAM12,                    PtArrCdvLAM12);
   AffectBoolD( CdvUDC10,                    PtArrCdvUDC10);
   OuDD(        SigUDC10kv,    SigUDC10kj,   PtArrSigUDC10);

   (* PtArrCdv12 = Cdv12 et (Cdv13 ou Aig13 deviee) *)
   OuDD(        CdvUDC13, AigUDC13.PosReverseFiltree, BoolTr);
   EtDD(        BoolTr,        CdvUDC12,    PtArrCdvUDC12);

   OuDD(        SigUDC12kv,    SigUDC12kj,   PtArrSigUDC12);
   AffectBoolD( CdvLUC11,                    PtArrCdvLUC11);
   AffectBoolD( CdvLUC12,                    PtArrCdvLUC12);
   AffectBoolD( CdvLUC13,                    PtArrCdvLUC13);
   AffectBoolD( CdvLUC14,                    PtArrCdvLUC14);

   AffectBoolD( CdvLUC23,                    PtArrCdvLUC23);
   AffectBoolD( CdvLUC22,                    PtArrCdvLUC22);
   EtDD(        CdvUDC24B,     CdvUDC24A,    PtArrCdvUDC24);
   AffectBoolD( SigUDC24,                    PtArrSigUDC24);
   EtDD(        CdvUDC22,      CdvUDC21B,    PtArrCdvUDC22);
   (* signal 22A = (Kv ou kJ) et non Sp1 *)
   NonD(        Sp1UDC,       BoolTr);
   OuDD(        SigUDC22Akv,   SigUDC22Akj,  PtArrSigUDC22A);
   EtDD(        PtArrSigUDC22A, BoolTr,      PtArrSigUDC22A);

   AffectBoolD( CdvLAM22,                    PtArrCdvLAM22);

   AffectBoolD( SigUDC14,                    PtArrSigUDC14);
   AffectBoolD( SigUDC20,                    PtArrSigUDC20);
   AffectBoolD( SigUDC22B,                   PtArrSigUDC22B);


(*** lecture des entrees de regulation ***)

   LireEntreesRegul;

END ExeSpecific;
END Specific.
