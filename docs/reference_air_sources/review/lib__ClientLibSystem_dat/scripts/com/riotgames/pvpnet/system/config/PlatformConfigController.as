package com.riotgames.pvpnet.system.config
{
   import com.riotgames.platform.common.AppConfig;
   import com.riotgames.platform.common.GeneratedContentLoader;
   import com.riotgames.platform.common.event.BroadcastMessageEvent;
   import com.riotgames.platform.common.provider.InventoryProviderProxy;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.domain.game.GameMap;
   import com.riotgames.platform.gameclient.domain.game.GameMapEnabledDTO;
   import com.riotgames.platform.gameclient.domain.game.practice.PracticeGameSearchResult;
   import com.riotgames.platform.gameclient.domain.gameconfig.GameTypeConfigManager;
   import com.riotgames.platform.gameclient.domain.systemstates.ClientSystemStatesNotification;
   import com.riotgames.platform.gameclient.notification.ClientNotificationType;
   import com.riotgames.pvpnet.system.messaging.BroadcastMessageControllerProxy;
   import flash.utils.getQualifiedClassName;
   import mx.collections.ArrayCollection;
   import mx.collections.Sort;
   import mx.collections.SortField;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.rpc.events.ResultEvent;
   
   public class PlatformConfigController implements IPlatformConfigProvider
   {
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var _platformConfig:PlatformConfig = new PlatformConfig();
      
      public function PlatformConfigController()
      {
         super();
      }
      
      private static function localizeAndSortMaps(param1:ArrayCollection) : void
      {
         RiotResourceLoader.loadMapResourceStrings(param1);
         var _loc2_:Sort = new Sort();
         var _loc3_:SortField = new SortField("mapId");
         _loc2_.fields = [_loc3_];
         param1.sort = _loc2_;
         param1.refresh();
      }
      
      public function initializePlatformConfigMonitoring() : void
      {
         BroadcastMessageControllerProxy.instance.addMessageListener(ClientNotificationType.SYSTEM_STATES,this.onClientSystemStatesMessageReceived);
      }
      
      public function getPlatformConfig() : PlatformConfig
      {
         return this._platformConfig;
      }
      
      public function updatePlatformConfig(param1:ClientSystemStatesNotification) : void
      {
         this._platformConfig.setPlatformConfigChanged();
         this.initializeSystemStateFlags(param1);
         this._platformConfig.kudosEnabled = param1.kudosEnabled;
         this._platformConfig.displayPromotionalGamesEnabled = param1.displayPromoGamesPlayedEnabled;
         this._platformConfig.queueThrottleDTO = param1.queueThrottleDTO;
         Session.instance.maxNumberOfAllowedMasteryPages = param1.maxMasteryPagesOnServer;
         var _loc2_:ArrayCollection = param1.gameMapEnabledDTOList;
         if(_loc2_ != null)
         {
            this.setAvailableMaps(_loc2_);
         }
         else
         {
            ServiceProxy.instance.gameMapService.getGameMapList(this.onGameMapsRetrieved,null,null);
         }
         if(ClientConfig.instance.localeSpecificChatRoomsEnabled != param1.localeSpecificChatRoomsEnabled)
         {
            ClientConfig.instance.localeSpecificChatRoomsEnabled = param1.localeSpecificChatRoomsEnabled;
         }
         ClientConfig.instance.buddyNotesEnabled = param1.buddyNotesEnabled;
         PracticeGameSearchResult.spectatorSlotLimit = param1.spectatorSlotLimit;
         if(param1.practiceGameTypeConfigIdList != null)
         {
            GameTypeConfigManager.instance.setPracticeGameConfigs(param1.practiceGameTypeConfigIdList);
         }
         ClientConfig.instance.storeEnabled = param1.storeCustomerEnabled;
         this.updateInventoryForSystemStates(param1);
         this._platformConfig.enabledQueueIdsList = param1.enabledQueueIdsList;
         this._platformConfig.clientHeartBeatRateSeconds = param1.clientHeartBeatRateSeconds;
      }
      
      private function onClientSystemStatesMessageReceived(param1:BroadcastMessageEvent) : void
      {
         var _loc2_:ClientSystemStatesNotification = param1.notification as ClientSystemStatesNotification;
         this.updatePlatformConfig(_loc2_);
      }
      
      public function initializeSystemStateFlags(param1:ClientSystemStatesNotification) : void
      {
         ClientConfig.instance.championTradeThroughLCDS = param1.championTradeThroughLCDS;
         ClientConfig.instance.practiceGamesEnabled = param1.practiceGameEnabled;
         ClientConfig.instance.observerModeEnabled = param1.observerModeEnabled;
         ClientConfig.instance.advancedTutorialEnabled = param1.advancedTutorialEnabled;
         ClientConfig.instance.minNumPlayersForPracticeGame = param1.minNumPlayersForPracticeGame;
         ClientConfig.instance.runeUniquePerSpellBook = param1.runeUniquePerSpellBook;
         ClientConfig.instance.socialIntegrationEnabled = param1.socialIntegrationEnabled;
         ClientConfig.instance.tribunalEnabled = param1.tribunalEnabled;
         ClientConfig.instance.spectatorSlotLimit = param1.spectatorSlotLimit;
         ClientConfig.instance.archivedStatsEnabled = param1.archivedStatsEnabled;
         ClientConfig.instance.observableGameModes = param1.observableGameModes;
         ClientConfig.instance.observableCustomGameModes = param1.observableCustomGameModes;
         ClientConfig.instance.teamServiceEnabled = param1.teamServiceEnabled;
         ClientConfig.instance.leagueServiceEnabled = param1.leagueServiceEnabled;
         ClientConfig.instance.leaguesDecayMessagingEnabled = param1.leaguesDecayMessagingEnabled;
         ClientConfig.instance.itemSetServiceEnabled = param1.itemSetServiceEnabled;
         ClientConfig.instance.tournamentSendStatsEnabled = param1.tournamentSendStatsEnabled;
         ClientConfig.instance.riotDataServiceDataSendProbability = param1.riotDataServiceDataSendProbability;
         ClientConfig.instance.replayServiceURL = param1.replaySystemStates.replayServiceAddress;
         ClientConfig.instance.setReplaySystemStates(param1.replaySystemStates);
         ClientConfig.instance.sendFeedbackEventsEnabled = param1.sendFeedbackEventsEnabled;
         ClientConfig.instance.knownGeographicGameServerRegions = param1.knownGeographicGameServerRegions;
         ClientConfig.instance.currentSeason = param1.currentSeason;
      }
      
      private function updateInventoryForSystemStates(param1:ClientSystemStatesNotification) : void
      {
         InventoryProviderProxy.instance.getInventoryController().updateChampionsRoster(param1.inactiveChampionIdList,param1.freeToPlayChampionIdList,param1.freeToPlayChampionForNewPlayersIdList,param1.freeToPlayChampionForNewPlayersMaxLevel);
         InventoryProviderProxy.instance.getInventoryController().updateChampionSkins(param1.unobtainableChampionSkinIDList);
         InventoryProviderProxy.instance.getInventoryController().updateSpellDictionary(param1.gameModeToInactiveSpellIds);
      }
      
      private function onGameMapsRetrieved(param1:ResultEvent) : void
      {
         var _loc2_:ArrayCollection = param1.result as ArrayCollection;
         if(Boolean(_loc2_))
         {
            this.setAvailableMaps(_loc2_);
         }
      }
      
      private function setAvailableMaps(param1:ArrayCollection) : void
      {
         var _loc4_:ArrayCollection = null;
         var _loc5_:GameMapEnabledDTO = null;
         var _loc2_:ArrayCollection = null;
         var _loc3_:GameMap = null;
         if(param1.length == 0 || param1[0] is GameMap)
         {
            _loc2_ = param1;
         }
         else
         {
            _loc4_ = new ArrayCollection();
            for each(_loc3_ in GeneratedContentLoader.instance.mapData)
            {
               for each(_loc5_ in param1)
               {
                  if(_loc3_.mapId == _loc5_.gameMapId)
                  {
                     _loc4_.addItem(_loc3_);
                     _loc3_.minCustomPlayers = _loc5_.minPlayers;
                  }
               }
            }
            _loc2_ = _loc4_;
         }
         if(_loc2_ != null)
         {
            localizeAndSortMaps(_loc2_);
            AppConfig.instance.availableMaps = _loc2_;
         }
      }
   }
}

