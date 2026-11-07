package com.riotgames.pvpnet.matchhistoryiron.newmatchhistory.model
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import flash.utils.Dictionary;
   
   public class NewMatchHistoryModel
   {
      
      public var playerDictionary:Dictionary = new Dictionary();
      
      private var _currentPlayer:MatchHistoryPlayer;
      
      private var _currentPlayerChanged:Signal = new Signal();
      
      private var _currentGame:MatchHistoryGame;
      
      private var _currentGameChanged:Signal = new Signal();
      
      private var _serviceErrorEncountered:Boolean = false;
      
      private var _serviceErrorEncounteredChanged:Signal = new Signal();
      
      public function NewMatchHistoryModel()
      {
         super();
      }
      
      public function getCurrentPlayer() : MatchHistoryPlayer
      {
         return this._currentPlayer;
      }
      
      public function setCurrentPlayer(param1:MatchHistoryPlayer) : void
      {
         if(param1 != this._currentPlayer)
         {
            this._currentPlayer = param1;
            this._currentPlayerChanged.dispatch();
         }
      }
      
      public function getCurrentPlayerChanged() : ISignal
      {
         return this._currentPlayerChanged;
      }
      
      public function getCurrentGame() : MatchHistoryGame
      {
         return this._currentGame;
      }
      
      public function setCurrentGame(param1:MatchHistoryGame) : void
      {
         if(param1 != this._currentGame)
         {
            this._currentGame = param1;
            this._currentGameChanged.dispatch();
         }
      }
      
      public function getCurrentGameChanged() : ISignal
      {
         return this._currentGameChanged;
      }
      
      public function getServiceErrorEncountered() : Boolean
      {
         return this._serviceErrorEncountered;
      }
      
      public function setServiceErrorEncountered(param1:Boolean) : void
      {
         if(param1 != this._serviceErrorEncountered)
         {
            this._serviceErrorEncountered = param1;
            this._serviceErrorEncounteredChanged.dispatch();
         }
      }
      
      public function getServiceErrorEncounteredChanged() : ISignal
      {
         return this._serviceErrorEncounteredChanged;
      }
   }
}

