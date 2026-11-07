package mx.effects.easing
{
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class Quartic
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public function Quartic()
      {
         super();
      }
      
      public static function easeIn(t:Number, b:Number, c:Number, d:Number) : Number
      {
         return c * (t = t / d) * t * t * t + b;
      }
      
      public static function easeInOut(t:Number, b:Number, c:Number, d:Number) : Number
      {
         t = t / (d / 2);
         if(t < 1)
         {
            return c / 2 * t * t * t * t + b;
         }
         return -c / 2 * ((t = t - 2) * t * t * t - 2) + b;
      }
      
      public static function easeOut(t:Number, b:Number, c:Number, d:Number) : Number
      {
         return -c * ((t = t / d - 1) * t * t * t - 1) + b;
      }
   }
}

