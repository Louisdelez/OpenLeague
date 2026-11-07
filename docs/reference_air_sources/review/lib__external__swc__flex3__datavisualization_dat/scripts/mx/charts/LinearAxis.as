package mx.charts
{
   import flash.events.Event;
   import mx.charts.chartClasses.AxisLabelSet;
   import mx.charts.chartClasses.NumericAxis;
   
   public class LinearAxis extends NumericAxis
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private var _labelPrecision:Number;
      
      private var _userInterval:Number;
      
      private var _userMinorInterval:Number;
      
      private var _minorInterval:Number;
      
      private var _alignLabelsToInterval:Boolean = true;
      
      public function LinearAxis()
      {
         super();
      }
      
      public function set maximum(value:Number) : void
      {
         assignedMaximum = value;
         computedMaximum = value;
         invalidateCache();
         dispatchEvent(new Event("mappingChange"));
         dispatchEvent(new Event("axisChange"));
      }
      
      [Inspectable(category="General")]
      public function get interval() : Number
      {
         return computedInterval;
      }
      
      public function set alignLabelsToInterval(value:Boolean) : void
      {
         if(value != _alignLabelsToInterval)
         {
            _alignLabelsToInterval = value;
            invalidateCache();
            dispatchEvent(new Event("mappingChange"));
            dispatchEvent(new Event("axisChange"));
         }
      }
      
      public function set interval(value:Number) : void
      {
         if(value <= 0)
         {
            value = NaN;
         }
         _userInterval = value;
         computedInterval = value;
         invalidateCache();
         dispatchEvent(new Event("axisChange"));
      }
      
      override public function reduceLabels(intervalStart:AxisLabel, intervalEnd:AxisLabel) : AxisLabelSet
      {
         var intervalMultiplier:Number = Math.round((Number(intervalEnd.value) - Number(intervalStart.value)) / computedInterval) + 1;
         var newMinorInterval:Number = intervalMultiplier * _minorInterval;
         var labels:Array = [];
         var newMinorTicks:Array = [];
         var newTicks:Array = [];
         var n:int = int(labelCache.length);
         for(var i:int = 0; i < n; i += intervalMultiplier)
         {
            labels.push(labelCache[i]);
            newTicks.push(labelCache[i].position);
         }
         var r:Number = computedMaximum - computedMinimum;
         var labelBase:Number = labelMinimum - Math.floor((labelMinimum - computedMinimum) / newMinorInterval) * newMinorInterval;
         if(_alignLabelsToInterval)
         {
            labelBase = Math.ceil(labelBase / newMinorInterval) * newMinorInterval;
         }
         var labelTop:Number = computedMaximum + 0.000001;
         for(var j:Number = labelBase; j <= labelTop; j += newMinorInterval)
         {
            newMinorTicks.push((j - computedMinimum) / r);
         }
         var labelSet:AxisLabelSet = new AxisLabelSet();
         labelSet.labels = labels;
         labelSet.minorTicks = newMinorTicks;
         labelSet.ticks = newTicks;
         labelSet.accurate = true;
         return labelSet;
      }
      
      [Inspectable(category="General")]
      public function get minimum() : Number
      {
         return computedMinimum;
      }
      
      public function set maximumLabelPrecision(value:Number) : void
      {
         _labelPrecision = value;
         invalidateCache();
      }
      
      [Inspectable(category="General")]
      public function get minorInterval() : Number
      {
         return _minorInterval;
      }
      
      public function set minimum(value:Number) : void
      {
         assignedMinimum = value;
         computedMinimum = value;
         invalidateCache();
         dispatchEvent(new Event("mappingChange"));
         dispatchEvent(new Event("axisChange"));
      }
      
      [Inspectable(category="General")]
      public function get maximum() : Number
      {
         return computedMaximum;
      }
      
      override protected function adjustMinMax(minValue:Number, maxValue:Number) : void
      {
         var y_userInterval:Number = NaN;
         var y_lowerBound:Number = NaN;
         var interval:Number = _userInterval;
         if(autoAdjust == false && !isNaN(_userInterval) && !isNaN(_userMinorInterval))
         {
            return;
         }
         if(maxValue == 0 && minValue == 0)
         {
            maxValue = 100;
         }
         var maxPowerOfTen:Number = Math.floor(Math.log(Math.abs(maxValue)) / Math.LN10);
         var minPowerOfTen:Number = Math.floor(Math.log(Math.abs(minValue)) / Math.LN10);
         var powerOfTen:Number = Math.floor(Math.log(Math.abs(maxValue - minValue)) / Math.LN10);
         if(isNaN(_userInterval))
         {
            y_userInterval = Math.pow(10,powerOfTen);
            if(Math.abs(maxValue - minValue) / y_userInterval < 4)
            {
               powerOfTen--;
               y_userInterval = y_userInterval * 2 / 10;
            }
         }
         else
         {
            y_userInterval = _userInterval;
         }
         var y_topBound:Number = Math.round(maxValue / y_userInterval) * y_userInterval == maxValue ? maxValue : (Math.floor(maxValue / y_userInterval) + 1) * y_userInterval;
         if(isFinite(minValue))
         {
            y_lowerBound = 0;
         }
         if(minValue < 0 || baseAtZero == false)
         {
            y_lowerBound = Math.floor(minValue / y_userInterval) * y_userInterval;
            if(maxValue < 0 && baseAtZero)
            {
               y_topBound = 0;
            }
         }
         else
         {
            y_lowerBound = 0;
         }
         if(isNaN(_userInterval))
         {
            computedInterval = y_userInterval;
         }
         if(isNaN(_userMinorInterval))
         {
            _minorInterval = computedInterval / 2;
         }
         if(autoAdjust)
         {
            if(isNaN(assignedMinimum))
            {
               computedMinimum = y_lowerBound;
            }
            if(isNaN(assignedMaximum))
            {
               computedMaximum = y_topBound;
            }
         }
      }
      
      public function get alignLabelsToInterval() : Boolean
      {
         return _alignLabelsToInterval;
      }
      
      public function get maximumLabelPrecision() : Number
      {
         return _labelPrecision;
      }
      
      public function set minorInterval(value:Number) : void
      {
         if(value <= 0)
         {
            value = NaN;
         }
         _userMinorInterval = value;
         _minorInterval = value;
         invalidateCache();
         dispatchEvent(new Event("axisChange"));
      }
      
      override protected function buildLabelCache() : Boolean
      {
         var i:Number = NaN;
         var roundedValue:Number = NaN;
         var decimal:Number = NaN;
         var previousValue:Number = NaN;
         if(Boolean(labelCache))
         {
            return false;
         }
         labelCache = [];
         var r:Number = computedMaximum - computedMinimum;
         var labelBase:Number = labelMinimum - Math.floor((labelMinimum - computedMinimum) / computedInterval) * computedInterval;
         if(_alignLabelsToInterval)
         {
            labelBase = Math.ceil(labelBase / computedInterval) * computedInterval;
         }
         var labelTop:Number = computedMaximum;
         var precision:Number = _labelPrecision;
         if(isNaN(precision))
         {
            decimal = Math.abs(computedInterval) - Math.floor(Math.abs(computedInterval));
            precision = decimal == 0 ? 1 : -Math.floor(Math.log(decimal) / Math.LN10);
            decimal = Math.abs(computedMinimum) - Math.floor(Math.abs(computedMinimum));
            precision = Math.max(precision,decimal == 0 ? 1 : -Math.floor(Math.log(decimal) / Math.LN10));
         }
         var roundBase:Number = Math.pow(10,precision);
         var labelFunction:Function = this.labelFunction;
         if(labelFunction != null)
         {
            previousValue = NaN;
            for(i = labelBase; i <= labelTop; i += computedInterval)
            {
               roundedValue = Math.round(i * roundBase) / roundBase;
               labelCache.push(new AxisLabel((i - computedMinimum) / r,i,labelFunction(roundedValue,previousValue,this)));
               previousValue = roundedValue;
            }
         }
         else
         {
            for(i = labelBase; i <= labelTop; i += computedInterval)
            {
               roundedValue = Math.round(i * roundBase) / roundBase;
               labelCache.push(new AxisLabel((i - computedMinimum) / r,i,roundedValue.toString()));
            }
         }
         return true;
      }
      
      override protected function buildMinorTickCache() : Array
      {
         var cache:Array = [];
         var r:Number = computedMaximum - computedMinimum;
         var labelBase:Number = labelMinimum - Math.floor((labelMinimum - computedMinimum) / _minorInterval) * _minorInterval;
         if(_alignLabelsToInterval)
         {
            labelBase = Math.ceil(labelBase / _minorInterval) * _minorInterval;
         }
         var labelTop:Number = computedMaximum;
         for(var i:Number = labelBase; i <= labelTop; i += _minorInterval)
         {
            cache.push((i - computedMinimum) / r);
         }
         return cache;
      }
   }
}

