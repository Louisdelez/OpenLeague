package com.riotgames.pvpnet.cap.actions.responses
{
   import com.riotgames.platform.common.provider.IInventoryController;
   import com.riotgames.platform.common.utils.decode.IDecode;
   import com.riotgames.pvpnet.cap.controllers.CapLobbyTimerController;
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   
   public class BaseCapUpdateGroupV3Action extends CapUpdatePlayerSelectionsV1Action
   {
      
      public static const METHOD_NAME:String = "groupUpdatedV3";
      
      public static const GROUP_ID_KEY:String = "groupId";
      
      public static const SLOT_ID_KEY:String = "slotId";
      
      public static const TTL_KEY:String = "groupTtlSecs";
      
      private var lobbyTimerController:CapLobbyTimerController;
      
      public function BaseCapUpdateGroupV3Action(param1:String, param2:CapModel, param3:IDecode, param4:IInventoryController, param5:CapLobbyTimerController)
      {
         this.lobbyTimerController = param5;
         super(param1,param2,param3,param4);
      }
      
      override protected function doDecode(param1:Object) : void
      {
         if(param1.hasOwnProperty(GROUP_ID_KEY))
         {
            _model.groupId = param1[GROUP_ID_KEY];
         }
         if(param1.hasOwnProperty(SLOT_ID_KEY))
         {
            _model.localPlayerSelection.slotId = param1[SLOT_ID_KEY];
         }
         if(param1.hasOwnProperty(TTL_KEY))
         {
            this.lobbyTimerController.startTimerFromSeconds(param1[TTL_KEY]);
         }
         super.doDecode(param1);
      }
      
      override protected function updatePlayerSelection(param1:CapPlayerSelection, param2:Object) : void
      {
         super.updatePlayerSelection(param1,param2);
         if(param1.isCandidate)
         {
            param1.currentState = param1.champion != null ? CapPlayerSelection.FOUND_STATE : CapPlayerSelection.SEARCHING_STATE;
         }
         param1.isPopulated = true;
      }
   }
}

