package com.riotgames.platform.gameclient.Models
{
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.IChampionFilter;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.events.IEventDispatcher;
   import mx.collections.ArrayCollection;
   import mx.collections.Sort;
   import mx.events.CollectionEvent;
   import mx.events.PropertyChangeEvent;
   
   public class ChampionListPresentationModel implements IEventDispatcher
   {
      
      private var _filterString:String = "";
      
      public var notOwned:Boolean = true;
      
      private var _almostExpired:Boolean = false;
      
      private var _customFilterFunction:Function = null;
      
      public var owned:Boolean = true;
      
      private var _ownedByMyTeam:Boolean = false;
      
      public var customSortFunction:Function = null;
      
      private var _rented:Boolean = false;
      
      public var recentlyPurchased:Boolean = false;
      
      private var championFilter:IChampionFilter;
      
      private var _bindingEventDispatcher:EventDispatcher = new EventDispatcher(IEventDispatcher(this));
      
      private var _showRandom:Boolean = false;
      
      private var _available:Boolean = false;
      
      public var allowFreeChampions:Boolean;
      
      private var refreshTimeoutId:int = 0;
      
      private var _championsList:ArrayCollection = null;
      
      private var _ownedByEnemyTeam:Boolean = false;
      
      private var _143041811sortedChampions:ArrayCollection = new ArrayCollection();
      
      private var _rentedExpired:Boolean = false;
      
      private var filterChangedSinceRefresh:Boolean = false;
      
      public function ChampionListPresentationModel(param1:Boolean, param2:IChampionFilter)
      {
         super();
         this.allowFreeChampions = param1;
         this.championFilter = param2;
      }
      
      public function get ownedByEnemyTeam() : Boolean
      {
         return this._ownedByEnemyTeam;
      }
      
      public function willTrigger(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.willTrigger(param1);
      }
      
      public function set customFilterFunction(param1:Function) : void
      {
         this._customFilterFunction = param1;
         this.filterChangedSinceRefresh = true;
      }
      
      public function get almostExpired() : Boolean
      {
         return this._almostExpired;
      }
      
      public function get rented() : Boolean
      {
         return this._rented;
      }
      
      public function set available(param1:Boolean) : void
      {
         if(this._available != param1)
         {
            this._available = param1;
            this.filterChangedSinceRefresh = true;
         }
      }
      
      public function set ownedByEnemyTeam(param1:Boolean) : void
      {
         if(this._ownedByEnemyTeam != param1)
         {
            this._ownedByEnemyTeam = param1;
            this.filterChangedSinceRefresh = true;
         }
      }
      
      public function get showRandom() : Boolean
      {
         return this._showRandom;
      }
      
      public function get filterString() : String
      {
         return this._filterString;
      }
      
      private function onChampionsListChanged(param1:CollectionEvent) : void
      {
         if(this._championsList != null && this._championsList.length > 0)
         {
            this._championsList.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.onChampionsListChanged);
            this.createSortedChampions();
         }
      }
      
      public function get ownedByMyTeam() : Boolean
      {
         return this._ownedByMyTeam;
      }
      
      public function set almostExpired(param1:Boolean) : void
      {
         if(this._almostExpired != param1)
         {
            this._almostExpired = param1;
            this.filterChangedSinceRefresh = true;
         }
      }
      
      public function refreshIfFiltersChanged() : void
      {
         if(this.filterChangedSinceRefresh)
         {
            this.refreshSortedList();
         }
      }
      
      private function filterChampions(param1:Object) : Boolean
      {
         var _loc2_:Champion = param1 as Champion;
         var _loc3_:Boolean = this.recentlyPurchased == true && !_loc2_.recentPurchase() == true;
         _loc3_ ||= this.owned == true && this.notOwned == false && _loc2_.owned == false;
         _loc3_ ||= this.owned == false && this.notOwned == true && _loc2_.owned == true;
         _loc3_ ||= this.available == true && !_loc2_.isAvailable(this.allowFreeChampions);
         _loc3_ ||= _loc2_.isRandomChampion() && !this.showRandom;
         _loc3_ ||= this.ownedByMyTeam && !_loc2_.ownedByYourTeam;
         _loc3_ ||= this.ownedByEnemyTeam && !_loc2_.ownedByEnemyTeam;
         _loc3_ ||= this.rented && !_loc2_.isRented();
         _loc3_ ||= this.rentedExpired && !_loc2_.isExpired();
         _loc3_ ||= this.almostExpired && !_loc2_.isAlmostExpired();
         _loc3_ ||= !this.checkFilters(_loc2_);
         if(_loc2_.isWildCardChampion() && this.showRandom)
         {
            _loc3_ = false;
         }
         return !_loc3_;
      }
      
      public function resetSortedChampionsListIfNeeded() : void
      {
         if(this.championsList.length != this.sortedChampions.length)
         {
            this.resetBooleanSortFlags();
            this.championFilter.resetSearchTags();
            this.refreshSortedList();
         }
      }
      
      public function refreshSortedList() : void
      {
         this.internalRefreshSortedList();
      }
      
      public function set rented(param1:Boolean) : void
      {
         if(this._rented != param1)
         {
            this._rented = param1;
            this.filterChangedSinceRefresh = true;
         }
      }
      
      public function set showRandom(param1:Boolean) : void
      {
         if(this._showRandom != param1)
         {
            this._showRandom = param1;
            this.filterChangedSinceRefresh = true;
         }
      }
      
      public function get customFilterFunction() : Function
      {
         return this._customFilterFunction;
      }
      
      public function get available() : Boolean
      {
         return this._available;
      }
      
      public function addEventListener(param1:String, param2:Function, param3:Boolean = false, param4:int = 0, param5:Boolean = false) : void
      {
         this._bindingEventDispatcher.addEventListener(param1,param2,param3,param4,param5);
      }
      
      public function dispatchEvent(param1:Event) : Boolean
      {
         return this._bindingEventDispatcher.dispatchEvent(param1);
      }
      
      public function set championsList(param1:ArrayCollection) : void
      {
         this._championsList = param1;
         if(param1 == null)
         {
            this.sortedChampions.removeAll();
         }
         else if(param1.length > 0)
         {
            this.createSortedChampions();
         }
         else
         {
            this.sortedChampions.removeAll();
            this._championsList.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.onChampionsListChanged);
         }
      }
      
      public function set filterString(param1:String) : void
      {
         if(param1 != this._filterString)
         {
            this._filterString = param1;
            this.championFilter.setFilterString(param1);
            this.refreshSortedList();
         }
      }
      
      private function checkFilters(param1:Champion) : Boolean
      {
         return this.championFilter.filter(param1,-1,null);
      }
      
      private function createSortedChampions() : void
      {
         if(this._championsList == null || this._championsList.length == 0)
         {
            return;
         }
         this.sortedChampions = new ArrayCollection(this._championsList.toArray());
         var _loc1_:Sort = new Sort();
         if(this.customSortFunction == null)
         {
            _loc1_.compareFunction = this.championFilter.sortByDisplayName;
         }
         else
         {
            _loc1_.compareFunction = this.customSortFunction;
         }
         this.sortedChampions.sort = _loc1_;
         this.sortedChampions.filterFunction = this.filterChampions;
         this.refreshSortedList();
      }
      
      public function set rentedExpired(param1:Boolean) : void
      {
         if(this._rentedExpired != param1)
         {
            this._rentedExpired = param1;
            this.filterChangedSinceRefresh = true;
         }
      }
      
      private function resetBooleanSortFlags() : void
      {
         this.owned = true;
         this.notOwned = true;
         this.recentlyPurchased = false;
         this._available = false;
         this._showRandom = false;
         this._ownedByMyTeam = false;
         this._ownedByEnemyTeam = false;
         this._rented = false;
         this._rentedExpired = false;
         this._almostExpired = false;
      }
      
      public function set sortedChampions(param1:ArrayCollection) : void
      {
         var _loc2_:Object = this._143041811sortedChampions;
         if(_loc2_ !== param1)
         {
            this._143041811sortedChampions = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"sortedChampions",_loc2_,param1));
         }
      }
      
      public function get championsList() : ArrayCollection
      {
         return this._championsList;
      }
      
      public function set ownedByMyTeam(param1:Boolean) : void
      {
         if(this._ownedByMyTeam != param1)
         {
            this._ownedByMyTeam = param1;
            this.filterChangedSinceRefresh = true;
         }
      }
      
      public function get rentedExpired() : Boolean
      {
         return this._rentedExpired;
      }
      
      [Bindable(event="propertyChange")]
      public function get sortedChampions() : ArrayCollection
      {
         return this._143041811sortedChampions;
      }
      
      public function removeEventListener(param1:String, param2:Function, param3:Boolean = false) : void
      {
         this._bindingEventDispatcher.removeEventListener(param1,param2,param3);
      }
      
      private function internalRefreshSortedList() : void
      {
         this.filterChangedSinceRefresh = false;
         this.sortedChampions.refresh();
      }
      
      public function hasEventListener(param1:String) : Boolean
      {
         return this._bindingEventDispatcher.hasEventListener(param1);
      }
   }
}

