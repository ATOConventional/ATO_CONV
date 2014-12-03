IMPLEMENTATION MODULE Specific;

(*$S- *)
(*$T- *)

(******************************************************************************
*   SANTIAGO - LIGNE 2 - Secteur 13
*  =============================
*  Version : SCCS 1.0
*  Date    : 28/03/1997
*  Auteur  : Marc Plywacz
*  Premiere Version
******************************************************************************)
(* Date : 11/09/1997,
   Auteur : F. Chanier,
   Origine : validation Gauvin n 0001
   version : 1.0.1
   nature : erreur dans la configuration boucle n3 *) 

(* Date : 23/01/1998,
   Auteur : F. Chanier,
   Origine : eq. dev.
   version : 1.0.2
   nature : modification pour detection def. ampli *) 
(*---------------------------------------------------------------------------*)
(*****************************************************************************)
(***            AJOUT DE LA NUMEROTATION SCCS DES VERSIONS                ****)
(*---------------------------------------------------------------------------*)
(* Version 1.0.3  =====================                                      *)
(* Version 1.4 DU SERVEUR SCCS =====================                         *)
(* Date :         21/09/1998                                                 *)
(* Auteur:        H. Le Roy                                                  *)
(* Modification : Fiche d'anomalie ba040998                                  *)
(*                Suite a un changement de vitesses maximales, mise a jour   *)
(*                des marches types                                          *)
(*****************************************************************************)
(* Version 1.0.4  =====================                                      *)
(* Version 1.5 DU SERVEUR SCCS =====================                         *)
(* Date :         14/04/1999                                                 *)
(* Auteur:        H. Le Roy                                                  *)
(* Modification : Adaptation de la configuration des amplis au standard      *)
(*                 1.3.3. Ajout d'entrees pour fusibles. Suppression de      *)
(*                 parties de code inutiles concernant les DAMTC.            *)
(*****************************************************************************)
(* Version 1.0.5  =====================                                      *)
(* Version 1.6 DU SERVEUR SCCS =====================                         *)
(* Date :         05/07/1999                                                 *)
(* Auteur:        H. Le Roy                                                  *)
(* Modification : correction d'une mauvaise assignation d'entree pour DAMTC  *)
(*****************************************************************************)
(* Version 1.0.6  =====================                                      *)
(* Version 1.7 DU SERVEUR SCCS =====================                         *)
(* Date :         15/06/2000                                                 *)
(* Auteur:        H. Le Roy                                                  *)
(* Modification : Am165 : modification des marches types                     *)
(*****************************************************************************)
(* Version 1.0.7  =====================                                      *)
(* Version 1.8 DU SERVEUR SCCS =====================                         *)
(* date : 07/08/06, Auteur : Rudy. Nsiona, Origine : Nouveau Train NS2004    *)
(* Modification : Nouveau Train NS2004                                       *)
(* Procédure CONFIGURATION DES TRONCONS TSR                                   *)
(*                ancienne valeur 1 , nouvelle 2                             *)
(*****************************  IMPORTATIONS  ********************************)
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

              		Ampli11, Ampli12, Ampli13, Ampli14, Ampli15, Ampli16, Ampli17, 
              		Ampli21, Ampli22, Ampli23, Ampli24, Ampli25,          Ampli27,    
              		Ampli31, Ampli32, Ampli33, Ampli34, Ampli35,          Ampli37,
              		Ampli41, Ampli42, Ampli43, Ampli44, Ampli45, Ampli46, Ampli47,    

(* variables *)
                       Boucle1, Boucle2, Boucle3, Boucle4,  BoucleFictive,
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

    L0214  = 1024*14;    (* numero Secteur aval voie impaire decale de 2**10 *)

    L0213  = 1024*13;    (* numero Secteur local decale de 2**10 *)

    L0212  = 1024*12;    (* numero Secteur amont voie impaire decale de 2**10 *)

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

(** No des stations du secteur 13 **)
(* ligne 1: 1,2 ; ligne 2: 3,4; ligne 5: 5,6 *)
    noHIGv1 = 3*32 + 5;
    noHIGv2 = 4*32 + 9;
    noRONv1 = 3*32 + 6;
    noRONv2 = 4*32 + 8;

(** indication de sens **)
    SensUp = TRUE;

(** No de Voie d'emissions SOL-Train, d'emission/reception inter-secteur **)
    noBouclefra = 00; 
    noBoucleheb = 01; 
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


(* DECLARATION DES VARIABLES GENERALES *)
 VAR
              Bouclefra, Boucleheb, Bouclefi : TyBoucle;

(* DECLARATION DES SINGULARITES DU SECTEUR 13 : dans les deux sens confondus *)


(* Declaration des variables correspondant a des entrees securitaires  *)
(*   - CDV et signaux                                                  *)
    CdvHIG11A,     (* entree  1, soit entree 0 de CES 02  *)
    CdvHIG11B,     (* entree  2, soit entree 1 de CES 02  *)
    CdvHIG12,      (* entree  3, soit entree 2 de CES 02  *)
    CdvHIG13,      (* entree  4, soit entree 3 de CES 02  *)
    CdvHIG14,      (* entree  5, soit entree 4 de CES 02  *)
    CdvRON11,      (* entree  6, soit entree 5 de CES 02  *)
    CdvRON12,      (* entree  7, soit entree 6 de CES 02  *)
    CdvRON13,      (* entree  8, soit entree 7 de CES 02  *)
    CdvRON23,      (* entree  9, soit entree 0 de CES 03  *)
    CdvRON22,      (* entree 10, soit entree 1 de CES 03  *)
    CdvRON21,      (* entree 11, soit entree 2 de CES 03  *)
    CdvRON20,      (* entree 12, soit entree 3 de CES 03  *)
    CdvHIG23,      (* entree 13, soit entree 4 de CES 03  *)
    CdvHIG22,      (* entree 14, soit entree 5 de CES 03  *)
    CdvHIG21B,     (* entree 15, soit entree 6 de CES 03  *)
    CdvHIG21A,     (* entree 16, soit entree 7 de CES 03  *)
    CdvHIG20       (* entree 17, soit entree 0 de CES 04  *)
             : BoolD;

(*   - aiguilles                                                       *)
    (* pas d'aiguilles *)



(* Variables ne correspondant pas a une entree securitaire *)
(* Point d'arret *)
    PtArrCdvHIG11,
    PtArrCdvHIG12,
    PtArrCdvHIG13,
    PtArrCdvHIG14,
    PtArrCdvRON11,
    PtArrCdvRON12,
    PtArrCdvRON13,

    PtArrCdvRON23,
    PtArrCdvRON22,
    PtArrCdvRON21,
    PtArrCdvRON20,
    PtArrCdvHIG23,
    PtArrCdvHIG22,
    PtArrCdvHIG21,
    PtArrCdvHIG20  : BoolD;

(* Variants anticipes *)
    PtAntCdvFRA10,
    PtAntSigFRA10,
    PtAntCdvTOE23  : BoolD;

(* Copie des entrees dans des variables fonctionnelles pour la regulation *)
    CdvHIG12Fonc,
    CdvRON12Fonc,
    CdvRON22Fonc,
    CdvHIG22Fonc     : BOOLEAN;

(** Voie d'emission SOL-TRAIN : deux sens confondus**)
    te11s13t01,
    te14s13t02,
    te21s13t03,
    te24s13t04           :TyEmissionTele;

(** Voie d'emission Inter-secteur deux voies confondues **)
    teL0214,
    teL0212	          :TyEmissionTele;

(** Voie de reception Inter-secteur deux voies confondues **)
    trL0214,
    trL0212               :TyCaracEntSec;
    	 
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

DeclarerVersionSpecific (31);


(******************** CONFIGURATIONS DIVERSES **********************)

(* CONFIGURATION DES AIGUILLES, POUR LES DEUX VOIES *)
(*   aucune aiguillee      *)

(* Configuration des entrees *)
    ProcEntreeIntrins (  1, CdvHIG11A);
    ProcEntreeIntrins (  2, CdvHIG11B);
    ProcEntreeIntrins (  3, CdvHIG12);
    ProcEntreeIntrins (  4, CdvHIG13);
    ProcEntreeIntrins (  5, CdvHIG14);
    ProcEntreeIntrins (  6, CdvRON11);
    ProcEntreeIntrins (  7, CdvRON12);
    ProcEntreeIntrins (  8, CdvRON13);
    ProcEntreeIntrins (  9, CdvRON23);
    ProcEntreeIntrins ( 10, CdvRON22);
    ProcEntreeIntrins ( 11, CdvRON21);
    ProcEntreeIntrins ( 12, CdvRON20);
    ProcEntreeIntrins ( 13, CdvHIG23);
    ProcEntreeIntrins ( 14, CdvHIG22);
    ProcEntreeIntrins ( 15, CdvHIG21B);
    ProcEntreeIntrins ( 16, CdvHIG21A);
    ProcEntreeIntrins ( 17, CdvHIG20);


(* CONFIGURATION POUR LA MAINTENANCE de la transmission continue *)
   ConfigurerBoucle(Boucle1, 1);
   ConfigurerBoucle(Boucle2, 2);
(* C+ : modif fiche gauvin n 0001 *)
   ConfigurerBoucle(Boucle3, 3);
   ConfigurerBoucle(Boucle4, 4);

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

   ConfigurerAmpli(Ampli27, 2, 7, 199, 16, TRUE);

   ConfigurerAmpli(Ampli31, 3, 1, 200, 21, FALSE);
   ConfigurerAmpli(Ampli32, 3, 2, 201, 22, FALSE);
   ConfigurerAmpli(Ampli33, 3, 3, 202, 22, FALSE);
   ConfigurerAmpli(Ampli34, 3, 4, 203, 22, TRUE);
   ConfigurerAmpli(Ampli35, 3, 5, 204, 23, FALSE);

   ConfigurerAmpli(Ampli37, 3, 7, 206, 23, TRUE);

   ConfigurerAmpli(Ampli41, 4, 1, 207, 24, FALSE);
   ConfigurerAmpli(Ampli42, 4, 2, 208, 25, FALSE);
   ConfigurerAmpli(Ampli43, 4, 3, 209, 25, FALSE);
   ConfigurerAmpli(Ampli44, 4, 4, 210, 25, TRUE);
   ConfigurerAmpli(Ampli45, 4, 5, 211, 26, FALSE);
   ConfigurerAmpli(Ampli46, 4, 6, 212, 26, FALSE);       
   ConfigurerAmpli(Ampli47, 4, 7, 213, 26, TRUE);       

 (** cartes CES **)
   ConfigurerCES(CarteCes1, 01);
   ConfigurerCES(CarteCes2, 02);
   ConfigurerCES(CarteCes3, 03);


(** Liaisons Inter-Secteur **)

   ConfigurerIntsecteur(Intersecteur1, 01, trL0214, trL0212);


(* Initialisations des variables ne correspondant pas a des entrees secu *)
(* Point d'arret *)
    AffectBoolD( BoolRestrictif, PtArrCdvHIG11);
    AffectBoolD( BoolRestrictif, PtArrCdvHIG12);
    AffectBoolD( BoolRestrictif, PtArrCdvHIG13);
    AffectBoolD( BoolRestrictif, PtArrCdvHIG14);
    AffectBoolD( BoolRestrictif, PtArrCdvRON11);
    AffectBoolD( BoolRestrictif, PtArrCdvRON12);
    AffectBoolD( BoolRestrictif, PtArrCdvRON13);
    AffectBoolD( BoolRestrictif, PtArrCdvRON23);
    AffectBoolD( BoolRestrictif, PtArrCdvRON22);
    AffectBoolD( BoolRestrictif, PtArrCdvRON21);
    AffectBoolD( BoolRestrictif, PtArrCdvRON20);
    AffectBoolD( BoolRestrictif, PtArrCdvHIG23);
    AffectBoolD( BoolRestrictif, PtArrCdvHIG22);
    AffectBoolD( BoolRestrictif, PtArrCdvHIG21);
    AffectBoolD( BoolRestrictif, PtArrCdvHIG20);

(* Variants anticipes *)
    AffectBoolD( BoolRestrictif, PtAntCdvFRA10);
    AffectBoolD( BoolRestrictif, PtAntSigFRA10);
    AffectBoolD( BoolRestrictif, PtAntCdvTOE23);

(* Copie des entrees dans des variables fonctionnelles pour la regulation *)
    CdvHIG12Fonc := FALSE;
    CdvRON12Fonc := FALSE;
    CdvRON22Fonc := FALSE;
    CdvHIG22Fonc := FALSE;

END InitSpecDivers;
(*  *)
(*----------------------------------------------------------------------------*)
PROCEDURE InitSpecConfMess;
(* -------------------------------------------------------------------------- *)
(*
 * Fonction :
 * Cette procedure configure les VoiesRetour, la voie d'emission SOL-Train et
 * Inter-secteur. Elle indique aussi le nombre de messages en inter-PCS.
 *
 * Condition d'appel : Appelee par InitSpecific a l'initialisation du logiciel
 *
 *)
(* ------------------------------------------------------------------------------------------------ *)

BEGIN
   
(* CONFIGURATION DES VOIES D'EMISSION **************************)

   ConfigEmisTeleSolTrain ( te11s13t01,
                            noBoucle1,         
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te14s13t02,
                            noBoucle2,         
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);
        
   ConfigEmisTeleSolTrain ( te21s13t03,
                            noBoucle3,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te24s13t04,
                            noBoucle4,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);
 

(* CONFIGURATION POUR LA REGULATION *)
   ConfigQuai (35, 64, CdvHIG12Fonc, te11s13t01, 0, 12,  2,  8,  9, 13, 14, 15);
   ConfigQuai (35, 69, CdvHIG22Fonc, te24s13t04, 0,  3,  4, 11, 10, 13, 14, 15);
   ConfigQuai (36, 74, CdvRON12Fonc, te14s13t02, 0, 12,  8,  3,  9, 13, 14, 15);
   ConfigQuai (36, 79, CdvRON22Fonc, te21s13t03, 0,  9, 11,  5, 10, 13, 14, 15);

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
(* ---------------------------------------------------------------------------- *)
BEGIN (* InSpecMessVar *)

(************** CONFIGURATION DES EMISSIONS DE VARIANTS SOL-TRAIN ************)

(* variants troncon 1   voie 1 --> si *)
   ProcEmisSolTrain( te11s13t01.EmissionSensUp, (2*noBoucle1), 
                     LigneL02+ L0213+ TRONC*01,     

              PtArrCdvHIG11,
              PtArrCdvHIG12,
              PtArrCdvHIG13,
              PtArrCdvHIG14,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
(* Variants Anticipes *)
              PtArrCdvRON11,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
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
   ProcEmisSolTrain( te14s13t02.EmissionSensUp, (2*noBoucle2), 
                     LigneL02+ L0213+ TRONC*02,     

              PtArrCdvRON11,
              PtArrCdvRON12,
              PtArrCdvRON13,
              PtAntCdvFRA10,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
	      (* Variants Anticipes *)
              PtAntSigFRA10,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
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

(*  *)
(* variants troncon 3    voie 2  <--- sp *)
   ProcEmisSolTrain( te21s13t03.EmissionSensUp, (2*noBoucle3), 
                     LigneL02+ L0213+ TRONC*03,

              PtArrCdvRON23,
              PtArrCdvRON22,
              PtArrCdvRON21,
              PtArrCdvRON20,
              BoolRestrictif, 
              BoolRestrictif, 
              BoolRestrictif, 
              BoolRestrictif,                     
(* Variants Anticipes *)
              PtArrCdvHIG23,
              BoolRestrictif, 
              BoolRestrictif, 
              BoolRestrictif, 
              BoolRestrictif,
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
   ProcEmisSolTrain( te24s13t04.EmissionSensUp, (2*noBoucle4), 
                     LigneL02+ L0213+ TRONC*04,     
  
              PtArrCdvHIG23,
              PtArrCdvHIG22,
              PtArrCdvHIG21,
              PtArrCdvHIG20,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
(* Variants Anticipes *)
              PtAntCdvTOE23,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
              BoolRestrictif,
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


(*  *)
(* reception du secteur 14 -aval- *)

   ProcReceptInterSecteur(trL0214, noBouclefra, LigneL02+ L0214+ TRONC*01,
                  PtAntCdvFRA10,
                  PtAntSigFRA10,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif, 
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


(* reception du secteur 12 -amont- *)

   ProcReceptInterSecteur(trL0212, noBoucleheb, LigneL02+ L0212+ TRONC*05,

                  PtAntCdvTOE23,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif, 
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


(* emission vers le secteur 14 -aval- *)

   ProcEmisInterSecteur (teL0214, noBouclefra, LigneL02+ L0213+ TRONC*03,
			noBouclefra,
                  PtArrCdvRON23,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif, 
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


(* emission vers le secteur 12 -amont- *)

   ProcEmisInterSecteur (teL0212, noBoucleheb, LigneL02+ L0213+ TRONC*01,
			noBoucleheb,
                  PtArrCdvHIG11,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif, 
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

(********* CONFIGURATION DES EMISSION DES INVARIANTS SECURITAIRES *********)

(* Tous les sens doivent etre a SensUp ; il n'y a pas de commutation *)
            

 (** Emission invariants vers secteur 14 aval L0214 **)

   EmettreSegm(LigneL02+ L0213+ TRONC*03+ SEGM*00, noBouclefra, SensUp);
   EmettreSegm(LigneL02+ L0213+ TRONC*03+ SEGM*01, noBouclefra, SensUp);

 (** Emission invariants vers secteur 12 amont L0212 **)

   EmettreSegm(LigneL02+ L0213+ TRONC*01+ SEGM*00, noBoucleheb, SensUp);
   EmettreSegm(LigneL02+ L0213+ TRONC*01+ SEGM*01, noBoucleheb, SensUp);



 (** Boucle 1 **) 
   EmettreSegm(LigneL02+ L0213+ TRONC*01+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL02+ L0213+ TRONC*01+ SEGM*01, noBoucle1, SensUp);
   EmettreSegm(LigneL02+ L0213+ TRONC*02+ SEGM*00, noBoucle1, SensUp);

 (** Boucle 2 **)        
   (* fc : retire le 30/7 EmettreSegm(LigneL02+ L0213+ TRONC*02+ SEGM*00, noBoucle2, SensUp); *)
   EmettreSegm(LigneL02+ L0213+ TRONC*02+ SEGM*01, noBoucle2, SensUp);
   EmettreSegm(LigneL02+ L0214+ TRONC*01+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL02+ L0214+ TRONC*01+ SEGM*01, noBoucle2, SensUp);

 (** Boucle 3 **)  
   EmettreSegm(LigneL02+ L0213+ TRONC*03+ SEGM*00, noBoucle3, SensUp);
   EmettreSegm(LigneL02+ L0213+ TRONC*03+ SEGM*01, noBoucle3, SensUp);
   EmettreSegm(LigneL02+ L0213+ TRONC*04+ SEGM*00, noBoucle3, SensUp);

 (** Boucle 4 **)  
   EmettreSegm(LigneL02+ L0213+ TRONC*04+ SEGM*00, noBoucle4, SensUp);
   EmettreSegm(LigneL02+ L0212+ TRONC*05+ SEGM*00, noBoucle4, SensUp);
   EmettreSegm(LigneL02+ L0212+ TRONC*05+ SEGM*01, noBoucle4, SensUp);


(*  *) 
(************************ CONFIGURATION DES TRONCONS TSR ****************************)

   ConfigurerTroncon(Tronc0, LigneL02 + L0213 + TRONC*01, 2,2,2,2);  (* troncon 13-1 *)
   ConfigurerTroncon(Tronc1, LigneL02 + L0213 + TRONC*02, 2,2,2,2);  (* troncon 13-2 *)
   ConfigurerTroncon(Tronc2, LigneL02 + L0213 + TRONC*03, 2,2,2,2);  (* troncon 13-3 *)
   ConfigurerTroncon(Tronc3, LigneL02 + L0213 + TRONC*04, 2,2,2,2);  (* troncon 13-4 *)


(*************************************** EMISSION DES TSR **************************************)



(** Emission des TSR vers le secteur aval 14 L0214 **)

   EmettreTronc(LigneL02+ L0213+ TRONC*03, noBouclefra, SensUp);


(** Emission des TSR vers le secteur amont 12 L0212 **)

   EmettreTronc(LigneL02+ L0213+ TRONC*01, noBoucleheb, SensUp);




 (** Emission des TSR sur les troncons du secteur courant **)

   EmettreTronc(LigneL02+ L0213+ TRONC*01, noBoucle1, SensUp); (* troncon 13-1 *)
   EmettreTronc(LigneL02+ L0213+ TRONC*02, noBoucle1, SensUp);


   EmettreTronc(LigneL02+ L0213+ TRONC*02, noBoucle2, SensUp); (* troncon 13-2 *)
   EmettreTronc(LigneL02+ L0214+ TRONC*01, noBoucle2, SensUp);


   EmettreTronc(LigneL02+ L0213+ TRONC*03, noBoucle3, SensUp); (* troncon 13-3 *)
   EmettreTronc(LigneL02+ L0213+ TRONC*04, noBoucle3, SensUp);


   EmettreTronc(LigneL02+ L0213+ TRONC*04, noBoucle4, SensUp); (* troncon 13-4 *)
   EmettreTronc(LigneL02+ L0212+ TRONC*05, noBoucle4, SensUp);



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
    StockAdres( ADR( CdvHIG11A));
    StockAdres( ADR( CdvHIG11B));
    StockAdres( ADR( CdvHIG12));
    StockAdres( ADR( CdvHIG13));
    StockAdres( ADR( CdvHIG14));
    StockAdres( ADR( CdvRON11));
    StockAdres( ADR( CdvRON12));
    StockAdres( ADR( CdvRON13));
    StockAdres( ADR( CdvRON23));
    StockAdres( ADR( CdvRON22));
    StockAdres( ADR( CdvRON21));
    StockAdres( ADR( CdvRON20));
    StockAdres( ADR( CdvHIG23));
    StockAdres( ADR( CdvHIG22));
    StockAdres( ADR( CdvHIG21B));
    StockAdres( ADR( CdvHIG21A));
    StockAdres( ADR( CdvHIG20));

    StockAdres( ADR( PtArrCdvHIG11));
    StockAdres( ADR( PtArrCdvHIG12));
    StockAdres( ADR( PtArrCdvHIG13));
    StockAdres( ADR( PtArrCdvHIG14));
    StockAdres( ADR( PtArrCdvRON11));
    StockAdres( ADR( PtArrCdvRON12));
    StockAdres( ADR( PtArrCdvRON13));
    StockAdres( ADR( PtArrCdvRON23));
    StockAdres( ADR( PtArrCdvRON22));
    StockAdres( ADR( PtArrCdvRON21));
    StockAdres( ADR( PtArrCdvRON20));
    StockAdres( ADR( PtArrCdvHIG23));
    StockAdres( ADR( PtArrCdvHIG22));
    StockAdres( ADR( PtArrCdvHIG21));
    StockAdres( ADR( PtArrCdvHIG20));

    StockAdres( ADR( PtAntCdvFRA10));
    StockAdres( ADR( PtAntSigFRA10));
    StockAdres( ADR( PtAntCdvTOE23));

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

(********** CONFIGURATION DES VARIABLES DU STANDARD NON UTILISEES ***********)
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
    CdvHIG12Fonc := CdvHIG12.F = Vrai.F;
    CdvRON12Fonc := CdvRON12.F = Vrai.F;
    CdvRON22Fonc := CdvRON22.F = Vrai.F;
    CdvHIG22Fonc := CdvHIG22.F = Vrai.F;



(******************************* FILTRAGE DES AIGUILLES*******************************)

(* pas d'aiguille *)

(************************** Gerer les point d'arrets **************************)

   EtDD(        CdvHIG11A,    CdvHIG11B,    PtArrCdvHIG11);
   AffectBoolD( CdvHIG12,                   PtArrCdvHIG12);
   AffectBoolD( CdvHIG13,                   PtArrCdvHIG13);
   AffectBoolD( CdvHIG14,                   PtArrCdvHIG14);
   AffectBoolD( CdvRON11,                   PtArrCdvRON11);
   AffectBoolD( CdvRON12,                   PtArrCdvRON12);
   AffectBoolD( CdvRON13,                   PtArrCdvRON13);
   AffectBoolD( CdvRON23,                   PtArrCdvRON23);
   AffectBoolD( CdvRON22,                   PtArrCdvRON22);
   AffectBoolD( CdvRON21,                   PtArrCdvRON21);
   AffectBoolD( CdvRON20,                   PtArrCdvRON20);
   AffectBoolD( CdvHIG23,                   PtArrCdvHIG23);
   AffectBoolD( CdvHIG22,                   PtArrCdvHIG22);
   EtDD(        CdvHIG21A,    CdvHIG21B,    PtArrCdvHIG21);
   AffectBoolD( CdvHIG20,                   PtArrCdvHIG20);


(*** lecture des entrees de regulation ***)

   LireEntreesRegul;

END ExeSpecific;
END Specific.
