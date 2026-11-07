package blix.signals
{
   import flash.events.IEventDispatcher;
   
   public interface INativeDispatcher
   {
      
      function getEventType() : String;
      
      function getEventDispatcher() : IEventDispatcher;
      
      function setEventDispatcher(param1:IEventDispatcher) : void;
   }
}

