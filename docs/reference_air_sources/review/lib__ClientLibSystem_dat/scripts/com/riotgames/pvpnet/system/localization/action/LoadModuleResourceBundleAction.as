package com.riotgames.pvpnet.system.localization.action
{
   import blix.action.BasicAction;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.util.logging.getLogger;
   import flash.events.IEventDispatcher;
   import mx.events.ResourceEvent;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.resources.IResourceManager;
   
   public class LoadModuleResourceBundleAction extends BasicAction
   {
      
      private static var logger:ILogger;
      
      private var resourceManager:IResourceManager;
      
      private var locale:String;
      
      private var bundleName:String;
      
      private var moduleName:String;
      
      private var moduleShortName:String;
      
      private var loadBundleProperties:Boolean;
      
      private var bundleLoadedDispatcher:IEventDispatcher;
      
      public function LoadModuleResourceBundleAction(param1:IResourceManager, param2:String, param3:String, param4:String, param5:String, param6:Boolean)
      {
         super(false);
         if(!logger)
         {
            logger = getLogger(this);
         }
         this.resourceManager = param1;
         this.locale = param2;
         this.bundleName = param3;
         this.moduleName = param4;
         this.moduleShortName = param5;
         this.loadBundleProperties = param6;
      }
      
      override protected function doInvocation() : void
      {
         var _loc1_:String = "mod" + "/" + this.moduleShortName + "/assets/locale/" + this.bundleName + "-" + this.locale + ".swf";
         logger.info("Loading resource module {0}.",_loc1_);
         this.bundleLoadedDispatcher = this.resourceManager.loadResourceModule(_loc1_);
         this.bundleLoadedDispatcher.addEventListener(ResourceEvent.COMPLETE,this.onLoadResourceModuleComplete);
         this.bundleLoadedDispatcher.addEventListener(ResourceEvent.ERROR,this.onLoadResourceModuleError);
         super.doInvocation();
      }
      
      private function loadUncompiledResourcePropertiesFile() : void
      {
         var _loc1_:String = "mod" + "/" + this.moduleShortName + "/assets/locale/" + this.locale + "/" + this.moduleName + ".properties";
         logger.info("Attempting to load resource bundle properties {0}.",_loc1_);
         RiotResourceLoader.registerFlatFile(this.bundleName,_loc1_);
         _loc1_ = "../../../../locale/" + this.moduleName + "/" + this.locale + "/" + this.moduleName + ".properties";
         RiotResourceLoader.registerFlatFile(this.moduleName,_loc1_);
         logger.info("Attempting to load resource bundle properties {0}.",_loc1_);
         _loc1_ = "../../../locale/" + this.moduleName + "/" + this.locale + "/" + this.moduleName + ".properties";
         RiotResourceLoader.registerFlatFile(this.moduleName,_loc1_);
         logger.info("Attempting to load resource bundle properties {0}.",_loc1_);
      }
      
      private function removeBundleListeners() : void
      {
         this.bundleLoadedDispatcher.removeEventListener(ResourceEvent.COMPLETE,this.onLoadResourceModuleComplete);
         this.bundleLoadedDispatcher.removeEventListener(ResourceEvent.ERROR,this.onLoadResourceModuleError);
      }
      
      private function onLoadResourceModuleComplete(param1:ResourceEvent) : void
      {
         var _loc2_:String = null;
         this.removeBundleListeners();
         if(this.loadBundleProperties)
         {
            this.loadUncompiledResourcePropertiesFile();
         }
         if(Log.isDebug())
         {
            _loc2_ = ClientConfig.LOCALES_PATH + "/" + this.moduleName + "/" + this.bundleName + "-" + this.locale + ".swf";
            logger.info("Completed loading resource bundle {0}.",_loc2_);
         }
         complete();
      }
      
      private function onLoadResourceModuleError(param1:ResourceEvent) : void
      {
         this.removeBundleListeners();
         logger.error("The following error occurred attempting to load a resource bundle\n{0}",param1.errorText);
         err(new Error(param1.errorText));
      }
   }
}

