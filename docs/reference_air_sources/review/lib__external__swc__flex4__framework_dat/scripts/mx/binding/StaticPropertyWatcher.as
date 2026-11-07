package mx.binding
{
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import mx.core.EventPriority;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   
   use namespace mx_internal;
   
   [ExcludeClass]
   public class StaticPropertyWatcher extends Watcher
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private var parentObj:Class;
      
      protected var events:Object;
      
      private var propertyGetter:Function;
      
      private var _propertyName:String;
      
      public function StaticPropertyWatcher(propertyName:String, events:Object, listeners:Array, propertyGetter:Function = null)
      {
         super(listeners);
         this._propertyName = propertyName;
         this.events = events;
         this.propertyGetter = propertyGetter;
      }
      
      public function get propertyName() : String
      {
         return this._propertyName;
      }
      
      override public function updateParent(parent:Object) : void
      {
         var eventType:String = null;
         var eventDispatcher:IEventDispatcher = null;
         this.parentObj = Class(parent);
         if(this.parentObj["staticEventDispatcher"] != null)
         {
            for(eventType in this.events)
            {
               if(eventType != "__NoChangeEvent__")
               {
                  eventDispatcher = this.parentObj["staticEventDispatcher"];
                  eventDispatcher.addEventListener(eventType,this.eventHandler,false,EventPriority.BINDING,true);
               }
            }
         }
         wrapUpdate(this.updateProperty);
      }
      
      override protected function shallowClone() : Watcher
      {
         return new StaticPropertyWatcher(this._propertyName,this.events,listeners,this.propertyGetter);
      }
      
      private function traceInfo() : String
      {
         return "StaticPropertyWatcher(" + this.parentObj + "." + this._propertyName + "): events = [" + this.eventNamesToString() + "]";
      }
      
      private function eventNamesToString() : String
      {
         var ev:String = null;
         var s:String = " ";
         for(ev in this.events)
         {
            s += ev + " ";
         }
         return s;
      }
      
      private function updateProperty() : void
      {
         if(Boolean(this.parentObj))
         {
            if(this.propertyGetter != null)
            {
               value = this.propertyGetter.apply(this.parentObj,[this._propertyName]);
            }
            else
            {
               value = this.parentObj[this._propertyName];
            }
         }
         else
         {
            value = null;
         }
         updateChildren();
      }
      
      public function eventHandler(event:Event) : void
      {
         var propName:Object = null;
         if(event is PropertyChangeEvent)
         {
            propName = PropertyChangeEvent(event).property;
            if(propName != this._propertyName)
            {
               return;
            }
         }
         wrapUpdate(this.updateProperty);
         notifyListeners(this.events[event.type]);
      }
   }
}

