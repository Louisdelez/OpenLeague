package com.riotgames.pvpnet.game.variants
{
   import com.riotgames.platform.gameclient.domain.gameconfig.GameTypeConfig;
   import com.riotgames.pvpnet.game.controllers.practice.PracticeGameParameters;
   import mx.collections.ArrayCollection;
   
   internal class OneForAllGameFlowVariant extends FeaturedGameFlowVariant
   {
      
      public function OneForAllGameFlowVariant()
      {
         super();
      }
      
      override public function createPracticeGameParameters() : PracticeGameParameters
      {
         var _loc1_:PracticeGameParameters = super.createPracticeGameParameters();
         _loc1_.overriddenGamePickIds = new ArrayCollection([GameTypeConfig.PICK_ID_ONE_TEAM_VOTE_DRAFT]);
         return _loc1_;
      }
   }
}

