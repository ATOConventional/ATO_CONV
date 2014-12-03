IMPLEMENTATION MODULE Specific;

(*$S- *)
(*$T- *)

(******************************************************************************
*   SANTIAGO - Ligne 5 - Secteur 1
*  =============================
*  Version : SCCS 1.1.0
*  Date    : 15/12/1996
*  Auteur  : Marc Plywacz
*  fc : Version conforme au 25/8/1997    
*
*  Version : SCCS 1.1.1
*  Date    : 2/2/1998
*  Auteur  : F. Chanier
*  nature : mise en place de la detection des pannes d'ampli     
*
******************************************************************************)
(***            AJOUT DE LA NUMEROTATION SCCS DES VERSIONS                ****)
(*---------------------------------------------------------------------------*)
(* Version 1.1.2  =====================                                      *)
(* Version 1.3 DU SERVEUR SCCS =====================                         *)
(* Date    :      19/07/1999                                                 *)
(* Auteur  :      H. Le Roy                                                  *)
(* Modification : Modification pour le prolongement de la ligne :            *)
(*               -  Suppression de code inutile.                             *)
(*               -  Remplacement du chainage par une gestion directe des     *)
(*                           points d'arret                                  *)
(*               -  Configuation et exploitation des nouveaux parametres de  *)
(*                           la voie                                         *)
(*               -  Configuration des fusibles.                              *)
(*               -  Gestion des SP                                           *)
(*---------------------------------------------------------------------------*)
(* Version 1.1.3  =====================                                      *)
(* Version 1.4 DU SERVEUR SCCS =====================                         *)
(* Date    :      20/12/1999                                                 *)
(* Auteur  :      H. Le Roy                                                  *)
(* Modification : Correction d'une erreur dans l'attribution des tables de   *)
(*                 compensation                                              *)
(*---------------------------------------------------------------------------*)
(* Version 1.1.4  =====================                                      *)
(* Version 1.5 DU SERVEUR SCCS =====================                         *)
(* Date    :      03/01/2000                                                 *)
(* Auteur  :      H. Le Roy                                                  *)
(* Modification : Inversion des entrees Kv et Kj du signal 24 pour limiter   *)
(*                  les modif. de cablage sur site                           *)
(*---------------------------------------------------------------------------*)
(* Version 1.1.5  =====================                                      *)
(* Version 1.6 DU SERVEUR SCCS =====================                         *)
(* Date    :      31/03/2000                                                 *)
(* Auteur  :      H. Le Roy                                                  *)
(* Modification : Am dev032000-5 : Modif. de la gestion du SP : Ajout d'un   *)
(*                   point d'arret specifique entierement dedie au SP1 a     *)
(*                   Baquedano V2. Le point d'arret sub. du 21, qui gerait   *)
(*                   cette tache en est maintenant decharge                  *)
(*---------------------------------------------------------------------------*)
(* Version 1.1.6  =====================                                      *)
(* Version 1.7 DU SERVEUR SCCS =====================                         *)
(* Date    :      24/05/2000                                                 *)
(* Auteur  :      D. MARTIN                                                  *)
(* Modification : Am 0165 : Ajustement des marches-types                     *)
(*                                                                           *)
(*****************************************************************************)
(* Version 1.1.7  =====================                                      *)
(* Version 1.7 DU SERVEUR SCCS =====================                         *)
(* Date    :      05/07/2012                                                 *)
(* Auteur  :      JP. BEMMA                                                  *)
(* Modification : Ajout de bibliothèques manquantes pour la compilation      *)
(*                                                                           *)
(*****************************************************************************)
(* Version 1.1.8  =====================                                      *)
(* Version 1.7 DU SERVEUR SCCS =====================                         *)
(* Date    :      31/07/2012                                                 *)
(* Auteur  :      JP. BEMMA                                                  *)
(* Modification : l'équation du point d'arret PtArrCdvBUS26 devient :        *)
(*                      Cdv26 et Cdv25                                       *)
(*****************************************************************************)
(******************************  IMPORTATIONS  ********************************)

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

    L0502  = 1024*02; (* numero Secteur aval voie impaire decale de 2**10 *)

    L0507  = 1024*07; (* numero Secteur amont voie impaire decale de 2**10 *)

    L0501  = 1024*01; (* numero Secteur local decale de 2**10 *)

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
    noBoucleira = 00;
    noBoucleana = 01;
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

(* DECLARATION DES SINGULARITES DU SECTEUR 01 : dans les deux sens confondus *)

(* Declaration des variables correspondant a des entrees securitaires       *)
(*   - CDV et signaux                                                       *)

   SigBAQ10,      (* entree  1, soit entree 0 de CES 02  *)
   SigBAQ12kv,    (* entree  2, soit entree 1 de CES 02  *)
   CdvBUS12,      (* entree  5, soit entree 4 de CES 02  *)
   CdvBUS13,      (* entree  6, soit entree 5 de CES 02  *)
   CdvBUS23,      (* entree  7, soit entree 6 de CES 02  *)
   CdvBUS26,      (* entree  8, soit entree 7 de CES 02  *)

   CdvBUS25,      (* entree  9, soit entree 0 de CES 03  *)
   CdvBAQ24,      (* entree 10, soit entree 1 de CES 03  *)
   SigBAQ24kj,    (* entree 11, soit entree 2 de CES 03  *)
   SigBAQ22B,     (* entree 12, soit entree 3 de CES 03  *)
   SigBAQ24kv,    (* entree 13, soit entree 4 de CES 03  *)
   CdvBAQ23,      (* entree 14, soit entree 5 de CES 03  *)
   CdvBAQ12,      (* entree 15, soit entree 6 de CES 03  *)
   CdvBAQ13,      (* entree 16, soit entree 7 de CES 03  *)

   SigBAQ12kj,    (* entree 17, soit entree 0 de CES 04  *)
   SigBAQ22,      (* entree 18, soit entree 1 de CES 04  *)
   SigBAQ26,      (* entree 19, soit entree 2 de CES 04  *)
   CdvBAQ10,      (* entree 20, soit entree 3 de CES 04  *)
   CdvBAQ20,      (* entree 21, soit entree 4 de CES 04  *)
   CdvBAQ21,      (* entree 22, soit entree 5 de CES 04  *)
   CdvBAQ22,      (* entree 23, soit entree 6 de CES 04  *)
   Sp1BAQ,        (* entree 24, soit entree 7 de CES 04  *)

(*pas utilisee*)  (* entree 25, soit entree 0 de CES 05  *)
   CdvBEL11,      (* entree 26, soit entree 1 de CES 05  *)
   CdvBEL12,      (* entree 27, soit entree 2 de CES 05  *)
   CdvBEL13,      (* entree 28, soit entree 3 de CES 05  *)
   CdvBEL14,      (* entree 29, soit entree 4 de CES 05  *)
   CdvBEL21,      (* entree 30, soit entree 5 de CES 05  *)
   CdvBEL22,      (* entree 31, soit entree 6 de CES 05  *)
   CdvBEL23       (* entree 32, soit entree 7 de CES 05  *)
             : BoolD;

    AigBAQ13       (* entrees 3 & 4, soit entrees 2 & 3 de CES 02 *) 
              : TyAig; 


(***********************************************************)
(* Variables ne correspondant pas a une entree securitaire *)
(* Points d'arret *)

 PtArrSigBAQ10,
 PtArrSigBAQ12,

 PtArrCdvBUS12,
 PtArrCdvBUS13,
 PtArrCdvBUS23,
 PtArrCdvBUS26,

 PtArrSigBAQ24,
 PtArrCdvBAQ12,
 PtArrSigBAQ22,
 PtArrSigBAQ26,
 PtArrCdvBAQ10,
 PtArrCdvBAQ20,
 PtArrCdvBAQ21,
 PtArrSpeBAQ22,

 PtArrCdvBEL11,
 PtArrCdvBEL12,
 PtArrCdvBEL13,
 PtArrCdvBEL14,
 PtArrCdvBEL21,
 PtArrCdvBEL22,
 PtArrCdvBEL23            : BoolD;

(***********************************************************)
 (* Variants anticipes *)
 PtAntCdvISA11,
 PtAntCdvISA12,
 PtAntCdvISA13,
 PtAntCdvPLA23,
 PtAntCdvPLA22            : BoolD;

(***********************************************************)
(* Copie des entrees dans des variables fonctionnelles pour la regulation   *)
 CdvBEL12Fonc,
 CdvBEL22Fonc,
 CdvBAQ12Fonc,
 CdvBAQ22Fonc,
 CdvBUS12Fonc,
 CdvBUS26Fonc           : BOOLEAN;



(** Voie d'emission SOL-TRAIN : deux sens confondus**)
    te11s01t01,
    te14s01t02,
    te17s01t03,
    te21s01t04,
    te23s01t05,
    te26s01t06     :TyEmissionTele;

(** Voie d'emission Inter-secteur deux voies confondues **)
    teL0502,
    teL0507       :TyEmissionTele;

(** Voie de reception Inter-secteur deux voies confondues **)
    trL0502,
    trL0507        :TyCaracEntSec;

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
   EntreeAiguille(AigBAQ13, 4, 3); (* Gauche = Reverse *) 

(* Configuration des entrees *)

   ProcEntreeIntrins (  1, SigBAQ10   );
   ProcEntreeIntrins (  2, SigBAQ12kv );
   ProcEntreeIntrins (  5, CdvBUS12   );
   ProcEntreeIntrins (  6, CdvBUS13   );
   ProcEntreeIntrins (  7, CdvBUS23   );
   ProcEntreeIntrins (  8, CdvBUS26   );
   ProcEntreeIntrins (  9, CdvBUS25   );
   ProcEntreeIntrins ( 10, CdvBAQ24   );
   ProcEntreeIntrins ( 11, SigBAQ24kj );
   ProcEntreeIntrins ( 12, SigBAQ22B  );
   ProcEntreeIntrins ( 13, SigBAQ24kv );
   ProcEntreeIntrins ( 14, CdvBAQ23   );
   ProcEntreeIntrins ( 15, CdvBAQ12   );
   ProcEntreeIntrins ( 16, CdvBAQ13   );
   ProcEntreeIntrins ( 17, SigBAQ12kj );
   ProcEntreeIntrins ( 18, SigBAQ22   );
   ProcEntreeIntrins ( 19, SigBAQ26   );
   ProcEntreeIntrins ( 20, CdvBAQ10   );
   ProcEntreeIntrins ( 21, CdvBAQ20   );
   ProcEntreeIntrins ( 22, CdvBAQ21   );
   ProcEntreeIntrins ( 23, CdvBAQ22   );
   ProcEntreeIntrins ( 24, Sp1BAQ     );
   ProcEntreeIntrins ( 26, CdvBEL11   );
   ProcEntreeIntrins ( 27, CdvBEL12   );
   ProcEntreeIntrins ( 28, CdvBEL13   );
   ProcEntreeIntrins ( 29, CdvBEL14   );
   ProcEntreeIntrins ( 30, CdvBEL21   );
   ProcEntreeIntrins ( 31, CdvBEL22   );
   ProcEntreeIntrins ( 32, CdvBEL23   );


(* CONFIGURATION POUR LA MAINTENANCE de la transmission continue*)
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

   ConfigurerAmpli(Ampli21, 2, 1, 193, 14, FALSE);
   ConfigurerAmpli(Ampli22, 2, 2, 194, 15, FALSE);
   ConfigurerAmpli(Ampli23, 2, 3, 195, 15, FALSE);
   ConfigurerAmpli(Ampli24, 2, 4, 196, 15, TRUE);
   ConfigurerAmpli(Ampli25, 2, 5, 197, 16, FALSE);
   ConfigurerAmpli(Ampli26, 2, 6, 198, 16, FALSE);
   ConfigurerAmpli(Ampli27, 2, 7, 199, 16, TRUE);

   ConfigurerAmpli(Ampli31, 3, 1, 200, 17, FALSE);
   ConfigurerAmpli(Ampli32, 3, 2, 201, 18, FALSE);
   ConfigurerAmpli(Ampli34, 3, 4, 203, 18, TRUE);

   ConfigurerAmpli(Ampli41, 4, 1, 204, 21, FALSE);
   ConfigurerAmpli(Ampli42, 4, 2, 205, 22, FALSE);
   ConfigurerAmpli(Ampli43, 4, 3, 206, 22, FALSE);
   ConfigurerAmpli(Ampli44, 4, 4, 207, 22, TRUE);

   ConfigurerAmpli(Ampli51, 5, 1, 208, 23, FALSE);
   ConfigurerAmpli(Ampli52, 5, 2, 209, 24, FALSE);
   ConfigurerAmpli(Ampli53, 5, 3, 210, 24, FALSE);
   ConfigurerAmpli(Ampli54, 5, 4, 211, 24, TRUE);
   ConfigurerAmpli(Ampli55, 5, 5, 212, 25, FALSE);
   ConfigurerAmpli(Ampli56, 5, 6, 213, 25, FALSE);
   ConfigurerAmpli(Ampli57, 5, 7, 214, 25, TRUE);

   ConfigurerAmpli(Ampli61, 6, 1, 215, 26, FALSE);
   ConfigurerAmpli(Ampli62, 6, 2, 216, 27, FALSE);
   ConfigurerAmpli(Ampli63, 6, 3, 217, 27, FALSE);
   ConfigurerAmpli(Ampli64, 6, 4, 218, 27, TRUE);
   ConfigurerAmpli(Ampli65, 6, 5, 219, 28, FALSE);
   ConfigurerAmpli(Ampli66, 6, 6, 220, 28, FALSE);
   ConfigurerAmpli(Ampli67, 6, 7, 221, 28, TRUE);


 
(** cartes CES **)
   ConfigurerCES(CarteCes1, 01);
   ConfigurerCES(CarteCes2, 02);
   ConfigurerCES(CarteCes3, 03);
   ConfigurerCES(CarteCes4, 04);

(** Liaisons Inter-Secteur **)
(*  pas de liaison intersecteur vers amont *)
   ConfigurerIntsecteur(Intersecteur1, 01, trL0502, trL0507);


(* Initialisations des variables ne correspondant pas a des entrees secu *)
(* Point d'arret *)
 AffectBoolD( BoolRestrictif, PtArrSigBAQ10  );
 AffectBoolD( BoolRestrictif, PtArrSigBAQ12  );
 AffectBoolD( BoolRestrictif, PtArrCdvBUS12  );
 AffectBoolD( BoolRestrictif, PtArrCdvBUS13  );
 AffectBoolD( BoolRestrictif, PtArrCdvBUS23  );
 AffectBoolD( BoolRestrictif, PtArrCdvBUS26  );
 AffectBoolD( BoolRestrictif, PtArrSigBAQ24  );
 AffectBoolD( BoolRestrictif, PtArrCdvBAQ12  );
 AffectBoolD( BoolRestrictif, PtArrSigBAQ22  );
 AffectBoolD( BoolRestrictif, PtArrSigBAQ26  );
 AffectBoolD( BoolRestrictif, PtArrCdvBAQ10  );
 AffectBoolD( BoolRestrictif, PtArrCdvBAQ20  );
 AffectBoolD( BoolRestrictif, PtArrCdvBAQ21  );
 AffectBoolD( BoolRestrictif, PtArrSpeBAQ22  );
 AffectBoolD( BoolRestrictif, PtArrCdvBEL11  );
 AffectBoolD( BoolRestrictif, PtArrCdvBEL12  );
 AffectBoolD( BoolRestrictif, PtArrCdvBEL13  );
 AffectBoolD( BoolRestrictif, PtArrCdvBEL14  );
 AffectBoolD( BoolRestrictif, PtArrCdvBEL21  );
 AffectBoolD( BoolRestrictif, PtArrCdvBEL22  );
 AffectBoolD( BoolRestrictif, PtArrCdvBEL23  ); 
(* Variants anticipes *)
 AffectBoolD( BoolRestrictif, PtAntCdvISA11  );
 AffectBoolD( BoolRestrictif, PtAntCdvISA12  );
 AffectBoolD( BoolRestrictif, PtAntCdvISA13  );
 AffectBoolD( BoolRestrictif, PtAntCdvPLA23  );
 AffectBoolD( BoolRestrictif, PtAntCdvPLA22  );

(* Regulation *)
 CdvBEL12Fonc := FALSE;
 CdvBEL22Fonc := FALSE;
 CdvBAQ12Fonc := FALSE;
 CdvBAQ22Fonc := FALSE;
 CdvBUS12Fonc := FALSE;
 CdvBUS26Fonc := FALSE;

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

   ConfigEmisTeleSolTrain ( te11s01t01,
			    noBoucle1,
			    BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te14s01t02,
			    noBoucle2,
			    BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te17s01t03,
			    noBoucle3,
			    BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te21s01t04,
			    noBoucle4,
			    BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te23s01t05,
			    noBoucle5,
			    BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

   ConfigEmisTeleSolTrain ( te26s01t06,
			    noBoucle6,
			    BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);

(* CONFIGURATION POUR LA REGULATION *)
(* fc: modification pour insertion des parametres le 3/7/1997 *)

 ConfigQuai(63, 84, CdvBEL12Fonc, te23s01t05, 0,12, 8, 3, 9, 13, 14, 15);
 ConfigQuai(63, 89, CdvBEL22Fonc, te26s01t06, 0, 4,11,10, 6, 13, 14, 15);
 ConfigQuai(51, 64, CdvBAQ12Fonc, te11s01t01, 0, 4,11, 5,10, 13, 14, 15);
 ConfigQuai(51, 69, CdvBAQ22Fonc, te14s01t02, 0,12, 2, 5, 6, 13, 14, 15);
 ConfigQuai(52, 74, CdvBUS12Fonc, te11s01t01, 0, 3, 9, 4, 5, 13, 14, 15);
 ConfigQuai(52, 79, CdvBUS26Fonc, te14s01t02, 0, 2, 8, 9, 4, 13, 14, 15);

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

(* variants premier troncon voie 1 --> sens impair *)
   ProcEmisSolTrain( te11s01t01.EmissionSensUp, (2*noBoucle1),
		     LigneL05+ L0501+ TRONC*01,

		  PtArrCdvBAQ12,
 		  PtArrSigBAQ12,  (* signal 12 *) 
 		  BoolRestrictif, (* AspectCroix *)
		  AigBAQ13.PosReverseFiltree,
		  AigBAQ13.PosNormaleFiltree,		  
		  PtArrCdvBUS12,
		  PtArrCdvBUS13,
		  PtAntCdvISA11,
(* Variants Anticipes *)
		  PtAntCdvISA12,
		  PtAntCdvISA13,
 		  BoolRestrictif, (* rouge fix *)
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
		  BaseSorVar);



(* variants second troncon voie 2 sens pair *)
   ProcEmisSolTrain( te14s01t02.EmissionSensUp, (2*noBoucle2),
		     LigneL05+ L0501+ TRONC*02,

		  PtArrCdvBUS26,
		  PtArrSigBAQ26,
		  BoolRestrictif (* AspectCroix *),
		  PtArrSigBAQ24,
		  BoolRestrictif (* AspectCroix *),
		  AigBAQ13.PosReverseFiltree,
		  AigBAQ13.PosNormaleFiltree,		  
		  PtArrSpeBAQ22,
		  PtArrCdvBAQ21,
(* Variants Anticipes *)
		  PtArrCdvBAQ20,
		  BoolRestrictif, (* rouge fix *)
		  BoolRestrictif (* AspectCroix *),
		  BoolRestrictif,
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


(* variants du troisieme troncon voie 1 sens pair *)
   ProcEmisSolTrain( te17s01t03.EmissionSensUp, (2*noBoucle3),
		     LigneL05+ L0501+ TRONC*03,

		  BoolRestrictif, (* rouge fixe permanent *)
		  BoolRestrictif, (* AspectCroix *)
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
		  BaseSorVar + 60);


(* variants quatrieme troncon voie 2 sens impair *)
   ProcEmisSolTrain( te21s01t04.EmissionSensUp, (2*noBoucle4),
		     LigneL05+ L0501+ TRONC*04,

		  PtArrSigBAQ22,
		  BoolRestrictif  (* AspectCroix *),
		  BoolRestrictif, (* rouge fixe *)
		  BoolRestrictif  (* AspectCroix *),
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
		  BaseSorVar + 90);



(* variants cinquieme troncon voie 1 sens impair *)
   ProcEmisSolTrain( te23s01t05.EmissionSensUp, (2*noBoucle5),
		     LigneL05+ L0501+ TRONC*05,

		  PtArrCdvBEL12,
		  PtArrCdvBEL13,
		  PtArrCdvBEL14,
		  PtArrCdvBAQ10,
		  PtArrSigBAQ10,
		  BoolRestrictif (* AspectCroix *),
		  BoolRestrictif,
		  BoolRestrictif,
(* Variants Anticipes *)
		  PtArrCdvBAQ12,
		  PtArrSigBAQ12,
		  BoolRestrictif (* AspectCroix *),
		  AigBAQ13.PosReverseFiltree,
		  AigBAQ13.PosNormaleFiltree,		  
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



(* variants sixieme troncon voie 2 sens pair *)
   ProcEmisSolTrain( te26s01t06.EmissionSensUp, (2*noBoucle6),
		     LigneL05+ L0501+ TRONC*06,

		  PtArrCdvBAQ20,
		  PtArrCdvBEL23,
		  PtArrCdvBEL22,
		  PtArrCdvBEL21,
		  PtAntCdvPLA23,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
(* Variants Anticipes *)
		  PtAntCdvPLA22,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
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


(* reception du secteur 2 aval *)
   ProcReceptInterSecteur(trL0502, noBoucleira, LigneL05+ L0502+ TRONC*01,

		  PtAntCdvISA11,
		  PtAntCdvISA12,
		  PtAntCdvISA13,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
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

(* reception du secteur 7 amont *)
   ProcReceptInterSecteur(trL0507, noBoucleana, LigneL05+ L0507+ TRONC*03,

		  PtAntCdvPLA23,
		  PtAntCdvPLA22,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
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



(* emission vers le secteur 2 aval *)
   ProcEmisInterSecteur (teL0502, noBoucleira, LigneL05+ L0501+ TRONC*02,
			noBoucleira,
		  PtArrCdvBUS23,
		  PtArrCdvBUS26,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
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

(* emission vers le secteur 7 amont *)
   ProcEmisInterSecteur (teL0507, noBoucleana, LigneL05+ L0501+ TRONC*05,
			noBoucleana,
		  PtArrCdvBEL11,
		  PtArrCdvBEL12,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
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

 (** Emission invariants vers secteur aval L0502 **)
   EmettreSegm(LigneL05+ L0501+ TRONC*02+ SEGM*00, noBoucleira, SensUp);
   EmettreSegm(LigneL05+ L0501+ TRONC*02+ SEGM*01, noBoucleira, SensUp);

 (** Emission invariants vers secteur amont L0507 **)
   EmettreSegm(LigneL05+ L0501+ TRONC*05+ SEGM*00, noBoucleana, SensUp);
   EmettreSegm(LigneL05+ L0501+ TRONC*05+ SEGM*01, noBoucleana, SensUp);

 (** Boucle 1 **)
   EmettreSegm(LigneL05+ L0501+ TRONC*01+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL05+ L0501+ TRONC*01+ SEGM*01, noBoucle1, SensUp);
   EmettreSegm(LigneL05+ L0501+ TRONC*04+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL05+ L0501+ TRONC*04+ SEGM*01, noBoucle1, SensUp);
   EmettreSegm(LigneL05+ L0502+ TRONC*01+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL05+ L0502+ TRONC*02+ SEGM*00, noBoucle1, SensUp);

 (** Boucle 2 **)
   EmettreSegm(LigneL05+ L0501+ TRONC*02+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL05+ L0501+ TRONC*02+ SEGM*01, noBoucle2, SensUp);
   EmettreSegm(LigneL05+ L0501+ TRONC*06+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL05+ L0501+ TRONC*06+ SEGM*01, noBoucle2, SensUp);
   EmettreSegm(LigneL05+ L0501+ TRONC*03+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL05+ L0501+ TRONC*04+ SEGM*00, noBoucle2, SensUp);

 (** Boucle 3 **)
   EmettreSegm(LigneL05+ L0501+ TRONC*03+ SEGM*00, noBoucle3, SensUp);  
(* fc : rajout pour retournement le 10/3/1997 *)
   EmettreSegm(LigneL05+ L0501+ TRONC*01+ SEGM*00, noBoucle3, SensUp);  

 (** Boucle 4 **)
   EmettreSegm(LigneL05+ L0501+ TRONC*04+ SEGM*00, noBoucle4, SensUp); 
   EmettreSegm(LigneL05+ L0501+ TRONC*02+ SEGM*01, noBoucle4, SensUp); 

 (** Boucle 5 **)
   EmettreSegm(LigneL05+ L0501+ TRONC*05+ SEGM*00, noBoucle5, SensUp); 
   EmettreSegm(LigneL05+ L0501+ TRONC*05+ SEGM*01, noBoucle5, SensUp); 
   EmettreSegm(LigneL05+ L0501+ TRONC*01+ SEGM*00, noBoucle5, SensUp); 
   EmettreSegm(LigneL05+ L0501+ TRONC*01+ SEGM*01, noBoucle5, SensUp); 
   EmettreSegm(LigneL05+ L0501+ TRONC*04+ SEGM*00, noBoucle5, SensUp); 

 (** Boucle 6 **)
   EmettreSegm(LigneL05+ L0501+ TRONC*06+ SEGM*00, noBoucle6, SensUp); 
   EmettreSegm(LigneL05+ L0501+ TRONC*06+ SEGM*01, noBoucle6, SensUp); 
   EmettreSegm(LigneL05+ L0507+ TRONC*03+ SEGM*00, noBoucle6, SensUp); 
   EmettreSegm(LigneL05+ L0507+ TRONC*03+ SEGM*01, noBoucle6, SensUp); 


(* CONFIGURATION DES TRONCONS TSR *********************************)

   ConfigurerTroncon(Tronc0, LigneL05 + L0501 + TRONC*01, 1,1,1,1);  (* troncon 1-1 *)
   ConfigurerTroncon(Tronc1, LigneL05 + L0501 + TRONC*02, 1,1,1,1);  (* troncon 1-2 *)
   ConfigurerTroncon(Tronc2, LigneL05 + L0501 + TRONC*03, 1,1,1,1);  (* troncon 1-3 *)
   ConfigurerTroncon(Tronc3, LigneL05 + L0501 + TRONC*04, 1,1,1,1);  (* troncon 1-4 *)
   ConfigurerTroncon(Tronc4, LigneL05 + L0501 + TRONC*05, 1,1,1,1);  (* troncon 1-5 *)
   ConfigurerTroncon(Tronc5, LigneL05 + L0501 + TRONC*06, 1,1,1,1);  (* troncon 1-6 *)

(* EMISSION DES TSR SUR VOIE 1 ***********************************************)

 (** Emission des TSR vers le secteur aval L0502 **)
   EmettreTronc(LigneL05+ L0501+ TRONC*02, noBoucleira, SensUp);

(** Emission des TSR vers le secteur amont L0507 **)
   EmettreTronc(LigneL05+ L0501+ TRONC*05, noBoucleana, SensUp);

 (** Emission des TSR sur les troncons du secteur courant **)
   EmettreTronc(LigneL05+ L0501+ TRONC*01, noBoucle1, SensUp); (* troncon 1-1 *)
   EmettreTronc(LigneL05+ L0501+ TRONC*04, noBoucle1, SensUp);
   EmettreTronc(LigneL05+ L0502+ TRONC*01, noBoucle1, SensUp);
   EmettreTronc(LigneL05+ L0502+ TRONC*02, noBoucle1, SensUp);

   EmettreTronc(LigneL05+ L0501+ TRONC*02, noBoucle2, SensUp); (* troncon 1-2 *)
   EmettreTronc(LigneL05+ L0501+ TRONC*06, noBoucle2, SensUp);
   EmettreTronc(LigneL05+ L0501+ TRONC*03, noBoucle2, SensUp);
   EmettreTronc(LigneL05+ L0501+ TRONC*04, noBoucle2, SensUp);

   EmettreTronc(LigneL05+ L0501+ TRONC*03, noBoucle3, SensUp); (* troncon 1-3 *)
(* fc : rajout pour le retournement le 10/3/1997 *)
   EmettreTronc(LigneL05+ L0501+ TRONC*01, noBoucle3, SensUp);

   EmettreTronc(LigneL05+ L0501+ TRONC*04, noBoucle4, SensUp); (* troncon 1-4 *)
   EmettreTronc(LigneL05+ L0501+ TRONC*02, noBoucle4, SensUp);

   EmettreTronc(LigneL05+ L0501+ TRONC*05, noBoucle5, SensUp); (* troncon 1-5 *)
   EmettreTronc(LigneL05+ L0501+ TRONC*01, noBoucle5, SensUp);
   EmettreTronc(LigneL05+ L0501+ TRONC*04, noBoucle5, SensUp);

   EmettreTronc(LigneL05+ L0501+ TRONC*06, noBoucle6, SensUp); (* troncon 1-6 *)
   EmettreTronc(LigneL05+ L0507+ TRONC*03, noBoucle6, SensUp);


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

   StockAdres( ADR(SigBAQ10   ));
   StockAdres( ADR(SigBAQ12kv ));
   StockAdres( ADR(CdvBUS12   ));
   StockAdres( ADR(CdvBUS13   ));
   StockAdres( ADR(CdvBUS23   ));
   StockAdres( ADR(CdvBUS26   ));
   StockAdres( ADR(CdvBUS25   ));
   StockAdres( ADR(CdvBAQ24   ));
   StockAdres( ADR(SigBAQ24kj ));
   StockAdres( ADR(SigBAQ22B  ));
   StockAdres( ADR(SigBAQ24kv ));
   StockAdres( ADR(CdvBAQ23   ));
   StockAdres( ADR(CdvBAQ12   ));
   StockAdres( ADR(CdvBAQ13   ));
   StockAdres( ADR(SigBAQ12kj ));
   StockAdres( ADR(SigBAQ22   ));
   StockAdres( ADR(SigBAQ26   ));
   StockAdres( ADR(CdvBAQ10   ));
   StockAdres( ADR(CdvBAQ20   ));
   StockAdres( ADR(CdvBAQ21   ));
   StockAdres( ADR(CdvBAQ22   ));
   StockAdres( ADR(Sp1BAQ     ));
   StockAdres( ADR(CdvBEL11   ));
   StockAdres( ADR(CdvBEL12   ));
   StockAdres( ADR(CdvBEL13   ));
   StockAdres( ADR(CdvBEL14   ));
   StockAdres( ADR(CdvBEL21   ));
   StockAdres( ADR(CdvBEL22   ));
   StockAdres( ADR(CdvBEL23   ));

   StockAdres( ADR( AigBAQ13  )); 

   StockAdres( ADR(PtArrSigBAQ10   ));
   StockAdres( ADR(PtArrSigBAQ12   ));
   StockAdres( ADR(PtArrCdvBUS12   ));
   StockAdres( ADR(PtArrCdvBUS13   ));
   StockAdres( ADR(PtArrCdvBUS23   ));
   StockAdres( ADR(PtArrCdvBUS26   ));
   StockAdres( ADR(PtArrSigBAQ24   ));
   StockAdres( ADR(PtArrCdvBAQ12   ));
   StockAdres( ADR(PtArrSigBAQ22   ));
   StockAdres( ADR(PtArrSigBAQ26   ));
   StockAdres( ADR(PtArrCdvBAQ10   ));
   StockAdres( ADR(PtArrCdvBAQ20   ));
   StockAdres( ADR(PtArrCdvBAQ21   ));
   StockAdres( ADR(PtArrSpeBAQ22   ));
   StockAdres( ADR(PtArrCdvBEL11   ));
   StockAdres( ADR(PtArrCdvBEL12   ));
   StockAdres( ADR(PtArrCdvBEL13   ));
   StockAdres( ADR(PtArrCdvBEL14   ));
   StockAdres( ADR(PtArrCdvBEL21   ));
   StockAdres( ADR(PtArrCdvBEL22   ));
   StockAdres( ADR(PtArrCdvBEL23   )); 
   StockAdres( ADR(PtAntCdvISA11   ));
   StockAdres( ADR(PtAntCdvISA12   ));
   StockAdres( ADR(PtAntCdvISA13   ));
   StockAdres( ADR(PtAntCdvPLA23   ));
   StockAdres( ADR(PtAntCdvPLA22   ));

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

	(* Configuration des troncons *)
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
VAR BoolSp : BoolLD;

BEGIN (* ExeSpecific *)

(* Affectation des "constantes" utilisees dans la construction des messages emis        *)
(* et recus sur les boucles de transmission continue et sur les liens intersecteur.     *)
(* Cette reaffectation est necessaire a chaque cycle pour la mise en securite.          *)
   AffectBoolC(Vrai, BoolPermissif)  ;
   AffectBoolC(Faux, BoolRestrictif) ;

 (* regulation *)
 CdvBEL12Fonc := CdvBEL12.F = Vrai.F;
 CdvBEL22Fonc := CdvBEL22.F = Vrai.F;
 CdvBAQ12Fonc := CdvBAQ12.F = Vrai.F;
 CdvBAQ22Fonc := CdvBAQ22.F = Vrai.F;
 CdvBUS12Fonc := CdvBUS12.F = Vrai.F;
 CdvBUS26Fonc := CdvBUS26.F = Vrai.F;

(**** FILTRAGE DES AIGUILLES **************************************************)

  FiltrerAiguille(AigBAQ13, BaseExeAig ) ;



(**** DETERMINATION DES POINTS D'ARRET ****************************************)

   (*voie 1*)

   AffectBoolD( CdvBEL11,    PtArrCdvBEL11 );

   AffectBoolD( CdvBEL12,    PtArrCdvBEL12 );
   AffectBoolD( CdvBEL13,    PtArrCdvBEL13 );
   AffectBoolD( CdvBEL14,    PtArrCdvBEL14 );

   AffectBoolD( CdvBAQ10,    PtArrCdvBAQ10 );
   AffectBoolD( SigBAQ10,    PtArrSigBAQ10 );
   EtDD( CdvBAQ12,    CdvBAQ13,      PtArrCdvBAQ12 );
   OuDD( SigBAQ12kv,  SigBAQ12kj,    PtArrSigBAQ12 );

   AffectBoolD( CdvBUS12,    PtArrCdvBUS12 );
   AffectBoolD( CdvBUS13,    PtArrCdvBUS13 );

   (*voie 2*)

   AffectBoolD( SigBAQ22,    PtArrSigBAQ22  );

   AffectBoolD( CdvBUS23,    PtArrCdvBUS23 );
   EtDD( CdvBUS25,    CdvBUS26,      PtArrCdvBUS26 );  
   AffectBoolD( SigBAQ26,    PtArrSigBAQ26 );

   OuDD( SigBAQ24kj,  SigBAQ24kv,    PtArrSigBAQ24 );
   NonD( Sp1BAQ,      PtArrSpeBAQ22 );
   AffectBoolD( CdvBAQ21,    PtArrCdvBAQ21 );
   AffectBoolD( CdvBAQ20,    PtArrCdvBAQ20 );

   AffectBoolD( CdvBEL23,    PtArrCdvBEL23 );
   AffectBoolD( CdvBEL22,    PtArrCdvBEL22 );
   AffectBoolD( CdvBEL21,    PtArrCdvBEL21 );



(*** lecture des entrees de regulation ***)
   LireEntreesRegul;

END ExeSpecific;
END Specific.


