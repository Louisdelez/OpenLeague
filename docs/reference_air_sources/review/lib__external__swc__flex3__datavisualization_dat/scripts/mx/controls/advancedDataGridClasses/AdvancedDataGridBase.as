package mx.controls.advancedDataGridClasses
{
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   import mx.collections.ArrayCollection;
   import mx.collections.CursorBookmark;
   import mx.collections.ItemResponder;
   import mx.collections.errors.ChildItemPendingError;
   import mx.collections.errors.ItemPendingError;
   import mx.controls.listClasses.AdvancedListBase;
   import mx.controls.listClasses.AdvancedListBaseContentHolder;
   import mx.controls.listClasses.BaseListData;
   import mx.controls.listClasses.IDropInListItemRenderer;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.controls.listClasses.ListBaseSeekPending;
   import mx.controls.listClasses.ListRowInfo;
   import mx.core.IFactory;
   import mx.core.IFlexModuleFactory;
   import mx.core.IFontContextComponent;
   import mx.core.IInvalidating;
   import mx.core.IUIComponent;
   import mx.core.UIComponentGlobals;
   import mx.events.ListEvent;
   import mx.events.ScrollEvent;
   import mx.events.ScrollEventDetail;
   import mx.events.ScrollEventDirection;
   import mx.events.TweenEvent;
   
   [Exclude(name="maxVerticalScrollPosition",kind="property")]
   [Exclude(name="maxHorizontalScrollPosition",kind="property")]
   public class AdvancedDataGridBase extends AdvancedListBase implements IFontContextComponent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      public static const NONE:String = "none";
      
      public static const SINGLE_ROW:String = "singleRow";
      
      public static const MULTIPLE_ROWS:String = "multipleRows";
      
      public static const SINGLE_CELL:String = "singleCell";
      
      public static const MULTIPLE_CELLS:String = "multipleCells";
      
      protected var itemPending:Boolean;
      
      protected var cellsWaitingToBeDisplayed:Boolean = true;
      
      private var _showHeaders:Boolean = true;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var visibleColumns:Array;
      
      private var _sortItemRenderer:IFactory;
      
      protected var freeItemRenderersTable:Dictionary;
      
      protected var currentRowNum:int;
      
      protected var columnMap:Object;
      
      protected var currentRowHeight:Number;
      
      protected var visibleHeaderInfos:Array;
      
      protected var bSelectItem:Boolean = false;
      
      protected var bCtrlKey:Boolean = false;
      
      public var headerItems:Array = [];
      
      private var _headerWordWrap:Boolean;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _explicitHeaderHeight:Boolean;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var listSubContent:AdvancedListBaseContentHolder;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var columnsInvalid:Boolean = true;
      
      protected var headerRowInfo:Array = [];
      
      protected var _selectionMode:String = "singleRow";
      
      protected var currentItemTop:Number;
      
      private var _headerRenderer:IFactory;
      
      private var lockedRowCountResetShowHeaders:Boolean = false;
      
      protected var _columns:Array;
      
      private var _styleFunction:Function;
      
      protected var currentColNum:int;
      
      protected var itemRendererToFactoryMap:Dictionary;
      
      protected var lastKey:uint = 0;
      
      protected var pendingCellSelection:ArrayCollection = new ArrayCollection([]);
      
      protected var headerInfos:Array;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _headerHeight:Number = 22;
      
      protected var bShiftKey:Boolean = false;
      
      public function AdvancedDataGridBase()
      {
         super();
         listType = "vertical";
         lockedRowCount = 0;
         defaultRowCount = 7;
         columnMap = {};
         freeItemRenderersTable = new Dictionary(false);
         itemRendererToFactoryMap = new Dictionary(true);
      }
      
      protected function isCellSelectionMode() : Boolean
      {
         return selectionMode == SINGLE_CELL || selectionMode == MULTIPLE_CELLS;
      }
      
      protected function setSelectionMode(newSelectionMode:String) : void
      {
         if(selectionMode == newSelectionMode)
         {
            return;
         }
         if(newSelectionMode == NONE)
         {
            selectable = false;
         }
         else if(!selectable)
         {
            selectable = true;
         }
         if(newSelectionMode == SINGLE_ROW || newSelectionMode == SINGLE_CELL)
         {
            if(allowMultipleSelection)
            {
               allowMultipleSelection = false;
            }
         }
         else if(newSelectionMode == MULTIPLE_ROWS || newSelectionMode == MULTIPLE_CELLS)
         {
            if(!allowMultipleSelection)
            {
               allowMultipleSelection = true;
            }
         }
         else if(newSelectionMode != NONE)
         {
            newSelectionMode = SINGLE_ROW;
            if(allowMultipleSelection)
            {
               allowMultipleSelection = false;
            }
         }
         clearAllSelection();
         _selectionMode = newSelectionMode;
      }
      
      protected function clearAllSelection() : void
      {
         if(isRowSelectionMode())
         {
            clearSelected();
            clearIndicators();
         }
      }
      
      [Inspectable(category="General",defaultValue="22")]
      [Bindable("resize")]
      public function get headerHeight() : Number
      {
         return _headerHeight;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function columnHeaderWordWrap(c:AdvancedDataGridColumn) : Boolean
      {
         if(c.headerWordWrap == true)
         {
            return true;
         }
         if(c.headerWordWrap == false)
         {
            return false;
         }
         return headerWordWrap;
      }
      
      protected function createLockedRows(left:Number, top:Number, right:Number, bottom:Number) : void
      {
         var i:int = 0;
         var bookmark:CursorBookmark = null;
         var more:Boolean = true;
         var numLocked:int = lockedRowCount;
         var rowsMade:int = 0;
         if(lockedRowCount > 0 && (!listItems[lockedRowCount - 1] || !listItems[lockedRowCount - 1][0] || top < listItems[lockedRowCount - 1][0].y + listItems[lockedRowCount - 1][0].height))
         {
            currentRowNum = 0;
            if(Boolean(numLocked) && Boolean(iterator))
            {
               bookmark = iterator.bookmark;
               try
               {
                  iterator.seek(CursorBookmark.FIRST);
               }
               catch(e:ItemPendingError)
               {
                  lastSeekPending = new ListBaseSeekPending(CursorBookmark.FIRST,0);
                  e.addResponder(new ItemResponder(seekPendingResultHandler,seekPendingFailureHandler,lastSeekPending));
                  iteratorValid = false;
               }
            }
            more = iterator != null && !iterator.afterLast && iteratorValid;
            for(i = 0; i < numLocked; i++)
            {
               createRow(left,top,right,bottom,more);
               more = moveIterator(more);
               rowsMade++;
            }
            if(Boolean(bookmark))
            {
               try
               {
                  iterator.seek(bookmark,numLocked);
               }
               catch(e:ItemPendingError)
               {
                  lastSeekPending = new ListBaseSeekPending(CursorBookmark.CURRENT,0);
                  e.addResponder(new ItemResponder(seekPendingResultHandler,seekPendingFailureHandler,lastSeekPending));
                  iteratorValid = false;
               }
            }
         }
      }
      
      override protected function finishKeySelection() : void
      {
         var uid:String = null;
         var listItem:IListItemRenderer = null;
         var evt:ListEvent = null;
         var pt:Point = null;
         var rowCount:int = int(listItems.length);
         var partialRow:int = rowInfo[rowCount - 1].y + rowInfo[rowCount - 1].height > listContent.height ? 1 : 0;
         if(lastKey == Keyboard.PAGE_DOWN)
         {
            if(lockedRowCount >= rowCount - partialRow - 1)
            {
               caretIndex = Math.min(verticalScrollPosition + lockedRowCount,collection.length - 1);
            }
            else
            {
               caretIndex = Math.min(verticalScrollPosition + rowCount - partialRow - 1,collection.length - 1);
            }
         }
         var bSelChanged:Boolean = false;
         if(bSelectItem && caretIndex - verticalScrollPosition >= 0)
         {
            if(caretIndex - verticalScrollPosition > listItems.length - 1)
            {
               caretIndex = listItems.length - 1 + verticalScrollPosition;
            }
            listItem = listItems[caretIndex - verticalScrollPosition][0];
            if(Boolean(listItem))
            {
               uid = itemToUID(listItem.data);
               listItem = visibleData[uid];
               if(Boolean(listItem))
               {
                  if(lastKey == Keyboard.SPACE)
                  {
                     bSelChanged = selectItem(listItem,bShiftKey,bCtrlKey);
                  }
                  else
                  {
                     if(!bCtrlKey)
                     {
                        selectItem(listItem,bShiftKey,bCtrlKey);
                        bSelChanged = true;
                     }
                     if(bCtrlKey)
                     {
                        drawItem(listItem,selectedData[uid] != null,uid == highlightUID,true);
                     }
                  }
               }
            }
         }
         if(bSelChanged)
         {
            evt = new ListEvent(ListEvent.CHANGE);
            evt.itemRenderer = listItem;
            pt = itemRendererToIndices(listItem);
            if(Boolean(pt))
            {
               evt.rowIndex = pt.y;
               evt.columnIndex = pt.x;
            }
            dispatchEvent(evt);
         }
      }
      
      [Inspectable(category="General")]
      public function get headerWordWrap() : Boolean
      {
         return _headerWordWrap;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(!listSubContent)
         {
            listSubContent = new AdvancedListBaseContentHolder(this);
            listSubContent.styleName = this;
            listContent.addChild(listSubContent);
         }
      }
      
      protected function addRendererToContentArea(item:IListItemRenderer, column:AdvancedDataGridColumn) : void
      {
         if(column.colNum < lockedColumnCount)
         {
            if(item.parent != listContent)
            {
               listContent.addChild(DisplayObject(item));
            }
         }
         else if(item.parent != listSubContent)
         {
            listSubContent.addChild(DisplayObject(item));
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get headerVisible() : Boolean
      {
         return showHeaders && headerHeight > 0;
      }
      
      override protected function drawHighlightIndicator(indicator:Sprite, x:Number, y:Number, width:Number, height:Number, color:uint, itemRenderer:IListItemRenderer) : void
      {
         if(isRowSelectionMode())
         {
            width = unscaledWidth - viewMetrics.left - viewMetrics.right;
         }
         super.drawHighlightIndicator(indicator,x,y,width,height,color,itemRenderer);
      }
      
      public function set headerHeight(value:Number) : void
      {
         _headerHeight = value;
         _explicitHeaderHeight = true;
         itemsSizeChanged = true;
         invalidateDisplayList();
      }
      
      override protected function drawCaretIndicator(indicator:Sprite, x:Number, y:Number, width:Number, height:Number, color:uint, itemRenderer:IListItemRenderer) : void
      {
         if(isRowSelectionMode())
         {
            width = unscaledWidth - viewMetrics.left - viewMetrics.right;
         }
         super.drawCaretIndicator(indicator,x,y,width,height,color,itemRenderer);
      }
      
      private function createRow(left:Number, top:Number, right:Number, bottom:Number, more:Boolean) : void
      {
         var xx:Number = NaN;
         var ww:Number = NaN;
         var hh:Number = NaN;
         var j:int = 0;
         var c:AdvancedDataGridColumn = null;
         var item:IListItemRenderer = null;
         var rowData:AdvancedDataGridListData = null;
         var extraItem:IListItemRenderer = null;
         var itemData:Object = null;
         var optimumColumns:Array = null;
         var obj:Object = null;
         var count:int = 0;
         var itemHeight:Number = NaN;
         var bSelected:Boolean = false;
         var bHighlight:Boolean = false;
         var bCaret:Boolean = false;
         var uid:String = null;
         if(itemPending)
         {
            optimumColumns = getOptimumColumns();
            obj = {};
            for(count = 0; count < optimumColumns.length; count++)
            {
               obj[AdvancedDataGridColumn(optimumColumns[count]).dataField] = "Data Loading";
            }
            itemData = obj;
         }
         else
         {
            itemData = more ? iterator.current : null;
         }
         xx = left;
         hh = 0;
         currentColNum = 0;
         if(!listItems[currentRowNum])
         {
            listItems[currentRowNum] = [];
         }
         if(more)
         {
            uid = itemToUID(itemData);
            setupRenderer(itemData,uid);
         }
         else
         {
            hh = currentRowNum > 1 ? Number(rowInfo[currentRowNum - 1].height) : rowHeight;
         }
         hh = layoutRow(more,left,hh);
         while(listItems[currentRowNum].length > currentColNum)
         {
            extraItem = listItems[currentRowNum].pop();
            addToFreeItemRenderers(extraItem);
         }
         if(more && variableRowHeight)
         {
            hh = Math.ceil(calculateRowHeight(itemData,hh,true));
         }
         if(Boolean(listItems[currentRowNum]))
         {
            itemHeight = hh - cachedPaddingTop - cachedPaddingBottom;
            for(j = 0; j < listItems[currentRowNum].length; j++)
            {
               listItems[currentRowNum][j].setActualSize(listItems[currentRowNum][j].width,itemHeight);
            }
         }
         if(cachedVerticalAlign != "top")
         {
            if(cachedVerticalAlign == "bottom")
            {
               for(j = 0; j < currentColNum; j++)
               {
                  item = listItems[currentRowNum][j];
                  item.move(item.x,currentItemTop + hh - cachedPaddingBottom - item.getExplicitOrMeasuredHeight());
               }
            }
            else
            {
               for(j = 0; j < currentColNum; j++)
               {
                  item = listItems[currentRowNum][j];
                  item.move(item.x,currentItemTop + cachedPaddingTop + (hh - cachedPaddingBottom - cachedPaddingTop - item.getExplicitOrMeasuredHeight()) / 2);
               }
            }
         }
         bSelected = selectedData[uid] != null;
         bHighlight = highlightUID == uid;
         bCaret = caretUID == uid;
         rowInfo[currentRowNum] = new ListRowInfo(currentItemTop,hh,uid);
         if(more)
         {
            drawVisibleItem(uid,bSelected,bHighlight,bCaret);
         }
         if(hh == 0)
         {
            hh = rowHeight;
         }
         currentItemTop += hh;
         ++currentRowNum;
      }
      
      public function set headerWordWrap(value:Boolean) : void
      {
         if(value == _headerWordWrap)
         {
            return;
         }
         _headerWordWrap = value;
         itemsSizeChanged = true;
         invalidateDisplayList();
         dispatchEvent(new Event("headerWordWrapChanged"));
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getRenderer(c:AdvancedDataGridColumn, itemData:Object, forDragProxy:Boolean = false) : IListItemRenderer
      {
         var renderer:IListItemRenderer = null;
         var factory:IFactory = columnItemRendererFactory(c,false,itemData);
         if(Boolean(freeItemRenderersTable[c]) && Boolean(freeItemRenderersTable[c][factory]) && Boolean(freeItemRenderersTable[c][factory].length))
         {
            renderer = freeItemRenderersTable[c][factory].pop();
         }
         else
         {
            renderer = columnItemRenderer(c,false,itemData);
            renderer.styleName = c;
         }
         return renderer;
      }
      
      override protected function makeRowsAndColumns(left:Number, top:Number, right:Number, bottom:Number, firstCol:int, firstRow:int, byCount:Boolean = false, rowsNeeded:uint = 0) : Point
      {
         var xx:Number = NaN;
         var ww:Number = NaN;
         var hh:Number = NaN;
         var rowData:AdvancedDataGridListData = null;
         var i:int = 0;
         var item:IListItemRenderer = null;
         var extraItem:DisplayObject = null;
         var uid:String = null;
         var c:AdvancedDataGridColumn = null;
         var rr:Array = null;
         currentColNum = lockedColumnCount;
         currentRowNum = lockedRowCount;
         var rowsMade:int = 0;
         if(!visibleColumns || visibleColumns.length == 0)
         {
            purgeHeaderRenderers();
            purgeItemRenderers();
            visibleData = {};
            return new Point(0,0);
         }
         invalidateSizeFlag = true;
         var more:Boolean = true;
         currentItemTop = top;
         if(firstRow <= lockedRowCount)
         {
            createHeaders(left,top);
            createLockedRows(left,top,right,bottom);
         }
         else
         {
            currentRowNum = firstRow;
         }
         more = iterator != null && !iterator.afterLast && iteratorValid;
         while(!byCount && currentItemTop < bottom || byCount && rowsNeeded > 0)
         {
            if(byCount)
            {
               rowsNeeded--;
            }
            createRow(left,top,right,bottom,more);
            more = moveIterator(more);
            rowsMade++;
         }
         if(!byCount)
         {
            while(currentRowNum < listItems.length)
            {
               rr = listItems.pop();
               rowInfo.pop();
               while(Boolean(rr.length))
               {
                  item = rr.pop();
                  addToFreeItemRenderers(item);
               }
            }
         }
         invalidateSizeFlag = false;
         return new Point(currentColNum,rowsMade);
      }
      
      override protected function drawSelectionIndicator(indicator:Sprite, x:Number, y:Number, width:Number, height:Number, color:uint, itemRenderer:IListItemRenderer) : void
      {
         if(isRowSelectionMode())
         {
            width = unscaledWidth - viewMetrics.left - viewMetrics.right;
         }
         super.drawSelectionIndicator(indicator,x,y,width,height,color,itemRenderer);
      }
      
      [Inspectable(category="General",enumeration="none,singleRow,multipleRows,singleCell,multipleCells",defaultValue="singleRow")]
      public function get selectionMode() : String
      {
         return _selectionMode;
      }
      
      public function set styleFunction(value:Function) : void
      {
         _styleFunction = value;
         invalidateDisplayList();
      }
      
      override protected function purgeItemRenderers() : void
      {
         var item:IListItemRenderer = null;
         rendererChanged = false;
         while(Boolean(listItems.length))
         {
            currentRowNum = listItems.length - 1;
            while(Boolean(listItems[currentRowNum].length))
            {
               item = listItems[currentRowNum].pop();
               item.parent.removeChild(DisplayObject(item));
            }
            listItems.pop();
         }
         rowMap = {};
         rowInfo = [];
      }
      
      public function get fontContext() : IFlexModuleFactory
      {
         return moduleFactory;
      }
      
      protected function selectionTween_updateHandler(event:TweenEvent) : void
      {
         Sprite(event.target.listener).alpha = Number(event.value);
      }
      
      public function set sortItemRenderer(value:IFactory) : void
      {
         _sortItemRenderer = value;
         itemsSizeChanged = true;
         rendererChanged = true;
         invalidateSize();
         invalidateDisplayList();
         dispatchEvent(new Event("sortItemRendererChanged"));
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function columnItemRenderer(c:AdvancedDataGridColumn, forHeader:Boolean, itemData:Object) : IListItemRenderer
      {
         var factory:IFactory = columnItemRendererFactory(c,forHeader,itemData);
         var renderer:IListItemRenderer = factory.newInstance();
         itemRendererToFactoryMap[renderer] = factory;
         renderer.owner = this;
         return renderer;
      }
      
      protected function getHeaderRenderer(c:AdvancedDataGridColumn) : IListItemRenderer
      {
         var renderer:IListItemRenderer = null;
         var factory:IFactory = columnItemRendererFactory(c,true,null);
         if(Boolean(freeItemRenderersTable[c]) && Boolean(freeItemRenderersTable[c][factory]) && Boolean(freeItemRenderersTable[c][factory].length))
         {
            renderer = freeItemRenderersTable[c][factory].pop();
         }
         else
         {
            renderer = columnItemRenderer(c,true,null);
            addRendererToContentArea(renderer,c);
         }
         return renderer;
      }
      
      private function moveIterator(more:Boolean) : Boolean
      {
         if(itemPending)
         {
            itemPending = false;
            return true;
         }
         if(Boolean(iterator) && more)
         {
            try
            {
               more = Boolean(iterator.moveNext());
            }
            catch(e:ChildItemPendingError)
            {
               itemPending = true;
            }
            catch(e:ItemPendingError)
            {
               lastSeekPending = new ListBaseSeekPending(CursorBookmark.CURRENT,0);
               e.addResponder(new ItemResponder(seekPendingResultHandler,seekPendingFailureHandler,lastSeekPending));
               more = false;
               iteratorValid = false;
            }
         }
         return more;
      }
      
      protected function setupRenderer(itemData:Object, uid:String, insertItems:Boolean = false) : void
      {
         var c:AdvancedDataGridColumn = null;
         var item:IListItemRenderer = null;
         var rowData:AdvancedDataGridListData = null;
         var row:Array = [];
         var optimumColumns:Array = getOptimumColumns();
         while(currentColNum < optimumColumns.length)
         {
            c = optimumColumns[currentColNum];
            if(insertItems)
            {
               item = getRenderer(c,itemData);
               addRendererToContentArea(item,c);
               columnMap[item.name] = c;
            }
            else
            {
               item = listItems[currentRowNum][currentColNum];
               if(!item || itemToUID(item.data) != uid || columnMap[item.name] != c)
               {
                  item = getRenderer(c,itemData);
                  addRendererToContentArea(item,c);
                  columnMap[item.name] = c;
                  if(Boolean(listItems[currentRowNum][currentColNum]))
                  {
                     addToFreeItemRenderers(listItems[currentRowNum][currentColNum]);
                  }
                  listItems[currentRowNum][currentColNum] = item;
               }
            }
            rowData = AdvancedDataGridListData(makeListData(itemData,uid,currentRowNum,c.colNum,c));
            rowMap[item.name] = rowData;
            if(item is IDropInListItemRenderer)
            {
               IDropInListItemRenderer(item).listData = Boolean(itemData) ? rowData : null;
            }
            item.data = itemData;
            item.visible = true;
            setVisibleDataItem(uid,item);
            row[currentColNum] = item;
            ++currentColNum;
         }
         if(insertItems)
         {
            listItems.splice(currentRowNum,0,row);
         }
      }
      
      [Bindable("headerRendererChanged")]
      [Inspectable(category="Data")]
      public function get headerRenderer() : IFactory
      {
         return _headerRenderer;
      }
      
      override protected function clearIndicators() : void
      {
         if(isRowSelectionMode())
         {
            super.clearIndicators();
         }
      }
      
      protected function layoutRow(more:Boolean, xx:Number, hh:Number) : Number
      {
         var item:IListItemRenderer = null;
         var c:AdvancedDataGridColumn = null;
         var ww:Number = NaN;
         var itemYPos:Number = NaN;
         var cachedPadding:Number = NaN;
         var optimumColumns:Array = null;
         var rh:Number = 0;
         if(more)
         {
            currentColNum = 0;
            itemYPos = currentItemTop + cachedPaddingTop;
            cachedPadding = cachedPaddingTop + cachedPaddingBottom;
            optimumColumns = getOptimumColumns();
            while(currentColNum < optimumColumns.length)
            {
               c = optimumColumns[currentColNum];
               item = listItems[currentRowNum][currentColNum];
               ww = getWidthOfItem(item,c,currentColNum);
               item.explicitWidth = ww;
               if(item is IInvalidating && (wordWrapChanged || variableRowHeight))
               {
                  IInvalidating(item).invalidateSize();
               }
               UIComponentGlobals.layoutManager.validateClient(item,true);
               currentRowHeight = item.getExplicitOrMeasuredHeight();
               rh = getRowHeight(item.data);
               item.setActualSize(ww,variableRowHeight ? currentRowHeight : rh - cachedPaddingTop - cachedPaddingBottom);
               item.move(xx,itemYPos);
               xx += c.width;
               if(variableRowHeight && Boolean(item.visible))
               {
                  hh = Math.ceil(Math.max(hh,variableRowHeight ? currentRowHeight + cachedPadding : rh));
               }
               ++currentColNum;
            }
         }
         if(!variableRowHeight)
         {
            hh = rh != 0 ? rh : getRowHeight();
         }
         return hh;
      }
      
      protected function makeListData(data:Object, uid:String, rowNum:int, columnNum:int, column:AdvancedDataGridColumn) : BaseListData
      {
         var label:String = null;
         if(data is AdvancedDataGridColumn)
         {
            return new AdvancedDataGridListData(column.headerText != null ? column.headerText : column.dataField,column.dataField,columnNum,uid,this,rowNum);
         }
         label = column.itemToLabel(data);
         return new AdvancedDataGridListData(label,column.dataField,columnNum,uid,this,rowNum);
      }
      
      override protected function drawItem(item:IListItemRenderer, selected:Boolean = false, highlighted:Boolean = false, caret:Boolean = false, transition:Boolean = false) : void
      {
         var r:IListItemRenderer = null;
         if(!item)
         {
            return;
         }
         if(rowMap[item.name] == null)
         {
            return;
         }
         super.drawItem(item,selected,highlighted,caret,transition);
         var rowIndex:int = int(rowMap[item.name].rowIndex);
         var optimumColumns:Array = getOptimumColumns();
         var n:int = int(optimumColumns.length);
         for(var columnIndex:int = 0; columnIndex < n; columnIndex++)
         {
            r = listItems[rowIndex][columnIndex];
            updateDisplayOfItemRenderer(r);
         }
      }
      
      protected function onSelectionTweenUpdate(value:Number) : void
      {
      }
      
      protected function updateDisplayOfItemRenderer(r:IListItemRenderer) : void
      {
         var ui:IInvalidating = null;
         if(r is IInvalidating)
         {
            ui = IInvalidating(r);
            ui.invalidateDisplayList();
            ui.validateNow();
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get gridColumnMap() : Object
      {
         return columnMap;
      }
      
      protected function addHeaderToFreeItemRenderers(item:IListItemRenderer, c:AdvancedDataGridColumn) : void
      {
         DisplayObject(item).visible = false;
         var factory:IFactory = itemRendererToFactoryMap[item];
         if(!freeItemRenderersTable[c])
         {
            freeItemRenderersTable[c] = new Dictionary(false);
         }
         if(!freeItemRenderersTable[c][factory])
         {
            freeItemRenderersTable[c][factory] = [];
         }
         freeItemRenderersTable[c][factory].push(item);
      }
      
      public function set showHeaders(value:Boolean) : void
      {
         _showHeaders = value;
         itemsSizeChanged = true;
         invalidateDisplayList();
         dispatchEvent(new Event("showHeadersChanged"));
      }
      
      override protected function addToFreeItemRenderers(item:IListItemRenderer) : void
      {
         var c:AdvancedDataGridColumn = null;
         var factory:IFactory = null;
         DisplayObject(item).visible = false;
         delete rowMap[item.name];
         var UID:String = itemToUID(item.data);
         if(visibleData[UID] == item)
         {
            delete visibleData[UID];
         }
         if(Boolean(columnMap[item.name]))
         {
            c = columnMap[item.name];
            factory = itemRendererToFactoryMap[item];
            if(!freeItemRenderersTable[c])
            {
               freeItemRenderersTable[c] = new Dictionary(false);
            }
            if(!freeItemRenderersTable[c][factory])
            {
               freeItemRenderersTable[c][factory] = [];
            }
            freeItemRenderersTable[c][factory].push(item);
            delete columnMap[item.name];
         }
         else
         {
            item.parent.removeChild(DisplayObject(item));
         }
      }
      
      public function set selectionMode(value:String) : void
      {
         setSelectionMode(value);
         itemsSizeChanged = true;
         invalidateDisplayList();
      }
      
      public function get styleFunction() : Function
      {
         return _styleFunction;
      }
      
      protected function setVisibleDataItem(uid:String, item:IListItemRenderer) : void
      {
         if(Boolean(uid) && currentColNum == 0)
         {
            visibleData[uid] = item;
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getWidthOfItem(item:IListItemRenderer, col:AdvancedDataGridColumn, visibleColumnIndex:int) : Number
      {
         return col.width;
      }
      
      [Bindable("sortItemRendererChanged")]
      [Inspectable]
      public function get sortItemRenderer() : IFactory
      {
         return _sortItemRenderer;
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function mouseEventToItemRendererOrEditor(event:MouseEvent) : IListItemRenderer
      {
         var pt:Point = null;
         var yy:Number = NaN;
         var n:int = 0;
         var i:int = 0;
         var xx:Number = NaN;
         var m:int = 0;
         var j:int = 0;
         var target:DisplayObject = DisplayObject(event.target);
         if(target == listContent)
         {
            pt = new Point(event.stageX,event.stageY);
            pt = listContent.globalToLocal(pt);
            yy = rowInfo.length == 0 ? 0 : Number(rowInfo[0].y);
            n = int(listItems.length);
            for(i = 0; i < n; yy += rowInfo[i].height,i++)
            {
               if(Boolean(listItems[i].length))
               {
                  if(pt.y < yy + rowInfo[i].height)
                  {
                     xx = 0;
                     m = int(listItems[i].length);
                     j = 0;
                     while(j < m)
                     {
                        if(pt.x < xx + visibleColumns[j].width)
                        {
                           return listItems[i][j];
                        }
                        xx += visibleColumns[j].width;
                        j++;
                     }
                  }
               }
            }
         }
         else if(target == highlightIndicator)
         {
            return lastHighlightItemRenderer;
         }
         while(Boolean(target) && target != this)
         {
            if(target is IListItemRenderer && (target.parent == listSubContent || target.parent == listContent))
            {
               if(target.visible)
               {
                  return IListItemRenderer(target);
               }
               break;
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
         return null;
      }
      
      public function set fontContext(moduleFactory:IFlexModuleFactory) : void
      {
         this.moduleFactory = moduleFactory;
      }
      
      protected function drawVisibleItem(uid:String, selected:Boolean = false, highlighted:Boolean = false, caret:Boolean = false, transition:Boolean = false) : void
      {
         if(isRowSelectionMode())
         {
            if(Boolean(visibleData[uid]))
            {
               drawItem(visibleData[uid],selected,highlighted,caret);
            }
         }
      }
      
      [Inspectable(category="General",defaultValue="true")]
      [Bindable("showHeadersChanged")]
      public function get showHeaders() : Boolean
      {
         return _showHeaders;
      }
      
      override protected function moveSelectionVertically(code:uint, shiftKey:Boolean, ctrlKey:Boolean) : void
      {
         var newVerticalScrollPosition:Number = NaN;
         var listItem:IListItemRenderer = null;
         var uid:String = null;
         var len:int = 0;
         var se:ScrollEvent = null;
         showCaret = true;
         var rowCount:int = int(listItems.length);
         if(rowCount == 0)
         {
            return;
         }
         var partialRow:int = 0;
         if(rowInfo[rowCount - 1].y + rowInfo[rowCount - 1].height > listContent.height)
         {
            partialRow++;
         }
         var bUpdateVerticalScrollPosition:Boolean = false;
         bSelectItem = false;
         switch(code)
         {
            case Keyboard.UP:
               if(caretIndex > 0)
               {
                  --caretIndex;
                  bUpdateVerticalScrollPosition = true;
                  bSelectItem = true;
               }
               break;
            case Keyboard.DOWN:
               if(caretIndex < collection.length - 1)
               {
                  ++caretIndex;
                  bUpdateVerticalScrollPosition = true;
                  bSelectItem = true;
               }
               else if(caretIndex == collection.length - 1 && Boolean(partialRow))
               {
                  if(verticalScrollPosition < maxVerticalScrollPosition)
                  {
                     newVerticalScrollPosition = verticalScrollPosition + 1;
                  }
               }
               break;
            case Keyboard.PAGE_UP:
               if(caretIndex < lockedRowCount)
               {
                  newVerticalScrollPosition = 0;
                  caretIndex = 0;
               }
               else if(caretIndex > verticalScrollPosition + lockedRowCount && caretIndex < verticalScrollPosition + rowCount)
               {
                  caretIndex = verticalScrollPosition + lockedRowCount;
               }
               else
               {
                  caretIndex = Math.max(caretIndex - rowCount + lockedRowCount,0);
                  newVerticalScrollPosition = Math.max(caretIndex - lockedRowCount,0);
               }
               bSelectItem = true;
               break;
            case Keyboard.PAGE_DOWN:
               if(caretIndex < lockedRowCount)
               {
                  newVerticalScrollPosition = 0;
               }
               else if(caretIndex >= verticalScrollPosition + lockedRowCount && caretIndex < verticalScrollPosition + rowCount - partialRow - 1)
               {
                  caretIndex = Math.min(verticalScrollPosition + listItems.length + lockedRowCount,collection.length - 1);
               }
               else if(lockedRowCount >= rowCount - partialRow - 1)
               {
                  newVerticalScrollPosition = Math.min(verticalScrollPosition + 1,maxVerticalScrollPosition);
               }
               else
               {
                  newVerticalScrollPosition = Math.min(caretIndex - lockedRowCount,maxVerticalScrollPosition);
               }
               bSelectItem = true;
               break;
            case Keyboard.HOME:
               if(caretIndex > 0)
               {
                  caretIndex = 0;
                  newVerticalScrollPosition = 0;
                  bSelectItem = true;
               }
               break;
            case Keyboard.END:
               if(caretIndex < collection.length - 1)
               {
                  caretIndex = collection.length - 1;
                  newVerticalScrollPosition = Number(maxVerticalScrollPosition);
                  bSelectItem = true;
               }
               break;
            case Keyboard.SPACE:
               bUpdateVerticalScrollPosition = true;
               bSelectItem = true;
         }
         if(bUpdateVerticalScrollPosition)
         {
            if(caretIndex < lockedRowCount)
            {
               newVerticalScrollPosition = 0;
            }
            else if(caretIndex < verticalScrollPosition + lockedRowCount)
            {
               newVerticalScrollPosition = caretIndex - lockedRowCount;
            }
            else if(caretIndex >= verticalScrollPosition + rowCount - partialRow)
            {
               newVerticalScrollPosition = Math.min(maxVerticalScrollPosition,caretIndex - rowCount + partialRow + 1);
            }
         }
         if(!isNaN(newVerticalScrollPosition))
         {
            if(verticalScrollPosition != newVerticalScrollPosition)
            {
               se = new ScrollEvent(ScrollEvent.SCROLL);
               se.detail = ScrollEventDetail.THUMB_POSITION;
               se.direction = ScrollEventDirection.VERTICAL;
               se.delta = newVerticalScrollPosition - verticalScrollPosition;
               se.position = newVerticalScrollPosition;
               verticalScrollPosition = newVerticalScrollPosition;
               dispatchEvent(se);
            }
            if(!iteratorValid)
            {
               keySelectionPending = true;
               return;
            }
         }
         bShiftKey = shiftKey;
         bCtrlKey = ctrlKey;
         lastKey = code;
         finishKeySelection();
      }
      
      protected function purgeHeaderRenderers() : void
      {
         var item:IListItemRenderer = null;
         var headerRow:Array = null;
         while(Boolean(headerItems.length))
         {
            headerRow = headerItems.pop();
            while(Boolean(headerRow.length))
            {
               item = IListItemRenderer(headerRow.pop());
               addHeaderToFreeItemRenderers(item,item.data as AdvancedDataGridColumn);
            }
         }
      }
      
      protected function calculateRowHeight(data:Object, hh:Number, skipVisible:Boolean = false) : Number
      {
         return NaN;
      }
      
      protected function isRowSelectionMode() : Boolean
      {
         return selectionMode == SINGLE_ROW || selectionMode == MULTIPLE_ROWS;
      }
      
      public function set headerRenderer(value:IFactory) : void
      {
         _headerRenderer = value;
         invalidateSize();
         invalidateDisplayList();
         itemsSizeChanged = true;
         rendererChanged = true;
         dispatchEvent(new Event("headerRendererChanged"));
      }
      
      protected function getOptimumColumns() : Array
      {
         return visibleColumns;
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function clearHighlight(item:IListItemRenderer) : void
      {
         if(isRowSelectionMode())
         {
            super.clearHighlight(item);
         }
      }
      
      override protected function removeIndicators(uid:String) : void
      {
         if(isRowSelectionMode())
         {
            super.removeIndicators(uid);
         }
      }
      
      protected function createHeaders(left:Number, top:Number) : void
      {
         var xx:Number = NaN;
         var ww:Number = NaN;
         var hh:Number = NaN;
         var item:IListItemRenderer = null;
         var extraItem:DisplayObject = null;
         var c:AdvancedDataGridColumn = null;
         var rowData:AdvancedDataGridListData = null;
         var i:int = 0;
         var optimumColumns:Array = null;
         var freeHeaderItem:IListItemRenderer = null;
         var headerItem:IInvalidating = null;
         var maxHeaderHeight:Number = 0;
         if(!headerItems[0] || !headerItems[0][0] || top < headerItems[0][0].y + headerItems[0][0].height)
         {
            xx = left;
            hh = 0;
            currentRowNum = 0;
            currentColNum = 0;
            for(i = 0; i < headerInfos.length; i++)
            {
               headerInfos[i].headerItem = null;
            }
            optimumColumns = getOptimumColumns();
            while(currentColNum < optimumColumns.length)
            {
               c = optimumColumns[currentColNum];
               if(!headerItems[currentRowNum])
               {
                  headerItems[currentRowNum] = [];
               }
               else if(Boolean(headerItems[currentRowNum][currentColNum]))
               {
                  freeHeaderItem = headerItems[currentRowNum][currentColNum];
                  addHeaderToFreeItemRenderers(freeHeaderItem,freeHeaderItem.data as AdvancedDataGridColumn);
               }
               item = getHeaderRenderer(c);
               rowData = AdvancedDataGridListData(makeListData(c,uid,-1,c.colNum,c));
               rowMap[item.name] = rowData;
               if(item is IDropInListItemRenderer)
               {
                  IDropInListItemRenderer(item).listData = rowData;
               }
               item.data = c;
               item.styleName = c;
               headerItems[currentRowNum][currentColNum] = item;
               headerInfos[c.colNum].headerItem = item;
               item.explicitWidth = ww = c.width;
               UIComponentGlobals.layoutManager.validateClient(item,true);
               currentRowHeight = item.getExplicitOrMeasuredHeight();
               item.setActualSize(ww,_explicitHeaderHeight ? _headerHeight - cachedPaddingTop - cachedPaddingBottom : currentRowHeight);
               item.move(xx,currentItemTop + cachedPaddingTop);
               xx += ww;
               hh = Math.ceil(Math.max(hh,_explicitHeaderHeight ? _headerHeight : currentRowHeight + cachedPaddingBottom + cachedPaddingTop));
               maxHeaderHeight = Math.max(maxHeaderHeight,_explicitHeaderHeight ? _headerHeight - cachedPaddingTop - cachedPaddingBottom : currentRowHeight);
               item.visible = headerVisible;
               ++currentColNum;
            }
            if(Boolean(headerItems[currentRowNum]))
            {
               for(i = 0; i < headerItems[currentRowNum].length; i++)
               {
                  headerItems[currentRowNum][i].setActualSize(headerItems[currentRowNum][i].width,maxHeaderHeight);
                  headerItem = headerItems[currentRowNum][i] as IInvalidating;
                  if(Boolean(headerItem))
                  {
                     IInvalidating(headerItem).invalidateDisplayList();
                  }
               }
               while(headerItems[currentRowNum].length > currentColNum)
               {
                  extraItem = headerItems[currentRowNum].pop();
                  extraItem.parent.removeChild(extraItem);
               }
            }
            headerRowInfo[currentRowNum] = new ListRowInfo(currentItemTop,hh,uid);
            if(headerVisible)
            {
               currentItemTop += Boolean(item) ? hh : 0;
            }
            if(!_explicitHeaderHeight)
            {
               _headerHeight = Boolean(item) ? hh : 0;
            }
         }
      }
      
      protected function getRowHeight(itemData:Object = null) : Number
      {
         return rowHeight;
      }
      
      override protected function adjustListContent(unscaledWidth:Number = -1, unscaledHeight:Number = -1) : void
      {
         super.adjustListContent(unscaledWidth,unscaledHeight);
         listSubContent.setActualSize(listContent.width,listContent.height);
      }
      
      protected function selectionTween_endHandler(event:TweenEvent) : void
      {
         selectionTween_updateHandler(event);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function columnWordWrap(c:AdvancedDataGridColumn) : Boolean
      {
         if(c.wordWrap == true)
         {
            return true;
         }
         if(c.wordWrap == false)
         {
            return false;
         }
         return wordWrap;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function columnItemRendererFactory(c:AdvancedDataGridColumn, forHeader:Boolean, itemData:Object) : IFactory
      {
         var factory:IFactory = null;
         if(forHeader)
         {
            if(Boolean(c.headerRenderer))
            {
               factory = c.headerRenderer;
            }
            else
            {
               factory = headerRenderer;
            }
         }
         else if(Boolean(c.itemRenderer))
         {
            factory = c.itemRenderer;
         }
         if(!factory)
         {
            factory = itemRenderer;
         }
         return factory;
      }
   }
}

