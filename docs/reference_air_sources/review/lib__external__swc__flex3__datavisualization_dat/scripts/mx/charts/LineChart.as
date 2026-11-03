package mx.charts
{
   import flash.filters.DropShadowFilter;
   import mx.charts.chartClasses.CartesianChart;
   import mx.charts.chartClasses.DataTip;
   import mx.charts.chartClasses.IAxis;
   import mx.charts.renderers.LineRenderer;
   import mx.charts.styles.HaloDefaults;
   import mx.core.ClassFactory;
   import mx.graphics.SolidColor;
   import mx.graphics.Stroke;
   import mx.styles.CSSStyleDeclaration;
   
   [IconFile("LineChart.png")]
   [DefaultTriggerEvent("itemClick")]
   [DefaultBindingProperty(destination="dataProvider")]
   public class LineChart extends CartesianChart
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private static var stylesInited:Boolean = initStyles();
      
      public function LineChart()
      {
         super();
         LinearAxis(horizontalAxis).autoAdjust = false;
         seriesFilters = [new DropShadowFilter()];
      }
      
      private static function initStyles() : Boolean
      {
         var lineChartStyle:CSSStyleDeclaration;
         var i:int;
         var n:int;
         var lineChartSeriesStyles:Array = null;
         var styleName:String = null;
         var o:CSSStyleDeclaration = null;
         var f:Function = null;
         HaloDefaults.init();
         lineChartStyle = HaloDefaults.createSelector("LineChart");
         lineChartSeriesStyles = [];
         lineChartStyle.defaultFactory = function():void
         {
            this.axisColor = 14016221;
            this.chartSeriesStyles = lineChartSeriesStyles;
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
         n = int(HaloDefaults.defaultColors.length);
         for(i = 0; i < n; i++)
         {
            styleName = "haloLineSeries" + i;
            lineChartSeriesStyles[i] = styleName;
            o = HaloDefaults.createSelector("." + styleName);
            f = function(o:CSSStyleDeclaration, stroke:Stroke):void
            {
               o.defaultFactory = function():void
               {
                  this.lineStroke = stroke;
                  this.stroke = stroke;
                  this.lineSegmentRenderer = new ClassFactory(LineRenderer);
               };
            };
            f(o,new Stroke(HaloDefaults.defaultColors[i],3,1));
         }
         return true;
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

