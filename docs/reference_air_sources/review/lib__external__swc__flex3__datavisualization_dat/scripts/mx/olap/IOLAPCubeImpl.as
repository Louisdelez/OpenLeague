package mx.olap
{
   public interface IOLAPCubeImpl
   {
      
      function cancelRefresh() : void;
      
      function get queryTotal() : int;
      
      function get queryProgress() : int;
      
      function buildCubeIteratively() : Boolean;
      
      function set cube(param1:IOLAPCube) : void;
      
      function refresh() : void;
      
      function execute(param1:IOLAPQuery, param2:OLAPResult) : Boolean;
      
      function cancelQuery(param1:IOLAPQuery) : void;
   }
}

