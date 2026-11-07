package com.riotgames.platform.common.services
{
   import com.riotgames.platform.common.RiotServiceConfig;
   import com.riotgames.platform.gameclient.services.AccountManagementService;
   import com.riotgames.platform.gameclient.services.AccountService;
   import com.riotgames.platform.gameclient.services.CLSServicePlatform;
   import com.riotgames.platform.gameclient.services.ClientFacadeService;
   import com.riotgames.platform.gameclient.services.GameMapService;
   import com.riotgames.platform.gameclient.services.GameService;
   import com.riotgames.platform.gameclient.services.GameZoneGameService;
   import com.riotgames.platform.gameclient.services.IBaseLcdsService;
   import com.riotgames.platform.gameclient.services.LocalGameDataService;
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
   import com.riotgames.platform.gameclient.services.maestro.MaestroService;
   import com.riotgames.platform.gameclient.services.mail.SMTPMailService;
   import com.riotgames.platform.gameclient.services.trade.IChampionTradeService;
   import com.riotgames.platform.gameclient.services.watch.IReplayDownloadService;
   import com.riotgames.platform.gameclient.services.watch.IReplayFileManagerService;
   
   public class ServiceProxy
   {
      
      private static var _instance:ServiceProxy;
      
      private var _gameZoneGameService:GameZoneGameService;
      
      private var _summonerIconService:SummonerIconService;
      
      private var _inventoryService:InventoryService;
      
      private var _gameInviteService:GameInviteService;
      
      private var _serverStatusService:ServerStatusService;
      
      private var _replayDownloadService:IReplayDownloadService;
      
      private var _summonerRuneService:SummonerRuneService;
      
      private var _authService:IAuthService;
      
      private var _playerStatsService:PlayerStatsService;
      
      private var _messageRouterService:MessageRouterService;
      
      private var _localGameDataService:LocalGameDataService;
      
      private var _masteryBookService:MasteryBookService;
      
      private var _summonerService:SummonerService;
      
      private var _rerollService:RerollService;
      
      private var _gameMapService:GameMapService;
      
      private var _chatService:ChatService;
      
      private var _restService:RESTService;
      
      private var _remoteObjectGeneratorService:RemoteObjectGeneratorService;
      
      private var _leagueService:CLSServicePlatform;
      
      private var _smtpMailService:SMTPMailService;
      
      private var _replayFileManagerService:IReplayFileManagerService;
      
      private var _statisticsService:StatisticsService;
      
      private var _championTradeService:IChampionTradeService;
      
      private var _spellBookService:SpellBookService;
      
      private var _accountManagementService:AccountManagementService;
      
      private var _maestroService:MaestroService;
      
      private var _gameService:GameService;
      
      private var _matchMakerService:MatchMakerService;
      
      private var _playerPreferencesService:PlayerPreferencesService;
      
      private var _lcdsService:IBaseLcdsService;
      
      private var _teamService:TeamService;
      
      private var _riotServiceConfig:RiotServiceConfig = RiotServiceConfig.instance;
      
      private var _accountService:AccountService;
      
      private var _loginService:LoginService;
      
      private var _clientFacadeService:ClientFacadeService;
      
      private var _microFeedbackService:MicroFeedbackService;
      
      private var _queueRestrictionService:QueueRestrictionService;
      
      public function ServiceProxy()
      {
         super();
      }
      
      public static function get instance() : ServiceProxy
      {
         if(_instance == null)
         {
            _instance = new ServiceProxy();
         }
         return _instance;
      }
      
      public function set summonerService(param1:SummonerService) : void
      {
         this._summonerService = param1;
      }
      
      public function get statisticsService() : StatisticsService
      {
         return this._statisticsService;
      }
      
      public function set loginService(param1:LoginService) : void
      {
         this._loginService = param1;
      }
      
      public function set statisticsService(param1:StatisticsService) : void
      {
         this._statisticsService = param1;
      }
      
      public function set lcdsService(param1:IBaseLcdsService) : void
      {
         this._lcdsService = param1;
      }
      
      public function get replayFileManagerService() : IReplayFileManagerService
      {
         return this._replayFileManagerService;
      }
      
      public function get replayDownloadService() : IReplayDownloadService
      {
         return this._replayDownloadService;
      }
      
      public function set gameInviteService(param1:GameInviteService) : *
      {
         this._gameInviteService = param1;
      }
      
      public function set teamService(param1:TeamService) : void
      {
         this._teamService = param1;
      }
      
      public function get loginService() : LoginService
      {
         return this._loginService;
      }
      
      public function get queueRestrictionService() : QueueRestrictionService
      {
         return this._queueRestrictionService;
      }
      
      public function get chatService() : ChatService
      {
         return this._chatService;
      }
      
      public function get restService() : RESTService
      {
         return this._restService;
      }
      
      public function get accountManagementService() : AccountManagementService
      {
         return this._accountManagementService;
      }
      
      public function get gameMapService() : GameMapService
      {
         return this._gameMapService;
      }
      
      public function set replayDownloadService(param1:IReplayDownloadService) : void
      {
         this._replayDownloadService = param1;
      }
      
      public function set playerStatsService(param1:PlayerStatsService) : void
      {
         this._playerStatsService = param1;
      }
      
      public function set microFeedbackService(param1:MicroFeedbackService) : void
      {
         this._microFeedbackService = param1;
      }
      
      public function set maestroService(param1:MaestroService) : void
      {
         this._maestroService = param1;
      }
      
      public function get spellBookService() : SpellBookService
      {
         return this._spellBookService;
      }
      
      public function set replayFileManagerService(param1:IReplayFileManagerService) : void
      {
         this._replayFileManagerService = param1;
      }
      
      public function get matchMakerService() : MatchMakerService
      {
         return this._matchMakerService;
      }
      
      public function set remoteObjectGeneratorService(param1:RemoteObjectGeneratorService) : void
      {
         this._remoteObjectGeneratorService = param1;
      }
      
      public function get playerPreferencesService() : PlayerPreferencesService
      {
         return this._playerPreferencesService;
      }
      
      public function set clientFacadeService(param1:ClientFacadeService) : void
      {
         this._clientFacadeService = param1;
      }
      
      public function get rerollService() : RerollService
      {
         return this._rerollService;
      }
      
      public function get microFeedbackService() : MicroFeedbackService
      {
         return this._microFeedbackService;
      }
      
      public function set masteryBookService(param1:MasteryBookService) : void
      {
         this._masteryBookService = param1;
      }
      
      public function set inventoryService(param1:InventoryService) : void
      {
         this._inventoryService = param1;
      }
      
      public function set matchMakerService(param1:MatchMakerService) : void
      {
         this._matchMakerService = param1;
      }
      
      public function set championTradeService(param1:IChampionTradeService) : void
      {
         this._championTradeService = param1;
      }
      
      public function get localGameDataService() : LocalGameDataService
      {
         return this._localGameDataService;
      }
      
      public function set riotServiceConfiguration(param1:RiotServiceConfig) : void
      {
         this._riotServiceConfig = param1;
      }
      
      public function get gameService() : GameService
      {
         return this._gameService;
      }
      
      public function get messageRouterService() : MessageRouterService
      {
         return this._messageRouterService;
      }
      
      public function set leagueService(param1:CLSServicePlatform) : void
      {
         this._leagueService = param1;
      }
      
      public function set chatService(param1:ChatService) : void
      {
         this._chatService = param1;
      }
      
      public function get maestroService() : MaestroService
      {
         return this._maestroService;
      }
      
      public function get summonerService() : SummonerService
      {
         return this._summonerService;
      }
      
      public function set queueRestricitonService(param1:QueueRestrictionService) : void
      {
         this._queueRestrictionService = param1;
      }
      
      public function set restService(param1:RESTService) : void
      {
         this._restService = param1;
      }
      
      public function get leagueService() : CLSServicePlatform
      {
         return this._leagueService;
      }
      
      public function set gameMapService(param1:GameMapService) : void
      {
         this._gameMapService = param1;
      }
      
      public function set accountService(param1:AccountService) : void
      {
         this._accountService = param1;
      }
      
      public function get teamService() : TeamService
      {
         return this._teamService;
      }
      
      public function set summonerIconService(param1:SummonerIconService) : void
      {
         this._summonerIconService = param1;
      }
      
      public function get playerStatsService() : PlayerStatsService
      {
         return this._playerStatsService;
      }
      
      public function set smtpMailService(param1:SMTPMailService) : void
      {
         this._smtpMailService = param1;
      }
      
      public function get gameInviteService() : GameInviteService
      {
         return this._gameInviteService;
      }
      
      public function set accountManagementService(param1:AccountManagementService) : void
      {
         this._accountManagementService = param1;
      }
      
      public function get remoteObjectGeneratorService() : RemoteObjectGeneratorService
      {
         return this._remoteObjectGeneratorService;
      }
      
      public function set spellBookService(param1:SpellBookService) : void
      {
         this._spellBookService = param1;
      }
      
      public function set gameZoneGameService(param1:GameZoneGameService) : void
      {
         this._gameZoneGameService = param1;
      }
      
      public function get clientFacadeService() : ClientFacadeService
      {
         return this._clientFacadeService;
      }
      
      public function get lcdsService() : IBaseLcdsService
      {
         return this._lcdsService;
      }
      
      public function get masteryBookService() : MasteryBookService
      {
         return this._masteryBookService;
      }
      
      public function get inventoryService() : InventoryService
      {
         return this._inventoryService;
      }
      
      public function get championTradeService() : IChampionTradeService
      {
         return this._championTradeService;
      }
      
      public function set playerPreferencesService(param1:PlayerPreferencesService) : void
      {
         this._playerPreferencesService = param1;
      }
      
      public function set serverStatusService(param1:ServerStatusService) : void
      {
         this._serverStatusService = param1;
      }
      
      public function get riotServiceConfiguration() : RiotServiceConfig
      {
         return this._riotServiceConfig;
      }
      
      public function get gameZoneGameService() : GameZoneGameService
      {
         return this._gameZoneGameService;
      }
      
      public function set gameService(param1:GameService) : void
      {
         this._gameService = param1;
      }
      
      public function get accountService() : AccountService
      {
         return this._accountService;
      }
      
      public function set rerollService(param1:RerollService) : void
      {
         this._rerollService = param1;
      }
      
      public function get smtpMailService() : SMTPMailService
      {
         return this._smtpMailService;
      }
      
      public function set messageRouterService(param1:MessageRouterService) : void
      {
         this._messageRouterService = param1;
      }
      
      public function get summonerIconService() : SummonerIconService
      {
         return this._summonerIconService;
      }
      
      public function set authService(param1:IAuthService) : void
      {
         this._authService = param1;
      }
      
      public function set localGameDataService(param1:LocalGameDataService) : void
      {
         this._localGameDataService = param1;
      }
      
      public function get serverStatusService() : ServerStatusService
      {
         return this._serverStatusService;
      }
      
      public function set summonerRuneService(param1:SummonerRuneService) : void
      {
         this._summonerRuneService = param1;
      }
      
      public function get authService() : IAuthService
      {
         return this._authService;
      }
      
      public function get summonerRuneService() : SummonerRuneService
      {
         return this._summonerRuneService;
      }
   }
}

