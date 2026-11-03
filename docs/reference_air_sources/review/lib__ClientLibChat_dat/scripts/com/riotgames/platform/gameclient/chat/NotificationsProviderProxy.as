package com.riotgames.platform.gameclient.chat
{
   import com.riotgames.platform.provider.ProviderLookup;
   
   public class NotificationsProviderProxy
   {
      
      public function NotificationsProviderProxy()
      {
         super();
      }
      
      public static function get instance() : INotificationsProvider
      {
         return ProviderLookup.getProviderProxy(INotificationsProvider);
      }
      
      §§namespace("http://www.riotgames.com/pvpnet/internal") static function setInstance(param1:INotificationsProvider) : void
      {
         ProviderLookup.setProviderProxy(INotificationsProvider,param1);
      }
   }
}

