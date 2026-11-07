package com.riotgames.pvpnet.clientfeaturedcontent
{
   import com.riotgames.platform.provider.ProviderLookup;
   
   public class IClientFeaturedContentProviderProxy
   {
      
      public function IClientFeaturedContentProviderProxy()
      {
         super();
      }
      
      public static function get instance() : IClientFeaturedContentProvider
      {
         return ProviderLookup.getProviderProxy(IClientFeaturedContentProvider);
      }
   }
}

