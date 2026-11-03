package com.riotgames.pvpnet.CLS.models
{
   public class ChampionSummaryStatsData
   {
      
      public var kills:Number = 0;
      
      public var deaths:Number = 0;
      
      public var assists:Number = 0;
      
      public var wins:Number = 0;
      
      public var totalGames:Number = 0;
      
      public var championId:Number;
      
      public var totalGold:Number = 0;
      
      public var kda:Number = 0;
      
      public var totalTime:Number = 0;
      
      public var goldPerMin:Number = 0;
      
      public function ChampionSummaryStatsData()
      {
         super();
      }
      
      public function getKDARatio() : Number
      {
         if(this.deaths < 1)
         {
            this.kda = this.kills + this.assists;
         }
         else
         {
            this.kda = (this.kills + this.assists) / this.deaths;
         }
         return this.kda;
      }
      
      public function getGoldPerMin() : Number
      {
         if(this.totalTime < 0.001)
         {
            this.goldPerMin = 0;
         }
         else
         {
            this.goldPerMin = this.totalGold / this.totalTime;
         }
         return this.goldPerMin;
      }
   }
}

