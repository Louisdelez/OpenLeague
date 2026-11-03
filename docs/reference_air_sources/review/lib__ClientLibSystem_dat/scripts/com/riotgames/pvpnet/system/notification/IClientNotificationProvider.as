package com.riotgames.pvpnet.system.notification
{
   import com.riotgames.platform.common.services.lcdsproxy.ILcdsProxyMessageRouter;
   import com.riotgames.platform.provider.IProvider;
   
   public interface IClientNotificationProvider extends IProvider
   {
      
      function initializeClientNotifications() : void;
      
      function getLcdsProxyMessageRouter() : ILcdsProxyMessageRouter;
      
      function enableNotificationProcessing() : void;
      
      function addClientNotificationMessageListener(param1:String, param2:Function) : void;
      
      function removeClientNotificationMessageListener(param1:String, param2:Function) : void;
   }
}

