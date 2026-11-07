package com.riotgames.pvpnet.matchhistoryiron.controller.action
{
   import blix.action.BasicAction;
   import com.riotgames.gameItems.dao.GameItemDao;
   import com.riotgames.gameItems.model.GameItem;
   import com.riotgames.platform.gameclient.configurations.PlayerInventoryConfig;
   import com.riotgames.platform.gameclient.domain.RawStat;
   import com.riotgames.pvpnet.matchhistoryiron.model.MatchHistoryStatModel;
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
   import mx.collections.ArrayCollection;
   
   public class FindGameItemAction extends BasicAction
   {
      
      private const ITEM_PREFIX:String = "ITEM";
      
      private var _model:MatchHistoryStatModel;
      
      private var _gameItemDao:GameItemDao;
      
      public function FindGameItemAction(param1:MatchHistoryStatModel, param2:GameItemDao)
      {
         super(false);
         this._model = param1;
         this._gameItemDao = param2;
      }
      
      override protected function doInvocation() : void
      {
         super.doInvocation();
         this.findItems();
      }
      
      private function findItems() : void
      {
         var _loc5_:RawStat = null;
         var _loc1_:ArrayCollection = this._model.stat.rawStats;
         var _loc2_:Vector.<int> = new Vector.<int>();
         var _loc3_:int = int(DynamicClientConfigManager.getConfiguration(PlayerInventoryConfig.NAMESPACE,PlayerInventoryConfig.NUM_ITEMS,PlayerInventoryConfig.numItemsDefault).getInt());
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            _loc5_ = RawStat.getRawStat(this.ITEM_PREFIX + _loc4_,_loc1_);
            if(_loc5_ != null)
            {
               _loc2_.push(_loc5_.value);
            }
            _loc4_++;
         }
         this._gameItemDao.getGameItemsById(_loc2_,this.onGetGameItemSucceed,this.onGetGameItemFail);
      }
      
      private function onGetGameItemFail(param1:Error) : void
      {
         err(param1);
      }
      
      private function onGetGameItemSucceed(param1:Vector.<GameItem>) : void
      {
         this._model.itemList = param1;
         complete();
      }
   }
}

