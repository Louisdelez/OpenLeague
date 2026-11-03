package com.riotgames.pvpnet.system.alerter
{
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.riot_internal;
   
   public class AlerterProviderProxy
   {
      
      public function AlerterProviderProxy()
      {
         super();
      }
      
      public static function get instance() : IAlerterProvider
      {
         return ProviderLookup.getProviderProxy(IAlerterProvider);
      }
      
      §§namespace("http://www.riotgames.com/pvpnet/internal") static function setInstance(param1:IAlerterProvider) : void
      {
         ProviderLookup.riot_internal::setProviderProxy(IAlerterProvider,param1);
      }
   }
}

