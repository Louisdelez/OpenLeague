package com.riotgames.pvpnet.endofgamegiftwindow.models.gift
{
   public class CustomMessageConfigData
   {
      
      private var _hintText:String;
      
      private var _hintTextColor:Number;
      
      private var _textColor:Number;
      
      private var _borderColor:Number;
      
      private var _backgroundColor:Number;
      
      public function CustomMessageConfigData(param1:String, param2:Number, param3:Number, param4:Number, param5:Number)
      {
         super();
         this._hintText = param1;
         this._hintTextColor = param2;
         this._textColor = param3;
         this._borderColor = param4;
         this._backgroundColor = param5;
      }
      
      public function get hintText() : String
      {
         return this._hintText;
      }
      
      public function get hintTextColor() : Number
      {
         return this._hintTextColor;
      }
      
      public function get textColor() : Number
      {
         return this._textColor;
      }
      
      public function get borderColor() : Number
      {
         return this._borderColor;
      }
      
      public function get backgroundColor() : Number
      {
         return this._backgroundColor;
      }
   }
}

