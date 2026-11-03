package system.data
{
   import system.Cloneable;
   import system.Serializable;
   
   public interface Stack extends Cloneable, Iterable, Serializable
   {
      
      function size() : uint;
      
      function pop() : *;
      
      function isEmpty() : Boolean;
      
      function search(param1:*) : int;
      
      function push(param1:*) : void;
      
      function peek() : *;
      
      function clear() : void;
   }
}

