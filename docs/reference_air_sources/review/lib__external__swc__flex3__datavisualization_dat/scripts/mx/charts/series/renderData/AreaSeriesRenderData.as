package mx.charts.series.renderData
{
   import mx.charts.chartClasses.RenderData;
   import mx.charts.series.AreaSeries;
   
   public class AreaSeriesRenderData extends RenderData
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      [Inspectable(environment="none")]
      public var radius:Number;
      
      [Inspectable(environment="none")]
      public var renderedBase:Number;
      
      [Inspectable(environment="none")]
      public var element:AreaSeries;
      
      public function AreaSeriesRenderData(element:AreaSeries, cache:Array = null, filteredCache:Array = null, renderedBase:Number = 0, radius:Number = 0)
      {
         super(cache,filteredCache);
         this.element = element;
         this.renderedBase = renderedBase;
         this.radius = radius;
      }
      
      override public function clone() : RenderData
      {
         return new AreaSeriesRenderData(element,cache,filteredCache,renderedBase,radius);
      }
   }
}

