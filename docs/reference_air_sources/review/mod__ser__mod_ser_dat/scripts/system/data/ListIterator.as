package system.data
{
   public interface ListIterator extends OrderedIterator
   {
      
      function add(param1:*) : void;
      
      function set(param1:*) : void;
      
      function previousIndex() : int;
      
      function nextIndex() : uint;
   }
}

