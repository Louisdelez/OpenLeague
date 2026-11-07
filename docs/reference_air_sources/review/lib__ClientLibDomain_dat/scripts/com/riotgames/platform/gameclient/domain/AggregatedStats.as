package com.riotgames.platform.gameclient.domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.statistics.AggregatedStats")]
   public class AggregatedStats implements IEventDispatcher
   {
      
      private var _114275892lifetimeStatistics:ArrayCollection;
      
      private var _106079key:AggregatedStatsKey;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function AggregatedStats()
      {
         super();
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get lifetimeStatistics() : ArrayCollection
      {
         return this._114275892lifetimeStatistics;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function set lifetimeStatistics(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._114275892lifetimeStatistics;
         if(_loc2_ !== param1)
         {
            this._114275892lifetimeStatistics = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lifetimeStatistics",_loc2_,param1));
         }
      }
      
      public function toString() : String
      {
         return this.key.toString() + ":numStats=" + this.lifetimeStatistics.length;
      }
      
      public function set key(param1:AggregatedStatsKey) : void
      {
         var _loc2_:Object = this._106079key;
         if(_loc2_ !== param1)
         {
            this._106079key = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"key",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get key() : AggregatedStatsKey
      {
         return this._106079key;
      }
   }
}

