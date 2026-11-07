package mx.olap
{
   public interface IOLAPQuery
   {
      
      function setAxis(param1:int, param2:IOLAPQueryAxis) : void;
      
      function getAxis(param1:int) : IOLAPQueryAxis;
   }
}

