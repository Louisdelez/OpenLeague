package com.riotgames.platform.gameclient.domain
{
   public class OdinSummaryAggStats
   {
      
      public var championsKilled:LifetimeStat;
      
      public var totalPlayerScore:LifetimeStat;
      
      public var nodeNeutralize:LifetimeStat;
      
      public var nodeNeutralizeAssist:LifetimeStat;
      
      public var teamObjective:LifetimeStat;
      
      public var combatPlayerScore:LifetimeStat;
      
      public var nodeCapture:LifetimeStat;
      
      public var numDeaths:LifetimeStat;
      
      public var assists:LifetimeStat;
      
      private var summaryAggStats:SummaryAggStats;
      
      public var nodeCaptureAssist:LifetimeStat;
      
      public var objectivePlayerScore:LifetimeStat;
      
      public function OdinSummaryAggStats(param1:SummaryAggStats)
      {
         super();
         this.summaryAggStats = param1;
         if(Boolean(param1))
         {
            this.nodeCapture = new LifetimeStat(param1.getStatValue(AggregatedStatType.MAX_NODE_CAPTURE),param1.getStatValue(AggregatedStatType.AVERAGE_NODE_CAPTURE));
            this.nodeCapture.total = param1.getStatValue(AggregatedStatType.TOTAL_NODE_CAPTURE);
            this.nodeCaptureAssist = new LifetimeStat(param1.getStatValue(AggregatedStatType.MAX_NODE_CAPTURE_ASSIST),param1.getStatValue(AggregatedStatType.AVERAGE_NODE_CAPTURE_ASSIST));
            this.nodeNeutralize = new LifetimeStat(param1.getStatValue(AggregatedStatType.MAX_NODE_NEUTRALIZE),param1.getStatValue(AggregatedStatType.AVERAGE_NODE_NEUTRALIZE));
            this.nodeNeutralize.total = param1.getStatValue(AggregatedStatType.TOTAL_NODE_NEUTRALIZE);
            this.nodeNeutralizeAssist = new LifetimeStat(param1.getStatValue(AggregatedStatType.MAX_NODE_NEUTRALIZE_ASSIST),param1.getStatValue(AggregatedStatType.AVERAGE_NODE_NEUTRALIZE_ASSIST));
            this.teamObjective = new LifetimeStat(param1.getStatValue(AggregatedStatType.MAX_TEAM_OBJECTIVE),param1.getStatValue(AggregatedStatType.AVERAGE_TEAM_OBJECTIVE));
            this.totalPlayerScore = new LifetimeStat(param1.getStatValue(AggregatedStatType.MAX_TOTAL_PLAYER_SCORE),param1.getStatValue(AggregatedStatType.AVERAGE_TOTAL_PLAYER_SCORE));
            this.combatPlayerScore = new LifetimeStat(param1.getStatValue(AggregatedStatType.MAX_COMBAT_PLAYER_SCORE),param1.getStatValue(AggregatedStatType.AVERAGE_COMBAT_PLAYER_SCORE));
            this.objectivePlayerScore = new LifetimeStat(param1.getStatValue(AggregatedStatType.MAX_OBJECTIVE_PLAYER_SCORE),param1.getStatValue(AggregatedStatType.AVERAGE_OBJECTIVE_PLAYER_SCORE));
            this.assists = new LifetimeStat(param1.getStatValue(AggregatedStatType.MAX_ASSISTS),param1.getStatValue(AggregatedStatType.AVERAGE_ASSISTS));
            this.assists.total = param1.getStatValue(AggregatedStatType.TOTAL_ASSISTS);
            this.numDeaths = new LifetimeStat(param1.getStatValue(AggregatedStatType.MAX_NUM_DEATHS),param1.getStatValue(AggregatedStatType.AVERAGE_NUM_DEATHS));
            this.championsKilled = new LifetimeStat(param1.getStatValue(AggregatedStatType.MAX_CHAMPIONS_KILLED),param1.getStatValue(AggregatedStatType.AVERAGE_CHAMPIONS_KILLED));
            this.championsKilled.total = param1.getStatValue(AggregatedStatType.STAT_TYPE_TOTAL_CHAMPION_KILLS);
         }
      }
      
      public function getTotalPointsCapturedAndNeutralized() : Number
      {
         return this.nodeCapture.total + this.nodeNeutralize.total;
      }
      
      public function getTotalTakedowns() : Number
      {
         return this.championsKilled.total + this.assists.total;
      }
   }
}

