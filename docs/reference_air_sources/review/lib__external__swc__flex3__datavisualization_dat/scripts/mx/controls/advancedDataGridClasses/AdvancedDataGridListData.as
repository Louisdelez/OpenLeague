package mx.controls.advancedDataGridClasses
{
   import mx.controls.dataGridClasses.DataGridListData;
   import mx.core.IUIComponent;
   
   public class AdvancedDataGridListData extends DataGridListData
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      public var hasChildren:Boolean;
      
      public var depth:int;
      
      public var disclosureIcon:Class;
      
      public var open:Boolean;
      
      public var indent:int;
      
      public var item:Object;
      
      public var icon:Class;
      
      public function AdvancedDataGridListData(text:String, dataField:String, columnIndex:int, uid:String, owner:IUIComponent, rowIndex:int = 0)
      {
         super(text,dataField,columnIndex,uid,owner,rowIndex);
      }
   }
}

