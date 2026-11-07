package com.riotgames.pvpnet.cap.factory.response
{
   import blix.action.IAction;
   import com.riotgames.platform.common.provider.IInventoryController;
   import com.riotgames.platform.common.provider.ISoundProvider;
   import com.riotgames.platform.common.utils.decode.IDecode;
   import com.riotgames.platform.gameclient.chat.IChatProvider;
   import com.riotgames.platform.gameclient.chat.INotificationsProvider;
   import com.riotgames.pvpnet.cap.actions.responses.CapSoloSearchedForAnotherGroupV2Action;
   import com.riotgames.pvpnet.cap.actions.responses.solo.CapPlayerRemovedAsSoloV3Action;
   import com.riotgames.pvpnet.cap.actions.responses.solo.CapUpdateGroupAsSoloV1Action;
   import com.riotgames.pvpnet.cap.controllers.CapLobbyTimerController;
   import com.riotgames.pvpnet.cap.controllers.CapTimerController;
   import com.riotgames.pvpnet.cap.controllers.ICapController;
   import com.riotgames.pvpnet.cap.mediators.CapViewMediator;
   import com.riotgames.pvpnet.cap.model.CapEstimatedWaitTimeCache;
   import com.riotgames.pvpnet.cap.model.CapPlayAgainModel;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.game.controllers.lobby.ILobbyViewController;
   import com.riotgames.pvpnet.invite.IInviteController;
   import com.riotgames.pvpnet.invite.model.InviteGroup;
   
   public class CapSoloMessageActionFactory extends BaseCapMessageActionFactory
   {
      
      public function CapSoloMessageActionFactory(param1:CapModel, param2:CapPlayAgainModel, param3:ILobbyViewController, param4:IDecode, param5:IInventoryController, param6:IInviteController, param7:InviteGroup, param8:ISoundProvider, param9:CapViewMediator, param10:INotificationsProvider, param11:CapLobbyTimerController, param12:CapTimerController, param13:CapEstimatedWaitTimeCache, param14:IChatProvider, param15:ICapController)
      {
         super(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11,param12,param13,param14,param15);
      }
      
      override protected function createUpdateGroupAction(param1:String) : IAction
      {
         return new CapUpdateGroupAsSoloV1Action(param1,_model,_decoder,_inventoryController,_lobbyTimerController);
      }
      
      override protected function createUpdateToSearchForSolosPhaseAction(param1:String) : IAction
      {
         throw new Error("Unexpected message received");
      }
      
      override protected function createSoloSearchedForAnotherGroupV2Action(param1:String) : IAction
      {
         return new CapSoloSearchedForAnotherGroupV2Action(_model,_dockedNotificationsProvider,_decoder,param1);
      }
      
      override protected function createPlayerRemovedV3Action(param1:String) : IAction
      {
         return new CapPlayerRemovedAsSoloV3Action(_model,_decoder,param1);
      }
      
      override protected function createUpdateToSoloSpecPhaseAction(param1:String) : IAction
      {
         throw new Error("Unexpected message received");
      }
   }
}

