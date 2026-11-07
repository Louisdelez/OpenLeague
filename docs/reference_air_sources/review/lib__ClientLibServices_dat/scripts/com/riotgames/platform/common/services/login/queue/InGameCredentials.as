package com.riotgames.platform.common.services.login.queue
{
   public class InGameCredentials
   {
      
      public var handshakeToken:String;
      
      public var encryptionKey:String;
      
      public var serverIp:String;
      
      public var serverPort:int;
      
      public var inGame:Boolean = false;
      
      public var playerId:Number;
      
      public function InGameCredentials()
      {
         super();
      }
   }
}

