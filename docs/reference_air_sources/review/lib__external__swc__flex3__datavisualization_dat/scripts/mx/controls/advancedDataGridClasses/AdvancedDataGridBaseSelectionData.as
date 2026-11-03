package mx.controls.advancedDataGridClasses
{
   public class AdvancedDataGridBaseSelectionData
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var prevSelectionData:AdvancedDataGridBaseSelectionData;
      
      public var data:Object;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var nextSelectionData:AdvancedDataGridBaseSelectionData;
      
      public var approximate:Boolean;
      
      public var rowIndex:int;
      
      public var columnIndex:int;
      
      public function AdvancedDataGridBaseSelectionData(data:Object, rowIndex:int, columnIndex:int, approximate:Boolean)
      {
         super();
         this.data = data;
         this.rowIndex = rowIndex;
         this.columnIndex = columnIndex;
         this.approximate = approximate;
      }
   }
}

