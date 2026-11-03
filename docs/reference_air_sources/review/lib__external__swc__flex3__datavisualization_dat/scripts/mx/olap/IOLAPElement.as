package mx.olap
{
   public interface IOLAPElement
   {
      
      function get name() : String;
      
      function get uniqueName() : String;
      
      function get displayName() : String;
      
      function get dimension() : IOLAPDimension;
   }
}

