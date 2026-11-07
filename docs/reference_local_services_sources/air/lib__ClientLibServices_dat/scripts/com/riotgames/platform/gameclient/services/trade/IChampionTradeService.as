package com.riotgames.platform.gameclient.services.trade
{
   public interface IChampionTradeService
   {
      
      function dismissTrade(param1:Function, param2:Function, param3:Function) : void;
      
      function getPotentialTraders(param1:Function, param2:Function, param3:Function) : void;
      
      function attemptTrade(param1:String, param2:int, param3:Boolean, param4:Function, param5:Function, param6:Function) : void;
   }
}

