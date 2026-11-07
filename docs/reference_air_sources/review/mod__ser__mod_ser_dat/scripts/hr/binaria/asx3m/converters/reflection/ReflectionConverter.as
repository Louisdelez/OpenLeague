package hr.binaria.asx3m.converters.reflection
{
   import flash.utils.describeType;
   import hr.binaria.asx3m.converters.IConverter;
   import hr.binaria.asx3m.converters.IMarshallingContext;
   import hr.binaria.asx3m.converters.IUnmarshallingContext;
   import hr.binaria.asx3m.io.IHierarchicalStreamReader;
   import hr.binaria.asx3m.io.IHierarchicalStreamWriter;
   import hr.binaria.asx3m.mapper.IMapper;
   
   public class ReflectionConverter implements IConverter
   {
      
      private var _mapper:IMapper;
      
      private var _alias:Array;
      
      private var _reflectionProvider:IReflectionProvider;
      
      public function ReflectionConverter(param1:IMapper, param2:IReflectionProvider)
      {
         super();
         _mapper = param1;
         _reflectionProvider = param2;
         _alias = new Array();
         _alias["String"] = "string";
         _alias["Number"] = "int";
         _alias["Boolean"] = "boolean";
      }
      
      public function unmarshal(param1:IHierarchicalStreamReader, param2:IUnmarshallingContext) : Object
      {
         var _loc3_:XML = null;
         var _loc4_:Class = null;
         var _loc5_:XML = null;
         var _loc6_:Object = null;
         var _loc7_:String = null;
         var _loc8_:Class = null;
         _loc3_ = param1.getCurrent();
         _loc4_ = param2.getRequiredType() as Class;
         _loc6_ = new _loc4_();
         _loc5_ = describeType(_loc6_);
         while(param1.hasMoreChildren())
         {
            param1.moveDown();
            _loc3_ = param1.getCurrent();
            _loc7_ = getTypeFromDescriptor(_loc3_.name(),_loc5_);
            if(_loc7_ != null)
            {
               _loc8_ = _mapper.realClass(_loc7_);
               _loc6_[_loc3_.name()] = param2.convertAnother(null,_loc8_,null);
            }
            param1.moveUp();
         }
         return _loc6_;
      }
      
      private function escapeNull(param1:*) : *
      {
         if(param1 == null)
         {
            return "";
         }
         return param1;
      }
      
      private function getTypeFromDescriptor(param1:String, param2:XML) : String
      {
         var _loc3_:XML = null;
         var _loc4_:XML = null;
         for each(_loc3_ in param2.elements("variable"))
         {
            if(_loc3_.@name == param1)
            {
               return String(_loc3_.@type);
            }
         }
         for each(_loc4_ in param2.elements("accessor"))
         {
            if(_loc4_.@name == param1)
            {
               return String(_loc4_.@type);
            }
         }
         return null;
      }
      
      public function canConvert(param1:Class) : Boolean
      {
         return new param1() is Object;
      }
      
      public function marshal(param1:Object, param2:IHierarchicalStreamWriter, param3:IMarshallingContext) : void
      {
         var _loc5_:XML = null;
         var _loc6_:String = null;
         var _loc7_:Object = null;
         var _loc4_:XML = describeType(param1);
         for each(_loc5_ in _loc4_.elements("variable"))
         {
            _loc7_ = param1[_loc5_.@name];
            if(_loc7_ is Number && isNaN(Number(_loc7_)))
            {
               _loc7_ = null;
            }
            if(_loc7_ != null)
            {
               param2.startNode(_loc5_.@name);
               param3.convertAnother(_loc7_,null);
               param2.endNode();
            }
         }
         for each(_loc5_ in _loc4_.elements("accessor"))
         {
            if(_loc5_.@access != "readonly")
            {
               if(param1[_loc5_.@name] != null)
               {
                  param2.startNode(_loc5_.@name);
                  param3.convertAnother(param1[_loc5_.@name],null);
                  param2.endNode();
               }
            }
         }
      }
   }
}

