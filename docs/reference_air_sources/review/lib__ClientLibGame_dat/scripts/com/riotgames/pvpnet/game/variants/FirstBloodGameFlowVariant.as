package com.riotgames.pvpnet.game.variants
{
   import com.riotgames.platform.gameclient.domain.game.GameMap;
   import com.riotgames.platform.gameclient.domain.gameconfig.GameTypeConfig;
   import com.riotgames.pvpnet.game.controllers.practice.PracticeGameParameters;
   import mx.collections.ArrayCollection;
   
   internal class FirstBloodGameFlowVariant extends FeaturedGameFlowVariant
   {
      
      public function FirstBloodGameFlowVariant()
      {
         super();
      }
      
      override public function canAddBotsToCustomGame() : Boolean
      {
         return false;
      }
      
      override public function getGameStatsType(param1:int) : String
      {
         return GameStatsType.ARAM;
      }
      
      override public function createPracticeGameParameters() : PracticeGameParameters
      {
         var _loc1_:PracticeGameParameters = super.createPracticeGameParameters();
         _loc1_.overriddenGamePickIds = new ArrayCollection([GameTypeConfig.PICK_ID_SIM_BAN]);
         _loc1_.overriddenMapIds = new ArrayCollection([GameMap.HOWLING_ABYSS]);
         _loc1_.overriddenMaxTeamSize = 2;
         return _loc1_;
      }
   }
}

