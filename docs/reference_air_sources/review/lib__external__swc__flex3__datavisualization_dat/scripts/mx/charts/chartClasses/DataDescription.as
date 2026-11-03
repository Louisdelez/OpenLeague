package mx.charts.chartClasses
{
   public class DataDescription
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      public static const REQUIRED_BOUNDED_VALUES:uint = 2;
      
      public static const REQUIRED_MIN_INTERVAL:uint = 1;
      
      public static const REQUIRED_MIN_MAX:uint = 4;
      
      public static const REQUIRED_PADDING:uint = 8;
      
      [Inspectable(environment="none")]
      public var padding:Number;
      
      [Inspectable(environment="none")]
      public var min:Number;
      
      [Inspectable(environment="none")]
      public var max:Number;
      
      [Inspectable(environment="none")]
      public var minInterval:Number;
      
      [Inspectable(environment="none")]
      public var boundedValues:Array;
      
      public function DataDescription()
      {
         super();
      }
   }
}

