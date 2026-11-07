package com.riotgames.pvpnet.tracker.parts
{
   public class BasicStatisticsCalculator
   {
      
      public function BasicStatisticsCalculator()
      {
         super();
      }
      
      public static function calculateQuartiles(param1:Array, param2:RecordingSummary) : RecordingSummary
      {
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         if(param1 == null || param1.length == 0)
         {
            return param2;
         }
         if(param1.length == 1)
         {
            param2.q1 = param2.q3 = param2.median = param1[0];
            return param2;
         }
         param1.sort(Array.NUMERIC);
         var _loc3_:Number = param1.length;
         var _loc4_:Number = _loc3_ / 2;
         var _loc5_:Number = (_loc3_ + 1) / 4;
         var _loc6_:Number = 3 * (_loc3_ + 1) / 4;
         var _loc7_:Number = Math.floor(_loc4_);
         if(Boolean(param1.length % 2))
         {
            param2.median = param1[_loc7_];
         }
         else
         {
            param2.median = (param1[_loc7_ - 1] + param1[_loc7_]) / 2;
         }
         var _loc12_:Number = Math.floor(_loc5_);
         if(Boolean(_loc12_ % 2))
         {
            param2.q1 = param1[_loc12_];
         }
         else
         {
            _loc9_ = Number(param1[_loc12_ - 1]);
            _loc10_ = Number(param1[_loc12_]);
            _loc11_ = _loc10_ - _loc9_;
            _loc8_ = _loc5_ - int(_loc5_);
            param2.q1 = _loc9_ + _loc11_ * _loc8_;
         }
         var _loc13_:Number = Math.floor(_loc6_);
         if(Boolean(_loc13_ % 2))
         {
            param2.q3 = param1[_loc13_];
         }
         else
         {
            _loc9_ = Number(param1[_loc13_ - 1]);
            _loc10_ = Number(param1[_loc13_]);
            _loc11_ = _loc10_ - _loc9_;
            _loc8_ = _loc6_ - int(_loc6_);
            param2.q3 = _loc9_ + _loc11_ * _loc8_;
         }
         return param2;
      }
      
      public static function getNumWithSetDec(param1:Number, param2:Number) : Number
      {
         var _loc3_:Number = Math.pow(10,param2 || 0);
         return Boolean(param2) ? Math.round(_loc3_ * param1) / _loc3_ : param1;
      }
      
      public static function getAverageFromNumArr(param1:Array, param2:Number) : Number
      {
         var _loc3_:Number = param1.length;
         var _loc4_:Number = 0;
         while(Boolean(_loc3_--))
         {
            _loc4_ += param1[_loc3_];
         }
         return getNumWithSetDec(_loc4_ / param1.length,param2);
      }
      
      public static function getVariance(param1:Array, param2:Number) : Number
      {
         var _loc3_:Number = getAverageFromNumArr(param1,param2);
         var _loc4_:Number = param1.length;
         var _loc5_:Number = 0;
         while(Boolean(_loc4_--))
         {
            _loc5_ += Math.pow(param1[_loc4_] - _loc3_,2);
         }
         _loc5_ /= param1.length;
         return getNumWithSetDec(_loc5_,param2);
      }
      
      public static function getStandardDeviation(param1:Array, param2:Number, param3:RecordingSummary) : Number
      {
         var _loc4_:Number = Math.sqrt(getVariance(param1,param2));
         var _loc5_:Number = getNumWithSetDec(_loc4_,param2);
         param3.std_dev = _loc5_;
         return _loc5_;
      }
   }
}

