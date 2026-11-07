package com.riotgames.pvpnet.endofgamegiftwindow.models.player
{
   public class SessionPlayer implements ISessionPlayer
   {
      
      private var _accountID:Number;
      
      private var _summonerID:Number;
      
      private var _summonerName:String;
      
      private var _playerLevel:Number;
      
      private var _localeString:String;
      
      private var _rp:Number;
      
      private var _giftsSent:Number;
      
      public function SessionPlayer(param1:Number, param2:Number, param3:String, param4:Number, param5:String, param6:Number)
      {
         super();
         this._accountID = param1;
         this._summonerID = param2;
         this._summonerName = param3;
         this._playerLevel = param4;
         this._localeString = param5;
         this._rp = param6;
      }
      
      public function get accountID() : Number
      {
         return this._accountID;
      }
      
      public function get summonerID() : Number
      {
         return this._summonerID;
      }
      
      public function get summonerName() : String
      {
         return this._summonerName;
      }
      
      public function get playerLevel() : Number
      {
         return this._playerLevel;
      }
      
      public function get localeString() : String
      {
         return this._localeString;
      }
      
      public function get rp() : Number
      {
         return this._rp;
      }
      
      public function get giftsSentThisSession() : Number
      {
         return this._giftsSent;
      }
      
      public function set giftsSentThisSession(param1:Number) : void
      {
         this._giftsSent = param1;
      }
   }
}

