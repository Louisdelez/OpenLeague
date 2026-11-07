package blix.layout.vo
{
   import blix.util.math.clamp;
   
   public class MinMax
   {
      
      public var min:Number;
      
      public var max:Number;
      
      public function MinMax(param1:Number = 0, param2:Number = 10000)
      {
         super();
         if(isNaN(param1))
         {
            param1 = 0;
         }
         if(isNaN(param2))
         {
            param2 = 10000;
         }
         this.min = param1;
         this.max = param2;
      }
      
      public function clampValue(param1:Number) : Number
      {
         return clamp(param1,this.min,this.max);
      }
      
      public function bound(param1:MinMax) : void
      {
         if(param1 == null)
         {
            return;
         }
         this.min = Math.max(param1.min,this.min);
         this.max = Math.min(param1.max,this.max);
      }
      
      public function clone() : MinMax
      {
         return new MinMax(this.min,this.max);
      }
      
      public function toString() : String
      {
         return "[MinMax min=" + String(this.min) + ", max=" + String(this.max) + "]";
      }
   }
}

