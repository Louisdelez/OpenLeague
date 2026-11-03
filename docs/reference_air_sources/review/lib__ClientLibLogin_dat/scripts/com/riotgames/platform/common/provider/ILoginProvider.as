package com.riotgames.platform.common.provider
{
   import blix.context.IContext;
   import com.riotgames.platform.common.view.IMainScreen;
   import com.riotgames.platform.provider.IProvider;
   
   public interface ILoginProvider extends IProvider
   {
      
      function createLoginModule(param1:IContext) : IMainScreen;
   }
}

