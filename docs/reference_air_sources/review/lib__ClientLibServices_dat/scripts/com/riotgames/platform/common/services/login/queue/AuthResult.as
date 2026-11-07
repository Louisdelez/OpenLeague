package com.riotgames.platform.common.services.login.queue
{
   public class AuthResult
   {
      
      public static const FAILED_STATUS:String = "FAILED";
      
      public static const BUSY_STATUS:String = "BUSY";
      
      public static const LOGIN_STATUS:String = "LOGIN";
      
      public static const QUEUE_STATUS:String = "QUEUE";
      
      public static const ARL_STATUS:String = "ARL_QUEUE";
      
      public var queueState:LoginQueueState;
      
      public var vcap:int;
      
      public var reason:String;
      
      public var inGameCredentials:InGameCredentials;
      
      public var gasToken:String;
      
      public var summoner:String;
      
      public var lqt:String;
      
      public var authToken:String;
      
      public var status:String = "FAILED";
      
      public var username:String;
      
      public function AuthResult()
      {
         super();
      }
   }
}

