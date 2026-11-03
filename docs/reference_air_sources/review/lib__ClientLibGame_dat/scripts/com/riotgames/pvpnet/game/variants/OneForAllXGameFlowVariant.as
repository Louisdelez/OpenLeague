package com.riotgames.pvpnet.game.variants
{
   import com.riotgames.platform.gameclient.domain.gameconfig.GameTypeConfig;
   import com.riotgames.pvpnet.game.controllers.practice.PracticeGameParameters;
   import mx.collections.ArrayCollection;
   
   internal class OneForAllXGameFlowVariant extends FeaturedGameFlowVariant
   {
      
      public function OneForAllXGameFlowVariant()
      {
         super();
      }
      
      override public function supportsBattleBoost() : Boolean
      {
         return true;
      }
      
      override public function createPracticeGameParameters() : PracticeGameParameters
      {
         var _loc1_:PracticeGameParameters = super.createPracticeGameParameters();
         _loc1_.overriddenGamePickIds = new ArrayCollection([GameTypeConfig.PICK_ID_ALL_TEAM_VOTE_PICK]);
         return _loc1_;
      }
   }
}

