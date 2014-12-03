IMPLEMENTATION MODULE Specific;

(*$S- *)
(*$T- *)

(******************************************************************************
*   SANTIAGO - LIGNE 1 - Secteur 31
*  =============================
*  Version :  1.0.0
*  Date    : 16/12/2009
*  Auteur  : Patrick Amsellem
*  Premiere Version
******************************************************************************)
(* Version 1.0.1  =====================                                      *)
(* Date :         08/01/2010                                                 *)
(* Auteur:        Patrick Amsellem                                           *)
(* Modification : Modification noms des variants anticipés du secteur 30     *)
(*****************************************************************************)
(* Version 1.0.2  =====================                                      *)
(* Date :         17/02/2010                                                 *)
(* Auteur:        Patrick Amsellem                                           *)
(* Modification : Modification du nom de la variable te15s31t02              *)
(* Modification : par te14s31t02                                   AM 167675 *)
(* Modification : OuDD( CdvLDO13B, AigLDO13.PosReverseFiltree, BoolTr);      *)
(* Modification : supprimer ligne ci-dessus                        AM 167680 *)
(* Modification : EtDD(        CdvLDO22A,     CdvLDO21,    BoolTr);          *)
(* Modification : supprimer ligne ci-dessus                        AM 167680 *)
(* Modification : Ajout PtArrCdvHMA11 emis vers le secteur 30                *)
(*****************************************************************************)
(* Version 1.0.3  =====================                                      *)
(* Version x.x   DU SERVEUR SCCS =====================                       *)
(* Date :         31/05/2010                                                 *)
(* Auteur:        Marc Plywacz                                               *)
(* Modifications : Prolongement 1                                            *)
(* Suppression des variables CdvMAN14                                        *)
(*---------------------------------------------------------------------------*)
(* Version 1.0.4  =====================                                      *)
(* Version x.x   DU SERVEUR SCCS =====================                       *)
(* Date :         14/06/2010                                                 *)
(* Auteur:        Marc Plywacz                                               *)
(* Modifications : Prolongement 1                                            *)
(* Remplace dans ProcReceptInterSecteur                                      *)
(* (trL0130, noBoucleEsM, LigneL01+ L0130+ TRONC*06 par                      *)
(* (trL0130, noBoucleEsM, LigneL01+ L0130+ TRONC*04                          *)
(*---------------------------------------------------------------------------*)
(* Version 1.0.5  =====================                                      *)
(* Version x.x   DU SERVEUR SCCS =====================                       *)
(* Date :         16/06/2010                                                 *)
(* Auteur:        Marc Plywacz                                               *)
(* Modifications : Prolongement 1                                            *)
(* Ajout condition aiguille 23 dans equation du PtArrSigLDO22B               *)
(*---------------------------------------------------------------------------*)
(* Version 1.0.6  =====================                                      *)
(* Version x.x   DU SERVEUR SCCS =====================                       *)
(* Date :         13/07/2010                                                 *)
(* Auteur:        Ph. Hog                                                    *)
(* Modifications : Prolongement 1                                            *)
(* Correction de la surveillance DAM (DamTc)                                 *)
(* Ajustage des marches types                                                *)
(*---------------------------------------------------------------------------*)


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

                  	Ampli11, Ampli12, Ampli13, Ampli14, Ampli15, Ampli16, Ampli17,
                  	Ampli21, Ampli22, Ampli23, Ampli24, Ampli25, Ampli26, Ampli27, Ampli28, Ampli29, Ampli2A,
                        Ampli2B, Ampli2C, Ampli2D,
                  	Ampli31, Ampli32, Ampli33, Ampli34, Ampli35, Ampli36, Ampli37,
                  	Ampli41, Ampli42, Ampli43, Ampli44, Ampli45, Ampli46, Ampli47, Ampli48, Ampli49, Ampli4A,
                  	Ampli51, Ampli52, Ampli53, Ampli54, Ampli55, Ampli56, Ampli57, Ampli58, Ampli59, Ampli5A, 
                        Ampli5B, Ampli5C, Ampli5D,



(* variables *)
                       Boucle1, Boucle2, Boucle3, Boucle4, Boucle5, BoucleFictive,
                       CarteCes1,  CarteCes2,  CarteCes3, CarteCes4, CarteCes5,CarteCes6,
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


    LigneL01 = 16384*00; (* numero de ligne decale de 2**14 *)

 (*   L01xx  = 1024*xx; *)    (* numero Secteur aval voie impaire decale de 2**10 *)

    L0131  = 1024*31;    (* numero Secteur local decale de 2**10 *)

    L0130  = 1024*30;    (* numero Secteur amont voie impaire decale de 2**10 *)

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
    noBoucleEsM = 01;
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

(* DECLARATION DES SINGULARITES DU SECTEUR 31 : dans les deux sens confondus *)

(* Declaration des variables correspondant a des entrees securitaires  *)
(*   - CDV et signaux                                                  *)
    CdvMAN15,      (* entree  1, soit entree 0 de CES 02  *)
    CdvMAN24,      (* entree  2, soit entree 1 de CES 02  *)
    CdvMAN25,      (* entree  3, soit entree 2 de CES 02  *)
    CdvMAN26,      (* entree  4, soit entree 3 de CES 02  *)
    CdvHMA10,      (* entree  5, soit entree 4 de CES 02  *)
    CdvHMA11,      (* entree  6, soit entree 5 de CES 02  *)
    CdvHMA12,      (* entree  7, soit entree 6 de CES 02  *)
    CdvHMA13,      (* entree  8, soit entree 7 de CES 02  *)
    
    CdvHMA14,      (* entree  9, soit entree 0 de CES 03  *)
    CdvHMA21A,     (* entree 10, soit entree 1 de CES 03  *)
    CdvHMA21B,     (* entree 11, soit entree 2 de CES 03  *)
    CdvHMA22,      (* entree 12, soit entree 3 de CES 03  *)
    CdvHMA23,      (* entree 13, soit entree 4 de CES 03  *)
    CdvHMA24,      (* entree 14, soit entree 5 de CES 03  *)
    CdvLDO10,      (* entree 15, soit entree 6 de CES 03  *)
    CdvLDO11,      (* entree 16, soit entree 7 de CES 03  *)

    CdvLDO12A,     (* entree 17, soit entree 0 de CES 04  *)
    CdvLDO12B,     (* entree 18, soit entree 1 de CES 04  *)
    CdvLDO13A,     (* entree 19, soit entree 2 de CES 04  *)
    CdvLDO13B,     (* entree 20, soit entree 3 de CES 04  *)
    CdvLDO14,      (* entree 21, soit entree 4 de CES 04  *)
    CdvLDO20,      (* entree 22, soit entree 5 de CES 04  *)
    CdvLDO21,      (* entree 23, soit entree 6 de CES 04  *)
    CdvLDO22A,     (* entree 24, soit entree 7 de CES 04  *)

    CdvLDO22B,     (* entree 25, soit entree 0 de CES 05  *)
    CdvLDO23A,     (* entree 26, soit entree 1 de CES 05  *)
    CdvLDO23B,     (* entree 27, soit entree 2 de CES 05  *)
    CdvLDO24,      (* entree 28, soit entree 3 de CES 05  *)
    SigLDO10kv,    (* entree 29, soit entree 4 de CES 05  *)
    SigLDO10kj,    (* entree 30, soit entree 5 de CES 05  *)
    SigLDO12,      (* entree 31, soit entree 6 de CES 05  *)
    SigLDO22A,   (* entree 32, soit entree 7 de CES 05  *)

    SigLDO22B,     (* entree 33, soit entree 0 de CES 06  *)
    SigLDO23,      (* entree 34, soit entree 1 de CES 06  *)
    SigLDO24A,     (* entree 35, soit entree 2 de CES 06  *)
    SigLDO14A,     (* entree 36, soit entree 3 de CES 06  *)
    SigMAN24      (* entree 37, soit entree 4 de CES 06  *)
    (* CdvMAN14  *)     (* entree 38, soit entree 5 de CES 06  *)

             : BoolD;

(*   - aiguilles                                                       *)
    AigLDO11,      (* entrees 41 et 42, soit entrees 0 et 1 de CES 07  *)
    AigLDO13       (* entrees 43 et 44, soit entrees 2 et 3 de CES 07  *)
             :TyAig;



(* Variables ne correspondant pas a une entree securitaire *)
(* Point d'arret *)
    PtArrCdvMAN15,
    PtArrCdvHMA10,
    PtArrCdvHMA11,

    PtArrCdvHMA12,
    PtArrCdvHMA13,
    PtArrCdvHMA14,
    PtArrCdvLDO10,
    PtArrSigLDO10,

    PtArrSpeLDO12,
    PtArrSigLDO12,
    PtArrSigLDO22B,

    PtArrSigLDO14A,
    PtArrSigLDO24A,
    PtArrSpeLDO23,
    PtArrSigLDO22A,
    PtArrCdvHMA24,

    PtArrCdvHMA23,
    PtArrCdvHMA22,
    PtArrCdvHMA21B,
    PtArrCdvHMA21A,
    PtArrCdvMAN26,
    PtArrCdvMAN25,
    PtArrCdvMAN24,
    PtArrSigMAN24  : BoolD;

(* Variants anticipes *)
    
    PtAntCdvMAN20,
    PtAntSpeMAN23  : BoolD;
    
(* Copie des entrees dans des variables fonctionnelles pour la regulation *)
    CdvLDO22Fonc,
    CdvHMA12Fonc,
    CdvHMA22Fonc     : BOOLEAN;

(** Voie d'emission SOL-TRAIN : deux sens confondus**)
    te11s31t01,
    te14s31t02,
    te21s31t03,
    te24s31t05,
    te31s31t04           :TyEmissionTele;

(** Voie d'emission Inter-secteur deux voies confondues **)
    teL0130,
    teL01fi	          :TyEmissionTele;

(** Voie de reception Inter-secteur deux voies confondues **)
    trL0130,
    trL01fi               :TyCaracEntSec;

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
    EntreeAiguille( AigLDO11, 42, 41);  (* kag D = pos normale *)
    EntreeAiguille( AigLDO13, 43, 44);  (* kag G = pos normale *)

(* Configuration des entrees *)

    ProcEntreeIntrins(  1, CdvMAN15);
    ProcEntreeIntrins(  2, CdvMAN24);
    ProcEntreeIntrins(  3, CdvMAN25);
    ProcEntreeIntrins(  4, CdvMAN26);
    ProcEntreeIntrins(  5, CdvHMA10);
    ProcEntreeIntrins(  6, CdvHMA11);
    ProcEntreeIntrins(  7, CdvHMA12);
    ProcEntreeIntrins(  8, CdvHMA13);

    ProcEntreeIntrins(  9, CdvHMA14);
    ProcEntreeIntrins( 10, CdvHMA21A);
    ProcEntreeIntrins( 11, CdvHMA21B);
    ProcEntreeIntrins( 12, CdvHMA22);
    ProcEntreeIntrins( 13, CdvHMA23);
    ProcEntreeIntrins( 14, CdvHMA24);
    ProcEntreeIntrins( 15, CdvLDO10);
    ProcEntreeIntrins( 16, CdvLDO11);

    ProcEntreeIntrins( 17, CdvLDO12A);
    ProcEntreeIntrins( 18, CdvLDO12B);
    ProcEntreeIntrins( 19, CdvLDO13A);
    ProcEntreeIntrins( 20, CdvLDO13B);
    ProcEntreeIntrins( 21, CdvLDO14);
    ProcEntreeIntrins( 22, CdvLDO20);
    ProcEntreeIntrins( 23, CdvLDO21);
    ProcEntreeIntrins( 24, CdvLDO22A);

    ProcEntreeIntrins( 25, CdvLDO22B);
    ProcEntreeIntrins( 26, CdvLDO23A);
    ProcEntreeIntrins( 27, CdvLDO23B);
    ProcEntreeIntrins( 28, CdvLDO24);
    ProcEntreeIntrins( 29, SigLDO10kv);
    ProcEntreeIntrins( 30, SigLDO10kj);
    ProcEntreeIntrins( 31, SigLDO12);
    ProcEntreeIntrins( 32, SigLDO22A);

    ProcEntreeIntrins( 33, SigLDO22B);
    ProcEntreeIntrins( 34, SigLDO23);
    ProcEntreeIntrins( 35, SigLDO24A);
    ProcEntreeIntrins( 36, SigLDO14A);
    ProcEntreeIntrins( 37, SigMAN24);
    (* ProcEntreeIntrins( 38, CdvMAN14); *)

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
   ConfigurerAmpli(Ampli16, 1, 6, 159, 13, FALSE);
   ConfigurerAmpli(Ampli17, 1, 7, 192, 13, TRUE);

   ConfigurerAmpli(Ampli21, 2, 1, 193, 14, FALSE);
   ConfigurerAmpli(Ampli22, 2, 2, 194, 15, FALSE);
   ConfigurerAmpli(Ampli23, 2, 3, 195, 15, FALSE);
   ConfigurerAmpli(Ampli24, 2, 4, 196, 15, TRUE);
   ConfigurerAmpli(Ampli25, 2, 5, 197, 16, FALSE);
   ConfigurerAmpli(Ampli26, 2, 6, 198, 16, FALSE);
   ConfigurerAmpli(Ampli27, 2, 7, 199, 16, TRUE);
   ConfigurerAmpli(Ampli28, 2, 8, 200, 17, FALSE);
   ConfigurerAmpli(Ampli29, 2, 9, 201, 17, FALSE);
   ConfigurerAmpli(Ampli2A, 2, 10, 202, 17, TRUE);
(*   ConfigurerAmpli(Ampli2B, 2, 11, 203, 18, FALSE); *)
(*   ConfigurerAmpli(Ampli2C, 2, 12, 204, 18, FALSE); *)
(*   ConfigurerAmpli(Ampli2D, 2, 13, 205, 18, TRUE);  *)

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
   ConfigurerAmpli(Ampli59, 5, 9, 221, 27, FALSE);
   ConfigurerAmpli(Ampli5A, 5, 10, 222, 27, TRUE);
(*   ConfigurerAmpli(Ampli5B, 5, 11, 223, 28, FALSE); *)
(*   ConfigurerAmpli(Ampli5C, 5, 12, 256, 28, FALSE); *)
(*   ConfigurerAmpli(Ampli5D, 5, 13, 257, 28, TRUE);  *)

   ConfigurerAmpli(Ampli41, 4, 1, 258, 31, FALSE);
   ConfigurerAmpli(Ampli42, 4, 2, 259, 32, FALSE);
   ConfigurerAmpli(Ampli43, 4, 3, 260, 32, FALSE);
   ConfigurerAmpli(Ampli44, 4, 4, 261, 32, TRUE);
   ConfigurerAmpli(Ampli45, 4, 5, 262, 33, FALSE);
   ConfigurerAmpli(Ampli46, 4, 6, 263, 33, FALSE);
   ConfigurerAmpli(Ampli47, 4, 7, 264, 33, TRUE);
   ConfigurerAmpli(Ampli48, 4, 8, 265, 34, FALSE);
(*   ConfigurerAmpli(Ampli49, 4, 9, 266, 34, FALSE); *)
   ConfigurerAmpli(Ampli4A, 4, 10, 267, 34, TRUE);


 (** cartes CES **)
   ConfigurerCES(CarteCes1, 01);
   ConfigurerCES(CarteCes2, 02);
   ConfigurerCES(CarteCes3, 03);
   ConfigurerCES(CarteCes4, 04);
   ConfigurerCES(CarteCes5, 05);
   ConfigurerCES(CarteCes6, 06);

(** Liaisons Inter-Secteur **)
(*  pas de liaison intersecteur vers aval *)
   ConfigurerIntsecteur(Intersecteur1, 01, trL01fi, trL0130);


(* Initialisations des variables ne correspondant pas a des entrees secu *)
(* Point d'arret *)

    AffectBoolD( BoolRestrictif, PtArrCdvMAN15);
    AffectBoolD( BoolRestrictif, PtArrCdvHMA10);
    AffectBoolD( BoolRestrictif, PtArrCdvHMA11);
    AffectBoolD( BoolRestrictif, PtArrCdvHMA12);
    AffectBoolD( BoolRestrictif, PtArrCdvHMA13);
    AffectBoolD( BoolRestrictif, PtArrCdvHMA14);
    AffectBoolD( BoolRestrictif, PtArrCdvLDO10);
    AffectBoolD( BoolRestrictif, PtArrSigLDO10);

    AffectBoolD( BoolRestrictif, PtArrSpeLDO12);
    AffectBoolD( BoolRestrictif, PtArrSigLDO12);
    AffectBoolD( BoolRestrictif, PtArrSigLDO22B);
    AffectBoolD( BoolRestrictif, PtArrSigLDO14A);
    AffectBoolD( BoolRestrictif, PtArrSigLDO24A);
    AffectBoolD( BoolRestrictif, PtArrSpeLDO23);
    AffectBoolD( BoolRestrictif, PtArrSigLDO22A);
    AffectBoolD( BoolRestrictif, PtArrCdvHMA24);
    AffectBoolD( BoolRestrictif, PtArrCdvHMA23);
    AffectBoolD( BoolRestrictif, PtArrCdvHMA22);
    AffectBoolD( BoolRestrictif, PtArrCdvHMA21B);
    AffectBoolD( BoolRestrictif, PtArrCdvHMA21A);
    AffectBoolD( BoolRestrictif, PtArrCdvMAN26);
    AffectBoolD( BoolRestrictif, PtArrCdvMAN25);
    AffectBoolD( BoolRestrictif, PtArrCdvMAN24);
    AffectBoolD( BoolRestrictif, PtArrSigMAN24);

(* Variants anticipes *)
    AffectBoolD( BoolRestrictif, PtAntSpeMAN23);
    AffectBoolD( BoolRestrictif, PtAntCdvMAN20);
        
(* Regulation *)
    CdvLDO22Fonc := FALSE;
    CdvHMA12Fonc := FALSE;
    CdvHMA22Fonc := FALSE;

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

   ConfigEmisTeleSolTrain ( te11s31t01,
                            noBoucle1,         
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);


   ConfigEmisTeleSolTrain ( te14s31t02,
                            noBoucle2,         
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);
   

     
   ConfigEmisTeleSolTrain ( te21s31t03,
                            noBoucle3,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);


   ConfigEmisTeleSolTrain ( te24s31t05,
                            noBoucle5,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);
 
   ConfigEmisTeleSolTrain ( te31s31t04,
                            noBoucle4,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);
 

(* CONFIGURATION POUR LA REGULATION *)
   ConfigQuai (27, 69, CdvLDO22Fonc, te31s31t04, 0, 3, 4, 5, 10, 13, 14, 15);
   ConfigQuai (26, 74, CdvHMA12Fonc, te11s31t01, 0, 8, 9, 5,  7, 13, 14, 15);
   ConfigQuai (26, 79, CdvHMA22Fonc, te24s31t05, 0, 2, 8, 9,  4, 13, 14, 15);


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
   ProcEmisSolTrain( te11s31t01.EmissionSensUp, (2*noBoucle1), 
                     LigneL01+ L0131+ TRONC*01,     

                  PtArrCdvMAN15,
                  PtArrCdvHMA10,
                  PtArrCdvHMA11,
                  PtArrCdvHMA12,
                  PtArrCdvHMA13,
                  PtArrCdvHMA14,
                  BoolRestrictif,
                  BoolRestrictif,
(* Variants Anticipes *)
              PtArrCdvLDO10,
		  PtArrSigLDO10,
		  BoolRestrictif,
		  AigLDO11.PosNormaleFiltree, (* tivcom *)
		  BoolRestrictif,
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
   ProcEmisSolTrain( te14s31t02.EmissionSensUp, (2*noBoucle2), 
                     LigneL01+ L0131+ TRONC*02,     

                  PtArrCdvLDO10,
                  PtArrSigLDO10,
                  BoolRestrictif,
                  AigLDO11.PosNormaleFiltree, (* tivcom *)
                  AigLDO11.PosReverseFiltree,
                  AigLDO11.PosNormaleFiltree,
                  PtArrSpeLDO12,
                  PtArrSigLDO12,
                  BoolRestrictif,               (* aspect croix *)
                  
	      (* Variants Anticipes *)
                  BoolRestrictif,
                  BoolRestrictif,               
                  PtArrSigLDO22B,
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
   ProcEmisSolTrain( te21s31t03.EmissionSensUp, (2*noBoucle3), 
                     LigneL01+ L0131+ TRONC*03,     

                  PtArrSigLDO22B,
                  BoolRestrictif,               (* aspect croix *)
                  AigLDO13.PosReverseFiltree,
                  AigLDO13.PosNormaleFiltree,
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
   ProcEmisSolTrain( te31s31t04.EmissionSensUp, (2*noBoucle4), 
                     LigneL01+ L0131+ TRONC*04,     

                  PtArrSigLDO14A,
                  BoolRestrictif,             (* aspect croix *)
                  PtArrSigLDO24A,
                  BoolRestrictif,             (* aspect croix *)
                  PtArrSpeLDO23,
                  PtArrSigLDO22A,			
                  BoolRestrictif,             (* aspect croix *)
                  BoolRestrictif,
(* Variants Anticipes *)
                  PtArrCdvHMA24,
                  PtArrCdvHMA23,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
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
   ProcEmisSolTrain( te24s31t05.EmissionSensUp, (2*noBoucle5), 
                     LigneL01+ L0131+ TRONC*05,     

                  PtArrCdvHMA24,
                  PtArrCdvHMA23,
                  PtArrCdvHMA22,
                  PtArrCdvHMA21B,			
                  PtArrCdvHMA21A,
                  PtArrCdvMAN26,
                  PtArrCdvMAN25,
                  PtArrCdvMAN24,
                  PtArrSigMAN24,
                  BoolRestrictif,             (* aspect croix *)
(* Variants Anticipes *)
                  PtAntSpeMAN23,
                  PtAntCdvMAN20,             (* aspect croix *)
                  BoolRestrictif,
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



(* reception du secteur 30 -amont- *)

   ProcReceptInterSecteur(trL0130, noBoucleEsM, LigneL01+ L0130+ TRONC*04,

                  PtAntSpeMAN23,
                  PtAntCdvMAN20,             
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif, 
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


(* emission vers le secteur XX -aval- inexistant *)




(* emission vers le secteur 30 -amont- Escuela Militar*)

   ProcEmisInterSecteur (teL0130, noBoucleEsM, LigneL01+ L0131+ TRONC*01,
			noBoucleEsM,
                  PtArrCdvMAN15,
                  PtArrCdvHMA10,
                  PtArrCdvHMA11,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif, 
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
            

 (** Emission invariants vers secteur xx aval L01xx **)

 (* pas de secteur aval *)


 (** Emission invariants vers secteur 30 amont L0130 **)

   EmettreSegm(LigneL01+ L0131+ TRONC*01+ SEGM*00, noBoucleEsM, SensUp);
   EmettreSegm(LigneL01+ L0131+ TRONC*01+ SEGM*01, noBoucleEsM, SensUp);


 (** Boucle 1 **)        
   EmettreSegm(LigneL01+ L0131+ TRONC*01+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL01+ L0131+ TRONC*01+ SEGM*01, noBoucle1, SensUp);
   EmettreSegm(LigneL01+ L0131+ TRONC*02+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL01+ L0131+ TRONC*02+ SEGM*01, noBoucle1, SensUp);

 (** Boucle 2 **)        
   EmettreSegm(LigneL01+ L0131+ TRONC*02+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL01+ L0131+ TRONC*02+ SEGM*01, noBoucle2, SensUp);
   EmettreSegm(LigneL01+ L0131+ TRONC*03+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL01+ L0131+ TRONC*03+ SEGM*01, noBoucle2, SensUp);
   EmettreSegm(LigneL01+ L0131+ TRONC*04+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL01+ L0131+ TRONC*04+ SEGM*01, noBoucle2, SensUp);

 (** Boucle 3 **)  
   EmettreSegm(LigneL01+ L0131+ TRONC*04+ SEGM*01, noBoucle3, SensUp);
   EmettreSegm(LigneL01+ L0131+ TRONC*02+ SEGM*01, noBoucle3, SensUp);
   EmettreSegm(LigneL01+ L0131+ TRONC*03+ SEGM*01, noBoucle3, SensUp);
   EmettreSegm(LigneL01+ L0131+ TRONC*03+ SEGM*00, noBoucle3, SensUp);

 (** Boucle 4 **)  
   EmettreSegm(LigneL01+ L0131+ TRONC*04+ SEGM*00, noBoucle4, SensUp);
   EmettreSegm(LigneL01+ L0131+ TRONC*04+ SEGM*01, noBoucle4, SensUp);
   EmettreSegm(LigneL01+ L0131+ TRONC*05+ SEGM*00, noBoucle4, SensUp);
   EmettreSegm(LigneL01+ L0131+ TRONC*05+ SEGM*01, noBoucle4, SensUp);
   EmettreSegm(LigneL01+ L0131+ TRONC*05+ SEGM*02, noBoucle4, SensUp);
   EmettreSegm(LigneL01+ L0131+ TRONC*03+ SEGM*00, noBoucle4, SensUp);

 (** Boucle 5 **) 
   EmettreSegm(LigneL01+ L0131+ TRONC*05+ SEGM*00, noBoucle5, SensUp);
   EmettreSegm(LigneL01+ L0131+ TRONC*05+ SEGM*01, noBoucle5, SensUp);
   EmettreSegm(LigneL01+ L0131+ TRONC*05+ SEGM*02, noBoucle5, SensUp);
   EmettreSegm(LigneL01+ L0130+ TRONC*06+ SEGM*00, noBoucle5, SensUp);
   EmettreSegm(LigneL01+ L0130+ TRONC*06+ SEGM*01, noBoucle5, SensUp);

 (* *)
(************************** CONFIGURATION DES TRONCONS TSR ***************************)

   ConfigurerTroncon(Tronc0, LigneL01 + L0131 + TRONC*01, 2,2,2,2);  (* troncon 31-1 *)
   ConfigurerTroncon(Tronc1, LigneL01 + L0131 + TRONC*02, 2,2,2,2);  (* troncon 31-2 *)
   ConfigurerTroncon(Tronc2, LigneL01 + L0131 + TRONC*03, 2,2,2,2);  (* troncon 31-3 *)
   ConfigurerTroncon(Tronc3, LigneL01 + L0131 + TRONC*04, 2,2,2,2);  (* troncon 31-4 *)
   ConfigurerTroncon(Tronc4, LigneL01 + L0131 + TRONC*05, 2,2,2,2);  (* troncon 31-5 *)


(******************************** EMISSION DES TSR ***********************************)

(** Emission des TSR vers le secteur aval xx L01xx **)



(** Emission des TSR vers le secteur amont 30 L0130 **)

   EmettreTronc(LigneL01+ L0131+ TRONC*01, noBoucleEsM, SensUp);


 (** Emission des TSR sur les troncons du secteur courant **)

   EmettreTronc(LigneL01+ L0131+ TRONC*01, noBoucle1, SensUp); (* troncon 31-1 *)
   EmettreTronc(LigneL01+ L0131+ TRONC*02, noBoucle1, SensUp);


   EmettreTronc(LigneL01+ L0131+ TRONC*02, noBoucle2, SensUp); (* troncon 31-2 *)
   EmettreTronc(LigneL01+ L0131+ TRONC*03, noBoucle2, SensUp);
   EmettreTronc(LigneL01+ L0131+ TRONC*04, noBoucle2, SensUp);


   EmettreTronc(LigneL01+ L0131+ TRONC*02, noBoucle3, SensUp); (* troncon 31-3 *)
   EmettreTronc(LigneL01+ L0131+ TRONC*04, noBoucle3, SensUp);
   EmettreTronc(LigneL01+ L0131+ TRONC*03, noBoucle3, SensUp);


   EmettreTronc(LigneL01+ L0131+ TRONC*04, noBoucle4, SensUp); (* troncon 31-4 *)
   EmettreTronc(LigneL01+ L0131+ TRONC*05, noBoucle4, SensUp);
   EmettreTronc(LigneL01+ L0131+ TRONC*03, noBoucle4, SensUp);


   EmettreTronc(LigneL01+ L0131+ TRONC*05, noBoucle5, SensUp); (* troncon 31-5 *)
   EmettreTronc(LigneL01+ L0130+ TRONC*06, noBoucle5, SensUp);


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
    StockAdres( ADR( CdvMAN15));
    StockAdres( ADR( CdvMAN24));
    StockAdres( ADR( CdvMAN25));
    StockAdres( ADR( CdvMAN26));
    StockAdres( ADR( CdvHMA10));
    StockAdres( ADR( CdvHMA11));
    StockAdres( ADR( CdvHMA12));
    StockAdres( ADR( CdvHMA13));
    StockAdres( ADR( CdvHMA14));
    StockAdres( ADR( CdvHMA21A));
    StockAdres( ADR( CdvHMA21B));
    StockAdres( ADR( CdvHMA22));
    StockAdres( ADR( CdvHMA23));
    StockAdres( ADR( CdvHMA24));
    StockAdres( ADR( CdvLDO10));
    StockAdres( ADR( CdvLDO11));
    StockAdres( ADR( CdvLDO12A));
    StockAdres( ADR( CdvLDO12B));
    StockAdres( ADR( CdvLDO13A));
    StockAdres( ADR( CdvLDO13B));
    StockAdres( ADR( CdvLDO14));
    StockAdres( ADR( CdvLDO20));
    StockAdres( ADR( CdvLDO21));
    StockAdres( ADR( CdvLDO22A));
    StockAdres( ADR( CdvLDO22B));   
    StockAdres( ADR( CdvLDO23A));
    StockAdres( ADR( CdvLDO23B));
    StockAdres( ADR( CdvLDO24));
    StockAdres( ADR( SigLDO10kv));
    StockAdres( ADR( SigLDO10kj));
    StockAdres( ADR( SigLDO12));
    StockAdres( ADR( SigLDO22A));
    StockAdres( ADR( SigLDO22B));
    StockAdres( ADR( SigLDO23));
    StockAdres( ADR( SigLDO24A));
    StockAdres( ADR( SigLDO14A));
    StockAdres( ADR( SigMAN24));
    (* StockAdres( ADR( CdvMAN14)); *)
    StockAdres( ADR( AigLDO11));
    StockAdres( ADR( AigLDO13));

    StockAdres( ADR( PtArrCdvMAN15));
    StockAdres( ADR( PtArrCdvHMA10));
    StockAdres( ADR( PtArrCdvHMA11));
    StockAdres( ADR( PtArrCdvHMA12));
    StockAdres( ADR( PtArrCdvHMA13));
    StockAdres( ADR( PtArrCdvHMA14));
    StockAdres( ADR( PtArrCdvLDO10));
    StockAdres( ADR( PtArrSigLDO10));
    StockAdres( ADR( PtArrSpeLDO12));
    StockAdres( ADR( PtArrSigLDO12));
    StockAdres( ADR( PtArrSigLDO22B));
    StockAdres( ADR( PtArrSigLDO14A));
    StockAdres( ADR( PtArrSigLDO24A));
    StockAdres( ADR( PtArrSpeLDO23));
    StockAdres( ADR( PtArrSigLDO22A));
    StockAdres( ADR( PtArrCdvHMA24));
    StockAdres( ADR( PtArrCdvHMA23));
    StockAdres( ADR( PtArrCdvHMA22));
    StockAdres( ADR( PtArrCdvHMA21B));
    StockAdres( ADR( PtArrCdvHMA21A));
    StockAdres( ADR( PtArrCdvMAN26));
    StockAdres( ADR( PtArrCdvMAN25));
    StockAdres( ADR( PtArrCdvMAN24));
    StockAdres( ADR( PtArrSigMAN24));

    StockAdres( ADR( PtAntSpeMAN23));
    StockAdres( ADR( PtAntCdvMAN20));
    
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
   CdvLDO22Fonc := CdvLDO22A.F = Vrai.F;
   CdvHMA12Fonc := CdvHMA12.F = Vrai.F;
   CdvHMA22Fonc := CdvHMA22.F = Vrai.F;


(****************************** FILTRAGE DES AIGUILLES *******************************)

   FiltrerAiguille( AigLDO11, BaseExeAig);
   FiltrerAiguille( AigLDO13, BaseExeAig+2);


(************************** Gerer les point d'arrets **************************)
      
   
   AffectBoolD( CdvMAN15,                   PtArrCdvMAN15);
   AffectBoolD( CdvHMA10,                   PtArrCdvHMA10);
   AffectBoolD( CdvHMA11,                   PtArrCdvHMA11);
   AffectBoolD( CdvHMA12,                   PtArrCdvHMA12);
   AffectBoolD( CdvHMA13,                   PtArrCdvHMA13);
   AffectBoolD( CdvHMA14,                   PtArrCdvHMA14);
   AffectBoolD( CdvLDO10,                   PtArrCdvLDO10);

   OuDD(        SigLDO10kv,   SigLDO10kj,   PtArrSigLDO10);

   
   EtDD( CdvLDO12B, CdvLDO13A,                     PtArrSpeLDO12);

   AffectBoolD( SigLDO12,                   PtArrSigLDO12);

   (* AffectBoolD( SigLDO22B,                  PtArrSigLDO22B); *)
   EtDD(SigLDO22B, AigLDO13.PosReverseFiltree, PtArrSigLDO22B);

   AffectBoolD( SigLDO14A,                  PtArrSigLDO14A);
   AffectBoolD( SigLDO24A,                  PtArrSigLDO24A);
   

  
   AffectBoolD(SigLDO23,                    PtArrSpeLDO23);

   
   AffectBoolD( SigLDO22A,                  PtArrSigLDO22A);

   AffectBoolD( CdvHMA24,                   PtArrCdvHMA24);

   AffectBoolD( CdvHMA23,                   PtArrCdvHMA23);
   AffectBoolD( CdvHMA22,                   PtArrCdvHMA22);
   AffectBoolD( CdvHMA21B,                  PtArrCdvHMA21B);
   AffectBoolD( CdvHMA21A,                  PtArrCdvHMA21A);
   AffectBoolD( CdvMAN26,                   PtArrCdvMAN26);
   AffectBoolD( CdvMAN25,                   PtArrCdvMAN25);
   AffectBoolD( CdvMAN24,                   PtArrCdvMAN24);
   AffectBoolD( SigMAN24,                   PtArrSigMAN24);

(*** lecture des entrees de regulation ***)

   LireEntreesRegul;

END ExeSpecific;
END Specific.
