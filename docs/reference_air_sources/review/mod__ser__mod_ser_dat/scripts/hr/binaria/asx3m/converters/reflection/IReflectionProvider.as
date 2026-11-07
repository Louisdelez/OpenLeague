package hr.binaria.asx3m.converters.reflection
{
   public interface IReflectionProvider
   {
      
      function getField(param1:Class, param2:String) : *;
      
      function newInstance(param1:Class) : Object;
      
      function writeField(param1:Object, param2:String, param3:Object, param4:Class) : void;
      
      function fieldDefinedInClass(param1:String, param2:Class) : Boolean;
      
      function getFieldType(param1:Object, param2:String, param3:Class) : Class;
   }
}

