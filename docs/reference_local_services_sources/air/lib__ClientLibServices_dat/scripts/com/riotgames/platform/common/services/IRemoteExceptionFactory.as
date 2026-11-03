package com.riotgames.platform.common.services
{
   public interface IRemoteExceptionFactory
   {
      
      function shouldInterruptServiceCall(param1:String, param2:String, param3:Array) : Boolean;
      
      function generateSimulatedRemoteServiceError(param1:String, param2:String, param3:Array) : Object;
   }
}

