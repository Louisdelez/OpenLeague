package mx.olap
{
   import mx.collections.IList;
   
   public interface IOLAPSet
   {
      
      function hierarchize(param1:Boolean = false) : IOLAPSet;
      
      function addTuple(param1:IOLAPTuple) : void;
      
      function addElements(param1:IList) : void;
      
      function crossJoin(param1:IOLAPSet) : IOLAPSet;
      
      function addElement(param1:IOLAPElement) : void;
      
      function union(param1:IOLAPSet) : IOLAPSet;
   }
}

