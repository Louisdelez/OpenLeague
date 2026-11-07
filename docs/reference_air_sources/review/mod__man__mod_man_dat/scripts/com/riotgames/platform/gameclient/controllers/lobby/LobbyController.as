package com.riotgames.platform.gameclient.controllers.lobby
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.AppConfig;
   import com.riotgames.platform.common.IAppController;
   import com.riotgames.platform.common.IAppControllerConstants;
   import com.riotgames.platform.common.error.ServerError;
   import com.riotgames.platform.common.provider.ChampionDetailProviderProxy;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.common.xmpp.data.invite.PresenceStatusXML;
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.gameclient.controllers.lobby.event.StoreNavigationEvent;
   import com.riotgames.platform.gameclient.controllers.store.StoreController;
   import com.riotgames.platform.gameclient.controllers.summoner.SummonerProfileController;
   import com.riotgames.platform.gameclient.domain.BaseSummoner;
   import com.riotgames.platform.gameclient.domain.PublicSummoner;
   import com.riotgames.platform.gameclient.domain.game.GameViewState;
   import com.riotgames.platform.gameclient.domain.lobby.LobbyViewState;
   import com.riotgames.platform.gameclient.domain.summoner.LevelUpInfo;
   import com.riotgames.platform.gameclient.popup.ShowHelpPopupAction;
   import com.riotgames.platform.gameclient.summoner.SummonerSearchController;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.game.controllers.MasterGameController;
   import com.riotgames.pvpnet.game.controllers.MasterGameViewController;
   import com.riotgames.pvpnet.game.controllers.lobby.ILegacyProfileNavigationProvider;
   import com.riotgames.pvpnet.game.controllers.lobby.ILobbyViewController;
   import com.riotgames.pvpnet.game.controllers.lobby.LobbyConfig;
   import com.riotgames.pvpnet.game.controllers.lobby.MatchMakingState;
   import com.riotgames.pvpnet.game.controllers.shutdown.ShutdownTimingTables;
   import com.riotgames.pvpnet.summonerprofile.ProfilePagesEnum;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.tracking.ICrossModuleTrackerProvider;
   import com.riotgames.pvpnet.tracking.trackers.friend.IFriendListBehaviorTracker;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.binding.utils.ChangeWatcher;
   import mx.events.PropertyChangeEvent;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class LobbyController implements ILobbyViewController, ILegacyProfileNavigationProvider, IEventDispatcher
   {
      
      private var _2070536460applicationController:IAppController;
      
      private var _269543472masterGameController:MasterGameController;
      
      private var currentStateWatcher:ChangeWatcher = null;
      
      private var navigatorVisibleWatcher:ChangeWatcher = null;
      
      private var proxiedOnError:Function;
      
      private var showHelpPopupAction:ShowHelpPopupAction = new ShowHelpPopupAction();
      
      private var _storeNavigated:Signal = new Signal();
      
      private var _promptingState:String;
      
      private var useOldProfile:Boolean;
      
      public var chooseGameFlowViewController:ChooseGameFlowViewController;
      
      private var _566834807summonerProfileController:SummonerProfileController;
      
      private var logger:ILogger = Log.getLogger("com.riotgames.gameclient.controllers.lobby.LobbyController");
      
      private var _friendTracker:IFriendListBehaviorTracker;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _1019249940chatController:ChatController;
      
      public var summonerSearchController:SummonerSearchController;
      
      public var clientConfig:ClientConfig = ClientConfig.instance;
      
      private var _navigationPromptFunction:Function = null;
      
      private var _storeRefreshed:Signal = new Signal();
      
      private var _1450947915masterGameViewController:MasterGameViewController;
      
      public function LobbyController()
      {
         super();
         this.useOldProfile = ClientConfig.instance.useOldProfileContainer;
         this.applySessionListeners();
         LobbyConfig.instance.currentLobbyStateChanged.add(this.onCurrentLobbyStateChanged);
      }
      
      public function reviewSummonerProfile(param1:BaseSummoner, param2:String = null) : Boolean
      {
         if(this.useOldProfile && Boolean(this.summonerProfileController.isBusy))
         {
            return false;
         }
         LobbyConfig.instance.isLobbyBusy = true;
         this.applicationController.home();
         if(this.useOldProfile)
         {
            this.summonerProfileController.baseSummoner = param1;
         }
         this.requestLobbyState(LobbyViewState.SUMMONER_INFO_STATE);
         if(this.useOldProfile)
         {
            if(param2 != null && param2 != ProfilePagesEnum.PROFILE_PAGE)
            {
               this.summonerProfileController.setPendingState(param2);
            }
         }
         LobbyConfig.instance.isLobbyBusy = false;
         return true;
      }
      
      public function clearNavigationPrompt() : void
      {
         this._navigationPromptFunction = null;
      }
      
      public function activate() : void
      {
         LobbyConfig.instance.isNavigationEnabled = true;
      }
      
      [Bindable(event="propertyChange")]
      public function get applicationController() : IAppController
      {
         return this._2070536460applicationController;
      }
      
      public function quitSpectating() : void
      {
         this.masterGameController.spectatorController.quitSpectating();
      }
      
      public function set applicationController(param1:IAppController) : void
      {
         var _loc2_:Object = this._2070536460applicationController;
         if(_loc2_ !== param1)
         {
            this._2070536460applicationController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"applicationController",_loc2_,param1));
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
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"chatController",_loc2_,param1));
         }
      }
      
      private function onSummonerSearchControllerComplete(param1:PublicSummoner) : void
      {
         if(param1 != null)
         {
            this.reviewSummonerProfile(param1);
            this.proxiedOnError = null;
         }
         LobbyConfig.instance.isLobbyBusy = false;
      }
      
      [Bindable(event="propertyChange")]
      public function get masterGameController() : MasterGameController
      {
         return this._269543472masterGameController;
      }
      
      private function onGetCrossModuleTrackerProvider(param1:ICrossModuleTrackerProvider) : void
      {
         this._friendTracker = param1.getFriendListBehaviorTracker();
      }
      
      private function onMasterGameStateChanged(param1:PropertyChangeEvent) : void
      {
         if(param1.newValue == GameViewState.WAIT_FOR_GAME)
         {
            LobbyConfig.instance.matchmakingState = MatchMakingState.MATCHMAKING_QUEUED;
         }
         else if(param1.newValue == GameViewState.WAIT_FOR_GAME_AFTER_MATCH)
         {
            LobbyConfig.instance.matchmakingState = MatchMakingState.MATCHMAKING_MATCHED;
         }
         else if(param1.newValue == GameViewState.JOIN_QUEUE)
         {
            LobbyConfig.instance.matchmakingState = MatchMakingState.MATCHMAKING_CREATE_TEAM;
         }
         else if(param1.newValue == GameViewState.TEAM_SELECTION)
         {
            LobbyConfig.instance.matchmakingState = MatchMakingState.MATCHMAKING_CUSTOM_GAME_LOBBY;
         }
         else if(this.isSpectatingChampSelect(param1.newValue))
         {
            LobbyConfig.instance.matchmakingState = MatchMakingState.MATCHMAKING_SPECTATING_CHAMP_SELECT;
         }
         else if(param1.newValue == GameViewState.CAP_STATE)
         {
            LobbyConfig.instance.matchmakingState = MatchMakingState.MATCHMAKING_CAP;
         }
         else
         {
            LobbyConfig.instance.matchmakingState = MatchMakingState.MATCHMAKING_NOT_PARTICIPATING;
         }
      }
      
      public function get storeNavigated() : ISignal
      {
         return this._storeNavigated;
      }
      
      public function get matchmakingStateChanged() : ISignal
      {
         return LobbyConfig.instance.matchmakingStateChanged;
      }
      
      public function navigateToGameFlow(param1:Array = null) : void
      {
         if(LobbyConfig.instance.matchmakingState == MatchMakingState.MATCHMAKING_NOT_PARTICIPATING)
         {
            if(Boolean(ShutdownTimingTables.noQueuesAvailable()) || Boolean(ShutdownTimingTables.isInShutdownWindow()))
            {
               return;
            }
            if(this.useOldProfile)
            {
               this.summonerProfileController.deactivate();
            }
            this.chooseGameFlowViewController.prepareForDisplay(param1);
            AppConfig.instance.currentAppState = IAppControllerConstants.CHOOSE_GAME_FLOW;
            LobbyConfig.instance.isLobbyBusy = false;
         }
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function get matchmakingState() : String
      {
         return LobbyConfig.instance.matchmakingState;
      }
      
      public function get spectatorDelayTimerString() : String
      {
         var _loc2_:int = 0;
         var _loc3_:int = 0;
         var _loc1_:String = "";
         if(this.masterGameController.spectatorController.spectatorDelayProgress > 0)
         {
            _loc2_ = int(this.masterGameController.spectatorController.spectatorDelaySecondsRemaining);
            if(_loc2_ > 0)
            {
               _loc3_ = Math.floor(_loc2_ / 60);
               if(_loc3_ > 0)
               {
                  _loc1_ += _loc3_;
               }
               else
               {
                  _loc1_ = "0";
               }
               _loc1_ += ":";
               _loc2_ -= _loc3_ * 60;
               if(_loc2_ < 10)
               {
                  _loc1_ += "0";
               }
               _loc1_ += _loc2_;
            }
         }
         return _loc1_;
      }
      
      public function requestLobbyState(param1:String) : void
      {
         if(param1 != LobbyViewState.PLAY_GAME_STATE)
         {
            if(this.masterGameController.currentState == GameViewState.CHAMPION_SELECTION && !this.masterGameController.isSpectating)
            {
               this.logger.warn("Aborting lobby state request for: " + param1 + " because we are in champion select.");
               return;
            }
         }
         if(param1 == LobbyViewState.LOBBY_LANDING_STATE && this.masterGameController.currentState == GameViewState.CREATE_GAME)
         {
            this.masterGameController.changePresence(PresenceStatusXML.GAME_STATUS_OUT_OF_GAME);
         }
         if(this._promptingState == null)
         {
            if(this.navigationPromptFunction != null)
            {
               this._promptingState = param1;
               this.navigationPromptFunction(this.onPromptComplete);
            }
            else
            {
               LobbyConfig.instance.currentLobbyState = param1;
            }
         }
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function cancelMatchmaking() : void
      {
         if(LobbyConfig.instance.matchmakingState != MatchMakingState.MATCHMAKING_NOT_PARTICIPATING)
         {
            LobbyConfig.instance.isLobbyBusy = true;
            this.masterGameViewController.cancelWaitingForGame(this.onCancelledQueue);
         }
         LobbyConfig.instance.isLobbyBusy = false;
      }
      
      private function onCurrentLobbyStateChanged(param1:String, param2:String) : void
      {
         if(this.useOldProfile)
         {
            if(param1 == LobbyViewState.SUMMONER_INFO_STATE)
            {
               this.summonerProfileController.deactivate();
            }
            if(param2 == LobbyViewState.SUMMONER_INFO_STATE)
            {
               this.summonerProfileController.activate();
            }
         }
         if(param2 == LobbyViewState.LOBBY_LANDING_STATE)
         {
            if(this.clientConfig.clientMode == ClientConfig.SPECIAL_MODE_TENCENT)
            {
               this.chatController.buddyListOpen = true;
            }
         }
         this.applicationController.logMemorySnapshot();
         ChampionDetailProviderProxy.instance.close();
      }
      
      public function set masterGameController(param1:MasterGameController) : void
      {
         var _loc2_:Object = this._269543472masterGameController;
         if(_loc2_ !== param1)
         {
            this._269543472masterGameController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"masterGameController",_loc2_,param1));
         }
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      public function showWatchTab() : void
      {
         this.applicationController.home();
         this.requestLobbyState(LobbyViewState.WATCH_TAB_STATE);
      }
      
      public function set currentLobbyState(param1:String) : void
      {
         LobbyConfig.instance.currentLobbyState = param1;
      }
      
      public function set masterGameViewController(param1:MasterGameViewController) : void
      {
         var _loc2_:Object = this._1450947915masterGameViewController;
         if(_loc2_ !== param1)
         {
            this._1450947915masterGameViewController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"masterGameViewController",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get summonerProfileController() : SummonerProfileController
      {
         return this._566834807summonerProfileController;
      }
      
      public function selectQueue(param1:int, param2:Boolean) : void
      {
         this.chooseGameFlowViewController.selectQueue(param1,param2);
      }
      
      public function searchForSummoner(param1:String, param2:Function, param3:Boolean = false) : void
      {
         var _loc4_:Boolean = false;
         if(Boolean(LobbyConfig.instance.isSummonerSearchEnabled) || param3)
         {
            _loc4_ = this.summonerSearchController.isCurrentSummoner(param1);
            if(_loc4_)
            {
               LobbyConfig.instance.isLobbyBusy = true;
               this.applicationController.home();
               this.requestLobbyState(LobbyViewState.SUMMONER_INFO_STATE);
               if(this.useOldProfile)
               {
                  this.summonerProfileController.setProfileState(ProfilePagesEnum.PROFILE_PAGE);
               }
               LobbyConfig.instance.isLobbyBusy = false;
            }
            else if(!_loc4_ || param3)
            {
               this.goToSummonerProfile(param1,param2);
            }
            this._friendTracker.incrementFriendSearch_InASession();
         }
      }
      
      private function goToSummonerProfile(param1:String, param2:Function) : void
      {
         this.proxiedOnError = param2;
         LobbyConfig.instance.isLobbyBusy = true;
         this.summonerSearchController.searchForSummoner(param1,this.onSummonerSearchFailed,this.onSummonerSearchControllerComplete);
      }
      
      public function requirePromptOnNavigate(param1:Function) : void
      {
         this._navigationPromptFunction = param1;
      }
      
      public function set matchmakingState(param1:String) : void
      {
         LobbyConfig.instance.matchmakingState = param1;
      }
      
      public function deactivate() : void
      {
         LobbyConfig.instance.isNavigationEnabled = false;
         LobbyConfig.instance.isLobbyBusy = false;
         this.proxiedOnError = null;
      }
      
      private function updateSummonerInfo() : void
      {
         var _loc1_:LevelUpInfo = null;
         if(Session.instance.summoner != null && Session.instance.summonerLevel != null && Session.instance.summonerLevelAndPoints != null)
         {
            _loc1_ = new LevelUpInfo();
            _loc1_.summonerName = Session.instance.summoner.name;
            _loc1_.currentLevel = Session.instance.summonerLevel.summonerLevel;
            _loc1_.nextLevel = _loc1_.currentLevel + 1;
            _loc1_.totalExperiencePoints = Session.instance.summonerLevelAndPoints.expPoints;
            _loc1_.pointsNeededToLevelUp = Session.instance.summonerLevel.expToNextLevel - _loc1_.totalExperiencePoints;
            LobbyConfig.instance.levelUpInfo = _loc1_;
         }
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function refreshStoreView(param1:String = "champion") : void
      {
         var _loc2_:String = StoreController.RELATIVE_URL_VIEW_CHAMPIONS;
         if(param1 == "skin")
         {
            _loc2_ = StoreController.RELATIVE_URL_VIEW_SKINS;
         }
         this._storeRefreshed.dispatch(new StoreNavigationEvent(StoreNavigationEvent.STORE_REFRESH,_loc2_));
      }
      
      public function closeStoreSession() : void
      {
         this._storeNavigated.dispatch(new StoreNavigationEvent(StoreNavigationEvent.STORE_NAVIGATE,"","logout=true"));
      }
      
      public function get navigationPromptFunction() : Function
      {
         return this._navigationPromptFunction;
      }
      
      private function onPromptComplete() : void
      {
         this.clearNavigationPrompt();
         LobbyConfig.instance.currentLobbyState = this._promptingState;
         this._promptingState = null;
      }
      
      public function initialize() : void
      {
         if(this.navigatorVisibleWatcher == null)
         {
            this.navigatorVisibleWatcher = ChangeWatcher.watch(AppConfig.instance,"isNavigatorVisible",this.onAppControllerNavigatorVisibleStateChanged);
         }
         LobbyConfig.instance.isSummonerSearchEnabled = AppConfig.instance.isNavigatorVisible;
         if(this.currentStateWatcher == null)
         {
            this.currentStateWatcher = ChangeWatcher.watch(this.masterGameController,"currentState",this.onMasterGameStateChanged);
         }
         if(this.useOldProfile)
         {
            this.summonerProfileController.initialize();
         }
         this.masterGameController.initialize();
         ProviderLookup.publishProvider(ILobbyViewController,this);
         ProviderLookup.publishProvider(ILegacyProfileNavigationProvider,this);
         ProviderLookup.getProvider(ICrossModuleTrackerProvider,this.onGetCrossModuleTrackerProvider);
      }
      
      public function navigateToQueue(param1:int, param2:Boolean, param3:String, param4:String) : void
      {
         this.masterGameController.joinQueueWithMapName(param1,param2,param3,param4);
      }
      
      public function showStoreView(param1:String, param2:String) : void
      {
         this.requestLobbyState(LobbyViewState.STORE_VIEW_STATE);
         AppConfig.instance.currentAppState = IAppControllerConstants.LOBBY;
         this._storeNavigated.dispatch(new StoreNavigationEvent(StoreNavigationEvent.STORE_NAVIGATE,param1,param2));
      }
      
      public function cancelJoinQueue() : void
      {
         this.masterGameViewController.cancelJoinQueueView();
      }
      
      public function showProfileView() : void
      {
         this.applicationController.home();
         this.requestLobbyState(LobbyViewState.SUMMONER_INFO_STATE);
      }
      
      public function cleanup() : void
      {
         if(LobbyConfig.instance.currentLobbyState == LobbyViewState.PLAY_GAME_STATE)
         {
            this.masterGameController.deactivate();
         }
         if(this.useOldProfile)
         {
            this.summonerProfileController.cleanup();
         }
         this.masterGameController.cleanup();
         if(this.navigatorVisibleWatcher != null)
         {
            this.navigatorVisibleWatcher.unwatch();
            this.navigatorVisibleWatcher = null;
         }
         if(this.currentStateWatcher != null)
         {
            this.currentStateWatcher.unwatch();
            this.currentStateWatcher = null;
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get masterGameViewController() : MasterGameViewController
      {
         return this._1450947915masterGameViewController;
      }
      
      public function showStoryView() : Boolean
      {
         if(this.useOldProfile && Boolean(this.summonerProfileController.isBusy))
         {
            return false;
         }
         this.applicationController.home();
         this.requestLobbyState(LobbyViewState.STORY_VIEW_STATE);
         return true;
      }
      
      public function get practiceGameTimerString() : String
      {
         return this.masterGameController.practiceGameManager.elapsedExpiryTimeStr;
      }
      
      private function onAppControllerNavigatorVisibleStateChanged(param1:PropertyChangeEvent) : void
      {
         LobbyConfig.instance.isSummonerSearchEnabled = param1.newValue;
      }
      
      public function issueGameFlowCommand(param1:String) : void
      {
         if(LobbyConfig.instance.matchmakingState == MatchMakingState.MATCHMAKING_NOT_PARTICIPATING)
         {
            this.chooseGameFlowViewController.issueCommand(param1);
         }
      }
      
      public function openHelpDialog() : void
      {
         if(this.showHelpPopupAction != null)
         {
            this.showHelpPopupAction.add();
         }
      }
      
      private function applySessionListeners() : void
      {
         Session.instance.getSummonerLevelAndPointsChanged().add(this.updateSummonerInfo);
         Session.instance.getSummonerLevelChanged().add(this.updateSummonerInfo);
         Session.instance.getSummonerChanged().add(this.updateSummonerInfo);
         this.updateSummonerInfo();
      }
      
      private function isSpectatingChampSelect(param1:Object) : Boolean
      {
         return Boolean(this.masterGameController.isSpectating) && (param1 == GameViewState.CHAMPION_SELECTION || param1 == GameViewState.START_REQUESTED);
      }
      
      public function navigateToHome() : void
      {
         AppConfig.instance.currentAppState = IAppControllerConstants.LOBBY;
         this.requestLobbyState(LobbyViewState.LOBBY_LANDING_STATE);
         LobbyConfig.instance.isNavigationEnabled = true;
         AppConfig.instance.isNavigatorVisible = true;
      }
      
      public function get storeRefreshed() : ISignal
      {
         return this._storeRefreshed;
      }
      
      public function set summonerProfileController(param1:SummonerProfileController) : void
      {
         var _loc2_:Object = this._566834807summonerProfileController;
         if(_loc2_ !== param1)
         {
            this._566834807summonerProfileController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerProfileController",_loc2_,param1));
         }
      }
      
      public function get lobbyStateChanged() : ISignal
      {
         return LobbyConfig.instance.currentLobbyStateChanged;
      }
      
      private function onSummonerSearchFailed(param1:ServerError) : void
      {
         if(this.proxiedOnError != null)
         {
            this.proxiedOnError.apply(null,[param1]);
         }
         this.proxiedOnError = null;
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
      
      public function showLobbyLanding() : void
      {
         this.requestLobbyState(LobbyViewState.LOBBY_LANDING_STATE);
      }
      
      private function onCancelledQueue(param1:Boolean) : void
      {
         if(param1)
         {
            this.chatController.leaveMatchmakingQueueChatRoom();
            this.masterGameController.abortCycle();
            this.requestLobbyState(LobbyViewState.LOBBY_LANDING_STATE);
         }
      }
   }
}

