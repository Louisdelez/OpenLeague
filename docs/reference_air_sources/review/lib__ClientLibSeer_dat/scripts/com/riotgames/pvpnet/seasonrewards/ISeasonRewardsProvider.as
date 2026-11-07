package com.riotgames.pvpnet.seasonrewards
{
   import blix.assets.proxy.IDisplayChild;
   import com.riotgames.platform.provider.IProvider;
   
   public interface ISeasonRewardsProvider extends IProvider
   {
      
      function showInformationPopup() : void;
      
      function updateRewards() : void;
      
      function getTeamRewardsView() : IDisplayChild;
      
      function getTierRewardsView() : IDisplayChild;
   }
}

