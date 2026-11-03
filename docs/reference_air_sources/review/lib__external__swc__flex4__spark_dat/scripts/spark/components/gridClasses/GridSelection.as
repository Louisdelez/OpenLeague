package spark.components.gridClasses
{
   import flash.geom.Rectangle;
   import mx.collections.ICollectionView;
   import mx.collections.IList;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import spark.components.Grid;
   
   [ExcludeClass]
   public class GridSelection
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var cellRegions:Vector.<CellRect> = new Vector.<CellRect>();
      
      private var selectedItem:Object;
      
      private var inCollectionHandler:Boolean;
      
      private var _grid:Grid;
      
      private var _preserveSelection:Boolean = true;
      
      private var _requireSelection:Boolean = false;
      
      private var _selectionLength:int = 0;
      
      private var _selectionMode:String = "singleRow";
      
      public function GridSelection()
      {
         super();
      }
      
      public function get grid() : Grid
      {
         return this._grid;
      }
      
      public function set grid(value:Grid) : void
      {
         this._grid = value;
      }
      
      public function get preserveSelection() : Boolean
      {
         return this._preserveSelection;
      }
      
      public function set preserveSelection(value:Boolean) : void
      {
         if(this._preserveSelection == value)
         {
            return;
         }
         this._preserveSelection = value;
         this.selectedItem = null;
         if(this._preserveSelection && (this.selectionMode == GridSelectionMode.SINGLE_ROW || this.selectionMode == GridSelectionMode.SINGLE_CELL) && this.selectionLength > 0)
         {
            if(this.selectionMode == GridSelectionMode.SINGLE_ROW)
            {
               this.selectedItem = this.grid.dataProvider.getItemAt(this.allRows()[0]);
            }
            else
            {
               this.selectedItem = this.grid.dataProvider.getItemAt(this.allCells()[0].rowIndex);
            }
         }
      }
      
      public function get requireSelection() : Boolean
      {
         return this._requireSelection;
      }
      
      public function set requireSelection(value:Boolean) : void
      {
         if(this._requireSelection == value)
         {
            return;
         }
         this._requireSelection = value;
         if(this._requireSelection)
         {
            this.ensureRequiredSelection();
         }
      }
      
      public function get selectionLength() : int
      {
         var cellRegionsLength:int = 0;
         var i:int = 0;
         var cr:CellRect = null;
         var numSelected:int = 0;
         var isRows:Boolean = this.isRowSelectionMode();
         if(this._selectionLength < 0)
         {
            this._selectionLength = 0;
            cellRegionsLength = int(this.cellRegions.length);
            for(i = 0; i < cellRegionsLength; i++)
            {
               cr = this.cellRegions[i];
               numSelected = isRows ? int(cr.height) : int(cr.height * cr.width);
               if(cr.isAdd)
               {
                  this._selectionLength += numSelected;
               }
               else
               {
                  this._selectionLength -= numSelected;
               }
            }
         }
         return this._selectionLength;
      }
      
      public function get selectionMode() : String
      {
         return this._selectionMode;
      }
      
      public function set selectionMode(value:String) : void
      {
         if(value == this._selectionMode)
         {
            return;
         }
         switch(value)
         {
            case GridSelectionMode.SINGLE_ROW:
            case GridSelectionMode.MULTIPLE_ROWS:
            case GridSelectionMode.SINGLE_CELL:
            case GridSelectionMode.MULTIPLE_CELLS:
            case GridSelectionMode.NONE:
               this._selectionMode = value;
               this.removeAll();
         }
      }
      
      public function allCells() : Vector.<CellPosition>
      {
         var bounds:Rectangle = null;
         var columnIndex:int = 0;
         var cells:Vector.<CellPosition> = new Vector.<CellPosition>();
         if(!this.isCellSelectionMode())
         {
            return cells;
         }
         bounds = this.getCellRegionsBounds();
         var left:int = bounds.left;
         var right:int = bounds.right;
         var bottom:int = bounds.bottom;
         for(var rowIndex:int = bounds.top; rowIndex < bottom; rowIndex++)
         {
            for(columnIndex = left; columnIndex < right; columnIndex++)
            {
               if(this.regionsContainCell(rowIndex,columnIndex))
               {
                  cells.push(new CellPosition(rowIndex,columnIndex));
               }
            }
         }
         return cells;
      }
      
      public function allRows() : Vector.<int>
      {
         var bounds:Rectangle = null;
         if(!this.isRowSelectionMode())
         {
            return new Vector.<int>(0,true);
         }
         var rows:Vector.<int> = new Vector.<int>();
         bounds = this.getCellRegionsBounds();
         var bottom:int = bounds.bottom;
         for(var rowIndex:int = bounds.top; rowIndex < bottom; rowIndex++)
         {
            if(this.regionsContainCell(rowIndex,0))
            {
               rows.push(rowIndex);
            }
         }
         return rows;
      }
      
      public function selectAll() : Boolean
      {
         var maxColumns:int = 0;
         var maxRows:int = int(this.getGridDataProviderLength());
         if(this.selectionMode == GridSelectionMode.MULTIPLE_ROWS)
         {
            return this.setRows(0,maxRows);
         }
         if(this.selectionMode == GridSelectionMode.MULTIPLE_CELLS)
         {
            maxColumns = int(this.getGridColumnsLength());
            return this.setCellRegion(0,0,maxRows,maxColumns);
         }
         return false;
      }
      
      public function removeAll() : Boolean
      {
         var selectionChanged:Boolean = this.selectionLength > 0;
         this.removeSelection();
         return this.ensureRequiredSelection() || selectionChanged;
      }
      
      public function containsRow(rowIndex:int) : Boolean
      {
         if(!this.validateIndex(rowIndex))
         {
            return false;
         }
         return this.regionsContainCell(rowIndex,0);
      }
      
      public function containsRows(rowsIndices:Vector.<int>) : Boolean
      {
         var rowIndex:int = 0;
         if(!this.validateIndices(rowsIndices))
         {
            return false;
         }
         for each(rowIndex in rowsIndices)
         {
            if(!this.regionsContainCell(rowIndex,0))
            {
               return false;
            }
         }
         return true;
      }
      
      public function setRow(rowIndex:int) : Boolean
      {
         if(!this.validateIndex(rowIndex))
         {
            return false;
         }
         this.internalSetCellRegion(rowIndex);
         return true;
      }
      
      public function addRow(rowIndex:int) : Boolean
      {
         if(!this.validateIndex(rowIndex))
         {
            return false;
         }
         if(this.selectionMode != GridSelectionMode.MULTIPLE_ROWS)
         {
            return false;
         }
         this.internalAddCell(rowIndex);
         return true;
      }
      
      public function removeRow(rowIndex:int) : Boolean
      {
         if(!this.validateIndex(rowIndex))
         {
            return false;
         }
         if(this.requireSelection && this.containsRow(rowIndex) && this.selectionLength == 1)
         {
            return false;
         }
         this.internalRemoveCell(rowIndex);
         return true;
      }
      
      public function setRows(rowIndex:int, rowCount:int) : Boolean
      {
         if(!this.validateRowRegion(rowIndex,rowCount))
         {
            return false;
         }
         this.internalSetCellRegion(rowIndex,0,rowCount,1);
         return true;
      }
      
      public function containsCell(rowIndex:int, columnIndex:int) : Boolean
      {
         if(!this.validateCell(rowIndex,columnIndex))
         {
            return false;
         }
         return this.regionsContainCell(rowIndex,columnIndex);
      }
      
      public function containsCellRegion(rowIndex:int, columnIndex:int, rowCount:int, columnCount:int) : Boolean
      {
         var cr:CellRect = null;
         var c:int = 0;
         if(!this.validateCellRegion(rowIndex,columnIndex,rowCount,columnCount))
         {
            return false;
         }
         if(rowCount * columnCount > this.selectionLength)
         {
            return false;
         }
         var cellRegionsLength:int = int(this.cellRegions.length);
         if(cellRegionsLength == 0)
         {
            return false;
         }
         if(cellRegionsLength == 1)
         {
            cr = this.cellRegions[0];
            return rowIndex >= cr.top && columnIndex >= cr.left && rowIndex + rowCount <= cr.bottom && columnIndex + columnCount <= cr.right;
         }
         var bottom:int = rowIndex + rowCount;
         var right:int = columnIndex + columnCount;
         loop0:
         for(var r:int = rowIndex; r < bottom; )
         {
            c = columnIndex;
            while(true)
            {
               if(c >= right)
               {
                  r++;
                  continue loop0;
               }
               if(!this.containsCell(r,c))
               {
                  break;
               }
               c++;
            }
            return false;
         }
         return true;
      }
      
      public function setCell(rowIndex:int, columnIndex:int) : Boolean
      {
         if(!this.validateCell(rowIndex,columnIndex))
         {
            return false;
         }
         var columnVisible:Boolean = this.isColumnVisible(columnIndex);
         if(columnVisible)
         {
            this.internalSetCellRegion(rowIndex,columnIndex,1,1);
         }
         return columnVisible;
      }
      
      public function addCell(rowIndex:int, columnIndex:int) : Boolean
      {
         if(!this.validateCellRegion(rowIndex,columnIndex,1,1))
         {
            return false;
         }
         var columnVisible:Boolean = this.isColumnVisible(columnIndex);
         if(columnVisible)
         {
            this.internalAddCell(rowIndex,columnIndex);
         }
         return columnVisible;
      }
      
      public function removeCell(rowIndex:int, columnIndex:int) : Boolean
      {
         if(!this.validateCell(rowIndex,columnIndex))
         {
            return false;
         }
         if(this.requireSelection && this.containsCell(rowIndex,columnIndex) && this.selectionLength == 1)
         {
            return false;
         }
         this.internalRemoveCell(rowIndex,columnIndex);
         return true;
      }
      
      public function setCellRegion(rowIndex:int, columnIndex:int, rowCount:uint, columnCount:uint) : Boolean
      {
         var columnVisible:Boolean = false;
         if(!this.validateCellRegion(rowIndex,columnIndex,rowCount,columnCount))
         {
            return false;
         }
         this.removeSelection();
         var startColumnIndex:int = columnIndex;
         var curColumnCount:int = 0;
         var endColumnIndex:int = columnIndex + columnCount - 1;
         for(var i:int = columnIndex; i <= endColumnIndex; i++)
         {
            columnVisible = this.isColumnVisible(i);
            if(columnVisible)
            {
               curColumnCount++;
            }
            else
            {
               this.internalAddCellRegion(rowIndex,startColumnIndex,rowCount,curColumnCount);
               curColumnCount = 0;
               startColumnIndex = i + 1;
            }
         }
         if(curColumnCount > 0)
         {
            this.internalAddCellRegion(rowIndex,startColumnIndex,rowCount,curColumnCount);
         }
         return true;
      }
      
      private function isRowSelectionMode() : Boolean
      {
         var mode:String = this.selectionMode;
         return mode == GridSelectionMode.SINGLE_ROW || mode == GridSelectionMode.MULTIPLE_ROWS;
      }
      
      private function isCellSelectionMode() : Boolean
      {
         var mode:String = this.selectionMode;
         return mode == GridSelectionMode.SINGLE_CELL || mode == GridSelectionMode.MULTIPLE_CELLS;
      }
      
      private function isColumnVisible(columnIndex:int) : Boolean
      {
         return GridColumn(this.grid.columns.getItemAt(columnIndex)).visible;
      }
      
      private function getGridColumnsLength() : uint
      {
         if(this.grid == null)
         {
            return 0;
         }
         var columns:IList = this.grid.columns;
         return Boolean(columns) ? uint(columns.length) : 0;
      }
      
      private function getGridDataProviderLength() : uint
      {
         if(this.grid == null)
         {
            return 0;
         }
         var dataProvider:IList = this.grid.dataProvider;
         return Boolean(dataProvider) ? uint(dataProvider.length) : 0;
      }
      
      private function regionsContainCell(rowIndex:int, columnIndex:int) : Boolean
      {
         var cr:CellRect = null;
         var cellRegionsLength:int = int(this.cellRegions.length);
         var index:int = -1;
         for(var i:int = 0; i < cellRegionsLength; i++)
         {
            cr = this.cellRegions[i];
            if(cr.isAdd && cr.containsCell(rowIndex,columnIndex))
            {
               index = i;
            }
         }
         if(index == -1)
         {
            return false;
         }
         for(i = index + 1; i < cellRegionsLength; i++)
         {
            cr = this.cellRegions[i];
            if(!cr.isAdd && cr.containsCell(rowIndex,columnIndex))
            {
               return false;
            }
         }
         return true;
      }
      
      private function ensureRequiredSelection() : Boolean
      {
         var selectionChanged:Boolean = false;
         if(!this.requireSelection)
         {
            return false;
         }
         if(this.getGridDataProviderLength() == 0 || this.getGridColumnsLength() == 0)
         {
            return false;
         }
         if(this.isRowSelectionMode())
         {
            if(this.selectionLength == 0)
            {
               selectionChanged = this.grid.setSelectedIndex(0);
            }
         }
         else if(this.isCellSelectionMode())
         {
            if(this.selectionLength == 0)
            {
               selectionChanged = this.grid.setSelectedCell(0,0);
            }
         }
         return selectionChanged;
      }
      
      private function removeSelection() : void
      {
         this.cellRegions.length = 0;
         this._selectionLength = 0;
         this.selectedItem = null;
      }
      
      protected function validateIndex(index:int) : Boolean
      {
         if(this.inCollectionHandler)
         {
            return true;
         }
         return this.isRowSelectionMode() && index >= 0 && index < this.getGridDataProviderLength();
      }
      
      protected function validateIndices(indices:Vector.<int>) : Boolean
      {
         var index:int = 0;
         if(this.selectionMode == GridSelectionMode.MULTIPLE_ROWS)
         {
            if(this.inCollectionHandler)
            {
               return true;
            }
            for each(index in indices)
            {
               if(index < 0 || index >= this.getGridDataProviderLength())
               {
                  return false;
               }
            }
            return true;
         }
         return false;
      }
      
      protected function validateCell(rowIndex:int, columnIndex:int) : Boolean
      {
         if(this.inCollectionHandler)
         {
            return true;
         }
         return this.isCellSelectionMode() && rowIndex >= 0 && rowIndex < this.getGridDataProviderLength() && columnIndex >= 0 && columnIndex < this.getGridColumnsLength();
      }
      
      protected function validateCellRegion(rowIndex:int, columnIndex:int, rowCount:int, columnCount:int) : Boolean
      {
         var maxRows:int = 0;
         var maxColumns:int = 0;
         if(this.selectionMode == GridSelectionMode.MULTIPLE_CELLS)
         {
            if(this.inCollectionHandler)
            {
               return true;
            }
            maxRows = int(this.getGridDataProviderLength());
            maxColumns = int(this.getGridColumnsLength());
            return rowIndex >= 0 && rowCount >= 0 && rowIndex + rowCount <= maxRows && columnIndex >= 0 && columnCount >= 0 && columnIndex + columnCount <= maxColumns;
         }
         return false;
      }
      
      protected function validateRowRegion(rowIndex:int, rowCount:int) : Boolean
      {
         var maxRows:int = 0;
         if(this.selectionMode == GridSelectionMode.MULTIPLE_ROWS)
         {
            if(this.inCollectionHandler)
            {
               return true;
            }
            maxRows = int(this.getGridDataProviderLength());
            return rowIndex >= 0 && rowCount >= 0 && rowIndex + rowCount <= maxRows;
         }
         return false;
      }
      
      private function internalSetCellRegion(rowIndex:int, columnIndex:int = 0, rowCount:uint = 1, columnCount:uint = 1) : void
      {
         var cr:CellRect = new CellRect(rowIndex,columnIndex,rowCount,columnCount,true);
         this.removeSelection();
         this.cellRegions.push(cr);
         this._selectionLength = rowCount * columnCount;
         if(this.preserveSelection && (this.selectionMode == GridSelectionMode.SINGLE_ROW || this.selectionMode == GridSelectionMode.SINGLE_CELL))
         {
            this.selectedItem = this.grid.dataProvider.getItemAt(rowIndex);
         }
      }
      
      private function internalAddCellRegion(rowIndex:int, columnIndex:int = 0, rowCount:uint = 1, columnCount:uint = 1) : void
      {
         var cr:CellRect = new CellRect(rowIndex,columnIndex,rowCount,columnCount,true);
         this.cellRegions.push(cr);
         this._selectionLength += rowCount * columnCount;
      }
      
      private function internalAddCell(rowIndex:int, columnIndex:int = 0) : void
      {
         var cr:CellRect = null;
         if(!this.regionsContainCell(rowIndex,columnIndex))
         {
            cr = new CellRect(rowIndex,columnIndex,1,1,true);
            this.cellRegions.push(cr);
            if(this._selectionLength >= 0)
            {
               ++this._selectionLength;
            }
         }
      }
      
      private function internalRemoveCell(rowIndex:int, columnIndex:int = 0) : void
      {
         var cr:CellRect = null;
         if(this.regionsContainCell(rowIndex,columnIndex))
         {
            cr = new CellRect(rowIndex,columnIndex,1,1,false);
            this.cellRegions.push(cr);
            if(this._selectionLength >= 0)
            {
               --this._selectionLength;
            }
            this.selectedItem = null;
         }
      }
      
      private function getCellRegionsBounds() : Rectangle
      {
         var cr:CellRect = null;
         var bounds:Rectangle = new Rectangle();
         var cellRegionsLength:int = int(this.cellRegions.length);
         for(var i:int = 0; i < cellRegionsLength; i++)
         {
            cr = this.cellRegions[i];
            if(cr.isAdd)
            {
               bounds = bounds.union(cr);
            }
         }
         return bounds;
      }
      
      public function dataProviderCollectionChanged(event:CollectionEvent) : void
      {
         this.inCollectionHandler = true;
         switch(event.kind)
         {
            case CollectionEventKind.ADD:
               this.dataProviderCollectionAdd(event);
               break;
            case CollectionEventKind.MOVE:
               this.dataProviderCollectionMove(event);
               break;
            case CollectionEventKind.REFRESH:
               this.dataProviderCollectionRefresh(event);
               break;
            case CollectionEventKind.REMOVE:
               this.dataProviderCollectionRemove(event);
               break;
            case CollectionEventKind.REPLACE:
               this.dataProviderCollectionReplace(event);
               break;
            case CollectionEventKind.RESET:
               this.dataProviderCollectionReset(event);
               break;
            case CollectionEventKind.UPDATE:
               this.dataProviderCollectionUpdate(event);
         }
         this.inCollectionHandler = false;
      }
      
      private function dataProviderCollectionAdd(event:CollectionEvent) : void
      {
         this.handleRowAdd(event.location,event.items.length);
         this.ensureRequiredSelection();
      }
      
      private function handleRowAdd(insertIndex:int, insertCount:int = 1) : void
      {
         var crIndex:int = 0;
         var cr:CellRect = null;
         var newCR:CellRect = null;
         for(var cnt:int = 0; cnt < insertCount; cnt++)
         {
            for(crIndex = 0; crIndex < this.cellRegions.length; crIndex++)
            {
               cr = this.cellRegions[crIndex];
               if(insertIndex <= cr.y)
               {
                  ++cr.y;
               }
               else if(insertIndex < cr.bottom)
               {
                  newCR = new CellRect(insertIndex + 1,cr.x,cr.bottom - insertIndex,cr.width,cr.isAdd);
                  cr.height = insertIndex - cr.y;
                  this.cellRegions.splice(++crIndex,0,newCR);
                  this._selectionLength = -1;
               }
            }
         }
      }
      
      private function dataProviderCollectionMove(event:CollectionEvent) : void
      {
         var oldRowIndex:int = int(event.oldLocation);
         var newRowIndex:int = int(event.location);
         this.handleRowRemove(oldRowIndex);
         if(newRowIndex > oldRowIndex)
         {
            newRowIndex--;
         }
         this.handleRowAdd(newRowIndex);
      }
      
      private function dataProviderCollectionRefresh(event:CollectionEvent) : void
      {
         this.handleRefreshAndReset(event);
      }
      
      private function handleRefreshAndReset(event:CollectionEvent) : void
      {
         var view:ICollectionView = null;
         var newRowIndex:int = 0;
         var oldSelectedCell:CellPosition = null;
         if(Boolean(this.selectedItem))
         {
            view = event.currentTarget as ICollectionView;
            if(Boolean(view) && Boolean(view.contains(this.selectedItem)))
            {
               newRowIndex = int(this.grid.dataProvider.getItemIndex(this.selectedItem));
               if(this.selectionMode == GridSelectionMode.SINGLE_ROW)
               {
                  this.internalSetCellRegion(newRowIndex);
               }
               else
               {
                  oldSelectedCell = this.allCells()[0];
                  this.internalSetCellRegion(newRowIndex,oldSelectedCell.columnIndex);
               }
               return;
            }
         }
         this.removeSelection();
         this.ensureRequiredSelection();
      }
      
      private function dataProviderCollectionRemove(event:CollectionEvent) : void
      {
         if(this.getGridDataProviderLength() == 0)
         {
            this.removeSelection();
            return;
         }
         this.handleRowRemove(event.location,event.items.length);
         this.ensureRequiredSelection();
      }
      
      private function handleRowRemove(removeIndex:int, removeCount:int = 1) : void
      {
         var crIndex:int = 0;
         var cr:CellRect = null;
         for(var cnt:int = 0; cnt < removeCount; cnt++)
         {
            crIndex = 0;
            while(crIndex < this.cellRegions.length)
            {
               cr = this.cellRegions[crIndex];
               if(removeIndex < cr.y)
               {
                  --cr.y;
               }
               else if(removeIndex >= cr.y && removeIndex < cr.bottom)
               {
                  this._selectionLength = -1;
                  --cr.height;
                  if(cr.height == 0)
                  {
                     this.cellRegions.splice(crIndex,1);
                     continue;
                  }
               }
               crIndex++;
            }
         }
      }
      
      private function dataProviderCollectionReplace(event:CollectionEvent) : void
      {
      }
      
      private function dataProviderCollectionReset(event:CollectionEvent) : void
      {
         this.handleRefreshAndReset(event);
      }
      
      private function dataProviderCollectionUpdate(event:CollectionEvent) : void
      {
      }
      
      public function columnsCollectionChanged(event:CollectionEvent) : void
      {
         this.inCollectionHandler = true;
         switch(event.kind)
         {
            case CollectionEventKind.ADD:
               this.columnsCollectionAdd(event);
               break;
            case CollectionEventKind.MOVE:
               this.columnsCollectionMove(event);
               break;
            case CollectionEventKind.REMOVE:
               this.columnsCollectionRemove(event);
               break;
            case CollectionEventKind.REPLACE:
            case CollectionEventKind.UPDATE:
               break;
            case CollectionEventKind.REFRESH:
               this.columnsCollectionRefresh(event);
               break;
            case CollectionEventKind.RESET:
               this.columnsCollectionReset(event);
         }
         this.inCollectionHandler = false;
      }
      
      private function columnsCollectionAdd(event:CollectionEvent) : void
      {
         if(!this.isCellSelectionMode())
         {
            return;
         }
         this.handleColumnAdd(event.location,event.items.length);
         this.ensureRequiredSelection();
      }
      
      private function handleColumnAdd(insertIndex:int, insertCount:int = 1) : void
      {
         var crIndex:int = 0;
         var cr:CellRect = null;
         var newCR:CellRect = null;
         for(var cnt:int = 0; cnt < insertCount; cnt++)
         {
            for(crIndex = 0; crIndex < this.cellRegions.length; crIndex++)
            {
               cr = this.cellRegions[crIndex];
               if(insertIndex <= cr.x)
               {
                  ++cr.x;
               }
               else if(insertIndex < cr.x)
               {
                  newCR = new CellRect(cr.y,insertIndex + 1,cr.height,cr.right - insertIndex,cr.isAdd);
                  cr.width = insertIndex - cr.x;
                  this.cellRegions.splice(++crIndex,0,newCR);
                  this._selectionLength = -1;
               }
            }
         }
      }
      
      private function columnsCollectionMove(event:CollectionEvent) : void
      {
         if(!this.isCellSelectionMode())
         {
            return;
         }
         var oldColumnIndex:int = int(event.oldLocation);
         var newColumnIndex:int = int(event.location);
         this.handleColumnRemove(oldColumnIndex);
         if(newColumnIndex > oldColumnIndex)
         {
            newColumnIndex--;
         }
         this.handleColumnAdd(newColumnIndex);
      }
      
      private function columnsCollectionRemove(event:CollectionEvent) : void
      {
         if(!this.isCellSelectionMode())
         {
            return;
         }
         if(this.getGridColumnsLength() == 0)
         {
            this.removeSelection();
            return;
         }
         this.handleColumnRemove(event.location,event.items.length);
         this.ensureRequiredSelection();
      }
      
      private function handleColumnRemove(removeIndex:int, removeCount:int = 1) : void
      {
         var crIndex:int = 0;
         var cr:CellRect = null;
         for(var cnt:int = 0; cnt < removeCount; cnt++)
         {
            crIndex = 0;
            while(crIndex < this.cellRegions.length)
            {
               cr = this.cellRegions[crIndex];
               if(removeIndex < cr.x)
               {
                  --cr.x;
               }
               else if(removeIndex >= cr.x && removeIndex < cr.right)
               {
                  this._selectionLength = -1;
                  --cr.width;
                  if(cr.width == 0)
                  {
                     this.cellRegions.splice(crIndex,1);
                     continue;
                  }
               }
               crIndex++;
            }
         }
      }
      
      private function columnsCollectionRefresh(event:CollectionEvent) : void
      {
         this.columnsCollectionReset(event);
      }
      
      private function columnsCollectionReset(event:CollectionEvent) : void
      {
         if(!this.isCellSelectionMode())
         {
            return;
         }
         this.removeSelection();
         this.ensureRequiredSelection();
      }
   }
}

import flash.geom.Rectangle;

class CellRect extends Rectangle
{
   
   public var isAdd:Boolean = false;
   
   public function CellRect(rowIndex:int, columnIndex:int, rowCount:uint, columnCount:uint, isAdd:Boolean)
   {
      super(columnIndex,rowIndex,columnCount,rowCount);
      this.isAdd = isAdd;
   }
   
   public function containsCell(cellRowIndex:int, cellColumnIndex:int) : Boolean
   {
      return contains(cellColumnIndex,cellRowIndex);
   }
}
