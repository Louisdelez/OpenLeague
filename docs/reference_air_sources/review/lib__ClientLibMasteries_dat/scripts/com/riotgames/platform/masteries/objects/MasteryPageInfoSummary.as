package com.riotgames.platform.masteries.objects
{
   import blix.signals.Signal;
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   public class MasteryPageInfoSummary implements IEventDispatcher
   {
      
      public var pageNameChanged:Signal = new Signal();
      
      private var _pageName:String = "";
      
      public var pageID:int = -1;
      
      public var pageTooltip:DisplayObject = null;
      
      public var isCurrent:Boolean = false;
      
      public var totalSpentPoints:int = 0;
      
      public var categoryPointsSpent:Vector.<int> = new Vector.<int>();
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function MasteryPageInfoSummary()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function get pageName() : String
      {
         return this._pageName;
      }
      
      private function set _859271610pageName(param1:String) : void
      {
         this._pageName = param1;
         this.pageNameChanged.dispatch();
      }
      
      public function set pageName(param1:String) : void
      {
         var _loc2_:Object = this.pageName;
         if(_loc2_ !== param1)
         {
            this._859271610pageName = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"pageName",_loc2_,param1));
            }
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
   }
}

