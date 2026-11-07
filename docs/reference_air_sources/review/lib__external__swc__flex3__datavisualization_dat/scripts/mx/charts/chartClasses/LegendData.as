package mx.charts.chartClasses
{
   import mx.core.IFlexDisplayObject;
   
   public class LegendData
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      [Inspectable]
      public var marker:IFlexDisplayObject;
      
      [Inspectable]
      public var aspectRatio:Number;
      
      [Inspectable]
      public var label:String = "";
      
      [Inspectable(environment="none")]
      public var element:IChartElement;
      
      public function LegendData()
      {
         super();
      }
   }
}

