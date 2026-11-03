package mx.charts.series.items
{
   import mx.charts.ChartItem;
   import mx.charts.series.ColumnSeries;
   import mx.controls.Label;
   import mx.graphics.IFill;
   
   public class ColumnSeriesItem extends ChartItem
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      [Inspectable(environment="none")]
      public var y:Number;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var labelText:String;
      
      [Inspectable(environment="none")]
      public var fill:IFill;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var labelTextWidth:Number = 1;
      
      [Inspectable(environment="none")]
      public var x:Number;
      
      [Inspectable(environment="none")]
      public var xFilter:Number;
      
      [Inspectable(environment="none")]
      public var yFilter:Number;
      
      [Inspectable(environment="none")]
      public var min:Number;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var labelHeight:Number = 1;
      
      [Inspectable(environment="none")]
      public var xValue:Object;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var labelIsHorizontal:Boolean = true;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var labelWidth:Number = 1;
      
      [Inspectable(environment="none")]
      public var xNumber:Number;
      
      [Inspectable(environment="none")]
      public var yNumber:Number;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var labelY:Number;
      
      [Inspectable(environment="none")]
      public var minFilter:Number;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var labelX:Number;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var label:Label;
      
      [Inspectable(environment="none")]
      public var yValue:Object;
      
      [Inspectable(environment="none")]
      public var minNumber:Number;
      
      [Inspectable(environment="none")]
      public var minValue:Object;
      
      public function ColumnSeriesItem(element:ColumnSeries = null, data:Object = null, index:uint = 0)
      {
         super(element,data,index);
      }
      
      override public function clone() : ChartItem
      {
         var result:ColumnSeriesItem = new ColumnSeriesItem(ColumnSeries(element),item,index);
         result.itemRenderer = itemRenderer;
         return result;
      }
   }
}

