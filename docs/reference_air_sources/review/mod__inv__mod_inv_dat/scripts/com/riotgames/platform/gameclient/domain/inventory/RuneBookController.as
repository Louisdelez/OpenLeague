package com.riotgames.platform.gameclient.domain.inventory
{
   import com.riotgames.platform.common.error.ServerError;
   import com.riotgames.platform.common.provider.IRuneBookController;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.common.utils.MessageDictionary;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.domain.ItemEffect;
   import com.riotgames.platform.gameclient.domain.Rune;
   import com.riotgames.platform.gameclient.domain.RuneCategories;
   import com.riotgames.platform.gameclient.domain.RuneQuantity;
   import com.riotgames.platform.gameclient.domain.RuneSlot;
   import com.riotgames.platform.gameclient.domain.RuneType;
   import com.riotgames.platform.gameclient.domain.SlotEntry;
   import com.riotgames.platform.gameclient.domain.SpellBookDTO;
   import com.riotgames.platform.gameclient.domain.SpellBookPageDTO;
   import com.riotgames.platform.gameclient.domain.Summoner;
   import com.riotgames.platform.gameclient.domain.SummonerRune;
   import com.riotgames.platform.gameclient.domain.SummonerRuneInventory;
   import com.riotgames.platform.gameclient.events.RuneBookEvent;
   import com.riotgames.platform.provider.IProvider;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.pvpnet.system.alerter.AlerterProviderProxy;
   import com.riotgames.pvpnet.system.alerter.IAlerterProvider;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.wordfilter.WordFilter;
   import flash.display.DisplayObject;
   import flash.events.EventDispatcher;
   import flash.utils.getQualifiedClassName;
   import mx.collections.ArrayCollection;
   import mx.collections.Sort;
   import mx.collections.SortField;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.events.PropertyChangeEvent;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.resources.ResourceManager;
   import mx.rpc.events.ResultEvent;
   import mx.utils.ObjectUtil;
   import mx.utils.StringUtil;
   
   public class RuneBookController extends EventDispatcher implements IRuneBookController, IProvider
   {
      
      private static const maxRunesPerFilter:uint = 200;
      
      private static const maxSanityCheckRunes:uint = 500;
      
      private static const maxRunePageNameLength:uint = 25;
      
      private var _tier1RunesFiltered:Boolean = true;
      
      private var yellowRuneFilteredCount:uint = 0;
      
      private var _hasUnsavedEdits:Boolean = false;
      
      private var proxiedErrorHandler:Function;
      
      private var _editing:Boolean = false;
      
      private var session:Session = Session.instance;
      
      private var _runeBook:SpellBookDTO;
      
      private var runeColorViewState:String = "redRunes";
      
      private var _summoner:Summoner;
      
      private var _combining:Boolean = false;
      
      private var serviceProxy:ServiceProxy = ServiceProxy.instance;
      
      private var _summonerLevel:Number;
      
      private var blueRuneFilteredCount:uint = 0;
      
      private var _categoryNames:ArrayCollection;
      
      private var _summonerRunesAwardedList:ArrayCollection = new ArrayCollection();
      
      private var _filteredYellowRunes:ArrayCollection;
      
      private var runeCombinerDelegate:RuneCombinerDelegate;
      
      private var _tier3RunesFiltered:Boolean = true;
      
      private var runeFilterFunction:Function = null;
      
      private var isInitialized:Boolean = false;
      
      private var _isBusy:Boolean;
      
      private var _filteredBlueRunes:ArrayCollection;
      
      private var redRuneFilteredCount:uint = 0;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var _tier2RunesFiltered:Boolean = true;
      
      private var _currentRuneBookPage:SpellBookPageDTO;
      
      private var _filteredBlackRunes:ArrayCollection;
      
      private var combinerCompleteCallback:Function;
      
      private var _inventory:Inventory;
      
      private var concurrentServiceRequestCount:int;
      
      private var blackRuneFilteredCount:uint = 0;
      
      private var _runesToCombine:ArrayCollection = new ArrayCollection();
      
      private var _runeCategorySelected:int = 0;
      
      private var _filteredRedRunes:ArrayCollection;
      
      public function RuneBookController(param1:Inventory)
      {
         super();
         this.inventory = param1;
      }
      
      private function updateRuneInventoryForNonUniqueSpellBook() : void
      {
         var _loc1_:SummonerRune = null;
         var _loc2_:SlotEntry = null;
         var _loc3_:Rune = null;
         if(this._currentRuneBookPage != null)
         {
            for each(_loc2_ in this._currentRuneBookPage.getEntries())
            {
               _loc3_ = _loc2_.getRune();
               if(_loc3_ != null)
               {
                  _loc1_ = this.inventory.summonerRuneInventory.findSummonerRune(_loc3_.itemId);
                  if(_loc1_)
                  {
                     _loc1_.currentAvailableQuantity = _loc1_.quantity - this._currentRuneBookPage.getSpecificRuneCount(_loc3_);
                     if(_loc1_.currentAvailableQuantity < 0)
                     {
                     }
                  }
               }
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set filteredBlueRunes(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this.filteredBlueRunes;
         if(_loc2_ !== param1)
         {
            this._2042951704filteredBlueRunes = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"filteredBlueRunes",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set tier2RunesFiltered(param1:Boolean) : void
      {
         var _loc2_:Object = this.tier2RunesFiltered;
         if(_loc2_ !== param1)
         {
            this._6092032tier2RunesFiltered = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"tier2RunesFiltered",_loc2_,param1));
         }
      }
      
      private function onPromptToSaveClose(param1:AlertAction) : void
      {
         var _loc2_:Function = param1.data as Function;
         if(param1.affirmativeResponse)
         {
            this.saveSpellBook();
            _loc2_();
         }
         else
         {
            this.undoRuneBookChanges();
            _loc2_();
         }
      }
      
      private function set _499466593tier3RunesFiltered(param1:Boolean) : void
      {
         if(this._tier3RunesFiltered == param1)
         {
            return;
         }
         this._tier3RunesFiltered = param1;
         this.refreshFilteredRuneInventory();
      }
      
      [Bindable(event="propertyChange")]
      public function set runeCategorySelected(param1:int) : void
      {
         var _loc2_:Object = this.runeCategorySelected;
         if(_loc2_ !== param1)
         {
            this._977969901runeCategorySelected = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"runeCategorySelected",_loc2_,param1));
         }
      }
      
      public function refreshRuneInventory(param1:Function = null) : void
      {
         this.internalRefreshRuneInventory(this.session.summoner.sumId,this.onRuneBookInventoryRetrieved,this.onServiceRequestComplete,param1);
      }
      
      private function updateRuneInventoryForUniqueSpellBook() : void
      {
         var _loc1_:SummonerRune = null;
         var _loc2_:SpellBookPageDTO = null;
         var _loc3_:SlotEntry = null;
         var _loc4_:Rune = null;
         for each(_loc2_ in this.runeBook.bookPages)
         {
            for each(_loc3_ in _loc2_.getEntries())
            {
               _loc4_ = _loc3_.getRune();
               if(_loc4_ != null)
               {
                  _loc1_ = this.inventory.summonerRuneInventory.findSummonerRune(_loc4_.itemId);
                  if(_loc1_)
                  {
                     --_loc1_.currentAvailableQuantity;
                  }
               }
            }
         }
      }
      
      private function onServiceRequestComplete(param1:Boolean) : void
      {
         --this.concurrentServiceRequestCount;
         if(this.concurrentServiceRequestCount <= 0)
         {
            this.concurrentServiceRequestCount = 0;
            this.isBusy = false;
         }
      }
      
      private function onLocalRuneBookRetrieved(param1:ResultEvent) : void
      {
         var _loc2_:SpellBookDTO = param1.result as SpellBookDTO;
         this.initNewRuneBook(_loc2_);
         this.inventory.runeBook = _loc2_;
         this.runeBook = _loc2_;
         this.hasUnsavedEdits = false;
         dispatchEvent(new RuneBookEvent(RuneBookEvent.LOCAL_RUNE_BOOK_RETRIEVED));
      }
      
      public function get combining() : Boolean
      {
         return this._combining;
      }
      
      public function get isBusy() : Boolean
      {
         return this._isBusy;
      }
      
      private function refreshFilteredRuneInventory() : void
      {
         if(this.filteredRedRunes == null)
         {
            return;
         }
         if(this.serviceProxy)
         {
            this.serviceProxy.maestroService.disableHeartbeatCheck();
         }
         this.redRuneFilteredCount = 0;
         this.blueRuneFilteredCount = 0;
         this.yellowRuneFilteredCount = 0;
         this.blackRuneFilteredCount = 0;
         this.updateRuneInventoryCount();
         this.filteredRedRunes.refresh();
         this.filteredYellowRunes.refresh();
         this.filteredBlueRunes.refresh();
         this.filteredBlackRunes.refresh();
         if(this.serviceProxy)
         {
            this.serviceProxy.maestroService.enableHeartbeatCheck();
         }
      }
      
      private function removeQuantityZeroRune(param1:SummonerRune, param2:Boolean) : void
      {
         var _loc4_:Boolean = false;
         RuneBookUtils.removeRuneFromList(this.inventory.summonerRuneInventory.summonerRunes,param1);
         var _loc3_:ArrayCollection = this.getFilteredRuneInventoryByType(param1.rune.runeType.runeTypeId);
         if(_loc3_)
         {
            _loc4_ = Boolean(RuneBookUtils.removeRuneFromList(_loc3_,param1));
            if((_loc4_) && param2)
            {
               this.refreshSingleFilteredRunes(param1.rune.runeType.runeTypeId);
            }
         }
      }
      
      private function synchronizeSummonerRunes(param1:SpellBookPageDTO) : void
      {
         var _loc2_:SlotEntry = null;
         var _loc3_:SummonerRune = null;
         if(this.inventory.summonerRuneInventory == null || !(this.editing || this.combining))
         {
            return;
         }
         if(param1.getEntries() == null)
         {
            param1.setEntries(new ArrayCollection());
         }
         for each(_loc2_ in param1.getEntries())
         {
            if(_loc2_.getRune() == null)
            {
               this.logger.error("RuneBookController.synchronizeSummonerRunes: SlotEntry not found in inventory on page " + param1.name);
            }
            else
            {
               _loc3_ = this.getSummonerRuneFromInventory(_loc2_.runeId);
               if(_loc3_ == null)
               {
                  this.logger.error("RuneBookController.synchronizeSummonerRunes: Slot Entry not found in inventory on page " + param1.name);
                  throw new Error("SummonerRune on page was not found in the inventory!");
               }
               _loc2_.setRune(_loc3_.rune);
            }
         }
      }
      
      private function refreshSingleFilteredRunes(param1:int) : void
      {
         var _loc2_:ArrayCollection = this.getFilteredRuneInventoryByType(param1);
         if(_loc2_)
         {
            this.redRuneFilteredCount = 0;
            this.blueRuneFilteredCount = 0;
            this.yellowRuneFilteredCount = 0;
            this.blackRuneFilteredCount = 0;
            _loc2_.refresh();
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set filteredBlackRunes(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this.filteredBlackRunes;
         if(_loc2_ !== param1)
         {
            this._494846671filteredBlackRunes = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"filteredBlackRunes",_loc2_,param1));
         }
      }
      
      private function getFilterFunction() : Function
      {
         if(this.editing)
         {
            return this.filterInventoryForEdit;
         }
         if(this.combining)
         {
            return this.filterInventoryForRuneCombiner;
         }
         return null;
      }
      
      private function filterByTier(param1:SummonerRune) : Boolean
      {
         switch(param1.rune.tier)
         {
            case 1:
               return this.tier1RunesFiltered;
            case 2:
               return this.tier2RunesFiltered;
            case 3:
               return this.tier3RunesFiltered;
            default:
               return false;
         }
      }
      
      private function filterInventoryForRuneCombiner(param1:SummonerRune) : Boolean
      {
         var _loc3_:Rune = null;
         var _loc2_:Boolean = true;
         if(this.runesToCombine.length > 0)
         {
            _loc3_ = this.runesToCombine.getItemAt(0) as Rune;
            _loc2_ &&= param1.rune.tier == _loc3_.tier;
         }
         return _loc2_ && param1.currentAvailableQuantity > 0;
      }
      
      public function deactivate() : void
      {
         this.isBusy = false;
         this.proxiedErrorHandler = null;
         this.concurrentServiceRequestCount = 0;
         this.runesToCombine.removeAll();
      }
      
      public function set combining(param1:Boolean) : void
      {
         if(this._combining == param1)
         {
            return;
         }
         this._combining = param1;
         if(!this.combining)
         {
            this.runesToCombine.removeAll();
            this.runeCombinerDelegate = null;
         }
         if(this.combining)
         {
            this.runeFilterFunction = this.filterInventoryForRuneCombiner;
         }
         else if(!this.editing)
         {
            this.runeFilterFunction = null;
         }
         dispatchEvent(new RuneBookEvent(RuneBookEvent.RUNE_BOOK_STATE_CHANGED,this.editing,this.combining));
      }
      
      public function combineRunes(param1:ArrayCollection, param2:Function, param3:Object = null) : void
      {
         var _loc4_:IAlerterProvider = null;
         if(Boolean(this.runeCombinerDelegate) && this.runeCombinerDelegate.isBusy)
         {
            return;
         }
         this.runeCombinerDelegate = param3 as RuneCombinerDelegate;
         this.combinerCompleteCallback = param2;
         if(!this.runeCombinerDelegate)
         {
            _loc4_ = AlerterProviderProxy.instance;
            this.runeCombinerDelegate = new RuneCombinerDelegate(this.serviceProxy.inventoryService,_loc4_,this.onCombinerFailed);
            this.runeCombinerDelegate.getAllRuneCombiners();
         }
         this.runeCombinerDelegate.combineRunes(param1,this.onCombinerComplete,this.onCombinerFailed);
      }
      
      public function get hasUnsavedEdits() : Boolean
      {
         return this._hasUnsavedEdits;
      }
      
      public function removeRunesFromInventory(param1:Array, param2:Boolean = true) : void
      {
         var _loc3_:Rune = null;
         var _loc4_:SummonerRune = null;
         if(param1 == null)
         {
            return;
         }
         for each(_loc3_ in param1)
         {
            _loc4_ = this.getSummonerRuneFromInventory(_loc3_.itemId);
            --_loc4_.quantity;
            --_loc4_.currentAvailableQuantity;
            if(_loc4_.quantity <= 0)
            {
               this.removeQuantityZeroRune(_loc4_,param2);
            }
         }
      }
      
      private function set _1895525985filteredRedRunes(param1:ArrayCollection) : void
      {
         if(this._filteredRedRunes == param1)
         {
            return;
         }
         this._filteredRedRunes = param1;
      }
      
      private function applyFilterToFilteredRunes(param1:ArrayCollection, param2:ArrayCollection, param3:ArrayCollection, param4:ArrayCollection) : void
      {
         param3.filterFunction = this.filterForBlueRunes;
         param1.filterFunction = this.filterForRedRunes;
         param2.filterFunction = this.filterForYellowRunes;
         param4.filterFunction = this.filterForBlackRunes;
      }
      
      private function internalRefreshRuneInventory(param1:Number, param2:Function, param3:Function, param4:Function) : void
      {
         this.isBusy = true;
         this.filteredRedRunes = null;
         this.filteredBlueRunes = null;
         this.filteredYellowRunes = null;
         this.filteredBlackRunes = null;
         this.proxiedErrorHandler = param4;
         ++this.concurrentServiceRequestCount;
         this.serviceProxy.summonerRuneService.getSummonerRuneInventory(param1,param2,param3,param4);
      }
      
      [Bindable(event="propertyChange")]
      public function set isBusy(param1:Boolean) : void
      {
         var _loc2_:Object = this.isBusy;
         if(_loc2_ !== param1)
         {
            this._1180619197isBusy = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isBusy",_loc2_,param1));
         }
      }
      
      public function addRuneToCombiner(param1:Rune) : void
      {
         var _loc2_:SummonerRune = null;
         this.runesToCombine.addItem(param1);
         _loc2_ = this.inventory.summonerRuneInventory.findSummonerRune(param1.itemId);
         if(_loc2_)
         {
            --_loc2_.currentAvailableQuantity;
         }
         if(this.runesToCombine.length == 1)
         {
            this.refreshFilteredRuneInventory();
         }
         else if(Boolean(param1) && Boolean(param1.runeType))
         {
            this.refreshSingleFilteredRunes(param1.runeType.runeTypeId);
         }
      }
      
      public function get currentRuneBookPage() : SpellBookPageDTO
      {
         return this._currentRuneBookPage;
      }
      
      private function compareRunesByTier(param1:Object, param2:Object, param3:Array = null) : int
      {
         var _loc7_:int = 0;
         var _loc8_:int = 0;
         var _loc4_:SummonerRune = param1 as SummonerRune;
         var _loc5_:SummonerRune = param2 as SummonerRune;
         if(_loc4_.rune == null || _loc5_.rune == null)
         {
            return 0;
         }
         var _loc6_:int = int(ObjectUtil.numericCompare(_loc4_.rune.tier,_loc5_.rune.tier));
         if(_loc6_ == 0)
         {
            _loc7_ = -1;
            _loc8_ = -1;
            _loc6_ = int(ObjectUtil.numericCompare(_loc7_,_loc8_));
            if(_loc6_ == 0)
            {
               if(_loc4_.rune.displayName != _loc5_.rune.displayName)
               {
                  _loc6_ = _loc4_.rune.displayName < _loc5_.rune.displayName ? -1 : 1;
               }
               else
               {
                  _loc6_ = int(ObjectUtil.numericCompare(_loc4_.quantity,_loc5_.quantity));
               }
            }
         }
         return _loc6_;
      }
      
      private function resetRuneInventoryCount() : void
      {
         var _loc1_:SummonerRune = null;
         if(this.inventory.summonerRuneInventory)
         {
            for each(_loc1_ in this.inventory.summonerRuneInventory.summonerRunes)
            {
               _loc1_.currentAvailableQuantity = _loc1_.quantity;
            }
         }
      }
      
      public function hydrateSpellBook(param1:SpellBookDTO) : void
      {
         var _loc2_:SpellBookPageDTO = null;
         var _loc3_:SlotEntry = null;
         if(!param1)
         {
            return;
         }
         for each(_loc2_ in param1.bookPages)
         {
            for each(_loc3_ in _loc2_.getEntries())
            {
               _loc3_.setRune(InventoryUtils.makeHydratedRune(_loc3_.runeId,this.inventory.runeDictionary));
               _loc3_.setRuneSlot(this.getRuneSlotById(_loc3_.runeSlotId));
            }
         }
      }
      
      public function get tier3RunesFiltered() : Boolean
      {
         return this._tier3RunesFiltered;
      }
      
      [Bindable(event="propertyChange")]
      public function set runeBook(param1:SpellBookDTO) : void
      {
         var _loc2_:Object = this.runeBook;
         if(_loc2_ !== param1)
         {
            this._820189507runeBook = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"runeBook",_loc2_,param1));
         }
      }
      
      public function undoRuneBookChanges() : void
      {
         var _loc1_:Boolean = this.summoner.acctId == this.session.summoner.acctId;
         if(_loc1_)
         {
            this.getLocalRunebook();
         }
         else
         {
            this.getRuneBook(null);
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set summoner(param1:Summoner) : void
      {
         var _loc2_:Object = this.summoner;
         if(_loc2_ !== param1)
         {
            this._1751869106summoner = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summoner",_loc2_,param1));
         }
      }
      
      private function set _322607338categoryNames(param1:ArrayCollection) : void
      {
         if(this._categoryNames == param1)
         {
            return;
         }
         this._categoryNames = param1;
      }
      
      public function set inventory(param1:Inventory) : void
      {
         if(this._inventory == param1)
         {
            return;
         }
         this._inventory = param1;
      }
      
      private function getRuneBook(param1:Function) : void
      {
         this.proxiedErrorHandler = param1;
         this.isBusy = true;
         ++this.concurrentServiceRequestCount;
         this.serviceProxy.spellBookService.getSpellBook(this.summoner.sumId,this.onRuneBookRetrieved,this.onServiceRequestComplete,this.onServiceRequestError);
      }
      
      private function set _511650657tier1RunesFiltered(param1:Boolean) : void
      {
         if(this._tier1RunesFiltered == param1)
         {
            return;
         }
         this._tier1RunesFiltered = param1;
         this.refreshFilteredRuneInventory();
      }
      
      [Bindable(event="propertyChange")]
      public function set tier1RunesFiltered(param1:Boolean) : void
      {
         var _loc2_:Object = this.tier1RunesFiltered;
         if(_loc2_ !== param1)
         {
            this._511650657tier1RunesFiltered = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"tier1RunesFiltered",_loc2_,param1));
         }
      }
      
      private function updateRuneCombiningCount() : void
      {
         var _loc1_:SummonerRune = null;
         var _loc2_:Rune = null;
         for each(_loc2_ in this.runesToCombine)
         {
            _loc1_ = this.inventory.summonerRuneInventory.findSummonerRune(_loc2_.itemId);
            if(_loc1_)
            {
               --_loc1_.currentAvailableQuantity;
            }
         }
      }
      
      private function getRuneSlotById(param1:int) : RuneSlot
      {
         var _loc3_:RuneSlot = null;
         var _loc2_:ArrayCollection = this.session.summonerCatalog.spellBookConfig;
         for each(_loc3_ in _loc2_)
         {
            if(_loc3_.id == param1)
            {
               return _loc3_;
            }
         }
         return null;
      }
      
      private function filterForBlackRunes(param1:Object) : Boolean
      {
         if(this.runeColorViewState != RuneColors.RUNE_COLOR_BLACK_VIEW)
         {
            return false;
         }
         if(this.blackRuneFilteredCount >= RuneBookController.maxRunesPerFilter)
         {
            return false;
         }
         var _loc2_:SummonerRune = param1 as SummonerRune;
         var _loc3_:Boolean = this.filterRunesIgnoreType(_loc2_);
         if(_loc3_)
         {
            ++this.blackRuneFilteredCount;
         }
         return _loc3_;
      }
      
      private function set _2042951704filteredBlueRunes(param1:ArrayCollection) : void
      {
         if(this._filteredBlueRunes == param1)
         {
            return;
         }
         this._filteredBlueRunes = param1;
      }
      
      private function synchronizeRuneBookPages(param1:SpellBookDTO) : void
      {
         var _loc2_:SpellBookPageDTO = null;
         if(!param1)
         {
            return;
         }
         for each(_loc2_ in param1.bookPages)
         {
            this.quitWatchingPage(_loc2_);
            this.synchronizeSummonerRunes(_loc2_);
            this.startWatchingPage(_loc2_);
         }
         this.refreshFilteredRuneInventory();
      }
      
      private function internalGetLocalRunebook(param1:Number, param2:Function, param3:Function, param4:Function) : void
      {
         this.isBusy = true;
         ++this.concurrentServiceRequestCount;
         this.serviceProxy.spellBookService.getSpellBook(param1,param2,param3,param4);
      }
      
      private function set _977969901runeCategorySelected(param1:int) : void
      {
         if(this._runeCategorySelected == param1)
         {
            return;
         }
         this._runeCategorySelected = param1;
         this.refreshFilteredRuneInventory();
      }
      
      private function set _1545882922summonerLevel(param1:Number) : void
      {
         if(this._summonerLevel == param1)
         {
            return;
         }
         this._summonerLevel = param1;
         dispatchEvent(new RuneBookEvent(RuneBookEvent.SUMMONER_LEVEL_CHANGED));
      }
      
      private function set _1180619197isBusy(param1:Boolean) : void
      {
         if(this._isBusy == param1)
         {
            return;
         }
         this._isBusy = param1;
         dispatchEvent(new RuneBookEvent(RuneBookEvent.IS_BUSY_CHANGED,this.editing,this.combining));
      }
      
      public function validateSpellBookName(param1:String) : String
      {
         var _loc4_:SpellBookPageDTO = null;
         param1 = StringUtil.trim(param1).toLowerCase();
         var _loc2_:String = null;
         if(param1.length == 0)
         {
            return ResourceManager.getInstance().getString("resources","validator_requiredErrorMessage");
         }
         if(param1.length > maxRunePageNameLength)
         {
            _loc2_ = ResourceManager.getInstance().getString("resources","validator_containsTokenErrorMessage");
         }
         if(param1.indexOf(RuneBookUtils.PAGE_NAME_TOKEN.toLowerCase()) >= 0)
         {
            return ResourceManager.getInstance().getString("resources","validator_containsTokenErrorMessage");
         }
         var _loc3_:WordFilter = WordFilter.instance;
         if(Boolean(_loc3_) && Boolean(_loc3_.containsOffensiveWords(param1,false)))
         {
            return ResourceManager.getInstance().getString("resources",MessageDictionary.PAGE_NAME_CONTAINS_OFFENSIVE_WORDS);
         }
         for each(_loc4_ in this.runeBook.bookPages)
         {
            if(_loc4_ != this.currentRuneBookPage)
            {
               if(_loc4_.name.toLocaleLowerCase() == param1)
               {
                  _loc2_ = ResourceManager.getInstance().getString("resources","validator_SpellBookNameMustBeUnique");
               }
            }
         }
         return _loc2_;
      }
      
      public function set hasUnsavedEdits(param1:Boolean) : void
      {
         if(this._hasUnsavedEdits == param1)
         {
            return;
         }
         this._hasUnsavedEdits = param1;
         dispatchEvent(new RuneBookEvent(RuneBookEvent.HAS_UNSAVED_EDITS_CHANGED));
      }
      
      private function filterRunesIgnoreType(param1:SummonerRune) : Boolean
      {
         var _loc2_:Boolean = true;
         if(this.runeFilterFunction != null)
         {
            _loc2_ = this.runeFilterFunction(param1);
         }
         _loc2_ &&= this.filterByTier(param1);
         return _loc2_ && this.filterByRuneCategory(param1);
      }
      
      private function refreshRuneInventoryCollections() : void
      {
         if(!this.inventory.summonerRuneInventory.summonerRunes)
         {
            return;
         }
         if(this.runeBook != null)
         {
            this.synchronizeRuneBookPages(this.runeBook);
         }
      }
      
      private function onCombinerFailed() : void
      {
         this.summonerRunesAwardedList = null;
         this.refreshRuneInventory();
         this.combinerCompleteCallback(false);
      }
      
      public function get summonerLevel() : Number
      {
         return this._summonerLevel;
      }
      
      public function get categoryNames() : ArrayCollection
      {
         return this._categoryNames;
      }
      
      public function get tier2RunesFiltered() : Boolean
      {
         return this._tier2RunesFiltered;
      }
      
      public function runesAwarded(param1:ArrayCollection) : ArrayCollection
      {
         var _loc2_:Array = this.runesToCombine.toArray();
         this.runesToCombine.removeAll();
         var _loc3_:ArrayCollection = this.addRunesToInventory(param1.toArray(),false);
         this.refreshFilteredRuneInventory();
         this.removeRunesFromInventory(_loc2_,false);
         return _loc3_;
      }
      
      private function set _820189507runeBook(param1:SpellBookDTO) : void
      {
         if(this._runeBook == param1)
         {
            return;
         }
         this.removeRuneBook();
         this._runeBook = param1;
         this.setRuneBook();
         dispatchEvent(new RuneBookEvent(RuneBookEvent.RUNE_BOOK_CHANGED));
      }
      
      private function updateRuneInventoryForCombining() : void
      {
         var _loc1_:SummonerRune = null;
         var _loc2_:SpellBookPageDTO = null;
         var _loc3_:SlotEntry = null;
         var _loc4_:Rune = null;
         var _loc5_:int = 0;
         for each(_loc2_ in this.runeBook.bookPages)
         {
            for each(_loc3_ in _loc2_.getEntries())
            {
               _loc4_ = _loc3_.getRune();
               if(_loc4_ != null)
               {
                  _loc1_ = this.inventory.summonerRuneInventory.findSummonerRune(_loc4_.itemId);
                  if(_loc1_)
                  {
                     _loc5_ = _loc1_.quantity - _loc2_.getSpecificRuneCount(_loc4_);
                     if(_loc5_ < _loc1_.currentAvailableQuantity)
                     {
                        _loc1_.currentAvailableQuantity = _loc5_;
                        if(_loc1_.currentAvailableQuantity < 0)
                        {
                        }
                     }
                  }
               }
            }
         }
      }
      
      public function get runeCategorySelected() : int
      {
         return this._runeCategorySelected;
      }
      
      private function filterForBlueRunes(param1:Object) : Boolean
      {
         if(this.runeColorViewState != RuneColors.RUNE_COLOR_BLUE_VIEW)
         {
            return false;
         }
         if(this.blueRuneFilteredCount >= RuneBookController.maxRunesPerFilter)
         {
            return false;
         }
         var _loc2_:SummonerRune = param1 as SummonerRune;
         var _loc3_:Boolean = this.filterRunesIgnoreType(_loc2_);
         if(_loc3_)
         {
            ++this.blueRuneFilteredCount;
         }
         return _loc3_;
      }
      
      public function set currentRuneBookPage(param1:SpellBookPageDTO) : void
      {
         if(this._currentRuneBookPage != param1)
         {
            this._currentRuneBookPage = param1;
            this.refreshFilteredRuneInventory();
         }
      }
      
      private function filterInventoryForEdit(param1:SummonerRune) : Boolean
      {
         var _loc2_:Boolean = false;
         return param1.currentAvailableQuantity > 0;
      }
      
      private function setFilteredRuneInventory(param1:Array) : void
      {
         var _loc2_:Array = this.getCappedInventory(param1);
         var _loc3_:ArrayCollection = new ArrayCollection();
         var _loc4_:ArrayCollection = new ArrayCollection();
         var _loc5_:ArrayCollection = new ArrayCollection();
         var _loc6_:ArrayCollection = new ArrayCollection();
         this.populateFilteredRunes(_loc2_,_loc3_,_loc4_,_loc5_,_loc6_);
         var _loc7_:Sort = this.getRuneSort();
         this.sortFilteredRunes(_loc7_,_loc3_,_loc4_,_loc5_,_loc6_);
         this.runeFilterFunction = this.getFilterFunction();
         this.applyFilterToFilteredRunes(_loc3_,_loc4_,_loc5_,_loc6_);
         if(Boolean(this.serviceProxy) && Boolean(this.serviceProxy.maestroService))
         {
            this.serviceProxy.maestroService.disableHeartbeatCheck();
         }
         this.setFilteredRunes(_loc3_,_loc4_,_loc5_,_loc6_);
         if(Boolean(this.serviceProxy) && Boolean(this.serviceProxy.maestroService))
         {
            this.serviceProxy.maestroService.enableHeartbeatCheck();
         }
      }
      
      public function get standardSpellBookPageConfiguration() : ArrayCollection
      {
         var _loc1_:ArrayCollection = new ArrayCollection(this.session.summonerCatalog.spellBookConfig.source);
         var _loc2_:Sort = new Sort();
         _loc2_.fields = [new SortField("id",false,false)];
         _loc1_.sort = _loc2_;
         _loc1_.refresh();
         return _loc1_;
      }
      
      public function get filteredBlackRunes() : ArrayCollection
      {
         return this._filteredBlackRunes;
      }
      
      public function saveSpellBook() : void
      {
         this.internalSaveSpellBook(this._runeBook,this.onRuneBookSaved,this.onServiceRequestComplete,this.onServiceRequestError);
      }
      
      public function set editing(param1:Boolean) : void
      {
         if(this._editing == param1)
         {
            return;
         }
         this._editing = param1;
         if(this.editing)
         {
            this.runeFilterFunction = this.filterInventoryForEdit;
         }
         else if(!this.combining)
         {
            this.runeFilterFunction = null;
         }
         dispatchEvent(new RuneBookEvent(RuneBookEvent.RUNE_BOOK_STATE_CHANGED,this.editing,this.combining));
      }
      
      public function get runeBook() : SpellBookDTO
      {
         return this._runeBook;
      }
      
      private function getFilteredRuneInventoryByType(param1:int) : ArrayCollection
      {
         var _loc2_:ArrayCollection = null;
         switch(param1)
         {
            case RuneType.RED_RUNE:
               _loc2_ = this.filteredRedRunes;
               break;
            case RuneType.BLUE_RUNE:
               _loc2_ = this.filteredBlueRunes;
               break;
            case RuneType.YELLOW_RUNE:
               _loc2_ = this.filteredYellowRunes;
               break;
            case RuneType.BLACK_RUNE:
               _loc2_ = this.filteredBlackRunes;
         }
         return _loc2_;
      }
      
      public function get summoner() : Summoner
      {
         return this._summoner;
      }
      
      private function getSummonerRuneFromInventory(param1:int) : SummonerRune
      {
         var _loc2_:SummonerRune = null;
         var _loc3_:SummonerRune = null;
         for each(_loc3_ in this.inventory.summonerRuneInventory.summonerRunes)
         {
            if(_loc3_.rune.itemId == param1)
            {
               _loc2_ = _loc3_;
               break;
            }
         }
         return _loc2_;
      }
      
      [Bindable(event="propertyChange")]
      public function set tier3RunesFiltered(param1:Boolean) : void
      {
         var _loc2_:Object = this.tier3RunesFiltered;
         if(_loc2_ !== param1)
         {
            this._499466593tier3RunesFiltered = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"tier3RunesFiltered",_loc2_,param1));
         }
      }
      
      public function get inventory() : Inventory
      {
         return this._inventory;
      }
      
      [Bindable(event="propertyChange")]
      public function set summonerRunesAwardedList(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this.summonerRunesAwardedList;
         if(_loc2_ !== param1)
         {
            this._522669487summonerRunesAwardedList = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerRunesAwardedList",_loc2_,param1));
         }
      }
      
      private function setFilteredRunes(param1:ArrayCollection, param2:ArrayCollection, param3:ArrayCollection, param4:ArrayCollection) : void
      {
         this.redRuneFilteredCount = 0;
         this.blueRuneFilteredCount = 0;
         this.yellowRuneFilteredCount = 0;
         this.blackRuneFilteredCount = 0;
         param1.refresh();
         param2.refresh();
         param3.refresh();
         param4.refresh();
         this.filteredRedRunes = param1;
         this.filteredYellowRunes = param2;
         this.filteredBlueRunes = param3;
         this.filteredBlackRunes = param4;
      }
      
      public function get tier1RunesFiltered() : Boolean
      {
         return this._tier1RunesFiltered;
      }
      
      private function onSpellBookPageRunesChanged(param1:CollectionEvent) : void
      {
         var _loc2_:Rune = null;
         if((Boolean(param1.kind == CollectionEventKind.ADD || param1.kind == CollectionEventKind.REMOVE)) && Boolean(param1.items) && param1.items.length == 1)
         {
            _loc2_ = param1.items[0].getRune();
            if(Boolean(_loc2_) && Boolean(_loc2_.runeType))
            {
               this.refreshSingleFilteredRunes(_loc2_.runeType.runeTypeId);
            }
         }
         else
         {
            this.refreshFilteredRuneInventory();
         }
      }
      
      private function startWatchingPage(param1:SpellBookPageDTO) : void
      {
         if(param1.getEntries() == null)
         {
            param1.setEntries(new ArrayCollection());
         }
         param1.getEntries().addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onSpellBookPageRunesChanged);
      }
      
      private function onRuneBookSaved(param1:ResultEvent) : void
      {
         this.hasUnsavedEdits = false;
         this.dispatchEvent(new RuneBookEvent(RuneBookEvent.RUNE_BOOK_SAVED));
      }
      
      private function onCombinerComplete(param1:ArrayCollection) : void
      {
         this.summonerRunesAwardedList = this.runesAwarded(param1);
         this.refreshRuneInventory();
         this.combinerCompleteCallback(true);
      }
      
      private function getRuneSort() : Sort
      {
         var _loc1_:Sort = new Sort();
         _loc1_.compareFunction = this.compareRunesByTier;
         return _loc1_;
      }
      
      private function filterForYellowRunes(param1:Object) : Boolean
      {
         if(this.runeColorViewState != RuneColors.RUNE_COLOR_YELLOW_VIEW)
         {
            return false;
         }
         if(this.yellowRuneFilteredCount >= RuneBookController.maxRunesPerFilter)
         {
            return false;
         }
         var _loc2_:SummonerRune = param1 as SummonerRune;
         var _loc3_:Boolean = this.filterRunesIgnoreType(_loc2_);
         if(_loc3_)
         {
            ++this.yellowRuneFilteredCount;
         }
         return _loc3_;
      }
      
      private function internalSaveSpellBook(param1:SpellBookDTO, param2:Function, param3:Function, param4:Function) : void
      {
         this.isBusy = true;
         this.proxiedErrorHandler = null;
         ++this.concurrentServiceRequestCount;
         this.serviceProxy.spellBookService.saveSpellBook(param1,param2,param3,param4);
      }
      
      public function promptToSaveBeforeExit(param1:DisplayObject, param2:Function) : void
      {
         var _loc3_:AlertAction = null;
         if(this.hasUnsavedEdits)
         {
            _loc3_ = new AlertAction(RiotResourceLoader.getString("runebook_book_unsavedChangesPromptTitle"),RiotResourceLoader.getString("runebook_book_unsavedChangesPrompt"));
            _loc3_.data = param2;
            _loc3_.showNegative = true;
            _loc3_.setYesNoLabels();
            _loc3_.getCompleted().addOnce(this.onPromptToSaveClose);
            _loc3_.add();
         }
         else if(param2 != null)
         {
            param2();
         }
      }
      
      private function set _522669487summonerRunesAwardedList(param1:ArrayCollection) : void
      {
         if(param1 == this._summonerRunesAwardedList)
         {
            return;
         }
         this._summonerRunesAwardedList = param1;
      }
      
      private function set _920522190filteredYellowRunes(param1:ArrayCollection) : void
      {
         if(this._filteredYellowRunes == param1)
         {
            return;
         }
         this._filteredYellowRunes = param1;
      }
      
      private function onRuneBookInventoryRetrieved(param1:ResultEvent) : void
      {
         if(param1.result != null)
         {
            this.inventory.summonerRuneInventory = param1.result as SummonerRuneInventory;
            if(this.inventory.summonerRuneInventory.summonerRunes != null)
            {
               RuneBookUtils.localizeSummonerRunes(this.inventory.summonerRuneInventory.summonerRunes.toArray());
               this.setFilteredRuneInventory(this.inventory.summonerRuneInventory.summonerRunes.source);
               this.refreshRuneInventoryCollections();
            }
         }
         dispatchEvent(new RuneBookEvent(RuneBookEvent.RUNE_INVENTORY_LOADED));
      }
      
      private function onAddedNewRuneBookPage(param1:ResultEvent) : void
      {
         var _loc2_:SpellBookPageDTO = param1.result as SpellBookPageDTO;
         this.runeBook.addPage(_loc2_);
         this.synchronizeSummonerRunes(_loc2_);
         this.startWatchingPage(_loc2_);
      }
      
      [Bindable(event="propertyChange")]
      public function set filteredRedRunes(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this.filteredRedRunes;
         if(_loc2_ !== param1)
         {
            this._1895525985filteredRedRunes = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"filteredRedRunes",_loc2_,param1));
         }
      }
      
      private function onRuneBookRetrieved(param1:ResultEvent) : void
      {
         var _loc2_:SpellBookDTO = param1.result as SpellBookDTO;
         this.initNewRuneBook(_loc2_);
         this.runeBook = _loc2_;
         dispatchEvent(new RuneBookEvent(RuneBookEvent.FOREIGN_RUNE_BOOK_RETRIEVED));
      }
      
      private function set _1751869106summoner(param1:Summoner) : void
      {
         if(this._summoner == param1)
         {
            return;
         }
         this._summoner = param1;
         this.setSummoner();
         dispatchEvent(new RuneBookEvent(RuneBookEvent.SUMMONER_CHANGED));
      }
      
      public function initialize() : void
      {
         var _loc2_:String = null;
         if(this.isInitialized)
         {
            return;
         }
         this.isInitialized = true;
         this.categoryNames = new ArrayCollection(RuneCategories.categoryNamesArray);
         var _loc1_:int = 0;
         while(_loc1_ < this.categoryNames.length)
         {
            _loc2_ = RuneCategories.categoryNamesArray[_loc1_];
            this.categoryNames[_loc1_] = ResourceManager.getInstance().getString("resources","runebook_runeCategory_" + _loc2_);
            if(this.categoryNames[_loc1_] == null)
            {
               this.categoryNames[_loc1_] = "**" + _loc2_;
            }
            _loc1_++;
         }
         dispatchEvent(new RuneBookEvent(RuneBookEvent.RUNE_BOOK_CONTROLLER_INITIALIZED));
      }
      
      public function setSummonerData(param1:Summoner, param2:Number) : void
      {
         this.summonerLevel = param2;
         this.summoner = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function set filteredYellowRunes(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this.filteredYellowRunes;
         if(_loc2_ !== param1)
         {
            this._920522190filteredYellowRunes = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"filteredYellowRunes",_loc2_,param1));
         }
      }
      
      public function updateRuneInventoryCount() : void
      {
         var _loc1_:ClientConfig = ClientConfig.instance;
         if(!_loc1_)
         {
            return;
         }
         var _loc2_:Boolean = false;
         if(this.inventory != null && this.inventory.summonerRuneInventory != null && this.inventory.summonerRuneInventory.summonerRunes != null)
         {
            this.inventory.summonerRuneInventory.summonerRunes.disableAutoUpdate();
            _loc2_ = true;
         }
         this.resetRuneInventoryCount();
         if(_loc1_.runeUniquePerSpellBook)
         {
            this.updateRuneInventoryForUniqueSpellBook();
            if(this.combining)
            {
               this.updateRuneCombiningCount();
            }
         }
         else if(this.combining)
         {
            this.updateRuneInventoryForCombining();
            this.updateRuneCombiningCount();
         }
         else
         {
            this.updateRuneInventoryForNonUniqueSpellBook();
         }
         if(_loc2_)
         {
            this.inventory.summonerRuneInventory.summonerRunes.enableAutoUpdate();
            this.inventory.summonerRuneInventory.summonerRunes.refresh();
         }
      }
      
      private function sortFilteredRunes(param1:Sort, param2:ArrayCollection, param3:ArrayCollection, param4:ArrayCollection, param5:ArrayCollection) : void
      {
         param4.sort = param1;
         param2.sort = param1;
         param3.sort = param1;
         param5.sort = param1;
      }
      
      public function get filteredRedRunes() : ArrayCollection
      {
         return this._filteredRedRunes;
      }
      
      public function get editing() : Boolean
      {
         return this._editing;
      }
      
      private function getCappedInventory(param1:Array) : Array
      {
         if(param1.length <= RuneBookController.maxSanityCheckRunes)
         {
            return param1;
         }
         return param1.slice(0,RuneBookController.maxSanityCheckRunes);
      }
      
      [Bindable(event="propertyChange")]
      public function set summonerLevel(param1:Number) : void
      {
         var _loc2_:Object = this.summonerLevel;
         if(_loc2_ !== param1)
         {
            this._1545882922summonerLevel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerLevel",_loc2_,param1));
         }
      }
      
      private function onDefaultRuneBookPageSelected(param1:ResultEvent) : void
      {
         var _loc2_:SpellBookPageDTO = param1.result as SpellBookPageDTO;
         var _loc3_:SpellBookPageDTO = this.runeBook.getPageWithId(_loc2_.pageId);
         this.runeBook.replacePage(_loc3_,_loc2_);
         this.quitWatchingPage(_loc3_);
         this.synchronizeSummonerRunes(_loc2_);
         this.startWatchingPage(_loc2_);
      }
      
      private function set _494846671filteredBlackRunes(param1:ArrayCollection) : void
      {
         if(this._filteredBlackRunes == param1)
         {
            return;
         }
         this._filteredBlackRunes = param1;
      }
      
      public function get summonerRunesAwardedList() : ArrayCollection
      {
         return this._summonerRunesAwardedList;
      }
      
      public function addRunesToInventory(param1:Array, param2:Boolean = true) : ArrayCollection
      {
         var _loc4_:RuneQuantity = null;
         var _loc5_:ArrayCollection = null;
         var _loc6_:Boolean = false;
         var _loc7_:SummonerRune = null;
         var _loc8_:SummonerRune = null;
         if(param1 == null)
         {
            return null;
         }
         var _loc3_:ArrayCollection = new ArrayCollection();
         for each(_loc4_ in param1)
         {
            if(this.inventory.summonerRuneInventory)
            {
               _loc7_ = this.inventory.summonerRuneInventory.addRuneQunatity(_loc4_);
               if(_loc7_ == null)
               {
                  continue;
               }
               _loc3_.addItem(_loc7_);
            }
            _loc5_ = this.getFilteredRuneInventoryByType(this.inventory.runeDictionary[_loc7_.runeId].runeType.runeTypeId);
            _loc6_ = false;
            if(_loc5_)
            {
               for each(_loc8_ in _loc5_.source)
               {
                  if(_loc8_.runeId == _loc7_.runeId)
                  {
                     _loc6_ = true;
                     break;
                  }
               }
               if(!_loc6_)
               {
                  InventoryUtils.hydrateRuneData(_loc7_,this.inventory.runeDictionary);
                  RuneBookUtils.localizeRune(_loc7_.rune);
                  _loc5_.addItem(_loc7_);
                  if(param2)
                  {
                     this.refreshSingleFilteredRunes(_loc7_.rune.runeType.runeTypeId);
                  }
               }
            }
         }
         return _loc3_;
      }
      
      private function filterForRedRunes(param1:Object) : Boolean
      {
         if(this.runeColorViewState != RuneColors.RUNE_COLOR_RED_VIEW)
         {
            return false;
         }
         if(this.redRuneFilteredCount >= RuneBookController.maxRunesPerFilter)
         {
            return false;
         }
         var _loc2_:SummonerRune = param1 as SummonerRune;
         var _loc3_:Boolean = this.filterRunesIgnoreType(_loc2_);
         if(_loc3_)
         {
            ++this.redRuneFilteredCount;
         }
         return _loc3_;
      }
      
      private function set _6092032tier2RunesFiltered(param1:Boolean) : void
      {
         if(this._tier2RunesFiltered == param1)
         {
            return;
         }
         this._tier2RunesFiltered = param1;
         this.refreshFilteredRuneInventory();
      }
      
      protected function setRuneBook() : void
      {
         var _loc1_:SpellBookPageDTO = null;
         if(this.runeBook != null)
         {
            for each(_loc1_ in this.runeBook.bookPages)
            {
               this.startWatchingPage(_loc1_);
            }
         }
      }
      
      private function onServiceRequestError(param1:ServerError) : void
      {
         if(this.proxiedErrorHandler != null)
         {
            this.proxiedErrorHandler.apply(null,[param1]);
         }
         this.proxiedErrorHandler = null;
      }
      
      private function get runesToCombine() : ArrayCollection
      {
         return this._runesToCombine;
      }
      
      public function get filteredYellowRunes() : ArrayCollection
      {
         return this._filteredYellowRunes;
      }
      
      private function initNewRuneBook(param1:SpellBookDTO) : void
      {
         this.hydrateSpellBook(param1);
         this.synchronizeRuneBookPages(param1);
         RuneBookUtils.localizeRuneBook(param1);
      }
      
      protected function setSummoner() : void
      {
         var _loc1_:Boolean = false;
         if(this._summoner != null)
         {
            if(!this.editing && !this.combining)
            {
               if(this.inventory.summonerRuneInventory == null)
               {
                  this.refreshRuneInventory();
               }
            }
            _loc1_ = this.summoner.acctId == this.session.summoner.acctId;
            if(_loc1_)
            {
               this.runeBook = this.inventory.runeBook;
               this.synchronizeRuneBookPages(this.runeBook);
            }
            else
            {
               this.getRuneBook(null);
            }
         }
      }
      
      private function populateFilteredRunes(param1:Array, param2:ArrayCollection, param3:ArrayCollection, param4:ArrayCollection, param5:ArrayCollection) : void
      {
         var _loc6_:SummonerRune = null;
         for each(_loc6_ in param1)
         {
            if(!_loc6_.rune || !_loc6_.rune.runeType)
            {
               continue;
            }
            switch(_loc6_.rune.runeType.runeTypeId)
            {
               case RuneType.BLUE_RUNE:
                  param4.addItem(_loc6_);
                  break;
               case RuneType.RED_RUNE:
                  param2.addItem(_loc6_);
                  break;
               case RuneType.YELLOW_RUNE:
                  param3.addItem(_loc6_);
                  break;
               case RuneType.BLACK_RUNE:
                  param5.addItem(_loc6_);
            }
         }
      }
      
      private function quitWatchingPage(param1:SpellBookPageDTO) : void
      {
         if(param1.getEntries() == null)
         {
            return;
         }
         param1.getEntries().removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.onSpellBookPageRunesChanged);
      }
      
      public function removeRuneFromCombiner(param1:Rune, param2:Boolean = true) : void
      {
         var _loc4_:SummonerRune = null;
         var _loc3_:int = int(this.runesToCombine.getItemIndex(param1));
         if(_loc3_ >= 0)
         {
            this.runesToCombine.removeItemAt(_loc3_);
            _loc4_ = this.inventory.summonerRuneInventory.findSummonerRune(param1.itemId);
            if(_loc4_)
            {
               ++_loc4_.currentAvailableQuantity;
            }
            if(this.runesToCombine.length == 0)
            {
               this.refreshFilteredRuneInventory();
            }
            else if(Boolean(param2) && Boolean(param1) && Boolean(param1.runeType))
            {
               this.refreshSingleFilteredRunes(param1.runeType.runeTypeId);
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set categoryNames(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this.categoryNames;
         if(_loc2_ !== param1)
         {
            this._322607338categoryNames = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"categoryNames",_loc2_,param1));
         }
      }
      
      private function filterByRuneCategory(param1:SummonerRune) : Boolean
      {
         var _loc3_:ItemEffect = null;
         var _loc2_:Boolean = true;
         if(this.runeCategorySelected != RuneCategories.RUNE_CATEGORY_ALL && param1.rune.itemEffects.length > 0)
         {
            for each(_loc3_ in param1.rune.itemEffects)
            {
               if(_loc3_)
               {
                  _loc2_ = _loc3_.effectCategory == this.runeCategorySelected;
                  if(_loc2_ == true)
                  {
                     break;
                  }
               }
            }
         }
         return _loc2_;
      }
      
      public function get filteredBlueRunes() : ArrayCollection
      {
         return this._filteredBlueRunes;
      }
      
      protected function removeRuneBook() : void
      {
         var _loc1_:SpellBookPageDTO = null;
         if(this._runeBook != null)
         {
            for each(_loc1_ in this._runeBook.bookPages)
            {
               this.quitWatchingPage(_loc1_);
            }
         }
      }
      
      public function getLocalRunebook() : void
      {
         this.internalGetLocalRunebook(this.session.summoner.sumId,this.onLocalRuneBookRetrieved,this.onServiceRequestComplete,null);
      }
   }
}

