package com.riotgames.platform.gameclient.domain.inventory
{
   import com.riotgames.pvpnet.system.config.cdc.ConfigurationModel;
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
   
   public class ChampionFilterConfig
   {
      
      private static const CHAMP_SELECT_NAMESPACE:String = "ChampionSelect";
      
      private static const COLLATOR_ENABLED_KEY:String = "CollatorChampionFilterEnabled";
      
      private static const COLLATOR_ENABLED_DEFAULT:Boolean = false;
      
      public function ChampionFilterConfig()
      {
         super();
      }
      
      public static function isCollatorFilterEnabled() : Boolean
      {
         var _loc1_:ConfigurationModel = DynamicClientConfigManager.getConfiguration(CHAMP_SELECT_NAMESPACE,COLLATOR_ENABLED_KEY,COLLATOR_ENABLED_DEFAULT);
         return _loc1_.getBoolean();
      }
   }
}

