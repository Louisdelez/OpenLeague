package hr.binaria.asx3m
{
   import hr.binaria.asx3m.converters.IConverterLookup;
   import hr.binaria.asx3m.converters.IDataHolder;
   import hr.binaria.asx3m.io.IHierarchicalStreamReader;
   import hr.binaria.asx3m.io.IHierarchicalStreamWriter;
   import hr.binaria.asx3m.mapper.IMapper;
   
   public interface IMarshallingStrategy
   {
      
      function marshall(param1:Object, param2:IHierarchicalStreamWriter, param3:IConverterLookup, param4:IMapper, param5:IDataHolder) : void;
      
      function unmarshall(param1:Object, param2:IHierarchicalStreamReader, param3:IDataHolder, param4:IConverterLookup, param5:IMapper) : Object;
   }
}

