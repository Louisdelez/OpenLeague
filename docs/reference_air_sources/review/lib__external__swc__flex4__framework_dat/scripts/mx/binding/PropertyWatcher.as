package mx.binding
{
   import flash.events.Event;
   import flash.events.IEventDispatcher;
   import flash.utils.getQualifiedClassName;
   import mx.core.EventPriority;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.utils.DescribeTypeCache;
   
   use namespace mx_internal;
   
   [ExcludeClass]
   public class PropertyWatcher extends Watcher
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      private var parentObj:Object;
      
      protected var events:Object;
      
      protected var propertyGetter:Function;
      
      private var _propertyName:String;
      
      private var useRTTI:Boolean;
      
      public function PropertyWatcher(propertyName:String, events:Object, listeners:Array, propertyGetter:Function = null)
      {
         super(listeners);
         this._propertyName = propertyName;
         this.events = events;
         this.propertyGetter = propertyGetter;
         this.useRTTI = !events;
      }
      
      public function get propertyName() : String
      {
         return this._propertyName;
      }
      
      override public function updateParent(parent:Object) : void
      {
         var eventType:String = null;
         var info:BindabilityInfo = null;
         if(Boolean(this.parentObj) && this.parentObj is IEventDispatcher)
         {
            for(eventType in this.events)
            {
               this.parentObj.removeEventListener(eventType,this.eventHandler);
            }
         }
         if(parent is Watcher)
         {
            this.parentObj = parent.value;
         }
         else
         {
            this.parentObj = parent;
         }
         if(Boolean(this.parentObj))
         {
            if(this.useRTTI)
            {
               this.events = {};
               if(this.parentObj is IEventDispatcher)
               {
                  info = DescribeTypeCache.describeType(this.parentObj).bindabilityInfo;
                  this.events = info.getChangeEvents(this._propertyName);
                  if(this.objectIsEmpty(this.events))
                  {
                     trace("warning: unable to bind to property \'" + this._propertyName + "\' on class \'" + getQualifiedClassName(this.parentObj) + "\'");
                  }
                  else
                  {
                     this.addParentEventListeners();
                  }
               }
               else
               {
                  trace("warning: unable to bind to property \'" + this._propertyName + "\' on class \'" + getQualifiedClassName(this.parentObj) + "\' (class is not an IEventDispatcher)");
               }
            }
            else if(this.parentObj is IEventDispatcher)
            {
               this.addParentEventListeners();
            }
         }
         wrapUpdate(this.updateProperty);
      }
      
      override protected function shallowClone() : Watcher
      {
         return new PropertyWatcher(this._propertyName,this.events,listeners,this.propertyGetter);
      }
      
      private function addParentEventListeners() : void
      {
         var eventType:String = null;
         for(eventType in this.events)
         {
            if(eventType != "__NoChangeEvent__")
            {
               this.parentObj.addEventListener(eventType,this.eventHandler,false,EventPriority.BINDING,true);
            }
         }
      }
      
      private function traceInfo() : String
      {
         return "Watcher(" + getQualifiedClassName(this.parentObj) + "." + this._propertyName + "): events = [" + this.eventNamesToString() + (this.useRTTI ? "] (RTTI)" : "]");
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
      
      private function objectIsEmpty(o:Object) : Boolean
      {
         var p:String = null;
         var _loc3_:int = 0;
         var _loc4_:* = o;
         for(p in _loc4_)
         {
            return false;
         }
         return true;
      }
      
      private function updateProperty() : void
      {
         if(Boolean(this.parentObj))
         {
            if(this._propertyName == "this")
            {
               value = this.parentObj;
            }
            else if(this.propertyGetter != null)
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

