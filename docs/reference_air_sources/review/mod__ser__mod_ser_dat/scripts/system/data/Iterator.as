package system.data
{
   public interface Iterator
   {
      
      function next() : *;
      
      function remove() : *;
      
      function key() : *;
      
      function seek(param1:*) : void;
      
      function hasNext() : Boolean;
      
      function reset() : void;
   }
}

