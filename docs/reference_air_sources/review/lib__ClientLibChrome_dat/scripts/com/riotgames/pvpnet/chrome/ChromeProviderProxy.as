package com.riotgames.pvpnet.chrome
{
   import com.riotgames.platform.provider.ProviderLookup;
   
   public class ChromeProviderProxy
   {
      
      public function ChromeProviderProxy()
      {
         super();
      }
      
      public static function get instance() : IChromeProvider
      {
         return ProviderLookup.getProviderProxy(IChromeProvider);
      }
   }
}

