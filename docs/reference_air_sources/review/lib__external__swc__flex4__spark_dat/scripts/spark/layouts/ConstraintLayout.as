package spark.layouts
{
   import flash.utils.Dictionary;
   import mx.containers.errors.ConstraintError;
   import mx.containers.utilityClasses.ConstraintColumn;
   import mx.containers.utilityClasses.ConstraintRow;
   import mx.containers.utilityClasses.Flex;
   import mx.core.ILayoutElement;
   import mx.resources.ResourceManager;
   import spark.components.supportClasses.GroupBase;
   import spark.layouts.supportClasses.LayoutBase;
   import spark.layouts.supportClasses.LayoutElementHelper;
   
   [ResourceBundle("layout")]
   public class ConstraintLayout extends LayoutBase
   {
      
      private var colSpanElements:Vector.<ElementConstraintInfo> = null;
      
      private var rowSpanElements:Vector.<ElementConstraintInfo> = null;
      
      private var otherElements:Vector.<ElementConstraintInfo> = null;
      
      private var rowBaselines:Vector.<Array> = null;
      
      private var rowMaxAscents:Vector.<Number> = null;
      
      private var constraintCache:Dictionary = null;
      
      private var _constraintColumns:Vector.<ConstraintColumn> = new Vector.<ConstraintColumn>(0,true);
      
      private var columnsObject:Object = new Object();
      
      private var _constraintRows:Vector.<ConstraintRow> = new Vector.<ConstraintRow>(0,true);
      
      private var rowsObject:Object = new Object();
      
      public function ConstraintLayout()
      {
         super();
      }
      
      private static function constraintsDetermineWidth(elementInfo:ElementConstraintInfo) : Boolean
      {
         return !isNaN(elementInfo.left) && !isNaN(elementInfo.right);
      }
      
      private static function constraintsDetermineHeight(elementInfo:ElementConstraintInfo) : Boolean
      {
         return !isNaN(elementInfo.top) && !isNaN(elementInfo.bottom);
      }
      
      private static function maxSizeToFitIn(totalSize:Number, lowConstraint:Number, highConstraint:Number, position:Number) : Number
      {
         if(!isNaN(lowConstraint))
         {
            return totalSize - lowConstraint;
         }
         if(!isNaN(highConstraint))
         {
            return totalSize - highConstraint;
         }
         return totalSize - position;
      }
      
      public function get constraintColumns() : Vector.<ConstraintColumn>
      {
         return this._constraintColumns.slice();
      }
      
      public function set constraintColumns(value:Vector.<ConstraintColumn>) : void
      {
         var col:ConstraintColumn = null;
         if(value == null)
         {
            this._constraintColumns = new Vector.<ConstraintColumn>(0,true);
            this.columnsObject = new Object();
            return;
         }
         var n:int = int(value.length);
         var temp:Vector.<ConstraintColumn> = value.slice();
         var obj:Object = new Object();
         for(var i:int = 0; i < n; i++)
         {
            col = temp[i];
            col.container = this.target;
            obj[col.id] = i;
         }
         this._constraintColumns = temp;
         this.columnsObject = obj;
         if(Boolean(target))
         {
            target.invalidateSize();
            target.invalidateDisplayList();
         }
      }
      
      public function get constraintRows() : Vector.<ConstraintRow>
      {
         return this._constraintRows.slice();
      }
      
      public function set constraintRows(value:Vector.<ConstraintRow>) : void
      {
         var row:ConstraintRow = null;
         var maxAscentStr:String = null;
         if(value == null)
         {
            this._constraintRows = new Vector.<ConstraintRow>(0,true);
            this.rowsObject = new Object();
            return;
         }
         var n:int = int(value.length);
         var temp:Vector.<ConstraintRow> = value.slice();
         var obj:Object = new Object();
         this.rowBaselines = new Vector.<Array>();
         for(var i:int = 0; i < n; i++)
         {
            row = temp[i];
            row.container = this.target;
            obj[row.id] = i;
            this.rowBaselines[i] = LayoutElementHelper.parseConstraintExp(row.baseline);
            maxAscentStr = this.rowBaselines[i][1];
            if(Boolean(maxAscentStr) && maxAscentStr != "maxAscent")
            {
               throw new Error(ResourceManager.getInstance().getString("layout","invalidBaselineOnRow",[row.id,row.baseline]));
            }
         }
         this._constraintRows = temp;
         this.rowsObject = obj;
         if(Boolean(target))
         {
            target.invalidateSize();
            target.invalidateDisplayList();
         }
      }
      
      override public function set target(value:GroupBase) : void
      {
         var i:int = 0;
         super.target = value;
         var n:int = int(this._constraintColumns.length);
         for(i = 0; i < n; i++)
         {
            this._constraintColumns[i].container = value;
         }
         n = int(this._constraintRows.length);
         for(i = 0; i < n; i++)
         {
            this._constraintRows[i].container = value;
         }
      }
      
      override public function measure() : void
      {
         var layoutTarget:GroupBase = null;
         var n:Number = NaN;
         var vec:Vector.<Number> = null;
         this.checkUseVirtualLayout();
         super.measure();
         layoutTarget = target;
         if(!layoutTarget)
         {
            return;
         }
         var width:Number = 0;
         var height:Number = 0;
         var minWidth:Number = 0;
         var minHeight:Number = 0;
         this.parseConstraints();
         var colWidths:Vector.<Number> = this.measureColumns();
         var rowHeights:Vector.<Number> = this.measureRows();
         for each(n in colWidths)
         {
            width += n;
         }
         for each(n in rowHeights)
         {
            height += n;
         }
         this.constrainPercentRegionSizes(colWidths,0,true);
         for each(n in colWidths)
         {
            minWidth += n;
         }
         this.constrainPercentRegionSizes(rowHeights,0,false);
         for each(n in rowHeights)
         {
            minHeight += n;
         }
         if(Boolean(this.otherElements))
         {
            vec = this.measureOtherContent();
            width = Math.max(width,vec[0]);
            height = Math.max(height,vec[1]);
            minWidth = Math.max(minWidth,vec[2]);
            minHeight = Math.max(minHeight,vec[3]);
         }
         layoutTarget.measuredWidth = Math.ceil(width);
         layoutTarget.measuredHeight = Math.ceil(height);
         layoutTarget.measuredMinWidth = Math.ceil(minWidth);
         layoutTarget.measuredMinHeight = Math.ceil(minHeight);
         this.clearConstraintCache();
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         this.checkUseVirtualLayout();
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var layoutTarget:GroupBase = target;
         if(!layoutTarget)
         {
            return;
         }
         this.measureAndPositionColumnsAndRows(unscaledWidth,unscaledHeight);
         this.layoutContent(unscaledWidth,unscaledHeight);
      }
      
      protected function layoutContent(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var layoutElement:ILayoutElement = null;
         var layoutTarget:GroupBase = target;
         if(!layoutTarget)
         {
            return;
         }
         var count:int = layoutTarget.numElements;
         var maxX:Number = 0;
         var maxY:Number = 0;
         for(var i:int = 0; i < count; i++)
         {
            layoutElement = layoutTarget.getElementAt(i);
            if(!(!layoutElement || !layoutElement.includeInLayout))
            {
               this.applyConstraintsToElement(unscaledWidth,unscaledHeight,layoutElement);
               maxX = Math.max(maxX,layoutElement.getLayoutBoundsX() + layoutElement.getLayoutBoundsWidth());
               maxY = Math.max(maxY,layoutElement.getLayoutBoundsY() + layoutElement.getLayoutBoundsHeight());
            }
         }
         layoutTarget.setContentSize(Math.ceil(maxX),Math.ceil(maxY));
         this.clearConstraintCache();
      }
      
      protected function measureAndPositionColumnsAndRows(constrainedWidth:Number = NaN, constrainedHeight:Number = NaN) : void
      {
         this.parseConstraints();
         this.setColumnWidths(this.measureColumns(constrainedWidth));
         this.setRowHeights(this.measureRows(constrainedHeight));
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function checkUseVirtualLayout() : void
      {
         if(useVirtualLayout)
         {
            throw new Error(ResourceManager.getInstance().getString("layout","constraintLayoutNotVirtualized"));
         }
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get virtualLayoutSupported() : Boolean
      {
         return false;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setColumnWidths(value:Vector.<Number>) : void
      {
         if(value == null)
         {
            return;
         }
         var constraintColumns:Vector.<ConstraintColumn> = this.constraintColumns;
         var numCols:int = int(constraintColumns.length);
         var totalWidth:Number = 0;
         for(var i:int = 0; i < numCols; i++)
         {
            constraintColumns[i].setActualWidth(value[i]);
            constraintColumns[i].x = totalWidth;
            totalWidth += value[i];
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setRowHeights(value:Vector.<Number>) : void
      {
         if(value == null)
         {
            return;
         }
         var constraintRows:Vector.<ConstraintRow> = this.constraintRows;
         var numRows:int = int(constraintRows.length);
         var totalHeight:Number = 0;
         for(var i:int = 0; i < numRows; i++)
         {
            constraintRows[i].setActualHeight(value[i]);
            constraintRows[i].y = totalHeight;
            totalHeight += value[i];
         }
      }
      
      private function applyConstraintsToElement(unscaledWidth:Number, unscaledHeight:Number, layoutElement:ILayoutElement) : void
      {
         var availableWidth:Number = NaN;
         var availableHeight:Number = NaN;
         var i:Number = NaN;
         var col:ConstraintColumn = null;
         var row:ConstraintRow = null;
         var baselineIndex:Number = NaN;
         var rowBaseline:Array = null;
         var elementInfo:ElementConstraintInfo = this.constraintCache[layoutElement];
         var left:Number = elementInfo.left;
         var right:Number = elementInfo.right;
         var top:Number = elementInfo.top;
         var bottom:Number = elementInfo.bottom;
         var baseline:Number = elementInfo.baseline;
         var leftBoundary:String = elementInfo.leftBoundary;
         var rightBoundary:String = elementInfo.rightBoundary;
         var topBoundary:String = elementInfo.topBoundary;
         var bottomBoundary:String = elementInfo.bottomBoundary;
         var baselineBoundary:String = elementInfo.baselineBoundary;
         var percentWidth:Number = Number(layoutElement.percentWidth);
         var percentHeight:Number = Number(layoutElement.percentHeight);
         var elementWidth:Number = NaN;
         var elementHeight:Number = NaN;
         var elementMaxWidth:Number = NaN;
         var elementMaxHeight:Number = NaN;
         var elementX:Number = 0;
         var elementY:Number = 0;
         var leftHolder:Number = 0;
         var rightHolder:Number = unscaledWidth;
         var topHolder:Number = 0;
         var bottomHolder:Number = unscaledHeight;
         var baselineHolder:Number = 0;
         if(Boolean(leftBoundary))
         {
            col = this._constraintColumns[elementInfo.colSpanLeftIndex];
            leftHolder = Number(col.x);
         }
         if(Boolean(rightBoundary))
         {
            col = this._constraintColumns[elementInfo.colSpanRightIndex];
            rightHolder = col.x + col.width;
         }
         if(Boolean(topBoundary))
         {
            row = this._constraintRows[elementInfo.rowSpanTopIndex];
            topHolder = Number(row.y);
         }
         if(Boolean(bottomBoundary))
         {
            row = this._constraintRows[elementInfo.rowSpanBottomIndex];
            bottomHolder = row.y + row.height;
         }
         if(Boolean(baselineBoundary))
         {
            baselineIndex = elementInfo.baselineIndex;
            rowBaseline = this.rowBaselines[baselineIndex];
            row = this._constraintRows[baselineIndex];
            baselineHolder = row.y + Number(rowBaseline[0]);
            if(Boolean(this.rowMaxAscents))
            {
               baselineHolder += this.rowMaxAscents[baselineIndex];
            }
            if(isNaN(bottom))
            {
               bottomHolder = row.y + row.height;
            }
         }
         availableWidth = Math.round(rightHolder - leftHolder);
         if(!isNaN(baseline) && (isNaN(top) || isNaN(bottom)))
         {
            availableHeight = Math.round(bottomHolder - baselineHolder);
         }
         else
         {
            availableHeight = Math.round(bottomHolder - topHolder);
         }
         if(!isNaN(percentWidth))
         {
            if(!isNaN(left))
            {
               availableWidth -= left;
            }
            if(!isNaN(right))
            {
               availableWidth -= right;
            }
            elementWidth = Math.round(availableWidth * Math.min(percentWidth * 0.01,1));
            elementMaxWidth = Math.min(layoutElement.getMaxBoundsWidth(),maxSizeToFitIn(unscaledWidth,left,right,layoutElement.getLayoutBoundsX()));
         }
         else if(!isNaN(left) && !isNaN(right))
         {
            elementWidth = availableWidth - left - right;
         }
         if(!isNaN(percentHeight))
         {
            if(!isNaN(top))
            {
               availableHeight -= top;
            }
            if(!isNaN(bottom))
            {
               availableHeight -= bottom;
            }
            elementHeight = Math.round(availableHeight * Math.min(percentHeight * 0.01,1));
            elementMaxHeight = Math.min(layoutElement.getMaxBoundsHeight(),maxSizeToFitIn(unscaledHeight,top,bottom,layoutElement.getLayoutBoundsY()));
         }
         else if(!isNaN(top) && !isNaN(bottom))
         {
            elementHeight = availableHeight - top - bottom;
         }
         if(!isNaN(elementWidth))
         {
            if(isNaN(elementMaxWidth))
            {
               elementMaxWidth = Number(layoutElement.getMaxBoundsWidth());
            }
            elementWidth = Math.max(layoutElement.getMinBoundsWidth(),Math.min(elementMaxWidth,elementWidth));
         }
         if(!isNaN(elementHeight))
         {
            if(isNaN(elementMaxHeight))
            {
               elementMaxHeight = Number(layoutElement.getMaxBoundsHeight());
            }
            elementHeight = Math.max(layoutElement.getMinBoundsHeight(),Math.min(elementMaxHeight,elementHeight));
         }
         layoutElement.setLayoutBoundsSize(elementWidth,elementHeight);
         elementWidth = Number(layoutElement.getLayoutBoundsWidth());
         elementHeight = Number(layoutElement.getLayoutBoundsHeight());
         if(!isNaN(left))
         {
            elementX = leftHolder + left;
         }
         else if(!isNaN(right))
         {
            elementX = rightHolder - right - elementWidth;
         }
         else
         {
            elementX = Number(layoutElement.getLayoutBoundsX());
         }
         if(!isNaN(baseline))
         {
            elementY = baselineHolder + baseline - layoutElement.baselinePosition;
         }
         else if(!isNaN(top))
         {
            elementY = topHolder + top;
         }
         else if(!isNaN(bottom))
         {
            elementY = bottomHolder - bottom - elementHeight;
         }
         else
         {
            elementY = Number(layoutElement.getLayoutBoundsY());
         }
         layoutElement.setLayoutBoundsPosition(elementX,elementY);
      }
      
      private function updateColumnWidthsForElement(colWidths:Vector.<Number>, elementInfo:ElementConstraintInfo) : void
      {
         var col:ConstraintColumn = null;
         var span:int = 0;
         var maxExtent:Number = NaN;
         var remainingWidth:Number = NaN;
         var j:int = 0;
         var isLeft:Boolean = false;
         var startIndex:int = 0;
         var endIndex:int = 0;
         var increment:int = 0;
         var contentCols:Vector.<ConstraintColumn> = null;
         var contentColsIndices:Vector.<int> = null;
         var numContentCols:Number = NaN;
         var splitWidth:Number = NaN;
         var layoutElement:ILayoutElement = elementInfo.layoutElement;
         var numCols:int = int(this._constraintColumns.length);
         var leftIndex:int = -1;
         var rightIndex:int = -1;
         var extX:Number = 0;
         var preferredWidth:Number = Number(layoutElement.getPreferredBoundsWidth());
         var colWidth:Number = 0;
         if(!isNaN(elementInfo.left))
         {
            extX += elementInfo.left;
            if(Boolean(elementInfo.leftBoundary))
            {
               leftIndex = elementInfo.colSpanLeftIndex;
            }
            else
            {
               leftIndex = 0;
            }
         }
         if(!isNaN(elementInfo.right))
         {
            extX += elementInfo.right;
            if(Boolean(elementInfo.rightBoundary))
            {
               rightIndex = elementInfo.colSpanRightIndex;
            }
            else
            {
               rightIndex = numCols - 1;
            }
         }
         maxExtent = extX + preferredWidth;
         remainingWidth = maxExtent;
         if(leftIndex < 0 || rightIndex < 0)
         {
            isLeft = leftIndex < 0;
            startIndex = isLeft ? rightIndex : leftIndex;
            endIndex = isLeft ? -1 : numCols;
            increment = isLeft ? -1 : 1;
            if(isLeft)
            {
               leftIndex = 0;
            }
            else
            {
               rightIndex = numCols - 1;
            }
            for(j = startIndex; j != endIndex; j += increment)
            {
               col = this._constraintColumns[j];
               if(!isNaN(col.explicitWidth))
               {
                  remainingWidth -= col.explicitWidth;
               }
               if(Boolean(col.contentSize) || !isNaN(col.percentWidth) || remainingWidth < 0)
               {
                  if(isLeft)
                  {
                     leftIndex = j;
                  }
                  else
                  {
                     rightIndex = j;
                  }
                  break;
               }
            }
         }
         span = rightIndex - leftIndex + 1;
         if(span == 1)
         {
            col = this._constraintColumns[leftIndex];
            if(Boolean(col.contentSize) || !isNaN(col.percentWidth))
            {
               colWidth = Math.max(colWidths[leftIndex],extX + preferredWidth);
               if(constraintsDetermineWidth(elementInfo))
               {
                  colWidth = Math.max(colWidth,extX + layoutElement.getMinBoundsWidth());
               }
               if(!isNaN(col.maxWidth))
               {
                  colWidth = Math.min(colWidth,col.maxWidth);
               }
               colWidths[leftIndex] = Math.ceil(colWidth);
            }
         }
         else
         {
            contentCols = new Vector.<ConstraintColumn>();
            contentColsIndices = new Vector.<int>();
            remainingWidth = maxExtent;
            for(j = leftIndex; j <= rightIndex; j++)
            {
               col = this._constraintColumns[j];
               if(!isNaN(col.explicitWidth))
               {
                  if(remainingWidth < col.width)
                  {
                     break;
                  }
                  remainingWidth -= col.width;
               }
               else if(Boolean(col.contentSize) || !isNaN(col.percentWidth))
               {
                  contentCols.push(col);
                  contentColsIndices.push(j);
               }
            }
            numContentCols = contentCols.length;
            if(numContentCols > 0)
            {
               splitWidth = remainingWidth / numContentCols;
               for(j = 0; j < numContentCols; j++)
               {
                  col = contentCols[j];
                  colWidth = Math.max(colWidths[contentColsIndices[j]],splitWidth);
                  if(!isNaN(col.maxWidth))
                  {
                     colWidth = Math.min(colWidth,col.maxWidth);
                  }
                  colWidths[contentColsIndices[j]] = Math.ceil(colWidth);
               }
            }
         }
      }
      
      private function constrainPercentRegionSizes(sizes:Vector.<Number>, constrainedSize:Number, isColumns:Boolean) : void
      {
         var col:ConstraintColumn = null;
         var row:ConstraintRow = null;
         var childInfo:ConstraintRegionFlexChildInfo = null;
         var percentSize:Number = NaN;
         var minSize:Number = NaN;
         var maxSize:Number = NaN;
         var roundOff:Number = NaN;
         var size:Number = NaN;
         var numSizes:int = isColumns ? int(this._constraintColumns.length) : int(this._constraintRows.length);
         var childInfoArray:Array = [];
         var remainingSpace:Number = constrainedSize;
         var percentMinSizes:Number = 0;
         var totalPercent:Number = 0;
         for(var i:int = 0; i < numSizes; i++)
         {
            if(isColumns)
            {
               col = this._constraintColumns[i];
               percentSize = Number(col.percentWidth);
               minSize = Number(col.minWidth);
               maxSize = Number(col.maxWidth);
            }
            else
            {
               row = this._constraintRows[i];
               percentSize = Number(row.percentHeight);
               minSize = Number(row.minHeight);
               maxSize = Number(row.maxHeight);
            }
            if(!isNaN(percentSize))
            {
               sizes[i] = !isNaN(minSize) ? Math.ceil(Math.max(minSize,0)) : 0;
               percentMinSizes += sizes[i];
               totalPercent += percentSize;
               childInfo = new ConstraintRegionFlexChildInfo();
               childInfo.index = i;
               childInfo.percent = percentSize;
               childInfo.min = minSize;
               childInfo.max = maxSize;
               childInfoArray.push(childInfo);
            }
            else
            {
               remainingSpace -= sizes[i];
            }
         }
         if(remainingSpace > percentMinSizes)
         {
            Flex.flexChildrenProportionally(constrainedSize,remainingSpace,totalPercent,childInfoArray);
            roundOff = 0;
            for each(childInfo in childInfoArray)
            {
               size = Math.round(childInfo.size + roundOff);
               roundOff += childInfo.size - size;
               sizes[childInfo.index] = size;
            }
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function measureColumns(constrainedWidth:Number = NaN) : Vector.<Number>
      {
         var i:Number = NaN;
         var col:ConstraintColumn = null;
         var w:Number = NaN;
         var elementInfo:ElementConstraintInfo = null;
         var clearCache:Boolean = false;
         if(!this.constraintCache)
         {
            this.parseConstraints();
            clearCache = true;
         }
         if(this._constraintColumns.length <= 0)
         {
            return new Vector.<Number>();
         }
         var measuredWidth:Number = 0;
         var numCols:Number = this._constraintColumns.length;
         var hasContentSize:Boolean = false;
         var hasPercentSize:Boolean = false;
         var colWidths:Vector.<Number> = new Vector.<Number>(numCols);
         for(i = 0; i < numCols; i++)
         {
            col = this._constraintColumns[i];
            if(Boolean(col.contentSize) || !isNaN(col.percentWidth))
            {
               hasContentSize ||= Boolean(col.contentSize);
               hasPercentSize ||= !isNaN(col.percentWidth);
               if(!isNaN(col.minWidth))
               {
                  colWidths[i] = Math.ceil(Math.max(col.minWidth,0));
               }
               else
               {
                  colWidths[i] = 0;
               }
            }
            else if(!isNaN(col.explicitWidth))
            {
               w = Number(col.explicitWidth);
               if(!isNaN(col.minWidth))
               {
                  w = Math.max(w,col.minWidth);
               }
               if(!isNaN(col.maxWidth))
               {
                  w = Math.min(w,col.maxWidth);
               }
               colWidths[i] = Math.ceil(w);
            }
         }
         if(Boolean(this.colSpanElements) && (hasContentSize || hasPercentSize))
         {
            for each(elementInfo in this.colSpanElements)
            {
               this.updateColumnWidthsForElement(colWidths,elementInfo);
            }
         }
         if(!isNaN(constrainedWidth) && hasPercentSize)
         {
            this.constrainPercentRegionSizes(colWidths,constrainedWidth,true);
         }
         if(clearCache)
         {
            this.clearConstraintCache();
         }
         return colWidths;
      }
      
      private function updateRowHeightsForElement(rowHeights:Vector.<Number>, elementInfo:ElementConstraintInfo) : void
      {
         var row:ConstraintRow = null;
         var span:int = 0;
         var maxExtent:Number = NaN;
         var remainingHeight:Number = NaN;
         var j:int = 0;
         var isTop:Boolean = false;
         var startIndex:int = 0;
         var endIndex:int = 0;
         var increment:int = 0;
         var contentRows:Vector.<ConstraintRow> = null;
         var contentRowsIndices:Vector.<int> = null;
         var numContentRows:Number = NaN;
         var splitHeight:Number = NaN;
         var layoutElement:ILayoutElement = elementInfo.layoutElement;
         var numRows:int = int(this._constraintRows.length);
         var topIndex:int = -1;
         var bottomIndex:int = -1;
         var extY:Number = 0;
         var preferredHeight:Number = Number(layoutElement.getPreferredBoundsHeight());
         var rowHeight:Number = 0;
         if(!isNaN(elementInfo.top))
         {
            extY += elementInfo.top;
            if(Boolean(elementInfo.topBoundary))
            {
               topIndex = elementInfo.rowSpanTopIndex;
            }
            else
            {
               topIndex = 0;
            }
         }
         if(!isNaN(elementInfo.bottom))
         {
            extY += elementInfo.bottom;
            if(Boolean(elementInfo.bottomBoundary))
            {
               bottomIndex = elementInfo.rowSpanBottomIndex;
            }
            else
            {
               bottomIndex = numRows - 1;
            }
         }
         if(!isNaN(elementInfo.baseline) && (topIndex < 0 || bottomIndex < 0))
         {
            extY += elementInfo.baseline - layoutElement.baselinePosition;
            if(!isNaN(elementInfo.top))
            {
               extY -= elementInfo.top;
            }
            if(Boolean(elementInfo.baselineBoundary))
            {
               topIndex = elementInfo.baselineIndex;
               extY += Number(this.rowBaselines[topIndex][0]);
               if(Boolean(this.rowMaxAscents))
               {
                  extY += this.rowMaxAscents[topIndex];
               }
            }
            else
            {
               topIndex = 0;
            }
         }
         maxExtent = extY + preferredHeight;
         remainingHeight = maxExtent;
         if(topIndex < 0 || bottomIndex < 0)
         {
            isTop = topIndex < 0;
            startIndex = isTop ? bottomIndex : topIndex;
            endIndex = isTop ? -1 : numRows;
            increment = isTop ? -1 : 1;
            if(isTop)
            {
               topIndex = 0;
            }
            else
            {
               bottomIndex = numRows - 1;
            }
            for(j = startIndex; j != endIndex; j += increment)
            {
               row = this._constraintRows[j];
               if(!isNaN(row.explicitHeight))
               {
                  remainingHeight -= row.explicitHeight;
               }
               if(Boolean(row.contentSize) || !isNaN(row.percentHeight) || remainingHeight < 0)
               {
                  if(isTop)
                  {
                     topIndex = j;
                  }
                  else
                  {
                     bottomIndex = j;
                  }
                  break;
               }
            }
         }
         span = bottomIndex - topIndex + 1;
         if(span == 1)
         {
            row = this._constraintRows[topIndex];
            if(Boolean(row.contentSize) || !isNaN(row.percentHeight))
            {
               rowHeight = Math.max(rowHeights[topIndex],extY + preferredHeight);
               if(constraintsDetermineHeight(elementInfo))
               {
                  rowHeight = Math.max(rowHeight,extY + layoutElement.getMinBoundsHeight());
               }
               if(!isNaN(row.maxHeight))
               {
                  rowHeight = Math.min(rowHeight,row.maxHeight);
               }
               rowHeights[topIndex] = Math.ceil(rowHeight);
            }
         }
         else
         {
            contentRows = new Vector.<ConstraintRow>();
            contentRowsIndices = new Vector.<int>();
            remainingHeight = maxExtent;
            for(j = topIndex; j <= bottomIndex; j++)
            {
               row = this._constraintRows[j];
               if(!isNaN(row.explicitHeight))
               {
                  if(remainingHeight < row.height)
                  {
                     break;
                  }
                  remainingHeight -= row.height;
               }
               else if(Boolean(row.contentSize) || !isNaN(row.percentHeight))
               {
                  contentRows.push(row);
                  contentRowsIndices.push(j);
               }
            }
            numContentRows = contentRows.length;
            if(numContentRows > 0)
            {
               splitHeight = remainingHeight / numContentRows;
               for(j = 0; j < numContentRows; j++)
               {
                  row = contentRows[j];
                  rowHeight = Math.max(rowHeights[contentRowsIndices[j]],splitHeight);
                  if(!isNaN(row.maxHeight))
                  {
                     rowHeight = Math.min(rowHeight,row.maxHeight);
                  }
                  rowHeights[contentRowsIndices[j]] = Math.ceil(rowHeight);
               }
            }
         }
      }
      
      private function measureRows(constrainedHeight:Number = NaN) : Vector.<Number>
      {
         var i:Number = NaN;
         var row:ConstraintRow = null;
         var h:Number = NaN;
         var elementInfo:ElementConstraintInfo = null;
         if(this._constraintRows.length <= 0)
         {
            return new Vector.<Number>();
         }
         var measuredHeight:Number = 0;
         var numRows:Number = this._constraintRows.length;
         var hasContentSize:Boolean = false;
         var hasPercentSize:Boolean = false;
         var rowHeights:Vector.<Number> = new Vector.<Number>(numRows);
         for(i = 0; i < numRows; i++)
         {
            row = this._constraintRows[i];
            if(Boolean(row.contentSize) || !isNaN(row.percentHeight))
            {
               hasContentSize ||= Boolean(row.contentSize);
               hasPercentSize ||= !isNaN(row.percentHeight);
               if(!isNaN(row.minHeight))
               {
                  rowHeights[i] = Math.ceil(Math.max(row.minHeight,0));
               }
               else
               {
                  rowHeights[i] = 0;
               }
            }
            else if(!isNaN(row.explicitHeight))
            {
               h = Number(row.explicitHeight);
               if(!isNaN(row.minHeight))
               {
                  h = Math.max(h,row.minHeight);
               }
               if(!isNaN(row.maxHeight))
               {
                  h = Math.min(h,row.maxHeight);
               }
               rowHeights[i] = Math.ceil(h);
            }
         }
         if(Boolean(this.rowSpanElements) && (hasContentSize || hasPercentSize))
         {
            for each(elementInfo in this.rowSpanElements)
            {
               this.updateRowHeightsForElement(rowHeights,elementInfo);
            }
         }
         if(!isNaN(constrainedHeight) && hasPercentSize)
         {
            this.constrainPercentRegionSizes(rowHeights,constrainedHeight,false);
         }
         return rowHeights;
      }
      
      private function measureOtherContent() : Vector.<Number>
      {
         var elementInfo:ElementConstraintInfo = null;
         var layoutElement:ILayoutElement = null;
         var noVerticalBoundaries:Boolean = false;
         var noBaselineBoundary:Boolean = false;
         var left:Number = NaN;
         var right:Number = NaN;
         var extX:Number = NaN;
         var preferredWidth:Number = NaN;
         var elementMinWidth:Number = NaN;
         var top:Number = NaN;
         var bottom:Number = NaN;
         var baseline:Number = NaN;
         var extY:Number = NaN;
         var preferredHeight:Number = NaN;
         var elementMinHeight:Number = NaN;
         var width:Number = 0;
         var height:Number = 0;
         var minWidth:Number = 0;
         var minHeight:Number = 0;
         var count:int = int(this.otherElements.length);
         for(var i:int = 0; i < count; i++)
         {
            elementInfo = this.otherElements[i];
            layoutElement = elementInfo.layoutElement;
            if(!elementInfo.leftBoundary && !elementInfo.rightBoundary)
            {
               left = elementInfo.left;
               right = elementInfo.right;
               if(!isNaN(left) && !isNaN(right))
               {
                  extX = left + right;
               }
               else if(!isNaN(left) || !isNaN(right))
               {
                  extX = isNaN(left) ? 0 : left;
                  extX += isNaN(right) ? 0 : right;
               }
               else
               {
                  extX = Number(layoutElement.getBoundsXAtSize(NaN,NaN));
               }
               preferredWidth = Number(layoutElement.getPreferredBoundsWidth());
               width = Math.max(width,extX + preferredWidth);
               elementMinWidth = constraintsDetermineWidth(elementInfo) ? Number(layoutElement.getMinBoundsWidth()) : preferredWidth;
               minWidth = Math.max(minWidth,extX + elementMinWidth);
            }
            noVerticalBoundaries = !elementInfo.topBoundary && !elementInfo.bottomBoundary;
            noBaselineBoundary = !elementInfo.baselineBoundary;
            if(noVerticalBoundaries || noBaselineBoundary)
            {
               if(noVerticalBoundaries)
               {
                  top = elementInfo.top;
                  bottom = elementInfo.bottom;
               }
               if(noBaselineBoundary)
               {
                  baseline = elementInfo.baseline;
               }
               if(!isNaN(top) && !isNaN(bottom))
               {
                  extY = top + bottom;
               }
               else if(!isNaN(baseline))
               {
                  extY = Math.round(baseline - layoutElement.baselinePosition);
               }
               else if(!isNaN(top) || !isNaN(bottom))
               {
                  extY = isNaN(top) ? 0 : top;
                  extY += isNaN(bottom) ? 0 : bottom;
               }
               else
               {
                  extY = Number(layoutElement.getBoundsYAtSize(NaN,NaN));
               }
               preferredHeight = Number(layoutElement.getPreferredBoundsHeight());
               height = Math.max(height,extY + preferredHeight);
               elementMinHeight = constraintsDetermineHeight(elementInfo) ? Number(layoutElement.getMinBoundsHeight()) : preferredHeight;
               minHeight = Math.max(minHeight,extY + elementMinHeight);
            }
         }
         var vec:Vector.<Number> = new Vector.<Number>(4,true);
         vec[0] = Math.max(width,minWidth);
         vec[1] = Math.max(height,minHeight);
         vec[2] = minWidth;
         vec[3] = minHeight;
         return vec;
      }
      
      private function parseConstraints() : void
      {
         var layoutElement:ILayoutElement = null;
         var i:int = 0;
         var row:ConstraintRow = null;
         var maxAscentStr:String = null;
         var layoutTarget:GroupBase = target;
         if(!layoutTarget)
         {
            return;
         }
         var count:Number = layoutTarget.numElements;
         var cache:Dictionary = new Dictionary(true);
         var n:int = int(this._constraintRows.length);
         var obj:Object = new Object();
         if(this.rowBaselines == null)
         {
            this.rowBaselines = new Vector.<Array>();
         }
         else
         {
            this.rowBaselines.length = 0;
         }
         for(i = 0; i < n; i++)
         {
            row = this._constraintRows[i];
            this.rowBaselines[i] = LayoutElementHelper.parseConstraintExp(row.baseline);
            maxAscentStr = this.rowBaselines[i][1];
            if(Boolean(maxAscentStr) && maxAscentStr != "maxAscent")
            {
               throw new Error(ResourceManager.getInstance().getString("layout","invalidBaselineOnRow",[row.id,row.baseline]));
            }
         }
         for(i = 0; i < count; i++)
         {
            layoutElement = layoutTarget.getElementAt(i);
            if(!(!layoutElement || !layoutElement.includeInLayout))
            {
               this.parseElementConstraints(layoutElement,cache);
            }
         }
         this.constraintCache = cache;
      }
      
      private function parseElementConstraints(layoutElement:ILayoutElement, constraintCache:Dictionary) : void
      {
         var left:Number = NaN;
         var right:Number = NaN;
         var top:Number = NaN;
         var bottom:Number = NaN;
         var baseline:Number = NaN;
         var leftBoundary:String = null;
         var rightBoundary:String = null;
         var topBoundary:String = null;
         var bottomBoundary:String = null;
         var baselineBoundary:String = null;
         var message:String = null;
         var temp:Array = null;
         var i:Number = NaN;
         var numColumns:Number = NaN;
         var colIndex:Object = null;
         var rowIndex:Object = null;
         var bIndex:int = 0;
         var numRows:Number = NaN;
         temp = LayoutElementHelper.parseConstraintExp(layoutElement.left);
         left = Number(temp[0]);
         leftBoundary = temp[1];
         temp = LayoutElementHelper.parseConstraintExp(layoutElement.right);
         right = Number(temp[0]);
         rightBoundary = temp[1];
         temp = LayoutElementHelper.parseConstraintExp(layoutElement.top);
         top = Number(temp[0]);
         topBoundary = temp[1];
         temp = LayoutElementHelper.parseConstraintExp(layoutElement.bottom);
         bottom = Number(temp[0]);
         bottomBoundary = temp[1];
         temp = LayoutElementHelper.parseConstraintExp(layoutElement.baseline);
         baseline = Number(temp[0]);
         baselineBoundary = temp[1];
         var elementInfo:ElementConstraintInfo = new ElementConstraintInfo(layoutElement,left,right,top,bottom,baseline,leftBoundary,rightBoundary,topBoundary,bottomBoundary,baselineBoundary);
         constraintCache[layoutElement] = elementInfo;
         if(!leftBoundary && !rightBoundary || !topBoundary && !bottomBoundary || !baselineBoundary)
         {
            if(!this.otherElements)
            {
               this.otherElements = new Vector.<ElementConstraintInfo>();
            }
            this.otherElements.push(elementInfo);
         }
         if(Boolean(leftBoundary) || Boolean(rightBoundary))
         {
            numColumns = this._constraintColumns.length;
            if(!this.colSpanElements)
            {
               this.colSpanElements = new Vector.<ElementConstraintInfo>();
            }
            this.colSpanElements.push(elementInfo);
            if(Boolean(leftBoundary))
            {
               colIndex = this.columnsObject[leftBoundary];
               if(colIndex != null)
               {
                  elementInfo.colSpanLeftIndex = int(colIndex);
               }
               if(elementInfo.colSpanLeftIndex < 0)
               {
                  message = ResourceManager.getInstance().getString("layout","columnNotFound",[leftBoundary]);
                  throw new ConstraintError(message);
               }
            }
            if(Boolean(rightBoundary))
            {
               colIndex = this.columnsObject[rightBoundary];
               if(colIndex != null)
               {
                  elementInfo.colSpanRightIndex = int(colIndex);
               }
               if(elementInfo.colSpanRightIndex < 0)
               {
                  message = ResourceManager.getInstance().getString("layout","columnNotFound",[rightBoundary]);
                  throw new ConstraintError(message);
               }
            }
         }
         if(Boolean(topBoundary) || Boolean(bottomBoundary) || Boolean(baselineBoundary))
         {
            if(!this.rowSpanElements)
            {
               this.rowSpanElements = new Vector.<ElementConstraintInfo>();
            }
            this.rowSpanElements.push(elementInfo);
            if(Boolean(topBoundary))
            {
               rowIndex = this.rowsObject[topBoundary];
               if(rowIndex != null)
               {
                  elementInfo.rowSpanTopIndex = int(rowIndex);
               }
               if(elementInfo.rowSpanTopIndex < 0)
               {
                  message = ResourceManager.getInstance().getString("layout","rowNotFound",[topBoundary]);
                  throw new ConstraintError(message);
               }
            }
            if(Boolean(bottomBoundary))
            {
               rowIndex = this.rowsObject[bottomBoundary];
               if(rowIndex != null)
               {
                  elementInfo.rowSpanBottomIndex = int(rowIndex);
               }
               if(elementInfo.rowSpanBottomIndex < 0)
               {
                  message = ResourceManager.getInstance().getString("layout","rowNotFound",[bottomBoundary]);
                  throw new ConstraintError(message);
               }
            }
            if(Boolean(baselineBoundary))
            {
               rowIndex = this.rowsObject[baselineBoundary];
               if(rowIndex != null)
               {
                  elementInfo.baselineIndex = int(rowIndex);
               }
               if(elementInfo.baselineIndex < 0)
               {
                  message = ResourceManager.getInstance().getString("layout","rowNotFound",[baselineBoundary]);
                  throw new ConstraintError(message);
               }
               bIndex = elementInfo.baselineIndex;
               numRows = this._constraintRows.length;
               if(Boolean(this.rowBaselines[bIndex][1]))
               {
                  if(!this.rowMaxAscents)
                  {
                     this.rowMaxAscents = new Vector.<Number>(numRows,true);
                  }
                  this.rowMaxAscents[bIndex] = Math.max(this.rowMaxAscents[bIndex],layoutElement.baselinePosition);
               }
            }
         }
      }
      
      private function clearConstraintCache() : void
      {
         this.colSpanElements = null;
         this.rowSpanElements = null;
         this.otherElements = null;
         this.rowBaselines = null;
         this.rowMaxAscents = null;
         this.constraintCache = null;
      }
   }
}

import mx.containers.utilityClasses.FlexChildInfo;
import mx.core.ILayoutElement;

class ElementConstraintInfo
{
   
   public var layoutElement:ILayoutElement;
   
   public var left:Number;
   
   public var right:Number;
   
   public var top:Number;
   
   public var bottom:Number;
   
   public var baseline:Number;
   
   public var leftBoundary:String;
   
   public var rightBoundary:String;
   
   public var topBoundary:String;
   
   public var bottomBoundary:String;
   
   public var baselineBoundary:String;
   
   public var colSpanLeftIndex:int;
   
   public var colSpanRightIndex:int;
   
   public var rowSpanTopIndex:int;
   
   public var rowSpanBottomIndex:int;
   
   public var baselineIndex:int;
   
   public function ElementConstraintInfo(layoutElement:ILayoutElement, left:Number, right:Number, top:Number, bottom:Number, baseline:Number, leftBoundary:String = null, rightBoundary:String = null, topBoundary:String = null, bottomBoundary:String = null, baselineBoundary:String = null, colSpanLeftIndex:int = -1, colSpanRightIndex:int = -1, rowSpanTopIndex:int = -1, rowSpanBottomIndex:int = -1, baselineIndex:int = -1)
   {
      super();
      this.layoutElement = layoutElement;
      this.left = left;
      this.right = right;
      this.top = top;
      this.bottom = bottom;
      this.baseline = baseline;
      this.leftBoundary = leftBoundary;
      this.rightBoundary = rightBoundary;
      this.topBoundary = topBoundary;
      this.bottomBoundary = bottomBoundary;
      this.baselineBoundary = baselineBoundary;
      this.colSpanLeftIndex = colSpanLeftIndex;
      this.colSpanRightIndex = colSpanRightIndex;
      this.rowSpanTopIndex = rowSpanTopIndex;
      this.rowSpanBottomIndex = rowSpanBottomIndex;
      this.baselineIndex = baselineIndex;
   }
}

class ConstraintRegionFlexChildInfo extends FlexChildInfo
{
   
   public var index:int;
   
   public function ConstraintRegionFlexChildInfo()
   {
      super();
   }
}
