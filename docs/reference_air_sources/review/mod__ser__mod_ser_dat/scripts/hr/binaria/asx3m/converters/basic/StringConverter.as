package hr.binaria.asx3m.converters.basic
{
   public class StringConverter extends AbstractSingleValueConverter
   {
      
      public function StringConverter()
      {
         super();
      }
      
      override public function canConvert(param1:Class) : Boolean
      {
         return new param1() is String;
      }
      
      override public function fromString(param1:String) : Object
      {
         return new String(param1);
      }
   }
}

