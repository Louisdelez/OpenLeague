package org.swizframework.core
{
   import flash.events.IEventDispatcher;
   
   public interface IDispatcherAware extends ISwizInterface
   {
      
      function set dispatcher(param1:IEventDispatcher) : void;
   }
}

