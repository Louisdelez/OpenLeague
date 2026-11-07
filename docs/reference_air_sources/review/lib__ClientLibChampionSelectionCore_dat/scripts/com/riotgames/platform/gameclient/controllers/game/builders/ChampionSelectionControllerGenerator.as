package com.riotgames.platform.gameclient.controllers.game.builders
{
   import blix.context.IContext;
   import com.riotgames.platform.gameclient.championselection.GameSelectionData;
   import com.riotgames.platform.gameclient.controllers.game.controllers.ChampionSelectionControllerNew;
   import com.riotgames.platform.gameclient.controllers.game.model.ChampionSelectionModel;
   
   public class ChampionSelectionControllerGenerator
   {
      
      public function ChampionSelectionControllerGenerator()
      {
         super();
      }
      
      public static function generateChampionSelectionController(param1:IContext, param2:GameSelectionData, param3:ChampionSelectionModel) : ChampionSelectionControllerNew
      {
         return new ChampionSelectionControllerNew(param1,param2,param3);
      }
   }
}

