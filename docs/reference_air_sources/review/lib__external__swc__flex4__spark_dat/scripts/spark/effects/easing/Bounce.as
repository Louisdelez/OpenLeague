package spark.effects.easing
{
   import mx.effects.easing.Bounce;
   
   public class Bounce implements IEaser
   {
      
      public function Bounce()
      {
         super();
      }
      
      public function ease(fraction:Number) : Number
      {
         return mx.effects.easing.Bounce.easeOut(fraction,0,1,1);
      }
   }
}

