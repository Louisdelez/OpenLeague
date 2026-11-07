package system.data
{
   public interface List extends Collection
   {
      
      function addAll(param1:Collection) : Boolean;
      
      function set(param1:uint, param2:*) : *;
      
      function containsAll(param1:Collection) : Boolean;
      
      function lastIndexOf(param1:*, param2:int = 2147483647) : int;
      
      function addAt(param1:uint, param2:*) : void;
      
      function removeAt(param1:uint, param2:int = 1) : *;
      
      function removeRange(param1:uint, param2:uint) : *;
      
      function retainAll(param1:Collection) : Boolean;
      
      function subList(param1:uint, param2:uint) : List;
   }
}

