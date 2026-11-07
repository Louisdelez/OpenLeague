package mx.charts.chartClasses
{
   import flash.events.Event;
   import mx.charts.AxisLabel;
   
   public class NumericAxis extends AxisBase implements IAxis
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      protected var assignedMaximum:Number;
      
      protected var labelMaximum:Number;
      
      private var _cachedDataDescriptions:Array;
      
      private var _labelSet:AxisLabelSet;
      
      protected var minorTickCache:Array;
      
      private var _parseFunction:Function = null;
      
      private var _autoAdjust:Boolean = true;
      
      public var computedMinimum:Number;
      
      private var _baseAtZero:Boolean = true;
      
      private var _padding:Number;
      
      public var computedMaximum:Number;
      
      private var _cachedValuesHaveBounds:Boolean;
      
      private var _regenerateAutoValues:Boolean = true;
      
      private var _labelFunction:Function = null;
      
      protected var labelCache:Array;
      
      protected var assignedMinimum:Number;
      
      protected var computedInterval:Number;
      
      protected var labelMinimum:Number;
      
      public function NumericAxis()
      {
         super();
      }
      
      protected function buildLabelCache() : Boolean
      {
         return false;
      }
      
      protected function invalidateCache() : void
      {
         minorTickCache = null;
         _regenerateAutoValues = true;
         labelCache = null;
      }
      
      public function mapCache(cache:Array, field:String, convertedField:String, indexValues:Boolean = false) : void
      {
         var i:int = 0;
         var v:Object = null;
         var n:int = int(cache.length);
         if(_parseFunction != null)
         {
            for(i = 0; i < n; i++)
            {
               v = cache[i];
               v[convertedField] = _parseFunction(v[field]);
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
               while(i < n)
               {
                  v = cache[i];
                  v[convertedField] = Number(v[field]);
                  i++;
               }
            }
            else if(cache[i][field] is XML || cache[i][field] is XMLList)
            {
               while(i < n)
               {
                  v = cache[i];
                  v[convertedField] = parseFloat(v[field].toString());
                  i++;
               }
            }
            else if(cache[i][field] is Number || cache[i][field] is int || cache[i][field] is uint)
            {
               while(i < n)
               {
                  v = cache[i];
                  if(v[field] == null || v[field].toString() == "")
                  {
                     v[convertedField] = NaN;
                  }
                  else
                  {
                     v[convertedField] = v[field];
                  }
                  i++;
               }
            }
            else
            {
               while(i < n)
               {
                  v = cache[i];
                  v[convertedField] = parseFloat(v[field]);
                  i++;
               }
            }
         }
      }
      
      [Inspectable(category="General")]
      public function get padding() : Number
      {
         return _padding;
      }
      
      public function reduceLabels(intervalStart:AxisLabel, intervalEnd:AxisLabel) : AxisLabelSet
      {
         return _labelSet;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getSortOrder() : Boolean
      {
         return computedMinimum < computedMaximum;
      }
      
      private function adjustForMargins(minimumAxisLength:Number) : void
      {
         var n:int = 0;
         var i:int = 0;
         var axisLength:Number = NaN;
         var currentRange:Number = NaN;
         var itrCount:int = 0;
         var verify:Boolean = false;
         var lowestOverlap:Number = NaN;
         var lowestValue:BoundedValue = null;
         var highestOverlap:Number = NaN;
         var highestValue:BoundedValue = null;
         var v1:Number = NaN;
         var m1:Number = NaN;
         var v2:Number = NaN;
         var m2:Number = NaN;
         var p1:Number = NaN;
         var v:BoundedValue = null;
         var vpos:Number = NaN;
         var min:Number = computedMinimum;
         var max:Number = computedMaximum;
         var boundedValues:Array = [];
         var cachedDataDescriptions:Array = dataDescriptions;
         var boundsWithinRegion:Boolean = true;
         for(i = 0; i < cachedDataDescriptions.length; i++)
         {
            if(Boolean(cachedDataDescriptions[i].boundedValues))
            {
               boundedValues = boundedValues.concat(cachedDataDescriptions[i].boundedValues);
            }
         }
         for(i = 0; i < boundedValues.length; i++)
         {
            if(!(boundedValues[i].lowerMargin < minimumAxisLength && boundedValues[i].upperMargin < minimumAxisLength))
            {
               boundsWithinRegion = false;
            }
         }
         if(boundedValues.length > 0 && minimumAxisLength > 0 && boundsWithinRegion)
         {
            if(isNaN(min))
            {
               min = Number(boundedValues[0].value);
            }
            if(isNaN(max))
            {
               max = Number(boundedValues[0].value);
            }
            axisLength = minimumAxisLength;
            currentRange = max - min;
            itrCount = 0;
            n = int(boundedValues.length);
            verify = true;
            while(verify)
            {
               lowestOverlap = minimumAxisLength;
               highestOverlap = 0;
               v1 = max;
               m1 = 0;
               v2 = min;
               m2 = 0;
               for(i = 0; i < n; i++)
               {
                  v = boundedValues[i];
                  vpos = (v.value - min) / currentRange * minimumAxisLength;
                  if(!isNaN(v.lowerMargin) && vpos - v.lowerMargin < lowestOverlap)
                  {
                     lowestOverlap = vpos - v.lowerMargin;
                     lowestValue = v;
                  }
                  if(!isNaN(v.upperMargin) && vpos + v.upperMargin > highestOverlap)
                  {
                     highestOverlap = vpos + v.upperMargin;
                     highestValue = v;
                  }
               }
               if(lowestOverlap > -0.0001 && highestOverlap < minimumAxisLength + 0.0001)
               {
                  break;
               }
               if(highestOverlap > minimumAxisLength)
               {
                  v1 = highestValue.value;
                  m1 = highestValue.upperMargin;
               }
               else
               {
                  verify = false;
               }
               if(lowestOverlap < 0)
               {
                  v2 = lowestValue.value;
                  m2 = lowestValue.lowerMargin;
               }
               else
               {
                  verify = false;
               }
               p1 = minimumAxisLength - m1;
               min = (p1 * v2 - m2 * v1) / Math.abs(p1 - m2);
               max = minimumAxisLength * (v1 - min) / (minimumAxisLength - m1) + min;
               currentRange = max - min;
               if(itrCount++ == 3)
               {
                  break;
               }
            }
         }
         var adjusted:Array = guardMinMax(min,max);
         if(Boolean(adjusted))
         {
            min = Number(adjusted[0]);
            max = Number(adjusted[1]);
         }
         if(isNaN(assignedMinimum))
         {
            computedMinimum = min;
         }
         if(isNaN(assignedMaximum))
         {
            computedMaximum = max;
         }
      }
      
      [Inspectable(category="General",defaultValue="true")]
      public function get autoAdjust() : Boolean
      {
         return _autoAdjust;
      }
      
      protected function adjustMinMax(minValue:Number, maxValue:Number) : void
      {
      }
      
      public function getLabelEstimate() : AxisLabelSet
      {
         update();
         var updated:Boolean = buildLabelCache();
         if(updated)
         {
            _labelSet = new AxisLabelSet();
            _labelSet.labels = labelCache;
            _labelSet.accurate = _cachedValuesHaveBounds == false;
            _labelSet.minorTicks = minorTicks;
            _labelSet.ticks = ticks;
         }
         return _labelSet;
      }
      
      public function set padding(value:Number) : void
      {
         _padding = value;
         invalidateCache();
         dispatchEvent(new Event("axisChange"));
      }
      
      [Inspectable(category="Other")]
      public function get parseFunction() : Function
      {
         return _parseFunction;
      }
      
      [Inspectable(category="General",defaultValue="true")]
      public function get baseAtZero() : Boolean
      {
         return _baseAtZero;
      }
      
      override public function dataChanged() : void
      {
         minorTickCache = null;
         _cachedDataDescriptions = null;
         _regenerateAutoValues = true;
         if(isNaN(assignedMinimum) || isNaN(assignedMaximum))
         {
            dispatchEvent(new Event("mappingChange"));
            dispatchEvent(new Event("axisChange"));
         }
      }
      
      public function invertTransform(value:Number) : Object
      {
         update();
         return value * (computedMaximum - computedMinimum) + computedMinimum;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get zeroValue() : Number
      {
         return 0;
      }
      
      private function updateCache(checkForMargins:Boolean, minimumAxisLength:Number) : void
      {
         var oldMin:Number = NaN;
         var oldMax:Number = NaN;
         var oldInterval:Number = NaN;
         var autoGen:Boolean = false;
         var us:Number = NaN;
         var cachedDataDescriptions:Array = null;
         var i:int = 0;
         var desc:DataDescription = null;
         var us2:Number = NaN;
         if(_regenerateAutoValues)
         {
            oldMin = computedMinimum;
            oldMax = computedMaximum;
            oldInterval = computedInterval;
            if(!isNaN(assignedMinimum))
            {
               computedMinimum = assignedMinimum;
            }
            if(!isNaN(assignedMaximum))
            {
               computedMaximum = assignedMaximum;
            }
            autoGen = isNaN(assignedMinimum) || isNaN(assignedMaximum);
            if(autoGen)
            {
               autoGenerate(checkForMargins,minimumAxisLength);
            }
            adjustMinMax(computedMinimum,computedMaximum);
            labelMinimum = computedMinimum;
            labelMaximum = computedMaximum;
            if((autoAdjust || autoGen) && checkForMargins && _cachedValuesHaveBounds)
            {
               adjustForMargins(minimumAxisLength);
            }
            us = unitSize;
            if(!isNaN(_padding))
            {
               if(labelMinimum - computedMinimum < _padding * us)
               {
                  computedMinimum = labelMinimum - _padding * us;
               }
               if(computedMaximum - labelMaximum < _padding * us)
               {
                  computedMaximum = labelMaximum + _padding * us;
               }
            }
            cachedDataDescriptions = dataDescriptions;
            for(i = 0; i < cachedDataDescriptions.length; i++)
            {
               desc = cachedDataDescriptions[i];
               if(!isNaN(desc.padding))
               {
                  if(isNaN(assignedMinimum) && desc.min - computedMinimum < desc.padding * us)
                  {
                     computedMinimum = desc.min - desc.padding * us;
                  }
                  if(isNaN(assignedMaximum) && computedMaximum - desc.max < desc.padding * us)
                  {
                     computedMaximum = desc.max + desc.padding * us;
                  }
               }
            }
            if(computedMinimum == computedMaximum)
            {
               us2 = unitSize / 2;
               computedMinimum -= us2;
               computedMaximum += us2;
            }
            if(oldMin != computedMinimum || oldMax != computedMaximum || oldInterval != computedInterval)
            {
               labelCache = null;
               minorTickCache = null;
            }
            _regenerateAutoValues = false;
         }
      }
      
      public function set autoAdjust(value:Boolean) : void
      {
         _autoAdjust = value;
         dataChanged();
      }
      
      protected function buildMinorTickCache() : Array
      {
         return [];
      }
      
      [Inspectable(environment="none")]
      public function get baseline() : Number
      {
         var baseVal:Number = NaN;
         if(computedMinimum >= 0)
         {
            baseVal = computedMinimum;
         }
         else if(computedMaximum <= 0)
         {
            baseVal = computedMaximum;
         }
         else
         {
            baseVal = 0;
         }
         return baseVal;
      }
      
      protected function guardMinMax(min:Number, max:Number) : Array
      {
         if(isNaN(min) || !isFinite(min))
         {
            return [0,100];
         }
         if(isNaN(max) || !isFinite(max) || min == max)
         {
            return [min,min + 100];
         }
         return null;
      }
      
      [Inspectable(environment="none")]
      public function get minorTicks() : Array
      {
         if(!minorTickCache)
         {
            minorTickCache = buildMinorTickCache();
         }
         return minorTickCache;
      }
      
      public function update() : void
      {
         updateCache(true,0);
      }
      
      public function set parseFunction(value:Function) : void
      {
         _parseFunction = value;
         invalidateCache();
         _cachedDataDescriptions = null;
         dispatchEvent(new Event("mappingChange"));
         dispatchEvent(new Event("axisChange"));
      }
      
      public function set baseAtZero(value:Boolean) : void
      {
         _baseAtZero = value;
         dataChanged();
      }
      
      protected function get dataDescriptions() : Array
      {
         if(!_cachedDataDescriptions)
         {
            _cachedDataDescriptions = describeData(requiredDescribedFields);
            _cachedValuesHaveBounds = false;
         }
         return _cachedDataDescriptions;
      }
      
      public function formatForScreen(value:Object) : String
      {
         return value.toString();
      }
      
      public function set labelFunction(value:Function) : void
      {
         _labelFunction = value;
         invalidateCache();
         dispatchEvent(new Event("mappingChange"));
         dispatchEvent(new Event("axisChange"));
      }
      
      private function autoGenerate(checkForMargins:Boolean, minimumAxisLength:Number) : void
      {
         var min:Number = NaN;
         var max:Number = NaN;
         var v:Object = null;
         var val:Number = NaN;
         var i:int = 0;
         var desc:DataDescription = null;
         var cachedDataDescriptions:Array = this.dataDescriptions;
         if(autoAdjust && baseAtZero)
         {
            min = zeroValue;
         }
         var n:int = int(cachedDataDescriptions.length);
         if(n > 0)
         {
            max = Number(cachedDataDescriptions[0].max);
            if(isNaN(min))
            {
               min = Number(cachedDataDescriptions[0].min);
            }
            else if(!isNaN(cachedDataDescriptions[0].min))
            {
               min = Math.min(min,cachedDataDescriptions[0].min);
            }
            for(i = 0; i < n; i++)
            {
               desc = cachedDataDescriptions[i];
               if(isNaN(min))
               {
                  min = desc.min;
               }
               else if(!isNaN(desc.min))
               {
                  min = Math.min(min,desc.min);
               }
               if(isNaN(max))
               {
                  max = desc.max;
               }
               else if(!isNaN(desc.max))
               {
                  max = Math.max(max,desc.max);
               }
               _cachedValuesHaveBounds = _cachedValuesHaveBounds || Boolean(desc.boundedValues) && desc.boundedValues.length > 0;
            }
         }
         var adjusted:Array = guardMinMax(min,max);
         if(Boolean(adjusted))
         {
            min = Number(adjusted[0]);
            max = Number(adjusted[1]);
         }
         if(isNaN(assignedMinimum))
         {
            computedMinimum = min;
         }
         if(isNaN(assignedMaximum))
         {
            computedMaximum = max;
         }
      }
      
      public function filterCache(cache:Array, field:String, filteredField:String) : void
      {
         var v:Object = null;
         update();
         var max:Number = computedMaximum + 0.00001;
         var min:Number = computedMinimum - 0.00001;
         var n:int = int(cache.length);
         for(var i:int = 0; i < n; i++)
         {
            v = cache[i][field];
            cache[i][filteredField] = v >= min && v <= max ? v : NaN;
         }
      }
      
      [Inspectable(category="General")]
      public function get labelFunction() : Function
      {
         return _labelFunction;
      }
      
      protected function get requiredDescribedFields() : uint
      {
         return DataDescription.REQUIRED_MIN_MAX | DataDescription.REQUIRED_BOUNDED_VALUES;
      }
      
      public function getLabels(minimumAxisLength:Number) : AxisLabelSet
      {
         var updated:Boolean = false;
         if(_cachedValuesHaveBounds || !labelCache)
         {
            _regenerateAutoValues = true;
            updateCache(true,minimumAxisLength);
            updated = buildLabelCache();
         }
         else
         {
            updated = false;
         }
         if(updated)
         {
            _labelSet = new AxisLabelSet();
            _labelSet.labels = labelCache;
            _labelSet.minorTicks = minorTicks;
            _labelSet.ticks = ticks;
         }
         return _labelSet;
      }
      
      protected function get ticks() : Array
      {
         var result:Array = [];
         var n:int = int(labelCache.length);
         for(var i:int = 0; i < n; i++)
         {
            result.push(labelCache[i].position);
         }
         return result;
      }
      
      public function transformCache(cache:Array, field:String, convertedField:String) : void
      {
         update();
         var r:Number = computedMaximum - computedMinimum;
         var n:int = int(cache.length);
         for(var i:int = 0; i < n; i++)
         {
            cache[i][convertedField] = (cache[i][field] - computedMinimum) / r;
         }
      }
      
      public function preferDropLabels() : Boolean
      {
         return true;
      }
   }
}

