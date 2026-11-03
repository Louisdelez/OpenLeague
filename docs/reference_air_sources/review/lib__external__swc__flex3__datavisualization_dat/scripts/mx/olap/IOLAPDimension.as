package mx.olap
{
   import mx.collections.IList;
   
   public interface IOLAPDimension extends IOLAPElement
   {
      
      function findMember(param1:String) : IOLAPMember;
      
      function findAttribute(param1:String) : IOLAPAttribute;
      
      function get isMeasure() : Boolean;
      
      function get cube() : IOLAPCube;
      
      function get attributes() : IList;
      
      function get members() : IList;
      
      function get hierarchies() : IList;
      
      function get defaultMember() : IOLAPMember;
      
      function findHierarchy(param1:String) : IOLAPHierarchy;
   }
}

