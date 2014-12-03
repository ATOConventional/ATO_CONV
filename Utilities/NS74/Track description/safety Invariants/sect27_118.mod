IMPLEMENTATION MODULE Specific;

(*$S- *)
(*$T- *)

(******************************************************************************
*   SANTIAGO - LIGNE 1 - Secteur 27
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
(*    Modification de la commande de l'aiguille fictive "AigFictBAQ14".      *)
(*                                                                           *)
(*  Date : 17/09/1997, Auteur : P. HOG     , Origine : Equipe developpement  *)
(*    Suppression des variables de boucles inter-secteur (inutiles).         *)
(*                                                                           *)
(*  Version 1.0.2                                                            *)
(*  Date : 24/09/1997, Auteur : P. HOG     , Origine : Equipe developpement  *)
(*    Modification des anticipations suite aux changements de vitesse.       *)
(*                                                                           *)
(*  Version 1.1.0                                                            *)
(*  Date : 01/10/1997, Auteur : P. HOG     , Origine : Equipe developpement  *)
(*    Modification des variants aniticipes du troncon 1.                     *)
(*    Suppression du "PtArrCdvBAQ22" qui ne sera jamais utilise.             *)
(*                                                                           *)
(* ========= Version 1.1.0 du 01/10/1997 ===(1ere version validee)========== *)
(*                                                                           *)
(*  Version 1.1.1                                                            *)
(*  Date : 07/10/1997, Auteur : F. Chanier,  Origine : Equipe developpement  *)
(*    Modification des variants sur le troncon 5 suite a erreur              *) 
(*    remplacement PtArrSigBAQ14 au lieu de PtArrSigBAQ24                    *)
(*                                                                           *)
(*  Version 1.1.2                                                            *)
(*  Date : 23/01/1998, Auteur : F. Chanier,  Origine : Equipe developpement  *)
(*    Modification pour gerer les defaillances d'ampli                       *) 
(*  date : 20/02/1997, Auteur : P. Hog    , origine : eq.dev.                *)
(*    Modification des marches types.                                        *)
(*    Ajout d'un point d'arret EP entree du quai Baquedano voie1.            *)
(*    PtArrCdvBAQ12 = CdvBAQ12 ET ( CdvBAQ13 OU aiguille deviee).            *)
(*---------------------------------------------------------------------------*)
(*****************************************************************************)
(***            AJOUT DE LA NUMEROTATION SCCS DES VERSIONS                ****)
(*---------------------------------------------------------------------------*)
(* Version 1.1.3  =====================                                      *)
(* Version 1.7 DU SERVEUR SCCS =====================                         *)
(* Date :         10/09/1998                                                 *)
(* Auteur:        H. Le Roy                                                  *)
(* Modification : Fiche d'anomalie ba040998                                  *)
(*                Suite a un changement de vitesses maximales, mise a jour   *)
(*                des marches types                                          *)
(*---------------------------------------------------------------------------*)
(* Version 1.1.4  =====================                                      *)
(* Version 1.8 DU SERVEUR SCCS =====================                         *)
(* Date :         20/04/1999                                                 *)
(* Auteur:        H. Le Roy                                                  *)
(* Modification : Adaptation et modification de la configuration des amplis  *)
(*                 pour detecter les pannes de fusibles.Suppression de       *)
(*                 parties de code inutiles concernant les DAMTC.            *)
(*---------------------------------------------------------------------------*)
(* Version 1.1.5  =====================                                      *)
(* Version 1.9 DU SERVEUR SCCS =====================                         *)
(* Date :         27/03/2000                                                 *)
(* Auteur:        H. Le Roy                                                  *)
(* Modification : Am dev032000-1 : modif. de la gestion des SP : ajout d'un  *)
(*        point arret specifique dedie a la gestion du SP1 a Baquedano V2.   *)
(*        Le point d'arret associe au cdv 21 est maintenant decharge de      *)
(*        cette tache.                                                       *)
(*---------------------------------------------------------------------------*)
(* Version 1.1.6  =====================                                      *)
(* Version 1.10 DU SERVEUR SCCS =====================                        *)
(* Date :         07/04/2000                                                 *)
(* Auteur:        H. Le Roy                                                  *)
(* Modification : Modif. de la valeurs d'init du point d'arret specifique    *)
(*          dedie au SP1 a Baquedano V2 pour plus de logique ( permissif et  *)
(*          non restrictif car ce point d'arret est  fonctionnel).           *)
(*                                                                           *)
(*                Om Dev042000-1 : M.A.J technique de gestion des Sp         *)
(*        Suppression de l'aiguille fictive et son traitement. Ajout d'une   *)
(*          entree secu associee aux cdv 14, d'un point d'arret specifique,  *)
(*          et introduction d'une logique de bascule dans le traitement des  *)
(*          Sp afin de compenser la suppression de l'aiguille fictive.       *)
(*                                                                           *)
(*                AM Bo032000-3                                              *)
(*        Ajout d'une entree secu. associee aux cdv 15 de Baquedano, et d'un *)
(*          point d'arret subcantonne pour le proteger, suite a la           *)
(*          modification de decoupage et de signalisation.                   *)
(*                                                                           *)
(*---------------------------------------------------------------------------*)
(* Version 1.1.7  =====================                                      *)
(* Version 1.11 DU SERVEUR SCCS =====================                        *)
(* Date :         06/06/2000                                                 *)
(* Auteur:        H. Le Roy                                                  *)
(* Modification : Am165 : modification des marches types                     *)
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

              		Ampli11, Ampli12, Ampli13, Ampli14, Ampli15, Ampli16,
              		Ampli21, Ampli22, Ampli23, Ampli24, Ampli25, Ampli26, Ampli27,
              		Ampli31, Ampli32, Ampli33, Ampli34,
              		Ampli41, Ampli42, Ampli43, Ampli44, Ampli45,
              		Ampli51, Ampli52, Ampli53, 
(* variables *)
                       Boucle1, Boucle2, Boucle3, Boucle4, Boucle5, BoucleFictive,
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

    L0128  = 1024*28;    (* numero Secteur aval voie impaire decale de 2**10 *)

    L0127  = 1024*27;    (* numero Secteur local decale de 2**10 *)

    L0126  = 1024*26;    (* numero Secteur amont voie impaire decale de 2**10 *)


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
    noBouclemon = 00; 
    noBoucleudc = 01; 
    noBouclefi = 02;
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

(***************** DECLARATION DES VARIABLES GENERALES **********************)
 VAR

(* DECLARATION DES SINGULARITES DU SECTEUR 27 : dans les deux sens confondus *)


(* Declaration des variables correspondant a des entrees securitaires  *)
(*   - CDV et signaux                                                  *)
    CdvCAT11,      (* entree  1, soit entree 0 de CES 02  *)
    CdvCAT12,      (* entree  2, soit entree 1 de CES 02  *)
    CdvCAT13,      (* entree  3, soit entree 2 de CES 02  *)
    CdvBAQ10,      (* entree  4, soit entree 3 de CES 02  *)
    SigBAQ10,      (* entree  5, soit entree 4 de CES 02  *)
    SigBAQ12kv,    (* entree  6, soit entree 5 de CES 02  *)
    SigBAQ12kj,    (* entree  7, soit entree 6 de CES 02  *)
    CdvBAQ24,      (* entree  8, soit entree 7 de CES 02  *)
    SigBAQ24,      (* entree  9, soit entree 0 de CES 03  *)
    CdvBAQ21,      (* entree 10, soit entree 1 de CES 03  *)
    CdvBAQ20,      (* entree 11, soit entree 2 de CES 03  *)
    CdvCAT23B,     (* entree 12, soit entree 3 de CES 03  *)
    CdvCAT23A,     (* entree 13, soit entree 4 de CES 03  *)
    CdvCAT22,      (* entree 14, soit entree 5 de CES 03  *)
    CdvCAT21,      (* entree 15, soit entree 6 de CES 03  *)
    Sp1BAQ,        (* entree 16, soit entree 7 de CES 03  *)
    Sp2BAQ,        (* entree 17, soit entree 0 de CES 04  *)
 (* pas utilisee *) (* entree 18, soit entree 1 de CES 04  *)
    SigBAQ14,      (* entree 19, soit entree 2 de CES 04  *)
    SigBAQ22,      (* entree 22, soit entree 5 de CES 04  *)
    CdvBAQ11,      (* entree 23, soit entree 6 de CES 04  *)
    CdvBAQ13,      (* entree 24, soit entree 7 de CES 04  *)
    CdvBAQ23,      (* entree 25, soit entree 0 de CES 05  *)
    CdvBAQ12,      (* entree 26, soit entree 1 de CES 05  *)
    CdvBAQ22,      (* entree 27, soit entree 2 de CES 05  *)
    CdvBAQ14,      (* entree 28, soit entree 3 de CES 05  *)
    CdvBAQ15       (* entree 29, soit entree 4 de CES 05  *)
             : BoolD;

(*   - aiguilles                                                       *)
    AigBAQ13       (* entrees 20 et 21, soit entrees 3 et 4 de CES 04  *)
             :TyAig;



(* Variables ne correspondant pas a une entree securitaire *)
(* Point d'arret *)
    PtArrCdvCAT11,
    PtArrCdvCAT12,
    PtArrCdvCAT13,
    PtArrCdvBAQ10,
    PtArrSigBAQ10,
    PtArrCdvBAQ12,
    PtArrSigBAQ12,
    PtArrCdvBAQ15,

    PtArrCdvBAQ24,
    PtArrSigBAQ24,
    PtArrCdvBAQ21,
    PtArrCdvBAQ20,
    PtArrCdvCAT23,
    PtArrCdvCAT22,
    PtArrCdvCAT21,

    PtArrSigBAQ14,
    PtArrSigBAQ22,
    PtArrSpeBAQ14,
    PtArrSpec21  : BoolD;

(* Tiv Com non lies a une aiguille *)
    TivComBAQ12    : BoolD;

(* Variants anticipes *)
    PtAntCdvSAL11,
    PtAntCdvSAL12,
    PtAntCdvSAL13,
    PtAntCdvLUC23,
    PtAntCdvLUC22  : BoolD;

(* Copie des entrees dans des variables fonctionnelles pour la regulation *)
    CdvCAT12Fonc,
    CdvCAT22Fonc,
    CdvBAQ12Fonc,
    CdvBAQ22Fonc     : BOOLEAN;

(** Voie d'emission SOL-TRAIN : deux sens confondus**)
    te11s27t01,
    te14s27t02,
    te21s27t03,
    te23s27t04,
    te27s27t05           :TyEmissionTele;

(** Voie d'emission Inter-secteur deux voies confondues **)
    teL0128,
    teL0126	          :TyEmissionTele;

(** Voie de reception Inter-secteur deux voies confondues **)
    trL0128,
    trL0126               :TyCaracEntSec;

(** Variables de memorisation des etats precedents des **)
(** cdv14 et SP2 de Baquedano pour la gestion des Sp   **)
    NonCdv14old,
    Sp2old                : BoolD;
    
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
   EntreeAiguille( AigBAQ13, 20, 21);   (* kag G = pos normale *)

(* Configuration des entrees *)
    ProcEntreeIntrins (  1, CdvCAT11);
    ProcEntreeIntrins (  2, CdvCAT12);
    ProcEntreeIntrins (  3, CdvCAT13);
    ProcEntreeIntrins (  4, CdvBAQ10);
    ProcEntreeIntrins (  5, SigBAQ10);
    ProcEntreeIntrins (  6, SigBAQ12kv);
    ProcEntreeIntrins (  7, SigBAQ12kj);
    ProcEntreeIntrins (  8, CdvBAQ24);
    ProcEntreeIntrins (  9, SigBAQ24);
    ProcEntreeIntrins ( 10, CdvBAQ21);
    ProcEntreeIntrins ( 11, CdvBAQ20);
    ProcEntreeIntrins ( 12, CdvCAT23B);
    ProcEntreeIntrins ( 13, CdvCAT23A);
    ProcEntreeIntrins ( 14, CdvCAT22);
    ProcEntreeIntrins ( 15, CdvCAT21);
    ProcEntreeIntrins ( 16, Sp1BAQ);
    ProcEntreeIntrins ( 17, Sp2BAQ);
    ProcEntreeIntrins ( 19, SigBAQ14);
    ProcEntreeIntrins ( 22, SigBAQ22);
    ProcEntreeIntrins ( 23, CdvBAQ11);
    ProcEntreeIntrins ( 24, CdvBAQ13);
    ProcEntreeIntrins ( 25, CdvBAQ23);
    ProcEntreeIntrins ( 26, CdvBAQ12);
    ProcEntreeIntrins ( 27, CdvBAQ22);
    ProcEntreeIntrins ( 28, CdvBAQ14);
    ProcEntreeIntrins ( 29, CdvBAQ15);

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
   ConfigurerAmpli(Ampli15, 1, 5, 158, 13, FALSE);
   ConfigurerAmpli(Ampli16, 1, 6, 159, 13, TRUE);

   ConfigurerAmpli(Ampli21, 2, 1, 192, 14, FALSE);
   ConfigurerAmpli(Ampli22, 2, 2, 193, 15, FALSE);
   ConfigurerAmpli(Ampli23, 2, 3, 194, 15, FALSE);
   ConfigurerAmpli(Ampli24, 2, 4, 195, 15, TRUE);
   ConfigurerAmpli(Ampli25, 2, 5, 196, 16, FALSE);
   ConfigurerAmpli(Ampli26, 2, 6, 197, 16, FALSE);
   ConfigurerAmpli(Ampli27, 2, 7, 198, 16, TRUE);

   ConfigurerAmpli(Ampli31, 3, 1, 199, 21, FALSE);
   ConfigurerAmpli(Ampli32, 3, 2, 200, 22, FALSE);
   ConfigurerAmpli(Ampli33, 3, 3, 201, 22, FALSE);
   ConfigurerAmpli(Ampli34, 3, 4, 202, 22, TRUE); 

   ConfigurerAmpli(Ampli41, 4, 1, 203, 23, FALSE);
   ConfigurerAmpli(Ampli42, 4, 2, 204, 24, FALSE);
   ConfigurerAmpli(Ampli43, 4, 3, 205, 24, TRUE);    
   ConfigurerAmpli(Ampli44, 4, 4, 206, 24, TRUE);
   ConfigurerAmpli(Ampli45, 4, 5, 207, 25, FALSE); 

   ConfigurerAmpli(Ampli51, 5, 1, 208, 27, FALSE);
   ConfigurerAmpli(Ampli52, 5, 2, 209, 28, FALSE);
   ConfigurerAmpli(Ampli53, 5, 3, 210, 28, TRUE);    

 (** cartes CES **)
   ConfigurerCES(CarteCes1, 01);
   ConfigurerCES(CarteCes2, 02);
   ConfigurerCES(CarteCes3, 03);
   ConfigurerCES(CarteCes4, 04);


(** Liaisons Inter-Secteur **)

   ConfigurerIntsecteur(Intersecteur1, 01, trL0128, trL0126);


(* Initialisations des variables ne correspondant pas a des entrees secu *)
(* Point d'arret *)
    AffectBoolD( BoolRestrictif, PtArrCdvCAT11);
    AffectBoolD( BoolRestrictif, PtArrCdvCAT12);
    AffectBoolD( BoolRestrictif, PtArrCdvCAT13);
    AffectBoolD( BoolRestrictif, PtArrCdvBAQ10);
    AffectBoolD( BoolRestrictif, PtArrSigBAQ10);
    AffectBoolD( BoolRestrictif, PtArrCdvBAQ12);
    AffectBoolD( BoolRestrictif, PtArrSigBAQ12);
    AffectBoolD( BoolRestrictif, PtArrCdvBAQ15);

    AffectBoolD( BoolRestrictif, PtArrCdvBAQ24);
    AffectBoolD( BoolRestrictif, PtArrSigBAQ24);
    AffectBoolD( BoolRestrictif, PtArrCdvBAQ21);
    AffectBoolD( BoolRestrictif, PtArrCdvBAQ20);
    AffectBoolD( BoolRestrictif, PtArrCdvCAT23);
    AffectBoolD( BoolRestrictif, PtArrCdvCAT22);
    AffectBoolD( BoolRestrictif, PtArrCdvCAT21);

    AffectBoolD( BoolRestrictif, PtArrSigBAQ14);
    AffectBoolD( BoolRestrictif, PtArrSigBAQ22);

    AffectBoolD( BoolPermissif, PtArrSpec21);
    AffectBoolD( BoolPermissif, PtArrSpeBAQ14);

(* Tiv Com non lies a une aiguille *)
    AffectBoolD( BoolRestrictif, TivComBAQ12);

(* Variants anticipes *)
    AffectBoolD( BoolRestrictif, PtAntCdvSAL11);
    AffectBoolD( BoolRestrictif, PtAntCdvSAL12);
    AffectBoolD( BoolRestrictif, PtAntCdvSAL13);
    AffectBoolD( BoolRestrictif, PtAntCdvLUC23);
    AffectBoolD( BoolRestrictif, PtAntCdvLUC22);

(** Variables de memorisation des etats precedents des **)
(** cdv14 et SP2 de Baquedano pour la gestion des Sp   **)
    AffectBoolD( BoolPermissif, NonCdv14old);
    AffectBoolD( BoolPermissif, Sp2old);

(* Copie des entrees dans des variables fonctionnelles pour la regulation *)
    CdvCAT12Fonc := FALSE;
    CdvCAT22Fonc := FALSE;
    CdvBAQ12Fonc := FALSE;
    CdvBAQ22Fonc := FALSE;

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

   ConfigEmisTeleSolTrain ( te11s27t01,
                            noBoucle1,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te14s27t02,
                            noBoucle2,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te21s27t03,
                            noBoucle3,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te23s27t04,
                            noBoucle4,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te27s27t05,
                            noBoucle5,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);


(* CONFIGURATION POUR LA REGULATION *)
   ConfigQuai (15, 74, CdvCAT12Fonc, te11s27t01, 0,  2,  8,  9,  4, 13, 14, 15);
   ConfigQuai (15, 79, CdvCAT22Fonc, te23s27t04, 0, 11, 10,  6,  7, 13, 14, 15);
   ConfigQuai (16, 64, CdvBAQ12Fonc, te14s27t02, 0,  3,  4, 11,  5, 13, 14, 15);
   ConfigQuai (16, 69, CdvBAQ22Fonc, te21s27t03, 0, 11, 10,  6,  7, 13, 14, 15);

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
   ProcEmisSolTrain( te11s27t01.EmissionSensUp, (2*noBoucle1), 
                     LigneL01+ L0127+ TRONC*01,

              PtArrCdvCAT11,
              PtArrCdvCAT12,
              PtArrCdvCAT13,
              PtArrCdvBAQ10,
              PtArrSigBAQ10,
              BoolRestrictif,             (* aspect croix *)
              PtArrCdvBAQ12,
              BoolRestrictif,
(* Variants Anticipes *)
              PtArrSigBAQ12,
              BoolRestrictif,             (* aspect croix *)
              TivComBAQ12,                (* tivcom *)
              PtArrCdvBAQ15,
              PtArrSpeBAQ14,
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
   ProcEmisSolTrain( te14s27t02.EmissionSensUp, (2*noBoucle2), 
                     LigneL01+ L0127+ TRONC*02,

              PtArrSigBAQ12,
              BoolRestrictif,             (* aspect croix *)
              TivComBAQ12,                (* tivcom *)
              PtArrCdvBAQ15,
              PtArrSpeBAQ14,
              PtAntCdvSAL11,
              PtArrSigBAQ22,
              BoolRestrictif,             (* aspect croix *)
(* Variants Anticipes *)
              PtAntCdvSAL12,
              PtAntCdvSAL13,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
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


(* variants troncon 3    voie 2  ---> sp  *)
   ProcEmisSolTrain( te21s27t03.EmissionSensUp, (2*noBoucle3), 
                     LigneL01+ L0127+ TRONC*03,

              PtArrSigBAQ24,
              BoolRestrictif,             (* aspect croix *)
              PtArrCdvBAQ21,
              PtArrSpec21,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
(* Variants Anticipes *)
              PtArrCdvBAQ20,
              PtArrCdvCAT23,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
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
   ProcEmisSolTrain( te23s27t04.EmissionSensUp, (2*noBoucle4), 
                     LigneL01+ L0127+ TRONC*04,
  
              PtArrCdvBAQ20,
              PtArrCdvCAT23,
              PtArrCdvCAT22,
              PtArrCdvCAT21,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
(* Variants Anticipes *)
              PtAntCdvLUC23,
              PtAntCdvLUC22,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
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
   ProcEmisSolTrain( te27s27t05.EmissionSensUp, (2*noBoucle5), 
                     LigneL01+ L0127+ TRONC*05,

              PtArrSigBAQ14,
              BoolRestrictif,             (* aspect croix *)
              AigBAQ13.PosReverseFiltree,
              AigBAQ13.PosNormaleFiltree,
              BoolRestrictif,             (* signal rouge fix2 fictif BAQ2sig*)
              BoolRestrictif,             (* aspect croix *)
              BoolRestrictif,
              BoolRestrictif,
(* Variants Anticipes *)
              PtArrCdvBAQ21,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
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
(* reception du secteur 28 -aval- *)

   ProcReceptInterSecteur(trL0128, noBouclemon, LigneL01+ L0128+ TRONC*01,
                  PtAntCdvSAL11,
                  PtAntCdvSAL12,
                  PtAntCdvSAL13,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
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

(* reception du secteur 26 -amont- *)

   ProcReceptInterSecteur(trL0126, noBoucleudc, LigneL01+ L0126+ TRONC*04,

                  PtAntCdvLUC23,
                  PtAntCdvLUC22,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
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
(* emission vers le secteur 28 -aval- *)

   ProcEmisInterSecteur (teL0128, noBouclemon, LigneL01+ L0127+ TRONC*03,
			noBouclemon,
                  PtArrCdvBAQ24,
                  PtArrSigBAQ24,
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
                  V1,
		  V2,
                  V3,
		  V4,
                  V5,
		  V6,
		  BaseSorVar + 210);


(*  *)

(* emission vers le secteur 26 -amont- *)

   ProcEmisInterSecteur (teL0126, noBoucleudc, LigneL01+ L0127+ TRONC*01,
			noBoucleudc,
                  PtArrCdvCAT11,
                  PtArrCdvCAT12,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
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


 (** Emission invariants vers secteur 28 aval L0128 **)

   EmettreSegm(LigneL01+ L0127+ TRONC*03+ SEGM*00, noBouclemon, SensUp);
   EmettreSegm(LigneL01+ L0127+ TRONC*04+ SEGM*00, noBouclemon, SensUp);

 (** Emission invariants vers secteur 26 amont L0126 **)

   EmettreSegm(LigneL01+ L0127+ TRONC*01+ SEGM*00, noBoucleudc, SensUp);
   EmettreSegm(LigneL01+ L0127+ TRONC*01+ SEGM*01, noBoucleudc, SensUp);
   EmettreSegm(LigneL01+ L0127+ TRONC*02+ SEGM*00, noBoucleudc, SensUp);


 (** Boucle 1 **)
   EmettreSegm(LigneL01+ L0127+ TRONC*01+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL01+ L0127+ TRONC*01+ SEGM*01, noBoucle1, SensUp);
   EmettreSegm(LigneL01+ L0127+ TRONC*02+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL01+ L0127+ TRONC*02+ SEGM*01, noBoucle1, SensUp);
   EmettreSegm(LigneL01+ L0128+ TRONC*01+ SEGM*00, noBoucle1, SensUp);

 (** Boucle 2 **)
   EmettreSegm(LigneL01+ L0127+ TRONC*02+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL01+ L0127+ TRONC*02+ SEGM*01, noBoucle2, SensUp);
   EmettreSegm(LigneL01+ L0127+ TRONC*02+ SEGM*02, noBoucle2, SensUp);
   EmettreSegm(LigneL01+ L0127+ TRONC*05+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL01+ L0128+ TRONC*01+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL01+ L0128+ TRONC*02+ SEGM*00, noBoucle2, SensUp);

 (** Boucle 3 **)
   EmettreSegm(LigneL01+ L0127+ TRONC*03+ SEGM*00, noBoucle3, SensUp);
   EmettreSegm(LigneL01+ L0127+ TRONC*03+ SEGM*02, noBoucle3, SensUp);
   EmettreSegm(LigneL01+ L0127+ TRONC*04+ SEGM*00, noBoucle3, SensUp);
   EmettreSegm(LigneL01+ L0127+ TRONC*02+ SEGM*02, noBoucle3, SensUp);
   EmettreSegm(LigneL01+ L0126+ TRONC*04+ SEGM*00, noBoucle3, SensUp);

 (** Boucle 4 **)
   EmettreSegm(LigneL01+ L0127+ TRONC*04+ SEGM*00, noBoucle4, SensUp);
   EmettreSegm(LigneL01+ L0126+ TRONC*04+ SEGM*00, noBoucle4, SensUp);
   EmettreSegm(LigneL01+ L0126+ TRONC*04+ SEGM*01, noBoucle4, SensUp);
   EmettreSegm(LigneL01+ L0126+ TRONC*05+ SEGM*00, noBoucle4, SensUp);

 (** Boucle 5 **)
   EmettreSegm(LigneL01+ L0127+ TRONC*05+ SEGM*00, noBoucle5, SensUp);
   EmettreSegm(LigneL01+ L0127+ TRONC*02+ SEGM*00, noBoucle5, SensUp);
   EmettreSegm(LigneL01+ L0127+ TRONC*03+ SEGM*00, noBoucle5, SensUp);
   EmettreSegm(LigneL01+ L0127+ TRONC*03+ SEGM*02, noBoucle5, SensUp);

(*  *)

(*************************** CONFIGURATION DES TRONCONS TSR **************************)

   ConfigurerTroncon(Tronc0, LigneL01 + L0127 + TRONC*01, 2,2,2,2);  (* troncon 27-1 *)
   ConfigurerTroncon(Tronc1, LigneL01 + L0127 + TRONC*02, 2,2,2,2);  (* troncon 27-2 *)
   ConfigurerTroncon(Tronc2, LigneL01 + L0127 + TRONC*03, 2,2,2,2);  (* troncon 27-3 *)
   ConfigurerTroncon(Tronc3, LigneL01 + L0127 + TRONC*04, 2,2,2,2);  (* troncon 27-4 *)
   ConfigurerTroncon(Tronc4, LigneL01 + L0127 + TRONC*05, 2,2,2,2);  (* troncon 27-5 *)


(************************************** EMISSION DES TSR *************************************)



(** Emission des TSR vers le secteur aval 28 L0128 **)

   EmettreTronc(LigneL01+ L0127+ TRONC*03, noBouclemon, SensUp);
   EmettreTronc(LigneL01+ L0127+ TRONC*04, noBouclemon, SensUp);


(** Emission des TSR vers le secteur amont 26 L0126 **)

   EmettreTronc(LigneL01+ L0127+ TRONC*01, noBoucleudc, SensUp);
   EmettreTronc(LigneL01+ L0127+ TRONC*02, noBoucleudc, SensUp);


 (** Emission des TSR sur les troncons du secteur courant **)

   EmettreTronc(LigneL01+ L0127+ TRONC*01, noBoucle1, SensUp); (* troncon 27-1 *)
   EmettreTronc(LigneL01+ L0127+ TRONC*02, noBoucle1, SensUp);
   EmettreTronc(LigneL01+ L0128+ TRONC*01, noBoucle1, SensUp);


   EmettreTronc(LigneL01+ L0127+ TRONC*02, noBoucle2, SensUp); (* troncon 27-2 *)
   EmettreTronc(LigneL01+ L0127+ TRONC*05, noBoucle2, SensUp);
   EmettreTronc(LigneL01+ L0128+ TRONC*01, noBoucle2, SensUp);
   EmettreTronc(LigneL01+ L0128+ TRONC*02, noBoucle2, SensUp);


   EmettreTronc(LigneL01+ L0127+ TRONC*03, noBoucle3, SensUp); (* troncon 27-3 *)
   EmettreTronc(LigneL01+ L0127+ TRONC*04, noBoucle3, SensUp);
   EmettreTronc(LigneL01+ L0127+ TRONC*02, noBoucle3, SensUp);
   EmettreTronc(LigneL01+ L0126+ TRONC*04, noBoucle3, SensUp);


   EmettreTronc(LigneL01+ L0127+ TRONC*04, noBoucle4, SensUp); (* troncon 27-4 *)
   EmettreTronc(LigneL01+ L0126+ TRONC*04, noBoucle4, SensUp);
   EmettreTronc(LigneL01+ L0126+ TRONC*05, noBoucle4, SensUp);


   EmettreTronc(LigneL01+ L0127+ TRONC*05, noBoucle5, SensUp); (* troncon 27-5 *)
   EmettreTronc(LigneL01+ L0127+ TRONC*02, noBoucle5, SensUp);
   EmettreTronc(LigneL01+ L0127+ TRONC*03, noBoucle5, SensUp);

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
    StockAdres( ADR( CdvCAT11));
    StockAdres( ADR( CdvCAT12));
    StockAdres( ADR( CdvCAT13));
    StockAdres( ADR( CdvBAQ10));
    StockAdres( ADR( SigBAQ10));
    StockAdres( ADR( SigBAQ12kv));
    StockAdres( ADR( SigBAQ12kj));
    StockAdres( ADR( CdvBAQ24));
    StockAdres( ADR( SigBAQ24));
    StockAdres( ADR( CdvBAQ21));
    StockAdres( ADR( CdvBAQ20));
    StockAdres( ADR( CdvCAT23B));
    StockAdres( ADR( CdvCAT23A));
    StockAdres( ADR( CdvCAT22));
    StockAdres( ADR( CdvCAT21));
    StockAdres( ADR( Sp1BAQ));
    StockAdres( ADR( Sp2BAQ));
    StockAdres( ADR( SigBAQ14));
    StockAdres( ADR( SigBAQ22));
    StockAdres( ADR( CdvBAQ11));
    StockAdres( ADR( CdvBAQ13));
    StockAdres( ADR( CdvBAQ23));
    StockAdres( ADR( CdvBAQ12));
    StockAdres( ADR( CdvBAQ22));
    StockAdres( ADR( CdvBAQ14));
    StockAdres( ADR( CdvBAQ15));

    StockAdres( ADR( AigBAQ13));

    StockAdres( ADR( PtArrCdvCAT11));
    StockAdres( ADR( PtArrCdvCAT12));
    StockAdres( ADR( PtArrCdvCAT13));
    StockAdres( ADR( PtArrCdvBAQ10));
    StockAdres( ADR( PtArrSigBAQ10));
    StockAdres( ADR( PtArrCdvBAQ12));
    StockAdres( ADR( PtArrSigBAQ12));
    StockAdres( ADR( PtArrCdvBAQ15));
    StockAdres( ADR( PtArrCdvBAQ24));
    StockAdres( ADR( PtArrSigBAQ24));
    StockAdres( ADR( PtArrCdvBAQ21));
    StockAdres( ADR( PtArrCdvBAQ20));
    StockAdres( ADR( PtArrCdvCAT23));
    StockAdres( ADR( PtArrCdvCAT22));
    StockAdres( ADR( PtArrCdvCAT21));
    StockAdres( ADR( PtArrSigBAQ14));
    StockAdres( ADR( PtArrSigBAQ22));

    StockAdres( ADR( PtArrSpec21));
    StockAdres( ADR( PtArrSpeBAQ14));
    
    StockAdres( ADR( TivComBAQ12));

    StockAdres( ADR( PtAntCdvSAL11));
    StockAdres( ADR( PtAntCdvSAL12));
    StockAdres( ADR( PtAntCdvSAL13));
    StockAdres( ADR( PtAntCdvLUC23));
    StockAdres( ADR( PtAntCdvLUC22));

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
VAR BoolTr,
    Reset, Set, NonReset  : BoolLD;

BEGIN (* ExeSpecific *)

(* Affectation des "constantes" utilisees dans la construction des messages emis    *)
(* et recus sur les boucles de transmission continue et sur les liens intersecteur. *)
(* Cette reaffectation est necessaire a chaque cycle pour la mise en securite.      *)
   AffectBoolC(Vrai, BoolPermissif)  ;
   AffectBoolC(Faux, BoolRestrictif) ;

(* regulation *)
  CdvCAT12Fonc := CdvCAT12.F = Vrai.F;
  CdvCAT22Fonc := CdvCAT22.F = Vrai.F;
  CdvBAQ12Fonc := CdvBAQ12.F = Vrai.F;
  CdvBAQ22Fonc := CdvBAQ22.F = Vrai.F;



(*  *)
(*********************************** FILTRAGE DES AIGUILLES ******************************)

   FiltrerAiguille( AigBAQ13, BaseExeAig);

(******************* Gerer les Tiv Com non lies a une aiguille ****************)

   AffectBoolD( SigBAQ12kv,                 TivComBAQ12);

(************************** Gerer les point d'arrets **************************)

(* V1 *)
   AffectBoolD( CdvCAT11,                   PtArrCdvCAT11);
   AffectBoolD( CdvCAT12,                   PtArrCdvCAT12);
   AffectBoolD( CdvCAT13,                   PtArrCdvCAT13);
   AffectBoolD( CdvBAQ10,                   PtArrCdvBAQ10);
   AffectBoolD( SigBAQ10,                   PtArrSigBAQ10);
   OuDD(        CdvBAQ13, AigBAQ13.PosReverseFiltree, BoolTr);
   EtDD(        BoolTr,       CdvBAQ12,     PtArrCdvBAQ12);
   OuDD(        SigBAQ12kv,   SigBAQ12kj,   PtArrSigBAQ12);
   AffectBoolD( CdvBAQ15,                   PtArrCdvBAQ15);


(* V2 *)
   AffectBoolD( CdvBAQ24,                   PtArrCdvBAQ24);
   AffectBoolD( SigBAQ24,                   PtArrSigBAQ24);
   AffectBoolD( CdvBAQ21,                   PtArrCdvBAQ21);
   AffectBoolD( CdvBAQ20,                   PtArrCdvBAQ20);
   EtDD(        CdvCAT23B,    CdvCAT23A,    PtArrCdvCAT23);
   AffectBoolD( CdvCAT22,                   PtArrCdvCAT22);
   AffectBoolD( CdvCAT21,                   PtArrCdvCAT21);

(* Contresens *)
   AffectBoolD( SigBAQ14,                   PtArrSigBAQ14);
   AffectBoolD( SigBAQ22,                   PtArrSigBAQ22);


(* Sp *)
   (* 27/03/2000 : Modif. de la gestion du SP1                  *)
   NonD(        Sp1BAQ,         PtArrSpec21);
   (*  NonD(        Sp1BAQ,       BoolTr);                      *)
   (*  EtDD(        CdvBAQ20,     BoolTr,       PtArrCdvBAQ20); *)

   (* Reset = Cdv14*Sp2 + Cdv14*Sp1*Aig13R                      *)
   (* Le point d'arret est demande restrictif si le cdv14 est   *)
   (* libre et le Sp2 est demande, ou si le cdv14 est libre et  *)
   (* le Sp1 est est demande et l'aiguille est passe en reverse *)
   EtDD(  AigBAQ13.PosReverseFiltree,   Sp1BAQ,     Reset );
   OuDD(  Reset,                        Sp2BAQ,     Reset );
   EtDD(  Reset,                        CdvBAQ14,   Reset );
   
   
   (* Set = Cdv14*non(Cdv14Prec) + Cdv14*Sp2Prec*non(Sp2)      *)
   (* Le point d'arret est demande permissif si le cdv14 est   *)
   (* libere, ou si le Sp2 est abandonne et le cdv14 est libre *)
   NonD(  Sp2BAQ,   Set );
   EtDD(  Set,      Sp2old,      Set );
   OuDD(  Set,      NonCdv14old, Set );
   EtDD(  Set,      CdvBAQ14,    Set );


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
   EtDD(  PtArrSpeBAQ14,   NonReset,       PtArrSpeBAQ14);
   OuDD(  PtArrSpeBAQ14,   Set,            PtArrSpeBAQ14);

   (* On memorise certains etats pour les calculs au cycle suivant *)
   NonD( CdvBAQ14, NonCdv14old );
   AffectBoolD( Sp2BAQ, Sp2old );



(*** lecture des entrees de regulation ***)

   LireEntreesRegul;

END ExeSpecific;
END Specific.
