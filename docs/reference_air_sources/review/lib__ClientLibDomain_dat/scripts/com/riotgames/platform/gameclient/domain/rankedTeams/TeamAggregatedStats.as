package com.riotgames.platform.gameclient.domain.rankedTeams
{
   import com.riotgames.platform.gameclient.domain.AbstractDomainObject;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.statistics.team.TeamAggregatedStatsDTO")]
   public class TeamAggregatedStats extends AbstractDomainObject implements IEventDispatcher
   {
      
      private var _1739445269queueType:String;
      
      private var _877713320teamId:TeamId;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _2093857737playerAggregatedStatsList:ArrayCollection;
      
      public function TeamAggregatedStats()
      {
         super();
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
      
      [Bindable(event="propertyChange")]
      public function get queueType() : String
      {
         return this._1739445269queueType;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function set playerAggregatedStatsList(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._2093857737playerAggregatedStatsList;
         if(_loc2_ !== param1)
         {
            this._2093857737playerAggregatedStatsList = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"playerAggregatedStatsList",_loc2_,param1));
         }
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function set teamId(param1:TeamId) : void
      {
         var _loc2_:Object = this._877713320teamId;
         if(_loc2_ !== param1)
         {
            this._877713320teamId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"teamId",_loc2_,param1));
         }
      }
      
      public function set queueType(param1:String) : void
      {
         var _loc2_:Object = this._1739445269queueType;
         if(_loc2_ !== param1)
         {
            this._1739445269queueType = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"queueType",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get playerAggregatedStatsList() : ArrayCollection
      {
         return this._2093857737playerAggregatedStatsList;
      }
      
      [Bindable(event="propertyChange")]
      public function get teamId() : TeamId
      {
         return this._877713320teamId;
      }
   }
}

