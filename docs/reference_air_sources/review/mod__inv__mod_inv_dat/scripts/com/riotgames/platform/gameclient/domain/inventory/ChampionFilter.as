package com.riotgames.platform.gameclient.domain.inventory
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.gameclient.Models.SearchTagData;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.ChampionAvailabilityEnums;
   import com.riotgames.platform.gameclient.domain.IChampionFilter;
   import mx.utils.ObjectUtil;
   
   public class ChampionFilter implements IChampionFilter
   {
      
      private var _searchTags:Array;
      
      private var _filterString:String = "";
      
      private var _ownedState:uint = 0;
      
      private var _customFilterFunction:Function;
      
      private var _changed:Signal = new Signal();
      
      public function ChampionFilter(param1:Array)
      {
         super();
         this._searchTags = param1;
      }
      
      private function filterChampionByFilterString(param1:Champion) : Boolean
      {
         var _loc3_:SearchTagData = null;
         var _loc4_:SearchTagData = null;
         var _loc5_:String = null;
         var _loc2_:Boolean = true;
         if(param1.championData)
         {
            _loc2_ = Boolean(param1.displayName) && param1.displayName.toLowerCase().search(this._filterString) > -1;
            if(!_loc2_)
            {
               for each(_loc4_ in this._searchTags)
               {
                  if(_loc4_.searchTagDisplayName.toLocaleLowerCase() == this._filterString.toLocaleLowerCase())
                  {
                     _loc3_ = _loc4_;
                     break;
                  }
               }
               if(_loc3_ != null)
               {
                  for each(_loc5_ in param1.searchTags)
                  {
                     if(_loc5_ == _loc3_.searchTag)
                     {
                        _loc2_ = true;
                     }
                  }
               }
            }
            if(!_loc2_ && this._filterString == "urf" && param1.championId == 19)
            {
               _loc2_ = true;
            }
         }
         return _loc2_;
      }
      
      private function filterByOwnedState(param1:Champion) : Boolean
      {
         var _loc2_:Boolean = true;
         switch(this._ownedState)
         {
            case ChampionAvailabilityEnums.FILTER_AVAILABLE:
               _loc2_ = Boolean(param1.isAvailable(true));
               break;
            case ChampionAvailabilityEnums.FILTER_OWNED:
               _loc2_ = Boolean(param1.isOwned());
               break;
            case ChampionAvailabilityEnums.FILTER_RENTED:
               _loc2_ = Boolean(param1.isRented());
               break;
            case ChampionAvailabilityEnums.FILTER_RENTED_EXPIRED:
               _loc2_ = Boolean(param1.isExpired());
               break;
            case ChampionAvailabilityEnums.FILTER_RECENT_PURCHASE:
               _loc2_ = Boolean(param1.recentPurchase());
               break;
            case ChampionAvailabilityEnums.FILTER_NOT_OWNED:
               _loc2_ = !param1.isOwned();
               break;
            case ChampionAvailabilityEnums.FILTER_PENDING_EXPIRATION:
               _loc2_ = Boolean(param1.isAlmostExpired());
               break;
            case ChampionAvailabilityEnums.FILTER_ALL:
         }
         return _loc2_;
      }
      
      public function setCustomFilterFunction(param1:Function) : void
      {
         if(this._customFilterFunction == param1)
         {
            return;
         }
         this._customFilterFunction = param1;
         this._changed.dispatch();
      }
      
      public function getChanged() : ISignal
      {
         return this._changed;
      }
      
      public function getCustomFilterFunction() : Function
      {
         return this._customFilterFunction;
      }
      
      public function sortByDisplayName(param1:Object, param2:Object, param3:Array = null) : int
      {
         var _loc4_:Champion = param1 is Champion ? param1 as Champion : param1.champion;
         var _loc5_:Champion = param2 is Champion ? param2 as Champion : param2.champion;
         if(_loc4_.championData == null)
         {
            return 1;
         }
         if(_loc5_.championData == null)
         {
            return -1;
         }
         var _loc6_:Boolean = Boolean(_loc4_.isRandomChampion());
         var _loc7_:Boolean = Boolean(_loc5_.isRandomChampion());
         var _loc8_:Boolean = Boolean(_loc4_.isWildCardChampion());
         var _loc9_:Boolean = Boolean(_loc5_.isWildCardChampion());
         if(_loc6_ && _loc7_)
         {
            return 0;
         }
         if(_loc8_ && _loc9_)
         {
            return 0;
         }
         if(_loc6_)
         {
            return -1;
         }
         if(_loc7_)
         {
            return 1;
         }
         if(_loc8_)
         {
            return 1;
         }
         if(_loc9_)
         {
            return -1;
         }
         return this.compareChampionDisplayNames(_loc4_.displayName,_loc5_.displayName);
      }
      
      public function setTagState(param1:SearchTagData, param2:Boolean, param3:Boolean = true) : *
      {
         var _loc4_:SearchTagData = null;
         for each(_loc4_ in this._searchTags)
         {
            if(_loc4_.searchTag == param1.searchTag)
            {
               _loc4_.enabled = param2;
            }
            else if(param3)
            {
               _loc4_.enabled = false;
            }
         }
         this._changed.dispatch();
      }
      
      public function getSearchTags() : Array
      {
         return this._searchTags;
      }
      
      public function setSearchTags(param1:Array) : void
      {
         if(this._searchTags == param1)
         {
            return;
         }
         this._searchTags = param1;
         this._changed.dispatch();
      }
      
      public function getFilterString() : String
      {
         return this._filterString;
      }
      
      public function resetSearchTags() : void
      {
         var _loc1_:SearchTagData = null;
         if(this._searchTags)
         {
            for each(_loc1_ in this._searchTags)
            {
               if(_loc1_.searchTag == "all")
               {
                  _loc1_.enabled = true;
               }
               else
               {
                  _loc1_.enabled = false;
               }
            }
         }
      }
      
      public function setOwnedState(param1:uint) : void
      {
         if(this._ownedState == param1)
         {
            return;
         }
         this._ownedState = param1;
         this._changed.dispatch();
      }
      
      public function setFilterString(param1:String) : void
      {
         if(this._filterString == param1)
         {
            return;
         }
         this._filterString = param1;
         this._changed.dispatch();
      }
      
      protected function compareChampionDisplayNames(param1:String, param2:String) : int
      {
         return ObjectUtil.stringCompare(param1,param2,true);
      }
      
      public function filter(param1:Champion, param2:int = -1, param3:Array = null) : Boolean
      {
         var _loc4_:Boolean = true;
         _loc4_ = (_loc4_) && param1.championData != null;
         _loc4_ = (_loc4_) && this.filterChampionBySearchTag(param1);
         _loc4_ = (_loc4_) && this.filterChampionByFilterString(param1);
         _loc4_ = (_loc4_) && this.filterByOwnedState(param1);
         if(this._customFilterFunction != null && _loc4_)
         {
            _loc4_ &&= Boolean(this._customFilterFunction(param1));
         }
         return _loc4_;
      }
      
      private function filterChampionBySearchTag(param1:Champion) : Boolean
      {
         var _loc4_:uint = 0;
         var _loc5_:SearchTagData = null;
         var _loc6_:String = null;
         var _loc2_:Boolean = true;
         var _loc3_:uint = 0;
         if(Boolean(param1.championData) && this._searchTags != null)
         {
            _loc4_ = 0;
            for each(_loc5_ in this._searchTags)
            {
               if(_loc5_.enabled)
               {
                  _loc3_++;
               }
               if(_loc5_.searchTag == "all" && Boolean(_loc5_.enabled))
               {
                  _loc2_ = true;
                  break;
               }
               for each(_loc6_ in param1.searchTags)
               {
                  if(_loc6_ == _loc5_.searchTag)
                  {
                     if(_loc5_.enabled)
                     {
                        _loc4_++;
                     }
                  }
               }
               if(_loc4_ < _loc3_)
               {
                  _loc2_ = false;
               }
            }
         }
         if(_loc3_ == 0)
         {
            _loc2_ = true;
         }
         return _loc2_;
      }
   }
}

