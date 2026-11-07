package com.riotgames.platform.gameclient.commands.featuredgame
{
   import blix.action.BasicAction;
   import com.riotgames.platform.common.error.ServerError;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.gameclient.domain.featuredgame.FeaturedGameMetadataDTO;
   import com.riotgames.pvpnet.game.controllers.GameConfig;
   import flash.utils.getQualifiedClassName;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.rpc.events.ResultEvent;
   
   internal class FeaturedGameMetadataQueryAction extends BasicAction
   {
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      public function FeaturedGameMetadataQueryAction()
      {
         super(false);
      }
      
      private function onGetFeaturedGameMetadataError(param1:ServerError) : void
      {
         this.logger.error(this.logger.category + ".onServiceRequestError, error obtaining featured game metadata: " + param1.exception);
      }
      
      override protected function doInvocation() : void
      {
         if(!FeaturedGameMetadataActions.serviceEnabled)
         {
            complete();
            return;
         }
         ServiceProxy.instance.gameService.getFeaturedGameMetadata(this.onGetFeaturedGameMetadataSuccess,this.onGetFeaturedGameMetadataComplete,this.onGetFeaturedGameMetadataError);
      }
      
      private function onGetFeaturedGameMetadataSuccess(param1:ResultEvent) : void
      {
         if(param1 != null)
         {
            GameConfig.instance.featuredGameMetadataDTO = param1.result as FeaturedGameMetadataDTO;
         }
      }
      
      private function onGetFeaturedGameMetadataComplete(param1:Object = null) : void
      {
         complete();
      }
   }
}

