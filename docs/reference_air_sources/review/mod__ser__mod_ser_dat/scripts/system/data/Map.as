package system.data
{
   import system.Cloneable;
   import system.Serializable;
   
   public interface Map extends Cloneable, Iterable, Serializable
   {
      
      function containsKey(param1:*) : Boolean;
      
      function size() : uint;
      
      function isEmpty() : Boolean;
      
      function remove(param1:*) : *;
      
      function getKeys() : Array;
      
      function keyIterator() : Iterator;
      
      function put(param1:*, param2:*) : *;
      
      function containsValue(param1:*) : Boolean;
      
      function clear() : void;
      
      function get(param1:*) : *;
      
      function getValues() : Array;
      
      function putAll(param1:Map) : void;
   }
}

