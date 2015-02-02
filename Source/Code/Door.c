/*================================ Header ================================*/

/*
Copyright: Alstom Transport Information Solutions
Software : ATO ML&S
Module   : Door
File type: Implementation
@DesignPart=ATO_Door
*/

#define _DoorC
#include "Door.h"

/*================================ Constants ================================*/

/*================================ External module interfaces ================================*/

/*-- Application --*/
#include "NoSanctionReferenceToDriver.h"
#include "Start.h"
#include "DrivingReference.h"
#include "ATPMessage.h"
#include "MasterCoreSelection.h"
#include "NCC.h"
#include "EmbeddedSetting.h"
#include "LongMath.h"
#include "Kinematics.h"
#include "KinematicsReferencePoint.h"
#include "DrivingCommand.h"
#include "SwitchFromManualToAutomaticDriving.h"
#include "OperationPlan.h"

/*-- Standard --*/
#include <string.h>
#include <limits.h>

/*================================ Macros ================================*/

/*================================ Types ================================*/

/*================================ Function interfaces ================================*/

/*================================ Data ================================*/

static long                        gOpeningCommandLatencyLeftSide ; /* 10^-1 s */
static long                        gClosingCommandLatencyLeftSide ; /* 10^-1 s */
static long                        gReferenceRemainingTimeToCloseLeftSide ; /* 10^-1 s */
static long                 const* gpTrainDoorClosedAndLockedLeftSide ; /* Boolean */
static long          const* const* gppTrainDoorClosedAndLockedLeftSide ; /* Boolean */
static long                        gTrainDoorClosedAndLockedLeftSideIsConstant; /* Boolean */
static long                        gCommandReferenceOpeningLeftSide ;
static long                        gCommandReferenceClosingLeftSide;
static long                        gCommandReferenceOpeningRightSide;
static long                        gCommandReferenceClosingRightSide;
static long                        gOpeningCommandLatencyRightSide; /* 10^-1 s */
static long                        gClosingCommandLatencyRightSide; /* 10^-1 s */
static long                        gReferenceRemainingTimeToCloseRightSide; /* 10^-1 s */
static long                 const* gpTrainDoorClosedAndLockedRightSide;
static long          const* const* gppTrainDoorClosedAndLockedRightSide; /* Boolean */
static long                        gTrainDoorClosedAndLockedRightSideIsConstant; /* Boolean */
static long                        gTrainDoorsManaged; /* Boolean */
static long                        gTDOpeningCommandLatency; /* 10^-1 s */
static long                        gTDClosingCommandLatency; /* 10^-1 s */
static long                        gPSDClosingCommandLatency; /* 10^-1 s */
static long                        gDoorCommandReferenceAnticipation; /* 10^-1 s */
static long                        gCommandReferenceToATPLeftSideClosing; /* Boolean */
static long                        gCommandReferenceToATPLeftSideOpening; /* Boolean */
static long                        gCommandReferenceToATPRightSideClosing; /* Boolean */
static long                        gCommandReferenceToATPRightSideOpening; /* Boolean */
static long                        gCommandReferenceToATPClosing; /* Boolean */
static long                        gCommandReferenceToATPOpening; /* Boolean */
static long                        gTDStateLeftSideUnknown; /* Boolean */
static long                        gTDStateLeftSideOpened; /* Boolean */ 
static long                        gTDStateLeftSideClosed; /* Boolean */
static long                        gTDStateRightSideUnknown; /* Boolean */
static long                        gTDStateRightSideOpened; /* Boolean */
static long                        gTDStateRightSideClosed; /* Boolean */
static long          const* const* gppTrainDoorManaged; /* Boolean */
static long          const* const* gppManualDoorOpeningManagement; /* Boolean */
static long          const* const* gppManualDoorClosingManagement; /* Boolean */
static long          const* const* gppAutomaticDrivingImpact; /* Boolean */
static long          const* const* gppDoorCommandReferenceOpeningLeftSide;
static long          const* const* gppDoorCommandReferenceClosingLeftSide;
static long          const* const* gppDoorCommandReferenceOpeningRightSide;
static long          const* const* gppDoorCommandReferenceClosingRightSide;

/*-- Miscellanous --*/
#include "OMAPFrameFieldDescription.h"

/*================================ Function implementations ================================*/

