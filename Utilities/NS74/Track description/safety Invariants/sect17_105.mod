IMPLEMENTATION MODULE Specific;

(*$S- *)
(*$T- *)

(******************************************************************************
*   SANTIAGO - LIGNE 2 - Secteur 17
*  =============================
*  Version  1.1 DU SERVEUR SCCS =====================
*  Date    : 10/06/2004
*  Auteur  : Marc Plywacz
*  Premiere Version
******************************************************************************)
(*                                                                           *)
(*****************************************************************************)
(* Version 1.0.1  =====================                                      *)
(* Version 1.2  DU SERVEUR SCCS =====================                        *)
(* Date :         09/11/2004                                                 *)
(* Auteur:        Ph. Hog                                                    *)
(* Modifications : data checking.                                            *)
(* Correction des numeros d'entrees dans la procedure "InitSpecDivers"       *)
(*    Entrees 4, 5, 6 et 7 deviennent 3, 4, 5 et 6                           *)
(*                                                                           *)
(*****************************************************************************)
(* Version 1.0.2  =====================                                      *)
(* Version 1.3  DU SERVEUR SCCS =====================                        *)
(* Date :         17/11/2004                                                 *)
(* Auteur:        Ph. Hog                                                    *)
(* Modifications : data checking.                                            *)
(* Correction de l'emission sur la boucle 3 (troncon 3)                      *)
(*    suppression de l'emission du segment 17.2.2                            *)
(*    Ajout de l'emission du segment 17.3.1                                  *)
(*    Ajout de l'emission des LTV du troncon 17.3                            *)
(*                                                                           *)
(*****************************************************************************)
(* Version 1.0.3  =====================                                      *)
(* Version 1.4  DU SERVEUR SCCS =====================                        *)
(* Date :         03/12/2004                                                 *)
(* Auteur:        Marc Plywacz                                               *)
(* Modifications : data checking.                                            *)
(* Correction de l'emission sur la boucle 4 (troncon 4)                      *)
(*    suppression de l'emission du segment 17.4.2                            *)
(*    Ajustement marches types                                               *)
(*                                                                           *)
(*****************************************************************************)
(* Version 1.0.4  =====================                                      *)
(* Version 1.5  DU SERVEUR SCCS =====================                        *)
(* Date :         08/12/2004                                                 *)
(* Auteur:        Marc Plywacz                                               *)
(* Modifications : data checking.                                            *)
(*    Ajustement marches types                                               *)
(*                                                                           *)
(* Version 1.0.5  =====================                                      *)
(* Version 1.6  DU SERVEUR SCCS =====================                        *)
(* Date :         07/08/2006                                                 *)
(* Auteur:        Rudy Nsiona                                                *)
(* Modification : Nouveau Train NS2004                                       *)
(* Procédure CONFIGURATION DES TRONCONS TSR                                   *)
(*                ancienne valeur 1 , nouvelle 2                             *)


(*****************************  IMPORTATIONS  ********************************)

FROM SYSTEM     IMPORT ADR;

FROM Opel       IMPORT StockAdres, AffectBoolD, AffectBoolC, BoolC, BoolD, EtDD, CodeD,
		       Tvrai, FinBranche, FinArbre, AffectC, BoolLD, OuDD;

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

                  	Ampli11, Ampli12, Ampli13, Ampli14,
                  	Ampli21, Ampli22, Ampli23, Ampli24, Ampli25, Ampli26, Ampli27, Ampli28,Ampli2A,
                  	Ampli31, Ampli32, Ampli33, Ampli34, Ampli35, Ampli36, Ampli37,
                  	Ampli41, Ampli42, Ampli43, Ampli44, Ampli45, Ampli46, Ampli47, Ampli48,Ampli4A,
                  	Ampli51, Ampli52, Ampli53, Ampli54, Ampli55, Ampli56, Ampli57, Ampli58,Ampli5A,


(* variables *)
                       Boucle1, Boucle2, Boucle3, Boucle4, Boucle5, BoucleFictive,
                       CarteCes1,  CarteCes2,  CarteCes3, CarteCes4, CarteCes5,
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


    LigneL02 = 16384*00; (* numero de ligne decale de 2**14 *)

 (*   L02xx  = 1024*xx; *)    (* numero Secteur aval voie impaire decale de 2**10 *)

    L0217  = 1024*17;    (* numero Secteur local decale de 2**10 *)

    L0216  = 1024*16;    (* numero Secteur amont voie impaire decale de 2**10 *)

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
 (*   noBoucleheb = 00; *)
    noBoucleOva = 01;
    noBouclefi = 02; (* boucle fictive *)
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

(* DECLARATION DES SINGULARITES DU SECTEUR 17 : dans les deux sens confondus *)

(* Declaration des variables correspondant a des entrees securitaires  *)
(*   - CDV et signaux                                                  *)
    CdvPAR11,      (* entree  1, soit entree 0 de CES 02  *)
    CdvPAR12,      (* entree  2, soit entree 1 de CES 02  *)
    CdvPAR13,      (* entree  3, soit entree 2 de CES 02  *)
    CdvPAR21,      (* entree  4, soit entree 3 de CES 02  *)
    CdvPAR22,      (* entree  5, soit entree 4 de CES 02  *)
    CdvPAR23,      (* entree  6, soit entree 5 de CES 02  *)

    CdvCIT09,      (* entree  9, soit entree 0 de CES 03  *)
    CdvCIT10,      (* entree 10, soit entree 1 de CES 03  *)
    CdvCIT11,      (* entree 11, soit entree 2 de CES 03  *)
    CdvCIT12,      (* entree 12, soit entree 3 de CES 03  *)
    CdvCIT13,      (* entree 13, soit entree 4 de CES 03  *)
    CdvCIT14,      (* entree 14, soit entree 5 de CES 03  *)
    CdvCIT19,      (* entree 15, soit entree 6 de CES 03  *)
    CdvCIT20,      (* entree 16, soit entree 7 de CES 03  *)

    CdvCIT21,      (* entree 17, soit entree 0 de CES 04  *)
    CdvCIT22A,     (* entree 18, soit entree 1 de CES 04  *)
    CdvCIT22B,     (* entree 19, soit entree 2 de CES 04  *)
    CdvCIT23A,     (* entree 20, soit entree 3 de CES 04  *)
    CdvCIT23B,     (* entree 21, soit entree 4 de CES 04  *)
    CdvCIT24,      (* entree 22, soit entree 5 de CES 04  *)
    SigCIT10kv,    (* entree 23, soit entree 6 de CES 04  *)
    SigCIT10kj,    (* entree 24, soit entree 7 de CES 04  *)

    SigCIT12,      (* entree 25, soit entree 0 de CES 05  *)
    SigCIT22A,     (* entree 26, soit entree 1 de CES 05  *)
    SigCIT22B,     (* entree 27, soit entree 2 de CES 05  *)
    SigCIT23,      (* entree 28, soit entree 3 de CES 05  *)
    SigCIT24,      (* entree 29, soit entree 4 de CES 05  *)
    SigCIT14       (* entree 29, soit entree 4 de CES 05  *)
             : BoolD;

(*   - aiguilles                                                       *)
    AigCIT11,      (* entrees 31 et 32, soit entrees 6 et 7 de CES 05  *)
    AigCIT13       (* entrees 33 et 34, soit entrees 0 et 1 de CES 06  *)
             :TyAig;



(* Variables ne correspondant pas a une entree securitaire *)
(* Point d'arret *)
    PtArrCdvPAR11,
    PtArrCdvPAR12,
    PtArrCdvPAR13,

    PtArrCdvCIT09,
    PtArrCdvCIT10,
    PtArrSigCIT10,
    PtArrSpeCIT12,
    PtArrSigCIT12,

    PtArrSigCIT14,
    PtArrSigCIT24,
    PtArrSpeCIT23,
    PtArrSigCIT22B,
    PtArrSigCIT22A,
    PtArrCdvCIT19,

    PtArrCdvPAR23,
    PtArrCdvPAR22,
    PtArrCdvPAR21  : BoolD;

(* Variants anticipes *)
    PtAntCdvOVA24,
    PtAntSigOVA24  : BoolD;
    
(* Copie des entrees dans des variables fonctionnelles pour la regulation *)
    CdvCIT22Fonc,
    CdvPAR12Fonc,
    CdvPAR22Fonc     : BOOLEAN;

(** Voie d'emission SOL-TRAIN : deux sens confondus**)
    te11s17t01,
    te14s17t02,
    te21s17t03,
    te24s17t05,
    te31s17t04           :TyEmissionTele;

(** Voie d'emission Inter-secteur deux voies confondues **)
    teL0216,
    teL02fi	          :TyEmissionTele;

(** Voie de reception Inter-secteur deux voies confondues **)
    trL0216,
    trL02fi               :TyCaracEntSec;

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
    EntreeAiguille( AigCIT11, 32, 31);  (* kag D = pos normale *)
    EntreeAiguille( AigCIT13, 33, 34);  (* kag G = pos normale *)

(* Configuration des entrees *)
    ProcEntreeIntrins(  1, CdvPAR11);
    ProcEntreeIntrins(  2, CdvPAR12);
    ProcEntreeIntrins(  3, CdvPAR13);
    ProcEntreeIntrins(  4, CdvPAR21);
    ProcEntreeIntrins(  5, CdvPAR22);
    ProcEntreeIntrins(  6, CdvPAR23);

    ProcEntreeIntrins(  9, CdvCIT09);
    ProcEntreeIntrins( 10, CdvCIT10);
    ProcEntreeIntrins( 11, CdvCIT11);
    ProcEntreeIntrins( 12, CdvCIT12);
    ProcEntreeIntrins( 13, CdvCIT13);
    ProcEntreeIntrins( 14, CdvCIT14);
    ProcEntreeIntrins( 15, CdvCIT19);
    ProcEntreeIntrins( 16, CdvCIT20);

    ProcEntreeIntrins( 17, CdvCIT21);
    ProcEntreeIntrins( 18, CdvCIT22A);
    ProcEntreeIntrins( 19, CdvCIT22B);
    ProcEntreeIntrins( 20, CdvCIT23A);
    ProcEntreeIntrins( 21, CdvCIT23B);
    ProcEntreeIntrins( 22, CdvCIT24);
    ProcEntreeIntrins( 23, SigCIT10kv);
    ProcEntreeIntrins( 24, SigCIT10kj);

    ProcEntreeIntrins( 25, SigCIT12);
    ProcEntreeIntrins( 26, SigCIT22A);
    ProcEntreeIntrins( 27, SigCIT22B);
    ProcEntreeIntrins( 28, SigCIT23);
    ProcEntreeIntrins( 29, SigCIT24);
    ProcEntreeIntrins( 30, SigCIT14);


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

   ConfigurerAmpli(Ampli21, 2, 1, 193, 14, FALSE);
   ConfigurerAmpli(Ampli22, 2, 2, 194, 15, FALSE);
   ConfigurerAmpli(Ampli23, 2, 3, 195, 15, FALSE);
   ConfigurerAmpli(Ampli24, 2, 4, 196, 15, TRUE);
   ConfigurerAmpli(Ampli25, 2, 5, 197, 16, FALSE); 
   ConfigurerAmpli(Ampli26, 2, 6, 198, 16, FALSE);
   ConfigurerAmpli(Ampli27, 2, 7, 199, 16, TRUE);
   ConfigurerAmpli(Ampli28, 2, 8, 200, 17, FALSE);
 
   ConfigurerAmpli(Ampli2A, 2, 10, 202, 17, TRUE); 

   ConfigurerAmpli(Ampli31, 3, 1, 206, 21, FALSE);
   ConfigurerAmpli(Ampli32, 3, 2, 207, 22, FALSE);
   ConfigurerAmpli(Ampli33, 3, 3, 208, 22, FALSE);
   ConfigurerAmpli(Ampli34, 3, 4, 209, 22, TRUE);
   ConfigurerAmpli(Ampli35, 3, 5, 210, 23, FALSE); 
   ConfigurerAmpli(Ampli36, 3, 6, 211, 23, FALSE);    
   ConfigurerAmpli(Ampli37, 3, 7, 212, 23, TRUE);

   ConfigurerAmpli(Ampli51, 5, 1, 213, 24, FALSE);
   ConfigurerAmpli(Ampli52, 5, 2, 214, 25, FALSE);
   ConfigurerAmpli(Ampli53, 5, 3, 215, 25, FALSE);
   ConfigurerAmpli(Ampli54, 5, 4, 216, 25, TRUE);
   ConfigurerAmpli(Ampli55, 5, 5, 217, 26, FALSE); 
   ConfigurerAmpli(Ampli56, 5, 6, 218, 26, FALSE);    
   ConfigurerAmpli(Ampli57, 5, 7, 219, 26, TRUE);    
   ConfigurerAmpli(Ampli58, 5, 8, 220, 27, FALSE);

   ConfigurerAmpli(Ampli5A, 5, 10, 222, 27, TRUE);    

   ConfigurerAmpli(Ampli41, 4, 1, 258, 31, FALSE);
   ConfigurerAmpli(Ampli42, 4, 2, 259, 32, FALSE);
   ConfigurerAmpli(Ampli43, 4, 3, 260, 32, FALSE);
   ConfigurerAmpli(Ampli44, 4, 4, 261, 32, TRUE);    
   ConfigurerAmpli(Ampli45, 4, 5, 262, 33, FALSE);
   ConfigurerAmpli(Ampli46, 4, 6, 263, 33, FALSE);
   ConfigurerAmpli(Ampli47, 4, 7, 264, 33, TRUE);
   ConfigurerAmpli(Ampli48, 4, 8, 265, 34, FALSE);

   ConfigurerAmpli(Ampli4A, 4, 10, 267, 34, TRUE);


 (** cartes CES **)
   ConfigurerCES(CarteCes1, 01);
   ConfigurerCES(CarteCes2, 02);
   ConfigurerCES(CarteCes3, 03);
   ConfigurerCES(CarteCes4, 04);
   ConfigurerCES(CarteCes5, 05);


(** Liaisons Inter-Secteur **)

   ConfigurerIntsecteur(Intersecteur1, 01, trL02fi, trL0216);


(* Initialisations des variables ne correspondant pas a des entrees secu *)
(* Point d'arret *)
    AffectBoolD( BoolRestrictif, PtArrCdvPAR11);
    AffectBoolD( BoolRestrictif, PtArrCdvPAR12);
    AffectBoolD( BoolRestrictif, PtArrCdvPAR13);
    AffectBoolD( BoolRestrictif, PtArrCdvCIT09);
    AffectBoolD( BoolRestrictif, PtArrCdvCIT10);
    AffectBoolD( BoolRestrictif, PtArrSigCIT10);
    AffectBoolD( BoolRestrictif, PtArrSpeCIT12);
    AffectBoolD( BoolRestrictif, PtArrSigCIT12);

    AffectBoolD( BoolRestrictif, PtArrSigCIT14);
    AffectBoolD( BoolRestrictif, PtArrSigCIT24);
    AffectBoolD( BoolRestrictif, PtArrSpeCIT23);
    AffectBoolD( BoolRestrictif, PtArrSigCIT22B);
    AffectBoolD( BoolRestrictif, PtArrSigCIT22A);
    AffectBoolD( BoolRestrictif, PtArrCdvCIT19);
    AffectBoolD( BoolRestrictif, PtArrCdvPAR23);
    AffectBoolD( BoolRestrictif, PtArrCdvPAR22);
    AffectBoolD( BoolRestrictif, PtArrCdvPAR21);

(* Variants anticipes *)
    AffectBoolD( BoolRestrictif, PtAntCdvOVA24);
    AffectBoolD( BoolRestrictif, PtAntSigOVA24);
        
(* Regulation *)
    CdvCIT22Fonc := FALSE;
    CdvPAR12Fonc := FALSE;
    CdvPAR22Fonc := FALSE;

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

   ConfigEmisTeleSolTrain ( te11s17t01,
                            noBoucle1,         
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);


   ConfigEmisTeleSolTrain ( te14s17t02,
                            noBoucle2,         
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);
   

     
   ConfigEmisTeleSolTrain ( te21s17t03,
                            noBoucle3,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);


   ConfigEmisTeleSolTrain ( te24s17t05,
                            noBoucle5,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);
 
   ConfigEmisTeleSolTrain ( te31s17t04,
                            noBoucle4,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);
 

(* CONFIGURATION POUR LA REGULATION *)
   ConfigQuai (45, 69, CdvCIT22Fonc, te31s17t04, 0, 8, 3, 4,  5, 13, 14, 15);
   ConfigQuai (44, 74, CdvPAR12Fonc, te11s17t01, 0, 3, 4, 5,  6, 13, 14, 15);
   ConfigQuai (44, 79, CdvPAR22Fonc, te24s17t05, 0, 8, 9, 4, 11, 13, 14, 15);


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



(* variants troncon 1   voie 1 --> si *)
   ProcEmisSolTrain( te11s17t01.EmissionSensUp, (2*noBoucle1), 
                     LigneL02+ L0217+ TRONC*01,     

                  PtArrCdvPAR12,
                  PtArrCdvPAR13,
                  PtArrCdvCIT09,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
(* Variants Anticipes *)
              PtArrCdvCIT10,
		  PtArrSigCIT10,
		  BoolRestrictif,
		  AigCIT11.PosNormaleFiltree, (* tivcom *)
		  BoolRestrictif,
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

(* variants troncon 2   voie 1 --> si  *)
   ProcEmisSolTrain( te14s17t02.EmissionSensUp, (2*noBoucle2), 
                     LigneL02+ L0217+ TRONC*02,     

                  PtArrCdvCIT10,
                  PtArrSigCIT10,
                  BoolRestrictif,
                  AigCIT11.PosNormaleFiltree, (* tivcom *)
                  AigCIT11.PosReverseFiltree,
                  AigCIT11.PosNormaleFiltree,
                  PtArrSpeCIT12,
                  PtArrSigCIT12,
                  BoolRestrictif,               (* aspect croix *)
                  
	      (* Variants Anticipes *)
                  BoolRestrictif,
                  BoolRestrictif,
                  PtArrSigCIT22B,
                  BoolRestrictif,               (* aspect croix *)
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


(* variants troncon 3    voie 2  si  *)
   ProcEmisSolTrain( te21s17t03.EmissionSensUp, (2*noBoucle3), 
                     LigneL02+ L0217+ TRONC*03,     

                  PtArrSigCIT22B,
                  BoolRestrictif,               (* aspect croix *)
                  AigCIT13.PosReverseFiltree,
                  AigCIT13.PosNormaleFiltree,
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


(* variants troncon 4  voie 2 <-- sp *)
   ProcEmisSolTrain( te31s17t04.EmissionSensUp, (2*noBoucle4), 
                     LigneL02+ L0217+ TRONC*04,     

                  PtArrSigCIT14,
                  BoolRestrictif,             (* aspect croix *)
                  PtArrSigCIT24,
                  BoolRestrictif,             (* aspect croix *)
                  PtArrSpeCIT23,
                  PtArrSigCIT22A,			
                  BoolRestrictif,             (* aspect croix *)
                  BoolRestrictif,
(* Variants Anticipes *)
                  PtArrCdvCIT19,
                  PtArrCdvPAR23,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
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
   ProcEmisSolTrain( te24s17t05.EmissionSensUp, (2*noBoucle5), 
                     LigneL02+ L0217+ TRONC*05,     

                  PtArrCdvCIT19,
                  PtArrCdvPAR23,
                  PtArrCdvPAR22,
                  PtArrCdvPAR21,			
                  PtAntCdvOVA24,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
(* Variants Anticipes *)
                  PtAntSigOVA24,
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
                  BoolRestrictif,
                  BoolPermissif,
                  BaseSorVar + 120);

(* reception du secteur XX -aval- inexistant *)



(* reception du secteur 16 -amont- *)

   ProcReceptInterSecteur(trL0216, noBoucleOva, LigneL02+ L0216+ TRONC*05,

                  PtAntCdvOVA24,
                  PtAntSigOVA24,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif, 
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


(* emission vers le secteur XX -aval- inexistant *)




(* emission vers le secteur 16 -amont- *)

   ProcEmisInterSecteur (teL0216, noBoucleOva, LigneL02+ L0217+ TRONC*01,
			noBoucleOva,
                  PtArrCdvPAR11,
                  PtArrCdvPAR12,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif, 
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
		  BaseSorVar + 180);


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
            

 (** Emission invariants vers secteur 12 aval L02xx **)

 (* pas de secteur aval *)


 (** Emission invariants vers secteur 16 amont L0216 **)

   EmettreSegm(LigneL02+ L0217+ TRONC*01+ SEGM*00, noBoucleOva, SensUp);
   EmettreSegm(LigneL02+ L0217+ TRONC*01+ SEGM*01, noBoucleOva, SensUp);


 (** Boucle 1 **)        
   EmettreSegm(LigneL02+ L0217+ TRONC*01+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL02+ L0217+ TRONC*01+ SEGM*01, noBoucle1, SensUp);
   EmettreSegm(LigneL02+ L0217+ TRONC*02+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL02+ L0217+ TRONC*02+ SEGM*01, noBoucle1, SensUp);

 (** Boucle 2 **)        
   EmettreSegm(LigneL02+ L0217+ TRONC*02+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL02+ L0217+ TRONC*02+ SEGM*01, noBoucle2, SensUp);
   EmettreSegm(LigneL02+ L0217+ TRONC*03+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL02+ L0217+ TRONC*03+ SEGM*01, noBoucle2, SensUp);
   EmettreSegm(LigneL02+ L0217+ TRONC*04+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL02+ L0217+ TRONC*04+ SEGM*01, noBoucle2, SensUp);

 (** Boucle 3 **)  
   EmettreSegm(LigneL02+ L0217+ TRONC*04+ SEGM*01, noBoucle3, SensUp);
   EmettreSegm(LigneL02+ L0217+ TRONC*02+ SEGM*01, noBoucle3, SensUp);
   EmettreSegm(LigneL02+ L0217+ TRONC*03+ SEGM*01, noBoucle3, SensUp);

 (** Boucle 4 **)  
   EmettreSegm(LigneL02+ L0217+ TRONC*04+ SEGM*00, noBoucle4, SensUp);
   EmettreSegm(LigneL02+ L0217+ TRONC*04+ SEGM*01, noBoucle4, SensUp);
   EmettreSegm(LigneL02+ L0217+ TRONC*05+ SEGM*00, noBoucle4, SensUp);
   EmettreSegm(LigneL02+ L0217+ TRONC*05+ SEGM*01, noBoucle4, SensUp);
   EmettreSegm(LigneL02+ L0217+ TRONC*03+ SEGM*00, noBoucle4, SensUp);

 (** Boucle 5 **) 
   EmettreSegm(LigneL02+ L0217+ TRONC*05+ SEGM*00, noBoucle5, SensUp);
   EmettreSegm(LigneL02+ L0217+ TRONC*05+ SEGM*01, noBoucle5, SensUp);
   EmettreSegm(LigneL02+ L0216+ TRONC*05+ SEGM*00, noBoucle5, SensUp);
   EmettreSegm(LigneL02+ L0216+ TRONC*05+ SEGM*01, noBoucle5, SensUp);
  
 (* *)
(************************** CONFIGURATION DES TRONCONS TSR ***************************)

   ConfigurerTroncon(Tronc0, LigneL02 + L0217 + TRONC*01, 2,2,2,2);  (* troncon 17-1 *)
   ConfigurerTroncon(Tronc1, LigneL02 + L0217 + TRONC*02, 2,2,2,2);  (* troncon 17-2 *)
   ConfigurerTroncon(Tronc2, LigneL02 + L0217 + TRONC*03, 2,2,2,2);  (* troncon 17-3 *)
   ConfigurerTroncon(Tronc3, LigneL02 + L0217 + TRONC*04, 2,2,2,2);  (* troncon 17-4 *)
   ConfigurerTroncon(Tronc4, LigneL02 + L0217 + TRONC*05, 2,2,2,2);  (* troncon 17-5 *)


(******************************** EMISSION DES TSR ***********************************)

(** Emission des TSR vers le secteur aval 12 L0212 **)



(** Emission des TSR vers le secteur amont 16 L0216 **)

   EmettreTronc(LigneL02+ L0217+ TRONC*01, noBoucleOva, SensUp);


 (** Emission des TSR sur les troncons du secteur courant **)

   EmettreTronc(LigneL02+ L0217+ TRONC*01, noBoucle1, SensUp); (* troncon 17-1 *)
   EmettreTronc(LigneL02+ L0217+ TRONC*02, noBoucle1, SensUp);


   EmettreTronc(LigneL02+ L0217+ TRONC*02, noBoucle2, SensUp); (* troncon 17-2 *)
   EmettreTronc(LigneL02+ L0217+ TRONC*03, noBoucle2, SensUp);
   EmettreTronc(LigneL02+ L0217+ TRONC*04, noBoucle2, SensUp);


   EmettreTronc(LigneL02+ L0217+ TRONC*02, noBoucle3, SensUp); (* troncon 17-3 *)
   EmettreTronc(LigneL02+ L0217+ TRONC*04, noBoucle3, SensUp);
   EmettreTronc(LigneL02+ L0217+ TRONC*03, noBoucle3, SensUp);


   EmettreTronc(LigneL02+ L0217+ TRONC*04, noBoucle4, SensUp); (* troncon 17-4 *)
   EmettreTronc(LigneL02+ L0217+ TRONC*05, noBoucle4, SensUp);
   EmettreTronc(LigneL02+ L0217+ TRONC*03, noBoucle4, SensUp);


   EmettreTronc(LigneL02+ L0217+ TRONC*05, noBoucle5, SensUp); (* troncon 17-5 *)
   EmettreTronc(LigneL02+ L0216+ TRONC*05, noBoucle5, SensUp);


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
    StockAdres( ADR( CdvPAR11));
    StockAdres( ADR( CdvPAR12));
    StockAdres( ADR( CdvPAR13));
    StockAdres( ADR( CdvPAR21));
    StockAdres( ADR( CdvPAR22));
    StockAdres( ADR( CdvPAR23));
    StockAdres( ADR( CdvCIT09));
    StockAdres( ADR( CdvCIT10));
    StockAdres( ADR( CdvCIT11));
    StockAdres( ADR( CdvCIT12));
    StockAdres( ADR( CdvCIT13));
    StockAdres( ADR( CdvCIT14));
    StockAdres( ADR( CdvCIT19));
    StockAdres( ADR( CdvCIT20));
    StockAdres( ADR( CdvCIT21));
    StockAdres( ADR( CdvCIT22A));
    StockAdres( ADR( CdvCIT22B));
    StockAdres( ADR( CdvCIT23A));
    StockAdres( ADR( CdvCIT23B));
    StockAdres( ADR( CdvCIT24));
    StockAdres( ADR( SigCIT10kv));
    StockAdres( ADR( SigCIT10kj));
    StockAdres( ADR( SigCIT12));
    StockAdres( ADR( SigCIT22A));
    StockAdres( ADR( SigCIT22B));
    StockAdres( ADR( SigCIT23));
    StockAdres( ADR( SigCIT24));
    StockAdres( ADR( SigCIT14));

    StockAdres( ADR( AigCIT11));
    StockAdres( ADR( AigCIT13));

    StockAdres( ADR( PtArrCdvPAR11));
    StockAdres( ADR( PtArrCdvPAR12));
    StockAdres( ADR( PtArrCdvPAR13));
    StockAdres( ADR( PtArrCdvCIT09));
    StockAdres( ADR( PtArrCdvCIT10));
    StockAdres( ADR( PtArrSigCIT10));
    StockAdres( ADR( PtArrSpeCIT12));
    StockAdres( ADR( PtArrSigCIT12));
    StockAdres( ADR( PtArrSigCIT14));
    StockAdres( ADR( PtArrSigCIT24));
    StockAdres( ADR( PtArrSpeCIT23));
    StockAdres( ADR( PtArrSigCIT22B));
    StockAdres( ADR( PtArrSigCIT22A));
    StockAdres( ADR( PtArrCdvCIT19));
    StockAdres( ADR( PtArrCdvPAR23));
    StockAdres( ADR( PtArrCdvPAR22));
    StockAdres( ADR( PtArrCdvPAR21));

    StockAdres( ADR( PtAntCdvOVA24));
    StockAdres( ADR( PtAntSigOVA24));
    
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
   CdvCIT22Fonc := CdvCIT22A.F = Vrai.F;
   CdvPAR12Fonc := CdvPAR12.F = Vrai.F;
   CdvPAR22Fonc := CdvPAR22.F = Vrai.F;


(****************************** FILTRAGE DES AIGUILLES *******************************)

   FiltrerAiguille( AigCIT11, BaseExeAig);
   FiltrerAiguille( AigCIT13, BaseExeAig+2);


(************************** Gerer les point d'arrets **************************)

   
   AffectBoolD( CdvPAR11,                   PtArrCdvPAR11);
   AffectBoolD( CdvPAR12,                   PtArrCdvPAR12);
   AffectBoolD( CdvPAR13,                   PtArrCdvPAR13);
   AffectBoolD( CdvCIT09,                   PtArrCdvCIT09);
   AffectBoolD( CdvCIT10,                   PtArrCdvCIT10);

   OuDD(        SigCIT10kv,   SigCIT10kj,   PtArrSigCIT10);

   OuDD( CdvCIT13, AigCIT13.PosReverseFiltree, BoolTr);
   EtDD( BoolTr, CdvCIT12,                     PtArrSpeCIT12);

   AffectBoolD( SigCIT12,                   PtArrSigCIT12);
   AffectBoolD( SigCIT14,                   PtArrSigCIT14);
   AffectBoolD( SigCIT24,                   PtArrSigCIT24);

   EtDD(        CdvCIT22A,     CdvCIT21,    BoolTr);
   EtDD(        BoolTr,        SigCIT23,    PtArrSpeCIT23);

   AffectBoolD( SigCIT22B,                  PtArrSigCIT22B);
   AffectBoolD( SigCIT22A,                  PtArrSigCIT22A);

   AffectBoolD( CdvCIT19,                   PtArrCdvCIT19);

   AffectBoolD( CdvPAR23,                   PtArrCdvPAR23);
   AffectBoolD( CdvPAR22,                   PtArrCdvPAR22);
   AffectBoolD( CdvPAR21,                   PtArrCdvPAR21);



(*** lecture des entrees de regulation ***)

   LireEntreesRegul;

END ExeSpecific;
END Specific.
