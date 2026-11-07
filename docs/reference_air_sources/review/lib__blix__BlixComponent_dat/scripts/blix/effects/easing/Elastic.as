package blix.effects.easing
{
   public class Elastic implements IEaser
   {
      
      public function Elastic()
      {
         super();
      }
      
      public function ease(param1:Number) : Number
      {
         if(param1 == 0)
         {
            return 0;
         }
         if(param1 == 1)
         {
            return 1;
         }
         return Math.pow(2,-10 * param1) * Math.sin((param1 - 0.3 / 4) * (2 * Math.PI) / 0.3) + 1;
      }
   }
}

