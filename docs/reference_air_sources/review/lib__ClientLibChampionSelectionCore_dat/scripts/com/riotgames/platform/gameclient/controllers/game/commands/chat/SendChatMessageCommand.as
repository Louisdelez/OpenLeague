package com.riotgames.platform.gameclient.controllers.game.commands.chat
{
   import com.riotgames.platform.common.commands.CommandBase;
   import com.riotgames.platform.common.services.ChatService;
   import flash.xml.XMLNode;
   import org.igniterealtime.xiff.core.UnescapedJID;
   
   public class SendChatMessageCommand extends CommandBase
   {
      
      private var jid:UnescapedJID;
      
      private var message:XMLNode;
      
      private var subject:String;
      
      private var chatService:ChatService;
      
      public function SendChatMessageCommand(param1:UnescapedJID, param2:String, param3:XMLNode, param4:ChatService)
      {
         super();
         this.jid = param1;
         this.chatService = param4;
         this.subject = param2;
         this.message = param3;
      }
      
      override public function execute() : void
      {
         super.execute();
         this.chatService.sendMessage(this.jid,this.subject,this.message);
      }
   }
}

