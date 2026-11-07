package com.riotgames.platform.gameclient.module.rt.controller
{
   import com.riotgames.platform.common.domain.XMPPMessageSubjectTypes;
   import com.riotgames.platform.common.services.ChatService;
   import com.riotgames.platform.common.xmpp.data.rankedTeams.RankedTeamXMLStanza;
   import com.riotgames.platform.gameclient.module.rt.RTFacade;
   import com.riotgames.platform.gameclient.module.rt.RTSimpleCommand;
   import org.igniterealtime.xiff.core.EscapedJID;
   import org.igniterealtime.xiff.core.UnescapedJID;
   import org.puremvc.as3.multicore.interfaces.INotification;
   
   public class RTSendInviteCommand extends RTSimpleCommand
   {
      
      public static const INVITE:String = "INVITE";
      
      public function RTSendInviteCommand()
      {
         super();
      }
      
      private function get chatService() : ChatService
      {
         return RTFacade.instance.rtProvider.serviceProxy.chatService;
      }
      
      override public function execute(param1:INotification) : void
      {
         var _loc2_:Number = Number(param1.getBody().playerId);
         var _loc3_:String = param1.getBody().teamId;
         var _loc4_:String = param1.getBody().teamName;
         var _loc5_:RankedTeamXMLStanza = new RankedTeamXMLStanza();
         _loc5_.setMsgType(RankedTeamXMLStanza.RANKED_TEAM_INVITE);
         _loc5_.setTeamId(_loc3_);
         _loc5_.setTeamName(_loc4_);
         var _loc6_:UnescapedJID = this.getJIDFromPlayerId(_loc2_);
         this.chatService.sendMessage(_loc6_,XMPPMessageSubjectTypes.RANKED_TEAM_UPDATE,_loc5_.getNode());
      }
      
      private function getJIDFromPlayerId(param1:Number) : UnescapedJID
      {
         var _loc2_:String = this.chatService.getConnection().resource;
         var _loc3_:EscapedJID = new EscapedJID("sum" + param1.toString() + "@pvp.net");
         return _loc3_.unescaped;
      }
   }
}

