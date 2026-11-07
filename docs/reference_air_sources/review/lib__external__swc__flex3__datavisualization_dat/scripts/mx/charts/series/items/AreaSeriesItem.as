package mx.charts.series.items
{
   import mx.charts.ChartItem;
   import mx.charts.series.AreaSeries;
   import mx.graphics.IFill;
   
   public class AreaSeriesItem extends ChartItem
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      [Inspectable(environment="none")]
      public var fill:IFill;
      
      [Inspectable(environment="none")]
      public var x:Number;
      
      [Inspectable(environment="none")]
      public var xFilter:Number;
      
      [Inspectable(environment="none")]
      public var yFilter:Number;
      
      [Inspectable(environment="none")]
      public var min:Number;
      
      [Inspectable(environment="none")]
      public var xValue:Object;
      
      [Inspectable(environment="none")]
      public var xNumber:Number;
      
      [Inspectable(environment="none")]
      public var yNumber:Number;
      
      [Inspectable(environment="none")]
      public var minFilter:Number;
      
      [Inspectable(environment="none")]
      public var yValue:Object;
      
      [Inspectable(environment="none")]
      public var y:Number;
      
      [Inspectable(environment="none")]
      public var minNumber:Number;
      
      [Inspectable(environment="none")]
      public var minValue:Object;
      
      public function AreaSeriesItem(element:AreaSeries = null, item:Object = null, index:uint = 0)
      {
         super(element,item,index);
      }
      
      override public function clone() : ChartItem
      {
         var result:AreaSeriesItem = new AreaSeriesItem(AreaSeries(element),item,index);
         result.itemRenderer = itemRenderer;
         return result;
      }
   }
}

