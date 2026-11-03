package com.riotgames.pvpnet.invite.action
{
   import blix.action.BasicAction;
   import blix.action.IAction;
   import com.riotgames.platform.common.AppConfig;
   import com.riotgames.platform.common.audio.AudioKeys;
   import com.riotgames.platform.common.event.ShellEvent;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.chat.INotificationsProvider;
   import com.riotgames.platform.gameclient.chat.domain.DockedPrompt;
   import com.riotgames.platform.gameclient.domain.ButtonNameType;
   import com.riotgames.platform.gameclient.domain.game.GameQueueConfig;
   import com.riotgames.platform.gameclient.domain.game.GameType;
   import com.riotgames.platform.gameclient.domain.gameconfig.GameTypeConfigManager;
   import com.riotgames.platform.gameclient.domain.gameinvite.InvitationPlayer;
   import com.riotgames.platform.gameclient.domain.gameinvite.InvitationState;
   import com.riotgames.platform.gameclient.domain.gameinvite.InviteType;
   import com.riotgames.platform.gameclient.domain.gameinvite.Inviter;
   import com.riotgames.platform.gameclient.domain.gameinvite.LobbyStatus;
   import com.riotgames.pvpnet.game.domain.GameVersionConfig;
   import com.riotgames.pvpnet.invite.IInviteController;
   import com.riotgames.pvpnet.invite.PlatformInviteActionFactory;
   import com.riotgames.pvpnet.invite.controller.InviteQueueManager;
   import com.riotgames.pvpnet.invite.model.GameInvite;
   import com.riotgames.pvpnet.invite.model.InviteGroup;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.pvpnet.system.leagues.LeagueCache;
   import com.riotgames.pvpnet.system.leagues.LeagueTier;
   import com.riotgames.pvpnet.system.maestro.MaestroProviderProxy;
   import com.riotgames.pvpnet.system.messaging.ShellDispatcher;
   import flash.utils.getQualifiedClassName;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class ShowGameInviteAction extends BasicAction implements ILobbyStatusAction
   {
      
      private var _isPlayerAllowedToAccept:Boolean = true;
      
      private var _gameInvite:GameInvite;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var _isAccepting:Boolean = false;
      
      private var _gameTypeConfigManager:GameTypeConfigManager;
      
      private var _inviteController:IInviteController;
      
      private var _lobbyStatus:LobbyStatus;
      
      private var _inviteQueueManager:InviteQueueManager;
      
      private var _inviteActionFactory:PlatformInviteActionFactory;
      
      private var _dockedPrompt:DockedPrompt;
      
      private var _inviteGroup:InviteGroup;
      
      private var _shellDispatcher:ShellDispatcher;
      
      private var _notificationsProvider:INotificationsProvider;
      
      public function ShowGameInviteAction(param1:GameInvite, param2:IInviteController, param3:INotificationsProvider, param4:GameTypeConfigManager, param5:ShellDispatcher, param6:PlatformInviteActionFactory, param7:InviteGroup, param8:InviteQueueManager)
      {
         super(false);
         this._gameInvite = param1;
         this._notificationsProvider = param3;
         this._inviteActionFactory = param6;
         this._inviteController = param2;
         this._gameTypeConfigManager = param4;
         this._shellDispatcher = param5;
         this._inviteGroup = param7;
         this._inviteQueueManager = param8;
      }
      
      public function updateGameInvite(param1:String) : void
      {
         this._gameInvite.invitationState = param1;
         this.refreshGameInvite();
      }
      
      private function onInviteCompleted(param1:ILobbyStatusAction) : void
      {
         this._lobbyStatus = param1.getLobbyStatus();
         complete();
      }
      
      private function onInviteDismissed(param1:String, param2:IAction) : void
      {
         this.abort();
      }
      
      private function setInvitationExpired() : void
      {
         this._dockedPrompt.unread = true;
         this._dockedPrompt.message = this._inviteActionFactory.getResourceManagerString("invite_lobby_closed_notification",[this._gameInvite.getInviterName()]);
         this._dockedPrompt.rightButtonLabel = "";
         this._dockedPrompt.leftButtonLabel = this._inviteActionFactory.getResourceManagerString("common_button_ok");
         this._dockedPrompt.closeHandlerCallback = this.onInviteDismissed;
         this._dockedPrompt.closeHandlerProperty = this;
         this._dockedPrompt.leftButtonDisabled = false;
      }
      
      private function getInviteTopLine(param1:GameInvite) : String
      {
         switch(param1.inviteType)
         {
            case InviteType.FRIEND_OF_FRIEND:
               return this._inviteActionFactory.getRiotResourceString("XMPP-FOF-PLAYER-INVITE","",[this._gameInvite.getInviterName(),this._gameInvite.commonFriendName]);
            case InviteType.HONORED_PLAYER:
               return this._inviteActionFactory.getRiotResourceString("XMPP-HONORED-PLAYER-INVITE","",[this._gameInvite.getInviterName()]);
            case InviteType.VICTORIOUS_COMRADE:
               return this._inviteActionFactory.getRiotResourceString("XMPP-VICTORIOUS-COMRADE-INVITE","",[this._gameInvite.getInviterName()]);
            default:
               return this._inviteActionFactory.getRiotResourceString("XMPP-NORMAL-GAME-INVITE","You have been invited to play a game.",[this._gameInvite.getInviterName()]);
         }
      }
      
      override protected function doInvocation() : void
      {
         this._shellDispatcher.dispatchEvent(new ShellEvent(ShellEvent.NOTIFY));
         this._inviteActionFactory.playSound(AudioKeys.SOUND_GAME_INVITE);
         var _loc1_:int = -1;
         var _loc2_:InvitationPlayer = this._gameInvite.getFirstInviter();
         if(_loc2_ is Inviter)
         {
            _loc1_ = int(LeagueCache.getIconRewardForTier(LeagueTier.valueOf((_loc2_ as Inviter).previousSeasonHighestTier)));
         }
         this._dockedPrompt = DockedPrompt.create(this.getMessage(),this._inviteActionFactory.getResourceManagerString("XMPP-GAME-INVITE-TITLE"),this._gameInvite.getInviterName(),this._inviteActionFactory.getResourceManagerString("common_button_accept"),this._inviteActionFactory.getResourceManagerString("common_button_decline"),DockedPrompt.TYPE_GAME_INVITE,this.handleInviteResponse,this,true,_loc1_);
         this.updateGameInvite(this._gameInvite.invitationState);
         this._notificationsProvider.showDockedPrompt(this._dockedPrompt);
      }
      
      public function getIsAccepted() : Boolean
      {
         return this._isAccepting;
      }
      
      private function refreshGameInvite() : void
      {
         if(this._gameInvite.invitationState == InvitationState.ACTIVE && Boolean(this._inviteGroup.pendingInvitesEnabled))
         {
            this.setInvitationActive();
         }
         else if(this._gameInvite.invitationState == InvitationState.ON_HOLD || this._gameInvite.invitationState == InvitationState.ACTIVE && !this._inviteGroup.pendingInvitesEnabled)
         {
            this.setInvitationOnHold();
         }
         else if(this._gameInvite.invitationState == InvitationState.REVOKED)
         {
            this.setInvitationExpired();
         }
         else
         {
            this.logger.error("Unknown InvitationState: " + this._gameInvite.invitationState);
         }
      }
      
      private function setInvitationActive() : void
      {
         this._dockedPrompt.unread = true;
         this._dockedPrompt.message = this.getMessage();
         this._dockedPrompt.leftButtonDisabled = false;
      }
      
      public function isInvitationExpired() : Boolean
      {
         return this._gameInvite.invitationState === InvitationState.REVOKED;
      }
      
      public function refreshGameInviteIfActive() : void
      {
         if(this._gameInvite.invitationState == InvitationState.ACTIVE)
         {
            this.refreshGameInvite();
         }
      }
      
      public function getGameInvitationId() : String
      {
         return this._gameInvite.invitationId;
      }
      
      override public function abort() : void
      {
         this._notificationsProvider.removeNotification(this._dockedPrompt,"common_button_ok");
         super.abort();
      }
      
      private function handleInviteResponse(param1:String, param2:IAction) : void
      {
         var _loc4_:AlertAction = null;
         var _loc3_:Boolean = param1 == ButtonNameType.RIGHT_BUTTON || Boolean(AppConfig.instance.otherGameInProgress);
         if(Boolean(GameVersionConfig.instance.isWorking) && !_loc3_)
         {
            _loc4_ = new AlertAction(RiotResourceLoader.getString("invite_joinGameResponse_confirmCancelPatchTitle"),RiotResourceLoader.getString("invite_joinGameResponse_confirmCancelPatch"));
            _loc4_.showNegative = true;
            _loc4_.setYesNoLabels();
            _loc4_.getCompleted().add(this.onConfirmPatchDecision);
            _loc4_.add();
         }
         else
         {
            this.respondToInvite(!_loc3_);
         }
      }
      
      private function handlePatchCancel() : void
      {
         this.respondToInvite(this._isAccepting);
      }
      
      private function onConfirmPatchDecision(param1:AlertAction) : void
      {
         this._isAccepting = param1.affirmativeResponse;
         if(Boolean(GameVersionConfig.instance.isWorking) && Boolean(param1.affirmativeResponse))
         {
            GameVersionConfig.instance.getIsWorkingChanged().add(this.handlePatchCancel);
            if(GameVersionConfig.instance.installingPatch)
            {
               MaestroProviderProxy.instance.cancelInstall();
            }
            else if(GameVersionConfig.instance.uninstallingPatch)
            {
               MaestroProviderProxy.instance.cancelUninstall();
            }
         }
         else
         {
            this.respondToInvite(this._isAccepting);
         }
      }
      
      private function setInvitationOnHold() : void
      {
         this._dockedPrompt.unread = true;
         this._dockedPrompt.message = this._inviteActionFactory.getResourceManagerString("invite_on_hold",[this._gameInvite.getInviterName()]);
         this._dockedPrompt.leftButtonDisabled = true;
      }
      
      public function addInviter(param1:Inviter) : Boolean
      {
         var _loc2_:Boolean = this._gameInvite.addInviter(param1);
         if(_loc2_)
         {
            this._dockedPrompt.message = this.getMessage();
            this._dockedPrompt.fromName = this._gameInvite.getInviterName();
         }
         return _loc2_;
      }
      
      private function respondToInvite(param1:Boolean) : void
      {
         GameVersionConfig.instance.getIsWorkingChanged().remove(this.handlePatchCancel);
         this._isAccepting = param1;
         var _loc2_:IAction = this._inviteActionFactory.getRespondToInviteAction(this._gameInvite,this._inviteController,param1,this._inviteGroup,this._inviteQueueManager);
         _loc2_.getCompleted().add(this.onInviteCompleted);
         _loc2_.getErred().add(this.onInviteCompleted);
         _loc2_.invoke();
      }
      
      public function getLobbyStatus() : LobbyStatus
      {
         return this._lobbyStatus;
      }
      
      private function getMessage() : String
      {
         var _loc3_:String = null;
         var _loc4_:String = null;
         var _loc5_:String = null;
         var _loc6_:Array = null;
         var _loc7_:String = null;
         var _loc8_:String = null;
         var _loc9_:String = null;
         var _loc10_:Array = null;
         var _loc11_:String = null;
         var _loc12_:String = null;
         var _loc13_:String = null;
         var _loc14_:Array = null;
         var _loc15_:String = null;
         var _loc16_:String = null;
         var _loc17_:String = null;
         var _loc18_:Array = null;
         var _loc1_:String = "";
         var _loc2_:String = "";
         if(this._gameInvite.gameType != GameType.CUSTOM_GAME || this._gameInvite.gameType != GameType.PRACTICE_GAME)
         {
            if(this._gameInvite.gameTypeId == GameQueueConfig.CAP_QUEUE_1V1 || this._gameInvite.gameTypeId == GameQueueConfig.CAP_QUEUE_5V5)
            {
               _loc2_ = "cap_game_mode_title";
            }
            else if(this._gameInvite.gameType == GameType.COOP_VS_AI)
            {
               _loc2_ = this._gameInvite.gameMode.toLowerCase() + "_pve_game_mode_title";
            }
            else
            {
               _loc2_ = this._gameInvite.gameMode.toLowerCase() + "_pvp_game_mode_title";
            }
         }
         if(this._gameInvite.gameType == GameType.NORMAL_GAME)
         {
            _loc3_ = this.getInviteTopLine(this._gameInvite);
            _loc4_ = "";
            if(this._gameInvite.inviteType == InviteType.TEAM_BUILDER_SUGGESTED)
            {
               _loc4_ = this._inviteActionFactory.getRiotResourceString("XMPP-TEAM-BUILDER-SOLO-PLAY-AGAIN-INVITE","");
            }
            _loc6_ = [this._inviteActionFactory.getRiotResourceString(_loc2_,"**" + this._gameInvite.gameMode),this._inviteActionFactory.getMapResourceString("displayname",this._gameInvite.mapId,"**League of Legends"),this._inviteActionFactory.getRiotResourceString("summonerProfile_profile_statsHeaderNormal","**Normal")];
            _loc5_ = this._inviteActionFactory.getRiotResourceString("XMPP-NORMAL-GAME-INVITE-GAME-MODE-INFO","**",_loc6_);
            _loc1_ = _loc3_ + _loc4_ + _loc5_;
         }
         else if(this._gameInvite.gameType == GameType.RANKED_GAME || this._gameInvite.gameType == GameType.RANKED_GAME_PREMADE || this._gameInvite.gameType == GameType.RANKED_TEAM_GAME)
         {
            if(!this._gameInvite.teamName || this._gameInvite.teamName == "")
            {
               _loc7_ = this.getInviteTopLine(this._gameInvite);
               _loc8_ = "";
               _loc10_ = [this._inviteActionFactory.getRiotResourceString(_loc2_,"**" + this._gameInvite.gameMode),this._inviteActionFactory.getMapResourceString("displayname",this._gameInvite.mapId,"**League of Legends"),this._inviteActionFactory.getRiotResourceString("summonerProfile_profile_statsHeaderRanked","Ranked")];
               _loc9_ = RiotResourceLoader.getString("XMPP-RANKED-GAME-INVITE-GAME-INFO","**",_loc10_);
               _loc1_ = _loc7_ + _loc8_ + _loc9_;
            }
            else
            {
               _loc1_ = this._inviteActionFactory.getRiotResourceString("XMPP-RANKED-TEAM-GAME-INVITE","**Ranked game invite",[this._gameInvite.getInviterName(),this._inviteActionFactory.getRiotResourceString(_loc2_,"**" + this._gameInvite.gameMode),this._inviteActionFactory.getMapResourceString("displayname",this._gameInvite.mapId,"**League of Legends"),this._gameInvite.teamName]);
            }
         }
         else if(this._gameInvite.gameType == GameType.COOP_VS_AI)
         {
            _loc11_ = this.getInviteTopLine(this._gameInvite);
            _loc12_ = "";
            _loc14_ = [this._inviteActionFactory.getRiotResourceString("practiceGame_gameMode_COOP_VS_AI_GAME","**PvE"),this._inviteActionFactory.getMapResourceString("displayname",this._gameInvite.mapId,"**League of Legends"),this._inviteActionFactory.getRiotResourceString("practiceGame_difficulty_" + this._gameInvite.gameDifficulty.toLowerCase(),"**Difficult")];
            _loc13_ = RiotResourceLoader.getString("XMPP-COOPVSAI-GAME-INVITE-GAME-INFO","",_loc14_);
            _loc1_ = _loc11_ + _loc12_ + _loc13_;
         }
         else
         {
            _loc15_ = this.getInviteTopLine(this._gameInvite);
            _loc16_ = "";
            _loc18_ = [this._inviteActionFactory.getMapResourceString("displayname",this._gameInvite.mapId,"**League of Legends"),this._inviteActionFactory.getRiotResourceString("practiceGame_gameMode_" + this._gameTypeConfigManager.getGameTypeConfig(this._gameInvite.gameTypeId).name,"**Custom")];
            _loc17_ = this._inviteActionFactory.getRiotResourceString("XMPP-PRACTICE-GAME-INVITE-GAME-INFO","**",_loc18_);
            _loc1_ = _loc15_ + _loc16_ + _loc17_;
         }
         return _loc1_;
      }
      
      public function removeGameInvite(param1:Vector.<ShowGameInviteAction>) : Vector.<ShowGameInviteAction>
      {
         var _loc3_:ShowGameInviteAction = null;
         var _loc2_:Vector.<ShowGameInviteAction> = new Vector.<ShowGameInviteAction>();
         for each(_loc3_ in param1)
         {
            if(_loc3_.getGameInvitationId() != this.getGameInvitationId())
            {
               _loc2_.push(_loc3_);
            }
         }
         return _loc2_;
      }
   }
}

