package com.riotgames.platform.gameclient.controllers.game.model
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.gameclient.Models.MaxViewableTeamSize;
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.gameclient.chat.controllers.ChatRoom;
   import com.riotgames.platform.gameclient.domain.GameDTO;
   import com.riotgames.platform.gameclient.domain.GameParticipant;
   import com.riotgames.platform.gameclient.domain.SpellBookDTO;
   import com.riotgames.platform.gameclient.domain.TeamSkinRentalDTO;
   import com.riotgames.platform.gameclient.domain.game.FeaturedGameInfo;
   import com.riotgames.platform.gameclient.domain.game.GameMap;
   import com.riotgames.platform.gameclient.domain.game.GameMode;
   import com.riotgames.platform.gameclient.domain.game.ParticipantChampionSelection;
   import com.riotgames.platform.gameclient.domain.gameconfig.GameTypeConfig;
   import com.riotgames.platform.gameclient.domain.gameconfig.GameTypeConfigManager;
   import com.riotgames.platform.masteries.objects.MasteryPageInfoSummary;
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.events.CollectionEvent;
   
   public class ChampionSelectionModel extends EventDispatcher
   {
      
      public static const SPELLS_MENU_STATE_CHANGED:String = "spellsMenuStateChanged";
      
      public static const MAIN_MENU_STATE_CHANGE:String = "mainMenuStateChanged";
      
      public static const LOCK_IN_STATE_CHANGED:String = "lockInStateChanged";
      
      public static const MASTERIES_MENU_CHANGED:String = "masteriesMenuStateChanged";
      
      public static const PROGRESS_BAR_VISIBLE_CHANGED:String = "progressBarVisibleChanged";
      
      public static const ENEMY_TEAM_VISIBLE_CHANGED:String = "enemyTeamVisibleChanged";
      
      public static const FRIENDLY_TEAMMATES_VISIBLE_CHANGED:String = "friendlyTeammatesVisibleChanged";
      
      public static const ALLOW_CHAMPION_SEARCHING_CHANGED:String = "allowChampionSearchingChanged";
      
      public static const IS_SPECTATING_CHANGED:String = "isSpectatingChanged";
      
      public static const CURRENT_TEAM_CHANGED:String = "currentTeamChanged";
      
      public static const ENEMY_TEAM_CHANGED:String = "enemyTeamChanged";
      
      public static const BANNING_TEAM_CHANGED:String = "banningTeamChanged";
      
      public static const CURRENT_PLAYER_PARTICIPANT_CHANGED:String = "currentPlayerParticipantChanged";
      
      public static const ALL_SPELLS_CHANGED:String = "allSpellsChanged";
      
      public static const SPELLS_BUSY_CHANGED:String = "spellsBusyChanged";
      
      public static const IS_BUSY_CHANGED:String = "isBusyChanged";
      
      public static const HAS_SUMMONED_CHAMPION_CHANGED:String = "hasSummonedChampionChanged";
      
      public static const CHAMPION_SELECTIONS_CHANGED:String = "championSelectionsChanged";
      
      public static const SELECTED_CHAMPION_CHANGED:String = "selectedChampionChanged";
      
      public static const CHAMPION_SELECTION_STATE_CHANGED:String = "championSelectionStateChanged";
      
      public static const CURRENT_PICK_MODE_CHANGED:String = "currentPickModeChanged";
      
      public static const GAME_TYPE_CONFIG_CHANGED:String = "gameTypeConfigChanged";
      
      public static const TIME_REMAINING_SECONDS_CHANGED:String = "timeRemainingSecondsChanged";
      
      public static const CURRENT_GAME_CHANGED:String = "currentGameChanged";
      
      public static const CHAMPION_SELECTION_IS_BUSY_CHANGED:String = "championSelectionIsBusyChanged";
      
      public static const PICK_TURN_CHANGED:String = "pickTurnChanged";
      
      public static const ENEMY_TEAM_ACTIVE_CHANGED:String = "enemyTeamActiveChanged";
      
      public static const CURRENT_TEAM_ACTIVE_CHANGED:String = "currentTeamActiveChanged";
      
      public static const STATE_DESCRIPTION_TEXT_CHANGED:String = "stateDescriptionTextChanged";
      
      public static const GAME_MAP_CHANGED:String = "gameMapChanged";
      
      public static const CURRENT_PLAYER_SELECTION_CHANGED:String = "currentPlayerSelectionChanged";
      
      public static const RUNE_PAGE_SYNCED_CHANGED:String = "runePageSyncedChanged";
      
      public static const SPECTATOR_DELAY_SECONDS_REMAINING_CHANGED:String = "spectatorDelaySecondsRemainingChanged";
      
      public static const SPECTATOR_DELAY_PROGRESS_CHANGED:String = "spectatorDelayProgressChanged";
      
      public static const TEAM_ONE_BANS_CHANGED:String = "teamOneBansChanged";
      
      public static const TEAM_TWO_BANS_CHANGED:String = "teamTwoBansChanged";
      
      private static const CHAMP_SELECT_NAMESPACE:String = "ChampionSelect";
      
      private static const ALL_CHAMPS_AVAILABLE_IN_ARAM:String = "allChampsAvailableInAram";
      
      private var _championSelectionIsBusy:Boolean = false;
      
      private var _currentPlayerSelection:PlayerSelection = null;
      
      private var _isGameQueuedToStart:Boolean = false;
      
      private var _allowReroll:Boolean = false;
      
      private var _gameTypeConfigManager:GameTypeConfigManager;
      
      private var _spellsMenuState:String = "inactive";
      
      private var _enemyTeamName:String;
      
      private var _spectatorDelaySecondsRemaining:int = -1;
      
      private var _championSelectionState:String;
      
      private var _championSelections:ParticipantChampionListView;
      
      private var _isAFK:Boolean = true;
      
      private var _masteriesActive:Boolean = false;
      
      private var _featuredGameInfo:FeaturedGameInfo;
      
      private var _currentPlayerParticipant:GameParticipant = null;
      
      private var _banningTeam:String;
      
      private var _spellsBusy:Boolean;
      
      private var _enemyTeam:ArrayCollection;
      
      private var _championsActive:Boolean = false;
      
      private var _selectedChampion:ParticipantChampionSelection;
      
      private var _teamSkinRentalChanged:Signal = new Signal();
      
      private var _runeBook:SpellBookDTO;
      
      private var _championTradeUpdated:Signal = new Signal();
      
      private var _mainMenuState:String = "champsInactive";
      
      private var _lockInActive:Boolean = false;
      
      private var _gameMap:GameMap;
      
      private var _gameTypeConfig:GameTypeConfig = null;
      
      private var _currentTeamName:String;
      
      private var _runePageSynced:Boolean = false;
      
      private var _teamOneBans:ArrayCollection = new ArrayCollection();
      
      private var _allowChampionSerching:Boolean = true;
      
      private var _lockInState:String = "inactive";
      
      private var _enemyTeamVisible:Boolean = true;
      
      private var _isSpectating:Boolean = false;
      
      private var _spellsActive:Boolean = false;
      
      private var _runesActive:Boolean = false;
      
      private var _enemyTeamActive:Boolean = false;
      
      private var _selectedMasteryPage:MasteryPageInfoSummary;
      
      private var _spectatorDelayProgress:Number;
      
      private var _chatController:ChatController;
      
      private var _showChampionGrid:Boolean = true;
      
      private var _currentGame:GameDTO;
      
      private var _stateDescriptionText:String;
      
      private var _masteriesMenuState:String = "inactive";
      
      private var _teamSkinRental:TeamSkinRentalDTO;
      
      private var _championTradeIsActive:Boolean = false;
      
      private var _friendlyTeamActive:Boolean = false;
      
      private var _timeRemainingSeconds:int = 90;
      
      private var _locale:String;
      
      private var _currentTeamSelections:ArrayCollection;
      
      private var _progressBarVisible:Boolean = false;
      
      private var _masteryPages:ArrayCollection;
      
      private var _enemyTeamSelections:ArrayCollection;
      
      private var _featuredGameInfoUpdated:Signal = new Signal();
      
      private var _friendlyTeammatesVisible:Boolean = true;
      
      private var _currentTeamActive:Boolean = false;
      
      private var _pickTurn:int = 0;
      
      private var _chatRoom:ChatRoom;
      
      private var _currentTeam:ArrayCollection;
      
      private var _currentPickMode:int = 0;
      
      private var _hasSummonedChampion:Boolean;
      
      private var _allSpells:ArrayCollection;
      
      private var _masteriesSynced:Boolean = false;
      
      private var _teamTwoBans:ArrayCollection = new ArrayCollection();
      
      private var _allowFreeChampions:Boolean = true;
      
      public function ChampionSelectionModel()
      {
         super();
         this._teamOneBans.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onTeamOneBansChanged);
         this._teamTwoBans.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onTeamTwoBansChanged);
      }
      
      [Bindable(event="enemyTeamChanged")]
      public function get enemyTeam() : ArrayCollection
      {
         return this._enemyTeam;
      }
      
      public function set enemyTeam(param1:ArrayCollection) : void
      {
         if(this._enemyTeam == param1)
         {
            return;
         }
         this._enemyTeam = param1;
         dispatchEvent(new Event("enemyTeamChanged"));
      }
      
      [Bindable(event="masteriesSyncedChanged")]
      public function get masteriesSynced() : Boolean
      {
         return this._masteriesSynced;
      }
      
      public function set gameMap(param1:GameMap) : void
      {
         if(this._gameMap == param1)
         {
            return;
         }
         this._gameMap = param1;
         dispatchEvent(new Event("gameMapChanged"));
      }
      
      public function get featuredGameInfo() : FeaturedGameInfo
      {
         return this._featuredGameInfo;
      }
      
      public function set currentGame(param1:GameDTO) : void
      {
         if(this._currentGame == param1)
         {
            return;
         }
         this._currentGame = param1;
         dispatchEvent(new Event("currentGameChanged"));
      }
      
      [Bindable(event="currentTeamActiveChanged")]
      public function get currentTeamActive() : Boolean
      {
         return this._currentTeamActive;
      }
      
      public function set masteriesSynced(param1:Boolean) : void
      {
         if(this._masteriesSynced == param1)
         {
            return;
         }
         this._masteriesSynced = param1;
         dispatchEvent(new Event("masteriesSyncedChanged"));
      }
      
      [Bindable(event="spectatorDelayProgressChanged")]
      public function get spectatorDelayProgress() : Number
      {
         return this._spectatorDelayProgress;
      }
      
      public function set featuredGameInfo(param1:FeaturedGameInfo) : void
      {
         if(this._featuredGameInfo == param1)
         {
            return;
         }
         this._featuredGameInfo = param1;
         this._featuredGameInfoUpdated.dispatch(this._featuredGameInfoUpdated,this._featuredGameInfo);
      }
      
      [Bindable(event="selectedChampionChanged")]
      public function get selectedChampion() : ParticipantChampionSelection
      {
         return this._selectedChampion;
      }
      
      public function get isOccludingActivePickTurns() : Boolean
      {
         return this.gameTypeConfig != null && this.gameTypeConfig.id == GameTypeConfig.PICK_ID_ALL_TEAM_VOTE_PICK;
      }
      
      [Bindable(event="spectatorDelaySecondsRemainingChanged")]
      public function get spectatorDelaySecondsRemaining() : int
      {
         return this._spectatorDelaySecondsRemaining;
      }
      
      [Bindable(event="friendlyTeammatesVisibleChanged")]
      public function get friendlyTeammatesVisible() : Boolean
      {
         return this._friendlyTeammatesVisible;
      }
      
      public function set chatController(param1:ChatController) : void
      {
         this._chatController = param1;
      }
      
      [Bindable(event="enemyTeamNameChanged")]
      public function get enemyTeamName() : String
      {
         return this._enemyTeamName;
      }
      
      public function get allChampionsPlayable() : Boolean
      {
         if(this._currentGame == null || this._currentGame.gameMode != GameMode.ARAM)
         {
            return false;
         }
         if(this._gameTypeConfig == null || this._gameTypeConfig.id != GameTypeConfig.PICK_ID_RANDOM)
         {
            return false;
         }
         return DynamicClientConfigManager.getConfiguration(CHAMP_SELECT_NAMESPACE,ALL_CHAMPS_AVAILABLE_IN_ARAM,false).getBoolean();
      }
      
      public function set currentTeamActive(param1:Boolean) : void
      {
         if(this._currentTeamActive == param1)
         {
            return;
         }
         this._currentTeamActive = param1;
         dispatchEvent(new Event("currentTeamActiveChanged"));
      }
      
      public function set currentPlayerParticipant(param1:GameParticipant) : void
      {
         if(this._currentPlayerParticipant == param1)
         {
            return;
         }
         this._currentPlayerParticipant = param1;
         dispatchEvent(new Event("currentPlayerParticipantChanged"));
      }
      
      public function set gameTypeConfigManager(param1:GameTypeConfigManager) : void
      {
         if(this._gameTypeConfigManager == param1)
         {
            return;
         }
         this._gameTypeConfigManager = param1;
      }
      
      public function set isSpectating(param1:Boolean) : void
      {
         if(this._isSpectating == param1)
         {
            return;
         }
         this._isSpectating = param1;
         dispatchEvent(new Event("isSpectatingChanged"));
      }
      
      public function set currentTeamName(param1:String) : void
      {
         if(this._currentTeamName == param1)
         {
            return;
         }
         this._currentTeamName = param1;
         dispatchEvent(new Event("currentTeamNameChanged"));
      }
      
      [Bindable(event="gameMapChanged")]
      public function get gameMap() : GameMap
      {
         return this._gameMap;
      }
      
      [Bindable(event="pickTurnChanged")]
      public function get pickTurn() : int
      {
         return this._pickTurn;
      }
      
      [Bindable(event="banningTeamChanged")]
      public function get banningTeam() : String
      {
         return this._banningTeam;
      }
      
      public function set selectedChampion(param1:ParticipantChampionSelection) : void
      {
         if(this._selectedChampion == param1)
         {
            return;
         }
         this._selectedChampion = param1;
         dispatchEvent(new Event("selectedChampionChanged"));
      }
      
      public function set spectatorDelayProgress(param1:Number) : void
      {
         if(this._spectatorDelayProgress == param1)
         {
            return;
         }
         this._spectatorDelayProgress = param1;
         dispatchEvent(new Event(SPECTATOR_DELAY_PROGRESS_CHANGED));
      }
      
      [Bindable(event="enemyTeamSelectionsChanged")]
      public function get enemyTeamSelections() : ArrayCollection
      {
         return this._enemyTeamSelections;
      }
      
      [Bindable(event="chatRoomChanged")]
      public function get chatRoom() : ChatRoom
      {
         return this._chatRoom;
      }
      
      public function set spectatorDelaySecondsRemaining(param1:int) : void
      {
         if(this._spectatorDelaySecondsRemaining == param1)
         {
            return;
         }
         this._spectatorDelaySecondsRemaining = param1;
         dispatchEvent(new Event(SPECTATOR_DELAY_SECONDS_REMAINING_CHANGED));
      }
      
      [Bindable(event="localeChanged")]
      public function get locale() : String
      {
         return this._locale;
      }
      
      public function set championSelectionState(param1:String) : void
      {
         if(param1 == this._championSelectionState)
         {
            return;
         }
         this._championSelectionState = param1;
         dispatchEvent(new Event("championSelectionStateChanged"));
      }
      
      public function set friendlyTeammatesVisible(param1:Boolean) : void
      {
         if(this._friendlyTeammatesVisible == param1)
         {
            return;
         }
         this._friendlyTeammatesVisible = param1;
         dispatchEvent(new Event("friendlyTeammatesVisibleChanged"));
      }
      
      public function set enemyTeamName(param1:String) : void
      {
         if(this._enemyTeamName == param1)
         {
            return;
         }
         this._enemyTeamName = param1;
         dispatchEvent(new Event("enemyTeamNameChanged"));
      }
      
      [Bindable(event="spellsMenuStateChanged")]
      public function get spellsMenuState() : String
      {
         return this._spellsMenuState;
      }
      
      public function set spellsActive(param1:Boolean) : void
      {
         this._spellsActive = param1;
      }
      
      public function get championTradeIsActive() : Boolean
      {
         return this._championTradeIsActive;
      }
      
      public function set pickTurn(param1:int) : void
      {
         if(this._pickTurn == param1)
         {
            return;
         }
         this._pickTurn = param1;
         dispatchEvent(new Event("pickTurnChanged"));
      }
      
      [Bindable(event="currentTeamSelectionsChanged")]
      public function get currentTeamSelections() : ArrayCollection
      {
         return this._currentTeamSelections;
      }
      
      [Bindable(event="stateDescriptionTextChanged")]
      public function get stateDescriptionText() : String
      {
         return this._stateDescriptionText;
      }
      
      public function set banningTeam(param1:String) : void
      {
         if(this._banningTeam == param1)
         {
            return;
         }
         this._banningTeam = param1;
         dispatchEvent(new Event("banningTeamChanged"));
      }
      
      [Bindable(event="hasSummonedChampionChanged")]
      public function get hasSummonedChampion() : Boolean
      {
         return this._hasSummonedChampion;
      }
      
      public function set teamSkinRental(param1:TeamSkinRentalDTO) : void
      {
         if(this._teamSkinRental == param1)
         {
            return;
         }
         this._teamSkinRental = param1;
         this._teamSkinRentalChanged.dispatch(this._teamSkinRentalChanged,this._teamSkinRental);
      }
      
      public function set championSelectionIsBusy(param1:Boolean) : void
      {
         if(this._championSelectionIsBusy == param1)
         {
            return;
         }
         this._championSelectionIsBusy = param1;
         dispatchEvent(new Event(CHAMPION_SELECTION_IS_BUSY_CHANGED));
      }
      
      public function set runeBook(param1:SpellBookDTO) : void
      {
         if(param1 == this._runeBook)
         {
            return;
         }
         this._runeBook = param1;
         dispatchEvent(new Event("runeBookChanged"));
      }
      
      [Bindable(event="timeRemainingSecondsChanged")]
      public function get timeRemainingSeconds() : int
      {
         return this._timeRemainingSeconds;
      }
      
      public function set enemyTeamSelections(param1:ArrayCollection) : void
      {
         if(this._enemyTeamSelections == param1)
         {
            return;
         }
         this._enemyTeamSelections = param1;
         dispatchEvent(new Event("enemyTeamSelectionsChanged"));
      }
      
      public function get masteriesActive() : Boolean
      {
         return this._masteriesActive;
      }
      
      public function set allSpells(param1:ArrayCollection) : void
      {
         if(this._allSpells == param1)
         {
            return;
         }
         this._allSpells = param1;
         dispatchEvent(new Event("allSpellsChanged"));
      }
      
      public function set allowFreeChampions(param1:Boolean) : void
      {
         if(this._allowFreeChampions == param1)
         {
            return;
         }
         this._allowFreeChampions = param1;
         dispatchEvent(new Event("allowFreeChampionsChanged"));
      }
      
      [Bindable(event="enemyTeamVisibleChanged")]
      public function get enemyTeamVisible() : Boolean
      {
         return this._enemyTeamVisible;
      }
      
      [Bindable(event="gameTypeConfigChanged")]
      public function get gameTypeConfig() : GameTypeConfig
      {
         return this._gameTypeConfig;
      }
      
      [Bindable(event="teamOneBansChanged")]
      public function get teamOneBans() : ArrayCollection
      {
         return this._teamOneBans;
      }
      
      [Bindable(event="mainMenuStateChanged")]
      public function get mainMenuState() : String
      {
         return this._mainMenuState;
      }
      
      public function set locale(param1:String) : void
      {
         if(this._locale == param1)
         {
            return;
         }
         this._locale = param1;
         dispatchEvent(new Event("localeChanged"));
      }
      
      [Bindable(event="masteriesMenuStateChanged")]
      public function get masteriesMenuState() : String
      {
         return this._masteriesMenuState;
      }
      
      public function set chatRoom(param1:ChatRoom) : void
      {
         if(this._chatRoom == param1)
         {
            return;
         }
         this._chatRoom = param1;
         dispatchEvent(new Event("chatRoomChanged"));
      }
      
      public function set isAFK(param1:Boolean) : void
      {
         if(this._isAFK == param1)
         {
            return;
         }
         this._isAFK = param1;
         dispatchEvent(new Event("isAFKChanged"));
      }
      
      [Bindable(event="lockInStateChanged")]
      public function get lockInState() : String
      {
         return this._lockInState;
      }
      
      [Bindable(event="runePageSyncedChanged")]
      public function get runePageSynced() : Boolean
      {
         return this._runePageSynced;
      }
      
      public function set spellsMenuState(param1:String) : void
      {
         if(this._spellsMenuState == param1)
         {
            return;
         }
         this._spellsMenuState = param1;
         dispatchEvent(new Event("spellsMenuStateChanged"));
      }
      
      public function get championsActive() : Boolean
      {
         return this._championsActive;
      }
      
      public function get featuredGameInfoUpdated() : ISignal
      {
         return this._featuredGameInfoUpdated;
      }
      
      public function get friendlyTeamActive() : Boolean
      {
         return this._friendlyTeamActive;
      }
      
      public function set enemyTeamActive(param1:Boolean) : void
      {
         if(this._enemyTeamActive == param1)
         {
            return;
         }
         this._enemyTeamActive = param1;
         dispatchEvent(new Event("enemyTeamActiveChanged"));
      }
      
      [Bindable("isGameQueuedToStartChanged")]
      public function get isGameQueuedToStart() : Boolean
      {
         return this._isGameQueuedToStart;
      }
      
      public function set championTradeIsActive(param1:Boolean) : void
      {
         if(this._championTradeIsActive == param1)
         {
            return;
         }
         this._championTradeIsActive = param1;
         this._championTradeUpdated.dispatch();
      }
      
      [Bindable(event="spellsBusyChanged")]
      public function get spellsBusy() : Boolean
      {
         return this._spellsBusy;
      }
      
      public function get lockInActive() : Boolean
      {
         return this._lockInActive;
      }
      
      public function get runesActive() : Boolean
      {
         return this._runesActive;
      }
      
      [Bindable(event="progressBarVisibleChanged")]
      public function get progressBarVisible() : Boolean
      {
         return this._progressBarVisible;
      }
      
      public function set stateDescriptionText(param1:String) : void
      {
         if(this._stateDescriptionText == param1)
         {
            return;
         }
         this._stateDescriptionText = param1;
         dispatchEvent(new Event("stateDescriptionTextChanged"));
      }
      
      [Bindable(event="currentPlayerSelectionChanged")]
      public function get currentPlayerSelection() : PlayerSelection
      {
         return this._currentPlayerSelection;
      }
      
      public function set currentTeam(param1:ArrayCollection) : void
      {
         if(this._currentTeam == param1)
         {
            return;
         }
         this._currentTeam = param1;
         dispatchEvent(new Event("currentTeamChanged"));
      }
      
      public function set currentTeamSelections(param1:ArrayCollection) : void
      {
         if(this._currentTeamSelections == param1)
         {
            return;
         }
         this._currentTeamSelections = param1;
         dispatchEvent(new Event("currentTeamSelectionsChanged"));
      }
      
      [Bindable(event="showChampionGridChanged")]
      public function get showChampionGrid() : Boolean
      {
         return this._showChampionGrid;
      }
      
      public function get extendedTeamSizes() : Boolean
      {
         var _loc1_:Boolean = false;
         _loc1_ ||= this._currentTeamSelections != null && this._currentTeamSelections.length > MaxViewableTeamSize.TEAM_SIZE_NORMAL_VIEW_LIMIT;
         return _loc1_ || this._enemyTeamSelections != null && this._enemyTeamSelections.length > MaxViewableTeamSize.TEAM_SIZE_NORMAL_VIEW_LIMIT;
      }
      
      [Bindable(event="currentGameChanged")]
      public function get currentGame() : GameDTO
      {
         return this._currentGame;
      }
      
      public function set hasSummonedChampion(param1:Boolean) : void
      {
         if(this._hasSummonedChampion == param1)
         {
            return;
         }
         this._hasSummonedChampion = param1;
         dispatchEvent(new Event("hasSummonedChampionChanged"));
      }
      
      public function get chatController() : ChatController
      {
         return this._chatController;
      }
      
      [Bindable(event="currentPlayerParticipantChanged")]
      public function get currentPlayerParticipant() : GameParticipant
      {
         return this._currentPlayerParticipant;
      }
      
      public function get gameTypeConfigManager() : GameTypeConfigManager
      {
         return this._gameTypeConfigManager;
      }
      
      [Bindable(event="isSpectatingChanged")]
      public function get isSpectating() : Boolean
      {
         return this._isSpectating;
      }
      
      [Bindable(event="currentTeamNameChanged")]
      public function get currentTeamName() : String
      {
         return this._currentTeamName;
      }
      
      public function set teamTwoBans(param1:ArrayCollection) : void
      {
         if(this._teamTwoBans == param1)
         {
            return;
         }
         this._teamTwoBans = param1;
         dispatchEvent(new Event("teamTwoBansChanged"));
      }
      
      [Bindable(event="championSelectionStateChanged")]
      public function get championSelectionState() : String
      {
         return this._championSelectionState;
      }
      
      public function get spellsActive() : Boolean
      {
         return this._spellsActive;
      }
      
      public function set timeRemainingSeconds(param1:int) : void
      {
         if(this._timeRemainingSeconds == param1)
         {
            return;
         }
         this._timeRemainingSeconds = param1;
         dispatchEvent(new Event("timeRemainingSecondsChanged"));
      }
      
      public function set masteriesActive(param1:Boolean) : void
      {
         this._masteriesActive = param1;
      }
      
      [Bindable(event="runeBookChanged")]
      public function get runeBook() : SpellBookDTO
      {
         return this._runeBook;
      }
      
      public function get teamSkinRental() : TeamSkinRentalDTO
      {
         return this._teamSkinRental;
      }
      
      [Bindable(event="championSelectionIsBusyChanged")]
      public function get championSelectionIsBusy() : Boolean
      {
         return this._championSelectionIsBusy;
      }
      
      [Bindable(event="allSpellsChanged")]
      [ArrayElementType("com.riotgames.pvpnet.spells.view.model.SpellSelection")]
      public function get allSpells() : ArrayCollection
      {
         return this._allSpells;
      }
      
      [Bindable(event="allowFreeChampionsChanged")]
      public function get allowFreeChampions() : Boolean
      {
         return this._allowFreeChampions;
      }
      
      public function set enemyTeamVisible(param1:Boolean) : void
      {
         if(this._enemyTeamVisible == param1)
         {
            return;
         }
         this._enemyTeamVisible = param1;
         dispatchEvent(new Event("enemyTeamVisibleChanged"));
      }
      
      public function set championSelections(param1:ParticipantChampionListView) : void
      {
         if(this._championSelections == param1)
         {
            return;
         }
         this._championSelections = param1;
      }
      
      public function set teamOneBans(param1:ArrayCollection) : void
      {
         if(this._teamOneBans == param1)
         {
            return;
         }
         this._teamOneBans = param1;
         dispatchEvent(new Event("teamOneBansChanged"));
      }
      
      public function set gameTypeConfig(param1:GameTypeConfig) : void
      {
         if(this._gameTypeConfig == param1)
         {
            return;
         }
         this._gameTypeConfig = param1;
         dispatchEvent(new Event("gameTypeConfigChanged"));
      }
      
      public function set masteryPages(param1:ArrayCollection) : void
      {
         this._masteryPages = param1;
         dispatchEvent(new Event("masteryPagesChanged"));
      }
      
      [Bindable(event="enemyTeamActiveChanged")]
      public function get enemyTeamActive() : Boolean
      {
         return this._enemyTeamActive;
      }
      
      public function set mainMenuState(param1:String) : void
      {
         if(this._mainMenuState == param1)
         {
            return;
         }
         this._mainMenuState = param1;
         dispatchEvent(new Event("mainMenuStateChanged"));
      }
      
      [Bindable(event="currentTeamChanged")]
      public function get currentTeam() : ArrayCollection
      {
         return this._currentTeam;
      }
      
      public function set masteriesMenuState(param1:String) : void
      {
         if(this._masteriesMenuState == param1)
         {
            return;
         }
         this._masteriesMenuState = param1;
         dispatchEvent(new Event("masteriesMenuStateChanged"));
      }
      
      public function set lockInState(param1:String) : void
      {
         if(this._lockInState == param1)
         {
            return;
         }
         this._lockInState = param1;
         dispatchEvent(new Event("lockInStateChanged"));
      }
      
      public function set runePageSynced(param1:Boolean) : void
      {
         if(param1 == this._runePageSynced)
         {
            return;
         }
         this._runePageSynced = param1;
         dispatchEvent(new Event("runePageSyncedChanged"));
      }
      
      [Bindable(event="isAFKChanged")]
      public function get isAFK() : Boolean
      {
         return this._isAFK;
      }
      
      [Bindable(event="teamTwoBansChanged")]
      public function get teamTwoBans() : ArrayCollection
      {
         return this._teamTwoBans;
      }
      
      private function onTeamOneBansChanged(param1:Event) : void
      {
         dispatchEvent(new Event("teamOneBansChanged"));
      }
      
      public function set friendlyTeamActive(param1:Boolean) : void
      {
         this._friendlyTeamActive = param1;
      }
      
      public function get teamSkinRentalChanged() : ISignal
      {
         return this._teamSkinRentalChanged;
      }
      
      public function set championsActive(param1:Boolean) : void
      {
         this._championsActive = param1;
      }
      
      public function set lockInActive(param1:Boolean) : void
      {
         this._lockInActive = param1;
      }
      
      [Bindable(event="masteryPagesChanged")]
      public function get masteryPages() : ArrayCollection
      {
         return this._masteryPages;
      }
      
      public function set isGameQueuedToStart(param1:Boolean) : void
      {
         if(this._isGameQueuedToStart == param1)
         {
            return;
         }
         this._isGameQueuedToStart = param1;
         dispatchEvent(new Event("isGameQueuedToStartChanged"));
      }
      
      public function get allSkinsRentalUnlock() : Boolean
      {
         return this._teamSkinRental != null && Boolean(this._teamSkinRental.unlocked);
      }
      
      public function set allowReroll(param1:Boolean) : void
      {
         if(this._allowReroll == param1)
         {
            return;
         }
         this._allowReroll = param1;
      }
      
      [Bindable(event="championSelectionsChanged")]
      public function get championSelections() : ParticipantChampionListView
      {
         return this._championSelections;
      }
      
      public function get championTradeUpdated() : ISignal
      {
         return this._championTradeUpdated;
      }
      
      public function set runesActive(param1:Boolean) : void
      {
         this._runesActive = param1;
      }
      
      public function set spellsBusy(param1:Boolean) : void
      {
         if(this._spellsBusy == param1)
         {
            return;
         }
         this._spellsBusy = param1;
         dispatchEvent(new Event("spellsBusyChanged"));
      }
      
      public function set selectedMasteryPage(param1:MasteryPageInfoSummary) : void
      {
         if(this._selectedMasteryPage == param1)
         {
            return;
         }
         this._selectedMasteryPage = param1;
         dispatchEvent(new Event("selectedMasteryPageChanged"));
      }
      
      public function set showChampionGrid(param1:Boolean) : void
      {
         if(this._showChampionGrid == param1)
         {
            return;
         }
         this._showChampionGrid = param1;
         dispatchEvent(new Event("showChampionGridChanged"));
      }
      
      public function get allowReroll() : Boolean
      {
         return this._allowReroll;
      }
      
      public function set allowChampionSerching(param1:Boolean) : void
      {
         if(this._allowChampionSerching == param1)
         {
            return;
         }
         this._allowChampionSerching = param1;
         dispatchEvent(new Event("allowChampionSearchingChanged"));
      }
      
      public function set progressBarVisible(param1:Boolean) : void
      {
         if(this._progressBarVisible == param1)
         {
            return;
         }
         this._progressBarVisible = param1;
         dispatchEvent(new Event("progressBarVisibleChanged"));
      }
      
      public function set currentPlayerSelection(param1:PlayerSelection) : void
      {
         if(this._currentPlayerSelection == param1)
         {
            return;
         }
         this._currentPlayerSelection = param1;
         dispatchEvent(new Event("currentPlayerSelectionChanged"));
      }
      
      private function onTeamTwoBansChanged(param1:Event) : void
      {
         dispatchEvent(new Event("teamTwoBansChanged"));
      }
      
      [Bindable(event="selectedMasteryPageChanged")]
      public function get selectedMasteryPage() : MasteryPageInfoSummary
      {
         return this._selectedMasteryPage;
      }
      
      [Bindable(event="allowChampionSearchingChanged")]
      public function get allowChampionSerching() : Boolean
      {
         return this._allowChampionSerching;
      }
      
      public function set currentPickMode(param1:int) : void
      {
         if(this._currentPickMode == param1)
         {
            return;
         }
         this._currentPickMode = param1;
         dispatchEvent(new Event("currentPickModeChanged"));
      }
      
      [Bindable(event="currentPickModeChanged")]
      public function get currentPickMode() : int
      {
         return this._currentPickMode;
      }
   }
}

