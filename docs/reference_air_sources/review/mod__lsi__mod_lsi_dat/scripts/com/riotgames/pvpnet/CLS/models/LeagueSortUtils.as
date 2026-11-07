package com.riotgames.pvpnet.CLS.models
{
   public class LeagueSortUtils
   {
      
      public function LeagueSortUtils()
      {
         super();
      }
      
      public static function sortLeagueItemsHighestToLowest(param1:ListItemObjectModel, param2:ListItemObjectModel) : int
      {
         if(Boolean(param1.miniSeriesResults) && Boolean(param2.miniSeriesResults))
         {
            if(param1.miniSeriesResults.length > 0 || param2.miniSeriesResults.length > 0)
            {
               if(param1.miniSeriesResults.length != param2.miniSeriesResults.length)
               {
                  return param2.miniSeriesResults.length - param1.miniSeriesResults.length;
               }
               if(param1.miniSeriesWins != param2.miniSeriesWins)
               {
                  return param2.miniSeriesWins - param1.miniSeriesWins;
               }
               if(param1.miniSeriesLosses != param2.miniSeriesLosses)
               {
                  return param1.miniSeriesLosses - param2.miniSeriesLosses;
               }
            }
         }
         if(param1.apexPendingPromotion && !param2.apexPendingPromotion)
         {
            return -1;
         }
         if(!param1.apexPendingPromotion && param2.apexPendingPromotion)
         {
            return 1;
         }
         if(!param1.apexPendingDemotion && param2.apexPendingDemotion)
         {
            return -1;
         }
         if(param1.apexPendingDemotion && !param2.apexPendingDemotion)
         {
            return 1;
         }
         if(param1.points != param2.points)
         {
            return param2.points - param1.points;
         }
         if(param1.tier.isBelow(param2.tier))
         {
            return 1;
         }
         if(param2.tier.isBelow(param1.tier))
         {
            return -1;
         }
         if(param1.wins != param2.wins)
         {
            return param2.wins - param1.wins;
         }
         if(param1.losses != param2.losses)
         {
            return param1.losses - param2.losses;
         }
         return param1.id - param2.id;
      }
   }
}

