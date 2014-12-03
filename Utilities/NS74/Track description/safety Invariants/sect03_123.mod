IMPLEMENTATION MODULE Specific;

(*$S- *)
(*$T- *)

(******************************************************************************
*   SANTIAGO - Ligne 5 - Secteur 3
*  =============================
*  Version : SCCS 1.1.0
*  Date    : 19/2/1997
*  Auteur  : F. CHANIER.
*  Version : du 25.8.1997 
******************************************************************************)

(*---------------------------------------------------------------------------*)
(* Modifications :                                                           *)
(* -------------                                                             *)
(*                                                                           *)
(* Version 1.1.1                                                             *)
(* Date : 30/10/1997, Auteur : P. Hog    ,  Origine : OM 34                  *)
(*  Modification de la procedure "InitSpecConfMess", correction des marches  *)
(*  types PA des stations NUBLE voie 1 et 2 et RODRIGO ARAYA voie 1.	     *)
(*									     *)
(* Version 1.1.2                                                             *)
(* Date : 2/2/1998, Auteur : F. Chanier, Or: Eq. dev.                        *)
(*  Rajout des appels a ConfigurerAmpli et ajout de vauNUB21Ctc entree 33    *)
(*  pour utiliser la cinquieme carte CES.                                    *)  
(*****************************************************************************)
(* Version 1.1.3  =======================                                    *)
(* Version 1.5 DU SERVEUR SCCS =====================                         *)
(* Date :         17/12/98                                                   *)
(* Auteur :       H. Le Roy                                                  *)
(* Modification : am ba071298-2                                              *)
(*                 Creation d'une equation sur le point d'arret 40A de NUB   *)
(*****************************************************************************)
(* Version 1.1.4  =======================                                    *)
(* Version 1.6 DU SERVEUR SCCS =====================                         *)
(* Date :         20/01/99                                                   *)
(* Auteur :       H. Le Roy                                                  *)
(* Modification : fa-001 : Modification de l'equation du point d'arret 40A.  *)
(*  Si l'aiguille 39B est decontrolee :                                      *)
(*        - le train s'arretera a une distance de securite de 25m si le pt   *)
(*           d'arret est vu permissif.                                       *)
(*        - il peut par contre approcher si le point d'arret est restrictif. *)
(*  Le point d'arret doit donc etre determine a partir de la position gauche *)
(*     et non de la position "non droite" de l'aiguille                      *) 
(*****************************************************************************)
(* Version 1.1.5  =======================                                    *)
(* Version 1.7 DU SERVEUR SCCS =====================                         *)
(* Date :         07/10/99                                                   *)
(* Auteur :       H. Le Roy                                                  *)
(* Modification : Adaptation de la configuration des amplis au standard      *)
(*                  1.3.3  Suppression d'importations, de declarations de    *)
(*                  constantes et variables, d'appels de fonctions  inutiles.*)
(*                  Suppression de code inutile concernant les DAMTC.        *)
(*---------------------------------------------------------------------------*)
(* Version 1.1.6  =====================                                      *)
(* Version 1.8 DU SERVEUR SCCS =====================                         *)
(* Date    :      24/05/2000                                                 *)
(* Auteur  :      D. MARTIN                                                  *)
(* Modification : Am 0165 : Ajustement des marches-types                     *)
(*                                                                           *)
(*****************************************************************************)
(* Version 1.2.0  =====================                                      *)
(* Version 1.10 DU SERVEUR SCCS =====================                        *)
(* Date    :      13/08/2002                                                 *)
(* Auteur  :      M. PLYWACZ                                                 *)
(* Modification : prolongement L5, ajout sp,                                 *)
(*                                                                           *)
(*****************************************************************************)
(* Version 1.2.1  =====================                                      *)
(* Version 1.11 DU SERVEUR SCCS =====================                        *)
(* Date    :      14/11/2002                                                 *)
(* Auteur  :      M. PLYWACZ                                                 *)
(* Modifications : conditions de ArrSpeNub13 = Non(SP2 & SigNUB12)           *)
(*                 ajoute dans troncons 1;2;4 pvNUB13tc.PtArret              *)
(*                 inversion ordre EntreeAiguille(AigNUB21D11, 26, 25)       *)
(*****************************************************************************)
(* Version 1.2.2  =====================                                      *)
(* Version 1.12 DU SERVEUR SCCS =====================                        *)
(* Date    :      09/07/2009                                                 *)
(* Auteur  :      Ph. HOG                                                    *)
(* Modifications : Prolongement L5 vers MAIPU, modif ateliers                *)
(* Troncon 4 : Déclaration de l'aiguille 41 (com 21C-41)                     *)
(*             Forcage au rouge du signal 40B si l'aiguille 41 est à gauche. *)
(*             Emission du nouveau segment.                                  *)
(*****************************************************************************)
(* Version 1.2.3  =====================                                      *)
(* Version 1.12 DU SERVEUR SCCS =====================                        *)
(* Date    :      18/09/2012                                                 *)
(* Auteur  :      X. Raby                                                    *)
(* Modifications : Modification des points d'arret en station                *)
(* Troncon 6 : Ajout du point d'arret subcantonné PtArrCdvNub22              *)
(*****************************************************************************)


(******************************  IMPORTATIONS  *******************************)

FROM SYSTEM     IMPORT ADR;

FROM Opel       IMPORT StockAdres, AffectBoolD, AffectBoolC, BoolC, BoolD, BoolLD, EtDD, CodeD,
		       EtatD, Tvrai, FinBranche, FinArbre, AffectC, AffectEtatC, OuDD, NonD;

FROM ConstCode  IMPORT BoolPermissif, BoolRestrictif, Vrai, Faux,
		       Zero, Etat0C, Etat4C;

FROM BibAig     IMPORT TyAig, FiltrerAiguille,
                       EntreeAiguille;

FROM BibExploi  IMPORT
(* types *)
                       TyPortionVoie,
                       TyReconfTransLocale,
                       TyReconfTransAmont,
(* procedures *)
                       VoieLimitrophe,
                       VoieProtegee,
                       VoieProtegeeContresens,
                       VoieNonProtegee,
                       ChainerPortionVoie,
                       TraiterDivergence,
                       TraiterConvergence; 


FROM NouvRegul IMPORT  LireEntreesRegul,
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
                       ProcReceptInterSecteur;


FROM BibEnregDam  IMPORT
(* Types *)           
		       TyBoucle, 
(* variables *)
 		       Ampli11, Ampli12, Ampli13, Ampli14,
		       Ampli21, Ampli22, Ampli23, Ampli24, Ampli25,          Ampli27,
		       Ampli31, Ampli32, Ampli33, Ampli34,
		       Ampli41, Ampli42, Ampli43, Ampli44, Ampli45, Ampli46, Ampli47,
		       Ampli51, Ampli52, Ampli53, Ampli54, Ampli55,          Ampli57,
		       Ampli61, Ampli62, Ampli63, Ampli64, Ampli65, Ampli66,
		       Ampli67, Ampli68, Ampli69, Ampli6A, Ampli6B, Ampli6C, Ampli6D,
		       Ampli71, Ampli72,          Ampli74,

                   Boucle1, Boucle2, Boucle3, Boucle4, Boucle5, Boucle6, Boucle7, BoucleFictive,
		       CarteCes1,  CarteCes2,  CarteCes3,  CarteCes4, CarteCes5,
                       Intersecteur1,

(* PROCEDURES *)       ConfigurerBoucle,
		(* C+AMP *)       ConfigurerAmpli,	
                       ConfigurerIntsecteur,
                       ConfigurerCES; 


FROM BibTsr      IMPORT
   (* VARIABLES *)
 Tronc0,  Tronc1,  Tronc2,  Tronc3 , Tronc4,  Tronc5, (* utilises *)
 Tronc6,  Tronc7,  Tronc8,  Tronc9,  Tronc10, Tronc11,
 Tronc12, Tronc13, Tronc14, Tronc15, (* inutilises *) 
   (* PROCEDURE *)
                       ConfigurerTroncon;


FROM ESbin     	 IMPORT 
			ProcEntreeIntrins;

(*****************************  CONSTANTES  ***********************************)

CONST

(** No ligne, No secteur, ....**)

(* supprime *)
    LigneL05 = 16384*00; (* numero de ligne decale de 2**14 *)

    L0504  = 1024*04;    (* numero Secteur aval voie impaire decale de 2**10 *)

    L0503  = 1024*03;    (* numero Secteur local decale de 2**10 *)

    L0502  = 1024*02;    (* numero Secteur amont voie impaire decale de 2**10 *)

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
(* prise en compte de l'AM GH/20 : inversion des deux liaisons intersecteur *)
    noBoucleval = 00;
    noBoucleira = 01;     
    noBouclefi = 02; (* boucle fictive *)
    noBoucle1 = 03;
    noBoucle2 = 04;
    noBoucle3 = 05;
    noBoucle4 = 06;
    noBoucle5 = 07;
    noBoucle6 = 08;
    noBoucle7 = 09;

(** Base pour les tables de compensation **)
    BaseEntVar	= 500 	;
    BaseSorVar	= 600 	;
    BaseExeAig	= 1280	;
    BaseExeChainage = 1360 ;
    BaseExeSpecific = 1950 ;


(* DECLARATION DES VARIABLES GENERALES *)
 VAR
		       Boucleira, Boucleval, Bouclefi : TyBoucle;


(* DECLARATION DES SINGULARITES DU SECTEUR 03 : dans les deux sens confondus *)

(** Portions de voie - sens impair ***)
    pvNUB8Atc, 
    pvNUB8Btc,    (* pvNUB8Btcr, *)
    pvNUB8sig,    	
    pvNUB9revtc, (* portion de voie comprenant 9 deviee, 21A1, 40 *)
    pvNUB9nortc, (* portion de voie comprenant 9 nor et 10 *)
    pvNUB40Bsig, (* portion de voie comprenant 41, 21C, 11rev *)
    pvNUB10sig,  (* portion de voie 11nor *) 	
    pvNUB11pointetc, (* portion de voie comprenant 11 pointe et 12 *)
    pvNUB13tc,
    pvROD10Atc,
    pvROD10Btc,
    pvROD11tc,
    pvROD12tc,
    pvROD13tc			: TyPortionVoie;

(* portions de voie - definie pour la regulation *)
    regNUB12tcsecu : BoolD;
    regNUB12tcfonc : BOOLEAN;

(** Portions de voie - sens pair ***)
    pvROD23Btc,              
    pvROD23Atc,
    pvROD22tc, 
    pvROD21tc,
    pvNUB24Btc,
    pvNUB24Atc,
    pvNUB22tc,
    pvNUB22sig, (* portion de voie comprenant 21C *)
    pvNUB21Cnortc, (* portion de voie comprenant 21Cnor, 21B, 21Anor *)
    pvNUB21Crevtc, (* portion de voie comprenant 21Crev, 41, 40 *)
    pvNUB40Asig, (* portion de voie comprenant 39Bpointe *)
    pvNUB39Brevtc, (* portion de voie vers l'atelier *)
    pvNUB39Bnortc, (* portion de voie vers la ligne sens pair *) 
    pvNUB21Apointetc,
    pvNUB21Anortc,
    pvNUB21Arevtc,   
    pvNUB20tc			: TyPortionVoie;


(** Voie d'emission SOL-TRAIN : deux sens confondus**)
    te11s03t01,
    te13s03t02,
    te16s03t03,
    te21s03t04,
    te24s03t05,
    te31s03t06,
    te37s03t07			:TyEmissionTele;

(** Voie d'emission Inter-secteur deux voies confondues **)
    teL0502,
    teL0504				:TyEmissionTele;

(** Voie de reception Inter-secteur deux voies confondues **)
    trL0502,
    trL0504				:TyCaracEntSec; 

(* boucle en amont des deux voies *)
    BoucleAmv1,
    BoucleAmv2,
    BoucleAmfi				: TyBoucle;
 
(* aiguilles *)
    AigNUB21C41,
    AigNUB39B21B,
    AigNUB21A9,
    AigNUB21D11 : TyAig;

(* variants lies a une commutation d'aiguille *)
    com1troncon1,
    com2troncon1,
    com3troncon1,
    com4troncon1 : BoolD; 

(* signaux ou autres entrees secus *)
    SigNUB12,
    SigNUB24,
    CdvNUB13,
    Sp2NUB,
    varsigNUB8kv,
    varsigNUB8kj,
    varsigNUB22kj,
    varsigNUB22kv,
    varNUB21Ctc : BoolD;   

(* signaux utilisees comme point d'arret *)
    PtArr40ASig : BoolD;
    PtArrSigNub40B : BoolD;
    PtArrSigNub12 : BoolD;
    PtArrSigNub24 : BoolD;
    PtArrSpeNub13 : BoolD;
    
    PtArrCdvNub22 : BoolD;
    

  V1, V2, V3, V4, V5, V6 : BOOLEAN;


(* DECLARATION DES SINGULARITES N'APPARTENANT PAS AU SECTEUR ********************)

(** 1ere portion de voie sur secteur 02 **)
    pvIRA23Btc				    : TyPortionVoie;
(** 1ere portion de voie sur secteur 04 **)
    pvVAL10tc				    : TyPortionVoie;

(** Variants Booleens recus du secteur 02 *)
    varIRA23Atc                                 : BoolD;
(** Variants Booleens recus du secteur 04 *)
    varVAL11tc,
    varVAL12tc					: BoolD;     


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

(* C-ESSAI EntreesCouplage(145); *)

(* CONFIGURATIONS DIVERSES ****************************************************)

(* CONFIGURATION DES AIGUILLES, POUR LES DEUX VOIES *)
   EntreeAiguille(AigNUB21C41, 17, 18); (* a gauche, position normale *)
   EntreeAiguille(AigNUB39B21B, 20, 21); (* a gauche, position normale *)
   EntreeAiguille(AigNUB21A9, 23, 22);  (* a droite, position normale *)
   EntreeAiguille(AigNUB21D11, 26, 25); (* a droite, position normale *)

(* CONFIGURATION DES SIGNAUX et de CDV*)
   ProcEntreeIntrins (15, varsigNUB22kv); 
   ProcEntreeIntrins (16, varsigNUB22kj);
   ProcEntreeIntrins (29, varsigNUB8kv);
   ProcEntreeIntrins (30, varsigNUB8kj);
   ProcEntreeIntrins (32, regNUB12tcsecu);
   ProcEntreeIntrins (33, varNUB21Ctc);
   ProcEntreeIntrins (34, SigNUB12);
   ProcEntreeIntrins (35, SigNUB24);
 (* ProcEntreeIntrins (2 , CdvNUB13); *)
   ProcEntreeIntrins (37, Sp2NUB);

(* CONFIGURATION POUR LA MAINTENANCE de la transmission continue*)
   ConfigurerBoucle(Boucle1, 1);
   ConfigurerBoucle(Boucle2, 2);
   ConfigurerBoucle(Boucle3, 3);
   ConfigurerBoucle(Boucle4, 4);
   ConfigurerBoucle(Boucle5, 5);
   ConfigurerBoucle(Boucle6, 6);
   ConfigurerBoucle(Boucle7, 7);

(* C-AMP  ProcEntreeFonctio( 154, damtc11); *)
   ConfigurerAmpli(Ampli11, 1, 1, 154, 11, FALSE);
   ConfigurerAmpli(Ampli12, 1, 2, 155, 12, FALSE);
   ConfigurerAmpli(Ampli13, 1, 3, 156, 12, FALSE);
   ConfigurerAmpli(Ampli14, 1, 4, 157, 12, TRUE);

   ConfigurerAmpli(Ampli21, 2, 1, 158, 13, FALSE);
   ConfigurerAmpli(Ampli22, 2, 2, 159, 14, FALSE);
   ConfigurerAmpli(Ampli23, 2, 3, 192, 14, FALSE);
   ConfigurerAmpli(Ampli24, 2, 4, 193, 14, TRUE);
   ConfigurerAmpli(Ampli25, 2, 5, 194, 15, FALSE);

   ConfigurerAmpli(Ampli27, 2, 7, 196, 15, TRUE);

   ConfigurerAmpli(Ampli31, 3, 1, 197, 16, FALSE);
   ConfigurerAmpli(Ampli32, 3, 2, 198, 17, FALSE);
   ConfigurerAmpli(Ampli33, 3, 3, 199, 17, FALSE); 
   ConfigurerAmpli(Ampli34, 3, 4, 200, 17, TRUE);

   ConfigurerAmpli(Ampli41, 4, 1, 201, 21, FALSE);
   ConfigurerAmpli(Ampli42, 4, 2, 202, 22, FALSE);
   ConfigurerAmpli(Ampli43, 4, 3, 203, 22, FALSE);
   ConfigurerAmpli(Ampli44, 4, 4, 204, 22, TRUE);
   ConfigurerAmpli(Ampli45, 4, 5, 205, 23, FALSE);
   ConfigurerAmpli(Ampli46, 4, 6, 206, 23, FALSE);
   ConfigurerAmpli(Ampli47, 4, 7, 207, 23, TRUE);

   ConfigurerAmpli(Ampli51, 5, 1, 208, 24, FALSE);
   ConfigurerAmpli(Ampli52, 5, 2, 209, 25, FALSE);
   ConfigurerAmpli(Ampli53, 5, 3, 210, 25, FALSE);
   ConfigurerAmpli(Ampli54, 5, 4, 211, 25, TRUE);
   ConfigurerAmpli(Ampli55, 5, 5, 212, 26, FALSE);

   ConfigurerAmpli(Ampli57, 5, 7, 214, 26, TRUE);

   ConfigurerAmpli(Ampli61, 6, 1, 215, 31, FALSE); 
   ConfigurerAmpli(Ampli62, 6, 2, 216, 32, FALSE);
   ConfigurerAmpli(Ampli63, 6, 3, 217, 32, FALSE);
   ConfigurerAmpli(Ampli64, 6, 4, 218, 32, TRUE);
   ConfigurerAmpli(Ampli65, 6, 5, 219, 33, FALSE);
   ConfigurerAmpli(Ampli66, 6, 6, 220, 33, FALSE);
   ConfigurerAmpli(Ampli67, 6, 7, 221, 33, TRUE);
   ConfigurerAmpli(Ampli68, 6, 8, 222, 34, FALSE);
   ConfigurerAmpli(Ampli69, 6, 9, 223, 34, FALSE);
   ConfigurerAmpli(Ampli6A, 6, 10, 256, 34, TRUE); (* avant code en hexa *)
   ConfigurerAmpli(Ampli6B, 6, 11, 257, 35, FALSE);
   ConfigurerAmpli(Ampli6C, 6, 12, 258, 35, FALSE); 
   ConfigurerAmpli(Ampli6D, 6, 13, 259, 35, TRUE); 
 
   ConfigurerAmpli(Ampli71, 7, 1, 260, 37, FALSE);
   ConfigurerAmpli(Ampli72, 7, 2, 261, 38, FALSE);
   
   ConfigurerAmpli(Ampli74, 7, 4, 263, 38, TRUE);

                                     
 (** cartes CES **)
   ConfigurerCES(CarteCes1, 01); 
   ConfigurerCES(CarteCes2, 02);
   ConfigurerCES(CarteCes3, 03);
   ConfigurerCES(CarteCes4, 04);
   ConfigurerCES(CarteCes5, 05); 

(** Liaisons Inter-Secteur **)
(** la liaison avec le secteur aval est fictive **)
   ConfigurerIntsecteur(Intersecteur1, 01, trL0502, trL0504); 

(* Affectation a l'etat restrictif des variants commutes *)
   AffectBoolD(BoolRestrictif, com1troncon1) ;
   AffectBoolD(BoolRestrictif, com2troncon1) ;
   AffectBoolD(BoolRestrictif, com3troncon1) ;
   AffectBoolD(BoolRestrictif, com4troncon1) ;

(* Affectation a l'etat restrictif des points d'arret signaux ou cdv *)
   AffectBoolD(BoolRestrictif, PtArr40ASig)  ;
   AffectBoolD(BoolRestrictif, PtArrSigNub40B) ;
   AffectBoolD(BoolRestrictif, PtArrSigNub12)  ;
   AffectBoolD(BoolRestrictif, PtArrSigNub24)  ;
   AffectBoolD(BoolRestrictif, PtArrSpeNub13)  ;
   AffectBoolD(BoolRestrictif, PtArrCdvNub22)  ;

END InitSpecDivers;

(*----------------------------------------------------------------------------*)
PROCEDURE InitSpecPv;
(*----------------------------------------------------------------------------*)
(*
 * Fonction :
 * Cette procedure configure les singularites portions de voie.
 *
 * Condition d'appel : Appelee par InitSpecific a l'initialisation du logiciel
 *
 *)
(*----------------------------------------------------------------------------*)

BEGIN


(* CONFIGURATION DES PORTIONS DE VOIE SUR LA VOIE 1 **************************)

(* ITINERAIRE DIRECT SENS IMPAIR *)
(* points d'injection associes a la CEO011 *)
(* voir si la fonction VoieLimitrophe n'est pas la bonne *)

(* points d'injection associes a la Boucle 1 *)
   VoieProtegee(pvNUB8Atc, Rien, RienAmont, FALSE, Boucle1, Boucleira, 27);      
   VoieProtegee(pvNUB8Btc, Rien, RienAmont, FALSE, Boucle1, Boucleira, 28);
   VoieProtegeeContresens(pvNUB8sig, Rien, RienAmont, FALSE, Boucle1, Boucleira);
   VoieNonProtegee(pvNUB9revtc, Rien, RienAmont, Boucle1, Boucleira); (* on va jusque 40B sig *) 
   VoieNonProtegee(pvNUB9nortc, Rien, RienAmont, Boucle1, Boucleira); (* on anticipe *)
 
(* points d'injection associes a la Boucle 2 *)
   VoieProtegee(pvNUB10sig, Rien, RienAmont, FALSE, Boucle2, Boucle1, 1);
   VoieNonProtegee(pvNUB11pointetc, Rien, RienAmont, Boucle2, Boucle1);
   VoieProtegee(pvNUB13tc, Rien, RienAmont, FALSE, Boucle2, Boucle1, 2); 
   VoieProtegee(pvROD10Atc, Rien, RienAmont, FALSE, Boucle2, Boucle1, 3);

(* points d'injection associes a la Boucle3 *)
   VoieProtegee(pvROD10Btc, Rien, RienAmont, FALSE, Boucle3, Boucle2, 4);
   VoieProtegee(pvROD11tc, Rien, RienAmont, FALSE, Boucle3, Boucle2, 5);
   VoieProtegee(pvROD12tc, Rien, RienAmont, FALSE, Boucle3, Boucle2, 6);
   VoieProtegee(pvROD13tc, Rien, RienAmont, FALSE, Boucle3, Boucle2, 7);

(* points d'injection associes a la Boucle4 *)
   VoieNonProtegee(pvNUB9revtc, Rien, RienAmont, Boucle4, Boucle1);
   VoieProtegee(pvNUB40Bsig, Rien, RienAmont, FALSE, Boucle4, Boucle1, 24);

(* points d'injection associes a la Boucle5 *)
   VoieProtegee(pvROD23Btc, Rien, RienAmont, FALSE, Boucle5, Boucleval, 8);
   VoieProtegee(pvROD23Atc, Rien, RienAmont, FALSE, Boucle5, Boucleval, 9);
   VoieProtegee(pvROD22tc, Rien, RienAmont, FALSE, Boucle5, Boucleval, 10);
   VoieProtegee(pvROD21tc, Rien, RienAmont, FALSE, Boucle5, Boucleval, 11);

(* points d'injection associes a la Boucle6 *)
   VoieProtegee(pvNUB24Btc, Rien, RienAmont, FALSE, Boucle6, Boucle5, 12);
   VoieProtegee(pvNUB24Atc, Rien, RienAmont, FALSE, Boucle6, Boucle5, 36);
   VoieProtegee(pvNUB22tc, Rien, RienAmont, FALSE, Boucle6, Boucle5, 14);
   VoieProtegeeContresens(pvNUB22sig, Rien, RienAmont, FALSE, Boucle6, Boucle5);
   VoieNonProtegee(pvNUB21Crevtc, Rien, RienAmont, Boucle6, Boucle5);
   VoieNonProtegee(pvNUB21Cnortc, Rien, RienAmont, Boucle6, Boucle5);
   VoieProtegee(pvNUB40Asig, Rien, RienAmont, FALSE, Boucle6, Boucle5, 19);
   VoieNonProtegee(pvNUB39Brevtc, Rien, RienAmont, Boucle6, Boucle5);
   VoieNonProtegee(pvNUB39Bnortc, Rien, RienAmont, Boucle6, Boucle5);
   VoieNonProtegee(pvNUB21Cnortc, Rien, RienAmont, Boucle6, Boucle5); 
   VoieNonProtegee(pvNUB21Apointetc, Rien, RienAmont, Boucle6, Boucle5);

   VoieNonProtegee(pvNUB21Anortc, Rien, RienAmont, Boucle6, Boucle5);


   VoieLimitrophe(pvVAL10tc);
   VoieLimitrophe(pvIRA23Btc);
   VoieLimitrophe(pvNUB39Brevtc);

END InitSpecPv;

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

   ConfigEmisTeleSolTrain ( te11s03t01,
                            noBoucle1,         
                            BoolPermissif,   (* AigNUB21A9.PosNormale, *)
			    BoolRestrictif,  (* AigNUB21A9.PosReverse, *)
			    VariantsContinus,
			    CommutDifferee);


   ConfigEmisTeleSolTrain ( te13s03t02,
                            noBoucle2,         
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);
   

   ConfigEmisTeleSolTrain ( te16s03t03,
                            noBoucle3,         
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

                                              
   ConfigEmisTeleSolTrain ( te21s03t04,
                            noBoucle4,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);


   ConfigEmisTeleSolTrain ( te24s03t05,
                            noBoucle5,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);
 

   ConfigEmisTeleSolTrain ( te31s03t06,
                            noBoucle6,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);
 

   ConfigEmisTeleSolTrain ( te37s03t07,
                            noBoucle7,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

(* CONFIGURATION POUR LA REGULATION *)
   ConfigQuai(55, 64, regNUB12tcfonc, te13s03t02, 0, 8, 9, 4,11, 13, 14, 15);
   ConfigQuai(55, 69, pvNUB22tc.EntreeFonc, te31s03t06, 0, 2, 8, 9,11, 13, 14, 15);
   ConfigQuai(56, 74, pvROD12tc.EntreeFonc, te16s03t03, 0, 8, 9,11, 5, 13, 14, 15);
   ConfigQuai(56, 79, pvROD22tc.EntreeFonc, te24s03t05, 0, 8, 4, 5,10, 13, 14, 15);    

END InitSpecConfMess;

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

(* CONFIGURATION DES EMISSIONS DE VARIANTS SOL-TRAIN SUR VOIE PAIRE ***************)

(* variants troncon 1 *)

   ProcEmisSolTrain( te11s03t01.EmissionSensUp, (2*noBoucle1), 
                     LigneL05+ L0503+ TRONC*01,     

                  pvNUB8Btc.PtArret,
                  pvNUB8sig.PtArret,
                  BoolRestrictif (* AspectCroix *),
    		  AigNUB21A9.PosNormaleFiltree (* tivcom *),
		  AigNUB21A9.PosReverseFiltree,
		  AigNUB21A9.PosNormaleFiltree,			
		  BoolRestrictif,
		  BoolRestrictif,
(* Variants Anticipes *)
                  com1troncon1, 
                  com2troncon1, 
		  com3troncon1, 
		  com4troncon1,
		  BoolRestrictif,
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


(* variants troncon 2 *)

   ProcEmisSolTrain( te13s03t02.EmissionSensUp, (2*noBoucle2), 
                     LigneL05+ L0503+ TRONC*02,     

                  pvNUB10sig.PtArret, 
                  BoolRestrictif (* AspectCroix *),
                  pvNUB13tc.PtArret,
    		  PtArrSpeNub13,
		  pvROD10Atc.PtArret,
		  pvROD10Btc.PtArret,			
		  BoolRestrictif,
		  BoolRestrictif,
(* Variants Anticipes *)
                  pvROD11tc.PtArret,
                  pvROD12tc.PtArret,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
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


(* variants troncon 3 *)

   ProcEmisSolTrain( te16s03t03.EmissionSensUp, (2*noBoucle3), 
                     LigneL05+ L0503+ TRONC*03,     

                  pvROD11tc.PtArret,  
                  pvROD12tc.PtArret,
                  pvROD13tc.PtArret,
    		  pvVAL10tc.Entree,
		  BoolRestrictif,
		  BoolRestrictif,			
		  BoolRestrictif,
		  BoolRestrictif,
(* Variants Anticipes *)
                  varVAL11tc,
                  varVAL12tc,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
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

	 
(* variants troncon 4 *)

(* prise en compte de l'AM du 10/2/1997 : inversion signal 40A et 40B *)

   ProcEmisSolTrain( te21s03t04.EmissionSensUp, (2*noBoucle4), 
                     LigneL05+ L0503+ TRONC*04,     

                  PtArrSigNub40B,   
                  BoolRestrictif,               (* AspectCroix *)
    		  AigNUB21C41.PosReverseFiltree,
		  AigNUB21C41.PosNormaleFiltree,
                  AigNUB21D11.PosReverseFiltree,
    		      AigNUB21D11.PosNormaleFiltree,
		      BoolRestrictif,               (* Rouge Fix *)
		      BoolRestrictif,               (* AspectCroix *)
(* Variants Anticipes *)
                  pvNUB13tc.PtArret,
                  PtArrSpeNub13,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
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


(* variants troncon 5 *)

   ProcEmisSolTrain( te24s03t05.EmissionSensUp, (2*noBoucle5), 
                     LigneL05+ L0503+ TRONC*05,     

                  pvROD23Atc.PtArret,  
                  pvROD22tc.PtArret,
                  pvROD21tc.PtArret,
    		  pvNUB24Btc.PtArret,
		  BoolRestrictif,
		  BoolRestrictif,			
		  BoolRestrictif,
		  BoolRestrictif,
(* Variants Anticipes *)
                  pvNUB24Atc.PtArret,
                  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
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


(* variants troncon 6 *)

   ProcEmisSolTrain( te31s03t06.EmissionSensUp, (2*noBoucle6), 
                     LigneL05+ L0503+ TRONC*06,     

                  pvNUB24Atc.PtArret,   
                  PtArrSigNub24,
                  BoolRestrictif,                (* AspectCroix *)
                  PtArrCdvNub22,
                  pvNUB22sig.PtArret,
                  BoolRestrictif,                (* AspectCroix *)
                  AigNUB21C41.PosNormaleFiltree, (* tivcom *)
    		  AigNUB21C41.PosReverseFiltree,
		  AigNUB21C41.PosNormaleFiltree,
		  pvIRA23Btc.Entree,			
		  PtArr40ASig,
		  BoolRestrictif (* AspectCroix *),
                  AigNUB39B21B.PosReverseFiltree,
                  AigNUB39B21B.PosNormaleFiltree,
		  varIRA23Atc,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
		      BoolRestrictif,
                  BoolPermissif,
                  BaseSorVar + 150); 


(* variants troncon 7 *)

   ProcEmisSolTrain( te37s03t07.EmissionSensUp, (2*noBoucle7), 
                     LigneL05+ L0503+ TRONC*07,     

                  PtArrSigNub12,
                  BoolRestrictif,           (* AspectCroix *)
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
(* Variants Anticipes *)
    		  AigNUB21C41.PosReverseFiltree,
		  AigNUB21C41.PosNormaleFiltree,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
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
 
 

(* reception du secteur 02*)

   ProcReceptInterSecteur(trL0502, noBoucleira, LigneL05+ L0502+ TRONC*04,
                  pvIRA23Btc.Entree,
                  varIRA23Atc,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif, 
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
                  BoucleAmv1.PanneTrans,
		  V5,
                  V5, 
		  V6,
		  BaseEntVar + 1);

   ProcReceptInterSecteur(trL0504, noBoucleval, LigneL05+ L0504+ TRONC*01,

                  pvVAL10tc.Entree,
                  varVAL11tc,
                  varVAL12tc,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif, 
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
                  BoucleAmv2.PanneTrans,
                  V4,
                  V5, 
		  V6,
		  BaseEntVar + 6);

(* emission vers les secteurs adjacents *)

   ProcEmisInterSecteur (teL0502, noBoucleira, LigneL05+ L0503+ TRONC*01,
			noBoucleira,
                  pvNUB8Atc.PtArret,
                  pvNUB8Btc.PtArret,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif, 
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
		  pvNUB8Atc.CumulCdvAmont,
                  Boucle1.PanneTrans,
		  V4,
                  V5, 
		  V6,
		  BaseSorVar + 210);

   ProcEmisInterSecteur (teL0504, noBoucleval, LigneL05+ L0503+ TRONC*05,
			noBoucleval,
                  pvROD23Btc.PtArret,
                  pvROD23Atc.PtArret,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif, 
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
                  pvROD23Btc.CumulCdvAmont,
                  Boucle5.PanneTrans,
                  V4,
                  V5,
		  V6,
		  BaseSorVar + 240); 

END InSpecMessVar;

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

(* CONFIGURATION DES EMISSION DES INVARIANTS SECURITAIRES VOIE UP *************)

(* Tous les sens doivent etre a SensUp ; il n'y a pas de commutation *)
            
 (** Emission invariants vers secteur amont L0502 **)        
(* M= BA *) EmettreSegm(LigneL05+ L0503+ TRONC*01+ SEGM*00, noBoucleira, SensUp);
            EmettreSegm(LigneL05+ L0503+ TRONC*01+ SEGM*01, noBoucleira, SensUp); 

 (** Emission invariants vers secteur amont L0504 **)
   EmettreSegm(LigneL05+ L0503+ TRONC*05+ SEGM*00, noBoucleval, SensUp);

 (** Boucle 1 **)        
   EmettreSegm(LigneL05+ L0503+ TRONC*01+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL05+ L0503+ TRONC*01+ SEGM*01, noBoucle1, SensUp);
   EmettreSegm(LigneL05+ L0503+ TRONC*02+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL05+ L0503+ TRONC*02+ SEGM*01, noBoucle1, SensUp);
   EmettreSegm(LigneL05+ L0503+ TRONC*04+ SEGM*00, noBoucle1, SensUp);

 (** Boucle 2 **)        
   EmettreSegm(LigneL05+ L0503+ TRONC*02+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL05+ L0503+ TRONC*02+ SEGM*01, noBoucle2, SensUp);
   EmettreSegm(LigneL05+ L0503+ TRONC*02+ SEGM*02, noBoucle2, SensUp);
   EmettreSegm(LigneL05+ L0503+ TRONC*03+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL05+ L0503+ TRONC*07+ SEGM*00, noBoucle2, SensUp);

 (** Boucle 3 **)        
   EmettreSegm(LigneL05+ L0503+ TRONC*03+ SEGM*00, noBoucle3, SensUp);
   EmettreSegm(LigneL05+ L0504+ TRONC*01+ SEGM*00, noBoucle3, SensUp);

 (** Boucle 4 **)        
   EmettreSegm(LigneL05+ L0503+ TRONC*04+ SEGM*00, noBoucle4, SensUp);
   EmettreSegm(LigneL05+ L0503+ TRONC*04+ SEGM*01, noBoucle4, SensUp);
   EmettreSegm(LigneL05+ L0503+ TRONC*02+ SEGM*00, noBoucle4, SensUp);
   EmettreSegm(LigneL05+ L0503+ TRONC*02+ SEGM*02, noBoucle4, SensUp);
   EmettreSegm(LigneL05+ L0503+ TRONC*06+ SEGM*03, noBoucle4, SensUp);
   EmettreSegm(LigneL05+ L0503+ TRONC*06+ SEGM*01, noBoucle4, SensUp);

 (** Boucle 5 **)        
   EmettreSegm(LigneL05+ L0503+ TRONC*05+ SEGM*00, noBoucle5, SensUp);
   EmettreSegm(LigneL05+ L0503+ TRONC*06+ SEGM*00, noBoucle5, SensUp);
   EmettreSegm(LigneL05+ L0503+ TRONC*06+ SEGM*01, noBoucle5, SensUp);
   EmettreSegm(LigneL05+ L0503+ TRONC*06+ SEGM*02, noBoucle5, SensUp);
   EmettreSegm(LigneL05+ L0503+ TRONC*06+ SEGM*03, noBoucle5, SensUp);

 (** Boucle 6 **)        
   EmettreSegm(LigneL05+ L0503+ TRONC*06+ SEGM*00, noBoucle6, SensUp);
   EmettreSegm(LigneL05+ L0503+ TRONC*06+ SEGM*01, noBoucle6, SensUp);
   EmettreSegm(LigneL05+ L0503+ TRONC*06+ SEGM*02, noBoucle6, SensUp);
   EmettreSegm(LigneL05+ L0503+ TRONC*06+ SEGM*03, noBoucle6, SensUp);
   EmettreSegm(LigneL05+ L0503+ TRONC*04+ SEGM*00, noBoucle6, SensUp);
   EmettreSegm(LigneL05+ L0502+ TRONC*04+ SEGM*00, noBoucle6, SensUp);
   EmettreSegm(LigneL05+ L0502+ TRONC*04+ SEGM*01, noBoucle6, SensUp);

 (** Boucle 7 **)        
   EmettreSegm(LigneL05+ L0503+ TRONC*07+ SEGM*00, noBoucle7, SensUp);
   EmettreSegm(LigneL05+ L0503+ TRONC*06+ SEGM*01, noBoucle7, SensUp);
   EmettreSegm(LigneL05+ L0503+ TRONC*06+ SEGM*02, noBoucle7, SensUp);
   EmettreSegm(LigneL05+ L0503+ TRONC*06+ SEGM*03, noBoucle7, SensUp);


(* CONFIGURATION DES TRONCONS TSR *********************************)

   ConfigurerTroncon(Tronc0, LigneL05 + L0503 + TRONC*01, 1,1,1,1);  (* troncon 3-1 *)
   ConfigurerTroncon(Tronc1, LigneL05 + L0503 + TRONC*02, 1,1,1,1);  (* troncon 3-2 *)
   ConfigurerTroncon(Tronc2, LigneL05 + L0503 + TRONC*03, 1,1,1,1);  (* troncon 3-3 *)
   ConfigurerTroncon(Tronc3, LigneL05 + L0503 + TRONC*04, 1,1,1,1);  (* troncon 3-4 *)
   ConfigurerTroncon(Tronc4, LigneL05 + L0503 + TRONC*05, 1,1,1,1);  (* troncon 3-5 *)
   ConfigurerTroncon(Tronc5, LigneL05 + L0503 + TRONC*06, 1,1,1,1);  (* troncon 3-6 *)
   ConfigurerTroncon(Tronc6, LigneL05 + L0503 + TRONC*07, 1,1,1,1);  (* troncon 3-7 *)


(* EMISSION DES TSR SUR VOIE UP ***********************************************)

 (** Emission des TSR vers le secteur amont L0502 **)
(* M= BA *) EmettreTronc(LigneL05+ L0503+ TRONC*01, noBoucleira, SensUp);

 (** Emission des TSR vers le secteur amont L0504 **)
(*M= BA *)  EmettreTronc(LigneL05+ L0503+ TRONC*05, noBoucleval, SensUp);

 (** Emission des TSR sur les troncons du secteur courant **)       
   EmettreTronc(LigneL05+ L0503+ TRONC*01, noBoucle1, SensUp); (* troncon 3-1 *)
   EmettreTronc(LigneL05+ L0503+ TRONC*02, noBoucle1, SensUp); 
   EmettreTronc(LigneL05+ L0503+ TRONC*04, noBoucle1, SensUp); (* rajout 28/2 : fc *)

   EmettreTronc(LigneL05+ L0503+ TRONC*02, noBoucle2, SensUp); (* troncon 3-2 *)
   EmettreTronc(LigneL05+ L0503+ TRONC*03, noBoucle2, SensUp);
   EmettreTronc(LigneL05+ L0503+ TRONC*07, noBoucle2, SensUp);

   EmettreTronc(LigneL05+ L0503+ TRONC*03, noBoucle3, SensUp); (* troncon 3-3 *)
   EmettreTronc(LigneL05+ L0504+ TRONC*01, noBoucle3, SensUp);

   EmettreTronc(LigneL05+ L0503+ TRONC*04, noBoucle4, SensUp); (* troncon 3-4 *)
(* fc : modification des emissions de TSR : fiche d'avis 24 *)
   EmettreTronc(LigneL05+ L0503+ TRONC*02, noBoucle4, SensUp);
   EmettreTronc(LigneL05+ L0503+ TRONC*06, noBoucle4, SensUp);

   EmettreTronc(LigneL05+ L0503+ TRONC*05, noBoucle5, SensUp); (* troncon 3-5 *)
   EmettreTronc(LigneL05+ L0503+ TRONC*06, noBoucle5, SensUp);

   EmettreTronc(LigneL05+ L0503+ TRONC*06, noBoucle6, SensUp); (* troncon 3-6 *)
   EmettreTronc(LigneL05+ L0503+ TRONC*04, noBoucle6, SensUp);
   EmettreTronc(LigneL05+ L0502+ TRONC*04, noBoucle6, SensUp);

   EmettreTronc(LigneL05+ L0503+ TRONC*07, noBoucle7, SensUp); (* troncon 3-7 *)
   EmettreTronc(LigneL05+ L0503+ TRONC*06, noBoucle7, SensUp);
                                                                  
END InSpecMessInv ;
    

(* Saut de page *)
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
    StockAdres( ADR(varNUB21Ctc));
    StockAdres( ADR(pvNUB8Atc));
    StockAdres( ADR(pvNUB8Btc));
    StockAdres( ADR(pvNUB8sig));
    StockAdres( ADR(pvNUB9revtc));
    StockAdres( ADR(pvNUB9nortc));
    StockAdres( ADR(pvNUB40Bsig)); 
    StockAdres( ADR(pvNUB10sig));
    StockAdres( ADR(pvNUB11pointetc));
    StockAdres( ADR(pvNUB13tc));
    StockAdres( ADR(pvROD10Atc));
    StockAdres( ADR(pvROD10Btc));
    StockAdres( ADR(pvROD11tc));
    StockAdres( ADR(pvROD12tc));
    StockAdres( ADR(pvROD13tc));


    StockAdres( ADR(pvROD23Btc));
    StockAdres( ADR(pvROD23Atc));
    StockAdres( ADR(pvROD22tc));
    StockAdres( ADR(pvROD21tc));
    StockAdres( ADR(pvNUB24Btc));
    StockAdres( ADR(pvNUB24Atc));
    StockAdres( ADR(pvNUB22tc));
    StockAdres( ADR(pvNUB22sig));
    StockAdres( ADR(pvNUB21Cnortc));
    StockAdres( ADR(pvNUB21Crevtc));
    StockAdres( ADR(pvNUB40Asig));
    StockAdres( ADR(pvNUB39Brevtc));
    StockAdres( ADR(pvNUB39Bnortc));
    StockAdres( ADR(pvNUB21Apointetc));
    StockAdres( ADR(pvNUB21Anortc));
    StockAdres( ADR(pvNUB21Arevtc));
    StockAdres( ADR(pvNUB20tc));	

    StockAdres( ADR(trL0502));
    StockAdres( ADR(trL0504));

    StockAdres( ADR(AigNUB21C41));
    StockAdres( ADR(AigNUB39B21B));
    StockAdres( ADR(AigNUB21A9)); 
    StockAdres( ADR(AigNUB21D11));

    StockAdres( ADR(com1troncon1));
    StockAdres( ADR(com2troncon1));
    StockAdres( ADR(com3troncon1));
    StockAdres( ADR(com4troncon1));

    StockAdres( ADR(varsigNUB8kv));
    StockAdres( ADR(varsigNUB8kj));
    StockAdres( ADR(varsigNUB22kv));
    StockAdres( ADR(varsigNUB22kj));

    StockAdres( ADR(varIRA23Atc));
    StockAdres( ADR(pvIRA23Btc));
    StockAdres( ADR(pvVAL10tc));
    StockAdres( ADR(varVAL11tc));
    StockAdres( ADR(varVAL12tc));

    StockAdres( ADR(regNUB12tcsecu));

    StockAdres( ADR(SigNUB12));
    StockAdres( ADR(SigNUB24));
    StockAdres( ADR(CdvNUB13));
    StockAdres( ADR(Sp2NUB));

    StockAdres( ADR(PtArr40ASig));
    StockAdres( ADR(PtArrSigNub40B));
    StockAdres( ADR(PtArrSigNub12));
    StockAdres( ADR(PtArrSigNub24));
    StockAdres( ADR(PtArrSpeNub13));
    StockAdres( ADR(PtArrCdvNub22));

END StockerAdresse ;

(* Saut de page *)
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


(* Saut de page *)
(*----------------------------------------------------------------------------*)
PROCEDURE InitSpecific ;
(*----------------------------------------------------------------------------*)
(*
 * Fonction :
 * Cette procedure appelle : InitSpecDivers, InitSpecPv, InitSpecConfMess
 *                           InSpecMessVarUp et Dn, InSpecMessInvUp et Dn
 *
 * Condition d'appel : Appelee par Applicati a l'initialisation du logiciel
 *
 *)
(*----------------------------------------------------------------------------*)
BEGIN (* InitSpecific *)

                                            

(**** CONFIGURATION DES SINGULARITES DIVERSES ****)
   InitSpecDivers;

(**** CONFIGURATION DES PORTIONS DE VOIE ****)
   InitSpecPv;

(**** CONFIGURATION DES VOIES RETOUR ET VOIES D'EMISSION ****)
   InitSpecConfMess;

(**** CONFIGURATION DES MESSAGES DE VARIANTS SOL-TRAIN ET INTERSECTEUR ****)
   InSpecMessVar;

(**** CONFIGURATION DES MESSAGES D'INVARIANTS SOL-TRAIN ET INTERSECTEUR ***)
   InSpecMessInv;

(**** 	CONFIGURATION DES VARIABLES DU STANDARD NON UTILISEES *************)
   InitInutil;  

(****   Stockage des adresses *****)
   StockerAdresse ;

END InitSpecific;

(* Saut de page *)
(*----------------------------------------------------------------------------*)
PROCEDURE ExeSpecific ;
(*----------------------------------------------------------------------------*)
(*
 * Fonction :
 * Cette procedure Traite la reconfiguration CdV, les caracteristiques
 * commutable (Zone d'arret d'urgence, FOD...) et fait le chainage des
 * portions de voie.
 *
 * Condition d'appel : Appelee par Applicati a chaque cycle du logiciel
 *
 *)
(*----------------------------------------------------------------------------*)
VAR BoolTr, BoolTr1, BoolTr2 : BoolLD;

BEGIN (* ExeSpecific *)

(* Affectation des "constantes" utilisees dans la construction des messages emis 	*)
(* et recus sur les boucles de transmission continue et sur les liens intersecteur.	*)
(* Cette reaffectation est necessaire a chaque cycle pour la mise en securite.		*)
   AffectBoolC(Vrai, BoolPermissif)  ;
   AffectBoolC(Faux, BoolRestrictif) ;

(**** FILTRAGE DES AIGUILLES **************************************************)
(* regulation *)
   regNUB12tcfonc := (regNUB12tcsecu.F = Vrai.F); 

   FiltrerAiguille(AigNUB21C41, BaseExeAig ) ;
   FiltrerAiguille(AigNUB39B21B, BaseExeAig + 2) ;
   FiltrerAiguille(AigNUB21A9, BaseExeAig + 4) ;
   FiltrerAiguille(AigNUB21D11, BaseExeAig + 6) ;

(* Gerer les signaux avec 2 aspects permissifs *)

   OuDD(varsigNUB8kv, varsigNUB8kj, pvNUB8sig.Entree);

   OuDD(varsigNUB22kv, varsigNUB22kj, pvNUB22sig.Entree);


(* CHAINAGE DES PORTIONS DE VOIE  SUR  VOIE IMPAIRE ********************************)

   ChainerPortionVoie(pvROD13tc, pvVAL10tc, BaseExeChainage);
   ChainerPortionVoie(pvROD12tc, pvROD13tc, BaseExeChainage + 5);
   ChainerPortionVoie(pvROD11tc, pvROD12tc, BaseExeChainage + 10);
   ChainerPortionVoie(pvROD10Btc, pvROD11tc, BaseExeChainage + 15);
   ChainerPortionVoie(pvROD10Atc, pvROD10Btc, BaseExeChainage + 20);
   ChainerPortionVoie(pvNUB13tc, pvROD10Atc, BaseExeChainage + 25);
   ChainerPortionVoie(pvNUB11pointetc, pvNUB13tc, BaseExeChainage + 30);

   TraiterConvergence(pvNUB11pointetc,
                      pvNUB10sig,
                      pvNUB40Bsig,
                      AigNUB21D11, BaseExeChainage + 35);
(* on reste sur la voie 1 *)
   ChainerPortionVoie(pvNUB9nortc, pvNUB10sig, BaseExeChainage + 40);
(* on prend la voie P *)
   ChainerPortionVoie(pvNUB9revtc, pvNUB40Bsig, BaseExeChainage + 45);  

(* Voie 1 *)
   TraiterDivergence( pvNUB8sig,
                      pvNUB9nortc,
                      pvNUB9revtc,
                      AigNUB21A9, BaseExeChainage + 50);
   ChainerPortionVoie(pvNUB8Btc, pvNUB8sig, BaseExeChainage + 55);
   ChainerPortionVoie(pvNUB8Atc, pvNUB8Btc, BaseExeChainage + 60); 


(* CHAINAGE DES PORTIONS DE VOIE  SUR  VOIE PAIRE ********************************)
                
   ChainerPortionVoie(pvNUB21Apointetc, pvIRA23Btc, BaseExeChainage + 100);
   TraiterConvergence(pvNUB21Apointetc,
                     pvNUB21Anortc,
                     pvNUB39Bnortc,   
                     AigNUB21A9, BaseExeChainage + 105);

(* on vient de la voie 2 *)
   ChainerPortionVoie(pvNUB21Cnortc, pvNUB21Anortc, BaseExeChainage + 110); 

(* on vient de la voie P *)
   ChainerPortionVoie(pvNUB39Bnortc, pvNUB21Arevtc, BaseExeChainage + 115);
   TraiterDivergence(pvNUB40Asig,
		     pvNUB39Bnortc,
		     pvNUB39Brevtc,
		     AigNUB39B21B,
		     BaseExeChainage + 120);
   ChainerPortionVoie(pvNUB21Crevtc, pvNUB40Asig, BaseExeChainage + 125);

(* portion commune voie 2 *)
   TraiterDivergence(pvNUB22sig,
                     pvNUB21Cnortc,
                     pvNUB21Crevtc,
                     AigNUB21C41, BaseExeChainage + 130);
   ChainerPortionVoie(pvNUB22tc, pvNUB22sig, BaseExeChainage + 135);
   ChainerPortionVoie(pvNUB24Atc,pvNUB22tc,  BaseExeChainage + 140);
   ChainerPortionVoie(pvNUB24Btc, pvNUB24Atc, BaseExeChainage + 145);
   ChainerPortionVoie(pvROD21tc, pvNUB24Btc, BaseExeChainage + 150);
   ChainerPortionVoie(pvROD22tc, pvROD21tc, BaseExeChainage + 155);
   ChainerPortionVoie(pvROD23Atc, pvROD22tc, BaseExeChainage + 160);
   ChainerPortionVoie(pvROD23Btc, pvROD23Atc, BaseExeChainage + 165);


(* Equations des points d'arrets associe aux signaux *)

  (* Permissif si signal 40A et aig gauche *)
   EtDD( AigNUB39B21B.PosNormaleFiltree,   pvNUB40Asig.PtArret,  PtArr40ASig );

  (* Permissif si signal 40B jaune et aig 41 a droite *)
   EtDD( AigNUB21C41.PosReverseFiltree,  pvNUB40Bsig.PtArret, PtArrSigNub40B);

  (* SigNub12 *) 
   AffectBoolD( SigNUB12,                  PtArrSigNub12 );

  (* SigNub24 *) 
   AffectBoolD( SigNUB24,                  PtArrSigNub24 );

  (* ArrSpeNub13 *) 
   NonD(Sp2NUB,                BoolTr1);
   NonD(PtArrSigNub12,         BoolTr2);
   EtDD(BoolTr1,               BoolTr2,     PtArrSpeNub13);
   
  (* PtArrCdvNub22 *) 
   OuDD(varNUB21Ctc,               AigNUB21C41.PosReverseFiltree,     BoolTr1); 
   EtDD(BoolTr1,               pvNUB22tc.PtArret,     PtArrCdvNub22);
   
(*** lecture des entrees de regulation ***)
   LireEntreesRegul;

(* commutation des variants en fonction de la valeur de la position d'aiguille 21A9 *)

IF Tvrai (AigNUB21A9.PosNormaleFiltree) THEN
	AffectBoolD (pvNUB10sig.PtArret, com1troncon1);
	AffectBoolD (BoolRestrictif,    com2troncon1);
	AffectBoolD (pvNUB13tc.PtArret, com3troncon1);
	AffectBoolD (PtArrSpeNub13,     com4troncon1);
	FinBranche(1);  
   ELSE
	IF Tvrai (AigNUB21A9.PosReverseFiltree) THEN
		AffectBoolD (PtArrSigNub40B, com1troncon1);
		AffectBoolD (BoolRestrictif, com2troncon1);
		AffectBoolD (BoolRestrictif, com3troncon1);
		AffectBoolD (BoolRestrictif, com4troncon1);
		FinBranche(2);
	ELSE 
	  AffectBoolD (BoolRestrictif, com1troncon1);
	  AffectBoolD (BoolRestrictif, com2troncon1);
	  AffectBoolD (BoolRestrictif, com3troncon1);
	  AffectBoolD (BoolRestrictif, com4troncon1);
	  FinBranche(3);
	END;
END;
FinArbre(BaseExeSpecific);
                                                
END ExeSpecific;
END Specific.
