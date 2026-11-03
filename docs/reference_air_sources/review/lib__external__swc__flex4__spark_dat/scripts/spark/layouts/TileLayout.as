package spark.layouts
{
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.core.ILayoutElement;
   import mx.core.IVisualElement;
   import mx.events.PropertyChangeEvent;
   import spark.components.supportClasses.GroupBase;
   import spark.core.NavigationUnit;
   import spark.layouts.supportClasses.DropLocation;
   import spark.layouts.supportClasses.LayoutBase;
   
   public class TileLayout extends LayoutBase
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var explicitHorizontalGap:Number = 6;
      
      private var _horizontalGap:Number = 6;
      
      private var explicitVerticalGap:Number = 6;
      
      private var _verticalGap:Number = 6;
      
      private var _columnCount:int = -1;
      
      private var _requestedColumnCount:int = -1;
      
      private var _rowCount:int = -1;
      
      private var _requestedRowCount:int = -1;
      
      private var explicitColumnWidth:Number = NaN;
      
      private var _columnWidth:Number = NaN;
      
      private var explicitRowHeight:Number = NaN;
      
      private var _rowHeight:Number = NaN;
      
      private var _paddingLeft:Number = 0;
      
      private var _paddingRight:Number = 0;
      
      private var _paddingTop:Number = 0;
      
      private var _paddingBottom:Number = 0;
      
      private var _horizontalAlign:String = "justify";
      
      private var _verticalAlign:String = "justify";
      
      private var _columnAlign:String = "left";
      
      private var _rowAlign:String = "top";
      
      private var _orientation:String = "rows";
      
      private var oldColumnWidth:Number = NaN;
      
      private var oldRowHeight:Number = NaN;
      
      private var oldColumnCount:int = -1;
      
      private var oldRowCount:int = -1;
      
      private var oldHorizontalGap:Number = NaN;
      
      private var oldVerticalGap:Number = NaN;
      
      private var _tileWidthCached:Number = NaN;
      
      private var _tileHeightCached:Number = NaN;
      
      private var _numElementsCached:int = -1;
      
      private var visibleStartIndex:int = -1;
      
      private var visibleEndIndex:int = -1;
      
      private var visibleStartX:Number = 0;
      
      private var visibleStartY:Number = 0;
      
      public function TileLayout()
      {
         super();
      }
      
      [Inspectable(category="General")]
      [Bindable("propertyChange")]
      public function get horizontalGap() : Number
      {
         return this._horizontalGap;
      }
      
      public function set horizontalGap(value:Number) : void
      {
         this.explicitHorizontalGap = value;
         if(value == this._horizontalGap)
         {
            return;
         }
         this._horizontalGap = value;
         this.invalidateTargetSizeAndDisplayList();
      }
      
      [Inspectable(category="General")]
      [Bindable("propertyChange")]
      public function get verticalGap() : Number
      {
         return this._verticalGap;
      }
      
      public function set verticalGap(value:Number) : void
      {
         this.explicitVerticalGap = value;
         if(value == this._verticalGap)
         {
            return;
         }
         this._verticalGap = value;
         this.invalidateTargetSizeAndDisplayList();
      }
      
      [Inspectable(category="General")]
      [Bindable("propertyChange")]
      public function get columnCount() : int
      {
         return this._columnCount;
      }
      
      [Inspectable(category="General",minValue="-1")]
      public function get requestedColumnCount() : int
      {
         return this._requestedColumnCount;
      }
      
      public function set requestedColumnCount(value:int) : void
      {
         if(this._requestedColumnCount == value)
         {
            return;
         }
         this._requestedColumnCount = value;
         this._columnCount = value;
         this.invalidateTargetSizeAndDisplayList();
      }
      
      [Inspectable(category="General")]
      [Bindable("propertyChange")]
      public function get rowCount() : int
      {
         return this._rowCount;
      }
      
      [Inspectable(category="General",minValue="-1")]
      public function get requestedRowCount() : int
      {
         return this._requestedRowCount;
      }
      
      public function set requestedRowCount(value:int) : void
      {
         if(this._requestedRowCount == value)
         {
            return;
         }
         this._requestedRowCount = value;
         this._rowCount = value;
         this.invalidateTargetSizeAndDisplayList();
      }
      
      [Inspectable(category="General",minValue="0.0")]
      [Bindable("propertyChange")]
      public function get columnWidth() : Number
      {
         return this._columnWidth;
      }
      
      public function set columnWidth(value:Number) : void
      {
         this.explicitColumnWidth = value;
         if(value == this._columnWidth)
         {
            return;
         }
         this._columnWidth = value;
         this.invalidateTargetSizeAndDisplayList();
      }
      
      [Inspectable(category="General",minValue="0.0")]
      [Bindable("propertyChange")]
      public function get rowHeight() : Number
      {
         return this._rowHeight;
      }
      
      public function set rowHeight(value:Number) : void
      {
         this.explicitRowHeight = value;
         if(value == this._rowHeight)
         {
            return;
         }
         this._rowHeight = value;
         this.invalidateTargetSizeAndDisplayList();
      }
      
      [Inspectable(category="General")]
      public function get paddingLeft() : Number
      {
         return this._paddingLeft;
      }
      
      public function set paddingLeft(value:Number) : void
      {
         if(this._paddingLeft == value)
         {
            return;
         }
         this._paddingLeft = value;
         this.invalidateTargetSizeAndDisplayList();
      }
      
      [Inspectable(category="General")]
      public function get paddingRight() : Number
      {
         return this._paddingRight;
      }
      
      public function set paddingRight(value:Number) : void
      {
         if(this._paddingRight == value)
         {
            return;
         }
         this._paddingRight = value;
         this.invalidateTargetSizeAndDisplayList();
      }
      
      [Inspectable(category="General")]
      public function get paddingTop() : Number
      {
         return this._paddingTop;
      }
      
      public function set paddingTop(value:Number) : void
      {
         if(this._paddingTop == value)
         {
            return;
         }
         this._paddingTop = value;
         this.invalidateTargetSizeAndDisplayList();
      }
      
      [Inspectable(category="General")]
      public function get paddingBottom() : Number
      {
         return this._paddingBottom;
      }
      
      public function set paddingBottom(value:Number) : void
      {
         if(this._paddingBottom == value)
         {
            return;
         }
         this._paddingBottom = value;
         this.invalidateTargetSizeAndDisplayList();
      }
      
      [Inspectable(category="General",enumeration="left,right,center,justify",defaultValue="justify")]
      public function get horizontalAlign() : String
      {
         return this._horizontalAlign;
      }
      
      public function set horizontalAlign(value:String) : void
      {
         if(this._horizontalAlign == value)
         {
            return;
         }
         this._horizontalAlign = value;
         this.invalidateTargetSizeAndDisplayList();
      }
      
      [Inspectable(category="General",enumeration="top,bottom,middle,justify",defaultValue="justify")]
      public function get verticalAlign() : String
      {
         return this._verticalAlign;
      }
      
      public function set verticalAlign(value:String) : void
      {
         if(this._verticalAlign == value)
         {
            return;
         }
         this._verticalAlign = value;
         this.invalidateTargetSizeAndDisplayList();
      }
      
      [Inspectable(category="General",enumeration="left,justifyUsingGap,justifyUsingWidth",defaultValue="left")]
      public function get columnAlign() : String
      {
         return this._columnAlign;
      }
      
      public function set columnAlign(value:String) : void
      {
         if(this._columnAlign == value)
         {
            return;
         }
         this._columnAlign = value;
         this.invalidateTargetSizeAndDisplayList();
      }
      
      [Inspectable(category="General",enumeration="top,justifyUsingGap,justifyUsingHeight",defaultValue="top")]
      public function get rowAlign() : String
      {
         return this._rowAlign;
      }
      
      public function set rowAlign(value:String) : void
      {
         if(this._rowAlign == value)
         {
            return;
         }
         this._rowAlign = value;
         this.invalidateTargetSizeAndDisplayList();
      }
      
      [Inspectable(category="General",enumeration="rows,columns",defaultValue="rows")]
      public function get orientation() : String
      {
         return this._orientation;
      }
      
      public function set orientation(value:String) : void
      {
         if(this._orientation == value)
         {
            return;
         }
         this._orientation = value;
         this._tileWidthCached = this._tileHeightCached = NaN;
         this.invalidateTargetSizeAndDisplayList();
      }
      
      override public function set useVirtualLayout(value:Boolean) : void
      {
         if(useVirtualLayout == value)
         {
            return;
         }
         super.useVirtualLayout = value;
         if(value)
         {
            this.visibleStartIndex = -1;
            this.visibleEndIndex = -1;
            this.visibleStartX = 0;
            this.visibleStartY = 0;
         }
      }
      
      override public function clearVirtualLayoutCache() : void
      {
         this._tileWidthCached = this._tileHeightCached = NaN;
      }
      
      private function dispatchEventsForActualValueChanges() : void
      {
         if(hasEventListener(PropertyChangeEvent.PROPERTY_CHANGE))
         {
            if(this.oldColumnWidth != this._columnWidth)
            {
               dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"columnWidth",this.oldColumnWidth,this._columnWidth));
            }
            if(this.oldRowHeight != this._rowHeight)
            {
               dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rowHeight",this.oldRowHeight,this._rowHeight));
            }
            if(this.oldColumnCount != this._columnCount)
            {
               dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"columnCount",this.oldColumnCount,this._columnCount));
            }
            if(this.oldRowCount != this._rowCount)
            {
               dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rowCount",this.oldRowCount,this._rowCount));
            }
            if(this.oldHorizontalGap != this._horizontalGap)
            {
               dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"horizontalGap",this.oldHorizontalGap,this._horizontalGap));
            }
            if(this.oldVerticalGap != this._verticalGap)
            {
               dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"verticalGap",this.oldVerticalGap,this._verticalGap));
            }
         }
         this.oldColumnWidth = this._columnWidth;
         this.oldRowHeight = this._rowHeight;
         this.oldColumnCount = this._columnCount;
         this.oldRowCount = this._rowCount;
         this.oldHorizontalGap = this._horizontalGap;
         this.oldVerticalGap = this._verticalGap;
      }
      
      private function updateActualValues(width:Number, height:Number) : void
      {
         var widthMinusPadding:Number = width - this.paddingLeft - this.paddingRight;
         var heightMinusPadding:Number = height - this.paddingTop - this.paddingBottom;
         this.calculateTileSize();
         var elementCount:int = this.calculateElementCount();
         this.calculateColumnAndRowCount(widthMinusPadding,heightMinusPadding,elementCount);
         this._horizontalGap = this.explicitHorizontalGap;
         this._verticalGap = this.explicitVerticalGap;
         if(!isNaN(width))
         {
            switch(this.columnAlign)
            {
               case ColumnAlign.JUSTIFY_USING_GAP:
                  this._horizontalGap = this.justifyByGapSize(widthMinusPadding,this._columnWidth,this._horizontalGap,this._columnCount);
                  break;
               case ColumnAlign.JUSTIFY_USING_WIDTH:
                  this._columnWidth = this.justifyByElementSize(widthMinusPadding,this._columnWidth,this._horizontalGap,this._columnCount);
            }
         }
         if(!isNaN(height))
         {
            switch(this.rowAlign)
            {
               case RowAlign.JUSTIFY_USING_GAP:
                  this._verticalGap = this.justifyByGapSize(heightMinusPadding,this._rowHeight,this._verticalGap,this._rowCount);
                  break;
               case RowAlign.JUSTIFY_USING_HEIGHT:
                  this._rowHeight = this.justifyByElementSize(heightMinusPadding,this._rowHeight,this._verticalGap,this._rowCount);
            }
         }
         if(-1 != this._requestedColumnCount && -1 != this._requestedRowCount)
         {
            if(this.orientation == TileOrientation.ROWS)
            {
               this._rowCount = Math.max(1,Math.ceil(elementCount / Math.max(1,this._requestedColumnCount)));
            }
            else
            {
               this._columnCount = Math.max(1,Math.ceil(elementCount / Math.max(1,this._requestedRowCount)));
            }
         }
      }
      
      private function closerToSquare(colCount1:int, rowCount1:int, colCount2:int, rowCount2:int) : Boolean
      {
         var difference1:Number = Math.abs(colCount1 * (this._columnWidth + this._horizontalGap) - this._horizontalGap - rowCount1 * (this._rowHeight + this._verticalGap) + this._verticalGap);
         var difference2:Number = Math.abs(colCount2 * (this._columnWidth + this._horizontalGap) - this._horizontalGap - rowCount2 * (this._rowHeight + this._verticalGap) + this._verticalGap);
         return difference1 < difference2 || difference1 == difference2 && rowCount1 <= rowCount2;
      }
      
      private function calculateColumnAndRowCount(width:Number, height:Number, elementCount:int) : void
      {
         var hGap:Number = NaN;
         var vGap:Number = NaN;
         var a:Number = NaN;
         var b:Number = NaN;
         var c:Number = NaN;
         var d:Number = NaN;
         var rowCount:Number = NaN;
         var row1:int = 0;
         var col1:int = 0;
         var row2:int = 0;
         var col2:int = 0;
         var col3:int = 0;
         var row3:int = 0;
         var col4:int = 0;
         var row4:int = 0;
         this._columnCount = this._rowCount = -1;
         if(-1 != this._requestedColumnCount || -1 != this._requestedRowCount)
         {
            if(-1 != this._requestedRowCount)
            {
               this._rowCount = Math.max(1,this._requestedRowCount);
            }
            if(-1 != this._requestedColumnCount)
            {
               this._columnCount = Math.max(1,this._requestedColumnCount);
            }
         }
         else if(!isNaN(width) && (this.orientation == TileOrientation.ROWS || isNaN(height)))
         {
            if(this._columnWidth + this.explicitHorizontalGap > 0)
            {
               this._columnCount = Math.max(1,Math.floor((width + this.explicitHorizontalGap) / (this._columnWidth + this.explicitHorizontalGap)));
            }
            else
            {
               this._columnCount = 1;
            }
         }
         else if(!isNaN(height) && (this.orientation == TileOrientation.COLUMNS || isNaN(width)))
         {
            if(this._rowHeight + this.explicitVerticalGap > 0)
            {
               this._rowCount = Math.max(1,Math.floor((height + this.explicitVerticalGap) / (this._rowHeight + this.explicitVerticalGap)));
            }
            else
            {
               this._rowCount = 1;
            }
         }
         else
         {
            hGap = this.explicitHorizontalGap;
            vGap = this.explicitVerticalGap;
            a = Math.max(0,this.rowHeight + vGap);
            b = hGap - vGap;
            c = -elementCount * (this._columnWidth + hGap);
            d = b * b - 4 * a * c;
            d = Math.sqrt(d);
            rowCount = a != 0 ? (b + d) / (2 * a) : elementCount;
            row1 = Math.max(1,Math.floor(rowCount));
            col1 = Math.max(1,Math.ceil(elementCount / row1));
            row1 = Math.max(1,Math.ceil(elementCount / col1));
            row2 = Math.max(1,Math.ceil(rowCount));
            col2 = Math.max(1,Math.ceil(elementCount / row2));
            row2 = Math.max(1,Math.ceil(elementCount / col2));
            col3 = Math.max(1,Math.floor(elementCount / rowCount));
            row3 = Math.max(1,Math.ceil(elementCount / col3));
            col3 = Math.max(1,Math.ceil(elementCount / row3));
            col4 = Math.max(1,Math.ceil(elementCount / rowCount));
            row4 = Math.max(1,Math.ceil(elementCount / col4));
            col4 = Math.max(1,Math.ceil(elementCount / row4));
            if(this.closerToSquare(col3,row3,col1,row1))
            {
               col1 = col3;
               row1 = row3;
            }
            if(this.closerToSquare(col4,row4,col2,row2))
            {
               col2 = col4;
               row2 = row4;
            }
            if(this.closerToSquare(col1,row1,col2,row2))
            {
               this._columnCount = col1;
               this._rowCount = row1;
            }
            else
            {
               this._columnCount = col2;
               this._rowCount = row2;
            }
         }
         if(-1 == this._rowCount)
         {
            this._rowCount = Math.max(1,Math.ceil(elementCount / this._columnCount));
         }
         if(-1 == this._columnCount)
         {
            this._columnCount = Math.max(1,Math.ceil(elementCount / this._rowCount));
         }
      }
      
      private function justifyByGapSize(totalSize:Number, elementSize:Number, gap:Number, elementCount:int) : Number
      {
         if(elementSize + gap <= 0)
         {
            return gap;
         }
         var visibleCount:int = Math.min(elementCount,Math.floor((totalSize + gap) / (elementSize + gap)));
         if(visibleCount < 1)
         {
            return gap;
         }
         if(visibleCount == 1)
         {
            return elementCount > 1 ? Math.max(gap,totalSize - elementSize) : gap;
         }
         return (totalSize - visibleCount * elementSize) / (visibleCount - 1);
      }
      
      private function justifyByElementSize(totalSize:Number, elementSize:Number, gap:Number, elementCount:int) : Number
      {
         var elementAndGapSize:Number = elementSize + gap;
         var visibleCount:int = 0;
         if(elementAndGapSize == 0)
         {
            visibleCount = elementCount;
         }
         else
         {
            visibleCount = Math.min(elementCount,Math.floor((totalSize + gap) / elementAndGapSize));
         }
         if(visibleCount < 1)
         {
            return elementSize;
         }
         return (totalSize - (visibleCount - 1) * gap) / visibleCount;
      }
      
      private function updateVirtualTileSize(elt:ILayoutElement) : void
      {
         if(!elt || !elt.includeInLayout)
         {
            return;
         }
         var w:Number = Number(elt.getPreferredBoundsWidth());
         var h:Number = Number(elt.getPreferredBoundsHeight());
         this._tileWidthCached = isNaN(this._tileWidthCached) ? w : Math.max(w,this._tileWidthCached);
         this._tileHeightCached = isNaN(this._tileHeightCached) ? h : Math.max(h,this._tileHeightCached);
      }
      
      private function calculateVirtualTileSize() : void
      {
         var index:int = 0;
         this._columnWidth = this.explicitColumnWidth;
         this._rowHeight = this.explicitRowHeight;
         if(!isNaN(this._columnWidth) && !isNaN(this._rowHeight))
         {
            this._tileWidthCached = this._columnWidth;
            this._tileHeightCached = this._rowHeight;
            return;
         }
         this.updateVirtualTileSize(typicalLayoutElement);
         if(this.visibleStartIndex != -1 && this.visibleEndIndex != -1)
         {
            for(index = this.visibleStartIndex; index <= this.visibleEndIndex; index++)
            {
               this.updateVirtualTileSize(target.getVirtualElementAt(index));
            }
         }
         if(isNaN(this._tileWidthCached))
         {
            this._tileWidthCached = 0;
         }
         if(isNaN(this._tileHeightCached))
         {
            this._tileHeightCached = 0;
         }
         if(isNaN(this._columnWidth))
         {
            this._columnWidth = this._tileWidthCached;
         }
         if(isNaN(this._rowHeight))
         {
            this._rowHeight = this._tileHeightCached;
         }
      }
      
      private function calculateRealTileSize() : void
      {
         var el:ILayoutElement = null;
         this._columnWidth = this._tileWidthCached;
         this._rowHeight = this._tileHeightCached;
         if(!isNaN(this._columnWidth) && !isNaN(this._rowHeight))
         {
            return;
         }
         this._columnWidth = this._tileWidthCached = this.explicitColumnWidth;
         this._rowHeight = this._tileHeightCached = this.explicitRowHeight;
         if(!isNaN(this._columnWidth) && !isNaN(this._rowHeight))
         {
            return;
         }
         var columnWidth:Number = 0;
         var rowHeight:Number = 0;
         var layoutTarget:GroupBase = target;
         var count:int = layoutTarget.numElements;
         this._numElementsCached = count;
         for(var i:int = 0; i < count; i++)
         {
            el = layoutTarget.getElementAt(i);
            if(!el || !el.includeInLayout)
            {
               --this._numElementsCached;
            }
            else
            {
               if(isNaN(this._columnWidth))
               {
                  columnWidth = Math.max(columnWidth,el.getPreferredBoundsWidth());
               }
               if(isNaN(this._rowHeight))
               {
                  rowHeight = Math.max(rowHeight,el.getPreferredBoundsHeight());
               }
            }
         }
         if(isNaN(this._columnWidth))
         {
            this._columnWidth = this._tileWidthCached = columnWidth;
         }
         if(isNaN(this._rowHeight))
         {
            this._rowHeight = this._tileHeightCached = rowHeight;
         }
      }
      
      private function calculateTileSize() : void
      {
         if(useVirtualLayout)
         {
            this.calculateVirtualTileSize();
         }
         else
         {
            this.calculateRealTileSize();
         }
      }
      
      private function calculateElementCount() : int
      {
         var el:ILayoutElement = null;
         if(-1 != this._numElementsCached)
         {
            return this._numElementsCached;
         }
         var layoutTarget:GroupBase = target;
         var count:int = layoutTarget.numElements;
         this._numElementsCached = count;
         if(useVirtualLayout)
         {
            return this._numElementsCached;
         }
         for(var i:int = 0; i < count; i++)
         {
            el = layoutTarget.getElementAt(i);
            if(!el || !el.includeInLayout)
            {
               --this._numElementsCached;
            }
         }
         return this._numElementsCached;
      }
      
      private function calculateDisplayParameters(unscaledWidth:int, unscaledHeight:int) : void
      {
         var hsp:Number = NaN;
         var vsp:Number = NaN;
         var cwg:Number = NaN;
         var rwg:Number = NaN;
         var visibleCol0:int = 0;
         var visibleRow0:int = 0;
         var visibleCol1:int = 0;
         var visibleRow1:int = 0;
         this.updateActualValues(unscaledWidth,unscaledHeight);
         var layoutTarget:GroupBase = target;
         var eltCount:int = layoutTarget.numElements;
         this.visibleStartX = this.paddingLeft;
         this.visibleStartY = this.paddingTop;
         this.visibleStartIndex = 0;
         this.visibleEndIndex = eltCount - 1;
         if(useVirtualLayout)
         {
            hsp = layoutTarget.horizontalScrollPosition - this.paddingLeft;
            vsp = layoutTarget.verticalScrollPosition - this.paddingTop;
            cwg = this._columnWidth + this._horizontalGap;
            rwg = this._rowHeight + this._verticalGap;
            visibleCol0 = Math.max(0,Math.floor(hsp / cwg));
            visibleRow0 = Math.max(0,Math.floor(vsp / rwg));
            visibleCol1 = Math.min(this._columnCount - 1,Math.floor((hsp + unscaledWidth) / cwg));
            visibleRow1 = Math.min(this._rowCount - 1,Math.floor((vsp + unscaledHeight) / rwg));
            if(this.orientation == TileOrientation.ROWS)
            {
               this.visibleStartIndex = visibleRow0 * this._columnCount;
               this.visibleEndIndex = Math.min(eltCount - 1,visibleRow1 * this._columnCount + visibleCol1);
               this.visibleStartY = visibleRow0 * rwg + this.paddingTop;
            }
            else
            {
               this.visibleStartIndex = visibleCol0 * this._rowCount;
               this.visibleEndIndex = Math.min(eltCount - 1,visibleCol1 * this._rowCount + visibleRow1);
               this.visibleStartX = visibleCol0 * cwg + this.paddingLeft;
            }
         }
      }
      
      private function updateVirtualLayout(unscaledWidth:int, unscaledHeight:int) : void
      {
         var el:ILayoutElement = null;
         var oldVisibleStartIndex:int = this.visibleStartIndex;
         var oldVisibleEndIndex:int = this.visibleEndIndex;
         this.calculateDisplayParameters(unscaledWidth,unscaledHeight);
         var layoutTarget:GroupBase = target;
         for(var i:int = oldVisibleStartIndex; i <= oldVisibleEndIndex; i++)
         {
            if(i >= this.visibleStartIndex && i <= this.visibleEndIndex)
            {
               i = this.visibleEndIndex;
            }
            else
            {
               el = layoutTarget.getElementAt(i);
               if(el)
               {
                  if(el is IVisualElement)
                  {
                     IVisualElement(el).visible = false;
                  }
               }
            }
         }
      }
      
      private function sizeAndPositionElement(element:ILayoutElement, cellX:int, cellY:int, cellWidth:int, cellHeight:int) : void
      {
         var childWidth:Number = NaN;
         var childHeight:Number = NaN;
         if(this.horizontalAlign == "justify")
         {
            childWidth = cellWidth;
         }
         else if(!isNaN(element.percentWidth))
         {
            childWidth = Math.round(cellWidth * element.percentWidth * 0.01);
         }
         else
         {
            childWidth = Number(element.getPreferredBoundsWidth());
         }
         if(this.verticalAlign == "justify")
         {
            childHeight = cellHeight;
         }
         else if(!isNaN(element.percentHeight))
         {
            childHeight = Math.round(cellHeight * element.percentHeight * 0.01);
         }
         else
         {
            childHeight = Number(element.getPreferredBoundsHeight());
         }
         var maxChildWidth:Number = Math.min(element.getMaxBoundsWidth(),cellWidth);
         var maxChildHeight:Number = Math.min(element.getMaxBoundsHeight(),cellHeight);
         childWidth = Math.max(element.getMinBoundsWidth(),Math.min(maxChildWidth,childWidth));
         childHeight = Math.max(element.getMinBoundsHeight(),Math.min(maxChildHeight,childHeight));
         element.setLayoutBoundsSize(childWidth,childHeight);
         var x:Number = cellX;
         switch(this.horizontalAlign)
         {
            case "right":
               x += cellWidth - element.getLayoutBoundsWidth();
               break;
            case "center":
               x = cellX + Math.floor((cellWidth - element.getLayoutBoundsWidth()) / 2);
         }
         var y:Number = cellY;
         switch(this.verticalAlign)
         {
            case "bottom":
               y += cellHeight - element.getLayoutBoundsHeight();
               break;
            case "middle":
               y += Math.floor((cellHeight - element.getLayoutBoundsHeight()) / 2);
         }
         element.setLayoutBoundsPosition(x,y);
      }
      
      final private function leftEdge(columnIndex:int) : Number
      {
         if(columnIndex < 0)
         {
            return 0;
         }
         return Math.max(0,columnIndex * (this._columnWidth + this._horizontalGap)) + this.paddingLeft;
      }
      
      final private function rightEdge(columnIndex:int) : Number
      {
         if(columnIndex < 0)
         {
            return 0;
         }
         return Math.min(target.contentWidth,columnIndex * (this._columnWidth + this._horizontalGap) + this._columnWidth) + this.paddingLeft;
      }
      
      final private function topEdge(rowIndex:int) : Number
      {
         if(rowIndex < 0)
         {
            return 0;
         }
         return Math.max(0,rowIndex * (this._rowHeight + this._verticalGap)) + this.paddingTop;
      }
      
      final private function bottomEdge(rowIndex:int) : Number
      {
         if(rowIndex < 0)
         {
            return 0;
         }
         return Math.min(target.contentHeight,rowIndex * (this._rowHeight + this._verticalGap) + this._rowHeight) + this.paddingTop;
      }
      
      private function invalidateTargetSizeAndDisplayList() : void
      {
         var g:GroupBase = target;
         if(!g)
         {
            return;
         }
         g.invalidateSize();
         g.invalidateDisplayList();
      }
      
      override protected function scrollPositionChanged() : void
      {
         super.scrollPositionChanged();
         var layoutTarget:GroupBase = target;
         if(!layoutTarget)
         {
            return;
         }
         if(useVirtualLayout)
         {
            layoutTarget.invalidateDisplayList();
         }
      }
      
      override public function measure() : void
      {
         var savedVerticalGap:int = 0;
         var savedColumnWidth:int = 0;
         var savedColumnCount:int = this._columnCount;
         var savedRowCount:int = this._rowCount;
         var savedHorizontalGap:int = this._horizontalGap;
         savedVerticalGap = this._verticalGap;
         savedColumnWidth = this._columnWidth;
         var savedRowHeight:int = this._rowHeight;
         var layoutTarget:GroupBase = target;
         if(!layoutTarget)
         {
            return;
         }
         this.updateActualValues(layoutTarget.explicitWidth,layoutTarget.explicitHeight);
         var columnCount:int = this._requestedColumnCount != -1 ? int(Math.max(1,this._requestedColumnCount)) : this._columnCount;
         var rowCount:int = this._requestedRowCount != -1 ? int(Math.max(1,this._requestedRowCount)) : this._rowCount;
         var measuredWidth:Number = 0;
         var measuredMinWidth:Number = 0;
         var measuredHeight:Number = 0;
         var measuredMinHeight:Number = 0;
         if(columnCount > 0)
         {
            measuredWidth = Math.ceil(columnCount * (this._columnWidth + this._horizontalGap) - this._horizontalGap);
            measuredMinWidth = Math.ceil(this._columnCount * (this._columnWidth + this._horizontalGap) - this._horizontalGap);
         }
         if(rowCount > 0)
         {
            measuredHeight = Math.ceil(rowCount * (this._rowHeight + this._verticalGap) - this._verticalGap);
            measuredMinHeight = Math.ceil(this._rowCount * (this._rowHeight + this._verticalGap) - this._verticalGap);
         }
         this._numElementsCached = -1;
         var hPadding:Number = this.paddingLeft + this.paddingRight;
         var vPadding:Number = this.paddingTop + this.paddingBottom;
         layoutTarget.measuredWidth = measuredWidth + hPadding;
         layoutTarget.measuredMinWidth = measuredMinWidth + hPadding;
         layoutTarget.measuredHeight = measuredHeight + vPadding;
         layoutTarget.measuredMinHeight = measuredMinHeight + vPadding;
         this._columnCount = savedColumnCount;
         this._rowCount = savedRowCount;
         this._horizontalGap = savedHorizontalGap;
         this._verticalGap = savedVerticalGap;
         this._columnWidth = savedColumnWidth;
         this._rowHeight = savedRowHeight;
      }
      
      override public function getNavigationDestinationIndex(currentIndex:int, navigationUnit:uint, arrowKeysWrapFocus:Boolean) : int
      {
         var currentRow:int = 0;
         var currentColumn:int = 0;
         var scrollRect:Rectangle = null;
         var firstVisibleRow:int = 0;
         var lastVisibleRow:int = 0;
         var firstVisibleColumn:int = 0;
         var lastVisibleColumn:int = 0;
         if(!target || target.numElements < 1)
         {
            return -1;
         }
         var maxIndex:int = target.numElements - 1;
         if(currentIndex == -1)
         {
            if(navigationUnit == NavigationUnit.UP || navigationUnit == NavigationUnit.LEFT)
            {
               return arrowKeysWrapFocus ? maxIndex : -1;
            }
            if(navigationUnit == NavigationUnit.DOWN || navigationUnit == NavigationUnit.RIGHT)
            {
               return 0;
            }
         }
         var inRows:Boolean = this.orientation == TileOrientation.ROWS;
         currentIndex = Math.max(0,Math.min(maxIndex,currentIndex));
         if(inRows)
         {
            if(this.columnCount == 0 || this.rowHeight + this.verticalGap == 0)
            {
               return currentIndex;
            }
            currentRow = currentIndex / this.columnCount;
            currentColumn = currentIndex - currentRow * this.columnCount;
         }
         else
         {
            if(this.rowCount == 0 || this.columnWidth + this.horizontalGap == 0)
            {
               return currentIndex;
            }
            currentColumn = currentIndex / this.rowCount;
            currentRow = currentIndex - currentColumn * this.rowCount;
         }
         var newRow:int = currentRow;
         var newColumn:int = currentColumn;
         switch(navigationUnit)
         {
            case NavigationUnit.LEFT:
               if(newColumn == 0 && inRows && newRow > 0)
               {
                  newRow--;
                  newColumn = this.columnCount - 1;
               }
               else if(arrowKeysWrapFocus && newColumn == 0 && inRows && newRow == 0)
               {
                  newRow = this.rowCount - 1;
                  newColumn = this.columnCount - 1;
               }
               else
               {
                  newColumn--;
               }
               break;
            case NavigationUnit.RIGHT:
               if(newColumn == this.columnCount - 1 && inRows && newRow < this.rowCount - 1)
               {
                  newColumn = 0;
                  newRow++;
               }
               else if(arrowKeysWrapFocus && newColumn == this.columnCount - 1 && inRows && newRow == this.rowCount - 1)
               {
                  newColumn = 0;
                  newRow = 0;
               }
               else
               {
                  newColumn++;
               }
               break;
            case NavigationUnit.UP:
               if(newRow == 0 && !inRows && newColumn > 0)
               {
                  newColumn--;
                  newRow = this.rowCount - 1;
               }
               else if(arrowKeysWrapFocus && newRow == 0 && !inRows && newColumn == 0)
               {
                  newColumn = this.columnCount - 1;
                  newRow = this.rowCount - 1;
               }
               else
               {
                  newRow--;
               }
               break;
            case NavigationUnit.DOWN:
               if(newRow == this.rowCount - 1 && !inRows && newColumn < this.columnCount - 1)
               {
                  newColumn++;
                  newRow = 0;
               }
               else if(arrowKeysWrapFocus && newRow == this.rowCount - 1 && !inRows && newColumn == this.columnCount - 1)
               {
                  newColumn = 0;
                  newRow = 0;
               }
               else
               {
                  newRow++;
               }
               break;
            case NavigationUnit.PAGE_UP:
            case NavigationUnit.PAGE_DOWN:
               scrollRect = getScrollRect();
               if(!scrollRect)
               {
                  scrollRect = new Rectangle(0,0,target.contentWidth,target.contentHeight);
               }
               if(inRows)
               {
                  firstVisibleRow = Math.ceil(scrollRect.top / (this.rowHeight + this.verticalGap));
                  lastVisibleRow = Math.floor(scrollRect.bottom / (this.rowHeight + this.verticalGap));
                  if(navigationUnit == NavigationUnit.PAGE_UP)
                  {
                     if(firstVisibleRow < currentRow && currentRow <= lastVisibleRow)
                     {
                        newRow = firstVisibleRow;
                     }
                     else
                     {
                        newRow = 2 * firstVisibleRow - lastVisibleRow;
                     }
                  }
                  else if(firstVisibleRow <= currentRow && currentRow < lastVisibleRow)
                  {
                     newRow = lastVisibleRow;
                  }
                  else
                  {
                     newRow = 2 * lastVisibleRow - firstVisibleRow;
                  }
               }
               else
               {
                  firstVisibleColumn = Math.ceil(scrollRect.left / (this.columnWidth + this.horizontalGap));
                  lastVisibleColumn = Math.floor(scrollRect.right / (this.columnWidth + this.horizontalGap));
                  if(navigationUnit == NavigationUnit.PAGE_UP)
                  {
                     if(firstVisibleColumn < currentColumn && currentColumn <= lastVisibleColumn)
                     {
                        newColumn = firstVisibleColumn;
                     }
                     else
                     {
                        newColumn = 2 * firstVisibleColumn - lastVisibleColumn;
                     }
                  }
                  else if(firstVisibleColumn <= currentColumn && currentColumn < lastVisibleColumn)
                  {
                     newColumn = lastVisibleColumn;
                  }
                  else
                  {
                     newColumn = 2 * lastVisibleColumn - firstVisibleColumn;
                  }
               }
               break;
            default:
               return super.getNavigationDestinationIndex(currentIndex,navigationUnit,arrowKeysWrapFocus);
         }
         newRow = Math.max(0,Math.min(this.rowCount - 1,newRow));
         newColumn = Math.max(0,Math.min(this.columnCount - 1,newColumn));
         if(inRows)
         {
            if(newRow == this.rowCount - 1)
            {
               if(currentIndex == maxIndex && newColumn > currentColumn)
               {
                  newColumn = currentColumn;
               }
               if(newColumn > maxIndex - this.columnCount * (this.rowCount - 1))
               {
                  newRow--;
               }
            }
            return newRow * this.columnCount + newColumn;
         }
         if(newColumn == this.columnCount - 1)
         {
            if(currentIndex == maxIndex && newRow > currentRow)
            {
               newRow = currentRow;
            }
            if(newRow > maxIndex - this.rowCount * (this.columnCount - 1))
            {
               newColumn--;
            }
         }
         return newColumn * this.rowCount + newRow;
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var xMajorDelta:Number = NaN;
         var yMajorDelta:Number = NaN;
         var xMinorDelta:Number = NaN;
         var yMinorDelta:Number = NaN;
         var counterLimit:int = 0;
         var el:ILayoutElement = null;
         var cellX:int = 0;
         var cellY:int = 0;
         var cellWidth:int = 0;
         var cellHeight:int = 0;
         var layoutTarget:GroupBase = target;
         if(!layoutTarget)
         {
            return;
         }
         this.calculateDisplayParameters(unscaledWidth,unscaledHeight);
         if(useVirtualLayout)
         {
            this.updateVirtualLayout(unscaledWidth,unscaledHeight);
         }
         var xPos:Number = this.visibleStartX;
         var yPos:Number = this.visibleStartY;
         var counter:int = 0;
         if(this.orientation == TileOrientation.ROWS)
         {
            counterLimit = this._columnCount;
            xMajorDelta = this._columnWidth + this._horizontalGap;
            xMinorDelta = 0;
            yMajorDelta = 0;
            yMinorDelta = this._rowHeight + this._verticalGap;
         }
         else
         {
            counterLimit = this._rowCount;
            xMajorDelta = 0;
            xMinorDelta = this._columnWidth + this._horizontalGap;
            yMajorDelta = this._rowHeight + this._verticalGap;
            yMinorDelta = 0;
         }
         for(var index:int = this.visibleStartIndex; index <= this.visibleEndIndex; index++)
         {
            el = null;
            if(useVirtualLayout)
            {
               el = layoutTarget.getVirtualElementAt(index);
               if(el is IVisualElement)
               {
                  IVisualElement(el).visible = true;
               }
            }
            else
            {
               el = layoutTarget.getElementAt(index);
            }
            if(!(!el || !el.includeInLayout))
            {
               cellX = Math.round(xPos);
               cellY = Math.round(yPos);
               cellWidth = Math.round(xPos + this._columnWidth) - cellX;
               cellHeight = Math.round(yPos + this._rowHeight) - cellY;
               this.sizeAndPositionElement(el,cellX,cellY,cellWidth,cellHeight);
               xPos += xMajorDelta;
               yPos += yMajorDelta;
               if(++counter >= counterLimit)
               {
                  counter = 0;
                  if(this.orientation == TileOrientation.ROWS)
                  {
                     xPos = this.paddingLeft;
                     yPos += yMinorDelta;
                  }
                  else
                  {
                     xPos += xMinorDelta;
                     yPos = this.paddingTop;
                  }
               }
            }
         }
         var hPadding:Number = this.paddingLeft + this.paddingRight;
         var vPadding:Number = this.paddingTop + this.paddingBottom;
         layoutTarget.setContentSize(Math.ceil(this._columnCount * (this._columnWidth + this._horizontalGap) - this._horizontalGap) + hPadding,Math.ceil(this._rowCount * (this._rowHeight + this._verticalGap) - this._verticalGap) + vPadding);
         if(!useVirtualLayout)
         {
            this._tileWidthCached = this._tileHeightCached = NaN;
         }
         this._numElementsCached = -1;
         if(useVirtualLayout)
         {
            this.visibleStartIndex = this.visibleEndIndex = -1;
         }
         this.dispatchEventsForActualValueChanges();
      }
      
      override public function getElementBounds(index:int) : Rectangle
      {
         var col:int = 0;
         var row:int = 0;
         if(!useVirtualLayout)
         {
            return super.getElementBounds(index);
         }
         var g:GroupBase = GroupBase(target);
         if(!g || index < 0 || index >= g.numElements)
         {
            return null;
         }
         if(this.orientation == TileOrientation.ROWS)
         {
            col = index % this._columnCount;
            row = index / this._columnCount;
         }
         else
         {
            col = index / this._rowCount;
            row = index % this._rowCount;
         }
         return new Rectangle(this.leftEdge(col),this.topEdge(row),this._columnWidth,this._rowHeight);
      }
      
      override protected function getElementBoundsLeftOfScrollRect(scrollRect:Rectangle) : Rectangle
      {
         var bounds:Rectangle = new Rectangle();
         var column:int = Math.floor((scrollRect.left - 1 - this.paddingLeft) / (this._columnWidth + this._horizontalGap));
         bounds.left = this.leftEdge(column);
         bounds.right = this.rightEdge(column);
         return bounds;
      }
      
      override protected function getElementBoundsRightOfScrollRect(scrollRect:Rectangle) : Rectangle
      {
         var bounds:Rectangle = new Rectangle();
         var column:int = Math.floor((scrollRect.right + 1 + this._horizontalGap - this.paddingLeft) / (this._columnWidth + this._horizontalGap));
         bounds.left = this.leftEdge(column);
         bounds.right = this.rightEdge(column);
         return bounds;
      }
      
      override protected function getElementBoundsAboveScrollRect(scrollRect:Rectangle) : Rectangle
      {
         var bounds:Rectangle = new Rectangle();
         var row:int = Math.floor((scrollRect.top - 1 - this.paddingTop) / (this._rowHeight + this._verticalGap));
         bounds.top = this.topEdge(row);
         bounds.bottom = this.bottomEdge(row);
         return bounds;
      }
      
      override protected function getElementBoundsBelowScrollRect(scrollRect:Rectangle) : Rectangle
      {
         var bounds:Rectangle = new Rectangle();
         var row:int = Math.floor((scrollRect.bottom + 1 + this._verticalGap - this.paddingTop) / (this._rowHeight + this._verticalGap));
         bounds.top = this.topEdge(row);
         bounds.bottom = this.bottomEdge(row);
         return bounds;
      }
      
      override public function elementAdded(index:int) : void
      {
         this.invalidateTargetSizeAndDisplayList();
      }
      
      override public function elementRemoved(index:int) : void
      {
         this.invalidateTargetSizeAndDisplayList();
      }
      
      private function calculateDropCellIndex(x:Number, y:Number) : Array
      {
         var midColumnLine:Number = NaN;
         var midRowLine:Number = NaN;
         var xStart:Number = x - this.paddingLeft;
         var yStart:Number = y - this.paddingTop;
         var column:int = Math.floor(xStart / (this._columnWidth + this._horizontalGap));
         var row:int = Math.floor(yStart / (this._rowHeight + this._verticalGap));
         var rowOrientation:Boolean = this.orientation == TileOrientation.ROWS;
         if(rowOrientation)
         {
            midColumnLine = (column + 1) * (this._columnWidth + this._horizontalGap) - this._horizontalGap - this._columnWidth / 2;
            midRowLine = (row + 1) * (this._rowHeight + this._verticalGap) - this._verticalGap / 2;
         }
         else
         {
            midColumnLine = (column + 1) * (this._columnWidth + this._horizontalGap) - this._horizontalGap / 2;
            midRowLine = (row + 1) * (this._rowHeight + this._verticalGap) - this._verticalGap - this._rowHeight / 2;
         }
         if(xStart > midColumnLine)
         {
            column++;
         }
         if(yStart > midRowLine)
         {
            row++;
         }
         if(column > this._columnCount || row > this._rowCount)
         {
            row = this._rowCount;
            column = this._columnCount;
         }
         if(column < 0)
         {
            column = 0;
         }
         if(row < 0)
         {
            row = 0;
         }
         if(rowOrientation)
         {
            if(row >= this._rowCount)
            {
               row = this._rowCount - 1;
            }
         }
         else if(column >= this._columnCount)
         {
            column = this._columnCount - 1;
         }
         return [row,column];
      }
      
      override protected function calculateDropIndex(x:Number, y:Number) : int
      {
         var index:int = 0;
         var result:Array = this.calculateDropCellIndex(x,y);
         var row:int = int(result[0]);
         var column:int = int(result[1]);
         if(this.orientation == TileOrientation.ROWS)
         {
            index = row * this._columnCount + column;
         }
         else
         {
            index = column * this._rowCount + row;
         }
         var count:int = this.calculateElementCount();
         this._numElementsCached = -1;
         if(index > count)
         {
            index = count;
         }
         return index;
      }
      
      override protected function calculateDropIndicatorBounds(dropLocation:DropLocation) : Rectangle
      {
         var x:Number = NaN;
         var y:Number = NaN;
         var dropIndicatorElement:IVisualElement = null;
         var emptySpace:Number = NaN;
         var emptySpaceLeft:Number = NaN;
         var emptySpaceTop:Number = NaN;
         var result:Array = this.calculateDropCellIndex(dropLocation.dropPoint.x,dropLocation.dropPoint.y);
         var row:int = int(result[0]);
         var column:int = int(result[1]);
         var rowOrientation:Boolean = this.orientation == TileOrientation.ROWS;
         var count:int = this.calculateElementCount();
         this._numElementsCached = -1;
         if(rowOrientation)
         {
            if(row * this._columnCount + column > count)
            {
               column = count - (this._rowCount - 1) * this._columnCount;
            }
         }
         else if(column * this._rowCount + row > count)
         {
            row = count - (this._columnCount - 1) * this._rowCount;
         }
         var width:Number = dropIndicator.width;
         var height:Number = dropIndicator.height;
         if(rowOrientation)
         {
            emptySpace = 0 < this._horizontalGap ? this._horizontalGap : 0;
            emptySpaceLeft = column * (this._columnWidth + this._horizontalGap) - emptySpace;
            if(this._horizontalGap < 0 && (column == this._columnCount || count == dropLocation.dropIndex))
            {
               emptySpaceLeft -= this._horizontalGap;
            }
            width = emptySpace;
            height = this._rowHeight;
            if(this._verticalGap < 0 && row < this._rowCount - 1)
            {
               height += this._verticalGap + 1;
            }
            if(dropIndicator is IVisualElement)
            {
               dropIndicatorElement = IVisualElement(dropIndicator);
               width = Math.max(Math.min(width,dropIndicatorElement.getMaxBoundsWidth(false)),dropIndicatorElement.getMinBoundsWidth(false));
            }
            x = emptySpaceLeft + Math.round((emptySpace - width) / 2) + this.paddingLeft;
            x = Math.max(-1,Math.min(target.contentWidth - width + 1,x));
            y = row * (this._rowHeight + this._verticalGap) + this.paddingTop;
         }
         else
         {
            emptySpace = 0 < this._verticalGap ? this._verticalGap : 0;
            emptySpaceTop = row * (this._rowHeight + this._verticalGap) - emptySpace;
            if(this._verticalGap < 0 && (row == this._rowCount || count == dropLocation.dropIndex))
            {
               emptySpaceTop -= this._verticalGap;
            }
            width = this._columnWidth;
            height = emptySpace;
            if(this._horizontalGap < 0 && column < this._columnCount - 1)
            {
               width += this._horizontalGap + 1;
            }
            if(dropIndicator is IVisualElement)
            {
               dropIndicatorElement = IVisualElement(dropIndicator);
               height = Math.max(Math.min(emptySpace,dropIndicatorElement.getMaxBoundsWidth(false)),dropIndicatorElement.getMinBoundsWidth(false));
            }
            x = column * (this._columnWidth + this._horizontalGap) + this.paddingLeft;
            y = emptySpaceTop + Math.round((emptySpace - height) / 2) + this.paddingTop;
            y = Math.max(-1,Math.min(target.contentHeight - height + 1,y));
         }
         return new Rectangle(x,y,width,height);
      }
      
      private function calculateCellIndex(x:Number, y:Number) : Array
      {
         var xStart:Number = x - this.paddingLeft;
         var yStart:Number = y - this.paddingTop;
         var column:int = Math.floor(xStart / (this._columnWidth + this._horizontalGap));
         var row:int = Math.floor(yStart / (this._rowHeight + this._verticalGap));
         if(column < 0)
         {
            column = 0;
         }
         if(column >= this._columnCount)
         {
            column = this._columnCount - 1;
         }
         if(row < 0)
         {
            row = 0;
         }
         if(row >= this._rowCount)
         {
            row = this._rowCount - 1;
         }
         return [row,column];
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getElementNearestScrollPosition(position:Point, elementComparePoint:String = "center") : int
      {
         var index:int = 0;
         var newIndex:int = 0;
         var result:Array = this.calculateCellIndex(position.x,position.y);
         var row:int = int(result[0]);
         var column:int = int(result[1]);
         var maxRow:int = this._rowCount - 1;
         var maxColumn:int = this._columnCount - 1;
         var bounds:Rectangle = new Rectangle(this.leftEdge(column),this.topEdge(row),this._columnWidth + this._horizontalGap,this._rowHeight + this._verticalGap);
         var TOP_LEFT:int = 0;
         var TOP_RIGHT:int = 1;
         var BOTTOM_LEFT:int = 2;
         var BOTTOM_RIGHT:int = 3;
         var quadrant:int = TOP_LEFT;
         if(position.x > bounds.left + bounds.width / 2)
         {
            quadrant += TOP_RIGHT;
         }
         if(position.y > bounds.top + bounds.height / 2)
         {
            quadrant += BOTTOM_LEFT;
         }
         if(this.orientation == TileOrientation.ROWS)
         {
            index = row * this._columnCount + column;
         }
         else
         {
            index = column * this._rowCount + row;
         }
         var g:GroupBase = GroupBase(target);
         if(index >= g.numElements)
         {
            return g.numElements - 1;
         }
         switch(elementComparePoint)
         {
            case "topLeft":
               if(quadrant == TOP_RIGHT && column < maxColumn)
               {
                  column++;
               }
               else if(quadrant == BOTTOM_LEFT && row < maxRow)
               {
                  row++;
               }
               else if(quadrant == BOTTOM_RIGHT && row < maxRow && column < maxColumn)
               {
                  row++;
                  column++;
               }
               break;
            case "topRight":
               if(quadrant == TOP_LEFT && column > 0)
               {
                  column--;
               }
               else if(quadrant == BOTTOM_LEFT && column > 0 && row < maxRow)
               {
                  column--;
                  row++;
               }
               else if(quadrant == BOTTOM_RIGHT && row < maxRow)
               {
                  row++;
               }
               break;
            case "bottomLeft":
               if(quadrant == TOP_LEFT && row > 0)
               {
                  row--;
               }
               else if(quadrant == TOP_RIGHT && row > 0 && column < maxColumn)
               {
                  row--;
                  column++;
               }
               else if(quadrant == BOTTOM_RIGHT && column < maxColumn)
               {
                  column++;
               }
               break;
            case "bottomRight":
               if(quadrant == TOP_LEFT && column > 0 && row > 0)
               {
                  column--;
                  row--;
               }
               else if(quadrant == TOP_RIGHT && row > 0)
               {
                  row--;
               }
               else if(quadrant == BOTTOM_LEFT && column > 0)
               {
                  column--;
               }
               break;
            case "center":
         }
         if(this.orientation == TileOrientation.ROWS)
         {
            newIndex = row * this._columnCount + column;
         }
         else
         {
            newIndex = column * this._rowCount + row;
         }
         if(newIndex < g.numElements)
         {
            index = newIndex;
         }
         return index;
      }
   }
}

