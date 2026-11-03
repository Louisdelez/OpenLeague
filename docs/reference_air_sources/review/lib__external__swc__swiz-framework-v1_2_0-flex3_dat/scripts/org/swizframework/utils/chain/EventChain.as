package org.swizframework.utils.chain
{
   import flash.events.IEventDispatcher;
   
   public class EventChain extends BaseCompositeChain
   {
      
      protected var _dispatcher:IEventDispatcher;
      
      public function EventChain(dispatcher:IEventDispatcher, mode:String = "sequence", stopOnError:Boolean = true)
      {
         super(mode,stopOnError);
         this.dispatcher = dispatcher;
      }
      
      public function get dispatcher() : IEventDispatcher
      {
         return this._dispatcher;
      }
      
      public function set dispatcher(value:IEventDispatcher) : void
      {
         this._dispatcher = value;
      }
      
      public function addEvent(event:EventChainStep) : EventChain
      {
         addStep(event);
         return this;
      }
      
      override public function doProceed() : void
      {
         if(currentStep is EventChainStep)
         {
            EventChainStep(currentStep).dispatcher = EventChainStep(currentStep).dispatcher || this.dispatcher;
         }
         super.doProceed();
      }
   }
}

