IMPLEMENTATION MODULE Specific;

(*$S- *)
(*$T- *)

(******************************************************************************
*   SANTIAGO - LIGNE 2 - Secteur 14
*  =============================
*  Version : 1.0.1
*  Date    : 07/04/1997
*  Auteur  : Marc Plywacz
*  Premiere Version
******************************************************************************)
(*****************************************************************************
Date : 3/9/1997,
Auteur : F. Chanier,
Version : 1.0.1
Nature : Pb sur Pt arret 21A toujours restrictif
         ===> Le PtArrCdvFRA21B est remplace par PtArrCdvFRA21A, toutefois
              les variables cdvFRA21A et cdvFRA21B ne sont pas touchees
         ===> Dans ExeSpecific, on remplace l'equation pour calculer
              PtArrCdvFRA21B par PtArrCdvFRA21A.
******************************************************************************)
(* Date : 10/9/1997
   Version : 1.0.2 
   Auteur : F. Chanier
   Nature : modification de la commande de l'aiguille fictive *) 

(* Date : 30/09/1997
   Version : 1.0.3 
   Auteur : P. Hog
   Nature : Procedure "InitSpecDivers", correction de la configuration de la
            boucle 3.
            Procedure "InSpecMessInv", ajout de l'emission du segment 13.3.0
            et des LTV du troncon 13.3 sur la boucle 3.
 *)

(* Date : 11/2/1998
   Version : 1.0.4 
   Auteur : F. Chanier
   Nature : - modification pour detection des defaillances d'ampli;
            - ajout des parametres pour la marche type *) 
(*---------------------------------------------------------------------------*)
(*****************************************************************************)
(***            AJOUT DE LA NUMEROTATION SCCS DES VERSIONS                ****)
(*---------------------------------------------------------------------------*)
(* Version 1.0.5  =====================                                      *)
(* Version 1.6 DU SERVEUR SCCS =====================                         *)
(* Date :         21/09/1998                                                 *)
(* Auteur:        H. Le Roy                                                  *)
(* Modification : Fiche d'anomalie ba040998                                  *)
(*                Suite a un changement de vitesses maximales, mise a jour   *)
(*                des marches types                                          *)
(*                Fiche d'anomalie ba080998                                  *)
(*                Correction dans l'emission des TSR : les troncon 14.4 et   *)
(*                15.1 sont emis sur le troncon 14.2(V2) au lieu du 14.1(V1) *)
(*****************************************************************************)
(* Version 1.0.6  =====================                                      *)
(* Version 1.7 DU SERVEUR SCCS =====================                         *)
(* Date :         15/12/98                                                   *)
(* Auteur :       H. Le Roy                                                  *)
(* Modifications : am ba091298-1                                             *)
(*                 Ajout d'une entree secu associee au cdv 13                *)
(*                 Ajout d'un variant emis sur la boucle 1, associe a        *)
(*                  l'arret sub qui protege le signal 12                     *) 
(*****************************************************************************)
(* Version 1.0.7  =====================                                      *)
(* Version 1.8 DU SERVEUR SCCS =====================                         *)
(* Date :         07/01/99                                                   *)
(* Auteur :       H. Le Roy                                                  *)
(* Modifications : am ba060199-1                                             *)
(*                 correction de l'equation du point d'arret ajoute dans la  *)
(*                 version precedente car permissif quand cdv13 occupe et    *)
(*                 aiguille decontrolee                                      *)
(*****************************************************************************)
(* Version 1.0.8  =====================                                      *)
(* Version 1.9 DU SERVEUR SCCS =====================                         *)
(* Date :         14/04/99                                                   *)
(* Auteur :       H. Le Roy                                                  *)
(* Modifications : Adaptation de la configuration des amplis au standard     *)
(*                 1.3.3. Suppression de parties de code inutiles concernant *)
(*                 les DAMTC.                                                *)
(*****************************************************************************)
(* Version 1.0.9  =====================                                      *)
(* Version 1.10 DU SERVEUR SCCS =====================                        *)
(* Auteur :       H. Le Roy                                                  *)
(* Modifications : Erreur d'archivage sous SCCS apres generation et marquage *)
(*                 des executables. Le numero de version non SCCS 1.0.9 sera *)
(*                 conserve. Theoriquement, la modification de cette entete  *)
(*                 ne devrait pas entrainer une variation des checksum en    *)
(*                 cas de regeneration des executables                       *)
(*****************************************************************************)
(* Version 1.0.9  =====================                                      *)
(* Version 1.11 DU SERVEUR SCCS =====================                        *)
(* Date :         21/04/99                                                   *)
(* Auteur :       H. Le Roy                                                  *)
(* Modifications : Config. des amplis pour detecter les pannes de fusibles   *)
(*****************************************************************************)
(* Version 1.1.0  =====================                                      *)
(* Version 1.12 DU SERVEUR SCCS =====================                        *)
(* Date :         15/06/2000                                                 *)
(* Auteur :       H. Le Roy                                                  *)
(* Modifications : Am165 : modification des marches types                    *)
(*****************************************************************************)
(* Version 1.1.1  =====================                                      *)
(* Version 1.13 DU SERVEUR SCCS =====================                        *)
(* Date :         07/08/2006                                                 *)
(* Auteur:        Rudy Nsiona                                                *)
(* Modification : Nouveau Train NS2004                                       *)
(* Procédure CONFIGURATION DES TRONCONS TSR                                   *)
(*                ancienne valeur 1 , nouvelle 2                             *)

(******************************  IMPORTATIONS  *******************************)

FROM SYSTEM     IMPORT ADR;

FROM Opel       IMPORT StockAdres, AffectBoolD, AffectBoolC, BoolC, BoolD, EtDD, CodeD, NonD,
		       Tvrai, FinBranche, FinArbre, AffectC, OuDD, BoolLD;

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

              		Ampli11, Ampli12, Ampli13, Ampli14, Ampli15, 
              		Ampli21, Ampli22, Ampli23, Ampli24, Ampli25, Ampli26, Ampli27, Ampli28,
	                Ampli31, Ampli32, Ampli33, Ampli34, Ampli35,
          		Ampli41, Ampli42, Ampli43, Ampli44, Ampli45,
              		Ampli46, Ampli47, Ampli48,                                  

(* variables *)
                       Boucle1, Boucle2, Boucle3, Boucle4, Boucle5, Boucle6, BoucleFictive,
		       CarteCes1,  CarteCes2,  CarteCes3, CarteCes4,
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
(*  *)
(*****************************  CONSTANTES  ***********************************)

CONST

(** No ligne, No secteur, ....**)


    LigneL02 = 16384*00; (* numero de ligne decale de 2**14 *)

    L0215  = 1024*15;    (* numero Secteur aval voie impaire decale de 2**10 *)

    L0214  = 1024*14;    (* numero Secteur local decale de 2**10 *)

    L0213  = 1024*13;    (* numero Secteur amont voie impaire decale de 2**10 *)


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

(** No des stations du secteur 14 **)
(* ligne 1: 1,2 ; ligne 2: 3,4; ligne 5: 5,6 *)
    noFRAv1 = 3*32 + 7;
    noFRAv2 = 3*32 + 7;
    noLLAv1 = 3*32 + 8;
    noLLAv2 = 3*32 + 8;

(** indication de sens **)
    SensUp = TRUE;

(** No de Voie d'emissions SOL-Train, d'emission/reception inter-secteur **)
    noBouclevia = 00; 
    noBouclehig = 01; 
    noBouclefi = 02;
    noBoucle1 = 03;
    noBoucle2 = 04;
    noBoucle3 = 05;
    noBoucle4 = 06;

(* numero de version *)
    noVersion = 01;

(** Base pour les tables de compensation **)
    BaseEntVar	= 500 	;
    BaseSorVar	= 600 	;
    BaseExeAig	= 1280	;
    BaseExeChainage = 1360 ;
    BaseExeSpecific = 1950 ;

(*  *)
TYPE
 TyAigNonLue = RECORD  (* Structure de donnees associee a une aiguille dont *
                        * l'etat n'est pas lu sur des entrees de carte CES  *
                        * (aiguille fictive ou anticipee)                   *)
                  PosNormale  : BoolD ;   (* position normale calculee *)
                  PosDeviee   : BoolD ;   (* position deviee calculee  *)
                END;


(* DECLARATION DES VARIABLES GENERALES *)
 VAR
              Bouclehig, Bouclevia, Bouclefi : TyBoucle;


(* DECLARATION DES SINGULARITES DU SECTEUR 14 : dans les deux sens confondus *)

(* Declaration des variables correspondant a des entrees securitaires  *)
(*   - CDV et signaux                                                  *)
    CdvFRA10A,     (* entree  1, soit entree 0 de CES 02  *)
    CdvFRA10B,     (* entree  2, soit entree 1 de CES 02  *)
    SigFRA10,      (* entree  3, soit entree 2 de CES 02  *)
    SigFRA12kv,    (* entree  4, soit entree 3 de CES 02  *)
    SigFRA12kj,    (* entree  5, soit entree 4 de CES 02  *)
    CdvLLA11,      (* entree  6, soit entree 5 de CES 02  *)
    CdvLLA12,      (* entree  7, soit entree 6 de CES 02  *)
    CdvLLA13,      (* entree  8, soit entree 7 de CES 02  *)
    CdvLLA14,      (* entree  9, soit entree 0 de CES 03  *)
    CdvLLA23,      (* entree 10, soit entree 1 de CES 03  *)
    CdvLLA22,      (* entree 11, soit entree 2 de CES 03  *)
    CdvLLA21,      (* entree 12, soit entree 3 de CES 03  *)
    CdvFRA24,      (* entree 13, soit entree 4 de CES 03  *)
    SigFRA24,      (* entree 14, soit entree 5 de CES 03  *)
    CdvFRA21B,     (* entree 15, soit entree 6 de CES 03  *)
    CdvFRA21A,     (* entree 16, soit entree 7 de CES 03  *)
    CdvFRA20B,     (* entree 17, soit entree 0 de CES 04  *)
    CdvFRA20A,     (* entree 18, soit entree 1 de CES 04  *)
    Sp1FRA,        (* entree 19, soit entree 2 de CES 04  *)
    Sp2FRA,        (* entree 20, soit entree 3 de CES 04  *)
    SigFRA14,      (* entree 21, soit entree 4 de CES 04  *)
    SigFRA22,      (* entree 24, soit entree 7 de CES 04  *)
    CdvFRA11,      (* entree 25, soit entree 0 de CES 05  *)
    CdvFRA12,      (* entree 26, soit entree 1 de CES 05  *)
    CdvFRA23,      (* entree 27, soit entree 2 de CES 05  *)
    CdvFRA22,      (* entree 28, soit entree 3 de CES 05  *)
    CdvFRA13       (* entree 29, soit entree 4 de CES 05  *)
             : BoolD;

(*   - aiguilles                                                       *)
    AigFRA13       (* entrees 22 et 23, soit entrees 5 et 6 de CES 04  *)
             :TyAig;



(* Variables ne correspondant pas a une entree securitaire *)
(* Point d'arret *)
    PtArrCdvFRA10,
    PtArrSigFRA10,
    PtArrSigFRA12,
    PtArrCdvFRA13,
    PtArrCdvLLA11,
    PtArrCdvLLA12,
    PtArrCdvLLA13,
    PtArrCdvLLA14,

    PtArrCdvLLA23,
    PtArrCdvLLA22,
    PtArrCdvLLA21,
    PtArrCdvFRA24,
    PtArrSigFRA24,
    PtArrCdvFRA21,
(* C+ : FC le 3/9/1997 : on retire PtArrCdvFRA21B et on met PtArrCdvFRA21A *)
    PtArrCdvFRA21A,
    PtArrCdvFRA20,

    PtArrSigFRA14,
    PtArrSigFRA22   : BoolD;

(* Aiguilles fictives *)
    AigFictFRA14     : TyAigNonLue;

(* Tiv Com non lies a une aiguille *)
    TivComFRA12     : BoolD;

(* Variants anticipes *)
    PtAntCdvMIG11,
    PtAntCdvRON23   : BoolD;

(* Copie des entrees dans des variables fonctionnelles pour la regulation *)
    CdvFRA12Fonc,
    CdvFRA22Fonc,
    CdvLLA12Fonc,
    CdvLLA22Fonc    : BOOLEAN;

(** Voie d'emission SOL-TRAIN : deux sens confondus**)
    te11s14t01,
    te14s14t02,
    te21s14t03,
    te24s14t04           :TyEmissionTele;	 			

(** Voie d'emission Inter-secteur deux voies confondues **)
    teL0215,
    teL0213	          :TyEmissionTele;

(** Voie de reception Inter-secteur deux voies confondues **)
    trL0215,
    trL0213               :TyCaracEntSec;

(* boucle en amont des voies *)
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


(***************************** CONFIGURATIONS DIVERSES ****************************)

(* CONFIGURATION DES AIGUILLES, POUR LES DEUX VOIES *)
    EntreeAiguille (AigFRA13, 22, 23);  (* kag G = pos normale *)

(* Configuration des entrees *)
    ProcEntreeIntrins(  1, CdvFRA10A);
    ProcEntreeIntrins(  2, CdvFRA10B);
    ProcEntreeIntrins(  3, SigFRA10);
    ProcEntreeIntrins(  4, SigFRA12kv);
    ProcEntreeIntrins(  5, SigFRA12kj);
    ProcEntreeIntrins(  6, CdvLLA11);
    ProcEntreeIntrins(  7, CdvLLA12);
    ProcEntreeIntrins(  8, CdvLLA13);
    ProcEntreeIntrins(  9, CdvLLA14);
    ProcEntreeIntrins( 10, CdvLLA23);
    ProcEntreeIntrins( 11, CdvLLA22);
    ProcEntreeIntrins( 12, CdvLLA21);
    ProcEntreeIntrins( 13, CdvFRA24);
    ProcEntreeIntrins( 14, SigFRA24);
    ProcEntreeIntrins( 15, CdvFRA21B);
    ProcEntreeIntrins( 16, CdvFRA21A);
    ProcEntreeIntrins( 17, CdvFRA20B);
    ProcEntreeIntrins( 18, CdvFRA20A);
    ProcEntreeIntrins( 19, Sp1FRA);
    ProcEntreeIntrins( 20, Sp2FRA);
    ProcEntreeIntrins( 21, SigFRA14);
    ProcEntreeIntrins( 24, SigFRA22);
    ProcEntreeIntrins( 25, CdvFRA11);
    ProcEntreeIntrins( 26, CdvFRA12);
    ProcEntreeIntrins( 27, CdvFRA23);
    ProcEntreeIntrins( 28, CdvFRA22);
    ProcEntreeIntrins( 29, CdvFRA13);

(* CONFIGURATION POUR LA MAINTENANCE de la transmission continue *)
   ConfigurerBoucle(Boucle1, 1);
   ConfigurerBoucle(Boucle2, 2);
   ConfigurerBoucle(Boucle3, 3);
   ConfigurerBoucle(Boucle4, 4);

   ConfigurerAmpli(Ampli11, 1, 1, 154, 11, FALSE);
   ConfigurerAmpli(Ampli12, 1, 2, 155, 12, FALSE);
   ConfigurerAmpli(Ampli13, 1, 3, 156, 12, FALSE);
   ConfigurerAmpli(Ampli14, 1, 4, 157, 12, TRUE);
   ConfigurerAmpli(Ampli15, 1, 5, 158, 13, FALSE);   

   ConfigurerAmpli(Ampli21, 2, 1, 159, 14, FALSE);
   ConfigurerAmpli(Ampli22, 2, 2, 192, 15, FALSE);
   ConfigurerAmpli(Ampli23, 2, 3, 193, 15, FALSE);  
   ConfigurerAmpli(Ampli24, 2, 4, 194, 15, TRUE);
   ConfigurerAmpli(Ampli25, 2, 5, 195, 16, FALSE);   
   ConfigurerAmpli(Ampli26, 2, 6, 196, 16, FALSE);
   ConfigurerAmpli(Ampli27, 2, 7, 197, 16, TRUE);
   ConfigurerAmpli(Ampli28, 2, 8, 198, 13, TRUE);  

   ConfigurerAmpli(Ampli31, 3, 1, 199, 21, FALSE);
   ConfigurerAmpli(Ampli32, 3, 2, 200, 22, FALSE);
   ConfigurerAmpli(Ampli33, 3, 3, 201, 22, FALSE);
   ConfigurerAmpli(Ampli34, 3, 4, 202, 22, TRUE);
   ConfigurerAmpli(Ampli35, 3, 5, 203, 23, FALSE);   

   ConfigurerAmpli(Ampli41, 4, 1, 204, 24, FALSE);
   ConfigurerAmpli(Ampli42, 4, 2, 205, 25, FALSE);
   ConfigurerAmpli(Ampli43, 4, 3, 206, 25, FALSE);  
   ConfigurerAmpli(Ampli44, 4, 4, 207, 25, TRUE);
   ConfigurerAmpli(Ampli45, 4, 5, 208, 26, FALSE);   
   ConfigurerAmpli(Ampli46, 4, 6, 209, 26, FALSE);
   ConfigurerAmpli(Ampli47, 4, 7, 210, 26, TRUE);
   ConfigurerAmpli(Ampli48, 4, 8, 211, 23, TRUE);  


 (** cartes CES **)
   ConfigurerCES(CarteCes1, 01);
   ConfigurerCES(CarteCes2, 02);
   ConfigurerCES(CarteCes3, 03);
   ConfigurerCES(CarteCes4, 04);


(** Liaisons Inter-Secteur **)

   ConfigurerIntsecteur(Intersecteur1, 01, trL0215, trL0213);


(* Initialisations des variables ne correspondant pas a des entrees secu *)
(* Point d'arret *)
    AffectBoolD( BoolRestrictif, PtArrCdvFRA10);
    AffectBoolD( BoolRestrictif, PtArrSigFRA10);
    AffectBoolD( BoolRestrictif, PtArrSigFRA12);
    AffectBoolD( BoolRestrictif, PtArrCdvFRA13);
    AffectBoolD( BoolRestrictif, PtArrCdvLLA11);
    AffectBoolD( BoolRestrictif, PtArrCdvLLA12);
    AffectBoolD( BoolRestrictif, PtArrCdvLLA13);
    AffectBoolD( BoolRestrictif, PtArrCdvLLA14);

    AffectBoolD( BoolRestrictif, PtArrCdvLLA23);
    AffectBoolD( BoolRestrictif, PtArrCdvLLA22);
    AffectBoolD( BoolRestrictif, PtArrCdvLLA21);
    AffectBoolD( BoolRestrictif, PtArrCdvFRA24);
    AffectBoolD( BoolRestrictif, PtArrSigFRA24);
    AffectBoolD( BoolRestrictif, PtArrCdvFRA21);
    AffectBoolD( BoolRestrictif, PtArrCdvFRA21A);
    AffectBoolD( BoolRestrictif, PtArrCdvFRA20);


    AffectBoolD( BoolRestrictif, PtArrSigFRA14);
    AffectBoolD( BoolRestrictif, PtArrSigFRA22);

(* Aiguilles fictives *)
    AffectBoolD( BoolRestrictif, AigFictFRA14.PosNormale);
    AffectBoolD( BoolRestrictif, AigFictFRA14.PosDeviee);

(* Tiv Com non lies a une aiguille *)
    AffectBoolD( BoolRestrictif, TivComFRA12);

(* Variants anticipes *)
    AffectBoolD( BoolRestrictif, PtAntCdvMIG11);
    AffectBoolD( BoolRestrictif, PtAntCdvRON23);

(* Regulation *)
    CdvFRA12Fonc := FALSE;
    CdvFRA22Fonc := FALSE;
    CdvLLA12Fonc := FALSE;
    CdvLLA22Fonc := FALSE;

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

   ConfigEmisTeleSolTrain ( te11s14t01,
                            noBoucle1,         
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);


   ConfigEmisTeleSolTrain ( te14s14t02,
                            noBoucle2,         
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);
   

     
   ConfigEmisTeleSolTrain ( te21s14t03,
                            noBoucle3,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);


   ConfigEmisTeleSolTrain ( te24s14t04,
                            noBoucle4,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);
 


(* CONFIGURATION POUR LA REGULATION *)
   ConfigQuai (37, 64, CdvFRA12Fonc, te11s14t01, 0, 9, 11,  5, 10, 13, 14, 15);
   ConfigQuai (37, 69, CdvFRA22Fonc, te24s14t04, 0, 3,  4, 11,  5, 13, 14, 15);
   ConfigQuai (38, 74, CdvLLA12Fonc, te14s14t02, 0, 3,  4, 11,  5, 13, 14, 15);
   ConfigQuai (38, 79, CdvLLA22Fonc, te21s14t03, 0, 3,  9, 11,  5, 13, 14, 15);

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
   ProcEmisSolTrain( te11s14t01.EmissionSensUp, (2*noBoucle1), 
                     LigneL02+ L0214+ TRONC*01,     

              PtArrSigFRA10,
              BoolRestrictif,             (* aspect croix *)
              PtArrCdvFRA13,
              PtArrSigFRA12,
              BoolRestrictif,             (* aspect croix *)
              TivComFRA12,                (* tivcom *)
              BoolRestrictif,
              BoolRestrictif,
(* Variants Anticipes *)
              AigFictFRA14.PosDeviee,        (* aiguille fictive pos. reverse *)
              AigFictFRA14.PosNormale,       (* aiguille fictive pos. normale *)
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
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

(* variants troncon 2   voie 1 --> si  *)
   ProcEmisSolTrain( te14s14t02.EmissionSensUp, (2*noBoucle2), 
                     LigneL02+ L0214+ TRONC*02,     

              AigFictFRA14.PosDeviee,        (* aiguille fictive pos. reverse *)
              AigFictFRA14.PosNormale,       (* aiguille fictive pos. normale *)
              BoolRestrictif,             (* signal rouge fix1 fictif *)
              BoolRestrictif,             (* aspect croix *)
              PtArrCdvLLA11,
              PtArrCdvLLA12,
              PtArrCdvLLA13,
              PtArrCdvLLA14,
              PtArrSigFRA22,
              BoolRestrictif,             (* aspect croix *)
                  
	      (* Variants Anticipes *)
	      PtAntCdvMIG11,
              BoolRestrictif,
              BoolRestrictif,
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


(* variants troncon 3    voie 2  <--- sp  *)
   ProcEmisSolTrain( te21s14t03.EmissionSensUp, (2*noBoucle3), 
                     LigneL02+ L0214+ TRONC*03,     

              PtArrCdvLLA23,
              PtArrCdvLLA22,
              PtArrCdvLLA21,
              PtArrCdvFRA24,
              PtArrSigFRA24,
              BoolRestrictif,             (* aspect croix *)
              BoolRestrictif, 
              BoolRestrictif,                     
(* Variants Anticipes *)
              PtArrCdvFRA21,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
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
   ProcEmisSolTrain( te24s14t04.EmissionSensUp, (2*noBoucle4), 
                     LigneL02+ L0214+ TRONC*04,
  
              PtArrCdvFRA21,
              PtArrCdvFRA21A,
              PtArrCdvFRA20,
              PtArrSigFRA14,
              BoolRestrictif,             (* aspect croix *)
              AigFRA13.PosReverseFiltree,
              AigFRA13.PosNormaleFiltree,
              BoolRestrictif,            (* signal rouge fix2 fictif *)
              BoolRestrictif,             (* aspect croix *)

(* Variants Anticipes *)
              PtAntCdvRON23,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
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


 (* *)
(* reception du secteur 15 -aval- *)

   ProcReceptInterSecteur(trL0215, noBouclevia, LigneL02+ L0215+ TRONC*01,
                  PtAntCdvMIG11,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif, 
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

(*  *)

(* reception du secteur 13 -amont- *)

   ProcReceptInterSecteur(trL0213, noBouclehig, LigneL02+ L0213+ TRONC*03,

                  PtAntCdvRON23,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif, 
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



(*  *)
(* emission vers le secteur 15 -aval- *)

   ProcEmisInterSecteur (teL0215, noBouclevia, LigneL02+ L0214+ TRONC*03,
			noBouclevia,
                  PtArrCdvLLA23,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif, 
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


(*  *)

(* emission vers le secteur 13 -amont- *)

   ProcEmisInterSecteur (teL0213, noBouclehig, LigneL02+ L0214+ TRONC*01,
			noBouclehig,
                  PtArrCdvFRA10,
                  PtArrSigFRA10,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif, 
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
            

 (** Emission invariants vers secteur 15 aval L0215 **)

   EmettreSegm(LigneL02+ L0214+ TRONC*03+ SEGM*00, noBouclevia, SensUp);

 (** Emission invariants vers secteur 13 amont L0213 **)

   EmettreSegm(LigneL02+ L0214+ TRONC*01+ SEGM*00, noBouclehig, SensUp);
   EmettreSegm(LigneL02+ L0214+ TRONC*01+ SEGM*01, noBouclehig, SensUp);



 (** Boucle 1 **)        
   EmettreSegm(LigneL02+ L0214+ TRONC*01+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL02+ L0214+ TRONC*01+ SEGM*01, noBoucle1, SensUp);
   EmettreSegm(LigneL02+ L0214+ TRONC*02+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL02+ L0214+ TRONC*02+ SEGM*01, noBoucle1, SensUp);

 (** Boucle 2 **)        
   EmettreSegm(LigneL02+ L0214+ TRONC*02+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL02+ L0214+ TRONC*02+ SEGM*01, noBoucle2, SensUp);
   EmettreSegm(LigneL02+ L0214+ TRONC*02+ SEGM*02, noBoucle2, SensUp);
   EmettreSegm(LigneL02+ L0214+ TRONC*04+ SEGM*02, noBoucle2, SensUp);
   EmettreSegm(LigneL02+ L0215+ TRONC*01+ SEGM*00, noBoucle2, SensUp);

 (** Boucle 3 **)  
   EmettreSegm(LigneL02+ L0214+ TRONC*03+ SEGM*00, noBoucle3, SensUp);
   EmettreSegm(LigneL02+ L0214+ TRONC*04+ SEGM*00, noBoucle3, SensUp);
   EmettreSegm(LigneL02+ L0214+ TRONC*04+ SEGM*01, noBoucle3, SensUp);
   EmettreSegm(LigneL02+ L0213+ TRONC*03+ SEGM*00, noBoucle3, SensUp);

 (** Boucle 4 **)  
   EmettreSegm(LigneL02+ L0214+ TRONC*04+ SEGM*00, noBoucle4, SensUp);
   EmettreSegm(LigneL02+ L0214+ TRONC*04+ SEGM*01, noBoucle4, SensUp);
   EmettreSegm(LigneL02+ L0214+ TRONC*04+ SEGM*02, noBoucle4, SensUp);
   EmettreSegm(LigneL02+ L0214+ TRONC*02+ SEGM*02, noBoucle4, SensUp);
   EmettreSegm(LigneL02+ L0214+ TRONC*01+ SEGM*01, noBoucle4, SensUp);
   EmettreSegm(LigneL02+ L0213+ TRONC*03+ SEGM*00, noBoucle4, SensUp);
   EmettreSegm(LigneL02+ L0213+ TRONC*03+ SEGM*01, noBoucle4, SensUp);

(*  *) 

(*************************** CONFIGURATION DES TRONCONS TSR **************************)

   ConfigurerTroncon(Tronc0, LigneL02 + L0214 + TRONC*01, 2,2,2,2);  (* troncon 14-1 *)
   ConfigurerTroncon(Tronc1, LigneL02 + L0214 + TRONC*02, 2,2,2,2);  (* troncon 14-2 *)
   ConfigurerTroncon(Tronc2, LigneL02 + L0214 + TRONC*03, 2,2,2,2);  (* troncon 14-3 *)
   ConfigurerTroncon(Tronc3, LigneL02 + L0214 + TRONC*04, 2,2,2,2);  (* troncon 14-4 *)


(************************************** EMISSION DES TSR *************************************)



(** Emission des TSR vers le secteur aval 15 L0215 **)

   EmettreTronc(LigneL02+ L0214+ TRONC*03, noBouclevia, SensUp);


(** Emission des TSR vers le secteur amont 13 L0213 **)

   EmettreTronc(LigneL02+ L0214+ TRONC*01, noBouclehig, SensUp);



 (** Emission des TSR sur les troncons du secteur courant **)

   EmettreTronc(LigneL02+ L0214+ TRONC*01, noBoucle1, SensUp); (* troncon 14-1 *)
   EmettreTronc(LigneL02+ L0214+ TRONC*02, noBoucle1, SensUp);


   EmettreTronc(LigneL02+ L0214+ TRONC*02, noBoucle2, SensUp); (* troncon 14-2 *)
   EmettreTronc(LigneL02+ L0214+ TRONC*04, noBoucle2, SensUp);
   EmettreTronc(LigneL02+ L0215+ TRONC*01, noBoucle2, SensUp);


   EmettreTronc(LigneL02+ L0214+ TRONC*03, noBoucle3, SensUp); (* troncon 14-3 *)
   EmettreTronc(LigneL02+ L0214+ TRONC*04, noBoucle3, SensUp);
   EmettreTronc(LigneL02+ L0213+ TRONC*03, noBoucle3, SensUp);


   EmettreTronc(LigneL02+ L0214+ TRONC*04, noBoucle4, SensUp); (* troncon 14-4 *)
   EmettreTronc(LigneL02+ L0214+ TRONC*02, noBoucle4, SensUp);
   EmettreTronc(LigneL02+ L0214+ TRONC*01, noBoucle4, SensUp);
   EmettreTronc(LigneL02+ L0213+ TRONC*03, noBoucle4, SensUp);


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
    StockAdres( ADR( CdvFRA10A));
    StockAdres( ADR( CdvFRA10B));
    StockAdres( ADR( SigFRA10));
    StockAdres( ADR( SigFRA12kv));
    StockAdres( ADR( SigFRA12kj));
    StockAdres( ADR( CdvLLA11));
    StockAdres( ADR( CdvLLA12));
    StockAdres( ADR( CdvLLA13));
    StockAdres( ADR( CdvLLA14));
    StockAdres( ADR( CdvLLA23));
    StockAdres( ADR( CdvLLA22));
    StockAdres( ADR( CdvLLA21));
    StockAdres( ADR( CdvFRA24));
    StockAdres( ADR( SigFRA24));
    StockAdres( ADR( CdvFRA21B));
    StockAdres( ADR( CdvFRA21A));
    StockAdres( ADR( CdvFRA20B));
    StockAdres( ADR( CdvFRA20A));
    StockAdres( ADR( Sp1FRA));
    StockAdres( ADR( Sp2FRA));
    StockAdres( ADR( SigFRA14));
    StockAdres( ADR( SigFRA22));
    StockAdres( ADR( CdvFRA11));
    StockAdres( ADR( CdvFRA12));
    StockAdres( ADR( CdvFRA23));
    StockAdres( ADR( CdvFRA22));
    StockAdres( ADR( CdvFRA13));

    StockAdres( ADR( AigFRA13));

    StockAdres( ADR( PtArrCdvFRA10));
    StockAdres( ADR( PtArrSigFRA10));
    StockAdres( ADR( PtArrSigFRA12));
    StockAdres( ADR( PtArrCdvFRA13));
    StockAdres( ADR( PtArrCdvLLA11));
    StockAdres( ADR( PtArrCdvLLA12));
    StockAdres( ADR( PtArrCdvLLA13));
    StockAdres( ADR( PtArrCdvLLA14));

    StockAdres( ADR( PtArrCdvLLA23));
    StockAdres( ADR( PtArrCdvLLA22));
    StockAdres( ADR( PtArrCdvLLA21));
    StockAdres( ADR( PtArrCdvFRA24));
    StockAdres( ADR( PtArrSigFRA24));
    StockAdres( ADR( PtArrCdvFRA21));
    StockAdres( ADR( PtArrCdvFRA21A));
    StockAdres( ADR( PtArrCdvFRA20));

    StockAdres( ADR( PtArrSigFRA14));
    StockAdres( ADR( PtArrSigFRA22));

    StockAdres( ADR( AigFictFRA14));

    StockAdres( ADR( TivComFRA12));

    StockAdres( ADR( PtAntCdvMIG11));
    StockAdres( ADR( PtAntCdvRON23));

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
VAR BoolTr, TmpAig13 : BoolLD;

BEGIN (* ExeSpecific *)

(* Affectation des "constantes" utilisees dans la construction des messages emis    *)
(* et recus sur les boucles de transmission continue et sur les liens intersecteur. *)
(* Cette reaffectation est necessaire a chaque cycle pour la mise en securite.      *)
   AffectBoolC(Vrai, BoolPermissif)  ;
   AffectBoolC(Faux, BoolRestrictif) ;

(* regulation *)
   CdvFRA12Fonc := CdvFRA12.F = Vrai.F;
   CdvFRA22Fonc := CdvFRA22.F = Vrai.F;
   CdvLLA12Fonc := CdvLLA12.F = Vrai.F;
   CdvLLA22Fonc := CdvLLA22.F = Vrai.F;



(*  *)
(*********************************** FILTRAGE DES AIGUILLES ******************************)

   FiltrerAiguille( AigFRA13, BaseExeAig);

(************************** Gerer les aiguilles non lues **********************)
(* C+ : rajout du 10/09/1997 *)
   EtDD(AigFRA13.PosReverseFiltree, Sp1FRA, BoolTr );
(* C+ : fin du rajout *)
   OuDD(BoolTr, Sp2FRA, AigFictFRA14.PosNormale);  (* position normale *)
   NonD(AigFictFRA14.PosNormale, AigFictFRA14.PosDeviee);    (* position reverse *)

(******************* Gerer les Tiv Com non lies a une aiguille ****************)

   AffectBoolD( SigFRA12kv,                 TivComFRA12);

(************************** Gerer les point d'arrets **************************)

   EtDD(        CdvFRA10A,    CdvFRA10B,    PtArrCdvFRA10);
   AffectBoolD( SigFRA10,                   PtArrSigFRA10);
   OuDD(        SigFRA12kv,   SigFRA12kj,   PtArrSigFRA12);
   AffectBoolD( CdvLLA11,                   PtArrCdvLLA11);
   AffectBoolD( CdvLLA12,                   PtArrCdvLLA12);
   AffectBoolD( CdvLLA13,                   PtArrCdvLLA13);
   AffectBoolD( CdvLLA14,                   PtArrCdvLLA14);

   AffectBoolD( CdvLLA23,                   PtArrCdvLLA23);
   AffectBoolD( CdvLLA22,                   PtArrCdvLLA22);
   AffectBoolD( CdvLLA21,                   PtArrCdvLLA21);
   AffectBoolD( CdvFRA24,                   PtArrCdvFRA24);
   AffectBoolD( SigFRA24,                   PtArrSigFRA24);
(* C+ : FC le 3/9/1997 : on remplace le PtArrCdvFRA21B par PtArrCdvFRA21A *)
   EtDD(        CdvFRA21A,    CdvFRA21B,    PtArrCdvFRA21);
   NonD(        Sp1FRA,       BoolTr);
   EtDD(        CdvFRA21A,    BoolTr,       PtArrCdvFRA21A);
   EtDD(        CdvFRA20A,    CdvFRA20B,    PtArrCdvFRA20);
   AffectBoolD( SigFRA14,                   PtArrSigFRA14);
   AffectBoolD( SigFRA22,                   PtArrSigFRA22);

(* 15/12/98 : l'arretsimple associe au sig12 est deplace en aval. On Ajoute *)
(*            un pt arret sub pour proteger le cdv 13                       *)
(* 07/01/99 : correction                                                    *)
   OuDD( CdvFRA13, AigFRA13.PosReverseFiltree ,PtArrCdvFRA13);

(*** lecture des entrees de regulation ***)

   LireEntreesRegul;

END ExeSpecific;
END Specific.
