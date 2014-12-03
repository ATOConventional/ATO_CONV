IMPLEMENTATION MODULE Specific;

(*$S- *)
(*$T- *)

(******************************************************************************
*   SANTIAGO - LIGNE 5 - Secteur 4
*  =============================
*  Version : SCCS 1.1.0
*  Date    : 06/01/1997
*  Auteur  : Marc Plywacz
*  FC : Version du 25.8.1997       
*
*  Version : SCCS 1.1.1
*  Date    : 2/2/1998
*  Auteur  : F. Chanier
*  Nature  : mise en place de la detection des pannes d'ampli       
******************************************************************************)
(*---------------------------------------------------------------------------*)
(* Version 1.1.2  =====================                                      *)
(* Version 1.3 DU SERVEUR SCCS =====================                         *)
(* Date :         07/10/1999                                                 *)
(* Auteur:        H. Le Roy                                                  *)
(* Modification :  Adaptation de la configuration des amplis au standard     *)
(*                  1.3.3  Suppression d'importations, de declarations de    *)
(*                  constantes et variables, d'appels de fonctions  inutiles.*)
(*                  Suppression de code inutile concernant les DAMTC.        *)
(*---------------------------------------------------------------------------*)
(* Version 1.1.3  =====================                                      *)
(* Version 1.4 DU SERVEUR SCCS =====================                         *)
(* Date    :      24/05/2000                                                 *)
(* Auteur  :      D. MARTIN                                                  *)
(* Modification : Am 0165 : Ajustement des marches-types                     *)
(*                                                                           *)
(*****************************************************************************)

(******************************  IMPORTATIONS  ********************************)

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
		       Ampli21, Ampli22, Ampli23, Ampli24, Ampli25,          Ampli27,
		       Ampli31, Ampli32, Ampli33, Ampli34,
		       Ampli41, Ampli42, Ampli43, Ampli44,  

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

    L0505  = 1024*05;    (* numero Secteur aval voie impaire decale de 2**10 *)

    L0504  = 1024*04;    (* numero Secteur local decale de 2**10 *)

    L0503  = 1024*03;    (* numero Secteur amont voie impaire decale de 2**10 *)

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
    noBouclejoa = 00;
    noBouclenub = 01;
    noBouclefi = 02; (* boucle fictive *)
    noBoucle1 = 03;
    noBoucle2 = 04;
    noBoucle3 = 05;
    noBoucle4 = 06;


(** Base pour les tables de compensation **)
    BaseEntVar	= 500 	;
    BaseSorVar	= 600 	;
    BaseExeAig	= 1280	;
    BaseExeChainage = 1360 ;
    BaseExeSpecific = 1950 ;


(* DECLARATION DES VARIABLES GENERALES *)
 VAR
		       Bouclejoa, Bouclenub, Bouclefi : TyBoucle;


(* DECLARATION DES SINGULARITES DU SECTEUR 04 : dans les deux sens confondus *)

(** portions de voie 1  - sens impair **)
    pvVAL10tc,
    pvVAL11tc,
    pvVAL12tc,
    pvVAL13tc,
    pvCAM11Atc,
    pvCAM11Btc,
    pvCAM12tc,
    pvCAM13tc            :TyPortionVoie;

(** portions de voie 2  - sens pair **)
    pvCAM23Btc,
    pvCAM23Atc,
    pvCAM22tc,
    pvCAM21tc,
    pvVAL23tc,
    pvVAL22tc,
    pvVAL21tc            :TyPortionVoie;



(** Voie d'emission SOL-TRAIN : deux sens confondus**)
    te11s04t01,
    te14s04t02,
    te21s04t03,
    te24s04t04           :TyEmissionTele;
    	 			


(** Voie d'emission Inter-secteur deux voies confondues **)
    teL0505,
    teL0503,
    teL05fi	          :TyEmissionTele;

(** Voie de reception Inter-secteur deux voies confondues **)
    trL0505,
    trL0503,
    trL05fi               :TyCaracEntSec;
    	 


(* boucle en amont des deux voies *)
    BoucleAmv1,
    BoucleAmv2            :TyBoucle;

   V1, V2, V3, V4, V5, V6 :BOOLEAN;





(* DECLARATION DES SINGULARITES N'APPARTENANT PAS AU SECTEUR ********************)


(** 1ere portion de voie sur secteur 05 **)
    pvJOA11Atc	       : TyPortionVoie;

(** 1ere portion de voie sur secteur 03 **)
    pvROD23Btc          : TyPortionVoie;
      

(** Variants Booleens recus du secteur 05 *)
    varJOA11Atc,
    varJOA11Btc         : BoolD;

(** Variants Booleens recus du secteur 03 *)
    varROD23Btc,
    varROD23Atc        : BoolD;






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
(*   EntreeAiguille(AigNUB21C41, 17,18);
   EntreeAiguille(AigNUB39B21B, 20,21);
   EntreeAiguille(AigNUB21A9, 22,23);
   EntreeAiguille(AigNUB21D11, 25,26); *)

(* CONFIGURATION DES SIGNAUX *)
(*   ProcEntreeIntrins (15, varsigNUB22kv); 
   ProcEntreeIntrins (16, varsigNUB22kj);
   ProcEntreeIntrins (19, varsigNUB40Akv);
   ProcEntreeIntrins (24, varsigNUB40Bkv);
   ProcEntreeIntrins (29, varsigNUB8kv);
   ProcEntreeIntrins (30, varsigNUB8kj); *)


(* CONFIGURATION POUR LA MAINTENANCE de la transmission continue*)
   ConfigurerBoucle(Boucle1, 1);
   ConfigurerBoucle(Boucle2, 2);
   ConfigurerBoucle(Boucle2, 3);
   ConfigurerBoucle(Boucle4, 4);

   ConfigurerAmpli(Ampli11, 1, 1, 154, 11, FALSE);
   ConfigurerAmpli(Ampli12, 1, 2, 155, 12, FALSE);
   ConfigurerAmpli(Ampli13, 1, 3, 156, 12, FALSE);
   ConfigurerAmpli(Ampli14, 1, 4, 157, 12, TRUE); 

   ConfigurerAmpli(Ampli21, 2, 1, 158, 14, FALSE);
   ConfigurerAmpli(Ampli22, 2, 2, 159, 15, FALSE);
   ConfigurerAmpli(Ampli23, 2, 3, 192, 15, FALSE);   
   ConfigurerAmpli(Ampli24, 2, 4, 193, 15, TRUE);   
   ConfigurerAmpli(Ampli25, 2, 5, 194, 16, FALSE); 

   ConfigurerAmpli(Ampli27, 2, 7, 196, 16, TRUE); 

   ConfigurerAmpli(Ampli31, 3, 1, 197, 21, FALSE);
   ConfigurerAmpli(Ampli32, 3, 2, 198, 22, FALSE);
   ConfigurerAmpli(Ampli33, 3, 3, 199, 22, FALSE);   
   ConfigurerAmpli(Ampli34, 3, 4, 200, 22, TRUE);   

   ConfigurerAmpli(Ampli41, 4, 1, 201, 24, FALSE);
   ConfigurerAmpli(Ampli42, 4, 2, 202, 25, FALSE);
   ConfigurerAmpli(Ampli43, 4, 3, 203, 25, FALSE);   
   ConfigurerAmpli(Ampli44, 4, 4, 204, 25, TRUE);   
   
 (** cartes CES **)
   ConfigurerCES(CarteCes1, 01);
   ConfigurerCES(CarteCes2, 02);


(** Liaisons Inter-Secteur **)

   ConfigurerIntsecteur(Intersecteur1, 01, trL0505, trL0503);


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


(* CONFIGURATION DES PORTIONS DE VOIE SENS IMPAIR  ****************************)


(* points d'injection associes a la CEO011 *)

(* points d'injection associes a la Boucle 1 *)
   VoieProtegee(pvVAL10tc, Rien, RienAmont, FALSE, Boucle1, Bouclenub, 1); 
   VoieProtegee(pvVAL11tc, Rien, RienAmont, FALSE, Boucle1, Bouclenub, 2);      
   VoieProtegee(pvVAL12tc, Rien, RienAmont, FALSE, Boucle1, Bouclenub, 3);
   
(* points d'injection associes a la Boucle 2 *)
   VoieProtegee(pvVAL13tc, Rien, RienAmont, FALSE, Boucle2, Boucle1, 4);
   VoieProtegee(pvCAM11Atc, Rien, RienAmont, FALSE, Boucle2, Boucle1, 5);
   VoieProtegee(pvCAM11Btc, Rien, RienAmont, FALSE, Boucle2, Boucle1, 6);
   VoieProtegee(pvCAM12tc, Rien, RienAmont, FALSE, Boucle2, Boucle1, 7);
   VoieProtegee(pvCAM13tc, Rien, RienAmont, FALSE, Boucle2, Boucle1, 8);

(* points d'injection associes a la Boucle 3 *)
   VoieProtegee(pvCAM23Btc, Rien, RienAmont, FALSE, Boucle3, Bouclejoa, 9);
   VoieProtegee(pvCAM23Atc, Rien, RienAmont, FALSE, Boucle3, Bouclejoa, 10);
   VoieProtegee(pvCAM22tc, Rien, RienAmont, FALSE, Boucle3, Bouclejoa, 11);

(* points d'injection associes a la Boucle4 *)
   VoieProtegee(pvCAM21tc, Rien, RienAmont, FALSE, Boucle4, Boucle3, 12);
   VoieProtegee(pvVAL23tc, Rien, RienAmont, FALSE, Boucle4, Boucle3, 13);
   VoieProtegee(pvVAL22tc, Rien, RienAmont, FALSE, Boucle4, Boucle3, 14);
   VoieProtegee(pvVAL21tc, Rien, RienAmont, FALSE, Boucle4, Boucle3, 15);


   VoieLimitrophe(pvJOA11Atc);
   VoieLimitrophe(pvROD23Btc);

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

   ConfigEmisTeleSolTrain ( te11s04t01,
                            noBoucle1,         
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);


   ConfigEmisTeleSolTrain ( te14s04t02,
                            noBoucle2,         
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);
   

     
   ConfigEmisTeleSolTrain ( te21s04t03,
                            noBoucle3,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);


   ConfigEmisTeleSolTrain ( te24s04t04,
                            noBoucle4,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);
 

(* CONFIGURATION POUR LA REGULATION *)
   ConfigQuai (57, 64, pvVAL12tc.EntreeFonc, te11s04t01, 0, 4, 5, 6, 6, 13, 14, 15);
   ConfigQuai (57, 69, pvVAL22tc.EntreeFonc, te24s04t04, 0, 8, 9,11, 5, 13, 14, 15);
   ConfigQuai (58, 74, pvCAM12tc.EntreeFonc, te14s04t02, 0, 9, 4, 5,10, 13, 14, 15);
   ConfigQuai (58, 79, pvCAM22tc.EntreeFonc, te21s04t03, 0, 5,10, 6, 7, 13, 14, 15);

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

(* CONFIGURATION DES EMISSIONS DE VARIANTS SOL-TRAIN SUR VOIE *****************)



(* variants troncon 1 voie 1 --> si *)
   ProcEmisSolTrain( te11s04t01.EmissionSensUp, (2*noBoucle1), 
                     LigneL05+ L0504+ TRONC*01,     

                  pvVAL11tc.PtArret,
                  pvVAL12tc.PtArret,
                  pvVAL13tc.PtArret,
    		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,		
		  BoolRestrictif,
		  BoolRestrictif,
(* Variants Anticipes *)
                  pvCAM11Atc.PtArret,
                  pvCAM11Btc.PtArret,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
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
   ProcEmisSolTrain( te14s04t02.EmissionSensUp, (2*noBoucle2), 
                     LigneL05+ L0504+ TRONC*02,     

                  pvCAM11Atc.PtArret,
                  pvCAM11Btc.PtArret,
                  pvCAM12tc.PtArret,
                  pvCAM13tc.PtArret,
                  pvJOA11Atc.Entree,
		  BoolRestrictif,			
		  BoolRestrictif,
		  BoolRestrictif,
(* Variants Anticipes *)
                  varJOA11Btc,
                  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
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



	 
(* variants troncon 3 voie 2 <-- sp *)
   ProcEmisSolTrain( te21s04t03.EmissionSensUp, (2*noBoucle3), 
                     LigneL05+ L0504+ TRONC*03,     

                  pvCAM23Atc.PtArret,
                  pvCAM22tc.PtArret,
                  pvCAM21tc.PtArret,
    		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,			
		  BoolRestrictif,
		  BoolRestrictif,
(* Variants Anticipes *)
                  pvVAL23tc.PtArret,
                  pvVAL22tc.PtArret,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
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


(* variants du troncon 4 voie 2 <-- sp *)
   ProcEmisSolTrain( te24s04t04.EmissionSensUp, (2*noBoucle4), 
                     LigneL05+ L0504+ TRONC*04,     

                  pvVAL23tc.PtArret,  
                  pvVAL22tc.PtArret,
                  pvVAL21tc.PtArret,
    		  pvROD23Btc.Entree,
		  BoolRestrictif,
		  BoolRestrictif,			
		  BoolRestrictif,
		  BoolRestrictif,
(* Variants Anticipes *)
                  varROD23Atc,
                  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
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



 
(* reception du secteur 05 -aval- *)

   ProcReceptInterSecteur(trL0505, noBouclejoa, LigneL05+ L0505+ TRONC*01,
                  pvJOA11Atc.Entree,
                  varJOA11Btc,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif, 
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


(* reception du secteur 03 -amont- *)

   ProcReceptInterSecteur(trL0503, noBouclenub, LigneL05+ L0503+ TRONC*05,

                  pvROD23Btc.Entree,
                  varROD23Atc,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif, 
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


(* emission vers le secteur 05 -aval- *)

   ProcEmisInterSecteur (teL0505, noBouclejoa, LigneL05+ L0504+ TRONC*03,
			noBouclejoa,
                  pvCAM23Btc.PtArret,
                  pvCAM23Atc.PtArret,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif, 
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
                  Boucle3.PanneTrans,
		  V4,
                  V5, 
		  V6,
		  BaseSorVar + 180);


(* emission vers le secteur 03 -amont- *)

   ProcEmisInterSecteur (teL0503, noBouclenub, LigneL05+ L0504+ TRONC*01,
			noBouclenub,
                  pvVAL10tc.PtArret,
                  pvVAL11tc.PtArret,
                  pvVAL12tc.PtArret,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif, 
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
            
 (** Emission invariants vers secteur 05 aval L0505 **)
        
   EmettreSegm(LigneL05+ L0504+ TRONC*03+ SEGM*00, noBouclejoa, SensUp);
   EmettreSegm(LigneL05+ L0504+ TRONC*04+ SEGM*00, noBouclejoa, SensUp);

 (** Emission invariants vers secteur 03 amont L0503 **)

   EmettreSegm(LigneL05+ L0504+ TRONC*01+ SEGM*00, noBouclenub, SensUp);
(*   EmettreSegm(LigneL05+ L0504+ TRONC*02+ SEGM*00, noBouclenub, SensUp); *)




 (** Boucle 1 **)        
   EmettreSegm(LigneL05+ L0504+ TRONC*01+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL05+ L0504+ TRONC*02+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL05+ L0504+ TRONC*02+ SEGM*01, noBoucle1, SensUp);

 (** Boucle 2 **)        
   EmettreSegm(LigneL05+ L0504+ TRONC*02+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL05+ L0504+ TRONC*02+ SEGM*01, noBoucle2, SensUp);
   EmettreSegm(LigneL05+ L0505+ TRONC*01+ SEGM*00, noBoucle2, SensUp);

 (** Boucle 3 **)        
   EmettreSegm(LigneL05+ L0504+ TRONC*03+ SEGM*00, noBoucle3, SensUp);
   EmettreSegm(LigneL05+ L0504+ TRONC*04+ SEGM*00, noBoucle3, SensUp);

 (** Boucle 4 **)        
   EmettreSegm(LigneL05+ L0504+ TRONC*04+ SEGM*00, noBoucle4, SensUp);
   EmettreSegm(LigneL05+ L0503+ TRONC*05+ SEGM*00, noBoucle4, SensUp);
   
 

(* CONFIGURATION DES TRONCONS TSR *********************************)

   ConfigurerTroncon(Tronc0, LigneL05 + L0504 + TRONC*01, 1,1,1,1);  (* troncon 4-1 *)
   ConfigurerTroncon(Tronc1, LigneL05 + L0504 + TRONC*02, 1,1,1,1);  (* troncon 4-2 *)
   ConfigurerTroncon(Tronc2, LigneL05 + L0504 + TRONC*03, 1,1,1,1);  (* troncon 4-3 *)
   ConfigurerTroncon(Tronc3, LigneL05 + L0504 + TRONC*04, 1,1,1,1);  (* troncon 4-4 *)


(* EMISSION DES TSR SUR VOIE UP ***********************************************)

 (** Emission des TSR vers le secteur 05 -aval- L0505 **)

   EmettreTronc(LigneL05+ L0504+ TRONC*03, noBouclejoa, SensUp);
   EmettreTronc(LigneL05+ L0504+ TRONC*04, noBouclejoa, SensUp);

 (** Emission des TSR vers le secteur amont 03 L0503 **)

   EmettreTronc(LigneL05+ L0504+ TRONC*01, noBouclenub, SensUp);


 (** Emission des TSR sur les troncons du secteur courant **)

   EmettreTronc(LigneL05+ L0504+ TRONC*01, noBoucle1, SensUp); (* troncon 4-1 *)
   EmettreTronc(LigneL05+ L0504+ TRONC*02, noBoucle1, SensUp);

   EmettreTronc(LigneL05+ L0504+ TRONC*02, noBoucle2, SensUp); (* troncon 4-2 *)
   EmettreTronc(LigneL05+ L0505+ TRONC*01, noBoucle2, SensUp);

   EmettreTronc(LigneL05+ L0504+ TRONC*03, noBoucle3, SensUp); (* troncon 4-3 *)
   EmettreTronc(LigneL05+ L0504+ TRONC*04, noBoucle3, SensUp);

   EmettreTronc(LigneL05+ L0504+ TRONC*04, noBoucle4, SensUp); (* troncon 4-4 *)
   EmettreTronc(LigneL05+ L0503+ TRONC*05, noBoucle4, SensUp);

END InSpecMessInv ;
    


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
    StockAdres( ADR(pvVAL10tc));
    StockAdres( ADR(pvVAL11tc));
    StockAdres( ADR(pvVAL12tc));
    StockAdres( ADR(pvVAL13tc));
    StockAdres( ADR(pvCAM11Atc));
    StockAdres( ADR(pvCAM11Btc));
    StockAdres( ADR(pvCAM12tc));
    StockAdres( ADR(pvCAM13tc));

    StockAdres( ADR(pvCAM23Btc));
    StockAdres( ADR(pvCAM23Atc));
    StockAdres( ADR(pvCAM22tc));
    StockAdres( ADR(pvCAM21tc));
    StockAdres( ADR(pvVAL23tc));
    StockAdres( ADR(pvVAL22tc));
    StockAdres( ADR(pvVAL21tc));

    StockAdres( ADR(pvJOA11Atc));
    StockAdres( ADR(pvROD23Btc));

    StockAdres( ADR(trL0505));
    StockAdres( ADR(trL0503));

    StockAdres( ADR(varJOA11Atc));
    StockAdres( ADR(varJOA11Btc));
    StockAdres( ADR(varROD23Btc));
    StockAdres( ADR(varROD23Atc));



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


(* CHAINAGE DES PORTIONS DE VOIE  SUR  VOIE 1 Sens IMPAIRE ******************************)

   ChainerPortionVoie(pvCAM13tc, pvJOA11Atc, BaseExeChainage);
   ChainerPortionVoie(pvCAM12tc, pvCAM13tc, BaseExeChainage + 5);
   ChainerPortionVoie(pvCAM11Btc, pvCAM12tc, BaseExeChainage + 10);
   ChainerPortionVoie(pvCAM11Atc, pvCAM11Btc, BaseExeChainage + 15);
   ChainerPortionVoie(pvVAL13tc, pvCAM11Atc, BaseExeChainage + 20);
   ChainerPortionVoie(pvVAL12tc, pvVAL13tc, BaseExeChainage + 25);
   ChainerPortionVoie(pvVAL11tc, pvVAL12tc, BaseExeChainage + 30);
   ChainerPortionVoie(pvVAL10tc, pvVAL11tc, BaseExeChainage + 35);

(* CHAINAGE DES PORTIONS DE VOIE  SUR  VOIE 2 Sens PAIRE ********************************)
                
   ChainerPortionVoie(pvVAL21tc, pvROD23Btc, BaseExeChainage + 100);
   ChainerPortionVoie(pvVAL22tc, pvVAL21tc, BaseExeChainage + 105);
   ChainerPortionVoie(pvVAL23tc, pvVAL22tc, BaseExeChainage + 110);
   ChainerPortionVoie(pvCAM21tc, pvVAL23tc, BaseExeChainage + 115);
   ChainerPortionVoie(pvCAM22tc, pvCAM21tc, BaseExeChainage + 120);
   ChainerPortionVoie(pvCAM23Atc, pvCAM22tc, BaseExeChainage + 125);
   ChainerPortionVoie(pvCAM23Btc, pvCAM23Atc, BaseExeChainage + 130);

(*** lecture des entrees de regulation ***)

   LireEntreesRegul;

END ExeSpecific;
END Specific.
