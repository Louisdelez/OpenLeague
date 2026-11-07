package mx.events
{
   import flash.events.Event;
   import mx.controls.listClasses.IListItemRenderer;
   
   public class DataGridEvent extends Event
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public static const ITEM_EDIT_BEGIN:String = "itemEditBegin";
      
      public static const ITEM_EDIT_END:String = "itemEditEnd";
      
      public static const ITEM_FOCUS_IN:String = "itemFocusIn";
      
      public static const ITEM_FOCUS_OUT:String = "itemFocusOut";
      
      public static const ITEM_EDIT_BEGINNING:String = "itemEditBeginning";
      
      public static const ITEM_EDITOR_CREATE:String = "itemEditorCreate";
      
      public static const COLUMN_STRETCH:String = "columnStretch";
      
      public static const HEADER_RELEASE:String = "headerRelease";
      
      public var columnIndex:int;
      
      public var dataField:String;
      
      public var itemRenderer:IListItemRenderer;
      
      public var localX:Number;
      
      public var reason:String;
      
      public var rowIndex:int;
      
      public function DataGridEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, columnIndex:int = -1, dataField:String = null, rowIndex:int = -1, reason:String = null, itemRenderer:IListItemRenderer = null, localX:Number = NaN)
      {
         super(type,bubbles,cancelable);
         this.columnIndex = columnIndex;
         this.dataField = dataField;
         this.rowIndex = rowIndex;
         this.reason = reason;
         this.itemRenderer = itemRenderer;
         this.localX = localX;
      }
      
      override public function clone() : Event
      {
         return new DataGridEvent(type,bubbles,cancelable,this.columnIndex,this.dataField,this.rowIndex,this.reason,this.itemRenderer,this.localX);
      }
   }
}

