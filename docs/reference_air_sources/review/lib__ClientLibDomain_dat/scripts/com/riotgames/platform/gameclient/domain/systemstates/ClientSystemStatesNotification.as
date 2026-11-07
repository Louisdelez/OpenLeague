package com.riotgames.platform.gameclient.domain.systemstates
{
   import com.riotgames.platform.gameclient.domain.game.GameMapEnabledDTO;
   import com.riotgames.platform.gameclient.domain.game.QueueThrottleDTO;
   import com.riotgames.platform.gameclient.notification.ClientNotificationType;
   import com.riotgames.platform.gameclient.notification.IClientNotification;
   import com.riotgames.util.json.jsonDecode;
   import flash.utils.Dictionary;
   import flash.utils.IDataInput;
   import flash.utils.IDataOutput;
   import flash.utils.IExternalizable;
   import flash.utils.getQualifiedClassName;
   import mx.collections.ArrayCollection;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   [RemoteClass(alias="com.riotgames.platform.systemstate.ClientSystemStatesNotification")]
   public class ClientSystemStatesNotification implements IClientNotification, IExternalizable
   {
      
      public static const ALL_GAME_MODES_DISABLED_SPELLS_KEY:String = "ALL_GAME_MODES_DISABLED_SPELLS_KEY";
      
      public var enabledQueueIdsList:ArrayCollection = null;
      
      public var itemSetServiceEnabled:Boolean = false;
      
      public var championTradeThroughLCDS:Boolean = true;
      
      public var playerPreferencesSyncing:Boolean = true;
      
      public var minNumPlayersForPracticeGame:int = 1;
      
      public var socialIntegrationEnabled:Boolean = false;
      
      public var buddyNotesEnabled:Boolean = false;
      
      public var observableCustomGameModes:String = null;
      
      public var gameModeToInactiveSpellIds:Dictionary = null;
      
      public var spectatorSlotLimit:int = 0;
      
      public var clientHeartBeatRateSeconds:int = 0;
      
      public var inactiveSpellIdList:ArrayCollection = null;
      
      public var freeToPlayChampionForNewPlayersMaxLevel:Number = 0;
      
      public var gameMapEnabledDTOList:ArrayCollection = null;
      
      public var replayServiceAddress:String = null;
      
      public var riotDataServiceDataSendProbability:Number = 0;
      
      public var unobtainableChampionSkinIDList:ArrayCollection = null;
      
      public var inactiveAramSpellIdList:ArrayCollection = null;
      
      public var maxMasteryPagesOnServer:int = 10;
      
      public var observableGameModes:ArrayCollection = null;
      
      public var storeCustomerEnabled:Boolean = true;
      
      public var tournamentSendStatsEnabled:Boolean = false;
      
      public var inactiveChampionIdList:ArrayCollection = null;
      
      public var observerModeEnabled:Boolean = false;
      
      public var knownGeographicGameServerRegions:ArrayCollection = null;
      
      public var modularGameModeEnabled:Boolean = false;
      
      public var localeSpecificChatRoomsEnabled:Boolean = false;
      
      public var inactiveClassicSpellIdList:ArrayCollection = null;
      
      public var advancedTutorialEnabled:Boolean = true;
      
      public var practiceGameTypeConfigIdList:ArrayCollection = null;
      
      public var queueThrottleDTO:QueueThrottleDTO = null;
      
      public var teamServiceEnabled:Boolean = false;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      public var replaySystemStates:ReplaySystemStates = null;
      
      public var inactiveOdinSpellIdList:ArrayCollection = null;
      
      public var archivedStatsEnabled:Boolean = false;
      
      public var tribunalEnabled:Boolean = true;
      
      public var masteryPageOnServer:Boolean = false;
      
      public var leaguesDecayMessagingEnabled:Boolean = false;
      
      public var practiceGameEnabled:Boolean = true;
      
      public var sendFeedbackEventsEnabled:Boolean = false;
      
      public var currentSeason:int = -1;
      
      public var kudosEnabled:Boolean = false;
      
      public var freeToPlayChampionForNewPlayersIdList:ArrayCollection = null;
      
      public var leagueServiceEnabled:Boolean = false;
      
      public var freeToPlayChampionIdList:ArrayCollection = null;
      
      public var runeUniquePerSpellBook:Boolean = false;
      
      public var inactiveTutorialSpellIdList:ArrayCollection = null;
      
      public var displayPromoGamesPlayedEnabled:Boolean = false;
      
      public function ClientSystemStatesNotification()
      {
         super();
      }
      
      private function copyProps(param1:Object, param2:Object) : *
      {
         var _loc3_:String = null;
         for(_loc3_ in param1)
         {
            if(param2.hasOwnProperty(_loc3_))
            {
               param2[_loc3_] = param1[_loc3_];
            }
         }
         return param2;
      }
      
      public function readExternal(param1:IDataInput) : void
      {
         var _loc4_:Object = null;
         var _loc2_:int = param1.readInt();
         var _loc3_:String = param1.readUTFBytes(_loc2_);
         if(_loc3_ != null)
         {
            _loc4_ = jsonDecode(_loc3_);
            this.assignProps(_loc4_);
         }
         else
         {
            this.logger.error("json was null!");
         }
      }
      
      public function assignProps(param1:Object) : void
      {
         var _loc2_:Object = null;
         var _loc3_:String = null;
         this.championTradeThroughLCDS = param1.championTradeThroughLCDS;
         this.practiceGameEnabled = param1.practiceGameEnabled;
         this.advancedTutorialEnabled = param1.advancedTutorialEnabled;
         this.archivedStatsEnabled = param1.archivedStatsEnabled;
         this.minNumPlayersForPracticeGame = param1.minNumPlayersForPracticeGame;
         this.storeCustomerEnabled = param1.storeCustomerEnabled;
         this.socialIntegrationEnabled = param1.socialIntegrationEnabled;
         this.runeUniquePerSpellBook = param1.runeUniquePerSpellBook;
         this.tribunalEnabled = param1.tribunalEnabled;
         this.kudosEnabled = param1.kudosEnabled;
         this.observerModeEnabled = param1.observerModeEnabled;
         this.spectatorSlotLimit = param1.spectatorSlotLimit;
         this.clientHeartBeatRateSeconds = param1.clientHeartBeatRateSeconds;
         this.observableCustomGameModes = param1.observableCustomGameModes;
         this.teamServiceEnabled = param1.teamServiceEnabled;
         this.leagueServiceEnabled = param1.leagueServiceEnabled;
         this.leaguesDecayMessagingEnabled = param1.leaguesDecayMessagingEnabled;
         this.modularGameModeEnabled = param1.modularGameModeEnabled;
         this.riotDataServiceDataSendProbability = param1.riotDataServiceDataSendProbability;
         this.masteryPageOnServer = param1.masteryPageOnServer;
         this.maxMasteryPagesOnServer = param1.maxMasteryPagesOnServer;
         this.displayPromoGamesPlayedEnabled = param1.displayPromoGamesPlayedEnabled;
         this.tournamentSendStatsEnabled = param1.tournamentSendStatsEnabled;
         this.localeSpecificChatRoomsEnabled = param1.localeSpecificChatRoomsEnabled;
         this.replayServiceAddress = param1.replayServiceAddress;
         this.buddyNotesEnabled = param1.buddyNotesEnabled;
         this.playerPreferencesSyncing = param1.playerPreferencesSyncing;
         this.sendFeedbackEventsEnabled = param1.sendFeedbackEventsEnabled;
         this.currentSeason = param1.currentSeason;
         this.queueThrottleDTO = this.copyProps(param1.queueThrottleDTO,new QueueThrottleDTO());
         this.replaySystemStates = this.copyProps(param1.replaySystemStates,new ReplaySystemStates());
         this.knownGeographicGameServerRegions = new ArrayCollection(param1.knownGeographicGameServerRegions);
         this.practiceGameTypeConfigIdList = new ArrayCollection(param1.practiceGameTypeConfigIdList);
         this.freeToPlayChampionIdList = new ArrayCollection(param1.freeToPlayChampionIdList);
         this.freeToPlayChampionForNewPlayersIdList = new ArrayCollection(param1.freeToPlayChampionForNewPlayersIdList);
         this.freeToPlayChampionForNewPlayersMaxLevel = Number(param1.freeToPlayChampionsForNewPlayersMaxLevel);
         this.enabledQueueIdsList = new ArrayCollection(param1.enabledQueueIdsList);
         this.unobtainableChampionSkinIDList = new ArrayCollection(param1.unobtainableChampionSkinIDList);
         this.inactiveChampionIdList = new ArrayCollection(param1.inactiveChampionIdList);
         this.inactiveSpellIdList = new ArrayCollection(param1.inactiveSpellIdList);
         this.inactiveTutorialSpellIdList = new ArrayCollection(param1.inactiveTutorialSpellIdList);
         this.inactiveClassicSpellIdList = new ArrayCollection(param1.inactiveClassicSpellIdList);
         this.inactiveOdinSpellIdList = new ArrayCollection(param1.inactiveOdinSpellIdList);
         this.inactiveAramSpellIdList = new ArrayCollection(param1.inactiveAramSpellIdList);
         this.observableGameModes = new ArrayCollection(param1.observableGameModes);
         this.gameMapEnabledDTOList = new ArrayCollection();
         for each(_loc2_ in param1.gameMapEnabledDTOList)
         {
            this.gameMapEnabledDTOList.addItem(this.copyProps(_loc2_,new GameMapEnabledDTO()));
         }
         this.gameModeToInactiveSpellIds = new Dictionary();
         for(_loc3_ in param1.gameModeToInactiveSpellIds)
         {
            this.gameModeToInactiveSpellIds[_loc3_] = new ArrayCollection(param1.gameModeToInactiveSpellIds[_loc3_]);
         }
      }
      
      public function writeExternal(param1:IDataOutput) : void
      {
         throw new Error("NotImplementedException");
      }
      
      public function get notificationType() : String
      {
         return ClientNotificationType.SYSTEM_STATES;
      }
   }
}

