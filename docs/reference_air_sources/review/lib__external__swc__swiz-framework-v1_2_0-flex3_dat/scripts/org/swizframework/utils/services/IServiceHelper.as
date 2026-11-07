package org.swizframework.utils.services
{
   import mx.rpc.AsyncToken;
   
   public interface IServiceHelper
   {
      
      function executeServiceCall(param1:AsyncToken, param2:Function, param3:Function = null, param4:Array = null) : AsyncToken;
   }
}

