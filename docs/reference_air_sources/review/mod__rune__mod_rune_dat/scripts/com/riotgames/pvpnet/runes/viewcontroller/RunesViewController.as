package com.riotgames.pvpnet.runes.viewcontroller
{
   import blix.ds.IListX;
   import blix.factory.ClassFactory;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.provider.IInventory;
   import com.riotgames.platform.common.provider.IRuneBookController;
   import com.riotgames.platform.gameclient.domain.SpellBookDTO;
   import com.riotgames.platform.gameclient.domain.SpellBookPageDTO;
   import com.riotgames.platform.gameclient.domain.Summoner;
   import com.riotgames.platform.gameclient.domain.SummonerRuneInventory;
   import com.riotgames.platform.gameclient.events.RuneBookEvent;
   import com.riotgames.pvpnet.runes.controller.RecordBookMetricsAction;
   import com.riotgames.pvpnet.runes.controller.RuneCounter;
   import flash.events.Event;
   import mx.collections.ArrayCollection;
   import mx.events.CollectionEvent;
   
   public class RunesViewController
   {
      
      private var _runeBookController:IRuneBookController;
      
      private var _inventory:IInventory;
      
      private var _currentRuneBookPageChange:Signal = new Signal();
      
      private var _summonerRunes:ArrayCollection;
      
      private var _runesFilter:RuneFilter;
      
      private var _runeCounter:RuneCounter;
      
      private var _runesToCombine:IListX;
      
      private var _runeModel:RuneViewModel;
      
      private var _hasUnsavedChanges:Boolean = false;
      
      private var _runeBook:SpellBookDTO;
      
      private var _viewIsHidden:Boolean;
      
      private var _runeBookRetrieved:Signal = new Signal();
      
      private var _hasUnsavedChangesChanged:Signal = new Signal();
      
      private var _runeBookControllerInitialized:Signal = new Signal();
      
      private var _summonerLevelChanged:Signal = new Signal();
      
      private var _summonerChanged:Signal = new Signal();
      
      private var _runesTrackerFactory:ClassFactory;
      
      private var _localSummoner:Summoner;
      
      private var _viewIsHiddenChanged:Signal = new Signal();
      
      public function RunesViewController(param1:IRuneBookController, param2:IInventory, param3:IListX, param4:RuneViewModel, param5:RuneFilter, param6:RuneCounter, param7:Summoner, param8:ClassFactory)
      {
         super();
         this._runeBookController = param1;
         this._runesToCombine = param3;
         this._runesTrackerFactory = param8;
         this._inventory = param2;
         this._localSummoner = param7;
         this._runesFilter = param5;
         this._runeModel = param4;
         this._runeCounter = param6;
         this._runeBookController.addEventListener(RuneBookEvent.RUNE_BOOK_CHANGED,this.runeBookChangedHandler);
         this._runeBookController.addEventListener(RuneBookEvent.SUMMONER_CHANGED,this.onSummonerChanged);
         this._runeBookController.addEventListener(RuneBookEvent.SUMMONER_LEVEL_CHANGED,this.handleSummonerLevelChanged);
         this._runeBookController.addEventListener(RuneBookEvent.RUNE_BOOK_CONTROLLER_INITIALIZED,this.onRuneBookControllerInitialized);
         this._runeBookController.addEventListener(RuneBookEvent.RUNE_BOOK_STATE_CHANGED,this.handleRuneBookStateChanged);
         this.setRuneBook(this._runeBookController.runeBook);
         this.setSummonerRunes(param2.summonerRuneInventory);
      }
      
      public function getRuneBookRetrieved() : ISignal
      {
         return this._runeBookRetrieved;
      }
      
      public function getHasUnsavedChangesChanged() : ISignal
      {
         return this._hasUnsavedChangesChanged;
      }
      
      public function getRuneBookControllerInitialized() : ISignal
      {
         return this._runeBookControllerInitialized;
      }
      
      public function getSummonerLevelChanged() : ISignal
      {
         return this._summonerLevelChanged;
      }
      
      public function getSummonerChanged() : ISignal
      {
         return this._summonerChanged;
      }
      
      public function getCurrentRuneBookPageChanged() : ISignal
      {
         return this._currentRuneBookPageChange;
      }
      
      public function getSummoner() : Summoner
      {
         return this._runeBookController.summoner;
      }
      
      public function getSummonerLevel() : Number
      {
         return this._runeBookController.summonerLevel;
      }
      
      public function getCurrentRuneBookPage() : SpellBookPageDTO
      {
         if(this._runeBookController.runeBook == null)
         {
            return null;
         }
         return this._runeBookController.currentRuneBookPage;
      }
      
      public function setCurrentRuneBookPage(param1:SpellBookPageDTO) : void
      {
         if(this._runeBook == null)
         {
            return;
         }
         if(param1 == null)
         {
            param1 = this._runeBook.bookPages[0];
         }
         this._runeBookController.currentRuneBookPage = param1;
         this._runeCounter.setRuneBookPage(param1);
         this.resetFilteredRunes();
         this._currentRuneBookPageChange.dispatch();
      }
      
      public function getHasUnsavedChanges() : Boolean
      {
         return this._hasUnsavedChanges;
      }
      
      public function setHasUnsavedChanges(param1:Boolean) : void
      {
         if(this._hasUnsavedChanges == param1)
         {
            return;
         }
         this._hasUnsavedChanges = param1;
         this._hasUnsavedChangesChanged.dispatch(param1);
      }
      
      public function getCategoryNames() : ArrayCollection
      {
         return this._runeBookController.categoryNames;
      }
      
      private function setRuneBook(param1:SpellBookDTO) : void
      {
         if(this._runeBook != null && this._runeBook.bookPages != null)
         {
            this._runeBook.bookPages.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.runeBookPagesChangeHandler);
         }
         this._runeBook = param1;
         this._runeCounter.setRuneBook(this._runeBook);
         if(this._runeBook != null && this._runeBook.bookPages != null)
         {
            this._runeBook.bookPages.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.runeBookPagesChangeHandler);
            this.setCurrentRuneBookPage(this._runeBook.defaultPage as SpellBookPageDTO);
         }
         this.recordBookMetrics();
         this._runeBookRetrieved.dispatch();
      }
      
      private function setSummonerRunes(param1:SummonerRuneInventory) : void
      {
         this._inventory.addEventListener("summonerRuneInventoryChanged",this.summonerRuneInventoryChangedHandler);
         if(this._inventory.summonerRuneInventory)
         {
            this._summonerRunes = param1.summonerRunes;
            this._runeModel.setSummonerRunes(this._summonerRunes);
         }
         this.recordBookMetrics();
      }
      
      public function getViewIsHidden() : Boolean
      {
         return this._viewIsHidden;
      }
      
      public function setViewIsHidden(param1:Boolean) : void
      {
         if(param1 == this._viewIsHidden)
         {
            return;
         }
         this._viewIsHidden = param1;
         this._viewIsHiddenChanged.dispatch(param1);
      }
      
      public function getViewIsHiddenChanged() : ISignal
      {
         return this._viewIsHiddenChanged;
      }
      
      public function save() : void
      {
         if(!this._hasUnsavedChanges)
         {
            return;
         }
         this.setCurrentRuneBookPage(this.getCurrentRuneBookPage());
         this._runeBookController.saveSpellBook();
         this.recordBookMetrics();
         this.setHasUnsavedChanges(false);
      }
      
      public function revert() : void
      {
         if(!this._hasUnsavedChanges)
         {
            return;
         }
         this._runeBookController.undoRuneBookChanges();
         this.setHasUnsavedChanges(false);
      }
      
      public function isLocalSummoner() : Boolean
      {
         if(this._runeBookController.summoner)
         {
            return this._localSummoner.acctId == this._runeBookController.summoner.acctId;
         }
         return false;
      }
      
      public function resetFilteredRunes() : void
      {
         this._runeModel.reset();
      }
      
      private function onSummonerChanged(param1:RuneBookEvent) : void
      {
         this._summonerChanged.dispatch();
      }
      
      private function handleSummonerLevelChanged(param1:RuneBookEvent) : void
      {
         this._summonerLevelChanged.dispatch();
      }
      
      private function onRuneBookControllerInitialized(param1:RuneBookEvent) : void
      {
         this._runeBookControllerInitialized.dispatch();
      }
      
      private function runeBookChangedHandler(param1:RuneBookEvent) : void
      {
         this.setRuneBook(this._runeBookController.runeBook);
      }
      
      private function summonerRuneInventoryChangedHandler(param1:Event) : void
      {
         this.setSummonerRunes(this._inventory.summonerRuneInventory);
      }
      
      private function handleRuneBookStateChanged(param1:RuneBookEvent) : void
      {
         this._runeModel.reset();
      }
      
      private function runeBookPagesChangeHandler(param1:CollectionEvent) : void
      {
         this._runeCounter.setRuneBookPage(this.getCurrentRuneBookPage());
         this._runeModel.reset();
         this._currentRuneBookPageChange.dispatch();
      }
      
      private function recordBookMetrics() : void
      {
         var _loc1_:RecordBookMetricsAction = this._runesTrackerFactory.getInstance() as RecordBookMetricsAction;
         _loc1_.setTrackRequirements(this._runeBook,this._summonerRunes);
         _loc1_.invoke();
      }
   }
}

