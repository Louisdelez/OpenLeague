package com.riotgames.platform.gameclient.domain
{
   public class ClassicSummaryAggStats
   {
      
      public var buildingKills:Number;
      
      private var summaryAggStats:SummaryAggStats;
      
      public var neutralKills:Number;
      
      public var assists:Number;
      
      public var kills:Number;
      
      public var minionsKilled:Number;
      
      public function ClassicSummaryAggStats(param1:SummaryAggStats)
      {
         super();
         this.summaryAggStats = param1;
         if(Boolean(param1))
         {
            this.buildingKills = param1.getStatValue(AggregatedStatType.TOTAL_TURRETS_KILLED);
            this.minionsKilled = param1.getStatValue(AggregatedStatType.TOTAL_MINION_KILLS);
            this.neutralKills = param1.getStatValue(AggregatedStatType.TOTAL_NEUTRAL_MINION_KILLS);
            this.assists = param1.getStatValue(AggregatedStatType.TOTAL_ASSISTS);
            this.kills = param1.getStatValue(AggregatedStatType.STAT_TYPE_TOTAL_CHAMPION_KILLS);
         }
      }
      
      public function getTotalTakedowns() : Number
      {
         return this.kills + this.assists + this.buildingKills;
      }
      
      public function getTotalCreepsAndMinionsKilled() : Number
      {
         return this.minionsKilled + this.neutralKills;
      }
   }
}

