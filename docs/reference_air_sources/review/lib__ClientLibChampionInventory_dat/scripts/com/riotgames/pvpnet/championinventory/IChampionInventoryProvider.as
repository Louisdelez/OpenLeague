package com.riotgames.pvpnet.championinventory
{
   import blix.context.IContext;
   import com.riotgames.platform.common.profile.IOldProfileScreenProvider;
   import com.riotgames.platform.common.view.IMainScreen;
   
   public interface IChampionInventoryProvider extends IOldProfileScreenProvider
   {
      
      function getChampionInventoryScreen(param1:IContext) : IMainScreen;
   }
}

