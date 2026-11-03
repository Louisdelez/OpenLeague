package com.riotgames.platform.gameclient.controllers.summoner
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.provider.ICLSProvider;
   import com.riotgames.platform.common.provider.IInventory;
   import com.riotgames.platform.common.provider.IInventoryController;
   import com.riotgames.platform.common.provider.IInventoryProvider;
   import com.riotgames.platform.common.provider.IRuneBookController;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.common.utils.MessageDictionary;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.buddyImages.BuddyImages;
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.gameclient.controllers.IViewController;
   import com.riotgames.platform.gameclient.domain.AggregatedStat;
   import com.riotgames.platform.gameclient.domain.AggregatedStatType;
   import com.riotgames.platform.gameclient.domain.AggregatedStats;
   import com.riotgames.platform.gameclient.domain.AllPublicSummonerDataDTO;
   import com.riotgames.platform.gameclient.domain.AllSummonerData;
   import com.riotgames.platform.gameclient.domain.BaseSummoner;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.ChampionStatInfo;
   import com.riotgames.platform.gameclient.domain.PlayerChampionStats;
   import com.riotgames.platform.gameclient.domain.PlayerGameStats;
   import com.riotgames.platform.gameclient.domain.PlayerLifetimeStats;
   import com.riotgames.platform.gameclient.domain.PlayerStatSummaries;
   import com.riotgames.platform.gameclient.domain.PlayerStats;
   import com.riotgames.platform.gameclient.domain.PublicSummoner;
   import com.riotgames.platform.gameclient.domain.Summoner;
   import com.riotgames.platform.gameclient.domain.SummonerLevel;
   import com.riotgames.platform.gameclient.domain.SummonerLevelAndPoints;
   import com.riotgames.platform.gameclient.domain.SummonerTalentsAndPoints;
   import com.riotgames.platform.gameclient.domain.game.CompetitiveSeason;
   import com.riotgames.platform.gameclient.domain.game.GameMode;
   import com.riotgames.platform.gameclient.domain.summoner.LevelUpInfo;
   import com.riotgames.platform.gameclient.utils.ChampionListUtil;
   import com.riotgames.platform.gameclient.views.summoner.stats.ChampionSummaryStatsData;
   import com.riotgames.platform.gameclient.views.summoner.stats.ProfileLifetimeStatsPresentationModel;
   import com.riotgames.platform.gameclient.views.summoner.stats.ProfileStatsSummaryPresentationModel;
   import com.riotgames.platform.provider.IProvider;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.platform.provider.proxy.IProviderProxy;
   import com.riotgames.pvpnet.rankedteams.IRankedTeamsProvider;
   import com.riotgames.pvpnet.rankedteams.RankedTeamsProviderProxy;
   import com.riotgames.pvpnet.summonerprofile.ISummonerProfileProvider;
   import com.riotgames.pvpnet.summonerprofile.ProfilePagesEnum;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.config.PlatformConfigProviderProxy;
   import com.riotgames.pvpnet.tracking.Dradis;
   import flash.display.BitmapData;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import flash.utils.getQualifiedClassName;
   import flash.utils.setTimeout;
   import mx.collections.ArrayCollection;
   import mx.collections.Sort;
   import mx.collections.SortField;
   import mx.events.PropertyChangeEvent;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.rpc.events.ResultEvent;
   
   public class SummonerProfileController implements IViewController, IProvider, ISummonerProfileProvider, IEventDispatcher
   {
      
      private static const VIEW_MY_MATCH_HISTORY:String = "sp_viewMyMatchHistory";
      
      private static const VIEW_OTHER_MATCH_HISTORY:String = "sp_viewOtherMatchHistory";
      
      public static const profilePages:Array = [ProfilePagesEnum.PROFILE_PAGE,ProfilePagesEnum.STATS_PAGE,ProfilePagesEnum.MATCH_HISTORY_PAGE,ProfilePagesEnum.CHARACTERS_PAGE,ProfilePagesEnum.RUNES_PAGE,ProfilePagesEnum.MASTERIES_PAGE,ProfilePagesEnum.SPELLS_PAGE,ProfilePagesEnum.CLS,ProfilePagesEnum.ITEMS_PAGE];
      
      public static const LIFETIME_STAT_STATE_STATS:int = 0;
      
      public static const LIFETIME_STAT_STAGE_GRAPH:int = 1;
      
      private var _currentState:String = "profilePage";
      
      private var _statsSummoner:BaseSummoner;
      
      private var _504377593summonerName:String;
      
      private var _1834022541levelUpInfo:LevelUpInfo;
      
      private var _1180619197isBusy:Boolean = false;
      
      private var _1201997067isSummonerInfoLoaded:Boolean = false;
      
      private var _768624076isSummonerStatsLoaded:Boolean = false;
      
      private var _1677587884isRunesLoaded:Boolean = false;
      
      private var _1626892049talentPoints:ArrayCollection;
      
      private var _2093131350lifetimeStats:ArrayCollection;
      
      private var _581949073playerStatSummaries:PlayerStatSummaries;
      
      private var _1489231293quickChampions:ArrayCollection;
      
      private var _832156267allChampionStats:ArrayCollection;
      
      private var _896064437spells:ArrayCollection = new ArrayCollection();
      
      private var _currentSummoner:Summoner = null;
      
      private var _currentSummonerChangedSignal:Signal = new Signal();
      
      public var summonerLevel:SummonerLevel = null;
      
      private var _270030021currentSummonerIconSource:BitmapData = null;
      
      private var _1588741225profileAcctId:Number;
      
      private var _isLocalSummoner:Boolean;
      
      private var _281365172isViewingOtherSummonerStats:Boolean;
      
      private var _1839054608totalGamesPlayed:Number;
      
      private var _1330205690promotionalGamesPlayed:Number;
      
      private var _960546869displayPromotionalGames:Boolean = false;
      
      private var _1347252708championWinCount:int = 0;
      
      public var clientConfig:ClientConfig;
      
      private var _baseSummoner:BaseSummoner;
      
      private var _championStatsChangedSignal:Signal = new Signal();
      
      private var _closeLeagueStatsSignal:Signal = new Signal();
      
      private var _serviceBusySignal:Signal = new Signal();
      
      private var concurrentServiceRequestCount:int;
      
      private var pendingState:String;
      
      private var isStatsLoaded:Boolean = false;
      
      public var session:Session;
      
      public var serviceProxy:ServiceProxy;
      
      public var profileLifetimeStatsPresentationModel:ProfileLifetimeStatsPresentationModel;
      
      public var profileStatsSummaryPresentationModel:ProfileStatsSummaryPresentationModel;
      
      private var _1019249940chatController:ChatController;
      
      private var _1690115777runeBookController:IRuneBookController;
      
      public var inventoryController:IInventoryController;
      
      private var leagueSystemProvider:ICLSProvider;
      
      private var inventory:IInventory;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var _1481639842championSummaryStats:Array;
      
      public var currentStatsSeason:int;
      
      private var championDetailId:Number;
      
      private var championDetailIds:Array = [];
      
      private var _525482994lifetimeStatsCurrentState:int = 0;
      
      private var _1607896001viewingMultipleChamps:Boolean = false;
      
      private var selectedStatId:String = "";
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      public function SummonerProfileController(param1:IInventory = null, param2:IInventoryController = null)
      {
         super();
         this.inventory = param1;
         this.inventoryController = param2;
         this.clientConfig = ClientConfig.instance;
         this.session = Session.instance;
         this.serviceProxy = ServiceProxy.instance;
         PlatformConfigProviderProxy.instance.getPlatformConfig().displayPromotionalGamesSet.add(this.onDisplayPromotionalGamesSet);
      }
      
      [Bindable(event="propertyChange")]
      public function get currentState() : String
      {
         return this._currentState;
      }
      
      private function set _1457822360currentState(param1:String) : void
      {
         this._currentState = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function get currentSummoner() : Summoner
      {
         return this._currentSummoner;
      }
      
      private function set _501625319currentSummoner(param1:Summoner) : void
      {
         this._currentSummoner = param1;
         this._currentSummonerChangedSignal.dispatch(param1);
      }
      
      public function getCurrentSummonerChangedSignal() : ISignal
      {
         return this._currentSummonerChangedSignal;
      }
      
      [Bindable(event="propertyChange")]
      public function get isLocalSummoner() : Boolean
      {
         return this._isLocalSummoner;
      }
      
      private function set _1021339441isLocalSummoner(param1:Boolean) : void
      {
         this._isLocalSummoner = param1;
      }
      
      public function get championStatsChanged() : Signal
      {
         return this._championStatsChangedSignal;
      }
      
      public function get closeLeagueStats() : Signal
      {
         return this._closeLeagueStatsSignal;
      }
      
      public function get baseSummoner() : BaseSummoner
      {
         return this._baseSummoner;
      }
      
      public function set baseSummoner(param1:BaseSummoner) : void
      {
         this._baseSummoner = param1;
         this._statsSummoner = param1;
         if(param1 != null)
         {
            this.summonerName = param1.name;
            this.profileAcctId = param1.acctId;
            this.currentSummonerIconSource = BuddyImages.getSummonerIconSafely(param1.profileIconId);
            this.refreshLeagueData();
            this.refreshSummonerData();
         }
         else
         {
            this.summonerName = null;
            this.profileAcctId = 0;
         }
      }
      
      private function onDisplayPromotionalGamesSet(param1:Boolean) : void
      {
         PlatformConfigProviderProxy.instance.getPlatformConfig().displayPromotionalGamesEnabledChanged.add(this.updateDisplayPromotionalGames);
         this.updateDisplayPromotionalGames(param1);
      }
      
      private function updateDisplayPromotionalGames(param1:Boolean) : void
      {
         this.displayPromotionalGames = param1;
      }
      
      public function initialize() : void
      {
         var _loc1_:LevelUpInfo = new LevelUpInfo();
         _loc1_.summonerName = "Not Yet Loaded";
         _loc1_.currentLevel = 12;
         _loc1_.nextLevel = 13;
         _loc1_.pointsEarned = 0;
         _loc1_.pointsNeededToLevelUp = 100;
         _loc1_.totalExperiencePoints = 50;
         this.summonerName = _loc1_.summonerName;
         this.levelUpInfo = _loc1_;
         this.talentPoints = new ArrayCollection();
         this.quickChampions = new ArrayCollection();
         this.concurrentServiceRequestCount = 0;
         if(!this.runeBookController)
         {
            this.getRuneBookController();
         }
         else
         {
            this.runeBookController.initialize();
         }
         if(!this.inventoryController)
         {
            ProviderLookup.getProvider(IInventoryProvider,this.onInventoryProvider);
         }
         if(!this.leagueSystemProvider)
         {
            this.getLeagueSystemProvider();
         }
         this.clientConfig.getLeagueServiceEnabledChanged().add(this.onLeagueServiceEnabledChanged);
         ProviderLookup.publishProvider(ISummonerProfileProvider,this);
      }
      
      private function getLeagueSystemProvider() : void
      {
         ProviderLookup.getProvider(ICLSProvider,this.onLeagueSystemProviderRetrieved);
      }
      
      private function onLeagueSystemProviderRetrieved(param1:ICLSProvider) : void
      {
         this.leagueSystemProvider = param1;
      }
      
      private function getRuneBookController() : void
      {
         ProviderLookup.getProvider(IRuneBookController,this.onRuneBookControllerRetrieved);
      }
      
      private function onRuneBookControllerRetrieved(param1:IRuneBookController) : void
      {
         this.runeBookController = param1;
         this.runeBookController.initialize();
      }
      
      private function onInventoryProvider(param1:IInventoryProvider) : void
      {
         this.inventory = param1.getInventory();
         this.inventoryController = param1.getInventoryController();
         this.setupAllChampionData();
      }
      
      public function cleanup() : void
      {
      }
      
      public function activate() : void
      {
      }
      
      public function deactivate() : void
      {
         this._closeLeagueStatsSignal.dispatch();
      }
      
      private function setSummoner(param1:Summoner, param2:SummonerLevel, param3:SummonerLevelAndPoints, param4:SummonerTalentsAndPoints) : void
      {
         this.currentSummoner = param1;
         this.currentSummoner.isMe = this.isLocalSummoner;
         this.currentSummonerIconSource = BuddyImages.getSummonerIconSafely(param1.profileIconId);
         var _loc5_:LevelUpInfo = new LevelUpInfo();
         _loc5_.summonerName = param1.name;
         if(param2 != null)
         {
            this.summonerLevel = param2;
            _loc5_.currentLevel = param2.summonerLevel;
            _loc5_.nextLevel = _loc5_.currentLevel + 1;
            _loc5_.pointsEarned = 0;
            _loc5_.totalExperiencePoints = param3.expPoints;
            _loc5_.pointsNeededToLevelUp = param2.expToNextLevel - _loc5_.totalExperiencePoints;
         }
         this.summonerName = _loc5_.summonerName;
         this.levelUpInfo = _loc5_;
         this.isSummonerInfoLoaded = true;
         this.isRunesLoaded = false;
         this.isStatsLoaded = false;
      }
      
      private function onServiceRequestComplete(param1:Boolean) : void
      {
         --this.concurrentServiceRequestCount;
         if(this.concurrentServiceRequestCount <= 0)
         {
            this.concurrentServiceRequestCount = 0;
            this.isBusy = false;
            if(this.pendingState != null)
            {
               this.setProfileState(this.pendingState);
               this.pendingState = null;
            }
         }
      }
      
      private function isChampionSummaryStat(param1:Object) : Boolean
      {
         return param1.championId != 0 && (param1.statType == AggregatedStatType.STAT_TYPE_WINS || param1.statType == AggregatedStatType.GAMES_PLAYED || param1.statType == AggregatedStatType.STAT_TYPE_TOTAL_CHAMPION_KILLS || param1.statType == AggregatedStatType.STAT_TYPE_TOTAL_CHAMPION_DEATHS || param1.statType == AggregatedStatType.TOTAL_ASSISTS);
      }
      
      private function isQuickViewStat(param1:Object) : Boolean
      {
         return param1.championId == 0 && (param1.statType == AggregatedStatType.STAT_TYPE_WINS || param1.statType == AggregatedStatType.STAT_TYPE_LOSSES || param1.statType == AggregatedStatType.STAT_TYPE_LEAVES);
      }
      
      private function filterOutTutorialGames(param1:PlayerGameStats) : Boolean
      {
         return param1.gameType != "TUTORIAL_GAME";
      }
      
      private function setupAllChampionData() : void
      {
         var _loc1_:ArrayCollection = null;
         var _loc2_:Champion = null;
         var _loc3_:Sort = null;
         var _loc4_:PlayerChampionStats = null;
         if(this.allChampionStats == null && Boolean(this.inventory))
         {
            _loc1_ = new ArrayCollection();
            for each(_loc2_ in this.inventory.championRegistry)
            {
               _loc4_ = new PlayerChampionStats();
               _loc4_.champion = _loc2_;
               _loc4_.owned = _loc2_.owned;
               _loc1_.addItem(_loc4_);
            }
            _loc3_ = new Sort();
            _loc3_.fields = [new SortField("totalGamesPlayed",false,true),new SortField("wins",false,true)];
            _loc1_.sort = _loc3_;
            _loc1_.refresh();
            this.allChampionStats = _loc1_;
         }
      }
      
      private function setupRecentChampionData(param1:ArrayCollection) : void
      {
         var _loc3_:ChampionStatInfo = null;
         var _loc4_:Sort = null;
         var _loc5_:PlayerChampionStats = null;
         var _loc2_:ArrayCollection = new ArrayCollection();
         for each(_loc3_ in param1)
         {
            _loc5_ = new PlayerChampionStats();
            _loc5_.champion = this.inventoryController.findChampionById(_loc3_.championId);
            if(_loc5_.champion != null)
            {
               _loc5_.updateFromChampionStats(_loc3_);
               _loc5_.owned = _loc5_.champion.owned;
               RiotResourceLoader.loadStatisticResourceStrings(_loc5_.stats);
               _loc2_.addItem(_loc5_);
            }
         }
         _loc4_ = new Sort();
         _loc4_.fields = [new SortField("totalGamesPlayed",false,true),new SortField("wins",false,true)];
         _loc2_.sort = _loc4_;
         if(Boolean(this.quickChampions))
         {
            _loc2_.filterFunction = this.quickChampions.filterFunction;
         }
         _loc2_.refresh();
         this.quickChampions = _loc2_;
      }
      
      private function get rankedTeamsProxy() : IProviderProxy
      {
         return RankedTeamsProviderProxy.instance;
      }
      
      private function get rankedTeamsProvider() : IRankedTeamsProvider
      {
         return RankedTeamsProviderProxy.instance;
      }
      
      private function onAllSummonerDataRetrieved(param1:ResultEvent) : void
      {
         var _loc2_:AllSummonerData = param1.result as AllSummonerData;
         if(Boolean(_loc2_))
         {
            if(this.rankedTeamsProxy.proxyLoaded)
            {
               this.rankedTeamsProvider.setViewableSummoner(_loc2_.summoner,_loc2_.summonerLevel);
            }
            this.setSummoner(_loc2_.summoner,_loc2_.summonerLevel,_loc2_.summonerLevelAndPoints,_loc2_.summonerTalentsAndPoints);
            this.isBusy = true;
            setTimeout(this.refreshSummonerDetails,300);
         }
      }
      
      private function onAllPublicSummonerDataRetrieved(param1:ResultEvent) : void
      {
         var _loc3_:IResourceManager = null;
         var _loc4_:AlertAction = null;
         var _loc5_:Summoner = null;
         var _loc2_:AllPublicSummonerDataDTO = param1.result as AllPublicSummonerDataDTO;
         if(_loc2_ == null)
         {
            _loc3_ = ResourceManager.getInstance();
            _loc4_ = new AlertAction(_loc3_.getString("resources",MessageDictionary.CONNECTION_FAILED_TITLE),_loc3_.getString("resources",MessageDictionary.REMOTE_SERVICE_REQUEST_TIMED_OUT));
            _loc4_.add();
         }
         else
         {
            _loc5_ = new Summoner();
            _loc5_.populate(_loc2_.summoner);
            if(this.rankedTeamsProxy.proxyLoaded)
            {
               this.rankedTeamsProvider.setViewableSummoner(_loc5_,_loc2_.summonerLevel);
            }
            this.setSummoner(_loc5_,_loc2_.summonerLevel,_loc2_.summonerLevelAndPoints,_loc2_.summonerTalentsAndPoints);
            this.isBusy = true;
            setTimeout(this.refreshSummonerDetails,300);
         }
      }
      
      private function findLifetimeStat(param1:String) : AggregatedStat
      {
         var _loc2_:AggregatedStat = null;
         var _loc3_:AggregatedStat = null;
         for each(_loc2_ in this.lifetimeStats)
         {
            if(param1 == _loc2_.statType)
            {
               return _loc2_;
            }
         }
         _loc3_ = new AggregatedStat();
         _loc3_.count = 0;
         _loc3_.value = 0;
         _loc3_.statType = param1;
         return _loc3_;
      }
      
      private function onRetrieveLifetimeStatsSuccess(param1:ResultEvent) : void
      {
         var _loc3_:String = null;
         var _loc2_:PlayerLifetimeStats = param1.result as PlayerLifetimeStats;
         if(_loc2_ == null)
         {
            _loc2_ = new PlayerLifetimeStats();
            _loc2_.playerStats = new PlayerStats();
         }
         _loc3_ = this.summonerName;
         this.profileStatsSummaryPresentationModel.setStats(_loc2_.playerStatSummaries,this.isLocalSummoner,_loc3_);
         this.playerStatSummaries = _loc2_.playerStatSummaries;
         this.promotionalGamesPlayed = _loc2_.playerStats.promoGamesPlayed;
         this.isSummonerStatsLoaded = true;
      }
      
      private function onRetrieveAggregatedStatsSuccess(param1:ResultEvent) : void
      {
         var _loc3_:Array = null;
         var _loc4_:AggregatedStat = null;
         var _loc5_:AggregatedStat = null;
         var _loc6_:AggregatedStat = null;
         var _loc7_:ChampionSummaryStatsData = null;
         var _loc2_:AggregatedStats = param1.result as AggregatedStats;
         if(_loc2_ != null)
         {
            this.lifetimeStats = _loc2_.lifetimeStatistics;
            RiotResourceLoader.loadStatisticResourceStrings(this.lifetimeStats);
            RiotResourceLoader.loadStatisticAndChampionResourceStrings(this.lifetimeStats,this.inventory.championIdMapping);
            this.lifetimeStats.filterFunction = this.isChampionSummaryStat;
            this.lifetimeStats.refresh();
            _loc3_ = new Array();
            this.championWinCount = 0;
            for each(_loc4_ in this.lifetimeStats)
            {
               _loc7_ = _loc3_[_loc4_.championId];
               if(_loc7_ == null)
               {
                  _loc7_ = new ChampionSummaryStatsData();
               }
               switch(_loc4_.statType)
               {
                  case AggregatedStatType.STAT_TYPE_WINS:
                     _loc7_.wins = _loc4_.value;
                     if(_loc7_.wins > 0)
                     {
                        ++this.championWinCount;
                     }
                     break;
                  case AggregatedStatType.GAMES_PLAYED:
                     _loc7_.totalGames = _loc4_.value;
                     break;
                  case AggregatedStatType.STAT_TYPE_TOTAL_CHAMPION_KILLS:
                     _loc7_.kills = _loc4_.value;
                     break;
                  case AggregatedStatType.STAT_TYPE_TOTAL_CHAMPION_DEATHS:
                     _loc7_.deaths = _loc4_.value;
                     break;
                  case AggregatedStatType.TOTAL_ASSISTS:
                     _loc7_.assists = _loc4_.value;
               }
               _loc7_.championId = _loc4_.championId;
               _loc3_[_loc4_.championId] = _loc7_;
            }
            this.championSummaryStats = _loc3_;
            this.lifetimeStats.filterFunction = this.isQuickViewStat;
            this.lifetimeStats.refresh();
            _loc5_ = this.findLifetimeStat(AggregatedStatType.STAT_TYPE_WINS);
            _loc6_ = this.findLifetimeStat(AggregatedStatType.STAT_TYPE_LOSSES);
            this.totalGamesPlayed = _loc5_.value + _loc6_.value;
            this.initializeTopPlayedChampionList();
            this.initializeLifetimeStats();
         }
         this.isStatsLoaded = true;
      }
      
      private function initializeTopPlayedChampionList() : void
      {
         ChampionListUtil.inventoryController = this.inventoryController;
         ChampionListUtil.championSummaryStats = this.championSummaryStats;
         ChampionListUtil.reset();
         this._championStatsChangedSignal.dispatch();
      }
      
      private function onRetrieveRecentChampionsSuccess(param1:ResultEvent) : void
      {
         this.setupRecentChampionData(param1.result as ArrayCollection);
      }
      
      protected function refreshSummonerData() : void
      {
         this.currentStatsSeason = 0;
         this.isBusy = true;
         this.setProfileState(ProfilePagesEnum.PROFILE_PAGE);
         this.lifetimeStats = null;
         this.isSummonerInfoLoaded = false;
         this.isLocalSummoner = this.profileAcctId == this.session.summoner.acctId;
         this.profileStatsSummaryPresentationModel.setStats(null,this.isLocalSummoner,this.summonerName);
         ++this.concurrentServiceRequestCount;
         if(this.isLocalSummoner)
         {
            this.serviceProxy.summonerService.getAllSummonerDataByAccount(this.profileAcctId,this.onAllSummonerDataRetrieved,this.onServiceRequestComplete);
         }
         else
         {
            this.serviceProxy.summonerService.getAllPublicSummonerDataByAccount(this.profileAcctId,this.onAllPublicSummonerDataRetrieved,this.onServiceRequestComplete);
         }
         this.isSummonerStatsLoaded = false;
         this.setupAllChampionData();
      }
      
      protected function refreshLeagueData() : void
      {
         if(Boolean(ClientConfig.instance.leagueServiceEnabled) && Boolean(this.leagueSystemProvider) && Boolean(this.baseSummoner))
         {
            this.leagueSystemProvider.loadDataForSummoner(this.baseSummoner.summonerId);
            this.leagueSystemProvider.currentSummoner = this.baseSummoner.name;
         }
      }
      
      private function onLeagueServiceEnabledChanged(param1:Boolean, param2:Boolean) : void
      {
         if(!param2)
         {
            this.serviceProxy.leagueService.cache.clearData();
         }
      }
      
      public function seeMoreStats(param1:BaseSummoner) : void
      {
         this.lifetimeStatsCurrentState = LIFETIME_STAT_STATE_STATS;
         if(this.isBusy)
         {
            this._serviceBusySignal.dispatch();
            return;
         }
         this.isBusy = true;
         this._statsSummoner = param1;
         this.updateStatsNewSummoner();
      }
      
      private function updateStatsNewSummoner() : void
      {
         this.isViewingOtherSummonerStats = this.statsSummoner.acctId == this.session.summoner.acctId;
         ++this.concurrentServiceRequestCount;
         if(this.currentStatsSeason == 0)
         {
            this.currentStatsSeason = CompetitiveSeason.currentSeason;
         }
         this.serviceProxy.playerStatsService.getAggregatedStats(this.statsSummoner.acctId,GameMode.CLASSIC,this.currentStatsSeason,this.onRetrieveAggregatedStatsSuccess,this.onServiceRequestComplete);
      }
      
      public function refreshSummonerDetails(param1:int = 0) : void
      {
         if(param1 == 0)
         {
            this.currentStatsSeason = CompetitiveSeason.currentSeason;
         }
         else
         {
            this.currentStatsSeason = param1;
         }
         ++this.concurrentServiceRequestCount;
         this.serviceProxy.playerStatsService.retrievePlayerStatsByAccountId(this.profileAcctId,this.currentStatsSeason,this.onRetrieveLifetimeStatsSuccess,this.onServiceRequestComplete);
         ++this.concurrentServiceRequestCount;
         this.serviceProxy.playerStatsService.retrieveTopPlayedChampions(this.profileAcctId,GameMode.CLASSIC,this.onRetrieveRecentChampionsSuccess,this.onServiceRequestComplete);
      }
      
      public function loadAggregatedStats(param1:int = 0) : void
      {
         if(param1 == 0)
         {
            this.currentStatsSeason = CompetitiveSeason.currentSeason;
         }
         else
         {
            this.currentStatsSeason = param1;
         }
         this.isBusy = true;
         ++this.concurrentServiceRequestCount;
         this.serviceProxy.playerStatsService.getAggregatedStats(this.statsSummoner.acctId,GameMode.CLASSIC,this.currentStatsSeason,this.onRetrieveAggregatedStatsSuccess,this.onServiceRequestComplete);
      }
      
      public function clickViewRuneBook(param1:Event) : void
      {
         this.setProfileState(ProfilePagesEnum.RUNES_PAGE);
      }
      
      public function clickViewAllChampions(param1:Event) : void
      {
         this.setProfileState(ProfilePagesEnum.CHARACTERS_PAGE);
      }
      
      public function setProfileState(param1:String, param2:Boolean = true) : void
      {
         if(param1 == this.currentState)
         {
            return;
         }
         if(param1 == ProfilePagesEnum.RUNES_PAGE)
         {
            this.runeBookController.editing = this.isLocalSummoner;
            this.runeBookController.combining = false;
            this.runeBookController.setSummonerData(this.currentSummoner,this.levelUpInfo.currentLevel);
         }
         if(this.currentState == ProfilePagesEnum.RUNES_PAGE)
         {
            this.runeBookController.deactivate();
         }
         if(param1 == ProfilePagesEnum.MASTERIES_PAGE)
         {
            if(this.isLocalSummoner)
            {
            }
         }
         else if(param1 == ProfilePagesEnum.MATCH_HISTORY_PAGE)
         {
            if(this.isLocalSummoner)
            {
               Dradis.track(VIEW_MY_MATCH_HISTORY);
            }
            else
            {
               Dradis.track(VIEW_OTHER_MATCH_HISTORY);
            }
         }
         this.currentState = param1;
      }
      
      public function profileViewChanged(param1:int) : void
      {
         this.setProfileState(profilePages[param1]);
      }
      
      public function setPendingState(param1:String) : void
      {
         this.pendingState = param1;
      }
      
      private function initializeLifetimeStats() : void
      {
         if(!this.lifetimeStats)
         {
            return;
         }
         this.viewingMultipleChamps = false;
         this.lifetimeStatsCurrentState = LIFETIME_STAT_STATE_STATS;
         this.championDetailId = 0;
         this.championDetailIds = [];
         this.lifetimeStats.filterFunction = this.filterLifetimeStats;
         this.lifetimeStats.refresh();
         this.profileLifetimeStatsPresentationModel.updateStats(this.inventoryController.findChampionById(this.championDetailId),this.lifetimeStats);
         this.isSummonerStatsLoaded = true;
      }
      
      private function filterLifetimeStats(param1:AggregatedStat) : Boolean
      {
         if(this.lifetimeStatsCurrentState == LIFETIME_STAT_STATE_STATS)
         {
            return this.championDetailId == param1.championId;
         }
         return param1.statType == this.selectedStatId && Boolean(this.championDetailIds[param1.championId]);
      }
      
      private function onUpdateSummonerStatsByName(param1:ResultEvent) : void
      {
         this.seeMoreStats(param1.result as PublicSummoner);
      }
      
      public function setLifetimeStatsState(param1:int) : void
      {
         this.lifetimeStatsCurrentState = param1;
         if(Boolean(this.lifetimeStats))
         {
            this.lifetimeStats.refresh();
         }
         if(this.lifetimeStatsCurrentState == LIFETIME_STAT_STATE_STATS)
         {
            this.profileLifetimeStatsPresentationModel.updateStats(this.inventoryController.findChampionById(this.championDetailId),this.lifetimeStats);
         }
      }
      
      public function viewChampionDetails(param1:Number, param2:Array) : void
      {
         var _loc3_:int = 0;
         var _loc4_:Boolean = false;
         this.championDetailId = param1;
         this.championDetailIds = param2;
         if(Boolean(this.lifetimeStats))
         {
            this.lifetimeStats.refresh();
         }
         if(this.lifetimeStatsCurrentState == LIFETIME_STAT_STATE_STATS)
         {
            this.profileLifetimeStatsPresentationModel.updateStats(this.inventoryController.findChampionById(this.championDetailId),this.lifetimeStats);
         }
         if(Boolean(param2))
         {
            _loc3_ = 0;
            for each(_loc4_ in param2)
            {
               _loc3_++;
               if(_loc3_ > 1)
               {
                  break;
               }
            }
            this.viewingMultipleChamps = _loc3_ > 1;
         }
         else
         {
            this.viewingMultipleChamps = false;
         }
      }
      
      public function setSelectedStat(param1:String) : void
      {
         this.selectedStatId = param1;
         if(Boolean(this.lifetimeStats))
         {
            this.lifetimeStats.refresh();
         }
      }
      
      public function updateStatsBySummonerName(param1:String) : void
      {
         this.serviceProxy.summonerService.getSummonerByName(param1,this.onUpdateSummonerStatsByName,null);
      }
      
      public function get statsSummoner() : BaseSummoner
      {
         if(Boolean(this._statsSummoner))
         {
            return this._statsSummoner;
         }
         return this._baseSummoner;
      }
      
      public function set statsSummoner(param1:BaseSummoner) : void
      {
         this._statsSummoner = param1;
      }
      
      public function get customSortedChampionList() : ArrayCollection
      {
         return ChampionListUtil.championList.sortedChampions;
      }
      
      public function get serviceBusySignal() : ISignal
      {
         return this._serviceBusySignal;
      }
      
      [Bindable(event="propertyChange")]
      public function get playerStatSummaries() : PlayerStatSummaries
      {
         return this._581949073playerStatSummaries;
      }
      
      public function set playerStatSummaries(param1:PlayerStatSummaries) : void
      {
         var _loc2_:Object = this._581949073playerStatSummaries;
         if(_loc2_ !== param1)
         {
            this._581949073playerStatSummaries = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"playerStatSummaries",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get isSummonerStatsLoaded() : Boolean
      {
         return this._768624076isSummonerStatsLoaded;
      }
      
      public function set isSummonerStatsLoaded(param1:Boolean) : void
      {
         var _loc2_:Object = this._768624076isSummonerStatsLoaded;
         if(_loc2_ !== param1)
         {
            this._768624076isSummonerStatsLoaded = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isSummonerStatsLoaded",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get viewingMultipleChamps() : Boolean
      {
         return this._1607896001viewingMultipleChamps;
      }
      
      public function set viewingMultipleChamps(param1:Boolean) : void
      {
         var _loc2_:Object = this._1607896001viewingMultipleChamps;
         if(_loc2_ !== param1)
         {
            this._1607896001viewingMultipleChamps = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"viewingMultipleChamps",_loc2_,param1));
            }
         }
      }
      
      public function set currentState(param1:String) : void
      {
         var _loc2_:Object = this.currentState;
         if(_loc2_ !== param1)
         {
            this._1457822360currentState = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"currentState",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get profileAcctId() : Number
      {
         return this._1588741225profileAcctId;
      }
      
      public function set profileAcctId(param1:Number) : void
      {
         var _loc2_:Object = this._1588741225profileAcctId;
         if(_loc2_ !== param1)
         {
            this._1588741225profileAcctId = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"profileAcctId",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get isRunesLoaded() : Boolean
      {
         return this._1677587884isRunesLoaded;
      }
      
      public function set isRunesLoaded(param1:Boolean) : void
      {
         var _loc2_:Object = this._1677587884isRunesLoaded;
         if(_loc2_ !== param1)
         {
            this._1677587884isRunesLoaded = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isRunesLoaded",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get isBusy() : Boolean
      {
         return this._1180619197isBusy;
      }
      
      public function set isBusy(param1:Boolean) : void
      {
         var _loc2_:Object = this._1180619197isBusy;
         if(_loc2_ !== param1)
         {
            this._1180619197isBusy = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isBusy",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get levelUpInfo() : LevelUpInfo
      {
         return this._1834022541levelUpInfo;
      }
      
      public function set levelUpInfo(param1:LevelUpInfo) : void
      {
         var _loc2_:Object = this._1834022541levelUpInfo;
         if(_loc2_ !== param1)
         {
            this._1834022541levelUpInfo = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"levelUpInfo",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get spells() : ArrayCollection
      {
         return this._896064437spells;
      }
      
      public function set spells(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._896064437spells;
         if(_loc2_ !== param1)
         {
            this._896064437spells = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"spells",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get championWinCount() : int
      {
         return this._1347252708championWinCount;
      }
      
      public function set championWinCount(param1:int) : void
      {
         var _loc2_:Object = this._1347252708championWinCount;
         if(_loc2_ !== param1)
         {
            this._1347252708championWinCount = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"championWinCount",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get totalGamesPlayed() : Number
      {
         return this._1839054608totalGamesPlayed;
      }
      
      public function set totalGamesPlayed(param1:Number) : void
      {
         var _loc2_:Object = this._1839054608totalGamesPlayed;
         if(_loc2_ !== param1)
         {
            this._1839054608totalGamesPlayed = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"totalGamesPlayed",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get lifetimeStatsCurrentState() : int
      {
         return this._525482994lifetimeStatsCurrentState;
      }
      
      public function set lifetimeStatsCurrentState(param1:int) : void
      {
         var _loc2_:Object = this._525482994lifetimeStatsCurrentState;
         if(_loc2_ !== param1)
         {
            this._525482994lifetimeStatsCurrentState = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lifetimeStatsCurrentState",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get runeBookController() : IRuneBookController
      {
         return this._1690115777runeBookController;
      }
      
      public function set runeBookController(param1:IRuneBookController) : void
      {
         var _loc2_:Object = this._1690115777runeBookController;
         if(_loc2_ !== param1)
         {
            this._1690115777runeBookController = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"runeBookController",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get championSummaryStats() : Array
      {
         return this._1481639842championSummaryStats;
      }
      
      public function set championSummaryStats(param1:Array) : void
      {
         var _loc2_:Object = this._1481639842championSummaryStats;
         if(_loc2_ !== param1)
         {
            this._1481639842championSummaryStats = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"championSummaryStats",_loc2_,param1));
            }
         }
      }
      
      public function set isLocalSummoner(param1:Boolean) : void
      {
         var _loc2_:Object = this.isLocalSummoner;
         if(_loc2_ !== param1)
         {
            this._1021339441isLocalSummoner = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isLocalSummoner",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get isViewingOtherSummonerStats() : Boolean
      {
         return this._281365172isViewingOtherSummonerStats;
      }
      
      public function set isViewingOtherSummonerStats(param1:Boolean) : void
      {
         var _loc2_:Object = this._281365172isViewingOtherSummonerStats;
         if(_loc2_ !== param1)
         {
            this._281365172isViewingOtherSummonerStats = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isViewingOtherSummonerStats",_loc2_,param1));
            }
         }
      }
      
      public function set currentSummoner(param1:Summoner) : void
      {
         var _loc2_:Object = this.currentSummoner;
         if(_loc2_ !== param1)
         {
            this._501625319currentSummoner = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"currentSummoner",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get quickChampions() : ArrayCollection
      {
         return this._1489231293quickChampions;
      }
      
      public function set quickChampions(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1489231293quickChampions;
         if(_loc2_ !== param1)
         {
            this._1489231293quickChampions = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"quickChampions",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get isSummonerInfoLoaded() : Boolean
      {
         return this._1201997067isSummonerInfoLoaded;
      }
      
      public function set isSummonerInfoLoaded(param1:Boolean) : void
      {
         var _loc2_:Object = this._1201997067isSummonerInfoLoaded;
         if(_loc2_ !== param1)
         {
            this._1201997067isSummonerInfoLoaded = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isSummonerInfoLoaded",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get allChampionStats() : ArrayCollection
      {
         return this._832156267allChampionStats;
      }
      
      public function set allChampionStats(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._832156267allChampionStats;
         if(_loc2_ !== param1)
         {
            this._832156267allChampionStats = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"allChampionStats",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get displayPromotionalGames() : Boolean
      {
         return this._960546869displayPromotionalGames;
      }
      
      public function set displayPromotionalGames(param1:Boolean) : void
      {
         var _loc2_:Object = this._960546869displayPromotionalGames;
         if(_loc2_ !== param1)
         {
            this._960546869displayPromotionalGames = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"displayPromotionalGames",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get chatController() : ChatController
      {
         return this._1019249940chatController;
      }
      
      public function set chatController(param1:ChatController) : void
      {
         var _loc2_:Object = this._1019249940chatController;
         if(_loc2_ !== param1)
         {
            this._1019249940chatController = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"chatController",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get lifetimeStats() : ArrayCollection
      {
         return this._2093131350lifetimeStats;
      }
      
      public function set lifetimeStats(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._2093131350lifetimeStats;
         if(_loc2_ !== param1)
         {
            this._2093131350lifetimeStats = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lifetimeStats",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get talentPoints() : ArrayCollection
      {
         return this._1626892049talentPoints;
      }
      
      public function set talentPoints(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1626892049talentPoints;
         if(_loc2_ !== param1)
         {
            this._1626892049talentPoints = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"talentPoints",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get currentSummonerIconSource() : BitmapData
      {
         return this._270030021currentSummonerIconSource;
      }
      
      public function set currentSummonerIconSource(param1:BitmapData) : void
      {
         var _loc2_:Object = this._270030021currentSummonerIconSource;
         if(_loc2_ !== param1)
         {
            this._270030021currentSummonerIconSource = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"currentSummonerIconSource",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get promotionalGamesPlayed() : Number
      {
         return this._1330205690promotionalGamesPlayed;
      }
      
      public function set promotionalGamesPlayed(param1:Number) : void
      {
         var _loc2_:Object = this._1330205690promotionalGamesPlayed;
         if(_loc2_ !== param1)
         {
            this._1330205690promotionalGamesPlayed = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"promotionalGamesPlayed",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get summonerName() : String
      {
         return this._504377593summonerName;
      }
      
      public function set summonerName(param1:String) : void
      {
         var _loc2_:Object = this._504377593summonerName;
         if(_loc2_ !== param1)
         {
            this._504377593summonerName = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerName",_loc2_,param1));
            }
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
   }
}

