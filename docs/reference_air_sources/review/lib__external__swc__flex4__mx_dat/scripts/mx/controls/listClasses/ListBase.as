package mx.controls.listClasses
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   import flash.utils.clearInterval;
   import flash.utils.setInterval;
   import mx.collections.ArrayCollection;
   import mx.collections.CursorBookmark;
   import mx.collections.ICollectionView;
   import mx.collections.IList;
   import mx.collections.IViewCursor;
   import mx.collections.ItemResponder;
   import mx.collections.ItemWrapper;
   import mx.collections.ListCollectionView;
   import mx.collections.ModifiedCollectionView;
   import mx.collections.XMLListCollection;
   import mx.collections.errors.CursorError;
   import mx.collections.errors.ItemPendingError;
   import mx.controls.dataGridClasses.DataGridListData;
   import mx.core.DragSource;
   import mx.core.EdgeMetrics;
   import mx.core.EventPriority;
   import mx.core.FlexShape;
   import mx.core.IDataRenderer;
   import mx.core.IFactory;
   import mx.core.IFlexDisplayObject;
   import mx.core.IInvalidating;
   import mx.core.ILayoutDirectionElement;
   import mx.core.IUIComponent;
   import mx.core.IUID;
   import mx.core.IUITextField;
   import mx.core.ScrollControlBase;
   import mx.core.ScrollPolicy;
   import mx.core.SpriteAsset;
   import mx.effects.IEffect;
   import mx.effects.IEffectTargetHost;
   import mx.effects.Tween;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.events.DragEvent;
   import mx.events.EffectEvent;
   import mx.events.FlexEvent;
   import mx.events.ListEvent;
   import mx.events.MoveEvent;
   import mx.events.SandboxMouseEvent;
   import mx.events.ScrollEvent;
   import mx.events.ScrollEventDetail;
   import mx.events.ScrollEventDirection;
   import mx.events.TweenEvent;
   import mx.managers.DragManager;
   import mx.managers.IFocusManagerComponent;
   import mx.managers.ISystemManager;
   import mx.skins.halo.ListDropIndicator;
   import mx.styles.StyleProxy;
   import mx.utils.ObjectUtil;
   import mx.utils.UIDUtil;
   
   [AccessibilityClass(implementation="mx.accessibility.ListBaseAccImpl")]
   [Style(name="verticalAlign",type="String",enumeration="bottom,middle,top",inherit="no")]
   [Style(name="useRollOver",type="Boolean",inherit="no")]
   [Style(name="textSelectedColor",type="uint",format="Color",inherit="yes")]
   [Style(name="textRollOverColor",type="uint",format="Color",inherit="yes")]
   [Style(name="selectionEasingFunction",type="Function",inherit="no")]
   [Style(name="selectionDuration",type="Number",format="Time",inherit="no")]
   [Style(name="selectionDisabledColor",type="uint",format="Color",inherit="yes")]
   [Style(name="selectionColor",type="uint",format="Color",inherit="yes")]
   [Style(name="rollOverColor",type="uint",format="Color",inherit="yes")]
   [Style(name="paddingTop",type="Number",format="Length",inherit="no")]
   [Style(name="paddingBottom",type="Number",format="Length",inherit="no")]
   [Style(name="dropIndicatorSkin",type="Class",inherit="no")]
   [Style(name="alternatingItemColors",type="Array",arrayType="uint",format="Color",inherit="yes")]
   [Style(name="paddingRight",type="Number",format="Length",inherit="no")]
   [Style(name="paddingLeft",type="Number",format="Length",inherit="no")]
   [Event(name="itemDoubleClick",type="mx.events.ListEvent")]
   [Event(name="itemClick",type="mx.events.ListEvent")]
   [Event(name="itemRollOut",type="mx.events.ListEvent")]
   [Event(name="itemRollOver",type="mx.events.ListEvent")]
   [Event(name="dataChange",type="mx.events.FlexEvent")]
   [Event(name="change",type="mx.events.ListEvent")]
   public class ListBase extends ScrollControlBase implements IDataRenderer, IFocusManagerComponent, IListItemRenderer, IDropInListItemRenderer, IEffectTargetHost
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static var createAccessibilityImplementation:Function;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const DRAG_THRESHOLD:int = 4;
      
      private static var _listContentStyleFilters:Object = null;
      
      private var IS_ITEM_STYLE:Object = {
         "alternatingItemColors":true,
         "backgroundColor":true,
         "backgroundDisabledColor":true,
         "color":true,
         "rollOverColor":true,
         "selectionColor":true,
         "selectionDisabledColor":true,
         "styleName":true,
         "textColor":true,
         "textRollOverColor":true,
         "textSelectedColor":true
      };
      
      protected var collection:ICollectionView;
      
      protected var iterator:IViewCursor;
      
      protected var iteratorValid:Boolean = true;
      
      protected var lastSeekPending:ListBaseSeekPending;
      
      protected var listContent:ListBaseContentHolder;
      
      protected var selectionLayer:Sprite;
      
      protected var rowMap:Object = {};
      
      protected var factoryMap:Dictionary;
      
      protected var freeItemRenderers:Array = [];
      
      protected var freeItemRenderersByFactory:Dictionary;
      
      protected var reservedItemRenderers:Object = {};
      
      protected var unconstrainedRenderers:Dictionary = new Dictionary();
      
      protected var dataItemWrappersByRenderer:Dictionary = new Dictionary(true);
      
      protected var runDataEffectNextUpdate:Boolean = false;
      
      protected var runningDataEffect:Boolean = false;
      
      protected var cachedItemsChangeEffect:IEffect = null;
      
      protected var modifiedCollectionView:ModifiedCollectionView;
      
      protected var actualCollection:ICollectionView;
      
      protected var offscreenExtraRows:int = 0;
      
      protected var offscreenExtraRowsTop:int = 0;
      
      protected var offscreenExtraRowsBottom:int = 0;
      
      protected var offscreenExtraColumns:int = 0;
      
      protected var offscreenExtraColumnsLeft:int = 0;
      
      protected var offscreenExtraColumnsRight:int = 0;
      
      protected var actualIterator:IViewCursor;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var allowRendererStealingDuringLayout:Boolean = true;
      
      protected var highlightUID:String;
      
      protected var highlightItemRenderer:IListItemRenderer;
      
      protected var highlightIndicator:Sprite;
      
      protected var caretUID:String;
      
      protected var caretItemRenderer:IListItemRenderer;
      
      protected var caretIndicator:Sprite;
      
      protected var selectedData:Object = {};
      
      protected var selectionIndicators:Object = {};
      
      protected var selectionTweens:Object = {};
      
      protected var caretBookmark:CursorBookmark;
      
      protected var anchorBookmark:CursorBookmark;
      
      protected var showCaret:Boolean;
      
      protected var lastDropIndex:int;
      
      protected var itemsNeedMeasurement:Boolean = true;
      
      protected var itemsSizeChanged:Boolean = false;
      
      protected var rendererChanged:Boolean = false;
      
      protected var dataEffectCompleted:Boolean = false;
      
      protected var wordWrapChanged:Boolean = false;
      
      protected var keySelectionPending:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var cachedPaddingTop:Number;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var cachedPaddingBottom:Number;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var cachedVerticalAlign:String;
      
      private var oldUnscaledWidth:Number;
      
      private var oldUnscaledHeight:Number;
      
      private var horizontalScrollPositionPending:Number;
      
      private var verticalScrollPositionPending:Number;
      
      private var mouseDownPoint:Point;
      
      private var bSortItemPending:Boolean = false;
      
      private var bShiftKey:Boolean = false;
      
      private var bCtrlKey:Boolean = false;
      
      private var lastKey:uint = 0;
      
      private var bSelectItem:Boolean = false;
      
      private var approximate:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var bColumnScrolling:Boolean = true;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var listType:String = "grid";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var bSelectOnRelease:Boolean;
      
      private var mouseDownItem:IListItemRenderer;
      
      private var mouseDownIndex:int;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var bSelectionChanged:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var bSelectedIndexChanged:Boolean = false;
      
      private var bSelectedItemChanged:Boolean = false;
      
      private var bSelectedItemsChanged:Boolean = false;
      
      private var bSelectedIndicesChanged:Boolean = false;
      
      private var cachedPaddingTopInvalid:Boolean = true;
      
      private var cachedPaddingBottomInvalid:Boolean = true;
      
      private var cachedVerticalAlignInvalid:Boolean = true;
      
      private var firstSelectionData:ListBaseSelectionData;
      
      private var lastSelectionData:ListBaseSelectionData;
      
      private var firstSelectedItem:Object;
      
      private var proposedSelectedItemIndexes:Dictionary;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var lastHighlightItemRenderer:IListItemRenderer;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var lastHighlightItemRendererAtIndices:IListItemRenderer;
      
      private var lastHighlightItemIndices:Point;
      
      private var selectionDataArray:Array;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var dragScrollingInterval:int = 0;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var itemMaskFreeList:Array;
      
      private var trackedRenderers:Array = [];
      
      private var rendererTrackingSuspended:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var isPressed:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var collectionIterator:IViewCursor;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var dropIndicator:IFlexDisplayObject;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var lastDragEvent:DragEvent;
      
      public var allowDragSelection:Boolean = false;
      
      private var _allowMultipleSelection:Boolean = false;
      
      protected var anchorIndex:int = -1;
      
      protected var caretIndex:int = -1;
      
      private var _columnCount:int = -1;
      
      private var columnCountChanged:Boolean = true;
      
      private var _columnWidth:Number;
      
      private var columnWidthChanged:Boolean = false;
      
      private var _data:Object;
      
      private var _dataTipField:String = "label";
      
      private var _dataTipFunction:Function;
      
      protected var defaultColumnCount:int = 4;
      
      protected var defaultRowCount:int = 4;
      
      private var _dragEnabled:Boolean = false;
      
      private var _dragMoveEnabled:Boolean = false;
      
      private var _dropEnabled:Boolean = false;
      
      protected var explicitColumnCount:int = -1;
      
      protected var explicitColumnWidth:Number;
      
      protected var explicitRowCount:int = -1;
      
      protected var explicitRowHeight:Number;
      
      private var _iconField:String = "icon";
      
      private var _iconFunction:Function;
      
      private var _itemRenderer:IFactory;
      
      private var _labelField:String = "label";
      
      private var _labelFunction:Function;
      
      private var _listData:BaseListData;
      
      public var menuSelectionMode:Boolean = false;
      
      private var _offscreenExtraRowsOrColumns:int = 0;
      
      protected var offscreenExtraRowsOrColumnsChanged:Boolean = false;
      
      private var _nullItemRenderer:IFactory;
      
      private var _rowCount:int = -1;
      
      private var rowCountChanged:Boolean = true;
      
      private var _rowHeight:Number;
      
      private var rowHeightChanged:Boolean = false;
      
      private var _selectable:Boolean = true;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _selectedIndex:int = -1;
      
      private var _selectedIndices:Array;
      
      private var _selectedItem:Object;
      
      private var _selectedItems:Array;
      
      private var _selectedItemsCompareFunction:Function;
      
      private var _showDataTips:Boolean = false;
      
      private var _variableRowHeight:Boolean = false;
      
      private var _wordWrap:Boolean = false;
      
      public function ListBase()
      {
         super();
         tabEnabled = true;
         tabFocusEnabled = true;
         this.factoryMap = new Dictionary(true);
         addEventListener(MouseEvent.MOUSE_WHEEL,this.mouseWheelHandler);
         addEventListener(MouseEvent.MOUSE_OVER,this.mouseOverHandler);
         addEventListener(MouseEvent.MOUSE_OUT,this.mouseOutHandler);
         addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
         addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
         addEventListener(MouseEvent.CLICK,this.mouseClickHandler);
         addEventListener(MouseEvent.DOUBLE_CLICK,this.mouseDoubleClickHandler);
         invalidateProperties();
      }
      
      protected function get visibleData() : Object
      {
         return this.listContent.visibleData;
      }
      
      protected function get listContentStyleFilters() : Object
      {
         return _listContentStyleFilters;
      }
      
      protected function get listItems() : Array
      {
         return Boolean(this.listContent) ? this.listContent.listItems : [];
      }
      
      protected function get rowInfo() : Array
      {
         return this.listContent.rowInfo;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get rendererArray() : Array
      {
         return this.listItems;
      }
      
      override public function get baselinePosition() : Number
      {
         if(!validateBaselinePosition())
         {
            return NaN;
         }
         var isNull:Boolean = this.dataProvider == null;
         var isEmpty:Boolean = this.dataProvider != null && this.dataProvider.length == 0;
         var originalProvider:Object = this.dataProvider;
         if(isNull || isEmpty)
         {
            this.dataProvider = [null];
            validateNow();
         }
         if(!this.listItems || this.listItems.length == 0)
         {
            return super.baselinePosition;
         }
         var listItem:IUIComponent = this.listItems[0][0] as IUIComponent;
         if(!listItem)
         {
            return super.baselinePosition;
         }
         var contentHolder:ListBaseContentHolder = ListBaseContentHolder(listItem.parent);
         var result:Number = contentHolder.y + listItem.y + listItem.baselinePosition;
         if(isNull || isEmpty)
         {
            this.dataProvider = originalProvider;
            validateNow();
         }
         return result;
      }
      
      [Inspectable(category="General")]
      override public function set enabled(value:Boolean) : void
      {
         super.enabled = value;
         var ui:IFlexDisplayObject = border as IFlexDisplayObject;
         if(Boolean(ui))
         {
            if(ui is IUIComponent)
            {
               IUIComponent(ui).enabled = value;
            }
            if(ui is IInvalidating)
            {
               IInvalidating(ui).invalidateDisplayList();
            }
         }
         this.itemsSizeChanged = true;
         invalidateDisplayList();
      }
      
      override public function set showInAutomationHierarchy(value:Boolean) : void
      {
      }
      
      override public function set horizontalScrollPolicy(value:String) : void
      {
         super.horizontalScrollPolicy = value;
         this.itemsSizeChanged = true;
         invalidateDisplayList();
      }
      
      [Inspectable(defaultValue="0")]
      [Bindable("viewChanged")]
      [Bindable("scroll")]
      override public function get horizontalScrollPosition() : Number
      {
         if(!isNaN(this.horizontalScrollPositionPending))
         {
            return this.horizontalScrollPositionPending;
         }
         return super.horizontalScrollPosition;
      }
      
      override public function set horizontalScrollPosition(value:Number) : void
      {
         var deltaPos:int = 0;
         var direction:Boolean = false;
         if(this.listItems.length == 0 || !this.dataProvider || !isNaN(this.horizontalScrollPositionPending))
         {
            this.horizontalScrollPositionPending = value;
            if(Boolean(this.dataProvider))
            {
               invalidateDisplayList();
            }
            return;
         }
         this.horizontalScrollPositionPending = NaN;
         var oldValue:int = super.horizontalScrollPosition;
         super.horizontalScrollPosition = value;
         this.removeClipMask();
         if(oldValue != value)
         {
            if(this.itemsSizeChanged)
            {
               return;
            }
            deltaPos = value - oldValue;
            direction = deltaPos > 0;
            deltaPos = Math.abs(deltaPos);
            if(this.bColumnScrolling && deltaPos >= this.columnCount)
            {
               this.clearIndicators();
               this.clearVisibleData();
               this.makeRowsAndColumnsWithExtraColumns(this.oldUnscaledWidth,this.oldUnscaledHeight);
               this.drawRowBackgrounds();
            }
            else
            {
               this.scrollHorizontally(value,deltaPos,direction);
            }
         }
         this.addClipMask(false);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function set $horizontalScrollPosition(value:Number) : void
      {
         var oldValue:int = super.horizontalScrollPosition;
         if(oldValue != value)
         {
            super.horizontalScrollPosition = value;
         }
      }
      
      override public function set verticalScrollPolicy(value:String) : void
      {
         super.verticalScrollPolicy = value;
         this.itemsSizeChanged = true;
         invalidateDisplayList();
      }
      
      [Bindable("viewChanged")]
      [Bindable("scroll")]
      override public function get verticalScrollPosition() : Number
      {
         if(!isNaN(this.verticalScrollPositionPending))
         {
            return this.verticalScrollPositionPending;
         }
         return super.verticalScrollPosition;
      }
      
      override public function set verticalScrollPosition(value:Number) : void
      {
         var deltaPos:int = 0;
         var direction:Boolean = false;
         if(this.listItems.length == 0 || !this.dataProvider || !isNaN(this.verticalScrollPositionPending))
         {
            this.verticalScrollPositionPending = value;
            if(Boolean(this.dataProvider))
            {
               invalidateDisplayList();
            }
            return;
         }
         this.verticalScrollPositionPending = NaN;
         var oldValue:int = super.verticalScrollPosition;
         super.verticalScrollPosition = value;
         this.removeClipMask();
         var oldoffscreenExtraRowsTop:int = this.offscreenExtraRowsTop;
         var oldoffscreenExtraRowsBottom:int = this.offscreenExtraRowsBottom;
         if(oldValue != value)
         {
            deltaPos = value - oldValue;
            direction = deltaPos > 0;
            deltaPos = Math.abs(deltaPos);
            if(deltaPos >= this.rowInfo.length - this.offscreenExtraRows || !this.iteratorValid)
            {
               this.clearIndicators();
               this.clearVisibleData();
               this.makeRowsAndColumnsWithExtraRows(this.oldUnscaledWidth,this.oldUnscaledHeight);
            }
            else
            {
               this.scrollVertically(value,deltaPos,direction);
               this.adjustListContent(this.oldUnscaledWidth,this.oldUnscaledHeight);
            }
            if(this.variableRowHeight)
            {
               this.configureScrollBars();
            }
            this.drawRowBackgrounds();
         }
         this.addClipMask(this.offscreenExtraRowsTop != oldoffscreenExtraRowsTop || this.offscreenExtraRowsBottom != oldoffscreenExtraRowsBottom);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function set $verticalScrollPosition(value:Number) : void
      {
         var oldValue:int = super.verticalScrollPosition;
         if(oldValue != value)
         {
            super.verticalScrollPosition = value;
         }
      }
      
      private function makeRowsAndColumnsWithExtraRows(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var lastPrefixRow:ListRowInfo = null;
         var lastOnscreenRow:ListRowInfo = null;
         var lastOffscreenRow:ListRowInfo = null;
         var onscreenRowIndex:int = 0;
         var pt:Point = null;
         var currentRows:int = 0;
         var extraEmptyRows:int = 0;
         var i:int = 0;
         var desiredExtraRowsTop:int = this.offscreenExtraRows / 2;
         var desiredExtraRowsBottom:int = this.offscreenExtraRows / 2;
         this.offscreenExtraRowsTop = Math.min(desiredExtraRowsTop,this.verticalScrollPosition);
         var index:int = this.scrollPositionToIndex(this.horizontalScrollPosition,this.verticalScrollPosition - this.offscreenExtraRowsTop);
         this.seekPositionSafely(index);
         var cursorPos:CursorBookmark = this.iterator.bookmark;
         if(this.offscreenExtraRowsTop > 0)
         {
            this.makeRowsAndColumns(0,0,this.listContent.width,this.listContent.height,0,0,true,this.offscreenExtraRowsTop);
         }
         var curY:Number = Boolean(this.offscreenExtraRowsTop) ? this.rowInfo[this.offscreenExtraRowsTop - 1].y + this.rowHeight : 0;
         pt = this.makeRowsAndColumns(0,curY,this.listContent.width,curY + this.listContent.heightExcludingOffsets,0,this.offscreenExtraRowsTop);
         if(desiredExtraRowsBottom > 0 && !this.iterator.afterLast)
         {
            if(this.offscreenExtraRowsTop + pt.y - 1 < 0)
            {
               curY = 0;
            }
            else
            {
               curY = this.rowInfo[this.offscreenExtraRowsTop + pt.y - 1].y + this.rowInfo[this.offscreenExtraRowsTop + pt.y - 1].height;
            }
            currentRows = int(this.listItems.length);
            pt = this.makeRowsAndColumns(0,curY,this.listContent.width,curY,0,this.offscreenExtraRowsTop + pt.y,true,desiredExtraRowsBottom);
            if(pt.y == desiredExtraRowsBottom)
            {
               while(Boolean(pt.y > 0) && Boolean(this.listItems[this.listItems.length - 1]) && this.listItems[this.listItems.length - 1].length == 0)
               {
                  --pt.y;
                  this.listItems.pop();
                  this.rowInfo.pop();
               }
            }
            else if(pt.y < desiredExtraRowsBottom)
            {
               extraEmptyRows = this.listItems.length - (currentRows + pt.y);
               if(Boolean(extraEmptyRows))
               {
                  for(i = 0; i < extraEmptyRows; i++)
                  {
                     this.listItems.pop();
                     this.rowInfo.pop();
                  }
               }
            }
            this.offscreenExtraRowsBottom = pt.y;
         }
         else
         {
            this.offscreenExtraRowsBottom = 0;
         }
         var oldContentHeight:Number = this.listContent.heightExcludingOffsets;
         this.listContent.topOffset = -this.offscreenExtraRowsTop * this.rowHeight;
         this.listContent.bottomOffset = this.offscreenExtraRowsBottom > 0 ? this.listItems[this.listItems.length - 1][0].y + this.rowHeight - oldContentHeight + this.listContent.topOffset : 0;
         this.seekPositionIgnoreError(this.iterator,cursorPos);
         this.adjustListContent(unscaledWidth,unscaledHeight);
      }
      
      private function makeRowsAndColumnsWithExtraColumns(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var currentColumns:int = 0;
         var extraEmptyColumns:int = 0;
         var i:int = 0;
         var j:int = 0;
         var desiredOffscreenColumnsLeft:int = this.offscreenExtraColumns / 2;
         var desiredOffscreenColumnsRight:int = this.offscreenExtraColumns / 2;
         if(this.horizontalScrollPosition > this.collection.length - this.columnCount)
         {
            super.horizontalScrollPosition = Math.max(0,this.collection.length - this.columnCount);
         }
         this.offscreenExtraColumnsLeft = Math.min(desiredOffscreenColumnsLeft,this.horizontalScrollPosition);
         var index:int = this.scrollPositionToIndex(this.horizontalScrollPosition - this.offscreenExtraColumnsLeft,this.verticalScrollPosition);
         this.seekPositionSafely(index);
         var cursorPos:CursorBookmark = this.iterator.bookmark;
         if(this.offscreenExtraColumnsLeft > 0)
         {
            this.makeRowsAndColumns(0,0,0,this.listContent.height,0,0,true,this.offscreenExtraColumnsLeft);
         }
         var curX:Number = Boolean(this.offscreenExtraColumnsLeft) ? this.listItems[0][this.offscreenExtraColumnsLeft - 1].x + this.columnWidth : 0;
         var pt:Point = this.makeRowsAndColumns(curX,0,curX + this.listContent.widthExcludingOffsets,this.listContent.height,this.offscreenExtraColumnsLeft,0);
         if(desiredOffscreenColumnsRight > 0 && !this.iterator.afterLast)
         {
            if(this.offscreenExtraColumnsLeft + pt.x - 1 < 0)
            {
               curX = 0;
            }
            else
            {
               curX = this.listItems[0][this.offscreenExtraColumnsLeft + pt.x - 1].x + this.columnWidth;
            }
            currentColumns = int(this.listItems[0].length);
            pt = this.makeRowsAndColumns(curX,0,curX,this.listContent.height,this.offscreenExtraColumnsLeft + pt.x,0,true,desiredOffscreenColumnsRight);
            if(pt.x < desiredOffscreenColumnsRight)
            {
               extraEmptyColumns = this.listItems[0].length - (currentColumns + pt.x);
               if(Boolean(extraEmptyColumns))
               {
                  for(i = 0; i < this.listItems.length; i++)
                  {
                     for(j = 0; j < extraEmptyColumns; j++)
                     {
                        this.listItems[i].pop();
                     }
                  }
               }
            }
            this.offscreenExtraColumnsRight = pt.x;
         }
         else
         {
            this.offscreenExtraColumnsRight = 0;
         }
         var oldContentWidth:Number = this.listContent.widthExcludingOffsets;
         this.listContent.leftOffset = -this.offscreenExtraColumnsLeft * this.columnWidth;
         this.listContent.rightOffset = this.offscreenExtraColumnsRight > 0 ? this.listItems[0][this.listItems[0].length - 1].x + this.columnWidth - oldContentWidth + this.listContent.leftOffset : 0;
         this.iterator.seek(cursorPos,0);
         this.adjustListContent(unscaledWidth,unscaledHeight);
      }
      
      [Inspectable(category="General",enumeration="false,true",defaultValue="false")]
      public function get allowMultipleSelection() : Boolean
      {
         return this._allowMultipleSelection;
      }
      
      public function set allowMultipleSelection(value:Boolean) : void
      {
         this._allowMultipleSelection = value;
      }
      
      public function get columnCount() : int
      {
         return this._columnCount;
      }
      
      public function set columnCount(value:int) : void
      {
         this.explicitColumnCount = value;
         if(this._columnCount != value)
         {
            this.setColumnCount(value);
            this.columnCountChanged = true;
            invalidateProperties();
            invalidateSize();
            this.itemsSizeChanged = true;
            invalidateDisplayList();
            dispatchEvent(new Event("columnCountChanged"));
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setColumnCount(value:int) : void
      {
         this._columnCount = value;
      }
      
      public function get columnWidth() : Number
      {
         return this._columnWidth;
      }
      
      public function set columnWidth(value:Number) : void
      {
         this.explicitColumnWidth = value;
         if(this._columnWidth != value)
         {
            this.setColumnWidth(value);
            invalidateSize();
            this.itemsSizeChanged = true;
            invalidateDisplayList();
            dispatchEvent(new Event("columnWidthChanged"));
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setColumnWidth(value:Number) : void
      {
         this._columnWidth = value;
      }
      
      [Inspectable(environment="none")]
      [Bindable("dataChange")]
      public function get data() : Object
      {
         return this._data;
      }
      
      public function set data(value:Object) : void
      {
         this._data = value;
         if(Boolean(this._listData) && this._listData is DataGridListData)
         {
            this.selectedItem = this._data[DataGridListData(this._listData).dataField];
         }
         else if(this._listData is ListData && ListData(this._listData).labelField in this._data)
         {
            this.selectedItem = this._data[ListData(this._listData).labelField];
         }
         else
         {
            this.selectedItem = this._data;
         }
         dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
      }
      
      [Inspectable(category="Data",defaultValue="undefined")]
      [Bindable("collectionChange")]
      public function get dataProvider() : Object
      {
         if(Boolean(this.actualCollection))
         {
            return this.actualCollection;
         }
         return this.collection;
      }
      
      public function set dataProvider(value:Object) : void
      {
         var xl:XMLList = null;
         var tmp:Array = null;
         if(Boolean(this.collection))
         {
            this.collection.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.collectionChangeHandler);
         }
         if(value is Array)
         {
            this.collection = new ArrayCollection(value as Array);
         }
         else if(value is ICollectionView)
         {
            this.collection = ICollectionView(value);
         }
         else if(value is IList)
         {
            this.collection = new ListCollectionView(IList(value));
         }
         else if(value is XMLList)
         {
            this.collection = new XMLListCollection(value as XMLList);
         }
         else if(value is XML)
         {
            xl = new XMLList();
            xl += value;
            this.collection = new XMLListCollection(xl);
         }
         else
         {
            tmp = [];
            if(value != null)
            {
               tmp.push(value);
            }
            this.collection = new ArrayCollection(tmp);
         }
         this.iterator = this.collection.createCursor();
         this.collectionIterator = this.collection.createCursor();
         this.collection.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.collectionChangeHandler,false,0,true);
         this.clearSelectionData();
         var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
         event.kind = CollectionEventKind.RESET;
         this.collectionChangeHandler(event);
         dispatchEvent(event);
         this.itemsNeedMeasurement = true;
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
      }
      
      [Inspectable(category="Data",defaultValue="label")]
      [Bindable("dataTipFieldChanged")]
      public function get dataTipField() : String
      {
         return this._dataTipField;
      }
      
      public function set dataTipField(value:String) : void
      {
         this._dataTipField = value;
         this.itemsSizeChanged = true;
         invalidateDisplayList();
         dispatchEvent(new Event("dataTipFieldChanged"));
      }
      
      [Inspectable(category="Data")]
      [Bindable("dataTipFunctionChanged")]
      public function get dataTipFunction() : Function
      {
         return this._dataTipFunction;
      }
      
      public function set dataTipFunction(value:Function) : void
      {
         this._dataTipFunction = value;
         this.itemsSizeChanged = true;
         invalidateDisplayList();
         dispatchEvent(new Event("dataTipFunctionChanged"));
      }
      
      public function get dragEnabled() : Boolean
      {
         return this._dragEnabled;
      }
      
      public function set dragEnabled(value:Boolean) : void
      {
         if(this._dragEnabled && !value)
         {
            removeEventListener(DragEvent.DRAG_START,this.dragStartHandler,false);
            removeEventListener(DragEvent.DRAG_COMPLETE,this.dragCompleteHandler,false);
         }
         this._dragEnabled = value;
         if(value)
         {
            addEventListener(DragEvent.DRAG_START,this.dragStartHandler,false,EventPriority.DEFAULT_HANDLER);
            addEventListener(DragEvent.DRAG_COMPLETE,this.dragCompleteHandler,false,EventPriority.DEFAULT_HANDLER);
         }
      }
      
      protected function get dragImage() : IUIComponent
      {
         var image:ListItemDragProxy = new ListItemDragProxy();
         image.owner = this;
         image.moduleFactory = moduleFactory;
         return image;
      }
      
      protected function get dragImageOffsets() : Point
      {
         var pt:Point = new Point();
         var n:int = int(this.listItems.length);
         for(var i:int = 0; i < n; i++)
         {
            if(Boolean(this.selectedData[this.rowInfo[i].uid]))
            {
               pt.x = this.listItems[i][0].x;
               pt.y = this.listItems[i][0].y;
            }
         }
         return pt;
      }
      
      [Inspectable(defaultValue="false")]
      public function get dragMoveEnabled() : Boolean
      {
         return this._dragMoveEnabled;
      }
      
      public function set dragMoveEnabled(value:Boolean) : void
      {
         this._dragMoveEnabled = value;
      }
      
      [Inspectable(defaultValue="false")]
      public function get dropEnabled() : Boolean
      {
         return this._dropEnabled;
      }
      
      public function set dropEnabled(value:Boolean) : void
      {
         if(this._dropEnabled && !value)
         {
            removeEventListener(DragEvent.DRAG_ENTER,this.dragEnterHandler,false);
            removeEventListener(DragEvent.DRAG_EXIT,this.dragExitHandler,false);
            removeEventListener(DragEvent.DRAG_OVER,this.dragOverHandler,false);
            removeEventListener(DragEvent.DRAG_DROP,this.dragDropHandler,false);
         }
         this._dropEnabled = value;
         if(value)
         {
            addEventListener(DragEvent.DRAG_ENTER,this.dragEnterHandler,false,EventPriority.DEFAULT_HANDLER);
            addEventListener(DragEvent.DRAG_EXIT,this.dragExitHandler,false,EventPriority.DEFAULT_HANDLER);
            addEventListener(DragEvent.DRAG_OVER,this.dragOverHandler,false,EventPriority.DEFAULT_HANDLER);
            addEventListener(DragEvent.DRAG_DROP,this.dragDropHandler,false,EventPriority.DEFAULT_HANDLER);
         }
      }
      
      [Inspectable(category="Data",defaultValue="")]
      [Bindable("iconFieldChanged")]
      public function get iconField() : String
      {
         return this._iconField;
      }
      
      public function set iconField(value:String) : void
      {
         this._iconField = value;
         this.itemsSizeChanged = true;
         invalidateDisplayList();
         dispatchEvent(new Event("iconFieldChanged"));
      }
      
      [Inspectable(category="Data")]
      [Bindable("iconFunctionChanged")]
      public function get iconFunction() : Function
      {
         return this._iconFunction;
      }
      
      public function set iconFunction(value:Function) : void
      {
         this._iconFunction = value;
         this.itemsSizeChanged = true;
         invalidateDisplayList();
         dispatchEvent(new Event("iconFunctionChanged"));
      }
      
      [Inspectable(category="Data")]
      public function get itemRenderer() : IFactory
      {
         return this._itemRenderer;
      }
      
      public function set itemRenderer(value:IFactory) : void
      {
         this._itemRenderer = value;
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
         this.itemsSizeChanged = true;
         this.itemsNeedMeasurement = true;
         this.rendererChanged = true;
         dispatchEvent(new Event("itemRendererChanged"));
      }
      
      [Inspectable(category="Data",defaultValue="label")]
      [Bindable("labelFieldChanged")]
      public function get labelField() : String
      {
         return this._labelField;
      }
      
      public function set labelField(value:String) : void
      {
         this._labelField = value;
         this.itemsSizeChanged = true;
         invalidateDisplayList();
         dispatchEvent(new Event("labelFieldChanged"));
      }
      
      [Inspectable(category="Data")]
      [Bindable("labelFunctionChanged")]
      public function get labelFunction() : Function
      {
         return this._labelFunction;
      }
      
      public function set labelFunction(value:Function) : void
      {
         this._labelFunction = value;
         this.itemsSizeChanged = true;
         invalidateDisplayList();
         dispatchEvent(new Event("labelFunctionChanged"));
      }
      
      [Inspectable(environment="none")]
      [Bindable("dataChange")]
      public function get listData() : BaseListData
      {
         return this._listData;
      }
      
      public function set listData(value:BaseListData) : void
      {
         this._listData = value;
      }
      
      public function get offscreenExtraRowsOrColumns() : int
      {
         return this._offscreenExtraRowsOrColumns;
      }
      
      public function set offscreenExtraRowsOrColumns(value:int) : void
      {
         value = Math.max(value,0);
         if(Boolean(value % 2))
         {
            value++;
         }
         if(this._offscreenExtraRowsOrColumns == value)
         {
            return;
         }
         this._offscreenExtraRowsOrColumns = value;
         this.offscreenExtraRowsOrColumnsChanged = true;
         invalidateProperties();
      }
      
      [Inspectable(category="Data")]
      public function get nullItemRenderer() : IFactory
      {
         return this._nullItemRenderer;
      }
      
      public function set nullItemRenderer(value:IFactory) : void
      {
         this._nullItemRenderer = value;
         invalidateSize();
         invalidateDisplayList();
         this.itemsSizeChanged = true;
         this.rendererChanged = true;
         dispatchEvent(new Event("nullItemRendererChanged"));
      }
      
      public function get rowCount() : int
      {
         return this._rowCount;
      }
      
      public function set rowCount(value:int) : void
      {
         this.explicitRowCount = value;
         if(this._rowCount != value)
         {
            this.setRowCount(value);
            this.rowCountChanged = true;
            invalidateProperties();
            invalidateSize();
            this.itemsSizeChanged = true;
            invalidateDisplayList();
            dispatchEvent(new Event("rowCountChanged"));
         }
      }
      
      protected function setRowCount(v:int) : void
      {
         this._rowCount = v;
      }
      
      [Inspectable(category="General")]
      public function get rowHeight() : Number
      {
         return this._rowHeight;
      }
      
      public function set rowHeight(value:Number) : void
      {
         this.explicitRowHeight = value;
         if(this._rowHeight != value)
         {
            this.setRowHeight(value);
            invalidateSize();
            this.itemsSizeChanged = true;
            invalidateDisplayList();
            dispatchEvent(new Event("rowHeightChanged"));
         }
      }
      
      protected function setRowHeight(v:Number) : void
      {
         this._rowHeight = v;
      }
      
      [Inspectable(defaultValue="true")]
      public function get selectable() : Boolean
      {
         return this._selectable;
      }
      
      public function set selectable(value:Boolean) : void
      {
         this._selectable = value;
      }
      
      [Inspectable(category="General",defaultValue="-1")]
      [Bindable("valueCommit")]
      [Bindable("change")]
      public function get selectedIndex() : int
      {
         return this._selectedIndex;
      }
      
      public function set selectedIndex(value:int) : void
      {
         if(!this.collection || this.collection.length == 0)
         {
            this._selectedIndex = value;
            this.bSelectionChanged = true;
            this.bSelectedIndexChanged = true;
            invalidateDisplayList();
            return;
         }
         this.commitSelectedIndex(value);
      }
      
      [Inspectable(category="General")]
      [Bindable("valueCommit")]
      [Bindable("change")]
      public function get selectedIndices() : Array
      {
         if(this.bSelectedIndicesChanged)
         {
            return this._selectedIndices;
         }
         return this.copySelectedItems(false);
      }
      
      public function set selectedIndices(indices:Array) : void
      {
         if(!this.collection || this.collection.length == 0)
         {
            this._selectedIndices = indices;
            this.bSelectedIndicesChanged = true;
            this.bSelectionChanged = true;
            invalidateDisplayList();
            return;
         }
         this.commitSelectedIndices(indices);
      }
      
      [Inspectable(category="General",defaultValue="null")]
      [Bindable("valueCommit")]
      [Bindable("change")]
      public function get selectedItem() : Object
      {
         return this._selectedItem;
      }
      
      public function set selectedItem(data:Object) : void
      {
         if(!this.collection || this.collection.length == 0)
         {
            this._selectedItem = data;
            this.bSelectedItemChanged = true;
            this.bSelectionChanged = true;
            invalidateDisplayList();
            return;
         }
         this.commitSelectedItem(data);
      }
      
      [Inspectable(category="General")]
      [Bindable("valueCommit")]
      [Bindable("change")]
      public function get selectedItems() : Array
      {
         return this.bSelectedItemsChanged ? this._selectedItems : this.copySelectedItems();
      }
      
      public function set selectedItems(items:Array) : void
      {
         if(!this.collection || this.collection.length == 0)
         {
            this._selectedItems = items;
            this.bSelectedItemsChanged = true;
            this.bSelectionChanged = true;
            invalidateDisplayList();
            return;
         }
         this.commitSelectedItems(items);
      }
      
      [Inspectable(category="Data")]
      [Bindable("selectedItemsCompareFunctionChanged")]
      public function get selectedItemsCompareFunction() : Function
      {
         return this._selectedItemsCompareFunction;
      }
      
      public function set selectedItemsCompareFunction(value:Function) : void
      {
         this._selectedItemsCompareFunction = value;
         dispatchEvent(new Event("selectedItemsCompareFunctionChanged"));
      }
      
      [Inspectable(category="Data",defaultValue="false")]
      [Bindable("showDataTipsChanged")]
      public function get showDataTips() : Boolean
      {
         return this._showDataTips;
      }
      
      public function set showDataTips(value:Boolean) : void
      {
         this._showDataTips = value;
         this.itemsSizeChanged = true;
         invalidateDisplayList();
         dispatchEvent(new Event("showDataTipsChanged"));
      }
      
      [Bindable("valueCommit")]
      [Bindable("change")]
      public function get value() : Object
      {
         var item:Object = this.selectedItem;
         if(!item)
         {
            return null;
         }
         if(typeof item != "object")
         {
            return item;
         }
         return item.data != null ? item.data : item.label;
      }
      
      [Inspectable(category="General")]
      public function get variableRowHeight() : Boolean
      {
         return this._variableRowHeight;
      }
      
      public function set variableRowHeight(value:Boolean) : void
      {
         this._variableRowHeight = value;
         this.itemsSizeChanged = true;
         invalidateDisplayList();
         dispatchEvent(new Event("variableRowHeightChanged"));
      }
      
      [Inspectable(category="General")]
      public function get wordWrap() : Boolean
      {
         return this._wordWrap;
      }
      
      public function set wordWrap(value:Boolean) : void
      {
         if(value == this._wordWrap)
         {
            return;
         }
         this._wordWrap = value;
         this.wordWrapChanged = true;
         this.itemsSizeChanged = true;
         invalidateDisplayList();
         dispatchEvent(new Event("wordWrapChanged"));
      }
      
      override protected function initializeAccessibility() : void
      {
         if(ListBase.createAccessibilityImplementation != null)
         {
            ListBase.createAccessibilityImplementation(this);
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         if(!this.listContent)
         {
            this.listContent = new ListBaseContentHolder(this);
            this.listContent.styleName = new StyleProxy(this,this.listContentStyleFilters);
            addChild(this.listContent);
         }
         if(!this.selectionLayer)
         {
            this.selectionLayer = this.listContent.selectionLayer;
         }
      }
      
      override protected function commitProperties() : void
      {
         var extraColumnsLeft:int = 0;
         var extraRowsTop:int = 0;
         var newIndex:int = 0;
         super.commitProperties();
         if(Boolean(this.listContent) && this.listContent.iterator != this.iterator)
         {
            this.listContent.iterator = this.iterator;
         }
         if(this.cachedPaddingTopInvalid)
         {
            this.cachedPaddingTopInvalid = false;
            this.cachedPaddingTop = getStyle("paddingTop");
            this.itemsSizeChanged = true;
            invalidateDisplayList();
         }
         if(this.cachedPaddingBottomInvalid)
         {
            this.cachedPaddingBottomInvalid = false;
            this.cachedPaddingBottom = getStyle("paddingBottom");
            this.itemsSizeChanged = true;
            invalidateDisplayList();
         }
         if(this.cachedVerticalAlignInvalid)
         {
            this.cachedVerticalAlignInvalid = false;
            this.cachedVerticalAlign = getStyle("verticalAlign");
            this.itemsSizeChanged = true;
            invalidateDisplayList();
         }
         if(this.columnCountChanged)
         {
            if(this._columnCount < 1)
            {
               this._columnCount = this.defaultColumnCount;
            }
            if(!isNaN(explicitWidth) && isNaN(this.explicitColumnWidth) && this.explicitColumnCount > 0)
            {
               this.setColumnWidth((explicitWidth - viewMetrics.left - viewMetrics.right) / this.columnCount);
            }
            this.columnCountChanged = false;
         }
         if(this.rowCountChanged)
         {
            if(this._rowCount < 1)
            {
               this._rowCount = this.defaultRowCount;
            }
            if(!isNaN(explicitHeight) && isNaN(this.explicitRowHeight) && this.explicitRowCount > 0)
            {
               this.setRowHeight((explicitHeight - viewMetrics.top - viewMetrics.bottom) / this.rowCount);
            }
            this.rowCountChanged = false;
         }
         if(this.offscreenExtraRowsOrColumnsChanged)
         {
            this.adjustOffscreenRowsAndColumns();
            if(Boolean(this.iterator))
            {
               extraColumnsLeft = Math.min(this.offscreenExtraColumns / 2,this.horizontalScrollPosition);
               extraRowsTop = Math.min(this.offscreenExtraRows / 2,this.verticalScrollPosition);
               newIndex = this.scrollPositionToIndex(this.horizontalScrollPosition - extraColumnsLeft,this.verticalScrollPosition - extraRowsTop);
               this.seekPositionSafely(newIndex);
               this.invalidateList();
            }
            this.offscreenExtraRowsOrColumnsChanged = false;
         }
      }
      
      override protected function measure() : void
      {
         super.measure();
         var o:EdgeMetrics = viewMetrics;
         var cc:int = this.explicitColumnCount < 1 ? this.defaultColumnCount : this.explicitColumnCount;
         var rc:int = this.explicitRowCount < 1 ? this.defaultRowCount : this.explicitRowCount;
         if(!isNaN(this.explicitRowHeight))
         {
            measuredHeight = this.explicitRowHeight * rc + o.top + o.bottom;
            measuredMinHeight = this.explicitRowHeight * Math.min(rc,2) + o.top + o.bottom;
         }
         else
         {
            measuredHeight = this.rowHeight * rc + o.top + o.bottom;
            measuredMinHeight = this.rowHeight * Math.min(rc,2) + o.top + o.bottom;
         }
         if(!isNaN(this.explicitColumnWidth))
         {
            measuredWidth = this.explicitColumnWidth * cc + o.left + o.right;
            measuredMinWidth = this.explicitColumnWidth * Math.min(cc,1) + o.left + o.right;
         }
         else
         {
            measuredWidth = this.columnWidth * cc + o.left + o.right;
            measuredMinWidth = this.columnWidth * Math.min(cc,1) + o.left + o.right;
         }
         if(Boolean(verticalScrollPolicy == ScrollPolicy.AUTO) && Boolean(verticalScrollBar) && Boolean(verticalScrollBar.visible))
         {
            measuredWidth -= verticalScrollBar.minWidth;
            measuredMinWidth -= verticalScrollBar.minWidth;
         }
         if(Boolean(horizontalScrollPolicy == ScrollPolicy.AUTO) && Boolean(horizontalScrollBar) && Boolean(horizontalScrollBar.visible))
         {
            measuredHeight -= horizontalScrollBar.minHeight;
            measuredMinHeight -= horizontalScrollBar.minHeight;
         }
      }
      
      override public function validateDisplayList() : void
      {
         var sm:ISystemManager = null;
         oldLayoutDirection = layoutDirection;
         if(invalidateDisplayListFlag)
         {
            sm = parent as ISystemManager;
            if(Boolean(sm))
            {
               if(sm == systemManager.topLevelSystemManager && sm.document != this)
               {
                  setActualSize(getExplicitOrMeasuredWidth(),getExplicitOrMeasuredHeight());
               }
            }
            validateMatrix();
            if(this.runDataEffectNextUpdate)
            {
               this.runDataEffectNextUpdate = false;
               this.runningDataEffect = true;
               this.initiateDataChangeEffect(unscaledWidth,unscaledHeight);
            }
            else
            {
               this.updateDisplayList(unscaledWidth,unscaledHeight);
            }
            invalidateDisplayListFlag = false;
         }
         else
         {
            validateMatrix();
         }
      }
      
      protected function initiateDataChangeEffect(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var rowItems:Array = null;
         var j:int = 0;
         var target:Object = null;
         this.actualCollection = this.collection;
         this.actualIterator = this.iterator;
         this.collection = this.modifiedCollectionView;
         this.modifiedCollectionView.showPreservedState = true;
         this.listContent.iterator = this.iterator = this.collection.createCursor();
         var index:int = this.scrollPositionToIndex(this.horizontalScrollPosition - this.offscreenExtraColumnsLeft,this.verticalScrollPosition - this.offscreenExtraRowsTop);
         this.iterator.seek(CursorBookmark.FIRST,index);
         this.updateDisplayList(unscaledWidth,unscaledHeight);
         var targets:Array = [];
         var targetHash:Dictionary = new Dictionary(true);
         for(var i:int = 0; i < this.listItems.length; i++)
         {
            rowItems = this.listItems[i];
            if(Boolean(rowItems) && rowItems.length > 0)
            {
               for(j = 0; j < rowItems.length; j++)
               {
                  target = rowItems[j];
                  if(Boolean(target))
                  {
                     targets.push(target);
                     targetHash[target] = true;
                  }
               }
            }
         }
         this.cachedItemsChangeEffect.targets = targets;
         if(this.cachedItemsChangeEffect.effectTargetHost != this)
         {
            this.cachedItemsChangeEffect.effectTargetHost = this;
         }
         this.cachedItemsChangeEffect.captureStartValues();
         this.modifiedCollectionView.showPreservedState = false;
         this.iterator.seek(CursorBookmark.FIRST,index);
         this.itemsSizeChanged = true;
         this.updateDisplayList(unscaledWidth,unscaledHeight);
         var newTargets:Array = [];
         var oldTargets:Array = this.cachedItemsChangeEffect.targets;
         for(i = 0; i < this.listItems.length; i++)
         {
            rowItems = this.listItems[i];
            if(Boolean(rowItems) && rowItems.length > 0)
            {
               for(j = 0; j < rowItems.length; j++)
               {
                  target = rowItems[j];
                  if(Boolean(target) && !targetHash[target])
                  {
                     oldTargets.push(target);
                     newTargets.push(target);
                  }
               }
            }
         }
         if(newTargets.length > 0)
         {
            this.cachedItemsChangeEffect.targets = oldTargets;
            this.cachedItemsChangeEffect.captureMoreStartValues(newTargets);
         }
         this.cachedItemsChangeEffect.captureEndValues();
         this.modifiedCollectionView.showPreservedState = true;
         this.iterator.seek(CursorBookmark.FIRST,index);
         this.itemsSizeChanged = true;
         this.updateDisplayList(unscaledWidth,unscaledHeight);
         this.initiateSelectionTracking(oldTargets);
         this.cachedItemsChangeEffect.addEventListener(EffectEvent.EFFECT_END,this.finishDataChangeEffect);
         this.cachedItemsChangeEffect.play();
      }
      
      private function initiateSelectionTracking(renderers:Array) : void
      {
         var renderer:IListItemRenderer = null;
         for(var i:int = 0; i < renderers.length; i++)
         {
            renderer = renderers[i] as IListItemRenderer;
            if(Boolean(this.selectedData[this.itemToUID(renderer.data)]))
            {
               renderer.addEventListener(MoveEvent.MOVE,this.rendererMoveHandler);
               this.trackedRenderers.push(renderer);
            }
         }
      }
      
      private function terminateSelectionTracking() : void
      {
         var renderer:IListItemRenderer = null;
         for(var i:int = 0; i < this.trackedRenderers.length; i++)
         {
            renderer = this.trackedRenderers[i] as IListItemRenderer;
            renderer.removeEventListener(MoveEvent.MOVE,this.rendererMoveHandler);
         }
         this.trackedRenderers = [];
      }
      
      public function removeDataEffectItem(item:Object) : void
      {
         if(Boolean(this.modifiedCollectionView))
         {
            this.modifiedCollectionView.removeItem(this.dataItemWrappersByRenderer[item]);
            this.iterator.seek(CursorBookmark.CURRENT);
            if(invalidateDisplayListFlag)
            {
               callLater(this.invalidateList);
            }
            else
            {
               this.invalidateList();
            }
         }
      }
      
      public function addDataEffectItem(item:Object) : void
      {
         if(Boolean(this.modifiedCollectionView))
         {
            this.modifiedCollectionView.addItem(this.dataItemWrappersByRenderer[item]);
         }
         if(this.iterator.afterLast)
         {
            this.iterator.seek(CursorBookmark.FIRST);
         }
         else
         {
            this.iterator.seek(CursorBookmark.CURRENT);
         }
         if(invalidateDisplayListFlag)
         {
            callLater(this.invalidateList);
         }
         else
         {
            this.invalidateList();
         }
      }
      
      public function unconstrainRenderer(item:Object) : void
      {
         this.unconstrainedRenderers[item] = true;
      }
      
      public function getRendererSemanticValue(target:Object, semanticProperty:String) : Object
      {
         return this.modifiedCollectionView.getSemantics(this.dataItemWrappersByRenderer[target]) == semanticProperty;
      }
      
      protected function isRendererUnconstrained(item:Object) : Boolean
      {
         return this.unconstrainedRenderers[item] != null;
      }
      
      protected function finishDataChangeEffect(event:EffectEvent) : void
      {
         this.collection = this.actualCollection;
         this.actualCollection = null;
         this.modifiedCollectionView = null;
         this.listContent.iterator = this.iterator = this.actualIterator;
         this.runningDataEffect = false;
         this.unconstrainedRenderers = new Dictionary();
         this.terminateSelectionTracking();
         this.reKeyVisibleData();
         var index:int = this.scrollPositionToIndex(this.horizontalScrollPosition - this.offscreenExtraColumnsLeft,this.verticalScrollPosition - this.offscreenExtraRowsTop);
         this.iterator.seek(CursorBookmark.FIRST,index);
         callLater(this.cleanupAfterDataChangeEffect);
      }
      
      private function cleanupAfterDataChangeEffect() : void
      {
         if(this.runningDataEffect || this.runDataEffectNextUpdate)
         {
            return;
         }
         var index:int = this.scrollPositionToIndex(this.horizontalScrollPosition - this.offscreenExtraColumnsLeft,this.verticalScrollPosition - this.offscreenExtraRowsTop);
         this.iterator.seek(CursorBookmark.FIRST,index);
         this.dataEffectCompleted = true;
         this.itemsSizeChanged = true;
         this.invalidateList();
         this.dataItemWrappersByRenderer = new Dictionary();
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var cursorPos:CursorBookmark = null;
         var rowIndex:int = 0;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(this.oldUnscaledWidth == unscaledWidth && this.oldUnscaledHeight == unscaledHeight && !this.itemsSizeChanged && !this.bSelectionChanged && !scrollAreaChanged)
         {
            return;
         }
         if(this.oldUnscaledWidth != unscaledWidth)
         {
            this.itemsSizeChanged = true;
         }
         this.removeClipMask();
         var g:Graphics = this.selectionLayer.graphics;
         g.clear();
         if(this.listContent.width > 0 && this.listContent.height > 0)
         {
            g.beginFill(8421504,0);
            g.drawRect(0,0,this.listContent.width,this.listContent.height);
            g.endFill();
         }
         if(this.rendererChanged)
         {
            this.purgeItemRenderers();
         }
         else if(this.dataEffectCompleted)
         {
            this.partialPurgeItemRenderers();
         }
         this.adjustListContent(unscaledWidth,unscaledHeight);
         var collectionHasItems:Boolean = Boolean(this.collection) && this.collection.length > 0;
         if(collectionHasItems)
         {
            this.adjustScrollPosition();
         }
         if(Boolean(this.oldUnscaledWidth == unscaledWidth && !scrollAreaChanged && !this.itemsSizeChanged && this.listItems.length > 0) && Boolean(this.iterator) && this.columnCount == 1)
         {
            rowIndex = this.listItems.length - 1;
            if(this.oldUnscaledHeight > unscaledHeight)
            {
               this.reduceRows(rowIndex);
            }
            else
            {
               this.makeAdditionalRows(rowIndex);
            }
         }
         else
         {
            if(Boolean(this.iterator))
            {
               cursorPos = this.iterator.bookmark;
            }
            this.clearIndicators();
            this.rendererTrackingSuspended = true;
            if(Boolean(this.iterator))
            {
               if(Boolean(this.offscreenExtraColumns) || Boolean(this.offscreenExtraColumnsLeft) || Boolean(this.offscreenExtraColumnsRight))
               {
                  this.makeRowsAndColumnsWithExtraColumns(unscaledWidth,unscaledHeight);
               }
               else
               {
                  this.makeRowsAndColumnsWithExtraRows(unscaledWidth,unscaledHeight);
               }
            }
            else
            {
               this.makeRowsAndColumns(0,0,this.listContent.width,this.listContent.height,0,0);
            }
            this.rendererTrackingSuspended = false;
            this.seekPositionIgnoreError(this.iterator,cursorPos);
         }
         this.oldUnscaledWidth = unscaledWidth;
         this.oldUnscaledHeight = unscaledHeight;
         this.configureScrollBars();
         this.addClipMask(true);
         this.itemsSizeChanged = false;
         this.wordWrapChanged = false;
         this.adjustSelectionSettings(collectionHasItems);
         if(this.keySelectionPending && this.iteratorValid)
         {
            this.keySelectionPending = false;
            this.finishKeySelection();
         }
      }
      
      protected function adjustListContent(unscaledWidth:Number = -1, unscaledHeight:Number = -1) : void
      {
         if(unscaledHeight < 0)
         {
            unscaledHeight = this.oldUnscaledHeight;
            unscaledWidth = this.oldUnscaledWidth;
         }
         var lcx:Number = viewMetrics.left + this.listContent.leftOffset;
         var lcy:Number = viewMetrics.top + this.listContent.topOffset;
         this.listContent.move(lcx,lcy);
         var ww:Number = Math.max(0,this.listContent.rightOffset) - lcx - viewMetrics.right;
         var hh:Number = Math.max(0,this.listContent.bottomOffset) - lcy - viewMetrics.bottom;
         this.listContent.setActualSize(unscaledWidth + ww,unscaledHeight + hh);
      }
      
      private function adjustScrollPosition() : void
      {
         var hPos:Number = NaN;
         var vPos:Number = NaN;
         var index:int = 0;
         var positionChanged:Boolean = false;
         if(!isNaN(this.horizontalScrollPositionPending))
         {
            positionChanged = true;
            hPos = Math.min(this.horizontalScrollPositionPending,maxHorizontalScrollPosition);
            this.horizontalScrollPositionPending = NaN;
            super.horizontalScrollPosition = hPos;
         }
         if(!isNaN(this.verticalScrollPositionPending))
         {
            positionChanged = true;
            vPos = Math.min(this.verticalScrollPositionPending,maxVerticalScrollPosition);
            this.verticalScrollPositionPending = NaN;
            super.verticalScrollPosition = vPos;
         }
         if(positionChanged)
         {
            index = this.scrollPositionToIndex(this.horizontalScrollPosition,this.verticalScrollPosition - this.offscreenExtraRowsTop);
            this.seekPositionSafely(index);
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function adjustOffscreenRowsAndColumns() : void
      {
         this.offscreenExtraColumns = 0;
         this.offscreenExtraRows = this.offscreenExtraRowsOrColumns;
      }
      
      protected function purgeItemRenderers() : void
      {
         var p:* = undefined;
         var row:Array = null;
         var item:IListItemRenderer = null;
         var freeRenderer:DisplayObject = null;
         var d:Dictionary = null;
         var q:* = undefined;
         this.rendererChanged = false;
         while(Boolean(this.listItems.length))
         {
            row = this.listItems.pop();
            while(Boolean(row.length))
            {
               item = IListItemRenderer(row.pop());
               if(Boolean(item))
               {
                  this.listContent.removeChild(DisplayObject(item));
                  if(Boolean(this.dataItemWrappersByRenderer[item]))
                  {
                     delete this.visibleData[this.itemToUID(this.dataItemWrappersByRenderer[item])];
                  }
                  else
                  {
                     delete this.visibleData[this.itemToUID(item.data)];
                  }
               }
            }
         }
         while(Boolean(this.freeItemRenderers.length))
         {
            freeRenderer = DisplayObject(this.freeItemRenderers.pop());
            if(Boolean(freeRenderer.parent))
            {
               this.listContent.removeChild(freeRenderer);
            }
         }
         for(p in this.freeItemRenderersByFactory)
         {
            d = this.freeItemRenderersByFactory[p];
            for(q in d)
            {
               freeRenderer = DisplayObject(q);
               delete d[q];
               if(Boolean(freeRenderer.parent))
               {
                  this.listContent.removeChild(freeRenderer);
               }
            }
         }
         this.rowMap = {};
         this.listContent.rowInfo = [];
      }
      
      private function partialPurgeItemRenderers() : void
      {
         var p:* = undefined;
         var uid:String = null;
         var freeRenderer:DisplayObject = null;
         var d:Dictionary = null;
         var q:* = undefined;
         this.dataEffectCompleted = false;
         while(Boolean(this.freeItemRenderers.length))
         {
            freeRenderer = DisplayObject(this.freeItemRenderers.pop());
            if(Boolean(freeRenderer.parent))
            {
               this.listContent.removeChild(freeRenderer);
            }
         }
         for(p in this.freeItemRenderersByFactory)
         {
            d = this.freeItemRenderersByFactory[p];
            for(q in d)
            {
               freeRenderer = DisplayObject(q);
               delete d[q];
               if(Boolean(freeRenderer.parent))
               {
                  this.listContent.removeChild(freeRenderer);
               }
            }
         }
         for(uid in this.reservedItemRenderers)
         {
            freeRenderer = DisplayObject(this.reservedItemRenderers[uid]);
            if(Boolean(freeRenderer.parent))
            {
               this.listContent.removeChild(freeRenderer);
            }
         }
         this.reservedItemRenderers = {};
         this.rowMap = {};
         this.clearVisibleData();
      }
      
      private function reduceRows(rowIndex:int) : void
      {
         var colLen:int = 0;
         var j:int = 0;
         var uid:String = null;
         while(rowIndex >= 0)
         {
            if(this.rowInfo[rowIndex].y < this.listContent.height)
            {
               break;
            }
            colLen = int(this.listItems[rowIndex].length);
            for(j = 0; j < colLen; j++)
            {
               this.addToFreeItemRenderers(this.listItems[rowIndex][j]);
            }
            uid = this.rowInfo[rowIndex].uid;
            delete this.visibleData[uid];
            this.removeIndicators(uid);
            this.listItems.pop();
            this.rowInfo.pop();
            rowIndex--;
         }
      }
      
      private function makeAdditionalRows(rowIndex:int) : void
      {
         var curY:Number;
         var cursorPos:CursorBookmark = null;
         if(Boolean(this.iterator))
         {
            cursorPos = this.iterator.bookmark;
            try
            {
               this.iterator.seek(CursorBookmark.CURRENT,this.listItems.length);
            }
            catch(e:ItemPendingError)
            {
               iteratorValid = false;
            }
         }
         curY = this.rowInfo[rowIndex].y + this.rowInfo[rowIndex].height;
         this.makeRowsAndColumns(0,curY,this.listContent.width,this.listContent.height,0,rowIndex + 1);
         this.seekPositionIgnoreError(this.iterator,cursorPos);
      }
      
      private function adjustSelectionSettings(collectionHasItems:Boolean) : void
      {
         if(this.bSelectionChanged)
         {
            this.bSelectionChanged = false;
            if(this.bSelectedIndicesChanged && (collectionHasItems || this._selectedIndices == null))
            {
               this.bSelectedIndicesChanged = false;
               this.bSelectedIndexChanged = false;
               this.commitSelectedIndices(this._selectedIndices);
            }
            if(this.bSelectedItemChanged && (collectionHasItems || this._selectedItem == null))
            {
               this.bSelectedItemChanged = false;
               this.bSelectedIndexChanged = false;
               this.commitSelectedItem(this._selectedItem);
            }
            if(this.bSelectedItemsChanged && (collectionHasItems || this._selectedItems == null))
            {
               this.bSelectedItemsChanged = false;
               this.bSelectedIndexChanged = false;
               this.commitSelectedItems(this._selectedItems);
            }
            if(this.bSelectedIndexChanged && (collectionHasItems || this._selectedIndex == -1))
            {
               this.commitSelectedIndex(this._selectedIndex);
               this.bSelectedIndexChanged = false;
            }
         }
      }
      
      private function seekPositionIgnoreError(iterator:IViewCursor, cursorPos:CursorBookmark) : void
      {
         if(Boolean(iterator))
         {
            try
            {
               iterator.seek(cursorPos,0);
            }
            catch(e:ItemPendingError)
            {
            }
         }
      }
      
      private function seekNextSafely(iterator:IViewCursor, pos:int) : Boolean
      {
         try
         {
            iterator.moveNext();
         }
         catch(e:ItemPendingError)
         {
            lastSeekPending = new ListBaseSeekPending(CursorBookmark.FIRST,pos);
            e.addResponder(new ItemResponder(seekPendingResultHandler,seekPendingFailureHandler,lastSeekPending));
            iteratorValid = false;
         }
         return this.iteratorValid;
      }
      
      private function seekPreviousSafely(iterator:IViewCursor, pos:int) : Boolean
      {
         try
         {
            iterator.movePrevious();
         }
         catch(e:ItemPendingError)
         {
            lastSeekPending = new ListBaseSeekPending(CursorBookmark.FIRST,pos);
            e.addResponder(new ItemResponder(seekPendingResultHandler,seekPendingFailureHandler,lastSeekPending));
            iteratorValid = false;
         }
         return this.iteratorValid;
      }
      
      protected function seekPositionSafely(index:int) : Boolean
      {
         try
         {
            this.iterator.seek(CursorBookmark.FIRST,index);
            if(!this.iteratorValid)
            {
               this.iteratorValid = true;
               this.lastSeekPending = null;
            }
         }
         catch(e:ItemPendingError)
         {
            lastSeekPending = new ListBaseSeekPending(CursorBookmark.FIRST,index);
            e.addResponder(new ItemResponder(seekPendingResultHandler,seekPendingFailureHandler,lastSeekPending));
            iteratorValid = false;
         }
         return this.iteratorValid;
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         var n:int = 0;
         var i:int = 0;
         var m:int = 0;
         var j:int = 0;
         if(Boolean(this.IS_ITEM_STYLE[styleProp]))
         {
            this.itemsSizeChanged = true;
            invalidateDisplayList();
         }
         else if(styleProp == "paddingTop")
         {
            this.cachedPaddingTopInvalid = true;
            invalidateProperties();
         }
         else if(styleProp == "paddingBottom")
         {
            this.cachedPaddingBottomInvalid = true;
            invalidateProperties();
         }
         else if(styleProp == "verticalAlign")
         {
            this.cachedVerticalAlignInvalid = true;
            invalidateProperties();
         }
         else if(styleProp == "itemsChangeEffect")
         {
            this.cachedItemsChangeEffect = null;
         }
         else if(Boolean(this.listContent) && Boolean(this.listItems))
         {
            n = int(this.listItems.length);
            for(i = 0; i < n; i++)
            {
               m = int(this.listItems[i].length);
               for(j = 0; j < m; j++)
               {
                  if(Boolean(this.listItems[i][j]))
                  {
                     this.listItems[i][j].styleChanged(styleProp);
                  }
               }
            }
         }
         super.styleChanged(styleProp);
         if(invalidateSizeFlag)
         {
            this.itemsNeedMeasurement = true;
            invalidateProperties();
         }
         if(styleManager.isSizeInvalidatingStyle(styleProp))
         {
            scrollAreaChanged = true;
         }
      }
      
      public function measureWidthOfItems(index:int = -1, count:int = 0) : Number
      {
         return NaN;
      }
      
      public function measureHeightOfItems(index:int = -1, count:int = 0) : Number
      {
         return NaN;
      }
      
      public function itemToLabel(data:Object) : String
      {
         if(data == null)
         {
            return " ";
         }
         if(this.labelFunction != null)
         {
            return this.labelFunction(data);
         }
         if(data is XML)
         {
            try
            {
               if(data[this.labelField].length() != 0)
               {
                  data = data[this.labelField];
               }
            }
            catch(e:Error)
            {
            }
         }
         else if(data is Object)
         {
            try
            {
               if(data[this.labelField] != null)
               {
                  data = data[this.labelField];
               }
            }
            catch(e:Error)
            {
            }
         }
         if(data is String)
         {
            return String(data);
         }
         try
         {
            return data.toString();
         }
         catch(e:Error)
         {
         }
         return " ";
      }
      
      public function itemToDataTip(data:Object) : String
      {
         if(data == null)
         {
            return " ";
         }
         if(this.dataTipFunction != null)
         {
            return this.dataTipFunction(data);
         }
         if(data is XML)
         {
            try
            {
               if(data[this.dataTipField].length() != 0)
               {
                  data = data[this.dataTipField];
               }
            }
            catch(e:Error)
            {
            }
         }
         else if(data is Object)
         {
            try
            {
               if(data[this.dataTipField] != null)
               {
                  data = data[this.dataTipField];
               }
               else if(data.label != null)
               {
                  data = data.label;
               }
            }
            catch(e:Error)
            {
            }
         }
         if(data is String)
         {
            return String(data);
         }
         try
         {
            return data.toString();
         }
         catch(e:Error)
         {
         }
         return " ";
      }
      
      public function itemToIcon(data:Object) : Class
      {
         var iconClass:Class = null;
         var icon:* = undefined;
         if(data == null)
         {
            return null;
         }
         if(this.iconFunction != null)
         {
            return this.iconFunction(data);
         }
         if(data is XML)
         {
            try
            {
               if(data[this.iconField].length() != 0)
               {
                  icon = String(data[this.iconField]);
                  if(icon != null)
                  {
                     iconClass = Class(systemManager.getDefinitionByName(icon));
                     if(Boolean(iconClass))
                     {
                        return iconClass;
                     }
                     return document[icon];
                  }
               }
            }
            catch(e:Error)
            {
            }
         }
         else if(data is Object)
         {
            try
            {
               if(data[this.iconField] != null)
               {
                  if(data[this.iconField] is Class)
                  {
                     return data[this.iconField];
                  }
                  if(data[this.iconField] is String)
                  {
                     iconClass = Class(systemManager.getDefinitionByName(data[this.iconField]));
                     if(Boolean(iconClass))
                     {
                        return iconClass;
                     }
                     return document[data[this.iconField]];
                  }
               }
            }
            catch(e:Error)
            {
            }
         }
         return null;
      }
      
      protected function makeRowsAndColumns(left:Number, top:Number, right:Number, bottom:Number, firstColumn:int, firstRow:int, byCount:Boolean = false, rowsNeeded:uint = 0) : Point
      {
         return new Point(0,0);
      }
      
      public function indicesToIndex(rowIndex:int, colIndex:int) : int
      {
         return rowIndex * this.columnCount + colIndex;
      }
      
      protected function indexToRow(index:int) : int
      {
         return index;
      }
      
      protected function indexToColumn(index:int) : int
      {
         return 0;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function indicesToItemRenderer(row:int, col:int) : IListItemRenderer
      {
         return this.listItems[row][col];
      }
      
      protected function itemRendererToIndices(item:IListItemRenderer) : Point
      {
         if(!item || !(item.name in this.rowMap))
         {
            return null;
         }
         var index:int = int(this.rowMap[item.name].rowIndex);
         var len:int = int(this.listItems[index].length);
         for(var i:int = 0; i < len; i++)
         {
            if(this.listItems[index][i] == item)
            {
               break;
            }
         }
         return new Point(i + this.horizontalScrollPosition,index + this.verticalScrollPosition + this.offscreenExtraRowsTop);
      }
      
      public function indexToItemRenderer(index:int) : IListItemRenderer
      {
         var firstItemIndex:int = this.verticalScrollPosition - this.offscreenExtraRowsTop;
         if(index < firstItemIndex || index >= firstItemIndex + this.listItems.length)
         {
            return null;
         }
         return this.listItems[index - firstItemIndex][0];
      }
      
      public function itemRendererToIndex(itemRenderer:IListItemRenderer) : int
      {
         var index:int = 0;
         if(itemRenderer.name in this.rowMap)
         {
            index = int(this.rowMap[itemRenderer.name].rowIndex);
            return index + this.verticalScrollPosition - this.offscreenExtraRowsTop;
         }
         return int.MIN_VALUE;
      }
      
      protected function itemToUID(data:Object) : String
      {
         if(data == null)
         {
            return "null";
         }
         return UIDUtil.getUID(data);
      }
      
      protected function UIDToItemRenderer(uid:String) : IListItemRenderer
      {
         if(!this.listContent)
         {
            return null;
         }
         return this.visibleData[uid];
      }
      
      public function itemToItemRenderer(item:Object) : IListItemRenderer
      {
         return this.UIDToItemRenderer(this.itemToUID(item));
      }
      
      public function isItemVisible(item:Object) : Boolean
      {
         return this.itemToItemRenderer(item) != null;
      }
      
      protected function mouseEventToItemRenderer(event:MouseEvent) : IListItemRenderer
      {
         return this.mouseEventToItemRendererOrEditor(event);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function mouseEventToItemRendererOrEditor(event:MouseEvent) : IListItemRenderer
      {
         var pt:Point = null;
         var yy:Number = NaN;
         var n:int = 0;
         var i:int = 0;
         var m:int = 0;
         var j:int = 0;
         var target:DisplayObject = DisplayObject(event.target);
         if(target == this.listContent)
         {
            pt = new Point(event.stageX,event.stageY);
            pt = this.listContent.globalToLocal(pt);
            yy = 0;
            n = int(this.listItems.length);
            for(i = 0; i < n; i++)
            {
               if(Boolean(this.listItems[i].length))
               {
                  if(pt.y < yy + this.rowInfo[i].height)
                  {
                     m = int(this.listItems[i].length);
                     if(m == 1)
                     {
                        return this.listItems[i][0];
                     }
                     j = Math.floor(pt.x / this.columnWidth);
                     return this.listItems[i][j];
                  }
               }
               yy += this.rowInfo[i].height;
            }
         }
         else if(target == this.highlightIndicator)
         {
            return this.lastHighlightItemRenderer;
         }
         while(Boolean(target) && target != this)
         {
            if(target is IListItemRenderer && target.parent == this.listContent)
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
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function hasOnlyTextRenderers() : Boolean
      {
         if(this.listItems.length == 0)
         {
            return true;
         }
         var rowItems:Array = this.listItems[this.listItems.length - 1];
         var n:int = int(rowItems.length);
         for(var i:int = 0; i < n; i++)
         {
            if(!(rowItems[i] is IUITextField))
            {
               return false;
            }
         }
         return true;
      }
      
      public function itemRendererContains(renderer:IListItemRenderer, object:DisplayObject) : Boolean
      {
         if(!object)
         {
            return false;
         }
         if(!renderer)
         {
            return false;
         }
         return renderer.owns(object);
      }
      
      protected function addToFreeItemRenderers(item:IListItemRenderer) : void
      {
         DisplayObject(item).visible = false;
         var factory:IFactory = this.factoryMap[item];
         var oldWrapper:ItemWrapper = this.dataItemWrappersByRenderer[item];
         var UID:String = Boolean(oldWrapper) ? this.itemToUID(oldWrapper) : this.itemToUID(item.data);
         if(this.visibleData[UID] == item)
         {
            delete this.visibleData[UID];
         }
         if(Boolean(oldWrapper))
         {
            this.reservedItemRenderers[this.itemToUID(oldWrapper)] = item;
         }
         else
         {
            if(!this.freeItemRenderersByFactory)
            {
               this.freeItemRenderersByFactory = new Dictionary(true);
            }
            if(this.freeItemRenderersByFactory[factory] == undefined)
            {
               this.freeItemRenderersByFactory[factory] = new Dictionary(true);
            }
            this.freeItemRenderersByFactory[factory][item] = 1;
            if(factory == this.itemRenderer)
            {
               this.freeItemRenderers.push(item);
            }
         }
         delete this.rowMap[item.name];
      }
      
      protected function getReservedOrFreeItemRenderer(data:Object) : IListItemRenderer
      {
         var item:IListItemRenderer = null;
         var uid:String = null;
         var factory:IFactory = null;
         var freeRenderers:Dictionary = null;
         var p:* = undefined;
         if(this.runningDataEffect)
         {
            item = IListItemRenderer(this.reservedItemRenderers[uid = this.itemToUID(data)]);
         }
         if(Boolean(item))
         {
            delete this.reservedItemRenderers[uid];
         }
         else
         {
            factory = this.getItemRendererFactory(data);
            if(Boolean(this.freeItemRenderersByFactory))
            {
               if(factory == this.itemRenderer)
               {
                  if(Boolean(this.freeItemRenderers.length))
                  {
                     item = this.freeItemRenderers.pop();
                     delete this.freeItemRenderersByFactory[factory][item];
                  }
               }
               else
               {
                  freeRenderers = this.freeItemRenderersByFactory[factory];
                  if(Boolean(freeRenderers))
                  {
                     var _loc7_:int = 0;
                     var _loc8_:* = freeRenderers;
                     for(p in _loc8_)
                     {
                        item = p;
                        delete this.freeItemRenderersByFactory[factory][item];
                     }
                  }
               }
            }
         }
         return item;
      }
      
      public function getItemRendererFactory(data:Object) : IFactory
      {
         if(data == null)
         {
            return this.nullItemRenderer;
         }
         return this.itemRenderer;
      }
      
      protected function drawRowBackgrounds() : void
      {
      }
      
      protected function drawItem(item:IListItemRenderer, selected:Boolean = false, highlighted:Boolean = false, caret:Boolean = false, transition:Boolean = false) : void
      {
         var o:Sprite = null;
         var g:Graphics = null;
         var effectiveRowY:Number = NaN;
         var oldCaretItemRenderer:IListItemRenderer = null;
         if(!item)
         {
            return;
         }
         var contentHolder:ListBaseContentHolder = DisplayObject(item).parent as ListBaseContentHolder;
         if(!contentHolder)
         {
            return;
         }
         var rowInfo:Array = contentHolder.rowInfo;
         var selectionLayer:Sprite = contentHolder.selectionLayer;
         var rowData:BaseListData = this.rowMap[item.name];
         if(!rowData)
         {
            return;
         }
         if(highlighted && (!this.highlightItemRenderer || this.highlightUID != rowData.uid))
         {
            if(!this.highlightIndicator)
            {
               o = new SpriteAsset();
               selectionLayer.addChild(DisplayObject(o));
               this.highlightIndicator = o;
            }
            else if(this.highlightIndicator.parent != selectionLayer)
            {
               selectionLayer.addChild(this.highlightIndicator);
            }
            else
            {
               selectionLayer.setChildIndex(DisplayObject(this.highlightIndicator),selectionLayer.numChildren - 1);
            }
            o = this.highlightIndicator;
            if(o is ILayoutDirectionElement)
            {
               ILayoutDirectionElement(o).layoutDirection = null;
            }
            this.drawHighlightIndicator(o,item.x,rowInfo[rowData.rowIndex].y,item.width,rowInfo[rowData.rowIndex].height,getStyle("rollOverColor"),item);
            this.lastHighlightItemRenderer = this.highlightItemRenderer = item;
            this.highlightUID = rowData.uid;
         }
         else if(Boolean(!highlighted) && Boolean(this.highlightItemRenderer) && (Boolean(rowData) && Boolean(this.highlightUID == rowData.uid)))
         {
            this.clearHighlightIndicator(this.highlightIndicator,item);
            this.highlightItemRenderer = null;
            this.highlightUID = null;
         }
         if(selected)
         {
            effectiveRowY = this.runningDataEffect ? item.y - this.cachedPaddingTop : Number(rowInfo[rowData.rowIndex].y);
            if(!this.selectionIndicators[rowData.uid])
            {
               o = new SpriteAsset();
               o.mouseEnabled = false;
               ILayoutDirectionElement(o).layoutDirection = null;
               selectionLayer.addChild(DisplayObject(o));
               this.selectionIndicators[rowData.uid] = o;
               this.drawSelectionIndicator(o,item.x,effectiveRowY,item.width,rowInfo[rowData.rowIndex].height,enabled ? uint(getStyle("selectionColor")) : uint(getStyle("selectionDisabledColor")),item);
               if(transition)
               {
                  this.applySelectionEffect(o,rowData.uid,item);
               }
            }
            else
            {
               o = this.selectionIndicators[rowData.uid];
               if(o is ILayoutDirectionElement)
               {
                  ILayoutDirectionElement(o).layoutDirection = null;
               }
               this.drawSelectionIndicator(o,item.x,effectiveRowY,item.width,rowInfo[rowData.rowIndex].height,enabled ? uint(getStyle("selectionColor")) : uint(getStyle("selectionDisabledColor")),item);
            }
         }
         else if(!selected)
         {
            if(Boolean(rowData) && Boolean(this.selectionIndicators[rowData.uid]))
            {
               if(Boolean(this.selectionTweens[rowData.uid]))
               {
                  this.selectionTweens[rowData.uid].removeEventListener(TweenEvent.TWEEN_UPDATE,this.selectionTween_updateHandler);
                  this.selectionTweens[rowData.uid].removeEventListener(TweenEvent.TWEEN_END,this.selectionTween_endHandler);
                  if(this.selectionIndicators[rowData.uid].alpha < 1)
                  {
                     Tween.removeTween(this.selectionTweens[rowData.uid]);
                  }
                  delete this.selectionTweens[rowData.uid];
               }
               selectionLayer.removeChild(this.selectionIndicators[rowData.uid]);
               delete this.selectionIndicators[rowData.uid];
            }
         }
         if(caret)
         {
            if(this.showCaret)
            {
               if(!this.caretIndicator)
               {
                  o = new SpriteAsset();
                  o.mouseEnabled = false;
                  selectionLayer.addChild(DisplayObject(o));
                  this.caretIndicator = o;
               }
               else if(this.caretIndicator.parent != selectionLayer)
               {
                  selectionLayer.addChild(this.caretIndicator);
               }
               else
               {
                  selectionLayer.setChildIndex(DisplayObject(this.caretIndicator),selectionLayer.numChildren - 1);
               }
               o = this.caretIndicator;
               if(o is ILayoutDirectionElement)
               {
                  ILayoutDirectionElement(o).layoutDirection = null;
               }
               this.drawCaretIndicator(o,item.x,rowInfo[rowData.rowIndex].y,item.width,rowInfo[rowData.rowIndex].height,getStyle("selectionColor"),item);
               oldCaretItemRenderer = this.caretItemRenderer;
               this.caretItemRenderer = item;
               this.caretUID = rowData.uid;
               if(Boolean(oldCaretItemRenderer))
               {
                  if(oldCaretItemRenderer is IFlexDisplayObject)
                  {
                     if(oldCaretItemRenderer is IInvalidating)
                     {
                        IInvalidating(oldCaretItemRenderer).invalidateDisplayList();
                        IInvalidating(oldCaretItemRenderer).validateNow();
                     }
                  }
                  else if(oldCaretItemRenderer is IUITextField)
                  {
                     IUITextField(oldCaretItemRenderer).validateNow();
                  }
               }
            }
         }
         else if(Boolean(!caret) && Boolean(this.caretItemRenderer) && this.caretUID == rowData.uid)
         {
            this.clearCaretIndicator(this.caretIndicator,item);
            this.caretItemRenderer = null;
            this.caretUID = "";
         }
         if(item is IFlexDisplayObject)
         {
            if(item is IInvalidating)
            {
               IInvalidating(item).invalidateDisplayList();
               IInvalidating(item).validateNow();
            }
         }
         else if(item is IUITextField)
         {
            IUITextField(item).validateNow();
         }
      }
      
      protected function drawHighlightIndicator(indicator:Sprite, x:Number, y:Number, width:Number, height:Number, color:uint, itemRenderer:IListItemRenderer) : void
      {
         var g:Graphics = Sprite(indicator).graphics;
         g.clear();
         g.beginFill(color);
         g.drawRect(0,0,width,height);
         g.endFill();
         indicator.x = x;
         indicator.y = y;
      }
      
      protected function clearHighlightIndicator(indicator:Sprite, itemRenderer:IListItemRenderer) : void
      {
         if(Boolean(this.highlightIndicator))
         {
            Sprite(this.highlightIndicator).graphics.clear();
         }
      }
      
      protected function drawSelectionIndicator(indicator:Sprite, x:Number, y:Number, width:Number, height:Number, color:uint, itemRenderer:IListItemRenderer) : void
      {
         var g:Graphics = Sprite(indicator).graphics;
         g.clear();
         g.beginFill(color);
         g.drawRect(0,0,width,height);
         g.endFill();
         indicator.x = x;
         indicator.y = y;
      }
      
      protected function drawCaretIndicator(indicator:Sprite, x:Number, y:Number, width:Number, height:Number, color:uint, itemRenderer:IListItemRenderer) : void
      {
         var g:Graphics = Sprite(indicator).graphics;
         g.clear();
         g.lineStyle(1,color,1);
         g.drawRect(0,0,width - 1,height - 1);
         indicator.x = x;
         indicator.y = y;
      }
      
      protected function clearCaretIndicator(indicator:Sprite, itemRenderer:IListItemRenderer) : void
      {
         if(Boolean(this.caretIndicator))
         {
            Sprite(this.caretIndicator).graphics.clear();
         }
      }
      
      protected function clearIndicators() : void
      {
         var uniqueID:String = null;
         for(uniqueID in this.selectionTweens)
         {
            this.removeIndicators(uniqueID);
         }
         while(this.selectionLayer.numChildren > 0)
         {
            this.selectionLayer.removeChildAt(0);
         }
         this.selectionTweens = {};
         this.selectionIndicators = {};
         this.highlightIndicator = null;
         this.highlightUID = null;
         this.caretIndicator = null;
         this.caretUID = null;
      }
      
      protected function removeIndicators(uid:String) : void
      {
         if(Boolean(this.selectionTweens[uid]))
         {
            this.selectionTweens[uid].removeEventListener(TweenEvent.TWEEN_UPDATE,this.selectionTween_updateHandler);
            this.selectionTweens[uid].removeEventListener(TweenEvent.TWEEN_END,this.selectionTween_endHandler);
            if(this.selectionIndicators[uid].alpha < 1)
            {
               Tween.removeTween(this.selectionTweens[uid]);
            }
            delete this.selectionTweens[uid];
         }
         if(Boolean(this.selectionIndicators[uid]))
         {
            this.selectionIndicators[uid].parent.removeChild(this.selectionIndicators[uid]);
            this.selectionIndicators[uid] = null;
         }
         if(uid == this.highlightUID)
         {
            this.highlightItemRenderer = null;
            this.highlightUID = null;
            this.clearHighlightIndicator(this.highlightIndicator,this.UIDToItemRenderer(uid));
         }
         if(uid == this.caretUID)
         {
            this.caretItemRenderer = null;
            this.caretUID = null;
            this.clearCaretIndicator(this.caretIndicator,this.UIDToItemRenderer(uid));
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function clearHighlight(item:IListItemRenderer) : void
      {
         var listEvent:ListEvent = null;
         var uid:String = this.itemToUID(item.data);
         this.drawItem(this.UIDToItemRenderer(uid),this.isItemSelected(item.data),false,uid == this.caretUID);
         var pt:Point = this.itemRendererToIndices(item);
         if(Boolean(pt) && Boolean(this.lastHighlightItemIndices))
         {
            listEvent = new ListEvent(ListEvent.ITEM_ROLL_OUT);
            listEvent.columnIndex = this.lastHighlightItemIndices.x;
            listEvent.rowIndex = this.lastHighlightItemIndices.y;
            listEvent.itemRenderer = this.lastHighlightItemRendererAtIndices;
            dispatchEvent(listEvent);
            this.lastHighlightItemIndices = null;
         }
      }
      
      public function invalidateList() : void
      {
         this.itemsSizeChanged = true;
         invalidateDisplayList();
      }
      
      protected function updateList() : void
      {
         this.removeClipMask();
         var cursorPos:CursorBookmark = Boolean(this.iterator) ? this.iterator.bookmark : null;
         this.clearIndicators();
         this.clearVisibleData();
         if(Boolean(this.iterator))
         {
            if(Boolean(this.offscreenExtraColumns) || Boolean(this.offscreenExtraColumnsLeft) || Boolean(this.offscreenExtraColumnsRight))
            {
               this.makeRowsAndColumnsWithExtraColumns(unscaledWidth,unscaledHeight);
            }
            else
            {
               this.makeRowsAndColumnsWithExtraRows(unscaledWidth,unscaledHeight);
            }
            this.iterator.seek(cursorPos,0);
         }
         else
         {
            this.makeRowsAndColumns(0,0,this.listContent.width,this.listContent.height,0,0);
         }
         this.drawRowBackgrounds();
         this.configureScrollBars();
         this.addClipMask(true);
      }
      
      protected function clearVisibleData() : void
      {
         this.listContent.visibleData = {};
      }
      
      protected function reKeyVisibleData() : void
      {
         var item:Object = null;
         var newVisibleData:Object = {};
         for each(item in this.visibleData)
         {
            if(Boolean(item.data))
            {
               newVisibleData[this.itemToUID(item.data)] = item;
            }
         }
         this.listContent.visibleData = newVisibleData;
      }
      
      protected function set allowItemSizeChangeNotification(value:Boolean) : void
      {
         this.listContent.allowItemSizeChangeNotification = value;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function addClipMask(layoutChanged:Boolean) : void
      {
         var item:DisplayObject = null;
         var yOffset:Number = NaN;
         if(layoutChanged)
         {
            if(Boolean(horizontalScrollBar && horizontalScrollBar.visible || this.hasOnlyTextRenderers() || this.runningDataEffect || this.listContent.bottomOffset != 0 || this.listContent.topOffset != 0) || Boolean(this.listContent.leftOffset != 0) || this.listContent.rightOffset != 0)
            {
               this.listContent.mask = maskShape;
               this.selectionLayer.mask = null;
            }
            else
            {
               this.listContent.mask = null;
               this.selectionLayer.mask = maskShape;
            }
         }
         if(Boolean(this.listContent.mask))
         {
            return;
         }
         var lastRowIndex:int = this.listItems.length - 1;
         var lastRowInfo:ListRowInfo = this.rowInfo[lastRowIndex];
         var lastRowItems:Array = this.listItems[lastRowIndex];
         if(lastRowInfo.y + lastRowInfo.height <= this.listContent.height)
         {
            return;
         }
         var numColumns:int = int(lastRowItems.length);
         var rowY:Number = lastRowInfo.y;
         var rowWidth:Number = Number(this.listContent.width);
         var rowHeight:Number = this.listContent.height - lastRowInfo.y;
         for(var i:int = 0; i < numColumns; i++)
         {
            item = lastRowItems[i];
            yOffset = item.y - rowY;
            if(item is IUITextField && !IUITextField(item).embedFonts)
            {
               item.height = Math.max(rowHeight - yOffset,0);
            }
            else
            {
               item.mask = this.createItemMask(0,rowY + yOffset,rowWidth,Math.max(rowHeight - yOffset,0));
            }
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function createItemMask(x:Number, y:Number, width:Number, height:Number, contentHolder:DisplayObjectContainer = null) : DisplayObject
      {
         var mask:Shape = null;
         var g:Graphics = null;
         if(!this.itemMaskFreeList)
         {
            this.itemMaskFreeList = [];
         }
         if(this.itemMaskFreeList.length > 0)
         {
            mask = this.itemMaskFreeList.pop();
            if(mask.width != width)
            {
               mask.width = width;
            }
            if(mask.height != height)
            {
               mask.height = height;
            }
         }
         else
         {
            mask = new FlexShape();
            mask.name = "mask";
            g = mask.graphics;
            g.beginFill(16777215);
            g.drawRect(0,0,width,height);
            g.endFill();
            mask.visible = false;
            if(Boolean(contentHolder))
            {
               contentHolder.addChild(mask);
            }
            else
            {
               this.listContent.addChild(mask);
            }
         }
         if(mask.x != x)
         {
            mask.x = x;
         }
         if(mask.y != y)
         {
            mask.y = y;
         }
         return mask;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function removeClipMask() : void
      {
         var item:DisplayObject = null;
         if(Boolean(this.listContent) && Boolean(this.listContent.mask))
         {
            return;
         }
         var lastRowIndex:int = this.listItems.length - 1;
         if(lastRowIndex < 0)
         {
            return;
         }
         var rowHeight:Number = Number(this.rowInfo[lastRowIndex].height);
         var lastRowInfo:ListRowInfo = this.rowInfo[lastRowIndex];
         var lastRowItems:Array = this.listItems[lastRowIndex];
         var numColumns:int = int(lastRowItems.length);
         for(var i:int = 0; i < numColumns; i++)
         {
            item = lastRowItems[i];
            if(item is IUITextField && !IUITextField(item).embedFonts)
            {
               if(item.height != rowHeight - (item.y - lastRowInfo.y))
               {
                  item.height = rowHeight - (item.y - lastRowInfo.y);
               }
            }
            else if(Boolean(item) && Boolean(item.mask))
            {
               this.itemMaskFreeList.push(item.mask);
               item.mask = null;
            }
         }
      }
      
      public function isItemShowingCaret(data:Object) : Boolean
      {
         if(data == null)
         {
            return false;
         }
         if(data is String)
         {
            return data == this.caretUID;
         }
         return this.itemToUID(data) == this.caretUID;
      }
      
      public function isItemHighlighted(data:Object) : Boolean
      {
         if(data == null)
         {
            return false;
         }
         var isSelected:Boolean = Boolean(this.highlightUID) && Boolean(this.selectedData[this.highlightUID]);
         if(data is String)
         {
            return data == this.highlightUID && !isSelected;
         }
         return this.itemToUID(data) == this.highlightUID && !isSelected;
      }
      
      public function isItemSelected(data:Object) : Boolean
      {
         if(data == null)
         {
            return false;
         }
         if(data is String)
         {
            return this.selectedData[data] != undefined;
         }
         return this.selectedData[this.itemToUID(data)] != undefined;
      }
      
      public function isItemSelectable(data:Object) : Boolean
      {
         if(!this.selectable)
         {
            return false;
         }
         if(data == null)
         {
            return false;
         }
         return true;
      }
      
      private function calculateSelectedIndexAndItem() : void
      {
         var p:String = null;
         var num:int = 0;
         var _loc3_:int = 0;
         var _loc4_:* = this.selectedData;
         for(p in _loc4_)
         {
            num = 1;
         }
         if(!num)
         {
            this._selectedIndex = -1;
            this._selectedItem = null;
            return;
         }
         this._selectedIndex = this.selectedData[p].index;
         this._selectedItem = this.selectedData[p].data;
      }
      
      protected function selectItem(item:IListItemRenderer, shiftKey:Boolean, ctrlKey:Boolean, transition:Boolean = true) : Boolean
      {
         var selectionChange:Boolean;
         var uid:String;
         var placeHolder:CursorBookmark = null;
         var index:int = 0;
         var numSelected:int = 0;
         var curSelectionData:ListBaseSelectionData = null;
         var oldAnchorBookmark:CursorBookmark = null;
         var oldAnchorIndex:int = 0;
         var incr:Boolean = false;
         if(!item || !this.isItemSelectable(item.data))
         {
            return false;
         }
         selectionChange = false;
         placeHolder = this.iterator.bookmark;
         index = this.itemRendererToIndex(item);
         uid = this.itemToUID(item.data);
         if(!this.allowMultipleSelection || !shiftKey && !ctrlKey)
         {
            numSelected = 0;
            if(this.allowMultipleSelection)
            {
               curSelectionData = this.firstSelectionData;
               if(curSelectionData != null)
               {
                  numSelected++;
                  if(Boolean(curSelectionData.nextSelectionData))
                  {
                     numSelected++;
                  }
               }
            }
            if(ctrlKey && Boolean(this.selectedData[uid]))
            {
               selectionChange = true;
               this.clearSelected(transition);
            }
            else if(this._selectedIndex != index || this.bSelectedIndexChanged || this.allowMultipleSelection && numSelected != 1)
            {
               selectionChange = true;
               this.clearSelected(transition);
               this.insertSelectionDataBefore(uid,new ListBaseSelectionData(item.data,index,this.approximate),this.firstSelectionData);
               this.drawItem(this.UIDToItemRenderer(uid),true,uid == this.highlightUID,true,transition);
               this._selectedIndex = index;
               this._selectedItem = item.data;
               this.iterator.seek(CursorBookmark.CURRENT,this._selectedIndex - this.indicesToIndex(this.verticalScrollPosition - this.offscreenExtraRowsTop,this.horizontalScrollPosition - this.offscreenExtraColumnsLeft));
               this.caretIndex = this._selectedIndex;
               this.caretBookmark = this.iterator.bookmark;
               this.anchorIndex = this._selectedIndex;
               this.anchorBookmark = this.iterator.bookmark;
               this.iterator.seek(placeHolder,0);
            }
         }
         else if(shiftKey && this.allowMultipleSelection)
         {
            if(Boolean(this.anchorBookmark))
            {
               oldAnchorBookmark = this.anchorBookmark;
               oldAnchorIndex = this.anchorIndex;
               incr = this.anchorIndex < index;
               this.clearSelected(false);
               this.caretIndex = index;
               this.caretBookmark = this.iterator.bookmark;
               this.anchorIndex = oldAnchorIndex;
               this.anchorBookmark = oldAnchorBookmark;
               this._selectedIndex = index;
               this._selectedItem = item.data;
               try
               {
                  this.iterator.seek(this.anchorBookmark,0);
               }
               catch(e:ItemPendingError)
               {
                  e.addResponder(new ItemResponder(selectionPendingResultHandler,selectionPendingFailureHandler,new ListBaseSelectionPending(incr,index,item.data,transition,placeHolder,CursorBookmark.CURRENT,0)));
                  iteratorValid = false;
               }
               this.shiftSelectionLoop(incr,this.anchorIndex,item.data,transition,placeHolder);
            }
            selectionChange = true;
         }
         else if(ctrlKey && this.allowMultipleSelection)
         {
            if(Boolean(this.selectedData[uid]))
            {
               this.removeSelectionData(uid);
               this.drawItem(this.UIDToItemRenderer(uid),false,uid == this.highlightUID,true,transition);
               if(item.data == this.selectedItem)
               {
                  this.calculateSelectedIndexAndItem();
               }
            }
            else
            {
               this.insertSelectionDataBefore(uid,new ListBaseSelectionData(item.data,index,this.approximate),this.firstSelectionData);
               this.drawItem(this.UIDToItemRenderer(uid),true,uid == this.highlightUID,true,transition);
               this._selectedIndex = index;
               this._selectedItem = item.data;
            }
            this.iterator.seek(CursorBookmark.CURRENT,index - this.indicesToIndex(this.verticalScrollPosition,this.horizontalScrollPosition));
            this.caretIndex = index;
            this.caretBookmark = this.iterator.bookmark;
            this.anchorIndex = index;
            this.anchorBookmark = this.iterator.bookmark;
            this.iterator.seek(placeHolder,0);
            selectionChange = true;
         }
         return selectionChange;
      }
      
      private function shiftSelectionLoop(incr:Boolean, index:int, stopData:Object, transition:Boolean, placeHolder:CursorBookmark) : void
      {
         var data:Object = null;
         var uid:String = null;
         try
         {
            do
            {
               data = this.iterator.current;
               uid = this.itemToUID(data);
               this.insertSelectionDataBefore(uid,new ListBaseSelectionData(data,index,this.approximate),this.firstSelectionData);
               if(Boolean(this.UIDToItemRenderer(uid)))
               {
                  this.drawItem(this.UIDToItemRenderer(uid),true,uid == this.highlightUID,false,transition);
               }
               if(data === stopData)
               {
                  if(Boolean(this.UIDToItemRenderer(uid)))
                  {
                     this.drawItem(this.UIDToItemRenderer(uid),true,uid == this.highlightUID,true,transition);
                  }
                  break;
               }
               if(incr)
               {
                  index++;
               }
               else
               {
                  index--;
               }
            }
            while(incr ? Boolean(this.iterator.moveNext()) : Boolean(this.iterator.movePrevious()));
         }
         catch(e:ItemPendingError)
         {
            e.addResponder(new ItemResponder(selectionPendingResultHandler,selectionPendingFailureHandler,new ListBaseSelectionPending(incr,index,stopData,transition,placeHolder,CursorBookmark.CURRENT,0)));
            iteratorValid = false;
         }
         try
         {
            this.iterator.seek(placeHolder,0);
            if(!this.iteratorValid)
            {
               this.iteratorValid = true;
               this.lastSeekPending = null;
            }
         }
         catch(e2:ItemPendingError)
         {
            lastSeekPending = new ListBaseSeekPending(placeHolder,0);
            e2.addResponder(new ItemResponder(seekPendingResultHandler,seekPendingFailureHandler,lastSeekPending));
         }
      }
      
      protected function clearSelected(transition:Boolean = false) : void
      {
         var uniqueID:String = null;
         var data:Object = null;
         var item:IListItemRenderer = null;
         for(uniqueID in this.selectedData)
         {
            data = this.selectedData[uniqueID].data;
            this.removeSelectionData(uniqueID);
            item = this.UIDToItemRenderer(this.itemToUID(data));
            if(Boolean(item))
            {
               this.drawItem(item,false,uniqueID == this.highlightUID,false,transition);
            }
         }
         this.clearSelectionData();
         this._selectedIndex = -1;
         this._selectedItem = null;
         this.caretIndex = -1;
         this.anchorIndex = -1;
         this.caretBookmark = null;
         this.anchorBookmark = null;
      }
      
      protected function moveSelectionHorizontally(code:uint, shiftKey:Boolean, ctrlKey:Boolean) : void
      {
      }
      
      protected function moveSelectionVertically(code:uint, shiftKey:Boolean, ctrlKey:Boolean) : void
      {
         var newVerticalScrollPosition:Number = NaN;
         var listItem:IListItemRenderer = null;
         var uid:String = null;
         var len:int = 0;
         var se:ScrollEvent = null;
         var bSelChanged:Boolean = false;
         this.showCaret = true;
         var rowCount:int = int(this.listItems.length);
         var onscreenRowCount:int = this.listItems.length - this.offscreenExtraRowsTop - this.offscreenExtraRowsBottom;
         var partialRow:int = this.rowInfo[rowCount - this.offscreenExtraRowsBottom - 1].y + this.rowInfo[rowCount - this.offscreenExtraRowsBottom - 1].height > this.listContent.heightExcludingOffsets - this.listContent.topOffset ? 1 : 0;
         var bUpdateVerticalScrollPosition:Boolean = false;
         this.bSelectItem = false;
         switch(code)
         {
            case Keyboard.UP:
               if(this.caretIndex > 0)
               {
                  --this.caretIndex;
                  bUpdateVerticalScrollPosition = true;
                  this.bSelectItem = true;
               }
               break;
            case Keyboard.DOWN:
               if(this.caretIndex < this.collection.length - 1)
               {
                  ++this.caretIndex;
                  bUpdateVerticalScrollPosition = true;
                  this.bSelectItem = true;
               }
               else if(this.caretIndex == this.collection.length - 1 && Boolean(partialRow))
               {
                  if(this.verticalScrollPosition < maxVerticalScrollPosition)
                  {
                     newVerticalScrollPosition = this.verticalScrollPosition + 1;
                  }
               }
               break;
            case Keyboard.PAGE_UP:
               if(this.caretIndex > this.verticalScrollPosition && this.caretIndex < this.verticalScrollPosition + onscreenRowCount)
               {
                  this.caretIndex = this.verticalScrollPosition;
               }
               else
               {
                  this.caretIndex = Math.max(this.caretIndex - Math.max(onscreenRowCount - partialRow,1),0);
                  newVerticalScrollPosition = Math.max(this.caretIndex,0);
               }
               this.bSelectItem = true;
               break;
            case Keyboard.PAGE_DOWN:
               if(!(this.caretIndex >= this.verticalScrollPosition && this.caretIndex < this.verticalScrollPosition + onscreenRowCount - partialRow - 1))
               {
                  if(this.caretIndex == this.verticalScrollPosition && onscreenRowCount - partialRow <= 1)
                  {
                     ++this.caretIndex;
                  }
                  newVerticalScrollPosition = Math.max(Math.min(this.caretIndex,maxVerticalScrollPosition),0);
               }
               this.bSelectItem = true;
               break;
            case Keyboard.HOME:
               if(this.caretIndex > 0)
               {
                  this.caretIndex = 0;
                  this.bSelectItem = true;
                  newVerticalScrollPosition = 0;
               }
               break;
            case Keyboard.END:
               if(this.caretIndex < this.collection.length - 1)
               {
                  this.caretIndex = this.collection.length - 1;
                  this.bSelectItem = true;
                  newVerticalScrollPosition = maxVerticalScrollPosition;
               }
         }
         if(bUpdateVerticalScrollPosition)
         {
            if(this.caretIndex >= this.verticalScrollPosition + onscreenRowCount - partialRow)
            {
               if(onscreenRowCount - partialRow == 0)
               {
                  newVerticalScrollPosition = Math.min(maxVerticalScrollPosition,this.caretIndex);
               }
               else
               {
                  newVerticalScrollPosition = Math.min(maxVerticalScrollPosition,this.caretIndex - onscreenRowCount + partialRow + 1);
               }
            }
            else if(this.caretIndex < this.verticalScrollPosition)
            {
               newVerticalScrollPosition = Math.max(this.caretIndex,0);
            }
         }
         if(!isNaN(newVerticalScrollPosition))
         {
            if(this.verticalScrollPosition != newVerticalScrollPosition)
            {
               se = new ScrollEvent(ScrollEvent.SCROLL);
               se.detail = ScrollEventDetail.THUMB_POSITION;
               se.direction = ScrollEventDirection.VERTICAL;
               se.delta = newVerticalScrollPosition - this.verticalScrollPosition;
               se.position = newVerticalScrollPosition;
               this.verticalScrollPosition = newVerticalScrollPosition;
               dispatchEvent(se);
            }
            if(!this.iteratorValid)
            {
               this.keySelectionPending = true;
               return;
            }
         }
         this.bShiftKey = shiftKey;
         this.bCtrlKey = ctrlKey;
         this.lastKey = code;
         this.finishKeySelection();
      }
      
      protected function finishKeySelection() : void
      {
         var uid:String = null;
         var listItem:IListItemRenderer = null;
         var pt:Point = null;
         var evt:ListEvent = null;
         var rowCount:int = int(this.listItems.length);
         var onscreenRowCount:int = this.listItems.length - this.offscreenExtraRowsTop - this.offscreenExtraRowsBottom;
         var partialRow:int = this.rowInfo[rowCount - this.offscreenExtraRowsBottom - 1].y + this.rowInfo[rowCount - this.offscreenExtraRowsBottom - 1].height > this.listContent.heightExcludingOffsets - this.listContent.topOffset ? 1 : 0;
         if(this.lastKey == Keyboard.PAGE_DOWN)
         {
            if(onscreenRowCount - partialRow == 0)
            {
               this.caretIndex = Math.min(this.verticalScrollPosition + onscreenRowCount - partialRow,this.collection.length - 1);
            }
            else
            {
               this.caretIndex = Math.min(this.verticalScrollPosition + onscreenRowCount - partialRow - 1,this.collection.length - 1);
            }
         }
         var bSelChanged:Boolean = false;
         if(this.bSelectItem && this.caretIndex - this.verticalScrollPosition >= 0)
         {
            if(this.caretIndex - this.verticalScrollPosition > Math.max(onscreenRowCount - partialRow - 1,0))
            {
               if(this.lastKey == Keyboard.END && maxVerticalScrollPosition > this.verticalScrollPosition)
               {
                  this.caretIndex -= 1;
                  this.moveSelectionVertically(this.lastKey,this.bShiftKey,this.bCtrlKey);
                  return;
               }
               this.caretIndex = onscreenRowCount - partialRow - 1 + this.verticalScrollPosition;
            }
            listItem = this.listItems[this.caretIndex - this.verticalScrollPosition + this.offscreenExtraRowsTop][0];
            if(Boolean(listItem))
            {
               uid = this.itemToUID(listItem.data);
               listItem = this.UIDToItemRenderer(uid);
               if(!this.bCtrlKey || this.lastKey == Keyboard.SPACE)
               {
                  this.selectItem(listItem,this.bShiftKey,this.bCtrlKey);
                  bSelChanged = true;
               }
               if(this.bCtrlKey)
               {
                  this.drawItem(listItem,this.selectedData[uid] != null,uid == this.highlightUID,true);
               }
            }
         }
         if(bSelChanged)
         {
            pt = this.itemRendererToIndices(listItem);
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
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function commitSelectedIndex(value:int) : void
      {
         var bookmark:CursorBookmark = null;
         var len:int = 0;
         var data:Object = null;
         var selectedBookmark:CursorBookmark = null;
         var uid:String = null;
         if(value != -1)
         {
            value = Math.min(value,this.collection.length - 1);
            bookmark = this.iterator.bookmark;
            len = value - this.scrollPositionToIndex(this.horizontalScrollPosition - this.offscreenExtraColumnsLeft,this.verticalScrollPosition - this.offscreenExtraRowsTop);
            try
            {
               this.iterator.seek(CursorBookmark.CURRENT,len);
            }
            catch(e:ItemPendingError)
            {
               iterator.seek(bookmark,0);
               bSelectedIndexChanged = true;
               _selectedIndex = value;
               return;
            }
            data = this.iterator.current;
            selectedBookmark = this.iterator.bookmark;
            uid = this.itemToUID(data);
            this.iterator.seek(bookmark,0);
            if(!this.selectedData[uid])
            {
               if(Boolean(this.listContent) && Boolean(this.UIDToItemRenderer(uid)))
               {
                  this.selectItem(this.UIDToItemRenderer(uid),false,false);
               }
               else
               {
                  this.clearSelected();
                  this.insertSelectionDataBefore(uid,new ListBaseSelectionData(data,value,this.approximate),this.firstSelectionData);
                  this._selectedIndex = value;
                  this.caretIndex = value;
                  this.caretBookmark = selectedBookmark;
                  this.anchorIndex = value;
                  this.anchorBookmark = selectedBookmark;
                  this._selectedItem = data;
               }
            }
         }
         else
         {
            this.clearSelected();
         }
         dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function commitSelectedIndices(indices:Array) : void
      {
         this.clearSelected();
         try
         {
            this.collectionIterator.seek(CursorBookmark.FIRST,0);
         }
         catch(e:ItemPendingError)
         {
            e.addResponder(new ItemResponder(selectionIndicesPendingResultHandler,selectionIndicesPendingFailureHandler,new ListBaseSelectionDataPending(true,0,indices,CursorBookmark.FIRST,0)));
            return;
         }
         this.setSelectionIndicesLoop(0,indices,true);
      }
      
      private function setSelectionIndicesLoop(index:int, indices:Array, firstTime:Boolean = false) : void
      {
         var data:Object = null;
         var uid:String = null;
         while(Boolean(indices.length))
         {
            if(index != indices[0])
            {
               try
               {
                  this.collectionIterator.seek(CursorBookmark.CURRENT,indices[0] - index);
               }
               catch(e:ItemPendingError)
               {
                  e.addResponder(new ItemResponder(selectionIndicesPendingResultHandler,selectionIndicesPendingFailureHandler,new ListBaseSelectionDataPending(firstTime,index,indices,CursorBookmark.CURRENT,indices[0] - index)));
                  return;
               }
            }
            index = int(indices[0]);
            indices.shift();
            data = this.collectionIterator.current;
            if(firstTime)
            {
               this._selectedIndex = index;
               this._selectedItem = data;
               this.caretIndex = index;
               this.caretBookmark = this.collectionIterator.bookmark;
               this.anchorIndex = index;
               this.anchorBookmark = this.collectionIterator.bookmark;
               firstTime = false;
            }
            uid = this.itemToUID(data);
            this.insertSelectionDataAfter(uid,new ListBaseSelectionData(data,index,false),this.lastSelectionData);
            if(Boolean(this.UIDToItemRenderer(uid)))
            {
               this.drawItem(this.UIDToItemRenderer(uid),true,uid == this.highlightUID,this.caretIndex == index);
            }
         }
         if(initialized)
         {
            this.updateList();
         }
         dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
      }
      
      private function commitSelectedItem(data:Object, clearFirst:Boolean = true) : void
      {
         if(clearFirst)
         {
            this.clearSelected();
         }
         if(data != null)
         {
            this.commitSelectedItems([data]);
         }
      }
      
      private function commitSelectedItems(items:Array) : void
      {
         var n:int;
         var i:int;
         var useFind:Boolean = false;
         var uid:String = null;
         this.clearSelected();
         items = items.slice();
         useFind = this.collection.sort != null;
         try
         {
            this.collectionIterator.seek(CursorBookmark.FIRST,0);
         }
         catch(e:ItemPendingError)
         {
            e.addResponder(new ItemResponder(selectionDataPendingResultHandler,selectionDataPendingFailureHandler,new ListBaseSelectionDataPending(useFind,0,items,null,0)));
            return;
         }
         n = int(items.length);
         this.selectionDataArray = new Array(n);
         this.firstSelectedItem = Boolean(n) ? items[0] : null;
         this.proposedSelectedItemIndexes = new Dictionary();
         for(i = 0; i < n; i++)
         {
            uid = this.itemToUID(items[i]);
            this.proposedSelectedItemIndexes[uid] = i;
         }
         this.setSelectionDataLoop(items,0,useFind);
      }
      
      private function setSelectionDataLoop(items:Array, index:int, useFind:Boolean = true) : void
      {
         var uid:String = null;
         var item:Object = null;
         var bookmark:CursorBookmark = null;
         var compareFunction:Function = null;
         var selectionData:ListBaseSelectionData = null;
         var lastSelectionData:ListBaseSelectionData = null;
         var len:int = 0;
         var data:Object = null;
         var i:int = 0;
         if(useFind)
         {
            while(Boolean(items.length))
            {
               item = items.pop();
               uid = this.itemToUID(item);
               try
               {
                  this.collectionIterator.findAny(item);
               }
               catch(e1:ItemPendingError)
               {
                  items.push(item);
                  e1.addResponder(new ItemResponder(selectionDataPendingResultHandler,selectionDataPendingFailureHandler,new ListBaseSelectionDataPending(useFind,0,items,null,0)));
                  return;
               }
               bookmark = this.collectionIterator.bookmark;
               index = int(bookmark.getViewIndex());
               if(index < 0)
               {
                  try
                  {
                     this.collectionIterator.seek(CursorBookmark.FIRST,0);
                  }
                  catch(e2:ItemPendingError)
                  {
                     e2.addResponder(new ItemResponder(selectionDataPendingResultHandler,selectionDataPendingFailureHandler,new ListBaseSelectionDataPending(false,0,items,CursorBookmark.FIRST,0)));
                     return;
                  }
                  this.setSelectionDataLoop(items,0,false);
                  return;
               }
               this.insertSelectionDataBefore(uid,new ListBaseSelectionData(item,index,true),this.firstSelectionData);
               if(items.length == 0)
               {
                  this._selectedIndex = index;
                  this._selectedItem = item;
                  this.caretIndex = index;
                  this.caretBookmark = this.collectionIterator.bookmark;
                  this.anchorIndex = index;
                  this.anchorBookmark = this.collectionIterator.bookmark;
               }
            }
         }
         else
         {
            compareFunction = this.selectedItemsCompareFunction;
            if(compareFunction == null)
            {
               compareFunction = this.strictEqualityCompareFunction;
            }
            while(Boolean(items.length) && !this.collectionIterator.afterLast)
            {
               len = int(items.length);
               data = this.collectionIterator.current;
               for(i = 0; i < len; i++)
               {
                  item = items[i];
                  if(Boolean(compareFunction(data,item)))
                  {
                     uid = this.itemToUID(data);
                     this.selectionDataArray[this.proposedSelectedItemIndexes[uid]] = new ListBaseSelectionData(data,index,false);
                     items.splice(i,1);
                     if(item === this.firstSelectedItem)
                     {
                        this._selectedIndex = index;
                        this._selectedItem = data;
                        this.caretIndex = index;
                        this.caretBookmark = this.collectionIterator.bookmark;
                        this.anchorIndex = index;
                        this.anchorBookmark = this.collectionIterator.bookmark;
                     }
                     break;
                  }
               }
               this.collectionIterator.moveNext();
               index++;
            }
            len = int(this.selectionDataArray.length);
            lastSelectionData = this.firstSelectionData;
            if(Boolean(len))
            {
               selectionData = this.selectionDataArray[0];
               if(Boolean(selectionData))
               {
                  uid = this.itemToUID(selectionData.data);
                  this.insertSelectionDataBefore(uid,selectionData,this.firstSelectionData);
                  lastSelectionData = selectionData;
               }
            }
            for(i = 1; i < len; i++)
            {
               selectionData = this.selectionDataArray[i];
               if(Boolean(selectionData))
               {
                  uid = this.itemToUID(selectionData.data);
                  this.insertSelectionDataAfter(uid,selectionData,lastSelectionData);
                  lastSelectionData = selectionData;
               }
            }
            this.selectionDataArray = null;
            this.proposedSelectedItemIndexes = null;
            this.firstSelectedItem = null;
         }
         if(initialized)
         {
            this.updateList();
         }
         dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
      }
      
      private function clearSelectionData() : void
      {
         this.selectedData = {};
         this.firstSelectionData = null;
         this.lastSelectionData = null;
      }
      
      private function insertSelectionDataBefore(uid:String, selectionData:ListBaseSelectionData, nextSelectionData:ListBaseSelectionData) : void
      {
         if(nextSelectionData == null)
         {
            this.firstSelectionData = this.lastSelectionData = selectionData;
         }
         else
         {
            if(nextSelectionData == this.firstSelectionData)
            {
               this.firstSelectionData = selectionData;
            }
            selectionData.nextSelectionData = nextSelectionData;
            selectionData.prevSelectionData = nextSelectionData.prevSelectionData;
            nextSelectionData.prevSelectionData = selectionData;
         }
         this.selectedData[uid] = selectionData;
      }
      
      private function insertSelectionDataAfter(uid:String, selectionData:ListBaseSelectionData, prevSelectionData:ListBaseSelectionData) : void
      {
         if(prevSelectionData == null)
         {
            this.firstSelectionData = this.lastSelectionData = selectionData;
         }
         else
         {
            if(prevSelectionData == this.lastSelectionData)
            {
               this.lastSelectionData = selectionData;
            }
            selectionData.prevSelectionData = prevSelectionData;
            selectionData.nextSelectionData = prevSelectionData.nextSelectionData;
            prevSelectionData.nextSelectionData = selectionData;
         }
         this.selectedData[uid] = selectionData;
      }
      
      private function removeSelectionData(uid:String) : void
      {
         var curSelectionData:ListBaseSelectionData = this.selectedData[uid];
         if(this.firstSelectionData == curSelectionData)
         {
            this.firstSelectionData = curSelectionData.nextSelectionData;
         }
         if(this.lastSelectionData == curSelectionData)
         {
            this.lastSelectionData = curSelectionData.prevSelectionData;
         }
         if(curSelectionData.prevSelectionData != null)
         {
            curSelectionData.prevSelectionData.nextSelectionData = curSelectionData.nextSelectionData;
         }
         if(curSelectionData.nextSelectionData != null)
         {
            curSelectionData.nextSelectionData.prevSelectionData = curSelectionData.prevSelectionData;
         }
         delete this.selectedData[uid];
      }
      
      protected function applySelectionEffect(indicator:Sprite, uid:String, itemRenderer:IListItemRenderer) : void
      {
         var selectionEasingFunction:Function = null;
         var selectionDuration:Number = Number(getStyle("selectionDuration"));
         if(selectionDuration != 0)
         {
            indicator.alpha = 0;
            this.selectionTweens[uid] = new Tween(indicator,0,1,selectionDuration,5);
            this.selectionTweens[uid].addEventListener(TweenEvent.TWEEN_UPDATE,this.selectionTween_updateHandler);
            this.selectionTweens[uid].addEventListener(TweenEvent.TWEEN_END,this.selectionTween_endHandler);
            this.selectionTweens[uid].setTweenHandlers(this.onSelectionTweenUpdate,this.onSelectionTweenUpdate);
            selectionEasingFunction = getStyle("selectionEasingFunction") as Function;
            if(selectionEasingFunction != null)
            {
               this.selectionTweens[uid].easingFunction = selectionEasingFunction;
            }
         }
      }
      
      private function onSelectionTweenUpdate(value:Number) : void
      {
      }
      
      protected function copySelectedItems(useDataField:Boolean = true) : Array
      {
         var tmp:Array = [];
         var curSelectionData:ListBaseSelectionData = this.firstSelectionData;
         while(curSelectionData != null)
         {
            if(useDataField)
            {
               tmp.push(curSelectionData.data);
            }
            else
            {
               tmp.push(curSelectionData.index);
            }
            curSelectionData = curSelectionData.nextSelectionData;
         }
         return tmp;
      }
      
      protected function scrollPositionToIndex(horizontalScrollPosition:int, verticalScrollPosition:int) : int
      {
         return Boolean(this.iterator) ? verticalScrollPosition : -1;
      }
      
      public function scrollToIndex(index:int) : Boolean
      {
         var newVPos:int = 0;
         if(index >= this.verticalScrollPosition + this.listItems.length - this.offscreenExtraRowsBottom || index < this.verticalScrollPosition)
         {
            newVPos = Math.min(index,maxVerticalScrollPosition);
            this.verticalScrollPosition = newVPos;
            return true;
         }
         return false;
      }
      
      protected function scrollVertically(pos:int, deltaPos:int, scrollUp:Boolean) : void
      {
         var i:int = 0;
         var j:int = 0;
         var numRows:int = 0;
         var numCols:int = 0;
         var uid:String = null;
         var curY:Number = NaN;
         var cursorPos:CursorBookmark = null;
         var discardRows:int = 0;
         var desiredoffscreenExtraRowsTop:int = 0;
         var newoffscreenExtraRowsTop:int = 0;
         var offscreenExtraRowsBottomToMake:int = 0;
         var newTopOffset:Number = NaN;
         var fillHeight:Number = NaN;
         var pt:Point = null;
         var rowIdx:int = 0;
         var modDeltaPos:int = 0;
         var desiredPrefixItems:int = 0;
         var actual:Point = null;
         var row:Array = null;
         var rowData:Object = null;
         var desiredSuffixItems:int = 0;
         var newOffscreenRows:int = 0;
         var visibleAreaBottomY:int = 0;
         var rowCount:int = int(this.rowInfo.length);
         var columnCount:int = int(this.listItems[0].length);
         var moveBlockDistance:Number = 0;
         var listContentVisibleHeight:Number = this.listContent.heightExcludingOffsets;
         if(scrollUp)
         {
            discardRows = deltaPos;
            desiredoffscreenExtraRowsTop = this.offscreenExtraRows / 2;
            newoffscreenExtraRowsTop = Math.min(desiredoffscreenExtraRowsTop,this.offscreenExtraRowsTop + deltaPos);
            if(this.offscreenExtraRowsTop < desiredoffscreenExtraRowsTop)
            {
               discardRows = Math.max(0,deltaPos - (desiredoffscreenExtraRowsTop - this.offscreenExtraRowsTop));
            }
            moveBlockDistance = this.sumRowHeights(0,discardRows - 1);
            for(i = 0; i < discardRows; i++)
            {
               if(!this.seekNextSafely(this.iterator,pos))
               {
                  return;
               }
            }
            for(i = 0; i < rowCount; i++)
            {
               numCols = int(this.listItems[i].length);
               if(i < discardRows)
               {
                  this.destroyRow(i,numCols);
               }
               else if(discardRows > 0)
               {
                  this.moveRowVertically(i,numCols,-moveBlockDistance);
                  this.moveIndicatorsVertically(this.rowInfo[i].uid,-moveBlockDistance);
                  this.shiftRow(i,i - discardRows,numCols,true);
                  if(this.listItems[i].length == 0)
                  {
                     this.listItems[i - discardRows].splice(0);
                  }
               }
            }
            if(Boolean(discardRows))
            {
               this.truncateRowArrays(rowCount - discardRows);
            }
            curY = this.rowInfo[rowCount - discardRows - 1].y + this.rowInfo[rowCount - discardRows - 1].height;
            cursorPos = this.iterator.bookmark;
            try
            {
               this.iterator.seek(CursorBookmark.CURRENT,rowCount - discardRows);
               if(!this.iteratorValid)
               {
                  this.iteratorValid = true;
                  this.lastSeekPending = null;
               }
            }
            catch(e1:ItemPendingError)
            {
               lastSeekPending = new ListBaseSeekPending(cursorPos,0);
               e1.addResponder(new ItemResponder(seekPendingResultHandler,seekPendingFailureHandler,lastSeekPending));
               iteratorValid = false;
            }
            offscreenExtraRowsBottomToMake = this.offscreenExtraRows / 2;
            newTopOffset = 0;
            for(i = 0; i < newoffscreenExtraRowsTop; i++)
            {
               newTopOffset -= this.rowInfo[i].height;
            }
            fillHeight = listContentVisibleHeight - (curY + newTopOffset);
            if(fillHeight > 0)
            {
               pt = this.makeRowsAndColumns(0,curY,this.listContent.width,curY + fillHeight,0,rowCount - discardRows);
               rowCount += pt.y;
            }
            else
            {
               rowIdx = rowCount - discardRows - 1;
               fillHeight += this.rowInfo[rowIdx--].height;
               while(fillHeight < 0)
               {
                  offscreenExtraRowsBottomToMake--;
                  fillHeight += this.rowInfo[rowIdx--].height;
               }
            }
            if(offscreenExtraRowsBottomToMake > 0)
            {
               if(Boolean(pt))
               {
                  curY = this.rowInfo[rowCount - discardRows - 1].y + this.rowInfo[rowCount - discardRows - 1].height;
               }
               pt = this.makeRowsAndColumns(0,curY,this.listContent.width,this.listContent.height,0,rowCount - discardRows,true,offscreenExtraRowsBottomToMake);
            }
            else
            {
               pt = new Point(0,0);
            }
            try
            {
               this.iterator.seek(cursorPos,0);
            }
            catch(e2:ItemPendingError)
            {
               lastSeekPending = new ListBaseSeekPending(cursorPos,0);
               e2.addResponder(new ItemResponder(seekPendingResultHandler,seekPendingFailureHandler,lastSeekPending));
               iteratorValid = false;
            }
            this.offscreenExtraRowsTop = newoffscreenExtraRowsTop;
            this.offscreenExtraRowsBottom = this.offscreenExtraRows / 2 - offscreenExtraRowsBottomToMake + pt.y;
         }
         else
         {
            curY = 0;
            modDeltaPos = deltaPos;
            desiredPrefixItems = this.offscreenExtraRows / 2;
            if(pos < desiredPrefixItems)
            {
               modDeltaPos -= desiredPrefixItems - pos;
            }
            for(i = 0; i < modDeltaPos; i++)
            {
               this.addToRowArrays();
            }
            actual = new Point(0,0);
            if(modDeltaPos > 0)
            {
               try
               {
                  this.iterator.seek(CursorBookmark.CURRENT,-modDeltaPos);
                  if(!this.iteratorValid)
                  {
                     this.iteratorValid = true;
                     this.lastSeekPending = null;
                  }
               }
               catch(e3:ItemPendingError)
               {
                  lastSeekPending = new ListBaseSeekPending(CursorBookmark.CURRENT,-modDeltaPos);
                  e3.addResponder(new ItemResponder(seekPendingResultHandler,seekPendingFailureHandler,lastSeekPending));
                  iteratorValid = false;
               }
               cursorPos = this.iterator.bookmark;
               this.allowRendererStealingDuringLayout = false;
               actual = this.makeRowsAndColumns(0,curY,this.listContent.width,this.listContent.height,0,0,true,modDeltaPos);
               this.allowRendererStealingDuringLayout = true;
               try
               {
                  this.iterator.seek(cursorPos,0);
               }
               catch(e4:ItemPendingError)
               {
                  lastSeekPending = new ListBaseSeekPending(cursorPos,0);
                  e4.addResponder(new ItemResponder(seekPendingResultHandler,seekPendingFailureHandler,lastSeekPending));
                  iteratorValid = false;
               }
            }
            if(actual.y == 0 && modDeltaPos > 0)
            {
               this.verticalScrollPosition = 0;
               this.restoreRowArrays(modDeltaPos);
            }
            moveBlockDistance = this.sumRowHeights(0,actual.y - 1);
            desiredSuffixItems = this.offscreenExtraRows / 2;
            newOffscreenRows = 0;
            visibleAreaBottomY = listContentVisibleHeight + this.sumRowHeights(0,Math.min(desiredPrefixItems,pos) - 1);
            for(i = actual.y; i < this.listItems.length; i++)
            {
               row = this.listItems[i];
               rowData = this.rowInfo[i];
               this.moveRowVertically(i,this.listItems[i].length,moveBlockDistance);
               if(rowData.y >= visibleAreaBottomY)
               {
                  newOffscreenRows++;
                  if(newOffscreenRows > desiredSuffixItems)
                  {
                     this.destroyRow(i,this.listItems[i].length);
                     this.removeFromRowArrays(i);
                     i--;
                  }
                  else
                  {
                     this.shiftRow(i,i + deltaPos,this.listItems[i].length,false);
                     this.moveIndicatorsVertically(this.rowInfo[i].uid,moveBlockDistance);
                  }
               }
               else
               {
                  this.shiftRow(i,i + deltaPos,this.listItems[i].length,false);
                  this.moveIndicatorsVertically(this.rowInfo[i].uid,moveBlockDistance);
               }
            }
            rowCount = int(this.listItems.length);
            this.offscreenExtraRowsTop = Math.min(desiredPrefixItems,pos);
            this.offscreenExtraRowsBottom = Math.min(newOffscreenRows,desiredSuffixItems);
         }
         this.listContent.topOffset = -this.sumRowHeights(0,this.offscreenExtraRowsTop - 1);
         this.listContent.bottomOffset = this.rowInfo[this.rowInfo.length - 1].y + this.rowInfo[this.rowInfo.length - 1].height + this.listContent.topOffset - listContentVisibleHeight;
         this.adjustListContent(this.oldUnscaledWidth,this.oldUnscaledHeight);
         this.addClipMask(true);
      }
      
      protected function destroyRow(i:int, numCols:int) : void
      {
         var r:IListItemRenderer = null;
         var uid:String = this.rowInfo[i].uid;
         this.removeIndicators(uid);
         for(var j:int = 0; j < numCols; j++)
         {
            r = this.listItems[i][j];
            if(Boolean(r.data))
            {
               delete this.visibleData[uid];
            }
            this.addToFreeItemRenderers(r);
         }
      }
      
      protected function moveRowVertically(i:int, numCols:int, moveBlockDistance:Number) : void
      {
         var r:IListItemRenderer = null;
         for(var j:int = 0; j < numCols; j++)
         {
            r = this.listItems[i][j];
            r.move(r.x,r.y + moveBlockDistance);
         }
         this.rowInfo[i].y += moveBlockDistance;
      }
      
      protected function shiftRow(oldIndex:int, newIndex:int, numCols:int, shiftItems:Boolean) : void
      {
         var r:IListItemRenderer = null;
         for(var j:int = 0; j < numCols; j++)
         {
            r = this.listItems[oldIndex][j];
            if(shiftItems)
            {
               this.listItems[newIndex][j] = r;
               this.rowMap[r.name].rowIndex = newIndex;
            }
            else
            {
               this.rowMap[r.name].rowIndex = oldIndex;
            }
         }
         if(shiftItems)
         {
            this.rowInfo[newIndex] = this.rowInfo[oldIndex];
         }
      }
      
      protected function moveIndicatorsVertically(uid:String, moveBlockDistance:Number) : void
      {
         if(uid != null)
         {
            if(Boolean(this.selectionIndicators[uid]))
            {
               this.selectionIndicators[uid].y += moveBlockDistance;
            }
            if(this.highlightUID == uid)
            {
               this.highlightIndicator.y += moveBlockDistance;
            }
            if(this.caretUID == uid)
            {
               this.caretIndicator.y += moveBlockDistance;
            }
         }
      }
      
      protected function moveIndicatorsHorizontally(uid:String, moveBlockDistance:Number) : void
      {
         if(uid != null)
         {
            if(Boolean(this.selectionIndicators[uid]))
            {
               this.selectionIndicators[uid].x += moveBlockDistance;
            }
            if(this.highlightUID == uid)
            {
               this.highlightIndicator.x += moveBlockDistance;
            }
            if(this.caretUID == uid)
            {
               this.caretIndicator.x += moveBlockDistance;
            }
         }
      }
      
      protected function sumRowHeights(startRowIdx:int, endRowIdx:int) : Number
      {
         var sum:Number = 0;
         for(var i:int = startRowIdx; i <= endRowIdx; i++)
         {
            sum += this.rowInfo[i].height;
         }
         return sum;
      }
      
      protected function truncateRowArrays(numRows:int) : void
      {
         this.listItems.splice(numRows);
         this.rowInfo.splice(numRows);
      }
      
      protected function addToRowArrays() : void
      {
         this.listItems.splice(0,0,null);
         this.rowInfo.splice(0,0,null);
      }
      
      protected function restoreRowArrays(modDeltaPos:int) : void
      {
         this.rowInfo.splice(0,modDeltaPos);
         this.listItems.splice(0,modDeltaPos);
      }
      
      protected function removeFromRowArrays(i:int) : void
      {
         this.listItems.splice(i,1);
         this.rowInfo.splice(i,1);
      }
      
      protected function scrollHorizontally(pos:int, deltaPos:int, scrollUp:Boolean) : void
      {
      }
      
      public function createItemRenderer(data:Object) : IListItemRenderer
      {
         return null;
      }
      
      protected function configureScrollBars() : void
      {
      }
      
      protected function dragScroll() : void
      {
         var scrollInterval:Number = NaN;
         var oldPosition:Number = NaN;
         var d:Number = NaN;
         var scrollEvent:ScrollEvent = null;
         var slop:Number = 0;
         if(this.dragScrollingInterval == 0)
         {
            return;
         }
         var minScrollInterval:Number = 30;
         oldPosition = this.verticalScrollPosition;
         if(DragManager.isDragging)
         {
            slop = viewMetrics.top + (this.variableRowHeight ? getStyle("fontSize") / 4 : this.rowHeight);
         }
         clearInterval(this.dragScrollingInterval);
         if(mouseY < slop)
         {
            this.verticalScrollPosition = Math.max(0,oldPosition - 1);
            if(DragManager.isDragging)
            {
               scrollInterval = 100;
            }
            else
            {
               d = Math.min(0 - mouseY - 30,0);
               scrollInterval = 0.593 * d * d + 1 + minScrollInterval;
            }
            this.dragScrollingInterval = setInterval(this.dragScroll,scrollInterval);
            if(oldPosition != this.verticalScrollPosition)
            {
               scrollEvent = new ScrollEvent(ScrollEvent.SCROLL);
               scrollEvent.detail = ScrollEventDetail.THUMB_POSITION;
               scrollEvent.direction = ScrollEventDirection.VERTICAL;
               scrollEvent.position = this.verticalScrollPosition;
               scrollEvent.delta = this.verticalScrollPosition - oldPosition;
               dispatchEvent(scrollEvent);
            }
         }
         else if(mouseY > unscaledHeight - slop)
         {
            this.verticalScrollPosition = Math.min(maxVerticalScrollPosition,this.verticalScrollPosition + 1);
            if(DragManager.isDragging)
            {
               scrollInterval = 100;
            }
            else
            {
               d = Math.min(mouseY - unscaledHeight - 30,0);
               scrollInterval = 0.593 * d * d + 1 + minScrollInterval;
            }
            this.dragScrollingInterval = setInterval(this.dragScroll,scrollInterval);
            if(oldPosition != this.verticalScrollPosition)
            {
               scrollEvent = new ScrollEvent(ScrollEvent.SCROLL);
               scrollEvent.detail = ScrollEventDetail.THUMB_POSITION;
               scrollEvent.direction = ScrollEventDirection.VERTICAL;
               scrollEvent.position = this.verticalScrollPosition;
               scrollEvent.delta = this.verticalScrollPosition - oldPosition;
               dispatchEvent(scrollEvent);
            }
         }
         else
         {
            this.dragScrollingInterval = setInterval(this.dragScroll,15);
         }
         if(Boolean(DragManager.isDragging) && Boolean(this.lastDragEvent) && oldPosition != this.verticalScrollPosition)
         {
            this.dragOverHandler(this.lastDragEvent);
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function resetDragScrolling() : void
      {
         if(this.dragScrollingInterval != 0)
         {
            clearInterval(this.dragScrollingInterval);
            this.dragScrollingInterval = 0;
         }
      }
      
      protected function addDragData(dragSource:Object) : void
      {
         dragSource.addHandler(this.copySelectedItems,"items");
         dragSource.addHandler(this.copySelectedItemsForDragDrop,"itemsByIndex");
         var caretIndex:int = 0;
         var draggedIndices:Array = this.selectedIndices;
         var count:int = int(draggedIndices.length);
         for(var i:int = 0; i < count; i++)
         {
            if(this.mouseDownIndex > draggedIndices[i])
            {
               caretIndex++;
            }
         }
         dragSource.addData(caretIndex,"caretIndex");
      }
      
      private function copySelectedItemsForDragDrop() : Vector.<Object>
      {
         var draggedIndices:Array = this.selectedIndices.slice(0,this.selectedIndices.length);
         var result:Vector.<Object> = new Vector.<Object>(draggedIndices.length);
         draggedIndices.sort();
         var count:int = int(draggedIndices.length);
         for(var i:int = 0; i < count; i++)
         {
            result[i] = this.dataProvider.getItemAt(draggedIndices[i]);
         }
         return result;
      }
      
      public function calculateDropIndex(event:DragEvent = null) : int
      {
         var item:IListItemRenderer = null;
         var lastItem:IListItemRenderer = null;
         var pt:Point = null;
         var rc:int = 0;
         var i:int = 0;
         if(Boolean(event))
         {
            pt = new Point(event.localX,event.localY);
            pt = DisplayObject(event.target).localToGlobal(pt);
            pt = this.listContent.globalToLocal(pt);
            rc = int(this.listItems.length);
            for(i = 0; i < rc; i++)
            {
               if(Boolean(this.listItems[i][0]))
               {
                  lastItem = this.listItems[i][0];
               }
               if(this.rowInfo[i].y <= pt.y && pt.y < this.rowInfo[i].y + this.rowInfo[i].height)
               {
                  item = this.listItems[i][0];
                  break;
               }
            }
            if(Boolean(item))
            {
               this.lastDropIndex = this.itemRendererToIndex(item);
            }
            else if(Boolean(lastItem))
            {
               this.lastDropIndex = this.itemRendererToIndex(lastItem) + 1;
            }
            else
            {
               this.lastDropIndex = Boolean(this.collection) ? int(this.collection.length) : 0;
            }
         }
         return this.lastDropIndex;
      }
      
      protected function calculateDropIndicatorY(rowCount:Number, rowNum:int) : Number
      {
         var i:int = 0;
         var yy:Number = 0;
         if(Boolean(rowCount) && Boolean(rowNum < rowCount) && Boolean(this.listItems[rowNum].length) && Boolean(this.listItems[rowNum][0]))
         {
            return this.listItems[rowNum][0].y - 1;
         }
         for(i = 0; i < rowCount; i++)
         {
            if(!Boolean(this.listItems[i].length))
            {
               break;
            }
            yy += this.rowInfo[i].height;
         }
         return yy;
      }
      
      public function showDropFeedback(event:DragEvent) : void
      {
         var dropIndicatorClass:Class = null;
         var vm:EdgeMetrics = null;
         if(!this.dropIndicator)
         {
            dropIndicatorClass = getStyle("dropIndicatorSkin");
            if(!dropIndicatorClass)
            {
               dropIndicatorClass = ListDropIndicator;
            }
            this.dropIndicator = IFlexDisplayObject(new dropIndicatorClass());
            vm = viewMetrics;
            drawFocus(true);
            this.dropIndicator.x = 2;
            this.dropIndicator.setActualSize(this.listContent.width - 4,4);
            this.dropIndicator.visible = true;
            this.listContent.addChild(DisplayObject(this.dropIndicator));
            if(Boolean(this.collection))
            {
               if(this.dragScrollingInterval == 0)
               {
                  this.dragScrollingInterval = setInterval(this.dragScroll,15);
               }
            }
         }
         var rowCount:int = int(this.listItems.length);
         var partialRow:int = this.rowInfo[rowCount - this.offscreenExtraRowsBottom - 1].y + this.rowInfo[rowCount - this.offscreenExtraRowsBottom - 1].height > this.listContent.heightExcludingOffsets - this.listContent.topOffset ? 1 : 0;
         var rowNum:Number = this.calculateDropIndex(event);
         rowNum -= this.verticalScrollPosition;
         var rc:Number = this.listItems.length;
         if(rowNum >= rc)
         {
            if(Boolean(partialRow))
            {
               rowNum = rc - 1;
            }
            else
            {
               rowNum = rc;
            }
         }
         if(rowNum < 0)
         {
            rowNum = 0;
         }
         this.dropIndicator.y = this.calculateDropIndicatorY(rc,rowNum + this.offscreenExtraRowsTop);
      }
      
      public function hideDropFeedback(event:DragEvent) : void
      {
         if(Boolean(this.dropIndicator))
         {
            DisplayObject(this.dropIndicator).parent.removeChild(DisplayObject(this.dropIndicator));
            this.dropIndicator = null;
            drawFocus(false);
         }
      }
      
      protected function seekPendingFailureHandler(data:Object, info:ListBaseSeekPending) : void
      {
      }
      
      protected function seekPendingResultHandler(data:Object, info:ListBaseSeekPending) : void
      {
         if(info != this.lastSeekPending)
         {
            return;
         }
         this.lastSeekPending = null;
         this.iteratorValid = true;
         try
         {
            this.iterator.seek(info.bookmark,info.offset);
         }
         catch(e:ItemPendingError)
         {
            lastSeekPending = new ListBaseSeekPending(info.bookmark,info.offset);
            e.addResponder(new ItemResponder(seekPendingResultHandler,seekPendingFailureHandler,lastSeekPending));
            iteratorValid = false;
         }
         if(this.bSortItemPending)
         {
            this.bSortItemPending = false;
            this.adjustAfterSort();
         }
         this.itemsSizeChanged = true;
         invalidateDisplayList();
      }
      
      private function findPendingFailureHandler(data:Object, info:ListBaseFindPending) : void
      {
      }
      
      private function findPendingResultHandler(data:Object, info:ListBaseFindPending) : void
      {
         this.iterator.seek(info.bookmark,info.offset);
         this.findStringLoop(info.searchString,info.startingBookmark,info.currentIndex,info.stopIndex);
      }
      
      private function selectionPendingFailureHandler(data:Object, info:ListBaseSelectionPending) : void
      {
      }
      
      private function selectionPendingResultHandler(data:Object, info:ListBaseSelectionPending) : void
      {
         this.iterator.seek(info.bookmark,info.offset);
         this.shiftSelectionLoop(info.incrementing,info.index,info.stopData,info.transition,info.placeHolder);
      }
      
      private function selectionDataPendingFailureHandler(data:Object, info:ListBaseSelectionDataPending) : void
      {
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function selectionDataPendingResultHandler(data:Object, info:ListBaseSelectionDataPending) : void
      {
         if(Boolean(info.bookmark))
         {
            this.collectionIterator.seek(info.bookmark,info.offset);
         }
         this.setSelectionDataLoop(info.items,info.index,info.useFind);
      }
      
      private function selectionIndicesPendingFailureHandler(data:Object, info:ListBaseSelectionDataPending) : void
      {
      }
      
      private function selectionIndicesPendingResultHandler(data:Object, info:ListBaseSelectionDataPending) : void
      {
         if(Boolean(info.bookmark))
         {
            this.iterator.seek(info.bookmark,info.offset);
         }
         this.setSelectionIndicesLoop(info.index,info.items,info.useFind);
      }
      
      protected function findKey(eventCode:int) : Boolean
      {
         var tmpCode:int = eventCode;
         return tmpCode >= 33 && tmpCode <= 126 && this.findString(String.fromCharCode(tmpCode));
      }
      
      public function findString(str:String) : Boolean
      {
         var stopIndex:int;
         var i:int;
         var cursorPos:CursorBookmark = null;
         var bMovedNext:Boolean = false;
         if(!this.collection || this.collection.length == 0)
         {
            return false;
         }
         cursorPos = this.iterator.bookmark;
         stopIndex = this.selectedIndex;
         i = stopIndex + 1;
         if(this.selectedIndex == -1)
         {
            try
            {
               this.iterator.seek(CursorBookmark.FIRST,0);
            }
            catch(e1:ItemPendingError)
            {
               e1.addResponder(new ItemResponder(findPendingResultHandler,findPendingFailureHandler,new ListBaseFindPending(str,cursorPos,CursorBookmark.FIRST,0,0,collection.length)));
               iteratorValid = false;
               return false;
            }
            stopIndex = int(this.collection.length);
            i = 0;
         }
         else
         {
            try
            {
               this.iterator.seek(CursorBookmark.FIRST,stopIndex);
            }
            catch(e2:ItemPendingError)
            {
               if(anchorIndex == collection.length - 1)
               {
                  e2.addResponder(new ItemResponder(findPendingResultHandler,findPendingFailureHandler,new ListBaseFindPending(str,cursorPos,CursorBookmark.FIRST,0,0,collection.length)));
               }
               else
               {
                  e2.addResponder(new ItemResponder(findPendingResultHandler,findPendingFailureHandler,new ListBaseFindPending(str,cursorPos,anchorBookmark,1,anchorIndex + 1,anchorIndex)));
               }
               iteratorValid = false;
               return false;
            }
            bMovedNext = false;
            try
            {
               bMovedNext = Boolean(this.iterator.moveNext());
            }
            catch(e3:ItemPendingError)
            {
               e3.addResponder(new ItemResponder(findPendingResultHandler,findPendingFailureHandler,new ListBaseFindPending(str,cursorPos,anchorBookmark,1,anchorIndex + 1,anchorIndex)));
               iteratorValid = false;
               return false;
            }
            if(!bMovedNext)
            {
               try
               {
                  this.iterator.seek(CursorBookmark.FIRST,0);
               }
               catch(e4:ItemPendingError)
               {
                  e4.addResponder(new ItemResponder(findPendingResultHandler,findPendingFailureHandler,new ListBaseFindPending(str,cursorPos,CursorBookmark.FIRST,0,0,collection.length)));
                  iteratorValid = false;
                  return false;
               }
               stopIndex = int(this.collection.length);
               i = 0;
            }
         }
         return this.findStringLoop(str,cursorPos,i,stopIndex);
      }
      
      private function findStringLoop(str:String, cursorPos:CursorBookmark, i:int, stopIndex:int) : Boolean
      {
         var itmStr:String = null;
         var item:IListItemRenderer = null;
         var pt:Point = null;
         var evt:ListEvent = null;
         var more:Boolean = false;
         while(i != stopIndex)
         {
            itmStr = this.itemToLabel(this.iterator.current);
            itmStr = itmStr.substring(0,str.length);
            if(str == itmStr || str.toUpperCase() == itmStr.toUpperCase())
            {
               this.iterator.seek(cursorPos,0);
               this.scrollToIndex(i);
               this.commitSelectedIndex(i);
               item = this.indexToItemRenderer(i);
               pt = this.itemRendererToIndices(item);
               evt = new ListEvent(ListEvent.CHANGE);
               evt.itemRenderer = item;
               if(Boolean(pt))
               {
                  evt.columnIndex = pt.x;
                  evt.rowIndex = pt.y;
               }
               dispatchEvent(evt);
               return true;
            }
            more = Boolean(this.iterator.moveNext());
            if(!more && stopIndex != this.collection.length)
            {
               i = -1;
               this.iterator.seek(CursorBookmark.FIRST,0);
            }
            i++;
         }
         this.iterator.seek(cursorPos,0);
         this.iteratorValid = true;
         return false;
      }
      
      private function adjustAfterSort() : void
      {
         var p:String = null;
         var index:int = 0;
         var newVerticalScrollPosition:int = 0;
         var newHorizontalScrollPosition:int = 0;
         var pos:int = 0;
         var data:ListBaseSelectionData = null;
         var i:int = 0;
         for(p in this.selectedData)
         {
            i++;
         }
         index = Boolean(this.anchorBookmark) ? int(this.anchorBookmark.getViewIndex()) : -1;
         if(index >= 0)
         {
            if(i == 1)
            {
               this._selectedIndex = this.anchorIndex = this.caretIndex = index;
               data = this.selectedData[p];
               data.index = index;
            }
            newVerticalScrollPosition = this.indexToRow(index);
            if(newVerticalScrollPosition == -1)
            {
               return;
            }
            newVerticalScrollPosition = Math.min(maxVerticalScrollPosition,newVerticalScrollPosition);
            newHorizontalScrollPosition = this.indexToColumn(index);
            if(newHorizontalScrollPosition == -1)
            {
               return;
            }
            newHorizontalScrollPosition = Math.min(maxHorizontalScrollPosition,newHorizontalScrollPosition);
            pos = this.scrollPositionToIndex(newHorizontalScrollPosition,newVerticalScrollPosition);
            try
            {
               this.iterator.seek(CursorBookmark.CURRENT,pos - index);
               if(!this.iteratorValid)
               {
                  this.iteratorValid = true;
                  this.lastSeekPending = null;
               }
            }
            catch(e:ItemPendingError)
            {
               lastSeekPending = new ListBaseSeekPending(CursorBookmark.CURRENT,pos - index);
               e.addResponder(new ItemResponder(seekPendingResultHandler,seekPendingFailureHandler,lastSeekPending));
               iteratorValid = false;
               return;
            }
            super.verticalScrollPosition = newVerticalScrollPosition;
            if(this.listType != "vertical")
            {
               super.horizontalScrollPosition = newHorizontalScrollPosition;
            }
         }
         else
         {
            try
            {
               index = this.scrollPositionToIndex(this.horizontalScrollPosition,this.verticalScrollPosition - this.offscreenExtraRowsTop);
               this.iterator.seek(CursorBookmark.FIRST,index);
               if(!this.iteratorValid)
               {
                  this.iteratorValid = true;
                  this.lastSeekPending = null;
               }
            }
            catch(e:ItemPendingError)
            {
               lastSeekPending = new ListBaseSeekPending(CursorBookmark.FIRST,index);
               e.addResponder(new ItemResponder(seekPendingResultHandler,seekPendingFailureHandler,lastSeekPending));
               iteratorValid = false;
               return;
            }
         }
         if(i > 1)
         {
            this.commitSelectedItems(this.selectedItems);
         }
      }
      
      override protected function keyDownHandler(event:KeyboardEvent) : void
      {
         var li:IListItemRenderer = null;
         var pt:Point = null;
         var evt:ListEvent = null;
         if(!this.selectable)
         {
            return;
         }
         if(!this.iteratorValid)
         {
            return;
         }
         if(!this.collection || this.collection.length == 0)
         {
            return;
         }
         switch(event.keyCode)
         {
            case Keyboard.UP:
            case Keyboard.DOWN:
               this.moveSelectionVertically(event.keyCode,event.shiftKey,event.ctrlKey);
               event.stopPropagation();
               break;
            case Keyboard.LEFT:
            case Keyboard.RIGHT:
               this.moveSelectionHorizontally(event.keyCode,event.shiftKey,event.ctrlKey);
               event.stopPropagation();
               break;
            case Keyboard.END:
            case Keyboard.HOME:
            case Keyboard.PAGE_UP:
            case Keyboard.PAGE_DOWN:
               this.moveSelectionVertically(event.keyCode,event.shiftKey,event.ctrlKey);
               event.stopPropagation();
               break;
            case Keyboard.SPACE:
               if(this.caretIndex != -1 && this.caretIndex - this.verticalScrollPosition >= 0 && this.caretIndex - this.verticalScrollPosition < this.listItems.length)
               {
                  li = this.listItems[this.caretIndex - this.verticalScrollPosition][0];
                  if(this.selectItem(li,event.shiftKey,event.ctrlKey))
                  {
                     pt = this.itemRendererToIndices(li);
                     evt = new ListEvent(ListEvent.CHANGE);
                     if(Boolean(pt))
                     {
                        evt.columnIndex = pt.x;
                        evt.rowIndex = pt.y;
                     }
                     evt.itemRenderer = li;
                     dispatchEvent(evt);
                  }
               }
               break;
            default:
               if(this.findKey(event.charCode))
               {
                  event.stopPropagation();
               }
         }
      }
      
      override protected function mouseWheelHandler(event:MouseEvent) : void
      {
         var oldPosition:Number = NaN;
         var newPos:int = 0;
         var scrollEvent:ScrollEvent = null;
         if(Boolean(!event.isDefaultPrevented()) && Boolean(verticalScrollBar) && Boolean(verticalScrollBar.visible))
         {
            oldPosition = this.verticalScrollPosition;
            newPos = this.verticalScrollPosition;
            newPos -= event.delta * verticalScrollBar.lineScrollSize;
            newPos = Math.max(0,Math.min(newPos,verticalScrollBar.maxScrollPosition));
            this.verticalScrollPosition = newPos;
            if(oldPosition != this.verticalScrollPosition)
            {
               scrollEvent = new ScrollEvent(ScrollEvent.SCROLL);
               scrollEvent.direction = ScrollEventDirection.VERTICAL;
               scrollEvent.position = this.verticalScrollPosition;
               scrollEvent.delta = this.verticalScrollPosition - oldPosition;
               dispatchEvent(scrollEvent);
            }
            event.preventDefault();
         }
      }
      
      protected function collectionChangeHandler(event:Event) : void
      {
         var len:int = 0;
         var index:int = 0;
         var i:int = 0;
         var data:ListBaseSelectionData = null;
         var p:String = null;
         var selectedUID:String = null;
         var ce:CollectionEvent = null;
         var emitEvent:Boolean = false;
         var oldUID:String = null;
         var sd:ListBaseSelectionData = null;
         var requiresValueCommit:Boolean = false;
         var firstUID:String = null;
         var uid:String = null;
         var deletedItems:Array = null;
         var fakeRemove:CollectionEvent = null;
         if(event is CollectionEvent)
         {
            ce = CollectionEvent(event);
            if(ce.kind == CollectionEventKind.ADD)
            {
               this.prepareDataEffect(ce);
               if(ce.location == 0 && this.verticalScrollPosition == 0)
               {
                  try
                  {
                     this.iterator.seek(CursorBookmark.FIRST);
                     if(!this.iteratorValid)
                     {
                        this.iteratorValid = true;
                        this.lastSeekPending = null;
                     }
                  }
                  catch(e:ItemPendingError)
                  {
                     lastSeekPending = new ListBaseSeekPending(CursorBookmark.FIRST,0);
                     e.addResponder(new ItemResponder(seekPendingResultHandler,seekPendingFailureHandler,lastSeekPending));
                     iteratorValid = false;
                  }
               }
               else if(this.listType == "vertical" && this.verticalScrollPosition >= ce.location)
               {
                  super.verticalScrollPosition += ce.items.length;
               }
               emitEvent = this.adjustAfterAdd(ce.items,ce.location);
               if(emitEvent)
               {
                  dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
               }
            }
            else if(ce.kind == CollectionEventKind.REPLACE)
            {
               selectedUID = Boolean(this.selectedItem) ? this.itemToUID(this.selectedItem) : null;
               len = int(ce.items.length);
               for(i = 0; i < len; i++)
               {
                  oldUID = this.itemToUID(ce.items[i].oldValue);
                  sd = this.selectedData[oldUID];
                  if(Boolean(sd))
                  {
                     sd.data = ce.items[i].newValue;
                     delete this.selectedData[oldUID];
                     this.selectedData[this.itemToUID(sd.data)] = sd;
                     if(selectedUID == oldUID)
                     {
                        this._selectedItem = sd.data;
                        dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
                     }
                  }
               }
               this.prepareDataEffect(ce);
            }
            else if(ce.kind == CollectionEventKind.REMOVE)
            {
               this.prepareDataEffect(ce);
               requiresValueCommit = false;
               if(Boolean(this.listItems.length) && Boolean(this.listItems[0].length))
               {
                  firstUID = this.rowMap[this.listItems[0][0].name].uid;
                  selectedUID = Boolean(this.selectedItem) ? this.itemToUID(this.selectedItem) : null;
                  for(i = 0; i < ce.items.length; i++)
                  {
                     uid = this.itemToUID(ce.items[i]);
                     if(uid == firstUID && this.verticalScrollPosition == 0)
                     {
                        try
                        {
                           this.iterator.seek(CursorBookmark.FIRST);
                           if(!this.iteratorValid)
                           {
                              this.iteratorValid = true;
                              this.lastSeekPending = null;
                           }
                        }
                        catch(e1:ItemPendingError)
                        {
                           lastSeekPending = new ListBaseSeekPending(CursorBookmark.FIRST,0);
                           e1.addResponder(new ItemResponder(seekPendingResultHandler,seekPendingFailureHandler,lastSeekPending));
                           iteratorValid = false;
                        }
                     }
                     if(Boolean(this.selectedData[uid]))
                     {
                        this.removeSelectionData(uid);
                     }
                     if(selectedUID == uid)
                     {
                        this._selectedItem = null;
                        this._selectedIndex = -1;
                        requiresValueCommit = true;
                     }
                     this.removeIndicators(uid);
                  }
                  if(this.listType == "vertical" && this.verticalScrollPosition >= ce.location)
                  {
                     if(this.verticalScrollPosition > ce.location)
                     {
                        super.verticalScrollPosition = this.verticalScrollPosition - Math.min(ce.items.length,this.verticalScrollPosition - ce.location);
                     }
                     else if(this.verticalScrollPosition >= this.collection.length)
                     {
                        super.verticalScrollPosition = Math.max(this.collection.length - 1,0);
                     }
                     try
                     {
                        this.offscreenExtraRowsTop = Math.min(this.offscreenExtraRowsTop,this.verticalScrollPosition);
                        index = this.scrollPositionToIndex(this.horizontalScrollPosition,this.verticalScrollPosition - this.offscreenExtraRowsTop);
                        this.iterator.seek(CursorBookmark.FIRST,index);
                        if(!this.iteratorValid)
                        {
                           this.iteratorValid = true;
                           this.lastSeekPending = null;
                        }
                     }
                     catch(e2:ItemPendingError)
                     {
                        lastSeekPending = new ListBaseSeekPending(CursorBookmark.FIRST,index);
                        e2.addResponder(new ItemResponder(seekPendingResultHandler,seekPendingFailureHandler,lastSeekPending));
                        iteratorValid = false;
                     }
                  }
                  emitEvent = this.adjustAfterRemove(ce.items,ce.location,requiresValueCommit);
                  if(emitEvent)
                  {
                     dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
                  }
               }
            }
            else if(ce.kind == CollectionEventKind.MOVE)
            {
               if(ce.oldLocation < ce.location)
               {
                  for(p in this.selectedData)
                  {
                     data = this.selectedData[p];
                     if(data.index > ce.oldLocation && data.index < ce.location)
                     {
                        --data.index;
                     }
                     else if(data.index == ce.oldLocation)
                     {
                        data.index = ce.location;
                     }
                  }
                  if(this._selectedIndex > ce.oldLocation && this._selectedIndex < ce.location)
                  {
                     --this._selectedIndex;
                  }
                  else if(this._selectedIndex == ce.oldLocation)
                  {
                     this._selectedIndex = ce.location;
                  }
               }
               else if(ce.location < ce.oldLocation)
               {
                  for(p in this.selectedData)
                  {
                     data = this.selectedData[p];
                     if(data.index > ce.location && data.index < ce.oldLocation)
                     {
                        ++data.index;
                     }
                     else if(data.index == ce.oldLocation)
                     {
                        data.index = ce.location;
                     }
                  }
                  if(this._selectedIndex > ce.location && this._selectedIndex < ce.oldLocation)
                  {
                     ++this._selectedIndex;
                  }
                  else if(this._selectedIndex == ce.oldLocation)
                  {
                     this._selectedIndex = ce.location;
                  }
               }
               if(ce.oldLocation == this.verticalScrollPosition)
               {
                  if(ce.location > maxVerticalScrollPosition)
                  {
                     this.iterator.seek(CursorBookmark.CURRENT,maxVerticalScrollPosition - ce.location);
                  }
                  super.verticalScrollPosition = Math.min(ce.location,maxVerticalScrollPosition);
               }
               else if(ce.location >= this.verticalScrollPosition && ce.oldLocation < this.verticalScrollPosition)
               {
                  this.seekNextSafely(this.iterator,this.verticalScrollPosition);
               }
               else if(ce.location <= this.verticalScrollPosition && ce.oldLocation > this.verticalScrollPosition)
               {
                  this.seekPreviousSafely(this.iterator,this.verticalScrollPosition);
               }
            }
            else if(ce.kind == CollectionEventKind.REFRESH)
            {
               if(Boolean(this.anchorBookmark))
               {
                  try
                  {
                     this.iterator.seek(this.anchorBookmark,0);
                     if(!this.iteratorValid)
                     {
                        this.iteratorValid = true;
                        this.lastSeekPending = null;
                     }
                  }
                  catch(e:ItemPendingError)
                  {
                     bSortItemPending = true;
                     lastSeekPending = new ListBaseSeekPending(anchorBookmark,0);
                     e.addResponder(new ItemResponder(seekPendingResultHandler,seekPendingFailureHandler,lastSeekPending));
                     iteratorValid = false;
                  }
                  catch(cursorError:CursorError)
                  {
                     clearSelected();
                  }
                  this.adjustAfterSort();
               }
               else
               {
                  try
                  {
                     index = this.scrollPositionToIndex(this.horizontalScrollPosition,this.verticalScrollPosition);
                     this.iterator.seek(CursorBookmark.FIRST,index);
                     if(!this.iteratorValid)
                     {
                        this.iteratorValid = true;
                        this.lastSeekPending = null;
                     }
                  }
                  catch(e:ItemPendingError)
                  {
                     bSortItemPending = true;
                     lastSeekPending = new ListBaseSeekPending(CursorBookmark.FIRST,index);
                     e.addResponder(new ItemResponder(seekPendingResultHandler,seekPendingFailureHandler,lastSeekPending));
                     iteratorValid = false;
                  }
               }
            }
            else if(ce.kind == CollectionEventKind.RESET)
            {
               if(this.collection.length == 0 || this.runningDataEffect && this.actualCollection.length == 0)
               {
                  deletedItems = this.reconstructDataFromListItems();
                  if(Boolean(deletedItems.length))
                  {
                     fakeRemove = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
                     fakeRemove.kind = CollectionEventKind.REMOVE;
                     fakeRemove.items = deletedItems;
                     fakeRemove.location = 0;
                     this.prepareDataEffect(fakeRemove);
                  }
               }
               try
               {
                  this.iterator.seek(CursorBookmark.FIRST);
                  if(!this.iteratorValid)
                  {
                     this.iteratorValid = true;
                     this.lastSeekPending = null;
                  }
                  this.collectionIterator.seek(CursorBookmark.FIRST);
               }
               catch(e:ItemPendingError)
               {
                  lastSeekPending = new ListBaseSeekPending(CursorBookmark.FIRST,0);
                  e.addResponder(new ItemResponder(seekPendingResultHandler,seekPendingFailureHandler,lastSeekPending));
                  iteratorValid = false;
               }
               if(this.bSelectedIndexChanged || this.bSelectedItemChanged || this.bSelectedIndicesChanged || this.bSelectedItemsChanged)
               {
                  this.bSelectionChanged = true;
               }
               else
               {
                  this.commitSelectedIndex(-1);
               }
               if(isNaN(this.verticalScrollPositionPending))
               {
                  this.verticalScrollPositionPending = 0;
                  super.verticalScrollPosition = 0;
               }
               if(isNaN(this.horizontalScrollPositionPending))
               {
                  this.horizontalScrollPositionPending = 0;
                  super.horizontalScrollPosition = 0;
               }
               invalidateSize();
            }
            else if(ce.kind == CollectionEventKind.UPDATE)
            {
               selectedUID = Boolean(this.selectedItem) ? this.itemToUID(this.selectedItem) : null;
               len = int(ce.items.length);
               for(i = 0; i < len; i++)
               {
                  if(ce.items[i].property == "uid")
                  {
                     oldUID = ce.items[i].oldValue;
                     sd = this.selectedData[oldUID];
                     if(Boolean(sd))
                     {
                        sd.data = ce.items[i].target;
                        delete this.selectedData[oldUID];
                        this.selectedData[ce.items[i].newValue] = sd;
                        if(selectedUID == oldUID)
                        {
                           this._selectedItem = sd.data;
                           dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
                        }
                     }
                  }
               }
            }
         }
         this.itemsSizeChanged = true;
         invalidateDisplayList();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function reconstructDataFromListItems() : Array
      {
         var items:Array = null;
         var i:int = 0;
         var renderer:IListItemRenderer = null;
         var data:Object = null;
         var data2:Object = null;
         var j:int = 0;
         if(!this.listItems)
         {
            return [];
         }
         items = [];
         for(i = 0; i < this.listItems.length; i++)
         {
            if(Boolean(this.listItems[i]))
            {
               renderer = this.listItems[i][0] as IListItemRenderer;
               if(Boolean(renderer))
               {
                  data = renderer.data;
                  items.push(data);
                  for(j = 0; j < this.listItems[i].length; j++)
                  {
                     renderer = this.listItems[i][j] as IListItemRenderer;
                     if(Boolean(renderer))
                     {
                        data2 = renderer.data;
                        if(data2 != data)
                        {
                           items.push(data2);
                        }
                     }
                  }
               }
            }
         }
         return items;
      }
      
      protected function prepareDataEffect(ce:CollectionEvent) : void
      {
         var dce:Object = null;
         var dceClass:Class = null;
         var firstItemIndex:int = 0;
         var lastItemIndex:int = 0;
         if(!this.cachedItemsChangeEffect)
         {
            dce = getStyle("itemsChangeEffect");
            dceClass = dce as Class;
            if(Boolean(dceClass))
            {
               dce = new dceClass();
            }
            this.cachedItemsChangeEffect = dce as IEffect;
         }
         if(this.runningDataEffect)
         {
            this.collection = this.actualCollection;
            this.listContent.iterator = this.iterator = this.actualIterator;
            this.cachedItemsChangeEffect.end();
            this.modifiedCollectionView = null;
         }
         if(Boolean(this.cachedItemsChangeEffect) && this.iteratorValid)
         {
            firstItemIndex = int(this.iterator.bookmark.getViewIndex());
            lastItemIndex = firstItemIndex + this.rowCount * this.columnCount - 1;
            if(!this.modifiedCollectionView && this.collection is IList)
            {
               this.modifiedCollectionView = new ModifiedCollectionView(ICollectionView(this.collection));
            }
            if(Boolean(this.modifiedCollectionView))
            {
               this.modifiedCollectionView.processCollectionEvent(ce,firstItemIndex,lastItemIndex);
               this.runDataEffectNextUpdate = true;
               if(invalidateDisplayListFlag)
               {
                  callLater(this.invalidateList);
               }
               else
               {
                  this.invalidateList();
               }
            }
         }
      }
      
      protected function adjustAfterAdd(items:Array, location:int) : Boolean
      {
         var length:int = 0;
         var requiresValueCommit:Boolean = false;
         var data:ListBaseSelectionData = null;
         var placeHolder:CursorBookmark = null;
         var p:String = null;
         length = int(items.length);
         requiresValueCommit = false;
         for(p in this.selectedData)
         {
            data = this.selectedData[p];
            if(data.index >= location)
            {
               data.index += length;
            }
         }
         if(this._selectedIndex >= location)
         {
            this._selectedIndex += length;
            requiresValueCommit = true;
         }
         if(this.anchorIndex >= location)
         {
            this.anchorIndex += length;
            placeHolder = this.iterator.bookmark;
            try
            {
               this.iterator.seek(CursorBookmark.FIRST,this.anchorIndex);
               this.anchorBookmark = this.iterator.bookmark;
            }
            catch(e:ItemPendingError)
            {
               e.addResponder(new ItemResponder(setBookmarkPendingResultHandler,setBookmarkPendingFailureHandler,{
                  "property":"anchorBookmark",
                  "value":anchorIndex
               }));
            }
            this.iterator.seek(placeHolder);
         }
         if(this.caretIndex >= location)
         {
            this.caretIndex += length;
            placeHolder = this.iterator.bookmark;
            try
            {
               this.iterator.seek(CursorBookmark.FIRST,this.caretIndex);
               this.caretBookmark = this.iterator.bookmark;
            }
            catch(e:ItemPendingError)
            {
               e.addResponder(new ItemResponder(setBookmarkPendingResultHandler,setBookmarkPendingFailureHandler,{
                  "property":"caretBookmark",
                  "value":caretIndex
               }));
            }
            this.iterator.seek(placeHolder);
         }
         return requiresValueCommit;
      }
      
      protected function adjustAfterRemove(items:Array, location:int, emitEvent:Boolean) : Boolean
      {
         var data:ListBaseSelectionData = null;
         var requiresValueCommit:Boolean = false;
         var i:int = 0;
         var length:int = 0;
         var placeHolder:CursorBookmark = null;
         var s:String = null;
         requiresValueCommit = emitEvent;
         i = 0;
         length = int(items.length);
         for(s in this.selectedData)
         {
            i++;
            data = this.selectedData[s];
            if(data.index > location)
            {
               data.index -= length;
            }
         }
         if(this._selectedIndex > location)
         {
            this._selectedIndex -= length;
            requiresValueCommit = true;
         }
         if(i > 0 && this._selectedIndex == -1)
         {
            this._selectedIndex = data.index;
            this._selectedItem = data.data;
            requiresValueCommit = true;
         }
         if(i == 0)
         {
            this._selectedIndex = -1;
            this.bSelectionChanged = true;
            this.bSelectedIndexChanged = true;
            invalidateDisplayList();
         }
         if(this.anchorIndex > location)
         {
            this.anchorIndex -= length;
            placeHolder = this.iterator.bookmark;
            try
            {
               this.iterator.seek(CursorBookmark.FIRST,this.anchorIndex);
               this.anchorBookmark = this.iterator.bookmark;
            }
            catch(e:ItemPendingError)
            {
               e.addResponder(new ItemResponder(setBookmarkPendingResultHandler,setBookmarkPendingFailureHandler,{
                  "property":"anchorBookmark",
                  "value":anchorIndex
               }));
            }
            this.iterator.seek(placeHolder);
         }
         if(this.caretIndex > location)
         {
            this.caretIndex -= length;
            placeHolder = this.iterator.bookmark;
            try
            {
               this.iterator.seek(CursorBookmark.FIRST,this.caretIndex);
               this.caretBookmark = this.iterator.bookmark;
            }
            catch(e:ItemPendingError)
            {
               e.addResponder(new ItemResponder(setBookmarkPendingResultHandler,setBookmarkPendingFailureHandler,{
                  "property":"caretBookmark",
                  "value":caretIndex
               }));
            }
            this.iterator.seek(placeHolder);
         }
         return requiresValueCommit;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setBookmarkPendingFailureHandler(data:Object, info:Object) : void
      {
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setBookmarkPendingResultHandler(data:Object, info:Object) : void
      {
         var placeHolder:CursorBookmark = null;
         placeHolder = this.iterator.bookmark;
         try
         {
            this.iterator.seek(CursorBookmark.FIRST,info.value);
            this[info.property] = this.iterator.bookmark;
         }
         catch(e:ItemPendingError)
         {
            e.addResponder(new ItemResponder(setBookmarkPendingResultHandler,setBookmarkPendingFailureHandler,info));
         }
         this.iterator.seek(placeHolder);
      }
      
      protected function mouseOverHandler(event:MouseEvent) : void
      {
         var evt:ListEvent = null;
         var item:IListItemRenderer = null;
         var pt:Point = null;
         var uid:String = null;
         var lastUID:String = null;
         var rowData:BaseListData = null;
         if(!enabled || !this.selectable)
         {
            return;
         }
         if(this.dragScrollingInterval != 0 && !event.buttonDown)
         {
            this.mouseIsUp();
         }
         this.isPressed = event.buttonDown;
         item = this.mouseEventToItemRenderer(event);
         pt = this.itemRendererToIndices(item);
         if(!item)
         {
            return;
         }
         uid = this.itemToUID(item.data);
         if(!this.isPressed || this.allowDragSelection)
         {
            if(Boolean(event.relatedObject))
            {
               if(Boolean(this.lastHighlightItemRenderer) && Boolean(this.highlightUID))
               {
                  rowData = this.rowMap[item.name];
                  lastUID = rowData.uid;
               }
               if(this.itemRendererContains(item,event.relatedObject) || uid == lastUID || event.relatedObject == this.highlightIndicator)
               {
                  return;
               }
            }
            if(Boolean(getStyle("useRollOver")) && item.data != null)
            {
               if(this.allowDragSelection)
               {
                  this.bSelectOnRelease = true;
               }
               this.drawItem(this.UIDToItemRenderer(uid),this.isItemSelected(item.data),true,uid == this.caretUID);
               if(Boolean(pt))
               {
                  evt = new ListEvent(ListEvent.ITEM_ROLL_OVER);
                  evt.columnIndex = pt.x;
                  evt.rowIndex = pt.y;
                  evt.itemRenderer = item;
                  dispatchEvent(evt);
                  this.lastHighlightItemIndices = pt;
                  this.lastHighlightItemRendererAtIndices = item;
               }
            }
         }
         else
         {
            if(DragManager.isDragging)
            {
               return;
            }
            if(this.dragScrollingInterval != 0 && this.allowDragSelection || this.menuSelectionMode)
            {
               if(this.selectItem(item,event.shiftKey,event.ctrlKey))
               {
                  evt = new ListEvent(ListEvent.CHANGE);
                  evt.itemRenderer = item;
                  if(Boolean(pt))
                  {
                     evt.columnIndex = pt.x;
                     evt.rowIndex = pt.y;
                  }
                  dispatchEvent(evt);
               }
            }
         }
      }
      
      protected function mouseOutHandler(event:MouseEvent) : void
      {
         var item:IListItemRenderer = null;
         if(!enabled || !this.selectable)
         {
            return;
         }
         this.isPressed = event.buttonDown;
         item = this.mouseEventToItemRenderer(event);
         if(!item)
         {
            return;
         }
         if(!this.isPressed)
         {
            if(this.itemRendererContains(item,event.relatedObject) || event.relatedObject == this.listContent || event.relatedObject == this.highlightIndicator || !this.highlightItemRenderer)
            {
               return;
            }
            if(Boolean(getStyle("useRollOver")) && item.data != null)
            {
               this.clearHighlight(item);
            }
         }
      }
      
      protected function mouseMoveHandler(event:MouseEvent) : void
      {
         var pt:Point = null;
         var item:IListItemRenderer = null;
         var dragEvent:DragEvent = null;
         var rowData:BaseListData = null;
         if(!enabled || !this.selectable)
         {
            return;
         }
         pt = new Point(event.localX,event.localY);
         pt = DisplayObject(event.target).localToGlobal(pt);
         pt = globalToLocal(pt);
         if(Boolean(this.isPressed) && Boolean(this.mouseDownPoint) && (Math.abs(this.mouseDownPoint.x - pt.x) > DRAG_THRESHOLD || Math.abs(this.mouseDownPoint.y - pt.y) > DRAG_THRESHOLD))
         {
            if(this.dragEnabled && !DragManager.isDragging && Boolean(this.mouseDownPoint))
            {
               dragEvent = new DragEvent(DragEvent.DRAG_START);
               dragEvent.dragInitiator = this;
               dragEvent.localX = this.mouseDownPoint.x;
               dragEvent.localY = this.mouseDownPoint.y;
               dragEvent.buttonDown = true;
               dispatchEvent(dragEvent);
            }
         }
         item = this.mouseEventToItemRenderer(event);
         if(Boolean(item) && Boolean(this.highlightItemRenderer))
         {
            rowData = this.rowMap[item.name];
            if(Boolean(this.highlightItemRenderer) && Boolean(this.highlightUID) && rowData.uid != this.highlightUID)
            {
               if(!this.isPressed)
               {
                  if(Boolean(getStyle("useRollOver")) && this.highlightItemRenderer.data != null)
                  {
                     this.clearHighlight(this.highlightItemRenderer);
                  }
               }
            }
         }
         else if(!item && Boolean(this.highlightItemRenderer))
         {
            if(!this.isPressed)
            {
               if(Boolean(getStyle("useRollOver")) && Boolean(this.highlightItemRenderer.data))
               {
                  this.clearHighlight(this.highlightItemRenderer);
               }
            }
         }
         if(Boolean(item) && !this.highlightItemRenderer)
         {
            this.mouseOverHandler(event);
         }
      }
      
      protected function mouseDownHandler(event:MouseEvent) : void
      {
         var item:IListItemRenderer = null;
         var pt:Point = null;
         if(!enabled || !this.selectable)
         {
            return;
         }
         if(this.runningDataEffect)
         {
            this.cachedItemsChangeEffect.end();
            this.dataEffectCompleted = true;
            this.itemsSizeChanged = true;
            this.invalidateList();
            this.dataItemWrappersByRenderer = new Dictionary();
            this.validateDisplayList();
         }
         this.isPressed = true;
         item = this.mouseEventToItemRenderer(event);
         if(!item)
         {
            return;
         }
         this.bSelectOnRelease = false;
         pt = new Point(event.localX,event.localY);
         pt = DisplayObject(event.target).localToGlobal(pt);
         this.mouseDownPoint = globalToLocal(pt);
         systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler,true,0,true);
         systemManager.getSandboxRoot().addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.mouseLeaveHandler,false,0,true);
         if(!this.dragEnabled)
         {
            this.dragScrollingInterval = setInterval(this.dragScroll,15);
         }
         if(this.dragEnabled)
         {
            this.mouseDownIndex = this.itemRendererToIndex(item);
         }
         if(this.dragEnabled && Boolean(this.selectedData[this.rowMap[item.name].uid]))
         {
            this.bSelectOnRelease = true;
         }
         else if(this.selectItem(item,event.shiftKey,event.ctrlKey))
         {
            this.mouseDownItem = item;
         }
      }
      
      private function mouseIsUp() : void
      {
         systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler,true);
         systemManager.getSandboxRoot().removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.mouseLeaveHandler);
         if(this.dragScrollingInterval != 0)
         {
            clearInterval(this.dragScrollingInterval);
            this.dragScrollingInterval = 0;
         }
      }
      
      private function mouseLeaveHandler(event:Event) : void
      {
         var evt:ListEvent = null;
         var pt:Point = null;
         this.mouseDownPoint = null;
         this.mouseDownIndex = -1;
         this.mouseIsUp();
         if(!enabled || !this.selectable)
         {
            return;
         }
         if(Boolean(this.mouseDownItem))
         {
            evt = new ListEvent(ListEvent.CHANGE);
            evt.itemRenderer = this.mouseDownItem;
            pt = this.itemRendererToIndices(this.mouseDownItem);
            if(Boolean(pt))
            {
               evt.columnIndex = pt.x;
               evt.rowIndex = pt.y;
            }
            dispatchEvent(evt);
            this.mouseDownItem = null;
         }
         this.isPressed = false;
      }
      
      protected function mouseUpHandler(event:MouseEvent) : void
      {
         var item:IListItemRenderer = null;
         var pt:Point = null;
         var evt:ListEvent = null;
         this.mouseDownPoint = null;
         this.mouseDownIndex = -1;
         item = this.mouseEventToItemRenderer(event);
         pt = this.itemRendererToIndices(item);
         this.mouseIsUp();
         if(!enabled || !this.selectable)
         {
            return;
         }
         if(Boolean(this.mouseDownItem))
         {
            evt = new ListEvent(ListEvent.CHANGE);
            evt.itemRenderer = this.mouseDownItem;
            pt = this.itemRendererToIndices(this.mouseDownItem);
            if(Boolean(pt))
            {
               evt.columnIndex = pt.x;
               evt.rowIndex = pt.y;
            }
            dispatchEvent(evt);
            this.mouseDownItem = null;
         }
         if(!item || !hitTestPoint(event.stageX,event.stageY))
         {
            this.isPressed = false;
            return;
         }
         if(this.bSelectOnRelease)
         {
            this.bSelectOnRelease = false;
            if(this.selectItem(item,event.shiftKey,event.ctrlKey))
            {
               evt = new ListEvent(ListEvent.CHANGE);
               evt.itemRenderer = item;
               if(Boolean(pt))
               {
                  evt.columnIndex = pt.x;
                  evt.rowIndex = pt.y;
               }
               dispatchEvent(evt);
            }
         }
         this.isPressed = false;
      }
      
      protected function mouseClickHandler(event:MouseEvent) : void
      {
         var item:IListItemRenderer = null;
         var pt:Point = null;
         var listEvent:ListEvent = null;
         item = this.mouseEventToItemRenderer(event);
         if(!item)
         {
            return;
         }
         pt = this.itemRendererToIndices(item);
         if(Boolean(pt))
         {
            listEvent = new ListEvent(ListEvent.ITEM_CLICK);
            listEvent.columnIndex = pt.x;
            listEvent.rowIndex = pt.y;
            listEvent.itemRenderer = item;
            dispatchEvent(listEvent);
         }
      }
      
      protected function mouseDoubleClickHandler(event:MouseEvent) : void
      {
         var item:IListItemRenderer = null;
         var pt:Point = null;
         var listEvent:ListEvent = null;
         item = this.mouseEventToItemRenderer(event);
         if(!item)
         {
            return;
         }
         pt = this.itemRendererToIndices(item);
         if(Boolean(pt))
         {
            listEvent = new ListEvent(ListEvent.ITEM_DOUBLE_CLICK);
            listEvent.columnIndex = pt.x;
            listEvent.rowIndex = pt.y;
            listEvent.itemRenderer = item;
            dispatchEvent(listEvent);
         }
      }
      
      protected function dragStartHandler(event:DragEvent) : void
      {
         var dragSource:DragSource = null;
         if(event.isDefaultPrevented())
         {
            return;
         }
         dragSource = new DragSource();
         this.addDragData(dragSource);
         DragManager.doDrag(this,dragSource,event,this.dragImage,0,0,0.5,this.dragMoveEnabled);
      }
      
      protected function dragEnterHandler(event:DragEvent) : void
      {
         if(event.isDefaultPrevented())
         {
            return;
         }
         this.lastDragEvent = event;
         if(enabled && this.iteratorValid && (Boolean(event.dragSource.hasFormat("items")) || Boolean(event.dragSource.hasFormat("itemsByIndex"))))
         {
            DragManager.acceptDragDrop(this);
            DragManager.showFeedback(event.ctrlKey ? DragManager.COPY : DragManager.MOVE);
            this.showDropFeedback(event);
            return;
         }
         this.hideDropFeedback(event);
         DragManager.showFeedback(DragManager.NONE);
      }
      
      protected function dragOverHandler(event:DragEvent) : void
      {
         if(event.isDefaultPrevented())
         {
            return;
         }
         this.lastDragEvent = event;
         if(enabled && this.iteratorValid && (Boolean(event.dragSource.hasFormat("items")) || Boolean(event.dragSource.hasFormat("itemsByIndex"))))
         {
            DragManager.showFeedback(event.ctrlKey ? DragManager.COPY : DragManager.MOVE);
            this.showDropFeedback(event);
            return;
         }
         this.hideDropFeedback(event);
         DragManager.showFeedback(DragManager.NONE);
      }
      
      protected function dragExitHandler(event:DragEvent) : void
      {
         if(event.isDefaultPrevented())
         {
            return;
         }
         this.lastDragEvent = null;
         this.hideDropFeedback(event);
         this.resetDragScrolling();
         DragManager.showFeedback(DragManager.NONE);
      }
      
      protected function dragDropHandler(event:DragEvent) : void
      {
         var dragSource:DragSource = null;
         var dropIndex:int = 0;
         if(event.isDefaultPrevented())
         {
            return;
         }
         this.hideDropFeedback(event);
         this.lastDragEvent = null;
         this.resetDragScrolling();
         if(!enabled)
         {
            return;
         }
         dragSource = event.dragSource;
         if(!dragSource.hasFormat("items") && !dragSource.hasFormat("itemsByIndex"))
         {
            return;
         }
         if(!this.dataProvider)
         {
            this.dataProvider = [];
         }
         dropIndex = this.calculateDropIndex(event);
         if(dragSource.hasFormat("items"))
         {
            this.insertItems(dropIndex,dragSource,event);
         }
         else
         {
            this.insertItemsByIndex(dropIndex,dragSource,event);
         }
         this.lastDragEvent = null;
      }
      
      private function insertItemsByIndex(dropIndex:int, dragSource:DragSource, event:DragEvent) : void
      {
         var items:Vector.<Object> = null;
         var count:int = 0;
         var i:int = 0;
         items = dragSource.dataForFormat("itemsByIndex") as Vector.<Object>;
         this.collectionIterator.seek(CursorBookmark.FIRST,dropIndex);
         count = int(items.length);
         for(i = 0; i < count; i++)
         {
            if(event.action == DragManager.COPY)
            {
               this.collectionIterator.insert(this.copyItemWithUID(items[i]));
            }
            else if(event.action == DragManager.MOVE)
            {
               this.collectionIterator.insert(items[i]);
            }
         }
      }
      
      private function insertItems(dropIndex:int, dragSource:DragSource, event:DragEvent) : void
      {
         var items:Array = null;
         var indices:Array = null;
         var i:int = 0;
         items = dragSource.dataForFormat("items") as Array;
         if(event.action == DragManager.MOVE && this.dragMoveEnabled && event.dragInitiator == this)
         {
            indices = this.selectedIndices;
            indices.sort(Array.NUMERIC);
            for(i = indices.length - 1; i >= 0; i--)
            {
               this.collectionIterator.seek(CursorBookmark.FIRST,indices[i]);
               if(indices[i] < dropIndex)
               {
                  dropIndex--;
               }
               this.collectionIterator.remove();
            }
            this.clearSelected(false);
         }
         this.collectionIterator.seek(CursorBookmark.FIRST,dropIndex);
         for(i = items.length - 1; i >= 0; i--)
         {
            if(event.action == DragManager.COPY)
            {
               this.collectionIterator.insert(this.copyItemWithUID(items[i]));
            }
            else if(event.action == DragManager.MOVE)
            {
               this.collectionIterator.insert(items[i]);
            }
         }
      }
      
      protected function copyItemWithUID(item:Object) : Object
      {
         var copyObj:Object = null;
         copyObj = ObjectUtil.copy(item);
         if(copyObj is IUID)
         {
            IUID(copyObj).uid = UIDUtil.createUID();
         }
         else if(copyObj is Object && "mx_internal_uid" in copyObj)
         {
            copyObj.mx_internal_uid = UIDUtil.createUID();
         }
         return copyObj;
      }
      
      protected function dragCompleteHandler(event:DragEvent) : void
      {
         var indices:Array = null;
         var n:int = 0;
         var i:int = 0;
         this.isPressed = false;
         if(event.isDefaultPrevented())
         {
            return;
         }
         if(event.action == DragManager.MOVE && this.dragMoveEnabled)
         {
            if(event.relatedObject != this)
            {
               indices = this.selectedIndices;
               this.clearSelected(false);
               indices.sort(Array.NUMERIC);
               n = int(indices.length);
               for(i = n - 1; i >= 0; i--)
               {
                  this.collectionIterator.seek(CursorBookmark.FIRST,indices[i]);
                  this.collectionIterator.remove();
               }
            }
         }
         this.lastDragEvent = null;
         this.resetDragScrolling();
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function selectionTween_updateHandler(event:TweenEvent) : void
      {
         Sprite(event.target.listener).alpha = Number(event.value);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function selectionTween_endHandler(event:TweenEvent) : void
      {
         this.selectionTween_updateHandler(event);
      }
      
      private function rendererMoveHandler(event:MoveEvent) : void
      {
         var renderer:IListItemRenderer = null;
         if(!this.rendererTrackingSuspended)
         {
            renderer = event.currentTarget as IListItemRenderer;
            this.drawItem(renderer,true);
         }
      }
      
      private function strictEqualityCompareFunction(a:Object, b:Object) : Boolean
      {
         return a === b;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getListVisibleData() : Object
      {
         return this.visibleData;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getItemUID(data:Object) : String
      {
         return this.itemToUID(data);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getItemRendererForMouseEvent(event:MouseEvent) : IListItemRenderer
      {
         return this.mouseEventToItemRenderer(event);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getListContentHolder() : ListBaseContentHolder
      {
         return this.listContent;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getRowInfo() : Array
      {
         return this.rowInfo;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function convertIndexToRow(index:int) : int
      {
         return this.indexToRow(index);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function convertIndexToColumn(index:int) : int
      {
         return this.indexToColumn(index);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getCaretIndex() : int
      {
         return this.caretIndex;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getIterator() : IViewCursor
      {
         return this.iterator;
      }
   }
}

