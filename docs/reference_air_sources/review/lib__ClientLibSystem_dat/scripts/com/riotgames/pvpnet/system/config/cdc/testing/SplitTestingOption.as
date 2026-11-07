package com.riotgames.pvpnet.system.config.cdc.testing
{
   public class SplitTestingOption
   {
      
      private var _value:String;
      
      private var _weight:Number;
      
      public function SplitTestingOption(param1:String, param2:Number)
      {
         super();
         this._value = param1;
         this._weight = param2;
      }
      
      public function getValue() : String
      {
         return this._value;
      }
      
      public function getWeight() : Number
      {
         return this._weight;
      }
   }
}

