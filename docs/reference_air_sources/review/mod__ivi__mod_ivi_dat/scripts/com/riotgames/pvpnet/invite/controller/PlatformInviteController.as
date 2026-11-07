package com.riotgames.pvpnet.invite.controller
{
   import blix.action.IAction;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.AppConfig;
   import com.riotgames.platform.common.services.MessageRouterService;
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.gameclient.chat.IChatBlockedRosterProvider;
   import com.riotgames.platform.gameclient.chat.IChatStateProvider;
   import com.riotgames.platform.gameclient.chat.domain.ChatMessageType;
   import com.riotgames.platform.gameclient.chat.domain.ChatMessageVO;
   import com.riotgames.platform.gameclient.domain.GameDTO;
   import com.riotgames.platform.gameclient.domain.gameinvite.InvitationPlayer;
   import com.riotgames.platform.gameclient.domain.gameinvite.InvitationRequest;
   import com.riotgames.platform.gameclient.domain.gameinvite.InvitePrivileges;
   import com.riotgames.platform.gameclient.domain.gameinvite.LobbyStatus;
   import com.riotgames.platform.gameclient.domain.gameinvite.RemovalReason;
   import com.riotgames.platform.gameclient.domain.gameinvite.RemovedFromLobbyNotification;
   import com.riotgames.platform.gameclient.domain.invite.InviteParticipant;
   import com.riotgames.platform.gameclient.domain.invite.InviteParticipantState;
   import com.riotgames.platform.gameclient.domain.invite.InviteState;
   import com.riotgames.platform.gameclient.domain.invite.InviteVerificationState;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.game.controllers.shutdown.ShutdownTimingTables;
   import com.riotgames.pvpnet.invite.IInviteController;
   import com.riotgames.pvpnet.invite.PlatformInviteActionFactory;
   import com.riotgames.pvpnet.invite.action.IInviteParticipantAction;
   import com.riotgames.pvpnet.invite.action.ILobbyStatusAction;
   import com.riotgames.pvpnet.invite.action.RetrievePendingInvitationsAction;
   import com.riotgames.pvpnet.invite.action.ShowGameInviteAction;
   import com.riotgames.pvpnet.invite.model.GameInvite;
   import com.riotgames.pvpnet.invite.model.InviteGroup;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.pvpnet.system.messaging.MessageQueue;
   import flash.utils.getQualifiedClassName;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.messaging.events.MessageEvent;
   import org.igniterealtime.xiff.data.im.RosterItemVO;
   
   public class PlatformInviteController
   {
      
      private static const MAX_EXPIRED_INVITATIONS:int = 15;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var _invitePrivilegeChangedSignal:Signal = new Signal();
      
      private var _quitLobbySignal:Signal = new Signal();
      
      private var _inviteQueueManager:InviteQueueManager;
      
      private var _ownerChangedSignal:Signal = new Signal();
      
      private var _chatBlockedRosterProvider:IChatBlockedRosterProvider;
      
      private var _inviteActionFactory:PlatformInviteActionFactory;
      
      private var _inviteGroup:InviteGroup;
      
      private var _messageRouterService:MessageRouterService;
      
      private var _lobbyCreatedSignal:Signal = new Signal();
      
      private var _clientMessageQueue:MessageQueue;
      
      private var _inviteController:IInviteController;
      
      private var _gameInvites:Vector.<ShowGameInviteAction> = new Vector.<ShowGameInviteAction>();
      
      public function PlatformInviteController(param1:IInviteController, param2:InviteGroup, param3:MessageRouterService, param4:InviteQueueManager, param5:PlatformInviteActionFactory, param6:IChatBlockedRosterProvider)
      {
         super();
         this._inviteController = param1;
         this._inviteGroup = param2;
         this._messageRouterService = param3;
         this._inviteActionFactory = param5;
         this._inviteQueueManager = param4;
         this._chatBlockedRosterProvider = param6;
      }
      
      private function processLobbyStatus(param1:LobbyStatus, param2:Boolean = false) : void
      {
         var _loc4_:InviteParticipant = null;
         var _loc3_:GameDTO = this._inviteQueueManager.getCurrentGame();
         if(param2 || this._inviteGroup.inviteState != InviteState.NONE && this._inviteGroup.inviteId == param1.invitationId || Boolean(_loc3_) && Boolean(_loc3_.id == param1.gameId))
         {
            _loc4_ = this._inviteGroup.ownerParticipant;
            this._inviteActionFactory.getProcessLobbyStatusAction(param1,this._inviteGroup).invoke();
            if(_loc4_ != this._inviteGroup.ownerParticipant)
            {
               this._ownerChangedSignal.dispatch(this._inviteGroup.isOwner);
            }
         }
      }
      
      private function selectExpiredFunction(param1:ShowGameInviteAction, ... rest) : Boolean
      {
         return param1.isInvitationExpired();
      }
      
      private function onKickErred(param1:IInviteParticipantAction) : void
      {
         this.getLobbyStatus();
      }
      
      private function processInvitationRequest(param1:InvitationRequest) : void
      {
         var _loc2_:GameInvite = null;
         var _loc3_:ShowGameInviteAction = null;
         var _loc4_:ShowGameInviteAction = null;
         if(Boolean(param1) && this.isInviteAllowed(param1))
         {
            for each(_loc4_ in this._gameInvites)
            {
               if(_loc4_.getGameInvitationId() == param1.invitationId)
               {
                  _loc3_ = _loc4_;
                  if(param1.inviter)
                  {
                     _loc4_.addInviter(param1.inviter);
                  }
                  _loc4_.updateGameInvite(param1.invitationState);
                  break;
               }
            }
            if(!_loc3_)
            {
               _loc2_ = new GameInvite();
               _loc2_.invitationId = param1.invitationId;
               _loc2_.invitationState = param1.invitationState;
               _loc2_.inviteType = param1.inviteType;
               _loc2_.owner = param1.owner;
               _loc2_.gameMode = param1.gameMode;
               _loc2_.gameType = param1.gameType;
               _loc2_.queueId = param1.queueId;
               _loc2_.mapId = param1.mapId;
               _loc2_.gameDifficulty = param1.gameDifficulty;
               _loc2_.gameTypeId = param1.gameTypeConfigId;
               _loc2_.teamName = param1.rankedTeamName;
               _loc2_.teamId = param1.rankedTeamId;
               _loc2_.groupId = param1.groupId;
               _loc2_.addInviter(param1.inviter);
               _loc2_.commonFriendName = param1.commonFriendName;
               _loc3_ = this._inviteActionFactory.getShowGameInviteAction(_loc2_,this._inviteController,this._inviteGroup,this._inviteQueueManager);
               this._gameInvites.push(_loc3_);
               _loc3_.getCompleted().add(this.onInviteAcceptCompleted);
               _loc3_.invoke();
            }
            this.checkAndCleanupExpiredInvitations();
         }
      }
      
      private function showShutDownAlert(param1:InvitationPlayer) : void
      {
         var _loc2_:String = this._inviteActionFactory.getRiotResourceString("INV-0005","You are not able to accept this invite.");
         var _loc3_:String = this._inviteActionFactory.getResourceManagerString("common_button_ok");
         var _loc4_:String = this._inviteActionFactory.getResourceManagerString("XMPP-GAME-INVITE-TITLE");
         this._inviteActionFactory.showDockedPrompt(_loc4_,_loc2_,param1.summonerName,[_loc3_]);
      }
      
      private function chatStateReady(param1:IChatStateProvider) : void
      {
         if(param1.getCurrentState() != ChatController.ONLINE || Boolean(this._chatBlockedRosterProvider.isPrivacyListReady()))
         {
            this.getPendingInvitations();
         }
         else
         {
            this._chatBlockedRosterProvider.getPrivacyListInitializedSignal().addOnce(this.getPendingInvitations);
         }
      }
      
      private function onInviteGroupQuit() : void
      {
         var _loc1_:IAction = this._inviteActionFactory.getLeaveLobbyAction();
         _loc1_.invoke();
         this._quitLobbySignal.dispatch();
      }
      
      private function onRankedTeamLobbyCreated(param1:String) : void
      {
         var _loc2_:IAction = null;
         if(this._inviteQueueManager.isRankedTeam())
         {
            _loc2_ = this._inviteActionFactory.getCreateArrangedRankedTeamLobbyAction(this._inviteQueueManager.getSelectedGameQueueConfigId(),param1);
            _loc2_.getCompleted().add(this.onLobbyCreateComplete);
            _loc2_.invoke();
         }
      }
      
      private function onInviteGroupCleared() : void
      {
         if(this._inviteController.getPlayerQuittingGame())
         {
            this._quitLobbySignal.dispatch();
         }
         else
         {
            this.getLobbyStatus();
         }
      }
      
      public function getQuitLobbySignal() : ISignal
      {
         return this._quitLobbySignal;
      }
      
      private function onInviteLobbyCreated() : void
      {
         this.createNewLobby();
      }
      
      private function joinChatRoom() : void
      {
         var _loc1_:IAction = this._inviteActionFactory.getJoinInviteChatRoomAction(this._inviteGroup);
         _loc1_.invoke();
      }
      
      private function onLobbyStatusRetrieved(param1:ILobbyStatusAction) : void
      {
         if(param1.getLobbyStatus())
         {
            if(this._inviteGroup.inviteState == InviteState.NONE && !this._inviteQueueManager.isCapGame())
            {
               this.joinLobbyFromLobbyStatus(param1.getLobbyStatus());
            }
            else
            {
               this.processLobbyStatus(param1.getLobbyStatus());
            }
         }
      }
      
      private function onParticipantsAdded(param1:Array, param2:Object, param3:String, param4:String) : void
      {
         var _loc5_:IAction = this._inviteActionFactory.getInvitePlayersAction(param1,this._inviteGroup,param3,param4);
         _loc5_.invoke();
      }
      
      public function getInvitePrivilegeChangedSignal() : ISignal
      {
         return this._invitePrivilegeChangedSignal;
      }
      
      public function disconnectFromLCDS() : void
      {
         this._messageRouterService.removeClientNotificationMessageListener(this._clientMessageQueue.onMessageReceived);
         this._clientMessageQueue = null;
      }
      
      private function onPendingInvitationsRetrieved(param1:RetrievePendingInvitationsAction) : void
      {
         var _loc2_:InvitationRequest = null;
         if(param1.getInvitations().length == 0)
         {
            return;
         }
         for each(_loc2_ in param1.getInvitations())
         {
            this.processInvitationRequest(_loc2_);
         }
      }
      
      private function showCooldownAlert(param1:InvitationPlayer) : void
      {
         var _loc2_:String = this._inviteActionFactory.getRiotResourceString("bingePreventionInviteRecievedError","You have recieved an invite, but can\'t do it.");
         var _loc3_:String = this._inviteActionFactory.getRiotResourceString("bingePreventionInviteRecievedErrorTitle","Been playing too long!");
         var _loc4_:String = this._inviteActionFactory.getResourceManagerString("common_button_ok");
         this._inviteActionFactory.showDockedPrompt(_loc3_,_loc2_,param1.summonerName,[_loc4_]);
      }
      
      private function getLobbyStatus() : void
      {
         var _loc1_:IAction = this._inviteActionFactory.getGetLobbyStatusAction();
         _loc1_.getCompleted().add(this.onLobbyStatusRetrieved);
         _loc1_.invoke();
      }
      
      private function onInviteAcceptCompleted(param1:ShowGameInviteAction) : void
      {
         if(param1.getIsAccepted())
         {
            if(param1.getLobbyStatus())
            {
               this.processLobbyStatus(param1.getLobbyStatus());
            }
            this.joinChatRoom();
         }
         this._gameInvites = param1.removeGameInvite(this._gameInvites);
      }
      
      private function createNewLobby() : void
      {
         var _loc1_:IAction = null;
         if(this._inviteQueueManager.isCapGame())
         {
            _loc1_ = this._inviteActionFactory.getCreateGroupFinderLobbyAction(this._inviteQueueManager.getSelectedGameQueueConfigId(),this._inviteGroup.groupId);
         }
         else if(this._inviteQueueManager.isCoopVsAiGame())
         {
            _loc1_ = this._inviteActionFactory.getCreateArrangedBotTeamLobbyAction(this._inviteQueueManager.getSelectedGameQueueConfigId(),this._inviteQueueManager.getGameDifficulty());
         }
         else if(!(this._inviteQueueManager.isPracticeGame() || this._inviteQueueManager.isRankedTeam()))
         {
            _loc1_ = this._inviteActionFactory.getCreateArrangedTeamLobbyAction(this._inviteQueueManager.getSelectedGameQueueConfigId());
         }
         if(_loc1_)
         {
            _loc1_.getCompleted().add(this.onLobbyCreateComplete);
            _loc1_.invoke();
         }
      }
      
      public function connectToLCDS() : void
      {
         this._clientMessageQueue = new MessageQueue("nonGame",this.onServerGameMessageReceived);
         this._messageRouterService.addClientNotificationMessageListener(this._clientMessageQueue.onMessageReceived);
      }
      
      private function isInviteAllowed(param1:InvitationRequest) : Boolean
      {
         if(AppConfig.instance.shutdownDisablePlayButton)
         {
            this.showCooldownAlert(param1.getInviterOrOwner());
            return false;
         }
         if(!ShutdownTimingTables.canJoinQueueRightNow("custom"))
         {
            this.showShutDownAlert(param1.getInviterOrOwner());
            return false;
         }
         if(this._chatBlockedRosterProvider != null && Boolean(this._chatBlockedRosterProvider.isBlockedBySummonerId(param1.getInviterOrOwner().summonerId)))
         {
            return false;
         }
         return true;
      }
      
      public function enablePendingInvites() : void
      {
         var _loc1_:ShowGameInviteAction = null;
         this._inviteGroup.pendingInvitesEnabled = true;
         for each(_loc1_ in this._gameInvites)
         {
            _loc1_.refreshGameInviteIfActive();
         }
      }
      
      private function getPendingInvitations() : void
      {
         var _loc1_:IAction = this._inviteActionFactory.getRetrievePendingInvitationsAction();
         _loc1_.getCompleted().add(this.onPendingInvitationsRetrieved);
         _loc1_.invoke();
      }
      
      private function onServerGameMessageReceived(param1:MessageEvent) : void
      {
         var _loc3_:RemovedFromLobbyNotification = null;
         var _loc4_:String = null;
         var _loc5_:AlertAction = null;
         var _loc2_:Object = param1.message.body;
         if(_loc2_ is InvitationRequest)
         {
            this.processInvitationRequest(_loc2_ as InvitationRequest);
         }
         else if(_loc2_ is LobbyStatus)
         {
            this.processLobbyStatus(_loc2_ as LobbyStatus);
         }
         else if(_loc2_ is InvitePrivileges)
         {
            this.processInvitationPrivilegesChanged(_loc2_.canInvite);
         }
         else if(_loc2_ is RemovedFromLobbyNotification)
         {
            _loc3_ = _loc2_ as RemovedFromLobbyNotification;
            if(_loc3_.removalReason == RemovalReason.PROGRESSED && this._inviteQueueManager.isCapGame())
            {
               return;
            }
            _loc4_ = this._inviteGroup.gameType;
            this._inviteController.setInviteGroupCancel(false);
            this._inviteActionFactory.getQuitGameAction(_loc4_,true).invoke();
            _loc5_ = this.createAlertForRemovedFromLobbyNotification(_loc2_ as RemovedFromLobbyNotification);
            if(_loc5_ != null)
            {
               _loc5_.setOkCancelLabels();
               _loc5_.showAffirmative = true;
               _loc5_.showNegative = false;
               _loc5_.add();
            }
         }
      }
      
      private function onOwnershipTransferred(param1:Object, param2:Object = null) : void
      {
         var _loc3_:IAction = null;
         if(param1 is Number)
         {
            _loc3_ = this._inviteActionFactory.getTransferOwnershipAction(this._inviteGroup.getParticipantBySummonerId(param1 as Number));
            _loc3_.invoke();
            this._ownerChangedSignal.dispatch(param1 as Number == this._inviteGroup.mySummonerId);
         }
      }
      
      private function onDelegateInvitePower(param1:InviteParticipant, param2:Boolean) : void
      {
         var _loc3_:IAction = this._inviteActionFactory.getChangeInvitePrivilegesAction(param1,param2);
         _loc3_.invoke();
      }
      
      private function createAlertForRemovedFromLobbyNotification(param1:RemovedFromLobbyNotification) : AlertAction
      {
         var _loc2_:String = this._inviteActionFactory.getResourceManagerString("invite_lobby_removed_title");
         var _loc3_:String = this._inviteActionFactory.getResourceManagerString("invite_lobby_removed_default");
         switch(param1.removalReason)
         {
            case RemovalReason.KICKED:
               _loc3_ = this._inviteActionFactory.getResourceManagerString("invite_lobby_removed_by_owner");
               break;
            case RemovalReason.DESTROYED:
               return null;
            case RemovalReason.PROGRESSED:
               return null;
            default:
               this.logger.warn("Received unknown removalReason: " + param1.removalReason);
         }
         return new AlertAction(_loc2_,_loc3_);
      }
      
      private function onVerifyInviteesRequested() : void
      {
         var _loc1_:InviteParticipant = null;
         for each(_loc1_ in this._inviteGroup.acceptedParticipants)
         {
            if(_loc1_.status != InviteParticipantState.OWNER)
            {
               _loc1_.verificationState = InviteVerificationState.ACK;
            }
         }
      }
      
      private function onParticipantKicked(param1:InviteParticipant) : void
      {
         var _loc2_:IAction = this._inviteActionFactory.getKickPlayerAction(param1);
         _loc2_.getErred().add(this.onKickErred);
         _loc2_.invoke();
      }
      
      private function checkAndCleanupExpiredInvitations() : void
      {
         var _loc3_:int = 0;
         var _loc4_:ShowGameInviteAction = null;
         var _loc1_:Vector.<ShowGameInviteAction> = this._gameInvites.filter(this.selectExpiredFunction);
         var _loc2_:int = _loc1_.length - MAX_EXPIRED_INVITATIONS;
         if(_loc2_ > 0)
         {
            _loc3_ = 0;
            while(_loc3_ < _loc2_)
            {
               _loc4_ = _loc1_.shift();
               if(_loc4_ != null)
               {
                  _loc4_.abort();
                  this._gameInvites = _loc4_.removeGameInvite(this._gameInvites);
               }
               _loc3_++;
            }
         }
      }
      
      public function connectInviteListeners() : void
      {
         this._inviteController.getInvitePowerDelegatedChangedSignal().add(this.onDelegateInvitePower);
         this._inviteController.getParticipantsAddedPracticeGameSignal().add(this.onParticipantsAdded);
         this._inviteController.getParticipantsAddedArrangedTeamSignal().add(this.onParticipantsAdded);
         this._inviteController.getParticipantCanceledSignal().add(this.onParticipantKicked);
         this._inviteController.getVerifyInviteesRequestedSignal().add(this.onVerifyInviteesRequested);
         this._inviteController.getLeaveLobbyRequestedSignal().add(this.onInviteGroupQuit);
         this._inviteController.getCloseLobbyRequestedSignal().add(this.onCloseLobbyRequested);
         this._inviteController.getInviteGroupClearedSignal().add(this.onInviteGroupCleared);
         this._inviteController.getInviteLobbyCreatedSignal().add(this.onInviteLobbyCreated);
         this._inviteController.getOwnershipTransferredSignal().add(this.onOwnershipTransferred);
         this._inviteController.getRankedTeamLobbyCreatedSignal().add(this.onRankedTeamLobbyCreated);
         this._inviteController.getEnablePendingInvitesSignal().add(this.enablePendingInvites);
         this._inviteController.getDisablePendingInvitesSignal().add(this.disablePendingInvites);
         this.getLobbyStatus();
         ProviderLookup.getProvider(IChatStateProvider,this.chatStateReady);
      }
      
      public function getLobbyCreatedSignal() : ISignal
      {
         return this._lobbyCreatedSignal;
      }
      
      private function processInvitationPrivilegesChanged(param1:Boolean) : void
      {
         var _loc2_:ChatMessageVO = null;
         var _loc3_:RosterItemVO = null;
         this._inviteGroup.allowedToInvite = param1;
         this._invitePrivilegeChangedSignal.dispatch(param1);
         if(this._inviteGroup.chatRoom)
         {
            _loc2_ = new ChatMessageVO();
            _loc2_.type = ChatMessageType.DELEGATE;
            _loc3_ = new RosterItemVO(this._inviteGroup.ownerParticipant.jid);
            _loc2_.rosterItem = _loc3_;
            if(param1)
            {
               _loc2_.body = this._inviteActionFactory.getRiotResourceString("teamSelectionView_InvitePowerDelegatedMessage","**Invite powers gained");
            }
            else
            {
               _loc2_.body = this._inviteActionFactory.getRiotResourceString("teamSelectionView_InvitePowerRevokedMessage","**Invite powers lost");
            }
            this._inviteGroup.chatRoom.addMessageToBuffer(_loc2_);
         }
      }
      
      private function joinLobbyFromLobbyStatus(param1:LobbyStatus) : void
      {
         this._inviteActionFactory.getJoinInviteLobbyAction(param1,this._inviteGroup,this._inviteController).invoke();
      }
      
      private function onLobbyCreateComplete(param1:ILobbyStatusAction) : void
      {
         this.processLobbyStatus(param1.getLobbyStatus(),true);
         this.joinChatRoom();
         this._lobbyCreatedSignal.dispatch();
      }
      
      private function onCloseLobbyRequested() : void
      {
         var _loc1_:IAction = this._inviteActionFactory.getCloseLobbyAction();
         _loc1_.invoke();
      }
      
      public function disconnectInviteListeners() : void
      {
         this._inviteController.getInvitePowerDelegatedChangedSignal().remove(this.onDelegateInvitePower);
         this._inviteController.getParticipantsAddedPracticeGameSignal().remove(this.onParticipantsAdded);
         this._inviteController.getParticipantsAddedArrangedTeamSignal().remove(this.onParticipantsAdded);
         this._inviteController.getParticipantCanceledSignal().remove(this.onParticipantKicked);
         this._inviteController.getVerifyInviteesRequestedSignal().remove(this.onVerifyInviteesRequested);
         this._inviteController.getLeaveLobbyRequestedSignal().remove(this.onInviteGroupQuit);
         this._inviteController.getCloseLobbyRequestedSignal().remove(this.onCloseLobbyRequested);
         this._inviteController.getInviteGroupClearedSignal().remove(this.onInviteGroupCleared);
         this._inviteController.getInviteLobbyCreatedSignal().remove(this.onInviteLobbyCreated);
         this._inviteController.getOwnershipTransferredSignal().remove(this.onOwnershipTransferred);
         this._inviteController.getRankedTeamLobbyCreatedSignal().remove(this.onRankedTeamLobbyCreated);
         this._inviteController.getEnablePendingInvitesSignal().remove(this.enablePendingInvites);
         this._inviteController.getDisablePendingInvitesSignal().remove(this.disablePendingInvites);
      }
      
      public function disablePendingInvites() : void
      {
         var _loc1_:ShowGameInviteAction = null;
         this._inviteGroup.pendingInvitesEnabled = false;
         for each(_loc1_ in this._gameInvites)
         {
            _loc1_.refreshGameInviteIfActive();
         }
      }
      
      public function getOwnerChangedSignal() : ISignal
      {
         return this._ownerChangedSignal;
      }
   }
}

