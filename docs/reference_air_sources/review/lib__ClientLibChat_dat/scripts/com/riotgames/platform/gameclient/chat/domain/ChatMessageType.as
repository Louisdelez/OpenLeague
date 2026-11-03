package com.riotgames.platform.gameclient.chat.domain
{
   public class ChatMessageType
   {
      
      public static const PRIVATE:String = "private";
      
      public static const PUBLIC:String = "public";
      
      public static const ADMIN:String = "admin";
      
      public static const JOIN:String = "join";
      
      public static const LEAVE:String = "leave";
      
      public static const SYSTEM:String = "system";
      
      public static const DELEGATE:String = "delegation";
      
      public static const REVOKE:String = "revoke";
      
      public static const ERROR:String = "error";
      
      public static const USER_ALERT:String = "userAlert";
      
      public function ChatMessageType()
      {
         super();
      }
   }
}

