package com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.factory
{
   import blix.action.IAction;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.MatchHistoryParser;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.action.GetGameDetailsAction;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.action.GetGameTimelineAction;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.action.GetPlayerByAccountIDAction;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.action.GetRecentGamesForPlayerAction;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.action.UpdatePlayerCacheAction;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.MatchHistoryGame;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.MatchHistoryPlayer;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.NewMatchHistoryModel;
   
   public class MatchHistoryActionFactory
   {
      
      private var _model:NewMatchHistoryModel;
      
      private var _session:Session;
      
      private var _parser:MatchHistoryParser;
      
      public function MatchHistoryActionFactory(param1:NewMatchHistoryModel, param2:Session, param3:MatchHistoryParser)
      {
         super();
         this._model = param1;
         this._session = param2;
         this._parser = param3;
      }
      
      public function getPlayerInfo(param1:MatchHistoryPlayer) : IAction
      {
         return new GetPlayerByAccountIDAction(param1,this._parser);
      }
      
      public function getRecentGamesForPlayerAction(param1:MatchHistoryPlayer) : IAction
      {
         return new GetRecentGamesForPlayerAction(param1,this._parser,this);
      }
      
      public function updatePlayerCacheAction(param1:MatchHistoryPlayer) : IAction
      {
         return new UpdatePlayerCacheAction(param1,this._model);
      }
      
      public function getGameDetailsAction(param1:MatchHistoryGame) : IAction
      {
         return new GetGameDetailsAction(param1,this._parser,this);
      }
      
      public function getGameTimelineAction(param1:MatchHistoryGame) : IAction
      {
         return new GetGameTimelineAction(param1,this._parser);
      }
   }
}

