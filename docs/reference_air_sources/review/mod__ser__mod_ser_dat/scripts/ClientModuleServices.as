package
{
   import com.riotgames.platform.common.RiotServiceConfig;
   import com.riotgames.platform.common.provider.IServicesProvider;
   import com.riotgames.platform.common.services.IAuthService;
   import com.riotgames.platform.common.services.InventoryService;
   import com.riotgames.platform.common.services.LoginService;
   import com.riotgames.platform.common.services.RemoteObjectGeneratorService;
   import com.riotgames.platform.common.services.RerollService;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.common.services.StatisticsService;
   import com.riotgames.platform.common.services.login.queue.PollingLoginQueueMonitor;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.gameclient.module.services.RemoteObjectGenerator;
   import com.riotgames.platform.gameclient.module.services.async.MessageRouterServiceImpl;
   import com.riotgames.platform.gameclient.module.services.lcds.AccountManagementServiceImpl;
   import com.riotgames.platform.gameclient.module.services.lcds.AccountServiceImpl;
   import com.riotgames.platform.gameclient.module.services.lcds.BaseLcdsService;
   import com.riotgames.platform.gameclient.module.services.lcds.CLSServicePlatformImpl;
   import com.riotgames.platform.gameclient.module.services.lcds.ChampionTradeService;
   import com.riotgames.platform.gameclient.module.services.lcds.ChatServiceImpl;
   import com.riotgames.platform.gameclient.module.services.lcds.ClientFacadeServiceImpl;
   import com.riotgames.platform.gameclient.module.services.lcds.GameInviteServiceImpl;
   import com.riotgames.platform.gameclient.module.services.lcds.GameMapServiceImpl;
   import com.riotgames.platform.gameclient.module.services.lcds.GameServiceImpl;
   import com.riotgames.platform.gameclient.module.services.lcds.InventoryServiceImpl;
   import com.riotgames.platform.gameclient.module.services.lcds.LoginServiceImpl;
   import com.riotgames.platform.gameclient.module.services.lcds.MasteryBookServiceImpl;
   import com.riotgames.platform.gameclient.module.services.lcds.MatchMakerServiceImpl;
   import com.riotgames.platform.gameclient.module.services.lcds.MicroFeedbackServiceImpl;
   import com.riotgames.platform.gameclient.module.services.lcds.PlayerPreferencesServiceImpl;
   import com.riotgames.platform.gameclient.module.services.lcds.PlayerStatsServiceImpl;
   import com.riotgames.platform.gameclient.module.services.lcds.QueueRestrictionServiceImpl;
   import com.riotgames.platform.gameclient.module.services.lcds.RerollServiceImpl;
   import com.riotgames.platform.gameclient.module.services.lcds.SpellBookServiceImpl;
   import com.riotgames.platform.gameclient.module.services.lcds.StatisticsServiceImpl;
   import com.riotgames.platform.gameclient.module.services.lcds.SummonerIconServiceImpl;
   import com.riotgames.platform.gameclient.module.services.lcds.SummonerRuneServiceImpl;
   import com.riotgames.platform.gameclient.module.services.lcds.SummonerServiceImpl;
   import com.riotgames.platform.gameclient.module.services.lcds.TeamServiceImpl;
   import com.riotgames.platform.gameclient.module.services.local.LocalGameDataServiceImpl;
   import com.riotgames.platform.gameclient.module.services.maestro.MaestroServiceImpl;
   import com.riotgames.platform.gameclient.module.services.mail.SMTPMailServiceImpl;
   import com.riotgames.platform.gameclient.module.services.rest.RemoteObjectGeneratorServiceImpl;
   import com.riotgames.platform.gameclient.module.services.rest.RestAuthService;
   import com.riotgames.platform.gameclient.module.services.rest.ServerStatusServiceImpl;
   import com.riotgames.platform.gameclient.module.services.watch.ReplayDownloadService;
   import com.riotgames.platform.gameclient.module.services.watch.ReplayFileManagerService;
   import com.riotgames.platform.gameclient.services.AccountManagementService;
   import com.riotgames.platform.gameclient.services.AccountService;
   import com.riotgames.platform.gameclient.services.CLSServicePlatform;
   import com.riotgames.platform.gameclient.services.ClientFacadeService;
   import com.riotgames.platform.gameclient.services.GameMapService;
   import com.riotgames.platform.gameclient.services.IBaseLcdsService;
   import com.riotgames.platform.gameclient.services.MasteryBookService;
   import com.riotgames.platform.gameclient.services.MatchMakerService;
   import com.riotgames.platform.gameclient.services.MicroFeedbackService;
   import com.riotgames.platform.gameclient.services.PlayerPreferencesService;
   import com.riotgames.platform.gameclient.services.PlayerStatsService;
   import com.riotgames.platform.gameclient.services.SpellBookService;
   import com.riotgames.platform.gameclient.services.SummonerIconService;
   import com.riotgames.platform.gameclient.services.SummonerRuneService;
   import com.riotgames.platform.gameclient.services.SummonerService;
   import com.riotgames.platform.gameclient.services.TeamService;
   import com.riotgames.platform.provider.IProviderModule;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.platform.provider.ProviderModuleInfo;
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
   import com.riotgames.pvpnet.system.messaging.ShellDispatcher;
   import flash.utils.getQualifiedClassName;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.modules.ModuleBase;
   
   public class ClientModuleServices extends ModuleBase implements IServicesProvider, IProviderModule
   {
      
      private var _remoteObjectGenerator:RemoteObjectGenerator;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var session:Session;
      
      private var serviceProxy:ServiceProxy;
      
      public function ClientModuleServices()
      {
         super();
      }
      
      public function initializeModule(param1:ProviderModuleInfo) : void
      {
         this.serviceProxy = ServiceProxy.instance;
         this.session = Session.instance;
         this._remoteObjectGenerator = new RemoteObjectGenerator();
         this._remoteObjectGenerator.config = RiotServiceConfig.instance;
         this._remoteObjectGenerator.session = Session.instance;
         this._remoteObjectGenerator.shellDispatcher = ShellDispatcher.instance;
         var _loc2_:MessageRouterServiceImpl = this.configureMessageRouterService(new MessageRouterServiceImpl());
         var _loc3_:GameServiceImpl = this.configure(new GameServiceImpl()) as GameServiceImpl;
         _loc3_.messageRouterService = _loc2_;
         this.serviceProxy.accountManagementService = this.configure(new AccountManagementServiceImpl()) as AccountManagementService;
         this.serviceProxy.accountService = this.configure(new AccountServiceImpl()) as AccountService;
         this.serviceProxy.chatService = new ChatServiceImpl();
         this.serviceProxy.clientFacadeService = this.configure(new ClientFacadeServiceImpl()) as ClientFacadeService;
         this.serviceProxy.gameMapService = this.configure(new GameMapServiceImpl()) as GameMapService;
         this.serviceProxy.gameService = _loc3_;
         this.serviceProxy.gameInviteService = this.configure(new GameInviteServiceImpl()) as GameInviteServiceImpl;
         this.serviceProxy.queueRestricitonService = this.configure(new QueueRestrictionServiceImpl()) as QueueRestrictionServiceImpl;
         this.serviceProxy.gameZoneGameService = _loc3_;
         this.serviceProxy.inventoryService = this.configure(new InventoryServiceImpl()) as InventoryService;
         this.serviceProxy.rerollService = this.configure(new RerollServiceImpl()) as RerollService;
         this.serviceProxy.loginService = this.configure(new LoginServiceImpl()) as LoginService;
         this.serviceProxy.maestroService = new MaestroServiceImpl();
         this.serviceProxy.matchMakerService = this.configure(new MatchMakerServiceImpl()) as MatchMakerService;
         this.serviceProxy.messageRouterService = _loc2_;
         this.serviceProxy.playerStatsService = this.configure(new PlayerStatsServiceImpl()) as PlayerStatsService;
         this.serviceProxy.serverStatusService = new ServerStatusServiceImpl();
         this.serviceProxy.smtpMailService = new SMTPMailServiceImpl();
         this.serviceProxy.spellBookService = this.configure(new SpellBookServiceImpl()) as SpellBookService;
         this.serviceProxy.statisticsService = this.configure(new StatisticsServiceImpl()) as StatisticsService;
         this.serviceProxy.summonerRuneService = this.configure(new SummonerRuneServiceImpl()) as SummonerRuneService;
         this.serviceProxy.summonerService = this.configure(new SummonerServiceImpl()) as SummonerService;
         this.serviceProxy.teamService = this.configure(new TeamServiceImpl()) as TeamService;
         this.serviceProxy.championTradeService = this.configure(new ChampionTradeService()) as ChampionTradeService;
         this.serviceProxy.localGameDataService = new LocalGameDataServiceImpl();
         this.serviceProxy.masteryBookService = this.configure(new MasteryBookServiceImpl()) as MasteryBookService;
         this.serviceProxy.remoteObjectGeneratorService = this.configureRemoteObjectGeneratorService() as RemoteObjectGeneratorService;
         this.serviceProxy.summonerIconService = this.configure(new SummonerIconServiceImpl()) as SummonerIconService;
         this.serviceProxy.microFeedbackService = this.configure(new MicroFeedbackServiceImpl()) as MicroFeedbackService;
         this.serviceProxy.lcdsService = this.configure(new BaseLcdsService()) as IBaseLcdsService;
         this.serviceProxy.playerPreferencesService = this.configure(new PlayerPreferencesServiceImpl()) as PlayerPreferencesService;
         this.serviceProxy.leagueService = this.configure(new CLSServicePlatformImpl()) as CLSServicePlatform;
         this.serviceProxy.replayFileManagerService = new ReplayFileManagerService();
         this.serviceProxy.replayDownloadService = new ReplayDownloadService();
         var _loc4_:RestAuthService = new RestAuthService("lol",this.serviceProxy.riotServiceConfiguration);
         this.configureAuthService(_loc4_);
         this.serviceProxy.authService = _loc4_;
         this.serviceProxy.restService = _loc4_;
         ProviderLookup.publishProvider(IServicesProvider,this);
         DynamicClientConfigManager.initialize(_loc2_);
      }
      
      private function configure(param1:BaseLcdsService) : BaseLcdsService
      {
         param1.config = this.serviceProxy.riotServiceConfiguration;
         param1.remoteObjectGenerator = this._remoteObjectGenerator;
         param1.session = this.session;
         return param1;
      }
      
      private function configureAuthService(param1:RestAuthService) : IAuthService
      {
         var _loc2_:PollingLoginQueueMonitor = new PollingLoginQueueMonitor(param1.getQueueId());
         _loc2_.config = this.serviceProxy.riotServiceConfiguration;
         param1.queueMonitor = _loc2_;
         return param1;
      }
      
      private function configureMessageRouterService(param1:MessageRouterServiceImpl) : MessageRouterServiceImpl
      {
         param1.config = this.serviceProxy.riotServiceConfiguration;
         param1.remoteObjectGenerator = this._remoteObjectGenerator;
         return param1;
      }
      
      private function configureRemoteObjectGeneratorService() : RemoteObjectGeneratorService
      {
         var _loc1_:RemoteObjectGeneratorServiceImpl = new RemoteObjectGeneratorServiceImpl();
         _loc1_.remoteObjectGenerator = this._remoteObjectGenerator;
         return _loc1_;
      }
   }
}

