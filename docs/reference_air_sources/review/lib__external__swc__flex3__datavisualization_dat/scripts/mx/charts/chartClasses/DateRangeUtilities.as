package mx.charts.chartClasses
{
   import mx.collections.ArrayCollection;
   
   public class DateRangeUtilities
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private static var disabledDayDifference:Number = 0;
      
      private var disabledRangeSet:Array = [];
      
      private const MILLISECONDS_IN_MINUTE:Number = 60000;
      
      private var disabledDaySet:Array = [];
      
      private var minimum:Number;
      
      private const MILLISECONDS_IN_HOUR:Number = 3600000;
      
      private const MILLISECONDS_IN_MONTH:Number = 2592000000;
      
      private const MILLISECONDS_IN_WEEK:Number = 604800000;
      
      private const DAYS_IN_WEEK:Number = 7;
      
      private var begin:Boolean = true;
      
      private const MILLISECONDS_IN_YEAR:Number = 31536000000;
      
      private const MILLISECONDS_IN_DAY:Number = 86400000;
      
      public function DateRangeUtilities()
      {
         super();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function isDisabled(time:Number) : Boolean
      {
         var j:int = 0;
         var disabled:Boolean = false;
         var len:int = int(disabledRangeSet.length);
         var tmpDate:Date = new Date(time);
         if(Boolean(disabledDaySet))
         {
            if(disabledDaySet.indexOf(tmpDate.day) != -1)
            {
               return true;
            }
         }
         for(j = 0; j < len; j++)
         {
            if(time >= disabledRangeSet[j].rangeStart && time <= disabledRangeSet[j].rangeEnd)
            {
               disabled = true;
               break;
            }
            if(time < disabledRangeSet[j].rangeStart)
            {
               break;
            }
         }
         return disabled;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function calculateDisabledRange(start:Number, end:Number) : Number
      {
         var temp:Number = NaN;
         var range:Range = null;
         var i:int = 0;
         var tmpTime:Number = NaN;
         var disDay:Number = NaN;
         var tempDay:Number = NaN;
         var diff:Number = NaN;
         var difference:Number = 0;
         var tmpDate:Date = new Date(start);
         tmpDate.setHours(0,0,0,0);
         temp = tmpDate.getTime();
         temp += MILLISECONDS_IN_DAY;
         if(disabledDaySet.length > 0)
         {
            if(disabledDaySet.indexOf(tmpDate.day) != -1)
            {
               range = new Range(start,temp - 1);
               difference = getActualDisabledRange(range,difference);
            }
            tmpTime = temp;
            for(i = 0; i < disabledDaySet.length; i++)
            {
               disDay = Number(disabledDaySet[i]);
               temp = tmpTime;
               while(temp < end)
               {
                  tmpDate = new Date(temp);
                  tempDay = tmpDate.day;
                  if(tempDay == disDay)
                  {
                     range = new Range(temp,temp + MILLISECONDS_IN_DAY - 1);
                     difference = getActualDisabledRange(range,difference);
                     temp += MILLISECONDS_IN_WEEK;
                  }
                  else if(tempDay < disDay)
                  {
                     diff = disDay - tempDay;
                     temp += diff * MILLISECONDS_IN_DAY;
                     if(temp < end)
                     {
                        range = new Range(temp,temp + MILLISECONDS_IN_DAY - 1);
                        difference = getActualDisabledRange(range,difference);
                     }
                     temp += MILLISECONDS_IN_WEEK;
                  }
                  else
                  {
                     diff = DAYS_IN_WEEK - tempDay;
                     temp += (diff + disDay) * MILLISECONDS_IN_DAY;
                     if(temp < end)
                     {
                        range = new Range(temp,temp + MILLISECONDS_IN_DAY - 1);
                        difference = getActualDisabledRange(range,difference);
                     }
                     temp += MILLISECONDS_IN_WEEK;
                  }
               }
               if(temp == end)
               {
                  tmpDate = new Date(temp);
                  tempDay = tmpDate.day;
                  if(tempDay == disDay)
                  {
                     range = new Range(temp,temp + MILLISECONDS_IN_DAY - 1);
                     difference = getActualDisabledRange(range,difference);
                  }
               }
            }
         }
         var len:int = int(disabledRangeSet.length);
         for(i = 0; i < len; i++)
         {
            if(end <= disabledRangeSet[i].rangeStart)
            {
               break;
            }
            difference += disabledRangeSet[i].rangeEnd - disabledRangeSet[i].rangeStart;
         }
         return difference;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function createDisabledRangeSet(disabledDays:Array, disabledRanges:Array, computedMinimum:Number, computedMaximum:Number) : void
      {
         var rangeStart:Number = NaN;
         var rangeEnd:Number = NaN;
         var j:int = 0;
         var startTime:Number = NaN;
         var i:int = 0;
         var k:int = 0;
         disabledRangeSet = [];
         disabledDaySet = [];
         minimum = computedMinimum;
         if(Boolean(disabledDays))
         {
            for(j = 0; j < disabledDays.length; j++)
            {
               if(disabledDaySet.indexOf(disabledDays[j]) == -1 && disabledDays[j] >= 0 && disabledDays[j] <= 6)
               {
                  disabledDaySet.push(disabledDays[j]);
               }
            }
         }
         if(Boolean(disabledRanges))
         {
            for(j = 0; j < disabledRanges.length; j++)
            {
               if(disabledRanges[j] is Date)
               {
                  startTime = Date.parse(disabledRanges[j]);
                  rangeStart = Math.max(computedMinimum,startTime);
                  rangeEnd = Math.min(computedMaximum,startTime + MILLISECONDS_IN_DAY - 1);
                  if(rangeStart < rangeEnd)
                  {
                     disabledRangeSet.push(new Range(rangeStart,rangeEnd));
                  }
               }
               else if(disabledRanges[j] is Object)
               {
                  if(!disabledRanges[j].rangeStart && Boolean(disabledRanges[j].rangeEnd))
                  {
                     rangeStart = computedMinimum;
                     if(disabledRanges[i].rangeEnd.getHours() == 0 && disabledRanges[i].rangeEnd.getMinutes() == 0 && disabledRanges[i].rangeEnd.getSeconds() == 0 && disabledRanges[i].rangeEnd.getMilliseconds() == 0)
                     {
                        rangeEnd = Math.min(computedMaximum,Date.parse(disabledRanges[j].rangeEnd) + MILLISECONDS_IN_DAY - 1);
                     }
                     else
                     {
                        rangeEnd = Math.min(computedMaximum,Date.parse(disabledRanges[j].rangeEnd) - 1);
                     }
                     if(rangeStart < rangeEnd)
                     {
                        disabledRangeSet.push(new Range(rangeStart,rangeEnd));
                     }
                  }
                  else if(Boolean(disabledRanges[j].rangeStart) && !disabledRanges[j].rangeEnd)
                  {
                     rangeEnd = computedMaximum;
                     rangeStart = Math.max(computedMinimum,Date.parse(disabledRanges[j].rangeStart));
                     if(rangeStart < rangeEnd)
                     {
                        disabledRangeSet.push(new Range(rangeStart,rangeEnd));
                     }
                  }
                  else if(Boolean(disabledRanges[j].rangeStart) && Boolean(disabledRanges[j].rangeEnd))
                  {
                     if(disabledRanges[i].rangeEnd.getHours() == 0 && disabledRanges[i].rangeEnd.getMinutes() == 0 && disabledRanges[i].rangeEnd.getSeconds() == 0 && disabledRanges[i].rangeEnd.getMilliseconds() == 0)
                     {
                        rangeEnd = Math.min(computedMaximum,Date.parse(disabledRanges[j].rangeEnd) + MILLISECONDS_IN_DAY - 1);
                     }
                     else
                     {
                        rangeEnd = Math.min(computedMaximum,Date.parse(disabledRanges[j].rangeEnd) - 1);
                     }
                     rangeStart = Math.max(computedMinimum,Date.parse(disabledRanges[j].rangeStart));
                     if(rangeStart < rangeEnd)
                     {
                        disabledRangeSet.push(new Range(rangeStart,rangeEnd));
                     }
                  }
               }
            }
         }
         var disabledRangeSetChanged:Boolean = true;
         var disabledArray:ArrayCollection = new ArrayCollection(disabledRangeSet);
         for(j = 0; j < disabledRangeSet.length; )
         {
            for(i = 0; i < disabledArray.length; )
            {
               disabledRangeSetChanged = false;
               if(disabledArray[i].rangeStart >= disabledRangeSet[j].rangeStart && disabledArray[i].rangeEnd <= disabledRangeSet[j].rangeEnd && i != j)
               {
                  disabledArray[i].rangeStart = computedMinimum - 1;
                  disabledRangeSetChanged = true;
               }
               else if(disabledArray[i].rangeStart >= disabledRangeSet[j].rangeStart && disabledArray[i].rangeStart <= disabledRangeSet[j].rangeEnd && disabledArray[i].rangeEnd >= disabledRangeSet[j].rangeEnd && i != j)
               {
                  disabledArray[j].rangeEnd = disabledArray[i].rangeEnd;
                  disabledArray[i].rangeStart = computedMinimum - 1;
                  disabledRangeSetChanged = true;
               }
               else if(disabledArray[i].rangeStart <= disabledRangeSet[j].rangeStart && disabledArray[i].rangeEnd >= disabledRangeSet[j].rangeStart && disabledArray[i].rangeEnd <= disabledRangeSet[j].rangeEnd && i != j)
               {
                  disabledArray[j].rangeStart = disabledArray[i].rangeStart;
                  disabledArray[i].rangeStart = computedMinimum - 1;
                  disabledRangeSetChanged = true;
               }
               if(disabledRangeSetChanged)
               {
                  for(k = 0; k < disabledArray.length; )
                  {
                     if(disabledArray[k].rangeStart < computedMinimum)
                     {
                        disabledArray.removeItemAt(k);
                     }
                     else
                     {
                        k++;
                     }
                  }
                  disabledRangeSet = [];
                  for(k = 0; k < disabledArray.length; k++)
                  {
                     disabledRangeSet.push(disabledArray.getItemAt(k));
                  }
                  i = 0;
               }
               else
               {
                  i++;
               }
            }
            if(disabledRangeSetChanged)
            {
               j = 0;
            }
            else
            {
               j++;
            }
         }
         disabledRangeSet.sortOn(["rangeStart","rangeEnd"],[Array.NUMERIC]);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getDisabledRange(start:Number, end:Number, units:String) : Number
      {
         var temp:Number = NaN;
         var tmpDate:Date = null;
         var maxUnitLength:Number = NaN;
         var v:Object = null;
         var range:Range = null;
         var difference:Number = 0;
         var considered:Boolean = false;
         temp = start;
         switch(units)
         {
            case "years":
               maxUnitLength = MILLISECONDS_IN_YEAR;
               break;
            case "months":
               maxUnitLength = MILLISECONDS_IN_MONTH;
               break;
            default:
               maxUnitLength = MILLISECONDS_IN_DAY;
         }
         if(begin)
         {
            if(Math.abs(start - minimum) < maxUnitLength)
            {
               disabledDayDifference = 0;
               begin = false;
            }
         }
         else
         {
            begin = true;
         }
         if(Boolean(disabledDaySet))
         {
            while(temp < end)
            {
               tmpDate = new Date(temp);
               if(disabledDaySet.indexOf(tmpDate.day) != -1)
               {
                  range = new Range(temp,Math.min(temp + MILLISECONDS_IN_DAY - 1,end));
                  disabledDayDifference = getActualDisabledRange(range,disabledDayDifference);
               }
               temp += MILLISECONDS_IN_DAY;
            }
         }
         difference = disabledDayDifference;
         var i:int = 0;
         var len:int = int(disabledRangeSet.length);
         for(i = 0; i < len; i++)
         {
            if(end <= disabledRangeSet[i].rangeStart)
            {
               break;
            }
            difference += disabledRangeSet[i].rangeEnd - disabledRangeSet[i].rangeStart;
         }
         return difference;
      }
      
      private function getActualDisabledRange(range:Range, difference:Number) : Number
      {
         var j:int = 0;
         var considered:Boolean = false;
         if(disabledRangeSet.length != 0)
         {
            for(j = 0; j < disabledRangeSet.length; )
            {
               if(range.rangeStart >= disabledRangeSet[j].rangeStart && range.rangeEnd <= disabledRangeSet[j].rangeEnd)
               {
                  considered = true;
                  break;
               }
               if(range.rangeStart >= disabledRangeSet[j].rangeStart && range.rangeStart < disabledRangeSet[j].rangeEnd && range.rangeEnd > disabledRangeSet[j].rangeEnd)
               {
                  range.rangeStart = disabledRangeSet[j].rangeEnd;
                  j = 0;
               }
               else if(range.rangeStart <= disabledRangeSet[j].rangeStart && range.rangeEnd > disabledRangeSet[j].rangeStart && range.rangeEnd < disabledRangeSet[j].rangeEnd)
               {
                  range.rangeEnd = disabledRangeSet[j].rangeStart;
                  j = 0;
               }
               else
               {
                  j++;
               }
            }
         }
         if(!considered)
         {
            difference += range.rangeEnd - range.rangeStart;
         }
         considered = false;
         return difference;
      }
   }
}

class Range
{
   
   §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
   
   public var rangeStart:Number;
   
   public var rangeEnd:Number;
   
   public function Range(rangeStart:Number, rangeEnd:Number)
   {
      super();
      this.rangeStart = rangeStart;
      this.rangeEnd = rangeEnd;
   }
}
