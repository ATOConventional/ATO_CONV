IMPLEMENTATION MODULE Specific;

(*$S- *)
(*$T- *)

(******************************************************************************
*   SANTIAGO - LIGNE 5 - Secteur 2
*  =============================
*  Version : SCCS 1.1.0
*  Date    : 26/12/1996
*  Auteur  : Marc Plywacz
*  FC : conforme au 25.8.1997
******************************************************************************)

(*---------------------------------------------------------------------------*)
(* Modifications :                                                           *)
(* -------------                                                             *)
(*                                                                           *)
(* Version 1.1.1                                                             *)
(* Date : 30/10/1997, Auteur : P. Hog    ,  Origine : OM 34                  *)
(*  Modification de la procedure "InitSpecConfMess", correction des marches  *)
(*  types PA de la station IRARRAZAVAL voie 2.				     *)
(*									     *)
(* Version 1.1.2                                                             *)
(* Date : 2/2/1998, Auteur : F. Chanier ,  Origine : Eq. dev                 *)
(*  Mise en place de la detection des pannes d'ampli                         *)
(*									     *)
(*---------------------------------------------------------------------------*)
(* Version 1.1.3  =====================                                      *)
(* Version 1.4 DU SERVEUR SCCS =====================                         *)
(* Date :         07/10/1999                                                 *)
(* Auteur:        H. Le Roy                                                  *)
(* Modification :  Adaptation de la configuration des amplis au standard     *)
(*                  1.3.3  Suppression d'importations, de declarations de    *)
(*                  constantes et variables, d'appels de fonctions  inutiles.*)
(*                  Suppression de code inutile concernant les DAMTC.        *)
(*---------------------------------------------------------------------------*)
(* Version 1.1.4  =====================                                      *)
(* Version 1.5 DU SERVEUR SCCS =====================                         *)
(* Date    :      24/05/2000                                                 *)
(* Auteur  :      D. MARTIN                                                  *)
(* Modification : Am 0165 : Ajustement des marches-types                     *)
(*                                                                           *)
(*****************************  IMPORTATIONS  ********************************)

FROM SYSTEM     IMPORT ADR;

FROM Opel       IMPORT StockAdres, AffectBoolD, AffectBoolC, BoolC, BoolD, EtDD, CodeD,
		       EtatD, Tvrai, FinBranche, FinArbre, AffectC, AffectEtatC, OuDD;

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
                       Boucle1, Boucle2, Boucle3, Boucle4, Boucle5, Boucle6, BoucleFictive,
		       CarteCes1,  CarteCes2,  CarteCes3,  CarteCes4,
                       Intersecteur1, Intersecteur2 (* comprend le secteur adjacent fictif *),

		       Ampli11, Ampli12, Ampli13, Ampli14,
		       Ampli21, Ampli22, Ampli23, Ampli24,
		       Ampli41, Ampli42, Ampli43, Ampli44, Ampli45,          Ampli47,
		       Ampli51, Ampli52, Ampli53, Ampli54, Ampli55,          Ampli57,

(* PROCEDURES *)       ConfigurerBoucle,
                       ConfigurerIntsecteur,
                       ConfigurerCES,
		       ConfigurerAmpli;


FROM BibTsr      IMPORT
   (* VARIABLES *)
 Tronc0,  Tronc1,  Tronc2,  Tronc3 , Tronc4,  Tronc5,
 Tronc6,  Tronc7,  Tronc8,  Tronc9,  Tronc10, Tronc11,
 Tronc12, Tronc13, Tronc14, Tronc15,
   (* PROCEDURE *)
                       ConfigurerTroncon;


FROM ESbin     	 IMPORT 
			ProcEntreeIntrins;

(*****************************  CONSTANTES  ***********************************)

CONST

(** No ligne, No secteur, ....**)

(* supprime *)
    LigneL05 = 16384*00; (* numero de ligne decale de 2**14 *)

    L0503  = 1024*03;    (* numero Secteur aval voie impaire decale de 2**10 *)

    L0502  = 1024*02;    (* numero Secteur local decale de 2**10 *)

    L0501  = 1024*01;    (* numero Secteur amont voie impaire decale de 2**10 *)

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
    noBouclenub = 00;
    noBouclebaq = 01;
    noBouclefi = 02; (* boucle fictive *)
    noBoucle1 = 03;
    noBoucle2 = 04;
(*    noBoucle3 = 05; *)
    noBoucle4 = 06;
    noBoucle5 = 07;

(** Base pour les tables de compensation **)
    BaseEntVar	= 500 	;
    BaseSorVar	= 600 	;
    BaseExeAig	= 1280	;
    BaseExeChainage = 1360 ;
    BaseExeSpecific = 1950 ;


(* DECLARATION DES VARIABLES GENERALES *)
 VAR
		       Bouclenub, Bouclebaq, Bouclefi : TyBoucle;


(* DECLARATION DES SINGULARITES DU SECTEUR 02 : dans les deux sens confondus *)

(** portions de voie 1  - sens impair **)
    pvISA11tc,
    pvISA12tc,
    pvISA13tc,
    pvIRA11tc,
    pvIRA12tc,
    pvIRA13tc            : TyPortionVoie;

(** portions de voie 2  - sens pair **)
    pvIRA23Btc,
    pvIRA23Atc,
    pvIRA22tc,
    pvIRA21tc,
    pvISA23tc,
    pvISA22tc,
    pvISA21tc            : TyPortionVoie;



(** Voie d'emission SOL-TRAIN : deux sens confondus**)
    te11s02t01,
    te13s02t02,
    te23s02t04,
    te26s02t05           : TyEmissionTele;
    	 			


(** Voie d'emission Inter-secteur deux voies confondues **)
    teL0503,
    teL0501,
    teL05fi	          : TyEmissionTele;

(** Voie de reception Inter-secteur deux voies confondues **)
    trL0503,
    trL0501,
    trL05fi               : TyCaracEntSec;
    	 


(* boucle en amont des deux voies *)
    BoucleAmv1,
    BoucleAmv2            : TyBoucle;

   V1, V2, V3, V4, V5, V6 : BOOLEAN;


(* DECLARATION DES SINGULARITES N'APPARTENANT PAS AU SECTEUR ********************)

(** 1ere portion de voie sur secteur 03 **)
    pvNUB8Atc	       : TyPortionVoie;

(** 1ere portion de voie sur secteur 01 **)
    pvBUS23tc          : TyPortionVoie;
      

(** Variants Booleens recus du secteur 03 *)
    (* varNUB8Atc, *)
    varNUB8Btc         : BoolD;

(** Variants Booleens recus du secteur 01 *)
    (* varBUS23tc, *)
    varBUS22tc        : BoolD;



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

(* CONFIGURATIONS DIVERSES ****************************************************)

(* CONFIGURATION DES AIGUILLES, POUR LES DEUX VOIES *)
(*  aucune aiguille dans ce secteur  *)

(* CONFIGURATION DES SIGNAUX *)
(* aucun signal dans ce secteur *)


(* CONFIGURATION POUR LA MAINTENANCE de la transmission continue*)
   ConfigurerBoucle(Boucle1, 1);
   ConfigurerBoucle(Boucle2, 2);
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
                                                           
   ConfigurerAmpli(Ampli41, 4, 1, 194, 23, FALSE);
   ConfigurerAmpli(Ampli42, 4, 2, 195, 24, FALSE);
   ConfigurerAmpli(Ampli43, 4, 3, 196, 24, FALSE);
   ConfigurerAmpli(Ampli44, 4, 4, 197, 24, TRUE);
   ConfigurerAmpli(Ampli45, 4, 5, 198, 25, FALSE);

   ConfigurerAmpli(Ampli47, 4, 7, 200, 25, TRUE);
                                                            
   ConfigurerAmpli(Ampli51, 5, 1, 201, 26, FALSE);
   ConfigurerAmpli(Ampli52, 5, 2, 202, 27, FALSE);
   ConfigurerAmpli(Ampli53, 5, 3, 203, 27, FALSE);
   ConfigurerAmpli(Ampli54, 5, 4, 204, 27, TRUE);
   ConfigurerAmpli(Ampli55, 5, 5, 205, 28, FALSE);

   ConfigurerAmpli(Ampli57, 5, 7, 207, 28, TRUE);

 (** cartes CES **)
   ConfigurerCES(CarteCes1, 01);
   ConfigurerCES(CarteCes2, 02);

(** Liaisons Inter-Secteur **)

   ConfigurerIntsecteur(Intersecteur1, 01, trL0503, trL0501);

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


(* CONFIGURATION DES PORTIONS DE VOIE SUR LA VOIE  ****************************)

(* points d'injection associes a la CEO011 *)

(* points d'injection associes a la Boucle 1 *)
   VoieProtegee(pvISA11tc, Rien, RienAmont, FALSE, Boucle1, Bouclebaq, 1);      
   VoieProtegee(pvISA12tc, Rien, RienAmont, FALSE, Boucle1, Bouclebaq, 2);
   VoieProtegee(pvISA13tc, Rien, RienAmont, FALSE, Boucle1, Bouclebaq, 3);

(* points d'injection associes a la Boucle 2 *)
   VoieProtegee(pvIRA11tc, Rien, RienAmont, FALSE, Boucle2, Boucle1, 4);
   VoieProtegee(pvIRA12tc, Rien, RienAmont, FALSE, Boucle2, Boucle1, 5);
   VoieProtegee(pvIRA13tc, Rien, RienAmont, FALSE, Boucle2, Boucle1, 6);

(* points d'injection associes a la Boucle 4 *)
   VoieProtegee(pvIRA23Btc, Rien, RienAmont, FALSE, Boucle4, Bouclenub, 7);
   VoieProtegee(pvIRA23Atc, Rien, RienAmont, FALSE, Boucle4, Bouclenub, 8);
   VoieProtegee(pvIRA22tc, Rien, RienAmont, FALSE, Boucle4, Bouclenub, 9);

(* points d'injection associes a la Boucle5 *)
   VoieProtegee(pvIRA21tc, Rien, RienAmont, FALSE, Boucle5, Boucle4, 10);
   VoieProtegee(pvISA23tc, Rien, RienAmont, FALSE, Boucle5, Boucle4, 11);
   VoieProtegee(pvISA22tc, Rien, RienAmont, FALSE, Boucle5, Boucle4, 12);
   VoieProtegee(pvISA21tc, Rien, RienAmont, FALSE, Boucle5, Boucle4, 13);


   VoieLimitrophe(pvNUB8Atc);
   VoieLimitrophe(pvBUS23tc);

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

   ConfigEmisTeleSolTrain ( te11s02t01,
                            noBoucle1,         
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);


   ConfigEmisTeleSolTrain ( te13s02t02,
                            noBoucle2,         
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);
   

     
   ConfigEmisTeleSolTrain ( te23s02t04,
                            noBoucle4,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);


   ConfigEmisTeleSolTrain ( te26s02t05,
                            noBoucle5,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);
 

(* CONFIGURATION POUR LA REGULATION *)
(* FC : modif pour insertion des parametres de regul le 3/7/1997 *)
   ConfigQuai (53, 74, pvISA12tc.EntreeFonc, te11s02t01, 0, 3, 4, 5,10, 13, 14, 15);
   ConfigQuai (53, 79, pvISA22tc.EntreeFonc, te26s02t05, 0, 8, 9, 4, 5, 13, 14, 15);
   ConfigQuai (54, 64, pvIRA12tc.EntreeFonc, te13s02t02, 0, 2, 8, 9, 4, 13, 14, 15);
   ConfigQuai (54, 69, pvIRA22tc.EntreeFonc, te23s02t04, 0, 9,11, 5,10, 13, 14, 15);

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



(* variants troncon 1 voie 1 --> si *)
   ProcEmisSolTrain( te11s02t01.EmissionSensUp, (2*noBoucle1), 
                     LigneL05+ L0502+ TRONC*01,     

                  pvISA12tc.PtArret,
                  pvISA13tc.PtArret,
                  pvIRA11tc.PtArret,
    		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,		
		  BoolRestrictif,
		  BoolRestrictif,
(* Variants Anticipes *)
                  pvIRA12tc.PtArret,
                  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
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


(* variants troncon 2 voie 1 --> si  *)
   ProcEmisSolTrain( te13s02t02.EmissionSensUp, (2*noBoucle2), 
                     LigneL05+ L0502+ TRONC*02,     

                  pvIRA12tc.PtArret,
                  pvIRA13tc.PtArret,
                  pvNUB8Atc.PtArret,  (* entree *)
    		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,			
		  BoolRestrictif,
		  BoolRestrictif,
(* Variants Anticipes *)
                  varNUB8Btc,
                  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
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



	 
(* variants troncon 4 voie 2 <-- sp *)
   ProcEmisSolTrain( te23s02t04.EmissionSensUp, (2*noBoucle4), 
                     LigneL05+ L0502+ TRONC*04,     

                  pvIRA23Atc.PtArret,
                  pvIRA22tc.PtArret,
                  pvIRA21tc.PtArret,
    		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,			
		  BoolRestrictif,
		  BoolRestrictif,
(* Variants Anticipes *)
                  pvISA23tc.PtArret,
                  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
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


(* variants du troncon 5 voie 2 <-- sp *)
   ProcEmisSolTrain( te26s02t05.EmissionSensUp, (2*noBoucle5), 
                     LigneL05+ L0502+ TRONC*05,     

                  pvISA23tc.PtArret,  
                  pvISA22tc.PtArret,
                  pvISA21tc.PtArret,
    		  pvBUS23tc.PtArret,
		  BoolRestrictif,
		  BoolRestrictif,			
		  BoolRestrictif,
		  BoolRestrictif,
(* Variants Anticipes *)
                  varBUS22tc,
                  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
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



 
(* reception du secteur 03 -aval- *)

   ProcReceptInterSecteur(trL0503, noBouclenub, LigneL05+ L0503+ TRONC*01,
                  pvNUB8Atc.PtArret,
                  varNUB8Btc,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif, 
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


(* reception du secteur 01 -amont- *)

   ProcReceptInterSecteur(trL0501, noBouclebaq, LigneL05+ L0501+ TRONC*02,

                  pvBUS23tc.PtArret,
                  varBUS22tc,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif, 
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


(* emission vers le secteur 03 -aval- *)

   ProcEmisInterSecteur (teL0503, noBouclenub, LigneL05+ L0502+ TRONC*04,
			noBouclenub,
                  pvIRA23Btc.PtArret,
                  pvIRA23Atc.PtArret,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif, 
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
		  BaseSorVar + 180);


(* emission vers le secteur 01 -amont- *)

   ProcEmisInterSecteur (teL0501, noBouclebaq, LigneL05+ L0502+ TRONC*01,
			noBouclebaq,
                  pvISA11tc.PtArret,
                  pvISA12tc.PtArret,
                  pvISA13tc.PtArret,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif, 
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

(* CONFIGURATION DES EMISSION DES INVARIANTS SECURITAIRES ******* *************)

(* Tous les sens doivent etre a SensUp ; il n'y a pas de commutation *)
            
 (** Emission invariants vers secteur 03 aval L0503 **)
        
   EmettreSegm(LigneL05+ L0502+ TRONC*04+ SEGM*00, noBouclenub, SensUp);
   EmettreSegm(LigneL05+ L0502+ TRONC*04+ SEGM*01, noBouclenub, SensUp);

 (** Emission invariants vers secteur 01 amont L0501 **)

   EmettreSegm(LigneL05+ L0502+ TRONC*01+ SEGM*00, noBouclebaq, SensUp);
   EmettreSegm(LigneL05+ L0502+ TRONC*02+ SEGM*00, noBouclebaq, SensUp);

 (** Boucle 1 **)        
   EmettreSegm(LigneL05+ L0502+ TRONC*01+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL05+ L0502+ TRONC*02+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL05+ L0503+ TRONC*01+ SEGM*00, noBoucle1, SensUp);

 (** Boucle 2 **)        
   EmettreSegm(LigneL05+ L0502+ TRONC*02+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL05+ L0503+ TRONC*01+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL05+ L0503+ TRONC*01+ SEGM*01, noBoucle2, SensUp);

 (** Boucle 3 **)        
(*   EmettreSegm(LigneL05+ L0503+ TRONC*03+ SEGM*00, noBoucle3, SensUp); *)
(*   EmettreSegm(LigneL05+ L0503+ TRONC*04+ SEGM*00, noBoucle3, SensUp); *)

 (** Boucle 4 **)        
   EmettreSegm(LigneL05+ L0502+ TRONC*04+ SEGM*00, noBoucle4, SensUp);
   EmettreSegm(LigneL05+ L0502+ TRONC*04+ SEGM*01, noBoucle4, SensUp);
   EmettreSegm(LigneL05+ L0502+ TRONC*05+ SEGM*00, noBoucle4, SensUp);
   EmettreSegm(LigneL05+ L0502+ TRONC*05+ SEGM*01, noBoucle4, SensUp);

 (** Boucle 5 **)        
   EmettreSegm(LigneL05+ L0502+ TRONC*05+ SEGM*00, noBoucle5, SensUp);
   EmettreSegm(LigneL05+ L0502+ TRONC*05+ SEGM*01, noBoucle5, SensUp);
   EmettreSegm(LigneL05+ L0501+ TRONC*02+ SEGM*00, noBoucle5, SensUp);
   EmettreSegm(LigneL05+ L0501+ TRONC*02+ SEGM*01, noBoucle5, SensUp);


(* CONFIGURATION DES TRONCONS TSR *********************************)

   ConfigurerTroncon(Tronc0, LigneL05 + L0502 + TRONC*01, 1,1,1,1);  (* troncon 2-1 *)
   ConfigurerTroncon(Tronc1, LigneL05 + L0502 + TRONC*02, 1,1,1,1);  (* troncon 2-2 *)
(* attention, le troncon 3 n'existe pas *) 
   ConfigurerTroncon(Tronc2, LigneL05 + L0502 + TRONC*04, 1,1,1,1);  (* troncon 3-3 *)
   ConfigurerTroncon(Tronc3, LigneL05 + L0502 + TRONC*05, 1,1,1,1);  (* troncon 2-4 *)
(*   ConfigurerTroncon(Tronc4, LigneL05 + L0502 + TRONC*05, 1,1,1,1); *) (* troncon 2-5 *)


(* EMISSION DES TSR SUR VOIE UP ***********************************************)

 (** Emission des TSR vers le secteur 03 -aval- L0503 **)

   EmettreTronc(LigneL05+ L0502+ TRONC*04, noBouclenub, SensUp);

 (** Emission des TSR vers le secteur amont 01 L0501 **)

   EmettreTronc(LigneL05+ L0502+ TRONC*01, noBouclebaq, SensUp);
   EmettreTronc(LigneL05+ L0502+ TRONC*02, noBouclebaq, SensUp);


 (** Emission des TSR sur les troncons du secteur courant **)

   EmettreTronc(LigneL05+ L0502+ TRONC*01, noBoucle1, SensUp); (* troncon 2-1 *)
   EmettreTronc(LigneL05+ L0502+ TRONC*02, noBoucle1, SensUp);
   EmettreTronc(LigneL05+ L0503+ TRONC*01, noBoucle1, SensUp);

   EmettreTronc(LigneL05+ L0502+ TRONC*02, noBoucle2, SensUp); (* troncon 2-2 *)
   EmettreTronc(LigneL05+ L0503+ TRONC*01, noBoucle2, SensUp);

   EmettreTronc(LigneL05+ L0502+ TRONC*04, noBoucle4, SensUp); (* troncon 2-4 *)
   EmettreTronc(LigneL05+ L0502+ TRONC*05, noBoucle4, SensUp);

   EmettreTronc(LigneL05+ L0502+ TRONC*05, noBoucle5, SensUp); (* troncon 2-5 *)
   EmettreTronc(LigneL05+ L0501+ TRONC*02, noBoucle5, SensUp);

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
    StockAdres( ADR(pvISA11tc)); 
    StockAdres( ADR(pvISA12tc));
    StockAdres( ADR(pvISA13tc));
    StockAdres( ADR(pvIRA11tc));
    StockAdres( ADR(pvIRA12tc));
    StockAdres( ADR(pvIRA13tc));

    StockAdres( ADR(pvIRA23Btc));
    StockAdres( ADR(pvIRA23Atc));
    StockAdres( ADR(pvIRA22tc));
    StockAdres( ADR(pvIRA21tc));
    StockAdres( ADR(pvISA23tc));
    StockAdres( ADR(pvISA22tc));
    StockAdres( ADR(pvISA21tc));

    StockAdres( ADR(pvNUB8Atc));
    StockAdres( ADR(pvBUS23tc));

    StockAdres( ADR(trL0503));
    StockAdres( ADR(trL0501));

    StockAdres( ADR(varNUB8Btc));
    StockAdres( ADR(varBUS22tc));



END StockerAdresse ;

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
        ConfigurerTroncon(Tronc4,  0, 0,0,0,0) ;           
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
   InitInutil ;


(****   Stockage des adresses *****)
   StockerAdresse ;

END InitSpecific;


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
BEGIN (* ExeSpecific *)

(* Affectation des "constantes" utilisees dans la construction des messages emis 	*)
(* et recus sur les boucles de transmission continue et sur les liens intersecteur.	*)
(* Cette reaffectation est necessaire a chaque cycle pour la mise en securite.		*)
   AffectBoolC(Vrai, BoolPermissif)  ;
   AffectBoolC(Faux, BoolRestrictif) ;

(* CHAINAGE DES PORTIONS DE VOIE  SUR  VOIE 1 (S.IMPAIRE *******************************)

   ChainerPortionVoie(pvIRA13tc, pvNUB8Atc, BaseExeChainage);
   ChainerPortionVoie(pvIRA12tc, pvIRA13tc, BaseExeChainage + 5);
   ChainerPortionVoie(pvIRA11tc, pvIRA12tc, BaseExeChainage + 10);
   ChainerPortionVoie(pvISA13tc, pvIRA11tc, BaseExeChainage + 15);
   ChainerPortionVoie(pvISA12tc, pvISA13tc, BaseExeChainage + 20);
   ChainerPortionVoie(pvISA11tc, pvISA12tc, BaseExeChainage + 25);


(* CHAINAGE DES PORTIONS DE VOIE  SUR  VOIE 2 (S. PAIRE ********************************)
                
   ChainerPortionVoie(pvISA21tc, pvBUS23tc, BaseExeChainage + 100);
   ChainerPortionVoie(pvISA22tc, pvISA21tc, BaseExeChainage + 105);
   ChainerPortionVoie(pvISA23tc, pvISA22tc, BaseExeChainage + 110);
   ChainerPortionVoie(pvIRA21tc, pvISA23tc, BaseExeChainage + 115);
   ChainerPortionVoie(pvIRA22tc, pvIRA21tc, BaseExeChainage + 120);
   ChainerPortionVoie(pvIRA23Atc, pvIRA22tc, BaseExeChainage + 125);
   ChainerPortionVoie(pvIRA23Btc, pvIRA23Atc, BaseExeChainage + 130);

(*** lecture des entrees de regulation ***)

   LireEntreesRegul;

END ExeSpecific;
END Specific.
