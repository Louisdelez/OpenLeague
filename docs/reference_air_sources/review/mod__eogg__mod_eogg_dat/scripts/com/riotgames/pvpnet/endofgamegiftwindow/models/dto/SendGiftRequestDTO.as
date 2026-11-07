package com.riotgames.pvpnet.endofgamegiftwindow.models.dto
{
   import com.riotgames.pvpnet.endofgamegiftwindow.models.IJSONserializable;
   import com.riotgames.pvpnet.endofgamegiftwindow.models.gift.IEndOfGameGift;
   
   public class SendGiftRequestDTO implements IJSONserializable
   {
      
      private var _sessionPlayerAccountID:Number;
      
      private var _sessionPlayerSummonerID:Number;
      
      private var _recipientSummonerID:Number;
      
      private var _giftMessage:String;
      
      private var _queueType:String;
      
      private var _gameID:Number;
      
      private var _giftItem:IEndOfGameGift;
      
      public function SendGiftRequestDTO(param1:Number, param2:Number, param3:Number, param4:String, param5:String, param6:Number, param7:IEndOfGameGift)
      {
         super();
         this._sessionPlayerAccountID = param1;
         this._sessionPlayerSummonerID = param2;
         this._recipientSummonerID = param3;
         this._giftMessage = param4;
         this._queueType = param5;
         this._gameID = param6;
         this._giftItem = param7;
      }
      
      public function toJSONString() : String
      {
         var _loc1_:Object = new Object();
         _loc1_.itemId = this._giftItem.itemID;
         _loc1_.inventoryType = this._giftItem.itemInventoryType;
         _loc1_.rpCost = this._giftItem.itemCost;
         _loc1_.iconUrl = this._giftItem.iconURL;
         _loc1_.name = this._giftItem.itemName;
         _loc1_.description = this._giftItem.itemDescription;
         var _loc2_:Object = new Object();
         _loc2_.accountId = this._sessionPlayerAccountID;
         _loc2_.senderSummonerId = this._sessionPlayerSummonerID;
         _loc2_.recipientSummonerId = this._recipientSummonerID;
         _loc2_.customMessage = this._giftMessage;
         _loc2_.queue = this._queueType;
         _loc2_.gameId = this._gameID;
         _loc2_.itemGift = _loc1_;
         return JSON.stringify(_loc2_);
      }
   }
}

