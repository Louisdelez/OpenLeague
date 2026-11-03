package com.riotgames.pvpnet.microfeedback
{
   import blix.action.IAction;
   import blix.assets.proxy.DisplayAdapter;
   import com.riotgames.platform.common.provider.IMicroFeedbackProvider;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.gameclient.domain.microfeedback.SurveyDTO;
   import com.riotgames.platform.provider.IProviderModule;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.platform.provider.ProviderModuleInfo;
   import com.riotgames.pvpnet.microfeedback.popup.PopupDriver;
   import com.riotgames.pvpnet.microfeedback.popup.survey.DTOValidator;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.localization.action.LoadModuleResourceBundleAction;
   import com.riotgames.rust.module.RiotModuleRoot;
   import flash.display.DisplayObjectContainer;
   import flash.net.URLRequest;
   import mx.core.UIComponent;
   import mx.messaging.events.MessageEvent;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class ClientModuleMicroFeedback extends RiotModuleRoot implements IProviderModule, IMicroFeedbackProvider
   {
      
      public static const MICROFEEDBACK_RESOURCE_ID:String = "MicroFeedbackSurvey";
      
      private var moduleInfo:ProviderModuleInfo;
      
      internal var popupDriver:PopupDriver;
      
      private var blockSurveys:Boolean = false;
      
      private var serviceProxy:ServiceProxy = ServiceProxy.instance;
      
      public function ClientModuleMicroFeedback()
      {
         super();
         this.serviceProxy.messageRouterService.addClientNotificationMessageListener(this.onClientNotificationMessageRecieved);
      }
      
      public function getBlockSurveys() : Boolean
      {
         return this.blockSurveys;
      }
      
      public function setBlockSurveys(param1:Boolean) : void
      {
         this.blockSurveys = param1;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
      }
      
      override protected function initializeDependencies() : void
      {
         registerDependency(IResourceManager,ResourceManager.getInstance());
         super.initializeDependencies();
      }
      
      internal function setPopupDriver(param1:SurveyDTO) : void
      {
         if(this.popupDriver != null)
         {
            this.clearPopupDriver();
         }
         this.popupDriver = new PopupDriver(this,param1);
         this.popupDriver.setX(20);
         rootView.addChild(this.popupDriver);
      }
      
      internal function clearPopupDriver() : void
      {
         if(this.popupDriver == null)
         {
            return;
         }
         rootView.removeChild(this.popupDriver);
         this.popupDriver.destroy();
         this.popupDriver = null;
      }
      
      private function onClientNotificationMessageRecieved(param1:MessageEvent) : void
      {
         var _loc2_:Object = param1.message.body;
         if(_loc2_ is SurveyDTO)
         {
            this.onSurveyMessageRecieved(SurveyDTO(_loc2_));
         }
      }
      
      public function initializeModule(param1:ProviderModuleInfo) : void
      {
         this.moduleInfo = param1;
         this.loadLocalizedResources();
      }
      
      private function loadLocalizedResources() : void
      {
         var _loc1_:String = this.getCurrentLocale();
         var _loc2_:IResourceManager = getDependency(IResourceManager);
         var _loc3_:IAction = new LoadModuleResourceBundleAction(_loc2_,_loc1_,"MicroFeedback","MicroFeedbackSurvey","mf",ClientConfig.instance.debugLocale);
         _loc3_.getCompleted().addOnce(this.onLoadResourceBundleComplete);
         _loc3_.invoke();
      }
      
      private function onLoadResourceBundleComplete() : void
      {
         assetsLoader.loadAssets(new URLRequest(this.moduleInfo.getPath() + "/assets/microFeedbackAssets.swf"));
         ProviderLookup.publishProvider(IMicroFeedbackProvider,this);
      }
      
      private function getCurrentLocale() : String
      {
         return ClientConfig.instance.locale;
      }
      
      public function forceStop(param1:Boolean = false) : void
      {
         if(this.popupDriver == null)
         {
            return;
         }
         if(param1)
         {
            this.popupDriver.setCurrentState(PopupDriver.STATE_CLOSED);
         }
         else
         {
            this.clearPopupDriver();
         }
      }
      
      public function onSurveyMessageRecieved(param1:SurveyDTO) : void
      {
         if(param1 == null || this.blockSurveys)
         {
            return;
         }
         if(DTOValidator.validateAndPrepPrompt(param1))
         {
            this.setPopupDriver(param1);
            this.popupDriver.startSurvey();
            logger.info("Prompting " + param1.questionType + " question: " + param1.questionContent);
         }
         else
         {
            logger.warn("Invalid Survey Prompt: type=" + param1.questionType + ",id=" + param1.questionId + ",txt=" + param1.questionContent);
         }
      }
      
      public function setParentView(param1:DisplayObjectContainer) : void
      {
         var _loc2_:UIComponent = null;
         if(param1 != null)
         {
            _loc2_ = new UIComponent();
            param1.addChild(_loc2_);
            new DisplayAdapter(_loc2_).addChild(this.rootView);
         }
      }
   }
}

