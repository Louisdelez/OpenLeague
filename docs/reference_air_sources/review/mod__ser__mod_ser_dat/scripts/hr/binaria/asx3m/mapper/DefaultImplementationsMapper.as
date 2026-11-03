package hr.binaria.asx3m.mapper
{
   import system.data.Map;
   import system.data.maps.HashMap;
   
   public class DefaultImplementationsMapper extends MapperWrapper
   {
      
      private var implToType:Map = new HashMap();
      
      private var typeToImpl:Map = new HashMap();
      
      public function DefaultImplementationsMapper(param1:IMapper)
      {
         super(param1);
      }
      
      public function addDefaultImplementation(param1:Class, param2:Class) : void
      {
         typeToImpl.put(param2,param1);
         implToType.put(param1,param2);
      }
      
      override public function serializedClass(param1:Class) : String
      {
         var _loc2_:Class = implToType.get(param1) as Class;
         return _loc2_ == null ? super.serializedClass(param1) : super.serializedClass(_loc2_);
      }
      
      override public function defaultImplementationOf(param1:Class) : Class
      {
         if(typeToImpl.containsKey(param1))
         {
            return typeToImpl.get(param1) as Class;
         }
         return super.defaultImplementationOf(param1);
      }
   }
}

