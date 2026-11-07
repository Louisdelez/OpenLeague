package mx.controls.menuClasses
{
   import mx.controls.listClasses.ListData;
   import mx.core.IUIComponent;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class MenuListData extends ListData
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public var maxMeasuredBranchIconWidth:Number;
      
      public var maxMeasuredIconWidth:Number;
      
      public var useTwoColumns:Boolean;
      
      public var maxMeasuredTypeIconWidth:Number;
      
      public function MenuListData(text:String, icon:Class, labelField:String, uid:String, owner:IUIComponent, rowIndex:int = 0, columnIndex:int = 0)
      {
         super(text,icon,labelField,uid,owner,rowIndex,columnIndex);
      }
   }
}

