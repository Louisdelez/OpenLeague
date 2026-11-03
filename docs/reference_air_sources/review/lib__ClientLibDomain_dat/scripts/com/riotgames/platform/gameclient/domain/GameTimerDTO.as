package com.riotgames.platform.gameclient.domain
{
   [RemoteClass(alias="com.riotgames.platform.game.GameTimerDTO")]
   public class GameTimerDTO
   {
      
      private var _currentGameState:String;
      
      private var _remainingTimeInMillis:Number;
      
      public function GameTimerDTO()
      {
         super();
      }
      
      public function set remainingTimeInMillis(param1:Number) : void
      {
         this._remainingTimeInMillis = param1;
      }
      
      public function get currentGameState() : String
      {
         return this._currentGameState;
      }
      
      public function toString() : String
      {
         return "Game State: " + this.currentGameState + " - Remaining Time In State: " + this.remainingTimeInMillis;
      }
      
      public function set currentGameState(param1:String) : void
      {
         this._currentGameState = param1;
      }
      
      public function get remainingTimeInMillis() : Number
      {
         return this._remainingTimeInMillis;
      }
   }
}

