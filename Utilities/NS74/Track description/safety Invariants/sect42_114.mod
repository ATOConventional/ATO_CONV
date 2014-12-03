IMPLEMENTATION MODULE Specific;

(*$S- *)
(*$T- *)

(*****************************************************************************)
(*   SANTIAGO - Ligne 5 - Secteur 42                                         *)
(*  =============================                                            *)
(*                                                                           *)
(* Version  1.0.0  =====================                                     *)
(* Version  1.1 DU SERVEUR SCCS =====================                        *)
(* Date :          18/10/2009                                                *)
(* Auteur :        M. Plywacz                                                *)
(* Modification :  Version initiale                                          *)
(*---------------------------------------------------------------------------*)
(* Version  1.0.1  =====================                                     *)
(* Version  1.2 DU SERVEUR SCCS =====================                        *)
(* Date :          08/12/2009                                                *)
(* Auteur :        M. Plywacz                                                *)
(* Modification : Modif message reception variants intersecteur s41          *)
(*                Modif acquisition "EntreeAiguille( AigPUD13_23"            *)
(*                                                                           *)
(*---------------------------------------------------------------------------*)
(* Version  1.0.2  =====================                                     *)
(* Version  1.3 DU SERVEUR SCCS =====================                        *)
(* Date :          08/12/2009                                                *)
(* Auteur :        Ph. Hog                                                   *)
(* Modification : Modif message variants troncon 1 (ajout rouge fixe V2)     *)
(*                Point d'arret et entre Sig PUD11 devient SigPUD10          *)
(*                Modif "No de Voie d'emissions" + "ConfigEmisTeleSolTrain"  *)
(*                Phase 1, sigPUB24 permissif uniquement si JAUNE            *)
(*---------------------------------------------------------------------------*)
(* Version  1.0.3  =====================                                     *)
(* Version  1.4 DU SERVEUR SCCS =====================                        *)
(* Date :          12/12/2009                                                *)
(* Auteur :        Ph. Hog                                                   *)
(* Modification : Ajout rouge fixe sur la branche directe du segment 42.4.0  *)
(*---------------------------------------------------------------------------*)
(* Version  1.0.4  =====================                                     *)
(* Version  1.5 DU SERVEUR SCCS =====================                        *)
(* Date :          18/12/2009                                                *)
(* Auteur :        M. Plywacz                                                *)
(* Modification : Ajout TIVCOM dans troncon 42.1.1                           *)
(*                                                                           *)
(*---------------------------------------------------------------------------*)
(* Version  1.0.5  =====================                                     *)
(* Version  1.6 DU SERVEUR SCCS =====================                        *)
(* Date :          04/03/2010                                                *)
(* Auteur :        M. Plywacz                                                *)
(* Modification : Mise en place des marches types                            *)
(*---------------------------------------------------------------------------*)
(* Version  1.0.6  =====================                                     *)
(* Version  1.7 DU SERVEUR SCCS =====================                        *)
(* Date :          31/08/2010                                                *)
(* Auteur :        M. Plywacz                                                *)
(* Modification : Ajout les itis SPs de San Pablo                            *)
(*---------------------------------------------------------------------------*)
(* Version  1.0.7  =====================                                     *)
(* Version  1.8 DU SERVEUR SCCS =====================                        *)
(* Date :          31/09/2010                                                *)
(* Auteur :        M. Plywacz                                                *)
(* Modification : modif variants Troncon 42.4 +                              *)
(*---------------------------------------------------------------------------*)
(* Version  1.0.8  =====================                                     *)
(* Version  1.9 DU SERVEUR SCCS =====================                        *)
(* Date :          09/11/2010                                                *)
(* Auteur :        Ph. Hog                                                   *)
(* Modification : Retour aux equations provisoires des signaux de San Pablo. *)
(*                Ajout du signal 14 de San Pablo.                           *)
(*                Preparation pour la prise en compte du SP2.                *)
(*                Forcage au rouge des signaux 14 et 22 de San Pablo.        *)
(*---------------------------------------------------------------------------*)
(* Version  1.0.9  =====================                                     *)
(* Version  1.10 DU SERVEUR SCCS =====================                       *)
(* Date :          15/11/2010                                                *)
(* Auteur :        M. Plywacz                                                *)
(* Modification : inhibition Entrees Fonc DAMTC amplis parcours hors service *)
(*---------------------------------------------------------------------------*)
(* Version  1.1.0  =====================                                     *)
(* Version  1.11 DU SERVEUR SCCS =====================                       *)
(* Date :          03/12/2010                                                *)
(* Auteur :        M. Plywacz                                                *)
(* Modification : utilisation de nouveau des conditions normales des signaux *)
(*---------------------------------------------------------------------------*)
(* Version  1.1.1  =====================                                     *)
(* Version  1.11 DU SERVEUR SCCS =====================                       *)
(* Date :          07/03/2011                                                *)
(* Auteur :        M. Plywacz                                                *)
(* Modification : modifie voie 2 San Pablo et Pudahuel les conditions des    *)
(* PtArrSpeSPA22b et PtArrSpePUD22a +  PtArrSpeSPA12a et PtArrSpePUD12b      *)
(* Ajustement des marches type voies 1-2                                     *)
(*---------------------------------------------------------------------------*)
(* Version  1.1.1  =====================                                     *)
(* Version  1.11 DU SERVEUR SCCS =====================                       *)
(* Date :          25/03/2011                                                *)
(* Auteur :        M. Plywacz                                                *)
(* Modification : position rang variant "PtArrSpePUD22a" dans troncon 42.4   *)
(*---------------------------------------------------------------------------*)
(* Version  1.1.2  =====================                                     *)
(* Date :          28/06/2012                                                *)
(* Auteur :        JP. BEMMA                                                 *)
(* Modification :   Ajout d'un point d'arrêt PtArrSpeSPA14 tronçon 42.3      *)
(*                  pour le Sp2SPA                                           *)
(*                  suppression de la  variable PtAntCdvPRA11SP              *)
(*---------------------------------------------------------------------------*)
(* Version  1.1.4  =====================                                     *)
(* Date :          24/07/2012                                                *)
(* Auteur :        JP. BEMMA                                                 *)
(* Modification :   Modification sur le tronçon 42.3 : PtArrSpeSPA14 passe   *)
(*                  au rang 6 et Pa_cdv11 passe au rang 7                    *)
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
		       CarteCes1,  CarteCes2,  CarteCes3,  CarteCes4,  CarteCes5, CarteCes6,

		       Intersecteur1,

Ampli11, Ampli12, Ampli13, Ampli14, Ampli15, Ampli16, Ampli17, Ampli18, Ampli19, Ampli1A, 
Ampli1B, Ampli1C, Ampli1D,
Ampli21, Ampli22, Ampli23, Ampli24, Ampli25, Ampli26, Ampli27, Ampli28, Ampli29, Ampli2A,
Ampli31, Ampli32, Ampli33, Ampli34, Ampli35, Ampli36, Ampli37, Ampli38, Ampli39, Ampli3A,
Ampli41, Ampli42, Ampli43, Ampli44, Ampli45, Ampli46, Ampli47, Ampli48, Ampli49, Ampli4A, 
Ampli4B, Ampli4C, Ampli4D,

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

    L0541  = 1024*41; (* numero Secteur aval decale de 2**10 *)

    L0542  = 1024*42; (* numero Secteur local decale de 2**10 *)

    L0543  = 1024*43; (* numero Secteur amont decale de 2**10 *)


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
(* coucou *)
(** No de Voie d'emissions SOL-Train, d'emission/reception inter-secteur **)
    noBoucleBLA = 00;
    noBoucleLAS = 01;
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

  SigPUD10,      (* entree nr : 1, sur CES pos : 2, ent : ES 0 *)
  SigPUD12kv,    (* entree nr : 2, sur CES pos : 2, ent : ES 1 *)
  SigPUD12kj,    (* entree nr : 3, sur CES pos : 2, ent : ES 2 *)
  SigPUD24kv,    (* entree nr : 5, sur CES pos : 2, ent : ES 4 *)
  SigPUD24kj,    (* entree nr : 6, sur CES pos : 2, ent : ES 5 *)
  SigPUD26,      (* entree nr : 8, sur CES pos : 2, ent : ES 7 *)
  CdvPUD10,      (* entree nr : 12, sur CES pos : 3, ent : ES 3 *)
  CdvPUD12a,     (* entree nr : 13, sur CES pos : 3, ent : ES 4 *)
  CdvPUD12b,     (* entree nr : 14, sur CES pos : 3, ent : ES 5 *)
  CdvPUD13,      (* entree nr : 15, sur CES pos : 3, ent : ES 6 *)
  CdvPUD14,      (* entree nr : 16, sur CES pos : 3, ent : ES 7 *)
  CdvPUD15,      (* entree nr : 17, sur CES pos : 4, ent : ES 0 *)
  CdvPUD20,      (* entree nr : 18, sur CES pos : 4, ent : ES 1 *)
  CdvPUD21,      (* entree nr : 19, sur CES pos : 4, ent : ES 2 *)
  CdvPUD22a,     (* entree nr : 20, sur CES pos : 4, ent : ES 3 *)
  CdvPUD22b,     (* entree nr : 21, sur CES pos : 4, ent : ES 4 *)
  CdvPUD23,      (* entree nr : 22, sur CES pos : 4, ent : ES 5 *)
  CdvPUD26,      (* entree nr : 23, sur CES pos : 4, ent : ES 6 *)
  CdvPUD27,      (* entree nr : 24, sur CES pos : 4, ent : ES 7 *)
  CdvSPA10,      (* entree nr : 25, sur CES pos : 5, ent : ES 0 *)
  CdvSPA12a,     (* entree nr : 26, sur CES pos : 5, ent : ES 1 *)
  CdvSPA12b,     (* entree nr : 27, sur CES pos : 5, ent : ES 2 *)
  CdvSPA13,      (* entree nr : 28, sur CES pos : 5, ent : ES 3 *)
  CdvSPA14,      (* entree nr : 29, sur CES pos : 5, ent : ES 4 *)
  CdvSPA20,      (* entree nr : 30, sur CES pos : 5, ent : ES 5 *)
  CdvSPA21,      (* entree nr : 31, sur CES pos : 5, ent : ES 6 *)
  CdvSPA22a,     (* entree nr : 32, sur CES pos : 5, ent : ES 7 *)
  CdvSPA22b,     (* entree nr : 33, sur CES pos : 6, ent : ES 0 *)
  CdvSPA23,      (* entree nr : 34, sur CES pos : 6, ent : ES 1 *)
  CdvSPA24,      (* entree nr : 35, sur CES pos : 6, ent : ES 2 *)
  SigSPA10,      (* entree nr : 36, sur CES pos : 6, ent : ES 3 *)
  SigSPA12kv,    (* entree nr : 38, sur CES pos : 6, ent : ES 5 *)
  SigSPA12kj,    (* entree nr : 39, sur CES pos : 6, ent : ES 6 *)
  SigSPA14,      (* entree nr : 40, sur CES pos : 6, ent : ES 7 *)
  SigSPA24,      (* entree nr : 41, sur CES pos : 7, ent : ES 0 *)

  Sp1SPA,      (* entree nr : 45, sur CES pos : 7, ent : ES 4 *)
  Sp2SPA,      (* entree nr : 46, sur CES pos : 7, ent : ES 5 *)

  SigSPA22,      (* entree nr : 48, sur CES pos : 7, ent : ES 7 *)

  CdvSPA11       (* entree nr : 47, sur CES pos : 7, ent : ES 6 *)
             : BoolD;

 (* Declaration des variables correspondant a des aiguilles       *)
 
  AigPUD13_23,   (* entrees nr :  9_10, sur CES pos : 3, ent : ES 0 *)
  AigSPA13_23    (* entrees nr : 43_44, sur CES pos : 7, ent : ES 2 *)
             : TyAig;


(* variants lies a une commutation d'aiguille *)


(***********************************************************)
(* Variables ne correspondant pas a une entree securitaire *)
(* Points d'arret *)

(* Variables ne correspondant pas a une entree securitaire *)
 

  PtArrSigPUD10,
  PtArrSigPUD12,
  PtArrSigPUD24,
  PtArrSigPUD26,
  PtArrCdvPUD10,
  PtArrSpePUD12b,
  PtArrSpeSPA14,
  PtArrCdvPUD15,
  PtArrCdvPUD20,
  PtArrCdvPUD21,
  PtArrSpePUD22a,
  PtArrCdvPUD26,
  PtArrCdvPUD27,
  PtArrCdvSPA10,
  PtArrSpeSPA12a,
  PtArrCdvSPA20,
  PtArrCdvSPA21,
  PtArrSpeSPA22b,
  PtArrCdvSPA24,
  PtArrSigSPA10,
  PtArrSigSPA12,
  PtArrSigSPA14,

  PtArrSigSPA22,

  PtArrSigSPA24
               : BoolD;



 (* Variants anticipes *)

   PtAntCdvBAR23,
   PtAntCdvBAR22,
   PtAntCdvBAR21,

    PtAntCdvPRA11,
    PtAntCdvPRA12,
    PtAntCdvPRA13             : BoolD;


(***********************************************************)
(* Copie des entrees dans des variables fonctionnelles pour la regulation   *)
 
 CdvPUD12Fonc,
 CdvPUD22Fonc,
 CdvSPA12Fonc,
 CdvSPA22Fonc           : BOOLEAN;

(** Voie d'emission SOL-TRAIN : deux sens confondus**)

    te11s42t01,
    te25s42t02,
    te21s42t03,
    te31s42t04,
    te36s42t05,     
    te16s42t06  :TyEmissionTele;

(** Voie d'emission Inter-secteur deux voies confondues **)
    teL0541,
    teL0543        :TyEmissionTele;

(** Voie de reception Inter-secteur deux voies confondues **)
    trL0541,
    trL0543        :TyCaracEntSec;

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

    EntreeAiguille( AigPUD13_23,    10,  9 ); (* kag D = pos normale *)
    EntreeAiguille( AigSPA13_23,    43, 44 ); (* kag G = pos normale *)


(* Configuration des entrees *)
 
    ProcEntreeIntrins (   1, SigPUD10       );
    ProcEntreeIntrins (   2, SigPUD12kv     );
    ProcEntreeIntrins (   3, SigPUD12kj     );
    ProcEntreeIntrins (   5, SigPUD24kv     );
    ProcEntreeIntrins (   6, SigPUD24kj     );
    ProcEntreeIntrins (   8, SigPUD26       );
    ProcEntreeIntrins (   12, CdvPUD10       );
    ProcEntreeIntrins (   13, CdvPUD12a      );
    ProcEntreeIntrins (   14, CdvPUD12b      );
    ProcEntreeIntrins (   15, CdvPUD13       );
    ProcEntreeIntrins (   16, CdvPUD14       );
    ProcEntreeIntrins (   17, CdvPUD15       );
    ProcEntreeIntrins (   18, CdvPUD20       );
    ProcEntreeIntrins (   19, CdvPUD21       );
    ProcEntreeIntrins (   20, CdvPUD22a      );
    ProcEntreeIntrins (   21, CdvPUD22b      );
    ProcEntreeIntrins (   22, CdvPUD23       );
    ProcEntreeIntrins (   23, CdvPUD26       );
    ProcEntreeIntrins (   24, CdvPUD27       );
    ProcEntreeIntrins (   25, CdvSPA10       );
    ProcEntreeIntrins (   26, CdvSPA12a      );
    ProcEntreeIntrins (   27, CdvSPA12b      );
    ProcEntreeIntrins (   28, CdvSPA13       );
    ProcEntreeIntrins (   29, CdvSPA14       );
    ProcEntreeIntrins (   30, CdvSPA20       );
    ProcEntreeIntrins (   31, CdvSPA21       );
    ProcEntreeIntrins (   32, CdvSPA22a      );
    ProcEntreeIntrins (   33, CdvSPA22b      );
    ProcEntreeIntrins (   34, CdvSPA23       );
    ProcEntreeIntrins (   35, CdvSPA24       );
    ProcEntreeIntrins (   36, SigSPA10       );
    ProcEntreeIntrins (   38, SigSPA12kv     );
    ProcEntreeIntrins (   39, SigSPA12kj     );
    ProcEntreeIntrins (   40, SigSPA14       );

    ProcEntreeIntrins (   41, SigSPA24       );

    ProcEntreeIntrins (   45, Sp1SPA         );
    ProcEntreeIntrins (   46, Sp2SPA         );

    ProcEntreeIntrins (   47, CdvSPA11       );
    ProcEntreeIntrins (   48, SigSPA22       );




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
(* ConfigurerAmpli(Ampli19, 1, 9, 194, 14, FALSE); *)
ConfigurerAmpli(Ampli1A, 1, 10, 195, 14, TRUE);
ConfigurerAmpli(Ampli1B, 1, 11, 196, 15, FALSE);
ConfigurerAmpli(Ampli1C, 1, 12, 197, 15, FALSE);
ConfigurerAmpli(Ampli1D, 1, 13, 198, 15, TRUE);


ConfigurerAmpli(Ampli31, 3, 1, 203, 21, FALSE);
ConfigurerAmpli(Ampli32, 3, 2, 204, 22, FALSE);
ConfigurerAmpli(Ampli33, 3, 3, 205, 22, FALSE);
ConfigurerAmpli(Ampli34, 3, 4, 206, 22, TRUE);
ConfigurerAmpli(Ampli35, 3, 5, 207, 23, FALSE);
ConfigurerAmpli(Ampli36, 3, 6, 208, 23, FALSE);
ConfigurerAmpli(Ampli37, 3, 7, 209, 23, TRUE);
ConfigurerAmpli(Ampli38, 3, 8, 210, 24, FALSE);
ConfigurerAmpli(Ampli39, 3, 9, 211, 24, FALSE);
ConfigurerAmpli(Ampli3A, 3, 10, 212, 24, TRUE);

ConfigurerAmpli(Ampli21, 2, 1, 213, 25, FALSE);
ConfigurerAmpli(Ampli22, 2, 2, 214, 26, FALSE);
ConfigurerAmpli(Ampli23, 2, 3, 215, 26, FALSE);
ConfigurerAmpli(Ampli24, 2, 4, 216, 26, TRUE);
ConfigurerAmpli(Ampli25, 2, 5, 217, 27, FALSE);
ConfigurerAmpli(Ampli26, 2, 6, 218, 27, FALSE);
ConfigurerAmpli(Ampli27, 2, 7, 219, 27, TRUE);
ConfigurerAmpli(Ampli28, 2, 8, 220, 28, FALSE);
ConfigurerAmpli(Ampli29, 2, 9, 221, 28, FALSE);
ConfigurerAmpli(Ampli2A, 2, 10, 222, 28, TRUE);

ConfigurerAmpli(Ampli41, 4, 1, 223, 31, FALSE);
ConfigurerAmpli(Ampli42, 4, 2, 256, 32, FALSE);
ConfigurerAmpli(Ampli43, 4, 3, 257, 32, FALSE);
ConfigurerAmpli(Ampli44, 4, 4, 258, 32, TRUE);
ConfigurerAmpli(Ampli45, 4, 5, 259, 33, FALSE);
ConfigurerAmpli(Ampli46, 4, 6, 260, 33, FALSE);
ConfigurerAmpli(Ampli47, 4, 7, 261, 33, TRUE);
ConfigurerAmpli(Ampli48, 4, 8, 262, 34, FALSE);
ConfigurerAmpli(Ampli49, 4, 9, 263, 34, FALSE);
ConfigurerAmpli(Ampli4A, 4, 10, 264, 34, TRUE);
ConfigurerAmpli(Ampli4B, 4, 11, 265, 35, FALSE);
(* ConfigurerAmpli(Ampli4C, 4, 12, 266, 35, FALSE); *)
ConfigurerAmpli(Ampli4D, 4, 13, 267, 35, TRUE);




 
(** cartes CES **)
   ConfigurerCES(CarteCes1, 01);
   ConfigurerCES(CarteCes2, 02);
   ConfigurerCES(CarteCes3, 03);
   ConfigurerCES(CarteCes4, 04);
   ConfigurerCES(CarteCes5, 05);
   ConfigurerCES(CarteCes6, 06);

(** Liaisons Inter-Secteur **)

   ConfigurerIntsecteur(Intersecteur1, 01, trL0541, trL0543);


(* Initialisations des variables ne correspondant pas a des entrees secu *)

(* Affectation a l'etat restrictif des variants commutes *)


(* Point d'arret *)
    AffectBoolD( BoolRestrictif, PtArrSigPUD10    );
    AffectBoolD( BoolRestrictif, PtArrSigPUD24    );
    AffectBoolD( BoolRestrictif, PtArrSigPUD26    );
    (*AffectBoolD( BoolRestrictif, PtArrCdvPUD9     );*)
    AffectBoolD( BoolRestrictif, PtArrCdvPUD10    );
    AffectBoolD( BoolRestrictif, PtArrSpePUD12b   );
    AffectBoolD( BoolRestrictif, PtArrSpeSPA14   );	
    AffectBoolD( BoolRestrictif, PtArrCdvPUD15    );
    AffectBoolD( BoolRestrictif, PtArrCdvPUD20    );
    AffectBoolD( BoolRestrictif, PtArrCdvPUD21    );
    AffectBoolD( BoolRestrictif, PtArrSpePUD22a   );
    AffectBoolD( BoolRestrictif, PtArrCdvPUD26    );
    AffectBoolD( BoolRestrictif, PtArrCdvPUD27    );
    AffectBoolD( BoolRestrictif, PtArrCdvSPA10    );
    AffectBoolD( BoolRestrictif, PtArrSpeSPA12a   );
    AffectBoolD( BoolRestrictif, PtArrCdvSPA20    );
    AffectBoolD( BoolRestrictif, PtArrCdvSPA21    );
    AffectBoolD( BoolRestrictif, PtArrSpeSPA22b   );
    AffectBoolD( BoolRestrictif, PtArrCdvSPA24    );
    AffectBoolD( BoolRestrictif, PtArrSigSPA10    );
    AffectBoolD( BoolRestrictif, PtArrSigSPA12    );
    AffectBoolD( BoolRestrictif, PtArrSigSPA14    );

    AffectBoolD( BoolRestrictif, PtArrSigSPA24    );

    AffectBoolD( BoolRestrictif, PtArrSigSPA22    );


(* Variants anticipes *)

   AffectBoolD( BoolRestrictif, PtAntCdvBAR23   );
   AffectBoolD( BoolRestrictif, PtAntCdvBAR22   );
   AffectBoolD( BoolRestrictif, PtAntCdvBAR21   );

   AffectBoolD( BoolRestrictif, PtAntCdvPRA11   );
   AffectBoolD( BoolRestrictif, PtAntCdvPRA12   );
   AffectBoolD( BoolRestrictif, PtAntCdvPRA13   );


(* Regulation *)
 CdvPUD12Fonc := FALSE;
 CdvPUD22Fonc := FALSE;
 CdvSPA12Fonc := FALSE;
 CdvSPA22Fonc := FALSE;

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
(* coucou *)

BEGIN

(* CONFIGURATION DES VOIES D'EMISSION **************************)

   ConfigEmisTeleSolTrain ( te11s42t01,
			    noBoucle1,
			    BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te25s42t02,
			    noBoucle4,
			    BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te21s42t03,
			    noBoucle3,
			    BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te31s42t04,
			    noBoucle5,
			    BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te36s42t05,
			    noBoucle6,
			    BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te16s42t06,
			    noBoucle2,
			    BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);


(* CONFIGURATION POUR LA REGULATION *)

   ConfigQuai(74, 64, CdvPUD12Fonc, te11s42t01,  0,  2, 8, 4, 11,  13,14,15);

   ConfigQuai(73, 74, CdvSPA12Fonc, te21s42t03, 12,  4, 5, 10, 6,  13,14,15);

   ConfigQuai(73, 79, CdvSPA22Fonc, te25s42t02,  0,  2, 8,  9, 4,  13,14,15);

   ConfigQuai(74, 69, CdvPUD22Fonc, te31s42t04,  0, 12, 8,  3, 9,  13,14,15);


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

   ProcEmisSolTrain( te11s42t01.EmissionSensUp, (2*noBoucle1),
		     LigneL05+ L0542+ TRONC*01,

 		  PtArrCdvPUD10,
 		  PtArrSigPUD10,
 		  BoolRestrictif, (* AspectCroix *)
 		  PtArrSpePUD12b,
		  PtArrSigPUD12,
		  BoolRestrictif, (* AspectCroix *)
		  AigPUD13_23.PosNormaleFiltree,  (* tiv com *)
		  AigPUD13_23.PosReverseFiltree,
		  AigPUD13_23.PosNormaleFiltree,
 		  BoolRestrictif, (* Rouge fixe contre sens V2 *)
		  BoolRestrictif, (* AspectCroix *)
 		  PtArrCdvPUD15,

(* Variants Anticipes *)
		  PtArrCdvSPA10,
 		  PtArrSigSPA10,
		  BoolRestrictif, (* AspectCroix *)
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

   ProcEmisSolTrain( te25s42t02.EmissionSensUp, (2*noBoucle4),
		     LigneL05+ L0542+ TRONC*02,

		  PtArrSigSPA24,
		  BoolRestrictif, (* AspectCroix *)
		  PtArrSpeSPA22b,
		  PtArrCdvSPA21,
		  PtArrCdvSPA20,
		  PtArrCdvPUD27,
		  PtArrCdvPUD26,		  
		  BoolRestrictif,
(* Variants Anticipes *)
		  PtArrSigPUD26,
		  BoolRestrictif, (* AspectCroix *)
		  PtArrSigPUD24,
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

   ProcEmisSolTrain( te21s42t03.EmissionSensUp, (2*noBoucle3),
		     LigneL05+ L0542+ TRONC*03,

		  PtArrCdvSPA10,
		  PtArrSigSPA10,
		  BoolRestrictif,  (* AspectCroix *)
		  PtArrSpeSPA12a,
		  PtArrSigSPA12,
		  BoolRestrictif,  (* AspectCroix *)
		  PtArrSpeSPA14,		  
		  PtAntCdvPRA11,
(* Variants Anticipes *)
		  PtAntCdvPRA12,		  
		  PtAntCdvPRA13,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
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

   ProcEmisSolTrain( te31s42t04.EmissionSensUp, (2*noBoucle5),
		     LigneL05+ L0542+ TRONC*04,

		  PtArrSigPUD26,
		  BoolRestrictif,  (* AspectCroix *)
		  PtArrSigPUD24,
		  BoolRestrictif,  (* AspectCroix *)
		  AigPUD13_23.PosNormaleFiltree,   (* TIV Com *)
		  AigPUD13_23.PosReverseFiltree,
		  AigPUD13_23.PosNormaleFiltree,
		  PtArrSpePUD22a,
		  BoolRestrictif, (* Rouge fixe contre sens V1 *)
		  BoolRestrictif, (* AspectCroix *)

		  PtArrCdvPUD21,
		  PtArrCdvPUD20,
		  PtAntCdvBAR23,
(* Variants Anticipes *)
		  PtAntCdvBAR22,
		  PtAntCdvBAR21,
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

   ProcEmisSolTrain( te36s42t05.EmissionSensUp, (2*noBoucle6),
		     LigneL05+ L0542+ TRONC*05,

		  PtArrSigSPA22,
		  BoolRestrictif,  (* AspectCroix *)
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
(* Variants Anticipes *)
		  PtArrSpeSPA14,
		  PtAntCdvPRA11,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,		  
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

   ProcEmisSolTrain( te16s42t06.EmissionSensUp, (2*noBoucle2),
		     LigneL05+ L0542+ TRONC*06,

		  PtArrSigSPA14,
		  BoolRestrictif, (* AspectCroix *)
		  AigSPA13_23.PosReverseFiltree,
		  AigSPA13_23.PosNormaleFiltree,
		  BoolRestrictif, 
		  BoolRestrictif, 
		  BoolRestrictif,
		  BoolRestrictif,
(* Variants Anticipes *)
		  PtArrSpeSPA22b, 
		  PtArrCdvSPA21, 
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,		  
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



(* reception du secteur 41 aval *)
   ProcReceptInterSecteur(trL0541, noBoucleBLA, LigneL05+ L0541+ TRONC*02,

		  PtAntCdvPRA11,
		  PtAntCdvPRA12,
		  PtAntCdvPRA13,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
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

(* reception du secteur 43 amont *)
   ProcReceptInterSecteur(trL0543, noBoucleLAS, LigneL05+ L0543+ TRONC*02,

		  PtAntCdvBAR23,
		  PtAntCdvBAR22,
		  PtAntCdvBAR21,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
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



(* emission vers le secteur 41 aval *)
   ProcEmisInterSecteur (teL0541, noBoucleBLA, LigneL05+ L0542+ TRONC*02,
			noBoucleBLA,
		  PtArrCdvSPA24,
		  PtArrSpeSPA22b,
		  PtArrSigSPA24,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
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

(* emission vers le secteur 43 amont *)
   ProcEmisInterSecteur (teL0543, noBoucleLAS, LigneL05+ L0542+ TRONC*01,
		  noBoucleLAS,
		  PtArrCdvPUD10,
		  PtArrSigPUD10,
		  PtArrSpePUD12b,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
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

 (** Emission invariants vers secteur aval L0541 **)
   EmettreSegm(LigneL05+ L0542+ TRONC*02+ SEGM*00, noBoucleBLA, SensUp);
   EmettreSegm(LigneL05+ L0542+ TRONC*02+ SEGM*01, noBoucleBLA, SensUp);

 (** Emission invariants vers secteur amont L0543 **)
   EmettreSegm(LigneL05+ L0542+ TRONC*01+ SEGM*00, noBoucleLAS, SensUp);
   EmettreSegm(LigneL05+ L0542+ TRONC*01+ SEGM*01, noBoucleLAS, SensUp);
   EmettreSegm(LigneL05+ L0542+ TRONC*01+ SEGM*02, noBoucleLAS, SensUp);



 (** Boucle 1 **) (* troncon 42-1 *)
   EmettreSegm(LigneL05+ L0542+ TRONC*01+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL05+ L0542+ TRONC*01+ SEGM*01, noBoucle1, SensUp);
   EmettreSegm(LigneL05+ L0542+ TRONC*01+ SEGM*02, noBoucle1, SensUp);
   EmettreSegm(LigneL05+ L0542+ TRONC*03+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL05+ L0542+ TRONC*03+ SEGM*01, noBoucle1, SensUp);
   EmettreSegm(LigneL05+ L0542+ TRONC*04+ SEGM*00, noBoucle1, SensUp);

 (** Boucle 4 **) (* troncon 42-2 *) 
   EmettreSegm(LigneL05+ L0542+ TRONC*02+ SEGM*00, noBoucle4, SensUp);
   EmettreSegm(LigneL05+ L0542+ TRONC*02+ SEGM*01, noBoucle4, SensUp);
   EmettreSegm(LigneL05+ L0542+ TRONC*04+ SEGM*00, noBoucle4, SensUp);
   EmettreSegm(LigneL05+ L0542+ TRONC*04+ SEGM*01, noBoucle4, SensUp);
   EmettreSegm(LigneL05+ L0542+ TRONC*04+ SEGM*02, noBoucle4, SensUp);
   EmettreSegm(LigneL05+ L0542+ TRONC*05+ SEGM*00, noBoucle4, SensUp);

 (** Boucle 3 **) (* troncon 42-3 *)
   EmettreSegm(LigneL05+ L0542+ TRONC*03+ SEGM*00, noBoucle3, SensUp);  
   EmettreSegm(LigneL05+ L0542+ TRONC*03+ SEGM*01, noBoucle3, SensUp);  
   EmettreSegm(LigneL05+ L0541+ TRONC*01+ SEGM*00, noBoucle3, SensUp);  
   EmettreSegm(LigneL05+ L0542+ TRONC*06+ SEGM*00, noBoucle3, SensUp);  

 (** Boucle 5 **) (* troncon 42-4 *)
   EmettreSegm(LigneL05+ L0542+ TRONC*04+ SEGM*00, noBoucle5, SensUp); 
   EmettreSegm(LigneL05+ L0542+ TRONC*04+ SEGM*01, noBoucle5, SensUp); 
   EmettreSegm(LigneL05+ L0542+ TRONC*04+ SEGM*02, noBoucle5, SensUp);
   EmettreSegm(LigneL05+ L0542+ TRONC*01+ SEGM*01, noBoucle5, SensUp); 
   EmettreSegm(LigneL05+ L0543+ TRONC*02+ SEGM*00, noBoucle5, SensUp); 
   EmettreSegm(LigneL05+ L0543+ TRONC*02+ SEGM*01, noBoucle5, SensUp); 

 (** Boucle 6 **) (* troncon 42-5 *)
   EmettreSegm(LigneL05+ L0542+ TRONC*05+ SEGM*00, noBoucle6, SensUp); 
   EmettreSegm(LigneL05+ L0542+ TRONC*03+ SEGM*01, noBoucle6, SensUp); 
   EmettreSegm(LigneL05+ L0542+ TRONC*06+ SEGM*00, noBoucle6, SensUp);

 (** Boucle 2 **) (* troncon 42-6 *)
   EmettreSegm(LigneL05+ L0542+ TRONC*06+ SEGM*00, noBoucle2, SensUp); 
   EmettreSegm(LigneL05+ L0542+ TRONC*02+ SEGM*00, noBoucle2, SensUp); 
   EmettreSegm(LigneL05+ L0542+ TRONC*03+ SEGM*01, noBoucle2, SensUp);


(* CONFIGURATION DES TRONCONS TSR *********************************)

   ConfigurerTroncon(Tronc0, LigneL05 + L0542 + TRONC*01, 1,1,1,1);  (* troncon 42-1 *)
   ConfigurerTroncon(Tronc1, LigneL05 + L0542 + TRONC*02, 1,1,1,1);  (* troncon 42-2 *)
   ConfigurerTroncon(Tronc2, LigneL05 + L0542 + TRONC*03, 1,1,1,1);  (* troncon 42-3 *)
   ConfigurerTroncon(Tronc3, LigneL05 + L0542 + TRONC*04, 1,1,1,1);  (* troncon 42-4 *)
   ConfigurerTroncon(Tronc4, LigneL05 + L0542 + TRONC*05, 1,1,1,1);  (* troncon 42-5 *)
   ConfigurerTroncon(Tronc5, LigneL05 + L0542 + TRONC*06, 1,1,1,1);  (* troncon 42-6 *)

(* EMISSION DES TSR SUR VOIE 1 ***********************************************)

 (** Emission des TSR vers le secteur aval L0541 **)
   EmettreTronc(LigneL05+ L0542+ TRONC*02, noBoucleBLA, SensUp);

 (** Emission des TSR vers le secteur amont L0543 **)
   EmettreTronc(LigneL05+ L0542+ TRONC*01, noBoucleLAS, SensUp);

 (** Emission des TSR sur les troncons du secteur courant **)
   EmettreTronc(LigneL05+ L0542+ TRONC*01, noBoucle1, SensUp); (* troncon 42-1 *)
   EmettreTronc(LigneL05+ L0542+ TRONC*03, noBoucle1, SensUp);
   EmettreTronc(LigneL05+ L0542+ TRONC*04, noBoucle1, SensUp);

   EmettreTronc(LigneL05+ L0542+ TRONC*02, noBoucle4, SensUp); (* troncon 42-2 *)
   EmettreTronc(LigneL05+ L0542+ TRONC*04, noBoucle4, SensUp);
   EmettreTronc(LigneL05+ L0542+ TRONC*05, noBoucle4, SensUp);

   EmettreTronc(LigneL05+ L0542+ TRONC*03, noBoucle3, SensUp); (* troncon 42-3 *)
   EmettreTronc(LigneL05+ L0541+ TRONC*01, noBoucle3, SensUp);
   EmettreTronc(LigneL05+ L0542+ TRONC*06, noBoucle3, SensUp);

   EmettreTronc(LigneL05+ L0542+ TRONC*04, noBoucle5, SensUp); (* troncon 42-4 *)
   EmettreTronc(LigneL05+ L0542+ TRONC*01, noBoucle5, SensUp);
   EmettreTronc(LigneL05+ L0543+ TRONC*02, noBoucle5, SensUp);

   EmettreTronc(LigneL05+ L0542+ TRONC*05, noBoucle6, SensUp); (* troncon 42-5 *)
   EmettreTronc(LigneL05+ L0542+ TRONC*03, noBoucle6, SensUp);
   EmettreTronc(LigneL05+ L0542+ TRONC*06, noBoucle6, SensUp);

   EmettreTronc(LigneL05+ L0542+ TRONC*06, noBoucle2, SensUp); (* troncon 42-6 *)
   EmettreTronc(LigneL05+ L0542+ TRONC*02, noBoucle2, SensUp);
   EmettreTronc(LigneL05+ L0542+ TRONC*03, noBoucle2, SensUp);


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

(* ------------------------------------------------ *)
    StockAdres( ADR( SigPUD10       ));
    StockAdres( ADR( SigPUD12kv     ));
    StockAdres( ADR( SigPUD12kj     ));
    StockAdres( ADR( SigPUD24kv     ));
    StockAdres( ADR( SigPUD24kj     ));
    StockAdres( ADR( SigPUD26       ));
   (* StockAdres( ADR( CdvPUD9        )); *)
    StockAdres( ADR( CdvPUD10       ));
    StockAdres( ADR( CdvPUD12a      ));
    StockAdres( ADR( CdvPUD12b      ));
    StockAdres( ADR( CdvPUD13       ));
    StockAdres( ADR( CdvPUD14       ));
    StockAdres( ADR( CdvPUD15       ));
    StockAdres( ADR( CdvPUD20       ));
    StockAdres( ADR( CdvPUD21       ));
    StockAdres( ADR( CdvPUD22a      ));
    StockAdres( ADR( CdvPUD22b      ));
    StockAdres( ADR( CdvPUD23       ));
    StockAdres( ADR( CdvPUD26       ));
    StockAdres( ADR( CdvPUD27       ));
    StockAdres( ADR( CdvSPA10       ));
    StockAdres( ADR( CdvSPA12a      ));
    StockAdres( ADR( CdvSPA12b      ));
    StockAdres( ADR( CdvSPA13       ));
    StockAdres( ADR( CdvSPA14       ));
    StockAdres( ADR( CdvSPA20       ));
    StockAdres( ADR( CdvSPA21       ));
    StockAdres( ADR( CdvSPA22a      ));
    StockAdres( ADR( CdvSPA22b      ));
    StockAdres( ADR( CdvSPA23       ));
    StockAdres( ADR( CdvSPA24       ));
    StockAdres( ADR( SigSPA10       ));
    StockAdres( ADR( SigSPA12kv     ));
    StockAdres( ADR( SigSPA12kj     ));
    StockAdres( ADR( SigSPA14       ));

    StockAdres( ADR( SigSPA24       ));

    StockAdres( ADR( Sp1SPA       ));
    StockAdres( ADR( Sp2SPA       ));

    StockAdres( ADR( CdvSPA11       ));
    StockAdres( ADR( SigSPA22       ));
 
(* ------------------------------------------------ *)
 
  (* StockerAdresse Points ARRETS*) 
 
(* ------------------------------------------------ *)
    StockAdres( ADR( PtArrSigPUD10    ));
    StockAdres( ADR( PtArrSigPUD12    ));
    StockAdres( ADR( PtArrSigPUD24    ));
    StockAdres( ADR( PtArrSigPUD26    ));
  (*  StockAdres( ADR( PtArrCdvPUD9     )); *)
    StockAdres( ADR( PtArrCdvPUD10    ));
    StockAdres( ADR( PtArrSpePUD12b   ));
    StockAdres( ADR( PtArrSpeSPA14    ));	
    StockAdres( ADR( PtArrCdvPUD15    ));
    StockAdres( ADR( PtArrCdvPUD20    ));
    StockAdres( ADR( PtArrCdvPUD21    ));
    StockAdres( ADR( PtArrSpePUD22a   ));
    StockAdres( ADR( PtArrCdvPUD26    ));
    StockAdres( ADR( PtArrCdvPUD27    ));
    StockAdres( ADR( PtArrCdvSPA10    ));
    StockAdres( ADR( PtArrSpeSPA12a   ));
    StockAdres( ADR( PtArrCdvSPA20    ));
    StockAdres( ADR( PtArrCdvSPA21    ));
    StockAdres( ADR( PtArrSpeSPA22b   ));
    StockAdres( ADR( PtArrCdvSPA24    ));
    StockAdres( ADR( PtArrSigSPA10    ));
    StockAdres( ADR( PtArrSigSPA12    ));
    StockAdres( ADR( PtArrSigSPA14    ));

    StockAdres( ADR( PtArrSigSPA24    ));

    StockAdres( ADR( PtArrSigSPA22    ));

 
(* ------------------------------------------------ *)

  (* StockerAdresse AIGUILLES*) 
 
(* ------------------------------------------------ *)
    StockAdres( ADR( AigPUD13_23    ));
    StockAdres( ADR( AigSPA13_23    ));
 
(* ------------------------------------------------ *)


   StockAdres( ADR( PtAntCdvPRA11   ));
   StockAdres( ADR( PtAntCdvPRA12   ));
   StockAdres( ADR( PtAntCdvPRA13   ));

   StockAdres( ADR( PtAntCdvBAR23   ));
   StockAdres( ADR( PtAntCdvBAR22   ));
   StockAdres( ADR( PtAntCdvBAR21   ));


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
 CdvPUD12Fonc := CdvPUD12a.F = Vrai.F;
 CdvPUD22Fonc := CdvPUD22a.F = Vrai.F;

 CdvSPA12Fonc := CdvSPA12a.F = Vrai.F;
 CdvSPA22Fonc := CdvSPA22a.F = Vrai.F;




(**** FILTRAGE DES AIGUILLES **************************************************)

  FiltrerAiguille(AigPUD13_23,  BaseExeAig ) ;
  FiltrerAiguille(AigSPA13_23, BaseExeAig + 2) ;


(**** DETERMINATION DES POINTS D'ARRET ****************************************)

(* Voie 1 *)
   AffectBoolD( CdvPUD10,    PtArrCdvPUD10  );
   AffectBoolD( SigPUD10,    PtArrSigPUD10  );

   EtDD( CdvPUD12a,    CdvPUD12b,     BoolTr );
   EtDD( BoolTr   ,    CdvPUD13 ,     PtArrSpePUD12b );

   OuDD( SigPUD12kv,   SigPUD12kj,   PtArrSigPUD12  );

   AffectBoolD( CdvPUD15,    PtArrCdvPUD15  );
   AffectBoolD( CdvSPA10,    PtArrCdvSPA10  );


   AffectBoolD( SigSPA10,    PtArrSigSPA10  );

   EtDD(CdvSPA12b,   CdvSPA12a,     BoolTr);
   EtDD(BoolTr   ,   CdvSPA13 ,     PtArrSpeSPA12a);


   OuDD( SigSPA12kv,   SigSPA12kj,   PtArrSigSPA12  );


   NonD( Sp2SPA,              PtArrSpeSPA14 );
   
(* Voie 2 *)
   AffectBoolD( CdvSPA24,    PtArrCdvSPA24  );


   AffectBoolD( SigSPA24,    PtArrSigSPA24  );

   EtDD(CdvSPA22a, CdvSPA22b, PtArrSpeSPA22b);


   NonD( Sp1SPA,                     BoolTr );
   EtDD( BoolTr, CdvSPA21,   PtArrCdvSPA21  );

   AffectBoolD( CdvSPA20,    PtArrCdvSPA20  );
   AffectBoolD( CdvPUD27,    PtArrCdvPUD27  );
   AffectBoolD( CdvPUD26,    PtArrCdvPUD26  );
   AffectBoolD( SigPUD26,    PtArrSigPUD26  );

   OuDD( SigPUD24kv,   SigPUD24kj,   PtArrSigPUD24 );

   EtDD(CdvPUD22b, CdvPUD22a, PtArrSpePUD22a);


   AffectBoolD( CdvPUD21,    PtArrCdvPUD21  );
   AffectBoolD( CdvPUD20,    PtArrCdvPUD20  );

(* Voies déviées SP *)

   AffectBoolD( SigSPA22,    PtArrSigSPA22  );


   AffectBoolD( SigSPA14,    PtArrSigSPA14  );



(*** lecture des entrees de regulation ***)
   LireEntreesRegul;



END ExeSpecific;
END Specific.

















