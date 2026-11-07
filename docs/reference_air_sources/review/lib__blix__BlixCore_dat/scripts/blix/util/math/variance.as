package blix.util.math
{
   public function variance(param1:Array) : Number
   {
      var _loc4_:Number = NaN;
      var _loc2_:Number = mean(param1);
      var _loc3_:Number = 0;
      for each(_loc4_ in param1)
      {
         _loc3_ += Math.pow(_loc4_ - _loc2_,2);
      }
      return _loc3_ / param1.length;
   }
}

