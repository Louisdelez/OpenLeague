package spark.effects.interpolation
{
   public class RGBInterpolator implements IInterpolator
   {
      
      private static var theInstance:RGBInterpolator;
      
      public function RGBInterpolator()
      {
         super();
      }
      
      public static function getInstance() : RGBInterpolator
      {
         if(!theInstance)
         {
            theInstance = new RGBInterpolator();
         }
         return theInstance;
      }
      
      public function interpolate(fraction:Number, startValue:Object, endValue:Object) : Object
      {
         var startR:int = 0;
         var startG:int = 0;
         var startB:int = 0;
         var endR:int = 0;
         var endG:int = 0;
         var endB:int = 0;
         var deltaR:int = 0;
         var deltaG:int = 0;
         var deltaB:int = 0;
         if(fraction == 0)
         {
            return startValue;
         }
         if(fraction == 1)
         {
            return endValue;
         }
         fraction = Math.min(1,Math.max(0,fraction));
         startR = (uint(startValue) & 0xFF0000) >> 16;
         startG = (uint(startValue) & 0xFF00) >> 8;
         startB = uint(startValue) & 0xFF;
         endR = (uint(endValue) & 0xFF0000) >> 16;
         endG = (uint(endValue) & 0xFF00) >> 8;
         endB = uint(endValue) & 0xFF;
         deltaR = endR - startR;
         deltaG = endG - startG;
         deltaB = endB - startB;
         var newR:uint = startR + deltaR * fraction;
         var newG:uint = startG + deltaG * fraction;
         var newB:uint = startB + deltaB * fraction;
         return newR << 16 | newG << 8 | newB;
      }
      
      private function combine(baseValue:uint, deltaValue:uint, increment:Boolean) : Object
      {
         var newR:uint = 0;
         var newG:uint = 0;
         var newB:uint = 0;
         var baseR:int = (baseValue & 0xFF0000) >> 16;
         var baseG:int = (baseValue & 0xFF00) >> 8;
         var baseB:int = baseValue & 0xFF;
         var deltaR:int = (deltaValue & 0xFF0000) >> 16;
         var deltaG:int = (deltaValue & 0xFF00) >> 8;
         var deltaB:int = deltaValue & 0xFF;
         if(increment)
         {
            newR = Math.min(baseR + deltaR,255);
            newG = Math.min(baseG + deltaG,255);
            newB = Math.min(baseB + deltaB,255);
         }
         else
         {
            newR = Math.max(baseR - deltaR,0);
            newG = Math.max(baseG - deltaG,0);
            newB = Math.max(baseB - deltaB,0);
         }
         return newR << 16 | newG << 8 | newB;
      }
      
      public function increment(baseValue:Object, incrementValue:Object) : Object
      {
         return this.combine(uint(baseValue),uint(incrementValue),true);
      }
      
      public function decrement(baseValue:Object, decrementValue:Object) : Object
      {
         return this.combine(uint(baseValue),uint(decrementValue),false);
      }
   }
}

