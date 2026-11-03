package mx.controls.dataGridClasses
{
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   import flash.utils.setInterval;
   import mx.collections.CursorBookmark;
   import mx.collections.IViewCursor;
   import mx.collections.ItemResponder;
   import mx.collections.errors.ItemPendingError;
   import mx.controls.listClasses.BaseListData;
   import mx.controls.listClasses.IDropInListItemRenderer;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.controls.listClasses.ListBase;
   import mx.controls.listClasses.ListBaseContentHolder;
   import mx.controls.listClasses.ListBaseSeekPending;
   import mx.controls.listClasses.ListRowInfo;
   import mx.core.EdgeMetrics;
   import mx.core.IFactory;
   import mx.core.IFlexDisplayObject;
   import mx.core.IFlexModuleFactory;
   import mx.core.IFontContextComponent;
   import mx.core.IInvalidating;
   import mx.core.IUIComponent;
   import mx.core.IUITextField;
   import mx.core.SpriteAsset;
   import mx.core.UIComponentGlobals;
   import mx.core.mx_internal;
   import mx.events.DragEvent;
   import mx.events.ListEvent;
   import mx.events.ScrollEvent;
   import mx.events.ScrollEventDetail;
   import mx.events.ScrollEventDirection;
   import mx.events.TweenEvent;
   import mx.skins.halo.ListDropIndicator;
   
   use namespace mx_internal;
   
   public class DataGridBase extends ListBase implements IFontContextComponent
   {
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private var _showHeaders:Boolean = true;
      
      mx_internal var visibleColumns:Array;
      
      private var lockedColumnMask:Shape;
      
      protected var headerMask:Shape;
      
      protected var freeItemRenderersTable:Dictionary;
      
      mx_internal var visibleLockedColumns:Array;
      
      protected var columnMap:Object;
      
      private var indicatorDictionary:Dictionary = new Dictionary(true);
      
      private var lockedColumnAndRowMask:Shape;
      
      private var bSelectItem:Boolean = false;
      
      private var bCtrlKey:Boolean = false;
      
      private var inSelectItem:Boolean = false;
      
      private var lockedRowCountChanged:Boolean = false;
      
      private var lockedColumnHeaderMask:Shape;
      
      mx_internal var _explicitHeaderHeight:Boolean;
      
      protected var lockedColumnAndRowContent:DataGridLockedRowContentHolder;
      
      protected var lockedColumnContent:ListBaseContentHolder;
      
      mx_internal var columnsInvalid:Boolean = true;
      
      private var lockedRowMask:Shape;
      
      protected var header:DataGridHeaderBase;
      
      mx_internal var _lockedColumnCount:int = 0;
      
      mx_internal var _lockedRowCount:int = 0;
      
      protected var lockedColumnHeader:DataGridHeaderBase;
      
      protected var columnHighlightIndicator:Sprite;
      
      protected var columnCaretIndicator:Sprite;
      
      private var lockedColumnCountChanged:Boolean = false;
      
      protected var lockedRowContent:DataGridLockedRowContentHolder;
      
      mx_internal var headerClass:Class = DataGridHeader;
      
      private var lastKey:uint = 0;
      
      mx_internal var _headerHeight:Number = 22;
      
      private var bShiftKey:Boolean = false;
      
      public function DataGridBase()
      {
         super();
         mx_internal::listType = "vertical";
         defaultRowCount = 7;
         columnMap = {};
         freeItemRenderersTable = new Dictionary(false);
      }
      
      mx_internal function get dataGridLockedColumnAndRows() : ListBaseContentHolder
      {
         return lockedColumnAndRowContent;
      }
      
      override protected function removeFromRowArrays(i:int) : void
      {
         super.removeFromRowArrays(i);
         if(Boolean(lockedColumnCount))
         {
            lockedColumnContent.listItems.splice(i,1);
            lockedColumnContent.rowInfo.splice(i,1);
         }
      }
      
      override mx_internal function removeClipMask() : void
      {
         var numColumns:int = 0;
         var i:int = 0;
         var item:DisplayObject = null;
         super.mx_internal::removeClipMask();
         if(!lockedColumnContent)
         {
            return;
         }
         var lastRowIndex:int = listItems.length - 1;
         if(lastRowIndex < 0)
         {
            return;
         }
         var rowHeight:Number = Number(rowInfo[lastRowIndex].height);
         var lastRowInfo:ListRowInfo = rowInfo[lastRowIndex];
         var lastRowItems:Array = lockedColumnContent.listItems[lastRowIndex];
         if(Boolean(lastRowItems))
         {
            numColumns = int(lastRowItems.length);
            for(i = 0; i < numColumns; i++)
            {
               item = lastRowItems[i];
               if(item is IUITextField)
               {
                  if(item.height != rowHeight - (item.y - lastRowInfo.y))
                  {
                     item.height = rowHeight - (item.y - lastRowInfo.y);
                  }
               }
               else if(Boolean(item) && Boolean(item.mask))
               {
                  itemMaskFreeList.push(item.mask);
                  item.mask = null;
               }
            }
         }
      }
      
      private function selectionRemovedListener(event:Event) : void
      {
         if(!lockedColumnCount)
         {
            return;
         }
         var columnIndicator:Sprite = indicatorDictionary[event.target] as Sprite;
         if(Boolean(columnIndicator))
         {
            columnIndicator.parent.removeChild(columnIndicator);
         }
      }
      
      override protected function shiftRow(oldIndex:int, newIndex:int, numCols:int, shiftItems:Boolean) : void
      {
         var listItems:Array = null;
         var r:IListItemRenderer = null;
         var j:int = 0;
         super.shiftRow(oldIndex,newIndex,numCols,shiftItems);
         if(Boolean(lockedColumnCount))
         {
            listItems = lockedColumnContent.listItems;
            numCols = int(listItems[oldIndex].length);
            for(j = 0; j < numCols; j++)
            {
               r = listItems[oldIndex][j];
               if(shiftItems)
               {
                  listItems[newIndex][j] = r;
                  rowMap[r.name].rowIndex = newIndex;
               }
               else
               {
                  rowMap[r.name].rowIndex = oldIndex;
               }
            }
            if(shiftItems)
            {
               lockedColumnContent.rowInfo[newIndex] = lockedColumnContent.rowInfo[oldIndex];
            }
         }
      }
      
      protected function makeRow(contentHolder:ListBaseContentHolder, rowNum:int, left:Number, right:Number, yy:Number, data:Object, uid:String) : Number
      {
         var columnContent:ListBaseContentHolder = null;
         var item:IListItemRenderer = null;
         var extraItem:IListItemRenderer = null;
         var c:DataGridColumn = null;
         var itemSize:Point = null;
         var listItems:Array = contentHolder.listItems;
         if(lockedColumnCount > 0)
         {
            if(contentHolder == lockedRowContent)
            {
               columnContent = lockedColumnAndRowContent;
            }
            else
            {
               columnContent = lockedColumnContent;
            }
         }
         else
         {
            columnContent = null;
         }
         var colNum:int = 0;
         var xx:Number = left;
         var hh:Number = 0;
         while(colNum < visibleLockedColumns.length)
         {
            c = visibleLockedColumns[colNum];
            item = setupColumnItemRenderer(c,columnContent,rowNum,colNum,data,uid);
            itemSize = layoutColumnItemRenderer(c,item,xx,yy);
            xx += itemSize.x;
            colNum++;
            hh = Math.ceil(Math.max(hh,variableRowHeight ? itemSize.y + cachedPaddingTop + cachedPaddingBottom : rowHeight));
         }
         if(Boolean(visibleLockedColumns.length))
         {
            while(columnContent.listItems[rowNum].length > colNum)
            {
               extraItem = columnContent.listItems[rowNum].pop();
               addToFreeItemRenderers(extraItem);
            }
         }
         colNum = 0;
         xx = left;
         while(xx < right && colNum < visibleColumns.length)
         {
            c = visibleColumns[colNum];
            item = setupColumnItemRenderer(c,contentHolder,rowNum,colNum,data,uid);
            itemSize = layoutColumnItemRenderer(c,item,xx,yy);
            xx += itemSize.x;
            colNum++;
            hh = Math.ceil(Math.max(hh,variableRowHeight ? itemSize.y + cachedPaddingTop + cachedPaddingBottom : rowHeight));
         }
         while(listItems[rowNum].length > colNum)
         {
            extraItem = listItems[rowNum].pop();
            addToFreeItemRenderers(extraItem);
         }
         return hh;
      }
      
      [Inspectable(category="General",defaultValue="22")]
      [Bindable("resize")]
      public function get headerHeight() : Number
      {
         return _headerHeight;
      }
      
      mx_internal function columnHeaderWordWrap(c:DataGridColumn) : Boolean
      {
         if(c.headerWordWrap == true)
         {
            return true;
         }
         if(c.headerWordWrap == false)
         {
            return false;
         }
         return wordWrap;
      }
      
      override protected function drawHighlightIndicator(indicator:Sprite, x:Number, y:Number, width:Number, height:Number, color:uint, itemRenderer:IListItemRenderer) : void
      {
         var columnContents:ListBaseContentHolder = null;
         var selectionLayer:Sprite = null;
         super.drawHighlightIndicator(indicator,x,y,unscaledWidth - viewMetrics.left - viewMetrics.right,height,color,itemRenderer);
         if(Boolean(lockedColumnCount))
         {
            if(itemRenderer.parent == listContent)
            {
               columnContents = lockedColumnContent;
            }
            else
            {
               columnContents = lockedColumnAndRowContent;
            }
            selectionLayer = columnContents.selectionLayer;
            if(!columnHighlightIndicator)
            {
               columnHighlightIndicator = new SpriteAsset();
               columnContents.selectionLayer.addChild(DisplayObject(columnHighlightIndicator));
            }
            else if(columnHighlightIndicator.parent != selectionLayer)
            {
               selectionLayer.addChild(columnHighlightIndicator);
            }
            else
            {
               selectionLayer.setChildIndex(DisplayObject(columnHighlightIndicator),selectionLayer.numChildren - 1);
            }
            super.drawHighlightIndicator(columnHighlightIndicator,x,y,columnContents.width,height,color,itemRenderer);
         }
      }
      
      override protected function finishKeySelection() : void
      {
         var uid:String = null;
         var listItem:IListItemRenderer = null;
         var pt:Point = null;
         var evt:ListEvent = null;
         var rowCount:int = int(listItems.length);
         var onscreenRowCount:int = listItems.length - offscreenExtraRowsTop - offscreenExtraRowsBottom;
         var partialRow:int = rowInfo[rowCount - offscreenExtraRowsBottom - 1].y + rowInfo[rowCount - offscreenExtraRowsBottom - 1].height > listContent.heightExcludingOffsets - listContent.topOffset ? 1 : 0;
         if(lastKey == Keyboard.PAGE_DOWN)
         {
            if(onscreenRowCount - partialRow == 0)
            {
               caretIndex = Math.min(verticalScrollPosition + lockedRowCount + onscreenRowCount - partialRow,collection.length - 1);
            }
            else
            {
               caretIndex = Math.min(verticalScrollPosition + lockedRowCount + onscreenRowCount - partialRow - 1,collection.length - 1);
            }
         }
         var bSelChanged:Boolean = false;
         if(bSelectItem && (caretIndex - verticalScrollPosition >= 0 || caretIndex < lockedRowCount))
         {
            if(caretIndex - lockedRowCount - verticalScrollPosition > Math.max(onscreenRowCount - partialRow - 1,0))
            {
               if(lastKey == Keyboard.END && maxVerticalScrollPosition > verticalScrollPosition)
               {
                  caretIndex -= 1;
                  moveSelectionVertically(lastKey,bShiftKey,bCtrlKey);
                  return;
               }
               caretIndex = lockedRowCount + onscreenRowCount - partialRow - 1 + verticalScrollPosition;
            }
            if(caretIndex < lockedRowCount)
            {
               listItem = lockedRowContent.listItems[caretIndex][0];
            }
            else
            {
               listItem = listItems[caretIndex - lockedRowCount - verticalScrollPosition + offscreenExtraRowsTop][0];
            }
            if(Boolean(listItem))
            {
               uid = itemToUID(listItem.data);
               listItem = UIDToItemRenderer(uid);
               if(!bCtrlKey || lastKey == Keyboard.SPACE)
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
         if(bSelChanged)
         {
            pt = itemRendererToIndices(listItem);
            evt = new ListEvent(ListEvent.CHANGE);
            if(Boolean(pt))
            {
               evt.columnIndex = pt.x;
               evt.rowIndex = pt.y;
            }
            evt.itemRenderer = listItem;
            dispatchEvent(evt);
         }
      }
      
      override mx_internal function addClipMask(layoutChanged:Boolean) : void
      {
         var g:Graphics = null;
         var item:DisplayObject = null;
         var yOffset:Number = NaN;
         if(layoutChanged)
         {
            if(Boolean(horizontalScrollBar && horizontalScrollBar.visible || hasOnlyTextRenderers() || listContent.bottomOffset != 0 || listContent.topOffset != 0) || Boolean(listContent.leftOffset != 0) || listContent.rightOffset != 0)
            {
               listContent.mask = maskShape;
               selectionLayer.mask = null;
               if(!headerMask)
               {
                  headerMask = new Shape();
                  addChild(headerMask);
                  g = headerMask.graphics;
                  g.beginFill(16777215);
                  g.drawRect(0,0,10,10);
                  g.endFill();
                  headerMask.visible = false;
               }
               header.mask = headerMask;
               header.selectionLayer.mask = null;
               headerMask.width = maskShape.width;
               headerMask.height = maskShape.height;
               headerMask.x = maskShape.x;
               headerMask.y = maskShape.y;
               if(verticalScrollBar != null && verticalScrollBar.visible && (horizontalScrollBar == null || !horizontalScrollBar.visible) && headerVisible)
               {
                  headerMask.width += verticalScrollBar.getExplicitOrMeasuredWidth();
               }
               if(Boolean(lockedRowContent))
               {
                  if(!lockedRowMask)
                  {
                     lockedRowMask = new Shape();
                     addChild(lockedRowMask);
                     g = lockedRowMask.graphics;
                     g.beginFill(16777215);
                     g.drawRect(0,0,10,10);
                     g.endFill();
                     lockedRowMask.visible = false;
                  }
                  lockedRowContent.mask = lockedRowMask;
                  lockedRowContent.selectionLayer.mask = null;
                  lockedRowMask.width = maskShape.width;
                  lockedRowMask.height = maskShape.height;
                  lockedRowMask.x = maskShape.x;
                  lockedRowMask.y = maskShape.y;
               }
               if(Boolean(lockedColumnContent))
               {
                  if(!lockedColumnMask)
                  {
                     lockedColumnMask = new Shape();
                     addChild(lockedColumnMask);
                     g = lockedColumnMask.graphics;
                     g.beginFill(16777215);
                     g.drawRect(0,0,10,10);
                     g.endFill();
                     lockedColumnMask.visible = false;
                  }
                  lockedColumnContent.mask = lockedColumnMask;
                  lockedColumnContent.selectionLayer.mask = null;
                  lockedColumnMask.width = maskShape.width;
                  lockedColumnMask.height = maskShape.height;
                  lockedColumnMask.x = maskShape.x;
                  lockedColumnMask.y = maskShape.y;
               }
               if(Boolean(lockedColumnAndRowContent))
               {
                  if(!lockedColumnAndRowMask)
                  {
                     lockedColumnAndRowMask = new Shape();
                     addChild(lockedColumnAndRowMask);
                     g = lockedColumnAndRowMask.graphics;
                     g.beginFill(16777215);
                     g.drawRect(0,0,10,10);
                     g.endFill();
                     lockedColumnAndRowMask.visible = false;
                  }
                  lockedColumnAndRowContent.mask = lockedColumnAndRowMask;
                  lockedColumnAndRowContent.selectionLayer.mask = null;
                  lockedColumnAndRowMask.width = maskShape.width;
                  lockedColumnAndRowMask.height = maskShape.height;
                  lockedColumnAndRowMask.x = maskShape.x;
                  lockedColumnAndRowMask.y = maskShape.y;
               }
               if(Boolean(lockedColumnHeader))
               {
                  if(!lockedColumnHeaderMask)
                  {
                     lockedColumnHeaderMask = new Shape();
                     addChild(lockedColumnHeaderMask);
                     g = lockedColumnHeaderMask.graphics;
                     g.beginFill(16777215);
                     g.drawRect(0,0,10,10);
                     g.endFill();
                     lockedColumnHeaderMask.visible = false;
                  }
                  lockedColumnHeader.mask = lockedColumnHeaderMask;
                  lockedColumnHeader.selectionLayer.mask = null;
                  lockedColumnHeaderMask.width = maskShape.width;
                  lockedColumnHeaderMask.height = maskShape.height;
                  lockedColumnHeaderMask.x = maskShape.x;
                  lockedColumnHeaderMask.y = maskShape.y;
               }
            }
            else
            {
               listContent.mask = null;
               selectionLayer.mask = maskShape;
               if(!headerMask)
               {
                  headerMask = new Shape();
                  addChild(headerMask);
                  g = headerMask.graphics;
                  g.beginFill(16777215);
                  g.drawRect(0,0,10,10);
                  g.endFill();
                  headerMask.visible = false;
               }
               header.mask = null;
               header.selectionLayer.mask = headerMask;
               headerMask.width = maskShape.width;
               headerMask.height = maskShape.height;
               headerMask.x = maskShape.x;
               headerMask.y = maskShape.y;
               if(verticalScrollBar != null && verticalScrollBar.visible && (horizontalScrollBar == null || !horizontalScrollBar.visible) && headerVisible)
               {
                  headerMask.width += verticalScrollBar.getExplicitOrMeasuredWidth();
               }
               if(Boolean(lockedRowContent))
               {
                  if(!lockedRowMask)
                  {
                     lockedRowMask = new Shape();
                     addChild(lockedRowMask);
                     g = lockedRowMask.graphics;
                     g.beginFill(16777215);
                     g.drawRect(0,0,10,10);
                     g.endFill();
                     lockedRowMask.visible = false;
                  }
                  lockedRowContent.mask = null;
                  lockedRowContent.selectionLayer.mask = lockedRowMask;
                  lockedRowMask.width = maskShape.width;
                  lockedRowMask.height = maskShape.height;
                  lockedRowMask.x = maskShape.x;
                  lockedRowMask.y = maskShape.y;
               }
               if(Boolean(lockedColumnContent))
               {
                  if(!lockedColumnMask)
                  {
                     lockedColumnMask = new Shape();
                     addChild(lockedColumnMask);
                     g = lockedColumnMask.graphics;
                     g.beginFill(16777215);
                     g.drawRect(0,0,10,10);
                     g.endFill();
                     lockedColumnMask.visible = false;
                  }
                  lockedColumnContent.mask = null;
                  lockedColumnContent.selectionLayer.mask = lockedColumnMask;
                  lockedColumnMask.width = maskShape.width;
                  lockedColumnMask.height = maskShape.height;
                  lockedColumnMask.x = maskShape.x;
                  lockedColumnMask.y = maskShape.y;
               }
               if(Boolean(lockedColumnAndRowContent))
               {
                  if(!lockedColumnAndRowMask)
                  {
                     lockedColumnAndRowMask = new Shape();
                     addChild(lockedColumnAndRowMask);
                     g = lockedColumnAndRowMask.graphics;
                     g.beginFill(16777215);
                     g.drawRect(0,0,10,10);
                     g.endFill();
                     lockedColumnAndRowMask.visible = false;
                  }
                  lockedColumnAndRowContent.mask = null;
                  lockedColumnAndRowContent.selectionLayer.mask = lockedColumnAndRowMask;
                  lockedColumnAndRowMask.width = maskShape.width;
                  lockedColumnAndRowMask.height = maskShape.height;
                  lockedColumnAndRowMask.x = maskShape.x;
                  lockedColumnAndRowMask.y = maskShape.y;
               }
               if(Boolean(lockedColumnHeader))
               {
                  if(!lockedColumnHeaderMask)
                  {
                     lockedColumnHeaderMask = new Shape();
                     addChild(lockedColumnHeaderMask);
                     g = lockedColumnHeaderMask.graphics;
                     g.beginFill(16777215);
                     g.drawRect(0,0,10,10);
                     g.endFill();
                     lockedColumnHeaderMask.visible = false;
                  }
                  lockedColumnHeader.mask = null;
                  lockedColumnHeader.selectionLayer.mask = lockedColumnHeaderMask;
                  lockedColumnHeaderMask.width = maskShape.width;
                  lockedColumnHeaderMask.height = maskShape.height;
                  lockedColumnHeaderMask.x = maskShape.x;
                  lockedColumnHeaderMask.y = maskShape.y;
               }
            }
         }
         if(Boolean(listContent.mask))
         {
            return;
         }
         var lastRowIndex:int = listItems.length - 1;
         var lastRowInfo:ListRowInfo = rowInfo[lastRowIndex];
         var lastRowItems:Array = listItems[lastRowIndex];
         if(lastRowInfo.y + lastRowInfo.height <= listContent.height)
         {
            return;
         }
         var numColumns:int = int(lastRowItems.length);
         var rowY:Number = lastRowInfo.y;
         var rowWidth:Number = listContent.width;
         var rowHeight:Number = listContent.height - lastRowInfo.y;
         for(var i:int = 0; i < numColumns; i++)
         {
            item = lastRowItems[i];
            yOffset = item.y - rowY;
            if(item is IUITextField)
            {
               item.height = Math.max(rowHeight - yOffset,0);
            }
            else
            {
               item.mask = createItemMask(0,rowY + yOffset,rowWidth,Math.max(rowHeight - yOffset,0));
            }
         }
         if(Boolean(lockedColumnContent))
         {
            lastRowItems = lockedColumnContent.listItems[lastRowIndex];
            numColumns = int(lastRowItems.length);
            rowWidth = lockedColumnContent.width;
            for(i = 0; i < numColumns; i++)
            {
               item = lastRowItems[i];
               yOffset = item.y - rowY;
               if(item is IUITextField)
               {
                  item.height = Math.max(rowHeight - yOffset,0);
               }
               else
               {
                  item.mask = createItemMask(0,rowY + yOffset,rowWidth,Math.max(rowHeight - yOffset,0),lockedColumnContent);
               }
            }
         }
      }
      
      mx_internal function get headerVisible() : Boolean
      {
         return showHeaders && headerHeight > 0;
      }
      
      public function set headerHeight(value:Number) : void
      {
         _headerHeight = value;
         _explicitHeaderHeight = true;
         itemsSizeChanged = true;
         invalidateDisplayList();
      }
      
      mx_internal function resizeColumn(col:int, w:Number) : void
      {
      }
      
      override protected function drawCaretIndicator(indicator:Sprite, x:Number, y:Number, width:Number, height:Number, color:uint, itemRenderer:IListItemRenderer) : void
      {
         var columnContents:ListBaseContentHolder = null;
         var selectionLayer:Sprite = null;
         super.drawCaretIndicator(indicator,x,y,unscaledWidth - viewMetrics.left - viewMetrics.right,height,color,itemRenderer);
         if(Boolean(lockedColumnCount))
         {
            if(itemRenderer.parent == listContent)
            {
               columnContents = lockedColumnContent;
            }
            else
            {
               columnContents = lockedColumnAndRowContent;
            }
            selectionLayer = columnContents.selectionLayer;
            if(!columnCaretIndicator)
            {
               columnCaretIndicator = new SpriteAsset();
               columnContents.selectionLayer.addChild(DisplayObject(columnCaretIndicator));
            }
            else if(columnCaretIndicator.parent != selectionLayer)
            {
               selectionLayer.addChild(columnCaretIndicator);
            }
            else
            {
               selectionLayer.setChildIndex(DisplayObject(columnCaretIndicator),selectionLayer.numChildren - 1);
            }
            super.drawCaretIndicator(columnCaretIndicator,x,y,columnContents.width,height,color,itemRenderer);
         }
      }
      
      mx_internal function get dataGridLockedRows() : ListBaseContentHolder
      {
         return lockedRowContent;
      }
      
      protected function layoutColumnItemRenderer(c:DataGridColumn, item:IListItemRenderer, xx:Number, yy:Number) : Point
      {
         var ww:Number = 0;
         var rh:Number = 0;
         if(Boolean(item))
         {
            item.explicitWidth = ww = getWidthOfItem(item,c);
            UIComponentGlobals.layoutManager.validateClient(item,true);
            rh = Number(item.getExplicitOrMeasuredHeight());
            item.setActualSize(ww,variableRowHeight ? Number(item.getExplicitOrMeasuredHeight()) : rowHeight - cachedPaddingTop - cachedPaddingBottom);
            item.move(xx,yy + cachedPaddingTop);
         }
         return new Point(ww,rh);
      }
      
      override public function showDropFeedback(event:DragEvent) : void
      {
         var dropIndicatorClass:Class = null;
         var vm:EdgeMetrics = null;
         var rowCount:int = 0;
         var partialRow:int = 0;
         if(!dropIndicator)
         {
            dropIndicatorClass = getStyle("dropIndicatorSkin");
            if(!dropIndicatorClass)
            {
               dropIndicatorClass = ListDropIndicator;
            }
            dropIndicator = IFlexDisplayObject(new dropIndicatorClass());
            vm = viewMetrics;
            drawFocus(true);
            dropIndicator.x = 2;
            dropIndicator.setActualSize(listContent.width - 4,4);
            dropIndicator.visible = true;
            listContent.addChild(DisplayObject(dropIndicator));
            if(Boolean(collection))
            {
               dragScrollingInterval = setInterval(dragScroll,15);
            }
         }
         var rowNum:Number = calculateDropIndex(event);
         if(Boolean(lockedRowCount) && rowNum < lockedRowCount)
         {
            if(dropIndicator.parent != lockedRowContent)
            {
               lockedRowContent.addChild(DisplayObject(dropIndicator));
            }
            dropIndicator.y = lockedRowContent.listItems[rowNum][0].y - 1;
         }
         else
         {
            rowCount = int(listItems.length);
            partialRow = rowCount > 0 && rowInfo[rowCount - offscreenExtraRowsBottom - 1].y + rowInfo[rowCount - offscreenExtraRowsBottom - 1].height > listContent.heightExcludingOffsets - listContent.topOffset ? 1 : 0;
            rowNum -= verticalScrollPosition + lockedRowCount;
            if(rowNum >= rowCount)
            {
               if(Boolean(partialRow))
               {
                  rowNum = rowCount - 1;
               }
               else
               {
                  rowNum = rowCount;
               }
            }
            if(rowNum < 0)
            {
               rowNum = 0;
            }
            if(dropIndicator.parent != listContent)
            {
               listContent.addChild(DisplayObject(dropIndicator));
            }
            dropIndicator.y = calculateDropIndicatorY(rowCount,rowNum + offscreenExtraRowsTop);
         }
      }
      
      mx_internal function columnRendererChanged(c:DataGridColumn) : void
      {
      }
      
      override protected function selectItem(item:IListItemRenderer, shiftKey:Boolean, ctrlKey:Boolean, transition:Boolean = true) : Boolean
      {
         var bookmark:CursorBookmark = iterator.bookmark;
         if(Boolean(lockedRowCount))
         {
            inSelectItem = true;
            iterator.seek(CursorBookmark.FIRST,0);
         }
         var retval:Boolean = super.selectItem(item,shiftKey,ctrlKey,transition);
         if(Boolean(lockedRowCount))
         {
            iterator.seek(bookmark,0);
            inSelectItem = false;
         }
         return retval;
      }
      
      mx_internal function get dataGridLockedColumns() : ListBaseContentHolder
      {
         return lockedColumnContent;
      }
      
      override protected function addToRowArrays() : void
      {
         super.addToRowArrays();
         if(Boolean(lockedColumnCount))
         {
            lockedColumnContent.listItems.splice(0,0,null);
            lockedColumnContent.rowInfo.splice(0,0,null);
         }
      }
      
      override public function itemRendererToIndex(itemRenderer:IListItemRenderer) : int
      {
         var index:int = 0;
         if(itemRenderer.name in rowMap)
         {
            index = int(rowMap[itemRenderer.name].rowIndex);
            if(itemRenderer.parent is DataGridLockedRowContentHolder)
            {
               return index;
            }
            return index + lockedRowCount + verticalScrollPosition - offscreenExtraRowsTop;
         }
         return int.MIN_VALUE;
      }
      
      override protected function makeRowsAndColumns(left:Number, top:Number, right:Number, bottom:Number, firstCol:int, firstRow:int, byCount:Boolean = false, rowsNeeded:uint = 0) : Point
      {
         return makeRows(listContent,left,top,right,bottom,firstCol,firstRow,byCount,rowsNeeded);
      }
      
      protected function removeExtraRow(contentHolder:ListBaseContentHolder) : void
      {
         var item:IListItemRenderer = null;
         var columnContent:ListBaseContentHolder = null;
         var listItems:Array = contentHolder.listItems;
         var rowInfo:Object = contentHolder.rowInfo;
         if(contentHolder == lockedRowContent)
         {
            columnContent = lockedColumnAndRowContent;
         }
         else
         {
            columnContent = lockedColumnContent;
         }
         var rr:Array = listItems.pop();
         rowInfo.pop();
         while(Boolean(rr.length))
         {
            item = rr.pop();
            addToFreeItemRenderers(item);
         }
         if(Boolean(columnContent))
         {
            columnContent.rowInfo.pop();
            rr = columnContent.listItems.pop();
            while(Boolean(rr) && Boolean(rr.length))
            {
               item = rr.pop();
               addToFreeItemRenderers(item);
            }
         }
      }
      
      override mx_internal function selectionTween_updateHandler(event:TweenEvent) : void
      {
         var s:Sprite = null;
         super.mx_internal::selectionTween_updateHandler(event);
         if(Boolean(lockedColumnCount))
         {
            s = Sprite(event.target.listener);
            s = indicatorDictionary[s] as Sprite;
            s.alpha = Number(event.value);
         }
      }
      
      override protected function purgeItemRenderers() : void
      {
         var listItems:Array = null;
         var row:Array = null;
         var item:IListItemRenderer = null;
         if(Boolean(lockedRowContent))
         {
            listItems = lockedRowContent.listItems;
            while(Boolean(listItems.length))
            {
               row = listItems.pop();
               while(Boolean(row.length))
               {
                  item = IListItemRenderer(row.pop());
                  if(Boolean(item))
                  {
                     lockedRowContent.removeChild(DisplayObject(item));
                     delete lockedRowContent.visibleData[itemToUID(item.data)];
                  }
               }
            }
         }
         if(Boolean(lockedColumnContent))
         {
            listItems = lockedColumnContent.listItems;
            while(Boolean(listItems.length))
            {
               row = listItems.pop();
               while(Boolean(row.length))
               {
                  item = IListItemRenderer(row.pop());
                  if(Boolean(item))
                  {
                     lockedColumnContent.removeChild(DisplayObject(item));
                     delete lockedColumnContent.visibleData[itemToUID(item.data)];
                  }
               }
            }
         }
         if(Boolean(lockedColumnAndRowContent))
         {
            listItems = lockedColumnAndRowContent.listItems;
            while(Boolean(listItems.length))
            {
               row = listItems.pop();
               while(Boolean(row.length))
               {
                  item = IListItemRenderer(row.pop());
                  if(Boolean(item))
                  {
                     lockedColumnAndRowContent.removeChild(DisplayObject(item));
                     delete lockedColumnAndRowContent.visibleData[itemToUID(item.data)];
                  }
               }
            }
         }
         super.purgeItemRenderers();
      }
      
      protected function clearRow(contentHolder:ListBaseContentHolder, rowNum:int) : void
      {
         var columnContent:ListBaseContentHolder = null;
         var extraItem:IListItemRenderer = null;
         var listItems:Array = contentHolder.listItems;
         if(lockedColumnCount > 0)
         {
            if(contentHolder == lockedRowContent)
            {
               columnContent = lockedColumnAndRowContent;
            }
            else
            {
               columnContent = lockedColumnContent;
            }
         }
         else
         {
            columnContent = null;
         }
         while(Boolean(listItems[rowNum].length))
         {
            extraItem = listItems[rowNum].pop();
            addToFreeItemRenderers(extraItem);
         }
         if(Boolean(columnContent))
         {
            while(Boolean(columnContent.listItems[rowNum].length))
            {
               extraItem = columnContent.listItems[rowNum].pop();
               addToFreeItemRenderers(extraItem);
            }
         }
      }
      
      override protected function moveIndicatorsVertically(uid:String, moveBlockDistance:Number) : void
      {
         super.moveIndicatorsVertically(uid,moveBlockDistance);
         if(Boolean(lockedColumnCount))
         {
            if(Boolean(uid))
            {
               if(Boolean(selectionIndicators[uid]))
               {
                  Sprite(indicatorDictionary[selectionIndicators[uid]]).y = Sprite(indicatorDictionary[selectionIndicators[uid]]).y + moveBlockDistance;
               }
               if(highlightUID == uid)
               {
                  columnHighlightIndicator.y += moveBlockDistance;
               }
               if(caretUID == uid)
               {
                  columnCaretIndicator.y += moveBlockDistance;
               }
            }
         }
      }
      
      mx_internal function getAllVisibleColumns() : Array
      {
         var temp:Array = [];
         if(Boolean(lockedColumnCount))
         {
            temp = temp.concat(visibleLockedColumns);
         }
         return temp.concat(visibleColumns);
      }
      
      override protected function drawSelectionIndicator(indicator:Sprite, x:Number, y:Number, width:Number, height:Number, color:uint, itemRenderer:IListItemRenderer) : void
      {
         var columnContents:ListBaseContentHolder = null;
         var selectionLayer:Sprite = null;
         var columnIndicator:Sprite = null;
         super.drawSelectionIndicator(indicator,x,y,unscaledWidth - viewMetrics.left - viewMetrics.right,height,color,itemRenderer);
         if(Boolean(lockedColumnCount))
         {
            if(itemRenderer.parent == listContent)
            {
               columnContents = lockedColumnContent;
            }
            else
            {
               columnContents = lockedColumnAndRowContent;
            }
            selectionLayer = columnContents.selectionLayer;
            columnIndicator = indicatorDictionary[indicator] as Sprite;
            if(!columnIndicator)
            {
               columnIndicator = new SpriteAsset();
               columnIndicator.mouseEnabled = false;
               selectionLayer.addChild(DisplayObject(columnIndicator));
               indicator.parent.addEventListener(Event.REMOVED,selectionRemovedListener);
               indicatorDictionary[indicator] = columnIndicator;
            }
            super.drawSelectionIndicator(columnIndicator,x,y,columnContents.width,height,color,itemRenderer);
         }
      }
      
      public function get fontContext() : IFlexModuleFactory
      {
         return moduleFactory;
      }
      
      override protected function itemRendererToIndices(item:IListItemRenderer) : Point
      {
         if(!item || !(item.name in rowMap))
         {
            return null;
         }
         var content:ListBaseContentHolder = item.parent as ListBaseContentHolder;
         var found:Boolean = false;
         var index:int = int(rowMap[item.name].rowIndex);
         var len:int = int(content.listItems[index].length);
         for(var i:int = 0; i < len; i++)
         {
            if(content.listItems[index][i] == item)
            {
               found = true;
               break;
            }
         }
         if(!found)
         {
            return null;
         }
         if(lockedRowContent == content)
         {
            return new Point(i + horizontalScrollPosition + lockedColumnCount,index + offscreenExtraRowsTop);
         }
         if(lockedColumnAndRowContent == content)
         {
            return new Point(i,index + offscreenExtraRowsTop);
         }
         if(lockedColumnContent == content)
         {
            return new Point(i,index + verticalScrollPosition + lockedRowCount + offscreenExtraRowsTop);
         }
         return new Point(i + horizontalScrollPosition + lockedColumnCount,index + verticalScrollPosition + lockedRowCount + offscreenExtraRowsTop);
      }
      
      protected function updateRendererDisplayList(r:IListItemRenderer) : void
      {
         var ui:IInvalidating = null;
         if(r is IInvalidating)
         {
            ui = IInvalidating(r);
            ui.invalidateDisplayList();
            ui.validateNow();
         }
      }
      
      override public function indicesToIndex(rowIndex:int, colIndex:int) : int
      {
         if(inSelectItem)
         {
            return 0;
         }
         return rowIndex;
      }
      
      override protected function clearIndicators() : void
      {
         super.clearIndicators();
         if(Boolean(lockedColumnCount) && Boolean(lockedColumnContent))
         {
            while(lockedColumnContent.selectionLayer.numChildren > 0)
            {
               lockedColumnContent.selectionLayer.removeChildAt(0);
            }
         }
         if(Boolean(lockedRowCount) && Boolean(lockedRowContent))
         {
            while(lockedRowContent.selectionLayer.numChildren > 0)
            {
               lockedRowContent.selectionLayer.removeChildAt(0);
            }
            if(Boolean(lockedColumnCount) && Boolean(lockedColumnAndRowContent))
            {
               while(lockedColumnAndRowContent.selectionLayer.numChildren > 0)
               {
                  lockedColumnAndRowContent.selectionLayer.removeChildAt(0);
               }
            }
         }
         if(Boolean(header))
         {
            header.clearSelectionLayer();
         }
         if(Boolean(lockedColumnHeader))
         {
            lockedColumnHeader.clearSelectionLayer();
         }
      }
      
      protected function makeListData(data:Object, uid:String, rowNum:int, columnNum:int, column:DataGridColumn) : BaseListData
      {
         if(data is DataGridColumn)
         {
            return new DataGridListData(column.headerText != null ? column.headerText : column.dataField,column.dataField,columnNum,uid,this,rowNum);
         }
         return new DataGridListData(column.itemToLabel(data),column.dataField,columnNum,uid,this,rowNum);
      }
      
      override protected function drawItem(item:IListItemRenderer, selected:Boolean = false, highlighted:Boolean = false, caret:Boolean = false, transition:Boolean = false) : void
      {
         var i:int = 0;
         var r:IListItemRenderer = null;
         var columnContents:ListBaseContentHolder = null;
         if(!item)
         {
            return;
         }
         super.drawItem(item,selected,highlighted,caret,transition);
         var rowIndex:int = int(rowMap[item.name].rowIndex);
         for(i = 0; i < visibleColumns.length; i++)
         {
            r = (item.parent as ListBaseContentHolder).listItems[rowIndex][i];
            updateRendererDisplayList(r);
         }
         if(Boolean(lockedColumnCount))
         {
            if(item.parent == listContent || item.parent == lockedColumnContent)
            {
               columnContents = lockedColumnContent;
            }
            else
            {
               columnContents = lockedColumnAndRowContent;
            }
            for(i = 0; i < visibleLockedColumns.length; i++)
            {
               r = columnContents.listItems[rowIndex][i];
               updateRendererDisplayList(r);
            }
         }
      }
      
      override protected function adjustAfterRemove(items:Array, location:int, requiresValueCommit:Boolean) : Boolean
      {
         var retval:Boolean;
         var firstUID:String = null;
         var i:int = 0;
         var uid:String = null;
         var adjustIterator:Boolean = false;
         if(Boolean(lockedRowCount) && Boolean(listItems.length) && Boolean(listItems[0].length))
         {
            if(location <= lockedRowCount + verticalScrollPosition)
            {
               adjustIterator = true;
            }
            else
            {
               firstUID = rowMap[listItems[0][0].name].uid;
               for(i = 0; i < items.length; i++)
               {
                  uid = itemToUID(items[i]);
                  if(uid == firstUID && verticalScrollPosition == 0)
                  {
                     adjustIterator = true;
                     break;
                  }
               }
            }
         }
         retval = super.adjustAfterRemove(items,location,requiresValueCommit);
         if(Boolean(lockedRowCount))
         {
            if(verticalScrollPosition > 0 && location > lockedRowCount && verticalScrollPosition <= lockedRowCount && verticalScrollPosition == maxVerticalScrollPosition)
            {
               super.verticalScrollPosition = verticalScrollPosition - items.length;
               adjustIterator = true;
            }
            if(adjustIterator)
            {
               try
               {
                  iterator.seek(CursorBookmark.FIRST,lockedRowCount + verticalScrollPosition);
                  if(!iteratorValid)
                  {
                     iteratorValid = true;
                     lastSeekPending = null;
                  }
               }
               catch(e:ItemPendingError)
               {
                  lastSeekPending = new ListBaseSeekPending(CursorBookmark.FIRST,lockedRowCount + verticalScrollPosition);
                  e.addResponder(new ItemResponder(seekPendingResultHandler,seekPendingFailureHandler,lastSeekPending));
                  iteratorValid = false;
               }
            }
         }
         return retval;
      }
      
      override protected function clearCaretIndicator(indicator:Sprite, itemRenderer:IListItemRenderer) : void
      {
         super.clearCaretIndicator(indicator,itemRenderer);
         if(Boolean(lockedColumnCount))
         {
            if(Boolean(columnCaretIndicator))
            {
               Sprite(columnCaretIndicator).graphics.clear();
            }
         }
      }
      
      [Inspectable(defaultValue="0")]
      public function get lockedRowCount() : int
      {
         return _lockedRowCount;
      }
      
      mx_internal function get gridColumnMap() : Object
      {
         return columnMap;
      }
      
      override protected function UIDToItemRenderer(uid:String) : IListItemRenderer
      {
         var r:IListItemRenderer = visibleData[uid];
         if(!r)
         {
            if(Boolean(lockedRowContent))
            {
               r = lockedRowContent.visibleData[uid];
            }
         }
         if(!r)
         {
            if(Boolean(lockedColumnContent))
            {
               r = lockedColumnContent.visibleData[uid];
            }
         }
         if(!r)
         {
            if(Boolean(lockedColumnAndRowContent))
            {
               r = lockedColumnAndRowContent.visibleData[uid];
            }
         }
         return r;
      }
      
      override protected function destroyRow(i:int, numCols:int) : void
      {
         var listItems:Array = null;
         var rowInfo:Array = null;
         var visibleData:Object = null;
         var r:IListItemRenderer = null;
         var uid:String = null;
         var j:int = 0;
         super.destroyRow(i,numCols);
         if(Boolean(lockedColumnCount))
         {
            listItems = lockedColumnContent.listItems;
            numCols = int(listItems[i].length);
            rowInfo = lockedColumnContent.rowInfo;
            visibleData = lockedColumnContent.visibleData;
            uid = rowInfo[i].uid;
            removeIndicators(uid);
            for(j = 0; j < numCols; j++)
            {
               r = listItems[i][j];
               if(Boolean(r.data))
               {
                  delete visibleData[uid];
               }
               addToFreeItemRenderers(r);
            }
         }
      }
      
      public function createColumnItemRenderer(c:DataGridColumn, forHeader:Boolean, data:Object) : IListItemRenderer
      {
         var factory:IFactory = null;
         var renderer:IListItemRenderer = null;
         var d:Dictionary = null;
         var p:* = undefined;
         factory = c.getItemRendererFactory(forHeader,data);
         if(!factory)
         {
            if(!data)
            {
               factory = nullItemRenderer;
            }
            if(!factory)
            {
               factory = itemRenderer;
            }
         }
         if(factory == c.itemRenderer)
         {
            if(Boolean(freeItemRenderersTable[c]) && Boolean(freeItemRenderersTable[c].length))
            {
               renderer = freeItemRenderersTable[c].pop();
               delete c.freeItemRenderersByFactory[factory][renderer];
            }
         }
         else if(Boolean(c.freeItemRenderersByFactory))
         {
            d = c.freeItemRenderersByFactory[factory];
            if(Boolean(d))
            {
               var _loc8_:int = 0;
               var _loc9_:* = d;
               for(p in _loc9_)
               {
                  renderer = IListItemRenderer(p);
                  delete d[p];
               }
            }
         }
         if(!renderer)
         {
            renderer = factory.newInstance();
            if(Boolean(renderer))
            {
               renderer.styleName = c;
               factoryMap[renderer] = factory;
            }
         }
         if(Boolean(renderer))
         {
            renderer.owner = this;
         }
         return renderer;
      }
      
      public function set showHeaders(value:Boolean) : void
      {
         if(value == _showHeaders)
         {
            return;
         }
         _showHeaders = value;
         itemsSizeChanged = true;
         invalidateDisplayList();
         dispatchEvent(new Event("showHeadersChanged"));
      }
      
      override protected function addToFreeItemRenderers(item:IListItemRenderer) : void
      {
         var c:DataGridColumn = null;
         DisplayObject(item).visible = false;
         delete rowMap[item.name];
         var factory:IFactory = factoryMap[item];
         var UID:String = itemToUID(item.data);
         var visibleData:Object = ListBaseContentHolder(item.parent).visibleData;
         if(visibleData[UID] == item)
         {
            delete visibleData[UID];
         }
         if(Boolean(columnMap[item.name]))
         {
            c = columnMap[item.name];
            if(factory == c.itemRenderer)
            {
               if(freeItemRenderersTable[c] == undefined)
               {
                  freeItemRenderersTable[c] = [];
               }
               freeItemRenderersTable[c].push(item);
            }
            if(!c.freeItemRenderersByFactory)
            {
               c.freeItemRenderersByFactory = new Dictionary(true);
            }
            if(c.freeItemRenderersByFactory[factory] == undefined)
            {
               c.freeItemRenderersByFactory[factory] = new Dictionary(true);
            }
            c.freeItemRenderersByFactory[factory][item] = 1;
            delete columnMap[item.name];
         }
      }
      
      override protected function moveSelectionVertically(code:uint, shiftKey:Boolean, ctrlKey:Boolean) : void
      {
         var newVerticalScrollPosition:Number = NaN;
         var listItem:IListItemRenderer = null;
         var uid:String = null;
         var len:int = 0;
         var se:ScrollEvent = null;
         var bSelChanged:Boolean = false;
         showCaret = true;
         var rowCount:int = int(listItems.length);
         var onscreenRowCount:int = listItems.length - offscreenExtraRowsTop - offscreenExtraRowsBottom;
         var partialRow:int = rowInfo[rowCount - offscreenExtraRowsBottom - 1].y + rowInfo[rowCount - offscreenExtraRowsBottom - 1].height > listContent.heightExcludingOffsets - listContent.topOffset ? 1 : 0;
         var bUpdateVerticalScrollPosition:Boolean = false;
         bSelectItem = false;
         switch(code)
         {
            case Keyboard.UP:
               if(caretIndex > 0)
               {
                  --caretIndex;
                  bSelectItem = true;
                  if(caretIndex >= lockedRowCount)
                  {
                     bUpdateVerticalScrollPosition = true;
                  }
               }
               break;
            case Keyboard.DOWN:
               if(caretIndex >= lockedRowCount - 1)
               {
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
               }
               else if(caretIndex < collection.length - 1)
               {
                  ++caretIndex;
                  bSelectItem = true;
               }
               break;
            case Keyboard.PAGE_UP:
               if(caretIndex > lockedRowCount)
               {
                  if(caretIndex > verticalScrollPosition + lockedRowCount && caretIndex < verticalScrollPosition + lockedRowCount + onscreenRowCount)
                  {
                     caretIndex = verticalScrollPosition + lockedRowCount;
                  }
                  else
                  {
                     caretIndex = Math.max(caretIndex - Math.max(onscreenRowCount - partialRow,1),lockedRowCount);
                     newVerticalScrollPosition = Math.max(caretIndex,lockedRowCount) - lockedRowCount;
                  }
                  bSelectItem = true;
               }
               else
               {
                  caretIndex = 0;
                  bSelectItem = true;
               }
               break;
            case Keyboard.PAGE_DOWN:
               if(!(caretIndex >= verticalScrollPosition + lockedRowCount && caretIndex < verticalScrollPosition + lockedRowCount + onscreenRowCount - partialRow - 1))
               {
                  if(caretIndex - lockedRowCount == verticalScrollPosition && onscreenRowCount - partialRow <= 1)
                  {
                     ++caretIndex;
                  }
                  newVerticalScrollPosition = Math.min(Math.max(caretIndex - lockedRowCount,0),maxVerticalScrollPosition);
               }
               bSelectItem = true;
               break;
            case Keyboard.HOME:
               if(caretIndex > 0)
               {
                  caretIndex = 0;
                  bSelectItem = true;
                  newVerticalScrollPosition = 0;
               }
               break;
            case Keyboard.END:
               if(lockedRowCount >= collection.length)
               {
                  caretIndex = collection.length - 1;
                  bSelectItem = true;
               }
               else if(caretIndex < collection.length - 1)
               {
                  caretIndex = collection.length - 1;
                  bSelectItem = true;
                  newVerticalScrollPosition = maxVerticalScrollPosition;
               }
               break;
            case Keyboard.SPACE:
               bUpdateVerticalScrollPosition = true;
               bSelectItem = true;
         }
         if(bUpdateVerticalScrollPosition)
         {
            if(caretIndex >= verticalScrollPosition + lockedRowCount + onscreenRowCount - partialRow)
            {
               if(onscreenRowCount - partialRow == 0)
               {
                  newVerticalScrollPosition = Math.min(maxVerticalScrollPosition,Math.max(caretIndex - lockedRowCount,0));
               }
               else
               {
                  newVerticalScrollPosition = Math.min(maxVerticalScrollPosition,caretIndex - lockedRowCount - onscreenRowCount + partialRow + 1);
               }
            }
            else if(caretIndex < verticalScrollPosition + lockedRowCount)
            {
               newVerticalScrollPosition = Math.max(caretIndex - lockedRowCount,0);
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
      
      override protected function set allowItemSizeChangeNotification(value:Boolean) : void
      {
         if(Boolean(lockedColumnContent))
         {
            lockedColumnContent.allowItemSizeChangeNotification = value;
         }
         if(Boolean(lockedRowContent))
         {
            lockedRowContent.allowItemSizeChangeNotification = value;
         }
         if(Boolean(lockedColumnAndRowContent))
         {
            lockedColumnAndRowContent.allowItemSizeChangeNotification = value;
         }
         super.allowItemSizeChangeNotification = value;
      }
      
      override protected function clearVisibleData() : void
      {
         if(Boolean(lockedColumnContent))
         {
            lockedColumnContent.visibleData = {};
         }
         if(Boolean(lockedRowContent))
         {
            lockedRowContent.visibleData = {};
         }
         if(Boolean(lockedColumnAndRowContent))
         {
            lockedColumnAndRowContent.visibleData = {};
         }
         super.clearVisibleData();
      }
      
      override protected function moveRowVertically(i:int, numCols:int, moveBlockDistance:Number) : void
      {
         var listItems:Array = null;
         var rowInfo:Array = null;
         var r:IListItemRenderer = null;
         var j:int = 0;
         super.moveRowVertically(i,numCols,moveBlockDistance);
         if(Boolean(lockedColumnCount))
         {
            listItems = lockedColumnContent.listItems;
            numCols = int(listItems[i].length);
            rowInfo = lockedColumnContent.rowInfo;
            for(j = 0; j < numCols; j++)
            {
               r = listItems[i][j];
               r.move(r.x,r.y + moveBlockDistance);
            }
         }
      }
      
      override mx_internal function mouseEventToItemRendererOrEditor(event:MouseEvent) : IListItemRenderer
      {
         var currentContent:ListBaseContentHolder = null;
         var listItems:Array = null;
         var rowInfo:Array = null;
         var pt:Point = null;
         var yy:Number = NaN;
         var n:int = 0;
         var i:int = 0;
         var xx:Number = NaN;
         var m:int = 0;
         var j:int = 0;
         var isHighlight:Boolean = false;
         var target:DisplayObject = DisplayObject(event.target);
         var visibleColumns:Array = this.visibleColumns;
         if(event.target == listContent)
         {
            currentContent = listContent;
         }
         else if(event.target == lockedColumnContent)
         {
            currentContent = lockedColumnContent;
            visibleColumns = visibleLockedColumns;
         }
         else if(event.target == lockedRowContent)
         {
            currentContent = lockedRowContent;
         }
         else if(event.target == lockedColumnAndRowContent)
         {
            currentContent = lockedColumnAndRowContent;
            visibleColumns = visibleLockedColumns;
         }
         else if(event.target == highlightIndicator)
         {
            currentContent = highlightIndicator.parent.parent as ListBaseContentHolder;
            visibleColumns = this.visibleColumns;
            if(currentContent == lockedColumnContent || currentContent == lockedColumnAndRowContent)
            {
               visibleColumns = visibleLockedColumns;
            }
            isHighlight = true;
         }
         else if(event.target == columnHighlightIndicator)
         {
            currentContent = columnHighlightIndicator.parent.parent as ListBaseContentHolder;
            visibleColumns = this.visibleColumns;
            if(currentContent == lockedColumnContent || currentContent == lockedColumnAndRowContent)
            {
               visibleColumns = visibleLockedColumns;
            }
            isHighlight = true;
         }
         if(isHighlight || target == currentContent)
         {
            listItems = currentContent.listItems;
            rowInfo = currentContent.rowInfo;
            pt = new Point(event.stageX,event.stageY);
            pt = currentContent.globalToLocal(pt);
            yy = 0;
            n = int(listItems.length);
            for(i = 0; i < n; yy += rowInfo[i].height,i++)
            {
               if(Boolean(listItems[i].length))
               {
                  if(pt.y < yy + rowInfo[i].height)
                  {
                     xx = 0;
                     m = int(visibleColumns.length);
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
         while(Boolean(target) && target != this)
         {
            if(Boolean(target is IListItemRenderer && target.parent) && Boolean(target.parent.parent == this) && target.parent is ListBaseContentHolder)
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
      
      mx_internal function getWidthOfItem(item:IListItemRenderer, col:DataGridColumn) : Number
      {
         return col.width;
      }
      
      override protected function indexToRow(index:int) : int
      {
         if(index < lockedRowCount)
         {
            return -1;
         }
         return index - lockedRowCount;
      }
      
      mx_internal function get dataGridHeader() : DataGridHeaderBase
      {
         return header;
      }
      
      public function set fontContext(moduleFactory:IFlexModuleFactory) : void
      {
         this.moduleFactory = moduleFactory;
      }
      
      protected function drawVisibleItem(uid:String, selected:Boolean = false, highlighted:Boolean = false, caret:Boolean = false, transition:Boolean = false) : void
      {
         if(Boolean(visibleData[uid]))
         {
            drawItem(visibleData[uid],selected,highlighted,caret,transition);
         }
         if(Boolean(lockedRowCount) && Boolean(lockedRowContent) && Boolean(lockedRowContent.visibleData[uid]))
         {
            drawItem(lockedRowContent.visibleData[uid],selected,highlighted,caret,transition);
         }
      }
      
      protected function prepareRowArray(contentHolder:ListBaseContentHolder, rowNum:int) : void
      {
         var columnContent:ListBaseContentHolder = null;
         var listItems:Array = contentHolder.listItems;
         if(lockedColumnCount > 0)
         {
            if(contentHolder == lockedRowContent)
            {
               columnContent = lockedColumnAndRowContent;
            }
            else
            {
               columnContent = lockedColumnContent;
            }
         }
         else
         {
            columnContent = null;
         }
         if(!listItems[rowNum])
         {
            listItems[rowNum] = [];
         }
         if(Boolean(columnContent))
         {
            if(!columnContent.listItems[rowNum])
            {
               columnContent.listItems[rowNum] = [];
            }
         }
      }
      
      [Inspectable(category="General",defaultValue="true")]
      [Bindable("showHeadersChanged")]
      public function get showHeaders() : Boolean
      {
         return _showHeaders;
      }
      
      protected function adjustRow(contentHolder:ListBaseContentHolder, rowNum:int, yy:Number, hh:Number) : void
      {
         var columnContent:ListBaseContentHolder = null;
         var i:int = 0;
         var j:int = 0;
         var n:int = 0;
         var colNum:int = 0;
         var item:IListItemRenderer = null;
         var listItems:Array = contentHolder.listItems;
         if(lockedColumnCount > 0)
         {
            if(contentHolder == lockedRowContent)
            {
               columnContent = lockedColumnAndRowContent;
            }
            else
            {
               columnContent = lockedColumnContent;
            }
         }
         else
         {
            columnContent = null;
         }
         if(Boolean(listItems[rowNum]))
         {
            if(Boolean(columnContent))
            {
               n = int(columnContent.listItems[rowNum].length);
               for(j = 0; j < n; j++)
               {
                  columnContent.listItems[rowNum][j].setActualSize(columnContent.listItems[rowNum][j].width,hh - cachedPaddingTop - cachedPaddingBottom);
               }
            }
            n = int(listItems[rowNum].length);
            for(j = 0; j < n; j++)
            {
               listItems[rowNum][j].setActualSize(listItems[rowNum][j].width,hh - cachedPaddingTop - cachedPaddingBottom);
            }
         }
         if(cachedVerticalAlign != "top")
         {
            if(cachedVerticalAlign == "bottom")
            {
               colNum = int(listItems[rowNum].length);
               for(j = 0; j < colNum; j++)
               {
                  item = listItems[rowNum][j];
                  item.move(item.x,yy + hh - cachedPaddingBottom - item.getExplicitOrMeasuredHeight());
               }
               if(Boolean(columnContent))
               {
                  n = int(columnContent.listItems[rowNum].length);
                  for(j = 0; j < n; j++)
                  {
                     item = columnContent.listItems[rowNum][j];
                     item.move(item.x,yy + hh - cachedPaddingBottom - item.getExplicitOrMeasuredHeight());
                  }
               }
            }
            else
            {
               colNum = int(listItems[rowNum].length);
               for(j = 0; j < colNum; j++)
               {
                  item = listItems[rowNum][j];
                  item.move(item.x,yy + cachedPaddingTop + (hh - cachedPaddingBottom - cachedPaddingTop - item.getExplicitOrMeasuredHeight()) / 2);
               }
               if(Boolean(columnContent))
               {
                  n = int(columnContent.listItems[rowNum].length);
                  for(j = 0; j < n; j++)
                  {
                     item = columnContent.listItems[rowNum][j];
                     item.move(item.x,yy + cachedPaddingTop + (hh - cachedPaddingBottom - cachedPaddingTop - item.getExplicitOrMeasuredHeight()) / 2);
                  }
               }
            }
         }
      }
      
      override protected function restoreRowArrays(modDeltaPos:int) : void
      {
         super.restoreRowArrays(modDeltaPos);
         if(Boolean(lockedColumnCount))
         {
            lockedColumnContent.listItems.splice(0,modDeltaPos);
            lockedColumnContent.rowInfo.splice(0,modDeltaPos);
         }
      }
      
      protected function setupColumnItemRenderer(c:DataGridColumn, contentHolder:ListBaseContentHolder, rowNum:int, colNum:int, data:Object, uid:String) : IListItemRenderer
      {
         var item:IListItemRenderer = null;
         var rowData:DataGridListData = null;
         var listItems:Array = contentHolder.listItems;
         item = listItems[rowNum][colNum];
         if(!item || itemToUID(item.data) != uid || columnMap[item.name] != c)
         {
            item = createColumnItemRenderer(c,false,data);
            if(item == null)
            {
               return null;
            }
            if(item.parent != contentHolder)
            {
               contentHolder.addChild(DisplayObject(item));
            }
            columnMap[item.name] = c;
            if(Boolean(listItems[rowNum][colNum]))
            {
               addToFreeItemRenderers(listItems[rowNum][colNum]);
            }
            listItems[rowNum][colNum] = item;
         }
         rowData = DataGridListData(makeListData(data,uid,rowNum,c.colNum,c));
         rowMap[item.name] = rowData;
         if(item is IDropInListItemRenderer)
         {
            IDropInListItemRenderer(item).listData = Boolean(data) ? rowData : null;
         }
         item.data = data;
         item.visible = true;
         if(Boolean(uid) && colNum == 0)
         {
            contentHolder.visibleData[uid] = item;
         }
         return item;
      }
      
      override protected function adjustAfterAdd(items:Array, location:int) : Boolean
      {
         var retval:Boolean = super.adjustAfterAdd(items,location);
         if(Boolean(lockedRowCount))
         {
            if(verticalScrollPosition > 0 && verticalScrollPosition >= location && location <= lockedRowCount)
            {
               if(verticalScrollPosition + lockedRowCount >= collection.length)
               {
                  super.verticalScrollPosition = verticalScrollPosition - items.length;
               }
            }
            if(collection.length - items.length <= lockedRowCount && collection.length >= lockedRowCount || location <= lockedRowCount || location == lockedRowCount + verticalScrollPosition)
            {
               try
               {
                  iterator.seek(CursorBookmark.FIRST,lockedRowCount + verticalScrollPosition);
                  if(!iteratorValid)
                  {
                     iteratorValid = true;
                     lastSeekPending = null;
                  }
               }
               catch(e:ItemPendingError)
               {
                  lastSeekPending = new ListBaseSeekPending(CursorBookmark.FIRST,lockedRowCount + verticalScrollPosition);
                  e.addResponder(new ItemResponder(seekPendingResultHandler,seekPendingFailureHandler,lastSeekPending));
                  iteratorValid = false;
               }
            }
         }
         return retval;
      }
      
      protected function calculateRowHeight(data:Object, hh:Number, skipVisible:Boolean = false) : Number
      {
         return NaN;
      }
      
      public function set columns(value:Array) : void
      {
      }
      
      public function get columns() : Array
      {
         return null;
      }
      
      public function set lockedColumnCount(value:int) : void
      {
         _lockedColumnCount = value;
         lockedColumnCountChanged = true;
         itemsSizeChanged = true;
         columnsInvalid = true;
         invalidateDisplayList();
      }
      
      mx_internal function get dataGridLockedColumnHeader() : DataGridHeaderBase
      {
         return lockedColumnHeader;
      }
      
      protected function makeRows(contentHolder:ListBaseContentHolder, left:Number, top:Number, right:Number, bottom:Number, firstCol:int, firstRow:int, byCount:Boolean = false, rowsNeeded:uint = 0, alwaysCleanup:Boolean = false) : Point
      {
         var more:Boolean;
         var valid:Boolean;
         var xx:Number = NaN;
         var yy:Number = NaN;
         var hh:Number = NaN;
         var i:int = 0;
         var j:int = 0;
         var n:int = 0;
         var item:IListItemRenderer = null;
         var data:Object = null;
         var uid:String = null;
         var bSelected:Boolean = false;
         var bHighlight:Boolean = false;
         var bCaret:Boolean = false;
         var colNum:int = 0;
         var rowNum:int = 0;
         var rowsMade:int = 0;
         var listItems:Array = contentHolder.listItems;
         var iterator:IViewCursor = contentHolder.iterator;
         var visibleData:Object = contentHolder.visibleData;
         var rowInfo:Object = contentHolder.rowInfo;
         if((!visibleColumns || visibleColumns.length == 0) && lockedColumnCount == 0)
         {
            while(Boolean(listItems.length))
            {
               rowNum = listItems.length - 1;
               while(Boolean(listItems[rowNum].length))
               {
                  item = listItems[rowNum].pop();
                  addToFreeItemRenderers(item);
               }
               listItems.pop();
            }
            contentHolder.visibleData = {};
            return new Point(0,0);
         }
         invalidateSizeFlag = true;
         more = true;
         valid = true;
         yy = top;
         rowNum = firstRow;
         more = iterator != null && !iterator.afterLast && iteratorValid;
         while(!byCount && yy < bottom || byCount && rowsNeeded > 0)
         {
            if(byCount)
            {
               rowsNeeded--;
            }
            valid = more;
            data = more ? iterator.current : null;
            if(Boolean(iterator) && more)
            {
               try
               {
                  more = iterator.moveNext();
               }
               catch(e:ItemPendingError)
               {
                  lastSeekPending = new ListBaseSeekPending(CursorBookmark.CURRENT,0);
                  e.addResponder(new ItemResponder(seekPendingResultHandler,seekPendingFailureHandler,lastSeekPending));
                  more = false;
                  iteratorValid = false;
               }
            }
            hh = 0;
            uid = null;
            prepareRowArray(contentHolder,rowNum);
            if(valid)
            {
               uid = itemToUID(data);
               hh = makeRow(contentHolder,rowNum,left,right,yy,data,uid);
            }
            else
            {
               hh = rowNum > 1 ? Number(rowInfo[rowNum - 1].height) : rowHeight;
            }
            if(valid && variableRowHeight)
            {
               hh = Math.ceil(calculateRowHeight(data,hh,true));
            }
            if(valid)
            {
               adjustRow(contentHolder,rowNum,yy,hh);
            }
            else
            {
               clearRow(contentHolder,rowNum);
            }
            bSelected = selectedData[uid] != null;
            bHighlight = highlightUID == uid;
            bCaret = caretUID == uid;
            setRowInfo(contentHolder,rowNum,yy,hh,uid);
            if(valid)
            {
               drawVisibleItem(uid,bSelected,bHighlight,bCaret);
            }
            if(hh == 0)
            {
               hh = rowHeight;
            }
            yy += hh;
            rowNum++;
            rowsMade++;
         }
         if(!byCount || alwaysCleanup)
         {
            while(rowNum < listItems.length)
            {
               removeExtraRow(contentHolder);
            }
         }
         invalidateSizeFlag = false;
         return new Point(colNum,rowsMade);
      }
      
      override protected function clearHighlightIndicator(indicator:Sprite, itemRenderer:IListItemRenderer) : void
      {
         super.clearHighlightIndicator(indicator,itemRenderer);
         if(Boolean(lockedColumnCount))
         {
            if(Boolean(columnHighlightIndicator))
            {
               Sprite(columnHighlightIndicator).graphics.clear();
            }
         }
      }
      
      mx_internal function columnWordWrap(c:DataGridColumn) : Boolean
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
      
      protected function setRowInfo(contentHolder:ListBaseContentHolder, rowNum:int, yy:Number, hh:Number, uid:String) : void
      {
         var columnContent:ListBaseContentHolder = null;
         var listItems:Array = contentHolder.listItems;
         var rowInfo:Object = contentHolder.rowInfo;
         if(lockedColumnCount > 0)
         {
            if(contentHolder == lockedRowContent)
            {
               columnContent = lockedColumnAndRowContent;
            }
            else
            {
               columnContent = lockedColumnContent;
            }
         }
         else
         {
            columnContent = null;
         }
         rowInfo[rowNum] = new ListRowInfo(yy,hh,uid);
         if(Boolean(columnContent))
         {
            columnContent.rowInfo[rowNum] = rowInfo[rowNum];
         }
      }
      
      override protected function truncateRowArrays(numRows:int) : void
      {
         super.truncateRowArrays(numRows);
         if(Boolean(lockedColumnCount))
         {
            lockedColumnContent.listItems.splice(numRows);
            lockedColumnContent.rowInfo.splice(numRows);
         }
      }
      
      [Inspectable(defaultValue="0")]
      public function get lockedColumnCount() : int
      {
         return _lockedColumnCount;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var ci:int = 0;
         var lcri:int = 0;
         if(headerVisible && Boolean(header))
         {
            header.visibleColumns = visibleColumns;
            header.headerItemsChanged = true;
            header.invalidateSize();
            header.validateNow();
         }
         if(lockedColumnCountChanged)
         {
            lockedColumnCountChanged = false;
            if(lockedColumnCount > 0)
            {
               if(!lockedColumnContent)
               {
                  lockedColumnHeader = new headerClass();
                  lockedColumnHeader.styleName = this;
                  addChild(lockedColumnHeader);
                  lockedColumnAndRowContent = new DataGridLockedRowContentHolder(this);
                  lockedColumnAndRowContent.styleName = this;
                  addChild(lockedColumnAndRowContent);
                  lockedColumnContent = new ListBaseContentHolder(this);
                  lockedColumnContent.styleName = this;
                  addChild(lockedColumnContent);
               }
               lockedColumnHeader.visible = true;
               lockedColumnAndRowContent.visible = lockedRowCount > 0;
               lockedColumnContent.visible = true;
            }
            else if(Boolean(lockedColumnContent))
            {
               lockedColumnHeader.visible = false;
               lockedColumnAndRowContent.visible = false;
               lockedColumnContent.visible = false;
            }
         }
         if(lockedRowCountChanged && Boolean(iterator))
         {
            lockedRowCountChanged = false;
            if(lockedRowCount > 0)
            {
               if(!lockedRowContent)
               {
                  lockedRowContent = new DataGridLockedRowContentHolder(this);
                  lockedRowContent.styleName = this;
                  addChild(lockedRowContent);
               }
               lockedRowContent.visible = true;
            }
            else if(Boolean(lockedRowContent))
            {
               lockedRowContent.visible = false;
            }
            if(Boolean(lockedColumnAndRowContent))
            {
               lockedColumnAndRowContent.visible = lockedRowCount > 0 && lockedColumnCount > 0;
            }
            seekPositionSafely(lockedRowCount + verticalScrollPosition);
         }
         if(Boolean(lockedRowContent) && Boolean(lockedColumnAndRowContent))
         {
            lcri = getChildIndex(lockedColumnAndRowContent);
            ci = getChildIndex(lockedRowContent);
            if(lcri < ci)
            {
               setChildIndex(lockedRowContent,lcri);
            }
         }
         if(Boolean(lockedColumnContent) && Boolean(lockedColumnAndRowContent))
         {
            lcri = getChildIndex(lockedColumnAndRowContent);
            ci = getChildIndex(lockedColumnContent);
            if(lcri < ci)
            {
               setChildIndex(lockedColumnContent,lcri);
            }
         }
         if(headerVisible && Boolean(lockedColumnHeader))
         {
            lockedColumnHeader.visibleColumns = visibleLockedColumns;
            lockedColumnHeader.headerItemsChanged = true;
            lockedColumnHeader.invalidateSize();
            lockedColumnHeader.validateNow();
         }
         super.updateDisplayList(unscaledWidth,unscaledHeight);
      }
      
      public function set lockedRowCount(value:int) : void
      {
         _lockedRowCount = value;
         lockedRowCountChanged = true;
         itemsSizeChanged = true;
         invalidateDisplayList();
      }
   }
}

