package com.riotgames.pvpnet.system.boot.legacy.actions
{
   import blix.action.BasicAction;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.common.validators.ValidatorFactory;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.wordfilter.WordFilter;
   import com.riotgames.util.logging.getLogger;
   import flash.events.IEventDispatcher;
   import mx.controls.Alert;
   import mx.events.ResourceEvent;
   import mx.logging.ILogger;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   public class LoadLegacyResourcesAction extends BasicAction
   {
      
      private var logger:ILogger;
      
      public function LoadLegacyResourcesAction()
      {
         super(false);
         this.logger = getLogger(this);
      }
      
      override protected function doInvocation() : void
      {
         this.loadApplicationResources();
      }
      
      private function loadApplicationResources() : void
      {
         var _loc1_:String = ClientConfig.LOCALES_PATH + "/App" + "/resources-" + ClientConfig.instance.locale + ".swf";
         var _loc2_:IEventDispatcher = ResourceManager.getInstance().loadResourceModule(_loc1_);
         _loc2_.addEventListener(ResourceEvent.COMPLETE,this.applicationResourceBundleLoaded);
         _loc2_.addEventListener(ResourceEvent.ERROR,this.resourceErrorHandler);
      }
      
      private function applicationResourceBundleLoaded(param1:ResourceEvent) : void
      {
         var _loc6_:String = null;
         var _loc2_:IResourceManager = ResourceManager.getInstance();
         ValidatorFactory.DEFAULT_ERROR_MESSAGE = _loc2_.getString("resources","validator_requiredErrorMessage");
         if(ClientConfig.instance.debugLocale)
         {
            for each(_loc6_ in RiotResourceLoader.RESOURCES_TYPES)
            {
               RiotResourceLoader.registerFlatFile(_loc6_,"/assets/locale/" + ClientConfig.instance.locale + "/" + _loc6_ + ".properties");
               RiotResourceLoader.registerFlatFile(_loc6_,"../../../../locale/" + ClientConfig.instance.locale + "/" + _loc6_ + ".properties");
            }
         }
         Alert.okLabel = _loc2_.getString("resources","common_button_ok");
         Alert.cancelLabel = _loc2_.getString("resources","common_button_cancel");
         Alert.yesLabel = _loc2_.getString("resources","common_button_yes");
         Alert.noLabel = _loc2_.getString("resources","common_button_no");
         var _loc3_:String = RiotResourceLoader.getFilterString("bad_words");
         var _loc4_:String = RiotResourceLoader.getFilterString("restricted_words");
         var _loc5_:String = RiotResourceLoader.getFilterString("allowed_characters");
         WordFilter.instance.initialize(ClientConfig.instance.locale,_loc3_,_loc4_,_loc5_);
         if(_loc2_.getString("resources","reportPlayerURL") != null)
         {
            ClientConfig.instance.reportAPlayerAvailable = true;
         }
         else
         {
            ClientConfig.instance.reportAPlayerAvailable = false;
         }
         this.loadGameContentResources();
      }
      
      private function loadGameContentResources() : void
      {
         var _loc1_:String = ClientConfig.LOCALES_PATH + "/Game" + "/resources-" + ClientConfig.instance.locale + ".swf";
         var _loc2_:IEventDispatcher = ResourceManager.getInstance().loadResourceModule(_loc1_);
         _loc2_.addEventListener(ResourceEvent.COMPLETE,this.gameResourceBundleLoaded);
         _loc2_.addEventListener(ResourceEvent.ERROR,this.resourceErrorHandler);
      }
      
      private function gameResourceBundleLoaded(param1:ResourceEvent) : void
      {
         complete();
      }
      
      private function resourceErrorHandler(param1:ResourceEvent) : void
      {
         err(new Error("LoadLegacyResourcesAction" + param1.errorText));
      }
   }
}

