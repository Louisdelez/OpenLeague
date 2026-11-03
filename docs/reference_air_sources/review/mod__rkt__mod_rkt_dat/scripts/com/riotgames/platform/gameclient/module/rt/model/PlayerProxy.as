package com.riotgames.platform.gameclient.module.rt.model
{
   import com.riotgames.platform.common.audio.AudioKeys;
   import com.riotgames.platform.common.error.ServerError;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.gameclient.domain.LeagueItemDTO;
   import com.riotgames.platform.gameclient.domain.SummonerLeagueItemsDTO;
   import com.riotgames.platform.gameclient.domain.rankedTeams.Player;
   import com.riotgames.platform.gameclient.domain.rankedTeams.Team;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamId;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamInfo;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamMemberStatus;
   import com.riotgames.platform.gameclient.module.rt.RTFacade;
   import com.riotgames.platform.gameclient.module.rt.controller.RTLogCommand;
   import com.riotgames.platform.gameclient.module.rt.controller.RTNotifyTeamStatusUpdate;
   import com.riotgames.platform.gameclient.module.rt.controller.RTRefreshProfileTeamCommand;
   import com.riotgames.platform.gameclient.module.rt.controller.RTSendInviteCommand;
   import com.riotgames.platform.gameclient.module.rt.controller.RTSendKickCommand;
   import com.riotgames.platform.gameclient.module.rt.controller.RTShowServiceError;
   import com.riotgames.platform.gameclient.services.TeamService;
   import com.riotgames.pvpnet.rankedteams.RankedTeamEvent;
   import flash.events.TimerEvent;
   import flash.utils.Timer;
   import mx.messaging.messages.ErrorMessage;
   import mx.rpc.events.ResultEvent;
   import org.puremvc.as3.multicore.patterns.proxy.Proxy;
   
   public class PlayerProxy extends Proxy
   {
      
      public static const NAME:String = "PlayerProxy";
      
      private var playerRefreshScheduled:Boolean = false;
      
      private var _localPlayer:Player = null;
      
      public function PlayerProxy(param1:String = "PlayerProxy", param2:Object = null)
      {
         super(param1,param2);
      }
      
      public function disbandTeam(param1:TeamId) : void
      {
         var delegate:Function;
         var teamId:TeamId = param1;
         this.serviceStateProxy.onServiceCall();
         delegate = function(param1:ResultEvent):void
         {
            onDisbandTeamSuccess(teamId);
         };
         this.teamService.disbandTeam(teamId,delegate,this.onComplete,this.onError);
      }
      
      public function ownerLeaveTeam(param1:Number, param2:TeamId) : void
      {
         this.serviceStateProxy.onServiceCall();
         this.teamService.ownerLeaveTeam(param1,param2,this.onOwnerLeaveTeamSuccess,this.onComplete,this.onError);
      }
      
      private function onRefreshTimerComplete(param1:TimerEvent) : void
      {
         this.playerRefreshScheduled = false;
         this.teamService.findOrCreateLocalPlayer(this.onFindLocalPlayerSuccess,null,this.onFindLocalPlayerError);
      }
      
      private function onGetLeaguePositions(param1:ResultEvent) : void
      {
         if(param1.result is SummonerLeagueItemsDTO)
         {
            ServiceProxy.instance.leagueService.cache.updatePrescenceData(param1.result as SummonerLeagueItemsDTO);
         }
         var _loc2_:LeagueItemDTO = ServiceProxy.instance.leagueService.cache.getTopLeagueForChatPrescence();
         this.chatController.presenceController.updateLeagueData(_loc2_);
      }
      
      public function kickPlayer(param1:Number, param2:TeamId, param3:String) : void
      {
         var playerId:Number = param1;
         var teamId:TeamId = param2;
         var playerName:String = param3;
         var delegate:Function = function(param1:ResultEvent):void
         {
            onKickPlayerSuccess(param1.result as Team,playerId,playerName);
         };
         this.serviceStateProxy.onServiceCall();
         this.teamService.kickPlayer(playerId,teamId,delegate,this.onComplete,this.onError);
      }
      
      private function onCancelInviteSuccess(param1:ResultEvent) : void
      {
         facade.sendNotification(RTRefreshProfileTeamCommand.REFRESH);
      }
      
      public function onFindPlayerSuccess(param1:ResultEvent) : void
      {
         if(!RTFacade.profilePlayerProxy.isLocal)
         {
            RTFacade.profilePlayerProxy.player = param1.result as Player;
         }
      }
      
      public function onFindPlayerError(param1:ServerError) : void
      {
         sendNotification(RTLogCommand.ERROR,ErrorMessage(param1.faultEvent.message).faultString);
      }
      
      public function retrieveLocalPlayer() : void
      {
         var _loc1_:Timer = null;
         if(!this.playerRefreshScheduled)
         {
            _loc1_ = new Timer(125,1);
            _loc1_.addEventListener(TimerEvent.TIMER,this.onRefreshTimerComplete);
            _loc1_.start();
            this.playerRefreshScheduled = true;
         }
      }
      
      public function invitePlayer(param1:Number, param2:TeamId, param3:String) : void
      {
         var pendingInviteObj:Object = null;
         var playerId:Number = param1;
         var teamId:TeamId = param2;
         var teamName:String = param3;
         pendingInviteObj = {
            "playerId":playerId,
            "teamId":teamId,
            "teamName":teamName
         };
         var delegate:Function = function(param1:ResultEvent):void
         {
            onInvitePlayerSuccess(pendingInviteObj);
         };
         this.serviceStateProxy.onServiceCall();
         this.teamService.invitePlayer(playerId,teamId,delegate,this.onComplete,this.onError);
      }
      
      private function onInviteDeclinedError(param1:Object) : void
      {
         facade.sendNotification(RTRefreshProfileTeamCommand.REFRESH);
         this.retrieveLocalPlayer();
      }
      
      private function onFindLocalPlayerError(param1:ServerError) : void
      {
         sendNotification(RTLogCommand.ERROR,ErrorMessage(param1.faultEvent.message).faultString);
      }
      
      private function onFindLocalPlayerSuccess(param1:ResultEvent) : void
      {
         this.setLocalPlayer(param1.result as Player);
         if(RTFacade.profilePlayerProxy.isLocal)
         {
            RTFacade.profilePlayerProxy.player = this.localPlayer();
         }
      }
      
      public function get teamService() : TeamService
      {
         return RTFacade.instance.rtProvider.serviceProxy.teamService;
      }
      
      public function get chatController() : ChatController
      {
         return RTFacade.instance.rtProvider.chatController;
      }
      
      private function onKickPlayerSuccess(param1:Team, param2:Number, param3:String) : void
      {
         facade.sendNotification(RTSendKickCommand.KICK,RTSendKickCommand.BuildCommandArgs(param1,param2,param3));
         facade.sendNotification(RTRefreshProfileTeamCommand.REFRESH);
      }
      
      public function declineInvite(param1:TeamId) : void
      {
         this.serviceStateProxy.onServiceCall();
         this.teamService.declineInvite(param1,this.onDeclineInviteSuccess,this.onComplete,this.onInviteDeclinedError);
      }
      
      private function onDisbandTeamSuccess(param1:TeamId) : void
      {
         var _loc3_:TeamInfo = null;
         var _loc2_:TeamId = null;
         for each(_loc3_ in this.localPlayer().playerTeams)
         {
            if(!_loc3_.teamId.Compare(param1) && (_loc3_.memberStatusString == TeamMemberStatus.MEMBER || _loc3_.memberStatusString == TeamMemberStatus.INVITED))
            {
               _loc2_ = _loc3_.teamId;
               break;
            }
         }
         if(_loc2_ != null)
         {
            RTFacade.teamProxy.showTeamById(_loc2_,false);
         }
         else
         {
            RTFacade.profileTeamProxy.team = null;
         }
         this.updateChatPresenceData();
         this.retrieveLocalPlayer();
      }
      
      private function onOwnerLeaveTeamSuccess(param1:ResultEvent) : void
      {
         var _loc2_:Team = param1.result as Team;
         this.onLeaveTeamSuccess(param1);
         sendNotification(RTNotifyTeamStatusUpdate.NOTIFY_TEAM_STATUS_UPDATE,RTNotifyTeamStatusUpdate.BuildCommandArgs(_loc2_,RTNotifyTeamStatusUpdate.NEW_OWNER));
      }
      
      public function localAllowsRankedTeams() : Boolean
      {
         return Boolean(RTFacade.instance.rtProvider.clientConfig.teamServiceEnabled) && RTFacade.instance.rtProvider.session.summonerLevel.summonerLevel >= Team.MIN_SUMMONER_LEVEL_FOR_RANKED_TEAMS;
      }
      
      public function joinTeam(param1:TeamId) : void
      {
         this.serviceStateProxy.onServiceCall();
         RTFacade.instance.rtProvider.clearInviteNotificationsForTeam(param1);
         this.teamService.joinTeam(param1,this.onJoinTeamSuccess,this.onComplete,this.onInviteAcceptedError);
      }
      
      private function onError(param1:Object) : void
      {
         facade.sendNotification(RTShowServiceError.SHOW_ERROR,param1);
      }
      
      private function onDeclineInviteSuccess(param1:ResultEvent) : void
      {
         var _loc2_:Team = param1.result as Team;
         if(_loc2_)
         {
            sendNotification(RTNotifyTeamStatusUpdate.NOTIFY_TEAM_STATUS_UPDATE,RTNotifyTeamStatusUpdate.BuildCommandArgs(_loc2_,RTNotifyTeamStatusUpdate.DECLINED_INVITE));
         }
         this.retrieveLocalPlayer();
         sendNotification(RTRefreshProfileTeamCommand.REFRESH);
      }
      
      private function get serviceStateProxy() : ServiceStateProxy
      {
         return RTFacade.instance.retrieveProxy(ServiceStateProxy.NAME) as ServiceStateProxy;
      }
      
      public function localPlayer() : Player
      {
         return this._localPlayer;
      }
      
      private function onLeaveTeamSuccess(param1:ResultEvent) : void
      {
         var _loc2_:Team = param1.result as Team;
         this.updateChatPresenceData();
         sendNotification(RTNotifyTeamStatusUpdate.NOTIFY_TEAM_STATUS_UPDATE,RTNotifyTeamStatusUpdate.BuildCommandArgs(_loc2_,RTNotifyTeamStatusUpdate.LEFT_TEAM));
         sendNotification(RTRefreshProfileTeamCommand.REFRESH);
      }
      
      private function setLocalPlayer(param1:Player) : void
      {
         this._localPlayer = param1;
         RTFacade.instance.rtProvider.shellDispatcher.dispatchEvent(new RankedTeamEvent(RankedTeamEvent.UPDATE_PLAYER,this._localPlayer));
      }
      
      public function changeOwner(param1:Number, param2:TeamId) : void
      {
         this.serviceStateProxy.onServiceCall();
         this.teamService.changeOwner(param1,param2,this.onChangeOwnerSuccess,this.onComplete,this.onError);
      }
      
      public function leaveTeam(param1:TeamId) : void
      {
         this.serviceStateProxy.onServiceCall();
         RTFacade.instance.rtProvider.clearInviteNotificationsForTeam(param1);
         this.teamService.leaveTeam(param1,this.onLeaveTeamSuccess,this.onComplete,this.onError);
      }
      
      private function updateChatPresenceData() : void
      {
         ServiceProxy.instance.leagueService.getMyLeaguePositions(this.onGetLeaguePositions);
      }
      
      private function onChangeOwnerSuccess(param1:ResultEvent) : void
      {
         var _loc2_:Team = param1.result as Team;
         sendNotification(RTNotifyTeamStatusUpdate.NOTIFY_TEAM_STATUS_UPDATE,RTNotifyTeamStatusUpdate.BuildCommandArgs(_loc2_,RTNotifyTeamStatusUpdate.NEW_OWNER));
         sendNotification(RTRefreshProfileTeamCommand.REFRESH);
      }
      
      private function onComplete(param1:Object) : void
      {
         this.serviceStateProxy.onServiceCallComplete();
      }
      
      private function onInviteAcceptedError(param1:Object) : void
      {
         facade.sendNotification(RTShowServiceError.SHOW_ERROR,param1);
         facade.sendNotification(RTRefreshProfileTeamCommand.REFRESH);
      }
      
      private function onInvitePlayerSuccess(param1:Object) : void
      {
         sendNotification(RTSendInviteCommand.INVITE,param1);
         sendNotification(RTRefreshProfileTeamCommand.REFRESH);
      }
      
      public function cancelInvite(param1:Number, param2:TeamId) : void
      {
         this.serviceStateProxy.onServiceCall();
         this.teamService.kickPlayer(param1,param2,this.onCancelInviteSuccess,this.onComplete,this.onError);
      }
      
      private function onJoinTeamSuccess(param1:ResultEvent) : void
      {
         var _loc2_:Team = param1.result as Team;
         this.retrieveLocalPlayer();
         this.updateChatPresenceData();
         RTFacade.instance.rtProvider.soundManager.play(AudioKeys.RT_TEAM_ACCEPT_1);
         sendNotification(RTRefreshProfileTeamCommand.REFRESH);
         sendNotification(RTNotifyTeamStatusUpdate.NOTIFY_TEAM_STATUS_UPDATE,RTNotifyTeamStatusUpdate.BuildCommandArgs(_loc2_,RTNotifyTeamStatusUpdate.JOINED_TEAM));
      }
      
      public function showPlayer(param1:Number) : void
      {
         this.serviceStateProxy.onServiceCall();
         this.teamService.findPlayer(param1,this.onFindPlayerSuccess,this.onComplete,this.onFindPlayerError);
      }
   }
}

