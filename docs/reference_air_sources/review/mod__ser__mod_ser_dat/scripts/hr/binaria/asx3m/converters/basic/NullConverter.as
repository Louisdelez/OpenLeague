package hr.binaria.asx3m.converters.basic
{
   import hr.binaria.asx3m.converters.IConverter;
   import hr.binaria.asx3m.converters.IMarshallingContext;
   import hr.binaria.asx3m.converters.IUnmarshallingContext;
   import hr.binaria.asx3m.io.IHierarchicalStreamReader;
   import hr.binaria.asx3m.io.IHierarchicalStreamWriter;
   
   public class NullConverter implements IConverter
   {
      
      public function NullConverter()
      {
         super();
      }
      
      public function canConvert(param1:Class) : Boolean
      {
         return param1 == null;
      }
      
      public function unmarshal(param1:IHierarchicalStreamReader, param2:IUnmarshallingContext) : Object
      {
         return null;
      }
      
      public function marshal(param1:Object, param2:IHierarchicalStreamWriter, param3:IMarshallingContext) : void
      {
         param2.startNode("null");
         param2.endNode();
      }
   }
}

