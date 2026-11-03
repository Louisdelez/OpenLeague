package mx.controls.listClasses
{
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   import flash.utils.setInterval;
   import mx.collections.CursorBookmark;
   import mx.collections.ItemResponder;
   import mx.collections.ItemWrapper;
   import mx.collections.ModifiedCollectionView;
   import mx.collections.errors.ItemPendingError;
   import mx.controls.scrollClasses.ScrollBar;
   import mx.core.ClassFactory;
   import mx.core.EdgeMetrics;
   import mx.core.FlexShape;
   import mx.core.FlexSprite;
   import mx.core.IFactory;
   import mx.core.IFlexDisplayObject;
   import mx.core.UIComponentGlobals;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.events.DragEvent;
   import mx.events.ListEvent;
   import mx.events.ScrollEvent;
   import mx.events.ScrollEventDetail;
   import mx.events.ScrollEventDirection;
   import mx.skins.halo.ListDropIndicator;
   
   public class TileBase extends ListBase
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var bShiftKey:Boolean = false;
      
      private var bCtrlKey:Boolean = false;
      
      private var lastKey:uint = 0;
      
      private var bSelectItem:Boolean = false;
      
      private var lastColumnCount:int = 0;
      
      private var lastRowCount:int = 0;
      
      protected var measuringObjects:Dictionary;
      
      private var _direction:String = "horizontal";
      
      private var _maxColumns:int = 0;
      
      private var _maxRows:int = 0;
      
      public function TileBase()
      {
         super();
         this.itemRenderer = new ClassFactory(TileListItemRenderer);
         setRowHeight(50);
         setColumnWidth(50);
      }
      
      [Inspectable(category="General",enumeration="vertical,horizontal",defaultValue="horizontal")]
      [Bindable("directionChanged")]
      public function get direction() : String
      {
         return this._direction;
      }
      
      public function set direction(value:String) : void
      {
         this._direction = value;
         itemsSizeChanged = true;
         offscreenExtraRowsOrColumnsChanged = true;
         if(Boolean(listContent))
         {
            if(this.direction == TileBaseDirection.HORIZONTAL)
            {
               listContent.leftOffset = listContent.rightOffset = 0;
               offscreenExtraColumnsLeft = offscreenExtraColumnsRight = 0;
            }
            else
            {
               listContent.topOffset = listContent.bottomOffset = 0;
               offscreenExtraRowsTop = offscreenExtraRowsBottom = 0;
            }
         }
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
         dispatchEvent(new Event("directionChanged"));
      }
      
      [Inspectable(category="General",defaultValue="0")]
      public function get maxColumns() : int
      {
         return this._maxColumns;
      }
      
      public function set maxColumns(value:int) : void
      {
         if(this._maxColumns != value)
         {
            this._maxColumns = value;
            invalidateSize();
            invalidateDisplayList();
         }
      }
      
      [Inspectable(category="General",defaultValue="0")]
      public function get maxRows() : int
      {
         return this._maxRows;
      }
      
      public function set maxRows(value:int) : void
      {
         if(this._maxRows != value)
         {
            this._maxRows = value;
            invalidateSize();
            invalidateDisplayList();
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         listContent.mask = maskShape;
      }
      
      override protected function makeRowsAndColumns(left:Number, top:Number, right:Number, bottom:Number, firstCol:int, firstRow:int, byCount:Boolean = false, rowsNeeded:uint = 0) : Point
      {
         var numRows:int = 0;
         var numCols:int = 0;
         var colNum:int = 0;
         var rowNum:int = 0;
         var xx:Number = NaN;
         var yy:Number = NaN;
         var wrappedData:Object = null;
         var data:Object = null;
         var uid:String = null;
         var oldItem:IListItemRenderer = null;
         var item:IListItemRenderer = null;
         var more:Boolean = false;
         var valid:Boolean = false;
         var i:int = 0;
         var rh:Number = NaN;
         var lastRowMade:int = 0;
         var lastColumnMade:int = 0;
         var a:Array = null;
         var bSelected:Boolean = false;
         var bHighlight:Boolean = false;
         var bCaret:Boolean = false;
         if(columnWidth == 0 || rowHeight == 0)
         {
            return null;
         }
         invalidateSizeFlag = true;
         allowItemSizeChangeNotification = false;
         if(this.direction == TileBaseDirection.VERTICAL)
         {
            numRows = this.maxRows > 0 ? this.maxRows : int(Math.max(Math.floor(listContent.heightExcludingOffsets / rowHeight),1));
            numCols = Math.max(Math.ceil(listContent.widthExcludingOffsets / columnWidth),1);
            setRowCount(numRows);
            setColumnCount(numCols);
            colNum = firstCol;
            xx = left;
            yy = top;
            lastColumnMade = colNum - 1;
            more = iterator != null && !iterator.afterLast && iteratorValid;
            if(!byCount && yy < bottom || byCount)
            {
               while(Boolean(byCount) && Boolean(rowsNeeded--) || !byCount && colNum < numCols + firstCol)
               {
                  rowNum = firstRow;
                  yy = top;
                  while(rowNum < numRows)
                  {
                     valid = more;
                     wrappedData = more ? iterator.current : null;
                     data = wrappedData is ItemWrapper ? wrappedData.data : wrappedData;
                     more = this.moveNextSafely(more);
                     if(!listItems[rowNum])
                     {
                        listItems[rowNum] = [];
                     }
                     if(valid && yy < bottom)
                     {
                        uid = itemToUID(wrappedData);
                        rowInfo[rowNum] = new ListRowInfo(yy,rowHeight,uid);
                        item = this.getPreparedItemRenderer(rowNum,colNum,wrappedData,data,uid);
                        this.placeAndDrawItemRenderer(item,xx,yy,uid);
                        lastColumnMade = Math.max(colNum,lastColumnMade);
                     }
                     else
                     {
                        oldItem = listItems[rowNum][colNum];
                        if(Boolean(oldItem))
                        {
                           addToFreeItemRenderers(oldItem);
                           listItems[rowNum][colNum] = null;
                        }
                        rowInfo[rowNum] = new ListRowInfo(yy,rowHeight,uid);
                     }
                     yy += rowHeight;
                     rowNum++;
                  }
                  colNum++;
                  if(Boolean(firstRow))
                  {
                     for(i = 0; i < firstRow; i++)
                     {
                        more = this.moveNextSafely(more);
                     }
                  }
                  xx += columnWidth;
               }
            }
         }
         else
         {
            numCols = this.maxColumns > 0 ? this.maxColumns : int(Math.max(Math.floor(listContent.widthExcludingOffsets / columnWidth),1));
            numRows = Math.max(Math.ceil(listContent.heightExcludingOffsets / rowHeight),1);
            setColumnCount(numCols);
            setRowCount(numRows);
            rowNum = firstRow;
            yy = top;
            xx = left;
            more = iterator != null && !iterator.afterLast && iteratorValid;
            lastRowMade = rowNum - 1;
            if(!byCount && xx < right || byCount)
            {
               while(Boolean(byCount) && Boolean(rowsNeeded--) || !byCount && rowNum < numRows + firstRow)
               {
                  colNum = firstCol;
                  xx = left;
                  rowInfo[rowNum] = null;
                  while(colNum < numCols)
                  {
                     valid = more;
                     wrappedData = more ? iterator.current : null;
                     data = wrappedData is ItemWrapper ? wrappedData.data : wrappedData;
                     more = this.moveNextSafely(more);
                     if(!listItems[rowNum])
                     {
                        listItems[rowNum] = [];
                     }
                     if(valid && xx < right)
                     {
                        uid = itemToUID(wrappedData);
                        if(!rowInfo[rowNum])
                        {
                           rowInfo[rowNum] = new ListRowInfo(yy,rowHeight,uid);
                        }
                        item = this.getPreparedItemRenderer(rowNum,colNum,wrappedData,data,uid);
                        this.placeAndDrawItemRenderer(item,xx,yy,uid);
                        lastRowMade = rowNum;
                     }
                     else
                     {
                        if(!rowInfo[rowNum])
                        {
                           rowInfo[rowNum] = new ListRowInfo(yy,rowHeight,uid);
                        }
                        oldItem = listItems[rowNum][colNum];
                        if(Boolean(oldItem))
                        {
                           addToFreeItemRenderers(oldItem);
                           listItems[rowNum][colNum] = null;
                        }
                     }
                     xx += columnWidth;
                     colNum++;
                  }
                  rowNum++;
                  if(Boolean(firstCol))
                  {
                     for(i = 0; i < firstCol; i++)
                     {
                        more = this.moveNextSafely(more);
                     }
                  }
                  yy += rowHeight;
               }
            }
         }
         if(!byCount)
         {
            while(listItems.length > numRows + offscreenExtraRowsTop)
            {
               a = listItems.pop();
               rowInfo.pop();
               for(i = 0; i < a.length; i++)
               {
                  oldItem = a[i];
                  if(Boolean(oldItem))
                  {
                     addToFreeItemRenderers(oldItem);
                  }
               }
            }
            if(Boolean(listItems.length) && listItems[0].length > numCols + offscreenExtraColumnsLeft)
            {
               for(i = 0; i < numRows + offscreenExtraRowsTop; i++)
               {
                  a = listItems[i];
                  while(a.length > numCols + offscreenExtraColumnsLeft)
                  {
                     oldItem = a.pop();
                     if(Boolean(oldItem))
                     {
                        addToFreeItemRenderers(oldItem);
                     }
                  }
               }
            }
         }
         allowItemSizeChangeNotification = true;
         invalidateSizeFlag = false;
         return new Point(lastColumnMade - firstCol + 1,lastRowMade - firstRow + 1);
      }
      
      private function moveNextSafely(more:Boolean) : Boolean
      {
         if(Boolean(iterator) && more)
         {
            try
            {
               more = Boolean(iterator.moveNext());
            }
            catch(e1:ItemPendingError)
            {
               lastSeekPending = new ListBaseSeekPending(CursorBookmark.CURRENT,0);
               e1.addResponder(new ItemResponder(seekPendingResultHandler,seekPendingFailureHandler,lastSeekPending));
               more = false;
               iteratorValid = false;
            }
         }
         return more;
      }
      
      private function getPreparedItemRenderer(rowNum:int, colNum:int, wrappedData:Object, data:Object, uid:String) : IListItemRenderer
      {
         var item:IListItemRenderer = null;
         var rowData:ListData = null;
         var ld:ListData = null;
         var oldItem:IListItemRenderer = listItems[rowNum][colNum];
         if(Boolean(oldItem))
         {
            if(runningDataEffect ? dataItemWrappersByRenderer[oldItem] != wrappedData : oldItem.data != data)
            {
               addToFreeItemRenderers(oldItem);
            }
            else
            {
               item = oldItem;
            }
         }
         if(!item)
         {
            if(allowRendererStealingDuringLayout)
            {
               item = visibleData[uid];
               if(!item && wrappedData != data)
               {
                  item = visibleData[itemToUID(data)];
               }
            }
            if(Boolean(item))
            {
               ld = ListData(rowMap[item.name]);
               if(Boolean(ld))
               {
                  if(this.direction == TileBaseDirection.HORIZONTAL && (ld.rowIndex > rowNum || ld.rowIndex == rowNum && ld.columnIndex > colNum) || this.direction == TileBaseDirection.VERTICAL && (ld.columnIndex > colNum || ld.columnIndex == colNum && ld.rowIndex > rowNum))
                  {
                     listItems[ld.rowIndex][ld.columnIndex] = null;
                  }
                  else
                  {
                     item = null;
                  }
               }
            }
            if(!item)
            {
               item = getReservedOrFreeItemRenderer(wrappedData);
               if(Boolean(item) && !isRendererUnconstrained(item))
               {
                  item.x = 0;
                  item.y = 0;
               }
            }
            if(!item)
            {
               item = this.createItemRenderer(data);
            }
            item.owner = this;
            item.styleName = listContent;
         }
         if(!item.parent)
         {
            listContent.addChild(DisplayObject(item));
         }
         rowData = ListData(this.makeListData(data,uid,rowNum,colNum));
         rowMap[item.name] = rowData;
         if(item is IDropInListItemRenderer)
         {
            IDropInListItemRenderer(item).listData = Boolean(data) ? rowData : null;
         }
         item.data = data;
         if(wrappedData != data)
         {
            dataItemWrappersByRenderer[item] = wrappedData;
         }
         item.visible = true;
         if(Boolean(uid))
         {
            visibleData[uid] = item;
         }
         listItems[rowNum][colNum] = item;
         UIComponentGlobals.layoutManager.validateClient(item,true);
         return item;
      }
      
      private function placeAndDrawItemRenderer(item:IListItemRenderer, xx:Number, yy:Number, uid:String) : void
      {
         var rh:Number = NaN;
         var bSelected:Boolean = false;
         var bHighlight:Boolean = false;
         var bCaret:Boolean = false;
         rh = Number(item.getExplicitOrMeasuredHeight());
         if(item.width != columnWidth || rh != rowHeight - cachedPaddingTop - cachedPaddingBottom)
         {
            item.setActualSize(columnWidth,rowHeight - cachedPaddingTop - cachedPaddingBottom);
         }
         if(!isRendererUnconstrained(item))
         {
            item.move(xx,yy + cachedPaddingTop);
         }
         bSelected = selectedData[uid] != null;
         if(runningDataEffect)
         {
            bSelected ||= selectedData[itemToUID(item.data)] != null;
            bSelected = bSelected && !getRendererSemanticValue(item,ModifiedCollectionView.REPLACEMENT) && !getRendererSemanticValue(item,ModifiedCollectionView.ADDED);
         }
         bHighlight = highlightUID == uid;
         bCaret = caretUID == uid;
         if(Boolean(uid))
         {
            drawItem(item,bSelected,bHighlight,bCaret);
         }
      }
      
      override protected function configureScrollBars() : void
      {
         var numRows:int = 0;
         var numCols:int = 0;
         var index:int = 0;
         var fillerCols:int = 0;
         var expectedFullColumns:int = 0;
         var extraEmptyColumns:int = 0;
         var i:int = 0;
         var fillerRows:int = 0;
         var rowCount:int = int(listItems.length);
         if(rowCount == 0)
         {
            return;
         }
         var colCount:int = int(listItems[0].length);
         if(colCount == 0)
         {
            return;
         }
         if(rowCount > 1 && (rowCount - offscreenExtraRowsTop - offscreenExtraRowsBottom) * rowHeight > listContent.heightExcludingOffsets)
         {
            rowCount--;
         }
         rowCount -= offscreenExtraRowsTop + offscreenExtraRowsBottom;
         if(colCount > 1 && (colCount - offscreenExtraColumnsLeft - offscreenExtraColumnsRight) * columnWidth > listContent.widthExcludingOffsets)
         {
            colCount--;
         }
         colCount -= offscreenExtraColumnsLeft + offscreenExtraColumnsRight;
         var oldHorizontalScrollBar:Object = horizontalScrollBar;
         var oldVerticalScrollBar:Object = verticalScrollBar;
         if(this.direction == TileBaseDirection.VERTICAL)
         {
            if(iteratorValid && horizontalScrollPosition > 0)
            {
               fillerCols = 0;
               while(colCount > 0 && listItems[0][colCount + offscreenExtraColumnsLeft - 1] == null)
               {
                  colCount--;
                  fillerCols++;
               }
               expectedFullColumns = Math.floor(listContent.widthExcludingOffsets / columnWidth);
               extraEmptyColumns = Math.max(0,expectedFullColumns - (colCount + fillerCols));
               if(Boolean(fillerCols) || Boolean(extraEmptyColumns))
               {
                  for(i = 0; i < listItems.length; i++)
                  {
                     while(listItems[i].length > colCount + offscreenExtraColumnsLeft)
                     {
                        (listItems[i] as Array).pop();
                     }
                  }
                  if(!runningDataEffect)
                  {
                     horizontalScrollPosition = Math.max(0,horizontalScrollPosition - (fillerCols + extraEmptyColumns));
                     index = this.scrollPositionToIndex(Math.max(0,horizontalScrollPosition - offscreenExtraColumnsLeft),verticalScrollPosition);
                     seekPositionSafely(index);
                     updateList();
                  }
                  return;
               }
            }
            if(!iteratorValid)
            {
               rowCount = Math.floor(listContent.heightExcludingOffsets / rowHeight);
            }
            numRows = this.maxRows > 0 ? this.maxRows : rowCount;
            numCols = Boolean(collection) ? int(Math.ceil(collection.length / numRows)) : colCount;
         }
         else
         {
            if(iteratorValid && verticalScrollPosition > 0)
            {
               fillerRows = 0;
               while(rowCount > 0 && (listItems[rowCount + offscreenExtraRowsTop - 1] == null || listItems[rowCount + offscreenExtraRowsTop - 1][0] == null))
               {
                  rowCount--;
                  fillerRows++;
               }
               if(Boolean(fillerRows))
               {
                  while(listItems.length > rowCount + offscreenExtraRowsTop)
                  {
                     listItems.pop();
                     rowInfo.pop();
                  }
                  if(!runningDataEffect)
                  {
                     verticalScrollPosition = Math.max(0,verticalScrollPosition - fillerRows);
                     index = this.scrollPositionToIndex(horizontalScrollPosition,Math.max(0,verticalScrollPosition - offscreenExtraRowsTop));
                     seekPositionSafely(index);
                     updateList();
                  }
                  return;
               }
            }
            if(!iteratorValid)
            {
               colCount = Math.floor(listContent.widthExcludingOffsets / columnWidth);
            }
            numCols = this.maxColumns > 0 ? this.maxColumns : colCount;
            numRows = Boolean(collection) ? int(Math.ceil(collection.length / numCols)) : rowCount;
         }
         maxHorizontalScrollPosition = Math.max(0,numCols - colCount);
         maxVerticalScrollPosition = Math.max(0,numRows - rowCount);
         setScrollBarProperties(numCols,colCount,numRows,rowCount);
      }
      
      override protected function scrollVertically(pos:int, deltaPos:int, scrollUp:Boolean) : void
      {
         var numRows:int = 0;
         var numCols:int = 0;
         var curY:Number = NaN;
         var uid:String = null;
         var index:int = 0;
         var moveBlockDistance:Number = NaN;
         var modDeltaPos:int = 0;
         var rowsToClear:int = 0;
         var rowDelta:int = 0;
         var partialRowOffset:int = 0;
         var j:int = 0;
         var r:IListItemRenderer = null;
         var rowsNeeded:int = 0;
         var actual:Point = null;
         var extraEmptyRows:int = 0;
         this.removeClipMask();
         var oldOffscreenExtraRowsBottom:int = offscreenExtraRowsBottom;
         var oldOffscreenExtraRowsTop:int = offscreenExtraRowsTop;
         var desiredOffscreenExtraRowsTop:int = offscreenExtraRows / 2;
         var desiredOffscreenExtraRowsBottom:int = offscreenExtraRows / 2;
         if(scrollUp)
         {
            offscreenExtraRowsTop = Math.min(desiredOffscreenExtraRowsTop,offscreenExtraRowsTop + deltaPos);
            modDeltaPos = deltaPos - (offscreenExtraRowsTop - oldOffscreenExtraRowsTop);
            rowsToClear = modDeltaPos;
         }
         else
         {
            partialRowOffset = Boolean(offscreenExtraRowsBottom == 0) && Boolean(listItems.length) && Boolean(listItems[listItems.length - 1][0]) && listItems[listItems.length - 1][0].y + rowHeight < listContent.heightExcludingOffsets - listContent.topOffset ? 1 : 0;
            offscreenExtraRowsTop = Math.min(desiredOffscreenExtraRowsTop,pos);
            offscreenExtraRowsBottom = Math.min(offscreenExtraRowsBottom + deltaPos - partialRowOffset,desiredOffscreenExtraRowsBottom);
            modDeltaPos = deltaPos - (oldOffscreenExtraRowsTop - offscreenExtraRowsTop);
            rowDelta = offscreenExtraRowsTop - oldOffscreenExtraRowsTop + partialRowOffset + (offscreenExtraRowsBottom - oldOffscreenExtraRowsBottom);
            rowsToClear = deltaPos - (offscreenExtraRowsBottom - oldOffscreenExtraRowsBottom) - partialRowOffset;
         }
         var rowCount:int = int(listItems.length);
         for(var i:int = 0; i < rowsToClear; i++)
         {
            numCols = scrollUp ? int(listItems[i].length) : int(listItems[rowCount - i - 1].length);
            j = 0;
            while(j < columnCount && j < numCols)
            {
               r = scrollUp ? listItems[i][j] : listItems[rowCount - i - 1][j];
               if(Boolean(r))
               {
                  delete visibleData[rowMap[r.name].uid];
                  removeIndicators(rowMap[r.name].uid);
                  addToFreeItemRenderers(r);
                  delete rowMap[r.name];
                  if(scrollUp)
                  {
                     listItems[i][j] = null;
                  }
                  else
                  {
                     listItems[rowCount - i - 1][j] = null;
                  }
               }
               j++;
            }
         }
         var actualRowCount:int = int(listItems.length);
         if(scrollUp)
         {
            moveBlockDistance = modDeltaPos * rowHeight;
            curY = 0;
            for(i = modDeltaPos; i < actualRowCount; i++)
            {
               numCols = int(listItems[i].length);
               j = 0;
               while(j < columnCount && j < numCols)
               {
                  r = listItems[i][j];
                  listItems[i - modDeltaPos][j] = r;
                  if(Boolean(r))
                  {
                     r.y -= moveBlockDistance;
                     rowMap[r.name].rowIndex -= modDeltaPos;
                     moveIndicatorsVertically(rowMap[r.name].uid,-moveBlockDistance);
                  }
                  j++;
               }
               if(numCols < columnCount)
               {
                  for(j = numCols; j < columnCount; j++)
                  {
                     listItems[i - modDeltaPos][j] = null;
                  }
               }
               rowInfo[i - modDeltaPos] = rowInfo[i];
               rowInfo[i - modDeltaPos].y -= moveBlockDistance;
               curY = rowInfo[i - modDeltaPos].y + rowHeight;
            }
            listItems.splice(actualRowCount - modDeltaPos - 1,modDeltaPos);
            rowInfo.splice(actualRowCount - modDeltaPos - 1,modDeltaPos);
            index = this.indicesToIndex(verticalScrollPosition - offscreenExtraRowsTop + actualRowCount - modDeltaPos,horizontalScrollPosition);
            seekPositionSafely(index);
            rowsNeeded = deltaPos + (desiredOffscreenExtraRowsBottom - oldOffscreenExtraRowsBottom);
            actual = this.makeRowsAndColumns(0,curY,listContent.width,curY + deltaPos * rowHeight,0,actualRowCount - modDeltaPos,true,rowsNeeded);
            extraEmptyRows = rowsNeeded - actual.y;
            while(Boolean(extraEmptyRows--))
            {
               listItems.pop();
               rowInfo.pop();
            }
            index = this.indicesToIndex(verticalScrollPosition - offscreenExtraRowsTop,horizontalScrollPosition);
            seekPositionSafely(index);
            offscreenExtraRowsBottom = Math.max(0,desiredOffscreenExtraRowsBottom - (actual.y < deltaPos ? rowsNeeded - actual.y : 0));
         }
         else
         {
            if(rowDelta < 0)
            {
               listItems.splice(listItems.length + rowDelta,-rowDelta);
               rowInfo.splice(rowInfo.length + rowDelta,-rowDelta);
            }
            else if(rowDelta > 0)
            {
               for(i = 0; i < rowDelta; i++)
               {
                  listItems[actualRowCount + i] = [];
               }
            }
            moveBlockDistance = modDeltaPos * rowHeight;
            curY = Number(rowInfo[modDeltaPos].y);
            for(i = listItems.length - 1 - modDeltaPos; i >= 0; i--)
            {
               numCols = int(listItems[i].length);
               j = 0;
               while(j < columnCount && j < numCols)
               {
                  r = listItems[i][j];
                  if(Boolean(r))
                  {
                     r.y += moveBlockDistance;
                     rowMap[r.name].rowIndex += modDeltaPos;
                     uid = rowMap[r.name].uid;
                     listItems[i + modDeltaPos][j] = r;
                     moveIndicatorsVertically(uid,moveBlockDistance);
                  }
                  else
                  {
                     listItems[i + modDeltaPos][j] = null;
                  }
                  j++;
               }
               rowInfo[i + modDeltaPos] = rowInfo[i];
               rowInfo[i + modDeltaPos].y += moveBlockDistance;
            }
            for(i = 0; i < modDeltaPos; i++)
            {
               for(j = 0; j < columnCount; j++)
               {
                  listItems[i][j] = null;
               }
            }
            index = this.indicesToIndex(verticalScrollPosition - offscreenExtraRowsTop,horizontalScrollPosition);
            seekPositionSafely(index);
            allowRendererStealingDuringLayout = false;
            actual = this.makeRowsAndColumns(0,0,listContent.width,curY,0,0,true,modDeltaPos);
            allowRendererStealingDuringLayout = true;
            seekPositionSafely(index);
         }
         var oldListContentHeight:Number = listContent.heightExcludingOffsets;
         listContent.topOffset = -rowHeight * offscreenExtraRowsTop;
         listContent.bottomOffset = Boolean(offscreenExtraRowsBottom) ? rowInfo[rowInfo.length - 1].y + rowHeight + listContent.topOffset - oldListContentHeight : 0;
         this.adjustListContent();
         this.addClipMask(false);
      }
      
      override protected function scrollHorizontally(pos:int, deltaPos:int, scrollUp:Boolean) : void
      {
         var numRows:int = 0;
         var numCols:int = 0;
         var curX:Number = NaN;
         var uid:String = null;
         var index:int = 0;
         var moveBlockDistance:Number = NaN;
         var modDeltaPos:int = 0;
         var columnsToClear:int = 0;
         var columnDelta:int = 0;
         var partialColumnOffset:int = 0;
         var j:int = 0;
         var r:IListItemRenderer = null;
         var columnsNeeded:int = 0;
         var currentColumns:int = 0;
         var actual:Point = null;
         var extraEmptyColumns:int = 0;
         var temp:IListItemRenderer = null;
         var newColumnCount:int = 0;
         var adjustedColumnCount:int = 0;
         if(deltaPos == 0)
         {
            return;
         }
         this.removeClipMask();
         var oldOffscreenExtraColumnsRight:int = offscreenExtraColumnsRight;
         var oldOffscreenExtraColumnsLeft:int = offscreenExtraColumnsLeft;
         var desiredOffscreenExtraColumnsLeft:int = offscreenExtraColumns / 2;
         var desiredOffscreenExtraColumnsRight:int = offscreenExtraColumns / 2;
         if(scrollUp)
         {
            offscreenExtraColumnsLeft = Math.min(desiredOffscreenExtraColumnsLeft,offscreenExtraColumnsLeft + deltaPos);
            modDeltaPos = deltaPos - (offscreenExtraColumnsLeft - oldOffscreenExtraColumnsLeft);
            columnsToClear = modDeltaPos;
         }
         else
         {
            partialColumnOffset = Boolean(offscreenExtraColumnsRight == 0 && listItems[0]) && Boolean(listItems[0].length > 0) && Boolean(listItems[0][listItems[0].length - 1]) && listItems[0][listItems[0].length - 1].x + columnWidth < listContent.widthExcludingOffsets - listContent.leftOffset ? 1 : 0;
            offscreenExtraColumnsLeft = Math.min(desiredOffscreenExtraColumnsLeft,pos);
            offscreenExtraColumnsRight = Math.min(offscreenExtraColumnsRight + deltaPos - partialColumnOffset,desiredOffscreenExtraColumnsRight);
            modDeltaPos = deltaPos - (oldOffscreenExtraColumnsLeft - offscreenExtraColumnsLeft);
            columnDelta = offscreenExtraColumnsLeft - oldOffscreenExtraColumnsLeft + partialColumnOffset + (offscreenExtraColumnsRight - oldOffscreenExtraColumnsRight);
            columnsToClear = deltaPos - (offscreenExtraColumnsRight - oldOffscreenExtraColumnsRight) - partialColumnOffset;
         }
         var columnCount:int = int(listItems[0].length);
         for(var i:int = 0; i < columnsToClear; i++)
         {
            for(j = 0; j < rowCount; j++)
            {
               r = scrollUp ? listItems[j][i] : listItems[j][columnCount - i - 1];
               if(Boolean(r))
               {
                  delete visibleData[rowMap[r.name].uid];
                  removeIndicators(rowMap[r.name].uid);
                  addToFreeItemRenderers(r);
                  delete rowMap[r.name];
                  if(scrollUp)
                  {
                     listItems[j][i] = null;
                  }
                  else
                  {
                     listItems[j][columnCount - i - 1] = null;
                  }
               }
            }
         }
         if(scrollUp)
         {
            moveBlockDistance = modDeltaPos * columnWidth;
            curX = 0;
            for(i = modDeltaPos; i < columnCount; i++)
            {
               for(j = 0; j < rowCount; j++)
               {
                  temp = listItems[j][i];
                  if(Boolean(temp))
                  {
                     r = temp;
                     r.x -= moveBlockDistance;
                     uid = rowMap[r.name].uid;
                     listItems[j][i - modDeltaPos] = r;
                     rowMap[r.name].columnIndex -= modDeltaPos;
                     moveIndicatorsHorizontally(uid,-moveBlockDistance);
                  }
                  else
                  {
                     listItems[j][i - modDeltaPos] = null;
                  }
               }
               curX += columnWidth;
            }
            for(i = 0; i < modDeltaPos; i++)
            {
               for(j = 0; j < rowCount; j++)
               {
                  listItems[j][columnCount - i - 1] = null;
               }
            }
            index = this.indicesToIndex(verticalScrollPosition,horizontalScrollPosition + columnCount - offscreenExtraColumnsLeft - modDeltaPos);
            seekPositionSafely(index);
            columnsNeeded = deltaPos + (desiredOffscreenExtraColumnsRight - oldOffscreenExtraColumnsRight);
            currentColumns = Boolean(listItems.length) ? int(listItems[0].length - modDeltaPos) : 0;
            allowRendererStealingDuringLayout = false;
            actual = this.makeRowsAndColumns(curX,0,listContent.width,listContent.height,columnCount - modDeltaPos,0,true,columnsNeeded);
            allowRendererStealingDuringLayout = true;
            extraEmptyColumns = listItems[0].length - (currentColumns + actual.x);
            if(Boolean(extraEmptyColumns))
            {
               for(i = 0; i < listItems.length; i++)
               {
                  for(j = 0; j < extraEmptyColumns; j++)
                  {
                     listItems[i].pop();
                  }
               }
            }
            index = this.indicesToIndex(verticalScrollPosition,horizontalScrollPosition - offscreenExtraColumnsLeft);
            seekPositionSafely(index);
            offscreenExtraColumnsRight = Math.max(0,desiredOffscreenExtraColumnsRight - (actual.x < deltaPos ? columnsNeeded - actual.x : 0));
         }
         else
         {
            if(columnDelta < 0)
            {
               adjustedColumnCount = listItems[0].length + columnDelta;
               for(j = 0; j < rowCount; j++)
               {
                  while(listItems[j].length > adjustedColumnCount)
                  {
                     listItems[j].pop();
                  }
               }
            }
            moveBlockDistance = modDeltaPos * columnWidth;
            if(Boolean(modDeltaPos))
            {
               curX = moveBlockDistance;
            }
            newColumnCount = columnCount + columnDelta;
            for(i = newColumnCount - modDeltaPos - 1; i >= 0; i--)
            {
               for(j = 0; j < rowCount; j++)
               {
                  r = listItems[j][i];
                  if(Boolean(r))
                  {
                     r.x += moveBlockDistance;
                     uid = rowMap[r.name].uid;
                     listItems[j][i + modDeltaPos] = r;
                     rowMap[r.name].columnIndex += modDeltaPos;
                     moveIndicatorsHorizontally(uid,moveBlockDistance);
                  }
                  else
                  {
                     listItems[j][i + modDeltaPos] = null;
                  }
               }
            }
            for(i = 0; i < modDeltaPos; i++)
            {
               for(j = 0; j < rowCount; j++)
               {
                  listItems[j][i] = null;
               }
            }
            index = this.indicesToIndex(verticalScrollPosition,horizontalScrollPosition - offscreenExtraColumnsLeft);
            seekPositionSafely(index);
            allowRendererStealingDuringLayout = false;
            this.makeRowsAndColumns(0,0,curX,listContent.height,0,0,true,modDeltaPos);
            allowRendererStealingDuringLayout = true;
            seekPositionSafely(index);
         }
         var oldListContentWidth:Number = listContent.widthExcludingOffsets;
         listContent.leftOffset = -columnWidth * offscreenExtraColumnsLeft;
         listContent.rightOffset = Boolean(offscreenExtraColumnsRight) ? listItems[0][listItems[0].length - 1].x + listItems[0][listItems[0].length - 1].width + listContent.leftOffset - oldListContentWidth : 0;
         this.adjustListContent();
         this.addClipMask(false);
      }
      
      override protected function moveSelectionVertically(code:uint, shiftKey:Boolean, ctrlKey:Boolean) : void
      {
         var newVerticalScrollPosition:Number = NaN;
         var newHorizontalScrollPosition:Number = NaN;
         var listItem:IListItemRenderer = null;
         var uid:String = null;
         var len:int = 0;
         var selected:Boolean = false;
         var rowIndex:int = 0;
         var colIndex:int = 0;
         var scrollEvent:ScrollEvent = null;
         var bSelChanged:Boolean = false;
         var rowCount:int = listItems.length - offscreenExtraRowsTop - offscreenExtraRowsBottom;
         var numRows:int = this.maxRows > 0 && this.direction != TileBaseDirection.HORIZONTAL ? this.maxRows : rowCount;
         var partialRow:int = this.displayingPartialRow() ? 1 : 0;
         var partialColumn:int = this.displayingPartialColumn() ? 1 : 0;
         if(!collection)
         {
            return;
         }
         showCaret = true;
         switch(code)
         {
            case Keyboard.UP:
               if(caretIndex > 0)
               {
                  if(this.direction == TileBaseDirection.VERTICAL)
                  {
                     --caretIndex;
                  }
                  else
                  {
                     rowIndex = this.indexToRow(caretIndex);
                     colIndex = this.indexToColumn(caretIndex);
                     if(rowIndex == 0)
                     {
                        colIndex--;
                        rowIndex = this.lastRowInColumn(colIndex);
                     }
                     else
                     {
                        rowIndex--;
                     }
                     caretIndex = Math.min(this.indicesToIndex(rowIndex,colIndex),collection.length - 1);
                  }
                  rowIndex = this.indexToRow(caretIndex);
                  colIndex = this.indexToColumn(caretIndex);
                  if(rowIndex < verticalScrollPosition)
                  {
                     newVerticalScrollPosition = verticalScrollPosition - 1;
                  }
                  if(rowIndex > verticalScrollPosition + rowCount - partialRow)
                  {
                     newVerticalScrollPosition = maxVerticalScrollPosition;
                  }
                  if(colIndex < horizontalScrollPosition)
                  {
                     newHorizontalScrollPosition = horizontalScrollPosition - 1;
                  }
               }
               break;
            case Keyboard.DOWN:
               if(caretIndex < collection.length - 1)
               {
                  if(this.direction == TileBaseDirection.VERTICAL || caretIndex == -1)
                  {
                     ++caretIndex;
                  }
                  else
                  {
                     rowIndex = this.indexToRow(caretIndex);
                     colIndex = this.indexToColumn(caretIndex);
                     if(rowIndex == this.lastRowInColumn(colIndex))
                     {
                        rowIndex = 0;
                        colIndex++;
                     }
                     else
                     {
                        rowIndex++;
                     }
                     caretIndex = Math.min(this.indicesToIndex(rowIndex,colIndex),collection.length - 1);
                  }
                  rowIndex = this.indexToRow(caretIndex);
                  colIndex = this.indexToColumn(caretIndex);
                  if(rowIndex >= verticalScrollPosition + rowCount - partialRow && verticalScrollPosition < maxVerticalScrollPosition)
                  {
                     newVerticalScrollPosition = verticalScrollPosition + 1;
                  }
                  if(rowIndex < verticalScrollPosition)
                  {
                     newVerticalScrollPosition = rowIndex;
                  }
                  if(colIndex > horizontalScrollPosition + columnCount - 1)
                  {
                     newHorizontalScrollPosition = horizontalScrollPosition + 1;
                  }
               }
               break;
            case Keyboard.PAGE_UP:
               if(caretIndex < 0)
               {
                  caretIndex = this.scrollPositionToIndex(horizontalScrollPosition,verticalScrollPosition);
               }
               rowIndex = this.indexToRow(caretIndex);
               colIndex = this.indexToColumn(caretIndex);
               if(verticalScrollPosition > 0)
               {
                  if(rowIndex == verticalScrollPosition)
                  {
                     newVerticalScrollPosition = rowIndex = Math.max(verticalScrollPosition - (rowCount - partialRow),0);
                  }
                  else
                  {
                     rowIndex = verticalScrollPosition;
                  }
                  caretIndex = this.indicesToIndex(rowIndex,colIndex);
                  break;
               }
            case Keyboard.HOME:
               if(Boolean(collection.length))
               {
                  caretIndex = 0;
                  newVerticalScrollPosition = 0;
                  newHorizontalScrollPosition = 0;
               }
               break;
            case Keyboard.PAGE_DOWN:
               if(caretIndex < 0)
               {
                  caretIndex = this.scrollPositionToIndex(horizontalScrollPosition,verticalScrollPosition);
               }
               rowIndex = this.indexToRow(caretIndex);
               colIndex = this.indexToColumn(caretIndex);
               if(rowIndex < maxVerticalScrollPosition)
               {
                  if(rowIndex == verticalScrollPosition + (rowCount - partialRow))
                  {
                     newVerticalScrollPosition = Math.min(verticalScrollPosition + rowCount - partialRow,maxVerticalScrollPosition);
                     rowIndex = verticalScrollPosition + rowCount;
                  }
                  else
                  {
                     rowIndex = Math.min(verticalScrollPosition + rowCount - partialRow,this.indexToRow(collection.length - 1));
                     if(rowIndex == verticalScrollPosition + rowCount - partialRow)
                     {
                        newVerticalScrollPosition = Math.min(verticalScrollPosition + rowCount - partialRow,maxVerticalScrollPosition);
                     }
                  }
                  caretIndex = Math.min(this.indicesToIndex(rowIndex,colIndex),collection.length - 1);
                  break;
               }
            case Keyboard.END:
               if(caretIndex < collection.length)
               {
                  caretIndex = collection.length - 1;
                  newVerticalScrollPosition = maxVerticalScrollPosition;
                  newHorizontalScrollPosition = maxHorizontalScrollPosition;
               }
         }
         if(!isNaN(newVerticalScrollPosition))
         {
            if(newVerticalScrollPosition != verticalScrollPosition)
            {
               scrollEvent = new ScrollEvent(ScrollEvent.SCROLL);
               scrollEvent.detail = ScrollEventDetail.THUMB_POSITION;
               scrollEvent.direction = ScrollEventDirection.VERTICAL;
               scrollEvent.delta = newVerticalScrollPosition - verticalScrollPosition;
               scrollEvent.position = newVerticalScrollPosition;
               verticalScrollPosition = newVerticalScrollPosition;
               dispatchEvent(scrollEvent);
            }
         }
         if(iteratorValid)
         {
            if(!isNaN(newHorizontalScrollPosition))
            {
               if(newHorizontalScrollPosition != horizontalScrollPosition)
               {
                  scrollEvent = new ScrollEvent(ScrollEvent.SCROLL);
                  scrollEvent.detail = ScrollEventDetail.THUMB_POSITION;
                  scrollEvent.direction = ScrollEventDirection.HORIZONTAL;
                  scrollEvent.delta = newHorizontalScrollPosition - horizontalScrollPosition;
                  scrollEvent.position = newHorizontalScrollPosition;
                  horizontalScrollPosition = newHorizontalScrollPosition;
                  dispatchEvent(scrollEvent);
               }
            }
         }
         if(!iteratorValid)
         {
            keySelectionPending = true;
            return;
         }
         this.bShiftKey = shiftKey;
         this.bCtrlKey = ctrlKey;
         this.lastKey = code;
         this.finishKeySelection();
      }
      
      override protected function moveSelectionHorizontally(code:uint, shiftKey:Boolean, ctrlKey:Boolean) : void
      {
         var newVerticalScrollPosition:Number = NaN;
         var newHorizontalScrollPosition:Number = NaN;
         var listItem:IListItemRenderer = null;
         var uid:String = null;
         var len:int = 0;
         var selected:Boolean = false;
         var rowIndex:int = 0;
         var colIndex:int = 0;
         var scrollEvent:ScrollEvent = null;
         var columnCount:int = listItems[0].length - offscreenExtraColumnsLeft - offscreenExtraColumnsRight;
         var numCols:int = this.maxColumns > 0 && this.direction != TileBaseDirection.VERTICAL ? this.maxColumns : columnCount;
         var partialRow:int = this.displayingPartialRow() ? 1 : 0;
         var partialColumn:int = this.displayingPartialColumn() ? 1 : 0;
         if(!collection)
         {
            return;
         }
         showCaret = true;
         switch(code)
         {
            case Keyboard.LEFT:
               if(caretIndex > 0)
               {
                  if(this.direction == TileBaseDirection.HORIZONTAL)
                  {
                     --caretIndex;
                  }
                  else
                  {
                     rowIndex = this.indexToRow(caretIndex);
                     colIndex = this.indexToColumn(caretIndex);
                     if(colIndex == 0)
                     {
                        rowIndex--;
                        colIndex = this.lastColumnInRow(rowIndex);
                     }
                     else
                     {
                        colIndex--;
                     }
                     caretIndex = Math.min(this.indicesToIndex(rowIndex,colIndex),collection.length - 1);
                  }
                  rowIndex = this.indexToRow(caretIndex);
                  colIndex = this.indexToColumn(caretIndex);
                  if(this.direction == TileBaseDirection.HORIZONTAL)
                  {
                     if(rowIndex < verticalScrollPosition)
                     {
                        newVerticalScrollPosition = verticalScrollPosition - 1;
                     }
                     else if(rowIndex > verticalScrollPosition + rowCount - partialRow)
                     {
                        newVerticalScrollPosition = maxVerticalScrollPosition;
                     }
                  }
                  else if(colIndex < horizontalScrollPosition)
                  {
                     newHorizontalScrollPosition = horizontalScrollPosition - 1;
                  }
                  else if(colIndex > horizontalScrollPosition + columnCount - 1 - partialColumn)
                  {
                     newHorizontalScrollPosition = maxHorizontalScrollPosition;
                  }
               }
               break;
            case Keyboard.RIGHT:
               if(caretIndex < collection.length - 1)
               {
                  if(this.direction == TileBaseDirection.HORIZONTAL || caretIndex == -1)
                  {
                     ++caretIndex;
                  }
                  else
                  {
                     rowIndex = this.indexToRow(caretIndex);
                     colIndex = this.indexToColumn(caretIndex);
                     if(colIndex == this.lastColumnInRow(rowIndex))
                     {
                        colIndex = 0;
                        rowIndex++;
                     }
                     else
                     {
                        colIndex++;
                     }
                     caretIndex = Math.min(this.indicesToIndex(rowIndex,colIndex),collection.length - 1);
                  }
                  rowIndex = this.indexToRow(caretIndex);
                  colIndex = this.indexToColumn(caretIndex);
                  if(this.direction == TileBaseDirection.HORIZONTAL)
                  {
                     if(rowIndex >= verticalScrollPosition + rowCount - partialRow && verticalScrollPosition < maxVerticalScrollPosition)
                     {
                        newVerticalScrollPosition = verticalScrollPosition + 1;
                     }
                     if(rowIndex < verticalScrollPosition)
                     {
                        newVerticalScrollPosition = rowIndex;
                     }
                  }
                  else
                  {
                     if(colIndex >= horizontalScrollPosition + columnCount - partialColumn && horizontalScrollPosition < maxHorizontalScrollPosition)
                     {
                        newHorizontalScrollPosition = horizontalScrollPosition + 1;
                     }
                     if(colIndex < horizontalScrollPosition)
                     {
                        newHorizontalScrollPosition = colIndex;
                     }
                  }
               }
               break;
            case Keyboard.PAGE_UP:
               if(caretIndex < 0)
               {
                  caretIndex = this.scrollPositionToIndex(horizontalScrollPosition,verticalScrollPosition);
               }
               rowIndex = this.indexToRow(caretIndex);
               colIndex = this.indexToColumn(caretIndex);
               if(colIndex > 0)
               {
                  caretIndex = this.indicesToIndex(rowIndex,newHorizontalScrollPosition = int(Math.max(horizontalScrollPosition - (columnCount - partialColumn),0)));
               }
               break;
            case Keyboard.PAGE_DOWN:
               if(caretIndex < 0)
               {
                  caretIndex = this.scrollPositionToIndex(horizontalScrollPosition,verticalScrollPosition);
               }
               rowIndex = this.indexToRow(caretIndex);
               colIndex = this.indexToColumn(caretIndex);
               if(colIndex < maxHorizontalScrollPosition)
               {
                  colIndex = Math.min(horizontalScrollPosition + columnCount - partialColumn,this.indexToColumn(collection.length - 1));
                  if(colIndex > horizontalScrollPosition)
                  {
                     newHorizontalScrollPosition = Math.min(colIndex,maxHorizontalScrollPosition);
                  }
                  caretIndex = this.indicesToIndex(rowIndex,colIndex);
               }
               break;
            case Keyboard.HOME:
               if(Boolean(collection.length))
               {
                  caretIndex = 0;
                  newHorizontalScrollPosition = 0;
                  newVerticalScrollPosition = 0;
               }
               break;
            case Keyboard.END:
               if(caretIndex < collection.length)
               {
                  caretIndex = collection.length - 1;
                  newHorizontalScrollPosition = maxHorizontalScrollPosition;
                  newVerticalScrollPosition = maxVerticalScrollPosition;
               }
         }
         if(!isNaN(newVerticalScrollPosition))
         {
            if(newVerticalScrollPosition != verticalScrollPosition)
            {
               scrollEvent = new ScrollEvent(ScrollEvent.SCROLL);
               scrollEvent.detail = ScrollEventDetail.THUMB_POSITION;
               scrollEvent.direction = ScrollEventDirection.VERTICAL;
               scrollEvent.delta = newVerticalScrollPosition - verticalScrollPosition;
               scrollEvent.position = newVerticalScrollPosition;
               verticalScrollPosition = newVerticalScrollPosition;
               dispatchEvent(scrollEvent);
            }
         }
         if(iteratorValid)
         {
            if(!isNaN(newHorizontalScrollPosition))
            {
               if(newHorizontalScrollPosition != horizontalScrollPosition)
               {
                  scrollEvent = new ScrollEvent(ScrollEvent.SCROLL);
                  scrollEvent.detail = ScrollEventDetail.THUMB_POSITION;
                  scrollEvent.direction = ScrollEventDirection.HORIZONTAL;
                  scrollEvent.delta = newHorizontalScrollPosition - horizontalScrollPosition;
                  scrollEvent.position = newHorizontalScrollPosition;
                  horizontalScrollPosition = newHorizontalScrollPosition;
                  dispatchEvent(scrollEvent);
               }
            }
         }
         if(!iteratorValid)
         {
            keySelectionPending = true;
            return;
         }
         this.bShiftKey = shiftKey;
         this.bCtrlKey = ctrlKey;
         this.lastKey = code;
         this.finishKeySelection();
      }
      
      private function displayingPartialRow() : Boolean
      {
         var r:IListItemRenderer = null;
         var row:Array = listItems[listItems.length - 1 - offscreenExtraRowsBottom];
         if(Boolean(row) && row.length > 0)
         {
            r = row[0];
            if(!r || r.y + r.height > listContent.heightExcludingOffsets - listContent.topOffset)
            {
               return true;
            }
         }
         return false;
      }
      
      private function displayingPartialColumn() : Boolean
      {
         var r:IListItemRenderer = null;
         if(Boolean(listItems[0]) && listItems[0].length > 0)
         {
            r = listItems[0][listItems[0].length - 1 - offscreenExtraColumnsRight];
            if(Boolean(r) && r.x + r.width > listContent.widthExcludingOffsets - listContent.leftOffset)
            {
               return true;
            }
         }
         return false;
      }
      
      override protected function finishKeySelection() : void
      {
         var uid:String = null;
         var rowIndex:int = 0;
         var colIndex:int = 0;
         var listItem:IListItemRenderer = null;
         var evt:ListEvent = null;
         var bSelChanged:Boolean = false;
         if(caretIndex < 0)
         {
            return;
         }
         rowIndex = this.indexToRow(caretIndex);
         colIndex = this.indexToColumn(caretIndex);
         listItem = listItems[rowIndex - verticalScrollPosition + offscreenExtraRowsTop][colIndex - horizontalScrollPosition + offscreenExtraColumnsLeft];
         if(!this.bCtrlKey)
         {
            selectItem(listItem,this.bShiftKey,this.bCtrlKey);
            bSelChanged = true;
         }
         if(this.bCtrlKey)
         {
            uid = itemToUID(listItem.data);
            drawItem(visibleData[uid],selectedData[uid] != null,false,true);
         }
         if(bSelChanged)
         {
            evt = new ListEvent(ListEvent.CHANGE);
            evt.itemRenderer = listItem;
            evt.rowIndex = rowIndex;
            evt.columnIndex = colIndex;
            dispatchEvent(evt);
         }
      }
      
      override public function itemRendererToIndex(item:IListItemRenderer) : int
      {
         var uid:String = null;
         var m:int = 0;
         var j:int = 0;
         if(runningDataEffect)
         {
            uid = itemToUID(dataItemWrappersByRenderer[item]);
         }
         else
         {
            uid = itemToUID(item.data);
         }
         var n:int = int(listItems.length);
         loop0:
         for(var i:int = 0; i < listItems.length; )
         {
            m = int(listItems[i].length);
            j = 0;
            while(true)
            {
               if(j >= m)
               {
                  i++;
                  continue loop0;
               }
               if(Boolean(listItems[i][j]) && rowMap[listItems[i][j].name].uid == uid)
               {
                  break;
               }
               j++;
            }
            if(this.direction == TileBaseDirection.VERTICAL)
            {
               return (j + horizontalScrollPosition - offscreenExtraColumnsLeft) * Math.max(this.maxRows,rowCount) + i;
            }
            return (i + verticalScrollPosition - offscreenExtraRowsTop) * Math.max(this.maxColumns,columnCount) + j;
         }
         return -1;
      }
      
      override public function indexToItemRenderer(index:int) : IListItemRenderer
      {
         var rowIndex:int = this.indexToRow(index);
         if(rowIndex < verticalScrollPosition || rowIndex >= verticalScrollPosition + rowCount)
         {
            return null;
         }
         var colIndex:int = this.indexToColumn(index);
         if(colIndex < horizontalScrollPosition || colIndex >= horizontalScrollPosition + columnCount)
         {
            return null;
         }
         return listItems[rowIndex - verticalScrollPosition][colIndex - horizontalScrollPosition];
      }
      
      override public function calculateDropIndex(event:DragEvent = null) : int
      {
         var item:IListItemRenderer = null;
         var pt:Point = null;
         var rc:int = 0;
         var i:int = 0;
         var cc:int = 0;
         var j:int = 0;
         if(Boolean(event))
         {
            pt = new Point(event.localX,event.localY);
            pt = DisplayObject(event.target).localToGlobal(pt);
            pt = listContent.globalToLocal(pt);
            rc = int(listItems.length);
            for(i = 0; i < rc; i++)
            {
               if(rowInfo[i].y <= pt.y && pt.y < rowInfo[i].y + rowInfo[i].height)
               {
                  cc = int(listItems[i].length);
                  for(j = 0; j < cc; j++)
                  {
                     if(Boolean(listItems[i][j]) && Boolean(listItems[i][j].x <= pt.x) && pt.x < listItems[i][j].x + listItems[i][j].width)
                     {
                        item = listItems[i][j];
                        if(!DisplayObject(item).visible)
                        {
                           item = null;
                        }
                        break;
                     }
                  }
                  break;
               }
            }
            if(Boolean(item))
            {
               lastDropIndex = this.itemRendererToIndex(item);
            }
            else
            {
               lastDropIndex = Boolean(collection) ? int(collection.length) : 0;
            }
         }
         return lastDropIndex;
      }
      
      override public function showDropFeedback(event:DragEvent) : void
      {
         var dropIndicatorClass:Class = null;
         var vm:EdgeMetrics = null;
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
            if(this.direction == TileBaseDirection.HORIZONTAL)
            {
               dropIndicator.setActualSize(rowHeight - 4,4);
               DisplayObject(dropIndicator).rotation = 90;
            }
            else
            {
               dropIndicator.setActualSize(columnWidth - 4,4);
            }
            dropIndicator.visible = true;
            listContent.addChild(DisplayObject(dropIndicator));
            if(Boolean(collection))
            {
               dragScrollingInterval = setInterval(dragScroll,15);
            }
         }
         var dropIndex:int = this.calculateDropIndex(event);
         var rowNum:int = this.indexToRow(dropIndex);
         var colNum:int = this.indexToColumn(dropIndex);
         rowNum -= verticalScrollPosition - offscreenExtraRowsTop;
         colNum -= horizontalScrollPosition - offscreenExtraColumnsLeft;
         var rc:Number = listItems.length;
         if(rowNum >= rc)
         {
            rowNum = rc - 1;
         }
         var cc:Number = Boolean(rc) ? Number(listItems[0].length) : 0;
         if(colNum > cc)
         {
            colNum = cc;
         }
         dropIndicator.x = Boolean(cc) && Boolean(listItems[rowNum].length) && Boolean(listItems[rowNum][colNum]) ? Number(listItems[rowNum][colNum].x) : colNum * columnWidth;
         dropIndicator.y = Boolean(rc) && Boolean(listItems[rowNum].length) && Boolean(listItems[rowNum][0]) ? Number(listItems[rowNum][0].y) : rowNum * rowHeight;
      }
      
      override public function measureWidthOfItems(index:int = -1, count:int = 0) : Number
      {
         var item:IListItemRenderer = null;
         var w:Number = NaN;
         var rowData:ListData = null;
         var wrappedData:Object = null;
         var data:Object = null;
         var factory:IFactory = null;
         var needSize:Boolean = false;
         if(Boolean(collection) && Boolean(collection.length))
         {
            wrappedData = iterator.current;
            data = wrappedData is ItemWrapper ? wrappedData.data : wrappedData;
            if(!this.measuringObjects)
            {
               this.measuringObjects = new Dictionary(true);
            }
            factory = getItemRendererFactory(data);
            item = this.measuringObjects[factory];
            if(!item)
            {
               item = this.getMeasuringRenderer(data);
               needSize = true;
            }
            rowData = ListData(this.makeListData(data,uid,0,0));
            if(item is IDropInListItemRenderer)
            {
               IDropInListItemRenderer(item).listData = Boolean(data) ? rowData : null;
            }
            item.data = data;
            UIComponentGlobals.layoutManager.validateClient(item,true);
            w = Number(item.getExplicitOrMeasuredWidth());
            if(needSize)
            {
               item.setActualSize(w,item.getExplicitOrMeasuredHeight());
               needSize = false;
            }
         }
         if(isNaN(w) || w == 0)
         {
            w = 50;
         }
         return w * count;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getMeasuringRenderer(data:Object) : IListItemRenderer
      {
         var item:IListItemRenderer = null;
         if(!this.measuringObjects)
         {
            this.measuringObjects = new Dictionary(true);
         }
         var factory:IFactory = getItemRendererFactory(data);
         item = this.measuringObjects[factory];
         if(!item)
         {
            item = this.createItemRenderer(data);
            item.owner = this;
            item.name = "hiddenItem";
            item.visible = false;
            item.styleName = listContent;
            listContent.addChild(DisplayObject(item));
            this.measuringObjects[factory] = item;
         }
         return item;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function purgeMeasuringRenderers() : void
      {
         var item:IListItemRenderer = null;
         for each(item in this.measuringObjects)
         {
            if(Boolean(item.parent))
            {
               item.parent.removeChild(DisplayObject(item));
            }
         }
         if(!this.measuringObjects)
         {
            this.measuringObjects = new Dictionary(true);
         }
      }
      
      override public function set itemRenderer(value:IFactory) : void
      {
         super.itemRenderer = value;
         this.purgeMeasuringRenderers();
      }
      
      override public function createItemRenderer(data:Object) : IListItemRenderer
      {
         var factory:IFactory = null;
         var renderer:IListItemRenderer = null;
         var d:Dictionary = null;
         var p:* = undefined;
         factory = getItemRendererFactory(data);
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
         if(factory == itemRenderer)
         {
            if(Boolean(freeItemRenderers) && Boolean(freeItemRenderers.length) && Boolean(freeItemRenderersByFactory[factory]))
            {
               renderer = freeItemRenderers.pop();
               delete freeItemRenderersByFactory[factory][renderer];
            }
         }
         else if(Boolean(freeItemRenderersByFactory))
         {
            d = freeItemRenderersByFactory[factory];
            if(Boolean(d))
            {
               var _loc6_:int = 0;
               var _loc7_:* = d;
               for(p in _loc7_)
               {
                  renderer = IListItemRenderer(p);
                  delete d[p];
               }
            }
         }
         if(!renderer)
         {
            renderer = factory.newInstance();
            renderer.styleName = this;
            factoryMap[renderer] = factory;
         }
         renderer.owner = this;
         return renderer;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setupRendererFromData(item:IListItemRenderer, data:Object) : void
      {
         var rowData:ListData = ListData(this.makeListData(data,itemToUID(data),0,0));
         if(item is IDropInListItemRenderer)
         {
            IDropInListItemRenderer(item).listData = Boolean(data) ? rowData : null;
         }
         item.data = data;
         UIComponentGlobals.layoutManager.validateClient(item,true);
      }
      
      override public function measureHeightOfItems(index:int = -1, count:int = 0) : Number
      {
         var h:Number = NaN;
         var wrappedData:Object = null;
         var data:Object = null;
         var factory:IFactory = null;
         var item:IListItemRenderer = null;
         var needSize:Boolean = false;
         if(Boolean(collection) && Boolean(collection.length))
         {
            wrappedData = iterator.current;
            data = wrappedData is ItemWrapper ? wrappedData.data : wrappedData;
            factory = getItemRendererFactory(data);
            item = this.measuringObjects[factory];
            if(item == null)
            {
               item = this.getMeasuringRenderer(data);
               needSize = true;
            }
            this.setupRendererFromData(item,data);
            h = Number(item.getExplicitOrMeasuredHeight());
            if(needSize)
            {
               item.setActualSize(item.getExplicitOrMeasuredWidth(),h);
               needSize = false;
            }
         }
         if(isNaN(h) || h == 0)
         {
            h = 50;
         }
         var paddingTop:Number = Number(getStyle("paddingTop"));
         var paddingBottom:Number = Number(getStyle("paddingBottom"));
         h += paddingTop + paddingBottom;
         return h * count;
      }
      
      override protected function scrollPositionToIndex(horizontalScrollPosition:int, verticalScrollPosition:int) : int
      {
         var startIndex:int = 0;
         if(Boolean(iterator))
         {
            if(this.direction == TileBaseDirection.HORIZONTAL)
            {
               startIndex = verticalScrollPosition * columnCount + horizontalScrollPosition;
            }
            else
            {
               startIndex = horizontalScrollPosition * rowCount + verticalScrollPosition;
            }
            return startIndex;
         }
         return -1;
      }
      
      override protected function get dragImageOffsets() : Point
      {
         var s:String = null;
         var pt:Point = new Point(8192,8192);
         var found:Boolean = false;
         var rC:int = int(listItems.length);
         for(s in visibleData)
         {
            if(Boolean(selectedData[s]))
            {
               pt.x = Math.min(pt.x,visibleData[s].x);
               pt.y = Math.min(pt.y,visibleData[s].y);
               found = true;
            }
         }
         if(found)
         {
            return pt;
         }
         return new Point(0,0);
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function addClipMask(layoutChanged:Boolean) : void
      {
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function removeClipMask() : void
      {
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function adjustOffscreenRowsAndColumns() : void
      {
         if(this.direction == TileBaseDirection.VERTICAL)
         {
            offscreenExtraRows = 0;
            offscreenExtraColumns = offscreenExtraRowsOrColumns;
         }
         else
         {
            offscreenExtraColumns = 0;
            offscreenExtraRows = offscreenExtraRowsOrColumns;
         }
      }
      
      protected function makeListData(data:Object, uid:String, rowNum:int, columnNum:int) : BaseListData
      {
         return new ListData(itemToLabel(data),itemToIcon(data),labelField,uid,this,rowNum,columnNum);
      }
      
      private function lastRowInColumn(index:int) : int
      {
         var numCols:int = this.maxColumns > 0 ? this.maxColumns : columnCount;
         var numRows:int = Math.floor((collection.length - 1) / numCols);
         if(index * numRows > collection.length)
         {
            numRows--;
         }
         return numRows;
      }
      
      private function lastColumnInRow(index:int) : int
      {
         var numRows:int = this.maxRows > 0 ? this.maxRows : rowCount;
         var numCols:int = Math.floor((collection.length - 1) / numRows);
         if(this.indicesToIndex(index,numCols) >= collection.length)
         {
            numCols--;
         }
         return numCols;
      }
      
      override protected function indexToRow(index:int) : int
      {
         var numRows:int = 0;
         if(this.direction == TileBaseDirection.VERTICAL)
         {
            numRows = this.maxRows > 0 ? this.maxRows : rowCount;
            return index % numRows;
         }
         var numCols:int = this.maxColumns > 0 ? this.maxColumns : columnCount;
         return Math.floor(index / numCols);
      }
      
      override protected function indexToColumn(index:int) : int
      {
         var numRows:int = 0;
         if(this.direction == TileBaseDirection.VERTICAL)
         {
            numRows = this.maxRows > 0 ? this.maxRows : rowCount;
            return Math.floor(index / numRows);
         }
         var numCols:int = this.maxColumns > 0 ? this.maxColumns : columnCount;
         return index % numCols;
      }
      
      override public function indicesToIndex(rowIndex:int, columnIndex:int) : int
      {
         var numRows:int = 0;
         if(this.direction == TileBaseDirection.VERTICAL)
         {
            numRows = this.maxRows > 0 ? this.maxRows : rowCount;
            return columnIndex * numRows + rowIndex;
         }
         var numCols:int = this.maxColumns > 0 ? this.maxColumns : columnCount;
         return rowIndex * numCols + columnIndex;
      }
      
      override protected function collectionChangeHandler(event:Event) : void
      {
         var ce:CollectionEvent = null;
         var oldIndex:int = 0;
         var newOffscreenRowsTop:int = 0;
         var newOffscreenColumnsLeft:int = 0;
         var index:int = 0;
         if(event is CollectionEvent)
         {
            ce = CollectionEvent(event);
            if(ce.location == 0 || ce.kind == CollectionEventKind.REFRESH)
            {
               itemsNeedMeasurement = true;
               invalidateProperties();
            }
            if(ce.kind == CollectionEventKind.REMOVE)
            {
               oldIndex = this.indicesToIndex(verticalScrollPosition,horizontalScrollPosition);
               if(ce.location < oldIndex)
               {
                  oldIndex -= ce.items.length;
                  super.collectionChangeHandler(event);
                  newOffscreenRowsTop = 0;
                  newOffscreenColumnsLeft = 0;
                  if(this.direction == TileBaseDirection.HORIZONTAL)
                  {
                     super.verticalScrollPosition = this.indexToRow(oldIndex);
                     newOffscreenRowsTop = Math.min(offscreenExtraRows / 2,verticalScrollPosition);
                  }
                  else
                  {
                     super.horizontalScrollPosition = this.indexToColumn(oldIndex);
                     newOffscreenColumnsLeft = Math.min(offscreenExtraColumns / 2,horizontalScrollPosition);
                  }
                  index = this.scrollPositionToIndex(horizontalScrollPosition - newOffscreenColumnsLeft,verticalScrollPosition - newOffscreenRowsTop);
                  seekPositionSafely(index);
                  return;
               }
            }
         }
         super.collectionChangeHandler(event);
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function reconstructDataFromListItems() : Array
      {
         var j:int = 0;
         var i:int = 0;
         var renderer:IListItemRenderer = null;
         var data:Object = null;
         if(this.direction == TileBaseDirection.HORIZONTAL || !listItems)
         {
            return super.reconstructDataFromListItems();
         }
         var items:Array = [];
         if(listItems.length > 0)
         {
            for(j = 0; j < listItems[0].length; j++)
            {
               for(i = 0; i < listItems.length; i++)
               {
                  if(Boolean(listItems[i]) && listItems[i].length > j)
                  {
                     renderer = listItems[i][j] as IListItemRenderer;
                     if(Boolean(renderer))
                     {
                        data = renderer.data;
                        items.push(data);
                     }
                  }
               }
            }
         }
         return items;
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(itemsNeedMeasurement)
         {
            itemsNeedMeasurement = false;
            if(isNaN(explicitRowHeight))
            {
               setRowHeight(this.measureHeightOfItems(0,1));
            }
            if(isNaN(explicitColumnWidth))
            {
               setColumnWidth(this.measureWidthOfItems(0,1));
            }
         }
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         if(explicitColumnCount > 0 && isNaN(explicitColumnWidth))
         {
            setColumnWidth(Math.floor((width - viewMetrics.left - viewMetrics.right) / explicitColumnCount));
         }
         if(explicitRowCount > 0 && isNaN(explicitRowHeight))
         {
            setRowHeight(Math.floor((height - viewMetrics.top - viewMetrics.bottom) / explicitRowCount));
         }
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         this.drawTileBackgrounds();
      }
      
      protected function drawTileBackgrounds() : void
      {
         var colors:Array = null;
         var n:int = 0;
         var j:int = 0;
         var height:Number = NaN;
         var width:Number = NaN;
         var item:IListItemRenderer = null;
         var actualIndex:int = 0;
         var bg:DisplayObject = null;
         var tileBGs:Sprite = Sprite(listContent.getChildByName("tileBGs"));
         if(!tileBGs)
         {
            tileBGs = new FlexSprite();
            tileBGs.mouseEnabled = false;
            tileBGs.name = "tileBGs";
            listContent.addChildAt(tileBGs,0);
         }
         var colorsStyle:Object = getStyle("alternatingItemColors");
         if(Boolean(colorsStyle))
         {
            colors = colorsStyle is Array ? colorsStyle as Array : [colorsStyle];
         }
         if(!colors || colors.length == 0)
         {
            while(tileBGs.numChildren > n)
            {
               tileBGs.removeChildAt(tileBGs.numChildren - 1);
            }
            return;
         }
         styleManager.getColorNames(colors);
         var curItem:int = 0;
         for(var i:int = 0; i < rowCount; i++)
         {
            for(j = 0; j < columnCount; j++)
            {
               height = i < rowCount - 1 ? rowHeight : Math.min(rowHeight,listContent.height - (rowCount - 1) * rowHeight);
               width = j < columnCount - 1 ? columnWidth : Math.min(columnWidth,listContent.width - (columnCount - 1) * columnWidth);
               item = Boolean(listItems[i]) ? listItems[i][j] : null;
               actualIndex = (verticalScrollPosition + i) * columnCount + (horizontalScrollPosition + j);
               bg = this.drawTileBackground(tileBGs,i,j,width,height,colors[actualIndex % colors.length],item);
               bg.y = i * rowHeight;
               bg.x = j * columnWidth;
            }
         }
         n = rowCount * columnCount;
         while(tileBGs.numChildren > n)
         {
            tileBGs.removeChildAt(tileBGs.numChildren - 1);
         }
      }
      
      protected function drawTileBackground(s:Sprite, rowIndex:int, columnIndex:int, width:Number, height:Number, color:uint, item:IListItemRenderer) : DisplayObject
      {
         var bg:Shape = null;
         var tileBGIndex:int = rowIndex * columnCount + columnIndex;
         if(tileBGIndex < s.numChildren)
         {
            bg = Shape(s.getChildAt(tileBGIndex));
         }
         else
         {
            bg = new FlexShape();
            bg.name = "tileBackground";
            s.addChild(bg);
         }
         var g:Graphics = bg.graphics;
         g.clear();
         g.beginFill(color,getStyle("backgroundAlpha"));
         g.drawRect(0,0,width,height);
         g.endFill();
         return bg;
      }
      
      override protected function keyDownHandler(event:KeyboardEvent) : void
      {
         var selectedListItem:IListItemRenderer = null;
         var rowIndex:int = 0;
         var colIndex:int = 0;
         if(!iteratorValid)
         {
            return;
         }
         if(!collection)
         {
            return;
         }
         var keyCode:uint = uint(mapKeycodeForLayoutDirection(event));
         switch(keyCode)
         {
            case Keyboard.UP:
            case Keyboard.DOWN:
               this.moveSelectionVertically(keyCode,event.shiftKey,event.ctrlKey);
               event.stopPropagation();
               break;
            case Keyboard.LEFT:
            case Keyboard.RIGHT:
               this.moveSelectionHorizontally(keyCode,event.shiftKey,event.ctrlKey);
               event.stopPropagation();
               break;
            case Keyboard.END:
            case Keyboard.HOME:
            case Keyboard.PAGE_UP:
            case Keyboard.PAGE_DOWN:
               if(this.direction == TileBaseDirection.VERTICAL)
               {
                  this.moveSelectionHorizontally(keyCode,event.shiftKey,event.ctrlKey);
               }
               else
               {
                  this.moveSelectionVertically(keyCode,event.shiftKey,event.ctrlKey);
               }
               event.stopPropagation();
               break;
            case Keyboard.SPACE:
               if(caretIndex < 0)
               {
                  break;
               }
               rowIndex = this.indexToRow(caretIndex);
               colIndex = this.indexToColumn(caretIndex);
               selectedListItem = listItems[rowIndex - verticalScrollPosition][colIndex - horizontalScrollPosition];
               selectItem(selectedListItem,event.shiftKey,event.ctrlKey);
               break;
            default:
               if(findKey(keyCode))
               {
                  event.stopPropagation();
               }
         }
      }
      
      override protected function scrollHandler(event:Event) : void
      {
         var scrollBar:ScrollBar = null;
         var pos:Number = NaN;
         var delta:int = 0;
         var startIndex:int = 0;
         var o:EdgeMetrics = null;
         var bookmark:CursorBookmark = null;
         if(event is ScrollEvent)
         {
            if(!liveScrolling && ScrollEvent(event).detail == ScrollEventDetail.THUMB_TRACK)
            {
               return;
            }
            scrollBar = ScrollBar(event.target);
            pos = scrollBar.scrollPosition;
            if(scrollBar == verticalScrollBar)
            {
               delta = pos - verticalScrollPosition;
               super.scrollHandler(event);
               if(Math.abs(delta) >= listItems.length || !iteratorValid)
               {
                  startIndex = this.indicesToIndex(pos,horizontalScrollPosition);
                  try
                  {
                     iterator.seek(CursorBookmark.FIRST,startIndex);
                     if(!iteratorValid)
                     {
                        iteratorValid = true;
                        lastSeekPending = null;
                     }
                  }
                  catch(e:ItemPendingError)
                  {
                     lastSeekPending = new ListBaseSeekPending(CursorBookmark.FIRST,startIndex);
                     e.addResponder(new ItemResponder(seekPendingResultHandler,seekPendingFailureHandler,lastSeekPending));
                     iteratorValid = false;
                  }
                  bookmark = iterator.bookmark;
                  clearIndicators();
                  clearVisibleData();
                  this.makeRowsAndColumns(0,0,listContent.width,listContent.height,0,0);
                  iterator.seek(bookmark,0);
                  drawRowBackgrounds();
               }
               else if(delta != 0)
               {
                  this.scrollVertically(pos,Math.abs(delta),delta > 0);
               }
            }
            else
            {
               delta = pos - horizontalScrollPosition;
               super.scrollHandler(event);
               if(Math.abs(delta) >= listItems[0].length || !iteratorValid)
               {
                  startIndex = this.indicesToIndex(verticalScrollPosition,pos);
                  try
                  {
                     iterator.seek(CursorBookmark.FIRST,startIndex);
                     if(!iteratorValid)
                     {
                        iteratorValid = true;
                        lastSeekPending = null;
                     }
                  }
                  catch(e:ItemPendingError)
                  {
                     lastSeekPending = new ListBaseSeekPending(CursorBookmark.FIRST,startIndex);
                     e.addResponder(new ItemResponder(seekPendingResultHandler,seekPendingFailureHandler,lastSeekPending));
                     iteratorValid = false;
                  }
                  bookmark = iterator.bookmark;
                  clearIndicators();
                  clearVisibleData();
                  this.makeRowsAndColumns(0,0,listContent.width,listContent.height,0,0);
                  iterator.seek(bookmark,0);
                  drawRowBackgrounds();
               }
               else if(delta != 0)
               {
                  this.scrollHorizontally(pos,Math.abs(delta),delta > 0);
               }
            }
         }
      }
      
      override public function scrollToIndex(index:int) : Boolean
      {
         var newVPos:int = 0;
         var newHPos:int = 0;
         var firstIndex:int = this.scrollPositionToIndex(horizontalScrollPosition,verticalScrollPosition);
         var numItemsVisible:int = (listItems.length - offscreenExtraRowsTop - offscreenExtraRowsBottom) * (listItems[0].length - offscreenExtraColumnsLeft - offscreenExtraColumnsRight);
         if(index >= firstIndex + numItemsVisible || index < firstIndex)
         {
            newVPos = Math.min(this.indexToRow(index),maxVerticalScrollPosition);
            newHPos = Math.min(this.indexToColumn(index),maxHorizontalScrollPosition);
            try
            {
               iterator.seek(CursorBookmark.FIRST,this.scrollPositionToIndex(horizontalScrollPosition,verticalScrollPosition));
               super.horizontalScrollPosition = newHPos;
               super.verticalScrollPosition = newVPos;
            }
            catch(e:ItemPendingError)
            {
            }
            return true;
         }
         return false;
      }
      
      override protected function adjustListContent(unscaledWidth:Number = -1, unscaledHeight:Number = -1) : void
      {
         var partial:Boolean = false;
         var index:int = 0;
         var numRows:int = 0;
         var numCols:int = 0;
         var maxHSP:int = 0;
         var maxVSP:int = 0;
         super.adjustListContent(unscaledWidth,unscaledHeight);
         if(!collection)
         {
            return;
         }
         var numItems:int = int(collection.length);
         if(this.direction == TileBaseDirection.VERTICAL)
         {
            numRows = this.maxRows > 0 ? this.maxRows : int(Math.max(Math.floor(listContent.heightExcludingOffsets / rowHeight),1));
            numCols = Math.max(Math.ceil(listContent.widthExcludingOffsets / columnWidth),1);
            if(numRows != this.lastRowCount)
            {
               partial = listContent.widthExcludingOffsets / columnWidth != Math.ceil(listContent.widthExcludingOffsets / columnWidth);
               maxHSP = Math.max(Math.ceil(numItems / numRows) - numCols,0);
               if(partial)
               {
                  maxHSP++;
               }
               if(horizontalScrollPosition > maxHSP)
               {
                  $horizontalScrollPosition = maxHSP;
               }
               setRowCount(numRows);
               setColumnCount(numCols);
               index = this.scrollPositionToIndex(Math.max(0,horizontalScrollPosition - offscreenExtraColumnsLeft),verticalScrollPosition);
               seekPositionSafely(index);
            }
            this.lastRowCount = numRows;
         }
         else
         {
            numCols = this.maxColumns > 0 ? this.maxColumns : int(Math.max(Math.floor(listContent.widthExcludingOffsets / columnWidth),1));
            numRows = Math.max(Math.ceil(listContent.heightExcludingOffsets / rowHeight),1);
            if(numCols != this.lastColumnCount)
            {
               partial = listContent.heightExcludingOffsets / rowHeight != Math.ceil(listContent.heightExcludingOffsets / rowHeight);
               maxVSP = Math.max(Math.ceil(numItems / numCols) - numRows,0);
               if(partial)
               {
                  maxVSP++;
               }
               if(verticalScrollPosition > maxVSP)
               {
                  $verticalScrollPosition = maxVSP;
               }
               setRowCount(numRows);
               setColumnCount(numCols);
               index = this.scrollPositionToIndex(horizontalScrollPosition,Math.max(0,verticalScrollPosition - offscreenExtraRowsTop));
               seekPositionSafely(index);
            }
            this.lastColumnCount = numCols;
         }
      }
   }
}

