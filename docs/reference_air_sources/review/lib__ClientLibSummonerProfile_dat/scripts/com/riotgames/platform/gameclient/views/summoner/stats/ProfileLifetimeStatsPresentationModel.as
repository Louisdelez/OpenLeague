package com.riotgames.platform.gameclient.views.summoner.stats
{
   import com.riotgames.platform.gameclient.domain.AggregatedStat;
   import com.riotgames.platform.gameclient.domain.AggregatedStatType;
   import com.riotgames.platform.gameclient.domain.Champion;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.collections.Sort;
   import mx.events.PropertyChangeEvent;
   
   public class ProfileLifetimeStatsPresentationModel implements IEventDispatcher
   {
      
      private var _1537709924championId:Number;
      
      private var _577192581totalWins:Number = 0;
      
      private var _940516491totalLosses:Number = 0;
      
      private var _1132421745winRatio:Number = 0;
      
      private var _728116771totalGames:Number;
      
      private var _1431766121champion:Champion;
      
      private var _724185103totalKills:Number;
      
      private var _1179320093totalDeaths:Number;
      
      private var _149613754totalAssists:Number;
      
      private var _1358513782totalLeftColStats:ArrayCollection = new ArrayCollection();
      
      private var _1461014615totalRightColStats:ArrayCollection = new ArrayCollection();
      
      private var _1921431843avgKills:Number;
      
      private var _769573391avgDeaths:Number;
      
      private var _332367880avgAssists:Number;
      
      private var _1086039357kdaRatio:Number;
      
      private var _2027391976avgLeftColStats:ArrayCollection = new ArrayCollection();
      
      private var _2094340215avgRightColStats:ArrayCollection = new ArrayCollection();
      
      private var lifetimeStats:ArrayCollection;
      
      private var globalStats:Array = null;
      
      private var totalStatsLeft:Array = null;
      
      private var totalStatsRight:Array = null;
      
      private var avgStatsLeft:Array = null;
      
      private var avgStatsRight:Array = null;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function ProfileLifetimeStatsPresentationModel()
      {
         super();
      }
      
      public function updateStats(param1:Champion, param2:ArrayCollection) : void
      {
         if(this.globalStats == null)
         {
            this.initializeLists();
         }
         this.lifetimeStats = param2;
         this.championId = Boolean(param1) ? Number(param1.championId) : 0;
         var _loc3_:AggregatedStat = AggregatedStat.FindAggregatedStat(AggregatedStatType.GAMES_PLAYED,param2);
         if(Boolean(_loc3_))
         {
            this.totalGames = _loc3_.value;
         }
         else
         {
            this.totalGames = 0;
         }
         this.updateStatLists();
         if(this.totalGames > 0)
         {
            this.winRatio = this.totalWins / (this.totalWins + this.totalLosses) * 100;
            this.kdaRatio = (this.totalKills + this.totalAssists) / this.totalDeaths;
         }
         else
         {
            this.avgKills = this.avgDeaths = this.avgAssists = this.totalWins = this.totalDeaths = this.totalAssists = this.totalKills = this.totalLosses = this.winRatio = this.kdaRatio = 0;
         }
         if(this.championId > 0)
         {
            this.champion = param1;
         }
         else
         {
            this.champion = null;
         }
      }
      
      private function updateGlobalStat(param1:AggregatedStat) : void
      {
         switch(param1.statType)
         {
            case AggregatedStatType.STAT_TYPE_WINS:
               this.totalWins = param1.value;
               break;
            case AggregatedStatType.STAT_TYPE_LOSSES:
               this.totalLosses = param1.value;
               break;
            case AggregatedStatType.STAT_TYPE_TOTAL_CHAMPION_KILLS:
               this.totalKills = param1.value;
               if(this.totalGames > 0)
               {
                  this.avgKills = this.totalKills / this.totalGames;
               }
               break;
            case AggregatedStatType.STAT_TYPE_TOTAL_CHAMPION_DEATHS:
               this.totalDeaths = param1.value;
               if(this.totalGames > 0)
               {
                  this.avgDeaths = this.totalDeaths / this.totalGames;
               }
               break;
            case AggregatedStatType.TOTAL_ASSISTS:
               this.totalAssists = param1.value;
               if(this.totalGames > 0)
               {
                  this.avgAssists = this.totalAssists / this.totalGames;
               }
         }
      }
      
      private function updateStatLists() : void
      {
         var _loc1_:AggregatedStat = null;
         this.totalLeftColStats.disableAutoUpdate();
         this.totalRightColStats.disableAutoUpdate();
         this.avgLeftColStats.disableAutoUpdate();
         this.avgRightColStats.disableAutoUpdate();
         this.totalLeftColStats.removeAll();
         this.totalRightColStats.removeAll();
         this.avgLeftColStats.removeAll();
         this.avgRightColStats.removeAll();
         for each(_loc1_ in this.lifetimeStats)
         {
            if(Boolean(this.globalStats[_loc1_.statType]))
            {
               this.updateGlobalStat(_loc1_);
            }
            else
            {
               if(Boolean(this.totalStatsLeft[_loc1_.statType]))
               {
                  this.totalLeftColStats.addItem(_loc1_);
               }
               else if(Boolean(this.totalStatsRight[_loc1_.statType]))
               {
                  this.totalRightColStats.addItem(_loc1_);
               }
               if(Boolean(this.avgStatsLeft[_loc1_.statType]))
               {
                  this.avgLeftColStats.addItem(_loc1_);
               }
               else if(Boolean(this.avgStatsRight[_loc1_.statType]))
               {
                  this.avgRightColStats.addItem(_loc1_);
               }
            }
         }
         this.totalLeftColStats.refresh();
         this.totalRightColStats.refresh();
         this.avgLeftColStats.refresh();
         this.avgRightColStats.refresh();
         this.totalLeftColStats.enableAutoUpdate();
         this.totalRightColStats.enableAutoUpdate();
         this.avgLeftColStats.enableAutoUpdate();
         this.avgRightColStats.enableAutoUpdate();
      }
      
      private function comparePriority(param1:AggregatedStat, param2:AggregatedStat, param3:Array = null) : int
      {
         var _loc4_:Number = this.findPriority(param1.statType);
         var _loc5_:Number = this.findPriority(param2.statType);
         if(_loc4_ == _loc5_)
         {
            return 0;
         }
         if(_loc4_ < _loc5_)
         {
            return -1;
         }
         return 1;
      }
      
      private function findPriority(param1:String) : Number
      {
         var _loc2_:Object = this.totalStatsLeft[param1];
         if(_loc2_ == null)
         {
            _loc2_ = this.totalStatsRight[param1];
         }
         if(_loc2_ != null)
         {
            return _loc2_ as Number;
         }
         return 0;
      }
      
      private function initializeLists() : void
      {
         this.globalStats = new Array();
         this.globalStats[AggregatedStatType.STAT_TYPE_WINS] = true;
         this.globalStats[AggregatedStatType.STAT_TYPE_LOSSES] = true;
         this.globalStats[AggregatedStatType.STAT_TYPE_TOTAL_CHAMPION_KILLS] = true;
         this.globalStats[AggregatedStatType.STAT_TYPE_TOTAL_CHAMPION_DEATHS] = true;
         this.globalStats[AggregatedStatType.TOTAL_ASSISTS] = true;
         this.totalStatsLeft = new Array();
         this.totalStatsLeft[AggregatedStatType.MAX_CHAMPIONS_KILLED] = 1;
         this.totalStatsLeft[AggregatedStatType.TOTAL_TURRETS_KILLED] = 2;
         this.totalStatsLeft[AggregatedStatType.TOTAL_MINION_KILLS] = 3;
         this.totalStatsLeft[AggregatedStatType.TOTAL_NEUTRAL_MINION_KILLS] = 4;
         this.totalStatsLeft[AggregatedStatType.TOTAL_DOUBLE_KILLS] = 5;
         this.totalStatsLeft[AggregatedStatType.TOTAL_TRIPLE_KILLS] = 6;
         this.totalStatsLeft[AggregatedStatType.TOTAL_QUADRA_KILLS] = 7;
         this.totalStatsLeft[AggregatedStatType.TOTAL_PENTA_KILLS] = 8;
         this.totalStatsRight = new Array();
         this.totalStatsRight[AggregatedStatType.MAX_NUM_DEATHS] = 1;
         this.totalStatsRight[AggregatedStatType.HEALTH_RESTORED] = 2;
         this.totalStatsRight[AggregatedStatType.TOTAL_DAMAGE_DEALT] = 3;
         this.totalStatsRight[AggregatedStatType.TOTAL_PHYSICAL_DAMAGE_DEALT] = 4;
         this.totalStatsRight[AggregatedStatType.TOTAL_MAGIC_DAMAGE_DEALT] = 5;
         this.totalStatsRight[AggregatedStatType.LARGEST_CRITICAL_STRIKE] = 6;
         this.totalStatsRight[AggregatedStatType.TOTAL_GOLD_EARNED] = 7;
         this.totalStatsRight[AggregatedStatType.LONGEST_TIME_PLAYED] = 8;
         this.avgStatsLeft = new Array();
         this.avgStatsLeft[AggregatedStatType.TOTAL_TURRETS_KILLED] = 1;
         this.avgStatsLeft[AggregatedStatType.TOTAL_MINION_KILLS] = 2;
         this.avgStatsLeft[AggregatedStatType.TOTAL_NEUTRAL_MINION_KILLS] = 3;
         this.avgStatsLeft[AggregatedStatType.TOTAL_TRIPLE_KILLS] = 4;
         this.avgStatsLeft[AggregatedStatType.TOTAL_PENTA_KILLS] = 5;
         this.avgStatsLeft[AggregatedStatType.TOTAL_DOUBLE_KILLS] = 6;
         this.avgStatsLeft[AggregatedStatType.TOTAL_QUADRA_KILLS] = 7;
         this.avgStatsRight = new Array();
         this.avgStatsRight[AggregatedStatType.HEALTH_RESTORED] = 1;
         this.avgStatsRight[AggregatedStatType.TOTAL_DAMAGE_DEALT] = 2;
         this.avgStatsRight[AggregatedStatType.TOTAL_PHYSICAL_DAMAGE_DEALT] = 3;
         this.avgStatsRight[AggregatedStatType.TOTAL_MAGIC_DAMAGE_DEALT] = 4;
         this.avgStatsRight[AggregatedStatType.TOTAL_GOLD_EARNED] = 5;
         var _loc1_:Sort = new Sort();
         _loc1_.compareFunction = this.comparePriority;
         this.totalLeftColStats.sort = _loc1_;
         this.totalRightColStats.sort = _loc1_;
         this.avgLeftColStats.sort = _loc1_;
         this.avgRightColStats.sort = _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get championId() : Number
      {
         return this._1537709924championId;
      }
      
      public function set championId(param1:Number) : void
      {
         var _loc2_:Object = this._1537709924championId;
         if(_loc2_ !== param1)
         {
            this._1537709924championId = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"championId",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get totalWins() : Number
      {
         return this._577192581totalWins;
      }
      
      public function set totalWins(param1:Number) : void
      {
         var _loc2_:Object = this._577192581totalWins;
         if(_loc2_ !== param1)
         {
            this._577192581totalWins = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"totalWins",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get totalLosses() : Number
      {
         return this._940516491totalLosses;
      }
      
      public function set totalLosses(param1:Number) : void
      {
         var _loc2_:Object = this._940516491totalLosses;
         if(_loc2_ !== param1)
         {
            this._940516491totalLosses = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"totalLosses",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get winRatio() : Number
      {
         return this._1132421745winRatio;
      }
      
      public function set winRatio(param1:Number) : void
      {
         var _loc2_:Object = this._1132421745winRatio;
         if(_loc2_ !== param1)
         {
            this._1132421745winRatio = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"winRatio",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get totalGames() : Number
      {
         return this._728116771totalGames;
      }
      
      public function set totalGames(param1:Number) : void
      {
         var _loc2_:Object = this._728116771totalGames;
         if(_loc2_ !== param1)
         {
            this._728116771totalGames = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"totalGames",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get champion() : Champion
      {
         return this._1431766121champion;
      }
      
      public function set champion(param1:Champion) : void
      {
         var _loc2_:Object = this._1431766121champion;
         if(_loc2_ !== param1)
         {
            this._1431766121champion = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"champion",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get totalKills() : Number
      {
         return this._724185103totalKills;
      }
      
      public function set totalKills(param1:Number) : void
      {
         var _loc2_:Object = this._724185103totalKills;
         if(_loc2_ !== param1)
         {
            this._724185103totalKills = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"totalKills",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get totalDeaths() : Number
      {
         return this._1179320093totalDeaths;
      }
      
      public function set totalDeaths(param1:Number) : void
      {
         var _loc2_:Object = this._1179320093totalDeaths;
         if(_loc2_ !== param1)
         {
            this._1179320093totalDeaths = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"totalDeaths",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get totalAssists() : Number
      {
         return this._149613754totalAssists;
      }
      
      public function set totalAssists(param1:Number) : void
      {
         var _loc2_:Object = this._149613754totalAssists;
         if(_loc2_ !== param1)
         {
            this._149613754totalAssists = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"totalAssists",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get totalLeftColStats() : ArrayCollection
      {
         return this._1358513782totalLeftColStats;
      }
      
      public function set totalLeftColStats(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1358513782totalLeftColStats;
         if(_loc2_ !== param1)
         {
            this._1358513782totalLeftColStats = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"totalLeftColStats",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get totalRightColStats() : ArrayCollection
      {
         return this._1461014615totalRightColStats;
      }
      
      public function set totalRightColStats(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1461014615totalRightColStats;
         if(_loc2_ !== param1)
         {
            this._1461014615totalRightColStats = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"totalRightColStats",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get avgKills() : Number
      {
         return this._1921431843avgKills;
      }
      
      public function set avgKills(param1:Number) : void
      {
         var _loc2_:Object = this._1921431843avgKills;
         if(_loc2_ !== param1)
         {
            this._1921431843avgKills = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"avgKills",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get avgDeaths() : Number
      {
         return this._769573391avgDeaths;
      }
      
      public function set avgDeaths(param1:Number) : void
      {
         var _loc2_:Object = this._769573391avgDeaths;
         if(_loc2_ !== param1)
         {
            this._769573391avgDeaths = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"avgDeaths",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get avgAssists() : Number
      {
         return this._332367880avgAssists;
      }
      
      public function set avgAssists(param1:Number) : void
      {
         var _loc2_:Object = this._332367880avgAssists;
         if(_loc2_ !== param1)
         {
            this._332367880avgAssists = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"avgAssists",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get kdaRatio() : Number
      {
         return this._1086039357kdaRatio;
      }
      
      public function set kdaRatio(param1:Number) : void
      {
         var _loc2_:Object = this._1086039357kdaRatio;
         if(_loc2_ !== param1)
         {
            this._1086039357kdaRatio = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"kdaRatio",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get avgLeftColStats() : ArrayCollection
      {
         return this._2027391976avgLeftColStats;
      }
      
      public function set avgLeftColStats(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._2027391976avgLeftColStats;
         if(_loc2_ !== param1)
         {
            this._2027391976avgLeftColStats = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"avgLeftColStats",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get avgRightColStats() : ArrayCollection
      {
         return this._2094340215avgRightColStats;
      }
      
      public function set avgRightColStats(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._2094340215avgRightColStats;
         if(_loc2_ !== param1)
         {
            this._2094340215avgRightColStats = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"avgRightColStats",_loc2_,param1));
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

