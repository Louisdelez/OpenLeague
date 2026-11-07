package com.riotgames.platform.gameclient.domain
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   
   public class PlayerChampionStats implements IEventDispatcher
   {
      
      private var _3649559wins:uint;
      
      private var _1839054608totalGamesPlayed:uint;
      
      private var _106164901owned:Boolean = false;
      
      private var _109757599stats:ArrayCollection;
      
      private var _1431766121champion:Champion;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function PlayerChampionStats()
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
      
      public function getLosses() : Number
      {
         return this.getStat(AggregatedStatType.STAT_TYPE_LOSSES);
      }
      
      private function getStat(param1:String) : Number
      {
         if(this.stats == null)
         {
            return 0;
         }
         var _loc2_:AggregatedStat = AggregatedStat.FindAggregatedStat(param1,this.stats);
         return _loc2_ == null ? 0 : _loc2_.value;
      }
      
      public function getWins() : Number
      {
         return this.wins;
      }
      
      public function set owned(param1:Boolean) : void
      {
         var _loc2_:Object = this._106164901owned;
         if(_loc2_ !== param1)
         {
            this._106164901owned = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"owned",_loc2_,param1));
         }
      }
      
      public function getTotalGames() : Number
      {
         return this.getStat(AggregatedStatType.GAMES_PLAYED);
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      [Bindable(event="propertyChange")]
      public function get totalGamesPlayed() : uint
      {
         return this._1839054608totalGamesPlayed;
      }
      
      public function set champion(param1:Champion) : void
      {
         var _loc2_:Object = this._1431766121champion;
         if(_loc2_ !== param1)
         {
            this._1431766121champion = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"champion",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get wins() : uint
      {
         return this._3649559wins;
      }
      
      public function getKills() : Number
      {
         return this.getStat(AggregatedStatType.STAT_TYPE_TOTAL_CHAMPION_KILLS);
      }
      
      public function set totalGamesPlayed(param1:uint) : void
      {
         var _loc2_:Object = this._1839054608totalGamesPlayed;
         if(_loc2_ !== param1)
         {
            this._1839054608totalGamesPlayed = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"totalGamesPlayed",_loc2_,param1));
         }
      }
      
      public function updateFromChampionStats(param1:ChampionStatInfo) : void
      {
         this.stats = param1.stats;
         this.totalGamesPlayed = param1.totalGamesPlayed;
         this.wins = this.getStat(AggregatedStatType.STAT_TYPE_WINS);
      }
      
      [Bindable(event="propertyChange")]
      public function get owned() : Boolean
      {
         return this._106164901owned;
      }
      
      [Bindable(event="propertyChange")]
      public function get stats() : ArrayCollection
      {
         return this._109757599stats;
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function set wins(param1:uint) : void
      {
         var _loc2_:Object = this._3649559wins;
         if(_loc2_ !== param1)
         {
            this._3649559wins = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"wins",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get champion() : Champion
      {
         return this._1431766121champion;
      }
      
      public function getAssists() : Number
      {
         return this.getStat(AggregatedStatType.TOTAL_ASSISTS);
      }
      
      public function getDeaths() : Number
      {
         return this.getStat(AggregatedStatType.STAT_TYPE_TOTAL_CHAMPION_DEATHS);
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
   }
}

