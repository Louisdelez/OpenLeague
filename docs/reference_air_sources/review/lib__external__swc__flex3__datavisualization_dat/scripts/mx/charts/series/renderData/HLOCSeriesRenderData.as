package mx.charts.series.renderData
{
   import mx.charts.chartClasses.RenderData;
   
   public class HLOCSeriesRenderData extends RenderData
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      [Inspectable(environment="none")]
      public var renderedXOffset:Number;
      
      [Inspectable(environment="none")]
      public var renderedHalfWidth:Number;
      
      public function HLOCSeriesRenderData(cache:Array = null, filteredCache:Array = null, renderedHalfWidth:Number = 0, renderedXOffset:Number = 0)
      {
         super(cache,filteredCache);
         this.renderedHalfWidth = renderedHalfWidth;
         this.renderedXOffset = renderedXOffset;
      }
      
      override public function clone() : RenderData
      {
         return new HLOCSeriesRenderData(cache,filteredCache,renderedHalfWidth,renderedXOffset);
      }
   }
}

