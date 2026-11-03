package com.riotgames.pvpnet.endofgamegiftwindow.models.gift
{
   public class EndOfGameGift implements IEndOfGameGift
   {
      
      private var _itemInventoryType:String;
      
      private var _itemID:Number;
      
      private var _itemName:String;
      
      private var _itemDescription:String;
      
      private var _currencyType:String;
      
      private var _itemCost:Number;
      
      private var _playerCanAfford:Boolean;
      
      private var _iconURL:String;
      
      private var _detailImageURL:String;
      
      public function EndOfGameGift(param1:String, param2:Number, param3:String, param4:String, param5:String, param6:Number, param7:String, param8:String)
      {
         super();
         this._itemInventoryType = param1;
         this._itemName = param3;
         this._itemDescription = param4;
         this._itemID = param2;
         this._currencyType = param5;
         this._itemCost = param6;
         this._iconURL = param7;
         this._detailImageURL = param8;
      }
      
      public function get itemInventoryType() : String
      {
         return this._itemInventoryType;
      }
      
      public function get itemName() : String
      {
         return this._itemName;
      }
      
      public function get itemDescription() : String
      {
         return this._itemDescription;
      }
      
      public function get itemID() : Number
      {
         return this._itemID;
      }
      
      public function get currencyType() : String
      {
         return this._currencyType;
      }
      
      public function get itemCost() : Number
      {
         return this._itemCost;
      }
      
      public function get iconURL() : String
      {
         return this._iconURL;
      }
      
      public function get detailImageURL() : String
      {
         return this._detailImageURL;
      }
   }
}

