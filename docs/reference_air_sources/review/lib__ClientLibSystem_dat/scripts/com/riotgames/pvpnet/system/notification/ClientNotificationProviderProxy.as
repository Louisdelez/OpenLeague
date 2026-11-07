package com.riotgames.pvpnet.system.notification
{
   import com.riotgames.platform.common.services.lcdsproxy.ILcdsProxyMessageRouter;
   import com.riotgames.platform.provider.proxy.ProviderProxyBase;
   
   public class ClientNotificationProviderProxy extends ProviderProxyBase implements IClientNotificationProvider
   {
      
      private static var _instance:IClientNotificationProvider;
      
      public function ClientNotificationProviderProxy()
      {
         super(IClientNotificationProvider);
      }
      
      public static function get instance() : IClientNotificationProvider
      {
         if(_instance == null)
         {
            _instance = new ClientNotificationProviderProxy();
         }
         return _instance;
      }
      
      §§namespace("http://www.riotgames.com/pvpnet/internal") static function setInstance(param1:IClientNotificationProvider) : void
      {
         _instance = param1;
      }
      
      public function initializeClientNotifications() : void
      {
         _invoke("initializeClientNotifications");
      }
      
      public function getLcdsProxyMessageRouter() : ILcdsProxyMessageRouter
      {
         return _invoke("getLcdsProxyMessageRouter");
      }
      
      public function enableNotificationProcessing() : void
      {
         _invoke("enableNotificationProcessing");
      }
      
      public function addClientNotificationMessageListener(param1:String, param2:Function) : void
      {
         _invoke("addClientNotificationMessageListener",[param1,param2]);
      }
      
      public function removeClientNotificationMessageListener(param1:String, param2:Function) : void
      {
         _invoke("removeClientNotificationMessageListener",[param1,param2]);
      }
      
      public function addLcdsProxyMessageRouter(param1:ILcdsProxyMessageRouter) : void
      {
         _invoke("addLcdsProxyMessageRouter",[param1]);
      }
   }
}

