package mx.charts.series
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.utils.Dictionary;
   import mx.charts.HitData;
   import mx.charts.chartClasses.CartesianTransform;
   import mx.charts.chartClasses.ChartBase;
   import mx.charts.chartClasses.DataDescription;
   import mx.charts.chartClasses.IAxis;
   import mx.charts.chartClasses.IBar;
   import mx.charts.chartClasses.IChartElement;
   import mx.charts.chartClasses.IStackable;
   import mx.charts.chartClasses.IStackable2;
   import mx.charts.chartClasses.Series;
   import mx.charts.chartClasses.StackedSeries;
   import mx.charts.series.items.BarSeriesItem;
   import mx.core.UIComponent;
   
   [DefaultProperty("series")]
   public class BarSet extends StackedSeries implements IBar
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private var _perBarMaxColumnWidth:Number;
      
      private var _rightOffset:Number;
      
      private var _barWidthRatio:Number = 0.65;
      
      private var _perBarWidthRatio:Number;
      
      private var _labelLayer:UIComponent;
      
      private var _offset:Number = 0;
      
      private var _maxBarWidth:Number;
      
      public function BarSet()
      {
         super();
         _labelLayer = new UIComponent();
         _labelLayer.styleName = this;
      }
      
      override public function stack() : void
      {
         var i:int = 0;
         var ser:IStackable2 = null;
         var obj:Object = null;
         var cachedDataDescriptions:Array = null;
         var n:int = int(series.length);
         posTotalsByPrimaryAxis = new Dictionary(false);
         negTotalsByPrimaryAxis = new Dictionary(false);
         stackedMaximum = 0;
         var previousSeries:IStackable2 = null;
         for(i = 0; i < n; i++)
         {
            ser = series[i];
            if(type == "stacked" && allowNegativeForStacked)
            {
               obj = ser.stackAll(posTotalsByPrimaryAxis,negTotalsByPrimaryAxis,previousSeries);
               stackedMaximum = Math.max(stackedMaximum,obj.maxValue);
               stackedMinimum = isNaN(stackedMinimum) ? Number(obj.minValue) : Math.min(stackedMinimum,obj.minValue);
            }
            else
            {
               stackedMaximum = Math.max(stackedMaximum,ser.stack(posTotalsByPrimaryAxis,previousSeries));
               if(type == "100%")
               {
                  stackedMinimum = 0;
               }
               else
               {
                  cachedDataDescriptions = Series(ser).describeData(CartesianTransform.HORIZONTAL_AXIS,DataDescription.REQUIRED_MIN_MAX | DataDescription.REQUIRED_BOUNDED_VALUES);
                  if(Boolean(cachedDataDescriptions.length))
                  {
                     stackedMinimum = isNaN(stackedMinimum) ? Number(cachedDataDescriptions[0].min) : Math.min(stackedMinimum,cachedDataDescriptions[0].min);
                  }
               }
            }
            previousSeries = ser;
         }
         var totals:Dictionary = type == "100%" ? posTotalsByPrimaryAxis : null;
         for(i = 0; i < n; i++)
         {
            ser = series[i];
            ser.stackTotals = totals;
         }
      }
      
      override protected function buildSubSeries() : void
      {
         var i:int = 0;
         var g:IChartElement = null;
         var series:Array = this.series;
         if(type == "100%" || type == "stacked")
         {
            _perBarWidthRatio = barWidthRatio;
            _perBarMaxColumnWidth = maxBarWidth;
         }
         else
         {
            _perBarWidthRatio = barWidthRatio / series.length;
            _perBarMaxColumnWidth = maxBarWidth / series.length;
         }
         _rightOffset = offset + barWidthRatio / 2 - _perBarWidthRatio / 2;
         while(numChildren > 0)
         {
            removeChildAt(0);
         }
         for(i = 0; i < series.length; i++)
         {
            g = IChartElement(series[i]);
            customizeSeries(g,i);
            addChild(g as DisplayObject);
         }
         var s:ChartBase = chart;
         if(Boolean(s))
         {
            s.invalidateSeriesStyles();
         }
      }
      
      [Inspectable(category="General")]
      public function get offset() : Number
      {
         return _offset;
      }
      
      override public function describeData(dimension:String, requiredFields:uint) : Array
      {
         var desc:DataDescription = null;
         var i:int = 0;
         var hCache:Array = null;
         var result:Array = [];
         updateStacking();
         validateData();
         if(type == "100%")
         {
            if(dimension == CartesianTransform.HORIZONTAL_AXIS)
            {
               desc = new DataDescription();
               desc.min = 0;
               desc.max = 100;
               result = [desc];
            }
            else
            {
               for(i = 0; i < series.length; i++)
               {
                  result = result.concat(series[i].describeData(dimension,requiredFields));
               }
            }
         }
         else if(type == "stacked")
         {
            if(dimension == CartesianTransform.HORIZONTAL_AXIS)
            {
               hCache = [{"value":stackedMinimum},{"value":stackedMaximum}];
               dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS).mapCache(hCache,"value","number");
               desc = new DataDescription();
               desc.min = hCache[0].number;
               desc.max = hCache[1].number;
               result = [desc];
            }
            else
            {
               for(i = 0; i < series.length; i++)
               {
                  result = result.concat(series[i].describeData(dimension,requiredFields));
               }
            }
         }
         else
         {
            for(i = 0; i < series.length; i++)
            {
               result = result.concat(series[i].describeData(dimension,requiredFields));
            }
         }
         return result;
      }
      
      [Inspectable(category="General")]
      public function get barWidthRatio() : Number
      {
         return _barWidthRatio;
      }
      
      override protected function customizeSeries(glyph:IChartElement, i:uint) : void
      {
         var currentSeries:IBar = IBar(glyph);
         if(!isNaN(_perBarWidthRatio))
         {
            currentSeries.barWidthRatio = _perBarWidthRatio;
         }
         if(!isNaN(_perBarMaxColumnWidth))
         {
            currentSeries.maxBarWidth = _perBarMaxColumnWidth;
         }
         if(type == "clustered")
         {
            currentSeries.offset = _rightOffset - i * _perBarWidthRatio;
         }
         else
         {
            currentSeries.offset = offset;
         }
         super.customizeSeries(glyph,i);
      }
      
      public function set offset(value:Number) : void
      {
         _offset = value;
         invalidateSeries();
      }
      
      override protected function formatDataTip(hd:HitData) : String
      {
         var percent:Number = NaN;
         var size:Number = NaN;
         var dt:String = "";
         var elt:IStackable = IStackable(hd.element);
         var item:BarSeriesItem = BarSeriesItem(hd.chartItem);
         var total:Number = Number(posTotalsByPrimaryAxis[item.yValue]);
         if(type == "100%")
         {
            percent = Number(item.xValue) - Number(item.minValue);
            percent = Math.round(percent * 10) / 10;
         }
         else
         {
            if(type == "stacked" && allowNegativeForStacked)
            {
               if(isNaN(total))
               {
                  total = 0;
               }
               total += isNaN(negTotalsByPrimaryAxis[item.yValue]) ? 0 : negTotalsByPrimaryAxis[item.yValue];
            }
            size = Number(item.xValue) - Number(item.minValue);
            percent = Math.round(size / total * 1000) / 10;
         }
         var n:String = (elt as Series).displayName;
         if(n != null && n.length > 0)
         {
            dt += "<b>" + n + "</b><BR/>";
         }
         var hAxis:IAxis = dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS);
         var vAxis:IAxis = dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS);
         var yName:String = vAxis.displayName;
         if(yName != "")
         {
            dt += "<i>" + yName + ":</i> ";
         }
         dt += vAxis.formatForScreen(item.yValue) + "\n";
         var xName:String = hAxis.displayName;
         if(xName != "")
         {
            dt += "<i>" + xName + ":</i> ";
         }
         dt += hAxis.formatForScreen(Number(item.xValue) - Number(item.minValue)) + " (" + percent + "%)\n";
         if(xName != "")
         {
            dt += "<i>" + xName + " (total):</i> ";
         }
         else
         {
            dt += "<i>total:</i> ";
         }
         return dt + hAxis.formatForScreen(total);
      }
      
      public function set maxBarWidth(value:Number) : void
      {
         _maxBarWidth = value;
         invalidateSeries();
      }
      
      public function set barWidthRatio(value:Number) : void
      {
         _barWidthRatio = value;
         invalidateSeries();
      }
      
      [Inspectable(category="General",enumeration="stacked,100%,clustered,overlaid",defaultValue="clustered")]
      override public function set type(value:String) : void
      {
         super.type = value;
      }
      
      override public function get labelContainer() : Sprite
      {
         return _labelLayer;
      }
      
      override public function set series(value:Array) : void
      {
         var g:IChartElement = null;
         super.series = value;
         for(var i:int = 0; i < value.length; i++)
         {
            g = value[i] as IChartElement;
            if(g)
            {
               if(Boolean(g.labelContainer))
               {
                  _labelLayer.addChild(value[i].labelContainer);
               }
            }
         }
      }
      
      [Inspectable(category="General")]
      public function get maxBarWidth() : Number
      {
         return _maxBarWidth;
      }
   }
}

