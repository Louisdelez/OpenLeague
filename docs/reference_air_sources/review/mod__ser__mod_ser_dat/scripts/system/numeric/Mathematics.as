package system.numeric
{
   import flash.errors.IllegalOperationError;
   
   public class Mathematics
   {
      
      public function Mathematics()
      {
         super();
      }
      
      public static function interpolate(param1:Number, param2:Number, param3:Number) : Number
      {
         return param2 + (param3 - param2) * param1;
      }
      
      public static function map(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number) : Number
      {
         return interpolate(normalize(param1,param2,param3),param4,param5);
      }
      
      public static function sign(param1:Number) : Number
      {
         if(isNaN(param1))
         {
            throw new IllegalOperationError("Mathematics.sign, the passed-in value not must be NaN.");
         }
         return param1 < 0 ? -1 : 1;
      }
      
      public static function ceil(param1:Number, param2:Number) : Number
      {
         if(isNaN(param1))
         {
            return NaN;
         }
         var _loc3_:Number = 1;
         var _loc4_:Number = -1;
         while(++_loc4_ < param2)
         {
            _loc3_ *= 10;
         }
         return Math.ceil(param1 * _loc3_) / _loc3_;
      }
      
      public static function gcd(param1:int, param2:int) : int
      {
         var _loc3_:int = 0;
         if(param2 == 0)
         {
            return param1;
         }
         if(param1 == param2)
         {
            return param1;
         }
         while(param2 != 0)
         {
            _loc3_ = param2;
            param2 = param1 % param2;
            param1 = _loc3_;
         }
         return param1;
      }
      
      public static function percentage(param1:Number = NaN, param2:Number = NaN) : Number
      {
         var _loc3_:Number = param1 / param2 * 100;
         return isNaN(_loc3_) || !isFinite(_loc3_) ? NaN : _loc3_;
      }
      
      public static function clamp(param1:Number, param2:Number, param3:Number) : Number
      {
         if(isNaN(param1))
         {
            return NaN;
         }
         if(isNaN(param2))
         {
            param2 = param1;
         }
         if(isNaN(param3))
         {
            param3 = param1;
         }
         return Math.max(Math.min(param1,param3),param2);
      }
      
      public static function floor(param1:Number, param2:Number) : Number
      {
         if(isNaN(param1))
         {
            return NaN;
         }
         var _loc3_:Number = 1;
         var _loc4_:Number = -1;
         while(++_loc4_ < param2)
         {
            _loc3_ *= 10;
         }
         return Math.floor(param1 * _loc3_) / _loc3_;
      }
      
      public static function normalize(param1:Number, param2:Number, param3:Number) : Number
      {
         return (param1 - param2) / (param3 - param2);
      }
      
      public static function round(param1:Number, param2:Number) : Number
      {
         if(isNaN(param1))
         {
            return NaN;
         }
         var _loc3_:Number = 1;
         var _loc4_:Number = -1;
         while(++_loc4_ < param2)
         {
            _loc3_ *= 10;
         }
         return Math.round(param1 * _loc3_) / _loc3_;
      }
   }
}

