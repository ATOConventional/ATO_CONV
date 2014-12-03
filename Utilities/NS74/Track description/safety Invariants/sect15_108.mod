IMPLEMENTATION MODULE Specific;

(*$S- *)
(*$T- *)

(******************************************************************************
*   SANTIAGO - LIGNE 2 - Secteur 15
*  =============================
*  Version : 1.0.1
*  Date    : 14/04/1997
*  Auteur  : Marc Plywacz
*  Premiere Version
******************************************************************************)
(* FC : correction dans le procemissoltrain du tronc 5 le 20/8/1997;
	demande: equipe de developpement *)

(* Date : 30/09/1997
   Version : 1.0.2 
   Auteur : P. Hog
   Nature : Procedure "InitSpecDivers", correction de la configuration de la
            boucle 3 (AM Gauvin 016).
 *)
                
(* Date : 23/01/1998
   Version : 1.0.3 
   Auteur : F. Chanier
   Nature : modification pour detection des defaillances d'ampli
 *)
(*---------------------------------------------------------------------------*)
(*****************************************************************************)
(***            AJOUT DE LA NUMEROTATION SCCS DES VERSIONS                ****)
(*---------------------------------------------------------------------------*)
(* Version 1.0.4  =====================                                      *)
(* Version 1.5 DU SERVEUR SCCS =====================                         *)
(* Date :         21/09/1998                                                 *)
(* Auteur:        H. Le Roy                                                  *)
(* Modification : Fiche d'anomalie ba040998                                  *)
(*                Suite a un changement de vitesses maximales, mise a jour   *)
(*                des marches types                                          *)
(*****************************************************************************)
(* Version 1.0.5  =====================                                      *)
(* Version 1.6 DU SERVEUR SCCS =====================                         *)
(* Date :         15/04/1999                                                 *)
(* Auteur:        H. Le Roy                                                  *)
(* Modification : Adaptation de la configuration des amplis au standard      *)
(*                 1.3.3. Suppression de parties de code inutiles concernant *)
(*                 les DAMTC                                                *)
(*****************************************************************************)
(* Version 1.0.6  =====================                                      *)
(* Version 1.7 DU SERVEUR SCCS =====================                         *)
(* Date :         21/04/1999                                                 *)
(* Auteur:        H. Le Roy                                                  *)
(* Modification : Config. des amplis pour detecter les pannes de fusibles    *)
(*****************************************************************************)
(* Version 1.0.7  =====================                                      *)
(* Version 1.8 DU SERVEUR SCCS =====================                         *)
(* Date :         15/06/2000                                                 *)
(* Auteur:        H. Le Roy                                                  *)
(* Modification :  Am165 : modification des marches types                    *)
(*****************************************************************************)
(* Version 1.0.8  =====================                                      *)
(* Version 1.9 DU SERVEUR SCCS =====================                         *)
(* Date :         07/08/2006                                                 *)
(* Auteur:        Rudy Nsiona                                                *)
(* Modification : Nouveau Train NS2004                                       *)
(* Procédure CONFIGURATION DES TRONCONS TSR                                  *)
(*                ancienne valeur 1 , nouvelle 2                             *)

(******************************  IMPORTATIONS  *******************************)

FROM SYSTEM     IMPORT ADR;

FROM Opel       IMPORT StockAdres, AffectBoolD, AffectBoolC, BoolC, BoolD, EtDD, CodeD, NonD,
		       Tvrai, FinBranche, FinArbre, AffectC, OuDD;

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
              		Ampli21, Ampli22, Ampli23, Ampli24,
              		Ampli31, Ampli32, Ampli33, Ampli34, Ampli35,
              		Ampli41, Ampli42, Ampli43, Ampli44, Ampli45,
              		Ampli51, Ampli52, Ampli53, Ampli54,
              		Ampli61, Ampli62, Ampli63, Ampli64, Ampli65,
                                                                               
(* variables *)
                       Boucle1, Boucle2, Boucle3, Boucle4, Boucle5, Boucle6, BoucleFictive,
		       CarteCes1,  CarteCes2,  CarteCes3, 
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

(* supprime *)
    LigneL02 = 16384*00; (* numero de ligne decale de 2**14 *)

    L0216  = 1024*16;    (* numero Secteur aval voie impaire decale de 2**10 *)

    L0215  = 1024*15;    (* numero Secteur local decale de 2**10 *)

    L0214  = 1024*14;    (* numero Secteur amont voie impaire decale de 2**10 *)


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

(** No des stations du secteur 12 **)
(* ligne 1: 1,2 ; ligne 2: 3,4; ligne 5: 5,6 *)
    noMIGv1 = 3*32 + 9;
    noMIGv2 = 3*32 + 5;
    noVIAv1 = 3*32 + 10;
    noVIAv2 = 3*32 + 4;
    noDEPv1 = 3*32 + 11;
    noDEPv2 = 3*32 + 3;

(** indication de sens **)
    SensUp = TRUE;

(** No de Voie d'emissions SOL-Train, d'emission/reception inter-secteur **)
    noBoucleova = 00; 
    noBouclefra = 01; 
    noBouclefi = 02;
    noBoucle1 = 03;
    noBoucle2 = 04;
    noBoucle3 = 05;
    noBoucle4 = 06;
    noBoucle5 = 07;
    noBoucle6 = 08;

(* numero de version *)
    noVersion = 01;

(** Base pour les tables de compensation **)
    BaseEntVar	= 500 	;
    BaseSorVar	= 600 	;
    BaseExeAig	= 1280	;
    BaseExeChainage = 1360 ;
    BaseExeSpecific = 1950 ;


(* DECLARATION DES VARIABLES GENERALES *)
 VAR
              Bouclefra, Boucleova : TyBoucle;


(* DECLARATION DES SINGULARITES DU SECTEUR 15 : dans les deux sens confondus *)


(* Declaration des variables correspondant a des entrees securitaires  *)
(*   - CDV et signaux                                                  *)
    CdvMIG11,      (* entree  1, soit entree 0 de CES 02  *)
    CdvMIG12,      (* entree  2, soit entree 1 de CES 02  *)
    CdvMIG13,      (* entree  3, soit entree 2 de CES 02  *)
    CdvMIG14,      (* entree  4, soit entree 3 de CES 02  *)
    CdvVIA11,      (* entree  5, soit entree 4 de CES 02  *)
    CdvVIA12,      (* entree  6, soit entree 5 de CES 02  *)
    CdvVIA13,      (* entree  7, soit entree 6 de CES 02  *)
    CdvVIA14,      (* entree  8, soit entree 7 de CES 02  *)
    CdvDEP11,      (* entree  9, soit entree 0 de CES 03  *)
    CdvDEP12,      (* entree 10, soit entree 1 de CES 03  *)
    CdvDEP13,      (* entree 11, soit entree 2 de CES 03  *)
    CdvDEP14,      (* entree 12, soit entree 3 de CES 03  *)
    CdvDEP23,      (* entree 13, soit entree 4 de CES 03  *)
    CdvDEP22,      (* entree 14, soit entree 5 de CES 03  *)
    CdvDEP21,      (* entree 15, soit entree 6 de CES 03  *)
    CdvDEP20,      (* entree 16, soit entree 7 de CES 03  *)
    CdvVIA23,      (* entree 17, soit entree 0 de CES 04  *)
    CdvVIA22,      (* entree 18, soit entree 1 de CES 04  *)
    CdvVIA21,      (* entree 19, soit entree 2 de CES 04  *)
    CdvVIA20,      (* entree 20, soit entree 3 de CES 04  *)
    CdvMIG23,      (* entree 21, soit entree 4 de CES 04  *)
    CdvMIG22,      (* entree 22, soit entree 5 de CES 04  *)
    CdvMIG21,      (* entree 23, soit entree 6 de CES 04  *)
    CdvMIG20       (* entree 24, soit entree 7 de CES 04  *)
             : BoolD;

(*   - aiguilles                                                       *)
    (* pas d'aiguille *)



(* Variables ne correspondant pas a une entree securitaire *)
(* Point d'arret *)
    PtArrCdvMIG11,
    PtArrCdvMIG12,
    PtArrCdvMIG13,
    PtArrCdvMIG14,
    PtArrCdvVIA11,
    PtArrCdvVIA12,
    PtArrCdvVIA13,
    PtArrCdvVIA14,
    PtArrCdvDEP11,
    PtArrCdvDEP12,
    PtArrCdvDEP13,
    PtArrCdvDEP14,
    PtArrCdvDEP23,
    PtArrCdvDEP22,
    PtArrCdvDEP21,
    PtArrCdvDEP20,
    PtArrCdvVIA23,
    PtArrCdvVIA22,
    PtArrCdvVIA21,
    PtArrCdvVIA20,
    PtArrCdvMIG23,
    PtArrCdvMIG22,
    PtArrCdvMIG21,
    PtArrCdvMIG20   : BoolD;

(* Variants anticipes *)
    PtAntCdvNIN06,
    PtAntCdvLLA23   : BoolD;

(* Copie des entrees dans des variables fonctionnelles pour la regulation *)
    CdvVIA12Fonc,
    CdvVIA22Fonc,
    CdvMIG12Fonc,
    CdvMIG22Fonc,
    CdvDEP12Fonc,
    CdvDEP22Fonc     : BOOLEAN;

(** Voie d'emission SOL-TRAIN : deux sens confondus**)
    te11s15t01,
    te14s15t02,
    te16s15t03,
    te21s15t04,
    te24s15t05,
    te26s15t06           :TyEmissionTele;

(** Voie d'emission Inter-secteur deux voies confondues **)
    teL0216,
    teL0214	          :TyEmissionTele;

(** Voie de reception Inter-secteur deux voies confondues **)
    trL0216,
    trL0214               :TyCaracEntSec;

(* boucle en amont des 2 voies *)
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

DeclarerVersionSpecific (35);


(* CONFIGURATIONS DIVERSES ****************************************************)

(* CONFIGURATION DES AIGUILLES, POUR LES DEUX VOIES *)
   (* pas d'aiguille *)

(* Configuration des entrees *)
    ProcEntreeIntrins(  1, CdvMIG11);
    ProcEntreeIntrins(  2, CdvMIG12);
    ProcEntreeIntrins(  3, CdvMIG13);
    ProcEntreeIntrins(  4, CdvMIG14);
    ProcEntreeIntrins(  5, CdvVIA11);
    ProcEntreeIntrins(  6, CdvVIA12);
    ProcEntreeIntrins(  7, CdvVIA13);
    ProcEntreeIntrins(  8, CdvVIA14);
    ProcEntreeIntrins(  9, CdvDEP11);
    ProcEntreeIntrins( 10, CdvDEP12);
    ProcEntreeIntrins( 11, CdvDEP13);
    ProcEntreeIntrins( 12, CdvDEP14);
    ProcEntreeIntrins( 13, CdvDEP23);
    ProcEntreeIntrins( 14, CdvDEP22);
    ProcEntreeIntrins( 15, CdvDEP21);
    ProcEntreeIntrins( 16, CdvDEP20);
    ProcEntreeIntrins( 17, CdvVIA23);
    ProcEntreeIntrins( 18, CdvVIA22);
    ProcEntreeIntrins( 19, CdvVIA21);
    ProcEntreeIntrins( 20, CdvVIA20);
    ProcEntreeIntrins( 21, CdvMIG23);
    ProcEntreeIntrins( 22, CdvMIG22);
    ProcEntreeIntrins( 23, CdvMIG21);
    ProcEntreeIntrins( 24, CdvMIG20);


(* CONFIGURATION POUR LA MAINTENANCE de la transmission continue *)
   ConfigurerBoucle(Boucle1, 1);
   ConfigurerBoucle(Boucle2, 2);
   ConfigurerBoucle(Boucle3, 3);
   ConfigurerBoucle(Boucle4, 4);
   ConfigurerBoucle(Boucle5, 5);
   ConfigurerBoucle(Boucle6, 6);

   ConfigurerAmpli(Ampli11, 1, 1, 154, 11, FALSE);
   ConfigurerAmpli(Ampli12, 1, 2, 155, 12, FALSE);
   ConfigurerAmpli(Ampli13, 1, 3, 156, 12, FALSE);
   ConfigurerAmpli(Ampli14, 1, 4, 157, 12, TRUE);

   ConfigurerAmpli(Ampli21, 2, 1, 158, 14, FALSE);
   ConfigurerAmpli(Ampli22, 2, 2, 159, 15, FALSE);
   ConfigurerAmpli(Ampli23, 2, 3, 192, 15, FALSE);
   ConfigurerAmpli(Ampli24, 2, 4, 193, 15, TRUE);
                                                
   ConfigurerAmpli(Ampli31, 3, 1, 194, 16, FALSE);
   ConfigurerAmpli(Ampli32, 3, 2, 195, 17, FALSE);
   ConfigurerAmpli(Ampli33, 3, 3, 196, 17, TRUE);
   ConfigurerAmpli(Ampli34, 3, 4, 197, 17, TRUE);
   ConfigurerAmpli(Ampli35, 3, 5, 198, 18, FALSE); 

   ConfigurerAmpli(Ampli41, 4, 1, 199, 21, FALSE);
   ConfigurerAmpli(Ampli42, 4, 2, 200, 22, FALSE);
   ConfigurerAmpli(Ampli43, 4, 3, 201, 22, FALSE);
   ConfigurerAmpli(Ampli44, 4, 4, 202, 22, TRUE);
   ConfigurerAmpli(Ampli45, 4, 5, 203, 23, FALSE); 

   ConfigurerAmpli(Ampli51, 5, 1, 204, 24, FALSE);
   ConfigurerAmpli(Ampli52, 5, 2, 205, 25, FALSE);
   ConfigurerAmpli(Ampli53, 5, 3, 206, 25, FALSE);
   ConfigurerAmpli(Ampli54, 5, 4, 207, 25, TRUE);
                                                
   ConfigurerAmpli(Ampli61, 6, 1, 208, 26, FALSE);
   ConfigurerAmpli(Ampli62, 6, 2, 209, 27, FALSE);
   ConfigurerAmpli(Ampli63, 6, 3, 210, 27, FALSE);
   ConfigurerAmpli(Ampli64, 6, 4, 211, 27, TRUE);
   ConfigurerAmpli(Ampli65, 6, 5, 212, 23, TRUE);   


 (** cartes CES **)
   ConfigurerCES(CarteCes1, 01);
   ConfigurerCES(CarteCes2, 02);
   ConfigurerCES(CarteCes3, 03);


(** Liaisons Inter-Secteur **)

   ConfigurerIntsecteur(Intersecteur1, 01, trL0216, trL0214);


(* Initialisations des variables ne correspondant pas a des entrees secu *)
(* Point d'arret *)
    AffectBoolD( BoolRestrictif, PtArrCdvMIG11);
    AffectBoolD( BoolRestrictif, PtArrCdvMIG12);
    AffectBoolD( BoolRestrictif, PtArrCdvMIG13);
    AffectBoolD( BoolRestrictif, PtArrCdvMIG14);
    AffectBoolD( BoolRestrictif, PtArrCdvVIA11);
    AffectBoolD( BoolRestrictif, PtArrCdvVIA12);
    AffectBoolD( BoolRestrictif, PtArrCdvVIA13);
    AffectBoolD( BoolRestrictif, PtArrCdvVIA14);
    AffectBoolD( BoolRestrictif, PtArrCdvDEP11);
    AffectBoolD( BoolRestrictif, PtArrCdvDEP12);
    AffectBoolD( BoolRestrictif, PtArrCdvDEP13);
    AffectBoolD( BoolRestrictif, PtArrCdvDEP14);
    AffectBoolD( BoolRestrictif, PtArrCdvDEP23);
    AffectBoolD( BoolRestrictif, PtArrCdvDEP22);
    AffectBoolD( BoolRestrictif, PtArrCdvDEP21);
    AffectBoolD( BoolRestrictif, PtArrCdvDEP20);
    AffectBoolD( BoolRestrictif, PtArrCdvVIA23);
    AffectBoolD( BoolRestrictif, PtArrCdvVIA22);
    AffectBoolD( BoolRestrictif, PtArrCdvVIA21);
    AffectBoolD( BoolRestrictif, PtArrCdvVIA20);
    AffectBoolD( BoolRestrictif, PtArrCdvMIG23);
    AffectBoolD( BoolRestrictif, PtArrCdvMIG22);
    AffectBoolD( BoolRestrictif, PtArrCdvMIG21);
    AffectBoolD( BoolRestrictif, PtArrCdvMIG20);

(* Variants anticipes *)
    AffectBoolD( BoolRestrictif, PtAntCdvNIN06);
    AffectBoolD( BoolRestrictif, PtAntCdvLLA23);

(* Copie des entrees dans des variables fonctionnelles pour la regulation *)
    CdvVIA12Fonc := FALSE;
    CdvVIA22Fonc := FALSE;
    CdvMIG12Fonc := FALSE;
    CdvMIG22Fonc := FALSE;
    CdvDEP12Fonc := FALSE;
    CdvDEP22Fonc := FALSE;

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

   ConfigEmisTeleSolTrain ( te11s15t01,
                            noBoucle1,         
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);


   ConfigEmisTeleSolTrain ( te14s15t02,
                            noBoucle2,         
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);
   

     
   ConfigEmisTeleSolTrain ( te16s15t03,
                            noBoucle3,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);


   ConfigEmisTeleSolTrain ( te21s15t04,
                            noBoucle4,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);
 
   ConfigEmisTeleSolTrain ( te24s15t05,
                            noBoucle5,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);
  
   ConfigEmisTeleSolTrain ( te26s15t06,
                            noBoucle6,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);


(* CONFIGURATION POUR LA REGULATION *)
   ConfigQuai (39, 74, CdvMIG12Fonc, te11s15t01, 0,  3,  4, 11, 10, 13, 14, 15);
   ConfigQuai (39, 79, CdvMIG22Fonc, te26s15t06, 0, 11,  5, 10,  6, 13, 14, 15);
   ConfigQuai (40, 64, CdvVIA12Fonc, te14s15t02, 0,  9,  4,  5, 10, 13, 14, 15);
   ConfigQuai (40, 69, CdvVIA22Fonc, te24s15t05, 0,  3,  9, 11,  5, 13, 14, 15);
   ConfigQuai (41, 84, CdvDEP12Fonc, te16s15t03, 0,  3,  4,  5, 10, 13, 14, 15);
   ConfigQuai (41, 89, CdvDEP22Fonc, te21s15t04, 0,  2,  9,  4,  5, 13, 14, 15);

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

(* CONFIGURATION DES EMISSIONS DE VARIANTS SOL-TRAIN vers VOIE *************)

(* variants troncon 1   voie 1 --> si *)
   ProcEmisSolTrain( te11s15t01.EmissionSensUp, (2*noBoucle1), 
                     LigneL02+ L0215+ TRONC*01,     

              PtArrCdvMIG11,
              PtArrCdvMIG12,
              PtArrCdvMIG13,
              PtArrCdvMIG14,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
(* Variants Anticipes *)
              PtArrCdvVIA11,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
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
   ProcEmisSolTrain( te14s15t02.EmissionSensUp, (2*noBoucle2), 
                     LigneL02+ L0215+ TRONC*02,     

              PtArrCdvVIA11,
              PtArrCdvVIA12,
              PtArrCdvVIA13,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
                  
	      (* Variants Anticipes *)
              PtArrCdvVIA14,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
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


(* variants troncon 3    voie 1  ---> si  *)
   ProcEmisSolTrain( te16s15t03.EmissionSensUp, (2*noBoucle3), 
                     LigneL02+ L0215+ TRONC*03,     

              PtArrCdvVIA14,
              PtArrCdvDEP11,
              PtArrCdvDEP12,
              PtArrCdvDEP13,
              PtArrCdvDEP14,
              BoolRestrictif,
              BoolRestrictif, 
              BoolRestrictif,                     
(* Variants Anticipes *)
              PtAntCdvNIN06,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
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
   ProcEmisSolTrain( te21s15t04.EmissionSensUp, (2*noBoucle4), 
                     LigneL02+ L0215+ TRONC*04,     
  
              PtArrCdvDEP23,
              PtArrCdvDEP22,
              PtArrCdvDEP21,
              PtArrCdvDEP20,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,

(* Variants Anticipes *)
              PtArrCdvVIA23,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
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

(* FC : le 20/8/1997 correction d'une erreur sur les quatre premiers variants:
   On envoyait les points d'arret de DEP au lieu de  VIA			*)
(* variants du troncon 5 voie 2 <-- sp *)
   ProcEmisSolTrain( te24s15t05.EmissionSensUp, (2*noBoucle5), 
                     LigneL02+ L0215+ TRONC*05,     

              PtArrCdvVIA23,
              PtArrCdvVIA22,
              PtArrCdvVIA21,
              PtArrCdvVIA20,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
(* Variants Anticipes *)
              PtArrCdvMIG23,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
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

(*  *)
(* variants du troncon 6 voie 2 <-- sp *)
   ProcEmisSolTrain( te26s15t06.EmissionSensUp, (2*noBoucle6), 
                     LigneL02+ L0215+ TRONC*06,     

              PtArrCdvMIG23,
              PtArrCdvMIG22,
              PtArrCdvMIG21,
              PtArrCdvMIG20,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
(* Variants Anticipes *)
               PtAntCdvLLA23,
               BoolRestrictif,
               BoolRestrictif,
               BoolRestrictif,
               BoolRestrictif,
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

(*  *)
(* reception du secteur 16 -aval- *)

   ProcReceptInterSecteur(trL0216, noBoucleova, LigneL02+ L0216+ TRONC*01,
                  PtAntCdvNIN06,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif, 
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

(* reception du secteur 14 -amont- *)

   ProcReceptInterSecteur(trL0214, noBouclefra, LigneL02+ L0214+ TRONC*03,

                  PtAntCdvLLA23,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif, 
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
(* emission vers le secteur 16 -aval- *)

   ProcEmisInterSecteur (teL0216, noBoucleova, LigneL02+ L0215+ TRONC*04,
			noBoucleova,
                  PtArrCdvDEP23,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif, 
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
                  Boucle5.PanneTrans,
		  V4,
                  V5, 
		  V6,
		  BaseSorVar + 180);


(*  *)

(* emission vers le secteur 14 -amont- *)

   ProcEmisInterSecteur (teL0214, noBouclefra, LigneL02+ L0215+ TRONC*01,
			noBouclefra,
                  PtArrCdvMIG11,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif, 
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

(********* CONFIGURATION DES EMISSION DES INVARIANTS SECURITAIRES ********)

(* Tous les sens doivent etre a SensUp ; il n'y a pas de commutation *)
            

 (** Emission invariants vers secteur 16 aval L0216 **)

   EmettreSegm(LigneL02+ L0215+ TRONC*04+ SEGM*00, noBoucleova, SensUp);

 (** Emission invariants vers secteur 14 amont L0214 **)

   EmettreSegm(LigneL02+ L0215+ TRONC*01+ SEGM*00, noBouclefra, SensUp);

 (** Boucle 1 **)        
   EmettreSegm(LigneL02+ L0215+ TRONC*01+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL02+ L0215+ TRONC*02+ SEGM*00, noBoucle1, SensUp);

 (** Boucle 2 **)        
   EmettreSegm(LigneL02+ L0215+ TRONC*02+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL02+ L0215+ TRONC*03+ SEGM*00, noBoucle2, SensUp);

 (** Boucle 3 **)  
   EmettreSegm(LigneL02+ L0215+ TRONC*03+ SEGM*00, noBoucle3, SensUp);
   EmettreSegm(LigneL02+ L0216+ TRONC*01+ SEGM*00, noBoucle3, SensUp);
   EmettreSegm(LigneL02+ L0216+ TRONC*01+ SEGM*01, noBoucle3, SensUp);

 (** Boucle 4 **)  
   EmettreSegm(LigneL02+ L0215+ TRONC*04+ SEGM*00, noBoucle4, SensUp);
   EmettreSegm(LigneL02+ L0215+ TRONC*05+ SEGM*00, noBoucle4, SensUp);

 (** Boucle 5 **) 
   EmettreSegm(LigneL02+ L0215+ TRONC*05+ SEGM*00, noBoucle5, SensUp);
   EmettreSegm(LigneL02+ L0215+ TRONC*06+ SEGM*00, noBoucle5, SensUp);
  
 (** Boucle 6 **)        
   EmettreSegm(LigneL02+ L0215+ TRONC*06+ SEGM*00, noBoucle6, SensUp);
   EmettreSegm(LigneL02+ L0214+ TRONC*03+ SEGM*00, noBoucle6, SensUp);

(*  *) 

(************************* CONFIGURATION DES TRONCONS TSR **************************)

   ConfigurerTroncon(Tronc0, LigneL02 + L0215 + TRONC*01, 2,2,2,2);  (* troncon 15-1 *)
   ConfigurerTroncon(Tronc1, LigneL02 + L0215 + TRONC*02, 2,2,2,2);  (* troncon 15-2 *)
   ConfigurerTroncon(Tronc2, LigneL02 + L0215 + TRONC*03, 2,2,2,2);  (* troncon 15-3 *)
   ConfigurerTroncon(Tronc3, LigneL02 + L0215 + TRONC*04, 2,2,2,2);  (* troncon 15-4 *)
   ConfigurerTroncon(Tronc4, LigneL02 + L0215 + TRONC*05, 2,2,2,2);  (* troncon 15-5 *)
   ConfigurerTroncon(Tronc5, LigneL02 + L0215 + TRONC*06, 2,2,2,2);  (* troncon 15-6 *)


(************************************* EMISSION DES TSR **************************************)



(** Emission des TSR vers le secteur aval 16 L0216 **)

   EmettreTronc(LigneL02+ L0215+ TRONC*04, noBoucleova, SensUp);


(** Emission des TSR vers le secteur amont 14 L0214 **)

   EmettreTronc(LigneL02+ L0215+ TRONC*01, noBouclefra, SensUp);




 (** Emission des TSR sur les troncons du secteur courant **)

   EmettreTronc(LigneL02+ L0215+ TRONC*01, noBoucle1, SensUp); (* troncon 15-1 *)
   EmettreTronc(LigneL02+ L0215+ TRONC*02, noBoucle1, SensUp);


   EmettreTronc(LigneL02+ L0215+ TRONC*02, noBoucle2, SensUp); (* troncon 15-2 *)
   EmettreTronc(LigneL02+ L0215+ TRONC*03, noBoucle2, SensUp);


   EmettreTronc(LigneL02+ L0215+ TRONC*03, noBoucle3, SensUp); (* troncon 15-3 *)
   EmettreTronc(LigneL02+ L0216+ TRONC*01, noBoucle3, SensUp);


   EmettreTronc(LigneL02+ L0215+ TRONC*04, noBoucle4, SensUp); (* troncon 15-4 *)
   EmettreTronc(LigneL02+ L0215+ TRONC*05, noBoucle4, SensUp);


   EmettreTronc(LigneL02+ L0215+ TRONC*05, noBoucle5, SensUp); (* troncon 15-5 *)
   EmettreTronc(LigneL02+ L0215+ TRONC*06, noBoucle5, SensUp);

 
   EmettreTronc(LigneL02+ L0215+ TRONC*06, noBoucle6, SensUp); (* troncon 15-6 *)
   EmettreTronc(LigneL02+ L0214+ TRONC*03, noBoucle6, SensUp);


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
    StockAdres( ADR( CdvMIG11));
    StockAdres( ADR( CdvMIG12));
    StockAdres( ADR( CdvMIG13));
    StockAdres( ADR( CdvMIG14));
    StockAdres( ADR( CdvVIA11));
    StockAdres( ADR( CdvVIA12));
    StockAdres( ADR( CdvVIA13));
    StockAdres( ADR( CdvVIA14));
    StockAdres( ADR( CdvDEP11));
    StockAdres( ADR( CdvDEP12));
    StockAdres( ADR( CdvDEP13));
    StockAdres( ADR( CdvDEP14));
    StockAdres( ADR( CdvDEP23));
    StockAdres( ADR( CdvDEP22));
    StockAdres( ADR( CdvDEP21));
    StockAdres( ADR( CdvDEP20));
    StockAdres( ADR( CdvVIA23));
    StockAdres( ADR( CdvVIA22));
    StockAdres( ADR( CdvVIA21));
    StockAdres( ADR( CdvVIA20));
    StockAdres( ADR( CdvMIG23));
    StockAdres( ADR( CdvMIG22));
    StockAdres( ADR( CdvMIG21));
    StockAdres( ADR( CdvMIG20));

    StockAdres( ADR( PtArrCdvMIG11));
    StockAdres( ADR( PtArrCdvMIG12));
    StockAdres( ADR( PtArrCdvMIG13));
    StockAdres( ADR( PtArrCdvMIG14));
    StockAdres( ADR( PtArrCdvVIA11));
    StockAdres( ADR( PtArrCdvVIA12));
    StockAdres( ADR( PtArrCdvVIA13));
    StockAdres( ADR( PtArrCdvVIA14));
    StockAdres( ADR( PtArrCdvDEP11));
    StockAdres( ADR( PtArrCdvDEP12));
    StockAdres( ADR( PtArrCdvDEP13));
    StockAdres( ADR( PtArrCdvDEP14));
    StockAdres( ADR( PtArrCdvDEP23));
    StockAdres( ADR( PtArrCdvDEP22));
    StockAdres( ADR( PtArrCdvDEP21));
    StockAdres( ADR( PtArrCdvDEP20));
    StockAdres( ADR( PtArrCdvVIA23));
    StockAdres( ADR( PtArrCdvVIA22));
    StockAdres( ADR( PtArrCdvVIA21));
    StockAdres( ADR( PtArrCdvVIA20));
    StockAdres( ADR( PtArrCdvMIG23));
    StockAdres( ADR( PtArrCdvMIG22));
    StockAdres( ADR( PtArrCdvMIG21));
    StockAdres( ADR( PtArrCdvMIG20));

    StockAdres( ADR( PtAntCdvNIN06));
    StockAdres( ADR( PtAntCdvLLA23));

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
BEGIN (* ExeSpecific *)

(* Affectation des "constantes" utilisees dans la construction des messages emis    *)
(* et recus sur les boucles de transmission continue et sur les liens intersecteur. *)
(* Cette reaffectation est necessaire a chaque cycle pour la mise en securite.      *)
   AffectBoolC(Vrai, BoolPermissif)  ;
   AffectBoolC(Faux, BoolRestrictif) ;

(* regulation *)
   CdvVIA12Fonc := CdvVIA12.F = Vrai.F;
   CdvVIA22Fonc := CdvVIA22.F = Vrai.F;
   CdvMIG12Fonc := CdvMIG12.F = Vrai.F;
   CdvMIG22Fonc := CdvMIG22.F = Vrai.F;
   CdvDEP12Fonc := CdvDEP12.F = Vrai.F;
   CdvDEP22Fonc := CdvDEP22.F = Vrai.F;


(*  *)
(******************************* FILTRAGE DES AIGUILLES *******************************)

  (* pas d'aiguille *)

(************************** Gerer les point d'arrets **************************)

   AffectBoolD( CdvMIG11,                   PtArrCdvMIG11);
   AffectBoolD( CdvMIG12,                   PtArrCdvMIG12);
   AffectBoolD( CdvMIG13,                   PtArrCdvMIG13);
   AffectBoolD( CdvMIG14,                   PtArrCdvMIG14);
   AffectBoolD( CdvVIA11,                   PtArrCdvVIA11);
   AffectBoolD( CdvVIA12,                   PtArrCdvVIA12);
   AffectBoolD( CdvVIA13,                   PtArrCdvVIA13);
   AffectBoolD( CdvVIA14,                   PtArrCdvVIA14);
   AffectBoolD( CdvDEP11,                   PtArrCdvDEP11);
   AffectBoolD( CdvDEP12,                   PtArrCdvDEP12);
   AffectBoolD( CdvDEP13,                   PtArrCdvDEP13);
   AffectBoolD( CdvDEP14,                   PtArrCdvDEP14);
   AffectBoolD( CdvDEP23,                   PtArrCdvDEP23);
   AffectBoolD( CdvDEP22,                   PtArrCdvDEP22);
   AffectBoolD( CdvDEP21,                   PtArrCdvDEP21);
   AffectBoolD( CdvDEP20,                   PtArrCdvDEP20);
   AffectBoolD( CdvVIA23,                   PtArrCdvVIA23);
   AffectBoolD( CdvVIA22,                   PtArrCdvVIA22);
   AffectBoolD( CdvVIA21,                   PtArrCdvVIA21);
   AffectBoolD( CdvVIA20,                   PtArrCdvVIA20);
   AffectBoolD( CdvMIG23,                   PtArrCdvMIG23);
   AffectBoolD( CdvMIG22,                   PtArrCdvMIG22);
   AffectBoolD( CdvMIG21,                   PtArrCdvMIG21);
   AffectBoolD( CdvMIG20,                   PtArrCdvMIG20);


(*** lecture des entrees de regulation ***)

   LireEntreesRegul;

END ExeSpecific;
END Specific.
