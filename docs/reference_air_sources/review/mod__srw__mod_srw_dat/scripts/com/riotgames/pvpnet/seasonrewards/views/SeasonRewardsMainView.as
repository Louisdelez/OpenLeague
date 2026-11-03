package com.riotgames.pvpnet.seasonrewards.views
{
   import blix.components.tooltip.IToolTipManager;
   import blix.context.Context;
   import blix.context.IContext;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.provider.ILeagueDataProvider;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.module.RiotModuleInfo;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.seasonrewards.configuration.SeasonRewardsConfig;
   import com.riotgames.pvpnet.seasonrewards.helpers.ILocaleHelper;
   import com.riotgames.pvpnet.seasonrewards.helpers.LocaleHelper;
   import com.riotgames.pvpnet.seasonrewards.models.RewardModel;
   import com.riotgames.pvpnet.seasonrewards.views.progress.TeamRewardsProgressView;
   import com.riotgames.pvpnet.seasonrewards.views.progress.TierRewardsProgressView;
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
   import com.riotgames.pvpnet.system.leagues.LeagueTier;
   import com.riotgames.pvpnet.system.leagues.configuration.LeagueConfig;
   import com.riotgames.pvpnet.tips.TipsProviderProxy;
   import com.riotgames.rust.module.RiotModuleView;
   import flash.net.URLRequest;
   
   public class SeasonRewardsMainView extends RiotModuleView
   {
      
      private static const MODULE_NAME:String = "SeasonRewards";
      
      private var _moduleInfo:RiotModuleInfo;
      
      private var _assetsUrlRequest:URLRequest;
      
      private var _hideCompleted:Signal = new Signal();
      
      private var _provider:ILeagueDataProvider;
      
      private var _tierRewardsProgressView:TierRewardsProgressView;
      
      private var _teamRewardsProgressView:TeamRewardsProgressView;
      
      public function SeasonRewardsMainView(param1:IContext, param2:RiotModuleInfo)
      {
         this._moduleInfo = param2;
         super(param1);
         enableAutoLocalization(MODULE_NAME);
      }
      
      override protected function createChildren() : void
      {
         var context:Context = null;
         super.createChildren();
         context = this;
         ProviderLookup.getProvider(ILeagueDataProvider,function(param1:ILeagueDataProvider):void
         {
            _provider = param1;
            _provider.getSeasonRewardsUpdateComplete().add(updateView);
            _tierRewardsProgressView = new TierRewardsProgressView(context);
            _teamRewardsProgressView = new TeamRewardsProgressView(context);
         });
      }
      
      public function get tierRewardsProgressView() : TierRewardsProgressView
      {
         return this._tierRewardsProgressView;
      }
      
      public function get teamRewardsProgressView() : TeamRewardsProgressView
      {
         return this._teamRewardsProgressView;
      }
      
      public function show() : void
      {
         this._assetsUrlRequest = new URLRequest(this._moduleInfo.getPath() + "assets/seasonRewardsAssets.swf");
         loadAssets(this._assetsUrlRequest);
         this._assetsUrlRequest = new URLRequest(this._moduleInfo.getPath() + "assets/seasonRewardsFaqAssets.swf");
         loadAssets(this._assetsUrlRequest);
      }
      
      public function getHideCompleted() : ISignal
      {
         return this._hideCompleted;
      }
      
      public function hide() : void
      {
         unloadAssets(this._assetsUrlRequest);
         this._hideCompleted.dispatch(this);
      }
      
      public function processRewardsAndInitialize() : void
      {
         var _loc3_:RewardModel = null;
         var _loc4_:String = null;
         var _loc5_:int = 0;
         var _loc6_:String = null;
         var _loc7_:String = null;
         var _loc10_:String = null;
         var _loc1_:String = DynamicClientConfigManager.getConfiguration(SeasonRewardsConfig.NAMESPACE,SeasonRewardsConfig.POINTS_PER_REWARD_LEVEL,null).getString();
         var _loc2_:Array = _loc1_ ? _loc1_.split(",") : [];
         var _loc8_:Vector.<RewardModel> = new Vector.<RewardModel>();
         var _loc9_:uint = 0;
         while(_loc9_ < _loc2_.length)
         {
            _loc5_ = parseInt(_loc2_[_loc9_]);
            _loc7_ = SeasonRewardsConfig.REWARD_ICONS[_loc9_ + 1];
            _loc10_ = String(_loc9_ + 1);
            _loc4_ = "reward" + _loc10_ + "_name";
            _loc6_ = "reward_desc";
            _loc3_ = new RewardModel(_loc4_,_loc5_,_loc6_,_loc7_);
            _loc8_.push(_loc3_);
            _loc9_++;
         }
         if(_loc2_.length > 0)
         {
            this._teamRewardsProgressView.clearRewards();
            for each(_loc3_ in _loc8_)
            {
               this._teamRewardsProgressView.addReward(_loc3_);
            }
            this.updateView();
         }
      }
      
      private function updateView() : void
      {
         var _loc1_:LeagueTier = null;
         var _loc2_:int = 0;
         if(LeagueConfig.isPreseason())
         {
            _loc1_ = LeagueTier.valueOf(Session.instance.summoner.previousSeasonHighestTier);
            _loc2_ = int(Session.instance.summoner.previousSeasonHighestTeamReward);
         }
         else
         {
            _loc1_ = LeagueTier.valueOf(this._provider.tierReward);
            _loc2_ = int(this._provider.teamRewardLevel);
         }
         this._tierRewardsProgressView.setRewardData(_loc1_,_loc2_,LeagueConfig.isPreseason());
         this._teamRewardsProgressView.setProgress(this._provider.teamReward,LeagueConfig.isPreseason());
      }
      
      override protected function initializeDependencies() : void
      {
         super.initializeDependencies();
         registerDependency(ILocaleHelper,new LocaleHelper());
         registerDependency(IToolTipManager,TipsProviderProxy.instance.createWindowToolTipManager(this));
      }
   }
}

