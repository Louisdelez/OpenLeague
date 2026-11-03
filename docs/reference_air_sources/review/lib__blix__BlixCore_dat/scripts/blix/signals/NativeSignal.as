package blix.signals
{
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   
   public class NativeSignal extends Signal implements INativeDispatcher
   {
      
      protected var _eventDispatcher:IEventDispatcher;
      
      protected var _eventType:String;
      
      protected var _nativeHandlerIsRegistered:Boolean;
      
      public function NativeSignal(param1:String, param2:IEventDispatcher = null)
      {
         super();
         this.setEventDispatcher(param2);
         this._eventType = param1;
      }
      
      public function getEventType() : String
      {
         return this._eventType;
      }
      
      public function getEventDispatcher() : IEventDispatcher
      {
         return this._eventDispatcher;
      }
      
      public function setEventDispatcher(param1:IEventDispatcher) : void
      {
         if(param1 == this._eventDispatcher)
         {
            return;
         }
         if(this._nativeHandlerIsRegistered)
         {
            this._eventDispatcher.removeEventListener(this._eventType,this.nativeEventHandler);
            this._nativeHandlerIsRegistered = false;
         }
         this._eventDispatcher = param1;
         if(this._eventDispatcher != null && !listeners.getIsEmpty())
         {
            this._eventDispatcher.addEventListener(this._eventType,this.nativeEventHandler);
            this._nativeHandlerIsRegistered = true;
         }
      }
      
      override protected function registerListener(param1:Function, param2:Boolean, param3:Boolean) : ListenerListItem
      {
         if(!this._nativeHandlerIsRegistered && this._eventDispatcher != null)
         {
            this._eventDispatcher.addEventListener(this._eventType,this.nativeEventHandler);
            this._nativeHandlerIsRegistered = true;
         }
         return super.registerListener(param1,param2,param3);
      }
      
      override public function removeItem(param1:ListenerListItem) : void
      {
         super.removeItem(param1);
         if(this._nativeHandlerIsRegistered && listeners.getIsEmpty())
         {
            this._eventDispatcher.removeEventListener(this._eventType,this.nativeEventHandler);
            this._nativeHandlerIsRegistered = false;
         }
      }
      
      override public function removeAll() : void
      {
         super.removeAll();
         if(this._nativeHandlerIsRegistered)
         {
            this._eventDispatcher.removeEventListener(this._eventType,this.nativeEventHandler);
            this._nativeHandlerIsRegistered = false;
         }
      }
      
      override public function dispatch(... rest) : void
      {
         if(null == rest)
         {
            throw new ArgumentError("Event object expected.");
         }
         if(rest.length != 1)
         {
            throw new ArgumentError("No more than one Event object expected.");
         }
         if(listeners.getIsEmpty())
         {
            return;
         }
         super.dispatch(rest[0] as Event);
         if(this._nativeHandlerIsRegistered && listeners.getIsEmpty())
         {
            this._eventDispatcher.removeEventListener(this._eventType,this.nativeEventHandler);
            this._nativeHandlerIsRegistered = false;
         }
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         this.dispatch(param1);
         return !param1.isDefaultPrevented();
      }
      
      protected function nativeEventHandler(param1:Event) : void
      {
         super.dispatch(param1);
         if(this._nativeHandlerIsRegistered && listeners.getIsEmpty())
         {
            this._nativeHandlerIsRegistered = false;
            this._eventDispatcher.removeEventListener(this._eventType,this.nativeEventHandler);
         }
      }
   }
}

