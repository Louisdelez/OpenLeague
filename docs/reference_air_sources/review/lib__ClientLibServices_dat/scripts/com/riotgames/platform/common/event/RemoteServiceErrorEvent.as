package com.riotgames.platform.common.event
{
   import flash.events.Event;
   import mx.rpc.events.FaultEvent;
   
   public class RemoteServiceErrorEvent extends Event
   {
      
      public static const UNHANDLED_REMOTE_SERVICE_ERROR:String = "unhandledRemoteServiceError";
      
      public static const CLIENT_ERROR:String = "clientError";
      
      public static const SESSION_TIMEOUT:String = "sessionTimeout";
      
      public static const SESSION_EXPIRATION_WARNING:String = "sessionTimeoutWarning";
      
      public static const AUTHENTICATION_CREDENTIALS_ERROR:String = "authenticationCredentialsError";
      
      public static const UNKNOWN_ERROR:String = "unknownError";
      
      public var faultEvent:FaultEvent;
      
      public var description:String;
      
      public function RemoteServiceErrorEvent(param1:String, param2:FaultEvent, param3:String)
      {
         super(param1);
         this.faultEvent = param2;
         this.description = param3;
      }
   }
}

