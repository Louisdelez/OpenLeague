package hr.binaria.asx3m.core
{
   import hr.binaria.asx3m.IMarshallingStrategy;
   import hr.binaria.asx3m.converters.IConverterLookup;
   import hr.binaria.asx3m.converters.IDataHolder;
   import hr.binaria.asx3m.io.IHierarchicalStreamReader;
   import hr.binaria.asx3m.io.IHierarchicalStreamWriter;
   import hr.binaria.asx3m.mapper.IMapper;
   
   public class TreeMarshallingStrategy implements IMarshallingStrategy
   {
      
      public function TreeMarshallingStrategy()
      {
         super();
      }
      
      public function marshall(param1:Object, param2:IHierarchicalStreamWriter, param3:IConverterLookup, param4:IMapper, param5:IDataHolder) : void
      {
         var _loc6_:TreeMarshaller = new TreeMarshaller(param2,param3,param4);
         _loc6_.start(param1,param5);
      }
      
      public function unmarshall(param1:Object, param2:IHierarchicalStreamReader, param3:IDataHolder, param4:IConverterLookup, param5:IMapper) : Object
      {
         var _loc6_:TreeUnmarshaller = new TreeUnmarshaller(param1,param2,param4,param5);
         return _loc6_.start(param3);
      }
   }
}

