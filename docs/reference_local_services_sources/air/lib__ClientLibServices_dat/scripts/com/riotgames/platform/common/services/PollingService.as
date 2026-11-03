package com.riotgames.platform.common.services
{
   import flash.events.IEventDispatcher;
   
   public interface PollingService extends IEventDispatcher
   {
      
      function startPolling(param1:Function, param2:Function) : void;
      
      function set pollingServiceURL(param1:String) : void;
   }
}

