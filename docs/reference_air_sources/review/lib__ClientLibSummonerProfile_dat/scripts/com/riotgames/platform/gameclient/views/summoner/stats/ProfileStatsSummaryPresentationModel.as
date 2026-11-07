package com.riotgames.platform.gameclient.views.summoner.stats
{
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.gameclient.domain.ARAMSummaryAggStats;
   import com.riotgames.platform.gameclient.domain.ClassicSummaryAggStats;
   import com.riotgames.platform.gameclient.domain.OdinSummaryAggStats;
   import com.riotgames.platform.gameclient.domain.PlayerStatSummaries;
   import com.riotgames.platform.gameclient.domain.PlayerStatSummary;
   import com.riotgames.platform.gameclient.domain.game.QueueType;
   import com.riotgames.pvpnet.system.leagues.ProfileUtils;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.Dictionary;
   import mx.events.PropertyChangeEvent;
   
   public class ProfileStatsSummaryPresentationModel implements IEventDispatcher
   {
      
      public var chatController:ChatController;
      
      public var totalRankedWins:uint = 0;
      
      public var totalRankedLosses:uint = 0;
      
      public var totalRankedLeaves:uint = 0;
      
      public var totalNormalClassicWins:uint = 0;
      
      public var totalNormalDominionWins:uint = 0;
      
      public var totalNormalARAMWins:uint = 0;
      
      public var totalClassicTakedowns:uint = 0;
      
      public var totalDominionTakedowns:uint = 0;
      
      public var totalARAMTakedowns:uint = 0;
      
      public var totalCreepsAndMinionsKilled:uint = 0;
      
      public var totalPointsCapturedAndNeutralized:uint = 0;
      
      public var totalARAMTowersDestroyed:uint = 0;
      
      public var rankedQueueStatSummaries:Dictionary;
      
      public var rankedQueueStatsLookupDic:Dictionary;
      
      public var normalClassicQueueSummaryTypes:Array = [QueueType.NORMAL,QueueType.NORMAL_3x3,QueueType.CAP5x5,QueueType.CAP1x1];
      
      private var _1914417246showStats:Boolean = false;
      
      private var _1111712580isSeededToLeague:Boolean = false;
      
      private var statSummary:PlayerStatSummaries;
      
      private var localSummoner:Boolean;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function ProfileStatsSummaryPresentationModel()
      {
         super();
         this.rankedQueueStatsLookupDic = new Dictionary();
         this.rankedQueueStatsLookupDic[QueueType.RANKED_PREMADE_3x3] = 0;
         this.rankedQueueStatsLookupDic[QueueType.RANKED_SOLO_5x5] = 0;
         this.rankedQueueStatsLookupDic[QueueType.RANKED_PREMADE_5x5] = 0;
         this.rankedQueueStatsLookupDic[QueueType.RANKED_TEAM_3x3] = 0;
         this.rankedQueueStatsLookupDic[QueueType.RANKED_TEAM_5x5] = 0;
         this.rankedQueueStatSummaries = new Dictionary();
         this.rankedQueueStatSummaries[QueueType.RANKED_PREMADE_3x3] = new PlayerStatSummary();
         this.rankedQueueStatSummaries[QueueType.RANKED_SOLO_5x5] = new PlayerStatSummary();
         this.rankedQueueStatSummaries[QueueType.RANKED_PREMADE_5x5] = new PlayerStatSummary();
      }
      
      public function isLocalSummoner() : Boolean
      {
         return this.localSummoner;
      }
      
      public function setStats(param1:PlayerStatSummaries, param2:Boolean, param3:String) : void
      {
         var _loc4_:Boolean = false;
         this.localSummoner = param2;
         if(param1 == null)
         {
            this.showStats = false;
         }
         else
         {
            _loc4_ = false;
            this.clear();
            if(!param2 && param3 != null && param3 != "" && Boolean(this.chatController))
            {
               _loc4_ = Boolean(this.chatController.isSummonerBuddy(param3,true));
            }
            this.statSummary = param1;
            this.parseStats();
            if(param2 || _loc4_)
            {
               this.showStats = this.totalRankedWins > 0 || this.totalRankedLosses > 0;
            }
            else
            {
               this.showStats = this.isSeededToLeague;
            }
         }
      }
      
      private function clear() : void
      {
         var _loc1_:String = null;
         for(_loc1_ in this.rankedQueueStatsLookupDic)
         {
            this.rankedQueueStatsLookupDic[_loc1_] = 0;
            this.rankedQueueStatSummaries[_loc1_] = new PlayerStatSummary();
         }
         this.totalRankedWins = 0;
         this.totalRankedLosses = 0;
         this.totalRankedLeaves = 0;
         this.totalNormalClassicWins = 0;
         this.totalNormalDominionWins = 0;
         this.totalNormalARAMWins = 0;
         this.totalClassicTakedowns = 0;
         this.totalDominionTakedowns = 0;
         this.totalARAMTakedowns = 0;
         this.totalCreepsAndMinionsKilled = 0;
         this.totalPointsCapturedAndNeutralized = 0;
         this.totalARAMTowersDestroyed = 0;
         this.showStats = false;
         this.statSummary = null;
         this.isSeededToLeague = false;
      }
      
      private function parseStats() : void
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:PlayerStatSummary = null;
         var _loc5_:PlayerStatSummary = null;
         var _loc6_:PlayerStatSummary = null;
         var _loc7_:* = undefined;
         var _loc8_:OdinSummaryAggStats = null;
         var _loc9_:ARAMSummaryAggStats = null;
         this.totalNormalClassicWins = 0;
         this.totalRankedWins = 0;
         this.totalRankedLosses = 0;
         this.totalRankedLeaves = 0;
         this.totalClassicTakedowns = 0;
         this.totalCreepsAndMinionsKilled = 0;
         if(this.statSummary == null)
         {
            this.isSeededToLeague = false;
            return;
         }
         for(_loc1_ in this.rankedQueueStatsLookupDic)
         {
            _loc5_ = this.statSummary.getPlayerStatSummary(_loc1_);
            if(_loc5_ != null)
            {
               this.rankedQueueStatsLookupDic[_loc1_] = _loc5_.rating;
               this.rankedQueueStatSummaries[_loc1_] = _loc5_;
               if(_loc5_.wins + _loc5_.losses >= ProfileUtils.MIN_RANKED_GAMES_FOR_RANKING)
               {
                  this.isSeededToLeague = true;
               }
               this.totalRankedWins += _loc5_.wins;
               this.totalRankedLosses += _loc5_.losses;
            }
         }
         for each(_loc2_ in this.normalClassicQueueSummaryTypes)
         {
            _loc6_ = this.statSummary.getPlayerStatSummary(_loc2_);
            if(Boolean(_loc6_))
            {
               this.totalNormalClassicWins += _loc6_.wins;
               _loc7_ = new ClassicSummaryAggStats(_loc6_.aggregatedStats);
               this.totalClassicTakedowns += _loc7_.getTotalTakedowns();
               this.totalCreepsAndMinionsKilled += _loc7_.getTotalCreepsAndMinionsKilled();
            }
         }
         _loc3_ = this.statSummary.getPlayerStatSummary(QueueType.DOMINION_UNRANKED);
         if(Boolean(_loc3_))
         {
            this.totalNormalDominionWins = _loc3_.wins;
            _loc8_ = new OdinSummaryAggStats(_loc3_.aggregatedStats);
            this.totalDominionTakedowns = _loc8_.getTotalTakedowns();
            this.totalPointsCapturedAndNeutralized = _loc8_.getTotalPointsCapturedAndNeutralized();
         }
         var _loc4_:PlayerStatSummary = this.statSummary.getPlayerStatSummary(QueueType.ARAM_UNRANKED_5x5);
         if(Boolean(_loc4_))
         {
            this.totalNormalARAMWins = _loc4_.wins;
            _loc9_ = new ARAMSummaryAggStats(_loc4_.aggregatedStats);
            this.totalARAMTakedowns = _loc9_.getTotalTakedowns();
            this.totalARAMTowersDestroyed = _loc9_.getTotalTowersDestroyed();
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get showStats() : Boolean
      {
         return this._1914417246showStats;
      }
      
      public function set showStats(param1:Boolean) : void
      {
         var _loc2_:Object = this._1914417246showStats;
         if(_loc2_ !== param1)
         {
            this._1914417246showStats = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"showStats",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get isSeededToLeague() : Boolean
      {
         return this._1111712580isSeededToLeague;
      }
      
      public function set isSeededToLeague(param1:Boolean) : void
      {
         var _loc2_:Object = this._1111712580isSeededToLeague;
         if(_loc2_ !== param1)
         {
            this._1111712580isSeededToLeague = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isSeededToLeague",_loc2_,param1));
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

