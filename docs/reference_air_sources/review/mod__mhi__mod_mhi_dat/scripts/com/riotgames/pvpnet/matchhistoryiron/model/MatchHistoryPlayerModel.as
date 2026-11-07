package com.riotgames.pvpnet.matchhistoryiron.model
{
   import com.riotgames.platform.gameclient.domain.Champion;
   
   public class MatchHistoryPlayerModel
   {
      
      private var _champion:Champion;
      
      private var _summonerName:String;
      
      private var _summonerId:Number;
      
      private var _isYou:Boolean = false;
      
      public function MatchHistoryPlayerModel()
      {
         super();
      }
      
      public function get summonerName() : String
      {
         return this._summonerName;
      }
      
      public function set summonerName(param1:String) : void
      {
         this._summonerName = param1;
      }
      
      public function get champion() : Champion
      {
         return this._champion;
      }
      
      public function set champion(param1:Champion) : void
      {
         this._champion = param1;
      }
      
      public function get isYou() : Boolean
      {
         return this._isYou;
      }
      
      public function set isYou(param1:Boolean) : void
      {
         this._isYou = param1;
      }
      
      public function get summonerId() : Number
      {
         return this._summonerId;
      }
      
      public function set summonerId(param1:Number) : void
      {
         this._summonerId = param1;
      }
   }
}

