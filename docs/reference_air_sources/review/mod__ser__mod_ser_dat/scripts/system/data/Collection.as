package system.data
{
   import system.Cloneable;
   import system.Serializable;
   
   public interface Collection extends Cloneable, Iterable, Serializable
   {
      
      function add(param1:*) : Boolean;
      
      function isEmpty() : Boolean;
      
      function remove(param1:*) : *;
      
      function get(param1:*) : *;
      
      function size() : uint;
      
      function indexOf(param1:*, param2:uint = 0) : int;
      
      function clear() : void;
      
      function toArray() : Array;
      
      function contains(param1:*) : Boolean;
   }
}

