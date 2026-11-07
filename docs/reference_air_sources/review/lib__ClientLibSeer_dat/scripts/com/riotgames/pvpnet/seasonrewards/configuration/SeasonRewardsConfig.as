package com.riotgames.pvpnet.seasonrewards.configuration
{
   public class SeasonRewardsConfig
   {
      
      public static const NAMESPACE:String = "SeasonReward";
      
      public static const ENABLED:String = "Enabled";
      
      public static const POINTS_PER_REWARD_LEVEL:String = "minimum_points_per_reward_level";
      
      public static const REWARD_ICONS:Array = ["none","tier3","tier2","tier1"];
      
      public function SeasonRewardsConfig()
      {
         super();
      }
   }
}

