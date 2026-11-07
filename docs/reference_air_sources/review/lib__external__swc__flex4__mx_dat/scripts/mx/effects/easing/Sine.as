package mx.effects.easing
{
   [Alternative(replacement="spark.effects.easing.Sine",since="4.0")]
   public class Sine
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function Sine()
      {
         super();
      }
      
      public static function easeIn(t:Number, b:Number, c:Number, d:Number) : Number
      {
         return -c * Math.cos(t / d * (Math.PI / 2)) + c + b;
      }
      
      public static function easeOut(t:Number, b:Number, c:Number, d:Number) : Number
      {
         return c * Math.sin(t / d * (Math.PI / 2)) + b;
      }
      
      public static function easeInOut(t:Number, b:Number, c:Number, d:Number) : Number
      {
         return -c / 2 * (Math.cos(Math.PI * t / d) - 1) + b;
      }
   }
}

