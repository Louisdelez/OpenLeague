package mx.charts.series.items
{
   import mx.charts.ChartItem;
   import mx.charts.chartClasses.HLOCSeriesBase;
   import mx.graphics.IFill;
   
   public class HLOCSeriesItem extends ChartItem
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      [Inspectable(environment="none")]
      public var highFilter:Number;
      
      [Inspectable(environment="none")]
      public var closeNumber:Number;
      
      [Inspectable(environment="none")]
      public var openValue:Object;
      
      [Inspectable(environment="none")]
      public var open:Number;
      
      [Inspectable(environment="none")]
      public var highNumber:Number;
      
      [Inspectable(environment="none")]
      public var lowValue:Object;
      
      [Inspectable(environment="none")]
      public var xFilter:Number;
      
      [Inspectable(environment="none")]
      public var fill:IFill;
      
      [Inspectable(environment="none")]
      public var low:Number;
      
      [Inspectable(environment="none")]
      public var openNumber:Number;
      
      [Inspectable(environment="none")]
      public var closeFilter:Number;
      
      [Inspectable(environment="none")]
      public var xValue:Object;
      
      [Inspectable(environment="none")]
      public var xNumber:Number;
      
      [Inspectable(environment="none")]
      public var high:Number;
      
      [Inspectable(environment="none")]
      public var openFilter:Number;
      
      [Inspectable(environment="none")]
      public var lowFilter:Number;
      
      [Inspectable(environment="none")]
      public var highValue:Object;
      
      [Inspectable(environment="none")]
      public var closeValue:Object;
      
      [Inspectable(environment="none")]
      public var x:Number;
      
      [Inspectable(environment="none")]
      public var lowNumber:Number;
      
      [Inspectable(environment="none")]
      public var close:Number;
      
      public function HLOCSeriesItem(element:HLOCSeriesBase = null, data:Object = null, index:uint = 0)
      {
         super(element,data,index);
      }
      
      override public function clone() : ChartItem
      {
         var result:HLOCSeriesItem = new HLOCSeriesItem(HLOCSeriesBase(element),item,index);
         result.itemRenderer = itemRenderer;
         return result;
      }
   }
}

