package com.riotgames.platform.gameclient.domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.statistics.SummaryAggStat")]
   public class SummaryAggStat extends AbstractDomainObject implements IEventDispatcher
   {
      
      private var _1317715886statType:String;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _111972721value:Number;
      
      public function SummaryAggStat()
      {
         super();
      }
      
      public function set value(param1:Number) : void
      {
         var _loc2_:Object = this._111972721value;
         if(_loc2_ !== param1)
         {
            this._111972721value = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"value",_loc2_,param1));
         }
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      [Bindable(event="propertyChange")]
      public function get statType() : String
      {
         return this._1317715886statType;
      }
      
      [Bindable(event="propertyChange")]
      public function get value() : Number
      {
         return this._111972721value;
      }
      
      public function set statType(param1:String) : void
      {
         var _loc2_:Object = this._1317715886statType;
         if(_loc2_ !== param1)
         {
            this._1317715886statType = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"statType",_loc2_,param1));
         }
      }
   }
}

