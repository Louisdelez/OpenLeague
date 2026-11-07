package mx.charts.series.items
{
   import flash.geom.Point;
   import mx.charts.ChartItem;
   import mx.charts.series.PieSeries;
   import mx.core.IUITextField;
   import mx.graphics.IFill;
   
   public class PieSeriesItem extends ChartItem
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var labelText:String;
      
      [Inspectable(environment="none")]
      public var fill:IFill;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var labelSin:Number;
      
      [Inspectable(environment="none")]
      public var number:Number;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var next:PieSeriesItem;
      
      [Inspectable(environment="none")]
      public var startAngle:Number;
      
      [Inspectable(environment="none")]
      public var angle:Number;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var labelCos:Number;
      
      [Inspectable(environment="none")]
      public var innerRadius:Number;
      
      [Inspectable(environment="none")]
      public var origin:Point;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var labelX:Number;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var labelY:Number;
      
      [Inspectable(environment="none")]
      public var percentValue:Number;
      
      [Inspectable(environment="none")]
      public var value:Object;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var labelWidth:Number;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var prev:PieSeriesItem;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var label:IUITextField;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var labelHeight:Number;
      
      [Inspectable(environment="none")]
      public var outerRadius:Number;
      
      [Inspectable(environment="none")]
      public var labelAngle:Number;
      
      public function PieSeriesItem(element:PieSeries = null, data:Object = null, index:uint = 0)
      {
         super(element,data,index);
      }
      
      override public function clone() : ChartItem
      {
         var result:PieSeriesItem = new PieSeriesItem(PieSeries(element),item,index);
         result.itemRenderer = itemRenderer;
         return result;
      }
   }
}

