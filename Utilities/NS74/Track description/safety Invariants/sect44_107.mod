IMPLEMENTATION MODULE Specific;

(*$S- *)
(*$T- *)

(******************************************************************************
*   SANTIAGO - LIGNE 5 - Secteur 44
*  =============================
*  Version : SCCS 1.0.0
*  Date    : 15/09/2009
*  Auteur  : Patrick Amsellem
*  Premiere Version
******************************************************************************)
(* Version 1.0.1  =====================                                      *)
(* Date :         19/01/2010                                                 *)
(* Auteur:        Patrick Amsellem                                           *)
(* Modification : ConfigQuai Del Sol remplacer 91 par 79 AM160281            *)
(* Modification : CONFIGURATION DES TRONCONS TSR 1 au lieu de 2 AM160284     *)
(* Modification : ajout PtArrCdvDS13 emission vers le secteur 45             *)
(*****************************************************************************)
(* Version  1.0.2  =====================                                     *)
(* Date :          05/10/2010                                                *)
(* Auteur :        M. Plywacz                                                *)
(* Modification : Ajout : dans tron 44_4    PtArrCdvDS22a & PtArrCdvDS22b    *)
(*---------------------------------------------------------------------------*)
(* Version  1.0.3  =====================                                     *)
(* Date :          13/10/2010                                                *)
(* Auteur :        M. Plywacz                                                *)
(* Modification : permutations noBoucle dans "ConfigEmisTeleSolTrain"        *)
(* Correction des noBoucle dans "EmettreSegm"  et "EmettreTronc"             *)
(*---------------------------------------------------------------------------*)
(* Version  1.0.4  =====================                                     *)
(* Date :          14/10/2010                                                *)
(* Auteur :        Ph. Hog                                                   *)
(* Modification : Correction noBoucle tronc 4 dans "ConfigEmisTeleSolTrain"  *)
(* Correction des noBoucle dans "EmettreSegm"  et "EmettreTronc"             *)
(*---------------------------------------------------------------------------*)
(* Version  1.0.5  =====================                                     *)
(* Date :          18/10/2010                                                *)
(* Auteur :        M. Plywacz                                                *)
(* Modification : Ajout : dans tron 44_4    PtArrCdvDS21                     *)
(*---------------------------------------------------------------------------*)
(* Version 1.0.6  =====================                                        *)
(* Date :         15/11/2010                                                   *)
(* Auteur:        Ph. Hog                                                      *)
(* Modification : Suppression des DamTc des ampli inutilisés.                  *)
(*******************************************************************************)
(* Version 1.0.7  =====================                                        *)
(* Date :         09/06/2011                                                   *)
(* Auteur:        I. ISSA                                                      *)
(* Modification : Marches types ConfigQuai                                     *)
(*******************************************************************************)

(*****************************  IMPORTATIONS  ********************************)

FROM SYSTEM     IMPORT ADR;

FROM Opel       IMPORT StockAdres, AffectBoolD, AffectBoolC, BoolC, BoolD, EtDD, CodeD,
		       Tvrai, FinBranche, FinArbre, AffectC, BoolLD, OuDD, NonD;

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

                  	Ampli11, Ampli12, Ampli13, Ampli14, Ampli15, Ampli16, Ampli17, 
                  	Ampli21, Ampli22, Ampli23, Ampli24, Ampli25, Ampli26, Ampli27, 
                  	Ampli31, Ampli32, Ampli33, Ampli34, Ampli35, Ampli36, Ampli37,
                  	Ampli41, Ampli42, Ampli43, Ampli44, Ampli45, Ampli46, Ampli47, Ampli48,Ampli49, Ampli4A,  
                  	

(* variables *)
                       Boucle1, Boucle2, Boucle3, Boucle4, Boucle5, BoucleFictive,
		       CarteCes1,  CarteCes2,  
                       Intersecteur1,

(* PROCEDURES *)       ConfigurerBoucle,
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

(*****************************  CONSTANTES  ***********************************)

CONST

(** No ligne, No secteur, ....**)


    LigneL05 = 16384*00; (* numero de ligne decale de 2**14 *)

    L0543  = 1024*43;     (* numero Secteur aval voie impaire decale de 2**10 *)

    L0544  = 1024*44;    (* numero Secteur local decale de 2**10 *)

    L0545  = 1024*45;    (* numero Secteur amont voie impaire decale de 2**10 *)

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

