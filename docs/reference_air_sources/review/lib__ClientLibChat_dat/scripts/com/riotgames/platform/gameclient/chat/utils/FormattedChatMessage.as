package com.riotgames.platform.gameclient.chat.utils
{
   public class FormattedChatMessage
   {
      
      public var messageType:String = "none";
      
      public var htmlMessage:String = "";
      
      public function FormattedChatMessage(param1:String, param2:String)
      {
         super();
         this.htmlMessage = param1;
         this.messageType = param2;
      }
   }
}

