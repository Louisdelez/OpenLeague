package com.riotgames.pvpnet.itembrowser
{
   import blix.context.IContext;
   import com.riotgames.platform.common.profile.IOldProfileScreenProvider;
   import com.riotgames.platform.common.view.IMainScreen;
   
   public interface IItemBrowserProvider extends IOldProfileScreenProvider
   {
      
      function getItemBrowserScreen(param1:IContext) : IMainScreen;
   }
}

