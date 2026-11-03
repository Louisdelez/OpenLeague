package com.riotgames.pvpnet.system.config
{
   import blix.signals.ISignal;
   import blix.signals.OnceSignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.utils.MultiValueProperty;
   import com.riotgames.platform.gameclient.domain.game.CompetitiveSeason;
   import com.riotgames.platform.gameclient.domain.systemstates.ReplaySystemStates;
   import flash.desktop.NativeApplication;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.events.PropertyChangeEvent;
   import mx.resources.Locale;
   
   public class ClientConfig extends EventDispatcher
   {
      
      private static var _instance:ClientConfig;
      
      public static const LOCALES_PATH:String = "assets/locale";
      
      public static const JABBER_DOMAIN:String = "pvp.net";
      
      public static const SPECIAL_MODE_TENCENT:String = "tencent";
      
      public static const SPECIAL_MODE_GARENA:String = "garena";
      
      private static var _staticBindingEventDispatcher:EventDispatcher = new EventDispatcher();
      
      private var _338410841locales:Array = [];
      
      private var _377380641servicesMode:uint = 1;
      
      private var _1690020690ekg_uri:String = "";
      
      private var _1987384754debugDradis:Boolean = false;
      
      private var _110320277bypassClientMinPlayersCheck:Boolean;
      
      private var _1784195260enableSummonerWizard:Boolean = true;
      
      private var _1097462182locale:String = "en_US";
      
      private var _1102234638clientMode:String;
      
      private var _regionTag:String = "na";
      
      private var _currentLocale:Locale;
      
      private var _1761065331debugLocale:Boolean;
      
      private var _85904877environment:String = "";
      
      private var _1223060252webHost:String = "signup.leagueoflegends.com";
      
      private var _1193516193loginUsername:String;
      
      private var _1097413176cacheSummonerNames:Boolean = true;
      
      private var _852462441startFakeGame:String = "false";
      
      private var _1152586552savePassword:Boolean = false;
      
      private var _1456626398enablePlaytimeReminderOverride:Boolean = false;
      
      private var _1632554711enableKeybinding:Boolean = false;
      
      private var _1327886693enableEditSummoner:Boolean = false;
      
      private var _606137427enableMatchmaking:Boolean = true;
      
      private var _1334538994maxPracticeGameSize:int;
      
      private var _1647392528championTradeThroughLCDS:Boolean = true;
      
      private var _322064536observerModeEnabled:Boolean = false;
      
      private var _862509441advancedTutorialEnabled:Boolean = true;
      
      private var _326560026socialIntegrationEnabled:Boolean = false;
      
      private var _709188897runeUniquePerSpellBook:Boolean = false;
      
      private var _439899558tribunalEnabled:Boolean = true;
      
      private var _2112415698spectatorSlotLimit:int = 1;
      
      private var _1111259484archivedStatsEnabled:Boolean = false;
      
      private var _54604709observableGameModes:ArrayCollection;
      
      private var _1771732522observableCustomGameModes:String;
      
      private var _435851845sendFeedbackEventsEnabled:Boolean = false;
      
      private var _localeSpecificChatRoomsEnabled:Boolean = false;
      
      private var _localeSpecificChatRoomsEnabledChanged:Signal = new Signal();
      
      private var _localeSpecificChatRoomsSet:Signal = new OnceSignal();
      
      private var _minNumPlayersForPracticeGame:int;
      
      private var _minNumPlayersForPracticeGameChanged:Signal = new Signal();
      
      private var _practiceGamesEnabledChanged:Signal = new Signal();
      
      private var _practiceGamesEnabled:Boolean = true;
      
      private var _knownGeographicGameServerRegionsChanged:Signal = new Signal();
      
      private var _knownGeographicGameServerRegions:ArrayCollection = null;
      
      private var _teamServiceEnabledChanged:Signal = new Signal();
      
      private var _teamServiceEnabled:Boolean = true;
      
      private var _leagueServiceEnabledChanged:Signal = new Signal();
      
      private var _leagueServiceEnabled:Boolean = false;
      
      private var _leaguesDecayMessagingEnabledChanged:Signal = new Signal();
      
      private var _leaguesDecayMessagingEnabled:Boolean = false;
      
      private var _itemSetServiceEnabledChanged:Signal = new Signal();
      
      private var _itemSetServiceEnabled:Boolean = false;
      
      private var _325513249showItemSets:Boolean = true;
      
      private var _844987882showItemSetSharing:Boolean = false;
      
      private var _1157211201matchHistoryTest:Boolean = false;
      
      private var _1893029577enableNPLP:Boolean = false;
      
      private var _853891315platform_to_game_chat:Boolean = true;
      
      private var _938538536rafUrl:String = null;
      
      private var _2129802534startChat:Boolean = true;
      
      private var _1625857000useOldProfileContainer:Boolean = true;
      
      private var _1899579676useNewEogChat:Boolean = false;
      
      private var _836077871useANE:Boolean = false;
      
      private var _1284542788disconnect_logging:Boolean = true;
      
      private var _1856940123showTierRewards:Boolean = true;
      
      private var _839387354buddyNotesEnabled:Boolean = false;
      
      private var _storeEnabled:Boolean = false;
      
      private var _storeEnabledChanged:Signal = new Signal();
      
      private var _569070327idleThreshold:Number = 600;
      
      private var _527640384helpEnabled:Boolean = false;
      
      private var _616320949minimumPlayersPerGame:uint = 1;
      
      private var _1557980326enableNewAccountPopulate:Boolean = false;
      
      private var _161624339autoResizeWindow:Boolean = true;
      
      private var _595619514storeUrlOverride:String = null;
      
      private var _enableFileLogTargetChanged:Signal = new Signal();
      
      private var _enableFileLogTarget:Boolean = true;
      
      private var _1859995903enableXMPPFileLogTarget:Boolean = false;
      
      private var _2063040591logRetentionDays:int = 5;
      
      private var _2120712743logSubmissionDays:int = 2;
      
      private var _10634241mailHost:String = "mx4.riotgames.com";
      
      private var _10395944mailPort:int = 2099;
      
      private var _234292070submitLogsToEmailAddress:String = "aclog@mx4.riotgames.com";
      
      private var _877195206submitErrorReportFromEmailAddress:String = "errorReports@riotgames.com";
      
      private var _1270231748featuredGamesURL:String;
      
      private var _1321158207replayServiceURL:String;
      
      private var _440001135replaySystemStatesOverrides:ConfigOverrides = new ConfigOverrides();
      
      private var _replaySystemStates:ReplaySystemStates;
      
      private var _replaySystemStatesChanged:Signal = new Signal();
      
      private var _1794117061lobbyAdvertURL:String;
      
      private var _1133050349ladderURL:String;
      
      private var _729889195storyPageURL:String;
      
      private var _805807726helpURL:String;
      
      private var _219269221reportAPlayerAvailable:Boolean;
      
      private var _lobbyLandingURLChanged:Signal = new Signal();
      
      private var _lobbyLandingURL:String;
      
      private var _485253720enableChatDebugWindow:Boolean = false;
      
      private var _1690914038enableSendingLogFiles:Boolean = false;
      
      private var _1518327835languages:ArrayCollection;
      
      private var _1175041091showLanguageChoices:Boolean;
      
      private var _1018322668partnerCredentials:String = null;
      
      private var _2022833208bootToDev:Boolean = false;
      
      private var _558759356isDevSandbox:Boolean = false;
      
      private var _104385ime:String;
      
      private var _platformId:String = "not_initialized";
      
      private var _1566131258showTeamHistory:Boolean = true;
      
      private var _828123707showTeamStats:Boolean = true;
      
      private var _1722048267minimizeTurnedOff:Boolean = false;
      
      private var _564302456reportingSampleRate:int = 100;
      
      private var _2019604275suppressLocaleLoading:Boolean = false;
      
      private var _364805805tournamentSendStatsEnabled:Boolean = false;
      
      private var _1204670525tournamentSupportAvailable:Boolean = false;
      
      private var _1759553964riotDataServiceDataSendProbability:Number = 0;
      
      private var _1011937437trackLoggedErrorsProbability:Number = 0.05;
      
      private var _1245954399maxErrorsToTrack:int = 1000;
      
      private var _1388251518trackServiceTrafficProbability:Number = 0.05;
      
      private var _844884202trackUncaughtErrorsProbability:Number = 0.05;
      
      private var _2131370883maxUncaughtErrorsPerSession:int = 20;
      
      private var _1099570341userFlowTrackingProbability:Number = 0.01;
      
      private var _198209540userFlowMaxEvents:int = 500;
      
      private var _1226790634userFlowCooldownMs:int = 100;
      
      private var _1721083431userFlowCooldownMaxEvents:int = 2;
      
      private var _1952520688playerPreferencesSyncing:Boolean = true;
      
      private var _339388763kudosPullNotifications:Boolean = true;
      
      private var _applicationBaseName:String;
      
      private var _477746289bexecutablePath:String = "";
      
      private var _477315369bexecutableArgs:MultiValueProperty = new MultiValueProperty();
      
      private var _2035745094preloadGameClient:Boolean = false;
      
      private var _1865069802enableEogStatsSavingToFile:Boolean = false;
      
      private var _1231497930eogStatsSavingFolder:String = "eog_debug";
      
      private var _1323675011eogStatsSavingFileName:String = "eogStats_";
      
      private var _732357827debugMessageQueue:Boolean = false;
      
      public function ClientConfig(param1:SingletonEnforcer)
      {
         super();
      }
      
      public static function get instance() : ClientConfig
      {
         if(_instance == null)
         {
            _instance = new ClientConfig(new SingletonEnforcer());
         }
         return _instance;
      }
      
      public static function get staticEventDispatcher() : IEventDispatcher
      {
         return _staticBindingEventDispatcher;
      }
      
      public function get regionTag() : String
      {
         return this._regionTag;
      }
      
      private function set _74337286regionTag(param1:String) : void
      {
         this._regionTag = param1;
      }
      
      public function get currentLocale() : Locale
      {
         if(this._currentLocale == null)
         {
            this._currentLocale = new Locale(this.locale);
         }
         return this._currentLocale;
      }
      
      public function get localeSpecificChatRoomsEnabledChanged() : ISignal
      {
         return this._localeSpecificChatRoomsEnabledChanged;
      }
      
      public function get localeSpecificChatRoomsSet() : ISignal
      {
         return this._localeSpecificChatRoomsSet;
      }
      
      public function get localeSpecificChatRoomsEnabled() : Boolean
      {
         return this._localeSpecificChatRoomsEnabled;
      }
      
      private function set _840748435localeSpecificChatRoomsEnabled(param1:Boolean) : void
      {
         this._localeSpecificChatRoomsEnabled = param1;
         this._localeSpecificChatRoomsEnabledChanged.dispatch(param1);
         this._localeSpecificChatRoomsSet.dispatch(param1);
      }
      
      public function getMinNumPlayersForPracticeGameChanged() : ISignal
      {
         return this._minNumPlayersForPracticeGameChanged;
      }
      
      public function get minNumPlayersForPracticeGame() : int
      {
         return this._minNumPlayersForPracticeGame;
      }
      
      private function set _917263336minNumPlayersForPracticeGame(param1:int) : void
      {
         var _loc2_:int = 0;
         if(param1 != this._minNumPlayersForPracticeGame)
         {
            _loc2_ = this._minNumPlayersForPracticeGame;
            this._minNumPlayersForPracticeGame = param1;
            this._minNumPlayersForPracticeGameChanged.dispatch(_loc2_,param1);
         }
      }
      
      public function getPracticeGamesEnabledChanged() : ISignal
      {
         return this._practiceGamesEnabledChanged;
      }
      
      public function get practiceGamesEnabled() : Boolean
      {
         return this._practiceGamesEnabled;
      }
      
      private function set _640460261practiceGamesEnabled(param1:Boolean) : void
      {
         var _loc2_:Boolean = false;
         if(this._practiceGamesEnabled != param1)
         {
            _loc2_ = this._practiceGamesEnabled;
            this._practiceGamesEnabled = param1;
            this._practiceGamesEnabledChanged.dispatch(_loc2_,param1);
         }
      }
      
      public function getknownGeographicGameServerRegionsChanged() : ISignal
      {
         return this._knownGeographicGameServerRegionsChanged;
      }
      
      public function get knownGeographicGameServerRegions() : ArrayCollection
      {
         return this._knownGeographicGameServerRegions;
      }
      
      private function set _374633840knownGeographicGameServerRegions(param1:ArrayCollection) : void
      {
         this._knownGeographicGameServerRegions = param1;
         this._knownGeographicGameServerRegionsChanged.dispatch(param1);
      }
      
      public function getteamServiceEnabledChanged() : ISignal
      {
         return this._teamServiceEnabledChanged;
      }
      
      public function get teamServiceEnabled() : Boolean
      {
         return this._teamServiceEnabled;
      }
      
      private function set _1968865655teamServiceEnabled(param1:Boolean) : void
      {
         var _loc2_:Boolean = false;
         if(this._teamServiceEnabled != param1)
         {
            _loc2_ = this._teamServiceEnabled;
            this._teamServiceEnabled = param1;
            this._teamServiceEnabledChanged.dispatch(_loc2_,param1);
         }
      }
      
      public function getLeagueServiceEnabledChanged() : ISignal
      {
         return this._leagueServiceEnabledChanged;
      }
      
      public function get leagueServiceEnabled() : Boolean
      {
         return this._leagueServiceEnabled;
      }
      
      private function set _1110341339leagueServiceEnabled(param1:Boolean) : void
      {
         var _loc2_:Boolean = false;
         if(this._leagueServiceEnabled != param1)
         {
            _loc2_ = this._leagueServiceEnabled;
            this._leagueServiceEnabled = param1;
            this._leagueServiceEnabledChanged.dispatch(_loc2_,param1);
         }
      }
      
      public function leaguesDecayMessagingEnabledChanged() : ISignal
      {
         return this._leaguesDecayMessagingEnabledChanged;
      }
      
      public function get leaguesDecayMessagingEnabled() : Boolean
      {
         return this._leaguesDecayMessagingEnabled;
      }
      
      private function set _1223033267leaguesDecayMessagingEnabled(param1:Boolean) : void
      {
         var _loc2_:Boolean = false;
         if(this._leaguesDecayMessagingEnabled != param1)
         {
            _loc2_ = this._leaguesDecayMessagingEnabled;
            this._leaguesDecayMessagingEnabled = param1;
            this._leaguesDecayMessagingEnabledChanged.dispatch(_loc2_,param1);
         }
      }
      
      public function getItemSetServiceEnabledChanged() : ISignal
      {
         return this._itemSetServiceEnabledChanged;
      }
      
      public function get itemSetServiceEnabled() : Boolean
      {
         return this._itemSetServiceEnabled;
      }
      
      private function set _1102546693itemSetServiceEnabled(param1:Boolean) : void
      {
         var _loc2_:Boolean = false;
         if(this._itemSetServiceEnabled != param1)
         {
            _loc2_ = this._itemSetServiceEnabled;
            this._itemSetServiceEnabled = param1;
            this._itemSetServiceEnabledChanged.dispatch(_loc2_,param1);
         }
      }
      
      public function getStoreEnabledChanged() : ISignal
      {
         return this._storeEnabledChanged;
      }
      
      public function get storeEnabled() : Boolean
      {
         return this._storeEnabled;
      }
      
      private function set _572613856storeEnabled(param1:Boolean) : void
      {
         var _loc2_:Boolean = false;
         if(param1 != this._storeEnabled)
         {
            _loc2_ = this._storeEnabled;
            this._storeEnabled = param1;
            this._storeEnabledChanged.dispatch(_loc2_,param1);
         }
      }
      
      private function set _2066000452currentSeason(param1:int) : void
      {
         CompetitiveSeason.currentSeason = param1;
      }
      
      public function get currentSeason() : int
      {
         return CompetitiveSeason.currentSeason;
      }
      
      public function getEnableFileLogTargetChanged() : ISignal
      {
         return this._enableFileLogTargetChanged;
      }
      
      public function get enableFileLogTarget() : Boolean
      {
         return this._enableFileLogTarget;
      }
      
      private function set _130771734enableFileLogTarget(param1:Boolean) : void
      {
         var _loc2_:Boolean = false;
         if(param1 != this._enableFileLogTarget)
         {
            _loc2_ = this._enableFileLogTarget;
            this._enableFileLogTarget = param1;
            this._enableFileLogTargetChanged.dispatch(_loc2_,param1);
         }
      }
      
      public function getReplaySystemStatesChanged() : ISignal
      {
         return this._replaySystemStatesChanged;
      }
      
      public function get replaySystemStates() : ReplaySystemStates
      {
         if(this._replaySystemStates == null)
         {
            this.setReplaySystemStates(new ReplaySystemStates());
         }
         return this._replaySystemStates;
      }
      
      public function setReplaySystemStates(param1:ReplaySystemStates) : void
      {
         var _loc2_:ReplaySystemStates = null;
         if(this.replaySystemStatesOverrides.hasOverrides())
         {
            this.replaySystemStatesOverrides.overrideProperties(param1);
         }
         if(param1 != this._replaySystemStates)
         {
            _loc2_ = this._replaySystemStates;
            this._replaySystemStates = param1;
            this._replaySystemStatesChanged.dispatch(_loc2_,param1);
         }
      }
      
      public function getLobbyLandingURLChanged() : ISignal
      {
         return this._lobbyLandingURLChanged;
      }
      
      public function get lobbyLandingURL() : String
      {
         return this._lobbyLandingURL;
      }
      
      private function set _836020302lobbyLandingURL(param1:String) : void
      {
         var _loc2_:String = null;
         if(param1 != this._lobbyLandingURL)
         {
            _loc2_ = this._lobbyLandingURL;
            this._lobbyLandingURL = param1;
            this._lobbyLandingURLChanged.dispatch(_loc2_,param1);
         }
      }
      
      public function get platformId() : String
      {
         return this._platformId;
      }
      
      private function set _1980047598platformId(param1:String) : void
      {
         if(param1 != this._platformId)
         {
            this._platformId = param1;
         }
      }
      
      public function get DISCONNECT_LOGGING_PROP() : Boolean
      {
         return this.disconnect_logging;
      }
      
      public function get CACHE_SUMMONER_NAMES_PROP() : Boolean
      {
         return this.cacheSummonerNames;
      }
      
      public function get START_CHAT_PROP() : Boolean
      {
         return this.startChat;
      }
      
      public function get START_FAKE_GAME_PROP() : Boolean
      {
         return this.startFakeGame == "true";
      }
      
      public function get AUTO_RESIZE_WINDOW() : Boolean
      {
         return this.autoResizeWindow;
      }
      
      public function get applicationBaseName() : String
      {
         if(!this._applicationBaseName || this._applicationBaseName == "")
         {
            this._applicationBaseName = NativeApplication.nativeApplication.applicationID;
         }
         return this._applicationBaseName;
      }
      
      public function get localePrefix() : String
      {
         return String(this.locale.split("_")[0]);
      }
      
      [Bindable(event="propertyChange")]
      public function get maxErrorsToTrack() : int
      {
         return this._1245954399maxErrorsToTrack;
      }
      
      public function set maxErrorsToTrack(param1:int) : void
      {
         var _loc2_:Object = this._1245954399maxErrorsToTrack;
         if(_loc2_ !== param1)
         {
            this._1245954399maxErrorsToTrack = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"maxErrorsToTrack",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get tournamentSendStatsEnabled() : Boolean
      {
         return this._364805805tournamentSendStatsEnabled;
      }
      
      public function set tournamentSendStatsEnabled(param1:Boolean) : void
      {
         var _loc2_:Object = this._364805805tournamentSendStatsEnabled;
         if(_loc2_ !== param1)
         {
            this._364805805tournamentSendStatsEnabled = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"tournamentSendStatsEnabled",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get mailPort() : int
      {
         return this._10395944mailPort;
      }
      
      public function set mailPort(param1:int) : void
      {
         var _loc2_:Object = this._10395944mailPort;
         if(_loc2_ !== param1)
         {
            this._10395944mailPort = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mailPort",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get userFlowCooldownMaxEvents() : int
      {
         return this._1721083431userFlowCooldownMaxEvents;
      }
      
      public function set userFlowCooldownMaxEvents(param1:int) : void
      {
         var _loc2_:Object = this._1721083431userFlowCooldownMaxEvents;
         if(_loc2_ !== param1)
         {
            this._1721083431userFlowCooldownMaxEvents = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"userFlowCooldownMaxEvents",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get socialIntegrationEnabled() : Boolean
      {
         return this._326560026socialIntegrationEnabled;
      }
      
      public function set socialIntegrationEnabled(param1:Boolean) : void
      {
         var _loc2_:Object = this._326560026socialIntegrationEnabled;
         if(_loc2_ !== param1)
         {
            this._326560026socialIntegrationEnabled = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"socialIntegrationEnabled",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get trackUncaughtErrorsProbability() : Number
      {
         return this._844884202trackUncaughtErrorsProbability;
      }
      
      public function set trackUncaughtErrorsProbability(param1:Number) : void
      {
         var _loc2_:Object = this._844884202trackUncaughtErrorsProbability;
         if(_loc2_ !== param1)
         {
            this._844884202trackUncaughtErrorsProbability = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"trackUncaughtErrorsProbability",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set teamServiceEnabled(param1:Boolean) : void
      {
         var _loc2_:Object = this.teamServiceEnabled;
         if(_loc2_ !== param1)
         {
            this._1968865655teamServiceEnabled = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"teamServiceEnabled",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get spectatorSlotLimit() : int
      {
         return this._2112415698spectatorSlotLimit;
      }
      
      public function set spectatorSlotLimit(param1:int) : void
      {
         var _loc2_:Object = this._2112415698spectatorSlotLimit;
         if(_loc2_ !== param1)
         {
            this._2112415698spectatorSlotLimit = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"spectatorSlotLimit",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get showLanguageChoices() : Boolean
      {
         return this._1175041091showLanguageChoices;
      }
      
      public function set showLanguageChoices(param1:Boolean) : void
      {
         var _loc2_:Object = this._1175041091showLanguageChoices;
         if(_loc2_ !== param1)
         {
            this._1175041091showLanguageChoices = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"showLanguageChoices",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get helpURL() : String
      {
         return this._805807726helpURL;
      }
      
      public function set helpURL(param1:String) : void
      {
         var _loc2_:Object = this._805807726helpURL;
         if(_loc2_ !== param1)
         {
            this._805807726helpURL = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"helpURL",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get languages() : ArrayCollection
      {
         return this._1518327835languages;
      }
      
      public function set languages(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1518327835languages;
         if(_loc2_ !== param1)
         {
            this._1518327835languages = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"languages",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set lobbyLandingURL(param1:String) : void
      {
         var _loc2_:Object = this.lobbyLandingURL;
         if(_loc2_ !== param1)
         {
            this._836020302lobbyLandingURL = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lobbyLandingURL",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get showTeamHistory() : Boolean
      {
         return this._1566131258showTeamHistory;
      }
      
      public function set showTeamHistory(param1:Boolean) : void
      {
         var _loc2_:Object = this._1566131258showTeamHistory;
         if(_loc2_ !== param1)
         {
            this._1566131258showTeamHistory = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"showTeamHistory",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get isDevSandbox() : Boolean
      {
         return this._558759356isDevSandbox;
      }
      
      public function set isDevSandbox(param1:Boolean) : void
      {
         var _loc2_:Object = this._558759356isDevSandbox;
         if(_loc2_ !== param1)
         {
            this._558759356isDevSandbox = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isDevSandbox",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get tribunalEnabled() : Boolean
      {
         return this._439899558tribunalEnabled;
      }
      
      public function set tribunalEnabled(param1:Boolean) : void
      {
         var _loc2_:Object = this._439899558tribunalEnabled;
         if(_loc2_ !== param1)
         {
            this._439899558tribunalEnabled = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"tribunalEnabled",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get ekg_uri() : String
      {
         return this._1690020690ekg_uri;
      }
      
      public function set ekg_uri(param1:String) : void
      {
         var _loc2_:Object = this._1690020690ekg_uri;
         if(_loc2_ !== param1)
         {
            this._1690020690ekg_uri = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ekg_uri",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set regionTag(param1:String) : void
      {
         var _loc2_:Object = this.regionTag;
         if(_loc2_ !== param1)
         {
            this._74337286regionTag = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"regionTag",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get userFlowTrackingProbability() : Number
      {
         return this._1099570341userFlowTrackingProbability;
      }
      
      public function set userFlowTrackingProbability(param1:Number) : void
      {
         var _loc2_:Object = this._1099570341userFlowTrackingProbability;
         if(_loc2_ !== param1)
         {
            this._1099570341userFlowTrackingProbability = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"userFlowTrackingProbability",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get showItemSetSharing() : Boolean
      {
         return this._844987882showItemSetSharing;
      }
      
      public function set showItemSetSharing(param1:Boolean) : void
      {
         var _loc2_:Object = this._844987882showItemSetSharing;
         if(_loc2_ !== param1)
         {
            this._844987882showItemSetSharing = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"showItemSetSharing",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get reportAPlayerAvailable() : Boolean
      {
         return this._219269221reportAPlayerAvailable;
      }
      
      public function set reportAPlayerAvailable(param1:Boolean) : void
      {
         var _loc2_:Object = this._219269221reportAPlayerAvailable;
         if(_loc2_ !== param1)
         {
            this._219269221reportAPlayerAvailable = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"reportAPlayerAvailable",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get advancedTutorialEnabled() : Boolean
      {
         return this._862509441advancedTutorialEnabled;
      }
      
      public function set advancedTutorialEnabled(param1:Boolean) : void
      {
         var _loc2_:Object = this._862509441advancedTutorialEnabled;
         if(_loc2_ !== param1)
         {
            this._862509441advancedTutorialEnabled = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"advancedTutorialEnabled",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get enableEogStatsSavingToFile() : Boolean
      {
         return this._1865069802enableEogStatsSavingToFile;
      }
      
      public function set enableEogStatsSavingToFile(param1:Boolean) : void
      {
         var _loc2_:Object = this._1865069802enableEogStatsSavingToFile;
         if(_loc2_ !== param1)
         {
            this._1865069802enableEogStatsSavingToFile = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"enableEogStatsSavingToFile",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get platform_to_game_chat() : Boolean
      {
         return this._853891315platform_to_game_chat;
      }
      
      public function set platform_to_game_chat(param1:Boolean) : void
      {
         var _loc2_:Object = this._853891315platform_to_game_chat;
         if(_loc2_ !== param1)
         {
            this._853891315platform_to_game_chat = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"platform_to_game_chat",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get idleThreshold() : Number
      {
         return this._569070327idleThreshold;
      }
      
      public function set idleThreshold(param1:Number) : void
      {
         var _loc2_:Object = this._569070327idleThreshold;
         if(_loc2_ !== param1)
         {
            this._569070327idleThreshold = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"idleThreshold",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get championTradeThroughLCDS() : Boolean
      {
         return this._1647392528championTradeThroughLCDS;
      }
      
      public function set championTradeThroughLCDS(param1:Boolean) : void
      {
         var _loc2_:Object = this._1647392528championTradeThroughLCDS;
         if(_loc2_ !== param1)
         {
            this._1647392528championTradeThroughLCDS = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"championTradeThroughLCDS",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get webHost() : String
      {
         return this._1223060252webHost;
      }
      
      public function set webHost(param1:String) : void
      {
         var _loc2_:Object = this._1223060252webHost;
         if(_loc2_ !== param1)
         {
            this._1223060252webHost = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"webHost",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get enableNewAccountPopulate() : Boolean
      {
         return this._1557980326enableNewAccountPopulate;
      }
      
      public function set enableNewAccountPopulate(param1:Boolean) : void
      {
         var _loc2_:Object = this._1557980326enableNewAccountPopulate;
         if(_loc2_ !== param1)
         {
            this._1557980326enableNewAccountPopulate = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"enableNewAccountPopulate",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get maxUncaughtErrorsPerSession() : int
      {
         return this._2131370883maxUncaughtErrorsPerSession;
      }
      
      public function set maxUncaughtErrorsPerSession(param1:int) : void
      {
         var _loc2_:Object = this._2131370883maxUncaughtErrorsPerSession;
         if(_loc2_ !== param1)
         {
            this._2131370883maxUncaughtErrorsPerSession = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"maxUncaughtErrorsPerSession",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get debugDradis() : Boolean
      {
         return this._1987384754debugDradis;
      }
      
      public function set debugDradis(param1:Boolean) : void
      {
         var _loc2_:Object = this._1987384754debugDradis;
         if(_loc2_ !== param1)
         {
            this._1987384754debugDradis = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"debugDradis",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get useANE() : Boolean
      {
         return this._836077871useANE;
      }
      
      public function set useANE(param1:Boolean) : void
      {
         var _loc2_:Object = this._836077871useANE;
         if(_loc2_ !== param1)
         {
            this._836077871useANE = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"useANE",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get bexecutablePath() : String
      {
         return this._477746289bexecutablePath;
      }
      
      public function set bexecutablePath(param1:String) : void
      {
         var _loc2_:Object = this._477746289bexecutablePath;
         if(_loc2_ !== param1)
         {
            this._477746289bexecutablePath = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bexecutablePath",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set platformId(param1:String) : void
      {
         var _loc2_:Object = this.platformId;
         if(_loc2_ !== param1)
         {
            this._1980047598platformId = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"platformId",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get userFlowCooldownMs() : int
      {
         return this._1226790634userFlowCooldownMs;
      }
      
      public function set userFlowCooldownMs(param1:int) : void
      {
         var _loc2_:Object = this._1226790634userFlowCooldownMs;
         if(_loc2_ !== param1)
         {
            this._1226790634userFlowCooldownMs = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"userFlowCooldownMs",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set storeEnabled(param1:Boolean) : void
      {
         var _loc2_:Object = this.storeEnabled;
         if(_loc2_ !== param1)
         {
            this._572613856storeEnabled = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"storeEnabled",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get storyPageURL() : String
      {
         return this._729889195storyPageURL;
      }
      
      public function set storyPageURL(param1:String) : void
      {
         var _loc2_:Object = this._729889195storyPageURL;
         if(_loc2_ !== param1)
         {
            this._729889195storyPageURL = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"storyPageURL",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get clientMode() : String
      {
         return this._1102234638clientMode;
      }
      
      public function set clientMode(param1:String) : void
      {
         var _loc2_:Object = this._1102234638clientMode;
         if(_loc2_ !== param1)
         {
            this._1102234638clientMode = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"clientMode",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get enableSummonerWizard() : Boolean
      {
         return this._1784195260enableSummonerWizard;
      }
      
      public function set enableSummonerWizard(param1:Boolean) : void
      {
         var _loc2_:Object = this._1784195260enableSummonerWizard;
         if(_loc2_ !== param1)
         {
            this._1784195260enableSummonerWizard = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"enableSummonerWizard",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get savePassword() : Boolean
      {
         return this._1152586552savePassword;
      }
      
      public function set savePassword(param1:Boolean) : void
      {
         var _loc2_:Object = this._1152586552savePassword;
         if(_loc2_ !== param1)
         {
            this._1152586552savePassword = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"savePassword",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get logSubmissionDays() : int
      {
         return this._2120712743logSubmissionDays;
      }
      
      public function set logSubmissionDays(param1:int) : void
      {
         var _loc2_:Object = this._2120712743logSubmissionDays;
         if(_loc2_ !== param1)
         {
            this._2120712743logSubmissionDays = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"logSubmissionDays",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get showTeamStats() : Boolean
      {
         return this._828123707showTeamStats;
      }
      
      public function set showTeamStats(param1:Boolean) : void
      {
         var _loc2_:Object = this._828123707showTeamStats;
         if(_loc2_ !== param1)
         {
            this._828123707showTeamStats = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"showTeamStats",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get autoResizeWindow() : Boolean
      {
         return this._161624339autoResizeWindow;
      }
      
      public function set autoResizeWindow(param1:Boolean) : void
      {
         var _loc2_:Object = this._161624339autoResizeWindow;
         if(_loc2_ !== param1)
         {
            this._161624339autoResizeWindow = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"autoResizeWindow",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set localeSpecificChatRoomsEnabled(param1:Boolean) : void
      {
         var _loc2_:Object = this.localeSpecificChatRoomsEnabled;
         if(_loc2_ !== param1)
         {
            this._840748435localeSpecificChatRoomsEnabled = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"localeSpecificChatRoomsEnabled",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get servicesMode() : uint
      {
         return this._377380641servicesMode;
      }
      
      public function set servicesMode(param1:uint) : void
      {
         var _loc2_:Object = this._377380641servicesMode;
         if(_loc2_ !== param1)
         {
            this._377380641servicesMode = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"servicesMode",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get enableKeybinding() : Boolean
      {
         return this._1632554711enableKeybinding;
      }
      
      public function set enableKeybinding(param1:Boolean) : void
      {
         var _loc2_:Object = this._1632554711enableKeybinding;
         if(_loc2_ !== param1)
         {
            this._1632554711enableKeybinding = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"enableKeybinding",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get maxPracticeGameSize() : int
      {
         return this._1334538994maxPracticeGameSize;
      }
      
      public function set maxPracticeGameSize(param1:int) : void
      {
         var _loc2_:Object = this._1334538994maxPracticeGameSize;
         if(_loc2_ !== param1)
         {
            this._1334538994maxPracticeGameSize = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"maxPracticeGameSize",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get minimumPlayersPerGame() : uint
      {
         return this._616320949minimumPlayersPerGame;
      }
      
      public function set minimumPlayersPerGame(param1:uint) : void
      {
         var _loc2_:Object = this._616320949minimumPlayersPerGame;
         if(_loc2_ !== param1)
         {
            this._616320949minimumPlayersPerGame = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"minimumPlayersPerGame",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get mailHost() : String
      {
         return this._10634241mailHost;
      }
      
      public function set mailHost(param1:String) : void
      {
         var _loc2_:Object = this._10634241mailHost;
         if(_loc2_ !== param1)
         {
            this._10634241mailHost = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mailHost",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get partnerCredentials() : String
      {
         return this._1018322668partnerCredentials;
      }
      
      public function set partnerCredentials(param1:String) : void
      {
         var _loc2_:Object = this._1018322668partnerCredentials;
         if(_loc2_ !== param1)
         {
            this._1018322668partnerCredentials = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"partnerCredentials",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get helpEnabled() : Boolean
      {
         return this._527640384helpEnabled;
      }
      
      public function set helpEnabled(param1:Boolean) : void
      {
         var _loc2_:Object = this._527640384helpEnabled;
         if(_loc2_ !== param1)
         {
            this._527640384helpEnabled = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"helpEnabled",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get tournamentSupportAvailable() : Boolean
      {
         return this._1204670525tournamentSupportAvailable;
      }
      
      public function set tournamentSupportAvailable(param1:Boolean) : void
      {
         var _loc2_:Object = this._1204670525tournamentSupportAvailable;
         if(_loc2_ !== param1)
         {
            this._1204670525tournamentSupportAvailable = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"tournamentSupportAvailable",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get enableSendingLogFiles() : Boolean
      {
         return this._1690914038enableSendingLogFiles;
      }
      
      public function set enableSendingLogFiles(param1:Boolean) : void
      {
         var _loc2_:Object = this._1690914038enableSendingLogFiles;
         if(_loc2_ !== param1)
         {
            this._1690914038enableSendingLogFiles = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"enableSendingLogFiles",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get trackLoggedErrorsProbability() : Number
      {
         return this._1011937437trackLoggedErrorsProbability;
      }
      
      public function set trackLoggedErrorsProbability(param1:Number) : void
      {
         var _loc2_:Object = this._1011937437trackLoggedErrorsProbability;
         if(_loc2_ !== param1)
         {
            this._1011937437trackLoggedErrorsProbability = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"trackLoggedErrorsProbability",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get logRetentionDays() : int
      {
         return this._2063040591logRetentionDays;
      }
      
      public function set logRetentionDays(param1:int) : void
      {
         var _loc2_:Object = this._2063040591logRetentionDays;
         if(_loc2_ !== param1)
         {
            this._2063040591logRetentionDays = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"logRetentionDays",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get riotDataServiceDataSendProbability() : Number
      {
         return this._1759553964riotDataServiceDataSendProbability;
      }
      
      public function set riotDataServiceDataSendProbability(param1:Number) : void
      {
         var _loc2_:Object = this._1759553964riotDataServiceDataSendProbability;
         if(_loc2_ !== param1)
         {
            this._1759553964riotDataServiceDataSendProbability = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"riotDataServiceDataSendProbability",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set currentSeason(param1:int) : void
      {
         var _loc2_:Object = this.currentSeason;
         if(_loc2_ !== param1)
         {
            this._2066000452currentSeason = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"currentSeason",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get lobbyAdvertURL() : String
      {
         return this._1794117061lobbyAdvertURL;
      }
      
      public function set lobbyAdvertURL(param1:String) : void
      {
         var _loc2_:Object = this._1794117061lobbyAdvertURL;
         if(_loc2_ !== param1)
         {
            this._1794117061lobbyAdvertURL = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lobbyAdvertURL",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set knownGeographicGameServerRegions(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this.knownGeographicGameServerRegions;
         if(_loc2_ !== param1)
         {
            this._374633840knownGeographicGameServerRegions = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"knownGeographicGameServerRegions",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get storeUrlOverride() : String
      {
         return this._595619514storeUrlOverride;
      }
      
      public function set storeUrlOverride(param1:String) : void
      {
         var _loc2_:Object = this._595619514storeUrlOverride;
         if(_loc2_ !== param1)
         {
            this._595619514storeUrlOverride = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"storeUrlOverride",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get minimizeTurnedOff() : Boolean
      {
         return this._1722048267minimizeTurnedOff;
      }
      
      public function set minimizeTurnedOff(param1:Boolean) : void
      {
         var _loc2_:Object = this._1722048267minimizeTurnedOff;
         if(_loc2_ !== param1)
         {
            this._1722048267minimizeTurnedOff = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"minimizeTurnedOff",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get useOldProfileContainer() : Boolean
      {
         return this._1625857000useOldProfileContainer;
      }
      
      public function set useOldProfileContainer(param1:Boolean) : void
      {
         var _loc2_:Object = this._1625857000useOldProfileContainer;
         if(_loc2_ !== param1)
         {
            this._1625857000useOldProfileContainer = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"useOldProfileContainer",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get debugMessageQueue() : Boolean
      {
         return this._732357827debugMessageQueue;
      }
      
      public function set debugMessageQueue(param1:Boolean) : void
      {
         var _loc2_:Object = this._732357827debugMessageQueue;
         if(_loc2_ !== param1)
         {
            this._732357827debugMessageQueue = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"debugMessageQueue",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get bootToDev() : Boolean
      {
         return this._2022833208bootToDev;
      }
      
      public function set bootToDev(param1:Boolean) : void
      {
         var _loc2_:Object = this._2022833208bootToDev;
         if(_loc2_ !== param1)
         {
            this._2022833208bootToDev = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bootToDev",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get observerModeEnabled() : Boolean
      {
         return this._322064536observerModeEnabled;
      }
      
      public function set observerModeEnabled(param1:Boolean) : void
      {
         var _loc2_:Object = this._322064536observerModeEnabled;
         if(_loc2_ !== param1)
         {
            this._322064536observerModeEnabled = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"observerModeEnabled",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get showItemSets() : Boolean
      {
         return this._325513249showItemSets;
      }
      
      public function set showItemSets(param1:Boolean) : void
      {
         var _loc2_:Object = this._325513249showItemSets;
         if(_loc2_ !== param1)
         {
            this._325513249showItemSets = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"showItemSets",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get runeUniquePerSpellBook() : Boolean
      {
         return this._709188897runeUniquePerSpellBook;
      }
      
      public function set runeUniquePerSpellBook(param1:Boolean) : void
      {
         var _loc2_:Object = this._709188897runeUniquePerSpellBook;
         if(_loc2_ !== param1)
         {
            this._709188897runeUniquePerSpellBook = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"runeUniquePerSpellBook",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get ladderURL() : String
      {
         return this._1133050349ladderURL;
      }
      
      public function set ladderURL(param1:String) : void
      {
         var _loc2_:Object = this._1133050349ladderURL;
         if(_loc2_ !== param1)
         {
            this._1133050349ladderURL = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ladderURL",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set minNumPlayersForPracticeGame(param1:int) : void
      {
         var _loc2_:Object = this.minNumPlayersForPracticeGame;
         if(_loc2_ !== param1)
         {
            this._917263336minNumPlayersForPracticeGame = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"minNumPlayersForPracticeGame",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get buddyNotesEnabled() : Boolean
      {
         return this._839387354buddyNotesEnabled;
      }
      
      public function set buddyNotesEnabled(param1:Boolean) : void
      {
         var _loc2_:Object = this._839387354buddyNotesEnabled;
         if(_loc2_ !== param1)
         {
            this._839387354buddyNotesEnabled = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"buddyNotesEnabled",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get showTierRewards() : Boolean
      {
         return this._1856940123showTierRewards;
      }
      
      public function set showTierRewards(param1:Boolean) : void
      {
         var _loc2_:Object = this._1856940123showTierRewards;
         if(_loc2_ !== param1)
         {
            this._1856940123showTierRewards = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"showTierRewards",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get ime() : String
      {
         return this._104385ime;
      }
      
      public function set ime(param1:String) : void
      {
         var _loc2_:Object = this._104385ime;
         if(_loc2_ !== param1)
         {
            this._104385ime = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"ime",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get trackServiceTrafficProbability() : Number
      {
         return this._1388251518trackServiceTrafficProbability;
      }
      
      public function set trackServiceTrafficProbability(param1:Number) : void
      {
         var _loc2_:Object = this._1388251518trackServiceTrafficProbability;
         if(_loc2_ !== param1)
         {
            this._1388251518trackServiceTrafficProbability = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"trackServiceTrafficProbability",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set practiceGamesEnabled(param1:Boolean) : void
      {
         var _loc2_:Object = this.practiceGamesEnabled;
         if(_loc2_ !== param1)
         {
            this._640460261practiceGamesEnabled = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"practiceGamesEnabled",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set enableFileLogTarget(param1:Boolean) : void
      {
         var _loc2_:Object = this.enableFileLogTarget;
         if(_loc2_ !== param1)
         {
            this._130771734enableFileLogTarget = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"enableFileLogTarget",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get loginUsername() : String
      {
         return this._1193516193loginUsername;
      }
      
      public function set loginUsername(param1:String) : void
      {
         var _loc2_:Object = this._1193516193loginUsername;
         if(_loc2_ !== param1)
         {
            this._1193516193loginUsername = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"loginUsername",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get bypassClientMinPlayersCheck() : Boolean
      {
         return this._110320277bypassClientMinPlayersCheck;
      }
      
      public function set bypassClientMinPlayersCheck(param1:Boolean) : void
      {
         var _loc2_:Object = this._110320277bypassClientMinPlayersCheck;
         if(_loc2_ !== param1)
         {
            this._110320277bypassClientMinPlayersCheck = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bypassClientMinPlayersCheck",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get startChat() : Boolean
      {
         return this._2129802534startChat;
      }
      
      public function set startChat(param1:Boolean) : void
      {
         var _loc2_:Object = this._2129802534startChat;
         if(_loc2_ !== param1)
         {
            this._2129802534startChat = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"startChat",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get enableMatchmaking() : Boolean
      {
         return this._606137427enableMatchmaking;
      }
      
      public function set enableMatchmaking(param1:Boolean) : void
      {
         var _loc2_:Object = this._606137427enableMatchmaking;
         if(_loc2_ !== param1)
         {
            this._606137427enableMatchmaking = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"enableMatchmaking",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get playerPreferencesSyncing() : Boolean
      {
         return this._1952520688playerPreferencesSyncing;
      }
      
      public function set playerPreferencesSyncing(param1:Boolean) : void
      {
         var _loc2_:Object = this._1952520688playerPreferencesSyncing;
         if(_loc2_ !== param1)
         {
            this._1952520688playerPreferencesSyncing = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"playerPreferencesSyncing",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get submitLogsToEmailAddress() : String
      {
         return this._234292070submitLogsToEmailAddress;
      }
      
      public function set submitLogsToEmailAddress(param1:String) : void
      {
         var _loc2_:Object = this._234292070submitLogsToEmailAddress;
         if(_loc2_ !== param1)
         {
            this._234292070submitLogsToEmailAddress = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"submitLogsToEmailAddress",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get enableXMPPFileLogTarget() : Boolean
      {
         return this._1859995903enableXMPPFileLogTarget;
      }
      
      public function set enableXMPPFileLogTarget(param1:Boolean) : void
      {
         var _loc2_:Object = this._1859995903enableXMPPFileLogTarget;
         if(_loc2_ !== param1)
         {
            this._1859995903enableXMPPFileLogTarget = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"enableXMPPFileLogTarget",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get enableEditSummoner() : Boolean
      {
         return this._1327886693enableEditSummoner;
      }
      
      public function set enableEditSummoner(param1:Boolean) : void
      {
         var _loc2_:Object = this._1327886693enableEditSummoner;
         if(_loc2_ !== param1)
         {
            this._1327886693enableEditSummoner = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"enableEditSummoner",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get suppressLocaleLoading() : Boolean
      {
         return this._2019604275suppressLocaleLoading;
      }
      
      public function set suppressLocaleLoading(param1:Boolean) : void
      {
         var _loc2_:Object = this._2019604275suppressLocaleLoading;
         if(_loc2_ !== param1)
         {
            this._2019604275suppressLocaleLoading = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"suppressLocaleLoading",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get bexecutableArgs() : MultiValueProperty
      {
         return this._477315369bexecutableArgs;
      }
      
      public function set bexecutableArgs(param1:MultiValueProperty) : void
      {
         var _loc2_:Object = this._477315369bexecutableArgs;
         if(_loc2_ !== param1)
         {
            this._477315369bexecutableArgs = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bexecutableArgs",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get matchHistoryTest() : Boolean
      {
         return this._1157211201matchHistoryTest;
      }
      
      public function set matchHistoryTest(param1:Boolean) : void
      {
         var _loc2_:Object = this._1157211201matchHistoryTest;
         if(_loc2_ !== param1)
         {
            this._1157211201matchHistoryTest = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"matchHistoryTest",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get sendFeedbackEventsEnabled() : Boolean
      {
         return this._435851845sendFeedbackEventsEnabled;
      }
      
      public function set sendFeedbackEventsEnabled(param1:Boolean) : void
      {
         var _loc2_:Object = this._435851845sendFeedbackEventsEnabled;
         if(_loc2_ !== param1)
         {
            this._435851845sendFeedbackEventsEnabled = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"sendFeedbackEventsEnabled",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get environment() : String
      {
         return this._85904877environment;
      }
      
      public function set environment(param1:String) : void
      {
         var _loc2_:Object = this._85904877environment;
         if(_loc2_ !== param1)
         {
            this._85904877environment = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"environment",_loc2_,param1));
            }
         }
      }
      
      [ArrayElementType("mx.resources.Locale")]
      [Bindable(event="propertyChange")]
      public function get locales() : Array
      {
         return this._338410841locales;
      }
      
      public function set locales(param1:Array) : void
      {
         var _loc2_:Object = this._338410841locales;
         if(_loc2_ !== param1)
         {
            this._338410841locales = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"locales",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get preloadGameClient() : Boolean
      {
         return this._2035745094preloadGameClient;
      }
      
      public function set preloadGameClient(param1:Boolean) : void
      {
         var _loc2_:Object = this._2035745094preloadGameClient;
         if(_loc2_ !== param1)
         {
            this._2035745094preloadGameClient = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"preloadGameClient",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set leagueServiceEnabled(param1:Boolean) : void
      {
         var _loc2_:Object = this.leagueServiceEnabled;
         if(_loc2_ !== param1)
         {
            this._1110341339leagueServiceEnabled = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"leagueServiceEnabled",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get startFakeGame() : String
      {
         return this._852462441startFakeGame;
      }
      
      public function set startFakeGame(param1:String) : void
      {
         var _loc2_:Object = this._852462441startFakeGame;
         if(_loc2_ !== param1)
         {
            this._852462441startFakeGame = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"startFakeGame",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get kudosPullNotifications() : Boolean
      {
         return this._339388763kudosPullNotifications;
      }
      
      public function set kudosPullNotifications(param1:Boolean) : void
      {
         var _loc2_:Object = this._339388763kudosPullNotifications;
         if(_loc2_ !== param1)
         {
            this._339388763kudosPullNotifications = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"kudosPullNotifications",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get enablePlaytimeReminderOverride() : Boolean
      {
         return this._1456626398enablePlaytimeReminderOverride;
      }
      
      public function set enablePlaytimeReminderOverride(param1:Boolean) : void
      {
         var _loc2_:Object = this._1456626398enablePlaytimeReminderOverride;
         if(_loc2_ !== param1)
         {
            this._1456626398enablePlaytimeReminderOverride = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"enablePlaytimeReminderOverride",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get observableCustomGameModes() : String
      {
         return this._1771732522observableCustomGameModes;
      }
      
      public function set observableCustomGameModes(param1:String) : void
      {
         var _loc2_:Object = this._1771732522observableCustomGameModes;
         if(_loc2_ !== param1)
         {
            this._1771732522observableCustomGameModes = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"observableCustomGameModes",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get locale() : String
      {
         return this._1097462182locale;
      }
      
      public function set locale(param1:String) : void
      {
         var _loc2_:Object = this._1097462182locale;
         if(_loc2_ !== param1)
         {
            this._1097462182locale = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"locale",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get eogStatsSavingFileName() : String
      {
         return this._1323675011eogStatsSavingFileName;
      }
      
      public function set eogStatsSavingFileName(param1:String) : void
      {
         var _loc2_:Object = this._1323675011eogStatsSavingFileName;
         if(_loc2_ !== param1)
         {
            this._1323675011eogStatsSavingFileName = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"eogStatsSavingFileName",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set itemSetServiceEnabled(param1:Boolean) : void
      {
         var _loc2_:Object = this.itemSetServiceEnabled;
         if(_loc2_ !== param1)
         {
            this._1102546693itemSetServiceEnabled = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"itemSetServiceEnabled",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get featuredGamesURL() : String
      {
         return this._1270231748featuredGamesURL;
      }
      
      public function set featuredGamesURL(param1:String) : void
      {
         var _loc2_:Object = this._1270231748featuredGamesURL;
         if(_loc2_ !== param1)
         {
            this._1270231748featuredGamesURL = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"featuredGamesURL",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get enableChatDebugWindow() : Boolean
      {
         return this._485253720enableChatDebugWindow;
      }
      
      public function set enableChatDebugWindow(param1:Boolean) : void
      {
         var _loc2_:Object = this._485253720enableChatDebugWindow;
         if(_loc2_ !== param1)
         {
            this._485253720enableChatDebugWindow = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"enableChatDebugWindow",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get replaySystemStatesOverrides() : ConfigOverrides
      {
         return this._440001135replaySystemStatesOverrides;
      }
      
      public function set replaySystemStatesOverrides(param1:ConfigOverrides) : void
      {
         var _loc2_:Object = this._440001135replaySystemStatesOverrides;
         if(_loc2_ !== param1)
         {
            this._440001135replaySystemStatesOverrides = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"replaySystemStatesOverrides",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get eogStatsSavingFolder() : String
      {
         return this._1231497930eogStatsSavingFolder;
      }
      
      public function set eogStatsSavingFolder(param1:String) : void
      {
         var _loc2_:Object = this._1231497930eogStatsSavingFolder;
         if(_loc2_ !== param1)
         {
            this._1231497930eogStatsSavingFolder = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"eogStatsSavingFolder",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get submitErrorReportFromEmailAddress() : String
      {
         return this._877195206submitErrorReportFromEmailAddress;
      }
      
      public function set submitErrorReportFromEmailAddress(param1:String) : void
      {
         var _loc2_:Object = this._877195206submitErrorReportFromEmailAddress;
         if(_loc2_ !== param1)
         {
            this._877195206submitErrorReportFromEmailAddress = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"submitErrorReportFromEmailAddress",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get enableNPLP() : Boolean
      {
         return this._1893029577enableNPLP;
      }
      
      public function set enableNPLP(param1:Boolean) : void
      {
         var _loc2_:Object = this._1893029577enableNPLP;
         if(_loc2_ !== param1)
         {
            this._1893029577enableNPLP = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"enableNPLP",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get observableGameModes() : ArrayCollection
      {
         return this._54604709observableGameModes;
      }
      
      public function set observableGameModes(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._54604709observableGameModes;
         if(_loc2_ !== param1)
         {
            this._54604709observableGameModes = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"observableGameModes",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get disconnect_logging() : Boolean
      {
         return this._1284542788disconnect_logging;
      }
      
      public function set disconnect_logging(param1:Boolean) : void
      {
         var _loc2_:Object = this._1284542788disconnect_logging;
         if(_loc2_ !== param1)
         {
            this._1284542788disconnect_logging = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"disconnect_logging",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get debugLocale() : Boolean
      {
         return this._1761065331debugLocale;
      }
      
      public function set debugLocale(param1:Boolean) : void
      {
         var _loc2_:Object = this._1761065331debugLocale;
         if(_loc2_ !== param1)
         {
            this._1761065331debugLocale = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"debugLocale",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get archivedStatsEnabled() : Boolean
      {
         return this._1111259484archivedStatsEnabled;
      }
      
      public function set archivedStatsEnabled(param1:Boolean) : void
      {
         var _loc2_:Object = this._1111259484archivedStatsEnabled;
         if(_loc2_ !== param1)
         {
            this._1111259484archivedStatsEnabled = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"archivedStatsEnabled",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get cacheSummonerNames() : Boolean
      {
         return this._1097413176cacheSummonerNames;
      }
      
      public function set cacheSummonerNames(param1:Boolean) : void
      {
         var _loc2_:Object = this._1097413176cacheSummonerNames;
         if(_loc2_ !== param1)
         {
            this._1097413176cacheSummonerNames = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"cacheSummonerNames",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rafUrl() : String
      {
         return this._938538536rafUrl;
      }
      
      public function set rafUrl(param1:String) : void
      {
         var _loc2_:Object = this._938538536rafUrl;
         if(_loc2_ !== param1)
         {
            this._938538536rafUrl = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rafUrl",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get useNewEogChat() : Boolean
      {
         return this._1899579676useNewEogChat;
      }
      
      public function set useNewEogChat(param1:Boolean) : void
      {
         var _loc2_:Object = this._1899579676useNewEogChat;
         if(_loc2_ !== param1)
         {
            this._1899579676useNewEogChat = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"useNewEogChat",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get reportingSampleRate() : int
      {
         return this._564302456reportingSampleRate;
      }
      
      public function set reportingSampleRate(param1:int) : void
      {
         var _loc2_:Object = this._564302456reportingSampleRate;
         if(_loc2_ !== param1)
         {
            this._564302456reportingSampleRate = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"reportingSampleRate",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get userFlowMaxEvents() : int
      {
         return this._198209540userFlowMaxEvents;
      }
      
      public function set userFlowMaxEvents(param1:int) : void
      {
         var _loc2_:Object = this._198209540userFlowMaxEvents;
         if(_loc2_ !== param1)
         {
            this._198209540userFlowMaxEvents = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"userFlowMaxEvents",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set leaguesDecayMessagingEnabled(param1:Boolean) : void
      {
         var _loc2_:Object = this.leaguesDecayMessagingEnabled;
         if(_loc2_ !== param1)
         {
            this._1223033267leaguesDecayMessagingEnabled = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"leaguesDecayMessagingEnabled",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get replayServiceURL() : String
      {
         return this._1321158207replayServiceURL;
      }
      
      public function set replayServiceURL(param1:String) : void
      {
         var _loc2_:Object = this._1321158207replayServiceURL;
         if(_loc2_ !== param1)
         {
            this._1321158207replayServiceURL = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"replayServiceURL",_loc2_,param1));
            }
         }
      }
   }
}

class SingletonEnforcer
{
   
   public function SingletonEnforcer()
   {
      super();
   }
}
