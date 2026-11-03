package com.riotgames.pvpnet.itembrowser.model
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.gameItems.model.GameItem;
   import com.riotgames.gameItems.model.ItemCategory;
   import com.riotgames.gameItems.model.ItemTag;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSetsModel;
   
   public class ItemBrowserModel
   {
      
      public static const VIEW_STATE_BUILDING:String = "building";
      
      public static const VIEW_STATE_ASSOCIATING:String = "associating";
      
      private var _allItems:Vector.<GameItem>;
      
      private var _itemSetsModel:ItemSetsModel = new ItemSetsModel();
      
      private var _viewStateChanged:Signal = new Signal();
      
      private var _allItemsChanged:Signal = new Signal();
      
      private var _activeItem:GameItem;
      
      private var _itemCategoriesChanged:Signal = new Signal();
      
      private var _viewState:String = "building";
      
      private var _itemCategories:Vector.<ItemCategory>;
      
      private var _activeItemChanged:Signal = new Signal();
      
      public function ItemBrowserModel()
      {
         super();
      }
      
      public function getItemsChanged() : ISignal
      {
         return this._allItemsChanged;
      }
      
      public function get itemCategories() : Vector.<ItemCategory>
      {
         return this._itemCategories;
      }
      
      public function getItemsWithTag(param1:String) : Vector.<GameItem>
      {
         var _loc3_:GameItem = null;
         var _loc4_:ItemTag = null;
         var _loc2_:Vector.<GameItem> = new Vector.<GameItem>();
         for each(_loc3_ in this._allItems)
         {
            for each(_loc4_ in _loc3_.tags)
            {
               if(_loc4_.tag == param1)
               {
                  _loc2_[_loc2_.length] = _loc3_;
               }
            }
         }
         return _loc2_;
      }
      
      public function setItemSetsModel(param1:ItemSetsModel) : void
      {
         this._itemSetsModel = param1;
      }
      
      public function getActiveItemChanged() : ISignal
      {
         return this._activeItemChanged;
      }
      
      public function getItemCategoryById(param1:int) : ItemCategory
      {
         var _loc2_:ItemCategory = null;
         for each(_loc2_ in this._itemCategories)
         {
            if(_loc2_.id == param1)
            {
               return _loc2_;
            }
         }
         return null;
      }
      
      public function set itemCategories(param1:Vector.<ItemCategory>) : void
      {
         if(this._itemCategories != param1)
         {
            this._itemCategories = param1;
            this._itemCategoriesChanged.dispatch();
         }
      }
      
      public function get allItems() : Vector.<GameItem>
      {
         return this._allItems;
      }
      
      public function getViewStateChanged() : ISignal
      {
         return this._viewStateChanged;
      }
      
      public function getItemSetsModel() : ItemSetsModel
      {
         return this._itemSetsModel;
      }
      
      public function setViewState(param1:String) : void
      {
         if(param1 != this._viewState)
         {
            this._viewState = param1;
            this._viewStateChanged.dispatch(param1);
         }
      }
      
      public function getItemCategoriesChanged() : ISignal
      {
         return this._itemCategoriesChanged;
      }
      
      public function getActiveItem() : GameItem
      {
         return this._activeItem;
      }
      
      public function setActiveItem(param1:GameItem) : void
      {
         this._activeItem = param1;
         this._activeItemChanged.dispatch(param1);
      }
      
      public function getViewState() : String
      {
         return this._viewState;
      }
      
      public function set allItems(param1:Vector.<GameItem>) : void
      {
         if(this._allItems != param1)
         {
            this._allItems = param1;
            this._allItemsChanged.dispatch();
         }
      }
   }
}

