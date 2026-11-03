package com.riotgames.platform.gameclient.module.rt
{
   import com.riotgames.platform.common.audio.AudioKeys;
   import com.riotgames.platform.common.domain.XMPPMessageSubjectTypes;
   import com.riotgames.platform.common.provider.SoundProviderProxy;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.common.xmpp.data.rankedTeams.RankedTeamXMLStanza;
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.gameclient.chat.NotificationsProviderProxy;
   import com.riotgames.platform.gameclient.chat.domain.DockedPrompt;
   import com.riotgames.platform.gameclient.domain.ButtonNameType;
   import com.riotgames.platform.gameclient.domain.broadcast.ClientLoginRankedTeamDeletedNotification;
   import com.riotgames.platform.gameclient.domain.rankedTeams.Player;
   import com.riotgames.platform.gameclient.domain.rankedTeams.Team;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamId;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamInfo;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamMemberStatus;
   import com.riotgames.platform.gameclient.module.rt.model.TeamProxy;
   import com.riotgames.platform.gameclient.notification.ClientNotificationType;
   import com.riotgames.platform.gameclient.services.TeamService;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.rankedteams.ILegacyTeamProfileNavigationProvider;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import com.riotgames.pvpnet.system.notification.ClientNotificationEvent;
   import com.riotgames.pvpnet.system.notification.ClientNotificationProviderProxy;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   import flash.utils.getTimer;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.resources.ResourceManager;
   import mx.rpc.events.ResultEvent;
   import org.igniterealtime.xiff.core.UnescapedJID;
   import org.igniterealtime.xiff.data.Message;
   
   public class PlayerNotificationController
   {
      
      private var _invitationPromptMap:Dictionary = new Dictionary();
      
      private var _teamProfileNavigator:ILegacyTeamProfileNavigationProvider;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var _lastOtherJoinedSoundTime:uint = 0;
      
      private var _lastInviteSoundTime:uint = 0;
      
      public function PlayerNotificationController()
      {
         super();
         ClientNotificationProviderProxy.instance.addClientNotificationMessageListener(ClientNotificationType.LOGIN_DELETED,this.onTeamDeletedMessageReceived);
         ProviderLookup.getProvider(ILegacyTeamProfileNavigationProvider,this.onGotTeamProfileNavigator);
      }
      
      private function showPrompt(param1:String, param2:String, param3:String, param4:String, param5:String, param6:String, param7:Function, param8:Object, param9:Boolean, param10:int = -1) : DockedPrompt
      {
         var _loc11_:DockedPrompt = DockedPrompt.create(param1,param2,param3,param4,param5,param6,param7,param8,param9,param10);
         NotificationsProviderProxy.instance.showDockedPrompt(_loc11_);
         return _loc11_;
      }
      
      private function onKickClick(param1:String, param2:String) : void
      {
         this.teamService.leaveTeam(TeamId.MakeTeamId(param2),null,null,this.onAcknowledgeKickedError);
      }
      
      private function showTeamInactivityWarnings(param1:Player) : void
      {
         var _loc6_:TeamInfo = null;
         var _loc2_:Array = UserPreferencesManager.userPrefs.teamInactivityWarnings;
         var _loc3_:Array = UserPreferencesManager.userPrefs.teamInactivityPendingWarnings;
         if(!_loc2_)
         {
            _loc2_ = [];
         }
         if(!_loc3_)
         {
            _loc3_ = [];
         }
         var _loc4_:Array = [];
         var _loc5_:Array = [];
         for each(_loc6_ in param1.playerTeams)
         {
            if(_loc6_.memberStatusString == TeamMemberStatus.MEMBER)
            {
               if(_loc6_.getInactivityStatus() == Team.STATUS_INACTIVE)
               {
                  if(_loc2_.indexOf(_loc6_.teamId.fullId) == -1)
                  {
                     this.showInactiveWarning(_loc6_.name,_loc6_.teamId);
                  }
                  _loc4_.push(_loc6_.teamId.fullId);
                  _loc5_.push(_loc6_.teamId.fullId);
               }
               else if(_loc6_.getInactivityStatus() == Team.STATUS_PENDING_INACTIVE)
               {
                  if(_loc3_.indexOf(_loc6_.teamId.fullId) == -1)
                  {
                     this.showPendingInactiveWarning(_loc6_.name,_loc6_.teamId);
                  }
                  _loc5_.push(_loc6_.teamId.fullId);
               }
            }
         }
         UserPreferencesManager.userPrefs.teamInactivityWarnings = _loc4_;
         UserPreferencesManager.userPrefs.teamInactivityPendingWarnings = _loc5_;
      }
      
      private function showOtherJoinedTeam(param1:String, param2:String) : void
      {
         var _loc3_:String = ResourceManager.getInstance().getString("resources","ranked_team_join_message",[param1,param2]);
         this.showPrompt(_loc3_,ResourceManager.getInstance().getString("resources","ranked_team_join"),param2,ResourceManager.getInstance().getString("resources","common_button_close"),null,DockedPrompt.TYPE_OTHER,null,null,true);
         var _loc4_:uint = uint(getTimer());
         if(_loc4_ - this._lastOtherJoinedSoundTime > 10000)
         {
            SoundProviderProxy.instance.play(AudioKeys.RT_TEAM_ACCEPT_3);
            this._lastOtherJoinedSoundTime = _loc4_;
         }
      }
      
      private function showInvitedNotification(param1:String, param2:TeamId) : void
      {
         var _loc3_:DockedPrompt = this.showPrompt(ResourceManager.getInstance().getString("resources","rankedTeams_docked_invite",[param1]),ResourceManager.getInstance().getString("resources","ranked_team_invite"),param1,ResourceManager.getInstance().getString("resources","common_button_view"),ResourceManager.getInstance().getString("resources","common_button_decline"),DockedPrompt.TYPE_FRIEND_INVITE,this.onInviteClick,param2.toString(),true);
         this._invitationPromptMap[param2.fullId] = _loc3_;
         var _loc4_:uint = uint(getTimer());
         if(_loc4_ - this._lastInviteSoundTime > 2500)
         {
            SoundProviderProxy.instance.play(AudioKeys.RT_TEAM_INVITE_1);
            this._lastInviteSoundTime = _loc4_;
         }
      }
      
      private function showKickedNotification(param1:String, param2:TeamId) : void
      {
         this.showPrompt(ResourceManager.getInstance().getString("resources","rankedTeams_docked_kick",[param1]),ResourceManager.getInstance().getString("resources","ranked_team_kick"),param1,ResourceManager.getInstance().getString("resources","common_button_close"),null,DockedPrompt.TYPE_OTHER,this.onKickClick,param2.toString(),true);
      }
      
      private function get teamProxy() : TeamProxy
      {
         return RTFacade.instance.retrieveProxy(TeamProxy.NAME) as TeamProxy;
      }
      
      private function showInvites(param1:Player) : void
      {
         var _loc2_:TeamInfo = null;
         for each(_loc2_ in param1.playerTeams)
         {
            if(_loc2_.memberStatusString == TeamMemberStatus.INVITED)
            {
               this.showInvitedNotification(_loc2_.name,_loc2_.teamId);
            }
            else if(_loc2_.memberStatusString == TeamMemberStatus.KICKED)
            {
               this.showKickedNotification(_loc2_.name,_loc2_.teamId);
            }
            else if(_loc2_.memberStatusString == TeamMemberStatus.DELETED)
            {
               this.showDeletedNotification(_loc2_.name,_loc2_.teamId);
            }
         }
      }
      
      private function onInactiveWarningClick(param1:String, param2:String) : void
      {
         if(param1 == ButtonNameType.LEFT_BUTTON)
         {
            if(this._teamProfileNavigator)
            {
               this._teamProfileNavigator.goToTeam(TeamId.MakeTeamId(param2));
            }
         }
      }
      
      private function get teamService() : TeamService
      {
         return RTFacade.instance.rtProvider.serviceProxy.teamService;
      }
      
      public function refreshPlayer() : void
      {
         RTFacade.playerProxy.retrieveLocalPlayer();
      }
      
      public function handleP2PMessage(param1:Message) : void
      {
         var _loc4_:String = null;
         var _loc2_:RankedTeamXMLStanza = new RankedTeamXMLStanza(param1.body);
         var _loc3_:TeamId = TeamId.MakeTeamId(_loc2_.getTeamId());
         switch(_loc2_.getMsgType())
         {
            case RankedTeamXMLStanza.RANKED_TEAM_INVITE:
               this.showInvitedNotification(_loc2_.getTeamName(),_loc3_);
               break;
            case RankedTeamXMLStanza.RANKED_TEAM_KICKED:
               this.refreshPlayer();
               this.showKickedNotification(_loc2_.getTeamName(),_loc3_);
               break;
            case RankedTeamXMLStanza.RANKED_TEAM_NOTIFY_JOIN:
               this.refreshPlayer();
               this.showOtherJoinedTeam(_loc2_.getSummonerName(),_loc2_.getTeamName());
               break;
            case RankedTeamXMLStanza.RANKED_TEAM_NOTIFY_LEFT:
               this.refreshPlayer();
               _loc4_ = ResourceManager.getInstance().getString("resources","ranked_team_leave_message",[_loc2_.getSummonerName(),_loc2_.getTeamName()]);
               this.showPrompt(_loc4_,ResourceManager.getInstance().getString("resources","ranked_team_Leave"),_loc2_.getTeamName(),ResourceManager.getInstance().getString("resources","common_button_close"),null,DockedPrompt.TYPE_OTHER,null,null,true);
               break;
            case RankedTeamXMLStanza.RANKED_TEAM_NOTIFY_DECLINE_INVITE:
               _loc4_ = ResourceManager.getInstance().getString("resources","ranked_team_invite_declined_message",[_loc2_.getSummonerName(),_loc2_.getTeamName()]);
               this.showPrompt(_loc4_,ResourceManager.getInstance().getString("resources","ranked_team_update"),_loc2_.getTeamName(),ResourceManager.getInstance().getString("resources","common_button_close"),null,DockedPrompt.TYPE_OTHER,null,null,true);
               break;
            case RankedTeamXMLStanza.RANKED_TEAM_NOTIFY_NEW_OWNER:
               this.refreshPlayer();
               _loc4_ = ResourceManager.getInstance().getString("resources","ranked_team_notify_new_owner_message",[_loc2_.getTeamName()]);
               this.showPrompt(_loc4_,ResourceManager.getInstance().getString("resources","ranked_team_update"),_loc2_.getTeamName(),ResourceManager.getInstance().getString("resources","common_button_close"),null,DockedPrompt.TYPE_OTHER,null,null,true);
         }
         if(_loc3_ != null)
         {
            this.teamProxy.onTeamRosterChanged(_loc3_);
         }
      }
      
      private function onDeclineInviteSuccess(param1:ResultEvent) : void
      {
         var _loc3_:RankedTeamXMLStanza = null;
         var _loc4_:UnescapedJID = null;
         this.refreshPlayer();
         var _loc2_:Team = param1.result as Team;
         if(_loc2_)
         {
            this.teamProxy.onTeamRosterChanged(_loc2_.teamId);
            _loc3_ = new RankedTeamXMLStanza();
            _loc3_.setMsgType(RankedTeamXMLStanza.RANKED_TEAM_NOTIFY_DECLINE_INVITE);
            _loc3_.setTeamId(_loc2_.teamId.toString());
            _loc3_.setTeamName(_loc2_.name);
            _loc3_.setSummonerName(Session.instance.summoner.name);
            _loc4_ = ChatController.unescapedJIDFromSummonerId(_loc2_.roster.ownerId);
            ServiceProxy.instance.chatService.sendMessage(_loc4_,XMPPMessageSubjectTypes.RANKED_TEAM_UPDATE,_loc3_.getNode());
         }
      }
      
      private function onAcknowledgeKickedError(param1:Object) : void
      {
         this.logger.error("Error while trying to clear a KICKED notification: " + param1.errorCode);
      }
      
      private function onInviteClick(param1:String, param2:String) : void
      {
         delete this._invitationPromptMap[param2];
         if(param1 == ButtonNameType.LEFT_BUTTON)
         {
            if(this._teamProfileNavigator)
            {
               this._teamProfileNavigator.goToTeam(TeamId.MakeTeamId(param2));
            }
         }
         else if(param1 == ButtonNameType.RIGHT_BUTTON || param1 == ButtonNameType.DISMISS_BUTTON)
         {
            this.teamService.leaveTeam(TeamId.MakeTeamId(param2),this.onDeclineInviteSuccess,null,this.onError);
         }
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
      
      private function onTeamDeletedMessageReceived(param1:ClientNotificationEvent) : void
      {
         this.logger.warn("received a team deleted push message!");
         var _loc2_:ClientLoginRankedTeamDeletedNotification = param1.notification as ClientLoginRankedTeamDeletedNotification;
         this.showDeletedNotification(_loc2_.teamName,_loc2_.teamId);
      }
      
      public function clearInviteNotificationsForTeam(param1:TeamId) : void
      {
         var _loc2_:DockedPrompt = this._invitationPromptMap[param1.fullId];
         if(_loc2_)
         {
            NotificationsProviderProxy.instance.removeNotification(_loc2_,ButtonNameType.MINIMIZE_BUTTON);
            delete this._invitationPromptMap[param1.fullId];
         }
      }
      
      private function showDeletedNotification(param1:String, param2:TeamId) : void
      {
         if(Boolean(param1) && Boolean(param2))
         {
            this.showPrompt(ResourceManager.getInstance().getString("resources","rankedTeams_docked_deleted",[param1]),ResourceManager.getInstance().getString("resources","ranked_team_deleted"),param1,ResourceManager.getInstance().getString("resources","common_button_close"),null,DockedPrompt.TYPE_OTHER,this.onKickClick,param2.toString(),true);
         }
      }
      
      private function showInactiveWarning(param1:String, param2:TeamId) : void
      {
         this.showPrompt(ResourceManager.getInstance().getString("resources","rankedTeams_docked_inactive",[param1]),ResourceManager.getInstance().getString("resources","ranked_team_inactive"),param1,ResourceManager.getInstance().getString("resources","common_button_view"),ResourceManager.getInstance().getString("resources","common_button_close"),DockedPrompt.TYPE_OTHER,this.onInactiveWarningClick,param2.toString(),true);
      }
      
      private function showPendingInactiveWarning(param1:String, param2:TeamId) : void
      {
         this.showPrompt(ResourceManager.getInstance().getString("resources","rankedTeams_docked_pending_inactive",[param1]),ResourceManager.getInstance().getString("resources","ranked_team_pending_inactive"),param1,ResourceManager.getInstance().getString("resources","common_button_view"),ResourceManager.getInstance().getString("resources","common_button_close"),DockedPrompt.TYPE_OTHER,this.onInactiveWarningClick,param2.toString(),true);
      }
      
      private function onGotTeamProfileNavigator(param1:ILegacyTeamProfileNavigationProvider) : void
      {
         this._teamProfileNavigator = param1;
      }
      
      public function processNotifications(param1:Player) : void
      {
         this.showInvites(param1);
         this.showTeamInactivityWarnings(param1);
      }
   }
}

