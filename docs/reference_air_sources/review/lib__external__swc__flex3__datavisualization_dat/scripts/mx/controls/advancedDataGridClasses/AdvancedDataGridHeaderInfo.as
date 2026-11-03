package mx.controls.advancedDataGridClasses
{
   import mx.controls.listClasses.IListItemRenderer;
   
   public class AdvancedDataGridHeaderInfo
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      public var headerItem:IListItemRenderer;
      
      public var depth:int;
      
      public var parent:AdvancedDataGridHeaderInfo;
      
      public var visibleIndex:int;
      
      public var internalLabelFunction:Function;
      
      public var visibleChildren:Array;
      
      public var index:int;
      
      public var column:AdvancedDataGridColumn;
      
      public var columnSpan:int;
      
      public var visible:Boolean;
      
      public var actualColNum:int;
      
      public var children:Array;
      
      public function AdvancedDataGridHeaderInfo(column:AdvancedDataGridColumn, parent:AdvancedDataGridHeaderInfo, index:int, depth:int, children:Array = null, internalLabelFunction:Function = null, headerItem:IListItemRenderer = null)
      {
         super();
         this.column = column;
         this.parent = parent;
         this.index = index;
         this.depth = depth;
         this.children = children;
         this.internalLabelFunction = internalLabelFunction;
         this.headerItem = headerItem;
      }
   }
}

