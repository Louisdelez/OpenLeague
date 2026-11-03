package mx.containers
{
   import mx.containers.gridClasses.GridColumnInfo;
   import mx.containers.gridClasses.GridRowInfo;
   import mx.core.EdgeMetrics;
   
   [IconFile("Grid.png")]
   [Exclude(name="focusOutEffect",kind="effect")]
   [Exclude(name="focusInEffect",kind="effect")]
   [Exclude(name="focusThickness",kind="style")]
   [Exclude(name="focusSkin",kind="style")]
   [Exclude(name="focusBlendMode",kind="style")]
   [Exclude(name="focusOut",kind="event")]
   [Exclude(name="focusIn",kind="event")]
   [Exclude(name="direction",kind="property")]
   [Style(name="verticalGap",type="Number",format="Length",inherit="no")]
   [Style(name="horizontalGap",type="Number",format="Length",inherit="no")]
   public class Grid extends Box
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var columnWidths:Array;
      
      private var rowHeights:Array;
      
      private var needToRemeasure:Boolean = true;
      
      public function Grid()
      {
         super();
      }
      
      override public function invalidateSize() : void
      {
         if(!isNaN(explicitWidth) && !isNaN(explicitHeight))
         {
            this.needToRemeasure = true;
         }
         super.invalidateSize();
      }
      
      override protected function measure() : void
      {
         var gridRow:GridRow = null;
         var gridItem:GridItem = null;
         var i:int = 0;
         var j:int = 0;
         var colIndex:int = 0;
         var curSpan:int = 0;
         var preferredHeight:Number = NaN;
         var row:GridRow = null;
         var rowVm:EdgeMetrics = null;
         var occupied:int = 0;
         var lastRowOccupied:int = 0;
         var k:int = 0;
         var rowSpan:int = 0;
         var colSpan:int = 0;
         var rowInfo:GridRowInfo = null;
         var columnInfo:GridColumnInfo = null;
         var rowPadding:Number = NaN;
         var numGridRows:int = 0;
         var numGridColumns:int = 0;
         var columnOccupiedUntilRow:Array = [];
         var rowList:Array = [];
         for(var index:int = 0; index < numChildren; index++)
         {
            gridRow = GridRow(getChildAt(index));
            if(gridRow.includeInLayout)
            {
               rowList.push(gridRow);
               numGridRows++;
            }
         }
         for(i = 0; i < numGridRows; i++)
         {
            colIndex = 0;
            gridRow = rowList[i];
            gridRow.numGridItems = gridRow.numChildren;
            gridRow.rowIndex = i;
            for(j = 0; j < gridRow.numGridItems; j++)
            {
               if(i > 0)
               {
                  occupied = int(columnOccupiedUntilRow[colIndex]);
                  while(!isNaN(occupied) && occupied >= i)
                  {
                     colIndex++;
                     occupied = int(columnOccupiedUntilRow[colIndex]);
                  }
               }
               gridItem = GridItem(gridRow.getChildAt(j));
               gridItem.colIndex = colIndex;
               if(gridItem.rowSpan > 1)
               {
                  lastRowOccupied = i + gridItem.rowSpan - 1;
                  for(k = 0; k < gridItem.colSpan; k++)
                  {
                     columnOccupiedUntilRow[colIndex + k] = lastRowOccupied;
                  }
               }
               colIndex += gridItem.colSpan;
            }
            if(colIndex > numGridColumns)
            {
               numGridColumns = colIndex;
            }
         }
         this.rowHeights = new Array(numGridRows);
         this.columnWidths = new Array(numGridColumns);
         for(i = 0; i < numGridRows; i++)
         {
            this.rowHeights[i] = new GridRowInfo();
         }
         for(i = 0; i < numGridColumns; i++)
         {
            this.columnWidths[i] = new GridColumnInfo();
         }
         var BIG_INT:int = int.MAX_VALUE;
         var nextSpan:int = 1;
         var horizontalGap:Number = Number(getStyle("horizontalGap"));
         var verticalGap:Number = Number(getStyle("verticalGap"));
         do
         {
            curSpan = nextSpan;
            nextSpan = BIG_INT;
            for(i = 0; i < numGridRows; i++)
            {
               gridRow = rowList[i];
               gridRow.columnWidths = this.columnWidths;
               gridRow.rowHeights = this.rowHeights;
               for(j = 0; j < gridRow.numGridItems; j++)
               {
                  gridItem = GridItem(gridRow.getChildAt(j));
                  rowSpan = gridItem.rowSpan;
                  colSpan = gridItem.colSpan;
                  if(rowSpan == curSpan)
                  {
                     this.distributeItemHeight(gridItem,i,verticalGap,this.rowHeights);
                  }
                  else if(rowSpan > curSpan && rowSpan < nextSpan)
                  {
                     nextSpan = rowSpan;
                  }
                  if(colSpan == curSpan)
                  {
                     this.distributeItemWidth(gridItem,gridItem.colIndex,horizontalGap,this.columnWidths);
                  }
                  else if(colSpan > curSpan && colSpan < nextSpan)
                  {
                     nextSpan = colSpan;
                  }
               }
            }
         }
         while(nextSpan < BIG_INT);
         var minWidth:Number = 0;
         var minHeight:Number = 0;
         var preferredWidth:Number = 0;
         preferredHeight = 0;
         for(i = 0; i < numGridRows; i++)
         {
            rowInfo = this.rowHeights[i];
            if(rowInfo.min > rowInfo.preferred)
            {
               rowInfo.min = rowInfo.preferred;
            }
            if(rowInfo.max < rowInfo.preferred)
            {
               rowInfo.max = rowInfo.preferred;
            }
            minHeight += rowInfo.min;
            preferredHeight += rowInfo.preferred;
         }
         for(i = 0; i < numGridColumns; i++)
         {
            columnInfo = this.columnWidths[i];
            if(columnInfo.min > columnInfo.preferred)
            {
               columnInfo.min = columnInfo.preferred;
            }
            if(columnInfo.max < columnInfo.preferred)
            {
               columnInfo.max = columnInfo.preferred;
            }
            minWidth += columnInfo.min;
            preferredWidth += columnInfo.preferred;
         }
         var vm:EdgeMetrics = viewMetricsAndPadding;
         var padding:Number = vm.left + vm.right;
         var maxRowPadding:Number = 0;
         if(numGridColumns > 1)
         {
            padding += getStyle("horizontalGap") * (numGridColumns - 1);
         }
         for(i = 0; i < numGridRows; i++)
         {
            row = rowList[i];
            rowVm = row.viewMetricsAndPadding;
            rowPadding = rowVm.left + rowVm.right;
            if(rowPadding > maxRowPadding)
            {
               maxRowPadding = rowPadding;
            }
         }
         padding += maxRowPadding;
         minWidth += padding;
         preferredWidth += padding;
         padding = vm.top + vm.bottom;
         if(numGridRows > 1)
         {
            padding += getStyle("verticalGap") * (numGridRows - 1);
         }
         for(i = 0; i < numGridRows; i++)
         {
            row = rowList[i];
            rowVm = row.viewMetricsAndPadding;
            padding += rowVm.top + rowVm.bottom;
         }
         minHeight += padding;
         preferredHeight += padding;
         for(i = 0; i < numGridRows; i++)
         {
            row = rowList[i];
            row.updateRowMeasurements();
         }
         super.measure();
         measuredMinWidth = Math.max(measuredMinWidth,minWidth);
         measuredMinHeight = Math.max(measuredMinHeight,minHeight);
         measuredWidth = Math.max(measuredWidth,preferredWidth);
         measuredHeight = Math.max(measuredHeight,preferredHeight);
         this.needToRemeasure = false;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var i:int = 0;
         var child:GridRow = null;
         if(this.needToRemeasure)
         {
            this.measure();
         }
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var n:int = 0;
         var rowList:Array = [];
         for(var index:int = 0; index < numChildren; index++)
         {
            child = GridRow(getChildAt(index));
            if(child.includeInLayout)
            {
               rowList.push(child);
               n++;
            }
         }
         for(i = 0; i < n; i++)
         {
            child = rowList[i];
            this.rowHeights[i].y = child.y;
            this.rowHeights[i].height = child.height;
         }
         for(i = 0; i < n; i++)
         {
            child = rowList[i];
            child.doRowLayout(child.width * child.scaleX,child.height * child.scaleY);
         }
      }
      
      private function distributeItemHeight(item:GridItem, rowIndex:Number, verticalGap:Number, rowHeights:Array) : void
      {
         var i:int = 0;
         var rowInfo:GridRowInfo = null;
         var gap:Number = NaN;
         var flex:Number = NaN;
         var maxHeight:Number = Number(item.maxHeight);
         var preferredHeightToDistribute:Number = Number(item.getExplicitOrMeasuredHeight());
         var minHeightToDistribute:Number = Number(item.minHeight);
         var rowSpan:int = item.rowSpan;
         var totalFlex:Number = 0;
         var divideEqually:Boolean = false;
         for(i = rowIndex; i < rowIndex + rowSpan; i++)
         {
            rowInfo = rowHeights[i];
            preferredHeightToDistribute -= rowInfo.preferred;
            minHeightToDistribute -= rowInfo.min;
            totalFlex += rowInfo.flex;
         }
         if(rowSpan > 1)
         {
            gap = verticalGap * (rowSpan - 1);
            preferredHeightToDistribute -= gap;
            minHeightToDistribute -= gap;
         }
         if(totalFlex == 0)
         {
            totalFlex = rowSpan;
            divideEqually = true;
         }
         preferredHeightToDistribute = preferredHeightToDistribute > 0 ? Math.ceil(preferredHeightToDistribute / totalFlex) : 0;
         minHeightToDistribute = minHeightToDistribute > 0 ? Math.ceil(minHeightToDistribute / totalFlex) : 0;
         for(i = rowIndex; i < rowIndex + rowSpan; i++)
         {
            rowInfo = rowHeights[i];
            flex = divideEqually ? 1 : rowInfo.flex;
            rowInfo.preferred += preferredHeightToDistribute * flex;
            rowInfo.min += minHeightToDistribute * flex;
         }
         if(rowSpan == 1 && maxHeight < rowInfo.max)
         {
            rowInfo.max = maxHeight;
         }
      }
      
      private function distributeItemWidth(item:GridItem, colIndex:int, horizontalGap:Number, columnWidths:Array) : void
      {
         var i:int = 0;
         var columnInfo:GridColumnInfo = null;
         var gap:Number = NaN;
         var flex:Number = NaN;
         var maxWidth:Number = Number(item.maxWidth);
         var preferredWidthToDistribute:Number = Number(item.getExplicitOrMeasuredWidth());
         var minWidthToDistribute:Number = Number(item.minWidth);
         var colSpan:int = item.colSpan;
         var percentWidth:Number = Number(item.percentWidth);
         var totalFlex:Number = 0;
         var divideEqually:Boolean = false;
         for(i = colIndex; i < colIndex + colSpan; i++)
         {
            columnInfo = columnWidths[i];
            preferredWidthToDistribute -= columnInfo.preferred;
            minWidthToDistribute -= columnInfo.min;
            totalFlex += columnInfo.flex;
         }
         if(colSpan > 1)
         {
            gap = horizontalGap * (colSpan - 1);
            preferredWidthToDistribute -= gap;
            minWidthToDistribute -= gap;
         }
         if(totalFlex == 0)
         {
            totalFlex = colSpan;
            divideEqually = true;
         }
         preferredWidthToDistribute = preferredWidthToDistribute > 0 ? Math.ceil(preferredWidthToDistribute / totalFlex) : 0;
         minWidthToDistribute = minWidthToDistribute > 0 ? Math.ceil(minWidthToDistribute / totalFlex) : 0;
         for(i = colIndex; i < colIndex + colSpan; i++)
         {
            columnInfo = columnWidths[i];
            flex = divideEqually ? 1 : Number(columnInfo.flex);
            columnInfo.preferred += preferredWidthToDistribute * flex;
            columnInfo.min += minWidthToDistribute * flex;
            if(Boolean(percentWidth))
            {
               columnInfo.percent = Math.max(columnInfo.percent,percentWidth / colSpan);
            }
         }
         if(colSpan == 1 && maxWidth < columnInfo.max)
         {
            columnInfo.max = maxWidth;
         }
      }
   }
}

