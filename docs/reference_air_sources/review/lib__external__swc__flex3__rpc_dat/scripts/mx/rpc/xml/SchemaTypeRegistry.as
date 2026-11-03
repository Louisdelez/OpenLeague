package mx.rpc.xml
{
   import flash.utils.getDefinitionByName;
   import flash.utils.getQualifiedClassName;
   
   public class SchemaTypeRegistry
   {
      
      private static var _instance:SchemaTypeRegistry;
      
      private var classMap:Object = {};
      
      private var collectionMap:Object = {};
      
      public function SchemaTypeRegistry()
      {
         super();
      }
      
      public static function getInstance() : SchemaTypeRegistry
      {
         if(_instance == null)
         {
            _instance = new SchemaTypeRegistry();
         }
         return _instance;
      }
      
      public function getClass(type:Object) : Class
      {
         var c:Class = null;
         var key:String = null;
         var definitionName:String = null;
         if(type != null)
         {
            key = getKey(type);
            definitionName = classMap[key] as String;
            if(definitionName != null)
            {
               c = getDefinitionByName(definitionName) as Class;
            }
         }
         return c;
      }
      
      private function register(type:Object, definition:Object, map:Object) : void
      {
         var definitionName:String = null;
         var key:String = getKey(type);
         if(definition is String)
         {
            definitionName = definition as String;
         }
         else
         {
            definitionName = getQualifiedClassName(definition);
         }
         map[key] = definitionName;
      }
      
      public function getCollectionClass(type:Object) : Class
      {
         var c:Class = null;
         var key:String = null;
         var definitionName:String = null;
         if(type != null)
         {
            key = getKey(type);
            definitionName = collectionMap[key] as String;
            if(definitionName != null)
            {
               c = getDefinitionByName(definitionName) as Class;
            }
         }
         return c;
      }
      
      public function unregisterCollectionClass(type:Object) : void
      {
         var key:String = null;
         if(type != null)
         {
            key = getKey(type);
            delete collectionMap[key];
         }
      }
      
      private function getKey(type:Object) : String
      {
         var key:String = null;
         var typeQName:QName = null;
         if(type is QName)
         {
            typeQName = type as QName;
            if(typeQName.uri == null || typeQName.uri == "")
            {
               key = typeQName.localName;
            }
            else
            {
               key = typeQName.toString();
            }
         }
         else
         {
            key = type.toString();
         }
         return key;
      }
      
      public function registerClass(type:Object, definition:Object) : void
      {
         register(type,definition,classMap);
      }
      
      public function registerCollectionClass(type:Object, definition:Object) : void
      {
         register(type,definition,collectionMap);
      }
      
      public function unregisterClass(type:Object) : void
      {
         var key:String = null;
         if(type != null)
         {
            key = getKey(type);
            delete classMap[key];
         }
      }
   }
}

