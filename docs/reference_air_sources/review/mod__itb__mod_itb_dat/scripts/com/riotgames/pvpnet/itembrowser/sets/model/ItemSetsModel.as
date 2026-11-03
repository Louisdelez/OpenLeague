package com.riotgames.pvpnet.itembrowser.sets.model
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.gameclient.domain.IChampionFilter;
   import com.riotgames.platform.gameclient.domain.game.GameMap;
   import flash.utils.Dictionary;
   
   public class ItemSetsModel
   {
      
      private var _availableMaps:Vector.<GameMap>;
      
      private var _itemSetsDirtyChanged:Signal = new Signal();
      
      public var skinNameToChampionDictionary:Dictionary = new Dictionary();
      
      private var _itemSetChampions:Vector.<ItemSetChampion> = new Vector.<ItemSetChampion>();
      
      private var _championFilterTags:Array;
      
      private var _itemSetsDirty:Boolean = false;
      
      public var championIdToChampionDictionary:Dictionary = new Dictionary();
      
      private var _itemSetsChanged:Signal = new Signal();
      
      private var _itemSetChampionsChanged:Signal = new Signal();
      
      private var _championFilter:IChampionFilter;
      
      private var _championFilterTagsChanged:Signal = new Signal();
      
      private var _itemSets:Vector.<ItemSet> = new Vector.<ItemSet>();
      
      private var _activeItemSet:ItemSet;
      
      private var _availableMapsChanged:Signal = new Signal();
      
      private var _activeItemSetChanged:Signal = new Signal();
      
      public function ItemSetsModel()
      {
         super();
      }
      
      public function addItemPage(param1:ItemSet) : void
      {
         if(!this._itemSets)
         {
            this._itemSets = new Vector.<ItemSet>();
         }
         this._itemSets.push(param1);
         this._itemSetsChanged.dispatch(this);
      }
      
      public function setItemSets(param1:Vector.<ItemSet>) : void
      {
         this._itemSets = param1;
         this._itemSetsChanged.dispatch(this);
         if(this._itemSets.length > 0)
         {
            this.setActiveItemSet(this._itemSets[0]);
         }
         else
         {
            this.setActiveItemSet(null);
         }
      }
      
      public function getActiveItemSetChanged() : ISignal
      {
         return this._activeItemSetChanged;
      }
      
      public function setChampionFilterTags(param1:Array) : void
      {
         if(param1 != this._championFilterTags)
         {
            this._championFilterTags = param1;
            if(this._championFilter)
            {
               this._championFilter.setSearchTags(param1);
            }
            this._championFilterTagsChanged.dispatch();
         }
      }
      
      public function getItemSetChampions() : Vector.<ItemSetChampion>
      {
         return this._itemSetChampions;
      }
      
      public function getItemSetsDirtyChanged() : ISignal
      {
         return this._itemSetsDirtyChanged;
      }
      
      public function setItemSetChampions(param1:Vector.<ItemSetChampion>) : void
      {
         if(this._itemSetChampions != param1)
         {
            this._itemSetChampions = param1;
            this._itemSetChampionsChanged.dispatch(this);
         }
      }
      
      public function getChampionFilterTagsChanged() : ISignal
      {
         return this._championFilterTagsChanged;
      }
      
      public function setActiveItemSet(param1:ItemSet) : void
      {
         if(this._activeItemSet != param1)
         {
            this._activeItemSet = param1;
            this._activeItemSetChanged.dispatch(this);
         }
      }
      
      public function getAvailableMapsChanged() : ISignal
      {
         return this._availableMapsChanged;
      }
      
      public function getChampionFilter() : IChampionFilter
      {
         return this._championFilter;
      }
      
      public function getActiveItemSet() : ItemSet
      {
         return this._activeItemSet;
      }
      
      public function setAvailableMaps(param1:Vector.<GameMap>) : void
      {
         if(param1 != this._availableMaps)
         {
            this._availableMaps = param1;
            this._availableMapsChanged.dispatch();
         }
      }
      
      public function setChampionFilter(param1:IChampionFilter) : void
      {
         if(param1 != this._championFilter)
         {
            this._championFilter = param1;
            this._championFilter.setSearchTags(this._championFilterTags);
            this._championFilterTagsChanged.dispatch();
         }
      }
      
      public function getAvailableMaps() : Vector.<GameMap>
      {
         return this._availableMaps;
      }
      
      public function removeItemSetPage(param1:ItemSet) : void
      {
         if(!this._itemSets)
         {
            return;
         }
         var _loc2_:int = this._itemSets.indexOf(param1);
         if(_loc2_ != -1)
         {
            this._itemSets.splice(_loc2_,1);
            this._itemSetsChanged.dispatch(this);
         }
      }
      
      public function getItemSetChampionsChanged() : ISignal
      {
         return this._itemSetChampionsChanged;
      }
      
      public function getItemSetsChanged() : ISignal
      {
         return this._itemSetsChanged;
      }
      
      public function setItemSetsDirty(param1:Boolean) : void
      {
         if(param1 != this._itemSetsDirty)
         {
            this._itemSetsDirty = param1;
            this._itemSetsDirtyChanged.dispatch(this,this._itemSetsDirty);
         }
      }
      
      public function getChampionFilterTags() : Array
      {
         return this._championFilterTags;
      }
      
      public function getItemSetsDirty() : Boolean
      {
         return this._itemSetsDirty;
      }
      
      public function getItemSets() : Vector.<ItemSet>
      {
         return this._itemSets;
      }
   }
}

