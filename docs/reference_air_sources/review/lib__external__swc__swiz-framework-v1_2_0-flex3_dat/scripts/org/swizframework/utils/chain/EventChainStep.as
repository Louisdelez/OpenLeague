package org.swizframework.utils.chain
{
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import org.swizframework.utils.async.IAsynchronousEvent;
   import org.swizframework.utils.async.IAsynchronousOperation;
   import org.swizframework.utils.services.SwizResponder;
   
   public class EventChainStep extends BaseChainStep implements IAutonomousChainStep, IAsyncChainStep
   {
      
      protected var _dispatcher:IEventDispatcher;
      
      protected var _event:Event;
      
      protected var _pendingCount:int = 0;
      
      public function EventChainStep(event:Event, dispatcher:IEventDispatcher = null)
      {
         super();
         this._dispatcher = dispatcher;
         this._event = event;
         if(this._event is IAsynchronousEvent)
         {
            IAsynchronousEvent(this._event).step = this;
         }
      }
      
      public function get dispatcher() : IEventDispatcher
      {
         return this._dispatcher;
      }
      
      public function set dispatcher(value:IEventDispatcher) : void
      {
         this._dispatcher = value;
      }
      
      public function get event() : Event
      {
         return this._event;
      }
      
      public function get pendingCount() : int
      {
         return this._pendingCount;
      }
      
      public function doProceed() : void
      {
         _failed = false;
         this._pendingCount = 0;
         this.dispatcher.dispatchEvent(this.event);
         if(this.pendingCount == 0 && !isComplete)
         {
            this.complete();
         }
      }
      
      override public function complete() : void
      {
         this._pendingCount = 0;
         super.complete();
      }
      
      override public function error() : void
      {
         _failed = true;
         super.error();
      }
      
      public function addAsynchronousOperation(operation:IAsynchronousOperation) : void
      {
         operation.addResponder(new SwizResponder(this.resultHandler,this.faultHandler));
         ++this._pendingCount;
      }
      
      protected function resultHandler(data:Object) : void
      {
         if(this._pendingCount > 0)
         {
            --this._pendingCount;
         }
         if(!_failed)
         {
            if(this._pendingCount == 0)
            {
               this.complete();
            }
         }
      }
      
      protected function faultHandler(info:Object) : void
      {
         if(this._pendingCount > 0)
         {
            --this._pendingCount;
         }
         this.error();
      }
   }
}

