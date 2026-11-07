package com.riotgames.championdetails.dao
{
   import blix.action.SequenceAction;
   import blix.action.sql.SQLConnectionAction;
   import blix.action.sql.SQLStatementAction;
   import blix.context.Context;
   import blix.logger.Logger;
   import com.riotgames.championdetails.model.ChampionAbility;
   import com.riotgames.championdetails.model.ChampionInfo;
   import com.riotgames.championdetails.model.ChampionSkin;
   import com.riotgames.gameItems.model.RecommendedItem;
   import com.riotgames.store.model.ChampionSearchTag;
   import flash.data.SQLMode;
   import flash.data.SQLResult;
   import flash.data.SQLStatement;
   import flash.filesystem.File;
   
   public class ChampionDetailsDao extends Context implements IChampionDetailsDao
   {
      
      private var sqlConnectionAction:SQLConnectionAction;
      
      private var logger:Logger;
      
      public function ChampionDetailsDao(param1:String, param2:Context)
      {
         super(param2);
         this.logger = new Logger(this);
         var _loc3_:File = new File("app:/assets/data/gameStats/gameStats_" + param1 + ".sqlite");
         this.sqlConnectionAction = new SQLConnectionAction(_loc3_,false,SQLMode.READ);
      }
      
      public function getChampionInfoById(param1:int, param2:Function, param3:Function) : void
      {
         var championInfoByIdAction:SQLStatementAction = null;
         var championAbilitiesAction:SQLStatementAction = null;
         var championSkinsAction:SQLStatementAction = null;
         var championSearchTagsAction:SQLStatementAction = null;
         var recommendedItemsAction:SQLStatementAction = null;
         var sequence:SequenceAction = null;
         var championId:int = param1;
         var successHandler:Function = param2;
         var failHandler:Function = param3;
         this.logger.logInfo("Loading champion: " + championId);
         championInfoByIdAction = this.getChampionInfoByIdAction(championId);
         championAbilitiesAction = this.getChampionAbilitiesAction(championId);
         championSkinsAction = this.getChampionSkinsAction(championId);
         championSearchTagsAction = this.getChampionSearchTagsAction(championId);
         recommendedItemsAction = this.getRecommendedItemsByChampionIdAction(championId);
         sequence = new SequenceAction();
         sequence.then(this.sqlConnectionAction);
         sequence.then(championInfoByIdAction);
         sequence.and(championAbilitiesAction);
         sequence.and(championSkinsAction);
         sequence.and(championSearchTagsAction);
         sequence.and(recommendedItemsAction);
         sequence.getCompleted().addOnce(function():void
         {
            var _loc1_:Vector.<ChampionInfo> = championInfoByIdAction.unmarshalledResult;
            if(_loc1_.length == 0)
            {
               successHandler(null);
               return;
            }
            var _loc2_:ChampionInfo = _loc1_[0];
            _loc2_.abilities = championAbilitiesAction.unmarshalledResult;
            _loc2_.skins = championSkinsAction.unmarshalledResult;
            _loc2_.searchTags = championSearchTagsAction.unmarshalledResult;
            _loc2_.recommendedItems = recommendedItemsAction.unmarshalledResult;
            successHandler(_loc2_);
         });
         sequence.getErred().addOnce(function():void
         {
            failHandler(sequence.getError());
         });
         sequence.invoke();
      }
      
      protected function getChampionInfoByIdAction(param1:int) : SQLStatementAction
      {
         var _loc2_:SQLStatement = new SQLStatement();
         _loc2_.sqlConnection = this.sqlConnectionAction.sqlConnection;
         _loc2_.text = "SELECT * FROM champions WHERE id=:id;";
         _loc2_.parameters[":id"] = param1;
         var _loc3_:SQLStatementAction = new SQLStatementAction(_loc2_);
         _loc3_.unmarshallResultFunction = this.unmarshallChampionInfos;
         return _loc3_;
      }
      
      protected function unmarshallChampionInfos(param1:SQLResult) : Vector.<ChampionInfo>
      {
         var _loc3_:Object = null;
         var _loc4_:ChampionInfo = null;
         var _loc5_:String = null;
         var _loc2_:Vector.<ChampionInfo> = new Vector.<ChampionInfo>();
         for each(_loc3_ in param1.data)
         {
            _loc4_ = new ChampionInfo();
            for(_loc5_ in _loc3_)
            {
               if(_loc4_.hasOwnProperty(_loc5_))
               {
                  _loc4_[_loc5_] = _loc3_[_loc5_];
               }
            }
            _loc2_[_loc2_.length] = _loc4_;
         }
         return _loc2_;
      }
      
      public function getChampionAbilities(param1:int, param2:Function, param3:Function) : void
      {
         var championAbilitiesAction:SQLStatementAction = null;
         var sequence:SequenceAction = null;
         var championId:int = param1;
         var successHandler:Function = param2;
         var failHandler:Function = param3;
         championAbilitiesAction = this.getChampionAbilitiesAction(championId);
         sequence = new SequenceAction();
         sequence.then(this.sqlConnectionAction);
         sequence.and(championAbilitiesAction);
         sequence.getCompleted().addOnce(function():void
         {
            successHandler(championAbilitiesAction.unmarshalledResult);
         });
         sequence.getErred().addOnce(function():void
         {
            failHandler(sequence.getError());
         });
         sequence.invoke();
      }
      
      protected function getChampionAbilitiesAction(param1:int) : SQLStatementAction
      {
         var _loc2_:SQLStatement = new SQLStatement();
         _loc2_.sqlConnection = this.sqlConnectionAction.sqlConnection;
         _loc2_.text = "SELECT * FROM championAbilities WHERE championId=:championId ORDER BY rank ASC";
         _loc2_.parameters[":championId"] = param1;
         var _loc3_:SQLStatementAction = new SQLStatementAction(_loc2_);
         _loc3_.unmarshallResultFunction = this.unmarshallChampionAbilities;
         return _loc3_;
      }
      
      private function unmarshallChampionAbilities(param1:SQLResult) : Vector.<ChampionAbility>
      {
         var _loc3_:Object = null;
         var _loc4_:ChampionAbility = null;
         var _loc5_:String = null;
         var _loc2_:Vector.<ChampionAbility> = new Vector.<ChampionAbility>();
         for each(_loc3_ in param1.data)
         {
            _loc4_ = new ChampionAbility();
            for(_loc5_ in _loc3_)
            {
               if(_loc4_.hasOwnProperty(_loc5_))
               {
                  _loc4_[_loc5_] = _loc3_[_loc5_];
               }
            }
            _loc2_[_loc2_.length] = _loc4_;
         }
         return _loc2_;
      }
      
      public function getChampionSkins(param1:int, param2:Function, param3:Function) : void
      {
         var championSkinsAction:SQLStatementAction = null;
         var sequence:SequenceAction = null;
         var championId:int = param1;
         var successHandler:Function = param2;
         var failHandler:Function = param3;
         championSkinsAction = this.getChampionSkinsAction(championId);
         sequence = new SequenceAction();
         sequence.then(this.sqlConnectionAction);
         sequence.and(championSkinsAction);
         sequence.getCompleted().addOnce(function():void
         {
            successHandler(championSkinsAction.unmarshalledResult);
         });
         sequence.getErred().addOnce(function():void
         {
            failHandler(sequence.getError());
         });
         sequence.invoke();
      }
      
      protected function getChampionSkinsAction(param1:int) : SQLStatementAction
      {
         var _loc2_:SQLStatement = new SQLStatement();
         _loc2_.sqlConnection = this.sqlConnectionAction.sqlConnection;
         _loc2_.text = "SELECT * FROM championSkins WHERE championId=:championId ORDER BY rank ASC";
         _loc2_.parameters[":championId"] = param1;
         var _loc3_:SQLStatementAction = new SQLStatementAction(_loc2_);
         _loc3_.unmarshallResultFunction = this.unmarshallChampionSkins;
         return _loc3_;
      }
      
      protected function unmarshallChampionSkins(param1:SQLResult) : Vector.<ChampionSkin>
      {
         var _loc3_:Object = null;
         var _loc4_:ChampionSkin = null;
         var _loc5_:String = null;
         var _loc2_:Vector.<ChampionSkin> = new Vector.<ChampionSkin>();
         for each(_loc3_ in param1.data)
         {
            _loc4_ = new ChampionSkin();
            for(_loc5_ in _loc3_)
            {
               if(_loc4_.hasOwnProperty(_loc5_))
               {
                  _loc4_[_loc5_] = _loc3_[_loc5_];
               }
            }
            _loc2_[_loc2_.length] = _loc4_;
         }
         return _loc2_;
      }
      
      protected function getChampionSearchTagsAction(param1:int) : SQLStatementAction
      {
         var _loc2_:SQLStatement = new SQLStatement();
         _loc2_.sqlConnection = this.sqlConnectionAction.sqlConnection;
         _loc2_.text = "SELECT searchTags.* FROM championSearchTags INNER JOIN searchTags ON searchTags.id = championSearchTags.searchTagId WHERE championSearchTags.championId=:championId";
         _loc2_.parameters[":championId"] = param1;
         var _loc3_:SQLStatementAction = new SQLStatementAction(_loc2_);
         _loc3_.unmarshallResultFunction = this.unmarshallSearchTags;
         return _loc3_;
      }
      
      private function unmarshallSearchTags(param1:SQLResult) : Vector.<ChampionSearchTag>
      {
         var _loc3_:Object = null;
         var _loc4_:ChampionSearchTag = null;
         var _loc5_:String = null;
         var _loc2_:Vector.<ChampionSearchTag> = new Vector.<ChampionSearchTag>();
         for each(_loc3_ in param1.data)
         {
            _loc4_ = new ChampionSearchTag();
            for(_loc5_ in _loc3_)
            {
               if(_loc4_.hasOwnProperty(_loc5_))
               {
                  _loc4_[_loc5_] = _loc3_[_loc5_];
               }
            }
            _loc2_[_loc2_.length] = _loc4_;
         }
         return _loc2_;
      }
      
      protected function getRecommendedItemsByChampionIdAction(param1:int) : SQLStatementAction
      {
         var _loc2_:SQLStatement = new SQLStatement();
         _loc2_.sqlConnection = this.sqlConnectionAction.sqlConnection;
         _loc2_.text = "SELECT * FROM championItems WHERE championId=:id";
         _loc2_.parameters[":id"] = param1;
         var _loc3_:SQLStatementAction = new SQLStatementAction(_loc2_);
         _loc3_.unmarshallResultFunction = this.unmarshallRecommendedGameItems;
         return _loc3_;
      }
      
      private function unmarshallRecommendedGameItems(param1:SQLResult) : Object
      {
         var _loc3_:Object = null;
         var _loc4_:RecommendedItem = null;
         var _loc5_:String = null;
         var _loc2_:Vector.<RecommendedItem> = new Vector.<RecommendedItem>();
         for each(_loc3_ in param1.data)
         {
            _loc4_ = new RecommendedItem();
            for(_loc5_ in _loc3_)
            {
               if(_loc4_.hasOwnProperty(_loc5_))
               {
                  _loc4_[_loc5_] = _loc3_[_loc5_];
               }
            }
            _loc2_[_loc2_.length] = _loc4_;
         }
         return _loc2_;
      }
   }
}

