package mx.olap
{
   import mx.collections.IList;
   
   public interface IOLAPSchema
   {
      
      function createCube(param1:String) : IOLAPCube;
      
      function getCube(param1:String) : IOLAPCube;
      
      function get cubes() : IList;
   }
}

