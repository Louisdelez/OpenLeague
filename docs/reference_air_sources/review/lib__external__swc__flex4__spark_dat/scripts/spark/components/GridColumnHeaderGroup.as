package spark.components
{
   import flash.display.InteractiveObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.collections.IList;
   import mx.core.IFactory;
   import mx.events.PropertyChangeEvent;
   import spark.components.gridClasses.GridColumn;
   import spark.components.gridClasses.GridColumnHeaderGroupLayout;
   import spark.components.gridClasses.IDataGridElement;
   import spark.components.gridClasses.IGridItemRenderer;
   import spark.events.GridEvent;
   import spark.utils.MouseEventUtil;
   
   [IconFile("GridColumnHeaderGroup.png")]
   [Style(name="paddingTop",type="Number",format="Length",inherit="no")]
   [Style(name="paddingRight",type="Number",format="Length",inherit="no")]
   [Style(name="paddingLeft",type="Number",format="Length",inherit="no")]
   [Style(name="paddingBottom",type="Number",format="Length",inherit="no")]
   [Style(name="separatorAffordance",type="Number",format="Length",inherit="no")]
   [Event(name="separatorDoubleClick",type="spark.events.GridEvent")]
   [Event(name="separatorClick",type="spark.events.GridEvent")]
   [Event(name="separatorRollOut",type="spark.events.GridEvent")]
   [Event(name="separatorRollOver",type="spark.events.GridEvent")]
   [Event(name="separatorMouseUp",type="spark.events.GridEvent")]
   [Event(name="separatorMouseDrag",type="spark.events.GridEvent")]
   [Event(name="gridDoubleClick",type="spark.events.GridEvent")]
   [Event(name="gridClick",type="spark.events.GridEvent")]
   [Event(name="gridRollOut",type="spark.events.GridEvent")]
   [Event(name="gridRollOver",type="spark.events.GridEvent")]
   [Event(name="gridMouseUp",type="spark.events.GridEvent")]
   [Event(name="gridMouseDrag",type="spark.events.GridEvent")]
   [Event(name="gridMouseDown",type="spark.events.GridEvent")]
   public class GridColumnHeaderGroup extends Group implements IDataGridElement
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var _columnSeparator:IFactory = null;
      
      private var _dataGrid:DataGrid = null;
      
      private var _downColumnIndex:int = -1;
      
      private var _headerRenderer:IFactory = null;
      
      private var _hoverColumnIndex:int = -1;
      
      private var _visibleSortIndicatorIndices:Vector.<int> = new Vector.<int>();
      
      private var rollColumnIndex:int = -1;
      
      private var rollSeparatorIndex:int = -1;
      
      private var pressColumnIndex:int = -1;
      
      private var pressSeparatorIndex:int = -1;
      
      public function GridColumnHeaderGroup()
      {
         super();
         layout = new GridColumnHeaderGroupLayout();
         layout.clipAndEnableScrolling = true;
         MouseEventUtil.addDownDragUpListeners(this,this.gchg_mouseDownDragUpHandler,this.gchg_mouseDownDragUpHandler,this.gchg_mouseDownDragUpHandler);
         addEventListener(MouseEvent.MOUSE_MOVE,this.gchg_mouseMoveHandler);
         addEventListener(MouseEvent.ROLL_OUT,this.gchg_mouseRollOutHandler);
         addEventListener(MouseEvent.CLICK,this.gchg_clickHandler);
         addEventListener(MouseEvent.DOUBLE_CLICK,this.gchg_doubleClickHandler);
      }
      
      private function dispatchChangeEvent(type:String) : void
      {
         if(hasEventListener(type))
         {
            dispatchEvent(new Event(type));
         }
      }
      
      [Bindable("columnSeparatorChanged")]
      public function get columnSeparator() : IFactory
      {
         return this._columnSeparator;
      }
      
      public function set columnSeparator(value:IFactory) : void
      {
         if(this._columnSeparator == value)
         {
            return;
         }
         this._columnSeparator = value;
         invalidateDisplayList();
         this.dispatchChangeEvent("columnSeparatorChanged");
      }
      
      [Bindable("dataGridChanged")]
      public function get dataGrid() : DataGrid
      {
         return this._dataGrid;
      }
      
      public function set dataGrid(value:DataGrid) : void
      {
         if(this._dataGrid == value)
         {
            return;
         }
         if(Boolean(this._dataGrid) && Boolean(this._dataGrid.grid))
         {
            this._dataGrid.grid.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.grid_changeEventHandler);
         }
         this._dataGrid = value;
         if(Boolean(this._dataGrid) && Boolean(this._dataGrid.grid))
         {
            this._dataGrid.grid.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.grid_changeEventHandler);
         }
         layout.clearVirtualLayoutCache();
         invalidateSize();
         invalidateDisplayList();
         this.dispatchChangeEvent("dataGridChanged");
      }
      
      private function grid_changeEventHandler(event:PropertyChangeEvent) : void
      {
         if(event.property == "horizontalScrollPosition")
         {
            horizontalScrollPosition = Number(event.newValue);
         }
      }
      
      [Bindable("downColumnIndexChanged")]
      public function get downColumnIndex() : int
      {
         return this._downColumnIndex;
      }
      
      public function set downColumnIndex(value:int) : void
      {
         if(this._downColumnIndex == value)
         {
            return;
         }
         this._downColumnIndex = value;
         invalidateDisplayList();
         this.dispatchChangeEvent("downColumnIndexChanged");
      }
      
      [Bindable("headerRendererChanged")]
      public function get headerRenderer() : IFactory
      {
         return this._headerRenderer;
      }
      
      public function set headerRenderer(value:IFactory) : void
      {
         if(value == this._headerRenderer)
         {
            return;
         }
         this._headerRenderer = value;
         layout.clearVirtualLayoutCache();
         invalidateSize();
         invalidateDisplayList();
         this.dispatchChangeEvent("headerRendererChanged");
      }
      
      [Bindable("hoverColumnIndexChanged")]
      public function get hoverColumnIndex() : int
      {
         return this._hoverColumnIndex;
      }
      
      public function set hoverColumnIndex(value:int) : void
      {
         if(this._hoverColumnIndex == value)
         {
            return;
         }
         this._hoverColumnIndex = value;
         invalidateDisplayList();
         this.dispatchChangeEvent("hoverColumnIndexChanged");
      }
      
      [Bindable("visibleSortIndicatorIndicesChanged")]
      public function get visibleSortIndicatorIndices() : Vector.<int>
      {
         return this._visibleSortIndicatorIndices.concat();
      }
      
      public function set visibleSortIndicatorIndices(value:Vector.<int>) : void
      {
         var valueCopy:Vector.<int> = Boolean(value) ? value.concat() : new Vector.<int>();
         this._visibleSortIndicatorIndices = valueCopy;
         invalidateDisplayList();
         this.dispatchChangeEvent("visibleSortIndicatorIndicesChanged");
      }
      
      public function isSortIndicatorVisible(columnIndex:int) : Boolean
      {
         return this._visibleSortIndicatorIndices.indexOf(columnIndex) != -1;
      }
      
      public function getHeaderIndexAt(x:Number, y:Number) : int
      {
         return GridColumnHeaderGroupLayout(layout).getHeaderIndexAt(x,y);
      }
      
      public function getSeparatorIndexAt(x:Number, y:Number) : int
      {
         return GridColumnHeaderGroupLayout(layout).getSeparatorIndexAt(x,y);
      }
      
      public function getHeaderRendererAt(columnIndex:int) : IGridItemRenderer
      {
         return GridColumnHeaderGroupLayout(layout).getHeaderRendererAt(columnIndex);
      }
      
      public function getHeaderBounds(columnIndex:int) : Rectangle
      {
         return GridColumnHeaderGroupLayout(layout).getHeaderBounds(columnIndex);
      }
      
      protected function gchg_mouseDownDragUpHandler(event:MouseEvent) : void
      {
         var eventStageXY:Point = null;
         var eventHeaderGroupXY:Point = null;
         var eventSeparatorIndex:int = 0;
         var gridEventType:String = null;
         eventStageXY = new Point(event.stageX,event.stageY);
         eventHeaderGroupXY = globalToLocal(eventStageXY);
         eventSeparatorIndex = this.getSeparatorIndexAt(eventHeaderGroupXY.x,0);
         var eventColumnIndex:int = eventSeparatorIndex == -1 ? this.getHeaderIndexAt(eventHeaderGroupXY.x,0) : -1;
         switch(event.type)
         {
            case MouseEvent.MOUSE_MOVE:
               gridEventType = this.pressSeparatorIndex != -1 ? GridEvent.SEPARATOR_MOUSE_DRAG : GridEvent.GRID_MOUSE_DRAG;
               break;
            case MouseEvent.MOUSE_UP:
               gridEventType = this.pressSeparatorIndex != -1 ? GridEvent.SEPARATOR_MOUSE_UP : GridEvent.GRID_MOUSE_UP;
               this.downColumnIndex = -1;
               break;
            case MouseEvent.MOUSE_DOWN:
               if(eventSeparatorIndex != -1)
               {
                  gridEventType = GridEvent.SEPARATOR_MOUSE_DOWN;
                  this.pressSeparatorIndex = eventSeparatorIndex;
                  this.pressColumnIndex = -1;
                  this.downColumnIndex = -1;
               }
               else
               {
                  gridEventType = GridEvent.GRID_MOUSE_DOWN;
                  this.pressSeparatorIndex = -1;
                  this.pressColumnIndex = eventColumnIndex;
                  this.downColumnIndex = eventColumnIndex;
               }
         }
         var columnIndex:int = eventSeparatorIndex != -1 ? eventSeparatorIndex : eventColumnIndex;
         this.dispatchGridEvent(event,gridEventType,eventHeaderGroupXY,columnIndex);
      }
      
      protected function gchg_mouseMoveHandler(event:MouseEvent) : void
      {
         var eventStageXY:Point = null;
         var eventHeaderGroupXY:Point = null;
         var eventSeparatorIndex:int = 0;
         eventStageXY = new Point(event.stageX,event.stageY);
         eventHeaderGroupXY = globalToLocal(eventStageXY);
         eventSeparatorIndex = this.getSeparatorIndexAt(eventHeaderGroupXY.x,0);
         var eventColumnIndex:int = eventSeparatorIndex == -1 ? this.getHeaderIndexAt(eventHeaderGroupXY.x,0) : -1;
         if(eventSeparatorIndex != this.rollSeparatorIndex)
         {
            if(this.rollSeparatorIndex != -1)
            {
               this.dispatchGridEvent(event,GridEvent.SEPARATOR_ROLL_OUT,eventHeaderGroupXY,this.rollSeparatorIndex);
            }
            if(eventSeparatorIndex != -1)
            {
               this.dispatchGridEvent(event,GridEvent.SEPARATOR_ROLL_OVER,eventHeaderGroupXY,eventSeparatorIndex);
            }
         }
         if(eventColumnIndex != this.rollColumnIndex)
         {
            if(this.rollColumnIndex != -1)
            {
               this.dispatchGridEvent(event,GridEvent.GRID_ROLL_OUT,eventHeaderGroupXY,this.rollColumnIndex);
            }
            if(eventColumnIndex != -1)
            {
               this.dispatchGridEvent(event,GridEvent.GRID_ROLL_OVER,eventHeaderGroupXY,eventColumnIndex);
            }
         }
         this.rollColumnIndex = eventColumnIndex;
         this.rollSeparatorIndex = eventSeparatorIndex;
         this.hoverColumnIndex = eventColumnIndex;
      }
      
      protected function gchg_mouseRollOutHandler(event:MouseEvent) : void
      {
         var eventStageXY:Point = null;
         eventStageXY = new Point(event.stageX,event.stageY);
         var eventHeaderGroupXY:Point = globalToLocal(eventStageXY);
         if(this.rollSeparatorIndex != -1)
         {
            this.dispatchGridEvent(event,GridEvent.SEPARATOR_ROLL_OUT,eventHeaderGroupXY,this.rollSeparatorIndex);
         }
         else if(this.rollColumnIndex != -1)
         {
            this.dispatchGridEvent(event,GridEvent.GRID_ROLL_OUT,eventHeaderGroupXY,this.rollColumnIndex);
         }
         this.rollColumnIndex = -1;
         this.rollSeparatorIndex = -1;
         this.hoverColumnIndex = -1;
      }
      
      protected function gchg_clickHandler(event:MouseEvent) : void
      {
         var eventStageXY:Point = null;
         var eventHeaderGroupXY:Point = null;
         var eventSeparatorIndex:int = 0;
         eventStageXY = new Point(event.stageX,event.stageY);
         eventHeaderGroupXY = globalToLocal(eventStageXY);
         eventSeparatorIndex = this.getSeparatorIndexAt(eventHeaderGroupXY.x,0);
         var eventColumnIndex:int = eventSeparatorIndex == -1 ? this.getHeaderIndexAt(eventHeaderGroupXY.x,0) : -1;
         if(eventSeparatorIndex != -1 && this.pressSeparatorIndex == eventSeparatorIndex)
         {
            this.dispatchGridEvent(event,GridEvent.SEPARATOR_CLICK,eventHeaderGroupXY,eventSeparatorIndex);
         }
         else if(eventColumnIndex != -1 && this.pressColumnIndex == eventColumnIndex)
         {
            this.dispatchGridEvent(event,GridEvent.GRID_CLICK,eventHeaderGroupXY,eventColumnIndex);
         }
      }
      
      protected function gchg_doubleClickHandler(event:MouseEvent) : void
      {
         var eventStageXY:Point = null;
         var eventHeaderGroupXY:Point = null;
         var eventSeparatorIndex:int = 0;
         eventStageXY = new Point(event.stageX,event.stageY);
         eventHeaderGroupXY = globalToLocal(eventStageXY);
         eventSeparatorIndex = this.getSeparatorIndexAt(eventHeaderGroupXY.x,0);
         var eventColumnIndex:int = eventSeparatorIndex == -1 ? this.getHeaderIndexAt(eventHeaderGroupXY.x,0) : -1;
         if(eventSeparatorIndex != -1 && this.pressSeparatorIndex == eventSeparatorIndex)
         {
            this.dispatchGridEvent(event,GridEvent.SEPARATOR_DOUBLE_CLICK,eventHeaderGroupXY,eventSeparatorIndex);
         }
         else if(eventColumnIndex != -1 && this.pressColumnIndex == eventColumnIndex)
         {
            this.dispatchGridEvent(event,GridEvent.GRID_DOUBLE_CLICK,eventHeaderGroupXY,eventColumnIndex);
         }
      }
      
      private function dispatchGridEvent(mouseEvent:MouseEvent, type:String, headerGroupXY:Point, columnIndex:int) : void
      {
         var column:GridColumn = null;
         var item:Object = null;
         var itemRenderer:IGridItemRenderer = null;
         var bubbles:Boolean = false;
         var cancelable:Boolean = false;
         var relatedObject:InteractiveObject = null;
         var ctrlKey:Boolean = false;
         var altKey:Boolean = false;
         var shiftKey:Boolean = false;
         var buttonDown:Boolean = false;
         var delta:int = 0;
         column = this.getColumnAt(columnIndex);
         item = null;
         itemRenderer = this.getHeaderRendererAt(columnIndex);
         bubbles = mouseEvent.bubbles;
         cancelable = mouseEvent.cancelable;
         relatedObject = mouseEvent.relatedObject;
         ctrlKey = mouseEvent.ctrlKey;
         altKey = mouseEvent.altKey;
         shiftKey = mouseEvent.shiftKey;
         buttonDown = mouseEvent.buttonDown;
         delta = mouseEvent.delta;
         var event:GridEvent = new GridEvent(type,bubbles,cancelable,headerGroupXY.x,headerGroupXY.y,relatedObject,ctrlKey,altKey,shiftKey,buttonDown,delta,-1,columnIndex,column,item,itemRenderer);
         dispatchEvent(event);
      }
      
      private function getColumnAt(columnIndex:int) : GridColumn
      {
         var grid:Grid = Boolean(this.dataGrid) ? this.dataGrid.grid : null;
         if(!grid || !grid.columns)
         {
            return null;
         }
         var columns:IList = grid.columns;
         return columnIndex >= 0 && columnIndex < columns.length ? columns.getItemAt(columnIndex) as GridColumn : null;
      }
   }
}

