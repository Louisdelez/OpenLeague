package com.riotgames.platform.common.services.lcdsproxy.servicecalls
{
   import com.riotgames.platform.common.services.lcdsproxy.responses.ILcdsProxyMessageAction;
   import mx.rpc.Fault;
   
   public interface ILcdsProxyServiceCall extends ILcdsProxyMessageAction
   {
      
      function get serviceName() : String;
      
      function get serviceMethodName() : String;
      
      function get fault() : Fault;
      
      function handleError(param1:String = null) : void;
      
      function handleComplete(param1:Object = null) : void;
      
      function handleResponse(param1:String = null, param2:String = null) : void;
      
      function get asyncObject() : Object;
      
      function toMessage() : Array;
      
      function getRequestPayload(param1:Object = null) : Object;
      
      function get timeCreated() : Date;
      
      function get uuid() : String;
   }
}

