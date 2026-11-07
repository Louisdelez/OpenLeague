package com.riotgames.platform.gameclient.domain.store
{
   import com.riotgames.platform.gameclient.notification.ClientNotificationType;
   import com.riotgames.platform.gameclient.notification.IClientNotification;
   
   [RemoteClass(alias="com.riotgames.platform.messaging.RentalUpdateNotification")]
   public class RentalUpdateNotification implements IClientNotification
   {
      
      public var inventoryType:String;
      
      public var data:Object;
      
      public function RentalUpdateNotification()
      {
         super();
      }
      
      public function get notificationType() : String
      {
         return ClientNotificationType.RENTAL_UPDATE;
      }
   }
}

