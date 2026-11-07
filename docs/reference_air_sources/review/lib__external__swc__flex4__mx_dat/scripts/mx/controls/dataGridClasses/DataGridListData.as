package mx.controls.dataGridClasses
{
   import mx.controls.listClasses.BaseListData;
   import mx.core.IUIComponent;
   
   public class DataGridListData extends BaseListData
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      [Bindable("__NoChangeEvent__")]
      public var dataField:String;
      
      public function DataGridListData(text:String, dataField:String, columnIndex:int, uid:String, owner:IUIComponent, rowIndex:int = 0)
      {
         super(text,uid,owner,rowIndex,columnIndex);
         this.dataField = dataField;
      }
   }
}

