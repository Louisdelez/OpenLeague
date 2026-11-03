package mx.olap
{
   import mx.collections.IList;
   
   public interface IOLAPAttributeLevel extends IOLAPLevel
   {
      
      function get children() : IList;
   }
}

