package blix.util.math
{
   public function mean(param1:Array) : Number
   {
      var _loc3_:Number = NaN;
      var _loc2_:Number = 0;
      for each(_loc3_ in param1)
      {
         _loc2_ += _loc3_;
      }
      return _loc2_ / param1.length;
   }
}

