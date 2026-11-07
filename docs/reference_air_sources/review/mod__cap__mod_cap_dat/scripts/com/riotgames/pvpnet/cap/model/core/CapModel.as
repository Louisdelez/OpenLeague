package com.riotgames.pvpnet.cap.model.core
{
   import blix.IDestructible;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.gameclient.chat.controllers.ChatRoom;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.SpellBookDTO;
   import com.riotgames.platform.gameclient.domain.Summoner;
   import com.riotgames.platform.gameclient.domain.game.CapModuleInfo;
   import com.riotgames.pvpnet.cap.model.CapDefaultPlayerSelections;
   import com.riotgames.pvpnet.cap.model.CapEstimatedWaitTime;
   import com.riotgames.pvpnet.cap.model.CapEstimatedWaitTimes;
   import com.riotgames.pvpnet.cap.model.CapPhase;
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.model.CapPositions;
   import com.riotgames.pvpnet.cap.model.CapRoles;
   import com.riotgames.pvpnet.cap.model.ISpellModel;
   import com.riotgames.pvpnet.cap.util.CapModelUtil;
   import mx.collections.ArrayCollection;
   import mx.events.CollectionEvent;
   
   public class CapModel implements ISpellModel, IDestructible
   {
      
      private var _selectingSkin:Boolean = false;
      
      public var selectableRoles:Array = [CapRoles.ASSASSIN,CapRoles.FIGHTER,CapRoles.MAGE,CapRoles.MARKSMAN,CapRoles.SUPPORT,CapRoles.TANK];
      
      private var _demandedSpecs:Array = [];
      
      private var _gameMode:String = null;
      
      private var _invitePanelVisible:Boolean = true;
      
      private var _captainsDemandedChanged:Signal = new Signal();
      
      private var _hasLaunchedGame:Boolean = false;
      
      private var _gameModeChanged:Signal = new Signal();
      
      public var playerSelections:ArrayCollection;
      
      private var _quitEnabled:Boolean = true;
      
      private var _newSkins:Vector.<Number> = new Vector.<Number>();
      
      public var numDemandBoardClicks:int = 0;
      
      private var _soloAFKTimeRemaining:Number = NaN;
      
      private var _inviteSuggestionListChanged:Signal = new Signal();
      
      public var pendingChampionSelection:Champion;
      
      private var _kickEnabled:Boolean = true;
      
      public var positions:Array = [CapPositions.TOP,CapPositions.MIDDLE,CapPositions.BOTTOM,CapPositions.JUNGLE];
      
      private var _enabledFeatureToggles:Object = new Object();
      
      public var speccableRoles:Array = [];
      
      private var _spellsBusy:Boolean;
      
      private var _mmaPositionBonusIds:Array = [];
      
      public var soloAFKStartTime:Number;
      
      private var _runeBook:SpellBookDTO;
      
      private var _chatRoomChanged:Signal = new Signal();
      
      private var capModuleInfo:CapModuleInfo = CapModuleInfo.instance;
      
      private var _summoner:Summoner;
      
      public var activeCaptainSelectionPanel:CapPlayerSelection = null;
      
      private var _groupId:String;
      
      private var _minPremadeSize:int = 0;
      
      private var _kickEnabledChanged:Signal = new Signal();
      
      private var _gameTypeConfigId:int;
      
      private var _inSoloQueueChanged:Signal = new Signal();
      
      private var _searchingForSolosChanged:Signal = new Signal();
      
      private var _currentEstimatedWaitTimeChanged:Signal = new Signal();
      
      private var _availableChampions:ArrayCollection = new ArrayCollection();
      
      private var _quitEnabledChanged:Signal = new Signal();
      
      private var _runePagesChanged:Signal = new Signal();
      
      private var _minPremadeSizeChanged:Signal = new Signal();
      
      private var _inviteSuggestionList:ArrayCollection = new ArrayCollection();
      
      private var _searchingForSolos:Boolean = false;
      
      private var _currentEstimatedWaitTime:CapEstimatedWaitTime;
      
      private var _runePages:ArrayCollection;
      
      private var _soloAFKTimeRemainingChanged:Signal = new Signal();
      
      private var _summonerChanged:Signal = new Signal();
      
      private var _inMatchmakingQueueChanged:Signal = new Signal();
      
      public var localPlayerCausedDisband:Boolean = false;
      
      private var _spells:ArrayCollection = new ArrayCollection();
      
      private var _showInvitePowersButtonChanged:Signal = new Signal();
      
      private var _captainsDemanded:Boolean = false;
      
      private var _groupIdChanged:Signal = new Signal();
      
      private var _groupTtlString:String;
      
      private var _creatingSoloQueryChanged:Signal = new Signal();
      
      private var _showInvitePowersButton:Boolean = false;
      
      private var _masteryPagesChanged:Signal = new Signal();
      
      public var currentPhase:String = "UNSPECIFIED";
      
      private var _masteryPages:ArrayCollection;
      
      private var _hasLaunchedGameChanged:Signal = new Signal();
      
      public var allRoles:Array = [CapRoles.ANY,CapRoles.ASSASSIN,CapRoles.FIGHTER,CapRoles.MAGE,CapRoles.MARKSMAN,CapRoles.SUPPORT,CapRoles.TANK];
      
      private var _demandedSpecsChanged:Signal = new Signal();
      
      public var originalInviteSuggestionList:Array = [];
      
      private var _inMatchmakingQueue:Boolean = false;
      
      private var _runeBookChanged:Signal = new Signal();
      
      private var _chatRoom:ChatRoom;
      
      private var _invitePanelVisibleChanged:Signal = new Signal();
      
      public var isInMatchmaking:Boolean = false;
      
      private var _mmaChampionBonusIds:Array = [];
      
      private var _inSoloQuery:Boolean = false;
      
      private var _enabledFeatureTogglesChanged:Signal = new Signal();
      
      private var _finishedSelectingSkin:Signal = new Signal();
      
      public var useNewSuggestedPlayers:Boolean = false;
      
      private var _mmaRoleBonusIds:Array = [];
      
      private var _numPlayersForQueue:int = 0;
      
      private var _creatingSoloQuery:Boolean = false;
      
      public var estimatedWaitTimes:Array = [CapEstimatedWaitTimes.UNKNOWN,CapEstimatedWaitTimes.VERY_SHORT,CapEstimatedWaitTimes.SHORT,CapEstimatedWaitTimes.AVERAGE,CapEstimatedWaitTimes.LONG,CapEstimatedWaitTimes.VERY_LONG];
      
      public function CapModel(param1:int)
      {
         super();
         this._numPlayersForQueue = param1;
         this.capModuleInfo.lobbyTextVisible = true;
         this.playerSelections = CapDefaultPlayerSelections.createDefaultPlayerSelections(param1);
      }
      
      public function destroy() : void
      {
         var _loc2_:CapPlayerSelection = null;
         this._chatRoom = null;
         this._chatRoomChanged.removeAll();
         this._selectingSkin = false;
         this.currentPhase = CapPhase.UNSPECIFIED;
         this.capModuleInfo.lobbyTimeRemaining = null;
         this.capModuleInfo.homeButtonVisible = false;
         this.capModuleInfo.inSoloQueue = false;
         this.capModuleInfo.lobbyTextVisible = false;
         this.capModuleInfo.inMatchmakingQueue = false;
         this._minPremadeSizeChanged.removeAll();
         this._gameModeChanged.removeAll();
         this._invitePanelVisibleChanged.removeAll();
         this._masteryPagesChanged.removeAll();
         this._runeBookChanged.removeAll();
         this._summonerChanged.removeAll();
         this._groupIdChanged.removeAll();
         this._hasLaunchedGameChanged.removeAll();
         this._inMatchmakingQueueChanged.removeAll();
         this._creatingSoloQueryChanged.removeAll();
         this._showInvitePowersButtonChanged.removeAll();
         var _loc1_:Array = CapModelUtil.getAllAvailablePlayerSelections(this);
         for each(_loc2_ in _loc1_)
         {
            _loc2_.destroy();
         }
      }
      
      public function get selectingSkin() : Boolean
      {
         return this._selectingSkin;
      }
      
      public function set selectingSkin(param1:Boolean) : void
      {
         var _loc2_:Boolean = true;
         if(this._selectingSkin == false)
         {
            _loc2_ = false;
         }
         this._selectingSkin = param1;
         if(this._selectingSkin == true)
         {
            _loc2_ = false;
         }
         if(_loc2_)
         {
            this._finishedSelectingSkin.dispatch();
         }
      }
      
      public function get inviteSuggestionListChanged() : ISignal
      {
         return this._inviteSuggestionListChanged;
      }
      
      public function get minPremadeSizeChanged() : ISignal
      {
         return this._minPremadeSizeChanged;
      }
      
      public function get mmaRoleBonusIds() : Array
      {
         return this._mmaRoleBonusIds;
      }
      
      public function set inMatchmakingQueue(param1:Boolean) : void
      {
         this._inMatchmakingQueue = param1;
         this.capModuleInfo.inMatchmakingQueue = param1;
         this._inMatchmakingQueueChanged.dispatch();
      }
      
      public function get demandedSpecs() : Array
      {
         return this._demandedSpecs;
      }
      
      public function get kickEnabledChanged() : ISignal
      {
         return this._kickEnabledChanged;
      }
      
      public function get creatingSoloQueryChanged() : ISignal
      {
         return this._creatingSoloQueryChanged;
      }
      
      public function get kickEnabled() : Boolean
      {
         return this._kickEnabled;
      }
      
      public function set demandedSpecs(param1:Array) : void
      {
         this._demandedSpecs = param1;
         this._demandedSpecsChanged.dispatch();
      }
      
      public function set captainsDemanded(param1:Boolean) : void
      {
         this._captainsDemanded = param1;
         this._captainsDemandedChanged.dispatch();
      }
      
      public function set kickEnabled(param1:Boolean) : void
      {
         if(param1 == this._kickEnabled)
         {
            return;
         }
         this._kickEnabled = param1;
         this._kickEnabledChanged.dispatch();
      }
      
      public function get gameModeChanged() : ISignal
      {
         return this._gameModeChanged;
      }
      
      public function get inviteSuggestionList() : ArrayCollection
      {
         return this._inviteSuggestionList;
      }
      
      public function get masteryPagesChanged() : ISignal
      {
         return this._masteryPagesChanged;
      }
      
      public function addNewlyPurchasedSkinId(param1:Number) : void
      {
         if(this._newSkins.indexOf(param1) == -1)
         {
            this._newSkins.push(param1);
         }
      }
      
      public function get chatRoom() : ChatRoom
      {
         return this._chatRoom;
      }
      
      public function set inviteSuggestionList(param1:ArrayCollection) : void
      {
         this._inviteSuggestionList = param1;
         this._inviteSuggestionListChanged.dispatch();
      }
      
      public function get hasLaunchedGame() : Boolean
      {
         return this._hasLaunchedGame;
      }
      
      public function get availableChampions() : ArrayCollection
      {
         return this._availableChampions;
      }
      
      public function get quitEnabledChanged() : ISignal
      {
         return this._quitEnabledChanged;
      }
      
      public function get gameTypeConfigId() : int
      {
         return this._gameTypeConfigId;
      }
      
      public function get creatingSoloQuery() : Boolean
      {
         return this._creatingSoloQuery;
      }
      
      public function get hasLaunchedGameChanged() : ISignal
      {
         return this._hasLaunchedGameChanged;
      }
      
      public function isSkinNewlyPurchased(param1:Number) : Boolean
      {
         if(this._newSkins.indexOf(param1) != -1)
         {
            this._newSkins.splice(this._newSkins.indexOf(param1),1);
            return true;
         }
         return false;
      }
      
      public function set runeBook(param1:SpellBookDTO) : void
      {
         this._runeBook = param1;
         if(this.runeBook)
         {
            this.runePages = this._runeBook.bookPages;
         }
         else
         {
            this.runePages = null;
         }
         this._runeBookChanged.dispatch();
      }
      
      public function get mmaChampionBonusIds() : Array
      {
         return this._mmaChampionBonusIds;
      }
      
      public function get inSoloQueryChanged() : ISignal
      {
         return this._inSoloQueueChanged;
      }
      
      public function set summoner(param1:Summoner) : void
      {
         this._summoner = param1;
         this._summonerChanged.dispatch();
         this.localPlayerSelection.summonerName = this._summoner.name;
      }
      
      public function set allSpells(param1:ArrayCollection) : void
      {
         this._spells = param1;
      }
      
      public function set chatRoom(param1:ChatRoom) : void
      {
         this._chatRoom = param1;
         this._chatRoomChanged.dispatch();
      }
      
      public function get minPremadeSize() : int
      {
         return this._minPremadeSize;
      }
      
      public function get runePages() : ArrayCollection
      {
         return this._runePages;
      }
      
      public function get runePagesChanged() : ISignal
      {
         return this._runePagesChanged;
      }
      
      public function get gameMode() : String
      {
         return this._gameMode;
      }
      
      public function set hasLaunchedGame(param1:Boolean) : void
      {
         this._hasLaunchedGame = param1;
         this._hasLaunchedGameChanged.dispatch();
      }
      
      public function get localPlayerSelection() : CapPlayerSelection
      {
         var _loc1_:CapPlayerSelection = null;
         if(!this.playerSelections.source)
         {
            return null;
         }
         for each(_loc1_ in this.playerSelections.source)
         {
            if(_loc1_.isLocalPlayer)
            {
               return _loc1_;
            }
         }
         return null;
      }
      
      public function set groupTtlString(param1:String) : void
      {
         this._groupTtlString = param1;
         this.capModuleInfo.lobbyTimeRemaining = param1;
      }
      
      public function set soloAFKTimeRemaining(param1:Number) : void
      {
         this._soloAFKTimeRemaining = param1;
         this._soloAFKTimeRemainingChanged.dispatch();
      }
      
      public function get finishedSelectingSkin() : ISignal
      {
         return this._finishedSelectingSkin;
      }
      
      public function set gameTypeConfigId(param1:int) : void
      {
         this._gameTypeConfigId = param1;
      }
      
      public function get inMatchmakingQueueChanged() : ISignal
      {
         return this._inMatchmakingQueueChanged;
      }
      
      public function set pvpNetHomeButtonVisible(param1:Boolean) : void
      {
         this.capModuleInfo.setHomeButtonVisible(param1);
      }
      
      public function set creatingSoloQuery(param1:Boolean) : void
      {
         if(param1 != this._creatingSoloQuery)
         {
            this._creatingSoloQuery = param1;
            this._creatingSoloQueryChanged.dispatch();
         }
      }
      
      public function get chatRoomChanged() : ISignal
      {
         return this._chatRoomChanged;
      }
      
      public function set enabledFeatureToggles(param1:Object) : void
      {
         this._enabledFeatureToggles = param1;
         this._enabledFeatureTogglesChanged.dispatch();
      }
      
      public function get spellsBusy() : Boolean
      {
         return this._spellsBusy;
      }
      
      public function get demandedSpecsChanged() : ISignal
      {
         return this._demandedSpecsChanged;
      }
      
      public function set invitePanelVisible(param1:Boolean) : void
      {
         this._invitePanelVisible = param1;
         this._invitePanelVisibleChanged.dispatch();
      }
      
      public function get soloAFKTimeRemainingChanged() : Signal
      {
         return this._soloAFKTimeRemainingChanged;
      }
      
      public function set inSoloQuery(param1:Boolean) : void
      {
         this._inSoloQuery = param1;
         this.capModuleInfo.inSoloQueue = param1;
         this._inSoloQueueChanged.dispatch();
      }
      
      public function set searchingForSolos(param1:Boolean) : void
      {
         this._searchingForSolos = param1;
         this._searchingForSolosChanged.dispatch();
      }
      
      public function get inMatchmakingQueue() : Boolean
      {
         return this._inMatchmakingQueue;
      }
      
      public function get captainsDemanded() : Boolean
      {
         return this._captainsDemanded;
      }
      
      public function get currentEstimatedWaitTimeChanged() : ISignal
      {
         return this._currentEstimatedWaitTimeChanged;
      }
      
      public function get numPlayersForQueue() : int
      {
         return this._numPlayersForQueue;
      }
      
      public function get invitePanelVisibleChanged() : ISignal
      {
         return this._invitePanelVisibleChanged;
      }
      
      public function get mmaPositionBonusIds() : Array
      {
         return this._mmaPositionBonusIds;
      }
      
      public function get allSpells() : ArrayCollection
      {
         return this._spells;
      }
      
      public function set minPremadeSize(param1:int) : void
      {
         this._minPremadeSize = param1;
         this._minPremadeSizeChanged.dispatch();
      }
      
      public function get runeBook() : SpellBookDTO
      {
         return this._runeBook;
      }
      
      public function set runePages(param1:ArrayCollection) : void
      {
         if(this._runePages)
         {
            this._runePages.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this._masteryPagesChanged.dispatch);
         }
         this._runePages = param1;
         if(this._runePages)
         {
            this._runePages.addEventListener(CollectionEvent.COLLECTION_CHANGE,this._masteryPagesChanged.dispatch);
         }
         this._runePagesChanged.dispatch();
      }
      
      public function get summoner() : Summoner
      {
         return this._summoner;
      }
      
      public function get captainsDemandedChanged() : ISignal
      {
         return this._captainsDemandedChanged;
      }
      
      public function get groupTtlString() : String
      {
         return this._groupTtlString;
      }
      
      public function get groupIdChanged() : ISignal
      {
         return this._groupIdChanged;
      }
      
      public function get soloAFKTimeRemaining() : Number
      {
         return this._soloAFKTimeRemaining;
      }
      
      public function getShowInvitePowersButton() : Boolean
      {
         return this._showInvitePowersButton;
      }
      
      public function setShowInvitePowersButton(param1:Boolean) : void
      {
         this._showInvitePowersButton = param1;
         this._showInvitePowersButtonChanged.dispatch();
      }
      
      public function set masteryPages(param1:ArrayCollection) : void
      {
         if(this._masteryPages)
         {
            this._masteryPages.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this._masteryPagesChanged.dispatch);
         }
         this._masteryPages = param1;
         if(this._masteryPages)
         {
            this._masteryPages.addEventListener(CollectionEvent.COLLECTION_CHANGE,this._masteryPagesChanged.dispatch);
         }
         this._masteryPagesChanged.dispatch();
      }
      
      public function set gameMode(param1:String) : void
      {
         this._gameMode = param1;
         this._gameModeChanged.dispatch();
      }
      
      public function get invitePanelVisible() : Boolean
      {
         return this._invitePanelVisible;
      }
      
      public function get searchingForSolosChanged() : ISignal
      {
         return this._searchingForSolosChanged;
      }
      
      public function get inSoloQuery() : Boolean
      {
         return this._inSoloQuery;
      }
      
      public function get summonerChanged() : ISignal
      {
         return this._summonerChanged;
      }
      
      public function set currentEstimatedWaitTime(param1:CapEstimatedWaitTime) : void
      {
         this._currentEstimatedWaitTime = param1;
         this._currentEstimatedWaitTimeChanged.dispatch();
      }
      
      public function get searchingForSolos() : Boolean
      {
         return this._searchingForSolos;
      }
      
      public function get masteryPages() : ArrayCollection
      {
         return this._masteryPages;
      }
      
      public function get enabledFeatureToggles() : Object
      {
         return this._enabledFeatureToggles;
      }
      
      public function getShowInvitePowersButtonChanged() : ISignal
      {
         return this._showInvitePowersButtonChanged;
      }
      
      public function get currentEstimatedWaitTime() : CapEstimatedWaitTime
      {
         return this._currentEstimatedWaitTime;
      }
      
      public function set spellsBusy(param1:Boolean) : void
      {
         this._spellsBusy = param1;
      }
      
      public function set quitEnabled(param1:Boolean) : void
      {
         this._quitEnabled = param1;
         this._quitEnabledChanged.dispatch();
      }
      
      public function get quitEnabled() : Boolean
      {
         return this._quitEnabled;
      }
      
      public function set groupId(param1:String) : void
      {
         this._groupId = param1;
         this._groupIdChanged.dispatch();
      }
      
      public function get runeBookChanged() : ISignal
      {
         return this._runeBookChanged;
      }
      
      public function get enabledFeatureTogglesChanged() : Signal
      {
         return this._enabledFeatureTogglesChanged;
      }
      
      public function get groupId() : String
      {
         return this._groupId;
      }
   }
}

