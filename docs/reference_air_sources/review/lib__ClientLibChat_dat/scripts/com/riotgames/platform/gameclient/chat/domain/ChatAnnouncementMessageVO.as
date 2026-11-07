package com.riotgames.platform.gameclient.chat.domain
{
   public class ChatAnnouncementMessageVO extends ChatMessageVO
   {
      
      public function ChatAnnouncementMessageVO()
      {
         super();
         rosterItem = null;
         this.type = ChatMessageType.SYSTEM;
      }
      
      override public function getContactDisplayName() : String
      {
         return "";
      }
      
      override public function set body(param1:String) : void
      {
         _body = "** " + param1 + " **";
         timeStamp = new Date();
      }
   }
}

