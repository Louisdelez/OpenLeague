package mx.charts.series.renderData
{
   import mx.charts.chartClasses.RenderData;
   
   public class BubbleSeriesRenderData extends RenderData
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      public function BubbleSeriesRenderData(cache:Array = null, filteredCache:Array = null)
      {
         super(cache,filteredCache);
      }
      
      override public function clone() : RenderData
      {
         return new BubbleSeriesRenderData(cache,filteredCache);
      }
   }
}

