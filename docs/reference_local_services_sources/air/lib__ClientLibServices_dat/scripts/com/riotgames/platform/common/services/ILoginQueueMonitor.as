package com.riotgames.platform.common.services
{
   import com.riotgames.platform.common.event.LoginQueueEvent;
   import com.riotgames.platform.common.services.login.queue.LoginQueueState;
   
   public interface ILoginQueueMonitor
   {
      
      function removeQueueListener(param1:Function) : void;
      
      function clearListeners() : void;
      
      function addQueueListener(param1:Function) : void;
      
      function forcePoll() : void;
      
      function dispatchPositionChanged(param1:LoginQueueEvent) : void;
      
      function getPollInterval() : int;
      
      function connect(param1:LoginQueueState, param2:Function) : void;
      
      function set pollingService(param1:PollingService) : void;
      
      function disconnect() : void;
   }
}

