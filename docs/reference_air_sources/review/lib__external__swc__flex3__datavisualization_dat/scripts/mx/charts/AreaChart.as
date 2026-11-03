package mx.charts
{
   import mx.charts.chartClasses.CartesianChart;
   import mx.charts.chartClasses.DataTip;
   import mx.charts.chartClasses.DataTransform;
   import mx.charts.chartClasses.IAxis;
   import mx.charts.chartClasses.Series;
   import mx.charts.series.AreaSeries;
   import mx.charts.series.AreaSet;
   import mx.charts.styles.HaloDefaults;
   import mx.graphics.IFill;
   import mx.graphics.SolidColor;
   import mx.graphics.Stroke;
   import mx.styles.CSSStyleDeclaration;
   
   [IconFile("AreaChart.png")]
   [DefaultTriggerEvent("itemClick")]
   [DefaultBindingProperty(destination="dataProvider")]
   public class AreaChart extends CartesianChart
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private static var stylesInited:Boolean = initStyles();
      
      private var _type:String = "overlaid";
      
      public function AreaChart()
      {
         super();
         LinearAxis(horizontalAxis).autoAdjust = false;
      }
      
      private static function initStyles() : Boolean
      {
         var areaChartStyle:CSSStyleDeclaration;
         var i:int;
         var n:int;
         var areaChartSeriesStyles:Array = null;
         var styleName:String = null;
         var o:CSSStyleDeclaration = null;
         var f:Function = null;
         HaloDefaults.init();
         areaChartStyle = HaloDefaults.createSelector("AreaChart");
         areaChartSeriesStyles = [];
         areaChartStyle.defaultFactory = function():void
         {
            this.axisColor = 14016221;
            this.chartSeriesStyles = areaChartSeriesStyles;
            this.dataTipRenderer = DataTip;
            this.fill = new SolidColor(16777215,0);
            this.calloutStroke = new Stroke(8947848,2);
            this.fontSize = 10;
            this.horizontalAxisStyleName = "hangingCategoryAxis";
            this.secondHorizontalAxisStyleName = "hangingCategoryAxis";
            this.secondVerticalAxisStyleName = "blockNumericAxis";
            this.textAlign = "left";
            this.verticalAxisStyleName = "blockNumericAxis";
            this.horizontalAxisStyleNames = ["hangingCategoryAxis"];
            this.verticalAxisStyleNames = ["blockNumericAxis"];
         };
         n = int(HaloDefaults.defaultFills.length);
         for(i = 0; i < n; i++)
         {
            styleName = "haloAreaSeries" + i;
            areaChartSeriesStyles[i] = styleName;
            o = HaloDefaults.createSelector("." + styleName);
            f = function(o:CSSStyleDeclaration, stroke:Stroke, fill:IFill):void
            {
               o.defaultFactory = function():void
               {
                  this.areaFill = fill;
                  this.fill = fill;
               };
            };
            f(o,null,HaloDefaults.defaultFills[i]);
         }
         return true;
      }
      
      [Inspectable(category="General",enumeration="overlaid,stacked,100%",defaultValue="overlaid")]
      public function get type() : String
      {
         return _type;
      }
      
      public function set type(value:String) : void
      {
         _type = value;
         invalidateSeries();
         invalidateData();
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
      
      [Inspectable(category="Data")]
      override public function set horizontalAxis(value:IAxis) : void
      {
         if(value is CategoryAxis)
         {
            CategoryAxis(value).padding = 0;
         }
         super.horizontalAxis = value;
      }
      
      override protected function customizeSeries(seriesGlyph:Series, i:uint) : void
      {
         var aSeries:AreaSeries = seriesGlyph as AreaSeries;
         if(Boolean(aSeries))
         {
            aSeries.stacker = null;
            aSeries.stackTotals = null;
         }
      }
      
      override protected function applySeriesSet(seriesSet:Array, transform:DataTransform) : Array
      {
         var newSeriesGlyph:AreaSet = null;
         switch(_type)
         {
            case "stacked":
            case "100%":
               newSeriesGlyph = new AreaSet();
               newSeriesGlyph.series = seriesSet;
               newSeriesGlyph.type = _type;
               return [newSeriesGlyph];
            case "overlaid":
         }
         return super.applySeriesSet(seriesSet,transform);
      }
   }
}

