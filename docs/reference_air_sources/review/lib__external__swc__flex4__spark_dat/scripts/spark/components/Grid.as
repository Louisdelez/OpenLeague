package spark.components
{
   import flash.display.InteractiveObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.utils.getTimer;
   import mx.collections.ArrayList;
   import mx.collections.IList;
   import mx.core.IFactory;
   import mx.core.UIComponentGlobals;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.utils.ObjectUtil;
   import spark.components.gridClasses.CellPosition;
   import spark.components.gridClasses.GridColumn;
   import spark.components.gridClasses.GridDimensions;
   import spark.components.gridClasses.GridLayout;
   import spark.components.gridClasses.GridSelection;
   import spark.components.gridClasses.GridSelectionMode;
   import spark.components.gridClasses.IDataGridElement;
   import spark.components.gridClasses.IGridItemRenderer;
   import spark.events.GridCaretEvent;
   import spark.events.GridEvent;
   import spark.utils.MouseEventUtil;
   
   [Event(name="caretChange",type="spark.events.GridCaretEvent")]
   [Event(name="gridDoubleClick",type="spark.events.GridEvent")]
   [Event(name="gridClick",type="spark.events.GridEvent")]
   [Event(name="gridRollOut",type="spark.events.GridEvent")]
   [Event(name="gridRollOver",type="spark.events.GridEvent")]
   [Event(name="gridMouseUp",type="spark.events.GridEvent")]
   [Event(name="gridMouseDrag",type="spark.events.GridEvent")]
   [Event(name="gridMouseDown",type="spark.events.GridEvent")]
   public class Grid extends Group implements IDataGridElement
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static const invalidateDisplayListReasonBits:Object = {
         "verticalScrollPosition":uint(1 << 0),
         "horizontalScrollPosition":uint(1 << 1),
         "bothScrollPositions":uint(1 << 0) | uint(1 << 1),
         "hoverIndicator":uint(1 << 2),
         "caretIndicator":uint(1 << 3),
         "selectionIndicator":uint(1 << 4),
         "editorIndicator":uint(1 << 5),
         "none":uint(~0)
      };
      
      private const deferredOperations:Vector.<Function> = new Vector.<Function>();
      
      private var caretSelectedItem:Object = null;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var inUpdateDisplayList:Boolean = false;
      
      private var dragInProgress:Boolean = false;
      
      private var generatedColumns:Boolean = false;
      
      private var _anchorColumnIndex:int = 0;
      
      private var anchorChanged:Boolean = false;
      
      private var _anchorRowIndex:int = 0;
      
      private var _caretIndicator:IFactory = null;
      
      private var _caretColumnIndex:int = -1;
      
      private var _oldCaretColumnIndex:int = -1;
      
      private var caretChanged:Boolean = false;
      
      private var _caretRowIndex:int = -1;
      
      private var _oldCaretRowIndex:int = -1;
      
      private var _hoverIndicator:IFactory = null;
      
      private var _hoverColumnIndex:int = -1;
      
      private var _hoverRowIndex:int = -1;
      
      private var _columns:IList = null;
      
      private var columnsChanged:Boolean = false;
      
      private var _dataProvider:IList = null;
      
      private var dataProviderChanged:Boolean;
      
      private var _dataTipField:String = null;
      
      private var _dataTipFunction:Function = null;
      
      private var _itemRenderer:IFactory = null;
      
      private var itemRendererChanged:Boolean = false;
      
      private var _columnSeparator:IFactory = null;
      
      private var _gridSelection:GridSelection;
      
      private var _dataGrid:DataGrid = null;
      
      private var _requestedMaxRowCount:int = 10;
      
      private var _requestedMinRowCount:int = -1;
      
      private var _requestedRowCount:int = -1;
      
      private var _requestedMinColumnCount:int = -1;
      
      private var _requestedColumnCount:int = -1;
      
      private var _resizableColumns:Boolean = true;
      
      private var _rowBackground:IFactory = null;
      
      private var _rowHeight:Number = NaN;
      
      private var rowHeightChanged:Boolean;
      
      private var _rowSeparator:IFactory = null;
      
      private var _selectionIndicator:IFactory = null;
      
      private var _showDataTips:Boolean = false;
      
      private var _typicalItem:Object = null;
      
      private var typicalItemChanged:Boolean = false;
      
      private var _variableRowHeight:Boolean = false;
      
      private var variableRowHeightChanged:Boolean = false;
      
      private var invalidateDisplayListReasonsMask:uint = 0;
      
      private var rollRowIndex:int = -1;
      
      private var rollColumnIndex:int = -1;
      
      private var mouseDownRowIndex:int = -1;
      
      private var mouseDownColumnIndex:int = -1;
      
      private var lastClickTime:Number;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var DOUBLE_CLICK_TIME:Number = 480;
      
      public function Grid()
      {
         super();
         layout = new GridLayout();
         MouseEventUtil.addDownDragUpListeners(this,this.grid_mouseDownDragUpHandler,this.grid_mouseDownDragUpHandler,this.grid_mouseDownDragUpHandler);
         addEventListener(MouseEvent.MOUSE_UP,this.grid_mouseUpHandler);
         addEventListener(MouseEvent.MOUSE_MOVE,this.grid_mouseMoveHandler);
         addEventListener(MouseEvent.ROLL_OUT,this.grid_mouseRollOutHandler);
      }
      
      private function get gridLayout() : GridLayout
      {
         return layout as GridLayout;
      }
      
      private function dispatchChangeEvent(type:String) : void
      {
         if(hasEventListener(type))
         {
            dispatchEvent(new Event(type));
         }
      }
      
      private function dispatchFlexEvent(type:String) : void
      {
         if(hasEventListener(type))
         {
            dispatchEvent(new FlexEvent(type));
         }
      }
      
      [Bindable("anchorColumnIndexChanged")]
      public function get anchorColumnIndex() : int
      {
         return this._anchorColumnIndex;
      }
      
      public function set anchorColumnIndex(value:int) : void
      {
         if(this._anchorColumnIndex == value || this.selectionMode == GridSelectionMode.SINGLE_ROW || this.selectionMode == GridSelectionMode.MULTIPLE_ROWS)
         {
            return;
         }
         this._anchorColumnIndex = value;
         this.anchorChanged = true;
         invalidateProperties();
         this.dispatchChangeEvent("anchorColumnIndexChanged");
      }
      
      [Bindable("anchorRowIndexChanged")]
      public function get anchorRowIndex() : int
      {
         return this._anchorRowIndex;
      }
      
      public function set anchorRowIndex(value:int) : void
      {
         if(this._anchorRowIndex == value)
         {
            return;
         }
         this._anchorRowIndex = value;
         this.anchorChanged = true;
         invalidateProperties();
         this.dispatchChangeEvent("anchorRowIndexChanged");
      }
      
      [Bindable("caretIndicatorChanged")]
      public function get caretIndicator() : IFactory
      {
         return this._caretIndicator;
      }
      
      public function set caretIndicator(value:IFactory) : void
      {
         if(this._caretIndicator == value)
         {
            return;
         }
         this._caretIndicator = value;
         this.invalidateDisplayListFor("caretIndicator");
         this.dispatchChangeEvent("caretIndicatorChanged");
      }
      
      [Bindable("caretColumnIndexChanged")]
      public function get caretColumnIndex() : int
      {
         return this._caretColumnIndex;
      }
      
      public function set caretColumnIndex(value:int) : void
      {
         if(this._caretColumnIndex == value || value < -1)
         {
            return;
         }
         this._caretColumnIndex = value;
         this.caretChanged = true;
         invalidateProperties();
         this.invalidateDisplayListFor("caretIndicator");
         this.dispatchChangeEvent("caretColumnIndexChanged");
      }
      
      [Bindable("caretRowIndexChanged")]
      public function get caretRowIndex() : int
      {
         return this._caretRowIndex;
      }
      
      public function set caretRowIndex(value:int) : void
      {
         if(this._caretRowIndex == value || value < -1)
         {
            return;
         }
         this._caretRowIndex = value;
         this.caretChanged = true;
         invalidateProperties();
         this.invalidateDisplayListFor("caretIndicator");
         this.dispatchChangeEvent("caretRowIndexChanged");
      }
      
      [Bindable("hoverIndicatorChanged")]
      public function get hoverIndicator() : IFactory
      {
         return this._hoverIndicator;
      }
      
      public function set hoverIndicator(value:IFactory) : void
      {
         if(this._hoverIndicator == value)
         {
            return;
         }
         this._hoverIndicator = value;
         this.invalidateDisplayListFor("hoverIndicator");
         this.dispatchChangeEvent("hoverIndicatorChanged");
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
         this.invalidateDisplayListFor("hoverIndicator");
         this.dispatchChangeEvent("hoverColumnIndexChanged");
      }
      
      [Bindable("hoverRowIndexChanged")]
      public function get hoverRowIndex() : int
      {
         return this._hoverRowIndex;
      }
      
      public function set hoverRowIndex(value:int) : void
      {
         if(this._hoverRowIndex == value)
         {
            return;
         }
         this._hoverRowIndex = value;
         this.invalidateDisplayListFor("hoverIndicator");
         this.dispatchChangeEvent("hoverRowIndexChanged");
      }
      
      [Inspectable(category="General")]
      [Bindable("columnsChanged")]
      public function get columns() : IList
      {
         return this._columns;
      }
      
      public function set columns(value:IList) : void
      {
         var index:int = 0;
         var oldColumn:GridColumn = null;
         var newColumn:GridColumn = null;
         if(this._columns == value)
         {
            return;
         }
         var oldColumns:IList = this._columns;
         if(Boolean(oldColumns))
         {
            oldColumns.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.columns_collectionChangeHandler);
            for(index = 0; index < oldColumns.length; index++)
            {
               oldColumn = GridColumn(oldColumns.getItemAt(index));
               oldColumn.setGrid(null);
               oldColumn.setColumnIndex(-1);
            }
         }
         this._columns = value;
         var newColumns:IList = this._columns;
         if(Boolean(newColumns))
         {
            newColumns.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.columns_collectionChangeHandler,false,0,true);
            for(index = 0; index < newColumns.length; index++)
            {
               newColumn = GridColumn(newColumns.getItemAt(index));
               newColumn.setGrid(this);
               newColumn.setColumnIndex(index);
            }
         }
         this.columnsChanged = true;
         this.generatedColumns = false;
         invalidateProperties();
         this.invalidateSize();
         this.invalidateDisplayList();
         this.dispatchChangeEvent("columnsChanged");
      }
      
      private function getColumnsLength() : uint
      {
         var columns:IList = this.columns;
         return Boolean(columns) ? uint(columns.length) : 0;
      }
      
      private function generateColumns() : IList
      {
         var classInfo:Object = null;
         var property:QName = null;
         var column:GridColumn = null;
         var item:Object = this.typicalItem;
         if(Boolean(!item) && Boolean(this.dataProvider) && this.dataProvider.length > 0)
         {
            item = this.dataProvider.getItemAt(0);
         }
         var itemColumns:IList = null;
         if(Boolean(item))
         {
            itemColumns = new ArrayList();
            classInfo = ObjectUtil.getClassInfo(item,["uid","mx_internal_uid"]);
            if(Boolean(classInfo))
            {
               for each(property in classInfo.properties)
               {
                  column = new GridColumn();
                  column.dataField = property.localName;
                  itemColumns.addItem(column);
               }
            }
         }
         return itemColumns;
      }
      
      [Inspectable(category="Data")]
      [Bindable("dataProviderChanged")]
      public function get dataProvider() : IList
      {
         return this._dataProvider;
      }
      
      public function set dataProvider(value:IList) : void
      {
         if(this._dataProvider == value)
         {
            return;
         }
         var oldDataProvider:IList = this.dataProvider;
         if(Boolean(oldDataProvider))
         {
            oldDataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.dataProvider_collectionChangeHandler);
         }
         this._dataProvider = value;
         var newDataProvider:IList = this.dataProvider;
         if(Boolean(newDataProvider))
         {
            newDataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.dataProvider_collectionChangeHandler,false,0,true);
         }
         this.dataProviderChanged = true;
         invalidateProperties();
         this.invalidateSize();
         this.invalidateDisplayList();
         this.dispatchChangeEvent("dataProviderChanged");
      }
      
      [Inspectable(category="Data",defaultValue="null")]
      [Bindable("dataTipFieldChanged")]
      public function get dataTipField() : String
      {
         return this._dataTipField;
      }
      
      public function set dataTipField(value:String) : void
      {
         if(this._dataTipField == value)
         {
            return;
         }
         this._dataTipField = value;
         this.invalidateDisplayList();
         this.dispatchChangeEvent("dataTipFieldChanged");
      }
      
      [Inspectable(category="Data")]
      [Bindable("dataTipFunctionChanged")]
      public function get dataTipFunction() : Function
      {
         return this._dataTipFunction;
      }
      
      public function set dataTipFunction(value:Function) : void
      {
         if(this._dataTipFunction == value)
         {
            return;
         }
         this._dataTipFunction = value;
         this.invalidateDisplayList();
         this.dispatchChangeEvent("dataTipFunctionChanged");
      }
      
      [Inspectable(category="Data")]
      [Bindable("itemRendererChanged")]
      public function get itemRenderer() : IFactory
      {
         return this._itemRenderer;
      }
      
      public function set itemRenderer(value:IFactory) : void
      {
         if(this._itemRenderer == value)
         {
            return;
         }
         this._itemRenderer = value;
         this.itemRendererChanged = true;
         invalidateProperties();
         this.invalidateSize();
         this.invalidateDisplayList();
         this.dispatchChangeEvent("itemRendererChanged");
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
         this.invalidateDisplayList();
         this.dispatchChangeEvent("columnSeparatorChanged");
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get gridSelection() : GridSelection
      {
         if(!this._gridSelection)
         {
            this._gridSelection = this.createGridSelection();
         }
         return this._gridSelection;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function set gridSelection(value:GridSelection) : void
      {
         this._gridSelection = value;
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
         this._dataGrid = value;
         this.dispatchChangeEvent("dataGridChanged");
      }
      
      [Inspectable(category="General",defaultValue="true")]
      public function get preserveSelection() : Boolean
      {
         return this.gridSelection.preserveSelection;
      }
      
      public function set preserveSelection(value:Boolean) : void
      {
         this.gridSelection.preserveSelection = value;
      }
      
      [Inspectable(category="General",defaultValue="10",minValue="-1")]
      public function get requestedMaxRowCount() : int
      {
         return this._requestedMaxRowCount;
      }
      
      public function set requestedMaxRowCount(value:int) : void
      {
         if(this._requestedMaxRowCount == value)
         {
            return;
         }
         this._requestedMaxRowCount = value;
         this.invalidateSize();
      }
      
      [Inspectable(category="General",minValue="-1")]
      public function get requestedMinRowCount() : int
      {
         return this._requestedMinRowCount;
      }
      
      public function set requestedMinRowCount(value:int) : void
      {
         if(this._requestedMinRowCount == value)
         {
            return;
         }
         this._requestedMinRowCount = value;
         this.invalidateSize();
      }
      
      [Inspectable(category="General",minValue="-1")]
      public function get requestedRowCount() : int
      {
         return this._requestedRowCount;
      }
      
      public function set requestedRowCount(value:int) : void
      {
         if(this._requestedRowCount == value)
         {
            return;
         }
         this._requestedRowCount = value;
         this.invalidateSize();
      }
      
      [Inspectable(category="General",minValue="-1")]
      public function get requestedMinColumnCount() : int
      {
         return this._requestedMinColumnCount;
      }
      
      public function set requestedMinColumnCount(value:int) : void
      {
         if(this._requestedMinColumnCount == value)
         {
            return;
         }
         this._requestedMinColumnCount = value;
         this.invalidateSize();
      }
      
      [Inspectable(category="General",minValue="-1")]
      public function get requestedColumnCount() : int
      {
         return this._requestedColumnCount;
      }
      
      public function set requestedColumnCount(value:int) : void
      {
         if(this._requestedColumnCount == value)
         {
            return;
         }
         this._requestedColumnCount = value;
         this.invalidateSize();
      }
      
      [Inspectable(category="General",defaultValue="false")]
      public function get requireSelection() : Boolean
      {
         return this.gridSelection.requireSelection;
      }
      
      public function set requireSelection(value:Boolean) : void
      {
         this.gridSelection.requireSelection = value;
         if(value)
         {
            this.invalidateDisplayListFor("selectionIndicator");
         }
      }
      
      [Inspectable(category="General",defaultValue="true")]
      [Bindable("resizableColumnsChanged")]
      public function get resizableColumns() : Boolean
      {
         return this._resizableColumns;
      }
      
      public function set resizableColumns(value:Boolean) : void
      {
         if(value == this.resizableColumns)
         {
            return;
         }
         this._resizableColumns = value;
         this.dispatchChangeEvent("resizableColumnsChanged");
      }
      
      [Bindable("rowBackgroundChanged")]
      public function get rowBackground() : IFactory
      {
         return this._rowBackground;
      }
      
      public function set rowBackground(value:IFactory) : void
      {
         if(this._rowBackground == value)
         {
            return;
         }
         this._rowBackground = value;
         this.invalidateDisplayList();
         this.dispatchChangeEvent("rowBackgroundChanged");
      }
      
      [Inspectable(category="General",minValue="0.0")]
      [Bindable("rowHeightChanged")]
      public function get rowHeight() : Number
      {
         return this._rowHeight;
      }
      
      public function set rowHeight(value:Number) : void
      {
         if(this._rowHeight == value)
         {
            return;
         }
         this._rowHeight = value;
         this.rowHeightChanged = true;
         invalidateProperties();
         this.dispatchChangeEvent("rowHeightChanged");
      }
      
      private function setFixedRowHeight(value:Number) : void
      {
         if(this._rowHeight == value)
         {
            return;
         }
         this._rowHeight = value;
         this.dispatchChangeEvent("rowHeightChanged");
      }
      
      [Bindable("rowSeparatorChanged")]
      public function get rowSeparator() : IFactory
      {
         return this._rowSeparator;
      }
      
      public function set rowSeparator(value:IFactory) : void
      {
         if(this._rowSeparator == value)
         {
            return;
         }
         this._rowSeparator = value;
         this.invalidateDisplayList();
         this.dispatchChangeEvent("rowSeparatorChanged");
      }
      
      [Bindable("valueCommit")]
      [Bindable("selectionChange")]
      public function get selectedCell() : CellPosition
      {
         var selectedCells:Vector.<CellPosition> = this.gridSelection.allCells();
         return Boolean(selectedCells.length) ? selectedCells[0] : null;
      }
      
      public function set selectedCell(value:CellPosition) : void
      {
         var rowIndex:int = 0;
         var columnIndex:int = 0;
         var f:Function = null;
         rowIndex = Boolean(value) ? value.rowIndex : -1;
         columnIndex = Boolean(value) ? value.columnIndex : -1;
         if(!initialized)
         {
            f = function():void
            {
               if(rowIndex != -1 && columnIndex != -1)
               {
                  setSelectedCell(rowIndex,columnIndex);
               }
               else
               {
                  clearSelection();
               }
            };
            this.deferredOperations.push(f);
            invalidateProperties();
         }
         else if(rowIndex != -1 && columnIndex != -1)
         {
            this.setSelectedCell(rowIndex,columnIndex);
         }
         else
         {
            this.clearSelection();
         }
      }
      
      [Bindable("valueCommit")]
      [Bindable("selectionChange")]
      public function get selectedCells() : Vector.<CellPosition>
      {
         return this.gridSelection.allCells();
      }
      
      public function set selectedCells(value:Vector.<CellPosition>) : void
      {
         var valueCopy:Vector.<CellPosition> = null;
         var cell:CellPosition = null;
         var f:Function = null;
         valueCopy = new Vector.<CellPosition>(0);
         if(Boolean(value))
         {
            for each(cell in value)
            {
               valueCopy.push(new CellPosition(cell.rowIndex,cell.columnIndex));
            }
         }
         if(!initialized)
         {
            f = function():void
            {
               clearSelection();
               for each(cell in valueCopy)
               {
                  addSelectedCell(cell.rowIndex,cell.columnIndex);
               }
            };
            this.deferredOperations.push(f);
            invalidateProperties();
         }
         else
         {
            this.clearSelection();
            for each(cell in valueCopy)
            {
               this.addSelectedCell(cell.rowIndex,cell.columnIndex);
            }
         }
      }
      
      [Inspectable(category="General",defaultValue="-1")]
      [Bindable("valueCommit")]
      [Bindable("selectionChange")]
      public function get selectedIndex() : int
      {
         var selectedRows:Vector.<int> = this.gridSelection.allRows();
         return selectedRows.length > 0 ? selectedRows[0] : -1;
      }
      
      public function set selectedIndex(value:int) : void
      {
         var f:Function = null;
         if(!initialized)
         {
            f = function():void
            {
               if(value != -1)
               {
                  setSelectedIndex(value);
               }
               else
               {
                  clearSelection();
               }
            };
            this.deferredOperations.push(f);
            invalidateProperties();
         }
         else if(value != -1)
         {
            this.setSelectedIndex(value);
         }
         else
         {
            this.clearSelection();
         }
      }
      
      [Inspectable(category="General")]
      [Bindable("valueCommit")]
      [Bindable("selectionChange")]
      public function get selectedIndices() : Vector.<int>
      {
         return this.gridSelection.allRows();
      }
      
      public function set selectedIndices(value:Vector.<int>) : void
      {
         var valueCopy:Vector.<int> = null;
         var f:Function = null;
         var index:int = 0;
         valueCopy = Boolean(value) ? value.concat() : new Vector.<int>(0);
         if(!initialized)
         {
            f = function():void
            {
               var index:int = 0;
               clearSelection();
               for each(index in valueCopy)
               {
                  addSelectedIndex(index);
               }
            };
            this.deferredOperations.push(f);
            invalidateProperties();
         }
         else
         {
            this.clearSelection();
            for each(index in valueCopy)
            {
               this.addSelectedIndex(index);
            }
         }
      }
      
      [Inspectable(category="General",defaultValue="null")]
      [Bindable("valueCommit")]
      [Bindable("selectionChange")]
      public function get selectedItem() : Object
      {
         var rowIndex:int = this.selectedIndex;
         if(rowIndex == -1)
         {
            return undefined;
         }
         return this.getDataProviderItem(rowIndex);
      }
      
      public function set selectedItem(value:Object) : void
      {
         var f:Function = null;
         var rowIndex:int = 0;
         if(!initialized)
         {
            f = function():void
            {
               if(!dataProvider)
               {
                  return;
               }
               var rowIndex:int = int(dataProvider.getItemIndex(value));
               if(rowIndex == -1)
               {
                  clearSelection();
               }
               else
               {
                  setSelectedIndex(rowIndex);
               }
            };
            this.deferredOperations.push(f);
            invalidateProperties();
         }
         else
         {
            if(!this.dataProvider)
            {
               return;
            }
            rowIndex = int(this.dataProvider.getItemIndex(value));
            if(rowIndex == -1)
            {
               this.clearSelection();
            }
            else
            {
               this.setSelectedIndex(rowIndex);
            }
         }
      }
      
      [Inspectable(category="General")]
      [Bindable("valueCommit")]
      [Bindable("selectionChange")]
      public function get selectedItems() : Vector.<Object>
      {
         var rowIndex:int = 0;
         var rowIndices:Vector.<int> = this.selectedIndices;
         if(rowIndices.length == 0)
         {
            return undefined;
         }
         var items:Vector.<Object> = new Vector.<Object>();
         for each(rowIndex in rowIndices)
         {
            items.push(this.dataProvider.getItemAt(rowIndex));
         }
         return items;
      }
      
      public function set selectedItems(value:Vector.<Object>) : void
      {
         var valueCopy:Vector.<Object> = null;
         var f:Function = null;
         var item:Object = null;
         valueCopy = Boolean(value) ? value.concat() : new Vector.<Object>(0);
         if(!initialized)
         {
            f = function():void
            {
               var item:Object = null;
               if(!dataProvider)
               {
                  return;
               }
               clearSelection();
               for each(item in valueCopy)
               {
                  addSelectedIndex(dataProvider.getItemIndex(item));
               }
            };
            this.deferredOperations.push(f);
            invalidateProperties();
         }
         else
         {
            if(!this.dataProvider)
            {
               return;
            }
            this.clearSelection();
            for each(item in valueCopy)
            {
               this.addSelectedIndex(this.dataProvider.getItemIndex(item));
            }
         }
      }
      
      [Bindable("selectionIndicatorChanged")]
      public function get selectionIndicator() : IFactory
      {
         return this._selectionIndicator;
      }
      
      public function set selectionIndicator(value:IFactory) : void
      {
         if(this._selectionIndicator == value)
         {
            return;
         }
         this._selectionIndicator = value;
         this.invalidateDisplayListFor("selectionIndicator");
         this.dispatchChangeEvent("selectionIndicatorChanged");
      }
      
      [Bindable("valueCommit")]
      [Bindable("selectionChange")]
      public function get selectionLength() : int
      {
         return this.gridSelection.selectionLength;
      }
      
      [Inspectable(category="General",enumeration="none,singleRow,multipleRows,singleCell,multipleCells",defaultValue="singleRow")]
      [Bindable("selectionModeChanged")]
      public function get selectionMode() : String
      {
         return this.gridSelection.selectionMode;
      }
      
      public function set selectionMode(value:String) : void
      {
         if(this.selectionMode == value)
         {
            return;
         }
         this.gridSelection.selectionMode = value;
         if(this.selectionMode != value)
         {
            return;
         }
         this.initializeAnchorPosition();
         if(!this.requireSelection)
         {
            this.initializeCaretPosition();
         }
         this.invalidateDisplayListFor("selectionIndicator");
         this.dispatchChangeEvent("selectionModeChanged");
      }
      
      [Inspectable(category="Data",defaultValue="false")]
      [Bindable("showDataTipsChanged")]
      public function get showDataTips() : Boolean
      {
         return this._showDataTips;
      }
      
      public function set showDataTips(value:Boolean) : void
      {
         if(this._showDataTips == value)
         {
            return;
         }
         this._showDataTips = value;
         this.invalidateDisplayList();
         dispatchEvent(new Event("showDataTipsChanged"));
      }
      
      [Inspectable(category="Data")]
      [Bindable("typicalItemChanged")]
      public function get typicalItem() : Object
      {
         return this._typicalItem;
      }
      
      public function set typicalItem(value:Object) : void
      {
         if(this._typicalItem == value)
         {
            return;
         }
         this._typicalItem = value;
         this.invalidateTypicalItemRenderer();
         this.dispatchChangeEvent("typicalItemChanged");
      }
      
      public function invalidateTypicalItemRenderer() : void
      {
         this.typicalItemChanged = true;
         invalidateProperties();
         this.invalidateSize();
         this.invalidateDisplayList();
      }
      
      [Inspectable(category="General",defaultValue="false")]
      [Bindable("variableRowHeightChanged")]
      public function get variableRowHeight() : Boolean
      {
         return this._variableRowHeight;
      }
      
      public function set variableRowHeight(value:Boolean) : void
      {
         if(value == this.variableRowHeight)
         {
            return;
         }
         this._variableRowHeight = value;
         this.variableRowHeightChanged = true;
         invalidateProperties();
         this.dispatchChangeEvent("variableRowHeightChanged");
      }
      
      public function selectAll() : Boolean
      {
         if(invalidatePropertiesFlag)
         {
            UIComponentGlobals.layoutManager.validateClient(this,false);
         }
         var selectionChanged:Boolean = this.gridSelection.selectAll();
         if(selectionChanged)
         {
            this.initializeCaretPosition();
            this.invalidateDisplayListFor("selectionIndicator");
            this.dispatchFlexEvent(FlexEvent.VALUE_COMMIT);
         }
         return selectionChanged;
      }
      
      public function clearSelection() : Boolean
      {
         if(invalidatePropertiesFlag)
         {
            UIComponentGlobals.layoutManager.validateClient(this,false);
         }
         var selectionChanged:Boolean = this.gridSelection.removeAll();
         if(selectionChanged)
         {
            this.invalidateDisplayListFor("selectionIndicator");
            this.dispatchFlexEvent(FlexEvent.VALUE_COMMIT);
         }
         this.initializeCaretPosition();
         this.initializeAnchorPosition();
         return selectionChanged;
      }
      
      public function selectionContainsIndex(rowIndex:int) : Boolean
      {
         return this.gridSelection.containsRow(rowIndex);
      }
      
      public function selectionContainsIndices(rowIndices:Vector.<int>) : Boolean
      {
         return this.gridSelection.containsRows(rowIndices);
      }
      
      public function setSelectedIndex(rowIndex:int) : Boolean
      {
         if(invalidatePropertiesFlag)
         {
            UIComponentGlobals.layoutManager.validateClient(this,false);
         }
         var selectionChanged:Boolean = this.gridSelection.setRow(rowIndex);
         if(selectionChanged)
         {
            this.caretRowIndex = rowIndex;
            this.caretColumnIndex = -1;
            this.invalidateDisplayListFor("selectionIndicator");
            this.dispatchFlexEvent(FlexEvent.VALUE_COMMIT);
         }
         return selectionChanged;
      }
      
      public function addSelectedIndex(rowIndex:int) : Boolean
      {
         if(invalidatePropertiesFlag)
         {
            UIComponentGlobals.layoutManager.validateClient(this,false);
         }
         var selectionChanged:Boolean = this.gridSelection.addRow(rowIndex);
         if(selectionChanged)
         {
            this.caretRowIndex = rowIndex;
            this.caretColumnIndex = -1;
            this.invalidateDisplayListFor("selectionIndicator");
            this.dispatchFlexEvent(FlexEvent.VALUE_COMMIT);
         }
         return selectionChanged;
      }
      
      public function removeSelectedIndex(rowIndex:int) : Boolean
      {
         if(invalidatePropertiesFlag)
         {
            UIComponentGlobals.layoutManager.validateClient(this,false);
         }
         var selectionChanged:Boolean = this.gridSelection.removeRow(rowIndex);
         if(selectionChanged)
         {
            this.caretRowIndex = rowIndex;
            this.caretColumnIndex = -1;
            this.invalidateDisplayListFor("selectionIndicator");
            this.dispatchFlexEvent(FlexEvent.VALUE_COMMIT);
         }
         return selectionChanged;
      }
      
      public function selectIndices(rowIndex:int, rowCount:int) : Boolean
      {
         if(invalidatePropertiesFlag)
         {
            UIComponentGlobals.layoutManager.validateClient(this,false);
         }
         var selectionChanged:Boolean = this.gridSelection.setRows(rowIndex,rowCount);
         if(selectionChanged)
         {
            this.caretRowIndex = rowIndex + rowCount - 1;
            this.caretColumnIndex = -1;
            this.invalidateDisplayListFor("selectionIndicator");
            this.dispatchFlexEvent(FlexEvent.VALUE_COMMIT);
         }
         return selectionChanged;
      }
      
      public function selectionContainsCell(rowIndex:int, columnIndex:int) : Boolean
      {
         return this.gridSelection.containsCell(rowIndex,columnIndex);
      }
      
      public function selectionContainsCellRegion(rowIndex:int, columnIndex:int, rowCount:int, columnCount:int) : Boolean
      {
         return this.gridSelection.containsCellRegion(rowIndex,columnIndex,rowCount,columnCount);
      }
      
      public function setSelectedCell(rowIndex:int, columnIndex:int) : Boolean
      {
         if(invalidatePropertiesFlag)
         {
            UIComponentGlobals.layoutManager.validateClient(this,false);
         }
         var selectionChanged:Boolean = this.gridSelection.setCell(rowIndex,columnIndex);
         if(selectionChanged)
         {
            this.caretRowIndex = rowIndex;
            this.caretColumnIndex = columnIndex;
            this.invalidateDisplayListFor("selectionIndicator");
            this.dispatchFlexEvent(FlexEvent.VALUE_COMMIT);
         }
         return selectionChanged;
      }
      
      public function addSelectedCell(rowIndex:int, columnIndex:int) : Boolean
      {
         if(invalidatePropertiesFlag)
         {
            UIComponentGlobals.layoutManager.validateClient(this,false);
         }
         var selectionChanged:Boolean = this.gridSelection.addCell(rowIndex,columnIndex);
         if(selectionChanged)
         {
            this.caretRowIndex = rowIndex;
            this.caretColumnIndex = columnIndex;
            this.invalidateDisplayListFor("selectionIndicator");
            this.dispatchFlexEvent(FlexEvent.VALUE_COMMIT);
         }
         return selectionChanged;
      }
      
      public function removeSelectedCell(rowIndex:int, columnIndex:int) : Boolean
      {
         if(invalidatePropertiesFlag)
         {
            UIComponentGlobals.layoutManager.validateClient(this,false);
         }
         var selectionChanged:Boolean = this.gridSelection.removeCell(rowIndex,columnIndex);
         if(selectionChanged)
         {
            this.caretRowIndex = rowIndex;
            this.caretColumnIndex = columnIndex;
            this.invalidateDisplayListFor("selectionIndicator");
            this.dispatchFlexEvent(FlexEvent.VALUE_COMMIT);
         }
         return selectionChanged;
      }
      
      public function selectCellRegion(rowIndex:int, columnIndex:int, rowCount:uint, columnCount:uint) : Boolean
      {
         if(invalidatePropertiesFlag)
         {
            UIComponentGlobals.layoutManager.validateClient(this,false);
         }
         var selectionChanged:Boolean = this.gridSelection.setCellRegion(rowIndex,columnIndex,rowCount,columnCount);
         if(selectionChanged)
         {
            this.caretRowIndex = rowIndex + rowCount - 1;
            this.caretColumnIndex = columnIndex + columnCount - 1;
            this.invalidateDisplayListFor("selectionIndicator");
            this.dispatchFlexEvent(FlexEvent.VALUE_COMMIT);
         }
         return selectionChanged;
      }
      
      private function get gridDimensions() : GridDimensions
      {
         return this.gridLayout.gridDimensions;
      }
      
      private function scrollToIndex(elementIndex:int, scrollHorizontally:Boolean, scrollVertically:Boolean) : Boolean
      {
         var spDelta:Point = this.gridLayout.getScrollPositionDeltaToElement(elementIndex);
         if(!spDelta)
         {
            return false;
         }
         var scrollChanged:Boolean = false;
         if(scrollHorizontally)
         {
            horizontalScrollPosition += spDelta.x;
            scrollChanged = spDelta.x != 0;
         }
         if(scrollVertically)
         {
            verticalScrollPosition += spDelta.y;
            scrollChanged ||= spDelta.y != 0;
         }
         return scrollChanged;
      }
      
      public function ensureCellIsVisible(rowIndex:int = -1, columnIndex:int = -1) : void
      {
         var visibleRowIndices:Vector.<int> = null;
         var columns:IList = this.columns;
         if(!columns || columnIndex < -1 || columnIndex >= columns.length || !this.dataProvider || rowIndex < -1 || rowIndex >= this.dataProvider.length || columnIndex == -1 && rowIndex == -1)
         {
            return;
         }
         if(columnIndex == -1 && this.getNextVisibleColumnIndex(-1) == -1 || columnIndex != -1 && !GridColumn(columns.getItemAt(columnIndex)).visible)
         {
            return;
         }
         var columnsLength:int = int(columns.length);
         var scrollHorizontally:Boolean = columnIndex != -1;
         var scrollVertically:Boolean = rowIndex != -1;
         if(this.getVisibleRowIndices().length == 0 || this.getVisibleColumnIndices().length == 0)
         {
            validateNow();
         }
         if(!scrollHorizontally)
         {
            columnIndex = 0;
         }
         if(!scrollVertically)
         {
            visibleRowIndices = this.getVisibleRowIndices();
            rowIndex = visibleRowIndices.length > 0 ? visibleRowIndices[0] : 0;
         }
         var elementIndex:int = rowIndex * columnsLength + columnIndex;
         var scrollChanged:Boolean = false;
         var firstScroll:Boolean = true;
         while(true)
         {
            scrollChanged = this.scrollToIndex(elementIndex,scrollHorizontally,scrollVertically);
            if(!this.variableRowHeight && !scrollHorizontally)
            {
               break;
            }
            if(!firstScroll && !scrollChanged)
            {
               return;
            }
            validateNow();
            firstScroll = false;
            if(this.isCellVisible(scrollVertically ? rowIndex : -1,scrollHorizontally ? columnIndex : -1))
            {
               this.scrollToIndex(elementIndex,scrollHorizontally,scrollVertically);
               return;
            }
         }
      }
      
      public function getVisibleRowIndices() : Vector.<int>
      {
         return this.gridLayout.getVisibleRowIndices();
      }
      
      public function getVisibleColumnIndices() : Vector.<int>
      {
         return this.gridLayout.getVisibleColumnIndices();
      }
      
      public function getCellBounds(rowIndex:int, columnIndex:int) : Rectangle
      {
         return this.gridLayout.getCellBounds(rowIndex,columnIndex);
      }
      
      public function getRowBounds(rowIndex:int) : Rectangle
      {
         return this.gridLayout.getRowBounds(rowIndex);
      }
      
      public function getColumnBounds(columnIndex:int) : Rectangle
      {
         return this.gridLayout.getColumnBounds(columnIndex);
      }
      
      public function getRowIndexAt(x:Number, y:Number) : int
      {
         return this.gridLayout.getRowIndexAt(x,y);
      }
      
      public function getColumnIndexAt(x:Number, y:Number) : int
      {
         return this.gridLayout.getColumnIndexAt(x,y);
      }
      
      public function getColumnWidth(columnIndex:int) : Number
      {
         var column:GridColumn = this.getGridColumn(columnIndex);
         return Boolean(column) && !isNaN(column.width) ? column.width : this.gridDimensions.getColumnWidth(columnIndex);
      }
      
      public function getCellAt(x:Number, y:Number) : CellPosition
      {
         return this.gridLayout.getCellAt(x,y);
      }
      
      public function getCellsAt(x:Number, y:Number, w:Number, h:Number) : Vector.<CellPosition>
      {
         return this.gridLayout.getCellsAt(x,y,w,h);
      }
      
      public function getCellX(rowIndex:int, columnIndex:int) : Number
      {
         return this.gridDimensions.getCellX(rowIndex,columnIndex);
      }
      
      public function getCellY(rowIndex:int, columnIndex:int) : Number
      {
         return this.gridDimensions.getCellY(rowIndex,columnIndex);
      }
      
      public function getItemRendererAt(rowIndex:int, columnIndex:int) : IGridItemRenderer
      {
         return this.gridLayout.getItemRendererAt(rowIndex,columnIndex);
      }
      
      public function isCellVisible(rowIndex:int = -1, columnIndex:int = -1) : Boolean
      {
         return this.gridLayout.isCellVisible(rowIndex,columnIndex);
      }
      
      private function setInvalidateDisplayListReason(reason:String) : void
      {
         this.invalidateDisplayListReasonsMask |= invalidateDisplayListReasonBits[reason];
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function isInvalidateDisplayListReason(reason:String) : Boolean
      {
         var bit:uint = uint(invalidateDisplayListReasonBits[reason]);
         return (this.invalidateDisplayListReasonsMask & bit) == bit;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function clearInvalidateDisplayListReasons() : void
      {
         this.invalidateDisplayListReasonsMask = 0;
      }
      
      override public function invalidateSize() : void
      {
         if(!this.inUpdateDisplayList)
         {
            super.invalidateSize();
            this.dispatchChangeEvent("invalidateSize");
         }
      }
      
      override public function invalidateDisplayList() : void
      {
         if(!this.inUpdateDisplayList)
         {
            this.setInvalidateDisplayListReason("none");
            super.invalidateDisplayList();
            this.dispatchChangeEvent("invalidateDisplayList");
         }
      }
      
      override protected function commitProperties() : void
      {
         var oldColumns:IList = null;
         var savedRequireSelection:Boolean = false;
         var deferredOperation:Function = null;
         if(this.variableRowHeightChanged || this.rowHeightChanged)
         {
            if(this.rowHeightChanged)
            {
               this.gridDimensions.defaultRowHeight = this._rowHeight;
            }
            this.gridDimensions.variableRowHeight = this.variableRowHeight;
            if(!this.variableRowHeight && this.rowHeightChanged || this.variableRowHeightChanged)
            {
               this.clearGridLayoutCache(false);
               this.invalidateSize();
               this.invalidateDisplayList();
            }
            this.rowHeightChanged = false;
            this.variableRowHeightChanged = false;
         }
         if(this.itemRendererChanged || this.typicalItemChanged)
         {
            this.clearGridLayoutCache(true);
            this.itemRendererChanged = false;
         }
         if(!this.columns || this.generatedColumns && (this.typicalItemChanged || !this.typicalItem && this.dataProviderChanged))
         {
            oldColumns = this.columns;
            this.columns = this.generateColumns();
            this.generatedColumns = this.columns != null;
            this.columnsChanged = this.columns != oldColumns;
         }
         this.typicalItemChanged = false;
         if(this.dataProviderChanged || this.columnsChanged)
         {
            if(Boolean(this.gridSelection))
            {
               savedRequireSelection = this.gridSelection.requireSelection;
               this.gridSelection.requireSelection = false;
               this.gridSelection.removeAll();
               this.gridSelection.requireSelection = savedRequireSelection;
            }
            if(this.columnsChanged)
            {
               this.gridDimensions.columnCount = Boolean(this._columns) ? int(this._columns.length) : 0;
            }
            if(this.typicalItem != null && !this.columnsChanged)
            {
               this.clearGridLayoutCache(false);
            }
            else
            {
               this.clearGridLayoutCache(true);
            }
            if(!this.caretChanged)
            {
               this.initializeCaretPosition();
            }
            if(!this.anchorChanged)
            {
               this.initializeAnchorPosition();
            }
            this.dataProviderChanged = false;
            this.columnsChanged = false;
         }
         this.anchorChanged = false;
         if(Boolean(this.dataProvider))
         {
            for each(deferredOperation in this.deferredOperations)
            {
               deferredOperation();
            }
            this.deferredOperations.length = 0;
         }
         if(this.caretChanged)
         {
            if(Boolean(this._dataProvider) && this.caretRowIndex >= this._dataProvider.length)
            {
               this._caretRowIndex = this._dataProvider.length - 1;
            }
            if(Boolean(this._columns) && this.caretColumnIndex >= this._columns.length)
            {
               this._caretColumnIndex = this.getPreviousVisibleColumnIndex(this._columns.length - 1);
            }
            this.caretSelectedItem = Boolean(this._dataProvider) && this._caretRowIndex >= 0 ? this._dataProvider.getItemAt(this._caretRowIndex) : null;
            this.dispatchCaretChangeEvent();
            this._oldCaretRowIndex = this._caretRowIndex;
            this._oldCaretColumnIndex = this._caretColumnIndex;
            this.caretChanged = false;
         }
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         this.inUpdateDisplayList = true;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         this.inUpdateDisplayList = false;
         this.clearInvalidateDisplayListReasons();
         if(!this.variableRowHeight)
         {
            this.setFixedRowHeight(this.gridDimensions.getRowHeight(0));
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function invalidateDisplayListFor(reason:String) : void
      {
         if(!this.inUpdateDisplayList)
         {
            this.setInvalidateDisplayListReason(reason);
            super.invalidateDisplayList();
            this.dispatchChangeEvent("invalidateDisplayList");
         }
      }
      
      public function invalidateCell(rowIndex:int, columnIndex:int) : void
      {
         var visibleColumnIndices:Vector.<int> = null;
         var visibleColumnIndex:int = 0;
         var visibleRowIndices:Vector.<int> = null;
         var visibleRowIndex:int = 0;
         if(!this.dataProvider)
         {
            return;
         }
         var dataProviderLength:int = int(this.dataProvider.length);
         if(rowIndex >= this.dataProvider.length)
         {
            return;
         }
         if(!this.isCellVisible(rowIndex,columnIndex))
         {
            return;
         }
         if(Boolean(invalidateDisplayListFlag) || Boolean(invalidateSizeFlag))
         {
            return;
         }
         if(rowIndex >= 0 && columnIndex >= 0)
         {
            this.gridLayout.invalidateCell(rowIndex,columnIndex);
         }
         else if(rowIndex >= 0)
         {
            visibleColumnIndices = this.getVisibleColumnIndices();
            for each(visibleColumnIndex in visibleColumnIndices)
            {
               this.gridLayout.invalidateCell(rowIndex,visibleColumnIndex);
               if(Boolean(invalidateDisplayListFlag) || Boolean(invalidateSizeFlag))
               {
                  break;
               }
            }
         }
         else if(columnIndex >= 0)
         {
            visibleRowIndices = this.getVisibleRowIndices();
            for each(visibleRowIndex in visibleRowIndices)
            {
               if(visibleRowIndex >= dataProviderLength)
               {
                  break;
               }
               this.gridLayout.invalidateCell(visibleRowIndex,columnIndex);
               if(Boolean(invalidateDisplayListFlag) || Boolean(invalidateSizeFlag))
               {
                  break;
               }
            }
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function createGridSelection() : GridSelection
      {
         return new GridSelection();
      }
      
      private function getGridColumn(columnIndex:int) : GridColumn
      {
         var columns:IList = this.columns;
         if(columns == null || columnIndex < 0 || columnIndex >= columns.length)
         {
            return null;
         }
         return columns.getItemAt(columnIndex) as GridColumn;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getDataProviderItem(rowIndex:int) : Object
      {
         var dataProvider:IList = this.dataProvider;
         if(dataProvider == null || rowIndex >= dataProvider.length)
         {
            return null;
         }
         return dataProvider.getItemAt(rowIndex);
      }
      
      private function getVisibleItemRenderer(rowIndex:int, columnIndex:int) : IGridItemRenderer
      {
         var layout:GridLayout = layout as GridLayout;
         if(!layout)
         {
            return null;
         }
         return layout.getVisibleItemRenderer(rowIndex,columnIndex);
      }
      
      protected function grid_mouseDownDragUpHandler(event:MouseEvent) : void
      {
         var eventStageXY:Point = null;
         var eventGridXY:Point = null;
         var gridDimensions:GridDimensions = null;
         var gridEventType:String = null;
         eventStageXY = new Point(event.stageX,event.stageY);
         eventGridXY = globalToLocal(eventStageXY);
         gridDimensions = this.gridDimensions;
         var eventRowIndex:int = gridDimensions.getRowIndexAt(eventGridXY.x,eventGridXY.y);
         var eventColumnIndex:int = gridDimensions.getColumnIndexAt(eventGridXY.x,eventGridXY.y);
         switch(event.type)
         {
            case MouseEvent.MOUSE_MOVE:
               gridEventType = GridEvent.GRID_MOUSE_DRAG;
               break;
            case MouseEvent.MOUSE_UP:
               gridEventType = GridEvent.GRID_MOUSE_UP;
               break;
            case MouseEvent.MOUSE_DOWN:
               gridEventType = GridEvent.GRID_MOUSE_DOWN;
               this.mouseDownRowIndex = eventRowIndex;
               this.mouseDownColumnIndex = eventColumnIndex;
               this.dragInProgress = true;
         }
         this.dispatchGridEvent(event,gridEventType,eventGridXY,eventRowIndex,eventColumnIndex);
         if(gridEventType == GridEvent.GRID_MOUSE_UP)
         {
            this.dispatchGridClickEvents(event,eventGridXY,eventRowIndex,eventColumnIndex);
         }
      }
      
      protected function grid_mouseMoveHandler(event:MouseEvent) : void
      {
         var eventStageXY:Point = null;
         var eventGridXY:Point = null;
         var gridDimensions:GridDimensions = null;
         eventStageXY = new Point(event.stageX,event.stageY);
         eventGridXY = globalToLocal(eventStageXY);
         gridDimensions = this.gridDimensions;
         var eventRowIndex:int = gridDimensions.getRowIndexAt(eventGridXY.x,eventGridXY.y);
         var eventColumnIndex:int = gridDimensions.getColumnIndexAt(eventGridXY.x,eventGridXY.y);
         if(eventRowIndex != this.rollRowIndex || eventColumnIndex != this.rollColumnIndex)
         {
            if(this.rollRowIndex != -1 || this.rollColumnIndex != -1)
            {
               this.dispatchGridEvent(event,GridEvent.GRID_ROLL_OUT,eventGridXY,this.rollRowIndex,this.rollColumnIndex);
            }
            if(eventRowIndex != -1 && eventColumnIndex != -1)
            {
               this.dispatchGridEvent(event,GridEvent.GRID_ROLL_OVER,eventGridXY,eventRowIndex,eventColumnIndex);
            }
            this.rollRowIndex = eventRowIndex;
            this.rollColumnIndex = eventColumnIndex;
         }
      }
      
      protected function grid_mouseRollOutHandler(event:MouseEvent) : void
      {
         var eventStageXY:Point = null;
         var eventGridXY:Point = null;
         if(this.rollRowIndex != -1 || this.rollColumnIndex != -1)
         {
            eventStageXY = new Point(event.stageX,event.stageY);
            eventGridXY = globalToLocal(eventStageXY);
            this.dispatchGridEvent(event,GridEvent.GRID_ROLL_OUT,eventGridXY,this.rollRowIndex,this.rollColumnIndex);
            this.rollRowIndex = -1;
            this.rollColumnIndex = -1;
         }
      }
      
      protected function grid_mouseUpHandler(event:MouseEvent) : void
      {
         var eventStageXY:Point = null;
         var eventGridXY:Point = null;
         var gridDimensions:GridDimensions = null;
         if(this.dragInProgress)
         {
            this.dragInProgress = false;
            return;
         }
         eventStageXY = new Point(event.stageX,event.stageY);
         eventGridXY = globalToLocal(eventStageXY);
         gridDimensions = this.gridDimensions;
         var eventRowIndex:int = gridDimensions.getRowIndexAt(eventGridXY.x,eventGridXY.y);
         var eventColumnIndex:int = gridDimensions.getColumnIndexAt(eventGridXY.x,eventGridXY.y);
         this.dispatchGridEvent(event,GridEvent.GRID_MOUSE_UP,eventGridXY,eventRowIndex,eventColumnIndex);
         this.dispatchGridClickEvents(event,eventGridXY,eventRowIndex,eventColumnIndex);
      }
      
      private function dispatchGridClickEvents(mouseEvent:MouseEvent, gridXY:Point, rowIndex:int, columnIndex:int) : void
      {
         var dispatchGridClick:Boolean = rowIndex == this.mouseDownRowIndex && columnIndex == this.mouseDownColumnIndex;
         var newClickTime:Number = getTimer();
         if(Boolean(doubleClickEnabled) && dispatchGridClick && !isNaN(this.lastClickTime) && newClickTime - this.lastClickTime <= this.DOUBLE_CLICK_TIME)
         {
            this.dispatchGridEvent(mouseEvent,GridEvent.GRID_DOUBLE_CLICK,gridXY,rowIndex,columnIndex);
            this.lastClickTime = NaN;
            return;
         }
         if(dispatchGridClick)
         {
            this.dispatchGridEvent(mouseEvent,GridEvent.GRID_CLICK,gridXY,rowIndex,columnIndex);
            this.lastClickTime = newClickTime;
         }
      }
      
      private function dispatchGridEvent(mouseEvent:MouseEvent, type:String, gridXY:Point, rowIndex:int, columnIndex:int) : void
      {
         var itemRenderer:IGridItemRenderer = null;
         var bubbles:Boolean = false;
         var cancelable:Boolean = false;
         var relatedObject:InteractiveObject = null;
         var ctrlKey:Boolean = false;
         var altKey:Boolean = false;
         var shiftKey:Boolean = false;
         var buttonDown:Boolean = false;
         var delta:int = 0;
         var column:GridColumn = columnIndex >= 0 ? this.getGridColumn(columnIndex) : null;
         var item:Object = rowIndex >= 0 ? this.getDataProviderItem(rowIndex) : null;
         itemRenderer = this.getVisibleItemRenderer(rowIndex,columnIndex);
         bubbles = mouseEvent.bubbles;
         cancelable = mouseEvent.cancelable;
         relatedObject = mouseEvent.relatedObject;
         ctrlKey = mouseEvent.ctrlKey;
         altKey = mouseEvent.altKey;
         shiftKey = mouseEvent.shiftKey;
         buttonDown = mouseEvent.buttonDown;
         delta = mouseEvent.delta;
         var event:GridEvent = new GridEvent(type,bubbles,cancelable,gridXY.x,gridXY.y,relatedObject,ctrlKey,altKey,shiftKey,buttonDown,delta,rowIndex,columnIndex,column,item,itemRenderer);
         dispatchEvent(event);
      }
      
      private function updateCaretForDataProviderChange(event:CollectionEvent) : void
      {
         var newCaretRowIndex:int = 0;
         var oldLocation:int = 0;
         var oldVsp:int = 0;
         var cHeight:Number = NaN;
         var maximum:int = 0;
         var oldCaretRowIndex:int = this.caretRowIndex;
         var location:int = int(event.location);
         var itemsLength:int = Boolean(event.items) ? int(event.items.length) : 0;
         switch(event.kind)
         {
            case CollectionEventKind.ADD:
               if(oldCaretRowIndex >= location)
               {
                  this.caretRowIndex += event.items.length;
               }
               break;
            case CollectionEventKind.REMOVE:
               if(oldCaretRowIndex >= location)
               {
                  if(oldCaretRowIndex < location + itemsLength)
                  {
                     this.caretRowIndex = -1;
                  }
                  else
                  {
                     this.caretRowIndex -= itemsLength;
                  }
               }
               break;
            case CollectionEventKind.MOVE:
               oldLocation = int(event.oldLocation);
               if(oldCaretRowIndex >= oldLocation && oldCaretRowIndex < oldLocation + itemsLength)
               {
                  this.caretRowIndex += location - oldLocation;
               }
               break;
            case CollectionEventKind.REPLACE:
            case CollectionEventKind.UPDATE:
               break;
            case CollectionEventKind.REFRESH:
               newCaretRowIndex = Boolean(this.caretSelectedItem) ? int(this._dataProvider.getItemIndex(this.caretSelectedItem)) : -1;
               if(newCaretRowIndex != -1)
               {
                  this.caretRowIndex = newCaretRowIndex;
                  this.ensureCellIsVisible(this.caretRowIndex,-1);
               }
               else
               {
                  oldVsp = verticalScrollPosition;
                  validateNow();
                  cHeight = Math.ceil(this.gridDimensions.getContentHeight());
                  maximum = Math.max(cHeight - height,0);
                  verticalScrollPosition = oldVsp > maximum ? maximum : oldVsp;
               }
               break;
            case CollectionEventKind.RESET:
               newCaretRowIndex = Boolean(this.caretSelectedItem) ? int(this._dataProvider.getItemIndex(this.caretSelectedItem)) : -1;
               if(newCaretRowIndex != -1)
               {
                  this.caretRowIndex = newCaretRowIndex;
                  this.ensureCellIsVisible(this.caretRowIndex,-1);
               }
               else
               {
                  this.caretRowIndex = this._dataProvider.length > 0 ? 0 : -1;
                  verticalScrollPosition = 0;
               }
         }
      }
      
      private function updateCaretForColumnsChange(event:CollectionEvent) : void
      {
         var oldLocation:int = 0;
         var pe:PropertyChangeEvent = null;
         var i:int = 0;
         var column:GridColumn = null;
         var oldCaretColumnIndex:int = this.caretColumnIndex;
         var location:int = int(event.location);
         var itemsLength:int = Boolean(event.items) ? int(event.items.length) : 0;
         switch(event.kind)
         {
            case CollectionEventKind.ADD:
               if(oldCaretColumnIndex >= location)
               {
                  this.caretColumnIndex += itemsLength;
               }
               break;
            case CollectionEventKind.REMOVE:
               if(oldCaretColumnIndex >= location)
               {
                  if(oldCaretColumnIndex < location + itemsLength)
                  {
                     this.caretColumnIndex = this._columns.length > 0 ? 0 : -1;
                  }
                  else
                  {
                     this.caretColumnIndex -= itemsLength;
                  }
               }
               break;
            case CollectionEventKind.MOVE:
               oldLocation = int(event.oldLocation);
               if(oldCaretColumnIndex >= oldLocation && oldCaretColumnIndex < oldLocation + itemsLength)
               {
                  this.caretColumnIndex += location - oldLocation;
               }
               break;
            case CollectionEventKind.REPLACE:
               break;
            case CollectionEventKind.UPDATE:
               if(this.selectionMode == GridSelectionMode.SINGLE_CELL || this.selectionMode == GridSelectionMode.MULTIPLE_CELLS)
               {
                  for(i = 0; i < itemsLength; i++)
                  {
                     pe = event.items[i] as PropertyChangeEvent;
                     if(Boolean(pe) && pe.property == "visible")
                     {
                        column = pe.source as GridColumn;
                        if(!(!column || column.visible))
                        {
                           if(column.columnIndex == this.caretColumnIndex)
                           {
                              this.initializeCaretPosition(true);
                           }
                           if(column.columnIndex == this.anchorColumnIndex)
                           {
                              this.initializeAnchorPosition(true);
                           }
                        }
                     }
                  }
               }
               break;
            case CollectionEventKind.REFRESH:
            case CollectionEventKind.RESET:
               this.initializeCaretPosition(true);
               horizontalScrollPosition = 0;
         }
      }
      
      private function updateHoverForDataProviderChange(event:CollectionEvent) : void
      {
         var oldHoverRowIndex:int = this.hoverRowIndex;
         var location:int = int(event.location);
         switch(event.kind)
         {
            case CollectionEventKind.ADD:
            case CollectionEventKind.REMOVE:
            case CollectionEventKind.REPLACE:
            case CollectionEventKind.UPDATE:
            case CollectionEventKind.MOVE:
               if(oldHoverRowIndex >= location)
               {
                  this.hoverRowIndex = this.gridDimensions.getRowIndexAt(mouseX,mouseY);
               }
               break;
            case CollectionEventKind.REFRESH:
            case CollectionEventKind.RESET:
               this.hoverRowIndex = this.gridDimensions.getRowIndexAt(mouseX,mouseY);
         }
      }
      
      private function updateHoverForColumnsChange(event:CollectionEvent) : void
      {
         switch(event.kind)
         {
            case CollectionEventKind.ADD:
            case CollectionEventKind.REMOVE:
            case CollectionEventKind.REPLACE:
            case CollectionEventKind.UPDATE:
            case CollectionEventKind.MOVE:
               if(this.hoverColumnIndex >= event.location)
               {
                  this.hoverColumnIndex = this.gridDimensions.getColumnIndexAt(mouseX,mouseY);
               }
               break;
            case CollectionEventKind.REFRESH:
            case CollectionEventKind.RESET:
               this.hoverColumnIndex = this.gridDimensions.getColumnIndexAt(mouseX,mouseY);
         }
      }
      
      private function dataProvider_collectionChangeHandler(event:CollectionEvent) : void
      {
         if(!this.columns && this.dataProvider.length > 0)
         {
            this.columns = this.generateColumns();
            this.generatedColumns = this.columns != null;
            this.gridDimensions.columnCount = this.generatedColumns ? int(this.columns.length) : 0;
         }
         var gridDimenions:GridDimensions = this.gridDimensions;
         if(Boolean(this.gridDimensions))
         {
            this.gridDimensions.dataProviderCollectionChanged(event);
            this.gridDimensions.rowCount = this.dataProvider.length;
         }
         if(Boolean(this.gridLayout))
         {
            this.gridLayout.dataProviderCollectionChanged(event);
         }
         if(Boolean(this.gridSelection))
         {
            this.gridSelection.dataProviderCollectionChanged(event);
         }
         if(Boolean(this.gridDimensions) && this.hoverRowIndex != -1)
         {
            this.updateHoverForDataProviderChange(event);
         }
         this.invalidateSize();
         this.invalidateDisplayList();
         if(this.caretRowIndex != -1)
         {
            this.updateCaretForDataProviderChange(event);
         }
      }
      
      private function columns_collectionChangeHandler(event:CollectionEvent) : void
      {
         var column:GridColumn = null;
         var i:int = 0;
         var maxIndex:int = 0;
         var items:Array = null;
         var length:int = 0;
         var count:int = 0;
         var columnIndex:int = int(event.location);
         switch(event.kind)
         {
            case CollectionEventKind.ADD:
               while(columnIndex < this.columns.length)
               {
                  column = GridColumn(this.columns.getItemAt(columnIndex));
                  column.setGrid(this);
                  column.setColumnIndex(columnIndex);
                  columnIndex++;
               }
               break;
            case CollectionEventKind.MOVE:
               columnIndex = Math.min(event.oldLocation,event.location);
               maxIndex = Math.max(event.oldLocation,event.location);
               while(columnIndex <= maxIndex)
               {
                  column = GridColumn(this.columns.getItemAt(columnIndex));
                  column.setColumnIndex(columnIndex);
                  columnIndex++;
               }
               break;
            case CollectionEventKind.REPLACE:
               items = event.items;
               length = int(items.length);
               for(i = 0; i < length; i++)
               {
                  if(items[i].oldValue is GridColumn)
                  {
                     column = GridColumn(items[i].oldValue);
                     column.setGrid(null);
                     column.setColumnIndex(-1);
                  }
                  if(items[i].newValue is GridColumn)
                  {
                     column = GridColumn(items[i].newValue);
                     column.setGrid(this);
                     column.setColumnIndex(columnIndex);
                  }
               }
               break;
            case CollectionEventKind.UPDATE:
               break;
            case CollectionEventKind.REFRESH:
               for(columnIndex = 0; columnIndex < this.columns.length; columnIndex++)
               {
                  column = GridColumn(this.columns.getItemAt(columnIndex));
                  column.setColumnIndex(columnIndex);
               }
               break;
            case CollectionEventKind.REMOVE:
               count = int(event.items.length);
               for(i = 0; i < count; i++)
               {
                  column = GridColumn(event.items[i]);
                  column.setGrid(null);
                  column.setColumnIndex(-1);
               }
               while(columnIndex < this.columns.length)
               {
                  column = GridColumn(this.columns.getItemAt(columnIndex));
                  column.setColumnIndex(columnIndex);
                  columnIndex++;
               }
               break;
            case CollectionEventKind.RESET:
               for(columnIndex = 0; columnIndex < this.columns.length; columnIndex++)
               {
                  column = GridColumn(this.columns.getItemAt(columnIndex));
                  column.setGrid(this);
                  column.setColumnIndex(columnIndex);
               }
         }
         if(Boolean(this.gridDimensions))
         {
            this.gridDimensions.columnsCollectionChanged(event);
         }
         if(Boolean(this.gridLayout))
         {
            this.gridLayout.columnsCollectionChanged(event);
         }
         if(Boolean(this.gridSelection))
         {
            this.gridSelection.columnsCollectionChanged(event);
         }
         if(this.caretColumnIndex != -1)
         {
            this.updateCaretForColumnsChange(event);
         }
         if(Boolean(this.gridDimensions) && this.hoverColumnIndex != -1)
         {
            this.updateHoverForColumnsChange(event);
         }
         this.invalidateSize();
         this.invalidateDisplayList();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function clearGridLayoutCache(clearTypicalSizes:Boolean) : void
      {
         this.gridLayout.clearVirtualLayoutCache();
         var gridDimensions:GridDimensions = this.gridDimensions;
         if(Boolean(gridDimensions))
         {
            if(clearTypicalSizes)
            {
               gridDimensions.clearTypicalCellWidthsAndHeights();
            }
            gridDimensions.clearHeights();
            gridDimensions.rowCount = Boolean(this._dataProvider) ? int(this._dataProvider.length) : 0;
         }
         setContentSize(0,0);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getNextVisibleColumnIndex(index:int = -1) : int
      {
         var columns:IList = null;
         var column:GridColumn = null;
         if(index < -1)
         {
            return -1;
         }
         columns = this.columns;
         var columnsLength:int = Boolean(columns) ? int(columns.length) : 0;
         for(var i:int = index + 1; i < columnsLength; i++)
         {
            column = columns.getItemAt(i) as GridColumn;
            if(Boolean(column) && column.visible)
            {
               return i;
            }
         }
         return -1;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getPreviousVisibleColumnIndex(index:int) : int
      {
         var column:GridColumn = null;
         var columns:IList = this.columns;
         if(!columns || index > columns.length)
         {
            return -1;
         }
         for(var i:int = index - 1; i >= 0; i--)
         {
            column = columns.getItemAt(i) as GridColumn;
            if(Boolean(column) && column.visible)
            {
               return i;
            }
         }
         return -1;
      }
      
      private function initializeAnchorPosition(columnOnly:Boolean = false) : void
      {
         if(!columnOnly)
         {
            this.anchorRowIndex = Boolean(this._dataProvider) && this._dataProvider.length > 0 ? 0 : -1;
         }
         this.anchorColumnIndex = this.getNextVisibleColumnIndex();
      }
      
      private function initializeCaretPosition(columnOnly:Boolean = false) : void
      {
         if(!columnOnly)
         {
            this.caretRowIndex = Boolean(this._dataProvider) && this._dataProvider.length > 0 ? 0 : -1;
         }
         this.caretColumnIndex = this.getNextVisibleColumnIndex();
      }
      
      private function dispatchCaretChangeEvent() : void
      {
         var caretChangeEvent:GridCaretEvent = null;
         if(hasEventListener(GridCaretEvent.CARET_CHANGE))
         {
            caretChangeEvent = new GridCaretEvent(GridCaretEvent.CARET_CHANGE);
            caretChangeEvent.oldRowIndex = this._oldCaretRowIndex;
            caretChangeEvent.oldColumnIndex = this._oldCaretColumnIndex;
            caretChangeEvent.newRowIndex = this._caretRowIndex;
            caretChangeEvent.newColumnIndex = this._caretColumnIndex;
            dispatchEvent(caretChangeEvent);
         }
      }
   }
}

