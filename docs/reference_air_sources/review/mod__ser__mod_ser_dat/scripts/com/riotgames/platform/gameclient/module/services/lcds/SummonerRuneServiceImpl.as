package com.riotgames.platform.gameclient.module.services.lcds
{
   import com.riotgames.platform.gameclient.services.SummonerRuneService;
   
   public class SummonerRuneServiceImpl extends BaseLcdsService implements SummonerRuneService
   {
      
      public function SummonerRuneServiceImpl()
      {
         super();
      }
      
      public function getSummonerRunes(param1:Number, param2:Function, param3:Function, param4:Function) : void
      {
         invokeServiceWithoutSession("summonerRuneService","getSummonerRunes",[param1],param2,param3);
      }
      
      public function getSummonerRuneInventory(param1:Number, param2:Function, param3:Function, param4:Function) : void
      {
         invokeServiceWithoutSession("summonerRuneService","getSummonerRuneInventory",[param1],param2,param3);
      }
   }
}

