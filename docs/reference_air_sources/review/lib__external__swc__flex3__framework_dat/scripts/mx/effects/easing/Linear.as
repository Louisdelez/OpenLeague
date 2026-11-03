package mx.effects.easing
{
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class Linear
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public function Linear()
      {
         super();
      }
      
      public static function easeOut(t:Number, b:Number, c:Number, d:Number) : Number
      {
         return c * t / d + b;
      }
      
      public static function easeIn(t:Number, b:Number, c:Number, d:Number) : Number
      {
         return c * t / d + b;
      }
      
      public static function easeNone(t:Number, b:Number, c:Number, d:Number) : Number
      {
         return c * t / d + b;
      }
      
      public static function easeInOut(t:Number, b:Number, c:Number, d:Number) : Number
      {
         return c * t / d + b;
      }
   }
}

