package mx.controls.menuClasses
{
   import mx.controls.listClasses.ListData;
   import mx.core.IUIComponent;
   
   public class MenuListData extends ListData
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public var maxMeasuredIconWidth:Number;
      
      public var maxMeasuredTypeIconWidth:Number;
      
      public var maxMeasuredBranchIconWidth:Number;
      
      public var useTwoColumns:Boolean;
      
      public function MenuListData(text:String, icon:Class, labelField:String, uid:String, owner:IUIComponent, rowIndex:int = 0, columnIndex:int = 0)
      {
         super(text,icon,labelField,uid,owner,rowIndex,columnIndex);
      }
   }
}

