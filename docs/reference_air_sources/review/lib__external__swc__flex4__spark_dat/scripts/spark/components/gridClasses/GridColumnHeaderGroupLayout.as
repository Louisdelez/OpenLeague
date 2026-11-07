package spark.components.gridClasses
{
   import flash.geom.Rectangle;
   import flash.utils.Dictionary;
   import mx.collections.IList;
   import mx.core.IFactory;
   import mx.core.IVisualElement;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import spark.components.DataGrid;
   import spark.components.Grid;
   import spark.components.GridColumnHeaderGroup;
   import spark.components.Group;
   import spark.components.supportClasses.GroupBase;
   import spark.layouts.supportClasses.LayoutBase;
   
   [ExcludeClass]
   public class GridColumnHeaderGroupLayout extends LayoutBase
   {
      
      private var rendererLayer:Group;
      
      private var overlayLayer:Group;
      
      private const rendererHeights:Array = new Array();
      
      private var maxRendererHeight:Number = 0;
      
      private const visibleRenderersBounds:Rectangle = new Rectangle();
      
      private const visibleHeaderRenderers:Vector.<IGridItemRenderer> = new Vector.<IGridItemRenderer>();
      
      private const visibleHeaderSeparators:Vector.<IVisualElement> = new Vector.<IVisualElement>();
      
      private var freeElementMap:Dictionary = new Dictionary();
      
      private var elementToFactoryMap:Dictionary = new Dictionary();
      
      private var createdVisualElement:Boolean = false;
      
      private var _columns:IList;
      
      public function GridColumnHeaderGroupLayout()
      {
         super();
      }
      
      override public function set target(value:GroupBase) : void
      {
         super.target = value;
         var chg:GridColumnHeaderGroup = value as GridColumnHeaderGroup;
         if(Boolean(chg))
         {
            this.rendererLayer = new Group();
            this.rendererLayer.layout = new LayoutBase();
            chg.addElement(this.rendererLayer);
            this.overlayLayer = new Group();
            this.overlayLayer.layout = new LayoutBase();
            chg.addElement(this.overlayLayer);
         }
      }
      
      override public function get useVirtualLayout() : Boolean
      {
         return true;
      }
      
      override public function set useVirtualLayout(value:Boolean) : void
      {
      }
      
      override public function clearVirtualLayoutCache() : void
      {
         this.rendererHeights.length = 0;
         this.visibleHeaderRenderers.length = 0;
         this.visibleHeaderSeparators.length = 0;
         this.visibleRenderersBounds.setEmpty();
         this.elementToFactoryMap = new Dictionary();
         this.freeElementMap = new Dictionary();
         if(Boolean(this.rendererLayer))
         {
            this.rendererLayer.removeAllElements();
         }
         if(Boolean(this.overlayLayer))
         {
            this.overlayLayer.removeAllElements();
         }
      }
      
      override protected function scrollPositionChanged() : void
      {
         var columnHeaderGroup:GridColumnHeaderGroup = this.columnHeaderGroup;
         if(!columnHeaderGroup)
         {
            return;
         }
         super.scrollPositionChanged();
         var scrollR:Rectangle = columnHeaderGroup.scrollRect;
         if(Boolean(scrollR) && !this.visibleRenderersBounds.containsRect(scrollR))
         {
            columnHeaderGroup.invalidateDisplayList();
         }
      }
      
      override public function measure() : void
      {
         var columnHeaderGroup:GridColumnHeaderGroup = this.columnHeaderGroup;
         var grid:Grid = this.grid;
         if(!columnHeaderGroup || !grid)
         {
            return;
         }
         this.updateRendererHeights();
         var paddingLeft:Number = Number(columnHeaderGroup.getStyle("paddingLeft"));
         var paddingRight:Number = Number(columnHeaderGroup.getStyle("paddingRight"));
         var paddingTop:Number = Number(columnHeaderGroup.getStyle("paddingTop"));
         var paddingBottom:Number = Number(columnHeaderGroup.getStyle("paddingBottom"));
         var measuredWidth:Number = Math.ceil(paddingLeft + paddingRight);
         var measuredHeight:Number = Math.ceil(this.maxRendererHeight + paddingTop + paddingBottom);
         columnHeaderGroup.measuredWidth = Math.max(measuredWidth,columnHeaderGroup.minWidth);
         columnHeaderGroup.measuredHeight = Math.max(measuredHeight,columnHeaderGroup.minHeight);
      }
      
      override public function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var renderer:IGridItemRenderer = null;
         var separator:IVisualElement = null;
         var column:GridColumn = null;
         var paddingLeft:Number = NaN;
         var paddingRight:Number = NaN;
         var paddingTop:Number = NaN;
         var paddingBottom:Number = NaN;
         var columns:IList = null;
         var columnsLength:int = 0;
         var isLastColumn:Boolean = false;
         var rendererX:Number = NaN;
         var rendererWidth:Number = NaN;
         var factory:IFactory = null;
         var separatorWidth:Number = NaN;
         var separatorX:Number = NaN;
         var columnHeaderGroup:GridColumnHeaderGroup = this.columnHeaderGroup;
         var grid:Grid = this.grid;
         if(!columnHeaderGroup || !grid)
         {
            return;
         }
         var visibleColumnIndices:Vector.<int> = grid.getVisibleColumnIndices();
         var oldRenderers:Array = [];
         var rendererLayer:Group = this.rendererLayer;
         var overlayLayer:Group = this.overlayLayer;
         var columnSeparatorFactory:IFactory = columnHeaderGroup.columnSeparator;
         var columnIndex:int = -1;
         for each(renderer in this.visibleHeaderRenderers)
         {
            column = renderer.column;
            columnIndex = Boolean(column) ? column.columnIndex : -1;
            if(columnIndex != -1 && visibleColumnIndices.indexOf(columnIndex) != -1 && oldRenderers[columnIndex] == null)
            {
               oldRenderers[columnIndex] = renderer;
            }
            else
            {
               this.freeVisualElement(renderer);
               renderer.discard(true);
            }
         }
         this.visibleHeaderRenderers.length = 0;
         for each(separator in this.visibleHeaderSeparators)
         {
            this.freeVisualElement(separator);
         }
         this.visibleHeaderSeparators.length = 0;
         paddingLeft = Number(columnHeaderGroup.getStyle("paddingLeft"));
         paddingRight = Number(columnHeaderGroup.getStyle("paddingRight"));
         paddingTop = Number(columnHeaderGroup.getStyle("paddingTop"));
         paddingBottom = Number(columnHeaderGroup.getStyle("paddingBottom"));
         columns = this.columns;
         columnsLength = Boolean(columns) ? int(columns.length) : 0;
         var lastVisibleColumnIndex:int = grid.getPreviousVisibleColumnIndex(columnsLength);
         var rendererY:Number = paddingTop;
         var rendererHeight:Number = unscaledHeight - paddingTop - paddingBottom;
         var maxRendererX:Number = columnHeaderGroup.horizontalScrollPosition + unscaledWidth;
         var visibleLeft:Number = 0;
         var visibleRight:Number = 0;
         for(var index:int = 0; true; index++)
         {
            if(index < visibleColumnIndices.length)
            {
               columnIndex = visibleColumnIndices[index];
            }
            else
            {
               columnIndex = grid.getNextVisibleColumnIndex(columnIndex);
            }
            if(columnIndex < 0 || columnIndex >= columnsLength)
            {
               break;
            }
            column = columns.getItemAt(columnIndex) as GridColumn;
            renderer = oldRenderers[columnIndex];
            oldRenderers[columnIndex] = null;
            if(!renderer)
            {
               factory = column.headerRenderer;
               if(!factory)
               {
                  factory = columnHeaderGroup.headerRenderer;
               }
               renderer = this.allocateVisualElement(factory) as IGridItemRenderer;
            }
            this.visibleHeaderRenderers.push(renderer);
            this.initializeItemRenderer(renderer,columnIndex,column,true);
            if(renderer.parent != rendererLayer)
            {
               rendererLayer.addElement(renderer);
            }
            isLastColumn = columnIndex == lastVisibleColumnIndex;
            rendererX = grid.getCellX(0,columnIndex) + paddingLeft;
            rendererWidth = grid.getColumnWidth(columnIndex);
            if(isLastColumn)
            {
               rendererWidth = horizontalScrollPosition + unscaledWidth - rendererX - paddingRight;
            }
            renderer.setLayoutBoundsSize(rendererWidth,rendererHeight);
            renderer.setLayoutBoundsPosition(rendererX,rendererY);
            if(index == 0)
            {
               visibleLeft = rendererX;
            }
            visibleRight = rendererX + rendererWidth;
            renderer.prepare(!this.createdVisualElement);
            if(rendererX + rendererWidth > maxRendererX)
            {
               break;
            }
            if(Boolean(columnSeparatorFactory) && !isLastColumn)
            {
               separator = this.allocateVisualElement(columnSeparatorFactory);
               this.visibleHeaderSeparators.push(separator);
               separator.visible = true;
               if(separator.parent != overlayLayer)
               {
                  overlayLayer.addElement(separator);
               }
               separatorWidth = Number(separator.getPreferredBoundsWidth());
               separatorX = rendererX + rendererWidth;
               separator.setLayoutBoundsSize(separatorWidth,rendererHeight);
               separator.setLayoutBoundsPosition(separatorX,rendererY);
            }
         }
         columnHeaderGroup.setContentSize(grid.contentWidth,rendererHeight);
         this.visibleRenderersBounds.left = visibleLeft - paddingLeft;
         this.visibleRenderersBounds.right = visibleRight = paddingRight;
         this.visibleRenderersBounds.top = rendererY - paddingTop;
         this.visibleRenderersBounds.height = rendererHeight + paddingTop + paddingBottom;
         columnHeaderGroup.validateNow();
         this.updateRendererHeights(true);
      }
      
      public function getHeaderIndexAt(x:Number, y:Number) : int
      {
         var paddingLeft:Number = NaN;
         var contentWidth:Number = NaN;
         var totalWidth:Number = NaN;
         var columnHeaderGroup:GridColumnHeaderGroup = this.columnHeaderGroup;
         var grid:Grid = this.grid;
         var columns:IList = this.columns;
         if(!columnHeaderGroup || !grid || !columns)
         {
            return -1;
         }
         paddingLeft = Number(columnHeaderGroup.getStyle("paddingLeft"));
         var paddedX:Number = x + paddingLeft;
         var columnIndex:int = grid.getColumnIndexAt(paddedX,0);
         if(columnIndex < 0)
         {
            contentWidth = columnHeaderGroup.contentWidth;
            totalWidth = horizontalScrollPosition + columnHeaderGroup.width - columnHeaderGroup.getStyle("paddingRight");
            if(paddedX >= contentWidth && paddedX < totalWidth)
            {
               columnIndex = grid.getPreviousVisibleColumnIndex(columns.length);
            }
         }
         return columnIndex;
      }
      
      public function getSeparatorIndexAt(x:Number, y:Number) : int
      {
         var paddingLeft:Number = NaN;
         var columnLeft:Number = NaN;
         var columnHeaderGroup:GridColumnHeaderGroup = this.columnHeaderGroup;
         var grid:Grid = this.grid;
         var columns:IList = this.columns;
         if(!columnHeaderGroup || !grid || !columns)
         {
            return -1;
         }
         paddingLeft = Number(columnHeaderGroup.getStyle("paddingLeft"));
         var columnIndex:int = grid.getColumnIndexAt(x + paddingLeft,0);
         if(columnIndex == -1)
         {
            return -1;
         }
         var isFirstColumn:Boolean = columnIndex == grid.getNextVisibleColumnIndex(-1);
         var isLastColumn:Boolean = columnIndex == grid.getPreviousVisibleColumnIndex(columns.length);
         columnLeft = grid.getCellX(0,columnIndex);
         var columnRight:Number = columnLeft + grid.getColumnWidth(columnIndex);
         var smw:Number = Number(columnHeaderGroup.getStyle("separatorAffordance"));
         if(!isFirstColumn && x > columnLeft - smw && x < columnLeft + smw)
         {
            return grid.getPreviousVisibleColumnIndex(columnIndex);
         }
         if(!isLastColumn && x > columnRight - smw && x < columnRight + smw)
         {
            return columnIndex;
         }
         return -1;
      }
      
      public function getHeaderBounds(columnIndex:int) : Rectangle
      {
         var columns:IList = null;
         var paddingTop:Number = NaN;
         var paddingBottom:Number = NaN;
         var columnHeaderGroup:GridColumnHeaderGroup = this.columnHeaderGroup;
         var grid:Grid = this.grid;
         if(!columnHeaderGroup || !grid)
         {
            return null;
         }
         columns = this.columns;
         var columnsLength:int = Boolean(columns) ? int(columns.length) : 0;
         if(columnIndex >= columnsLength)
         {
            return null;
         }
         var column:GridColumn = columns.getItemAt(columnIndex) as GridColumn;
         if(!column.visible)
         {
            return null;
         }
         var paddingLeft:Number = Number(columnHeaderGroup.getStyle("paddingLeft"));
         var paddingRight:Number = Number(columnHeaderGroup.getStyle("paddingRight"));
         paddingTop = Number(columnHeaderGroup.getStyle("paddingTop"));
         paddingBottom = Number(columnHeaderGroup.getStyle("paddingBottom"));
         var isLastColumn:Boolean = columnIndex == grid.getPreviousVisibleColumnIndex(columnsLength);
         var rendererX:Number = grid.getCellX(0,columnIndex) + paddingLeft;
         var rendererY:Number = paddingTop;
         var rendererWidth:Number = grid.getColumnWidth(columnIndex);
         var rendererHeight:Number = columnHeaderGroup.height - paddingTop - paddingBottom;
         if(isLastColumn)
         {
            rendererWidth = horizontalScrollPosition + columnHeaderGroup.width - rendererX - paddingRight;
         }
         return new Rectangle(rendererX,rendererY,rendererWidth,rendererHeight);
      }
      
      public function getHeaderRendererAt(columnIndex:int) : IGridItemRenderer
      {
         var visibleColumnIndices:Vector.<int> = null;
         var paddingLeft:Number = NaN;
         var paddingTop:Number = NaN;
         var paddingBottom:Number = NaN;
         var rendererLayerNumElements:int = 0;
         var index:int = 0;
         var elt:IGridItemRenderer = null;
         var columnHeaderGroup:GridColumnHeaderGroup = this.columnHeaderGroup;
         var grid:Grid = this.grid;
         if(!columnHeaderGroup || !grid || columnIndex < 0)
         {
            return null;
         }
         var rendererLayer:Group = this.rendererLayer;
         visibleColumnIndices = grid.getVisibleColumnIndices();
         var eltIndex:int = visibleColumnIndices.indexOf(columnIndex);
         if(eltIndex != -1)
         {
            rendererLayerNumElements = rendererLayer.numElements;
            for(index = 0; index < rendererLayerNumElements; index++)
            {
               elt = rendererLayer.getElementAt(index) as IGridItemRenderer;
               if(Boolean(elt && elt.visible) && Boolean(elt.column) && elt.column.columnIndex == columnIndex)
               {
                  return elt;
               }
            }
            return null;
         }
         var columns:IList = this.columns;
         if(!columns || columns.length <= columnIndex)
         {
            return null;
         }
         var column:GridColumn = columns.getItemAt(columnIndex) as GridColumn;
         if(!column.visible)
         {
            return null;
         }
         var factory:IFactory = column.headerRenderer;
         if(!factory)
         {
            factory = columnHeaderGroup.headerRenderer;
         }
         var renderer:IGridItemRenderer = this.allocateVisualElement(factory) as IGridItemRenderer;
         rendererLayer.addElement(renderer);
         this.initializeItemRenderer(renderer,columnIndex,column,renderer.visible);
         paddingLeft = Number(columnHeaderGroup.getStyle("paddingLeft"));
         var paddingRight:Number = Number(columnHeaderGroup.getStyle("paddingRight"));
         paddingTop = Number(columnHeaderGroup.getStyle("paddingTop"));
         paddingBottom = Number(columnHeaderGroup.getStyle("paddingBottom"));
         var isLastColumn:Boolean = columnIndex == grid.getPreviousVisibleColumnIndex(columns.length);
         var rendererX:Number = grid.getCellX(0,columnIndex) + paddingLeft;
         var rendererY:Number = paddingTop;
         var rendererHeight:Number = columnHeaderGroup.height - paddingTop - paddingBottom;
         var rendererWidth:Number = grid.getColumnWidth(columnIndex);
         if(isLastColumn)
         {
            rendererWidth = horizontalScrollPosition + columnHeaderGroup.width - rendererX - paddingRight;
         }
         renderer.setLayoutBoundsSize(rendererWidth,rendererHeight);
         renderer.setLayoutBoundsPosition(rendererX,rendererY);
         rendererLayer.removeElement(renderer);
         renderer.visible = false;
         return renderer;
      }
      
      private function initializeItemRenderer(renderer:IGridItemRenderer, columnIndex:int, column:GridColumn, visible:Boolean = true) : void
      {
         var columnHeaderGroup:GridColumnHeaderGroup = null;
         renderer.visible = visible;
         renderer.column = column;
         renderer.label = column.headerText;
         columnHeaderGroup = this.columnHeaderGroup;
         var dataGrid:DataGrid = columnHeaderGroup.dataGrid;
         if(Boolean(dataGrid))
         {
            renderer.owner = dataGrid;
         }
         renderer.hovered = columnIndex == columnHeaderGroup.hoverColumnIndex;
         renderer.down = columnIndex == columnHeaderGroup.downColumnIndex;
      }
      
      private function createVisualElement(factory:IFactory) : IVisualElement
      {
         this.createdVisualElement = true;
         var newElement:IVisualElement = factory.newInstance() as IVisualElement;
         this.elementToFactoryMap[newElement] = factory;
         return newElement;
      }
      
      private function allocateVisualElement(factory:IFactory) : IVisualElement
      {
         var freeElement:IVisualElement = null;
         this.createdVisualElement = false;
         var freeElements:Vector.<IVisualElement> = this.freeElementMap[factory] as Vector.<IVisualElement>;
         if(Boolean(freeElements))
         {
            freeElement = freeElements.pop();
            if(freeElements.length == 0)
            {
               delete this.freeElementMap[factory];
            }
            if(Boolean(freeElement))
            {
               return freeElement;
            }
         }
         return this.createVisualElement(factory);
      }
      
      private function freeVisualElement(element:IVisualElement) : void
      {
         var factory:IFactory = this.elementToFactoryMap[element];
         var freeElements:Vector.<IVisualElement> = this.freeElementMap[factory];
         if(!freeElements)
         {
            freeElements = new Vector.<IVisualElement>();
            this.freeElementMap[factory] = freeElements;
         }
         freeElements.push(element);
         element.visible = false;
      }
      
      private function updateRendererHeights(inUpdateDisplayList:Boolean = false) : void
      {
         var renderer:IGridItemRenderer = null;
         var preferredHeight:Number = NaN;
         var i:int = 0;
         var rendererHeight:Number = NaN;
         var columns:IList = this.columns;
         this.rendererHeights.length = Boolean(columns) ? uint(columns.length) : 0;
         var newHeight:Number = 0;
         for each(renderer in this.visibleHeaderRenderers)
         {
            preferredHeight = Number(renderer.getPreferredBoundsHeight());
            this.rendererHeights[renderer.column.columnIndex] = preferredHeight;
            if(preferredHeight > newHeight)
            {
               newHeight = preferredHeight;
            }
         }
         if(newHeight == this.maxRendererHeight)
         {
            return;
         }
         if(newHeight < this.maxRendererHeight)
         {
            for(i = 0; i < this.rendererHeights.length; i++)
            {
               rendererHeight = Number(this.rendererHeights[i]);
               if(!isNaN(rendererHeight) && rendererHeight > newHeight)
               {
                  newHeight = rendererHeight;
               }
            }
         }
         this.maxRendererHeight = newHeight;
         if(inUpdateDisplayList)
         {
            this.columnHeaderGroup.invalidateSize();
         }
      }
      
      private function get columnHeaderGroup() : GridColumnHeaderGroup
      {
         return target as GridColumnHeaderGroup;
      }
      
      private function get grid() : Grid
      {
         var chg:GridColumnHeaderGroup = this.columnHeaderGroup;
         if(Boolean(chg.dataGrid))
         {
            return chg.dataGrid.grid;
         }
         return null;
      }
      
      private function get columns() : IList
      {
         var grid:Grid = null;
         grid = this.grid;
         var newColumns:IList = Boolean(grid) ? grid.columns : null;
         if(newColumns != this._columns)
         {
            if(Boolean(this._columns))
            {
               this._columns.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.columns_collectionChangeHandler);
            }
            this._columns = newColumns;
            if(Boolean(this._columns))
            {
               this._columns.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.columns_collectionChangeHandler);
            }
         }
         return this._columns;
      }
      
      private function columns_collectionChangeHandler(event:CollectionEvent) : void
      {
         switch(event.kind)
         {
            case CollectionEventKind.ADD:
               this.columns_collectionChangeAdd(event);
               break;
            case CollectionEventKind.REMOVE:
               this.columns_collectionChangeRemove(event);
               break;
            case CollectionEventKind.MOVE:
               this.columns_collectionChangeMove(event);
               break;
            case CollectionEventKind.REPLACE:
            case CollectionEventKind.UPDATE:
               break;
            case CollectionEventKind.REFRESH:
            case CollectionEventKind.RESET:
               this.columnHeaderGroup.visibleSortIndicatorIndices = null;
         }
      }
      
      private function columns_collectionChangeAdd(event:CollectionEvent) : void
      {
         var chg:GridColumnHeaderGroup = null;
         var indices:Vector.<int> = null;
         var itemsLength:int = int(event.items.length);
         if(itemsLength <= 0)
         {
            return;
         }
         chg = this.columnHeaderGroup;
         indices = chg.visibleSortIndicatorIndices;
         var indicesLength:int = int(indices.length);
         var startIndex:int = int(event.location);
         for(var i:int = 0; i < indicesLength; i++)
         {
            if(indices[i] >= startIndex)
            {
               indices[i] += itemsLength;
            }
         }
         chg.visibleSortIndicatorIndices = indices;
      }
      
      private function columns_collectionChangeRemove(event:CollectionEvent) : void
      {
         var chg:GridColumnHeaderGroup = null;
         var indices:Vector.<int> = null;
         var startIndex:int = 0;
         var index:int = 0;
         var itemsLength:int = int(event.items.length);
         if(itemsLength <= 0)
         {
            return;
         }
         chg = this.columnHeaderGroup;
         indices = chg.visibleSortIndicatorIndices;
         var indicesLength:int = int(indices.length);
         startIndex = int(event.location);
         var lastIndex:int = startIndex + itemsLength;
         var newIndices:Vector.<int> = new Vector.<int>();
         for each(index in indices)
         {
            if(index < startIndex)
            {
               newIndices.push(index);
            }
            else if(index >= lastIndex)
            {
               newIndices.push(index - lastIndex);
            }
         }
         chg.visibleSortIndicatorIndices = newIndices;
      }
      
      private function columns_collectionChangeMove(event:CollectionEvent) : void
      {
         var chg:GridColumnHeaderGroup = null;
         var indices:Vector.<int> = null;
         var index:int = 0;
         var itemsLength:int = int(event.items.length);
         if(itemsLength <= 0)
         {
            return;
         }
         chg = this.columnHeaderGroup;
         indices = chg.visibleSortIndicatorIndices;
         var indicesLength:int = int(indices.length);
         var oldStart:int = int(event.oldLocation);
         var oldEnd:int = event.oldLocation + itemsLength;
         var newStart:int = int(event.location);
         var newEnd:int = event.location + itemsLength;
         for(var i:int = 0; i < indicesLength; i++)
         {
            index = indices[i];
            if(index >= oldStart && index < oldEnd)
            {
               indices[i] = newStart + (index - oldStart);
            }
            else if(newStart > oldStart)
            {
               if(index >= oldEnd && index < newEnd)
               {
                  indices[i] -= itemsLength;
               }
            }
            else if(newStart < oldStart)
            {
               if(index >= newStart && index < oldStart)
               {
                  indices[i] += itemsLength;
               }
            }
         }
         chg.visibleSortIndicatorIndices = indices;
      }
   }
}

