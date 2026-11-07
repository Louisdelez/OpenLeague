package com.riotgames.pvpnet.suggestedplayers
{
   import com.riotgames.platform.provider.ProviderLookup;
   
   public class SuggestedPlayersProviderProxy
   {
      
      public function SuggestedPlayersProviderProxy()
      {
         super();
      }
      
      public static function get instance() : ISuggestedPlayersProvider
      {
         return ProviderLookup.getProviderProxy(ISuggestedPlayersProvider);
      }
   }
}

