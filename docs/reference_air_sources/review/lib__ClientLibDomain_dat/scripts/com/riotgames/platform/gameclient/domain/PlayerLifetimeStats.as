package com.riotgames.platform.gameclient.domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   
   [RemoteClass(alias="com.riotgames.platform.statistics.PlayerLifetimeStats")]
   public class PlayerLifetimeStats extends AbstractDomainObject implements IEventDispatcher
   {
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _546037310playerStats:PlayerStats;
      
      private var _581949073playerStatSummaries:PlayerStatSummaries;
      
      private var _771927266previousFirstWinOfDay:Date;
      
      private var _1242688843gameStatistics:ArrayCollection;
      
      private var _836030906userId:Number;
      
      public function PlayerLifetimeStats()
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
      
      public function set previousFirstWinOfDay(param1:Date) : void
      {
         var _loc2_:Object = this._771927266previousFirstWinOfDay;
         if(_loc2_ !== param1)
         {
            this._771927266previousFirstWinOfDay = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"previousFirstWinOfDay",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get userId() : Number
      {
         return this._836030906userId;
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function set userId(param1:Number) : void
      {
         var _loc2_:Object = this._836030906userId;
         if(_loc2_ !== param1)
         {
            this._836030906userId = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"userId",_loc2_,param1));
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function set playerStatSummaries(param1:PlayerStatSummaries) : void
      {
         var _loc2_:Object = this._581949073playerStatSummaries;
         if(_loc2_ !== param1)
         {
            this._581949073playerStatSummaries = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"playerStatSummaries",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get previousFirstWinOfDay() : Date
      {
         return this._771927266previousFirstWinOfDay;
      }
      
      public function set gameStatistics(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1242688843gameStatistics;
         if(_loc2_ !== param1)
         {
            this._1242688843gameStatistics = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gameStatistics",_loc2_,param1));
         }
      }
      
      public function toString() : String
      {
         var _loc1_:String = "";
         _loc1_ += "userId=" + this.userId;
         return _loc1_ + (":gameStatistics=" + this.gameStatistics);
      }
      
      [Bindable(event="propertyChange")]
      public function get playerStatSummaries() : PlayerStatSummaries
      {
         return this._581949073playerStatSummaries;
      }
      
      [Bindable(event="propertyChange")]
      public function get gameStatistics() : ArrayCollection
      {
         return this._1242688843gameStatistics;
      }
      
      public function set playerStats(param1:PlayerStats) : void
      {
         var _loc2_:Object = this._546037310playerStats;
         if(_loc2_ !== param1)
         {
            this._546037310playerStats = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"playerStats",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get playerStats() : PlayerStats
      {
         return this._546037310playerStats;
      }
   }
}

