package com.riotgames.platform.common.services.lcdsproxy
{
   public interface ILcdsProxyMessageRouter
   {
      
      function onMessageReceived(param1:String) : void;
      
      function removeServiceCallListener(param1:String) : void;
      
      function setServiceCallListener(param1:String, param2:ILcdsProxyServiceMessenger) : void;
   }
}

