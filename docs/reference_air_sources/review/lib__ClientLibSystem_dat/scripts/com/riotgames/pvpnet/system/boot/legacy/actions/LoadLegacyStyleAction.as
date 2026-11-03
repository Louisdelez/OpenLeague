package com.riotgames.pvpnet.system.boot.legacy.actions
{
   import blix.action.BasicAction;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.util.logging.getLogger;
   import flash.events.IEventDispatcher;
   import flash.filesystem.File;
   import mx.events.StyleEvent;
   import mx.logging.ILogger;
   import mx.styles.StyleManager;
   
   public class LoadLegacyStyleAction extends BasicAction
   {
      
      private var logger:ILogger;
      
      public function LoadLegacyStyleAction()
      {
         super(false);
         this.logger = getLogger(this);
      }
      
      override protected function doInvocation() : void
      {
         var _loc3_:IEventDispatcher = null;
         var _loc1_:String = ClientConfig.LOCALES_PATH + "/styles/styles_" + ClientConfig.instance.locale + ".swf";
         var _loc2_:File = File.applicationDirectory.resolvePath(_loc1_);
         if(_loc2_.exists)
         {
            _loc3_ = StyleManager.loadStyleDeclarations(_loc1_);
            _loc3_.addEventListener(StyleEvent.COMPLETE,this.onStyleComplete);
            _loc3_.addEventListener(StyleEvent.ERROR,this.styleErredHandler);
         }
         else
         {
            complete();
         }
      }
      
      private function onStyleComplete(param1:StyleEvent) : void
      {
         complete();
      }
      
      private function styleErredHandler(param1:StyleEvent) : void
      {
         err(new Error("LoadLegacyStyleAction: " + param1.errorText));
      }
   }
}

