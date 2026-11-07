package com.riotgames.pvpnet.endofgamegiftwindow.models.gift
{
   public class GiftTitleData
   {
      
      private var _giftTitleText:String;
      
      private var _giftSubTitleText:String;
      
      private var _giftType:String;
      
      public function GiftTitleData(param1:String, param2:String, param3:String)
      {
         super();
         this._giftTitleText = param1;
         this._giftSubTitleText = param2;
         this._giftType = param3;
      }
      
      public function get giftTitleText() : String
      {
         return this._giftTitleText;
      }
      
      public function get giftSubTitleText() : String
      {
         return this._giftSubTitleText;
      }
      
      public function get giftType() : String
      {
         return this._giftType;
      }
   }
}

