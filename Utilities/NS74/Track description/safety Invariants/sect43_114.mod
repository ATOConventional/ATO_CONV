IMPLEMENTATION MODULE Specific;

(*$S- *)
(*$T- *)

(******************************************************************************
*   SANTIAGO - LIGNE 5 - Secteur 43
*  =============================
*  Version : SCCS 1.0.0
*  Date    : 21/07/2009
*  Auteur  : Patrick Amsellem
*  Premiere Version
******************************************************************************)
(* Version 1.0.1  =====================                                      *)
(* Date :         22/09/2009                                                 *)
(* Auteur:        Patrick Amsellem                                           *)
(* Modification : ajout invariants securitaire 44.02.01 boucle 6             *)
(*                ajout PtAntCdvMOT21 tronçon 6                              *)
(*                modif configquai Barranca 84 au lieu de 74                 *)
(*                modif configquai Barranca 89 au lieu de 79                 *)
(*****************************************************************************)
(* Version 1.0.2  =====================                                      *)
(* Date :         16/10/2009                                                 *)
(* Auteur:        Patrick Amsellem                                           *)
(* Modification : ConfigurerAmpli(Ampli68, 6, 8, 260, 33, FALSE)             *)
(*                ConfigurerAmpli(Ampli69, 6, 9, 268, 33, TRUE)              *)
(*****************************************************************************)
(* Version 1.0.3  =====================                                      *)
(* Date :         11/02/2010                                                 *)
(* Auteur:        Patrick Amsellem                                           *)
(* Modification : ProcEmisSolTrain remplacer boucle 8 par boucle 7 AM160772  *)
(* Modification : ajout variant PtArrCdvBR21 dans ProcEmisInterSecteur S42   *)
(* Modification : AM160773                                                   *)
(* Modification : CONFIGURATION DES EMISSION DES INVARIANTS SECURITAIRES     *)
(* Modification : boucles 6 / 7 / 8 AM160774                                 *)
(* Modification : CONFIGURATION DES TRONCONS TSR 1 au lieu de 2 AM160775     *)
(* Modification : Modification equation PtArrSpeLP22 et remplacement         *)
(* Modification : PtArrSpeLP13 par PtArrCdvLP13 avec modif equation AM160754 *)
(* Modification : Modification equation PtArrCdvLP13                         *)
(* Modification : Modification equation PtArrSpeLP20 AM160776                *)
(*****************************************************************************)
(* Version  1.0.4  =====================                                     *)
(* Date :          10/09/2010                                                *)
(* Auteur :        M. Plywacz                                                *)
(* Modification : Ajout : ConfigurerTroncon(Tronc8,  0, 0,0,0,0) ;           *)
(*---------------------------------------------------------------------------*)
(* Version  1.0.5  =====================                                     *)
(* Date :          05/10/2010                                                *)
(* Auteur :        M. Plywacz                                                *)
(* Modification : Ajout : dans tron 43_5    "PtArrCdvBR12B"                  *)
(* Remplace     : dans tron 43_1 :  "PtArrSpeLP12" par "PtArrSpeLP12A"       *)
(*---------------------------------------------------------------------------*)
(* Version  1.0.6  =====================                                     *)
(* Date :          12/10/2010                                                *)
(* Auteur :        M. Plywacz                                                *)
(* Modification : permutations noBoucle dans "ConfigEmisTeleSolTrain"        *)
(* Correction des noBoucle dans "EmettreSegm"  et "EmettreTronc"             *)
(*---------------------------------------------------------------------------*)
(* Version  1.0.7  =====================                                     *)
(* Date :          04/11/2010                                                *)
(* Auteur :        Ph. Hog                                                   *)
(* Modification : Correction du nom et de l'ecuation du point d'arret en     *)
(*                entree de LP voie 1                                        *)
(*                ("PtArrSpeLP12A" devient "PtArrSpeLP12B")                  *)
(*---------------------------------------------------------------------------*)
(* Version  1.0.8  =====================                                     *)
(* Date :          10/11/2010                                                *)
(* Auteur :        Ph. Hog                                                   *)
(* Modification : Suppression du point d'arret PtArrSpeLP20 (pour SP1)       *)
(*                Equation entre SP1 et PtAntMOT23                           *)
(*                Forcage au rouge des signaux LP12 et LP20                  *)
(*                Mise en commentaire de l'emission des LTV 43.7 et 43.8     *)
(*---------------------------------------------------------------------------*)
(* Version  1.0.9  =====================                                     *)
(* Date :          15/11/2010                                                *)
(* Auteur :        M. Plywacz                                                *)
(* Modification : inhibition Entrees Fonc DAMTC amplis parcours hors service *)
(*---------------------------------------------------------------------------*)
(* Version  1.1.0  =====================                                     *)
(* Date :          09/06/2011                                                *)
(* Auteur :        I. ISSA                                                   *)
(* Modification : Marches types ConfigQuai                                   *)
(*---------------------------------------------------------------------------*)
(* Version  1.1.1  =====================                                     *)
(* Date :          21/09/2011                                                *)
(* Auteur :        I. ISSA                                                   *)
(* Modification : Emission des TSR sur les tronçons                          *)
(*---------------------------------------------------------------------------*)
(* Version  1.1.2  =====================                                     *)
(* Date :          22/09/2011                                                *)
(* Auteur :        I. ISSA                                                   *)
(* Modification : Version avec les manoeuvres: suppression de la partie      *)
(*                provisoire à la fin du spécifique                          *)
(*---------------------------------------------------------------------------*)
(* Version  1.1.3  =====================                                     *)
(* Date :          27/09/2011                                                *)
(* Auteur :        I. ISSA                                                   *)
(* Modification : Version avec les manoeuvres : Suppression des commentaires *)
(*                pour les DAM TC des troçons 7 et 8                         *)
(*---------------------------------------------------------------------------*)
(* Version  1.1.4  =====================                                     *)
(* Date :          11/05/2012                                                *)
(* Auteur :        JP. BEMMA                                                 *)
(* Modification :   Ajout d'un point d'arrêt PtArrSpeLP20 tronçon 43.6       *)
(*                  pour le Sp1LP des trains de plus de 120m                 *)
(*                  suppression de la  variable PtAntCdvMOT23SP               *)
(*---------------------------------------------------------------------------*)
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

                  	Ampli11, Ampli12, Ampli13, Ampli14, Ampli15, Ampli16, Ampli17, Ampli18,Ampli19, Ampli1A,
                  	Ampli21, Ampli22, Ampli23, Ampli24, Ampli25, Ampli26, Ampli27, 
                  	Ampli31, Ampli32, Ampli33, Ampli34, Ampli35, Ampli36, Ampli37,
                  	Ampli41, Ampli42, Ampli43, Ampli44,   
                  	Ampli51, Ampli52, Ampli53, Ampli54, Ampli55, Ampli56, Ampli57, Ampli58,Ampli59, Ampli5A,
                  	Ampli61, Ampli62, Ampli63, Ampli64, Ampli65, Ampli66, Ampli67, Ampli68,Ampli69,                 
                  	Ampli71, Ampli72, Ampli73, Ampli74,              
                        Ampli81, Ampli82, Ampli83, Ampli84, 

(* variables *)
                       Boucle1, Boucle2, Boucle3, Boucle4, Boucle5, Boucle6, Boucle7, Boucle8, BoucleFictive,
		       CarteCes1,  CarteCes2,  CarteCes3, CarteCes4, CarteCes5, CarteCes6,
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

    L0542  = 1024*42;     (* numero Secteur aval voie impaire decale de 2**10 *)

    L0543  = 1024*43;    (* numero Secteur local decale de 2**10 *)

    L0544  = 1024*44;    (* numero Secteur amont voie impaire decale de 2**10 *)

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

(** No des stations du secteur 43 **)
(* ligne 1: 1,2 ; ligne 2: 3,4; ligne 5: 5,6 *)
   (* noLPv1 = 5*32 + 1;*)
   (* noLPv2 = 6*32 + 13;*)
   (* noLSv1 = 5*32 + 2;*)
   (* noLSv2 = 6*32 + 12;*)
   (* noBRv1 = 5*32 + 2;*)
   (* noBRv2 = 6*32 + 12;*)

(** indication de sens **)
    SensUp = TRUE;

(** No de Voie d'emissions SOL-Train, d'emission/reception inter-secteur **)
    noBouclePud = 00; 
    noBoucleMoT = 01;
    noBouclefi = 02; (* boucle fictive *)
    noBoucle1 = 03;
    noBoucle2 = 04;
    noBoucle3 = 05;
    noBoucle4 = 06;
    noBoucle5 = 07;
    noBoucle6 = 08;
    noBoucle7 = 09;
    noBoucle8 = 10;

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

(* DECLARATION DES SINGULARITES DU SECTEUR 43 : dans les deux sens confondus *)

(* Declaration des variables correspondant a des entrees securitaires  *)
(*   - CDV et signaux                                                  *)
    SigLP20,       (* entree  1, soit entree 0 de CES 02  *)
    SigLP10,       (* entree  2, soit entree 1 de CES 02  *)
  (* reserve, *)   (* entree  3, soit entree 2 de CES 02  *)
    SigLP22kv,     (* entree  4, soit entree 3 de CES 02  *)
    SigLP22kj,     (* entree  5, soit entree 4 de CES 02  *)
  (* reserve, *)   (* entree  6, soit entree 5 de CES 02  *)
    SigLP24,       (* entree  7, soit entree 6 de CES 02  *)
    SigLP12,       (* entree  8, soit entree 7 de CES 02  *)

    CdvLP10,      (* entree 11, soit entree 2 de CES 03  *)
    CdvLP11,      (* entree 12, soit entree 3 de CES 03  *)
    CdvLP12B,     (* entree 13, soit entree 4 de CES 03  *)
    CdvLP12A,     (* entree 14, soit entree 5 de CES 03  *)
    CdvLP13,      (* entree 15, soit entree 6 de CES 03  *)
    CdvLP14,      (* entree 16, soit entree 7 de CES 03  *)

    CdvLP15,      (* entree 17, soit entree 0 de CES 04  *)
    CdvLP20,      (* entree 18, soit entree 1 de CES 04  *)
    CdvLP21,      (* entree 19, soit entree 2 de CES 04  *)
    CdvLP22B,     (* entree 20, soit entree 3 de CES 04  *)
    CdvLP22A,     (* entree 21, soit entree 4 de CES 04  *)
    CdvLP24,      (* entree 22, soit entree 5 de CES 04  *)
    CdvLP25,      (* entree 23, soit entree 6 de CES 04  *)
  (* reserve, *)  (* entree 24, soit entree 7 de CES 04  *)

    CdvLS20,      (* entree 25, soit entree 0 de CES 05  *)
    CdvLS21,      (* entree 26, soit entree 1 de CES 05  *)
    CdvLS22,      (* entree 27, soit entree 2 de CES 05  *)
    CdvLS23,      (* entree 28, soit entree 3 de CES 05  *)
    CdvLS10,      (* entree 29, soit entree 4 de CES 05  *)
    CdvLS11,      (* entree 30, soit entree 5 de CES 05  *)
    CdvLS12,      (* entree 31, soit entree 6 de CES 05  *)
    CdvLS13,      (* entree 32, soit entree 7 de CES 05  *)

    CdvBR20,      (* entree 33, soit entree 0 de CES 06  *)
    CdvBR21,      (* entree 34, soit entree 1 de CES 06  *)
    CdvBR22,      (* entree 35, soit entree 2 de CES 06  *)
    CdvBR23,      (* entree 36, soit entree 3 de CES 06  *)
    CdvBR10,      (* entree 37, soit entree 4 de CES 06  *)
    CdvBR11,      (* entree 38, soit entree 5 de CES 06  *)
    CdvBR12B,     (* entree 39, soit entree 6 de CES 06  *)
    CdvBR12A,     (* entree 40, soit entree 7 de CES 06  *)

    CdvBR13,      (* entree 41, soit entree 0 de CES 07  *)
    CdvBR14,      (* entree 42, soit entree 1 de CES 07  *)
    CdvBR15,      (* entree 43, soit entree 2 de CES 07  *)
    Sp2LP,        (* entree 44, soit entree 3 de CES 07  *)
    Sp1LP,         (* entree 45, soit entree 4 de CES 07  *)
    CdvBR16       (* entree 46, soit entree 5 de CES 07  *)



             : BoolD;

(*   - aiguilles                                                        *)
    AigLP11_21      (* entrees  9 et  10, soit entrees 0 et 1 de CES 03 *)
             :TyAig;


(* Variables ne correspondant pas a une entree securitaire *)
(* Point d'arret *)

    PtArrSigLP20,
    PtArrCdvLP10,
    PtArrCdvBR23,
    PtArrSigLP10,
    PtArrSpeLP12B,
    PtArrSpeLP22,
    PtArrSpeLP20,	
    PtArrCdvLP13,
    PtArrCdvLP14,
    PtArrCdvLP15,
    PtArrCdvLS10,
    PtArrCdvLS11,
    PtArrCdvLS12,

    PtArrCdvLS13,
    PtArrCdvBR10,
    PtArrCdvBR11,
    PtArrCdvBR12A,
    PtArrCdvBR12B,

    PtArrCdvBR13,
    PtArrSigLP24,
    PtArrCdvBR14,
    PtArrSigLP22,

    PtArrCdvBR15,
    PtArrCdvBR16,
    PtArrCdvBR22,
    PtArrCdvBR21,
    PtArrCdvBR20,
    PtArrCdvLS23,
    PtArrCdvLS22,
    PtArrCdvLS21,
    PtArrCdvLS20,
    PtArrCdvLP25,
    PtArrCdvLP24,

    PtArrSigLP12 : BoolD;


 (* Tiv Com *)
    TivComSigLP22 : BoolD;
    
(* Variants anticipes *)
    PtAntCdvPUD10,
    PtAntSigPUD11,


    PtAntCdvMOT23,
    PtAntCdvMOT22,
    PtAntCdvMOT21    : BoolD;

    
(* Copie des entrees dans des variables fonctionnelles pour la regulation *)
    CdvLP12Fonc,
    CdvLP22Fonc,
    CdvLS12Fonc,
    CdvLS22Fonc,
    CdvBR12Fonc,
    CdvBR22Fonc            : BOOLEAN;

(** Voie d'emission SOL-TRAIN : deux sens confondus**)
    te11s43t01,
    te24s43t02,
    te21s43t03,
    te31s43t04,
    te15s43t05,
    te34s43t06,
    te37s43t07,
    te27s43t08           :TyEmissionTele;

(** Voie d'emission Inter-secteur deux voies confondues **)
    teL0542,
    teL0544,
    teL05fi	          :TyEmissionTele;

(** Voie de reception Inter-secteur deux voies confondues **)
    trL0542,
    trL0544,
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
    EntreeAiguille( AigLP11_21,  9,  10);  (* kag G = pos normale *)

(* Configuration des entrees *)
    ProcEntreeIntrins(  1, SigLP20);
    ProcEntreeIntrins(  2, SigLP10);

    ProcEntreeIntrins(  4, SigLP22kv);
    ProcEntreeIntrins(  5, SigLP22kj);
    ProcEntreeIntrins(  7, SigLP24);
    ProcEntreeIntrins(  8, SigLP12);

    ProcEntreeIntrins( 11, CdvLP10);
    ProcEntreeIntrins( 12, CdvLP11);
    ProcEntreeIntrins( 13, CdvLP12B);
    ProcEntreeIntrins( 14, CdvLP12A);
    ProcEntreeIntrins( 15, CdvLP13);
    ProcEntreeIntrins( 16, CdvLP14);
    ProcEntreeIntrins( 17, CdvLP15);
    ProcEntreeIntrins( 18, CdvLP20);
    ProcEntreeIntrins( 19, CdvLP21);
    ProcEntreeIntrins( 20, CdvLP22B);

    ProcEntreeIntrins( 21, CdvLP22A);
    ProcEntreeIntrins( 22, CdvLP24);
    ProcEntreeIntrins( 23, CdvLP25);
    
    ProcEntreeIntrins( 25, CdvLS20);
    ProcEntreeIntrins( 26, CdvLS21);
    ProcEntreeIntrins( 27, CdvLS22); 
    ProcEntreeIntrins( 28, CdvLS23);
    ProcEntreeIntrins( 29, CdvLS10);
    ProcEntreeIntrins( 30, CdvLS11);
    ProcEntreeIntrins( 31, CdvLS12);
    ProcEntreeIntrins( 32, CdvLS13);

    ProcEntreeIntrins( 33, CdvBR20);
    ProcEntreeIntrins( 34, CdvBR21);
    ProcEntreeIntrins( 35, CdvBR22);
    ProcEntreeIntrins( 36, CdvBR23);
    ProcEntreeIntrins( 37, CdvBR10);
    ProcEntreeIntrins( 38, CdvBR11);
    ProcEntreeIntrins( 39, CdvBR12B);
    ProcEntreeIntrins( 40, CdvBR12A);

    ProcEntreeIntrins( 41, CdvBR13);
    ProcEntreeIntrins( 42, CdvBR14);
    ProcEntreeIntrins( 43, CdvBR15);

    ProcEntreeIntrins( 44, Sp2LP);
    ProcEntreeIntrins( 45, Sp1LP);
    ProcEntreeIntrins( 46, CdvBR16);

(* CONFIGURATION POUR LA MAINTENANCE de la transmission continue *)
   ConfigurerBoucle(Boucle1, 1);
   ConfigurerBoucle(Boucle2, 2);
   ConfigurerBoucle(Boucle3, 3);
   ConfigurerBoucle(Boucle4, 4);
   ConfigurerBoucle(Boucle5, 5);
   ConfigurerBoucle(Boucle6, 6);
   ConfigurerBoucle(Boucle7, 7);
   ConfigurerBoucle(Boucle8, 8);

(* PTC 1 *)

   ConfigurerAmpli(Ampli11, 1, 1, 154, 11, FALSE);
   ConfigurerAmpli(Ampli12, 1, 2, 155, 12, FALSE);
   ConfigurerAmpli(Ampli13, 1, 3, 156, 12, FALSE);
   ConfigurerAmpli(Ampli14, 1, 4, 157, 12, TRUE);
   ConfigurerAmpli(Ampli15, 1, 5, 158, 13, FALSE);
   ConfigurerAmpli(Ampli16, 1, 6, 159, 13, FALSE);
   ConfigurerAmpli(Ampli17, 1, 7, 192, 13, TRUE);
   ConfigurerAmpli(Ampli18, 1, 8, 193, 14, FALSE);
   ConfigurerAmpli(Ampli19, 1, 9, 194, 14, FALSE);
   ConfigurerAmpli(Ampli1A, 1, 10, 195, 14, TRUE);


   ConfigurerAmpli(Ampli51, 5, 1, 196, 15, FALSE);
   ConfigurerAmpli(Ampli52, 5, 2, 197, 16, FALSE);
   ConfigurerAmpli(Ampli53, 5, 3, 198, 16, FALSE);
   ConfigurerAmpli(Ampli54, 5, 4, 199, 16, TRUE);
   ConfigurerAmpli(Ampli55, 5, 5, 200, 17, FALSE);
   ConfigurerAmpli(Ampli56, 5, 6, 201, 17, FALSE);
   ConfigurerAmpli(Ampli57, 5, 7, 202, 17, TRUE);
   ConfigurerAmpli(Ampli58, 5, 8, 203, 18, FALSE);
   ConfigurerAmpli(Ampli59, 5, 9, 204, 18, FALSE);
   ConfigurerAmpli(Ampli5A, 5, 10, 205, 18, TRUE);

(* PTC 2 *)
   ConfigurerAmpli(Ampli31, 3, 1, 206, 21, FALSE);
   ConfigurerAmpli(Ampli32, 3, 2, 207, 22, FALSE);
   ConfigurerAmpli(Ampli33, 3, 3, 208, 22, FALSE);
   ConfigurerAmpli(Ampli34, 3, 4, 209, 22, TRUE);
   ConfigurerAmpli(Ampli35, 3, 5, 210, 23, FALSE);
   ConfigurerAmpli(Ampli36, 3, 6, 211, 23, FALSE);
   ConfigurerAmpli(Ampli37, 3, 7, 212, 23, TRUE);


   ConfigurerAmpli(Ampli21, 2, 1, 213, 24, FALSE);
   ConfigurerAmpli(Ampli22, 2, 2, 214, 25, FALSE);
   ConfigurerAmpli(Ampli23, 2, 3, 215, 25, FALSE);
   ConfigurerAmpli(Ampli24, 2, 4, 216, 25, TRUE);
   ConfigurerAmpli(Ampli25, 2, 5, 217, 26, FALSE);
   ConfigurerAmpli(Ampli26, 2, 6, 218, 26, FALSE);
   ConfigurerAmpli(Ampli27, 2, 7, 219, 26, TRUE);


   ConfigurerAmpli(Ampli81, 8, 1, 220, 27, FALSE);
   ConfigurerAmpli(Ampli82, 8, 2, 221, 28, FALSE);
   ConfigurerAmpli(Ampli83, 8, 3, 222, 28, FALSE);
   ConfigurerAmpli(Ampli84, 8, 4, 223, 28, TRUE);


(* PTC 3 *)
   ConfigurerAmpli(Ampli41, 4, 1, 256, 31, FALSE);
   ConfigurerAmpli(Ampli42, 4, 2, 257, 32, FALSE);
   ConfigurerAmpli(Ampli43, 4, 3, 258, 32, FALSE);
   ConfigurerAmpli(Ampli44, 4, 4, 259, 32, TRUE);

   ConfigurerAmpli(Ampli68, 6, 8, 260, 33, FALSE);
   ConfigurerAmpli(Ampli61, 6, 1, 261, 34, FALSE);
   ConfigurerAmpli(Ampli62, 6, 2, 262, 35, FALSE);
   ConfigurerAmpli(Ampli63, 6, 3, 263, 35, FALSE);
   ConfigurerAmpli(Ampli64, 6, 4, 264, 35, TRUE);
   ConfigurerAmpli(Ampli65, 6, 5, 265, 36, FALSE);
   ConfigurerAmpli(Ampli66, 6, 6, 266, 36, FALSE);
   ConfigurerAmpli(Ampli67, 6, 7, 267, 36, TRUE);
   ConfigurerAmpli(Ampli69, 6, 9, 268, 33, TRUE);

   ConfigurerAmpli(Ampli71, 7, 1, 269, 37, FALSE);
   ConfigurerAmpli(Ampli72, 7, 2, 270, 38, FALSE);
   ConfigurerAmpli(Ampli73, 7, 3, 271, 38, FALSE);
   ConfigurerAmpli(Ampli74, 7, 4, 272, 38, TRUE);



   




 (** cartes CES **)
   ConfigurerCES(CarteCes1, 01);
   ConfigurerCES(CarteCes2, 02);
   ConfigurerCES(CarteCes3, 03);
   ConfigurerCES(CarteCes4, 04);
   ConfigurerCES(CarteCes5, 05);
   ConfigurerCES(CarteCes6, 06);

(** Liaisons Inter-Secteur **)

   ConfigurerIntsecteur(Intersecteur1, 01, trL0542, trL0544);

(* Initialisations des variables ne correspondant pas a des entrees secu *)
(* Point d'arret *)
    AffectBoolD( BoolRestrictif, PtArrSigLP20);
    AffectBoolD( BoolRestrictif, PtArrCdvLP10);
    AffectBoolD( BoolRestrictif, PtArrCdvBR23);
    AffectBoolD( BoolRestrictif, PtArrSigLP10);
    AffectBoolD( BoolRestrictif, PtArrSpeLP12B);
    AffectBoolD( BoolRestrictif, PtArrSpeLP22);
    AffectBoolD( BoolRestrictif, PtArrSpeLP20);	
    AffectBoolD( BoolRestrictif, PtArrCdvLP13);
    AffectBoolD( BoolRestrictif, PtArrCdvLP14);
    AffectBoolD( BoolRestrictif, PtArrCdvLP15);
    AffectBoolD( BoolRestrictif, PtArrCdvLS10);
    AffectBoolD( BoolRestrictif, PtArrCdvLS11);
    AffectBoolD( BoolRestrictif, PtArrCdvLS12);
    AffectBoolD( BoolRestrictif, PtArrCdvLS13);
    AffectBoolD( BoolRestrictif, PtArrCdvBR10);
    AffectBoolD( BoolRestrictif, PtArrCdvBR11);
    AffectBoolD( BoolRestrictif, PtArrCdvBR12A);
    AffectBoolD( BoolRestrictif, PtArrCdvBR12B);
    AffectBoolD( BoolRestrictif, PtArrCdvBR13);

    AffectBoolD( BoolRestrictif, PtArrCdvBR14);
    AffectBoolD( BoolRestrictif, PtArrSigLP22);
    AffectBoolD( BoolRestrictif, PtArrSigLP24);
    AffectBoolD( BoolRestrictif, PtArrCdvBR15);
    AffectBoolD( BoolRestrictif, PtArrCdvBR16);
    AffectBoolD( BoolRestrictif, PtArrCdvBR22);
    AffectBoolD( BoolRestrictif, PtArrCdvBR21);

    AffectBoolD( BoolRestrictif, PtArrCdvBR20);
    AffectBoolD( BoolRestrictif, PtArrCdvLS23);
    AffectBoolD( BoolRestrictif, PtArrCdvLS22);
    AffectBoolD( BoolRestrictif, PtArrCdvLS21);
    AffectBoolD( BoolRestrictif, PtArrCdvLS20);
    AffectBoolD( BoolRestrictif, PtArrCdvLP25);
    AffectBoolD( BoolRestrictif, PtArrCdvLP24);

    AffectBoolD( BoolRestrictif, PtArrSigLP12);

    AffectBoolD( BoolRestrictif, TivComSigLP22);

(* Variants anticipes *)
    
    AffectBoolD( BoolRestrictif, PtAntCdvPUD10);
    AffectBoolD( BoolRestrictif, PtAntSigPUD11);

    AffectBoolD( BoolRestrictif, PtAntCdvMOT23);
    AffectBoolD( BoolRestrictif, PtAntCdvMOT22);
    AffectBoolD( BoolRestrictif, PtAntCdvMOT21);
        
(* Regulation *)
    CdvLP12Fonc := FALSE;
    CdvLP22Fonc := FALSE;
    CdvLS12Fonc := FALSE;
    CdvLS22Fonc := FALSE;
    CdvBR12Fonc := FALSE;
    CdvBR22Fonc := FALSE;
            
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

   ConfigEmisTeleSolTrain ( te11s43t01,
                            noBoucle1,         
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te24s43t02,
                            noBoucle4,         
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);
       
   ConfigEmisTeleSolTrain ( te21s43t03,
                            noBoucle3,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te31s43t04,
                            noBoucle6,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);
 
   ConfigEmisTeleSolTrain ( te15s43t05,
                            noBoucle2,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);
 
   ConfigEmisTeleSolTrain ( te34s43t06,
                            noBoucle7,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te37s43t07,
                            noBoucle8,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te27s43t08,
                            noBoucle5,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

(* CONFIGURATION POUR LA REGULATION *)

   ConfigQuai (77, 64, CdvLP12Fonc, te11s43t01, 0, 2, 3, 4, 11, 13, 14, 15);
   ConfigQuai (77, 69, CdvLP22Fonc, te34s43t06, 0, 8, 9, 11, 10, 13, 14, 15);

   ConfigQuai (76, 74, CdvLS12Fonc, te21s43t03, 0, 8, 9, 11, 5, 13, 14, 15);
   ConfigQuai (76, 79, CdvLS22Fonc, te31s43t04, 0, 8, 9, 4, 11, 13, 14, 15);

   ConfigQuai (75, 84, CdvBR12Fonc, te15s43t05, 0, 2, 8, 9, 4, 13, 14, 15);
   ConfigQuai (75, 89, CdvBR22Fonc, te24s43t02, 0, 11, 5, 10, 6, 13, 14, 15);

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
   ProcEmisSolTrain( te11s43t01.EmissionSensUp, (2*noBoucle1), 
                     LigneL05+ L0543+ TRONC*01,     

                  PtArrSigLP10,
                  BoolRestrictif,             (* aspect croix *)
                  PtArrSpeLP12B,
                  PtArrCdvLP13,
                  PtArrCdvLP14,
                  PtArrCdvLP15,
                  PtArrCdvLS10,
		  BoolRestrictif,
(* Variants Anticipes *)
                  PtArrCdvLS11,
		  PtArrCdvLS12,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
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
   ProcEmisSolTrain( te24s43t02.EmissionSensUp, (2*noBoucle4), 
                     LigneL05+ L0543+ TRONC*02,     

                  PtArrCdvBR22,
                  PtArrCdvBR21,
                  PtArrCdvBR20,
                  PtArrCdvLS23,
                  PtArrCdvLS22,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
	      (* Variants Anticipes *)
                  PtArrCdvLS21,
                  PtArrCdvLS20,               
                  PtArrCdvLP25,                  
                  BoolRestrictif,
                  BoolRestrictif,
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
   ProcEmisSolTrain( te21s43t03.EmissionSensUp, (2*noBoucle3), 
                     LigneL05+ L0543+ TRONC*03,     

                  PtArrCdvLS11,
                  PtArrCdvLS12,
                  PtArrCdvLS13,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif, 
                  BoolRestrictif,                     
(* Variants Anticipes *)
                  PtArrCdvBR10,
                  PtArrCdvBR11,
                  BoolRestrictif,             
                  BoolRestrictif,
                  BoolRestrictif,
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
   ProcEmisSolTrain( te31s43t04.EmissionSensUp, (2*noBoucle6), 
                     LigneL05+ L0543+ TRONC*04,     

                  PtArrCdvLS21,
                  PtArrCdvLS20,
                  PtArrCdvLP25,             
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,             
                  BoolRestrictif,
                  BoolRestrictif,
(* Variants Anticipes *)
                  PtArrCdvLP24,
                  PtArrSigLP24,
                  BoolRestrictif,                  (* aspect croix *)
                  BoolRestrictif,
                  BoolRestrictif,
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


(* variants du troncon 5 voie 1 <-- si *)
   ProcEmisSolTrain( te15s43t05.EmissionSensUp, (2*noBoucle2), 
                     LigneL05+ L0543+ TRONC*05,     

                  PtArrCdvBR10,
                  PtArrCdvBR11,             
                  PtArrCdvBR12A,
                  PtArrCdvBR12B,
                  PtArrCdvBR13,
                  PtArrCdvBR14,
                  PtArrCdvBR15,
                  PtArrCdvBR16,
(* Variants Anticipes *)
                  PtAntCdvPUD10,
                  PtAntSigPUD11,
		  BoolRestrictif,                       (* aspect croix *) 
		  BoolRestrictif,
		  BoolRestrictif,
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


(* variants troncon 6  voie 2 <-- sp *)
   ProcEmisSolTrain( te34s43t06.EmissionSensUp, (2*noBoucle7), 
                     LigneL05+ L0543+ TRONC*06,     

                  PtArrCdvLP24,
                  PtArrSigLP24,
                  BoolRestrictif,                 (* aspect croix *) 
                  PtArrSpeLP22,                   
                  PtArrSigLP22,
                  BoolRestrictif,                  (* aspect croix *) 
                  TivComSigLP22,
                  PtAntCdvMOT23,
                  PtArrSpeLP20,
(* Variants Anticipes *)
                  PtAntCdvMOT22,
                  PtAntCdvMOT21,
                  BoolRestrictif,
                  BoolRestrictif,
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


(* variants troncon 7   voie 2 --> si  *)
   ProcEmisSolTrain( te37s43t07.EmissionSensUp, (2*noBoucle8), 
                     LigneL05+ L0543+ TRONC*07,     

                  PtArrSigLP20,
                  BoolRestrictif,             (* aspect croix *)
                  AigLP11_21.PosReverseFiltree,
                  AigLP11_21.PosNormaleFiltree,
                  BoolRestrictif,             (* Rouge Fix *)
                  BoolRestrictif,             (* aspect croix *)
                  BoolRestrictif,
                  BoolRestrictif,
	      (* Variants Anticipes *)
                  PtArrSpeLP12B,
                  PtArrCdvLP13,
                  PtArrCdvLP14,
                  BoolRestrictif,
                  BoolRestrictif,
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

(* variants troncon 8   voie 1 --> sp  *)
   ProcEmisSolTrain( te27s43t08.EmissionSensUp, (2*noBoucle5), 
                     LigneL05+ L0543+ TRONC*08,     

                  PtArrSigLP12,
                  BoolRestrictif,             (* aspect croix *)
                  BoolRestrictif,             
                  BoolRestrictif,             
                  BoolRestrictif,             
                  BoolRestrictif,             
                  BoolRestrictif,
                  BoolRestrictif,
              (* Variants Anticipes *)
                  PtAntCdvMOT23,
                  PtArrSpeLP20,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
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
                  BaseSorVar + 210);


(* emission vers le secteur 42 -aval- PUDAHUEL *)

   ProcEmisInterSecteur (teL0542, noBouclePud, LigneL05+ L0543+ TRONC*02,
			noBouclePud,
                  PtArrCdvBR23,
                  PtArrCdvBR22,
                  PtArrCdvBR21,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif, 
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


(* emission vers le secteur 44 -amont- MONTE TABOR *)

   ProcEmisInterSecteur (teL0544, noBoucleMoT, LigneL05+ L0543+ TRONC*01,
			noBoucleMoT,
                  PtArrCdvLP10,
                  PtArrSigLP10,
                  PtArrSpeLP12B,            
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
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



(* reception du secteur 42 -aval- *)

   ProcReceptInterSecteur(trL0542, noBouclePud, LigneL05+ L0542+ TRONC*01,
                  PtAntCdvPUD10,
                  PtAntSigPUD11,                 
                  BoolRestrictif,         
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif, 
                  BoolRestrictif,
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


(* reception du secteur 44 -amont- MONTE TABOR *)

   ProcReceptInterSecteur(trL0544, noBoucleMoT, LigneL05+ L0544+ TRONC*02,
                  PtAntCdvMOT23,
                  PtAntCdvMOT22,
                  PtAntCdvMOT21,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif, 
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
            

 (** Emission invariants vers secteur 42 aval L0542 **)

   EmettreSegm(LigneL05+ L0543+ TRONC*02+ SEGM*00, noBouclePud, SensUp);
   EmettreSegm(LigneL05+ L0543+ TRONC*02+ SEGM*01, noBouclePud, SensUp);

 (** Emission invariants vers secteur 44 amont L0544 **)

   EmettreSegm(LigneL05+ L0543+ TRONC*01+ SEGM*00, noBoucleMoT, SensUp);
   EmettreSegm(LigneL05+ L0543+ TRONC*01+ SEGM*01, noBoucleMoT, SensUp);
   EmettreSegm(LigneL05+ L0543+ TRONC*01+ SEGM*02, noBoucleMoT, SensUp);

 (** troncon 1 **)        
   EmettreSegm(LigneL05+ L0543+ TRONC*01+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL05+ L0543+ TRONC*01+ SEGM*01, noBoucle1, SensUp);
   EmettreSegm(LigneL05+ L0543+ TRONC*01+ SEGM*02, noBoucle1, SensUp);
   EmettreSegm(LigneL05+ L0543+ TRONC*03+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL05+ L0543+ TRONC*08+ SEGM*00, noBoucle1, SensUp);

 (** troncon 2 **)        
   EmettreSegm(LigneL05+ L0543+ TRONC*02+ SEGM*00, noBoucle4, SensUp);
   EmettreSegm(LigneL05+ L0543+ TRONC*02+ SEGM*01, noBoucle4, SensUp);
   EmettreSegm(LigneL05+ L0543+ TRONC*04+ SEGM*00, noBoucle4, SensUp);

 (** troncon 3 **)  
   (* EmettreSegm(LigneL05+ L0543+ TRONC*03+ SEGM*00, noBoucle3, SensUp); *)
   EmettreSegm(LigneL05+ L0543+ TRONC*05+ SEGM*00, noBoucle3, SensUp);
   EmettreSegm(LigneL05+ L0543+ TRONC*05+ SEGM*01, noBoucle3, SensUp);

 (** troncon 4 **)  
   (* EmettreSegm(LigneL05+ L0543+ TRONC*04+ SEGM*00, noBoucle6, SensUp);  *)   
   EmettreSegm(LigneL05+ L0543+ TRONC*06+ SEGM*01, noBoucle6, SensUp); 
   EmettreSegm(LigneL05+ L0543+ TRONC*06+ SEGM*00, noBoucle6, SensUp);
   EmettreSegm(LigneL05+ L0543+ TRONC*06+ SEGM*02, noBoucle6, SensUp);

 (** troncon 5 **) 
   (*  EmettreSegm(LigneL05+ L0543+ TRONC*05+ SEGM*00, noBoucle2, SensUp); *)
   (*  EmettreSegm(LigneL05+ L0543+ TRONC*05+ SEGM*01, noBoucle2, SensUp); *)
   EmettreSegm(LigneL05+ L0542+ TRONC*01+ SEGM*00, noBoucle2, SensUp);

 (** troncon 6 **)  
   (* EmettreSegm(LigneL05+ L0543+ TRONC*06+ SEGM*00, noBoucle7, SensUp); *)
   EmettreSegm(LigneL05+ L0543+ TRONC*06+ SEGM*01, noBoucle7, SensUp); 
   EmettreSegm(LigneL05+ L0543+ TRONC*06+ SEGM*02, noBoucle7, SensUp); 
   EmettreSegm(LigneL05+ L0543+ TRONC*07+ SEGM*00, noBoucle7, SensUp);
   EmettreSegm(LigneL05+ L0544+ TRONC*02+ SEGM*00, noBoucle7, SensUp);
   EmettreSegm(LigneL05+ L0544+ TRONC*02+ SEGM*01, noBoucle7, SensUp);

 (** troncon 7 **) 
   EmettreSegm(LigneL05+ L0543+ TRONC*07+ SEGM*00, noBoucle8, SensUp); 
   EmettreSegm(LigneL05+ L0543+ TRONC*01+ SEGM*00, noBoucle8, SensUp); 
   EmettreSegm(LigneL05+ L0543+ TRONC*01+ SEGM*01, noBoucle8, SensUp); 
   EmettreSegm(LigneL05+ L0543+ TRONC*01+ SEGM*02, noBoucle8, SensUp); 
   EmettreSegm(LigneL05+ L0543+ TRONC*06+ SEGM*01, noBoucle8, SensUp); 

 (** troncon 8 **) 
   EmettreSegm(LigneL05+ L0543+ TRONC*08+ SEGM*00, noBoucle5, SensUp); 
   EmettreSegm(LigneL05+ L0543+ TRONC*06+ SEGM*02, noBoucle5, SensUp); 
     
 (* *)
(************************** CONFIGURATION DES TRONCONS TSR ***************************)

   ConfigurerTroncon(Tronc0, LigneL05 + L0543 + TRONC*01, 1,1,1,1);  (* troncon 43-1 *)
   ConfigurerTroncon(Tronc1, LigneL05 + L0543 + TRONC*02, 1,1,1,1);  (* troncon 43-2 *)
   ConfigurerTroncon(Tronc2, LigneL05 + L0543 + TRONC*03, 1,1,1,1);  (* troncon 43-3 *)
   ConfigurerTroncon(Tronc3, LigneL05 + L0543 + TRONC*04, 1,1,1,1);  (* troncon 43-4 *)
   ConfigurerTroncon(Tronc4, LigneL05 + L0543 + TRONC*05, 1,1,1,1);  (* troncon 43-5 *)
   ConfigurerTroncon(Tronc5, LigneL05 + L0543 + TRONC*06, 1,1,1,1);  (* troncon 43-6 *)
   ConfigurerTroncon(Tronc6, LigneL05 + L0543 + TRONC*07, 1,1,1,1);  (* troncon 43-7 *)
   ConfigurerTroncon(Tronc7, LigneL05 + L0543 + TRONC*08, 1,1,1,1);  (* troncon 43-8 *)

(******************************** EMISSION DES TSR ***********************************)

(** Emission des TSR vers le secteur aval 42 L0542 **)

   EmettreTronc(LigneL05+ L0543+ TRONC*02, noBouclePud, SensUp);


(** Emission des TSR vers le secteur amont 44 L0544 **)

   EmettreTronc(LigneL05+ L0543+ TRONC*01, noBoucleMoT, SensUp);


 (** Emission des TSR sur les troncons du secteur courant **)

   EmettreTronc(LigneL05+ L0543+ TRONC*01, noBoucle1, SensUp); (* troncon 43-1 *)
   EmettreTronc(LigneL05+ L0543+ TRONC*03, noBoucle1, SensUp);
   EmettreTronc(LigneL05+ L0543+ TRONC*08, noBoucle1, SensUp); 


   EmettreTronc(LigneL05+ L0543+ TRONC*02, noBoucle4, SensUp); (* troncon 43-2 *)
   EmettreTronc(LigneL05+ L0543+ TRONC*04, noBoucle4, SensUp);
   


   EmettreTronc(LigneL05+ L0543+ TRONC*03, noBoucle3, SensUp); (* troncon 43-3 *)
   EmettreTronc(LigneL05+ L0543+ TRONC*05, noBoucle3, SensUp);


   EmettreTronc(LigneL05+ L0543+ TRONC*04, noBoucle6, SensUp); (* troncon 43-4 *)
   EmettreTronc(LigneL05+ L0543+ TRONC*06, noBoucle6, SensUp);


   EmettreTronc(LigneL05+ L0543+ TRONC*05, noBoucle2, SensUp); (* troncon 43-5 *)
   EmettreTronc(LigneL05+ L0542+ TRONC*01, noBoucle2, SensUp);


   EmettreTronc(LigneL05+ L0543+ TRONC*06, noBoucle7, SensUp); (* troncon 43-6 *)
   EmettreTronc(LigneL05+ L0543+ TRONC*07, noBoucle7, SensUp); 
   EmettreTronc(LigneL05+ L0544+ TRONC*02, noBoucle7, SensUp);

                                                               (* troncon 43-7 *)
   EmettreTronc(LigneL05+ L0543+ TRONC*07, noBoucle8, SensUp);
   EmettreTronc(LigneL05+ L0543+ TRONC*01, noBoucle8, SensUp);
   EmettreTronc(LigneL05+ L0543+ TRONC*06, noBoucle8, SensUp);

                                                               (* troncon 43-8 *)
   EmettreTronc(LigneL05+ L0543+ TRONC*08, noBoucle5, SensUp);
   EmettreTronc(LigneL05+ L0543+ TRONC*06, noBoucle5, SensUp);


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

    StockAdres( ADR( SigLP20));
    StockAdres( ADR( SigLP10));
    StockAdres( ADR( SigLP22kv));
    StockAdres( ADR( SigLP22kj));
    StockAdres( ADR( SigLP24));
    StockAdres( ADR( SigLP12));
    StockAdres( ADR( CdvLP10));
    StockAdres( ADR( CdvLP11));
    StockAdres( ADR( CdvLP12B));
    StockAdres( ADR( CdvLP12A));
    StockAdres( ADR( CdvLP13));
    StockAdres( ADR( CdvLP14));
    StockAdres( ADR( CdvLP15));
    StockAdres( ADR( CdvLP20));

    StockAdres( ADR( CdvLP21));
    StockAdres( ADR( CdvLP22B));
    StockAdres( ADR( CdvLP22A));

    StockAdres( ADR( CdvLP24));
    StockAdres( ADR( CdvLP25));
    StockAdres( ADR( CdvLS20));
    StockAdres( ADR( CdvLS21)); 

    StockAdres( ADR( CdvLS22));
    StockAdres( ADR( CdvLS23));
    StockAdres( ADR( CdvLS10));

    StockAdres( ADR( CdvLS11));
    StockAdres( ADR( CdvLS12));
    StockAdres( ADR( CdvLS13));

    StockAdres( ADR( CdvBR20));
    StockAdres( ADR( CdvBR21));
    StockAdres( ADR( CdvBR22));
    StockAdres( ADR( CdvBR23));
    StockAdres( ADR( CdvBR10));
    StockAdres( ADR( CdvBR11));
    StockAdres( ADR( CdvBR12B));
    StockAdres( ADR( CdvBR12A));
    StockAdres( ADR( CdvBR13));
    StockAdres( ADR( CdvBR14));
    StockAdres( ADR( CdvBR15));
    StockAdres( ADR( CdvBR16));

    StockAdres( ADR( Sp1LP));
    StockAdres( ADR( Sp2LP));

    StockAdres( ADR( AigLP11_21));


    StockAdres( ADR( PtArrSigLP20));
    StockAdres( ADR( PtArrCdvLP10));
    StockAdres( ADR( PtArrCdvBR23));
    StockAdres( ADR( PtArrSigLP10));

    StockAdres( ADR( PtArrSpeLP12B));
    StockAdres( ADR( PtArrSpeLP20));
	
    StockAdres( ADR( PtArrSpeLP22));
    StockAdres( ADR( PtArrCdvLP13));
    StockAdres( ADR( PtArrCdvLP14));

    StockAdres( ADR( PtArrCdvLP15));
    StockAdres( ADR( PtArrCdvLS10));
    StockAdres( ADR( PtArrCdvLS11));

    StockAdres( ADR( PtArrCdvLS12));
    StockAdres( ADR( PtArrCdvLS13));
    StockAdres( ADR( PtArrCdvBR10));

    StockAdres( ADR( PtArrCdvBR11));
    StockAdres( ADR( PtArrCdvBR12A));
    StockAdres( ADR( PtArrCdvBR12B));
    StockAdres( ADR( PtArrCdvBR13));

    StockAdres( ADR( PtArrSigLP24));
    StockAdres( ADR( PtArrCdvBR14));

    StockAdres( ADR( PtArrSigLP22));
    StockAdres( ADR( PtArrCdvBR15));
    StockAdres( ADR( PtArrCdvBR16));


    StockAdres( ADR( PtArrCdvBR22));
    StockAdres( ADR( PtArrCdvBR21));
    StockAdres( ADR( PtArrCdvBR20));
    StockAdres( ADR( PtArrCdvLS23));
    StockAdres( ADR( PtArrCdvLS22));
    StockAdres( ADR( PtArrCdvLS21));
    StockAdres( ADR( PtArrCdvLS20));
    StockAdres( ADR( PtArrCdvLP25));
    StockAdres( ADR( PtArrSigLP24));
    StockAdres( ADR( PtArrSigLP12));

    
    StockAdres( ADR( PtAntCdvPUD10));
    StockAdres( ADR( PtAntSigPUD11));

    StockAdres( ADR( PtAntCdvMOT23));
    StockAdres( ADR( PtAntCdvMOT22));
    StockAdres( ADR( PtAntCdvMOT21));

    StockAdres( ADR( TivComSigLP22));
    
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
VAR BoolTr , BoolTr1 , BoolTr2 : BoolLD;

BEGIN (* ExeSpecific *)

(* Affectation des "constantes" utilisees dans la construction des messages emis    *)
(* et recus sur les boucles de transmission continue et sur les liens intersecteur. *)
(* Cette reaffectation est necessaire a chaque cycle pour la mise en securite.      *)
   AffectBoolC(Vrai, BoolPermissif)  ;
   AffectBoolC(Faux, BoolRestrictif) ;

(* regulation *)
   CdvLP12Fonc := CdvLP12B.F = Vrai.F;
   CdvLP22Fonc := CdvLP22A.F = Vrai.F;
   CdvLS22Fonc := CdvLS22.F = Vrai.F;
   CdvLS12Fonc := CdvLS12.F = Vrai.F;
   CdvBR22Fonc := CdvBR22.F = Vrai.F;
   CdvBR12Fonc := CdvBR12B.F = Vrai.F;

(****************************** FILTRAGE DES AIGUILLES *******************************)

   FiltrerAiguille( AigLP11_21, BaseExeAig);


(************************** Gerer les point d'arrets **************************)
   AffectBoolD( CdvLP10,                    PtArrCdvLP10);
   AffectBoolD( SigLP10,                    PtArrSigLP10);
   EtDD(        CdvLP12B,      CdvLP12A,    PtArrSpeLP12B);
   NonD(        Sp2LP,                      BoolTr);
   EtDD(        BoolTr,        CdvLP13,     PtArrCdvLP13);
   AffectBoolD( CdvLP14,                    PtArrCdvLP14);
   AffectBoolD( CdvLP15,                    PtArrCdvLP15);

   AffectBoolD( CdvLS10,                    PtArrCdvLS10);
   AffectBoolD( CdvLS11,                    PtArrCdvLS11);
   AffectBoolD( CdvLS12,                    PtArrCdvLS12);
   AffectBoolD( CdvLS13,                    PtArrCdvLS13);

   AffectBoolD( CdvBR10,                    PtArrCdvBR10);
   AffectBoolD( CdvBR11,                    PtArrCdvBR11);
   AffectBoolD( CdvBR12A,                   PtArrCdvBR12A);
   AffectBoolD( CdvBR12B,                   PtArrCdvBR12B);
   AffectBoolD( CdvBR13,                    PtArrCdvBR13);
   AffectBoolD( CdvBR14,                    PtArrCdvBR14);
   AffectBoolD( CdvBR15,                    PtArrCdvBR15);
   AffectBoolD( CdvBR16,                    PtArrCdvBR16);


   AffectBoolD( CdvBR23,                    PtArrCdvBR23);
   AffectBoolD( CdvBR22,                    PtArrCdvBR22);
   AffectBoolD( CdvBR21,                    PtArrCdvBR21);
   AffectBoolD( CdvBR20,                    PtArrCdvBR20);

   AffectBoolD( CdvLS23,                    PtArrCdvLS23);
   AffectBoolD( CdvLS22,                    PtArrCdvLS22);
   AffectBoolD( CdvLS21,                    PtArrCdvLS21);
   AffectBoolD( CdvLS20,                    PtArrCdvLS20);

   AffectBoolD( CdvLP25,                    PtArrCdvLP25);
   AffectBoolD( CdvLP24,                    PtArrCdvLP24);
   AffectBoolD( SigLP24,                    PtArrSigLP24);
   OuDD(        CdvLP21, AigLP11_21.PosReverseFiltree, BoolTr1); 
   EtDD(        CdvLP22A,      CdvLP22B,    BoolTr2); 
   EtDD(        BoolTr1,       BoolTr2,     PtArrSpeLP22);
   OuDD(        SigLP22kv,     SigLP22kj,   PtArrSigLP22);
   AffectBoolD( SigLP22kv,                  TivComSigLP22);

   NonD(        Sp1LP,                      PtArrSpeLP20 );

   AffectBoolD( SigLP20,                    PtArrSigLP20); 
   AffectBoolD( SigLP12,                    PtArrSigLP12); 

(*** lecture des entrees de regulation ***)

   LireEntreesRegul;

END ExeSpecific;
END Specific.
