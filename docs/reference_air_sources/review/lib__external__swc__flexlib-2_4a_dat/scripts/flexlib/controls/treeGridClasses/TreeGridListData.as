package flexlib.controls.treeGridClasses
{
   import mx.controls.dataGridClasses.DataGridListData;
   import mx.core.IUIComponent;
   
   public class TreeGridListData extends DataGridListData
   {
      
      public var hasChildren:Boolean;
      
      public var depth:int;
      
      public var hasSibling:Boolean;
      
      public var disclosureIcon:Class;
      
      public var open:Boolean;
      
      public var item:Object;
      
      public var indentationGap:int;
      
      public var trunkOffsetBottom:Number;
      
      public var indent:int;
      
      public var trunkOffsetTop:Number;
      
      public var icon:Class;
      
      public var trunk:String;
      
      public function TreeGridListData(text:String, dataField:String, columnIndex:int, uid:String, owner:IUIComponent, rowIndex:int = 0)
      {
         super(text,dataField,columnIndex,uid,owner,rowIndex);
      }
   }
}

