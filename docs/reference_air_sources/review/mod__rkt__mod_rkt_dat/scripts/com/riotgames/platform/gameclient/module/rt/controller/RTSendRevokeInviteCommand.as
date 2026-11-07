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
   
   public class RTSendRevokeInviteCommand extends RTSimpleCommand
   {
      
      public static const REVOKE:String = "REVOKE";
      
      public function RTSendRevokeInviteCommand()
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
         var _loc3_:Number = Number(param1.getBody().teamId);
         var _loc4_:RankedTeamXMLStanza = new RankedTeamXMLStanza();
         _loc4_.setMsgType(RankedTeamXMLStanza.RANKED_TEAM_REVOKE_INVITE);
         _loc4_.setTeamId(_loc3_.toString());
         var _loc5_:UnescapedJID = this.getJIDFromPlayerId(_loc2_);
         this.chatService.sendMessage(_loc5_,XMPPMessageSubjectTypes.RANKED_TEAM_UPDATE,_loc4_.getNode());
      }
      
      private function getJIDFromPlayerId(param1:Number) : UnescapedJID
      {
         var _loc2_:String = this.chatService.getConnection().resource;
         var _loc3_:EscapedJID = new EscapedJID("sum" + param1.toString() + "@pvp.net");
         return _loc3_.unescaped;
      }
   }
}

