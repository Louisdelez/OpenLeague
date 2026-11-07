package mx.charts.series
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import mx.charts.HitData;
   import mx.charts.chartClasses.CartesianTransform;
   import mx.charts.chartClasses.ChartBase;
   import mx.charts.chartClasses.IAxis;
   import mx.charts.chartClasses.IChartElement;
   import mx.charts.chartClasses.IColumn;
   import mx.charts.chartClasses.IStackable;
   import mx.charts.chartClasses.Series;
   import mx.charts.chartClasses.StackedSeries;
   import mx.charts.series.items.ColumnSeriesItem;
   import mx.core.UIComponent;
   
   [DefaultProperty("series")]
   public class ColumnSet extends StackedSeries implements IColumn
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private var _perColumnMaxColumnWidth:Number;
      
      private var _leftOffset:Number;
      
      private var _labelLayer:UIComponent;
      
      private var _perColumnWidthRatio:Number;
      
      private var _maxColumnWidth:Number;
      
      private var _offset:Number = 0;
      
      private var _columnWidthRatio:Number = 0.65;
      
      public function ColumnSet()
      {
         super();
         _labelLayer = new UIComponent();
         _labelLayer.styleName = this;
      }
      
      override protected function buildSubSeries() : void
      {
         var i:int = 0;
         var g:IChartElement = null;
         var series:Array = this.series;
         if(type == "100%" || type == "stacked")
         {
            _perColumnWidthRatio = columnWidthRatio;
            _perColumnMaxColumnWidth = maxColumnWidth;
         }
         else
         {
            _perColumnWidthRatio = columnWidthRatio / series.length;
            _perColumnMaxColumnWidth = maxColumnWidth / series.length;
         }
         _leftOffset = offset + (1 - columnWidthRatio) / 2 + _perColumnWidthRatio / 2 - 0.5;
         while(numChildren > 0)
         {
            removeChildAt(0);
         }
         if(type == "stacked" || type == "100%")
         {
            for(i = series.length - 1; i >= 0; i--)
            {
               g = IChartElement(series[i]);
               customizeSeries(g,i);
               addChild(g as DisplayObject);
            }
         }
         else
         {
            for(i = 0; i < series.length; i++)
            {
               g = IChartElement(series[i]);
               customizeSeries(g,i);
               addChild(g as DisplayObject);
            }
         }
         var s:ChartBase = chart;
         if(Boolean(s))
         {
            s.invalidateSeriesStyles();
         }
      }
      
      [Inspectable(category="General")]
      public function get maxColumnWidth() : Number
      {
         return _maxColumnWidth;
      }
      
      [Inspectable(category="General")]
      public function get offset() : Number
      {
         return _offset;
      }
      
      override public function describeData(dimension:String, requiredFields:uint) : Array
      {
         var result:Array = super.describeData(dimension,requiredFields);
         if(dimension == CartesianTransform.HORIZONTAL_AXIS && result.length > 0)
         {
            result[0].padding = 0.5;
         }
         return result;
      }
      
      override protected function customizeSeries(glyph:IChartElement, i:uint) : void
      {
         var currentSeries:IColumn = IColumn(glyph);
         if(!isNaN(_perColumnWidthRatio))
         {
            currentSeries.columnWidthRatio = _perColumnWidthRatio;
         }
         if(!isNaN(_perColumnMaxColumnWidth))
         {
            currentSeries.maxColumnWidth = _perColumnMaxColumnWidth;
         }
         if(type == "clustered")
         {
            currentSeries.offset = _leftOffset + i * _perColumnWidthRatio;
         }
         else
         {
            currentSeries.offset = offset;
         }
         super.customizeSeries(glyph,i);
      }
      
      [Inspectable(category="General")]
      public function get columnWidthRatio() : Number
      {
         return _columnWidthRatio;
      }
      
      public function set maxColumnWidth(value:Number) : void
      {
         _maxColumnWidth = value;
         invalidateSeries();
      }
      
      override protected function formatDataTip(hd:HitData) : String
      {
         var percent:Number = NaN;
         var size:Number = NaN;
         var dt:String = "";
         var elt:IStackable = IStackable(hd.element);
         var item:ColumnSeriesItem = ColumnSeriesItem(hd.chartItem);
         var total:Number = Number(posTotalsByPrimaryAxis[item.xValue]);
         if(type == "100%")
         {
            percent = Number(item.yValue) - Number(item.minValue);
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
               total += isNaN(negTotalsByPrimaryAxis[item.xValue]) ? 0 : negTotalsByPrimaryAxis[item.xValue];
            }
            size = Number(item.yValue) - Number(item.minValue);
            percent = Math.round(size / total * 1000) / 10;
         }
         var n:String = (elt as Series).displayName;
         if(n != null && n.length > 0)
         {
            dt += "<b>" + n + "</b><BR/>";
         }
         var hAxis:IAxis = dataTransform.getAxis(CartesianTransform.HORIZONTAL_AXIS);
         var xName:String = hAxis.displayName;
         if(xName != "")
         {
            dt += "<i>" + xName + ":</i> ";
         }
         dt += hAxis.formatForScreen(item.xValue) + "\n";
         var vAxis:IAxis = dataTransform.getAxis(CartesianTransform.VERTICAL_AXIS);
         var yName:String = vAxis.displayName;
         if(yName != "")
         {
            dt += "<i>" + yName + ":</i> ";
         }
         dt += vAxis.formatForScreen(Number(item.yValue) - Number(item.minValue)) + " (" + percent + "%)\n";
         if(yName != "")
         {
            dt += "<i>" + yName + " (total):</i> ";
         }
         else
         {
            dt += "<i>total:</i> ";
         }
         return dt + vAxis.formatForScreen(total);
      }
      
      public function set offset(value:Number) : void
      {
         _offset = value;
         invalidateSeries();
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
      
      [Inspectable(category="General",enumeration="stacked,100%,clustered,overlaid",defaultValue="clustered")]
      override public function set type(value:String) : void
      {
         super.type = value;
      }
      
      public function set columnWidthRatio(value:Number) : void
      {
         _columnWidthRatio = value;
         invalidateSeries();
      }
      
      override public function get labelContainer() : Sprite
      {
         return _labelLayer;
      }
   }
}

