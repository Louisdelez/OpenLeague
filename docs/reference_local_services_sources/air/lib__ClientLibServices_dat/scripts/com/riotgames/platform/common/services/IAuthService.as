package com.riotgames.platform.common.services
{
   import com.riotgames.platform.common.services.login.queue.LoginQueueState;
   
   public interface IAuthService
   {
      
      function forcePoll() : void;
      
      function set queueMonitor(param1:ILoginQueueMonitor) : void;
      
      function listenForStatusChange(param1:LoginQueueState, param2:Function, param3:Function) : void;
      
      function authenticate(param1:String, param2:Function, param3:Function) : void;
      
      function cancelQueue(param1:String, param2:Function, param3:Function) : void;
      
      function stopListening() : void;
      
      function getPollInterval() : int;
      
      function getAuthToken(param1:String, param2:Function, param3:Function) : void;
   }
}

