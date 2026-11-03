package com.riotgames.pvpnet.seasonrewards.commands
{
   import com.riotgames.platform.common.provider.ChromeContextAlertProviderProxy;
   import com.riotgames.platform.gameclient.contextAlert.AlertLocation;
   import com.riotgames.platform.gameclient.contextAlert.AlertParameters;
   import com.riotgames.pvpnet.seasonrewards.helpers.ILocaleHelper;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import com.riotgames.pvpnet.system.leagues.configuration.LeagueConfig;
   
   public class SeasonRewardsInfoCommand
   {
      
      private var _localeHelper:ILocaleHelper;
      
      private var _alertParameters:AlertParameters;
      
      public function SeasonRewardsInfoCommand(param1:ILocaleHelper)
      {
         super();
         this._localeHelper = param1;
      }
      
      public function execute() : void
      {
         var _loc1_:Boolean = Boolean(UserPreferencesManager.userPrefs.seenSeerInfo);
         this._alertParameters = new AlertParameters();
         this._alertParameters.message = this._localeHelper.localeLookup("season_rewards_ticker_message");
         this._alertParameters.title = this._localeHelper.localeLookup("season_rewards_ticker_title",[LeagueConfig.seasonName()]);
         this._alertParameters.location = AlertLocation.PROFILE_BUTTON;
         if(this._alertParameters.message == "null" || _loc1_)
         {
            return;
         }
         ChromeContextAlertProviderProxy.instance.getAlertDismissedByUser().add(this.handleAlertDismissed);
         ChromeContextAlertProviderProxy.instance.showAlertForParameters(this._alertParameters);
      }
      
      private function handleAlertDismissed(param1:AlertParameters) : void
      {
         if(this._alertParameters == param1)
         {
            ChromeContextAlertProviderProxy.instance.getAlertDismissedByUser().remove(this.handleAlertDismissed);
            UserPreferencesManager.userPrefs.seenSeerInfo = true;
         }
      }
   }
}

