package com.riotgames.pvpnet.endofgamegiftwindow.models.gift
{
   public class GiftRecipientData
   {
      
      private var _toFieldText:String;
      
      private var _recipientName:String;
      
      public function GiftRecipientData(param1:String, param2:String)
      {
         super();
         this._toFieldText = param1;
         this._recipientName = param2;
      }
      
      public function get toFieldText() : String
      {
         return this._toFieldText;
      }
      
      public function get recipientName() : String
      {
         return this._recipientName;
      }
   }
}

