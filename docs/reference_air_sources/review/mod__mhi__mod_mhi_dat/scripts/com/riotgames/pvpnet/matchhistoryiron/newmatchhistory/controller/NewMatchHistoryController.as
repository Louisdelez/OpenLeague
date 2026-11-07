package com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.controller
{
   import blix.action.IAction;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.factory.MatchHistoryActionFactory;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.MatchHistoryGame;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.MatchHistoryPlayer;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.NewMatchHistoryModel;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   
   public class NewMatchHistoryController
   {
      
      private var _model:NewMatchHistoryModel;
      
      private var _serviceCallActionFactory:MatchHistoryActionFactory;
      
      public function NewMatchHistoryController(param1:NewMatchHistoryModel, param2:MatchHistoryActionFactory)
      {
         super();
         this._model = param1;
         this._serviceCallActionFactory = param2;
      }
      
      public function showMatchHistoryForPlayer(param1:Number) : void
      {
         var _loc2_:MatchHistoryPlayer = null;
         this._model.setServiceErrorEncountered(false);
         _loc2_ = this._model.playerDictionary[param1];
         if(!_loc2_)
         {
            _loc2_ = new MatchHistoryPlayer();
            _loc2_.currentAccountId = param1;
            _loc2_.currentPlatformId = ClientConfig.instance.platformId;
            this._model.playerDictionary[param1] = _loc2_;
         }
         if(_loc2_ != this._model.getCurrentPlayer())
         {
            this._model.setCurrentPlayer(_loc2_);
            this._model.setCurrentGame(null);
         }
         this.getMatchHistoryPlayerDataIfNeeded();
      }
      
      public function viewGameDetails(param1:MatchHistoryGame) : void
      {
         if(this._model.getCurrentGame() != param1)
         {
            this._model.setCurrentGame(param1);
            this.getGameDetailsIfNeeded();
         }
      }
      
      private function getMatchHistoryPlayerDataIfNeeded() : void
      {
         var _loc2_:IAction = null;
         var _loc1_:MatchHistoryPlayer = this._model.getCurrentPlayer();
         if(!_loc1_)
         {
            return;
         }
         if(!_loc1_.playerInfoRetrieved && !_loc1_.getRetrievingPlayerInfo())
         {
            _loc2_ = this._serviceCallActionFactory.getPlayerInfo(_loc1_);
            _loc2_.getCompleted().addOnce(this.getMatchHistoryPlayerDataIfNeeded);
            _loc2_.getErred().addOnce(this.handleActionErred);
         }
         else if(!_loc1_.getRetrievingRecentGames())
         {
            _loc2_ = this._serviceCallActionFactory.getRecentGamesForPlayerAction(_loc1_);
            _loc2_.getErred().addOnce(this.handleActionErred);
         }
         if(_loc2_)
         {
            _loc2_.invoke();
         }
      }
      
      private function getGameDetailsIfNeeded() : void
      {
         var _loc2_:IAction = null;
         var _loc1_:MatchHistoryGame = this._model.getCurrentGame();
         if(!_loc1_)
         {
            return;
         }
         if(!_loc1_.getDetailsPopulated() && !_loc1_.getRetrievingDetails())
         {
            _loc2_ = this._serviceCallActionFactory.getGameDetailsAction(_loc1_);
            _loc2_.getErred().addOnce(this.handleActionErred);
            _loc2_.getCompleted().addOnce(this.getGameDetailsIfNeeded);
            _loc2_.invoke();
         }
         else if(!_loc1_.getTimelineRetrieved() && !_loc1_.getRetrievingTimeline())
         {
            _loc2_ = this._serviceCallActionFactory.getGameTimelineAction(_loc1_);
            _loc2_.getErred().addOnce(this.handleActionErred);
            _loc2_.invoke();
         }
      }
      
      private function handleActionErred() : void
      {
         this._model.setServiceErrorEncountered(true);
      }
   }
}

