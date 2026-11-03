package com.riotgames.platform.common.provider
{
   import blix.signals.ISignal;
   import com.riotgames.platform.gameclient.domain.loyalty.LoyaltyRewards;
   import com.riotgames.platform.gameclient.domain.loyalty.LoyaltyStateChangeNotification;
   import com.riotgames.platform.provider.proxy.ProviderProxyBase;
   
   public class LoyaltyProviderProxy extends ProviderProxyBase implements ILoyaltyProvider
   {
      
      private static var _instance:ILoyaltyProvider;
      
      public function LoyaltyProviderProxy()
      {
         super(ILoyaltyProvider);
      }
      
      public static function get instance() : ILoyaltyProvider
      {
         if(_instance == null)
         {
            _instance = new LoyaltyProviderProxy();
         }
         return _instance;
      }
      
      public function getRewardsChanged() : ISignal
      {
         return _getSignal("getRewardsChanged");
      }
      
      public function processLoyaltyStateUpdate(param1:LoyaltyStateChangeNotification) : void
      {
         _invoke("processLoyaltyStateUpdate",[param1]);
      }
      
      public function getRewards() : LoyaltyRewards
      {
         return _invoke("getRewards");
      }
      
      public function getRewardsDescription() : String
      {
         return _invoke("getRewardsDescription");
      }
   }
}

