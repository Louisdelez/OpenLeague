package com.riotgames.pvpnet.game.variants
{
   import com.riotgames.platform.gameclient.domain.game.GameMap;
   import com.riotgames.pvpnet.game.controllers.practice.PracticeGameParameters;
   import mx.collections.ArrayCollection;
   
   internal class HexakillGameFlowVariant extends FeaturedGameFlowVariant
   {
      
      public function HexakillGameFlowVariant()
      {
         super();
      }
      
      override public function createPracticeGameParameters() : PracticeGameParameters
      {
         var _loc1_:PracticeGameParameters = null;
         _loc1_ = super.createPracticeGameParameters();
         _loc1_.overriddenMaxTeamSize = 6;
         if(_gameKey == "sr6")
         {
            _loc1_.overriddenMapIds = new ArrayCollection([GameMap.SUMMONERS_RIFT_ID]);
         }
         else if(Boolean(_gameKey = "tt6"))
         {
            _loc1_.overriddenMapIds = new ArrayCollection([GameMap.TWISTED_TREELINE_ID]);
         }
         return _loc1_;
      }
   }
}

