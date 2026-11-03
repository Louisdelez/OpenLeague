package mx.controls
{
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   import flash.utils.describeType;
   import mx.collections.CursorBookmark;
   import mx.collections.ICollectionView;
   import mx.collections.ISort;
   import mx.collections.ISortField;
   import mx.collections.ItemResponder;
   import mx.collections.Sort;
   import mx.collections.SortField;
   import mx.collections.errors.ItemPendingError;
   import mx.controls.dataGridClasses.DataGridBase;
   import mx.controls.dataGridClasses.DataGridColumn;
   import mx.controls.dataGridClasses.DataGridDragProxy;
   import mx.controls.dataGridClasses.DataGridHeader;
   import mx.controls.dataGridClasses.DataGridItemRenderer;
   import mx.controls.dataGridClasses.DataGridListData;
   import mx.controls.listClasses.BaseListData;
   import mx.controls.listClasses.IDropInListItemRenderer;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.controls.listClasses.ListBaseContentHolder;
   import mx.controls.listClasses.ListBaseSeekPending;
   import mx.controls.listClasses.ListRowInfo;
   import mx.controls.scrollClasses.ScrollBar;
   import mx.core.ContextualClassFactory;
   import mx.core.EdgeMetrics;
   import mx.core.EventPriority;
   import mx.core.FlexShape;
   import mx.core.FlexSprite;
   import mx.core.IFactory;
   import mx.core.IFlexDisplayObject;
   import mx.core.IFlexModuleFactory;
   import mx.core.IIMESupport;
   import mx.core.IInvalidating;
   import mx.core.IPropertyChangeNotifier;
   import mx.core.IUIComponent;
   import mx.core.ScrollPolicy;
   import mx.core.UIComponent;
   import mx.core.UIComponentGlobals;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.events.DataGridEvent;
   import mx.events.DataGridEventReason;
   import mx.events.DragEvent;
   import mx.events.IndexChangedEvent;
   import mx.events.ListEvent;
   import mx.events.SandboxMouseEvent;
   import mx.events.ScrollEvent;
   import mx.events.ScrollEventDetail;
   import mx.managers.IFocusManager;
   import mx.managers.IFocusManagerComponent;
   import mx.skins.halo.ListDropIndicator;
   import mx.styles.ISimpleStyleClient;
   import mx.utils.ObjectUtil;
   import mx.utils.StringUtil;
   
   [Alternative(replacement="spark.components.DataGrid",since="4.5")]
   [RequiresDataBinding("true")]
   [IconFile("DataGrid.png")]
   [DefaultTriggerEvent("change")]
   [DefaultProperty("dataProvider")]
   [DefaultBindingProperty(source="selectedItem",destination="dataProvider")]
   [DataBindingInfo("{ dataProvider: &quot;String&quot; }")]
   [AccessibilityClass(implementation="mx.accessibility.DataGridAccImpl")]
   [Exclude(name="cornerRadius",kind="style")]
   [Exclude(name="showDataTips",kind="property")]
   [Exclude(name="offscreenExtraRowsOrColumnsChanged",kind="property")]
   [Exclude(name="offscreenExtraColumnsRight",kind="property")]
   [Exclude(name="offscreenExtraColumnsLeft",kind="property")]
   [Exclude(name="offscreenExtraColumns",kind="property")]
   [Exclude(name="offscreenExtraRowsBottom",kind="property")]
   [Exclude(name="offscreenExtraRowsTop",kind="property")]
   [Exclude(name="offscreenExtraRows",kind="property")]
   [Exclude(name="offscreenExtraRowsOrColumns",kind="property")]
   [Exclude(name="labelField",kind="property")]
   [Exclude(name="iconFunction",kind="property")]
   [Exclude(name="iconField",kind="property")]
   [Exclude(name="columnWidth",kind="property")]
   [Exclude(name="columnCount",kind="property")]
   [Style(name="headerDragProxyStyleName",type="String",inherit="no")]
   [Style(name="columnDropIndicatorSkin",type="Class",inherit="no")]
   [Style(name="stretchCursor",type="Class",inherit="no")]
   [Style(name="sortArrowSkin",type="Class",inherit="no")]
   [Style(name="verticalLockedSeparatorSkin",type="Class",inherit="no")]
   [Style(name="verticalSeparatorSkin",type="Class",inherit="no")]
   [Style(name="horizontalLockedSeparatorSkin",type="Class",inherit="no")]
   [Style(name="horizontalSeparatorSkin",type="Class",inherit="no")]
   [Style(name="headerSeparatorSkin",type="Class",inherit="no")]
   [Style(name="headerBackgroundSkin",type="Class",inherit="no")]
   [Style(name="columnResizeSkin",type="Class",inherit="no")]
   [Style(name="headerStyleName",type="String",inherit="no")]
   [Style(name="selectionColor",type="uint",format="Color",inherit="yes")]
   [Style(name="rollOverColor",type="uint",format="Color",inherit="yes")]
   [Style(name="headerColors",type="Array",arrayType="uint",format="Color",inherit="yes",theme="halo")]
   [Style(name="horizontalGridLineColor",type="uint",format="Color",inherit="yes")]
   [Style(name="verticalGridLineColor",type="uint",format="Color",inherit="yes")]
   [Style(name="horizontalGridLines",type="Boolean",inherit="no")]
   [Style(name="verticalGridLines",type="Boolean",inherit="no")]
   [Style(name="defaultDataGridItemRenderer",type="Class",inherit="no")]
   [Style(name="defaultDataGridItemEditor",type="Class",inherit="no")]
   [Style(name="disabledIconColor",type="uint",format="Color",inherit="yes",theme="halo")]
   [Style(name="iconColor",type="uint",format="Color",inherit="yes",theme="halo")]
   [Event(name="headerShift",type="mx.events.IndexChangedEvent")]
   [Event(name="headerRelease",type="mx.events.DataGridEvent")]
   [Event(name="columnStretch",type="mx.events.DataGridEvent")]
   [Event(name="itemFocusOut",type="mx.events.DataGridEvent")]
   [Event(name="itemFocusIn",type="mx.events.DataGridEvent")]
   [Event(name="itemEditEnd",type="mx.events.DataGridEvent")]
   [Event(name="itemEditorCreate",type="mx.events.DataGridEvent")]
   [Event(name="itemEditBegin",type="mx.events.DataGridEvent")]
   [Event(name="itemEditBeginning",type="mx.events.DataGridEvent")]
   public class DataGrid extends DataGridBase implements IIMESupport
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static var createAccessibilityImplementation:Function;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      [Inspectable(environment="none")]
      public var itemEditorInstance:IListItemRenderer;
      
      private var skipHeaderUpdate:Boolean = false;
      
      private var dontEdit:Boolean = false;
      
      private var losingFocus:Boolean = false;
      
      private var inEndEdit:Boolean = false;
      
      private var collectionUpdatesDisabled:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var sortIndex:int = -1;
      
      private var sortColumn:DataGridColumn;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var sortDirection:String;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var lastSortIndex:int = -1;
      
      private var lastItemDown:IListItemRenderer;
      
      private var lastItemFocused:DisplayObject;
      
      private var displayWidth:Number;
      
      private var lockedColumnWidth:Number = 0;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var movingColumn:DataGridColumn;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var resizingColumn:DataGridColumn;
      
      private var displayableColumns:Array;
      
      private var generatedColumns:Boolean = true;
      
      private var actualRowIndex:int;
      
      private var actualColIndex:int;
      
      private var actualContentHolder:ListBaseContentHolder;
      
      private var manualSort:Boolean;
      
      private var _imeMode:String = null;
      
      private var _minColumnWidth:Number;
      
      private var minColumnWidthInvalid:Boolean = false;
      
      private var _columns:Array;
      
      private var _draggableColumns:Boolean = true;
      
      private var _editable:Boolean = false;
      
      private var bEditedItemPositionChanged:Boolean = false;
      
      private var _proposedEditedItemPosition:*;
      
      private var lastEditedItemPosition:*;
      
      private var _editedItemPosition:Object;
      
      private var itemEditorPositionChanged:Boolean = false;
      
      [Inspectable(category="General")]
      public var resizableColumns:Boolean = true;
      
      [Inspectable(category="General")]
      public var sortableColumns:Boolean = true;
      
      private var _headerWordWrapPresent:Boolean = false;
      
      private var _originalExplicitHeaderHeight:Boolean = false;
      
      private var _originalHeaderHeight:Number = 0;
      
      private var _focusPane:Sprite;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var lockedColumnDropIndicator:IFlexDisplayObject;
      
      public function DataGrid()
      {
         super();
         this._columns = [];
         setRowHeight(20);
         addEventListener(DataGridEvent.ITEM_EDIT_BEGINNING,this.itemEditorItemEditBeginningHandler,false,EventPriority.DEFAULT_HANDLER);
         addEventListener(DataGridEvent.ITEM_EDIT_BEGIN,this.itemEditorItemEditBeginHandler,false,EventPriority.DEFAULT_HANDLER);
         addEventListener(DataGridEvent.ITEM_EDIT_END,this.itemEditorItemEditEndHandler,false,EventPriority.DEFAULT_HANDLER);
         addEventListener(DataGridEvent.HEADER_RELEASE,this.headerReleaseHandler,false,EventPriority.DEFAULT_HANDLER);
         addEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
      }
      
      public function get editedItemRenderer() : IListItemRenderer
      {
         if(!this.itemEditorInstance)
         {
            return null;
         }
         return this.actualContentHolder.listItems[this.actualRowIndex][this.actualColIndex];
      }
      
      override public function get baselinePosition() : Number
      {
         if(!validateBaselinePosition())
         {
            return NaN;
         }
         if(!showHeaders)
         {
            return super.baselinePosition;
         }
         var header0:IUIComponent = DataGridHeader(header).rendererArray[0];
         if(!header0)
         {
            return super.baselinePosition;
         }
         return header.y + header0.y + header0.baselinePosition;
      }
      
      override public function get columnCount() : int
      {
         if(Boolean(this._columns))
         {
            return this._columns.length;
         }
         return 0;
      }
      
      [Inspectable(category="General",enumeration="true,false",defaultValue="true")]
      override public function set enabled(value:Boolean) : void
      {
         super.enabled = value;
         if(Boolean(header))
         {
            header.enabled = value;
         }
         if(Boolean(this.itemEditorInstance))
         {
            this.endEdit(DataGridEventReason.OTHER);
         }
         this.invalidateDisplayList();
      }
      
      override public function set headerHeight(value:Number) : void
      {
         super.headerHeight = value;
         this._originalHeaderHeight = isNaN(value) ? 22 : value;
         this._originalExplicitHeaderHeight = !isNaN(value);
      }
      
      override public function set horizontalScrollPosition(value:Number) : void
      {
         var bookmark:CursorBookmark = null;
         var cursorPos:CursorBookmark = null;
         if(!initialized || listItems.length == 0)
         {
            super.horizontalScrollPosition = value;
            return;
         }
         var oldValue:int = super.horizontalScrollPosition;
         super.horizontalScrollPosition = value;
         scrollAreaChanged = true;
         columnsInvalid = true;
         this.calculateColumnSizes();
         if(itemsSizeChanged)
         {
            return;
         }
         if(oldValue != value)
         {
            removeClipMask();
            if(Boolean(iterator))
            {
               bookmark = iterator.bookmark;
            }
            clearIndicators();
            clearVisibleData();
            this.makeRowsAndColumns(0,0,listContent.width,listContent.height,0,0);
            if(Boolean(lockedRowCount))
            {
               cursorPos = lockedRowContent.iterator.bookmark;
               makeRows(lockedRowContent,0,0,unscaledWidth,unscaledHeight,0,0,true,lockedRowCount);
               if(iteratorValid)
               {
                  lockedRowContent.iterator.seek(cursorPos,0);
               }
            }
            if(headerVisible && Boolean(header))
            {
               header.visibleColumns = visibleColumns;
               header.headerItemsChanged = true;
               header.invalidateSize();
               header.validateNow();
            }
            if(Boolean(iterator) && Boolean(bookmark))
            {
               iterator.seek(bookmark,0);
            }
            this.invalidateDisplayList();
            addClipMask(false);
         }
      }
      
      override public function set horizontalScrollPolicy(value:String) : void
      {
         super.horizontalScrollPolicy = value;
         columnsInvalid = true;
         itemsSizeChanged = true;
         this.invalidateDisplayList();
      }
      
      override public function set itemRenderer(value:IFactory) : void
      {
         var n:int = 0;
         var i:int = 0;
         super.itemRenderer = value;
         if(Boolean(this.columns))
         {
            n = int(this.columns.length);
            for(i = 0; i < n; i++)
            {
               this.columns[i].resetFactories();
            }
         }
      }
      
      override public function set verticalScrollPosition(value:Number) : void
      {
         this.skipHeaderUpdate = true;
         var oldValue:Number = super.verticalScrollPosition;
         super.verticalScrollPosition = value;
         if(oldValue != value)
         {
            if(Boolean(lockedColumnContent))
            {
               this.drawRowGraphics(lockedColumnContent);
            }
         }
         this.skipHeaderUpdate = false;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(!header)
         {
            header = new headerClass();
            header.styleName = this;
            addChild(header);
         }
      }
      
      public function get enableIME() : Boolean
      {
         return false;
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
      
      override public function get itemRenderer() : IFactory
      {
         var fontName:String = null;
         var fontWeight:String = null;
         var fontStyle:String = null;
         var bold:Boolean = false;
         var italic:Boolean = false;
         var flexModuleFactory:IFlexModuleFactory = null;
         var c:Class = null;
         if(super.itemRenderer == null)
         {
            fontName = StringUtil.trimArrayElements(getStyle("fontFamily"),",");
            fontWeight = getStyle("fontWeight");
            fontStyle = getStyle("fontStyle");
            bold = fontWeight == "bold";
            italic = fontStyle == "italic";
            flexModuleFactory = getFontContext(fontName,bold,italic);
            c = getStyle("defaultDataGridItemRenderer");
            if(!c)
            {
               c = DataGridItemRenderer;
            }
            super.itemRenderer = new ContextualClassFactory(c,flexModuleFactory);
         }
         return super.itemRenderer;
      }
      
      [Inspectable(defaultValue="NaN")]
      public function get minColumnWidth() : Number
      {
         return this._minColumnWidth;
      }
      
      public function set minColumnWidth(value:Number) : void
      {
         this._minColumnWidth = value;
         this.minColumnWidthInvalid = true;
         itemsSizeChanged = true;
         columnsInvalid = true;
         this.invalidateDisplayList();
      }
      
      [Inspectable(category="General",arrayType="mx.controls.dataGridClasses.DataGridColumn")]
      [Bindable("columnsChanged")]
      override public function get columns() : Array
      {
         return this._columns.slice(0);
      }
      
      override public function set columns(value:Array) : void
      {
         var n:int = 0;
         var i:int = 0;
         var column:DataGridColumn = null;
         var item:DisplayObject = null;
         n = int(this._columns.length);
         for(i = 0; i < n; i++)
         {
            this.columnRendererChanged(this._columns[i]);
         }
         freeItemRenderersTable = new Dictionary(false);
         columnMap = {};
         this._columns = value.slice(0);
         columnsInvalid = true;
         this.generatedColumns = false;
         n = int(value.length);
         for(i = 0; i < n; i++)
         {
            column = this._columns[i];
            column.owner = this;
            column.colNum = i;
            if(Boolean(column.cachedHeaderRenderer))
            {
               item = column.cachedHeaderRenderer as DisplayObject;
               if(Boolean(item.parent))
               {
                  item.parent.removeChild(item);
               }
               column.cachedHeaderRenderer = null;
            }
         }
         this.updateSortIndexAndDirection();
         fontContextChanged = true;
         invalidateProperties();
         itemsSizeChanged = true;
         this.invalidateDisplayList();
         dispatchEvent(new Event("columnsChanged"));
      }
      
      [Inspectable(defaultValue="true")]
      public function get draggableColumns() : Boolean
      {
         return this._draggableColumns;
      }
      
      public function set draggableColumns(value:Boolean) : void
      {
         this._draggableColumns = value;
      }
      
      [Inspectable(category="General")]
      public function get editable() : Boolean
      {
         return this._editable;
      }
      
      public function set editable(value:Boolean) : void
      {
         this._editable = value;
      }
      
      [Bindable("itemFocusIn")]
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
      
      override public function invalidateDisplayList() : void
      {
         super.invalidateDisplayList();
         if(Boolean(header))
         {
            header.headerItemsChanged = true;
            header.invalidateSize();
            header.invalidateDisplayList();
         }
         if(Boolean(lockedColumnHeader))
         {
            lockedColumnHeader.headerItemsChanged = true;
            lockedColumnHeader.invalidateSize();
            lockedColumnHeader.invalidateDisplayList();
         }
      }
      
      [Inspectable(category="Data",defaultValue="undefined")]
      override public function set dataProvider(value:Object) : void
      {
         if(Boolean(this.itemEditorInstance))
         {
            this.endEdit(DataGridEventReason.OTHER);
         }
         this.lastEditedItemPosition = null;
         super.dataProvider = value;
      }
      
      override protected function initializeAccessibility() : void
      {
         if(DataGrid.createAccessibilityImplementation != null)
         {
            DataGrid.createAccessibilityImplementation(this);
         }
      }
      
      override protected function measure() : void
      {
         var o:EdgeMetrics = null;
         super.measure();
         if(explicitRowCount != -1)
         {
            measuredHeight += _explicitHeaderHeight ? headerHeight : header.getExplicitOrMeasuredHeight();
            measuredMinHeight += _explicitHeaderHeight ? headerHeight : header.getExplicitOrMeasuredHeight();
         }
         o = viewMetrics;
         var n:int = int(this.columns.length);
         if(n == 0)
         {
            measuredWidth = DEFAULT_MEASURED_WIDTH;
            measuredMinWidth = DEFAULT_MEASURED_MIN_WIDTH;
            return;
         }
         var columnWidths:Number = 0;
         var columnMinWidths:Number = 0;
         for(var i:int = 0; i < n; i++)
         {
            if(Boolean(this.columns[i].visible))
            {
               columnWidths += this.columns[i].preferredWidth;
               if(isNaN(this._minColumnWidth))
               {
                  columnMinWidths += this.columns[i].minWidth;
               }
            }
         }
         if(!isNaN(this._minColumnWidth))
         {
            columnMinWidths = n * this._minColumnWidth;
         }
         measuredWidth = columnWidths + o.left + o.right;
         measuredMinWidth = columnMinWidths + o.left + o.right;
         if(Boolean(verticalScrollPolicy == ScrollPolicy.AUTO) && Boolean(verticalScrollBar) && Boolean(verticalScrollBar.visible))
         {
            measuredWidth -= verticalScrollBar.minWidth;
            measuredMinWidth -= verticalScrollBar.minWidth;
         }
         if(Boolean(horizontalScrollPolicy == ScrollPolicy.AUTO) && Boolean(horizontalScrollBar) && Boolean(horizontalScrollBar.visible))
         {
            measuredHeight -= horizontalScrollBar.minHeight;
            measuredMinHeight -= horizontalScrollBar.minHeight;
         }
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var hh:Number = NaN;
         var bm:EdgeMetrics = null;
         if(this.displayWidth != unscaledWidth - viewMetrics.right - viewMetrics.left)
         {
            this.displayWidth = unscaledWidth - viewMetrics.right - viewMetrics.left;
            columnsInvalid = true;
         }
         this.calculateColumnSizes();
         if(this.itemEditorPositionChanged)
         {
            this.itemEditorPositionChanged = false;
            if(!this.lastItemDown)
            {
               this.scrollToEditedItem(this.editedItemPosition.rowIndex,this.editedItemPosition.colIndex);
            }
         }
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(Boolean(collection) && Boolean(collection.length))
         {
            setRowCount(listItems.length);
            if(Boolean(listItems.length))
            {
               setColumnCount(listItems[0].length);
            }
            else
            {
               setColumnCount(0);
            }
         }
         if(verticalScrollBar != null && Boolean(verticalScrollBar.visible) && (horizontalScrollBar == null || !horizontalScrollBar.visible) && headerVisible)
         {
            hh = Number(header.height);
            bm = borderMetrics;
            if(roomForScrollBar(verticalScrollBar,unscaledWidth - bm.left - bm.right,unscaledHeight - hh - bm.top - bm.bottom))
            {
               verticalScrollBar.move(verticalScrollBar.x,viewMetrics.top + hh);
               verticalScrollBar.setActualSize(verticalScrollBar.width,unscaledHeight - viewMetrics.top - viewMetrics.bottom - hh);
               verticalScrollBar.visible = true;
               headerMask.width += verticalScrollBar.getExplicitOrMeasuredWidth();
               if(!DataGridHeader(header).needRightSeparator)
               {
                  header.invalidateDisplayList();
                  DataGridHeader(header).needRightSeparator = true;
               }
            }
            else if(DataGridHeader(header).needRightSeparator)
            {
               header.invalidateDisplayList();
               DataGridHeader(header).needRightSeparator = false;
            }
         }
         else if(DataGridHeader(header).needRightSeparator)
         {
            header.invalidateDisplayList();
            DataGridHeader(header).needRightSeparator = false;
         }
         if(this.bEditedItemPositionChanged)
         {
            this.bEditedItemPositionChanged = false;
            if(!this.lastItemDown)
            {
               this.commitEditedItemPosition(this._proposedEditedItemPosition);
            }
            this._proposedEditedItemPosition = undefined;
            itemsSizeChanged = false;
         }
         this.drawRowBackgrounds();
         this.drawLinesAndColumnBackgrounds();
         if(Boolean(lockedRowCount) && Boolean(lockedRowContent))
         {
            this.drawRowGraphics(lockedRowContent);
            this.drawLinesAndColumnGraphics(lockedRowContent,visibleColumns,{"bottom":1});
            if(Boolean(lockedColumnCount))
            {
               this.drawRowGraphics(lockedColumnAndRowContent);
               this.drawLinesAndColumnGraphics(lockedColumnAndRowContent,visibleLockedColumns,{
                  "right":1,
                  "bottom":1
               });
            }
         }
         if(Boolean(lockedColumnCount))
         {
            this.drawRowGraphics(lockedColumnContent);
            this.drawLinesAndColumnGraphics(lockedColumnContent,visibleLockedColumns,{"right":1});
         }
      }
      
      override protected function makeRowsAndColumns(left:Number, top:Number, right:Number, bottom:Number, firstCol:int, firstRow:int, byCount:Boolean = false, rowsNeeded:uint = 0) : Point
      {
         var col:DataGridColumn = null;
         var item:IListItemRenderer = null;
         var rowData:ListRowInfo = null;
         var lines:Sprite = null;
         var dx:Number = NaN;
         var dy:Number = NaN;
         var dw:Number = NaN;
         var dh:Number = NaN;
         allowItemSizeChangeNotification = false;
         var pt:Point = super.makeRowsAndColumns(left,top,right,bottom,firstCol,firstRow,byCount,rowsNeeded);
         if(Boolean(this.itemEditorInstance))
         {
            this.actualContentHolder.setChildIndex(DisplayObject(this.itemEditorInstance),this.actualContentHolder.numChildren - 1);
            if(Boolean(lockedColumnCount) && this.editedItemPosition.columnIndex <= visibleLockedColumns[lockedColumnCount - 1].colNum)
            {
               col = visibleLockedColumns[this.actualColIndex];
            }
            else
            {
               col = visibleColumns[this.actualColIndex];
            }
            item = this.actualContentHolder.listItems[this.actualRowIndex][this.actualColIndex];
            rowData = this.actualContentHolder.rowInfo[this.actualRowIndex];
            if(Boolean(item) && !col.rendererIsEditor)
            {
               dx = col.editorXOffset;
               dy = col.editorYOffset;
               dw = col.editorWidthOffset;
               dh = col.editorHeightOffset;
               this.itemEditorInstance.move(item.x + dx,rowData.y + dy);
               this.itemEditorInstance.setActualSize(Math.min(col.width + dw,this.actualContentHolder.width - this.itemEditorInstance.x),Math.min(rowData.height + dh,this.actualContentHolder.height - this.itemEditorInstance.y));
               item.visible = false;
            }
            lines = Sprite(this.actualContentHolder.getChildByName("lines"));
            if(Boolean(lines))
            {
               this.actualContentHolder.setChildIndex(lines,this.actualContentHolder.numChildren - 1);
            }
         }
         allowItemSizeChangeNotification = variableRowHeight;
         return pt;
      }
      
      override protected function commitProperties() : void
      {
         var c:DataGridColumn = null;
         var n:int = 0;
         var j:int = 0;
         var paddingTop:Number = NaN;
         var paddingBottom:Number = NaN;
         var data:Object = null;
         var item:IListItemRenderer = null;
         var ch:Number = NaN;
         super.commitProperties();
         if(fontContextChanged)
         {
            fontContextChanged = false;
            n = int(this.columns.length);
            for(j = 0; j < n; j++)
            {
               c = this.columns[j];
               c.determineFontContext();
            }
         }
         if(itemsNeedMeasurement)
         {
            itemsNeedMeasurement = false;
            if(isNaN(explicitRowHeight))
            {
               if(Boolean(iterator) && this.columns.length > 0)
               {
                  visibleColumns = this.columns;
                  columnsInvalid = true;
                  paddingTop = Number(getStyle("paddingTop"));
                  paddingBottom = Number(getStyle("paddingBottom"));
                  data = iterator.current;
                  ch = 0;
                  n = int(this.columns.length);
                  for(j = 0; j < n; j++)
                  {
                     c = this.columns[j];
                     if(c.visible)
                     {
                        item = c.getMeasuringRenderer(false,data);
                        if(DisplayObject(item).parent == null)
                        {
                           listContent.addChild(DisplayObject(item));
                        }
                        this.setupRendererFromData(c,item,data);
                        ch = Math.max(ch,item.getExplicitOrMeasuredHeight() + paddingBottom + paddingTop);
                     }
                  }
                  setRowHeight(Math.max(ch,20));
               }
               else
               {
                  setRowHeight(20);
               }
               if(!collection || collection.length == 0 || this.columns.length == 0)
               {
                  itemsNeedMeasurement = true;
               }
            }
         }
      }
      
      override public function measureWidthOfItems(index:int = -1, count:int = 0) : Number
      {
         var w:Number = 0;
         var n:int = Boolean(this.columns) ? int(this.columns.length) : 0;
         for(var i:int = 0; i < n; i++)
         {
            if(Boolean(this.columns[i].visible))
            {
               w += this.columns[i].width;
            }
         }
         return w;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setupRendererFromData(c:DataGridColumn, item:IListItemRenderer, data:Object) : void
      {
         var rowData:DataGridListData = DataGridListData(makeListData(data,itemToUID(data),0,c.colNum,c));
         if(item is IDropInListItemRenderer)
         {
            IDropInListItemRenderer(item).listData = Boolean(data) ? rowData : null;
         }
         item.data = data;
         item.explicitWidth = getWidthOfItem(item,c);
         UIComponentGlobals.layoutManager.validateClient(item,true);
      }
      
      override public function measureHeightOfItems(index:int = -1, count:int = 0) : Number
      {
         return this.measureHeightOfItemsUptoMaxHeight(index,count);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function measureHeightOfItemsUptoMaxHeight(index:int = -1, count:int = 0, maxHeight:Number = -1) : Number
      {
         var h:Number;
         var ch:Number;
         var paddingTop:Number;
         var paddingBottom:Number;
         var lockedCount:int;
         var bookmark:CursorBookmark;
         var bMore:Boolean;
         var i:int;
         var item:IListItemRenderer = null;
         var c:DataGridColumn = null;
         var n:int = 0;
         var j:int = 0;
         var data:Object = null;
         if(!this.columns.length)
         {
            return rowHeight * count;
         }
         h = 0;
         ch = 0;
         paddingTop = Number(getStyle("paddingTop"));
         paddingBottom = Number(getStyle("paddingBottom"));
         lockedCount = lockedRowCount;
         if(headerVisible && count > 0 && index == -1)
         {
            h = this.calculateHeaderHeight();
            if(maxHeight != -1 && h > maxHeight)
            {
               setRowCount(0);
               return 0;
            }
            count--;
            index = 0;
         }
         bookmark = Boolean(iterator) ? iterator.bookmark : null;
         bMore = iterator != null;
         if(index != -1 && Boolean(iterator))
         {
            try
            {
               iterator.seek(CursorBookmark.FIRST,index);
            }
            catch(e:ItemPendingError)
            {
               bMore = false;
            }
         }
         if(lockedCount > 0)
         {
            try
            {
               collectionIterator.seek(CursorBookmark.FIRST,0);
            }
            catch(e:ItemPendingError)
            {
               bMore = false;
            }
         }
         for(i = 0; i < count; i++)
         {
            if(bMore)
            {
               data = lockedCount > 0 ? collectionIterator.current : iterator.current;
               ch = 0;
               n = int(this.columns.length);
               for(j = 0; j < n; j++)
               {
                  c = this.columns[j];
                  if(c.visible)
                  {
                     item = c.getMeasuringRenderer(false,data);
                     if(DisplayObject(item).parent == null)
                     {
                        listContent.addChild(DisplayObject(item));
                     }
                     this.setupRendererFromData(c,item,data);
                     ch = Math.ceil(Math.max(ch,variableRowHeight ? item.getExplicitOrMeasuredHeight() + paddingBottom + paddingTop : rowHeight));
                  }
               }
            }
            if(maxHeight != -1 && (h + ch > maxHeight || !bMore))
            {
               try
               {
                  if(Boolean(iterator))
                  {
                     iterator.seek(bookmark,0);
                  }
               }
               catch(e:ItemPendingError)
               {
               }
               count = headerVisible ? int(i + 1) : i;
               setRowCount(count);
               return h;
            }
            h += ch;
            if(Boolean(iterator))
            {
               try
               {
                  bMore = Boolean(iterator.moveNext());
                  if(lockedCount > 0)
                  {
                     collectionIterator.moveNext();
                     lockedCount--;
                  }
               }
               catch(e:ItemPendingError)
               {
                  bMore = false;
                  continue;
               }
            }
         }
         if(Boolean(iterator))
         {
            try
            {
               iterator.seek(bookmark,0);
            }
            catch(e:ItemPendingError)
            {
            }
         }
         return h;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function calculateHeaderHeight() : Number
      {
         var item:IListItemRenderer = null;
         var c:DataGridColumn = null;
         var rowData:DataGridListData = null;
         var n:int = 0;
         var j:int = 0;
         if(!this.columns.length)
         {
            return rowHeight;
         }
         if(!listContent)
         {
            return rowHeight;
         }
         var ch:Number = 0;
         var paddingTop:Number = Number(getStyle("paddingTop"));
         var paddingBottom:Number = Number(getStyle("paddingBottom"));
         if(showHeaders)
         {
            ch = 0;
            n = int(this.columns.length);
            if(this._headerWordWrapPresent)
            {
               _headerHeight = this._originalHeaderHeight;
               _explicitHeaderHeight = this._originalExplicitHeaderHeight;
            }
            for(j = 0; j < n; j++)
            {
               c = this.columns[j];
               if(c.visible)
               {
                  item = c.cachedHeaderRenderer;
                  if(!item)
                  {
                     item = createColumnItemRenderer(c,true,c);
                     item.styleName = c;
                     c.cachedHeaderRenderer = item;
                  }
                  if(DisplayObject(item).parent == null)
                  {
                     listContent.addChild(DisplayObject(item));
                     item.visible = false;
                  }
                  rowData = DataGridListData(makeListData(c,uid,0,c.colNum,c));
                  rowMap[item.name] = rowData;
                  if(item is IDropInListItemRenderer)
                  {
                     IDropInListItemRenderer(item).listData = rowData;
                  }
                  item.data = c;
                  item.explicitWidth = c.width;
                  UIComponentGlobals.layoutManager.validateClient(item,true);
                  ch = Math.max(ch,_explicitHeaderHeight ? headerHeight : item.getExplicitOrMeasuredHeight() + paddingBottom + paddingTop);
                  if(columnHeaderWordWrap(c))
                  {
                     this._headerWordWrapPresent = true;
                  }
               }
            }
            if(this._headerWordWrapPresent)
            {
               this._originalHeaderHeight = _headerHeight;
               this._originalExplicitHeaderHeight = _explicitHeaderHeight;
               _headerHeight = ch;
               _explicitHeaderHeight = true;
            }
         }
         return ch;
      }
      
      override protected function calculateRowHeight(data:Object, hh:Number, skipVisible:Boolean = false) : Number
      {
         var item:IListItemRenderer = null;
         var c:DataGridColumn = null;
         var j:int = 0;
         var n:int = int(this.columns.length);
         var k:int = 0;
         var l:int = int(visibleLockedColumns.length);
         if(skipVisible && visibleColumns.length == this._columns.length)
         {
            return hh;
         }
         var paddingTop:Number = Number(getStyle("paddingTop"));
         var paddingBottom:Number = Number(getStyle("paddingBottom"));
         for(j = 0; j < n; j++)
         {
            if(skipVisible && k < l && visibleLockedColumns[k].colNum == this.columns[j].colNum)
            {
               k++;
            }
            else if(skipVisible && k - l < visibleColumns.length && visibleColumns[k - l].colNum == this.columns[j].colNum)
            {
               k++;
            }
            else
            {
               c = this.columns[j];
               if(c.visible)
               {
                  item = c.getMeasuringRenderer(false,data);
                  if(DisplayObject(item).parent == null)
                  {
                     listContent.addChild(DisplayObject(item));
                  }
                  this.setupRendererFromData(c,item,data);
                  hh = Math.max(hh,item.getExplicitOrMeasuredHeight() + paddingBottom + paddingTop);
               }
            }
         }
         return hh;
      }
      
      override protected function scrollHandler(event:Event) : void
      {
         var scrollBar:ScrollBar = null;
         var pos:Number = NaN;
         if(event.target == verticalScrollBar || event.target == horizontalScrollBar)
         {
            if(event is ScrollEvent)
            {
               if(!liveScrolling && ScrollEvent(event).detail == ScrollEventDetail.THUMB_TRACK)
               {
                  return;
               }
               if(Boolean(this.itemEditorInstance))
               {
                  this.endEdit(DataGridEventReason.OTHER);
               }
               scrollBar = ScrollBar(event.target);
               pos = scrollBar.scrollPosition;
               if(scrollBar == verticalScrollBar)
               {
                  this.verticalScrollPosition = pos;
               }
               else if(scrollBar == horizontalScrollBar)
               {
                  this.horizontalScrollPosition = pos;
               }
               super.scrollHandler(event);
            }
         }
      }
      
      private function displayingPartialRow() : Boolean
      {
         var index:int = listItems.length - 1 - offscreenExtraRowsBottom;
         if(rowInfo[index].y + rowInfo[index].height > listContent.heightExcludingOffsets - listContent.topOffset)
         {
            return true;
         }
         return false;
      }
      
      override protected function configureScrollBars() : void
      {
         var bookmark:CursorBookmark = null;
         var rowIndex:int = 0;
         var colX:int = 0;
         var i:int = 0;
         if(columnsInvalid)
         {
            return;
         }
         if(!this.displayableColumns)
         {
            return;
         }
         var countableContentListItems:Array = this.listItems;
         if(Boolean(visibleColumns && !visibleColumns.length) && Boolean(visibleLockedColumns) && Boolean(visibleLockedColumns.length))
         {
            countableContentListItems = lockedColumnContent.listItems;
         }
         var oldHorizontalScrollBar:Object = horizontalScrollBar;
         var oldVerticalScrollBar:Object = verticalScrollBar;
         var rowCount:int = int(countableContentListItems.length);
         if(rowCount == 0)
         {
            if(Boolean(oldHorizontalScrollBar) || Boolean(oldVerticalScrollBar))
            {
               if(Boolean(listContent.height))
               {
                  setScrollBarProperties(0,0,0,0);
               }
            }
            return;
         }
         if(rowCount > 1 && this.displayingPartialRow())
         {
            rowCount--;
         }
         var offset:int = verticalScrollPosition;
         var fillerRows:int = 0;
         while(Boolean(rowCount) && countableContentListItems[rowCount - 1].length == 0)
         {
            if(!(Boolean(collection) && rowCount + offset >= collection.length - lockedRowCount))
            {
               break;
            }
            rowCount--;
            fillerRows++;
         }
         if(verticalScrollPosition > 0 && fillerRows > 0)
         {
            bookmark = iterator.bookmark;
            rowIndex = int(bookmark.getViewIndex());
            if(verticalScrollPosition != rowIndex - lockedRowCount)
            {
               super.verticalScrollPosition = Math.max(rowIndex - lockedRowCount,0);
            }
            if(this.adjustVerticalScrollPositionDownward(Math.max(rowCount,1)))
            {
               return;
            }
         }
         rowCount -= offscreenExtraRowsTop + offscreenExtraRowsBottom;
         var collectionHasRows:Boolean = Boolean(collection) && collection.length > 0;
         var colCount:int = collectionHasRows && rowCount > 0 ? int(listItems[0].length) : int(visibleColumns.length);
         if(collectionHasRows && rowCount > 0 && colCount > 1 && listItems[0][colCount - 1].x + visibleColumns[colCount - 1].width > this.displayWidth - listContent.x + viewMetrics.left)
         {
            colCount--;
         }
         else if(colCount > 1 && !collectionHasRows)
         {
            colX = 0;
            for(i = 0; i < visibleColumns.length; i++)
            {
               colX += visibleColumns[i].width;
            }
            if(colX > this.displayWidth - listContent.x + viewMetrics.left)
            {
               colCount--;
            }
         }
         setScrollBarProperties(this.displayableColumns.length - lockedColumnCount,Math.max(colCount,1),Boolean(collection) ? int(collection.length - lockedRowCount) : 0,Math.max(rowCount,1));
         if((Boolean(!verticalScrollBar || !verticalScrollBar.visible)) && Boolean(collection) && collection.length - lockedRowCount > rowCount)
         {
            maxVerticalScrollPosition = collection.length - lockedRowCount - rowCount;
         }
         if((!horizontalScrollBar || !horizontalScrollBar.visible) && this.displayableColumns.length - lockedColumnCount > colCount - lockedColumnCount)
         {
            maxHorizontalScrollPosition = this.displayableColumns.length - lockedColumnCount - colCount;
         }
      }
      
      private function adjustVerticalScrollPositionDownward(rowCount:int) : Boolean
      {
         var item:IListItemRenderer = null;
         var c:DataGridColumn = null;
         var n:int = 0;
         var j:int = 0;
         var bMore:Boolean = false;
         var data:Object = null;
         var bookmark:CursorBookmark = iterator.bookmark;
         var h:Number = 0;
         var ch:Number = 0;
         var paddingTop:Number = Number(getStyle("paddingTop"));
         var paddingBottom:Number = Number(getStyle("paddingBottom"));
         h = rowInfo[rowCount - 1].y + rowInfo[rowCount - 1].height;
         h = listContent.heightExcludingOffsets - listContent.topOffset - h;
         var numRows:int = 0;
         try
         {
            if(iterator.afterLast)
            {
               iterator.seek(CursorBookmark.LAST,0);
            }
            else
            {
               bMore = Boolean(iterator.movePrevious());
            }
         }
         catch(e:ItemPendingError)
         {
            bMore = false;
         }
         if(!bMore)
         {
            super.verticalScrollPosition = 0;
            try
            {
               iterator.seek(CursorBookmark.FIRST,0);
               if(!iteratorValid)
               {
                  iteratorValid = true;
                  lastSeekPending = null;
               }
            }
            catch(e:ItemPendingError)
            {
               lastSeekPending = new ListBaseSeekPending(CursorBookmark.FIRST,0);
               e.addResponder(new ItemResponder(seekPendingResultHandler,seekPendingFailureHandler,lastSeekPending));
               iteratorValid = false;
               invalidateList();
               return true;
            }
            updateList();
            return true;
         }
         while(h > 0 && bMore)
         {
            if(bMore)
            {
               data = iterator.current;
               ch = 0;
               n = int(this.columns.length);
               for(j = 0; j < n; j++)
               {
                  c = this.columns[j];
                  if(c.visible)
                  {
                     if(variableRowHeight)
                     {
                        item = c.getMeasuringRenderer(false,data);
                        if(DisplayObject(item).parent == null)
                        {
                           listContent.addChild(DisplayObject(item));
                        }
                        this.setupRendererFromData(c,item,data);
                     }
                     ch = Math.max(ch,variableRowHeight ? item.getExplicitOrMeasuredHeight() + paddingBottom + paddingTop : rowHeight);
                  }
               }
            }
            h -= ch;
            try
            {
               bMore = Boolean(iterator.movePrevious());
               numRows++;
            }
            catch(e:ItemPendingError)
            {
               bMore = false;
            }
         }
         if(h < 0)
         {
            numRows--;
         }
         iterator.seek(bookmark,0);
         this.verticalScrollPosition = Math.max(0,verticalScrollPosition - numRows);
         if(numRows > 0 && !variableRowHeight)
         {
            this.configureScrollBars();
         }
         return numRows > 0;
      }
      
      override public function calculateDropIndex(event:DragEvent = null) : int
      {
         var item:IListItemRenderer = null;
         var lastItem:IListItemRenderer = null;
         var pt:Point = null;
         var n:int = 0;
         var i:int = 0;
         if(Boolean(event))
         {
            pt = new Point(event.localX,event.localY);
            pt = DisplayObject(event.target).localToGlobal(pt);
            pt = listContent.globalToLocal(pt);
            n = int(listItems.length);
            for(i = 0; i < n; i++)
            {
               if(Boolean(listItems[i][0]))
               {
                  lastItem = listItems[i][0];
               }
               if(rowInfo[i].y <= pt.y && pt.y < rowInfo[i].y + rowInfo[i].height)
               {
                  item = listItems[i][0];
                  break;
               }
            }
            if(!item && Boolean(lockedRowContent))
            {
               pt = listContent.localToGlobal(pt);
               pt = lockedRowContent.globalToLocal(pt);
               n = int(lockedRowContent.listItems.length);
               for(i = 0; i < n; i++)
               {
                  if(lockedRowContent.rowInfo[i].y <= pt.y && pt.y < lockedRowContent.rowInfo[i].y + lockedRowContent.rowInfo[i].height)
                  {
                     item = lockedRowContent.listItems[i][0];
                     break;
                  }
               }
            }
            if(Boolean(item))
            {
               lastDropIndex = itemRendererToIndex(item);
            }
            else if(Boolean(lastItem))
            {
               lastDropIndex = itemRendererToIndex(lastItem) + 1;
            }
            else
            {
               lastDropIndex = Boolean(collection) ? int(collection.length) : 0;
            }
         }
         return lastDropIndex;
      }
      
      override protected function drawRowBackgrounds() : void
      {
         this.drawRowGraphics(listContent);
      }
      
      protected function drawRowGraphics(contentHolder:ListBaseContentHolder) : void
      {
         var colors:Array = null;
         var n:int = 0;
         var rowBGs:Sprite = Sprite(contentHolder.getChildByName("rowBGs"));
         if(!rowBGs)
         {
            rowBGs = new FlexSprite();
            rowBGs.mouseEnabled = false;
            rowBGs.name = "rowBGs";
            contentHolder.addChildAt(rowBGs,0);
         }
         var colorsStyle:Object = getStyle("alternatingItemColors");
         if(Boolean(colorsStyle))
         {
            colors = colorsStyle is Array ? colorsStyle as Array : [colorsStyle];
         }
         if(!colors || colors.length == 0)
         {
            while(rowBGs.numChildren > n)
            {
               rowBGs.removeChildAt(rowBGs.numChildren - 1);
            }
            return;
         }
         styleManager.getColorNames(colors);
         var curRow:int = 0;
         var i:int = 0;
         var actualRow:int = verticalScrollPosition;
         n = int(contentHolder.listItems.length);
         while(curRow < n)
         {
            this.drawRowBackground(rowBGs,i++,contentHolder.rowInfo[curRow].y,contentHolder.rowInfo[curRow].height,colors[actualRow % colors.length],actualRow);
            curRow++;
            actualRow++;
         }
         while(rowBGs.numChildren > i)
         {
            rowBGs.removeChildAt(rowBGs.numChildren - 1);
         }
      }
      
      override protected function mouseEventToItemRenderer(event:MouseEvent) : IListItemRenderer
      {
         var r:IListItemRenderer = null;
         r = super.mouseEventToItemRenderer(event);
         return r == this.itemEditorInstance ? null : r;
      }
      
      override protected function get dragImage() : IUIComponent
      {
         var image:DataGridDragProxy = new DataGridDragProxy();
         image.owner = this;
         image.moduleFactory = moduleFactory;
         return image;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function shiftColumns(oldIndex:int, newIndex:int, trigger:Event = null) : void
      {
         var incr:int = 0;
         var i:int = 0;
         var icEvent:IndexChangedEvent = null;
         var j:int = 0;
         var c:DataGridColumn = null;
         if(newIndex >= 0 && oldIndex != newIndex)
         {
            incr = oldIndex < newIndex ? 1 : -1;
            for(i = oldIndex; i != newIndex; i += incr)
            {
               j = i + incr;
               c = this._columns[i];
               this._columns[i] = this._columns[j];
               this._columns[j] = c;
               this._columns[i].colNum = i;
               this._columns[j].colNum = j;
            }
            if(this.sortIndex == oldIndex)
            {
               this.sortIndex += newIndex - oldIndex;
            }
            else if(oldIndex < this.sortIndex && this.sortIndex <= newIndex || newIndex <= this.sortIndex && this.sortIndex < oldIndex)
            {
               this.sortIndex -= incr;
            }
            if(this.lastSortIndex == oldIndex)
            {
               this.lastSortIndex += newIndex - oldIndex;
            }
            else if(oldIndex < this.lastSortIndex && this.lastSortIndex <= newIndex || newIndex <= this.lastSortIndex && this.lastSortIndex < oldIndex)
            {
               this.lastSortIndex -= incr;
            }
            columnsInvalid = true;
            itemsSizeChanged = true;
            this.invalidateDisplayList();
            if(Boolean(lockedColumnHeader))
            {
               lockedColumnHeader.invalidateDisplayList();
            }
            icEvent = new IndexChangedEvent(IndexChangedEvent.HEADER_SHIFT);
            icEvent.oldIndex = oldIndex;
            icEvent.newIndex = newIndex;
            icEvent.triggerEvent = trigger;
            dispatchEvent(icEvent);
         }
      }
      
      private function generateCols() : void
      {
         var col:DataGridColumn = null;
         var newCols:Array = null;
         var cols:Array = null;
         var info:Object = null;
         var itmObj:Object = null;
         var p:String = null;
         var n:int = 0;
         var colName:Object = null;
         var i:int = 0;
         if(collection.length > 0)
         {
            newCols = [];
            if(Boolean(dataProvider))
            {
               try
               {
                  iterator.seek(CursorBookmark.FIRST);
                  if(!iteratorValid)
                  {
                     iteratorValid = true;
                     lastSeekPending = null;
                  }
               }
               catch(e:ItemPendingError)
               {
                  lastSeekPending = new ListBaseSeekPending(CursorBookmark.FIRST,0);
                  e.addResponder(new ItemResponder(generateColumnsPendingResultHandler,seekPendingFailureHandler,lastSeekPending));
                  iteratorValid = false;
                  return;
               }
               info = ObjectUtil.getClassInfo(iterator.current,["uid","mx_internal_uid"]);
               if(Boolean(info))
               {
                  cols = info.properties;
               }
            }
            if(!cols)
            {
               itmObj = iterator.current;
               for(p in itmObj)
               {
                  if(p != "uid")
                  {
                     col = new DataGridColumn();
                     col.dataField = p;
                     newCols.push(col);
                  }
               }
            }
            else
            {
               n = int(cols.length);
               for(i = 0; i < n; i++)
               {
                  colName = cols[i];
                  if(colName is QName)
                  {
                     colName = QName(colName).localName;
                  }
                  col = new DataGridColumn();
                  col.dataField = String(colName);
                  newCols.push(col);
               }
            }
            this.columns = newCols;
            this.generatedColumns = true;
         }
      }
      
      private function generateColumnsPendingResultHandler(data:Object, info:ListBaseSeekPending) : void
      {
         if(this.columns.length == 0)
         {
            this.generateCols();
         }
         seekPendingResultHandler(data,info);
      }
      
      private function calculateColumnSizes() : void
      {
         var delta:Number = NaN;
         var n:int = 0;
         var i:int = 0;
         var col:DataGridColumn = null;
         var cw:Number = NaN;
         var lastColumn:DataGridColumn = null;
         var newSize:Number = NaN;
         var k:int = 0;
         var numResizable:int = 0;
         var fixedWidth:Number = NaN;
         var ratio:Number = NaN;
         var newTotal:Number = NaN;
         var minWidth:Number = NaN;
         var totalWidth:Number = 0;
         if(this.columns.length == 0)
         {
            visibleColumns = [];
            visibleLockedColumns = [];
            this.lockedColumnWidth = 0;
            columnsInvalid = false;
            return;
         }
         if(columnsInvalid)
         {
            columnsInvalid = false;
            visibleColumns = [];
            visibleLockedColumns = [];
            this.lockedColumnWidth = 0;
            if(this.minColumnWidthInvalid)
            {
               n = int(this.columns.length);
               for(i = 0; i < n; i++)
               {
                  this.columns[i].minWidth = this.minColumnWidth;
               }
               this.minColumnWidthInvalid = false;
            }
            this.displayableColumns = null;
            n = int(this._columns.length);
            for(i = 0; i < n; i++)
            {
               if(Boolean(this.displayableColumns) && Boolean(this._columns[i].visible))
               {
                  this.displayableColumns.push(this._columns[i]);
               }
               else if(!this.displayableColumns && !this._columns[i].visible)
               {
                  this.displayableColumns = new Array(i);
                  for(k = 0; k < i; k++)
                  {
                     this.displayableColumns[k] = this._columns[k];
                  }
               }
            }
            if(!this.displayableColumns)
            {
               this.displayableColumns = this._columns;
            }
            if(horizontalScrollPolicy == ScrollPolicy.OFF)
            {
               n = int(this.displayableColumns.length);
               for(i = 0; i < n; i++)
               {
                  col = this.displayableColumns[i];
                  if(i < lockedColumnCount)
                  {
                     visibleLockedColumns.push(col);
                  }
                  else
                  {
                     visibleColumns.push(col);
                  }
               }
            }
            else
            {
               n = int(this.displayableColumns.length);
               for(i = 0; i < n; i++)
               {
                  if(!(i >= lockedColumnCount && i < lockedColumnCount + horizontalScrollPosition))
                  {
                     col = this.displayableColumns[i];
                     if(col.preferredWidth < col.minWidth)
                     {
                        col.preferredWidth = col.minWidth;
                     }
                     if(totalWidth >= this.displayWidth)
                     {
                        if(visibleColumns.length == 0)
                        {
                           visibleColumns.push(this.displayableColumns[0]);
                        }
                        break;
                     }
                     if(i < lockedColumnCount)
                     {
                        this.lockedColumnWidth += Math.max(isNaN(col.explicitWidth) ? col.preferredWidth : col.explicitWidth,col.minWidth);
                        visibleLockedColumns.push(col);
                     }
                     else
                     {
                        visibleColumns.push(col);
                     }
                     totalWidth += Math.max(isNaN(col.explicitWidth) ? col.preferredWidth : col.explicitWidth,col.minWidth);
                     if(col.width != col.preferredWidth)
                     {
                        col.setWidth(col.preferredWidth);
                     }
                  }
               }
            }
         }
         if(horizontalScrollPolicy == ScrollPolicy.OFF)
         {
            numResizable = 0;
            fixedWidth = 0;
            n = int(visibleColumns.length);
            for(i = 0; i < n; i++)
            {
               if(Boolean(visibleColumns[i].resizable) && !visibleColumns[i].newlyVisible)
               {
                  if(!isNaN(visibleColumns[i].explicitWidth))
                  {
                     fixedWidth += visibleColumns[i].width;
                  }
                  else
                  {
                     numResizable++;
                     fixedWidth += visibleColumns[i].minWidth;
                  }
               }
               else
               {
                  fixedWidth += visibleColumns[i].width;
               }
               totalWidth += visibleColumns[i].width;
            }
            n = int(visibleLockedColumns.length);
            for(i = 0; i < n; i++)
            {
               if(Boolean(visibleLockedColumns[i].resizable) && !visibleLockedColumns[i].newlyVisible)
               {
                  if(!isNaN(visibleLockedColumns[i].explicitWidth))
                  {
                     fixedWidth += visibleLockedColumns[i].width;
                  }
                  else
                  {
                     numResizable++;
                     fixedWidth += visibleLockedColumns[i].minWidth;
                  }
               }
               else
               {
                  fixedWidth += visibleLockedColumns[i].width;
               }
               totalWidth += visibleLockedColumns[i].width;
            }
            newTotal = this.displayWidth;
            if(this.displayWidth > fixedWidth && Boolean(numResizable))
            {
               n = int(visibleLockedColumns.length);
               for(i = 0; i < n; i++)
               {
                  if(Boolean(visibleLockedColumns[i].resizable) && Boolean(!visibleLockedColumns[i].newlyVisible) && isNaN(visibleLockedColumns[i].explicitWidth))
                  {
                     lastColumn = visibleLockedColumns[i];
                     if(totalWidth > this.displayWidth)
                     {
                        ratio = (lastColumn.width - lastColumn.minWidth) / (totalWidth - fixedWidth);
                     }
                     else
                     {
                        ratio = lastColumn.width / totalWidth;
                     }
                     newSize = Math.floor(lastColumn.width - (totalWidth - this.displayWidth) * ratio);
                     minWidth = Number(visibleLockedColumns[i].minWidth);
                     visibleLockedColumns[i].setWidth(newSize > minWidth ? newSize : minWidth);
                  }
                  newTotal -= visibleLockedColumns[i].width;
                  visibleLockedColumns[i].newlyVisible = false;
               }
               n = int(visibleColumns.length);
               for(i = 0; i < n; i++)
               {
                  if(Boolean(visibleColumns[i].resizable) && Boolean(!visibleColumns[i].newlyVisible) && isNaN(visibleColumns[i].explicitWidth))
                  {
                     lastColumn = visibleColumns[i];
                     if(totalWidth > this.displayWidth)
                     {
                        ratio = (lastColumn.width - lastColumn.minWidth) / (totalWidth - fixedWidth);
                     }
                     else
                     {
                        ratio = lastColumn.width / totalWidth;
                     }
                     newSize = Math.floor(lastColumn.width - (totalWidth - this.displayWidth) * ratio);
                     minWidth = Number(visibleColumns[i].minWidth);
                     visibleColumns[i].setWidth(newSize > minWidth ? newSize : minWidth);
                  }
                  newTotal -= visibleColumns[i].width;
                  visibleColumns[i].newlyVisible = false;
               }
               if(Boolean(newTotal) && Boolean(lastColumn))
               {
                  lastColumn.setWidth(lastColumn.width + newTotal);
               }
            }
            else
            {
               n = int(visibleLockedColumns.length);
               for(i = 0; i < n; i++)
               {
                  lastColumn = visibleLockedColumns[i];
                  ratio = lastColumn.width / totalWidth;
                  newSize = Math.floor(this.displayWidth * ratio);
                  lastColumn.setWidth(newSize);
                  lastColumn.explicitWidth = NaN;
                  newTotal -= newSize;
               }
               n = int(visibleColumns.length);
               for(i = 0; i < n; i++)
               {
                  lastColumn = visibleColumns[i];
                  ratio = lastColumn.width / totalWidth;
                  newSize = Math.floor(this.displayWidth * ratio);
                  lastColumn.setWidth(newSize);
                  lastColumn.explicitWidth = NaN;
                  newTotal -= newSize;
               }
               if(Boolean(newTotal) && Boolean(lastColumn))
               {
                  lastColumn.setWidth(lastColumn.width + newTotal);
               }
            }
         }
         else
         {
            totalWidth = 0;
            n = int(visibleColumns.length);
            for(i = 0; i < n; i++)
            {
               if(totalWidth > this.displayWidth - this.lockedColumnWidth)
               {
                  visibleColumns.splice(i);
                  break;
               }
               totalWidth += isNaN(visibleColumns[i].explicitWidth) ? visibleColumns[i].preferredWidth : visibleColumns[i].explicitWidth;
            }
            if(visibleColumns.length == 0)
            {
               return;
            }
            i = visibleColumns[visibleColumns.length - 1].colNum + 1;
            if(totalWidth < this.displayWidth - this.lockedColumnWidth && i < this.displayableColumns.length)
            {
               n = int(this.displayableColumns.length);
               while(i < n && totalWidth < this.displayWidth - this.lockedColumnWidth)
               {
                  col = this.displayableColumns[i];
                  visibleColumns.push(col);
                  totalWidth += isNaN(col.explicitWidth) ? col.preferredWidth : col.explicitWidth;
                  i++;
               }
            }
            else if(totalWidth < this.displayWidth - this.lockedColumnWidth && horizontalScrollPosition > 0)
            {
               while(totalWidth < this.displayWidth - this.lockedColumnWidth && horizontalScrollPosition > 0)
               {
                  col = this.displayableColumns[lockedColumnCount + horizontalScrollPosition - 1];
                  cw = isNaN(col.explicitWidth) ? col.preferredWidth : col.explicitWidth;
                  if(cw >= this.displayWidth - this.lockedColumnWidth - totalWidth)
                  {
                     break;
                  }
                  visibleColumns.splice(0,0,col);
                  var _loc15_:DataGrid = this;
                  var _loc16_:Number = _loc15_.super.horizontalScrollPosition - 1;
                  _loc15_.super.horizontalScrollPosition = _loc16_;
                  totalWidth += cw;
               }
            }
            lastColumn = visibleColumns[visibleColumns.length - 1];
            cw = isNaN(lastColumn.explicitWidth) ? lastColumn.preferredWidth : lastColumn.explicitWidth;
            newSize = cw + this.displayWidth - this.lockedColumnWidth - totalWidth;
            if(lastColumn == this.displayableColumns[this.displayableColumns.length - 1] && lastColumn.resizable && newSize >= lastColumn.minWidth && newSize > cw)
            {
               lastColumn.setWidth(newSize);
               maxHorizontalScrollPosition = this.displayableColumns.length - visibleColumns.length;
            }
            else if(visibleColumns.length == 1 && lastColumn == this.displayableColumns[this.displayableColumns.length - 1])
            {
               maxHorizontalScrollPosition = this.displayableColumns.length - visibleColumns.length;
            }
            else
            {
               maxHorizontalScrollPosition = this.displayableColumns.length - visibleColumns.length + 1;
            }
         }
         this.lockedColumnWidth = 0;
         if(Boolean(visibleLockedColumns.length))
         {
            n = int(visibleLockedColumns.length);
            for(i = 0; i < n; i++)
            {
               col = visibleLockedColumns[i];
               this.lockedColumnWidth += col.width;
            }
         }
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function resizeColumn(col:int, w:Number) : void
      {
         var n:int = 0;
         var i:int = 0;
         var totalSpace:Number = NaN;
         var lastColumn:DataGridColumn = null;
         var newWidth:Number = NaN;
         var newTotalSpace:Number = NaN;
         var totX:Number = NaN;
         if((!visibleColumns || visibleColumns.length == 0) && (!visibleLockedColumns || visibleLockedColumns.length == 0))
         {
            this._columns[col].setWidth(w);
            this._columns[col].preferredWidth = w;
            return;
         }
         if(w < this._columns[col].minWidth)
         {
            w = Number(this._columns[col].minWidth);
         }
         if(_horizontalScrollPolicy == ScrollPolicy.ON || _horizontalScrollPolicy == ScrollPolicy.AUTO)
         {
            this._columns[col].setWidth(w);
            this._columns[col].explicitWidth = w;
            this._columns[col].preferredWidth = w;
            columnsInvalid = true;
         }
         else
         {
            n = int(this._columns.length);
            for(i = 0; i < n; i++)
            {
               if(col == this._columns[i].colNum)
               {
                  break;
               }
            }
            if(i >= this._columns.length - 1)
            {
               return;
            }
            col = i;
            totalSpace = 0;
            for(i = col + 1; i < n; i++)
            {
               if(Boolean(this._columns[i].visible))
               {
                  if(Boolean(this._columns[i].resizable))
                  {
                     totalSpace += this._columns[i].width;
                  }
               }
            }
            newTotalSpace = this._columns[col].width - w + totalSpace;
            if(Boolean(totalSpace))
            {
               this._columns[col].setWidth(w);
               this._columns[col].explicitWidth = w;
            }
            totX = 0;
            for(i = col + 1; i < n; i++)
            {
               if(Boolean(this._columns[i].visible))
               {
                  if(Boolean(this._columns[i].resizable))
                  {
                     newWidth = Math.floor(this._columns[i].width * newTotalSpace / totalSpace);
                     if(newWidth < this._columns[i].minWidth)
                     {
                        newWidth = Number(this._columns[i].minWidth);
                     }
                     this._columns[i].setWidth(newWidth);
                     totX += this._columns[i].width;
                     lastColumn = this._columns[i];
                  }
               }
            }
            if(totX > newTotalSpace)
            {
               newWidth = this._columns[col].width - totX + newTotalSpace;
               if(newWidth < this._columns[col].minWidth)
               {
                  newWidth = Number(this._columns[col].minWidth);
               }
               this._columns[col].setWidth(newWidth);
            }
            else if(Boolean(lastColumn))
            {
               lastColumn.setWidth(lastColumn.width - totX + newTotalSpace);
            }
         }
         itemsSizeChanged = true;
         this.invalidateDisplayList();
      }
      
      protected function drawRowBackground(s:Sprite, rowIndex:int, y:Number, height:Number, color:uint, dataIndex:int) : void
      {
         var background:Shape = null;
         var contentHolder:ListBaseContentHolder = ListBaseContentHolder(s.parent);
         if(rowIndex < s.numChildren)
         {
            background = Shape(s.getChildAt(rowIndex));
         }
         else
         {
            background = new FlexShape();
            background.name = "background";
            s.addChild(background);
         }
         background.y = y;
         height = Math.min(height,contentHolder.height - y);
         var g:Graphics = background.graphics;
         g.clear();
         g.beginFill(color,getStyle("backgroundAlpha"));
         g.drawRect(0,0,contentHolder.width,height);
         g.endFill();
      }
      
      protected function drawColumnBackground(s:Sprite, columnIndex:int, color:uint, column:DataGridColumn) : void
      {
         var background:Shape = null;
         background = Shape(s.getChildByName(columnIndex.toString()));
         if(!background)
         {
            background = new FlexShape();
            s.addChild(background);
            background.name = columnIndex.toString();
         }
         var g:Graphics = background.graphics;
         g.clear();
         g.beginFill(color);
         var lastRow:Object = rowInfo[listItems.length - 1];
         var columnHeader:DataGridHeader = s.parent == lockedColumnContent ? DataGridHeader(lockedColumnHeader) : DataGridHeader(header);
         var xx:Number = Number(columnHeader.rendererArray[columnIndex].x);
         var yy:Number = Number(rowInfo[0].y);
         var height:Number = Math.min(lastRow.y + lastRow.height,listContent.height - yy);
         g.drawRect(xx,yy,columnHeader.visibleColumns[columnIndex].width,listContent.height - yy);
         g.endFill();
      }
      
      private function drawHorizontalSeparator(s:Sprite, rowIndex:int, color:uint, y:Number, useLockedSeparator:Boolean = false) : void
      {
         var sepSkin:IFlexDisplayObject = null;
         var lockedSepSkin:IFlexDisplayObject = null;
         var deleteThisSkin:IFlexDisplayObject = null;
         var createThisSkin:IFlexDisplayObject = null;
         var sepSkinClass:Class = null;
         var styleableSkin:ISimpleStyleClient = null;
         var mHeight:Number = NaN;
         var hSepSkinName:String = "hSeparator" + rowIndex;
         var hLockedSepSkinName:String = "hLockedSeparator" + rowIndex;
         var createThisSkinName:String = useLockedSeparator ? hLockedSepSkinName : hSepSkinName;
         var createThisStyleName:String = useLockedSeparator ? "horizontalLockedSeparatorSkin" : "horizontalSeparatorSkin";
         sepSkin = IFlexDisplayObject(s.getChildByName(hSepSkinName));
         lockedSepSkin = IFlexDisplayObject(s.getChildByName(hLockedSepSkinName));
         createThisSkin = useLockedSeparator ? lockedSepSkin : sepSkin;
         deleteThisSkin = useLockedSeparator ? sepSkin : lockedSepSkin;
         if(Boolean(deleteThisSkin))
         {
            s.removeChild(DisplayObject(deleteThisSkin));
         }
         if(!createThisSkin)
         {
            sepSkinClass = Class(getStyle(createThisStyleName));
            if(Boolean(sepSkinClass))
            {
               createThisSkin = IFlexDisplayObject(new sepSkinClass());
               createThisSkin.name = createThisSkinName;
               styleableSkin = createThisSkin as ISimpleStyleClient;
               if(Boolean(styleableSkin))
               {
                  styleableSkin.styleName = this;
               }
               s.addChild(DisplayObject(createThisSkin));
            }
         }
         if(Boolean(createThisSkin))
         {
            mHeight = !isNaN(createThisSkin.measuredHeight) ? Number(createThisSkin.measuredHeight) : 1;
            createThisSkin.setActualSize(this.displayWidth - this.lockedColumnWidth,mHeight);
            createThisSkin.move(0,y);
         }
         else
         {
            this.drawHorizontalLine(s,rowIndex,color,y);
         }
      }
      
      protected function drawHorizontalLine(s:Sprite, rowIndex:int, color:uint, y:Number) : void
      {
         var contentHolder:ListBaseContentHolder = s.parent.parent as ListBaseContentHolder;
         var g:Graphics = s.graphics;
         g.lineStyle(1,color);
         g.moveTo(0,y);
         g.lineTo(contentHolder.width,y);
      }
      
      private function drawVerticalSeparator(s:Sprite, colIndex:int, color:uint, x:Number, useLockedSeparator:Boolean = false) : void
      {
         var sepSkin:IFlexDisplayObject = null;
         var lockedSepSkin:IFlexDisplayObject = null;
         var deleteThisSkin:IFlexDisplayObject = null;
         var createThisSkin:IFlexDisplayObject = null;
         var sepSkinClass:Class = null;
         var styleableSkin:ISimpleStyleClient = null;
         var mWidth:Number = NaN;
         var vSepSkinName:String = "vSeparator" + colIndex;
         var vLockedSepSkinName:String = "vLockedSeparator" + colIndex;
         var createThisSkinName:String = useLockedSeparator ? vLockedSepSkinName : vSepSkinName;
         var createThisStyleName:String = useLockedSeparator ? "verticalLockedSeparatorSkin" : "verticalSeparatorSkin";
         sepSkin = IFlexDisplayObject(s.getChildByName(vSepSkinName));
         lockedSepSkin = IFlexDisplayObject(s.getChildByName(vLockedSepSkinName));
         createThisSkin = useLockedSeparator ? lockedSepSkin : sepSkin;
         deleteThisSkin = useLockedSeparator ? sepSkin : lockedSepSkin;
         if(Boolean(deleteThisSkin))
         {
            s.removeChild(DisplayObject(deleteThisSkin));
         }
         if(!createThisSkin)
         {
            sepSkinClass = Class(getStyle(createThisStyleName));
            if(Boolean(sepSkinClass))
            {
               createThisSkin = IFlexDisplayObject(new sepSkinClass());
               createThisSkin.name = createThisSkinName;
               styleableSkin = createThisSkin as ISimpleStyleClient;
               if(Boolean(styleableSkin))
               {
                  styleableSkin.styleName = this;
               }
               s.addChild(DisplayObject(createThisSkin));
            }
         }
         if(Boolean(createThisSkin))
         {
            mWidth = !isNaN(createThisSkin.measuredWidth) ? Number(createThisSkin.measuredWidth) : 1;
            createThisSkin.setActualSize(mWidth,s.parent.parent.height);
            createThisSkin.move(x - Math.round(mWidth / 2),0);
         }
         else
         {
            this.drawVerticalLine(s,colIndex,color,x);
         }
      }
      
      protected function drawVerticalLine(s:Sprite, colIndex:int, color:uint, x:Number) : void
      {
         var contentHolder:ListBaseContentHolder = s.parent.parent as ListBaseContentHolder;
         var g:Graphics = s.graphics;
         g.lineStyle();
         g.beginFill(color);
         g.drawRect(x,headerVisible ? 0 : 1,1,contentHolder.height);
         g.endFill();
      }
      
      protected function drawLinesAndColumnBackgrounds() : void
      {
         this.drawLinesAndColumnGraphics(listContent,visibleColumns,{});
      }
      
      protected function drawLinesAndColumnGraphics(contentHolder:ListBaseContentHolder, visibleColumns:Array, separators:Object) : void
      {
         var lineCol:uint = 0;
         var i:int = 0;
         var yy:Number = NaN;
         var colBGs:Sprite = null;
         var lastChild:int = 0;
         var xx:Number = NaN;
         var col:DataGridColumn = null;
         var bgCol:Object = null;
         var background:Shape = null;
         var g:Graphics = null;
         var bg:DisplayObject = null;
         var lines:Sprite = Sprite(contentHolder.getChildByName("lines"));
         if(!lines)
         {
            lines = new UIComponent();
            lines.name = "lines";
            lines.cacheAsBitmap = true;
            lines.mouseEnabled = false;
            contentHolder.addChild(lines);
         }
         contentHolder.setChildIndex(lines,contentHolder.numChildren - 1);
         var rowInfo:Array = contentHolder.rowInfo;
         lines.graphics.clear();
         var linesBody:Sprite = Sprite(lines.getChildByName("body"));
         if(!linesBody)
         {
            linesBody = new UIComponent();
            linesBody.name = "body";
            linesBody.mouseEnabled = false;
            lines.addChild(linesBody);
         }
         linesBody.graphics.clear();
         while(Boolean(linesBody.numChildren))
         {
            linesBody.removeChildAt(0);
         }
         var len:uint = Boolean(visibleColumns) ? visibleColumns.length : 0;
         var rowlen:uint = contentHolder.listItems.length;
         lineCol = uint(getStyle("horizontalGridLineColor"));
         if(Boolean(getStyle("horizontalGridLines")))
         {
            for(i = 0; i < rowlen; i++)
            {
               yy = rowInfo[i].y + rowInfo[i].height;
               if(yy < contentHolder.height)
               {
                  this.drawHorizontalSeparator(linesBody,i,lineCol,yy);
               }
            }
         }
         if(Boolean(separators.top))
         {
            this.drawHorizontalSeparator(linesBody,i++,0,rowInfo[0].y,true);
         }
         if(Boolean(separators.bottom) && rowlen > 0)
         {
            this.drawHorizontalSeparator(linesBody,i++,0,rowInfo[rowlen - 1].y + rowInfo[rowlen - 1].height,true);
         }
         var vLines:Boolean = Boolean(getStyle("verticalGridLines"));
         lineCol = uint(getStyle("verticalGridLineColor"));
         if(Boolean(len))
         {
            colBGs = Sprite(contentHolder.getChildByName("colBGs"));
            lastChild = -1;
            xx = 0;
            for(i = 0; i < len; i++)
            {
               if(vLines && i < len - 1)
               {
                  this.drawVerticalSeparator(linesBody,i,lineCol,xx + visibleColumns[i].width);
               }
               col = visibleColumns[i];
               if(enabled)
               {
                  bgCol = col.getStyle("backgroundColor");
               }
               else
               {
                  bgCol = col.getStyle("backgroundDisabledColor");
               }
               if(bgCol !== null && !isNaN(Number(bgCol)))
               {
                  if(!colBGs)
                  {
                     colBGs = new FlexSprite();
                     colBGs.mouseEnabled = false;
                     colBGs.name = "colBGs";
                     contentHolder.addChildAt(colBGs,contentHolder.getChildIndex(contentHolder.getChildByName("rowBGs")) + 1);
                  }
                  this.drawColumnBackground(colBGs,i,Number(bgCol),col);
                  lastChild = i;
               }
               else if(Boolean(colBGs))
               {
                  background = Shape(colBGs.getChildByName(i.toString()));
                  if(Boolean(background))
                  {
                     g = background.graphics;
                     g.clear();
                     colBGs.removeChild(background);
                  }
               }
               xx += visibleColumns[i].width;
            }
            if(Boolean(colBGs) && Boolean(colBGs.numChildren))
            {
               while(Boolean(colBGs.numChildren))
               {
                  bg = colBGs.getChildAt(colBGs.numChildren - 1);
                  if(parseInt(bg.name) <= lastChild)
                  {
                     break;
                  }
                  colBGs.removeChild(bg);
               }
            }
         }
         if(Boolean(separators.right) && Boolean(visibleColumns) && Boolean(visibleColumns.length))
         {
            if(Boolean(contentHolder.listItems.length) && Boolean(contentHolder.listItems[0].length))
            {
               this.drawVerticalSeparator(linesBody,i++,0,contentHolder.listItems[0][len - 1].x + visibleColumns[len - 1].width,true);
            }
            else
            {
               xx = 0;
               for(i = 0; i < len; i++)
               {
                  xx += visibleColumns[i].width;
               }
               this.drawVerticalSeparator(linesBody,i++,0,xx,true);
            }
         }
         if(Boolean(separators.left))
         {
            this.drawVerticalSeparator(linesBody,i++,0,0,true);
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function _drawHeaderBackground(headerBG:UIComponent) : void
      {
         this.drawHeaderBackground(headerBG);
      }
      
      protected function drawHeaderBackground(headerBG:UIComponent) : void
      {
         DataGridHeader(headerBG.parent)._drawHeaderBackground(headerBG);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function _clearSeparators() : void
      {
         this.clearSeparators();
      }
      
      protected function clearSeparators() : void
      {
         DataGridHeader(header)._clearSeparators();
         if(Boolean(lockedColumnHeader))
         {
            DataGridHeader(lockedColumnHeader)._clearSeparators();
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function _drawSeparators() : void
      {
         this.drawSeparators();
      }
      
      protected function drawSeparators() : void
      {
         DataGridHeader(header)._drawSeparators();
         if(Boolean(lockedColumnHeader))
         {
            DataGridHeader(lockedColumnHeader)._drawSeparators();
         }
      }
      
      private function updateSortIndexAndDirection() : void
      {
         if(!this.sortableColumns)
         {
            this.lastSortIndex = this.sortIndex;
            this.sortIndex = -1;
            if(this.lastSortIndex != this.sortIndex)
            {
               this.invalidateDisplayList();
            }
            return;
         }
         if(!dataProvider)
         {
            return;
         }
         var view:ICollectionView = ICollectionView(dataProvider);
         var sort:ISort = view.sort;
         if(!sort)
         {
            this.sortIndex = this.lastSortIndex = -1;
            return;
         }
         var fields:Array = sort.fields;
         if(!fields)
         {
            return;
         }
         if(fields.length != 1)
         {
            this.lastSortIndex = this.sortIndex;
            this.sortIndex = -1;
            if(this.lastSortIndex != this.sortIndex)
            {
               this.invalidateDisplayList();
            }
            return;
         }
         var sortField:ISortField = fields[0];
         var n:int = int(this._columns.length);
         this.sortIndex = -1;
         for(var i:int = 0; i < n; i++)
         {
            if(this._columns[i].dataField == sortField.name)
            {
               this.sortIndex = Boolean(this._columns[i].sortable) ? i : -1;
               this.sortDirection = sortField.descending ? "DESC" : "ASC";
               return;
            }
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function _placeSortArrow() : void
      {
         this.placeSortArrow();
      }
      
      protected function placeSortArrow() : void
      {
         DataGridHeader(header)._placeSortArrow();
         if(Boolean(lockedColumnHeader))
         {
            DataGridHeader(lockedColumnHeader)._placeSortArrow();
         }
      }
      
      private function sortByColumn(index:int) : void
      {
         var s:ISort = null;
         var f:ISortField = null;
         var dir:String = null;
         var sf:Array = null;
         var i:int = 0;
         var c:DataGridColumn = this.columns[index];
         var desc:Boolean = c.sortDescending;
         if(c.sortable)
         {
            s = collection.sort;
            if(Boolean(s))
            {
               s.compareFunction = null;
               sf = s.fields;
               if(Boolean(sf))
               {
                  for(i = 0; i < sf.length; i++)
                  {
                     if(sf[i].name == c.dataField)
                     {
                        f = sf[i];
                        desc = !f.descending;
                        break;
                     }
                  }
               }
            }
            else
            {
               s = new Sort();
            }
            if(!f)
            {
               f = new SortField(c.dataField);
            }
            c.sortDescending = desc;
            dir = desc ? "DESC" : "ASC";
            this.sortDirection = dir;
            this.lastSortIndex = this.sortIndex;
            this.sortIndex = index;
            this.sortColumn = c;
            f.name = c.dataField;
            if(c.sortCompareFunction != null)
            {
               f.compareFunction = c.sortCompareFunction;
            }
            else
            {
               f.compareFunction = null;
            }
            f.descending = desc;
            s.fields = [f];
         }
         collection.sort = s;
         collection.refresh();
      }
      
      private function setEditedItemPosition(coord:Object) : void
      {
         this.bEditedItemPositionChanged = true;
         this._proposedEditedItemPosition = coord;
         this.invalidateDisplayList();
      }
      
      private function commitEditedItemPosition(coord:Object) : void
      {
         var reason:String = null;
         var i:int = 0;
         var evt:ListEvent = null;
         if(!enabled || !this.editable)
         {
            return;
         }
         if(!collection || collection.length == 0)
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
            if(!coord)
            {
               reason = DataGridEventReason.OTHER;
            }
            else
            {
               reason = !this.editedItemPosition || coord.rowIndex == this.editedItemPosition.rowIndex ? DataGridEventReason.NEW_COLUMN : DataGridEventReason.NEW_ROW;
            }
            if(!this.endEdit(reason) && reason != DataGridEventReason.OTHER)
            {
               return;
            }
         }
         this._editedItemPosition = coord;
         if(!coord)
         {
            return;
         }
         if(this.dontEdit)
         {
            return;
         }
         var rowIndex:int = int(coord.rowIndex);
         var colIndex:int = int(coord.columnIndex);
         if(this.displayableColumns.length != this._columns.length)
         {
            for(i = 0; i < this.displayableColumns.length; i++)
            {
               if(this.displayableColumns[i].colNum >= colIndex)
               {
                  colIndex = i;
                  break;
               }
            }
            if(i == this.displayableColumns.length)
            {
               colIndex = 0;
            }
         }
         var needChangeEvent:Boolean = false;
         if(selectedIndex != coord.rowIndex)
         {
            commitSelectedIndex(coord.rowIndex);
            needChangeEvent = true;
         }
         this.scrollToEditedItem(rowIndex,colIndex);
         var item:IListItemRenderer = this.actualContentHolder.listItems[this.actualRowIndex][this.actualColIndex];
         if(!item)
         {
            this.commitEditedItemPosition(null);
            return;
         }
         if(!this.isItemEditable(item.data))
         {
            this.commitEditedItemPosition(null);
            return;
         }
         if(needChangeEvent)
         {
            evt = new ListEvent(ListEvent.CHANGE);
            evt.columnIndex = coord.columnIndex;
            evt.rowIndex = coord.rowIndex;
            evt.itemRenderer = item;
            dispatchEvent(evt);
         }
         var event:DataGridEvent = new DataGridEvent(DataGridEvent.ITEM_EDIT_BEGIN,false,true);
         event.columnIndex = this.displayableColumns[colIndex].colNum;
         event.rowIndex = this._editedItemPosition.rowIndex;
         event.itemRenderer = item;
         dispatchEvent(event);
         this.lastEditedItemPosition = this._editedItemPosition;
         if(this.bEditedItemPositionChanged)
         {
            this.bEditedItemPositionChanged = false;
            this.commitEditedItemPosition(this._proposedEditedItemPosition);
            this._proposedEditedItemPosition = undefined;
         }
         if(!this.itemEditorInstance)
         {
            this.commitEditedItemPosition(null);
         }
      }
      
      private function scrollToEditedItem(rowIndex:int, colIndex:int) : void
      {
         var partialCol:int = 0;
         this.actualContentHolder = listContent;
         var listItems:Array = this.actualContentHolder.listItems;
         var lastRowIndex:int = verticalScrollPosition + listItems.length - 1 + lockedRowCount;
         var partialRow:int = rowInfo[listItems.length - 1].y + rowInfo[listItems.length - 1].height > listContent.height ? 1 : 0;
         if(rowIndex > lockedRowCount)
         {
            if(rowIndex < verticalScrollPosition + lockedRowCount)
            {
               this.verticalScrollPosition = rowIndex - lockedRowCount;
            }
            else
            {
               while(rowIndex > lastRowIndex || Boolean(rowIndex == lastRowIndex && rowIndex > verticalScrollPosition + lockedRowCount) && Boolean(partialRow))
               {
                  if(verticalScrollPosition == maxVerticalScrollPosition)
                  {
                     break;
                  }
                  this.verticalScrollPosition = Math.min(verticalScrollPosition + (rowIndex > lastRowIndex ? rowIndex - lastRowIndex : partialRow),maxVerticalScrollPosition);
                  lastRowIndex = verticalScrollPosition + listItems.length - 1 + lockedRowCount;
                  partialRow = rowInfo[listItems.length - 1].y + rowInfo[listItems.length - 1].height > listContent.height ? 1 : 0;
               }
            }
            this.actualRowIndex = rowIndex - verticalScrollPosition - lockedRowCount;
         }
         else if(rowIndex == lockedRowCount)
         {
            this.verticalScrollPosition = 0;
            this.actualRowIndex = rowIndex - lockedRowCount;
         }
         else
         {
            if(Boolean(lockedRowCount))
            {
               this.actualContentHolder = lockedRowContent;
            }
            this.actualRowIndex = rowIndex;
         }
         listItems = this.actualContentHolder.listItems;
         var len:uint = Boolean(listItems) && Boolean(listItems[0]) ? uint(listItems[0].length) : visibleColumns.length;
         var lastColIndex:int = horizontalScrollPosition + len - 1 + lockedColumnCount;
         if(colIndex > lockedColumnCount)
         {
            partialCol = listItems[0][len - 1].x + listItems[0][len - 1].width > listContent.width ? 1 : 0;
            if(colIndex < horizontalScrollPosition + lockedColumnCount)
            {
               this.horizontalScrollPosition = colIndex - lockedColumnCount;
            }
            else
            {
               while(colIndex > lastColIndex || Boolean(colIndex == lastColIndex && colIndex > horizontalScrollPosition + lockedColumnCount) && Boolean(partialCol))
               {
                  if(horizontalScrollPosition == maxHorizontalScrollPosition)
                  {
                     break;
                  }
                  this.horizontalScrollPosition = Math.min(horizontalScrollPosition + (colIndex > lastColIndex ? colIndex - lastColIndex : partialCol),maxHorizontalScrollPosition);
                  len = Boolean(listItems) && Boolean(listItems[0]) ? uint(listItems[0].length) : visibleColumns.length;
                  lastColIndex = horizontalScrollPosition + len - 1 + lockedColumnCount;
                  partialCol = listItems[0][len - 1].x + listItems[0][len - 1].width > listContent.width ? 1 : 0;
               }
            }
            this.actualColIndex = colIndex - horizontalScrollPosition - lockedColumnCount;
         }
         else if(colIndex == lockedColumnCount)
         {
            this.horizontalScrollPosition = 0;
            this.actualColIndex = colIndex - lockedColumnCount;
         }
         else
         {
            if(Boolean(lockedColumnCount))
            {
               if(this.actualContentHolder == lockedRowContent)
               {
                  this.actualContentHolder = lockedColumnAndRowContent;
               }
               else
               {
                  this.actualContentHolder = lockedColumnContent;
               }
            }
            this.actualColIndex = colIndex;
         }
      }
      
      public function createItemEditor(colIndex:int, rowIndex:int) : void
      {
         var i:int = 0;
         var dx:Number = NaN;
         var dy:Number = NaN;
         var dw:Number = NaN;
         var dh:Number = NaN;
         var itemEditor:IFactory = null;
         var c:Class = null;
         var fontName:String = null;
         var fontWeight:String = null;
         var fontStyle:String = null;
         var bold:Boolean = false;
         var italic:Boolean = false;
         var flexModuleFactory:IFlexModuleFactory = null;
         if(this.displayableColumns.length != this._columns.length)
         {
            for(i = 0; i < this.displayableColumns.length; i++)
            {
               if(this.displayableColumns[i].colNum >= colIndex)
               {
                  colIndex = i;
                  break;
               }
            }
            if(i == this.displayableColumns.length)
            {
               colIndex = 0;
            }
         }
         var col:DataGridColumn = this.displayableColumns[colIndex];
         if(rowIndex >= lockedRowCount)
         {
            rowIndex -= verticalScrollPosition + lockedRowCount;
         }
         if(colIndex >= lockedColumnCount)
         {
            colIndex -= horizontalScrollPosition + lockedColumnCount;
         }
         var item:IListItemRenderer = this.actualContentHolder.listItems[rowIndex][colIndex];
         var rowData:ListRowInfo = this.actualContentHolder.rowInfo[rowIndex];
         if(!col.rendererIsEditor)
         {
            dx = 0;
            dy = -2;
            dw = 0;
            dh = 4;
            if(!this.itemEditorInstance)
            {
               itemEditor = col.itemEditor;
               if(itemEditor == DataGridColumn.defaultItemEditorFactory)
               {
                  c = getStyle("defaultDataGridItemEditor");
                  if(Boolean(c))
                  {
                     fontName = StringUtil.trimArrayElements(col.getStyle("fontFamily"),",");
                     fontWeight = col.getStyle("fontWeight");
                     fontStyle = col.getStyle("fontStyle");
                     bold = fontWeight == "bold";
                     italic = fontStyle == "italic";
                     flexModuleFactory = getFontContext(fontName,bold,italic);
                     itemEditor = col.itemEditor = new ContextualClassFactory(c,flexModuleFactory);
                  }
               }
               dx = col.editorXOffset;
               dy = col.editorYOffset;
               dw = col.editorWidthOffset;
               dh = col.editorHeightOffset;
               this.itemEditorInstance = itemEditor.newInstance();
               this.itemEditorInstance.owner = this;
               this.itemEditorInstance.styleName = col;
               this.actualContentHolder.addChild(DisplayObject(this.itemEditorInstance));
            }
            this.actualContentHolder.setChildIndex(DisplayObject(this.itemEditorInstance),this.actualContentHolder.numChildren - 1);
            this.itemEditorInstance.visible = true;
            this.itemEditorInstance.move(item.x + dx,rowData.y + dy);
            this.itemEditorInstance.setActualSize(Math.min(col.width + dw,this.actualContentHolder.width - 1 - this.itemEditorInstance.x),Math.min(rowData.height + dh,this.actualContentHolder.height - this.itemEditorInstance.y));
            DisplayObject(this.itemEditorInstance).addEventListener(FocusEvent.FOCUS_OUT,this.itemEditorFocusOutHandler);
            item.visible = false;
         }
         else
         {
            this.itemEditorInstance = item;
         }
         DisplayObject(this.itemEditorInstance).addEventListener(KeyboardEvent.KEY_DOWN,this.editorKeyDownHandler);
         if(Boolean(focusManager))
         {
            focusManager.defaultButtonEnabled = false;
         }
         systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_DOWN,this.editorMouseDownHandler,true,0,true);
         systemManager.getSandboxRoot().addEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE,this.editorMouseDownHandler,false,0,true);
         systemManager.addEventListener(Event.RESIZE,this.editorAncestorResizeHandler);
         addEventListener(Event.RESIZE,this.editorAncestorResizeHandler);
         var event:DataGridEvent = new DataGridEvent(DataGridEvent.ITEM_EDITOR_CREATE,false,true,colIndex,null,rowIndex);
         dispatchEvent(event);
      }
      
      private function findNextItemRenderer(shiftKey:Boolean) : Boolean
      {
         var reason:String = null;
         if(!this.lastEditedItemPosition)
         {
            return false;
         }
         if(this._proposedEditedItemPosition !== undefined)
         {
            return true;
         }
         this._editedItemPosition = this.lastEditedItemPosition;
         var index:int = int(this._editedItemPosition.rowIndex);
         var colIndex:int = int(this._editedItemPosition.columnIndex);
         var found:Boolean = false;
         var incr:int = shiftKey ? -1 : 1;
         var maxIndex:int = collection.length - 1;
         while(!found)
         {
            colIndex += incr;
            if(colIndex >= this._columns.length || colIndex < 0)
            {
               colIndex = colIndex < 0 ? int(this._columns.length - 1) : 0;
               index += incr;
               if(index > maxIndex || index < 0)
               {
                  if(this.endEdit(DataGridEventReason.NEW_ROW))
                  {
                     this.setEditedItemPosition(null);
                     this.deferFocus();
                     return false;
                  }
                  return true;
               }
            }
            if(Boolean(this._columns[colIndex].editable) && Boolean(this._columns[colIndex].visible))
            {
               found = true;
               reason = index == this._editedItemPosition.rowIndex ? DataGridEventReason.NEW_COLUMN : DataGridEventReason.NEW_ROW;
               if(!this.itemEditorInstance || this.endEdit(reason))
               {
                  this.beginningEdit(colIndex,index);
               }
            }
         }
         return found;
      }
      
      public function destroyItemEditor() : void
      {
         var event:DataGridEvent = null;
         if(Boolean(this.itemEditorInstance))
         {
            DisplayObject(this.itemEditorInstance).removeEventListener(KeyboardEvent.KEY_DOWN,this.editorKeyDownHandler);
            if(Boolean(focusManager))
            {
               focusManager.defaultButtonEnabled = true;
            }
            systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_DOWN,this.editorMouseDownHandler,true);
            systemManager.getSandboxRoot().removeEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE,this.editorMouseDownHandler);
            systemManager.removeEventListener(Event.RESIZE,this.editorAncestorResizeHandler);
            removeEventListener(Event.RESIZE,this.editorAncestorResizeHandler);
            event = new DataGridEvent(DataGridEvent.ITEM_FOCUS_OUT);
            event.columnIndex = this._editedItemPosition.columnIndex;
            event.rowIndex = this._editedItemPosition.rowIndex;
            event.itemRenderer = this.itemEditorInstance;
            dispatchEvent(event);
            if(!this._columns[this._editedItemPosition.columnIndex].rendererIsEditor)
            {
               if(Boolean(this.itemEditorInstance) && this.itemEditorInstance is UIComponent)
               {
                  UIComponent(this.itemEditorInstance).drawFocus(false);
               }
               this.deferFocus();
               if(Boolean(this.itemEditorInstance))
               {
                  this.actualContentHolder.removeChild(DisplayObject(this.itemEditorInstance));
                  this.editedItemRenderer.visible = true;
               }
            }
            this.itemEditorInstance = null;
            this._editedItemPosition = null;
         }
      }
      
      private function beginningEdit(columnIndex:int, rowIndex:int, itemRenderer:IListItemRenderer = null) : void
      {
         var dataGridEvent:DataGridEvent = new DataGridEvent(DataGridEvent.ITEM_EDIT_BEGINNING,false,true);
         dataGridEvent.columnIndex = Math.min(columnIndex,this.columns.length - 1);
         dataGridEvent.dataField = this._columns[columnIndex].dataField;
         dataGridEvent.rowIndex = Math.min(rowIndex,collection.length - 1);
         dataGridEvent.itemRenderer = itemRenderer;
         if(!dispatchEvent(dataGridEvent))
         {
            this.lastEditedItemPosition = {
               "columnIndex":columnIndex,
               "rowIndex":rowIndex
            };
         }
      }
      
      private function endEdit(reason:String) : Boolean
      {
         if(!this.editedItemRenderer)
         {
            return true;
         }
         this.inEndEdit = true;
         var dataGridEvent:DataGridEvent = new DataGridEvent(DataGridEvent.ITEM_EDIT_END,false,true);
         dataGridEvent.columnIndex = this.editedItemPosition.columnIndex;
         dataGridEvent.dataField = this._columns[this.editedItemPosition.columnIndex].dataField;
         dataGridEvent.rowIndex = this.editedItemPosition.rowIndex;
         dataGridEvent.itemRenderer = this.editedItemRenderer;
         dataGridEvent.reason = reason;
         dispatchEvent(dataGridEvent);
         this.dontEdit = this.itemEditorInstance != null;
         if(!this.dontEdit && reason == DataGridEventReason.CANCELLED)
         {
            this.deferFocus();
         }
         this.inEndEdit = false;
         return !dataGridEvent.isDefaultPrevented();
      }
      
      public function isItemEditable(data:Object) : Boolean
      {
         if(!this.editable)
         {
            return false;
         }
         if(!data)
         {
            return false;
         }
         return true;
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function columnRendererChanged(c:DataGridColumn) : void
      {
         var item:DisplayObject = null;
         var p:* = undefined;
         var freeRenderers:Array = null;
         var factory:IFactory = null;
         var d:Dictionary = null;
         var q:* = undefined;
         var factories:Dictionary = c.measuringObjects;
         if(Boolean(factories))
         {
            for(p in factories)
            {
               factory = IFactory(p);
               item = c.measuringObjects[factory];
               if(Boolean(item))
               {
                  item.parent.removeChild(item);
                  c.measuringObjects[factory] = null;
               }
               if(Boolean(c.freeItemRenderersByFactory) && Boolean(c.freeItemRenderersByFactory[factory]))
               {
                  d = c.freeItemRenderersByFactory[factory];
                  for(q in d)
                  {
                     item = DisplayObject(q);
                     item.parent.removeChild(item);
                  }
                  c.freeItemRenderersByFactory[factory] = new Dictionary(true);
               }
            }
            freeRenderers = freeItemRenderersTable[c] as Array;
            if(Boolean(freeRenderers))
            {
               while(Boolean(freeRenderers.length))
               {
                  item = freeRenderers.pop();
               }
            }
         }
         item = c.cachedHeaderRenderer as DisplayObject;
         if(Boolean(item) && Boolean(item.parent))
         {
            item.parent.removeChild(item);
         }
         c.cachedHeaderRenderer = null;
         rendererChanged = true;
         this.invalidateDisplayList();
      }
      
      override protected function collectionChangeHandler(event:Event) : void
      {
         var curEditedItemPosition:Object = null;
         var ceEvent:CollectionEvent = null;
         var ce:CollectionEvent = null;
         if(event is CollectionEvent)
         {
            ceEvent = CollectionEvent(event);
            if(ceEvent.kind == CollectionEventKind.RESET)
            {
               if(Boolean(this.itemEditorInstance))
               {
                  this.endEdit(DataGridEventReason.CANCELLED);
               }
               this.setEditedItemPosition(null);
               if(this.generatedColumns)
               {
                  this.generateCols();
               }
               else
               {
                  columnsInvalid = true;
               }
               this.updateSortIndexAndDirection();
               if(Boolean(lockedRowContent))
               {
                  lockedRowContent.iterator = collection.createCursor();
               }
               if(Boolean(lockedColumnAndRowContent))
               {
                  lockedColumnAndRowContent.iterator = collection.createCursor();
               }
            }
            else if(ceEvent.kind == CollectionEventKind.REFRESH && !this.manualSort)
            {
               this.updateSortIndexAndDirection();
            }
            else if(ceEvent.kind == CollectionEventKind.ADD)
            {
               if(Boolean(this.editedItemPosition))
               {
                  if(ceEvent.location <= this.editedItemPosition.rowIndex)
                  {
                     curEditedItemPosition = this.editedItemPosition;
                     if(this.inEndEdit)
                     {
                        this._editedItemPosition = {
                           "columnIndex":this.editedItemPosition.columnIndex,
                           "rowIndex":Math.max(0,this.editedItemPosition.rowIndex + ceEvent.items.length)
                        };
                     }
                     else if(Boolean(this.itemEditorInstance))
                     {
                        this._editedItemPosition = {
                           "columnIndex":this.editedItemPosition.columnIndex,
                           "rowIndex":Math.max(0,this.editedItemPosition.rowIndex + ceEvent.items.length)
                        };
                        this.itemEditorPositionChanged = true;
                        this.lastEditedItemPosition = this._editedItemPosition;
                     }
                     else
                     {
                        this.setEditedItemPosition({
                           "columnIndex":curEditedItemPosition.columnIndex,
                           "rowIndex":Math.max(0,curEditedItemPosition.rowIndex + ceEvent.items.length)
                        });
                     }
                  }
               }
            }
            else if(ceEvent.kind == CollectionEventKind.REMOVE)
            {
               if(Boolean(this.editedItemPosition))
               {
                  if(collection.length == 0)
                  {
                     if(Boolean(this.itemEditorInstance))
                     {
                        this.endEdit(DataGridEventReason.CANCELLED);
                     }
                     this.setEditedItemPosition(null);
                  }
                  else if(ceEvent.location <= this.editedItemPosition.rowIndex)
                  {
                     curEditedItemPosition = this.editedItemPosition;
                     if(ceEvent.location == this.editedItemPosition.rowIndex && Boolean(this.itemEditorInstance))
                     {
                        this.endEdit(DataGridEventReason.CANCELLED);
                     }
                     if(this.inEndEdit)
                     {
                        this._editedItemPosition = {
                           "columnIndex":this.editedItemPosition.columnIndex,
                           "rowIndex":Math.max(0,this.editedItemPosition.rowIndex - ceEvent.items.length)
                        };
                     }
                     else if(Boolean(this.itemEditorInstance))
                     {
                        this._editedItemPosition = {
                           "columnIndex":this.editedItemPosition.columnIndex,
                           "rowIndex":Math.max(0,this.editedItemPosition.rowIndex - ceEvent.items.length)
                        };
                        this.itemEditorPositionChanged = true;
                        this.lastEditedItemPosition = this._editedItemPosition;
                     }
                     else
                     {
                        this.setEditedItemPosition({
                           "columnIndex":curEditedItemPosition.columnIndex,
                           "rowIndex":Math.max(0,curEditedItemPosition.rowIndex - ceEvent.items.length)
                        });
                     }
                  }
               }
            }
            else if(ceEvent.kind == CollectionEventKind.REPLACE)
            {
               if(Boolean(this.editedItemPosition))
               {
                  if(ceEvent.location == this.editedItemPosition.rowIndex && Boolean(this.itemEditorInstance))
                  {
                     this.endEdit(DataGridEventReason.CANCELLED);
                  }
               }
            }
         }
         super.collectionChangeHandler(event);
         if(event is CollectionEvent)
         {
            ce = CollectionEvent(event);
            if(ce.kind == CollectionEventKind.ADD)
            {
               if(collection.length == 1)
               {
                  if(this.generatedColumns)
                  {
                     this.generateCols();
                  }
               }
            }
            else if(ce.kind == CollectionEventKind.REFRESH)
            {
               if(Boolean(lockedRowCount) && Boolean(lockedRowContent))
               {
                  lockedRowContent.iterator.seek(CursorBookmark.FIRST,0);
               }
            }
         }
         if(itemsNeedMeasurement)
         {
            invalidateProperties();
         }
      }
      
      override protected function mouseDownHandler(event:MouseEvent) : void
      {
         var r:IListItemRenderer = null;
         var s:Sprite = null;
         var pos:Point = null;
         var bEndedEdit:Boolean = false;
         r = this.mouseEventToItemRenderer(event);
         this.lastItemDown = null;
         var isItemEditor:Boolean = itemRendererContains(this.itemEditorInstance,DisplayObject(event.target));
         if(!isItemEditor)
         {
            if(Boolean(r))
            {
               this.lastItemDown = r;
               pos = itemRendererToIndices(r);
               bEndedEdit = true;
               if(Boolean(this.itemEditorInstance))
               {
                  if(this.displayableColumns[pos.x].editable == false)
                  {
                     bEndedEdit = this.endEdit(DataGridEventReason.OTHER);
                  }
                  else if(Boolean(this.editedItemPosition))
                  {
                     bEndedEdit = this.endEdit(this.editedItemPosition.rowIndex == pos.y ? DataGridEventReason.NEW_COLUMN : DataGridEventReason.NEW_ROW);
                  }
                  else
                  {
                     bEndedEdit = false;
                  }
               }
               if(!bEndedEdit)
               {
                  return;
               }
            }
            else if(Boolean(this.itemEditorInstance))
            {
               this.endEdit(DataGridEventReason.OTHER);
            }
            super.mouseDownHandler(event);
            if(Boolean(r))
            {
               if(Boolean(this.displayableColumns[pos.x].rendererIsEditor))
               {
                  resetDragScrolling();
               }
            }
         }
         else
         {
            resetDragScrolling();
         }
      }
      
      override protected function mouseUpHandler(event:MouseEvent) : void
      {
         var dataGridEvent:DataGridEvent = null;
         var r:IListItemRenderer = null;
         var s:Sprite = null;
         var n:int = 0;
         var i:int = 0;
         var pos:Point = null;
         r = this.mouseEventToItemRenderer(event);
         super.mouseUpHandler(event);
         if(Boolean(r) && Boolean(r != this.itemEditorInstance) && (this.lastItemDown == r || itemRendererContains(this.lastItemDown,this.lastItemFocused)))
         {
            if(this.lastItemDown != r)
            {
               r = this.lastItemDown;
            }
            this.lastItemFocused = null;
            pos = itemRendererToIndices(r);
            if(Boolean(pos && pos.y >= 0) && Boolean(this.editable) && !this.dontEdit)
            {
               if(Boolean(this.displayableColumns[pos.x].editable))
               {
                  this.beginningEdit(this.displayableColumns[pos.x].colNum,pos.y,r);
               }
               else
               {
                  this.lastEditedItemPosition = {
                     "columnIndex":this.displayableColumns[pos.x].colNum,
                     "rowIndex":pos.y
                  };
               }
            }
         }
         else if(Boolean(this.lastItemDown) && this.lastItemDown != this.itemEditorInstance)
         {
            pos = itemRendererToIndices(this.lastItemDown);
            if(Boolean(pos && pos.y >= 0) && Boolean(this.editable) && !this.dontEdit)
            {
               if(Boolean(this.displayableColumns[pos.x].editable))
               {
                  this.beginningEdit(this.displayableColumns[pos.x].colNum,pos.y,this.lastItemDown);
               }
               else
               {
                  this.lastEditedItemPosition = {
                     "columnIndex":this.displayableColumns[pos.x].colNum,
                     "rowIndex":pos.y
                  };
               }
            }
         }
         this.lastItemDown = null;
      }
      
      override protected function focusInHandler(event:FocusEvent) : void
      {
         var dataGridEvent:DataGridEvent = null;
         var foundOne:Boolean = false;
         if(this.losingFocus)
         {
            this.losingFocus = false;
            return;
         }
         if(this.editable)
         {
            addEventListener(FocusEvent.KEY_FOCUS_CHANGE,this.keyFocusChangeHandler);
            addEventListener(MouseEvent.MOUSE_DOWN,this.mouseFocusChangeHandler);
         }
         if(event.target != this)
         {
            if(Boolean(this.itemEditorInstance) && itemRendererContains(this.itemEditorInstance,DisplayObject(event.target)))
            {
               return;
            }
            this.lastItemFocused = DisplayObject(event.target);
            return;
         }
         this.lastItemFocused = null;
         super.focusInHandler(event);
         if(this.editable && !isPressed)
         {
            this._editedItemPosition = this.lastEditedItemPosition;
            foundOne = false;
            if(!this._editedItemPosition)
            {
               this._editedItemPosition = {
                  "rowIndex":0,
                  "columnIndex":0
               };
            }
            while(this._editedItemPosition.columnIndex != this._columns.length)
            {
               if(Boolean(this._columns[this._editedItemPosition.columnIndex].editable) && Boolean(this._columns[this._editedItemPosition.columnIndex].visible))
               {
                  foundOne = true;
                  break;
               }
               ++this._editedItemPosition.columnIndex;
            }
            if(foundOne)
            {
               this.beginningEdit(this._editedItemPosition.columnIndex,this._editedItemPosition.rowIndex);
            }
         }
      }
      
      override protected function focusOutHandler(event:FocusEvent) : void
      {
         var target:DisplayObject = null;
         if(event.target == this)
         {
            super.focusOutHandler(event);
         }
         if(event.relatedObject == this && itemRendererContains(this.itemEditorInstance,DisplayObject(event.target)))
         {
            return;
         }
         if(event.relatedObject == null && itemRendererContains(this.editedItemRenderer,DisplayObject(event.target)))
         {
            return;
         }
         if(event.relatedObject == null && itemRendererContains(this.itemEditorInstance,DisplayObject(event.target)))
         {
            return;
         }
         if(Boolean(this.itemEditorInstance) && (!event.relatedObject || !itemRendererContains(this.itemEditorInstance,event.relatedObject)))
         {
            target = DisplayObject(event.relatedObject);
            while(Boolean(target) && target != this)
            {
               if(target is IListItemRenderer && target.parent.parent == this && target.parent is ListBaseContentHolder)
               {
                  if(target.visible)
                  {
                     return;
                  }
               }
               if(target is IUIComponent)
               {
                  target = IUIComponent(target).owner;
               }
               else
               {
                  target = target.parent;
               }
            }
            this.endEdit(DataGridEventReason.OTHER);
            removeEventListener(FocusEvent.KEY_FOCUS_CHANGE,this.keyFocusChangeHandler);
            removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseFocusChangeHandler);
         }
      }
      
      private function deactivateHandler(event:Event) : void
      {
         if(Boolean(this.itemEditorInstance))
         {
            this.endEdit(DataGridEventReason.OTHER);
            this.deferFocus();
         }
      }
      
      override protected function keyDownHandler(event:KeyboardEvent) : void
      {
         if(Boolean(this.itemEditorInstance) || event.target != event.currentTarget)
         {
            return;
         }
         if(event.keyCode != Keyboard.SPACE)
         {
            super.keyDownHandler(event);
         }
         else if(caretIndex != -1)
         {
            moveSelectionVertically(event.keyCode,event.shiftKey,event.ctrlKey);
         }
      }
      
      override public function itemToLabel(data:Object) : String
      {
         return this._columns[this.sortIndex == -1 ? 0 : this.sortIndex].itemToLabel(data);
      }
      
      private function editorMouseDownHandler(event:Event) : void
      {
         if(event is MouseEvent && Boolean(owns(DisplayObject(event.target))))
         {
            return;
         }
         this.endEdit(DataGridEventReason.OTHER);
         this.deferFocus();
      }
      
      private function editorKeyDownHandler(event:KeyboardEvent) : void
      {
         if(event.keyCode == Keyboard.ESCAPE)
         {
            this.endEdit(DataGridEventReason.CANCELLED);
         }
         else if(event.ctrlKey && event.charCode == 46)
         {
            this.endEdit(DataGridEventReason.CANCELLED);
         }
         else if(event.charCode == Keyboard.ENTER && event.keyCode != 229)
         {
            if(!this._editedItemPosition)
            {
               return;
            }
            if(Boolean(this.columns[this._editedItemPosition.columnIndex].editorUsesEnterKey))
            {
               return;
            }
            if(this.endEdit(DataGridEventReason.NEW_ROW) && !this.dontEdit)
            {
               this.findNextEnterItemRenderer(event);
               if(Boolean(focusManager))
               {
                  focusManager.defaultButtonEnabled = false;
               }
            }
         }
      }
      
      private function editorAncestorResizeHandler(event:Event) : void
      {
         this.endEdit(DataGridEventReason.OTHER);
      }
      
      private function findNextEnterItemRenderer(event:KeyboardEvent) : void
      {
         if(this._proposedEditedItemPosition !== undefined)
         {
            return;
         }
         this._editedItemPosition = this.lastEditedItemPosition;
         if(!this._editedItemPosition)
         {
            return;
         }
         var rowIndex:int = int(this._editedItemPosition.rowIndex);
         var columnIndex:int = int(this._editedItemPosition.columnIndex);
         var newIndex:int = this._editedItemPosition.rowIndex + (event.shiftKey ? -1 : 1);
         if(newIndex < collection.length && newIndex >= 0)
         {
            rowIndex = newIndex;
         }
         this.beginningEdit(columnIndex,rowIndex);
      }
      
      private function mouseFocusChangeHandler(event:MouseEvent) : void
      {
         if(Boolean(this.itemEditorInstance) && Boolean(!event.isDefaultPrevented()) && itemRendererContains(this.itemEditorInstance,DisplayObject(event.target)))
         {
            event.preventDefault();
         }
      }
      
      private function keyFocusChangeHandler(event:FocusEvent) : void
      {
         if(event.keyCode == Keyboard.TAB && !event.isDefaultPrevented() && this.findNextItemRenderer(event.shiftKey))
         {
            event.preventDefault();
         }
      }
      
      private function itemEditorFocusOutHandler(event:FocusEvent) : void
      {
         if(Boolean(event.relatedObject) && Boolean(contains(event.relatedObject)))
         {
            return;
         }
         if(!event.relatedObject)
         {
            return;
         }
         if(Boolean(this.itemEditorInstance))
         {
            this.endEdit(DataGridEventReason.OTHER);
         }
      }
      
      private function itemEditorItemEditBeginningHandler(event:DataGridEvent) : void
      {
         if(!event.isDefaultPrevented())
         {
            this.setEditedItemPosition({
               "columnIndex":event.columnIndex,
               "rowIndex":event.rowIndex
            });
         }
         else if(!this.itemEditorInstance)
         {
            this._editedItemPosition = null;
            this.editable = false;
            setFocus();
            this.editable = true;
         }
      }
      
      private function itemEditorItemEditBeginHandler(event:DataGridEvent) : void
      {
         var fm:IFocusManager = null;
         if(Boolean(root))
         {
            systemManager.addEventListener(Event.DEACTIVATE,this.deactivateHandler,false,0,true);
         }
         if(!event.isDefaultPrevented() && this.actualContentHolder.listItems[this.actualRowIndex][this.actualColIndex].data != null)
         {
            this.createItemEditor(event.columnIndex,event.rowIndex);
            if(this.editedItemRenderer is IDropInListItemRenderer && this.itemEditorInstance is IDropInListItemRenderer)
            {
               IDropInListItemRenderer(this.itemEditorInstance).listData = IDropInListItemRenderer(this.editedItemRenderer).listData;
            }
            if(!this.columns[event.columnIndex].rendererIsEditor)
            {
               this.itemEditorInstance.data = this.editedItemRenderer.data;
            }
            if(this.itemEditorInstance is IInvalidating)
            {
               IInvalidating(this.itemEditorInstance).validateNow();
            }
            if(this.itemEditorInstance is IIMESupport)
            {
               IIMESupport(this.itemEditorInstance).imeMode = this.columns[event.columnIndex].imeMode == null ? this._imeMode : this.columns[event.columnIndex].imeMode;
            }
            fm = focusManager;
            if(this.itemEditorInstance is IFocusManagerComponent)
            {
               fm.setFocus(IFocusManagerComponent(this.itemEditorInstance));
            }
            event = new DataGridEvent(DataGridEvent.ITEM_FOCUS_IN);
            event.columnIndex = this._editedItemPosition.columnIndex;
            event.rowIndex = this._editedItemPosition.rowIndex;
            event.itemRenderer = this.itemEditorInstance;
            dispatchEvent(event);
         }
      }
      
      private function itemEditorItemEditEndHandler(event:DataGridEvent) : void
      {
         var bChanged:Boolean = false;
         var newData:Object = null;
         var property:String = null;
         var data:Object = null;
         var typeInfo:String = null;
         var variable:XML = null;
         var listData:DataGridListData = null;
         var fm:IFocusManager = null;
         if(!event.isDefaultPrevented())
         {
            bChanged = false;
            if(event.reason == DataGridEventReason.NEW_COLUMN)
            {
               if(!this.collectionUpdatesDisabled)
               {
                  collection.disableAutoUpdate();
                  this.collectionUpdatesDisabled = true;
               }
            }
            else if(this.collectionUpdatesDisabled)
            {
               collection.enableAutoUpdate();
               this.collectionUpdatesDisabled = false;
            }
            if(Boolean(this.itemEditorInstance) && event.reason != DataGridEventReason.CANCELLED)
            {
               newData = this.itemEditorInstance[this._columns[event.columnIndex].editorDataField];
               property = this._columns[event.columnIndex].dataField;
               data = event.itemRenderer.data;
               typeInfo = "";
               for each(variable in describeType(data).variable)
               {
                  if(property == variable.@name.toString())
                  {
                     typeInfo = variable.@type.toString();
                     break;
                  }
               }
               if(typeInfo == "String")
               {
                  if(!(newData is String))
                  {
                     newData = newData.toString();
                  }
               }
               else if(typeInfo == "uint")
               {
                  if(!(newData is uint))
                  {
                     newData = uint(newData);
                  }
               }
               else if(typeInfo == "int")
               {
                  if(!(newData is int))
                  {
                     newData = int(newData);
                  }
               }
               else if(typeInfo == "Number")
               {
                  if(!(newData is int))
                  {
                     newData = Number(newData);
                  }
               }
               if(property != null && this.getCurrentDataValue(data,property) !== newData)
               {
                  bChanged = this.setNewValue(data,property,newData,event.columnIndex);
               }
               if(bChanged && !(data is IPropertyChangeNotifier || data is XML))
               {
                  collection.itemUpdated(data,property);
               }
               if(event.itemRenderer is IDropInListItemRenderer)
               {
                  listData = DataGridListData(IDropInListItemRenderer(event.itemRenderer).listData);
                  listData.label = this._columns[event.columnIndex].itemToLabel(data);
                  IDropInListItemRenderer(event.itemRenderer).listData = listData;
               }
               event.itemRenderer.data = data;
            }
         }
         else if(event.reason != DataGridEventReason.OTHER)
         {
            if(Boolean(this.itemEditorInstance) && Boolean(this._editedItemPosition))
            {
               if(selectedIndex != this._editedItemPosition.rowIndex)
               {
                  selectedIndex = this._editedItemPosition.rowIndex;
               }
               fm = focusManager;
               if(this.itemEditorInstance is IFocusManagerComponent)
               {
                  fm.setFocus(IFocusManagerComponent(this.itemEditorInstance));
               }
            }
         }
         if(event.reason == DataGridEventReason.OTHER || !event.isDefaultPrevented())
         {
            this.destroyItemEditor();
         }
      }
      
      private function deferFocus() : void
      {
         this.losingFocus = true;
         setFocus();
         this.losingFocus = false;
      }
      
      protected function isComplexColumn(property:String) : Boolean
      {
         return property.indexOf(".") != -1;
      }
      
      protected function deriveComplexFieldReference(data:Object, complexFieldNameComponents:Array) : Object
      {
         var i:int = 0;
         var currentRef:Object = data;
         if(Boolean(complexFieldNameComponents))
         {
            for(i = 0; i < complexFieldNameComponents.length; i++)
            {
               currentRef = currentRef[complexFieldNameComponents[i]];
            }
         }
         return currentRef;
      }
      
      protected function getCurrentDataValue(data:Object, property:String) : String
      {
         if(!this.isComplexColumn(property))
         {
            return data[property];
         }
         var complexFieldNameComponents:Array = property.split(".");
         var obj:Object = this.deriveComplexFieldReference(data,complexFieldNameComponents);
         return String(obj);
      }
      
      protected function setNewValue(data:Object, property:String, value:Object, columnIndex:int) : Boolean
      {
         var complexFieldNameComponents:Array = null;
         var lastProp:String = null;
         var parent:Object = null;
         if(!this.isComplexColumn(property))
         {
            data[property] = value;
         }
         else
         {
            complexFieldNameComponents = property.split(".");
            lastProp = complexFieldNameComponents.pop();
            parent = this.deriveComplexFieldReference(data,complexFieldNameComponents);
            parent[lastProp] = value;
         }
         return true;
      }
      
      private function headerReleaseHandler(event:DataGridEvent) : void
      {
         if(!event.isDefaultPrevented())
         {
            this.manualSort = true;
            this.sortByColumn(event.columnIndex);
            this.manualSort = false;
         }
      }
      
      override protected function mouseWheelHandler(event:MouseEvent) : void
      {
         if(Boolean(this.itemEditorInstance))
         {
            this.endEdit(DataGridEventReason.OTHER);
         }
         super.mouseWheelHandler(event);
      }
      
      override protected function dragStartHandler(event:DragEvent) : void
      {
         if(this.collectionUpdatesDisabled)
         {
            collection.enableAutoUpdate();
            this.collectionUpdatesDisabled = false;
         }
         super.dragStartHandler(event);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get vScrollBar() : ScrollBar
      {
         return verticalScrollBar;
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get rendererArray() : Array
      {
         var arr:Array = listItems.slice();
         var arr2:Array = DataGridHeader(header).rendererArray;
         arr.unshift(arr2);
         return arr;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get sortArrow() : IFlexDisplayObject
      {
         return DataGridHeader(header).sortArrow;
      }
      
      override protected function adjustListContent(unscaledWidth:Number = -1, unscaledHeight:Number = -1) : void
      {
         var ww:Number = NaN;
         var lcx:Number = NaN;
         var lcy:Number = NaN;
         var hcx:Number = NaN;
         var pt:Point = null;
         var hh:Number = 0;
         if(headerVisible)
         {
            if(lockedColumnCount > 0)
            {
               lockedColumnHeader.visible = true;
               hcx = viewMetrics.left + Math.min(DataGridHeader(lockedColumnHeader).leftOffset,0);
               lockedColumnHeader.move(hcx,viewMetrics.top);
               hh = Number(lockedColumnHeader.getExplicitOrMeasuredHeight());
               lockedColumnHeader.setActualSize(this.lockedColumnWidth + 1,hh);
               DataGridHeader(lockedColumnHeader).needRightSeparator = true;
               DataGridHeader(lockedColumnHeader).needRightSeparatorEvents = true;
            }
            header.visible = true;
            hcx = viewMetrics.left + this.lockedColumnWidth + Math.min(DataGridHeader(header).leftOffset,0);
            header.move(hcx,viewMetrics.top);
            if(verticalScrollBar != null && Boolean(verticalScrollBar.visible) && (horizontalScrollBar == null || !horizontalScrollBar.visible) && headerVisible && roomForScrollBar(verticalScrollBar,unscaledWidth,unscaledHeight - header.height))
            {
               ww = Math.max(0,DataGridHeader(header).rightOffset) - hcx - borderMetrics.right;
            }
            else
            {
               ww = Math.max(0,DataGridHeader(header).rightOffset) - hcx - viewMetrics.right;
            }
            hh = Number(header.getExplicitOrMeasuredHeight());
            header.setActualSize(unscaledWidth + ww,hh);
            if(!this.skipHeaderUpdate)
            {
               header.headerItemsChanged = true;
               header.invalidateDisplayList();
            }
         }
         else
         {
            header.visible = false;
            if(lockedColumnCount > 0)
            {
               lockedColumnHeader.visible = false;
            }
         }
         if(Boolean(lockedRowCount > 0) && Boolean(lockedRowContent) && Boolean(lockedRowContent.iterator))
         {
            try
            {
               lockedRowContent.iterator.seek(CursorBookmark.FIRST);
               pt = makeRows(lockedRowContent,0,0,unscaledWidth,unscaledHeight,0,0,true,lockedRowCount,true);
               if(lockedColumnCount > 0)
               {
                  lcx = viewMetrics.left + Math.min(lockedColumnAndRowContent.leftOffset,0);
                  lcy = viewMetrics.top + Math.min(lockedColumnAndRowContent.topOffset,0) + Math.ceil(hh);
                  lockedColumnAndRowContent.move(lcx,lcy);
                  lockedColumnAndRowContent.setActualSize(this.lockedColumnWidth,lockedColumnAndRowContent.getExplicitOrMeasuredHeight());
               }
               lcx = viewMetrics.left + this.lockedColumnWidth + Math.min(lockedRowContent.leftOffset,0);
               lcy = viewMetrics.top + Math.min(lockedRowContent.topOffset,0) + Math.ceil(hh);
               lockedRowContent.move(lcx,lcy);
               ww = Math.max(0,lockedRowContent.rightOffset) - lcx - viewMetrics.right;
               lockedRowContent.setActualSize(unscaledWidth + ww,lockedRowContent.getExplicitOrMeasuredHeight());
               hh += lockedRowContent.getExplicitOrMeasuredHeight();
            }
            catch(e:ItemPendingError)
            {
               e.addResponder(new ItemResponder(lockedRowSeekPendingResultHandler,seekPendingFailureHandler,null));
            }
         }
         if(lockedColumnCount > 0)
         {
            lcx = viewMetrics.left + Math.min(lockedColumnContent.leftOffset,0);
            lcy = viewMetrics.top + Math.min(lockedColumnContent.topOffset,0) + Math.ceil(hh);
            lockedColumnContent.move(lcx,lcy);
            ww = this.lockedColumnWidth + lockedColumnContent.rightOffset - lockedColumnContent.leftOffset;
            lockedColumnContent.setActualSize(ww,unscaledHeight + Math.max(0,lockedColumnContent.bottomOffset) - lcy - viewMetrics.bottom);
         }
         lcx = viewMetrics.left + this.lockedColumnWidth + Math.min(listContent.leftOffset,0);
         lcy = viewMetrics.top + Math.min(listContent.topOffset,0) + Math.ceil(hh);
         listContent.move(lcx,lcy);
         ww = Math.max(0,listContent.rightOffset) - lcx - viewMetrics.right;
         hh = Math.max(0,listContent.bottomOffset) - lcy - viewMetrics.bottom;
         listContent.setActualSize(Math.max(0,unscaledWidth + ww),Math.max(0,unscaledHeight + hh));
      }
      
      private function lockedRowSeekPendingResultHandler(data:Object, info:ListBaseSeekPending) : void
      {
         try
         {
            lockedRowContent.iterator.seek(CursorBookmark.FIRST);
         }
         catch(e:ItemPendingError)
         {
            e.addResponder(new ItemResponder(lockedRowSeekPendingResultHandler,seekPendingFailureHandler,null));
         }
         itemsSizeChanged = true;
         this.invalidateDisplayList();
      }
      
      override protected function scrollPositionToIndex(horizontalScrollPosition:int, verticalScrollPosition:int) : int
      {
         return Boolean(iterator) ? int(verticalScrollPosition + lockedRowCount) : -1;
      }
      
      override protected function scrollVertically(pos:int, deltaPos:int, scrollUp:Boolean) : void
      {
         var lines:Sprite = null;
         super.scrollVertically(pos,deltaPos,scrollUp);
         if(Boolean(getStyle("horizontalGridLines")))
         {
            this.drawLinesAndColumnGraphics(listContent,visibleColumns,{});
            if(Boolean(lockedColumnCount))
            {
               this.drawLinesAndColumnGraphics(lockedColumnContent,visibleLockedColumns,{"right":1});
            }
         }
         else
         {
            lines = Sprite(listContent.getChildByName("lines"));
            if(Boolean(lines))
            {
               listContent.setChildIndex(lines,listContent.numChildren - 1);
            }
            if(Boolean(lockedColumnCount))
            {
               lines = Sprite(lockedColumnContent.getChildByName("lines"));
               if(Boolean(lines))
               {
                  lockedColumnContent.setChildIndex(lines,lockedColumnContent.numChildren - 1);
               }
            }
         }
      }
      
      override public function set focusPane(value:Sprite) : void
      {
         super.focusPane = value;
         if(!value && Boolean(this._focusPane))
         {
            this._focusPane.mask = null;
         }
         this._focusPane = value;
      }
      
      override public function showDropFeedback(event:DragEvent) : void
      {
         var dropIndicatorClass:Class = null;
         super.showDropFeedback(event);
         if(lockedColumnCount > 0)
         {
            if(!this.lockedColumnDropIndicator)
            {
               dropIndicatorClass = getStyle("dropIndicatorSkin");
               if(!dropIndicatorClass)
               {
                  dropIndicatorClass = ListDropIndicator;
               }
               this.lockedColumnDropIndicator = IFlexDisplayObject(new dropIndicatorClass());
               this.lockedColumnDropIndicator.x = 2;
               this.lockedColumnDropIndicator.setActualSize(lockedColumnContent.width - 2,4);
               this.lockedColumnDropIndicator.visible = true;
            }
            if(dropIndicator.parent == listContent)
            {
               lockedColumnContent.addChild(DisplayObject(this.lockedColumnDropIndicator));
            }
            else
            {
               lockedColumnAndRowContent.addChild(DisplayObject(this.lockedColumnDropIndicator));
            }
            this.lockedColumnDropIndicator.y = dropIndicator.y;
         }
      }
      
      override public function hideDropFeedback(event:DragEvent) : void
      {
         super.hideDropFeedback(event);
         if(Boolean(this.lockedColumnDropIndicator))
         {
            DisplayObject(this.lockedColumnDropIndicator).parent.removeChild(DisplayObject(this.lockedColumnDropIndicator));
            this.lockedColumnDropIndicator = null;
         }
      }
      
      override public function regenerateStyleCache(recursive:Boolean) : void
      {
         super.regenerateStyleCache(recursive);
         fontContextChanged = true;
         invalidateProperties();
      }
   }
}

