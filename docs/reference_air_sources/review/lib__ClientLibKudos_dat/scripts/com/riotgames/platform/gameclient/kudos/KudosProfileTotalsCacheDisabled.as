package com.riotgames.platform.gameclient.kudos
{
   public class KudosProfileTotalsCacheDisabled implements IKudosProfileTotalsCache
   {
      
      public function KudosProfileTotalsCacheDisabled()
      {
         super();
      }
      
      public function cacheKudosTotals(param1:Number, param2:Object) : void
      {
      }
      
      public function getKudosTotals(param1:Number) : Object
      {
         return null;
      }
      
      public function clearCache() : void
      {
      }
   }
}

