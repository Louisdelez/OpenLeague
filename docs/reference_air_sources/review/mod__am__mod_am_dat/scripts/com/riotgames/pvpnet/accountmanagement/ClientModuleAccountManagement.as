package com.riotgames.pvpnet.accountmanagement
{
   import blix.action.IAction;
   import blix.action.SequenceAction;
   import com.riotgames.platform.common.provider.IChromeContextAlertProvider;
   import com.riotgames.platform.common.provider.IMetricsProvider;
   import com.riotgames.platform.provider.IProviderModule;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.platform.provider.ProviderModuleInfo;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import com.riotgames.pvpnet.system.config.cdc.ConfigurationModel;
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
   import com.riotgames.pvpnet.system.localization.action.LoadModuleResourceBundleAction;
   import flash.display.Sprite;
   import flash.events.Event;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class ClientModuleAccountManagement extends Sprite implements IProviderModule, IAccountManagementProvider
   {
      
      public static const ACCOUNT_MANAGEMENT_RESOURCE_ID:String = "AccountManagement";
      
      private static const ACCOUNT_MANAGEMENT_MODULE_CODE:String = "am";
      
      private static const ACCOUNT_MANAGEMENT_EVURL_KEY:String = "evURL";
      
      private static const ACCOUNT_MANAGEMENT_DEFAULT_EVURL:String = "https://account.leagueoflegends.com/{0}/{1}/protect?utm_source=AIRCLIENT&utm_medium=NOTIFICATION&utm_campaign=verification";
      
      private var _moduleInfo:ProviderModuleInfo;
      
      private var metricsProvider:IMetricsProvider;
      
      private var contextAlertProvider:IChromeContextAlertProvider;
      
      private var initSequence:SequenceAction;
      
      internal var evDynamicConfigModel:ConfigurationModel;
      
      public function ClientModuleAccountManagement()
      {
         super();
      }
      
      public function initializeModule(param1:ProviderModuleInfo) : void
      {
         this._moduleInfo = param1;
         this.evDynamicConfigModel = DynamicClientConfigManager.getConfiguration(ACCOUNT_MANAGEMENT_RESOURCE_ID,ACCOUNT_MANAGEMENT_EVURL_KEY,ACCOUNT_MANAGEMENT_DEFAULT_EVURL);
         this.initSequence = new SequenceAction();
         this.initSequence.and(this.getLoadLocalizedResources());
         this.initSequence.andCall(this.getContextAlertProvider);
         this.initSequence.andCall(this.getMetricsProvider);
         if(!UserPreferencesManager.instance.hasLoadedUserPreferences)
         {
            this.initSequence.andCall(this.getUserPreferences);
         }
         this.initSequence.getCompleted().addOnce(this.onInitComplete);
         this.initSequence.invoke();
      }
      
      private function getLoadLocalizedResources() : IAction
      {
         var _loc1_:String = ClientConfig.instance.locale;
         var _loc2_:IResourceManager = ResourceManager.getInstance();
         return new LoadModuleResourceBundleAction(_loc2_,_loc1_,ACCOUNT_MANAGEMENT_RESOURCE_ID,ACCOUNT_MANAGEMENT_RESOURCE_ID,ACCOUNT_MANAGEMENT_MODULE_CODE,ClientConfig.instance.debugLocale);
      }
      
      private function getContextAlertProvider() : void
      {
         ProviderLookup.getProvider(IChromeContextAlertProvider,this.onGottenContextAlertProvider);
      }
      
      private function onGottenContextAlertProvider(param1:IChromeContextAlertProvider) : void
      {
         this.contextAlertProvider = param1;
         this.initSequence.completeFunction(this.getContextAlertProvider);
      }
      
      private function getMetricsProvider() : void
      {
         ProviderLookup.getProvider(IMetricsProvider,this.onGottenMetricsProvider);
      }
      
      private function onGottenMetricsProvider(param1:IMetricsProvider) : void
      {
         this.metricsProvider = param1;
         this.initSequence.completeFunction(this.getMetricsProvider);
      }
      
      private function getUserPreferences() : void
      {
         UserPreferencesManager.instance.addEventListener(UserPreferencesManager.USER_PREFERENCES_LOADED,this.onGottenUserPreferences);
      }
      
      private function onGottenUserPreferences(param1:Event) : void
      {
         this.initSequence.completeFunction(this.getUserPreferences);
         UserPreferencesManager.instance.removeEventListener(UserPreferencesManager.USER_PREFERENCES_LOADED,this.onGottenUserPreferences);
      }
      
      private function onInitComplete() : void
      {
         ProviderLookup.publishProvider(IAccountManagementProvider,this);
      }
      
      public function createEmailVerificationAlert(param1:String) : void
      {
         AccountManagementEmailVerificationAlert.create(this.contextAlertProvider,this.metricsProvider,param1,this.evDynamicConfigModel.getString());
      }
   }
}

