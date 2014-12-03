IMPLEMENTATION MODULE Specific;

(*$S- *)
(*$T- *)

(******************************************************************************
*   SANTIAGO - LIGNE 2 - Secteur 11
*  =============================
*  Version : SCCS 1.0
*  Date    : 13/03/1997
*  Auteur  : Marc Plywacz
*  Premiere Version
******************************************************************************)

(* !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! *
 * ATTENTION : l'etat du PtArrCdvCAL12 est   *
 * calcule mais pas utilise.                 *
 * ATTENTION : l'etat du PtArrCdvCAL22 est   *
 * calcule mais pas utilise.                 *
 * ATTENTION : le CdvCAL12 est ajoute sur    *
 * l'entree 28.                              *
 * ATTENTION : le CdvCAL21 est ajoute sur    *
 * l'entree 29.                              *
 * !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!! *)

(* Date : 11/09/1997
   Version : 1.0.1
   Auteur : F. Chanier
   Nature : fiche Gauvin 0009 - erreur dans la config de la boucle 3 *)

(* date : 23/01/1998
   Version : 1.0.2
   Auteur : F. Chanier
   Nature : modification pour detection alarme CEM - CEF
	    + rajout de l'EP : on rajoute une info sur le troncon 4 liee
			       a l'etat du cdv 12 et (cdv13 ou Aig23 dev)) *)
(*---------------------------------------------------------------------------*)
(*****************************************************************************)
(***            AJOUT DE LA NUMEROTATION SCCS DES VERSIONS                ****)
(*---------------------------------------------------------------------------*)
(* Version 1.0.3  =====================                                      *)
(* Version 1.5 DU SERVEUR SCCS =====================                         *)
(* Date :         21/09/1998                                                 *)
(* Auteur:        H. Le Roy                                                  *)
(* Modification : Fiche d'anomalie ba040998                                  *)
(*                Suite a un changement de vitesses maximales, mise a jour   *)
(*                des marches types                                          *)
(*****************************************************************************)
(* Version 1.0.4  =====================                                      *)
(* Version 1.6 DU SERVEUR SCCS =====================                         *)
(* Date :         03/12/1998                                                 *)
(* Auteur:        H. Le Roy                                                  *)
(* Modification : Emission de segment et troncon correspondant a l'ajout     *)
(*                  d'un retournement pour manoeuvre 14-22-24                *)
(*****************************************************************************)
(* Version 1.0.5  =====================                                      *)
(* Version 1.7 DU SERVEUR SCCS =====================                         *)
(* Date :         14/04/1999                                                 *)
(* Auteur:        H. Le Roy                                                  *)
(* Modification : Adaptation de la configuration des amplis au standard      *)
(*                 1.3.3. Ajout d'entrees pour fusibles. Suppression de      *)
(*                 parties de code inutiles concernant les DAMTC.            *)
(*****************************************************************************)
(* Version 1.0.6  =====================                                      *)
(* Version 1.8 DU SERVEUR SCCS =====================                         *)
(* Date :         20/04/1999                                                 *)
(* Auteur:        H. Le Roy                                                  *)
(* Modification : correction de la configuration des fusible                 *)
(*****************************************************************************)
(* Version 1.0.7  =====================                                      *)
(* Version 1.9 DU SERVEUR SCCS =====================                         *)
(* Date :         14/03/2000                                                 *)
(* Auteur:        H. Le Roy                                                  *)
(* Modification : Am dev022000-1 : L'aiguille 09 du secteur 12 est anticipee *)
(*                 sur le troncon 2 pour augmenter la distance de visibilite *)
(*****************************************************************************)
(* Version 1.0.8  =====================                                      *)
(* Version 1.10 DU SERVEUR SCCS =====================                        *)
(* Date :         27/06/2000                                                 *)
(* Auteur:        H. Le Roy                                                  *)
(* Modification : Am165 : Configuration des marches types.                   *)
(*                                                                           *)
(*****************************************************************************)
(* Version 1.0.9  =====================                                      *)
(* Version 1.11 DU SERVEUR SCCS =====================                        *)
(* Date :         22/01/2004                                                 *)
(* Auteur:        Marc Plywacz                                               *)
(* Modification : Prolongement 1 de la ligne 2.                              *)
(*                                                                           *)
(*****************************************************************************)
(* Version 1.1.0  =====================                                      *)
(* Version 1.12 DU SERVEUR SCCS =====================                        *)
(* Date :         02/07/2004                                                 *)
(* Auteur:        Marc Plywacz                                               *)
(* Modification : Am    : Rapport Validation                                 *)
(*              - Voie d'emission Inter-secteur / teL0212, noBoucleCeB  /    *)
(*                remplacee par                 / teL0218, noBoucleCeB  /    *)
(*              - Ajoute AffectBoolD(CdvCAL10, PtArrCdvCAL10);               *)
(* Modification : demandes site                                              *)
(*              - Variants Troncon 11.6 : supprime arret / PtArrCdvCAL19 /   *)
(*              - Entree Secu 27 = cdv12A & cdv12B                           *)
(*****************************************************************************)
(* Version 1.1.1  =====================                                      *)
(* Version 1.13 DU SERVEUR SCCS =====================                        *)
(* Date :         15/07/2004                                                 *)
(* Auteur:        Marc Plywacz                                               *)
(* Modification : demandes site                                              *)
(*              - Equation PtArrSpeCAL13 = NonD Sp2CAL                       *)
(*              - Equation PtArrSpeCAL19 = NonD Sp1CAL                       *)
(*              - Entree Secu 21 = SigCAL22kv                                *)
(*              - Entree Secu 22 = SigCAL22kj                                *)
(*****************************************************************************)
(* Version 1.1.2  =====================                                      *)
(* Version 1.14 DU SERVEUR SCCS =====================                        *)
(* Date :         23/07/2004                                                 *)
(* Auteur:        Ph. Hog                                                    *)
(* Modification : demandes site                                              *)
(*              - Inversion des entrees SP1 et SP2                           *)
(*                SP1 passe de entree 34 (CES06.1) a entree 35 (CES06.2)     *)
(*                SP2 passe de entree 35 (CES06.2) a entree 34 (CES06.1)     *)
(*****************************************************************************)
(* Version 1.1.3  =====================                                      *)
(* Version 1.15 DU SERVEUR SCCS =====================                        *)
(* Date :         16/08/2004                                                 *)
(* Auteur:        Marc Plywacz                                               *)
(* Modification : Ajustement marches types                                   *)
(*              - Variants Troncon 11.6 : remis arret / PtArrCdvCAL19 /      *)
(*****************************************************************************)
(* Version 1.1.4  =====================                                      *)
(* Version 1.16 DU SERVEUR SCCS =====================                        *)
(* Date :         06/12/2004                                                 *)
(* Auteur:        Marc Plywacz                                               *)
(* Modification : Modif rangs variants                                       *)
(*              - Troncon 11.6 : PtArrSpeCAL19 passe devant PtArrCdvCAL19    *)
(*              - Troncon 11.5 : PtArrSpeCAL19 passe devant PtArrCdvCAL19    *)
(*              - Troncon 11.4 : PtArrSpeCAL19 passe devant PtArrCdvCAL19    *)
(*****************************************************************************)
(* Version 1.1.5  =====================                                      *)
(* Version 1.17 DU SERVEUR SCCS =====================                        *)
(* Date :         16/03/2005                                                 *)
(* Auteur:        Marc Plywacz                                               *)
(* Modification : CdvCAL12 est remplacee par CdvCAL12A ou CdvCAL12B          *)
(*                Modif  variants                                            *)
(*              - Troncon 11.1 : PtArrCdvCAL12 devient PtArrSpeCAL12         *)
(*                               conditions = CdvCAL12B & CdvCAL13           *)
(*****************************************************************************)
(* Version 1.1.6  =====================                                      *)
(* Version 1.18 DU SERVEUR SCCS =====================                        *)
(* Date :         07/08/2006                                                 *)
(* Auteur:        Rudy Nsiona                                                *)
(* Modification : Nouveau Train NS2004                                       *)
(* Procédure CONFIGURATION DES TRONCONS TSR                                  *)
(*                ancienne valeur 1 , nouvelle 2                             *)


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

                  	Ampli11, Ampli12, Ampli13, Ampli14, Ampli15, Ampli16, Ampli17, Ampli18,
                  	Ampli21, Ampli22, Ampli23, Ampli24, Ampli25,
                  	Ampli31, Ampli32, Ampli33, Ampli34, Ampli35, Ampli36, Ampli37,
                  	Ampli41, Ampli42, Ampli43, Ampli44, Ampli45, Ampli46, Ampli47,    
                  	Ampli51, Ampli52, Ampli53, Ampli54,
                  	Ampli61, Ampli62, Ampli63, Ampli64,                 
                  	Ampli71, Ampli72, Ampli73, Ampli74,                


(* variables *)
                       Boucle1, Boucle2, Boucle3, Boucle4, Boucle5, Boucle6, Boucle7, BoucleFictive,
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

    L0212  = 1024*12;     (* numero Secteur aval voie impaire decale de 2**10 *)

    L0211  = 1024*11;    (* numero Secteur local decale de 2**10 *)

    L0218  = 1024*18;    (* numero Secteur amont voie impaire decale de 2**10 *)

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

(** No des stations du secteur 11 **)
(* ligne 1: 1,2 ; ligne 2: 3,4; ligne 5: 5,6 *)
    noCALv1 = 3*32 + 1;
    noCALv2 = 3*32 + 13;
    noANAv1 = 3*32 + 2;
    noANAv2 = 3*32 + 12;

(** indication de sens **)
    SensUp = TRUE;

(** No de Voie d'emissions SOL-Train, d'emission/reception inter-secteur **)
    noBoucleHer = 00; 
    noBoucleCeB = 01;
    noBouclefi = 02; (* boucle fictive *)
    noBoucle1 = 03;
    noBoucle2 = 04;
    noBoucle3 = 05;
    noBoucle4 = 06;
    noBoucle5 = 07;
    noBoucle6 = 08;
    noBoucle7 = 09;

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

(* DECLARATION DES SINGULARITES DU SECTEUR 11 : dans les deux sens confondus *)

(* Declaration des variables correspondant a des entrees securitaires  *)
(*   - CDV et signaux                                                  *)
    SigCAL20,      (* entree  1, soit entree 0 de CES 02  *)
    SigCAL10,      (* entree  2, soit entree 1 de CES 02  *)
  (* reserve, *)   (* entree  5, soit entree 4 de CES 02  *)
    CdvCAL15,      (* entree  6, soit entree 5 de CES 02  *)
    CdvCAL16,      (* entree  7, soit entree 6 de CES 02  *)
    CdvANA10,      (* entree  8, soit entree 7 de CES 02  *)
    CdvANA11,      (* entree  9, soit entree 0 de CES 03  *)
    CdvANA12,      (* entree 10, soit entree 1 de CES 03  *)
    CdvANA22,      (* entree 11, soit entree 2 de CES 03  *)
    CdvANA21,      (* entree 12, soit entree 3 de CES 03  *)
    CdvANA20,      (* entree 13, soit entree 4 de CES 03  *)
    CdvCAL26,      (* entree 14, soit entree 5 de CES 03  *)
    CdvCAL25,      (* entree 15, soit entree 6 de CES 03  *)
    CdvCAL24,      (* entree 16, soit entree 7 de CES 03  *)
    SigCAL24,      (* entree 17, soit entree 0 de CES 04  *)
  (* reserve, *)   (* entree 18, soit entree 1 de CES 04  *)
    SigCAL22kv,    (* entree 21, soit entree 4 de CES 04  *)
    SigCAL22kj,    (* entree 22, soit entree 4 de CES 04  *)
    SigCAL12,      (* entree 23, soit entree 6 de CES 04  *)
    CdvCAL10,      (* entree 24, soit entree 7 de CES 04  *)
    CdvCAL21,      (* entree 25, soit entree 0 de CES 05  *)
    CdvCAL23,      (* entree 26, soit entree 1 de CES 05  *)
  (* CdvCAL12, *)     (* entree 27, soit entree 2 de CES 05  *)
    CdvCAL22,      (* entree 28, soit entree 3 de CES 05  *)
    CdvCAL13,      (* entree 29, soit entree 4 de CES 05  *)
    CdvCAL14,      (* entree 30, soit entree 5 de CES 05  *)
    CdvCAL12A,     (* entree 31, soit entree 6 de CES 05  *)
    CdvCAL12B,     (* entree 32, soit entree 7 de CES 05  *)
    CdvCAL19,      (* entree 33, soit entree 0 de CES 06  *)
    Sp2CAL,        (* entree 34, soit entree 1 de CES 06  *)
    Sp1CAL         (* entree 35, soit entree 2 de CES 06  *)
             : BoolD;

(*   - aiguilles                                                        *)
    AigCAL11_21      (* entrees  3 et  4, soit entrees 2 et 3 de CES 02 *)
             :TyAig;


(* Variables ne correspondant pas a une entree securitaire *)
(* Point d'arret *)

    PtArrSigCAL20,
    PtArrCdvCAL10,
    PtArrSigCAL10,
    PtArrSpeCAL12,
    PtArrSpeCAL13,
    PtArrCdvCAL14,
    PtArrCdvCAL15,
    PtArrCdvCAL16,
    PtArrCdvANA10,
    PtArrCdvANA11,
    PtArrCdvANA12,

    PtArrCdvANA22,
    PtArrCdvANA21,
    PtArrCdvANA20,
    PtArrCdvCAL26,
    PtArrCdvCAL24,
    PtArrSigCAL24,
    PtArrCdvCAL22,
    PtArrSigCAL22,

    PtArrCdvCAL19,
    PtArrSpeCAL19,

    PtArrSigCAL12 : BoolD;


 (* Tiv Com *)
    TivComSigANA22 : BoolD;
    
(* Variants anticipes *)
    PtAntCdvCEB22,
    PtAntCdvCEB23,
    PtAntCdvCEB10,

    PtAntCdvHEB08,
    PtAntSigHEB08,
    TivAntHEB09    : BoolD;

    AigAntHEB09    : TyAigNonLue;
    
(* Copie des entrees dans des variables fonctionnelles pour la regulation *)
    CdvCAL12Fonc,
    CdvCAL22Fonc,
    CdvANA12Fonc,
    CdvANA22Fonc     : BOOLEAN;

(** Voie d'emission SOL-TRAIN : deux sens confondus**)
    te11s11t01,
    te15s11t02,
    te21s11t03,
    te24s11t04,
    te27s11t05,
    te31s11t06,
    te34s11t07           :TyEmissionTele;

(** Voie d'emission Inter-secteur deux voies confondues **)
    teL0212,
    teL0218,
    teL02fi	          :TyEmissionTele;

(** Voie de reception Inter-secteur deux voies confondues **)
    trL0212,
    trL0218,
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
    EntreeAiguille( AigCAL11_21,  3,  4);  (* kag G = pos normale *)

(* Configuration des entrees *)
    ProcEntreeIntrins(  1, SigCAL20);
    ProcEntreeIntrins(  2, SigCAL10);

    ProcEntreeIntrins(  6, CdvCAL15);
    ProcEntreeIntrins(  7, CdvCAL16);
    ProcEntreeIntrins(  8, CdvANA10);
    ProcEntreeIntrins(  9, CdvANA11);
    ProcEntreeIntrins( 10, CdvANA12);
    ProcEntreeIntrins( 11, CdvANA22);
    ProcEntreeIntrins( 12, CdvANA21);
    ProcEntreeIntrins( 13, CdvANA20);
    ProcEntreeIntrins( 14, CdvCAL26);
    ProcEntreeIntrins( 15, CdvCAL25);
    ProcEntreeIntrins( 16, CdvCAL24);
    ProcEntreeIntrins( 17, SigCAL24);

    ProcEntreeIntrins( 21, SigCAL22kv);
    ProcEntreeIntrins( 22, SigCAL22kj);
    ProcEntreeIntrins( 23, SigCAL12);
    ProcEntreeIntrins( 24, CdvCAL10);
    ProcEntreeIntrins( 25, CdvCAL21);
    ProcEntreeIntrins( 26, CdvCAL23);
 (*   ProcEntreeIntrins( 27, CdvCAL12); *)

    ProcEntreeIntrins( 28, CdvCAL22);
    ProcEntreeIntrins( 29, CdvCAL13);
    ProcEntreeIntrins( 30, CdvCAL14);
    ProcEntreeIntrins( 31, CdvCAL12A);
    ProcEntreeIntrins( 32, CdvCAL12B);
    ProcEntreeIntrins( 33, CdvCAL19);
    ProcEntreeIntrins( 34, Sp2CAL);
    ProcEntreeIntrins( 35, Sp1CAL);


(* CONFIGURATION POUR LA MAINTENANCE de la transmission continue *)
   ConfigurerBoucle(Boucle1, 1);
   ConfigurerBoucle(Boucle2, 2);
(* C+ : modif de la fiche gauvin n 0009 *)
   ConfigurerBoucle(Boucle3, 3);
   ConfigurerBoucle(Boucle4, 4);
   ConfigurerBoucle(Boucle5, 5);
   ConfigurerBoucle(Boucle6, 6);
   ConfigurerBoucle(Boucle7, 7);


   ConfigurerAmpli(Ampli11, 1, 1, 154, 11, FALSE);
   ConfigurerAmpli(Ampli12, 1, 2, 155, 12, FALSE);
   ConfigurerAmpli(Ampli13, 1, 3, 156, 12, FALSE);
   ConfigurerAmpli(Ampli14, 1, 4, 157, 12, TRUE);
   ConfigurerAmpli(Ampli15, 1, 5, 158, 13, FALSE); 
   ConfigurerAmpli(Ampli16, 1, 6, 159, 13, FALSE);
   ConfigurerAmpli(Ampli17, 1, 7, 192, 13, TRUE);
   ConfigurerAmpli(Ampli18, 1, 8, 193, 14, FALSE);   

   ConfigurerAmpli(Ampli21, 2, 1, 196, 15, FALSE);
   ConfigurerAmpli(Ampli22, 2, 2, 197, 16, FALSE);
   ConfigurerAmpli(Ampli23, 2, 3, 198, 16, FALSE);
   ConfigurerAmpli(Ampli24, 2, 4, 199, 16, TRUE);
   ConfigurerAmpli(Ampli25, 2, 5, 194, 14, TRUE); 

   ConfigurerAmpli(Ampli31, 3, 1, 200, 21, FALSE);
   ConfigurerAmpli(Ampli32, 3, 2, 201, 22, FALSE);
   ConfigurerAmpli(Ampli33, 3, 3, 202, 22, FALSE);
   ConfigurerAmpli(Ampli34, 3, 4, 203, 22, TRUE);
   ConfigurerAmpli(Ampli35, 3, 5, 204, 23, FALSE); 
   ConfigurerAmpli(Ampli36, 3, 6, 205, 23, FALSE);    
   ConfigurerAmpli(Ampli37, 3, 7, 206, 23, TRUE);

   ConfigurerAmpli(Ampli41, 4, 1, 207, 24, FALSE);
   ConfigurerAmpli(Ampli42, 4, 2, 208, 25, FALSE);
   ConfigurerAmpli(Ampli43, 4, 3, 209, 25, FALSE);
   ConfigurerAmpli(Ampli44, 4, 4, 210, 25, TRUE);

   ConfigurerAmpli(Ampli51, 5, 1, 214, 27, FALSE);
   ConfigurerAmpli(Ampli52, 5, 2, 215, 28, FALSE);
   ConfigurerAmpli(Ampli53, 5, 3, 216, 28, FALSE);
   ConfigurerAmpli(Ampli54, 5, 4, 217, 28, TRUE);

   ConfigurerAmpli(Ampli61, 6, 1, 218, 31, FALSE);
   ConfigurerAmpli(Ampli62, 6, 2, 219, 32, FALSE);
   ConfigurerAmpli(Ampli63, 6, 3, 220, 32, FALSE);
   ConfigurerAmpli(Ampli64, 6, 4, 221, 32, TRUE);

   ConfigurerAmpli(Ampli71, 7, 1, 257, 34, FALSE);
   ConfigurerAmpli(Ampli72, 7, 2, 258, 35, FALSE);
   ConfigurerAmpli(Ampli73, 7, 3, 259, 35, FALSE);
   ConfigurerAmpli(Ampli74, 7, 4, 260, 35, TRUE);



 (** cartes CES **)
   ConfigurerCES(CarteCes1, 01);
   ConfigurerCES(CarteCes2, 02);
   ConfigurerCES(CarteCes3, 03);
   ConfigurerCES(CarteCes4, 04);
   ConfigurerCES(CarteCes5, 05);


(** Liaisons Inter-Secteur **)

   ConfigurerIntsecteur(Intersecteur1, 01, trL0212, trL0218);


(* Initialisations des variables ne correspondant pas a des entrees secu *)
(* Point d'arret *)
    AffectBoolD( BoolRestrictif, PtArrSigCAL20);
    AffectBoolD( BoolRestrictif, PtArrCdvCAL10);
    AffectBoolD( BoolRestrictif, PtArrSigCAL10);
    AffectBoolD( BoolRestrictif, PtArrSpeCAL12);
    AffectBoolD( BoolRestrictif, PtArrSpeCAL13);
    AffectBoolD( BoolRestrictif, PtArrCdvCAL14);
    AffectBoolD( BoolRestrictif, PtArrCdvCAL15);
    AffectBoolD( BoolRestrictif, PtArrCdvCAL16);
    AffectBoolD( BoolRestrictif, PtArrCdvANA10);
    AffectBoolD( BoolRestrictif, PtArrCdvANA11);
    AffectBoolD( BoolRestrictif, PtArrCdvANA12);

    AffectBoolD( BoolRestrictif, PtArrCdvANA22);
    AffectBoolD( BoolRestrictif, PtArrCdvANA21);
    AffectBoolD( BoolRestrictif, PtArrCdvANA20);

    AffectBoolD( BoolRestrictif, PtArrCdvCAL26);
    AffectBoolD( BoolRestrictif, PtArrCdvCAL24);
    AffectBoolD( BoolRestrictif, PtArrSigCAL24);
    AffectBoolD( BoolRestrictif, PtArrCdvCAL22);
    AffectBoolD( BoolRestrictif, PtArrSigCAL22);
    AffectBoolD( BoolRestrictif, PtArrCdvCAL19);
    AffectBoolD( BoolRestrictif, PtArrSpeCAL19);

    AffectBoolD( BoolRestrictif, PtArrSigCAL12);

    AffectBoolD( BoolRestrictif, TivComSigANA22);

(* Variants anticipes *)
    AffectBoolD( BoolRestrictif, PtAntCdvCEB22);
    AffectBoolD( BoolRestrictif, PtAntCdvCEB23);
    AffectBoolD( BoolRestrictif, PtAntCdvCEB10);

    AffectBoolD( BoolRestrictif, PtAntCdvHEB08);
    AffectBoolD( BoolRestrictif, PtAntSigHEB08);
    AffectBoolD( BoolRestrictif, TivAntHEB09);
    AffectBoolD( BoolRestrictif, AigAntHEB09.PosNormale);
    AffectBoolD( BoolRestrictif, AigAntHEB09.PosDeviee);
        
(* Regulation *)
    CdvANA12Fonc := FALSE;
    CdvANA22Fonc := FALSE;

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

   ConfigEmisTeleSolTrain ( te11s11t01,
                            noBoucle1,         
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te15s11t02,
                            noBoucle2,         
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);
       
   ConfigEmisTeleSolTrain ( te21s11t03,
                            noBoucle3,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te24s11t04,
                            noBoucle4,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);
 
   ConfigEmisTeleSolTrain ( te27s11t05,
                            noBoucle5,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);
 
   ConfigEmisTeleSolTrain ( te31s11t06,
                            noBoucle6,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te34s11t07,
                            noBoucle7,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);


(* CONFIGURATION POUR LA REGULATION *)
   ConfigQuai (31, 64, CdvCAL12Fonc, te11s11t01, 0, 2, 3, 4, 11, 13, 14, 15);
   ConfigQuai (31, 69, CdvCAL22Fonc, te24s11t04, 0, 9,11, 5,  6, 13, 14, 15);

   ConfigQuai (32, 74, CdvANA12Fonc, te15s11t02, 0, 2, 8, 3,  9, 13, 14, 15);
   ConfigQuai (32, 79, CdvANA22Fonc, te21s11t03, 0, 2, 3, 4, 11, 13, 14, 15);

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
   ProcEmisSolTrain( te11s11t01.EmissionSensUp, (2*noBoucle1), 
                     LigneL02+ L0211+ TRONC*01,     

                  PtArrSigCAL10,
                  BoolRestrictif,             (* aspect croix *)
                  PtArrSpeCAL12,
                  PtArrSpeCAL13,
                  PtArrCdvCAL14,
                  PtArrCdvCAL15,
                  PtArrCdvCAL16,
		  BoolRestrictif,
(* Variants Anticipes *)
                  PtArrCdvANA10,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
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
   ProcEmisSolTrain( te15s11t02.EmissionSensUp, (2*noBoucle2), 
                     LigneL02+ L0211+ TRONC*02,     

                  PtArrCdvANA10,
                  PtArrCdvANA11,
                  PtArrCdvANA12,
                  PtAntCdvHEB08,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
	      (* Variants Anticipes *)
                  PtAntSigHEB08,
                  BoolRestrictif,               (* aspect croix *)
                  TivAntHEB09,                  (* tivcom *)
                  AigAntHEB09.PosDeviee,
                  AigAntHEB09.PosNormale,
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


(* variants troncon 3    voie 2  sp  *)
   ProcEmisSolTrain( te21s11t03.EmissionSensUp, (2*noBoucle3), 
                     LigneL02+ L0211+ TRONC*03,     

                  PtArrCdvANA22,
                  PtArrCdvANA21,
                  PtArrCdvANA20,
                  PtArrCdvCAL26,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif, 
                  BoolRestrictif,                     
(* Variants Anticipes *)
                  PtArrCdvCAL24,
                  PtArrSigCAL24,
                  BoolRestrictif,             (* aspect croix *)
                  PtArrCdvCAL22,
                  PtArrSigCAL22,
                  BoolRestrictif,             (* aspect croix *)
                  TivComSigANA22,
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
   ProcEmisSolTrain( te24s11t04.EmissionSensUp, (2*noBoucle4), 
                     LigneL02+ L0211+ TRONC*04,     

                  PtArrCdvCAL24,
                  PtArrSigCAL24,
                  BoolRestrictif,             (* aspect croix *)
                  PtArrCdvCAL22,
                  PtArrSigCAL22,
                  BoolRestrictif,             (* aspect croix *)
                  TivComSigANA22,
                  BoolRestrictif,
(* Variants Anticipes *)
                  PtArrSpeCAL19,
                  PtArrCdvCAL19,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
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


(* variants du troncon 5 voie 1 <-- sp *)
   ProcEmisSolTrain( te27s11t05.EmissionSensUp, (2*noBoucle5), 
                     LigneL02+ L0211+ TRONC*05,     

                  PtArrSigCAL12,
                  BoolRestrictif,             (* aspect croix *)
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
(* Variants Anticipes *)
                  PtArrSpeCAL19,
                  PtArrCdvCAL19,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
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
   ProcEmisSolTrain( te31s11t06.EmissionSensUp, (2*noBoucle6), 
                     LigneL02+ L0211+ TRONC*06,     

                  PtArrSpeCAL19,
                  PtArrCdvCAL19,
                  PtAntCdvCEB22,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
(* Variants Anticipes *)
                  PtAntCdvCEB23,
                  PtAntCdvCEB10,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
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
   ProcEmisSolTrain( te34s11t07.EmissionSensUp, (2*noBoucle7), 
                     LigneL02+ L0211+ TRONC*07,     

                  PtArrSigCAL20,
                  BoolRestrictif,             (* aspect croix *)
                  AigCAL11_21.PosReverseFiltree,
                  AigCAL11_21.PosNormaleFiltree,
                  BoolRestrictif,             (* Rouge Fix *)
                  BoolRestrictif,             (* aspect croix *)
                  BoolRestrictif,
                  BoolRestrictif,
	      (* Variants Anticipes *)
                  PtArrSpeCAL12,
                  PtArrSpeCAL13,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
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



(* emission vers le secteur 12 -aval- *)

   ProcEmisInterSecteur (teL0212, noBoucleHer, LigneL02+ L0211+ TRONC*03,
			noBoucleHer,
                  PtArrCdvANA22,
                  PtArrCdvANA21,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif, 
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


(* emission vers le secteur 18 -amont- Cerro Branco *)

   ProcEmisInterSecteur (teL0218, noBoucleCeB, LigneL02+ L0211+ TRONC*01,
			noBoucleCeB,
                  PtArrCdvCAL10,
                  PtArrSigCAL10,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif, 
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



(* reception du secteur 12 -aval- *)

   ProcReceptInterSecteur(trL0212, noBoucleHer, LigneL02+ L0212+ TRONC*01,
                  PtAntCdvHEB08,
                  PtAntSigHEB08,
                  TivAntHEB09,                 (* tivcom *)
                  AigAntHEB09.PosDeviee,
                  AigAntHEB09.PosNormale,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif, 
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


(* reception du secteur 18 -amont- Cerro Branco *)

   ProcReceptInterSecteur(trL0218, noBoucleCeB, LigneL02+ L0218+ TRONC*03,
                  PtAntCdvCEB22,
                  PtAntCdvCEB23,
                  PtAntCdvCEB10,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif, 
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
            

 (** Emission invariants vers secteur 12 aval L0212 **)

   EmettreSegm(LigneL02+ L0211+ TRONC*03+ SEGM*00, noBoucleHer, SensUp);
   EmettreSegm(LigneL02+ L0211+ TRONC*03+ SEGM*01, noBoucleHer, SensUp);

 (** Emission invariants vers secteur 18 amont L0218 **)

   EmettreSegm(LigneL02+ L0211+ TRONC*01+ SEGM*01, noBoucleCeB, SensUp);
   EmettreSegm(LigneL02+ L0211+ TRONC*01+ SEGM*02, noBoucleCeB, SensUp);


 (** Boucle 1 **)        
   EmettreSegm(LigneL02+ L0211+ TRONC*01+ SEGM*01, noBoucle1, SensUp);
   EmettreSegm(LigneL02+ L0211+ TRONC*01+ SEGM*02, noBoucle1, SensUp);
   EmettreSegm(LigneL02+ L0211+ TRONC*02+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL02+ L0211+ TRONC*02+ SEGM*01, noBoucle1, SensUp);
   EmettreSegm(LigneL02+ L0211+ TRONC*05+ SEGM*00, noBoucle1, SensUp);

 (** Boucle 2 **)        
   (* EmettreSegm(LigneL02+ L0211+ TRONC*02+ SEGM*00, noBoucle2, SensUp); *)
   (* EmettreSegm(LigneL02+ L0211+ TRONC*02+ SEGM*01, noBoucle2, SensUp); *)
   EmettreSegm(LigneL02+ L0212+ TRONC*01+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL02+ L0212+ TRONC*01+ SEGM*01, noBoucle2, SensUp);
   EmettreSegm(LigneL02+ L0212+ TRONC*03+ SEGM*00, noBoucle2, SensUp);

 (** Boucle 3 **)  
   EmettreSegm(LigneL02+ L0211+ TRONC*03+ SEGM*00, noBoucle3, SensUp);
   EmettreSegm(LigneL02+ L0211+ TRONC*03+ SEGM*01, noBoucle3, SensUp);
   EmettreSegm(LigneL02+ L0211+ TRONC*04+ SEGM*00, noBoucle3, SensUp);
   EmettreSegm(LigneL02+ L0211+ TRONC*04+ SEGM*01, noBoucle3, SensUp);
   (* EmettreSegm(LigneL02+ L0211+ TRONC*06+ SEGM*00, noBoucle3, SensUp); *)

 (** Boucle 4 **)  
   (* EmettreSegm(LigneL02+ L0211+ TRONC*04+ SEGM*00, noBoucle4, SensUp); *)
   (* EmettreSegm(LigneL02+ L0211+ TRONC*04+ SEGM*01, noBoucle4, SensUp); *)
   EmettreSegm(LigneL02+ L0211+ TRONC*06+ SEGM*00, noBoucle4, SensUp);
   EmettreSegm(LigneL02+ L0218+ TRONC*03+ SEGM*00, noBoucle4, SensUp);

 (** Boucle 5 **) 
   (* EmettreSegm(LigneL02+ L0211+ TRONC*05+ SEGM*00, noBoucle5, SensUp); *)
   EmettreSegm(LigneL02+ L0211+ TRONC*06+ SEGM*00, noBoucle5, SensUp);

 (** Boucle 6 **)  
   (* EmettreSegm(LigneL02+ L0211+ TRONC*06+ SEGM*00, noBoucle6, SensUp); *)
   EmettreSegm(LigneL02+ L0211+ TRONC*07+ SEGM*00, noBoucle6, SensUp);
   EmettreSegm(LigneL02+ L0218+ TRONC*03+ SEGM*00, noBoucle6, SensUp);
   EmettreSegm(LigneL02+ L0218+ TRONC*03+ SEGM*01, noBoucle6, SensUp);

 (** Boucle 7 **) 
   (* EmettreSegm(LigneL02+ L0211+ TRONC*07+ SEGM*00, noBoucle7, SensUp); *)
   EmettreSegm(LigneL02+ L0211+ TRONC*01+ SEGM*01, noBoucle7, SensUp);
   EmettreSegm(LigneL02+ L0211+ TRONC*01+ SEGM*02, noBoucle7, SensUp);
   EmettreSegm(LigneL02+ L0211+ TRONC*04+ SEGM*01, noBoucle7, SensUp);

  
 (* *)
(************************** CONFIGURATION DES TRONCONS TSR ***************************)

   ConfigurerTroncon(Tronc0, LigneL02 + L0211 + TRONC*01, 2,2,2,2);  (* troncon 11-1 *)
   ConfigurerTroncon(Tronc1, LigneL02 + L0211 + TRONC*02, 2,2,2,2);  (* troncon 11-2 *)
   ConfigurerTroncon(Tronc2, LigneL02 + L0211 + TRONC*03, 2,2,2,2);  (* troncon 11-3 *)
   ConfigurerTroncon(Tronc3, LigneL02 + L0211 + TRONC*04, 2,2,2,2);  (* troncon 11-4 *)
   ConfigurerTroncon(Tronc4, LigneL02 + L0211 + TRONC*05, 2,2,2,2);  (* troncon 11-5 *)
   ConfigurerTroncon(Tronc5, LigneL02 + L0211 + TRONC*06, 2,2,2,2);  (* troncon 11-6 *)
   ConfigurerTroncon(Tronc6, LigneL02 + L0211 + TRONC*07, 2,2,2,2);  (* troncon 11-7 *)


(******************************** EMISSION DES TSR ***********************************)

(** Emission des TSR vers le secteur aval 12 L0212 **)

   EmettreTronc(LigneL02+ L0211+ TRONC*03, noBoucleHer, SensUp);


(** Emission des TSR vers le secteur amont 05 L0218 **)

   EmettreTronc(LigneL02+ L0211+ TRONC*01, noBoucleCeB, SensUp);


 (** Emission des TSR sur les troncons du secteur courant **)

   EmettreTronc(LigneL02+ L0211+ TRONC*01, noBoucle1, SensUp); (* troncon 11-1 *)
   EmettreTronc(LigneL02+ L0211+ TRONC*02, noBoucle1, SensUp);
   EmettreTronc(LigneL02+ L0211+ TRONC*05, noBoucle1, SensUp);


   EmettreTronc(LigneL02+ L0211+ TRONC*02, noBoucle2, SensUp); (* troncon 11-2 *)
   EmettreTronc(LigneL02+ L0212+ TRONC*01, noBoucle2, SensUp);
   EmettreTronc(LigneL02+ L0212+ TRONC*03, noBoucle2, SensUp);


   EmettreTronc(LigneL02+ L0211+ TRONC*03, noBoucle3, SensUp); (* troncon 11-3 *)
   EmettreTronc(LigneL02+ L0211+ TRONC*04, noBoucle3, SensUp);
   EmettreTronc(LigneL02+ L0211+ TRONC*06, noBoucle3, SensUp);


   EmettreTronc(LigneL02+ L0211+ TRONC*04, noBoucle4, SensUp); (* troncon 11-4 *)
   EmettreTronc(LigneL02+ L0211+ TRONC*06, noBoucle4, SensUp);
   EmettreTronc(LigneL02+ L0218+ TRONC*03, noBoucle4, SensUp);


   EmettreTronc(LigneL02+ L0211+ TRONC*05, noBoucle5, SensUp); (* troncon 11-5 *)
   EmettreTronc(LigneL02+ L0211+ TRONC*06, noBoucle5, SensUp);


   EmettreTronc(LigneL02+ L0211+ TRONC*06, noBoucle6, SensUp); (* troncon 11-6 *)
   EmettreTronc(LigneL02+ L0211+ TRONC*07, noBoucle6, SensUp);
   EmettreTronc(LigneL02+ L0218+ TRONC*03, noBoucle6, SensUp);


   EmettreTronc(LigneL02+ L0211+ TRONC*07, noBoucle7, SensUp); (* troncon 11-7 *)
   EmettreTronc(LigneL02+ L0211+ TRONC*01, noBoucle7, SensUp);
   EmettreTronc(LigneL02+ L0211+ TRONC*04, noBoucle7, SensUp);


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
    StockAdres( ADR( SigCAL20));
    StockAdres( ADR( SigCAL10));
    StockAdres( ADR( CdvCAL15));
    StockAdres( ADR( CdvCAL16));
    StockAdres( ADR( CdvANA10));
    StockAdres( ADR( CdvANA11));
    StockAdres( ADR( CdvANA12));
    StockAdres( ADR( CdvANA22));
    StockAdres( ADR( CdvANA21));
    StockAdres( ADR( CdvANA20));
    StockAdres( ADR( CdvCAL26));
    StockAdres( ADR( CdvCAL25));
    StockAdres( ADR( CdvCAL24));
    StockAdres( ADR( SigCAL24));

    StockAdres( ADR( SigCAL22kj));
    StockAdres( ADR( SigCAL22kv));
    StockAdres( ADR( SigCAL12));

    StockAdres( ADR( CdvCAL10));
    StockAdres( ADR( CdvCAL21));
    StockAdres( ADR( CdvCAL23));
  (*  StockAdres( ADR( CdvCAL12)); *)

    StockAdres( ADR( CdvCAL22));
    StockAdres( ADR( CdvCAL13));
    StockAdres( ADR( CdvCAL14));

    StockAdres( ADR( CdvCAL12A));
    StockAdres( ADR( CdvCAL12B));
    StockAdres( ADR( CdvCAL19));

    StockAdres( ADR( Sp1CAL));
    StockAdres( ADR( Sp2CAL));

    StockAdres( ADR( AigCAL11_21));


    StockAdres( ADR( PtArrCdvCAL10));
    StockAdres( ADR( PtArrSigCAL20));
    StockAdres( ADR( PtArrSigCAL10));
    StockAdres( ADR( PtArrSpeCAL12));

    StockAdres( ADR( PtArrSpeCAL13));

    StockAdres( ADR( PtArrCdvCAL14));
    StockAdres( ADR( PtArrCdvCAL15));
    StockAdres( ADR( PtArrCdvCAL16));

    StockAdres( ADR( PtArrCdvANA10));
    StockAdres( ADR( PtArrCdvANA11));
    StockAdres( ADR( PtArrCdvANA12));

    StockAdres( ADR( PtArrCdvANA22));
    StockAdres( ADR( PtArrCdvANA21));
    StockAdres( ADR( PtArrCdvANA20));

    StockAdres( ADR( PtArrCdvCAL26));
    StockAdres( ADR( PtArrCdvCAL24));
    StockAdres( ADR( PtArrSigCAL24));

    StockAdres( ADR( PtArrCdvCAL22));
    StockAdres( ADR( PtArrSigCAL22));

    StockAdres( ADR( PtArrCdvCAL19));
    StockAdres( ADR( PtArrSpeCAL19));

    StockAdres( ADR( PtArrSigCAL12));


    StockAdres( ADR( PtAntCdvCEB22));
    StockAdres( ADR( PtAntCdvCEB23));
    StockAdres( ADR( PtAntCdvCEB10));

    StockAdres( ADR( PtAntCdvHEB08));
    StockAdres( ADR( PtAntSigHEB08));
    StockAdres( ADR( TivAntHEB09));
    StockAdres( ADR( AigAntHEB09));

    StockAdres( ADR( TivComSigANA22));
    
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
   CdvANA12Fonc := CdvANA12.F = Vrai.F;
   CdvANA22Fonc := CdvANA22.F = Vrai.F;
   CdvCAL22Fonc := CdvCAL22.F = Vrai.F;
   CdvCAL12Fonc := CdvCAL12A.F = Vrai.F;


(****************************** FILTRAGE DES AIGUILLES *******************************)

   FiltrerAiguille( AigCAL11_21, BaseExeAig);


(************************** Gerer les point d'arrets **************************)

   AffectBoolD( CdvCAL10,                   PtArrCdvCAL10);
   AffectBoolD( SigCAL20,                   PtArrSigCAL20);
   AffectBoolD( SigCAL10,                   PtArrSigCAL10);

   EtDD(        CdvCAL12B,     CdvCAL13,    PtArrSpeCAL12);
   NonD(        Sp2CAL,                     PtArrSpeCAL13);

   AffectBoolD( CdvCAL14,                   PtArrCdvCAL14);
   AffectBoolD( CdvCAL15,                   PtArrCdvCAL15);
   AffectBoolD( CdvCAL16,                   PtArrCdvCAL16);

   AffectBoolD( CdvANA10,                   PtArrCdvANA10);
   AffectBoolD( CdvANA11,                   PtArrCdvANA11);
   AffectBoolD( CdvANA12,                   PtArrCdvANA12);

   AffectBoolD( CdvANA22,                   PtArrCdvANA22);
   AffectBoolD( CdvANA21,                   PtArrCdvANA21);
   AffectBoolD( CdvANA20,                   PtArrCdvANA20);

   EtDD(        CdvCAL26,     CdvCAL25,     PtArrCdvCAL26);
   AffectBoolD( CdvCAL24,                   PtArrCdvCAL24);
   AffectBoolD( SigCAL24,                   PtArrSigCAL24);

   OuDD( CdvCAL21, AigCAL11_21.PosReverseFiltree, BoolTr);
   EtDD( BoolTr, CdvCAL22, PtArrCdvCAL22);

   OuDD(      SigCAL22kv,   SigCAL22kj,     PtArrSigCAL22);

   AffectBoolD( CdvCAL19,                   PtArrCdvCAL19);

   NonD(      Sp1CAL,                       PtArrSpeCAL19);

   AffectBoolD( SigCAL12,                   PtArrSigCAL12);
   AffectBoolD( SigCAL22kv,                 TivComSigANA22);

(*** lecture des entrees de regulation ***)

   LireEntreesRegul;

END ExeSpecific;
END Specific.
         