/*---------------- Initialise -> Main  ----------------*/
/* Start_VariablesTraceability */
void Door_Main_Initialise(void){

  /*==== Local data ====*/

  /*==== Processing ====*/
  /*-- @Source=CC-Non_Vital-A437358-SwRS-0002 --*/
  Door_gTDStateLeftSide = Door_eState_Unknown;
  Door_gTDStateRightSide = Door_eState_Unknown;

  /*-- @Source=CC-Non_Vital-A437358-SwRS-0315 --*/
  Door_gCommandReferenceToATPRightSide = Door_eCommand_None;
  Door_gCommandReferenceToATPLeftSide = Door_eCommand_None;

  /*-- @Source=CC-Non_Vital-A437358-SwRS-0662 --*/
  ReferencePoints_Initialise1(&Door_gReferencePoints);

  gOpeningCommandLatencyLeftSide = 0;
  /*-- @Source=CC-Non_Vital-A437358-SwRS-0314 --*/
  gClosingCommandLatencyLeftSide = 0;
  /*-- @Source=CC-Non_Vital-A437358-SwRS-0132 --*/
  gReferenceRemainingTimeToCloseLeftSide = 0;

  gOpeningCommandLatencyRightSide = 0;
  /*-- @Source=CC-Non_Vital-A437358-SwRS-0314 --*/
  gClosingCommandLatencyRightSide = 0;
  /*-- @Source=CC-Non_Vital-A437358-SwRS-0132 --*/
  gReferenceRemainingTimeToCloseRightSide = 0;

  /*-- @Source=CC-Non_Vital-A437358-SwRS-0723 --*/
  Door_gManualDoorClosingManagement = 0; /* False */

  /*-- @Source=CC-Non_Vital-A437358-SwRS-0722 --*/
  Door_gManualDoorOpeningManagement = 0; /* False */

  /*-- Door command latency from setting --*/
  /*-- @Source=CC-Non_Vital-A437358-SwRS-0364 --*/
  gTDOpeningCommandLatency = EmbeddedSetting_ReadData(4,0);

  /*-- Door command latency from setting --*/
  /*-- @Source=CC-Non_Vital-A437358-SwRS-0364 --*/
  gTDClosingCommandLatency = EmbeddedSetting_ReadData(4,0);

  /*-- @Source=CC-Non_Vital-A437358-SwRS-1485 --*/  
  gPSDClosingCommandLatency = EmbeddedSetting_ReadData(4,0);

  /*-- Display anticipation of closing door command reference --*/
  /*-- @Source=CC-Non_Vital-A437358-SwRS-0373 --*/
  gDoorCommandReferenceAnticipation = EmbeddedSetting_ReadData(4,0);

  /*-- @Source=CC-Non_Vital-A437358-SwRS-0363 --*/
  gTrainDoorsManaged = 0; /* False */
  gppTrainDoorManaged = NCC_ppComputedData(EmbeddedSetting_ReadData(4,0));
   
  /*-- @Source=CC-Non_Vital-A437358-SwRS-0722 --*/
  gppManualDoorOpeningManagement = NCC_ppComputedData(EmbeddedSetting_ReadData(4,0));
  
  /*-- @Source=CC-Non_Vital-A437358-SwRS-0723 --*/
  gppManualDoorClosingManagement = NCC_ppComputedData(EmbeddedSetting_ReadData(4,0));   

  /*-- @Source=CC-Non_Vital-A437358-SwRS-0001 --*/
  Door_gTrainDoorClosedAndLockedLeftSide = 0; /* False */
  Door_gTrainDoorClosedAndLockedRightSide = 0; /* False */

  gpTrainDoorClosedAndLockedLeftSide = 0; /* Undefined */
  gppTrainDoorClosedAndLockedLeftSide = NCC_ppComputedData(EmbeddedSetting_ReadData(4,0));
  gTrainDoorClosedAndLockedLeftSideIsConstant = NCC_ComputedDataIsConstant(gppTrainDoorClosedAndLockedLeftSide);
  gpTrainDoorClosedAndLockedRightSide = 0; /* Undefined */
  gppTrainDoorClosedAndLockedRightSide = NCC_ppComputedData(EmbeddedSetting_ReadData(4,0));
  gTrainDoorClosedAndLockedRightSideIsConstant = NCC_ComputedDataIsConstant(gppTrainDoorClosedAndLockedRightSide);

  /*-- @Source=CC-Non_Vital-A437358-SwRS-1395 --*/  
  Door_gTrainDoorClosedAndLockedIsNotLateralised =
    (  (gppTrainDoorClosedAndLockedLeftSide)
     ==(gppTrainDoorClosedAndLockedRightSide)); 
  
  /*-- @Source=CC-Non_Vital-A437358-SwRS-1012 --*/
  gCommandReferenceToATPLeftSideOpening = 0; /* False */
  NCC_AddAlwaysDefinedInputData(&gCommandReferenceToATPLeftSideOpening,EmbeddedSetting_ReadData(4,0)); 
  /*-- @Source=CC-Non_Vital-A437358-SwRS-1013 --*/  
  gCommandReferenceToATPLeftSideClosing = 0; /* False */ 
  NCC_AddAlwaysDefinedInputData(&gCommandReferenceToATPLeftSideClosing ,EmbeddedSetting_ReadData(4,0));  
  /*-- @Source=CC-Non_Vital-A437358-SwRS-0369 --*/
  gCommandReferenceOpeningLeftSide = 0; /*False*/
  gppDoorCommandReferenceOpeningLeftSide = NCC_ppComputedData(EmbeddedSetting_ReadData(4,0));
  /*-- @Source=CC-Non_Vital-A437358-SwRS-1024 --*/   
  gCommandReferenceClosingLeftSide = 0; /*False*/
  gppDoorCommandReferenceClosingLeftSide = NCC_ppComputedData(EmbeddedSetting_ReadData(4,0));
  /*-- @Source=CC-Non_Vital-A437358-SwRS-1016 --*/ 
  gTDStateLeftSideUnknown  = 0; /* False */ 
  NCC_AddAlwaysDefinedInputData(&gTDStateLeftSideUnknown ,EmbeddedSetting_ReadData(4,0));
  /*-- @Source=CC-Non_Vital-A437358-SwRS-1014 --*/
  gTDStateLeftSideOpened   = 0; /* False */ 
  NCC_AddAlwaysDefinedInputData(&gTDStateLeftSideOpened  ,EmbeddedSetting_ReadData(4,0));
  /*-- @Source=CC-Non_Vital-A437358-SwRS-1015 --*/ 
  gTDStateLeftSideClosed   = 0; /* False */ 
  NCC_AddAlwaysDefinedInputData(&gTDStateLeftSideClosed  ,EmbeddedSetting_ReadData(4,0));
  /*-- @Source=CC-Non_Vital-A437358-SwRS-1012 --*/
  gCommandReferenceToATPRightSideOpening = 0; /* False */
  NCC_AddAlwaysDefinedInputData(&gCommandReferenceToATPRightSideOpening ,EmbeddedSetting_ReadData(4,0));
  /*-- @Source=CC-Non_Vital-A437358-SwRS-1013 --*/  
  gCommandReferenceToATPRightSideClosing = 0; /* False */ 
  NCC_AddAlwaysDefinedInputData(&gCommandReferenceToATPRightSideClosing ,EmbeddedSetting_ReadData(4,0));
  /*-- @Source=CC-Non_Vital-A437358-SwRS-0369 --*/
  gCommandReferenceOpeningRightSide = 0; /*False*/
  gppDoorCommandReferenceOpeningRightSide = NCC_ppComputedData(EmbeddedSetting_ReadData(4,0));
  /*-- @Source=CC-Non_Vital-A437358-SwRS-1024 --*/  
  gCommandReferenceClosingRightSide = 0; /*False*/ 
  gppDoorCommandReferenceClosingRightSide = NCC_ppComputedData(EmbeddedSetting_ReadData(4,0));
  /*-- @Source=CC-Non_Vital-A437358-SwRS-1016 --*/
  gTDStateRightSideUnknown  = 0; /* False */ 
  NCC_AddAlwaysDefinedInputData(&gTDStateRightSideUnknown ,EmbeddedSetting_ReadData(4,0));
  /*-- @Source=CC-Non_Vital-A437358-SwRS-1014 --*/
  gTDStateRightSideOpened   = 0; /* False */ 
  NCC_AddAlwaysDefinedInputData(&gTDStateRightSideOpened  ,EmbeddedSetting_ReadData(4,0));
  /*-- @Source=CC-Non_Vital-A437358-SwRS-1015 --*/ 
  gTDStateRightSideClosed   = 0; /* False */ 
  NCC_AddAlwaysDefinedInputData(&gTDStateRightSideClosed  ,EmbeddedSetting_ReadData(4,0));
  /*-- @Source=CC-Non_Vital-A437358-SwRS-1017 --*/
  gCommandReferenceToATPOpening   = 0; /* False */ 
  NCC_AddAlwaysDefinedInputData(&gCommandReferenceToATPOpening ,EmbeddedSetting_ReadData(4,0)); 
  /*-- @Source=CC-Non_Vital-A437358-SwRS-1018 --*/
  gCommandReferenceToATPClosing   = 0; /* False */
  NCC_AddAlwaysDefinedInputData(&gCommandReferenceToATPClosing ,EmbeddedSetting_ReadData(4,0)); 
  /*-- @Source=CC-Non_Vital-A437358-SwRS-1304 --*/
  gppAutomaticDrivingImpact = NCC_ppComputedData(EmbeddedSetting_ReadData(4,0));

  #include "OMAPSubscription.h"
}
/* End_VariablesTraceability */

