package org.swizframework.utils.async
{
   import flash.events.Event;
   import org.swizframework.utils.chain.IAsyncChainStep;
   
   public class AsynchronousEvent extends Event implements IAsynchronousEvent
   {
      
      protected var _step:IAsyncChainStep;
      
      public function AsynchronousEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false)
      {
         super(type,bubbles,cancelable);
      }
      
      public function get step() : IAsyncChainStep
      {
         return this._step;
      }
      
      public function set step(value:IAsyncChainStep) : void
      {
         this._step = value;
      }
      
      override public function clone() : Event
      {
         var clone:AsynchronousEvent = new AsynchronousEvent(type,bubbles,cancelable);
         clone.step = this.step;
         return clone;
      }
   }
}

