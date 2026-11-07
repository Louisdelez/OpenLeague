package com.riotgames.pvpnet.cap.actions.responses.invitee
{
   import com.riotgames.platform.common.provider.IInventoryController;
   import com.riotgames.platform.common.utils.decode.IDecode;
   import com.riotgames.pvpnet.cap.actions.responses.BaseCapUpdateGroupV3Action;
   import com.riotgames.pvpnet.cap.controllers.CapLobbyTimerController;
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   
   public class CapUpdateGroupAsInviteeV1Action extends BaseCapUpdateGroupV3Action
   {
      
      public function CapUpdateGroupAsInviteeV1Action(param1:String, param2:CapModel, param3:IDecode, param4:IInventoryController, param5:CapLobbyTimerController)
      {
         super(param1,param2,param3,param4,param5);
      }
      
      override protected function updatePlayerSelection(param1:CapPlayerSelection, param2:Object) : void
      {
         super.updatePlayerSelection(param1,param2);
         param1.isInvitedPlayer = true;
         param1.rolePositionLocked = false;
      }
   }
}

