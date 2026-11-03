package com.riotgames.platform.gameclient.domain.store
{
   import com.riotgames.platform.gameclient.notification.ClientNotificationType;
   import com.riotgames.platform.gameclient.notification.IClientNotification;
   
   [RemoteClass(alias="com.riotgames.platform.messaging.StoreFulfillmentNotification")]
   public class StoreFulfillmentNotification implements IClientNotification
   {
      
      public var inventoryType:String;
      
      public var ip:Number;
      
      public var data:Object;
      
      public var rp:Number;
      
      public function StoreFulfillmentNotification()
      {
         super();
      }
      
      public function get notificationType() : String
      {
         return ClientNotificationType.FULFILLMENT;
      }
   }
}

