package mx.charts
{
   import flash.events.Event;
   import mx.charts.chartClasses.AxisLabelSet;
   import mx.charts.chartClasses.NumericAxis;
   
   public class LogAxis extends NumericAxis
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private var _labelPrecision:Number;
      
      public function LogAxis()
      {
         super();
         computedInterval = 1;
      }
      
      [Inspectable(category="General")]
      public function get maximum() : Number
      {
         return Math.pow(10,computedMaximum);
      }
      
      override protected function adjustMinMax(minValue:Number, maxValue:Number) : void
      {
         computedMinimum = Math.floor(computedMinimum);
         computedMaximum = Math.ceil(computedMaximum);
      }
      
      override protected function buildLabelCache() : Boolean
      {
         var i:Number = NaN;
         var v:Number = NaN;
         var roundedValue:Number = NaN;
         var roundBase:Number = NaN;
         var previousValue:Number = NaN;
         if(Boolean(labelCache))
         {
            return false;
         }
         labelCache = [];
         var r:Number = computedMaximum - computedMinimum;
         var labelBase:Number = labelMinimum - Math.floor((labelMinimum - computedMinimum) / computedInterval) * computedInterval;
         var labelTop:Number = computedMaximum + 0.000001;
         var labelFunction:Function = this.labelFunction;
         if(!isNaN(_labelPrecision))
         {
            roundBase = Math.pow(10,_labelPrecision);
         }
         if(labelFunction != null)
         {
            previousValue = NaN;
            for(i = labelBase; i <= labelTop; i += computedInterval)
            {
               v = Math.pow(10,i);
               roundedValue = isNaN(_labelPrecision) ? v : Math.round(v * roundBase) / roundBase;
               labelCache.push(new AxisLabel((i - computedMinimum) / r,v,labelFunction(roundedValue,previousValue,this)));
               previousValue = v;
            }
         }
         else
         {
            for(i = labelBase; i <= labelTop; i += computedInterval)
            {
               v = Math.pow(10,i);
               roundedValue = isNaN(_labelPrecision) ? v : Math.round(v * roundBase) / roundBase;
               labelCache.push(new AxisLabel((i - computedMinimum) / r,v,roundedValue.toString()));
            }
         }
         return true;
      }
      
      [Inspectable(category="General")]
      public function get interval() : Number
      {
         return Math.pow(10,computedInterval);
      }
      
      override public function mapCache(cache:Array, field:String, convertedField:String, indexValues:Boolean = false) : void
      {
         var i:int = 0;
         var v:Object = null;
         var vf:Number = NaN;
         var ln10:Number = Math.LN10;
         var n:int = int(cache.length);
         var parseFunction:Function = this.parseFunction;
         if(parseFunction != null)
         {
            for(i = 0; i < n; i++)
            {
               v = cache[i];
               v[convertedField] = Math.log(Number(parseFunction(v[field]))) / ln10;
            }
         }
         else
         {
            i = 0;
            while(i < n && cache[i][field] == null)
            {
               i++;
            }
            if(i == n)
            {
               return;
            }
            if(cache[i][field] is String)
            {
               for(i = 0; i < n; i++)
               {
                  v = cache[i];
                  v[convertedField] = Math.log(Number(v[field])) / ln10;
               }
            }
            else if(cache[i][field] is XML || cache[i][field] is XMLList)
            {
               for(i = 0; i < n; i++)
               {
                  v = cache[i];
                  v[convertedField] = Math.log(Number(v[field].toString())) / ln10;
               }
            }
            else if(cache[i][field] is Number || cache[i][field] is int || cache[i][field] is uint)
            {
               for(i = 0; i < n; i++)
               {
                  v = cache[i];
                  v[convertedField] = v[field] == null ? NaN : Math.log(v[field]) / ln10;
               }
            }
            else
            {
               for(i = 0; i < n; i++)
               {
                  v = cache[i];
                  v[convertedField] = Math.log(parseFloat(v[field])) / ln10;
               }
            }
         }
      }
      
      public function set maximum(value:Number) : void
      {
         computedMaximum = Math.ceil(Math.log(value) / Math.LN10);
         assignedMaximum = computedMaximum;
         invalidateCache();
         dispatchEvent(new Event("mappingChange"));
         dispatchEvent(new Event("axisChange"));
      }
      
      public function get maximumLabelPrecision() : Number
      {
         return _labelPrecision;
      }
      
      override public function reduceLabels(intervalStart:AxisLabel, intervalEnd:AxisLabel) : AxisLabelSet
      {
         var ci:AxisLabel = null;
         var intervalMultiplier:Number = Math.round(Math.log(Number(intervalEnd.value)) / Math.LN10 - Math.log(Number(intervalStart.value)) / Math.LN10);
         intervalMultiplier = Math.floor(intervalMultiplier / computedInterval) + 1;
         var labels:Array = [];
         var newMinorTicks:Array = [];
         var newTicks:Array = [];
         var r:Number = computedMaximum - computedMinimum;
         var labelBase:Number = labelMinimum - Math.floor((labelMinimum - computedMinimum) / computedInterval) * computedInterval;
         var labelTop:Number = computedMaximum + 0.000001;
         for(var i:int = 0; i < labelCache.length; i += intervalMultiplier)
         {
            ci = labelCache[i];
            labels.push(ci);
            newTicks.push(ci.position);
            newMinorTicks.push(ci.position);
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
         return Math.pow(10,computedMinimum);
      }
      
      public function set interval(value:Number) : void
      {
         if(!isNaN(value))
         {
            value = Math.max(1,Math.floor(Math.log(value) / Math.LN10));
         }
         if(isNaN(value))
         {
            value = 1;
         }
         computedInterval = value;
         invalidateCache();
         dispatchEvent(new Event("axisChange"));
      }
      
      public function set maximumLabelPrecision(value:Number) : void
      {
         _labelPrecision = value;
         invalidateCache();
      }
      
      override public function invertTransform(value:Number) : Object
      {
         update();
         return Math.pow(10,value * (computedMaximum - computedMinimum) + computedMinimum);
      }
      
      override protected function guardMinMax(min:Number, max:Number) : Array
      {
         if(isNaN(min) || !isFinite(min))
         {
            min = 0;
         }
         if(isNaN(max) || !isFinite(max))
         {
            max = min + 2;
         }
         if(max == min)
         {
            max = min + 2;
         }
         return [min,max];
      }
      
      public function set minimum(value:Number) : void
      {
         if(value == 0)
         {
            assignedMinimum = NaN;
         }
         else
         {
            assignedMinimum = Math.floor(Math.log(value) / Math.LN10);
         }
         computedMinimum = assignedMinimum;
         invalidateCache();
         dispatchEvent(new Event("mappingChange"));
         dispatchEvent(new Event("axisChange"));
      }
      
      override protected function buildMinorTickCache() : Array
      {
         var cache:Array = [];
         var n:int = int(labelCache.length);
         for(var i:int = 0; i < labelCache.length; i++)
         {
            cache.push(labelCache[i].position);
         }
         return cache;
      }
   }
}

