package com.riotgames.pvpnet.runes
{
   import blix.context.IContext;
   import com.riotgames.platform.common.profile.IOldProfileScreenProvider;
   import com.riotgames.platform.common.view.IMainScreen;
   
   public interface IRunesProvider extends IOldProfileScreenProvider
   {
      
      function getRunesScreen(param1:IContext) : IMainScreen;
   }
}

