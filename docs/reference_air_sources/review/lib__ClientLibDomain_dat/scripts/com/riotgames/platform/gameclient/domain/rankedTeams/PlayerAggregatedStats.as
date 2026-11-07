package com.riotgames.platform.gameclient.domain.rankedTeams
{
   import com.riotgames.platform.gameclient.domain.AbstractDomainObject;
   import com.riotgames.platform.gameclient.domain.AggregatedStats;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.statistics.team.TeamPlayerAggregatedStatsDTO")]
   public class PlayerAggregatedStats extends AbstractDomainObject implements IEventDispatcher
   {
      
      private var _1879273436playerId:Number;
      
      private var _640804122aggregatedStats:AggregatedStats;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function PlayerAggregatedStats()
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
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function set aggregatedStats(param1:AggregatedStats) : void
      {
         var _loc2_:Object = this._640804122aggregatedStats;
         if(_loc2_ !== param1)
         {
            this._640804122aggregatedStats = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"aggregatedStats",_loc2_,param1));
         }
      }
      
      public function set playerId(param1:Number) : void
      {
         var _loc2_:Object = this._1879273436playerId;
         if(_loc2_ !== param1)
         {
            this._1879273436playerId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"playerId",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get aggregatedStats() : AggregatedStats
      {
         return this._640804122aggregatedStats;
      }
      
      [Bindable(event="propertyChange")]
      public function get playerId() : Number
      {
         return this._1879273436playerId;
      }
   }
}

