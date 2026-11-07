package hr.binaria.asx3m.converters
{
   public interface ISingleValueConverter extends IConverterMatcher
   {
      
      function fromString(param1:String) : Object;
      
      function toString(param1:Object) : String;
   }
}

