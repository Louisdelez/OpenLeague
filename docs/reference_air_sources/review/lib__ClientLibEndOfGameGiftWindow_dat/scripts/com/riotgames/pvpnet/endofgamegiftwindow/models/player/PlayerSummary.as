package com.riotgames.pvpnet.endofgamegiftwindow.models.player
{
   public class PlayerSummary implements IPlayerSummary
   {
      
      private var _summonerID:Number;
      
      private var _summonerName:String;
      
      private var _skinName:String;
      
      private var _isBuddy:Boolean;
      
      private var _playerLevel:Number;
      
      private var _gameID:Number;
      
      private var _queueType:String;
      
      public function PlayerSummary(param1:Number, param2:String, param3:String, param4:Boolean, param5:Number, param6:Number, param7:String)
      {
         super();
         this._summonerID = param1;
         this._summonerName = param2;
         this._skinName = param3;
         this._isBuddy = param4;
         this._playerLevel = param5;
         this._gameID = param6;
         this._queueType = param7;
      }
      
      public function get summonerID() : Number
      {
         return this._summonerID;
      }
      
      public function get summonerName() : String
      {
         return this._summonerName;
      }
      
      public function get skinName() : String
      {
         return this._skinName;
      }
      
      public function get isBuddy() : Boolean
      {
         return this._isBuddy;
      }
      
      public function get playerLevel() : Number
      {
         return this._playerLevel;
      }
      
      public function get gameID() : Number
      {
         return this._gameID;
      }
      
      public function get queueType() : String
      {
         return this._queueType;
      }
   }
}

