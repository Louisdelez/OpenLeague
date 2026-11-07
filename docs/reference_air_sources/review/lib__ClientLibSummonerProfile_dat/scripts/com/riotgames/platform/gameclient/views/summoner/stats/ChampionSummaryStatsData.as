package com.riotgames.platform.gameclient.views.summoner.stats
{
   public class ChampionSummaryStatsData
   {
      
      public var kills:Number = 0;
      
      public var deaths:Number = 0;
      
      public var assists:Number = 0;
      
      public var wins:Number = 0;
      
      public var totalGames:Number = 0;
      
      public var championId:Number;
      
      public function ChampionSummaryStatsData()
      {
         super();
      }
      
      public function getKDARatio() : Number
      {
         var _loc1_:Number = this.deaths <= 0 ? 1 : this.deaths;
         return (this.kills + this.assists) / _loc1_;
      }
   }
}

