package com.riotgames.pvpnet.tournament.model
{
   import blix.signals.Signal;
   import com.riotgames.platform.gameclient.domain.game.GameMap;
   import com.riotgames.platform.gameclient.domain.gameconfig.GameTypeConfig;
   
   public class CustomGameModuleConfig
   {
      
      public var availableMaps:Array;
      
      public var configChanged:Signal = new Signal();
      
      public var gameTypes:Array;
      
      public function CustomGameModuleConfig()
      {
         super();
      }
      
      public function isGameTypeValid(param1:int) : Boolean
      {
         var _loc2_:GameTypeConfig = null;
         for each(_loc2_ in this.gameTypes)
         {
            if(_loc2_.id == param1)
            {
               return true;
            }
         }
         return false;
      }
      
      public function getMapById(param1:String) : GameMap
      {
         var _loc3_:GameMap = null;
         var _loc2_:int = parseInt(param1);
         for each(_loc3_ in this.availableMaps)
         {
            if(_loc3_.mapId == _loc2_)
            {
               return _loc3_;
            }
         }
         return null;
      }
   }
}