(** No des stations du secteur 44 **)
(* ligne 1: 1,2 ; ligne 2: 3,4; ligne 5: 5,6 *)
   (* noDSv1 = 5*32 + 1;*)
   (* noDSv2 = 6*32 + 13;*)
   (* noMTv1 = 5*32 + 2;*)
   (* noMTv2 = 6*32 + 12;*)
   

(** indication de sens **)
    SensUp = TRUE;

(** No de Voie d'emissions SOL-Train, d'emission/reception inter-secteur **)
    noBoucleLaP = 00; 
    noBouclePlM = 01;
    noBouclefi = 02; (* boucle fictive *)
    noBoucle1 = 03;
    noBoucle2 = 04;
    noBoucle3 = 05;

    noBoucle5 = 07;
    

(* numero de version *)
    (* noVersion = 01; *)

(** Base pour les tables de compensation **)
    BaseEntVar	= 500 	;
    BaseSorVar	= 600 	;
    BaseExeAig	= 1280	;
    BaseExeChainage = 1360 ;
    BaseExeSpecific = 1950 ;

TYPE
 TyAigNonLue = RECORD  (* Structure de donnees associee a une aiguille dont *
                        * l'etat n'est pas lu sur des entrees de carte CES  *
                        * (aiguille fictive ou anticipee)                   *)
                  PosNormale  : BoolD ;   (* position normale calculee *)
                  PosDeviee   : BoolD ;   (* position deviee calculee  *)
                END;


(***************** DECLARATION DES VARIABLES GENERALES ***********)
 VAR
                  Boucleheb : TyBoucle;

(* DECLARATION DES SINGULARITES DU SECTEUR 44 : dans les deux sens confondus *)

(* Declaration des variables correspondant a des entrees securitaires  *)
(*   - CDV et signaux                                                  *)
    CdvDS11,      (* entree  1, soit entree 0 de CES 02  *)
    CdvDS12,      (* entree  2, soit entree 1 de CES 02  *)
    CdvDS13,      (* entree  3, soit entree 2 de CES 02  *)
    CdvDS20,      (* entree  4, soit entree 3 de CES 02  *)
    CdvDS21,      (* entree  5, soit entree 4 de CES 02  *)
    CdvDS22b,     (* entree  6, soit entree 5 de CES 02  *)
    CdvDS22a,     (* entree  7, soit entree 6 de CES 02  *)
    CdvDS23,      (* entree  8, soit entree 7 de CES 02  *)

    
    CdvMT10,      (* entree 9, soit entree 0 de CES 03  *)
    CdvMT11,      (* entree 10, soit entree 1 de CES 03  *)
    CdvMT12,      (* entree 11, soit entree 2 de CES 03  *)
    CdvMT13,      (* entree 12, soit entree 3 de CES 03  *)
    CdvMT20,      (* entree 13, soit entree 4 de CES 03  *)
    CdvMT21,      (* entree 14, soit entree 5 de CES 03  *)
    CdvMT22,      (* entree 15, soit entree 6 de CES 03  *)
    CdvMT23       (* entree 16, soit entree 7 de CES 03  *)

    
             : BoolD;

