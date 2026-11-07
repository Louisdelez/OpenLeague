package mx.printing
{
   import flash.events.KeyboardEvent;
   import mx.collections.CursorBookmark;
   import mx.controls.AdvancedDataGrid;
   import mx.controls.advancedDataGridClasses.AdvancedDataGridColumn;
   import mx.core.EdgeMetrics;
   import mx.core.ScrollPolicy;
   import mx.events.AdvancedDataGridEvent;
   
   [Exclude(name="showEffect",kind="effect")]
   [Exclude(name="rollOverEffect",kind="effect")]
   [Exclude(name="rollOutEffect",kind="effect")]
   [Exclude(name="resizeEffect",kind="effect")]
   [Exclude(name="removedEffect",kind="effect")]
   [Exclude(name="moveEffect",kind="effect")]
   [Exclude(name="mouseUpEffect",kind="effect")]
   [Exclude(name="mouseDownEffect",kind="effect")]
   [Exclude(name="hideEffect",kind="effect")]
   [Exclude(name="focusOutEffect",kind="effect")]
   [Exclude(name="focusInEffect",kind="effect")]
   [Exclude(name="creationCompleteEffect",kind="effect")]
   [Exclude(name="addedEffect",kind="effect")]
   [Exclude(name="verticalScrollBarStyleName",kind="style")]
   [Exclude(name="useRollOver",kind="style")]
   [Exclude(name="textSelectedColor",kind="style")]
   [Exclude(name="textRollOverColor",kind="style")]
   [Exclude(name="strechCursor",kind="style")]
   [Exclude(name="selectionEasingFunction",kind="style")]
   [Exclude(name="selectionDuration",kind="style")]
   [Exclude(name="selectionDisabledColor",kind="style")]
   [Exclude(name="selectionColor",kind="style")]
   [Exclude(name="rollOverColor",kind="style")]
   [Exclude(name="horizontalScrollBarStyleName",kind="style")]
   [Exclude(name="headerDragProxyStyleName",kind="style")]
   [Exclude(name="dropIndicatorSkin",kind="style")]
   [Exclude(name="columnResizeSkin",kind="style")]
   [Exclude(name="columnDropIndicatorSkin",kind="style")]
   [Exclude(name="toolTipStart",kind="event")]
   [Exclude(name="toolTipShown",kind="event")]
   [Exclude(name="toolTipShow",kind="event")]
   [Exclude(name="toolTipHide",kind="event")]
   [Exclude(name="toolTipEnd",kind="event")]
   [Exclude(name="toolTipCreate",kind="event")]
   [Exclude(name="rollOver",kind="event")]
   [Exclude(name="rollOut",kind="event")]
   [Exclude(name="mouseWheelOutside",kind="event")]
   [Exclude(name="mouseWheel",kind="event")]
   [Exclude(name="mouseUp",kind="event")]
   [Exclude(name="mouseOver",kind="event")]
   [Exclude(name="mouseOut",kind="event")]
   [Exclude(name="mouseMove",kind="event")]
   [Exclude(name="mouseFocusChange",kind="event")]
   [Exclude(name="mouseDownOutside",kind="event")]
   [Exclude(name="mouseDown",kind="event")]
   [Exclude(name="keyUp",kind="event")]
   [Exclude(name="keyDown",kind="event")]
   [Exclude(name="itemRollOver",kind="event")]
   [Exclude(name="itemRollOut",kind="event")]
   [Exclude(name="itemFocusOut",kind="event")]
   [Exclude(name="itemFocusIn",kind="event")]
   [Exclude(name="itemEditEnd",kind="event")]
   [Exclude(name="itemEditBeginning",kind="event")]
   [Exclude(name="itemEditBegin",kind="event")]
   [Exclude(name="itemDoubleClick",kind="event")]
   [Exclude(name="itemClick",kind="event")]
   [Exclude(name="headerRelease",kind="event")]
   [Exclude(name="effectStart",kind="event")]
   [Exclude(name="effectEnd",kind="event")]
   [Exclude(name="dragOver",kind="event")]
   [Exclude(name="dragExit",kind="event")]
   [Exclude(name="dragEnter",kind="event")]
   [Exclude(name="dragDrop",kind="event")]
   [Exclude(name="dragComplete",kind="event")]
   [Exclude(name="doubleClick",kind="event")]
   [Exclude(name="click",kind="event")]
   [Exclude(name="expandItemHandler",kind="method")]
   [Exclude(name="setScrollBarProperties",kind="method")]
   [Exclude(name="selectItem",kind="method")]
   [Exclude(name="removeIndicators",kind="method")]
   [Exclude(name="placeSortArrow",kind="method")]
   [Exclude(name="moveSelectionVertically",kind="method")]
   [Exclude(name="moveSelectionHorizontally",kind="method")]
   [Exclude(name="mouseWheelHandler",kind="method")]
   [Exclude(name="mouseUpHandler",kind="method")]
   [Exclude(name="mouseOverHandler",kind="method")]
   [Exclude(name="mouseOutHandler",kind="method")]
   [Exclude(name="mouseMoveHandler",kind="method")]
   [Exclude(name="mouseEventToItemRenderer",kind="method")]
   [Exclude(name="mouseDownHandler",kind="method")]
   [Exclude(name="mouseDoubleClickHandler",kind="method")]
   [Exclude(name="mouseClickHandler",kind="method")]
   [Exclude(name="drawSelectionIndicator",kind="method")]
   [Exclude(name="drawHighlightIndicator",kind="method")]
   [Exclude(name="drawCaretIndicator",kind="method")]
   [Exclude(name="dragScroll",kind="method")]
   [Exclude(name="dragOverHandler",kind="method")]
   [Exclude(name="dragExitHandler",kind="method")]
   [Exclude(name="dragEnterHandler",kind="method")]
   [Exclude(name="dragDropHandler",kind="method")]
   [Exclude(name="dragCompleteHandler",kind="method")]
   [Exclude(name="startDrag",kind="method")]
   [Exclude(name="showDropFeedback",kind="method")]
   [Exclude(name="isItemSelected",kind="method")]
   [Exclude(name="isItemHighlighted",kind="method")]
   [Exclude(name="hideDropFeedback",kind="method")]
   [Exclude(name="endEffectStarted",kind="method")]
   [Exclude(name="effectStarted",kind="method")]
   [Exclude(name="effectFinished",kind="method")]
   [Exclude(name="destroyItemEditor",kind="method")]
   [Exclude(name="createItemEditor",kind="method")]
   [Exclude(name="calculateDropIndex",kind="method")]
   [Exclude(name="showCaret",kind="property")]
   [Exclude(name="selectionTweens",kind="property")]
   [Exclude(name="selectionLayer",kind="property")]
   [Exclude(name="lastDropIndex",kind="property")]
   [Exclude(name="keySelectionPending",kind="property")]
   [Exclude(name="highlightUID",kind="property")]
   [Exclude(name="highlightIndicator",kind="property")]
   [Exclude(name="dragImageOffsets",kind="property")]
   [Exclude(name="dragImage",kind="property")]
   [Exclude(name="caretUID",kind="property")]
   [Exclude(name="caretItemRenderer",kind="property")]
   [Exclude(name="caretIndicator",kind="property")]
   [Exclude(name="caretIndex",kind="property")]
   [Exclude(name="caretBookmark",kind="property")]
   [Exclude(name="anchorIndex",kind="property")]
   [Exclude(name="anchorBookmark",kind="property")]
   [Exclude(name="verticalScrollPolicy",kind="property")]
   [Exclude(name="verticalScrollBar",kind="property")]
   [Exclude(name="useHandCursor",kind="property")]
   [Exclude(name="toolTip",kind="property")]
   [Exclude(name="showScrollTips",kind="property")]
   [Exclude(name="selectedItems",kind="property")]
   [Exclude(name="selectedItem",kind="property")]
   [Exclude(name="selectedIndices",kind="property")]
   [Exclude(name="selectedIndex",kind="property")]
   [Exclude(name="selectable",kind="property")]
   [Exclude(name="scrollTipFunction",kind="property")]
   [Exclude(name="maxVerticalScrollPosition",kind="property")]
   [Exclude(name="maxHorizontalScrollPosition",kind="property")]
   [Exclude(name="horizontalScrollPolicy",kind="property")]
   [Exclude(name="horizontalScrollBar",kind="property")]
   [Exclude(name="editedItemRenderer",kind="property")]
   [Exclude(name="editedItemPosition",kind="property")]
   [Exclude(name="editable",kind="property")]
   [Exclude(name="dropTarget",kind="property")]
   [Exclude(name="dropEnabled",kind="property")]
   [Exclude(name="dragMoveEnabled",kind="property")]
   [Exclude(name="draggableColumns",kind="property")]
   [Exclude(name="dragEnabled",kind="property")]
   [Exclude(name="doubleClickEnabled",kind="property")]
   [Exclude(name="dataTipFunction",kind="property")]
   [Exclude(name="dataTipField",kind="property")]
   [Exclude(name="allowMultipleSelection",kind="property")]
   [Exclude(name="allowDragSelection",kind="property")]
   public class PrintAdvancedDataGrid extends AdvancedDataGrid
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      private var defaultLeafIconClass:Class;
      
      private var folderOpenIconClass:Class;
      
      public var sizeToPage:Boolean = true;
      
      private var previousPageRowCount:int = 0;
      
      private var displayIconsChanged:Boolean;
      
      private var folderClosedIconClass:Class;
      
      private var _source:AdvancedDataGrid;
      
      private var _displayIcons:Boolean = true;
      
      private var _allowInteraction:Boolean;
      
      private var _currentPageHeight:Number;
      
      private var _originalHeight:Number;
      
      public function PrintAdvancedDataGrid()
      {
         super();
         horizontalScrollPolicy = ScrollPolicy.OFF;
         verticalScrollPolicy = ScrollPolicy.OFF;
         sortableColumns = false;
         selectable = false;
         dragEnabled = true;
         resizableColumns = false;
         mouseChildren = false;
         super.percentHeight = 100;
      }
      
      public function get allowInteraction() : Boolean
      {
         return _allowInteraction;
      }
      
      public function set allowInteraction(value:Boolean) : void
      {
         _allowInteraction = value;
         if(value)
         {
            mouseChildren = true;
            resizableColumns = true;
         }
         else
         {
            mouseChildren = false;
            resizableColumns = false;
         }
      }
      
      public function moveToFirstPage() : void
      {
         iterator.seek(CursorBookmark.FIRST);
         verticalScrollPosition = 0;
         invalidateSize();
         invalidateDisplayList();
      }
      
      override public function set percentHeight(value:Number) : void
      {
         _originalHeight = NaN;
         super.percentHeight = value;
      }
      
      public function get source() : AdvancedDataGrid
      {
         return _source;
      }
      
      public function previousPage() : void
      {
         if(verticalScrollPosition > 0)
         {
            verticalScrollPosition = Math.max(0,verticalScrollPosition - previousPageRowCount);
            invalidateSize();
            invalidateDisplayList();
         }
      }
      
      [PercentProxy("percentHeight")]
      [Inspectable(category="General")]
      [Bindable("heightChanged")]
      override public function get height() : Number
      {
         return super.height;
      }
      
      public function nextPage() : void
      {
         previousPageRowCount = rowCount - lockedRowCount;
         if(verticalScrollPosition < dataProvider.length)
         {
            verticalScrollPosition += rowCount - lockedRowCount;
            itemsSizeChanged = true;
            invalidateSize();
            invalidateDisplayList();
         }
      }
      
      private function measureHeight() : void
      {
         if(Boolean(dataProvider) && Boolean(dataProvider.length > 0) && verticalScrollPosition >= dataProvider.length)
         {
            setRowCount(0);
            measuredHeight = 0;
            measuredMinHeight = 0;
            return;
         }
         var o:EdgeMetrics = viewMetrics;
         var rc:int = explicitRowCount < 1 ? rowCount : explicitRowCount;
         var maxHeight:Number = isNaN(_originalHeight) ? -1 : _originalHeight - o.top - o.bottom;
         measuredHeight = measureHeightOfItemsUptoMaxHeight(-1,rc,maxHeight) + o.top + o.bottom;
         measuredMinHeight = measureHeightOfItemsUptoMaxHeight(-1,Math.min(rc,2),maxHeight) + o.top + o.bottom;
      }
      
      override protected function configureScrollBars() : void
      {
      }
      
      override public function setActualSize(w:Number, h:Number) : void
      {
         if(!isNaN(percentHeight))
         {
            _originalHeight = h;
            super.percentHeight = NaN;
            measure();
            h = Number(measuredHeight);
         }
         super.setActualSize(w,h);
         invalidateDisplayList();
         if(sizeToPage && !isNaN(explicitHeight))
         {
            explicitHeight = NaN;
         }
      }
      
      public function set source(value:AdvancedDataGrid) : void
      {
         var groupColumnsArray:Array = null;
         var columnArray:Array = null;
         var i:int = 0;
         var sourceColumn:AdvancedDataGridColumn = null;
         var col:AdvancedDataGridColumn = null;
         _source = value;
         this.dataProvider = value.dataProvider;
         if(value.groupedColumns != null)
         {
            groupColumnsArray = [];
            for(i = 0; i < value.groupedColumns.length; i++)
            {
               groupColumnsArray.push(value.groupedColumns[i].clone());
            }
            this.groupedColumns = groupColumnsArray;
         }
         else
         {
            columnArray = [];
            i = 0;
            while(Boolean(value.columns) && i < value.columns.length)
            {
               sourceColumn = value.columns[i];
               col = sourceColumn.clone();
               if(sourceColumn == value.treeColumn)
               {
                  this.treeColumn = col;
               }
               columnArray.push(col);
               i++;
            }
            this.columns = columnArray;
         }
         this.itemRenderer = value.itemRenderer;
         this.headerRenderer = value.headerRenderer;
         this.groupItemRenderer = value.groupItemRenderer;
         this.rendererProviders = value.rendererProviders;
         this.labelField = value.labelField;
         this.labelFunction = value.labelFunction;
         this.groupIconFunction = value.groupIconFunction;
         this.groupLabelFunction = value.groupLabelFunction;
         this.displayDisclosureIcon = value.displayDisclosureIcon;
         this.displayItemsExpanded = value.displayItemsExpanded;
         this.itemIcons = value.itemIcons;
         this.lockedColumnCount = value.lockedColumnCount;
         this.lockedRowCount = value.lockedRowCount;
         this.wordWrap = value.wordWrap;
         this.variableRowHeight = value.variableRowHeight;
         columnsInvalid = true;
         itemsSizeChanged = true;
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
      }
      
      public function get validNextPage() : Boolean
      {
         var vPos:int = verticalScrollPosition + rowCount;
         return Boolean(dataProvider) && vPos < dataProvider.length ? true : false;
      }
      
      public function get validPreviousPage() : Boolean
      {
         var vPos:int = verticalScrollPosition - previousPageRowCount;
         return Boolean(dataProvider) && vPos >= 0 ? true : false;
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function expandItemHandler(event:AdvancedDataGridEvent) : void
      {
         event.animate = false;
         super.expandItemHandler(event);
         itemsSizeChanged = true;
         invalidateDisplayList();
         invalidateSize();
         invalidateProperties();
      }
      
      override protected function commitProperties() : void
      {
         var i:int = 0;
         var sourceColumn:AdvancedDataGridColumn = null;
         super.commitProperties();
         if(Boolean(source) && Boolean(source.groupedColumns) && Boolean(source.treeColumn))
         {
            for(i = 0; i < source.columns.length; i++)
            {
               sourceColumn = source.columns[i];
               if(sourceColumn == source.treeColumn)
               {
                  this.treeColumn = this.columns[i];
                  break;
               }
            }
         }
         if(displayIconsChanged)
         {
            displayIconsChanged = false;
            if(displayIcons)
            {
               setStyle("defaultLeafIcon",defaultLeafIconClass);
               setStyle("folderClosedIcon",folderClosedIconClass);
               setStyle("folderOpenIcon",folderOpenIconClass);
            }
            else
            {
               folderClosedIconClass = getStyle("folderClosedIcon");
               folderOpenIconClass = getStyle("folderOpenIcon");
               defaultLeafIconClass = getStyle("defaultLeafIcon");
               setStyle("defaultLeafIcon",null);
               setStyle("folderClosedIcon",null);
               setStyle("folderOpenIcon",null);
            }
         }
      }
      
      [Inspectable(category="Size",defaultValue="NaN")]
      [Bindable("resize")]
      override public function get percentHeight() : Number
      {
         return super.percentHeight;
      }
      
      override public function set height(value:Number) : void
      {
         _originalHeight = value;
         if(!isNaN(percentHeight))
         {
            super.percentHeight = NaN;
            measure();
            value = Number(measuredHeight);
         }
         super.height = value;
         invalidateDisplayList();
         if(sizeToPage && !isNaN(explicitHeight))
         {
            explicitHeight = NaN;
         }
      }
      
      public function get originalHeight() : Number
      {
         return _originalHeight;
      }
      
      override protected function measure() : void
      {
         var count:uint = 0;
         var oldRowCount:uint = uint(rowCount);
         count = Boolean(dataProvider) ? uint(dataProvider.length) : 0;
         if(count == 0 && headerVisible)
         {
            count++;
         }
         if(count >= verticalScrollPosition)
         {
            count -= verticalScrollPosition;
         }
         else
         {
            count = 0;
         }
         setRowCount(count);
         super.measure();
         measureHeight();
         if(isNaN(_originalHeight))
         {
            _originalHeight = measuredHeight;
         }
         _currentPageHeight = measuredHeight;
         if(!sizeToPage)
         {
            setRowCount(oldRowCount);
            super.measure();
         }
      }
      
      override protected function keyDownHandler(event:KeyboardEvent) : void
      {
      }
      
      public function get currentPageHeight() : Number
      {
         return _currentPageHeight;
      }
      
      public function set displayIcons(value:Boolean) : void
      {
         if(value != _displayIcons)
         {
            _displayIcons = value;
            displayIconsChanged = true;
            itemsSizeChanged = true;
            invalidateProperties();
            invalidateSize();
            invalidateDisplayList();
         }
      }
      
      public function get displayIcons() : Boolean
      {
         return _displayIcons;
      }
   }
}

