package mx.charts
{
   import mx.charts.chartClasses.CartesianChart;
   import mx.charts.chartClasses.DataTip;
   import mx.charts.chartClasses.IAxis;
   import mx.charts.chartClasses.Series;
   import mx.charts.series.BubbleSeries;
   import mx.charts.styles.HaloDefaults;
   import mx.graphics.SolidColor;
   import mx.graphics.Stroke;
   import mx.styles.CSSStyleDeclaration;
   
   [IconFile("BubbleChart.png")]
   [DefaultTriggerEvent("itemClick")]
   [DefaultBindingProperty(destination="dataProvider")]
   [Style(name="minRadius",type="Number",format="Length",inherit="no")]
   [Style(name="maxRadius",type="Number",format="Length",inherit="no")]
   public class BubbleChart extends CartesianChart
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private static var stylesInited:Boolean = initStyles();
      
      private var _radiusAxis2:IAxis;
      
      private var _radiusAxis:IAxis;
      
      public function BubbleChart()
      {
         super();
         var zAxis:LinearAxis = new LinearAxis();
         zAxis.autoAdjust = false;
         zAxis.minimum = 0;
         zAxis.interval = 1;
         radiusAxis = zAxis;
      }
      
      private static function initStyles() : Boolean
      {
         var bubbleChartStyle:CSSStyleDeclaration;
         HaloDefaults.init();
         bubbleChartStyle = HaloDefaults.createSelector("BubbleChart");
         bubbleChartStyle.defaultFactory = function():void
         {
            this.axisColor = 14016221;
            this.chartSeriesStyles = HaloDefaults.chartBaseChartSeriesStyles;
            this.dataTipCalloutStroke = new Stroke(2,0);
            this.dataTipRenderer = DataTip;
            this.fill = new SolidColor(16777215,0);
            this.calloutStroke = new Stroke(8947848,2);
            this.fontSize = 10;
            this.gridLinesStyleName = "bothGridLines";
            this.horizontalAxisStyleName = "blockNumericAxis";
            this.maxRadius = 50;
            this.minRadius = 0;
            this.secondHorizontalAxisStyleName = "blockNumericAxis";
            this.secondVerticalAxisStyleName = "blockNumericAxis";
            this.textAlign = "left";
            this.verticalAxisStyleName = "blockNumericAxis";
            this.horizontalAxisStyleNames = ["blockNumericAxis"];
            this.verticalAxisStyleNames = ["blockNumericAxis"];
         };
         return true;
      }
      
      [Inspectable(category="Data")]
      public function get radiusAxis() : IAxis
      {
         return _transforms[0].getAxis(BubbleSeries.RADIUS_AXIS);
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         var series:Array = null;
         var n:int = 0;
         var i:int = 0;
         var maxRadius:Number = NaN;
         var minRadius:Number = NaN;
         if(styleProp == null || styleProp == "maxRadius")
         {
            maxRadius = Number(getStyle("maxRadius"));
            series = this.series;
            n = int(series.length);
            for(i = 0; i < n; i++)
            {
               if(series[i] is BubbleSeries)
               {
                  series[i].maxRadius = maxRadius;
                  series[i].invalidateDisplayList();
               }
            }
            series = secondSeries;
            n = int(series.length);
            for(i = 0; i < n; i++)
            {
               if(series[i] is BubbleSeries)
               {
                  series[i].maxRadius = maxRadius;
                  series[i].invalidateDisplayList();
               }
            }
         }
         if(styleProp == null || styleProp == "minRadius")
         {
            minRadius = Number(getStyle("minRadius"));
            series = this.series;
            n = int(series.length);
            for(i = 0; i < n; i++)
            {
               if(series[i] is BubbleSeries)
               {
                  series[i].minRadius = minRadius;
                  series[i].invalidateDisplayList();
               }
            }
            series = secondSeries;
            n = int(series.length);
            for(i = 0; i < n; i++)
            {
               if(series[i] is BubbleSeries)
               {
                  series[i].minRadius = minRadius;
                  series[i].invalidateDisplayList();
               }
            }
         }
      }
      
      public function set radiusAxis(value:IAxis) : void
      {
         _radiusAxis = value;
         _transforms[0].setAxis(BubbleSeries.RADIUS_AXIS,value);
         invalidateData();
      }
      
      public function set secondRadiusAxis(value:IAxis) : void
      {
         _radiusAxis2 = value;
         initSecondaryMode();
         _transforms[1].setAxis(2,value);
         invalidateData();
         invalidateProperties();
      }
      
      [Deprecated(replacement="series specific axis, example:BubbleSeries.radiusAxis")]
      [Inspectable(category="Data")]
      public function get secondRadiusAxis() : IAxis
      {
         return _radiusAxis2;
      }
      
      override protected function customizeSeries(seriesGlyph:Series, i:uint) : void
      {
         var maxRadius:Number = Number(getStyle("maxRadius"));
         var minRadius:Number = Number(getStyle("minRadius"));
         if(seriesGlyph is BubbleSeries && !isNaN(maxRadius))
         {
            BubbleSeries(seriesGlyph).maxRadius = maxRadius;
         }
         if(seriesGlyph is BubbleSeries && !isNaN(minRadius))
         {
            BubbleSeries(seriesGlyph).minRadius = minRadius;
         }
      }
      
      override protected function initSecondaryMode() : void
      {
         var la:LinearAxis = null;
         super.initSecondaryMode();
         if(!secondVerticalAxis)
         {
            secondVerticalAxis = new LinearAxis();
         }
         if(!secondHorizontalAxis)
         {
            secondHorizontalAxis = new LinearAxis();
         }
         if(!_radiusAxis2)
         {
            la = new LinearAxis();
            la.autoAdjust = false;
            la.minimum = 0;
            la.interval = 1;
            _radiusAxis2 = la;
            _transforms[1].setAxis(2,_radiusAxis2);
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

