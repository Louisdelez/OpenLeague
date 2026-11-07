package com.riotgames.pvpnet.cap.controllers
{
   import blix.action.IAction;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.provider.IInventoryController;
   import com.riotgames.platform.common.provider.ISoundProvider;
   import com.riotgames.platform.common.services.lcdsproxy.servicecalls.LcdsProxyServiceCall;
   import com.riotgames.platform.gameclient.chat.IChatRoomProvider;
   import com.riotgames.platform.gameclient.chat.IPresenceProvider;
   import com.riotgames.platform.gameclient.chat.actions.CreateChatRoomAction;
   import com.riotgames.platform.gameclient.chat.domain.ChatRoomType;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.ChampionSkin;
   import com.riotgames.platform.gameclient.domain.SpellBookPageDTO;
   import com.riotgames.platform.gameclient.domain.game.GameQueueConfig;
   import com.riotgames.platform.gameclient.domain.game.GameType;
   import com.riotgames.platform.gameclient.domain.game.GameViewState;
   import com.riotgames.platform.gameclient.domain.gameinvite.InviteType;
   import com.riotgames.platform.gameclient.domain.invite.InviteParticipant;
   import com.riotgames.platform.gameclient.domain.lobby.LobbyViewState;
   import com.riotgames.platform.gameclient.events.InventoryEvent;
   import com.riotgames.platform.masteries.objects.MasteryPageInfoSummary;
   import com.riotgames.pvpnet.cap.audio.CapAudioKeys;
   import com.riotgames.pvpnet.cap.factory.ICapActionFactory;
   import com.riotgames.pvpnet.cap.faults.CapFaults;
   import com.riotgames.pvpnet.cap.model.CapEstimatedWaitTime;
   import com.riotgames.pvpnet.cap.model.CapEstimatedWaitTimeCache;
   import com.riotgames.pvpnet.cap.model.CapFeatureToggles;
   import com.riotgames.pvpnet.cap.model.CapPlayAgainModel;
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.model.CapPosition;
   import com.riotgames.pvpnet.cap.model.CapRole;
   import com.riotgames.pvpnet.cap.model.CapRoles;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.cap.observers.CapModuleRequestedObserver;
   import com.riotgames.pvpnet.cap.util.CapFlowUtil;
   import com.riotgames.pvpnet.cap.util.CapLocaleUtil;
   import com.riotgames.pvpnet.cap.util.CapModelUtil;
   import com.riotgames.pvpnet.cap.util.CapPlayerSelectionUtil;
   import com.riotgames.pvpnet.game.controllers.IMasterGameController;
   import com.riotgames.pvpnet.game.controllers.IMasterGameViewController;
   import com.riotgames.pvpnet.game.controllers.lobby.ILobbyViewController;
   import com.riotgames.pvpnet.game.domain.IGameQueueManager;
   import com.riotgames.pvpnet.invite.IInviteController;
   import com.riotgames.pvpnet.invite.model.InviteGroup;
   import com.riotgames.pvpnet.suggestedplayers.ISuggestedPlayersProvider;
   import com.riotgames.pvpnet.suggestedplayers.model.SuggestedPlayer;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
   import com.riotgames.pvpnet.system.notification.IClientNotificationProvider;
   import com.riotgames.util.json.jsonEncode;
   import flash.utils.getQualifiedClassName;
   import mx.collections.ArrayCollection;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.rpc.Fault;
   
   public class CapController implements ICapController
   {
      
      private var _estimatedWaitTimeCache:CapEstimatedWaitTimeCache;
      
      private var _masterGameController:IMasterGameController;
      
      private var _masterGameViewController:IMasterGameViewController;
      
      private var _initialized:Boolean = false;
      
      private var _quitCompleteSignal:Signal = new Signal();
      
      private var _playAgainModel:CapPlayAgainModel;
      
      private var _soundProvider:ISoundProvider;
      
      private var _model:CapModel;
      
      private var _inviteGroup:InviteGroup;
      
      private var _chatProvider:IChatRoomProvider;
      
      private var _inventoryController:IInventoryController;
      
      private var quitErrorFunc:Function;
      
      private var _presenceProvider:IPresenceProvider;
      
      private var _playerSelection:CapPlayerSelection;
      
      private var _clientNotificationController:IClientNotificationProvider;
      
      private var _intializedSignal:Signal = new Signal();
      
      private var _suggestedPlayersProvider:ISuggestedPlayersProvider;
      
      private var _moduleObserver:CapModuleRequestedObserver;
      
      private var quitCompleteFunc:Function;
      
      protected var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var _spellController:IPlayerSpellController;
      
      private var _gameQueueManager:IGameQueueManager;
      
      private var _lobbyController:ILobbyViewController;
      
      private var _inviteController:IInviteController;
      
      private var _lobbyTimerController:CapLobbyTimerController;
      
      private var batchedSkinCall:IAction;
      
      private var _actionFactory:ICapActionFactory;
      
      public function CapController(param1:CapModel, param2:CapPlayAgainModel, param3:ICapActionFactory, param4:IPlayerSpellController, param5:IMasterGameController, param6:IMasterGameViewController, param7:ILobbyViewController, param8:IInviteController, param9:InviteGroup, param10:ISoundProvider, param11:CapLobbyTimerController, param12:IGameQueueManager, param13:CapEstimatedWaitTimeCache, param14:IInventoryController, param15:IChatRoomProvider, param16:IPresenceProvider, param17:ISuggestedPlayersProvider)
      {
         super();
         this._actionFactory = param3;
         this._model = param1;
         this._playAgainModel = param2;
         this._inviteController = param8;
         this._inviteGroup = param9;
         this._masterGameController = param5;
         this._masterGameViewController = param6;
         this._gameQueueManager = param12;
         this._inventoryController = param14;
         this._spellController = param4;
         this._lobbyController = param7;
         this._soundProvider = param10;
         this._lobbyTimerController = param11;
         this._estimatedWaitTimeCache = param13;
         this._chatProvider = param15;
         this._presenceProvider = param16;
         this._suggestedPlayersProvider = param17;
      }
      
      private function getInviteParticipantByPlayerSelection(param1:CapPlayerSelection, param2:InviteGroup) : InviteParticipant
      {
         var _loc3_:InviteParticipant = null;
         for each(_loc3_ in param2.participants)
         {
            if(this.sanitizeString(_loc3_.name) == this.sanitizeString(param1.summonerName))
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      public function unreadyGroup() : Boolean
      {
         var _loc3_:CapPlayerSelection = null;
         var _loc1_:Boolean = CapModelUtil.isFullPremadeGroup(this._model);
         var _loc2_:Boolean = false;
         for each(_loc3_ in CapModelUtil.getAllAvailablePlayerSelections(this._model))
         {
            _loc2_ ||= _loc3_.isReady;
            _loc3_.isReady = false;
            _loc3_.currentState = CapPlayerSelectionUtil.determineReadyState(_loc3_.isReady,_loc3_,!_loc1_);
         }
         return _loc2_;
      }
      
      public function selectRunePage(param1:SpellBookPageDTO) : void
      {
         var _loc2_:IAction = this._actionFactory.getSelectRunePageAction(param1);
         _loc2_.invoke();
      }
      
      public function hideView() : void
      {
         this._soundProvider.play(CapAudioKeys.CAP_PLAYER_LEAVES);
         var _loc1_:IAction = this._actionFactory.getHideViewAction();
         _loc1_.invoke();
      }
      
      public function hasQuit() : void
      {
         this._quitCompleteSignal.dispatch();
         if(this.quitCompleteFunc != null)
         {
            this.quitCompleteFunc.call(this);
            this.quitCompleteFunc = null;
         }
      }
      
      private function createGroupChatName() : String
      {
         return "cap" + this._model.groupId.replace(/[-]/g,"");
      }
      
      public function trackPlayAgainMetrics() : void
      {
         if(!CapFlowUtil.isCaptain(this._model))
         {
            return;
         }
         if(!this._model.useNewSuggestedPlayers)
         {
            this.trackOldPlayAgainMetrics();
         }
      }
      
      public function displayStatusMessage(param1:String) : void
      {
         var _loc2_:IAction = this._actionFactory.getStatusMessageAction(param1);
         _loc2_.invoke();
      }
      
      private function deactivateInviteController() : void
      {
         if(this._inviteController)
         {
            this._inviteController.setInviteGroupCancel(false);
            this._inviteController.leaveLobby();
            this._inviteController = null;
         }
         if(this._inviteGroup)
         {
            this._inviteGroup.groupId = "";
            this._inviteGroup.isAcceptingInvites = true;
            this._inviteGroup.getChatRoomChangedSignal().remove(this.handleInviteGroupChatroomChanged);
            this._inviteGroup.getInvitedParticipantsChangedSignal().remove(this.handleInviteGroupParticipantsChanged);
            if(!this._model.hasLaunchedGame)
            {
               this._inviteGroup.clear();
               this._inviteGroup.ownerQuitCancelsGame = true;
               this._inviteGroup = null;
            }
         }
         this._playAgainModel.playAgainClicked = false;
         this._playAgainModel.isVictorious = false;
      }
      
      private function handleGameChanged() : void
      {
         if(Boolean(this._masterGameController.currentGame && this._masterGameController.currentGame.gameState == GameViewState.START_REQUESTED) && Boolean(this._masterGameController.currentState == GameViewState.CAP_STATE) && Boolean(this._model.localPlayerSelection.champion))
         {
            this._presenceProvider.setSkinName(this._model.localPlayerSelection.champion.skinName);
         }
      }
      
      public function get intializedSignal() : ISignal
      {
         return this._intializedSignal;
      }
      
      public function declineSuggestedPlayer(param1:SuggestedPlayer) : void
      {
         this._suggestedPlayersProvider.declineSuggestedPlayerAndGetReplacement(this._model.inviteSuggestionList,param1);
         this._model.inviteSuggestionList = this._model.inviteSuggestionList;
      }
      
      public function declineGroup() : void
      {
         throw new Error("Unimplemented");
      }
      
      public function declineCandidate(param1:Number, param2:Function = null) : void
      {
         var _loc3_:IAction = this._actionFactory.getDeclineCandidateServiceCall(param1);
         if(param2 != null)
         {
            _loc3_.getErred().add(param2);
         }
         _loc3_.invoke();
      }
      
      public function delegateAsInvitor(param1:CapPlayerSelection) : void
      {
         if(!this._inviteGroup || !this._inviteController)
         {
            return;
         }
         var _loc2_:InviteParticipant = this.getInviteParticipantByPlayerSelection(param1,this._inviteGroup);
         if(!_loc2_ || Boolean(_loc2_.isOwner))
         {
            return;
         }
         this._inviteController.delegateInvitePower(_loc2_);
      }
      
      private function onChatRoomCreated(param1:CreateChatRoomAction) : void
      {
         if(Boolean(param1) && Boolean(param1.chatRoom))
         {
            this._inviteGroup.chatRoom = param1.chatRoom;
            this._model.chatRoom = param1.chatRoom;
         }
      }
      
      public function leaveChatRoom() : void
      {
         if(Boolean(this._inviteGroup) && Boolean(this._inviteGroup.chatRoom))
         {
            this._chatProvider.closeChatRoom(this._inviteGroup.chatRoom);
            this._inviteGroup.chatRoom = null;
            this._model.chatRoom = null;
         }
      }
      
      private function handleSkinPurchased(param1:InventoryEvent) : void
      {
         var _loc2_:ChampionSkin = param1.info as ChampionSkin;
         this._model.addNewlyPurchasedSkinId(_loc2_.skinId);
      }
      
      private function setupChildControllers() : void
      {
         this._spellController.playerSelection = this._model.localPlayerSelection;
         this._spellController.activate();
      }
      
      private function handleSkinError() : void
      {
         this._model.selectingSkin = false;
      }
      
      public function selectPosition(param1:CapPosition, param2:int = -1) : void
      {
         var _loc3_:IAction = null;
         if(CapFlowUtil.isCaptain(this._model) || CapFlowUtil.isInvitee(this._model))
         {
            _loc3_ = this._actionFactory.getSelectPositionAction(param1,param2);
            _loc3_.invoke();
         }
         else
         {
            this._model.localPlayerSelection.position = param1;
         }
      }
      
      public function get isInitialized() : Boolean
      {
         return this._initialized;
      }
      
      public function selectAdvertisedRole(param1:CapRole, param2:int = -1) : void
      {
         var _loc3_:IAction = null;
         if(CapFlowUtil.isCaptain(this._model))
         {
            _loc3_ = this._actionFactory.getSelectAdvertisedRoleAction(param1,param2);
            _loc3_.invoke();
         }
      }
      
      private function handleSuggestedPlayers(param1:ArrayCollection) : void
      {
         this._model.inviteSuggestionList = param1;
         this._model.originalInviteSuggestionList = this._model.inviteSuggestionList.toArray();
      }
      
      public function joinGroupAsSolo(param1:Function, param2:Function) : void
      {
         var _loc3_:IAction = this._actionFactory.getIndicateGroupAcceptAsCandidateAction();
         if(param1 != null)
         {
            _loc3_.getCompleted().addOnce(param1);
         }
         if(param2 != null)
         {
            _loc3_.getErred().addOnce(param2);
         }
         _loc3_.invoke();
      }
      
      public function acceptCandidate(param1:Number, param2:Function = null) : void
      {
         var _loc3_:IAction = this._actionFactory.getAcceptCandidateServiceCall(param1);
         if(param2 != null)
         {
            _loc3_.getErred().add(param2);
         }
         _loc3_.invoke();
      }
      
      private function invokeBatchedSkinCall() : void
      {
         this.batchedSkinCall.invoke();
         this.batchedSkinCall = null;
      }
      
      public function launchInvites() : void
      {
         var _loc1_:IAction = this._actionFactory.getInviteAction();
         _loc1_.invoke();
      }
      
      private function doDeactivate() : void
      {
         if(!this._initialized)
         {
            return;
         }
         this._spellController.deactivate();
         this.deactivateInviteController();
         this.leaveChatRoom();
         this._model.isInMatchmaking = false;
         this._gameQueueManager.endQueueWait();
         if(!this._model.hasLaunchedGame)
         {
            this._masterGameController.cancelGameFlow();
            this._masterGameViewController.abortCycle();
         }
         this._masterGameController.setGamePreparationDelegate(null);
         this._masterGameController.getCurrentGameChanged().remove(this.handleGameChanged);
         this._inventoryController.removeEventListener(InventoryEvent.SKIN_PURCHASE_PENDING,this.handleSkinPurchased);
         this._initialized = false;
      }
      
      private function setupAudioPlaybacks() : void
      {
         var playerSelection:CapPlayerSelection = null;
         this._model.inMatchmakingQueueChanged.add(function():void
         {
            if(_model.inMatchmakingQueue)
            {
               _soundProvider.play(CapAudioKeys.CAP_MATCHMAKING_STARTED);
            }
         });
         for each(playerSelection in CapModelUtil.getAllAvailablePlayerSelections(this._model))
         {
            playerSelection.isReadyChanged.add(function(param1:Boolean, param2:CapPlayerSelection):void
            {
               if(!param2.isLocalPlayer)
               {
                  return;
               }
               if(param1)
               {
                  _soundProvider.play(CapAudioKeys.CAP_PLAYER_IS_READY);
               }
               else
               {
                  _soundProvider.play(CapAudioKeys.CAP_PLAYER_IS_NOT_READY);
               }
            });
         }
      }
      
      public function retrieveEstimatedWaitTime() : IAction
      {
         var _loc2_:CapEstimatedWaitTime = null;
         var _loc3_:GameQueueConfig = null;
         var _loc4_:IAction = null;
         var _loc1_:CapPlayerSelection = this._model.localPlayerSelection;
         if(Boolean(_loc1_.champion) && Boolean(_loc1_.role) && Boolean(_loc1_.position))
         {
            _loc2_ = this._estimatedWaitTimeCache.getEstimatedWaitTime(_loc1_.champion,_loc1_.role,_loc1_.position);
            if(_loc2_)
            {
               this._model.currentEstimatedWaitTime = _loc2_;
               return null;
            }
            _loc3_ = this._gameQueueManager.getSelectedGameQueueConfig();
            _loc4_ = this._actionFactory.getRetrieveEstimatedWaitTimeAction(_loc1_.champion,_loc1_.role,_loc1_.position,_loc3_.id);
            _loc4_.invoke();
            return _loc4_;
         }
         return null;
      }
      
      private function handleInviteGroupParticipantsChanged() : void
      {
         var _loc1_:InviteParticipant = null;
         var _loc2_:SuggestedPlayer = null;
         for each(_loc1_ in this._inviteGroup.participants)
         {
            for each(_loc2_ in this._model.inviteSuggestionList)
            {
               if(_loc2_.summonerName.toLowerCase() == _loc1_.name.toLowerCase())
               {
                  _loc2_.invited = true;
                  _loc2_.visible = false;
                  break;
               }
            }
         }
         if(this._model.useNewSuggestedPlayers)
         {
            this._suggestedPlayersProvider.updateSuggestedPlayerVisibility(this._model.inviteSuggestionList);
         }
         else
         {
            this._model.inviteSuggestionList.refresh();
         }
         this._model.inviteSuggestionList = this._model.inviteSuggestionList;
      }
      
      private function triggerInitializationSuccess() : void
      {
         this._initialized = true;
         this._intializedSignal.dispatch();
      }
      
      private function handleInviteGroupChatroomChanged() : void
      {
         if(Boolean(this._model) && Boolean(this._inviteGroup))
         {
            this._model.chatRoom = this._inviteGroup.chatRoom;
         }
      }
      
      private function onActivationFailure(param1:LcdsProxyServiceCall = null) : void
      {
         var _loc4_:AlertAction = null;
         var _loc5_:String = null;
         var _loc6_:String = null;
         var _loc2_:Fault = param1.fault;
         var _loc3_:String = _loc2_.faultCode;
         this._initialized = true;
         if(_loc3_ == CapFaults.INVALID_STATE)
         {
            _loc5_ = CapLocaleUtil.getResourceString("gf_dialog_buddy_join_failure_title","Unable to Join Group");
            _loc6_ = CapLocaleUtil.getResourceString("gf_dialog_buddy_join_failure_body","The lobby is currently full.");
         }
         else if(CapFlowUtil.isCaptain(this._model))
         {
            _loc5_ = CapLocaleUtil.getResourceString("gf_dialog_captain_launch_failure_title","Unable to create group");
            _loc6_ = CapLocaleUtil.getResourceString("gf_dialog_captain_launch_failure_body","We are not able to create a group for you at this time. Please try again later.");
         }
         else
         {
            _loc5_ = CapLocaleUtil.getResourceString("gf_dialog_groupie_launch_failure_title","Unable to Join Group");
            _loc6_ = CapLocaleUtil.getResourceString("gf_dialog_groupie_launch_failure_body","We are not able to add you to the group. Please try again later.");
         }
         _loc4_ = new AlertAction(_loc5_,_loc6_);
         _loc4_.add();
         this._quitCompleteSignal.dispatch();
      }
      
      public function closeLobbyToAdditionalInvitees() : void
      {
         if(!CapFlowUtil.isCaptain(this._model))
         {
            return;
         }
         if(this._inviteController)
         {
            this._inviteController.closeLobbyToAdditionalInvitees();
         }
      }
      
      private function invokeInitializationServiceCalls() : void
      {
         var _loc1_:IAction = null;
         this.getInventory();
         var _loc2_:GameQueueConfig = this._gameQueueManager.getSelectedGameQueueConfig();
         if(CapFlowUtil.isCaptain(this._model))
         {
            _loc1_ = this._actionFactory.getCreateGroupAction(_loc2_.id);
         }
         else if(CapFlowUtil.isInvitee(this._model))
         {
            _loc1_ = this._actionFactory.getJoinGroupAction();
         }
         if(CapFlowUtil.isCaptain(this._model) || CapFlowUtil.isInvitee(this._model))
         {
            this._model.groupIdChanged.addOnce(this.initializeInvites);
         }
         if(_loc1_)
         {
            _loc1_.getErred().addOnce(this.onActivationFailure);
            _loc1_.invoke();
         }
      }
      
      public function startMatchmaking(param1:Function = null) : void
      {
         if(this._model.isInMatchmaking)
         {
            return;
         }
         var _loc2_:IAction = this._actionFactory.getStartMatchmakingAction();
         if(param1 != null)
         {
            _loc2_.getErred().add(param1);
         }
         _loc2_.invoke();
         this.closeLobbyToAdditionalInvitees();
         this._model.isInMatchmaking = true;
      }
      
      public function requestQuit(param1:Boolean = false, param2:Function = null, param3:Function = null) : void
      {
         this.quitCompleteFunc = param2;
         this.quitErrorFunc = param3;
         if(this._model)
         {
            this._model.localPlayerCausedDisband = true;
         }
         var _loc4_:IAction = this._actionFactory.getConfirmQuitAction(param1);
         _loc4_.getCompleted().addOnce(this.hasQuit);
         _loc4_.getErred().addOnce(this.handleQuitError);
         _loc4_.invoke();
      }
      
      public function revokeInvitePrivileges(param1:CapPlayerSelection) : void
      {
         if(!this._inviteGroup || !this._inviteController)
         {
            return;
         }
         var _loc2_:InviteParticipant = this.getInviteParticipantByPlayerSelection(param1,this._inviteGroup);
         if(!_loc2_ || Boolean(_loc2_.isOwner))
         {
            return;
         }
         this._inviteController.revokeInvitePower(_loc2_);
      }
      
      public function selectAdvertisedPosition(param1:CapPosition, param2:int = -1) : void
      {
         var _loc3_:IAction = null;
         if(CapFlowUtil.isCaptain(this._model))
         {
            if(this._model.enabledFeatureToggles[CapFeatureToggles.PREMADE_RESPEC])
            {
               _loc3_ = this._actionFactory.getSelectAdvertisedPositionAction(param1,param2);
               _loc3_.invoke();
            }
            else
            {
               this.selectPosition(param1,param2);
            }
         }
      }
      
      public function get quitCompletedSignal() : ISignal
      {
         return this._quitCompleteSignal;
      }
      
      public function selectChampion(param1:Champion) : void
      {
         var _loc2_:IAction = null;
         if(Boolean(this._model.pendingChampionSelection) && this._model.pendingChampionSelection.championId == param1.championId)
         {
            return;
         }
         if(CapFlowUtil.isSolo(this._model))
         {
            this._model.localPlayerSelection.champion = param1;
            if(param1)
            {
               this._model.localPlayerSelection.skin = param1.getCurrentChampionSkin();
            }
         }
         else
         {
            _loc2_ = this._actionFactory.getSelectChampionAction(param1);
            _loc2_.invoke();
         }
      }
      
      public function searchForPlayers(param1:Function = null, param2:Function = null) : void
      {
         var _loc3_:IAction = this._actionFactory.getSearchForCandidatesAction();
         if(param1 != null)
         {
            _loc3_.getCompleted().addOnce(param1);
         }
         if(param2 != null)
         {
            _loc3_.getErred().addOnce(param2);
         }
         _loc3_.invoke();
      }
      
      public function createSoloQuery() : void
      {
         var _loc1_:GameQueueConfig = this._gameQueueManager.getSelectedGameQueueConfig();
         var _loc2_:IAction = this._actionFactory.getCreateSoloQueryAction(_loc1_.id);
         _loc2_.invoke();
      }
      
      public function selectRole(param1:CapRole, param2:int = -1) : void
      {
         var _loc3_:IAction = null;
         if(CapFlowUtil.isCaptain(this._model) || CapFlowUtil.isInvitee(this._model))
         {
            _loc3_ = this._actionFactory.getSelectRoleAction(param1,param2);
            _loc3_.invoke();
         }
         else
         {
            this._model.localPlayerSelection.role = param1;
         }
      }
      
      public function inviteSuggestedPlayer(param1:SuggestedPlayer) : void
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         if(this._inviteController)
         {
            if(this._model.useNewSuggestedPlayers)
            {
               _loc2_ = this.getInviteTypeFromSuggestionReason(param1.suggestionReason);
               _loc3_ = this.getPayloadForInvite(param1);
               this._inviteController.invitePlayerBySummonerName(param1.summonerName,_loc2_,_loc3_);
            }
            else
            {
               this._inviteController.invitePlayerBySummonerName(param1.summonerName,InviteType.TEAM_BUILDER_SUGGESTED);
            }
         }
      }
      
      public function joinChatRoom() : void
      {
         if(Boolean(this._model.groupId) && !this._inviteGroup.chatRoom)
         {
            this._masterGameViewController.initChatRoom(this._model.groupId,null,ChatRoomType.CAP,this.onChatRoomCreated);
         }
      }
      
      public function goToSoloSpecPhase(param1:Function = null, param2:Function = null) : void
      {
         var _loc3_:IAction = null;
         if(CapFlowUtil.isCaptain(this._model))
         {
            _loc3_ = this._actionFactory.getSpecSolosServiceCall();
            if(param1 != null)
            {
               _loc3_.getCompleted().addOnce(param1);
            }
            if(param2 != null)
            {
               _loc3_.getErred().addOnce(param2);
            }
            _loc3_.invoke();
         }
      }
      
      public function initialize() : void
      {
         var _loc2_:IAction = null;
         if(this._initialized)
         {
            return;
         }
         this.setupModel();
         this._model.useNewSuggestedPlayers = DynamicClientConfigManager.getConfiguration("SuggestedPlayers","Enabled",true).getBoolean();
         this._inviteGroup.ownerQuitCancelsGame = false;
         this.setupChildControllers();
         var _loc1_:IAction = this._actionFactory.getConfigureMasterGameControllerAction();
         _loc1_.invoke();
         this._lobbyController.requestLobbyState(LobbyViewState.CAP_STATE);
         _loc2_ = this._actionFactory.getRetrieveFeatureTogglesAction();
         this._model.enabledFeatureTogglesChanged.addOnce(this.invokeInitializationServiceCalls);
         _loc2_.getErred().addOnce(this.onActivationFailure);
         _loc2_.invoke();
         this._inventoryController.addEventListener(InventoryEvent.SKIN_PURCHASE_PENDING,this.handleSkinPurchased);
         this._masterGameController.getCurrentGameChanged().add(this.handleGameChanged);
         this.triggerInitializationSuccess();
         this._inviteGroup.getChatRoomChangedSignal().add(this.handleInviteGroupChatroomChanged);
         this._inviteGroup.getInvitedParticipantsChangedSignal().add(this.handleInviteGroupParticipantsChanged);
         this.handleInviteGroupChatroomChanged();
      }
      
      public function selectSkin(param1:ChampionSkin) : void
      {
         var _loc2_:IAction = null;
         if(Boolean(param1) && Boolean(param1.isAvailable()) && !param1.skinDisabled)
         {
            if(CapFlowUtil.isSolo(this._model) && !CapFlowUtil.isInAGroup(this._model))
            {
               this._model.localPlayerSelection.skin = param1;
            }
            else if(param1 != this._model.localPlayerSelection.skin)
            {
               _loc2_ = this._actionFactory.getSelectSkinAction(param1);
               _loc2_.getErred().addOnce(this.handleSkinError);
               if(!this._model.selectingSkin)
               {
                  _loc2_.invoke();
                  this._model.selectingSkin = true;
               }
               else
               {
                  this.batchedSkinCall = _loc2_;
                  this._model.finishedSelectingSkin.addOnce(this.invokeBatchedSkinCall);
               }
            }
         }
      }
      
      private function getInviteTypeFromSuggestionReason(param1:int) : String
      {
         if(param1 == SuggestedPlayer.REASON_FRIEND_OF_FRIEND)
         {
            return InviteType.FRIEND_OF_FRIEND;
         }
         if(param1 == SuggestedPlayer.REASON_HONORED)
         {
            return InviteType.HONORED_PLAYER;
         }
         if(param1 == SuggestedPlayer.REASON_VICTORIOUS_COMRADE)
         {
            return InviteType.VICTORIOUS_COMRADE;
         }
         return InviteType.DEFAULT;
      }
      
      private function setupModel() : void
      {
         this._playerSelection = this._model.localPlayerSelection;
         this.setupAudioPlaybacks();
         this.sortRoles(this._model.allRoles);
         this.sortRoles(this._model.speccableRoles);
         this.sortRoles(this._model.selectableRoles);
      }
      
      public function getInventory() : void
      {
         var _loc1_:GameQueueConfig = this._gameQueueManager.getSelectedGameQueueConfig();
         var _loc2_:IAction = this._actionFactory.getRetrievePlayerInfoAction(_loc1_.id);
         _loc2_.getErred().addOnce(this.onActivationFailure);
         _loc2_.invoke();
      }
      
      private function trackOldPlayAgainMetrics() : void
      {
         var _loc1_:String = this._model.currentPhase;
         var _loc2_:Boolean = this._playAgainModel.playAgainClicked;
         var _loc3_:Array = this._model.originalInviteSuggestionList;
         var _loc4_:Boolean = _loc3_.length >= 1;
         var _loc5_:IAction = this._actionFactory.getTrackEnhancedPlayAgainMetricsAction(_loc2_,_loc4_,_loc1_,_loc3_,this._inviteGroup);
         _loc5_.invoke();
      }
      
      private function handleQuitError(param1:IAction) : void
      {
         if(this.quitErrorFunc != null)
         {
            this.quitErrorFunc.call(this,param1);
            this.quitErrorFunc = null;
         }
      }
      
      public function declineGroupAsSolo(param1:Function) : void
      {
         var _loc2_:IAction = this._actionFactory.getIndicateGroupDeclineAsCandidateAction();
         if(param1 != null)
         {
            _loc2_.getErred().addOnce(param1);
         }
         _loc2_.invoke();
      }
      
      public function sortRoles(param1:Array) : void
      {
         param1.sort(CapRoles.roleCompareFunction);
      }
      
      public function indicateReadiness(param1:Boolean) : void
      {
         var _loc2_:IAction = this._actionFactory.getIndicateReadinessAction(param1);
         _loc2_.invoke();
      }
      
      public function kickPlayer(param1:CapPlayerSelection) : void
      {
         var _loc2_:IAction = null;
         if(CapFlowUtil.isCaptain(this._model))
         {
            _loc2_ = this._actionFactory.getKickPlayerAction(param1);
            _loc2_.invoke();
         }
      }
      
      private function getPayloadForInvite(param1:SuggestedPlayer) : String
      {
         if(param1.suggestionReason == SuggestedPlayer.REASON_FRIEND_OF_FRIEND)
         {
            return jsonEncode({"commonFriendId":param1.commonFriendId});
         }
         return "";
      }
      
      public function initializeInvites() : void
      {
         var _loc2_:GameQueueConfig = null;
         var _loc3_:String = null;
         var _loc4_:SuggestedPlayer = null;
         var _loc1_:Boolean = CapFlowUtil.isCaptain(this._model);
         if(!this._model.groupId)
         {
            return;
         }
         if(_loc1_)
         {
            this._inviteGroup.groupId = this._model.groupId;
            this._inviteController.setInviteGroupAsInvitor(GameType.NORMAL_GAME,0,this._masterGameController.gameModel.gameMap.mapId,"");
            if(Boolean(this._playAgainModel.reinviteList.length) && this._playAgainModel.playAgainClicked)
            {
               this.reinvite(this._playAgainModel.reinviteList);
            }
            if(this._model.useNewSuggestedPlayers)
            {
               _loc2_ = this._gameQueueManager.getSelectedGameQueueConfig();
               this._suggestedPlayersProvider.getSuggestedPlayerModels(_loc2_,this.handleSuggestedPlayers);
            }
            else if(this._playAgainModel.suggestionList.length)
            {
               this._model.originalInviteSuggestionList = this._playAgainModel.suggestionList.toArray();
               for each(_loc3_ in this._playAgainModel.suggestionList)
               {
                  _loc4_ = new SuggestedPlayer();
                  _loc4_.summonerName = _loc3_;
                  _loc4_.suggestionReason = SuggestedPlayer.REASON_LEGACY_PLAY_AGAIN;
                  this._model.inviteSuggestionList.addItem(_loc4_);
               }
               this._model.inviteSuggestionList = this._model.inviteSuggestionList;
            }
         }
         this._playAgainModel.clear();
         this._playAgainModel.playAgainClicked = false;
      }
      
      public function searchForAnotherGroup() : void
      {
         var _loc1_:IAction = this._actionFactory.getSearchForAnotherGroupServiceCall();
         _loc1_.invoke();
      }
      
      private function sanitizeString(param1:String) : String
      {
         var _loc2_:RegExp = /[\s\r\n]+/gim;
         return param1.replace(_loc2_,"").toLowerCase();
      }
      
      public function selectMasteryPage(param1:MasteryPageInfoSummary) : void
      {
         var _loc2_:IAction = this._actionFactory.getSelectMasteryPageAction(param1);
         _loc2_.invoke();
      }
      
      public function destroy() : void
      {
         this.doDeactivate();
         this._spellController.destroy();
         this._intializedSignal.removeAll();
         this._lobbyTimerController.stopTimer();
         this._estimatedWaitTimeCache.clearCache();
         this._quitCompleteSignal.removeAll();
         this._model = null;
      }
      
      private function reinvite(param1:ArrayCollection) : void
      {
         this._inviteController.reInviteParticipants(param1.toArray());
      }
   }
}

