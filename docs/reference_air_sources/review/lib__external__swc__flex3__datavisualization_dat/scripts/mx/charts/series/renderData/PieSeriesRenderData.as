package mx.charts.series.renderData
{
   import mx.charts.chartClasses.RenderData;
   
   public class PieSeriesRenderData extends RenderData
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      [Inspectable(environment="none")]
      public var labelScale:Number;
      
      public var itemSum:Number;
      
      [Inspectable(environment="none")]
      public var labelData:Object;
      
      public function PieSeriesRenderData(cache:Array = null, filteredCache:Array = null, labelScale:Number = 1, labelData:Object = null)
      {
         super(cache,filteredCache);
         this.labelScale = labelScale;
         this.labelData = labelData;
      }
      
      override public function clone() : RenderData
      {
         return new PieSeriesRenderData(cache,filteredCache,labelScale,labelData);
      }
   }
}

