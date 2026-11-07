package blix.ds
{
   public interface IIterator
   {
      
      function hasNext() : Boolean;
      
      function getNext() : Object;
      
      function hasPrevious() : Boolean;
      
      function getPrevious() : Object;
      
      function getCurrent() : Object;
   }
}

