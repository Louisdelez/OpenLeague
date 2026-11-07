package com.riotgames.platform.common.provider
{
   import com.riotgames.platform.provider.proxy.ProviderProxyBase;
   
   [Deprecated]
   public class DeprecatedNavigationProviderProxy extends ProviderProxyBase implements IDeprecatedNavigationProvider
   {
      
      private static var _instance:DeprecatedNavigationProviderProxy;
      
      public function DeprecatedNavigationProviderProxy()
      {
         super(IDeprecatedNavigationProvider);
      }
      
      public static function get instance() : DeprecatedNavigationProviderProxy
      {
         if(_instance == null)
         {
            _instance = new DeprecatedNavigationProviderProxy();
         }
         return _instance;
      }
      
      public function openWatchTab() : void
      {
         _invoke("openWatchTab");
      }
   }
}

