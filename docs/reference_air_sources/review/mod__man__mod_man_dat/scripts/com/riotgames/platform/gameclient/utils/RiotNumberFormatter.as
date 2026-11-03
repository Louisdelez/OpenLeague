package com.riotgames.platform.gameclient.utils
{
   import mx.formatters.NumberFormatter;
   
   public class RiotNumberFormatter extends NumberFormatter
   {
      
      private var _setPrecision:int;
      
      public function RiotNumberFormatter()
      {
         super();
      }
      
      override public function format(param1:Object) : String
      {
         var _loc2_:String = null;
         if((param1 as Number) - int(param1) < 0.1)
         {
            this._setPrecision = this.precision as int;
            this.precision = 0;
            _loc2_ = super.format(param1);
            this.precision = this._setPrecision;
         }
         else
         {
            _loc2_ = super.format(param1);
         }
         return _loc2_;
      }
   }
}

