package com.riotgames.pvpnet.system.boot
{
   import blix.action.BasicAction;
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.util.logging.getLogger;
   import flash.utils.getTimer;
   import mx.logging.ILogger;
   
   public class LoadImageResourcesAction extends BasicAction
   {
      
      private var startTime:int;
      
      private var logger:ILogger;
      
      public function LoadImageResourcesAction()
      {
         super(false);
         this.logger = getLogger(this);
      }
      
      override protected function doInvocation() : void
      {
         this.startTime = getTimer();
         ImagePackLookup.instance.initializeImagePacks(this.handleImageResourcesLoaded);
      }
      
      private function handleImageResourcesLoaded() : void
      {
         var _loc1_:int = getTimer();
         this.logger.debug("Image Resources loaded in " + (_loc1_ - this.startTime) / 1000 + " seconds.");
         complete();
      }
   }
}

