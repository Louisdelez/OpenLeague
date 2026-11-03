package hr.binaria.asx3m.converters
{
   public interface IConverterLookup
   {
      
      function lookupConverterForType(param1:Class) : IConverter;
   }
}

