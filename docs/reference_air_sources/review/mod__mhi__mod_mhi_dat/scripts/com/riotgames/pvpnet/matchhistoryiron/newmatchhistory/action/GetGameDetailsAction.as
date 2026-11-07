package com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.action
{
   import blix.action.IAction;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.MatchHistoryParser;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.factory.MatchHistoryActionFactory;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.MatchHistoryGame;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.MatchHistoryGameParticipant;
   
   public class GetGameDetailsAction extends MatchHistoryServiceAction
   {
      
      private var _game:MatchHistoryGame;
      
      private var _parser:MatchHistoryParser;
      
      private var _actionFactory:MatchHistoryActionFactory;
      
      public function GetGameDetailsAction(param1:MatchHistoryGame, param2:MatchHistoryParser, param3:MatchHistoryActionFactory)
      {
         super();
         this._game = param1;
         this._parser = param2;
         this._actionFactory = param3;
      }
      
      override protected function doInvocation() : void
      {
         if(!this._game || this._game.getRetrievingDetails() || !this._game.gameId || this._game.getDetailsPopulated())
         {
            abort();
            return;
         }
         this._game.setRetrievingDetails(true);
         super.doInvocation();
      }
      
      override protected function buildEndpointURL(param1:String) : String
      {
         return param1 + "/stats/game/" + this._game.platformId + "/" + this._game.gameId;
      }
      
      override protected function parseData(param1:String) : Object
      {
         return this._parser.getDetailedGame(param1);
      }
      
      override protected function handleData(param1:Object) : void
      {
         var _loc3_:MatchHistoryGameParticipant = null;
         var _loc4_:IAction = null;
         var _loc2_:MatchHistoryGame = param1 as MatchHistoryGame;
         this._game.gameType = _loc2_.gameType;
         this._game.gameMode = _loc2_.gameMode;
         this._game.participants = _loc2_.participants;
         this._game.participantsDict = _loc2_.participantsDict;
         this._game.teams = _loc2_.teams;
         this._game.setDetailsPopulated(true);
         for each(_loc3_ in this._game.participants)
         {
            _loc4_ = this._actionFactory.updatePlayerCacheAction(_loc3_.player);
            _loc4_.invoke();
         }
      }
      
      override protected function onCompleted() : void
      {
         this._game.setRetrievingDetails(false);
         super.onCompleted();
      }
      
      override protected function onAborted() : void
      {
         this._game.setRetrievingDetails(false);
         super.onAborted();
      }
      
      override protected function onErred(param1:Error) : void
      {
         this._game.setRetrievingDetails(false);
         super.onErred(param1);
      }
   }
}

