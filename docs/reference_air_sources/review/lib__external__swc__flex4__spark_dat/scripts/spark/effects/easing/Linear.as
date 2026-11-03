package spark.effects.easing
{
   public class Linear implements IEaser
   {
      
      private var _easeInFraction:Number = 0;
      
      private var _easeOutFraction:Number = 0;
      
      public function Linear(easeInFraction:Number = 0, easeOutFraction:Number = 0)
      {
         super();
         this.easeInFraction = easeInFraction;
         this.easeOutFraction = easeOutFraction;
      }
      
      public function get easeInFraction() : Number
      {
         return this._easeInFraction;
      }
      
      public function set easeInFraction(value:Number) : void
      {
         this._easeInFraction = value;
      }
      
      public function get easeOutFraction() : Number
      {
         return this._easeOutFraction;
      }
      
      public function set easeOutFraction(value:Number) : void
      {
         this._easeOutFraction = value;
      }
      
      public function ease(fraction:Number) : Number
      {
         var decTime:Number = NaN;
         var decProportion:Number = NaN;
         if(this.easeInFraction == 0 && this.easeOutFraction == 0)
         {
            return fraction;
         }
         var runRate:Number = 1 / (1 - this.easeInFraction / 2 - this.easeOutFraction / 2);
         if(fraction < this.easeInFraction)
         {
            return fraction * runRate * (fraction / this.easeInFraction) / 2;
         }
         if(fraction > 1 - this.easeOutFraction)
         {
            decTime = fraction - (1 - this.easeOutFraction);
            decProportion = decTime / this.easeOutFraction;
            return runRate * (1 - this.easeInFraction / 2 - this.easeOutFraction + decTime * (2 - decProportion) / 2);
         }
         return runRate * (fraction - this.easeInFraction / 2);
      }
   }
}

