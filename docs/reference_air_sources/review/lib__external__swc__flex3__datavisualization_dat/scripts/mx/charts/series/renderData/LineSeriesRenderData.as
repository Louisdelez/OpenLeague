package mx.charts.series.renderData
{
   import mx.charts.chartClasses.RenderData;
   
   public class LineSeriesRenderData extends RenderData
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      [Inspectable(environment="none")]
      public var segments:Array;
      
      [Inspectable(environment="none")]
      public var radius:Number;
      
      [Inspectable(environment="none")]
      public var validPoints:Number;
      
      public function LineSeriesRenderData(cache:Array = null, filteredCache:Array = null, validPoints:Number = 0, segments:Array = null, radius:Number = 0)
      {
         super(cache,filteredCache);
         this.validPoints = validPoints;
         this.segments = segments;
         this.radius = radius;
      }
      
      override public function clone() : RenderData
      {
         var newSegments:Array = [];
         var n:int = int(segments.length);
         for(var i:int = 0; i < n; i++)
         {
            newSegments[i] = segments[i].clone();
         }
         return new LineSeriesRenderData(cache,filteredCache,validPoints,newSegments,radius);
      }
   }
}

