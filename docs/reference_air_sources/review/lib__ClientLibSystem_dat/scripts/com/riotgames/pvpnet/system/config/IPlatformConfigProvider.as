package com.riotgames.pvpnet.system.config
{
   import com.riotgames.platform.gameclient.domain.systemstates.ClientSystemStatesNotification;
   import com.riotgames.platform.provider.IProvider;
   
   public interface IPlatformConfigProvider extends IProvider
   {
      
      function initializePlatformConfigMonitoring() : void;
      
      function updatePlatformConfig(param1:ClientSystemStatesNotification) : void;
      
      function getPlatformConfig() : PlatformConfig;
   }
}

