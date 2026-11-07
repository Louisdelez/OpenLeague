package com.riotgames.platform.gameclient.module.services.lcds
{
   import com.riotgames.platform.gameclient.services.SummonerIconService;
   
   public class SummonerIconServiceImpl extends BaseLcdsService implements SummonerIconService
   {
      
      public function SummonerIconServiceImpl()
      {
         super();
      }
      
      public function getSummonerIconInventory(param1:Number, param2:Function, param3:Function = null) : void
      {
         invokeServiceWithoutSession("summonerIconService","getSummonerIconInventory",[param1],param2,param3);
      }
   }
}

