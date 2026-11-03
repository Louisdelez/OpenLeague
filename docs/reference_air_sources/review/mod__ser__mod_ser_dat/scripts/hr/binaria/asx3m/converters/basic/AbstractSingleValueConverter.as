package hr.binaria.asx3m.converters.basic
{
   import hr.binaria.asx3m.converters.ISingleValueConverter;
   
   public class AbstractSingleValueConverter implements ISingleValueConverter
   {
      
      public function AbstractSingleValueConverter()
      {
         super();
      }
      
      public function canConvert(param1:Class) : Boolean
      {
         return false;
      }
      
      public function toString(param1:Object) : String
      {
         return param1 == null ? null : param1.toString();
      }
      
      public function fromString(param1:String) : Object
      {
         return null;
      }
   }
}

