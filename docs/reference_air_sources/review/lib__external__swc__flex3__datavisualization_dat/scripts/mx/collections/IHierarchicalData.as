package mx.collections
{
   import flash.events.IEventDispatcher;
   
   public interface IHierarchicalData extends IEventDispatcher
   {
      
      function getData(param1:Object) : Object;
      
      function getChildren(param1:Object) : Object;
      
      function canHaveChildren(param1:Object) : Boolean;
      
      function getRoot() : Object;
      
      function hasChildren(param1:Object) : Boolean;
   }
}