(*   - aiguilles                                                        *)
             (* pas d'aiguille *)


(* Variables ne correspondant pas a une entree securitaire *)
(* Point d'arret *)

    
    PtArrCdvDS11,
    PtArrCdvDS12,
    PtArrCdvDS13,
    PtArrCdvDS20,
    PtArrCdvDS21,
    PtArrCdvDS22a,
    PtArrCdvDS22b,

    PtArrCdvDS23,
    PtArrCdvMT10,
    PtArrCdvMT11,
    PtArrCdvMT12,
    PtArrCdvMT13,

    PtArrCdvMT20,
    PtArrCdvMT21,
    PtArrCdvMT22,
    PtArrCdvMT23 : BoolD;


 (* Tiv Com *)
    (* pas de Tiv Com  *)
    
(* Variants anticipes *)
    PtAntCdvLP10,
    PtAntSigLP10,
    PtAntSpeLP12,

    PtAntCdvSAB23,
    PtAntCdvSAB22,
    PtAntCdvSAB21,
    PtAntCdvPLM09    : BoolD;

    
(* Copie des entrees dans des variables fonctionnelles pour la regulation *)
    CdvDS12Fonc,
    CdvDS22Fonc,
    CdvMT12Fonc,
    CdvMT22Fonc            : BOOLEAN;

(** Voie d'emission SOL-TRAIN : deux sens confondus**)
    te11s44t01,
    te21s44t02,
    te14s44t03,
    te24s44t04           :TyEmissionTele;

(** Voie d'emission Inter-secteur deux voies confondues **)
    teL0543,
    teL0545,
    teL05fi	          :TyEmissionTele;

(** Voie de reception Inter-secteur deux voies confondues **)
    trL0543,
    trL0545,
    trL05fi               :TyCaracEntSec;

(* boucle en amont des deux voies *)
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

DeclarerVersionSpecific (21);


(* CONFIGURATIONS DIVERSES ****************************************************)

(* CONFIGURATION DES AIGUILLES, POUR LES DEUX VOIES *)
    (* pas d'aiguille *)

(* Configuration des entrees *)
    ProcEntreeIntrins(  1, CdvDS11);
    ProcEntreeIntrins(  2, CdvDS12);
    ProcEntreeIntrins(  3, CdvDS13);
    ProcEntreeIntrins(  4, CdvDS20);
    ProcEntreeIntrins(  5, CdvDS21);
    ProcEntreeIntrins(  6, CdvDS22b);
    ProcEntreeIntrins(  7, CdvDS22a);
    ProcEntreeIntrins(  8, CdvDS23);

    ProcEntreeIntrins(  9, CdvMT10);
    ProcEntreeIntrins( 10, CdvMT11);
    ProcEntreeIntrins( 11, CdvMT12);
    ProcEntreeIntrins( 12, CdvMT13);
    ProcEntreeIntrins( 13, CdvMT20);
    ProcEntreeIntrins( 14, CdvMT21);
    ProcEntreeIntrins( 15, CdvMT22);
    ProcEntreeIntrins( 16, CdvMT23);
    

    
(* CONFIGURATION POUR LA MAINTENANCE de la transmission continue *)
   ConfigurerBoucle(Boucle1, 1);
   ConfigurerBoucle(Boucle2, 2);
   ConfigurerBoucle(Boucle3, 3);

   ConfigurerBoucle(Boucle5, 4);
   

(* PTC 1 *)
   ConfigurerAmpli(Ampli11, 1, 1, 154, 11, FALSE);
   ConfigurerAmpli(Ampli12, 1, 2, 155, 12, FALSE);
   ConfigurerAmpli(Ampli13, 1, 3, 156, 12, FALSE);
   ConfigurerAmpli(Ampli14, 1, 4, 157, 12, TRUE);
   (* ConfigurerAmpli(Ampli15, 1, 5, 158, 13, FALSE); *)
   (* ConfigurerAmpli(Ampli16, 1, 6, 159, 13, FALSE); *)
   (* ConfigurerAmpli(Ampli17, 1, 7, 192, 13, TRUE);  *)

   ConfigurerAmpli(Ampli31, 3, 1, 193, 14, FALSE);
   ConfigurerAmpli(Ampli32, 3, 2, 194, 15, FALSE);
   ConfigurerAmpli(Ampli33, 3, 3, 195, 15, FALSE);
   ConfigurerAmpli(Ampli34, 3, 4, 196, 15, TRUE);
   ConfigurerAmpli(Ampli35, 3, 5, 197, 16, FALSE);
   (* ConfigurerAmpli(Ampli36, 3, 6, 198, 16, FALSE); *)
   ConfigurerAmpli(Ampli37, 3, 7, 199, 16, TRUE);

(* PTC 2 *)
   ConfigurerAmpli(Ampli21, 2, 1, 200, 21, FALSE);
   ConfigurerAmpli(Ampli22, 2, 2, 201, 22, FALSE);
   ConfigurerAmpli(Ampli23, 2, 3, 202, 22, FALSE);
   ConfigurerAmpli(Ampli24, 2, 4, 203, 22, TRUE);
   ConfigurerAmpli(Ampli25, 2, 5, 204, 23, FALSE);
   ConfigurerAmpli(Ampli26, 2, 6, 205, 23, FALSE);
   ConfigurerAmpli(Ampli27, 2, 7, 206, 23, TRUE);

   ConfigurerAmpli(Ampli41, 4, 1, 207, 24, FALSE);
   ConfigurerAmpli(Ampli42, 4, 2, 208, 25, FALSE);
   ConfigurerAmpli(Ampli43, 4, 3, 209, 25, FALSE);
   ConfigurerAmpli(Ampli44, 4, 4, 210, 25, TRUE);
   ConfigurerAmpli(Ampli45, 4, 5, 211, 26, FALSE);
   ConfigurerAmpli(Ampli46, 4, 6, 212, 26, FALSE);
   ConfigurerAmpli(Ampli47, 4, 7, 213, 26, TRUE);
   (* ConfigurerAmpli(Ampli48, 4, 8, 214, 27, FALSE); *)
   (* ConfigurerAmpli(Ampli49, 4, 9, 215, 27, FALSE); *)
   (* ConfigurerAmpli(Ampli4A, 4, 10, 216, 27, TRUE); *)

 (** cartes CES **)
   ConfigurerCES(CarteCes1, 01);
   ConfigurerCES(CarteCes2, 02);
   

(** Liaisons Inter-Secteur **)

   ConfigurerIntsecteur(Intersecteur1, 01, trL0543, trL0545);

(* Initialisations des variables ne correspondant pas a des entrees secu *)
(* Point d'arret *)

    AffectBoolD( BoolRestrictif, PtArrCdvDS11);
    AffectBoolD( BoolRestrictif, PtArrCdvDS12);
    AffectBoolD( BoolRestrictif, PtArrCdvDS13);
    AffectBoolD( BoolRestrictif, PtArrCdvDS20);
    AffectBoolD( BoolRestrictif, PtArrCdvDS21);
    AffectBoolD( BoolRestrictif, PtArrCdvDS22a);
    AffectBoolD( BoolRestrictif, PtArrCdvDS22b);
    AffectBoolD( BoolRestrictif, PtArrCdvDS23);
    AffectBoolD( BoolRestrictif, PtArrCdvMT10);
    AffectBoolD( BoolRestrictif, PtArrCdvMT11);
    AffectBoolD( BoolRestrictif, PtArrCdvMT12);
    AffectBoolD( BoolRestrictif, PtArrCdvMT13);
    AffectBoolD( BoolRestrictif, PtArrCdvMT20);
    AffectBoolD( BoolRestrictif, PtArrCdvMT21);
    AffectBoolD( BoolRestrictif, PtArrCdvMT22);
    AffectBoolD( BoolRestrictif, PtArrCdvMT23);
    

    

(* Variants anticipes *)
    
    AffectBoolD( BoolRestrictif, PtAntCdvLP10);
    AffectBoolD( BoolRestrictif, PtAntSigLP10);
    AffectBoolD( BoolRestrictif, PtAntSpeLP12);

    AffectBoolD( BoolRestrictif, PtAntCdvSAB23);
    AffectBoolD( BoolRestrictif, PtAntCdvSAB22);
    AffectBoolD( BoolRestrictif, PtAntCdvSAB21);
    AffectBoolD( BoolRestrictif, PtAntCdvPLM09);

        
(* Regulation *)
    CdvDS12Fonc := FALSE;
    CdvDS22Fonc := FALSE;
    CdvMT12Fonc := FALSE;
    CdvMT22Fonc := FALSE;
    
            
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
         
(********************* CONFIGURATION DES VOIES D'EMISSION *********************)

  
   ConfigEmisTeleSolTrain ( te11s44t01,
                            noBoucle1,         
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te21s44t02,
                            noBoucle3,         
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);
       
   ConfigEmisTeleSolTrain ( te14s44t03,
                            noBoucle2,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te24s44t04,
                            noBoucle5,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);
 
   

(* CONFIGURATION POUR LA REGULATION *)

   ConfigQuai (79, 64, CdvDS12Fonc, te11s44t01, 0, 8, 9, 11, 5, 13, 14, 15);
   ConfigQuai (79, 69, CdvDS22Fonc, te24s44t04, 0, 8, 9, 11, 5, 13, 14, 15);

   ConfigQuai (78, 74, CdvMT12Fonc, te14s44t03, 0, 9, 11, 5, 6, 13, 14, 15);
   ConfigQuai (78, 79, CdvMT22Fonc, te21s44t02, 0, 8, 3, 4, 11, 13, 14, 15);

   

END InitSpecConfMess;
(* *)
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

(************** CONFIGURATION DES EMISSIONS DE VARIANTS SOL-TRAIN *************)



(* variants troncon 1   voies 1 --> si *)
   ProcEmisSolTrain( te11s44t01.EmissionSensUp, (2*noBoucle1), 
                     LigneL05+ L0544+ TRONC*01,     

                  PtArrCdvDS12,
                  PtArrCdvDS13,             
                  PtArrCdvMT10,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
		  BoolRestrictif,
(* Variants Anticipes *)
                  PtArrCdvMT11,
		  PtArrCdvMT12,
		  PtArrCdvMT13,
		  BoolRestrictif,
		  BoolRestrictif,
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

(* variants troncon 2   voie 2 --> sp  *)
   ProcEmisSolTrain( te21s44t02.EmissionSensUp, (2*noBoucle3), 
                     LigneL05+ L0544+ TRONC*02,     

                  PtArrCdvMT22,
                  PtArrCdvMT21,
                  PtArrCdvMT20,
                  PtArrCdvDS23,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
	      (* Variants Anticipes *)
                  PtArrCdvDS22b,
                  PtArrCdvDS22a,               
                  PtArrCdvDS21,                  
                  PtArrCdvDS20,
                  BoolRestrictif,
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


(* variants troncon 3    voie 1  si  *)
   ProcEmisSolTrain( te14s44t03.EmissionSensUp, (2*noBoucle2), 
                     LigneL05+ L0544+ TRONC*03,     

                  PtArrCdvMT11,
                  PtArrCdvMT12,
                  PtArrCdvMT13,
                  PtAntCdvLP10,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif, 
                  BoolRestrictif,                     
(* Variants Anticipes *)
                  PtAntSigLP10,
                  BoolRestrictif,             (* aspect croix *)
                  PtAntSpeLP12,
                  BoolRestrictif,
                  BoolRestrictif,
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

(* variants troncon 4  voie 2 <-- sp *)
   ProcEmisSolTrain( te24s44t04.EmissionSensUp, (2*noBoucle5), 
                     LigneL05+ L0544+ TRONC*04,     

                  PtArrCdvDS22b,
                  PtArrCdvDS22a,               
                  PtArrCdvDS21,                  
                  PtArrCdvDS20,
                  PtAntCdvSAB23,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
(* Variants Anticipes *)
                  PtAntCdvSAB22,
                  PtAntCdvSAB21,
                  PtAntCdvPLM09,                  
                  BoolRestrictif,
                  BoolRestrictif,
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






(* emission vers le secteur 43 -aval- LAS PARCELAS *)

   ProcEmisInterSecteur (teL0543, noBoucleLaP, LigneL05+ L0544+ TRONC*02,

			noBoucleLaP,
                  PtArrCdvMT23,
                  PtArrCdvMT22,
                  PtArrCdvMT21,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif, 
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
		  BaseSorVar + 120);


(* emission vers le secteur 45 -amont- PLAZA DE MAIPU *)

   ProcEmisInterSecteur (teL0545, noBouclePlM, LigneL05+ L0544+ TRONC*01,

			noBouclePlM,
                  PtArrCdvDS11,
                  PtArrCdvDS12,
                  PtArrCdvDS13,            
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
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
		  BaseSorVar + 150);



(* reception du secteur 43 -aval- *)

    ProcReceptInterSecteur(trL0543, noBoucleLaP, LigneL05+ L0543+ TRONC*01,

                  PtAntCdvLP10,
                  PtAntSigLP10,
                  PtAntSpeLP12,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif, 
                  BoolRestrictif,
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


(* reception du secteur 45 -amont- PLAZA MAIPU *)

   ProcReceptInterSecteur(trL0545, noBouclePlM, LigneL05+ L0545+ TRONC*02,

                  PtAntCdvSAB23,
                  PtAntCdvSAB22,
                  PtAntCdvSAB21,
                  PtAntCdvPLM09,   
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif, 
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

(*********** CONFIGURATION DES EMISSION DES INVARIANTS SECURITAIRES ***********)

(* Tous les sens doivent etre a SensUp ; il n'y a pas de commutation *)
            

 (** Emission invariants vers secteur 43 aval L0543 **)

   EmettreSegm(LigneL05+ L0544+ TRONC*02+ SEGM*00, noBoucleLaP, SensUp);
   EmettreSegm(LigneL05+ L0544+ TRONC*02+ SEGM*01, noBoucleLaP, SensUp);

 (** Emission invariants vers secteur 45 amont L0545 **)

   EmettreSegm(LigneL05+ L0544+ TRONC*01+ SEGM*00, noBouclePlM, SensUp);

 (** Troncon 1 **)        
   EmettreSegm(LigneL05+ L0544+ TRONC*01+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL05+ L0544+ TRONC*03+ SEGM*00, noBoucle1, SensUp);

 (** Troncon 2 **)        
   EmettreSegm(LigneL05+ L0544+ TRONC*02+ SEGM*00, noBoucle3, SensUp);
   EmettreSegm(LigneL05+ L0544+ TRONC*02+ SEGM*01, noBoucle3, SensUp);
   EmettreSegm(LigneL05+ L0544+ TRONC*04+ SEGM*00, noBoucle3, SensUp);

 (** Troncon 3 **)  
   (* EmettreSegm(LigneL05+ L0544+ TRONC*03+ SEGM*00, noBoucle2, SensUp); *)
   EmettreSegm(LigneL05+ L0543+ TRONC*01+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL05+ L0543+ TRONC*01+ SEGM*01, noBoucle2, SensUp);
   EmettreSegm(LigneL05+ L0543+ TRONC*01+ SEGM*02, noBoucle2, SensUp);

 (** Troncon 4 **)  
   (* EmettreSegm(LigneL05+ L0544+ TRONC*04+ SEGM*00, noBoucle5, SensUp);  *)   
   EmettreSegm(LigneL05+ L0545+ TRONC*02+ SEGM*00, noBoucle5, SensUp); 
   EmettreSegm(LigneL05+ L0545+ TRONC*02+ SEGM*01, noBoucle5, SensUp);

     
 (* *)
(************************** CONFIGURATION DES TRONCONS TSR ***************************)

   ConfigurerTroncon(Tronc0, LigneL05 + L0544 + TRONC*01, 1,1,1,1);  (* troncon 44-1 *)
   ConfigurerTroncon(Tronc1, LigneL05 + L0544 + TRONC*02, 1,1,1,1);  (* troncon 44-2 *)
   ConfigurerTroncon(Tronc2, LigneL05 + L0544 + TRONC*03, 1,1,1,1);  (* troncon 44-3 *)
   ConfigurerTroncon(Tronc3, LigneL05 + L0544 + TRONC*04, 1,1,1,1);  (* troncon 44-4 *)

(******************************** EMISSION DES TSR ***********************************)

(** Emission des TSR vers le secteur aval 43 L0543 **)

   EmettreTronc(LigneL05+ L0544+ TRONC*02, noBoucleLaP, SensUp);


(** Emission des TSR vers le secteur amont 45 L0545 **)

   EmettreTronc(LigneL05+ L0544+ TRONC*01, noBouclePlM, SensUp);


 (** Emission des TSR sur les troncons du secteur courant **)

   EmettreTronc(LigneL05+ L0544+ TRONC*01, noBoucle1, SensUp); (* troncon 44-1 *)
   EmettreTronc(LigneL05+ L0544+ TRONC*03, noBoucle1, SensUp);


   EmettreTronc(LigneL05+ L0544+ TRONC*02, noBoucle3, SensUp); (* troncon 44-2 *)
   EmettreTronc(LigneL05+ L0544+ TRONC*04, noBoucle3, SensUp);
   


   EmettreTronc(LigneL05+ L0544+ TRONC*03, noBoucle2, SensUp); (* troncon 44-3 *)
   EmettreTronc(LigneL05+ L0543+ TRONC*01, noBoucle2, SensUp);


   EmettreTronc(LigneL05+ L0544+ TRONC*04, noBoucle5, SensUp); (* troncon 44-4 *)
   EmettreTronc(LigneL05+ L0545+ TRONC*02, noBoucle5, SensUp);


  


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

    StockAdres( ADR( CdvDS11));
    StockAdres( ADR( CdvDS12));
    StockAdres( ADR( CdvDS13));
    StockAdres( ADR( CdvDS20));
    StockAdres( ADR( CdvDS21));
    StockAdres( ADR( CdvDS22b));
    StockAdres( ADR( CdvDS22a));
    StockAdres( ADR( CdvDS23));
    StockAdres( ADR( CdvMT10));
    StockAdres( ADR( CdvMT11));
    StockAdres( ADR( CdvMT12));
    StockAdres( ADR( CdvMT13));
    StockAdres( ADR( CdvMT20));
    StockAdres( ADR( CdvMT21));

    StockAdres( ADR( CdvMT22));
    StockAdres( ADR( CdvMT23));
    

    StockAdres( ADR( PtArrCdvDS11));
    StockAdres( ADR( PtArrCdvDS12));
    StockAdres( ADR( PtArrCdvDS13));
    StockAdres( ADR( PtArrCdvDS20));

    StockAdres( ADR( PtArrCdvDS21));

    StockAdres( ADR( PtArrCdvDS22b));
    StockAdres( ADR( PtArrCdvDS22a));

    StockAdres( ADR( PtArrCdvDS23));
    StockAdres( ADR( PtArrCdvMT10));

    StockAdres( ADR( PtArrCdvMT11));
    StockAdres( ADR( PtArrCdvMT12));
    StockAdres( ADR( PtArrCdvMT13));

    StockAdres( ADR( PtArrCdvMT20));
    StockAdres( ADR( PtArrCdvMT21));
    StockAdres( ADR( PtArrCdvMT22));

    StockAdres( ADR( PtArrCdvMT23));
    
    
    StockAdres( ADR( PtAntCdvLP10));
    StockAdres( ADR( PtAntSigLP10));
    StockAdres( ADR( PtAntSpeLP12));
    StockAdres( ADR( PtAntCdvSAB23));
    StockAdres( ADR( PtAntCdvSAB22));
    StockAdres( ADR( PtAntCdvSAB21));   
    StockAdres( ADR( PtAntCdvPLM09));
 
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
   CdvDS12Fonc := CdvDS12.F = Vrai.F;
   CdvDS22Fonc := CdvDS22a.F = Vrai.F;
   CdvMT22Fonc := CdvMT22.F = Vrai.F;
   CdvMT12Fonc := CdvMT12.F = Vrai.F;
   

(****************************** FILTRAGE DES AIGUILLES *******************************)

   (* pas d'aiguille *)


(************************** Gerer les point d'arrets **************************)
   

   AffectBoolD( CdvDS11,                    PtArrCdvDS11);
   AffectBoolD( CdvDS12,                    PtArrCdvDS12);
   AffectBoolD( CdvDS13,                    PtArrCdvDS13);
   AffectBoolD( CdvDS20,                    PtArrCdvDS20);
   AffectBoolD( CdvDS21,                    PtArrCdvDS21);
   AffectBoolD( CdvDS22b,                   PtArrCdvDS22b);
   AffectBoolD( CdvDS22a,                   PtArrCdvDS22a);

 (*  EtDD(        CdvDS22b,     CdvDS22a,     PtArrCdvDS22); *)
   AffectBoolD( CdvDS23,                    PtArrCdvDS23);
   AffectBoolD( CdvMT10,                    PtArrCdvMT10);
   AffectBoolD( CdvMT11,                    PtArrCdvMT11);
   AffectBoolD( CdvMT12,                    PtArrCdvMT12);
   AffectBoolD( CdvMT13,                    PtArrCdvMT13);
   AffectBoolD( CdvMT20,                    PtArrCdvMT20);
   AffectBoolD( CdvMT21,                    PtArrCdvMT21);
   AffectBoolD( CdvMT22,                    PtArrCdvMT22);
   AffectBoolD( CdvMT23,                    PtArrCdvMT23);
   
(*** lecture des entrees de regulation ***)

   LireEntreesRegul;

END ExeSpecific;
END Specific.
