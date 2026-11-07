package com.riotgames.platform.gameclient.kudos
{
   public class KudosTotals
   {
      
      public var totals:Array;
      
      public function KudosTotals()
      {
         super();
      }
      
      public function getTotal(param1:Number) : String
      {
         if(Boolean(this.totals) && Boolean(param1 >= 0) && param1 < this.totals.length)
         {
            return this.totals[param1];
         }
         return "-";
      }
   }
}

