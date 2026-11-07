package spark.components.gridClasses
{
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import mx.core.ClassFactory;
   import mx.core.IFactory;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.events.PropertyChangeEvent;
   import mx.formatters.IFormatter;
   import mx.styles.IAdvancedStyleClient;
   import mx.utils.ObjectUtil;
   import spark.collections.SortField;
   import spark.components.Grid;
   
   public class GridColumn extends EventDispatcher
   {
      
      private static var _defaultItemEditorFactory:IFactory;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public static const ERROR_TEXT:String = new String(" ");
      
      private var _grid:Grid = null;
      
      private var _columnIndex:int = -1;
      
      private var _dataField:String = null;
      
      private var dataFieldPath:Array = [];
      
      private var _dataTipField:String = null;
      
      private var _dataTipFormatter:IFormatter = null;
      
      private var dataTipFormatterStyleParentInvalid:Boolean = false;
      
      private var _dataTipFunction:Function = null;
      
      private var _editable:Boolean = true;
      
      private var _formatter:IFormatter = null;
      
      private var formatterStyleParentInvalid:Boolean = false;
      
      private var _headerRenderer:IFactory = null;
      
      private var _headerText:String;
      
      private var _imeMode:String = null;
      
      private var _itemEditor:IFactory = null;
      
      private var _itemRenderer:IFactory = null;
      
      private var _itemRendererFunction:Function = null;
      
      private var _labelFunction:Function = null;
      
      private var _width:Number = NaN;
      
      private var _minWidth:Number = 20;
      
      private var _maxWidth:Number = NaN;
      
      private var _rendererIsEditable:Boolean = false;
      
      private var _resizable:Boolean = true;
      
      private var _showDataTips:*;
      
      private var _sortable:Boolean = true;
      
      private var _sortCompareFunction:Function;
      
      private var _sortDescending:Boolean = false;
      
      private var _visible:Boolean = true;
      
      public function GridColumn(columnName:String = null)
      {
         super();
         if(Boolean(columnName))
         {
            this.dataField = this.headerText = columnName;
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static function get defaultItemEditorFactory() : IFactory
      {
         if(!_defaultItemEditorFactory)
         {
            _defaultItemEditorFactory = new ClassFactory(DefaultGridItemEditor);
         }
         return _defaultItemEditorFactory;
      }
      
      private static function dataFieldPathSortCompare(obj1:Object, obj2:Object, column:GridColumn) : int
      {
         var dataFieldPath:Array = null;
         var formatter:IFormatter = null;
         if(!obj1 && !obj2)
         {
            return 0;
         }
         if(!obj1)
         {
            return 1;
         }
         if(!obj2)
         {
            return -1;
         }
         dataFieldPath = column.dataField.split(".");
         formatter = column.formatter;
         var obj1String:String = column.itemToString(obj1,dataFieldPath,null,formatter);
         var obj2String:String = column.itemToString(obj2,dataFieldPath,null,formatter);
         if(obj1String < obj2String)
         {
            return -1;
         }
         if(obj1String > obj2String)
         {
            return 1;
         }
         return 0;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setGrid(value:Grid) : void
      {
         if(this._grid == value)
         {
            return;
         }
         this._grid = value;
         this.dispatchChangeEvent("gridChanged");
      }
      
      [Bindable("gridChanged")]
      public function get grid() : Grid
      {
         return this._grid;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setColumnIndex(value:int) : void
      {
         if(this._columnIndex == value)
         {
            return;
         }
         this._columnIndex = value;
         this.dispatchChangeEvent("columnIndexChanged");
      }
      
      [Bindable("columnIndexChanged")]
      public function get columnIndex() : int
      {
         return this._columnIndex;
      }
      
      [Bindable("dataFieldChanged")]
      public function get dataField() : String
      {
         return this._dataField;
      }
      
      public function set dataField(value:String) : void
      {
         if(this._dataField == value)
         {
            return;
         }
         this._dataField = value;
         if(value == null)
         {
            this.dataFieldPath = [];
         }
         else if(value.indexOf(".") != -1)
         {
            this.dataFieldPath = value.split(".");
         }
         else
         {
            this.dataFieldPath = [value];
         }
         this.invalidateGrid();
         if(Boolean(this.grid))
         {
            this.grid.clearGridLayoutCache(true);
         }
         this.dispatchChangeEvent("dataFieldChanged");
      }
      
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
         if(Boolean(this.grid))
         {
            this.grid.invalidateDisplayList();
         }
         this.dispatchChangeEvent("dataTipFieldChanged");
      }
      
      [Inspectable(category="General")]
      [Bindable("dataTipFormatterChanged")]
      public function get dataTipFormatter() : IFormatter
      {
         var asc:IAdvancedStyleClient = null;
         if(this.dataTipFormatterStyleParentInvalid && Boolean(this.grid))
         {
            asc = this._dataTipFormatter as IAdvancedStyleClient;
            if(Boolean(asc) && asc.styleParent != this.grid)
            {
               this.grid.addStyleClient(asc);
            }
            this.dataTipFormatterStyleParentInvalid = false;
         }
         return this._dataTipFormatter;
      }
      
      public function set dataTipFormatter(value:IFormatter) : void
      {
         var oldASC:IAdvancedStyleClient = null;
         if(this._dataTipFormatter == value)
         {
            return;
         }
         if(Boolean(this.grid) && Boolean(this._dataTipFormatter))
         {
            oldASC = this._dataTipFormatter as IAdvancedStyleClient;
            if(Boolean(oldASC) && oldASC.styleParent == this.grid)
            {
               this.grid.removeStyleClient(oldASC);
            }
         }
         this._dataTipFormatter = value;
         this.dataTipFormatterStyleParentInvalid = true;
         if(Boolean(this.grid))
         {
            this.grid.invalidateDisplayList();
         }
         this.dispatchChangeEvent("dataTipFormatterChanged");
      }
      
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
         if(Boolean(this.grid))
         {
            this.grid.invalidateDisplayList();
         }
         this.dispatchChangeEvent("dataTipFunctionChanged");
      }
      
      [Inspectable(category="General")]
      [Bindable("editableChanged")]
      public function get editable() : Boolean
      {
         return this._editable;
      }
      
      public function set editable(value:Boolean) : void
      {
         if(this._editable == value)
         {
            return;
         }
         this._editable = value;
         this.dispatchChangeEvent("editableChanged");
      }
      
      [Inspectable(category="General")]
      [Bindable("formatterChanged")]
      public function get formatter() : IFormatter
      {
         var asc:IAdvancedStyleClient = null;
         if(this.formatterStyleParentInvalid && Boolean(this.grid))
         {
            asc = this._formatter as IAdvancedStyleClient;
            if(Boolean(asc) && asc.styleParent != this.grid)
            {
               this.grid.addStyleClient(asc);
            }
            this.formatterStyleParentInvalid = false;
         }
         return this._formatter;
      }
      
      public function set formatter(value:IFormatter) : void
      {
         var oldASC:IAdvancedStyleClient = null;
         if(this._formatter == value)
         {
            return;
         }
         if(Boolean(this.grid) && Boolean(this._formatter))
         {
            oldASC = this._formatter as IAdvancedStyleClient;
            if(Boolean(oldASC) && oldASC.styleParent == this.grid)
            {
               this.grid.removeStyleClient(oldASC);
            }
         }
         this._formatter = value;
         this.formatterStyleParentInvalid = true;
         if(Boolean(this.grid))
         {
            this.invalidateGrid();
            this.grid.clearGridLayoutCache(true);
         }
         this.dispatchChangeEvent("formatterChanged");
      }
      
      [Bindable("headerRendererChanged")]
      public function get headerRenderer() : IFactory
      {
         return this._headerRenderer;
      }
      
      public function set headerRenderer(value:IFactory) : void
      {
         if(this._headerRenderer == value)
         {
            return;
         }
         this._headerRenderer = value;
         if(Boolean(this.grid))
         {
            this.grid.invalidateDisplayList();
         }
         this.dispatchChangeEvent("headerRendererChanged");
      }
      
      [Bindable("headerTextChanged")]
      public function get headerText() : String
      {
         return this._headerText != null ? this._headerText : (Boolean(this.dataField) ? this.dataField : "");
      }
      
      public function set headerText(value:String) : void
      {
         this._headerText = value;
         if(Boolean(this.grid))
         {
            this.grid.invalidateDisplayList();
         }
         this.dispatchChangeEvent("headerTextChanged");
      }
      
      [Inspectable(environment="none")]
      public function get imeMode() : String
      {
         return this._imeMode;
      }
      
      public function set imeMode(value:String) : void
      {
         this._imeMode = value;
      }
      
      [Bindable("itemEditorChanged")]
      public function get itemEditor() : IFactory
      {
         return this._itemEditor;
      }
      
      public function set itemEditor(value:IFactory) : void
      {
         if(this._itemEditor == value)
         {
            return;
         }
         this._itemEditor = value;
         this.dispatchChangeEvent("itemEditorChanged");
      }
      
      [Bindable("itemRendererChanged")]
      public function get itemRenderer() : IFactory
      {
         return Boolean(this._itemRenderer) ? this._itemRenderer : this.grid.itemRenderer;
      }
      
      public function set itemRenderer(value:IFactory) : void
      {
         if(this._itemRenderer == value)
         {
            return;
         }
         this._itemRenderer = value;
         this.invalidateGrid();
         if(Boolean(this.grid))
         {
            this.grid.clearGridLayoutCache(true);
         }
         this.dispatchChangeEvent("itemRendererChanged");
      }
      
      [Bindable("itemRendererFunctionChanged")]
      public function get itemRendererFunction() : Function
      {
         return this._itemRendererFunction;
      }
      
      public function set itemRendererFunction(value:Function) : void
      {
         if(this._itemRendererFunction == value)
         {
            return;
         }
         this._itemRendererFunction = value;
         this.invalidateGrid();
         if(Boolean(this.grid))
         {
            this.grid.clearGridLayoutCache(true);
         }
         this.dispatchChangeEvent("itemRendererFunctionChanged");
      }
      
      [Bindable("labelFunctionChanged")]
      public function get labelFunction() : Function
      {
         return this._labelFunction;
      }
      
      public function set labelFunction(value:Function) : void
      {
         if(this._labelFunction == value)
         {
            return;
         }
         this._labelFunction = value;
         this.invalidateGrid();
         if(Boolean(this.grid))
         {
            this.grid.clearGridLayoutCache(true);
         }
         this.dispatchChangeEvent("labelFunctionChanged");
      }
      
      [Bindable("widthChanged")]
      public function get width() : Number
      {
         return this._width;
      }
      
      public function set width(value:Number) : void
      {
         if(this._width == value)
         {
            return;
         }
         this._width = value;
         this.invalidateGrid();
         this.dispatchChangeEvent("widthChanged");
      }
      
      [Bindable("minWidthChanged")]
      public function get minWidth() : Number
      {
         return this._minWidth;
      }
      
      public function set minWidth(value:Number) : void
      {
         if(this._minWidth == value)
         {
            return;
         }
         this._minWidth = value;
         this.invalidateGrid();
         if(Boolean(this.grid))
         {
            this.grid.setContentSize(0,0);
         }
         this.dispatchChangeEvent("minWidthChanged");
      }
      
      [Bindable("maxWidthChanged")]
      public function get maxWidth() : Number
      {
         return this._maxWidth;
      }
      
      public function set maxWidth(value:Number) : void
      {
         if(this._maxWidth == value)
         {
            return;
         }
         this._maxWidth = value;
         this.invalidateGrid();
         if(Boolean(this.grid))
         {
            this.grid.setContentSize(0,0);
         }
         this.dispatchChangeEvent("maxWidthChanged");
      }
      
      [Bindable("rendererIsEditableChanged")]
      public function get rendererIsEditable() : Boolean
      {
         return this._rendererIsEditable;
      }
      
      public function set rendererIsEditable(value:Boolean) : void
      {
         if(this._rendererIsEditable == value)
         {
            return;
         }
         this._rendererIsEditable = value;
         this.dispatchChangeEvent("rendererIsEditableChanged");
      }
      
      [Inspectable(category="General")]
      [Bindable("resizableChanged")]
      public function get resizable() : Boolean
      {
         return this._resizable;
      }
      
      public function set resizable(value:Boolean) : void
      {
         if(this._resizable == value)
         {
            return;
         }
         this._resizable = value;
         this.dispatchChangeEvent("resizableChanged");
      }
      
      [Bindable("showDataTipsChanged")]
      public function get showDataTips() : *
      {
         return this._showDataTips;
      }
      
      public function set showDataTips(value:*) : void
      {
         if(this._showDataTips === value)
         {
            return;
         }
         this._showDataTips = value;
         if(Boolean(this.grid))
         {
            this.grid.invalidateDisplayList();
         }
         this.dispatchChangeEvent("showDataTipsChanged");
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getShowDataTips() : Boolean
      {
         return this.showDataTips === undefined ? Boolean(this.grid) && this.grid.showDataTips : Boolean(this.showDataTips);
      }
      
      [Inspectable(category="General")]
      [Bindable("sortableChanged")]
      public function get sortable() : Boolean
      {
         return this._sortable;
      }
      
      public function set sortable(value:Boolean) : void
      {
         if(this._sortable == value)
         {
            return;
         }
         this._sortable = value;
         this.dispatchChangeEvent("sortableChanged");
      }
      
      [Inspectable(category="Advanced")]
      [Bindable("sortCompareFunctionChanged")]
      public function get sortCompareFunction() : Function
      {
         return this._sortCompareFunction;
      }
      
      public function set sortCompareFunction(value:Function) : void
      {
         if(this._sortCompareFunction == value)
         {
            return;
         }
         this._sortCompareFunction = value;
         this.dispatchChangeEvent("sortCompareFunctionChanged");
      }
      
      [Bindable("sortDescendingChanged")]
      public function get sortDescending() : Boolean
      {
         return this._sortDescending;
      }
      
      public function set sortDescending(value:Boolean) : void
      {
         if(this._sortDescending == value)
         {
            return;
         }
         this._sortDescending = value;
         this.dispatchChangeEvent("sortDescendingChanged");
      }
      
      public function get sortField() : SortField
      {
         var cF:Function;
         var column:GridColumn = null;
         var sortField:SortField = null;
         column = this;
         var isComplexDataField:Boolean = this.dataFieldPath.length > 1;
         if(isComplexDataField)
         {
            sortField = new GridSortField();
            GridSortField(sortField).dataFieldPath = this.dataField;
         }
         else
         {
            sortField = new SortField(this.dataField);
         }
         cF = null;
         if(this._sortCompareFunction != null)
         {
            cF = function(a:Object, b:Object):int
            {
               return _sortCompareFunction(a,b,column);
            };
         }
         else if(isComplexDataField)
         {
            cF = function(a:Object, b:Object):int
            {
               return dataFieldPathSortCompare(a,b,column);
            };
         }
         else if(this.dataField == null && this._labelFunction != null)
         {
            cF = function(a:Object, b:Object):int
            {
               return ObjectUtil.stringCompare(_labelFunction(a,column),_labelFunction(b,column));
            };
         }
         sortField.compareFunction = cF;
         sortField.descending = column.sortDescending;
         return sortField;
      }
      
      [Bindable("visibleChanged")]
      public function get visible() : Boolean
      {
         return this._visible;
      }
      
      public function set visible(value:Boolean) : void
      {
         var propertyChangeEvent:PropertyChangeEvent = null;
         var collectionEvent:CollectionEvent = null;
         if(this._visible == value)
         {
            return;
         }
         this._visible = value;
         if(Boolean(this.grid) && Boolean(this.grid.columns))
         {
            propertyChangeEvent = PropertyChangeEvent.createUpdateEvent(this,"visible",!this._visible,this._visible);
            collectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
            collectionEvent.kind = CollectionEventKind.UPDATE;
            collectionEvent.items.push(propertyChangeEvent);
            this.grid.columns.dispatchEvent(collectionEvent);
         }
         this.dispatchChangeEvent("visibleChanged");
      }
      
      private function itemToString(item:Object, labelPath:Array, labelFunction:Function, formatter:IFormatter) : String
      {
         var itemData:Object = null;
         var pathElement:String = null;
         if(!item)
         {
            return ERROR_TEXT;
         }
         if(labelFunction != null)
         {
            return labelFunction(item,this);
         }
         var itemString:String = null;
         try
         {
            itemData = item;
            for each(pathElement in labelPath)
            {
               itemData = itemData[pathElement];
            }
            if(itemData != null && labelPath.length > 0)
            {
               itemString = Boolean(formatter) ? formatter.format(itemData) : itemData.toString();
            }
         }
         catch(ignored:Error)
         {
         }
         return itemString != null ? itemString : ERROR_TEXT;
      }
      
      public function itemToLabel(item:Object) : String
      {
         return this.itemToString(item,this.dataFieldPath,this.labelFunction,this.formatter);
      }
      
      public function itemToDataTip(item:Object) : String
      {
         var tipFunction:Function = this.dataTipFunction != null ? this.dataTipFunction : this.grid.dataTipFunction;
         var tipField:String = Boolean(this.dataTipField) ? this.dataTipField : this.grid.dataTipField;
         var tipPath:Array = Boolean(tipField) ? [tipField] : this.dataFieldPath;
         return this.itemToString(item,tipPath,tipFunction,this.dataTipFormatter);
      }
      
      public function itemToRenderer(item:Object) : IFactory
      {
         var itemRendererFunction:Function = this.itemRendererFunction;
         return itemRendererFunction != null ? itemRendererFunction(item,this) : this.itemRenderer;
      }
      
      private function dispatchChangeEvent(type:String) : void
      {
         if(hasEventListener(type))
         {
            dispatchEvent(new Event(type));
         }
      }
      
      private function invalidateGrid() : void
      {
         if(Boolean(this.grid))
         {
            this.grid.invalidateSize();
            this.grid.invalidateDisplayList();
         }
      }
   }
}

