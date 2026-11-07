package com.riotgames.platform.gameclient.module.rt.controller
{
   import com.riotgames.platform.common.domain.XMPPMessageSubjectTypes;
   import com.riotgames.platform.common.services.ChatService;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.common.xmpp.data.rankedTeams.RankedTeamXMLStanza;
   import com.riotgames.platform.gameclient.domain.rankedTeams.Team;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamMemberInfo;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamMemberStatus;
   import com.riotgames.platform.gameclient.module.rt.RTFacade;
   import com.riotgames.platform.gameclient.module.rt.RTSimpleCommand;
   import com.riotgames.platform.gameclient.module.rt.model.PlayerProxy;
   import com.riotgames.platform.gameclient.module.rt.model.ProfilePlayerProxy;
   import com.riotgames.platform.gameclient.module.rt.model.TeamProxy;
   import org.igniterealtime.xiff.core.UnescapedJID;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class RTNotifyTeamStatusUpdate extends RTSimpleCommand
   {
      
      public static const NOTIFY_TEAM_STATUS_UPDATE:String = "RTNotifyTeamStatusUpdate.NOTIFY_TEAM_STATUS_UPDATE";
      
      public static const LEFT_TEAM:String = "LeftTeam";
      
      public static const JOINED_TEAM:String = "JoinedTeam";
      
      public static const NEW_OWNER:String = "NewOwner";
      
      public static const DECLINED_INVITE:String = "DeclinedInvite";
      
      public function RTNotifyTeamStatusUpdate()
      {
         super();
      }
      
      private static function getMessageType(param1:String) : String
      {
         var _loc2_:String = RankedTeamXMLStanza.RANKED_TEAM_NOTIFY_JOIN;
         switch(param1)
         {
            case JOINED_TEAM:
               _loc2_ = RankedTeamXMLStanza.RANKED_TEAM_NOTIFY_JOIN;
               break;
            case LEFT_TEAM:
               _loc2_ = RankedTeamXMLStanza.RANKED_TEAM_NOTIFY_LEFT;
               break;
            case NEW_OWNER:
               _loc2_ = RankedTeamXMLStanza.RANKED_TEAM_NOTIFY_NEW_OWNER;
               break;
            case DECLINED_INVITE:
               _loc2_ = RankedTeamXMLStanza.RANKED_TEAM_NOTIFY_DECLINE_INVITE;
         }
         return _loc2_;
      }
      
      public static function BuildCommandArgs(param1:Team, param2:String) : Object
      {
         return {
            "team":param1,
            "notifyType":param2
         };
      }
      
      private function get teamProxy() : TeamProxy
      {
         return RTFacade.instance.retrieveProxy(TeamProxy.NAME) as TeamProxy;
      }
      
      private function get profilePlayerProxy() : ProfilePlayerProxy
      {
         return RTFacade.instance.retrieveProxy(ProfilePlayerProxy.NAME) as ProfilePlayerProxy;
      }
      
      private function get session() : Session
      {
         return RTFacade.instance.rtProvider.session;
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc5_:TeamMemberInfo = null;
         var _loc6_:Boolean = false;
         var _loc7_:RankedTeamXMLStanza = null;
         var _loc8_:UnescapedJID = null;
         var _loc2_:Team = param1.getBody().team;
         var _loc3_:String = param1.getBody().notifyType;
         var _loc4_:Boolean = _loc3_ == NEW_OWNER || _loc3_ == DECLINED_INVITE;
         if(_loc2_)
         {
            for each(_loc5_ in _loc2_.roster.memberList)
            {
               _loc6_ = _loc5_.playerId == _loc2_.roster.ownerId;
               if(_loc5_.playerId != this.profilePlayerProxy.player.playerId && _loc5_.status == TeamMemberStatus.MEMBER && (_loc6_ || !_loc4_))
               {
                  _loc7_ = new RankedTeamXMLStanza();
                  _loc7_.setMsgType(getMessageType(_loc3_));
                  _loc7_.setTeamId(_loc2_.teamId.toString());
                  _loc7_.setTeamName(_loc2_.name);
                  _loc7_.setSummonerName(this.session.summoner.name);
                  _loc8_ = ProfilePlayerProxy.unescapedJIDFromSummonerId(_loc5_.playerId);
                  this.chatService.sendMessage(_loc8_,XMPPMessageSubjectTypes.RANKED_TEAM_UPDATE,_loc7_.getNode());
               }
            }
            this.teamProxy.onTeamRosterChanged(_loc2_.teamId);
         }
         this.playerProxy.retrieveLocalPlayer();
      }
      
      private function get playerProxy() : PlayerProxy
      {
         return RTFacade.instance.retrieveProxy(PlayerProxy.NAME) as PlayerProxy;
      }
      
      private function get chatService() : ChatService
      {
         return RTFacade.instance.rtProvider.serviceProxy.chatService;
      }
   }
}

