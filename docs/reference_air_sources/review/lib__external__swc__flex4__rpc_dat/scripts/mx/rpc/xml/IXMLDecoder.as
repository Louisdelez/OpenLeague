package mx.rpc.xml
{
   public interface IXMLDecoder
   {
      
      function get makeObjectsBindable() : Boolean;
      
      function set makeObjectsBindable(param1:Boolean) : void;
      
      function get recordXSIType() : Boolean;
      
      function set recordXSIType(param1:Boolean) : void;
      
      function get typeRegistry() : SchemaTypeRegistry;
      
      function set typeRegistry(param1:SchemaTypeRegistry) : void;
      
      function decode(param1:*, param2:QName = null, param3:QName = null, param4:XML = null) : *;
      
      function reset() : void;
   }
}

