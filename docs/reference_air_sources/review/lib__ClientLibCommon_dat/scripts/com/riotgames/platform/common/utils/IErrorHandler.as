package com.riotgames.platform.common.utils
{
   import flash.events.UncaughtErrorEvent;
   
   public interface IErrorHandler
   {
      
      function handleError(param1:Error) : void;
      
      function handleUncaughtErrorEvent(param1:UncaughtErrorEvent) : void;
   }
}

