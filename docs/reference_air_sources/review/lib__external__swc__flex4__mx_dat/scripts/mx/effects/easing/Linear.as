package mx.effects.easing
{
   [Alternative(replacement="spark.effects.easing.Linear",since="4.0")]
   public class Linear
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function Linear()
      {
         super();
      }
      
      public static function easeNone(t:Number, b:Number, c:Number, d:Number) : Number
      {
         return c * t / d + b;
      }
      
      public static function easeIn(t:Number, b:Number, c:Number, d:Number) : Number
      {
         return c * t / d + b;
      }
      
      public static function easeOut(t:Number, b:Number, c:Number, d:Number) : Number
      {
         return c * t / d + b;
      }
      
      public static function easeInOut(t:Number, b:Number, c:Number, d:Number) : Number
      {
         return c * t / d + b;
      }
   }
}

