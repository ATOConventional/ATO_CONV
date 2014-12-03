IMPLEMENTATION MODULE Specific;

(*$S- *)
(*$T- *)

(******************************************************************************
*   SANTIAGO - LIGNE 1 - Secteur 30
*  =============================
*  Version : SCCS 1.0
*  Date    : 10/07/1997
*  Auteur  : Marc Plywacz
*  Premiere Version
******************************************************************************)

(*---------------------------------------------------------------------------*)
(* Modifications :                                                           *)
(* -------------                                                             *)
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
(* ========= Version 1.1.2 ================================================= *)
(*  Date : 01/10/1997, Auteur : F. Chanier, Origine : Fax F240               *)
(*  l'anticipe GOL23 sur troncon5 passe du 9eme rang au 8eme                 *)
(*                                                                           *)
(* ========= Version 1.1.3 ================================================= *)
(*  Date : 08/10/1997, Auteur : F. Chanier, Origine : Fiche Gauvin AM22      *)
(*  noboucle5 et pas noboucle4 dans l'emission des TSR sur le troncon 5      *)  
(*---------------------------------------------------------------------------*)
(* ========= Version 1.1.4 ================================================= *)
(*  Date : 24/12/1997, Auteur : F. Chanier, Origine : Eq. de DEV             *)
(*     modification pour amelioration de la securite a cause de la non mise  *)
(*     en service des enclenchements                                         *)
(*  nature : rajout de PtArrCdvESC12 calcule comme un                        *)
(*           OU(aiguille 23 deviee , cdvESC13 ) puis un                      *)
(*           ET(CdvESC12 et le derniere variable calculee                    *)
(*           rajout de cette variable dans l'emission du troncon 2           *)
(*           Il est a noter que l'etat de ce cdv etait deja calcule mais     *)
(*           non utilise                                                     *)
(*                                                                           *)
(* ========= Version 1.1.5 ================================================= *)
(*  Date : 23/01/1998, Auteur : F. Chanier, Origine : Eq. de DEV             *)
(*     modification de la detection des pannes d'ampli.                      *)
(*  Date : 19/02/1998, Auteur : P. Hog    , Origine : Eq. de DEV             *)
(*     Modification des marches types.                                       *)
(*---------------------------------------------------------------------------*)
(*****************************************************************************)
(***            AJOUT DE LA NUMEROTATION SCCS DES VERSIONS                ****)
(*---------------------------------------------------------------------------*)
(* Version 1.1.6  =====================                                      *)
(* Version 1.8 DU SERVEUR SCCS =====================                         *)
(* Date :         10/09/1998                                                 *)
(* Auteur:        H. Le Roy                                                  *)
(* Modification : Fiche d'anomalie ba040998                                  *)
(*                Suite a un changement de vitesses maximales, mise a jour   *)
(*                des marches types                                          *)
(*---------------------------------------------------------------------------*)
(* Version 1.1.7  =====================                                      *)
(* Version 1.9 DU SERVEUR SCCS =====================                         *)
(* Date :         04/11/1998                                                 *)
(* Auteur:        H. Le Roy                                                  *)
(* Modification : Emission segment 30.3.0 et troncon associe sur v4 pour     *)
(*                  retournement en 30.4.1                                   *)
(*---------------------------------------------------------------------------*)
(* Version 1.1.8  =====================                                      *)
(* Version 1.10 DU SERVEUR SCCS =====================                        *)
(* Date :         19/04/1999                                                 *)
(* Auteur:        H. Le Roy                                                  *)
(* Modification : Adaptation et modification de la configuration des amplis  *)
(*                 pour detecter les pannes de fusibles.Suppression de       *)
(*                 parties de code inutiles concernant les DAMTC.            *)
(*---------------------------------------------------------------------------*)
(* Version 1.1.9  =====================                                      *)
(* Version 1.11 DU SERVEUR SCCS =====================                        *)
(* Date :         27/06/2000                                                 *)
(* Auteur:        H. Le Roy                                                  *)
(* Modification : Am 165 : Modification des marches types                    *)
(*                                                                           *)
(*---------------------------------------------------------------------------*)
(* Version 1.2.0  =====================                                      *)
(* Version 1.12 DU SERVEUR SCCS =====================                        *)
(* Date :         28/09/2000                                                 *)
(* Auteur:        H. Le Roy                                                  *)
(* Modification : Am Bo032000-2 Avenant                                      *)
(*          Suite au decoupage en 2 des cdv de quai de ESC, modification des *)
(*        entrees secu en consequence. Ajout de l'entree associee au cdv 21. *)
(*        Configuration de la CES 4.                                         *)
(*          Suppression de l'EP en V1 boucle 2. Ajout d'un point d'arret en  *)
(*        milieu de quai.                                                    *)
(*          Ajout d'un point d'arret en milieu de quai V2 boucle 4.          *)
(*          Modification du parametrage des conditions d'emission de la      *)
(*        regulation a ESC v2 suite a la modif. des cdv.                     *)
(*          Modification de l'emission des segment sur la boucle 2 pour      *)
(*        diminuer le temps de retournement en arriere station.              *)
(*          Adaptation de la gestion du dam au decoupage des cdv de quai.    *)
(*---------------------------------------------------------------------------*)
(* Version 1.2.1  =====================                                      *)
(* Version 1.13 DU SERVEUR SCCS =====================                        *)
(* Date :         08/08/2006                                                 *)
(* Auteur:        Rudy Nsiona                                                *)
(* Modification : Nouveau Train NS2004                                       *)
(* Procédure CONFIGURATION DES TRONCONS TSR                                   *)
(*                ancienne valeur 1 , nouvelle 2                             *)
(*---------------------------------------------------------------------------*)

(*---------------------------------------------------------------------------*)

(* Version 1.2.2  =====================                                      *)
(* Version 1.14  DU SERVEUR SCCS =====================                       *)
(* Date :         26/06/2009                                                 *)
(* Auteur:        Marc Plywacz                                               *)
(* Modifications : VERSION SPECIALE POUR TESTS .                             *)
(* ajout CarteCes7  l'etat des entrees est force manuellement                *)
(* ajout PtArrCdvESC08 et PtArrSigESC08 dans troncon 1                       *)
(*---------------------------------------------------------------------------*)
(* Version 1.2.3  =====================                                      *)
(* Version 1.15  DU SERVEUR SCCS =====================                       *)
(* Date :         17/07/2009                                                 *)
(* Auteur:        Ph. Hog                                                    *)
(* Modifications : VERSION SPECIALE POUR TESTS = 1.2.2 + :                   *)
(* ajout TIVCom dans le troncon 2                                            *)
(*---------------------------------------------------------------------------*)
(* Version 1.2.4  =====================                                      *)
(* Version 1.16  DU SERVEUR SCCS =====================                       *)
(* Date :         14/09/2009                                                 *)
(* Auteur:        Marc Plywacz                                               *)
(* Modifications : Prolongement 1                                            *)
(* ajout prolongement jusqu'a la station MANQUEHUE (troncons 6 et 7)         *)
(*                                                                           *)
(*---------------------------------------------------------------------------*)
(* Version 1.2.5  =====================                                      *)
(* Version 1.17  DU SERVEUR SCCS =====================                       *)
(* Date :         14/09/2009                                                 *)
(* Auteur:        Marc Plywacz                                               *)
(* Modifications : Prolongement 1                                            *)
(* ajout affectation des PointsArrets jusqu'a la station MANQUEHUE           *)
(*                                                                           *)
(*---------------------------------------------------------------------------*)
(* Version 1.2.6  =====================                                      *)
(* Version 1.17  DU SERVEUR SCCS =====================                       *)
(* Date :         14/09/2009                                                 *)
(* Auteur:        Marc Plywacz                                               *)
(* Modifications : Prolongement 1                                            *)
(* modif condition position Aiguille dans l'equation de "PtArrSigESC14"      *)
(* PtArrSigMAN23 devient PtArrSpeMAN23                                       *)
(* Aquisition du CdvESC08 de ESCUALA M est faite par l'ES nr 4 et non 44     *)
(* Ajout trans invariants sur ** Boucle 7 **                                 *)
(*---------------------------------------------------------------------------*)
(* Version 1.2.7  =====================                                      *)
(* Version 1.18  DU SERVEUR SCCS =====================                       *)
(* Date :         17/07/2009                                                 *)
(* Auteur:        Ph. Hog                                                    *)
(* Modifications : VERSION SPECIALE POUR TESTS                               *)
(* les variants troncon2 = version spec 1.2.3 + les ES = version spec 1.2.6  *)
(* les variants troncon4 = version spec 1.2.3 + les ES = version spec 1.2.6  *)
(*---------------------------------------------------------------------------*)
(* Version 1.2.8  =====================                                      *)
(* Version 1.19  DU SERVEUR SCCS =====================                       *)
(* Date :         04/12/2009                                                 *)
(* Auteur:        Marc Plywacz                                               *)
(* Modifications : Prolongement 1  (réalisee a pertir de la V126)            *)
(* Suppression des variables CdvESC10B PtArrCdvESC10B.                       *)
(* Suppression de l'aiguille MAN23.                                          *)
(* Suppression de l'emission du 30.4.2 sur le tronçon 4.                     *)
(* Suppression de l'emission du 29.4.0 sur le tronçon 4.                     *)
(* Suppression de l'emission des LTV 29.4 sur le tronçon 4.                  *)
(*---------------------------------------------------------------------------*)
(* Version 1.2.9  =====================                                      *)
(* Version 1.20  DU SERVEUR SCCS =====================                       *)
(* Date :         04/01/2010                                                 *)
(* Auteur:        Marc Plywacz                                               *)
(* Modifications : Prolongement 1                                            *)
(* Ajout marches types ESC-MAN .                                             *)
(*---------------------------------------------------------------------------*)
(* Version 1.3.0  =====================                                      *)
(* Version 1.21  DU SERVEUR SCCS =====================                       *)
(* Date :         17/02/2010                                                 *)
(* Auteur:        Ph. Hog                                                    *)
(* Modifications : Prolongement 1                                            *)
(*   Raccordement au secteur 31 :                                            *)
(*      - Ajout entrée signal MAN12 kv                                       *)
(*      - Ajout émission et reception inter-secteur S31                      *)
(*      - modification du mesage de variant tronçon 7                        *)
(*      - Ajout de la commande d'émision marche type MAN -> HMA              *)
(*   Mise en place des valeurs de marches types :                            *)
(*      ALC -> ESC, ESC -> MAN, MAN -> ESC et ESC -> ALC                     *)
(*   Modifications des émissions pour accélérer le retournement :            *)
(*      - Tr 2, suppression 30.2.0 et 30.2.1                                 *)
(*      - Tr 3, suppression 30.3.0                                           *)
(*      - Tr 4, suppression 30.4.0                                           *)
(*      - Tr 6, suppression 30.6.0                                           *)
(*      - Tr 7, suppression 30.7.0 et 30.7.1                                 *)
(*---------------------------------------------------------------------------*)
(* Version 1.3.1  =====================                                      *)
(* Version 1.22  DU SERVEUR SCCS =====================                       *)
(* Date :         05/05/2010                                                 *)
(* Auteur:        Ph. Hog                                                    *)
(* Modifications : Prolongement 1                                            *)
(*   Suppression de la déclaration de la septieme (7) carte CES              *)
(*   Raccordement au secteur 31 :                                            *)
(*      - Emission inter-secteur S31, TRONC*04                               *)
(*---------------------------------------------------------------------------*)
(* Version 1.3.2  =====================                                      *)
(* Version 1.23  DU SERVEUR SCCS =====================                       *)
(* Date :         15/07/2010                                                 *)
(* Auteur:        Ph. Hog                                                    *)
(* Modifications : Prolongement 1                                            *)
(*   Ajustage de la marche type MQ->HM voie 1                                *)
(*   Ajout du Cdv ESC 11 sur l'entree securitaire 5 (entree 4 de CES 02)     *)
(*   Modification de l'équation du point d'arret specifique ESC22            *)
(*      PtArrSpeESC22 = cdv22a et cdv 21 et (cdv11 ou aguille 21 a droite)   *)
(*---------------------------------------------------------------------------*)


(******************************  IMPORTATIONS  *******************************)

FROM SYSTEM     IMPORT ADR;

FROM Opel       IMPORT StockAdres, AffectBoolD, AffectBoolC, BoolC, BoolD, EtDD, CodeD, NonD,
		       Tvrai, FinBranche, FinArbre, BoolLD, AffectC, OuDD;

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

       Ampli11, Ampli12, Ampli13, Ampli14, Ampli15, Ampli16, 
       Ampli21, Ampli22, Ampli23, Ampli24, Ampli25, Ampli26,
	 Ampli31, Ampli32, Ampli33, Ampli34,
	 Ampli41, Ampli42, Ampli43, Ampli44, Ampli45, Ampli46, Ampli47, Ampli48, Ampli49,
	 Ampli51, Ampli52, Ampli53, Ampli54,
	 Ampli61, Ampli62, Ampli63, Ampli64, Ampli65, Ampli66, Ampli67, Ampli68, Ampli69, Ampli6A,
	 Ampli71, Ampli72, Ampli73, Ampli74, Ampli75, Ampli76, Ampli77, Ampli78, Ampli79, Ampli7A,


          			
(* variables *)
                       Boucle1, Boucle2, Boucle3, Boucle4, Boucle5, Boucle6, Boucle7, BoucleFictive,
		       CarteCes1,  CarteCes2,  CarteCes3,  CarteCes4, CarteCes5, CarteCes6, CarteCes7,
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

    L0131  = 1024*31;    (* numero Secteur aval voie impaire decale de 2**10 *)

    L0130  = 1024*30;    (* numero Secteur local decale de 2**10 *)

    L0129  = 1024*29;    (* numero Secteur amont voie impaire decale de 2**10 *)


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
    noBouclehma = 00;
    noBoucletob = 01; 
    noBouclefi = 02;
    noBoucle1 = 03;
    noBoucle2 = 04;
    noBoucle3 = 05;
    noBoucle4 = 06;
    noBoucle5 = 07;
    noBoucle7 = 09;
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

(* DECLARATION DES SINGULARITES DU SECTEUR 30: dans les deux sens confondus *)

(* Declaration des variables correspondant a des entrees securitaires  *)
(*   - CDV et signaux                                                  *)
    CdvALC11,      (* entree  1, soit entree 0 de CES 02  *)
    CdvALC12,      (* entree  2, soit entree 1 de CES 02  *)
    CdvALC13,      (* entree  3, soit entree 2 de CES 02  *)
    CdvESC08,      (* entree  4, soit entree 3 de CES 02  *)
    CdvESC11,      (* entree  5, soit entree 4 de CES 02  *)
    SigESC10kv,    (* entree  6, soit entree 5 de CES 02  *)
    SigESC10kj,    (* entree  7, soit entree 6 de CES 02  *)


    SigESC12kj,    (* entree 10, soit entree 1 de CES 03  *)
    CdvESC12B,     (* entree 11, soit entree 2 de CES 03  *)
    SigESC22B,     (* entree 12, soit entree 3 de CES 03  *)


    CdvESC22A,     (* entree 15, soit entree 6 de CES 03  *)
    SigESC14,      (* entree 16, soit entree 7 de CES 03  *)
    SigESC24,      (* entree 17, soit entree 0 de CES 04  *)
    SigESC22Akv,   (* entree 18, soit entree 1 de CES 04  *)
    CdvALC23,      (* entree 19, soit entree 2 de CES 04  *)
    CdvALC22,      (* entree 20, soit entree 3 de CES 04  *)
    CdvALC21,      (* entree 21, soit entree 4 de CES 04  *)
    Sp1ESC,        (* entree 22, soit entree 5 de CES 04  *)
    CdvESC13,      (* entree 23, soit entree 6 de CES 04  *)
    CdvESC24,      (* entree 24, soit entree 7 de CES 04  *)

    CdvESC15,      (* entree 25, soit entree 0 de CES 05  *)
    CdvESC21,      (* entree 26, soit entree 1 de CES 05  *)
    CdvMAN10,      (* entree 27, soit entree 2 de CES 05  *)
    CdvESC25,      (* entree 28, soit entree 3 de CES 05  *)
    CdvMAN19,      (* entree 29, soit entree 4 de CES 05  *)
    CdvMAN11,      (* entree 30, soit entree 5 de CES 05  *)
    CdvMAN12A,     (* entree 31, soit entree 6 de CES 05  *)
    CdvMAN12B,     (* entree 32, soit entree 7 de CES 05  *)

    CdvMAN13,      (* entree 33, soit entree 0 de CES 06  *)
    CdvMAN22A,     (* entree 34, soit entree 1 de CES 06  *)
    Sp2ESC,        (* entree 35, soit entree 2 de CES 06  *)
    SigMAN12kj,    (* entree 36, soit entree 3 de CES 06  *)
    SigMAN23kv,    (* entree 37, soit entree 4 de CES 06  *)
    SigMAN23kj,    (* entree 38, soit entree 5 de CES 06  *)


    SigMANzAkj,    (* entree 43, soit entree 2 de CES 07  *)
    SigMAN12kv,    (* entree 44, soit entree 3 de CES 06  *)
    SigESC08,      (* entree 45, soit entree 4 de CES 07  *)
    SigESC12kv,    (* entree 46, soit entree 5 de CES 07  *)
    SigESC22Akj,   (* entree 47, soit entree 6 de CES 07  *)
    CdvMAN20       (* entree 48, soit entree 7 de CES 07  *)
             : BoolD;

(*   - aiguilles                                                       *)

    AigMAN13,      (* entrees 39 et 40, soit entrees 6 et 7 de CES 06  *)

    AigESC11,      (* entrees  8 et  9, soit entrees 7 et 0 de CES 02 et 03 *)
    AigESC23       (* entrees 13 et 14, soit entrees 4 et 5 de CES 03  *)
             :TyAig;



(* Variables ne correspondant pas a une entree securitaire *)
(* Point d'arret *)
    PtArrCdvALC11,
    PtArrCdvALC12,
    PtArrCdvALC13,
    PtArrCdvESC08,
    PtArrSigESC08,

    PtArrSigESC10,
    PtArrSpeESC12,
    PtArrSigESC12,
    PtArrSpeESC14,
    PtArrCdvESC15,

    PtArrCdvMAN10,
    PtArrCdvMAN11,
    PtArrCdvMAN12,

    PtArrSpeMAN12,
    PtArrSigMAN12,

    PtArrSigMANzA,

    PtArrSpeMAN23,
    PtArrCdvMAN20,
    PtArrCdvMAN19,

    PtArrCdvESC25,
    PtArrCdvESC24,
    PtArrSigESC24,

    PtArrSigESC22B,


    PtArrSigESC14,
    PtArrSpeESC22,
    PtArrSigESC22A,
    PtArrCdvALC23,
    PtArrCdvALC22,
    PtArrCdvALC21  : BoolD;

(* Tiv Com *)
    TivComESC12    : BoolD;

(* Variants anticipes *)
    PtAntCdvGOL24,
    PtAntCdvGOL23,
    PtAntCdvMAN15,
    PtAntCdvHMA10,
    PtAntCdvHMA11  : BoolD;

(* Copie des entrees dans des variables fonctionnelles pour la regulation *)

    CdvESC12Fonc,
    CdvESC22Fonc,
    CdvALC12Fonc,
    CdvALC22Fonc,
    CdvMAN12Fonc,
    CdvMAN22Fonc   : BOOLEAN;

(** Voie d'emission SOL-TRAIN : deux sens confondus**)
    
    te31s30t07,
    te35s30t06,

    te11s30t01,
    te14s30t02,
    te16s30t03,
    te21s30t04,
    te24s30t05           :TyEmissionTele;

(** Voie d'emission Inter-secteur deux voies confondues **)
    teL0131, 
    teL0129	          :TyEmissionTele;

(** Voie de reception Inter-secteur deux voies confondues **)
    trL0131, 
    trL0129               :TyCaracEntSec;


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
    EntreeAiguille( AigESC11,  9,  8);
    EntreeAiguille( AigESC23, 13, 14);

    EntreeAiguille( AigMAN13, 40, 39);


(* Configuration des entrees *)
    ProcEntreeIntrins (  1, CdvALC11);
    ProcEntreeIntrins (  2, CdvALC12);
    ProcEntreeIntrins (  3, CdvALC13);
    ProcEntreeIntrins (  4, CdvESC08);
    ProcEntreeIntrins (  5, CdvESC11);
    ProcEntreeIntrins (  6, SigESC10kv); 
    ProcEntreeIntrins (  7, SigESC10kj); 

    ProcEntreeIntrins ( 10, SigESC12kj);
    ProcEntreeIntrins ( 11, CdvESC12B);
    ProcEntreeIntrins ( 12, SigESC22B);

    ProcEntreeIntrins ( 15, CdvESC22A);
    ProcEntreeIntrins ( 16, SigESC14);
    ProcEntreeIntrins ( 17, SigESC24);
    ProcEntreeIntrins ( 18, SigESC22Akv);
    ProcEntreeIntrins ( 19, CdvALC23);
    ProcEntreeIntrins ( 20, CdvALC22);
    ProcEntreeIntrins ( 21, CdvALC21);
    ProcEntreeIntrins ( 22, Sp1ESC);
    ProcEntreeIntrins ( 23, CdvESC13);
    ProcEntreeIntrins ( 24, CdvESC24);
    ProcEntreeIntrins ( 25, CdvESC15);
    ProcEntreeIntrins ( 26, CdvESC21);
    ProcEntreeIntrins ( 27, CdvMAN10);
    ProcEntreeIntrins ( 28, CdvESC25);
    ProcEntreeIntrins ( 29, CdvMAN19);
    ProcEntreeIntrins ( 30, CdvMAN11);
    ProcEntreeIntrins ( 31, CdvMAN12A);
    ProcEntreeIntrins ( 32, CdvMAN12B);

    ProcEntreeIntrins ( 33, CdvMAN13);
    ProcEntreeIntrins ( 34, CdvMAN22A);
    ProcEntreeIntrins ( 35, Sp2ESC);
    ProcEntreeIntrins ( 36, SigMAN12kj);
    ProcEntreeIntrins ( 37, SigMAN23kv);
    ProcEntreeIntrins ( 38, SigMAN23kj);


    ProcEntreeIntrins ( 43, SigMANzAkj);
    ProcEntreeIntrins ( 44, SigMAN12kv);
    ProcEntreeIntrins ( 45, SigESC08);
    ProcEntreeIntrins ( 46, SigESC12kv);
    ProcEntreeIntrins ( 47, SigESC22Akj);
    ProcEntreeIntrins ( 48, CdvMAN20);


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

   ConfigurerAmpli(Ampli15, 1, 5, 158, 13, FALSE);

   ConfigurerAmpli(Ampli16, 1, 6, 210, 18, FALSE);

   ConfigurerAmpli(Ampli21, 2, 1, 159, 14, FALSE);
   ConfigurerAmpli(Ampli22, 2, 2, 192, 15, FALSE);
   ConfigurerAmpli(Ampli23, 2, 3, 193, 15, FALSE);
   ConfigurerAmpli(Ampli24, 2, 4, 194, 15, TRUE);
   ConfigurerAmpli(Ampli25, 2, 5, 195, 13, TRUE);
   ConfigurerAmpli(Ampli26, 2, 6, 211, 18, TRUE);

   ConfigurerAmpli(Ampli31, 3, 1, 196, 16, FALSE);
   ConfigurerAmpli(Ampli32, 3, 2, 197, 17, FALSE);
   ConfigurerAmpli(Ampli33, 3, 3, 198, 17, FALSE);
   ConfigurerAmpli(Ampli34, 3, 4, 199, 17, TRUE);

   ConfigurerAmpli(Ampli41, 4, 1, 200, 21, FALSE);
   ConfigurerAmpli(Ampli42, 4, 2, 201, 22, FALSE);
   ConfigurerAmpli(Ampli43, 4, 3, 202, 22, FALSE);
   ConfigurerAmpli(Ampli44, 4, 4, 203, 22, TRUE);

   ConfigurerAmpli(Ampli45, 4, 5, 204, 23, FALSE);
   ConfigurerAmpli(Ampli46, 4, 6, 205, 23, TRUE);

   ConfigurerAmpli(Ampli47, 4, 7, 212, 26, FALSE);
   ConfigurerAmpli(Ampli48, 4, 8, 213, 26, FALSE);
   ConfigurerAmpli(Ampli49, 4, 9, 214, 26, TRUE);

   ConfigurerAmpli(Ampli51, 5, 1, 206, 24, FALSE);
   ConfigurerAmpli(Ampli52, 5, 2, 207, 25, FALSE);
   ConfigurerAmpli(Ampli53, 5, 3, 208, 25, FALSE);
   ConfigurerAmpli(Ampli54, 5, 4, 209, 25, TRUE);

   ConfigurerAmpli(Ampli71, 7, 1, 215, 31, FALSE);
   ConfigurerAmpli(Ampli72, 7, 2, 216, 32, FALSE);
   ConfigurerAmpli(Ampli73, 7, 3, 217, 32, FALSE);
   ConfigurerAmpli(Ampli74, 7, 4, 218, 32, TRUE);

   ConfigurerAmpli(Ampli75, 7, 5, 219, 33, FALSE);
   ConfigurerAmpli(Ampli76, 7, 6, 220, 33, FALSE);
   ConfigurerAmpli(Ampli77, 7, 7, 221, 33, TRUE);

   ConfigurerAmpli(Ampli78, 7, 8, 222, 34, FALSE);
   ConfigurerAmpli(Ampli79, 7, 9, 223, 34, FALSE);
   ConfigurerAmpli(Ampli7A, 7, 10, 256, 34, TRUE);

   ConfigurerAmpli(Ampli61, 6, 1, 257, 35, FALSE);
   ConfigurerAmpli(Ampli62, 6, 2, 258, 36, FALSE);
   ConfigurerAmpli(Ampli63, 6, 3, 259, 36, FALSE);
   ConfigurerAmpli(Ampli64, 6, 4, 260, 36, TRUE);

   ConfigurerAmpli(Ampli65, 6, 5, 261, 37, FALSE);
   ConfigurerAmpli(Ampli66, 6, 6, 262, 37, FALSE);
   ConfigurerAmpli(Ampli67, 6, 7, 263, 37, TRUE);

   ConfigurerAmpli(Ampli68, 6, 8, 264, 38, FALSE);
   ConfigurerAmpli(Ampli69, 6, 9, 265, 38, FALSE);
   ConfigurerAmpli(Ampli6A, 6, 10, 266, 38, TRUE);





 (** cartes CES **)
   ConfigurerCES(CarteCes1, 01);
   ConfigurerCES(CarteCes2, 02);
   ConfigurerCES(CarteCes3, 03);
   ConfigurerCES(CarteCes4, 04);
   ConfigurerCES(CarteCes5, 05);
   ConfigurerCES(CarteCes6, 06);


(** Liaisons Inter-Secteur **)

   ConfigurerIntsecteur(Intersecteur1, 01, trL0131, trL0129);


(* Initialisations des variables ne correspondant pas a des entrees secu *)
(* Point d'arret *)
    AffectBoolD( BoolRestrictif, PtArrCdvALC11);
    AffectBoolD( BoolRestrictif, PtArrCdvALC12);
    AffectBoolD( BoolRestrictif, PtArrCdvALC13);
    AffectBoolD( BoolRestrictif, PtArrCdvESC08);
    AffectBoolD( BoolRestrictif, PtArrSigESC08);

    AffectBoolD( BoolRestrictif, PtArrSigESC10);
    AffectBoolD( BoolRestrictif, PtArrSpeESC12);
    AffectBoolD( BoolRestrictif, PtArrSigESC12);
    AffectBoolD( BoolRestrictif, PtArrSpeESC14);
    AffectBoolD( BoolRestrictif, PtArrCdvESC15);

    AffectBoolD( BoolRestrictif, PtArrCdvMAN10);
    AffectBoolD( BoolRestrictif, PtArrCdvMAN11);
    AffectBoolD( BoolRestrictif, PtArrCdvMAN12);
    AffectBoolD( BoolRestrictif, PtArrSpeMAN12);
    AffectBoolD( BoolRestrictif, PtArrSigMAN12);


    AffectBoolD( BoolRestrictif, PtArrSigMANzA);
    AffectBoolD( BoolRestrictif, PtArrSpeMAN23);
    AffectBoolD( BoolRestrictif, PtArrCdvMAN20);
    AffectBoolD( BoolRestrictif, PtArrCdvMAN19);

    AffectBoolD( BoolRestrictif, PtArrCdvESC25);
    AffectBoolD( BoolRestrictif, PtArrCdvESC24);
    AffectBoolD( BoolRestrictif, PtArrSigESC24);

    AffectBoolD( BoolRestrictif, PtArrSigESC22B);

    AffectBoolD( BoolRestrictif, PtArrSigESC14);
    AffectBoolD( BoolRestrictif, PtArrSpeESC22);
    AffectBoolD( BoolRestrictif, PtArrSigESC22A);

    AffectBoolD( BoolRestrictif, PtArrCdvALC23);
    AffectBoolD( BoolRestrictif, PtArrCdvALC22);
    AffectBoolD( BoolRestrictif, PtArrCdvALC21);


(* Tiv Com *)
    AffectBoolD( BoolRestrictif, TivComESC12);

(* Variants anticipes *)
    AffectBoolD( BoolRestrictif, PtAntCdvGOL24);
    AffectBoolD( BoolRestrictif, PtAntCdvGOL23);

(* Copie des entrees dans des variables fonctionnelles pour la regulation *)
    CdvESC12Fonc := FALSE;
    CdvESC22Fonc := FALSE;

    CdvALC12Fonc := FALSE;
    CdvALC22Fonc := FALSE;

    CdvMAN12Fonc := FALSE;
    CdvMAN22Fonc := FALSE;

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

   ConfigEmisTeleSolTrain ( te11s30t01,
                            noBoucle1,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te14s30t02,
                            noBoucle2,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te16s30t03,
                            noBoucle3,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te21s30t04,
                            noBoucle4,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te24s30t05,
                            noBoucle5,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te31s30t07,
                            noBoucle7,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te35s30t06,
                            noBoucle6,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

(* CONFIGURATION POUR LA REGULATION *)
   ConfigQuai (23, 74, CdvALC12Fonc, te11s30t01, 0,  8, 8, 3, 9, 13, 14, 15);  (* voie 1 ALC-ESC *)
   ConfigQuai (23, 79, CdvALC22Fonc, te24s30t05, 0, 12, 2, 8, 9, 13, 14, 15);  (* voie 2 ALC-GOL *)

   ConfigQuai (24, 64, CdvESC12Fonc, te14s30t02, 0,  2, 3, 4,11, 13, 14, 15);  (* voie 1 ESC-MAN *)
   ConfigQuai (24, 69, CdvESC22Fonc, te21s30t04, 0, 12, 2, 3, 9, 13, 14, 15);  (* voie 2 ESC-ALC *)

   ConfigQuai (25, 84, CdvMAN12Fonc, te31s30t07, 0,  8, 9,11, 5, 13, 14, 15);  (* voie 1 MAN-HMA *)
   ConfigQuai (25, 89, CdvMAN22Fonc, te35s30t06, 0,  2, 3, 9, 4, 13, 14, 15);  (* voie 2 MAN-ESC *)


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
   ProcEmisSolTrain( te11s30t01.EmissionSensUp, (2*noBoucle1), 
                     LigneL01+ L0130+ TRONC*01,

              PtArrCdvALC11,
              PtArrCdvALC12,
              PtArrCdvALC13,
              PtArrCdvESC08,
              PtArrSigESC08,
              BoolRestrictif,             (* aspect croix *)
              BoolRestrictif,
              BoolRestrictif,
(* Variants Anticipes *)
              PtArrSigESC10,
              BoolRestrictif,             (* aspect croix *)
              AigESC11.PosNormaleFiltree,     (* tivcom *)
              AigESC11.PosReverseFiltree,
              AigESC11.PosNormaleFiltree,
              PtArrSpeESC12,
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
   ProcEmisSolTrain( te14s30t02.EmissionSensUp, (2*noBoucle2), 
                     LigneL01+ L0130+ TRONC*02,

              PtArrSigESC10,
              BoolRestrictif,             (* aspect croix *)
              AigESC11.PosNormaleFiltree,     (* tivcom *)
              AigESC11.PosReverseFiltree,
              AigESC11.PosNormaleFiltree,
	      PtArrSpeESC12,   
              PtArrSigESC12,
              BoolRestrictif,             (* aspect croix *)
              TivComESC12,
              PtArrSpeESC14,
              PtArrCdvESC15,
              PtArrCdvMAN10,

(* Variants Anticipes *)
              PtArrCdvMAN11,
              PtArrCdvMAN12,
              PtArrSpeMAN12,

              PtArrSigESC22B,
              BoolRestrictif,             (* aspect croix *)
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolPermissif,
              BaseSorVar + 30);


(* variants troncon 3    voie 2  ---> si  *)
   ProcEmisSolTrain( te16s30t03.EmissionSensUp, (2*noBoucle3), 
                     LigneL01+ L0130+ TRONC*03,

              PtArrSigESC22B,
              BoolRestrictif,             (* aspect croix *)
              AigESC23.PosReverseFiltree,
              AigESC23.PosNormaleFiltree,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
(* Variants Anticipes *)
              PtArrSpeESC14,
              PtArrCdvESC15,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
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

(* variants troncon 4  voies 1+2 <-- sp *)
   ProcEmisSolTrain( te21s30t04.EmissionSensUp, (2*noBoucle4), 
                     LigneL01+ L0130+ TRONC*04,

	      PtArrSigESC14,
              BoolRestrictif,             (* aspect croix *)
              AigESC23.PosNormaleFiltree,
              AigESC23.PosReverseFiltree,
              PtArrCdvESC24,
	      PtArrSigESC24,
              BoolRestrictif,             (* aspect croix *)
              PtArrSpeESC22,
	      PtArrSigESC22A,
              BoolRestrictif,             (* aspect croix *)
              AigESC11.PosReverseFiltree,
              AigESC11.PosNormaleFiltree,
(* Variants Anticipes *)
              PtArrCdvALC23,
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
   ProcEmisSolTrain( te24s30t05.EmissionSensUp, (2*noBoucle5), 
                     LigneL01+ L0130+ TRONC*05,

              PtArrCdvALC23,
              PtArrCdvALC22,
              PtArrCdvALC21,
              PtAntCdvGOL24,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
(* Variants Anticipes *)
              PtAntCdvGOL23,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
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

(* variants troncon 6  voies z+2 <-- sp *)
   ProcEmisSolTrain( te35s30t06.EmissionSensUp, (2*noBoucle6), 
                     LigneL01+ L0130+ TRONC*06,

	      PtArrSigMANzA,
            BoolRestrictif,             (* aspect croix *)
	        PtArrSpeMAN23,
              PtArrCdvMAN20,
	      PtArrCdvMAN19,
              PtArrCdvESC25,
              BoolRestrictif,
              BoolRestrictif,
(* Variants Anticipes *)
              PtArrCdvESC24,
              PtArrSigESC24,
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
              BaseSorVar + 150);


(* variants troncon 7    voie 1+z  ---> si  *)
   ProcEmisSolTrain( te31s30t07.EmissionSensUp, (2*noBoucle7), 
                     LigneL01+ L0130+ TRONC*07,

              PtArrCdvMAN11,
              PtArrCdvMAN12,
              PtArrSpeMAN12,
              PtArrSigMAN12,
              BoolRestrictif,             (* aspect croix *)
              AigMAN13.PosNormaleFiltree, (* tivcom *)
              AigMAN13.PosReverseFiltree,
              AigMAN13.PosNormaleFiltree,
              BoolRestrictif, (* signal ZB, considere rouge permanant *)
              BoolRestrictif, (* aspect croix *)
              PtAntCdvMAN15,
              PtAntCdvHMA10,
              PtAntCdvHMA11,
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
(* reception du secteur 31 -aval- *)

   ProcReceptInterSecteur(trL0131, noBouclehma, LigneL01+ L0131+ TRONC*01,

                  PtAntCdvMAN15,
                  PtAntCdvHMA10,
                  PtAntCdvHMA11,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
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

(* reception du secteur 29 -amont- *)

   ProcReceptInterSecteur(trL0129, noBoucletob, LigneL01+ L0129+ TRONC*04,

                  PtAntCdvGOL24,
                  PtAntCdvGOL23,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
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
(* emission vers le secteur 31 -aval- *)

   ProcEmisInterSecteur (teL0131, noBouclehma, LigneL01+ L0130+ TRONC*04,
			noBouclehma,
	            PtArrSpeMAN23,
                  PtArrCdvMAN20,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
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

(* emission vers le secteur 29 -amont- *)

   ProcEmisInterSecteur (teL0129, noBoucletob, LigneL01+ L0130+ TRONC*01,
			noBoucletob,
                  PtArrCdvALC11,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
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
            

 (** Emission invariants vers secteur 31 aval L0131 **)

   EmettreSegm(LigneL01+ L0130+ TRONC*06+ SEGM*00, noBouclehma, SensUp);
   EmettreSegm(LigneL01+ L0130+ TRONC*06+ SEGM*01, noBouclehma, SensUp);

 (** Emission invariants vers secteur 29 amont L0129 **)

   EmettreSegm(LigneL01+ L0130+ TRONC*01+ SEGM*00, noBoucletob, SensUp);
   EmettreSegm(LigneL01+ L0130+ TRONC*01+ SEGM*01, noBoucletob, SensUp);



 (** Boucle 1 **)
   EmettreSegm(LigneL01+ L0130+ TRONC*01+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL01+ L0130+ TRONC*01+ SEGM*01, noBoucle1, SensUp);
   EmettreSegm(LigneL01+ L0130+ TRONC*02+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL01+ L0130+ TRONC*02+ SEGM*01, noBoucle1, SensUp);
   EmettreSegm(LigneL01+ L0130+ TRONC*03+ SEGM*00, noBoucle1, SensUp);

 (** Boucle 2 **)
   EmettreSegm(LigneL01+ L0130+ TRONC*02+ SEGM*02, noBoucle2, SensUp);
   EmettreSegm(LigneL01+ L0130+ TRONC*07+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL01+ L0130+ TRONC*07+ SEGM*01, noBoucle2, SensUp);

   EmettreSegm(LigneL01+ L0130+ TRONC*03+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL01+ L0130+ TRONC*04+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL01+ L0130+ TRONC*04+ SEGM*01, noBoucle2, SensUp);

 (** Boucle 3 **)
   EmettreSegm(LigneL01+ L0130+ TRONC*02+ SEGM*02, noBoucle3, SensUp);
   EmettreSegm(LigneL01+ L0130+ TRONC*04+ SEGM*01, noBoucle3, SensUp);

 (** Boucle 4 **)
   EmettreSegm(LigneL01+ L0130+ TRONC*04+ SEGM*01, noBoucle4, SensUp);
   EmettreSegm(LigneL01+ L0130+ TRONC*05+ SEGM*00, noBoucle4, SensUp);
   EmettreSegm(LigneL01+ L0130+ TRONC*05+ SEGM*01, noBoucle4, SensUp);
   EmettreSegm(LigneL01+ L0130+ TRONC*03+ SEGM*00, noBoucle4, SensUp);

 (** Boucle 5 **)
   EmettreSegm(LigneL01+ L0130+ TRONC*05+ SEGM*01, noBoucle5, SensUp);
   EmettreSegm(LigneL01+ L0129+ TRONC*04+ SEGM*00, noBoucle5, SensUp);
   EmettreSegm(LigneL01+ L0129+ TRONC*05+ SEGM*00, noBoucle5, SensUp);
  

 (** Boucle 6 **)
   EmettreSegm(LigneL01+ L0130+ TRONC*06+ SEGM*01, noBoucle6, SensUp);
   EmettreSegm(LigneL01+ L0130+ TRONC*04+ SEGM*01, noBoucle6, SensUp);
   EmettreSegm(LigneL01+ L0130+ TRONC*04+ SEGM*02, noBoucle6, SensUp);

 (** Boucle 7 **)
   EmettreSegm(LigneL01+ L0130+ TRONC*06+ SEGM*01, noBoucle7, SensUp);
   EmettreSegm(LigneL01+ L0130+ TRONC*06+ SEGM*00, noBoucle7, SensUp);
   EmettreSegm(LigneL01+ L0131+ TRONC*01+ SEGM*00, noBoucle7, SensUp);
   EmettreSegm(LigneL01+ L0131+ TRONC*01+ SEGM*01, noBoucle7, SensUp);

(*  *)

(************************* CONFIGURATION DES TRONCONS TSR ****************************)

   ConfigurerTroncon(Tronc0, LigneL01 + L0130 + TRONC*01, 2,2,2,2);  (* troncon 30-1 *)
   ConfigurerTroncon(Tronc1, LigneL01 + L0130 + TRONC*02, 2,2,2,2);  (* troncon 30-2 *)
   ConfigurerTroncon(Tronc2, LigneL01 + L0130 + TRONC*03, 2,2,2,2);  (* troncon 30-3 *)
   ConfigurerTroncon(Tronc3, LigneL01 + L0130 + TRONC*04, 2,2,2,2);  (* troncon 30-4 *)
   ConfigurerTroncon(Tronc4, LigneL01 + L0130 + TRONC*05, 2,2,2,2);  (* troncon 30-5 *)
   ConfigurerTroncon(Tronc5, LigneL01 + L0130 + TRONC*06, 2,2,2,2);  (* troncon 30-6 *)
   ConfigurerTroncon(Tronc6, LigneL01 + L0130 + TRONC*07, 2,2,2,2);  (* troncon 30-7 *)


(******************************* EMISSION DES TSR ************************************)



(** Emission des TSR vers le secteur aval 31 L0131 **)

   EmettreTronc(LigneL01+ L0130+ TRONC*06, noBouclehma, SensUp);


(** Emission des TSR vers le secteur amont 29 L0129 **)

   EmettreTronc(LigneL01+ L0130+ TRONC*01, noBoucletob, SensUp);



 (** Emission des TSR sur les troncons du secteur courant **)

   EmettreTronc(LigneL01+ L0130+ TRONC*01, noBoucle1, SensUp); (* troncon 30-1 *)
   EmettreTronc(LigneL01+ L0130+ TRONC*02, noBoucle1, SensUp);
   EmettreTronc(LigneL01+ L0130+ TRONC*03, noBoucle1, SensUp);


   EmettreTronc(LigneL01+ L0130+ TRONC*02, noBoucle2, SensUp); (* troncon 30-2 *)
   EmettreTronc(LigneL01+ L0130+ TRONC*03, noBoucle2, SensUp);
   EmettreTronc(LigneL01+ L0130+ TRONC*04, noBoucle2, SensUp);
   EmettreTronc(LigneL01+ L0130+ TRONC*07, noBoucle2, SensUp);


   EmettreTronc(LigneL01+ L0130+ TRONC*03, noBoucle3, SensUp); (* troncon 30-3 *)
   EmettreTronc(LigneL01+ L0130+ TRONC*02, noBoucle3, SensUp);
   EmettreTronc(LigneL01+ L0130+ TRONC*04, noBoucle3, SensUp);


   EmettreTronc(LigneL01+ L0130+ TRONC*04, noBoucle4, SensUp); (* troncon 30-4 *)
   EmettreTronc(LigneL01+ L0130+ TRONC*05, noBoucle4, SensUp);
   EmettreTronc(LigneL01+ L0130+ TRONC*03, noBoucle4, SensUp);


   EmettreTronc(LigneL01+ L0130+ TRONC*05, noBoucle5, SensUp); (* troncon 30-5 *)
   EmettreTronc(LigneL01+ L0129+ TRONC*04, noBoucle5, SensUp);
   EmettreTronc(LigneL01+ L0129+ TRONC*05, noBoucle5, SensUp);


   EmettreTronc(LigneL01+ L0130+ TRONC*06, noBoucle6, SensUp); (* troncon 30-6 *)
   EmettreTronc(LigneL01+ L0130+ TRONC*04, noBoucle6, SensUp);

   EmettreTronc(LigneL01+ L0130+ TRONC*06, noBoucle7, SensUp); (* troncon 30-7 *)
   EmettreTronc(LigneL01+ L0130+ TRONC*07, noBoucle7, SensUp);
   EmettreTronc(LigneL01+ L0131+ TRONC*01, noBoucle7, SensUp);

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
    StockAdres( ADR( CdvALC11));
    StockAdres( ADR( CdvALC12));
    StockAdres( ADR( CdvALC13));
    StockAdres( ADR( CdvESC08));
    StockAdres( ADR( CdvESC11));
    StockAdres( ADR( SigESC10kv));
    StockAdres( ADR( SigESC10kj));


    StockAdres( ADR( SigESC12kj));
    StockAdres( ADR( CdvESC12B));
    StockAdres( ADR( SigESC22B));


    StockAdres( ADR( CdvESC22A));
    StockAdres( ADR( SigESC14));
    StockAdres( ADR( SigESC24));
    StockAdres( ADR( SigESC22Akv));
    StockAdres( ADR( CdvALC23));
    StockAdres( ADR( CdvALC22));
    StockAdres( ADR( CdvALC21));
    StockAdres( ADR( Sp1ESC));
    StockAdres( ADR( CdvESC13));
    StockAdres( ADR( CdvESC24));

    StockAdres( ADR( CdvESC15));
    StockAdres( ADR( CdvESC21));
    StockAdres( ADR( CdvMAN10));
    StockAdres( ADR( CdvESC25));
    StockAdres( ADR( CdvMAN19));
    StockAdres( ADR( CdvMAN11));
    StockAdres( ADR( CdvMAN12A));
    StockAdres( ADR( CdvMAN12B));

    StockAdres( ADR( CdvMAN13));
    StockAdres( ADR( CdvMAN22A));
    StockAdres( ADR( Sp2ESC));
    StockAdres( ADR( SigMAN12kj));
    StockAdres( ADR( SigMAN23kv));
    StockAdres( ADR( SigMAN23kj));


    StockAdres( ADR( SigMANzAkj));
    StockAdres( ADR( SigMAN12kv));
    StockAdres( ADR( SigESC08));
    StockAdres( ADR( SigESC12kv));
    StockAdres( ADR( SigESC22Akj));
    StockAdres( ADR( CdvMAN20));

    StockAdres( ADR( AigESC11));
    StockAdres( ADR( AigESC23));
    StockAdres( ADR( AigMAN13));

    StockAdres( ADR( PtArrCdvALC11));
    StockAdres( ADR( PtArrCdvALC12));
    StockAdres( ADR( PtArrCdvALC13));
    StockAdres( ADR( PtArrCdvESC08));
    StockAdres( ADR( PtArrSigESC08));

    StockAdres( ADR( PtArrSigESC10));
    StockAdres( ADR( PtArrSpeESC12));
    StockAdres( ADR( PtArrSigESC12));
    StockAdres( ADR( PtArrSpeESC14));
    StockAdres( ADR( PtArrCdvESC15));


    StockAdres( ADR( PtArrCdvMAN10));
    StockAdres( ADR( PtArrCdvMAN11));
    StockAdres( ADR( PtArrCdvMAN12));

    StockAdres( ADR( PtArrSpeMAN12));
    StockAdres( ADR( PtArrSigMAN12));
    StockAdres( ADR( PtArrSigMANzA));

    StockAdres( ADR( PtArrSpeMAN23));
    StockAdres( ADR( PtArrCdvMAN20));
    StockAdres( ADR( PtArrCdvMAN19));

    StockAdres( ADR( PtArrCdvESC25));
    StockAdres( ADR( PtArrCdvESC24));
    StockAdres( ADR( PtArrSigESC24));

    StockAdres( ADR( PtArrSigESC22B));

    StockAdres( ADR( PtArrSigESC14));
    StockAdres( ADR( PtArrSpeESC22));
    StockAdres( ADR( PtArrSigESC22A));
    StockAdres( ADR( PtArrCdvALC23));
    StockAdres( ADR( PtArrCdvALC22));
    StockAdres( ADR( PtArrCdvALC21));

    StockAdres( ADR( TivComESC12));

    StockAdres( ADR( PtAntCdvGOL24));
    StockAdres( ADR( PtAntCdvGOL23));

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
VAR BoolTr : BoolLD;

BEGIN (* ExeSpecific *)

(* Affectation des "constantes" utilisees dans la construction des messages emis    *)
(* et recus sur les boucles de transmission continue et sur les liens intersecteur. *)
(* Cette reaffectation est necessaire a chaque cycle pour la mise en securite.      *)
   AffectBoolC(Vrai, BoolPermissif)  ;
   AffectBoolC(Faux, BoolRestrictif) ;

(* regulation *)
  CdvESC12Fonc := CdvESC12B.F = Vrai.F;
  CdvESC22Fonc := CdvESC22A.F = Vrai.F;
  CdvALC12Fonc := CdvALC12.F = Vrai.F;
  CdvALC22Fonc := CdvALC22.F = Vrai.F;

  CdvMAN12Fonc := CdvMAN12B.F = Vrai.F;
  CdvMAN22Fonc := CdvMAN22A.F = Vrai.F;



(*  *)
(******************************* FILTRAGE DES AIGUILLES **********************************)

   FiltrerAiguille( AigESC11, BaseExeAig);
   FiltrerAiguille( AigESC23, BaseExeAig+2);
   FiltrerAiguille( AigMAN13, BaseExeAig+4);


(************************** Gerer les Tiv Com *********************************)

(* application du TIVCom (TIVCOM = Faux) si le signal 12 est jaune *)
   NonD(        SigESC12kj,             TivComESC12);

(************************** Gerer les point d'arrets **************************)

   AffectBoolD( CdvALC11,                   PtArrCdvALC11);
   AffectBoolD( CdvALC12,                   PtArrCdvALC12);
   AffectBoolD( CdvALC13,                   PtArrCdvALC13);

   AffectBoolD( CdvESC08,                   PtArrCdvESC08);
   AffectBoolD( SigESC08,                   PtArrSigESC08);

   OuDD(        SigESC10kv,   SigESC10kj,   PtArrSigESC10);

   OuDD(CdvESC13, AigESC23.PosReverseFiltree, BoolTr);
   EtDD(BoolTr,   CdvESC12B, PtArrSpeESC12);

   OuDD(SigESC12kv,           SigESC12kj,   PtArrSigESC12);

   NonD(Sp2ESC,                             PtArrSpeESC14);

   AffectBoolD( SigESC22B,                  PtArrSigESC22B);
   
   EtDD(SigESC14, AigESC23.PosReverseFiltree,PtArrSigESC14);
   
   AffectBoolD( SigESC24,                   PtArrSigESC24);

   (*  PtArrSpeESC22 = cdv22a et cdv 21 et (cdv11 ou aguille 21 a droite)  *)
   OuDD( AigESC11.PosNormaleFiltree,  CdvESC11, PtArrSpeESC22);
   EtDD(           PtArrSpeESC22,     CdvESC21, PtArrSpeESC22);
   EtDD(           PtArrSpeESC22,    CdvESC22A, PtArrSpeESC22);

   NonD(Sp1ESC,                              BoolTr);
   EtDD(SigESC22Akv,          BoolTr,        PtArrSigESC22A);
  
   AffectBoolD( SigMANzAkj,                 PtArrSigMANzA);

   AffectBoolD( CdvALC23,                   PtArrCdvALC23);
   AffectBoolD( CdvALC22,                   PtArrCdvALC22);
   AffectBoolD( CdvALC21,                   PtArrCdvALC21);

   AffectBoolD( CdvESC15,                   PtArrCdvESC15);
   AffectBoolD( CdvMAN10,                   PtArrCdvMAN10);
   AffectBoolD( CdvMAN11,                   PtArrCdvMAN11);
   EtDD(        CdvMAN12A,    CdvMAN12B,    PtArrCdvMAN12);
   EtDD(        CdvMAN12B,    CdvMAN13,     PtArrSpeMAN12);

   OuDD(        SigMAN12kj,   SigMAN12kv,   PtArrSigMAN12);

   OuDD(SigMAN23kv,           SigMAN23kj,   PtArrSpeMAN23);
   AffectBoolD( CdvMAN20,                   PtArrCdvMAN20);
   AffectBoolD( CdvMAN19,                   PtArrCdvMAN19);
   AffectBoolD( CdvESC25,                   PtArrCdvESC25);
   AffectBoolD( CdvESC24,                   PtArrCdvESC24);


(*** lecture des entrees de regulation ***)

   LireEntreesRegul;

END ExeSpecific;
END Specific.
