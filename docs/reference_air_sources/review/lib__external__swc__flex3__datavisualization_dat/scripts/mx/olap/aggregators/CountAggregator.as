package mx.olap.aggregators
{
   import mx.olap.IOLAPCustomAggregator;
   
   public class CountAggregator implements IOLAPCustomAggregator
   {
      
      public function CountAggregator()
      {
         super();
      }
      
      public function computeObjectBegin(value:Object) : Object
      {
         var prop:String = null;
         var newObj:Object = {};
         for(prop in value)
         {
            newObj[prop] = value[prop];
         }
         return newObj;
      }
      
      public function computeLoop(data:Object, dataField:String, value:Object) : void
      {
         if(!data.hasOwnProperty(dataField))
         {
            data[dataField] = [value[dataField]];
            data[dataField + "Counter"] = 1;
         }
         else
         {
            data[dataField].push(value[dataField]);
            data[dataField + "Counter"] += 1;
         }
      }
      
      public function computeEnd(data:Object, dataField:String) : Number
      {
         return data[dataField + "Counter"];
      }
      
      public function computeObjectEnd(oldValue:Object, dataField:String) : Number
      {
         return oldValue[dataField + "Counter"];
      }
      
      public function computeBegin(dataField:String) : Object
      {
         var newObj:Object = {};
         newObj[dataField] = [];
         newObj[dataField + "Counter"] = 0;
         return newObj;
      }
      
      public function computeObjectLoop(oldValue:Object, newValue:Object) : void
      {
         var prop:String = null;
         for(prop in newValue)
         {
            if(oldValue[prop] is Array)
            {
               oldValue[prop] = oldValue[prop].concat(newValue[prop]);
            }
            else
            {
               oldValue[prop] += newValue[prop];
            }
         }
      }
   }
}

