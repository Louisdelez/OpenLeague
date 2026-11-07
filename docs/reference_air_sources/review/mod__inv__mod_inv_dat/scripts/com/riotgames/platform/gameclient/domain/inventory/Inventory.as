package com.riotgames.platform.gameclient.domain.inventory
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.provider.IInventory;
   import com.riotgames.platform.gameclient.domain.Spell;
   import com.riotgames.platform.gameclient.domain.SpellBookDTO;
   import com.riotgames.platform.gameclient.domain.SummonerRune;
   import com.riotgames.platform.gameclient.domain.SummonerRuneInventory;
   import com.riotgames.platform.provider.IProvider;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   import mx.collections.ArrayCollection;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class Inventory extends EventDispatcher implements IInventory, IProvider
   {
      
      private var _runeStats:ArrayCollection;
      
      private var _championsPrecached:Boolean = false;
      
      private var _freeToPlayChampionForNewPlayerMaxLevel:Number = 0;
      
      private var _knownGameModesForSpells:ArrayCollection;
      
      private var _championRegistry:Array;
      
      private var _championCount:int = 0;
      
      private var _skinSkinIdMapping:Object = null;
      
      private var _freeToPlayChampionForNewPlayersIds:ArrayCollection = null;
      
      private var _championIdMapping:Array = null;
      
      private var _championSkinIdMapping:Object = null;
      
      private var _gameItemData:Object;
      
      private var _unobtainableChampionSkinIDList:ArrayCollection = null;
      
      private var _lastIpPoints:Number;
      
      private var _runeDictionary:Dictionary;
      
      private var _inactiveChampionIdList:ArrayCollection = null;
      
      private var _summonerRuneInventory:SummonerRuneInventory;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var _spellDictionary:Dictionary = null;
      
      private var _runeBook:SpellBookDTO = null;
      
      private var _champions:ArrayCollection = new ArrayCollection();
      
      private var _activeBoosts:ActiveBoosts = new ActiveBoosts();
      
      private var _freeToPlayChampionIds:ArrayCollection = null;
      
      private var _isChampionsLoaded:Boolean = false;
      
      private var _championDataDictionary:Dictionary = null;
      
      private var _championSearchTags:Array;
      
      private var _gameModeToInactiveSpellIds:Dictionary;
      
      private var _championDataDictionaryChanged:Signal = new Signal();
      
      private var _influencePoints:Number = 0;
      
      private var _knownMaps:ArrayCollection;
      
      private var _riotPoints:Number = 0;
      
      public function Inventory()
      {
         super();
      }
      
      public function get freeToPlayChampionForNewPlayerMaxLevel() : Number
      {
         return this._freeToPlayChampionForNewPlayerMaxLevel;
      }
      
      public function set runeStats(param1:ArrayCollection) : void
      {
         if(this._runeStats == param1)
         {
            return;
         }
         this._runeStats = param1;
         dispatchEvent(new Event("runeStatsChanged"));
      }
      
      public function set knownMaps(param1:ArrayCollection) : void
      {
         this._knownMaps = param1;
      }
      
      [Bindable(event="championCountChanged")]
      public function get championCount() : int
      {
         return this._championCount;
      }
      
      public function set summonerRuneInventory(param1:SummonerRuneInventory) : void
      {
         var _loc2_:SummonerRune = null;
         for each(_loc2_ in param1.summonerRunes)
         {
            InventoryUtils.hydrateRuneData(_loc2_,this._runeDictionary);
         }
         if(this._summonerRuneInventory == param1)
         {
            return;
         }
         this._summonerRuneInventory = param1;
         dispatchEvent(new Event("summonerRuneInventoryChanged"));
      }
      
      public function get gameModeToInactiveSpellIds() : Dictionary
      {
         return this._gameModeToInactiveSpellIds;
      }
      
      public function get champions() : ArrayCollection
      {
         return this._champions;
      }
      
      [Bindable(event="influencePointsChanged")]
      public function get influencePoints() : Number
      {
         return this._influencePoints;
      }
      
      public function set freeToPlayChampionForNewPlayersIds(param1:ArrayCollection) : void
      {
         if(this._freeToPlayChampionForNewPlayersIds == param1)
         {
            return;
         }
         this._freeToPlayChampionForNewPlayersIds = param1;
      }
      
      [Bindable(event="runeBookChanged")]
      public function get runeBook() : SpellBookDTO
      {
         return this._runeBook;
      }
      
      public function get isChampionsLoaded() : Boolean
      {
         return this._isChampionsLoaded;
      }
      
      public function set lastIpPoints(param1:Number) : void
      {
         if(this._lastIpPoints == param1)
         {
            return;
         }
      }
      
      public function get championSkinIdMapping() : Object
      {
         return this._championSkinIdMapping;
      }
      
      private function updateKnownGameModesForSpells() : void
      {
         var _loc1_:Spell = null;
         var _loc2_:String = null;
         this.knownGameModesForSpells = new ArrayCollection();
         for each(_loc1_ in this.spellDictionary)
         {
            for each(_loc2_ in _loc1_.gameModes)
            {
               if(!this.knownGameModesForSpells.contains(_loc2_))
               {
                  this.knownGameModesForSpells.addItem(_loc2_);
               }
            }
         }
      }
      
      public function set championCount(param1:int) : void
      {
         if(this._championCount == param1)
         {
            return;
         }
         this._championCount = param1;
         dispatchEvent(new Event("championCountChanged"));
         this.checkInitialized();
      }
      
      public function set champions(param1:ArrayCollection) : void
      {
         if(this._champions == param1)
         {
            return;
         }
         this._champions = param1;
      }
      
      public function get unobtainableChampionSkinIDList() : ArrayCollection
      {
         return this._unobtainableChampionSkinIDList;
      }
      
      public function set championDataDictionary(param1:Dictionary) : void
      {
         if(this._championDataDictionary == param1)
         {
            return;
         }
         this._championDataDictionary = param1;
         this._championDataDictionaryChanged.dispatch();
         this.checkInitialized();
      }
      
      [Bindable(event="riotPointsChanged")]
      public function get riotPoints() : Number
      {
         return this._riotPoints;
      }
      
      public function getFreeToPlayChampionIdsForLevel(param1:Number) : ArrayCollection
      {
         return param1 > this._freeToPlayChampionForNewPlayerMaxLevel ? this._freeToPlayChampionIds : this._freeToPlayChampionForNewPlayersIds;
      }
      
      public function set gameModeToInactiveSpellIds(param1:Dictionary) : void
      {
         if(this._gameModeToInactiveSpellIds == param1)
         {
            return;
         }
         this._gameModeToInactiveSpellIds = param1;
      }
      
      public function set influencePoints(param1:Number) : void
      {
         if(this._influencePoints == param1)
         {
            return;
         }
         this._influencePoints = param1;
         dispatchEvent(new Event("influencePointsChanged"));
      }
      
      public function set skinSkinIdMapping(param1:Object) : void
      {
         if(this._skinSkinIdMapping == param1)
         {
            return;
         }
         this._skinSkinIdMapping = param1;
      }
      
      public function get inactiveChampionIdList() : ArrayCollection
      {
         return this._inactiveChampionIdList;
      }
      
      public function get gameItemData() : Object
      {
         return this._gameItemData;
      }
      
      public function set freeToPlayChampionIds(param1:ArrayCollection) : void
      {
         if(this._freeToPlayChampionIds == param1)
         {
            return;
         }
         this._freeToPlayChampionIds = param1;
      }
      
      public function get knownMaps() : ArrayCollection
      {
         return this._knownMaps;
      }
      
      public function get championsPrecached() : Boolean
      {
         return this._championsPrecached;
      }
      
      [Bindable(event="runeStatsChanged")]
      public function get runeStats() : ArrayCollection
      {
         return this._runeStats;
      }
      
      public function set runeBook(param1:SpellBookDTO) : void
      {
         if(this._runeBook == param1)
         {
            return;
         }
         this._runeBook = param1;
         dispatchEvent(new Event("runeBookChanged"));
      }
      
      public function set isChampionsLoaded(param1:Boolean) : void
      {
         if(this._isChampionsLoaded == param1)
         {
            return;
         }
         this._isChampionsLoaded = param1;
      }
      
      public function set championSkinIdMapping(param1:Object) : void
      {
         if(this._championSkinIdMapping)
         {
            return;
         }
         this._championSkinIdMapping = param1;
      }
      
      public function set championIdMapping(param1:Array) : void
      {
         if(this._championIdMapping == param1)
         {
            return;
         }
         this._championIdMapping = param1;
      }
      
      public function get lastIpPoints() : Number
      {
         return this._lastIpPoints;
      }
      
      public function set championRegistry(param1:Array) : void
      {
         if(this._championRegistry == param1)
         {
            return;
         }
         this._championRegistry = param1;
         dispatchEvent(new Event("championRegistryChanged"));
      }
      
      public function get championDataDictionary() : Dictionary
      {
         return this._championDataDictionary;
      }
      
      public function get knownGameModesForSpells() : ArrayCollection
      {
         return this._knownGameModesForSpells;
      }
      
      public function set unobtainableChampionSkinIDList(param1:ArrayCollection) : void
      {
         if(this._unobtainableChampionSkinIDList == param1)
         {
            return;
         }
         this._unobtainableChampionSkinIDList = param1;
      }
      
      public function set knownGameModesForSpells(param1:ArrayCollection) : void
      {
         if(this._knownGameModesForSpells == param1)
         {
            return;
         }
         this._knownGameModesForSpells = param1;
      }
      
      public function set activeBoosts(param1:ActiveBoosts) : void
      {
         if(this._activeBoosts == param1)
         {
            return;
         }
         this._activeBoosts = param1;
         dispatchEvent(new Event("activeBoostsChanged"));
      }
      
      [Bindable(event="summonerRuneInventoryChanged")]
      public function get summonerRuneInventory() : SummonerRuneInventory
      {
         return this._summonerRuneInventory;
      }
      
      public function set riotPoints(param1:Number) : void
      {
         if(this._riotPoints == param1)
         {
            return;
         }
         this._riotPoints = param1;
         dispatchEvent(new Event("riotPointsChanged"));
      }
      
      public function get skinSkinIdMapping() : Object
      {
         return this._skinSkinIdMapping;
      }
      
      public function set spellDictionary(param1:Dictionary) : void
      {
         if(this.spellDictionary == param1)
         {
            return;
         }
         this._spellDictionary = param1;
         this.updateKnownGameModesForSpells();
         dispatchEvent(new Event("spellDictionaryChanged"));
         this.checkInitialized();
      }
      
      private function checkInitialized() : void
      {
         if(Boolean(this._championDataDictionary && this._gameItemData) && Boolean(this.championCount > 0) && Boolean(this.spellDictionary))
         {
            dispatchEvent(new Event("inventoryInitialized"));
         }
      }
      
      [Bindable(event="championRegistryChanged")]
      public function get championRegistry() : Array
      {
         return this._championRegistry;
      }
      
      public function get championIdMapping() : Array
      {
         return this._championIdMapping;
      }
      
      public function get championDataDictionaryChanged() : ISignal
      {
         return this._championDataDictionaryChanged;
      }
      
      public function get runeDictionary() : Dictionary
      {
         return this._runeDictionary;
      }
      
      public function set inactiveChampionIdList(param1:ArrayCollection) : void
      {
         if(this._inactiveChampionIdList == param1)
         {
            return;
         }
         this._inactiveChampionIdList = param1;
      }
      
      [Bindable(event="activeBoostsChanged")]
      public function get activeBoosts() : ActiveBoosts
      {
         return this._activeBoosts;
      }
      
      public function set runeDictionary(param1:Dictionary) : void
      {
         this._runeDictionary = param1;
      }
      
      public function set gameItemData(param1:Object) : void
      {
         if(this._gameItemData == param1)
         {
            return;
         }
         this._gameItemData = param1;
         this.checkInitialized();
      }
      
      [Bindable(event="spellDictionaryChanged")]
      public function get spellDictionary() : Dictionary
      {
         return this._spellDictionary;
      }
      
      public function set championsPrecached(param1:Boolean) : void
      {
         if(this._championsPrecached == param1)
         {
            return;
         }
         this._championsPrecached = param1;
      }
      
      public function set freeToPlayChampionForNewPlayerMaxLevel(param1:Number) : void
      {
         if(this._freeToPlayChampionForNewPlayerMaxLevel == param1)
         {
            return;
         }
         this._freeToPlayChampionForNewPlayerMaxLevel = param1;
      }
   }
}

