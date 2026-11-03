package com.riotgames.pvpnet.endofgamegiftwindow.models.gift
{
   public class GiftDetailDisplayData
   {
      
      private var _giftTitleData:GiftTitleData;
      
      private var _giftRecipientData:GiftRecipientData;
      
      private var _giftCurrencyData:GiftCurrencyData;
      
      private var _unlockButtonLabel:String;
      
      public function GiftDetailDisplayData(param1:GiftTitleData, param2:GiftRecipientData, param3:GiftCurrencyData, param4:String)
      {
         super();
         this._giftTitleData = param1;
         this._giftRecipientData = param2;
         this._giftCurrencyData = param3;
         this._unlockButtonLabel = param4;
      }
      
      public function get giftTitleData() : GiftTitleData
      {
         return this._giftTitleData;
      }
      
      public function get giftRecipientData() : GiftRecipientData
      {
         return this._giftRecipientData;
      }
      
      public function get giftCurrencyData() : GiftCurrencyData
      {
         return this._giftCurrencyData;
      }
      
      public function get unlockButtonLabel() : String
      {
         return this._unlockButtonLabel;
      }
   }
}

