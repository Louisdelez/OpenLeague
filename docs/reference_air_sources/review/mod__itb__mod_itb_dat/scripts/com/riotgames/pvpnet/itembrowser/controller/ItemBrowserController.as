package com.riotgames.pvpnet.itembrowser.controller
{
   import com.riotgames.gameItems.dao.GameItemDao;
   import com.riotgames.gameItems.model.GameItem;
   import com.riotgames.gameItems.model.ItemCategory;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.pvpnet.itembrowser.model.ItemBrowserModel;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.tracking.trackers.itemset.IItemSetsBehaviorTracker;
   
   public class ItemBrowserController
   {
      
      private var _itemSetsBehaviorTracker:IItemSetsBehaviorTracker;
      
      private var _model:ItemBrowserModel;
      
      private var _gameItemDao:GameItemDao;
      
      private var _itemSetsController:ItemSetsController;
      
      public function ItemBrowserController(param1:ItemSetsController, param2:ItemBrowserModel, param3:IItemSetsBehaviorTracker)
      {
         super();
         this._gameItemDao = new GameItemDao(ClientConfig.instance.locale,null);
         this._model = param2;
         this._itemSetsController = param1;
         this._itemSetsBehaviorTracker = param3;
         this.fetchGameItemData();
      }
      
      private function onGetItemsSuccess(param1:Vector.<GameItem>) : void
      {
         this._model.allItems = param1;
      }
      
      public function get itemSetsBehaviorTracker() : IItemSetsBehaviorTracker
      {
         return this._itemSetsBehaviorTracker;
      }
      
      private function fetchGameItemData() : void
      {
         this._gameItemDao.getAllGameItems(this.onGetItemsSuccess,this.onGetDataFailure);
         this._gameItemDao.getGameItemCategories(this.onGetItemCategoriesSuccess,this.onGetDataFailure);
      }
      
      private function onGetDataFailure(param1:Error) : void
      {
         throw param1;
      }
      
      public function exportChampionItems(param1:Champion, param2:Number) : void
      {
         this._itemSetsController.exportChampionItems(param1,param2);
      }
      
      public function changeItemSetsViewState(param1:String) : void
      {
         this._model.setViewState(param1);
      }
      
      public function destroy() : void
      {
      }
      
      public function setActiveItem(param1:GameItem) : void
      {
         this._model.setActiveItem(param1);
      }
      
      private function onGetItemCategoriesSuccess(param1:Vector.<ItemCategory>) : void
      {
         var _loc2_:ItemCategory = new ItemCategory();
         _loc2_.id = -1;
         _loc2_.name = "all_categories";
         param1.splice(0,0,_loc2_);
         this._model.itemCategories = param1;
      }
   }
}

