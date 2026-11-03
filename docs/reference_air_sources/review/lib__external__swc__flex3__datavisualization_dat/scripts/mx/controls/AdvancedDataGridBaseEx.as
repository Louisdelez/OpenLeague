package mx.controls
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.GradientType;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   import flash.utils.describeType;
   import flash.utils.getTimer;
   import mx.collections.CursorBookmark;
   import mx.collections.ICollectionView;
   import mx.collections.IViewCursor;
   import mx.collections.ItemResponder;
   import mx.collections.Sort;
   import mx.collections.SortField;
   import mx.collections.errors.ItemPendingError;
   import mx.controls.advancedDataGridClasses.AdvancedDataGridBase;
   import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
   import mx.controls.advancedDataGridClasses.AdvancedDataGridDragProxy;
   import mx.controls.advancedDataGridClasses.AdvancedDataGridHeaderInfo;
   import mx.controls.advancedDataGridClasses.AdvancedDataGridHeaderRenderer;
   import mx.controls.advancedDataGridClasses.AdvancedDataGridItemRenderer;
   import mx.controls.advancedDataGridClasses.AdvancedDataGridListData;
   import mx.controls.advancedDataGridClasses.AdvancedDataGridSortItemRenderer;
   import mx.controls.advancedDataGridClasses.SortInfo;
   import mx.controls.listClasses.IDropInListItemRenderer;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.controls.listClasses.ListBaseSeekPending;
   import mx.controls.listClasses.ListBaseSelectionData;
   import mx.controls.listClasses.ListRowInfo;
   import mx.controls.scrollClasses.ScrollBar;
   import mx.core.ClassFactory;
   import mx.core.ContextualClassFactory;
   import mx.core.EdgeMetrics;
   import mx.core.EventPriority;
   import mx.core.FlexShape;
   import mx.core.FlexSprite;
   import mx.core.IBorder;
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
   import mx.events.AdvancedDataGridEvent;
   import mx.events.AdvancedDataGridEventReason;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.events.DragEvent;
   import mx.events.IndexChangedEvent;
   import mx.events.ListEvent;
   import mx.events.SandboxMouseEvent;
   import mx.events.ScrollEvent;
   import mx.events.ScrollEventDetail;
   import mx.events.ScrollEventDirection;
   import mx.managers.CursorManagerPriority;
   import mx.managers.IFocusManager;
   import mx.managers.IFocusManagerComponent;
   import mx.skins.halo.DataGridColumnDropIndicator;
   import mx.styles.ISimpleStyleClient;
   import mx.styles.StyleManager;
   import mx.utils.ObjectUtil;
   import mx.utils.StringUtil;
   import mx.utils.UIDUtil;
   
   [RequiresDataBinding("true")]
   [IconFile("AdvancedDataGrid.png")]
   [DefaultTriggerEvent("change")]
   [DefaultProperty("dataProvider")]
   [DefaultBindingProperty(source="selectedItem",destination="dataProvider")]
   [DataBindingInfo("{ dataProvider: &quot;String&quot; }")]
   [Exclude(name="cornerRadius",kind="style")]
   [Exclude(name="showDataTips",kind="property")]
   [Exclude(name="maxVerticalScrollPosition",kind="property")]
   [Exclude(name="maxHorizontalScrollPosition",kind="property")]
   [Exclude(name="offscreenExtraRowsOrColumnsChanged",kind="property")]
   [Exclude(name="offscreenExtraColumnsRight",kind="property")]
   [Exclude(name="offscreenExtraColumnsLeft",kind="property")]
   [Exclude(name="offscreenExtraColumns",kind="property")]
   [Exclude(name="offscreenExtraRowsBottom",kind="property")]
   [Exclude(name="offscreenExtraRowsTop",kind="property")]
   [Exclude(name="offscreenExtraRows",kind="property")]
   [Exclude(name="offscreenExtraRowsOrColumns",kind="property")]
   [Exclude(name="labelField",kind="property")]
   [Exclude(name="columnCount",kind="property")]
   [Style(name="headerDragProxyStyleName",type="String",inherit="no")]
   [Style(name="columnDropIndicatorSkin",type="Class",inherit="no")]
   [Style(name="stretchCursor",type="Class",inherit="no")]
   [Style(name="verticalLockedSeparatorSkin",type="Class",inherit="no")]
   [Style(name="verticalSeparatorSkin",type="Class",inherit="no")]
   [Style(name="horizontalLockedSeparatorSkin",type="Class",inherit="no")]
   [Style(name="horizontalSeparatorSkin",type="Class",inherit="no")]
   [Style(name="headerHorizontalSeparatorSkin",type="Class",inherit="no")]
   [Style(name="headerSeparatorSkin",type="Class",inherit="no")]
   [Style(name="headerBackgroundSkin",type="Class",inherit="no")]
   [Style(name="columnResizeSkin",type="Class",inherit="no")]
   [Style(name="headerStyleName",type="String",inherit="no")]
   [Style(name="selectionColor",type="uint",format="Color",inherit="yes")]
   [Style(name="rollOverColor",type="uint",format="Color",inherit="yes")]
   [Style(name="headerColors",type="Array",arrayType="uint",format="Color",inherit="yes")]
   [Style(name="horizontalGridLineColor",type="uint",format="Color",inherit="yes")]
   [Style(name="verticalGridLineColor",type="uint",format="Color",inherit="yes")]
   [Style(name="horizontalGridLines",type="Boolean",inherit="no")]
   [Style(name="verticalGridLines",type="Boolean",inherit="no")]
   [Style(name="disabledIconColor",type="uint",format="Color",inherit="yes")]
   [Style(name="iconColor",type="uint",format="Color",inherit="yes")]
   [Event(name="headerShift",type="mx.events.IndexChangedEvent")]
   [Event(name="sort",type="mx.events.AdvancedDataGridEvent")]
   [Event(name="headerRelease",type="mx.events.AdvancedDataGridEvent")]
   [Event(name="columnStretch",type="mx.events.AdvancedDataGridEvent")]
   [Event(name="itemFocusOut",type="mx.events.AdvancedDataGridEvent")]
   [Event(name="itemFocusIn",type="mx.events.AdvancedDataGridEvent")]
   [Event(name="itemEditEnd",type="mx.events.AdvancedDataGridEvent")]
   [Event(name="itemEditBegin",type="mx.events.AdvancedDataGridEvent")]
   [Event(name="itemEditBeginning",type="mx.events.AdvancedDataGridEvent")]
   public class AdvancedDataGridBaseEx extends AdvancedDataGridBase implements IIMESupport
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      public static var useOldDGHeaderBGLogic:Boolean = false;
      
      private var columnsChanged:Boolean = false;
      
      [Inspectable(defaultValue="400")]
      public var lookAheadDuration:Number = 400;
      
      private var dropIndexFound:Boolean = false;
      
      private var displayWidth:Number;
      
      private var separators:Array;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var columnDropIndicator:IFlexDisplayObject;
      
      private var startX:Number;
      
      private var lookAheadCache:String = "";
      
      private var minX:Number;
      
      private var _headerWordWrapPresent:Boolean = false;
      
      private var previousTime:uint;
      
      private var separatorAffordance:Number = 3;
      
      private var _minColumnWidth:Number;
      
      private var manualSort:Boolean;
      
      private var _headerIndex:int = -1;
      
      private var bEditedItemPositionChanged:Boolean = false;
      
      private var sortColumn:AdvancedDataGridColumn;
      
      protected var orderedHeadersList:Array = [];
      
      private var inEndEdit:Boolean = false;
      
      protected var dropColumnIndex:int = -1;
      
      [Inspectable(category="General")]
      public var resizableColumns:Boolean = true;
      
      private var _editedItemPosition:Object;
      
      [Inspectable(category="General")]
      public var sortableColumns:Boolean = true;
      
      private var actualRowIndex:int;
      
      protected var lockedSeparators:Array;
      
      private var actualColIndex:int;
      
      private var _focusPane:Sprite;
      
      private var collectionUpdatesDisabled:Boolean = false;
      
      protected var headerInfoInitialized:Boolean = false;
      
      private var isHeaderDragOutside:Boolean = false;
      
      private var lastItemDown:IListItemRenderer;
      
      [Inspectable(environment="none")]
      public var itemEditorInstance:IListItemRenderer;
      
      protected var displayableColumns:Array;
      
      private var headerSepSkinChanged:Boolean = false;
      
      private var resizingColumn:AdvancedDataGridColumn;
      
      private var lastPt:Point;
      
      private var dontEdit:Boolean = false;
      
      protected var movingColumn:AdvancedDataGridColumn;
      
      private var _sortExpertMode:Boolean = false;
      
      protected var generatedColumns:Boolean = true;
      
      private var lastEditedItemPosition:*;
      
      private var subContentScrolled:Boolean = false;
      
      private var losingFocus:Boolean = false;
      
      private var _originalHeaderHeight:Number = 0;
      
      private var sortDirection:String;
      
      private var headerBGSkinChanged:Boolean = false;
      
      protected var isKeyPressed:Boolean = false;
      
      private var resizeGraphic:IFlexDisplayObject;
      
      private var _originalExplicitHeaderHeight:Boolean = false;
      
      private var minColumnWidthInvalid:Boolean = false;
      
      private var resizeCursorID:int = 0;
      
      private var _proposedEditedItemPosition:*;
      
      private var _imeMode:String = null;
      
      private var _editable:String = "";
      
      private var sortIndex:int = -1;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var selectedHeaderInfo:AdvancedDataGridHeaderInfo;
      
      private var lastSortIndex:int = -1;
      
      private var _draggableColumns:Boolean = true;
      
      protected var measuringObjects:Dictionary;
      
      public function AdvancedDataGridBaseEx()
      {
         super();
         _columns = [];
         itemRenderer = new ContextualClassFactory(AdvancedDataGridItemRenderer,getNonNullSystemManager());
         headerRenderer = new ClassFactory(AdvancedDataGridHeaderRenderer);
         sortItemRenderer = new ClassFactory(AdvancedDataGridSortItemRenderer);
         setRowHeight(20);
         addEventListener(AdvancedDataGridEvent.ITEM_EDIT_BEGINNING,itemEditorItemEditBeginningHandler,false,EventPriority.DEFAULT_HANDLER);
         addEventListener(AdvancedDataGridEvent.ITEM_EDIT_BEGIN,itemEditorItemEditBeginHandler,false,EventPriority.DEFAULT_HANDLER);
         addEventListener(AdvancedDataGridEvent.ITEM_EDIT_END,itemEditorItemEditEndHandler,false,EventPriority.DEFAULT_HANDLER);
         addEventListener(AdvancedDataGridEvent.HEADER_RELEASE,headerReleaseHandler,false,EventPriority.DEFAULT_HANDLER);
         addEventListener(AdvancedDataGridEvent.SORT,sortHandler,false,EventPriority.DEFAULT_HANDLER);
         addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
      }
      
      override public function measureWidthOfItems(index:int = -1, count:int = 0) : Number
      {
         var w:Number = 0;
         var n:int = Boolean(columns) ? int(columns.length) : 0;
         for(var i:int = 0; i < n; i++)
         {
            if(Boolean(columns[i].visible))
            {
               w += columns[i].width;
            }
         }
         return w;
      }
      
      public function set imeMode(value:String) : void
      {
         _imeMode = value;
      }
      
      private function itemEditorItemEditEndHandler(event:AdvancedDataGridEvent) : void
      {
         var bChanged:Boolean = false;
         var newData:Object = null;
         var property:String = null;
         var data:Object = null;
         var typeInfo:String = null;
         var variable:XML = null;
         var listData:AdvancedDataGridListData = null;
         var fm:IFocusManager = null;
         if(!event.isDefaultPrevented())
         {
            bChanged = false;
            if(event.reason == AdvancedDataGridEventReason.NEW_COLUMN)
            {
               if(!collectionUpdatesDisabled)
               {
                  collection.disableAutoUpdate();
                  collectionUpdatesDisabled = true;
               }
            }
            else if(collectionUpdatesDisabled)
            {
               collection.enableAutoUpdate();
               collectionUpdatesDisabled = false;
            }
            if(Boolean(itemEditorInstance) && event.reason != AdvancedDataGridEventReason.CANCELLED)
            {
               newData = itemEditorInstance[_columns[event.columnIndex].editorDataField];
               property = _columns[event.columnIndex].dataField;
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
               if(data[property] != newData)
               {
                  bChanged = true;
                  data[property] = newData;
               }
               if(bChanged && !(data is IPropertyChangeNotifier))
               {
                  collection.itemUpdated(data,property);
               }
               if(event.itemRenderer is IDropInListItemRenderer)
               {
                  listData = AdvancedDataGridListData(IDropInListItemRenderer(event.itemRenderer).listData);
                  listData.label = _columns[event.columnIndex].itemToLabel(data);
                  IDropInListItemRenderer(event.itemRenderer).listData = listData;
               }
               event.itemRenderer.data = data;
            }
         }
         else if(event.reason != AdvancedDataGridEventReason.OTHER)
         {
            if(Boolean(itemEditorInstance) && Boolean(_editedItemPosition))
            {
               if(selectedIndex != _editedItemPosition.rowIndex)
               {
                  selectedIndex = _editedItemPosition.rowIndex;
               }
               fm = focusManager;
               if(itemEditorInstance is IFocusManagerComponent)
               {
                  fm.setFocus(IFocusManagerComponent(itemEditorInstance));
               }
            }
         }
         if(event.reason == AdvancedDataGridEventReason.OTHER || !event.isDefaultPrevented())
         {
            destroyItemEditor();
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function measureHeightOfItemsUptoMaxHeight(index:int = -1, count:int = 0, maxHeight:Number = -1) : Number
      {
         var paddingTop:Number;
         var bMore:Boolean;
         var paddingBottom:Number;
         var ch:Number;
         var h:Number;
         var i:int;
         var lockedCount:int;
         var bookmark:CursorBookmark;
         var item:IListItemRenderer = null;
         var c:AdvancedDataGridColumn = null;
         var n:int = 0;
         var j:int = 0;
         var data:Object = null;
         if(!columns.length)
         {
            return rowHeight * count;
         }
         h = 0;
         ch = 0;
         paddingTop = Number(getStyle("paddingTop"));
         paddingBottom = Number(getStyle("paddingBottom"));
         if(!measuringObjects)
         {
            measuringObjects = new Dictionary(false);
         }
         lockedCount = lockedRowCount;
         if(headerVisible && count > 0 && index == -1)
         {
            h = calculateHeaderHeight();
            if(maxHeight != -1 && h > maxHeight)
            {
               setRowCount(0);
               return 0;
            }
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
         if(lockedCount > 0 && Boolean(collectionIterator))
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
               n = int(columns.length);
               for(j = 0; j < n; j++)
               {
                  c = columns[j];
                  if(c.visible)
                  {
                     item = getMeasuringRenderer(c,false,data);
                     setupRendererFromData(c,item,data);
                     ch = Math.max(ch,variableRowHeight ? item.getExplicitOrMeasuredHeight() + paddingBottom + paddingTop : rowHeight);
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
               count = i;
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
      
      private function updateSortIndexAndDirection() : void
      {
         if(!sortableColumns)
         {
            lastSortIndex = sortIndex;
            sortIndex = -1;
            if(lastSortIndex != sortIndex)
            {
               invalidateDisplayList();
            }
            return;
         }
         if(!dataProvider)
         {
            return;
         }
         var view:ICollectionView = ICollectionView(dataProvider);
         var sort:Sort = view.sort;
         if(!sort)
         {
            sortIndex = lastSortIndex = -1;
            return;
         }
         var fields:Array = sort.fields;
         if(!fields)
         {
            return;
         }
         if(fields.length != 1)
         {
            lastSortIndex = sortIndex;
            sortIndex = -1;
            if(lastSortIndex != sortIndex)
            {
               invalidateDisplayList();
            }
            return;
         }
         var sortField:SortField = fields[0];
         var n:int = int(_columns.length);
         for(var i:int = 0; i < n; i++)
         {
            if(_columns[i].dataField == sortField.name)
            {
               sortIndex = Boolean(_columns[i].sortable) ? i : -1;
               sortDirection = sortField.descending ? "DESC" : "ASC";
               return;
            }
         }
      }
      
      private function itemEditorItemEditBeginningHandler(event:AdvancedDataGridEvent) : void
      {
         if(!event.isDefaultPrevented())
         {
            setEditedItemPosition({
               "columnIndex":event.columnIndex,
               "rowIndex":event.rowIndex
            });
         }
         else if(!itemEditorInstance)
         {
            _editedItemPosition = null;
            setFocus();
         }
      }
      
      private function generateCols() : void
      {
         var col:AdvancedDataGridColumn = null;
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
                     col = new AdvancedDataGridColumn();
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
                  col = new AdvancedDataGridColumn();
                  col.dataField = String(colName);
                  newCols.push(col);
               }
            }
            columns = newCols;
            generatedColumns = true;
         }
      }
      
      [Bindable("itemFocusIn")]
      public function get editedItemPosition() : Object
      {
         if(Boolean(_editedItemPosition))
         {
            return {
               "rowIndex":_editedItemPosition.rowIndex,
               "columnIndex":_editedItemPosition.columnIndex
            };
         }
         return _editedItemPosition;
      }
      
      private function setEditedItemPosition(coord:Object) : void
      {
         bEditedItemPositionChanged = true;
         _proposedEditedItemPosition = coord;
         invalidateDisplayList();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getSeparators() : Array
      {
         return separators;
      }
      
      private function columnResizeMouseDownHandler(event:MouseEvent) : void
      {
         var target:DisplayObject = null;
         var index:int = 0;
         var optimumColumns:Array = null;
         var headerItem:IListItemRenderer = null;
         var sbRoot:DisplayObject = null;
         var pt:Point = null;
         if(!enabled || !resizableColumns)
         {
            return;
         }
         target = DisplayObject(event.target);
         index = target.parent.getChildIndex(target);
         if(lockedColumnCount > 0 && target.parent == UIComponent(getLines().getChildByName("header")))
         {
            index += lockedColumnCount - 1;
         }
         optimumColumns = getOptimumColumns();
         if(!optimumColumns[index].resizable)
         {
            return;
         }
         if(Boolean(itemEditorInstance))
         {
            endEdit(AdvancedDataGridEventReason.OTHER);
         }
         startX = DisplayObject(event.target).x;
         lastPt = new Point(event.stageX,event.stageY);
         lastPt = listContent.globalToLocal(lastPt);
         resizingColumn = optimumColumns[index];
         headerItem = getHeaderInfo(optimumColumns[index]).headerItem;
         if(index > lockedColumnCount)
         {
            minX = getAdjustedXPos(headerItem.x);
            startX = getAdjustedXPos(startX);
         }
         else
         {
            minX = headerItem.x;
         }
         minX += resizingColumn.minWidth;
         isPressed = true;
         sbRoot = systemManager.getSandboxRoot();
         sbRoot.addEventListener(MouseEvent.MOUSE_MOVE,columnResizingHandler,true);
         sbRoot.addEventListener(MouseEvent.MOUSE_UP,columnResizeMouseUpHandler,true);
         sbRoot.addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,columnResizeMouseUpHandler);
         systemManager.deployMouseShields(true);
         var resizeSkinClass:Class = getStyle("columnResizeSkin");
         resizeGraphic = new resizeSkinClass();
         listContent.addChild(DisplayObject(resizeGraphic));
         pt = new Point(event.stageX,event.stageY);
         pt = listContent.globalToLocal(pt);
         resizeGraphic.move(pt.x,target.y);
         resizeGraphic.setActualSize(resizeGraphic.measuredWidth,unscaledHeight - target.y);
      }
      
      protected function getSeparator(i:int, seperators:Array, headerLines:UIComponent) : UIComponent
      {
         var sep:UIComponent = null;
         var sepSkin:IFlexDisplayObject = null;
         var headerSeparatorClass:Class = null;
         if(i < headerLines.numChildren)
         {
            sep = UIComponent(headerLines.getChildAt(i));
            sepSkin = IFlexDisplayObject(sep.getChildAt(0));
         }
         else
         {
            headerSeparatorClass = getStyle("headerSeparatorSkin");
            sepSkin = new headerSeparatorClass();
            if(sepSkin is ISimpleStyleClient)
            {
               ISimpleStyleClient(sepSkin).styleName = this;
            }
            sep = new UIComponent();
            sep.addChild(DisplayObject(sepSkin));
            headerLines.addChild(sep);
            DisplayObject(sep).addEventListener(MouseEvent.MOUSE_OVER,columnResizeMouseOverHandler);
            DisplayObject(sep).addEventListener(MouseEvent.MOUSE_OUT,columnResizeMouseOutHandler);
            DisplayObject(sep).addEventListener(MouseEvent.MOUSE_DOWN,columnResizeMouseDownHandler);
            seperators.push(sep);
         }
         return sep;
      }
      
      override protected function scrollVertically(pos:int, deltaPos:int, scrollUp:Boolean) : void
      {
         iterator.seek(CursorBookmark.CURRENT,lockedRowCount);
         super.scrollVertically(pos,deltaPos,scrollUp);
         iterator.seek(CursorBookmark.CURRENT,-lockedRowCount);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function columnRendererChanged(c:AdvancedDataGridColumn) : void
      {
         var item:IListItemRenderer = null;
         var freeRenderers:Array = null;
         var factory:IFactory = columnItemRendererFactory(c,true,null);
         if(Boolean(measuringObjects))
         {
            item = measuringObjects[factory];
            if(Boolean(item))
            {
               item.parent.removeChild(DisplayObject(item));
               measuringObjects[factory] = null;
            }
            factory = columnItemRendererFactory(c,false,null);
            item = measuringObjects[factory];
            if(Boolean(item))
            {
               item.parent.removeChild(DisplayObject(item));
               measuringObjects[factory] = null;
            }
         }
         if(Boolean(freeItemRenderersTable[c]))
         {
            freeRenderers = freeItemRenderersTable[c][c.itemRenderer] as Array;
            if(Boolean(freeRenderers))
            {
               while(Boolean(freeRenderers.length))
               {
                  item = freeRenderers.pop();
                  item.parent.removeChild(DisplayObject(item));
               }
            }
         }
         rendererChanged = true;
         invalidateDisplayList();
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function addSelectionData(uid:String, selectionData:ListBaseSelectionData) : void
      {
         if(selectionData.data is AdvancedDataGridColumn)
         {
            return;
         }
         super.addSelectionData(uid,selectionData);
      }
      
      private function deactivateHandler(event:Event) : void
      {
         if(Boolean(itemEditorInstance))
         {
            endEdit(AdvancedDataGridEventReason.OTHER);
            losingFocus = true;
            setFocus();
         }
      }
      
      private function keyFocusChangeHandler(event:FocusEvent) : void
      {
         if(event.keyCode == Keyboard.TAB && !event.isDefaultPrevented() && findNextItemRenderer(event.shiftKey))
         {
            event.preventDefault();
         }
      }
      
      protected function findSortField(name:String) : int
      {
         var i:int = 0;
         if(Boolean(collection) && Boolean(collection.sort))
         {
            for(i = 0; i < collection.sort.fields.length; i++)
            {
               if(collection.sort.fields[i]["name"] == name)
               {
                  return i;
               }
            }
         }
         return -1;
      }
      
      override public function measureHeightOfItems(index:int = -1, count:int = 0) : Number
      {
         return measureHeightOfItemsUptoMaxHeight(index,count);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get headerIndex() : int
      {
         return _headerIndex;
      }
      
      override protected function selectItem(item:IListItemRenderer, shiftKey:Boolean, ctrlKey:Boolean, transition:Boolean = true) : Boolean
      {
         var val:Boolean = false;
         val = super.selectItem(item,shiftKey,ctrlKey,transition);
         if(item.data is AdvancedDataGridColumn)
         {
            _selectedItem = null;
         }
         return val;
      }
      
      public function set editedItemPosition(value:Object) : void
      {
         if(!value)
         {
            setEditedItemPosition(null);
            return;
         }
         var newValue:Object = {
            "rowIndex":value.rowIndex,
            "columnIndex":value.columnIndex
         };
         setEditedItemPosition(newValue);
      }
      
      override protected function makeRowsAndColumns(left:Number, top:Number, right:Number, bottom:Number, firstCol:int, firstRow:int, byCount:Boolean = false, rowsNeeded:uint = 0) : Point
      {
         var col:AdvancedDataGridColumn = null;
         var item:IListItemRenderer = null;
         var rowData:ListRowInfo = null;
         var dx:Number = NaN;
         var dy:Number = NaN;
         var dw:Number = NaN;
         var dh:Number = NaN;
         listContent.allowItemSizeChangeNotification = false;
         listSubContent.allowItemSizeChangeNotification = false;
         if(headerVisible && itemsSizeChanged)
         {
            calculateHeaderHeight();
         }
         var pt:Point = super.makeRowsAndColumns(left,top,right,bottom,firstCol,firstRow,byCount,rowsNeeded);
         var optimumColumns:Array = getOptimumColumns();
         if(Boolean(itemEditorInstance))
         {
            itemEditorInstance.parent.setChildIndex(DisplayObject(itemEditorInstance),itemEditorInstance.parent.numChildren - 1);
            col = optimumColumns[actualColIndex];
            item = listItems[actualRowIndex][actualColIndex];
            rowData = rowInfo[actualRowIndex];
            if(Boolean(item) && !col.rendererIsEditor)
            {
               dx = col.editorXOffset;
               dy = col.editorYOffset;
               dw = col.editorWidthOffset;
               dh = col.editorHeightOffset;
               itemEditorInstance.move(item.x + dx,rowData.y + dy);
               itemEditorInstance.setActualSize(Math.min(col.width + dw,listContent.width - listContent.x - itemEditorInstance.x),Math.min(rowData.height + dh,listContent.height - listContent.y - itemEditorInstance.y));
            }
         }
         var lines:Sprite = Sprite(listSubContent.getChildByName("lines"));
         if(Boolean(lines))
         {
            listSubContent.setChildIndex(lines,listSubContent.numChildren - 1);
         }
         listContent.allowItemSizeChangeNotification = variableRowHeight;
         listSubContent.allowItemSizeChangeNotification = variableRowHeight;
         return pt;
      }
      
      protected function colNumToIndex(colNum:int) : int
      {
         if(getOptimumColumns() == visibleColumns)
         {
            return absoluteToVisibleColumnIndex(colNum);
         }
         if(getOptimumColumns() == displayableColumns)
         {
            return absoluteToDisplayColumnIndex(colNum);
         }
         return -1;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getLockedSeparators() : Array
      {
         return lockedSeparators;
      }
      
      public function set sortExpertMode(value:Boolean) : void
      {
         _sortExpertMode = value;
         invalidateHeaders();
         invalidateProperties();
         invalidateDisplayList();
      }
      
      override public function set verticalScrollPosition(value:Number) : void
      {
         super.verticalScrollPosition = value;
         if(variableRowHeight)
         {
            drawHorizontalSeparators();
         }
      }
      
      private function getLockedContent() : Sprite
      {
         var locked:Sprite = Sprite(listContent.getChildByName("lockedContent"));
         if(!locked)
         {
            locked = new UIComponent();
            locked.name = "lockedContent";
            locked.cacheAsBitmap = true;
            locked.mouseEnabled = false;
            listContent.addChild(locked);
         }
         listContent.setChildIndex(locked,listContent.numChildren - 1);
         return locked;
      }
      
      override public function calculateDropIndex(event:DragEvent = null) : int
      {
         var item:IListItemRenderer = null;
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
               if(rowInfo[i].y <= pt.y && pt.y <= rowInfo[i].y + rowInfo[i].height)
               {
                  item = listItems[i][0];
                  break;
               }
            }
            if(Boolean(item))
            {
               lastDropIndex = itemRendererToIndex(item);
            }
            else
            {
               lastDropIndex = Boolean(collection) ? int(collection.length) : 0;
            }
         }
         return lastDropIndex;
      }
      
      [Inspectable(defaultValue="NaN")]
      public function get minColumnWidth() : Number
      {
         return _minColumnWidth;
      }
      
      protected function clearSeparators() : void
      {
         if(!separators)
         {
            return;
         }
         var lines:Sprite = Sprite(listSubContent.getChildByName("lines"));
         var headerLines:Sprite = Sprite(lines.getChildByName("header"));
         if(Boolean(headerLines))
         {
            while(Boolean(headerLines.numChildren))
            {
               headerLines.removeChildAt(headerLines.numChildren - 1);
               separators.pop();
            }
         }
         var lockedContent:Sprite = getLockedContent();
         headerLines = Sprite(lockedContent.getChildByName("lockedHeaderLines"));
         if(Boolean(headerLines))
         {
            while(Boolean(headerLines.numChildren))
            {
               headerLines.removeChildAt(headerLines.numChildren - 1);
               lockedSeparators.pop();
            }
         }
      }
      
      override protected function mouseDownHandler(event:MouseEvent) : void
      {
         var r:IListItemRenderer = null;
         var s:Sprite = null;
         var n:int = 0;
         var headerItem:IListItemRenderer = null;
         var i:int = 0;
         var headerInfo:AdvancedDataGridHeaderInfo = null;
         var c:AdvancedDataGridColumn = null;
         var h:Number = NaN;
         var w:Number = NaN;
         var x:Number = NaN;
         var g:Graphics = null;
         var lockedWidth:Number = NaN;
         var lastLockedInfo:AdvancedDataGridHeaderInfo = null;
         var sbRoot:DisplayObject = null;
         var pos:Point = null;
         var bEndedEdit:Boolean = false;
         var pt:Point = null;
         r = mouseEventToItemRenderer(event);
         var optimumColumns:Array = getOptimumColumns();
         if(enabled && (sortableColumns || draggableColumns) && headerVisible && hasHeaderItemsCreated())
         {
            n = int(orderedHeadersList.length);
            i = 0;
            while(i < n && Boolean(r))
            {
               headerItem = orderedHeadersList[i].headerItem;
               if(headerItem == r)
               {
                  headerInfo = orderedHeadersList[i];
                  if(Boolean(itemEditorInstance))
                  {
                     endEdit(AdvancedDataGridEventReason.OTHER);
                  }
                  c = orderedHeadersList[i].column;
                  if(sortableColumns && c.sortable)
                  {
                     lastItemDown = r;
                     s = Sprite(selectionLayer.getChildByName("headerSelection"));
                     if(!s)
                     {
                        s = new FlexSprite();
                        s.name = "headerSelection";
                        selectionLayer.addChild(s);
                     }
                     h = r.height + cachedPaddingBottom + cachedPaddingTop;
                     w = Number(r.getExplicitOrMeasuredWidth());
                     x = Number(r.x);
                     if(headerInfo.actualColNum >= lockedColumnCount)
                     {
                        x = getAdjustedXPos(r.x);
                        if(horizontalScrollPosition > 0 && headerInfo.actualColNum - horizontalScrollPosition < lockedColumnCount)
                        {
                           lockedWidth = 0;
                           if(lockedColumnCount > 0)
                           {
                              lastLockedInfo = getHeaderInfo(columns[lockedColumnCount - 1]);
                              lockedWidth = lastLockedInfo.headerItem.x + columns[lockedColumnCount - 1].width;
                           }
                           else
                           {
                              lockedWidth = 0;
                           }
                           w -= lockedWidth - x;
                           x = lockedWidth;
                        }
                     }
                     g = s.graphics;
                     g.clear();
                     g.beginFill(getStyle("selectionColor"));
                     g.drawRect(0,0,w,h - 0.5);
                     g.endFill();
                     s.x = x;
                     s.y = r.y - cachedPaddingTop;
                  }
                  isPressed = true;
                  if(draggableColumns && isDraggingAllowed(c))
                  {
                     startX = NaN;
                     sbRoot = systemManager.getSandboxRoot();
                     sbRoot.addEventListener(MouseEvent.MOUSE_MOVE,columnDraggingMouseMoveHandler,true);
                     sbRoot.addEventListener(MouseEvent.MOUSE_UP,columnDraggingMouseUpHandler,true);
                     sbRoot.addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,columnDraggingMouseUpHandler);
                     systemManager.deployMouseShields(true);
                     movingColumn = c;
                  }
                  return;
               }
               i++;
            }
         }
         lastItemDown = null;
         var isItemEditor:Boolean = itemRendererContains(itemEditorInstance,DisplayObject(event.target));
         if(!isItemEditor)
         {
            if(Boolean(r) && Boolean(r.data))
            {
               lastItemDown = r;
               pos = itemRendererToIndices(r);
               bEndedEdit = true;
               if(Boolean(itemEditorInstance))
               {
                  if(pos == null || displayableColumns[pos.x].editable == false)
                  {
                     bEndedEdit = endEdit(AdvancedDataGridEventReason.OTHER);
                  }
                  else
                  {
                     bEndedEdit = endEdit(editedItemPosition.rowIndex == pos.y ? AdvancedDataGridEventReason.NEW_COLUMN : AdvancedDataGridEventReason.NEW_ROW);
                  }
               }
               if(!bEndedEdit)
               {
                  return;
               }
            }
            else if(Boolean(itemEditorInstance))
            {
               endEdit(AdvancedDataGridEventReason.OTHER);
            }
            if(headerIndex != -1)
            {
               pt = itemRendererToIndices(r);
               if(Boolean(pt))
               {
                  unselectColumnHeader(headerIndex,true);
                  headerIndex = -1;
                  caretIndex = pt.y;
               }
            }
            super.mouseDownHandler(event);
            if(Boolean(r))
            {
               if(Boolean(pos) && Boolean(displayableColumns[pos.x].rendererIsEditor))
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
      
      protected function rowNumberToData(rowNumber:int) : Object
      {
         var iterator:IViewCursor = null;
         iterator = collection.createCursor();
         iterator.seek(CursorBookmark.FIRST,rowNumber);
         if(iterator.afterLast)
         {
            return null;
         }
         return iterator.current;
      }
      
      override protected function keyDownHandler(event:KeyboardEvent) : void
      {
         if(Boolean(itemEditorInstance) || event.target != event.currentTarget)
         {
            return;
         }
         if(headerIndex != -1)
         {
            headerNavigationHandler(event);
            return;
         }
         if(event.keyCode == Keyboard.ESCAPE)
         {
            setEditedItemPosition(null);
            lastEditedItemPosition = null;
            endEdit(AdvancedDataGridEventReason.CANCELLED);
            return;
         }
         if(headerVisible && selectedIndex == 0 && caretIndex == 0 && event.keyCode == Keyboard.UP && !event.ctrlKey && !event.shiftKey)
         {
            moveFocusToHeader();
         }
         else if(event.keyCode == Keyboard.UP && caretIndex == 0 && selectedIndex == -1)
         {
            moveFocusToHeader();
         }
         else if(event.shiftKey && (event.keyCode == Keyboard.PAGE_UP || event.keyCode == Keyboard.PAGE_DOWN))
         {
            moveSelectionHorizontally(event.keyCode,event.shiftKey,event.ctrlKey);
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
      
      protected function addSortField(columnName:String, columnNumber:int, collection:ICollectionView) : void
      {
         var column:AdvancedDataGridColumn = null;
         var headerInfo:AdvancedDataGridHeaderInfo = null;
         var singleColumnSort:Boolean = false;
         var field:SortField = null;
         var sort:Sort = null;
         column = columns[columnNumber];
         if(!column.sortable)
         {
            return;
         }
         headerInfo = getHeaderInfo(column);
         if(Boolean(headerInfo) && Boolean(headerInfo.internalLabelFunction != null) && column.sortCompareFunction == null)
         {
            return;
         }
         singleColumnSort = false;
         if(!collection.sort || !collection.sort.fields)
         {
            singleColumnSort = true;
            sort = new Sort();
            sort.fields = [];
            collection.sort = sort;
         }
         else if(collection.sort.fields.length == 0)
         {
            singleColumnSort = true;
         }
         if(singleColumnSort)
         {
            lastSortIndex = sortIndex;
            sortIndex = columnNumber;
            sortColumn = column;
            sortDirection = "DESC";
         }
         else
         {
            lastSortIndex = -1;
            sortIndex = -1;
            sortColumn = null;
            sortDirection = null;
         }
         column.sortDescending = false;
         field = new SortField(columnName);
         if(column.sortCompareFunction != null)
         {
            field.compareFunction = column.sortCompareFunction;
         }
         collection.sort.fields.push(field);
      }
      
      [Inspectable(category="General")]
      public function get editable() : String
      {
         return _editable;
      }
      
      override protected function focusInHandler(event:FocusEvent) : void
      {
         var foundOne:Boolean = false;
         var row:Array = null;
         if(losingFocus)
         {
            losingFocus = false;
            return;
         }
         if(Boolean(editable.length))
         {
            addEventListener(FocusEvent.KEY_FOCUS_CHANGE,keyFocusChangeHandler);
            addEventListener(MouseEvent.MOUSE_DOWN,mouseFocusChangeHandler);
         }
         if(event.target != this)
         {
            return;
         }
         super.focusInHandler(event);
         if(Boolean(editable.length) && !isPressed)
         {
            _editedItemPosition = lastEditedItemPosition;
            foundOne = editedItemPosition != null;
            if(!_editedItemPosition)
            {
               _editedItemPosition = {
                  "rowIndex":0,
                  "columnIndex":0
               };
               while(_editedItemPosition.columnIndex != _columns.length)
               {
                  if(Boolean(_columns[_editedItemPosition.columnIndex].editable) && Boolean(_columns[_editedItemPosition.columnIndex].visible))
                  {
                     row = listItems[_editedItemPosition.rowIndex];
                     if(Boolean(row) && Boolean(row[_editedItemPosition.columnIndex]))
                     {
                        foundOne = true;
                        break;
                     }
                  }
                  ++_editedItemPosition.columnIndex;
               }
            }
            if(foundOne)
            {
               setEditedItemPosition(_editedItemPosition);
            }
         }
      }
      
      protected function hasHeaderItemsCreated(index:int = -1) : Boolean
      {
         if(index == -1)
         {
            return Boolean(headerItems) && Boolean(headerItems[0]) && Boolean(headerItems[0][0]);
         }
         return Boolean(headerItems) && Boolean(headerItems[0]) && Boolean(headerItems[0][index]);
      }
      
      private function flipSortOrder(columnName:String, columnNumber:int, collection:ICollectionView) : String
      {
         var column:AdvancedDataGridColumn = null;
         if(Boolean(collection.sort))
         {
            column = columns[columnNumber];
            collection.sort.fields[findSortField(columnName)]["descending"] = !collection.sort.fields[findSortField(columnName)]["descending"];
            if(Boolean(collection.sort.fields[findSortField(columnName)]["descending"]))
            {
               column.sortDescending = true;
               return "DESC";
            }
            column.sortDescending = false;
            return "ASC";
         }
         return null;
      }
      
      protected function isDataEditable(data:Object) : Boolean
      {
         return true;
      }
      
      public function createItemEditor(colIndex:int, rowIndex:int) : void
      {
         var item:IListItemRenderer = null;
         var i:int = 0;
         var dx:Number = NaN;
         var dy:Number = NaN;
         var dw:Number = NaN;
         var dh:Number = NaN;
         var itemXPos:Number = NaN;
         var itemEditor:IFactory = null;
         if(displayableColumns.length != _columns.length)
         {
            for(i = 0; i < displayableColumns.length; i++)
            {
               if(displayableColumns[i].colNum >= colIndex)
               {
                  colIndex = i;
                  break;
               }
            }
            if(i == displayableColumns.length)
            {
               colIndex = 0;
            }
         }
         var col:AdvancedDataGridColumn = displayableColumns[colIndex];
         if(rowIndex > lockedRowCount)
         {
            rowIndex -= verticalScrollPosition;
         }
         if(colIndex > lockedColumnCount)
         {
            colIndex -= horizontalScrollPosition;
         }
         item = listItems[actualRowIndex][actualColIndex];
         var rowData:ListRowInfo = rowInfo[actualRowIndex];
         if(item is IDropInListItemRenderer)
         {
            IDropInListItemRenderer(item).listData.label = col.itemToLabel(item.data,false);
         }
         if(!col.rendererIsEditor)
         {
            dx = 0;
            dy = -2;
            dw = 0;
            dh = 4;
            if(!itemEditorInstance)
            {
               itemEditor = col.itemEditor;
               dx = col.editorXOffset;
               dy = col.editorYOffset;
               dw = col.editorWidthOffset;
               dh = col.editorHeightOffset;
               itemEditorInstance = itemEditor.newInstance();
               itemEditorInstance.owner = this;
               itemEditorInstance.styleName = col;
               addRendererToContentArea(itemEditorInstance,col);
            }
            itemEditorInstance.parent.setChildIndex(DisplayObject(itemEditorInstance),itemEditorInstance.parent.numChildren - 1);
            itemEditorInstance.visible = true;
            itemXPos = item.x + dx;
            itemEditorInstance.move(itemXPos,rowData.y + dy);
            itemEditorInstance.setActualSize(editedItemRenderer.width + dw,Math.min(rowData.height + dh,listContent.height - listContent.y - itemEditorInstance.y));
            DisplayObject(itemEditorInstance).addEventListener(FocusEvent.FOCUS_OUT,itemEditorFocusOutHandler);
            layoutItemEditor();
         }
         else
         {
            itemEditorInstance = item;
         }
         DisplayObject(itemEditorInstance).addEventListener(KeyboardEvent.KEY_DOWN,editorKeyDownHandler);
         systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_DOWN,editorMouseDownHandler,true,0,true);
         systemManager.getSandboxRoot().addEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE,editorMouseDownHandler,false,0,true);
         systemManager.addEventListener(Event.RESIZE,editorStageResizeHandler,true,0,true);
      }
      
      [Inspectable(category="General",enumeration="true,false",defaultValue="true")]
      override public function set enabled(value:Boolean) : void
      {
         super.enabled = value;
         if(Boolean(itemEditorInstance))
         {
            endEdit(AdvancedDataGridEventReason.OTHER);
         }
         invalidateDisplayList();
      }
      
      override protected function get dragImage() : IUIComponent
      {
         var image:AdvancedDataGridDragProxy = new AdvancedDataGridDragProxy();
         image.owner = this;
         image.moduleFactory = moduleFactory;
         return image;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function set headerIndex(value:int) : void
      {
         _headerIndex = value;
         dispatchEvent(new ListEvent(ListEvent.CHANGE));
      }
      
      protected function initializeHeaderInfo(a:Array) : Array
      {
         var headerInfo:AdvancedDataGridHeaderInfo = null;
         var newArray:Array = [];
         for(var i:int = 0; i < columns.length; i++)
         {
            headerInfo = new AdvancedDataGridHeaderInfo(columns[i],null,i,0);
            newArray.push(headerInfo);
         }
         return newArray;
      }
      
      override public function get baselinePosition() : Number
      {
         var top:Number = 0;
         if(Boolean(border) && border is IBorder)
         {
            top = Number(IBorder(border).borderMetrics.top);
         }
         return top + measureText(" ").ascent;
      }
      
      protected function drawColumnBackground(s:Sprite, columnIndex:int, color:uint, column:AdvancedDataGridColumn) : void
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
         if(columnIndex >= lockedColumnCount && columnIndex < lockedColumnCount + horizontalScrollPosition)
         {
            return;
         }
         g.beginFill(color);
         var lastRow:Object = rowInfo[listItems.length - 1];
         var headerInfo:AdvancedDataGridHeaderInfo = getHeaderInfo(getOptimumColumns()[columnIndex]);
         var xx:Number = Number(headerInfo.headerItem.x);
         if(columnIndex >= lockedColumnCount)
         {
            xx = getAdjustedXPos(xx);
         }
         var yy:Number = Number(headerRowInfo[0].y);
         if(headerVisible)
         {
            yy += headerRowInfo[0].height;
         }
         var height:Number = Math.min(lastRow.y + lastRow.height,listContent.height - yy);
         g.drawRect(xx,yy,headerInfo.headerItem.width,listContent.height - yy);
         g.endFill();
      }
      
      override protected function keyUpHandler(event:KeyboardEvent) : void
      {
         if(isKeyPressed && headerIndex != -1)
         {
            isKeyPressed = false;
            selectedHeaderInfo = getHeaderInfo(columns[headerIndex]);
            selectColumnHeader(headerIndex);
         }
      }
      
      protected function drawSeparators() : void
      {
         var lines:Sprite = getLines();
         lines.graphics.clear();
         var optimumColumns:Array = getOptimumColumns();
         if(headerSepSkinChanged)
         {
            headerSepSkinChanged = false;
            clearSeparators();
         }
         if(!separators)
         {
            separators = [];
            lockedSeparators = [];
         }
         lines = Sprite(listSubContent.getChildByName("lines"));
         var actualLocked:int = 0;
         var allColsLocked:Boolean = false;
         var numUnLockedSeparators:int = Math.max(0,optimumColumns.length - 1);
         var lockedContent:Sprite = getLockedContent();
         var lockedHeaderLines:UIComponent = UIComponent(lockedContent.getChildByName("lockedHeaderLines"));
         var headerLines:UIComponent = UIComponent(lines.getChildByName("header"));
         if(Boolean(optimumColumns) && optimumColumns.length > 0)
         {
            if(lockedColumnCount > 0)
            {
               actualLocked = Math.min(lockedColumnCount,optimumColumns.length);
               allColsLocked = actualLocked == optimumColumns.length;
               if(allColsLocked)
               {
                  actualLocked--;
               }
               numUnLockedSeparators -= actualLocked;
               if(!allColsLocked)
               {
                  numUnLockedSeparators++;
               }
               if(!lockedHeaderLines)
               {
                  lockedHeaderLines = new UIComponent();
                  lockedHeaderLines.name = "lockedHeaderLines";
                  lockedContent.addChild(lockedHeaderLines);
               }
            }
            if(Boolean(lockedHeaderLines))
            {
               createHeaderSeparators(actualLocked,lockedSeparators,lockedHeaderLines);
            }
            if(!headerLines)
            {
               headerLines = new UIComponent();
               headerLines.name = "header";
               lines.addChild(headerLines);
            }
            createHeaderSeparators(numUnLockedSeparators,separators,headerLines);
         }
         if(Boolean(lockedHeaderLines))
         {
            removeExtraSeparators(actualLocked,lockedSeparators,lockedHeaderLines);
         }
         if(Boolean(headerLines))
         {
            removeExtraSeparators(numUnLockedSeparators,separators,headerLines);
         }
      }
      
      private function findHeaderRenderer(pt:Point) : IListItemRenderer
      {
         var r:IListItemRenderer = null;
         var yy:Number = NaN;
         var ww:Number = NaN;
         var m:int = 0;
         var n:int = 0;
         var optimumColumns:Array = null;
         var i:int = 0;
         var j:int = 0;
         yy = 0;
         ww = 0;
         m = 0;
         n = int(headerItems.length);
         optimumColumns = getOptimumColumns();
         for(i = 0; i < n; i++)
         {
            if(Boolean(headerItems[i].length))
            {
               if(pt.y < yy + headerRowInfo[i].height)
               {
                  m = int(headerItems[i].length);
                  if(m == 1)
                  {
                     r = headerItems[i][0];
                     break;
                  }
                  ww = 0;
                  for(j = 0; j < lockedColumnCount; j++)
                  {
                     ww += optimumColumns[j].width;
                     if(pt.x < ww)
                     {
                        r = headerItems[i][j];
                        break;
                     }
                  }
                  if(Boolean(r))
                  {
                     break;
                  }
                  for(j = lockedColumnCount + horizontalScrollPosition; j < m; j++)
                  {
                     ww += optimumColumns[j].width;
                     if(pt.x < ww)
                     {
                        r = headerItems[i][j];
                        break;
                     }
                  }
               }
            }
            yy += headerRowInfo[i].height;
         }
         return r;
      }
      
      private function getLinesBody(lines:Sprite, linesBodyName:String) : Sprite
      {
         var linesBody:Sprite = Sprite(lines.getChildByName(linesBodyName));
         if(!linesBody)
         {
            linesBody = new UIComponent();
            linesBody.name = linesBodyName;
            lines.addChild(linesBody);
         }
         return linesBody;
      }
      
      protected function selectColumnHeader(columnNumber:int) : void
      {
         var visibleColumnNumber:int = 0;
         var i:int = 0;
         var s:Sprite = null;
         var r:IListItemRenderer = null;
         var g:Graphics = null;
         visibleColumnNumber = -1;
         for(i = 0; i < visibleColumns.length; i++)
         {
            if(visibleColumns[i].colNum == columnNumber)
            {
               visibleColumnNumber = i;
               break;
            }
         }
         if(visibleColumnNumber == -1)
         {
            visibleColumnNumber = 0;
            headerIndex = visibleColumns[0].colNum;
         }
         s = Sprite(selectionLayer.getChildByName("headerKeyboardSelection"));
         if(!s)
         {
            s = new FlexSprite();
            s.name = "headerKeyboardSelection";
            selectionLayer.addChild(s);
         }
         r = selectedHeaderInfo.headerItem;
         if(Boolean(r))
         {
            g = s.graphics;
            g.clear();
            g.beginFill(isPressed || isKeyPressed ? uint(getStyle("selectionColor")) : uint(getStyle("rollOverColor")));
            g.drawRect(0,0,visibleColumns[visibleColumnNumber].width,r.height + cachedPaddingTop + cachedPaddingBottom - 0.5);
            g.endFill();
            s.x = getAdjustedXPos(r.x);
            s.y = r.y - cachedPaddingTop;
            caretIndex = -1;
            isPressed = false;
            selectItem(selectedHeaderInfo.headerItem,false,false);
         }
      }
      
      protected function calculateHeaderHeight() : Number
      {
         var item:IListItemRenderer = null;
         var c:AdvancedDataGridColumn = null;
         var rowData:AdvancedDataGridListData = null;
         var n:int = 0;
         var j:int = 0;
         if(!columns.length)
         {
            return rowHeight;
         }
         var ch:Number = 0;
         var paddingTop:Number = Number(getStyle("paddingTop"));
         var paddingBottom:Number = Number(getStyle("paddingBottom"));
         if(!measuringObjects)
         {
            measuringObjects = new Dictionary(false);
         }
         if(headerVisible)
         {
            ch = 0;
            n = int(columns.length);
            if(_headerWordWrapPresent)
            {
               _headerHeight = _originalHeaderHeight;
               _explicitHeaderHeight = _originalExplicitHeaderHeight;
            }
            for(j = 0; j < n; j++)
            {
               c = columns[j];
               if(c.visible)
               {
                  item = getMeasuringRenderer(c,true,null);
                  rowData = AdvancedDataGridListData(makeListData(c,uid,0,c.colNum,c));
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
                     _headerWordWrapPresent = true;
                  }
               }
            }
            if(_headerWordWrapPresent)
            {
               _originalHeaderHeight = _headerHeight;
               _originalExplicitHeaderHeight = _explicitHeaderHeight;
               headerHeight = ch;
            }
         }
         return ch;
      }
      
      protected function drawHorizontalLine(s:Sprite, rowIndex:int, color:uint, y:Number) : void
      {
         var g:Graphics = s.graphics;
         if(lockedRowCount > 0 && rowIndex == lockedRowCount - 1)
         {
            g.lineStyle(1,0);
         }
         else
         {
            g.lineStyle(1,color);
         }
         g.moveTo(0,y);
         g.lineTo(displayWidth,y);
      }
      
      override public function itemToLabel(data:Object) : String
      {
         return displayableColumns[sortIndex == -1 ? 0 : sortIndex].itemToLabel(data);
      }
      
      protected function drawVerticalSeparators() : void
      {
         var childIndex:int = 0;
         var i:int = 0;
         var lockedColCount:int = 0;
         var headerInfo:AdvancedDataGridHeaderInfo = null;
         var lines:Sprite = getLines();
         var lockedContent:Sprite = getLockedContent();
         var lockedLinesBody:Sprite = Sprite(lockedContent.getChildByName("lockedVerticalLines"));
         if(!lockedLinesBody)
         {
            lockedLinesBody = new UIComponent();
            lockedLinesBody.name = "lockedVerticalLines";
            lockedContent.addChild(lockedLinesBody);
         }
         var child:UIComponent = UIComponent(lockedContent.getChildByName("lockedHeaderLines"));
         if(Boolean(child))
         {
            childIndex = lockedContent.getChildIndex(DisplayObject(child));
            if(childIndex > lockedContent.getChildIndex(DisplayObject(lockedLinesBody)))
            {
               lockedContent.setChildIndex(lockedLinesBody,childIndex);
            }
         }
         lockedLinesBody.graphics.clear();
         while(Boolean(lockedLinesBody.numChildren))
         {
            lockedLinesBody.removeChildAt(0);
         }
         var yVal:Number = Boolean(headerVisible) && Boolean(headerRowInfo) && Boolean(headerRowInfo[0]) ? Number(headerRowInfo[0].height) : 0;
         var len:uint = Math.min(Boolean(visibleColumns) ? visibleColumns.length : 0,Math.max(0,lockedColumnCount));
         var vLines:Boolean = Boolean(getStyle("verticalGridLines"));
         var lineCol:uint = uint(getStyle("verticalGridLineColor"));
         if(vLines && Boolean(len))
         {
            for(i = 0; i < len; i++)
            {
               drawVerticalSeparator(lockedLinesBody,i,lineCol,getHeaderInfo(visibleColumns[i]).headerItem.x + visibleColumns[i].width,yVal);
            }
         }
         var linesBody:Sprite = getLinesBody(lines,"verticalLines");
         linesBody.graphics.clear();
         while(Boolean(linesBody.numChildren))
         {
            linesBody.removeChildAt(0);
         }
         len = visibleColumns.length;
         if(len > visibleColumns.length)
         {
            len = visibleColumns.length;
         }
         vLines = Boolean(getStyle("verticalGridLines"));
         lineCol = uint(getStyle("verticalGridLineColor"));
         if(Boolean(vLines && headerInfos) && Boolean(hasHeaderItemsCreated(0)) && hasHeaderItemsCreated(len - 1))
         {
            lockedColCount = Math.max(0,lockedColumnCount);
            for(i = lockedColCount; i < len - 1; i++)
            {
               headerInfo = getHeaderInfo(visibleColumns[i]);
               drawVerticalSeparator(linesBody,absoluteToVisibleColumnIndex(visibleColumns[i].colNum),lineCol,headerInfo.headerItem.x + visibleColumns[i].width,yVal);
            }
         }
         if(!vLines && lockedColumnCount > 0 && lockedColumnCount < len)
         {
            drawVerticalSeparator(linesBody,lockedColumnCount - 1,lineCol,getHeaderInfo(visibleColumns[lockedColumnCount - 1]).headerItem.x + visibleColumns[lockedColumnCount - 1].width,0);
         }
      }
      
      protected function isColumnFullyVisible(columnIndex:int, rowIndex:int = -1) : Boolean
      {
         var visibleCoords:Object = null;
         var visibleRowIndex:int = 0;
         var visibleColIndex:int = 0;
         var isFullyVisible:Boolean = false;
         var adjustedX:Number = NaN;
         if(rowIndex == -1)
         {
            rowIndex = verticalScrollPosition;
         }
         visibleCoords = absoluteToVisibleIndices(rowIndex,columnIndex);
         visibleRowIndex = int(visibleCoords.rowIndex);
         visibleColIndex = int(visibleCoords.columnIndex);
         if(visibleRowIndex < 0)
         {
            return false;
         }
         isFullyVisible = visibleColIndex != -1;
         if(isFullyVisible)
         {
            if(listItems.length >= 1 && visibleColumns.length >= 1)
            {
               adjustedX = Number(listItems[visibleRowIndex][visibleColIndex].x);
               if(getOptimumColumns() == displayableColumns && visibleColIndex > lockedColumnCount)
               {
                  adjustedX = getAdjustedXPos(adjustedX);
               }
               if(adjustedX + listItems[visibleRowIndex][visibleColIndex].width > listContent.width)
               {
                  isFullyVisible = false;
               }
            }
         }
         return isFullyVisible;
      }
      
      protected function getPossibleDropPositions(val:AdvancedDataGridColumn) : Array
      {
         var n:int = Boolean(visibleColumns) ? int(visibleColumns.length) : 0;
         var dropPositions:Array = [];
         for(var i:int = 0; i < n; i++)
         {
            dropPositions.push(getHeaderInfo(visibleColumns[i]));
         }
         return dropPositions;
      }
      
      override protected function mouseOutHandler(event:MouseEvent) : void
      {
         var r:IListItemRenderer = null;
         var n:int = 0;
         var headerItem:IListItemRenderer = null;
         var i:int = 0;
         var s:Sprite = null;
         if(Boolean(movingColumn))
         {
            return;
         }
         var optimumColumns:Array = getOptimumColumns();
         if(enabled && headerVisible && Boolean(listItems.length))
         {
            r = mouseEventToItemRenderer(event);
            if(!r)
            {
               n = int(optimumColumns.length);
               for(i = 0; i < n; i++)
               {
                  if(optimumColumns[i].colNum == sortIndex)
                  {
                     r = getHeaderInfo(optimumColumns[i]).headerItem;
                  }
               }
            }
            n = int(orderedHeadersList.length);
            i = 0;
            while(i < n && Boolean(r))
            {
               headerItem = orderedHeadersList[i].headerItem;
               if(headerItem == r)
               {
                  if(Boolean(orderedHeadersList[i].column.sortable))
                  {
                     s = Sprite(selectionLayer.getChildByName("headerSelection"));
                     if(Boolean(s))
                     {
                        selectionLayer.removeChild(s);
                     }
                  }
                  return;
               }
               i++;
            }
         }
         if(event.buttonDown)
         {
            lastItemDown = r;
         }
         else
         {
            lastItemDown = null;
         }
         super.mouseOutHandler(event);
      }
      
      override protected function configureScrollBars() : void
      {
         var vScrollProperties:Array = null;
         var hScrollProperties:Array = null;
         var oldHorizontalScrollBar:Object = horizontalScrollBar;
         var oldVerticalScrollBar:Object = verticalScrollBar;
         var rowCount:int = int(listItems.length);
         if(rowCount + headerItems.length == 0)
         {
            if(Boolean(oldHorizontalScrollBar) || Boolean(oldVerticalScrollBar))
            {
               setScrollBarProperties(0,0,0,0);
            }
            return;
         }
         if(rowCount > 1 && rowInfo[rowCount - 1].y + rowInfo[rowCount - 1].height > listContent.height)
         {
            rowCount--;
         }
         var offset:int = verticalScrollPosition - lockedRowCount;
         var fillerRows:int = 0;
         while(Boolean(rowCount) && listItems[rowCount - 1].length == 0)
         {
            if(!(Boolean(collection) && rowCount + offset >= collection.length))
            {
               break;
            }
            rowCount--;
            fillerRows++;
         }
         if(verticalScrollPosition > 0 && fillerRows > 0)
         {
            if(adjustVerticalScrollPositionDownward(Math.max(rowCount,1)))
            {
               return;
            }
         }
         vScrollProperties = [Boolean(collection) ? collection.length - lockedRowCount : 0,Math.max(rowCount - lockedRowCount,1)];
         var colCount:int = int(visibleColumns.length);
         var lastHeaderInfo:AdvancedDataGridHeaderInfo = getHeaderInfo(visibleColumns[visibleColumns.length - 1]);
         var headerPosX:int = int(lastHeaderInfo.headerItem.x);
         if(visibleColumns.length - 1 > lockedColumnCount)
         {
            headerPosX = getAdjustedXPos(headerPosX);
         }
         if(colCount > 1 && visibleColumns[colCount - 1] == displayableColumns[displayableColumns.length - 1] && headerPosX + visibleColumns[colCount - 1].width > displayWidth)
         {
            colCount--;
         }
         hScrollProperties = [displayableColumns.length - lockedColumnCount,Math.max(colCount - lockedColumnCount,1)];
         setScrollBarProperties(hScrollProperties[0],hScrollProperties[1],vScrollProperties[0],vScrollProperties[1]);
         if((Boolean(!verticalScrollBar || !verticalScrollBar.visible)) && Boolean(collection) && collection.length - lockedRowCount > rowCount - lockedRowCount)
         {
            maxVerticalScrollPosition = collection.length - lockedRowCount - (rowCount - lockedRowCount);
         }
         if((!horizontalScrollBar || !horizontalScrollBar.visible) && displayableColumns.length - lockedColumnCount > colCount - lockedColumnCount)
         {
            maxHorizontalScrollPosition = displayableColumns.length - lockedColumnCount - (colCount - lockedColumnCount);
         }
      }
      
      override public function set horizontalScrollPosition(value:Number) : void
      {
         var bookmark:CursorBookmark = null;
         if(!initialized || listItems.length == 0)
         {
            super.horizontalScrollPosition = value;
            return;
         }
         var oldValue:int = super.horizontalScrollPosition;
         super.horizontalScrollPosition = value;
         columnsInvalid = true;
         calculateColumnSizes();
         if(itemsSizeChanged)
         {
            return;
         }
         if(oldValue != value)
         {
            removeClipMask();
            if(getOptimumColumns() == visibleColumns)
            {
               visibleData = {};
               scrollAreaChanged = true;
               if(Boolean(iterator))
               {
                  bookmark = iterator.bookmark;
               }
               makeRowsAndColumns(0,0,listContent.width,listContent.height,0,0);
               if(Boolean(iterator) && Boolean(bookmark))
               {
                  iterator.seek(bookmark,0);
               }
            }
            else
            {
               subContentScrolled = true;
            }
            updateSubContent();
            updateHeaderSearchList();
            addClipMask(false);
            invalidateDisplayList();
         }
      }
      
      override protected function mouseWheelHandler(event:MouseEvent) : void
      {
         if(Boolean(itemEditorInstance))
         {
            endEdit(AdvancedDataGridEventReason.OTHER);
         }
         super.mouseWheelHandler(event);
      }
      
      public function set minColumnWidth(value:Number) : void
      {
         _minColumnWidth = value;
         minColumnWidthInvalid = true;
         itemsSizeChanged = true;
         columnsInvalid = true;
         invalidateDisplayList();
      }
      
      override public function set focusPane(value:Sprite) : void
      {
         super.focusPane = value;
         if(Boolean(value))
         {
            value.scrollRect = Boolean(listSubContent) ? listSubContent.scrollRect : null;
         }
         if(!value && Boolean(_focusPane))
         {
            _focusPane.mask = null;
         }
         _focusPane = value;
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
         if(Boolean(itemEditorInstance))
         {
            endEdit(AdvancedDataGridEventReason.OTHER);
         }
      }
      
      private function loseFocus() : void
      {
         setEditedItemPosition(null);
         losingFocus = true;
         setFocus();
      }
      
      public function set editable(value:String) : void
      {
         _editable = "";
         if(!value)
         {
            return;
         }
         var editableFlags:Array = value.split(" ");
         var n:int = int(editableFlags.length);
         var keepProcessingFlags:Boolean = true;
         var i:int = 0;
         while(i < n && keepProcessingFlags)
         {
            switch(editableFlags[i])
            {
               case "item":
               case "group":
               case "summary":
                  _editable += editableFlags[i] + " ";
                  break;
               case "true":
                  _editable = "item" + " ";
                  keepProcessingFlags = false;
                  break;
               case "false":
                  _editable = "" + " ";
                  keepProcessingFlags = false;
                  break;
               case "all":
                  _editable = "item group summary" + " ";
                  keepProcessingFlags = false;
            }
            i++;
         }
         _editable = _editable.slice(0,-1);
      }
      
      public function getFieldSortInfo(column:AdvancedDataGridColumn) : SortInfo
      {
         var colUID:String = null;
         var n:int = 0;
         var i:int = 0;
         if(Boolean(column) && Boolean(collection) && Boolean(collection.sort))
         {
            if(!column.dataField)
            {
               colUID = itemToUID(column);
            }
            n = int(collection.sort.fields.length);
            for(i = 0; i < n; i++)
            {
               if(Boolean(column.dataField) && Boolean(collection.sort.fields[i].name == column.dataField) || Boolean(colUID) && Boolean(collection.sort.fields[i].name == colUID))
               {
                  return new SortInfo(i + 1,collection.sort.fields[i].descending);
               }
            }
         }
         return null;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getHeaderInfo(col:AdvancedDataGridColumn) : AdvancedDataGridHeaderInfo
      {
         return headerInfos[col.colNum];
      }
      
      protected function drawHorizontalSeparators() : void
      {
         var i:int = 0;
         var lineCol:uint = uint(getStyle("horizontalGridLineColor"));
         var lockedContent:Sprite = getLockedContent();
         var lockedLinesBody:Sprite = Sprite(lockedContent.getChildByName("lockedHorizontalLines"));
         if(Boolean(lockedLinesBody))
         {
            lockedLinesBody.graphics.clear();
            while(Boolean(lockedLinesBody.numChildren))
            {
               lockedLinesBody.removeChildAt(0);
            }
         }
         if(Boolean(getStyle("horizontalGridLines")) || lockedRowCount > 0 && lockedRowCount < listItems.length)
         {
            if(!lockedLinesBody)
            {
               lockedLinesBody = new UIComponent();
               lockedLinesBody.name = "lockedHorizontalLines";
               lockedContent.addChild(lockedLinesBody);
            }
            if(Boolean(getStyle("horizontalGridLines")))
            {
               for(i = 0; i < listItems.length; i++)
               {
                  drawHorizontalSeparator(lockedLinesBody,i,lineCol,rowInfo[i].y + rowInfo[i].height);
               }
            }
            else
            {
               drawHorizontalSeparator(lockedLinesBody,lockedRowCount - 1,lineCol,rowInfo[lockedRowCount - 1].y + rowInfo[lockedRowCount - 1].height);
            }
         }
      }
      
      override protected function calculateRowHeight(data:Object, hh:Number, skipVisible:Boolean = false) : Number
      {
         var item:IListItemRenderer = null;
         var c:AdvancedDataGridColumn = null;
         var j:int = 0;
         var n:int = int(columns.length);
         var k:int = 0;
         if(skipVisible && visibleColumns.length == _columns.length)
         {
            return hh;
         }
         var paddingTop:Number = Number(getStyle("paddingTop"));
         var paddingBottom:Number = Number(getStyle("paddingBottom"));
         if(!measuringObjects)
         {
            measuringObjects = new Dictionary(false);
         }
         for(j = 0; j < n; j++)
         {
            if(skipVisible && k < visibleColumns.length && visibleColumns[k].colNum == columns[j].colNum)
            {
               k++;
            }
            else
            {
               c = columns[j];
               if(c.visible)
               {
                  item = getMeasuringRenderer(c,false,data);
                  setupRendererFromData(c,item,data);
                  hh = Math.max(hh,item.getExplicitOrMeasuredHeight() + paddingBottom + paddingTop);
               }
            }
         }
         return hh;
      }
      
      protected function scrollToViewColumn(newColumnIndex:int, columnIndex:int) : void
      {
         var i:int = 0;
         var n:int = 0;
         var newDisplayColumnIndex:int = 0;
         var displayColumnIndex:int = 0;
         var delta:int = 0;
         var newHorizontalScrollPosition:int = 0;
         var scrollEvent:ScrollEvent = null;
         if(newColumnIndex == columnIndex)
         {
            return;
         }
         newDisplayColumnIndex = absoluteToDisplayColumnIndex(newColumnIndex);
         displayColumnIndex = absoluteToDisplayColumnIndex(columnIndex);
         delta = newDisplayColumnIndex - displayColumnIndex;
         newHorizontalScrollPosition = Math.max(0,horizontalScrollPosition + delta);
         if(lockedColumnCount > 0 && columnIndex == lockedColumnCount - 1)
         {
            newHorizontalScrollPosition = 0;
         }
         scrollEvent = new ScrollEvent(ScrollEvent.SCROLL);
         scrollEvent.detail = ScrollEventDetail.THUMB_POSITION;
         scrollEvent.direction = ScrollEventDirection.HORIZONTAL;
         scrollEvent.delta = delta;
         scrollEvent.position = newHorizontalScrollPosition;
         dispatchEvent(scrollEvent);
         horizontalScrollPosition = newHorizontalScrollPosition;
      }
      
      private function generateColumnsPendingResultHandler(data:Object, info:ListBaseSeekPending) : void
      {
         if(columns.length == 0)
         {
            generateCols();
         }
         seekPendingResultHandler(data,info);
      }
      
      protected function getAdjustedXPos(posx:int) : int
      {
         if(Boolean(listSubContent.scrollRect))
         {
            if(listSubContent.x == 0)
            {
               posx -= listSubContent.scrollRect.x;
            }
            else
            {
               posx -= listSubContent.scrollRect.x - listSubContent.x;
            }
         }
         return posx;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getHeaderInfoAt(colIndex:int) : AdvancedDataGridHeaderInfo
      {
         if(Boolean(headerInfos))
         {
            return headerInfos[colIndex];
         }
         return null;
      }
      
      protected function isDraggingAllowed(draggedColumn:AdvancedDataGridColumn) : Boolean
      {
         return true;
      }
      
      override protected function adjustListContent(unscaledWidth:Number = -1, unscaledHeight:Number = -1) : void
      {
         super.adjustListContent(unscaledWidth,unscaledHeight);
         updateSubContent();
      }
      
      protected function isHeaderItemRenderer(item:IListItemRenderer) : Boolean
      {
         var row:int = 0;
         var col:int = 0;
         loop0:
         for(row = 0; row < headerItems.length; )
         {
            col = 0;
            while(true)
            {
               if(col >= headerItems[row].length)
               {
                  row++;
                  continue loop0;
               }
               if(UIDUtil.getUID(headerItems[row][col]) == UIDUtil.getUID(item))
               {
                  break;
               }
               col++;
            }
            return true;
         }
         return false;
      }
      
      protected function absoluteToDisplayColumnIndex(columnIndex:int) : int
      {
         var n:int = 0;
         var i:int = 0;
         n = int(displayableColumns.length);
         for(i = 0; i < n; i++)
         {
            if(displayableColumns[i].colNum == columnIndex)
            {
               return i;
            }
         }
         return -1;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setupRendererFromData(c:AdvancedDataGridColumn, item:IListItemRenderer, data:Object) : void
      {
         var rowData:AdvancedDataGridListData = AdvancedDataGridListData(makeListData(data,itemToUID(data),0,c.colNum,c));
         if(item is IDropInListItemRenderer)
         {
            if(data != null)
            {
               IDropInListItemRenderer(item).listData = makeListData(data,itemToUID(data),0,c.colNum,c);
            }
            else
            {
               IDropInListItemRenderer(item).listData = null;
            }
         }
         item.data = data;
         if(item is IInvalidating)
         {
            IInvalidating(item).invalidateSize();
         }
         item.explicitWidth = getWidthOfItem(item,c,currentColNum);
         UIComponentGlobals.layoutManager.validateClient(item,true);
      }
      
      override public function get itemRenderer() : IFactory
      {
         var fontName:String = null;
         var fontWeight:String = null;
         var fontStyle:String = null;
         var bold:Boolean = false;
         var italic:Boolean = false;
         var flexModuleFactory:IFlexModuleFactory = null;
         if(super.itemRenderer == null)
         {
            fontName = StringUtil.trimArrayElements(getStyle("fontFamily"),",");
            fontWeight = getStyle("fontWeight");
            fontStyle = getStyle("fontStyle");
            bold = fontWeight == "bold";
            italic = fontStyle == "italic";
            flexModuleFactory = getFontContext(fontName,bold,italic);
            super.itemRenderer = new ContextualClassFactory(AdvancedDataGridItemRenderer,flexModuleFactory);
         }
         return super.itemRenderer;
      }
      
      protected function unselectColumnHeader(columnNumber:int, completely:Boolean = false) : void
      {
         var s:Sprite = null;
         s = Sprite(selectionLayer.getChildByName("headerKeyboardSelection"));
         if(Boolean(s))
         {
            selectionLayer.removeChild(s);
         }
         selectedHeaderInfo = null;
         if(completely)
         {
            caretIndex = 0;
            isPressed = false;
            selectItem(listItems[caretIndex][0],false,false);
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function shiftColumns(oldIndex:int, newIndex:int, trigger:Event = null) : void
      {
         var incr:int = 0;
         var i:int = 0;
         var icEvent:IndexChangedEvent = null;
         var j:int = 0;
         var c:AdvancedDataGridColumn = null;
         var cInfo:AdvancedDataGridHeaderInfo = null;
         var groupInfos:Array = headerInfos;
         if(newIndex >= 0 && oldIndex != newIndex)
         {
            incr = oldIndex < newIndex ? 1 : -1;
            for(i = oldIndex; i != newIndex; i += incr)
            {
               j = i + incr;
               c = _columns[i];
               _columns[i] = _columns[j];
               _columns[j] = c;
               _columns[i].colNum = i;
               _columns[j].colNum = j;
               cInfo = groupInfos[i];
               groupInfos[i] = groupInfos[j];
               groupInfos[j] = cInfo;
               groupInfos[i].index -= incr;
               groupInfos[j].index += incr;
            }
            if(sortIndex == oldIndex)
            {
               sortIndex += newIndex - oldIndex;
            }
            else if(oldIndex < sortIndex && sortIndex <= newIndex || newIndex <= sortIndex && sortIndex < oldIndex)
            {
               sortIndex -= incr;
            }
            if(lastSortIndex == oldIndex)
            {
               lastSortIndex += newIndex - oldIndex;
            }
            else if(oldIndex < lastSortIndex && lastSortIndex <= newIndex || newIndex <= lastSortIndex && lastSortIndex < oldIndex)
            {
               lastSortIndex -= incr;
            }
            columnsInvalid = true;
            itemsSizeChanged = true;
            visibleHeaderInfos = updateVisibleHeaders();
            updateHeaderSearchList();
            createDisplayableColumns();
            invalidateDisplayList();
            icEvent = new IndexChangedEvent(IndexChangedEvent.HEADER_SHIFT);
            icEvent.oldIndex = oldIndex;
            icEvent.newIndex = newIndex;
            icEvent.triggerEvent = trigger;
            dispatchEvent(icEvent);
         }
      }
      
      protected function drawHeaderBackground(headerBG:UIComponent) : void
      {
         var bm:EdgeMetrics = null;
         var adjustedWidth:Number = NaN;
         var tot:Number = displayWidth;
         if(verticalScrollBar != null && _horizontalScrollPolicy == ScrollPolicy.OFF && headerVisible)
         {
            bm = borderMetrics;
            adjustedWidth = unscaledWidth - (bm.left + bm.right);
            tot = adjustedWidth;
            maskShape.width = adjustedWidth;
         }
         var hh:Number = Boolean(headerRowInfo.length) ? Number(headerRowInfo[0].height) : headerHeight;
         var g:Graphics = headerBG.graphics;
         g.clear();
         var colors:Array = getStyle("headerColors");
         StyleManager.getColorNames(colors);
         var matrix:Matrix = new Matrix();
         matrix.createGradientBox(tot,hh + 1,Math.PI / 2,0,0);
         colors = [colors[0],colors[0],colors[1]];
         var ratios:Array = [0,60,255];
         var alphas:Array = [1,1,1];
         g.beginGradientFill(GradientType.LINEAR,colors,alphas,ratios,matrix);
         g.lineStyle(0,0,0);
         g.moveTo(0,0);
         g.lineTo(tot,0);
         g.lineTo(tot,hh - 0.5);
         g.lineStyle(0,getStyle("borderColor"),100);
         g.lineTo(0,hh - 0.5);
         g.lineStyle(0,0,0);
         g.endFill();
      }
      
      [Inspectable(environment="none")]
      public function get imeMode() : String
      {
         return _imeMode;
      }
      
      private function mouseFocusChangeHandler(event:MouseEvent) : void
      {
         if(Boolean(itemEditorInstance) && Boolean(!event.isDefaultPrevented()) && itemRendererContains(itemEditorInstance,DisplayObject(event.target)))
         {
            event.preventDefault();
         }
      }
      
      private function findNextEnterItemRenderer(event:KeyboardEvent) : void
      {
         var rowIndex:int = 0;
         var columnIndex:int = 0;
         var newIndex:int = 0;
         var advancedDataGridEvent:AdvancedDataGridEvent = null;
         var newData:* = undefined;
         if(_proposedEditedItemPosition !== undefined)
         {
            return;
         }
         _editedItemPosition = lastEditedItemPosition;
         rowIndex = int(_editedItemPosition.rowIndex);
         columnIndex = int(_editedItemPosition.columnIndex);
         newIndex = rowIndex;
         do
         {
            newIndex += event.shiftKey ? -1 : 1;
            if(!(newIndex < collection.length && newIndex >= 0))
            {
               setEditedItemPosition(null);
               return;
            }
            rowIndex = newIndex;
            newData = rowNumberToData(newIndex);
            if(newData == null)
            {
               setEditedItemPosition(null);
               return;
            }
            if(isDataEditable(newData))
            {
               break;
            }
         }
         while(true);
         advancedDataGridEvent = new AdvancedDataGridEvent(AdvancedDataGridEvent.ITEM_EDIT_BEGINNING,false,true);
         advancedDataGridEvent.columnIndex = columnIndex;
         advancedDataGridEvent.dataField = _columns[columnIndex].dataField;
         advancedDataGridEvent.rowIndex = rowIndex;
         dispatchEvent(advancedDataGridEvent);
      }
      
      protected function displayToAbsoluteColumnIndex(columnIndex:int) : int
      {
         return displayableColumns[columnIndex].colNum;
      }
      
      override protected function mouseUpHandler(event:MouseEvent) : void
      {
         var advancedDataGridEvent:AdvancedDataGridEvent = null;
         var r:IListItemRenderer = null;
         var s:Sprite = null;
         var n:int = 0;
         var i:int = 0;
         var pos:Point = null;
         var c:AdvancedDataGridColumn = null;
         if(!collection || !collection.length)
         {
            return;
         }
         r = mouseEventToItemRenderer(event);
         if(Boolean(enabled && (sortableColumns || draggableColumns) && collection) && Boolean(headerVisible) && hasHeaderItemsCreated())
         {
            n = int(orderedHeadersList.length);
            for(i = 0; i < n; i++)
            {
               if(r == orderedHeadersList[i].headerItem && Boolean(r))
               {
                  c = orderedHeadersList[i].column;
                  if(sortableColumns && c.sortable && lastItemDown == r)
                  {
                     lastItemDown = null;
                     advancedDataGridEvent = new AdvancedDataGridEvent(AdvancedDataGridEvent.HEADER_RELEASE,false,true);
                     if(c.colNum == -1 || isNaN(c.colNum))
                     {
                        advancedDataGridEvent.columnIndex = -1;
                     }
                     else
                     {
                        advancedDataGridEvent.columnIndex = c.colNum;
                     }
                     advancedDataGridEvent.dataField = c.dataField;
                     advancedDataGridEvent.itemRenderer = r;
                     advancedDataGridEvent.triggerEvent = event;
                     if(Object(r).hasOwnProperty("mouseEventToHeaderPart"))
                     {
                        advancedDataGridEvent.headerPart = Object(r).mouseEventToHeaderPart(event);
                     }
                     dispatchEvent(advancedDataGridEvent);
                  }
                  isPressed = false;
                  return;
               }
            }
         }
         if(Boolean(movingColumn))
         {
            return;
         }
         super.mouseUpHandler(event);
         if(Boolean(r && r.data && r != itemEditorInstance && lastItemDown == r) && Boolean(r.visible) && isDataEditable(r.data))
         {
            pos = itemRendererToIndices(r);
            if(Boolean(pos) && Boolean(pos.y >= 0) && Boolean(displayableColumns[pos.x].editable) && !dontEdit)
            {
               advancedDataGridEvent = new AdvancedDataGridEvent(AdvancedDataGridEvent.ITEM_EDIT_BEGINNING,false,true);
               advancedDataGridEvent.columnIndex = displayableColumns[pos.x].colNum;
               advancedDataGridEvent.dataField = displayableColumns[pos.x].dataField;
               advancedDataGridEvent.rowIndex = pos.y;
               advancedDataGridEvent.itemRenderer = r;
               dispatchEvent(advancedDataGridEvent);
            }
         }
         else if(Boolean(lastItemDown) && lastItemDown != itemEditorInstance)
         {
            pos = itemRendererToIndices(lastItemDown);
            if(Boolean(pos && pos.y >= 0) && Boolean(editable) && !dontEdit)
            {
               if(Boolean(displayableColumns[pos.x].editable))
               {
                  advancedDataGridEvent = new AdvancedDataGridEvent(AdvancedDataGridEvent.ITEM_EDIT_BEGINNING,false,true);
                  advancedDataGridEvent.columnIndex = displayableColumns[pos.x].colNum;
                  advancedDataGridEvent.dataField = displayableColumns[pos.x].dataField;
                  advancedDataGridEvent.rowIndex = pos.y;
                  advancedDataGridEvent.itemRenderer = lastItemDown;
                  dispatchEvent(advancedDataGridEvent);
               }
               else
               {
                  lastEditedItemPosition = {
                     "columnIndex":pos.x,
                     "rowIndex":pos.y
                  };
               }
            }
         }
         lastItemDown = null;
      }
      
      override protected function moveSelectionHorizontally(code:uint, shiftKey:Boolean, ctrlKey:Boolean) : void
      {
         var newHorizontalScrollPosition:Number = NaN;
         var maxPosition:int = 0;
         var scrollEvent:ScrollEvent = null;
         var bUpdateHorizontalScrollPosition:Boolean = false;
         if(shiftKey && code == Keyboard.PAGE_UP)
         {
            newHorizontalScrollPosition = Math.max(horizontalScrollPosition - (visibleColumns.length - lockedColumnCount),0);
            if(newHorizontalScrollPosition != horizontalScrollPosition)
            {
               bUpdateHorizontalScrollPosition = true;
            }
         }
         else if(shiftKey && code == Keyboard.PAGE_DOWN)
         {
            maxPosition = Math.min(maxHorizontalScrollPosition,columns.length - 1);
            newHorizontalScrollPosition = Math.min(horizontalScrollPosition + (visibleColumns.length - lockedColumnCount),maxPosition);
            if(newHorizontalScrollPosition != horizontalScrollPosition)
            {
               bUpdateHorizontalScrollPosition = true;
            }
         }
         else
         {
            super.moveSelectionHorizontally(code,shiftKey,ctrlKey);
         }
         if(bUpdateHorizontalScrollPosition)
         {
            scrollEvent = new ScrollEvent(ScrollEvent.SCROLL);
            scrollEvent.detail = ScrollEventDetail.THUMB_POSITION;
            scrollEvent.direction = ScrollEventDirection.HORIZONTAL;
            scrollEvent.delta = newHorizontalScrollPosition - horizontalScrollPosition;
            scrollEvent.position = newHorizontalScrollPosition;
            horizontalScrollPosition = newHorizontalScrollPosition;
            dispatchEvent(scrollEvent);
            if(headerIndex != -1)
            {
               unselectColumnHeader(headerIndex);
            }
         }
      }
      
      override protected function focusOutHandler(event:FocusEvent) : void
      {
         if(event.target == this)
         {
            super.focusOutHandler(event);
         }
         if(event.relatedObject == this && itemRendererContains(itemEditorInstance,DisplayObject(event.target)))
         {
            return;
         }
         if(event.relatedObject == null && itemRendererContains(editedItemRenderer,DisplayObject(event.target)))
         {
            return;
         }
         if(event.relatedObject == null && itemRendererContains(itemEditorInstance,DisplayObject(event.target)))
         {
            return;
         }
         if(Boolean(itemEditorInstance) && (!event.relatedObject || !itemRendererContains(itemEditorInstance,event.relatedObject)))
         {
            endEdit(AdvancedDataGridEventReason.OTHER);
            removeEventListener(FocusEvent.KEY_FOCUS_CHANGE,keyFocusChangeHandler);
            removeEventListener(MouseEvent.MOUSE_DOWN,mouseFocusChangeHandler);
         }
      }
      
      protected function invalidateRenderer(renderer:IListItemRenderer) : void
      {
         var i:IInvalidating = renderer as IInvalidating;
         if(Boolean(i))
         {
            i.invalidateProperties();
            i.invalidateSize();
            i.invalidateDisplayList();
         }
      }
      
      public function set draggableColumns(value:Boolean) : void
      {
         _draggableColumns = value;
      }
      
      private function drawHeaderBackgroundSkin(headerBGSkin:IFlexDisplayObject) : void
      {
         var bm:EdgeMetrics = null;
         var adjustedWidth:Number = NaN;
         var tot:Number = displayWidth;
         if(verticalScrollBar != null && _horizontalScrollPolicy == ScrollPolicy.OFF && headerVisible)
         {
            bm = borderMetrics;
            adjustedWidth = unscaledWidth - (bm.left + bm.right);
            tot = adjustedWidth;
            maskShape.width = adjustedWidth;
         }
         var hh:Number = Boolean(headerRowInfo.length) ? Number(headerRowInfo[0].height) : headerHeight;
         headerBGSkin.setActualSize(tot,hh);
      }
      
      private function measureItems() : void
      {
         var paddingTop:Number = NaN;
         var paddingBottom:Number = NaN;
         var data:Object = null;
         var item:IListItemRenderer = null;
         var c:AdvancedDataGridColumn = null;
         var ch:Number = NaN;
         var n:int = 0;
         var j:int = 0;
         if(itemsNeedMeasurement)
         {
            itemsNeedMeasurement = false;
            if(isNaN(explicitRowHeight))
            {
               if(Boolean(iterator) && columns.length > 0)
               {
                  if(!measuringObjects)
                  {
                     measuringObjects = new Dictionary(false);
                  }
                  visibleColumns = columns;
                  columnsInvalid = true;
                  paddingTop = Number(getStyle("paddingTop"));
                  paddingBottom = Number(getStyle("paddingBottom"));
                  data = iterator.current;
                  ch = 0;
                  n = int(columns.length);
                  for(j = 0; j < n; j++)
                  {
                     c = columns[j];
                     if(c.visible)
                     {
                        item = getMeasuringRenderer(c,false,data);
                        setupRendererFromData(c,item,data);
                        ch = Math.max(ch,item.getExplicitOrMeasuredHeight() + paddingBottom + paddingTop);
                     }
                  }
                  setRowHeight(Math.max(ch,20));
               }
               else
               {
                  setRowHeight(20);
               }
            }
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function resizeColumn(col:int, w:Number) : void
      {
         var n:int = 0;
         var i:int = 0;
         var totalSpace:Number = NaN;
         var lastColumn:AdvancedDataGridColumn = null;
         var newWidth:Number = NaN;
         var optimumColumns:Array = null;
         var newTotalSpace:Number = NaN;
         var totX:Number = NaN;
         if(!visibleColumns || visibleColumns.length == 0)
         {
            columns[col].setWidth(w);
            columns[col].preferredWidth = w;
            return;
         }
         if(w < columns[col].minWidth)
         {
            w = Number(columns[col].minWidth);
         }
         if(_horizontalScrollPolicy == ScrollPolicy.ON || _horizontalScrollPolicy == ScrollPolicy.AUTO)
         {
            columns[col].setWidth(w);
            columns[col].explicitWidth = w;
            columns[col].preferredWidth = w;
            columnsInvalid = true;
         }
         else
         {
            n = int(visibleColumns.length);
            for(i = 0; i < n; i++)
            {
               if(col == visibleColumns[i].colNum)
               {
                  break;
               }
            }
            if(i >= visibleColumns.length)
            {
               return;
            }
            col = i;
            totalSpace = 0;
            optimumColumns = getOptimumColumns();
            for(i = col + 1; i < n; i++)
            {
               if(Boolean(optimumColumns[i].resizable))
               {
                  totalSpace += visibleColumns[i].width;
               }
            }
            newTotalSpace = optimumColumns[col].width - w + totalSpace;
            if(Boolean(totalSpace))
            {
               optimumColumns[col].setWidth(w);
               optimumColumns[col].explicitWidth = w;
            }
            totX = 0;
            for(i = col + 1; i < n; i++)
            {
               if(Boolean(optimumColumns[i].resizable))
               {
                  newWidth = Math.floor(visibleColumns[i].width * newTotalSpace / totalSpace);
                  if(newWidth < visibleColumns[i].minWidth)
                  {
                     newWidth = Number(visibleColumns[i].minWidth);
                  }
                  optimumColumns[i].setWidth(newWidth);
                  totX += optimumColumns[i].width;
                  lastColumn = optimumColumns[i];
               }
            }
            if(totX > newTotalSpace)
            {
               newWidth = optimumColumns[col].width - totX + newTotalSpace;
               if(newWidth < optimumColumns[col].minWidth)
               {
                  newWidth = Number(optimumColumns[col].minWidth);
               }
               optimumColumns[col].setWidth(newWidth);
            }
            else if(Boolean(lastColumn))
            {
               lastColumn.setWidth(lastColumn.width - totX + newTotalSpace);
            }
         }
         itemsSizeChanged = true;
         updateSubContent();
         invalidateDisplayList();
      }
      
      [Inspectable(enumeration="true,false",defaultValue="false")]
      public function get sortExpertMode() : Boolean
      {
         return _sortExpertMode;
      }
      
      protected function headerReleaseHandler(event:AdvancedDataGridEvent) : void
      {
         var advancedDataGridEvent:AdvancedDataGridEvent = null;
         var mouseEvent:MouseEvent = null;
         if(!event.isDefaultPrevented())
         {
            if(Boolean(itemEditorInstance))
            {
               endEdit(AdvancedDataGridEventReason.OTHER);
            }
            advancedDataGridEvent = new AdvancedDataGridEvent(AdvancedDataGridEvent.SORT,false,true);
            advancedDataGridEvent.columnIndex = event.columnIndex;
            advancedDataGridEvent.dataField = event.dataField;
            advancedDataGridEvent.triggerEvent = event.triggerEvent;
            if(Boolean(event.triggerEvent))
            {
               mouseEvent = event.triggerEvent as MouseEvent;
               if(Boolean(mouseEvent))
               {
                  advancedDataGridEvent.multiColumnSort = mouseEvent.ctrlKey;
                  advancedDataGridEvent.removeColumnFromSort = mouseEvent.shiftKey;
               }
            }
            dispatchEvent(advancedDataGridEvent);
         }
      }
      
      protected function layoutItemEditor() : void
      {
      }
      
      private function drawVerticalSeparator(s:Sprite, colIndex:int, color:uint, x:Number, y:Number) : void
      {
         var sepSkin:IFlexDisplayObject = null;
         var lockedSepSkin:IFlexDisplayObject = null;
         var deleteThisSkin:IFlexDisplayObject = null;
         var createThisSkin:IFlexDisplayObject = null;
         var sepSkinClass:Class = null;
         var styleableSkin:ISimpleStyleClient = null;
         var mWidth:Number = NaN;
         var useLockedSeparator:Boolean = false;
         if(lockedColumnCount > 0 && colIndex == lockedColumnCount - 1)
         {
            useLockedSeparator = true;
         }
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
            createThisSkin.setActualSize(mWidth,listContent.height);
            createThisSkin.move(x,y);
         }
         else
         {
            drawVerticalLine(s,colIndex,color,x);
         }
      }
      
      protected function viewDisplayableColumnAtOffset(columnIndex:int, offset:int, rowIndex:int = -1, scroll:Boolean = true) : int
      {
         var displayColumnIndex:int = 0;
         var n:int = 0;
         var newDisplayColumnIndex:int = 0;
         var newAbsoluteColumnIndex:int = 0;
         var visibleCoord:Object = null;
         var listItem:IListItemRenderer = null;
         displayColumnIndex = absoluteToDisplayColumnIndex(columnIndex);
         if(displayColumnIndex == -1)
         {
            return -1;
         }
         n = int(displayableColumns.length);
         newDisplayColumnIndex = displayColumnIndex + offset;
         while(true)
         {
            if(!(newDisplayColumnIndex >= 0 && newDisplayColumnIndex <= n - 1))
            {
               return -1;
            }
            if(rowIndex <= -1)
            {
               break;
            }
            visibleCoord = absoluteToVisibleIndices(rowIndex,displayToAbsoluteColumnIndex(newDisplayColumnIndex));
            if(Boolean(listItems[visibleCoord.rowIndex]))
            {
               listItem = listItems[visibleCoord.rowIndex][visibleCoord.columnIndex];
            }
            if(!(Boolean(listItem) && !listItem.visible))
            {
               break;
            }
            newDisplayColumnIndex += offset;
         }
         newAbsoluteColumnIndex = displayToAbsoluteColumnIndex(newDisplayColumnIndex);
         if(newAbsoluteColumnIndex < 0 || newAbsoluteColumnIndex > columns.length - 1)
         {
            return -1;
         }
         if(scroll)
         {
            if(!isColumnFullyVisible(newAbsoluteColumnIndex))
            {
               scrollToViewColumn(newAbsoluteColumnIndex,columnIndex);
            }
         }
         return newAbsoluteColumnIndex;
      }
      
      override protected function drawRowBackgrounds() : void
      {
         var colors:Array = null;
         var rowBGs:Sprite = Sprite(listContent.getChildByName("rowBGs"));
         if(!rowBGs)
         {
            rowBGs = new FlexSprite();
            rowBGs.mouseEnabled = false;
            rowBGs.name = "rowBGs";
            listContent.addChildAt(rowBGs,0);
         }
         colors = getStyle("alternatingItemColors");
         if(!colors || colors.length == 0)
         {
            return;
         }
         StyleManager.getColorNames(colors);
         var curRow:int = 0;
         var i:int = 0;
         var actualRow:int = verticalScrollPosition;
         var actualLockedRow:int = 0;
         var n:int = int(listItems.length);
         while(curRow < lockedRowCount && curRow < n)
         {
            drawRowBackground(rowBGs,i++,rowInfo[curRow].y,rowInfo[curRow].height,colors[actualLockedRow % colors.length],actualLockedRow);
            curRow++;
            actualLockedRow++;
            actualRow++;
         }
         while(curRow < n)
         {
            drawRowBackground(rowBGs,i++,rowInfo[curRow].y,rowInfo[curRow].height,colors[actualRow % colors.length],actualRow);
            curRow++;
            actualRow++;
         }
         while(rowBGs.numChildren > i)
         {
            rowBGs.removeChildAt(rowBGs.numChildren - 1);
         }
      }
      
      protected function columnDraggingMouseMoveHandler(event:MouseEvent) : void
      {
         var item:IListItemRenderer = null;
         var s:Sprite = null;
         var n:int = 0;
         var headerInfo:AdvancedDataGridHeaderInfo = null;
         var proxy:IListItemRenderer = null;
         var rowData:AdvancedDataGridListData = null;
         var h:Number = NaN;
         var w:Number = NaN;
         var x:Number = NaN;
         var vm:EdgeMetrics = null;
         var lockedWidth:Number = NaN;
         var lastLockedInfo:AdvancedDataGridHeaderInfo = null;
         var g:Graphics = null;
         var bm:EdgeMetrics = null;
         var dropIndicatorClass:Class = null;
         var advancedDataGridEvent:AdvancedDataGridEvent = null;
         var movingColumnInfo:AdvancedDataGridHeaderInfo = null;
         if(!event.buttonDown)
         {
            columnDraggingMouseUpHandler(event);
            return;
         }
         var c:AdvancedDataGridColumn = movingColumn;
         var i:int = 0;
         if(isNaN(startX))
         {
            startX = event.stageX;
            lastItemDown = null;
            proxy = columnItemRenderer(c,true,null);
            proxy.name = "headerDragProxy";
            rowData = AdvancedDataGridListData(makeListData(c,null,0,c.colNum,c));
            if(proxy is IDropInListItemRenderer)
            {
               IDropInListItemRenderer(proxy).listData = rowData;
            }
            listContent.addChild(DisplayObject(proxy));
            n = int(orderedHeadersList.length);
            for(i = 0; i < n; i++)
            {
               item = orderedHeadersList[i].headerItem;
               if(Boolean(item) && item.data == movingColumn)
               {
                  break;
               }
            }
            h = item.height + cachedPaddingBottom + cachedPaddingTop;
            w = Number(item.getExplicitOrMeasuredWidth());
            x = Number(item.x);
            if(orderedHeadersList[i].actualColNum >= lockedColumnCount)
            {
               x = getAdjustedXPos(item.x);
               if(horizontalScrollPosition > 0 && orderedHeadersList[i].actualColNum - horizontalScrollPosition < lockedColumnCount)
               {
                  lockedWidth = 0;
                  if(lockedColumnCount > 0)
                  {
                     lastLockedInfo = getHeaderInfo(columns[lockedColumnCount - 1]);
                     lockedWidth = lastLockedInfo.headerItem.x + columns[lockedColumnCount - 1].width;
                  }
                  else
                  {
                     lockedWidth = 0;
                  }
                  w -= lockedWidth - x;
                  x = lockedWidth;
               }
            }
            proxy.data = c;
            proxy.styleName = getStyle("headerDragProxyStyleName");
            UIComponentGlobals.layoutManager.validateClient(proxy,true);
            proxy.setActualSize(w,_explicitHeaderHeight ? headerHeight : Number(proxy.getExplicitOrMeasuredHeight()));
            proxy.move(x,item.y);
            s = new FlexSprite();
            s.name = "columnDragOverlay";
            s.alpha = 0.6;
            listContent.addChildAt(s,listContent.getChildIndex(selectionLayer));
            vm = viewMetrics;
            s.x = x;
            s.y = item.y - cachedPaddingTop;
            if(w > 0)
            {
               g = s.graphics;
               g.beginFill(getStyle("disabledColor"));
               g.drawRect(0,0,w,unscaledHeight - vm.bottom - s.y);
               g.endFill();
            }
            s = Sprite(selectionLayer.getChildByName("headerSelection"));
            if(Boolean(s))
            {
               s.width = w;
            }
            if(!listContent.mask)
            {
               bm = borderMetrics;
               listContent.scrollRect = new Rectangle(0,0,unscaledWidth - bm.left - bm.right,unscaledHeight - bm.top - bm.bottom);
            }
            return;
         }
         var deltaX:Number = event.stageX - startX;
         s = Sprite(selectionLayer.getChildByName("headerSelection"));
         if(Boolean(s))
         {
            s.x += deltaX;
         }
         item = IListItemRenderer(listContent.getChildByName("headerDragProxy"));
         if(Boolean(item))
         {
            item.move(item.x + deltaX,item.y);
         }
         startX += deltaX;
         var pt:Point = new Point(event.stageX,event.stageY);
         pt = listContent.globalToLocal(pt);
         lastPt = pt;
         var headerSearchArray:Array = getPossibleDropPositions(movingColumn);
         n = int(headerSearchArray.length);
         var columnXPos:Number = Number(headerSearchArray[0].headerItem.x);
         var ww:Number = columnXPos;
         var notLocked:Boolean = false;
         dropIndexFound = false;
         for(var k:int = 0; k < n; k++)
         {
            headerInfo = headerSearchArray[k];
            if(headerInfo.actualColNum >= lockedColumnCount)
            {
               notLocked = true;
            }
            ww += headerInfo.column.width;
            if(notLocked && headerInfo.actualColNum + headerInfo.columnSpan - horizontalScrollPosition <= lockedColumnCount)
            {
               columnXPos = ww;
            }
            else
            {
               if(notLocked)
               {
                  columnXPos = getAdjustedXPos(columnXPos);
               }
               if(pt.x >= columnXPos && pt.x < columnXPos + headerInfo.column.width)
               {
                  dropIndexFound = true;
                  isHeaderDragOutside = false;
                  if(pt.x > columnXPos + headerInfo.column.width / 2 || notLocked && headerInfo.actualColNum - horizontalScrollPosition < lockedColumnCount)
                  {
                     columnXPos += headerInfo.column.width;
                     k++;
                  }
                  if(dropColumnIndex != k)
                  {
                     dropColumnIndex = k;
                     if(!columnDropIndicator)
                     {
                        dropIndicatorClass = getStyle("columnDropIndicatorSkin");
                        if(!dropIndicatorClass)
                        {
                           dropIndicatorClass = DataGridColumnDropIndicator;
                        }
                        columnDropIndicator = IFlexDisplayObject(new dropIndicatorClass());
                        if(columnDropIndicator is ISimpleStyleClient)
                        {
                           ISimpleStyleClient(columnDropIndicator).styleName = this;
                        }
                        listContent.addChild(DisplayObject(columnDropIndicator));
                     }
                     listContent.setChildIndex(DisplayObject(columnDropIndicator),listContent.numChildren - 1);
                     columnDropIndicator.x = columnXPos - 2;
                     columnDropIndicator.y = item.y;
                     columnDropIndicator.setActualSize(3,listContent.height - item.y);
                  }
                  columnDropIndicator.visible = true;
                  break;
               }
               columnXPos = ww;
            }
         }
         if(!dropIndexFound && isHeaderDragOutside == false)
         {
            isHeaderDragOutside = true;
            advancedDataGridEvent = new AdvancedDataGridEvent(AdvancedDataGridEvent.HEADER_DRAG_OUTSIDE,false,true);
            movingColumnInfo = getHeaderInfo(movingColumn);
            advancedDataGridEvent.column = movingColumn;
            advancedDataGridEvent.columnIndex = -1;
            advancedDataGridEvent.itemRenderer = movingColumnInfo.headerItem;
            advancedDataGridEvent.triggerEvent = event;
            dispatchEvent(advancedDataGridEvent);
         }
      }
      
      protected function absoluteToVisibleColumnIndex(columnIndex:int) : int
      {
         var optimumColumns:Array = null;
         var n:int = 0;
         var i:int = 0;
         optimumColumns = getOptimumColumns();
         n = int(optimumColumns.length);
         for(i = 0; i < n; i++)
         {
            if(optimumColumns[i].colNum == columnIndex)
            {
               return i;
            }
         }
         return -1;
      }
      
      protected function createDisplayableColumns() : void
      {
         var i:int = 0;
         var n:int = 0;
         var k:int = 0;
         displayableColumns = null;
         n = int(_columns.length);
         for(i = 0; i < n; i++)
         {
            if(Boolean(displayableColumns) && Boolean(_columns[i].visible))
            {
               displayableColumns.push(_columns[i]);
            }
            else if(!displayableColumns && !_columns[i].visible)
            {
               displayableColumns = new Array(i);
               for(k = 0; k < i; k++)
               {
                  displayableColumns[k] = _columns[k];
               }
            }
         }
         if(!displayableColumns)
         {
            displayableColumns = _columns;
         }
      }
      
      protected function columnDraggingMouseUpHandler(event:Event) : void
      {
         if(!movingColumn)
         {
            return;
         }
         var origIndex:int = movingColumn.colNum;
         if(dropColumnIndex >= 0)
         {
            if(dropColumnIndex >= visibleColumns.length)
            {
               dropColumnIndex = visibleColumns.length - 1;
            }
            else if(origIndex < visibleColumns[dropColumnIndex].colNum)
            {
               --dropColumnIndex;
            }
            dropColumnIndex = visibleColumns[dropColumnIndex].colNum;
         }
         shiftColumns(origIndex,dropColumnIndex,event as MouseEvent);
         unsetColumnDragParameters();
      }
      
      private function removeExtraSeparators(n:int, seperators:Array, headerLines:UIComponent) : void
      {
         while(headerLines.numChildren > n)
         {
            headerLines.removeChildAt(headerLines.numChildren - 1);
            seperators.pop();
         }
      }
      
      protected function indexToColNum(columnIndex:int) : int
      {
         if(getOptimumColumns() == visibleColumns)
         {
            return visibleToAbsoluteColumnIndex(columnIndex);
         }
         if(getOptimumColumns() == displayableColumns)
         {
            return displayToAbsoluteColumnIndex(columnIndex);
         }
         return -1;
      }
      
      protected function editorKeyDownHandler(event:KeyboardEvent) : void
      {
         if(event.keyCode == Keyboard.ESCAPE)
         {
            endEdit(AdvancedDataGridEventReason.CANCELLED);
         }
         else if(event.ctrlKey && event.charCode == 46)
         {
            endEdit(AdvancedDataGridEventReason.CANCELLED);
         }
         else if(event.charCode == Keyboard.ENTER && event.keyCode != 229)
         {
            if(Boolean(columns[_editedItemPosition.columnIndex].editorUsesEnterKey))
            {
               return;
            }
            if(endEdit(AdvancedDataGridEventReason.NEW_ROW) && !dontEdit)
            {
               findNextEnterItemRenderer(event);
            }
         }
      }
      
      override public function set horizontalScrollPolicy(value:String) : void
      {
         super.horizontalScrollPolicy = value;
         columnsInvalid = true;
         itemsSizeChanged = true;
         invalidateDisplayList();
      }
      
      private function getLines() : Sprite
      {
         var lines:Sprite = Sprite(listSubContent.getChildByName("lines"));
         if(!lines)
         {
            lines = new UIComponent();
            lines.name = "lines";
            lines.cacheAsBitmap = true;
            lines.mouseEnabled = false;
            listSubContent.addChild(lines);
         }
         listSubContent.setChildIndex(lines,listSubContent.numChildren - 1);
         return lines;
      }
      
      private function drawHorizontalSeparator(s:Sprite, rowIndex:int, color:uint, y:Number) : void
      {
         var sepSkin:IFlexDisplayObject = null;
         var lockedSepSkin:IFlexDisplayObject = null;
         var deleteThisSkin:IFlexDisplayObject = null;
         var createThisSkin:IFlexDisplayObject = null;
         var sepSkinClass:Class = null;
         var styleableSkin:ISimpleStyleClient = null;
         var mHeight:Number = NaN;
         var useLockedSeparator:Boolean = false;
         if(lockedRowCount > 0 && rowIndex == lockedRowCount - 1)
         {
            useLockedSeparator = true;
         }
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
            createThisSkin.setActualSize(displayWidth,mHeight);
            createThisSkin.move(0,y);
         }
         else
         {
            drawHorizontalLine(s,rowIndex,color,y);
         }
      }
      
      private function itemEditorItemEditBeginHandler(event:AdvancedDataGridEvent) : void
      {
         var fm:IFocusManager = null;
         if(Boolean(root))
         {
            systemManager.addEventListener(Event.DEACTIVATE,deactivateHandler,false,0,true);
         }
         if(!event.isDefaultPrevented() && listItems[actualRowIndex][actualColIndex].data != null)
         {
            createItemEditor(event.columnIndex,event.rowIndex);
            if(editedItemRenderer is IDropInListItemRenderer && itemEditorInstance is IDropInListItemRenderer)
            {
               IDropInListItemRenderer(itemEditorInstance).listData = IDropInListItemRenderer(editedItemRenderer).listData;
            }
            if(!columns[event.columnIndex].rendererIsEditor)
            {
               itemEditorInstance.data = editedItemRenderer.data;
            }
            if(itemEditorInstance is IInvalidating)
            {
               IInvalidating(itemEditorInstance).validateNow();
            }
            if(itemEditorInstance is IIMESupport)
            {
               IIMESupport(itemEditorInstance).imeMode = columns[event.columnIndex].imeMode == null ? _imeMode : columns[event.columnIndex].imeMode;
            }
            fm = focusManager;
            if(itemEditorInstance is IFocusManagerComponent)
            {
               fm.setFocus(IFocusManagerComponent(itemEditorInstance));
            }
            fm.defaultButtonEnabled = false;
            event = new AdvancedDataGridEvent(AdvancedDataGridEvent.ITEM_FOCUS_IN);
            event.columnIndex = _editedItemPosition.columnIndex;
            event.rowIndex = _editedItemPosition.rowIndex;
            event.itemRenderer = itemEditorInstance;
            dispatchEvent(event);
         }
      }
      
      private function columnResizeMouseUpHandler(event:Event) : void
      {
         var sbRoot:DisplayObject = null;
         var c:AdvancedDataGridColumn = null;
         var vsw:int = 0;
         var mouseEvent:MouseEvent = null;
         var pt:Point = null;
         var separatorWidth:Number = NaN;
         var maxWidth:Number = NaN;
         var widthChange:Number = NaN;
         var advancedDataGridEvent:AdvancedDataGridEvent = null;
         if(!enabled || !resizableColumns)
         {
            return;
         }
         isPressed = false;
         sbRoot = systemManager.getSandboxRoot();
         sbRoot.removeEventListener(MouseEvent.MOUSE_MOVE,columnResizingHandler,true);
         sbRoot.removeEventListener(MouseEvent.MOUSE_UP,columnResizeMouseUpHandler,true);
         sbRoot.removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,columnResizeMouseUpHandler);
         systemManager.deployMouseShields(false);
         listContent.removeChild(DisplayObject(resizeGraphic));
         cursorManager.removeCursor(resizeCursorID);
         c = resizingColumn;
         resizingColumn = null;
         vsw = Boolean(verticalScrollBar) ? int(verticalScrollBar.width) : 0;
         mouseEvent = event as MouseEvent;
         if(Boolean(mouseEvent))
         {
            pt = new Point(mouseEvent.stageX,mouseEvent.stageY);
            pt = listContent.globalToLocal(pt);
         }
         else
         {
            pt = lastPt;
         }
         separatorWidth = 0;
         if(Boolean(lockedSeparators) && lockedSeparators.length > 0)
         {
            separatorWidth = Number(lockedSeparators[0].width);
         }
         else if(Boolean(separators) && separators.length > 0)
         {
            separatorWidth = Number(separators[0].width);
         }
         maxWidth = unscaledWidth - separatorWidth - vsw;
         widthChange = Math.min(Math.max(minX,pt.x),maxWidth) - startX;
         resizeColumn(c.colNum,Math.floor(c.width + widthChange));
         advancedDataGridEvent = new AdvancedDataGridEvent(AdvancedDataGridEvent.COLUMN_STRETCH);
         advancedDataGridEvent.columnIndex = c.colNum;
         advancedDataGridEvent.dataField = c.dataField;
         advancedDataGridEvent.localX = pt.x;
         dispatchEvent(advancedDataGridEvent);
      }
      
      protected function visibleToAbsoluteColumnIndex(columnIndex:int) : int
      {
         var optimumColumns:Array = null;
         optimumColumns = getOptimumColumns();
         return optimumColumns[columnIndex].colNum;
      }
      
      override public function get columnCount() : int
      {
         if(Boolean(_columns))
         {
            return _columns.length;
         }
         return 0;
      }
      
      override protected function measure() : void
      {
         super.measure();
         var o:EdgeMetrics = viewMetrics;
         var n:int = int(columns.length);
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
            if(Boolean(columns[i].visible))
            {
               columnWidths += columns[i].preferredWidth;
               if(isNaN(_minColumnWidth))
               {
                  columnMinWidths += columns[i].minWidth;
               }
            }
         }
         if(!isNaN(_minColumnWidth))
         {
            columnMinWidths = n * _minColumnWidth;
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
      
      private function findNextItemRenderer(shiftKey:Boolean) : Boolean
      {
         var itemRenderer:IListItemRenderer = null;
         var visibleCoords:Object = null;
         var visibleRowIndex:int = 0;
         var visibleColIndex:int = 0;
         var newData:Object = null;
         var reason:String = null;
         var advancedDataGridEvent:AdvancedDataGridEvent = null;
         if(!lastEditedItemPosition)
         {
            return false;
         }
         if(!editable.length)
         {
            loseFocus();
            return false;
         }
         if(_proposedEditedItemPosition !== undefined)
         {
            return false;
         }
         _editedItemPosition = lastEditedItemPosition;
         var index:int = int(_editedItemPosition.rowIndex);
         var colIndex:int = int(_editedItemPosition.columnIndex);
         var found:Boolean = false;
         var incr:int = shiftKey ? -1 : 1;
         var maxIndex:int = collection.length - 1;
         while(!found)
         {
            colIndex += incr;
            if(colIndex >= _columns.length || colIndex < 0)
            {
               colIndex = colIndex < 0 ? int(_columns.length - 1) : 0;
               index += incr;
               if(index > maxIndex || index < 0)
               {
                  loseFocus();
                  return false;
               }
            }
            visibleCoords = absoluteToVisibleIndices(index,colIndex);
            visibleRowIndex = int(visibleCoords.rowIndex);
            visibleColIndex = int(visibleCoords.columnIndex);
            if(visibleColIndex > -1)
            {
               if(visibleRowIndex == listItems.length)
               {
                  visibleRowIndex -= 1;
               }
               else if(visibleRowIndex == -1)
               {
                  visibleRowIndex = 0;
               }
               itemRenderer = null;
               if(Boolean(listItems[visibleRowIndex]) && Boolean(listItems[visibleRowIndex][visibleColIndex]))
               {
                  itemRenderer = listItems[visibleRowIndex][visibleColIndex];
               }
               if(Boolean(itemRenderer) && !itemRenderer.visible)
               {
                  continue;
               }
            }
            newData = rowNumberToData(index);
            if(newData == null)
            {
               return true;
            }
            if(isDataEditable(newData))
            {
               if(Boolean(_columns[colIndex].editable) && Boolean(_columns[colIndex].visible))
               {
                  found = true;
                  reason = index == _editedItemPosition.rowIndex ? AdvancedDataGridEventReason.NEW_COLUMN : AdvancedDataGridEventReason.NEW_ROW;
                  if(!itemEditorInstance || endEdit(reason))
                  {
                     advancedDataGridEvent = new AdvancedDataGridEvent(AdvancedDataGridEvent.ITEM_EDIT_BEGINNING,false,true);
                     advancedDataGridEvent.columnIndex = colIndex;
                     advancedDataGridEvent.dataField = _columns[colIndex].dataField;
                     advancedDataGridEvent.rowIndex = index;
                     dispatchEvent(advancedDataGridEvent);
                  }
               }
            }
         }
         return found;
      }
      
      private function columnResizingHandler(event:MouseEvent) : void
      {
         var vsw:int = 0;
         var pt:Point = null;
         var separatorWidth:Number = NaN;
         var maxWidth:Number = NaN;
         var index:int = 0;
         if(!MouseEvent(event).buttonDown)
         {
            columnResizeMouseUpHandler(event);
            return;
         }
         vsw = Boolean(verticalScrollBar) ? int(verticalScrollBar.width) : 0;
         pt = new Point(event.stageX,event.stageY);
         pt = listContent.globalToLocal(pt);
         lastPt = pt;
         separatorWidth = 0;
         if(Boolean(lockedSeparators) && lockedSeparators.length > 0)
         {
            separatorWidth = Number(lockedSeparators[0].width);
         }
         else if(Boolean(separators) && separators.length > 0)
         {
            separatorWidth = Number(separators[0].width);
         }
         maxWidth = unscaledWidth - separatorWidth - vsw;
         if(getOptimumColumns() == visibleColumns)
         {
            index = absoluteToVisibleColumnIndex(resizingColumn.colNum);
         }
         else
         {
            index = absoluteToDisplayColumnIndex(resizingColumn.colNum);
         }
         resizeGraphic.move(Math.min(Math.max(minX,pt.x),maxWidth),resizeGraphic.y);
      }
      
      override protected function mouseEventToItemRenderer(event:MouseEvent) : IListItemRenderer
      {
         var r:IListItemRenderer = null;
         var pt:Point = null;
         var ww:Number = NaN;
         if(event.target == highlightIndicator || event.target == listContent)
         {
            pt = new Point(event.stageX,event.stageY);
            pt = listContent.globalToLocal(pt);
            ww = 0;
            if(headerVisible)
            {
               r = findHeaderRenderer(pt);
            }
            if(!r && rowInfo.length != 0)
            {
               r = findRenderer(pt,listItems,rowInfo,rowInfo[0].y);
            }
         }
         if(!r)
         {
            r = super.mouseEventToItemRenderer(event);
         }
         return r == itemEditorInstance ? null : r;
      }
      
      protected function drawLinesAndColumnBackgrounds() : void
      {
         var colBGs:Sprite = null;
         var lastChild:int = 0;
         var i:int = 0;
         var col:AdvancedDataGridColumn = null;
         var bgCol:Object = null;
         var background:Shape = null;
         var g:Graphics = null;
         var bg:DisplayObject = null;
         var lines:Sprite = getLines();
         lines.graphics.clear();
         var len:uint = uint(getNumColumns());
         len = len != -1 ? len : visibleColumns.length;
         var optimumColumns:Array = getOptimumColumns();
         if(len > optimumColumns.length)
         {
            len = optimumColumns.length;
         }
         drawHorizontalSeparators();
         drawVerticalSeparators();
         if(Boolean(headerInfos) && Boolean(hasHeaderItemsCreated(0)) && hasHeaderItemsCreated(len - 1))
         {
            colBGs = Sprite(listContent.getChildByName("colBGs"));
            lastChild = -1;
            for(i = 0; i < len; i++)
            {
               col = optimumColumns[i];
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
                     listContent.addChildAt(colBGs,listContent.getChildIndex(listContent.getChildByName("rowBGs")) + 1);
                  }
                  drawColumnBackground(colBGs,i,Number(bgCol),col);
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
      }
      
      protected function getNumColumns() : int
      {
         if(Boolean(headerItems) && Boolean(headerItems[0]))
         {
            return headerItems[0].length;
         }
         return -1;
      }
      
      [Inspectable(category="Data",defaultValue="undefined")]
      override public function set dataProvider(value:Object) : void
      {
         if(Boolean(itemEditorInstance))
         {
            endEdit(AdvancedDataGridEventReason.OTHER);
         }
         lastEditedItemPosition = null;
         super.dataProvider = value;
         invalidateProperties();
      }
      
      override protected function collectionChangeHandler(event:Event) : void
      {
         var ceEvent:CollectionEvent = null;
         var curEditedItemPosition:Object = null;
         var ce:CollectionEvent = null;
         if(iterator == null)
         {
            return;
         }
         if(event is CollectionEvent)
         {
            ceEvent = CollectionEvent(event);
            if(ceEvent.kind == CollectionEventKind.EXPAND)
            {
               event.stopPropagation();
            }
            if(ceEvent.kind == CollectionEventKind.UPDATE)
            {
               event.stopPropagation();
               itemsSizeChanged = true;
               invalidateDisplayList();
            }
            if(ceEvent.kind == CollectionEventKind.RESET)
            {
               if(generatedColumns)
               {
                  generateCols();
               }
               updateSortIndexAndDirection();
            }
            else if(ceEvent.kind == CollectionEventKind.REFRESH && !manualSort)
            {
               updateSortIndexAndDirection();
            }
            else if(ceEvent.kind == CollectionEventKind.REMOVE)
            {
               if(Boolean(editedItemPosition))
               {
                  if(collection.length == 0)
                  {
                     if(Boolean(itemEditorInstance))
                     {
                        endEdit(AdvancedDataGridEventReason.CANCELLED);
                     }
                     setEditedItemPosition(null);
                  }
                  else if(ceEvent.location <= editedItemPosition.rowIndex)
                  {
                     curEditedItemPosition = editedItemPosition;
                     if(ceEvent.location == editedItemPosition.rowIndex && Boolean(itemEditorInstance))
                     {
                        endEdit(AdvancedDataGridEventReason.CANCELLED);
                     }
                     if(inEndEdit)
                     {
                        _editedItemPosition = {
                           "columnIndex":editedItemPosition.columnIndex,
                           "rowIndex":Math.max(0,editedItemPosition.rowIndex - ceEvent.items.length)
                        };
                     }
                     else
                     {
                        setEditedItemPosition({
                           "columnIndex":curEditedItemPosition.columnIndex,
                           "rowIndex":Math.max(0,curEditedItemPosition.rowIndex - ceEvent.items.length)
                        });
                     }
                  }
               }
            }
            else if(ceEvent.kind == CollectionEventKind.REPLACE)
            {
               if(Boolean(editedItemPosition))
               {
                  if(ceEvent.location == editedItemPosition.rowIndex && Boolean(itemEditorInstance))
                  {
                     endEdit(AdvancedDataGridEventReason.CANCELLED);
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
                  if(generatedColumns)
                  {
                     generateCols();
                  }
               }
            }
         }
      }
      
      override protected function calculateDropIndicatorY(rowCount:Number, rowNum:int) : Number
      {
         var i:int = 0;
         var yy:Number = headerVisible ? headerHeight : 0;
         if(Boolean(rowCount) && Boolean(listItems[rowNum].length) && Boolean(listItems[rowNum][0]))
         {
            return listItems[rowNum][0].y - 1;
         }
         for(i = 0; i < rowCount; i++)
         {
            if(!Boolean(listItems[i].length))
            {
               break;
            }
            yy += rowInfo[i].height;
         }
         return yy;
      }
      
      protected function headerNavigationHandler(event:KeyboardEvent) : void
      {
         var newColumnIndex:int = 0;
         var advancedDataGridEvent:AdvancedDataGridEvent = null;
         if(headerIndex == -1)
         {
            return;
         }
         if(event.keyCode == Keyboard.DOWN)
         {
            unselectColumnHeader(headerIndex,true);
            headerIndex = -1;
         }
         else if(event.keyCode == Keyboard.LEFT)
         {
            newColumnIndex = viewDisplayableColumnAtOffset(headerIndex,-1);
            if(newColumnIndex != -1)
            {
               unselectColumnHeader(headerIndex);
               selectedHeaderInfo = getHeaderInfo(columns[newColumnIndex]);
               headerIndex = newColumnIndex;
               selectColumnHeader(headerIndex);
            }
         }
         else if(event.keyCode == Keyboard.RIGHT)
         {
            newColumnIndex = viewDisplayableColumnAtOffset(headerIndex,1);
            if(newColumnIndex != -1)
            {
               unselectColumnHeader(headerIndex);
               selectedHeaderInfo = getHeaderInfo(columns[newColumnIndex]);
               headerIndex = newColumnIndex;
               selectColumnHeader(headerIndex);
            }
         }
         else if(event.keyCode == Keyboard.SPACE)
         {
            if(sortableColumns && Boolean(columns[headerIndex].sortable))
            {
               isKeyPressed = true;
               selectedHeaderInfo = getHeaderInfo(columns[headerIndex]);
               selectColumnHeader(headerIndex);
               advancedDataGridEvent = new AdvancedDataGridEvent(AdvancedDataGridEvent.SORT,false,true);
               advancedDataGridEvent.columnIndex = headerIndex;
               advancedDataGridEvent.dataField = columns[headerIndex].dataField;
               advancedDataGridEvent.multiColumnSort = event.ctrlKey;
               advancedDataGridEvent.removeColumnFromSort = event.shiftKey;
               dispatchEvent(advancedDataGridEvent);
            }
         }
         else if(event.shiftKey && (event.keyCode == Keyboard.PAGE_UP || event.keyCode == Keyboard.PAGE_DOWN))
         {
            moveSelectionHorizontally(event.keyCode,event.shiftKey,event.ctrlKey);
         }
         event.stopPropagation();
      }
      
      public function moveFocusToHeader(columnIndex:int = -1) : void
      {
         if(!headerVisible || headerIndex != -1)
         {
            return;
         }
         if(visibleColumns.length > 0)
         {
            if(columnIndex == -1)
            {
               columnIndex = int(visibleColumns[0].colNum);
            }
            selectedHeaderInfo = getHeaderInfo(columns[columnIndex]);
            headerIndex = columnIndex;
            selectColumnHeader(headerIndex);
         }
      }
      
      [Inspectable(defaultValue="true")]
      public function get draggableColumns() : Boolean
      {
         return _draggableColumns;
      }
      
      private function calculateColumnSizes() : void
      {
         var delta:Number = NaN;
         var n:int = 0;
         var i:int = 0;
         var col:AdvancedDataGridColumn = null;
         var cw:Number = NaN;
         var lastColumn:AdvancedDataGridColumn = null;
         var newSize:Number = NaN;
         var numResizable:int = 0;
         var fixedWidth:Number = NaN;
         var ratio:Number = NaN;
         var newTotal:Number = NaN;
         var minWidth:Number = NaN;
         var totalWidth:Number = 0;
         if(columns.length == 0)
         {
            visibleColumns = [];
            return;
         }
         if(columnsInvalid)
         {
            columnsInvalid = false;
            visibleColumns = [];
            if(minColumnWidthInvalid)
            {
               n = int(columns.length);
               for(i = 0; i < n; i++)
               {
                  columns[i].minWidth = minColumnWidth;
               }
               minColumnWidthInvalid = false;
            }
            if(horizontalScrollPolicy == ScrollPolicy.OFF)
            {
               n = int(displayableColumns.length);
               for(i = 0; i < n; i++)
               {
                  visibleColumns.push(displayableColumns[i]);
               }
            }
            else
            {
               n = int(displayableColumns.length);
               for(i = 0; i < n; i++)
               {
                  if(!(i >= lockedColumnCount && i < lockedColumnCount + horizontalScrollPosition))
                  {
                     col = displayableColumns[i];
                     if(col.preferredWidth < col.minWidth)
                     {
                        col.preferredWidth = col.minWidth;
                     }
                     if(totalWidth >= displayWidth)
                     {
                        if(visibleColumns.length == 0)
                        {
                           visibleColumns.push(displayableColumns[0]);
                        }
                        break;
                     }
                     visibleColumns.push(col);
                     totalWidth += isNaN(col.explicitWidth) ? col.preferredWidth : col.explicitWidth;
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
               if(Boolean(visibleColumns[i].resizable))
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
            newTotal = displayWidth;
            if(displayWidth > fixedWidth && Boolean(numResizable))
            {
               n = int(visibleColumns.length);
               for(i = 0; i < n; i++)
               {
                  if(Boolean(visibleColumns[i].resizable) && isNaN(visibleColumns[i].explicitWidth))
                  {
                     lastColumn = visibleColumns[i];
                     if(totalWidth > displayWidth)
                     {
                        ratio = (lastColumn.width - lastColumn.minWidth) / (totalWidth - fixedWidth);
                     }
                     else
                     {
                        ratio = lastColumn.width / totalWidth;
                     }
                     newSize = lastColumn.width - (totalWidth - displayWidth) * ratio;
                     minWidth = Number(visibleColumns[i].minWidth);
                     visibleColumns[i].setWidth(newSize > minWidth ? newSize : minWidth);
                  }
                  newTotal -= visibleColumns[i].width;
               }
               if(Boolean(newTotal) && Boolean(lastColumn))
               {
                  lastColumn.setWidth(lastColumn.width + newTotal);
               }
            }
            else
            {
               n = int(visibleColumns.length);
               for(i = 0; i < n; i++)
               {
                  lastColumn = visibleColumns[i];
                  ratio = lastColumn.width / totalWidth;
                  newSize = displayWidth * ratio;
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
               if(totalWidth > displayWidth)
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
            if(totalWidth < displayWidth && i < displayableColumns.length)
            {
               n = int(displayableColumns.length);
               while(i < n && totalWidth < displayWidth)
               {
                  col = displayableColumns[i];
                  visibleColumns.push(col);
                  totalWidth += isNaN(col.explicitWidth) ? col.preferredWidth : col.explicitWidth;
                  i++;
               }
            }
            else if(totalWidth < displayWidth && horizontalScrollPosition > 0)
            {
               while(totalWidth < displayWidth && horizontalScrollPosition > 0)
               {
                  col = displayableColumns[lockedColumnCount + horizontalScrollPosition - 1];
                  cw = isNaN(col.explicitWidth) ? col.preferredWidth : col.explicitWidth;
                  if(cw >= displayWidth - totalWidth)
                  {
                     break;
                  }
                  visibleColumns.splice(lockedColumnCount,0,col);
                  var _loc14_:AdvancedDataGridBaseEx = this;
                  var _loc15_:Number = _loc14_.super.horizontalScrollPosition - 1;
                  _loc14_.super.horizontalScrollPosition = _loc15_;
                  totalWidth += cw;
               }
            }
            lastColumn = visibleColumns[visibleColumns.length - 1];
            cw = isNaN(lastColumn.explicitWidth) ? lastColumn.preferredWidth : lastColumn.explicitWidth;
            newSize = cw + displayWidth - totalWidth;
            if(lastColumn == displayableColumns[displayableColumns.length - 1] && lastColumn.resizable && newSize >= lastColumn.minWidth && newSize > cw)
            {
               lastColumn.setWidth(newSize);
               maxHorizontalScrollPosition = displayableColumns.length - visibleColumns.length;
            }
            else if(visibleColumns.length == displayableColumns.length)
            {
               maxHorizontalScrollPosition = 0;
               super.horizontalScrollPosition = 0;
            }
            else if(lockedColumnCount < visibleColumns.length)
            {
               maxHorizontalScrollPosition = displayableColumns.length - visibleColumns.length + 1;
            }
            else
            {
               maxHorizontalScrollPosition = Math.max(0,displayableColumns.length - lockedColumnCount + 1);
               super.horizontalScrollPosition = Math.min(horizontalScrollPosition,maxHorizontalScrollPosition);
            }
         }
      }
      
      private function columnResizeMouseOutHandler(event:MouseEvent) : void
      {
         var target:DisplayObject = null;
         var index:int = 0;
         var optimumColumns:Array = null;
         if(!enabled || !resizableColumns)
         {
            return;
         }
         target = DisplayObject(event.target);
         index = target.parent.getChildIndex(target);
         optimumColumns = getOptimumColumns();
         if(!optimumColumns[index].resizable)
         {
            return;
         }
         cursorManager.removeCursor(resizeCursorID);
      }
      
      private function findRenderer(pt:Point, items:Array, info:Array, yy:Number = 0) : IListItemRenderer
      {
         var r:IListItemRenderer = null;
         var ww:Number = NaN;
         var m:int = 0;
         var n:int = 0;
         var optimumColumns:Array = null;
         var i:int = 0;
         var j:int = 0;
         ww = 0;
         m = 0;
         n = int(items.length);
         optimumColumns = getOptimumColumns();
         for(i = 0; i < n; i++)
         {
            if(Boolean(items[i].length))
            {
               if(pt.y < yy + info[i].height)
               {
                  m = int(items[i].length);
                  if(m == 1)
                  {
                     r = items[i][0];
                     break;
                  }
                  ww = 0;
                  for(j = 0; j < m; j++)
                  {
                     ww += optimumColumns[j].width;
                     if(pt.x < ww)
                     {
                        r = items[i][j];
                        break;
                     }
                  }
                  if(Boolean(r))
                  {
                     break;
                  }
               }
            }
            yy += info[i].height;
         }
         return r;
      }
      
      protected function endEdit(reason:String) : Boolean
      {
         if(!editedItemRenderer)
         {
            return true;
         }
         inEndEdit = true;
         var advancedDataGridEvent:AdvancedDataGridEvent = new AdvancedDataGridEvent(AdvancedDataGridEvent.ITEM_EDIT_END,false,true);
         advancedDataGridEvent.columnIndex = editedItemPosition.columnIndex;
         advancedDataGridEvent.dataField = _columns[editedItemPosition.columnIndex].dataField;
         advancedDataGridEvent.rowIndex = editedItemPosition.rowIndex;
         advancedDataGridEvent.itemRenderer = editedItemRenderer;
         advancedDataGridEvent.reason = reason;
         dispatchEvent(advancedDataGridEvent);
         dontEdit = itemEditorInstance != null;
         if(!dontEdit && reason == AdvancedDataGridEventReason.CANCELLED)
         {
            losingFocus = true;
            setFocus();
         }
         inEndEdit = false;
         return !advancedDataGridEvent.isDefaultPrevented();
      }
      
      protected function createHeaderSeparators(n:int, seperators:Array, headerLines:UIComponent) : void
      {
         var headerItemIndex:int = 0;
         var sep:UIComponent = null;
         var sepSkin:IFlexDisplayObject = null;
         var optimumColumns:Array = getOptimumColumns();
         for(var i:int = 0; i < n; i++)
         {
            headerItemIndex = lockedColumnCount > 0 && seperators != lockedSeparators ? int(i + lockedColumnCount - 1) : i;
            sep = getSeparator(i,seperators,headerLines);
            sepSkin = IFlexDisplayObject(sep.getChildAt(0));
            if(!headerItems || !headerItems[0] || !headerItems[0][headerItemIndex])
            {
               sep.visible = false;
            }
            else
            {
               sep.visible = true;
               sep.x = headerItems[0][headerItemIndex].x + optimumColumns[headerItemIndex].width - Math.round(sep.measuredWidth / 2 + 0.5);
               if(i > 0)
               {
                  sep.x = Math.max(sep.x,seperators[i - 1].x + Math.round(sep.measuredWidth / 2 + 0.5));
               }
               sep.y = 0;
               sepSkin.setActualSize(sepSkin.measuredWidth,Boolean(headerRowInfo.length) ? Number(headerRowInfo[0].height) : headerHeight);
               sep.graphics.clear();
               sep.graphics.beginFill(16777215,0);
               sep.graphics.drawRect(-separatorAffordance,0,sepSkin.measuredWidth + separatorAffordance,headerHeight);
               sep.graphics.endFill();
            }
         }
      }
      
      public function set columns(value:Array) : void
      {
         var n:int = 0;
         var i:int = 0;
         var column:AdvancedDataGridColumn = null;
         freeItemRenderersTable = new Dictionary(false);
         columnMap = {};
         purgeHeaderRenderers();
         n = int(_columns.length);
         for(i = 0; i < n; i++)
         {
            columnRendererChanged(_columns[i]);
         }
         _columns = value.slice(0);
         columnsInvalid = true;
         generatedColumns = false;
         n = int(value.length);
         for(i = 0; i < n; i++)
         {
            column = _columns[i];
            column.owner = this;
            column.colNum = i;
         }
         updateSortIndexAndDirection();
         itemsSizeChanged = true;
         columnsChanged = true;
         invalidateDisplayList();
         dispatchEvent(new Event("columnsChanged"));
      }
      
      private function columnResizeMouseOverHandler(event:MouseEvent) : void
      {
         var target:DisplayObject = null;
         var index:int = 0;
         var optimumColumns:Array = null;
         var stretchCursorClass:Class = null;
         if(!enabled || !resizableColumns)
         {
            return;
         }
         target = DisplayObject(event.target);
         index = target.parent.getChildIndex(target);
         optimumColumns = getOptimumColumns();
         if(!optimumColumns[index].resizable)
         {
            return;
         }
         stretchCursorClass = getStyle("stretchCursor");
         resizeCursorID = cursorManager.setCursor(stretchCursorClass,CursorManagerPriority.HIGH);
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
               if(Boolean(itemEditorInstance))
               {
                  endEdit(AdvancedDataGridEventReason.OTHER);
               }
               scrollBar = ScrollBar(event.target);
               pos = Number(scrollBar.scrollPosition);
               if(scrollBar == verticalScrollBar)
               {
                  verticalScrollPosition = pos;
               }
               else if(scrollBar == horizontalScrollBar)
               {
                  horizontalScrollPosition = pos;
               }
               super.scrollHandler(event);
            }
         }
      }
      
      public function get editedItemRenderer() : IListItemRenderer
      {
         if(!itemEditorInstance)
         {
            return null;
         }
         return listItems[actualRowIndex][actualColIndex];
      }
      
      protected function updateHeaderSearchList() : void
      {
         var i:int = 0;
         var n:int = Boolean(visibleHeaderInfos) ? int(visibleHeaderInfos.length) : 0;
         orderedHeadersList = [];
         for(i = 0; i < n; i++)
         {
            orderedHeadersList.push(visibleHeaderInfos[i]);
         }
      }
      
      protected function drawRowBackground(s:Sprite, rowIndex:int, y:Number, height:Number, color:uint, dataIndex:int) : void
      {
         var background:Shape = null;
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
         height = Math.min(height,listContent.height - y);
         var g:Graphics = background.graphics;
         g.clear();
         g.beginFill(color,getStyle("backgroundAlpha"));
         g.drawRect(0,0,displayWidth,height);
         g.endFill();
      }
      
      protected function absoluteToVisibleIndices(rowIndex:int, columnIndex:int) : Object
      {
         var visibleRowIndex:int = 0;
         var visibleColIndex:int = 0;
         var columnsOnScreen:Array = null;
         visibleRowIndex = -1;
         visibleColIndex = -1;
         if((rowIndex < lockedRowCount || rowIndex >= verticalScrollPosition) && rowIndex <= verticalScrollPosition + (Boolean(listItems.length) ? listItems.length - 1 : 0))
         {
            if(rowIndex >= lockedRowCount && rowIndex >= verticalScrollPosition)
            {
               visibleRowIndex = rowIndex - verticalScrollPosition;
            }
            else
            {
               visibleRowIndex = rowIndex;
            }
         }
         if(visibleRowIndex > -1)
         {
            columnsOnScreen = visibleColumns;
            if(Boolean(columnsOnScreen) && columnsOnScreen.length > 0)
            {
               if(columnIndex >= columnsOnScreen[0].colNum && columnIndex <= columnsOnScreen[columnsOnScreen.length - 1].colNum)
               {
                  if(columnIndex >= lockedColumnCount)
                  {
                     visibleColIndex = absoluteToVisibleColumnIndex(columnIndex);
                  }
                  else
                  {
                     visibleColIndex = columnIndex;
                  }
               }
            }
         }
         return {
            "rowIndex":visibleRowIndex,
            "columnIndex":visibleColIndex
         };
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getMeasuringRenderer(c:AdvancedDataGridColumn, forHeader:Boolean, data:Object) : IListItemRenderer
      {
         var factory:IFactory = columnItemRendererFactory(c,forHeader,data);
         var item:IListItemRenderer = measuringObjects[factory];
         if(!item)
         {
            item = columnItemRenderer(c,forHeader,data);
            item.visible = false;
            item.styleName = c;
            listContent.addChild(DisplayObject(item));
            measuringObjects[factory] = item;
         }
         return item;
      }
      
      private function updateSubContent() : void
      {
         if(!visibleColumns || getOptimumColumns() == visibleColumns)
         {
            listSubContent.scrollRect = null;
            listSubContent.x = 0;
            return;
         }
         var lockedWidth:Number = 0;
         for(var i:int = 0; i < lockedColumnCount; i++)
         {
            lockedWidth += displayableColumns[i].width;
         }
         var scrollWidth:Number = 0;
         if(visibleColumns.length > lockedColumnCount)
         {
            for(i = lockedColumnCount; i < lockedColumnCount + horizontalScrollPosition; i++)
            {
               scrollWidth += displayableColumns[i].width;
            }
         }
         if(horizontalScrollPosition == 0)
         {
            listSubContent.scrollRect = null;
            listSubContent.x = 0;
         }
         else
         {
            if(lockedColumnCount > 0)
            {
               listSubContent.x = lockedWidth;
            }
            else
            {
               listSubContent.x = 0;
            }
            if(lockedWidth > 0)
            {
               listSubContent.scrollRect = new Rectangle(lockedWidth + scrollWidth,0,listContent.width - lockedWidth,listContent.height);
            }
            else
            {
               listSubContent.scrollRect = new Rectangle(scrollWidth,0,listContent.width,listContent.height);
            }
         }
      }
      
      private function commitEditedItemPosition(coord:Object) : void
      {
         var item:IListItemRenderer = null;
         var reason:String = null;
         var i:int = 0;
         var evt:ListEvent = null;
         if(!enabled || !editable.length)
         {
            return;
         }
         if(Boolean(itemEditorInstance && coord && itemEditorInstance is IFocusManagerComponent) && Boolean(_editedItemPosition.rowIndex == coord.rowIndex) && _editedItemPosition.columnIndex == coord.columnIndex)
         {
            IFocusManagerComponent(itemEditorInstance).setFocus();
            return;
         }
         if(Boolean(itemEditorInstance))
         {
            if(!coord)
            {
               reason = AdvancedDataGridEventReason.OTHER;
            }
            else
            {
               reason = !editedItemPosition || coord.rowIndex == editedItemPosition.rowIndex ? AdvancedDataGridEventReason.NEW_COLUMN : AdvancedDataGridEventReason.NEW_ROW;
            }
            if(!endEdit(reason) && reason != AdvancedDataGridEventReason.OTHER)
            {
               return;
            }
         }
         _editedItemPosition = coord;
         if(!coord)
         {
            return;
         }
         if(dontEdit)
         {
            return;
         }
         var rowIndex:int = int(coord.rowIndex);
         var colIndex:int = int(coord.columnIndex);
         if(displayableColumns.length != _columns.length)
         {
            for(i = 0; i < displayableColumns.length; i++)
            {
               if(displayableColumns[i].colNum >= colIndex)
               {
                  colIndex = i;
                  break;
               }
            }
            if(i == displayableColumns.length)
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
         var actualLockedRows:int = lockedRowCount;
         var lastRowIndex:int = verticalScrollPosition + listItems.length - 1;
         var partialRow:int = rowInfo[listItems.length - 1].y + rowInfo[listItems.length - 1].height > listContent.height ? 1 : 0;
         if(rowIndex > actualLockedRows)
         {
            if(rowIndex < verticalScrollPosition + actualLockedRows)
            {
               verticalScrollPosition = rowIndex - actualLockedRows;
            }
            else
            {
               while(rowIndex > lastRowIndex || Boolean(rowIndex == lastRowIndex && rowIndex > verticalScrollPosition + actualLockedRows) && Boolean(partialRow))
               {
                  if(verticalScrollPosition == maxVerticalScrollPosition)
                  {
                     break;
                  }
                  verticalScrollPosition = Math.min(verticalScrollPosition + (rowIndex > lastRowIndex ? rowIndex - lastRowIndex : partialRow),maxVerticalScrollPosition);
                  lastRowIndex = verticalScrollPosition + listItems.length - 1;
                  partialRow = rowInfo[listItems.length - 1].y + rowInfo[listItems.length - 1].height > listContent.height ? 1 : 0;
               }
            }
            actualRowIndex = rowIndex - verticalScrollPosition;
         }
         else
         {
            if(rowIndex == actualLockedRows)
            {
               verticalScrollPosition = 0;
            }
            actualRowIndex = rowIndex;
         }
         var bm:EdgeMetrics = borderMetrics;
         var len:uint = visibleColumns.length;
         var lastColIndex:int = horizontalScrollPosition + len - 1;
         var headerInfo:AdvancedDataGridHeaderInfo = getHeaderInfo(visibleColumns[visibleColumns.length - 1]);
         var partialCol:int = headerInfo.headerItem.x + headerInfo.column.width > listContent.width ? 1 : 0;
         if(colIndex > lockedColumnCount)
         {
            if(colIndex < horizontalScrollPosition + lockedColumnCount)
            {
               horizontalScrollPosition = colIndex - lockedColumnCount;
            }
            else
            {
               while(colIndex > lastColIndex || Boolean(colIndex == lastColIndex && colIndex > horizontalScrollPosition + lockedColumnCount) && Boolean(partialCol))
               {
                  if(horizontalScrollPosition == maxHorizontalScrollPosition)
                  {
                     break;
                  }
                  horizontalScrollPosition = Math.min(horizontalScrollPosition + (colIndex > lastColIndex ? colIndex - lastColIndex : partialCol),maxHorizontalScrollPosition);
                  lastColIndex = horizontalScrollPosition + visibleColumns.length - 1;
                  headerInfo = getHeaderInfo(visibleColumns[visibleColumns.length - 1]);
                  partialCol = headerInfo.headerItem.x + headerInfo.headerItem.width > listContent.width ? 1 : 0;
               }
            }
            actualColIndex = absoluteToVisibleColumnIndex(displayToAbsoluteColumnIndex(colIndex));
         }
         else
         {
            if(colIndex == lockedColumnCount)
            {
               horizontalScrollPosition = 0;
            }
            actualColIndex = colIndex;
         }
         if(Boolean(listItems[actualRowIndex]) && Boolean(listItems[actualRowIndex][actualColIndex]))
         {
            item = listItems[actualRowIndex][actualColIndex];
         }
         if(!item)
         {
            commitEditedItemPosition(null);
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
         var event:AdvancedDataGridEvent = new AdvancedDataGridEvent(AdvancedDataGridEvent.ITEM_EDIT_BEGIN,false,true);
         event.columnIndex = displayableColumns[colIndex].colNum;
         event.rowIndex = _editedItemPosition.rowIndex;
         event.itemRenderer = item;
         dispatchEvent(event);
         lastEditedItemPosition = _editedItemPosition;
         if(bEditedItemPositionChanged)
         {
            bEditedItemPositionChanged = false;
            commitEditedItemPosition(_proposedEditedItemPosition);
            _proposedEditedItemPosition = undefined;
         }
         if(!itemEditorInstance)
         {
            commitEditedItemPosition(null);
         }
      }
      
      override protected function commitProperties() : void
      {
         if(columnsInvalid)
         {
            if(columnsChanged && !headerInfoInitialized)
            {
               headerInfoInitialized = true;
               headerInfos = initializeHeaderInfo(columns);
               headerInfoInitialized = false;
               columnsChanged = false;
            }
            columnsChanged = false;
            visibleHeaderInfos = updateVisibleHeaders();
            updateHeaderSearchList();
            createDisplayableColumns();
         }
         super.commitProperties();
         measureItems();
      }
      
      protected function sortHandler(event:AdvancedDataGridEvent) : void
      {
         var columnName:String = null;
         var columnNumber:int = 0;
         var sortFields:Array = null;
         var sort:Sort = null;
         columnName = event.dataField;
         columnNumber = event.columnIndex;
         if(!sortableColumns || !columns[columnNumber].sortable)
         {
            return;
         }
         if(columnName == null)
         {
            columnName = itemToUID(columns[columnNumber]);
         }
         if(!event.multiColumnSort)
         {
            if(Boolean(collection.sort) && Boolean(collection.sort.fields.length == 1) && (Boolean(columnName) && Boolean(findSortField(columnName) > -1)))
            {
               if(sortExpertMode == true)
               {
                  sortDirection = flipSortOrder(columnName,columnNumber,collection);
               }
            }
            else
            {
               collection.sort = null;
               addSortField(columnName,columnNumber,collection);
            }
         }
         else if(event.removeColumnFromSort)
         {
            removeSortField(columnName,columnNumber,collection);
         }
         else if(findSortField(columnName) == -1)
         {
            addSortField(columnName,columnNumber,collection);
         }
         else if(findSortField(columnName) > -1)
         {
            if(collection.sort.fields.length == 1)
            {
               sortDirection = flipSortOrder(columnName,columnNumber,collection);
            }
            else
            {
               flipSortOrder(columnName,columnNumber,collection);
               sortDirection = null;
            }
         }
         collection.refresh();
         if(headerIndex != -1)
         {
            selectedHeaderInfo = getHeaderInfo(columns[event.columnIndex]);
            headerIndex = event.columnIndex;
            selectColumnHeader(headerIndex);
         }
         invalidateHeaders();
      }
      
      protected function removeSortField(columnName:String, columnNumber:int, collection:ICollectionView) : void
      {
         var column:AdvancedDataGridColumn = null;
         var columnNumberToRemove:int = 0;
         var n:int = 0;
         var i:int = 0;
         column = columns[columnNumber];
         if(!collection || !collection.sort || !collection.sort.fields || !collection.sort.fields.length)
         {
            return;
         }
         columnNumberToRemove = -1;
         n = int(collection.sort.fields.length);
         for(i = 0; i < n; i++)
         {
            if(collection.sort.fields[i].name == column.dataField)
            {
               columnNumberToRemove = i;
               break;
            }
         }
         if(columnNumberToRemove != -1)
         {
            collection.sort.fields.splice(columnNumberToRemove,1);
         }
      }
      
      private function adjustVerticalScrollPositionDownward(rowCount:int) : Boolean
      {
         var item:IListItemRenderer = null;
         var c:AdvancedDataGridColumn = null;
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
         h = listContent.height - h;
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
               n = int(columns.length);
               for(j = 0; j < n; j++)
               {
                  c = columns[j];
                  if(c.visible)
                  {
                     if(variableRowHeight)
                     {
                        item = getMeasuringRenderer(c,false,data);
                        setupRendererFromData(c,item,data);
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
         verticalScrollPosition = Math.max(0,verticalScrollPosition - numRows);
         if(numRows > 0 && !variableRowHeight)
         {
            configureScrollBars();
         }
         return numRows > 0;
      }
      
      protected function invalidateHeaders() : void
      {
         var n:int = int(orderedHeadersList.length);
         for(var i:int = 0; i < n; i++)
         {
            invalidateRenderer(orderedHeadersList[i].headerItem);
         }
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         super.styleChanged(styleProp);
         var changed:Boolean = false;
         if(styleProp == "headerBackgroundSkin")
         {
            changed = true;
            headerBGSkinChanged = true;
         }
         else if(styleProp == "headerSortSeparatorSkin")
         {
            changed = true;
         }
         else if(styleProp == "headerSeparatorSkin")
         {
            headerSepSkinChanged = true;
            changed = true;
         }
         if(changed)
         {
            itemsSizeChanged = true;
         }
      }
      
      override protected function dragStartHandler(event:DragEvent) : void
      {
         if(collectionUpdatesDisabled)
         {
            collection.enableAutoUpdate();
            collectionUpdatesDisabled = false;
         }
         super.dragStartHandler(event);
      }
      
      protected function updateVisibleHeaders() : Array
      {
         var i:int = 0;
         var visibleHeaderInfos:Array = [];
         var n:int = Boolean(headerInfos) ? int(headerInfos.length) : 0;
         var k:int = 0;
         for(i = 0; i < n; i++)
         {
            headerInfos[i].visible = headerInfos[i].column.visible;
            if(Boolean(headerInfos[i].visible))
            {
               visibleHeaderInfos.push(headerInfos[i]);
               headerInfos[i].actualColNum = k++;
               headerInfos[i].columnSpan = 1;
            }
            else
            {
               headerInfos[i].actualColNum = NaN;
            }
         }
         return visibleHeaderInfos;
      }
      
      [Inspectable(category="General",arrayType="mx.controls.advancedDataGridClasses.AdvancedDataGridColumn")]
      [Bindable("columnsChanged")]
      public function get columns() : Array
      {
         return _columns.slice(0);
      }
      
      override public function set lockedColumnCount(value:int) : void
      {
         var i:int = 0;
         var j:int = 0;
         if(value > super.lockedColumnCount)
         {
            for(i = super.lockedColumnCount; i < value; i++)
            {
               for(j = 0; j < listItems.length; j++)
               {
                  if(Boolean(listItems[j]) && Boolean(listItems[j][i]))
                  {
                     delete columnMap[listItems[j][i].name];
                  }
               }
            }
         }
         else if(value < super.lockedColumnCount)
         {
            for(i = value; i < super.lockedColumnCount; i++)
            {
               for(j = 0; j < listItems.length; j++)
               {
                  if(Boolean(listItems[j]) && Boolean(listItems[j][i]))
                  {
                     delete columnMap[listItems[j][i].name];
                  }
               }
            }
         }
         super.lockedColumnCount = value;
         updateSubContent();
         itemsSizeChanged = true;
         columnsInvalid = true;
         horizontalScrollPosition = super.horizontalScrollPosition;
      }
      
      override protected function findKey(eventCode:int) : Boolean
      {
         var tmpCode:int = eventCode;
         var now:uint = uint(getTimer());
         var str:String = String.fromCharCode(tmpCode);
         if(!(tmpCode >= 33 && tmpCode <= 126))
         {
            return false;
         }
         var selIndex:Number = _selectedIndex;
         if(now - previousTime < lookAheadDuration)
         {
            str = lookAheadCache + str;
            lookAheadCache = str;
            previousTime = now;
            if(_selectedIndex > 0)
            {
               selIndex = _selectedIndex;
               --_selectedIndex;
            }
         }
         else
         {
            previousTime = now;
            lookAheadCache = str;
         }
         var selectionChanged:Boolean = findString(str);
         if(!selectionChanged && _selectedIndex != selIndex)
         {
            _selectedIndex = selIndex;
         }
         return selectionChanged;
      }
      
      private function editorStageResizeHandler(event:Event) : void
      {
         if(event.target is DisplayObjectContainer && DisplayObjectContainer(event.target).contains(this))
         {
            endEdit(AdvancedDataGridEventReason.OTHER);
         }
      }
      
      protected function drawVerticalLine(s:Sprite, colIndex:int, color:uint, x:Number) : void
      {
         var g:Graphics = s.graphics;
         if(lockedColumnCount > 0 && colIndex == lockedColumnCount - 1)
         {
            g.lineStyle(1,0,100);
         }
         else
         {
            g.lineStyle(1,color,100);
         }
         var tempY:Number = 0;
         if(headerVisible)
         {
            if(lockedColumnCount > 0 && colIndex == lockedColumnCount - 1)
            {
               g.moveTo(x,1);
               g.lineTo(x,headerItems[0][colIndex].height);
            }
            else
            {
               tempY = Number(headerItems[0][colIndex].height);
            }
         }
         g.moveTo(x,tempY);
         g.lineTo(x,listContent.height);
      }
      
      override protected function mouseOverHandler(event:MouseEvent) : void
      {
         var r:IListItemRenderer = null;
         var n:int = 0;
         var headerItem:IListItemRenderer = null;
         var headerInfo:AdvancedDataGridHeaderInfo = null;
         var i:int = 0;
         var s:Sprite = null;
         var h:Number = NaN;
         var w:Number = NaN;
         var x:Number = NaN;
         var g:Graphics = null;
         var lockedWidth:Number = NaN;
         var lastLockedInfo:AdvancedDataGridHeaderInfo = null;
         if(Boolean(movingColumn))
         {
            return;
         }
         if(!enabled || !selectable)
         {
            return;
         }
         if(Boolean(enabled && headerVisible) && Boolean(getNumColumns()) && !isPressed)
         {
            r = mouseEventToItemRenderer(event);
            n = int(orderedHeadersList.length);
            i = 0;
            while(i < n && Boolean(r))
            {
               headerItem = orderedHeadersList[i].headerItem;
               if(headerItem == r)
               {
                  headerInfo = orderedHeadersList[i];
                  if(Boolean(orderedHeadersList[i].column.sortable))
                  {
                     s = Sprite(selectionLayer.getChildByName("headerSelection"));
                     if(!s)
                     {
                        s = new FlexSprite();
                        s.name = "headerSelection";
                        selectionLayer.addChild(s);
                     }
                     h = r.height + cachedPaddingBottom + cachedPaddingTop;
                     w = Number(r.getExplicitOrMeasuredWidth());
                     x = Number(r.x);
                     if(headerInfo.actualColNum >= lockedColumnCount)
                     {
                        x = getAdjustedXPos(r.x);
                        if(horizontalScrollPosition > 0 && headerInfo.actualColNum - horizontalScrollPosition < lockedColumnCount)
                        {
                           lockedWidth = 0;
                           if(lockedColumnCount > 0)
                           {
                              lastLockedInfo = getHeaderInfo(columns[lockedColumnCount - 1]);
                              lockedWidth = lastLockedInfo.headerItem.x + columns[lockedColumnCount - 1].width;
                           }
                           else
                           {
                              lockedWidth = 0;
                           }
                           w -= lockedWidth - x;
                           x = lockedWidth;
                        }
                     }
                     g = s.graphics;
                     g.clear();
                     g.beginFill(getStyle("rollOverColor"));
                     g.drawRect(0,0,w,h - 0.5);
                     g.endFill();
                     s.x = x;
                     s.y = r.y - cachedPaddingTop;
                  }
                  return;
               }
               i++;
            }
         }
         if(event.buttonDown)
         {
            lastItemDown = r;
         }
         else
         {
            lastItemDown = null;
         }
         super.mouseOverHandler(event);
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var bm:EdgeMetrics = null;
         var hh:Number = NaN;
         var headerBGSkinClass:Class = null;
         var headerBGSkin:IFlexDisplayObject = null;
         var updateContent:Boolean = false;
         if(displayWidth != unscaledWidth - viewMetrics.right - viewMetrics.left)
         {
            displayWidth = unscaledWidth - viewMetrics.right - viewMetrics.left;
            columnsInvalid = true;
            updateContent = true;
         }
         calculateColumnSizes();
         if(updateContent)
         {
            updateSubContent();
         }
         if(rendererChanged)
         {
            purgeItemRenderers();
         }
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(horizontalScrollPolicy != ScrollPolicy.OFF && getOptimumColumns() != visibleColumns && !itemsSizeChanged && !bSelectionChanged && !scrollAreaChanged && subContentScrolled)
         {
            configureScrollBars();
            subContentScrolled = false;
         }
         if(Boolean(collection) && Boolean(collection.length))
         {
            setRowCount(listItems.length);
            if(Boolean(headerInfos) && Boolean(headerInfos.length))
            {
               setColumnCount(headerInfos.length);
            }
            else
            {
               setColumnCount(0);
            }
         }
         if(_horizontalScrollPolicy == ScrollPolicy.OFF)
         {
            bm = borderMetrics;
            hh = Boolean(headerRowInfo.length) ? Number(headerRowInfo[0].height) : headerHeight;
            if(verticalScrollBar != null && Boolean(verticalScrollBar.visible) && headerVisible && Boolean(roomForScrollBar(verticalScrollBar,unscaledWidth - bm.left - bm.right,unscaledHeight - hh - bm.top - bm.bottom)))
            {
               verticalScrollBar.move(verticalScrollBar.x,viewMetrics.top + hh);
               verticalScrollBar.setActualSize(verticalScrollBar.width,unscaledHeight - viewMetrics.top - viewMetrics.bottom - hh);
               verticalScrollBar.visible = verticalScrollBar.height >= verticalScrollBar.minHeight;
            }
         }
         if(bEditedItemPositionChanged)
         {
            bEditedItemPositionChanged = false;
            commitEditedItemPosition(_proposedEditedItemPosition);
            _proposedEditedItemPosition = undefined;
            itemsSizeChanged = false;
         }
         var headerBG:UIComponent = UIComponent(listContent.getChildByName("headerBG"));
         if(headerBGSkinChanged)
         {
            headerBGSkinChanged = false;
            if(Boolean(headerBG))
            {
               listContent.removeChild(headerBG);
            }
            headerBG = null;
         }
         if(!headerBG)
         {
            headerBG = new UIComponent();
            headerBG.name = "headerBG";
            listContent.addChildAt(DisplayObject(headerBG),listContent.getChildIndex(selectionLayer));
            headerBGSkinClass = getStyle("headerBackgroundSkin");
            if(headerBGSkinClass != null)
            {
               headerBGSkin = new headerBGSkinClass();
               if(headerBGSkin is ISimpleStyleClient)
               {
                  ISimpleStyleClient(headerBGSkin).styleName = this;
               }
               headerBG.addChild(DisplayObject(headerBGSkin));
            }
         }
         if(headerVisible)
         {
            headerBG.visible = true;
            if(useOldDGHeaderBGLogic)
            {
               drawHeaderBackground(headerBG);
            }
            else if(headerBG.numChildren > 0)
            {
               drawHeaderBackgroundSkin(IFlexDisplayObject(headerBG.getChildAt(0)));
            }
         }
         else
         {
            headerBG.visible = false;
         }
         drawRowBackgrounds();
         if(headerVisible)
         {
            drawSeparators();
         }
         else
         {
            clearSeparators();
         }
         drawLinesAndColumnBackgrounds();
      }
      
      public function destroyItemEditor() : void
      {
         var event:AdvancedDataGridEvent = null;
         if(Boolean(itemEditorInstance))
         {
            DisplayObject(itemEditorInstance).removeEventListener(KeyboardEvent.KEY_DOWN,editorKeyDownHandler);
            systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_DOWN,editorMouseDownHandler,true);
            systemManager.getSandboxRoot().removeEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE,editorMouseDownHandler);
            systemManager.removeEventListener(Event.RESIZE,editorStageResizeHandler,true);
            event = new AdvancedDataGridEvent(AdvancedDataGridEvent.ITEM_FOCUS_OUT);
            event.columnIndex = _editedItemPosition.columnIndex;
            event.rowIndex = _editedItemPosition.rowIndex;
            event.itemRenderer = itemEditorInstance;
            dispatchEvent(event);
            if(!_columns[_editedItemPosition.columnIndex].rendererIsEditor)
            {
               if(Boolean(itemEditorInstance) && itemEditorInstance is UIComponent)
               {
                  UIComponent(itemEditorInstance).drawFocus(false);
               }
               itemEditorInstance.parent.removeChild(DisplayObject(itemEditorInstance));
            }
            itemEditorInstance = null;
            _editedItemPosition = null;
         }
      }
      
      protected function unsetColumnDragParameters() : void
      {
         var sbRoot:DisplayObject = systemManager.getSandboxRoot();
         sbRoot.removeEventListener(MouseEvent.MOUSE_MOVE,columnDraggingMouseMoveHandler,true);
         sbRoot.removeEventListener(MouseEvent.MOUSE_UP,columnDraggingMouseUpHandler,true);
         sbRoot.removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,columnDraggingMouseUpHandler);
         systemManager.deployMouseShields(false);
         var proxy:IListItemRenderer = IListItemRenderer(listContent.getChildByName("headerDragProxy"));
         if(Boolean(proxy))
         {
            listContent.removeChild(DisplayObject(proxy));
         }
         var s:Sprite = Sprite(selectionLayer.getChildByName("headerSelection"));
         if(Boolean(s))
         {
            selectionLayer.removeChild(s);
         }
         if(Boolean(columnDropIndicator))
         {
            columnDropIndicator.visible = false;
         }
         s = Sprite(listContent.getChildByName("columnDragOverlay"));
         if(Boolean(s))
         {
            listContent.removeChild(s);
         }
         listContent.scrollRect = null;
         addClipMask(false);
         startX = NaN;
         movingColumn = null;
         dropColumnIndex = -1;
      }
      
      private function editorMouseDownHandler(event:Event) : void
      {
         if(event is MouseEvent && Boolean(owns(DisplayObject(event.target))))
         {
            return;
         }
         endEdit(AdvancedDataGridEventReason.OTHER);
      }
   }
}

