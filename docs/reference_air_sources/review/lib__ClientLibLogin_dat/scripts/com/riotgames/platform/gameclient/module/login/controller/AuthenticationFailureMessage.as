package com.riotgames.platform.gameclient.module.login.controller
{
   public class AuthenticationFailureMessage
   {
      
      public var isBannedError:Boolean = false;
      
      public var isRetryWait:Boolean = false;
      
      public var isAccountTransferred:Boolean = false;
      
      public var reason:String;
      
      public var localeCode:String;
      
      public var banReason:String;
      
      public var destination:String;
      
      public var retryWait:int;
      
      public var expire:Number;
      
      public function AuthenticationFailureMessage()
      {
         super();
      }
   }
}

