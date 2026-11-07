package com.riotgames.pvpnet.endofgamegiftwindow.models.dto
{
   import com.riotgames.pvpnet.endofgamegiftwindow.models.IJSONserializable;
   
   public class LoadGiftsRequestDTO implements IJSONserializable
   {
      
      private var _senderSummonerID:Number;
      
      private var _recipientSummonerID:Number;
      
      private var _gameID:Number;
      
      private var _queueType:String;
      
      private var _language:String;
      
      public function LoadGiftsRequestDTO(param1:Number, param2:Number, param3:Number, param4:String, param5:String)
      {
         super();
         this._senderSummonerID = param1;
         this._recipientSummonerID = param2;
         this._gameID = param3;
         this._queueType = param4;
         this._language = param5;
      }
      
      public function toJSONString() : String
      {
         var _loc1_:Object = new Object();
         _loc1_.senderSummonerId = this._senderSummonerID;
         _loc1_.recipientSummonerId = this._recipientSummonerID;
         _loc1_.gameId = this._gameID;
         _loc1_.queue = this._queueType;
         _loc1_.language = this._language;
         return JSON.stringify(_loc1_);
      }
   }
}

