package spark.effects.easing
{
   public class Power extends EaseInOutBase
   {
      
      private var _exponent:Number;
      
      public function Power(easeInFraction:Number = 0.5, exponent:Number = 2)
      {
         super(easeInFraction);
         this.exponent = exponent;
      }
      
      [Inspectable(minValue="1.0")]
      public function get exponent() : Number
      {
         return this._exponent;
      }
      
      public function set exponent(value:Number) : void
      {
         this._exponent = value;
      }
      
      override protected function easeIn(fraction:Number) : Number
      {
         return Math.pow(fraction,this._exponent);
      }
      
      override protected function easeOut(fraction:Number) : Number
      {
         return 1 - Math.pow(1 - fraction,this._exponent);
      }
   }
}

