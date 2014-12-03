IMPLEMENTATION MODULE Specific;

(*$S- *)
(*$T- *)

(*****************************************************************************)
(*   SANTIAGO - Ligne 5 - Secteur 41                                          *)
(*  =============================                                            *)
(*                                                                           *)
(* Version  1.0.0  =====================                                     *)
(* Version  1.1 DU SERVEUR SCCS =====================                        *)
(* Date :          23/09/2009                                                *)
(* Auteur :        M. Plywacz                                                *)
(* Modification :  Version initiale                                          *)
(*---------------------------------------------------------------------------*)
(* Version  1.0.1  =====================                                     *)
(* Version  1.2 DU SERVEUR SCCS =====================                        *)
(* Date :          01/12/2009                                                *)
(* Auteur :        M. Plywacz                                                *)
(* Modification : Modif variants anticipes troncon 41_4                      *)
(*                                                                           *)
(*                                                                           *)
(*---------------------------------------------------------------------------*)
(* Version  1.0.2  =====================                                     *)
(* Version  1.3 DU SERVEUR SCCS =====================                        *)
(* Date :          10/12/2009                                                *)
(* Auteur :        M. Plywacz                                                *)
(* Modification : Modif "No de Voie d'emissions" + "ConfigEmisTeleSolTrain"  *)
(*                                                                           *)
(*                                                                           *)
(*---------------------------------------------------------------------------*)
(* Version  1.0.3  =====================                                     *)
(* Version  1.4 DU SERVEUR SCCS =====================                        *)
(* Date :          24/02/2010                                                *)
(* Auteur :        M. Plywacz                                                *)
(* Modification : Mise en place des marches types                            *)
(*---------------------------------------------------------------------------*)
(* Version  1.0.4  =====================                                     *)
(* Version  1.5 DU SERVEUR SCCS =====================                        *)
(* Date :          29/07/2011                                                *)
(* Auteur :        I. ISSA                                                   *)
(* Modification : Modif configuration pour la régulation                     *)
(*---------------------------------------------------------------------------*)

(*****************************************************************************)


(******************************  IMPORTATIONS  ********************************)

FROM SYSTEM     IMPORT ADR;

FROM Opel       IMPORT StockAdres, AffectBoolD, AffectBoolC, BoolC, BoolD, BoolLD, EtDD, CodeD,
		       EtatD, Tvrai, FinBranche, FinArbre, AffectC, AffectEtatC, OuDD, NonD;

FROM ConstCode  IMPORT BoolPermissif, BoolRestrictif, Vrai, Faux ;

FROM BibAig     IMPORT TyAig, FiltrerAiguille,
		       EntreeAiguille;

FROM NouvRegul IMPORT  
(* procedures *)
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
		       ProcReceptInterSecteur;

FROM BibEnregDam  IMPORT
(* Types *)
		       TyBoucle,
(* variables *)
		       Boucle1, Boucle2, Boucle3,  Boucle4, Boucle5,Boucle6,
		       CarteCes1,  CarteCes2,  CarteCes3,  
		       Intersecteur1,

       Ampli11, Ampli12, Ampli13, Ampli14, Ampli15, Ampli16, Ampli17, Ampli18, Ampli19, Ampli1A,
	 Ampli21, Ampli22, Ampli23, Ampli24, Ampli25, Ampli26, Ampli27,
	 Ampli31, Ampli32, Ampli33, Ampli34, Ampli35, Ampli36, Ampli37,  
 	 Ampli41, Ampli42, Ampli43, Ampli44, Ampli45, Ampli46, Ampli47,  
       Ampli51, Ampli52, Ampli53, Ampli54, Ampli55, Ampli56, Ampli57,
       Ampli61, Ampli62, Ampli63, Ampli64, Ampli65, Ampli66, Ampli67,

   (* procedures *)
		       ConfigurerBoucle,
		       ConfigurerIntsecteur,
		       ConfigurerCES,
		       ConfigurerAmpli;

FROM BibTsr      IMPORT
   (* variables *)
		       Tronc0, Tronc1, Tronc2, Tronc3, Tronc4,
		       Tronc5, Tronc6, Tronc7, Tronc8, Tronc9, 
		       Tronc10, Tronc11, Tronc12, Tronc13, Tronc14, Tronc15,
   (* procedures *)
	               ConfigurerTroncon;

FROM ESbin       IMPORT
   (* procedures *)
		       ProcEntreeIntrins;

(*****************************  CONSTANTES  ***********************************)

CONST

(** No ligne, No secteur, ....**)

    LigneL05 = 16384*00; (* numero de ligne decale de 2**14 *)

    LigneL02 = 16384*00; (* numero de ligne decale de 2**14 *)

    L0508  = 1024*08; (* numero Secteur aval decale de 2**10 *)

    L0541  = 1024*41; (* numero Secteur local decale de 2**10 *)

    L0542  = 1024*42; (* numero Secteur amont decale de 2**10 *)


    TRONC  = 64; (* decalage de 2**6 pour numero de troncon *)

    SEGM   = 16; (* decalage de 2**4 pour numero de segment *)


