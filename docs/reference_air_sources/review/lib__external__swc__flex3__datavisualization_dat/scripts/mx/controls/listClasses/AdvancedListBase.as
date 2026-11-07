package mx.controls.listClasses
{
   import flash.display.DisplayObject;
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
   import mx.core.FlexSprite;
   import mx.core.IDataRenderer;
   import mx.core.IFactory;
   import mx.core.IFlexDisplayObject;
   import mx.core.IInvalidating;
   import mx.core.IUIComponent;
   import mx.core.IUITextField;
   import mx.core.ScrollControlBase;
   import mx.core.ScrollPolicy;
   import mx.core.SpriteAsset;
   import mx.effects.Effect;
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
   import mx.styles.StyleManager;
   import mx.utils.UIDUtil;
   
   [Style(name="dataChangeEffect",type="Object",inherit="no")]
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
   [Style(name="focusRoundedCorners",type="String",inherit="no")]
   [Style(name="focusAlpha",type="Number",inherit="no")]
   [Event(name="itemDoubleClick",type="mx.events.ListEvent")]
   [Event(name="itemClick",type="mx.events.ListEvent")]
   [Event(name="itemRollOut",type="mx.events.ListEvent")]
   [Event(name="itemRollOver",type="mx.events.ListEvent")]
   [Event(name="dataChange",type="mx.events.FlexEvent")]
   [Event(name="change",type="mx.events.ListEvent")]
   public class AdvancedListBase extends ScrollControlBase implements IDataRenderer, IFocusManagerComponent, IListItemRenderer, IDropInListItemRenderer, IEffectTargetHost
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static var createAccessibilityImplementation:Function;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.0.0.0";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const DRAG_THRESHOLD:int = 4;
      
      private var _labelField:String = "label";
      
      private var trackedRenderers:Array = [];
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var bSelectionChanged:Boolean = false;
      
      protected var offscreenExtraColumnsLeft:int = 0;
      
      protected var selectionTweens:Object = {};
      
      protected var caretItemRenderer:IListItemRenderer;
      
      protected var actualIterator:IViewCursor;
      
      protected var iteratorValid:Boolean = true;
      
      private var bSelectItem:Boolean = false;
      
      private var _allowMultipleSelection:Boolean = false;
      
      protected var iterator:IViewCursor;
      
      protected var rendererChanged:Boolean = false;
      
      protected var unconstrainedRenderers:Object = {};
      
      private var columnWidthChanged:Boolean = false;
      
      protected var explicitColumnCount:int = -1;
      
      private var _data:Object;
      
      private var bSelectedItemsChanged:Boolean = false;
      
      protected var defaultRowCount:int = 4;
      
      private var _rowCount:int = -1;
      
      protected var offscreenExtraRowsTop:int = 0;
      
      private var _dataTipField:String = "label";
      
      private var cachedPaddingTopInvalid:Boolean = true;
      
      protected var selectedData:Object = {};
      
      private var _labelFunction:Function;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var listType:String = "grid";
      
      private var cachedPaddingBottomInvalid:Boolean = true;
      
      protected var runningDataEffect:Boolean = false;
      
      protected var runDataEffectNextUpdate:Boolean = false;
      
      private var bShiftKey:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _selectedIndex:int = -1;
      
      private var columnCountChanged:Boolean = true;
      
      protected var rowMap:Object = {};
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var collectionIterator:IViewCursor;
      
      protected var lastDropIndex:int;
      
      private var bCtrlKey:Boolean = false;
      
      private var oldUnscaledHeight:Number;
      
      protected var explicitColumnWidth:Number;
      
      private var _dataTipFunction:Function;
      
      private var _iconFunction:Function;
      
      protected var dataItemWrappersByRenderer:Dictionary = new Dictionary(true);
      
      protected var itemsNeedMeasurement:Boolean = true;
      
      protected var offscreenExtraRowsBottom:int = 0;
      
      protected var modifiedCollectionView:ModifiedCollectionView;
      
      private var _columnCount:int = -1;
      
      private var rowCountChanged:Boolean = true;
      
      protected var wordWrapChanged:Boolean = false;
      
      protected var rowInfo:Array = [];
      
      protected var explicitRowCount:int = -1;
      
      public var offscreenExtraRows:int = 0;
      
      private var _dragEnabled:Boolean = false;
      
      protected var listItems:Array = [];
      
      private var bSortItemPending:Boolean = false;
      
      protected var caretIndicator:Sprite;
      
      protected var caretUID:String;
      
      protected var caretBookmark:CursorBookmark;
      
      private var _selectable:Boolean = true;
      
      public var allowDragSelection:Boolean = false;
      
      protected var listContent:AdvancedListBaseContentHolder;
      
      private var _showDataTips:Boolean = false;
      
      private var _variableRowHeight:Boolean = false;
      
      private var cachedVerticalAlignInvalid:Boolean = true;
      
      private var _dragMoveEnabled:Boolean = false;
      
      private var _rowHeight:Number;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _selectedItem:Object;
      
      public var menuSelectionMode:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var cachedPaddingTop:Number;
      
      private var _selectedIndices:Array;
      
      private var _columnWidth:Number;
      
      protected var defaultColumnCount:int = 4;
      
      private var oldUnscaledWidth:Number;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var bColumnScrolling:Boolean = true;
      
      protected var showCaret:Boolean;
      
      private var firstSelectionData:ListBaseSelectionData;
      
      private var mouseDownItem:IListItemRenderer;
      
      protected var collection:ICollectionView;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _lockedRowCount:int = 0;
      
      private var _iconField:String = "icon";
      
      protected var dataEffectCompleted:Boolean = false;
      
      private var bSelectedItemChanged:Boolean = false;
      
      private var _listData:BaseListData;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var bSelectOnRelease:Boolean;
      
      protected var actualCollection:ICollectionView;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var lastHighlightItemRenderer:IListItemRenderer;
      
      private var _itemRenderer:IFactory;
      
      private var itemMaskFreeList:Array;
      
      protected var keySelectionPending:Boolean = false;
      
      private var mouseDownPoint:Point;
      
      protected var selectionIndicators:Object = {};
      
      protected var highlightUID:String;
      
      private var dragScrollingInterval:int = 0;
      
      protected var anchorBookmark:CursorBookmark;
      
      protected var caretIndex:int = -1;
      
      protected var offscreenExtraColumnsRight:int = 0;
      
      private var approximate:Boolean = false;
      
      protected var anchorIndex:int = -1;
      
      protected var selectionLayer:Sprite;
      
      protected var freeItemRenderers:Array = [];
      
      protected var visibleData:Object = {};
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var bSelectedIndexChanged:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var cachedVerticalAlign:String;
      
      protected var cachedDataChangeEffect:Effect = null;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _lockedColumnCount:int = 0;
      
      private var lastHighlightItemIndices:Point;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var lastHighlightItemRendererAtIndices:IListItemRenderer;
      
      protected var lastSeekPending:ListBaseSeekPending;
      
      private var bSelectedIndicesChanged:Boolean = false;
      
      private var _dropEnabled:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var isPressed:Boolean = false;
      
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
      
      protected var itemsSizeChanged:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var cachedPaddingBottom:Number;
      
      protected var highlightIndicator:Sprite;
      
      private var verticalScrollPositionPending:Number;
      
      protected var explicitRowHeight:Number;
      
      protected var highlightItemRenderer:IListItemRenderer;
      
      private var rowHeightChanged:Boolean = false;
      
      private var _wordWrap:Boolean = false;
      
      private var horizontalScrollPositionPending:Number;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var dropIndicator:IFlexDisplayObject;
      
      private var _selectedItems:Array;
      
      private var lastKey:uint = 0;
      
      public var offscreenExtraColumns:int = 0;
      
      protected var reservedItemRenderers:Object = {};
      
      public function AdvancedListBase()
      {
         super();
         tabEnabled = true;
         addEventListener(MouseEvent.MOUSE_WHEEL,mouseWheelHandler);
         addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
         addEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
         addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
         addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
         addEventListener(MouseEvent.CLICK,mouseClickHandler);
         addEventListener(MouseEvent.DOUBLE_CLICK,mouseDoubleClickHandler);
         invalidateProperties();
      }
      
      [Inspectable(category="Data",defaultValue="")]
      [Bindable("iconFieldChanged")]
      public function get iconField() : String
      {
         return _iconField;
      }
      
      public function set iconField(value:String) : void
      {
         _iconField = value;
         itemsSizeChanged = true;
         invalidateDisplayList();
         dispatchEvent(new Event("iconFieldChanged"));
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getItemUID(data:Object) : String
      {
         return itemToUID(data);
      }
      
      public function measureWidthOfItems(index:int = -1, count:int = 0) : Number
      {
         return NaN;
      }
      
      private function terminateSelectionTracking() : void
      {
         var renderer:IListItemRenderer = null;
         for(var i:int = 0; i < trackedRenderers.length; i++)
         {
            renderer = trackedRenderers[i] as IListItemRenderer;
            renderer.removeEventListener(MoveEvent.MOVE,rendererMoveHandler);
         }
         trackedRenderers = [];
      }
      
      public function get columnWidth() : Number
      {
         return _columnWidth;
      }
      
      protected function clearSelected(transition:Boolean = false) : void
      {
         var uniqueID:String = null;
         var data:Object = null;
         var item:IListItemRenderer = null;
         for(uniqueID in selectedData)
         {
            data = selectedData[uniqueID].data;
            removeSelectionData(uniqueID);
            item = visibleData[itemToUID(data)];
            if(Boolean(item))
            {
               drawItem(item,false,uniqueID == highlightUID,false,transition);
            }
         }
         clearSelectionData();
         _selectedIndex = -1;
         _selectedItem = null;
         caretIndex = -1;
         anchorIndex = -1;
         caretBookmark = null;
         anchorBookmark = null;
      }
      
      [Inspectable(category="Data",defaultValue="false")]
      [Bindable("showDataTipsChanged")]
      public function get showDataTips() : Boolean
      {
         return _showDataTips;
      }
      
      public function set columnWidth(value:Number) : void
      {
         explicitColumnWidth = value;
         if(_columnWidth != value)
         {
            setColumnWidth(value);
            invalidateSize();
            itemsSizeChanged = true;
            invalidateDisplayList();
            dispatchEvent(new Event("columnWidthChanged"));
         }
      }
      
      protected function scrollHorizontally(pos:int, deltaPos:int, scrollUp:Boolean) : void
      {
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
      
      [Bindable("viewChanged")]
      [Bindable("scroll")]
      override public function get verticalScrollPosition() : Number
      {
         if(!isNaN(verticalScrollPositionPending))
         {
            return verticalScrollPositionPending;
         }
         return super.verticalScrollPosition;
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
      
      private function makeAdditionalRows(rowIndex:int) : void
      {
         var curY:Number;
         var cursorPos:CursorBookmark = null;
         if(Boolean(iterator))
         {
            cursorPos = iterator.bookmark;
            try
            {
               iterator.seek(CursorBookmark.CURRENT,listItems.length - lockedRowCount);
            }
            catch(e:ItemPendingError)
            {
               lastSeekPending = new ListBaseSeekPending(CursorBookmark.CURRENT,listItems.length - lockedRowCount);
               e.addResponder(new ItemResponder(seekPendingResultHandler,seekPendingFailureHandler,lastSeekPending));
               iteratorValid = false;
            }
         }
         curY = rowInfo[rowIndex].y + rowInfo[rowIndex].height;
         makeRowsAndColumns(0,curY,listContent.width,listContent.height,0,rowIndex + 1);
         seekPositionIgnoreError(iterator,cursorPos);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function addSelectionData(uid:String, selectionData:ListBaseSelectionData) : void
      {
         if(firstSelectionData != null)
         {
            firstSelectionData.prevSelectionData = selectionData;
         }
         selectionData.nextSelectionData = firstSelectionData;
         firstSelectionData = selectionData;
         selectedData[uid] = selectionData;
      }
      
      public function set showDataTips(value:Boolean) : void
      {
         _showDataTips = value;
         itemsSizeChanged = true;
         invalidateDisplayList();
         dispatchEvent(new Event("showDataTipsChanged"));
      }
      
      protected function seekPendingFailureHandler(data:Object, info:ListBaseSeekPending) : void
      {
      }
      
      protected function moveIndicatorsHorizontally(uid:String, moveBlockDistance:Number) : void
      {
         if(Boolean(uid))
         {
            if(Boolean(selectionIndicators[uid]))
            {
               selectionIndicators[uid].x += moveBlockDistance;
            }
            if(highlightUID == uid)
            {
               highlightIndicator.x += moveBlockDistance;
            }
            if(caretUID == uid)
            {
               caretIndicator.x += moveBlockDistance;
            }
         }
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
         return iteratorValid;
      }
      
      public function measureHeightOfItems(index:int = -1, count:int = 0) : Number
      {
         return NaN;
      }
      
      [Inspectable(environment="none")]
      [Bindable("valueCommit")]
      [Bindable("change")]
      public function get selectedItem() : Object
      {
         return _selectedItem;
      }
      
      protected function mouseMoveHandler(event:MouseEvent) : void
      {
         var dragEvent:DragEvent = null;
         var rowData:BaseListData = null;
         if(!enabled || !selectable)
         {
            return;
         }
         var pt:Point = new Point(event.localX,event.localY);
         pt = DisplayObject(event.target).localToGlobal(pt);
         pt = globalToLocal(pt);
         if(Boolean(isPressed) && Boolean(mouseDownPoint) && (Math.abs(mouseDownPoint.x - pt.x) > DRAG_THRESHOLD || Math.abs(mouseDownPoint.y - pt.y) > DRAG_THRESHOLD))
         {
            if(dragEnabled && !DragManager.isDragging && Boolean(mouseDownPoint))
            {
               dragEvent = new DragEvent(DragEvent.DRAG_START);
               dragEvent.dragInitiator = this;
               dragEvent.localX = mouseDownPoint.x;
               dragEvent.localY = mouseDownPoint.y;
               dragEvent.buttonDown = true;
               dragStartHandler(dragEvent);
            }
         }
         var item:IListItemRenderer = mouseEventToItemRenderer(event);
         if(Boolean(item) && Boolean(highlightItemRenderer))
         {
            rowData = rowMap[item.name];
            if(Boolean(highlightItemRenderer) && Boolean(highlightUID) && rowData.uid != highlightUID)
            {
               if(!isPressed)
               {
                  if(Boolean(getStyle("useRollOver")) && highlightItemRenderer.data != null)
                  {
                     clearHighlight(highlightItemRenderer);
                  }
               }
            }
         }
         else if(!item && Boolean(highlightItemRenderer))
         {
            if(!isPressed)
            {
               if(Boolean(getStyle("useRollOver")) && Boolean(highlightItemRenderer.data))
               {
                  clearHighlight(highlightItemRenderer);
               }
            }
         }
         if(Boolean(item) && !highlightItemRenderer)
         {
            mouseOverHandler(event);
         }
      }
      
      [Inspectable(defaultValue="true")]
      public function get selectable() : Boolean
      {
         return _selectable;
      }
      
      override public function set verticalScrollPosition(value:Number) : void
      {
         var deltaPos:int = 0;
         var direction:Boolean = false;
         if(listItems.length == 0 || !dataProvider || !isNaN(verticalScrollPositionPending))
         {
            verticalScrollPositionPending = value;
            if(Boolean(dataProvider))
            {
               invalidateDisplayList();
            }
            return;
         }
         verticalScrollPositionPending = NaN;
         var oldValue:int = super.verticalScrollPosition;
         super.verticalScrollPosition = value;
         removeClipMask();
         var oldoffscreenExtraRowsTop:int = offscreenExtraRowsTop;
         var oldoffscreenExtraRowsBottom:int = offscreenExtraRowsBottom;
         if(oldValue != value)
         {
            deltaPos = value - oldValue;
            direction = deltaPos > 0;
            deltaPos = Math.abs(deltaPos);
            if(deltaPos >= rowInfo.length - lockedRowCount || !iteratorValid)
            {
               clearIndicators();
               visibleData = {};
               makeRowsAndColumnsWithExtraRows(oldUnscaledWidth,oldUnscaledHeight);
            }
            else
            {
               scrollVertically(value,deltaPos,direction);
               adjustListContent(oldUnscaledWidth,oldUnscaledHeight);
            }
            if(variableRowHeight)
            {
               configureScrollBars();
            }
            drawRowBackgrounds();
         }
         addClipMask(offscreenExtraRowsTop != oldoffscreenExtraRowsTop || offscreenExtraRowsBottom != oldoffscreenExtraRowsBottom);
      }
      
      override public function get horizontalScrollPosition() : Number
      {
         if(!isNaN(horizontalScrollPositionPending))
         {
            return horizontalScrollPositionPending;
         }
         return super.horizontalScrollPosition;
      }
      
      protected function itemRendererToIndices(item:IListItemRenderer) : Point
      {
         if(!item || !(item.name in rowMap))
         {
            return null;
         }
         var index:int = int(rowMap[item.name].rowIndex);
         var len:int = int(listItems[index].length);
         for(var i:int = 0; i < len; i++)
         {
            if(listItems[index][i] == item)
            {
               break;
            }
         }
         return new Point(i < lockedColumnCount ? i : i + horizontalScrollPosition,index < lockedRowCount ? index : index + verticalScrollPosition + offscreenExtraRowsTop);
      }
      
      private function reduceRows(rowIndex:int) : void
      {
         var colLen:int = 0;
         var j:int = 0;
         var uid:String = null;
         while(rowIndex >= 0)
         {
            if(rowInfo[rowIndex].y < listContent.height)
            {
               break;
            }
            colLen = int(listItems[rowIndex].length);
            for(j = 0; j < colLen; j++)
            {
               addToFreeItemRenderers(listItems[rowIndex][j]);
            }
            uid = rowInfo[rowIndex].uid;
            delete visibleData[uid];
            removeIndicators(uid);
            listItems.pop();
            rowInfo.pop();
            rowIndex--;
         }
      }
      
      [Inspectable(defaultValue="false")]
      public function get dragMoveEnabled() : Boolean
      {
         return _dragMoveEnabled;
      }
      
      protected function moveIndicatorsVertically(uid:String, moveBlockDistance:Number) : void
      {
         if(Boolean(uid))
         {
            if(Boolean(selectionIndicators[uid]))
            {
               selectionIndicators[uid].y += moveBlockDistance;
            }
            if(highlightUID == uid)
            {
               highlightIndicator.y += moveBlockDistance;
            }
            if(caretUID == uid)
            {
               caretIndicator.y += moveBlockDistance;
            }
         }
      }
      
      override protected function keyDownHandler(event:KeyboardEvent) : void
      {
         var li:IListItemRenderer = null;
         var pt:Point = null;
         var evt:ListEvent = null;
         if(!selectable)
         {
            return;
         }
         if(!iteratorValid)
         {
            return;
         }
         if(!collection)
         {
            return;
         }
         switch(event.keyCode)
         {
            case Keyboard.UP:
            case Keyboard.DOWN:
               moveSelectionVertically(event.keyCode,event.shiftKey,event.ctrlKey);
               event.stopPropagation();
               break;
            case Keyboard.LEFT:
            case Keyboard.RIGHT:
               moveSelectionHorizontally(event.keyCode,event.shiftKey,event.ctrlKey);
               event.stopPropagation();
               break;
            case Keyboard.END:
            case Keyboard.HOME:
            case Keyboard.PAGE_UP:
            case Keyboard.PAGE_DOWN:
               moveSelectionVertically(event.keyCode,event.shiftKey,event.ctrlKey);
               event.stopPropagation();
               break;
            case Keyboard.SPACE:
               if(caretIndex != -1 && caretIndex - verticalScrollPosition + lockedRowCount >= 0 && caretIndex - verticalScrollPosition + lockedRowCount < listItems.length)
               {
                  li = listItems[caretIndex - verticalScrollPosition + lockedRowCount][0];
                  if(selectItem(li,event.shiftKey,event.ctrlKey))
                  {
                     pt = itemRendererToIndices(li);
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
               if(findKey(event.keyCode))
               {
                  event.stopPropagation();
               }
         }
      }
      
      protected function copySelectedItems(useDataField:Boolean = true) : Array
      {
         var tmp:Array = [];
         var curSelectionData:ListBaseSelectionData = firstSelectionData;
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
      
      public function invalidateList() : void
      {
         itemsSizeChanged = true;
         invalidateDisplayList();
      }
      
      [Inspectable(defaultValue="0")]
      public function get lockedRowCount() : int
      {
         return _lockedRowCount;
      }
      
      protected function itemToUID(data:Object) : String
      {
         if(data == null)
         {
            return "null";
         }
         return UIDUtil.getUID(data);
      }
      
      public function indexToItemRenderer(index:int) : IListItemRenderer
      {
         var firstItemIndex:int = verticalScrollPosition - offscreenExtraRowsTop;
         if(index < firstItemIndex || index >= firstItemIndex + listItems.length)
         {
            return null;
         }
         return listItems[index - firstItemIndex][0];
      }
      
      protected function get dragImage() : IUIComponent
      {
         var image:ListItemDragProxy = new ListItemDragProxy();
         image.owner = this;
         image.moduleFactory = moduleFactory;
         return image;
      }
      
      [Inspectable(category="General")]
      [Bindable("valueCommit")]
      [Bindable("change")]
      public function get selectedIndices() : Array
      {
         if(bSelectedIndicesChanged)
         {
            return _selectedIndices;
         }
         return copySelectedItems(false);
      }
      
      [Inspectable(category="General")]
      public function get variableRowHeight() : Boolean
      {
         return _variableRowHeight;
      }
      
      protected function mouseDoubleClickHandler(event:MouseEvent) : void
      {
         var item:IListItemRenderer = null;
         var pt:Point = null;
         var listEvent:ListEvent = null;
         item = mouseEventToItemRenderer(event);
         if(!item)
         {
            return;
         }
         pt = itemRendererToIndices(item);
         if(Boolean(pt))
         {
            listEvent = new ListEvent(ListEvent.ITEM_DOUBLE_CLICK);
            listEvent.columnIndex = pt.x;
            listEvent.rowIndex = pt.y;
            listEvent.itemRenderer = item;
            dispatchEvent(listEvent);
         }
      }
      
      private function selectionDataPendingResultHandler(data:Object, info:ListBaseSelectionDataPending) : void
      {
         if(Boolean(info.bookmark))
         {
            iterator.seek(info.bookmark,info.offset);
         }
         setSelectionDataLoop(info.items,info.index,info.useFind);
      }
      
      public function set selectedItem(data:Object) : void
      {
         if(!collection || collection.length == 0)
         {
            _selectedItem = data;
            bSelectedItemChanged = true;
            bSelectionChanged = true;
            invalidateDisplayList();
            return;
         }
         commitSelectedItem(data);
      }
      
      private function adjustScrollPosition() : void
      {
         var hPos:Number = NaN;
         var vPos:Number = NaN;
         if(!isNaN(horizontalScrollPositionPending))
         {
            hPos = Math.min(horizontalScrollPositionPending,maxHorizontalScrollPosition);
            horizontalScrollPositionPending = NaN;
            super.horizontalScrollPosition = hPos;
         }
         if(!isNaN(verticalScrollPositionPending))
         {
            vPos = Math.min(verticalScrollPositionPending,maxVerticalScrollPosition);
            verticalScrollPositionPending = NaN;
            super.verticalScrollPosition = vPos;
         }
      }
      
      protected function indexToColumn(index:int) : int
      {
         return 0;
      }
      
      protected function dragEnterHandler(event:DragEvent) : void
      {
         if(event.isDefaultPrevented())
         {
            return;
         }
         if(event.dragSource.hasFormat("items"))
         {
            DragManager.acceptDragDrop(this);
            DragManager.showFeedback(event.ctrlKey ? DragManager.COPY : DragManager.MOVE);
            showDropFeedback(event);
            return;
         }
         hideDropFeedback(event);
         DragManager.showFeedback(DragManager.NONE);
      }
      
      public function set selectable(value:Boolean) : void
      {
         _selectable = value;
      }
      
      private function moveRowVertically(i:int, numCols:int, moveBlockDistance:Number) : void
      {
         var r:IListItemRenderer = null;
         for(var j:int = 0; j < numCols; j++)
         {
            r = listItems[i][j];
            r.move(r.x,r.y + moveBlockDistance);
         }
         rowInfo[i].y += moveBlockDistance;
      }
      
      override public function set horizontalScrollPosition(value:Number) : void
      {
         var deltaPos:int = 0;
         var direction:Boolean = false;
         if(listItems.length == 0 || !dataProvider || !isNaN(horizontalScrollPositionPending))
         {
            horizontalScrollPositionPending = value;
            if(Boolean(dataProvider))
            {
               invalidateDisplayList();
            }
            return;
         }
         horizontalScrollPositionPending = NaN;
         var oldValue:int = super.horizontalScrollPosition;
         super.horizontalScrollPosition = value;
         removeClipMask();
         if(oldValue != value)
         {
            if(itemsSizeChanged)
            {
               return;
            }
            deltaPos = value - oldValue;
            direction = deltaPos > 0;
            deltaPos = Math.abs(deltaPos);
            if(bColumnScrolling && deltaPos >= columnCount - lockedColumnCount)
            {
               clearIndicators();
               visibleData = {};
               makeRowsAndColumnsWithExtraColumns(oldUnscaledWidth,oldUnscaledHeight);
               drawRowBackgrounds();
            }
            else
            {
               scrollHorizontally(value,deltaPos,direction);
            }
         }
         addClipMask(false);
      }
      
      public function set dragMoveEnabled(value:Boolean) : void
      {
         _dragMoveEnabled = value;
      }
      
      public function isItemHighlighted(data:Object) : Boolean
      {
         if(data == null)
         {
            return false;
         }
         var isSelected:Boolean = Boolean(highlightIndicator) && highlightIndicator.parent.getChildIndex(highlightIndicator) != selectionLayer.numChildren - 1;
         if(data is String)
         {
            return data == highlightUID && !isSelected;
         }
         return itemToUID(data) == highlightUID && !isSelected;
      }
      
      override protected function mouseWheelHandler(event:MouseEvent) : void
      {
         var oldPosition:Number = NaN;
         var newPos:int = 0;
         var scrollEvent:ScrollEvent = null;
         if(Boolean(verticalScrollBar) && Boolean(verticalScrollBar.visible))
         {
            event.stopPropagation();
            oldPosition = verticalScrollPosition;
            newPos = verticalScrollPosition;
            newPos -= event.delta * verticalScrollBar.lineScrollSize;
            newPos = Math.max(0,Math.min(newPos,verticalScrollBar.maxScrollPosition));
            verticalScrollPosition = newPos;
            if(oldPosition != verticalScrollPosition)
            {
               scrollEvent = new ScrollEvent(ScrollEvent.SCROLL);
               scrollEvent.direction = ScrollEventDirection.VERTICAL;
               scrollEvent.position = verticalScrollPosition;
               scrollEvent.delta = verticalScrollPosition - oldPosition;
               dispatchEvent(scrollEvent);
            }
         }
      }
      
      public function set labelField(value:String) : void
      {
         _labelField = value;
         itemsSizeChanged = true;
         invalidateDisplayList();
         dispatchEvent(new Event("labelFieldChanged"));
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
      
      protected function finishDataChangeEffect(event:EffectEvent) : void
      {
         var item:Object = null;
         var index:int = 0;
         collection = actualCollection;
         actualCollection = null;
         modifiedCollectionView = null;
         iterator = actualIterator;
         runningDataEffect = false;
         unconstrainedRenderers = {};
         terminateSelectionTracking();
         var newVisibleData:Object = {};
         for each(item in visibleData)
         {
            if(Boolean(item.data))
            {
               newVisibleData[itemToUID(item.data)] = item;
            }
         }
         visibleData = newVisibleData;
         index = scrollPositionToIndex(horizontalScrollPosition - offscreenExtraColumnsLeft,verticalScrollPosition - offscreenExtraRowsTop);
         iterator.seek(CursorBookmark.FIRST,index);
         callLater(cleanupAfterDataChangeEffect);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function clearHighlight(item:IListItemRenderer) : void
      {
         var listEvent:ListEvent = null;
         var uid:String = itemToUID(item.data);
         drawItem(visibleData[uid],isItemSelected(item.data),false,uid == caretUID);
         var pt:Point = itemRendererToIndices(item);
         if(Boolean(pt) && Boolean(lastHighlightItemIndices))
         {
            listEvent = new ListEvent(ListEvent.ITEM_ROLL_OUT);
            listEvent.columnIndex = lastHighlightItemIndices.x;
            listEvent.rowIndex = lastHighlightItemIndices.y;
            listEvent.itemRenderer = lastHighlightItemRendererAtIndices;
            dispatchEvent(listEvent);
            lastHighlightItemIndices = null;
         }
      }
      
      public function set wordWrap(value:Boolean) : void
      {
         if(value == _wordWrap)
         {
            return;
         }
         _wordWrap = value;
         wordWrapChanged = true;
         itemsSizeChanged = true;
         invalidateDisplayList();
         dispatchEvent(new Event("wordWrapChanged"));
      }
      
      private function shiftSelectionLoop(incr:Boolean, index:int, stopData:Object, transition:Boolean, placeHolder:CursorBookmark) : void
      {
         var data:Object = null;
         var uid:String = null;
         iterator.seek(CursorBookmark.FIRST,anchorIndex);
         try
         {
            do
            {
               data = iterator.current;
               uid = itemToUID(data);
               addSelectionData(uid,new ListBaseSelectionData(data,index,approximate));
               if(Boolean(visibleData[uid]))
               {
                  drawItem(visibleData[uid],true,uid == highlightUID,false,transition);
               }
               if(data === stopData)
               {
                  if(Boolean(visibleData[uid]))
                  {
                     drawItem(visibleData[uid],true,uid == highlightUID,true,transition);
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
            while(incr ? Boolean(iterator.moveNext()) : Boolean(iterator.movePrevious()));
         }
         catch(e:ItemPendingError)
         {
            e.addResponder(new ItemResponder(selectionPendingResultHandler,selectionPendingFailureHandler,new ListBaseSelectionPending(incr,index,stopData,transition,placeHolder,CursorBookmark.CURRENT,0)));
            iteratorValid = false;
         }
         try
         {
            iterator.seek(placeHolder,0);
            iteratorValid = true;
         }
         catch(e2:ItemPendingError)
         {
            lastSeekPending = new ListBaseSeekPending(placeHolder,0);
            e2.addResponder(new ItemResponder(seekPendingResultHandler,seekPendingFailureHandler,lastSeekPending));
         }
      }
      
      protected function applySelectionEffect(indicator:Sprite, uid:String, itemRenderer:IListItemRenderer) : void
      {
         var selectionEasingFunction:Function = null;
         var selectionDuration:Number = Number(getStyle("selectionDuration"));
         if(selectionDuration != 0)
         {
            indicator.alpha = 0;
            selectionTweens[uid] = new Tween(indicator,0,1,selectionDuration,5);
            selectionTweens[uid].addEventListener(TweenEvent.TWEEN_UPDATE,selectionTween_updateHandler);
            selectionTweens[uid].addEventListener(TweenEvent.TWEEN_END,selectionTween_endHandler);
            selectionTweens[uid].setTweenHandlers(onSelectionTweenUpdate,onSelectionTweenUpdate);
            selectionEasingFunction = getStyle("selectionEasingFunction") as Function;
            if(selectionEasingFunction != null)
            {
               selectionTweens[uid].easingFunction = selectionEasingFunction;
            }
         }
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
            itmStr = itemToLabel(iterator.current);
            itmStr = itmStr.substring(0,str.length);
            if(str == itmStr || str.toUpperCase() == itmStr.toUpperCase())
            {
               iterator.seek(cursorPos,0);
               scrollToIndex(i);
               commitSelectedIndex(i);
               item = indexToItemRenderer(i);
               pt = itemRendererToIndices(item);
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
            more = Boolean(iterator.moveNext());
            if(!more && stopIndex != collection.length)
            {
               i = -1;
               iterator.seek(CursorBookmark.FIRST,0);
            }
            i++;
         }
         iterator.seek(cursorPos,0);
         iteratorValid = true;
         return false;
      }
      
      [Inspectable(category="Data")]
      public function get itemRenderer() : IFactory
      {
         return _itemRenderer;
      }
      
      protected function seekPositionSafely(index:int) : Boolean
      {
         try
         {
            iterator.seek(CursorBookmark.FIRST,index);
         }
         catch(e:ItemPendingError)
         {
            lastSeekPending = new ListBaseSeekPending(CursorBookmark.FIRST,index);
            e.addResponder(new ItemResponder(seekPendingResultHandler,seekPendingFailureHandler,lastSeekPending));
            iteratorValid = false;
         }
         return iteratorValid;
      }
      
      public function set lockedRowCount(value:int) : void
      {
         _lockedRowCount = value;
         invalidateDisplayList();
      }
      
      override public function set showInAutomationHierarchy(value:Boolean) : void
      {
      }
      
      public function itemToItemRenderer(item:Object) : IListItemRenderer
      {
         return visibleData[itemToUID(item)];
      }
      
      protected function updateList() : void
      {
         removeClipMask();
         var cursorPos:CursorBookmark = Boolean(iterator) ? iterator.bookmark : null;
         clearIndicators();
         visibleData = {};
         makeRowsAndColumns(0,0,listContent.width,listContent.height,0,0);
         if(Boolean(iterator))
         {
            iterator.seek(cursorPos,0);
         }
         drawRowBackgrounds();
         configureScrollBars();
         addClipMask(true);
      }
      
      public function set variableRowHeight(value:Boolean) : void
      {
         _variableRowHeight = value;
         itemsSizeChanged = true;
         invalidateDisplayList();
         dispatchEvent(new Event("variableRowHeightChanged"));
      }
      
      protected function isRendererUnconstrained(item:Object) : Boolean
      {
         return unconstrainedRenderers[item] != null;
      }
      
      public function set selectedIndices(indices:Array) : void
      {
         if(!collection || collection.length == 0)
         {
            _selectedIndices = indices;
            bSelectedIndicesChanged = true;
            bSelectionChanged = true;
            invalidateDisplayList();
            return;
         }
         commitSelectedIndices(indices);
      }
      
      protected function mouseUpHandler(event:MouseEvent) : void
      {
         var evt:ListEvent = null;
         mouseDownPoint = null;
         var item:IListItemRenderer = mouseEventToItemRenderer(event);
         var pt:Point = itemRendererToIndices(item);
         mouseIsUp();
         if(!enabled || !selectable)
         {
            return;
         }
         if(Boolean(mouseDownItem))
         {
            evt = new ListEvent(ListEvent.CHANGE);
            evt.itemRenderer = mouseDownItem;
            pt = itemRendererToIndices(mouseDownItem);
            if(Boolean(pt))
            {
               evt.columnIndex = pt.x;
               evt.rowIndex = pt.y;
            }
            dispatchEvent(evt);
            mouseDownItem = null;
         }
         if(!item || !hitTestPoint(event.stageX,event.stageY))
         {
            isPressed = false;
            return;
         }
         if(bSelectOnRelease)
         {
            bSelectOnRelease = false;
            if(selectItem(item,event.shiftKey,event.ctrlKey))
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
         isPressed = false;
      }
      
      [Inspectable(category="General",enumeration="false,true",defaultValue="false")]
      public function get allowMultipleSelection() : Boolean
      {
         return _allowMultipleSelection;
      }
      
      public function isItemSelected(data:Object) : Boolean
      {
         if(data == null)
         {
            return false;
         }
         if(data is String)
         {
            return selectedData[data] != undefined;
         }
         return selectedData[itemToUID(data)] != undefined;
      }
      
      protected function dragScroll() : void
      {
         var scrollInterval:Number = NaN;
         var oldPosition:Number = NaN;
         var d:Number = NaN;
         var scrollEvent:ScrollEvent = null;
         var slop:Number = 0;
         if(dragScrollingInterval == 0)
         {
            return;
         }
         var minScrollInterval:Number = 30;
         if(DragManager.isDragging)
         {
            slop = viewMetrics.top + (variableRowHeight ? getStyle("fontSize") / 4 : rowHeight);
         }
         clearInterval(dragScrollingInterval);
         if(mouseY < slop)
         {
            oldPosition = verticalScrollPosition;
            verticalScrollPosition = Math.max(0,oldPosition - 1);
            if(DragManager.isDragging)
            {
               scrollInterval = 100;
            }
            else
            {
               d = Math.min(0 - mouseY - 30,0);
               scrollInterval = 0.593 * d * d + 1 + minScrollInterval;
            }
            dragScrollingInterval = setInterval(dragScroll,scrollInterval);
            if(oldPosition != verticalScrollPosition)
            {
               scrollEvent = new ScrollEvent(ScrollEvent.SCROLL);
               scrollEvent.detail = ScrollEventDetail.THUMB_POSITION;
               scrollEvent.direction = ScrollEventDirection.VERTICAL;
               scrollEvent.position = verticalScrollPosition;
               scrollEvent.delta = verticalScrollPosition - oldPosition;
               dispatchEvent(scrollEvent);
            }
         }
         else if(mouseY > unscaledHeight - slop)
         {
            oldPosition = verticalScrollPosition;
            verticalScrollPosition = Math.min(maxVerticalScrollPosition,verticalScrollPosition + 1);
            if(DragManager.isDragging)
            {
               scrollInterval = 100;
            }
            else
            {
               d = Math.min(mouseY - unscaledHeight - 30,0);
               scrollInterval = 0.593 * d * d + 1 + minScrollInterval;
            }
            dragScrollingInterval = setInterval(dragScroll,scrollInterval);
            if(oldPosition != verticalScrollPosition)
            {
               scrollEvent = new ScrollEvent(ScrollEvent.SCROLL);
               scrollEvent.detail = ScrollEventDetail.THUMB_POSITION;
               scrollEvent.direction = ScrollEventDirection.VERTICAL;
               scrollEvent.position = verticalScrollPosition;
               scrollEvent.delta = verticalScrollPosition - oldPosition;
               dispatchEvent(scrollEvent);
            }
         }
         else
         {
            dragScrollingInterval = setInterval(dragScroll,15);
         }
      }
      
      protected function moveSelectionHorizontally(code:uint, shiftKey:Boolean, ctrlKey:Boolean) : void
      {
      }
      
      protected function drawRowBackgrounds() : void
      {
      }
      
      private function selectionIndicesPendingResultHandler(data:Object, info:ListBaseSelectionDataPending) : void
      {
         if(Boolean(info.bookmark))
         {
            iterator.seek(info.bookmark,info.offset);
         }
         setSelectionIndicesLoop(info.index,info.items,info.useFind);
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
      
      public function removeDataEffectItem(item:Object) : void
      {
         if(Boolean(modifiedCollectionView))
         {
            modifiedCollectionView.removeItem(dataItemWrappersByRenderer[item]);
         }
         iterator.seek(CursorBookmark.CURRENT);
         if(invalidateDisplayListFlag)
         {
            itemsSizeChanged = true;
            validateDisplayList();
         }
         else
         {
            invalidateList();
         }
      }
      
      override public function set horizontalScrollPolicy(value:String) : void
      {
         super.horizontalScrollPolicy = value;
         itemsSizeChanged = true;
         invalidateDisplayList();
      }
      
      public function itemRendererToIndex(itemRenderer:IListItemRenderer) : int
      {
         var index:int = 0;
         if(itemRenderer.name in rowMap)
         {
            index = int(rowMap[itemRenderer.name].rowIndex);
            return index < lockedRowCount ? index : int(index + verticalScrollPosition);
         }
         return int.MIN_VALUE;
      }
      
      [Inspectable(defaultValue="false")]
      public function get dropEnabled() : Boolean
      {
         return _dropEnabled;
      }
      
      private function setSelectionIndicesLoop(index:int, indices:Array, firstTime:Boolean = false) : void
      {
         var data:Object = null;
         while(Boolean(indices.length))
         {
            if(index != indices[0])
            {
               try
               {
                  collectionIterator.seek(CursorBookmark.CURRENT,indices[0] - index);
               }
               catch(e:ItemPendingError)
               {
                  e.addResponder(new ItemResponder(selectionIndicesPendingResultHandler,selectionIndicesPendingFailureHandler,new ListBaseSelectionDataPending(firstTime,index,indices,CursorBookmark.CURRENT,indices[0] - index)));
                  return;
               }
            }
            index = int(indices[0]);
            indices.shift();
            data = collectionIterator.current;
            if(firstTime)
            {
               _selectedIndex = index;
               _selectedItem = data;
               firstTime = false;
            }
            addSelectionData(itemToUID(data),new ListBaseSelectionData(data,index,false));
         }
         if(initialized)
         {
            updateList();
         }
         dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
      }
      
      override protected function measure() : void
      {
         super.measure();
         var o:EdgeMetrics = viewMetrics;
         var cc:int = explicitColumnCount < 1 ? defaultColumnCount : explicitColumnCount;
         var rc:int = explicitRowCount < 1 ? defaultRowCount : explicitRowCount;
         if(!isNaN(explicitRowHeight))
         {
            measuredHeight = explicitRowHeight * rc + o.top + o.bottom;
            measuredMinHeight = explicitRowHeight * Math.min(rc,2) + o.top + o.bottom;
         }
         else
         {
            measuredHeight = rowHeight * rc + o.top + o.bottom;
            measuredMinHeight = rowHeight * Math.min(rc,2) + o.top + o.bottom;
         }
         if(!isNaN(explicitColumnWidth))
         {
            measuredWidth = explicitColumnWidth * cc + o.left + o.right;
            measuredMinWidth = explicitColumnWidth * Math.min(cc,1) + o.left + o.right;
         }
         else
         {
            measuredWidth = columnWidth * cc + o.left + o.right;
            measuredMinWidth = columnWidth * Math.min(cc,1) + o.left + o.right;
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
      
      protected function setRowHeight(v:Number) : void
      {
         _rowHeight = v;
      }
      
      [Inspectable(environment="none")]
      [Bindable("dataChange")]
      public function get listData() : BaseListData
      {
         return _listData;
      }
      
      private function removeSelectionData(uid:String) : void
      {
         var curSelectionData:ListBaseSelectionData = selectedData[uid];
         if(firstSelectionData == curSelectionData)
         {
            firstSelectionData = curSelectionData.nextSelectionData;
         }
         if(curSelectionData.prevSelectionData != null)
         {
            curSelectionData.prevSelectionData.nextSelectionData = curSelectionData.nextSelectionData;
         }
         if(curSelectionData.nextSelectionData != null)
         {
            curSelectionData.nextSelectionData.prevSelectionData = curSelectionData.prevSelectionData;
         }
         delete selectedData[uid];
      }
      
      public function indicesToIndex(rowIndex:int, colIndex:int) : int
      {
         return rowIndex * columnCount + colIndex;
      }
      
      [Bindable("valueCommit")]
      [Bindable("change")]
      public function get value() : Object
      {
         var item:Object = selectedItem;
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
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getRowInfo() : Array
      {
         return rowInfo;
      }
      
      private function rendererMoveHandler(event:MoveEvent) : void
      {
         var renderer:IListItemRenderer = null;
         renderer = event.currentTarget as IListItemRenderer;
         drawItem(renderer,true);
      }
      
      protected function calculateDropIndicatorY(rowCount:Number, rowNum:int) : Number
      {
         var i:int = 0;
         var yy:Number = 0;
         if(Boolean(rowCount) && Boolean(listItems[rowNum].length) && Boolean(listItems[rowNum][0]))
         {
            return listItems[rowNum][0].y - 1;
         }
         for(i = 0; i < rowCount; i++)
         {
            if(!Boolean(listItems[i].length))
            {
               break;
            }
            yy += rowInfo[i].height;
         }
         return yy;
      }
      
      override public function validateDisplayList() : void
      {
         var sm:ISystemManager = null;
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
            if(runDataEffectNextUpdate)
            {
               runDataEffectNextUpdate = false;
               runningDataEffect = true;
               initiateDataChangeEffect(scaleX == 0 ? 0 : width / scaleX,scaleY == 0 ? 0 : height / scaleY);
            }
            else
            {
               updateDisplayList(scaleX == 0 ? 0 : width / scaleX,scaleY == 0 ? 0 : height / scaleY);
            }
            invalidateDisplayListFlag = false;
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getListVisibleData() : Object
      {
         return visibleData;
      }
      
      public function getRendererSemanticValue(target:Object, semanticProperty:String) : Object
      {
         return modifiedCollectionView.getSemantics(dataItemWrappersByRenderer[target]) == semanticProperty;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setColumnCount(value:int) : void
      {
         _columnCount = value;
      }
      
      private function hasOnlyTextRenderers() : Boolean
      {
         if(listItems.length == 0)
         {
            return true;
         }
         var rowItems:Array = listItems[listItems.length - 1];
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
      
      private function sumRowHeights(startRowIdx:int, endRowIdx:int) : Number
      {
         var sum:Number = 0;
         for(var i:int = startRowIdx; i <= endRowIdx; i++)
         {
            sum += rowInfo[i].height;
         }
         return sum;
      }
      
      private function selectionPendingFailureHandler(data:Object, info:ListBaseSelectionPending) : void
      {
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function convertIndexToColumn(index:int) : int
      {
         return indexToColumn(index);
      }
      
      private function createItemMask(x:Number, y:Number, width:Number, height:Number) : DisplayObject
      {
         var mask:Shape = null;
         var g:Graphics = null;
         if(!itemMaskFreeList)
         {
            itemMaskFreeList = [];
         }
         if(itemMaskFreeList.length > 0)
         {
            mask = itemMaskFreeList.pop();
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
            listContent.addChild(mask);
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
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function convertIndexToRow(index:int) : int
      {
         return indexToRow(index);
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(cachedPaddingTopInvalid)
         {
            cachedPaddingTopInvalid = false;
            cachedPaddingTop = getStyle("paddingTop");
            itemsSizeChanged = true;
            invalidateDisplayList();
         }
         if(cachedPaddingBottomInvalid)
         {
            cachedPaddingBottomInvalid = false;
            cachedPaddingBottom = getStyle("paddingBottom");
            itemsSizeChanged = true;
            invalidateDisplayList();
         }
         if(cachedVerticalAlignInvalid)
         {
            cachedVerticalAlignInvalid = false;
            cachedVerticalAlign = getStyle("verticalAlign");
            itemsSizeChanged = true;
            invalidateDisplayList();
         }
         if(columnCountChanged)
         {
            if(_columnCount < 1)
            {
               _columnCount = defaultColumnCount;
            }
            if(!isNaN(explicitWidth) && isNaN(explicitColumnWidth) && explicitColumnCount > 0)
            {
               setColumnWidth((explicitWidth - viewMetrics.left - viewMetrics.right) / columnCount);
            }
            columnCountChanged = false;
         }
         if(rowCountChanged)
         {
            if(_rowCount < 1)
            {
               _rowCount = defaultRowCount;
            }
            if(!isNaN(explicitHeight) && isNaN(explicitRowHeight) && explicitRowCount > 0)
            {
               setRowHeight((explicitHeight - viewMetrics.top - viewMetrics.bottom) / rowCount);
            }
            rowCountChanged = false;
         }
      }
      
      protected function setRowCount(v:int) : void
      {
         _rowCount = v;
      }
      
      public function set labelFunction(value:Function) : void
      {
         _labelFunction = value;
         itemsSizeChanged = true;
         invalidateDisplayList();
         dispatchEvent(new Event("labelFunctionChanged"));
      }
      
      private function mouseLeaveHandler(event:Event) : void
      {
         mouseIsUp();
         isPressed = false;
      }
      
      public function unconstrainRenderer(item:Object) : void
      {
         unconstrainedRenderers[item] = true;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getIterator() : IViewCursor
      {
         return iterator;
      }
      
      [Inspectable(environment="none")]
      [Bindable("valueCommit")]
      [Bindable("change")]
      public function get selectedItems() : Array
      {
         return bSelectedItemsChanged ? _selectedItems : copySelectedItems();
      }
      
      protected function findKey(eventCode:int) : Boolean
      {
         var tmpCode:int = eventCode;
         return tmpCode >= 33 && tmpCode <= 126 && findString(String.fromCharCode(tmpCode));
      }
      
      override public function set verticalScrollPolicy(value:String) : void
      {
         super.verticalScrollPolicy = value;
         itemsSizeChanged = true;
         invalidateDisplayList();
      }
      
      public function set selectedIndex(value:int) : void
      {
         if(!collection || collection.length == 0)
         {
            _selectedIndex = value;
            bSelectionChanged = true;
            bSelectedIndexChanged = true;
            invalidateDisplayList();
            return;
         }
         commitSelectedIndex(value);
      }
      
      [Inspectable(defaultValue="0")]
      public function get lockedColumnCount() : int
      {
         return _lockedColumnCount;
      }
      
      protected function mouseOverHandler(event:MouseEvent) : void
      {
         var evt:ListEvent = null;
         var lastUID:String = null;
         var rowData:BaseListData = null;
         if(!enabled || !selectable)
         {
            return;
         }
         if(dragScrollingInterval != 0 && !event.buttonDown)
         {
            mouseIsUp();
         }
         isPressed = event.buttonDown;
         var item:IListItemRenderer = mouseEventToItemRenderer(event);
         var pt:Point = itemRendererToIndices(item);
         if(!item)
         {
            return;
         }
         var uid:String = itemToUID(item.data);
         if(!isPressed || allowDragSelection)
         {
            if(Boolean(event.relatedObject))
            {
               if(Boolean(lastHighlightItemRenderer) && Boolean(highlightUID))
               {
                  rowData = rowMap[item.name];
                  lastUID = rowData.uid;
               }
               if(itemRendererContains(item,event.relatedObject) || uid == lastUID || event.relatedObject == highlightIndicator)
               {
                  return;
               }
            }
            if(Boolean(getStyle("useRollOver")) && item.data != null)
            {
               if(allowDragSelection)
               {
                  bSelectOnRelease = true;
               }
               drawItem(visibleData[uid],isItemSelected(item.data),true,uid == caretUID);
               if(Boolean(pt))
               {
                  evt = new ListEvent(ListEvent.ITEM_ROLL_OVER);
                  evt.columnIndex = pt.x;
                  evt.rowIndex = pt.y;
                  evt.itemRenderer = item;
                  dispatchEvent(evt);
                  lastHighlightItemIndices = pt;
                  lastHighlightItemRendererAtIndices = item;
               }
            }
         }
         else
         {
            if(DragManager.isDragging)
            {
               return;
            }
            if(dragScrollingInterval != 0 && allowDragSelection || menuSelectionMode)
            {
               if(selectItem(item,event.shiftKey,event.ctrlKey))
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
      
      public function set itemRenderer(value:IFactory) : void
      {
         _itemRenderer = value;
         invalidateSize();
         invalidateDisplayList();
         itemsSizeChanged = true;
         rendererChanged = true;
         dispatchEvent(new Event("itemRendererChanged"));
      }
      
      private function commitSelectedItems(items:Array) : void
      {
         var useFind:Boolean = false;
         clearSelected();
         useFind = collection.sort != null;
         try
         {
            collectionIterator.seek(CursorBookmark.FIRST,0);
         }
         catch(e:ItemPendingError)
         {
            e.addResponder(new ItemResponder(selectionDataPendingResultHandler,selectionDataPendingFailureHandler,new ListBaseSelectionDataPending(useFind,0,items,null,0)));
            return;
         }
         setSelectionDataLoop(items,0,useFind);
      }
      
      public function set dataTipField(value:String) : void
      {
         _dataTipField = value;
         itemsSizeChanged = true;
         invalidateDisplayList();
         dispatchEvent(new Event("dataTipFieldChanged"));
      }
      
      private function makeRowsAndColumnsWithExtraColumns(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var currentColumns:int = 0;
         var extraEmptyColumns:int = 0;
         var i:int = 0;
         var j:int = 0;
         var desiredOffscreenColumnsLeft:int = offscreenExtraColumns / 2;
         var desiredOffscreenColumnsRight:int = offscreenExtraColumns / 2;
         offscreenExtraColumnsLeft = Math.min(desiredOffscreenColumnsLeft,horizontalScrollPosition);
         var index:int = scrollPositionToIndex(horizontalScrollPosition - offscreenExtraColumnsLeft,verticalScrollPosition);
         seekPositionSafely(index);
         var cursorPos:CursorBookmark = iterator.bookmark;
         if(offscreenExtraColumnsLeft > 0)
         {
            makeRowsAndColumns(0,0,0,listContent.height,0,0,true,offscreenExtraColumnsLeft);
         }
         var curX:Number = Boolean(offscreenExtraColumnsLeft) ? listItems[0][offscreenExtraColumnsLeft - 1].x + columnWidth : 0;
         var pt:Point = makeRowsAndColumns(curX,0,curX + listContent.widthExcludingOffsets,listContent.height,offscreenExtraColumnsLeft,0);
         if(desiredOffscreenColumnsRight > 0 && !iterator.afterLast)
         {
            if(offscreenExtraColumnsLeft + pt.x - 1 < 0)
            {
               curX = 0;
            }
            else
            {
               curX = listItems[0][offscreenExtraColumnsLeft + pt.x - 1].x + columnWidth;
            }
            currentColumns = int(listItems[0].length);
            pt = makeRowsAndColumns(curX,0,curX,listContent.height,offscreenExtraColumnsLeft + pt.x,0,true,desiredOffscreenColumnsRight);
            if(pt.x < desiredOffscreenColumnsRight)
            {
               extraEmptyColumns = listItems[0].length - (currentColumns + pt.x);
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
            }
            offscreenExtraColumnsRight = pt.x;
         }
         var oldContentWidth:Number = listContent.widthExcludingOffsets;
         listContent.leftOffset = -offscreenExtraColumnsLeft * columnWidth;
         listContent.rightOffset = offscreenExtraColumnsRight > 0 ? listItems[0][listItems[0].length - 1].x + columnWidth - oldContentWidth + listContent.leftOffset : 0;
         iterator.seek(cursorPos,0);
         adjustListContent(unscaledWidth,unscaledHeight);
      }
      
      protected function dragOverHandler(event:DragEvent) : void
      {
         if(event.isDefaultPrevented())
         {
            return;
         }
         if(event.dragSource.hasFormat("items"))
         {
            DragManager.showFeedback(event.ctrlKey ? DragManager.COPY : DragManager.MOVE);
            showDropFeedback(event);
            return;
         }
         hideDropFeedback(event);
         DragManager.showFeedback(DragManager.NONE);
      }
      
      private function adjustSelectionSettings(collectionHasItems:Boolean) : void
      {
         if(bSelectionChanged)
         {
            bSelectionChanged = false;
            if(bSelectedIndicesChanged && (collectionHasItems || _selectedIndices == null))
            {
               bSelectedIndicesChanged = false;
               bSelectedIndexChanged = false;
               commitSelectedIndices(_selectedIndices);
            }
            if(bSelectedItemChanged && (collectionHasItems || _selectedItem == null))
            {
               bSelectedItemChanged = false;
               bSelectedIndexChanged = false;
               commitSelectedItem(_selectedItem);
            }
            if(bSelectedItemsChanged && (collectionHasItems || _selectedItems == null))
            {
               bSelectedItemsChanged = false;
               bSelectedIndexChanged = false;
               commitSelectedItems(_selectedItems);
            }
            if(bSelectedIndexChanged && (collectionHasItems || _selectedIndex == -1))
            {
               commitSelectedIndex(_selectedIndex);
               bSelectedIndexChanged = false;
            }
         }
      }
      
      private function clearSelectionData() : void
      {
         selectedData = {};
         firstSelectionData = null;
      }
      
      public function hideDropFeedback(event:DragEvent) : void
      {
         if(Boolean(dropIndicator))
         {
            listContent.removeChild(DisplayObject(dropIndicator));
            dropIndicator = null;
            drawFocus(false);
            if(dragScrollingInterval != 0)
            {
               clearInterval(dragScrollingInterval);
               dragScrollingInterval = 0;
            }
         }
      }
      
      private function shiftRow(oldIndex:int, newIndex:int, numCols:int, shiftItems:Boolean) : void
      {
         var r:IListItemRenderer = null;
         for(var j:int = 0; j < numCols; j++)
         {
            r = listItems[oldIndex][j];
            if(shiftItems)
            {
               listItems[newIndex][j] = r;
               rowMap[r.name].rowIndex = newIndex;
            }
            else
            {
               rowMap[r.name].rowIndex = oldIndex;
            }
         }
      }
      
      private function selectionTween_endHandler(event:TweenEvent) : void
      {
         selectionTween_updateHandler(event);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function resetDragScrolling() : void
      {
         if(dragScrollingInterval != 0)
         {
            clearInterval(dragScrollingInterval);
            dragScrollingInterval = 0;
         }
      }
      
      protected function mouseClickHandler(event:MouseEvent) : void
      {
         var listEvent:ListEvent = null;
         var item:IListItemRenderer = mouseEventToItemRenderer(event);
         if(!item)
         {
            return;
         }
         var pt:Point = itemRendererToIndices(item);
         if(Boolean(pt))
         {
            listEvent = new ListEvent(ListEvent.ITEM_CLICK);
            listEvent.columnIndex = pt.x;
            listEvent.rowIndex = pt.y;
            listEvent.itemRenderer = item;
            dispatchEvent(listEvent);
         }
      }
      
      private function selectionIndicesPendingFailureHandler(data:Object, info:ListBaseSelectionDataPending) : void
      {
      }
      
      protected function finishKeySelection() : void
      {
         var uid:String = null;
         var listItem:IListItemRenderer = null;
         var pt:Point = null;
         var evt:ListEvent = null;
         var rowCount:int = int(listItems.length);
         var partialRow:int = rowInfo[rowCount - 1].y + rowInfo[rowCount - 1].height > listContent.height ? 1 : 0;
         if(lastKey == Keyboard.PAGE_DOWN)
         {
            caretIndex = Math.min(verticalScrollPosition + rowCount - partialRow - 1,collection.length - 1);
         }
         var bSelChanged:Boolean = false;
         if(bSelectItem && caretIndex - verticalScrollPosition >= 0)
         {
            if(caretIndex - verticalScrollPosition > listItems.length - 1)
            {
               caretIndex = listItems.length - 1 + verticalScrollPosition;
            }
            listItem = listItems[caretIndex - verticalScrollPosition][0];
            if(Boolean(listItem))
            {
               uid = itemToUID(listItem.data);
               listItem = visibleData[uid];
               if(!bCtrlKey)
               {
                  selectItem(listItem,bShiftKey,bCtrlKey);
                  bSelChanged = true;
               }
               if(bCtrlKey)
               {
                  drawItem(listItem,selectedData[uid] != null,uid == highlightUID,true);
               }
            }
         }
         if(bSelChanged)
         {
            pt = itemRendererToIndices(listItem);
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
      
      private function selectionDataPendingFailureHandler(data:Object, info:ListBaseSelectionDataPending) : void
      {
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function addClipMask(layoutChanged:Boolean) : void
      {
         var item:DisplayObject = null;
         var yOffset:Number = NaN;
         if(layoutChanged)
         {
            if(Boolean(horizontalScrollBar && horizontalScrollBar.visible || hasOnlyTextRenderers() || runningDataEffect || listContent.bottomOffset != 0 || listContent.topOffset != 0) || Boolean(listContent.leftOffset != 0) || listContent.rightOffset != 0)
            {
               listContent.mask = maskShape;
               selectionLayer.mask = null;
            }
            else
            {
               listContent.mask = null;
               selectionLayer.mask = maskShape;
            }
         }
         if(Boolean(listContent.mask))
         {
            return;
         }
         var lastRowIndex:int = listItems.length - 1;
         var lastRowInfo:ListRowInfo = rowInfo[lastRowIndex];
         var lastRowItems:Array = listItems[lastRowIndex];
         if(lastRowInfo.y + lastRowInfo.height <= listContent.height)
         {
            return;
         }
         var numColumns:int = int(lastRowItems.length);
         var rowY:Number = Number(lastRowInfo.y);
         var rowWidth:Number = Number(listContent.width);
         var rowHeight:Number = listContent.height - lastRowInfo.y;
         for(var i:int = 0; i < numColumns; i++)
         {
            item = lastRowItems[i];
            yOffset = item.y - rowY;
            if(item is IUITextField)
            {
               item.height = rowHeight - yOffset;
            }
            else
            {
               item.mask = createItemMask(0,rowY + yOffset,rowWidth,rowHeight - yOffset);
            }
         }
      }
      
      public function set allowMultipleSelection(value:Boolean) : void
      {
         _allowMultipleSelection = value;
      }
      
      protected function scrollVertically(pos:int, deltaPos:int, scrollUp:Boolean) : void
      {
         var moveBlockDistance:Number;
         var columnCount:int;
         var i:int = 0;
         var j:int = 0;
         var r:IListItemRenderer = null;
         var item:IListItemRenderer = null;
         var numRows:int = 0;
         var numCols:int = 0;
         var uid:String = null;
         var visibleY:Number = NaN;
         var curY:Number = NaN;
         var cursorPos:CursorBookmark = null;
         var startRow:int = 0;
         var actual:Point = null;
         var row:Array = null;
         var rowData:Object = null;
         var deltaY:Number = NaN;
         var deleteRow:Boolean = false;
         var oldRow:Array = null;
         var rowCount:int = int(rowInfo.length);
         if(rowCount > listItems.length)
         {
            rowCount = int(listItems.length);
         }
         columnCount = int(listItems[0].length);
         moveBlockDistance = 0;
         visibleY = lockedRowCount > 0 ? rowInfo[lockedRowCount - 1].y + rowInfo[lockedRowCount - 1].height : Number(rowInfo[0].y);
         if(scrollUp)
         {
            for(i = lockedRowCount; i < rowCount; i++)
            {
               if(rowInfo[i].y >= visibleY)
               {
                  break;
               }
            }
            for(startRow = i; i < deltaPos + startRow; )
            {
               moveBlockDistance += rowInfo[i].height;
               try
               {
                  iterator.moveNext();
               }
               catch(e:ItemPendingError)
               {
                  lastSeekPending = new ListBaseSeekPending(CursorBookmark.FIRST,pos);
                  e.addResponder(new ItemResponder(seekPendingResultHandler,seekPendingFailureHandler,lastSeekPending));
                  iteratorValid = false;
                  return;
               }
               i++;
            }
            for(i = lockedRowCount; i < rowCount; i++)
            {
               numCols = Math.min(columnCount,listItems[i].length);
               if(i < deltaPos + lockedRowCount)
               {
                  destroyRow(i,numCols);
               }
               else if(deltaPos > 0)
               {
                  for(j = 0; j < numCols; j++)
                  {
                     r = listItems[i][j];
                     r.move(r.x,r.y - moveBlockDistance);
                     if(Boolean(r.data) && r is IDropInListItemRenderer)
                     {
                        IDropInListItemRenderer(r).listData.rowIndex = i;
                     }
                     rowMap[r.name].rowIndex = i;
                  }
                  rowInfo[i].y -= moveBlockDistance;
                  uid = rowInfo[i].uid;
                  if(Boolean(uid))
                  {
                     moveIndicators(uid,-moveBlockDistance,false);
                  }
               }
            }
            if(Boolean(deltaPos))
            {
               for(i = lockedRowCount + deltaPos; i < rowCount; i++)
               {
                  numCols = int(listItems[i].length);
                  for(j = 0; j < numCols; j++)
                  {
                     r = listItems[i][j];
                     if(Boolean(r.data) && r is IDropInListItemRenderer)
                     {
                        IDropInListItemRenderer(r).listData.rowIndex = i - deltaPos;
                     }
                     rowMap[r.name].rowIndex = i - deltaPos;
                     listItems[i - deltaPos][j] = r;
                  }
                  if(listItems[i - deltaPos].length > numCols)
                  {
                     listItems[i - deltaPos].splice(numCols);
                  }
                  if(!numCols)
                  {
                     listItems[i - deltaPos].splice(0);
                  }
                  rowInfo[i - deltaPos] = rowInfo[i];
               }
               listItems.splice(rowCount - deltaPos);
               rowInfo.splice(rowCount - deltaPos);
            }
            if(Boolean(rowInfo) && rowInfo.length > 0)
            {
               curY = rowInfo[rowCount - deltaPos - 1].y + rowInfo[rowCount - deltaPos - 1].height;
            }
            else
            {
               curY = 0;
            }
            cursorPos = iterator.bookmark;
            try
            {
               iterator.seek(CursorBookmark.CURRENT,rowCount - lockedRowCount - deltaPos);
            }
            catch(e1:ItemPendingError)
            {
               lastSeekPending = new ListBaseSeekPending(cursorPos,0);
               e1.addResponder(new ItemResponder(seekPendingResultHandler,seekPendingFailureHandler,lastSeekPending));
               iteratorValid = false;
            }
            makeRowsAndColumns(0,curY,listContent.width,listContent.height,0,rowCount - deltaPos);
            iterator.seek(cursorPos,0);
         }
         else
         {
            curY = 0;
            if(lockedRowCount > 0)
            {
               curY = rowInfo[lockedRowCount - 1].y + rowInfo[lockedRowCount - 1].height;
            }
            else
            {
               curY = Number(rowInfo[0].y);
            }
            for(i = 0; i < deltaPos; i++)
            {
               listItems.splice(lockedRowCount,0,null);
               rowInfo.splice(lockedRowCount,0,null);
            }
            try
            {
               iterator.seek(CursorBookmark.CURRENT,-deltaPos);
            }
            catch(e2:ItemPendingError)
            {
               lastSeekPending = new ListBaseSeekPending(CursorBookmark.CURRENT,-deltaPos);
               e2.addResponder(new ItemResponder(seekPendingResultHandler,seekPendingFailureHandler,lastSeekPending));
               iteratorValid = false;
            }
            cursorPos = iterator.bookmark;
            actual = makeRowsAndColumns(0,curY,listContent.width,listContent.height,0,lockedRowCount,true,deltaPos);
            iterator.seek(cursorPos,0);
            if(actual.y == 0)
            {
               verticalScrollPosition = 0;
               rowInfo.splice(lockedRowCount,deltaPos);
               listItems.splice(lockedRowCount,deltaPos);
            }
            for(i = 0; i < actual.y; i++)
            {
               moveBlockDistance += rowInfo[lockedRowCount + i].height;
            }
            curY += moveBlockDistance;
            for(i = lockedRowCount + actual.y; i < listItems.length; i++)
            {
               row = listItems[i];
               rowData = rowInfo[i];
               deleteRow = false;
               deltaY = curY - rowData.y;
               rowData.y = curY;
               if(Boolean(row.length))
               {
                  for(j = 0; j < row.length; j++)
                  {
                     item = row[j];
                     item.move(item.x,item.y + deltaY);
                     if(item.y >= listContent.height)
                     {
                        deleteRow = true;
                     }
                     if(!deleteRow)
                     {
                        rowMap[item.name].rowIndex += deltaPos;
                     }
                  }
               }
               else if(rowData.y >= listContent.height)
               {
                  deleteRow = true;
               }
               uid = rowInfo[i].uid;
               if(deleteRow)
               {
                  oldRow = listItems[i];
                  if(Boolean(oldRow.length) && Boolean(oldRow[0].data))
                  {
                     removeIndicators(uid);
                  }
                  for(j = 0; j < oldRow.length; j++)
                  {
                     if(Boolean(oldRow[j]) && Boolean(oldRow[j].data))
                     {
                        delete visibleData[uid];
                        addToFreeItemRenderers(oldRow[j]);
                     }
                  }
                  listItems.splice(i,1);
                  rowInfo.splice(i,1);
                  i--;
               }
               if(Boolean(uid))
               {
                  moveIndicators(uid,curY,true);
                  if(Boolean(selectionIndicators[uid]))
                  {
                     selectionIndicators[uid].y = curY;
                  }
                  if(highlightUID == uid)
                  {
                     highlightIndicator.y = curY;
                  }
                  if(caretUID == uid)
                  {
                     caretIndicator.y = curY;
                  }
               }
               curY += rowData.height;
            }
            rowCount = int(listItems.length);
         }
      }
      
      protected function selectItem(item:IListItemRenderer, shiftKey:Boolean, ctrlKey:Boolean, transition:Boolean = true) : Boolean
      {
         var uid:String;
         var selectionChange:Boolean;
         var placeHolder:CursorBookmark = null;
         var index:int = 0;
         var data:Object = null;
         var numSelected:int = 0;
         var curSelectionData:ListBaseSelectionData = null;
         var oldCaretIndex:int = 0;
         var oldAnchorBookmark:CursorBookmark = null;
         var oldAnchorIndex:int = 0;
         var incr:Boolean = false;
         if(!item || !isItemSelectable(item.data))
         {
            return false;
         }
         selectionChange = false;
         placeHolder = iterator.bookmark;
         index = itemRendererToIndex(item);
         uid = itemToUID(item.data);
         if(!allowMultipleSelection || !shiftKey && !ctrlKey)
         {
            numSelected = 0;
            if(allowMultipleSelection)
            {
               curSelectionData = firstSelectionData;
               if(curSelectionData != null)
               {
                  numSelected++;
                  if(Boolean(curSelectionData.nextSelectionData))
                  {
                     numSelected++;
                  }
               }
            }
            if(ctrlKey && Boolean(selectedData[uid]))
            {
               selectionChange = true;
               oldCaretIndex = caretIndex;
               clearSelected(transition);
               caretIndex = oldCaretIndex;
            }
            else if(_selectedIndex != index || bSelectedIndexChanged || allowMultipleSelection && numSelected != 1)
            {
               selectionChange = true;
               clearSelected(transition);
               addSelectionData(uid,new ListBaseSelectionData(item.data,index,approximate));
               drawItem(visibleData[uid],true,uid == highlightUID,true,transition);
               _selectedIndex = index;
               _selectedItem = item.data;
               iterator.seek(CursorBookmark.CURRENT,_selectedIndex - indicesToIndex(verticalScrollPosition - offscreenExtraRowsTop,horizontalScrollPosition - offscreenExtraColumnsLeft));
               caretIndex = _selectedIndex;
               caretBookmark = iterator.bookmark;
               anchorIndex = _selectedIndex;
               anchorBookmark = iterator.bookmark;
               iterator.seek(placeHolder,0);
            }
         }
         else if(shiftKey && allowMultipleSelection)
         {
            if(Boolean(anchorBookmark))
            {
               oldAnchorBookmark = anchorBookmark;
               oldAnchorIndex = anchorIndex;
               incr = anchorIndex < index;
               clearSelected(false);
               caretIndex = index;
               caretBookmark = iterator.bookmark;
               anchorIndex = oldAnchorIndex;
               anchorBookmark = oldAnchorBookmark;
               try
               {
                  iterator.seek(anchorBookmark,0);
               }
               catch(e:ItemPendingError)
               {
                  e.addResponder(new ItemResponder(selectionPendingResultHandler,selectionPendingFailureHandler,new ListBaseSelectionPending(incr,index,item.data,transition,placeHolder,CursorBookmark.CURRENT,0)));
                  iteratorValid = false;
               }
               shiftSelectionLoop(incr,anchorIndex,item.data,transition,placeHolder);
            }
            selectionChange = true;
         }
         else if(ctrlKey && allowMultipleSelection)
         {
            if(Boolean(selectedData[uid]))
            {
               removeSelectionData(uid);
               drawItem(visibleData[uid],false,uid == highlightUID,true,transition);
               if(item.data == selectedItem)
               {
                  calculateSelectedIndexAndItem();
               }
            }
            else
            {
               addSelectionData(uid,new ListBaseSelectionData(item.data,index,approximate));
               drawItem(visibleData[uid],true,uid == highlightUID,true,transition);
               _selectedIndex = index;
               _selectedItem = item.data;
            }
            iterator.seek(CursorBookmark.CURRENT,index - indicesToIndex(verticalScrollPosition,horizontalScrollPosition));
            caretIndex = index;
            caretBookmark = iterator.bookmark;
            anchorIndex = index;
            anchorBookmark = iterator.bookmark;
            iterator.seek(placeHolder,0);
            selectionChange = true;
         }
         return selectionChange;
      }
      
      private function selectionTween_updateHandler(event:TweenEvent) : void
      {
         Sprite(event.target.listener).alpha = Number(event.value);
      }
      
      protected function prepareDataEffect(ce:CollectionEvent) : void
      {
         var dce:Object = null;
         var dceClass:Class = null;
         var firstItemIndex:int = 0;
         var lastItemIndex:int = 0;
         if(!cachedDataChangeEffect)
         {
            dce = getStyle("dataChangeEffect");
            dceClass = dce as Class;
            if(Boolean(dceClass))
            {
               dce = new dceClass();
            }
            cachedDataChangeEffect = dce as Effect;
         }
         if(runningDataEffect)
         {
            collection = actualCollection;
            iterator = actualIterator;
            cachedDataChangeEffect.end();
            modifiedCollectionView = null;
         }
         if(Boolean(cachedDataChangeEffect) && iteratorValid)
         {
            firstItemIndex = int(iterator.bookmark.getViewIndex());
            lastItemIndex = firstItemIndex + rowCount * columnCount - 1;
            if(!modifiedCollectionView && collection is IList)
            {
               modifiedCollectionView = new ModifiedCollectionView(ICollectionView(collection));
            }
            if(Boolean(modifiedCollectionView))
            {
               modifiedCollectionView.processCollectionEvent(ce,firstItemIndex,lastItemIndex);
               runDataEffectNextUpdate = true;
               if(invalidateDisplayListFlag)
               {
                  callLater(invalidateList);
               }
               else
               {
                  invalidateList();
               }
            }
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
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setColumnWidth(value:Number) : void
      {
         _columnWidth = value;
      }
      
      protected function makeRowsAndColumns(left:Number, top:Number, right:Number, bottom:Number, firstColumn:int, firstRow:int, byCount:Boolean = false, rowsNeeded:uint = 0) : Point
      {
         return new Point(0,0);
      }
      
      public function isItemVisible(item:Object) : Boolean
      {
         return itemToItemRenderer(item) != null;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function commitSelectedIndices(indices:Array) : void
      {
         clearSelected();
         try
         {
            collectionIterator.seek(CursorBookmark.FIRST,0);
         }
         catch(e:ItemPendingError)
         {
            e.addResponder(new ItemResponder(selectionIndicesPendingResultHandler,selectionIndicesPendingFailureHandler,new ListBaseSelectionDataPending(true,0,indices,CursorBookmark.FIRST,0)));
            return;
         }
         setSelectionIndicesLoop(0,indices,true);
      }
      
      public function calculateDropIndex(event:DragEvent = null) : int
      {
         var item:IListItemRenderer = null;
         var pt:Point = null;
         var rc:int = 0;
         var i:int = 0;
         if(Boolean(event))
         {
            pt = new Point(event.localX,event.localY);
            pt = DisplayObject(event.target).localToGlobal(pt);
            pt = listContent.globalToLocal(pt);
            rc = int(listItems.length);
            for(i = 0; i < rc; i++)
            {
               if(rowInfo[i].y <= pt.y && pt.y <= rowInfo[i].y + rowInfo[i].height)
               {
                  item = listItems[i][0];
                  break;
               }
            }
            if(Boolean(item))
            {
               lastDropIndex = itemRendererToIndex(item);
            }
            else
            {
               lastDropIndex = Boolean(collection) ? int(collection.length) : 0;
            }
         }
         return lastDropIndex;
      }
      
      protected function mouseDownHandler(event:MouseEvent) : void
      {
         if(!enabled || !selectable)
         {
            return;
         }
         isPressed = true;
         var item:IListItemRenderer = mouseEventToItemRenderer(event);
         if(!item)
         {
            return;
         }
         bSelectOnRelease = false;
         var pt:Point = new Point(event.localX,event.localY);
         pt = DisplayObject(event.target).localToGlobal(pt);
         mouseDownPoint = globalToLocal(pt);
         systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler,true,0,true);
         systemManager.getSandboxRoot().addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,mouseLeaveHandler,false,0,true);
         if(!dragEnabled)
         {
            dragScrollingInterval = setInterval(dragScroll,15);
         }
         if(dragEnabled && Boolean(selectedData[rowMap[item.name].uid]))
         {
            bSelectOnRelease = true;
         }
         else if(selectItem(item,event.shiftKey,event.ctrlKey))
         {
            mouseDownItem = item;
         }
      }
      
      [Inspectable(category="Data",defaultValue="label")]
      [Bindable("labelFieldChanged")]
      public function get labelField() : String
      {
         return _labelField;
      }
      
      private function onSelectionTweenUpdate(value:Number) : void
      {
      }
      
      protected function clearIndicators() : void
      {
         var uniqueID:String = null;
         for(uniqueID in selectionTweens)
         {
            removeIndicators(uniqueID);
         }
         if(Boolean(selectionLayer))
         {
            while(selectionLayer.numChildren > 0)
            {
               selectionLayer.removeChildAt(0);
            }
         }
         selectionTweens = {};
         selectionIndicators = {};
         highlightIndicator = null;
         highlightUID = null;
         caretIndicator = null;
         caretUID = null;
      }
      
      [Inspectable(category="General")]
      public function get wordWrap() : Boolean
      {
         return _wordWrap;
      }
      
      protected function drawItem(item:IListItemRenderer, selected:Boolean = false, highlighted:Boolean = false, caret:Boolean = false, transition:Boolean = false) : void
      {
         var o:Sprite = null;
         var g:Graphics = null;
         var effectiveRowY:Number = NaN;
         if(!item)
         {
            return;
         }
         var rowData:BaseListData = rowMap[item.name];
         if(!rowData)
         {
            return;
         }
         if(highlighted && (!highlightItemRenderer || highlightUID != rowData.uid))
         {
            if(!highlightIndicator)
            {
               o = new SpriteAsset();
               selectionLayer.addChild(DisplayObject(o));
               highlightIndicator = o;
            }
            else
            {
               selectionLayer.setChildIndex(DisplayObject(highlightIndicator),selectionLayer.numChildren - 1);
            }
            o = highlightIndicator;
            drawHighlightIndicator(o,item.x,rowInfo[rowData.rowIndex].y,item.width,rowInfo[rowData.rowIndex].height,getStyle("rollOverColor"),item);
            lastHighlightItemRenderer = highlightItemRenderer = item;
            highlightUID = rowData.uid;
         }
         else if(Boolean(!highlighted) && Boolean(highlightItemRenderer) && (Boolean(rowData) && Boolean(highlightUID == rowData.uid)))
         {
            if(Boolean(highlightIndicator))
            {
               Sprite(highlightIndicator).graphics.clear();
            }
            highlightItemRenderer = null;
            highlightUID = "";
         }
         if(selected)
         {
            effectiveRowY = runningDataEffect ? item.y - cachedPaddingTop : Number(rowInfo[rowData.rowIndex].y);
            if(!selectionIndicators[rowData.uid])
            {
               o = new SpriteAsset();
               o.mouseEnabled = false;
               selectionLayer.addChild(DisplayObject(o));
               selectionIndicators[rowData.uid] = o;
               drawSelectionIndicator(o,item.x,effectiveRowY,item.width,rowInfo[rowData.rowIndex].height,enabled ? uint(getStyle("selectionColor")) : uint(getStyle("selectionDisabledColor")),item);
               if(transition)
               {
                  applySelectionEffect(o,rowData.uid,item);
               }
            }
            else
            {
               o = selectionIndicators[rowData.uid];
               drawSelectionIndicator(o,item.x,effectiveRowY,item.width,rowInfo[rowData.rowIndex].height,enabled ? uint(getStyle("selectionColor")) : uint(getStyle("selectionDisabledColor")),item);
            }
         }
         else if(!selected)
         {
            if(Boolean(rowData) && Boolean(selectionIndicators[rowData.uid]))
            {
               if(Boolean(selectionTweens[rowData.uid]))
               {
                  selectionTweens[rowData.uid].removeEventListener(TweenEvent.TWEEN_UPDATE,selectionTween_updateHandler);
                  selectionTweens[rowData.uid].removeEventListener(TweenEvent.TWEEN_END,selectionTween_endHandler);
                  if(selectionIndicators[rowData.uid].alpha < 1)
                  {
                     Tween.removeTween(selectionTweens[rowData.uid]);
                  }
                  delete selectionTweens[rowData.uid];
               }
               selectionLayer.removeChild(selectionIndicators[rowData.uid]);
               delete selectionIndicators[rowData.uid];
            }
         }
         if(caret)
         {
            if(showCaret)
            {
               if(!caretIndicator)
               {
                  o = new SpriteAsset();
                  o.mouseEnabled = false;
                  selectionLayer.addChild(DisplayObject(o));
                  caretIndicator = o;
               }
               else
               {
                  selectionLayer.setChildIndex(DisplayObject(caretIndicator),selectionLayer.numChildren - 1);
               }
               o = caretIndicator;
               drawCaretIndicator(o,item.x,rowInfo[rowData.rowIndex].y,item.width,rowInfo[rowData.rowIndex].height,getStyle("selectionColor"),item);
               caretItemRenderer = item;
               caretUID = rowData.uid;
            }
         }
         else if(Boolean(!caret) && Boolean(caretItemRenderer) && caretUID == rowData.uid)
         {
            if(Boolean(caretIndicator))
            {
               Sprite(caretIndicator).graphics.clear();
            }
            caretItemRenderer = null;
            caretUID = "";
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
      
      protected function adjustAfterRemove(items:Array, location:int, emitEvent:Boolean) : Boolean
      {
         var data:ListBaseSelectionData = null;
         var s:String = null;
         var requiresValueCommit:Boolean = emitEvent;
         var i:int = 0;
         var length:int = int(items.length);
         for(s in selectedData)
         {
            i++;
            data = selectedData[s];
            if(data.index > location)
            {
               data.index -= length;
            }
         }
         if(_selectedIndex > location)
         {
            _selectedIndex -= length;
            requiresValueCommit = true;
         }
         if(i > 0 && _selectedIndex == -1)
         {
            _selectedIndex = data.index;
            _selectedItem = data.data;
            requiresValueCommit = true;
         }
         if(i == 0)
         {
            _selectedIndex = -1;
            bSelectionChanged = true;
            bSelectedIndexChanged = true;
            invalidateDisplayList();
         }
         return requiresValueCommit;
      }
      
      public function itemToIcon(data:Object) : Class
      {
         var iconClass:Class = null;
         var icon:* = undefined;
         if(data == null)
         {
            return null;
         }
         if(iconFunction != null)
         {
            return iconFunction(data);
         }
         if(data is XML)
         {
            try
            {
               if(data[iconField].length() != 0)
               {
                  icon = String(data[iconField]);
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
               if(data[iconField] != null)
               {
                  if(data[iconField] is Class)
                  {
                     return data[iconField];
                  }
                  if(data[iconField] is String)
                  {
                     iconClass = Class(systemManager.getDefinitionByName(data[iconField]));
                     if(Boolean(iconClass))
                     {
                        return iconClass;
                     }
                     return document[data[iconField]];
                  }
               }
            }
            catch(e:Error)
            {
            }
         }
         return null;
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
         itemsSizeChanged = true;
         invalidateDisplayList();
      }
      
      public function addDataEffectItem(item:Object) : void
      {
         if(Boolean(modifiedCollectionView))
         {
            modifiedCollectionView.addItem(dataItemWrappersByRenderer[item]);
         }
         if(iterator.afterLast)
         {
            iterator.seek(CursorBookmark.FIRST);
         }
         else
         {
            iterator.seek(CursorBookmark.CURRENT);
         }
         if(invalidateDisplayListFlag)
         {
            itemsSizeChanged = true;
            validateDisplayList();
         }
         else
         {
            invalidateList();
         }
      }
      
      protected function dragExitHandler(event:DragEvent) : void
      {
         if(event.isDefaultPrevented())
         {
            return;
         }
         hideDropFeedback(event);
         DragManager.showFeedback(DragManager.NONE);
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
         var desiredExtraRowsTop:int = offscreenExtraRows / 2;
         var desiredExtraRowsBottom:int = offscreenExtraRows / 2;
         offscreenExtraRowsTop = Math.min(desiredExtraRowsTop,verticalScrollPosition);
         var index:int = scrollPositionToIndex(horizontalScrollPosition,verticalScrollPosition - offscreenExtraRowsTop);
         seekPositionSafely(index);
         var cursorPos:CursorBookmark = iterator.bookmark;
         if(offscreenExtraRowsTop > 0)
         {
            makeRowsAndColumns(0,0,listContent.width,listContent.height,0,0,true,offscreenExtraRowsTop);
         }
         var curY:Number = Boolean(offscreenExtraRowsTop) ? rowInfo[offscreenExtraRowsTop - 1].y + rowHeight : 0;
         pt = makeRowsAndColumns(0,curY,listContent.width,curY + listContent.heightExcludingOffsets,0,offscreenExtraRowsTop);
         if(desiredExtraRowsBottom > 0 && !iterator.afterLast)
         {
            if(offscreenExtraRowsTop + pt.y - 1 < 0)
            {
               curY = 0;
            }
            else
            {
               curY = rowInfo[offscreenExtraRowsTop + pt.y - 1].y + rowInfo[offscreenExtraRowsTop + pt.y - 1].height;
            }
            currentRows = int(listItems.length);
            pt = makeRowsAndColumns(0,curY,listContent.width,curY,0,offscreenExtraRowsTop + pt.y,true,desiredExtraRowsBottom);
            if(pt.y < desiredExtraRowsBottom)
            {
               extraEmptyRows = listItems.length - (currentRows + pt.y);
               if(Boolean(extraEmptyRows))
               {
                  for(i = 0; i < extraEmptyRows; i++)
                  {
                     listItems.pop();
                     rowInfo.pop();
                  }
               }
            }
            offscreenExtraRowsBottom = pt.y;
         }
         var oldContentHeight:Number = listContent.heightExcludingOffsets;
         listContent.topOffset = -offscreenExtraRowsTop * rowHeight;
         listContent.bottomOffset = offscreenExtraRowsBottom > 0 ? listItems[listItems.length - 1][0].y + rowHeight - oldContentHeight + listContent.topOffset : 0;
         if(iteratorValid)
         {
            iterator.seek(cursorPos,0);
         }
         adjustListContent(unscaledWidth,unscaledHeight);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function indicesToItemRenderer(row:int, col:int) : IListItemRenderer
      {
         return listItems[row][col];
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getItemRendererForMouseEvent(event:MouseEvent) : IListItemRenderer
      {
         return mouseEventToItemRenderer(event);
      }
      
      protected function mouseOutHandler(event:MouseEvent) : void
      {
         if(!enabled || !selectable)
         {
            return;
         }
         isPressed = event.buttonDown;
         var item:IListItemRenderer = mouseEventToItemRenderer(event);
         if(!item)
         {
            return;
         }
         if(!isPressed)
         {
            if(itemRendererContains(item,event.relatedObject) || event.relatedObject == listContent || event.relatedObject == highlightIndicator || !highlightItemRenderer)
            {
               return;
            }
            if(Boolean(getStyle("useRollOver")) && item.data != null)
            {
               clearHighlight(item);
            }
         }
      }
      
      public function set dropEnabled(value:Boolean) : void
      {
         if(_dropEnabled && !value)
         {
            removeEventListener(DragEvent.DRAG_ENTER,dragEnterHandler,false);
            removeEventListener(DragEvent.DRAG_EXIT,dragExitHandler,false);
            removeEventListener(DragEvent.DRAG_OVER,dragOverHandler,false);
            removeEventListener(DragEvent.DRAG_DROP,dragDropHandler,false);
         }
         _dropEnabled = value;
         if(value)
         {
            addEventListener(DragEvent.DRAG_ENTER,dragEnterHandler,false,EventPriority.DEFAULT_HANDLER);
            addEventListener(DragEvent.DRAG_EXIT,dragExitHandler,false,EventPriority.DEFAULT_HANDLER);
            addEventListener(DragEvent.DRAG_OVER,dragOverHandler,false,EventPriority.DEFAULT_HANDLER);
            addEventListener(DragEvent.DRAG_DROP,dragDropHandler,false,EventPriority.DEFAULT_HANDLER);
         }
      }
      
      public function itemToLabel(data:Object) : String
      {
         if(data == null)
         {
            return " ";
         }
         if(labelFunction != null)
         {
            return labelFunction(data);
         }
         if(data is XML)
         {
            try
            {
               if(data[labelField].length() != 0)
               {
                  data = data[labelField];
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
               if(data[labelField] != null)
               {
                  data = data[labelField];
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
      
      public function set rowCount(value:int) : void
      {
         explicitRowCount = value;
         if(_rowCount != value)
         {
            setRowCount(value);
            rowCountChanged = true;
            invalidateProperties();
            invalidateSize();
            itemsSizeChanged = true;
            invalidateDisplayList();
            dispatchEvent(new Event("rowCountChanged"));
         }
      }
      
      protected function moveSelectionVertically(code:uint, shiftKey:Boolean, ctrlKey:Boolean) : void
      {
         var newVerticalScrollPosition:Number = NaN;
         var listItem:IListItemRenderer = null;
         var uid:String = null;
         var len:int = 0;
         var se:ScrollEvent = null;
         var bSelChanged:Boolean = false;
         showCaret = true;
         var rowCount:int = int(listItems.length);
         var partialRow:int = rowInfo[rowCount - 1].y + rowInfo[rowCount - 1].height > listContent.height ? 1 : 0;
         var bUpdateVerticalScrollPosition:Boolean = false;
         bSelectItem = false;
         switch(code)
         {
            case Keyboard.UP:
               if(caretIndex > 0)
               {
                  --caretIndex;
                  bUpdateVerticalScrollPosition = true;
                  bSelectItem = true;
               }
               break;
            case Keyboard.DOWN:
               if(caretIndex < collection.length - 1)
               {
                  ++caretIndex;
                  bUpdateVerticalScrollPosition = true;
                  bSelectItem = true;
               }
               else if(caretIndex == collection.length - 1 && Boolean(partialRow))
               {
                  if(verticalScrollPosition < maxVerticalScrollPosition)
                  {
                     newVerticalScrollPosition = verticalScrollPosition + 1;
                  }
               }
               break;
            case Keyboard.PAGE_UP:
               if(caretIndex < lockedRowCount)
               {
                  newVerticalScrollPosition = 0;
                  caretIndex = 0;
               }
               else if(caretIndex > verticalScrollPosition + lockedRowCount && caretIndex < verticalScrollPosition + rowCount)
               {
                  caretIndex = verticalScrollPosition + lockedRowCount;
               }
               else
               {
                  caretIndex = Math.max(caretIndex - rowCount + lockedRowCount,0);
                  newVerticalScrollPosition = Math.max(caretIndex - lockedRowCount,0);
               }
               bSelectItem = true;
               break;
            case Keyboard.PAGE_DOWN:
               if(caretIndex < lockedRowCount)
               {
                  newVerticalScrollPosition = 0;
               }
               else if(!(caretIndex >= verticalScrollPosition + lockedRowCount && caretIndex < verticalScrollPosition + rowCount - partialRow - 1))
               {
                  newVerticalScrollPosition = Math.min(caretIndex - lockedRowCount,maxVerticalScrollPosition);
               }
               bSelectItem = true;
               break;
            case Keyboard.HOME:
               if(caretIndex > 0)
               {
                  caretIndex = 0;
                  bSelectItem = true;
                  newVerticalScrollPosition = 0;
               }
               break;
            case Keyboard.END:
               if(caretIndex < collection.length - 1)
               {
                  caretIndex = collection.length - 1;
                  bSelectItem = true;
                  newVerticalScrollPosition = Number(maxVerticalScrollPosition);
               }
         }
         if(bUpdateVerticalScrollPosition)
         {
            if(caretIndex < lockedRowCount)
            {
               newVerticalScrollPosition = 0;
            }
            else if(caretIndex < verticalScrollPosition + lockedRowCount)
            {
               newVerticalScrollPosition = caretIndex - lockedRowCount;
            }
            else if(caretIndex >= verticalScrollPosition + rowCount - partialRow)
            {
               newVerticalScrollPosition = Math.min(maxVerticalScrollPosition,caretIndex - rowCount + partialRow + 1);
            }
         }
         if(!isNaN(newVerticalScrollPosition))
         {
            if(verticalScrollPosition != newVerticalScrollPosition)
            {
               se = new ScrollEvent(ScrollEvent.SCROLL);
               se.detail = ScrollEventDetail.THUMB_POSITION;
               se.direction = ScrollEventDirection.VERTICAL;
               se.delta = newVerticalScrollPosition - verticalScrollPosition;
               se.position = newVerticalScrollPosition;
               verticalScrollPosition = newVerticalScrollPosition;
               dispatchEvent(se);
            }
            if(!iteratorValid)
            {
               keySelectionPending = true;
               return;
            }
         }
         bShiftKey = shiftKey;
         bCtrlKey = ctrlKey;
         lastKey = code;
         finishKeySelection();
      }
      
      public function set columnCount(value:int) : void
      {
         explicitColumnCount = value;
         if(_columnCount != value)
         {
            setColumnCount(value);
            columnCountChanged = true;
            invalidateProperties();
            invalidateSize();
            itemsSizeChanged = true;
            invalidateDisplayList();
            dispatchEvent(new Event("columnCountChanged"));
         }
      }
      
      private function partialPurgeItemRenderers() : void
      {
         var uid:String = null;
         var freeRenderer:DisplayObject = null;
         dataEffectCompleted = false;
         while(Boolean(freeItemRenderers.length))
         {
            freeRenderer = DisplayObject(freeItemRenderers.pop());
            if(Boolean(freeRenderer.parent))
            {
               listContent.removeChild(freeRenderer);
            }
         }
         for(uid in reservedItemRenderers)
         {
            freeRenderer = DisplayObject(reservedItemRenderers[uid]);
            if(Boolean(freeRenderer.parent))
            {
               listContent.removeChild(freeRenderer);
            }
         }
         reservedItemRenderers = {};
         rowMap = {};
         visibleData = {};
      }
      
      protected function seekPendingResultHandler(data:Object, info:ListBaseSeekPending) : void
      {
         if(info != lastSeekPending)
         {
            return;
         }
         lastSeekPending = null;
         iteratorValid = true;
         try
         {
            iterator.seek(info.bookmark,info.offset);
         }
         catch(e:ItemPendingError)
         {
            lastSeekPending = new ListBaseSeekPending(info.bookmark,info.offset);
            e.addResponder(new ItemResponder(seekPendingResultHandler,seekPendingFailureHandler,lastSeekPending));
            iteratorValid = false;
         }
         if(bSortItemPending)
         {
            bSortItemPending = false;
            adjustAfterSort();
         }
         itemsSizeChanged = true;
         invalidateDisplayList();
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
         if(target == listContent)
         {
            pt = new Point(event.stageX,event.stageY);
            pt = listContent.globalToLocal(pt);
            yy = 0;
            n = int(listItems.length);
            for(i = 0; i < n; i++)
            {
               if(Boolean(listItems[i].length))
               {
                  if(pt.y < yy + rowInfo[i].height)
                  {
                     m = int(listItems[i].length);
                     if(m == 1)
                     {
                        return listItems[i][0];
                     }
                     j = Math.floor(pt.x / columnWidth);
                     return listItems[i][j];
                  }
               }
               yy += rowInfo[i].height;
            }
         }
         else if(target == highlightIndicator)
         {
            return lastHighlightItemRenderer;
         }
         while(Boolean(target) && target != this)
         {
            if(target is IListItemRenderer && target.parent == listContent)
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
      
      protected function configureScrollBars() : void
      {
      }
      
      protected function addDragData(ds:Object) : void
      {
         ds.addHandler(copySelectedItems,"items");
      }
      
      protected function getReservedOrFreeItemRenderer(data:Object) : IListItemRenderer
      {
         var item:IListItemRenderer = null;
         var uid:String = null;
         if(runningDataEffect)
         {
            item = IListItemRenderer(reservedItemRenderers[uid = itemToUID(data)]);
         }
         if(Boolean(item))
         {
            delete reservedItemRenderers[uid];
         }
         else if(Boolean(freeItemRenderers.length))
         {
            item = freeItemRenderers.pop();
         }
         return item;
      }
      
      protected function selectData(uid:String, data:Object, index:int, selectedBookmark:CursorBookmark) : void
      {
         if(!selectedData[uid])
         {
            if(Boolean(visibleData[uid]))
            {
               selectItem(visibleData[uid],false,false);
            }
            else
            {
               clearSelected();
               addSelectionData(uid,new ListBaseSelectionData(data,index,approximate));
               _selectedIndex = index;
               caretIndex = index;
               caretBookmark = selectedBookmark;
               anchorIndex = index;
               anchorBookmark = selectedBookmark;
               _selectedItem = data;
            }
         }
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
         for(p in selectedData)
         {
            i++;
         }
         index = Boolean(anchorBookmark) ? int(anchorBookmark.getViewIndex()) : -1;
         if(index >= 0)
         {
            if(i == 1)
            {
               _selectedIndex = anchorIndex = caretIndex = index;
               data = selectedData[p];
               data.index = index;
            }
            newVerticalScrollPosition = indexToRow(index);
            newVerticalScrollPosition = Math.min(maxVerticalScrollPosition,newVerticalScrollPosition);
            newHorizontalScrollPosition = indexToColumn(index);
            newHorizontalScrollPosition = Math.min(maxHorizontalScrollPosition,newHorizontalScrollPosition);
            pos = scrollPositionToIndex(newHorizontalScrollPosition,newVerticalScrollPosition);
            try
            {
               iterator.seek(CursorBookmark.CURRENT,pos - index);
            }
            catch(e:ItemPendingError)
            {
               lastSeekPending = new ListBaseSeekPending(CursorBookmark.CURRENT,pos - index);
               e.addResponder(new ItemResponder(seekPendingResultHandler,seekPendingFailureHandler,lastSeekPending));
               iteratorValid = false;
               return;
            }
            super.verticalScrollPosition = newVerticalScrollPosition;
            if(listType != "vertical")
            {
               super.horizontalScrollPosition = newHorizontalScrollPosition;
            }
         }
         else
         {
            try
            {
               iterator.seek(CursorBookmark.FIRST,verticalScrollPosition);
            }
            catch(e:ItemPendingError)
            {
               lastSeekPending = new ListBaseSeekPending(CursorBookmark.FIRST,verticalScrollPosition);
               e.addResponder(new ItemResponder(seekPendingResultHandler,seekPendingFailureHandler,lastSeekPending));
               iteratorValid = false;
               return;
            }
         }
         if(i > 1)
         {
            commitSelectedItems(selectedItems);
         }
      }
      
      public function set listData(value:BaseListData) : void
      {
         _listData = value;
      }
      
      private function initiateSelectionTracking(renderers:Array) : void
      {
         var renderer:IListItemRenderer = null;
         for(var i:int = 0; i < renderers.length; i++)
         {
            renderer = renderers[i] as IListItemRenderer;
            if(Boolean(selectedData[itemToUID(renderer.data)]))
            {
               renderer.addEventListener(MoveEvent.MOVE,rendererMoveHandler);
               trackedRenderers.push(renderer);
            }
         }
      }
      
      private function setSelectionDataLoop(items:Array, index:int, useFind:Boolean = true) : void
      {
         var uid:String = null;
         var item:Object = null;
         var bookmark:CursorBookmark = null;
         var len:int = 0;
         var data:Object = null;
         var i:int = 0;
         if(useFind)
         {
            while(Boolean(items.length))
            {
               item = items.pop();
               uid = itemToUID(item);
               try
               {
                  collectionIterator.findAny(item);
               }
               catch(e1:ItemPendingError)
               {
                  items.push(item);
                  e1.addResponder(new ItemResponder(selectionDataPendingResultHandler,selectionDataPendingFailureHandler,new ListBaseSelectionDataPending(useFind,0,items,null,0)));
                  return;
               }
               bookmark = collectionIterator.bookmark;
               index = int(bookmark.getViewIndex());
               if(index < 0)
               {
                  try
                  {
                     collectionIterator.seek(CursorBookmark.FIRST,0);
                  }
                  catch(e2:ItemPendingError)
                  {
                     e2.addResponder(new ItemResponder(selectionDataPendingResultHandler,selectionDataPendingFailureHandler,new ListBaseSelectionDataPending(false,0,items,CursorBookmark.FIRST,0)));
                     return;
                  }
                  items.push(item);
                  setSelectionDataLoop(items,0,false);
                  return;
               }
               addSelectionData(uid,new ListBaseSelectionData(item,index,true));
               if(items.length == 0)
               {
                  _selectedIndex = index;
               }
            }
         }
         else
         {
            while(Boolean(items.length) && !collectionIterator.afterLast)
            {
               len = int(items.length);
               data = collectionIterator.current;
               for(i = 0; i < len; i++)
               {
                  if(data == items[i])
                  {
                     uid = itemToUID(data);
                     addSelectionData(uid,new ListBaseSelectionData(data,index,false));
                     items.splice(i,1);
                     if(items.length == 0)
                     {
                        _selectedIndex = index;
                        _selectedItem = data;
                     }
                     break;
                  }
               }
               collectionIterator.moveNext();
               index++;
            }
         }
         if(initialized)
         {
            updateList();
         }
         dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
      }
      
      public function set dragEnabled(value:Boolean) : void
      {
         if(_dragEnabled && !value)
         {
            removeEventListener(DragEvent.DRAG_COMPLETE,dragCompleteHandler,false);
         }
         _dragEnabled = value;
         if(value)
         {
            addEventListener(DragEvent.DRAG_COMPLETE,dragCompleteHandler,false,EventPriority.DEFAULT_HANDLER);
         }
      }
      
      public function set iconFunction(value:Function) : void
      {
         _iconFunction = value;
         itemsSizeChanged = true;
         invalidateDisplayList();
         dispatchEvent(new Event("iconFunctionChanged"));
      }
      
      protected function initiateDataChangeEffect(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var rowItems:Array = null;
         var j:int = 0;
         var target:Object = null;
         actualCollection = collection;
         actualIterator = iterator;
         collection = modifiedCollectionView;
         modifiedCollectionView.showPreservedState = true;
         iterator = collection.createCursor();
         var index:int = scrollPositionToIndex(horizontalScrollPosition - offscreenExtraColumnsLeft,verticalScrollPosition - offscreenExtraRowsTop);
         iterator.seek(CursorBookmark.FIRST,index);
         updateDisplayList(unscaledWidth,unscaledHeight);
         var targets:Array = [];
         var targetHash:Dictionary = new Dictionary(true);
         for(var i:int = 0; i < listItems.length; i++)
         {
            rowItems = listItems[i];
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
         cachedDataChangeEffect.targets = targets;
         if(cachedDataChangeEffect.effectTargetHost != this)
         {
            cachedDataChangeEffect.effectTargetHost = this;
         }
         cachedDataChangeEffect.captureStartValues();
         modifiedCollectionView.showPreservedState = false;
         iterator.seek(CursorBookmark.FIRST,index);
         itemsSizeChanged = true;
         updateDisplayList(unscaledWidth,unscaledHeight);
         var newTargets:Array = [];
         var oldTargets:Array = cachedDataChangeEffect.targets;
         for(i = 0; i < listItems.length; i++)
         {
            rowItems = listItems[i];
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
            cachedDataChangeEffect.targets = oldTargets;
            cachedDataChangeEffect.captureMoreStartValues(newTargets);
         }
         cachedDataChangeEffect.captureEndValues();
         modifiedCollectionView.showPreservedState = true;
         iterator.seek(CursorBookmark.FIRST,index);
         itemsSizeChanged = true;
         updateDisplayList(unscaledWidth,unscaledHeight);
         initiateSelectionTracking(oldTargets);
         cachedDataChangeEffect.addEventListener(EffectEvent.EFFECT_END,finishDataChangeEffect);
         cachedDataChangeEffect.play();
      }
      
      [Inspectable(category="Data")]
      [Bindable("labelFunctionChanged")]
      public function get labelFunction() : Function
      {
         return _labelFunction;
      }
      
      protected function moveIndicators(uid:String, offset:int, absolute:Boolean) : void
      {
         if(Boolean(selectionIndicators[uid]))
         {
            if(absolute)
            {
               selectionIndicators[uid].y = offset;
            }
            else
            {
               selectionIndicators[uid].y += offset;
            }
         }
         if(highlightUID == uid)
         {
            if(absolute)
            {
               highlightIndicator.y = offset;
            }
            else
            {
               highlightIndicator.y += offset;
            }
         }
         if(caretUID == uid)
         {
            if(absolute)
            {
               caretIndicator.y = offset;
            }
            else
            {
               caretIndicator.y += offset;
            }
         }
      }
      
      [Inspectable(category="Data",defaultValue="label")]
      [Bindable("dataTipFieldChanged")]
      public function get dataTipField() : String
      {
         return _dataTipField;
      }
      
      protected function adjustListContent(unscaledWidth:Number = -1, unscaledHeight:Number = -1) : void
      {
         if(unscaledHeight < 0)
         {
            unscaledHeight = oldUnscaledHeight;
            unscaledWidth = oldUnscaledWidth;
         }
         var lcx:Number = viewMetrics.left + listContent.leftOffset;
         var lcy:Number = viewMetrics.top + listContent.topOffset;
         listContent.move(lcx,lcy);
         var ww:Number = Math.max(0,listContent.rightOffset) - lcx - viewMetrics.right;
         var hh:Number = Math.max(0,listContent.bottomOffset) - lcy - viewMetrics.bottom;
         listContent.setActualSize(unscaledWidth + ww,unscaledHeight + hh);
      }
      
      [Inspectable(category="General",defaultValue="-1")]
      [Bindable("valueCommit")]
      [Bindable("change")]
      public function get selectedIndex() : int
      {
         return _selectedIndex;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getCaretIndex() : int
      {
         return caretIndex;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function removeClipMask() : void
      {
         var item:DisplayObject = null;
         if(Boolean(listContent) && Boolean(listContent.mask))
         {
            return;
         }
         var lastRowIndex:int = listItems.length - 1;
         if(lastRowIndex < 0)
         {
            return;
         }
         var rowHeight:Number = Number(rowInfo[lastRowIndex].height);
         var lastRowInfo:ListRowInfo = rowInfo[lastRowIndex];
         var lastRowItems:Array = listItems[lastRowIndex];
         var numColumns:int = int(lastRowItems.length);
         for(var i:int = 0; i < numColumns; i++)
         {
            item = lastRowItems[i];
            if(item is IUITextField)
            {
               if(item.height != rowHeight - (item.y - lastRowInfo.y))
               {
                  item.height = rowHeight - (item.y - lastRowInfo.y);
               }
            }
            else if(Boolean(item) && Boolean(item.mask))
            {
               itemMaskFreeList.push(item.mask);
               item.mask = null;
            }
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function reconstructDataFromListItems() : Array
      {
         var renderer:IListItemRenderer = null;
         var data:Object = null;
         var data2:Object = null;
         var j:int = 0;
         if(!listItems)
         {
            return [];
         }
         var items:Array = [];
         for(var i:int = 0; i < listItems.length; i++)
         {
            if(Boolean(listItems[i]))
            {
               renderer = listItems[i][0] as IListItemRenderer;
               if(Boolean(renderer))
               {
                  data = renderer.data;
                  items.push(data);
                  for(j = 0; j < listItems[i].length; j++)
                  {
                     renderer = listItems[i][j] as IListItemRenderer;
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
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getListContentHolder() : AdvancedListBaseContentHolder
      {
         return listContent;
      }
      
      private function calculateSelectedIndexAndItem() : void
      {
         var p:String = null;
         var num:int = 0;
         var _loc3_:int = 0;
         var _loc4_:* = selectedData;
         for(p in _loc4_)
         {
            num = 1;
         }
         if(!num)
         {
            _selectedIndex = -1;
            _selectedItem = null;
            return;
         }
         _selectedIndex = selectedData[p].index;
         _selectedItem = selectedData[p].data;
      }
      
      public function set dataTipFunction(value:Function) : void
      {
         _dataTipFunction = value;
         itemsSizeChanged = true;
         invalidateDisplayList();
         dispatchEvent(new Event("dataTipFunctionChanged"));
      }
      
      override protected function createChildren() : void
      {
         var g:Graphics = null;
         super.createChildren();
         if(!listContent)
         {
            listContent = new AdvancedListBaseContentHolder(this);
            listContent.styleName = this;
            addChild(listContent);
         }
         if(!selectionLayer)
         {
            selectionLayer = new FlexSprite();
            selectionLayer.name = "selectionLayer";
            selectionLayer.mouseEnabled = false;
            listContent.addChild(selectionLayer);
            g = selectionLayer.graphics;
            g.beginFill(0,0);
            g.drawRect(0,0,10,10);
            g.endFill();
         }
      }
      
      protected function scrollPositionToIndex(horizontalScrollPosition:int, verticalScrollPosition:int) : int
      {
         return Boolean(iterator) ? verticalScrollPosition : -1;
      }
      
      public function findString(str:String) : Boolean
      {
         var stopIndex:int;
         var i:int;
         var cursorPos:CursorBookmark = null;
         var bMovedNext:Boolean = false;
         if(!collection || collection.length == 0)
         {
            return false;
         }
         cursorPos = iterator.bookmark;
         stopIndex = selectedIndex;
         i = stopIndex + 1;
         if(selectedIndex == -1)
         {
            try
            {
               iterator.seek(CursorBookmark.FIRST,0);
            }
            catch(e1:ItemPendingError)
            {
               e1.addResponder(new ItemResponder(findPendingResultHandler,findPendingFailureHandler,new ListBaseFindPending(str,cursorPos,CursorBookmark.FIRST,0,0,collection.length)));
               iteratorValid = false;
               return false;
            }
            stopIndex = int(collection.length);
            i = 0;
         }
         else
         {
            try
            {
               iterator.seek(CursorBookmark.FIRST,stopIndex);
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
               bMovedNext = Boolean(iterator.moveNext());
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
                  iterator.seek(CursorBookmark.FIRST,0);
               }
               catch(e4:ItemPendingError)
               {
                  e4.addResponder(new ItemResponder(findPendingResultHandler,findPendingFailureHandler,new ListBaseFindPending(str,cursorPos,CursorBookmark.FIRST,0,0,collection.length)));
                  iteratorValid = false;
                  return false;
               }
               stopIndex = int(collection.length);
               i = 0;
            }
         }
         return findStringLoop(str,cursorPos,i,stopIndex);
      }
      
      private function commitSelectedItem(data:Object, clearFirst:Boolean = true) : void
      {
         if(clearFirst)
         {
            clearSelected();
         }
         if(data != null)
         {
            commitSelectedItems([data]);
         }
      }
      
      public function showDropFeedback(event:DragEvent) : void
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
            dropIndicator.setActualSize(listContent.width - 4,4);
            dropIndicator.visible = true;
            listContent.addChild(DisplayObject(dropIndicator));
            if(Boolean(collection))
            {
               dragScroll();
            }
         }
         var rowNum:Number = calculateDropIndex(event);
         if(rowNum >= lockedRowCount)
         {
            rowNum -= verticalScrollPosition;
         }
         var rc:Number = listItems.length;
         if(rowNum >= rc)
         {
            rowNum = rc - 1;
         }
         if(rowNum < 0)
         {
            rowNum = 0;
         }
         dropIndicator.y = calculateDropIndicatorY(rc,rowNum);
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
            value = Math.min(value,collection.length - 1);
            bookmark = iterator.bookmark;
            len = value - scrollPositionToIndex(horizontalScrollPosition,verticalScrollPosition);
            try
            {
               iterator.seek(CursorBookmark.CURRENT,len);
            }
            catch(e:ItemPendingError)
            {
               iterator.seek(bookmark,0);
               bSelectedIndexChanged = true;
               _selectedIndex = value;
               return;
            }
            data = iterator.current;
            selectedBookmark = iterator.bookmark;
            uid = itemToUID(data);
            iterator.seek(bookmark,0);
            selectData(uid,data,value,selectedBookmark);
         }
         else
         {
            clearSelected();
         }
         dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
      }
      
      public function set rowHeight(value:Number) : void
      {
         explicitRowHeight = value;
         if(_rowHeight != value)
         {
            setRowHeight(value);
            invalidateSize();
            itemsSizeChanged = true;
            invalidateDisplayList();
            dispatchEvent(new Event("rowHeightChanged"));
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
         return iteratorValid;
      }
      
      public function set data(value:Object) : void
      {
         _data = value;
         if(Boolean(_listData) && _listData is DataGridListData)
         {
            selectedItem = _data[DataGridListData(_listData).dataField];
         }
         else if(_listData is ListData && ListData(_listData).labelField in _data)
         {
            selectedItem = _data[ListData(_listData).labelField];
         }
         else
         {
            selectedItem = _data;
         }
         dispatchEvent(new FlexEvent(FlexEvent.DATA_CHANGE));
      }
      
      public function get rowCount() : int
      {
         return _rowCount;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get rendererArray() : Array
      {
         return listItems;
      }
      
      public function get columnCount() : int
      {
         return _columnCount;
      }
      
      protected function purgeItemRenderers() : void
      {
         var row:Array = null;
         var item:IListItemRenderer = null;
         var freeRenderer:DisplayObject = null;
         rendererChanged = false;
         while(Boolean(listItems.length))
         {
            row = listItems.pop();
            while(Boolean(row.length))
            {
               item = IListItemRenderer(row.pop());
               if(Boolean(item))
               {
                  listContent.removeChild(DisplayObject(item));
                  if(Boolean(dataItemWrappersByRenderer[item]))
                  {
                     delete visibleData[itemToUID(dataItemWrappersByRenderer[item])];
                  }
                  else
                  {
                     delete visibleData[itemToUID(item.data)];
                  }
               }
            }
         }
         while(Boolean(freeItemRenderers.length))
         {
            freeRenderer = DisplayObject(freeItemRenderers.pop());
            if(Boolean(freeRenderer.parent))
            {
               listContent.removeChild(freeRenderer);
            }
         }
         rowMap = {};
         rowInfo = [];
      }
      
      protected function mouseEventToItemRenderer(event:MouseEvent) : IListItemRenderer
      {
         return mouseEventToItemRendererOrEditor(event);
      }
      
      private function findPendingResultHandler(data:Object, info:ListBaseFindPending) : void
      {
         iterator.seek(info.bookmark,info.offset);
         findStringLoop(info.searchString,info.startingBookmark,info.currentIndex,info.stopIndex);
      }
      
      [Inspectable(category="Data")]
      [Bindable("iconFunctionChanged")]
      public function get iconFunction() : Function
      {
         return _iconFunction;
      }
      
      public function get dragEnabled() : Boolean
      {
         return _dragEnabled;
      }
      
      protected function collectionChangeHandler(event:Event) : void
      {
         var len:int = 0;
         var i:int = 0;
         var data:ListBaseSelectionData = null;
         var p:String = null;
         var selectedUID:String = null;
         var ce:CollectionEvent = null;
         var oldUID:String = null;
         var sd:ListBaseSelectionData = null;
         var requiresValueCommit:Boolean = false;
         var firstUID:String = null;
         var emitEvent:Boolean = false;
         var uid:String = null;
         var deletedItems:Array = null;
         var fakeRemove:CollectionEvent = null;
         if(event is CollectionEvent)
         {
            ce = CollectionEvent(event);
            if(ce.kind == CollectionEventKind.ADD)
            {
               prepareDataEffect(ce);
               if(ce.location == 0 && verticalScrollPosition == 0)
               {
                  try
                  {
                     iterator.seek(CursorBookmark.FIRST);
                  }
                  catch(e:ItemPendingError)
                  {
                     lastSeekPending = new ListBaseSeekPending(CursorBookmark.FIRST,0);
                     e.addResponder(new ItemResponder(seekPendingResultHandler,seekPendingFailureHandler,lastSeekPending));
                     iteratorValid = false;
                  }
               }
               else if(listType == "vertical" && verticalScrollPosition >= ce.location)
               {
                  super.verticalScrollPosition += ce.items.length;
               }
               len = int(ce.items.length);
               for(p in selectedData)
               {
                  data = selectedData[p];
                  if(data.index > ce.location)
                  {
                     data.index += len;
                  }
               }
               if(_selectedIndex >= ce.location)
               {
                  _selectedIndex += len;
                  dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
               }
            }
            else if(ce.kind == CollectionEventKind.REPLACE)
            {
               selectedUID = Boolean(selectedItem) ? itemToUID(selectedItem) : null;
               len = int(ce.items.length);
               for(i = 0; i < len; i++)
               {
                  oldUID = itemToUID(ce.items[i].oldValue);
                  sd = selectedData[oldUID];
                  if(Boolean(sd))
                  {
                     sd.data = ce.items[i].newValue;
                     delete selectedData[oldUID];
                     selectedData[itemToUID(sd.data)] = sd;
                     if(selectedUID == oldUID)
                     {
                        _selectedItem = sd.data;
                        dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
                     }
                  }
               }
               prepareDataEffect(ce);
            }
            else if(ce.kind == CollectionEventKind.REMOVE)
            {
               prepareDataEffect(ce);
               requiresValueCommit = false;
               if(Boolean(listItems.length) && Boolean(listItems[lockedRowCount].length))
               {
                  firstUID = rowMap[listItems[lockedRowCount][0].name].uid;
                  selectedUID = Boolean(selectedItem) ? itemToUID(selectedItem) : null;
                  for(i = 0; i < ce.items.length; i++)
                  {
                     uid = itemToUID(ce.items[i]);
                     if(uid == firstUID && verticalScrollPosition == 0)
                     {
                        try
                        {
                           iterator.seek(CursorBookmark.FIRST);
                        }
                        catch(e1:ItemPendingError)
                        {
                           lastSeekPending = new ListBaseSeekPending(CursorBookmark.FIRST,0);
                           e1.addResponder(new ItemResponder(seekPendingResultHandler,seekPendingFailureHandler,lastSeekPending));
                           iteratorValid = false;
                        }
                     }
                     if(Boolean(selectedData[uid]))
                     {
                        removeSelectionData(uid);
                     }
                     if(selectedUID == uid)
                     {
                        _selectedItem = null;
                        _selectedIndex = -1;
                        requiresValueCommit = true;
                     }
                     removeIndicators(uid);
                  }
                  if(listType == "vertical" && verticalScrollPosition >= ce.location)
                  {
                     if(verticalScrollPosition > ce.location)
                     {
                        super.verticalScrollPosition = verticalScrollPosition - Math.min(ce.items.length,verticalScrollPosition - ce.location);
                     }
                     else if(verticalScrollPosition >= collection.length)
                     {
                        super.verticalScrollPosition = Math.max(collection.length - 1,0);
                     }
                     try
                     {
                        offscreenExtraRowsTop = Math.min(offscreenExtraRowsTop,verticalScrollPosition);
                        iterator.seek(CursorBookmark.FIRST,verticalScrollPosition - offscreenExtraRowsTop);
                     }
                     catch(e2:ItemPendingError)
                     {
                        lastSeekPending = new ListBaseSeekPending(CursorBookmark.FIRST,verticalScrollPosition - offscreenExtraRowsTop);
                        e2.addResponder(new ItemResponder(seekPendingResultHandler,seekPendingFailureHandler,lastSeekPending));
                        iteratorValid = false;
                     }
                  }
                  emitEvent = adjustAfterRemove(ce.items,ce.location,requiresValueCommit);
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
                  for(p in selectedData)
                  {
                     data = selectedData[p];
                     if(data.index > ce.oldLocation && data.index < ce.location)
                     {
                        --data.index;
                     }
                     else if(data.index == ce.oldLocation)
                     {
                        data.index = ce.location;
                     }
                  }
                  if(_selectedIndex > ce.oldLocation && _selectedIndex < ce.location)
                  {
                     --_selectedIndex;
                  }
                  else if(_selectedIndex == ce.oldLocation)
                  {
                     _selectedIndex = ce.location;
                  }
               }
               else if(ce.location < ce.oldLocation)
               {
                  for(p in selectedData)
                  {
                     data = selectedData[p];
                     if(data.index > ce.location && data.index < ce.oldLocation)
                     {
                        ++data.index;
                     }
                     else if(data.index == ce.oldLocation)
                     {
                        data.index = ce.location;
                     }
                  }
                  if(_selectedIndex > ce.location && _selectedIndex < ce.oldLocation)
                  {
                     ++_selectedIndex;
                  }
                  else if(_selectedIndex == ce.oldLocation)
                  {
                     _selectedIndex = ce.location;
                  }
               }
               if(ce.oldLocation == verticalScrollPosition)
               {
                  if(ce.location > maxVerticalScrollPosition)
                  {
                     iterator.seek(CursorBookmark.CURRENT,maxVerticalScrollPosition - ce.location);
                  }
                  super.verticalScrollPosition = Math.min(ce.location,maxVerticalScrollPosition);
               }
               else if(ce.location >= verticalScrollPosition && ce.oldLocation < verticalScrollPosition)
               {
                  seekNextSafely(iterator,verticalScrollPosition);
               }
               else if(ce.location <= verticalScrollPosition && ce.oldLocation > verticalScrollPosition)
               {
                  seekPreviousSafely(iterator,verticalScrollPosition);
               }
            }
            else if(ce.kind == CollectionEventKind.REFRESH)
            {
               if(Boolean(anchorBookmark))
               {
                  try
                  {
                     iterator.seek(anchorBookmark,0);
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
                  adjustAfterSort();
               }
               else
               {
                  try
                  {
                     iterator.seek(CursorBookmark.FIRST,verticalScrollPosition);
                  }
                  catch(e:ItemPendingError)
                  {
                     bSortItemPending = true;
                     lastSeekPending = new ListBaseSeekPending(CursorBookmark.FIRST,verticalScrollPosition);
                     e.addResponder(new ItemResponder(seekPendingResultHandler,seekPendingFailureHandler,lastSeekPending));
                     iteratorValid = false;
                  }
               }
            }
            else if(ce.kind == CollectionEventKind.RESET)
            {
               if(collection.length == 0 || runningDataEffect && actualCollection.length == 0)
               {
                  deletedItems = reconstructDataFromListItems();
                  if(Boolean(deletedItems.length))
                  {
                     fakeRemove = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
                     fakeRemove.kind = CollectionEventKind.REMOVE;
                     fakeRemove.items = deletedItems;
                     fakeRemove.location = 0;
                     prepareDataEffect(fakeRemove);
                  }
               }
               try
               {
                  iterator.seek(CursorBookmark.FIRST);
                  collectionIterator.seek(CursorBookmark.FIRST);
               }
               catch(e:ItemPendingError)
               {
                  lastSeekPending = new ListBaseSeekPending(CursorBookmark.FIRST,0);
                  e.addResponder(new ItemResponder(seekPendingResultHandler,seekPendingFailureHandler,lastSeekPending));
                  iteratorValid = false;
               }
               if(bSelectedIndexChanged || bSelectedItemChanged || bSelectedIndicesChanged || bSelectedItemsChanged)
               {
                  bSelectionChanged = true;
               }
               else
               {
                  commitSelectedIndex(-1);
               }
               if(isNaN(verticalScrollPositionPending))
               {
                  verticalScrollPositionPending = 0;
                  super.verticalScrollPosition = 0;
               }
               if(isNaN(horizontalScrollPositionPending))
               {
                  horizontalScrollPositionPending = 0;
                  super.horizontalScrollPosition = 0;
               }
               invalidateSize();
            }
         }
         itemsSizeChanged = true;
         invalidateDisplayList();
      }
      
      public function set dataProvider(value:Object) : void
      {
         var xl:XMLList = null;
         var tmp:Array = null;
         if(Boolean(collection))
         {
            collection.removeEventListener(CollectionEvent.COLLECTION_CHANGE,collectionChangeHandler);
         }
         if(value is Array)
         {
            collection = new ArrayCollection(value as Array);
         }
         else if(value is ICollectionView)
         {
            collection = ICollectionView(value);
         }
         else if(value is IList)
         {
            collection = new ListCollectionView(IList(value));
         }
         else if(value is XMLList)
         {
            collection = new XMLListCollection(value as XMLList);
         }
         else if(value is XML)
         {
            xl = new XMLList();
            xl += value;
            collection = new XMLListCollection(xl);
         }
         else
         {
            tmp = [];
            if(value != null)
            {
               tmp.push(value);
            }
            collection = new ArrayCollection(tmp);
         }
         iterator = collection.createCursor();
         collectionIterator = collection.createCursor();
         collection.addEventListener(CollectionEvent.COLLECTION_CHANGE,collectionChangeHandler,false,0,true);
         clearSelectionData();
         var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
         event.kind = CollectionEventKind.RESET;
         collectionChangeHandler(event);
         dispatchEvent(event);
         itemsNeedMeasurement = true;
         invalidateProperties();
         invalidateSize();
         invalidateDisplayList();
      }
      
      private function destroyRow(i:int, numCols:int) : void
      {
         var r:IListItemRenderer = null;
         var uid:String = rowInfo[i].uid;
         removeIndicators(uid);
         for(var j:int = 0; j < numCols; j++)
         {
            r = listItems[i][j];
            if(Boolean(r.data))
            {
               delete visibleData[uid];
            }
            addToFreeItemRenderers(r);
         }
      }
      
      protected function dragDropHandler(event:DragEvent) : void
      {
         var items:Array = null;
         var dropIndex:int = 0;
         var indices:Array = null;
         var n:int = 0;
         var i:int = 0;
         if(event.isDefaultPrevented())
         {
            return;
         }
         hideDropFeedback(event);
         if(event.dragSource.hasFormat("items"))
         {
            if(!dataProvider)
            {
               dataProvider = [];
            }
            items = event.dragSource.dataForFormat("items") as Array;
            dropIndex = calculateDropIndex(event);
            if(event.action == DragManager.MOVE && dragMoveEnabled)
            {
               if(event.dragInitiator == this)
               {
                  indices = selectedIndices;
                  indices.sort(Array.NUMERIC);
                  n = int(indices.length);
                  for(i = n - 1; i >= 0; i--)
                  {
                     collectionIterator.seek(CursorBookmark.FIRST,indices[i]);
                     if(indices[i] < dropIndex)
                     {
                        dropIndex--;
                     }
                     collectionIterator.remove();
                  }
                  clearSelected(false);
               }
            }
            collectionIterator.seek(CursorBookmark.FIRST,dropIndex);
            for(i = items.length - 1; i >= 0; i--)
            {
               collectionIterator.insert(items[i]);
            }
         }
      }
      
      [Inspectable(category="Data")]
      [Bindable("dataTipFunctionChanged")]
      public function get dataTipFunction() : Function
      {
         return _dataTipFunction;
      }
      
      public function scrollToIndex(index:int) : Boolean
      {
         var newVPos:int = 0;
         if(index >= verticalScrollPosition + listItems.length - lockedRowCount - offscreenExtraRowsBottom || index < verticalScrollPosition)
         {
            newVPos = Math.min(index,maxVerticalScrollPosition);
            verticalScrollPosition = newVPos;
            return true;
         }
         return false;
      }
      
      protected function addToFreeItemRenderers(item:IListItemRenderer) : void
      {
         DisplayObject(item).visible = false;
         var oldWrapper:ItemWrapper = dataItemWrappersByRenderer[item];
         var UID:String = Boolean(oldWrapper) ? itemToUID(oldWrapper) : itemToUID(item.data);
         if(visibleData[UID] == item)
         {
            delete visibleData[UID];
         }
         if(Boolean(oldWrapper))
         {
            reservedItemRenderers[itemToUID(oldWrapper)] = item;
         }
         else
         {
            freeItemRenderers.push(item);
         }
         delete rowMap[item.name];
      }
      
      public function isItemSelectable(data:Object) : Boolean
      {
         if(!selectable)
         {
            return false;
         }
         if(data == null)
         {
            return false;
         }
         return true;
      }
      
      override protected function initializeAccessibility() : void
      {
      }
      
      private function findPendingFailureHandler(data:Object, info:ListBaseFindPending) : void
      {
      }
      
      [Inspectable(category="General")]
      public function get rowHeight() : Number
      {
         return _rowHeight;
      }
      
      [Inspectable(environment="none")]
      [Bindable("dataChange")]
      public function get data() : Object
      {
         return _data;
      }
      
      protected function indexToRow(index:int) : int
      {
         return index;
      }
      
      protected function get dragImageOffsets() : Point
      {
         var pt:Point = new Point();
         var n:int = int(listItems.length);
         for(var i:int = lockedRowCount; i < n; i++)
         {
            if(Boolean(selectedData[rowInfo[i].uid]))
            {
               pt.x = listItems[i][0].x;
               pt.y = listItems[i][0].y;
            }
         }
         return pt;
      }
      
      [Inspectable(category="Data",defaultValue="undefined")]
      [Bindable("collectionChange")]
      public function get dataProvider() : Object
      {
         if(Boolean(actualCollection))
         {
            return actualCollection;
         }
         return collection;
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         var n:int = 0;
         var i:int = 0;
         var m:int = 0;
         var j:int = 0;
         if(Boolean(IS_ITEM_STYLE[styleProp]))
         {
            itemsSizeChanged = true;
            invalidateDisplayList();
         }
         else if(styleProp == "paddingTop")
         {
            cachedPaddingTopInvalid = true;
            invalidateProperties();
         }
         else if(styleProp == "paddingBottom")
         {
            cachedPaddingBottomInvalid = true;
            invalidateProperties();
         }
         else if(styleProp == "verticalAlign")
         {
            cachedVerticalAlignInvalid = true;
            invalidateProperties();
         }
         else if(styleProp == "dataChangeEffect")
         {
            cachedDataChangeEffect = null;
         }
         else if(Boolean(listItems))
         {
            n = int(listItems.length);
            for(i = 0; i < n; i++)
            {
               m = int(listItems[i].length);
               for(j = 0; j < m; j++)
               {
                  if(Boolean(listItems[i][j]))
                  {
                     listItems[i][j].styleChanged(styleProp);
                  }
               }
            }
         }
         super.styleChanged(styleProp);
         if(invalidateSizeFlag)
         {
            itemsNeedMeasurement = true;
            invalidateProperties();
         }
         if(StyleManager.isSizeInvalidatingStyle(styleProp))
         {
            scrollAreaChanged = true;
         }
      }
      
      private function selectionPendingResultHandler(data:Object, info:ListBaseSelectionPending) : void
      {
         iterator.seek(info.bookmark,info.offset);
         shiftSelectionLoop(info.incrementing,info.index,info.stopData,info.transition,info.placeHolder);
      }
      
      public function set selectedItems(items:Array) : void
      {
         if(!collection || collection.length == 0)
         {
            _selectedItems = items;
            bSelectedItemsChanged = true;
            bSelectionChanged = true;
            invalidateDisplayList();
            return;
         }
         commitSelectedItems(items);
      }
      
      private function mouseIsUp() : void
      {
         systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_UP,mouseUpHandler,true);
         systemManager.getSandboxRoot().removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,mouseLeaveHandler);
         if(!dragEnabled && dragScrollingInterval != 0)
         {
            clearInterval(dragScrollingInterval);
            dragScrollingInterval = 0;
         }
      }
      
      public function itemToDataTip(data:Object) : String
      {
         if(dataTipFunction != null)
         {
            return dataTipFunction(data);
         }
         if(typeof data == "object")
         {
            try
            {
               if(data[dataTipField] != null)
               {
                  data = data[dataTipField];
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
         if(typeof data == "string")
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
      
      protected function dragStartHandler(event:DragEvent) : void
      {
         var dragSource:DragSource = null;
         if(event.isDefaultPrevented())
         {
            return;
         }
         dragSource = new DragSource();
         addDragData(dragSource);
         DragManager.doDrag(this,dragSource,event,dragImage,0,0,0.5,dragMoveEnabled);
      }
      
      private function cleanupAfterDataChangeEffect() : void
      {
         if(runningDataEffect || runDataEffectNextUpdate)
         {
            return;
         }
         var index:int = scrollPositionToIndex(horizontalScrollPosition - offscreenExtraColumnsLeft,verticalScrollPosition - offscreenExtraRowsTop);
         iterator.seek(CursorBookmark.FIRST,index);
         dataEffectCompleted = true;
         itemsSizeChanged = true;
         invalidateList();
         dataItemWrappersByRenderer = new Dictionary();
      }
      
      public function set lockedColumnCount(value:int) : void
      {
         _lockedColumnCount = value;
         invalidateDisplayList();
      }
      
      protected function removeIndicators(uid:String) : void
      {
         if(Boolean(selectionTweens[uid]))
         {
            selectionTweens[uid].removeEventListener(TweenEvent.TWEEN_UPDATE,selectionTween_updateHandler);
            selectionTweens[uid].removeEventListener(TweenEvent.TWEEN_END,selectionTween_endHandler);
            if(selectionIndicators[uid].alpha < 1)
            {
               Tween.removeTween(selectionTweens[uid]);
            }
            delete selectionTweens[uid];
         }
         if(Boolean(selectionIndicators[uid]))
         {
            selectionLayer.removeChild(selectionIndicators[uid]);
            selectionIndicators[uid] = null;
         }
         if(uid == highlightUID)
         {
            highlightItemRenderer = null;
            highlightUID = null;
            if(Boolean(highlightIndicator))
            {
               Sprite(highlightIndicator).graphics.clear();
            }
         }
         if(uid == caretUID)
         {
            caretItemRenderer = null;
            caretUID = null;
            if(Boolean(caretIndicator))
            {
               Sprite(caretIndicator).graphics.clear();
            }
         }
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var cursorPos:CursorBookmark = null;
         var rowIndex:int = 0;
         if(oldUnscaledWidth == unscaledWidth && oldUnscaledHeight == unscaledHeight && !itemsSizeChanged && !bSelectionChanged && !scrollAreaChanged)
         {
            return;
         }
         if(oldUnscaledWidth != unscaledWidth)
         {
            itemsSizeChanged = true;
         }
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         adjustListContent(unscaledWidth,unscaledHeight);
         var collectionHasItems:Boolean = Boolean(collection) && collection.length > 0;
         if(collectionHasItems)
         {
            adjustScrollPosition();
         }
         removeClipMask();
         var g:Graphics = selectionLayer.graphics;
         g.clear();
         if(listContent.width > 0 && listContent.height > 0)
         {
            g.beginFill(8421504,0);
            g.drawRect(0,0,listContent.width,listContent.height);
            g.endFill();
         }
         if(rendererChanged)
         {
            purgeItemRenderers();
         }
         else if(dataEffectCompleted)
         {
            partialPurgeItemRenderers();
         }
         if(Boolean(oldUnscaledWidth == unscaledWidth && !scrollAreaChanged && !itemsSizeChanged && listItems.length > 0) && Boolean(iterator) && columnCount == 1)
         {
            rowIndex = listItems.length - 1;
            if(oldUnscaledHeight > unscaledHeight)
            {
               reduceRows(rowIndex);
            }
            else
            {
               makeAdditionalRows(rowIndex);
            }
         }
         else
         {
            if(Boolean(iterator))
            {
               cursorPos = iterator.bookmark;
            }
            clearIndicators();
            if(Boolean(iterator))
            {
               if(Boolean(offscreenExtraColumns))
               {
                  makeRowsAndColumnsWithExtraColumns(unscaledWidth,unscaledHeight);
               }
               else
               {
                  makeRowsAndColumnsWithExtraRows(unscaledWidth,unscaledHeight);
               }
            }
            else
            {
               makeRowsAndColumns(0,0,listContent.width,listContent.height,0,0);
            }
            seekPositionIgnoreError(iterator,cursorPos);
         }
         oldUnscaledWidth = unscaledWidth;
         oldUnscaledHeight = unscaledHeight;
         configureScrollBars();
         addClipMask(true);
         itemsSizeChanged = false;
         wordWrapChanged = false;
         adjustSelectionSettings(collectionHasItems);
         if(keySelectionPending && iteratorValid)
         {
            keySelectionPending = false;
            finishKeySelection();
         }
      }
      
      protected function dragCompleteHandler(event:DragEvent) : void
      {
         var indices:Array = null;
         var n:int = 0;
         var i:int = 0;
         isPressed = false;
         if(event.isDefaultPrevented())
         {
            return;
         }
         if(event.action == DragManager.MOVE && dragMoveEnabled)
         {
            if(event.relatedObject != this)
            {
               indices = selectedIndices;
               indices.sort(Array.NUMERIC);
               n = int(indices.length);
               for(i = n - 1; i >= 0; i--)
               {
                  collectionIterator.seek(CursorBookmark.FIRST,indices[i]);
                  collectionIterator.remove();
               }
               clearSelected(false);
            }
         }
      }
   }
}

