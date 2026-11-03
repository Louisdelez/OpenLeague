package mx.olap
{
   import mx.collections.IList;
   import mx.rpc.AsyncToken;
   
   public interface IOLAPCube
   {
      
      function cancelRefresh() : void;
      
      function refresh() : void;
      
      function findDimension(param1:String) : IOLAPDimension;
      
      function execute(param1:IOLAPQuery) : AsyncToken;
      
      function get name() : String;
      
      function get dimensions() : IList;
      
      function cancelQuery(param1:IOLAPQuery) : void;
   }
}

