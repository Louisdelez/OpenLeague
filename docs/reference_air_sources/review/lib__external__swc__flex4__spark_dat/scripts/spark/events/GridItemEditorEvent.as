package spark.events
{
   import flash.events.Event;
   import spark.components.gridClasses.GridColumn;
   
   public class GridItemEditorEvent extends Event
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public static const GRID_ITEM_EDITOR_SESSION_STARTING:String = "gridItemEditorSessionStarting";
      
      public static const GRID_ITEM_EDITOR_SESSION_START:String = "gridItemEditorSessionStart";
      
      public static const GRID_ITEM_EDITOR_SESSION_SAVE:String = "gridItemEditorSessionSave";
      
      public static const GRID_ITEM_EDITOR_SESSION_CANCEL:String = "gridItemEditorSessionCancel";
      
      public var columnIndex:int;
      
      public var column:GridColumn;
      
      public var rowIndex:int;
      
      public function GridItemEditorEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, rowIndex:uint = 1, columnIndex:uint = 1, column:GridColumn = null)
      {
         super(type,bubbles,cancelable);
         this.rowIndex = rowIndex;
         this.columnIndex = columnIndex;
         this.column = column;
      }
      
      override public function clone() : Event
      {
         return new GridItemEditorEvent(type,bubbles,cancelable,this.rowIndex,this.columnIndex,this.column);
      }
   }
}

