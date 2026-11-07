package com.riotgames.pvpnet.CLS
{
   import blix.action.IAction;
   import blix.assets.proxy.DisplayAdapter;
   import blix.context.IContext;
   import blix.signals.Signal;
   import com.riotgames.platform.common.provider.ICLSProvider;
   import com.riotgames.platform.common.provider.ILeagueDataProvider;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.common.services.lcdsproxy.ILcdsProxyMessageRouter;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.common.utils.decode.IDecode;
   import com.riotgames.platform.common.utils.decode.JSONDecoder;
   import com.riotgames.platform.common.utils.encode.IEncode;
   import com.riotgames.platform.common.utils.encode.JSONEncoder;
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.gameclient.chat.IChatProvider;
   import com.riotgames.platform.gameclient.domain.summoner.LevelUpInfo;
   import com.riotgames.platform.gameclient.leagues.LeagueUpdateItem;
   import com.riotgames.platform.gameclient.notification.ClientNotificationProxyServiceName;
   import com.riotgames.platform.gameclient.services.IBaseLcdsService;
   import com.riotgames.platform.provider.IProviderModule;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.platform.provider.ProviderModuleInfo;
   import com.riotgames.pvpnet.CLS.commands.LeagueUpdatePopupCommand;
   import com.riotgames.pvpnet.CLS.controllers.ILeagueDecayMessageController;
   import com.riotgames.pvpnet.CLS.controllers.LeagueDecayMessageController;
   import com.riotgames.pvpnet.CLS.controllers.LeagueSystemModuleController;
   import com.riotgames.pvpnet.CLS.dataprovider.ILeagueDataProviderLocal;
   import com.riotgames.pvpnet.CLS.dataprovider.LeagueDataProvider;
   import com.riotgames.pvpnet.CLS.factory.ILeaguesActionFactory;
   import com.riotgames.pvpnet.CLS.factory.LeaguesActionFactory;
   import com.riotgames.pvpnet.CLS.localeHelper.ILocaleHelper;
   import com.riotgames.pvpnet.CLS.localeHelper.LocaleHelper;
   import com.riotgames.pvpnet.CLS.managers.ILeagueSystemModuleNavigation;
   import com.riotgames.pvpnet.CLS.managers.LeagueSystemModuleNavigation;
   import com.riotgames.pvpnet.CLS.services.LeaguesService;
   import com.riotgames.pvpnet.CLS.views.LeagueSystemModuleView;
   import com.riotgames.pvpnet.CLS.views.helpers.ISummonerHelper;
   import com.riotgames.pvpnet.CLS.views.helpers.SummonerHelper;
   import com.riotgames.pvpnet.game.controllers.SpectatorController;
   import com.riotgames.pvpnet.rankedteams.IRankedTeamsProvider;
   import com.riotgames.pvpnet.seasonrewards.ISeasonRewardsProvider;
   import com.riotgames.pvpnet.seasonrewards.configuration.SeasonRewardsConfig;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.config.cdc.ConfigurationModel;
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
   import com.riotgames.pvpnet.system.localization.action.LoadModuleResourceBundleAction;
   import com.riotgames.pvpnet.system.notification.ClientNotificationProviderProxy;
   import com.riotgames.pvpnet.system.notification.IClientNotificationProvider;
   import com.riotgames.rust.components.sidebar.INestedScreen;
   import com.riotgames.rust.module.RiotModuleRoot;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   
   [SWF(width="500", height="375", backgroundColor="#ffffff", frameRate="24")]
   public class ClientModuleLeagueSystemIron extends RiotModuleRoot implements IProviderModule, ICLSProvider
   {
      
      private var _spectatorController:SpectatorController;
      
      private var _moduleInfo:ProviderModuleInfo;
      
      private var _controller:LeagueSystemModuleController;
      
      private var _leagueDataProvider:LeagueDataProvider;
      
      private var _leagueSystemModuleNavigation:LeagueSystemModuleNavigation;
      
      private var _seasonRewardsProvider:ISeasonRewardsProvider;
      
      private var _seasonRewardsEnabled:ConfigurationModel;
      
      private var _chat:ChatController;
      
      private var _instance:LeagueSystemModuleView;
      
      private var _lobbySignal:Signal = new Signal();
      
      private var _statsSignal:Signal = new Signal();
      
      private var _leagueUpdateMessageReceivedSignal:Signal = new Signal();
      
      private var _shouldRefreshInstance:Boolean = false;
      
      private var _parent:DisplayAdapter;
      
      private var _summonerHelper:SummonerHelper;
      
      public function ClientModuleLeagueSystemIron()
      {
         super();
      }
      
      public function initializeModule(param1:ProviderModuleInfo) : void
      {
         this._moduleInfo = param1;
         ProviderLookup.getProvider(IChatProvider,this.onChatProvider);
         ProviderLookup.getProvider(ISeasonRewardsProvider,this.onSeasonRewardsProvider);
         this.loadLocalizations();
      }
      
      public function getCLS(param1:IContext) : INestedScreen
      {
         this._controller = new LeagueSystemModuleController(this,this._leagueDataProvider,this._lobbySignal,this._statsSignal,this._chat);
         if(this._instance == null)
         {
            this._instance = new LeagueSystemModuleView(this,this._moduleInfo);
         }
         return this._instance;
      }
      
      public function show(param1:DisplayAdapter) : void
      {
         this._parent = param1;
         if(this._shouldRefreshInstance)
         {
            this.loadDataForSummoner(Session.instance.summoner.summonerId);
         }
         if(this._controller == null)
         {
            this._controller = new LeagueSystemModuleController(this,this._leagueDataProvider,this._lobbySignal,this._statsSignal,this._chat);
         }
         if(this._instance == null || this._shouldRefreshInstance)
         {
            this._instance = new LeagueSystemModuleView(this,this._moduleInfo);
            if(this._shouldRefreshInstance)
            {
               this._shouldRefreshInstance = false;
            }
         }
         this._instance.isParchment = true;
         this._instance.show();
         this._parent.addChild(this._instance);
      }
      
      public function hide(param1:DisplayAdapter) : void
      {
         if(this._instance != null && this._parent != null)
         {
            this._instance.hide();
            this._parent.removeChild(this._instance);
         }
      }
      
      public function loadDataForSummoner(param1:Number) : void
      {
         this._leagueDataProvider.getLeaguesFromSummoner(param1,isNaN(param1));
      }
      
      public function get lobbySignal() : Signal
      {
         return this._lobbySignal;
      }
      
      public function get statsSignal() : Signal
      {
         return this._statsSignal;
      }
      
      public function get leagueUpdateMessageReceivedSignal() : Signal
      {
         return this._leagueUpdateMessageReceivedSignal;
      }
      
      public function processDecayMessages() : void
      {
         var _loc1_:ILeagueDecayMessageController = getDependency(ILeagueDecayMessageController);
         _loc1_.processDecayMessages(ServiceProxy.instance.leagueService.cache.myLeagueStandings);
      }
      
      public function getTeamProfileDecayMessages(param1:String) : Object
      {
         var _loc2_:ILeagueDecayMessageController = getDependency(ILeagueDecayMessageController);
         return _loc2_.getProfileScreenDecayMessage("RANKED_TEAM_5x5",param1);
      }
      
      public function processLatestMessage(param1:Object) : Boolean
      {
         var _loc2_:ILocaleHelper = getDependency(ILocaleHelper);
         if(!param1.hasOwnProperty("notifyReason") || !param1.hasOwnProperty("leagueItem"))
         {
            logger.error("Malformed league message update recieved.");
            return false;
         }
         if(this._instance == null)
         {
            this._instance = new LeagueSystemModuleView(this,this._moduleInfo);
         }
         this._instance.loadCeremonyAssets();
         var _loc3_:LeagueUpdateItem = new LeagueUpdateItem();
         _loc3_.fillDataFromPayload(param1["notifyReason"],param1["leagueItem"],param1["leaguePointsDelta"],param1["gameId"]);
         _loc3_.leagueName = _loc2_.getLeagueName(_loc3_.leagueName);
         var _loc4_:LeagueDecayMessageController = getDependency(ILeagueDecayMessageController);
         var _loc5_:LeagueUpdatePopupCommand = new LeagueUpdatePopupCommand(_loc3_,_loc4_,this._instance);
         _loc5_.execute();
         this._leagueUpdateMessageReceivedSignal.dispatch(_loc3_);
         this._shouldRefreshInstance = true;
         if(param1["notifyReason"] == LeagueUpdateItem.LEAGUE_POINTS_UPDATE || param1["notifyReason"] == LeagueUpdateItem.NOT_YET_SEEDED)
         {
            return false;
         }
         return true;
      }
      
      public function preInitialize() : void
      {
         if(this._instance == null)
         {
            this._instance = new LeagueSystemModuleView(this,this._moduleInfo);
         }
      }
      
      override protected function initializeDependencies() : void
      {
         super.initializeDependencies();
         this._leagueDataProvider = new LeagueDataProvider();
         this._leagueSystemModuleNavigation = new LeagueSystemModuleNavigation();
         this._seasonRewardsEnabled = DynamicClientConfigManager.getConfiguration(SeasonRewardsConfig.NAMESPACE,SeasonRewardsConfig.ENABLED,false,this.onSeasonRewardsEnabledChanged);
         this.onSeasonRewardsEnabledChanged();
         registerDependency(ILeagueSystemModuleNavigation,this._leagueSystemModuleNavigation);
         registerDependency(ILocaleHelper,new LocaleHelper());
         registerDependency(ISummonerHelper,new SummonerHelper());
         registerDependency(ILeagueDecayMessageController,new LeagueDecayMessageController());
         registerDependency(ILeagueDataProviderLocal,this._leagueDataProvider);
         var _loc1_:IEncode = new JSONEncoder();
         var _loc2_:IDecode = new JSONDecoder();
         var _loc3_:IClientNotificationProvider = ClientNotificationProviderProxy.instance;
         var _loc4_:ILcdsProxyMessageRouter = _loc3_.getLcdsProxyMessageRouter();
         var _loc5_:IBaseLcdsService = ServiceProxy.instance.lcdsService;
         var _loc6_:LeaguesService = new LeaguesService(_loc5_,_loc2_);
         _loc4_.setServiceCallListener(ClientNotificationProxyServiceName.SPECTATOR,_loc6_);
         var _loc7_:ILeaguesActionFactory = new LeaguesActionFactory(_loc6_,_loc1_,_loc2_);
         registerDependency(ILeaguesActionFactory,_loc7_);
         ProviderLookup.getProvider(IRankedTeamsProvider,this.onRankedTeamsAvailable);
      }
      
      private function onRankedTeamsAvailable(param1:IRankedTeamsProvider) : void
      {
         registerDependency(IRankedTeamsProvider,param1);
      }
      
      private function onSeasonRewardsEnabledChanged() : void
      {
         var _loc2_:String = null;
         var _loc1_:Boolean = Boolean(this._seasonRewardsEnabled.getBoolean());
         this._leagueDataProvider.seasonRewardsEnabled = _loc1_;
         if(_loc1_)
         {
            _loc2_ = DynamicClientConfigManager.getConfiguration(SeasonRewardsConfig.NAMESPACE,SeasonRewardsConfig.POINTS_PER_REWARD_LEVEL,null).getString();
            if(!_loc2_ || _loc2_.split(",").length <= 1)
            {
               _loc1_ = false;
            }
         }
         this._leagueSystemModuleNavigation.setLeagueOverviewEnabled(_loc1_);
      }
      
      private function loadLocalizations() : void
      {
         var _loc1_:String = ClientConfig.instance.locale;
         var _loc2_:IResourceManager = ResourceManager.getInstance();
         var _loc3_:IAction = new LoadModuleResourceBundleAction(_loc2_,_loc1_,"LeagueSystemIron","LeagueSystemIron","lsi",ClientConfig.instance.debugLocale);
         _loc3_.getCompleted().addOnce(this.onLoadResourceBundleComplete);
         _loc3_.invoke();
         RiotResourceLoader.registerFlatFile("LeagueNames",this._moduleInfo.getPath() + "assets/leagueNames/{0}/LeagueNames.properties");
      }
      
      private function onChatProvider(param1:IChatProvider) : void
      {
         this._chat = param1 as ChatController;
         this._leagueDataProvider.chatController = this._chat;
      }
      
      private function onSeasonRewardsProvider(param1:ISeasonRewardsProvider) : void
      {
         this._seasonRewardsProvider = param1;
         if(this._leagueSystemModuleNavigation.getLeagueOverviewEnabled())
         {
            if(Session.instance.levelUpInfo != null && Session.instance.levelUpInfo.currentLevel == LevelUpInfo.MAX_LEVEL)
            {
               this._seasonRewardsProvider.showInformationPopup();
            }
            else
            {
               Session.instance.getLevelUpInfoChanged().add(this.onLevelUpInfoChanged);
            }
         }
      }
      
      private function onLevelUpInfoChanged() : void
      {
         if(Boolean(this._seasonRewardsEnabled.getValue()) && Session.instance.levelUpInfo.currentLevel == LevelUpInfo.MAX_LEVEL)
         {
            this._seasonRewardsProvider.showInformationPopup();
         }
      }
      
      private function onLoadResourceBundleComplete() : void
      {
         ProviderLookup.publishProvider(ICLSProvider,this);
         ProviderLookup.publishProvider(ILeagueDataProvider,this._leagueDataProvider);
      }
      
      public function set currentSummoner(param1:String) : void
      {
         var _loc2_:String = param1;
         if(!this._summonerHelper)
         {
            this._summonerHelper = getDependency(ISummonerHelper);
         }
         this._summonerHelper.currentSummoner = _loc2_;
      }
   }
}

