package hr.binaria.asx3m.mapper
{
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   import system.data.Iterator;
   import system.data.Map;
   import system.data.Set;
   import system.data.maps.HashMap;
   import system.data.sets.HashSet;
   
   public class ClassAliasingMapper extends MapperWrapper
   {
      
      protected var typeToName:Map = new HashMap();
      
      protected var nameToType:Map = new HashMap();
      
      protected var knownAttributes:Set = new HashSet();
      
      protected var classToName:Map = new HashMap();
      
      public function ClassAliasingMapper(param1:IMapper)
      {
         super(param1);
      }
      
      override public function realClass(param1:String) : Class
      {
         var _loc3_:Class = null;
         var _loc2_:String = nameToType.get(param1);
         if(_loc2_ != null)
         {
            _loc3_ = primitiveClassNamed(_loc2_);
            if(_loc3_ != null)
            {
               return _loc3_;
            }
            param1 = _loc2_;
         }
         return super.realClass(param1);
      }
      
      public function aliasIsAttribute(param1:String) : Boolean
      {
         return nameToType.containsKey(param1);
      }
      
      override public function serializedClass(param1:Class) : String
      {
         var _loc3_:Iterator = null;
         var _loc4_:Class = null;
         var _loc2_:String = String(classToName.get(getQualifiedClassName(param1)));
         if(_loc2_ != "undefined")
         {
            return _loc2_;
         }
         _loc3_ = typeToName.keyIterator();
         while(_loc3_.hasNext())
         {
            _loc4_ = Class(getDefinitionByName(_loc3_.next()));
            if(param1 is _loc4_)
            {
               return String(typeToName.get(_loc4_));
            }
         }
         return super.serializedClass(param1);
      }
      
      private function primitiveClassNamed(param1:String) : Class
      {
         return Class(param1 == "boolean" ? getDefinitionByName("Boolean") : (param1 == "byte" ? getDefinitionByName("int") : (param1 == "char" ? getDefinitionByName("String") : (param1 == "short" ? getDefinitionByName("int") : (param1 == "int" ? getDefinitionByName("int") : (param1 == "long" ? getDefinitionByName("Number") : (param1 == "big-decimal" ? getDefinitionByName("Number") : (param1 == "float" ? getDefinitionByName("Number") : (param1 == "double" ? getDefinitionByName("Number") : null)))))))));
      }
      
      public function addClassAttributeAlias(param1:String, param2:Class) : void
      {
         addClassAlias(param1,param2);
         knownAttributes.add(param1);
      }
      
      public function addTypeAlias(param1:String, param2:Class) : void
      {
         nameToType.put(param1,getQualifiedClassName(param2));
         typeToName.put(getQualifiedClassName(param2),param1);
      }
      
      private function readResolve() : Object
      {
         var _loc3_:Object = null;
         var _loc1_:Map = new HashMap();
         var _loc2_:Iterator = classToName.keyIterator();
         while(_loc2_.hasNext())
         {
            _loc3_ = _loc2_.next();
            _loc1_.put(classToName.get(_loc3_),_loc3_);
         }
         _loc2_ = typeToName.keyIterator();
         while(_loc2_.hasNext())
         {
            _loc3_ = Class(_loc2_.next());
            _loc1_.put(typeToName.get(_loc3_),getQualifiedClassName(_loc3_));
         }
         return this;
      }
      
      public function addClassAlias(param1:String, param2:Class) : void
      {
         nameToType.put(param1,getQualifiedClassName(param2));
         classToName.put(getQualifiedClassName(param2),param1);
      }
      
      public function temTypeAsAttribute(param1:Class) : Boolean
      {
         return classToName.containsKey(param1);
      }
   }
}

