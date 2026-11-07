package mx.charts
{
   import mx.charts.chartClasses.CartesianChart;
   import mx.charts.chartClasses.DataTip;
   import mx.charts.chartClasses.DataTransform;
   import mx.charts.chartClasses.Series;
   import mx.charts.series.CandlestickSeries;
   import mx.charts.styles.HaloDefaults;
   import mx.graphics.IFill;
   import mx.graphics.SolidColor;
   import mx.graphics.Stroke;
   import mx.styles.CSSStyleDeclaration;
   
   [IconFile("CandlestickChart.png")]
   [DefaultTriggerEvent("itemClick")]
   [DefaultBindingProperty(destination="dataProvider")]
   [Style(name="maxColumnWidth",type="Number",format="Length",inherit="no")]
   [Style(name="columnWidthRatio",type="Number",inherit="no")]
   public class CandlestickChart extends CartesianChart
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private static var stylesInited:Boolean = initStyles();
      
      private static var INVALIDATING_STYLES:Object = {
         "columnWidthRatio":1,
         "maxColumnWidth":1
      };
      
      private var _perSeriescolumnWidthRatio:Number;
      
      private var _perSeriesMaxColumnWidth:Number;
      
      private var _leftOffset:Number;
      
      public function CandlestickChart()
      {
         super();
         dataTipMode = "single";
      }
      
      private static function initStyles() : Boolean
      {
         var i:int;
         var n:int;
         var candlestickChartStyle:CSSStyleDeclaration;
         var candlestickChartSeriesStyles:Array = null;
         var styleName:String = null;
         var o:CSSStyleDeclaration = null;
         var f:Function = null;
         HaloDefaults.init();
         candlestickChartStyle = HaloDefaults.createSelector("CandlestickChart");
         candlestickChartSeriesStyles = [];
         candlestickChartStyle.defaultFactory = function():void
         {
            this.axisColor = 14016221;
            this.chartSeriesStyles = candlestickChartSeriesStyles;
            this.columnWidthRatio = 0.65;
            this.dataTipRenderer = DataTip;
            this.fill = new SolidColor(16777215,0);
            this.calloutStroke = new Stroke(8947848,2);
            this.fontSize = 10;
            this.horizontalAxisStyleName = "blockCategoryAxis";
            this.secondHorizontalAxisStyleName = "blockCategoryAxis";
            this.secondVerticalAxisStyleName = "blockNumericAxis";
            this.textAlign = "left";
            this.verticalAxisStyleName = "blockNumericAxis";
            this.horizontalAxisStyleNames = ["blockCategoryAxis"];
            this.verticalAxisStyleNames = ["blockNumericAxis"];
         };
         n = int(HaloDefaults.defaultColors.length);
         for(i = 0; i < n; i++)
         {
            styleName = "haloCandlestickSeries" + i;
            candlestickChartSeriesStyles[i] = styleName;
            o = HaloDefaults.createSelector("." + styleName);
            f = function(o:CSSStyleDeclaration, boxStroke:Stroke, declineFill:IFill):void
            {
               o.defaultFactory = function():void
               {
                  this.boxStroke = boxStroke;
                  this.declineFill = declineFill;
               };
            };
            f(o,new Stroke(HaloDefaults.defaultColors[i],0,1),new SolidColor(HaloDefaults.defaultColors[i]));
         }
         return true;
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         if(styleProp == null || INVALIDATING_STYLES[styleProp] != undefined)
         {
            invalidateSeries();
         }
         super.styleChanged(styleProp);
      }
      
      override protected function customizeSeries(seriesGlyph:Series, i:uint) : void
      {
         var series:CandlestickSeries = seriesGlyph as CandlestickSeries;
         if(Boolean(series))
         {
            if(!isNaN(_perSeriescolumnWidthRatio))
            {
               series.columnWidthRatio = _perSeriescolumnWidthRatio;
            }
            if(!isNaN(_perSeriesMaxColumnWidth))
            {
               series.maxColumnWidth = _perSeriesMaxColumnWidth;
            }
            series.offset = _leftOffset + i * _perSeriescolumnWidthRatio;
         }
      }
      
      override protected function applySeriesSet(seriesSet:Array, transform:DataTransform) : Array
      {
         var columnWidthRatio:Number = Number(getStyle("columnWidthRatio"));
         var maxColumnWidth:Number = Number(getStyle("maxColumnWidth"));
         _perSeriescolumnWidthRatio = columnWidthRatio / seriesSet.length;
         _perSeriesMaxColumnWidth = maxColumnWidth / seriesSet.length;
         _leftOffset = (1 - columnWidthRatio) / 2 + _perSeriescolumnWidthRatio / 2 - 0.5;
         return super.applySeriesSet(seriesSet,transform);
      }
      
      override protected function initSecondaryMode() : void
      {
         super.initSecondaryMode();
         if(!secondVerticalAxis)
         {
            secondVerticalAxis = new LinearAxis();
         }
         if(!secondVerticalAxisRenderer)
         {
            secondVerticalAxisRenderer = new AxisRenderer();
         }
      }
   }
}

