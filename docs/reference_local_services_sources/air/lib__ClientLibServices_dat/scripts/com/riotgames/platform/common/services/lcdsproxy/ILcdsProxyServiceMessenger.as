package com.riotgames.platform.common.services.lcdsproxy
{
   import blix.IDestructible;
   import com.riotgames.platform.common.services.lcdsproxy.servicecalls.IAsyncLcdsProxyServiceCall;
   import com.riotgames.platform.common.services.lcdsproxy.servicecalls.ILcdsProxyServiceCall;
   
   public interface ILcdsProxyServiceMessenger extends IDestructible
   {
      
      function onMessageReceived(param1:String, param2:String = null, param3:String = null, param4:String = null) : void;
      
      function invokeProxyServiceWithSession(param1:ILcdsProxyServiceCall) : String;
      
      function invokeAsyncProxyServiceWithSession(param1:IAsyncLcdsProxyServiceCall) : String;
      
      function invokeAsyncProxyServiceWithoutSession(param1:IAsyncLcdsProxyServiceCall) : String;
      
      function invokeProxyServiceWithoutSession(param1:ILcdsProxyServiceCall) : String;
   }
}

