package com.riotgames.pvpnet.endofgamegiftwindow.models.gift
{
   import blix.ds.IListX;
   
   public class EndOfGameGiftDetailData implements IEndOfGameGiftDetailData
   {
      
      private var _giftDetailTitle:String;
      
      private var _recipientName:String;
      
      private var _toText:String;
      
      private var _showCurrency:Boolean;
      
      private var _currencyName:String;
      
      private var _giftData:IEndOfGameGift;
      
      private var _customMessageConfig:CustomMessageConfigData;
      
      private var _buttonLabel:String;
      
      private var _giftMessage:String;
      
      private var _giftDropDownData:GiftMessageDropDownData;
      
      private var _unlockButtonLabel:String;
      
      public function EndOfGameGiftDetailData(param1:String, param2:String, param3:String, param4:Boolean, param5:String, param6:IEndOfGameGift, param7:CustomMessageConfigData, param8:String, param9:String, param10:GiftMessageDropDownData, param11:String)
      {
         super();
         this._giftDetailTitle = param1;
         this._recipientName = param2;
         this._toText = param3;
         this._showCurrency = param4;
         this._currencyName = param5;
         this._giftData = param6;
         this._customMessageConfig = param7;
         this._giftMessage = param9;
         this._buttonLabel = param8;
         this._giftDropDownData = param10;
         this._unlockButtonLabel = param11;
      }
      
      public function get giftTitleDisplayData() : GiftTitleData
      {
         return new GiftTitleData(this._giftData.itemName,this._giftData.itemDescription,this._giftData.itemInventoryType);
      }
      
      public function get giftRecipientData() : GiftRecipientData
      {
         return new GiftRecipientData(this._toText,this._recipientName);
      }
      
      public function get giftCurrencyData() : GiftCurrencyData
      {
         return new GiftCurrencyData(this._currencyName,this._giftData.itemCost,this._giftData.currencyType,this._showCurrency);
      }
      
      public function get giftDetailDisplayData() : GiftDetailDisplayData
      {
         return new GiftDetailDisplayData(this.giftTitleDisplayData,this.giftRecipientData,this.giftCurrencyData,this._unlockButtonLabel);
      }
      
      public function get giftDetailTitle() : String
      {
         return this._giftDetailTitle;
      }
      
      public function get customMessageConfig() : CustomMessageConfigData
      {
         return this._customMessageConfig;
      }
      
      public function get giftRecipientName() : String
      {
         return this._recipientName;
      }
      
      public function get toText() : String
      {
         return this._toText;
      }
      
      public function get showCurrency() : Boolean
      {
         return this._showCurrency;
      }
      
      public function get currencyName() : String
      {
         return this._currencyName;
      }
      
      public function get itemInventoryType() : String
      {
         return this._giftData.itemInventoryType;
      }
      
      public function get itemName() : String
      {
         return this._giftData.itemName;
      }
      
      public function get itemDescription() : String
      {
         return this._giftData.itemDescription;
      }
      
      public function get itemID() : Number
      {
         return this._giftData.itemID;
      }
      
      public function get currencyType() : String
      {
         return this._giftData.currencyType;
      }
      
      public function get itemCost() : Number
      {
         return this._giftData.itemCost;
      }
      
      public function get iconURL() : String
      {
         return this._giftData.iconURL;
      }
      
      public function get detailImageURL() : String
      {
         return this._giftData.detailImageURL;
      }
      
      public function get giftMessage() : String
      {
         return this._giftMessage;
      }
      
      public function get buttonLabel() : String
      {
         return this._buttonLabel;
      }
      
      public function get giftDropDownLabel() : String
      {
         return this._giftDropDownData.label;
      }
      
      public function get giftDropDownNoneSelectedLabel() : String
      {
         return this._giftDropDownData.noneSelectedLabel;
      }
      
      public function get giftDropDownDataProvider() : IListX
      {
         return this._giftDropDownData.listData;
      }
   }
}

