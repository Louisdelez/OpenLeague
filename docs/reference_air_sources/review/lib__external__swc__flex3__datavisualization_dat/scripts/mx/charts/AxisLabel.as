package mx.charts
{
   public class AxisLabel
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      [Inspectable(environment="none")]
      public var value:Object;
      
      [Inspectable(environment="none")]
      public var position:Number;
      
      [Inspectable(environment="none")]
      public var text:String;
      
      public function AxisLabel(position:Number = 0, value:Object = null, text:String = null)
      {
         super();
         this.position = position;
         this.value = value;
         this.text = text;
      }
   }
}

