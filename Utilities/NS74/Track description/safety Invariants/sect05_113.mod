IMPLEMENTATION MODULE Specific;

(*$S- *)
(*$T- *)

(******************************************************************************
*   SANTIAGO - LIGNE 5 - Secteur 5
*  =============================
*  Version : SCCS 1.1.0
*  Date    : 10/01/1997
*  Auteur  : Marc Plywacz
*  FC : Version conforme au 25.8.1997
*
*  Version : 1.1.1
*  Date    : 2/2/1998
*  Auteur  : F. Chanier
*  Nature  : mise en place des appels a ConfigurerAmpli
******************************************************************************)
(*---------------------------------------------------------------------------*)
(* Version 1.1.2  =====================                                      *)
(* Version 1.3 DU SERVEUR SCCS =====================                         *)
(* Date :         06/10/1999                                                 *)
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
		       CarteCes1,  CarteCes2,  CarteCes3,
                       Intersecteur1, Intersecteur2 (* comprend le secteur adjacent fictif *),

                       Ampli11, Ampli12, Ampli13, Ampli14,
                       Ampli21, Ampli22, Ampli23, Ampli24, Ampli25, Ampli26, Ampli27,
                       Ampli31, Ampli32, Ampli33, Ampli34,
                       Ampli41, Ampli42, Ampli43, Ampli44, Ampli45, Ampli46, Ampli47, 

(* PROCEDURES *)       ConfigurerBoucle,
                       ConfigurerIntsecteur,
                       ConfigurerCES,
		       ConfigurerAmpli	;


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

    L0506  = 1024*06;    (* numero Secteur aval voie impaire decale de 2**10 *)

    L0505  = 1024*05;    (* numero Secteur local decale de 2**10 *)

    L0504  = 1024*04;    (* numero Secteur amont voie impaire decale de 2**10 *)

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
    noBoucleflo = 00;
    noBoucleval = 01;
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
                  Boucleflo, Boucleval, Bouclefi : TyBoucle;


(* DECLARATION DES SINGULARITES DU SECTEUR 05 : dans les deux sens confondus *)

(** portions de voie 1  - sens impair **)
    pvJOA11Atc,
    pvJOA11Btc,
    pvJOA12tc,
    pvJOA13tc,
    pvPED11Atc,
    pvPED11Btc,
    pvPED12tc,
    pvPED13tc            :TyPortionVoie;

(** portions de voie 2  - sens pair **)
    pvPED23Btc,
    pvPED23Atc,
    pvPED22tc,
    pvPED21tc,
    pvJOA23Btc,
    pvJOA23Atc,
    pvJOA22tc,
    pvJOA21tc            :TyPortionVoie;



