package hr.binaria.asx3m.converters.basic
{
   public class NumberConverter extends AbstractSingleValueConverter
   {
      
      public function NumberConverter()
      {
         super();
      }
      
      override public function fromString(param1:String) : Object
      {
         return isNaN(Number(param1)) ? null : new Number(param1);
      }
      
      override public function canConvert(param1:Class) : Boolean
      {
         return new param1() is Number;
      }
      
      override public function toString(param1:Object) : String
      {
         return param1 == null || isNaN(Number(param1)) ? null : param1.toString();
      }
   }
}

