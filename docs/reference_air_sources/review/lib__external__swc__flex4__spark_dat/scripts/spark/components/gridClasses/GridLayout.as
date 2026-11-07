package spark.components.gridClasses
{
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import flash.utils.getTimer;
   import mx.collections.IList;
   import mx.core.ClassFactory;
   import mx.core.IFactory;
   import mx.core.IInvalidating;
   import mx.core.IVisualElement;
   import mx.core.IVisualElementContainer;
   import mx.core.Singleton;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.events.PropertyChangeEvent;
   import mx.managers.ILayoutManagerClient;
   import mx.managers.LayoutManager;
   import spark.components.DataGrid;
   import spark.components.Grid;
   import spark.core.IGraphicElement;
   import spark.layouts.supportClasses.LayoutBase;
   
   [ExcludeClass]
   public class GridLayout extends LayoutBase
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var _embeddedFontRegistryExists:Boolean = false;
      
      private static var embeddedFontRegistryExistsInitialized:Boolean = false;
      
      private static const MAX_ELEMENT_SIZE:Number = 8192;
      
      private static const ELEMENT_EDGE_PAD:Number = 512;
      
      public var gridDimensions:GridDimensions;
      
      private var visibleRowIndices:Vector.<int> = new Vector.<int>(0);
      
      private var visibleColumnIndices:Vector.<int> = new Vector.<int>(0);
      
      private var oldVisibleRowIndices:Vector.<int> = new Vector.<int>(0);
      
      private var oldVisibleColumnIndices:Vector.<int> = new Vector.<int>(0);
      
      private var visibleRowBackgrounds:Vector.<IVisualElement> = new Vector.<IVisualElement>(0);
      
      private var visibleRowSeparators:Vector.<IVisualElement> = new Vector.<IVisualElement>(0);
      
      private var visibleColumnSeparators:Vector.<IVisualElement> = new Vector.<IVisualElement>(0);
      
      private var visibleItemRenderers:Vector.<IGridItemRenderer> = new Vector.<IGridItemRenderer>(0);
      
      private var hoverIndicator:IVisualElement = null;
      
      private var caretIndicator:IVisualElement = null;
      
      private var editorIndicator:IVisualElement = null;
      
      private const visibleItemRenderersBounds:Rectangle = new Rectangle();
      
      private const visibleGridBounds:Rectangle = new Rectangle();
      
      private const freeElementMap:Dictionary = new Dictionary();
      
      private const elementToFactoryMap:Dictionary = new Dictionary();
      
      private var oldVerticalScrollPosition:Number = 0;
      
      private var oldHorizontalScrollPosition:Number = 0;
      
      private var _showCaret:Boolean = false;
      
      private const gridItemRendererClassFactories:Dictionary = new Dictionary(true);
      
      private var visibleSelectionIndicators:Vector.<IVisualElement> = new Vector.<IVisualElement>(0);
      
      private var visibleRowSelectionIndices:Vector.<int> = new Vector.<int>(0);
      
      private var visibleColumnSelectionIndices:Vector.<int> = new Vector.<int>(0);
      
      private var mouseXOffset:Number = 0;
      
      private var mouseYOffset:Number = 0;
      
      private var createdGridElement:Boolean = false;
      
      private var _performanceStatistics:Object = null;
      
      private var _enablePerformanceStatistics:Boolean = false;
      
      public function GridLayout()
      {
         super();
         this.gridDimensions = new GridDimensions();
      }
      
      private static function get embeddedFontRegistryExists() : Boolean
      {
         if(!embeddedFontRegistryExistsInitialized)
         {
            embeddedFontRegistryExistsInitialized = true;
            try
            {
               _embeddedFontRegistryExists = Singleton.getInstance("mx.core::IEmbeddedFontRegistry") != null;
            }
            catch(e:Error)
            {
               _embeddedFontRegistryExists = false;
            }
         }
         return _embeddedFontRegistryExists;
      }
      
      private static function clampColumnWidth(width:Number, column:GridColumn) : Number
      {
         var minColumnWidth:Number = column.minWidth;
         var maxColumnWidth:Number = column.maxWidth;
         if(!isNaN(minColumnWidth))
         {
            width = Math.max(width,minColumnWidth);
         }
         if(!isNaN(maxColumnWidth))
         {
            width = Math.min(width,maxColumnWidth);
         }
         return width;
      }
      
      override public function get useVirtualLayout() : Boolean
      {
         return true;
      }
      
      override public function set useVirtualLayout(value:Boolean) : void
      {
      }
      
      public function get showCaret() : Boolean
      {
         return this._showCaret;
      }
      
      public function set showCaret(show:Boolean) : void
      {
         if(Boolean(this.caretIndicator))
         {
            this.caretIndicator.visible = show;
         }
         this._showCaret = show;
      }
      
      override public function clearVirtualLayoutCache() : void
      {
         this.freeGridElements(this.visibleRowBackgrounds);
         this.freeGridElements(this.visibleRowSeparators);
         this.visibleRowIndices.length = 0;
         this.freeGridElements(this.visibleColumnSeparators);
         this.visibleColumnIndices.length = 0;
         this.freeItemRenderers(this.visibleItemRenderers);
         this.clearSelectionIndicators();
         this.freeGridElement(this.hoverIndicator);
         this.hoverIndicator = null;
         this.freeGridElement(this.caretIndicator);
         this.caretIndicator = null;
         this.freeGridElement(this.editorIndicator);
         this.editorIndicator = null;
         this.visibleItemRenderersBounds.setEmpty();
         this.visibleGridBounds.setEmpty();
      }
      
      override public function getElementBounds(index:int) : Rectangle
      {
         var columnsLength:uint = 0;
         var rowIndex:int = 0;
         var columns:IList = Boolean(this.grid) ? this.grid.columns : null;
         if(!columns)
         {
            return null;
         }
         columnsLength = uint(columns.length);
         rowIndex = index / columnsLength;
         var columnIndex:int = index - rowIndex * columnsLength;
         return this.gridDimensions.getCellBounds(rowIndex,columnIndex);
      }
      
      override protected function getElementBoundsAboveScrollRect(scrollRect:Rectangle) : Rectangle
      {
         var y:int = 0;
         y = Math.max(0,scrollRect.top - 1);
         var rowIndex:int = this.gridDimensions.getRowIndexAt(scrollRect.x,y);
         return this.gridDimensions.getRowBounds(rowIndex);
      }
      
      override protected function getElementBoundsBelowScrollRect(scrollRect:Rectangle) : Rectangle
      {
         var maxY:int = 0;
         var y:int = 0;
         maxY = Math.max(0,this.gridDimensions.getContentHeight() - 1);
         y = Math.min(maxY,scrollRect.bottom + 1);
         var rowIndex:int = this.gridDimensions.getRowIndexAt(scrollRect.x,y);
         return this.gridDimensions.getRowBounds(rowIndex);
      }
      
      override protected function getElementBoundsLeftOfScrollRect(scrollRect:Rectangle) : Rectangle
      {
         var x:int = 0;
         x = Math.max(0,scrollRect.left - 1);
         var columnIndex:int = this.gridDimensions.getColumnIndexAt(x,scrollRect.y);
         return this.gridDimensions.getColumnBounds(columnIndex);
      }
      
      override protected function getElementBoundsRightOfScrollRect(scrollRect:Rectangle) : Rectangle
      {
         var maxX:int = 0;
         var x:int = 0;
         maxX = Math.max(0,this.gridDimensions.getContentWidth() - 1);
         x = Math.min(maxX,scrollRect.right + 1);
         var columnIndex:int = this.gridDimensions.getColumnIndexAt(x,scrollRect.y);
         return this.gridDimensions.getColumnBounds(columnIndex);
      }
      
      override protected function scrollPositionChanged() : void
      {
         var invalidate:Boolean = false;
         var oldFirstRowIndex:int = 0;
         var oldLastRowIndex:int = 0;
         var newFirstRowIndex:int = 0;
         var newLastRowIndex:int = 0;
         var oldFirstColIndex:int = 0;
         var oldLastColIndex:int = 0;
         var newFirstColIndex:int = 0;
         var newLastColIndex:int = 0;
         var reason:String = null;
         if(!this.grid)
         {
            return;
         }
         this.grid.hoverRowIndex = -1;
         this.grid.hoverColumnIndex = -1;
         super.scrollPositionChanged();
         var hspChanged:Boolean = this.oldHorizontalScrollPosition != horizontalScrollPosition;
         var vspChanged:Boolean = this.oldVerticalScrollPosition != verticalScrollPosition;
         this.oldHorizontalScrollPosition = horizontalScrollPosition;
         this.oldVerticalScrollPosition = verticalScrollPosition;
         if(this.visibleRowIndices.length == 0 || this.visibleColumnIndices.length == 0)
         {
            invalidate = true;
         }
         if(!invalidate && vspChanged)
         {
            oldFirstRowIndex = this.visibleRowIndices[0];
            oldLastRowIndex = this.visibleRowIndices[this.visibleRowIndices.length - 1];
            newFirstRowIndex = this.gridDimensions.getRowIndexAt(horizontalScrollPosition,verticalScrollPosition);
            newLastRowIndex = this.gridDimensions.getRowIndexAt(horizontalScrollPosition,verticalScrollPosition + target.height);
            if(oldFirstRowIndex != newFirstRowIndex || oldLastRowIndex != newLastRowIndex)
            {
               invalidate = true;
            }
         }
         if(!invalidate && hspChanged)
         {
            oldFirstColIndex = this.visibleColumnIndices[0];
            oldLastColIndex = this.visibleColumnIndices[this.visibleColumnIndices.length - 1];
            newFirstColIndex = this.gridDimensions.getColumnIndexAt(horizontalScrollPosition,verticalScrollPosition);
            newLastColIndex = this.gridDimensions.getColumnIndexAt(horizontalScrollPosition + target.width,verticalScrollPosition);
            if(oldFirstColIndex != newFirstColIndex || oldLastColIndex != newLastColIndex)
            {
               invalidate = true;
            }
         }
         if(invalidate)
         {
            reason = "none";
            if(vspChanged && hspChanged)
            {
               reason = "bothScrollPositions";
            }
            else if(vspChanged)
            {
               reason = "verticalScrollPosition";
            }
            else if(hspChanged)
            {
               reason = "horizontalScrollPosition";
            }
            this.grid.invalidateDisplayListFor(reason);
         }
      }
      
      override public function measure() : void
      {
         var startTime:Number = NaN;
         var rowCount:int = 0;
         var elapsedTime:Number = NaN;
         if(!this.grid)
         {
            return;
         }
         if(this.enablePerformanceStatistics)
         {
            startTime = getTimer();
         }
         this.updateTypicalCellSizes();
         var measuredRowCount:int = this.grid.requestedRowCount;
         if(measuredRowCount == -1)
         {
            rowCount = this.gridDimensions.rowCount;
            if(this.grid.requestedMaxRowCount != -1)
            {
               measuredRowCount = Math.min(this.grid.requestedMaxRowCount,rowCount);
            }
            if(this.grid.requestedMinRowCount != -1)
            {
               measuredRowCount = Math.max(this.grid.requestedMinRowCount,measuredRowCount);
            }
         }
         var measuredWidth:Number = this.gridDimensions.getTypicalContentWidth(this.grid.requestedColumnCount);
         var measuredHeight:Number = this.gridDimensions.getTypicalContentHeight(measuredRowCount);
         var measuredMinWidth:Number = this.gridDimensions.getTypicalContentWidth(this.grid.requestedMinColumnCount);
         var measuredMinHeight:Number = this.gridDimensions.getTypicalContentHeight(this.grid.requestedMinRowCount);
         this.grid.measuredWidth = Math.ceil(measuredWidth);
         this.grid.measuredHeight = Math.ceil(measuredHeight);
         this.grid.measuredMinWidth = Math.ceil(measuredMinWidth);
         this.grid.measuredMinHeight = Math.ceil(measuredMinHeight);
         if(this.enablePerformanceStatistics)
         {
            elapsedTime = getTimer() - startTime;
            this.performanceStatistics.measureTimes.push(elapsedTime);
         }
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var startTime:Number = NaN;
         var columns:IList = null;
         var scrollX:Number = NaN;
         var scrollY:Number = NaN;
         var contentWidth:Number = NaN;
         var contentHeight:Number = NaN;
         var paddedRowCount:int = 0;
         var rowIndex:int = 0;
         var lastRowIndex:int = 0;
         var unusedHeight:Number = NaN;
         var endTime:Number = NaN;
         var cellCount:int = 0;
         if(!this.grid)
         {
            return;
         }
         if(this.enablePerformanceStatistics)
         {
            startTime = getTimer();
            if(this.performanceStatistics.updateDisplayListStartTime === undefined)
            {
               this.performanceStatistics.updateDisplayListStartTime = startTime;
            }
         }
         columns = this.grid.columns;
         var lastVisibleColumnIndex:int = Boolean(columns) ? this.grid.getPreviousVisibleColumnIndex(this.grid.columns.length) : -1;
         if(!columns || lastVisibleColumnIndex < 0)
         {
            return;
         }
         var backgroundLayer:GridLayer = this.getLayer("backgroundLayer");
         var selectionLayer:GridLayer = this.getLayer("selectionLayer");
         var editorIndicatorLayer:GridLayer = this.getLayer("editorIndicatorLayer");
         var rendererLayer:GridLayer = this.getLayer("rendererLayer");
         var overlayLayer:GridLayer = this.getLayer("overlayLayer");
         var completeLayoutNeeded:Boolean = this.grid.isInvalidateDisplayListReason("verticalScrollPosition") || this.grid.isInvalidateDisplayListReason("horizontalScrollPosition");
         if(completeLayoutNeeded)
         {
            this.oldVisibleRowIndices = this.visibleRowIndices;
            this.oldVisibleColumnIndices = this.visibleColumnIndices;
            scrollX = Math.max(0,horizontalScrollPosition);
            scrollY = Math.max(0,verticalScrollPosition);
            this.visibleGridBounds.x = scrollX;
            this.visibleGridBounds.y = scrollY;
            this.visibleGridBounds.width = unscaledWidth;
            this.visibleGridBounds.height = unscaledHeight;
            this.layoutColumns(scrollX,scrollY,unscaledWidth);
            this.layoutItemRenderers(rendererLayer,scrollX,scrollY,unscaledWidth,unscaledHeight);
            contentWidth = Math.ceil(this.gridDimensions.getContentWidth());
            contentHeight = Math.ceil(this.gridDimensions.getContentHeight());
            this.grid.setContentSize(contentWidth,contentHeight);
            paddedRowCount = this.gridDimensions.rowCount;
            if(scrollY == 0 && contentHeight < unscaledHeight)
            {
               unusedHeight = unscaledHeight - this.gridDimensions.getContentHeight();
               paddedRowCount += Math.ceil(unusedHeight / this.gridDimensions.defaultRowHeight);
            }
            for(rowIndex = this.gridDimensions.rowCount; rowIndex < paddedRowCount; rowIndex++)
            {
               this.visibleRowIndices.push(rowIndex);
            }
            this.visibleRowBackgrounds = this.layoutLinearElements(this.grid.rowBackground,backgroundLayer,this.visibleRowBackgrounds,this.oldVisibleRowIndices,this.visibleRowIndices,this.layoutRowBackground);
            lastRowIndex = paddedRowCount - 1;
            this.visibleRowSeparators = this.layoutLinearElements(this.grid.rowSeparator,overlayLayer,this.visibleRowSeparators,this.oldVisibleRowIndices,this.visibleRowIndices,this.layoutRowSeparator,lastRowIndex);
            this.visibleColumnSeparators = this.layoutLinearElements(this.grid.columnSeparator,overlayLayer,this.visibleColumnSeparators,this.oldVisibleColumnIndices,this.visibleColumnIndices,this.layoutColumnSeparator,lastVisibleColumnIndex);
            this.oldVisibleRowIndices.length = 0;
            this.oldVisibleColumnIndices.length = 0;
         }
         if(completeLayoutNeeded || this.grid.isInvalidateDisplayListReason("hoverIndicator"))
         {
            this.layoutHoverIndicator(backgroundLayer);
         }
         if(completeLayoutNeeded || this.grid.isInvalidateDisplayListReason("selectionIndicator"))
         {
            this.layoutSelectionIndicators(selectionLayer);
         }
         if(completeLayoutNeeded || this.grid.isInvalidateDisplayListReason("caretIndicator"))
         {
            this.layoutCaretIndicator(overlayLayer);
         }
         if(completeLayoutNeeded || this.grid.isInvalidateDisplayListReason("editorIndicator"))
         {
            this.layoutEditorIndicator(editorIndicatorLayer);
         }
         if(!completeLayoutNeeded)
         {
            this.updateVisibleItemRenderers();
         }
         this.grid.validateNow();
         if(this.enablePerformanceStatistics)
         {
            endTime = getTimer();
            cellCount = this.visibleRowIndices.length * this.visibleColumnIndices.length;
            this.performanceStatistics.updateDisplayListEndTime = endTime;
            this.performanceStatistics.updateDisplayListTimes.push(endTime - startTime);
            this.performanceStatistics.updateDisplayListRectangles.push(this.visibleGridBounds.clone());
            this.performanceStatistics.updateDisplayListCellCounts.push(cellCount);
         }
      }
      
      private function updateVisibleItemRenderers() : void
      {
         var renderer:IGridItemRenderer = null;
         var rowIndex:int = 0;
         var columnIndex:int = 0;
         var oldSelected:Boolean = false;
         var oldShowsCaret:Boolean = false;
         var oldHovered:Boolean = false;
         var grid:Grid = this.grid;
         var rowSelectionMode:Boolean = this.isRowSelectionMode();
         var cellSelectionMode:Boolean = this.isCellSelectionMode();
         if(!rowSelectionMode && !cellSelectionMode)
         {
            return;
         }
         for each(renderer in this.visibleItemRenderers)
         {
            rowIndex = renderer.rowIndex;
            columnIndex = renderer.columnIndex;
            oldSelected = renderer.selected;
            oldShowsCaret = renderer.showsCaret;
            oldHovered = renderer.hovered;
            if(rowSelectionMode)
            {
               renderer.selected = grid.selectionContainsIndex(rowIndex);
               renderer.showsCaret = grid.caretRowIndex == rowIndex;
               renderer.hovered = grid.hoverRowIndex == rowIndex;
            }
            else if(cellSelectionMode)
            {
               renderer.selected = grid.selectionContainsCell(rowIndex,columnIndex);
               renderer.showsCaret = grid.caretRowIndex == rowIndex && grid.caretColumnIndex == columnIndex;
               renderer.hovered = grid.hoverRowIndex == rowIndex && grid.hoverColumnIndex == columnIndex;
            }
            if(oldSelected != renderer.selected || oldShowsCaret != renderer.showsCaret || oldHovered != renderer.hovered)
            {
               renderer.prepare(true);
            }
         }
      }
      
      private function get grid() : Grid
      {
         return target as Grid;
      }
      
      private function getLayer(name:String) : GridLayer
      {
         var grid:Grid = target as Grid;
         if(!grid)
         {
            return null;
         }
         return grid.getChildByName(name) as GridLayer;
      }
      
      private function getGridColumn(columnIndex:int) : GridColumn
      {
         var columns:IList = this.grid.columns;
         if(columns == null || columnIndex >= columns.length || columnIndex < 0)
         {
            return null;
         }
         return columns.getItemAt(columnIndex) as GridColumn;
      }
      
      private function getDataProviderItem(rowIndex:int) : Object
      {
         var dataProvider:IList = this.grid.dataProvider;
         if(dataProvider == null || rowIndex >= dataProvider.length || rowIndex < 0)
         {
            return null;
         }
         return dataProvider.getItemAt(rowIndex);
      }
      
      private function createTypicalItemRenderer(columnIndex:int) : IGridItemRenderer
      {
         var column:GridColumn = null;
         var factory:IFactory = null;
         var rendererLayer:GridLayer = this.getLayer("rendererLayer");
         if(!rendererLayer)
         {
            return null;
         }
         var typicalItem:Object = this.grid.typicalItem;
         if(typicalItem == null)
         {
            typicalItem = this.getDataProviderItem(0);
         }
         column = this.getGridColumn(columnIndex);
         factory = this.itemToRenderer(column,typicalItem);
         var renderer:IGridItemRenderer = this.allocateGridElement(factory) as IGridItemRenderer;
         rendererLayer.addElement(renderer);
         this.initializeItemRenderer(renderer,0,columnIndex,this.grid.typicalItem,false);
         var columnWidth:Number = column.width;
         if(isNaN(columnWidth))
         {
            if("explicitWidth" in renderer)
            {
               columnWidth = Number(Object(renderer).explicitWidth);
            }
         }
         if(isNaN(columnWidth))
         {
            columnWidth = 4096;
         }
         this.layoutItemRenderer(renderer,0,0,columnWidth,NaN);
         return renderer;
      }
      
      private function updateVisibleTypicalCellSizes(width:Number, scrollX:Number, firstVisibleColumnIndex:int) : void
      {
         var gridDimensions:GridDimensions = null;
         var cellHeight:Number = NaN;
         var cellWidth:Number = NaN;
         var column:GridColumn = null;
         var renderer:IGridItemRenderer = null;
         var rendererLayer:GridLayer = this.getLayer("rendererLayer");
         if(!rendererLayer)
         {
            return;
         }
         gridDimensions = this.gridDimensions;
         var columnCount:int = gridDimensions.columnCount;
         var startCellX:Number = gridDimensions.getCellX(0,firstVisibleColumnIndex);
         var columnGap:int = gridDimensions.columnGap;
         var columnIndex:int = firstVisibleColumnIndex;
         while(width > 0 && columnIndex >= 0 && columnIndex < columnCount)
         {
            cellHeight = gridDimensions.getTypicalCellHeight(columnIndex);
            cellWidth = gridDimensions.getTypicalCellWidth(columnIndex);
            column = this.getGridColumn(columnIndex);
            if(!isNaN(column.width))
            {
               cellWidth = column.width;
               gridDimensions.setTypicalCellWidth(columnIndex,cellWidth);
            }
            if(isNaN(cellWidth) || isNaN(cellHeight))
            {
               renderer = this.createTypicalItemRenderer(columnIndex);
               if(isNaN(cellWidth))
               {
                  cellWidth = clampColumnWidth(renderer.getPreferredBoundsWidth(),column);
                  gridDimensions.setTypicalCellWidth(columnIndex,cellWidth);
               }
               if(isNaN(cellHeight))
               {
                  cellHeight = Number(renderer.getPreferredBoundsHeight());
                  gridDimensions.setTypicalCellHeight(columnIndex,cellHeight);
               }
               rendererLayer.removeElement(renderer);
               this.freeGridElement(renderer);
            }
            if(columnIndex == firstVisibleColumnIndex)
            {
               width -= startCellX + cellWidth - scrollX;
            }
            else
            {
               width -= cellWidth + columnGap;
            }
            columnIndex = this.grid.getNextVisibleColumnIndex(columnIndex);
         }
      }
      
      private function updateTypicalCellSizes() : void
      {
         var gridDimensions:GridDimensions = null;
         var cellHeight:Number = NaN;
         var cellWidth:Number = NaN;
         var column:GridColumn = null;
         var needTypicalRenderer:Boolean = false;
         var renderer:IGridItemRenderer = null;
         var rendererLayer:GridLayer = this.getLayer("rendererLayer");
         if(!rendererLayer)
         {
            return;
         }
         gridDimensions = this.gridDimensions;
         var columnCount:int = gridDimensions.columnCount;
         var columnGap:int = gridDimensions.columnGap;
         var requestedColumnCount:int = this.grid.requestedColumnCount;
         var measuredColumnCount:int = 0;
         for(var columnIndex:int = 0; columnIndex < columnCount; columnIndex++)
         {
            cellHeight = gridDimensions.getTypicalCellHeight(columnIndex);
            cellWidth = gridDimensions.getTypicalCellWidth(columnIndex);
            column = this.getGridColumn(columnIndex);
            if(!column.visible)
            {
               gridDimensions.setTypicalCellWidth(columnIndex,0);
               gridDimensions.setTypicalCellHeight(columnIndex,0);
            }
            else
            {
               if(!isNaN(column.width))
               {
                  cellWidth = column.width;
                  gridDimensions.setTypicalCellWidth(columnIndex,cellWidth);
               }
               needTypicalRenderer = requestedColumnCount == -1 || measuredColumnCount < requestedColumnCount;
               if(needTypicalRenderer && (isNaN(cellWidth) || isNaN(cellHeight)))
               {
                  renderer = this.createTypicalItemRenderer(columnIndex);
                  if(isNaN(cellWidth))
                  {
                     cellWidth = clampColumnWidth(renderer.getPreferredBoundsWidth(),column);
                     gridDimensions.setTypicalCellWidth(columnIndex,cellWidth);
                  }
                  if(isNaN(cellHeight))
                  {
                     cellHeight = Number(renderer.getPreferredBoundsHeight());
                     gridDimensions.setTypicalCellHeight(columnIndex,cellHeight);
                  }
                  rendererLayer.removeElement(renderer);
                  this.freeGridElement(renderer);
               }
               measuredColumnCount++;
            }
         }
      }
      
      private function layoutColumns(scrollX:Number, scrollY:Number, width:Number) : void
      {
         var firstVisibleColumnIndex:int = 0;
         var columnWidth:Number = NaN;
         var gridColumn:GridColumn = null;
         var oldColumnWidth:Number = NaN;
         var gridDimensions:GridDimensions = this.gridDimensions;
         var columnCount:int = gridDimensions.columnCount;
         if(columnCount <= 0)
         {
            return;
         }
         firstVisibleColumnIndex = gridDimensions.getColumnIndexAt(scrollX,scrollY);
         this.updateVisibleTypicalCellSizes(width,scrollX,firstVisibleColumnIndex);
         var columnGap:int = gridDimensions.columnGap;
         var startCellX:Number = gridDimensions.getCellX(0,firstVisibleColumnIndex);
         var availableWidth:Number = width;
         var flexibleColumnCount:uint = 0;
         var columnIndex:int = firstVisibleColumnIndex;
         while(availableWidth > 0 && columnIndex >= 0 && columnIndex < columnCount)
         {
            columnWidth = gridDimensions.getTypicalCellWidth(columnIndex);
            gridColumn = this.getGridColumn(columnIndex);
            if(isNaN(gridColumn.width))
            {
               flexibleColumnCount += 1;
               columnWidth = clampColumnWidth(columnWidth,gridColumn);
            }
            else
            {
               columnWidth = gridColumn.width;
            }
            gridDimensions.setColumnWidth(columnIndex,columnWidth);
            if(columnIndex == firstVisibleColumnIndex)
            {
               availableWidth -= startCellX + columnWidth - scrollX;
            }
            else
            {
               availableWidth -= columnWidth + columnGap;
            }
            columnIndex = this.grid.getNextVisibleColumnIndex(columnIndex);
         }
         if(scrollX != 0 || availableWidth < 1 || flexibleColumnCount == 0)
         {
            return;
         }
         var columnWidthDelta:Number = Math.ceil(availableWidth / flexibleColumnCount);
         columnIndex = firstVisibleColumnIndex;
         while(columnIndex >= 0 && columnIndex < columnCount && availableWidth >= 1)
         {
            gridColumn = this.getGridColumn(columnIndex);
            if(isNaN(gridColumn.width))
            {
               oldColumnWidth = gridDimensions.getColumnWidth(columnIndex);
               columnWidth = oldColumnWidth + Math.min(availableWidth,columnWidthDelta);
               columnWidth = clampColumnWidth(columnWidth,gridColumn);
               gridDimensions.setColumnWidth(columnIndex,columnWidth);
               availableWidth -= columnWidth - oldColumnWidth;
            }
            columnIndex = this.grid.getNextVisibleColumnIndex(columnIndex);
         }
      }
      
      private function itemToRenderer(column:GridColumn, dataItem:Object) : IFactory
      {
         var factory:IFactory = column.itemToRenderer(dataItem);
         var rendererClassFactory:IFactory = null;
         if(embeddedFontRegistryExists && factory is ClassFactory)
         {
            rendererClassFactory = this.gridItemRendererClassFactories[factory];
            if(!rendererClassFactory)
            {
               rendererClassFactory = new GridItemRendererClassFactory(this.grid,ClassFactory(factory));
               this.gridItemRendererClassFactories[factory] = rendererClassFactory;
            }
         }
         return Boolean(rendererClassFactory) ? rendererClassFactory : factory;
      }
      
      private function layoutItemRenderers(rendererLayer:GridLayer, scrollX:Number, scrollY:Number, width:Number, height:Number) : void
      {
         var rowIndex:int = 0;
         var colIndex:int = 0;
         var gridDimensions:GridDimensions = null;
         var startColIndex:int = 0;
         var startRowIndex:int = 0;
         var column:GridColumn = null;
         var oldRenderer:IGridItemRenderer = null;
         var columnWidth:Number = NaN;
         var rowHeight:Number = NaN;
         var finalRowHeight:Number = NaN;
         var renderer:IGridItemRenderer = null;
         var colWidth:Number = NaN;
         var preferredRowHeight:Number = NaN;
         var dataItem:Object = null;
         var factory:IFactory = null;
         var visibleColumnsLength:int = 0;
         var rowOffset:int = 0;
         var colOffset:int = 0;
         var index:int = 0;
         var rendererX:Number = NaN;
         var rendererY:Number = NaN;
         var rendererWidth:Number = NaN;
         var lastRowIndex:int = 0;
         var lastColIndex:int = 0;
         var lastCellR:Rectangle = null;
         if(!rendererLayer)
         {
            return;
         }
         gridDimensions = this.gridDimensions;
         var rowCount:int = gridDimensions.rowCount;
         var colCount:int = gridDimensions.columnCount;
         var rowGap:int = gridDimensions.rowGap;
         var colGap:int = gridDimensions.columnGap;
         startColIndex = gridDimensions.getColumnIndexAt(scrollX,scrollY);
         startRowIndex = gridDimensions.getRowIndexAt(scrollX,scrollY);
         var startCellX:Number = gridDimensions.getCellX(startRowIndex,startColIndex);
         var startCellY:Number = gridDimensions.getCellY(startRowIndex,startColIndex);
         var newVisibleColumnIndices:Vector.<int> = new Vector.<int>();
         var availableWidth:Number = width;
         colIndex = startColIndex;
         while(availableWidth > 0 && colIndex >= 0 && colIndex < colCount)
         {
            newVisibleColumnIndices.push(colIndex);
            columnWidth = gridDimensions.getColumnWidth(colIndex);
            if(colIndex == startColIndex)
            {
               availableWidth -= startCellX + columnWidth - scrollX;
            }
            else
            {
               availableWidth -= columnWidth + colGap;
            }
            colIndex = this.grid.getNextVisibleColumnIndex(colIndex);
         }
         var newVisibleRowIndices:Vector.<int> = new Vector.<int>();
         var newVisibleItemRenderers:Vector.<IGridItemRenderer> = new Vector.<IGridItemRenderer>();
         var cellX:Number = startCellX;
         var cellY:Number = startCellY;
         var availableHeight:Number = height;
         rowIndex = startRowIndex;
         while(availableHeight > 0 && rowIndex >= 0 && rowIndex < rowCount)
         {
            newVisibleRowIndices.push(rowIndex);
            rowHeight = gridDimensions.getRowHeight(rowIndex);
            for each(colIndex in newVisibleColumnIndices)
            {
               renderer = this.takeVisibleItemRenderer(rowIndex,colIndex);
               if(!renderer)
               {
                  dataItem = this.getDataProviderItem(rowIndex);
                  column = this.getGridColumn(colIndex);
                  factory = this.itemToRenderer(column,dataItem);
                  renderer = this.allocateGridElement(factory) as IGridItemRenderer;
               }
               if(renderer.parent != rendererLayer)
               {
                  rendererLayer.addElement(renderer);
               }
               newVisibleItemRenderers.push(renderer);
               this.initializeItemRenderer(renderer,rowIndex,colIndex);
               colWidth = gridDimensions.getColumnWidth(colIndex);
               this.layoutItemRenderer(renderer,cellX,cellY,colWidth,rowHeight);
               preferredRowHeight = Number(renderer.getPreferredBoundsHeight());
               gridDimensions.setCellHeight(rowIndex,colIndex,preferredRowHeight);
               cellX += colWidth + colGap;
            }
            finalRowHeight = gridDimensions.getRowHeight(rowIndex);
            if(rowHeight != finalRowHeight)
            {
               visibleColumnsLength = int(newVisibleColumnIndices.length);
               rowHeight = finalRowHeight;
               for each(colIndex in newVisibleColumnIndices)
               {
                  rowOffset = newVisibleRowIndices.indexOf(rowIndex);
                  colOffset = newVisibleColumnIndices.indexOf(colIndex);
                  index = rowOffset * visibleColumnsLength + colOffset;
                  renderer = newVisibleItemRenderers[index];
                  rendererX = Number(renderer.getLayoutBoundsX());
                  rendererY = Number(renderer.getLayoutBoundsY());
                  rendererWidth = Number(renderer.getLayoutBoundsWidth());
                  this.layoutItemRenderer(renderer,rendererX,rendererY,rendererWidth,rowHeight);
                  gridDimensions.setCellHeight(rowIndex,colIndex,renderer.getPreferredBoundsHeight());
               }
            }
            cellX = startCellX;
            cellY += rowHeight + rowGap;
            if(rowIndex == startRowIndex)
            {
               availableHeight -= startCellY + rowHeight - scrollY;
            }
            else
            {
               availableHeight -= rowHeight + rowGap;
            }
            rowIndex++;
         }
         for each(oldRenderer in this.visibleItemRenderers)
         {
            this.freeItemRenderer(oldRenderer);
            if(Boolean(oldRenderer))
            {
               oldRenderer.discard(true);
            }
         }
         if(newVisibleRowIndices.length > 0 && newVisibleColumnIndices.length > 0)
         {
            lastRowIndex = newVisibleRowIndices[newVisibleRowIndices.length - 1];
            lastColIndex = newVisibleColumnIndices[newVisibleColumnIndices.length - 1];
            lastCellR = gridDimensions.getCellBounds(lastRowIndex,lastColIndex);
            this.visibleItemRenderersBounds.x = startCellX;
            this.visibleItemRenderersBounds.y = startCellY;
            this.visibleItemRenderersBounds.width = lastCellR.x + lastCellR.width - startCellX;
            this.visibleItemRenderersBounds.height = lastCellR.y + lastCellR.height - startCellY;
         }
         else
         {
            this.visibleItemRenderersBounds.setEmpty();
         }
         this.visibleItemRenderers = newVisibleItemRenderers;
         this.visibleRowIndices = newVisibleRowIndices;
         this.visibleColumnIndices = newVisibleColumnIndices;
      }
      
      public function invalidateCell(rowIndex:int, columnIndex:int) : void
      {
         var renderer:IGridItemRenderer = this.getVisibleItemRenderer(rowIndex,columnIndex);
         if(!renderer)
         {
            return;
         }
         if(this.itemRendererFunctionValueChanged(renderer))
         {
            renderer.grid.invalidateDisplayList();
            return;
         }
         this.initializeItemRenderer(renderer,rowIndex,columnIndex);
         var rendererX:Number = Number(renderer.getLayoutBoundsX());
         var rendererY:Number = Number(renderer.getLayoutBoundsY());
         var rendererWidth:Number = Number(renderer.getLayoutBoundsWidth());
         var rendererHeight:Number = Number(renderer.getLayoutBoundsHeight());
         this.layoutItemRenderer(renderer,rendererX,rendererY,rendererWidth,rendererHeight);
         var preferredRendererHeight:Number = Number(renderer.getPreferredBoundsHeight());
         if(this.gridDimensions.variableRowHeight && rendererHeight != preferredRendererHeight)
         {
            this.grid.invalidateDisplayList();
         }
      }
      
      private function itemRendererFunctionValueChanged(renderer:IGridItemRenderer) : Boolean
      {
         var column:GridColumn = renderer.column;
         if(!column || column.itemRendererFunction === null)
         {
            return false;
         }
         var factory:IFactory = this.itemToRenderer(column,renderer.data);
         return factory !== this.elementToFactoryMap[renderer];
      }
      
      private function getVisibleItemRendererIndex(rowIndex:int, columnIndex:int) : int
      {
         if(this.visibleRowIndices == null || this.visibleColumnIndices == null)
         {
            return -1;
         }
         var rowOffset:int = this.visibleRowIndices.indexOf(rowIndex);
         var colOffset:int = this.visibleColumnIndices.indexOf(columnIndex);
         if(rowOffset == -1 || colOffset == -1)
         {
            return -1;
         }
         return int(rowOffset * this.visibleColumnIndices.length + colOffset);
      }
      
      public function getVisibleItemRenderer(rowIndex:int, columnIndex:int) : IGridItemRenderer
      {
         var index:int = this.getVisibleItemRendererIndex(rowIndex,columnIndex);
         if(index == -1 || index >= this.visibleItemRenderers.length)
         {
            return null;
         }
         return this.visibleItemRenderers[index];
      }
      
      private function takeVisibleItemRenderer(rowIndex:int, columnIndex:int) : IGridItemRenderer
      {
         var index:int = this.getVisibleItemRendererIndex(rowIndex,columnIndex);
         if(index == -1 || index >= this.visibleItemRenderers.length)
         {
            return null;
         }
         var renderer:IGridItemRenderer = this.visibleItemRenderers[index];
         this.visibleItemRenderers[index] = null;
         if(Boolean(renderer) && this.itemRendererFunctionValueChanged(renderer))
         {
            this.freeItemRenderer(renderer);
            return null;
         }
         return renderer;
      }
      
      private function initializeItemRenderer(renderer:IGridItemRenderer, rowIndex:int, columnIndex:int, dataItem:Object = null, visible:Boolean = true) : void
      {
         renderer.visible = visible;
         var gridColumn:GridColumn = this.getGridColumn(columnIndex);
         if(Boolean(gridColumn))
         {
            renderer.rowIndex = rowIndex;
            renderer.column = gridColumn;
            if(dataItem == null)
            {
               dataItem = this.getDataProviderItem(rowIndex);
            }
            renderer.label = gridColumn.itemToLabel(dataItem);
            if(this.isRowSelectionMode())
            {
               renderer.selected = this.grid.selectionContainsIndex(rowIndex);
               renderer.showsCaret = this.grid.caretRowIndex == rowIndex;
               renderer.hovered = this.grid.hoverRowIndex == rowIndex;
            }
            else if(this.isCellSelectionMode())
            {
               renderer.selected = this.grid.selectionContainsCell(rowIndex,columnIndex);
               renderer.showsCaret = this.grid.caretRowIndex == rowIndex && this.grid.caretColumnIndex == columnIndex;
               renderer.hovered = this.grid.hoverRowIndex == rowIndex && this.grid.hoverColumnIndex == columnIndex;
            }
            renderer.data = dataItem;
            if(Boolean(this.grid.dataGrid))
            {
               renderer.owner = this.grid.dataGrid;
            }
            renderer.prepare(!this.createdGridElement);
         }
      }
      
      private function freeItemRenderer(renderer:IGridItemRenderer) : void
      {
         if(!renderer)
         {
            return;
         }
         this.freeGridElement(renderer);
      }
      
      private function freeItemRenderers(renderers:Vector.<IGridItemRenderer>) : void
      {
         var renderer:IGridItemRenderer = null;
         for each(renderer in renderers)
         {
            this.freeItemRenderer(renderer);
         }
         renderers.length = 0;
      }
      
      private function layoutLinearElements(factory:IFactory, layer:GridLayer, oldVisibleElements:Vector.<IVisualElement>, oldVisibleIndices:Vector.<int>, newVisibleIndices:Vector.<int>, layoutFunction:Function, lastIndex:int = -1) : Vector.<IVisualElement>
      {
         var newVisibleElementCount:uint = 0;
         var newEltIndex:int = 0;
         var eltOffset:int = 0;
         var elt:IVisualElement = null;
         if(!layer)
         {
            return new Vector.<IVisualElement>(0);
         }
         this.discardGridElementsIfFactoryChanged(factory,layer,oldVisibleElements);
         if(factory == null)
         {
            return new Vector.<IVisualElement>(0);
         }
         this.freeLinearElements(oldVisibleElements,oldVisibleIndices,newVisibleIndices,lastIndex);
         newVisibleElementCount = newVisibleIndices.length;
         var newVisibleElements:Vector.<IVisualElement> = new Vector.<IVisualElement>(newVisibleElementCount);
         for(var index:int = 0; index < newVisibleElementCount; index++)
         {
            newEltIndex = newVisibleIndices[index];
            if(newEltIndex == lastIndex)
            {
               newVisibleElements.length = index;
               break;
            }
            eltOffset = oldVisibleIndices.indexOf(newEltIndex);
            elt = eltOffset != -1 && eltOffset < oldVisibleElements.length ? oldVisibleElements[eltOffset] : null;
            if(elt == null)
            {
               elt = this.allocateGridElement(factory);
            }
            newVisibleElements[index] = elt;
            layer.addElement(elt);
            elt.visible = true;
            layoutFunction(elt,newEltIndex);
         }
         return newVisibleElements;
      }
      
      private function layoutCellElements(factory:IFactory, layer:GridLayer, oldVisibleElements:Vector.<IVisualElement>, oldVisibleRowIndices:Vector.<int>, oldVisibleColumnIndices:Vector.<int>, newVisibleRowIndices:Vector.<int>, newVisibleColumnIndices:Vector.<int>, layoutFunction:Function) : Vector.<IVisualElement>
      {
         var newVisibleElementCount:uint = 0;
         var newEltRowIndex:int = 0;
         var newEltColumnIndex:int = 0;
         var elt:IVisualElement = null;
         if(!layer)
         {
            return new Vector.<IVisualElement>(0);
         }
         if(this.discardGridElementsIfFactoryChanged(factory,layer,oldVisibleElements))
         {
            oldVisibleRowIndices.length = 0;
            oldVisibleColumnIndices.length = 0;
         }
         if(factory == null)
         {
            return new Vector.<IVisualElement>(0);
         }
         newVisibleElementCount = newVisibleRowIndices.length;
         var newVisibleElements:Vector.<IVisualElement> = new Vector.<IVisualElement>(newVisibleElementCount);
         this.freeCellElements(oldVisibleElements,newVisibleElements,oldVisibleRowIndices,newVisibleRowIndices,oldVisibleColumnIndices,newVisibleColumnIndices);
         for(var index:int = 0; index < newVisibleElementCount; index++)
         {
            newEltRowIndex = newVisibleRowIndices[index];
            newEltColumnIndex = newVisibleColumnIndices[index];
            elt = newVisibleElements[index];
            if(elt === null)
            {
               elt = this.allocateGridElement(factory);
               newVisibleElements[index] = elt;
            }
            layer.addElement(elt);
            elt.visible = true;
            layoutFunction(elt,newEltRowIndex,newEltColumnIndex);
         }
         return newVisibleElements;
      }
      
      private function discardGridElementsIfFactoryChanged(factory:IFactory, layer:GridLayer, oldVisibleElements:Vector.<IVisualElement>) : Boolean
      {
         var oldElt:IVisualElement = null;
         if(oldVisibleElements.length > 0 && factory != this.elementToFactoryMap[oldVisibleElements[0]])
         {
            for each(oldElt in oldVisibleElements)
            {
               layer.removeElement(oldElt);
               this.freeGridElement(oldElt);
            }
            oldVisibleElements.length = 0;
            return true;
         }
         return false;
      }
      
      private function freeLinearElements(elements:Vector.<IVisualElement>, oldIndices:Vector.<int>, newIndices:Vector.<int>, lastIndex:int) : void
      {
         var offset:int = 0;
         var elt:IVisualElement = null;
         for(var i:int = 0; i < elements.length; i++)
         {
            offset = newIndices.indexOf(oldIndices[i]);
            if(oldIndices[i] == lastIndex || offset == -1)
            {
               elt = elements[i];
               if(Boolean(elt))
               {
                  this.freeGridElement(elt);
                  elements[i] = null;
               }
            }
         }
      }
      
      private function freeCellElements(elements:Vector.<IVisualElement>, newElements:Vector.<IVisualElement>, oldRowIndices:Vector.<int>, newRowIndices:Vector.<int>, oldColumnIndices:Vector.<int>, newColumnIndices:Vector.<int>) : void
      {
         var elt:IVisualElement = null;
         var oldRowIndex:int = 0;
         var oldColumnIndex:int = 0;
         var newRowIndex:int = 0;
         var newColumnIndex:int = 0;
         var freeElement:Boolean = true;
         var numNewCells:int = int(newRowIndices.length);
         var newIndex:int = 0;
         for(var i:int = 0; i < elements.length; i++)
         {
            elt = elements[i];
            if(elt != null)
            {
               oldRowIndex = oldRowIndices[i];
               for(oldColumnIndex = oldColumnIndices[i]; newIndex < numNewCells; )
               {
                  newRowIndex = newRowIndices[newIndex];
                  newColumnIndex = newColumnIndices[newIndex];
                  if(newRowIndex == oldRowIndex)
                  {
                     if(newColumnIndex == oldColumnIndex)
                     {
                        newElements[newIndex] = elt;
                        freeElement = false;
                        break;
                     }
                     if(newColumnIndex > oldColumnIndex)
                     {
                        break;
                     }
                  }
                  else if(newRowIndex > oldRowIndex)
                  {
                     break;
                  }
                  newIndex++;
               }
               if(freeElement)
               {
                  this.freeGridElement(elt);
               }
               freeElement = true;
            }
         }
         elements.length = 0;
      }
      
      private function layoutRowBackground(rowBackground:IVisualElement, rowIndex:int) : void
      {
         var rowCount:int = 0;
         rowCount = this.gridDimensions.rowCount;
         var bounds:Rectangle = rowIndex < rowCount ? this.gridDimensions.getRowBounds(rowIndex) : this.gridDimensions.getPadRowBounds(rowIndex);
         if(!bounds)
         {
            return;
         }
         if(rowIndex < rowCount && bounds.width == 0)
         {
            bounds.width = this.visibleGridBounds.width;
         }
         this.intializeGridVisualElement(rowBackground,rowIndex);
         this.layoutGridElementR(rowBackground,bounds);
      }
      
      private function layoutRowSeparator(separator:IVisualElement, rowIndex:int) : void
      {
         var rowCount:int = 0;
         this.intializeGridVisualElement(separator,rowIndex);
         var height:Number = Number(separator.getPreferredBoundsHeight());
         rowCount = this.gridDimensions.rowCount;
         var bounds:Rectangle = rowIndex < rowCount ? this.gridDimensions.getRowBounds(rowIndex) : this.gridDimensions.getPadRowBounds(rowIndex);
         if(!bounds)
         {
            return;
         }
         var x:Number = bounds.x;
         var width:Number = Math.max(bounds.width,this.visibleGridBounds.right);
         var y:Number = bounds.bottom;
         this.layoutGridElement(separator,x,y,width,height);
      }
      
      private function layoutColumnSeparator(separator:IVisualElement, columnIndex:int) : void
      {
         var r:Rectangle = null;
         this.intializeGridVisualElement(separator,-1,columnIndex);
         r = this.visibleItemRenderersBounds;
         var width:Number = Number(separator.getPreferredBoundsWidth());
         var height:Number = Math.max(r.height,this.visibleGridBounds.height);
         var x:Number = this.gridDimensions.getCellX(0,columnIndex) + this.gridDimensions.getColumnWidth(columnIndex);
         var y:Number = r.y;
         this.layoutGridElement(separator,x,y,width,height);
      }
      
      private function isRowSelectionMode() : Boolean
      {
         var mode:String = this.grid.selectionMode;
         return mode == GridSelectionMode.SINGLE_ROW || mode == GridSelectionMode.MULTIPLE_ROWS;
      }
      
      private function isCellSelectionMode() : Boolean
      {
         var mode:String = this.grid.selectionMode;
         return mode == GridSelectionMode.SINGLE_CELL || mode == GridSelectionMode.MULTIPLE_CELLS;
      }
      
      private function layoutSelectionIndicators(layer:GridLayer) : void
      {
         var oldVisibleRowSelectionIndices:Vector.<int> = null;
         var rowIndex:int = 0;
         var oldVisibleColumnSelectionIndices:Vector.<int> = null;
         var columnIndex:int = 0;
         var selectionIndicatorFactory:IFactory = this.grid.selectionIndicator;
         if(this.isRowSelectionMode())
         {
            if(this.visibleColumnSelectionIndices.length > 0)
            {
               this.clearSelectionIndicators();
            }
            oldVisibleRowSelectionIndices = this.visibleRowSelectionIndices;
            this.visibleRowSelectionIndices = new Vector.<int>();
            for each(rowIndex in this.visibleRowIndices)
            {
               if(this.grid.selectionContainsIndex(rowIndex))
               {
                  this.visibleRowSelectionIndices.push(rowIndex);
               }
            }
            this.visibleSelectionIndicators = this.layoutLinearElements(selectionIndicatorFactory,layer,this.visibleSelectionIndicators,oldVisibleRowSelectionIndices,this.visibleRowSelectionIndices,this.layoutRowSelectionIndicator);
            return;
         }
         if(this.visibleRowSelectionIndices.length > 0 && this.visibleColumnSelectionIndices.length == 0)
         {
            this.clearSelectionIndicators();
         }
         if(this.isCellSelectionMode())
         {
            oldVisibleRowSelectionIndices = this.visibleRowSelectionIndices;
            oldVisibleColumnSelectionIndices = this.visibleColumnSelectionIndices;
            this.visibleRowSelectionIndices = new Vector.<int>();
            this.visibleColumnSelectionIndices = new Vector.<int>();
            for each(rowIndex in this.visibleRowIndices)
            {
               for each(columnIndex in this.visibleColumnIndices)
               {
                  if(this.grid.selectionContainsCell(rowIndex,columnIndex))
                  {
                     this.visibleRowSelectionIndices.push(rowIndex);
                     this.visibleColumnSelectionIndices.push(columnIndex);
                  }
               }
            }
            this.visibleSelectionIndicators = this.layoutCellElements(selectionIndicatorFactory,layer,this.visibleSelectionIndicators,oldVisibleRowSelectionIndices,oldVisibleColumnSelectionIndices,this.visibleRowSelectionIndices,this.visibleColumnSelectionIndices,this.layoutCellSelectionIndicator);
            return;
         }
         if(this.visibleColumnSelectionIndices.length > 0)
         {
            this.clearSelectionIndicators();
         }
      }
      
      private function layoutRowSelectionIndicator(indicator:IVisualElement, rowIndex:int) : void
      {
         this.intializeGridVisualElement(indicator,rowIndex);
         this.layoutGridElementR(indicator,this.gridDimensions.getRowBounds(rowIndex));
      }
      
      private function layoutCellSelectionIndicator(indicator:IVisualElement, rowIndex:int, columnIndex:int) : void
      {
         this.intializeGridVisualElement(indicator,rowIndex,columnIndex);
         this.layoutGridElementR(indicator,this.gridDimensions.getCellBounds(rowIndex,columnIndex));
      }
      
      private function clearSelectionIndicators() : void
      {
         this.freeGridElements(this.visibleSelectionIndicators);
         this.visibleRowSelectionIndices.length = 0;
         this.visibleColumnSelectionIndices.length = 0;
      }
      
      private function layoutIndicator(layer:GridLayer, indicatorFactory:IFactory, indicator:IVisualElement, rowIndex:int, columnIndex:int) : IVisualElement
      {
         var bounds:Rectangle = null;
         if(!layer)
         {
            return null;
         }
         if(Boolean(indicator) && indicatorFactory != this.elementToFactoryMap[indicator])
         {
            this.removeGridElement(indicator);
            indicator = null;
            if(indicatorFactory == null)
            {
               return null;
            }
         }
         if(rowIndex == -1 || this.grid.selectionMode == GridSelectionMode.NONE || this.isCellSelectionMode() && this.grid.getNextVisibleColumnIndex(columnIndex - 1) != columnIndex)
         {
            if(Boolean(indicator))
            {
               indicator.visible = false;
            }
            return indicator;
         }
         if(!indicator && Boolean(indicatorFactory))
         {
            indicator = this.createGridElement(indicatorFactory);
         }
         if(Boolean(indicator))
         {
            bounds = this.isRowSelectionMode() ? this.gridDimensions.getRowBounds(rowIndex) : this.gridDimensions.getCellBounds(rowIndex,columnIndex);
            this.intializeGridVisualElement(indicator,rowIndex,columnIndex);
            if(indicatorFactory == this.grid.caretIndicator && Boolean(bounds))
            {
               if(this.isCellSelectionMode() && columnIndex < this.grid.columns.length - 1)
               {
                  bounds.width += 1;
               }
               if(rowIndex < this.grid.dataProvider.length - 1 || this.visibleRowIndices.length > this.grid.dataProvider.length)
               {
                  bounds.height += 1;
               }
            }
            this.layoutGridElementR(indicator,bounds);
            layer.addElement(indicator);
            indicator.visible = true;
         }
         return indicator;
      }
      
      private function layoutHoverIndicator(layer:GridLayer) : void
      {
         var rowIndex:int = this.grid.hoverRowIndex;
         var columnIndex:int = this.grid.hoverColumnIndex;
         var factory:IFactory = this.grid.hoverIndicator;
         this.hoverIndicator = this.layoutIndicator(layer,factory,this.hoverIndicator,rowIndex,columnIndex);
      }
      
      private function layoutCaretIndicator(layer:GridLayer) : void
      {
         var rowIndex:int = this.grid.caretRowIndex;
         var colIndex:int = this.grid.caretColumnIndex;
         var factory:IFactory = this.grid.caretIndicator;
         this.caretIndicator = this.layoutIndicator(layer,factory,this.caretIndicator,rowIndex,colIndex);
         if(Boolean(this.caretIndicator) && !this._showCaret)
         {
            this.caretIndicator.visible = this._showCaret;
         }
      }
      
      private function layoutEditorIndicator(layer:GridLayer) : void
      {
         var bounds:Rectangle = null;
         var dataGrid:DataGrid = this.grid.dataGrid;
         if(!dataGrid)
         {
            return;
         }
         var rowIndex:int = dataGrid.editorRowIndex;
         var columnIndex:int = dataGrid.editorColumnIndex;
         var indicatorFactory:IFactory = dataGrid.editorIndicator;
         if(Boolean(this.editorIndicator) && indicatorFactory != this.elementToFactoryMap[this.editorIndicator])
         {
            this.removeGridElement(this.editorIndicator);
            this.editorIndicator = null;
            if(indicatorFactory == null)
            {
               return;
            }
         }
         if(rowIndex == -1 || columnIndex == -1)
         {
            if(Boolean(this.editorIndicator))
            {
               this.editorIndicator.visible = false;
            }
            return;
         }
         if(!this.editorIndicator && Boolean(indicatorFactory))
         {
            this.editorIndicator = this.createGridElement(indicatorFactory);
         }
         if(Boolean(this.editorIndicator))
         {
            bounds = this.gridDimensions.getCellBounds(rowIndex,columnIndex);
            this.intializeGridVisualElement(this.editorIndicator,rowIndex,columnIndex);
            this.layoutGridElementR(this.editorIndicator,bounds);
            layer.addElement(this.editorIndicator);
            this.editorIndicator.visible = true;
         }
      }
      
      public function dataProviderCollectionChanged(event:CollectionEvent) : void
      {
         switch(event.kind)
         {
            case CollectionEventKind.ADD:
               this.dataProviderCollectionAdd(event);
               break;
            case CollectionEventKind.REMOVE:
               this.dataProviderCollectionRemove(event);
               break;
            case CollectionEventKind.MOVE:
               break;
            case CollectionEventKind.REFRESH:
            case CollectionEventKind.RESET:
               this.dataProviderCollectionReset(event);
               break;
            case CollectionEventKind.UPDATE:
               this.dataProviderCollectionUpdate(event);
               break;
            case CollectionEventKind.REPLACE:
         }
      }
      
      private function dataProviderCollectionAdd(event:CollectionEvent) : void
      {
         var insertIndex:int = int(event.location);
         var insertLength:int = int(event.items.length);
         this.incrementIndicesGTE(this.visibleRowIndices,insertIndex,insertLength);
         this.incrementIndicesGTE(this.visibleRowSelectionIndices,insertIndex,insertLength);
      }
      
      private function dataProviderCollectionRemove(event:CollectionEvent) : void
      {
         var rowIndex:int = 0;
         var removeCount:int = 0;
         var visibleColCount:int = 0;
         var firstRendererOffset:int = 0;
         var eventItemsLength:uint = uint(event.items.length);
         var firstRemoveIndex:int = int(event.location);
         var lastRemoveIndex:int = event.location + event.items.length - 1;
         var firstVisibleOffset:int = -1;
         var lastVisibleOffset:int = -1;
         for(var offset:int = 0; offset < this.visibleRowIndices.length; offset++)
         {
            rowIndex = this.visibleRowIndices[offset];
            if(rowIndex >= firstRemoveIndex && rowIndex <= lastRemoveIndex)
            {
               if(firstVisibleOffset == -1)
               {
                  firstVisibleOffset = lastVisibleOffset = offset;
               }
               else
               {
                  lastVisibleOffset = offset;
               }
            }
            else if(rowIndex > lastRemoveIndex)
            {
               this.visibleRowIndices[offset] = rowIndex - eventItemsLength;
            }
         }
         if(firstVisibleOffset != -1 && lastVisibleOffset != -1)
         {
            removeCount = lastVisibleOffset - firstVisibleOffset + 1;
            this.visibleRowIndices.splice(firstVisibleOffset,removeCount);
            if(lastVisibleOffset < this.visibleRowBackgrounds.length)
            {
               this.freeGridElements(this.visibleRowBackgrounds.splice(firstVisibleOffset,removeCount));
            }
            if(lastVisibleOffset < this.visibleRowSeparators.length)
            {
               this.freeGridElements(this.visibleRowSeparators.splice(firstVisibleOffset,removeCount));
            }
            visibleColCount = int(this.visibleColumnIndices.length);
            firstRendererOffset = firstVisibleOffset * visibleColCount;
            this.freeItemRenderers(this.visibleItemRenderers.splice(firstRendererOffset,removeCount * visibleColCount));
         }
      }
      
      private function incrementIndicesGTE(indices:Vector.<int>, insertIndex:int, delta:int) : void
      {
         var index:int = 0;
         var indicesLength:int = int(indices.length);
         for(var i:int = 0; i < indicesLength; i++)
         {
            index = indices[i];
            if(index >= insertIndex)
            {
               indices[i] = index + delta;
            }
         }
      }
      
      private function dataProviderCollectionReset(event:CollectionEvent) : void
      {
         this.clearVirtualLayoutCache();
      }
      
      private function dataProviderCollectionUpdate(event:CollectionEvent) : void
      {
         var data:Object = null;
         var j:int = 0;
         var renderer:IGridItemRenderer = null;
         var itemsLength:int = int(event.items.length);
         var itemRenderersLength:int = int(this.visibleItemRenderers.length);
         for(var i:int = 0; i < itemsLength; i++)
         {
            data = PropertyChangeEvent(event.items[i]).source;
            for(j = 0; j < itemRenderersLength; j++)
            {
               renderer = this.visibleItemRenderers[j] as IGridItemRenderer;
               if(Boolean(renderer) && renderer.data == data)
               {
                  this.freeItemRenderer(renderer);
                  this.visibleItemRenderers[j] = null;
               }
            }
         }
      }
      
      public function columnsCollectionChanged(event:CollectionEvent) : void
      {
         switch(event.kind)
         {
            case CollectionEventKind.UPDATE:
               this.clearVirtualLayoutCache();
               break;
            default:
               this.clearVirtualLayoutCache();
               if(Boolean(this.grid))
               {
                  this.grid.setContentSize(0,0);
               }
         }
      }
      
      private function createGridElement(factory:IFactory) : IVisualElement
      {
         this.createdGridElement = true;
         var element:IVisualElement = factory.newInstance() as IVisualElement;
         this.elementToFactoryMap[element] = factory;
         return element;
      }
      
      private function allocateGridElement(factory:IFactory) : IVisualElement
      {
         var element:IVisualElement = null;
         this.createdGridElement = false;
         var elements:Vector.<IVisualElement> = this.freeElementMap[factory] as Vector.<IVisualElement>;
         if(Boolean(elements))
         {
            element = elements.pop();
            if(elements.length == 0)
            {
               delete this.freeElementMap[factory];
            }
            if(Boolean(element))
            {
               return element;
            }
         }
         return this.createGridElement(factory);
      }
      
      private function freeGridElement(element:IVisualElement) : Boolean
      {
         if(!element)
         {
            return false;
         }
         element.visible = false;
         var factory:IFactory = this.elementToFactoryMap[element];
         if(!factory)
         {
            return false;
         }
         var freeElements:Vector.<IVisualElement> = this.freeElementMap[factory];
         if(!freeElements)
         {
            freeElements = new Vector.<IVisualElement>();
            this.freeElementMap[factory] = freeElements;
         }
         freeElements.push(element);
         return true;
      }
      
      private function freeGridElements(elements:Vector.<IVisualElement>) : void
      {
         var elt:IVisualElement = null;
         for each(elt in elements)
         {
            this.freeGridElement(elt);
         }
         elements.length = 0;
      }
      
      private function removeGridElement(element:IVisualElement) : void
      {
         var factory:IFactory = null;
         var index:int = 0;
         factory = this.elementToFactoryMap[element];
         var freeElements:Vector.<IVisualElement> = Boolean(factory) ? this.freeElementMap[factory] : null;
         if(Boolean(freeElements))
         {
            index = freeElements.indexOf(element);
            if(index != -1)
            {
               freeElements.splice(index,1);
            }
            if(freeElements.length == 0)
            {
               delete this.freeElementMap[factory];
            }
         }
         delete this.elementToFactoryMap[element];
         element.visible = false;
         var parent:IVisualElementContainer = element.parent as IVisualElementContainer;
         if(Boolean(parent))
         {
            parent.removeElement(element);
         }
      }
      
      private function layoutItemRenderer(renderer:IGridItemRenderer, x:Number, y:Number, width:Number, height:Number) : void
      {
         var startTime:Number = NaN;
         var validateClientRenderer:ILayoutManagerClient = null;
         var graphicElementRenderer:IGraphicElement = null;
         var validateNowRenderer:IInvalidating = null;
         var elapsedTime:Number = NaN;
         if(this.enablePerformanceStatistics)
         {
            startTime = getTimer();
         }
         if(!isNaN(width) || !isNaN(height))
         {
            if(renderer is ILayoutManagerClient)
            {
               validateClientRenderer = renderer as ILayoutManagerClient;
               LayoutManager.getInstance().validateClient(validateClientRenderer,true);
            }
            else if(renderer is IGraphicElement)
            {
               graphicElementRenderer = renderer as IGraphicElement;
               graphicElementRenderer.validateProperties();
               graphicElementRenderer.validateSize();
            }
            renderer.setLayoutBoundsSize(width,height);
         }
         if(renderer is IInvalidating && !(renderer is IGraphicElement))
         {
            validateNowRenderer = renderer as IInvalidating;
            validateNowRenderer.validateNow();
         }
         renderer.setLayoutBoundsPosition(x,y);
         if(this.enablePerformanceStatistics)
         {
            elapsedTime = getTimer() - startTime;
            this.performanceStatistics.layoutGridElementTimes.push(elapsedTime);
         }
      }
      
      private function layoutGridElementR(elt:IVisualElement, bounds:Rectangle) : void
      {
         if(Boolean(bounds))
         {
            this.layoutGridElement(elt,bounds.x,bounds.y,bounds.width,bounds.height);
         }
      }
      
      private function layoutGridElement(elt:IVisualElement, x:Number, y:Number, width:Number, height:Number) : void
      {
         var scrollX:Number = NaN;
         var gridWidth:Number = NaN;
         var newX:Number = NaN;
         var newRight:Number = NaN;
         var scrollY:Number = NaN;
         var gridHeight:Number = NaN;
         var newY:Number = NaN;
         var newBottom:Number = NaN;
         if(width > MAX_ELEMENT_SIZE)
         {
            scrollX = Math.max(0,horizontalScrollPosition);
            gridWidth = Number(this.grid.getLayoutBoundsWidth());
            newX = Math.max(x,scrollX - ELEMENT_EDGE_PAD);
            newRight = Math.min(x + width,scrollX + gridWidth + ELEMENT_EDGE_PAD);
            x = newX;
            width = newRight - newX;
         }
         if(height > MAX_ELEMENT_SIZE)
         {
            scrollY = Math.max(0,verticalScrollPosition);
            gridHeight = Number(this.grid.getLayoutBoundsHeight());
            newY = Math.max(y,scrollY - ELEMENT_EDGE_PAD);
            newBottom = Math.min(y + height,scrollY + gridHeight + ELEMENT_EDGE_PAD);
            y = newY;
            height = newBottom - newY;
         }
         elt.setLayoutBoundsSize(width,height);
         elt.setLayoutBoundsPosition(x,y);
      }
      
      private function intializeGridVisualElement(elt:IVisualElement, rowIndex:int = -1, columnIndex:int = -1) : void
      {
         var gridVisualElement:IGridVisualElement = elt as IGridVisualElement;
         if(Boolean(gridVisualElement))
         {
            gridVisualElement.prepareGridVisualElement(this.grid,rowIndex,columnIndex);
         }
      }
      
      public function getVisibleRowIndices() : Vector.<int>
      {
         return this.visibleRowIndices.concat();
      }
      
      public function getVisibleColumnIndices() : Vector.<int>
      {
         return this.visibleColumnIndices.concat();
      }
      
      public function getCellBounds(rowIndex:int, columnIndex:int) : Rectangle
      {
         return this.gridDimensions.getCellBounds(rowIndex,columnIndex);
      }
      
      public function getRowBounds(rowIndex:int) : Rectangle
      {
         return this.gridDimensions.getRowBounds(rowIndex);
      }
      
      public function getColumnBounds(columnIndex:int) : Rectangle
      {
         return this.gridDimensions.getColumnBounds(columnIndex);
      }
      
      public function getRowIndexAt(x:Number, y:Number) : int
      {
         return this.gridDimensions.getRowIndexAt(x,y);
      }
      
      public function getColumnIndexAt(x:Number, y:Number) : int
      {
         return this.gridDimensions.getColumnIndexAt(x,y);
      }
      
      public function getCellAt(x:Number, y:Number) : CellPosition
      {
         var rowIndex:int = this.gridDimensions.getRowIndexAt(x,y);
         var columnIndex:int = this.gridDimensions.getColumnIndexAt(x,y);
         if(rowIndex == -1 || columnIndex == -1)
         {
            return null;
         }
         return new CellPosition(rowIndex,columnIndex);
      }
      
      public function getCellsAt(x:Number, y:Number, w:Number, h:Number) : Vector.<CellPosition>
      {
         var columnIndex:int = 0;
         var cells:Vector.<CellPosition> = new Vector.<CellPosition>();
         if(w <= 0 || h <= 0)
         {
            return cells;
         }
         var topLeft:CellPosition = this.getCellAt(x,y);
         var bottomRight:CellPosition = this.getCellAt(x + w,y + h);
         if(!topLeft || !bottomRight)
         {
            return cells;
         }
         for(var rowIndex:int = topLeft.rowIndex; rowIndex <= bottomRight.rowIndex; )
         {
            for(columnIndex = topLeft.columnIndex; columnIndex <= bottomRight.columnIndex; )
            {
               cells.push(new CellPosition(rowIndex,columnIndex));
               columnIndex++;
            }
            rowIndex++;
         }
         return cells;
      }
      
      public function getItemRendererAt(rowIndex:int, columnIndex:int) : IGridItemRenderer
      {
         var factory:IFactory = null;
         var visibleItemRenderer:IGridItemRenderer = this.getVisibleItemRenderer(rowIndex,columnIndex);
         if(Boolean(visibleItemRenderer))
         {
            return visibleItemRenderer;
         }
         var rendererLayer:GridLayer = this.getLayer("rendererLayer");
         if(!rendererLayer)
         {
            return null;
         }
         var dataItem:Object = this.getDataProviderItem(rowIndex);
         var column:GridColumn = this.getGridColumn(columnIndex);
         if(dataItem == null || column == null)
         {
            return null;
         }
         if(!column.visible)
         {
            return null;
         }
         factory = this.itemToRenderer(column,dataItem);
         var renderer:IGridItemRenderer = factory.newInstance() as IGridItemRenderer;
         this.createdGridElement = true;
         rendererLayer.addElement(renderer);
         this.initializeItemRenderer(renderer,rowIndex,columnIndex,dataItem,false);
         var bounds:Rectangle = this.gridDimensions.getCellBounds(rowIndex,columnIndex);
         if(bounds == null)
         {
            return null;
         }
         this.layoutItemRenderer(renderer,bounds.x,bounds.y,bounds.width,bounds.height);
         rendererLayer.removeElement(renderer);
         renderer.visible = false;
         return renderer;
      }
      
      public function isCellVisible(rowIndex:int, columnIndex:int) : Boolean
      {
         if(rowIndex == -1 && columnIndex == -1)
         {
            return false;
         }
         return (rowIndex == -1 || this.visibleRowIndices.indexOf(rowIndex) != -1) && (columnIndex == -1 || this.visibleColumnIndices.indexOf(columnIndex) != -1);
      }
      
      public function get performanceStatistics() : Object
      {
         return this._performanceStatistics;
      }
      
      public function get enablePerformanceStatistics() : Boolean
      {
         return this._enablePerformanceStatistics;
      }
      
      public function set enablePerformanceStatistics(value:Boolean) : void
      {
         if(value == this._enablePerformanceStatistics)
         {
            return;
         }
         if(value)
         {
            this._performanceStatistics = {
               "updateDisplayListTimes":new Vector.<Number>(),
               "updateDisplayListRectangles":new Vector.<Rectangle>(),
               "updateDisplayListCellCounts":new Vector.<int>(),
               "measureTimes":new Vector.<Number>(),
               "layoutGridElementTimes":new Vector.<Number>()
            };
         }
         this._enablePerformanceStatistics = value;
      }
   }
}

import flash.utils.getQualifiedClassName;
import mx.core.ClassFactory;
import mx.core.IFlexModuleFactory;
import spark.components.Grid;

class GridItemRendererClassFactory extends ClassFactory
{
   
   public var grid:Grid;
   
   public var factory:ClassFactory;
   
   public function GridItemRendererClassFactory(grid:Grid, factory:ClassFactory)
   {
      super(factory.generator);
      this.grid = grid;
      this.factory = factory;
   }
   
   override public function newInstance() : *
   {
      var moduleFactory:IFlexModuleFactory = null;
      var p:String = null;
      var factoryGenerator:Class = this.factory.generator;
      moduleFactory = this.grid.moduleFactory;
      var instance:Object = Boolean(moduleFactory) ? moduleFactory.create(getQualifiedClassName(factoryGenerator)) : new factoryGenerator();
      var factoryProperties:Object = this.factory.properties;
      if(Boolean(factoryProperties))
      {
         for(p in factoryProperties)
         {
            instance[p] = factoryProperties[p];
         }
      }
      return instance;
   }
}
