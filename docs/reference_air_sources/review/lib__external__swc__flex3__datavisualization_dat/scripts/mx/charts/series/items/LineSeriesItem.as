package mx.charts.series.items
{
   import mx.charts.ChartItem;
   import mx.charts.series.LineSeries;
   import mx.graphics.IFill;
   
   public class LineSeriesItem extends ChartItem
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      [Inspectable(environment="none")]
      public var xNumber:Number;
      
      [Inspectable(environment="none")]
      public var yNumber:Number;
      
      [Inspectable(environment="none")]
      public var fill:IFill;
      
      [Inspectable(environment="none")]
      public var xFilter:Number;
      
      [Inspectable(environment="none")]
      public var yFilter:Number;
      
      [Inspectable(environment="none")]
      public var yValue:Object;
      
      [Inspectable(environment="none")]
      public var xValue:Object;
      
      [Inspectable(environment="none")]
      public var y:Number;
      
      [Inspectable(environment="none")]
      public var x:Number;
      
      public function LineSeriesItem(element:LineSeries = null, data:Object = null, index:uint = 0)
      {
         super(element,data,index);
      }
      
      override public function clone() : ChartItem
      {
         var result:LineSeriesItem = new LineSeriesItem(LineSeries(element),item,index);
         result.itemRenderer = itemRenderer;
         return result;
      }
   }
}