(** Constantes de configuration des emissions en absence d'entrees de commutation **)
    VariantsContinus  = TRUE;
    CommutDifferee    = FALSE;

(** Indication  de positionnement d'aiguille **)
    PosNormale = TRUE;
    PosDeviee = FALSE;

(** indication de sens **)
    SensUp = TRUE;

(** No de Voie d'emissions SOL-Train, d'emission/reception inter-secteur **)
    noBoucleQUI = 00;
    noBouclePUD = 01;
    noBoucle1 = 03;
    noBoucle2 = 04;
    noBoucle3 = 05;
    
    noBoucle5 = 07;
    noBoucle6 = 08;
    noBoucle7 = 09;


(** Base pour les tables de compensation **)
    BaseEntVar  = 500   ;
    BaseSorVar  = 600   ;
    BaseExeAig  = 1280  ;
    BaseExeChainage = 1360 ;
    BaseExeSpecific = 1950 ;



(******************** DECLARATION DES VARIABLES GENERALES ********************)
 VAR

(* DECLARATION DES SINGULARITES DU SECTEUR 07 : dans les deux sens confondus *)

(* Declaration des variables correspondant a des entrees securitaires       *)
(*   - CDV et signaux                                                       *)

   CdvPRA11,      (* entree  1, soit entree 0 de CES 02  *)
   CdvPRA12,      (* entree  2, soit entree 1 de CES 02  *)
   CdvPRA13,      (* entree  3, soit entree 2 de CES 02  *)
   CdvPRA21,      (* entree  4, soit entree 3 de CES 02  *)
   CdvPRA22,      (* entree  5, soit entree 4 de CES 02  *)
   CdvPRA23,      (* entree  6, soit entree 5 de CES 02  *)
   CdvPRA24,      (* entree  7, soit entree 6 de CES 02  *)
   CdvBLA10,       (* entree  8, soit entree 7 de CES 02  *)

   CdvBLA11,       (* entree  9, soit entree 0 de CES 03  *)
   CdvBLA12,       (* entree 10, soit entree 1 de CES 03  *)
   CdvBLA13,       (* entree 11, soit entree 2 de CES 03  *)
   CdvBLA14,       (* entree 12, soit entree 3 de CES 03  *)
   CdvBLA21,       (* entree 13, soit entree 4 de CES 03  *)
   CdvBLA22,       (* entree 14, soit entree 5 de CES 03  *)
   CdvBLA23,       (* entree 15, soit entree 6 de CES 03  *)
   CdvBLA24,       (* entree 16, soit entree 7 de CES 03  *)

   CdvGRU10,       (* entree 17, soit entree 0 de CES 04  *)
   CdvGRU11,       (* entree 18, soit entree 1 de CES 04  *)
   CdvGRU12,       (* entree 19, soit entree 2 de CES 04  *)
   CdvGRU13,       (* entree 20, soit entree 3 de CES 04  *)
   CdvGRU20,       (* entree 21, soit entree 4 de CES 04  *)
   CdvGRU21,       (* entree 22, soit entree 5 de CES 04  *)
   CdvGRU22,       (* entree 23, soit entree 6 de CES 04  *)
   CdvGRU23        (* entree 24, soit entree 7 de CES 04  *)

             : BoolD;





(***********************************************************)
(* Variables ne correspondant pas a une entree securitaire *)
(* Points d'arret *)

    PtArrCdvPRA11,
    PtArrCdvPRA12,
    PtArrCdvPRA13,
    PtArrCdvPRA21,
    PtArrCdvPRA22,
    PtArrCdvPRA23,
    PtArrCdvPRA24,

    PtArrCdvBLA10,
    PtArrCdvBLA11,
    PtArrCdvBLA12,
    PtArrCdvBLA13,
    PtArrCdvBLA14,

    PtArrCdvBLA21,
    PtArrCdvBLA22,
    PtArrCdvBLA23,
    PtArrCdvBLA24,

    PtArrCdvGRU10,
    PtArrCdvGRU11,
    PtArrCdvGRU12,
    PtArrCdvGRU13,

    PtArrCdvGRU20,
    PtArrCdvGRU21,
    PtArrCdvGRU22,
    PtArrCdvGRU23            : BoolD;



 (* Variants anticipes *)

   PtAntCdvSPA24,
   PtAntCdvSPA22,
   PtAntSigSPA24,

    PtAntCdvQUI09,
    PtAntCdvQUI10,
    PtAntSigQUI10             : BoolD;


(***********************************************************)
(* Copie des entrees dans des variables fonctionnelles pour la regulation   *)
 
 CdvGRU12Fonc,
 CdvGRU22Fonc,
 CdvBLA12Fonc,
 CdvBLA22Fonc,
 CdvPRA12Fonc,
 CdvPRA22Fonc           : BOOLEAN;

(** Voie d'emission SOL-TRAIN : deux sens confondus**)

    te11s41t01,
    te24s41t02,
    te15s41t03,
    te31s41t04,
    te21s41t05,     
    te34s41t06  :TyEmissionTele;

(** Voie d'emission Inter-secteur deux voies confondues **)
    teL0508,
    teL0542        :TyEmissionTele;

(** Voie de reception Inter-secteur deux voies confondues **)
    trL0508,
    trL0542        :TyCaracEntSec;

  V1, V2, V3, V4, V5, V6   : BOOLEAN;



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


(********************** CONFIGURATIONS DIVERSES ******************************)

(* CONFIGURATION DES AIGUILLES, POUR LES DEUX VOIES *)



(* Configuration des entrees *)
   ProcEntreeIntrins ( 1,   CdvPRA11   );
   ProcEntreeIntrins ( 2,   CdvPRA12 );
   ProcEntreeIntrins ( 3,   CdvPRA13 );
   ProcEntreeIntrins ( 4,   CdvPRA21  );
   ProcEntreeIntrins ( 5,   CdvPRA22 );
   ProcEntreeIntrins ( 6,   CdvPRA23 );
   ProcEntreeIntrins ( 7,   CdvPRA24 );

   ProcEntreeIntrins ( 8,   CdvBLA10   );
   ProcEntreeIntrins ( 9,   CdvBLA11   );
   ProcEntreeIntrins (10,   CdvBLA12   );
   ProcEntreeIntrins (11,   CdvBLA13   );
   ProcEntreeIntrins (12,   CdvBLA14   );

   ProcEntreeIntrins (13,   CdvBLA21  );
   ProcEntreeIntrins (14,   CdvBLA22  );
   ProcEntreeIntrins (15,   CdvBLA23  );
   ProcEntreeIntrins (16,   CdvBLA24  );

   ProcEntreeIntrins (17,   CdvGRU10   );
   ProcEntreeIntrins (18,   CdvGRU11   );
   ProcEntreeIntrins (19,   CdvGRU12   );
   ProcEntreeIntrins (20,   CdvGRU13   );

   ProcEntreeIntrins (21,   CdvGRU20   );
   ProcEntreeIntrins (22,   CdvGRU21   );
   ProcEntreeIntrins (23,   CdvGRU22   );
   ProcEntreeIntrins (24,   CdvGRU23   );




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
ConfigurerAmpli(Ampli15, 1, 5, 158, 13, FALSE);
ConfigurerAmpli(Ampli16, 1, 6, 159, 13, FALSE);
ConfigurerAmpli(Ampli17, 1, 7, 192, 13, TRUE);
ConfigurerAmpli(Ampli18, 1, 8, 193, 14, FALSE);
ConfigurerAmpli(Ampli19, 1, 9, 194, 14, FALSE);
ConfigurerAmpli(Ampli1A, 1, 10, 195, 14, FALSE);

ConfigurerAmpli(Ampli31, 3, 1, 196, 15, FALSE);
ConfigurerAmpli(Ampli32, 3, 2, 197, 16, FALSE);
ConfigurerAmpli(Ampli33, 3, 3, 198, 16, FALSE);
ConfigurerAmpli(Ampli34, 3, 4, 199, 16, TRUE);
ConfigurerAmpli(Ampli35, 3, 5, 200, 17, FALSE);
ConfigurerAmpli(Ampli36, 3, 6, 201, 17, FALSE);
ConfigurerAmpli(Ampli37, 3, 7, 202, 17, TRUE);

ConfigurerAmpli(Ampli51, 5, 1, 206, 21, FALSE);
ConfigurerAmpli(Ampli52, 5, 2, 207, 22, FALSE);
ConfigurerAmpli(Ampli53, 5, 3, 208, 22, FALSE);
ConfigurerAmpli(Ampli54, 5, 4, 209, 22, TRUE);
ConfigurerAmpli(Ampli55, 5, 5, 210, 23, FALSE);
ConfigurerAmpli(Ampli56, 5, 6, 211, 23, FALSE);
ConfigurerAmpli(Ampli57, 5, 7, 212, 23, TRUE);

ConfigurerAmpli(Ampli21, 2, 1, 213, 24, FALSE);
ConfigurerAmpli(Ampli22, 2, 2, 214, 25, FALSE);
ConfigurerAmpli(Ampli23, 2, 3, 215, 25, FALSE);
ConfigurerAmpli(Ampli24, 2, 4, 216, 25, TRUE);
ConfigurerAmpli(Ampli25, 2, 5, 217, 26, FALSE);
ConfigurerAmpli(Ampli26, 2, 6, 218, 26, FALSE);
ConfigurerAmpli(Ampli27, 2, 7, 219, 26, TRUE);

ConfigurerAmpli(Ampli41, 4, 1, 258, 31, FALSE);
ConfigurerAmpli(Ampli42, 4, 2, 259, 32, FALSE);
ConfigurerAmpli(Ampli43, 4, 3, 260, 32, FALSE);
ConfigurerAmpli(Ampli44, 4, 4, 261, 32, TRUE);
ConfigurerAmpli(Ampli45, 4, 5, 262, 33, FALSE);
ConfigurerAmpli(Ampli46, 4, 6, 263, 33, FALSE);
ConfigurerAmpli(Ampli47, 4, 7, 264, 33, TRUE);

ConfigurerAmpli(Ampli61, 6, 1, 265, 34, FALSE);
ConfigurerAmpli(Ampli62, 6, 2, 266, 35, FALSE);
ConfigurerAmpli(Ampli63, 6, 3, 267, 35, FALSE);
ConfigurerAmpli(Ampli64, 6, 4, 268, 35, TRUE);
ConfigurerAmpli(Ampli65, 6, 5, 269, 36, FALSE);
ConfigurerAmpli(Ampli66, 6, 6, 270, 36, FALSE);
ConfigurerAmpli(Ampli67, 6, 7, 271, 36, TRUE);



 
(** cartes CES **)
   ConfigurerCES(CarteCes1, 01);
   ConfigurerCES(CarteCes2, 02);
   ConfigurerCES(CarteCes3, 03);


(** Liaisons Inter-Secteur **)

   ConfigurerIntsecteur(Intersecteur1, 01, trL0508, trL0542);


(* Initialisations des variables ne correspondant pas a des entrees secu *)

(* Affectation a l'etat restrictif des variants commutes *)


(* Point d'arret *)
   AffectBoolD( BoolRestrictif, PtArrCdvPRA11   );
   AffectBoolD( BoolRestrictif, PtArrCdvPRA12   );
   AffectBoolD( BoolRestrictif, PtArrCdvPRA13   );
   AffectBoolD( BoolRestrictif, PtArrCdvPRA21   );
   AffectBoolD( BoolRestrictif, PtArrCdvPRA22   );
   AffectBoolD( BoolRestrictif, PtArrCdvPRA23   );
   AffectBoolD( BoolRestrictif, PtArrCdvPRA24   );

   AffectBoolD( BoolRestrictif, PtArrCdvBLA10   );
   AffectBoolD( BoolRestrictif, PtArrCdvBLA11   );
   AffectBoolD( BoolRestrictif, PtArrCdvBLA12   );
   AffectBoolD( BoolRestrictif, PtArrCdvBLA13   );
   AffectBoolD( BoolRestrictif, PtArrCdvBLA14   );
   AffectBoolD( BoolRestrictif, PtArrCdvBLA21   );
   AffectBoolD( BoolRestrictif, PtArrCdvBLA22   );
   AffectBoolD( BoolRestrictif, PtArrCdvBLA23   );
   AffectBoolD( BoolRestrictif, PtArrCdvBLA24   );

   AffectBoolD( BoolRestrictif, PtArrCdvGRU10   );
   AffectBoolD( BoolRestrictif, PtArrCdvGRU11   );
   AffectBoolD( BoolRestrictif, PtArrCdvGRU12   );
   AffectBoolD( BoolRestrictif, PtArrCdvGRU13   );
   AffectBoolD( BoolRestrictif, PtArrCdvGRU20   );
   AffectBoolD( BoolRestrictif, PtArrCdvGRU21   );
   AffectBoolD( BoolRestrictif, PtArrCdvGRU22   );
   AffectBoolD( BoolRestrictif, PtArrCdvGRU23   );



(* Variants anticipes *)

   AffectBoolD( BoolRestrictif, PtAntCdvSPA24   );
   AffectBoolD( BoolRestrictif, PtAntCdvSPA22   );
   AffectBoolD( BoolRestrictif, PtAntSigSPA24   );

   AffectBoolD( BoolRestrictif, PtAntCdvQUI09   );
   AffectBoolD( BoolRestrictif, PtAntCdvQUI10   );
   AffectBoolD( BoolRestrictif, PtAntSigQUI10   );


(* Regulation *)
 CdvGRU12Fonc := FALSE;
 CdvGRU22Fonc := FALSE;

 CdvBLA12Fonc := FALSE;
 CdvBLA22Fonc := FALSE;

 CdvPRA12Fonc := FALSE;
 CdvPRA22Fonc := FALSE;

END InitSpecDivers;



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

   ConfigEmisTeleSolTrain ( te11s41t01,
			    noBoucle1,
			    BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te24s41t02,
			    noBoucle5,
			    BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te15s41t03,
			    noBoucle2,
			    BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te31s41t04,
			    noBoucle6,
			    BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te21s41t05,
			    noBoucle3,
			    BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te34s41t06,
			    noBoucle7,
			    BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);


(* CONFIGURATION POUR LA REGULATION *)

   ConfigQuai(70, 74, CdvGRU12Fonc, te21s41t05, 0,  2, 3, 9, 4,  13,14,15);

   ConfigQuai(71, 64, CdvBLA12Fonc, te15s41t03, 0,  2, 3, 4,11,  13,14,15);

   ConfigQuai(72, 84, CdvPRA12Fonc, te11s41t01, 0,  3, 9,11, 5,  13,14,15);

   ConfigQuai(70, 79, CdvGRU22Fonc, te24s41t02, 0,  2, 3, 4,11,  13,14,15);

   ConfigQuai(71, 69, CdvBLA22Fonc, te31s41t04, 0,  8, 9,11, 5,  13,14,15);

   ConfigQuai(72, 89, CdvPRA22Fonc, te34s41t06, 8,  4, 5,10, 6,  13,14,15);


END InitSpecConfMess;


(*----------------------------------------------------------------------------*)
PROCEDURE InSpecMessVar ;
(*----------------------------------------------------------------------------*)
(*
 * Fonction :
 * Cette procedure definit les messages de variants emis vers le TRAIN et
 * ceux emis et recus sur les liaisons Inter-secteurs.
 *
 * Condition d'appel : Appelee par InitSpecific a l'initialisation du logiciel
 *
 *)
(*----------------------------------------------------------------------------*)
BEGIN (* InSpecMessVar *)

(* CONFIGURATION DES EMISSIONS DE VARIANTS SOL-TRAIN VERS la VOIE *************)

(* variants troncon 1 *)

   ProcEmisSolTrain( te11s41t01.EmissionSensUp, (2*noBoucle1),
		     LigneL05+ L0541+ TRONC*01,

 		  PtArrCdvPRA12,
 		  PtArrCdvPRA13,
 		  PtArrCdvBLA10,
 		  PtArrCdvBLA11,
 		  BoolRestrictif,
 		  BoolRestrictif,
 		  BoolRestrictif,
 		  BoolRestrictif,
(* Variants Anticipes *)

 		  PtArrCdvBLA12,
 		  PtArrCdvBLA13, 
 		  BoolRestrictif,
 		  BoolRestrictif,
 		  BoolRestrictif,
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



(* variants troncon 2 *)

   ProcEmisSolTrain( te24s41t02.EmissionSensUp, (2*noBoucle5),
		     LigneL05+ L0541+ TRONC*02,

		  PtArrCdvGRU22,
		  PtArrCdvGRU21,
		  PtArrCdvGRU20,
		  PtArrCdvBLA24,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,		  
		  BoolRestrictif,
(* Variants Anticipes *)
		  PtArrCdvBLA23,
		  PtArrCdvBLA22, 
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
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


(* variants troncon 3 *)

   ProcEmisSolTrain( te15s41t03.EmissionSensUp, (2*noBoucle2),
		     LigneL05+ L0541+ TRONC*03,

		  PtArrCdvBLA12,
		  PtArrCdvBLA13,
		  PtArrCdvBLA14,
		  PtArrCdvGRU10,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,

(* Variants Anticipes *)

		  PtArrCdvGRU11,
		  PtArrCdvGRU12,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
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


(* variants troncon 4 *)

   ProcEmisSolTrain( te31s41t04.EmissionSensUp, (2*noBoucle6),
		     LigneL05+ L0541+ TRONC*04,

  PtArrCdvBLA23,
  PtArrCdvBLA22,
  PtArrCdvBLA21,
  PtArrCdvPRA24,
  BoolRestrictif,
  BoolRestrictif,
  BoolRestrictif,
  BoolRestrictif,
(* Variants Anticipes *)
  PtArrCdvPRA23,
  PtArrCdvPRA22,
  BoolRestrictif,
  BoolRestrictif,
  BoolRestrictif,
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


(* variants troncon 5 *)

   ProcEmisSolTrain( te21s41t05.EmissionSensUp, (2*noBoucle3),
		     LigneL05+ L0541+ TRONC*05,

		  PtArrCdvGRU11,
		  PtArrCdvGRU12,  (* AspectCroix *)
		  PtArrCdvGRU13,
		  PtAntCdvQUI09,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
(* Variants Anticipes *)
		  PtAntCdvQUI10,
		  PtAntSigQUI10, 
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,		  
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


(* variants troncon 6 *)

   ProcEmisSolTrain( te34s41t06.EmissionSensUp, (2*noBoucle7),
		     LigneL05+ L0541+ TRONC*06,

		  PtArrCdvPRA23,
		  PtArrCdvPRA22,  
		  PtArrCdvPRA21,
		  PtAntCdvSPA24,
		  BoolRestrictif, 
		  BoolRestrictif, 
		  BoolRestrictif,
		  BoolRestrictif,
(* Variants Anticipes *)
		  PtAntSigSPA24, 
		  BoolRestrictif, 
		  PtAntCdvSPA22,
		  BoolRestrictif,
		  BoolRestrictif,		  
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



(* reception du secteur 8 aval *)
   ProcReceptInterSecteur(trL0508, noBoucleQUI, LigneL05+ L0508+ TRONC*02,

		  PtAntCdvQUI09,
		  PtAntCdvQUI10,
		  PtAntSigQUI10,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
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

(* reception du secteur 42 amont *)
   ProcReceptInterSecteur(trL0542, noBouclePUD, LigneL05+ L0542+ TRONC*02,

		  PtAntCdvSPA24,
		  PtAntCdvSPA22,
		  PtAntSigSPA24,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
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



(* emission vers le secteur 8 aval *)
   ProcEmisInterSecteur (teL0508, noBoucleQUI, LigneL05+ L0541+ TRONC*01,
			noBoucleQUI,
		  PtArrCdvGRU23,
		  PtArrCdvGRU22,
		  PtArrCdvGRU21,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
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

(* emission vers le secteur 42 amont *)
   ProcEmisInterSecteur (teL0542, noBouclePUD, LigneL05+ L0541+ TRONC*02,
		  noBouclePUD,
		  PtArrCdvPRA11,
		  PtArrCdvPRA12,
		  PtArrCdvPRA13,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
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

(* CONFIGURATION DES EMISSION DES INVARIANTS SECURITAIRES VOIE UP *************)

(* Tous les sens doivent etre a SensUp ; il n'y a pas de commutation *)

 (** Emission invariants vers secteur aval L0508 **)
   EmettreSegm(LigneL05+ L0541+ TRONC*02+ SEGM*00, noBoucleQUI, SensUp);
   EmettreSegm(LigneL05+ L0541+ TRONC*04+ SEGM*00, noBoucleQUI, SensUp);

 (** Emission invariants vers secteur amont L0542 **)
   EmettreSegm(LigneL05+ L0541+ TRONC*01+ SEGM*00, noBouclePUD, SensUp);
   EmettreSegm(LigneL05+ L0541+ TRONC*03+ SEGM*00, noBouclePUD, SensUp);



 (** Boucle 1 **)
   EmettreSegm(LigneL05+ L0541+ TRONC*01+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL05+ L0541+ TRONC*03+ SEGM*00, noBoucle1, SensUp);

 (** Boucle 5 **)
   EmettreSegm(LigneL05+ L0541+ TRONC*02+ SEGM*00, noBoucle5, SensUp);
   EmettreSegm(LigneL05+ L0541+ TRONC*04+ SEGM*00, noBoucle5, SensUp);

 (** Boucle 2 **)
   EmettreSegm(LigneL05+ L0541+ TRONC*03+ SEGM*00, noBoucle2, SensUp);  
   EmettreSegm(LigneL05+ L0541+ TRONC*05+ SEGM*00, noBoucle2, SensUp);  

 (** Boucle 6 **)
   EmettreSegm(LigneL05+ L0541+ TRONC*04+ SEGM*00, noBoucle6, SensUp); 
   EmettreSegm(LigneL05+ L0541+ TRONC*06+ SEGM*00, noBoucle6, SensUp);

 (** Boucle 3 **)
   EmettreSegm(LigneL05+ L0541+ TRONC*05+ SEGM*00, noBoucle3, SensUp); 
   EmettreSegm(LigneL05+ L0508+ TRONC*01+ SEGM*00, noBoucle3, SensUp); 
   EmettreSegm(LigneL05+ L0508+ TRONC*01+ SEGM*01, noBoucle3, SensUp); 

 (** Boucle 7 **)
   EmettreSegm(LigneL05+ L0541+ TRONC*06+ SEGM*00, noBoucle7, SensUp); 
   EmettreSegm(LigneL05+ L0542+ TRONC*02+ SEGM*00, noBoucle7, SensUp); 
   EmettreSegm(LigneL05+ L0542+ TRONC*02+ SEGM*01, noBoucle7, SensUp); 


(* CONFIGURATION DES TRONCONS TSR *********************************)

   ConfigurerTroncon(Tronc0, LigneL05 + L0541 + TRONC*01, 1,1,1,1);  (* troncon 8-1 *)
   ConfigurerTroncon(Tronc1, LigneL05 + L0541 + TRONC*02, 1,1,1,1);  (* troncon 8-2 *)
   ConfigurerTroncon(Tronc2, LigneL05 + L0541 + TRONC*03, 1,1,1,1);  (* troncon 8-3 *)
   ConfigurerTroncon(Tronc3, LigneL05 + L0541 + TRONC*04, 1,1,1,1);  (* troncon 8-4 *)
   ConfigurerTroncon(Tronc4, LigneL05 + L0541 + TRONC*05, 1,1,1,1);  (* troncon 8-5 *)
   ConfigurerTroncon(Tronc5, LigneL05 + L0541 + TRONC*06, 1,1,1,1);  (* troncon 8-6 *)

(* EMISSION DES TSR SUR VOIE 1 ***********************************************)

 (** Emission des TSR vers le secteur aval L0507 **)
   EmettreTronc(LigneL05+ L0541+ TRONC*02, noBoucleQUI, SensUp);

 (** Emission des TSR vers le secteur amont L0542 **)
   EmettreTronc(LigneL05+ L0541+ TRONC*01, noBouclePUD, SensUp);

 (** Emission des TSR sur les troncons du secteur courant **)
   EmettreTronc(LigneL05+ L0541+ TRONC*01, noBoucle1, SensUp); (* troncon 41-1 *)
   EmettreTronc(LigneL05+ L0541+ TRONC*03, noBoucle1, SensUp);

   EmettreTronc(LigneL05+ L0541+ TRONC*02, noBoucle5, SensUp); (* troncon 41-2 *)
   EmettreTronc(LigneL05+ L0541+ TRONC*04, noBoucle5, SensUp);

   EmettreTronc(LigneL05+ L0541+ TRONC*03, noBoucle2, SensUp); (* troncon 41-3 *)
   EmettreTronc(LigneL05+ L0541+ TRONC*05, noBoucle2, SensUp);

   EmettreTronc(LigneL05+ L0541+ TRONC*04, noBoucle6, SensUp); (* troncon 41-4 *)
   EmettreTronc(LigneL05+ L0541+ TRONC*06, noBoucle6, SensUp);

   EmettreTronc(LigneL05+ L0541+ TRONC*05, noBoucle3, SensUp); (* troncon 41-5 *)
   EmettreTronc(LigneL05+ L0508+ TRONC*01, noBoucle3, SensUp);

   EmettreTronc(LigneL05+ L0541+ TRONC*06, noBoucle7, SensUp); (* troncon 41-6 *)
   EmettreTronc(LigneL05+ L0542+ TRONC*02, noBoucle7, SensUp);


END InSpecMessInv ;

(* Saut de page *)
(*----------------------------------------------------------------------------*)
PROCEDURE StockerAdresse;
(*----------------------------------------------------------------------------*)
(*
 * Fonction :
 *      Cette procedure stocke l'adresse de toutes les variables securitaires.
 *
 * Condition d'appel : Appelee par InitSpecific a l'initialisation du logiciel
 *
 *)
(*----------------------------------------------------------------------------*)
BEGIN (* StockerAdresse *)

(* VARIABLES *)

   StockAdres( ADR(CdvPRA11 ));
   StockAdres( ADR(CdvPRA12 ));
   StockAdres( ADR(CdvPRA13 ));
   StockAdres( ADR(CdvPRA21 ));
   StockAdres( ADR(CdvPRA22 ));
   StockAdres( ADR(CdvPRA23 ));
   StockAdres( ADR(CdvPRA24 ));
   StockAdres( ADR(CdvBLA10 ));

   StockAdres( ADR(CdvBLA11 ));
   StockAdres( ADR(CdvBLA12 ));

   StockAdres( ADR(CdvBLA13 ));
   StockAdres( ADR(CdvBLA14 ));
   StockAdres( ADR(CdvBLA21 ));
   StockAdres( ADR(CdvBLA22 ));

   StockAdres( ADR(CdvBLA23 ));
   StockAdres( ADR(CdvBLA24 ));

   StockAdres( ADR(CdvGRU10 ));
   StockAdres( ADR(CdvGRU11 ));
   StockAdres( ADR(CdvGRU12 ));
   StockAdres( ADR(CdvGRU13 ));
   StockAdres( ADR(CdvGRU20 ));
   StockAdres( ADR(CdvGRU21 ));
   StockAdres( ADR(CdvGRU22 ));

   StockAdres( ADR(CdvGRU23 ));


(* coucou *)

(* Points d'arret *)
   StockAdres( ADR( PtArrCdvPRA11   ));
   StockAdres( ADR( PtArrCdvPRA12   ));
   StockAdres( ADR( PtArrCdvPRA13  ));
   StockAdres( ADR( PtArrCdvPRA21   ));
   StockAdres( ADR( PtArrCdvPRA22   ));
   StockAdres( ADR( PtArrCdvPRA23   ));
   StockAdres( ADR( PtArrCdvPRA24   ));

   StockAdres( ADR( PtArrCdvBLA10   ));
   StockAdres( ADR( PtArrCdvBLA11   ));
   StockAdres( ADR( PtArrCdvBLA12   ));
   StockAdres( ADR( PtArrCdvBLA13   ));
   StockAdres( ADR( PtArrCdvBLA14   ));

   StockAdres( ADR( PtArrCdvBLA21   ));
   StockAdres( ADR( PtArrCdvBLA22   ));
   StockAdres( ADR( PtArrCdvBLA23   ));
   StockAdres( ADR( PtArrCdvBLA24   ));

   StockAdres( ADR( PtArrCdvGRU10   ));
   StockAdres( ADR( PtArrCdvGRU11   ));
   StockAdres( ADR( PtArrCdvGRU12   ));
   StockAdres( ADR( PtArrCdvGRU13   ));
   StockAdres( ADR( PtArrCdvGRU20   ));
   StockAdres( ADR( PtArrCdvGRU21   ));
   StockAdres( ADR( PtArrCdvGRU22   ));
   StockAdres( ADR( PtArrCdvGRU23   ));


(* coucou *)
   StockAdres( ADR( PtAntCdvSPA24   ));
   StockAdres( ADR( PtAntCdvSPA22   ));
   StockAdres( ADR( PtAntSigSPA24   ));

   StockAdres( ADR( PtAntCdvQUI09   ));
   StockAdres( ADR( PtAntCdvQUI10   ));
   StockAdres( ADR( PtAntSigQUI10   ));


END StockerAdresse ;

(* Saut de page *)
(*----------------------------------------------------------------------------*)
PROCEDURE InitInutil ;
(*----------------------------------------------------------------------------*)
(*
 * Fonction :
 *      Cette procedure permet l'initialisation des variables de troncons et
 *      d'interstations du standard qui ne font pas partie de la configuration
 *      reelle du secteur.
 *
 * Condition d'appel : Appelee par InitSpecific a l'initialisation du logiciel
 *
 *)
(*----------------------------------------------------------------------------*)
BEGIN (* InitInutil *)

(* Configuration des troncons TSR inutilisees *)

	ConfigurerTroncon(Tronc6, 0, 0,0,0,0) ;
	ConfigurerTroncon(Tronc7, 0, 0,0,0,0) ;
	ConfigurerTroncon(Tronc8, 0, 0,0,0,0) ;
	ConfigurerTroncon(Tronc9, 0, 0,0,0,0) ;
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

(**** CONFIGURATION DES VOIES RETOUR ET VOIES D'EMISSION ****)
   InitSpecConfMess;

(**** CONFIGURATION DES MESSAGES DE VARIANTS SOL-TRAIN ET INTERSECTEUR ****)
   InSpecMessVar;

(**** CONFIGURATION DES MESSAGES D'INVARIANTS SOL-TRAIN ET INTERSECTEUR ***)
   InSpecMessInv;

(****   CONFIGURATION DES VARIABLES DU STANDARD NON UTILISEES *************)
   InitInutil;

(****   Stockage des adresses *****)
   StockerAdresse ;

END InitSpecific;

(* Saut de page *)
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
VAR BoolTr : BoolLD;

BEGIN (* ExeSpecific *)

(* Affectation des "constantes" utilisees dans la construction des messages emis        *)
(* et recus sur les boucles de transmission continue et sur les liens intersecteur.     *)
(* Cette reaffectation est necessaire a chaque cycle pour la mise en securite.          *)
   AffectBoolC(Vrai, BoolPermissif)  ;
   AffectBoolC(Faux, BoolRestrictif) ;

 (* regulation *)
 CdvGRU12Fonc := CdvGRU12.F = Vrai.F;
 CdvGRU22Fonc := CdvGRU22.F = Vrai.F;

 CdvBLA12Fonc := CdvBLA12.F = Vrai.F;
 CdvBLA22Fonc := CdvBLA22.F = Vrai.F;

 CdvPRA12Fonc := CdvPRA12.F = Vrai.F;
 CdvPRA22Fonc := CdvPRA22.F = Vrai.F;




(**** FILTRAGE DES AIGUILLES **************************************************)



(**** DETERMINATION DES POINTS D'ARRET ****************************************)

   AffectBoolD( CdvPRA11,    PtArrCdvPRA11 );
   AffectBoolD( CdvPRA12,    PtArrCdvPRA12 );
   AffectBoolD( CdvPRA13,    PtArrCdvPRA13 );

   AffectBoolD( CdvPRA21,    PtArrCdvPRA21  );
   AffectBoolD( CdvPRA22,    PtArrCdvPRA22  );
   AffectBoolD( CdvPRA23,    PtArrCdvPRA23  );
   AffectBoolD( CdvPRA24,    PtArrCdvPRA24  );
  

   AffectBoolD( CdvBLA10,    PtArrCdvBLA10  );
   AffectBoolD( CdvBLA11,    PtArrCdvBLA11  );
   AffectBoolD( CdvBLA12,    PtArrCdvBLA12  );
   AffectBoolD( CdvBLA13,    PtArrCdvBLA13  );
   AffectBoolD( CdvBLA14,    PtArrCdvBLA14  );

   AffectBoolD( CdvBLA21,    PtArrCdvBLA21  );
   AffectBoolD( CdvBLA22,    PtArrCdvBLA22  );
   AffectBoolD( CdvBLA23,    PtArrCdvBLA23  );
   AffectBoolD( CdvBLA24,    PtArrCdvBLA24  );

   AffectBoolD( CdvGRU10,    PtArrCdvGRU10  );
   AffectBoolD( CdvGRU11,    PtArrCdvGRU11  );
   AffectBoolD( CdvGRU12,    PtArrCdvGRU12  );
   AffectBoolD( CdvGRU13,    PtArrCdvGRU13  );

   AffectBoolD( CdvGRU20,    PtArrCdvGRU20  );
   AffectBoolD( CdvGRU21,    PtArrCdvGRU21  );
   AffectBoolD( CdvGRU22,    PtArrCdvGRU22  );
   AffectBoolD( CdvGRU23,    PtArrCdvGRU23  );


(*** lecture des entrees de regulation ***)
   LireEntreesRegul;


END ExeSpecific;
END Specific.

















