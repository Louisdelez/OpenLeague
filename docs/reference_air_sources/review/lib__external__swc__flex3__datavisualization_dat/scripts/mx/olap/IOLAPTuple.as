package mx.olap
{
   import mx.collections.IList;
   
   public interface IOLAPTuple
   {
      
      function addMembers(param1:IList) : void;
      
      function addMember(param1:IOLAPElement) : void;
      
      function get explicitMembers() : IList;
   }
}

