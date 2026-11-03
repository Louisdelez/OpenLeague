package org.swizframework.utils.async
{
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   
   public class AbstractAsynchronousDispatcherOperation extends AbstractAsynchronousOperation implements IAsynchronousOperation
   {
      
      public function AbstractAsynchronousDispatcherOperation(dispatcher:IEventDispatcher)
      {
         super();
         this.addEventListeners(dispatcher);
      }
      
      protected function addEventListeners(dispatcher:IEventDispatcher) : void
      {
      }
      
      protected function removeEventListeners(dispatcher:IEventDispatcher) : void
      {
      }
      
      protected function completeHandler(event:Event) : void
      {
         this.removeEventListeners(event.target as IEventDispatcher);
         complete(event);
      }
      
      protected function failHandler(event:Event) : void
      {
         this.removeEventListeners(event.target as IEventDispatcher);
         fail(event);
      }
   }
}

