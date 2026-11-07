package com.riotgames.landing
{
   import blix.context.IContext;
   import com.riotgames.platform.common.view.IMainScreen;
   import com.riotgames.platform.provider.IProvider;
   
   public interface ILandingPageProvider extends IProvider
   {
      
      function createLandingPage(param1:IContext) : IMainScreen;
   }
}

