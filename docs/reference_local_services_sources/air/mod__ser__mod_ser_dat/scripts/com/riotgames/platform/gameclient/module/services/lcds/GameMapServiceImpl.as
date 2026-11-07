package com.riotgames.platform.gameclient.module.services.lcds
{
   import com.riotgames.platform.gameclient.services.GameMapService;
   
   public class GameMapServiceImpl extends BaseLcdsService implements GameMapService
   {
      
      public function GameMapServiceImpl()
      {
         super();
      }
      
      public function getGameMapList(param1:Function, param2:Function, param3:Function) : void
      {
         invokeServiceWithoutSession("gameMapService","getGameMapList",[],param1,param2);
      }
      
      public function getGameMapSet(param1:Function, param2:Function, param3:Function) : void
      {
         invokeServiceWithoutSession("gameMapService","getGameMapSet",[],param1,param2);
      }
   }
}

