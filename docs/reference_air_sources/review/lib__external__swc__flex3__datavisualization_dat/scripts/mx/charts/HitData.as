package mx.charts
{
   import mx.charts.chartClasses.GraphicsUtilities;
   import mx.charts.chartClasses.IChartElement;
   import mx.styles.IStyleClient;
   
   public class HitData
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      [Inspectable(environment="none")]
      public var dataTipFunction:Function;
      
      [Inspectable(environment="none")]
      public var chartItem:ChartItem;
      
      [Inspectable(environment="none")]
      public var contextColor:uint = 0;
      
      [Inspectable(environment="none")]
      public var distance:Number;
      
      [Inspectable(environment="none")]
      public var x:Number;
      
      [Inspectable(environment="none")]
      public var y:Number;
      
      [Inspectable(environment="none")]
      public var item:Object;
      
      [Inspectable(environment="none")]
      public var id:Number;
      
      public function HitData(id:Number, distance:Number, x:Number, y:Number, chartItem:ChartItem)
      {
         var f:Object = null;
         super();
         this.id = id;
         this.distance = distance;
         this.x = x;
         this.y = y;
         this.chartItem = chartItem;
         this.item = chartItem.item;
         if(chartItem.element is IStyleClient)
         {
            f = IStyleClient(chartItem.element).getStyle("fill");
            contextColor = GraphicsUtilities.colorFromFill(f);
         }
      }
      
      [Inspectable(environment="none")]
      public function get displayText() : String
      {
         return dataTipFunction(this);
      }
      
      [Inspectable(environment="none")]
      public function get element() : IChartElement
      {
         return chartItem.element;
      }
   }
}

