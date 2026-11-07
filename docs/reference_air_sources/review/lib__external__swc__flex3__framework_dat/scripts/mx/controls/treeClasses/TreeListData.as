package mx.controls.treeClasses
{
   import mx.controls.listClasses.BaseListData;
   import mx.controls.listClasses.ListBase;
   import mx.core.mx_internal;
   
   use namespace mx_internal;
   
   public class TreeListData extends BaseListData
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      public var hasChildren:Boolean;
      
      public var depth:int;
      
      public var disclosureIcon:Class;
      
      public var open:Boolean;
      
      public var indent:int;
      
      public var item:Object;
      
      public var icon:Class;
      
      public function TreeListData(text:String, uid:String, owner:ListBase, rowIndex:int = 0, columnIndex:int = 0)
      {
         super(text,uid,owner,rowIndex,columnIndex);
      }
   }
}

