package com.riotgames.platform.gameclient.module.rt.model
{
   import blix.signals.Signal;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.gameclient.domain.AggregatedStatType;
   import com.riotgames.platform.gameclient.domain.rankedTeams.PlayerAggregatedStats;
   import com.riotgames.platform.gameclient.domain.rankedTeams.Team;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamAggregatedStats;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamStatDetail;
   import com.riotgames.platform.gameclient.module.rt.RTFacade;
   import com.riotgames.platform.gameclient.module.rt.controller.RTShowServiceError;
   import com.riotgames.pvpnet.rankedteams.stats.TeamQueuePlayerChampStats;
   import com.riotgames.pvpnet.rankedteams.stats.TeamQueueStats;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import flash.utils.Dictionary;
   import mx.collections.ArrayCollection;
   import mx.rpc.events.ResultEvent;
   
   public class TeamStatsProxy
   {
      
      public static const CHAMP_HIGHEST_WIN_RATIO:String = "highestWinRatio";
      
      public static const CHAMP_HIGHEST_AVERAGE_KILLS:String = "highestAverageKills";
      
      public static const CHAMP_HIGHEST_AVERAGE_GOLD:String = "highestAverageGold";
      
      public static const CHAMP_HIGHEST_AVERAGE_ASSISTS:String = "highestAverageAssists";
      
      public static const CHAMP_LOWEST_AVERAGE_DEATHS:String = "lowestAverageDeaths";
      
      public static const CHAMP_HIGHEST_AVERAGE_MINIONS_KILLED:String = "highestAverageMinionsKilled";
      
      public static const CHAMP_HIGHEST_AVERAGE_DAMAGE_DEALT:String = "highestAverageDamageDealt";
      
      public static const CHAMP_HIGHEST_AVERAGE_MULTI_KILLS:String = "highestAverageMultiKills";
      
      public static const CHAMP_MAX_KILLING_SPREE:String = "maxKillingSpree";
      
      public static const CHAMP_MAX_CRIT:String = "maxCrit";
      
      public static const CHAMP_HIGHEST_AVERAGE_DAMAGE_TAKEN:String = "highestAverageDamageTaken";
      
      public static const CHAMP_LOWEST_AVERAGE_DAMAGE_TAKEN:String = "lowestAverageDamageTaken";
      
      public static const CHAMP_HIGHEST_AVERAGE_BUILDINGS_DESTROYED:String = "highestAverageBuildingsDestroyed";
      
      public static const CHAMP_HIGHEST_AVERAGE_HEALING:String = "highestAverageHealing";
      
      public static const CHAMP_HIGHEST_AVERAGE_PHYSICAL_DAMAGE_DEALT:String = "highestAveragePhysicalDamageDealt";
      
      public static const CHAMP_HIGHEST_AVERAGE_MAGIC_DAMAGE_DEALT:String = "highestAverageMagicDamageDealt";
      
      public static const CHAMP_MOST_WINS:String = "mostWins";
      
      public static const CHAMP_MOST_KILLS:String = "mostKills";
      
      public static const CHAMP_MOST_GOLD:String = "mostGold";
      
      public static const CHAMP_MOST_ASSISTS:String = "mostAssists";
      
      public static const CHAMP_MOST_MINIONS_KILLED:String = "mostMinionsKilled";
      
      public static const CHAMP_MOST_DAMAGE_DEALT:String = "mostDamageDealt";
      
      public static const CHAMP_MOST_MULTI_KILLS:String = "mostMultiKills";
      
      public static const CHAMP_MOST_DAMAGE_TAKEN:String = "mostDamageTaken";
      
      public static const CHAMP_MOST_BUILDINGS_DESTROYED:String = "mostBuildingsDestroyed";
      
      public static const CHAMP_MOST_HEALING:String = "mostHealing";
      
      public static const CHAMP_MOST_PHYSICAL_DAMAGE_DEALT:String = "mostPhysicalDamageDealt";
      
      public static const CHAMP_MOST_MAGIC_DAMAGE_DEALT:String = "mostMagicDamageDealt";
      
      private var associatedTeam:Team;
      
      private var processedStats:Dictionary;
      
      public var statsChanged:Signal = new Signal();
      
      private var rawStats:ArrayCollection;
      
      public function TeamStatsProxy()
      {
         super();
      }
      
      private static function compileMin(param1:Object, param2:Number, param3:Number) : void
      {
         if(param1.value == null || param1.value > param2)
         {
            param1.value = param2;
            param1.champ = param3;
         }
      }
      
      private static function compileMax(param1:Object, param2:Number, param3:Number) : void
      {
         if(param2 > 0 && (param1.value == null || param1.value < param2))
         {
            param1.value = param2;
            param1.champ = param3;
         }
      }
      
      public static function computeChampionCallouts(param1:Array) : Dictionary
      {
         var _loc3_:TeamQueuePlayerChampStats = null;
         var _loc4_:Number = NaN;
         var _loc5_:int = 0;
         var _loc2_:Dictionary = new Dictionary();
         _loc2_[CHAMP_HIGHEST_WIN_RATIO] = {
            "value":null,
            "champ":null
         };
         _loc2_[CHAMP_HIGHEST_AVERAGE_KILLS] = {
            "value":null,
            "champ":null
         };
         _loc2_[CHAMP_HIGHEST_AVERAGE_GOLD] = {
            "value":null,
            "champ":null
         };
         _loc2_[CHAMP_HIGHEST_AVERAGE_ASSISTS] = {
            "value":null,
            "champ":null
         };
         _loc2_[CHAMP_LOWEST_AVERAGE_DEATHS] = {
            "value":null,
            "champ":null
         };
         _loc2_[CHAMP_HIGHEST_AVERAGE_MINIONS_KILLED] = {
            "value":null,
            "champ":null
         };
         _loc2_[CHAMP_HIGHEST_AVERAGE_DAMAGE_DEALT] = {
            "value":null,
            "champ":null
         };
         _loc2_[CHAMP_HIGHEST_AVERAGE_MULTI_KILLS] = {
            "value":null,
            "champ":null
         };
         _loc2_[CHAMP_MAX_KILLING_SPREE] = {
            "value":null,
            "champ":null
         };
         _loc2_[CHAMP_MAX_CRIT] = {
            "value":null,
            "champ":null
         };
         _loc2_[CHAMP_HIGHEST_AVERAGE_DAMAGE_TAKEN] = {
            "value":null,
            "champ":null
         };
         _loc2_[CHAMP_LOWEST_AVERAGE_DAMAGE_TAKEN] = {
            "value":null,
            "champ":null
         };
         _loc2_[CHAMP_HIGHEST_AVERAGE_BUILDINGS_DESTROYED] = {
            "value":null,
            "champ":null
         };
         _loc2_[CHAMP_HIGHEST_AVERAGE_HEALING] = {
            "value":null,
            "champ":null
         };
         _loc2_[CHAMP_HIGHEST_AVERAGE_PHYSICAL_DAMAGE_DEALT] = {
            "value":null,
            "champ":null
         };
         _loc2_[CHAMP_HIGHEST_AVERAGE_MAGIC_DAMAGE_DEALT] = {
            "value":null,
            "champ":null
         };
         _loc2_[CHAMP_MOST_WINS] = {
            "value":null,
            "champ":null
         };
         _loc2_[CHAMP_MOST_KILLS] = {
            "value":null,
            "champ":null
         };
         _loc2_[CHAMP_MOST_GOLD] = {
            "value":null,
            "champ":null
         };
         _loc2_[CHAMP_MOST_ASSISTS] = {
            "value":null,
            "champ":null
         };
         _loc2_[CHAMP_MOST_MINIONS_KILLED] = {
            "value":null,
            "champ":null
         };
         _loc2_[CHAMP_MOST_DAMAGE_DEALT] = {
            "value":null,
            "champ":null
         };
         _loc2_[CHAMP_MOST_MULTI_KILLS] = {
            "value":null,
            "champ":null
         };
         _loc2_[CHAMP_MOST_DAMAGE_TAKEN] = {
            "value":null,
            "champ":null
         };
         _loc2_[CHAMP_MOST_BUILDINGS_DESTROYED] = {
            "value":null,
            "champ":null
         };
         _loc2_[CHAMP_MOST_HEALING] = {
            "value":null,
            "champ":null
         };
         _loc2_[CHAMP_MOST_PHYSICAL_DAMAGE_DEALT] = {
            "value":null,
            "champ":null
         };
         _loc2_[CHAMP_MOST_MAGIC_DAMAGE_DEALT] = {
            "value":null,
            "champ":null
         };
         for each(_loc3_ in param1)
         {
            _loc4_ = Number(_loc3_.getGamesPlayed());
            compileMax(_loc2_[CHAMP_HIGHEST_WIN_RATIO],_loc3_.getStatValue(AggregatedStatType.STAT_TYPE_WINS) / _loc4_,_loc3_.champId);
            compileMax(_loc2_[CHAMP_HIGHEST_AVERAGE_KILLS],_loc3_.getStatValue(AggregatedStatType.STAT_TYPE_TOTAL_CHAMPION_KILLS) / _loc4_,_loc3_.champId);
            compileMax(_loc2_[CHAMP_HIGHEST_AVERAGE_GOLD],_loc3_.getStatValue(AggregatedStatType.TOTAL_GOLD_EARNED) / _loc4_,_loc3_.champId);
            compileMax(_loc2_[CHAMP_HIGHEST_AVERAGE_ASSISTS],_loc3_.getStatValue(AggregatedStatType.TOTAL_ASSISTS) / _loc4_,_loc3_.champId);
            compileMin(_loc2_[CHAMP_LOWEST_AVERAGE_DEATHS],_loc3_.getStatValue(AggregatedStatType.STAT_TYPE_TOTAL_CHAMPION_DEATHS) / _loc4_,_loc3_.champId);
            compileMax(_loc2_[CHAMP_HIGHEST_AVERAGE_MINIONS_KILLED],_loc3_.getStatValue(AggregatedStatType.TOTAL_MINION_KILLS) / _loc4_,_loc3_.champId);
            compileMax(_loc2_[CHAMP_HIGHEST_AVERAGE_DAMAGE_DEALT],_loc3_.getStatValue(AggregatedStatType.TOTAL_DAMAGE_DEALT) / _loc4_,_loc3_.champId);
            _loc5_ = int(_loc3_.getStatValue(AggregatedStatType.TOTAL_DOUBLE_KILLS));
            compileMax(_loc2_[CHAMP_HIGHEST_AVERAGE_MULTI_KILLS],_loc5_ / _loc4_,_loc3_.champId);
            compileMax(_loc2_[CHAMP_MAX_KILLING_SPREE],_loc3_.getStatValue(AggregatedStatType.LARGEST_KILLING_SPREE),_loc3_.champId);
            compileMax(_loc2_[CHAMP_MAX_CRIT],_loc3_.getStatValue(AggregatedStatType.LARGEST_CRITICAL_STRIKE),_loc3_.champId);
            compileMax(_loc2_[CHAMP_HIGHEST_AVERAGE_DAMAGE_TAKEN],_loc3_.getStatValue(AggregatedStatType.TOTAL_DAMAGE_TAKEN) / _loc4_,_loc3_.champId);
            compileMin(_loc2_[CHAMP_LOWEST_AVERAGE_DAMAGE_TAKEN],_loc3_.getStatValue(AggregatedStatType.TOTAL_DAMAGE_TAKEN) / _loc4_,_loc3_.champId);
            compileMax(_loc2_[CHAMP_HIGHEST_AVERAGE_BUILDINGS_DESTROYED],_loc3_.getStatValue(AggregatedStatType.TOTAL_TURRETS_KILLED) / _loc4_,_loc3_.champId);
            compileMax(_loc2_[CHAMP_HIGHEST_AVERAGE_HEALING],_loc3_.getStatValue(AggregatedStatType.HEALTH_RESTORED) / _loc4_,_loc3_.champId);
            compileMax(_loc2_[CHAMP_HIGHEST_AVERAGE_PHYSICAL_DAMAGE_DEALT],_loc3_.getStatValue(AggregatedStatType.TOTAL_PHYSICAL_DAMAGE_DEALT) / _loc4_,_loc3_.champId);
            compileMax(_loc2_[CHAMP_HIGHEST_AVERAGE_MAGIC_DAMAGE_DEALT],_loc3_.getStatValue(AggregatedStatType.TOTAL_MAGIC_DAMAGE_DEALT) / _loc4_,_loc3_.champId);
            compileMax(_loc2_[CHAMP_MOST_WINS],_loc3_.getStatValue(AggregatedStatType.STAT_TYPE_WINS),_loc3_.champId);
            compileMax(_loc2_[CHAMP_MOST_KILLS],_loc3_.getStatValue(AggregatedStatType.STAT_TYPE_TOTAL_CHAMPION_KILLS),_loc3_.champId);
            compileMax(_loc2_[CHAMP_MOST_GOLD],_loc3_.getStatValue(AggregatedStatType.TOTAL_GOLD_EARNED),_loc3_.champId);
            compileMax(_loc2_[CHAMP_MOST_ASSISTS],_loc3_.getStatValue(AggregatedStatType.TOTAL_ASSISTS),_loc3_.champId);
            compileMax(_loc2_[CHAMP_MOST_MINIONS_KILLED],_loc3_.getStatValue(AggregatedStatType.TOTAL_MINION_KILLS),_loc3_.champId);
            compileMax(_loc2_[CHAMP_MOST_DAMAGE_DEALT],_loc3_.getStatValue(AggregatedStatType.TOTAL_DAMAGE_DEALT),_loc3_.champId);
            compileMax(_loc2_[CHAMP_MOST_MULTI_KILLS],_loc5_,_loc3_.champId);
            compileMax(_loc2_[CHAMP_MOST_DAMAGE_TAKEN],_loc3_.getStatValue(AggregatedStatType.TOTAL_DAMAGE_TAKEN),_loc3_.champId);
            compileMax(_loc2_[CHAMP_MOST_BUILDINGS_DESTROYED],_loc3_.getStatValue(AggregatedStatType.TOTAL_TURRETS_KILLED),_loc3_.champId);
            compileMax(_loc2_[CHAMP_MOST_HEALING],_loc3_.getStatValue(AggregatedStatType.HEALTH_RESTORED),_loc3_.champId);
            compileMax(_loc2_[CHAMP_MOST_PHYSICAL_DAMAGE_DEALT],_loc3_.getStatValue(AggregatedStatType.TOTAL_PHYSICAL_DAMAGE_DEALT),_loc3_.champId);
            compileMax(_loc2_[CHAMP_MOST_MAGIC_DAMAGE_DEALT],_loc3_.getStatValue(AggregatedStatType.TOTAL_MAGIC_DAMAGE_DEALT),_loc3_.champId);
         }
         return _loc2_;
      }
      
      private function get serviceStateProxy() : ServiceStateProxy
      {
         return RTFacade.instance.retrieveProxy(ServiceStateProxy.NAME) as ServiceStateProxy;
      }
      
      public function retrieveStats(param1:Team) : void
      {
         this.associatedTeam = param1;
         if(param1)
         {
            RTFacade.instance.rtProvider.serviceProxy.playerStatsService.getTeamAggregatedStats(param1.teamId,this.onGotStats,this.onComplete,this.onError);
         }
         else
         {
            this.resetStats();
         }
      }
      
      private function processStats() : void
      {
         var _loc2_:TeamAggregatedStats = null;
         var _loc3_:TeamQueueStats = null;
         var _loc4_:ArrayCollection = null;
         var _loc5_:PlayerAggregatedStats = null;
         var _loc6_:TeamStatDetail = null;
         if(!this.rawStats || !this.associatedTeam)
         {
            this.processedStats = null;
            return;
         }
         this.processedStats = new Dictionary();
         var _loc1_:TeamQueueStats = new TeamQueueStats();
         _loc1_.queueId = TeamQueueStats.ALL;
         this.processedStats[_loc1_.queueId] = _loc1_;
         for each(_loc2_ in this.rawStats)
         {
            _loc3_ = new TeamQueueStats();
            if(ClientConfig.instance.leagueServiceEnabled)
            {
               _loc3_.isLeague = true;
               _loc3_.league = ServiceProxy.instance.leagueService.cache.getLeagueDataFromTeamCache(this.associatedTeam.name,_loc2_.queueType);
               _loc3_.leaguePoints = ServiceProxy.instance.leagueService.cache.getLeaguePointsFromTeamCache(this.associatedTeam.name,_loc2_.queueType);
            }
            _loc3_.teamName = this.associatedTeam.name;
            _loc3_.queueId = _loc2_.queueType;
            this.processedStats[_loc3_.queueId] = _loc3_;
            _loc4_ = this.associatedTeam.teamStatSummary ? this.associatedTeam.teamStatSummary.teamStatDetails : null;
            if(_loc4_)
            {
               for each(_loc6_ in _loc4_)
               {
                  if(_loc6_.teamStatType == _loc3_.queueId)
                  {
                     _loc3_.wins = _loc6_.wins;
                     _loc3_.losses = _loc6_.losses;
                     _loc3_.isRanked = _loc6_.getIsRanked();
                     _loc1_.wins += _loc6_.wins;
                     _loc1_.losses += _loc6_.losses;
                     _loc1_.isRanked = Boolean(_loc1_.isRanked) || Boolean(_loc6_.getIsRanked());
                  }
               }
            }
            if(ClientConfig.instance.leagueServiceEnabled)
            {
               _loc1_.isLeague = true;
               _loc1_.league = ServiceProxy.instance.leagueService.cache.getLeagueDataFromTeamCache(this.associatedTeam.name);
               _loc1_.leaguePoints = ServiceProxy.instance.leagueService.cache.getLeaguePointsFromTeamCache(this.associatedTeam.name);
            }
            for each(_loc5_ in _loc2_.playerAggregatedStatsList)
            {
               _loc3_.processPlayerStats(_loc5_);
               _loc1_.processPlayerStats(_loc5_);
            }
         }
      }
      
      private function onError(param1:Object) : void
      {
         RTFacade.instance.sendNotification(RTShowServiceError.SHOW_ERROR,param1);
      }
      
      public function injectStats(param1:ArrayCollection, param2:Team) : void
      {
         this.associatedTeam = param2;
         this.rawStats = param1;
         this.processStats();
         this.statsChanged.dispatch(this.processedStats);
      }
      
      public function resetStats() : void
      {
         this.rawStats = null;
         this.processedStats = null;
         this.statsChanged.dispatch(this.processedStats);
      }
      
      private function onGotStats(param1:ResultEvent) : void
      {
         if(param1.result is ArrayCollection)
         {
            this.rawStats = param1.result as ArrayCollection;
         }
         else
         {
            this.rawStats = null;
         }
         this.processStats();
         this.statsChanged.dispatch(this.processedStats);
      }
      
      private function onComplete(param1:Object) : void
      {
         this.serviceStateProxy.onServiceCallComplete();
      }
      
      public function get stats() : Dictionary
      {
         return this.processedStats;
      }
   }
}

