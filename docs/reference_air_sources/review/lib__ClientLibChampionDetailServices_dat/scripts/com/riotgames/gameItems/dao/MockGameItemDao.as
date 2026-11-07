package com.riotgames.gameItems.dao
{
   import blix.action.XmlLoaderAction;
   import blix.util.xml.XMLUtils;
   import com.riotgames.gameItems.model.GameItem;
   import flash.net.URLRequest;
   import flash.utils.Dictionary;
   
   public class MockGameItemDao implements IGameItemDao
   {
      
      private static var gameItemsDictCache:Dictionary;
      
      private var _allGameItemsAction:XmlLoaderAction;
      
      private var _gameItems:Vector.<GameItem>;
      
      public function MockGameItemDao()
      {
         super();
      }
      
      public function getAllGameItems(param1:Function, param2:Function) : void
      {
         var action:XmlLoaderAction = null;
         var successHandler:Function = param1;
         var failHandler:Function = param2;
         action = this.getAllGameItemsAction();
         action.getCompleted().addOnce(function():void
         {
            successHandler(_gameItems);
         });
         action.getErred().addOnce(function():void
         {
            failHandler(action.getError());
         });
         action.invoke();
      }
      
      public function getAllGameItemsDictionary(param1:Function, param2:Function) : void
      {
         var action:XmlLoaderAction = null;
         var successHandler:Function = param1;
         var failHandler:Function = param2;
         action = this.getAllGameItemsAction();
         action.getCompleted().addOnce(function():void
         {
            successHandler(gameItemsDictCache);
         });
         action.getErred().addOnce(function():void
         {
            failHandler(action.getError());
         });
         action.invoke();
      }
      
      protected function getAllGameItemsAction() : XmlLoaderAction
      {
         if(this._allGameItemsAction == null)
         {
            this._allGameItemsAction = new XmlLoaderAction(new URLRequest("mockData/gameItems.txt"));
         }
         this._allGameItemsAction.unmarshallDataFunction = XMLUtils.unmarshal;
         this._allGameItemsAction.getCompleted().addOnce(function():void
         {
            var _loc1_:GameItem = null;
            _gameItems = _allGameItemsAction.unmarshalledData;
            gameItemsDictCache = new Dictionary();
            for each(_loc1_ in _gameItems)
            {
               gameItemsDictCache[_loc1_.id] = _loc1_;
            }
         });
         return this._allGameItemsAction;
      }
      
      public function getGameItemById(param1:int, param2:Function, param3:Function, ... rest) : void
      {
         var action:XmlLoaderAction = null;
         var itemId:int = param1;
         var successHandler:Function = param2;
         var failHandler:Function = param3;
         var successHandlerParams:Array = rest;
         if(gameItemsDictCache != null)
         {
            successHandler(gameItemsDictCache[itemId]);
         }
         action = this.getAllGameItemsAction();
         action.getCompleted().addOnce(function():void
         {
            successHandler(gameItemsDictCache[itemId]);
         });
         action.getErred().addOnce(function():void
         {
            failHandler(action.getError());
         });
         action.invoke();
      }
      
      public function getGameItemsById(param1:Vector.<int>, param2:Function, param3:Function, ... rest) : void
      {
         var action:XmlLoaderAction = null;
         var itemIds:Vector.<int> = param1;
         var successHandler:Function = param2;
         var failHandler:Function = param3;
         var successHandlerParams:Array = rest;
         if(gameItemsDictCache != null)
         {
            successHandler(this.getGameItemsVector(itemIds).concat(successHandlerParams));
         }
         action = this.getAllGameItemsAction();
         action.getCompleted().addOnce(function():void
         {
            successHandler(getGameItemsVector(itemIds).concat(successHandlerParams));
         });
         action.getErred().addOnce(function():void
         {
            failHandler(action.getError());
         });
         action.invoke();
      }
      
      public function getGameItemCategories(param1:Function, param2:Function) : void
      {
      }
      
      private function getGameItemsVector(param1:Vector.<int>) : Vector.<GameItem>
      {
         var _loc3_:int = 0;
         var _loc4_:GameItem = null;
         var _loc2_:Vector.<GameItem> = new Vector.<GameItem>();
         for each(_loc3_ in param1)
         {
            _loc4_ = gameItemsDictCache[_loc3_];
            if(_loc4_ != null)
            {
               _loc2_.push(_loc4_);
            }
         }
         return _loc2_;
      }
   }
}

