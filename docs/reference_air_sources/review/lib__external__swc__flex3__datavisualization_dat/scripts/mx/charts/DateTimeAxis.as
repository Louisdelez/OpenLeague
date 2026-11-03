package mx.charts
{
   import flash.events.Event;
   import mx.charts.chartClasses.AxisLabelSet;
   import mx.charts.chartClasses.DataDescription;
   import mx.charts.chartClasses.DateRangeUtilities;
   import mx.charts.chartClasses.NumericAxis;
   
   public class DateTimeAxis extends NumericAxis
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private static const MILLISECONDS_IN_MINUTE:Number = 1000 * 60;
      
      private static const MILLISECONDS_IN_HOUR:Number = 1000 * 60 * 60;
      
      private static const MILLISECONDS_IN_DAY:Number = 1000 * 60 * 60 * 24;
      
      private static const MILLISECONDS_IN_WEEK:Number = 1000 * 60 * 60 * 24 * 7;
      
      private static const MILLISECONDS_IN_MONTH:Number = 1000 * 60 * 60 * 24 * 30;
      
      private static const MILLISECONDS_IN_YEAR:Number = 1000 * 60 * 60 * 24 * 365;
      
      private static const MINIMUM_LABEL_COUNT:Number = 2;
      
      private static var tmpDate:Date = new Date();
      
      private var _unitSize:Number = 86400000;
      
      private var hoursP:String;
      
      private var _interval:Number;
      
      private var _userLabelUnits:String = null;
      
      private var dayP:String;
      
      private var _userMinorTickInterval:Number;
      
      private var _alignLabelsToUnits:Boolean = true;
      
      private var minutesP:String;
      
      private var _minorTickInterval:Number;
      
      private var _userDataInterval:Number;
      
      private var _userDataUnits:String = null;
      
      private var UNIT_PROGRESSION:Object = {
         "milliseconds":null,
         "seconds":"milliseconds",
         "minutes":"seconds",
         "hours":"minutes",
         "days":"hours",
         "weeks":"days",
         "months":"weeks",
         "years":"months"
      };
      
      private var fullYearP:String;
      
      private var _dataUnits:String = null;
      
      private var dateP:String;
      
      private var _dataInterval:Number = 1;
      
      private var _labelUnits:String;
      
      private var millisecondsP:String;
      
      private var _disabledRanges:Array;
      
      private var _displayLocalTime:Boolean = false;
      
      private var dateRangeUtilities:DateRangeUtilities = new DateRangeUtilities();
      
      private var secondsP:String;
      
      private var _minorTickUnits:String;
      
      private var monthP:String;
      
      private var _disabledDays:Array;
      
      private var _userMinorTickUnits:String = null;
      
      public function DateTimeAxis()
      {
         super();
         baseAtZero = false;
         autoAdjust = false;
         updatePropertyAccessors();
      }
      
      override public function reduceLabels(intervalStart:AxisLabel, intervalEnd:AxisLabel) : AxisLabelSet
      {
         var i:int = 0;
         var milliInterval:Number = NaN;
         var intervalMultiplier:int = 0;
         switch(_labelUnits)
         {
            case "months":
               intervalMultiplier = Math.floor((intervalEnd.value[fullYearP] * 12 + intervalEnd.value[monthP] - (intervalStart.value[fullYearP] * 12 + intervalStart.value[monthP])) / computedInterval) + 1;
               break;
            case "years":
               intervalMultiplier = Math.floor((intervalEnd.value[fullYearP] - intervalStart.value[fullYearP]) / computedInterval) + 1;
               break;
            default:
               milliInterval = toMilli(computedInterval,_labelUnits);
               intervalMultiplier = Math.floor((intervalEnd.value.getTime() - intervalStart.value.getTime()) / milliInterval) + 1;
         }
         var labels:Array = [];
         var newTicks:Array = [];
         var newMinorTicks:Array = [];
         for(i = 0; i < labelCache.length; i += intervalMultiplier)
         {
            labels.push(labelCache[i]);
            newTicks.push(labelCache[i].position);
         }
         if(computedInterval == _minorTickInterval && intervalMultiplier > 1)
         {
            for(i = intervalMultiplier - 1; i >= 1; i--)
            {
               if(intervalMultiplier % i == 0)
               {
                  intervalMultiplier = i;
                  break;
               }
            }
         }
         for(i = 0; i < minorTickCache.length; i += intervalMultiplier)
         {
            newMinorTicks.push(minorTickCache[i]);
         }
         var labelSet:AxisLabelSet = new AxisLabelSet();
         labelSet.labels = labels;
         labelSet.minorTicks = newMinorTicks;
         labelSet.ticks = newTicks;
         labelSet.accurate = true;
         return labelSet;
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get minimum() : Date
      {
         return new Date(computedMinimum);
      }
      
      private function toMilli(v:Number, unit:String) : Number
      {
         switch(unit)
         {
            case "milliseconds":
               return v;
            case "seconds":
               return v * 1000;
            case "minutes":
               return v * MILLISECONDS_IN_MINUTE;
            case "hours":
               return v * MILLISECONDS_IN_HOUR;
            case "weeks":
               return v * MILLISECONDS_IN_WEEK;
            case "months":
               return v * MILLISECONDS_IN_MONTH;
            case "years":
               return v * MILLISECONDS_IN_YEAR;
            case "days":
         }
         return v * MILLISECONDS_IN_DAY;
      }
      
      private function chooseLabelFunction() : Function
      {
         if(labelFunction != null)
         {
            return labelFunction;
         }
         switch(_labelUnits)
         {
            case "years":
               return formatYears;
            case "months":
               return formatMonths;
            case "days":
            case "weeks":
               return formatDays;
            case "hours":
            case "minutes":
               return formatMinutes;
            case "seconds":
               return formatSeconds;
            case "milliseconds":
               return formatMilliseconds;
            default:
               return formatDays;
         }
      }
      
      private function roundDateUp(d:Date, units:String) : void
      {
         switch(units)
         {
            case "seconds":
               if(d[millisecondsP] > 0)
               {
                  d[secondsP] += 1;
                  d[millisecondsP] = 0;
               }
               break;
            case "minutes":
               if(d[secondsP] > 0 || d[millisecondsP] > 0)
               {
                  d[minutesP] += 1;
                  d[secondsP] = 0;
                  d[millisecondsP] = 0;
               }
               break;
            case "hours":
               if(d[minutesP] > 0 || d[secondsP] > 0 || d[millisecondsP] > 0)
               {
                  d[hoursP] += 1;
                  d[minutesP] = 0;
                  d[secondsP] = 0;
                  d[millisecondsP] = 0;
               }
               break;
            case "days":
               if(d[hoursP] > 0 || d[minutesP] > 0 || d[secondsP] > 0 || d[millisecondsP] > 0)
               {
                  d[hoursP] = 0;
                  d[minutesP] = 0;
                  d[secondsP] = 0;
                  d[millisecondsP] = 0;
                  d[dateP] += 1;
               }
               break;
            case "weeks":
               d[hoursP] = 0;
               d[minutesP] = 0;
               d[secondsP] = 0;
               d[millisecondsP] = 0;
               if(d[dayP] != 0)
               {
                  d[dateP] += 7 - d[dayP];
               }
               break;
            case "months":
               if(d[dateP] > 1 || d[hoursP] > 0 || d[minutesP] > 0 || d[secondsP] > 0 || d[millisecondsP] > 0)
               {
                  d[hoursP] = 0;
                  d[minutesP] = 0;
                  d[secondsP] = 0;
                  d[millisecondsP] = 0;
                  d[dateP] = 1;
                  d[monthP] += 1;
               }
               break;
            case "years":
               if(d[monthP] > 0 || d[dateP] > 1 || d[hoursP] > 0 || d[minutesP] > 0 || d[secondsP] > 0 || d[millisecondsP] > 0)
               {
                  d[hoursP] = 0;
                  d[minutesP] = 0;
                  d[secondsP] = 0;
                  d[millisecondsP] = 0;
                  d[dateP] = 1;
                  d[monthP] = 0;
                  d[fullYearP] += 1;
               }
         }
      }
      
      public function set minimum(value:Date) : void
      {
         if(value != null)
         {
            assignedMinimum = value.getTime();
         }
         else
         {
            assignedMinimum = NaN;
         }
         invalidateCache();
         dispatchEvent(new Event("mappingChange"));
         dispatchEvent(new Event("axisChange"));
      }
      
      [Inspectable]
      public function set dataInterval(value:Number) : void
      {
         if(isNaN(value))
         {
            value = 1;
         }
         _dataInterval = _userDataInterval = value;
         if(_userDataUnits != null)
         {
            _unitSize = toMilli(_dataInterval,_userDataUnits);
         }
         else
         {
            _unitSize = MILLISECONDS_IN_DAY;
         }
         invalidateCache();
         dispatchEvent(new Event("mappingChange"));
         dispatchEvent(new Event("axisChange"));
      }
      
      protected function formatYears(d:Date, previousValue:Date, axis:DateTimeAxis) : String
      {
         var fy:Number = Number(d[fullYearP]);
         return fy.toString();
      }
      
      [Inspectable(category="General",defaultValue="null")]
      public function get maximum() : Date
      {
         return new Date(computedMaximum);
      }
      
      override protected function adjustMinMax(minValue:Number, maxValue:Number) : void
      {
         var min:Number = NaN;
         var max:Number = NaN;
         var units:String = null;
         var i:int = 0;
         var descriptions:Array = null;
         var minInterval:Number = NaN;
         var interval:Number = _interval;
         var adjustMin:Boolean = autoAdjust && isNaN(assignedMinimum);
         var adjustMax:Boolean = autoAdjust && isNaN(assignedMaximum);
         var delta:Number = minValue - maxValue;
         var validUnitFound:Boolean = false;
         var labelInterval:Number = isNaN(_interval) ? 1 : _interval;
         if(_userDataUnits == null)
         {
            units = "years";
            _dataInterval = 1;
            if(_userLabelUnits != null && _userLabelUnits != "")
            {
               units = _userLabelUnits;
            }
            descriptions = dataDescriptions;
            minInterval = Infinity;
            for(i = 0; i < descriptions.length; i++)
            {
               interval = Number(descriptions[i].minInterval);
               if(!isNaN(interval))
               {
                  minInterval = Math.min(interval,minInterval);
               }
            }
            if(minInterval == Infinity || minInterval == 0)
            {
               _unitSize = MILLISECONDS_IN_DAY;
               _dataUnits = "days";
            }
            else
            {
               while(units != null)
               {
                  _unitSize = toMilli(1,units);
                  if(_unitSize <= minInterval)
                  {
                     break;
                  }
                  units = UNIT_PROGRESSION[units];
               }
               if(units == null)
               {
                  _unitSize = MILLISECONDS_IN_DAY;
               }
               else
               {
                  _dataUnits = units;
               }
            }
         }
         else
         {
            _dataUnits = _userDataUnits;
            _dataInterval = isNaN(_userDataInterval) ? 1 : _userDataInterval;
         }
         units = "years";
         if(_userLabelUnits != null && _userLabelUnits != "")
         {
            units = _userLabelUnits;
         }
         var lastValidUnits:String = units;
         var minD:Date = new Date(minValue);
         var maxD:Date = new Date(maxValue);
         var minMilli:Number = minValue;
         var maxMilli:Number = maxValue;
         while(units != null)
         {
            lastValidUnits = units;
            if(units == _dataUnits)
            {
               labelInterval = Math.max(labelInterval,_dataInterval);
            }
            if(adjustMin)
            {
               minD.setTime(minValue);
               roundDateDown(minD,units);
               minMilli = minD.getTime();
            }
            if(adjustMax)
            {
               maxD.setTime(maxValue);
               roundDateUp(maxD,units);
               maxMilli = maxD.getTime();
            }
            switch(units)
            {
               case "milliseconds":
                  minMilli = minValue;
                  maxMilli = maxValue;
                  break;
               case "seconds":
               case "hours":
               case "days":
               case "minutes":
               case "years":
                  min = fromMilli(minD.getTime(),units);
                  max = fromMilli(maxD.getTime(),units);
                  if(max - min >= MINIMUM_LABEL_COUNT * labelInterval)
                  {
                     validUnitFound = true;
                  }
                  break;
               case "weeks":
                  if(fromMilli(maxMilli - minMilli,"weeks") >= MINIMUM_LABEL_COUNT * labelInterval)
                  {
                     validUnitFound = true;
                  }
                  break;
               case "months":
                  min = minD[monthP] + minD[fullYearP] * 12;
                  max = maxD[monthP] + maxD[fullYearP] * 12;
                  if(max - min >= MINIMUM_LABEL_COUNT * labelInterval)
                  {
                     validUnitFound = true;
                  }
            }
            if(validUnitFound)
            {
               break;
            }
            if(units == _userLabelUnits || UNIT_PROGRESSION[units] == null)
            {
               break;
            }
            if(units == _dataUnits)
            {
               if(labelInterval <= _dataInterval)
               {
                  break;
               }
               labelInterval = _dataInterval;
            }
            else
            {
               units = UNIT_PROGRESSION[units];
            }
         }
         _labelUnits = lastValidUnits;
         if(_userMinorTickUnits != null && _userMinorTickUnits != "")
         {
            _minorTickInterval = isNaN(_userMinorTickInterval) ? 1 : _userMinorTickInterval;
            _minorTickUnits = _userMinorTickUnits;
         }
         else if(labelInterval == 1)
         {
            _minorTickInterval = 1;
            _minorTickUnits = _labelUnits;
         }
         else
         {
            _minorTickUnits = _labelUnits;
            for(i = 2; i <= labelInterval; i++)
            {
               if(labelInterval % i == 0)
               {
                  _minorTickInterval = labelInterval / i;
                  break;
               }
            }
         }
         invalidateCache();
         if(adjustMin)
         {
            computedMinimum = minMilli;
         }
         if(adjustMax)
         {
            computedMaximum = maxMilli;
         }
         computedInterval = labelInterval;
      }
      
      private function roundDateDown(d:Date, units:String) : void
      {
         switch(units)
         {
            case "seconds":
               d[secondsP] = 0;
               break;
            case "minutes":
               d[secondsP] = 0;
               d[millisecondsP] = 0;
               break;
            case "hours":
               d[minutesP] = 0;
               d[secondsP] = 0;
               d[millisecondsP] = 0;
               break;
            case "days":
               d[hoursP] = 0;
               d[minutesP] = 0;
               d[secondsP] = 0;
               d[millisecondsP] = 0;
               break;
            case "weeks":
               d[hoursP] = 0;
               d[minutesP] = 0;
               d[secondsP] = 0;
               d[millisecondsP] = 0;
               if(d[dayP] != 0)
               {
                  d[dateP] -= d[dayP];
               }
               break;
            case "months":
               d[hoursP] = 0;
               d[minutesP] = 0;
               d[secondsP] = 0;
               d[millisecondsP] = 0;
               d[dateP] = 1;
               break;
            case "years":
               d[hoursP] = 0;
               d[minutesP] = 0;
               d[secondsP] = 0;
               d[millisecondsP] = 0;
               d[dateP] = 1;
               d[monthP] = 0;
         }
      }
      
      [Inspectable(category="General")]
      public function get displayLocalTime() : Boolean
      {
         return _displayLocalTime;
      }
      
      public function set minorTickUnits(value:String) : void
      {
         _minorTickUnits = _userMinorTickUnits = value;
         invalidateCache();
         dispatchEvent(new Event("mappingChange"));
         dispatchEvent(new Event("axisChange"));
      }
      
      public function set maximum(value:Date) : void
      {
         if(value != null)
         {
            assignedMaximum = value.getTime();
         }
         else
         {
            assignedMaximum = NaN;
         }
         invalidateCache();
         dispatchEvent(new Event("mappingChange"));
         dispatchEvent(new Event("axisChange"));
      }
      
      private function fromMilli(v:Number, unit:String) : Number
      {
         switch(unit)
         {
            case "milliseconds":
               return v;
            case "seconds":
               return v / 1000;
            case "minutes":
               return v / MILLISECONDS_IN_MINUTE;
            case "hours":
               return v / MILLISECONDS_IN_HOUR;
            case "days":
               return v / MILLISECONDS_IN_DAY;
            case "weeks":
               return v / MILLISECONDS_IN_WEEK;
            case "months":
               return v / MILLISECONDS_IN_MONTH;
            case "years":
               return v / MILLISECONDS_IN_YEAR;
            default:
               return NaN;
         }
      }
      
      [Inspectable(category="Other")]
      override public function set parseFunction(value:Function) : void
      {
         super.parseFunction = value;
      }
      
      override public function formatForScreen(v:Object) : String
      {
         var d:Date = tmpDate;
         if(parseFunction != null)
         {
            d = parseFunction(v);
         }
         else if(v is String)
         {
            d.setTime(Date.parse(v));
         }
         else if(v is Date)
         {
            d = v as Date;
         }
         else
         {
            d.setTime(v);
         }
         var f:Function = chooseLabelFunction();
         return f(d,null,this);
      }
      
      public function set alignLabelsToUnits(value:Boolean) : void
      {
         if(value != _alignLabelsToUnits)
         {
            _alignLabelsToUnits = value;
            invalidateCache();
            dispatchEvent(new Event("mappingChange"));
            dispatchEvent(new Event("axisChange"));
         }
      }
      
      public function set displayLocalTime(value:Boolean) : void
      {
         _displayLocalTime = value;
         invalidateCache();
         dispatchEvent(new Event("mappingChange"));
         dispatchEvent(new Event("axisChange"));
         updatePropertyAccessors();
      }
      
      [Inspectable(arrayType="Object",category="General",defaultValue="null")]
      public function get disabledRanges() : Array
      {
         return _disabledRanges;
      }
      
      override protected function get requiredDescribedFields() : uint
      {
         var fields:uint = uint(DataDescription.REQUIRED_MIN_MAX | DataDescription.REQUIRED_BOUNDED_VALUES);
         if(_userDataUnits == null)
         {
            fields |= DataDescription.REQUIRED_MIN_INTERVAL;
         }
         return fields;
      }
      
      override public function transformCache(cache:Array, field:String, convertedField:String) : void
      {
         var i:int = 0;
         var diff:Number = NaN;
         update();
         var alen:Number = computedMaximum - computedMinimum - dateRangeUtilities.calculateDisabledRange(computedMinimum,computedMaximum);
         var n:int = int(cache.length);
         if(Boolean(disabledRanges) || Boolean(disabledDays))
         {
            diff = 0;
            for(i = 0; i < n; i++)
            {
               diff = dateRangeUtilities.calculateDisabledRange(computedMinimum,cache[i][field]);
               cache[i][convertedField] = (cache[i][field] - diff - computedMinimum) / alen;
            }
         }
         else
         {
            super.transformCache(cache,field,convertedField);
         }
      }
      
      override public function mapCache(cache:Array, field:String, convertedField:String, indexValues:Boolean = false) : void
      {
         var i:int = 0;
         var v:Object = null;
         var tmpValue:Number = NaN;
         var d:Date = null;
         var n:int = int(cache.length);
         var parseFunction:Function = this.parseFunction;
         if(parseFunction != null)
         {
            for(i = 0; i < n; i++)
            {
               v = cache[i];
               d = parseFunction(v[field]);
               if(d != null)
               {
                  v[convertedField] = d.getTime();
               }
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
                  v[convertedField] = Date.parse(v[field]);
                  i++;
               }
            }
            else if(cache[i][field] is XML || cache[i][field] is XMLList)
            {
               v = cache[i];
               if(isNaN(Number(v[field].toString())))
               {
                  while(i < n)
                  {
                     v = cache[i];
                     v[convertedField] = Date.parse(v[field].toString());
                     i++;
                  }
               }
               else
               {
                  while(i < n)
                  {
                     v = cache[i];
                     v[convertedField] = Number(v[field].toString());
                     i++;
                  }
               }
            }
            else if(cache[i][field] is Date)
            {
               while(i < n)
               {
                  v = cache[i];
                  v[convertedField] = v[field].getTime();
                  i++;
               }
            }
            else
            {
               while(i < n)
               {
                  v = cache[i];
                  v[convertedField] = v[field];
                  i++;
               }
            }
         }
      }
      
      protected function formatSeconds(d:Date, previousValue:Date, axis:DateTimeAxis) : String
      {
         return d[hoursP] + ":" + (d[minutesP] < 10 ? "0" + d[minutesP] : d[minutesP]) + ":" + (d[secondsP] < 10 ? "0" + d[secondsP] : d[secondsP]);
      }
      
      public function set interval(value:Number) : void
      {
         _interval = Math.max(1,value);
         invalidateCache();
         dispatchEvent(new Event("mappingChange"));
         dispatchEvent(new Event("axisChange"));
      }
      
      [Inspectable(category="General",enumeration="milliseconds,seconds,minutes,hours,days,weeks,months,years")]
      public function get minorTickUnits() : String
      {
         return _minorTickUnits;
      }
      
      override public function get unitSize() : Number
      {
         return _unitSize;
      }
      
      protected function formatMilliseconds(d:Date, previousValue:Date, axis:DateTimeAxis) : String
      {
         var i:int = 0;
         var s:String = d[hoursP] + ":" + (d[minutesP] < 10 ? "0" + d[minutesP] : d[minutesP]) + ":" + (d[secondsP] < 10 ? "0" + d[secondsP] : d[secondsP]);
         var m:String = d[millisecondsP].toString();
         if(m.length < 4)
         {
            for(i = m.length; i < 4; i++)
            {
               m = "0" + m;
            }
         }
         return s + m;
      }
      
      public function set minorTickInterval(value:Number) : void
      {
         _userMinorTickInterval = value;
         invalidateCache();
         dispatchEvent(new Event("mappingChange"));
         dispatchEvent(new Event("axisChange"));
      }
      
      public function get alignLabelsToUnits() : Boolean
      {
         return _alignLabelsToUnits;
      }
      
      public function set labelUnits(value:String) : void
      {
         _userLabelUnits = _labelUnits = value;
         invalidateCache();
         dispatchEvent(new Event("mappingChange"));
         dispatchEvent(new Event("axisChange"));
      }
      
      override protected function buildMinorTickCache() : Array
      {
         var labelDate:Date = null;
         var dTime:Number = NaN;
         var j:int = 0;
         var nextMonth:Number = NaN;
         var nextYear:Number = NaN;
         var i:Number = NaN;
         var tmp:Date = null;
         var cache:Array = [];
         var d:Date = new Date();
         var r:Number = computedMaximum - computedMinimum - dateRangeUtilities.calculateDisabledRange(computedMinimum,computedMaximum);
         var milliInterval:Number = toMilli(_minorTickInterval,_minorTickUnits);
         var labelBase:Number = labelMinimum;
         var labelTop:Number = labelMaximum + 0.000001;
         var previousValue:Date = null;
         var tzo:Number = 0;
         var disabled:Boolean = false;
         var diff:Number = 0;
         labelDate = new Date(labelBase);
         if(_alignLabelsToUnits)
         {
            roundDateUp(labelDate,_minorTickUnits);
         }
         labelBase = labelDate.getTime();
         switch(_minorTickUnits)
         {
            case "months":
               nextMonth = Number(labelDate[monthP]);
               while(labelDate.getTime() <= labelTop)
               {
                  dTime = labelDate.getTime();
                  if(Boolean(disabledDays) || Boolean(disabledRanges))
                  {
                     if(previousValue != null)
                     {
                        diff = dateRangeUtilities.getDisabledRange(previousValue.getTime() + 1,dTime,_minorTickUnits);
                     }
                     else
                     {
                        diff = dateRangeUtilities.getDisabledRange(computedMinimum,dTime,_minorTickUnits);
                     }
                     if(!dateRangeUtilities.isDisabled(dTime))
                     {
                        cache.push((dTime - computedMinimum - diff) / r);
                     }
                  }
                  else
                  {
                     cache.push((dTime - computedMinimum) / r);
                  }
                  if(previousValue == null)
                  {
                     previousValue = new Date(dTime);
                  }
                  else
                  {
                     previousValue.setTime(dTime);
                  }
                  nextMonth += _minorTickInterval;
                  labelDate.setTime(labelBase);
                  labelDate[monthP] = nextMonth;
                  if(labelDate[monthP] != nextMonth % 12)
                  {
                     labelDate[dateP] = 0;
                  }
               }
               break;
            case "years":
               nextYear = Number(labelDate[fullYearP]);
               while(labelDate.getTime() <= labelTop)
               {
                  dTime = labelDate.getTime();
                  if(Boolean(disabledDays) || Boolean(disabledRanges))
                  {
                     if(previousValue != null)
                     {
                        diff = dateRangeUtilities.getDisabledRange(previousValue.getTime() + 1,dTime,_minorTickUnits);
                     }
                     else
                     {
                        diff = dateRangeUtilities.getDisabledRange(computedMinimum,dTime,_minorTickUnits);
                     }
                     if(!dateRangeUtilities.isDisabled(dTime))
                     {
                        cache.push((dTime - computedMinimum - diff) / r);
                     }
                  }
                  else
                  {
                     cache.push((dTime - computedMinimum) / r);
                  }
                  if(previousValue == null)
                  {
                     previousValue = new Date(dTime);
                  }
                  else
                  {
                     previousValue.setTime(dTime);
                  }
                  nextYear += _minorTickInterval;
                  labelDate.setTime(labelBase);
                  labelDate[fullYearP] = nextYear;
                  if(labelDate[fullYearP] != nextYear)
                  {
                     labelDate[dateP] = 0;
                  }
               }
               break;
            default:
               i = labelBase;
               while(i <= labelTop)
               {
                  d = new Date(i);
                  if(Boolean(disabledDays) || Boolean(disabledRanges))
                  {
                     if(previousValue != null)
                     {
                        diff = dateRangeUtilities.getDisabledRange(previousValue.getTime() + 1,i,_minorTickUnits);
                     }
                     else
                     {
                        diff = dateRangeUtilities.getDisabledRange(computedMinimum,i,_minorTickUnits);
                     }
                     if(!dateRangeUtilities.isDisabled(i))
                     {
                        cache.push((i - computedMinimum - diff) / r);
                     }
                  }
                  else
                  {
                     cache.push((i - computedMinimum) / r);
                  }
                  previousValue = d;
                  tmp = new Date(i);
                  if(_minorTickUnits == "weeks")
                  {
                     tmp.dateUTC += 7 * _minorTickInterval;
                     i = tmp.time;
                  }
                  else if(_minorTickUnits == "hours")
                  {
                     tmp.hoursUTC += _minorTickInterval;
                     i = tmp.time;
                  }
                  else if(_minorTickUnits == "minutes")
                  {
                     tmp.minutesUTC += _minorTickInterval;
                     i = tmp.time;
                  }
                  else if(_minorTickUnits == "seconds")
                  {
                     tmp.secondsUTC += _minorTickInterval;
                     i = tmp.time;
                  }
                  else if(_minorTickUnits == "milliseconds")
                  {
                     tmp.millisecondsUTC += _minorTickInterval;
                     i = tmp.time;
                  }
                  else
                  {
                     tmp.dateUTC += _minorTickInterval;
                     i = tmp.time;
                  }
               }
         }
         return cache;
      }
      
      [Inspectable(category="General")]
      public function get interval() : Number
      {
         return _interval;
      }
      
      override protected function guardMinMax(min:Number, max:Number) : Array
      {
         if(isNaN(min) || !isFinite(min))
         {
            return [0,100];
         }
         if(isNaN(max) || !isFinite(max))
         {
            return [min,min + 1];
         }
         if(min == max)
         {
            return [min,min + 1];
         }
         return null;
      }
      
      protected function formatMonths(d:Date, previousValue:Date, axis:DateTimeAxis) : String
      {
         var fy:Number = Number(d[fullYearP]);
         return d[monthP] + 1 + "/" + (fy % 100 < 10 ? "0" + fy % 100 : fy % 100);
      }
      
      public function set dataUnits(value:String) : void
      {
         _dataUnits = _userDataUnits = value;
         if(_dataUnits != null)
         {
            _unitSize = toMilli(_dataInterval,_dataUnits);
         }
         else
         {
            _unitSize = MILLISECONDS_IN_DAY;
         }
         invalidateCache();
         dispatchEvent(new Event("mappingChange"));
         dispatchEvent(new Event("axisChange"));
      }
      
      [Inspectable(category="General")]
      public function get minorTickInterval() : Number
      {
         return _userMinorTickInterval;
      }
      
      [Inspectable(category="General",enumeration="milliseconds,seconds,minutes,hours,days,weeks,months,years")]
      public function get labelUnits() : String
      {
         return _labelUnits;
      }
      
      public function set disabledRanges(value:Array) : void
      {
         _disabledRanges = value;
         invalidateCache();
         dispatchEvent(new Event("mappingChange"));
         dispatchEvent(new Event("axisChange"));
      }
      
      [Inspectable(category="General",enumeration="milliseconds,seconds,minutes,hours,days,weeks,months,years",defaultValue="days")]
      public function get dataUnits() : String
      {
         return _dataUnits;
      }
      
      public function set disabledDays(value:Array) : void
      {
         _disabledDays = value;
         invalidateCache();
         dispatchEvent(new Event("mappingChange"));
         dispatchEvent(new Event("axisChange"));
      }
      
      protected function formatMinutes(d:Date, previousValue:Date, axis:DateTimeAxis) : String
      {
         return d[hoursP] + ":" + (d[minutesP] < 10 ? "0" + d[minutesP] : d[minutesP]);
      }
      
      override public function filterCache(cache:Array, field:String, filteredField:String) : void
      {
         var i:int = 0;
         super.filterCache(cache,field,filteredField);
         var n:int = int(cache.length);
         if(Boolean(disabledRanges) || Boolean(disabledDays))
         {
            for(i = 0; i < n; i++)
            {
               cache[i][filteredField] = dateRangeUtilities.isDisabled(cache[i][field]) ? NaN : cache[i][field];
            }
         }
      }
      
      protected function formatDays(d:Date, previousValue:Date, axis:DateTimeAxis) : String
      {
         var fy:Number = Number(d[fullYearP]);
         return d[monthP] + 1 + "/" + d[dateP] + "/" + (fy % 100 < 10 ? "0" + fy % 100 : fy % 100);
      }
      
      [Inspectable(arrayType="int",category="General",defaultValue="null")]
      public function get disabledDays() : Array
      {
         return _disabledDays;
      }
      
      private function updatePropertyAccessors() : void
      {
         if(_displayLocalTime)
         {
            millisecondsP = "milliseconds";
            secondsP = "seconds";
            minutesP = "minutes";
            hoursP = "hours";
            dateP = "date";
            dayP = "day";
            monthP = "month";
            fullYearP = "fullYear";
         }
         else
         {
            millisecondsP = "millisecondsUTC";
            secondsP = "secondsUTC";
            minutesP = "minutesUTC";
            hoursP = "hoursUTC";
            dateP = "dateUTC";
            dayP = "dayUTC";
            monthP = "monthUTC";
            fullYearP = "fullYearUTC";
         }
      }
      
      override protected function buildLabelCache() : Boolean
      {
         var j:int = 0;
         var labelDate:Date = null;
         var dTime:Number = NaN;
         var nextMonth:Number = NaN;
         var nextYear:Number = NaN;
         var i:Number = NaN;
         var tmp:Date = null;
         dateRangeUtilities.createDisabledRangeSet(disabledDays,disabledRanges,computedMinimum,computedMaximum);
         var lfunc:Function = chooseLabelFunction();
         if(Boolean(labelCache))
         {
            return false;
         }
         var d:Date = new Date();
         labelCache = [];
         var r:Number = computedMaximum - computedMinimum - dateRangeUtilities.calculateDisabledRange(computedMinimum,computedMaximum);
         var milliInterval:Number = toMilli(computedInterval,_labelUnits);
         var labelBase:Number = labelMinimum;
         var labelTop:Number = labelMaximum + 0.000001;
         var previousValue:Date = null;
         var diff:Number = 0;
         var tzo:Number = 0;
         var firstLabelAdded:Boolean = false;
         labelDate = new Date(labelBase);
         if(_alignLabelsToUnits)
         {
            roundDateUp(labelDate,_labelUnits);
         }
         labelBase = labelDate.getTime();
         switch(_labelUnits)
         {
            case "months":
               nextMonth = Number(labelDate[monthP]);
               while(labelDate.getTime() <= labelTop)
               {
                  dTime = labelDate.getTime();
                  if(Boolean(disabledDays) || Boolean(disabledRanges))
                  {
                     if(previousValue != null)
                     {
                        diff = dateRangeUtilities.getDisabledRange(previousValue.getTime() + 1,dTime,_labelUnits);
                     }
                     else
                     {
                        diff = dateRangeUtilities.getDisabledRange(computedMinimum,dTime,_labelUnits);
                     }
                     if(!dateRangeUtilities.isDisabled(dTime))
                     {
                        labelCache.push(new AxisLabel((dTime - computedMinimum - diff) / r,new Date(dTime),lfunc(labelDate,previousValue,this)));
                     }
                  }
                  else
                  {
                     labelCache.push(new AxisLabel((dTime - computedMinimum) / r,new Date(dTime),lfunc(labelDate,previousValue,this)));
                  }
                  if(previousValue == null)
                  {
                     previousValue = new Date(dTime);
                  }
                  else
                  {
                     previousValue.setTime(dTime);
                  }
                  nextMonth += computedInterval;
                  labelDate.setTime(labelBase);
                  labelDate[monthP] = nextMonth;
                  if(labelDate[monthP] != nextMonth % 12)
                  {
                     labelDate[dateP] = 0;
                  }
               }
               break;
            case "years":
               nextYear = Number(labelDate[fullYearP]);
               while(labelDate.getTime() <= labelTop)
               {
                  dTime = labelDate.getTime();
                  if(Boolean(disabledDays) || Boolean(disabledRanges))
                  {
                     if(previousValue != null)
                     {
                        diff = dateRangeUtilities.getDisabledRange(previousValue.getTime() + 1,dTime,_labelUnits);
                     }
                     else
                     {
                        diff = dateRangeUtilities.getDisabledRange(computedMinimum,dTime,_labelUnits);
                     }
                     if(!dateRangeUtilities.isDisabled(dTime))
                     {
                        labelCache.push(new AxisLabel((dTime - computedMinimum - diff) / r,new Date(dTime),lfunc(labelDate,previousValue,this)));
                     }
                  }
                  else
                  {
                     labelCache.push(new AxisLabel((dTime - computedMinimum) / r,new Date(dTime),lfunc(labelDate,previousValue,this)));
                  }
                  if(previousValue == null)
                  {
                     previousValue = new Date(dTime);
                  }
                  else
                  {
                     previousValue.setTime(dTime);
                  }
                  nextYear += computedInterval;
                  labelDate.setTime(labelBase);
                  labelDate[fullYearP] = nextYear;
                  if(labelDate[fullYearP] != nextYear)
                  {
                     labelDate[dateP] = 0;
                  }
               }
               break;
            default:
               for(i = labelBase; i <= labelTop; )
               {
                  d = new Date(i);
                  if(Boolean(disabledDays) || Boolean(disabledRanges))
                  {
                     if(previousValue != null)
                     {
                        diff = dateRangeUtilities.getDisabledRange(previousValue.getTime() + 1,i,_labelUnits);
                     }
                     else
                     {
                        diff = dateRangeUtilities.getDisabledRange(computedMinimum,i,_labelUnits);
                     }
                     if(!dateRangeUtilities.isDisabled(i))
                     {
                        labelCache.push(new AxisLabel((i - computedMinimum - diff) / r,d,lfunc(d,previousValue,this)));
                        if(!firstLabelAdded)
                        {
                           firstLabelAdded = true;
                        }
                     }
                     previousValue = d;
                     if(!firstLabelAdded)
                     {
                        i += MILLISECONDS_IN_DAY;
                     }
                     else
                     {
                        tmp = new Date(i);
                        if(_labelUnits == "weeks")
                        {
                           tmp.dateUTC += 7 * computedInterval;
                           i = tmp.time;
                        }
                        else if(_labelUnits == "hours")
                        {
                           tmp.hoursUTC += computedInterval;
                           i = tmp.time;
                        }
                        else if(_labelUnits == "minutes")
                        {
                           tmp.minutesUTC += computedInterval;
                           i = tmp.time;
                        }
                        else if(_labelUnits == "seconds")
                        {
                           tmp.secondsUTC += computedInterval;
                           i = tmp.time;
                        }
                        else if(_labelUnits == "milliseconds")
                        {
                           tmp.millisecondsUTC += computedInterval;
                           i = tmp.time;
                        }
                        else
                        {
                           tmp.dateUTC += computedInterval;
                           i = tmp.time;
                        }
                     }
                  }
                  else
                  {
                     labelCache.push(new AxisLabel((i - computedMinimum) / r,d,lfunc(d,previousValue,this)));
                     previousValue = d;
                     tmp = new Date(i);
                     if(_labelUnits == "weeks")
                     {
                        tmp.dateUTC += 7 * computedInterval;
                        i = tmp.time;
                     }
                     else if(_labelUnits == "hours")
                     {
                        tmp.hoursUTC += computedInterval;
                        i = tmp.time;
                     }
                     else if(_labelUnits == "minutes")
                     {
                        tmp.minutesUTC += computedInterval;
                        i = tmp.time;
                     }
                     else if(_labelUnits == "seconds")
                     {
                        tmp.secondsUTC += computedInterval;
                        i = tmp.time;
                     }
                     else if(_labelUnits == "milliseconds")
                     {
                        tmp.millisecondsUTC += computedInterval;
                        i = tmp.time;
                     }
                     else
                     {
                        tmp.dateUTC += computedInterval;
                        i = tmp.time;
                     }
                  }
               }
         }
         return true;
      }
   }
}

