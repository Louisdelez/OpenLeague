package com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   
   public class MatchHistoryPlayer
   {
      
      public var accountId:Number = -1;
      
      public var platformId:String = null;
      
      public var currentAccountId:Number = -1;
      
      public var currentPlatformId:String = null;
      
      public var playerInfoRetrieved:Boolean = false;
      
      private var _retrievingPlayerInfo:Boolean = false;
      
      private var _retrievingPlayerInfoChanged:Signal = new Signal();
      
      private var _retrievingRecentGames:Boolean = false;
      
      private var _retrievingRecentGamesChanged:Signal = new Signal();
      
      private var _recentGames:MatchHistoryRecentGames;
      
      private var _recentGamesChanged:Signal = new Signal();
      
      public var matchHistoryUri:String = "";
      
      public var summonerName:String = "";
      
      public var profileIcon:int = 0;
      
      public function MatchHistoryPlayer()
      {
         super();
      }
      
      public function setRetrievingPlayerInfo(param1:Boolean) : void
      {
         if(this._retrievingPlayerInfo != param1)
         {
            this._retrievingPlayerInfo = param1;
            this._retrievingPlayerInfoChanged.dispatch();
         }
      }
      
      public function getRetrievingPlayerInfo() : Boolean
      {
         return this._retrievingPlayerInfo;
      }
      
      public function getRetrievingPlayerInfoChanged() : ISignal
      {
         return this._retrievingPlayerInfoChanged;
      }
      
      public function setRetrievingRecentGames(param1:Boolean) : void
      {
         if(this._retrievingRecentGames != param1)
         {
            this._retrievingRecentGames = param1;
            this._retrievingRecentGamesChanged.dispatch();
         }
      }
      
      public function getRetrievingRecentGames() : Boolean
      {
         return this._retrievingRecentGames;
      }
      
      public function getRetrievingRecentGamesChanged() : ISignal
      {
         return this._retrievingRecentGamesChanged;
      }
      
      public function setRecentGames(param1:MatchHistoryRecentGames) : void
      {
         if(param1 != this._recentGames)
         {
            this._recentGames = param1;
            this._recentGamesChanged.dispatch();
         }
      }
      
      public function getRecentGames() : MatchHistoryRecentGames
      {
         return this._recentGames;
      }
      
      public function getRecentGamesChanged() : ISignal
      {
         return this._recentGamesChanged;
      }
   }
}

