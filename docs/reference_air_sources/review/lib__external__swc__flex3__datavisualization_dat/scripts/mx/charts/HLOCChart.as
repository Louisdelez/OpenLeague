package mx.charts
{
   import mx.charts.chartClasses.CartesianChart;
   import mx.charts.chartClasses.DataTip;
   import mx.charts.chartClasses.DataTransform;
   import mx.charts.chartClasses.Series;
   import mx.charts.series.HLOCSeries;
   import mx.charts.styles.HaloDefaults;
   import mx.graphics.SolidColor;
   import mx.graphics.Stroke;
   import mx.styles.CSSStyleDeclaration;
   
   [IconFile("HLOCChart.png")]
   [DefaultTriggerEvent("itemClick")]
   [DefaultBindingProperty(destination="dataProvider")]
   [Style(name="maxColumnWidth",type="Number",format="Length",inherit="no")]
   [Style(name="columnWidthRatio",type="Number",inherit="no")]
   public class HLOCChart extends CartesianChart
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private static var stylesInited:Boolean = initStyles();
      
      private static var INVALIDATING_STYLES:Object = {
         "columnWidthRatio":1,
         "maxColumnWidth":1
      };
      
      private var _perSeriesColumnWidthRatio:Number;
      
      private var _perSeriesMaxColumnWidth:Number;
      
      private var _leftOffset:Number;
      
      public function HLOCChart()
      {
         super();
         dataTipMode = "single";
      }
      
      private static function initStyles() : Boolean
      {
         var i:int;
         var hlocChartStyle:CSSStyleDeclaration;
         var n:int;
         var hlocChartSeriesStyles:Array = null;
         var styleName:String = null;
         var o:CSSStyleDeclaration = null;
         var f:Function = null;
         HaloDefaults.init();
         hlocChartStyle = HaloDefaults.createSelector("HLOCChart");
         hlocChartSeriesStyles = [];
         hlocChartStyle.defaultFactory = function():void
         {
            this.axisColor = 14016221;
            this.chartSeriesStyles = hlocChartSeriesStyles;
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
            styleName = "haloHLOCSeries" + i;
            hlocChartSeriesStyles[i] = styleName;
            o = HaloDefaults.createSelector("." + styleName);
            f = function(o:CSSStyleDeclaration, stroke:Stroke, tickStroke:Stroke):void
            {
               o.defaultFactory = function():void
               {
                  this.closeTickStroke = tickStroke;
                  this.openTickStroke = tickStroke;
                  this.stroke = stroke;
                  this.hlocColor = stroke.color;
               };
            };
            f(o,new Stroke(HaloDefaults.defaultColors[i],0,1),new Stroke(HaloDefaults.defaultColors[i],2,1,false,"normal","none"));
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
         var series:HLOCSeries = seriesGlyph as HLOCSeries;
         if(Boolean(series))
         {
            if(!isNaN(_perSeriesColumnWidthRatio))
            {
               series.columnWidthRatio = _perSeriesColumnWidthRatio;
            }
            if(!isNaN(_perSeriesMaxColumnWidth))
            {
               series.maxColumnWidth = _perSeriesMaxColumnWidth;
            }
            series.offset = _leftOffset + i * _perSeriesColumnWidthRatio;
         }
      }
      
      override protected function applySeriesSet(seriesSet:Array, transform:DataTransform) : Array
      {
         var columnWidthRatio:Number = Number(getStyle("columnWidthRatio"));
         var maxColumnWidth:Number = Number(getStyle("maxColumnWidth"));
         _perSeriesColumnWidthRatio = columnWidthRatio / seriesSet.length;
         _perSeriesMaxColumnWidth = maxColumnWidth / seriesSet.length;
         _leftOffset = (1 - columnWidthRatio) / 2 + _perSeriesColumnWidthRatio / 2 - 0.5;
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

