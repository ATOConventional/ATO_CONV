
IMPLEMENTATION MODULE Specific;

(*$S- *)
(*$T- *)

(******************************************************************************
*   SANTIAGO - LIGNE 1 - Secteur 24
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
(* Version 1.0.1                                                             *)
(*  Date : 15/10/1997, Auteur: F. Chanier, Origine : Eq dev                  *)
(*    modifications dans la partie emission (emettresegm et emettretronc)    *)
(*    rajout de variants dans l'emission sur troncon 2,3 et 4                *)
(*    rajout de la reception sur les intersecteurs de AntCdvREP12 et CdvUSA22*)
(*    rajout de l'emission sur intersecteur de PtArrCdvULA22 et SigCEN10     *)
(*                                                                           *)
(* Version 1.1.0 : F. Chanier - pas de modif - mais premiere livraison a la  *)
(*                 validation                                                *)
(*                                                                           *)
(* Version 1.1.1                                                             *)
(*  Date : 09/03/1998, Auteur: F. Chanier, Origine : Eq dev                  *)
(*    detection des defaillances d'ampli                                     *)
(*    rajout de l'EP sur cdv 12 a Central - troncon 1                        *)
(*                                                                           *)
(* Version 1.1.2                                                             *)
(*  Date : 10/03/1998, Auteur: F. Chanier, Origine : Eq. dev                 *) 
(*    ptarrspecret dpendant de l'etat du SP sur cdv z15                      *)         
(*    le ptarretsub ducdv15 n'est plus dependant des SP                      *)
(*                                                                           *)
(* Version 1.1.3                                                             *)
(*  Date : 11/03/1998, Autuer: F. Chanier, Origine : Eq. Dev                 *)  
(*  prise en compte des nouvelles marche-type                                *)
(*  affectation du cdv15                                                     *)
(*                                                                           *)
(* Version 1.1.4                                                             *)
(*  Date : 18/03/1998, Autuer: F. Chanier, Origine : Eq. Dev                 *)
(*  modification de la logique de commande de PtArrSpec15                    *)  
(*                                                                           *)
(* Version 1.1.5                                                             *)
(*  Date : 08/06/1998, Autuer: F. Chanier, Origine : Eq. Dev                 *)
(*  modification de la logique de commande de l'arretspe15: la position de   *)
(*  l'aiguille 13 intervient dans le calcul                                  *)
(*---------------------------------------------------------------------------*)
(*****************************************************************************)
(***            AJOUT DE LA NUMEROTATION SCCS DES VERSIONS                ****)
(*---------------------------------------------------------------------------*)
(* Version 1.1.6  =====================                                      *)
(* Version 1.9 DU SERVEUR SCCS =====================                         *)
(* Date :         10/09/1998                                                 *)
(* Auteur:        H. Le Roy                                                  *)
(* Modification : Fiche d'anomalie ba040998                                  *)
(*                Suite a un changement de vitesses maximales, mise a jour   *)
(*                des marches types                                          *)
(*---------------------------------------------------------------------------*)
(* Version 1.1.7  =====================                                      *)
(* Version 1.10 DU SERVEUR SCCS =====================                        *)
(* Date :         10/12/1998                                                 *)
(* Auteur:        H. Le Roy                                                  *)
(* Modification : anomalie ba091298-2                                        *)
(*                Modification de la logique de commande de l'arretspe15 :   *)
(*                 prevention de destrucion intempestive du SP               *)
(*                Ajout d'une entree secu pour l'etat du cdv 14 de Central   *)
(*---------------------------------------------------------------------------*)
(* Version 1.1.8  =====================                                      *)
(* Version 1.11 DU SERVEUR SCCS =====================                        *)
(* Date :          14/12/1998                                                *)
(* Auteur :        H. Le Roy                                                 *)
(* Modification : ba 141298-1 correction de la version precedente            *)
(*                 Conflits entre les conditions non exclusives de chute et  *)
(*                  levee du point d'arret                                   *)
(*---------------------------------------------------------------------------*)
(* Version 1.1.9  =====================                                      *)
(* Version 1.12 DU SERVEUR SCCS =====================                        *)
(* Date :          20/04/1999                                                *)
(* Auteur :        H. Le Roy                                                 *)
(* Modification :  Adaptation et modification de la configuration des amplis *)
(*                 pour detecter les pannes de fusibles.Suppression de       *)
(*                 parties de code inutiles concernant les DAMTC.            *)
(*---------------------------------------------------------------------------*)
(* Version 1.2.0  =====================                                      *)
(* Version 1.13 DU SERVEUR SCCS =====================                        *)
(* Date :          20/03/2000                                                *)
(* Auteur :        H. Le Roy                                                 *)
(* Modification :  Am dev032000-1 : Modif. de la gestion du SP : Ajout d'un  *)
(*                   point d'arret specifique entierement dedie au SP1,      *)
(*                   auparavant gere par le point d'arret sub. du 21A. Ce    *)
(*                   dernier devient inutile, car le cdv21A est deja gere,   *)
(*                   au niveau secu, par l'arret sub du 21B                  *)
(*                                                                           *)
(*---------------------------------------------------------------------------*)
(* Version 1.2.1  =====================                                      *)
(* Version 1.14 DU SERVEUR SCCS =====================                        *)
(* Date :          06/06/2000                                                *)
(* Auteur :        H. Le Roy                                                 *)
(* Modification :  Am165 : modification des marches types                    *)
(*---------------------------------------------------------------------------*)
(* Version 1.2.2  =====================                                      *)
(* Version 1.15 DU SERVEUR SCCS =====================                        *)
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

              		Ampli11, Ampli12, Ampli13, Ampli14,
              		Ampli21, Ampli22, Ampli23, Ampli24, Ampli25, Ampli26, Ampli27,
              		Ampli31, Ampli32, Ampli33, Ampli34,
              		Ampli41, Ampli42, Ampli43, Ampli44, Ampli45,          Ampli47,
              		Ampli51, Ampli52, Ampli53, Ampli54,
 
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

    L0125  = 1024*25;    (* numero Secteur aval voie impaire decale de 2**10 *)

    L0124  = 1024*24;    (* numero Secteur local decale de 2**10 *)

    L0123  = 1024*23;    (* numero Secteur amont voie impaire decale de 2**10 *)


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
    noBouclehea = 00; 
    noBouclepdg = 01; 
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
TYPE
 TyAigNonLue = RECORD  (* Structure de donnees associee a une aiguille dont *
                        * l'etat n'est pas lu sur des entrees de carte CES  *
                        * (aiguille fictive ou anticipee)                   *)
                  PosNormale  : BoolD ;   (* position normale calculee *)
                  PosDeviee   : BoolD ;   (* position deviee calculee  *)
                END;


(***************** DECLARATION DES VARIABLES GENERALES **********************)
 VAR

(* DECLARATION DES SINGULARITES DU SECTEUR 24 : dans les deux sens confondus *)


(* Declaration des variables correspondant a des entrees securitaires  *)
(*   - CDV et signaux                                                  *)
    CdvCEN10,      (* entree  1, soit entree 0 de CES 02  *)
    SigCEN10,      (* entree  2, soit entree 1 de CES 02  *)
    CdvCEN11,      (* entree  3, soit entree 2 de CES 02  *)
    SigCEN12kv,    (* entree  4, soit entree 3 de CES 02  *)
    SigCEN12kj,    (* entree  5, soit entree 4 de CES 02  *)
    CdvCEN13,      (* entree  6, soit entree 5 de CES 02  *)
    CdvCEN15,      (* entree  7, soit entree 6 de CES 02  *)
    CdvULA12,      (* entree  8, soit entree 7 de CES 02  *)
    CdvULA13,      (* entree  9, soit entree 0 de CES 03  *)
    CdvULA14,      (* entree 10, soit entree 1 de CES 03  *)

    CdvULA23,      (* entree 11, soit entree 2 de CES 03  *)
    CdvULA22,      (* entree 12, soit entree 3 de CES 03  *)
    CdvCEN24,      (* entree 13, soit entree 4 de CES 03  *)
    SigCEN24,      (* entree 14, soit entree 5 de CES 03  *)
    CdvCEN23,      (* entree 15, soit entree 6 de CES 03  *)
    CdvCEN21B,     (* entree 16, soit entree 7 de CES 03  *)
    CdvCEN21A,     (* entree 17, soit entree 0 de CES 04  *)
    CdvCEN20,      (* entree 18, soit entree 1 de CES 04  *)

    SigCEN14,      (* entree 19, soit entree 2 de CES 04  *)
    SigCEN22,      (* entree 22, soit entree 5 de CES 04  *)
    Sp1CEN,        (* entree 23, soit entree 6 de CES 04  *)
    Sp2CEN,        (* entree 24, soit entree 7 de CES 04  *)
    CdvCEN12,      (* entree 25, soit entree 0 de CES 05  *)
    CdvCEN22,      (* entree 26, soit entree 1 de CES 05  *)
    CdvCEN14       (* entree 27, soit entree 2 de CES 05  *)
             : BoolD;

(*   - aiguilles                                                       *)
    AigCEN13       (* entrees 20 et 21, soit entrees 3 et 4 de CES 04  *)
             :TyAig;



(* Variables ne correspondant pas a une entree securitaire *)
(* Point d'arret *)
    PtArrCdvCEN10,
(* rajout du 9/3/1998 *)
    PtArrCdvCEN12,
(* rajout du 10/3/1998 *)
    PtArrSpec15,
    PtArrSigCEN10,
    PtArrSigCEN12,
    PtArrCdvCEN15,
    PtArrCdvULA12,
    PtArrCdvULA13,
    PtArrCdvULA14,

    PtArrCdvULA23,
    PtArrCdvULA22,
    PtArrCdvCEN24,
    PtArrSigCEN24,
    PtArrCdvCEN21,
(* modif. du 24/2/2000 : modif. de la gestion du SP1 *)
    PtArrSpec21B,
(*  PtArrCdvCEN21A,     *)
    PtArrCdvCEN20,

    PtArrSigCEN14,
    PtArrSigCEN22  : BoolD;

(* Aiguilles fictives *)

(* Tiv Com non lies a une aiguille *)
    TivComCEN12    : BoolD;

(* Variants anticipes *)
    PtAntCdvREP11,
    PtAntCdvREP12,
    PtAntCdvUSA22,
    PtAntCdvUSA23  : BoolD;

(* Copie des entrees dans des variables fonctionnelles pour la regulation *)
    CdvCEN12Fonc,
    CdvCEN22Fonc,
    CdvULA12Fonc,
    CdvULA22Fonc     : BOOLEAN;

(** Voie d'emission SOL-TRAIN : deux sens confondus**)
    te11s24t01,
    te15s24t02,
    te21s24t03,
    te23s24t04,
    te26s24t05           :TyEmissionTele;

(** Voie d'emission Inter-secteur deux voies confondues **)
    teL0125,
    teL0123	          :TyEmissionTele;

(** Voie de reception Inter-secteur deux voies confondues **)
    trL0125,
    trL0123               :TyCaracEntSec;

(* 10/12/98 : variables de memorisation des etats precedents *)
(*   du cdv14 et du SP2 de Central pour logique du SP        *)
    CdvCEN14prec,
    Sp2CENprec       : BoolD;


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
   EntreeAiguille( AigCEN13, 20, 21);   (* kag G = pos normale *)

(* Configuration des entrees *)
    ProcEntreeIntrins (  1, CdvCEN10);
    ProcEntreeIntrins (  2, SigCEN10);
    ProcEntreeIntrins (  3, CdvCEN11);
    ProcEntreeIntrins (  4, SigCEN12kv);
    ProcEntreeIntrins (  5, SigCEN12kj);
    ProcEntreeIntrins (  6, CdvCEN13);
    ProcEntreeIntrins (  7, CdvCEN15);
    ProcEntreeIntrins (  8, CdvULA12);
    ProcEntreeIntrins (  9, CdvULA13);
    ProcEntreeIntrins ( 10, CdvULA14);
    ProcEntreeIntrins ( 11, CdvULA23);
    ProcEntreeIntrins ( 12, CdvULA22);
    ProcEntreeIntrins ( 13, CdvCEN24);
    ProcEntreeIntrins ( 14, SigCEN24);
    ProcEntreeIntrins ( 15, CdvCEN23);
    ProcEntreeIntrins ( 16, CdvCEN21B);
    ProcEntreeIntrins ( 17, CdvCEN21A);
    ProcEntreeIntrins ( 18, CdvCEN20);
    ProcEntreeIntrins ( 19, SigCEN14);
    ProcEntreeIntrins ( 22, SigCEN22);
    ProcEntreeIntrins ( 23, Sp1CEN);
    ProcEntreeIntrins ( 24, Sp2CEN);
    ProcEntreeIntrins ( 25, CdvCEN12);
    ProcEntreeIntrins ( 26, CdvCEN22);
    ProcEntreeIntrins ( 27, CdvCEN14);

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

   ConfigurerAmpli(Ampli21, 2, 1, 158, 15, FALSE);
   ConfigurerAmpli(Ampli22, 2, 2, 159, 16, FALSE);
   ConfigurerAmpli(Ampli23, 2, 3, 192, 16, FALSE);
   ConfigurerAmpli(Ampli24, 2, 4, 193, 16, TRUE);
   ConfigurerAmpli(Ampli25, 2, 5, 194, 17, FALSE);   
   ConfigurerAmpli(Ampli26, 2, 6, 195, 17, FALSE);
   ConfigurerAmpli(Ampli27, 2, 7, 196, 17, TRUE);

   ConfigurerAmpli(Ampli31, 3, 1, 197, 21, FALSE);
   ConfigurerAmpli(Ampli32, 3, 2, 198, 22, FALSE);
   ConfigurerAmpli(Ampli33, 3, 3, 199, 22, FALSE);         
   ConfigurerAmpli(Ampli34, 3, 4, 200, 22, TRUE);         

   ConfigurerAmpli(Ampli41, 4, 1, 201, 23, FALSE);
   ConfigurerAmpli(Ampli42, 4, 2, 202, 24, FALSE);
   ConfigurerAmpli(Ampli43, 4, 3, 203, 24, FALSE);     
   ConfigurerAmpli(Ampli44, 4, 4, 204, 24, TRUE);
   ConfigurerAmpli(Ampli45, 4, 5, 205, 25, FALSE);   
   ConfigurerAmpli(Ampli47, 4, 7, 207, 25, TRUE);   

   ConfigurerAmpli(Ampli51, 5, 1, 208, 26, FALSE);
   ConfigurerAmpli(Ampli52, 5, 2, 209, 27, FALSE);
   ConfigurerAmpli(Ampli53, 5, 3, 210, 27, FALSE);     
   ConfigurerAmpli(Ampli54, 5, 4, 211, 27, TRUE);     

 (** cartes CES **)
   ConfigurerCES(CarteCes1, 01);
   ConfigurerCES(CarteCes2, 02);
   ConfigurerCES(CarteCes3, 03);
   ConfigurerCES(CarteCes4, 04);


(** Liaisons Inter-Secteur **)

   ConfigurerIntsecteur(Intersecteur1, 01, trL0125, trL0123);


(* Initialisations des variables ne correspondant pas a des entrees secu *)
(* Point d'arret *)
    AffectBoolD( BoolRestrictif, PtArrCdvCEN10);
(* rajout du 9/3/1998 : FC *)
    AffectBoolD( BoolRestrictif, PtArrCdvCEN12);
(* rajouyt du 10/3/1998 *)
    AffectBoolD( BoolPermissif, PtArrSpec15);
    AffectBoolD( BoolRestrictif, PtArrSigCEN10);
    AffectBoolD( BoolRestrictif, PtArrSigCEN12);
    AffectBoolD( BoolRestrictif, PtArrCdvCEN15);
    AffectBoolD( BoolRestrictif, PtArrCdvULA12);
    AffectBoolD( BoolRestrictif, PtArrCdvULA13);
    AffectBoolD( BoolRestrictif, PtArrCdvULA14);

    AffectBoolD( BoolRestrictif, PtArrCdvULA23);
    AffectBoolD( BoolRestrictif, PtArrCdvULA22);
    AffectBoolD( BoolRestrictif, PtArrCdvCEN24);
    AffectBoolD( BoolRestrictif, PtArrSigCEN24);
    AffectBoolD( BoolRestrictif, PtArrCdvCEN21);
    
(* modif. du 24/2/2000 : Modif de la gestion du SP1 *)
    AffectBoolD( BoolPermissif,  PtArrSpec21B);
(*  AffectBoolD( BoolRestrictif, PtArrCdvCEN21A);   *)

    AffectBoolD( BoolRestrictif, PtArrCdvCEN20);
    AffectBoolD( BoolRestrictif, PtArrSigCEN14);
    AffectBoolD( BoolRestrictif, PtArrSigCEN22);

(* Aiguilles fictives *)

(* Tiv Com non lies a une aiguille *)
    AffectBoolD( BoolRestrictif, TivComCEN12);

(* Variants anticipes *)
    AffectBoolD( BoolRestrictif, PtAntCdvREP11);
    AffectBoolD( BoolRestrictif, PtAntCdvREP12);
    AffectBoolD( BoolRestrictif, PtAntCdvUSA22);
    AffectBoolD( BoolRestrictif, PtAntCdvUSA23);

(* Variables de memorisation des etats du cdv 14 et SP2 pour les SP *)
    AffectBoolD( BoolPermissif, CdvCEN14prec);
    AffectBoolD( BoolRestrictif, Sp2CENprec);

(* Copie des entrees dans des variables fonctionnelles pour la regulation *)
    CdvCEN12Fonc := FALSE;
    CdvCEN22Fonc := FALSE;
    CdvULA12Fonc := FALSE;
    CdvULA22Fonc := FALSE;

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

   ConfigEmisTeleSolTrain ( te11s24t01,
                            noBoucle1,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te15s24t02,
                            noBoucle2,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te21s24t03,
                            noBoucle3,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te23s24t04,
                            noBoucle4,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te26s24t05,
                            noBoucle5,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);


(* CONFIGURATION POUR LA REGULATION *)
   ConfigQuai ( 8, 64, CdvCEN12Fonc, te11s24t01, 0, 5,  6,  7,  7, 13, 14, 15);
   ConfigQuai ( 8, 69, CdvCEN22Fonc, te23s24t04, 0, 3, 11,  5, 10, 13, 14, 15);
   ConfigQuai ( 9, 74, CdvULA12Fonc, te15s24t02, 0, 9, 11,  5,  6, 13, 14, 15);
   ConfigQuai ( 9, 79, CdvULA22Fonc, te21s24t03, 0, 3,  9,  4, 11, 13, 14, 15);

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
   ProcEmisSolTrain( te11s24t01.EmissionSensUp, (2*noBoucle1), 
                     LigneL01+ L0124+ TRONC*01,

              PtArrCdvCEN10,
              PtArrSigCEN10,
              BoolRestrictif,             (* aspect croix *)
              PtArrCdvCEN12,
              PtArrSigCEN12,
              BoolRestrictif,             (* aspect croix *)
              TivComCEN12,
              BoolRestrictif,
(* Variants Anticipes *)
              PtArrCdvCEN15,
              PtArrSpec15,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
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
   ProcEmisSolTrain( te15s24t02.EmissionSensUp, (2*noBoucle2), 
                     LigneL01+ L0124+ TRONC*02,

              PtArrCdvCEN15,
              PtArrSpec15,
              PtArrCdvULA12,
              PtArrCdvULA13,
              PtArrCdvULA14,
              PtArrSigCEN22,
              BoolRestrictif,             (* aspect croix *)
              BoolRestrictif,
(* Variants Anticipes *)
              PtAntCdvREP11,
              PtAntCdvREP12,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
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
   ProcEmisSolTrain( te21s24t03.EmissionSensUp, (2*noBoucle3), 
                     LigneL01+ L0124+ TRONC*03,

              PtArrCdvULA23,
              PtArrCdvULA22,
              PtArrCdvCEN24,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
(* Variants Anticipes *)
              PtArrSigCEN24,
              BoolRestrictif,             (* aspect croix *)
              PtArrCdvCEN21,
              BoolRestrictif,
              BoolRestrictif,
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
   ProcEmisSolTrain( te23s24t04.EmissionSensUp, (2*noBoucle4), 
                     LigneL01+ L0124+ TRONC*04,
  
              PtArrSigCEN24,
              BoolRestrictif,             (* aspect croix *)
              PtArrCdvCEN21,
              PtArrSpec21B,
              PtArrCdvCEN20,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
(* Variants Anticipes *)
              PtAntCdvUSA23,
              PtAntCdvUSA22,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
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
   ProcEmisSolTrain( te26s24t05.EmissionSensUp, (2*noBoucle5), 
                     LigneL01+ L0124+ TRONC*05,

              PtArrSigCEN14,
              BoolRestrictif,             (* aspect croix *)
              AigCEN13.PosReverseFiltree,
              AigCEN13.PosNormaleFiltree,
              BoolRestrictif,             (* signal rouge fix fict. SigCEN12A *)
              BoolRestrictif,             (* aspect croix *)
              BoolRestrictif,
              BoolRestrictif,
(* Variants Anticipes *)
              PtArrCdvCEN21,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
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
(* reception du secteur 25 -aval- *)

   ProcReceptInterSecteur(trL0125, noBouclehea, LigneL01+ L0125+ TRONC*01,
                  PtAntCdvREP11,
                  PtAntCdvREP12,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
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

(* reception du secteur 23 -amont- *)

   ProcReceptInterSecteur(trL0123, noBouclepdg, LigneL01+ L0123+ TRONC*02,

                  PtAntCdvUSA23,
                  PtAntCdvUSA22,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
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
(* emission vers le secteur 25 -aval- *)

   ProcEmisInterSecteur (teL0125, noBouclehea, LigneL01+ L0124+ TRONC*03,
			noBouclehea,
                  PtArrCdvULA23,
                  PtArrCdvULA22,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
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

(* emission vers le secteur 23 -amont- *)

   ProcEmisInterSecteur (teL0123, noBouclepdg, LigneL01+ L0124+ TRONC*01,
			noBouclepdg,
                  PtArrCdvCEN10,
                  PtArrSigCEN10,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
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


 (** Emission invariants vers secteur 25 aval L0125 **)

   EmettreSegm(LigneL01+ L0124+ TRONC*03+ SEGM*00, noBouclehea, SensUp);
   EmettreSegm(LigneL01+ L0124+ TRONC*04+ SEGM*00, noBouclehea, SensUp);

 (** Emission invariants vers secteur 23 amont L0123 **)

   EmettreSegm(LigneL01+ L0124+ TRONC*01+ SEGM*00, noBouclepdg, SensUp);
   EmettreSegm(LigneL01+ L0124+ TRONC*02+ SEGM*00, noBouclepdg, SensUp);

 (** Boucle 1 **)
   EmettreSegm(LigneL01+ L0124+ TRONC*01+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL01+ L0124+ TRONC*02+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL01+ L0124+ TRONC*02+ SEGM*01, noBoucle1, SensUp);
   EmettreSegm(LigneL01+ L0125+ TRONC*01+ SEGM*00, noBoucle1, SensUp);

 (** Boucle 2 **)
   EmettreSegm(LigneL01+ L0124+ TRONC*02+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL01+ L0124+ TRONC*02+ SEGM*01, noBoucle2, SensUp);
   EmettreSegm(LigneL01+ L0124+ TRONC*02+ SEGM*02, noBoucle2, SensUp);
   EmettreSegm(LigneL01+ L0125+ TRONC*01+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL01+ L0125+ TRONC*02+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL01+ L0124+ TRONC*05+ SEGM*00, noBoucle2, SensUp);

 (** Boucle 3 **)
   EmettreSegm(LigneL01+ L0124+ TRONC*03+ SEGM*00, noBoucle3, SensUp);
   EmettreSegm(LigneL01+ L0124+ TRONC*04+ SEGM*00, noBoucle3, SensUp);
   EmettreSegm(LigneL01+ L0124+ TRONC*04+ SEGM*01, noBoucle3, SensUp);
   EmettreSegm(LigneL01+ L0123+ TRONC*02+ SEGM*00, noBoucle3, SensUp);

 (** Boucle 4 **)
   EmettreSegm(LigneL01+ L0124+ TRONC*04+ SEGM*01, noBoucle4, SensUp);
   EmettreSegm(LigneL01+ L0124+ TRONC*04+ SEGM*02, noBoucle4, SensUp);
   EmettreSegm(LigneL01+ L0123+ TRONC*02+ SEGM*00, noBoucle4, SensUp);
   EmettreSegm(LigneL01+ L0123+ TRONC*02+ SEGM*01, noBoucle4, SensUp);
   EmettreSegm(LigneL01+ L0124+ TRONC*02+ SEGM*02, noBoucle4, SensUp);

 (** Boucle 5 **)
   EmettreSegm(LigneL01+ L0124+ TRONC*05+ SEGM*00, noBoucle5, SensUp);
   EmettreSegm(LigneL01+ L0124+ TRONC*04+ SEGM*00, noBoucle5, SensUp);
   EmettreSegm(LigneL01+ L0124+ TRONC*04+ SEGM*01, noBoucle5, SensUp);
   EmettreSegm(LigneL01+ L0124+ TRONC*04+ SEGM*02, noBoucle5, SensUp);
   EmettreSegm(LigneL01+ L0124+ TRONC*01+ SEGM*00, noBoucle5, SensUp);

(*  *)

(*************************** CONFIGURATION DES TRONCONS TSR **************************)

   ConfigurerTroncon(Tronc0, LigneL01 + L0124 + TRONC*01, 2,2,2,2);  (* troncon 24-1 *)
   ConfigurerTroncon(Tronc1, LigneL01 + L0124 + TRONC*02, 2,2,2,2);  (* troncon 24-2 *)
   ConfigurerTroncon(Tronc2, LigneL01 + L0124 + TRONC*03, 2,2,2,2);  (* troncon 24-3 *)
   ConfigurerTroncon(Tronc3, LigneL01 + L0124 + TRONC*04, 2,2,2,2);  (* troncon 24-4 *)
   ConfigurerTroncon(Tronc4, LigneL01 + L0124 + TRONC*05, 2,2,2,2);  (* troncon 24-5 *)


(************************************** EMISSION DES TSR *************************************)



(** Emission des TSR vers le secteur aval 25 L0125 **)

   EmettreTronc(LigneL01+ L0124+ TRONC*03, noBouclehea, SensUp);
   EmettreTronc(LigneL01+ L0124+ TRONC*04, noBouclehea, SensUp);


(** Emission des TSR vers le secteur amont 23 L0123 **)

   EmettreTronc(LigneL01+ L0124+ TRONC*01, noBouclepdg, SensUp);
   EmettreTronc(LigneL01+ L0124+ TRONC*02, noBouclepdg, SensUp);

 (** Emission des TSR sur les troncons du secteur courant **)

   EmettreTronc(LigneL01+ L0124+ TRONC*01, noBoucle1, SensUp); (* troncon 24-1 *)
   EmettreTronc(LigneL01+ L0124+ TRONC*02, noBoucle1, SensUp);
   EmettreTronc(LigneL01+ L0125+ TRONC*01, noBoucle1, SensUp);


   EmettreTronc(LigneL01+ L0124+ TRONC*02, noBoucle2, SensUp); (* troncon 24-2 *)
   EmettreTronc(LigneL01+ L0125+ TRONC*01, noBoucle2, SensUp);
   EmettreTronc(LigneL01+ L0125+ TRONC*02, noBoucle2, SensUp);
   EmettreTronc(LigneL01+ L0124+ TRONC*05, noBoucle2, SensUp);


   EmettreTronc(LigneL01+ L0124+ TRONC*03, noBoucle3, SensUp); (* troncon 24-3 *)
   EmettreTronc(LigneL01+ L0124+ TRONC*04, noBoucle3, SensUp);
   EmettreTronc(LigneL01+ L0123+ TRONC*02, noBoucle3, SensUp);


   EmettreTronc(LigneL01+ L0124+ TRONC*04, noBoucle4, SensUp); (* troncon 24-4 *)
   EmettreTronc(LigneL01+ L0123+ TRONC*02, noBoucle4, SensUp);
   EmettreTronc(LigneL01+ L0124+ TRONC*02, noBoucle4, SensUp);


   EmettreTronc(LigneL01+ L0124+ TRONC*05, noBoucle5, SensUp); (* troncon 24-5 *)
   EmettreTronc(LigneL01+ L0124+ TRONC*04, noBoucle5, SensUp);
   EmettreTronc(LigneL01+ L0124+ TRONC*01, noBoucle5, SensUp);

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
    StockAdres( ADR( CdvCEN10));
    StockAdres( ADR( SigCEN10));
    StockAdres( ADR( CdvCEN11));
    StockAdres( ADR( SigCEN12kv));
    StockAdres( ADR( SigCEN12kj));
    StockAdres( ADR( CdvCEN13));
    StockAdres( ADR( CdvCEN15));
    StockAdres( ADR( CdvULA12));
    StockAdres( ADR( CdvULA13));
    StockAdres( ADR( CdvULA14));
    StockAdres( ADR( CdvULA23));
    StockAdres( ADR( CdvULA22));
    StockAdres( ADR( CdvCEN24));
    StockAdres( ADR( SigCEN24));
    StockAdres( ADR( CdvCEN23));
    StockAdres( ADR( CdvCEN21B));
    StockAdres( ADR( CdvCEN21A));
    StockAdres( ADR( CdvCEN20));
    StockAdres( ADR( SigCEN14));
    StockAdres( ADR( SigCEN22));
    StockAdres( ADR( Sp1CEN));
    StockAdres( ADR( Sp2CEN));
    StockAdres( ADR( CdvCEN12));
    StockAdres( ADR( CdvCEN22));
    StockAdres( ADR( CdvCEN14));

    StockAdres( ADR( AigCEN13));

    StockAdres( ADR( PtArrCdvCEN10));
    StockAdres( ADR( PtArrSigCEN10));
(* rajout du 9/3/1998 *)
    StockAdres( ADR( PtArrCdvCEN12));
(* rajout du 10/3/1998 *)
    StockAdres( ADR( PtArrSpec15));
    StockAdres( ADR( PtArrSigCEN12));
    StockAdres( ADR( PtArrCdvCEN15));
    StockAdres( ADR( PtArrCdvULA12));
    StockAdres( ADR( PtArrCdvULA13));
    StockAdres( ADR( PtArrCdvULA14));
    StockAdres( ADR( PtArrCdvULA23));
    StockAdres( ADR( PtArrCdvULA22));
    StockAdres( ADR( PtArrCdvCEN24));
    StockAdres( ADR( PtArrSigCEN24));
    StockAdres( ADR( PtArrCdvCEN21));

(* modif. du 24/2/2000 : modif. de la gestion du SP1 *)
    StockAdres( ADR( PtArrSpec21B));
(*  StockAdres( ADR( PtArrCdvCEN21A));               *)

    StockAdres( ADR( PtArrCdvCEN20));
    StockAdres( ADR( PtArrSigCEN14));
    StockAdres( ADR( PtArrSigCEN22));

    StockAdres( ADR( TivComCEN12));

    StockAdres( ADR( PtAntCdvREP11));
    StockAdres( ADR( PtAntCdvREP12));
    StockAdres( ADR( PtAntCdvUSA22));
    StockAdres( ADR( PtAntCdvUSA23));

    StockAdres( ADR( CdvCEN14prec));
    StockAdres( ADR( Sp2CENprec));

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
VAR BoolTr, BoolTemp, 
    TmpNonReset, TmpCdv14p, (* var. interm  *)
    BoolReset, BoolSet (* logique de mise a 0 et a 1 du point d'arret spec *)
                      : BoolLD;

BEGIN (* ExeSpecific *)

(* Affectation des "constantes" utilisees dans la construction des messages emis    *)
(* et recus sur les boucles de transmission continue et sur les liens intersecteur. *)
(* Cette reaffectation est necessaire a chaque cycle pour la mise en securite.      *)
   AffectBoolC(Vrai, BoolPermissif)  ;
   AffectBoolC(Faux, BoolRestrictif) ;

(* regulation *)
  CdvCEN12Fonc := CdvCEN12.F = Vrai.F;
  CdvCEN22Fonc := CdvCEN22.F = Vrai.F;
  CdvULA12Fonc := CdvULA12.F = Vrai.F;
  CdvULA22Fonc := CdvULA22.F = Vrai.F;


(*  *)
(*********************************** FILTRAGE DES AIGUILLES ******************************)

   FiltrerAiguille( AigCEN13, BaseExeAig);

(************************** Gerer les aiguilles non lues **********************)


(******************* Gerer les Tiv Com non lies a une aiguille ****************)

   AffectBoolD( SigCEN12kv,                 TivComCEN12);

(************************** Gerer les point d'arrets **************************)

   AffectBoolD( CdvCEN10,                   PtArrCdvCEN10);
   AffectBoolD( SigCEN10,                   PtArrSigCEN10);
   OuDD(        SigCEN12kv,   SigCEN12kj,   PtArrSigCEN12);

(* retire le 10/3/1998:
    PtArrCdv15 = Cdv15 et non Sp2 et non (Sp1 et Aig devie) 
   NonD(        Sp2CEN,       BoolTr);
   EtDD(        CdvCEN15,     BoolTr,       PtArrCdvCEN15);
   EtDD(        Sp1CEN,       AigCEN13.PosReverseFiltree, BoolTr);
   NonD(        BoolTr,       BoolTr);
   EtDD(        PtArrCdvCEN15,BoolTr,       PtArrCdvCEN15); *)

(* retire le 10/12/1998 :
   NonD(        Sp2CEN,       BoolSp2);
   NonD(        Sp1CEN,       BoolSp1);
   OuDD(        BoolSp1,      AigCEN13.PosNormaleFiltree, BoolSp1);
   EtDD(        BoolSp1,      BoolSp2,      PtArrSpec15); *)

(* rajout du 10/12/1998, modifie le 14 *)

   EtDD(  AigCEN13.PosReverseFiltree,   Sp1CEN,     BoolReset );
   OuDD(  BoolReset,                    Sp2CEN,     BoolReset );
   EtDD(  BoolReset,                    CdvCEN14,   BoolReset );
   
   NonD(  Sp2CEN, BoolSet );
   NonD(  CdvCEN14prec, TmpCdv14p );
   EtDD(  Sp2CENprec, BoolSet, BoolSet );
   OuDD(  BoolSet, TmpCdv14p, BoolSet );
   EtDD(  CdvCEN14, BoolSet, BoolSet);

   NonD(  BoolReset,     TmpNonReset );
   EtDD(  TmpNonReset,   PtArrSpec15,     PtArrSpec15);
   OuDD(  PtArrSpec15,   BoolSet,         PtArrSpec15);

   AffectBoolD( CdvCEN14, CdvCEN14prec );
   AffectBoolD( Sp2CEN, Sp2CENprec );

   (* rajout du 9/3/1998 *)
   OuDD(CdvCEN13, AigCEN13.PosReverseFiltree, BoolTemp);
   EtDD(BoolTemp, CdvCEN12, PtArrCdvCEN12);

   (* rajout du 11/3/1998 *)
   AffectBoolD( CdvCEN15,                   PtArrCdvCEN15);

   AffectBoolD( CdvULA12,                   PtArrCdvULA12);
   AffectBoolD( CdvULA13,                   PtArrCdvULA13);
   AffectBoolD( CdvULA14,                   PtArrCdvULA14);

   AffectBoolD( CdvULA23,                   PtArrCdvULA23);
   AffectBoolD( CdvULA22,                   PtArrCdvULA22);
   AffectBoolD( CdvCEN24,                   PtArrCdvCEN24);
   AffectBoolD( SigCEN24,                   PtArrSigCEN24);
   EtDD(        CdvCEN21B,    CdvCEN21A,    PtArrCdvCEN21);

(*  modif du 24/2/2000 : modif. de la gestion du SP1           *)
     NonD(        Sp1CEN,       PtArrSpec21B);
(*   NonD(        Sp1CEN,       BoolTr);                       *)
(*   EtDD(        CdvCEN21A,    BoolTr,       PtArrCdvCEN21A); *)

   AffectBoolD( CdvCEN20,                   PtArrCdvCEN20);
   AffectBoolD( SigCEN14,                   PtArrSigCEN14);
   AffectBoolD( SigCEN22,                   PtArrSigCEN22);



(*** lecture des entrees de regulation ***)

   LireEntreesRegul;

END ExeSpecific;
END Specific.
