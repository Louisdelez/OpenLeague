package mx.olap
{
   import mx.collections.IList;
   
   public interface IOLAPLevel extends IOLAPElement
   {
      
      function get depth() : int;
      
      function findMember(param1:String) : IList;
      
      function get hierarchy() : IOLAPHierarchy;
      
      function get members() : IList;
      
      function get parent() : IOLAPLevel;
      
      function get child() : IOLAPLevel;
   }
}

