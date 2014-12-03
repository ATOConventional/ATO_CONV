IMPLEMENTATION MODULE Specific;

(*$S- *)
(*$T- *)

(*****************************************************************************)
(*   SANTIAGO - Ligne 5 - Secteur 8                                          *)
(*  =============================                                            *)
(*                                                                           *)
(* Version  1.0.0  =====================                                     *)
(* Version  1.1 DU SERVEUR SCCS =====================                        *)
(* Date :          30/10/2002                                                *)
(* Auteur :        M. Plywacz                                                *)
(* Modification :  Version initiale                                          *)
(*---------------------------------------------------------------------------*)
(* Version  1.0.1  =====================                                     *)
(* Version  1.2 DU SERVEUR SCCS =====================                        *)
(* Date :          13/02/2004                                                *)
(* Auteur :        M. Plywacz                                                *)
(* Modification : Emission des TSR et Invariants 8_5_0   pour retournement   *)
(*                sur troncon 8-1                                            *)
(*                                                                           *)
(*---------------------------------------------------------------------------*)
(*                                                                           *)
(* Version  1.0.2  =====================                                     *)
(* Version  1.3 DU SERVEUR SCCS =====================                        *)
(* Date :          16/02/2004                                                *)
(* Auteur :        M. Plywacz                                                *)
(* Modification : Inversion Entrees Aiguilles AigQUI13_23, 11,12             *)
(*                Inversion Entrees Aiguilles AigQUI11_21, 10, 9             *)
(*                                                                           *)
(*---------------------------------------------------------------------------*)
(*                                                                           *)
(* Version  1.0.3  =====================                                     *)
(* Version  1.4 DU SERVEUR SCCS =====================                        *)
(* Date :          03/03/2004                                                *)
(* Auteur :        M. Plywacz                                                *)
(* Modification : variants ant tr 8.3 commutes par AigQUI11_21               *)
(*                                                                           *)
(*---------------------------------------------------------------------------*)
(*                                                                           *)
(* Version  1.0.4  =====================                                     *)
(* Version  1.5 DU SERVEUR SCCS =====================                        *)
(* Date :          11/03/2004                                                *)
(* Auteur :        M. Plywacz                                                *)
(* Modification : Ajustement marches types                                   *)
(*                                                                           *)
(*---------------------------------------------------------------------------*)
(*                                                                           *)
(* Version  1.0.5  =====================                                     *)
(* Version  1.6 DU SERVEUR SCCS =====================                        *)
(* Date :          16/03/2004                                                *)
(* Auteur :        M. Plywacz                                                *)
(* Modification : Arret Sig23 : PtArrSigQUI23 devient PtArrSpeQUI23          *)
(*                                                                           *)
(*---------------------------------------------------------------------------*)
(*                                                                           *)
(* Version  1.0.6  =====================                                     *)
(* Version  1.7 DU SERVEUR SCCS =====================                        *)
(* Date :          09/04/2004                                                *)
(* Auteur :        M. Plywacz                                                *)
(* Modification : troncon 8.1 : PtArrCdvQUI20 : = supprime                   *)
(*                                                                           *)
(*---------------------------------------------------------------------------*)
(*                                                                           *)
(* Version  1.0.7  =====================                                     *)
(* Version  1.8 DU SERVEUR SCCS =====================                        *)
(* Date :          23/04/2004                                                *)
(* Auteur :        M. Plywacz                                                *)
(* Modification : Ajustement marches types                                   *)
(*                                                                           *)
(*---------------------------------------------------------------------------*)
(*                                                                           *)
(* Version  1.0.8  =====================                                     *)
(* Version  1.9 DU SERVEUR SCCS =====================                        *)
(* Date :          04/05/2004                                                *)
(* Auteur :        M. Plywacz                                                *)
(* Modification : Ajustement marches types                                   *)
(*                                                                           *)
(*---------------------------------------------------------------------------*)
(*                                                                           *)
(* Version  1.0.9  =====================                                     *)
(* Version  1.10 DU SERVEUR SCCS =====================                       *)
(* Date :          26/05/2004                                                *)
(* Auteur :        M. Plywacz                                                *)
(* Modification : Ajustement de la marche type  RC->QN voie 2                *)
(*     Anciennes valeurs  0,  3,11,10, 6                                     *)
(*     Nouvelles valeurs  0,  3,11,10, 7                                     *)
(*                                                                           *)
(*****************************************************************************)
(*                                                                           *)
(* Version  1.1.0  =====================                                     *)
(* Version  1.11 DU SERVEUR SCCS =====================                       *)
(* Date :          17/07/2007                                                *)
(* Auteur :        P.Amsellem                                                *)
(* Modification : tronçon 3 ajout d'un nouveau point d'arret , rouge fixe    *)
(* tronçon 5 suppression de tout ce qui est au delà du joint 23A/22B         *)
(* signal 22B remplaçer par rouge fixe                                       *)
(* emission sur le tronçon 4 en commentaires                                 *)
(* configuration des amplis cdv 12, 13, 14, 24, 23B et 23A en commentaires   *)
(*****************************************************************************)
(*---------------------------------------------------------------------------*)
(*                                                                           *)
(* Version  1.1.1  =====================                                     *)
(* Version  1.12 DU SERVEUR SCCS =====================                       *)
(* Date   : 11/08/2009                                                       *)
(* Auteur :        M. Plywacz                                                *)
(* Modification : prolongement 4 de la ligne 5                               *)
(*     Ajout raccordement au nouveau secteur 41 + nouveaux itineraires       *)
(*                                                                           *)
(*---------------------------------------------------------------------------*)
(* Version  1.1.2  =====================                                     *)
(* Version  1.13 DU SERVEUR SCCS =====================                       *)
(* Date   : 09/09/2009                                                       *)
(* Auteur :        M. Plywacz                                                *)
(* Modification : prolongement 4 de la ligne 5                               *)
(* Segment 8.1.1 : TIVCOM à 25 km/h au pk -671 supprimé                      *)
(* Segment 8.1.1 : ArretSimple S11  au pk -671   devient ARRETSPECIFIC       *)
(* Segment 8.4.0 : ARRETSUB  cdv22  au pk -519.5 devient ARRETSPECIFIC       *)
(* Troncon 8.1.  : ajout LTV du 8.6*)
(*                                                                           *)
(*---------------------------------------------------------------------------*)
(* Version  1.1.3  =====================                                     *)
(* Version  1.14 DU SERVEUR SCCS =====================                       *)
(* Date   : 04/10/2009                                                       *)
(* Auteur :        M. Plywacz                                                *)
(* Modification : prolongement 4 de la ligne 5                               *)
(* AMs validation                                                            *)
(* AM74  Aiguille commut var = AigQUI13_23                                   *)
(* AM76  Rajout trans LTV anticipees (41.2) dans troncon 8.4                 *)
(*                                                                           *)
(*---------------------------------------------------------------------------*)
(* Version  1.1.4  =====================                                     *)
(* Version  1.15 DU SERVEUR SCCS =====================                       *)
(* Date   : 18/12/2009                                                       *)
(* Auteur :        Ph. Hog                                                   *)
(* Modification : prolongement 4 de la ligne 5                               *)
(* Le point d'arrêt PA_CDV22 passe segment 8.4.0 au segment 8.3.1            *)
(*---------------------------------------------------------------------------*)
(* Version  1.1.5  =====================                                     *)
(* Version  1.16 DU SERVEUR SCCS =====================                       *)
(* Date   : 13/01/2010                                                       *)
(* Auteur :        Ph. Hog                                                   *)
(* Modification : prolongement 4 de la ligne 5                               *)
(* Correction des informations de maintenance des amplis (DamTc).            *)
(* Ajout de la marche type de l'inter-station QN -> GL                       *)
(* L'entrée CES4 ES3 (CdvQUI25) devient CdvQUI22B                            *)
(*---------------------------------------------------------------------------*)
(* Version  1.1.6  =====================                                     *)
(* Version  1.14 DU SERVEUR SCCS =====================                       *)
(* Date   : 24/03/2010                                                       *)
(* Auteur :        M. Plywacz                                                *)
(* Modification : prolongement 4 de la ligne 5                               *)
(* Ajout conditions "CdvQUI22B" et "CdvQUI21" dans "PtArrSpeQUI22"           *)
(*                                                                           *)
(*---------------------------------------------------------------------------*)
(* Version  1.1.7  =====================                                     *)
(* Version  1.15 DU SERVEUR SCCS =====================                       *)
(* Date   : 03/06/2010                                                       *)
(* Auteur :        M. Plywacz                                                *)
(* Modification : prolongement 4 de la ligne 5                               *)
(* Mise en place des marches type voie 2 QN -> GL                            *)
(*---------------------------------------------------------------------------*)
(* Version  1.1.8  =====================                                     *)
(* Version  1.16 DU SERVEUR SCCS =====================                       *)
(* Date   : 18/06/2010                                                       *)
(* Auteur :        M. Plywacz                                                *)
(* Modification : prolongement 4 de la ligne 5                               *)
(* Ajout Entree Sp2QN qui est utilisee dans l'equation du sig12A             *)
(*---------------------------------------------------------------------------*)
(* Version  1.1.9  =====================                                     *)
(* Version  1.17 DU SERVEUR SCCS =====================                       *)
(* Date   : 01/07/2010                                                       *)
(* Auteur :        M. Plywacz                                                *)
(* Modification : prolongement 4 de la ligne 5                               *)
(* Ajustement des marches type voies 1-2 QN <-> CU                           *)
(*---------------------------------------------------------------------------*)
(* Version  1.2.0  =====================                                     *)
(* Version  1.18 DU SERVEUR SCCS =====================                       *)
(* Date   : 01/07/2010                                                       *)
(* Auteur :        Ph. Hog                                                   *)
(* Modification : prolongement 4 de la ligne 5                               *)
(* Ajout de l'ArretSpeQUI12B = Cdv12B et Cdv13 et (Aig13 à droite ou Cdv23)  *)
(*---------------------------------------------------------------------------*)
(* Version  1.2.1  =====================                                     *)
(* Version  1.19 DU SERVEUR SCCS =====================                       *)
(* Date   : 30/07/2010                                                       *)
(* Auteur :        M. Plywacz                                                *)
(* Modification : prolongement 4 de la ligne 5                               *)
(* Ajustement des marches type voies 1-2 QN <-> CU                           *)
(*---------------------------------------------------------------------------*)
(* Version  1.2.2  =====================                                     *)
(* Version  1.19 DU SERVEUR SCCS =====================                       *)
(* Date   : 25/05/2012                                                       *)
(* Auteur :        JP. BEMMA                                                 *)
(* Modification :  Modification poin d'arret                                 *)
(* Ajout d'un point d'arret PtArrSpeQUI13 tronçon 8.5 en entree de quai      *)
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
		       CarteCes1,  CarteCes2,  CarteCes3,  CarteCes4,  CarteCes5,  CarteCes6,
		       Intersecteur1,

       Ampli11, Ampli12, Ampli13, Ampli14, Ampli15, Ampli16, Ampli17, Ampli18, Ampli19,
                Ampli1A, Ampli1B, Ampli1C, Ampli1D,
	 Ampli21, Ampli22, Ampli23, Ampli24, Ampli25, Ampli26, Ampli27, 
	 Ampli31, Ampli32, Ampli33, Ampli34, Ampli35, Ampli36, Ampli37, Ampli38, Ampli39,
                Ampli3A,
 	 Ampli41, Ampli42, Ampli43, Ampli44, Ampli45, Ampli46, Ampli47, Ampli48, Ampli49,
                Ampli4A,
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

    L0507  = 1024*07; (* numero Secteur aval decale de 2**10 *)

    L0508  = 1024*08; (* numero Secteur local decale de 2**10 *)

    L0541  = 1024*41; (* numero Secteur amont decale de 2**10 *)


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
    noBoucleANA = 00;
    noBoucleBLA = 01;
    noBoucle1 = 03;
    noBoucle2 = 04;
    noBoucle3 = 05;
    noBoucle4 = 06;
    noBoucle5 = 07;
    noBoucle6 = 08;


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

   SigQUI10,       (* entree  1, soit entree 0 de CES 02  *)
   SigQUI11kj,     (* entree  2, soit entree 1 de CES 02  *)
   SigQUI12Akv,    (* entree  3, soit entree 2 de CES 02  *)
   SigQUI12B,      (* entree  4, soit entree 3 de CES 02  *)
   SigQUI24kv,     (* entree  5, soit entree 4 de CES 02  *)
   SigQUI24kj,     (* entree  6, soit entree 5 de CES 02  *)
   SigQUI22kj,     (* entree  7, soit entree 6 de CES 02  *)
   SigQUI_Z,       (* entree  8, soit entree 7 de CES 02  *)


   CdvQUI11A,      (* entree 13, soit entree 4 de CES 03  *)
   CdvQUI11B,      (* entree 14, soit entree 5 de CES 03  *)
   CdvQUI12A,      (* entree 15, soit entree 6 de CES 03  *)
   CdvQUI12B,      (* entree 16, soit entree 7 de CES 03  *)

   CdvQUI13,       (* entree 17, soit entree 0 de CES 04  *)
   CdvQUI14,       (* entree 18, soit entree 1 de CES 04  *)
   CdvQUI26,       (* entree 19, soit entree 2 de CES 04  *)
   CdvQUI22B,      (* entree 20, soit entree 3 de CES 04  *)
   CdvQUI23,       (* entree 21, soit entree 4 de CES 04  *)
   CdvQUI22A,      (* entree 22, soit entree 5 de CES 04  *)
   CdvQUI21,       (* entree 23, soit entree 6 de CES 04  *)
   CdvQUI20,       (* entree 24, soit entree 7 de CES 04  *)

   CdvLIB10,       (* entree 25, soit entree 0 de CES 05  *)
   CdvLIB11,       (* entree 26, soit entree 1 de CES 05  *)
   CdvLIB12,       (* entree 27, soit entree 2 de CES 05  *)
   CdvLIB22,       (* entree 28, soit entree 3 de CES 05  *)
   CdvLIB23,       (* entree 29, soit entree 4 de CES 05  *)
   CdvLIB24,       (* entree 30, soit entree 5 de CES 05  *)
   CdvLIB25,       (* entree 31, soit entree 6 de CES 05  *)
   CdvQUI19,       (* entree 32, soit entree 7 de CES 05  *)

   CdvQUI09,       (* entree 33, soit entree 0 de CES 06  *)
   CdvQUI10,       (* entree 34, soit entree 1 de CES 06  *)
   SigQUI11kv,     (* entree 35, soit entree 2 de CES 06  *)
   SigQUI12Akj,    (* entree 36, soit entree 3 de CES 06  *)
   SigQUI22kv,     (* entree 37, soit entree 4 de CES 06  *)
   SigQUI26,       (* entree 38, soit entree 5 de CES 06  *)

   Sp2QN          (* entree 41, soit entree 1 de CES 07  *)

             : BoolD;

    AigQUI13_23,    (* entrees 09 & 10, soit entrees 0 & 1 de CES 03 *) 
    AigQUI11_z,     (* entrees 11 & 12, soit entrees 2 & 3 de CES 03 *) 
    AigQUI21        (* entrees 39 & 40, soit entrees 6 & 7 de CES 06 *) 

             : TyAig; 


(* variants lies a une commutation d'aiguille *)
    com1troncon3,
    com2troncon3,
    com3troncon3,
    com4troncon3,
    com5troncon3 : BoolD; 


(***********************************************************)
(* Variables ne correspondant pas a une entree securitaire *)
(* Points d'arret *)

    PtArrSigQUI10,
    PtArrSpeQUI11,
    PtArrSpeQUI12B,
    PtArrSigQUI12A,
    PtArrSigQUI12B,
    PtArrSigQUI26,
    PtArrSigQUI24,
    PtArrSigQUI22,
    PtArrSigQUI_Z,

    PtArrCdvQUI09,
    PtArrCdvQUI10,
    PtArrCdvQUI19,
    PtArrCdvQUI20,
    PtArrSpeQUI22,
    PtArrCdvQUI26,
	
    PtArrSpeQUI13,	

    PtArrCdvLIB10,
    PtArrCdvLIB11,
    PtArrCdvLIB12,
    PtArrCdvLIB22,
    PtArrCdvLIB23,
    PtArrCdvLIB24,
    PtArrCdvLIB25            : BoolD;



 (* Variants anticipes *)

   PtAntCdvGLU23,
   PtAntCdvGLU22,
   PtAntCdvGLU21,

    PtAntCdvANA06,
    PtAntSigANA06,
    PtAntSigANA08             : BoolD;


(***********************************************************)
(* Copie des entrees dans des variables fonctionnelles pour la regulation   *)
 
 CdvQUI12Fonc,
 CdvQUI22Fonc,
 CdvLIB10Fonc,
 CdvLIB25Fonc,
 CdvLIB12Fonc,
 CdvLIB22Fonc           : BOOLEAN;

(** Voie d'emission SOL-TRAIN : deux sens confondus**)

    te11s08t01,
    te16s08t02,
    te21s08t03,
    te25s08t04,
    te31s08t05,     
    te34s08t06  :TyEmissionTele;

(** Voie d'emission Inter-secteur deux voies confondues **)
    teL0507,
    teL0541        :TyEmissionTele;

(** Voie de reception Inter-secteur deux voies confondues **)
    trL0507,
    trL0541        :TyCaracEntSec;

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

   EntreeAiguille(AigQUI11_z,  11, 12); (* Aig --> Gauche = Branch Normale *)
   EntreeAiguille(AigQUI13_23, 10, 9 ); (* Aig --> Droite = Branch Normale *) 
   EntreeAiguille(AigQUI21,    40, 39); (* Aig --> Droite = Branch Normale *) 


(* Configuration des entrees *)
   ProcEntreeIntrins ( 1,   SigQUI10   );
   ProcEntreeIntrins ( 2,   SigQUI11kj );
   ProcEntreeIntrins ( 3,   SigQUI12Akv );
   ProcEntreeIntrins ( 4,   SigQUI12B  );
   ProcEntreeIntrins ( 5,   SigQUI24kv );
   ProcEntreeIntrins ( 6,   SigQUI24kj );
   ProcEntreeIntrins ( 7,   SigQUI22kj );
   ProcEntreeIntrins ( 8,   SigQUI_Z   );
   ProcEntreeIntrins (13,   CdvQUI11A  );
   ProcEntreeIntrins (14,   CdvQUI11B  );
   ProcEntreeIntrins (15,   CdvQUI12A  );
   ProcEntreeIntrins (16,   CdvQUI12B  );
   ProcEntreeIntrins (17,   CdvQUI13   );
   ProcEntreeIntrins (18,   CdvQUI14   );

   ProcEntreeIntrins (19,   CdvQUI26   );
   ProcEntreeIntrins (20,   CdvQUI22B  );
   ProcEntreeIntrins (21,   CdvQUI23   );
   ProcEntreeIntrins (22,   CdvQUI22A  );
   ProcEntreeIntrins (23,   CdvQUI21   );
   ProcEntreeIntrins (24,   CdvQUI20   );

   ProcEntreeIntrins (25,   CdvLIB10   );
   ProcEntreeIntrins (26,   CdvLIB11   );
   ProcEntreeIntrins (27,   CdvLIB12   );
   ProcEntreeIntrins (28,   CdvLIB22   );
   ProcEntreeIntrins (29,   CdvLIB23   );
   ProcEntreeIntrins (30,   CdvLIB24   );
   ProcEntreeIntrins (31,   CdvLIB25   );

   ProcEntreeIntrins (32,   CdvQUI19   );
   ProcEntreeIntrins (33,   CdvQUI09   );
   ProcEntreeIntrins (34,   CdvQUI10   );

   ProcEntreeIntrins (35,   SigQUI11kv );
   ProcEntreeIntrins (36,   SigQUI12Akj );
   ProcEntreeIntrins (37,   SigQUI22kv );
   ProcEntreeIntrins (38,   SigQUI26   );

   ProcEntreeIntrins (41,   Sp2QN        );


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
ConfigurerAmpli(Ampli1A, 1, 10, 195, 14, TRUE);
ConfigurerAmpli(Ampli1B, 1, 11, 196, 15, FALSE);
ConfigurerAmpli(Ampli1C, 1, 12, 197, 15, FALSE);
ConfigurerAmpli(Ampli1D, 1, 13, 198, 15, FALSE);

ConfigurerAmpli(Ampli21, 2, 1, 199, 16, FALSE);
ConfigurerAmpli(Ampli22, 2, 2, 200, 17, FALSE);
ConfigurerAmpli(Ampli23, 2, 3, 201, 17, FALSE);
ConfigurerAmpli(Ampli24, 2, 4, 202, 17, TRUE);
ConfigurerAmpli(Ampli25, 2, 5, 203, 18, FALSE);
ConfigurerAmpli(Ampli26, 2, 6, 204, 18, FALSE);
ConfigurerAmpli(Ampli27, 2, 7, 205, 18, TRUE);

ConfigurerAmpli(Ampli31, 3, 1, 206, 21, FALSE);
ConfigurerAmpli(Ampli32, 3, 2, 207, 22, FALSE);
ConfigurerAmpli(Ampli33, 3, 3, 208, 22, FALSE);
ConfigurerAmpli(Ampli34, 3, 4, 209, 22, TRUE);
ConfigurerAmpli(Ampli35, 3, 5, 210, 23, FALSE);
ConfigurerAmpli(Ampli36, 3, 6, 211, 23, FALSE);
ConfigurerAmpli(Ampli37, 3, 7, 212, 23, TRUE);
ConfigurerAmpli(Ampli38, 3, 8, 213, 24, FALSE);
ConfigurerAmpli(Ampli39, 3, 9, 214, 24, FALSE);
ConfigurerAmpli(Ampli3A, 3, 10, 215, 24, TRUE);

ConfigurerAmpli(Ampli41, 4, 1, 216, 25, FALSE);
ConfigurerAmpli(Ampli42, 4, 2, 217, 26, FALSE);
ConfigurerAmpli(Ampli43, 4, 3, 218, 26, FALSE);
ConfigurerAmpli(Ampli44, 4, 4, 219, 26, TRUE);
ConfigurerAmpli(Ampli45, 4, 5, 220, 27, FALSE);
ConfigurerAmpli(Ampli46, 4, 6, 221, 27, FALSE);
ConfigurerAmpli(Ampli47, 4, 7, 222, 27, TRUE);
ConfigurerAmpli(Ampli48, 4, 8, 223, 28, FALSE);
ConfigurerAmpli(Ampli49, 4, 9, 256, 28, FALSE);
ConfigurerAmpli(Ampli4A, 4, 10, 257, 28, TRUE);

ConfigurerAmpli(Ampli51, 5, 1, 258, 31, FALSE);
ConfigurerAmpli(Ampli52, 5, 2, 259, 32, FALSE);
ConfigurerAmpli(Ampli53, 5, 3, 260, 32, FALSE);
ConfigurerAmpli(Ampli54, 5, 4, 261, 32, TRUE);
ConfigurerAmpli(Ampli55, 5, 5, 262, 33, FALSE);
ConfigurerAmpli(Ampli56, 5, 6, 263, 33, FALSE);
ConfigurerAmpli(Ampli57, 5, 7, 264, 33, TRUE);

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
   ConfigurerCES(CarteCes4, 04);
   ConfigurerCES(CarteCes5, 05);
   ConfigurerCES(CarteCes6, 06);

(** Liaisons Inter-Secteur **)

   ConfigurerIntsecteur(Intersecteur1, 01, trL0507, trL0541);


(* Initialisations des variables ne correspondant pas a des entrees secu *)

(* Affectation a l'etat restrictif des variants commutes *)
   AffectBoolD(BoolRestrictif, com1troncon3) ;
   AffectBoolD(BoolRestrictif, com2troncon3) ;
   AffectBoolD(BoolRestrictif, com3troncon3) ;
   AffectBoolD(BoolRestrictif, com4troncon3) ;
   AffectBoolD(BoolRestrictif, com5troncon3) ;


(* Point d'arret *)
   AffectBoolD( BoolRestrictif, PtArrSigQUI10   );
   AffectBoolD( BoolRestrictif, PtArrSpeQUI11   );
   AffectBoolD( BoolRestrictif, PtArrSpeQUI12B  );
   AffectBoolD( BoolRestrictif, PtArrSigQUI12A   );
   AffectBoolD( BoolRestrictif, PtArrSigQUI12B  );
   AffectBoolD( BoolRestrictif, PtArrCdvQUI26   );
   
   AffectBoolD( BoolRestrictif, PtArrSigQUI22  );
   AffectBoolD( BoolRestrictif, PtArrSigQUI_Z   );

   AffectBoolD( BoolRestrictif, PtArrCdvQUI09   );
   AffectBoolD( BoolRestrictif, PtArrCdvQUI10   );
   AffectBoolD( BoolRestrictif, PtArrCdvQUI19   );
   AffectBoolD( BoolRestrictif, PtArrCdvQUI20   );
   AffectBoolD( BoolRestrictif, PtArrSpeQUI22   );
   AffectBoolD( BoolRestrictif, PtArrCdvQUI26   );
   
   AffectBoolD( BoolRestrictif, PtArrSpeQUI13   );   

   AffectBoolD( BoolRestrictif, PtArrCdvLIB10   );
   AffectBoolD( BoolRestrictif, PtArrCdvLIB11   );
   AffectBoolD( BoolRestrictif, PtArrCdvLIB12   );

   AffectBoolD( BoolRestrictif, PtArrCdvLIB22   );
   AffectBoolD( BoolRestrictif, PtArrCdvLIB23   );
   AffectBoolD( BoolRestrictif, PtArrCdvLIB24   );
   AffectBoolD( BoolRestrictif, PtArrCdvLIB25   );



(* Variants anticipes *)

   AffectBoolD( BoolRestrictif, PtAntCdvGLU23   );
   AffectBoolD( BoolRestrictif, PtAntCdvGLU22   );
   AffectBoolD( BoolRestrictif, PtAntCdvGLU21   );

   AffectBoolD( BoolRestrictif, PtAntCdvANA06   );
   AffectBoolD( BoolRestrictif, PtAntSigANA06   );
   AffectBoolD( BoolRestrictif, PtAntSigANA08   );


(* Regulation *)
 CdvQUI12Fonc := FALSE;
 CdvQUI22Fonc := FALSE;
 CdvLIB10Fonc := FALSE;
 CdvLIB25Fonc := FALSE;
 CdvLIB12Fonc := FALSE;
 CdvLIB22Fonc := FALSE;

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

   ConfigEmisTeleSolTrain ( te11s08t01,
			    noBoucle1,
			    BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te16s08t02,
			    noBoucle2,
			    BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te21s08t03,
			    noBoucle3,
			    BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te25s08t04,
			    noBoucle4,
			    BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te31s08t05,
			    noBoucle5,
			    BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te34s08t06,
			    noBoucle6,
			    BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);


(* CONFIGURATION POUR LA REGULATION *)

   ConfigQuai(68, 64, CdvQUI12Fonc, te11s08t01, 0,  3, 4,11, 5,  13,14,15);

(* ConfigQuai(67, 74, CdvLIB10Fonc, te16s08t02, 0, 11,10, 6, 7,  13,14,15); *)

   ConfigQuai(66, 84, CdvLIB12Fonc, te16s08t02, 0,  9, 4,11, 5,  13,14,15);

   ConfigQuai(68, 69, CdvQUI22Fonc, te25s08t04, 0, 12, 8, 9, 4,  13,14,15);

(* ConfigQuai(67, 79, CdvLIB25Fonc, te21s08t03, 0, 11,10, 6, 7,  13,14,15); *)

   ConfigQuai(66, 89, CdvLIB22Fonc, te21s08t03, 0,  3, 4,11, 5,  13,14,15);


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

   ProcEmisSolTrain( te11s08t01.EmissionSensUp, (2*noBoucle1),
		     LigneL05+ L0508+ TRONC*01,

 		  PtArrCdvQUI10,
 		  PtArrSigQUI10,
 		  BoolRestrictif, (* AspectCroix *)
 		  PtArrSpeQUI11,
 		  PtArrSpeQUI12B,
		  PtArrSigQUI12A,
		  BoolRestrictif, (* AspectCroix *)
 		  AigQUI13_23.PosNormaleFiltree,   (* TIV Com *)
		  AigQUI13_23.PosReverseFiltree,
		  AigQUI13_23.PosNormaleFiltree,
 		  PtArrSigQUI_Z,
 		  BoolRestrictif, (* AspectCroix *)
		  AigQUI11_z.PosReverseFiltree,
		  AigQUI11_z.PosNormaleFiltree,
 		  BoolRestrictif,

(* Variants Anticipes *)
		  PtArrCdvLIB10,
 		  PtArrCdvLIB11,
 		  BoolRestrictif,
		  BoolRestrictif,
 		  BoolRestrictif,
 		  BoolRestrictif,
 		  BoolRestrictif,
		  BoolPermissif,
		  BaseSorVar);



(* variants troncon 2 *)

   ProcEmisSolTrain( te16s08t02.EmissionSensUp, (2*noBoucle2),
		     LigneL05+ L0508+ TRONC*02,

		  PtArrCdvLIB10,
		  PtArrCdvLIB11,
		  PtArrCdvLIB12,
		  PtAntCdvANA06,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,		  
		  BoolRestrictif,
(* Variants Anticipes *)
		  PtAntSigANA06,
		  BoolRestrictif, (* AspectCroix *)
		  PtAntSigANA08,
		  BoolRestrictif, (* AspectCroix *)
		  BoolRestrictif,
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

   ProcEmisSolTrain( te21s08t03.EmissionSensUp, (2*noBoucle3),
		     LigneL05+ L0508+ TRONC*03,

		  PtArrCdvLIB23,
		  PtArrCdvLIB24,
		  PtArrCdvLIB25,
		  PtArrCdvQUI26,
		  PtArrSigQUI26,
		  BoolRestrictif,  (* AspectCroix *)
		  PtArrSigQUI24,
		  BoolRestrictif,  (* AspectCroix *)
		  AigQUI13_23.PosNormaleFiltree,   (* TIV Com *)
		  AigQUI13_23.PosReverseFiltree,
		  AigQUI13_23.PosNormaleFiltree,
		  PtArrSpeQUI22,
(* Variants Anticipes *)
		  com1troncon3,		  
		  com2troncon3,
		  com3troncon3,
		  com4troncon3,
		  com5troncon3,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolPermissif,
		  BaseSorVar + 60);


(* variants troncon 4 *)

   ProcEmisSolTrain( te25s08t04.EmissionSensUp, (2*noBoucle4),
		     LigneL05+ L0508+ TRONC*04,

		  PtArrSigQUI22,
		  BoolRestrictif,  (* AspectCroix *)
		  AigQUI21.PosNormaleFiltree,   (* TIV Com *)
		  AigQUI21.PosReverseFiltree,
		  AigQUI21.PosNormaleFiltree,
		  BoolRestrictif,
		  BoolRestrictif,
		  PtArrCdvQUI19,
		  PtAntCdvGLU23,
		  BoolRestrictif,
(* Variants Anticipes *)
		  PtAntCdvGLU22,
		  PtAntCdvGLU21,
		  BoolRestrictif,
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

   ProcEmisSolTrain( te31s08t05.EmissionSensUp, (2*noBoucle5),
		     LigneL05+ L0508+ TRONC*05,
          
		  PtArrSpeQUI13,
		  PtArrSigQUI12B,
		  BoolRestrictif,  (* AspectCroix *)
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
(* Variants Anticipes *)
		  BoolRestrictif, (* rouge fixe *)
		  BoolRestrictif, (* AspectCroix *)
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,		  
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

   ProcEmisSolTrain( te34s08t06.EmissionSensUp, (2*noBoucle6),
		     LigneL05+ L0508+ TRONC*06,

		  BoolRestrictif,
		  BoolRestrictif,  
		  BoolRestrictif,
		  BoolRestrictif,
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
		  BaseSorVar + 150);



(* reception du secteur 7 aval *)
   ProcReceptInterSecteur(trL0507, noBoucleANA, LigneL05+ L0507+ TRONC*01,

		  PtAntCdvANA06,
		  PtAntSigANA06,
		  PtAntSigANA08,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
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

(* reception du secteur 41 amont *)
   ProcReceptInterSecteur(trL0541, noBoucleBLA, LigneL05+ L0541+ TRONC*01,

		  PtAntCdvGLU23,
		  PtAntCdvGLU22,
		  PtAntCdvGLU21,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
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



(* emission vers le secteur 7 aval *)
   ProcEmisInterSecteur (teL0507, noBoucleANA, LigneL05+ L0508+ TRONC*02,
			noBoucleANA,
		  PtArrCdvLIB22,
		  PtArrCdvLIB23,
		  PtArrCdvLIB24,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
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

(* emission vers le secteur 41 amont *)
   ProcEmisInterSecteur (teL0541, noBoucleBLA, LigneL05+ L0508+ TRONC*02,
		  noBoucleBLA,
		  PtArrCdvQUI09,
		  PtArrCdvQUI10,
		  PtArrSigQUI10,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
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

 (** Emission invariants vers secteur aval L0507 **)
   EmettreSegm(LigneL05+ L0508+ TRONC*03+ SEGM*00, noBoucleANA, SensUp);
   EmettreSegm(LigneL05+ L0508+ TRONC*03+ SEGM*01, noBoucleANA, SensUp);

 (** Emission invariants vers secteur amont L0541 **)
   EmettreSegm(LigneL05+ L0508+ TRONC*01+ SEGM*00, noBoucleBLA, SensUp);
   EmettreSegm(LigneL05+ L0508+ TRONC*01+ SEGM*01, noBoucleBLA, SensUp);



 (** Boucle 1 **)
   EmettreSegm(LigneL05+ L0508+ TRONC*01+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL05+ L0508+ TRONC*01+ SEGM*01, noBoucle1, SensUp);
   EmettreSegm(LigneL05+ L0508+ TRONC*01+ SEGM*02, noBoucle1, SensUp);
   EmettreSegm(LigneL05+ L0508+ TRONC*02+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL05+ L0508+ TRONC*02+ SEGM*01, noBoucle1, SensUp);
   EmettreSegm(LigneL05+ L0508+ TRONC*06+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL05+ L0508+ TRONC*06+ SEGM*01, noBoucle1, SensUp);
   EmettreSegm(LigneL05+ L0508+ TRONC*05+ SEGM*00, noBoucle1, SensUp);

 (** Boucle 2 **)
   EmettreSegm(LigneL05+ L0508+ TRONC*02+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL05+ L0508+ TRONC*02+ SEGM*01, noBoucle2, SensUp);
   EmettreSegm(LigneL05+ L0507+ TRONC*01+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL05+ L0507+ TRONC*01+ SEGM*01, noBoucle2, SensUp);
   EmettreSegm(LigneL05+ L0507+ TRONC*01+ SEGM*02, noBoucle2, SensUp);
   EmettreSegm(LigneL05+ L0507+ TRONC*02+ SEGM*00, noBoucle2, SensUp);

 (** Boucle 3 **)
   EmettreSegm(LigneL05+ L0508+ TRONC*03+ SEGM*00, noBoucle3, SensUp);  
   EmettreSegm(LigneL05+ L0508+ TRONC*03+ SEGM*01, noBoucle3, SensUp);  
   EmettreSegm(LigneL05+ L0508+ TRONC*04+ SEGM*00, noBoucle3, SensUp);  
   EmettreSegm(LigneL05+ L0508+ TRONC*04+ SEGM*01, noBoucle3, SensUp);  
   EmettreSegm(LigneL05+ L0508+ TRONC*04+ SEGM*02, noBoucle3, SensUp);  
   EmettreSegm(LigneL05+ L0508+ TRONC*05+ SEGM*00, noBoucle3, SensUp);  

 (** Boucle 4 **)
   EmettreSegm(LigneL05+ L0508+ TRONC*04+ SEGM*00, noBoucle4, SensUp); 
   EmettreSegm(LigneL05+ L0508+ TRONC*04+ SEGM*01, noBoucle4, SensUp); 
   EmettreSegm(LigneL05+ L0508+ TRONC*04+ SEGM*02, noBoucle4, SensUp); 
   EmettreSegm(LigneL05+ L0508+ TRONC*01+ SEGM*02, noBoucle4, SensUp); 
   EmettreSegm(LigneL05+ L0541+ TRONC*02+ SEGM*00, noBoucle4, SensUp);
   EmettreSegm(LigneL05+ L0541+ TRONC*02+ SEGM*01, noBoucle4, SensUp);

 (** Boucle 5 **)
   EmettreSegm(LigneL05+ L0508+ TRONC*05+ SEGM*00, noBoucle5, SensUp); 
   EmettreSegm(LigneL05+ L0508+ TRONC*04+ SEGM*01, noBoucle5, SensUp); 
   EmettreSegm(LigneL05+ L0508+ TRONC*01+ SEGM*01, noBoucle5, SensUp); 

 (** Boucle 6 **)
   EmettreSegm(LigneL05+ L0508+ TRONC*06+ SEGM*00, noBoucle6, SensUp); 
   EmettreSegm(LigneL05+ L0508+ TRONC*06+ SEGM*01, noBoucle6, SensUp); 
   EmettreSegm(LigneL05+ L0508+ TRONC*04+ SEGM*00, noBoucle6, SensUp); 
   EmettreSegm(LigneL05+ L0508+ TRONC*03+ SEGM*01, noBoucle6, SensUp); 


(* CONFIGURATION DES TRONCONS TSR *********************************)

   ConfigurerTroncon(Tronc0, LigneL05 + L0508 + TRONC*01, 1,1,1,1);  (* troncon 8-1 *)
   ConfigurerTroncon(Tronc1, LigneL05 + L0508 + TRONC*02, 1,1,1,1);  (* troncon 8-2 *)
   ConfigurerTroncon(Tronc2, LigneL05 + L0508 + TRONC*03, 1,1,1,1);  (* troncon 8-3 *)
   ConfigurerTroncon(Tronc3, LigneL05 + L0508 + TRONC*04, 1,1,1,1);  (* troncon 8-4 *)
   ConfigurerTroncon(Tronc4, LigneL05 + L0508 + TRONC*05, 1,1,1,1);  (* troncon 8-5 *)
   ConfigurerTroncon(Tronc5, LigneL05 + L0508 + TRONC*06, 1,1,1,1);  (* troncon 8-6 *)

(* EMISSION DES TSR SUR VOIE 1 ***********************************************)

 (** Emission des TSR vers le secteur aval L0507 **)
   EmettreTronc(LigneL05+ L0508+ TRONC*03, noBoucleANA, SensUp);

 (** Emission des TSR vers le secteur amont L0541 **)
   EmettreTronc(LigneL05+ L0508+ TRONC*01, noBoucleBLA, SensUp);

 (** Emission des TSR sur les troncons du secteur courant **)
   EmettreTronc(LigneL05+ L0508+ TRONC*01, noBoucle1, SensUp); (* troncon 8-1 *)
   EmettreTronc(LigneL05+ L0508+ TRONC*02, noBoucle1, SensUp);
   EmettreTronc(LigneL05+ L0508+ TRONC*05, noBoucle1, SensUp);
   EmettreTronc(LigneL05+ L0508+ TRONC*06, noBoucle1, SensUp);

   EmettreTronc(LigneL05+ L0508+ TRONC*02, noBoucle2, SensUp); (* troncon 8-2 *)
   EmettreTronc(LigneL05+ L0507+ TRONC*01, noBoucle2, SensUp);
   EmettreTronc(LigneL05+ L0507+ TRONC*02, noBoucle2, SensUp);

   EmettreTronc(LigneL05+ L0508+ TRONC*03, noBoucle3, SensUp); (* troncon 8-3 *)
   EmettreTronc(LigneL05+ L0508+ TRONC*04, noBoucle3, SensUp);
   EmettreTronc(LigneL05+ L0508+ TRONC*05, noBoucle3, SensUp);

   EmettreTronc(LigneL05+ L0508+ TRONC*04, noBoucle4, SensUp); (* troncon 8-4 *)
   EmettreTronc(LigneL05+ L0508+ TRONC*01, noBoucle4, SensUp);
   EmettreTronc(LigneL05+ L0541+ TRONC*02, noBoucle4, SensUp);

   EmettreTronc(LigneL05+ L0508+ TRONC*05, noBoucle5, SensUp); (* troncon 8-5 *)
   EmettreTronc(LigneL05+ L0508+ TRONC*04, noBoucle5, SensUp);
   EmettreTronc(LigneL05+ L0508+ TRONC*01, noBoucle5, SensUp);

   EmettreTronc(LigneL05+ L0508+ TRONC*06, noBoucle6, SensUp); (* troncon 8-6 *)
   EmettreTronc(LigneL05+ L0508+ TRONC*04, noBoucle6, SensUp);
   EmettreTronc(LigneL05+ L0508+ TRONC*03, noBoucle6, SensUp);


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

   StockAdres( ADR(SigQUI10   ));
   StockAdres( ADR(SigQUI11kj ));
   StockAdres( ADR(SigQUI12Akv  ));
   StockAdres( ADR(SigQUI12B  ));
   StockAdres( ADR(SigQUI24kv ));
   StockAdres( ADR(SigQUI24kj ));
   StockAdres( ADR(SigQUI22kj   ));
   StockAdres( ADR(SigQUI_Z      ));

   StockAdres( ADR(CdvQUI11A  ));
   StockAdres( ADR(CdvQUI11B  ));

   StockAdres( ADR(CdvQUI12A  ));
   StockAdres( ADR(CdvQUI12B  ));
   StockAdres( ADR(CdvQUI13  ));
   StockAdres( ADR(CdvQUI14   ));

   StockAdres( ADR(CdvQUI26   ));
   StockAdres( ADR(CdvQUI22B  ));
   StockAdres( ADR(CdvQUI23   ));
   StockAdres( ADR(CdvQUI22A  ));
   StockAdres( ADR(CdvQUI21   ));
   StockAdres( ADR(CdvQUI20   ));

   StockAdres( ADR(CdvLIB10   ));
   StockAdres( ADR(CdvLIB11   ));
   StockAdres( ADR(CdvLIB12   ));
   StockAdres( ADR(CdvLIB22   ));
   StockAdres( ADR(CdvLIB23   ));
   StockAdres( ADR(CdvLIB24   ));
   StockAdres( ADR(CdvLIB25   ));

   StockAdres( ADR(CdvQUI19   ));
   StockAdres( ADR(CdvQUI09   ));
   StockAdres( ADR(CdvQUI10   ));

   StockAdres( ADR(SigQUI11kv ));
   StockAdres( ADR(SigQUI12Akj  ));
   StockAdres( ADR(SigQUI22kv   ));
   StockAdres( ADR(SigQUI26   ));
   StockAdres( ADR(Sp2QN   ));

   StockAdres( ADR( AigQUI13_23 )); 
   StockAdres( ADR( AigQUI11_z )); 
   StockAdres( ADR( AigQUI21 )); 

   StockAdres( ADR(com1troncon3));
   StockAdres( ADR(com2troncon3));
   StockAdres( ADR(com3troncon3));
   StockAdres( ADR(com4troncon3));
   StockAdres( ADR(com5troncon3));


(* Points d'arret *)
   StockAdres( ADR( PtArrSigQUI10   ));
   StockAdres( ADR( PtArrSpeQUI11   ));
   StockAdres( ADR( PtArrSpeQUI12B  ));
   StockAdres( ADR( PtArrSigQUI12A   ));
   StockAdres( ADR( PtArrSigQUI12B  ));
   StockAdres( ADR( PtArrSigQUI26   ));
   StockAdres( ADR( PtArrSigQUI24   ));
   StockAdres( ADR( PtArrSigQUI22   ));
   StockAdres( ADR( PtArrSigQUI_Z   ));

   StockAdres( ADR( PtArrCdvLIB10   ));
   StockAdres( ADR( PtArrCdvLIB11   ));
   StockAdres( ADR( PtArrCdvLIB12   ));

   StockAdres( ADR( PtArrCdvLIB22   ));
   StockAdres( ADR( PtArrCdvLIB23   ));
   StockAdres( ADR( PtArrCdvLIB24   ));
   StockAdres( ADR( PtArrCdvLIB25   ));

   StockAdres( ADR( PtArrCdvQUI09   ));
   StockAdres( ADR( PtArrCdvQUI10   ));
   StockAdres( ADR( PtArrCdvQUI19   ));
   StockAdres( ADR( PtArrCdvQUI20   ));
   StockAdres( ADR( PtArrSpeQUI22   ));
   StockAdres( ADR( PtArrCdvQUI26  ));
   StockAdres( ADR( PtArrSpeQUI13   ));
   
(* coucou *)
   StockAdres( ADR( PtAntCdvANA06   ));
   StockAdres( ADR( PtAntSigANA06   ));
   StockAdres( ADR( PtAntSigANA08   ));

   StockAdres( ADR( PtAntCdvGLU23   ));
   StockAdres( ADR( PtAntCdvGLU22   ));
   StockAdres( ADR( PtAntCdvGLU21   ));


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
VAR BoolTr, BoolTr1 : BoolLD;

BEGIN (* ExeSpecific *)

(* Affectation des "constantes" utilisees dans la construction des messages emis        *)
(* et recus sur les boucles de transmission continue et sur les liens intersecteur.     *)
(* Cette reaffectation est necessaire a chaque cycle pour la mise en securite.          *)
   AffectBoolC(Vrai, BoolPermissif)  ;
   AffectBoolC(Faux, BoolRestrictif) ;

 (* regulation *)
 CdvQUI12Fonc := (CdvQUI12A.F = Vrai.F) AND (CdvQUI12B.F = Vrai.F);
 CdvQUI22Fonc := (CdvQUI22A.F = Vrai.F) AND (CdvQUI22B.F = Vrai.F);

 CdvLIB10Fonc := CdvLIB10.F = Vrai.F;
 CdvLIB12Fonc := CdvLIB12.F = Vrai.F;
 CdvLIB22Fonc := CdvLIB22.F = Vrai.F;
 CdvLIB25Fonc := CdvLIB25.F = Vrai.F;




(**** FILTRAGE DES AIGUILLES **************************************************)

  FiltrerAiguille(AigQUI11_z,  BaseExeAig ) ;
  FiltrerAiguille(AigQUI13_23, BaseExeAig + 2) ;
  FiltrerAiguille(AigQUI21,    BaseExeAig + 4) ;


(**** DETERMINATION DES POINTS D'ARRET ****************************************)

   AffectBoolD( SigQUI10,    PtArrSigQUI10  );

   AffectBoolD( SigQUI12B,   PtArrSigQUI12B );
   AffectBoolD( SigQUI26,    PtArrSigQUI26  );
   AffectBoolD( SigQUI_Z,    PtArrSigQUI_Z  );

   OuDD( SigQUI11kv,   SigQUI11kj,   PtArrSpeQUI11  );
   OuDD( SigQUI22kv,   SigQUI22kj,   PtArrSigQUI22  );
   OuDD( SigQUI24kv,   SigQUI24kj,   PtArrSigQUI24  );
   (* OuDD( SigQUI12Akv,  SigQUI12Akj,  PtArrSigQUI12A ); *)

   NonD( Sp2QN,                    BoolTr );
   OuDD( SigQUI12Akv, SigQUI12Akj, BoolTr1 );
   EtDD( BoolTr     , BoolTr1    , PtArrSigQUI12A );

   OuDD( AigQUI13_23.PosNormaleFiltree, CdvQUI23 , PtArrSpeQUI12B );
   EtDD( PtArrSpeQUI12B               , CdvQUI13 , PtArrSpeQUI12B );
   EtDD( PtArrSpeQUI12B               , CdvQUI12B, PtArrSpeQUI12B );


   AffectBoolD( CdvQUI09,    PtArrCdvQUI09  );
   AffectBoolD( CdvQUI10,    PtArrCdvQUI10  );
   AffectBoolD( CdvQUI19,    PtArrCdvQUI19  );

   
   EtDD( CdvQUI22A,CdvQUI22B,BoolTr  );
   EtDD( CdvQUI21, BoolTr,   PtArrSpeQUI22  );

   EtDD( CdvQUI12B,CdvQUI12A,BoolTr1  );
   EtDD( CdvQUI11B, BoolTr1,   PtArrSpeQUI13  );  
   
   
   AffectBoolD( CdvQUI26,    PtArrCdvQUI26  );

   AffectBoolD( CdvLIB10,    PtArrCdvLIB10  );
   AffectBoolD( CdvLIB11,    PtArrCdvLIB11  );
   AffectBoolD( CdvLIB12,    PtArrCdvLIB12  );

   AffectBoolD( CdvLIB22,    PtArrCdvLIB22  );
   AffectBoolD( CdvLIB23,    PtArrCdvLIB23  );
   AffectBoolD( CdvLIB24,    PtArrCdvLIB24  );
   AffectBoolD( CdvLIB25,    PtArrCdvLIB25  );



(*** lecture des entrees de regulation ***)
   LireEntreesRegul;

(* commutation des variants troncon 3 *)
(* en fonction de la position de l'aiguille AigQUI13_23 *)

IF Tvrai (AigQUI13_23.PosNormaleFiltree) THEN
	AffectBoolD (PtArrSigQUI22 , com1troncon3);
	AffectBoolD (BoolRestrictif, com2troncon3);
	AffectBoolD (AigQUI21.PosNormaleFiltree, com3troncon3);
	AffectBoolD (AigQUI21.PosReverseFiltree, com4troncon3);
	AffectBoolD (AigQUI21.PosNormaleFiltree, com5troncon3);

	FinBranche(1);  
 ELSE
	IF Tvrai (AigQUI13_23.PosReverseFiltree) THEN
		AffectBoolD (PtArrSpeQUI13, com1troncon3);
		AffectBoolD (PtArrSigQUI12B, com2troncon3);
		AffectBoolD (BoolRestrictif, com3troncon3);
		AffectBoolD (BoolRestrictif, com4troncon3);
		AffectBoolD (BoolRestrictif, com5troncon3);
		FinBranche(2);
	ELSE 
	  	AffectBoolD (BoolRestrictif, com1troncon3);
	  	AffectBoolD (BoolRestrictif, com2troncon3);
	  	AffectBoolD (BoolRestrictif, com3troncon3);
	  	AffectBoolD (BoolRestrictif, com4troncon3);
	  	AffectBoolD (BoolRestrictif, com5troncon3);
	  	FinBranche(3);
	END;
END;
FinArbre(BaseExeSpecific);


END ExeSpecific;
END Specific.

















