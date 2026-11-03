package com.riotgames.platform.gameclient.domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.statistics.SummaryAggStats")]
   public class SummaryAggStats extends AbstractDomainObject implements IEventDispatcher
   {
      
      private var _109757599stats:ArrayCollection;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function SummaryAggStats()
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
      
      public function getStatValue(param1:String) : Number
      {
         var _loc2_:SummaryAggStat = this.getStat(param1);
         return _loc2_ == null ? 0 : _loc2_.value;
      }
      
      public function getStat(param1:String) : SummaryAggStat
      {
         var _loc2_:SummaryAggStat = null;
         for each(_loc2_ in this.stats)
         {
            if(_loc2_.statType == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function set stats(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._109757599stats;
         if(_loc2_ !== param1)
         {
            this._109757599stats = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"stats",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get stats() : ArrayCollection
      {
         return this._109757599stats;
      }
   }
}

