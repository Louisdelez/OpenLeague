package spark.components.gridClasses
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.InteractiveObject;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.IEventDispatcher;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.events.TimerEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.ui.Keyboard;
   import flash.utils.Timer;
   import mx.core.ClassFactory;
   import mx.core.EventPriority;
   import mx.core.IFactory;
   import mx.core.IIMESupport;
   import mx.core.IInvalidating;
   import mx.core.IUIComponent;
   import mx.core.IVisualElement;
   import mx.events.FlexEvent;
   import mx.events.SandboxMouseEvent;
   import mx.managers.FocusManager;
   import mx.managers.IFocusManager;
   import mx.managers.IFocusManagerComponent;
   import mx.styles.ISimpleStyleClient;
   import spark.components.DataGrid;
   import spark.components.Grid;
   import spark.events.GridEvent;
   import spark.events.GridItemEditorEvent;
   
   [ExcludeClass]
   public class DataGridEditor
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var doubleClickTimer:Timer;
      
      private var gotDoubleClickEvent:Boolean;
      
      private var gotFlexEnterEvent:Boolean;
      
      private var lastEvent:Event;
      
      private var lastItemClickedPosition:Object;
      
      private var lastItemDown:IVisualElement;
      
      private var lastEditedItemPosition:*;
      
      private var restoreFocusableChildren:Boolean = true;
      
      private var saveDataGridHasFocusableChildren:Boolean;
      
      private var saveScrollerHasFocusableChildren:Boolean;
      
      private var _dataGrid:DataGrid;
      
      private var _editedItemPosition:Object;
      
      private var inEndEdit:Boolean = false;
      
      public var itemEditorInstance:IGridItemEditor;
      
      private var _editedItemRenderer:IVisualElement;
      
      public function DataGridEditor(dataGrid:DataGrid)
      {
         super();
         this._dataGrid = dataGrid;
      }
      
      public function get dataGrid() : DataGrid
      {
         return this._dataGrid;
      }
      
      public function get grid() : Grid
      {
         return this._dataGrid.grid;
      }
      
      public function get editedItemPosition() : Object
      {
         if(Boolean(this._editedItemPosition))
         {
            return {
               "rowIndex":this._editedItemPosition.rowIndex,
               "columnIndex":this._editedItemPosition.columnIndex
            };
         }
         return this._editedItemPosition;
      }
      
      public function set editedItemPosition(value:Object) : void
      {
         if(!value)
         {
            this.setEditedItemPosition(null);
            return;
         }
         var newValue:Object = {
            "rowIndex":value.rowIndex,
            "columnIndex":value.columnIndex
         };
         this.setEditedItemPosition(newValue);
      }
      
      private function setEditedItemPosition(coord:Object) : void
      {
         if(!this.grid.enabled || !this.dataGrid.editable)
         {
            return;
         }
         if(!this.grid.dataProvider || this.grid.dataProvider.length == 0)
         {
            return;
         }
         if(Boolean(this.itemEditorInstance && coord && this.itemEditorInstance is IFocusManagerComponent) && Boolean(this._editedItemPosition.rowIndex == coord.rowIndex) && this._editedItemPosition.columnIndex == coord.columnIndex)
         {
            IFocusManagerComponent(this.itemEditorInstance).setFocus();
            return;
         }
         if(Boolean(this.itemEditorInstance))
         {
            if(!this.dataGrid.endItemEditorSession())
            {
               return;
            }
         }
         this._editedItemPosition = coord;
         if(!coord)
         {
            return;
         }
         var rowIndex:int = int(coord.rowIndex);
         var columnIndex:int = int(coord.columnIndex);
         this.dataGrid.ensureCellIsVisible(rowIndex,columnIndex);
         this.createItemEditor(rowIndex,columnIndex);
         if(this.itemEditorInstance is IInvalidating)
         {
            IInvalidating(this.itemEditorInstance).validateNow();
         }
         var column:GridColumn = this.dataGrid.columns.getItemAt(columnIndex) as GridColumn;
         if(this.itemEditorInstance is IIMESupport)
         {
            IIMESupport(this.itemEditorInstance).imeMode = column.imeMode == null ? this.dataGrid.imeMode : column.imeMode;
         }
         var fm:IFocusManager = this.grid.focusManager;
         if(this.itemEditorInstance is IFocusManagerComponent)
         {
            this.itemEditorInstance.removeEventListener(FocusEvent.FOCUS_OUT,this.editor_focusOutHandler);
            fm.setFocus(IFocusManagerComponent(this.itemEditorInstance));
            this.itemEditorInstance.addEventListener(FocusEvent.FOCUS_OUT,this.editor_focusOutHandler);
         }
         this.lastEditedItemPosition = this._editedItemPosition;
         var dataGridEvent:GridItemEditorEvent = null;
         if(column.rendererIsEditable == false)
         {
            dataGridEvent = new GridItemEditorEvent(GridItemEditorEvent.GRID_ITEM_EDITOR_SESSION_START);
         }
         if(Boolean(dataGridEvent))
         {
            dataGridEvent.columnIndex = this.editedItemPosition.columnIndex;
            dataGridEvent.column = column;
            dataGridEvent.rowIndex = this.editedItemPosition.rowIndex;
            this.dataGrid.dispatchEvent(dataGridEvent);
         }
      }
      
      public function get editedItemRenderer() : IVisualElement
      {
         return this._editedItemRenderer;
      }
      
      public function get editorColumnIndex() : int
      {
         if(Boolean(this.editedItemPosition))
         {
            return this.editedItemPosition.columnIndex;
         }
         return -1;
      }
      
      public function get editorRowIndex() : int
      {
         if(Boolean(this.editedItemPosition))
         {
            return this.editedItemPosition.rowIndex;
         }
         return -1;
      }
      
      public function initialize() : void
      {
         var grid:Grid = this.dataGrid.grid;
         this.dataGrid.addEventListener(KeyboardEvent.KEY_DOWN,this.dataGrid_keyboardDownHandler);
         grid.addEventListener(GridEvent.GRID_MOUSE_DOWN,this.grid_gridMouseDownHandler,false,1000);
         grid.addEventListener(GridEvent.GRID_MOUSE_UP,this.grid_gridMouseUpHandler,false,1000);
         grid.addEventListener(GridEvent.GRID_DOUBLE_CLICK,this.grid_gridDoubleClickHandler);
      }
      
      public function uninitialize() : void
      {
         this.grid.removeEventListener(KeyboardEvent.KEY_DOWN,this.dataGrid_keyboardDownHandler);
         this.grid.removeEventListener(GridEvent.GRID_MOUSE_DOWN,this.grid_gridMouseDownHandler);
         this.grid.removeEventListener(GridEvent.GRID_MOUSE_UP,this.grid_gridMouseUpHandler);
         this.grid.removeEventListener(GridEvent.GRID_DOUBLE_CLICK,this.grid_gridDoubleClickHandler);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function destroyItemEditor() : void
      {
         var o:IVisualElement = null;
         if(Boolean(this.grid.root))
         {
            this.grid.systemManager.addEventListener(Event.DEACTIVATE,this.deactivateHandler,false,0,true);
         }
         this.grid.systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_DOWN,this.sandBoxRoot_mouseDownHandler,true);
         this.grid.systemManager.getSandboxRoot().removeEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE,this.sandBoxRoot_mouseDownHandler);
         this.grid.systemManager.removeEventListener(Event.RESIZE,this.editorAncestorResizeHandler);
         this.dataGrid.removeEventListener(Event.RESIZE,this.editorAncestorResizeHandler);
         if(Boolean(this.itemEditorInstance) || Boolean(this.editedItemRenderer))
         {
            if(Boolean(this.itemEditorInstance))
            {
               this.itemEditorInstance.discard();
            }
            o = Boolean(this.itemEditorInstance) ? this.itemEditorInstance : this.editedItemRenderer;
            o.removeEventListener(KeyboardEvent.KEY_DOWN,this.editor_keyDownHandler);
            o.removeEventListener(FocusEvent.FOCUS_OUT,this.editor_focusOutHandler);
            o.removeEventListener(FocusEvent.KEY_FOCUS_CHANGE,this.editor_keyFocusChangeHandler);
            this.addRemoveFlexEventEnterListener(DisplayObject(o),false);
            if(Boolean(this.grid.focusManager))
            {
               this.grid.focusManager.defaultButtonEnabled = true;
            }
            this.dataGrid.setFocus();
            if(Boolean(this.itemEditorInstance))
            {
               this.grid.removeElement(this.itemEditorInstance);
            }
            else
            {
               this.grid.invalidateDisplayList();
            }
            if(this.restoreFocusableChildren)
            {
               this.restoreFocusableChildrenFlags();
            }
            this.itemEditorInstance = null;
            this._editedItemRenderer = null;
            this._editedItemPosition = null;
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function createItemEditor(rowIndex:int, columnIndex:int) : void
      {
         var itemEditor:IFactory = null;
         var c:Class = null;
         var editor:IEventDispatcher = null;
         if(columnIndex >= this.grid.columns.length)
         {
            return;
         }
         var col:GridColumn = this.grid.columns.getItemAt(columnIndex) as GridColumn;
         var item:IGridItemRenderer = this.grid.getItemRendererAt(rowIndex,columnIndex);
         var cellBounds:Rectangle = this.grid.getCellBounds(rowIndex,columnIndex);
         var localCellOrigin:Point = cellBounds.topLeft;
         this._editedItemRenderer = item;
         if(this.restoreFocusableChildren)
         {
            this.saveDataGridHasFocusableChildren = this.dataGrid.hasFocusableChildren;
         }
         this.dataGrid.hasFocusableChildren = true;
         if(Boolean(this.dataGrid.scroller))
         {
            if(this.restoreFocusableChildren)
            {
               this.saveScrollerHasFocusableChildren = this.dataGrid.scroller.hasFocusableChildren;
            }
            this.dataGrid.scroller.hasFocusableChildren = true;
         }
         this.restoreFocusableChildren = true;
         if(!col.rendererIsEditable)
         {
            itemEditor = col.itemEditor;
            if(!itemEditor)
            {
               itemEditor = this.dataGrid.itemEditor;
            }
            if(!itemEditor)
            {
               itemEditor = GridColumn.defaultItemEditorFactory;
            }
            if(itemEditor == GridColumn.defaultItemEditorFactory)
            {
               c = this.dataGrid.getStyle("defaultDataGridItemEditor");
               if(Boolean(c))
               {
                  itemEditor = col.itemEditor = new ClassFactory(c);
               }
            }
            this.itemEditorInstance = itemEditor.newInstance();
            this.itemEditorInstance.owner = this.dataGrid;
            this.itemEditorInstance.rowIndex = rowIndex;
            this.itemEditorInstance.column = col;
            this.itemEditorInstance.hasFocusableChildren = true;
            if(this.itemEditorInstance is ISimpleStyleClient)
            {
               ISimpleStyleClient(this.itemEditorInstance).styleName = item;
            }
            this.grid.addElement(this.itemEditorInstance);
            this.itemEditorInstance.data = item.data;
            this.itemEditorInstance.width = cellBounds.width + 1;
            this.itemEditorInstance.height = cellBounds.height + 1;
            this.itemEditorInstance.setLayoutBoundsPosition(localCellOrigin.x,localCellOrigin.y);
            if(this.itemEditorInstance is IInvalidating)
            {
               IInvalidating(this.itemEditorInstance).validateNow();
            }
            this.itemEditorInstance.prepare();
            this.itemEditorInstance.visible = true;
         }
         else
         {
            this.setFocusInItemRenderer(item);
         }
         if(Boolean(this.itemEditorInstance) || Boolean(this.editedItemRenderer))
         {
            editor = Boolean(this.itemEditorInstance) ? this.itemEditorInstance : this.editedItemRenderer;
            editor.addEventListener(FocusEvent.FOCUS_OUT,this.editor_focusOutHandler);
            editor.addEventListener(KeyboardEvent.KEY_DOWN,this.editor_keyDownHandler);
            editor.addEventListener(FocusEvent.KEY_FOCUS_CHANGE,this.editor_keyFocusChangeHandler,false,1000);
            this.addRemoveFlexEventEnterListener(DisplayObject(editor),true);
         }
         if(Boolean(this.grid.focusManager))
         {
            this.grid.focusManager.defaultButtonEnabled = false;
         }
         this.grid.invalidateDisplayList();
         if(Boolean(this.grid.root))
         {
            this.grid.systemManager.addEventListener(Event.DEACTIVATE,this.deactivateHandler,false,0,true);
         }
         this.grid.systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_DOWN,this.sandBoxRoot_mouseDownHandler,true,0,true);
         this.grid.systemManager.getSandboxRoot().addEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE,this.sandBoxRoot_mouseDownHandler,false,0,true);
         this.grid.systemManager.addEventListener(Event.RESIZE,this.editorAncestorResizeHandler);
         this.grid.addEventListener(Event.RESIZE,this.editorAncestorResizeHandler);
      }
      
      private function setFocusInItemRenderer(item:IGridItemRenderer) : void
      {
         var fm:FocusManager = null;
         var o:DisplayObject = null;
         var firstComponent:DisplayObject = null;
         var found:Boolean = false;
         var lastItem:DisplayObject = null;
         if(Boolean(this.grid.focusManager) && this.grid.focusManager is FocusManager)
         {
            fm = this.grid.focusManager as FocusManager;
            o = item as DisplayObject;
            firstComponent = null;
            found = false;
            do
            {
               fm.fauxFocus = o;
               o = fm.getNextFocusManagerComponent(false) as DisplayObject;
               if(o == item || item is DisplayObjectContainer && DisplayObjectContainer(item).contains(o))
               {
                  found = true;
                  break;
               }
               if(!firstComponent)
               {
                  firstComponent = o;
               }
               else if(firstComponent == o)
               {
                  break;
               }
            }
            while(Boolean(o) && Boolean(this.dataGrid.contains(o)));
            if(found && this.wasLastEventMovingBackward())
            {
               lastItem = o;
               do
               {
                  fm.fauxFocus = o;
                  lastItem = o;
                  o = fm.getNextFocusManagerComponent(false) as DisplayObject;
               }
               while(Boolean(o) && DisplayObjectContainer(item).contains(o));
               o = lastItem;
            }
            fm.fauxFocus = null;
            if(found)
            {
               fm.setFocus(IFocusManagerComponent(o));
               fm.showFocus();
            }
         }
      }
      
      private function wasLastEventMovingBackward() : Boolean
      {
         if(Boolean(this.lastEvent))
         {
            if(this.lastEvent.type == FocusEvent.KEY_FOCUS_CHANGE && FocusEvent(this.lastEvent).shiftKey)
            {
               return true;
            }
            if(this.lastEvent.type == KeyboardEvent.KEY_DOWN && KeyboardEvent(this.lastEvent).keyCode == Keyboard.TAB && KeyboardEvent(this.lastEvent).shiftKey)
            {
               return true;
            }
         }
         return false;
      }
      
      public function startItemEditorSession(rowIndex:int, columnIndex:int) : Boolean
      {
         if(!this.isValidCellPosition(rowIndex,columnIndex))
         {
            return false;
         }
         this.dataGrid.addEventListener(GridItemEditorEvent.GRID_ITEM_EDITOR_SESSION_STARTING,this.dataGrid_gridItemEditorSessionStartingHandler,false,EventPriority.DEFAULT_HANDLER);
         var column:GridColumn = this.grid.columns.getItemAt(columnIndex) as GridColumn;
         if(!column || !column.visible)
         {
            return false;
         }
         var dataGridEvent:GridItemEditorEvent = new GridItemEditorEvent(GridItemEditorEvent.GRID_ITEM_EDITOR_SESSION_STARTING,false,true);
         dataGridEvent.rowIndex = Math.min(rowIndex,this.grid.dataProvider.length - 1);
         dataGridEvent.columnIndex = Math.min(columnIndex,this.grid.columns.length - 1);
         dataGridEvent.column = column;
         var editorStarted:Boolean = false;
         if(column.rendererIsEditable == true)
         {
            this.dataGrid_gridItemEditorSessionStartingHandler(dataGridEvent);
            editorStarted = true;
         }
         else
         {
            editorStarted = Boolean(this.dataGrid.dispatchEvent(dataGridEvent));
         }
         if(editorStarted)
         {
            this.lastEditedItemPosition = {
               "columnIndex":columnIndex,
               "rowIndex":rowIndex
            };
            this.dataGrid.grid.caretRowIndex = rowIndex;
            this.dataGrid.grid.caretColumnIndex = columnIndex;
         }
         this.restoreFocusableChildren = true;
         this.dataGrid.removeEventListener(GridItemEditorEvent.GRID_ITEM_EDITOR_SESSION_STARTING,this.dataGrid_gridItemEditorSessionStartingHandler);
         return editorStarted;
      }
      
      public function endItemEditorSession(cancel:Boolean = false) : Boolean
      {
         if(cancel)
         {
            this.cancelEdit();
            return false;
         }
         return this.endEdit();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function cancelEdit() : void
      {
         if(Boolean(this.itemEditorInstance))
         {
            this.dispatchCancelEvent();
            this.destroyItemEditor();
         }
         else if(Boolean(this.editedItemRenderer))
         {
            this.destroyItemEditor();
         }
      }
      
      private function dispatchCancelEvent() : void
      {
         var dataGridEvent:GridItemEditorEvent = new GridItemEditorEvent(GridItemEditorEvent.GRID_ITEM_EDITOR_SESSION_CANCEL);
         dataGridEvent.columnIndex = this.editedItemPosition.columnIndex;
         dataGridEvent.column = this.itemEditorInstance.column;
         dataGridEvent.rowIndex = this.editedItemPosition.rowIndex;
         this.dataGrid.dispatchEvent(dataGridEvent);
      }
      
      private function endEdit() : Boolean
      {
         if(!this.itemEditorInstance && Boolean(this.editedItemRenderer))
         {
            this.inEndEdit = true;
            this.destroyItemEditor();
            this.inEndEdit = false;
            return true;
         }
         if(!this.itemEditorInstance)
         {
            return false;
         }
         this.inEndEdit = true;
         var itemPosition:Object = this.editedItemPosition;
         if(!this.saveItemEditorSession())
         {
            this.dispatchCancelEvent();
            this.inEndEdit = false;
            return false;
         }
         var dataGridEvent:GridItemEditorEvent = new GridItemEditorEvent(GridItemEditorEvent.GRID_ITEM_EDITOR_SESSION_SAVE,false,true);
         dataGridEvent.columnIndex = itemPosition.columnIndex;
         dataGridEvent.column = this.dataGrid.columns.getItemAt(itemPosition.columnIndex) as GridColumn;
         dataGridEvent.rowIndex = itemPosition.rowIndex;
         this.dataGrid.dispatchEvent(dataGridEvent);
         this.inEndEdit = false;
         return true;
      }
      
      private function saveItemEditorSession() : Boolean
      {
         var dataSaved:Boolean = false;
         if(Boolean(this.itemEditorInstance))
         {
            dataSaved = this.itemEditorInstance.save();
            if(dataSaved)
            {
               this.destroyItemEditor();
            }
         }
         return dataSaved;
      }
      
      private function openEditorInNextEditableCell(rowIndex:int, columnIndex:int, backward:Boolean) : Boolean
      {
         var nextCell:Point = new Point(rowIndex,columnIndex);
         var openedEditor:Boolean = false;
         do
         {
            nextCell = this.getNextEditableCell(nextCell.x,nextCell.y,backward);
            if(Boolean(nextCell))
            {
               openedEditor = this.dataGrid.startItemEditorSession(nextCell.x,nextCell.y);
            }
         }
         while(Boolean(nextCell) && !openedEditor);
         return openedEditor;
      }
      
      private function getNextEditableCell(rowIndex:int, columnIndex:int, backward:Boolean) : Point
      {
         var nextColumn:int = 0;
         var nextRow:int = 0;
         var increment:int = backward ? -1 : 1;
         rowIndex = rowIndex;
         columnIndex = columnIndex;
         while(true)
         {
            nextColumn = columnIndex + increment;
            if(nextColumn >= 0 && nextColumn < this.dataGrid.columns.length)
            {
               columnIndex += increment;
            }
            else
            {
               columnIndex = backward ? int(this.dataGrid.grid.columns.length - 1) : 0;
               nextRow = rowIndex + increment;
               if(!(nextRow >= 0 && nextRow < this.dataGrid.dataProvider.length))
               {
                  break;
               }
               rowIndex += increment;
            }
            if(this.canEditColumn(columnIndex))
            {
               return new Point(rowIndex,columnIndex);
            }
         }
         return null;
      }
      
      private function canEditColumn(columnIndex:int) : Boolean
      {
         var column:GridColumn = this.grid.columns.getItemAt(columnIndex) as GridColumn;
         return this.dataGrid.editable && column.editable && column.visible;
      }
      
      private function wasCellPreviouslySelected(rowIndex:int, columnIndex:int) : Boolean
      {
         if(this.dataGrid.isRowSelectionMode())
         {
            return this.dataGrid.selectionContainsIndex(rowIndex);
         }
         if(this.dataGrid.isCellSelectionMode())
         {
            return this.dataGrid.selectionContainsCell(rowIndex,columnIndex);
         }
         return false;
      }
      
      private function isValidCellPosition(rowIndex:int, cellIndex:int) : Boolean
      {
         if(rowIndex >= 0 && rowIndex < this.dataGrid.dataProvider.length && cellIndex >= 0 && cellIndex < this.dataGrid.columns.length)
         {
            return true;
         }
         return false;
      }
      
      private function addRemoveFlexEventEnterListener(element:DisplayObject, addListener:Boolean) : void
      {
         var container:DisplayObjectContainer = null;
         var n:int = 0;
         var i:int = 0;
         var child:DisplayObject = null;
         if(addListener)
         {
            element.addEventListener(FlexEvent.ENTER,this.editor_enterHandler);
         }
         else
         {
            element.removeEventListener(FlexEvent.ENTER,this.editor_enterHandler);
         }
         if(element is DisplayObjectContainer)
         {
            container = DisplayObjectContainer(element);
            n = container.numChildren;
            for(i = 0; i < n; i++)
            {
               child = container.getChildAt(i);
               if(child is DisplayObjectContainer)
               {
                  this.addRemoveFlexEventEnterListener(child,addListener);
               }
               else if(addListener)
               {
                  child.addEventListener(FlexEvent.ENTER,this.editor_enterHandler);
               }
               else
               {
                  child.removeEventListener(FlexEvent.ENTER,this.editor_enterHandler);
               }
            }
         }
      }
      
      private function editorOwnsClick(event:Event) : Boolean
      {
         var target:IUIComponent = null;
         if(event is MouseEvent)
         {
            target = this.getIUIComponent(DisplayObject(event.target));
            if(Boolean(target))
            {
               return this.editorOwns(target);
            }
         }
         return false;
      }
      
      private function editorOwns(child:IUIComponent) : Boolean
      {
         return Boolean(this.itemEditorInstance) && (this.itemEditorInstance == child || IUIComponent(this.itemEditorInstance).owns(DisplayObject(child))) || Boolean(this.editedItemRenderer) && (this.editedItemRenderer == child || IUIComponent(this.editedItemRenderer).owns(DisplayObject(child)));
      }
      
      private function getIUIComponent(displayObject:DisplayObject) : IUIComponent
      {
         if(displayObject is IUIComponent)
         {
            return IUIComponent(displayObject);
         }
         var current:DisplayObject = displayObject.parent;
         while(Boolean(current))
         {
            if(current is IUIComponent)
            {
               return IUIComponent(current);
            }
            current = current.parent;
         }
         return null;
      }
      
      private function restoreFocusableChildrenFlags() : void
      {
         this.dataGrid.hasFocusableChildren = this.saveDataGridHasFocusableChildren;
         if(Boolean(this.dataGrid.scroller))
         {
            this.dataGrid.scroller.hasFocusableChildren = this.saveScrollerHasFocusableChildren;
         }
      }
      
      private function dataGrid_gridItemEditorSessionStartingHandler(event:GridItemEditorEvent) : void
      {
         if(!event.isDefaultPrevented())
         {
            this.setEditedItemPosition({
               "columnIndex":event.column.columnIndex,
               "rowIndex":event.rowIndex
            });
         }
         else if(!this.itemEditorInstance)
         {
            this._editedItemPosition = null;
            this.dataGrid.setFocus();
         }
      }
      
      private function dataGrid_keyboardDownHandler(event:KeyboardEvent) : void
      {
         var nextCell:Point = null;
         var lastColumn:int = 0;
         if(!this.dataGrid.editable || this.dataGrid.selectionMode == GridSelectionMode.NONE)
         {
            return;
         }
         if(event.isDefaultPrevented())
         {
            return;
         }
         this.lastEvent = event;
         if(event.keyCode == this.dataGrid.editKey)
         {
            if(Boolean(this.itemEditorInstance))
            {
               return;
            }
            nextCell = null;
            if(this.dataGrid.isRowSelectionMode())
            {
               lastColumn = Boolean(this.lastEditedItemPosition) ? int(this.lastEditedItemPosition.columnIndex) : 0;
               this.openEditorInNextEditableCell(this.dataGrid.grid.caretRowIndex,lastColumn - 1,false);
               return;
            }
            if(this.canEditColumn(this.grid.caretColumnIndex))
            {
               this.dataGrid.startItemEditorSession(this.grid.caretRowIndex,this.grid.caretColumnIndex);
            }
         }
      }
      
      private function grid_gridMouseDownHandler(event:GridEvent) : void
      {
         this.gotDoubleClickEvent = false;
         if(!this.dataGrid.editable || this.editorOwnsClick(event))
         {
            return;
         }
         if(!this.isValidCellPosition(event.rowIndex,event.columnIndex))
         {
            return;
         }
         this.lastEvent = event;
         var rowIndex:int = event.rowIndex;
         var columnIndex:int = event.columnIndex;
         var r:IGridItemRenderer = event.itemRenderer;
         this.lastItemDown = null;
         if(event.shiftKey || event.ctrlKey)
         {
            return;
         }
         if(Boolean(this.itemEditorInstance))
         {
            if(!this.dataGrid.endItemEditorSession())
            {
               this.dataGrid.endItemEditorSession(true);
            }
            return;
         }
         var column:GridColumn = this.dataGrid.columns.getItemAt(columnIndex) as GridColumn;
         if(Boolean(r) && (column.rendererIsEditable || this.wasCellPreviouslySelected(rowIndex,columnIndex)))
         {
            this.lastItemDown = r;
         }
      }
      
      private function grid_gridMouseUpHandler(event:GridEvent) : void
      {
         if(!this.dataGrid.editable)
         {
            return;
         }
         if(!this.isValidCellPosition(event.rowIndex,event.columnIndex))
         {
            return;
         }
         this.lastEvent = event;
         var eventRowIndex:int = event.rowIndex;
         var eventColumnIndex:int = event.columnIndex;
         if(this.dataGrid.selectionLength != 1)
         {
            return;
         }
         var rowIndex:int = eventRowIndex;
         var columnIndex:int = eventColumnIndex;
         var r:IVisualElement = event.itemRenderer;
         if(Boolean(r && r != this.editedItemRenderer) && Boolean(this.lastItemDown) && this.lastItemDown == r)
         {
            if(columnIndex >= 0)
            {
               if(Boolean(this.grid.columns.getItemAt(columnIndex).editable))
               {
                  if(Boolean(this.doubleClickTimer))
                  {
                     if(rowIndex == this.lastItemClickedPosition.rowIndex && columnIndex == this.lastItemClickedPosition.columnIndex)
                     {
                        this.lastItemDown == null;
                        return;
                     }
                     this.doubleClickTimer.stop();
                     this.doubleClickTimer = null;
                  }
                  this.lastItemClickedPosition = {
                     "columnIndex":columnIndex,
                     "rowIndex":rowIndex
                  };
                  if(this.dataGrid.editOnDoubleClick || InteractiveObject(this.lastItemDown).doubleClickEnabled == false)
                  {
                     this.dataGrid.startItemEditorSession(rowIndex,columnIndex);
                  }
                  else
                  {
                     this.doubleClickTimer = new Timer(this.dataGrid.doubleClickTime,1);
                     this.doubleClickTimer.addEventListener(TimerEvent.TIMER,this.doubleClickTimerHandler);
                     this.doubleClickTimer.start();
                  }
               }
            }
         }
         this.lastItemDown = null;
      }
      
      private function grid_gridDoubleClickHandler(event:GridEvent) : void
      {
         if(!this.dataGrid.editable)
         {
            return;
         }
         if(!this.isValidCellPosition(event.rowIndex,event.columnIndex))
         {
            return;
         }
         this.lastEvent = event;
         this.gotDoubleClickEvent = true;
      }
      
      private function doubleClickTimerHandler(event:TimerEvent) : void
      {
         this.doubleClickTimer.removeEventListener(TimerEvent.TIMER,this.doubleClickTimerHandler);
         this.doubleClickTimer = null;
         if(!this.gotDoubleClickEvent)
         {
            this.dataGrid.startItemEditorSession(this.lastItemClickedPosition.rowIndex,this.lastItemClickedPosition.columnIndex);
         }
         this.gotDoubleClickEvent = false;
      }
      
      private function deactivateHandler(event:Event) : void
      {
         if(Boolean(this.itemEditorInstance) || Boolean(this.editedItemRenderer))
         {
            if(!this.dataGrid.endItemEditorSession())
            {
               this.dataGrid.endItemEditorSession(true);
            }
            this.dataGrid.setFocus();
         }
      }
      
      private function editor_focusOutHandler(event:FocusEvent) : void
      {
         var component:IUIComponent = null;
         if(Boolean(event.relatedObject))
         {
            component = this.getIUIComponent(event.relatedObject);
            if(Boolean(component) && this.editorOwns(component))
            {
               return;
            }
         }
         if(!event.relatedObject)
         {
            return;
         }
         if(Boolean(this.itemEditorInstance) || Boolean(this.editedItemRenderer))
         {
            if(!this.dataGrid.endItemEditorSession())
            {
               this.dataGrid.endItemEditorSession(true);
            }
         }
      }
      
      private function editor_enterHandler(event:Event) : void
      {
         if(event is FlexEvent)
         {
            this.gotFlexEnterEvent = true;
         }
      }
      
      private function editor_keyDownHandler(event:KeyboardEvent) : void
      {
         var lastRow:int = 0;
         var lastColumn:int = 0;
         if(event.isDefaultPrevented())
         {
            if(!(event.charCode == Keyboard.ENTER && this.gotFlexEnterEvent))
            {
               this.gotFlexEnterEvent = false;
               return;
            }
         }
         this.gotFlexEnterEvent = false;
         if(event.keyCode == Keyboard.ESCAPE)
         {
            this.cancelEdit();
         }
         else if(event.ctrlKey && event.charCode == 46)
         {
            this.cancelEdit();
         }
         else if(event.charCode == Keyboard.ENTER && event.keyCode != 229)
         {
            if(!this._editedItemPosition)
            {
               return;
            }
            if(event.ctrlKey || event.ctrlKey && event.shiftKey)
            {
               this.restoreFocusableChildren = false;
            }
            if(this.dataGrid.endItemEditorSession())
            {
               if(Boolean(this.grid.focusManager))
               {
                  this.grid.focusManager.defaultButtonEnabled = false;
               }
               if(event.ctrlKey || event.ctrlKey && event.shiftKey)
               {
                  lastRow = Boolean(this.lastEditedItemPosition) ? int(this.lastEditedItemPosition.rowIndex) : 0;
                  lastColumn = Boolean(this.lastEditedItemPosition) ? int(this.lastEditedItemPosition.columnIndex) : 0;
                  if(event.shiftKey)
                  {
                     lastRow -= 1;
                  }
                  else
                  {
                     lastRow += 1;
                  }
                  if(lastRow >= 0 && lastRow < this.dataGrid.dataProvider.length)
                  {
                     if(!this.openEditorInNextEditableCell(lastRow,lastColumn - 1,false))
                     {
                        this.restoreFocusableChildren = true;
                        this.restoreFocusableChildrenFlags();
                     }
                  }
               }
            }
         }
         event.stopPropagation();
      }
      
      private function editor_keyFocusChangeHandler(event:FocusEvent) : void
      {
         var nextObject:IFocusManagerComponent = null;
         this.lastEvent = event;
         if(Boolean(this.itemEditorInstance) || Boolean(this.editedItemRenderer))
         {
            if(event.isDefaultPrevented())
            {
               return;
            }
            nextObject = this.grid.focusManager.getNextFocusManagerComponent(event.shiftKey);
            if(Boolean(nextObject == this.itemEditorInstance) || Boolean(this.itemEditorInstance && !DisplayObjectContainer(this.itemEditorInstance).contains(DisplayObject(nextObject))) || Boolean(!this.itemEditorInstance) && (Boolean(nextObject == this.editedItemRenderer || this.editedItemRenderer && !DisplayObjectContainer(this.editedItemRenderer).contains(DisplayObject(nextObject)))))
            {
               event.preventDefault();
               this.restoreFocusableChildren = false;
               this.dataGrid.endItemEditorSession();
               if(!this.openEditorInNextEditableCell(this.lastEditedItemPosition.rowIndex,this.lastEditedItemPosition.columnIndex,event.shiftKey))
               {
                  this.restoreFocusableChildren = true;
                  this.restoreFocusableChildrenFlags();
               }
            }
         }
      }
      
      private function editorAncestorResizeHandler(event:Event) : void
      {
         if(!this.dataGrid.endItemEditorSession())
         {
            this.dataGrid.endItemEditorSession(true);
         }
      }
      
      private function sandBoxRoot_mouseDownHandler(event:Event) : void
      {
         if(this.editorOwnsClick(event))
         {
            return;
         }
         if(Boolean(this.dataGrid.scroller) && Boolean(this.dataGrid.scroller.contains(DisplayObject(event.target))) && !this.grid.contains(DisplayObject(event.target)))
         {
            return;
         }
         if(!this.dataGrid.endItemEditorSession())
         {
            this.dataGrid.endItemEditorSession(true);
         }
         this.dataGrid.setFocus();
      }
   }
}

