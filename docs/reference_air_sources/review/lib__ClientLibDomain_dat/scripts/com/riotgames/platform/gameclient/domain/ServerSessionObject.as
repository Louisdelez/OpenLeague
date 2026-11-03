package com.riotgames.platform.gameclient.domain
{
   [RemoteClass(alias="com.riotgames.platform.login.Session")]
   public class ServerSessionObject
   {
      
      public var token:String;
      
      public var accountSummary:AccountSummary;
      
      public var password:String;
      
      public function ServerSessionObject()
      {
         super();
      }
   }
}

