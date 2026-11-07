package com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.action
{
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.MatchHistoryParser;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.MatchHistoryPlayer;
   import com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model.MatchHistoryPlayerInfo;
   
   public class GetPlayerByAccountIDAction extends MatchHistoryServiceAction
   {
      
      private var _matchHistoryPlayer:MatchHistoryPlayer;
      
      private var _accountId:Number;
      
      private var _parser:MatchHistoryParser;
      
      private var _platformId:String;
      
      public function GetPlayerByAccountIDAction(param1:MatchHistoryPlayer, param2:MatchHistoryParser)
      {
         super();
         this._matchHistoryPlayer = param1;
         this._accountId = param1.currentAccountId;
         this._platformId = param1.currentPlatformId;
         this._parser = param2;
      }
      
      override protected function doInvocation() : void
      {
         super.doInvocation();
         this._matchHistoryPlayer.setRetrievingPlayerInfo(true);
      }
      
      override protected function buildEndpointURL(param1:String) : String
      {
         return param1 + "/players/current?region=" + this._platformId + "&account=" + this._accountId;
      }
      
      override protected function parseData(param1:String) : Object
      {
         return this._parser.getPlayerInfo(param1);
      }
      
      override protected function handleData(param1:Object) : void
      {
         var _loc2_:MatchHistoryPlayerInfo = param1 as MatchHistoryPlayerInfo;
         this._matchHistoryPlayer.accountId = _loc2_.accountId;
         this._matchHistoryPlayer.platformId = _loc2_.platformId;
         this._matchHistoryPlayer.playerInfoRetrieved = true;
      }
      
      override protected function onCompleted() : void
      {
         super.onCompleted();
         this._matchHistoryPlayer.setRetrievingPlayerInfo(false);
      }
      
      override protected function onErred(param1:Error) : void
      {
         super.onErred(param1);
         this._matchHistoryPlayer.setRetrievingPlayerInfo(false);
      }
      
      override protected function onAborted() : void
      {
         super.onAborted();
         this._matchHistoryPlayer.setRetrievingPlayerInfo(false);
      }
   }
}

