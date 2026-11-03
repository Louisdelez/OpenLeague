package spark.components.supportClasses
{
   import mx.events.FlexEvent;
   
   public class Range extends SkinnableComponent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var _maximum:Number = 100;
      
      private var maxChanged:Boolean = false;
      
      private var _minimum:Number = 0;
      
      private var minChanged:Boolean = false;
      
      private var _stepSize:Number = 1;
      
      private var stepSizeChanged:Boolean = false;
      
      private var _value:Number = 0;
      
      private var _changedValue:Number = 0;
      
      private var valueChanged:Boolean = false;
      
      private var _snapInterval:Number = 1;
      
      private var snapIntervalChanged:Boolean = false;
      
      private var _explicitSnapInterval:Boolean = false;
      
      public function Range()
      {
         super();
      }
      
      [Inspectable(category="General",defaultValue="100.0")]
      public function get maximum() : Number
      {
         return this._maximum;
      }
      
      public function set maximum(value:Number) : void
      {
         if(value == this._maximum)
         {
            return;
         }
         this._maximum = value;
         this.maxChanged = true;
         invalidateProperties();
      }
      
      [Inspectable(category="General",defaultValue="0.0")]
      public function get minimum() : Number
      {
         return this._minimum;
      }
      
      public function set minimum(value:Number) : void
      {
         if(value == this._minimum)
         {
            return;
         }
         this._minimum = value;
         this.minChanged = true;
         invalidateProperties();
      }
      
      [Inspectable(category="General",defaultValue="1.0",minValue="0.0")]
      public function get stepSize() : Number
      {
         return this._stepSize;
      }
      
      public function set stepSize(value:Number) : void
      {
         if(value == this._stepSize)
         {
            return;
         }
         this._stepSize = value;
         this.stepSizeChanged = true;
         invalidateProperties();
      }
      
      [Inspectable(category="General",defaultValue="0.0")]
      [Bindable(event="valueCommit")]
      public function get value() : Number
      {
         return this.valueChanged ? this._changedValue : this._value;
      }
      
      public function set value(newValue:Number) : void
      {
         if(newValue == this.value)
         {
            return;
         }
         this._changedValue = newValue;
         this.valueChanged = true;
         invalidateProperties();
      }
      
      [Inspectable(category="General",defaultValue="1.0",minValue="0.0")]
      public function get snapInterval() : Number
      {
         return this._snapInterval;
      }
      
      public function set snapInterval(value:Number) : void
      {
         this._explicitSnapInterval = true;
         if(value == this._snapInterval)
         {
            return;
         }
         if(isNaN(value))
         {
            this._snapInterval = 1;
            this._explicitSnapInterval = false;
         }
         else
         {
            this._snapInterval = value;
         }
         this.snapIntervalChanged = true;
         this.stepSizeChanged = true;
         invalidateProperties();
      }
      
      override protected function commitProperties() : void
      {
         var currentValue:Number = NaN;
         super.commitProperties();
         if(this.minimum > this.maximum)
         {
            if(!this.maxChanged)
            {
               this._minimum = this._maximum;
            }
            else
            {
               this._maximum = this._minimum;
            }
         }
         if(this.stepSizeChanged || this.snapIntervalChanged)
         {
            if(this._explicitSnapInterval)
            {
               this._stepSize = this.nearestValidSize(this._stepSize);
               this.stepSizeChanged = true;
            }
            else
            {
               this._snapInterval = this._stepSize;
               this.snapIntervalChanged = true;
            }
         }
         if(this.valueChanged || this.maxChanged || this.minChanged || this.stepSizeChanged || this.snapIntervalChanged)
         {
            currentValue = this.valueChanged ? this._changedValue : this._value;
            this.valueChanged = false;
            this.maxChanged = false;
            this.minChanged = false;
            this.stepSizeChanged = false;
            this.snapIntervalChanged = false;
            this.setValue(this.nearestValidValue(currentValue,this.snapInterval));
         }
      }
      
      private function nearestValidSize(size:Number) : Number
      {
         var interval:Number = this.snapInterval;
         if(interval == 0)
         {
            return size;
         }
         var validSize:Number = Math.round(size / interval) * interval;
         return Math.abs(validSize) < interval ? interval : validSize;
      }
      
      protected function nearestValidValue(value:Number, interval:Number) : Number
      {
         var parts:Array = null;
         if(interval == 0)
         {
            return Math.max(this.minimum,Math.min(this.maximum,value));
         }
         var maxValue:Number = this.maximum - this.minimum;
         var scale:Number = 1;
         value -= this.minimum;
         if(interval != Math.round(interval))
         {
            parts = new String(1 + interval).split(".");
            scale = Math.pow(10,parts[1].length);
            maxValue *= scale;
            value = Math.round(value * scale);
            interval = Math.round(interval * scale);
         }
         var lower:Number = Math.max(0,Math.floor(value / interval) * interval);
         var upper:Number = Math.min(maxValue,Math.floor((value + interval) / interval) * interval);
         var validValue:Number = value - lower >= (upper - lower) / 2 ? upper : lower;
         return validValue / scale + this.minimum;
      }
      
      protected function setValue(value:Number) : void
      {
         if(this._value == value)
         {
            return;
         }
         if(!isNaN(this.maximum) && !isNaN(this.minimum) && this.maximum > this.minimum)
         {
            this._value = Math.min(this.maximum,Math.max(this.minimum,value));
         }
         else
         {
            this._value = value;
         }
         dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
      }
      
      public function changeValueByStep(increase:Boolean = true) : void
      {
         if(this.stepSize == 0)
         {
            return;
         }
         var newValue:Number = increase ? this.value + this.stepSize : this.value - this.stepSize;
         this.setValue(this.nearestValidValue(newValue,this.snapInterval));
      }
   }
}

