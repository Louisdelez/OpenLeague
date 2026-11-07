package mx.charts.series.items
{
   import mx.charts.series.LineSeries;
   
   public class LineSeriesSegment
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      [Inspectable(environment="none")]
      public var index:uint;
      
      [Inspectable(environment="none")]
      public var items:Array;
      
      [Inspectable(environment="none")]
      public var start:uint;
      
      [Inspectable(environment="none")]
      public var end:uint;
      
      [Inspectable(environment="none")]
      public var element:LineSeries;
      
      public function LineSeriesSegment(element:LineSeries, index:uint, items:Array, start:uint, end:uint)
      {
         super();
         this.element = element;
         this.items = items;
         this.index = index;
         this.start = start;
         this.end = end;
      }
      
      public function clone() : LineSeriesSegment
      {
         return new LineSeriesSegment(element,index,items,start,end);
      }
   }
}

