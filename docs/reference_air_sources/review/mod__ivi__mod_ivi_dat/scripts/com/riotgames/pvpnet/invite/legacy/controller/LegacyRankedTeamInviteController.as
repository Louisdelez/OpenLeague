package com.riotgames.pvpnet.invite.legacy.controller
{
   import com.riotgames.platform.common.provider.ISoundProvider;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.chat.IChatProvider;
   import com.riotgames.platform.gameclient.domain.game.GameType;
   import com.riotgames.platform.gameclient.domain.invite.InviteState;
   import com.riotgames.platform.gameclient.domain.lobby.LobbyViewState;
   import com.riotgames.platform.gameclient.domain.rankedTeams.Player;
   import com.riotgames.platform.gameclient.domain.rankedTeams.Team;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamId;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamInfo;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamMemberInfo;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamMemberStatus;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.game.controllers.MasterGameViewController;
   import com.riotgames.pvpnet.game.controllers.lobby.ILobbyViewController;
   import com.riotgames.pvpnet.game.controllers.lobby.LobbyConfig;
   import com.riotgames.pvpnet.game.domain.GameQueueManager;
   import com.riotgames.pvpnet.invite.IInviteRankedTeamController;
   import com.riotgames.pvpnet.invite.model.InviteGroup;
   import com.riotgames.pvpnet.rankedteams.ILegacyTeamProfileNavigationProvider;
   import com.riotgames.pvpnet.rankedteams.IRankedTeamsProvider;
   import com.riotgames.pvpnet.rankedteams.RankedTeamEvent;
   import com.riotgames.pvpnet.rankedteams.RankedTeamsProviderProxy;
   import com.riotgames.pvpnet.summonerprofile.ISummonerProfileProvider;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.pvpnet.system.alerter.AlertWaitAction;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.messaging.ShellDispatcher;
   import flash.events.EventDispatcher;
   import flash.utils.getQualifiedClassName;
   import mx.events.PropertyChangeEvent;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.rpc.events.ResultEvent;
   import org.igniterealtime.xiff.data.Message;
   
   public class LegacyRankedTeamInviteController extends EventDispatcher implements ILegacyTeamProfileNavigationProvider, IInviteRankedTeamController
   {
      
      private var _lastSelectedTeamInfo:Team;
      
      private var profileTeamToView:TeamId = null;
      
      private var _masterGameViewController:MasterGameViewController;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var retrievingRankedTeamsWaitAction:AlertWaitAction;
      
      private var _soundProvider:ISoundProvider;
      
      private var _serviceProxy:ServiceProxy;
      
      private var findTeamRequestQueue:Array = [];
      
      private var _numTeams:int = 0;
      
      private var _shellDispatcher:ShellDispatcher;
      
      private var _teamPlayer:Player = null;
      
      private var _inviteGroup:InviteGroup;
      
      private var _chatProvider:IChatProvider;
      
      private var _clientConfig:ClientConfig;
      
      private var _gameQueueManager:GameQueueManager;
      
      private var _lobbyController:ILobbyViewController;
      
      private var _summonerProfileProvider:ISummonerProfileProvider;
      
      private var _session:Session;
      
      public function LegacyRankedTeamInviteController(param1:ServiceProxy, param2:Session, param3:ClientConfig, param4:ShellDispatcher, param5:ISoundProvider, param6:GameQueueManager, param7:MasterGameViewController, param8:ILobbyViewController, param9:ISummonerProfileProvider, param10:InviteGroup, param11:IChatProvider)
      {
         super();
         this._serviceProxy = param1;
         this._session = param2;
         this._clientConfig = param3;
         this._shellDispatcher = param4;
         this._soundProvider = param5;
         this._gameQueueManager = param6;
         this._masterGameViewController = param7;
         this._lobbyController = param8;
         this._summonerProfileProvider = param9;
         this._inviteGroup = param10;
         this.setChatProvider(param11);
      }
      
      public function goToTeam(param1:TeamId) : void
      {
         if(!LobbyConfig.instance.isNavigationEnabled)
         {
            return;
         }
         this.profileTeamToView = param1;
         if(LobbyConfig.instance.currentLobbyState == LobbyViewState.SUMMONER_INFO_STATE && Boolean(this._summonerProfileProvider.isLocalSummoner))
         {
            this.ExecuteShowTeam();
         }
         else
         {
            LobbyConfig.instance.currentLobbyStateChanged.add(this.onCurrentLobbyStateChangedForShowTeam);
            this._lobbyController.showProfileView();
         }
      }
      
      private function onLeftTeam(param1:String) : void
      {
         var _loc2_:AlertAction = null;
         if(this.isInRankedTeamLobby())
         {
            if(Boolean(this._gameQueueManager.rankedTeamName) && this._gameQueueManager.rankedTeamName == param1)
            {
               this._masterGameViewController.cancelJoinQueueView();
               _loc2_ = new AlertAction(ResourceManager.getInstance().getString("resources","general_generalAlertErrorTitle"),ResourceManager.getInstance().getString("resources","rankedTeams_error_arranged_team_left_team"));
               _loc2_.add();
            }
         }
      }
      
      private function onCurrentLobbyStateChangedForShowTeam() : void
      {
         LobbyConfig.instance.currentLobbyStateChanged.remove(this.onCurrentLobbyStateChangedForShowTeam);
         if(this.profileTeamToView != null && this._summonerProfileProvider.currentSummoner != null)
         {
            this.ExecuteShowTeam();
         }
      }
      
      private function onUpdatePlayer(param1:RankedTeamEvent) : void
      {
         this.teamPlayer = param1.teamPlayer;
      }
      
      private function countNumTeams() : void
      {
         var _loc1_:TeamInfo = null;
         this._numTeams = 0;
         if(this.teamPlayer)
         {
            for each(_loc1_ in this.teamPlayer.playerTeams)
            {
               if(_loc1_.memberStatusString == TeamMemberStatus.MEMBER)
               {
                  ++this._numTeams;
               }
            }
         }
      }
      
      private function set _1589391458teamPlayer(param1:Player) : void
      {
         var _loc2_:Boolean = this._teamPlayer == null && param1 != null;
         this._teamPlayer = param1;
         this.onPlayerChanged();
         if(_loc2_ && Boolean(ClientConfig.instance.teamServiceEnabled))
         {
            this.rankedTeamsProvider.processNotifications(this._teamPlayer);
         }
      }
      
      public function get teamPlayer() : Player
      {
         return this._teamPlayer;
      }
      
      private function chatController_handleRankTeamUpdated(param1:Message) : void
      {
         this.rankedTeamsProvider.handleP2PMessage(param1);
      }
      
      public function findTeamById(param1:TeamId, param2:Function) : void
      {
         var _loc3_:IResourceManager = null;
         this.findTeamRequestQueue.push([param1,param2]);
         if(this.findTeamRequestQueue.length == 1)
         {
            if(this.retrievingRankedTeamsWaitAction == null)
            {
               _loc3_ = ResourceManager.getInstance();
               this.retrievingRankedTeamsWaitAction = new AlertWaitAction(_loc3_.getString("resources","serverWait_retrievingDataMessage"),_loc3_.getString("resources","serverWait_loadingMessage"));
            }
            this.retrievingRankedTeamsWaitAction.add();
            this._serviceProxy.teamService.findTeamById(param1,this.onExternalFindTeamSuccess,this.onExternalFindTeamComplete,this.onError);
         }
      }
      
      private function get rankedTeamsProvider() : IRankedTeamsProvider
      {
         return RankedTeamsProviderProxy.instance;
      }
      
      private function onExternalFindTeamSuccess(param1:ResultEvent) : void
      {
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         if(this.findTeamRequestQueue.length > 0)
         {
            _loc2_ = this.findTeamRequestQueue.shift();
            _loc2_[1](param1);
            if(this.findTeamRequestQueue.length > 0)
            {
               _loc3_ = this.findTeamRequestQueue[0];
               this._serviceProxy.teamService.findTeamById(_loc3_[0],this.onExternalFindTeamSuccess,null,this.onError);
            }
         }
      }
      
      public function getLastSelectedTeam() : Team
      {
         return this._lastSelectedTeamInfo;
      }
      
      public function set teamPlayer(param1:Player) : void
      {
         var _loc2_:Object = this.teamPlayer;
         if(_loc2_ !== param1)
         {
            this._1589391458teamPlayer = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"teamPlayer",_loc2_,param1));
         }
      }
      
      private function onRequestAddFriend(param1:RankedTeamEvent) : void
      {
         this._chatProvider.addBuddy(param1.summonerName);
      }
      
      public function get numTeams() : int
      {
         return this._numTeams;
      }
      
      public function setLastSelectedTeam(param1:Team) : void
      {
         this._lastSelectedTeamInfo = param1;
      }
      
      private function onError(param1:Object) : void
      {
         var _loc2_:String = RiotResourceLoader.getResourceString("rankedTeams","ranked_team_error_header","**Error");
         var _loc3_:String = "RT_" + param1.errorCode;
         _loc3_ = RiotResourceLoader.getResourceString("rankedTeams",_loc3_,null);
         if(!_loc3_)
         {
            _loc3_ = RiotResourceLoader.getResourceString("rankedTeams","RT_UNKNOWN","**Unknown error");
         }
         this.logger.error("error code: " + param1.errorCode);
         var _loc4_:AlertAction = new AlertAction(_loc2_,_loc3_);
         _loc4_.add();
      }
      
      public function connect() : void
      {
         this._shellDispatcher.addEventListener(RankedTeamEvent.UPDATE_PLAYER,this.onUpdatePlayer);
         this._shellDispatcher.addEventListener(RankedTeamEvent.REQUEST_ADD_FRIEND,this.onRequestAddFriend);
         this._shellDispatcher.addEventListener(RankedTeamEvent.REQUEST_VIEW_PROFILE,this.onRequestViewProfile);
         this._shellDispatcher.addEventListener(RankedTeamEvent.REQUEST_RETURN_TO_MATCH_DETAILS,this.onRequestReturnToMatchDetails);
         ProviderLookup.publishProvider(ILegacyTeamProfileNavigationProvider,this);
      }
      
      public function setChatProvider(param1:IChatProvider) : void
      {
         if(this._chatProvider)
         {
            this._chatProvider.getChatRankedTeamUpdatedSignal().remove(this.chatController_handleRankTeamUpdated);
         }
         this._chatProvider = param1;
         if(this._chatProvider)
         {
            this._chatProvider.getChatRankedTeamUpdatedSignal().add(this.chatController_handleRankTeamUpdated);
         }
      }
      
      public function isPlayerGuest(param1:Number) : Boolean
      {
         var _loc3_:TeamMemberInfo = null;
         var _loc2_:Boolean = true;
         for each(_loc3_ in this.getLastSelectedTeam().roster.memberList)
         {
            if(param1 == _loc3_.playerId)
            {
               _loc2_ = false;
            }
         }
         return _loc2_;
      }
      
      private function ExecuteShowTeam() : void
      {
         this.rankedTeamsProvider.setActiveRankedTeam(this.profileTeamToView);
      }
      
      private function onPlayerChanged() : void
      {
         var _loc1_:TeamInfo = null;
         var _loc2_:TeamInfo = null;
         this.countNumTeams();
         if(this.isInRankedTeamLobby())
         {
            if(Boolean(this._gameQueueManager.rankedTeamName) && this._gameQueueManager.rankedTeamName != GameQueueManager.TEAM_NAME_UNSELECTED)
            {
               _loc1_ = null;
               for each(_loc2_ in this.teamPlayer.playerTeams)
               {
                  if(this._gameQueueManager.rankedTeamName == _loc2_.name)
                  {
                     _loc1_ = _loc2_;
                     break;
                  }
               }
               if(!_loc1_ || _loc1_.memberStatusString != TeamMemberStatus.MEMBER)
               {
                  this.onLeftTeam(this._gameQueueManager.rankedTeamName);
               }
            }
         }
      }
      
      private function onRequestReturnToMatchDetails(param1:RankedTeamEvent) : void
      {
         this._lobbyController.requestLobbyState(LobbyViewState.SUMMONER_INFO_STATE);
      }
      
      private function onExternalFindTeamComplete(param1:Object) : void
      {
         if(this.retrievingRankedTeamsWaitAction)
         {
            this.retrievingRankedTeamsWaitAction.complete();
         }
      }
      
      private function onRequestViewProfile(param1:RankedTeamEvent) : void
      {
         this._lobbyController.searchForSummoner(param1.summonerName,null,true);
      }
      
      private function isInRankedTeamLobby() : Boolean
      {
         return this._inviteGroup.inviteState != InviteState.NONE && (this._inviteGroup.gameType == GameType.RANKED_GAME_PREMADE || this._inviteGroup.gameType == GameType.RANKED_TEAM_GAME);
      }
   }
}

