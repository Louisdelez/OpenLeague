package com.riotgames.pvpnet.chrome
{
   import com.riotgames.platform.common.AppConfig;
   import com.riotgames.platform.common.IAppControllerConstants;
   import com.riotgames.platform.common.event.ShellEvent;
   import com.riotgames.platform.common.provider.CapProviderProxy;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.gameclient.domain.game.CapModuleInfo;
   import com.riotgames.platform.gameclient.domain.game.GameQueueConfig;
   import com.riotgames.platform.gameclient.domain.lobby.LobbyViewState;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.chrome.model.ChromeGameState;
   import com.riotgames.pvpnet.chrome.model.ChromeModel;
   import com.riotgames.pvpnet.game.controllers.lobby.ILobbyViewController;
   import com.riotgames.pvpnet.game.controllers.lobby.LobbyConfig;
   import com.riotgames.pvpnet.game.controllers.lobby.MatchMakingState;
   import com.riotgames.pvpnet.game.domain.IGameQueueManager;
   import com.riotgames.pvpnet.metrics.UserFlow;
   import com.riotgames.pvpnet.system.messaging.ShellDispatcher;
   import flash.display.NativeWindowResize;
   
   public class ChromeController
   {
      
      private static const RESIZE_NAMES:Object = {
         "L":NativeWindowResize.LEFT,
         "TL":NativeWindowResize.TOP_LEFT,
         "T":NativeWindowResize.TOP,
         "TR":NativeWindowResize.TOP_RIGHT,
         "R":NativeWindowResize.RIGHT,
         "BR":NativeWindowResize.BOTTOM_RIGHT,
         "B":NativeWindowResize.BOTTOM,
         "BL":NativeWindowResize.BOTTOM_LEFT
      };
      
      private var _model:ChromeModel;
      
      private var _windowControls:IWindowControlsProvider;
      
      private var _chromePopupProvider:IChromePopupsProvider;
      
      private var _lobbyViewProvider:ILobbyViewController;
      
      private var _gameQueueManagerProvider:IGameQueueManager;
      
      private var _contextAlertController:ChromeContextAlertController;
      
      public function ChromeController(param1:ChromeModel, param2:IWindowControlsProvider, param3:ChromeContextAlertController)
      {
         super();
         this._model = param1;
         this._contextAlertController = param3;
         this._windowControls = param2;
         ProviderLookup.getProvider(ILobbyViewController,this.onGotLobbyViewController);
         ProviderLookup.getProvider(IChromePopupsProvider,this.onGotChromePopupProvider);
         ProviderLookup.getProvider(IGameQueueManager,this.onGotGameQueueManager);
         AppConfig.instance.currentAppStateChanged.add(this.updatePlayButtonState);
         LobbyConfig.instance.currentLobbyStateChanged.add(this.updatePlayButtonState);
         AppConfig.instance.shutdownDisablePlayButtonChanged.add(this.updatePlayButtonState);
         CapModuleInfo.instance.getHomeButtonVisibleChanged().add(this.updateGameState);
         AppConfig.instance.isNavigatorVisibleChanged.add(this.updateNavigatorVisible);
         this.updatePlayButtonState();
      }
      
      private function onGotLobbyViewController(param1:ILobbyViewController) : void
      {
         this._lobbyViewProvider = param1;
         this._lobbyViewProvider.lobbyStateChanged.add(this.updateGameState);
         this._lobbyViewProvider.matchmakingStateChanged.add(this.updateGameState);
         LobbyConfig.instance.gameButtonEnabledChanged.add(this.updateGameState);
         AppConfig.instance.currentAppStateChanged.add(this.updateGameState);
         LobbyConfig.instance.currentLobbyStateChanged.add(this.updateGameState);
         this.updateGameState();
      }
      
      private function updateNavigatorVisible() : void
      {
         this._model.navigatorVisible = AppConfig.instance.isNavigatorVisible;
         this._contextAlertController.navigatorVisibleChanged(AppConfig.instance.isNavigatorVisible);
      }
      
      private function updatePlayButtonState() : void
      {
         if(AppConfig.instance.shutdownDisablePlayButton)
         {
            this._model.playButtonEnabled = false;
         }
         else if(AppConfig.instance.currentAppState == IAppControllerConstants.CHOOSE_GAME_FLOW || LobbyViewState.PLAY_PRACTICE_GAME_STATE == LobbyConfig.instance.currentLobbyState)
         {
            this._model.playButtonEnabled = false;
         }
         else
         {
            this._model.playButtonEnabled = true;
         }
      }
      
      private function updateGameState() : void
      {
         switch(this._lobbyViewProvider.matchmakingState)
         {
            case MatchMakingState.MATCHMAKING_NOT_PARTICIPATING:
               this._model.gameState = ChromeGameState.NONE;
               break;
            case MatchMakingState.MATCHMAKING_CREATE_TEAM:
               this._model.gameState = ChromeGameState.ARRANGING;
               this._model.queueBoxHomeButtonIsHidden = LobbyConfig.instance.currentLobbyState == LobbyViewState.CREATE_ARRANGED_TEAM_STATE;
               break;
            case MatchMakingState.MATCHMAKING_CUSTOM_GAME_LOBBY:
               this._model.gameState = ChromeGameState.CUSTOM_GAME;
               this._model.queueBoxHomeButtonIsHidden = LobbyConfig.instance.currentLobbyState == LobbyViewState.PLAY_PRACTICE_GAME_STATE;
               break;
            case MatchMakingState.MATCHMAKING_QUEUED:
            case MatchMakingState.MATCHMAKING_MATCHED:
               this._model.gameState = ChromeGameState.MATCHING;
               this._model.queueBoxHomeButtonIsHidden = !CapModuleInfo.instance.homeButtonVisible;
               break;
            case MatchMakingState.MATCHMAKING_SPECTATING_CHAMP_SELECT:
               this._model.gameState = ChromeGameState.SPECTATING;
               this._model.queueBoxHomeButtonIsHidden = LobbyConfig.instance.currentLobbyState == LobbyViewState.PLAY_GAME_STATE;
               break;
            case MatchMakingState.MATCHMAKING_CAP:
               this._model.gameState = ChromeGameState.CAP;
               this._model.queueBoxHomeButtonIsHidden = LobbyConfig.instance.currentLobbyState == LobbyViewState.CAP_STATE;
               break;
            default:
               this._model.gameState = ChromeGameState.NONE;
         }
      }
      
      public function minimize() : void
      {
         this._windowControls.requestMinimize();
      }
      
      public function close() : void
      {
         if(this._model.closeRequestedHandler != null)
         {
            this._model.closeRequestedHandler();
         }
         else
         {
            ShellDispatcher.instance.dispatchEvent(new ShellEvent(ShellEvent.EXIT));
         }
      }
      
      public function resize(param1:String) : void
      {
         this._windowControls.beginResize(RESIZE_NAMES[param1]);
      }
      
      public function drag() : void
      {
         this._windowControls.beginDrag();
      }
      
      public function setToDefaultSize() : void
      {
         UserFlow.track("client_chrome","set_to_default_size",null,UserFlow.INPUT);
         this._windowControls.setToDefaultSize();
      }
      
      public function navigateToGameFlow() : void
      {
         if(this._lobbyViewProvider != null)
         {
            UserFlow.track("play_game_flow","play_game_flow",null,UserFlow.INPUT);
            this._lobbyViewProvider.navigateToGameFlow();
         }
      }
      
      public function navigateToLobby() : void
      {
         if(this._lobbyViewProvider != null)
         {
            UserFlow.track("client_chrome","home_button_clicked",null,UserFlow.INPUT);
            this._lobbyViewProvider.navigateToHome();
         }
      }
      
      public function navigateToProfile() : void
      {
         if(this._lobbyViewProvider != null)
         {
            UserFlow.track("summoner_profile","profile_page_opened",null,UserFlow.INPUT);
            this._lobbyViewProvider.reviewSummonerProfile(Session.instance.summoner);
         }
      }
      
      public function navigateToStore() : void
      {
         if(this._lobbyViewProvider != null)
         {
            UserFlow.track("content_unlock","store_page_opened",null,UserFlow.INPUT);
            this._lobbyViewProvider.showStoreView(null,null);
         }
      }
      
      public function navigateToLore() : void
      {
         if(this._lobbyViewProvider != null)
         {
            UserFlow.track("client_chrome","lore_button_clicked",null,UserFlow.INPUT);
            this._lobbyViewProvider.showStoryView();
         }
      }
      
      public function navigateToReplays() : void
      {
         if(this._lobbyViewProvider != null)
         {
            UserFlow.track("spectator","watch_button_clicked",null,UserFlow.INPUT);
            this._lobbyViewProvider.showWatchTab();
         }
      }
      
      public function openHelpDialog() : void
      {
         if(this._lobbyViewProvider != null)
         {
            UserFlow.track("client_chrome","help_dialogue_opened",null,UserFlow.INPUT);
            this._lobbyViewProvider.openHelpDialog();
         }
      }
      
      public function backToGame() : void
      {
         if(this._lobbyViewProvider == null)
         {
            return;
         }
         if(this._lobbyViewProvider.matchmakingState == MatchMakingState.MATCHMAKING_CUSTOM_GAME_LOBBY)
         {
            this._lobbyViewProvider.requestLobbyState(LobbyViewState.PLAY_PRACTICE_GAME_STATE);
         }
         else if(this._lobbyViewProvider.matchmakingState == MatchMakingState.MATCHMAKING_CREATE_TEAM)
         {
            this._lobbyViewProvider.requestLobbyState(LobbyViewState.CREATE_ARRANGED_TEAM_STATE);
         }
         else if(this._lobbyViewProvider.matchmakingState == MatchMakingState.MATCHMAKING_SPECTATING_CHAMP_SELECT)
         {
            this._lobbyViewProvider.requestLobbyState(LobbyViewState.PLAY_GAME_STATE);
         }
         else if(this._lobbyViewProvider.matchmakingState == MatchMakingState.MATCHMAKING_CAP || Boolean(CapModuleInfo.instance.homeButtonVisible) && this._lobbyViewProvider.matchmakingState == MatchMakingState.MATCHMAKING_QUEUED)
         {
            this._lobbyViewProvider.requestLobbyState(LobbyViewState.CAP_STATE);
         }
      }
      
      public function cancelGame() : void
      {
         if(this._lobbyViewProvider == null)
         {
            return;
         }
         if(CapProviderProxy.instance.isModuleActive())
         {
            CapProviderProxy.instance.quit();
         }
         else if(this._lobbyViewProvider.matchmakingState == MatchMakingState.MATCHMAKING_CREATE_TEAM || this._lobbyViewProvider.matchmakingState == MatchMakingState.MATCHMAKING_CAP)
         {
            this._lobbyViewProvider.cancelJoinQueue();
         }
         else if(this._lobbyViewProvider.matchmakingState == MatchMakingState.MATCHMAKING_SPECTATING_CHAMP_SELECT)
         {
            this._lobbyViewProvider.quitSpectating();
         }
         else
         {
            this._lobbyViewProvider.cancelMatchmaking();
         }
      }
      
      public function showPreferencesPopup() : void
      {
         if(this._chromePopupProvider != null)
         {
            UserFlow.track("client_chrome","client_preferences_opened",null,UserFlow.INPUT);
            this._chromePopupProvider.showPreferencesPopup();
         }
      }
      
      public function showSummonerIconChoosePopup() : void
      {
         if(this._chromePopupProvider != null)
         {
            this._chromePopupProvider.showSummonerIconChoosePopup();
         }
      }
      
      private function onGotChromePopupProvider(param1:IChromePopupsProvider) : void
      {
         this._chromePopupProvider = param1;
      }
      
      private function onGotGameQueueManager(param1:IGameQueueManager) : void
      {
         this._gameQueueManagerProvider = param1;
      }
      
      public function get practiceGameTimerString() : String
      {
         return this._lobbyViewProvider.practiceGameTimerString;
      }
      
      public function get spectatorDelayTimerString() : String
      {
         return this._lobbyViewProvider.spectatorDelayTimerString;
      }
      
      public function get isCapMode() : Boolean
      {
         return CapModuleInfo.instance.inSoloQueue;
      }
      
      public function getSelectedGameQueueConfigName() : String
      {
         var _loc2_:GameQueueConfig = null;
         var _loc1_:String = "";
         if(this._gameQueueManagerProvider != null)
         {
            _loc2_ = this._gameQueueManagerProvider.getSelectedGameQueueConfig();
            if(_loc2_ != null)
            {
               _loc1_ = _loc2_.name;
            }
         }
         return _loc1_;
      }
      
      public function get queueManagerWaitTimeStr() : String
      {
         var _loc1_:String = "";
         if(this._gameQueueManagerProvider != null && this._gameQueueManagerProvider.getQueueInfo() != null)
         {
            _loc1_ = this._gameQueueManagerProvider.getQueueInfo().waitTimeStr;
         }
         return _loc1_;
      }
      
      public function get queueManagerActualWaitTimeStr() : String
      {
         var _loc1_:String = "";
         if(this._gameQueueManagerProvider != null)
         {
            _loc1_ = this._gameQueueManagerProvider.getActualWaitTimeStr();
         }
         return _loc1_;
      }
   }
}

