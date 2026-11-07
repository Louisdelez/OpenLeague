package com.riotgames.pvpnet.accountmanagement
{
   import com.riotgames.platform.common.provider.IChromeContextAlertProvider;
   import com.riotgames.platform.common.provider.IMetricsProvider;
   import com.riotgames.platform.gameclient.contextAlert.AlertLocation;
   import com.riotgames.platform.gameclient.contextAlert.AlertParameters;
   import com.riotgames.platform.gameclient.domain.UserPrefs;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   internal class AccountManagementEmailVerificationAlert
   {
      
      internal static const NAG_INTERVAL:Number = 1209600000;
      
      internal static const TITLE_KEY:String = "accountManagement_emailVerificationAlertTitle";
      
      internal static const MESSAGE_KEY:String = "accountManagement_emailVerificationAlertMessage";
      
      internal static const SHOW_METRIC:String = "accountManagementVerifyEmailShow";
      
      internal static const CLOSE_METRIC:String = "accountManagementVerifyEmailClose";
      
      private static const URL_REPLACEMENT:RegExp = /\{(\d+)\}/g;
      
      private var contextAlertProvider:IChromeContextAlertProvider;
      
      private var tracker:IMetricsProvider;
      
      private var preferencesManager:UserPreferencesManager;
      
      private var userPrefs:UserPrefs;
      
      private var resourceManager:IResourceManager;
      
      private var clientConfig:ClientConfig;
      
      private var summonerName:String;
      
      private var url:String;
      
      internal var alertParams:AlertParameters;
      
      public function AccountManagementEmailVerificationAlert(param1:IChromeContextAlertProvider, param2:IMetricsProvider, param3:UserPreferencesManager, param4:UserPrefs, param5:IResourceManager, param6:ClientConfig, param7:String, param8:String)
      {
         super();
         this.contextAlertProvider = param1;
         this.tracker = param2;
         this.preferencesManager = param3;
         this.userPrefs = param4;
         this.resourceManager = param5;
         this.clientConfig = param6;
         this.summonerName = param7;
         this.url = param8;
         this.alertParams = new AlertParameters();
         this.alertParams.title = this.resourceManager.getString(ClientModuleAccountManagement.ACCOUNT_MANAGEMENT_RESOURCE_ID,TITLE_KEY);
         this.alertParams.message = this.resourceManager.getString(ClientModuleAccountManagement.ACCOUNT_MANAGEMENT_RESOURCE_ID,MESSAGE_KEY,[this.getLocalizedURL()]);
         this.alertParams.location = AlertLocation.PROFILE_BUTTON;
      }
      
      internal static function create(param1:IChromeContextAlertProvider, param2:IMetricsProvider, param3:String, param4:String) : Boolean
      {
         var _loc5_:AccountManagementEmailVerificationAlert = new AccountManagementEmailVerificationAlert(param1,param2,UserPreferencesManager.instance,UserPreferencesManager.userPrefs,ResourceManager.getInstance(),ClientConfig.instance,param3,param4);
         var _loc6_:Boolean = _loc5_.isRecentlySeen();
         if(!_loc6_)
         {
            _loc5_.show();
         }
         return _loc6_;
      }
      
      internal function show() : AccountManagementEmailVerificationAlert
      {
         this.contextAlertProvider.getActiveAlertChanged().add(this.onAlertDisplayed);
         this.contextAlertProvider.getAlertDismissedByUser().add(this.onAlertDismissed);
         this.contextAlertProvider.showAlertForParameters(this.alertParams);
         return this;
      }
      
      private function localizedURLReplacement(param1:String, param2:String, param3:Number, param4:String) : String
      {
         var _loc5_:Array = [this.clientConfig.regionTag,this.clientConfig.localePrefix];
         var _loc6_:int = parseInt(param2,10);
         var _loc7_:Boolean = isNaN(_loc6_) || _loc6_ < 0 || _loc6_ >= _loc5_.length;
         return _loc7_ ? param1 : _loc5_[_loc6_];
      }
      
      internal function getLocalizedURL() : String
      {
         return this.url.replace(URL_REPLACEMENT,this.localizedURLReplacement);
      }
      
      internal function isRecentlySeen() : Boolean
      {
         var _loc1_:Date = this.userPrefs.lastSeenEmailVerificationPopup;
         var _loc2_:Date = new Date();
         return _loc1_ !== null && NAG_INTERVAL + _loc1_.getTime() > _loc2_.getTime();
      }
      
      internal function setRecentlySeen() : void
      {
         this.userPrefs.lastSeenEmailVerificationPopup = new Date();
         this.preferencesManager.saveUserPreferences(this.summonerName);
      }
      
      private function onAlertDisplayed(param1:AlertParameters) : void
      {
         if(param1 == this.alertParams)
         {
            this.contextAlertProvider.getActiveAlertChanged().remove(this.onAlertDisplayed);
            this.tracker.track(SHOW_METRIC,{
               "summonerName":this.summonerName,
               "regionTag":this.clientConfig.regionTag
            });
         }
      }
      
      private function onAlertDismissed(param1:AlertParameters) : void
      {
         if(param1 == this.alertParams)
         {
            this.contextAlertProvider.getAlertDismissedByUser().remove(this.onAlertDismissed);
            this.tracker.track(CLOSE_METRIC,{
               "summonerName":this.summonerName,
               "regionTag":this.clientConfig.regionTag
            });
            this.setRecentlySeen();
         }
      }
   }
}

