package com.riotgames.platform.gameclient.kudos
{
   public interface IKudosProfileTotalsCache
   {
      
      function cacheKudosTotals(param1:Number, param2:Object) : void;
      
      function clearCache() : void;
      
      function getKudosTotals(param1:Number) : Object;
   }
}

