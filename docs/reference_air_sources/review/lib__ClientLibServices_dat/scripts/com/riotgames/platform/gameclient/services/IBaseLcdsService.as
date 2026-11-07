package com.riotgames.platform.gameclient.services
{
   import com.riotgames.platform.common.services.IRemoteExceptionFactory;
   import flash.utils.Dictionary;
   
   public interface IBaseLcdsService
   {
      
      function invokeServiceWithoutSession(param1:String, param2:String, param3:Array, param4:Function, param5:Function = null, param6:Dictionary = null, param7:Object = null, param8:Boolean = true, param9:Boolean = true, param10:Boolean = true) : void;
      
      function setRemoteExceptionFactory(param1:IRemoteExceptionFactory) : void;
      
      function invokeServiceWithSession(param1:String, param2:String, param3:Array, param4:Function, param5:Function = null, param6:Dictionary = null, param7:Object = null, param8:Boolean = true, param9:Boolean = true, param10:Boolean = true) : void;
   }
}

