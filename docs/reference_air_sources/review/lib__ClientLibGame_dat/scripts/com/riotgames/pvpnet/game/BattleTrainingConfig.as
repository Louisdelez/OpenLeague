package com.riotgames.pvpnet.game
{
   import com.riotgames.pvpnet.system.config.cdc.ConfigurationModel;
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
   
   public class BattleTrainingConfig
   {
      
      public static const NAMESPACE:String = "BattleTraining";
      
      public static const ENABLED:String = "Enabled";
      
      public static const USE_SRU_MAP:String = "UseSRU";
      
      public function BattleTrainingConfig()
      {
         super();
      }
      
      public static function getEnabledConfig() : ConfigurationModel
      {
         return DynamicClientConfigManager.getConfiguration(NAMESPACE,ENABLED,false,null);
      }
      
      public static function getUseSRUConfiguration() : ConfigurationModel
      {
         return DynamicClientConfigManager.getConfiguration(NAMESPACE,USE_SRU_MAP,true,null);
      }
   }
}

