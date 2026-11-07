package mx.olap
{
   public interface IOLAPCustomAggregator
   {
      
      function computeBegin(param1:String) : Object;
      
      function computeObjectBegin(param1:Object) : Object;
      
      function computeEnd(param1:Object, param2:String) : Number;
      
      function computeObjectEnd(param1:Object, param2:String) : Number;
      
      function computeObjectLoop(param1:Object, param2:Object) : void;
      
      function computeLoop(param1:Object, param2:String, param3:Object) : void;
   }
}

