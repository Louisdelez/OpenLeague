package com.riotgames.pvpnet.game.variants
{
   import com.riotgames.platform.gameclient.domain.game.GameMap;
   import com.riotgames.platform.gameclient.domain.gameconfig.GameTypeConfig;
   import com.riotgames.pvpnet.game.controllers.practice.PracticeGameParameters;
   import mx.collections.ArrayCollection;
   
   public class PPPGameFlowVariant extends FeaturedGameFlowVariant
   {
      
      public function PPPGameFlowVariant()
      {
         super();
      }
      
      override public function createPracticeGameParameters() : PracticeGameParameters
      {
         var _loc1_:PracticeGameParameters = super.createPracticeGameParameters();
         _loc1_.overriddenGamePickIds = new ArrayCollection([GameTypeConfig.PICK_ID_SIM_BAN_SHORT_TIMER]);
         _loc1_.overriddenMapIds = new ArrayCollection([GameMap.HOWLING_ABYSS]);
         return _loc1_;
      }
   }
}

