package com.riotgames.pvpnet.game.variants
{
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.domain.game.GameMode;
   
   internal class DominionGameFlowVariant extends StandardGameFlowVariant
   {
      
      public function DominionGameFlowVariant()
      {
         super();
         initializeKey(GameMode.DOMINION);
      }
      
      override public function useClassicKDATooltip() : Boolean
      {
         return false;
      }
      
      override public function showPointsInfo() : Boolean
      {
         return true;
      }
      
      override public function getNexusFinalHealthTooltip() : String
      {
         return RiotResourceLoader.getString("end_of_game_nexus_health_tooltip","Final Nexus health");
      }
      
      override public function getGameStatsType(param1:int) : String
      {
         return GameStatsType.DOMINION;
      }
   }
}

