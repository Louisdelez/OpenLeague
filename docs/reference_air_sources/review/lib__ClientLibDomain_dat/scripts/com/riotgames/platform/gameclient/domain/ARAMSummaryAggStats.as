package com.riotgames.platform.gameclient.domain
{
   public class ARAMSummaryAggStats
   {
      
      public var buildingKills:Number;
      
      public var kills:Number;
      
      public var assists:Number;
      
      private var summaryAggStats:SummaryAggStats;
      
      public function ARAMSummaryAggStats(param1:SummaryAggStats)
      {
         super();
         this.summaryAggStats = param1;
         if(Boolean(param1))
         {
            this.buildingKills = param1.getStatValue(AggregatedStatType.TOTAL_TURRETS_KILLED);
            this.assists = param1.getStatValue(AggregatedStatType.TOTAL_ASSISTS);
            this.kills = param1.getStatValue(AggregatedStatType.STAT_TYPE_TOTAL_CHAMPION_KILLS);
         }
      }
      
      public function getTotalTowersDestroyed() : Number
      {
         return this.buildingKills;
      }
      
      public function getTotalTakedowns() : Number
      {
         return this.kills + this.assists;
      }
   }
}

