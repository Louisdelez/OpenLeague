package mx.controls.advancedDataGridClasses
{
   public class SortInfo
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      public static const PROPOSEDSORT:String = "proposedSort";
      
      public static const ACTUALSORT:String = "actualSort";
      
      public var status:String;
      
      public var descending:Boolean;
      
      public var sequenceNumber:int;
      
      public function SortInfo(sequenceNumber:int = -1, descending:Boolean = false, status:String = "actualSort")
      {
         super();
         this.sequenceNumber = sequenceNumber;
         this.descending = descending;
         this.status = status;
      }
   }
}

