package mx.effects.easing
{
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class Bounce
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public function Bounce()
      {
         super();
      }
      
      public static function easeIn(t:Number, b:Number, c:Number, d:Number) : Number
      {
         return c - easeOut(d - t,0,c,d) + b;
      }
      
      public static function easeInOut(t:Number, b:Number, c:Number, d:Number) : Number
      {
         if(t < d / 2)
         {
            return easeIn(t * 2,0,c,d) * 0.5 + b;
         }
         return easeOut(t * 2 - d,0,c,d) * 0.5 + c * 0.5 + b;
      }
      
      public static function easeOut(t:Number, b:Number, c:Number, d:Number) : Number
      {
         t = t / d;
         if(t < 1 / 2.75)
         {
            return c * (7.5625 * t * t) + b;
         }
         if(t < 2 / 2.75)
         {
            return c * (7.5625 * (t = t - 1.5 / 2.75) * t + 0.75) + b;
         }
         if(t < 2.5 / 2.75)
         {
            return c * (7.5625 * (t = t - 2.25 / 2.75) * t + 0.9375) + b;
         }
         return c * (7.5625 * (t = t - 2.625 / 2.75) * t + 0.984375) + b;
      }
   }
}

