package mx.charts.chartClasses
{
   public class BoundedValue
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      [Inspectable(environment="none")]
      public var upperMargin:Number;
      
      [Inspectable(environment="none")]
      public var value:Number;
      
      [Inspectable(environment="none")]
      public var lowerMargin:Number;
      
      public function BoundedValue(value:Number, lowerMargin:Number = 0, upperMargin:Number = 0)
      {
         super();
         this.value = value;
         this.lowerMargin = lowerMargin;
         this.upperMargin = upperMargin;
      }
   }
}

