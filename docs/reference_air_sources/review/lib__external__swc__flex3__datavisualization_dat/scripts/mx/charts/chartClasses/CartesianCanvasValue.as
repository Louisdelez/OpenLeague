package mx.charts.chartClasses
{
   public class CartesianCanvasValue
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private var _offset:Number;
      
      private var _value:*;
      
      public function CartesianCanvasValue(value:*, offset:Number = 0)
      {
         super();
         this.value = value;
         this.offset = offset;
      }
      
      public function get value() : *
      {
         return _value;
      }
      
      public function get offset() : Number
      {
         return _offset;
      }
      
      public function set offset(data:Number) : void
      {
         _offset = data;
      }
      
      public function set value(data:*) : void
      {
         _value = data;
      }
      
      public function clone() : CartesianCanvasValue
      {
         return new CartesianCanvasValue(value,offset);
      }
   }
}

