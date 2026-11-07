package mx.olap
{
   public interface IOLAPResult
   {
      
      function get query() : IOLAPQuery;
      
      function getCell(param1:int, param2:int) : IOLAPCell;
      
      function get axes() : Array;
      
      function getAxis(param1:int) : IOLAPResultAxis;
   }
}

