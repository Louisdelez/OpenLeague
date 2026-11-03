package com.riotgames.pvpnet.system.leagues.configuration
{
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
   
   public class LeagueConfig
   {
      
      private static const NAMESPACE:String = "LeagueConfig";
      
      private static const MASTER_TIER_ENABLED:String = "MasterTierEnabled";
      
      private static const IS_PRESEASON:String = "IsPreseason";
      
      private static const SEASON_NAME:String = "SeasonName";
      
      private static const PRESEASON_NAME:String = "PreseasonName";
      
      public function LeagueConfig()
      {
         super();
      }
      
      public static function isMasterTierEnabled() : Boolean
      {
         return DynamicClientConfigManager.getConfiguration(NAMESPACE,MASTER_TIER_ENABLED,false,null).getBoolean();
      }
      
      public static function isPreseason() : Boolean
      {
         return DynamicClientConfigManager.getConfiguration(NAMESPACE,IS_PRESEASON,false,null).getBoolean();
      }
      
      public static function seasonName() : String
      {
         return DynamicClientConfigManager.getConfiguration(NAMESPACE,SEASON_NAME,"",null).getString();
      }
      
      public static function preseasonName() : String
      {
         return DynamicClientConfigManager.getConfiguration(NAMESPACE,PRESEASON_NAME,"",null).getString();
      }
   }
}

