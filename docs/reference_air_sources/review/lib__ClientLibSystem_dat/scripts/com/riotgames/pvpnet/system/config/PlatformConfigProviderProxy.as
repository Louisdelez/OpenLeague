package com.riotgames.pvpnet.system.config
{
   import com.riotgames.platform.gameclient.domain.systemstates.ClientSystemStatesNotification;
   import com.riotgames.platform.provider.proxy.ProviderProxyBase;
   
   public class PlatformConfigProviderProxy extends ProviderProxyBase implements IPlatformConfigProvider
   {
      
      private static var _instance:PlatformConfigProviderProxy;
      
      public function PlatformConfigProviderProxy()
      {
         super(IPlatformConfigProvider);
      }
      
      public static function get instance() : PlatformConfigProviderProxy
      {
         if(_instance == null)
         {
            _instance = new PlatformConfigProviderProxy();
         }
         return _instance;
      }
      
      public function initializePlatformConfigMonitoring() : void
      {
         _invoke("initializePlatformConfigMonitoring");
      }
      
      public function updatePlatformConfig(param1:ClientSystemStatesNotification) : void
      {
         _invoke("updatePlatformConfig",[param1]);
      }
      
      public function getPlatformConfig() : PlatformConfig
      {
         var _loc1_:PlatformConfig = _invoke("getPlatformConfig") as PlatformConfig;
         if(_loc1_ != null)
         {
            return _loc1_;
         }
         return new PlatformConfig();
      }
   }
}

