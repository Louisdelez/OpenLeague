package com.riotgames.pvpnet.localconnectiontool
{
   import com.riotgames.platform.provider.ProviderLookup;
   
   public class LocalConnectionToolProviderProxy
   {
      
      public function LocalConnectionToolProviderProxy()
      {
         super();
      }
      
      public static function get instance() : ILocalConnectionToolProvider
      {
         return ProviderLookup.getProviderProxy(ILocalConnectionToolProvider);
      }
   }
}

