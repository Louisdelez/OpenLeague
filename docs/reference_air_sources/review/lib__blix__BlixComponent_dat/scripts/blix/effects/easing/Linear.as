package blix.effects.easing
{
   public class Linear implements IEaser
   {
      
      private var _easeInFraction:Number = 0;
      
      private var _easeOutFraction:Number = 0;
      
      public function Linear(param1:Number = 0, param2:Number = 0)
      {
         super();
         this._easeInFraction = param1;
         this._easeOutFraction = param2;
      }
      
      public function getEaseInFraction() : Number
      {
         return this._easeInFraction;
      }
      
      public function setEaseInFraction(param1:Number) : void
      {
         this._easeInFraction = param1;
      }
      
      public function getEaseOutFraction() : Number
      {
         return this._easeOutFraction;
      }
      
      public function setEaseOutFraction(param1:Number) : void
      {
         this._easeOutFraction = param1;
      }
      
      public function ease(param1:Number) : Number
      {
         var _loc3_:Number = NaN;
         var _loc4_:Number = NaN;
         if(this._easeInFraction == 0 && this._easeOutFraction == 0)
         {
            return param1;
         }
         var _loc2_:Number = 1 / (1 - this._easeInFraction / 2 - this._easeOutFraction / 2);
         if(param1 < this._easeInFraction)
         {
            return param1 * _loc2_ * (param1 / this._easeInFraction) / 2;
         }
         if(param1 > 1 - this._easeOutFraction)
         {
            _loc3_ = param1 - (1 - this._easeOutFraction);
            _loc4_ = _loc3_ / this._easeOutFraction;
            return _loc2_ * (1 - this._easeInFraction / 2 - this._easeOutFraction + _loc3_ * (2 - _loc4_) / 2);
         }
         return _loc2_ * (param1 - this._easeInFraction / 2);
      }
   }
}

