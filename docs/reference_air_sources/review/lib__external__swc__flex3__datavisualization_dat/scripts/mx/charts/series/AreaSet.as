package mx.charts.series
{
   import flash.display.DisplayObject;
   import mx.charts.HitData;
   import mx.charts.chartClasses.CartesianTransform;
   import mx.charts.chartClasses.ChartBase;
   import mx.charts.chartClasses.IAxis;
   import mx.charts.chartClasses.IChartElement;
   import mx.charts.chartClasses.StackedSeries;
   import mx.charts.series.items.AreaSeriesItem;
   
   [DefaultProperty("series")]
   public class AreaSet extends StackedSeries
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      public function AreaSet()
      {
         super();
      }
      
      override protected function buildSubSeries() : void
      {
         var i:int = 0;
         var g:IChartElement = null;
         while(numChildren > 0)
         {
            removeChildAt(0);
         }
         var series:Array = this.series;
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
      
      override protected function formatDataTip(hd:HitData) : String
      {
         var percent:Number = NaN;
         var size:Number = NaN;
         var dt:String = "";
         var elt:AreaSeries = AreaSeries(hd.element);
         var item:AreaSeriesItem = AreaSeriesItem(hd.chartItem);
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
         var n:String = elt.displayName;
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
      
      [Inspectable(category="General",enumeration="stacked,100%,overlaid",defaultValue="overlaid")]
      override public function set type(value:String) : void
      {
         super.type = value;
      }
   }
}

