package com.riotgames.pvpnet.matchhistoryiron.controller.action
{
   import blix.action.BasicAction;
   import com.riotgames.gameItems.dao.GameItemDao;
   import com.riotgames.platform.common.provider.IInventoryController;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.domain.PlayerGameStats;
   import com.riotgames.platform.gameclient.domain.RecentGames;
   import com.riotgames.platform.gameclient.services.PlayerStatsService;
   import com.riotgames.pvpnet.matchhistoryiron.model.MatchHistoryModel;
   import com.riotgames.pvpnet.matchhistoryiron.model.MatchHistoryStatModel;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import mx.collections.ArrayCollection;
   import mx.collections.Sort;
   import mx.collections.SortField;
   import mx.rpc.events.ResultEvent;
   
   public class GetRecentGamePlayedAction extends BasicAction
   {
      
      private const DATE_FIELD:String = "createDate";
      
      private var _service:PlayerStatsService;
      
      private var _model:MatchHistoryModel;
      
      private var _acctId:Number;
      
      private var _inventoryController:IInventoryController;
      
      private var _recentGameStatList:Vector.<PlayerGameStats>;
      
      private var _gameModelList:Vector.<MatchHistoryStatModel>;
      
      private var _gameItemDao:GameItemDao;
      
      public function GetRecentGamePlayedAction(param1:Number, param2:MatchHistoryModel, param3:PlayerStatsService, param4:IInventoryController)
      {
         super(false);
         this._service = param3;
         this._model = param2;
         this._acctId = param1;
         this._inventoryController = param4;
         this._gameItemDao = new GameItemDao(ClientConfig.instance.locale,null);
      }
      
      override protected function doInvocation() : void
      {
         super.doInvocation();
         this._service.getRecentGames(this._acctId,this.onRetrieveRecentGamesSuccess,this.onRetrieveRecentGamesComplete);
      }
      
      private function onRetrieveRecentGamesSuccess(param1:ResultEvent) : void
      {
         var _loc3_:PlayerGameStats = null;
         var _loc2_:RecentGames = param1.result as RecentGames;
         this._gameModelList = new Vector.<MatchHistoryStatModel>();
         this._recentGameStatList = new Vector.<PlayerGameStats>();
         if(_loc2_)
         {
            this.sortRecentGames(_loc2_);
            for each(_loc3_ in _loc2_.gameStatistics)
            {
               this._recentGameStatList.push(_loc3_);
            }
            this.validateNextGameStat();
         }
         else
         {
            err(new Error("Match history : There is no recent game list received "));
         }
      }
      
      private function retreiveGameStat() : void
      {
         var _loc1_:PlayerGameStats = this._recentGameStatList.shift();
         RiotResourceLoader.loadStatisticResourceStrings(_loc1_.statistics as ArrayCollection);
         var _loc2_:MatchHistoryStatModel = new MatchHistoryStatModel();
         _loc2_.stat = _loc1_;
         this._gameModelList.push(_loc2_);
         var _loc3_:CreateLegacyGameStatAction = new CreateLegacyGameStatAction(_loc2_,this._inventoryController);
         var _loc4_:FindGameItemAction = new FindGameItemAction(_loc2_,this._gameItemDao);
         _loc3_.invoke();
         _loc4_.getCompleted().addOnce(this.onRetreiveItem);
         _loc4_.invoke();
      }
      
      private function onRetreiveItem() : void
      {
         this.validateNextGameStat();
      }
      
      private function validateNextGameStat() : void
      {
         if(this._recentGameStatList.length > 0)
         {
            this.retreiveGameStat();
         }
         else
         {
            this._model.updateModel(this._gameModelList,this._acctId);
            complete();
         }
      }
      
      private function onRetrieveRecentGamesComplete(param1:Object = null) : void
      {
      }
      
      private function sortRecentGames(param1:RecentGames) : void
      {
         var _loc2_:Sort = new Sort();
         var _loc3_:SortField = new SortField(this.DATE_FIELD,false,true);
         _loc2_.fields = [_loc3_];
         param1.gameStatistics.sort = _loc2_;
         param1.gameStatistics.filterFunction = this.filterOutTutorialGames;
         param1.gameStatistics.refresh();
      }
      
      private function filterOutTutorialGames(param1:PlayerGameStats) : Boolean
      {
         return param1.gameType != "TUTORIAL_GAME";
      }
   }
}

