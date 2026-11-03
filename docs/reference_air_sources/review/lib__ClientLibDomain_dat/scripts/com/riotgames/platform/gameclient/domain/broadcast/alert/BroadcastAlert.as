package com.riotgames.platform.gameclient.domain.broadcast.alert
{
   import com.riotgames.platform.gameclient.notification.ClientNotificationType;
   import com.riotgames.platform.gameclient.notification.IClientNotification;
   
   [RemoteClass(alias="com.riotgames.platform.broadcast.alert.BroadcastAlert")]
   public class BroadcastAlert implements IClientNotification
   {
      
      public var alertMessage:String = null;
      
      public function BroadcastAlert()
      {
         super();
      }
      
      public function get notificationType() : String
      {
         return ClientNotificationType.ALERT;
      }
   }
}

