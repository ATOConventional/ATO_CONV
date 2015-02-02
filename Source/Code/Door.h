/*================================ Header ================================*/

/*
Copyright: Alstom Transport Information Solutions
Software : ATO ML&S
Module   : Door
File type: Interface
*/

#ifndef _DoorH
#define _DoorH

/*================================ Constants ================================*/

/*================================ External module interfaces ================================*/

/*-- Application --*/
#include "ReferencePoints.h"

/*================================ Macros ================================*/

/*================================ Types ================================*/

/*-- Door command --*/
typedef enum{
  Door_eCommand_None    = 0,
  Door_eCommand_Opening = 1,
  Door_eCommand_Closing = 2
}Door_tCommand;

/*-- Door state --*/
typedef enum{
  Door_eState_Unknown = 0,
  Door_eState_Opened  = 1,
  Door_eState_Closed  = 2
}Door_tState;

/*================================ Function interfaces ================================*/

/*-- Initialise -> Main --*/
void Door_Main_Initialise(void);

/*-- Update -> Main --*/
void Door_Main_Update(void);

/*================================ Data ================================*/
#ifdef _DoorC
#define _extern
#define _const
#else
#define _extern extern
#define _const const
#endif

_extern Door_tCommand                   _const Door_gCommandReferenceToATPLeftSide;
_extern Door_tState                     _const Door_gTDStateLeftSide;
_extern Door_tCommand                   _const Door_gCommandReferenceToATPRightSide;
_extern Door_tState                     _const Door_gTDStateRightSide;
_extern ReferencePoints_tObjectx1       _const Door_gReferencePoints;
_extern long                            _const Door_gManualDoorOpeningManagement;
_extern long                            _const Door_gManualDoorClosingManagement;
_extern long                            _const Door_gTrainDoorClosedAndLockedIsNotLateralised; /* Boolean */
_extern long                            _const Door_gTrainDoorClosedAndLockedLeftSide; /* Boolean */
_extern long                            _const Door_gTrainDoorClosedAndLockedRightSide; /* Boolean */

#undef _extern
#undef _const

#endif
