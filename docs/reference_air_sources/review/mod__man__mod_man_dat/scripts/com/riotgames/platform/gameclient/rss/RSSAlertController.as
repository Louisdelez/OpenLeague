package com.riotgames.platform.gameclient.rss
{
   import com.riotgames.platform.common.IAppController;
   import com.riotgames.platform.common.RiotServiceConfig;
   import com.riotgames.platform.common.provider.ChromeContextAlertProviderProxy;
   import com.riotgames.platform.gameclient.contextAlert.AlertLocation;
   import com.riotgames.platform.gameclient.contextAlert.AlertParameters;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import mx.resources.ResourceManager;
   
   public class RSSAlertController
   {
      
      public var serviceConfig:RiotServiceConfig = RiotServiceConfig.instance;
      
      public var applicationController:IAppController;
      
      public var clientConfig:ClientConfig = ClientConfig.instance;
      
      public function RSSAlertController()
      {
         super();
      }
      
      private function onStoreAlert(param1:String, param2:String, param3:Date) : void
      {
         var _loc4_:AlertParameters = null;
         if(!this.applicationController.firstLogin && UserPreferencesManager.userPrefs.lastStoreRSSRead < param3.time)
         {
            UserPreferencesManager.userPrefs.lastStoreRSSRead = param3.time;
            _loc4_ = new AlertParameters();
            _loc4_.location = AlertLocation.STORE_BUTTON;
            _loc4_.title = param1;
            _loc4_.message = param2;
            ChromeContextAlertProviderProxy.instance.showAlertForParameters(_loc4_);
         }
      }
      
      private function onJoJAlert(param1:String, param2:String, param3:Date) : void
      {
         var _loc4_:String = null;
         var _loc5_:AlertParameters = null;
         if(!this.applicationController.firstLogin && UserPreferencesManager.userPrefs.lastJoJRSSRead < param3.time)
         {
            UserPreferencesManager.userPrefs.lastJoJRSSRead = param3.time;
            _loc4_ = ResourceManager.getInstance().getString("resources","alert_joj_new_issue_title");
            if(_loc4_ == null)
            {
               _loc4_ = "New Journal of Justice Issue!";
            }
            _loc5_ = new AlertParameters();
            _loc5_.location = AlertLocation.JOURNAL_OF_JUSTICE_BUTTON;
            _loc5_.title = _loc4_;
            _loc5_.message = param1 + "\n" + param2;
            ChromeContextAlertProviderProxy.instance.showAlertForParameters(_loc5_);
         }
      }
      
      public function checkRSSFeeds() : void
      {
         var _loc3_:RSSParser = null;
         var _loc4_:RSSParser = null;
         var _loc1_:String = null;
         if(this.serviceConfig.rssFeedJoJURL != "" && this.serviceConfig.rssFeedJoJURL != null)
         {
            _loc1_ = this.serviceConfig.rssFeedJoJURL;
         }
         else
         {
            _loc1_ = ResourceManager.getInstance().getString("resources","joj_rss_url");
         }
         if(_loc1_ != "" && _loc1_ != null)
         {
            _loc3_ = new RSSParser(_loc1_,this.onJoJAlert);
         }
         var _loc2_:String = null;
         if(this.serviceConfig.rssFeedStoreURL != "" && this.serviceConfig.rssFeedStoreURL != null)
         {
            _loc2_ = this.serviceConfig.rssFeedStoreURL;
         }
         else
         {
            _loc2_ = ResourceManager.getInstance().getString("resources","store_rss_url");
         }
         if(_loc2_ != null && _loc2_ != "")
         {
            _loc4_ = new RSSParser(_loc2_,this.onStoreAlert);
         }
      }
   }
}

