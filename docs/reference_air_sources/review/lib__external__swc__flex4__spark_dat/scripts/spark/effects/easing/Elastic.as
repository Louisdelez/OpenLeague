package spark.effects.easing
{
   import mx.effects.easing.Elastic;
   
   public class Elastic implements IEaser
   {
      
      public function Elastic()
      {
         super();
      }
      
      public function ease(fraction:Number) : Number
      {
         return mx.effects.easing.Elastic.easeOut(fraction,0,1,1);
      }
   }
}

