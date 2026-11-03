package blix.effects.easing
{
   public class Bounce implements IEaser
   {
      
      public function Bounce()
      {
         super();
      }
      
      public function ease(param1:Number) : Number
      {
         if(param1 < 1 / 2.75)
         {
            return 7.5625 * param1 * param1;
         }
         if(param1 < 2 / 2.75)
         {
            return 7.5625 * (param1 = param1 - 1.5 / 2.75) * param1 + 0.75;
         }
         if(param1 < 2.5 / 2.75)
         {
            return 7.5625 * (param1 = param1 - 2.25 / 2.75) * param1 + 0.9375;
         }
         return 7.5625 * (param1 = param1 - 2.625 / 2.75) * param1 + 0.984375;
      }
   }
}

