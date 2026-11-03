package com.riotgames.pvpnet.game.variants
{
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.domain.PlayerStatCategory;
   import com.riotgames.platform.gameclient.domain.game.GameMap;
   import com.riotgames.platform.gameclient.domain.gameconfig.GameTypeConfig;
   import com.riotgames.pvpnet.game.controllers.practice.PracticeGameParameters;
   import mx.collections.ArrayCollection;
   
   internal class AscensionGameFlowVariant extends FeaturedGameFlowVariant
   {
      
      public function AscensionGameFlowVariant()
      {
         super();
      }
      
      override public function getNexusFinalHealthTooltip() : String
      {
         return RiotResourceLoader.getString("asc_final_score_tooltip","Final Team Score");
      }
      
      override public function showStatCategory(param1:String) : Boolean
      {
         return param1 != PlayerStatCategory.OBJECTIVE_CATEGORY;
      }
      
      override public function getGameStatsType(param1:int) : String
      {
         return GameStatsType.DOMINION;
      }
      
      override public function createPracticeGameParameters() : PracticeGameParameters
      {
         var _loc1_:PracticeGameParameters = super.createPracticeGameParameters();
         _loc1_.overriddenGamePickIds = new ArrayCollection([GameTypeConfig.PICK_ID_SIM_BAN_SHORT_TIMER]);
         _loc1_.overriddenMapIds = new ArrayCollection([GameMap.CRYSTAL_SCAR_ID]);
         _loc1_.overriddenMaxTeamSize = 5;
         return _loc1_;
      }
   }
}

