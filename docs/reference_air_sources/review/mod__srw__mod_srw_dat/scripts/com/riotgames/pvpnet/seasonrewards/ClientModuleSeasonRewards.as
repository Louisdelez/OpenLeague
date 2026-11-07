package com.riotgames.pvpnet.seasonrewards
{
   import blix.action.IAction;
   import blix.assets.proxy.IDisplayChild;
   import com.riotgames.platform.provider.IProviderModule;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.platform.provider.ProviderModuleInfo;
   import com.riotgames.pvpnet.seasonrewards.commands.SeasonRewardsInfoCommand;
   import com.riotgames.pvpnet.seasonrewards.helpers.ILocaleHelper;
   import com.riotgames.pvpnet.seasonrewards.helpers.LocaleHelper;
   import com.riotgames.pvpnet.seasonrewards.views.SeasonRewardsMainView;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.localization.action.LoadModuleResourceBundleAction;
   import com.riotgames.rust.module.RiotModuleRoot;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class ClientModuleSeasonRewards extends RiotModuleRoot implements IProviderModule, ISeasonRewardsProvider
   {
      
      private var _moduleInfo:ProviderModuleInfo;
      
      private var _seasonRewardsScreen:SeasonRewardsMainView;
      
      public function ClientModuleSeasonRewards()
      {
         super();
      }
      
      public function initializeModule(param1:ProviderModuleInfo) : void
      {
         this._moduleInfo = param1;
         this.loadLocalizations();
      }
      
      private function showSeasonRewardsInfo() : void
      {
         var _loc1_:SeasonRewardsInfoCommand = new SeasonRewardsInfoCommand(getDependency(ILocaleHelper));
         _loc1_.execute();
      }
      
      private function loadLocalizations() : void
      {
         var _loc1_:String = ClientConfig.instance.locale;
         var _loc2_:IResourceManager = ResourceManager.getInstance();
         var _loc3_:IAction = new LoadModuleResourceBundleAction(_loc2_,_loc1_,"SeasonRewards","SeasonRewards","srw",ClientConfig.instance.debugLocale);
         _loc3_.getCompleted().addOnce(this.onLoadResourceBundleComplete);
         _loc3_.invoke();
      }
      
      override protected function initializeDependencies() : void
      {
         super.initializeDependencies();
         registerDependency(ILocaleHelper,new LocaleHelper());
      }
      
      private function onLoadResourceBundleComplete() : void
      {
         ProviderLookup.publishProvider(ISeasonRewardsProvider,this);
      }
      
      public function getTeamRewardsView() : IDisplayChild
      {
         if(!this._seasonRewardsScreen)
         {
            this.updateRewards();
         }
         return this._seasonRewardsScreen.teamRewardsProgressView;
      }
      
      public function getTierRewardsView() : IDisplayChild
      {
         if(!this._seasonRewardsScreen)
         {
            this.updateRewards();
         }
         return this._seasonRewardsScreen.tierRewardsProgressView;
      }
      
      public function updateRewards() : void
      {
         if(!this._seasonRewardsScreen)
         {
            this._seasonRewardsScreen = new SeasonRewardsMainView(this,this._moduleInfo);
            this._seasonRewardsScreen.show();
         }
         this._seasonRewardsScreen.processRewardsAndInitialize();
      }
      
      public function showInformationPopup() : void
      {
         this.showSeasonRewardsInfo();
      }
   }
}

