package com.riotgames.platform.gameclient.domain.accountState
{
   import com.riotgames.platform.gameclient.notification.ClientNotificationType;
   import com.riotgames.platform.gameclient.notification.IClientNotification;
   
   [RemoteClass(alias="com.riotgames.platform.account.impl.AccountStateChangeEventImpl")]
   public class AccountStateChangeNotification implements IClientNotification
   {
      
      public var eventDate:Date;
      
      public var accountId:Number;
      
      public var oldState:String;
      
      public var context:String;
      
      public var newState:String;
      
      public function AccountStateChangeNotification()
      {
         super();
      }
      
      public function get notificationType() : String
      {
         return ClientNotificationType.ACCOUNT_STATE_CHANGE;
      }
      
      public function toString() : String
      {
         return "accountId: " + this.accountId + " newState: " + this.newState + " oldState: " + this.oldState + " eventDate: " + this.eventDate + "context: " + this.context;
      }
   }
}

