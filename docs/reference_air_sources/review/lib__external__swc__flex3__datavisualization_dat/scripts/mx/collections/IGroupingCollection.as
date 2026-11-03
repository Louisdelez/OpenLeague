package mx.collections
{
   public interface IGroupingCollection extends IHierarchicalData
   {
      
      function cancelRefresh() : void;
      
      function refresh(param1:Boolean = false) : Boolean;
      
      function get grouping() : Grouping;
      
      function set grouping(param1:Grouping) : void;
   }
}

