package com.riotgames.pvpnet.endofgamegiftwindow.models.gift
{
   public class GiftCurrencyData
   {
      
      private var _showCurrencyGroup:Boolean;
      
      private var _currencyName:String;
      
      private var _currencyAmount:Number;
      
      private var _currencyType:String;
      
      public function GiftCurrencyData(param1:String, param2:Number, param3:String, param4:Boolean)
      {
         super();
         this._currencyName = param1;
         this._currencyAmount = param2;
         this._currencyType = param3;
         this._showCurrencyGroup = param4;
      }
      
      public function get currencyName() : String
      {
         return this._currencyName;
      }
      
      public function get currencyAmount() : Number
      {
         return this._currencyAmount;
      }
      
      public function get currencyType() : String
      {
         return this._currencyType;
      }
      
      public function get showCurrencyGroup() : Boolean
      {
         return this._showCurrencyGroup;
      }
   }
}

