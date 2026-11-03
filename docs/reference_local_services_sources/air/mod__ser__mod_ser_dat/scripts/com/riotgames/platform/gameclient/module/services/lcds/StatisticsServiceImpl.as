package com.riotgames.platform.gameclient.module.services.lcds
{
   import com.riotgames.platform.common.services.StatisticsService;
   
   public class StatisticsServiceImpl extends BaseLcdsService implements StatisticsService
   {
      
      public function StatisticsServiceImpl()
      {
         super();
      }
      
      public function getSummonerSummaryByInternalName(param1:String, param2:Function, param3:Function) : void
      {
         invokeServiceWithoutSession("statisticsService","getSummonerSummaryByInternalName",[param1],param2,param3);
      }
      
      public function setRatingsForUser(param1:Number, param2:String, param3:Number, param4:Function) : void
      {
         invokeServiceWithoutSession("statisticsService","altSetUserRatings",[param1,param2,param3],param4,null);
      }
   }
}

