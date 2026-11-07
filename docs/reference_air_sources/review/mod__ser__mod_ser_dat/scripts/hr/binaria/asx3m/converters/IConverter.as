package hr.binaria.asx3m.converters
{
   import hr.binaria.asx3m.io.IHierarchicalStreamReader;
   import hr.binaria.asx3m.io.IHierarchicalStreamWriter;
   
   public interface IConverter extends IConverterMatcher
   {
      
      function unmarshal(param1:IHierarchicalStreamReader, param2:IUnmarshallingContext) : Object;
      
      function marshal(param1:Object, param2:IHierarchicalStreamWriter, param3:IMarshallingContext) : void;
   }
}

