package system.data
{
   public interface OrderedIterator extends Iterator
   {
      
      function hasPrevious() : Boolean;
      
      function previous() : *;
   }
}

