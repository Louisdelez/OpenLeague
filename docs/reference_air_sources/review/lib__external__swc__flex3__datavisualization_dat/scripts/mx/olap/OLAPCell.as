package mx.olap
{
   public class OLAPCell implements IOLAPCell
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private var _value:Number;
      
      protected var _formattedValue:String;
      
      public function OLAPCell(value:Number, formattedValue:String = null)
      {
         super();
         _value = value;
         _formattedValue = formattedValue;
      }
      
      public function get value() : Number
      {
         return _value;
      }
      
      public function get formattedValue() : String
      {
         if(Boolean(_formattedValue))
         {
            return _formattedValue;
         }
         return _value.toString();
      }
   }
}

