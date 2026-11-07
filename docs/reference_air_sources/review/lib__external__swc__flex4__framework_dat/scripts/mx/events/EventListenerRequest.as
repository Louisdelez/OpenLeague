package mx.events
{
   import flash.events.Event;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class EventListenerRequest extends SWFBridgeRequest
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      public static const ADD_EVENT_LISTENER_REQUEST:String = "addEventListenerRequest";
      
      public static const REMOVE_EVENT_LISTENER_REQUEST:String = "removeEventListenerRequest";
      
      private var _priority:int;
      
      private var _useCapture:Boolean;
      
      private var _eventType:String;
      
      private var _listener:Function;
      
      private var _useWeakReference:Boolean;
      
      public function EventListenerRequest(type:String, bubbles:Boolean = false, cancelable:Boolean = true, eventType:String = null, listener:Function = null, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false)
      {
         super(type,false,false);
         this._eventType = eventType;
         this._listener = listener;
         this._useCapture = useCapture;
         this._priority = priority;
         this._useWeakReference = useWeakReference;
      }
      
      public static function marshal(event:Event) : EventListenerRequest
      {
         var eventObj:Object = event;
         return new EventListenerRequest(eventObj.type,eventObj.bubbles,eventObj.cancelable,eventObj.eventType,"listener" in eventObj ? eventObj.listener : null,eventObj.useCapture,eventObj.priority,eventObj.useWeakReference);
      }
      
      public function get priority() : int
      {
         return this._priority;
      }
      
      public function get useCapture() : Boolean
      {
         return this._useCapture;
      }
      
      public function get eventType() : String
      {
         return this._eventType;
      }
      
      public function get listener() : Function
      {
         return this._listener;
      }
      
      public function get useWeakReference() : Boolean
      {
         return this._useWeakReference;
      }
      
      override public function clone() : Event
      {
         return new EventListenerRequest(type,bubbles,cancelable,this.eventType,this.listener,this.useCapture,this.priority,this.useWeakReference);
      }
   }
}

