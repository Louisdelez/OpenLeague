package spark.components.gridClasses
{
   import flash.geom.Rectangle;
   import mx.collections.IList;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.events.PropertyChangeEvent;
   
   [ExcludeClass]
   public class GridDimensions
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var rowList:GridRowList = new GridRowList();
      
      private var _columnWidths:Vector.<Number> = new Vector.<Number>();
      
      private var startY:Number = 0;
      
      private var recentNode:GridRowNode = null;
      
      private var startY2:Number = 0;
      
      private var recentNode2:GridRowNode = null;
      
      private const typicalCellWidths:Vector.<Number> = new Vector.<Number>();
      
      private const typicalCellHeights:Vector.<Number> = new Vector.<Number>();
      
      private var maxTypicalCellHeight:Number = NaN;
      
      private var useMaxTypicalCellHeight:Boolean = true;
      
      private var _rowCount:int = 0;
      
      private var _columnCount:int = 0;
      
      private var _rowGap:Number = 0;
      
      private var _columnGap:Number = 0;
      
      private var _defaultRowHeight:Number = NaN;
      
      public var defaultColumnWidth:Number = 150;
      
      public var variableRowHeight:Boolean = false;
      
      private var _minRowHeight:Number = 0;
      
      private var _maxRowHeight:Number = 10000;
      
      public function GridDimensions()
      {
         super();
      }
      
      public static function insertElementsToVector(vec:Vector.<Number>, startIndex:int, elements:Vector.<Number>) : void
      {
         var i:int = 0;
         var oldLength:int = int(vec.length);
         var count:int = int(elements.length);
         vec.length += count;
         var vecLength:int = int(vec.length);
         for(i = oldLength - 1; i >= startIndex; i--)
         {
            vec[i + count] = vec[i];
         }
         var endIndex:int = startIndex + elements.length;
         var j:int = 0;
         for(i = startIndex; i < endIndex; i++)
         {
            vec[i] = elements[j++];
         }
      }
      
      public static function insertValueToVector(vec:Vector.<Number>, startIndex:int, count:int, value:Number) : void
      {
         var oldLength:int = int(vec.length);
         vec.length += count;
         var vecLength:int = int(vec.length);
         for(var i:int = oldLength - 1; i >= startIndex; i--)
         {
            vec[i + count] = vec[i];
         }
         clearVector(vec,value,startIndex,count);
      }
      
      public static function clearVector(vec:Vector.<Number>, value:Number, startIndex:int = 0, count:int = -1) : void
      {
         var endIndex:int = count == -1 ? int(vec.length) : int(startIndex + count);
         for(var i:int = startIndex; i < endIndex; i++)
         {
            vec[i] = value;
         }
      }
      
      private static function bound(a:Number, min:Number, max:Number) : Number
      {
         if(a < min)
         {
            a = min;
         }
         else if(a > max)
         {
            a = max;
         }
         return a;
      }
      
      public function get rowCount() : int
      {
         return this._rowCount;
      }
      
      public function set rowCount(value:int) : void
      {
         if(value == this._rowCount)
         {
            return;
         }
         if(value < this._rowCount)
         {
            this.removeRowsAt(value,value - this._rowCount);
         }
         this._rowCount = value;
      }
      
      public function get columnCount() : int
      {
         return this._columnCount;
      }
      
      public function set columnCount(value:int) : void
      {
         this.clearHeights();
         this._columnCount = value;
         this._columnWidths.length = value;
         this.typicalCellHeights.length = value;
         this.typicalCellWidths.length = value;
         this.rowList.numColumns = value;
         this.clearTypicalCellWidthsAndHeights();
         clearVector(this._columnWidths,NaN,0,this._columnCount);
      }
      
      public function get rowGap() : Number
      {
         return this._rowGap;
      }
      
      public function set rowGap(value:Number) : void
      {
         if(value == this._rowGap)
         {
            return;
         }
         this._rowGap = value;
         this.recentNode = null;
         this.recentNode2 = null;
      }
      
      public function get columnGap() : Number
      {
         return this._columnGap;
      }
      
      public function set columnGap(value:Number) : void
      {
         if(value == this._columnGap)
         {
            return;
         }
         this._columnGap = value;
         this.recentNode = null;
         this.recentNode2 = null;
      }
      
      public function get defaultRowHeight() : Number
      {
         return this.useMaxTypicalCellHeight ? this.maxTypicalCellHeight : this._defaultRowHeight;
      }
      
      public function set defaultRowHeight(value:Number) : void
      {
         if(value == this._defaultRowHeight)
         {
            return;
         }
         this._defaultRowHeight = bound(value,this._minRowHeight,this._maxRowHeight);
         this.useMaxTypicalCellHeight = isNaN(this._defaultRowHeight);
         this.recentNode = null;
         this.recentNode2 = null;
      }
      
      public function get minRowHeight() : Number
      {
         return this._minRowHeight;
      }
      
      public function set minRowHeight(value:Number) : void
      {
         if(value == this._minRowHeight)
         {
            return;
         }
         this._minRowHeight = value;
         this._defaultRowHeight = Math.max(this._defaultRowHeight,this._minRowHeight);
      }
      
      public function get maxRowHeight() : Number
      {
         return this._maxRowHeight;
      }
      
      public function set maxRowHeight(value:Number) : void
      {
         if(value == this._maxRowHeight)
         {
            return;
         }
         this._maxRowHeight = value;
         this._defaultRowHeight = Math.min(this._defaultRowHeight,this._maxRowHeight);
      }
      
      public function getRowHeight(row:int) : Number
      {
         var node:GridRowNode = null;
         var height:Number = this.defaultRowHeight;
         if(this.variableRowHeight)
         {
            node = this.rowList.find(row);
            if(Boolean(node))
            {
               if(node.fixedHeight >= 0)
               {
                  height = node.fixedHeight;
               }
               else if(node.maxCellHeight >= 0)
               {
                  height = node.maxCellHeight;
               }
            }
         }
         return !isNaN(height) ? bound(height,this.minRowHeight,this.maxRowHeight) : height;
      }
      
      public function setRowHeight(row:int, height:Number) : void
      {
         if(!this.variableRowHeight)
         {
            return;
         }
         var node:GridRowNode = this.rowList.find(row);
         if(Boolean(node))
         {
            node.fixedHeight = bound(height,this.minRowHeight,this.maxRowHeight);
         }
         else
         {
            node = this.rowList.insert(row);
            if(Boolean(node))
            {
               node.fixedHeight = bound(height,this.minRowHeight,this.maxRowHeight);
            }
         }
      }
      
      public function getColumnWidth(col:int) : Number
      {
         var w:Number = NaN;
         w = this._columnWidths[col];
         if(isNaN(w))
         {
            w = this.typicalCellWidths[col];
         }
         if(isNaN(w))
         {
            w = this.defaultColumnWidth;
         }
         return w;
      }
      
      public function setColumnWidth(col:int, width:Number) : void
      {
         this._columnWidths[col] = width;
      }
      
      public function getCellHeight(row:int, col:int) : Number
      {
         var node:GridRowNode = this.rowList.find(row);
         if(Boolean(node))
         {
            return node.getCellHeight(col);
         }
         return NaN;
      }
      
      public function setCellHeight(row:int, col:int, height:Number) : void
      {
         if(!this.variableRowHeight)
         {
            return;
         }
         var node:GridRowNode = this.rowList.find(row);
         var oldHeight:Number = this.defaultRowHeight;
         if(node == null)
         {
            node = this.rowList.insert(row);
         }
         else
         {
            oldHeight = node.maxCellHeight;
         }
         if(Boolean(node) && node.setCellHeight(col,height))
         {
            if(Boolean(this.recentNode) && node.rowIndex < this.recentNode.rowIndex)
            {
               this.startY += node.maxCellHeight - oldHeight;
            }
            if(Boolean(this.recentNode2) && node.rowIndex < this.recentNode2.rowIndex)
            {
               this.startY2 += node.maxCellHeight - oldHeight;
            }
         }
      }
      
      public function getCellBounds(row:int, col:int) : Rectangle
      {
         if(row < 0 || row >= this.rowCount || col < 0 || col >= this.columnCount)
         {
            return null;
         }
         var x:Number = this.getCellX(row,col);
         var y:Number = this.getCellY(row,col);
         var width:Number = this.getColumnWidth(col);
         var height:Number = this.getRowHeight(row);
         return new Rectangle(x,y,width,height);
      }
      
      public function getCellX(row:int, col:int) : Number
      {
         var x:Number = 0;
         for(var i:int = 0; i < col; i++)
         {
            x += this.getColumnWidth(i) + this.columnGap;
         }
         return x;
      }
      
      public function getCellY(row:int, col:int) : Number
      {
         var y:Number = NaN;
         if(!this.variableRowHeight || this.rowList.length == 0)
         {
            return row * (this.defaultRowHeight + this.rowGap);
         }
         if(row == 0)
         {
            return 0;
         }
         if(!this.recentNode2)
         {
            this.recentNode2 = this.rowList.first;
            this.startY2 = this.recentNode2.rowIndex * (this.defaultRowHeight + this.rowGap);
         }
         var recentIndex:int = this.recentNode2.rowIndex;
         if(row == recentIndex)
         {
            y = this.startY2;
         }
         else if(row < recentIndex)
         {
            y = this.getPrevYAt(row,this.recentNode2,this.startY2);
         }
         else
         {
            y = this.getNextYAt(row,this.recentNode2,this.startY2);
         }
         return y;
      }
      
      private function getPrevYAt(row:int, startNode:GridRowNode, startY:Number) : Number
      {
         var prevNode:GridRowNode = null;
         var indDiff:int = 0;
         var node:GridRowNode = startNode;
         var nodeY:Number = startY;
         var currentY:Number = startY;
         while(Boolean(node))
         {
            if(node.rowIndex == row)
            {
               break;
            }
            prevNode = node.prev;
            if(!prevNode || row < node.rowIndex && row > prevNode.rowIndex)
            {
               indDiff = node.rowIndex - row;
               currentY -= indDiff * (this.defaultRowHeight + this.rowGap);
               break;
            }
            indDiff = node.rowIndex - prevNode.rowIndex - 1;
            currentY = currentY - indDiff * (this.defaultRowHeight + this.rowGap) - (prevNode.maxCellHeight + this.rowGap);
            nodeY = currentY;
            node = prevNode;
         }
         this.recentNode2 = node;
         this.startY2 = nodeY;
         return currentY;
      }
      
      private function getNextYAt(row:int, startNode:GridRowNode, startY:Number) : Number
      {
         var nextNode:GridRowNode = null;
         var indDiff:int = 0;
         var node:GridRowNode = startNode;
         var nodeY:Number = startY;
         var currentY:Number = startY;
         while(Boolean(node))
         {
            if(node.rowIndex == row)
            {
               break;
            }
            currentY += node.maxCellHeight;
            if(node.rowIndex < this._rowCount - 1)
            {
               currentY += this.rowGap;
            }
            nextNode = node.next;
            if(!nextNode || row > node.rowIndex && row < nextNode.rowIndex)
            {
               indDiff = row - node.rowIndex - 1;
               currentY += indDiff * (this.defaultRowHeight + this.rowGap);
               break;
            }
            indDiff = nextNode.rowIndex - node.rowIndex - 1;
            currentY += indDiff * (this.defaultRowHeight + this.rowGap);
            nodeY = currentY;
            node = nextNode;
         }
         this.recentNode2 = node;
         this.startY2 = nodeY;
         return currentY;
      }
      
      public function getRowBounds(row:int) : Rectangle
      {
         var x:Number = NaN;
         if(row < 0 || row >= this._rowCount)
         {
            return null;
         }
         if(this._columnCount == 0 || this._rowCount == 0)
         {
            return new Rectangle(0,0,0,0);
         }
         x = this.getCellX(row,0);
         var y:Number = this.getCellY(row,0);
         var rowWidth:Number = this.getCellX(row,this._columnCount - 1) + this.getColumnWidth(this._columnCount - 1) - x;
         var rowHeight:Number = this.getRowHeight(row);
         return new Rectangle(x,y,rowWidth,rowHeight);
      }
      
      public function getPadRowBounds(row:int) : Rectangle
      {
         var lastRow:int = 0;
         var padRowCount:int = 0;
         if(row < 0)
         {
            return null;
         }
         if(row < this.rowCount)
         {
            return this.getRowBounds(row);
         }
         lastRow = this.rowCount - 1;
         var lastCol:int = this.columnCount - 1;
         var x:Number = lastRow >= 0 ? this.getCellX(lastRow,0) : 0;
         var lastRowBottom:Number = lastRow >= 0 ? this.getCellY(lastRow,0) + this.getRowHeight(lastRow) : 0;
         padRowCount = row - this.rowCount;
         var padRowTotalGap:Number = padRowCount > 0 ? (padRowCount - 1) * this.rowGap : 0;
         var y:Number = lastRowBottom + padRowCount * this.defaultRowHeight + padRowTotalGap;
         var rowWidth:Number = 0;
         if(lastCol >= 0 && lastRow >= 0)
         {
            rowWidth = this.getCellX(lastRow,lastCol) + this.getColumnWidth(lastCol) - x;
         }
         else if(lastCol >= 0)
         {
            rowWidth = this.getCellX(0,lastCol) + this.getColumnWidth(lastCol) - x;
         }
         else if(lastRow >= 0)
         {
            rowWidth = this.getCellX(lastRow,0) + this.getColumnWidth(0) - x;
         }
         return new Rectangle(x,y,rowWidth,this.defaultRowHeight);
      }
      
      public function getColumnBounds(col:int) : Rectangle
      {
         var y:Number = NaN;
         if(col < 0 || col >= this._columnCount)
         {
            return null;
         }
         if(this._columnCount == 0 || this._rowCount == 0)
         {
            return new Rectangle(0,0,0,0);
         }
         var x:Number = this.getCellX(0,col);
         y = this.getCellY(0,col);
         var colWidth:Number = this.getColumnWidth(col);
         var colHeight:Number = this.getCellY(this._rowCount - 1,col) + this.getRowHeight(this._rowCount - 1) - y;
         return new Rectangle(x,y,colWidth,colHeight);
      }
      
      public function getRowIndexAt(x:Number, y:Number) : int
      {
         var index:int = 0;
         if(y < 0)
         {
            return -1;
         }
         if(!this.variableRowHeight || this.rowList.length == 0)
         {
            index = y / (this.defaultRowHeight + this.rowGap);
            return index < this._rowCount ? index : -1;
         }
         if(y == 0)
         {
            return this._rowCount > 0 ? 0 : -1;
         }
         if(!this.recentNode)
         {
            this.recentNode = this.rowList.first;
            this.startY = this.recentNode.rowIndex * (this.defaultRowHeight + this.rowGap);
         }
         if(this.isYInRow(y,this.startY,this.recentNode))
         {
            index = this.recentNode.rowIndex;
         }
         else if(y < this.startY)
         {
            index = this.getPrevRowIndexAt(y,this.recentNode,this.startY);
         }
         else
         {
            index = this.getNextRowIndexAt(y,this.recentNode,this.startY);
         }
         return index < this._rowCount ? index : -1;
      }
      
      private function isYInRow(y:Number, startY:Number, node:GridRowNode) : Boolean
      {
         var end:Number = startY + node.maxCellHeight;
         if(node.rowIndex != this.rowCount - 1)
         {
            end += this.rowGap;
         }
         if(y >= startY && y < end)
         {
            return true;
         }
         return false;
      }
      
      private function getPrevRowIndexAt(y:Number, startNode:GridRowNode, startY:Number) : int
      {
         var prevY:Number = NaN;
         var indDiff:int = 0;
         var node:GridRowNode = startNode;
         var prevNode:GridRowNode = null;
         var index:int = node.rowIndex;
         var currentY:Number = startY;
         var targetY:Number = y;
         while(Boolean(node))
         {
            if(this.isYInRow(targetY,currentY,node))
            {
               break;
            }
            prevNode = node.prev;
            if(!prevNode)
            {
               prevY = 0;
            }
            else
            {
               prevY = currentY;
               indDiff = node.rowIndex - prevNode.rowIndex;
               if(indDiff > 1)
               {
                  prevY -= (indDiff - 1) * (this.defaultRowHeight + this.rowGap);
               }
            }
            if(targetY < currentY && targetY >= prevY)
            {
               index -= Math.ceil(Number(currentY - targetY) / (this.defaultRowHeight + this.rowGap));
               break;
            }
            currentY = prevY - prevNode.maxCellHeight - this.rowGap;
            node = node.prev;
            index = node.rowIndex;
         }
         this.recentNode = node;
         this.startY = currentY;
         return index;
      }
      
      private function getNextRowIndexAt(y:Number, startNode:GridRowNode, startY:Number) : int
      {
         var nextY:Number = NaN;
         var indDiff:int = 0;
         var node:GridRowNode = startNode;
         var nextNode:GridRowNode = null;
         var index:int = node.rowIndex;
         var nodeY:Number = startY;
         var currentY:Number = startY;
         var targetY:Number = y;
         while(Boolean(node))
         {
            if(this.isYInRow(targetY,nodeY,node))
            {
               break;
            }
            currentY += node.maxCellHeight;
            if(node.rowIndex != this.rowCount - 1)
            {
               currentY += this.rowGap;
            }
            nextNode = node.next;
            nextY = currentY;
            if(!nextNode)
            {
               indDiff = this.rowCount - 1 - node.rowIndex;
               nextY += indDiff * (this.defaultRowHeight + this.rowGap) - this.rowGap + 1;
            }
            else
            {
               indDiff = nextNode.rowIndex - node.rowIndex;
               nextY += (indDiff - 1) * (this.defaultRowHeight + this.rowGap);
            }
            if(targetY >= currentY && targetY < nextY)
            {
               index += Math.ceil(Number(targetY - currentY) / (this.defaultRowHeight + this.rowGap));
               break;
            }
            if(!nextNode)
            {
               index = -1;
               break;
            }
            nodeY = currentY = nextY;
            node = node.next;
            index = node.rowIndex;
         }
         this.recentNode = node;
         this.startY = nodeY;
         return index;
      }
      
      public function getColumnIndexAt(x:Number, y:Number) : int
      {
         var i:int = 0;
         var temp:Number = NaN;
         var cur:Number = x;
         for(i = 0; i < this._columnCount; i++)
         {
            temp = this._columnWidths[i];
            if(isNaN(temp))
            {
               temp = this.typicalCellWidths[i];
               if(temp == 0)
               {
                  continue;
               }
            }
            if(isNaN(temp))
            {
               temp = this.defaultColumnWidth;
            }
            cur -= temp + this.columnGap;
            if(cur <= 0)
            {
               return i;
            }
         }
         return -1;
      }
      
      public function getContentWidth(columnCountOverride:int = -1) : Number
      {
         var width:Number = NaN;
         var nCols:int = columnCountOverride == -1 ? this._columnCount : columnCountOverride;
         var contentWidth:Number = 0;
         var measuredColCount:int = 0;
         var i:int = 0;
         for(; i < this._columnCount && measuredColCount < nCols; i++)
         {
            if(i >= this._columnWidths.length)
            {
               contentWidth += this.defaultColumnWidth;
               measuredColCount++;
            }
            else
            {
               width = this._columnWidths[i];
               if(isNaN(width))
               {
                  width = this.typicalCellWidths[i];
                  if(width == 0)
                  {
                     continue;
                  }
               }
               if(isNaN(width))
               {
                  width = this.defaultColumnWidth;
               }
               contentWidth += width;
               measuredColCount++;
            }
         }
         if(nCols > 1)
         {
            contentWidth += (nCols - 1) * this.columnGap;
         }
         return contentWidth;
      }
      
      public function getContentHeight(rowCountOverride:int = -1) : Number
      {
         var nRows:int = rowCountOverride == -1 ? this.rowCount : rowCountOverride;
         var contentHeight:Number = 0;
         if(nRows > 1)
         {
            contentHeight += (nRows - 1) * this.rowGap;
         }
         if(!this.variableRowHeight || this.rowList.length == 0)
         {
            return contentHeight + nRows * this.defaultRowHeight;
         }
         var node:GridRowNode = this.rowList.first;
         var numRows:int = 0;
         while(Boolean(node) && node.rowIndex < nRows)
         {
            contentHeight += node.maxCellHeight;
            numRows++;
            node = node.next;
         }
         return contentHeight + (nRows - numRows) * this.defaultRowHeight;
      }
      
      public function getTypicalContentWidth(columnCountOverride:int = -1) : Number
      {
         var width:Number = NaN;
         var nCols:int = columnCountOverride == -1 ? this._columnCount : columnCountOverride;
         var contentWidth:Number = 0;
         var measuredColCount:int = 0;
         var columnIndex:int = 0;
         while(columnIndex < this._columnCount && measuredColCount < nCols)
         {
            width = columnIndex < this._columnCount ? this.typicalCellWidths[columnIndex] : NaN;
            if(width != 0)
            {
               if(isNaN(width))
               {
                  width = this.defaultColumnWidth;
               }
               contentWidth += width;
               measuredColCount++;
            }
            columnIndex++;
         }
         if(nCols > 1)
         {
            contentWidth += (measuredColCount - 1) * this.columnGap;
         }
         return contentWidth;
      }
      
      public function getTypicalContentHeight(rowCountOverride:int = -1) : Number
      {
         var nRows:int = rowCountOverride == -1 ? this.rowCount : rowCountOverride;
         var contentHeight:Number = 0;
         if(nRows > 1)
         {
            contentHeight += (nRows - 1) * this.rowGap;
         }
         if(!isNaN(this.defaultRowHeight))
         {
            return contentHeight + nRows * this.defaultRowHeight;
         }
         return 0;
      }
      
      public function getTypicalCellWidth(columnIndex:int) : Number
      {
         return this.typicalCellWidths[columnIndex];
      }
      
      public function setTypicalCellWidth(columnIndex:int, value:Number) : void
      {
         this.typicalCellWidths[columnIndex] = value;
      }
      
      public function getTypicalCellHeight(columnIndex:int) : Number
      {
         return this.typicalCellHeights[columnIndex];
      }
      
      public function setTypicalCellHeight(columnIndex:int, value:Number) : void
      {
         this.typicalCellHeights[columnIndex] = value;
         var max:Number = 0;
         var typicalCellHeightsLength:int = int(this.typicalCellHeights.length);
         for(var i:int = 0; i < typicalCellHeightsLength; i++)
         {
            if(!isNaN(this.typicalCellHeights[i]))
            {
               max = Math.max(max,this.typicalCellHeights[i]);
            }
         }
         this.maxTypicalCellHeight = max;
      }
      
      public function clearTypicalCellWidthsAndHeights() : void
      {
         clearVector(this.typicalCellWidths,NaN);
         clearVector(this.typicalCellHeights,NaN);
         this.maxTypicalCellHeight = NaN;
      }
      
      public function insertRows(startRow:int, count:int) : void
      {
         this.insertRowsAt(startRow,count);
      }
      
      public function insertColumns(startColumn:int, count:int) : void
      {
         var oldColumnCount:int = this._columnCount;
         var newColumnCount:int = this._columnCount + count;
         if(startColumn < 0 || startColumn > oldColumnCount)
         {
            return;
         }
         this.rowList.insertColumns(startColumn,count);
         this._columnCount = newColumnCount;
         insertValueToVector(this._columnWidths,startColumn,count,NaN);
         insertValueToVector(this.typicalCellWidths,startColumn,count,NaN);
         insertValueToVector(this.typicalCellHeights,startColumn,count,NaN);
      }
      
      public function removeRows(startRow:int, count:int) : void
      {
         this.removeRowsAt(startRow,count);
      }
      
      public function removeColumns(startColumn:int, count:int) : void
      {
         var oldColumnCount:int = this._columnCount;
         var newColumnCount:int = this._columnCount - count;
         if(startColumn < 0 || startColumn >= oldColumnCount)
         {
            return;
         }
         if(newColumnCount <= 0)
         {
            this.columnCount = 0;
            return;
         }
         this.rowList.removeColumns(startColumn,count);
         this._columnCount = newColumnCount;
         this._columnWidths.splice(startColumn,count);
         this.typicalCellWidths.splice(startColumn,count);
         this.typicalCellHeights.splice(startColumn,count);
         this.recentNode = null;
         this.recentNode2 = null;
      }
      
      public function clearRows(startRow:int, count:int) : void
      {
         var oldNode:GridRowNode = null;
         if(startRow < 0 || count <= 0)
         {
            return;
         }
         var node:GridRowNode = this.rowList.findNearestLTE(startRow);
         var endRow:int = startRow + count;
         if(Boolean(node) && node.rowIndex < startRow)
         {
            node = node.next;
         }
         while(Boolean(node) && node.rowIndex < endRow)
         {
            oldNode = node;
            node = node.next;
            this.rowList.removeNode(oldNode);
         }
         this.recentNode = null;
         this.recentNode2 = null;
      }
      
      public function clearColumns(startColumn:int, count:int) : void
      {
         if(startColumn < 0 || startColumn >= this._columnCount)
         {
            return;
         }
         this.rowList.clearColumns(startColumn,count);
         clearVector(this.typicalCellWidths,NaN,startColumn,count);
         clearVector(this.typicalCellHeights,NaN,startColumn,count);
         clearVector(this._columnWidths,NaN,startColumn,count);
         this.recentNode = null;
         this.recentNode2 = null;
      }
      
      public function moveRows(fromRow:int, toRow:int, count:int) : void
      {
         var node:GridRowNode = null;
         var rows:Vector.<GridRowNode> = this.removeRowsAt(fromRow,count);
         var diff:int = toRow - fromRow;
         for each(node in rows)
         {
            node.rowIndex += diff;
         }
         this.insertRowsAt(toRow,count,rows);
      }
      
      public function moveColumns(fromCol:int, toCol:int, count:int) : void
      {
         if(fromCol < 0 || fromCol >= this._columnCount || toCol < 0 || toCol > this._columnCount)
         {
            return;
         }
         this.rowList.moveColumns(fromCol,toCol,count);
         insertElementsToVector(this._columnWidths,toCol,this._columnWidths.splice(fromCol,count));
         insertElementsToVector(this.typicalCellWidths,toCol,this.typicalCellWidths.splice(fromCol,count));
         insertElementsToVector(this.typicalCellHeights,toCol,this.typicalCellHeights.splice(fromCol,count));
      }
      
      public function clearHeights() : void
      {
         this.rowList.removeAll();
         this.recentNode = null;
         this.recentNode2 = null;
         this.startY = 0;
         this.startY2 = 0;
      }
      
      private function insertRowsAt(startRow:int, count:int, nodes:Vector.<GridRowNode> = null) : void
      {
         var node:GridRowNode = null;
         if(startRow < 0 || count <= 0)
         {
            return;
         }
         var startNode:GridRowNode = this.rowList.findNearestLTE(startRow);
         if(Boolean(startNode) && startNode.rowIndex < startRow)
         {
            startNode = startNode.next;
         }
         if(Boolean(nodes))
         {
            if(Boolean(startNode))
            {
               for each(node in nodes)
               {
                  this.rowList.insertBefore(startNode,node);
               }
            }
            else
            {
               for each(node in nodes)
               {
                  this.rowList.push(node);
               }
            }
         }
         node = startNode;
         while(Boolean(node))
         {
            node.rowIndex += count;
            node = node.next;
         }
         this.rowCount += count;
         this.recentNode = null;
         this.recentNode2 = null;
      }
      
      private function removeRowsAt(startRow:int, count:int) : Vector.<GridRowNode>
      {
         var oldNode:GridRowNode = null;
         var vec:Vector.<GridRowNode> = new Vector.<GridRowNode>();
         if(startRow < 0 || count <= 0)
         {
            return vec;
         }
         var node:GridRowNode = this.rowList.findNearestLTE(startRow);
         var endRow:int = startRow + count;
         if(Boolean(node) && node.rowIndex < startRow)
         {
            node = node.next;
         }
         while(Boolean(node) && node.rowIndex < endRow)
         {
            oldNode = node;
            vec.push(oldNode);
            node = node.next;
            this.rowList.removeNode(oldNode);
         }
         while(Boolean(node))
         {
            node.rowIndex -= count;
            node = node.next;
         }
         this._rowCount -= count;
         this.recentNode = null;
         this.recentNode2 = null;
         return vec;
      }
      
      public function dataProviderCollectionChanged(event:CollectionEvent) : void
      {
         switch(event.kind)
         {
            case CollectionEventKind.ADD:
               this.insertRows(event.location,event.items.length);
               break;
            case CollectionEventKind.REMOVE:
               this.removeRows(event.location,event.items.length);
               break;
            case CollectionEventKind.MOVE:
               this.moveRows(event.oldLocation,event.location,event.items.length);
               break;
            case CollectionEventKind.REFRESH:
               this.clearHeights();
               break;
            case CollectionEventKind.RESET:
               this.clearHeights();
               this.clearTypicalCellWidthsAndHeights();
               break;
            case CollectionEventKind.UPDATE:
               break;
            case CollectionEventKind.REPLACE:
               this.clearRows(event.location,event.items.length);
         }
      }
      
      public function columnsCollectionChanged(event:CollectionEvent) : void
      {
         var pcEvent:PropertyChangeEvent = null;
         var itemsLength:int = 0;
         var i:int = 0;
         switch(event.kind)
         {
            case CollectionEventKind.ADD:
               this.insertColumns(event.location,event.items.length);
               break;
            case CollectionEventKind.REMOVE:
               this.removeColumns(event.location,event.items.length);
               break;
            case CollectionEventKind.MOVE:
               this.moveColumns(event.oldLocation,event.location,event.items.length);
               break;
            case CollectionEventKind.REFRESH:
            case CollectionEventKind.RESET:
               this.columnCount = IList(event.target).length;
               break;
            case CollectionEventKind.UPDATE:
               itemsLength = Boolean(event.items) ? int(event.items.length) : 0;
               for(i = 0; i < itemsLength; i++)
               {
                  pcEvent = event.items[i] as PropertyChangeEvent;
                  if(Boolean(pcEvent) && pcEvent.property == "visible")
                  {
                     this.columns_visibleChangedHandler(pcEvent);
                  }
               }
               break;
            case CollectionEventKind.REPLACE:
               this.clearColumns(event.location,event.items.length);
         }
      }
      
      private function columns_visibleChangedHandler(pcEvent:PropertyChangeEvent) : void
      {
         var column:GridColumn = null;
         column = pcEvent.source as GridColumn;
         var columnIndex:int = column.columnIndex;
         if(!column || columnIndex < 0 || columnIndex >= this._columnCount)
         {
            return;
         }
         this.clearColumns(columnIndex,1);
         if(column.visible)
         {
            this.setTypicalCellWidth(columnIndex,NaN);
            this.setTypicalCellHeight(columnIndex,NaN);
            if(!isNaN(column.width))
            {
               this.setColumnWidth(columnIndex,column.width);
            }
         }
         else
         {
            this.setTypicalCellWidth(columnIndex,0);
            this.setTypicalCellHeight(columnIndex,0);
            this.setColumnWidth(columnIndex,NaN);
         }
      }
      
      public function toString() : String
      {
         return this.rowList.toString();
      }
   }
}

