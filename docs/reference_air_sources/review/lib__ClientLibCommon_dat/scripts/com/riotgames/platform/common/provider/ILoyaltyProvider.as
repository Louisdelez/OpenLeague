package com.riotgames.platform.common.provider
{
   import blix.signals.ISignal;
   import com.riotgames.platform.gameclient.domain.loyalty.LoyaltyRewards;
   import com.riotgames.platform.gameclient.domain.loyalty.LoyaltyStateChangeNotification;
   import com.riotgames.platform.provider.IProvider;
   
   public interface ILoyaltyProvider extends IProvider
   {
      
      function getRewards() : LoyaltyRewards;
      
      function processLoyaltyStateUpdate(param1:LoyaltyStateChangeNotification) : void;
      
      function getRewardsChanged() : ISignal;
      
      function getRewardsDescription() : String;
   }
}

