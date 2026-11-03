package mx.effects.easing
{
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class Exponential
   {
      
      mx_internal static const VERSION:String = "4.6.0.23201";
      
      public function Exponential()
      {
         super();
      }
      
      public static function easeIn(t:Number, b:Number, c:Number, d:Number) : Number
      {
         return t == 0 ? b : c * Math.pow(2,10 * (t / d - 1)) + b;
      }
      
      public static function easeOut(t:Number, b:Number, c:Number, d:Number) : Number
      {
         return t == d ? b + c : c * (-Math.pow(2,-10 * t / d) + 1) + b;
      }
      
      public static function easeInOut(t:Number, b:Number, c:Number, d:Number) : Number
      {
         if(t == 0)
         {
            return b;
         }
         if(t == d)
         {
            return b + c;
         }
         t = t / (d / 2);
         if(t < 1)
         {
            return c / 2 * Math.pow(2,10 * (t - 1)) + b;
         }
         return c / 2 * (-Math.pow(2,-10 * --t) + 2) + b;
      }
   }
}

