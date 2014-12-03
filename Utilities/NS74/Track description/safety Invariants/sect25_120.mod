IMPLEMENTATION MODULE Specific;

(*$S- *)
(*$T- *)

(******************************************************************************
*   SANTIAGO - LIGNE 1 - Secteur 25
*  =============================
*  Version : SCCS 1.0
*  Date    : 12/09/1997
*  Auteur  : Marc Plywacz
*  Premiere Version
******************************************************************************)

(*---------------------------------------------------------------------------*)
(* Modifications :                                                           *)
(* -------------                                                             *)
(*  version 1.1.0 - premiere version livree a la validation                  *)
(*  Date : 14/10/1997, Auteur : F. Chanier, Origine : Eq. dev                *)
(*  nature : modification des anticipations                                  *)
(*                                                                           *)
(* version 1.1.1                                                             *)
(* Date : 20/10/1997, Auteur : P. Hog    , Origine : Eq. dev                 *)
(*  Modification du calcul du point d'arret en entree du quai de la voie 2   *)
(*  a Los Heroes (PtArrCdvHEA26). Ce point d'arret prend en compte la        *)
(*  position de l'aiguille 25 car lorsque cette aiguille est en position     *)
(*  deviee le Cdv25 peut etre occupe.                                        *)
(*                                                                           *)
(* version 1.1.2                                                             *)
(* Date : 29/10/1997, Auteur : P. Hog    , Origine : Fiche Gauvin DI 15      *)
(*  Modification de l'emission des variants du troncon 3 suite a l'ajout     *)
(*  d'un TivCom a 25 Km/h sur le segment 25.3.1.                             *)
(* Date : 29/10/1997, Auteur : P. Hog    , Origine : Fiche Gauvin AM 52      *)
(*  Emission vers le secteur 12 du segment 25.3.2 au lieu du segment 25.3.0. *)
(*                                                                           *)
(* Version 1.1.3                                                             *)
(* Date : 03/11/1997, Auteur : P. Hog     , Origine : Site  FAX F297         *)
(*  Emission du segment 25.2.0 en anticipation sur le troncon 5 pour le      *)
(*  retournement sur le 25.5.1.                                              *)
(*                                                                           *)
(*                                                                           *)
(* Version 1.1.4                                                             *)
(* Date : 16/01/1998, Auteur : F. Chanier    , Origine : Equipe de dev       *)
(*  modification provisoire de l'emission des LTV pour cause de delocal.     *)
(*  en attendant que le bord puisse memoriser plus de 6 LTV                  *)
(*  ==> segment et LTV 24.3 sur boucle 3 supprimes                           *)
(*                                                                           *) 
(* Version 1.1.5                                                             *)
(* Date : 13/03/1998, Auteur : F. Chanier    , Origine : Eq. dev             *)
(*  ajout de la detection des pannes d'ampli                                 *)
(*  ajout des marches-type                                                   *)
(*  on remet le segment 24.3.0 et les LTV correspondantes sur bou3           *) 
(*---------------------------------------------------------------------------*)
(*****************************************************************************)
(***            AJOUT DE LA NUMEROTATION SCCS DES VERSIONS                ****)
(*---------------------------------------------------------------------------*)
(* Version 1.1.6  =====================                                      *)
(* Version 1.8 DU SERVEUR SCCS =====================                         *)
(* Date :         09/09/1998                                                 *)
(* Auteur:        H. Le Roy                                                  *)
(* Modification : Fiche d'anomalie ba040998                                  *)
(*                Suite a un changement de vitesses maximales, mise a jour   *)
(*                des marches types                                          *)
(*---------------------------------------------------------------------------*)
(* Version 1.1.7  =====================                                      *)
(* Version 1.9 DU SERVEUR SCCS =====================                         *)
(* Date :         20/04/1999                                                 *)
(* Auteur:        H. Le Roy                                                  *)
(* Modification : Adaptation et modification de la configuration des amplis  *)
(*                 pour detecter les pannes de fusibles.Suppression de       *)
(*                 parties de code inutiles concernant les DAMTC.            *)
(*---------------------------------------------------------------------------*)
(* Version 1.1.8  =====================                                      *)
(* Version 1.10 DU SERVEUR SCCS =====================                        *)
(* Date :         24/02/2000                                                 *)
(* Auteur:        H. Le Roy                                                  *)
(* Modification : Am dev032000-1 : modif. de la gestion des SP : ajout d'un  *)
(*        point arret specifique dedie a la gestion du SP2 a Los Heroes V1.  *)
(*        Le point d'arret associe au cdv 16B est maintenant decharge de     *)
(*        cette tache.                                                       *)
(*---------------------------------------------------------------------------*)
(* Version 1.1.9  =====================                                      *)
(* Version 1.11 DU SERVEUR SCCS =====================                        *)
(* Date :         07/06/2000                                                 *)
(* Auteur:        H. Le Roy                                                  *)
(* Modification : Am165 : Modification des marches types                     *)
(*---------------------------------------------------------------------------*)
(* Version 1.2.0  =====================                                      *)
(* Version 1.12 DU SERVEUR SCCS =====================                        *)
(* Date :         07/08/2006                                                 *)
(* Auteur:        Rudy Nsiona                                                *)
(* Modification : Nouveau Train NS2004                                       *)
(* Procédure CONFIGURATION DES TRONCONS TSR                                  *)
(*                ancienne valeur 1 , nouvelle 2                             *)
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
              		Ampli21, Ampli22, Ampli23, Ampli24, Ampli25, Ampli26,
                        Ampli27, Ampli28, Ampli29, Ampli2A,
              		Ampli31, Ampli32, Ampli33, Ampli34, Ampli35, Ampli37,
              		Ampli41, Ampli42, Ampli43, Ampli44,
              		Ampli51, Ampli52, Ampli53, Ampli54, Ampli55, Ampli57,         	
(* variables *)
                       Boucle1, Boucle2, Boucle3, Boucle4, Boucle5, Boucle6, BoucleFictive,
		       CarteCes1,  CarteCes2,  CarteCes3, CarteCes4, CarteCes5,
                       Intersecteur1, Intersecteur2,
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

    L0126  = 1024*26;    (* numero Secteur aval voie impaire decale de 2**10 *)

    L0125  = 1024*25;    (* numero Secteur local decale de 2**10 *)

    L0124  = 1024*24;    (* numero Secteur amont voie impaire decale de 2**10 *)

    L0212  = 1024*12;    (* numero Secteur adjacent LIGNE 2 decale de 2**10 *)

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
    noBoucleudc = 00; 
    noBouclecen = 01; 
    noBoucleheb = 02;
    noBoucle1 = 03;
    noBoucle2 = 04;
    noBoucle3 = 05;
    noBoucle4 = 06;
    noBoucle5 = 07;

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
    CdvHEA11A,     (* entree  1, soit entree 0 de CES 02  *)
    CdvHEA11B,     (* entree  2, soit entree 1 de CES 02  *)
    CdvHEA12,      (* entree  3, soit entree 2 de CES 02  *)
    SigHEA12kv,    (* entree  4, soit entree 4 de CES 02  *)
    SigHEA12kj,    (* entree  5, soit entree 5 de CES 02  *)
    SigHEA13,      (* entree  8, soit entree 7 de CES 02  *)
    CdvHEA16A,     (* entree  9, soit entree 0 de CES 03  *)
    CdvHEA16B,     (* entree 10, soit entree 1 de CES 03  *)

    CdvHEA28,      (* entree 11, soit entree 2 de CES 03  *)
    SigHEA28,      (* entree 12, soit entree 3 de CES 03  *)
    SigHEA26kv,    (* entree 13, soit entree 4 de CES 03  *)
    SigHEA26kj,    (* entree 14, soit entree 5 de CES 03  *)
    SigHEA24kv,    (* entree 17, soit entree 0 de CES 04  *)
    SigHEA24kj,    (* entree 18, soit entree 1 de CES 04  *)
    CdvHEA21B,     (* entree 19, soit entree 2 de CES 04  *)
    CdvHEA21A,     (* entree 20, soit entree 3 de CES 04  *)
    CdvHEA20,      (* entree 21, soit entree 4 de CES 04  *)

    SigHEAzA,      (* entree 22, soit entree 5 de CES 04  *)
    SigHEAzB,      (* entree 23, soit entree 6 de CES 04  *)
    Sp1HEA,        (* entree 24, soit entree 7 de CES 04  *)
    Sp2HEA,        (* entree 25, soit entree 0 de CES 05  *)
    CdvHEA13A,     (* entree 28, soit entree 3 de CES 05  *)
    CdvHEA27,      (* entree 29, soit entree 4 de CES 05  *)
    CdvHEA25,      (* entree 30, soit entree 5 de CES 05  *)
    SigHEA15,      (* entree 31, soit entree 6 de CES 05  *)
    CdvHEA15,      (* entree 32, soit entree 7 de CES 05  *)
    CdvHEA26,      (* entree 33, soit entree 0 de CES 06  *)
    CdvHEA22,      (* entree 34, soit entree 1 de CES 06  *)
    Sp2REP         (* entree 37, soit entree 4 de CES 06  *)
             : BoolD;

(*   - aiguilles                                                       *)
    AigHEA13,      (* entrees  6 et  7, soit entrees 5 et 6 de CES 02  *)
    AigHEA24,      (* entrees 15 et 16, soit entrees 6 et 7 de CES 03  *)
    AigHEAzB1,     (* entrees 26 et 27, soit entrees 1 et 2 de CES 05  *)
    AigHEA25       (* entrees 35 et 36, soit entrees 2 et 3 de CES 06  *)
             :TyAig;



(* Variables ne correspondant pas a une entree securitaire *)
(* Point d'arret *)
    PtArrCdvHEA11,
    PtArrCdvHEA12,   (* point d'arret pour section tampon sur Sig 12 *)
    PtArrSigHEA12,
    PtArrSigHEA13,
    PtArrCdvHEA15,
    PtArrCdvHEA16B,

    PtArrCdvHEA28,
    PtArrSigHEA28,
    PtArrCdvHEA26,   (* point d'arret pour section tampon sur Sig 26 *)
    PtArrSigHEA26,
    PtArrSigHEA24,
    PtArrCdvHEA21,
    PtArrCdvHEA20,

    PtArrSigHEA15,
    PtArrSigHEAzA,
    PtArrSigHEAzB,
    PtArrSpec16A  : BoolD;

(* Aiguilles fictives *)

(* Tiv Com non lies a une aiguille *)
    TivComHEA12,
    TivComHEA26,
    TivComHEA24    : BoolD;

(* Variants anticipes *)
    PtAntCdvLAM11,
    PtAntCdvLAM12,
    PtAntSigHEB46B,
    PtAntCdvULA23,
    PtAntCdvULA22  : BoolD;

(* Variants commutes *)
    VarComTron1_10,
    VarComTron1_11 : BoolD;

(* Copie des entrees dans des variables fonctionnelles pour la regulation *)
    CdvHEA12Fonc,
    CdvHEA22Fonc,
    CdvHEA15Fonc,
    CdvHEA26Fonc     : BOOLEAN;

(** Voie d'emission SOL-TRAIN : deux sens confondus**)
    te11s25t01,
    te13s25t02,
    te21s25t03,
    te24s25t04,
    te26s25t05     :TyEmissionTele;

(** Voie d'emission Inter-secteur deux voies confondues **)
    teL0126,
    teL0124,
    teL0212	          :TyEmissionTele;

(** Voie de reception Inter-secteur deux voies confondues **)
    trL0126,
    trL0124,
    trL0212,
    trfictive               :TyCaracEntSec;


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
   EntreeAiguille( AigHEA13,  7,  6);   (* kag D = pos normale *)
   EntreeAiguille( AigHEA24, 16, 15);   (* kag D = pos normale *)
   EntreeAiguille( AigHEAzB1,27, 26);   (* kag D = pos normale *)
   EntreeAiguille( AigHEA25, 36, 35);   (* kag D = pos normale *)

(* Configuration des entrees *)
    ProcEntreeIntrins (  1, CdvHEA11A);
    ProcEntreeIntrins (  2, CdvHEA11B);
    ProcEntreeIntrins (  3, CdvHEA12);
    ProcEntreeIntrins (  4, SigHEA12kv);
    ProcEntreeIntrins (  5, SigHEA12kj);
    ProcEntreeIntrins (  8, SigHEA13);
    ProcEntreeIntrins (  9, CdvHEA16A);
    ProcEntreeIntrins ( 10, CdvHEA16B);

    ProcEntreeIntrins ( 11, CdvHEA28);
    ProcEntreeIntrins ( 12, SigHEA28);
    ProcEntreeIntrins ( 13, SigHEA26kv);
    ProcEntreeIntrins ( 14, SigHEA26kj);
    ProcEntreeIntrins ( 17, SigHEA24kv);
    ProcEntreeIntrins ( 18, SigHEA24kj);
    ProcEntreeIntrins ( 19, CdvHEA21B);
    ProcEntreeIntrins ( 20, CdvHEA21A);
    ProcEntreeIntrins ( 21, CdvHEA20);

    ProcEntreeIntrins ( 22, SigHEAzA);
    ProcEntreeIntrins ( 23, SigHEAzB);
    ProcEntreeIntrins ( 24, Sp1HEA);
    ProcEntreeIntrins ( 25, Sp2HEA);
    ProcEntreeIntrins ( 28, CdvHEA13A);
    ProcEntreeIntrins ( 29, CdvHEA27);
    ProcEntreeIntrins ( 30, CdvHEA25);
    ProcEntreeIntrins ( 31, SigHEA15);
    ProcEntreeIntrins ( 32, CdvHEA15);
    ProcEntreeIntrins ( 33, CdvHEA26);
    ProcEntreeIntrins ( 34, CdvHEA22);
    ProcEntreeIntrins ( 37, Sp2REP);

(* CONFIGURATION POUR LA MAINTENANCE de la transmission continue *)
   ConfigurerBoucle(Boucle1, 1);
   ConfigurerBoucle(Boucle2, 2);
   ConfigurerBoucle(Boucle3, 3);
   ConfigurerBoucle(Boucle4, 4);
   ConfigurerBoucle(Boucle5, 5);

   ConfigurerAmpli(Ampli11, 1, 1, 154, 11, FALSE);
   ConfigurerAmpli(Ampli12, 1, 2, 155, 12, FALSE);
   ConfigurerAmpli(Ampli13, 1, 3, 156, 12, FALSE);
   ConfigurerAmpli(Ampli14, 1, 4, 157, 12, TRUE);

   ConfigurerAmpli(Ampli21, 2, 1, 158, 13, FALSE);
   ConfigurerAmpli(Ampli22, 2, 2, 159, 14, FALSE);
   ConfigurerAmpli(Ampli23, 2, 3, 192, 14, FALSE);
   ConfigurerAmpli(Ampli24, 2, 4, 193, 14, TRUE);
   ConfigurerAmpli(Ampli25, 2, 5, 194, 15, FALSE);
   ConfigurerAmpli(Ampli26, 2, 6, 195, 15, FALSE);
   ConfigurerAmpli(Ampli27, 2, 7, 196, 15, TRUE);
   ConfigurerAmpli(Ampli28, 2, 8, 197, 16, FALSE);
   ConfigurerAmpli(Ampli29, 2, 9, 198, 16, FALSE);
   ConfigurerAmpli(Ampli2A, 2, 10, 199, 16, TRUE);


   ConfigurerAmpli(Ampli31, 3, 1, 200, 21, FALSE);
   ConfigurerAmpli(Ampli32, 3, 2, 201, 22, FALSE);
   ConfigurerAmpli(Ampli33, 3, 3, 202, 22, FALSE);
   ConfigurerAmpli(Ampli34, 3, 4, 203, 22, TRUE); 
   ConfigurerAmpli(Ampli35, 3, 5, 204, 23, FALSE);     
   ConfigurerAmpli(Ampli37, 3, 7, 206, 23, TRUE);     

   ConfigurerAmpli(Ampli41, 4, 1, 207, 24, FALSE);
   ConfigurerAmpli(Ampli42, 4, 2, 208, 25, FALSE);
   ConfigurerAmpli(Ampli43, 4, 3, 209, 25, FALSE);
   ConfigurerAmpli(Ampli44, 4, 4, 210, 25, TRUE); 

   ConfigurerAmpli(Ampli51, 5, 1, 211, 26, FALSE);
   ConfigurerAmpli(Ampli52, 5, 2, 212, 27, FALSE);
   ConfigurerAmpli(Ampli53, 5, 3, 213, 27, FALSE);
   ConfigurerAmpli(Ampli54, 5, 4, 214, 27, TRUE); 
   ConfigurerAmpli(Ampli55, 5, 5, 215, 28, FALSE);     
   ConfigurerAmpli(Ampli57, 5, 7, 217, 28, TRUE);     

 (** cartes CES **)
   ConfigurerCES(CarteCes1, 01);
   ConfigurerCES(CarteCes2, 02);
   ConfigurerCES(CarteCes3, 03);
   ConfigurerCES(CarteCes4, 04);
   ConfigurerCES(CarteCes5, 05);


(** Liaisons Inter-Secteur **)

   ConfigurerIntsecteur(Intersecteur1, 01, trL0126, trL0124);
   ConfigurerIntsecteur(Intersecteur2, 02, trL0212, trfictive);


(* Initialisations des variables ne correspondant pas a des entrees secu *)
(* Point d'arret *)
    AffectBoolD( BoolRestrictif, PtArrCdvHEA11);
    AffectBoolD( BoolRestrictif, PtArrCdvHEA12);
    AffectBoolD( BoolRestrictif, PtArrSigHEA12);
    AffectBoolD( BoolRestrictif, PtArrSigHEA13);
    AffectBoolD( BoolRestrictif, PtArrCdvHEA15);
    AffectBoolD( BoolRestrictif, PtArrCdvHEA16B);

    AffectBoolD( BoolRestrictif, PtArrCdvHEA28);
    AffectBoolD( BoolRestrictif, PtArrSigHEA28);
    AffectBoolD( BoolRestrictif, PtArrCdvHEA26);
    AffectBoolD( BoolRestrictif, PtArrSigHEA26);
    AffectBoolD( BoolRestrictif, PtArrSigHEA24);
    AffectBoolD( BoolRestrictif, PtArrCdvHEA21);
    AffectBoolD( BoolRestrictif, PtArrCdvHEA20);

    AffectBoolD( BoolRestrictif, PtArrSigHEA15);
    AffectBoolD( BoolRestrictif, PtArrSigHEAzA);
    AffectBoolD( BoolRestrictif, PtArrSigHEAzB);
    AffectBoolD( BoolPermissif,  PtArrSpec16A);

(* Aiguilles fictives *)

(* Tiv Com non lies a une aiguille *)
    AffectBoolD( BoolRestrictif, TivComHEA12);
    AffectBoolD( BoolRestrictif, TivComHEA26);
    AffectBoolD( BoolRestrictif, TivComHEA24);

(* Variants anticipes *)
    AffectBoolD( BoolRestrictif, PtAntCdvLAM11);
    AffectBoolD( BoolRestrictif, PtAntCdvLAM12);
    AffectBoolD( BoolRestrictif, PtAntSigHEB46B);
    AffectBoolD( BoolRestrictif, PtAntCdvULA23);
    AffectBoolD( BoolRestrictif, PtAntCdvULA22);

(* Variants commutes *)
    AffectBoolD( BoolRestrictif, VarComTron1_10);
    AffectBoolD( BoolRestrictif, VarComTron1_11);

(* Copie des entrees dans des variables fonctionnelles pour la regulation *)
    CdvHEA12Fonc := FALSE;
    CdvHEA22Fonc := FALSE;
    CdvHEA15Fonc := FALSE;
    CdvHEA26Fonc := FALSE;

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

   ConfigEmisTeleSolTrain ( te11s25t01,
                            noBoucle1,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te13s25t02,
                            noBoucle2,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te21s25t03,
                            noBoucle3,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te24s25t04,
                            noBoucle4,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te26s25t05,
                            noBoucle5,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);


(* CONFIGURATION POUR LA REGULATION *)
   ConfigQuai (10, 74, CdvHEA12Fonc, te11s25t01, 0, 1,  2,  8,  3, 13, 14, 15);
   ConfigQuai (10, 79, CdvHEA22Fonc, te24s25t04, 0, 8,  9, 11, 10, 13, 14, 15);
   ConfigQuai (11, 64, CdvHEA15Fonc, te13s25t02, 0, 4, 11,  5, 10, 13, 14, 15);
   ConfigQuai (11, 69, CdvHEA26Fonc, te21s25t03, 0, 8,  3,  9,  4, 13, 14, 15);

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
   ProcEmisSolTrain( te11s25t01.EmissionSensUp, (2*noBoucle1), 
                     LigneL01+ L0125+ TRONC*01,

              PtArrCdvHEA11,
              PtArrCdvHEA12,
              PtArrSigHEA12,
              BoolRestrictif,           (* aspect croix *)
              TivComHEA12,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
(* Variants Anticipes *)
              AigHEA13.PosReverseFiltree,
              AigHEA13.PosNormaleFiltree,
              VarComTron1_10,
              VarComTron1_11,
              BoolRestrictif,
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
(* variants troncon 2   voie 1 et 2 --> si  *)
   ProcEmisSolTrain( te13s25t02.EmissionSensUp, (2*noBoucle2), 
                     LigneL01+ L0125+ TRONC*02,

              AigHEA13.PosReverseFiltree,
              AigHEA13.PosNormaleFiltree,
              PtArrSigHEA13,
              BoolRestrictif,           (* aspect croix *)
              PtArrCdvHEA15,
              PtArrSpec16A,
              PtArrCdvHEA16B,
              PtArrSigHEAzB,
              BoolRestrictif,           (* aspect croix *)
              AigHEAzB1.PosReverseFiltree,
              AigHEAzB1.PosNormaleFiltree,
              AigHEA25.PosReverseFiltree,
              AigHEA25.PosNormaleFiltree,
              BoolRestrictif,           (* signal rouge fix fictif SigHEA26B *)
              BoolRestrictif,           (* aspect croix *)
(* Variants Anticipes *)
              PtAntCdvLAM11,
              PtAntCdvLAM12,
              PtAntSigHEB46B,
              BoolRestrictif,           (* aspect croix *)
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolPermissif,
              BaseSorVar + 30);


(* variants troncon 3    voie 2  ---> sp  *)
   ProcEmisSolTrain( te21s25t03.EmissionSensUp, (2*noBoucle3), 
                     LigneL01+ L0125+ TRONC*03,

              PtArrSigHEA28,
              BoolRestrictif,           (* aspect croix *)
              PtArrCdvHEA26,
              PtArrSigHEA26,
              BoolRestrictif,           (* aspect croix *)
              TivComHEA26,
              AigHEA24.PosReverseFiltree,
              AigHEA24.PosNormaleFiltree,
              PtArrSigHEA24,
              BoolRestrictif,           (* aspect croix *)
              TivComHEA24,
(* Variants Anticipes *)
              PtArrCdvHEA21,
              PtArrSigHEAzA,
              BoolRestrictif,           (* aspect croix *)
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
   ProcEmisSolTrain( te24s25t04.EmissionSensUp, (2*noBoucle4), 
                     LigneL01+ L0125+ TRONC*04,
  
              PtArrCdvHEA21,
              PtArrCdvHEA20,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
(* Variants Anticipes *)
              PtAntCdvULA23,
              PtAntCdvULA22,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
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
   ProcEmisSolTrain( te26s25t05.EmissionSensUp, (2*noBoucle5), 
                     LigneL01+ L0125+ TRONC*05,

              PtArrSigHEA15,
              BoolRestrictif,           (* aspect croix *)
              PtArrSigHEAzA,
              BoolRestrictif,           (* aspect croix *)
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
(* Variants Anticipes *)
              PtArrCdvHEA21,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
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
(* reception du secteur 26 -aval- *)

   ProcReceptInterSecteur(trL0126, noBoucleudc, LigneL01+ L0126+ TRONC*01,
                  PtAntCdvLAM11,
                  PtAntCdvLAM12,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
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

(* reception du secteur 24 -amont- *)

   ProcReceptInterSecteur(trL0124, noBouclecen, LigneL01+ L0124+ TRONC*03,

                  PtAntCdvULA23,
                  PtAntCdvULA22,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
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

(* reception du secteur 12 -adjacent- ligne 2 *)
   ProcReceptInterSecteur(trL0212, noBoucleheb, LigneL01+ L0212+ TRONC*04,
                  PtAntSigHEB46B,
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
                  V3,
                  V4,
                  V5,
		  V6,
		  BaseEntVar + 11);

(*  *)
(* emission vers le secteur 26 -aval- *)

   ProcEmisInterSecteur (teL0126, noBoucleudc, LigneL01+ L0125+ TRONC*03,
			noBoucleudc,
                  PtArrCdvHEA28,
                  PtArrSigHEA28,
                  BoolRestrictif,           (* aspect croix *)
                  PtArrCdvHEA26,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
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

(* emission vers le secteur 24 -amont- *)

   ProcEmisInterSecteur (teL0124, noBouclecen, LigneL01+ L0125+ TRONC*01,
			noBouclecen,
                  PtArrCdvHEA11,
                  PtArrCdvHEA12,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
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
(*  *)

(* emission vers le secteur 12 -adjacent- ligne 2 *)

   ProcEmisInterSecteur (teL0212, noBoucleheb, LigneL01+ L0125+ TRONC*03,
			noBoucleheb,
                  AigHEA24.PosReverseFiltree,
                  AigHEA24.PosNormaleFiltree,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
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


 (** Emission invariants vers secteur 26 aval L0126 **)

   EmettreSegm(LigneL01+ L0125+ TRONC*03+ SEGM*00, noBoucleudc, SensUp);
   EmettreSegm(LigneL01+ L0125+ TRONC*03+ SEGM*01, noBoucleudc, SensUp);
   EmettreSegm(LigneL01+ L0125+ TRONC*04+ SEGM*00, noBoucleudc, SensUp);

 (** Emission invariants vers secteur 24 amont L0124 **)

   EmettreSegm(LigneL01+ L0125+ TRONC*01+ SEGM*00, noBouclecen, SensUp);
   EmettreSegm(LigneL01+ L0125+ TRONC*02+ SEGM*00, noBouclecen, SensUp);

 (** Emission invariants vers secteur 12 adjat L0212 **)

   EmettreSegm(LigneL01+ L0125+ TRONC*03+ SEGM*01, noBoucleheb, SensUp);
   EmettreSegm(LigneL01+ L0125+ TRONC*03+ SEGM*02, noBoucleheb, SensUp);
   EmettreSegm(LigneL01+ L0125+ TRONC*04+ SEGM*00, noBoucleheb, SensUp);
   EmettreSegm(LigneL01+ L0125+ TRONC*05+ SEGM*01, noBoucleheb, SensUp);


 (** Boucle 1 **)
   EmettreSegm(LigneL01+ L0125+ TRONC*01+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL01+ L0125+ TRONC*02+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL01+ L0125+ TRONC*02+ SEGM*01, noBoucle1, SensUp);
   EmettreSegm(LigneL01+ L0126+ TRONC*01+ SEGM*00, noBoucle1, SensUp);

 (** Boucle 2 **)
   EmettreSegm(LigneL01+ L0125+ TRONC*02+ SEGM*02, noBoucle2, SensUp);
   EmettreSegm(LigneL01+ L0126+ TRONC*01+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL01+ L0126+ TRONC*01+ SEGM*01, noBoucle2, SensUp);
   EmettreSegm(LigneL01+ L0212+ TRONC*04+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL01+ L0125+ TRONC*03+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL01+ L0125+ TRONC*05+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL01+ L0125+ TRONC*05+ SEGM*01, noBoucle2, SensUp);

 (** Boucle 3 **)
   EmettreSegm(LigneL01+ L0125+ TRONC*03+ SEGM*00, noBoucle3, SensUp);
   EmettreSegm(LigneL01+ L0125+ TRONC*03+ SEGM*01, noBoucle3, SensUp);
   EmettreSegm(LigneL01+ L0125+ TRONC*03+ SEGM*02, noBoucle3, SensUp);
   EmettreSegm(LigneL01+ L0125+ TRONC*04+ SEGM*00, noBoucle3, SensUp);
   EmettreSegm(LigneL01+ L0125+ TRONC*05+ SEGM*01, noBoucle3, SensUp);
   EmettreSegm(LigneL01+ L0124+ TRONC*03+ SEGM*00, noBoucle3, SensUp);

 (** Boucle 4 **)
   EmettreSegm(LigneL01+ L0125+ TRONC*04+ SEGM*01, noBoucle4, SensUp);
   EmettreSegm(LigneL01+ L0124+ TRONC*03+ SEGM*00, noBoucle4, SensUp);
   EmettreSegm(LigneL01+ L0124+ TRONC*04+ SEGM*00, noBoucle4, SensUp);

 (** Boucle 5 **)
   EmettreSegm(LigneL01+ L0125+ TRONC*05+ SEGM*00, noBoucle5, SensUp);
   EmettreSegm(LigneL01+ L0125+ TRONC*05+ SEGM*01, noBoucle5, SensUp);
   EmettreSegm(LigneL01+ L0125+ TRONC*04+ SEGM*01, noBoucle5, SensUp);
   EmettreSegm(LigneL01+ L0125+ TRONC*04+ SEGM*00, noBoucle5, SensUp);
   EmettreSegm(LigneL01+ L0125+ TRONC*02+ SEGM*00, noBoucle5, SensUp);
   EmettreSegm(LigneL01+ L0125+ TRONC*02+ SEGM*01, noBoucle5, SensUp);

(*  *)

(*************************** CONFIGURATION DES TRONCONS TSR **************************)

   ConfigurerTroncon(Tronc0, LigneL01 + L0125 + TRONC*01, 2,2,2,2);  (* troncon 25-1 *)
   ConfigurerTroncon(Tronc1, LigneL01 + L0125 + TRONC*02, 2,2,2,2);  (* troncon 25-2 *)
   ConfigurerTroncon(Tronc2, LigneL01 + L0125 + TRONC*03, 2,2,2,2);  (* troncon 25-3 *)
   ConfigurerTroncon(Tronc3, LigneL01 + L0125 + TRONC*04, 2,2,2,2);  (* troncon 25-4 *)
   ConfigurerTroncon(Tronc4, LigneL01 + L0125 + TRONC*05, 2,2,2,2);  (* troncon 25-5 *)


(************************************** EMISSION DES TSR *************************************)



(** Emission des TSR vers le secteur aval 26 L0126 **)

   EmettreTronc(LigneL01+ L0125+ TRONC*03, noBoucleudc, SensUp); 
   EmettreTronc(LigneL01+ L0125+ TRONC*04, noBoucleudc, SensUp); 

(** Emission des TSR vers le secteur amont 24 L0124 **)

   EmettreTronc(LigneL01+ L0125+ TRONC*01, noBouclecen, SensUp);
   EmettreTronc(LigneL01+ L0125+ TRONC*02, noBouclecen, SensUp); 

(** Emission des TSR vers le secteur adjacent 12 L0212 **)

   EmettreTronc(LigneL01+ L0125+ TRONC*03, noBoucleheb, SensUp);
   EmettreTronc(LigneL01+ L0125+ TRONC*04, noBoucleheb, SensUp);
   EmettreTronc(LigneL01+ L0125+ TRONC*05, noBoucleheb, SensUp);


 (** Emission des TSR sur les troncons du secteur courant **)

   EmettreTronc(LigneL01+ L0125+ TRONC*01, noBoucle1, SensUp); (* troncon 25-1 *)
   EmettreTronc(LigneL01+ L0125+ TRONC*02, noBoucle1, SensUp);
   EmettreTronc(LigneL01+ L0126+ TRONC*01, noBoucle1, SensUp);


   EmettreTronc(LigneL01+ L0125+ TRONC*02, noBoucle2, SensUp); (* troncon 25-2 *)
   EmettreTronc(LigneL01+ L0126+ TRONC*01, noBoucle2, SensUp);
   EmettreTronc(LigneL01+ L0212+ TRONC*04, noBoucle2, SensUp);
   EmettreTronc(LigneL01+ L0125+ TRONC*03, noBoucle2, SensUp);
   EmettreTronc(LigneL01+ L0125+ TRONC*05, noBoucle2, SensUp);


   EmettreTronc(LigneL01+ L0125+ TRONC*03, noBoucle3, SensUp); (* troncon 25-3 *)
   EmettreTronc(LigneL01+ L0125+ TRONC*04, noBoucle3, SensUp);
   EmettreTronc(LigneL01+ L0125+ TRONC*05, noBoucle3, SensUp);
   EmettreTronc(LigneL01+ L0124+ TRONC*03, noBoucle3, SensUp); 


   EmettreTronc(LigneL01+ L0125+ TRONC*04, noBoucle4, SensUp); (* troncon 25-4 *)
   EmettreTronc(LigneL01+ L0124+ TRONC*03, noBoucle4, SensUp);
   EmettreTronc(LigneL01+ L0124+ TRONC*04, noBoucle4, SensUp);


   EmettreTronc(LigneL01+ L0125+ TRONC*05, noBoucle5, SensUp); (* troncon 25-5 *)
   EmettreTronc(LigneL01+ L0125+ TRONC*04, noBoucle5, SensUp);
   EmettreTronc(LigneL01+ L0125+ TRONC*02, noBoucle5, SensUp);

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
    StockAdres( ADR( CdvHEA11A));
    StockAdres( ADR( CdvHEA11B));
    StockAdres( ADR( CdvHEA12));
    StockAdres( ADR( SigHEA12kv));
    StockAdres( ADR( SigHEA12kj));
    StockAdres( ADR( SigHEA13));
    StockAdres( ADR( CdvHEA16A));
    StockAdres( ADR( CdvHEA16B));
    StockAdres( ADR( CdvHEA28));
    StockAdres( ADR( SigHEA28));
    StockAdres( ADR( SigHEA26kv));
    StockAdres( ADR( SigHEA26kj));
    StockAdres( ADR( SigHEA24kv));
    StockAdres( ADR( SigHEA24kj));
    StockAdres( ADR( CdvHEA21B));
    StockAdres( ADR( CdvHEA21A));
    StockAdres( ADR( CdvHEA20));
    StockAdres( ADR( SigHEAzA));
    StockAdres( ADR( SigHEAzB));
    StockAdres( ADR( Sp1HEA));
    StockAdres( ADR( Sp2HEA));
    StockAdres( ADR( CdvHEA13A));
    StockAdres( ADR( CdvHEA27));
    StockAdres( ADR( CdvHEA25));
    StockAdres( ADR( SigHEA15));
    StockAdres( ADR( CdvHEA15));
    StockAdres( ADR( CdvHEA26));
    StockAdres( ADR( CdvHEA22));
    StockAdres( ADR( Sp2REP));

    StockAdres( ADR( AigHEA13));
    StockAdres( ADR( AigHEA24));
    StockAdres( ADR( AigHEAzB1));
    StockAdres( ADR( AigHEA25));

    StockAdres( ADR( PtArrCdvHEA11));
    StockAdres( ADR( PtArrCdvHEA12));
    StockAdres( ADR( PtArrSigHEA12));
    StockAdres( ADR( PtArrSigHEA13));
    StockAdres( ADR( PtArrCdvHEA15));
    StockAdres( ADR( PtArrCdvHEA16B));
    StockAdres( ADR( PtArrCdvHEA28));
    StockAdres( ADR( PtArrSigHEA28));
    StockAdres( ADR( PtArrCdvHEA26));
    StockAdres( ADR( PtArrSigHEA26));
    StockAdres( ADR( PtArrSigHEA24));
    StockAdres( ADR( PtArrCdvHEA21));
    StockAdres( ADR( PtArrCdvHEA20));
    StockAdres( ADR( PtArrSigHEA15));
    StockAdres( ADR( PtArrSigHEAzA));
    StockAdres( ADR( PtArrSigHEAzB));
    StockAdres( ADR( PtArrSpec16A));

    StockAdres( ADR( TivComHEA12));
    StockAdres( ADR( TivComHEA26));
    StockAdres( ADR( TivComHEA24));

    StockAdres( ADR( PtAntCdvLAM11));
    StockAdres( ADR( PtAntCdvLAM12));
    StockAdres( ADR( PtAntSigHEB46B));
    StockAdres( ADR( PtAntCdvULA23));
    StockAdres( ADR( PtAntCdvULA22));

    StockAdres( ADR( VarComTron1_10));
    StockAdres( ADR( VarComTron1_11));

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
VAR BoolTr1, BoolTr2 : BoolLD;

BEGIN (* ExeSpecific *)

(* Affectation des "constantes" utilisees dans la construction des messages emis    *)
(* et recus sur les boucles de transmission continue et sur les liens intersecteur. *)
(* Cette reaffectation est necessaire a chaque cycle pour la mise en securite.      *)
   AffectBoolC(Vrai, BoolPermissif)  ;
   AffectBoolC(Faux, BoolRestrictif) ;

(* regulation *)
  CdvHEA12Fonc := CdvHEA12.F = Vrai.F;
  CdvHEA22Fonc := CdvHEA22.F = Vrai.F;
  CdvHEA15Fonc := CdvHEA15.F = Vrai.F;
  CdvHEA26Fonc := CdvHEA26.F = Vrai.F;



(*  *)
(*********************************** FILTRAGE DES AIGUILLES ******************************)

   FiltrerAiguille( AigHEA13, BaseExeAig);
   FiltrerAiguille( AigHEA24, BaseExeAig + 2);
   FiltrerAiguille( AigHEAzB1,BaseExeAig + 4);
   FiltrerAiguille( AigHEA25, BaseExeAig + 6);

(************************** Gerer les aiguilles non lues **********************)


(******************* Gerer les Tiv Com non lies a une aiguille ****************)

   AffectBoolD( SigHEA12kv,                 TivComHEA12);
   AffectBoolD( SigHEA26kv,                 TivComHEA26);
   AffectBoolD( SigHEA24kv,                 TivComHEA24);

(************************** Gerer les point d'arrets **************************)

   EtDD(        CdvHEA11A,    CdvHEA11B,    PtArrCdvHEA11);
   EtDD(        CdvHEA12,     CdvHEA13A,    PtArrCdvHEA12);
   OuDD(        SigHEA12kv,   SigHEA12kj,   PtArrSigHEA12);
   AffectBoolD( SigHEA13,                   PtArrSigHEA13);
   EtDD(        CdvHEA15,     CdvHEA16A,    PtArrCdvHEA15);

(* 24/02/2000 : Modif. de la gestion du SP2                  *)
   AffectBoolD( CdvHEA16B,      PtArrCdvHEA16B);
   NonD(        Sp2HEA,       PtArrSpec16A);
(* NonD(        Sp2HEA,       BoolTr1); mais remis plus loin *)
(* EtDD(        CdvHEA16B,    BoolTr1,      PtArrCdvHEA16B); *)


   AffectBoolD( CdvHEA28,                   PtArrCdvHEA28);
   AffectBoolD( SigHEA28,                   PtArrSigHEA28);

   (* Pour le calcul de PtArrCdvHEA26, l'etat du CdvHEA25 est utilise en    *)
   (* fonction de la position de l'aiguille 25. Soit :                      *)
   (* PtArrCdvHEA26 = CdvHEA26 ET (CdvHEA25 OU AigHEA25 en position deviee) *)
   OuDD(        CdvHEA25,     AigHEA25.PosReverseFiltree,  BoolTr2); 
   EtDD(        CdvHEA26,     BoolTr2,      PtArrCdvHEA26);

   OuDD(        SigHEA26kv,   SigHEA26kj,   PtArrSigHEA26);
   OuDD(        SigHEA24kv,   SigHEA24kj,   PtArrSigHEA24);
   EtDD(        CdvHEA21B,    CdvHEA21A,    PtArrCdvHEA21);
   AffectBoolD( CdvHEA20,                   PtArrCdvHEA20);
   AffectBoolD( SigHEA15,                   PtArrSigHEA15);


   (* PtArrSigHEAzA = NON SP1 ET NON SP2 ET SigHEAzA *)
   NonD(        Sp2HEA,       BoolTr1);
   NonD(        Sp1HEA,       BoolTr2);
   EtDD(        BoolTr1,      BoolTr2,      BoolTr1);
   EtDD(        SigHEAzA,     BoolTr1,      PtArrSigHEAzA);
   (* PtArrSigHEAzB = NON SP2 ET SigHEAzB *)
   NonD(        Sp2REP,       BoolTr1);
   EtDD(        SigHEAzB,     BoolTr1,      PtArrSigHEAzB);

(************************ Gerer les vaiants commutes **************************)

   IF Tvrai( AigHEA13.PosNormale) THEN
     AffectBoolD( PtArrSigHEA13, VarComTron1_10);
     AffectBoolD( BoolRestrictif, VarComTron1_11);
   ELSE
     AffectBoolD( PtArrSigHEAzB,  VarComTron1_10);
     AffectBoolD( BoolRestrictif,  VarComTron1_11);
   END;
   FinsiSecu( BaseExeSpecific);

(*** lecture des entrees de regulation ***)

   LireEntreesRegul;

END ExeSpecific;
END Specific.
