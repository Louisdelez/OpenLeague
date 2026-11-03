package com.riotgames.pvpnet.cap.factory
{
   import blix.action.IAction;
   import com.riotgames.platform.common.provider.IInventory;
   import com.riotgames.platform.common.services.lcdsproxy.ILcdsProxyServiceMessenger;
   import com.riotgames.platform.common.services.lcdsproxy.servicecalls.ILcdsProxyServiceCall;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.common.utils.decode.IDecode;
   import com.riotgames.platform.common.utils.encode.IEncode;
   import com.riotgames.platform.gameclient.chat.IChatProvider;
   import com.riotgames.platform.gameclient.chat.INotificationsProvider;
   import com.riotgames.platform.gameclient.chat.actions.DockedPromptAction;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.ChampionSkin;
   import com.riotgames.platform.gameclient.domain.Spell;
   import com.riotgames.platform.gameclient.domain.SpellBookPageDTO;
   import com.riotgames.platform.gameclient.domain.game.GameType;
   import com.riotgames.platform.gameclient.domain.game.GameViewState;
   import com.riotgames.platform.gameclient.services.SpellBookService;
   import com.riotgames.platform.masteries.IMasteriesProvider;
   import com.riotgames.platform.masteries.objects.MasteryPageInfoSummary;
   import com.riotgames.pvpnet.cap.actions.CapConfirmQuitAction;
   import com.riotgames.pvpnet.cap.actions.CapHideViewAction;
   import com.riotgames.pvpnet.cap.actions.CapInviteAction;
   import com.riotgames.pvpnet.cap.actions.CapRevealNextAvailableSlotAction;
   import com.riotgames.pvpnet.cap.actions.CapSelectMasteryPageAction;
   import com.riotgames.pvpnet.cap.actions.CapSelectRunePageAction;
   import com.riotgames.pvpnet.cap.actions.CapStatusMessageAction;
   import com.riotgames.pvpnet.cap.actions.CapTrackDemandBoardMetricsAction;
   import com.riotgames.pvpnet.cap.actions.CapTrackEnhancedPlayAgainMetricsAction;
   import com.riotgames.pvpnet.cap.actions.ConfigureMasterGameControllerAction;
   import com.riotgames.pvpnet.cap.actions.servicecalls.async.CapAcceptCandidateServiceCall;
   import com.riotgames.pvpnet.cap.actions.servicecalls.async.CapCreateGroupV3ServiceCall;
   import com.riotgames.pvpnet.cap.actions.servicecalls.async.CapCreateSoloQueryV4ServiceCall;
   import com.riotgames.pvpnet.cap.actions.servicecalls.async.CapDeclineCandidateServiceCall;
   import com.riotgames.pvpnet.cap.actions.servicecalls.async.CapIndicateGroupAcceptAsCandidateServiceCall;
   import com.riotgames.pvpnet.cap.actions.servicecalls.async.CapIndicateGroupDeclineAsCandidateServiceCall;
   import com.riotgames.pvpnet.cap.actions.servicecalls.async.CapIndicateReadinessServiceCall;
   import com.riotgames.pvpnet.cap.actions.servicecalls.async.CapJoinGroupAsInviteeServiceCall;
   import com.riotgames.pvpnet.cap.actions.servicecalls.async.CapKickPlayerV1ServiceCall;
   import com.riotgames.pvpnet.cap.actions.servicecalls.async.CapQuitServiceCall;
   import com.riotgames.pvpnet.cap.actions.servicecalls.async.CapRetrieveEstimatedWaitTimeV2ServiceCall;
   import com.riotgames.pvpnet.cap.actions.servicecalls.async.CapRetrieveFeatureTogglesServiceCall;
   import com.riotgames.pvpnet.cap.actions.servicecalls.async.CapRetrieveInfoV1;
   import com.riotgames.pvpnet.cap.actions.servicecalls.async.CapSearchForAnotherGroupServiceCall;
   import com.riotgames.pvpnet.cap.actions.servicecalls.async.CapSearchForCandidatesServiceCall;
   import com.riotgames.pvpnet.cap.actions.servicecalls.async.CapSelectAdvertisedPositionServiceCall;
   import com.riotgames.pvpnet.cap.actions.servicecalls.async.CapSelectAdvertisedRoleServiceCall;
   import com.riotgames.pvpnet.cap.actions.servicecalls.async.CapSelectChampionServiceCall;
   import com.riotgames.pvpnet.cap.actions.servicecalls.async.CapSelectPositionServiceCall;
   import com.riotgames.pvpnet.cap.actions.servicecalls.async.CapSelectRoleServiceCall;
   import com.riotgames.pvpnet.cap.actions.servicecalls.async.CapSelectSkinV2ServiceCall;
   import com.riotgames.pvpnet.cap.actions.servicecalls.async.CapSelectSpellsServiceCall;
   import com.riotgames.pvpnet.cap.actions.servicecalls.async.CapSpecCandidatesServiceCall;
   import com.riotgames.pvpnet.cap.actions.servicecalls.async.CapStartMatchmakingPhaseServiceCall;
   import com.riotgames.pvpnet.cap.faults.CapFaults;
   import com.riotgames.pvpnet.cap.model.CapDemandBoardMetrics;
   import com.riotgames.pvpnet.cap.model.CapPlayAgainMetrics;
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.model.CapPosition;
   import com.riotgames.pvpnet.cap.model.CapRole;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.game.IGamePreparationDelegate;
   import com.riotgames.pvpnet.game.controllers.IMasterGameController;
   import com.riotgames.pvpnet.game.controllers.lobby.ILobbyViewController;
   import com.riotgames.pvpnet.invite.IInviteProvider;
   import com.riotgames.pvpnet.invite.model.InviteGroup;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   
   public class CapActionFactory implements ICapActionFactory
   {
      
      private var dockedNotificationsProvider:INotificationsProvider;
      
      private var lobbyController:ILobbyViewController;
      
      private var chatController:IChatProvider;
      
      private var inviteProvider:IInviteProvider;
      
      private var encoder:IEncode;
      
      protected var model:CapModel;
      
      private var _gamePreparationDelegate:IGamePreparationDelegate;
      
      private var masterGameController:IMasterGameController;
      
      private var service:ILcdsProxyServiceMessenger;
      
      private var spellBookService:SpellBookService;
      
      private var masteriesProvider:IMasteriesProvider;
      
      private var decoder:IDecode;
      
      private var inventory:IInventory;
      
      public function CapActionFactory(param1:CapModel, param2:ILcdsProxyServiceMessenger, param3:IInventory, param4:IMasterGameController, param5:ILobbyViewController, param6:IInviteProvider, param7:IChatProvider, param8:IEncode, param9:IDecode, param10:IMasteriesProvider, param11:SpellBookService, param12:INotificationsProvider, param13:IGamePreparationDelegate)
      {
         super();
         this.model = param1;
         this.service = param2;
         this.encoder = param8;
         this.decoder = param9;
         this.inventory = param3;
         this.lobbyController = param5;
         this.masterGameController = param4;
         this.chatController = param7;
         this.inviteProvider = param6;
         this.masteriesProvider = param10;
         this.spellBookService = param11;
         this.dockedNotificationsProvider = param12;
         this._gamePreparationDelegate = param13;
      }
      
      public function getRetrieveEstimatedWaitTimeAction(param1:Champion, param2:CapRole, param3:CapPosition, param4:int) : IAction
      {
         return new CapRetrieveEstimatedWaitTimeV2ServiceCall(param1,param2,param3,param4,this.service,this.encoder);
      }
      
      public function getIndicateReadinessAction(param1:Boolean) : IAction
      {
         var _loc2_:ILcdsProxyServiceCall = new CapIndicateReadinessServiceCall(this.service,this.encoder,param1);
         this.wireServiceCallErrorMessage(_loc2_);
         return _loc2_;
      }
      
      public function getSelectMasteryPageAction(param1:MasteryPageInfoSummary) : IAction
      {
         return new CapSelectMasteryPageAction(param1,this.masteriesProvider,this.model.localPlayerSelection);
      }
      
      public function getTrackDemandBoardMetricsAction() : IAction
      {
         var _loc1_:CapDemandBoardMetricsFactory = new CapDemandBoardMetricsFactory();
         var _loc2_:CapPlayerSelection = this.model.localPlayerSelection;
         var _loc3_:Date = new Date();
         var _loc4_:CapDemandBoardMetrics = _loc1_.createDemandBoardMetrics(Session.instance,ClientConfig.instance,this.model.demandedSpecs,_loc2_.champion,_loc2_.role,_loc2_.position,this.model.numDemandBoardClicks,this.model.creatingSoloQuery);
         return new CapTrackDemandBoardMetricsAction(_loc4_);
      }
      
      public function getDeclineCandidateServiceCall(param1:Number) : IAction
      {
         var _loc2_:ILcdsProxyServiceCall = new CapDeclineCandidateServiceCall(param1,this.service,this.encoder);
         this.wireServiceCallErrorMessage(_loc2_);
         return _loc2_;
      }
      
      public function getSelectChampionAction(param1:Champion) : IAction
      {
         var _loc2_:ILcdsProxyServiceCall = new CapSelectChampionServiceCall(param1,this.service,this.encoder,this.model);
         this.wireServiceCallErrorMessage(_loc2_);
         return _loc2_;
      }
      
      public function getSearchForAnotherGroupServiceCall() : IAction
      {
         var _loc1_:ILcdsProxyServiceCall = new CapSearchForAnotherGroupServiceCall(this.service,this.encoder);
         this.wireServiceCallErrorMessage(_loc1_);
         return _loc1_;
      }
      
      public function getConfirmQuitAction(param1:Boolean) : IAction
      {
         return new CapConfirmQuitAction(this.model,this,param1);
      }
      
      public function getRetrievePlayerInfoAction(param1:int) : IAction
      {
         var _loc2_:ILcdsProxyServiceCall = new CapRetrieveInfoV1(this.model,param1,this.service,this.encoder);
         this.wireServiceCallErrorMessage(_loc2_);
         return _loc2_;
      }
      
      public function getSearchForCandidatesAction() : IAction
      {
         var _loc1_:ILcdsProxyServiceCall = new CapSearchForCandidatesServiceCall(this.service,this.encoder);
         this.wireServiceCallErrorMessage(_loc1_);
         return _loc1_;
      }
      
      public function getQuitAction() : IAction
      {
         return new CapQuitServiceCall(this.service,this.encoder);
      }
      
      public function getHideViewAction() : IAction
      {
         return new CapHideViewAction(this.lobbyController);
      }
      
      public function getSelectSkinAction(param1:ChampionSkin) : IAction
      {
         var _loc2_:ILcdsProxyServiceCall = null;
         _loc2_ = new CapSelectSkinV2ServiceCall(param1,this.model.isSkinNewlyPurchased(param1.skinId),this.service,this.encoder);
         this.wireServiceCallErrorMessage(_loc2_);
         return _loc2_;
      }
      
      public function getInviteAction() : IAction
      {
         return new CapInviteAction(this.model,this.inviteProvider);
      }
      
      public function getIndicateGroupAcceptAsCandidateAction() : IAction
      {
         return new CapIndicateGroupAcceptAsCandidateServiceCall(this.model,this.service,this.encoder);
      }
      
      public function getRetrieveFeatureTogglesAction() : IAction
      {
         return new CapRetrieveFeatureTogglesServiceCall(this.service,this.encoder);
      }
      
      public function getStartMatchmakingAction() : IAction
      {
         var _loc1_:ILcdsProxyServiceCall = new CapStartMatchmakingPhaseServiceCall(this.service,this.encoder,this.model);
         this.wireServiceCallErrorMessage(_loc1_);
         return _loc1_;
      }
      
      public function getStatusMessageAction(param1:String) : IAction
      {
         return new CapStatusMessageAction(this.model,this.chatController,param1);
      }
      
      public function getCreateGroupAction(param1:int) : IAction
      {
         var _loc2_:ILcdsProxyServiceCall = null;
         _loc2_ = new CapCreateGroupV3ServiceCall(param1,this.service,this.encoder);
         this.wireServiceCallErrorMessage(_loc2_);
         return _loc2_;
      }
      
      public function getRevealNextAvailableSlotAction() : IAction
      {
         return new CapRevealNextAvailableSlotAction(this.model);
      }
      
      public function getAcceptCandidateServiceCall(param1:Number) : IAction
      {
         var _loc2_:ILcdsProxyServiceCall = new CapAcceptCandidateServiceCall(param1,this.service,this.encoder);
         this.wireServiceCallErrorMessage(_loc2_);
         return _loc2_;
      }
      
      public function getTrackEnhancedPlayAgainMetricsAction(param1:Boolean, param2:Boolean, param3:String, param4:Array, param5:InviteGroup) : IAction
      {
         var _loc6_:CapPlayAgainMetricsFactory = new CapPlayAgainMetricsFactory();
         var _loc7_:CapPlayAgainMetrics = _loc6_.createPlayAgainMetrics(param1,param2,param3,param4,param5);
         return new CapTrackEnhancedPlayAgainMetricsAction(_loc7_);
      }
      
      public function getSelectPositionAction(param1:CapPosition, param2:int = -1) : IAction
      {
         var _loc3_:ILcdsProxyServiceCall = new CapSelectPositionServiceCall(param1,this.service,this.encoder,param2);
         this.wireServiceCallErrorMessage(_loc3_);
         return _loc3_;
      }
      
      public function getKickPlayerAction(param1:CapPlayerSelection) : IAction
      {
         return new CapKickPlayerV1ServiceCall(param1,this.service,this.encoder);
      }
      
      public function getSelectAdvertisedRoleAction(param1:CapRole, param2:int = -1) : IAction
      {
         var _loc3_:ILcdsProxyServiceCall = new CapSelectAdvertisedRoleServiceCall(param1,this.service,this.encoder,param2);
         this.wireServiceCallErrorMessage(_loc3_);
         return _loc3_;
      }
      
      public function getSelectRoleAction(param1:CapRole, param2:int = -1) : IAction
      {
         var _loc3_:ILcdsProxyServiceCall = new CapSelectRoleServiceCall(param1,this.service,this.encoder,param2);
         this.wireServiceCallErrorMessage(_loc3_);
         return _loc3_;
      }
      
      public function getIndicateGroupDeclineAsCandidateAction() : IAction
      {
         return new CapIndicateGroupDeclineAsCandidateServiceCall(this.model,this.service,this.encoder);
      }
      
      public function getDockedPromptAction(param1:Boolean, param2:String, param3:String, param4:String, param5:String, param6:String = null, param7:String = null, param8:Function = null, param9:Object = null, param10:Boolean = true, param11:int = -1) : IAction
      {
         return new DockedPromptAction(param1,this.dockedNotificationsProvider,param2,param3,param4,param5,param6,param7,param8,param9,param10,param11);
      }
      
      public function getSelectRunePageAction(param1:SpellBookPageDTO) : IAction
      {
         return new CapSelectRunePageAction(this.spellBookService,this.inventory.runeBook,param1,this.model.localPlayerSelection);
      }
      
      public function getJoinGroupAction() : IAction
      {
         return new CapJoinGroupAsInviteeServiceCall(this.model,this.service,this.encoder);
      }
      
      public function getConfigureMasterGameControllerAction() : IAction
      {
         return new ConfigureMasterGameControllerAction(this.masterGameController,GameViewState.CAP_STATE,GameType.NORMAL_GAME,false,this._gamePreparationDelegate);
      }
      
      public function getSelectAdvertisedPositionAction(param1:CapPosition, param2:int = -1) : IAction
      {
         var _loc3_:ILcdsProxyServiceCall = new CapSelectAdvertisedPositionServiceCall(param1,this.service,this.encoder,param2);
         this.wireServiceCallErrorMessage(_loc3_);
         return _loc3_;
      }
      
      private function wireServiceCallErrorMessage(param1:ILcdsProxyServiceCall) : void
      {
         var action:ILcdsProxyServiceCall = param1;
         action.getErred().addOnce(function():void
         {
            CapFaults.handleActionFaulted(action);
         });
      }
      
      public function getCreateSoloQueryAction(param1:int) : IAction
      {
         var _loc2_:ILcdsProxyServiceCall = null;
         _loc2_ = new CapCreateSoloQueryV4ServiceCall(this.model,param1,this.service,this.encoder,this);
         this.wireServiceCallErrorMessage(_loc2_);
         return _loc2_;
      }
      
      public function getSpecSolosServiceCall() : IAction
      {
         return new CapSpecCandidatesServiceCall(this.service,this.encoder);
      }
      
      public function getSelectSpellsAction(param1:Spell, param2:Spell) : IAction
      {
         var _loc3_:ILcdsProxyServiceCall = new CapSelectSpellsServiceCall(param1,param2,this.service,this.encoder);
         this.wireServiceCallErrorMessage(_loc3_);
         return _loc3_;
      }
   }
}

