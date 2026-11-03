package com.degrafa.core
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import mx.core.IMXMLObject;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.events.PropertyChangeEventKind;
   import mx.utils.NameUtil;
   
   use namespace degrafa_internal;
   
   public class DegrafaObject implements IDegrafaObject, IMXMLObject
   {
      
      public var objectBindings:Array;
      
      private var _suppressEventProcessing:Boolean = false;
      
      private var _eventDispatcher:EventDispatcher;
      
      private var _id:String;
      
      degrafa_internal var _parent:IDegrafaObject;
      
      private var _isInitialized:Boolean;
      
      private var _enableEvents:Boolean = true;
      
      private var _document:Object;
      
      public function DegrafaObject()
      {
         super();
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return eventDispatcher.willTrigger(param1);
      }
      
      public function set enableEvents(param1:Boolean) : void
      {
         _enableEvents = param1;
      }
      
      public function get name() : String
      {
         return id;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return eventDispatcher.hasEventListener(param1);
      }
      
      public function dispatchPropertyChange(param1:Boolean = false, param2:Object = null, param3:Object = null, param4:Object = null, param5:Object = null) : Boolean
      {
         return dispatchEvent(new PropertyChangeEvent("propertyChange",param1,false,PropertyChangeEventKind.UPDATE,param2,param3,param4,param5));
      }
      
      public function get hasEventManager() : Boolean
      {
         return _eventDispatcher ? true : false;
      }
      
      public function get id() : String
      {
         if(_id)
         {
            return _id;
         }
         _id = NameUtil.createUniqueName(this);
         return _id;
      }
      
      public function get parent() : IDegrafaObject
      {
         return degrafa_internal::_parent;
      }
      
      public function get document() : Object
      {
         return _document;
      }
      
      public function set suppressEventProcessing(param1:Boolean) : void
      {
         if(_suppressEventProcessing == true && param1 == false)
         {
            _suppressEventProcessing = param1;
            initChange("suppressEventProcessing",false,true,this);
         }
         else
         {
            _suppressEventProcessing = param1;
         }
      }
      
      public function set id(param1:String) : void
      {
         _id = param1;
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         if(_suppressEventProcessing)
         {
            param1.stopImmediatePropagation();
            return false;
         }
         return eventDispatcher.dispatchEvent(param1);
      }
      
      protected function set eventDispatcher(param1:EventDispatcher) : void
      {
         _eventDispatcher = param1;
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         eventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = true) : void
      {
         eventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function get isInitialized() : Boolean
      {
         return _isInitialized;
      }
      
      public function set parent(param1:IDegrafaObject) : void
      {
         degrafa_internal::_parent = param1;
      }
      
      public function get suppressEventProcessing() : Boolean
      {
         return _suppressEventProcessing;
      }
      
      public function initChange(param1:String, param2:Object, param3:Object, param4:Object) : void
      {
         if(hasEventManager && !suppressEventProcessing)
         {
            dispatchPropertyChange(false,param1,param2,param3,param4);
         }
      }
      
      protected function get eventDispatcher() : EventDispatcher
      {
         if(!_eventDispatcher)
         {
            _eventDispatcher = new EventDispatcher(this);
         }
         return _eventDispatcher;
      }
      
      public function initialized(param1:Object, param2:String) : void
      {
         if(!_id)
         {
            if(param2)
            {
               _id = param2;
            }
            else
            {
               _id = NameUtil.createUniqueName(this);
            }
         }
         _document = param1;
         _isInitialized = true;
         if(enableEvents && !_suppressEventProcessing)
         {
            dispatchEvent(new FlexEvent(FlexEvent.INITIALIZE));
         }
      }
      
      public function get enableEvents() : Boolean
      {
         return _enableEvents;
      }
   }
}

