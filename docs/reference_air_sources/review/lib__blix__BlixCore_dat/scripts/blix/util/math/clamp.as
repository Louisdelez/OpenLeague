package blix.util.math
{
   public function clamp(param1:Number, param2:Number, param3:Number) : Number
   {
      return Math.max(Math.min(param1,param3),param2);
   }
}

