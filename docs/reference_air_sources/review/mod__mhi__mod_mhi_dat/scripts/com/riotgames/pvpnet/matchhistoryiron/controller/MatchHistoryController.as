package com.riotgames.pvpnet.matchhistoryiron.controller
{
   import com.riotgames.platform.common.provider.IInventoryController;
   import com.riotgames.platform.common.provider.IInventoryProvider;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.pvpnet.matchhistoryiron.controller.action.GetRecentGamePlayedAction;
   import com.riotgames.pvpnet.matchhistoryiron.controller.action.GetSummonerNameAction;
   import com.riotgames.pvpnet.matchhistoryiron.model.MatchHistoryModel;
   import com.riotgames.pvpnet.matchhistoryiron.model.MatchHistoryStatModel;
   
   public class MatchHistoryController
   {
      
      private var _model:MatchHistoryModel;
      
      private var _serviceProxy:ServiceProxy;
      
      private var _session:Session;
      
      private var _inventoryController:IInventoryController;
      
      public function MatchHistoryController(param1:IInventoryProvider)
      {
         super();
         this._serviceProxy = ServiceProxy.instance;
         this._session = Session.instance;
         this._inventoryController = param1.getInventoryController();
      }
      
      public function setModel(param1:MatchHistoryModel) : void
      {
         this._model = param1;
      }
      
      public function getRecentGames(param1:Number) : void
      {
         var _loc2_:Number = NaN;
         if(param1 != 0)
         {
            _loc2_ = param1;
         }
         else
         {
            _loc2_ = Number(this._session.summoner.acctId);
         }
         var _loc3_:GetRecentGamePlayedAction = new GetRecentGamePlayedAction(_loc2_,this._model,this._serviceProxy.playerStatsService,this._inventoryController);
         _loc3_.invoke();
      }
      
      public function onGameClicked(param1:MatchHistoryStatModel) : void
      {
         var _loc2_:GetSummonerNameAction = new GetSummonerNameAction(param1,ServiceProxy.instance.summonerService);
         _loc2_.invoke();
      }
   }
}

