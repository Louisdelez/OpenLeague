package mx.collections
{
   public class SummaryField
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      public var dataField:String;
      
      public var label:String;
      
      public var summaryFunction:Function;
      
      public var operation:String = "SUM";
      
      public function SummaryField(dataField:String = null, operation:String = "SUM")
      {
         super();
         this.dataField = dataField;
         this.operation = operation;
      }
   }
}

