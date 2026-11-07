package mx.olap
{
   import mx.collections.IList;
   
   public interface IOLAPMember extends IOLAPElement
   {
      
      function get level() : IOLAPLevel;
      
      function get hierarchy() : IOLAPHierarchy;
      
      function get isAll() : Boolean;
      
      function get parent() : IOLAPMember;
      
      function get isMeasure() : Boolean;
      
      function findChildMember(param1:String) : IOLAPMember;
      
      function get children() : IList;
   }
}

