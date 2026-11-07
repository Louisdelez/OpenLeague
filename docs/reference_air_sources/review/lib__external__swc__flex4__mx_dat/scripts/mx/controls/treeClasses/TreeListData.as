package mx.controls.treeClasses
{
   import mx.controls.listClasses.BaseListData;
   import mx.controls.listClasses.ListBase;
   
   public class TreeListData extends BaseListData
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      [Bindable("__NoChangeEvent__")]
      public var depth:int;
      
      [Bindable("__NoChangeEvent__")]
      public var disclosureIcon:Class;
      
      [Bindable("__NoChangeEvent__")]
      public var hasChildren:Boolean;
      
      [Bindable("__NoChangeEvent__")]
      public var icon:Class;
      
      [Bindable("__NoChangeEvent__")]
      public var indent:int;
      
      [Bindable("__NoChangeEvent__")]
      public var item:Object;
      
      [Bindable("__NoChangeEvent__")]
      public var open:Boolean;
      
      public function TreeListData(text:String, uid:String, owner:ListBase, rowIndex:int = 0, columnIndex:int = 0)
      {
         super(text,uid,owner,rowIndex,columnIndex);
      }
   }
}

