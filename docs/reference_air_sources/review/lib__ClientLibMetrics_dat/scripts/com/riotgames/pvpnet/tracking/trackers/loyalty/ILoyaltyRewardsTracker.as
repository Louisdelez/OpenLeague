package com.riotgames.pvpnet.tracking.trackers.loyalty
{
   public interface ILoyaltyRewardsTracker
   {
      
      function setPremiumType(param1:uint) : void;
      
      function setIpBoost(param1:Number) : void;
      
      function setXpBoost(param1:Number) : void;
      
      function addChampion(param1:uint) : void;
      
      function addSkin(param1:uint) : void;
      
      function completeAndSend() : void;
   }
}

