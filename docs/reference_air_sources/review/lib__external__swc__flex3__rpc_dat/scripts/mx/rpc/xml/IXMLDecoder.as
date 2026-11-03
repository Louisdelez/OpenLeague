package mx.rpc.xml
{
   [ExcludeClass]
   public interface IXMLDecoder
   {
      
      function decode(param1:*, param2:QName = null, param3:QName = null, param4:XML = null) : *;
      
      function set recordXSIType(param1:Boolean) : void;
      
      function get recordXSIType() : Boolean;
      
      function get typeRegistry() : SchemaTypeRegistry;
      
      function set makeObjectsBindable(param1:Boolean) : void;
      
      function get makeObjectsBindable() : Boolean;
      
      function set typeRegistry(param1:SchemaTypeRegistry) : void;
      
      function reset() : void;
   }
}

