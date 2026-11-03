package org.swizframework.utils.async
{
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   
   public class AsynchronousIOOperation extends AbstractAsynchronousDispatcherOperation implements IAsynchronousOperation
   {
      
      public function AsynchronousIOOperation(dispatcher:IEventDispatcher)
      {
         super(dispatcher);
      }
      
      override protected function addEventListeners(dispatcher:IEventDispatcher) : void
      {
         dispatcher.addEventListener(Event.CANCEL,failHandler);
         dispatcher.addEventListener(Event.COMPLETE,completeHandler);
         dispatcher.addEventListener(IOErrorEvent.IO_ERROR,failHandler);
         dispatcher.addEventListener(SecurityErrorEvent.SECURITY_ERROR,failHandler);
      }
      
      override protected function removeEventListeners(dispatcher:IEventDispatcher) : void
      {
         dispatcher.removeEventListener(Event.CANCEL,failHandler);
         dispatcher.removeEventListener(Event.COMPLETE,completeHandler);
         dispatcher.removeEventListener(IOErrorEvent.IO_ERROR,failHandler);
         dispatcher.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,failHandler);
      }
   }
}

