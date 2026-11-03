package mx.charts.series.renderData
{
   import mx.charts.chartClasses.RenderData;
   
   public class BarSeriesRenderData extends RenderData
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      [Inspectable(environment="none")]
      public var labelData:Object;
      
      [Inspectable(environment="none")]
      public var renderedBase:Number;
      
      [Inspectable(environment="none")]
      public var renderedYOffset:Number;
      
      [Inspectable(environment="none")]
      public var labelScale:Number;
      
      [Inspectable(environment="none")]
      public var renderedHalfWidth:Number;
      
      public function BarSeriesRenderData(cache:Array = null, filteredCache:Array = null, renderedBase:Number = 0, renderedHalfWidth:Number = 0, renderedYOffset:Number = 0, labelScale:Number = 1, labelData:Object = null)
      {
         super(cache,filteredCache);
         this.renderedBase = renderedBase;
         this.renderedHalfWidth = renderedHalfWidth;
         this.renderedYOffset = renderedYOffset;
         this.labelScale = labelScale;
         this.labelData = labelData;
      }
      
      override public function clone() : RenderData
      {
         return new BarSeriesRenderData(cache,filteredCache,renderedBase,renderedHalfWidth,renderedYOffset,labelScale,labelData);
      }
   }
}

