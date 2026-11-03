package com.riotgames.platform.gameclient.domain.store
{
   import com.riotgames.platform.gameclient.notification.ClientNotificationType;
   import com.riotgames.platform.gameclient.notification.IClientNotification;
   
   [RemoteClass(alias="com.riotgames.platform.messaging.StoreURLNotification")]
   public class StoreURLNotification implements IClientNotification
   {
      
      public var token:String;
      
      public var storeBaseUrl:String;
      
      public function StoreURLNotification()
      {
         super();
      }
      
      public function get notificationType() : String
      {
         return ClientNotificationType.STORE_URL;
      }
      
      public function get storeURL() : String
      {
         return this.storeBaseUrl + "?sessionId=" + this.token;
      }
   }
}

