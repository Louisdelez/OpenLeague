package com.riotgames.platform.common.services.lcdsproxy.servicecalls
{
   public interface IAsyncLcdsProxyServiceCall extends ILcdsProxyServiceCall
   {
      
      function handleTimeout() : void;
      
      function handleAck() : void;
      
      function get timeoutDuration() : Number;
      
      function set timeoutDuration(param1:Number) : void;
      
      function get timeoutLifetime() : Number;
   }
}

