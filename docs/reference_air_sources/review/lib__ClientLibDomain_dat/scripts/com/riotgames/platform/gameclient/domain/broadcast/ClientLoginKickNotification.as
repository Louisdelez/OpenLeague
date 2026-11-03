package com.riotgames.platform.gameclient.domain.broadcast
{
   import com.riotgames.platform.gameclient.notification.ClientNotificationType;
   import com.riotgames.platform.gameclient.notification.IClientNotification;
   
   [RemoteClass(alias="com.riotgames.platform.messaging.ClientLoginKickNotification")]
   public class ClientLoginKickNotification implements IClientNotification
   {
      
      public var sessionToken:String;
      
      public function ClientLoginKickNotification()
      {
         super();
      }
      
      public function get notificationType() : String
      {
         return ClientNotificationType.LOGIN_KICK;
      }
   }
}

