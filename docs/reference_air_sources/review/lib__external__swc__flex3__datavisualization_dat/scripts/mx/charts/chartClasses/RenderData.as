package mx.charts.chartClasses
{
   import flash.geom.Rectangle;
   
   public class RenderData
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      [Inspectable(environment="none")]
      public var cache:Array;
      
      [Inspectable(environment="none")]
      public var filteredCache:Array;
      
      [Inspectable(environment="none")]
      public var visibleRegion:Rectangle;
      
      [Inspectable(environment="none")]
      public var elementBounds:Array;
      
      [Inspectable(environment="none")]
      public var bounds:Rectangle;
      
      public function RenderData(cache:Array = null, filteredCache:Array = null)
      {
         super();
         this.cache = cache;
         this.filteredCache = filteredCache;
      }
      
      [Inspectable(environment="none")]
      public function get length() : uint
      {
         return Boolean(cache) ? cache.length : 0;
      }
      
      public function clone() : RenderData
      {
         return null;
      }
   }
}

