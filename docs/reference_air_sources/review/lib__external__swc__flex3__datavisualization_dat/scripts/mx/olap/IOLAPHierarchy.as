package mx.olap
{
   import mx.collections.IList;
   
   public interface IOLAPHierarchy extends IOLAPElement
   {
      
      function get defaultMember() : IOLAPMember;
      
      function findMember(param1:String) : IOLAPMember;
      
      function get allMemberName() : String;
      
      function get hasAll() : Boolean;
      
      function get members() : IList;
      
      function findLevel(param1:String) : IOLAPLevel;
      
      function get levels() : IList;
      
      function get children() : IList;
   }
}

