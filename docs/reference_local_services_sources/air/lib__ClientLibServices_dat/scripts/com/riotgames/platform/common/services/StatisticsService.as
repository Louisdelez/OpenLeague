package com.riotgames.platform.common.services
{
   public interface StatisticsService
   {
      
      function setRatingsForUser(param1:Number, param2:String, param3:Number, param4:Function) : void;
      
      function getSummonerSummaryByInternalName(param1:String, param2:Function, param3:Function) : void;
   }
}

