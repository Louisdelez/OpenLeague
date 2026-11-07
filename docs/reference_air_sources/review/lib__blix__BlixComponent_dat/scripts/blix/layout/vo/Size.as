package blix.layout.vo
{
   public class Size
   {
      
      private var _value:Number;
      
      private var _actual:Number;
      
      private var _min:Number = -10000;
      
      private var _max:Number = 10000;
      
      private var _isFlexible:Boolean = true;
      
      public function Size()
      {
         super();
      }
      
      public function getIsSet() : Boolean
      {
         return !isNaN(this._value);
      }
      
      public function getValue() : Number
      {
         return this._value;
      }
      
      public function setValue(param1:Number) : void
      {
         this._value = param1;
      }
      
      public function getActual() : Number
      {
         return this._actual;
      }
      
      public function setActual(param1:Number) : void
      {
         this._actual = param1;
      }
      
      public function getMin() : Number
      {
         return this._min;
      }
      
      public function setMin(param1:Number) : void
      {
         if(isNaN(param1))
         {
            throw new Error("Min size may not be NaN.");
         }
         this._min = param1;
      }
      
      public function getMax() : Number
      {
         return this._max;
      }
      
      public function setMax(param1:Number) : void
      {
         if(isNaN(param1))
         {
            throw new Error("Max size may not be NaN.");
         }
         this._max = param1;
      }
      
      public function getIsFlexible() : Boolean
      {
         return this._isFlexible;
      }
      
      public function setIsFlexible(param1:Boolean) : void
      {
         this._isFlexible = param1;
      }
      
      public function getIdeal() : Number
      {
         return Math.min(Math.max(this._value,this._min),this._max);
      }
      
      public function setSize(param1:Number) : void
      {
         param1 = Math.max(Math.min(param1,this._max),this._min);
         this._value = param1;
         this._actual = param1;
      }
      
      public function clear() : void
      {
         this._value = NaN;
         this._min = -10000;
         this._max = 10000;
      }
      
      public function bound(param1:MinMax) : void
      {
         if(param1 == null)
         {
            return;
         }
         this._min = Math.max(param1.min,this._min);
         this._max = Math.min(param1.max,this._max);
      }
      
      public function toString() : String
      {
         return "[Size value=" + this._value + " min=" + this._min + " max=" + this._max + "]";
      }
   }
}

