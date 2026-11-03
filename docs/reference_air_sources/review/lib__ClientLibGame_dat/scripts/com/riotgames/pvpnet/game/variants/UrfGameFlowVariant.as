package com.riotgames.pvpnet.game.variants
{
   import com.riotgames.platform.gameclient.domain.gameconfig.GameTypeConfig;
   import com.riotgames.pvpnet.game.controllers.practice.PracticeGameParameters;
   import mx.collections.ArrayCollection;
   
   internal class UrfGameFlowVariant extends FeaturedGameFlowVariant
   {
      
      public function UrfGameFlowVariant()
      {
         super();
      }
      
      override public function createPracticeGameParameters() : PracticeGameParameters
      {
         var _loc1_:PracticeGameParameters = super.createPracticeGameParameters();
         _loc1_.overriddenGamePickIds = new ArrayCollection([GameTypeConfig.PICK_ID_SIM_BAN_SHORT_TIMER]);
         return _loc1_;
      }
   }
}

