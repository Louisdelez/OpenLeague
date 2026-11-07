package spark.effects.easing
{
   public class Sine extends EaseInOutBase
   {
      
      public function Sine(easeInFraction:Number = 0.5)
      {
         super(easeInFraction);
      }
      
      override protected function easeIn(fraction:Number) : Number
      {
         return 1 - Math.cos(fraction * Math.PI / 2);
      }
      
      override protected function easeOut(fraction:Number) : Number
      {
         return Math.sin(fraction * Math.PI / 2);
      }
   }
}

