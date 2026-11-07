package blix.util.math
{
   public function snapNumber(param1:Number, param2:Number, param3:Number = 0) : Number
   {
      param1 -= param3;
      param1 /= param2;
      param1 = Math.round(param1);
      param1 *= param2;
      return param1 + param3;
   }
}

