package com.riotgames.pvpnet.endofgamegiftwindow.models.gift
{
   public class GiftErrorData implements IGiftErrorData
   {
      
      private var _errorID:Number;
      
      private var _errorTitleText:String;
      
      private var _errorText:String;
      
      private var _errorInfoText:String;
      
      private var _errorInfoLink:String;
      
      private var _doneButtonLabel:String;
      
      public function GiftErrorData(param1:Number, param2:String, param3:String, param4:String, param5:String, param6:String)
      {
         super();
         this._errorID = param1;
         this._errorTitleText = param2;
         this._errorText = param3;
         this._errorInfoText = param4;
         this._errorInfoLink = param5;
         this._doneButtonLabel = param6;
      }
      
      public function get errorID() : Number
      {
         return this._errorID;
      }
      
      public function get errorTitleText() : String
      {
         return this._errorTitleText;
      }
      
      public function get errorText() : String
      {
         return this._errorText;
      }
      
      public function get errorInfoText() : String
      {
         return this._errorInfoText;
      }
      
      public function get errorInfoLink() : String
      {
         return this._errorInfoLink;
      }
      
      public function get doneButtonLabel() : String
      {
         return this._doneButtonLabel;
      }
   }
}

