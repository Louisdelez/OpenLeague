package com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.action
{
   import blix.action.IAction;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.MatchHistoryParser;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.factory.MatchHistoryActionFactory;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.MatchHistoryPlayer;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.MatchHistoryRecentGames;
   
   public class GetRecentGamesForPlayerAction extends MatchHistoryServiceAction
   {
      
      private var _matchHistoryPlayer:MatchHistoryPlayer;
      
      private var _accountId:Number;
      
      private var _platformId:String;
      
      private var _parser:MatchHistoryParser;
      
      private var _actionFactory:MatchHistoryActionFactory;
      
      public function GetRecentGamesForPlayerAction(param1:MatchHistoryPlayer, param2:MatchHistoryParser, param3:MatchHistoryActionFactory)
      {
         super();
         this._matchHistoryPlayer = param1;
         this._accountId = param1.accountId;
         this._platformId = param1.platformId;
         this._parser = param2;
         this._actionFactory = param3;
      }
      
      override protected function buildEndpointURL(param1:String) : String
      {
         return param1 + "/stats/player_history/" + this._platformId + "/" + this._accountId + "?begIndex=0&endIndex=20&queue=0&queue=2&queue=4&queue=6&queue=7&queue=8&queue=9&queue=14&queue=16&queue=17&queue=25&queue=31&queue=32&queue=33&queue=41&queue=42&queue=52&queue=61&queue=65&queue=70&queue=73&queue=76&queue=78&queue=83&queue=91&queue=92&queue=93&queue=96";
      }
      
      override protected function parseData(param1:String) : Object
      {
         return this._parser.getPlayerRecentGames(param1);
      }
      
      override protected function doInvocation() : void
      {
         super.doInvocation();
         this._matchHistoryPlayer.setRetrievingRecentGames(true);
      }
      
      override protected function handleData(param1:Object) : void
      {
         var _loc3_:IAction = null;
         var _loc2_:MatchHistoryRecentGames = param1 as MatchHistoryRecentGames;
         this._matchHistoryPlayer.setRecentGames(param1 as MatchHistoryRecentGames);
         if(_loc2_.games.length)
         {
            _loc3_ = this._actionFactory.updatePlayerCacheAction(_loc2_.games[0].searchedParticipant.player);
            _loc3_.invoke();
         }
      }
      
      override protected function onCompleted() : void
      {
         super.onCompleted();
         this._matchHistoryPlayer.setRetrievingRecentGames(false);
      }
      
      override protected function onErred(param1:Error) : void
      {
         super.onErred(param1);
         this._matchHistoryPlayer.setRetrievingRecentGames(false);
      }
      
      override protected function onAborted() : void
      {
         super.onAborted();
         this._matchHistoryPlayer.setRetrievingRecentGames(false);
      }
   }
}

