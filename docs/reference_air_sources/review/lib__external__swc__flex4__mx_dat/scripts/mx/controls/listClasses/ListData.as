package mx.controls.listClasses
{
   import mx.core.IUIComponent;
   
   public class ListData extends BaseListData
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      [Bindable("__NoChangeEvent__")]
      public var icon:Class;
      
      [Bindable("__NoChangeEvent__")]
      public var labelField:String;
      
      public function ListData(text:String, icon:Class, labelField:String, uid:String, owner:IUIComponent, rowIndex:int = 0, columnIndex:int = 0)
      {
         super(text,uid,owner,rowIndex,columnIndex);
         this.icon = icon;
         this.labelField = labelField;
      }
   }
}

