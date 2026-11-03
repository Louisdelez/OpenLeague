package mx.olap.aggregators
{
   import mx.olap.IOLAPCustomAggregator;
   
   public class AverageAggregator implements IOLAPCustomAggregator
   {
      
      public function AverageAggregator()
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
      
      public function computeLoop(data:Object, dataField:String, rowData:Object) : void
      {
         var value:Number = Number(rowData[dataField]);
         if("number" == "xml")
         {
            value = Number(value.toString());
         }
         if(!data.hasOwnProperty(dataField))
         {
            data[dataField] = value;
            data[dataField + "Count"] = 1;
         }
         else
         {
            data[dataField] += value;
            data[dataField + "Count"] += 1;
         }
      }
      
      public function computeEnd(data:Object, dataField:String) : Number
      {
         return data[dataField] / data[dataField + "Count"];
      }
      
      public function computeObjectEnd(oldValue:Object, dataField:String) : Number
      {
         return oldValue[dataField] / oldValue[dataField + "Count"];
      }
      
      public function computeBegin(dataField:String) : Object
      {
         var newObj:Object = {};
         newObj[dataField] = 0;
         newObj[dataField + "Count"] = 0;
         return newObj;
      }
      
      public function computeObjectLoop(oldValue:Object, newValue:Object) : void
      {
         var prop:String = null;
         for(prop in newValue)
         {
            oldValue[prop] += newValue[prop];
         }
      }
   }
}

