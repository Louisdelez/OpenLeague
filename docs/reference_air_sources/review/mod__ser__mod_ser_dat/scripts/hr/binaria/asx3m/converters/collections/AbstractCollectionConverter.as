package hr.binaria.asx3m.converters.collections
{
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   import hr.binaria.asx3m.converters.IConverter;
   import hr.binaria.asx3m.converters.IMarshallingContext;
   import hr.binaria.asx3m.converters.IUnmarshallingContext;
   import hr.binaria.asx3m.io.IHierarchicalStreamReader;
   import hr.binaria.asx3m.io.IHierarchicalStreamWriter;
   import hr.binaria.asx3m.mapper.IMapper;
   
   public class AbstractCollectionConverter implements IConverter
   {
      
      protected var _mapper:IMapper;
      
      public function AbstractCollectionConverter(param1:IMapper)
      {
         super();
         _mapper = param1;
      }
      
      public function canConvert(param1:Class) : Boolean
      {
         return false;
      }
      
      protected function writeItem(param1:Object, param2:IMarshallingContext, param3:IHierarchicalStreamWriter) : void
      {
         var _loc4_:String = null;
         if(param1 == null)
         {
            _loc4_ = _mapper.serializedClass(null);
            param3.startNode(_loc4_);
            param3.endNode();
         }
         else
         {
            _loc4_ = _mapper.serializedClass(getDefinitionByName(getQualifiedClassName(param1)) as Class);
            param3.startNode(_loc4_);
            param2.convertAnother(param1,null);
            param3.endNode();
         }
      }
      
      public function unmarshal(param1:IHierarchicalStreamReader, param2:IUnmarshallingContext) : Object
      {
         return null;
      }
      
      public function marshal(param1:Object, param2:IHierarchicalStreamWriter, param3:IMarshallingContext) : void
      {
      }
   }
}

