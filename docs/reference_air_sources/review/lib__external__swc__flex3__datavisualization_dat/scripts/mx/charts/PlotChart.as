package mx.charts
{
   import mx.charts.chartClasses.CartesianChart;
   import mx.charts.chartClasses.DataTip;
   import mx.charts.renderers.BoxItemRenderer;
   import mx.charts.renderers.CircleItemRenderer;
   import mx.charts.renderers.DiamondItemRenderer;
   import mx.charts.styles.HaloDefaults;
   import mx.core.ClassFactory;
   import mx.core.IFactory;
   import mx.graphics.IFill;
   import mx.graphics.SolidColor;
   import mx.graphics.Stroke;
   import mx.styles.CSSStyleDeclaration;
   
   [IconFile("PlotChart.png")]
   [DefaultTriggerEvent("itemClick")]
   [DefaultBindingProperty(destination="dataProvider")]
   public class PlotChart extends CartesianChart
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private static var stylesInited:Boolean = initStyles();
      
      public function PlotChart()
      {
         super();
      }
      
      private static function initStyles() : Boolean
      {
         var i:int;
         var n:int;
         var defaultSizes:Array;
         var plotChartStyle:CSSStyleDeclaration;
         var defaultSkins:Array;
         var plotChartSeriesStyles:Array = null;
         var styleName:String = null;
         var o:CSSStyleDeclaration = null;
         var f:Function = null;
         HaloDefaults.init();
         plotChartStyle = HaloDefaults.createSelector("PlotChart");
         plotChartSeriesStyles = [];
         defaultSkins = [new ClassFactory(DiamondItemRenderer),new ClassFactory(CircleItemRenderer),new ClassFactory(BoxItemRenderer)];
         defaultSizes = [5,3.5,3.5];
         n = int(HaloDefaults.defaultFills.length);
         for(i = 0; i < n; i++)
         {
            styleName = "haloPlotSeries" + i;
            plotChartSeriesStyles[i] = styleName;
            o = HaloDefaults.createSelector("." + styleName);
            f = function(o:CSSStyleDeclaration, skin:IFactory, fill:IFill, radius:Number):void
            {
               o.defaultFactory = function():void
               {
                  this.fill = fill;
                  this.itemRenderer = skin;
                  this.radius = radius;
               };
            };
            f(o,defaultSkins[i % defaultSkins.length],HaloDefaults.defaultFills[i],defaultSizes[i % defaultSizes.length]);
         }
         plotChartStyle.defaultFactory = function():void
         {
            this.axisColor = 14016221;
            this.chartSeriesStyles = plotChartSeriesStyles;
            this.dataTipRenderer = DataTip;
            this.fill = new SolidColor(16777215,0);
            this.calloutStroke = new Stroke(8947848,2);
            this.fontSize = 10;
            this.gridLinesStyleName = "bothGridLines";
            this.horizontalAxisStyleName = "blockNumericAxis";
            this.secondHorizontalAxisStyleName = "blockNumericAxis";
            this.secondVerticalAxisStyleName = "blockNumericAxis";
            this.textAlign = "left";
            this.verticalAxisStyleName = "blockNumericAxis";
            this.horizontalAxisStyleNames = ["blockNumericAxis"];
            this.verticalAxisStyleNames = ["blockNumericAxis"];
         };
         return true;
      }
      
      override protected function initSecondaryMode() : void
      {
         super.initSecondaryMode();
         if(!secondVerticalAxis)
         {
            secondVerticalAxis = new LinearAxis();
         }
         if(!secondHorizontalAxis)
         {
            secondHorizontalAxis = new LinearAxis();
         }
         if(!secondVerticalAxisRenderer)
         {
            secondVerticalAxisRenderer = new AxisRenderer();
         }
         if(!secondHorizontalAxis)
         {
            secondHorizontalAxis = new LinearAxis();
         }
         if(!secondHorizontalAxisRenderer)
         {
            secondHorizontalAxisRenderer = new AxisRenderer();
         }
      }
   }
}

