package com.riotgames.platform.gameclient.domain.loyalty
{
   import com.riotgames.platform.gameclient.notification.ClientNotificationType;
   import com.riotgames.platform.gameclient.notification.IClientNotification;
   
   [RemoteClass(alias="com.riotgames.platform.loyalty.message.LoyaltyStateChangeNotification")]
   public class LoyaltyStateChangeNotification implements IClientNotification
   {
      
      public var premiumType:Number;
      
      public var rewards:LoyaltyRewards;
      
      public var accountId:Number;
      
      public function LoyaltyStateChangeNotification()
      {
         super();
      }
      
      public function get notificationType() : String
      {
         return ClientNotificationType.LOYALTY_STATE_CHANGE;
      }
      
      public function toString() : String
      {
         return "[accountId: " + this.accountId + "]" + " [premiumType: " + this.premiumType + "]" + " [Rewards: " + this.rewards.toString() + "]";
      }
   }
}

