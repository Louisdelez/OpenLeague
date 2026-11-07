package com.riotgames.platform.gameclient.domain.inventory
{
   import com.riotgames.platform.common.provider.ChromeContextAlertProviderProxy;
   import com.riotgames.platform.common.provider.IInventory;
   import com.riotgames.platform.common.provider.IInventoryController;
   import com.riotgames.platform.common.services.InventoryService;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.gameclient.Models.SearchTagData;
   import com.riotgames.platform.gameclient.contextAlert.AlertParameters;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.ChampionSkin;
   import com.riotgames.platform.gameclient.domain.GameItem;
   import com.riotgames.platform.gameclient.domain.IChampionFilter;
   import com.riotgames.platform.gameclient.domain.Spell;
   import com.riotgames.platform.gameclient.domain.SummonerRune;
   import com.riotgames.platform.gameclient.domain.store.RentalUpdateNotification;
   import com.riotgames.platform.gameclient.domain.store.StoreAccountBalanceNotification;
   import com.riotgames.platform.gameclient.domain.store.StoreFulfillmentNotification;
   import com.riotgames.platform.gameclient.domain.systemstates.ClientSystemStatesNotification;
   import com.riotgames.platform.gameclient.events.InventoryEvent;
   import com.riotgames.platform.provider.IProvider;
   import com.riotgames.pvpnet.system.config.cdc.ConfigurationModel;
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
   import com.riotgames.util.json.jsonDecode;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   import mx.collections.ArrayCollection;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.resources.ResourceManager;
   import mx.rpc.events.ResultEvent;
   
   public class InventoryController extends EventDispatcher implements IInventoryController, IProvider
   {
      
      public static const DISABLED_SKIN_NAMESPACE:String = "DisabledChampionSkins";
      
      public static const DISABLED_SKIN_KEY:String = "DisabledChampionSkins";
      
      private var _searchTags:Array;
      
      public var championDelegate:ChampionDelegate;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      public var fullfillmentDelegate:FullfillmentDelegate;
      
      private var disabledChampionSkinIds:Array;
      
      public var runeBookController:RuneBookController;
      
      private var overWriteLoginAccountBalance:Boolean = false;
      
      private var _searchTagsSecondary:Array;
      
      private var _inventory:IInventory;
      
      public function InventoryController(param1:Inventory, param2:RuneBookController, param3:ChampionDelegate, param4:FullfillmentDelegate)
      {
         super();
         this.runeBookController = param2;
         this.inventory = param1;
         this.fullfillmentDelegate = param4;
         this.championDelegate = param3;
         this.disabledChampionSkinIds = new Array();
         this.fullfillmentDelegate.addEventListener(InventoryEvent.SHOW_ALERT,this.displayAlertForFulfillment);
         this.fullfillmentDelegate.addEventListener(InventoryEvent.ACCOUNT_BALANCE_UPDATED,this.redispatchInventoryEvent);
         this.fullfillmentDelegate.addEventListener(InventoryEvent.SKIN_PURCHASE_PENDING,this.redispatchInventoryEvent);
      }
      
      public function findChampionBySkinName(param1:String) : Champion
      {
         return this.inventory.championRegistry[param1] as Champion;
      }
      
      public function populateSearchTags(param1:Array) : void
      {
         this._searchTags = param1;
      }
      
      public function createSearchTags() : Array
      {
         return this.createSearchTagArray(this._searchTags);
      }
      
      public function loadUserInventory() : void
      {
         this.getChampionList();
         this.loadUserRunes();
      }
      
      public function refreshChampionSkins() : void
      {
         this.updateChampionSkins(this.inventory.unobtainableChampionSkinIDList);
      }
      
      public function getChampionList() : void
      {
         var _loc1_:InventoryService = ServiceProxy.instance.inventoryService;
         _loc1_.getAvailableChampions(this.onRetrieveAvailableChampionsSuccess,null);
      }
      
      public function processRentalUpdateNotification(param1:RentalUpdateNotification) : void
      {
         this.fullfillmentDelegate.processRentalUpdateNotification(param1);
      }
      
      public function redispatchInventoryEvent(param1:InventoryEvent) : void
      {
         dispatchEvent(param1);
      }
      
      public function loadUserRunes() : void
      {
         this.runeBookController.refreshRuneInventory();
         if(this.inventory.runeBook == null)
         {
            this.runeBookController.getLocalRunebook();
         }
         else
         {
            RuneBookUtils.localizeRuneBook(this.inventory.runeBook);
         }
      }
      
      public function populateSecondarySearchTags(param1:Array) : void
      {
         this._searchTagsSecondary = param1;
      }
      
      public function set inventory(param1:IInventory) : void
      {
         if(this._inventory == param1)
         {
            return;
         }
         this._inventory = param1;
      }
      
      public function hasAnyRentalItems() : Boolean
      {
         return this.championDelegate.hasAnyRentalItems(this.inventory.championRegistry);
      }
      
      public function findChampionById(param1:Number) : Champion
      {
         return InventoryUtils.findChampionById(param1,this.inventory.championRegistry);
      }
      
      public function updateInactiveSpells_internal() : void
      {
         var _loc2_:Spell = null;
         var _loc1_:ArrayCollection = this.inventory.gameModeToInactiveSpellIds[ClientSystemStatesNotification.ALL_GAME_MODES_DISABLED_SPELLS_KEY];
         if(!_loc1_)
         {
            return;
         }
         for each(_loc2_ in this.inventory.spellDictionary)
         {
            if(_loc1_.contains(_loc2_.spellId))
            {
               _loc2_.active = false;
            }
         }
         dispatchEvent(new InventoryEvent(InventoryEvent.SPELL_DICTIONARY_CHANGED));
      }
      
      public function displayAlertForFulfillment(param1:InventoryEvent) : void
      {
         ChromeContextAlertProviderProxy.instance.showAlertForParameters(param1.info as AlertParameters);
      }
      
      public function findGameItemDefinitionbyId(param1:Number) : GameItem
      {
         return this.inventory.gameItemData[param1];
      }
      
      public function getRuneCount(param1:int) : uint
      {
         var _loc3_:SummonerRune = null;
         if(param1 <= 0 || param1 > 3 || !this.inventory.summonerRuneInventory)
         {
            return 0;
         }
         var _loc2_:uint = 0;
         for each(_loc3_ in this.inventory.summonerRuneInventory.summonerRunes)
         {
            if(Boolean(_loc3_.rune) && _loc3_.rune.tier >= param1)
            {
               _loc2_++;
            }
         }
         return _loc2_;
      }
      
      public function processAccountBalanceNotification(param1:StoreAccountBalanceNotification) : void
      {
         this.overWriteLoginAccountBalance = true;
         this.fullfillmentDelegate.processAccountBalanceNotification(param1);
      }
      
      public function updateChampionsRoster(param1:ArrayCollection, param2:ArrayCollection, param3:ArrayCollection, param4:Number) : void
      {
         this.inventory.inactiveChampionIdList = param1;
         if(param2)
         {
            this.inventory.freeToPlayChampionIds = param2;
         }
         if(param3)
         {
            this.inventory.freeToPlayChampionForNewPlayersIds = param3;
         }
         if(param4)
         {
            this.inventory.freeToPlayChampionForNewPlayerMaxLevel = param4;
         }
         this.refreshChampionsRoster(this.getSummonerLevelFromSession());
      }
      
      public function setBalanceFromLoginPacket(param1:Number, param2:Number) : void
      {
         if(!this.overWriteLoginAccountBalance)
         {
            this.inventory.lastIpPoints = this.inventory.influencePoints = param1;
            this.inventory.riotPoints = param2;
         }
      }
      
      public function getChampionById(param1:int) : Champion
      {
         var _loc4_:Champion = null;
         var _loc2_:ArrayCollection = this.inventory.champions;
         var _loc3_:Array = _loc2_.source;
         for each(_loc4_ in _loc3_)
         {
            if(_loc4_.championId == param1)
            {
               return _loc4_;
            }
         }
         return null;
      }
      
      private function createSearchTagArray(param1:Array) : Array
      {
         var _loc3_:String = null;
         var _loc4_:SearchTagData = null;
         var _loc2_:Array = new Array();
         for each(_loc3_ in param1)
         {
            _loc4_ = new SearchTagData(_loc3_,ResourceManager.getInstance().getString("champion_search_tag_resources","champion_search_tag_" + _loc3_));
            _loc2_.push(_loc4_);
         }
         _loc2_.sortOn("searchTagDisplayName");
         _loc4_ = new SearchTagData("all",ResourceManager.getInstance().getString("resources","championFilter_owned_all"),true);
         _loc2_.unshift(_loc4_);
         return _loc2_;
      }
      
      public function getAvailableChampionCount(param1:Boolean) : int
      {
         return this.championDelegate.getAvailableChampionCount(this.inventory.championRegistry,param1);
      }
      
      public function updateSpellDictionary(param1:Dictionary) : void
      {
         this.inventory.gameModeToInactiveSpellIds = param1;
         this.updateInactiveSpells_internal();
      }
      
      public function createSecondarySearchTags() : Array
      {
         return this.createSearchTagArray(this._searchTagsSecondary);
      }
      
      public function processStoreFulfillmentNotification(param1:StoreFulfillmentNotification) : void
      {
         this.fullfillmentDelegate.processStoreFulfillmentNotification(param1);
      }
      
      public function checkDisabledSkins() : void
      {
         var disabledSkinsResult:Array = null;
         var id:int = 0;
         var disabledSkinId:int = 0;
         var champID:int = 0;
         var skinIndex:int = 0;
         var configModel:ConfigurationModel = DynamicClientConfigManager.getConfiguration(DISABLED_SKIN_NAMESPACE,DISABLED_SKIN_KEY,[],this.checkDisabledSkins);
         if(configModel != null)
         {
            try
            {
               disabledSkinsResult = jsonDecode(configModel.getString()) as Array;
            }
            catch(error:Error)
            {
               logger.error("Garbled dynamic configuration for disabled skins for game: " + error.toString());
            }
            for each(id in this.disabledChampionSkinIds)
            {
               if(this._inventory.skinSkinIdMapping[id] != null)
               {
                  this._inventory.skinSkinIdMapping[id].skinDisabled = false;
               }
            }
            this.disabledChampionSkinIds.length = 0;
            if(disabledSkinsResult != null && disabledSkinsResult.length > 0)
            {
               for each(disabledSkinId in disabledSkinsResult)
               {
                  champID = disabledSkinId / 1000;
                  skinIndex = disabledSkinId - champID;
                  if(skinIndex > 0)
                  {
                     if(this._inventory.skinSkinIdMapping[disabledSkinId] != null)
                     {
                        this._inventory.skinSkinIdMapping[disabledSkinId].skinDisabled = true;
                        this.disabledChampionSkinIds.push(disabledSkinId);
                     }
                  }
               }
            }
         }
      }
      
      private function getSummonerLevelFromSession() : Number
      {
         var _loc2_:* = undefined;
         var _loc1_:* = Session.instance;
         if(_loc1_ != null)
         {
            _loc2_ = _loc1_.summonerLevel;
            if(_loc2_ != null)
            {
               return _loc2_.summonerLevel;
            }
         }
         return 1;
      }
      
      public function get inventory() : IInventory
      {
         return this._inventory;
      }
      
      public function getSpellById(param1:int) : Spell
      {
         var _loc2_:Spell = null;
         for each(_loc2_ in this._inventory.spellDictionary)
         {
            if(_loc2_.spellId == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function processRawFulfillment(param1:Object) : void
      {
         this.fullfillmentDelegate.processRawFulfillment(param1);
      }
      
      public function getActiveSpells() : ArrayCollection
      {
         var _loc2_:Spell = null;
         var _loc1_:ArrayCollection = new ArrayCollection();
         for each(_loc2_ in this.inventory.spellDictionary)
         {
            if(_loc2_.active)
            {
               _loc1_.addItem(_loc2_);
            }
         }
         return _loc1_;
      }
      
      private function onRetrieveAvailableChampionsSuccess(param1:ResultEvent) : void
      {
         var _loc2_:ArrayCollection = param1.result as ArrayCollection;
         this.championDelegate.createChampionRegistry(_loc2_);
         this.refreshChampionsRoster(this.getSummonerLevelFromSession());
         this.checkDisabledSkins();
         dispatchEvent(new InventoryEvent(InventoryEvent.CHAMPIONS_RETRIEVED));
      }
      
      public function isSpellDisabledForMode(param1:int, param2:String) : Boolean
      {
         if(Boolean(this.inventory.gameModeToInactiveSpellIds[param2]) && Boolean(this.inventory.gameModeToInactiveSpellIds[param2].contains(param1)))
         {
            return true;
         }
         return false;
      }
      
      public function updateChampionSkins(param1:ArrayCollection) : void
      {
         if(!this.inventory.championRegistry)
         {
            return;
         }
         this.championDelegate.updateUnobtainableChampionSkins(param1);
      }
      
      public function createChampionFilter(param1:Array) : IChampionFilter
      {
         return ChampionFilterConfig.isCollatorFilterEnabled() ? new CollatorChampionFilter(param1) : new ChampionFilter(param1);
      }
      
      public function refreshChampionsRoster(param1:Number) : void
      {
         if(Boolean(this.inventory.championIdMapping) && Boolean(this.inventory.getFreeToPlayChampionIdsForLevel(param1)))
         {
            this.championDelegate.resetChampions();
            this.championDelegate.setFreeToPlayChampions(param1);
            this.championDelegate.resetChampionActiveStates();
            this.championDelegate.setInactiveChampions();
            dispatchEvent(new InventoryEvent(InventoryEvent.CHAMPIONS_CHANGED));
         }
      }
      
      public function getSkinById(param1:Number, param2:Champion) : ChampionSkin
      {
         var _loc3_:Champion = null;
         var _loc4_:ArrayCollection = null;
         var _loc5_:Array = null;
         var _loc6_:ChampionSkin = null;
         if(!param2)
         {
            return null;
         }
         if(param1 == 0)
         {
            return param2.defaultSkin;
         }
         _loc4_ = param2.championSkins;
         _loc5_ = _loc4_.source;
         for each(_loc6_ in _loc5_)
         {
            if(_loc6_.skinId == param1)
            {
               return _loc6_;
            }
         }
         return null;
      }
   }
}

