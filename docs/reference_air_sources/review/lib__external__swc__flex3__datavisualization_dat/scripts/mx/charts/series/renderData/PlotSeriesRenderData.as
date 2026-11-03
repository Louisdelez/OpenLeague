package mx.charts.series.renderData
{
   import mx.charts.chartClasses.RenderData;
   
   public class PlotSeriesRenderData extends RenderData
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      [Inspectable(environment="none")]
      public var radius:Number;
      
      public function PlotSeriesRenderData(cache:Array = null, filteredCache:Array = null, radius:Number = 0)
      {
         super(cache,filteredCache);
         this.radius = radius;
      }
      
      override public function clone() : RenderData
      {
         return new PlotSeriesRenderData(cache,filteredCache,radius);
      }
   }
}

