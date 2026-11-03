package com.riotgames.pvpnet.game.variants
{
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.domain.PlayerParticipantStatsSummary;
   import com.riotgames.platform.gameclient.domain.game.GameMutator;
   
   internal class NightmareBotsGameFlowVariant extends FeaturedGameFlowVariant
   {
      
      private static const NIGHTMARE_BOTS_1:String = "NightmareBots1";
      
      private static const NIGHTMARE_BOTS_2:String = "NightmareBots2";
      
      private static const NIGHTMARE_BOTS_3:String = "NightmareBots3";
      
      private static const NIGHTMARE_BOT_PROFILE_ICON:int = 673;
      
      public function NightmareBotsGameFlowVariant()
      {
         super();
      }
      
      override public function getGameFlowName() : String
      {
         var _loc1_:String = super.getGameFlowName();
         if(GameMutator.hasMutator(this._gameMutators,NIGHTMARE_BOTS_3))
         {
            return _loc1_ + " " + RiotResourceLoader.getString("featured_nbots_tier_3");
         }
         if(GameMutator.hasMutator(this._gameMutators,NIGHTMARE_BOTS_2))
         {
            return _loc1_ + " " + RiotResourceLoader.getString("featured_nbots_tier_2");
         }
         if(GameMutator.hasMutator(this._gameMutators,NIGHTMARE_BOTS_1))
         {
            return _loc1_ + " " + RiotResourceLoader.getString("featured_nbots_tier_1");
         }
         return _loc1_;
      }
      
      override public function getGameFlowQueueTitleIcon() : String
      {
         return this.getBombIconPath();
      }
      
      override public function getEndOfGameProfileIcon(param1:PlayerParticipantStatsSummary) : int
      {
         if(param1.botPlayer)
         {
            return NIGHTMARE_BOT_PROFILE_ICON;
         }
         return param1.profileIconId;
      }
      
      override public function getEndOfGameCoOpVsAiText(param1:String) : String
      {
         return null;
      }
      
      override public function getEndOfGameCoOpVsAiIcon(param1:String) : String
      {
         return this.getBombIconPath();
      }
      
      private function getBombIconPath() : String
      {
         if(GameMutator.hasMutator(this._gameMutators,NIGHTMARE_BOTS_3))
         {
            return "e_difficulty3";
         }
         if(GameMutator.hasMutator(this._gameMutators,NIGHTMARE_BOTS_2))
         {
            return "e_difficulty2";
         }
         if(GameMutator.hasMutator(this._gameMutators,NIGHTMARE_BOTS_1))
         {
            return "e_difficulty1";
         }
         return null;
      }
   }
}