/*---------------- Update -> Main  ----------------*/
void Door_Main_Update(void){

  /*==== Local data ====*/
  /*==== Processing ====*/
  /*-- Update NCC input --*/

  /*-- Doors managed --*/
  /*-- @Source=CC-Non_Vital-A437358-SwRS-0363 --*/
  NCC_ComputeData(gppTrainDoorManaged);
  gTrainDoorsManaged = *gppTrainDoorManaged ? **gppTrainDoorManaged : 0;
  /*-- @Source=CC-Non_Vital-A437358-SwRS-0722 --*/
  NCC_ComputeData(gppManualDoorOpeningManagement);
  Door_gManualDoorOpeningManagement = *gppManualDoorOpeningManagement ? **gppManualDoorOpeningManagement : 0;
  /*-- @Source=CC-Non_Vital-A437358-SwRS-0723 --*/
  NCC_ComputeData(gppManualDoorClosingManagement);
  Door_gManualDoorClosingManagement = *gppManualDoorClosingManagement ? **gppManualDoorClosingManagement : 0;

  /*-- @Source=CC-Non_Vital-A437358-SwRS-0001 --*/
  NCC_ComputeData(gppTrainDoorClosedAndLockedLeftSide);
  gpTrainDoorClosedAndLockedLeftSide = *gppTrainDoorClosedAndLockedLeftSide;
  Door_gTrainDoorClosedAndLockedLeftSide = (gpTrainDoorClosedAndLockedLeftSide)? *gpTrainDoorClosedAndLockedLeftSide : 0;
  NCC_ComputeData(gppTrainDoorClosedAndLockedRightSide);
  gpTrainDoorClosedAndLockedRightSide = *gppTrainDoorClosedAndLockedRightSide;
  Door_gTrainDoorClosedAndLockedRightSide = (gpTrainDoorClosedAndLockedRightSide)? *gpTrainDoorClosedAndLockedRightSide : 0;

  /*---- Left side ----*/
  /*-- Reference remaining time to close doors left side --*/
  /*-- @Source=CC-Non_Vital-A437358-SwRS-0132 --*/
  gReferenceRemainingTimeToCloseLeftSide =
      (OperationPlan_gCorrectDockingOnLeftSide)
    ? (   (OperationPlan_gpRemainingTimeReferenceToCommandTrainStart)
        ? *OperationPlan_gpRemainingTimeReferenceToCommandTrainStart
        : LONG_MAX)
    : 0;

  /*-- Closing command latency left side --*/
  /*-- @Source=CC-Non_Vital-A437358-SwRS-0314 --*/
  gClosingCommandLatencyLeftSide =
      (OperationPlan_gCorrectDockingOnLeftSide)
    ? LongMath_Max(
        gTDClosingCommandLatency,
        gPSDClosingCommandLatency)
    : gTDClosingCommandLatency;

  /*-- Command reference to driver left side --*/
  /*-- @Source=CC-Non_Vital-A437358-SwRS-0315 --*/
  if(!OperationPlan_gCorrectDockingOnLeftSide){
    Door_gCommandReferenceToATPLeftSide = Door_eCommand_None;
  }else if(gReferenceRemainingTimeToCloseLeftSide <= (gClosingCommandLatencyLeftSide + gDoorCommandReferenceAnticipation)){
    Door_gCommandReferenceToATPLeftSide = Door_eCommand_Closing;
  }else{
    Door_gCommandReferenceToATPLeftSide = Door_eCommand_Opening;
  }

  /*-- @Source=CC-Non_Vital-A437358-SwRS-1012 --*/
  gCommandReferenceToATPLeftSideOpening = (Door_gCommandReferenceToATPLeftSide == Door_eCommand_Opening);   
  /*-- @Source=CC-Non_Vital-A437358-SwRS-1013 --*/
  gCommandReferenceToATPLeftSideClosing = (Door_gCommandReferenceToATPLeftSide == Door_eCommand_Closing);

  /*-- Command reference left side --*/
  /*-- @Source=CC-Non_Vital-A437358-SwRS-0369 --*/
  NCC_ComputeData(gppDoorCommandReferenceOpeningLeftSide);
  gCommandReferenceOpeningLeftSide = *gppDoorCommandReferenceOpeningLeftSide ? **gppDoorCommandReferenceOpeningLeftSide : 0;
  /*-- @Source=CC-Non_Vital-A437358-SwRS-1024 --*/
  NCC_ComputeData(gppDoorCommandReferenceClosingLeftSide);
  gCommandReferenceClosingLeftSide = *gppDoorCommandReferenceClosingLeftSide ? **gppDoorCommandReferenceClosingLeftSide : 0;

  /*-- Train door state left side --*/
  /*-- @Source=CC-Non_Vital-A437358-SwRS-0002 --*/
  if(  (!gpTrainDoorClosedAndLockedLeftSide)
     ||(gTrainDoorClosedAndLockedLeftSideIsConstant)){
    Door_gTDStateLeftSide = Door_eState_Unknown;
  }else if(*gpTrainDoorClosedAndLockedLeftSide){
    Door_gTDStateLeftSide = Door_eState_Closed;
  }else{
    Door_gTDStateLeftSide = Door_eState_Opened;
  }

  /*-- @Source=CC-Non_Vital-A437358-SwRS-1016 --*/
  gTDStateLeftSideUnknown = (Door_gTDStateLeftSide == Door_eState_Unknown);
  /*-- @Source=CC-Non_Vital-A437358-SwRS-1014 --*/
  gTDStateLeftSideOpened  = (Door_gTDStateLeftSide == Door_eState_Opened);
  /*-- @Source=CC-Non_Vital-A437358-SwRS-1015 --*/
  gTDStateLeftSideClosed  = (Door_gTDStateLeftSide == Door_eState_Closed);


  /*---- Right side ----*/
  /*-- Reference remaining time to close doors right side --*/
  /*-- @Source=CC-Non_Vital-A437358-SwRS-0132 --*/
  gReferenceRemainingTimeToCloseRightSide =
      (OperationPlan_gCorrectDockingOnRightSide)
    ? (   (OperationPlan_gpRemainingTimeReferenceToCommandTrainStart)
        ?  *OperationPlan_gpRemainingTimeReferenceToCommandTrainStart
        : LONG_MAX)
    : 0;

  /*-- Closing command latency right side --*/
  /*-- @Source=CC-Non_Vital-A437358-SwRS-0314 --*/
  gClosingCommandLatencyRightSide =
      (OperationPlan_gCorrectDockingOnRightSide)
    ? LongMath_Max(
        gTDClosingCommandLatency,
        gPSDClosingCommandLatency)
    : gTDClosingCommandLatency;

  /*-- Command reference to driver right side --*/
  /*-- @Source=CC-Non_Vital-A437358-SwRS-0315 --*/
  if(!OperationPlan_gCorrectDockingOnRightSide){
    Door_gCommandReferenceToATPRightSide = Door_eCommand_None;
  }else if(gReferenceRemainingTimeToCloseRightSide <= (gClosingCommandLatencyRightSide + gDoorCommandReferenceAnticipation)){
   Door_gCommandReferenceToATPRightSide = Door_eCommand_Closing;
  }else{
    Door_gCommandReferenceToATPRightSide = Door_eCommand_Opening;
  }

  /*-- @Source=CC-Non_Vital-A437358-SwRS-1012 --*/
  gCommandReferenceToATPRightSideOpening = (Door_gCommandReferenceToATPRightSide == Door_eCommand_Opening);   
  /*-- @Source=CC-Non_Vital-A437358-SwRS-1013 --*/
  gCommandReferenceToATPRightSideClosing = (Door_gCommandReferenceToATPRightSide == Door_eCommand_Closing);

  /*-- Command reference right side  --*/
  /*-- @Source=CC-Non_Vital-A437358-SwRS-0369 --*/
  NCC_ComputeData(gppDoorCommandReferenceOpeningRightSide);
  gCommandReferenceOpeningRightSide = *gppDoorCommandReferenceOpeningRightSide ? **gppDoorCommandReferenceOpeningRightSide : 0;
  /*-- @Source=CC-Non_Vital-A437358-SwRS-1024 --*/
  NCC_ComputeData(gppDoorCommandReferenceClosingRightSide);
  gCommandReferenceClosingRightSide = *gppDoorCommandReferenceClosingRightSide ? **gppDoorCommandReferenceClosingRightSide : 0;  
  
  /*-- Train door state right side --*/
  /*-- @Source=CC-Non_Vital-A437358-SwRS-0002 --*/
  if(  (!gpTrainDoorClosedAndLockedRightSide)
     ||(gTrainDoorClosedAndLockedRightSideIsConstant)){
    Door_gTDStateRightSide = Door_eState_Unknown;
  }else if(*gpTrainDoorClosedAndLockedRightSide){
    Door_gTDStateRightSide = Door_eState_Closed;
  }else{
    Door_gTDStateRightSide = Door_eState_Opened;
  }

  /*-- @Source=CC-Non_Vital-A437358-SwRS-1016 --*/
  gTDStateRightSideUnknown = (Door_gTDStateRightSide == Door_eState_Unknown);
  /*-- @Source=CC-Non_Vital-A437358-SwRS-1014 --*/
  gTDStateRightSideOpened  = (Door_gTDStateRightSide == Door_eState_Opened);
  /*-- @Source=CC-Non_Vital-A437358-SwRS-1015 --*/
  gTDStateRightSideClosed  = (Door_gTDStateRightSide == Door_eState_Closed);

  /*-- Command reference Opening/Closing --*/
  /*-- @Source=CC-Non_Vital-A437358-SwRS-1017 --*/
  gCommandReferenceToATPOpening = gCommandReferenceToATPLeftSideOpening || gCommandReferenceToATPRightSideOpening;
  /*-- @Source=CC-Non_Vital-A437358-SwRS-1018 --*/
  gCommandReferenceToATPClosing = gCommandReferenceToATPLeftSideClosing || gCommandReferenceToATPRightSideClosing;

  /*---- Compute reference points for driving and vital sanction ----*/
  /*-- @Source=CC-Non_Vital-A437358-SwRS-0662 --*/
  ReferencePoints_Initialise1(&Door_gReferencePoints);
  if(  (Kinematics_gConsolidatedFilteredStop)
     &&(  (Door_gTDStateLeftSide == Door_eState_Opened)
        ||(Door_gTDStateRightSide == Door_eState_Opened))){
    KinematicsReferencePoint_AddObject(
      (ReferencePoints_tObjectx50*)&Door_gReferencePoints,
      ReferencePoint_eType_ImmobilisationKinematics,
      0,
      0,
      DrivingCommand_gImmobilisationCommandAcceleration);
  }

  /*-- @Source=CC-Non_Vital-A437358-SwRS-1304 --*/
  NCC_ComputeData(gppAutomaticDrivingImpact);
  
  /*---- Reference points sources ------*/
  if(  (*gppAutomaticDrivingImpact)/* Defined */
     &&(**gppAutomaticDrivingImpact)){ /* True */
    DrivingReference_AddReferencePointsSource((ReferencePoints_tObjectx50*)&Door_gReferencePoints,ReferencePoints_deSource_Door);
    Start_AddReferencePointsSource((ReferencePoints_tObjectx50*)&Door_gReferencePoints,ReferencePoints_deSource_Door);
    SwitchFromManualToAutomaticDriving_AddReferencePointsSource((ReferencePoints_tObjectx50*)&Door_gReferencePoints,ReferencePoints_deSource_Door);
  }
  NoSanctionReferenceToDriver_AddReferencePointsSource((ReferencePoints_tObjectx50*)&Door_gReferencePoints,0,ReferencePoints_deSource_Door);
  
}
