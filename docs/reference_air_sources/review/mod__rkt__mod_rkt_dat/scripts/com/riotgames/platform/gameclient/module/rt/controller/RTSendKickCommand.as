package com.riotgames.platform.gameclient.module.rt.controller
{
   import com.riotgames.platform.common.domain.XMPPMessageSubjectTypes;
   import com.riotgames.platform.common.services.ChatService;
   import com.riotgames.platform.common.xmpp.data.rankedTeams.RankedTeamXMLStanza;
   import com.riotgames.platform.gameclient.domain.rankedTeams.Team;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamMemberInfo;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamMemberStatus;
   import com.riotgames.platform.gameclient.module.rt.RTFacade;
   import com.riotgames.platform.gameclient.module.rt.RTSimpleCommand;
   import com.riotgames.platform.gameclient.module.rt.model.ProfilePlayerProxy;
   import com.riotgames.platform.gameclient.module.rt.model.ProfileTeamProxy;
   import com.riotgames.platform.gameclient.module.rt.model.TeamProxy;
   import org.igniterealtime.xiff.core.EscapedJID;
   import org.igniterealtime.xiff.core.UnescapedJID;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class RTSendKickCommand extends RTSimpleCommand
   {
      
      public static const KICK:String = "KICK";
      
      public function RTSendKickCommand()
      {
         super();
      }
      
      public static function BuildCommandArgs(param1:Team, param2:Number, param3:String) : Object
      {
         return {
            "team":param1,
            "playerId":param2,
            "playerName":param3
         };
      }
      
      private function get teamProxy() : TeamProxy
      {
         return RTFacade.instance.retrieveProxy(TeamProxy.NAME) as TeamProxy;
      }
      
      private function getJIDFromPlayerId(param1:Number) : UnescapedJID
      {
         var _loc2_:String = this.chatService.getConnection().resource;
         var _loc3_:EscapedJID = new EscapedJID("sum" + param1.toString() + "@pvp.net");
         return _loc3_.unescaped;
      }
      
      public function get profileTeamProxy() : ProfileTeamProxy
      {
         return facade.retrieveProxy(ProfileTeamProxy.NAME) as ProfileTeamProxy;
      }
      
      private function get profilePlayerProxy() : ProfilePlayerProxy
      {
         return RTFacade.instance.retrieveProxy(ProfilePlayerProxy.NAME) as ProfilePlayerProxy;
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc7_:TeamMemberInfo = null;
         var _loc2_:Number = Number(param1.getBody().playerId);
         var _loc3_:Team = param1.getBody().team as Team;
         var _loc4_:String = param1.getBody().playerName as String;
         if(_loc3_ == null)
         {
            return;
         }
         var _loc5_:RankedTeamXMLStanza = new RankedTeamXMLStanza();
         _loc5_.setMsgType(RankedTeamXMLStanza.RANKED_TEAM_KICKED);
         _loc5_.setTeamId(_loc3_.teamId.toString());
         _loc5_.setTeamName(_loc3_.name);
         var _loc6_:UnescapedJID = this.getJIDFromPlayerId(_loc2_);
         this.chatService.sendMessage(_loc6_,XMPPMessageSubjectTypes.RANKED_TEAM_UPDATE,_loc5_.getNode());
         for each(_loc7_ in _loc3_.roster.memberList)
         {
            if(_loc7_.playerId != this.profilePlayerProxy.player.playerId && _loc7_.status == TeamMemberStatus.MEMBER && _loc7_.playerId != _loc2_)
            {
               _loc5_ = new RankedTeamXMLStanza();
               _loc5_.setMsgType(RankedTeamXMLStanza.RANKED_TEAM_NOTIFY_LEFT);
               _loc5_.setTeamId(_loc3_.teamId.toString());
               _loc5_.setTeamName(_loc3_.name);
               _loc5_.setSummonerName(_loc4_);
               _loc6_ = ProfilePlayerProxy.unescapedJIDFromSummonerId(_loc7_.playerId);
               this.chatService.sendMessage(_loc6_,XMPPMessageSubjectTypes.RANKED_TEAM_UPDATE,_loc5_.getNode());
            }
         }
         this.teamProxy.onTeamRosterChanged(_loc3_.teamId);
      }
      
      private function get chatService() : ChatService
      {
         return RTFacade.instance.rtProvider.serviceProxy.chatService;
      }
   }
}

