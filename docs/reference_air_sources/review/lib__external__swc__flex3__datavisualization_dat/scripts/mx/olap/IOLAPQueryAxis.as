package mx.olap
{
   public interface IOLAPQueryAxis
   {
      
      function get sets() : Array;
      
      function addMember(param1:IOLAPMember) : void;
      
      function addTuple(param1:IOLAPTuple) : void;
      
      function addSet(param1:IOLAPSet) : void;
      
      function get tuples() : Array;
   }
}

