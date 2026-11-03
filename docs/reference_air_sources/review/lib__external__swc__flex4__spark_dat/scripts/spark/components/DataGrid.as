package spark.components
{
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.geom.Rectangle;
   import flash.ui.Keyboard;
   import mx.collections.ICollectionView;
   import mx.collections.IList;
   import mx.collections.ISort;
   import mx.collections.ISortField;
   import mx.core.EventPriority;
   import mx.core.IFactory;
   import mx.core.IIMESupport;
   import mx.core.LayoutDirection;
   import mx.core.ScrollPolicy;
   import mx.core.UIComponent;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.managers.CursorManagerPriority;
   import mx.managers.IFocusManagerComponent;
   import mx.styles.AdvancedStyleClient;
   import spark.collections.Sort;
   import spark.components.gridClasses.CellPosition;
   import spark.components.gridClasses.CellRegion;
   import spark.components.gridClasses.DataGridEditor;
   import spark.components.gridClasses.GridColumn;
   import spark.components.gridClasses.GridLayout;
   import spark.components.gridClasses.GridSelection;
   import spark.components.gridClasses.GridSelectionMode;
   import spark.components.gridClasses.GridSortField;
   import spark.components.gridClasses.IDataGridElement;
   import spark.components.gridClasses.IGridItemEditor;
   import spark.components.supportClasses.SkinnableContainerBase;
   import spark.core.NavigationUnit;
   import spark.events.GridCaretEvent;
   import spark.events.GridEvent;
   import spark.events.GridSelectionEvent;
   import spark.events.GridSelectionEventKind;
   import spark.events.GridSortEvent;
   
   [IconFile("DataGrid.png")]
   [DiscouragedForProfile("mobileDevice")]
   [DefaultTriggerEvent("selectionChange")]
   [DefaultProperty("dataProvider")]
   [AccessibilityClass(implementation="spark.accessibility.DataGridAccImpl")]
   [Event(name="gridItemEditorSessionCancel",type="spark.events.GridItemEditorEvent")]
   [Event(name="gridItemEditorSessionSave",type="spark.events.GridItemEditorEvent")]
   [Event(name="gridItemEditorSessionStart",type="spark.events.GridItemEditorEvent")]
   [Event(name="gridItemEditorSessionStarting",type="spark.events.GridItemEditorEvent")]
   [Event(name="sortChange",type="spark.events.GridSortEvent")]
   [Event(name="sortChanging",type="spark.events.GridSortEvent")]
   [Event(name="selectionChange",type="spark.events.GridSelectionEvent")]
   [Event(name="selectionChanging",type="spark.events.GridSelectionEvent")]
   [Event(name="gridDoubleClick",type="spark.events.GridEvent")]
   [Event(name="gridClick",type="spark.events.GridEvent")]
   [Event(name="gridRollOut",type="spark.events.GridEvent")]
   [Event(name="gridRollOver",type="spark.events.GridEvent")]
   [Event(name="gridMouseUp",type="spark.events.GridEvent")]
   [Event(name="gridMouseDrag",type="spark.events.GridEvent")]
   [Event(name="gridMouseDown",type="spark.events.GridEvent")]
   [Event(name="caretChange",type="spark.events.GridCaretEvent")]
   [Style(name="verticalScrollPolicy",type="String",inherit="no",enumeration="off,on,auto")]
   [Style(name="horizontalScrollPolicy",type="String",inherit="no",enumeration="off,on,auto")]
   [Style(name="defaultDataGridItemEditor",type="Class",inherit="no")]
   [Style(name="typographicCase",type="String",enumeration="default,capsToSmallCaps,uppercase,lowercase,lowercaseToSmallCaps",inherit="yes")]
   [Style(name="trackingRight",type="Object",inherit="yes")]
   [Style(name="trackingLeft",type="Object",inherit="yes")]
   [Style(name="textJustify",type="String",enumeration="interWord,distribute",inherit="yes")]
   [Style(name="textDecoration",type="String",enumeration="none,underline",inherit="yes")]
   [Style(name="textAlpha",type="Number",inherit="yes",minValue="0.0",maxValue="1.0")]
   [Style(name="textAlignLast",type="String",enumeration="start,end,left,right,center,justify",inherit="yes")]
   [Style(name="textAlign",type="String",enumeration="start,end,left,right,center,justify",inherit="yes")]
   [Style(name="renderingMode",type="String",enumeration="cff,normal",inherit="yes")]
   [Style(name="locale",type="String",inherit="yes")]
   [Style(name="lineThrough",type="Boolean",inherit="yes")]
   [Style(name="lineHeight",type="Object",inherit="yes")]
   [Style(name="ligatureLevel",type="String",enumeration="common,minimum,uncommon,exotic",inherit="yes")]
   [Style(name="letterSpacing",type="Number",inherit="yes",theme="mobile")]
   [Style(name="leading",type="Number",format="Length",inherit="yes",theme="mobile")]
   [Style(name="kerning",type="String",enumeration="auto,on,off",inherit="yes")]
   [Style(name="justificationStyle",type="String",enumeration="auto,prioritizeLeastAdjustment,pushInKinsoku,pushOutOnly",inherit="yes")]
   [Style(name="justificationRule",type="String",enumeration="auto,space,eastAsian",inherit="yes")]
   [Style(name="fontWeight",type="String",enumeration="normal,bold",inherit="yes")]
   [Style(name="fontStyle",type="String",enumeration="normal,italic",inherit="yes")]
   [Style(name="fontSize",type="Number",format="Length",inherit="yes",minValue="1.0",maxValue="720.0")]
   [Style(name="fontLookup",type="String",enumeration="auto,device,embeddedCFF",inherit="yes")]
   [Style(name="fontFamily",type="String",inherit="yes")]
   [Style(name="dominantBaseline",type="String",enumeration="auto,roman,ascent,descent,ideographicTop,ideographicCenter,ideographicBottom",inherit="yes")]
   [Style(name="direction",type="String",enumeration="ltr,rtl",inherit="yes")]
   [Style(name="digitWidth",type="String",enumeration="default,proportional,tabular",inherit="yes")]
   [Style(name="digitCase",type="String",enumeration="default,lining,oldStyle",inherit="yes")]
   [Style(name="color",type="uint",format="Color",inherit="yes")]
   [Style(name="cffHinting",type="String",enumeration="horizontalStem,none",inherit="yes")]
   [Style(name="baselineShift",type="Object",inherit="yes")]
   [Style(name="alignmentBaseline",type="String",enumeration="useDominantBaseline,roman,ascent,descent,ideographicTop,ideographicCenter,ideographicBottom",inherit="yes")]
   [Style(name="symbolColor",type="uint",format="Color",inherit="yes",theme="spark, mobile")]
   [Style(name="stretchCursor",type="Class",inherit="no")]
   [Style(name="selectionColor",type="uint",format="Color",inherit="yes",theme="spark, mobile")]
   [Style(name="rollOverColor",type="uint",format="Color",inherit="yes",theme="spark")]
   [Style(name="contentBackgroundColor",type="uint",format="Color",inherit="yes",theme="spark")]
   [Style(name="contentBackgroundAlpha",type="Number",inherit="yes",theme="spark",minValue="0.0",maxValue="1.0")]
   [Style(name="caretColor",type="uint",format="Color",inherit="yes",theme="spark")]
   [Style(name="borderVisible",type="Boolean",inherit="no",theme="spark")]
   [Style(name="borderColor",type="uint",format="Color",inherit="no",theme="spark")]
   [Style(name="borderAlpha",type="Number",inherit="no",theme="spark",minValue="0.0",maxValue="1.0")]
   [Style(name="alternatingRowColors",type="Array",arrayType="uint",format="Color",inherit="no",theme="spark")]
   public class DataGrid extends SkinnableContainerBase implements IFocusManagerComponent, IIMESupport
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static var createAccessibilityImplementation:Function;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static const factorySkinPartNames:Array = ["alternatingRowColorsBackground","caretIndicator","columnSeparator","headerColumnSeparator","hoverIndicator","rowBackground","rowSeparator","selectionIndicator"];
      
      private static const partPropertyBits:Object = {
         "columns":uint(1 << 0),
         "dataProvider":uint(1 << 1),
         "itemRenderer":uint(1 << 2),
         "requestedRowCount":uint(1 << 3),
         "requestedColumnCount":uint(1 << 4),
         "requestedMaxRowCount":uint(1 << 5),
         "requestedMinRowCount":uint(1 << 6),
         "requestedMinColumnCount":uint(1 << 7),
         "rowHeight":uint(1 << 8),
         "showDataTips":uint(1 << 9),
         "typicalItem":uint(1 << 10),
         "variableRowHeight":uint(1 << 11),
         "dataTipField":uint(1 << 12),
         "dataTipFunction":uint(1 << 13),
         "resizableColumns":uint(1 << 14)
      };
      
      private static const gridPropertyDefaults:Object = {
         "columns":null,
         "dataProvider":null,
         "itemRenderer":null,
         "resizableColumns":true,
         "requestedRowCount":int(-1),
         "requestedMaxRowCount":int(10),
         "requestedMinRowCount":int(-1),
         "requestedColumnCount":int(-1),
         "requestedMinColumnCount":int(-1),
         "rowHeight":NaN,
         "showDataTips":false,
         "typicalItem":null,
         "variableRowHeight":false,
         "dataTipField":null,
         "dataTipFunction":null
      };
      
      private static var _skinParts:Object = {
         "grid":false,
         "scroller":false,
         "alternatingRowColorsBackground":false,
         "editorIndicator":false,
         "selectionIndicator":false,
         "caretIndicator":false,
         "rowBackground":false,
         "columnSeparator":false,
         "rowSeparator":false,
         "columnHeaderGroup":false,
         "hoverIndicator":false
      };
      
      private var updateHoverOnRollOver:Boolean = true;
      
      private var _1277490047alternatingRowColorsBackground:IFactory;
      
      private var _502679092caretIndicator:IFactory;
      
      private var _1482148164columnHeaderGroup:GridColumnHeaderGroup;
      
      private var _237342767columnSeparator:IFactory;
      
      private var _1555036382editorIndicator:IFactory;
      
      private var _3181382grid:Grid;
      
      private var _1933789133hoverIndicator:IFactory;
      
      private var _367467864rowBackground:IFactory;
      
      private var _1763950123rowSeparator:IFactory;
      
      private var _402164678scroller:Scroller;
      
      private var _627206627selectionIndicator:IFactory;
      
      private const deferredGridOperations:Vector.<Function> = new Vector.<Function>();
      
      private var gridProperties:Object = new Object();
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var doubleClickTime:Number = 620;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var editKey:uint = 113;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var editOnDoubleClick:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var editor:DataGridEditor;
      
      private var _editable:Boolean = false;
      
      private var _gridSelection:GridSelection = null;
      
      private var _imeMode:String = null;
      
      private var _itemEditor:IFactory = null;
      
      private var _sortableColumns:Boolean = true;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var focusOwner:UIComponent;
      
      private var focusOwnerWidth:Number = 1;
      
      private var focusOwnerHeight:Number = 1;
      
      private var scrollerEvent:KeyboardEvent = null;
      
      private var stretchCursorID:int = 0;
      
      private var resizeColumn:GridColumn = null;
      
      private var resizeAnchorX:Number = NaN;
      
      private var resizeColumnWidth:Number = NaN;
      
      private var nextColumn:GridColumn = null;
      
      private var nextColumnWidth:Number = NaN;
      
      public function DataGrid()
      {
         super();
         addEventListener(Event.SELECT_ALL,this.selectAllHandler);
      }
      
      private static function getPartProperty(part:Object, properties:Object, propertyName:String, defaults:Object) : *
      {
         if(Boolean(part))
         {
            return part[propertyName];
         }
         var value:* = properties[propertyName];
         return value === undefined ? defaults[propertyName] : value;
      }
      
      private static function setPartProperty(part:Object, properties:Object, propertyName:String, value:*, defaults:Object) : Boolean
      {
         if(getPartProperty(part,properties,propertyName,defaults) === value)
         {
            return false;
         }
         var defaultValue:* = defaults[propertyName];
         if(Boolean(part))
         {
            part[propertyName] = value;
            if(value === defaultValue)
            {
               properties.propertyBits &= ~partPropertyBits[propertyName];
            }
            else
            {
               properties.propertyBits |= partPropertyBits[propertyName];
            }
         }
         else if(value === defaultValue)
         {
            delete properties[propertyName];
         }
         else
         {
            properties[propertyName] = value;
         }
         return true;
      }
      
      private static function findSortField(dataField:String, fields:Array, isComplexDataField:Boolean) : ISortField
      {
         var field:ISortField = null;
         var name:String = null;
         if(dataField == null)
         {
            return null;
         }
         for each(field in fields)
         {
            name = field.name;
            if(isComplexDataField && field is GridSortField)
            {
               name = GridSortField(field).dataFieldPath;
            }
            if(name == dataField)
            {
               return field;
            }
         }
         return null;
      }
      
      private function initializeGridRowBackground() : void
      {
         if(!this.grid)
         {
            return;
         }
         if(Boolean(getStyle("alternatingRowColors") as Array) && Boolean(this.alternatingRowColorsBackground))
         {
            this.grid.rowBackground = this.alternatingRowColorsBackground;
         }
         else
         {
            this.grid.rowBackground = this.rowBackground;
         }
      }
      
      private function getGridProperty(propertyName:String) : *
      {
         return getPartProperty(this.grid,this.gridProperties,propertyName,gridPropertyDefaults);
      }
      
      private function setGridProperty(propertyName:String, value:*) : Boolean
      {
         return setPartProperty(this.grid,this.gridProperties,propertyName,value,gridPropertyDefaults);
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
      
      [Inspectable(category="General")]
      [Bindable("columnsChanged")]
      public function get columns() : IList
      {
         return this.getGridProperty("columns");
      }
      
      public function set columns(value:IList) : void
      {
         if(this.setGridProperty("columns",value))
         {
            if(Boolean(this.columnHeaderGroup))
            {
               this.columnHeaderGroup.layout.clearVirtualLayoutCache();
               this.columnHeaderGroup.invalidateSize();
               this.columnHeaderGroup.invalidateDisplayList();
            }
            this.dispatchChangeEvent("columnsChanged");
         }
      }
      
      private function getColumnAt(columnIndex:int) : GridColumn
      {
         var grid:Grid = this.grid;
         if(!grid || !grid.columns)
         {
            return null;
         }
         var columns:IList = grid.columns;
         return columnIndex >= 0 && columnIndex < columns.length ? columns.getItemAt(columnIndex) as GridColumn : null;
      }
      
      public function get columnsLength() : int
      {
         var columns:IList = this.columns;
         return Boolean(columns) ? int(columns.length) : 0;
      }
      
      [Inspectable(category="Data")]
      [Bindable("dataProviderChanged")]
      public function get dataProvider() : IList
      {
         return this.getGridProperty("dataProvider");
      }
      
      public function set dataProvider(value:IList) : void
      {
         if(this.setGridProperty("dataProvider",value))
         {
            this.dispatchChangeEvent("dataProviderChanged");
         }
      }
      
      public function get dataProviderLength() : int
      {
         var dataProvider:IList = this.dataProvider;
         return Boolean(dataProvider) ? int(dataProvider.length) : 0;
      }
      
      [Inspectable(category="Data",defaultValue="null")]
      [Bindable("dataTipFieldChanged")]
      public function get dataTipField() : String
      {
         return this.getGridProperty("dataTipField");
      }
      
      public function set dataTipField(value:String) : void
      {
         if(this.setGridProperty("dataTipField",value))
         {
            this.dispatchChangeEvent("dataTipFieldChanged");
         }
      }
      
      [Inspectable(category="Data")]
      [Bindable("dataTipFunctionChanged")]
      public function get dataTipFunction() : Function
      {
         return this.getGridProperty("dataTipFunction");
      }
      
      public function set dataTipFunction(value:Function) : void
      {
         if(this.setGridProperty("dataTipFunction",value))
         {
            this.dispatchChangeEvent("dataTipFunctionChanged");
         }
      }
      
      [Inspectable(category="General",defaultValue="false")]
      public function get editable() : Boolean
      {
         return this._editable;
      }
      
      public function set editable(value:Boolean) : void
      {
         this._editable = value;
      }
      
      public function get editorColumnIndex() : int
      {
         if(Boolean(this.editor))
         {
            return this.editor.editorColumnIndex;
         }
         return -1;
      }
      
      public function get editorRowIndex() : int
      {
         if(Boolean(this.editor))
         {
            return this.editor.editorRowIndex;
         }
         return -1;
      }
      
      public function get enableIME() : Boolean
      {
         return false;
      }
      
      protected function get gridSelection() : GridSelection
      {
         if(!this._gridSelection)
         {
            this._gridSelection = this.createGridSelection();
         }
         return this._gridSelection;
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
      
      public function get itemEditorInstance() : IGridItemEditor
      {
         if(Boolean(this.editor))
         {
            return this.editor.itemEditorInstance;
         }
         return null;
      }
      
      [Inspectable(category="Data")]
      [Bindable("itemRendererChanged")]
      public function get itemRenderer() : IFactory
      {
         return this.getGridProperty("itemRenderer");
      }
      
      public function set itemRenderer(value:IFactory) : void
      {
         if(this.setGridProperty("itemRenderer",value))
         {
            this.dispatchChangeEvent("itemRendererChanged");
         }
      }
      
      [Inspectable(category="General",defaultValue="true")]
      public function get preserveSelection() : Boolean
      {
         if(Boolean(this.grid))
         {
            return this.grid.preserveSelection;
         }
         return this.gridSelection.preserveSelection;
      }
      
      public function set preserveSelection(value:Boolean) : void
      {
         if(Boolean(this.grid))
         {
            this.grid.preserveSelection = value;
         }
         else
         {
            this.gridSelection.preserveSelection = value;
         }
      }
      
      [Inspectable(category="General",defaultValue="false")]
      public function get requireSelection() : Boolean
      {
         if(Boolean(this.grid))
         {
            return this.grid.requireSelection;
         }
         return this.gridSelection.requireSelection;
      }
      
      public function set requireSelection(value:Boolean) : void
      {
         if(Boolean(this.grid))
         {
            this.grid.requireSelection = value;
         }
         else
         {
            this.gridSelection.requireSelection = value;
         }
      }
      
      [Inspectable(category="General",minValue="-1")]
      public function get requestedRowCount() : int
      {
         return this.getGridProperty("requestedRowCount");
      }
      
      public function set requestedRowCount(value:int) : void
      {
         this.setGridProperty("requestedRowCount",value);
      }
      
      [Inspectable(category="General",minValue="-1")]
      public function get requestedColumnCount() : int
      {
         return this.getGridProperty("requestedColumnCount");
      }
      
      public function set requestedColumnCount(value:int) : void
      {
         this.setGridProperty("requestedColumnCount",value);
      }
      
      [Inspectable(category="General",defaultValue="10",minValue="-1")]
      public function get requestedMaxRowCount() : int
      {
         return this.getGridProperty("requestedMaxRowCount");
      }
      
      public function set requestedMaxRowCount(value:int) : void
      {
         this.setGridProperty("requestedMaxRowCount",value);
      }
      
      [Inspectable(category="General",minValue="-1")]
      public function get requestedMinRowCount() : int
      {
         return this.getGridProperty("requestedMinRowCount");
      }
      
      public function set requestedMinRowCount(value:int) : void
      {
         this.setGridProperty("requestedMinRowCount",value);
      }
      
      [Inspectable(category="General",minValue="-1")]
      public function get requestedMinColumnCount() : int
      {
         return this.getGridProperty("requestedMinColumnCount");
      }
      
      public function set requestedMinColumnCount(value:int) : void
      {
         this.setGridProperty("requestedMinColumnCount",value);
      }
      
      [Inspectable(category="General",defaultValue="true")]
      [Bindable("resizableColumnsChanged")]
      public function get resizableColumns() : Boolean
      {
         return this.getGridProperty("resizableColumns");
      }
      
      public function set resizableColumns(value:Boolean) : void
      {
         if(this.setGridProperty("resizableColumns",value))
         {
            this.dispatchChangeEvent("resizableColumnsChanged");
         }
      }
      
      [Inspectable(category="General",minValue="0.0")]
      [Bindable("rowHeightChanged")]
      public function get rowHeight() : Number
      {
         return this.getGridProperty("rowHeight");
      }
      
      public function set rowHeight(value:Number) : void
      {
         if(this.setGridProperty("rowHeight",value))
         {
            this.dispatchChangeEvent("rowHeightChanged");
         }
      }
      
      [Inspectable(category="General",enumeration="none,singleRow,multipleRows,singleCell,multipleCells",defaultValue="singleRow")]
      [Bindable("selectionModeChanged")]
      public function get selectionMode() : String
      {
         if(Boolean(this.grid))
         {
            return this.grid.selectionMode;
         }
         return this.gridSelection.selectionMode;
      }
      
      public function set selectionMode(value:String) : void
      {
         if(this.selectionMode == value)
         {
            return;
         }
         if(Boolean(this.grid))
         {
            this.grid.selectionMode = value;
         }
         else
         {
            this.gridSelection.selectionMode = value;
         }
         if(Boolean(this.grid) && Boolean(this.grid.layout is GridLayout) && Boolean(this.caretIndicator))
         {
            GridLayout(this.grid.layout).showCaret = value != GridSelectionMode.NONE && this == getFocus();
         }
         this.dispatchChangeEvent("selectionModeChanged");
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function isRowSelectionMode() : Boolean
      {
         var mode:String = this.selectionMode;
         return mode == GridSelectionMode.SINGLE_ROW || mode == GridSelectionMode.MULTIPLE_ROWS;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function isCellSelectionMode() : Boolean
      {
         var mode:String = this.selectionMode;
         return mode == GridSelectionMode.SINGLE_CELL || mode == GridSelectionMode.MULTIPLE_CELLS;
      }
      
      [Inspectable(category="Data",defaultValue="false")]
      [Bindable("showDataTipsChanged")]
      public function get showDataTips() : Boolean
      {
         return this.getGridProperty("showDataTips");
      }
      
      public function set showDataTips(value:Boolean) : void
      {
         if(this.setGridProperty("showDataTips",value))
         {
            this.dispatchChangeEvent("showDataTipsChanged");
         }
      }
      
      [Inspectable(category="General",defaultValue="true")]
      [Bindable("sortableColumnsChanged")]
      public function get sortableColumns() : Boolean
      {
         return this._sortableColumns;
      }
      
      public function set sortableColumns(value:Boolean) : void
      {
         if(this._sortableColumns == value)
         {
            return;
         }
         this._sortableColumns = value;
         this.dispatchChangeEvent("sortableColumnsChanged");
      }
      
      [Inspectable(category="Data")]
      [Bindable("typicalItemChanged")]
      public function get typicalItem() : Object
      {
         return this.getGridProperty("typicalItem");
      }
      
      public function set typicalItem(value:Object) : void
      {
         if(this.setGridProperty("typicalItem",value))
         {
            this.dispatchChangeEvent("typicalItemChanged");
         }
      }
      
      public function invalidateTypicalItem() : void
      {
         if(Boolean(this.grid))
         {
            this.grid.invalidateTypicalItemRenderer();
         }
      }
      
      [Inspectable(category="General",defaultValue="false")]
      [Bindable("variableRowHeightChanged")]
      public function get variableRowHeight() : Boolean
      {
         return this.getGridProperty("variableRowHeight");
      }
      
      public function set variableRowHeight(value:Boolean) : void
      {
         if(this.setGridProperty("variableRowHeight",value))
         {
            this.dispatchChangeEvent("variableRowHeightChanged");
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.focusOwner = new UIComponent();
         var g:Graphics = this.focusOwner.graphics;
         g.clear();
         g.lineStyle(0,0,0);
         g.drawRect(0,0,this.focusOwnerWidth,this.focusOwnerHeight);
         $addChild(this.focusOwner);
         this.focusOwner.tabEnabled = true;
         this.focusOwner.tabIndex = tabIndex;
         this.focusOwner.$visible = true;
      }
      
      override public function set nestLevel(value:int) : void
      {
         super.nestLevel = value;
         if(Boolean(this.grid))
         {
            this.initializeDataGridElement(this.columnHeaderGroup);
         }
      }
      
      override public function set tabIndex(index:int) : void
      {
         super.tabIndex = index;
         if(Boolean(this.focusOwner))
         {
            this.focusOwner.tabIndex = index;
         }
      }
      
      override public function set accessibilityDescription(value:String) : void
      {
         super.accessibilityDescription = value;
         if(Boolean(this.focusOwner))
         {
            this.focusOwner.accessibilityDescription = value;
         }
      }
      
      override public function set accessibilityShortcut(value:String) : void
      {
         super.accessibilityShortcut = value;
         if(Boolean(this.focusOwner))
         {
            this.focusOwner.accessibilityShortcut = value;
         }
      }
      
      override protected function initializeAccessibility() : void
      {
         if(DataGrid.createAccessibilityImplementation != null)
         {
            DataGrid.createAccessibilityImplementation(this);
         }
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var g:Graphics = null;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(Boolean(this.focusOwner) && (this.focusOwnerWidth != unscaledWidth || this.focusOwnerHeight != unscaledHeight))
         {
            this.focusOwnerWidth = unscaledWidth;
            this.focusOwnerHeight = unscaledHeight;
            g = this.focusOwner.graphics;
            g.clear();
            g.lineStyle(0,0,0);
            g.drawRect(0,0,this.focusOwnerWidth,this.focusOwnerHeight);
         }
      }
      
      override public function setFocus() : void
      {
         if(Boolean(this.grid))
         {
            this.focusOwner.setFocus();
         }
      }
      
      override protected function isOurFocus(target:DisplayObject) : Boolean
      {
         return target == this.focusOwner || Boolean(super.isOurFocus(target));
      }
      
      override public function styleChanged(styleName:String) : void
      {
         var vsp:String = null;
         var hsp:String = null;
         super.styleChanged(styleName);
         var allStyles:Boolean = styleName == null || styleName == "styleName";
         if(Boolean(this.grid))
         {
            if(allStyles || Boolean(styleManager.isSizeInvalidatingStyle(styleName)))
            {
               if(Boolean(this.grid))
               {
                  this.grid.invalidateSize();
                  this.grid.clearGridLayoutCache(true);
               }
               if(Boolean(this.columnHeaderGroup))
               {
                  this.columnHeaderGroup.layout.clearVirtualLayoutCache();
                  this.columnHeaderGroup.invalidateSize();
               }
            }
            if(allStyles || styleName == "alternatingRowColors")
            {
               this.initializeGridRowBackground();
               if(Boolean(this.grid) && Boolean(this.grid.layout))
               {
                  this.grid.layout.clearVirtualLayoutCache();
               }
            }
            if(Boolean(this.grid))
            {
               this.grid.invalidateDisplayList();
            }
            if(Boolean(this.columnHeaderGroup))
            {
               this.columnHeaderGroup.invalidateDisplayList();
            }
         }
         if(Boolean(this.scroller))
         {
            vsp = getStyle("verticalScrollPolicy");
            if(styleName == "verticalScrollPolicy")
            {
               this.scroller.setStyle("verticalScrollPolicy",vsp);
            }
            else if(Boolean(allStyles) && Boolean(vsp) && vsp !== ScrollPolicy.AUTO)
            {
               this.scroller.setStyle("verticalScrollPolicy",vsp);
            }
            hsp = getStyle("horizontalScrollPolicy");
            if(styleName == "horizontalScrollPolicy")
            {
               this.scroller.setStyle("horizontalScrollPolicy",hsp);
            }
            else if(Boolean(allStyles) && Boolean(hsp) && hsp !== ScrollPolicy.AUTO)
            {
               this.scroller.setStyle("horizontalScrollPolicy",hsp);
            }
         }
      }
      
      override protected function keyDownHandler(event:KeyboardEvent) : void
      {
         var op:String = null;
         if(!this.grid || event.isDefaultPrevented())
         {
            return;
         }
         if(event == this.scrollerEvent)
         {
            this.scrollerEvent = null;
            event.preventDefault();
            return;
         }
         if(!this.isOurFocus(DisplayObject(event.target)))
         {
            return;
         }
         if(event.keyCode == Keyboard.A && event.ctrlKey)
         {
            this.selectAllFromKeyboard();
            event.preventDefault();
            return;
         }
         if(this.selectionMode == GridSelectionMode.NONE || this.grid.caretRowIndex < 0 || this.grid.caretRowIndex >= this.dataProviderLength || this.isCellSelectionMode() && (this.grid.caretColumnIndex < 0 || this.grid.caretColumnIndex >= this.columnsLength))
         {
            if(Boolean(this.scroller) && this.scrollerEvent != event)
            {
               this.scrollerEvent = event.clone() as KeyboardEvent;
               this.scroller.dispatchEvent(this.scrollerEvent);
            }
            return;
         }
         if(event.keyCode == Keyboard.SPACE)
         {
            if(event.ctrlKey)
            {
               if(this.toggleSelection(this.grid.caretRowIndex,this.grid.caretColumnIndex))
               {
                  this.grid.anchorRowIndex = this.grid.caretRowIndex;
                  this.grid.anchorColumnIndex = this.grid.caretColumnIndex;
                  event.preventDefault();
               }
            }
            else if(event.shiftKey)
            {
               if(this.extendSelection(this.grid.caretRowIndex,this.grid.caretColumnIndex))
               {
                  event.preventDefault();
               }
            }
            else if(this.grid.caretRowIndex != -1)
            {
               if(this.isRowSelectionMode())
               {
                  op = this.selectionMode == GridSelectionMode.SINGLE_ROW ? GridSelectionEventKind.SET_ROW : GridSelectionEventKind.ADD_ROW;
                  if(!this.commitInteractiveSelection(op,this.grid.caretRowIndex,this.grid.caretColumnIndex))
                  {
                     return;
                  }
                  event.preventDefault();
               }
               else if(this.isCellSelectionMode() && this.grid.caretColumnIndex != -1)
               {
                  op = this.selectionMode == GridSelectionMode.SINGLE_CELL ? GridSelectionEventKind.SET_CELL : GridSelectionEventKind.ADD_CELL;
                  if(!this.commitInteractiveSelection(op,this.grid.caretRowIndex,this.grid.caretColumnIndex))
                  {
                     return;
                  }
                  event.preventDefault();
               }
            }
            return;
         }
         this.adjustSelectionUponNavigation(event);
      }
      
      protected function selectAllHandler(event:Event) : void
      {
         if(!this.grid || event.isDefaultPrevented() || !this.isOurFocus(DisplayObject(event.target)))
         {
            return;
         }
         this.selectAllFromKeyboard();
      }
      
      private function selectAllFromKeyboard() : void
      {
         if(this.selectionMode == GridSelectionMode.MULTIPLE_CELLS || this.selectionMode == GridSelectionMode.MULTIPLE_ROWS)
         {
            if(this.commitInteractiveSelection(GridSelectionEventKind.SELECT_ALL,0,0,this.dataProvider.length,this.columns.length))
            {
               this.grid.anchorRowIndex = 0;
               this.grid.anchorColumnIndex = 0;
            }
         }
      }
      
      override protected function findSkinParts() : void
      {
         var partName:String = null;
         super.findSkinParts();
         for each(partName in factorySkinPartNames)
         {
            if(partName in skin && Boolean(skin[partName]))
            {
               this.partAdded(partName,skin[partName]);
            }
         }
      }
      
      private function initializeDataGridElement(elt:IDataGridElement) : void
      {
         if(!elt)
         {
            return;
         }
         elt.dataGrid = this;
         if(elt.nestLevel <= this.grid.nestLevel)
         {
            elt.nestLevel = this.grid.nestLevel + 1;
         }
      }
      
      override protected function partAdded(partName:String, instance:Object) : void
      {
         var modifiedGridProperties:Object = null;
         var propertyName:String = null;
         var deferredGridOperation:Function = null;
         var vsp:String = null;
         var hsp:String = null;
         super.partAdded(partName,instance);
         if(instance == this.grid)
         {
            this.gridSelection.grid = this.grid;
            this.grid.gridSelection = this.gridSelection;
            this.grid.dataGrid = this;
            modifiedGridProperties = this.gridProperties;
            this.gridProperties = {"propertyBits":0};
            for(propertyName in modifiedGridProperties)
            {
               if(propertyName != "propertyBits")
               {
                  this.setGridProperty(propertyName,modifiedGridProperties[propertyName]);
               }
            }
            this.initializeGridRowBackground();
            this.grid.columnSeparator = this.columnSeparator;
            this.grid.rowSeparator = this.rowSeparator;
            this.grid.hoverIndicator = this.hoverIndicator;
            this.grid.caretIndicator = this.caretIndicator;
            this.grid.selectionIndicator = this.selectionIndicator;
            this.grid.addEventListener(GridEvent.GRID_MOUSE_DOWN,this.grid_mouseDownHandler,false,EventPriority.DEFAULT_HANDLER);
            this.grid.addEventListener(GridEvent.GRID_MOUSE_UP,this.grid_mouseUpHandler,false,EventPriority.DEFAULT_HANDLER);
            this.grid.addEventListener(GridEvent.GRID_ROLL_OVER,this.grid_rollOverHandler,false,EventPriority.DEFAULT_HANDLER);
            this.grid.addEventListener(GridEvent.GRID_ROLL_OUT,this.grid_rollOutHandler,false,EventPriority.DEFAULT_HANDLER);
            this.grid.addEventListener(GridCaretEvent.CARET_CHANGE,this.grid_caretChangeHandler);
            this.grid.addEventListener(FlexEvent.VALUE_COMMIT,this.grid_valueCommitHandler);
            this.grid.addEventListener("invalidateSize",this.grid_invalidateSizeHandler);
            this.grid.addEventListener("invalidateDisplayList",this.grid_invalidateDisplayListHandler);
            for each(deferredGridOperation in this.deferredGridOperations)
            {
               deferredGridOperation(this.grid);
            }
            this.deferredGridOperations.length = 0;
            this.initializeDataGridElement(this.columnHeaderGroup);
            this.editor = this.createEditor();
            this.editor.initialize();
         }
         if(instance == this.alternatingRowColorsBackground)
         {
            this.initializeGridRowBackground();
         }
         if(Boolean(this.grid))
         {
            if(instance == this.columnSeparator)
            {
               this.grid.columnSeparator = this.columnSeparator;
            }
            if(instance == this.rowSeparator)
            {
               this.grid.rowSeparator = this.rowSeparator;
            }
            if(instance == this.hoverIndicator)
            {
               this.grid.hoverIndicator = this.hoverIndicator;
            }
            if(instance == this.caretIndicator)
            {
               this.grid.caretIndicator = this.caretIndicator;
               addEventListener(FocusEvent.FOCUS_IN,this.dataGrid_focusHandler);
               addEventListener(FocusEvent.FOCUS_OUT,this.dataGrid_focusHandler);
               if(Boolean(this.grid) && this.grid.layout is GridLayout)
               {
                  GridLayout(this.grid.layout).showCaret = false;
               }
            }
            if(instance == this.rowBackground)
            {
               this.grid.rowBackground = this.rowBackground;
            }
            if(instance == this.selectionIndicator)
            {
               this.grid.selectionIndicator = this.selectionIndicator;
            }
         }
         if(instance == this.columnHeaderGroup)
         {
            if(Boolean(this.grid))
            {
               this.initializeDataGridElement(this.columnHeaderGroup);
            }
            this.columnHeaderGroup.addEventListener(GridEvent.GRID_CLICK,this.columnHeaderGroup_clickHandler);
            this.columnHeaderGroup.addEventListener(GridEvent.SEPARATOR_ROLL_OVER,this.separator_rollOverHandler);
            this.columnHeaderGroup.addEventListener(GridEvent.SEPARATOR_ROLL_OUT,this.separator_rollOutHandler);
            this.columnHeaderGroup.addEventListener(GridEvent.SEPARATOR_MOUSE_DOWN,this.separator_mouseDownHandler);
            this.columnHeaderGroup.addEventListener(GridEvent.SEPARATOR_MOUSE_DRAG,this.separator_mouseDragHandler);
            this.columnHeaderGroup.addEventListener(GridEvent.SEPARATOR_MOUSE_UP,this.separator_mouseUpHandler);
         }
         if(instance == this.scroller)
         {
            vsp = getStyle("verticalScrollPolicy");
            if(Boolean(vsp) && vsp !== ScrollPolicy.AUTO)
            {
               this.scroller.setStyle("verticalScrollPolicy",vsp);
            }
            hsp = getStyle("horizontalScrollPolicy");
            if(Boolean(hsp) && hsp !== ScrollPolicy.AUTO)
            {
               this.scroller.setStyle("horizontalScrollPolicy",hsp);
            }
         }
      }
      
      override protected function partRemoved(partName:String, instance:Object) : void
      {
         var gridPropertyBits:uint = 0;
         var propertyName:String = null;
         var propertyBit:uint = 0;
         super.partRemoved(partName,instance);
         if(instance == this.grid)
         {
            this.gridSelection.grid = null;
            this.grid.gridSelection = null;
            this.grid.dataGrid = null;
            this.grid.removeEventListener("invalidateSize",this.grid_invalidateSizeHandler);
            this.grid.removeEventListener("invalidateDisplayList",this.grid_invalidateDisplayListHandler);
            this.grid.removeEventListener(GridEvent.GRID_MOUSE_DOWN,this.grid_mouseDownHandler);
            this.grid.removeEventListener(GridEvent.GRID_MOUSE_UP,this.grid_mouseUpHandler);
            this.grid.removeEventListener(GridEvent.GRID_ROLL_OVER,this.grid_rollOverHandler);
            this.grid.removeEventListener(GridEvent.GRID_ROLL_OUT,this.grid_rollOutHandler);
            this.grid.removeEventListener(GridCaretEvent.CARET_CHANGE,this.grid_caretChangeHandler);
            this.grid.removeEventListener(FlexEvent.VALUE_COMMIT,this.grid_valueCommitHandler);
            gridPropertyBits = uint(this.gridProperties.propertyBits);
            this.gridProperties = new Object();
            for(propertyName in gridPropertyDefaults)
            {
               propertyBit = uint(partPropertyBits[propertyName]);
               if((propertyBit & gridPropertyBits) == propertyBit)
               {
                  this.gridProperties[propertyName] = this.getGridProperty(propertyName);
               }
            }
            this.grid.rowBackground = null;
            this.grid.columnSeparator = null;
            this.grid.rowSeparator = null;
            this.grid.hoverIndicator = null;
            this.grid.caretIndicator = null;
            this.grid.selectionIndicator = null;
            if(Boolean(this.columnHeaderGroup))
            {
               this.columnHeaderGroup.dataGrid = null;
            }
            if(Boolean(this.editor))
            {
               this.editor.uninitialize();
               this.editor = null;
            }
         }
         if(Boolean(this.grid))
         {
            if(instance == this.columnSeparator)
            {
               this.grid.columnSeparator = null;
            }
            if(instance == this.rowSeparator)
            {
               this.grid.rowSeparator = null;
            }
            if(instance == this.hoverIndicator)
            {
               this.grid.hoverIndicator = null;
            }
            if(instance == this.caretIndicator)
            {
               this.grid.caretIndicator = null;
               removeEventListener(FocusEvent.FOCUS_IN,this.dataGrid_focusHandler);
               removeEventListener(FocusEvent.FOCUS_OUT,this.dataGrid_focusHandler);
            }
            if(instance == this.selectionIndicator)
            {
               this.grid.selectionIndicator = null;
            }
            if(instance == this.rowBackground)
            {
               this.grid.rowBackground = null;
            }
         }
         if(instance == this.columnHeaderGroup)
         {
            this.columnHeaderGroup.dataGrid = null;
            this.columnHeaderGroup.removeEventListener(GridEvent.GRID_CLICK,this.columnHeaderGroup_clickHandler);
            this.columnHeaderGroup.removeEventListener(GridEvent.SEPARATOR_ROLL_OVER,this.separator_rollOverHandler);
            this.columnHeaderGroup.removeEventListener(GridEvent.SEPARATOR_ROLL_OUT,this.separator_rollOutHandler);
            this.columnHeaderGroup.removeEventListener(GridEvent.SEPARATOR_MOUSE_DOWN,this.separator_mouseDownHandler);
            this.columnHeaderGroup.removeEventListener(GridEvent.SEPARATOR_MOUSE_DRAG,this.separator_mouseDragHandler);
            this.columnHeaderGroup.removeEventListener(GridEvent.SEPARATOR_MOUSE_UP,this.separator_mouseUpHandler);
         }
      }
      
      [Bindable("valueCommit")]
      [Bindable("selectionChange")]
      public function get selectedCell() : CellPosition
      {
         if(Boolean(this.grid))
         {
            return this.grid.selectedCell;
         }
         return Boolean(this.selectedCells.length) ? this.selectedCells[0] : null;
      }
      
      public function set selectedCell(value:CellPosition) : void
      {
         var valueCopy:CellPosition = null;
         var f:Function = null;
         if(Boolean(this.grid))
         {
            this.grid.selectedCell = value;
         }
         else
         {
            valueCopy = Boolean(value) ? new CellPosition(value.rowIndex,value.columnIndex) : null;
            f = function(g:Grid):void
            {
               g.selectedCell = valueCopy;
            };
            this.deferredGridOperations.push(f);
         }
      }
      
      [Bindable("valueCommit")]
      [Bindable("selectionChange")]
      public function get selectedCells() : Vector.<CellPosition>
      {
         return Boolean(this.grid) ? this.grid.selectedCells : this.gridSelection.allCells();
      }
      
      public function set selectedCells(value:Vector.<CellPosition>) : void
      {
         var valueCopy:Vector.<CellPosition> = null;
         var f:Function = null;
         if(Boolean(this.grid))
         {
            this.grid.selectedCells = value;
         }
         else
         {
            valueCopy = Boolean(value) ? value.concat() : null;
            f = function(g:Grid):void
            {
               g.selectedCells = valueCopy;
            };
            this.deferredGridOperations.push(f);
         }
      }
      
      [Inspectable(category="General",defaultValue="-1")]
      [Bindable("valueCommit")]
      [Bindable("selectionChange")]
      public function get selectedIndex() : int
      {
         if(Boolean(this.grid))
         {
            return this.grid.selectedIndex;
         }
         return this.selectedIndices.length > 0 ? this.selectedIndices[0] : -1;
      }
      
      public function set selectedIndex(value:int) : void
      {
         var f:Function = null;
         if(Boolean(this.grid))
         {
            this.grid.selectedIndex = value;
         }
         else
         {
            f = function(g:Grid):void
            {
               g.selectedIndex = value;
            };
            this.deferredGridOperations.push(f);
         }
      }
      
      [Inspectable(category="General")]
      [Bindable("valueCommit")]
      [Bindable("selectionChange")]
      public function get selectedIndices() : Vector.<int>
      {
         return Boolean(this.grid) ? this.grid.selectedIndices : this.gridSelection.allRows();
      }
      
      public function set selectedIndices(value:Vector.<int>) : void
      {
         var valueCopy:Vector.<int> = null;
         var f:Function = null;
         if(Boolean(this.grid))
         {
            this.grid.selectedIndices = value;
         }
         else
         {
            valueCopy = Boolean(value) ? value.concat() : null;
            f = function(g:Grid):void
            {
               g.selectedIndices = valueCopy;
            };
            this.deferredGridOperations.push(f);
         }
      }
      
      [Inspectable(category="General",defaultValue="null")]
      [Bindable("valueCommit")]
      [Bindable("selectionChange")]
      public function get selectedItem() : Object
      {
         if(Boolean(this.grid))
         {
            return this.grid.selectedItem;
         }
         return Boolean(this.dataProvider) && this.selectedIndex > 0 ? this.dataProvider.getItemAt(this.selectedIndex) : undefined;
      }
      
      public function set selectedItem(value:Object) : void
      {
         var f:Function = null;
         if(Boolean(this.grid))
         {
            this.grid.selectedItem = value;
         }
         else
         {
            f = function(g:Grid):void
            {
               g.selectedItem = value;
            };
            this.deferredGridOperations.push(f);
         }
      }
      
      [Inspectable(category="General")]
      [Bindable("valueCommit")]
      [Bindable("selectionChange")]
      public function get selectedItems() : Vector.<Object>
      {
         if(Boolean(this.grid))
         {
            return this.grid.selectedItems;
         }
         var items:Vector.<Object> = new Vector.<Object>();
         for(var i:int = 0; i < this.selectedIndices.length; i++)
         {
            items.push(this.selectedIndices[i]);
         }
         return items;
      }
      
      public function set selectedItems(value:Vector.<Object>) : void
      {
         var valueCopy:Vector.<Object> = null;
         var f:Function = null;
         if(Boolean(this.grid))
         {
            this.grid.selectedItems = value;
         }
         else
         {
            valueCopy = value.concat();
            f = function(g:Grid):void
            {
               g.selectedItems = valueCopy;
            };
            this.deferredGridOperations.push(f);
         }
      }
      
      [Bindable("valueCommit")]
      [Bindable("selectionChange")]
      public function get selectionLength() : int
      {
         return Boolean(this.grid) ? this.grid.selectionLength : this.gridSelection.selectionLength;
      }
      
      public function invalidateCell(rowIndex:int, columnIndex:int) : void
      {
         if(Boolean(this.grid))
         {
            this.grid.invalidateCell(rowIndex,columnIndex);
         }
      }
      
      public function selectAll() : Boolean
      {
         var selectionChanged:Boolean = false;
         if(Boolean(this.grid))
         {
            selectionChanged = this.grid.selectAll();
         }
         else
         {
            selectionChanged = this.gridSelection.selectAll();
            if(selectionChanged)
            {
               this.dispatchFlexEvent(FlexEvent.VALUE_COMMIT);
            }
         }
         return selectionChanged;
      }
      
      public function clearSelection() : Boolean
      {
         var selectionChanged:Boolean = false;
         if(Boolean(this.grid))
         {
            selectionChanged = this.grid.clearSelection();
         }
         else
         {
            selectionChanged = this.gridSelection.removeAll();
            if(selectionChanged)
            {
               this.dispatchFlexEvent(FlexEvent.VALUE_COMMIT);
            }
         }
         return selectionChanged;
      }
      
      public function selectionContainsIndex(rowIndex:int) : Boolean
      {
         if(Boolean(this.grid))
         {
            return this.grid.selectionContainsIndex(rowIndex);
         }
         return this.gridSelection.containsRow(rowIndex);
      }
      
      public function selectionContainsIndices(rowIndices:Vector.<int>) : Boolean
      {
         if(Boolean(this.grid))
         {
            return this.grid.selectionContainsIndices(rowIndices);
         }
         return this.gridSelection.containsRows(rowIndices);
      }
      
      public function setSelectedIndex(rowIndex:int) : Boolean
      {
         var selectionChanged:Boolean = false;
         if(Boolean(this.grid))
         {
            selectionChanged = this.grid.setSelectedIndex(rowIndex);
         }
         else
         {
            selectionChanged = this.gridSelection.setRow(rowIndex);
            if(selectionChanged)
            {
               this.dispatchFlexEvent(FlexEvent.VALUE_COMMIT);
            }
         }
         return selectionChanged;
      }
      
      public function addSelectedIndex(rowIndex:int) : Boolean
      {
         var selectionChanged:Boolean = false;
         if(Boolean(this.grid))
         {
            selectionChanged = this.grid.addSelectedIndex(rowIndex);
         }
         else
         {
            selectionChanged = this.gridSelection.addRow(rowIndex);
            if(selectionChanged)
            {
               this.dispatchFlexEvent(FlexEvent.VALUE_COMMIT);
            }
         }
         return selectionChanged;
      }
      
      public function removeSelectedIndex(rowIndex:int) : Boolean
      {
         var selectionChanged:Boolean = false;
         if(Boolean(this.grid))
         {
            selectionChanged = this.grid.removeSelectedIndex(rowIndex);
         }
         else
         {
            selectionChanged = this.gridSelection.removeRow(rowIndex);
            if(selectionChanged)
            {
               this.dispatchFlexEvent(FlexEvent.VALUE_COMMIT);
            }
         }
         return selectionChanged;
      }
      
      public function selectIndices(rowIndex:int, rowCount:int) : Boolean
      {
         var selectionChanged:Boolean = false;
         if(Boolean(this.grid))
         {
            selectionChanged = this.grid.selectIndices(rowIndex,rowCount);
         }
         else
         {
            selectionChanged = this.gridSelection.setRows(rowIndex,rowCount);
            if(selectionChanged)
            {
               this.dispatchFlexEvent(FlexEvent.VALUE_COMMIT);
            }
         }
         return selectionChanged;
      }
      
      public function selectionContainsCell(rowIndex:int, columnIndex:int) : Boolean
      {
         if(Boolean(this.grid))
         {
            return this.grid.selectionContainsCell(rowIndex,columnIndex);
         }
         return this.gridSelection.containsCell(rowIndex,columnIndex);
      }
      
      public function selectionContainsCellRegion(rowIndex:int, columnIndex:int, rowCount:int, columnCount:int) : Boolean
      {
         if(Boolean(this.grid))
         {
            return this.grid.selectionContainsCellRegion(rowIndex,columnIndex,rowCount,columnCount);
         }
         return this.gridSelection.containsCellRegion(rowIndex,columnIndex,rowCount,columnCount);
      }
      
      public function setSelectedCell(rowIndex:int, columnIndex:int) : Boolean
      {
         var selectionChanged:Boolean = false;
         if(Boolean(this.grid))
         {
            selectionChanged = this.grid.setSelectedCell(rowIndex,columnIndex);
         }
         else
         {
            selectionChanged = this.gridSelection.setCell(rowIndex,columnIndex);
            if(selectionChanged)
            {
               this.dispatchFlexEvent(FlexEvent.VALUE_COMMIT);
            }
         }
         return selectionChanged;
      }
      
      public function addSelectedCell(rowIndex:int, columnIndex:int) : Boolean
      {
         var selectionChanged:Boolean = false;
         if(Boolean(this.grid))
         {
            selectionChanged = this.grid.addSelectedCell(rowIndex,columnIndex);
         }
         else
         {
            selectionChanged = this.gridSelection.addCell(rowIndex,columnIndex);
            if(selectionChanged)
            {
               this.dispatchFlexEvent(FlexEvent.VALUE_COMMIT);
            }
         }
         return selectionChanged;
      }
      
      public function removeSelectedCell(rowIndex:int, columnIndex:int) : Boolean
      {
         var selectionChanged:Boolean = false;
         if(Boolean(this.grid))
         {
            selectionChanged = this.grid.removeSelectedCell(rowIndex,columnIndex);
         }
         else
         {
            selectionChanged = this.gridSelection.removeCell(rowIndex,columnIndex);
            if(selectionChanged)
            {
               this.dispatchFlexEvent(FlexEvent.VALUE_COMMIT);
            }
         }
         return selectionChanged;
      }
      
      public function selectCellRegion(rowIndex:int, columnIndex:int, rowCount:uint, columnCount:uint) : Boolean
      {
         var selectionChanged:Boolean = false;
         if(Boolean(this.grid))
         {
            selectionChanged = this.grid.selectCellRegion(rowIndex,columnIndex,rowCount,columnCount);
         }
         else
         {
            selectionChanged = this.gridSelection.setCellRegion(rowIndex,columnIndex,rowCount,columnCount);
            if(selectionChanged)
            {
               this.dispatchFlexEvent(FlexEvent.VALUE_COMMIT);
            }
         }
         return selectionChanged;
      }
      
      protected function commitInteractiveSelection(selectionEventKind:String, rowIndex:int, columnIndex:int, rowCount:int = 1, columnCount:int = 1) : Boolean
      {
         var changed:Boolean = false;
         var changingEvent:GridSelectionEvent = null;
         var changeEvent:GridSelectionEvent = null;
         if(!this.grid)
         {
            return false;
         }
         var selectionChange:CellRegion = new CellRegion(rowIndex,columnIndex,rowCount,columnCount);
         if(!this.doesChangeCurrentSelection(selectionEventKind,selectionChange))
         {
            return true;
         }
         if(hasEventListener(GridSelectionEvent.SELECTION_CHANGING))
         {
            changingEvent = new GridSelectionEvent(GridSelectionEvent.SELECTION_CHANGING,false,true,selectionEventKind,selectionChange);
            if(!dispatchEvent(changingEvent))
            {
               return false;
            }
         }
         switch(selectionEventKind)
         {
            case GridSelectionEventKind.SET_ROW:
               changed = this.grid.gridSelection.setRow(rowIndex);
               break;
            case GridSelectionEventKind.ADD_ROW:
               changed = this.grid.gridSelection.addRow(rowIndex);
               break;
            case GridSelectionEventKind.REMOVE_ROW:
               changed = this.grid.gridSelection.removeRow(rowIndex);
               break;
            case GridSelectionEventKind.SET_ROWS:
               changed = this.grid.gridSelection.setRows(rowIndex,rowCount);
               break;
            case GridSelectionEventKind.SET_CELL:
               changed = this.grid.gridSelection.setCell(rowIndex,columnIndex);
               break;
            case GridSelectionEventKind.ADD_CELL:
               changed = this.grid.gridSelection.addCell(rowIndex,columnIndex);
               break;
            case GridSelectionEventKind.REMOVE_CELL:
               changed = this.grid.gridSelection.removeCell(rowIndex,columnIndex);
               break;
            case GridSelectionEventKind.SET_CELL_REGION:
               changed = this.grid.gridSelection.setCellRegion(rowIndex,columnIndex,rowCount,columnCount);
               break;
            case GridSelectionEventKind.SELECT_ALL:
               changed = this.grid.gridSelection.selectAll();
         }
         if(!changed)
         {
            return false;
         }
         this.grid.invalidateDisplayListFor("selectionIndicator");
         if(hasEventListener(GridSelectionEvent.SELECTION_CHANGE))
         {
            changeEvent = new GridSelectionEvent(GridSelectionEvent.SELECTION_CHANGE,false,true,selectionEventKind,selectionChange);
            dispatchEvent(changeEvent);
            if(this.grid.hasEventListener(GridSelectionEvent.SELECTION_CHANGE))
            {
               this.grid.dispatchEvent(changeEvent);
            }
         }
         this.dispatchFlexEvent(FlexEvent.VALUE_COMMIT);
         return true;
      }
      
      protected function commitCaretPosition(newCaretRowIndex:int, newCaretColumnIndex:int) : void
      {
         this.grid.caretRowIndex = newCaretRowIndex;
         this.grid.caretColumnIndex = newCaretColumnIndex;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function createGridSelection() : GridSelection
      {
         return new GridSelection();
      }
      
      protected function selectionContainsOnlyIndex(index:int) : Boolean
      {
         if(Boolean(this.grid))
         {
            return this.grid.selectionContainsIndex(index) && this.grid.selectionLength == 1;
         }
         return this.gridSelection.containsRow(index) && this.gridSelection.selectionLength == 1;
      }
      
      protected function selectionContainsOnlyIndices(selectionChange:CellRegion) : Boolean
      {
         var selectionLength:int = Boolean(this.grid) ? this.grid.selectionLength : this.gridSelection.selectionLength;
         if(selectionChange.rowCount != selectionLength)
         {
            return false;
         }
         var bottom:int = selectionChange.rowIndex + selectionChange.rowCount;
         var rowIndex:int = selectionChange.rowIndex;
         while(rowIndex < bottom)
         {
            if(Boolean(this.grid))
            {
               if(!this.grid.selectionContainsIndex(rowIndex))
               {
                  return false;
               }
            }
            else if(!this.gridSelection.containsRow(rowIndex))
            {
               return false;
            }
            rowIndex++;
         }
         return true;
      }
      
      private function selectionContainsOnlyCell(rowIndex:int, columnIndex:int) : Boolean
      {
         if(Boolean(this.grid))
         {
            return this.grid.selectionContainsCell(rowIndex,columnIndex) && this.grid.selectionLength == 1;
         }
         return this.gridSelection.containsCell(rowIndex,columnIndex) && this.gridSelection.selectionLength == 1;
      }
      
      private function selectionContainsOnlyCellRegion(rowIndex:int, columnIndex:int, rowCount:int, columnCount:int) : Boolean
      {
         if(Boolean(this.grid))
         {
            return this.grid.selectionContainsCellRegion(rowIndex,columnIndex,rowCount,columnCount) && this.grid.selectionLength == rowCount * columnCount;
         }
         return this.gridSelection.containsCellRegion(rowIndex,columnIndex,rowCount,columnCount) && this.gridSelection.selectionLength == rowCount * columnCount;
      }
      
      public function startItemEditorSession(rowIndex:int, columnIndex:int) : Boolean
      {
         if(Boolean(this.editor))
         {
            return this.editor.startItemEditorSession(rowIndex,columnIndex);
         }
         return false;
      }
      
      public function endItemEditorSession(cancel:Boolean = false) : Boolean
      {
         if(Boolean(this.editor))
         {
            return this.editor.endItemEditorSession(cancel);
         }
         return false;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function createEditor() : DataGridEditor
      {
         return new DataGridEditor(this);
      }
      
      public function sortByColumns(columnIndices:Vector.<int>, isInteractive:Boolean = false) : Boolean
      {
         var newSortField:ISortField = null;
         var changingEvent:GridSortEvent = null;
         var oldSortField:ISortField = null;
         var oldASC:AdvancedStyleClient = null;
         var newASC:AdvancedStyleClient = null;
         var changeEvent:GridSortEvent = null;
         var dataProvider:ICollectionView = this.dataProvider as ICollectionView;
         if(!dataProvider)
         {
            return false;
         }
         var sort:ISort = dataProvider.sort;
         if(Boolean(sort))
         {
            sort.compareFunction = null;
         }
         else
         {
            sort = new Sort();
         }
         var sortFields:Array = this.createSortFields(columnIndices,sort.fields,isInteractive);
         if(!sortFields)
         {
            return false;
         }
         var oldSortFields:Array = Boolean(dataProvider.sort) ? dataProvider.sort.fields : null;
         if(isInteractive)
         {
            if(Boolean(oldSortFields))
            {
               oldSortFields = oldSortFields.concat();
            }
            if(hasEventListener(GridSortEvent.SORT_CHANGING))
            {
               changingEvent = new GridSortEvent(GridSortEvent.SORT_CHANGING,false,true,columnIndices,oldSortFields,sortFields);
               if(!dispatchEvent(changingEvent))
               {
                  return false;
               }
               columnIndices = changingEvent.columnIndices;
               if(!columnIndices)
               {
                  return false;
               }
               sortFields = changingEvent.newSortFields;
               if(!sortFields)
               {
                  return false;
               }
            }
         }
         if(Boolean(oldSortFields))
         {
            for each(oldSortField in oldSortFields)
            {
               oldASC = oldSortField as AdvancedStyleClient;
               if(!(!oldASC || oldASC.styleParent != this || sortFields.indexOf(oldASC) != -1))
               {
                  removeStyleClient(oldASC);
               }
            }
         }
         for each(newSortField in sortFields)
         {
            newASC = newSortField as AdvancedStyleClient;
            if(!(!newASC || newASC.styleParent == this))
            {
               addStyleClient(newASC);
            }
         }
         sort.fields = sortFields;
         dataProvider.sort = sort;
         dataProvider.refresh();
         if(isInteractive)
         {
            if(hasEventListener(GridSortEvent.SORT_CHANGE))
            {
               changeEvent = new GridSortEvent(GridSortEvent.SORT_CHANGE,false,true,columnIndices,oldSortFields,sortFields);
               dispatchEvent(changeEvent);
            }
            if(Boolean(this.columnHeaderGroup))
            {
               this.columnHeaderGroup.visibleSortIndicatorIndices = columnIndices;
            }
         }
         return true;
      }
      
      private function createSortFields(columnIndices:Vector.<int>, previousFields:Array, preservePrevious:Boolean) : Array
      {
         var columnIndex:int = 0;
         var col:GridColumn = null;
         var dataField:String = null;
         var isComplexDataField:Boolean = false;
         var sortField:ISortField = null;
         var sortDescending:Boolean = false;
         if(columnIndices.length == 0)
         {
            return null;
         }
         var fields:Array = new Array();
         for each(columnIndex in columnIndices)
         {
            col = this.getColumnAt(columnIndex);
            if(!col)
            {
               return null;
            }
            dataField = col.dataField;
            if(dataField == null && col.labelFunction == null && col.sortCompareFunction == null)
            {
               return null;
            }
            isComplexDataField = Boolean(dataField) && dataField.indexOf(".") != -1;
            sortField = null;
            sortDescending = col.sortDescending;
            sortField = findSortField(dataField,fields,isComplexDataField);
            if(!sortField && Boolean(previousFields))
            {
               sortField = findSortField(dataField,previousFields,isComplexDataField);
            }
            else
            {
               preservePrevious = false;
            }
            if(Boolean(sortField))
            {
               sortDescending = !sortField.descending;
            }
            if(!sortField || preservePrevious)
            {
               sortField = col.sortField;
            }
            col.sortDescending = sortDescending;
            sortField.descending = sortDescending;
            fields.push(sortField);
         }
         return fields;
      }
      
      private function isAnchorSet() : Boolean
      {
         if(!this.grid)
         {
            return false;
         }
         if(this.isRowSelectionMode())
         {
            return this.grid.anchorRowIndex != -1;
         }
         return this.grid.anchorRowIndex != -1 && this.grid.anchorRowIndex != -1;
      }
      
      private function toggleSelection(rowIndex:int, columnIndex:int) : Boolean
      {
         var kind:String = null;
         if(this.isRowSelectionMode())
         {
            if(this.grid.selectionContainsIndex(rowIndex))
            {
               kind = GridSelectionEventKind.REMOVE_ROW;
            }
            else if(this.selectionMode == GridSelectionMode.MULTIPLE_ROWS)
            {
               kind = GridSelectionEventKind.ADD_ROW;
            }
            else
            {
               kind = GridSelectionEventKind.SET_ROW;
            }
         }
         else if(this.isCellSelectionMode())
         {
            if(this.grid.selectionContainsCell(rowIndex,columnIndex))
            {
               kind = GridSelectionEventKind.REMOVE_CELL;
            }
            else if(this.selectionMode == GridSelectionMode.MULTIPLE_CELLS)
            {
               kind = GridSelectionEventKind.ADD_CELL;
            }
            else
            {
               kind = GridSelectionEventKind.SET_CELL;
            }
         }
         var success:Boolean = this.commitInteractiveSelection(kind,rowIndex,columnIndex);
         if(success)
         {
            this.commitCaretPosition(rowIndex,columnIndex);
         }
         return success;
      }
      
      private function extendSelection(caretRowIndex:int, caretColumnIndex:int) : Boolean
      {
         var success:Boolean = false;
         var rowCount:int = 0;
         var startColumnIndex:int = 0;
         var endColumnIndex:int = 0;
         var columnCount:int = 0;
         if(!this.isAnchorSet())
         {
            return false;
         }
         var startRowIndex:int = Math.min(this.grid.anchorRowIndex,caretRowIndex);
         var endRowIndex:int = Math.max(this.grid.anchorRowIndex,caretRowIndex);
         if(this.selectionMode == GridSelectionMode.MULTIPLE_ROWS)
         {
            success = this.commitInteractiveSelection(GridSelectionEventKind.SET_ROWS,startRowIndex,-1,endRowIndex - startRowIndex + 1,0);
         }
         else if(this.selectionMode == GridSelectionMode.SINGLE_ROW)
         {
            success = this.commitInteractiveSelection(GridSelectionEventKind.SET_ROW,caretRowIndex,-1,1,0);
         }
         else if(this.selectionMode == GridSelectionMode.MULTIPLE_CELLS)
         {
            rowCount = endRowIndex - startRowIndex + 1;
            startColumnIndex = Math.min(this.grid.anchorColumnIndex,caretColumnIndex);
            endColumnIndex = Math.max(this.grid.anchorColumnIndex,caretColumnIndex);
            columnCount = endColumnIndex - startColumnIndex + 1;
            success = this.commitInteractiveSelection(GridSelectionEventKind.SET_CELL_REGION,startRowIndex,startColumnIndex,rowCount,columnCount);
         }
         else if(this.selectionMode == GridSelectionMode.SINGLE_CELL)
         {
            success = this.commitInteractiveSelection(GridSelectionEventKind.SET_CELL,caretRowIndex,caretColumnIndex,1,1);
         }
         if(success)
         {
            this.commitCaretPosition(caretRowIndex,caretColumnIndex);
         }
         return success;
      }
      
      private function setSelectionAnchorCaret(rowIndex:int, columnIndex:int) : Boolean
      {
         var success:Boolean = false;
         if(this.isRowSelectionMode())
         {
            success = this.commitInteractiveSelection(GridSelectionEventKind.SET_ROW,rowIndex,columnIndex);
         }
         else if(this.isCellSelectionMode())
         {
            success = this.commitInteractiveSelection(GridSelectionEventKind.SET_CELL,rowIndex,columnIndex);
         }
         if(success)
         {
            this.commitCaretPosition(rowIndex,columnIndex);
            this.grid.anchorRowIndex = rowIndex;
            this.grid.anchorColumnIndex = columnIndex;
         }
         return success;
      }
      
      private function setCaretToNavigationDestination(navigationUnit:uint) : CellPosition
      {
         var visibleRows:Vector.<int> = null;
         var caretRowBounds:Rectangle = null;
         var firstVisibleRowIndex:int = 0;
         var firstVisibleRowBounds:Rectangle = null;
         var delta:Number = NaN;
         var lastVisibleRowIndex:int = 0;
         var lastVisibleRowBounds:Rectangle = null;
         var caretRowIndex:int = this.grid.caretRowIndex;
         var caretColumnIndex:int = this.grid.caretColumnIndex;
         var inRows:Boolean = this.isRowSelectionMode();
         var rowCount:int = this.dataProviderLength;
         var columnCount:int = this.columnsLength;
         switch(navigationUnit)
         {
            case NavigationUnit.LEFT:
               if(this.isCellSelectionMode())
               {
                  if(this.grid.caretColumnIndex > 0)
                  {
                     caretColumnIndex = this.grid.getPreviousVisibleColumnIndex(caretColumnIndex);
                  }
               }
               break;
            case NavigationUnit.RIGHT:
               if(this.isCellSelectionMode())
               {
                  if(this.grid.caretColumnIndex + 1 < columnCount)
                  {
                     caretColumnIndex = this.grid.getNextVisibleColumnIndex(caretColumnIndex);
                  }
               }
               break;
            case NavigationUnit.UP:
               if(this.grid.caretRowIndex > 0)
               {
                  caretRowIndex--;
               }
               break;
            case NavigationUnit.DOWN:
               if(this.grid.caretRowIndex + 1 < rowCount)
               {
                  caretRowIndex++;
               }
               break;
            case NavigationUnit.PAGE_UP:
               visibleRows = this.grid.getVisibleRowIndices();
               if(visibleRows.length == 0)
               {
                  break;
               }
               firstVisibleRowIndex = visibleRows[0];
               firstVisibleRowBounds = this.grid.getRowBounds(firstVisibleRowIndex);
               if(firstVisibleRowIndex < rowCount - 1 && firstVisibleRowBounds.top < this.grid.scrollRect.top)
               {
                  firstVisibleRowIndex = visibleRows[1];
               }
               if(caretRowIndex > firstVisibleRowIndex)
               {
                  caretRowIndex = firstVisibleRowIndex;
               }
               else
               {
                  caretRowBounds = this.grid.getRowBounds(caretRowIndex);
                  delta = this.grid.scrollRect.bottom - caretRowBounds.bottom;
                  this.grid.verticalScrollPosition -= delta;
                  validateNow();
                  visibleRows = this.grid.getVisibleRowIndices();
                  firstVisibleRowIndex = visibleRows[0];
                  if(visibleRows.length > 0)
                  {
                     firstVisibleRowBounds = this.grid.getRowBounds(firstVisibleRowIndex);
                     if(firstVisibleRowIndex < rowCount - 1 && this.grid.scrollRect.top > firstVisibleRowBounds.top)
                     {
                        firstVisibleRowIndex = visibleRows[1];
                     }
                     caretRowIndex = firstVisibleRowIndex;
                  }
               }
               break;
            case NavigationUnit.PAGE_DOWN:
               visibleRows = this.grid.getVisibleRowIndices();
               if(visibleRows.length == 0)
               {
                  break;
               }
               lastVisibleRowIndex = Math.min(rowCount - 1,visibleRows[visibleRows.length - 1]);
               lastVisibleRowBounds = this.grid.getRowBounds(lastVisibleRowIndex);
               if(lastVisibleRowIndex > 0 && this.grid.scrollRect.bottom < lastVisibleRowBounds.bottom)
               {
                  lastVisibleRowIndex = visibleRows[visibleRows.length - 2];
               }
               if(caretRowIndex < lastVisibleRowIndex)
               {
                  caretRowIndex = lastVisibleRowIndex;
               }
               else
               {
                  caretRowBounds = this.grid.getRowBounds(caretRowIndex);
                  this.grid.verticalScrollPosition = caretRowBounds.y;
                  validateNow();
                  visibleRows = this.grid.getVisibleRowIndices();
                  lastVisibleRowIndex = Math.min(rowCount - 1,visibleRows[visibleRows.length - 1]);
                  if(visibleRows.length >= 0)
                  {
                     lastVisibleRowBounds = this.grid.getRowBounds(lastVisibleRowIndex);
                     if(lastVisibleRowIndex > 0 && this.grid.scrollRect.bottom < lastVisibleRowBounds.bottom)
                     {
                        lastVisibleRowIndex = visibleRows[visibleRows.length - 2];
                     }
                     caretRowIndex = lastVisibleRowIndex;
                  }
               }
               break;
            case NavigationUnit.HOME:
               caretRowIndex = 0;
               caretColumnIndex = this.isCellSelectionMode() ? this.grid.getNextVisibleColumnIndex(-1) : -1;
               break;
            case NavigationUnit.END:
               caretRowIndex = rowCount - 1;
               caretColumnIndex = this.isCellSelectionMode() ? this.grid.getPreviousVisibleColumnIndex(columnCount) : -1;
               this.grid.verticalScrollPosition = this.grid.contentHeight;
               validateNow();
               if(this.grid.contentHeight != this.grid.verticalScrollPosition)
               {
                  this.grid.verticalScrollPosition = this.grid.contentHeight;
                  validateNow();
               }
               break;
            default:
               return null;
         }
         return new CellPosition(caretRowIndex,caretColumnIndex);
      }
      
      public function ensureCellIsVisible(rowIndex:int, columnIndex:int = -1) : void
      {
         if(Boolean(this.grid))
         {
            this.grid.ensureCellIsVisible(rowIndex,columnIndex);
         }
      }
      
      protected function adjustSelectionUponNavigation(event:KeyboardEvent) : Boolean
      {
         var navigationUnit:uint = 0;
         if(!NavigationUnit.isNavigationUnit(event.keyCode))
         {
            return false;
         }
         navigationUnit = uint(mapKeycodeForLayoutDirection(event));
         var newPosition:CellPosition = this.setCaretToNavigationDestination(navigationUnit);
         if(!newPosition)
         {
            return false;
         }
         event.preventDefault();
         var selectionChanged:Boolean = false;
         if(event.shiftKey)
         {
            selectionChanged = this.extendSelection(newPosition.rowIndex,newPosition.columnIndex);
         }
         else if(event.ctrlKey)
         {
            this.commitCaretPosition(newPosition.rowIndex,newPosition.columnIndex);
         }
         else
         {
            this.setSelectionAnchorCaret(newPosition.rowIndex,newPosition.columnIndex);
         }
         this.ensureCellIsVisible(newPosition.rowIndex,newPosition.columnIndex);
         return true;
      }
      
      private function doesChangeCurrentSelection(selectionEventKind:String, selectionChange:CellRegion) : Boolean
      {
         var changesSelection:Boolean = false;
         var rowIndex:int = selectionChange.rowIndex;
         var columnIndex:int = selectionChange.columnIndex;
         var rowCount:int = selectionChange.rowCount;
         var columnCount:int = selectionChange.columnCount;
         switch(selectionEventKind)
         {
            case GridSelectionEventKind.SET_ROW:
               changesSelection = !this.selectionContainsOnlyIndex(rowIndex);
               break;
            case GridSelectionEventKind.ADD_ROW:
               changesSelection = !this.grid.selectionContainsIndex(rowIndex);
               break;
            case GridSelectionEventKind.REMOVE_ROW:
               changesSelection = this.requireSelection ? !this.selectionContainsOnlyIndex(rowIndex) : this.grid.selectionContainsIndex(rowIndex);
               break;
            case GridSelectionEventKind.SET_ROWS:
               changesSelection = !this.selectionContainsOnlyIndices(selectionChange);
               break;
            case GridSelectionEventKind.SET_CELL:
               changesSelection = !this.selectionContainsOnlyCell(rowIndex,columnIndex);
               break;
            case GridSelectionEventKind.ADD_CELL:
               changesSelection = !this.grid.selectionContainsCell(rowIndex,columnIndex);
               break;
            case GridSelectionEventKind.REMOVE_CELL:
               changesSelection = this.requireSelection ? !this.selectionContainsOnlyCell(rowIndex,columnIndex) : this.grid.selectionContainsCell(rowIndex,columnIndex);
               break;
            case GridSelectionEventKind.SET_CELL_REGION:
               changesSelection = !this.selectionContainsOnlyCellRegion(rowIndex,columnIndex,rowCount,columnCount);
               break;
            case GridSelectionEventKind.SELECT_ALL:
               changesSelection = true;
         }
         return changesSelection;
      }
      
      protected function grid_rollOverHandler(event:GridEvent) : void
      {
         if(event.isDefaultPrevented())
         {
            return;
         }
         if(event.buttonDown && event.relatedObject != this.grid)
         {
            this.updateHoverOnRollOver = false;
         }
         this.grid.hoverRowIndex = this.updateHoverOnRollOver ? event.rowIndex : -1;
         this.grid.hoverColumnIndex = this.updateHoverOnRollOver ? event.columnIndex : -1;
         event.updateAfterEvent();
      }
      
      protected function grid_rollOutHandler(event:GridEvent) : void
      {
         if(event.isDefaultPrevented())
         {
            return;
         }
         this.grid.hoverRowIndex = -1;
         this.grid.hoverColumnIndex = -1;
         this.updateHoverOnRollOver = true;
         event.updateAfterEvent();
      }
      
      protected function grid_mouseUpHandler(event:GridEvent) : void
      {
         if(event.isDefaultPrevented())
         {
            return;
         }
         if(!this.updateHoverOnRollOver)
         {
            this.grid.hoverRowIndex = event.rowIndex;
            this.grid.hoverColumnIndex = event.columnIndex;
            this.updateHoverOnRollOver = true;
         }
      }
      
      protected function grid_mouseDownHandler(event:GridEvent) : void
      {
         var isCellSelection:Boolean = false;
         if(event.isDefaultPrevented())
         {
            return;
         }
         isCellSelection = this.isCellSelectionMode();
         var rowIndex:int = event.rowIndex;
         var columnIndex:int = isCellSelection ? event.columnIndex : -1;
         if(rowIndex == -1 || isCellSelection && columnIndex == -1)
         {
            return;
         }
         if(event.ctrlKey)
         {
            if(!this.toggleSelection(rowIndex,columnIndex))
            {
               return;
            }
            this.grid.anchorRowIndex = rowIndex;
            this.grid.anchorColumnIndex = columnIndex;
         }
         else if(event.shiftKey)
         {
            if(this.grid.selectionMode == GridSelectionMode.MULTIPLE_ROWS || this.grid.selectionMode == GridSelectionMode.MULTIPLE_CELLS)
            {
               if(!this.extendSelection(rowIndex,columnIndex))
               {
                  return;
               }
            }
         }
         else
         {
            this.setSelectionAnchorCaret(rowIndex,columnIndex);
         }
      }
      
      protected function grid_caretChangeHandler(event:GridCaretEvent) : void
      {
         if(hasEventListener(GridCaretEvent.CARET_CHANGE))
         {
            dispatchEvent(event);
         }
      }
      
      protected function grid_valueCommitHandler(event:FlexEvent) : void
      {
         if(hasEventListener(FlexEvent.VALUE_COMMIT))
         {
            dispatchEvent(event);
         }
      }
      
      private function grid_invalidateDisplayListHandler(event:Event) : void
      {
         if(Boolean(this.columnHeaderGroup) && this.grid.isInvalidateDisplayListReason("horizontalScrollPosition"))
         {
            this.columnHeaderGroup.invalidateDisplayList();
         }
      }
      
      private function grid_invalidateSizeHandler(event:Event) : void
      {
         if(Boolean(this.columnHeaderGroup))
         {
            this.columnHeaderGroup.invalidateSize();
         }
      }
      
      protected function columnHeaderGroup_clickHandler(event:GridEvent) : void
      {
         var column:GridColumn = event.column;
         if(!enabled || !this.sortableColumns || !column || !column.sortable)
         {
            return;
         }
         var columnIndices:Vector.<int> = Vector.<int>([column.columnIndex]);
         this.sortByColumns(columnIndices,true);
      }
      
      protected function separator_mouseDownHandler(event:GridEvent) : void
      {
         var nextColumnIndex:int = 0;
         var gc:GridColumn = null;
         var column:GridColumn = event.column;
         if(!enabled || !this.grid.resizableColumns || !column || !column.resizable)
         {
            return;
         }
         this.resizeColumn = event.column;
         this.resizeAnchorX = event.localX;
         this.resizeColumnWidth = this.grid.getColumnWidth(this.resizeColumn.columnIndex);
         if(isNaN(explicitWidth) && layoutDirection == LayoutDirection.RTL)
         {
            nextColumnIndex = this.grid.getNextVisibleColumnIndex(this.resizeColumn.columnIndex);
            this.nextColumn = this.getColumnAt(nextColumnIndex);
            this.nextColumnWidth = Math.ceil(this.grid.getColumnWidth(nextColumnIndex));
         }
         else
         {
            this.nextColumn = null;
            this.nextColumnWidth = NaN;
         }
         var resizeColumnIndex:int = this.resizeColumn.columnIndex;
         for(var columnIndex:int = 0; columnIndex < resizeColumnIndex; columnIndex++)
         {
            gc = this.getColumnAt(columnIndex);
            if(gc.visible && isNaN(gc.width))
            {
               gc.width = this.grid.getColumnWidth(columnIndex);
            }
         }
      }
      
      protected function separator_mouseDragHandler(event:GridEvent) : void
      {
         var nextMinWidth:Number = NaN;
         if(!this.resizeColumn)
         {
            return;
         }
         var widthDelta:Number = event.localX - this.resizeAnchorX;
         var minWidth:Number = isNaN(this.resizeColumn.minWidth) ? 0 : this.resizeColumn.minWidth;
         var maxWidth:Number = this.resizeColumn.maxWidth;
         var newWidth:Number = Math.ceil(this.resizeColumnWidth + widthDelta);
         if(Boolean(this.nextColumn))
         {
            nextMinWidth = isNaN(this.nextColumn.minWidth) ? 0 : this.nextColumn.minWidth;
            if(Math.ceil(this.nextColumnWidth - widthDelta) <= nextMinWidth)
            {
               return;
            }
            if(Math.ceil(this.resizeColumnWidth + widthDelta) <= minWidth)
            {
               return;
            }
            this.nextColumn.width = this.nextColumnWidth - widthDelta;
         }
         newWidth = Math.max(newWidth,minWidth);
         if(!isNaN(maxWidth))
         {
            newWidth = Math.min(newWidth,maxWidth);
         }
         this.resizeColumn.width = newWidth;
         event.updateAfterEvent();
      }
      
      protected function separator_mouseUpHandler(event:GridEvent) : void
      {
         if(!this.resizeColumn)
         {
            return;
         }
         this.resizeColumn = null;
      }
      
      protected function separator_rollOverHandler(event:GridEvent) : void
      {
         var column:GridColumn = event.column;
         if(!enabled || !this.grid.resizableColumns || !column || !column.resizable)
         {
            return;
         }
         var stretchCursorClass:Class = getStyle("stretchCursor") as Class;
         if(Boolean(stretchCursorClass))
         {
            this.stretchCursorID = cursorManager.setCursor(stretchCursorClass,CursorManagerPriority.HIGH,0,0);
         }
      }
      
      protected function separator_rollOutHandler(event:GridEvent) : void
      {
         if(!enabled)
         {
            return;
         }
         cursorManager.removeCursor(this.stretchCursorID);
      }
      
      protected function dataGrid_focusHandler(event:FocusEvent) : void
      {
         if(!this.grid || !(this.grid.layout is GridLayout))
         {
            return;
         }
         if(this.isOurFocus(DisplayObject(event.target)))
         {
            GridLayout(this.grid.layout).showCaret = event.type == FocusEvent.FOCUS_IN && this.selectionMode != GridSelectionMode.NONE;
         }
      }
      
      [SkinPart(required="false",type="mx.core.IVisualElement")]
      [Bindable(event="propertyChange")]
      public function get alternatingRowColorsBackground() : IFactory
      {
         return this._1277490047alternatingRowColorsBackground;
      }
      
      public function set alternatingRowColorsBackground(param1:IFactory) : void
      {
         var _loc2_:Object = this._1277490047alternatingRowColorsBackground;
         if(_loc2_ !== param1)
         {
            this._1277490047alternatingRowColorsBackground = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"alternatingRowColorsBackground",_loc2_,param1));
            }
         }
      }
      
      [SkinPart(required="false",type="mx.core.IVisualElement")]
      [Bindable(event="propertyChange")]
      public function get caretIndicator() : IFactory
      {
         return this._502679092caretIndicator;
      }
      
      public function set caretIndicator(param1:IFactory) : void
      {
         var _loc2_:Object = this._502679092caretIndicator;
         if(_loc2_ !== param1)
         {
            this._502679092caretIndicator = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"caretIndicator",_loc2_,param1));
            }
         }
      }
      
      [SkinPart(required="false")]
      [Bindable(event="propertyChange")]
      public function get columnHeaderGroup() : GridColumnHeaderGroup
      {
         return this._1482148164columnHeaderGroup;
      }
      
      public function set columnHeaderGroup(param1:GridColumnHeaderGroup) : void
      {
         var _loc2_:Object = this._1482148164columnHeaderGroup;
         if(_loc2_ !== param1)
         {
            this._1482148164columnHeaderGroup = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"columnHeaderGroup",_loc2_,param1));
            }
         }
      }
      
      [SkinPart(required="false",type="mx.core.IVisualElement")]
      [Bindable(event="propertyChange")]
      public function get columnSeparator() : IFactory
      {
         return this._237342767columnSeparator;
      }
      
      public function set columnSeparator(param1:IFactory) : void
      {
         var _loc2_:Object = this._237342767columnSeparator;
         if(_loc2_ !== param1)
         {
            this._237342767columnSeparator = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"columnSeparator",_loc2_,param1));
            }
         }
      }
      
      [SkinPart(required="false",type="mx.core.IVisualElement")]
      [Bindable(event="propertyChange")]
      public function get editorIndicator() : IFactory
      {
         return this._1555036382editorIndicator;
      }
      
      public function set editorIndicator(param1:IFactory) : void
      {
         var _loc2_:Object = this._1555036382editorIndicator;
         if(_loc2_ !== param1)
         {
            this._1555036382editorIndicator = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"editorIndicator",_loc2_,param1));
            }
         }
      }
      
      [SkinPart(required="false")]
      [Bindable(event="propertyChange")]
      public function get grid() : Grid
      {
         return this._3181382grid;
      }
      
      public function set grid(param1:Grid) : void
      {
         var _loc2_:Object = this._3181382grid;
         if(_loc2_ !== param1)
         {
            this._3181382grid = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"grid",_loc2_,param1));
            }
         }
      }
      
      [SkinPart(required="false",type="mx.core.IVisualElement")]
      [Bindable(event="propertyChange")]
      public function get hoverIndicator() : IFactory
      {
         return this._1933789133hoverIndicator;
      }
      
      public function set hoverIndicator(param1:IFactory) : void
      {
         var _loc2_:Object = this._1933789133hoverIndicator;
         if(_loc2_ !== param1)
         {
            this._1933789133hoverIndicator = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"hoverIndicator",_loc2_,param1));
            }
         }
      }
      
      [SkinPart(required="false",type="mx.core.IVisualElement")]
      [Bindable(event="propertyChange")]
      public function get rowBackground() : IFactory
      {
         return this._367467864rowBackground;
      }
      
      public function set rowBackground(param1:IFactory) : void
      {
         var _loc2_:Object = this._367467864rowBackground;
         if(_loc2_ !== param1)
         {
            this._367467864rowBackground = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rowBackground",_loc2_,param1));
            }
         }
      }
      
      [SkinPart(required="false",type="mx.core.IVisualElement")]
      [Bindable(event="propertyChange")]
      public function get rowSeparator() : IFactory
      {
         return this._1763950123rowSeparator;
      }
      
      public function set rowSeparator(param1:IFactory) : void
      {
         var _loc2_:Object = this._1763950123rowSeparator;
         if(_loc2_ !== param1)
         {
            this._1763950123rowSeparator = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rowSeparator",_loc2_,param1));
            }
         }
      }
      
      [SkinPart(required="false")]
      [Bindable(event="propertyChange")]
      public function get scroller() : Scroller
      {
         return this._402164678scroller;
      }
      
      public function set scroller(param1:Scroller) : void
      {
         var _loc2_:Object = this._402164678scroller;
         if(_loc2_ !== param1)
         {
            this._402164678scroller = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"scroller",_loc2_,param1));
            }
         }
      }
      
      [SkinPart(required="false",type="mx.core.IVisualElement")]
      [Bindable(event="propertyChange")]
      public function get selectionIndicator() : IFactory
      {
         return this._627206627selectionIndicator;
      }
      
      public function set selectionIndicator(param1:IFactory) : void
      {
         var _loc2_:Object = this._627206627selectionIndicator;
         if(_loc2_ !== param1)
         {
            this._627206627selectionIndicator = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"selectionIndicator",_loc2_,param1));
            }
         }
      }
   }
}

