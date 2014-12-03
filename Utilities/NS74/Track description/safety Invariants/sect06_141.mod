IMPLEMENTATION MODULE Specific;

(*$S- *)
(*$T- *)

(******************************************************************************
*   SANTIAGO - LIGNE 5 - Secteur 6
*  =============================
*  Version : SCCS 1.2.0
*  Date    : 16/01/1997
*  Auteur  : Marc Plywacz
*  FC : Version du 25.8.1997
******************************************************************************)
(* version 1.3.0 : rajout d'une condition sur la position de l'aiguille FLO 23
		   pour autoriser l'entree a quai du train quand un 14/22 et
		   22/14 est forme. Sinon, on prend la condition normale     
   date : 26/08/1997
   auteur : F. Chanier 
*)          
(*****************************************************************************)
(* version 1.3.1 : mise en place de la detection des pannes d'ampli
   date : 2/2/1998
   auteur : F. Chanier 
*)          
(*****************************************************************************)
(*   Version : 1.3.2 / SCCS 1.4                                              *)
(*   Date    : 27/11/1998                                                    *)
(*   Auteur  : H. Le Roy                                                     *)
(*   Objet   : Mise a jour de l'emission des segments et troncons suite a    *)
(*              l'ajout d'un retournement en 6.4.1 pour manoeuvre 14-22-24.  *)
(*                                                                           *)
(*---------------------------------------------------------------------------*)
(* Version 1.3.3  =====================                                      *)
(* Version 1.5 DU SERVEUR SCCS =====================                         *)
(* Date :         05/10/1999                                                 *)
(* Auteur:        H. Le Roy                                                  *)
(* Modification :  Adaptation de la configuration des amplis au standard     *)
(*                  1.3.3  Suppression d'importations, de declarations de    *)
(*                  constantes et variables, d'appels de fonctions  inutiles.*)
(*                  Suppression de code inutile concernant les DAMTC.        *)
(*---------------------------------------------------------------------------*)
(* Version 1.3.4  =====================                                      *)
(* Version 1.6 DU SERVEUR SCCS =====================                         *)
(* Date :         14/04/2000                                                 *)
(* Auteur:        H. Le Roy                                                  *)
(* Modification : Modif. des marches types de l'interstation Mir-Flo pour    *)
(*                 test de mise au point.                                    *)
(*---------------------------------------------------------------------------*)
(* Version 1.3.5  =====================                                      *)
(* Version 1.7 DU SERVEUR SCCS =====================                         *)
(* Date    :      24/05/2000                                                 *)
(* Auteur  :      D. MARTIN                                                  *)
(* Modification : Am 0165 : Ajustement des marches-types                     *)
(*                                                                           *)
(*****************************************************************************)
(* Version 1.3.6  =====================                                      *)
(* Version 1.8 DU SERVEUR SCCS =====================                         *)
(* Date    :      18/01/2001                                                 *)
(* Auteur  :      S. PEREA                                                   *)
(* Modification :  Am BO2001-01_2_temps retournement.doc                     *)
(* Modif pour diminuer le temps de retournement en terminus:                 *)
(*  Le segment 6.4.1 doit etre inclus dans le message du troncon 6.2         *)
(*                                                                           *)
(*****************************************************************************)
(*                                                                           *)
(*---------------------------------------------------------------------------*)
(* Version 1.3.7  =====================                                      *)
(* Version 1.10 DU SERVEUR SCCS =====================                        *)
(* Date    :      24/02/2005                                                 *)
(* Auteur  :      Marc PLYWACZ                                               *)
(* Modification : Prolongement 3 de la Ligne5 : liaison vers Vince VALDES    *)
(*                Remplacement des portions de voies par des Entrees Secus   *)
(*                Simplifie l'equation du PtArrCdvFLO12                      *)
(*---------------------------------------------------------------------------*)
(* Version 1.3.8  =====================                                      *)
(* Version 1.11 DU SERVEUR SCCS =====================                        *)
(* Date    :      03/03/2005                                                 *)
(* Auteur  :      Marc PLYWACZ                                               *)
(* Modification : demande PHog                                               *)
(*  Ajout de l'ARRETSUB 10B dans segment 9_1_0 implique pour le              *)
(*  Troncon 6.2 d'avoir 6 variants anticipes                                 *)
(*---------------------------------------------------------------------------*)
(* Version 1.3.9  =====================                                      *)
(* Version 1.12 DU SERVEUR SCCS =====================                        *)
(* Date    :      13/07/2005                                                 *)
(* Auteur  :      Marc PLYWACZ                                               *)
(* Modification : tests site                                                 *)
(*  Ajout de affectation de PtArrSigFLO22                                    *)
(*  reprise emission segments sur troncons                                   *)
(*---------------------------------------------------------------------------*)
(* Version 1.4.0  =====================                                      *)
(* Version 1.13 DU SERVEUR SCCS =====================                        *)
(* Date    :      23/08/2005                                                 *)
(* Auteur  :      Marc PLYWACZ                                               *)
(* Modification : tests site                                                 *)
(*  Ajustement marches tytpes    +  Ajout point arret PtArrSigFLO14spe       *)
(*                                                                           *)
(*---------------------------------------------------------------------------*)
(* Version 1.4.1  =====================                                      *)
(* Version 1.14 DU SERVEUR SCCS =====================                        *)
(* Date    :      09/06/2006                                                 *)
(* Auteur  :      Patrick AMSELLEM                                           *)
(* Modification : tests site                                                 *)
(*  Tronçons 2 et 3 PtAntCdvVIN10A remplacé par PtAntCdvVIN10                *)
(*  Ajout pt d'arret  NonD( Sp2FLO,                         BoolTr1       ); *)
(*                    EtDD( BoolTr1,       PtAntCdvVIN10A,  PtAntCdvVIN10 ); *)
(*                                                                           *)
(*---------------------------------------------------------------------------*)


(*****************************  IMPORTATIONS  ********************************)

FROM SYSTEM     IMPORT ADR;

FROM Opel       IMPORT StockAdres, AffectBoolD, AffectBoolC, BoolC, BoolD, BoolLD, EtDD, CodeD,
		       EtatD, Tvrai, FinBranche, FinArbre, AffectC, AffectEtatC, OuDD, NonD;

FROM ConstCode  IMPORT BoolPermissif, BoolRestrictif, Vrai, Faux,
		       Zero, Etat0C, Etat4C;

FROM BibAig     IMPORT TyAig, FiltrerAiguille,
                       EntreeAiguille;

FROM BibExploi  IMPORT
(* types *)
                       TyPortionVoie,
                       TyReconfTransLocale,
                       TyReconfTransAmont,
(* procedures *)
                       VoieLimitrophe,
                       VoieProtegee,
                       VoieProtegeeContresens,
                       VoieNonProtegee,
                       ChainerPortionVoie,
                       TraiterDivergence,
                       TraiterConvergence; 


FROM NouvRegul IMPORT  LireEntreesRegul,
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
                       Boucle1, Boucle2, Boucle3, Boucle4, Boucle5,
		       CarteCes1,  CarteCes2,  CarteCes3, CarteCes4, CarteCes5,
                       Intersecteur1,

                       Ampli11, Ampli12, Ampli13, Ampli14,
                       Ampli21, Ampli22, Ampli23, Ampli24, Ampli25, Ampli26, Ampli27,
                       Ampli31, Ampli32, Ampli33, Ampli34, (* Ampli35, Ampli36, Ampli37, *)
                       Ampli41, Ampli42, Ampli43, Ampli44, Ampli45, Ampli46,
		       Ampli47, Ampli48,          Ampli4A,
		       Ampli51, Ampli52, Ampli53, Ampli54, Ampli55, Ampli56, Ampli57,

(* PROCEDURES *)       ConfigurerBoucle,
                       ConfigurerIntsecteur,
                       ConfigurerCES,
                       ConfigurerAmpli;


FROM BibTsr      IMPORT
   (* VARIABLES *)
 Tronc0,  Tronc1,  Tronc2,  Tronc3 , Tronc4,  Tronc5,
 Tronc6,  Tronc7,  Tronc8,  Tronc9,  Tronc10, Tronc11,
 Tronc12, Tronc13, Tronc14, Tronc15,
   (* PROCEDURE *)
                       ConfigurerTroncon;


FROM ESbin     	 IMPORT 
			ProcEntreeIntrins;

(*****************************  CONSTANTES  ***********************************)

CONST

(** No ligne, No secteur, ....**)

(* supprime *)

    LigneL05 = 16384*00; (* numero de ligne decale de 2**14 *)

    L0509  = 1024*09;    (* numero Secteur aval decale de 2**10 *)

    L0506  = 1024*06;    (* numero Secteur local decale de 2**10 *)

    L0505  = 1024*05;    (* numero Secteur amont decale de 2**10 *)

    TRONC  = 64;         (* decalage de 2**6 pour numero de troncon *)

    SEGM   = 16;         (* decalage de 2**4 pour numero de segment *)


(** Constantes de configuration des emissions en absence d'entrees de commutation **)
    VariantsContinus  = TRUE;
    CommutDifferee    = FALSE;

(** Indication  de positionnement d'aiguille **)
    PosNormale = TRUE;
    PosDeviee = FALSE;

(** indication de sens **)
    SensUp = TRUE;

(** No de Voie d'emissions SOL-Train, d'emission/reception inter-secteur **)
    noBoucleVin = 00;
    noBouclejoa = 01;
    noBouclefi = 02; (* boucle fictive *)
    noBoucle1 = 03;
    noBoucle2 = 04;
    noBoucle3 = 05;
    noBoucle4 = 06;
    noBoucle5 = 07;

(** Base pour les tables de compensation **)
    BaseEntVar	= 500 	;
    BaseSorVar	= 600 	;
    BaseExeAig	= 1280	;
    BaseExeChainage = 1360 ;
    BaseExeSpecific = 1950 ;


(******************** DECLARATION DES VARIABLES GENERALES ********************)
 VAR
(*   BoucleVin, Bouclefi, Bouclejoa : TyBoucle;  *)

(* DECLARATION DES SINGULARITES DU SECTEUR 06 : dans les deux sens confondus *)
(* Declaration des variables correspondant a des entrees securitaires       *)
(*    CDV + signaux + aiguilles + iti                                       *)

   CdvMIR11A,      (* entree  1, CES *)
   CdvMIR11B,      (* entree  2, CES *)
   CdvMIR12,       (* entree  3, CES *)
   CdvMIR13,       (* entree  4, CES *)
   CdvFLO10A,      (* entree  5, CES *)
   CdvFLO10B,      (* entree  6, CES *)

   SigFLO12kj,     (* entree  11, CES *)
   SigFLO12kv,     (* entree  12, CES *)
   SigFLO22,       (* entree  13, CES *)

   SigFLO14,       (* entree  17, CES *)
   SigFLO24,       (* entree  18, CES *)

   CdvMIR23B,      (* entree  21, CES *)
   CdvMIR23A,      (* entree  22, CES *)
   CdvMIR22,       (* entree  23, CES *)
   CdvMIR21,       (* entree  24, CES *)

   CdvFLO11,       (* entree  25, CES *)
   CdvFLO13,       (* entree  26, CES *)
   CdvFLO22A,      (* entree  27, CES *)
   CdvFLO22B,      (* entree  28, CES *)
   CdvFLO12,       (* entree  29, CES *)
   CdvFLO24,       (* entree  30, CES *)
   Sp2FLO,         (* entree  31, CES *)
   V1FLO,          (* entree  32, CES *)
   CdvFLO21,       (* entree  33, CES *)
   CdvFLO20        (* entree  34, CES *)


             : BoolD;


(** aiguilles **)

   AigFLO23,
   AigFLO13               :TyAig;


(* variants lies a la commutation d'aiguille *)
(* pas de commut sur ce secteur *)



(***********************************************************)
(* Variables ne correspondant pas a une entree securitaire *)
(* Points d'arret *)

    PtArrCdvMIR11A,
    PtArrCdvMIR11B,
    PtArrCdvMIR12,
    PtArrCdvMIR13,
    PtArrCdvFLO10A,
    PtArrCdvFLO10B,
    PtArrCdvFLO11,
    PtArrCdvFLO12,

    PtArrSigFLO12,
    PtArrSigFLO22,

    PtArrCdvFLO24,

    PtArrSigFLO14spe,

    PtArrSigFLO14,
    PtArrSigFLO24,

    PtArrCdvFLO22,
    PtArrCdvFLO21,


    PtArrCdvMIR23B,
    PtArrCdvMIR23A,
    PtArrCdvMIR22,
    PtArrCdvMIR21,

    PtAntCdvPED23B           : BoolD;


(** Variants Booleens recus du secteur 09 *)
    PtAntCdvVIN10,
    PtAntCdvVIN10A,
    PtAntCdvVIN10B,
    PtAntSigVIN10,
    AigAntVIN11Rev,
    AigAntVIN11Nor     : BoolD;

(** Variants Booleens recus du secteur 05 *)
    
    PtAntCdvPED23A        : BoolD;


 (* Tiv Com *)

    TivComSigFLO12          : BoolD;


(***********************************************************)
(* Copie des entrees dans des variables fonctionnelles pour la regulation   *)

    CdvMIR12Fonc,
    CdvMIR22Fonc,
    CdvFLO12Fonc,
    CdvFLO22Fonc : BOOLEAN;



(** Voie d'emission SOL-TRAIN : deux sens confondus**)
    te11s06t01,
    te13s06t02,
    te16s06t03,
    te21s06t04,
    te26s06t05           :TyEmissionTele;
    	 			


(** Voie d'emission Inter-secteur deux voies confondues **)
    teL0509,
    teL0505,
    teL05fi	          :TyEmissionTele;

(** Voie de reception Inter-secteur deux voies confondues **)
    trL0509,
    trL0505,
    trL05fi               :TyCaracEntSec;


   V1, V2, V3, V4, V5, V6 : BOOLEAN;




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


(* CONFIGURATIONS DIVERSES ****************************************************)

(* CONFIGURATION DES AIGUILLES, POUR LES DEUX VOIES *)

EntreeAiguille(AigFLO23, 14, 15); (* kag G = pos normale *)



(* Configuration des entrees secu *)

   ProcEntreeIntrins ( 1, CdvMIR11A   );
   ProcEntreeIntrins ( 2, CdvMIR11B   );
   ProcEntreeIntrins ( 3, CdvMIR12    );
   ProcEntreeIntrins ( 4, CdvMIR13    );

   ProcEntreeIntrins ( 5, CdvFLO10A   );
   ProcEntreeIntrins ( 6, CdvFLO10B   );

   ProcEntreeIntrins (11, SigFLO12kj  );
   ProcEntreeIntrins (12, SigFLO12kv  );
   ProcEntreeIntrins (13, SigFLO22    );

   ProcEntreeIntrins (17, SigFLO14    );
   ProcEntreeIntrins (18, SigFLO24    );

   ProcEntreeIntrins (21, CdvMIR23B   );
   ProcEntreeIntrins (22, CdvMIR23A   );
   ProcEntreeIntrins (23, CdvMIR22    );
   ProcEntreeIntrins (24, CdvMIR21    );

   ProcEntreeIntrins (25, CdvFLO11    );
   ProcEntreeIntrins (26, CdvFLO13    );
   ProcEntreeIntrins (27, CdvFLO22A   );
   ProcEntreeIntrins (28, CdvFLO22B   );
   ProcEntreeIntrins (29, CdvFLO12    );
   ProcEntreeIntrins (30, CdvFLO24    );
   ProcEntreeIntrins (31, Sp2FLO      );
   ProcEntreeIntrins (32, V1FLO       );
   ProcEntreeIntrins (33, CdvFLO21    );
   ProcEntreeIntrins (34, CdvFLO20    );



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

   ConfigurerAmpli(Ampli21, 2, 1, 158, 13, FALSE);
   ConfigurerAmpli(Ampli22, 2, 2, 159, 14, FALSE);
   ConfigurerAmpli(Ampli23, 2, 3, 192, 14, FALSE);
   ConfigurerAmpli(Ampli24, 2, 4, 193, 14, TRUE);  
   ConfigurerAmpli(Ampli25, 2, 5, 194, 15, FALSE);
   ConfigurerAmpli(Ampli26, 2, 6, 195, 15, FALSE);         
   ConfigurerAmpli(Ampli27, 2, 7, 196, 15, TRUE);         

   ConfigurerAmpli(Ampli31, 3, 1, 197, 16, FALSE);
   ConfigurerAmpli(Ampli32, 3, 2, 198, 17, FALSE);
   ConfigurerAmpli(Ampli33, 3, 3, 199, 17, FALSE);
   ConfigurerAmpli(Ampli34, 3, 4, 200, 17, TRUE);  
 (*  ConfigurerAmpli(Ampli35, 3, 5, 201, 18, FALSE);
   ConfigurerAmpli(Ampli36, 3, 6, 202, 18, FALSE);               
   ConfigurerAmpli(Ampli37, 3, 7, 203, 18, TRUE);  *)             
         
   ConfigurerAmpli(Ampli41, 4, 1, 204, 21, FALSE);
   ConfigurerAmpli(Ampli42, 4, 2, 205, 22, FALSE);
   ConfigurerAmpli(Ampli43, 4, 3, 206, 22, FALSE);
   ConfigurerAmpli(Ampli44, 4, 4, 207, 22, TRUE);  
   ConfigurerAmpli(Ampli45, 4, 5, 208, 23, FALSE);
   ConfigurerAmpli(Ampli46, 4, 6, 209, 23, FALSE);               
   ConfigurerAmpli(Ampli47, 4, 7, 210, 23, TRUE);
   ConfigurerAmpli(Ampli48, 4, 8, 211, 24, FALSE);    

   ConfigurerAmpli(Ampli4A, 4,10, 213, 24, TRUE);
    
   ConfigurerAmpli(Ampli51, 5, 1, 214, 26, FALSE);
   ConfigurerAmpli(Ampli52, 5, 2, 215, 27, FALSE);
   ConfigurerAmpli(Ampli53, 5, 3, 216, 27, FALSE);
   ConfigurerAmpli(Ampli54, 5, 4, 217, 27, TRUE);  
   ConfigurerAmpli(Ampli55, 5, 5, 218, 28, FALSE);
   ConfigurerAmpli(Ampli56, 5, 6, 219, 28, FALSE);             
   ConfigurerAmpli(Ampli57, 5, 7, 220, 28, TRUE);             
 

 (** cartes CES **)
   ConfigurerCES(CarteCes1, 01);
   ConfigurerCES(CarteCes2, 02);
   ConfigurerCES(CarteCes3, 03);
   ConfigurerCES(CarteCes4, 04);
   ConfigurerCES(CarteCes5, 05);


(** Liaisons Inter-Secteur **)

   ConfigurerIntsecteur(Intersecteur1, 01, trL0509, trL0505);


(* Initialisations des variables ne correspondant pas a des entrees secu *)

(* Point d'arret *)



   AffectBoolD( BoolRestrictif, PtArrCdvMIR11B  );
   AffectBoolD( BoolRestrictif, PtArrCdvMIR12   );
   AffectBoolD( BoolRestrictif, PtArrCdvMIR13   );
   AffectBoolD( BoolRestrictif, PtArrCdvFLO10A  );
   AffectBoolD( BoolRestrictif, PtArrCdvFLO10B  );
   AffectBoolD( BoolRestrictif, PtArrCdvFLO11   );
   AffectBoolD( BoolRestrictif, PtArrCdvFLO12   );

   AffectBoolD( BoolRestrictif, PtArrSigFLO12   );
   AffectBoolD( BoolRestrictif, PtArrSigFLO22   );

   AffectBoolD( BoolRestrictif, PtArrSigFLO14   );
   AffectBoolD( BoolRestrictif, PtArrSigFLO24   );

   AffectBoolD( BoolRestrictif, PtArrCdvFLO22   );
   AffectBoolD( BoolRestrictif, PtArrCdvFLO21   );

   AffectBoolD( BoolRestrictif, PtAntCdvVIN10   );

   AffectBoolD( BoolRestrictif, PtArrCdvMIR23B  );
   AffectBoolD( BoolRestrictif, PtArrCdvMIR23A  );
   AffectBoolD( BoolRestrictif, PtArrCdvMIR22   );
   AffectBoolD( BoolRestrictif, PtArrCdvMIR21   );



 (* Recu par intersecteur *)
   AffectBoolD( BoolRestrictif, PtAntCdvVIN10A   );
   AffectBoolD( BoolRestrictif, PtAntCdvVIN10B   );
   AffectBoolD( BoolRestrictif, PtAntSigVIN10    );
   AffectBoolD( BoolRestrictif, AigAntVIN11Nor   );
   AffectBoolD( BoolRestrictif, AigAntVIN11Rev   );

   AffectBoolD( BoolRestrictif, PtAntCdvPED23A   );
   AffectBoolD( BoolRestrictif, PtAntCdvPED23B   );



 (* Tiv Com *)
   AffectBoolD( BoolRestrictif, TivComSigFLO12   );
   

(* Regulation *)
 CdvFLO12Fonc := FALSE;
 CdvFLO22Fonc := FALSE;
 CdvMIR12Fonc := FALSE;
 CdvMIR22Fonc := FALSE;



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

   ConfigEmisTeleSolTrain ( te11s06t01,
                            noBoucle1,         
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);


   ConfigEmisTeleSolTrain ( te13s06t02,
                            noBoucle2,         
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);
   

     
   ConfigEmisTeleSolTrain ( te16s06t03,
                            noBoucle3,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);


   ConfigEmisTeleSolTrain ( te21s06t04,
                            noBoucle4,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);
 
   ConfigEmisTeleSolTrain ( te26s06t05,
                            noBoucle5,
                            BoolPermissif,
			    BoolRestrictif,
			    VariantsContinus,
			    CommutDifferee);
 

(* CONFIGURATION POUR LA REGULATION *)

   ConfigQuai (62, 64, CdvFLO12Fonc, te13s06t02, 0, 4,11, 10, 7, 13, 14, 15);
   ConfigQuai (62, 69, CdvFLO22Fonc, te21s06t04, 0,11, 5, 10, 6, 13, 14, 15);
   ConfigQuai (61, 74, CdvMIR12Fonc, te11s06t01, 0, 1, 3,  9,11, 13, 14, 15);
   ConfigQuai (61, 79, CdvMIR22Fonc, te26s06t05, 0, 3, 4, 11,10, 13, 14, 15);

END InitSpecConfMess;

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

(* CONFIGURATION DES EMISSIONS DE VARIANTS SOL-TRAIN SUR VOIE *****************)



(* variants troncon 1   voie 1 --> si *)
   ProcEmisSolTrain( te11s06t01.EmissionSensUp, (2*noBoucle1), 
                     LigneL05+ L0506+ TRONC*01,     

                 PtArrCdvMIR11B,
                 PtArrCdvMIR12,
                 PtArrCdvMIR13,
    		  PtArrCdvFLO10A,
		  BoolRestrictif,
		  BoolRestrictif,		
		  BoolRestrictif,
		  BoolRestrictif,
(* Variants Anticipes *)
    		  PtArrCdvFLO10B,
                  PtArrCdvFLO11,
                  PtArrCdvFLO12,
		  BoolRestrictif,
		  BoolRestrictif,
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
   ProcEmisSolTrain( te13s06t02.EmissionSensUp, (2*noBoucle2), 
                     LigneL05+ L0506+ TRONC*02,     

    		  PtArrCdvFLO10B,
                  PtArrCdvFLO11,
                  PtArrCdvFLO12,
		  PtArrSigFLO12,
                  BoolRestrictif,             (* aspect croix *)
		  TivComSigFLO12,
                  PtArrSigFLO14spe,
		  PtAntCdvVIN10,

(* Variants Anticipes *)
                 PtAntCdvVIN10B,
                 PtAntSigVIN10,
                 BoolRestrictif,             (* aspect croix *)
                 AigAntVIN11Nor,             (* tiv Com *)
		 AigAntVIN11Rev,
                 AigAntVIN11Nor,
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


(* variants troncon 3    voie 1-->2  si  *)
   ProcEmisSolTrain( te16s06t03.EmissionSensUp, (2*noBoucle3), 
                     LigneL05+ L0506+ TRONC*03,     

                  PtArrSigFLO22,
                  BoolRestrictif,             (* aspect croix *)
		  BoolRestrictif,
		  BoolRestrictif,			
		  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif, 
                  BoolRestrictif,                     
(* Variants Anticipes *)
                  PtArrSigFLO14spe,
                  PtAntCdvVIN10,
		  BoolRestrictif,             
                  BoolRestrictif,
		  BoolRestrictif,
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



	 
(* variants troncon 4  voies 1-2 <-- sp *)
   ProcEmisSolTrain( te21s06t04.EmissionSensUp, (2*noBoucle4), 
                     LigneL05+ L0506+ TRONC*04,     

                  PtArrSigFLO14,
                  BoolRestrictif,             (* aspect croix *)
                  PtArrSigFLO24,
                  BoolRestrictif,             (* aspect croix *)
		  PtArrCdvFLO22,
                  PtArrCdvFLO21,
		  BoolRestrictif,
                  BoolRestrictif,
(* Variants Anticipes *)
                  PtArrCdvMIR23B,
                  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
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
   ProcEmisSolTrain( te26s06t05.EmissionSensUp, (2*noBoucle5), 
                     LigneL05+ L0506+ TRONC*05,     

                  PtArrCdvMIR23B,  
                  PtArrCdvMIR23A,
                  PtArrCdvMIR22,
                  PtArrCdvMIR21,
    		  PtAntCdvPED23B,
		  BoolRestrictif,			
		  BoolRestrictif,
		  BoolRestrictif,
(* Variants Anticipes *)
                  PtAntCdvPED23A,
                  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
		  BoolRestrictif,
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



 
(* reception du secteur 09 -aval- *)

   ProcReceptInterSecteur(trL0509, noBoucleVin, LigneL05+ L0509+ TRONC*01,
                  PtAntCdvVIN10A,
                  PtAntCdvVIN10B,
                  PtAntSigVIN10,
                  AigAntVIN11Rev,
                  AigAntVIN11Nor,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif, 
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


(* reception du secteur 05 -amont- *)

   ProcReceptInterSecteur(trL0505, noBouclejoa, LigneL05+ L0505+ TRONC*03,

                  PtAntCdvPED23B,
                  PtAntCdvPED23A,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif, 
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


(* emission vers le secteur 05 -amont- *)

   ProcEmisInterSecteur (teL0505, noBouclejoa, LigneL05+ L0506+ TRONC*01,
			noBouclejoa,
			
                  PtArrCdvMIR11A,
                  PtArrCdvMIR11B,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif, 
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



(* emission vers le secteur 09 -aval- *)

   ProcEmisInterSecteur (teL0509, noBoucleVin, LigneL05+ L0506+ TRONC*04,
			noBoucleVin,
                  PtArrCdvFLO24,
                  PtArrSigFLO24,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif,
                  BoolRestrictif, 
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

(* CONFIGURATION DES EMISSION DES INVARIANTS SECURITAIRES *********************)

(* Tous les sens doivent etre a SensUp ; il n'y a pas de commutation *)
            

 (** Emission invariants vers secteur 05 amont L0505 **)

   EmettreSegm(LigneL05+ L0506+ TRONC*01+ SEGM*00, noBouclejoa, SensUp);


 (** Emission invariants vers secteur 09 aval L0509 **)

   EmettreSegm(LigneL05+ L0506+ TRONC*04+ SEGM*01, noBoucleVin, SensUp);
   EmettreSegm(LigneL05+ L0506+ TRONC*05+ SEGM*00, noBoucleVin, SensUp);



 (** Boucle 1 **)        
   EmettreSegm(LigneL05+ L0506+ TRONC*01+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL05+ L0506+ TRONC*02+ SEGM*00, noBoucle1, SensUp);
   EmettreSegm(LigneL05+ L0506+ TRONC*02+ SEGM*01, noBoucle1, SensUp);
 

 (** Boucle 2 **)        
   EmettreSegm(LigneL05+ L0506+ TRONC*02+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL05+ L0506+ TRONC*02+ SEGM*01, noBoucle2, SensUp);
 
   EmettreSegm(LigneL05+ L0506+ TRONC*04+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL05+ L0506+ TRONC*04+ SEGM*01, noBoucle2, SensUp);
   
   EmettreSegm(LigneL05+ L0509+ TRONC*01+ SEGM*00, noBoucle2, SensUp);
   EmettreSegm(LigneL05+ L0509+ TRONC*01+ SEGM*01, noBoucle2, SensUp);
   EmettreSegm(LigneL05+ L0509+ TRONC*03+ SEGM*00, noBoucle2, SensUp);


 (** Boucle 3 **)        
 
   EmettreSegm(LigneL05+ L0509+ TRONC*01+ SEGM*00, noBoucle3, SensUp);
   EmettreSegm(LigneL05+ L0506+ TRONC*02+ SEGM*01, noBoucle3, SensUp);

 (** Boucle 4 **)        
   EmettreSegm(LigneL05+ L0506+ TRONC*04+ SEGM*00, noBoucle4, SensUp);
   EmettreSegm(LigneL05+ L0506+ TRONC*04+ SEGM*01, noBoucle4, SensUp);
   EmettreSegm(LigneL05+ L0506+ TRONC*05+ SEGM*00, noBoucle4, SensUp);
   EmettreSegm(LigneL05+ L0506+ TRONC*05+ SEGM*01, noBoucle4, SensUp);
   EmettreSegm(LigneL05+ L0506+ TRONC*03+ SEGM*00, noBoucle4, SensUp);

 (** Boucle 5 **) (** les invariants du tr. 5 ne sont pas transmis *)       
   EmettreSegm(LigneL05+ L0505+ TRONC*03+ SEGM*00, noBoucle5, SensUp);
   EmettreSegm(LigneL05+ L0505+ TRONC*03+ SEGM*01, noBoucle5, SensUp);
   EmettreSegm(LigneL05+ L0505+ TRONC*04+ SEGM*00, noBoucle5, SensUp);
   
 

(* CONFIGURATION DES TRONCONS TSR *********************************)

   ConfigurerTroncon(Tronc0, LigneL05 + L0506 + TRONC*01, 1,1,1,1);  (* troncon 6-1 *)
   ConfigurerTroncon(Tronc1, LigneL05 + L0506 + TRONC*02, 1,1,1,1);  (* troncon 6-2 *)
   ConfigurerTroncon(Tronc2, LigneL05 + L0506 + TRONC*03, 1,1,1,1);  (* troncon 6-3 *)
   ConfigurerTroncon(Tronc3, LigneL05 + L0506 + TRONC*04, 1,1,1,1);  (* troncon 6-4 *)
   ConfigurerTroncon(Tronc4, LigneL05 + L0506 + TRONC*05, 1,1,1,1);  (* troncon 6-5 *)


(* EMISSION DES TSR ***********************************************)



(** Emission des TSR vers le secteur amont 05 L0505 **)

   EmettreTronc(LigneL05+ L0506+ TRONC*01, noBouclejoa, SensUp);


(** Emission des TSR vers le secteur aval 09 L0509 **)

   EmettreTronc(LigneL05+ L0506+ TRONC*04, noBoucleVin, SensUp);
   EmettreTronc(LigneL05+ L0506+ TRONC*05, noBoucleVin, SensUp);



 (** Emission des TSR sur les troncons du secteur courant **)

   EmettreTronc(LigneL05+ L0506+ TRONC*01, noBoucle1, SensUp); (* troncon 6-1 *)
   EmettreTronc(LigneL05+ L0506+ TRONC*02, noBoucle1, SensUp);
 


   EmettreTronc(LigneL05+ L0506+ TRONC*02, noBoucle2, SensUp); (* troncon 6-2 *)
 
   EmettreTronc(LigneL05+ L0506+ TRONC*04, noBoucle2, SensUp);
   
   EmettreTronc(LigneL05+ L0509+ TRONC*01, noBoucle2, SensUp);
   EmettreTronc(LigneL05+ L0509+ TRONC*03, noBoucle2, SensUp);


   EmettreTronc(LigneL05+ L0509+ TRONC*01, noBoucle3, SensUp); (* troncon 6-3 *)
   EmettreTronc(LigneL05+ L0506+ TRONC*03, noBoucle3, SensUp);
   EmettreTronc(LigneL05+ L0506+ TRONC*02, noBoucle3, SensUp);


   EmettreTronc(LigneL05+ L0506+ TRONC*04, noBoucle4, SensUp); (* troncon 6-4 *)
   EmettreTronc(LigneL05+ L0506+ TRONC*05, noBoucle4, SensUp);
   EmettreTronc(LigneL05+ L0506+ TRONC*03, noBoucle4, SensUp);


   EmettreTronc(LigneL05+ L0506+ TRONC*05, noBoucle5, SensUp); (* troncon 6-5 *)
   EmettreTronc(LigneL05+ L0505+ TRONC*03, noBoucle5, SensUp);
   EmettreTronc(LigneL05+ L0505+ TRONC*04, noBoucle5, SensUp);



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
    StockAdres( ADR(CdvMIR11A));
    StockAdres( ADR(CdvMIR11B));
    StockAdres( ADR(CdvMIR12));
    StockAdres( ADR(CdvMIR13));
    StockAdres( ADR(CdvFLO10A));
    StockAdres( ADR(CdvFLO10B));

    StockAdres( ADR(SigFLO12kj));
    StockAdres( ADR(SigFLO12kv));
    StockAdres( ADR(SigFLO22));
    StockAdres( ADR(SigFLO14));
    StockAdres( ADR(SigFLO24));

    StockAdres( ADR(CdvMIR23B));
    StockAdres( ADR(CdvMIR23A));
    StockAdres( ADR(CdvMIR22));
    StockAdres( ADR(CdvMIR21));

    StockAdres( ADR(CdvFLO11));
    StockAdres( ADR(CdvFLO13));
    StockAdres( ADR(CdvFLO22A));
    StockAdres( ADR(CdvFLO22B));
    StockAdres( ADR(CdvFLO12));
    StockAdres( ADR(CdvFLO24));
    StockAdres( ADR(Sp2FLO));
    StockAdres( ADR(V1FLO));
    StockAdres( ADR(CdvFLO21));
    StockAdres( ADR(CdvFLO20));



    StockAdres( ADR(PtArrCdvMIR11A));
    StockAdres( ADR(PtArrCdvMIR11B));
    StockAdres( ADR(PtArrCdvMIR12));
    StockAdres( ADR(PtArrCdvMIR13));
    StockAdres( ADR(PtArrCdvFLO10A));
    StockAdres( ADR(PtArrCdvFLO10B));
    StockAdres( ADR(PtArrCdvFLO11));
    StockAdres( ADR(PtArrCdvFLO12));

    StockAdres( ADR(PtArrSigFLO12));
    StockAdres( ADR(PtArrSigFLO22));

    StockAdres( ADR(PtArrCdvFLO24));

    StockAdres( ADR(PtArrSigFLO14spe));

    StockAdres( ADR(PtArrSigFLO14));
    StockAdres( ADR(PtArrSigFLO24));

    StockAdres( ADR(PtArrCdvFLO22));
    StockAdres( ADR(PtArrCdvFLO21));

    StockAdres( ADR(PtAntCdvVIN10));

    StockAdres( ADR(PtArrCdvMIR23B));
    StockAdres( ADR(PtArrCdvMIR23A));
    StockAdres( ADR(PtArrCdvMIR22));
    StockAdres( ADR(PtArrCdvMIR21));
    StockAdres( ADR(PtAntCdvPED23B));


    StockAdres( ADR(PtAntCdvVIN10A));
    StockAdres( ADR(PtAntCdvVIN10B));
    StockAdres( ADR(PtAntSigVIN10));
    StockAdres( ADR(AigAntVIN11Rev));
    StockAdres( ADR(AigAntVIN11Nor));


    StockAdres( ADR(PtAntCdvPED23A));


    StockAdres( ADR(TivComSigFLO12));




    StockAdres( ADR(AigFLO23));
    StockAdres( ADR(AigFLO13));



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

(**** CONFIGURATION DES PORTIONS DE VOIE ****)
(*   InitSpecPv;  *)

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

VAR BoolTr1, BoolTr2 : BoolLD;

BEGIN (* ExeSpecific *)

(* Affectation des "constantes" utilisees dans la construction des messages emis    *)
(* et recus sur les boucles de transmission continue et sur les liens intersecteur. *)
(* Cette reaffectation est necessaire a chaque cycle pour la mise en securite.      *)
   AffectBoolC(Vrai, BoolPermissif)  ;
   AffectBoolC(Faux, BoolRestrictif) ;

(* regulation *)

CdvFLO12Fonc:=(CdvFLO12.F  = Vrai.F);
CdvFLO22Fonc:=(CdvFLO22A.F = Vrai.F);
CdvMIR12Fonc:=(CdvMIR12.F  = Vrai.F);
CdvMIR22Fonc:=(CdvMIR22.F  = Vrai.F);


(* FILTRAGE DES AIGUILLES ***********************************************************)

FiltrerAiguille(AigFLO23,BaseExeAig);
(* FiltrerAiguille(AigFLO11,BaseExeAig+2); *)


(**** DETERMINATION DES POINTS D'ARRET ****************************************)


AffectBoolD( CdvMIR11A, PtArrCdvMIR11A );
AffectBoolD( CdvMIR11B, PtArrCdvMIR11B );
AffectBoolD( CdvMIR12,  PtArrCdvMIR12  );
AffectBoolD( CdvMIR13,  PtArrCdvMIR13  );



AffectBoolD( CdvFLO10A,    PtArrCdvFLO10A );
AffectBoolD( CdvFLO10B,    PtArrCdvFLO10B );
AffectBoolD( CdvFLO11,     PtArrCdvFLO11);


OuDD( CdvFLO13,      AigFLO23.PosReverseFiltree,   BoolTr1      );
EtDD( CdvFLO12,      BoolTr1,                      PtArrCdvFLO12);


OuDD( SigFLO12kv,    SigFLO12kj,      PtArrSigFLO12 );

NonD( Sp2FLO,                         BoolTr1       );
EtDD( BoolTr1,       PtAntCdvVIN10A,  PtAntCdvVIN10 ); 

NonD( Sp2FLO,                         PtArrSigFLO14spe);


AffectBoolD( CdvFLO24,    PtArrCdvFLO24 );

AffectBoolD( SigFLO14,    PtArrSigFLO14 );
AffectBoolD( SigFLO24,    PtArrSigFLO24 );
AffectBoolD( SigFLO22,    PtArrSigFLO22 );

EtDD( CdvFLO22A,     CdvFLO22B, PtArrCdvFLO22 );
EtDD( PtArrCdvFLO22, CdvFLO21,  PtArrCdvFLO22 );


NonD( V1FLO,                     BoolTr1       );
EtDD( CdvFLO21,      CdvFLO20,   PtArrCdvFLO21 );
EtDD( PtArrCdvFLO21, BoolTr1,    PtArrCdvFLO21 );


AffectBoolD( CdvMIR23B,            PtArrCdvMIR23B );
AffectBoolD( CdvMIR23A,            PtArrCdvMIR23A );
AffectBoolD( CdvMIR22 ,            PtArrCdvMIR22  );
AffectBoolD( CdvMIR21 ,            PtArrCdvMIR21  );



(* Determine le TIV COM *)

   AffectBoolD (SigFLO12kv,     TivComSigFLO12);




(*** lecture des entrees de regulation ***)

   LireEntreesRegul;

END ExeSpecific;
END Specific.
