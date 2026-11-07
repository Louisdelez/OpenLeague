package com.riotgames.pvpnet.cap.actions.responses
{
   import com.riotgames.platform.common.provider.IInventoryController;
   import com.riotgames.platform.common.utils.decode.IDecode;
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   
   public class CapCandidateJoinedV1Action extends CapUpdatePlayerSelectionsV1Action
   {
      
      public static const METHOD_NAME:String = "candidateJoinedV1";
      
      public function CapCandidateJoinedV1Action(param1:String, param2:CapModel, param3:IDecode, param4:IInventoryController)
      {
         super(param1,param2,param3,param4);
      }
      
      override protected function updatePlayerSelection(param1:CapPlayerSelection, param2:Object) : void
      {
         super.updatePlayerSelection(param1,param2);
         if(param1.isCandidate)
         {
            param1.currentState = CapPlayerSelection.FOUND_STATE;
            param1.rolePositionLocked = true;
         }
         param1.isInvitedPlayer = false;
      }
   }
}

