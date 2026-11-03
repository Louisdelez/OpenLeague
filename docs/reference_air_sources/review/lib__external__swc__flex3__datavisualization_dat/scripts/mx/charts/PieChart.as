package mx.charts
{
   import mx.charts.chartClasses.DataTip;
   import mx.charts.chartClasses.DataTransform;
   import mx.charts.chartClasses.PolarChart;
   import mx.charts.chartClasses.Series;
   import mx.charts.series.PieSeries;
   import mx.charts.styles.HaloDefaults;
   import mx.graphics.SolidColor;
   import mx.graphics.Stroke;
   import mx.styles.CSSStyleDeclaration;
   
   [IconFile("PieChart.png")]
   [DefaultTriggerEvent("itemClick")]
   [DefaultBindingProperty(destination="dataProvider")]
   [Style(name="innerRadius",type="Number",inherit="no")]
   [Style(name="textIndent",type="Number",format="Length",inherit="yes")]
   [Style(name="textDecoration",type="String",enumeration="none,underline",inherit="yes")]
   [Style(name="textAlign",type="String",enumeration="left,center,right",inherit="yes")]
   [Style(name="letterSpacing",type="Number",inherit="yes")]
   [Style(name="kerning",type="Boolean",inherit="yes")]
   [Style(name="fontWeight",type="String",enumeration="normal,bold",inherit="yes")]
   [Style(name="fontThickness",type="Number",inherit="yes")]
   [Style(name="fontStyle",type="String",enumeration="normal,italic",inherit="yes")]
   [Style(name="fontSize",type="Number",format="Length",inherit="yes")]
   [Style(name="fontSharpness",type="Number",inherit="yes")]
   [Style(name="fontGridFitType",type="String",enumeration="none,pixel,subpixel",inherit="yes")]
   [Style(name="fontFamily",type="String",inherit="yes")]
   [Style(name="fontAntiAliasType",type="String",enumeration="normal,advanced",inherit="yes")]
   [Style(name="disabledColor",type="uint",format="Color",inherit="yes")]
   [Style(name="color",type="uint",format="Color",inherit="yes")]
   public class PieChart extends PolarChart
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private static var stylesInited:Boolean = initStyles();
      
      private var _seriesWidth:Number;
      
      private var _innerRadius:Number;
      
      public function PieChart()
      {
         super();
         dataTipMode = "single";
         var aa:LinearAxis = new LinearAxis();
         aa.minimum = 0;
         aa.maximum = 100;
         angularAxis = aa;
      }
      
      private static function initStyles() : Boolean
      {
         var pieChartStyle:CSSStyleDeclaration;
         HaloDefaults.init();
         pieChartStyle = HaloDefaults.createSelector("PieChart");
         pieChartStyle.defaultFactory = function():void
         {
            this.dataTipRenderer = DataTip;
            this.fill = new SolidColor(16777215,0);
            this.calloutStroke = new Stroke(8947848,2);
            this.fontSize = 10;
            this.innerRadius = 0;
            this.textAlign = "left";
         };
         return true;
      }
      
      override protected function customizeSeries(seriesGlyph:Series, i:uint) : void
      {
         if(seriesGlyph is PieSeries)
         {
            PieSeries(seriesGlyph).setStyle("innerRadius",_innerRadius + i * _seriesWidth);
            PieSeries(seriesGlyph).outerRadius = _innerRadius + (i + 1) * _seriesWidth;
         }
      }
      
      override public function get legendData() : Array
      {
         var keyItems:Array = [];
         if(series.length > 0)
         {
            keyItems = [series[0].legendData];
         }
         return keyItems;
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         if(styleProp == null || styleProp == "innerRadius")
         {
            invalidateSeries();
         }
         super.styleChanged(styleProp);
      }
      
      override protected function applySeriesSet(seriesSet:Array, transform:DataTransform) : Array
      {
         _innerRadius = getStyle("innerRadius");
         _innerRadius = isNaN(_innerRadius) ? 0 : _innerRadius;
         _seriesWidth = (1 - _innerRadius) / seriesSet.length;
         return super.applySeriesSet(seriesSet,transform);
      }
   }
}

