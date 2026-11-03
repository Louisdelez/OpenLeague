package spark.effects.easing
{
   public class EaseInOutBase implements IEaser
   {
      
      private var _easeInFraction:Number = 0.5;
      
      public function EaseInOutBase(easeInFraction:Number = 0.5)
      {
         super();
         this.easeInFraction = easeInFraction;
      }
      
      [Inspectable(minValue="0.0",maxValue="1.0")]
      public function get easeInFraction() : Number
      {
         return this._easeInFraction;
      }
      
      public function set easeInFraction(value:Number) : void
      {
         this._easeInFraction = value;
      }
      
      public function ease(fraction:Number) : Number
      {
         var easeOutFraction:Number = 1 - this.easeInFraction;
         if(fraction <= this.easeInFraction && this.easeInFraction > 0)
         {
            return this.easeInFraction * this.easeIn(fraction / this.easeInFraction);
         }
         return this.easeInFraction + easeOutFraction * this.easeOut((fraction - this.easeInFraction) / easeOutFraction);
      }
      
      protected function easeIn(fraction:Number) : Number
      {
         return fraction;
      }
      
      protected function easeOut(fraction:Number) : Number
      {
         return fraction;
      }
   }
}

