IMPLEMENTATION MODULE Specific;

(*$S- *)
(*$T- *)

(*****************************************************************************)
(*   SANTIAGO - Ligne 5 - Secteur 7                                          *)
(*  =============================                                            *)
(*                                                                           *)
(* Version  1.0.0  =====================                                     *)
(* Version  1.1 DU SERVEUR SCCS =====================                        *)
(* Date :          06/09/1999                                                *)
(* Auteur :        H. Le Roy                                                 *)
(* Modification :  Version initiale                                          *)
(*---------------------------------------------------------------------------*)
(* Version  1.0.1  =====================                                     *)
(* Version  1.2 DU SERVEUR SCCS =====================                        *)
(* Date :          20/12/1999                                                *)
(* Auteur :        H. Le Roy                                                 *)
(* Modification :  Correction d'une erreur dans l'attribution des tables de  *)
(*                  compensation                                             *)
(*---------------------------------------------------------------------------*)
(* Version  1.0.2  =====================                                     *)
(* Version  1.3 DU SERVEUR SCCS =====================                        *)
(* Date :          29/12/1999                                                *)
(* Auteur :        H. Le Roy                                                 *)
(* Modification :  Correction d'une erreur dans l'emission des segments sur  *)
(*                   le troncon 3                                            *)
(*---------------------------------------------------------------------------*)
(* Version  1.0.3  =====================                                     *)
(* Version  1.4 DU SERVEUR SCCS =====================                        *)
(* Date :          12/01/2000                                                *)
(* Auteur :        H. Le Roy                                                 *)
(* Modification :  Pour permettre l'entree a quai des grands trains, le      *)
(*      signal 12 devient approchable. On doit alors ajouter un EP en entree *)
(*      station pour garantir qu'aucun train n'est present sur le cdv13.     *)
(*      Mais un train effectuant un 14-22 bloque alors inutilement l'entree  *)
(*      a quai. L'EP est donc mis a permissif si l'aiguille est deviee,      *)
(*      quelque soit l'etat du cdv 13.                                       *)
(*---------------------------------------------------------------------------*)
(* Version  1.0.4  =====================                                     *)
(* Version  1.5 DU SERVEUR SCCS =====================                        *)
(* Date :          22/02/2000                                                *)
(* Auteur :        H. Le Roy                                                 *)
(* Modification :  AM dev022000-1 : Emission, sur le troncon 1, du segment   *)
(*                   12.4.0 necessaire au retournement sur cdv 44 du secteur *)
(*                   12. Reorganisation des emissions de segments sur les    *)
(*                   troncons 4 et 5 pour eviter une eventuelle surcharge    *) 
(*---------------------------------------------------------------------------*)
(* Version  1.0.5  =====================                                     *)
(* Version  1.6 DU SERVEUR SCCS =====================                        *)
(* Date :          03/04/2000                                                *)
(* Auteur :        H. Le Roy                                                 *)
(* Modification :  AM bo022000-1 : Correction d'une erreur de configuration  *)
(*                   des amplis. Les amplis 36 et 59 ne sont pas utilises.   *)
(*                   En outre, les amplis associes aux CEF 5 et 8 du PTC 1,  *)
(*                   4 et 7 du PTC 2 et 5 du PTC 3 sont aussi retires car    *)
(*                   ces cartes n'existent pas a l'heure actuelle            *)
(*---------------------------------------------------------------------------*)
(* Version 1.0.6  =====================                                      *)
(* Version 1.7 DU SERVEUR SCCS =====================                         *)
(* Date    :      24/05/2000                                                 *)
(* Auteur  :      D. MARTIN                                                  *)
(* Modification : Am 0165 : Ajustement des marches-types                     *)
(*                                                                           *)
(*---------------------------------------------------------------------------*)
(* Version 1.0.7  =====================                                      *)
(* Version 1.8 DU SERVEUR SCCS =====================                         *)
(* Date    :      17/10/2002                                                 *)
(* Auteur  :      M. Plywacz                                                 *)
(* Modification : Prolongement Ligne 5                                       *)
(*                                                                           *)
(*---------------------------------------------------------------------------*)
(* Version 1.0.8  =====================                                      *)
(* Version 1.9 DU SERVEUR SCCS =====================                         *)
(* Date    :      20/11/2002                                                 *)
(* Auteur  :      M. Plywacz                                                 *)
(* Modification : AM 1 (validation donnees)                                  *)
(*                                                                           *)
(*---------------------------------------------------------------------------*)
(* Version 1.0.9  =====================                                      *)
(* Version 1.10 DU SERVEUR SCCS =====================                        *)
(* Date    :      16/12/2003                                                 *)
(* Auteur  :      M. Plywacz                                                 *)
(* Modification : inversion des Entrees Secu 7 et 18                         *)
(*              : ajout de condition SP1 dans le point d'arret sig20B        *)
(*---------------------------------------------------------------------------*)
(* Version 1.1.0  =====================                                      *)
(* Version 1.11 DU SERVEUR SCCS =====================                        *)
(* Date    :      09/01/2004                                                 *)
(* Auteur  :      M. Plywacz                                                 *)
(* Modification : Emission des TSR sur troncon 7-4 TRONC*01 devient TRONC*04 *)
(*                                                                           *)
(*---------------------------------------------------------------------------*)
(* Version 1.1.1  =====================                                      *)
(* Version 1.12 DU SERVEUR SCCS =====================                        *)
(* Date    :      13/02/2004                                                 *)
(* Auteur  :      M. Plywacz                                                 *)
(* Modification : Version provisoire pour essais :                           *)
(* ne transmet pas le seg 12_4_0  sur troncon 7_1                            *)
(*                                                                           *)
(*---------------------------------------------------------------------------*)
(* Version 1.1.2  =====================                                      *)
(* Version 1.13 DU SERVEUR SCCS =====================                        *)
(* Date    :      18/02/2004                                                 *)
(* Auteur  :      M. Plywacz                                                 *)
(* Modification : Modifs Troncons intersecteur vers sect 1 :                 *)
(*                                                                           *)
(*---------------------------------------------------------------------------*)
(* Version 1.1.3  =====================                                      *)
(* Version 1.14 DU SERVEUR SCCS =====================                        *)
(* Date :         11/03/2004                                                 *)
(* Auteur  :      M. Plywacz                                                 *)
(* Modification : Ajustement marches types                                   *)
(*                                                                           *)
(*---------------------------------------------------------------------------*)
(* Version 1.1.4  =====================                                      *)
(* Version 1.15 DU SERVEUR SCCS =====================                        *)
(* Date    :      17/03/2004                                                 *)
(* Auteur  :      M. Plywacz                                                 *)
(* Modification : Ajout Troncon 7.7 et modif  troncon 7.1                    *)
(*                Ajout EP (cdv12 Santa ANA)  troncon 7.1                    *)
(*                Ajout EP (cdv22 Santa ANA)  troncon 7.3                    *)
(*                Ajout var anticipe (sig42B) troncon 7.6                    *)
(*                                                                           *)
(*---------------------------------------------------------------------------*)
(* Version 1.1.5  =====================                                      *)
(* Version 1.16 DU SERVEUR SCCS =====================                        *)
(* Date    :      19/03/2004                                                 *)
(* Auteur  :      M. Plywacz                                                 *)
(* Modification : Supprim emission seg 7.4.0         sur Troncon 7.4         *)
(*                Supprim emission seg 7.5.0 , 7.5.1 sur Troncon 7.5         *)
(*                Supprim emission seg 7.7.0 , 7.7.0 sur Troncon 7.7         *)
(*                Supprim emission seg 7.6.0 , 7.6.1 , 7.6.2 sur Troncon 7.6 *)
(*                Ajout Boucle7                                              *)
(*                                                                           *)
(*---------------------------------------------------------------------------*)
(* Version 1.1.6  =====================                                      *)
(* Version 1.17 DU SERVEUR SCCS =====================                        *)
(* Date    :      08/04/2004                                                 *)
(* Auteur  :      M. Plywacz                                                 *)
(* Modification : transmission des variants  du troncon 1  sur boucle 7      *)
(*                modifs trans segments sur toncon 1 et 6                    *)
(*                                                                           *)
(*---------------------------------------------------------------------------*)
(* Version 1.1.7  =====================                                      *)
(* Version 1.18 DU SERVEUR SCCS =====================                        *)
(* Date    :      23/04/2004                                                 *)
(* Auteur  :      M. Plywacz                                                 *)
(* Modification : Ajustement marches types interstat AN-QN                   *)
(*                                                                           *)
(*---------------------------------------------------------------------------*)
(* Version 1.1.8  =====================                                      *)
(* Version 1.19 DU SERVEUR SCCS =====================                        *)
(* Date    :      04/05/2004                                                 *)
(* Auteur  :      M. Plywacz                                                 *)
(* Modification : Ajustement marches types interstat ANA-Ricardo             *)
(*                                                                           *)
(*---------------------------------------------------------------------------*)
(* Version 1.1.9  =====================                                      *)
(* Version 1.20 DU SERVEUR SCCS =====================                        *)
(* Date    :      02/05/2005                                                 *)
(* Auteur  :      M. Plywacz                                                 *)
(* Modification : Ajout condition  Sp2ANA au point d'arret "PtArrSigANA12A"  *)
(*                Ajout Entree Secu Sp2ANA sur CES 07-43                     *)
(*                                                                           *)
(*---------------------------------------------------------------------------*)
(* Version 1.2.0  =====================                                      *)
(* Version 1.21 DU SERVEUR SCCS =====================                        *)
(* Date    :      31/05/2005                                                 *)
(* Auteur  :      M. Plywacz                                                 *)
(* Modification : modif equation du point d'arret "PtArrSigANA12A"           *)
(*                                                                           *)

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
		       Boucle1, Boucle2, Boucle3,  Boucle4, Boucle5, Boucle6, Boucle7,
		       CarteCes1,  CarteCes2,  CarteCes3,  CarteCes4,  CarteCes5,
                   CarteCes6,
		       Intersecteur1, Intersecteur2,

		       Ampli11, Ampli12, Ampli13, Ampli14, Ampli15, Ampli16, Ampli17,
		       Ampli18, Ampli19, Ampli1A,
                   Ampli1B,
	               Ampli21, Ampli22, Ampli23, Ampli24,
	               Ampli31, Ampli32, Ampli33, Ampli34, Ampli35, Ampli36, Ampli37,
 	               Ampli41, Ampli42, Ampli43, Ampli44, Ampli45, Ampli46, Ampli47,
 		       Ampli51, Ampli52, Ampli53, Ampli54, Ampli55, Ampli56, Ampli57,
 		       Ampli58,          Ampli5A,
 		       Ampli61, Ampli62, Ampli63, Ampli64, Ampli65, Ampli66, Ampli67,
                   

   (* procedures *)
		       ConfigurerBoucle,
		       ConfigurerIntsecteur,
		       ConfigurerCES,
		       ConfigurerAmpli;

FROM BibTsr      IMPORT
   (* variables *)
		       Tronc0, Tronc1, Tronc2, Tronc3, Tronc4, Tronc5, Tronc6,  (* utilises *)
		       Tronc7, Tronc8, Tronc9, (* inutilises *)
		       Tronc10, Tronc11, Tronc12, Tronc13, Tronc14, Tronc15, (* inutilises *)
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

    L0501  = 1024*01; (* numero Secteur aval voie impaire decale de 2**10 *)

    L0508  = 1024*08; (* numero Secteur adja voie impaire decale de 2**10 *)

    L0212  = 1024*12; (* numero Secteur amont voie impaire decale de 2**10 *)

    L0507  = 1024*07; (* numero Secteur local decale de 2**10 *)

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
    noBouclebaq = 00;
    noBoucleheb = 01;
    noBouclequi = 02;
    noBoucle1 = 03;
    noBoucle2 = 04;
    noBoucle3 = 05;
    noBoucle4 = 06;
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
(*    CDV + signaux + aiguilles + iti                                       *)

   SigANA06,       (* entree  1, soit entree 0 de CES 02  *)
   SigANA10,       (* entree  2, soit entree 1 de CES 02  *)
   SigANA12Akv,    (* entree  3, soit entree 2 de CES 02  *)
   SigANA12B,      (* entree  4, soit entree 3 de CES 02  *)
   SigANA24kv,     (* entree  5, soit entree 4 de CES 02  *)
   SigANA24kj,     (* entree  6, soit entree 5 de CES 02  *)
   SigANA22kj,     (* entree  7, soit entree 6 de CES 02  *)
   SigANA20A,      (* entree  8, soit entree 7 de CES 02  *)

   SigANA42A,      (* entree  9, soit entree 0 de CES 03  *)
   SigANA42B,      (* entree 10, soit entree 1 de CES 03  *)

   SigANA08kv,     (* entree 15, soit entree 6 de CES 03  *)
   SigANA08kj,     (* entree 16, soit entree 7 de CES 03  *)

   SigANA12Akj,    (* entree 17, soit entree 0 de CES 04  *)
   SigANA22kv,     (* entree 18, soit entree 1 de CES 04  *)

   CdvANA12,       (* entree 19, soit entree 2 de CES 04  *)
   CdvANA26,       (* entree 20, soit entree 3 de CES 04  *)
(*pas utilisee*)   (* entree 21, soit entree 4 de CES 04  *)
   CdvANA06,       (* entree 22, soit entree 5 de CES 04  *)
   CdvANA22,       (* entree 23, soit entree 6 de CES 04  *)
   CdvANA21,       (* entree 24, soit entree 7 de CES 04  *)

   SigANA26,       (* entree 25, soit entree 0 de CES 05  *)
   CdvPLA11,       (* entree 26, soit entree 1 de CES 05  *)
   CdvPLA12,       (* entree 27, soit entree 2 de CES 05  *)
   CdvPLA13,       (* entree 28, soit entree 3 de CES 05  *)
   CdvPLA23,       (* entree 29, soit entree 4 de CES 05  *)
   CdvPLA22,       (* entree 30, soit entree 5 de CES 05  *)
   CdvPLA21,       (* entree 31, soit entree 6 de CES 05  *)

   SigANA20Bkv,    (* entree 36, soit entree 3 de CES 06  *)
   SigANA20Bkj,    (* entree 37, soit entree 4 de CES 06  *)
   SigANA18,       (* entree 39, soit entree 6 de CES 06  *)
   iti20_42,       (* entree 38, soit entree 5 de CES 06  *)
   Sp1ANA,         (* entree 40, soit entree 7 de CES 06  *)

   CdvANA13,       (* entree 41, soit entree 0 de CES 07  *)
   CdvANA23,       (* entree 42, soit entree 1 de CES 07  *)
   Sp2ANA          (* entree 43, soit entree 2 de CES 07  *)

             : BoolD;

    AigANA10_41,       (* entrees 11 & 12, soit entrees 2 & 3 de CES 03 *) 
    AigANA11_21,       (* entrees 13 & 14, soit entrees 4 & 5 de CES 03 *) 
    AigANA09_19,       (* entrees 34 & 35, soit entrees 1 & 2 de CES 06 *) 
    AigANA13_23        (* entrees 32 & 33, soit entrees 7  de CES 05 & 0 de CES 06 *) 
             : TyAig; 

(* variants lies a une commutation d'aiguille *)
    com1troncon1,
    com2troncon1 : BoolD; 

    com1troncon3,
    com2troncon3,
    com3troncon3,
    com4troncon3,
    com5troncon3,
    com6troncon3 : BoolD; 
    
    
(***********************************************************)
(* Variables ne correspondant pas a une entree securitaire *)
(* Points d'arret *)

    PtArrCdvANA06,
    PtArrSigANA06,
    PtArrSigANA08,

    PtArrSigANA42A,
    PtArrSigANA42B,

    PtArrSigANA10,
    PtArrCdvANA12,
    PtArrSigANA12A,
    PtArrSigANA12B,

    PtArrCdvPLA11,
    PtArrCdvPLA12,
    PtArrCdvPLA13,
    PtArrCdvPLA23,
    PtArrCdvPLA22,
    PtArrCdvPLA21,

    PtArrCdvANA26,

    PtArrSigANA26,
    PtArrSigANA24,
    PtArrCdvANA22,
    PtArrSigANA22,

    PtArrSigANA20A,
    PtArrSigANA20B,
    PtArrSigANA18,
    PtArrSpeANA18F           : BoolD;

 (* Recu par intersecteurs *)

    PtAntCdvCUM22,
    PtAntCdvCUM23,
    PtAntCdvCUM24,
    PtAntSigHEB44B,
    PtAntCdvBEL11,
    PtAntCdvBEL12            : BoolD;

 (* Tiv Com *)

    TivComSigANA22,
    TivComSigANA20B          : BoolD;


(***********************************************************)
(* Copie des entrees dans des variables fonctionnelles pour la regulation   *)
 CdvANA12Fonc,
 CdvANA22Fonc,
 CdvPLA12Fonc,
 CdvPLA22Fonc           : BOOLEAN;

(** Voie d'emission SOL-TRAIN : deux sens confondus**)
    te11s07t01,
    te15s07t07,
    te16s07t02,
    te21s07t03,
    te25s07t04,
    te31s07t05,
    te36s07t06     :TyEmissionTele;


(** Voie d'emission Inter-secteur deux voies confondues **)
    teL0501,
    teL0508,
    teL0212,
    teL05fi       :TyEmissionTele;

(** Voie de reception Inter-secteur deux voies confondues **)
    trL0501,
    trL0508,
    trL0212,
    trL05fi        :TyCaracEntSec;

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

(* CONFIGURATION DES ENTREES SECU AIGUILLES, *)
   EntreeAiguille(AigANA10_41, 11, 12); (* A gauche = Branche Normale *) 
   EntreeAiguille(AigANA11_21, 13, 14); (* A gauche = Branche Normale *)
   EntreeAiguille(AigANA13_23, 33, 32); (* A gauche = Branche Reverse *) 
   EntreeAiguille(AigANA09_19, 34, 35); (* A gauche = Branche Normale *)

(* Configuration des entrees secu *)
   ProcEntreeIntrins ( 1,   SigANA06    );
   ProcEntreeIntrins ( 2,   SigANA10    );
   ProcEntreeIntrins ( 3,   SigANA12Akv );
   ProcEntreeIntrins ( 4,   SigANA12B   );
   ProcEntreeIntrins ( 5,   SigANA24kv  );
   ProcEntreeIntrins ( 6,   SigANA24kj  );
   ProcEntreeIntrins ( 7,   SigANA22kj  );
   ProcEntreeIntrins ( 8,   SigANA20A   );
   ProcEntreeIntrins ( 9,   SigANA42A   );
   ProcEntreeIntrins (10,   SigANA42B   );
   ProcEntreeIntrins (15,   SigANA08kv  );
   ProcEntreeIntrins (16,   SigANA08kj  );
   ProcEntreeIntrins (17,   SigANA12Akj );
   ProcEntreeIntrins (18,   SigANA22kv  );
   ProcEntreeIntrins (19,   CdvANA12    );
   ProcEntreeIntrins (20,   CdvANA26    );
   ProcEntreeIntrins (22,   CdvANA06    );
   ProcEntreeIntrins (23,   CdvANA22    );
   ProcEntreeIntrins (24,   CdvANA21    );
   ProcEntreeIntrins (25,   SigANA26    );
   ProcEntreeIntrins (26,   CdvPLA11    );
   ProcEntreeIntrins (27,   CdvPLA12    );
   ProcEntreeIntrins (28,   CdvPLA13    );
   ProcEntreeIntrins (29,   CdvPLA23    );
   ProcEntreeIntrins (30,   CdvPLA22    );
   ProcEntreeIntrins (31,   CdvPLA21    );
   ProcEntreeIntrins (36,   SigANA20Bkv );
   ProcEntreeIntrins (37,   SigANA20Bkj );
   ProcEntreeIntrins (39,   SigANA18    );
   ProcEntreeIntrins (38,   iti20_42    );
   ProcEntreeIntrins (40,   Sp1ANA      );
   ProcEntreeIntrins (41,   CdvANA13    );
   ProcEntreeIntrins (42,   CdvANA23    );
   ProcEntreeIntrins (43,   Sp2ANA      );


(* CONFIGURATION POUR LA MAINTENANCE de la transmission continue *)
   ConfigurerBoucle(Boucle1, 1);
   ConfigurerBoucle(Boucle2, 2);
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
   ConfigurerAmpli(Ampli19, 1, 9, 194, 14, FALSE);
   ConfigurerAmpli(Ampli1A, 1, 10, 195, 14, TRUE);

   ConfigurerAmpli(Ampli1B, 7, 11, 196, 15, FALSE);

   ConfigurerAmpli(Ampli21, 2, 1, 199, 16, FALSE);
   ConfigurerAmpli(Ampli22, 2, 2, 200, 17, FALSE);
   ConfigurerAmpli(Ampli23, 2, 3, 201, 17, FALSE);
   ConfigurerAmpli(Ampli24, 2, 4, 202, 17, TRUE);

   ConfigurerAmpli(Ampli31, 3, 1, 206, 21, FALSE);
   ConfigurerAmpli(Ampli32, 3, 2, 207, 22, FALSE);
   ConfigurerAmpli(Ampli33, 3, 3, 208, 22, FALSE);
   ConfigurerAmpli(Ampli34, 3, 4, 209, 22, TRUE);
   ConfigurerAmpli(Ampli35, 3, 5, 210, 23, FALSE);
   ConfigurerAmpli(Ampli36, 3, 6, 211, 23, FALSE);
   ConfigurerAmpli(Ampli37, 3, 7, 212, 23, TRUE);

   ConfigurerAmpli(Ampli41, 4, 1, 216, 25, FALSE);
   ConfigurerAmpli(Ampli42, 4, 2, 217, 26, FALSE);
   ConfigurerAmpli(Ampli43, 4, 3, 218, 26, FALSE);
   ConfigurerAmpli(Ampli44, 4, 4, 219, 26, TRUE);
   ConfigurerAmpli(Ampli45, 4, 5, 220, 27, FALSE);
   ConfigurerAmpli(Ampli46, 4, 6, 221, 27, FALSE);
   ConfigurerAmpli(Ampli47, 4, 7, 222, 27, TRUE);

   ConfigurerAmpli(Ampli51, 5, 1, 223, 31, FALSE);
   ConfigurerAmpli(Ampli52, 5, 2, 256, 32, FALSE);
   ConfigurerAmpli(Ampli53, 5, 3, 257, 32, FALSE);
   ConfigurerAmpli(Ampli54, 5, 4, 258, 32, TRUE);
   ConfigurerAmpli(Ampli55, 5, 5, 259, 33, FALSE);
   ConfigurerAmpli(Ampli56, 5, 6, 260, 33, FALSE);
   ConfigurerAmpli(Ampli57, 5, 7, 261, 33, TRUE);
   ConfigurerAmpli(Ampli58, 5, 8, 262, 34, FALSE);
   ConfigurerAmpli(Ampli5A, 5, 10, 264, 34, TRUE);

   ConfigurerAmpli(Ampli61, 6, 1, 268, 36, FALSE);
   ConfigurerAmpli(Ampli62, 6, 2, 269, 37, FALSE);
   ConfigurerAmpli(Ampli63, 6, 3, 270, 37, FALSE);
   ConfigurerAmpli(Ampli64, 6, 4, 271, 37, TRUE);
   ConfigurerAmpli(Ampli65, 6, 5, 272, 38, FALSE);
   ConfigurerAmpli(Ampli66, 6, 6, 273, 38, FALSE);
   ConfigurerAmpli(Ampli67, 6, 7, 274, 38, TRUE);

 
(** cartes CES **)
   ConfigurerCES(CarteCes1, 01);
   ConfigurerCES(CarteCes2, 02);
   ConfigurerCES(CarteCes3, 03);
   ConfigurerCES(CarteCes4, 04);
   ConfigurerCES(CarteCes5, 05);
   ConfigurerCES(CarteCes6, 06);

(** Liaisons Inter-Secteur **)
   ConfigurerIntsecteur(Intersecteur1, 01, trL0501, trL0212);
   ConfigurerIntsecteur(Intersecteur2, 02, trL0508, trL05fi);


(* Initialisations des variables ne correspondant pas a des entrees secu *)

(* Affectation a l'etat restrictif des variants commutes *)
   AffectBoolD(BoolRestrictif, com1troncon1) ;
   AffectBoolD(BoolRestrictif, com2troncon1) ;

   AffectBoolD(BoolRestrictif, com1troncon3) ;
   AffectBoolD(BoolRestrictif, com2troncon3) ;
   AffectBoolD(BoolRestrictif, com3troncon3) ;
   AffectBoolD(BoolRestrictif, com4troncon3) ;
   AffectBoolD(BoolRestrictif, com5troncon3) ;
   AffectBoolD(BoolRestrictif, com6troncon3) ;
   
(* Point d'arret *)
   AffectBoolD( BoolRestrictif, PtArrCdvANA06   );
   AffectBoolD( BoolRestrictif, PtArrSigANA06   );
   AffectBoolD( BoolRestrictif, PtArrSigANA08   );

   AffectBoolD( BoolRestrictif, PtArrSigANA42A  );
   AffectBoolD( BoolRestrictif, PtArrSigANA42B  );

   AffectBoolD( BoolRestrictif, PtArrSigANA10   );
   AffectBoolD( BoolRestrictif, PtArrCdvANA12   );

   AffectBoolD( BoolRestrictif, PtArrSigANA12A  );
   AffectBoolD( BoolRestrictif, PtArrSigANA12B  );

   AffectBoolD( BoolRestrictif, PtArrCdvPLA11   );
   AffectBoolD( BoolRestrictif, PtArrCdvPLA12   );
   AffectBoolD( BoolRestrictif, PtArrCdvPLA13   );
   AffectBoolD( BoolRestrictif, PtArrCdvPLA23   );
   AffectBoolD( BoolRestrictif, PtArrCdvPLA22   );
   AffectBoolD( BoolRestrictif, PtArrCdvPLA21   );

   AffectBoolD( BoolRestrictif, PtArrCdvANA26   );

   AffectBoolD( BoolRestrictif, PtArrSigANA26   );
   AffectBoolD( BoolRestrictif, PtArrSigANA24   );
   AffectBoolD( BoolRestrictif, PtArrCdvANA22   );

   AffectBoolD( BoolRestrictif, PtArrSigANA22   );

   AffectBoolD( BoolRestrictif, PtArrSigANA20A  );
   AffectBoolD( BoolRestrictif, PtArrSigANA20B  );
   AffectBoolD( BoolRestrictif, PtArrSigANA18   );
   AffectBoolD( BoolRestrictif, PtArrSpeANA18F  );



 (* Recu par intersecteurs *)
   AffectBoolD( BoolRestrictif, PtAntCdvCUM22   );
   AffectBoolD( BoolRestrictif, PtAntCdvCUM23   );
   AffectBoolD( BoolRestrictif, PtAntCdvCUM24   );
   AffectBoolD( BoolRestrictif, PtAntSigHEB44B  );
   AffectBoolD( BoolRestrictif, PtAntCdvBEL11   );
   AffectBoolD( BoolRestrictif, PtAntCdvBEL12   );

 (* Tiv Com *)
   AffectBoolD( BoolRestrictif, TivComSigANA22  );
   AffectBoolD( BoolRestrictif, TivComSigANA20B );


(* Regulation *)
 CdvANA12Fonc := FALSE;
 CdvANA22Fonc := FALSE;
 CdvPLA12Fonc := FALSE;
 CdvPLA22Fonc := FALSE;

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

   ConfigEmisTeleSolTrain ( te11s07t01,
			    noBoucle1,
			    BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te16s07t02,
			    noBoucle2,
			    BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te21s07t03,
			    noBoucle3,
			    BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te25s07t04,
			    noBoucle4,
			    BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te31s07t05,
			    noBoucle5,
			    BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);


   ConfigEmisTeleSolTrain ( te36s07t06,
			    noBoucle6,
			    BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);


   ConfigEmisTeleSolTrain ( te15s07t07,
			    noBoucle7,
			    BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

(* CONFIGURATION POUR LA REGULATION *)

 ConfigQuai(65, 64, CdvANA12Fonc, te11s07t01, 0, 4,11,10, 6, 13, 14, 15);
 ConfigQuai(65, 69, CdvANA22Fonc, te25s07t04, 0, 9,11, 5,10, 13, 14, 15);

 ConfigQuai(64, 74, CdvPLA12Fonc, te16s07t02, 0,11, 5,10, 6, 13, 14, 15);
 ConfigQuai(64, 79, CdvPLA22Fonc, te21s07t03, 0,11,10, 6, 7, 13, 14, 15);

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

(* variants  troncon 1 voie 1 sens impair = boucle 1 *)
   ProcEmisSolTrain( te11s07t01.EmissionSensUp, (2*noBoucle1),
		     LigneL05+ L0507+ TRONC*01,

 		  PtArrSigANA06,
 		  BoolRestrictif, (* AspectCroix *)
 		  PtArrSigANA08,
 		  BoolRestrictif, (* AspectCroix *)
		  AigANA10_41.PosNormaleFiltree,  (* TIVCOM *)
		  AigANA10_41.PosReverseFiltree,
		  AigANA10_41.PosNormaleFiltree,		  
		  PtArrSigANA10,
		  BoolRestrictif, (* AspectCroix *)
                  PtArrCdvANA12,
 		  PtArrSigANA12A,
 		  BoolRestrictif, (* AspectCroix *)
		  AigANA13_23.PosNormaleFiltree,  (* TIVCOM *)
		  AigANA13_23.PosReverseFiltree,
		  AigANA13_23.PosNormaleFiltree,
 		  PtArrSigANA42B,
 		  BoolRestrictif, (* AspectCroix *)
(* Variants Anticipes *)
 		  com1troncon1,
 		  com2troncon1,
 		  PtAntSigHEB44B,
 		  BoolRestrictif, (* AspectCroix *)
		  BoolRestrictif,
		  BoolPermissif,
		  BaseSorVar);

(*		  PtArrSigANA42B,
		  BoolRestrictif,  (* AspectCroix *)
 		  PtAntSigHEB44B,
 		  BoolRestrictif, (* AspectCroix *)
*)


(* variants  troncon 2 voie 1 sens impair *)
   ProcEmisSolTrain( te16s07t02.EmissionSensUp, (2*noBoucle2),
		     LigneL05+ L0507+ TRONC*02,

		  PtArrCdvPLA11,
		  PtArrCdvPLA12,
		  PtArrCdvPLA13,
		  PtAntCdvBEL11,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,		  
		  BoolRestrictif,
(* Variants Anticipes *)
		  PtAntCdvBEL12,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
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


(* variants du  troncon 3 voie 2 sens pair *)
   ProcEmisSolTrain( te21s07t03.EmissionSensUp, (2*noBoucle3),
		     LigneL05+ L0507+ TRONC*03,

		  PtArrCdvPLA22,
		  PtArrCdvPLA21,
		  PtArrCdvANA26,
		  PtArrSigANA26,
		  BoolRestrictif,  (* AspectCroix *)
		  PtArrSigANA24,
		  BoolRestrictif,  (* AspectCroix *)
		  AigANA13_23.PosNormaleFiltree,  (* TIVCOM *)
		  AigANA13_23.PosReverseFiltree,
		  AigANA13_23.PosNormaleFiltree,
		  PtArrCdvANA22,
(* Variants Anticipes *)
 		  com1troncon3,
 		  com2troncon3,
 		  com3troncon3,
		  com4troncon3,
		  com5troncon3,
		  com6troncon3,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolPermissif,
		  BaseSorVar + 60);


(* variants du  troncon 4 voie 2 sens pair *)
   ProcEmisSolTrain( te25s07t04.EmissionSensUp, (2*noBoucle4),
		     LigneL05+ L0507+ TRONC*04,

		  PtArrSigANA22,
		  BoolRestrictif,  (* AspectCroix *)
		  TivComSigANA22,  (* TIVCOM *)
		  PtArrSigANA20B,
		  BoolRestrictif,  (* AspectCroix *)
		  TivComSigANA20B, (* TIVCOM *)
		  PtArrSpeANA18F,
		  PtAntCdvCUM22,
(* Variants Anticipes *)
		  PtAntCdvCUM23,
		  PtAntCdvCUM24,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
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



(* variants du troncon 5 voie 1+E sens pair *)
   ProcEmisSolTrain( te31s07t05.EmissionSensUp, (2*noBoucle5),
		     LigneL05+ L0507+ TRONC*05,

		  PtArrSigANA42A,
		  BoolRestrictif,  (* AspectCroix *)
		  AigANA09_19.PosReverseFiltree,
		  AigANA09_19.PosNormaleFiltree,
		  BoolRestrictif,  (* rouge fixe *)
		  BoolRestrictif,  (* AspectCroix *)
		  PtArrSigANA12B,
		  BoolRestrictif,  (* AspectCroix *)
(* Variants Anticipes *)
		  PtArrSigANA20B,
		  BoolRestrictif,  (* AspectCroix *)
		  PtArrSpeANA18F,
		  BoolRestrictif,
		  BoolRestrictif,		  
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



(* variants du troncon 6 voie 2  sens impair *)
   ProcEmisSolTrain( te36s07t06.EmissionSensUp, (2*noBoucle6),
		     LigneL05+ L0507+ TRONC*06,

		  PtArrSigANA18,
		  BoolRestrictif,  (* AspectCroix *)
		  PtArrSigANA20A,
		  BoolRestrictif,  (* AspectCroix *)
		  AigANA11_21.PosReverseFiltree,
		  AigANA11_21.PosNormaleFiltree,
		  BoolRestrictif,  (* rouge fixe *)
		  BoolRestrictif,  (* AspectCroix *)
		  BoolRestrictif,  (* rouge fixe *)
		  BoolRestrictif,  (* AspectCroix *)
(* Variants Anticipes *)
		  AigANA10_41.PosReverseFiltree,
		  AigANA10_41.PosNormaleFiltree,
 		  PtArrSigANA42B,
 		  BoolRestrictif, (* AspectCroix *)
		  PtArrSigANA12A,
		  BoolRestrictif, (* AspectCroix *)
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolPermissif,
		  BaseSorVar + 150);


(* variants  troncon 1 emis sur  voie E sens impair *)
   ProcEmisSolTrain( te15s07t07.EmissionSensUp, (2*noBoucle7),
		     LigneL05+ L0507+ TRONC*01,

 		  PtArrSigANA06,
 		  BoolRestrictif, (* AspectCroix *)
 		  PtArrSigANA08,
 		  BoolRestrictif, (* AspectCroix *)
		  AigANA10_41.PosNormaleFiltree,  (* TIVCOM *)
		  AigANA10_41.PosReverseFiltree,
		  AigANA10_41.PosNormaleFiltree,		  
		  PtArrSigANA10,
		  BoolRestrictif, (* AspectCroix *)
                  PtArrCdvANA12,
 		  PtArrSigANA12A,
 		  BoolRestrictif, (* AspectCroix *)
		  AigANA13_23.PosNormaleFiltree,  (* TIVCOM *)
		  AigANA13_23.PosReverseFiltree,
		  AigANA13_23.PosNormaleFiltree,
 		  PtArrSigANA42B,
 		  BoolRestrictif, (* AspectCroix *)
(* Variants Anticipes *)
 		  com1troncon1,
 		  com2troncon1,
 		  PtAntSigHEB44B,
 		  BoolRestrictif, (* AspectCroix *)
		  BoolRestrictif,
		  BoolPermissif,
		  BaseSorVar + 180);



(* reception du secteur 1 aval *)
   ProcReceptInterSecteur(trL0501, noBouclebaq, LigneL05+ L0501+ TRONC*05,

		  PtAntCdvBEL11,
		  PtAntCdvBEL12,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
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

(* reception du secteur 12 amont *)
   ProcReceptInterSecteur(trL0212, noBoucleheb, LigneL02+ L0212+ TRONC*03,

		  PtAntSigHEB44B,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
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


(* reception du secteur 8 adja *)
   ProcReceptInterSecteur(trL0508, noBouclequi, LigneL05+ L0508+ TRONC*02,

		  PtAntCdvCUM22,
		  PtAntCdvCUM23,
		  PtAntCdvCUM24,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BaseEntVar + 10,
		  V1,
		  V2,
		  V3,
		  V4,
		  V5,
		  V6,
		  BaseEntVar + 11);



(* emission vers le secteur 1 aval *)
   ProcEmisInterSecteur (teL0501, noBouclebaq, LigneL05+ L0507+ TRONC*03,
			noBouclebaq,
		  PtArrCdvPLA23,
		  PtArrCdvPLA22,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
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

(* emission vers le secteur 12 amont *)
   ProcEmisInterSecteur (teL0212, noBoucleheb, LigneL05+ L0507+ TRONC*05,
			noBoucleheb,
		  PtArrSigANA42A,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
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

(* emission vers le secteur 8 adja *)
   ProcEmisInterSecteur (teL0508, noBouclequi, LigneL05+ L0507+ TRONC*01,
			noBouclequi,
		  PtArrCdvANA06,
		  PtArrSigANA06,
		  PtArrSigANA08,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
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

(* CONFIGURATION DES EMISSIONS DES INVARIANTS SECURITAIRES  ******************)

(* Tous les sens doivent etre a SensUp ; il n'y a pas de commutation *)

 (** Emission invariants vers secteur aval L0501 **)
   EmettreSegm(LigneL05+ L0507+ TRONC*03+ SEGM*00, noBouclebaq, SensUp);
   EmettreSegm(LigneL05+ L0507+ TRONC*03+ SEGM*01, noBouclebaq, SensUp);

 (** Emission invariants vers secteur amont L0212 **)
   EmettreSegm(LigneL05+ L0507+ TRONC*05+ SEGM*00, noBoucleheb, SensUp);

 (** Emission invariants vers secteur adja L0508 **)
   EmettreSegm(LigneL05+ L0507+ TRONC*01+ SEGM*00, noBouclequi, SensUp);
   EmettreSegm(LigneL05+ L0507+ TRONC*01+ SEGM*01, noBouclequi, SensUp);
   EmettreSegm(LigneL05+ L0507+ TRONC*01+ SEGM*02, noBouclequi, SensUp);
   EmettreSegm(LigneL05+ L0507+ TRONC*02+ SEGM*00, noBouclequi, SensUp);
   
 (** Troncon 1 **)
   EmettreSegm(LigneL05+ L0507+ TRONC*01+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL05+ L0507+ TRONC*01+ SEGM*01, noBoucle1, SensUp);
   EmettreSegm(LigneL05+ L0507+ TRONC*01+ SEGM*02, noBoucle1, SensUp);
   EmettreSegm(LigneL05+ L0507+ TRONC*02+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL05+ L0507+ TRONC*02+ SEGM*01, noBoucle1, SensUp);
   EmettreSegm(LigneL05+ L0507+ TRONC*05+ SEGM*01, noBoucle1, SensUp);
   EmettreSegm(LigneL05+ L0507+ TRONC*06+ SEGM*02, noBoucle1, SensUp);
   EmettreSegm(LigneL05+ L0507+ TRONC*01+ SEGM*03, noBoucle1, SensUp);


 (** Troncon 2 **)
   EmettreSegm(LigneL05+ L0507+ TRONC*02+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL05+ L0507+ TRONC*02+ SEGM*01, noBoucle2, SensUp);
   EmettreSegm(LigneL05+ L0501+ TRONC*05+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL05+ L0501+ TRONC*05+ SEGM*01, noBoucle2, SensUp);

 (** Troncon 3 **)
   EmettreSegm(LigneL05+ L0507+ TRONC*03+ SEGM*00, noBoucle3, SensUp);  
   EmettreSegm(LigneL05+ L0507+ TRONC*03+ SEGM*01, noBoucle3, SensUp);  
   EmettreSegm(LigneL05+ L0507+ TRONC*04+ SEGM*00, noBoucle3, SensUp); 
   EmettreSegm(LigneL05+ L0507+ TRONC*04+ SEGM*01, noBoucle3, SensUp); 
   EmettreSegm(LigneL05+ L0507+ TRONC*05+ SEGM*01, noBoucle3, SensUp);  

 (** Troncon 4 **)
   EmettreSegm(LigneL05+ L0507+ TRONC*04+ SEGM*01, noBoucle4, SensUp); 
   EmettreSegm(LigneL05+ L0507+ TRONC*06+ SEGM*00, noBoucle4, SensUp); 
   EmettreSegm(LigneL05+ L0507+ TRONC*06+ SEGM*01, noBoucle4, SensUp); 
   EmettreSegm(LigneL05+ L0508+ TRONC*03+ SEGM*00, noBoucle4, SensUp); 
   EmettreSegm(LigneL05+ L0508+ TRONC*03+ SEGM*01, noBoucle4, SensUp); 

 (** Troncon 5 **)
   EmettreSegm(LigneL05+ L0507+ TRONC*05+ SEGM*02, noBoucle5, SensUp); 
   EmettreSegm(LigneL05+ L0507+ TRONC*04+ SEGM*00, noBoucle5, SensUp);
   EmettreSegm(LigneL05+ L0507+ TRONC*04+ SEGM*01, noBoucle5, SensUp);
   EmettreSegm(LigneL05+ L0507+ TRONC*01+ SEGM*00, noBoucle5, SensUp); 
   EmettreSegm(LigneL05+ L0507+ TRONC*01+ SEGM*02, noBoucle5, SensUp); 

 (** Troncon 6 **)
   EmettreSegm(LigneL05+ L0507+ TRONC*03+ SEGM*01, noBoucle6, SensUp);
   EmettreSegm(LigneL05+ L0507+ TRONC*04+ SEGM*00, noBoucle6, SensUp);
   EmettreSegm(LigneL05+ L0507+ TRONC*01+ SEGM*01, noBoucle6, SensUp);
   EmettreSegm(LigneL05+ L0507+ TRONC*01+ SEGM*02, noBoucle6, SensUp);
   EmettreSegm(LigneL05+ L0507+ TRONC*01+ SEGM*03, noBoucle6, SensUp);

 (** Troncon 1 **)
   EmettreSegm(LigneL02+ L0212+ TRONC*03+ SEGM*00, noBoucle7, SensUp);
   EmettreSegm(LigneL02+ L0212+ TRONC*03+ SEGM*01, noBoucle7, SensUp);
   EmettreSegm(LigneL02+ L0212+ TRONC*04+ SEGM*00, noBoucle7, SensUp);


(* CONFIGURATION DES TRONCONS TSR *************************************)

   ConfigurerTroncon(Tronc0, LigneL05 + L0507 + TRONC*01, 1,1,1,1);  (* troncon 7-1 *)
   ConfigurerTroncon(Tronc1, LigneL05 + L0507 + TRONC*02, 1,1,1,1);  (* troncon 7-2 *)
   ConfigurerTroncon(Tronc2, LigneL05 + L0507 + TRONC*03, 1,1,1,1);  (* troncon 7-3 *)
   ConfigurerTroncon(Tronc3, LigneL05 + L0507 + TRONC*04, 1,1,1,1);  (* troncon 7-4 *)
   ConfigurerTroncon(Tronc4, LigneL05 + L0507 + TRONC*05, 1,1,1,1);  (* troncon 7-5 *)
   ConfigurerTroncon(Tronc5, LigneL05 + L0507 + TRONC*06, 1,1,1,1);  (* troncon 7-6 *)
 (*  ConfigurerTroncon(Tronc6, LigneL05 + L0507 + TRONC*07, 1,1,1,1); *) (* troncon 7-7 *)

(* EMISSION DES TSR SUR ***********************************************)

 (** Emission des TSR vers le secteur aval L0501 **)
   EmettreTronc(LigneL05+ L0507+ TRONC*03, noBouclebaq, SensUp);

(** Emission des TSR vers le secteur amont L0212 **)
   EmettreTronc(LigneL05+ L0507+ TRONC*05, noBoucleheb, SensUp);

 (** Emission des TSR vers le secteur adja L0508 **)
   EmettreTronc(LigneL05+ L0507+ TRONC*01, noBouclequi, SensUp);
   EmettreTronc(LigneL05+ L0507+ TRONC*02, noBouclequi, SensUp);

 (** Emission des TSR sur les troncons du secteur courant **)
   EmettreTronc(LigneL05+ L0507+ TRONC*01, noBoucle1, SensUp); (* troncon 7-1 *)
   EmettreTronc(LigneL05+ L0507+ TRONC*05, noBoucle1, SensUp);
   EmettreTronc(LigneL05+ L0507+ TRONC*02, noBoucle1, SensUp);
   EmettreTronc(LigneL05+ L0507+ TRONC*06, noBoucle1, SensUp);
 (*  EmettreTronc(LigneL05+ L0507+ TRONC*07, noBoucle1, SensUp); *)

   EmettreTronc(LigneL05+ L0507+ TRONC*02, noBoucle2, SensUp); (* troncon 7-2 *)
   EmettreTronc(LigneL05+ L0501+ TRONC*05, noBoucle2, SensUp);

   EmettreTronc(LigneL05+ L0507+ TRONC*03, noBoucle3, SensUp); (* troncon 7-3 *)
   EmettreTronc(LigneL05+ L0507+ TRONC*04, noBoucle3, SensUp);
   EmettreTronc(LigneL05+ L0507+ TRONC*05, noBoucle3, SensUp);

   EmettreTronc(LigneL05+ L0507+ TRONC*04, noBoucle4, SensUp); (* troncon 7-4 *)
   EmettreTronc(LigneL05+ L0507+ TRONC*06, noBoucle4, SensUp);
   EmettreTronc(LigneL05+ L0508+ TRONC*03, noBoucle4, SensUp);

   EmettreTronc(LigneL05+ L0507+ TRONC*05, noBoucle5, SensUp); (* troncon 7-5 *)
   EmettreTronc(LigneL05+ L0507+ TRONC*04, noBoucle5, SensUp);
   EmettreTronc(LigneL05+ L0507+ TRONC*01, noBoucle5, SensUp);

   EmettreTronc(LigneL05+ L0507+ TRONC*06, noBoucle6, SensUp); (* troncon 7-6 *)
   EmettreTronc(LigneL05+ L0507+ TRONC*04, noBoucle6, SensUp);
   EmettreTronc(LigneL05+ L0507+ TRONC*03, noBoucle6, SensUp);
   EmettreTronc(LigneL05+ L0507+ TRONC*01, noBoucle6, SensUp);
 (*  EmettreTronc(LigneL05+ L0507+ TRONC*07, noBoucle6, SensUp); *)

 (*  EmettreTronc(LigneL05+ L0507+ TRONC*07, noBoucle7, SensUp); *) (* troncon 1-7 *)
   EmettreTronc(LigneL02+ L0212+ TRONC*03, noBoucle7, SensUp);
   EmettreTronc(LigneL02+ L0212+ TRONC*04, noBoucle7, SensUp);

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

   StockAdres( ADR(SigANA06    ));
   StockAdres( ADR(SigANA10    ));
   StockAdres( ADR(SigANA12Akv ));
   StockAdres( ADR(SigANA12B   ));
   StockAdres( ADR(SigANA24kv  ));
   StockAdres( ADR(SigANA24kj  ));
   StockAdres( ADR(SigANA22kv  ));
   StockAdres( ADR(SigANA20A   ));

   StockAdres( ADR(SigANA42A   ));
   StockAdres( ADR(SigANA42B   ));

   StockAdres( ADR(SigANA08kv  ));
   StockAdres( ADR(SigANA08kj  ));

   StockAdres( ADR(SigANA12Akj ));
   StockAdres( ADR(SigANA22kj  ));

   StockAdres( ADR(CdvANA12    ));
   StockAdres( ADR(CdvANA26    ));
   StockAdres( ADR(CdvANA06    ));
   StockAdres( ADR(CdvANA22    ));
   StockAdres( ADR(CdvANA21    ));

   StockAdres( ADR(SigANA26    ));
   StockAdres( ADR(CdvPLA11    ));
   StockAdres( ADR(CdvPLA12    ));
   StockAdres( ADR(CdvPLA13    ));
   StockAdres( ADR(CdvPLA23    ));
   StockAdres( ADR(CdvPLA22    ));
   StockAdres( ADR(CdvPLA21    ));

   StockAdres( ADR(SigANA20Bkv ));
   StockAdres( ADR(SigANA20Bkj ));
   StockAdres( ADR(SigANA18    ));
   StockAdres( ADR(iti20_42    ));
   StockAdres( ADR(Sp1ANA      ));
   StockAdres( ADR(CdvANA13    ));
   StockAdres( ADR(CdvANA23    ));
   StockAdres( ADR(Sp2ANA      ));

   StockAdres( ADR(AigANA10_41 )); 
   StockAdres( ADR(AigANA11_21 )); 
   StockAdres( ADR(AigANA09_19 )); 
   StockAdres( ADR(AigANA13_23 )); 

   StockAdres( ADR(com1troncon1));
   StockAdres( ADR(com2troncon1));

   StockAdres( ADR(com1troncon3));
   StockAdres( ADR(com2troncon3));
   StockAdres( ADR(com3troncon3));
   StockAdres( ADR(com4troncon3));
   StockAdres( ADR(com5troncon3));
   StockAdres( ADR(com6troncon3));


(* Points d'arret *)

   StockAdres( ADR( PtArrCdvANA06   ));
   StockAdres( ADR( PtArrSigANA06   ));
   StockAdres( ADR( PtArrSigANA08   ));

   StockAdres( ADR( PtArrSigANA42A  ));
   StockAdres( ADR( PtArrSigANA42B  ));

   StockAdres( ADR( PtArrSigANA10   ));
   StockAdres( ADR( PtArrCdvANA12   ));

   StockAdres( ADR( PtArrSigANA12A  ));
   StockAdres( ADR( PtArrSigANA12B  ));

   StockAdres( ADR( PtArrCdvPLA11   ));
   StockAdres( ADR( PtArrCdvPLA12   ));
   StockAdres( ADR( PtArrCdvPLA13   ));
   StockAdres( ADR( PtArrCdvPLA23   ));
   StockAdres( ADR( PtArrCdvPLA22   ));
   StockAdres( ADR( PtArrCdvPLA21   ));

   StockAdres( ADR( PtArrCdvANA26   ));

   StockAdres( ADR( PtArrSigANA26   ));
   StockAdres( ADR( PtArrSigANA24   ));
   StockAdres( ADR( PtArrCdvANA22   ));
   StockAdres( ADR( PtArrSigANA22   ));

   StockAdres( ADR( PtArrSigANA20A  ));
   StockAdres( ADR( PtArrSigANA20B  ));
   StockAdres( ADR( PtArrSigANA18   ));
   StockAdres( ADR( PtArrSpeANA18F  ));

   StockAdres( ADR( PtAntCdvCUM22   ));
   StockAdres( ADR( PtAntCdvCUM23   ));
   StockAdres( ADR( PtAntCdvCUM24   ));
   StockAdres( ADR( PtAntSigHEB44B  ));
   StockAdres( ADR( PtAntCdvBEL11   ));
   StockAdres( ADR( PtAntCdvBEL12   ));

   StockAdres( ADR( TivComSigANA22  ));
   StockAdres( ADR( TivComSigANA20B ));

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

(* Configuration des troncons non utilises *)

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
VAR BoolTr1, BoolTr2 : BoolLD;

BEGIN (* ExeSpecific *)

(* Affectation des "constantes" utilisees dans la construction des messages emis        *)
(* et recus sur les boucles de transmission continue et sur les liens intersecteur.     *)
(* Cette reaffectation est necessaire a chaque cycle pour la mise en securite.          *)
   AffectBoolC(Vrai, BoolPermissif)  ;
   AffectBoolC(Faux, BoolRestrictif) ;

 (* regulation *)
 CdvANA12Fonc := CdvANA12.F = Vrai.F;
 CdvANA22Fonc := CdvANA22.F = Vrai.F;
 CdvPLA12Fonc := CdvPLA12.F = Vrai.F;
 CdvPLA22Fonc := CdvPLA22.F = Vrai.F;




(**** FILTRAGE DES AIGUILLES **************************************************)

  FiltrerAiguille(AigANA09_19, BaseExeAig ) ;
  FiltrerAiguille(AigANA10_41, BaseExeAig + 2) ;
  FiltrerAiguille(AigANA11_21, BaseExeAig + 4) ;
  FiltrerAiguille(AigANA13_23, BaseExeAig + 6) ;


(**** DETERMINATION DES POINTS D'ARRET ****************************************)

   (*voie 1*)
   AffectBoolD( CdvANA06,    PtArrCdvANA06  );   
   AffectBoolD( SigANA06,    PtArrSigANA06  );
   AffectBoolD( SigANA10,    PtArrSigANA10  );

   OuDD( CdvANA23, AigANA13_23.PosNormaleFiltree, BoolTr1);
   EtDD( CdvANA12, CdvANA13,                      BoolTr2 );
   EtDD( BoolTr1 , BoolTr2 ,                PtArrCdvANA12 );

   AffectBoolD( SigANA12B,   PtArrSigANA12B );

   OuDD( SigANA08kv,  SigANA08kj,  PtArrSigANA08  );

   NonD( Sp2ANA,                   BoolTr1 );
   OuDD( SigANA12Akv, SigANA12Akj, BoolTr2 );
   EtDD( BoolTr1    , BoolTr2    , PtArrSigANA12A );

   AffectBoolD( CdvPLA11,    PtArrCdvPLA11  );
   AffectBoolD( CdvPLA12,    PtArrCdvPLA12  );
   AffectBoolD( CdvPLA13,    PtArrCdvPLA13  );

   (*voie E*)
   AffectBoolD( SigANA42A,   PtArrSigANA42A );
   AffectBoolD( SigANA42B,   PtArrSigANA42B );

   (*voie 2*)
   AffectBoolD( CdvPLA23,    PtArrCdvPLA23  );
   AffectBoolD( CdvPLA22,    PtArrCdvPLA22  );
   AffectBoolD( CdvPLA21,    PtArrCdvPLA21  );
   AffectBoolD( CdvANA26,    PtArrCdvANA26  );

   AffectBoolD( SigANA26,    PtArrSigANA26  );
   AffectBoolD( SigANA20A,   PtArrSigANA20A );
   AffectBoolD( SigANA18,    PtArrSigANA18  );

   OuDD( SigANA24kv,  SigANA24kj,  PtArrSigANA24  );

   OuDD( CdvANA21, AigANA11_21.PosReverseFiltree, BoolTr1);        
   EtDD( BoolTr1,   CdvANA22,            PtArrCdvANA22 );

   OuDD( SigANA22kv,  SigANA22kj,  PtArrSigANA22  );

   NonD( Sp1ANA,                   BoolTr1 );
   OuDD( SigANA20Bkv, SigANA20Bkj, BoolTr2 );
   EtDD( BoolTr1    , BoolTr2    , PtArrSigANA20B );

   NonD( iti20_42,       BoolTr1 );
   NonD( PtArrSigANA18,  BoolTr2 );
   EtDD( BoolTr1,        BoolTr2,  PtArrSpeANA18F );

(* Determine les TIV COM *)

   AffectBoolD (SigANA22kv,     TivComSigANA22);
   AffectBoolD (SigANA20Bkv,    TivComSigANA20B);


(*** lecture des entrees de regulation ***)
   LireEntreesRegul;

(* commutation des variants troncon 1 *)
(* en fonction de la position de l'aiguille 13_23 *)

IF Tvrai (AigANA13_23.PosNormaleFiltree) THEN
	AffectBoolD (PtArrCdvPLA11 , com1troncon1);
	AffectBoolD (PtArrCdvPLA12 , com2troncon1);
	FinBranche(1);  
   ELSE
	IF Tvrai (AigANA13_23.PosReverseFiltree) THEN
		AffectBoolD (BoolRestrictif, com1troncon1);
		AffectBoolD (BoolRestrictif, com2troncon1);
		FinBranche(2);
	ELSE 
	  AffectBoolD (BoolRestrictif, com1troncon1);
	  AffectBoolD (BoolRestrictif, com2troncon1);
	  FinBranche(3);
	END;
END;
FinArbre(BaseExeSpecific);

(* commutation des variants troncon 3 *)
(* en fonction de la position de l'aiguille 13_23 *)

IF Tvrai (AigANA13_23.PosNormaleFiltree) THEN
	AffectBoolD (PtArrSigANA22 ,  com1troncon3);
	AffectBoolD (BoolRestrictif,  com2troncon3);
	AffectBoolD (TivComSigANA22,  com3troncon3);
	AffectBoolD (PtArrSigANA20B,  com4troncon3);
	AffectBoolD (BoolRestrictif,  com5troncon3);
	AffectBoolD (TivComSigANA20B, com6troncon3);
	FinBranche(1);  
   ELSE
	IF Tvrai (AigANA13_23.PosReverseFiltree) THEN
		AffectBoolD (PtArrSigANA12B, com1troncon3);
		AffectBoolD (BoolRestrictif, com2troncon3);
		AffectBoolD (BoolRestrictif, com3troncon3);
		AffectBoolD (BoolRestrictif, com4troncon3);
		AffectBoolD (BoolRestrictif, com5troncon3);
		AffectBoolD (BoolRestrictif, com6troncon3);
		FinBranche(2);
	ELSE 
		AffectBoolD (BoolRestrictif, com1troncon3);
		AffectBoolD (BoolRestrictif, com2troncon3);
		AffectBoolD (BoolRestrictif, com3troncon3);
		AffectBoolD (BoolRestrictif, com4troncon3);
		AffectBoolD (BoolRestrictif, com5troncon3);
		AffectBoolD (BoolRestrictif, com6troncon3);
	        FinBranche(3);
	END;
END;
FinArbre(BaseExeSpecific + 1);

END ExeSpecific;
END Specific.

















