package com.riotgames.pvpnet.rankedteams.stats
{
   import com.riotgames.platform.gameclient.domain.AggregatedStat;
   import flash.utils.Dictionary;
   
   public class TeamQueuePlayerStats
   {
      
      public var playerId:Number;
      
      public var statsMap:Dictionary = new Dictionary();
      
      public var championsMap:Array = [];
      
      public function TeamQueuePlayerStats()
      {
         super();
      }
      
      public function processStat(param1:AggregatedStat) : void
      {
         var _loc2_:TeamQueuePlayerChampStats = null;
         var _loc3_:AggregatedStat = null;
         if(param1.championId > 0)
         {
            _loc2_ = this.championsMap[param1.championId];
            if(!_loc2_)
            {
               _loc2_ = new TeamQueuePlayerChampStats();
               _loc2_.champId = param1.championId;
               this.championsMap[_loc2_.champId] = _loc2_;
            }
            _loc2_.processStat(param1);
         }
         else
         {
            _loc3_ = this.statsMap[param1.statType];
            if(!_loc3_)
            {
               _loc3_ = param1.duplicate();
               this.statsMap[param1.statType] = _loc3_;
            }
            else
            {
               _loc3_.combine(param1);
            }
         }
      }
      
      public function getStat(param1:String) : AggregatedStat
      {
         return this.statsMap[param1];
      }
      
      public function getStatValue(param1:String) : Number
      {
         var _loc2_:AggregatedStat = this.getStat(param1);
         return Boolean(_loc2_) ? Number(_loc2_.value) : 0;
      }
   }
}

