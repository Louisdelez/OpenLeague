package com.riotgames.platform.gameclient.domain
{
   import com.riotgames.platform.gameclient.notification.ClientNotificationType;
   import com.riotgames.platform.gameclient.notification.IClientNotification;
   
   [RemoteClass(alias="com.riotgames.platform.messaging.ForcedClientShutdown")]
   public class ForcedClientShutdown implements IClientNotification
   {
      
      public static const USER_SUSPENDED:String = "USER_SUSPENDED";
      
      public static const USER_BANNED:String = "USER_BANNED";
      
      public static const USER_BANNED_FOR_LEAVING:String = "USER_BANNED_FOR_LEAVING";
      
      public var reason:String;
      
      public var additionalInfo:String;
      
      public function ForcedClientShutdown()
      {
         super();
      }
      
      public function isBannedForLeaving() : Boolean
      {
         return this.reason == USER_BANNED_FOR_LEAVING;
      }
      
      public function isBooted() : Boolean
      {
         return this.reason == USER_SUSPENDED;
      }
      
      public function get notificationType() : String
      {
         return ClientNotificationType.FORCED_SHUTDOWN;
      }
      
      public function isBanned() : Boolean
      {
         return this.reason == USER_BANNED;
      }
   }
}

