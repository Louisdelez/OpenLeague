package com.riotgames.pvpnet.cap.factory.response
{
   import blix.action.IAction;
   import blix.action.NoopAction;
   import com.riotgames.platform.common.provider.IInventoryController;
   import com.riotgames.platform.common.provider.ISoundProvider;
   import com.riotgames.platform.common.services.lcdsproxy.responses.factory.ILcdsProxyMessageActionFactory;
   import com.riotgames.platform.common.utils.decode.IDecode;
   import com.riotgames.platform.gameclient.chat.IChatProvider;
   import com.riotgames.platform.gameclient.chat.INotificationsProvider;
   import com.riotgames.pvpnet.cap.actions.responses.BaseCapUpdateGroupV3Action;
   import com.riotgames.pvpnet.cap.actions.responses.CapAcceptedByGroupV2Action;
   import com.riotgames.pvpnet.cap.actions.responses.CapCandidateAcceptedV1Action;
   import com.riotgames.pvpnet.cap.actions.responses.CapCandidateDeclinedGroupV2Action;
   import com.riotgames.pvpnet.cap.actions.responses.CapCandidateDeclinedV2Action;
   import com.riotgames.pvpnet.cap.actions.responses.CapCandidateFoundV2Action;
   import com.riotgames.pvpnet.cap.actions.responses.CapCandidateJoinedV1Action;
   import com.riotgames.pvpnet.cap.actions.responses.CapEstimatedWaitTimeRetrievedV1;
   import com.riotgames.pvpnet.cap.actions.responses.CapFeatureTogglesRetrievedAction;
   import com.riotgames.pvpnet.cap.actions.responses.CapGameStartFailedV1Action;
   import com.riotgames.pvpnet.cap.actions.responses.CapGatekeeperRestrictedV1Action;
   import com.riotgames.pvpnet.cap.actions.responses.CapGroupCreatedV3Action;
   import com.riotgames.pvpnet.cap.actions.responses.CapGroupNoLongerAvailableV1Action;
   import com.riotgames.pvpnet.cap.actions.responses.CapInfoRetrievedV1;
   import com.riotgames.pvpnet.cap.actions.responses.CapInfoRetrievedV2;
   import com.riotgames.pvpnet.cap.actions.responses.CapMatchMadeV1Action;
   import com.riotgames.pvpnet.cap.actions.responses.CapMatchmakingPhaseStartedV1Action;
   import com.riotgames.pvpnet.cap.actions.responses.CapPlayerRemovedV3Action;
   import com.riotgames.pvpnet.cap.actions.responses.CapQuitDeniedV1;
   import com.riotgames.pvpnet.cap.actions.responses.CapReadinessIndicatedV1Action;
   import com.riotgames.pvpnet.cap.actions.responses.CapRemovedFromServiceV1;
   import com.riotgames.pvpnet.cap.actions.responses.CapSlotPopulatedV1Action;
   import com.riotgames.pvpnet.cap.actions.responses.CapSoloQueryCreatedV1Action;
   import com.riotgames.pvpnet.cap.actions.responses.CapSoloSearchedForAnotherGroupV2Action;
   import com.riotgames.pvpnet.cap.actions.responses.CapUpdatePlayerSelectionsV1Action;
   import com.riotgames.pvpnet.cap.actions.responses.CapUpdateToCandidateSpecPhaseV2Action;
   import com.riotgames.pvpnet.cap.actions.responses.CapUpdateToSearchForCandidatesPhaseV1Action;
   import com.riotgames.pvpnet.cap.controllers.CapLobbyTimerController;
   import com.riotgames.pvpnet.cap.controllers.CapTimerController;
   import com.riotgames.pvpnet.cap.controllers.ICapController;
   import com.riotgames.pvpnet.cap.faults.CapFaults;
   import com.riotgames.pvpnet.cap.mediators.CapViewMediator;
   import com.riotgames.pvpnet.cap.model.CapEstimatedWaitTimeCache;
   import com.riotgames.pvpnet.cap.model.CapPlayAgainModel;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.game.controllers.lobby.ILobbyViewController;
   import com.riotgames.pvpnet.invite.IInviteController;
   import com.riotgames.pvpnet.invite.model.InviteGroup;
   
   public class BaseCapMessageActionFactory implements ILcdsProxyMessageActionFactory
   {
      
      protected var _timerController:CapTimerController;
      
      protected var _estimatedWaitTimeCache:CapEstimatedWaitTimeCache;
      
      protected var _decoder:IDecode;
      
      protected var _chatProvider:IChatProvider;
      
      protected var _lobbyController:ILobbyViewController;
      
      protected var _capController:ICapController;
      
      protected var _dockedNotificationsProvider:INotificationsProvider;
      
      protected var _inventoryController:IInventoryController;
      
      protected var _playAgainModel:CapPlayAgainModel;
      
      protected var _viewMediator:CapViewMediator;
      
      protected var _soundProvider:ISoundProvider;
      
      protected var _inviteController:IInviteController;
      
      protected var _lobbyTimerController:CapLobbyTimerController;
      
      protected var _model:CapModel;
      
      protected var _inviteGroup:InviteGroup;
      
      public function BaseCapMessageActionFactory(param1:CapModel, param2:CapPlayAgainModel, param3:ILobbyViewController, param4:IDecode, param5:IInventoryController, param6:IInviteController, param7:InviteGroup, param8:ISoundProvider, param9:CapViewMediator, param10:INotificationsProvider, param11:CapLobbyTimerController, param12:CapTimerController, param13:CapEstimatedWaitTimeCache, param14:IChatProvider, param15:ICapController)
      {
         super();
         this._model = param1;
         this._playAgainModel = param2;
         this._decoder = param4;
         this._lobbyController = param3;
         this._inventoryController = param5;
         this._inviteController = param6;
         this._inviteGroup = param7;
         this._viewMediator = param9;
         this._dockedNotificationsProvider = param10;
         this._lobbyTimerController = param11;
         this._timerController = param12;
         this._estimatedWaitTimeCache = param13;
         this._chatProvider = param14;
         this._capController = param15;
         this._soundProvider = param8;
      }
      
      public function createAction(param1:String, param2:String) : IAction
      {
         var _loc3_:IAction = this.doCreateAction(param1,param2);
         if(_loc3_ == null)
         {
            throw new Error("Unable to process method: " + param1);
         }
         this.wireServiceCallErrorMessage(_loc3_);
         return _loc3_;
      }
      
      protected function createSoloSearchedForAnotherGroupV2Action(param1:String) : IAction
      {
         throw new Error("Unimplemented");
      }
      
      protected function createPlayerRemovedV3Action(param1:String) : IAction
      {
         throw new Error("Unimplemented");
      }
      
      private function wireServiceCallErrorMessage(param1:IAction) : void
      {
         var action:IAction = param1;
         action.getErred().addOnce(function():void
         {
            CapFaults.displayErrorAlert(action.getError());
         });
      }
      
      protected function createUpdateToSoloSpecPhaseAction(param1:String) : IAction
      {
         throw new Error("Unimplemented");
      }
      
      protected function createUpdateGroupAction(param1:String) : IAction
      {
         throw new Error("Unimplemented");
      }
      
      private function doCreateAction(param1:String, param2:String) : IAction
      {
         switch(param1)
         {
            case BaseCapUpdateGroupV3Action.METHOD_NAME:
               return this.createUpdateGroupAction(param2);
            case CapPlayerRemovedV3Action.PLAYER_REMOVED_METHOD_NAME:
               return this.createPlayerRemovedV3Action(param2);
            case CapSoloSearchedForAnotherGroupV2Action.METHOD_NAME:
               return this.createSoloSearchedForAnotherGroupV2Action(param2);
            case CapUpdateToCandidateSpecPhaseV2Action.METHOD_NAME:
               return this.createUpdateToSoloSpecPhaseAction(param2);
            case CapUpdateToSearchForCandidatesPhaseV1Action.METHOD_NAME:
               return this.createUpdateToSearchForSolosPhaseAction(param2);
            case CapReadinessIndicatedV1Action.METHOD_NAME:
               return new CapReadinessIndicatedV1Action(param2,this._model,this._decoder);
            case CapCandidateJoinedV1Action.METHOD_NAME:
               return new CapCandidateJoinedV1Action(param2,this._model,this._decoder,this._inventoryController);
            case CapCandidateAcceptedV1Action.METHOD_NAME:
               return new CapCandidateAcceptedV1Action(param2,this._model,this._decoder,this._inventoryController);
            case CapSlotPopulatedV1Action.METHOD_NAME:
               return new CapSlotPopulatedV1Action(param2,this._model,this._decoder,this._inventoryController);
            case CapUpdatePlayerSelectionsV1Action.ADVERTISED_ROLE_PICKED_METHOD_NAME:
            case CapUpdatePlayerSelectionsV1Action.ADVERTISED_POSITION_PICKED_METHOD_NAME:
            case CapUpdatePlayerSelectionsV1Action.CHAMPION_PICKED_METHOD_NAME:
            case CapUpdatePlayerSelectionsV1Action.SKIN_PICKED_METHOD_NAME:
            case CapUpdatePlayerSelectionsV1Action.ROLE_PICKED_METHOD_NAME:
            case CapUpdatePlayerSelectionsV1Action.POSITION_PICKED_METHOD_NAME:
               return new CapUpdatePlayerSelectionsV1Action(param2,this._model,this._decoder,this._inventoryController);
            case CapUpdatePlayerSpellSelectionsV1Action.UPDATE_SPELLS_METHOD_NAME:
               return new CapUpdatePlayerSpellSelectionsV1Action(param2,this._model,this._decoder,this._inventoryController,this._capController);
            case CapCandidateFoundV2Action.METHOD_NAME:
               return new CapCandidateFoundV2Action(param2,this._model,this._decoder,this._inventoryController,this._soundProvider);
            case CapAcceptedByGroupV2Action.METHOD_NAME:
               return new CapAcceptedByGroupV2Action(this._model,this._timerController,this._capController,this._decoder,param2);
            case CapGroupNoLongerAvailableV1Action.METHOD_NAME:
               return new CapGroupNoLongerAvailableV1Action(this._decoder);
            case CapCandidateDeclinedV2Action.METHOD_NAME:
               return new CapCandidateDeclinedV2Action(param2,this._model,this._decoder);
            case CapCandidateDeclinedGroupV2Action.METHOD_NAME:
               return new CapCandidateDeclinedGroupV2Action(param2,this._model,this._decoder,this._soundProvider);
            case CapMatchMadeV1Action.METHOD_NAME:
               return new CapMatchMadeV1Action(this._model,this._playAgainModel,this._decoder,param2,this._chatProvider,this._inviteGroup,this._capController);
            case CapInfoRetrievedV1.METHOD_NAME:
               return new CapInfoRetrievedV1(this._model,this._inventoryController.inventory,this._decoder,param2);
            case CapInfoRetrievedV2.METHOD_NAME:
               return new CapInfoRetrievedV2(this._model,this._inventoryController.inventory,this._viewMediator,this._decoder,param2);
            case CapGroupCreatedV3Action.METHOD_NAME:
               return new CapGroupCreatedV3Action(this._model,this._decoder,this._lobbyTimerController,this._inviteGroup,param2);
            case CapMatchmakingPhaseStartedV1Action.METHOD_NAME:
               return new CapMatchmakingPhaseStartedV1Action(this._model,this._decoder,param2);
            case CapRemovedFromServiceV1.METHOD_NAME:
               return new CapRemovedFromServiceV1(this._model,this._decoder,this._dockedNotificationsProvider,this._lobbyTimerController,this._capController,param2);
            case CapEstimatedWaitTimeRetrievedV1.METHOD_NAME:
               return new CapEstimatedWaitTimeRetrievedV1(this._model,this._decoder,this._estimatedWaitTimeCache,param2);
            case CapGameStartFailedV1Action.METHOD_NAME:
               return new CapGameStartFailedV1Action(this._model,this._decoder,this._capController);
            case CapFeatureTogglesRetrievedAction.METHOD_NAME:
               return new CapFeatureTogglesRetrievedAction(this._model,this._decoder,param2);
            case CapSoloQueryCreatedV1Action.METHOD_NAME:
               return new CapSoloQueryCreatedV1Action(this._model,this._decoder);
            case CapGatekeeperRestrictedV1Action.METHOD_NAME:
               return new CapGatekeeperRestrictedV1Action(this._model,this._decoder,this._capController,param2);
            case CapQuitDeniedV1.METHOD_NAME:
               return new CapQuitDeniedV1(this._model,this._decoder);
            default:
               return new NoopAction();
         }
      }
      
      protected function createUpdateToSearchForSolosPhaseAction(param1:String) : IAction
      {
         throw new Error("Unimplemented");
      }
   }
}

