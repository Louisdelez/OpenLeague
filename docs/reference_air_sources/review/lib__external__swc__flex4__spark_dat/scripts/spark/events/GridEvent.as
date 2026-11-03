package spark.events
{
   import flash.display.InteractiveObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import spark.components.Grid;
   import spark.components.gridClasses.GridColumn;
   import spark.components.gridClasses.IDataGridElement;
   import spark.components.gridClasses.IGridItemRenderer;
   
   public class GridEvent extends MouseEvent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public static const GRID_MOUSE_DOWN:String = "gridMouseDown";
      
      public static const GRID_MOUSE_DRAG:String = "gridMouseDrag";
      
      public static const GRID_MOUSE_UP:String = "gridMouseUp";
      
      public static const GRID_CLICK:String = "gridClick";
      
      public static const GRID_DOUBLE_CLICK:String = "gridDoubleClick";
      
      public static const GRID_ROLL_OVER:String = "gridRollOver";
      
      public static const GRID_ROLL_OUT:String = "gridRollOut";
      
      public static const SEPARATOR_MOUSE_DRAG:String = "separatorMouseDrag";
      
      public static const SEPARATOR_CLICK:String = "separatorClick";
      
      public static const SEPARATOR_DOUBLE_CLICK:String = "separatorDoubleClick";
      
      public static const SEPARATOR_MOUSE_DOWN:String = "separatorMouseDown";
      
      public static const SEPARATOR_MOUSE_UP:String = "separatorMouseUp";
      
      public static const SEPARATOR_ROLL_OUT:String = "separatorRollOut";
      
      public static const SEPARATOR_ROLL_OVER:String = "separatorRollOver";
      
      public var rowIndex:int;
      
      public var columnIndex:int;
      
      public var column:GridColumn;
      
      public var item:Object;
      
      public var itemRenderer:IGridItemRenderer;
      
      public function GridEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false, localX:Number = NaN, localY:Number = NaN, relatedObject:InteractiveObject = null, ctrlKey:Boolean = false, altKey:Boolean = false, shiftKey:Boolean = false, buttonDown:Boolean = false, delta:int = 0, rowIndex:int = -1, columnIndex:int = -1, column:GridColumn = null, item:Object = null, itemRenderer:IGridItemRenderer = null)
      {
         super(type,bubbles,cancelable,localX,localY,relatedObject,ctrlKey,altKey,shiftKey,buttonDown,delta);
         this.rowIndex = rowIndex;
         this.columnIndex = columnIndex;
         this.column = column;
         this.item = item;
         this.itemRenderer = itemRenderer;
      }
      
      public function get grid() : Grid
      {
         if(Boolean(this.column))
         {
            return this.column.grid;
         }
         if(target is Grid)
         {
            return Grid(target);
         }
         var elt:IDataGridElement = target as IDataGridElement;
         if(Boolean(elt) && Boolean(elt.dataGrid))
         {
            return elt.dataGrid.grid;
         }
         return null;
      }
      
      override public function clone() : Event
      {
         var cloneEvent:GridEvent = new GridEvent(type,bubbles,cancelable,localX,localY,relatedObject,ctrlKey,altKey,shiftKey,buttonDown,delta,this.rowIndex,this.columnIndex,this.column,this.item,this.itemRenderer);
         cloneEvent.relatedObject = this.relatedObject;
         return cloneEvent;
      }
      
      override public function toString() : String
      {
         return "GridEvent{" + "type=\"" + type + "\"" + " localX,Y=" + localX + "," + localY + " rowIndex,columnIndex=" + this.rowIndex + "," + this.columnIndex + "}";
      }
   }
}

