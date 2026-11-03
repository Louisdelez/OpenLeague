package mx.utils
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   
   public class OnDemandEventDispatcher implements IEventDispatcher
   {
      
      private var _dispatcher:EventDispatcher;
      
      public function OnDemandEventDispatcher()
      {
         super();
      }
      
      public function addEventListener(type:String, listener:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false) : void
      {
         if(this._dispatcher == null)
         {
            this._dispatcher = new EventDispatcher(this);
         }
         this._dispatcher.addEventListener(type,listener,useCapture,priority,useWeakReference);
      }
      
      public function dispatchEvent(event:Event) : Boolean
      {
         if(this._dispatcher != null)
         {
            return this._dispatcher.dispatchEvent(event);
         }
         return true;
      }
      
      public function hasEventListener(type:String) : Boolean
      {
         if(this._dispatcher != null)
         {
            return this._dispatcher.hasEventListener(type);
         }
         return false;
      }
      
      public function removeEventListener(type:String, listener:Function, useCapture:Boolean = false) : void
      {
         if(this._dispatcher != null)
         {
            this._dispatcher.removeEventListener(type,listener,useCapture);
         }
      }
      
      public function willTrigger(type:String) : Boolean
      {
         if(this._dispatcher != null)
         {
            return this._dispatcher.willTrigger(type);
         }
         return false;
      }
   }
}

