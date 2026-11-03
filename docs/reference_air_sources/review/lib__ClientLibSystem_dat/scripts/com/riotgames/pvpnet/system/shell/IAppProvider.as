package com.riotgames.pvpnet.system.shell
{
   import com.riotgames.platform.common.IAppController;
   import com.riotgames.platform.provider.IProvider;
   
   public interface IAppProvider extends IProvider
   {
      
      function get appController() : IAppController;
   }
}