(** Voie d'emission SOL-TRAIN : deux sens confondus**)
    te11s05t01,
    te14s05t02,
    te21s05t03,
    te24s05t04           :TyEmissionTele;
    	 			


(** Voie d'emission Inter-secteur deux voies confondues **)
    teL0506,
    teL0504,
    teL05fi	          :TyEmissionTele;

(** Voie de reception Inter-secteur deux voies confondues **)
    trL0506,
    trL0504,
    trL05fi               :TyCaracEntSec;
    	 

(* boucle en amont des deux voies *)
    BoucleAmv1,
    BoucleAmv2            :TyBoucle;

   V1, V2, V3, V4, V5, V6 :BOOLEAN;


(* DECLARATION DES SINGULARITES N'APPARTENANT PAS AU SECTEUR ********************)


(** 1ere portion de voie sur secteur 06 **)
    pvMIR11Atc	       : TyPortionVoie;

(** 1ere portion de voie sur secteur 04 **)
    pvCAM23Btc          : TyPortionVoie;
      

(** Variants Booleens recus du secteur 06 *)
    varMIR11Atc,
    varMIR11Btc         : BoolD;

(** Variants Booleens recus du secteur 04 *)
    varCAM23Btc,
    varCAM23Atc        : BoolD;






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
   ConfigurerAmpli(Ampli26, 2, 6, 195, 16, FALSE);     
   ConfigurerAmpli(Ampli27, 2, 7, 196, 16, TRUE);     
                                                    
   ConfigurerAmpli(Ampli31, 3, 1, 197, 21, FALSE);
   ConfigurerAmpli(Ampli32, 3, 2, 198, 22, FALSE);
   ConfigurerAmpli(Ampli33, 3, 3, 199, 22, FALSE);
   ConfigurerAmpli(Ampli34, 3, 4, 200, 22, TRUE);

   ConfigurerAmpli(Ampli41, 4, 1, 201, 24, FALSE);
   ConfigurerAmpli(Ampli42, 4, 2, 202, 25, FALSE);
   ConfigurerAmpli(Ampli43, 4, 3, 203, 25, FALSE);
   ConfigurerAmpli(Ampli44, 4, 4, 204, 25, TRUE);   
   ConfigurerAmpli(Ampli45, 4, 5, 205, 26, FALSE);
   ConfigurerAmpli(Ampli46, 4, 6, 206, 26, FALSE);
   ConfigurerAmpli(Ampli47, 4, 7, 207, 26, TRUE);
   
 (** cartes CES **)
   ConfigurerCES(CarteCes1, 01);
   ConfigurerCES(CarteCes2, 02);


(** Liaisons Inter-Secteur **)

   ConfigurerIntsecteur(Intersecteur1, 01, trL0506, trL0504);


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
   VoieProtegee(pvJOA11Atc, Rien, RienAmont, FALSE, Boucle1, Boucleval, 1); 
   VoieProtegee(pvJOA11Btc, Rien, RienAmont, FALSE, Boucle1, Boucleval, 2);      
   VoieProtegee(pvJOA12tc, Rien, RienAmont, FALSE, Boucle1, Boucleval, 3);
   VoieProtegee(pvJOA13tc, Rien, RienAmont, FALSE, Boucle1, Boucleval, 4);
   
(* points d'injection associes a la Boucle 2 *)
   VoieProtegee(pvPED11Atc, Rien, RienAmont, FALSE, Boucle2, Boucle1, 5);
   VoieProtegee(pvPED11Btc, Rien, RienAmont, FALSE, Boucle2, Boucle1, 6);
   VoieProtegee(pvPED12tc, Rien, RienAmont, FALSE, Boucle2, Boucle1, 7);
   VoieProtegee(pvPED13tc, Rien, RienAmont, FALSE, Boucle2, Boucle1, 8);

(* points d'injection associes a la Boucle 3 *)
   VoieProtegee(pvPED23Btc, Rien, RienAmont, FALSE, Boucle3, Boucleflo, 9);
   VoieProtegee(pvPED23Atc, Rien, RienAmont, FALSE, Boucle3, Boucleflo, 10);
   VoieProtegee(pvPED22tc, Rien, RienAmont, FALSE, Boucle3, Boucleflo, 11);
   VoieProtegee(pvPED21tc, Rien, RienAmont, FALSE, Boucle3, Boucleflo, 12);

(* points d'injection associes a la Boucle4 *)
   VoieProtegee(pvJOA23Btc, Rien, RienAmont, FALSE, Boucle4, Boucle3, 13);
   VoieProtegee(pvJOA23Atc, Rien, RienAmont, FALSE, Boucle4, Boucle3, 14);
   VoieProtegee(pvJOA22tc, Rien, RienAmont, FALSE, Boucle4, Boucle3, 15);
   VoieProtegee(pvJOA21tc, Rien, RienAmont, FALSE, Boucle4, Boucle3, 16);


   VoieLimitrophe(pvMIR11Atc);
   VoieLimitrophe(pvCAM23Btc);

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

   ConfigEmisTeleSolTrain ( te11s05t01,
                            noBoucle1,         
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);


   ConfigEmisTeleSolTrain ( te14s05t02,
                            noBoucle2,         
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);
   

     
   ConfigEmisTeleSolTrain ( te21s05t03,
                            noBoucle3,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);


   ConfigEmisTeleSolTrain ( te24s05t04,
                            noBoucle4,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);
 

(* CONFIGURATION POUR LA REGULATION *)
(* fc: modification pour insertion des parametres de la regulation le 3/7/1997 *)
   ConfigQuai (59, 64, pvJOA12tc.EntreeFonc, te11s05t01, 0, 3, 4,11,10, 13, 14, 15);
   ConfigQuai (59, 69, pvJOA22tc.EntreeFonc, te24s05t04, 0, 3, 4,11, 5, 13, 14, 15);
   ConfigQuai (60, 74, pvPED12tc.EntreeFonc, te14s05t02, 0, 4,11, 5,10, 13, 14, 15);
   ConfigQuai (60, 79, pvPED22tc.EntreeFonc, te21s05t03, 0, 3, 4,11,10, 13, 14, 15);

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
   ProcEmisSolTrain( te11s05t01.EmissionSensUp, (2*noBoucle1), 
                     LigneL05+ L0505+ TRONC*01,     

                  pvJOA11Btc.PtArret,
                  pvJOA12tc.PtArret,
                  pvJOA13tc.PtArret,
    		  pvPED11Atc.PtArret,
		  BoolRestrictif,
		  BoolRestrictif,		
		  BoolRestrictif,
		  BoolRestrictif,
(* Variants Anticipes *)
                  pvPED11Btc.PtArret,
                  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
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
   ProcEmisSolTrain( te14s05t02.EmissionSensUp, (2*noBoucle2), 
                     LigneL05+ L0505+ TRONC*02,     

                  pvPED11Btc.PtArret,
                  pvPED12tc.PtArret,
                  pvPED13tc.PtArret,
                  pvMIR11Atc.Entree,
                  BoolRestrictif,
		  BoolRestrictif,			
		  BoolRestrictif,
		  BoolRestrictif,
(* Variants Anticipes *)
                  varMIR11Btc,
                  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
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
   ProcEmisSolTrain( te21s05t03.EmissionSensUp, (2*noBoucle3), 
                     LigneL05+ L0505+ TRONC*03,     

                  pvPED23Atc.PtArret,
                  pvPED22tc.PtArret,
                  pvPED21tc.PtArret,
    		  pvJOA23Btc.PtArret,
		  BoolRestrictif,
		  BoolRestrictif,			
		  BoolRestrictif,
		  BoolRestrictif,
(* Variants Anticipes *)
                  pvJOA23Atc.PtArret,
                  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
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
   ProcEmisSolTrain( te24s05t04.EmissionSensUp, (2*noBoucle4), 
                     LigneL05+ L0505+ TRONC*04,     

                  pvJOA23Atc.PtArret,  
                  pvJOA22tc.PtArret,
                  pvJOA21tc.PtArret,
    		  pvCAM23Btc.Entree,
		  BoolRestrictif,
		  BoolRestrictif,			
		  BoolRestrictif,
		  BoolRestrictif,
(* Variants Anticipes *)
                  varCAM23Atc,
                  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
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



 
(* reception du secteur 06 -aval- *)

   ProcReceptInterSecteur(trL0506, noBoucleflo, LigneL05+ L0506+ TRONC*01,
                  pvMIR11Atc.Entree,
                  varMIR11Btc,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
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


(* reception du secteur 04 -amont- *)

   ProcReceptInterSecteur(trL0504, noBoucleval, LigneL05+ L0504+ TRONC*03,

                  pvCAM23Btc.Entree,
                  varCAM23Atc,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif, 
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


(* emission vers le secteur 06 -aval- *)

   ProcEmisInterSecteur (teL0506, noBoucleflo, LigneL05+ L0505+ TRONC*03,
			noBoucleflo,
                  pvPED23Btc.PtArret,
                  pvPED23Atc.PtArret,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif, 
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


(* emission vers le secteur 04 -amont- *)

   ProcEmisInterSecteur (teL0504, noBoucleval, LigneL05+ L0505+ TRONC*01,
			noBoucleval,
                  pvJOA11Atc.PtArret,
                  pvJOA11Btc.PtArret,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif, 
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
            
 (** Emission invariants vers secteur 06 aval L0506 **)
        
   EmettreSegm(LigneL05+ L0505+ TRONC*03+ SEGM*00, noBoucleflo, SensUp);
   EmettreSegm(LigneL05+ L0505+ TRONC*03+ SEGM*01, noBoucleflo, SensUp);
   EmettreSegm(LigneL05+ L0505+ TRONC*04+ SEGM*00, noBoucleflo, SensUp);

 (** Emission invariants vers secteur 04 amont L0504 **)

   EmettreSegm(LigneL05+ L0505+ TRONC*01+ SEGM*00, noBoucleval, SensUp);
   EmettreSegm(LigneL05+ L0505+ TRONC*02+ SEGM*00, noBoucleval, SensUp); 

 (** Boucle 1 **)        
   EmettreSegm(LigneL05+ L0505+ TRONC*01+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL05+ L0505+ TRONC*02+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL05+ L0505+ TRONC*02+ SEGM*01, noBoucle1, SensUp);

 (** Boucle 2 **)        
   EmettreSegm(LigneL05+ L0505+ TRONC*02+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL05+ L0505+ TRONC*02+ SEGM*01, noBoucle2, SensUp);
   EmettreSegm(LigneL05+ L0506+ TRONC*01+ SEGM*00, noBoucle2, SensUp);

 (** Boucle 3 **)        
   EmettreSegm(LigneL05+ L0505+ TRONC*03+ SEGM*00, noBoucle3, SensUp);
   EmettreSegm(LigneL05+ L0505+ TRONC*03+ SEGM*01, noBoucle3, SensUp);
   EmettreSegm(LigneL05+ L0505+ TRONC*04+ SEGM*00, noBoucle3, SensUp);
   EmettreSegm(LigneL05+ L0505+ TRONC*04+ SEGM*01, noBoucle3, SensUp);

 (** Boucle 4 **)        
   EmettreSegm(LigneL05+ L0505+ TRONC*04+ SEGM*00, noBoucle4, SensUp);
   EmettreSegm(LigneL05+ L0505+ TRONC*04+ SEGM*01, noBoucle4, SensUp);
   EmettreSegm(LigneL05+ L0504+ TRONC*03+ SEGM*00, noBoucle4, SensUp);
   
 

(* CONFIGURATION DES TRONCONS TSR *********************************)

   ConfigurerTroncon(Tronc0, LigneL05 + L0505 + TRONC*01, 1,1,1,1);  (* troncon 5-1 *)
   ConfigurerTroncon(Tronc1, LigneL05 + L0505 + TRONC*02, 1,1,1,1);  (* troncon 5-2 *)
   ConfigurerTroncon(Tronc2, LigneL05 + L0505 + TRONC*03, 1,1,1,1);  (* troncon 5-3 *)
   ConfigurerTroncon(Tronc3, LigneL05 + L0505 + TRONC*04, 1,1,1,1);  (* troncon 5-4 *)


(* EMISSION DES TSR SUR VOIE UP ***********************************************)

 (** Emission des TSR vers le secteur 06 -aval- L0506 **)

   EmettreTronc(LigneL05+ L0505+ TRONC*03, noBoucleflo, SensUp);
   EmettreTronc(LigneL05+ L0505+ TRONC*04, noBoucleflo, SensUp);

 (** Emission des TSR vers le secteur amont 04 L0504 **)

   EmettreTronc(LigneL05+ L0505+ TRONC*01, noBoucleval, SensUp);
   EmettreTronc(LigneL05+ L0505+ TRONC*02, noBoucleval, SensUp);


 (** Emission des TSR sur les troncons du secteur courant **)

   EmettreTronc(LigneL05+ L0505+ TRONC*01, noBoucle1, SensUp); (* troncon 5-1 *)
   EmettreTronc(LigneL05+ L0505+ TRONC*02, noBoucle1, SensUp);

   EmettreTronc(LigneL05+ L0505+ TRONC*02, noBoucle2, SensUp); (* troncon 5-2 *)
   EmettreTronc(LigneL05+ L0506+ TRONC*01, noBoucle2, SensUp);

   EmettreTronc(LigneL05+ L0505+ TRONC*03, noBoucle3, SensUp); (* troncon 5-3 *)
   EmettreTronc(LigneL05+ L0505+ TRONC*04, noBoucle3, SensUp);

   EmettreTronc(LigneL05+ L0505+ TRONC*04, noBoucle4, SensUp); (* troncon 5-4 *)
   EmettreTronc(LigneL05+ L0504+ TRONC*03, noBoucle4, SensUp);

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
    StockAdres( ADR(pvJOA11Atc));
    StockAdres( ADR(pvJOA11Btc));
    StockAdres( ADR(pvJOA12tc));
    StockAdres( ADR(pvJOA13tc));
    StockAdres( ADR(pvPED11Atc));
    StockAdres( ADR(pvPED11Btc));
    StockAdres( ADR(pvPED12tc));
    StockAdres( ADR(pvPED13tc));

    StockAdres( ADR(pvPED23Btc));
    StockAdres( ADR(pvPED23Atc));
    StockAdres( ADR(pvPED22tc));
    StockAdres( ADR(pvPED21tc));
    StockAdres( ADR(pvJOA23Btc));
    StockAdres( ADR(pvJOA23Atc));
    StockAdres( ADR(pvJOA22tc));
    StockAdres( ADR(pvJOA21tc));

    StockAdres( ADR(pvMIR11Atc));
    StockAdres( ADR(pvCAM23Btc));

    StockAdres( ADR(trL0506));
    StockAdres( ADR(trL0504));

    StockAdres( ADR(varMIR11Atc));
    StockAdres( ADR(varMIR11Btc));
    StockAdres( ADR(varCAM23Btc));
    StockAdres( ADR(varCAM23Atc));



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


(* CHAINAGE DES PORTIONS DE VOIE  SUR  VOIE 1 Sens IMPAIR ******************************)

   ChainerPortionVoie(pvPED13tc, pvMIR11Atc, BaseExeChainage);
   ChainerPortionVoie(pvPED12tc, pvPED13tc, BaseExeChainage + 5);
   ChainerPortionVoie(pvPED11Btc, pvPED12tc, BaseExeChainage + 10);
   ChainerPortionVoie(pvPED11Atc, pvPED11Btc, BaseExeChainage + 15);
   ChainerPortionVoie(pvJOA13tc, pvPED11Atc, BaseExeChainage + 20);
   ChainerPortionVoie(pvJOA12tc, pvJOA13tc, BaseExeChainage + 25);
   ChainerPortionVoie(pvJOA11Btc, pvJOA12tc, BaseExeChainage + 30);
   ChainerPortionVoie(pvJOA11Atc, pvJOA11Btc, BaseExeChainage + 35);

(* CHAINAGE DES PORTIONS DE VOIE  SUR  VOIE 2 Sens PAIR ********************************)
                
   ChainerPortionVoie(pvJOA21tc, pvCAM23Btc, BaseExeChainage + 100);
   ChainerPortionVoie(pvJOA22tc, pvJOA21tc, BaseExeChainage + 105);
   ChainerPortionVoie(pvJOA23Atc, pvJOA22tc, BaseExeChainage + 110);
   ChainerPortionVoie(pvJOA23Btc, pvJOA23Atc, BaseExeChainage + 115);
   ChainerPortionVoie(pvPED21tc, pvJOA23Btc, BaseExeChainage + 120);
   ChainerPortionVoie(pvPED22tc, pvPED21tc, BaseExeChainage + 125);
   ChainerPortionVoie(pvPED23Atc, pvPED22tc, BaseExeChainage + 130);
   ChainerPortionVoie(pvPED23Btc, pvPED23Atc, BaseExeChainage + 135);

(*** lecture des entrees de regulation ***)

   LireEntreesRegul;

END ExeSpecific;
END Specific.
