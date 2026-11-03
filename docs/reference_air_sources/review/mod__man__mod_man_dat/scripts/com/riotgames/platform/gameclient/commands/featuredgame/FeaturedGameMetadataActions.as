package com.riotgames.platform.gameclient.commands.featuredgame
{
   import com.riotgames.platform.gameclient.configurations.FeaturedGameMetadataConfigurationEnum;
   import com.riotgames.platform.gameclient.views.lobby.ChooseGameViewLayoutPVE;
   import com.riotgames.pvpnet.game.controllers.GameConfig;
   import com.riotgames.pvpnet.game.domain.GameQueueManager;
   import com.riotgames.pvpnet.system.config.PlatformConfigProviderProxy;
   import com.riotgames.pvpnet.system.config.cdc.ConfigurationModel;
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
   import mx.collections.ArrayCollection;
   
   public class FeaturedGameMetadataActions
   {
      
      public function FeaturedGameMetadataActions()
      {
         super();
      }
      
      public static function executeUpdateGameOptionsAction(param1:GameQueueManager, param2:Array) : void
      {
         new UpdateGameOptionsForMetadataAction(param1,param2).invoke();
      }
      
      public static function executeQueryMetadataAndUpdateGameOptionsAction(param1:GameQueueManager, param2:Array, param3:Function) : void
      {
         var _loc4_:QueryMetadataAndUpdateGameOptionsAction = null;
         if(!GameConfig.instance.featuredGameMetadataQueried && serviceEnabled && metadataApplicableQueuesTurnedOn())
         {
            GameConfig.instance.featuredGameMetadataQueried = true;
            _loc4_ = new QueryMetadataAndUpdateGameOptionsAction(param1,param2);
            _loc4_.getCompleted().add(param3);
            _loc4_.invoke();
         }
      }
      
      private static function metadataApplicableQueuesTurnedOn() : Boolean
      {
         var _loc2_:Number = NaN;
         if(PlatformConfigProviderProxy.instance.getPlatformConfig() == null)
         {
            return false;
         }
         var _loc1_:ArrayCollection = PlatformConfigProviderProxy.instance.getPlatformConfig().enabledQueueIdsList;
         if(_loc1_ != null)
         {
            for each(_loc2_ in ChooseGameViewLayoutPVE.QUEUE_NBOTS)
            {
               if(_loc1_.contains(_loc2_))
               {
                  return true;
               }
            }
         }
         return false;
      }
      
      public static function get serviceEnabled() : Boolean
      {
         var _loc1_:ConfigurationModel = DynamicClientConfigManager.getConfiguration(FeaturedGameMetadataConfigurationEnum.METADATA_NAMESPACE,FeaturedGameMetadataConfigurationEnum.METADATA_ENABLED_KEY,FeaturedGameMetadataConfigurationEnum.METADATA_ENABLED_DEFAULT);
         return FeaturedGameMetadataConfigurationEnum.METADATA_ENABLED_ON == _loc1_.getString();
      }
   }
}

