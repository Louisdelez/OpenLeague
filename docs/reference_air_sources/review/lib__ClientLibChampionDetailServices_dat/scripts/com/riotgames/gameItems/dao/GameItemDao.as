package com.riotgames.gameItems.dao
{
   import blix.action.IAction;
   import blix.action.SequenceAction;
   import blix.action.respondToAction;
   import blix.context.Context;
   import blix.context.IContext;
   import com.riotgames.gameItems.action.LoadJsonBinaryAction;
   import com.riotgames.gameItems.action.LoadPropertiesBinaryAction;
   import com.riotgames.gameItems.model.GameItem;
   import com.riotgames.gameItems.model.ItemCategory;
   import com.riotgames.gameItems.model.ItemTag;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.util.string.RiotStringUtil;
   import flash.filesystem.File;
   import flash.net.URLRequest;
   import flash.utils.Dictionary;
   
   public class GameItemDao extends Context implements IGameItemDao
   {
      
      private static var gameItemsDictCache:Dictionary;
      
      private static var gameItemsCache:Vector.<GameItem>;
      
      private static var gameCategoriesCache:Vector.<ItemCategory>;
      
      private var loadDataPackAction:LoadJsonBinaryAction;
      
      private var loadColloqDataPackAction:LoadPropertiesBinaryAction;
      
      public function GameItemDao(param1:String, param2:IContext)
      {
         super(param2);
         var _loc3_:File = new File("app:/assets/data/gameStats/gameStats_" + param1 + ".sqlite");
         this.loadDataPackAction = new LoadJsonBinaryAction(new URLRequest("app:/assets/dataPacks/items/ItemDataPack.swf"));
         this.loadColloqDataPackAction = new LoadPropertiesBinaryAction(new URLRequest("app:/assets/dataPacks/items/colloq/ColloqPack_fontconfig_" + ClientConfig.instance.locale + ".swf"),null,null,true);
      }
      
      public function getGameItemById(param1:int, param2:Function, param3:Function, ... rest) : void
      {
         var allGameItemsAction:IAction = null;
         var gameItem:GameItem = null;
         var itemId:int = param1;
         var successHandler:Function = param2;
         var failHandler:Function = param3;
         var successHandlerParams:Array = rest;
         if(gameItemsDictCache != null)
         {
            gameItem = gameItemsDictCache[itemId];
            successHandler.apply(null,[gameItem].concat(successHandlerParams));
            return;
         }
         allGameItemsAction = this.getAllGameItemsAction();
         respondToAction(allGameItemsAction,function():void
         {
            var _loc1_:GameItem = gameItemsDictCache[itemId];
            successHandler.apply(null,[_loc1_].concat(successHandlerParams));
         },function():void
         {
            failHandler(allGameItemsAction.getError());
         });
      }
      
      public function getGameItemsById(param1:Vector.<int>, param2:Function, param3:Function, ... rest) : void
      {
         var allGameItemsAction:IAction = null;
         var gameItems:Vector.<GameItem> = null;
         var itemId:Vector.<int> = param1;
         var successHandler:Function = param2;
         var failHandler:Function = param3;
         var successHandlerParams:Array = rest;
         if(gameItemsDictCache != null)
         {
            gameItems = this.getGameItemsVector(itemId);
            successHandler.apply(null,[gameItems].concat(successHandlerParams));
            return;
         }
         allGameItemsAction = this.getAllGameItemsAction();
         respondToAction(allGameItemsAction,function():void
         {
            var _loc1_:Vector.<GameItem> = getGameItemsVector(itemId);
            successHandler.apply(null,[_loc1_].concat(successHandlerParams));
         },function():void
         {
            failHandler(allGameItemsAction.getError());
         });
      }
      
      public function getAllGameItems(param1:Function, param2:Function) : void
      {
         var successHandler:Function = param1;
         var failHandler:Function = param2;
         var allGameItemsAction:IAction = this.getAllGameItemsAction();
         var sequence:SequenceAction = new SequenceAction();
         sequence.then(allGameItemsAction);
         sequence.getCompleted().addOnce(function():void
         {
            successHandler(gameItemsCache);
         });
         sequence.getErred().addOnce(function(param1:SequenceAction):void
         {
            failHandler(param1.getError());
         });
         sequence.invoke();
      }
      
      public function getAllGameItemsDictionary(param1:Function, param2:Function) : void
      {
         var successHandler:Function = param1;
         var failHandler:Function = param2;
         var allGameItemsAction:IAction = this.getAllGameItemsAction();
         var sequence:SequenceAction = new SequenceAction();
         sequence.then(allGameItemsAction);
         sequence.getCompleted().addOnce(function():void
         {
            successHandler(gameItemsDictCache);
         });
         sequence.getErred().addOnce(function(param1:SequenceAction):void
         {
            failHandler(param1.getError());
         });
         sequence.invoke();
      }
      
      public function getGameItemCategories(param1:Function, param2:Function) : void
      {
         var gameItemCategoriesAction:IAction;
         var sequence:SequenceAction;
         var successHandler:Function = param1;
         var failHandler:Function = param2;
         if(gameCategoriesCache != null)
         {
            successHandler(gameCategoriesCache);
            return;
         }
         gameItemCategoriesAction = this.getgameCategoriesAction();
         sequence = new SequenceAction();
         sequence.then(gameItemCategoriesAction);
         sequence.getCompleted().addOnce(function():void
         {
            successHandler(gameCategoriesCache);
         });
         sequence.getErred().addOnce(function(param1:SequenceAction):void
         {
            failHandler(param1.getError());
         });
         sequence.invoke();
      }
      
      protected function getAllGameItemsAction() : IAction
      {
         var _loc1_:SequenceAction = new SequenceAction();
         _loc1_.then(this.loadDataPackAction);
         _loc1_.then(this.loadColloqDataPackAction);
         _loc1_.thenCall(this.unmarshallAndCacheGameItems,null,true);
         _loc1_.invoke();
         return _loc1_;
      }
      
      protected function getgameCategoriesAction() : IAction
      {
         var _loc1_:SequenceAction = new SequenceAction();
         _loc1_.then(this.loadDataPackAction);
         _loc1_.then(this.loadColloqDataPackAction);
         _loc1_.thenCall(this.unmarshallAndCacheItemCategories,null,true);
         _loc1_.invoke();
         return _loc1_;
      }
      
      private function unmarshallAndCacheItemCategories() : Vector.<ItemCategory>
      {
         var _loc3_:Object = null;
         var _loc4_:ItemCategory = null;
         var _loc5_:String = null;
         var _loc6_:ItemTag = null;
         gameCategoriesCache = new Vector.<ItemCategory>();
         var _loc1_:Array = this.loadDataPackAction.data.categories;
         var _loc2_:Object = this.loadColloqDataPackAction.data;
         for each(_loc3_ in _loc1_)
         {
            _loc4_ = new ItemCategory();
            _loc4_.name = _loc3_.header;
            for each(_loc5_ in _loc3_.tags)
            {
               _loc6_ = new ItemTag(_loc5_);
               _loc6_.aliases = this.getAliasesForTag(_loc6_,_loc2_);
               _loc4_.tags.push(_loc6_);
            }
            gameCategoriesCache.push(_loc4_);
         }
         return gameCategoriesCache;
      }
      
      private function getAliasesForGameItem(param1:GameItem, param2:Object) : Vector.<String>
      {
         var _loc5_:Array = null;
         var _loc6_:String = null;
         var _loc3_:Vector.<String> = new Vector.<String>();
         if(!param2)
         {
            return _loc3_;
         }
         var _loc4_:String = param2["game_item_colloquialism_" + param1.id.toString()];
         if(_loc4_ != null && _loc4_.length > 0 && _loc4_ != ";")
         {
            _loc5_ = _loc4_.split(";");
            for each(_loc6_ in _loc5_)
            {
               if(_loc6_.length > 0)
               {
                  _loc3_.push(_loc6_);
               }
            }
         }
         return _loc3_;
      }
      
      private function getAliasesForTag(param1:ItemTag, param2:Object) : Vector.<String>
      {
         var _loc5_:Array = null;
         var _loc6_:String = null;
         var _loc3_:Vector.<String> = new Vector.<String>();
         if(!param2)
         {
            return _loc3_;
         }
         var _loc4_:String = param2["flash_itemShop_categories_colloquialism_" + param1.tag];
         if(_loc4_ != null && _loc4_.length > 0 && _loc4_ != ";")
         {
            _loc5_ = _loc4_.split(";");
            for each(_loc6_ in _loc5_)
            {
               if(_loc6_.length > 0)
               {
                  _loc3_.push(_loc6_);
               }
            }
         }
         return _loc3_;
      }
      
      private function unmarshallAndCacheGameItems() : Vector.<GameItem>
      {
         var _loc1_:GameItem = null;
         var _loc4_:Object = null;
         var _loc5_:uint = 0;
         var _loc6_:uint = 0;
         var _loc7_:String = null;
         var _loc8_:* = undefined;
         var _loc9_:Vector.<int> = null;
         var _loc10_:Vector.<ItemTag> = null;
         var _loc11_:String = null;
         var _loc12_:ItemTag = null;
         var _loc13_:Array = null;
         var _loc14_:int = 0;
         var _loc15_:GameItem = null;
         var _loc16_:GameItem = null;
         if(Boolean(gameItemsCache))
         {
            return gameItemsCache;
         }
         gameItemsDictCache = new Dictionary();
         gameItemsCache = new Vector.<GameItem>();
         var _loc2_:Object = this.loadDataPackAction.data.basicitem;
         var _loc3_:Object = this.loadColloqDataPackAction.data;
         for each(_loc4_ in this.loadDataPackAction.data.items)
         {
            _loc1_ = new GameItem();
            for(_loc7_ in _loc2_)
            {
               this.setItemProperty(_loc1_,_loc7_,_loc2_[_loc7_]);
            }
            for(_loc7_ in _loc2_.stats)
            {
               this.setItemProperty(_loc1_,_loc7_,_loc2_.stats[_loc7_]);
            }
            for(_loc7_ in _loc4_)
            {
               this.setItemProperty(_loc1_,_loc7_,_loc4_[_loc7_]);
            }
            for(_loc7_ in _loc4_.stats)
            {
               this.setItemProperty(_loc1_,_loc7_,_loc4_.stats[_loc7_]);
            }
            if(_loc4_.tags != null)
            {
               _loc10_ = new Vector.<ItemTag>();
               for each(_loc11_ in _loc4_.tags)
               {
                  _loc12_ = new ItemTag(_loc11_);
                  _loc12_.aliases = this.getAliasesForTag(_loc12_,_loc3_);
                  _loc10_.push(_loc12_);
               }
               _loc1_.tags = _loc10_;
            }
            _loc1_.name = RiotResourceLoader.getItemResourceString("name",_loc1_.id,"**" + _loc1_.id.toString());
            _loc1_.description = RiotResourceLoader.getItemResourceString("description",_loc1_.id,"**" + _loc1_.id.toString() + "_desc");
            _loc1_.aliases = this.getAliasesForGameItem(_loc1_,_loc3_);
            if(_loc4_.gold != null)
            {
               _loc1_.price = _loc4_.gold.base;
               _loc1_.totalPrice = _loc4_.gold.total;
               _loc1_.sellPrice = _loc4_.gold.sell;
            }
            else if(_loc2_.gold != null)
            {
               _loc1_.price = _loc2_.gold.base;
               _loc1_.totalPrice = _loc2_.gold.total;
               _loc1_.sellPrice = _loc2_.gold.sell;
            }
            gameItemsDictCache[_loc1_.id] = _loc1_;
            gameItemsCache[gameItemsCache.length] = _loc1_;
            _loc9_ = this.loadDataPackAction.restrictedMapItemData[int(_loc4_.id)] as Vector.<int>;
            if(Boolean(_loc9_))
            {
               _loc1_.restrictedMapIDs = _loc9_;
            }
         }
         _loc5_ = uint(this.loadDataPackAction.data.items.length);
         _loc6_ = 0;
         while(_loc6_ < _loc5_)
         {
            _loc13_ = this.loadDataPackAction.data.items[_loc6_].from;
            _loc1_ = gameItemsCache[_loc6_];
            if(_loc13_ != null && _loc13_.length > 0)
            {
               for each(_loc14_ in _loc13_)
               {
                  _loc15_ = gameItemsDictCache[_loc14_];
                  if(_loc15_ != null)
                  {
                     _loc1_.recipeItems[_loc1_.recipeItems.length] = _loc15_;
                     if(_loc15_.buildsTo.indexOf(_loc1_) === -1)
                     {
                        _loc15_.buildsTo[_loc15_.buildsTo.length] = _loc1_;
                     }
                  }
               }
            }
            if(_loc1_.specialRecipe > 1)
            {
               _loc16_ = gameItemsDictCache[_loc1_.specialRecipe];
               if(Boolean(_loc16_))
               {
                  _loc1_.recipeItems[_loc1_.recipeItems.length] = _loc16_;
                  if(_loc16_.buildsTo.indexOf(_loc1_) === -1)
                  {
                     _loc16_.buildsTo[_loc16_.buildsTo.length] = _loc1_;
                  }
               }
            }
            _loc6_++;
         }
         return gameItemsCache;
      }
      
      private function setItemProperty(param1:GameItem, param2:String, param3:*) : void
      {
         var _loc4_:String = null;
         for each(_loc4_ in [param2,RiotStringUtil.firstToLower(param2)])
         {
            if(param1.hasOwnProperty(_loc4_))
            {
               if(param3 is String)
               {
                  param3 = (param3 as String).replace(/dds/g,"png");
               }
               try
               {
                  param1[_loc4_] = param3;
               }
               catch(e:Error)
               {
               }
            }
         }
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

