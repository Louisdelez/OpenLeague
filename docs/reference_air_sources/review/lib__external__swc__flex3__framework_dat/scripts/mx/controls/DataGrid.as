package mx.controls
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
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
   import mx.core.FlexVersion;
   import mx.core.IFactory;
   import mx.core.IFlexDisplayObject;
   import mx.core.IFlexModuleFactory;
   import mx.core.IIMESupport;
   import mx.core.IInvalidating;
   import mx.core.IPropertyChangeNotifier;
   import mx.core.IRectangularBorder;
   import mx.core.IUIComponent;
   import mx.core.ScrollPolicy;
   import mx.core.UIComponent;
   import mx.core.UIComponentGlobals;
   import mx.core.mx_internal;
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
   import mx.styles.StyleManager;
   import mx.utils.ObjectUtil;
   import mx.utils.StringUtil;
   
   use namespace mx_internal;
   
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
   [Style(name="headerColors",type="Array",arrayType="uint",format="Color",inherit="yes")]
   [Style(name="horizontalGridLineColor",type="uint",format="Color",inherit="yes")]
   [Style(name="verticalGridLineColor",type="uint",format="Color",inherit="yes")]
   [Style(name="horizontalGridLines",type="Boolean",inherit="no")]
   [Style(name="verticalGridLines",type="Boolean",inherit="no")]
   [Style(name="disabledIconColor",type="uint",format="Color",inherit="yes")]
   [Style(name="iconColor",type="uint",format="Color",inherit="yes")]
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
      
      mx_internal static var createAccessibilityImplementation:Function;
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private var lastItemDown:IListItemRenderer;
      
      [Inspectable(environment="none")]
      public var itemEditorInstance:IListItemRenderer;
      
      private var displayableColumns:Array;
      
      private var displayWidth:Number;
      
      mx_internal var resizingColumn:DataGridColumn;
      
      private var dontEdit:Boolean = false;
      
      mx_internal var movingColumn:DataGridColumn;
      
      private var generatedColumns:Boolean = true;
      
      private var lastEditedItemPosition:*;
      
      private var _headerWordWrapPresent:Boolean = false;
      
      [Inspectable(category="General")]
      public var editable:Boolean = false;
      
      private var losingFocus:Boolean = false;
      
      private var lastItemFocused:DisplayObject;
      
      private var _originalHeaderHeight:Number = 0;
      
      private var _minColumnWidth:Number;
      
      mx_internal var sortDirection:String;
      
      private var manualSort:Boolean;
      
      private var bEditedItemPositionChanged:Boolean = false;
      
      private var sortColumn:DataGridColumn;
      
      private var actualContentHolder:ListBaseContentHolder;
      
      private var _columns:Array;
      
      private var inEndEdit:Boolean = false;
      
      private var lockedColumnWidth:Number = 0;
      
      [Inspectable(category="General")]
      public var resizableColumns:Boolean = true;
      
      private var _originalExplicitHeaderHeight:Boolean = false;
      
      private var minColumnWidthInvalid:Boolean = false;
      
      private var _editedItemPosition:Object;
      
      private var _imeMode:String = null;
      
      private var actualRowIndex:int;
      
      private var _proposedEditedItemPosition:*;
      
      private var itemEditorPositionChanged:Boolean = false;
      
      mx_internal var sortIndex:int = -1;
      
      private var skipHeaderUpdate:Boolean = false;
      
      mx_internal var lastSortIndex:int = -1;
      
      private var actualColIndex:int;
      
      mx_internal var lockedColumnDropIndicator:IFlexDisplayObject;
      
      [Inspectable(category="General")]
      public var sortableColumns:Boolean = true;
      
      private var collectionUpdatesDisabled:Boolean = false;
      
      private var _draggableColumns:Boolean = true;
      
      private var _focusPane:Sprite;
      
      public function DataGrid()
      {
         super();
         _columns = [];
         setRowHeight(20);
         addEventListener(DataGridEvent.ITEM_EDIT_BEGINNING,itemEditorItemEditBeginningHandler,false,EventPriority.DEFAULT_HANDLER);
         addEventListener(DataGridEvent.ITEM_EDIT_BEGIN,itemEditorItemEditBeginHandler,false,EventPriority.DEFAULT_HANDLER);
         addEventListener(DataGridEvent.ITEM_EDIT_END,itemEditorItemEditEndHandler,false,EventPriority.DEFAULT_HANDLER);
         addEventListener(DataGridEvent.HEADER_RELEASE,headerReleaseHandler,false,EventPriority.DEFAULT_HANDLER);
         addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
      }
      
      mx_internal function _drawHeaderBackground(headerBG:UIComponent) : void
      {
         drawHeaderBackground(headerBG);
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
      
      public function destroyItemEditor() : void
      {
         var event:DataGridEvent = null;
         if(Boolean(itemEditorInstance))
         {
            DisplayObject(itemEditorInstance).removeEventListener(KeyboardEvent.KEY_DOWN,editorKeyDownHandler);
            systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_DOWN,editorMouseDownHandler,true);
            systemManager.getSandboxRoot().removeEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE,editorMouseDownHandler);
            systemManager.removeEventListener(Event.RESIZE,editorStageResizeHandler,true);
            event = new DataGridEvent(DataGridEvent.ITEM_FOCUS_OUT);
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
               actualContentHolder.removeChild(DisplayObject(itemEditorInstance));
               editedItemRenderer.visible = true;
            }
            itemEditorInstance = null;
            _editedItemPosition = null;
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
         r = mouseEventToItemRenderer(event);
         super.mouseUpHandler(event);
         if(Boolean(r) && Boolean(r != itemEditorInstance) && (lastItemDown == r || itemRendererContains(lastItemDown,lastItemFocused)))
         {
            if(lastItemDown != r)
            {
               r = lastItemDown;
            }
            lastItemFocused = null;
            pos = itemRendererToIndices(r);
            if(Boolean(pos && pos.y >= 0) && Boolean(editable) && !dontEdit)
            {
               if(Boolean(displayableColumns[pos.x].editable))
               {
                  beginningEdit(displayableColumns[pos.x].colNum,pos.y,r);
               }
               else
               {
                  lastEditedItemPosition = {
                     "columnIndex":displayableColumns[pos.x].colNum,
                     "rowIndex":pos.y
                  };
               }
            }
         }
         else if(Boolean(lastItemDown) && lastItemDown != itemEditorInstance)
         {
            pos = itemRendererToIndices(lastItemDown);
            if(Boolean(pos && pos.y >= 0) && Boolean(editable) && !dontEdit)
            {
               if(Boolean(displayableColumns[pos.x].editable))
               {
                  beginningEdit(displayableColumns[pos.x].colNum,pos.y,lastItemDown);
               }
               else
               {
                  lastEditedItemPosition = {
                     "columnIndex":displayableColumns[pos.x].colNum,
                     "rowIndex":pos.y
                  };
               }
            }
         }
         lastItemDown = null;
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
            if(Boolean(itemEditorInstance) && event.reason != DataGridEventReason.CANCELLED)
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
               if(property != null && getCurrentDataValue(data,property) !== newData)
               {
                  bChanged = setNewValue(data,property,newData,event.columnIndex);
               }
               if(bChanged && !(data is IPropertyChangeNotifier || data is XML))
               {
                  collection.itemUpdated(data,property);
               }
               if(event.itemRenderer is IDropInListItemRenderer)
               {
                  listData = DataGridListData(IDropInListItemRenderer(event.itemRenderer).listData);
                  listData.label = _columns[event.columnIndex].itemToLabel(data);
                  IDropInListItemRenderer(event.itemRenderer).listData = listData;
               }
               event.itemRenderer.data = data;
            }
         }
         else if(event.reason != DataGridEventReason.OTHER)
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
         if(event.reason == DataGridEventReason.OTHER || !event.isDefaultPrevented())
         {
            destroyItemEditor();
         }
      }
      
      public function set imeMode(value:String) : void
      {
         _imeMode = value;
      }
      
      mx_internal function measureHeightOfItemsUptoMaxHeight(index:int = -1, count:int = 0, maxHeight:Number = -1) : Number
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
         var c:DataGridColumn = null;
         var n:int = 0;
         var j:int = 0;
         var data:Object = null;
         if(!columns.length)
         {
            return rowHeight * count;
         }
         h = 0;
         ch = 0;
         paddingTop = getStyle("paddingTop");
         paddingBottom = getStyle("paddingBottom");
         lockedCount = lockedRowCount;
         if(headerVisible && count > 0 && index == -1)
         {
            h = calculateHeaderHeight();
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
               n = int(columns.length);
               for(j = 0; j < n; j++)
               {
                  c = columns[j];
                  if(c.visible)
                  {
                     item = c.getMeasuringRenderer(false,data);
                     if(DisplayObject(item).parent == null)
                     {
                        listContent.addChild(DisplayObject(item));
                     }
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
               count = headerVisible ? int(i + 1) : i;
               setRowCount(count);
               return h;
            }
            h += ch;
            if(Boolean(iterator))
            {
               try
               {
                  bMore = iterator.moveNext();
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
      
      mx_internal function get sortArrow() : IFlexDisplayObject
      {
         return DataGridHeader(header).sortArrow;
      }
      
      override protected function focusOutHandler(event:FocusEvent) : void
      {
         var target:DisplayObject = null;
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
            endEdit(DataGridEventReason.OTHER);
            removeEventListener(FocusEvent.KEY_FOCUS_CHANGE,keyFocusChangeHandler);
            removeEventListener(MouseEvent.MOUSE_DOWN,mouseFocusChangeHandler);
         }
      }
      
      private function itemEditorItemEditBeginningHandler(event:DataGridEvent) : void
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
            editable = false;
            setFocus();
            editable = true;
         }
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
      
      mx_internal function _clearSeparators() : void
      {
         clearSeparators();
      }
      
      public function set draggableColumns(value:Boolean) : void
      {
         _draggableColumns = value;
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
         sortIndex = -1;
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
      
      protected function isComplexColumn(property:String) : Boolean
      {
         return property.indexOf(".") != -1;
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
            mWidth = !isNaN(createThisSkin.measuredWidth) ? createThisSkin.measuredWidth : 1;
            createThisSkin.setActualSize(mWidth,s.parent.parent.height);
            createThisSkin.move(x - Math.round(mWidth / 2),0);
         }
         else
         {
            drawVerticalLine(s,colIndex,color,x);
         }
      }
      
      override public function set headerHeight(value:Number) : void
      {
         super.headerHeight = value;
         _originalHeaderHeight = isNaN(value) ? 22 : value;
         _originalExplicitHeaderHeight = !isNaN(value);
      }
      
      private function headerReleaseHandler(event:DataGridEvent) : void
      {
         if(!event.isDefaultPrevented())
         {
            manualSort = true;
            sortByColumn(event.columnIndex);
            manualSort = false;
         }
      }
      
      override mx_internal function resizeColumn(col:int, w:Number) : void
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
            _columns[col].setWidth(w);
            _columns[col].preferredWidth = w;
            return;
         }
         if(w < _columns[col].minWidth)
         {
            w = Number(_columns[col].minWidth);
         }
         if(_horizontalScrollPolicy == ScrollPolicy.ON || _horizontalScrollPolicy == ScrollPolicy.AUTO)
         {
            _columns[col].setWidth(w);
            _columns[col].explicitWidth = w;
            _columns[col].preferredWidth = w;
            columnsInvalid = true;
         }
         else
         {
            n = int(_columns.length);
            for(i = 0; i < n; i++)
            {
               if(col == _columns[i].colNum)
               {
                  break;
               }
            }
            if(i >= _columns.length - 1)
            {
               return;
            }
            col = i;
            totalSpace = 0;
            for(i = col + 1; i < n; i++)
            {
               if(Boolean(_columns[i].visible))
               {
                  if(Boolean(_columns[i].resizable))
                  {
                     totalSpace += _columns[i].width;
                  }
               }
            }
            newTotalSpace = _columns[col].width - w + totalSpace;
            if(Boolean(totalSpace))
            {
               _columns[col].setWidth(w);
               _columns[col].explicitWidth = w;
            }
            totX = 0;
            for(i = col + 1; i < n; i++)
            {
               if(Boolean(_columns[i].visible))
               {
                  if(Boolean(_columns[i].resizable))
                  {
                     newWidth = Math.floor(_columns[i].width * newTotalSpace / totalSpace);
                     if(newWidth < _columns[i].minWidth)
                     {
                        newWidth = Number(_columns[i].minWidth);
                     }
                     _columns[i].setWidth(newWidth);
                     totX += _columns[i].width;
                     lastColumn = _columns[i];
                  }
               }
            }
            if(totX > newTotalSpace)
            {
               newWidth = _columns[col].width - totX + newTotalSpace;
               if(newWidth < _columns[col].minWidth)
               {
                  newWidth = Number(_columns[col].minWidth);
               }
               _columns[col].setWidth(newWidth);
            }
            else if(Boolean(lastColumn))
            {
               lastColumn.setWidth(lastColumn.width - totX + newTotalSpace);
            }
         }
         itemsSizeChanged = true;
         invalidateDisplayList();
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
            columns = newCols;
            generatedColumns = true;
         }
      }
      
      override protected function drawRowBackgrounds() : void
      {
         drawRowGraphics(listContent);
      }
      
      mx_internal function get vScrollBar() : ScrollBar
      {
         return verticalScrollBar;
      }
      
      override public function showDropFeedback(event:DragEvent) : void
      {
         var dropIndicatorClass:Class = null;
         super.showDropFeedback(event);
         if(lockedColumnCount > 0)
         {
            if(!lockedColumnDropIndicator)
            {
               dropIndicatorClass = getStyle("dropIndicatorSkin");
               if(!dropIndicatorClass)
               {
                  dropIndicatorClass = ListDropIndicator;
               }
               lockedColumnDropIndicator = IFlexDisplayObject(new dropIndicatorClass());
               lockedColumnDropIndicator.x = 2;
               lockedColumnDropIndicator.setActualSize(lockedColumnContent.width - 2,4);
               lockedColumnDropIndicator.visible = true;
            }
            if(dropIndicator.parent == listContent)
            {
               lockedColumnContent.addChild(DisplayObject(lockedColumnDropIndicator));
            }
            else
            {
               lockedColumnAndRowContent.addChild(DisplayObject(lockedColumnDropIndicator));
            }
            lockedColumnDropIndicator.y = dropIndicator.y;
         }
      }
      
      override protected function scrollPositionToIndex(horizontalScrollPosition:int, verticalScrollPosition:int) : int
      {
         return Boolean(iterator) ? int(verticalScrollPosition + lockedRowCount) : -1;
      }
      
      protected function setNewValue(data:Object, property:String, value:Object, columnIndex:int) : Boolean
      {
         var complexFieldNameComponents:Array = null;
         var lastProp:String = null;
         var parent:Object = null;
         if(!isComplexColumn(property))
         {
            data[property] = value;
         }
         else
         {
            complexFieldNameComponents = property.split(".");
            lastProp = complexFieldNameComponents.pop();
            parent = deriveComplexFieldReference(data,complexFieldNameComponents);
            parent[lastProp] = value;
         }
         return true;
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
            mHeight = !isNaN(createThisSkin.measuredHeight) ? createThisSkin.measuredHeight : 1;
            createThisSkin.setActualSize(displayWidth - lockedColumnWidth,mHeight);
            createThisSkin.move(0,y);
         }
         else
         {
            drawHorizontalLine(s,rowIndex,color,y);
         }
      }
      
      private function itemEditorItemEditBeginHandler(event:DataGridEvent) : void
      {
         var fm:IFocusManager = null;
         if(Boolean(root))
         {
            systemManager.addEventListener(Event.DEACTIVATE,deactivateHandler,false,0,true);
         }
         if(!event.isDefaultPrevented() && actualContentHolder.listItems[actualRowIndex][actualColIndex].data != null)
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
            event = new DataGridEvent(DataGridEvent.ITEM_FOCUS_IN);
            event.columnIndex = _editedItemPosition.columnIndex;
            event.rowIndex = _editedItemPosition.rowIndex;
            event.itemRenderer = itemEditorInstance;
            dispatchEvent(event);
         }
      }
      
      private function setEditedItemPosition(coord:Object) : void
      {
         bEditedItemPositionChanged = true;
         _proposedEditedItemPosition = coord;
         invalidateDisplayList();
      }
      
      private function keyFocusChangeHandler(event:FocusEvent) : void
      {
         if(event.keyCode == Keyboard.TAB && !event.isDefaultPrevented() && findNextItemRenderer(event.shiftKey))
         {
            event.preventDefault();
         }
      }
      
      override public function set horizontalScrollPolicy(value:String) : void
      {
         super.horizontalScrollPolicy = value;
         columnsInvalid = true;
         itemsSizeChanged = true;
         invalidateDisplayList();
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
      
      override public function measureHeightOfItems(index:int = -1, count:int = 0) : Number
      {
         return measureHeightOfItemsUptoMaxHeight(index,count);
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
         if(Boolean(itemEditorInstance))
         {
            actualContentHolder.setChildIndex(DisplayObject(itemEditorInstance),actualContentHolder.numChildren - 1);
            if(Boolean(lockedColumnCount) && Boolean(editedItemPosition.columnIndex) && Boolean(visibleLockedColumns[lockedColumnCount - 1].colNum))
            {
               col = visibleLockedColumns[actualColIndex];
            }
            else
            {
               col = visibleColumns[actualColIndex];
            }
            item = actualContentHolder.listItems[actualRowIndex][actualColIndex];
            rowData = actualContentHolder.rowInfo[actualRowIndex];
            if(Boolean(item) && !col.rendererIsEditor)
            {
               dx = col.editorXOffset;
               dy = col.editorYOffset;
               dw = col.editorWidthOffset;
               dh = col.editorHeightOffset;
               itemEditorInstance.move(item.x + dx,rowData.y + dy);
               itemEditorInstance.setActualSize(Math.min(col.width + dw,actualContentHolder.width - itemEditorInstance.x),Math.min(rowData.height + dh,actualContentHolder.height - itemEditorInstance.y));
               item.visible = false;
            }
            lines = Sprite(actualContentHolder.getChildByName("lines"));
            if(Boolean(lines))
            {
               actualContentHolder.setChildIndex(lines,actualContentHolder.numChildren - 1);
            }
         }
         allowItemSizeChangeNotification = variableRowHeight;
         return pt;
      }
      
      private function scrollToEditedItem(rowIndex:int, colIndex:int) : void
      {
         var partialCol:int = 0;
         actualContentHolder = listContent;
         var listItems:Array = actualContentHolder.listItems;
         var lastRowIndex:int = verticalScrollPosition + listItems.length - 1 + lockedRowCount;
         var partialRow:int = rowInfo[listItems.length - 1].y + rowInfo[listItems.length - 1].height > listContent.height ? 1 : 0;
         if(rowIndex > lockedRowCount)
         {
            if(rowIndex < verticalScrollPosition + lockedRowCount)
            {
               verticalScrollPosition = rowIndex - lockedRowCount;
            }
            else
            {
               while(rowIndex > lastRowIndex || Boolean(rowIndex == lastRowIndex && rowIndex > verticalScrollPosition + lockedRowCount) && Boolean(partialRow))
               {
                  if(verticalScrollPosition == maxVerticalScrollPosition)
                  {
                     break;
                  }
                  verticalScrollPosition = Math.min(verticalScrollPosition + (rowIndex > lastRowIndex ? rowIndex - lastRowIndex : partialRow),maxVerticalScrollPosition);
                  lastRowIndex = verticalScrollPosition + listItems.length - 1 + lockedRowCount;
                  partialRow = rowInfo[listItems.length - 1].y + rowInfo[listItems.length - 1].height > listContent.height ? 1 : 0;
               }
            }
            actualRowIndex = rowIndex - verticalScrollPosition - lockedRowCount;
         }
         else if(rowIndex == lockedRowCount)
         {
            verticalScrollPosition = 0;
            actualRowIndex = rowIndex - lockedRowCount;
         }
         else
         {
            if(Boolean(lockedRowCount))
            {
               actualContentHolder = lockedRowContent;
            }
            actualRowIndex = rowIndex;
         }
         listItems = actualContentHolder.listItems;
         var len:uint = Boolean(listItems) && Boolean(listItems[0]) ? uint(listItems[0].length) : visibleColumns.length;
         var lastColIndex:int = horizontalScrollPosition + len - 1 + lockedColumnCount;
         if(colIndex > lockedColumnCount)
         {
            partialCol = listItems[0][len - 1].x + listItems[0][len - 1].width > listContent.width ? 1 : 0;
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
                  len = Boolean(listItems) && Boolean(listItems[0]) ? uint(listItems[0].length) : visibleColumns.length;
                  lastColIndex = horizontalScrollPosition + len - 1 + lockedColumnCount;
                  partialCol = listItems[0][len - 1].x + listItems[0][len - 1].width > listContent.width ? 1 : 0;
               }
            }
            actualColIndex = colIndex - horizontalScrollPosition - lockedColumnCount;
         }
         else if(colIndex == lockedColumnCount)
         {
            horizontalScrollPosition = 0;
            actualColIndex = colIndex - lockedColumnCount;
         }
         else
         {
            if(Boolean(lockedColumnCount))
            {
               if(actualContentHolder == lockedRowContent)
               {
                  actualContentHolder = lockedColumnAndRowContent;
               }
               else
               {
                  actualContentHolder = lockedColumnContent;
               }
            }
            actualColIndex = colIndex;
         }
      }
      
      private function sortByColumn(index:int) : void
      {
         var s:Sort = null;
         var f:SortField = null;
         var dir:String = null;
         var sf:Array = null;
         var i:int = 0;
         var c:DataGridColumn = columns[index];
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
            sortDirection = dir;
            lastSortIndex = sortIndex;
            sortIndex = index;
            sortColumn = c;
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
      
      override mx_internal function columnRendererChanged(c:DataGridColumn) : void
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
         invalidateDisplayList();
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
      
      private function findNextEnterItemRenderer(event:KeyboardEvent) : void
      {
         if(_proposedEditedItemPosition !== undefined)
         {
            return;
         }
         _editedItemPosition = lastEditedItemPosition;
         if(!_editedItemPosition)
         {
            return;
         }
         var rowIndex:int = int(_editedItemPosition.rowIndex);
         var columnIndex:int = int(_editedItemPosition.columnIndex);
         var newIndex:int = _editedItemPosition.rowIndex + (event.shiftKey ? -1 : 1);
         if(newIndex < collection.length && newIndex >= 0)
         {
            rowIndex = newIndex;
         }
         beginningEdit(columnIndex,rowIndex);
      }
      
      override public function set verticalScrollPosition(value:Number) : void
      {
         skipHeaderUpdate = true;
         var oldValue:Number = super.verticalScrollPosition;
         super.verticalScrollPosition = value;
         if(oldValue != value)
         {
            if(Boolean(lockedColumnContent))
            {
               drawRowGraphics(lockedColumnContent);
            }
         }
         skipHeaderUpdate = false;
      }
      
      override public function get columnCount() : int
      {
         if(Boolean(_columns))
         {
            return _columns.length;
         }
         return 0;
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
               lastDropIndex = Boolean(collection) ? collection.length : 0;
            }
         }
         return lastDropIndex;
      }
      
      override protected function measure() : void
      {
         var o:EdgeMetrics = null;
         super.measure();
         if(explicitRowCount != -1)
         {
            measuredHeight += headerHeight;
            measuredMinHeight += headerHeight;
         }
         o = viewMetrics;
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
         if(Boolean(verticalScrollPolicy == ScrollPolicy.AUTO) && Boolean(verticalScrollBar) && verticalScrollBar.visible)
         {
            measuredWidth -= verticalScrollBar.minWidth;
            measuredMinWidth -= verticalScrollBar.minWidth;
         }
         if(Boolean(horizontalScrollPolicy == ScrollPolicy.AUTO) && Boolean(horizontalScrollBar) && horizontalScrollBar.visible)
         {
            measuredHeight -= horizontalScrollBar.minHeight;
            measuredMinHeight -= horizontalScrollBar.minHeight;
         }
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
         invalidateDisplayList();
      }
      
      override protected function mouseDownHandler(event:MouseEvent) : void
      {
         var r:IListItemRenderer = null;
         var s:Sprite = null;
         var pos:Point = null;
         var bEndedEdit:Boolean = false;
         r = mouseEventToItemRenderer(event);
         lastItemDown = null;
         var isItemEditor:Boolean = itemRendererContains(itemEditorInstance,DisplayObject(event.target));
         if(!isItemEditor)
         {
            if(Boolean(r))
            {
               lastItemDown = r;
               pos = itemRendererToIndices(r);
               bEndedEdit = true;
               if(Boolean(itemEditorInstance))
               {
                  if(displayableColumns[pos.x].editable == false)
                  {
                     bEndedEdit = endEdit(DataGridEventReason.OTHER);
                  }
                  else if(Boolean(editedItemPosition))
                  {
                     bEndedEdit = endEdit(editedItemPosition.rowIndex == pos.y ? DataGridEventReason.NEW_COLUMN : DataGridEventReason.NEW_ROW);
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
            else if(Boolean(itemEditorInstance))
            {
               endEdit(DataGridEventReason.OTHER);
            }
            super.mouseDownHandler(event);
            if(Boolean(r))
            {
               if(Boolean(displayableColumns[pos.x].rendererIsEditor))
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
      
      [Inspectable(defaultValue="NaN")]
      public function get minColumnWidth() : Number
      {
         return _minColumnWidth;
      }
      
      private function findNextItemRenderer(shiftKey:Boolean) : Boolean
      {
         var reason:String = null;
         if(!lastEditedItemPosition)
         {
            return false;
         }
         if(_proposedEditedItemPosition !== undefined)
         {
            return true;
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
                  if(endEdit(DataGridEventReason.NEW_ROW))
                  {
                     setEditedItemPosition(null);
                     losingFocus = true;
                     setFocus();
                     return false;
                  }
                  return true;
               }
            }
            if(Boolean(_columns[colIndex].editable) && Boolean(_columns[colIndex].visible))
            {
               found = true;
               reason = index == _editedItemPosition.rowIndex ? DataGridEventReason.NEW_COLUMN : DataGridEventReason.NEW_ROW;
               if(!itemEditorInstance || endEdit(reason))
               {
                  beginningEdit(colIndex,index);
               }
            }
         }
         return found;
      }
      
      protected function clearSeparators() : void
      {
         DataGridHeader(header)._clearSeparators();
         if(Boolean(lockedColumnHeader))
         {
            DataGridHeader(lockedColumnHeader)._clearSeparators();
         }
      }
      
      override protected function mouseEventToItemRenderer(event:MouseEvent) : IListItemRenderer
      {
         var r:IListItemRenderer = null;
         r = super.mouseEventToItemRenderer(event);
         return r == itemEditorInstance ? null : r;
      }
      
      private function deactivateHandler(event:Event) : void
      {
         if(Boolean(itemEditorInstance))
         {
            endEdit(DataGridEventReason.OTHER);
            losingFocus = true;
            setFocus();
         }
      }
      
      override protected function focusInHandler(event:FocusEvent) : void
      {
         var dataGridEvent:DataGridEvent = null;
         var foundOne:Boolean = false;
         if(losingFocus)
         {
            losingFocus = false;
            return;
         }
         if(editable)
         {
            addEventListener(FocusEvent.KEY_FOCUS_CHANGE,keyFocusChangeHandler);
            addEventListener(MouseEvent.MOUSE_DOWN,mouseFocusChangeHandler);
         }
         if(event.target != this)
         {
            if(Boolean(itemEditorInstance) && itemRendererContains(itemEditorInstance,DisplayObject(event.target)))
            {
               return;
            }
            lastItemFocused = DisplayObject(event.target);
            return;
         }
         lastItemFocused = null;
         super.focusInHandler(event);
         if(editable && !isPressed)
         {
            _editedItemPosition = lastEditedItemPosition;
            foundOne = false;
            if(!_editedItemPosition)
            {
               _editedItemPosition = {
                  "rowIndex":0,
                  "columnIndex":0
               };
            }
            while(_editedItemPosition.columnIndex != _columns.length)
            {
               if(Boolean(_columns[_editedItemPosition.columnIndex].editable) && Boolean(_columns[_editedItemPosition.columnIndex].visible))
               {
                  foundOne = true;
                  break;
               }
               ++_editedItemPosition.columnIndex;
            }
            if(foundOne)
            {
               beginningEdit(_editedItemPosition.columnIndex,_editedItemPosition.rowIndex);
            }
         }
      }
      
      [Inspectable(category="Data",defaultValue="undefined")]
      override public function set dataProvider(value:Object) : void
      {
         if(Boolean(itemEditorInstance))
         {
            endEdit(DataGridEventReason.OTHER);
         }
         lastEditedItemPosition = null;
         super.dataProvider = value;
      }
      
      override protected function keyDownHandler(event:KeyboardEvent) : void
      {
         if(Boolean(itemEditorInstance) || event.target != event.currentTarget)
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
      
      protected function drawLinesAndColumnBackgrounds() : void
      {
         drawLinesAndColumnGraphics(listContent,visibleColumns,{});
      }
      
      public function createItemEditor(colIndex:int, rowIndex:int) : void
      {
         var i:int = 0;
         var dx:Number = NaN;
         var dy:Number = NaN;
         var dw:Number = NaN;
         var dh:Number = NaN;
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
         var col:DataGridColumn = displayableColumns[colIndex];
         if(rowIndex >= lockedRowCount)
         {
            rowIndex -= verticalScrollPosition + lockedRowCount;
         }
         if(colIndex >= lockedColumnCount)
         {
            colIndex -= horizontalScrollPosition + lockedColumnCount;
         }
         var item:IListItemRenderer = actualContentHolder.listItems[rowIndex][colIndex];
         var rowData:ListRowInfo = actualContentHolder.rowInfo[rowIndex];
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
               actualContentHolder.addChild(DisplayObject(itemEditorInstance));
            }
            actualContentHolder.setChildIndex(DisplayObject(itemEditorInstance),actualContentHolder.numChildren - 1);
            itemEditorInstance.visible = true;
            itemEditorInstance.move(item.x + dx,rowData.y + dy);
            itemEditorInstance.setActualSize(Math.min(col.width + dw,actualContentHolder.width - 1 - itemEditorInstance.x),Math.min(rowData.height + dh,actualContentHolder.height - itemEditorInstance.y));
            DisplayObject(itemEditorInstance).addEventListener(FocusEvent.FOCUS_OUT,itemEditorFocusOutHandler);
            item.visible = false;
         }
         else
         {
            itemEditorInstance = item;
         }
         DisplayObject(itemEditorInstance).addEventListener(KeyboardEvent.KEY_DOWN,editorKeyDownHandler);
         systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_DOWN,editorMouseDownHandler,true,0,true);
         systemManager.getSandboxRoot().addEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE,editorMouseDownHandler,false,0,true);
         systemManager.addEventListener(Event.RESIZE,editorStageResizeHandler,true,0,true);
         var event:DataGridEvent = new DataGridEvent(DataGridEvent.ITEM_EDITOR_CREATE,false,true,colIndex,null,rowIndex);
         dispatchEvent(event);
      }
      
      [Inspectable(category="General",enumeration="true,false",defaultValue="true")]
      override public function set enabled(value:Boolean) : void
      {
         super.enabled = value;
         if(Boolean(header))
         {
            header.enabled = value;
         }
         if(Boolean(itemEditorInstance))
         {
            endEdit(DataGridEventReason.OTHER);
         }
         invalidateDisplayList();
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
               if(Boolean(itemEditorInstance))
               {
                  endEdit(DataGridEventReason.CANCELLED);
               }
               setEditedItemPosition(null);
               if(generatedColumns)
               {
                  generateCols();
               }
               else
               {
                  columnsInvalid = true;
               }
               updateSortIndexAndDirection();
               if(Boolean(lockedRowContent))
               {
                  lockedRowContent.iterator = collection.createCursor();
               }
               if(Boolean(lockedColumnAndRowContent))
               {
                  lockedColumnAndRowContent.iterator = collection.createCursor();
               }
            }
            else if(ceEvent.kind == CollectionEventKind.REFRESH && !manualSort)
            {
               updateSortIndexAndDirection();
            }
            else if(ceEvent.kind == CollectionEventKind.ADD)
            {
               if(Boolean(editedItemPosition))
               {
                  if(ceEvent.location <= editedItemPosition.rowIndex)
                  {
                     curEditedItemPosition = editedItemPosition;
                     if(inEndEdit)
                     {
                        _editedItemPosition = {
                           "columnIndex":editedItemPosition.columnIndex,
                           "rowIndex":Math.max(0,editedItemPosition.rowIndex + ceEvent.items.length)
                        };
                     }
                     else if(Boolean(itemEditorInstance))
                     {
                        _editedItemPosition = {
                           "columnIndex":editedItemPosition.columnIndex,
                           "rowIndex":Math.max(0,editedItemPosition.rowIndex + ceEvent.items.length)
                        };
                        itemEditorPositionChanged = true;
                        lastEditedItemPosition = _editedItemPosition;
                     }
                     else
                     {
                        setEditedItemPosition({
                           "columnIndex":curEditedItemPosition.columnIndex,
                           "rowIndex":Math.max(0,curEditedItemPosition.rowIndex + ceEvent.items.length)
                        });
                     }
                  }
               }
            }
            else if(ceEvent.kind == CollectionEventKind.REMOVE)
            {
               if(Boolean(editedItemPosition))
               {
                  if(collection.length == 0)
                  {
                     if(Boolean(itemEditorInstance))
                     {
                        endEdit(DataGridEventReason.CANCELLED);
                     }
                     setEditedItemPosition(null);
                  }
                  else if(ceEvent.location <= editedItemPosition.rowIndex)
                  {
                     curEditedItemPosition = editedItemPosition;
                     if(ceEvent.location == editedItemPosition.rowIndex && Boolean(itemEditorInstance))
                     {
                        endEdit(DataGridEventReason.CANCELLED);
                     }
                     if(inEndEdit)
                     {
                        _editedItemPosition = {
                           "columnIndex":editedItemPosition.columnIndex,
                           "rowIndex":Math.max(0,editedItemPosition.rowIndex - ceEvent.items.length)
                        };
                     }
                     else if(Boolean(itemEditorInstance))
                     {
                        _editedItemPosition = {
                           "columnIndex":editedItemPosition.columnIndex,
                           "rowIndex":Math.max(0,editedItemPosition.rowIndex - ceEvent.items.length)
                        };
                        itemEditorPositionChanged = true;
                        lastEditedItemPosition = _editedItemPosition;
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
                     endEdit(DataGridEventReason.CANCELLED);
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
            else if(ce.kind == CollectionEventKind.REFRESH)
            {
               if(Boolean(lockedRowCount) && Boolean(lockedRowContent))
               {
                  lockedRowContent.iterator.seek(CursorBookmark.FIRST,0);
               }
            }
         }
      }
      
      override protected function get dragImage() : IUIComponent
      {
         var image:DataGridDragProxy = new DataGridDragProxy();
         image.owner = this;
         image.moduleFactory = moduleFactory;
         return image;
      }
      
      [Inspectable(defaultValue="true")]
      public function get draggableColumns() : Boolean
      {
         return _draggableColumns;
      }
      
      protected function drawSeparators() : void
      {
         DataGridHeader(header)._drawSeparators();
         if(Boolean(lockedColumnHeader))
         {
            DataGridHeader(lockedColumnHeader)._drawSeparators();
         }
      }
      
      override protected function scrollVertically(pos:int, deltaPos:int, scrollUp:Boolean) : void
      {
         super.scrollVertically(pos,deltaPos,scrollUp);
         if(Boolean(getStyle("horizontalGridLines")))
         {
            drawLinesAndColumnGraphics(listContent,visibleColumns,{});
            if(Boolean(lockedColumnCount))
            {
               drawLinesAndColumnGraphics(lockedColumnContent,visibleLockedColumns,{"right":1});
            }
         }
      }
      
      override public function get baselinePosition() : Number
      {
         var top:Number = NaN;
         if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)
         {
            top = 0;
            if(Boolean(border) && border is IRectangularBorder)
            {
               top = Number(IRectangularBorder(border).borderMetrics.top);
            }
            return top + measureText(" ").ascent;
         }
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
      
      private function displayingPartialRow() : Boolean
      {
         var index:int = listItems.length - 1 - offscreenExtraRowsBottom;
         if(rowInfo[index].y + rowInfo[index].height > listContent.heightExcludingOffsets - listContent.topOffset)
         {
            return true;
         }
         return false;
      }
      
      mx_internal function calculateHeaderHeight() : Number
      {
         var item:IListItemRenderer = null;
         var c:DataGridColumn = null;
         var rowData:DataGridListData = null;
         var n:int = 0;
         var j:int = 0;
         if(!columns.length)
         {
            return rowHeight;
         }
         if(!listContent)
         {
            return rowHeight;
         }
         var ch:Number = 0;
         var paddingTop:Number = getStyle("paddingTop");
         var paddingBottom:Number = getStyle("paddingBottom");
         if(showHeaders)
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
                     _headerWordWrapPresent = true;
                  }
               }
            }
            if(_headerWordWrapPresent)
            {
               _originalHeaderHeight = _headerHeight;
               _originalExplicitHeaderHeight = _explicitHeaderHeight;
               _headerHeight = ch;
               _explicitHeaderHeight = true;
            }
         }
         return ch;
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
         if(columns.length == 0)
         {
            visibleColumns = [];
            visibleLockedColumns = [];
            lockedColumnWidth = 0;
            columnsInvalid = false;
            return;
         }
         if(columnsInvalid)
         {
            columnsInvalid = false;
            visibleColumns = [];
            visibleLockedColumns = [];
            lockedColumnWidth = 0;
            if(minColumnWidthInvalid)
            {
               n = int(columns.length);
               for(i = 0; i < n; i++)
               {
                  columns[i].minWidth = minColumnWidth;
               }
               minColumnWidthInvalid = false;
            }
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
            if(horizontalScrollPolicy == ScrollPolicy.OFF)
            {
               n = int(displayableColumns.length);
               for(i = 0; i < n; i++)
               {
                  col = displayableColumns[i];
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
                     if(i < lockedColumnCount)
                     {
                        lockedColumnWidth += Math.max(isNaN(col.explicitWidth) ? col.preferredWidth : col.explicitWidth,col.minWidth);
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
            newTotal = displayWidth;
            if(displayWidth > fixedWidth && Boolean(numResizable))
            {
               n = int(visibleLockedColumns.length);
               for(i = 0; i < n; i++)
               {
                  if(Boolean(visibleLockedColumns[i].resizable) && Boolean(!visibleLockedColumns[i].newlyVisible) && isNaN(visibleLockedColumns[i].explicitWidth))
                  {
                     lastColumn = visibleLockedColumns[i];
                     if(totalWidth > displayWidth)
                     {
                        ratio = (lastColumn.width - lastColumn.minWidth) / (totalWidth - fixedWidth);
                     }
                     else
                     {
                        ratio = lastColumn.width / totalWidth;
                     }
                     newSize = lastColumn.width - (totalWidth - displayWidth) * ratio;
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
                  newSize = displayWidth * ratio;
                  lastColumn.setWidth(newSize);
                  lastColumn.explicitWidth = NaN;
                  newTotal -= newSize;
               }
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
               if(totalWidth > displayWidth - lockedColumnWidth)
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
            if(totalWidth < displayWidth - lockedColumnWidth && i < displayableColumns.length)
            {
               n = int(displayableColumns.length);
               while(i < n && totalWidth < displayWidth - lockedColumnWidth)
               {
                  col = displayableColumns[i];
                  visibleColumns.push(col);
                  totalWidth += isNaN(col.explicitWidth) ? col.preferredWidth : col.explicitWidth;
                  i++;
               }
            }
            else if(totalWidth < displayWidth - lockedColumnWidth && horizontalScrollPosition > 0)
            {
               while(totalWidth < displayWidth - lockedColumnWidth && horizontalScrollPosition > 0)
               {
                  col = displayableColumns[lockedColumnCount + horizontalScrollPosition - 1];
                  cw = isNaN(col.explicitWidth) ? col.preferredWidth : col.explicitWidth;
                  if(cw >= displayWidth - lockedColumnWidth - totalWidth)
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
            newSize = cw + displayWidth - lockedColumnWidth - totalWidth;
            if(lastColumn == displayableColumns[displayableColumns.length - 1] && lastColumn.resizable && newSize >= lastColumn.minWidth && newSize > cw)
            {
               lastColumn.setWidth(newSize);
               maxHorizontalScrollPosition = displayableColumns.length - visibleColumns.length;
            }
            else if(visibleColumns.length == 1 && lastColumn == displayableColumns[displayableColumns.length - 1])
            {
               maxHorizontalScrollPosition = displayableColumns.length - visibleColumns.length;
            }
            else
            {
               maxHorizontalScrollPosition = displayableColumns.length - visibleColumns.length + 1;
            }
         }
         lockedColumnWidth = 0;
         if(Boolean(visibleLockedColumns.length))
         {
            n = int(visibleLockedColumns.length);
            for(i = 0; i < n; i++)
            {
               col = visibleLockedColumns[i];
               lockedColumnWidth += col.width;
            }
         }
      }
      
      private function beginningEdit(columnIndex:int, rowIndex:int, itemRenderer:IListItemRenderer = null) : void
      {
         var dataGridEvent:DataGridEvent = new DataGridEvent(DataGridEvent.ITEM_EDIT_BEGINNING,false,true);
         dataGridEvent.columnIndex = columnIndex;
         dataGridEvent.dataField = _columns[columnIndex].dataField;
         dataGridEvent.rowIndex = rowIndex;
         dataGridEvent.itemRenderer = itemRenderer;
         if(!dispatchEvent(dataGridEvent))
         {
            lastEditedItemPosition = {
               "columnIndex":columnIndex,
               "rowIndex":rowIndex
            };
         }
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
         colors = getStyle("alternatingItemColors");
         if(!colors || colors.length == 0)
         {
            while(rowBGs.numChildren > n)
            {
               rowBGs.removeChildAt(rowBGs.numChildren - 1);
            }
            return;
         }
         StyleManager.getColorNames(colors);
         var curRow:int = 0;
         var i:int = 0;
         var actualRow:int = verticalScrollPosition;
         n = int(contentHolder.listItems.length);
         while(curRow < n)
         {
            drawRowBackground(rowBGs,i++,contentHolder.rowInfo[curRow].y,contentHolder.rowInfo[curRow].height,colors[actualRow % colors.length],actualRow);
            curRow++;
            actualRow++;
         }
         while(rowBGs.numChildren > i)
         {
            rowBGs.removeChildAt(rowBGs.numChildren - 1);
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
      
      override protected function initializeAccessibility() : void
      {
         if(DataGrid.createAccessibilityImplementation != null)
         {
            DataGrid.createAccessibilityImplementation(this);
         }
      }
      
      private function endEdit(reason:String) : Boolean
      {
         if(!editedItemRenderer)
         {
            return true;
         }
         inEndEdit = true;
         var dataGridEvent:DataGridEvent = new DataGridEvent(DataGridEvent.ITEM_EDIT_END,false,true);
         dataGridEvent.columnIndex = editedItemPosition.columnIndex;
         dataGridEvent.dataField = _columns[editedItemPosition.columnIndex].dataField;
         dataGridEvent.rowIndex = editedItemPosition.rowIndex;
         dataGridEvent.itemRenderer = editedItemRenderer;
         dataGridEvent.reason = reason;
         dispatchEvent(dataGridEvent);
         dontEdit = itemEditorInstance != null;
         if(!dontEdit && reason == DataGridEventReason.CANCELLED)
         {
            losingFocus = true;
            setFocus();
         }
         inEndEdit = false;
         return !dataGridEvent.isDefaultPrevented();
      }
      
      private function editorKeyDownHandler(event:KeyboardEvent) : void
      {
         if(event.keyCode == Keyboard.ESCAPE)
         {
            endEdit(DataGridEventReason.CANCELLED);
         }
         else if(event.ctrlKey && event.charCode == 46)
         {
            endEdit(DataGridEventReason.CANCELLED);
         }
         else if(event.charCode == Keyboard.ENTER && event.keyCode != 229)
         {
            if(!_editedItemPosition)
            {
               return;
            }
            if(Boolean(columns[_editedItemPosition.columnIndex].editorUsesEnterKey))
            {
               return;
            }
            if(endEdit(DataGridEventReason.NEW_ROW) && !dontEdit)
            {
               findNextEnterItemRenderer(event);
            }
         }
      }
      
      private function itemEditorFocusOutHandler(event:FocusEvent) : void
      {
         if(Boolean(event.relatedObject) && contains(event.relatedObject))
         {
            return;
         }
         if(!event.relatedObject)
         {
            return;
         }
         if(Boolean(itemEditorInstance))
         {
            endEdit(DataGridEventReason.OTHER);
         }
      }
      
      override public function itemToLabel(data:Object) : String
      {
         return displayableColumns[sortIndex == -1 ? 0 : sortIndex].itemToLabel(data);
      }
      
      mx_internal function _drawSeparators() : void
      {
         drawSeparators();
      }
      
      override protected function configureScrollBars() : void
      {
         var colX:int = 0;
         var i:int = 0;
         if(columnsInvalid)
         {
            return;
         }
         if(!displayableColumns)
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
         if(rowCount > 1 && displayingPartialRow())
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
            if(adjustVerticalScrollPositionDownward(Math.max(rowCount,1)))
            {
               return;
            }
         }
         rowCount -= offscreenExtraRowsTop + offscreenExtraRowsBottom;
         var collectionHasRows:Boolean = Boolean(collection) && collection.length > 0;
         var colCount:int = collectionHasRows && rowCount > 0 ? int(listItems[0].length) : int(visibleColumns.length);
         if(collectionHasRows && rowCount > 0 && colCount > 1 && listItems[0][colCount - 1].x + visibleColumns[colCount - 1].width > displayWidth - listContent.x + viewMetrics.left)
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
            if(colX > displayWidth - listContent.x + viewMetrics.left)
            {
               colCount--;
            }
         }
         setScrollBarProperties(displayableColumns.length - lockedColumnCount,Math.max(colCount,1),Boolean(collection) ? int(collection.length - lockedRowCount) : 0,Math.max(rowCount,1));
         if((Boolean(!verticalScrollBar || !verticalScrollBar.visible)) && Boolean(collection) && collection.length - lockedRowCount > rowCount)
         {
            maxVerticalScrollPosition = collection.length - lockedRowCount - rowCount;
         }
         if((!horizontalScrollBar || !horizontalScrollBar.visible) && displayableColumns.length - lockedColumnCount > colCount - lockedColumnCount)
         {
            maxHorizontalScrollPosition = displayableColumns.length - lockedColumnCount - colCount;
         }
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
         calculateColumnSizes();
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
            makeRowsAndColumns(0,0,listContent.width,listContent.height,0,0);
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
            invalidateDisplayList();
            addClipMask(false);
         }
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
      
      override public function set columns(value:Array) : void
      {
         var n:int = 0;
         var i:int = 0;
         var column:DataGridColumn = null;
         var item:DisplayObject = null;
         n = int(_columns.length);
         for(i = 0; i < n; i++)
         {
            columnRendererChanged(_columns[i]);
         }
         freeItemRenderersTable = new Dictionary(false);
         columnMap = {};
         _columns = value.slice(0);
         columnsInvalid = true;
         generatedColumns = false;
         n = int(value.length);
         for(i = 0; i < n; i++)
         {
            column = _columns[i];
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
         updateSortIndexAndDirection();
         itemsSizeChanged = true;
         invalidateDisplayList();
         dispatchEvent(new Event("columnsChanged"));
      }
      
      override protected function mouseWheelHandler(event:MouseEvent) : void
      {
         if(Boolean(itemEditorInstance))
         {
            endEdit(DataGridEventReason.OTHER);
         }
         super.mouseWheelHandler(event);
      }
      
      public function get editedItemRenderer() : IListItemRenderer
      {
         if(!itemEditorInstance)
         {
            return null;
         }
         return actualContentHolder.listItems[actualRowIndex][actualColIndex];
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
         if(!value && Boolean(_focusPane))
         {
            _focusPane.mask = null;
         }
         _focusPane = value;
      }
      
      override mx_internal function get rendererArray() : Array
      {
         var arr:Array = listItems.slice();
         var arr2:Array = DataGridHeader(header).rendererArray;
         arr.unshift(arr2);
         return arr;
      }
      
      override protected function commitProperties() : void
      {
         var paddingTop:Number = NaN;
         var paddingBottom:Number = NaN;
         var data:Object = null;
         var item:IListItemRenderer = null;
         var c:DataGridColumn = null;
         var ch:Number = NaN;
         var n:int = 0;
         var j:int = 0;
         super.commitProperties();
         if(itemsNeedMeasurement)
         {
            itemsNeedMeasurement = false;
            if(isNaN(explicitRowHeight))
            {
               if(Boolean(iterator) && columns.length > 0)
               {
                  visibleColumns = columns;
                  columnsInvalid = true;
                  paddingTop = getStyle("paddingTop");
                  paddingBottom = getStyle("paddingBottom");
                  data = iterator.current;
                  ch = 0;
                  n = int(columns.length);
                  for(j = 0; j < n; j++)
                  {
                     c = columns[j];
                     if(c.visible)
                     {
                        item = c.getMeasuringRenderer(false,data);
                        if(DisplayObject(item).parent == null)
                        {
                           listContent.addChild(DisplayObject(item));
                        }
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
         var paddingTop:Number = getStyle("paddingTop");
         var paddingBottom:Number = getStyle("paddingBottom");
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
               bMore = iterator.movePrevious();
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
                        item = c.getMeasuringRenderer(false,data);
                        if(DisplayObject(item).parent == null)
                        {
                           listContent.addChild(DisplayObject(item));
                        }
                        setupRendererFromData(c,item,data);
                     }
                     ch = Math.max(ch,variableRowHeight ? item.getExplicitOrMeasuredHeight() + paddingBottom + paddingTop : rowHeight);
                  }
               }
            }
            h -= ch;
            try
            {
               bMore = iterator.movePrevious();
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
      
      override protected function calculateRowHeight(data:Object, hh:Number, skipVisible:Boolean = false) : Number
      {
         var item:IListItemRenderer = null;
         var c:DataGridColumn = null;
         var j:int = 0;
         var n:int = int(columns.length);
         var k:int = 0;
         var l:int = int(visibleLockedColumns.length);
         if(skipVisible && visibleColumns.length == _columns.length)
         {
            return hh;
         }
         var paddingTop:Number = getStyle("paddingTop");
         var paddingBottom:Number = getStyle("paddingBottom");
         for(j = 0; j < n; j++)
         {
            if(skipVisible && k < l && visibleLockedColumns[k].colNum == columns[j].colNum)
            {
               k++;
            }
            else if(skipVisible && k - l < visibleColumns.length && visibleColumns[k - l].colNum == columns[j].colNum)
            {
               k++;
            }
            else
            {
               c = columns[j];
               if(c.visible)
               {
                  item = c.getMeasuringRenderer(false,data);
                  if(DisplayObject(item).parent == null)
                  {
                     listContent.addChild(DisplayObject(item));
                  }
                  setupRendererFromData(c,item,data);
                  hh = Math.max(hh,item.getExplicitOrMeasuredHeight() + paddingBottom + paddingTop);
               }
            }
         }
         return hh;
      }
      
      [Inspectable(category="General",arrayType="mx.controls.dataGridClasses.DataGridColumn")]
      [Bindable("columnsChanged")]
      override public function get columns() : Array
      {
         return _columns.slice(0);
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
                  endEdit(DataGridEventReason.OTHER);
               }
               scrollBar = ScrollBar(event.target);
               pos = scrollBar.scrollPosition;
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
      
      public function isItemEditable(data:Object) : Boolean
      {
         if(!editable)
         {
            return false;
         }
         if(!data)
         {
            return false;
         }
         return true;
      }
      
      mx_internal function _placeSortArrow() : void
      {
         placeSortArrow();
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
         var tmpHeight:Number = unscaledHeight - 1;
         var len:uint = Boolean(visibleColumns) ? visibleColumns.length : 0;
         var rowlen:uint = contentHolder.listItems.length;
         lineCol = getStyle("horizontalGridLineColor");
         if(Boolean(getStyle("horizontalGridLines")))
         {
            for(i = 0; i < rowlen; i++)
            {
               yy = rowInfo[i].y + rowInfo[i].height;
               if(yy < contentHolder.height)
               {
                  drawHorizontalSeparator(linesBody,i,lineCol,yy);
               }
            }
         }
         if(Boolean(separators.top))
         {
            drawHorizontalSeparator(linesBody,i++,0,rowInfo[0].y,true);
         }
         if(Boolean(separators.bottom) && rowlen > 0)
         {
            drawHorizontalSeparator(linesBody,i++,0,rowInfo[rowlen - 1].y + rowInfo[rowlen - 1].height,true);
         }
         var vLines:Boolean = getStyle("verticalGridLines");
         lineCol = getStyle("verticalGridLineColor");
         if(Boolean(len))
         {
            colBGs = Sprite(contentHolder.getChildByName("colBGs"));
            lastChild = -1;
            xx = 0;
            for(i = 0; i < len; i++)
            {
               if(vLines && i < len - 1)
               {
                  drawVerticalSeparator(linesBody,i,lineCol,xx + visibleColumns[i].width);
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
               drawVerticalSeparator(linesBody,i++,0,contentHolder.listItems[0][len - 1].x + visibleColumns[len - 1].width,true);
            }
            else
            {
               xx = 0;
               for(i = 0; i < len; i++)
               {
                  xx += visibleColumns[i].width;
               }
               drawVerticalSeparator(linesBody,i++,0,xx,true);
            }
         }
         if(Boolean(separators.left))
         {
            drawVerticalSeparator(linesBody,i++,0,0,true);
         }
      }
      
      protected function placeSortArrow() : void
      {
         DataGridHeader(header)._placeSortArrow();
         if(Boolean(lockedColumnHeader))
         {
            DataGridHeader(lockedColumnHeader)._placeSortArrow();
         }
      }
      
      private function commitEditedItemPosition(coord:Object) : void
      {
         var reason:String = null;
         var i:int = 0;
         var evt:ListEvent = null;
         if(!enabled || !editable)
         {
            return;
         }
         if(!collection || collection.length == 0)
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
               reason = DataGridEventReason.OTHER;
            }
            else
            {
               reason = !editedItemPosition || coord.rowIndex == editedItemPosition.rowIndex ? DataGridEventReason.NEW_COLUMN : DataGridEventReason.NEW_ROW;
            }
            if(!endEdit(reason) && reason != DataGridEventReason.OTHER)
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
         scrollToEditedItem(rowIndex,colIndex);
         var item:IListItemRenderer = actualContentHolder.listItems[actualRowIndex][actualColIndex];
         if(!item)
         {
            commitEditedItemPosition(null);
            return;
         }
         if(!isItemEditable(item.data))
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
         var event:DataGridEvent = new DataGridEvent(DataGridEvent.ITEM_EDIT_BEGIN,false,true);
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
      
      protected function getCurrentDataValue(data:Object, property:String) : String
      {
         if(!isComplexColumn(property))
         {
            return data[property];
         }
         var complexFieldNameComponents:Array = property.split(".");
         var obj:Object = deriveComplexFieldReference(data,complexFieldNameComponents);
         return String(obj);
      }
      
      private function editorStageResizeHandler(event:Event) : void
      {
         if(event.target is DisplayObjectContainer && DisplayObjectContainer(event.target).contains(this))
         {
            endEdit(DataGridEventReason.OTHER);
         }
      }
      
      private function generateColumnsPendingResultHandler(data:Object, info:ListBaseSeekPending) : void
      {
         if(columns.length == 0)
         {
            generateCols();
         }
         seekPendingResultHandler(data,info);
      }
      
      protected function drawVerticalLine(s:Sprite, colIndex:int, color:uint, x:Number) : void
      {
         var contentHolder:ListBaseContentHolder = s.parent.parent as ListBaseContentHolder;
         var g:Graphics = s.graphics;
         g.lineStyle(1,color,100);
         g.moveTo(x,headerVisible ? 0 : 1);
         g.lineTo(x,contentHolder.height);
      }
      
      private function editorMouseDownHandler(event:Event) : void
      {
         if(event is MouseEvent && owns(DisplayObject(event.target)))
         {
            return;
         }
         endEdit(DataGridEventReason.OTHER);
         losingFocus = true;
         setFocus();
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
               hh = lockedColumnHeader.getExplicitOrMeasuredHeight();
               lockedColumnHeader.setActualSize(lockedColumnWidth + 1,hh);
               DataGridHeader(lockedColumnHeader).needRightSeparator = true;
               DataGridHeader(lockedColumnHeader).needRightSeparatorEvents = true;
            }
            header.visible = true;
            hcx = viewMetrics.left + lockedColumnWidth + Math.min(DataGridHeader(header).leftOffset,0);
            header.move(hcx,viewMetrics.top);
            if(verticalScrollBar != null && verticalScrollBar.visible && (horizontalScrollBar == null || !horizontalScrollBar.visible) && headerVisible && roomForScrollBar(verticalScrollBar,unscaledWidth,unscaledHeight - header.height))
            {
               ww = Math.max(0,DataGridHeader(header).rightOffset) - hcx - borderMetrics.right;
            }
            else
            {
               ww = Math.max(0,DataGridHeader(header).rightOffset) - hcx - viewMetrics.right;
            }
            hh = header.getExplicitOrMeasuredHeight();
            header.setActualSize(unscaledWidth + ww,hh);
            if(!skipHeaderUpdate)
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
                  lockedColumnAndRowContent.setActualSize(lockedColumnWidth,lockedColumnAndRowContent.getExplicitOrMeasuredHeight());
               }
               lcx = viewMetrics.left + lockedColumnWidth + Math.min(lockedRowContent.leftOffset,0);
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
            ww = lockedColumnWidth + lockedColumnContent.rightOffset - lockedColumnContent.leftOffset;
            lockedColumnContent.setActualSize(ww,unscaledHeight + Math.max(0,lockedColumnContent.bottomOffset) - lcy - viewMetrics.bottom);
         }
         lcx = viewMetrics.left + lockedColumnWidth + Math.min(listContent.leftOffset,0);
         lcy = viewMetrics.top + Math.min(listContent.topOffset,0) + Math.ceil(hh);
         listContent.move(lcx,lcy);
         ww = Math.max(0,listContent.rightOffset) - lcx - viewMetrics.right;
         hh = Math.max(0,listContent.bottomOffset) - lcy - viewMetrics.bottom;
         listContent.setActualSize(Math.max(0,unscaledWidth + ww),Math.max(0,unscaledHeight + hh));
      }
      
      mx_internal function setupRendererFromData(c:DataGridColumn, item:IListItemRenderer, data:Object) : void
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
            super.itemRenderer = new ContextualClassFactory(DataGridItemRenderer,flexModuleFactory);
         }
         return super.itemRenderer;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var hh:Number = NaN;
         var bm:EdgeMetrics = null;
         if(displayWidth != unscaledWidth - viewMetrics.right - viewMetrics.left)
         {
            displayWidth = unscaledWidth - viewMetrics.right - viewMetrics.left;
            columnsInvalid = true;
         }
         calculateColumnSizes();
         if(itemEditorPositionChanged)
         {
            itemEditorPositionChanged = false;
            if(!lastItemDown)
            {
               scrollToEditedItem(editedItemPosition.rowIndex,editedItemPosition.colIndex);
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
         if(verticalScrollBar != null && verticalScrollBar.visible && (horizontalScrollBar == null || !horizontalScrollBar.visible) && headerVisible)
         {
            hh = header.height;
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
         if(bEditedItemPositionChanged)
         {
            bEditedItemPositionChanged = false;
            if(!lastItemDown)
            {
               commitEditedItemPosition(_proposedEditedItemPosition);
            }
            _proposedEditedItemPosition = undefined;
            itemsSizeChanged = false;
         }
         drawRowBackgrounds();
         drawLinesAndColumnBackgrounds();
         if(Boolean(lockedRowCount) && Boolean(lockedRowContent))
         {
            drawRowGraphics(lockedRowContent);
            drawLinesAndColumnGraphics(lockedRowContent,visibleColumns,{"bottom":1});
            if(Boolean(lockedColumnCount))
            {
               drawRowGraphics(lockedColumnAndRowContent);
               drawLinesAndColumnGraphics(lockedColumnAndRowContent,visibleLockedColumns,{
                  "right":1,
                  "bottom":1
               });
            }
         }
         if(Boolean(lockedColumnCount))
         {
            drawRowGraphics(lockedColumnContent);
            drawLinesAndColumnGraphics(lockedColumnContent,visibleLockedColumns,{"right":1});
         }
      }
      
      mx_internal function shiftColumns(oldIndex:int, newIndex:int, trigger:Event = null) : void
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
               c = _columns[i];
               _columns[i] = _columns[j];
               _columns[j] = c;
               _columns[i].colNum = i;
               _columns[j].colNum = j;
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
            invalidateDisplayList();
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
      
      override public function hideDropFeedback(event:DragEvent) : void
      {
         super.hideDropFeedback(event);
         if(Boolean(lockedColumnDropIndicator))
         {
            DisplayObject(lockedColumnDropIndicator).parent.removeChild(DisplayObject(lockedColumnDropIndicator));
            lockedColumnDropIndicator = null;
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
      
      protected function drawHeaderBackground(headerBG:UIComponent) : void
      {
         DataGridHeader(headerBG.parent)._drawHeaderBackground(headerBG);
      }
   }
}

