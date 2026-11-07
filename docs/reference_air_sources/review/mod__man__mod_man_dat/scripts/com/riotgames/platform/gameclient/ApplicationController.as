package com.riotgames.platform.gameclient
{
   import blix.action.IAction;
   import com.riotgames.platform.common.AppConfig;
   import com.riotgames.platform.common.GeneratedContentLoader;
   import com.riotgames.platform.common.IAppController;
   import com.riotgames.platform.common.IAppControllerConstants;
   import com.riotgames.platform.common.IReportTracker;
   import com.riotgames.platform.common.RiotServiceConfig;
   import com.riotgames.platform.common.event.GameCrashedEvent;
   import com.riotgames.platform.common.event.RemoteServiceErrorEvent;
   import com.riotgames.platform.common.event.ShellEvent;
   import com.riotgames.platform.common.provider.ChromeContextAlertProviderProxy;
   import com.riotgames.platform.common.provider.IInventoryProvider;
   import com.riotgames.platform.common.provider.ISoundProvider;
   import com.riotgames.platform.common.provider.InventoryProviderProxy;
   import com.riotgames.platform.common.provider.SoundProviderProxy;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.common.services.lcdsproxy.ILcdsProxyMessageRouter;
   import com.riotgames.platform.common.services.lcdsproxy.LcdsProxyFunctionMessenger;
   import com.riotgames.platform.common.services.lcdsproxy.LcdsProxyServiceMessenger;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.account.GameCfgData.PlayerPreferencesSyncController;
   import com.riotgames.platform.gameclient.buddyImages.BuddyImages;
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.gameclient.chat.IChatRoomProvider;
   import com.riotgames.platform.gameclient.chat.IChatRosterProvider;
   import com.riotgames.platform.gameclient.chat.controllers.PresenceController;
   import com.riotgames.platform.gameclient.controllers.IViewController;
   import com.riotgames.platform.gameclient.controllers.loyalty.LoyaltyController;
   import com.riotgames.platform.gameclient.controllers.social.RealNameController;
   import com.riotgames.platform.gameclient.controllers.store.StoreController;
   import com.riotgames.platform.gameclient.controllers.summoner.SummonerNameController;
   import com.riotgames.platform.gameclient.domain.ForcedClientShutdown;
   import com.riotgames.platform.gameclient.domain.LeagueItemDTO;
   import com.riotgames.platform.gameclient.domain.SummonerCatalog;
   import com.riotgames.platform.gameclient.domain.SummonerLeagueItemsDTO;
   import com.riotgames.platform.gameclient.domain.accountState.AccountStateChangeNotification;
   import com.riotgames.platform.gameclient.domain.accountState.AccountStateChangeNotificationListener;
   import com.riotgames.platform.gameclient.domain.broadcast.BroadcastMessage;
   import com.riotgames.platform.gameclient.domain.broadcast.ClientLoginKickNotification;
   import com.riotgames.platform.gameclient.domain.game.GameMap;
   import com.riotgames.platform.gameclient.domain.game.GameViewState;
   import com.riotgames.platform.gameclient.domain.gameconfig.GameTypeConfigManager;
   import com.riotgames.platform.gameclient.domain.kudos.PendingKudos;
   import com.riotgames.platform.gameclient.domain.lobby.LobbyViewState;
   import com.riotgames.platform.gameclient.domain.loyalty.LoyaltyStateChangeNotification;
   import com.riotgames.platform.gameclient.domain.store.RentalUpdateNotification;
   import com.riotgames.platform.gameclient.domain.store.StoreAccountBalanceNotification;
   import com.riotgames.platform.gameclient.domain.store.StoreFulfillmentNotification;
   import com.riotgames.platform.gameclient.kudos.IKudosFactory;
   import com.riotgames.platform.gameclient.kudos.KudosBadgeDialog;
   import com.riotgames.platform.gameclient.kudos.KudosFactoryProxy;
   import com.riotgames.platform.gameclient.leaverbuster.LeaverBusterController;
   import com.riotgames.platform.gameclient.notification.ClientNotificationProxyServiceName;
   import com.riotgames.platform.gameclient.notification.ClientNotificationType;
   import com.riotgames.platform.gameclient.rss.RSSAlertController;
   import com.riotgames.platform.gameclient.shutdown.ChineseAntiIndulgenceLaw;
   import com.riotgames.platform.gameclient.shutdown.KoreanSelectiveShutdownLaw;
   import com.riotgames.platform.gameclient.shutdown.KoreanShutdownLaw;
   import com.riotgames.platform.gameclient.shutdown.VietnamAntiAddictionLaw;
   import com.riotgames.platform.gameclient.summoner.SummonerController;
   import com.riotgames.platform.gameclient.views.ViewMediator;
   import com.riotgames.platform.gameclient.views.game.common.endofgame.HarassmentReportTracker;
   import com.riotgames.platform.gameclient.views.models.ProfileDisplayModel;
   import com.riotgames.platform.masteries.IMasteriesProvider;
   import com.riotgames.platform.masteries.MasteriesProviderProxy;
   import com.riotgames.platform.masteries.objects.MasteryPageInfoSummary;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.accountmanagement.IAccountManagementProvider;
   import com.riotgames.pvpnet.game.controllers.InGameController;
   import com.riotgames.pvpnet.game.controllers.MasterGameController;
   import com.riotgames.pvpnet.game.controllers.MasterGameViewController;
   import com.riotgames.pvpnet.game.controllers.lobby.ILobbyViewController;
   import com.riotgames.pvpnet.game.controllers.lobby.LobbyConfig;
   import com.riotgames.pvpnet.game.controllers.lobby.MatchMakingState;
   import com.riotgames.pvpnet.game.domain.GameVersionConfig;
   import com.riotgames.pvpnet.game.domain.IGameQueueManager;
   import com.riotgames.pvpnet.invite.IInviteProvider;
   import com.riotgames.pvpnet.invite.model.InviteGroup;
   import com.riotgames.pvpnet.metrics.ChampSelectTracker;
   import com.riotgames.pvpnet.metrics.UserFlow;
   import com.riotgames.pvpnet.rankedteams.IRankedTeamsProvider;
   import com.riotgames.pvpnet.rankedteams.RankedTeamsProviderProxy;
   import com.riotgames.pvpnet.summonerprofile.ProfilePagesEnum;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.pvpnet.system.alerter.AlerterProviderProxy;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.config.LoginConfig;
   import com.riotgames.pvpnet.system.config.PlatformConfigProviderProxy;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import com.riotgames.pvpnet.system.config.cdc.ConfigurationModel;
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
   import com.riotgames.pvpnet.system.maestro.IMaestroProvider;
   import com.riotgames.pvpnet.system.maestro.MaestroController;
   import com.riotgames.pvpnet.system.maestro.MaestroProviderProxy;
   import com.riotgames.pvpnet.system.messaging.BroadcastMessageControllerProxy;
   import com.riotgames.pvpnet.system.messaging.IBroadcastMessageProvider;
   import com.riotgames.pvpnet.system.messaging.ShellDispatcher;
   import com.riotgames.pvpnet.system.notification.ClientNotificationEvent;
   import com.riotgames.pvpnet.system.notification.ClientNotificationProviderProxy;
   import com.riotgames.pvpnet.system.notification.IClientNotificationProvider;
   import com.riotgames.pvpnet.system.notification.IServerStatusProvider;
   import com.riotgames.pvpnet.system.notification.ServerStatusProviderProxy;
   import com.riotgames.pvpnet.tournament.ITournamentCodeProvider;
   import com.riotgames.pvpnet.tracking.trackers.session.ISessionMetricsProvider;
   import com.riotgames.pvpnet.watch.WatchTabProviderProxy;
   import flash.desktop.NativeApplication;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.getQualifiedClassName;
   import mx.collections.ArrayCollection;
   import mx.collections.Sort;
   import mx.collections.SortField;
   import mx.events.CollectionEvent;
   import mx.events.PropertyChangeEvent;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.managers.CursorManager;
   import mx.messaging.events.ChannelEvent;
   import mx.resources.ResourceManager;
   import mx.rpc.events.ResultEvent;
   import org.swizframework.core.ISwiz;
   import org.swizframework.core.ISwizAware;
   
   public class ApplicationController extends EventDispatcher implements IAppController, ISwizAware
   {
      
      public var lobbyController:ILobbyViewController;
      
      private var _1984987798session:Session = Session.instance;
      
      public var maestroController:IMaestroProvider = MaestroProviderProxy.instance;
      
      public var masterGameController:MasterGameController;
      
      private var _firstLogin:Boolean = false;
      
      public var broadcastMessageController:IBroadcastMessageProvider = BroadcastMessageControllerProxy.instance;
      
      private var _1852489237availableCountries:ArrayCollection = new ArrayCollection(["USA","Canada"]);
      
      private var shouldExitAfterLogout:Boolean = false;
      
      private var _1137159790gameQueueManager:IGameQueueManager;
      
      private var knownMaps:ArrayCollection;
      
      private var _lastInterestingMaestroMessage:String;
      
      [Inject]
      public var loyaltyController:LoyaltyController;
      
      private var _hasLogoutCompleted:Boolean = false;
      
      private var activeSubsidiaryController:IViewController;
      
      public var serverStatusController:IServerStatusProvider = ServerStatusProviderProxy.instance;
      
      public var clientNotificationController:IClientNotificationProvider = ClientNotificationProviderProxy.instance;
      
      private var koreanSelectiveShutdownLaw:KoreanSelectiveShutdownLaw;
      
      public var accountStateChangeEventListener:AccountStateChangeNotificationListener;
      
      private var _1001129699loginSuccessful:Boolean = false;
      
      public var masterGameViewController:MasterGameViewController;
      
      public var viewMediator:ViewMediator;
      
      public var serviceProxy:ServiceProxy = ServiceProxy.instance;
      
      public var userPreferencesManager:UserPreferencesManager = UserPreferencesManager.instance;
      
      private var _gameCrashCallbacksRegistered:Boolean = false;
      
      public var leaverBusterController:LeaverBusterController;
      
      public var presenceController:PresenceController;
      
      public var shellDispatcher:ShellDispatcher = ShellDispatcher.instance;
      
      private var _shutdownLawActive:Boolean = false;
      
      public var chatController:ChatController;
      
      private var _1895424275clientConfig:ClientConfig = ClientConfig.instance;
      
      public var storeController:StoreController;
      
      [Inject]
      public var chatRoomProvider:IChatRoomProvider;
      
      public var _reportTracker:HarassmentReportTracker = new HarassmentReportTracker();
      
      private var _sessionMetrics:ISessionMetricsProvider;
      
      public var rssAlertController:RSSAlertController;
      
      private var _409553451availableStates:ArrayCollection = new ArrayCollection(["AL","AK","AZ","AR","CA","CO","CT","DE","DC","FL","GA","HI","ID","IL","IN","IA","KS","KY","LA","ME","MD","MA","MI","MN","MS","MO","MT","NE","NV","NH","NJ","NM","NY","NC","ND","OH","OK","OR","PA","RI","SC","SD","TN","TX","UT","VT","VA","WA","WV","WI","WY","AB","BC","MB","NL","NB","NS","ON","PE","QC","NU","NT","YT","SK"]);
      
      [Inject]
      public var summonerNameController:SummonerNameController;
      
      private var _swiz:ISwiz;
      
      public var summonerController:SummonerController;
      
      public var kudosFactory:IKudosFactory = KudosFactoryProxy.getInstance();
      
      protected var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var gcCount:int;
      
      public var soundManager:ISoundProvider = SoundProviderProxy.instance;
      
      [Inject]
      public var rosterProvider:IChatRosterProvider;
      
      private var chineseAntiIndulgenceLaw:ChineseAntiIndulgenceLaw;
      
      public var inGameController:InGameController;
      
      private var _inGhostGame:Boolean;
      
      private var kudosEnabled:Boolean = false;
      
      public var realNameController:RealNameController;
      
      private var koreanShutdownLaw:KoreanShutdownLaw;
      
      public var playerPreferencesSyncController:PlayerPreferencesSyncController;
      
      [Inject]
      public var profileDisplayModel:ProfileDisplayModel;
      
      private var vietnamAntiAddictionLaw:VietnamAntiAddictionLaw;
      
      public function ApplicationController()
      {
         super();
      }
      
      private function onKudosReceived(param1:ClientNotificationEvent) : void
      {
         var _loc2_:PendingKudos = param1.notification as PendingKudos;
         this.kudosFactory.createKudosContextAlertCommand(_loc2_).execute();
      }
      
      private function onGotTournamentProvider(param1:ITournamentCodeProvider) : void
      {
         var _loc2_:ITournamentCodeProvider = param1;
         _loc2_.initialize(AppConfig.instance.availableMaps.source,GameTypeConfigManager.instance.getPracticeGameTypeConfigs().source);
         this.clientConfig.tournamentSupportAvailable = true;
      }
      
      private function initializeDataFromUserPreferencers() : void
      {
         this.masterGameController.championSmallIcons = UserPreferencesManager.userPrefs.championSmallIcons;
         ProviderLookup.getProvider(IMasteriesProvider,this.onMasteriesProviderRecieved);
      }
      
      private function onDeletePageAlertClosed() : void
      {
         this.lobbyController.reviewSummonerProfile(this.session.summoner,ProfilePagesEnum.MASTERIES_PAGE);
      }
      
      private function onLogoutSuccessWithoutExit(param1:ResultEvent) : void
      {
         this.preViewMediatorLogoutWork();
         this.lobbyController.initialize();
         this.viewMediator.handleLogoutWithoutExit();
      }
      
      private function saveLocalPreferences() : void
      {
         if(this.session.summoner == null)
         {
            this.userPreferencesManager.saveGlobalPreferences();
         }
         else
         {
            this.userPreferencesManager.saveUserPreferences(this.session.summoner.name);
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get availableStates() : ArrayCollection
      {
         return this._409553451availableStates;
      }
      
      private function onMaestroGameClientVersionMismatch(param1:Event) : void
      {
         this.masterGameController.onMaestroGameClientVersionMismatch();
      }
      
      public function forceExitWithoutLogout() : void
      {
         this.saveLocalPreferences();
         this.lobbyController.closeStoreSession();
         NativeApplication.nativeApplication.exit();
      }
      
      public function logMemorySnapshot() : void
      {
      }
      
      public function set availableStates(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._409553451availableStates;
         if(_loc2_ !== param1)
         {
            this._409553451availableStates = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"availableStates",_loc2_,param1));
         }
      }
      
      private function onLeagueUpdateReceived(param1:String, param2:String, param3:String, param4:String) : void
      {
         var data:Object = null;
         var uuid:String = param1;
         var status:String = param2;
         var payload:String = param3;
         var methodName:String = param4;
         if(status == LcdsProxyServiceMessenger.ACK_STATUS)
         {
         }
      }
      
      private function onLCDSChannelConnect(param1:ChannelEvent) : void
      {
         if(AppConfig.instance.currentAppState != IAppControllerConstants.LOGIN)
         {
            if(this.chatController.currentState == ChatController.OFFLINE)
            {
               this.chatController.reconnect();
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get gameQueueManager() : IGameQueueManager
      {
         return this._1137159790gameQueueManager;
      }
      
      private function onLogoutSuccessAfterAuthenticationError(param1:ResultEvent) : void
      {
         this.preViewMediatorLogoutWork();
      }
      
      public function restore() : void
      {
         if(!this.clientConfig.minimizeTurnedOff)
         {
            this.viewMediator.maximizeClient();
         }
      }
      
      public function minimizeToTray() : void
      {
         AppConfig.instance.minimized = true;
         if(!this.clientConfig.minimizeTurnedOff)
         {
            this.viewMediator.minimizeClient();
         }
      }
      
      public function get firstLogin() : Boolean
      {
         return this._firstLogin;
      }
      
      private function onLogoutComplete(param1:Boolean) : void
      {
         this.preViewMediatorLogoutWork();
         this.handleExit();
      }
      
      public function cleanup() : void
      {
         this.removeGameCrashCallbacks();
         this.shellDispatcher.removeEventListener(MaestroController.GAME_STARTED,this.onGameStarted);
         this.shellDispatcher.removeEventListener(MaestroController.GAME_COMPLETED,this.onGameCompleted);
         this.shellDispatcher.removeEventListener(MaestroController.MAESTRO_HEARTBEAT_ERROR,this.onMaestroHeartbeatError);
         this.shellDispatcher.removeEventListener(MaestroController.GAME_CLIENT_VERSION_MISMATCH,this.onMaestroGameClientVersionMismatch);
         this.shellDispatcher.removeEventListener(MaestroController.GAME_CLIENT_CONNECTED_TO_SERVER,this.onMaestroGameConnectedToServer);
         this.shellDispatcher.removeEventListener(RemoteServiceErrorEvent.SESSION_TIMEOUT,this.onSessionExpired);
         this.shellDispatcher.removeEventListener(RemoteServiceErrorEvent.SESSION_EXPIRATION_WARNING,this.onSessionExpirationWarning);
         this.shellDispatcher.removeEventListener(RemoteServiceErrorEvent.AUTHENTICATION_CREDENTIALS_ERROR,this.onAuthenticationCredentialsError);
         this.clientNotificationController.removeClientNotificationMessageListener(ClientNotificationType.FULFILLMENT,this.onStoreFulfillmentMessageReceived);
         this.clientNotificationController.removeClientNotificationMessageListener(ClientNotificationType.RENTAL_UPDATE,this.onRentalUpdateMessageReceived);
         this.serviceProxy.remoteObjectGeneratorService.removeChannelSetListener(ChannelEvent.CONNECT,this.onLCDSChannelConnect);
         this.serviceProxy.remoteObjectGeneratorService.removeChannelSetListener(ChannelEvent.DISCONNECT,this.onLCDSChannelDisconnect);
      }
      
      private function onLogoutSuccessWithExit(param1:ResultEvent) : void
      {
         this.cleanup();
         this.handleExit();
      }
      
      internal function internalLogout(param1:String, param2:Boolean = true) : void
      {
         var logoutReason:String = param1;
         var exitApplication:Boolean = param2;
         var logoutFunction:Function = null;
         var onCompleteFunction:Function = null;
         if(logoutReason == IAppControllerConstants.LOGOUT_REASON_SESSION_EXPIRED)
         {
            logoutFunction = this.onLogoutSuccessAfterSessionExpired;
         }
         else if(logoutReason == IAppControllerConstants.LOGOUT_REASON_AUTHENTICATION_ERROR)
         {
            logoutFunction = this.onLogoutSuccessAfterAuthenticationError;
         }
         else if(exitApplication)
         {
            onCompleteFunction = this.onLogoutComplete;
         }
         else
         {
            logoutFunction = this.onLogoutSuccessWithoutExit;
         }
         AppConfig.instance.loggingOut = true;
         if(GameVersionConfig.instance.installingPatch)
         {
            MaestroProviderProxy.instance.cancelInstall();
         }
         else if(GameVersionConfig.instance.uninstallingPatch)
         {
            MaestroProviderProxy.instance.cancelUninstall();
         }
         this.leaverBusterController.deactivate();
         this.masterGameController.currentState = GameViewState.NO_GAME;
         this.masterGameController.cleanupIfGameIsNotNull();
         this.lobbyController.closeStoreSession();
         try
         {
            if(this.activeSubsidiaryController != null)
            {
               this.activeSubsidiaryController.deactivate();
               this.activeSubsidiaryController = null;
            }
         }
         catch(error:Error)
         {
            logger.error("internalLougout: error cleaningup subsidiary controllers",error);
         }
         this.logoutOfChat();
         if(this._sessionMetrics)
         {
            this._sessionMetrics.sessionClosed();
         }
         ChampSelectTracker.instance.quitClient();
         UserFlow.track("session","logout");
         try
         {
            this.lobbyController.cleanup();
         }
         catch(error:Error)
         {
            logger.error("internalLougout: error cleaning up login and lobby controllers",error);
         }
         if(logoutReason == IAppControllerConstants.LOGOUT_REASON_SESSION_EXPIRED || logoutReason == IAppControllerConstants.LOGOUT_REASON_AUTHENTICATION_ERROR)
         {
            logoutFunction.apply(null,[null]);
         }
         else if(this.session.token == null)
         {
            if(logoutFunction != null)
            {
               logoutFunction.apply(this,[null]);
            }
            if(onCompleteFunction != null)
            {
               onCompleteFunction.apply(this,[false]);
            }
         }
         else
         {
            this.serviceProxy.loginService.logout(this.session.token,logoutFunction,onCompleteFunction);
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get session() : Session
      {
         return this._1984987798session;
      }
      
      private function onGotAccountManagementProvider(param1:IAccountManagementProvider) : void
      {
         param1.createEmailVerificationAlert(this.session.summoner.name);
      }
      
      public function get isMatchmakingEnabled() : Boolean
      {
         return this.clientConfig.enableMatchmaking;
      }
      
      private function onLoginKickMessageReceived(param1:ClientNotificationEvent) : void
      {
         if((param1.notification as ClientLoginKickNotification).sessionToken == this.session.token)
         {
            this.serviceProxy.messageRouterService.invalidateConsumers();
            this.viewMediator.showExitAlert("session_sessionExpiredOtherLoginErrorMessage","session_sessionExpiredOtherLoginErrorTitle");
         }
      }
      
      private function onAuthenticationCredentialsError(param1:RemoteServiceErrorEvent) : void
      {
         this.doSessionClosed(IAppControllerConstants.LOGOUT_REASON_AUTHENTICATION_ERROR);
      }
      
      public function getLastInterestingMaestroMessage() : String
      {
         return this._lastInterestingMaestroMessage;
      }
      
      private function onGameStarted(param1:Event) : void
      {
         this._lastInterestingMaestroMessage = param1.type;
         if(Boolean(WatchTabProviderProxy.instance.isEnabled()) && Boolean(WatchTabProviderProxy.instance.isReplayMode()))
         {
            return;
         }
         AppConfig.instance.currentAppState = IAppControllerConstants.LOBBY;
         this.lobbyController.requestLobbyState(LobbyViewState.PLAY_GAME_STATE);
         this.lobbyController.refreshStoreView();
      }
      
      private function onLogoutSuccessAfterSessionExpired(param1:ResultEvent) : void
      {
         this.preViewMediatorLogoutWork();
      }
      
      public function handlePasswordResetLogout(param1:ResultEvent) : void
      {
         this._hasLogoutCompleted = true;
         this.session.token = null;
      }
      
      private function doSessionClosed(param1:String) : void
      {
         this.internalLogout(param1);
      }
      
      private function onGameCompleted(param1:Event) : void
      {
         this._lastInterestingMaestroMessage = param1.type;
         if(Boolean(WatchTabProviderProxy.instance.isEnabled()) && Boolean(WatchTabProviderProxy.instance.isReplayMode()))
         {
            return;
         }
         AppConfig.instance.minimized = false;
         this.masterGameController.gameCompleted();
         this.viewMediator.maximizeClient();
      }
      
      private function onRentalUpdateMessageReceived(param1:ClientNotificationEvent) : void
      {
         var _loc2_:RentalUpdateNotification = param1.notification as RentalUpdateNotification;
         InventoryProviderProxy.instance.getInventoryController().processRentalUpdateNotification(_loc2_);
      }
      
      public function home() : void
      {
         AppConfig.instance.currentAppState = IAppControllerConstants.LOBBY;
         if(this.masterGameController.currentState == GameViewState.JOIN_QUEUE)
         {
            this.lobbyController.requestLobbyState(LobbyViewState.CREATE_ARRANGED_TEAM_STATE);
         }
         else
         {
            this.lobbyController.requestLobbyState(LobbyViewState.LOBBY_LANDING_STATE);
         }
         LobbyConfig.instance.isNavigationEnabled = true;
         AppConfig.instance.isNavigatorVisible = true;
      }
      
      private function onKudosSet(param1:Boolean) : void
      {
         PlatformConfigProviderProxy.instance.getPlatformConfig().kudosEnabledChanged.add(this.updateKudosEnabled);
         this.updateKudosEnabled(param1);
      }
      
      private function onMaestroHeartbeatError(param1:Event) : void
      {
         if(AppConfig.instance.minimized)
         {
            this.internalLogout(IAppControllerConstants.LOGOUT_REASON_MAESTRO_HEARTBEAT);
         }
      }
      
      private function updateSummonerDataInAccountSummary() : void
      {
         this.session.accountSummary.summonerName = this.session.summoner.name;
         this.session.accountSummary.summonerInternalName = this.session.summoner.internalName;
      }
      
      public function get summonerCatalog() : SummonerCatalog
      {
         return this.session.summonerCatalog;
      }
      
      [Bindable(event="propertyChange")]
      public function get loginSuccessful() : Boolean
      {
         return this._1001129699loginSuccessful;
      }
      
      public function initializeAppController() : void
      {
         var leagueMessenger:LcdsProxyFunctionMessenger;
         var lcdsProxyMessageRouter:ILcdsProxyMessageRouter;
         var sortField:SortField;
         var sort:Sort;
         var alertAction:AlertAction = null;
         AppConfig.instance.currentAppStateChanged.add(this.onCurrentAppStateChanged);
         LobbyConfig.instance.currentLobbyStateChanged.add(this.onLobbyStateChanged);
         PlatformConfigProviderProxy.instance.getPlatformConfig().kudosSet.add(this.onKudosSet);
         PlatformConfigProviderProxy.instance.getPlatformConfig().enabledQueueIdsListChanged.add(this.updateEnabledQueueIdsList);
         this.updateEnabledQueueIdsList(PlatformConfigProviderProxy.instance.getPlatformConfig().enabledQueueIdsList);
         this.shellDispatcher.addEventListener(MaestroController.MAESTRO_HEARTBEAT_ERROR,this.onMaestroHeartbeatError);
         this.shellDispatcher.addEventListener(RemoteServiceErrorEvent.AUTHENTICATION_CREDENTIALS_ERROR,this.onAuthenticationCredentialsError);
         this.shellDispatcher.addEventListener(RemoteServiceErrorEvent.SESSION_TIMEOUT,this.onSessionExpired);
         this.shellDispatcher.addEventListener(RemoteServiceErrorEvent.SESSION_EXPIRATION_WARNING,this.onSessionExpirationWarning);
         this.shellDispatcher.addEventListener(MaestroController.GAME_STARTED,this.onGameStarted);
         this.shellDispatcher.addEventListener(MaestroController.GAME_COMPLETED,this.onGameCompleted);
         this.shellDispatcher.addEventListener(MaestroController.GAME_CLIENT_VERSION_MISMATCH,this.onMaestroGameClientVersionMismatch);
         this.shellDispatcher.addEventListener(MaestroController.GAME_CLIENT_CONNECTED_TO_SERVER,this.onMaestroGameConnectedToServer);
         if(!this.clientConfig.preloadGameClient)
         {
            this.registerGameCrashCallbacks();
         }
         if(this.clientConfig.clientMode == ClientConfig.SPECIAL_MODE_TENCENT)
         {
            BuddyImages.uniqueCollection = BuddyImages.TENCENT_COLLECTION;
         }
         sort = new Sort();
         sortField = new SortField();
         sort.fields = [sortField];
         this.availableCountries.sort = sort;
         this.availableCountries.refresh();
         this.lobbyController.initialize();
         this.inGameController.initialize();
         this.presenceController.initialize();
         this.clientNotificationController.addClientNotificationMessageListener(ClientNotificationType.FULFILLMENT,this.onStoreFulfillmentMessageReceived);
         this.clientNotificationController.addClientNotificationMessageListener(ClientNotificationType.ACCOUNT_BALANCE,this.onStoreAccountBalanceMessageReceived);
         this.clientNotificationController.addClientNotificationMessageListener(ClientNotificationType.FORCED_SHUTDOWN,this.onForcedShutdownMessageReceived);
         this.clientNotificationController.addClientNotificationMessageListener(ClientNotificationType.RENTAL_UPDATE,this.onRentalUpdateMessageReceived);
         this.clientNotificationController.addClientNotificationMessageListener(ClientNotificationType.ACCOUNT_STATE_CHANGE,this.onAccountStateChangeMessageReceived);
         this.clientNotificationController.addClientNotificationMessageListener(ClientNotificationType.LOYALTY_STATE_CHANGE,this.onLoyaltyStateChangeMessageReceived);
         this.clientNotificationController.addClientNotificationMessageListener(ClientNotificationType.LOGIN_KICK,this.onLoginKickMessageReceived);
         this.clientNotificationController.addClientNotificationMessageListener(ClientNotificationType.KUDOS_RECEIVED,this.onKudosReceived);
         leagueMessenger = new LcdsProxyFunctionMessenger(this.onLeagueUpdateReceived);
         lcdsProxyMessageRouter = this.clientNotificationController.getLcdsProxyMessageRouter();
         lcdsProxyMessageRouter.setServiceCallListener(ClientNotificationProxyServiceName.LEAGUE,leagueMessenger);
         this.serviceProxy.remoteObjectGeneratorService.addChannelSetListener(ChannelEvent.CONNECT,this.onLCDSChannelConnect);
         this.serviceProxy.remoteObjectGeneratorService.addChannelSetListener(ChannelEvent.DISCONNECT,this.onLCDSChannelDisconnect);
         if(Session.instance.passwordResetLockout)
         {
            this._hasLogoutCompleted = true;
            this.home();
            alertAction = new AlertAction(ResourceManager.getInstance().getString("resources","resetPassword_dialogTitle"),ResourceManager.getInstance().getString("resources","resetPassword_passwordNeedsResetLineOne") + " " + ResourceManager.getInstance().getString("resources","resetPassword_passwordNeedsResetLineTwo") + "\n" + ResourceManager.getInstance().getString("resources","resetPasswordURL"));
            alertAction.getCompleted().add(function():void
            {
               logout(true);
            });
            alertAction.add();
         }
         else
         {
            this.soundManager.stopLoginMusic();
            this.loadLoginDataOrPromptForBetaKey();
         }
         if(this._sessionMetrics == null)
         {
            ProviderLookup.getProvider(ISessionMetricsProvider,this.onSessionMetricsProvided);
         }
      }
      
      private function onSessionExpirationWarning(param1:Event) : void
      {
         if(AppConfig.instance.currentAppState == IAppControllerConstants.LOBBY && LobbyConfig.instance.currentLobbyState == LobbyViewState.STORE_VIEW_STATE)
         {
            this.lobbyController.showLobbyLanding();
         }
      }
      
      private function onPagesInfoChange(param1:CollectionEvent) : void
      {
         var _loc3_:MasteryPageInfoSummary = null;
         var _loc4_:AlertAction = null;
         var _loc2_:ArrayCollection = param1.target as ArrayCollection;
         if(_loc2_.length == 1)
         {
            _loc3_ = _loc2_.getItemAt(0) as MasteryPageInfoSummary;
            if(_loc3_.totalSpentPoints == 0)
            {
               if(UserPreferencesManager.userPrefs.masteryPages != null)
               {
                  _loc4_ = new AlertAction("",RiotResourceLoader.getString("talentTree_localPagesPopupText","Local Pages gone. Server pages now"));
                  _loc4_.getCompleted().addOnce(this.onDeletePageAlertClosed);
                  _loc4_.add();
               }
               UserPreferencesManager.userPrefs.masteryPages = null;
            }
         }
         _loc2_.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.onPagesInfoChange);
      }
      
      [Bindable(event="propertyChange")]
      public function get clientConfig() : ClientConfig
      {
         return this._1895424275clientConfig;
      }
      
      private function checkLeaverPenaltyPopup(param1:int) : void
      {
         if(param1 <= 0)
         {
            return;
         }
         var _loc2_:int = param1;
         if(_loc2_ > 4)
         {
            _loc2_ = 4;
         }
         var _loc3_:String = "leaver_penalty_warning_" + _loc2_;
         var _loc4_:AlertAction = new AlertAction(ResourceManager.getInstance().getString("resources","leaver_penalty_warning_title"),ResourceManager.getInstance().getString("resources",_loc3_));
         _loc4_.add();
      }
      
      public function initializeChat(param1:Boolean = false) : void
      {
         if(Boolean(this.clientConfig.START_CHAT_PROP) && this.session.summoner != null && this.session.summoner.sumId > 0 && !this.chatController.loggedIn)
         {
            this.session.useGasTokenForChatPassword = DynamicClientConfigManager.getConfiguration("Chat","GasTokenChatEnabled",false).getValue();
            this.chatController.login(this.session.accountSummary.username,this.session.getChatPassword(),this.session.accountSummary.summonerName,this.session.summoner.profileIconId,param1);
            this.chatController.realNameController = this.realNameController;
         }
      }
      
      public function set gameQueueManager(param1:IGameQueueManager) : void
      {
         var _loc2_:Object = this._1137159790gameQueueManager;
         if(_loc2_ !== param1)
         {
            this._1137159790gameQueueManager = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gameQueueManager",_loc2_,param1));
         }
      }
      
      private function onGetLeaguePositions(param1:ResultEvent) : void
      {
         if(param1.result is SummonerLeagueItemsDTO)
         {
            this.serviceProxy.leagueService.cache.updatePrescenceData(param1.result as SummonerLeagueItemsDTO);
         }
         var _loc2_:LeagueItemDTO = this.serviceProxy.leagueService.cache.getTopLeagueForChatPrescence();
         this.presenceController.updateLeagueData(_loc2_);
      }
      
      public function onSessionMetricsProvided(param1:ISessionMetricsProvider) : void
      {
         this._sessionMetrics = param1;
      }
      
      private function onAccountStateChangeMessageReceived(param1:ClientNotificationEvent) : void
      {
         var _loc2_:AccountStateChangeNotification = param1.notification as AccountStateChangeNotification;
         this.accountStateChangeEventListener.handleAccountStateChangeEvent(_loc2_);
      }
      
      private function preViewMediatorLogoutWork() : void
      {
         this.serviceProxy.remoteObjectGeneratorService.expireAuthenticationChannel();
         AppConfig.instance.loggingOut = false;
         this._hasLogoutCompleted = true;
         this.session.token = null;
         this.session.summoner = null;
         this.cleanup();
      }
      
      private function loadLoginDataOrPromptForBetaKey() : void
      {
         var rankedTeamsProvider:IRankedTeamsProvider;
         var masteriesProvider:IMasteriesProvider;
         var serverStatusAPIEnabled:ConfigurationModel;
         var msg:BroadcastMessage = null;
         if(this.session == null || this.session.accountSummary == null)
         {
            return;
         }
         CursorManager.getInstance().removeBusyCursor();
         this.knownMaps = GeneratedContentLoader.instance.mapData;
         AppConfig.instance.otherGameInProgress = false;
         this._inGhostGame = LoginConfig.instance.inGhostGame;
         if(this.session.summoner != null)
         {
            this.initializeDataFromUserPreferencers();
            ProviderLookup.getProvider(IInventoryProvider,function(param1:IInventoryProvider):void
            {
               ChromeContextAlertProviderProxy.instance.initialize(param1.getInventoryController(),session,AlerterProviderProxy.instance);
               ChromeContextAlertProviderProxy.instance.runExpiredBoostScript(param1.getInventory().activeBoosts);
            });
            this._firstLogin = this.session.summoner.displayEloQuestionaire;
         }
         else
         {
            this._firstLogin = true;
         }
         this.isMatchmakingEnabled = LoginConfig.instance.matchMakingEnabled;
         this.clientConfig.maxPracticeGameSize = LoginConfig.instance.maxPracticeGameSize;
         this.clientConfig.languages = LoginConfig.instance.languages;
         if(this.clientConfig.languages == null || this.clientConfig.languages.length <= 1)
         {
            this.clientConfig.showLanguageChoices = false;
         }
         else
         {
            this.clientConfig.showLanguageChoices = true;
         }
         if(this.session.summoner != null)
         {
            if(this.session.summoner.profileIconId > -1)
            {
               AppConfig.instance.summonerIconSource = BuddyImages.getSummonerIconSafely(this.session.summoner.profileIconId);
               this.presenceController.setSummonerProfileIcon(this.session.summoner.profileIconId,true);
            }
            this.loginSuccessful = true;
         }
         if(LoginConfig.instance.reconnectInfo != null)
         {
            if(LoginConfig.instance.reconnectInfo.game != null)
            {
               this.masterGameController.currentGame = LoginConfig.instance.reconnectInfo.game;
            }
            if(LoginConfig.instance.hasReconnected)
            {
               this.onGameStarted(new Event(MaestroController.GAME_STARTED));
               this.inGameController.currentState = InGameController.PLAYING_CONNECTED;
               this.masterGameController.initializeCycle();
               this.masterGameController.currentState = GameViewState.PLAYING_GAME;
            }
            else
            {
               AppConfig.instance.currentAppState = IAppControllerConstants.RECONNECT;
               this.inGameController.setDisconnected();
            }
         }
         else
         {
            this.viewMediator.showSummonerWizardOrMainLobbyView();
         }
         if(AppConfig.instance.summonerIconSource == null)
         {
            AppConfig.instance.summonerIconSource = BuddyImages.getSummonerIconSafely(0);
         }
         this.presenceController.updateProfileStats(this.session.summonerLevel ? int(this.session.summonerLevel.summonerLevel) : 0,LoginConfig.instance.playerStatSummaries,this.session.summoner ? this.session.summoner.previousSeasonHighestTier : null);
         this.presenceController.setRankedSoloRestricted(this.session.rankedRestrictedGamesRemaining > 0);
         if(this.clientConfig.leagueServiceEnabled)
         {
            this.onLeagueServiceEnabledDisabled(true,true);
         }
         this.rssAlertController.checkRSSFeeds();
         serverStatusAPIEnabled = DynamicClientConfigManager.getConfiguration(RiotServiceConfig.SERVICE_STATUS_API_NAMESPACE,RiotServiceConfig.SERVICE_STATUS_API_ENABLED,false);
         if(serverStatusAPIEnabled.getBoolean() == false && LoginConfig.instance.broadcastNotification != null)
         {
            this.serverStatusController.clearPlatformMessages();
            if(LoginConfig.instance.broadcastNotification.broadcastMessages != null && LoginConfig.instance.broadcastNotification.broadcastMessages.length > 0)
            {
               for each(msg in LoginConfig.instance.broadcastNotification.broadcastMessages)
               {
                  msg.flagOnLoginDataPacket();
                  this.serverStatusController.addPlatformMessage(msg);
               }
            }
         }
         if(!this._firstLogin && this.leaverBusterController.shouldPreventAlternateLogin(LoginConfig.instance.leaverBusterPenaltyTime))
         {
            this.leaverBusterController.checkGameState(this.onLeaverGameStateComplete);
         }
         else
         {
            this.initializeChat();
         }
         this.leaverBusterController.activate();
         this.checkLeaverPenaltyPopup(LoginConfig.instance.leaverPenaltyLevel);
         this.vietnamAntiAddictionLaw = new VietnamAntiAddictionLaw(this,this.masterGameController,LoginConfig.instance.bingePreventionSystemEnabledForClient);
         this.clientNotificationController.addClientNotificationMessageListener(ClientNotificationType.BINGE_PREVENTION,this.vietnamAntiAddictionLaw.onBingePreventionNotificationReceived);
         if(LoginConfig.instance.bingeIsPlayerInBingePreventionWindow)
         {
            this.vietnamAntiAddictionLaw.apply(LoginConfig.instance.bingeIsPlayerInBingePreventionWindow,LoginConfig.instance.bingeMinutesRemaining);
         }
         this.chineseAntiIndulgenceLaw = new ChineseAntiIndulgenceLaw();
         this.chineseAntiIndulgenceLaw.apply();
         this.koreanShutdownLaw = new KoreanShutdownLaw(this,this.masterGameController);
         this.koreanSelectiveShutdownLaw = new KoreanSelectiveShutdownLaw(this,this.masterGameController,this.chatController,this.clientConfig.locale);
         if(LoginConfig.instance.minutesUntilShutdownEnabled)
         {
            this.koreanSelectiveShutdownLaw.playReminderMessages();
         }
         if(Boolean(LoginConfig.instance.minor) && Boolean(LoginConfig.instance.minorShutdownEnforced) && Boolean(LoginConfig.instance.minutesUntilShutdownEnabled))
         {
            if(LoginConfig.instance.minutesUntilShutdown < 0)
            {
               LoginConfig.instance.minutesUntilShutdownEnabled = false;
            }
         }
         if(!this.koreanSelectiveShutdownLaw.apply(LoginConfig.instance.minutesUntilShutdownEnabled,LoginConfig.instance.minutesUntilShutdown))
         {
            this.koreanShutdownLaw.apply(LoginConfig.instance.minor,LoginConfig.instance.minorShutdownEnforced,LoginConfig.instance.minutesUntilMidnight);
         }
         if(LoginConfig.instance.showEmailVerificationPopup)
         {
            ProviderLookup.getProvider(IAccountManagementProvider,this.onGotAccountManagementProvider);
         }
         this.kudosFactory.createKudosContextAlertCommand(LoginConfig.instance.pendingKudosDTO,false).execute();
         this.kudosFactory.createKudosBadgeDialogCommand(LoginConfig.instance.pendingBadges,KudosBadgeDialog.DEFAULT_BADGE_DIALOGUE_DELAY).execute();
         if(this.clientConfig.playerPreferencesSyncing)
         {
            this.playerPreferencesSyncController.loadFromServerIfNeeded(PlayerPreferencesSyncController.PREFERENCES_KEYBINDING);
         }
         rankedTeamsProvider = RankedTeamsProviderProxy.instance;
         rankedTeamsProvider.setExternalChatAndProfileManagers(this.chatRoomProvider,this.rosterProvider,this.profileDisplayModel);
         masteriesProvider = MasteriesProviderProxy.instance;
         ProviderLookup.getProvider(ITournamentCodeProvider,this.onGotTournamentProvider);
         this.clientNotificationController.enableNotificationProcessing();
      }
      
      private function onGameCrashedOrAbandoned(param1:Event) : void
      {
         this._lastInterestingMaestroMessage = param1.type;
         if(Boolean(WatchTabProviderProxy.instance.isEnabled()) && Boolean(WatchTabProviderProxy.instance.isReplayMode()))
         {
            return;
         }
         AppConfig.instance.minimized = false;
         this.viewMediator.maximizeClient();
         if(this.masterGameController.currentState == GameViewState.NO_GAME || this.masterGameController.currentState == GameViewState.GAME_OVER)
         {
            AppConfig.instance.currentAppState = IAppControllerConstants.LOBBY;
         }
         else
         {
            AppConfig.instance.currentAppState = IAppControllerConstants.RECONNECT;
         }
      }
      
      public function removeGameCrashCallbacks() : void
      {
         if(this._gameCrashCallbacksRegistered)
         {
            this.shellDispatcher.removeEventListener(GameCrashedEvent.CRASHED_EVENT_FROM_GAME,this.onGameCrashedOrAbandoned);
            this.shellDispatcher.removeEventListener(MaestroController.GAME_ABANDONED,this.onGameCrashedOrAbandoned);
            this._gameCrashCallbacksRegistered = false;
         }
      }
      
      public function shutdownConnections() : void
      {
         if(this.serviceProxy.messageRouterService != null)
         {
            this.serviceProxy.messageRouterService.disconnect();
         }
      }
      
      private function onForcedShutdownMessageReceived(param1:ClientNotificationEvent) : void
      {
         var _loc3_:String = null;
         var _loc2_:ForcedClientShutdown = param1.notification as ForcedClientShutdown;
         if(_loc2_.isBanned())
         {
            _loc3_ = "session_sessionBannedErrorMessage";
            if(_loc2_.additionalInfo)
            {
               _loc3_ = _loc3_ + "-" + _loc2_.additionalInfo;
            }
            this.viewMediator.showExitAlert(_loc3_,"session_sessionBannedErrorTitle");
         }
         else if(_loc2_.isBannedForLeaving())
         {
            this.viewMediator.showExitAlert("session_sessionBannedForLeavingErrorMessage","session_sessionBannedForLeavingErrorTitle");
         }
         else
         {
            this.viewMediator.showExitAlert("session_sessionSuspendedErrorMessage","session_sessionSuspendedErrorTitle");
         }
      }
      
      public function set swiz(param1:ISwiz) : void
      {
         this._swiz = param1;
      }
      
      public function set shutdownLawActive(param1:Boolean) : void
      {
         this._shutdownLawActive = param1;
      }
      
      private function onCancelledQueueFromLogout(param1:Boolean) : void
      {
         if(param1)
         {
            this.internalLogout(IAppControllerConstants.LOGOUT_REASON_NORMAL,this.shouldExitAfterLogout);
         }
      }
      
      private function onStoreFulfillmentMessageReceived(param1:ClientNotificationEvent) : void
      {
         var _loc2_:StoreFulfillmentNotification = param1.notification as StoreFulfillmentNotification;
         InventoryProviderProxy.instance.getInventoryController().processStoreFulfillmentNotification(_loc2_);
         this.reportStoreFulfillment(_loc2_);
         this.summonerNameController.processStoreFulfillmentNotification(_loc2_);
      }
      
      private function updateKudosEnabled(param1:Boolean) : void
      {
         this.kudosFactory.updateKudosState(param1,this.serviceProxy);
      }
      
      public function getMapByName(param1:String) : GameMap
      {
         var _loc2_:GameMap = null;
         for each(_loc2_ in this.knownMaps)
         {
            if(_loc2_ != null && param1 != null && _loc2_.name.toLowerCase() == param1.toLowerCase())
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function set session(param1:Session) : void
      {
         var _loc2_:Object = this._1984987798session;
         if(_loc2_ !== param1)
         {
            this._1984987798session = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"session",_loc2_,param1));
         }
      }
      
      private function reportStoreAccountBalance(param1:StoreAccountBalanceNotification) : void
      {
         var _loc2_:Object = new Object();
         _loc2_["ip"] = param1.ip;
         _loc2_["rp"] = param1.rp;
      }
      
      public function get reportTracker() : IReportTracker
      {
         return this._reportTracker;
      }
      
      private function onSessionExpired(param1:RemoteServiceErrorEvent) : void
      {
         this.doSessionClosed(IAppControllerConstants.LOGOUT_REASON_SESSION_EXPIRED);
      }
      
      private function set _927854267isMatchmakingEnabled(param1:Boolean) : void
      {
         this.clientConfig.enableMatchmaking = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function set isMatchmakingEnabled(param1:Boolean) : void
      {
         var _loc2_:Object = this.isMatchmakingEnabled;
         if(_loc2_ !== param1)
         {
            this._927854267isMatchmakingEnabled = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isMatchmakingEnabled",_loc2_,param1));
         }
      }
      
      public function registerGameCrashCallbacks() : void
      {
         if(!this._gameCrashCallbacksRegistered)
         {
            this.shellDispatcher.addEventListener(GameCrashedEvent.CRASHED_EVENT_FROM_GAME,this.onGameCrashedOrAbandoned);
            this.shellDispatcher.addEventListener(MaestroController.GAME_ABANDONED,this.onGameCrashedOrAbandoned);
            this._gameCrashCallbacksRegistered = true;
         }
      }
      
      private function updateEnabledQueueIdsList(param1:ArrayCollection) : void
      {
         if(param1 != null)
         {
            this.gameQueueManager.checkQueuesHaveChanged(param1);
         }
      }
      
      public function handleExit() : void
      {
         this.shellDispatcher.dispatchEvent(new ShellEvent(ShellEvent.EXIT));
      }
      
      private function onMaestroGameConnectedToServer(param1:Event) : void
      {
         this.masterGameController.onMaestroGameConnectedToServer();
      }
      
      private function onInviteProviderForRename(param1:IInviteProvider) : void
      {
         var _loc2_:InviteGroup = param1.getInviteGroup();
         _loc2_.myJID = param1.getInviteGroup().myJID;
         _loc2_.myUserName = this.session.summoner.name;
         _loc2_.myUserIconId = param1.getInviteGroup().myUserIconId;
      }
      
      public function get shutdownLawActive() : Boolean
      {
         return this._shutdownLawActive;
      }
      
      private function reportStoreFulfillment(param1:StoreFulfillmentNotification) : void
      {
         var _loc2_:Object = new Object();
         _loc2_["inventoryType"] = param1.inventoryType;
         _loc2_["data"] = param1.data;
         _loc2_["ip"] = param1.ip;
         _loc2_["rp"] = param1.rp;
      }
      
      public function logout(param1:Boolean = true) : void
      {
         CursorManager.setBusyCursor();
         this.saveLocalPreferences();
         if(LobbyConfig.instance.matchmakingState == MatchMakingState.MATCHMAKING_QUEUED)
         {
            this.shouldExitAfterLogout = param1;
            this.masterGameViewController.cancelWaitingForGame(this.onCancelledQueueFromLogout);
         }
         else
         {
            this.internalLogout(IAppControllerConstants.LOGOUT_REASON_NORMAL,param1);
            if(param1 == false)
            {
               CursorManager.removeBusyCursor();
            }
         }
      }
      
      private function onCurrentAppStateChanged(param1:String, param2:String) : void
      {
         var _loc3_:IViewController = this.activeSubsidiaryController;
         switch(param2)
         {
            case IAppControllerConstants.LOBBY:
               this.activeSubsidiaryController = this.lobbyController;
               if(param1 == IAppControllerConstants.RECONNECT)
               {
                  _loc3_ = null;
                  AppConfig.instance.isNavigatorVisible = false;
               }
               else
               {
                  AppConfig.instance.isNavigatorVisible = true;
               }
               break;
            case IAppControllerConstants.CHOOSE_GAME_FLOW:
               _loc3_ = null;
               break;
            case IAppControllerConstants.RECONNECT:
               this.activeSubsidiaryController = this.inGameController;
               this.initializeChat(true);
               break;
            case IAppControllerConstants.PARTNER_BETA_BLOCKED:
               this.viewMediator.showPartnerBetaBlockedMessage();
               break;
            default:
               this.activeSubsidiaryController = null;
         }
         if(_loc3_ != null && _loc3_ != this.activeSubsidiaryController)
         {
            _loc3_.deactivate();
         }
         if(this.activeSubsidiaryController != null)
         {
            this.activeSubsidiaryController.activate();
         }
         this.logMemorySnapshot();
      }
      
      private function dataLoadErredHandler(param1:IAction) : void
      {
         this.logger.error(param1.getError().message);
      }
      
      private function onMasteriesProviderRecieved(param1:IMasteriesProvider) : void
      {
         var _loc2_:ArrayCollection = param1.getPagesInfo();
         _loc2_.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onPagesInfoChange);
      }
      
      private function onLobbyStateChanged(param1:String, param2:String) : void
      {
         switch(param2)
         {
            case LobbyViewState.PLAY_PRACTICE_GAME_STATE:
               this.queueNavigatorVisibility(true);
               break;
            case LobbyViewState.PLAY_GAME_STATE:
               this.queueNavigatorVisibility(false);
               break;
            default:
               this.queueNavigatorVisibility(true);
         }
      }
      
      public function set loginSuccessful(param1:Boolean) : void
      {
         var _loc2_:Object = this._1001129699loginSuccessful;
         if(_loc2_ !== param1)
         {
            this._1001129699loginSuccessful = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"loginSuccessful",_loc2_,param1));
         }
      }
      
      public function getGameMap(param1:Number) : GameMap
      {
         var _loc2_:GameMap = null;
         for each(_loc2_ in this.knownMaps)
         {
            if(_loc2_ != null && _loc2_.mapId == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function set availableCountries(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._1852489237availableCountries;
         if(_loc2_ !== param1)
         {
            this._1852489237availableCountries = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"availableCountries",_loc2_,param1));
         }
      }
      
      public function logoutSessionExpired() : void
      {
         this.internalLogout(IAppControllerConstants.LOGOUT_REASON_SESSION_EXPIRED,false);
      }
      
      public function onSummonerCreated() : void
      {
         this.updateSummonerDataInAccountSummary();
         this.viewMediator.handleCreateSummoner();
         this.initializeChat();
      }
      
      private function onLeaverGameStateComplete(param1:Boolean, param2:String) : void
      {
         if(param1)
         {
            AppConfig.instance.otherGameInProgress = true;
            AppConfig.instance.otherAccountGameInProgressSummonerName = param2;
            AppConfig.instance.currentAppState = IAppControllerConstants.RECONNECT;
         }
         else
         {
            this.initializeChat();
         }
      }
      
      private function onLCDSChannelDisconnect(param1:ChannelEvent) : void
      {
      }
      
      public function get hasLogoutCompleted() : Boolean
      {
         return this._hasLogoutCompleted;
      }
      
      public function onSummonerRenamed(param1:Boolean = false) : void
      {
         this.updateSummonerDataInAccountSummary();
         if(param1)
         {
            this.viewMediator.handleRenameSummoner();
         }
         this.chatController.currentUserDisplayName = this.session.summoner.name;
         this.presenceController.sendPresenceUpdate();
         this.chatController.closeAllChatRooms();
         ProviderLookup.getProvider(IInviteProvider,this.onInviteProviderForRename);
      }
      
      public function set clientConfig(param1:ClientConfig) : void
      {
         var _loc2_:Object = this._1895424275clientConfig;
         if(_loc2_ !== param1)
         {
            this._1895424275clientConfig = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"clientConfig",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get availableCountries() : ArrayCollection
      {
         return this._1852489237availableCountries;
      }
      
      private function onLoyaltyStateChangeMessageReceived(param1:ClientNotificationEvent) : void
      {
         var _loc2_:LoyaltyStateChangeNotification = param1.notification as LoyaltyStateChangeNotification;
         this.loyaltyController.processLoyaltyStateUpdate(_loc2_);
      }
      
      public function isInGhostGame() : Boolean
      {
         return this._inGhostGame && null == this._lastInterestingMaestroMessage;
      }
      
      private function onLeagueServiceEnabledDisabled(param1:Boolean, param2:Boolean) : void
      {
         if(param2)
         {
            this.serviceProxy.leagueService.getMyLeaguePositions(this.onGetLeaguePositions);
         }
      }
      
      private function onStoreAccountBalanceMessageReceived(param1:ClientNotificationEvent) : void
      {
         var _loc2_:StoreAccountBalanceNotification = param1.notification as StoreAccountBalanceNotification;
         this.reportStoreAccountBalance(_loc2_);
         InventoryProviderProxy.instance.getInventoryController().processAccountBalanceNotification(_loc2_);
         ChromeContextAlertProviderProxy.instance.runStoreScript();
      }
      
      private function queueNavigatorVisibility(param1:Boolean) : void
      {
         LobbyConfig.instance.isNavigationEnabled = param1;
         AppConfig.instance.isNavigatorVisible = param1;
      }
      
      private function logoutOfChat() : void
      {
         try
         {
            if(this.clientConfig.START_CHAT_PROP)
            {
               this.chatController.logout();
            }
         }
         catch(error:Error)
         {
            logger.error("internalLougout: error cleaning up chat controllers",error);
         }
      }
   }
}

