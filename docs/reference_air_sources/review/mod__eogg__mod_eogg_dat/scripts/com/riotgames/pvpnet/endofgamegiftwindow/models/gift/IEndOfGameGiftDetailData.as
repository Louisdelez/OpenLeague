package com.riotgames.pvpnet.endofgamegiftwindow.models.gift
{
   import blix.ds.IListX;
   
   public interface IEndOfGameGiftDetailData extends IEndOfGameGift
   {
      
      function get giftTitleDisplayData() : GiftTitleData;
      
      function get giftRecipientData() : GiftRecipientData;
      
      function get giftCurrencyData() : GiftCurrencyData;
      
      function get giftDetailDisplayData() : GiftDetailDisplayData;
      
      function get giftDetailTitle() : String;
      
      function get giftMessage() : String;
      
      function get customMessageConfig() : CustomMessageConfigData;
      
      function get giftRecipientName() : String;
      
      function get toText() : String;
      
      function get showCurrency() : Boolean;
      
      function get currencyName() : String;
      
      function get buttonLabel() : String;
      
      function get giftDropDownLabel() : String;
      
      function get giftDropDownNoneSelectedLabel() : String;
      
      function get giftDropDownDataProvider() : IListX;
   }
}

