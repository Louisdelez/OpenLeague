package mx.controls
{
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   import mx.collections.CursorBookmark;
   import mx.collections.IList;
   import mx.collections.ItemResponder;
   import mx.collections.ItemWrapper;
   import mx.collections.ModifiedCollectionView;
   import mx.collections.errors.ItemPendingError;
   import mx.controls.listClasses.BaseListData;
   import mx.controls.listClasses.IDropInListItemRenderer;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.controls.listClasses.ListBase;
   import mx.controls.listClasses.ListBaseSeekPending;
   import mx.controls.listClasses.ListData;
   import mx.controls.listClasses.ListItemRenderer;
   import mx.controls.listClasses.ListRowInfo;
   import mx.controls.scrollClasses.ScrollBar;
   import mx.core.ClassFactory;
   import mx.core.EdgeMetrics;
   import mx.core.EventPriority;
   import mx.core.FlexShape;
   import mx.core.FlexSprite;
   import mx.core.IFactory;
   import mx.core.IIMESupport;
   import mx.core.IInvalidating;
   import mx.core.IPropertyChangeNotifier;
   import mx.core.ScrollPolicy;
   import mx.core.UIComponent;
   import mx.core.UIComponentGlobals;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.events.ListEvent;
   import mx.events.ListEventReason;
   import mx.events.SandboxMouseEvent;
   import mx.events.ScrollEvent;
   import mx.events.ScrollEventDetail;
   import mx.managers.IFocusManager;
   import mx.managers.IFocusManagerComponent;
   
   [Alternative(replacement="spark.components.List",since="4.0")]
   [Effect(name="itemsChangeEffect",event="itemsChange")]
   [Event(name="itemFocusOut",type="mx.events.ListEvent")]
   [Event(name="itemFocusIn",type="mx.events.ListEvent")]
   [Event(name="itemEditEnd",type="mx.events.ListEvent")]
   [Event(name="itemEditBegin",type="mx.events.ListEvent")]
   [Event(name="itemEditBeginning",type="mx.events.ListEvent")]
   [AccessibilityClass(implementation="mx.accessibility.ListAccImpl")]
   [DefaultTriggerEvent("change")]
   [DefaultBindingProperty(source="selectedItem",destination="dataProvider")]
   [DefaultProperty("dataProvider")]
   [DataBindingInfo("{ dataProvider: { label: &quot;String&quot; } }")]
   [IconFile("List.png")]
   public class List extends ListBase implements IIMESupport
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static var createAccessibilityImplementation:Function;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public var itemEditorInstance:IListItemRenderer;
      
      private var dontEdit:Boolean = false;
      
      private var losingFocus:Boolean = false;
      
      private var inEndEdit:Boolean = false;
      
      private var actualRowIndex:int;
      
      private var actualColIndex:int = 0;
      
      protected var measuringObjects:Dictionary;
      
      private var _editable:Boolean = false;
      
      [Inspectable(category="Data")]
      public var itemEditor:IFactory;
      
      [Inspectable(category="Data")]
      public var editorDataField:String = "text";
      
      [Inspectable(defaultValue="0")]
      public var editorHeightOffset:Number = 0;
      
      [Inspectable(defaultValue="0")]
      public var editorWidthOffset:Number = 0;
      
      [Inspectable(defaultValue="0")]
      public var editorXOffset:Number = 0;
      
      [Inspectable(defaultValue="0")]
      public var editorYOffset:Number = 0;
      
      [Inspectable(defaultValue="false")]
      public var editorUsesEnterKey:Boolean = false;
      
      private var bEditedItemPositionChanged:Boolean = false;
      
      private var _proposedEditedItemPosition:*;
      
      private var lastEditedItemPosition:*;
      
      private var _editedItemPosition:Object;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _lockedRowCount:int = 0;
      
      [Inspectable(category="Data",defaultValue="false")]
      public var rendererIsEditor:Boolean = false;
      
      private var _imeMode:String;
      
      public function List()
      {
         super();
         listType = "vertical";
         bColumnScrolling = false;
         this.itemRenderer = new ClassFactory(ListItemRenderer);
         _horizontalScrollPolicy = ScrollPolicy.OFF;
         _verticalScrollPolicy = ScrollPolicy.AUTO;
         defaultColumnCount = 1;
         defaultRowCount = 7;
         addEventListener(ListEvent.ITEM_EDIT_BEGINNING,this.itemEditorItemEditBeginningHandler,false,EventPriority.DEFAULT_HANDLER);
         addEventListener(ListEvent.ITEM_EDIT_BEGIN,this.itemEditorItemEditBeginHandler,false,EventPriority.DEFAULT_HANDLER);
         addEventListener(ListEvent.ITEM_EDIT_END,this.itemEditorItemEditEndHandler,false,EventPriority.DEFAULT_HANDLER);
      }
      
      public function get editedItemRenderer() : IListItemRenderer
      {
         if(!this.itemEditorInstance)
         {
            return null;
         }
         return listItems[this.actualRowIndex][this.actualColIndex];
      }
      
      override public function set maxHorizontalScrollPosition(value:Number) : void
      {
         super.maxHorizontalScrollPosition = value;
         scrollAreaChanged = true;
         invalidateDisplayList();
      }
      
      [Inspectable(category="General")]
      public function get editable() : Boolean
      {
         return this._editable;
      }
      
      public function set editable(value:Boolean) : void
      {
         this._editable = value;
      }
      
      [Inspectable(category="General",enumeration="true,false",defaultValue="true")]
      override public function set enabled(value:Boolean) : void
      {
         super.enabled = value;
         if(Boolean(this.itemEditorInstance))
         {
            this.endEdit(ListEventReason.OTHER);
         }
         invalidateDisplayList();
      }
      
      [Bindable("itemFocusIn")]
      public function get editedItemPosition() : Object
      {
         if(Boolean(this._editedItemPosition))
         {
            return {
               "rowIndex":this._editedItemPosition.rowIndex,
               "columnIndex":0
            };
         }
         return this._editedItemPosition;
      }
      
      public function set editedItemPosition(value:Object) : void
      {
         var newValue:Object = {
            "rowIndex":value.rowIndex,
            "columnIndex":0
         };
         this.setEditedItemPosition(newValue);
      }
      
      public function get enableIME() : Boolean
      {
         return false;
      }
      
      [Inspectable(defaultValue="0")]
      public function get lockedRowCount() : int
      {
         return this._lockedRowCount;
      }
      
      public function set lockedRowCount(value:int) : void
      {
         this._lockedRowCount = value;
         invalidateDisplayList();
      }
      
      public function get imeMode() : String
      {
         return this._imeMode;
      }
      
      public function set imeMode(value:String) : void
      {
         this._imeMode = value;
      }
      
      [Inspectable(category="Data",defaultValue="undefined")]
      override public function set dataProvider(value:Object) : void
      {
         if(Boolean(this.itemEditorInstance))
         {
            this.endEdit(ListEventReason.OTHER);
         }
         super.dataProvider = value;
      }
      
      override protected function initializeAccessibility() : void
      {
         if(createAccessibilityImplementation != null)
         {
            createAccessibilityImplementation(this);
         }
      }
      
      override protected function commitProperties() : void
      {
         var paddingTop:Number = NaN;
         var paddingBottom:Number = NaN;
         var item:IListItemRenderer = null;
         var ww:Number = NaN;
         var rh:int = 0;
         super.commitProperties();
         if(itemsNeedMeasurement)
         {
            itemsNeedMeasurement = false;
            if(isNaN(explicitRowHeight))
            {
               if(Boolean(iterator))
               {
                  paddingTop = Number(getStyle("paddingTop"));
                  paddingBottom = Number(getStyle("paddingBottom"));
                  item = this.getMeasuringRenderer(iterator.current);
                  ww = 200;
                  if(Boolean(listContent.width))
                  {
                     ww = Number(listContent.width);
                  }
                  item.explicitWidth = ww;
                  this.setupRendererFromData(item,iterator.current);
                  rh = item.getExplicitOrMeasuredHeight() + paddingTop + paddingBottom;
                  setRowHeight(Math.max(rh,20));
               }
               else
               {
                  setRowHeight(20);
               }
            }
            if(isNaN(explicitColumnWidth))
            {
               setColumnWidth(this.measureWidthOfItems(0,explicitRowCount < 1 ? defaultRowCount : explicitRowCount));
            }
         }
      }
      
      override protected function measure() : void
      {
         super.measure();
         var o:EdgeMetrics = viewMetrics;
         measuredMinWidth = DEFAULT_MEASURED_MIN_WIDTH;
         if(Boolean(initialized) && variableRowHeight && explicitRowCount < 1 && isNaN(explicitRowHeight))
         {
            measuredHeight = height;
         }
      }
      
      override protected function configureScrollBars() : void
      {
         var yy:Number = NaN;
         var i:int = 0;
         var bookmark:CursorBookmark = null;
         var rowIndex:int = 0;
         var rowCount:int = int(listItems.length);
         if(rowCount == 0)
         {
            return;
         }
         var n:int = int(listItems.length);
         while(rowCount > 1 && rowInfo[n - 1].y + rowInfo[n - 1].height > listContent.height - listContent.bottomOffset)
         {
            rowCount--;
            n--;
         }
         var offset:int = verticalScrollPosition - this.lockedRowCount - 1;
         var fillerRows:int = 0;
         while(Boolean(rowCount) && listItems[rowCount - 1].length == 0)
         {
            if(!(Boolean(collection) && rowCount + offset >= collection.length))
            {
               break;
            }
            rowCount--;
            fillerRows++;
         }
         if(verticalScrollPosition > 0 && fillerRows > 0 && !runningDataEffect)
         {
            bookmark = iterator.bookmark;
            rowIndex = int(bookmark.getViewIndex());
            if(verticalScrollPosition != rowIndex - this.lockedRowCount)
            {
               super.verticalScrollPosition = Math.max(rowIndex - this.lockedRowCount,0);
            }
            if(this.adjustVerticalScrollPositionDownward(Math.max(rowCount,1)))
            {
               return;
            }
         }
         if(Boolean(listContent.topOffset))
         {
            yy = Math.abs(listContent.topOffset);
            i = 0;
            while(rowInfo[i].y + rowInfo[i].height <= yy)
            {
               rowCount--;
               i++;
               if(i == rowCount)
               {
                  break;
               }
            }
         }
         var colCount:int = int(listItems[0].length);
         var oldHorizontalScrollBar:Object = horizontalScrollBar;
         var oldVerticalScrollBar:Object = verticalScrollBar;
         var roundedWidth:int = Math.round(unscaledWidth);
         var length:int = Boolean(collection) ? int(collection.length - this.lockedRowCount) : 0;
         var numRows:int = rowCount - this.lockedRowCount;
         setScrollBarProperties(isNaN(_maxHorizontalScrollPosition) ? int(Math.round(listContent.width)) : int(Math.round(_maxHorizontalScrollPosition + roundedWidth)),roundedWidth,length,numRows);
         maxVerticalScrollPosition = Math.max(length - numRows,0);
      }
      
      private function adjustVerticalScrollPositionDownward(rowCount:int) : Boolean
      {
         var item:IListItemRenderer;
         var n:int = 0;
         var j:int = 0;
         var more:Boolean = false;
         var data:Object = null;
         var bookmark:CursorBookmark = iterator.bookmark;
         var h:Number = 0;
         var ch:Number = 0;
         var paddingTop:Number = Number(getStyle("paddingTop"));
         var paddingBottom:Number = Number(getStyle("paddingBottom"));
         var paddingLeft:Number = Number(getStyle("paddingLeft"));
         var paddingRight:Number = Number(getStyle("paddingRight"));
         h = rowInfo[rowCount - 1].y + rowInfo[rowCount - 1].height;
         h = listContent.heightExcludingOffsets - listContent.topOffset - h;
         var numRows:int = 0;
         try
         {
            if(iterator.afterLast)
            {
               iterator.seek(CursorBookmark.LAST,0);
            }
            else
            {
               more = Boolean(iterator.movePrevious());
            }
         }
         catch(e:ItemPendingError)
         {
            more = false;
         }
         if(!more)
         {
            super.verticalScrollPosition = 0;
            try
            {
               iterator.seek(CursorBookmark.FIRST,0);
               if(!iteratorValid)
               {
                  iteratorValid = true;
                  lastSeekPending = null;
               }
            }
            catch(e:ItemPendingError)
            {
               lastSeekPending = new ListBaseSeekPending(CursorBookmark.FIRST,0);
               e.addResponder(new ItemResponder(seekPendingResultHandler,seekPendingFailureHandler,lastSeekPending));
               iteratorValid = false;
               invalidateList();
               return true;
            }
            updateList();
            return true;
         }
         item = this.getMeasuringRenderer(iterator.current);
         item.explicitWidth = listContent.width - paddingLeft - paddingRight;
         while(h > 0 && more)
         {
            if(more)
            {
               data = iterator.current;
               this.setupRendererFromData(item,data);
               ch = variableRowHeight ? item.getExplicitOrMeasuredHeight() + paddingBottom + paddingTop : rowHeight;
            }
            h -= ch;
            try
            {
               more = Boolean(iterator.movePrevious());
               numRows++;
            }
            catch(e:ItemPendingError)
            {
               more = false;
            }
         }
         if(h < 0)
         {
            numRows--;
         }
         iterator.seek(bookmark,0);
         verticalScrollPosition = Math.max(0,verticalScrollPosition - numRows);
         if(numRows > 0 && !variableRowHeight)
         {
            this.configureScrollBars();
         }
         return numRows > 0;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         setRowCount(listItems.length);
         if(this.bEditedItemPositionChanged && !this.editingTemporarilyPrevented(this._proposedEditedItemPosition))
         {
            this.bEditedItemPositionChanged = false;
            this.commitEditedItemPosition(this._proposedEditedItemPosition);
            this._proposedEditedItemPosition = undefined;
         }
         this.drawRowBackgrounds();
      }
      
      override protected function adjustListContent(unscaledWidth:Number = -1, unscaledHeight:Number = -1) : void
      {
         var lcx:Number = viewMetrics.left + Math.max(listContent.leftOffset,0);
         var lcy:Number = viewMetrics.top + listContent.topOffset;
         listContent.move(lcx,lcy);
         var ww:Number = Math.max(0,listContent.rightOffset) - lcx - viewMetrics.right;
         var hh:Number = Math.max(0,listContent.bottomOffset) - lcy - viewMetrics.bottom;
         var scrollableWidth:Number = unscaledWidth + ww;
         if(horizontalScrollPolicy == ScrollPolicy.ON || horizontalScrollPolicy == ScrollPolicy.AUTO && !isNaN(_maxHorizontalScrollPosition))
         {
            if(isNaN(_maxHorizontalScrollPosition))
            {
               scrollableWidth *= 2;
            }
            else
            {
               scrollableWidth += _maxHorizontalScrollPosition;
            }
         }
         listContent.setActualSize(scrollableWidth,unscaledHeight + hh);
      }
      
      override protected function drawRowBackgrounds() : void
      {
         var colors:Array = null;
         var n:int = 0;
         var rowBGs:Sprite = Sprite(listContent.getChildByName("rowBGs"));
         if(!rowBGs)
         {
            rowBGs = new FlexSprite();
            rowBGs.mouseEnabled = false;
            rowBGs.name = "rowBGs";
            listContent.addChildAt(rowBGs,0);
         }
         var colorsStyle:Object = getStyle("alternatingItemColors");
         if(Boolean(colorsStyle))
         {
            colors = colorsStyle is Array ? colorsStyle as Array : [colorsStyle];
         }
         if(!colors || colors.length == 0)
         {
            while(rowBGs.numChildren > n)
            {
               rowBGs.removeChildAt(rowBGs.numChildren - 1);
            }
            return;
         }
         styleManager.getColorNames(colors);
         var curRow:int = 0;
         var actualRow:int = verticalScrollPosition;
         var i:int = 0;
         n = int(listItems.length);
         while(curRow < n)
         {
            this.drawRowBackground(rowBGs,i++,rowInfo[curRow].y,rowInfo[curRow].height,colors[actualRow % colors.length],actualRow);
            curRow++;
            actualRow++;
         }
         while(rowBGs.numChildren > n)
         {
            rowBGs.removeChildAt(rowBGs.numChildren - 1);
         }
      }
      
      protected function drawRowBackground(s:Sprite, rowIndex:int, y:Number, height:Number, color:uint, dataIndex:int) : void
      {
         var bg:Shape = null;
         if(rowIndex < s.numChildren)
         {
            bg = Shape(s.getChildAt(rowIndex));
         }
         else
         {
            bg = new FlexShape();
            bg.name = "rowBackground";
            s.addChild(bg);
         }
         height = Math.min(rowInfo[rowIndex].height,listContent.height - rowInfo[rowIndex].y);
         bg.y = rowInfo[rowIndex].y;
         var g:Graphics = bg.graphics;
         g.clear();
         g.beginFill(color,getStyle("backgroundAlpha"));
         g.drawRect(0,0,listContent.width,height);
         g.endFill();
      }
      
      override protected function makeRowsAndColumns(left:Number, top:Number, right:Number, bottom:Number, firstCol:int, firstRow:int, byCount:Boolean = false, rowsNeeded:uint = 0) : Point
      {
         var paddingLeft:Number;
         var paddingRight:Number;
         var xx:Number;
         var ww:Number;
         var bSelected:Boolean;
         var bHighlight:Boolean;
         var bCaret:Boolean;
         var colNum:int;
         var rowNum:int;
         var rowsMade:int;
         var more:Boolean;
         var valid:Boolean;
         var yy:Number = NaN;
         var hh:Number = NaN;
         var i:int = 0;
         var j:int = 0;
         var item:IListItemRenderer = null;
         var oldItem:IListItemRenderer = null;
         var rowData:BaseListData = null;
         var data:Object = null;
         var wrappedData:Object = null;
         var uid:String = null;
         var rh:Number = NaN;
         var ld:BaseListData = null;
         var rr:Array = null;
         var rowInfo:ListRowInfo = null;
         var dx:Number = NaN;
         var dy:Number = NaN;
         var dw:Number = NaN;
         var dh:Number = NaN;
         listContent.allowItemSizeChangeNotification = false;
         paddingLeft = Number(getStyle("paddingLeft"));
         paddingRight = Number(getStyle("paddingRight"));
         xx = left + paddingLeft - horizontalScrollPosition;
         ww = right - paddingLeft - paddingRight;
         bSelected = false;
         bHighlight = false;
         bCaret = false;
         colNum = 0;
         rowNum = this.lockedRowCount;
         rowsMade = 0;
         more = true;
         valid = true;
         yy = top;
         rowNum = firstRow;
         more = iterator != null && !iterator.afterLast && iteratorValid;
         while(!byCount && yy < bottom || byCount && rowsNeeded > 0)
         {
            if(byCount)
            {
               rowsNeeded--;
            }
            valid = more;
            wrappedData = more ? iterator.current : null;
            data = wrappedData is ItemWrapper ? wrappedData.data : wrappedData;
            uid = null;
            if(!listItems[rowNum])
            {
               listItems[rowNum] = [];
            }
            if(valid)
            {
               item = listItems[rowNum][colNum];
               uid = itemToUID(wrappedData);
               if(!item || (runningDataEffect && Boolean(dataItemWrappersByRenderer[item]) ? Boolean(dataItemWrappersByRenderer[item] != wrappedData) : Boolean(item.data != data)))
               {
                  if(allowRendererStealingDuringLayout)
                  {
                     item = visibleData[uid];
                     if(!item && wrappedData != data)
                     {
                        item = visibleData[itemToUID(data)];
                     }
                  }
                  if(Boolean(item))
                  {
                     ld = BaseListData(rowMap[item.name]);
                     if(Boolean(ld) && ld.rowIndex > rowNum)
                     {
                        listItems[ld.rowIndex] = [];
                     }
                     else
                     {
                        item = null;
                     }
                  }
                  if(!item)
                  {
                     item = getReservedOrFreeItemRenderer(wrappedData);
                  }
                  if(!item)
                  {
                     item = this.createItemRenderer(data);
                     item.owner = this;
                     item.styleName = listContent;
                     listContent.addChild(DisplayObject(item));
                  }
                  oldItem = listItems[rowNum][colNum];
                  if(Boolean(oldItem))
                  {
                     addToFreeItemRenderers(oldItem);
                  }
                  listItems[rowNum][colNum] = item;
               }
               rowData = this.makeListData(data,uid,rowNum);
               rowMap[item.name] = rowData;
               if(item is IDropInListItemRenderer)
               {
                  if(data != null)
                  {
                     IDropInListItemRenderer(item).listData = rowData;
                  }
                  else
                  {
                     IDropInListItemRenderer(item).listData = null;
                  }
               }
               item.data = data;
               item.enabled = enabled;
               item.visible = true;
               if(uid != null)
               {
                  visibleData[uid] = item;
               }
               if(wrappedData != data)
               {
                  dataItemWrappersByRenderer[item] = wrappedData;
               }
               item.explicitWidth = ww;
               if(item is IInvalidating && (wordWrapChanged || variableRowHeight))
               {
                  IInvalidating(item).invalidateSize();
               }
               UIComponentGlobals.layoutManager.validateClient(item,true);
               hh = Math.ceil(variableRowHeight ? item.getExplicitOrMeasuredHeight() + cachedPaddingTop + cachedPaddingBottom : rowHeight);
               rh = Number(item.getExplicitOrMeasuredHeight());
               item.setActualSize(ww,variableRowHeight ? rh : rowHeight - cachedPaddingTop - cachedPaddingBottom);
               item.move(xx,yy + cachedPaddingTop);
            }
            else
            {
               hh = rowNum > 0 ? Number(rowInfo[rowNum - 1].height) : rowHeight;
               if(hh == 0)
               {
                  hh = rowHeight;
               }
               oldItem = listItems[rowNum][colNum];
               if(Boolean(oldItem))
               {
                  addToFreeItemRenderers(oldItem);
                  listItems[rowNum].splice(colNum,1);
               }
            }
            bSelected = selectedData[uid] != null;
            if(wrappedData != data)
            {
               bSelected ||= Boolean(selectedData[itemToUID(data)]);
               bSelected = bSelected && !getRendererSemanticValue(item,ModifiedCollectionView.REPLACEMENT) && !getRendererSemanticValue(item,ModifiedCollectionView.ADDED);
            }
            bHighlight = highlightUID == uid;
            bCaret = caretUID == uid;
            rowInfo[rowNum] = new ListRowInfo(yy,hh,uid,data);
            if(valid)
            {
               drawItem(item,bSelected,bHighlight,bCaret);
            }
            yy += hh;
            rowNum++;
            rowsMade++;
            if(Boolean(iterator) && more)
            {
               try
               {
                  more = Boolean(iterator.moveNext());
               }
               catch(e:ItemPendingError)
               {
                  lastSeekPending = new ListBaseSeekPending(CursorBookmark.CURRENT,0);
                  e.addResponder(new ItemResponder(seekPendingResultHandler,seekPendingFailureHandler,lastSeekPending));
                  more = false;
                  iteratorValid = false;
               }
            }
         }
         if(!byCount)
         {
            while(rowNum < listItems.length)
            {
               rr = listItems.pop();
               rowInfo.pop();
               while(Boolean(rr.length))
               {
                  item = rr.pop();
                  addToFreeItemRenderers(item);
               }
            }
         }
         if(Boolean(this.itemEditorInstance))
         {
            listContent.setChildIndex(DisplayObject(this.itemEditorInstance),listContent.numChildren - 1);
            item = listItems[this.actualRowIndex][this.actualColIndex];
            rowInfo = rowInfo[this.actualRowIndex];
            if(Boolean(item) && !this.rendererIsEditor)
            {
               dx = this.editorXOffset;
               dy = this.editorYOffset;
               dw = this.editorWidthOffset;
               dh = this.editorHeightOffset;
               this.layoutEditor(item.x + dx,rowInfo.y + dy,Math.min(item.width + dw,listContent.width - listContent.x - this.itemEditorInstance.x),Math.min(rowInfo.height + dh,listContent.height - listContent.y - this.itemEditorInstance.y));
            }
         }
         listContent.allowItemSizeChangeNotification = variableRowHeight;
         return new Point(colNum,rowsMade);
      }
      
      protected function layoutEditor(x:int, y:int, w:int, h:int) : void
      {
         this.itemEditorInstance.move(x,y);
         this.itemEditorInstance.setActualSize(w,h);
      }
      
      override protected function scrollHandler(event:Event) : void
      {
         var scrollBar:ScrollBar = null;
         var pos:Number = NaN;
         var delta:int = 0;
         var o:EdgeMetrics = null;
         var bookmark:CursorBookmark = null;
         if(event is ScrollEvent)
         {
            if(Boolean(this.itemEditorInstance))
            {
               this.endEdit(ListEventReason.OTHER);
            }
            if(!liveScrolling && ScrollEvent(event).detail == ScrollEventDetail.THUMB_TRACK)
            {
               return;
            }
            scrollBar = ScrollBar(event.target);
            pos = scrollBar.scrollPosition;
            removeClipMask();
            if(scrollBar == verticalScrollBar)
            {
               delta = pos - verticalScrollPosition;
               super.scrollHandler(event);
               if(Math.abs(delta) >= listItems.length - this.lockedRowCount || !iteratorValid)
               {
                  try
                  {
                     if(!iteratorValid)
                     {
                        iterator.seek(CursorBookmark.FIRST,pos);
                     }
                     else
                     {
                        iterator.seek(CursorBookmark.CURRENT,delta);
                     }
                     if(!iteratorValid)
                     {
                        iteratorValid = true;
                        lastSeekPending = null;
                     }
                  }
                  catch(e:ItemPendingError)
                  {
                     lastSeekPending = new ListBaseSeekPending(CursorBookmark.FIRST,pos);
                     e.addResponder(new ItemResponder(seekPendingResultHandler,seekPendingFailureHandler,lastSeekPending));
                     iteratorValid = false;
                  }
                  bookmark = iterator.bookmark;
                  clearIndicators();
                  clearVisibleData();
                  this.makeRowsAndColumns(0,0,listContent.width,listContent.height,0,0);
                  iterator.seek(bookmark,0);
               }
               else if(delta != 0)
               {
                  scrollVertically(pos,Math.abs(delta),Boolean(delta > 0));
               }
               if(variableRowHeight)
               {
                  this.configureScrollBars();
               }
               this.drawRowBackgrounds();
            }
            else
            {
               delta = pos - _horizontalScrollPosition;
               super.scrollHandler(event);
               this.scrollHorizontally(pos,Math.abs(delta),Boolean(delta > 0));
            }
            addClipMask(false);
         }
      }
      
      override protected function scrollHorizontally(pos:int, deltaPos:int, scrollUp:Boolean) : void
      {
         var n:int = int(listItems.length);
         var paddingLeft:Number = Number(getStyle("paddingLeft"));
         for(var i:int = 0; i < n; i++)
         {
            if(Boolean(listItems[i].length))
            {
               listItems[i][0].x = -pos + paddingLeft;
            }
         }
      }
      
      protected function makeListData(data:Object, uid:String, rowNum:int) : BaseListData
      {
         return new ListData(itemToLabel(data),itemToIcon(data),labelField,uid,this,rowNum);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function setupRendererFromData(item:IListItemRenderer, wrappedData:Object) : void
      {
         var data:Object = wrappedData is ItemWrapper ? wrappedData.data : wrappedData;
         if(item is IDropInListItemRenderer)
         {
            if(data != null)
            {
               IDropInListItemRenderer(item).listData = this.makeListData(data,itemToUID(wrappedData),0);
            }
            else
            {
               IDropInListItemRenderer(item).listData = null;
            }
         }
         item.data = data;
         if(item is IInvalidating)
         {
            IInvalidating(item).invalidateSize();
         }
         UIComponentGlobals.layoutManager.validateClient(item,true);
      }
      
      override public function measureWidthOfItems(index:int = -1, count:int = 0) : Number
      {
         var w:Number;
         var bookmark:CursorBookmark;
         var more:Boolean;
         var i:int;
         var paddingLeft:Number;
         var paddingRight:Number;
         var item:IListItemRenderer = null;
         var rw:Number = NaN;
         var data:Object = null;
         var factory:IFactory = null;
         if(count == 0)
         {
            count = Boolean(collection) ? int(collection.length) : 0;
         }
         if(Boolean(collection) && collection.length == 0)
         {
            count = 0;
         }
         w = 0;
         bookmark = Boolean(iterator) ? iterator.bookmark : null;
         if(index != -1 && Boolean(iterator))
         {
            try
            {
               iterator.seek(CursorBookmark.FIRST,index);
            }
            catch(e:ItemPendingError)
            {
               return 0;
            }
         }
         more = iterator != null;
         for(i = 0; i < count; i++)
         {
            if(more)
            {
               data = iterator.current;
               factory = getItemRendererFactory(data);
               item = this.measuringObjects[factory];
               if(!item)
               {
                  item = this.getMeasuringRenderer(data);
               }
               item.explicitWidth = NaN;
               this.setupRendererFromData(item,data);
               rw = Number(item.measuredWidth);
               w = Math.max(w,rw);
            }
            if(more)
            {
               try
               {
                  more = Boolean(iterator.moveNext());
               }
               catch(e:ItemPendingError)
               {
                  more = false;
               }
            }
         }
         if(Boolean(iterator))
         {
            iterator.seek(bookmark,0);
         }
         if(w == 0)
         {
            if(Boolean(explicitWidth))
            {
               return explicitWidth;
            }
            return DEFAULT_MEASURED_WIDTH;
         }
         paddingLeft = Number(getStyle("paddingLeft"));
         paddingRight = Number(getStyle("paddingRight"));
         w += paddingLeft + paddingRight;
         return w;
      }
      
      override public function measureHeightOfItems(index:int = -1, count:int = 0) : Number
      {
         var paddingTop:Number;
         var paddingBottom:Number;
         var ww:Number;
         var h:Number;
         var bookmark:CursorBookmark;
         var rh:Number;
         var more:Boolean;
         var i:int;
         var data:Object = null;
         var item:IListItemRenderer = null;
         if(count == 0)
         {
            count = Boolean(collection) ? int(collection.length) : 0;
         }
         paddingTop = Number(getStyle("paddingTop"));
         paddingBottom = Number(getStyle("paddingBottom"));
         ww = 200;
         if(Boolean(listContent.width))
         {
            ww = Number(listContent.width);
         }
         h = 0;
         bookmark = Boolean(iterator) ? iterator.bookmark : null;
         if(index != -1 && Boolean(iterator))
         {
            iterator.seek(CursorBookmark.FIRST,index);
         }
         rh = rowHeight;
         more = iterator != null;
         for(i = 0; i < count; i++)
         {
            if(more)
            {
               rh = rowHeight;
               data = iterator.current;
               item = this.getMeasuringRenderer(data);
               item.explicitWidth = ww;
               this.setupRendererFromData(item,data);
               if(variableRowHeight)
               {
                  rh = item.getExplicitOrMeasuredHeight() + paddingTop + paddingBottom;
               }
            }
            h += rh;
            if(more)
            {
               try
               {
                  more = Boolean(iterator.moveNext());
               }
               catch(e:ItemPendingError)
               {
                  more = false;
               }
            }
         }
         if(Boolean(iterator))
         {
            iterator.seek(bookmark,0);
         }
         return h;
      }
      
      override protected function mouseEventToItemRenderer(event:MouseEvent) : IListItemRenderer
      {
         var r:IListItemRenderer = super.mouseEventToItemRenderer(event);
         return r == this.itemEditorInstance ? null : r;
      }
      
      [Inspectable(category="Data")]
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getMeasuringRenderer(data:Object) : IListItemRenderer
      {
         var item:IListItemRenderer = null;
         if(!this.measuringObjects)
         {
            this.measuringObjects = new Dictionary(true);
         }
         var factory:IFactory = getItemRendererFactory(data);
         item = this.measuringObjects[factory];
         if(!item)
         {
            item = this.createItemRenderer(data);
            item.owner = this;
            item.name = "hiddenItem";
            item.visible = false;
            item.styleName = listContent;
            listContent.addChild(DisplayObject(item));
            this.measuringObjects[factory] = item;
         }
         return item;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function purgeMeasuringRenderers() : void
      {
         var item:IListItemRenderer = null;
         for each(item in this.measuringObjects)
         {
            if(Boolean(item.parent))
            {
               item.parent.removeChild(DisplayObject(item));
            }
         }
         if(!this.measuringObjects)
         {
            this.measuringObjects = new Dictionary(true);
         }
      }
      
      override public function set itemRenderer(value:IFactory) : void
      {
         super.itemRenderer = value;
         this.purgeMeasuringRenderers();
      }
      
      override public function createItemRenderer(data:Object) : IListItemRenderer
      {
         var factory:IFactory = null;
         var renderer:IListItemRenderer = null;
         var d:Dictionary = null;
         var p:* = undefined;
         factory = getItemRendererFactory(data);
         if(!factory)
         {
            if(data == null)
            {
               factory = nullItemRenderer;
            }
            if(!factory)
            {
               factory = itemRenderer;
            }
         }
         if(factory == itemRenderer)
         {
            if(Boolean(freeItemRenderers) && Boolean(freeItemRenderers.length))
            {
               renderer = freeItemRenderers.pop();
               delete freeItemRenderersByFactory[factory][renderer];
            }
         }
         else if(Boolean(freeItemRenderersByFactory))
         {
            d = freeItemRenderersByFactory[factory];
            if(Boolean(d))
            {
               var _loc6_:int = 0;
               var _loc7_:* = d;
               for(p in _loc7_)
               {
                  renderer = IListItemRenderer(p);
                  delete d[p];
               }
            }
         }
         if(!renderer)
         {
            renderer = factory.newInstance();
            renderer.styleName = this;
            factoryMap[renderer] = factory;
         }
         renderer.owner = this;
         return renderer;
      }
      
      private function editingTemporarilyPrevented(coord:Object) : Boolean
      {
         var rowIndex:int = 0;
         var item:IListItemRenderer = null;
         if(runningDataEffect && Boolean(coord))
         {
            rowIndex = coord.rowIndex - verticalScrollPosition + offscreenExtraRowsTop;
            if(rowIndex < 0 || rowIndex >= listItems.length)
            {
               return false;
            }
            item = listItems[rowIndex][0];
            if(Boolean(item) && (Boolean(getRendererSemanticValue(item,"replaced")) || Boolean(getRendererSemanticValue(item,"removed"))))
            {
               return true;
            }
         }
         return false;
      }
      
      private function setEditedItemPosition(coord:Object) : void
      {
         this.bEditedItemPositionChanged = true;
         this._proposedEditedItemPosition = coord;
         invalidateDisplayList();
      }
      
      private function commitEditedItemPosition(coord:Object) : void
      {
         var reason:String = null;
         if(!enabled || !this.editable)
         {
            return;
         }
         if(Boolean(this.itemEditorInstance && coord) && Boolean(this.itemEditorInstance is IFocusManagerComponent) && this._editedItemPosition.rowIndex == coord.rowIndex)
         {
            IFocusManagerComponent(this.itemEditorInstance).setFocus();
            return;
         }
         if(Boolean(this.itemEditorInstance))
         {
            if(!coord)
            {
               reason = ListEventReason.OTHER;
            }
            else
            {
               reason = ListEventReason.NEW_ROW;
            }
            if(!this.endEdit(reason) && reason != ListEventReason.OTHER)
            {
               return;
            }
         }
         this._editedItemPosition = coord;
         if(!coord || this.dontEdit)
         {
            return;
         }
         var rowIndex:int = int(coord.rowIndex);
         var colIndex:int = int(coord.columnIndex);
         if(selectedIndex != coord.rowIndex)
         {
            commitSelectedIndex(coord.rowIndex);
         }
         var actualLockedRows:int = this.lockedRowCount;
         var lastRowIndex:int = verticalScrollPosition + listItems.length - offscreenExtraRowsTop - offscreenExtraRowsBottom - 1;
         var partialRow:int = rowInfo[listItems.length - offscreenExtraRowsBottom - 1].y + rowInfo[listItems.length - offscreenExtraRowsBottom - 1].height > listContent.height ? 1 : 0;
         if(rowIndex > actualLockedRows)
         {
            if(rowIndex < verticalScrollPosition + actualLockedRows)
            {
               verticalScrollPosition = rowIndex - actualLockedRows;
            }
            else
            {
               while(rowIndex > lastRowIndex || Boolean(rowIndex == lastRowIndex && rowIndex > verticalScrollPosition + actualLockedRows) && Boolean(partialRow))
               {
                  if(verticalScrollPosition == maxVerticalScrollPosition)
                  {
                     break;
                  }
                  verticalScrollPosition = Math.min(verticalScrollPosition + (rowIndex > lastRowIndex ? rowIndex - lastRowIndex : partialRow),maxVerticalScrollPosition);
                  lastRowIndex = verticalScrollPosition + listItems.length - offscreenExtraRowsTop - offscreenExtraRowsBottom - 1;
                  partialRow = rowInfo[listItems.length - offscreenExtraRowsBottom - 1].y + rowInfo[listItems.length - offscreenExtraRowsBottom - 1].height > listContent.height ? 1 : 0;
               }
            }
            this.actualRowIndex = rowIndex - verticalScrollPosition;
         }
         else
         {
            if(rowIndex == actualLockedRows)
            {
               verticalScrollPosition = 0;
            }
            this.actualRowIndex = rowIndex;
         }
         var bm:EdgeMetrics = borderMetrics;
         this.actualColIndex = colIndex;
         var item:IListItemRenderer = listItems[this.actualRowIndex][this.actualColIndex];
         if(!item)
         {
            this.commitEditedItemPosition(null);
            return;
         }
         if(!this.isItemEditable(item.data))
         {
            this.commitEditedItemPosition(null);
            return;
         }
         var event:ListEvent = new ListEvent(ListEvent.ITEM_EDIT_BEGIN,false,true);
         event.rowIndex = this._editedItemPosition.rowIndex;
         event.itemRenderer = item;
         dispatchEvent(event);
         this.lastEditedItemPosition = this._editedItemPosition;
         if(this.bEditedItemPositionChanged)
         {
            this.bEditedItemPositionChanged = false;
            this.commitEditedItemPosition(this._proposedEditedItemPosition);
            this._proposedEditedItemPosition = undefined;
         }
         if(!this.itemEditorInstance)
         {
            this.commitEditedItemPosition(null);
         }
      }
      
      public function createItemEditor(colIndex:int, rowIndex:int) : void
      {
         var textInputClass:Class = null;
         var dx:Number = NaN;
         var dy:Number = NaN;
         var dw:Number = NaN;
         var dh:Number = NaN;
         if(!this.itemEditor)
         {
            textInputClass = getStyle("textInputClass");
            if(Boolean(textInputClass))
            {
               this.itemEditor = new ClassFactory(textInputClass);
            }
            else
            {
               this.itemEditor = new ClassFactory(TextInput);
            }
         }
         colIndex = 0;
         if(rowIndex > this.lockedRowCount)
         {
            rowIndex -= verticalScrollPosition;
         }
         var item:IListItemRenderer = listItems[rowIndex][colIndex];
         var rowData:ListRowInfo = rowInfo[rowIndex];
         if(!this.rendererIsEditor)
         {
            dx = 0;
            dy = -2;
            dw = 0;
            dh = 4;
            if(!this.itemEditorInstance)
            {
               dx = this.editorXOffset;
               dy = this.editorYOffset;
               dw = this.editorWidthOffset;
               dh = this.editorHeightOffset;
               this.itemEditorInstance = this.itemEditor.newInstance();
               this.itemEditorInstance.owner = this;
               this.itemEditorInstance.styleName = this;
               listContent.addChild(DisplayObject(this.itemEditorInstance));
            }
            listContent.setChildIndex(DisplayObject(this.itemEditorInstance),listContent.numChildren - 1);
            this.itemEditorInstance.visible = true;
            this.layoutEditor(item.x + dx,rowData.y + dy,Math.min(item.width + dw,listContent.width - listContent.x - this.itemEditorInstance.x),Math.min(rowData.height + dh,listContent.height - listContent.y - this.itemEditorInstance.y));
            DisplayObject(this.itemEditorInstance).addEventListener("focusOut",this.itemEditorFocusOutHandler);
         }
         else
         {
            this.itemEditorInstance = item;
         }
         DisplayObject(this.itemEditorInstance).addEventListener(KeyboardEvent.KEY_DOWN,this.editorKeyDownHandler);
         if(Boolean(focusManager))
         {
            focusManager.defaultButtonEnabled = false;
         }
         systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_DOWN,this.editorMouseDownHandler,true,0,true);
         systemManager.getSandboxRoot().addEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE,this.editorMouseDownHandler,false,0,true);
      }
      
      private function findNextItemRenderer(shiftKey:Boolean) : Boolean
      {
         if(!this.lastEditedItemPosition)
         {
            return false;
         }
         if(this._proposedEditedItemPosition !== undefined)
         {
            return true;
         }
         this._editedItemPosition = this.lastEditedItemPosition;
         var rowIndex:int = int(this._editedItemPosition.rowIndex);
         var columnIndex:int = int(this._editedItemPosition.columnIndex);
         var newIndex:int = this._editedItemPosition.rowIndex + (shiftKey ? -1 : 1);
         if(newIndex < collection.length && newIndex >= 0)
         {
            rowIndex = newIndex;
            var listEvent:ListEvent = new ListEvent(ListEvent.ITEM_EDIT_BEGINNING,false,true);
            listEvent.rowIndex = rowIndex;
            listEvent.columnIndex = columnIndex;
            dispatchEvent(listEvent);
            return true;
         }
         this.setEditedItemPosition(null);
         this.losingFocus = true;
         setFocus();
         return false;
      }
      
      public function destroyItemEditor() : void
      {
         var event:ListEvent = null;
         if(Boolean(this.itemEditorInstance))
         {
            DisplayObject(this.itemEditorInstance).removeEventListener(KeyboardEvent.KEY_DOWN,this.editorKeyDownHandler);
            if(Boolean(focusManager))
            {
               focusManager.defaultButtonEnabled = true;
            }
            systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_DOWN,this.editorMouseDownHandler,true);
            systemManager.getSandboxRoot().removeEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE,this.editorMouseDownHandler);
            event = new ListEvent(ListEvent.ITEM_FOCUS_OUT);
            event.rowIndex = this._editedItemPosition.rowIndex;
            event.itemRenderer = this.editedItemRenderer;
            dispatchEvent(event);
            if(!this.rendererIsEditor)
            {
               if(Boolean(this.itemEditorInstance) && this.itemEditorInstance is UIComponent)
               {
                  UIComponent(this.itemEditorInstance).drawFocus(false);
               }
               listContent.removeChild(DisplayObject(this.itemEditorInstance));
            }
            this.itemEditorInstance = null;
            this._editedItemPosition = null;
         }
      }
      
      protected function endEdit(reason:String) : Boolean
      {
         if(!this.editedItemRenderer)
         {
            return true;
         }
         this.inEndEdit = true;
         var listEvent:ListEvent = new ListEvent(ListEvent.ITEM_EDIT_END,false,true);
         listEvent.rowIndex = this.editedItemPosition.rowIndex;
         listEvent.itemRenderer = this.editedItemRenderer;
         listEvent.reason = reason;
         dispatchEvent(listEvent);
         this.dontEdit = this.itemEditorInstance != null;
         if(!this.dontEdit && reason == ListEventReason.CANCELLED)
         {
            this.losingFocus = true;
            setFocus();
         }
         this.inEndEdit = false;
         return !listEvent.isDefaultPrevented();
      }
      
      public function isItemEditable(data:Object) : Boolean
      {
         if(!this.editable)
         {
            return false;
         }
         if(data == null)
         {
            return false;
         }
         return true;
      }
      
      override protected function mouseDownHandler(event:MouseEvent) : void
      {
         var r:IListItemRenderer = null;
         var s:Sprite = null;
         var pos:Point = null;
         var bEndedEdit:Boolean = false;
         r = this.mouseEventToItemRenderer(event);
         var isItemEditor:Boolean = itemRendererContains(this.itemEditorInstance,DisplayObject(event.target));
         if(!isItemEditor)
         {
            if(Boolean(r) && Boolean(r.data))
            {
               pos = itemRendererToIndices(r);
               bEndedEdit = true;
               if(Boolean(this.itemEditorInstance))
               {
                  bEndedEdit = this.endEdit(ListEventReason.NEW_ROW);
               }
               if(!bEndedEdit)
               {
                  return;
               }
            }
            else if(Boolean(this.itemEditorInstance))
            {
               this.endEdit(ListEventReason.OTHER);
            }
            super.mouseDownHandler(event);
         }
      }
      
      override protected function mouseUpHandler(event:MouseEvent) : void
      {
         var listEvent:ListEvent = null;
         var r:IListItemRenderer = null;
         var s:Sprite = null;
         var n:int = 0;
         var i:int = 0;
         var pos:Point = null;
         r = this.mouseEventToItemRenderer(event);
         super.mouseUpHandler(event);
         if(Boolean(r) && Boolean(r.data) && r != this.itemEditorInstance)
         {
            pos = itemRendererToIndices(r);
            if(this.editable && !this.dontEdit)
            {
               listEvent = new ListEvent(ListEvent.ITEM_EDIT_BEGINNING,false,true);
               listEvent.rowIndex = pos.y;
               listEvent.columnIndex = 0;
               listEvent.itemRenderer = r;
               dispatchEvent(listEvent);
            }
         }
      }
      
      override protected function focusInHandler(event:FocusEvent) : void
      {
         var foundOne:Boolean = false;
         if(event.target != this)
         {
            return;
         }
         if(this.losingFocus)
         {
            this.losingFocus = false;
            return;
         }
         super.focusInHandler(event);
         if(this.editable && !isPressed)
         {
            this._editedItemPosition = this.lastEditedItemPosition;
            foundOne = this.editedItemPosition != null;
            if(!this._editedItemPosition)
            {
               this._editedItemPosition = {
                  "rowIndex":0,
                  "columnIndex":0
               };
               foundOne = Boolean(listItems.length) && listItems[0].length > 0;
            }
            if(foundOne)
            {
               this.setEditedItemPosition(this._editedItemPosition);
            }
         }
         if(this.editable)
         {
            addEventListener(FocusEvent.KEY_FOCUS_CHANGE,this.keyFocusChangeHandler);
            addEventListener(MouseEvent.MOUSE_DOWN,this.mouseFocusChangeHandler);
         }
      }
      
      override protected function focusOutHandler(event:FocusEvent) : void
      {
         if(event.target == this)
         {
            super.focusOutHandler(event);
         }
         if(event.relatedObject == this && itemRendererContains(this.itemEditorInstance,DisplayObject(event.target)))
         {
            return;
         }
         if(event.relatedObject == null && itemRendererContains(this.editedItemRenderer,DisplayObject(event.target)))
         {
            return;
         }
         if(event.relatedObject == null && itemRendererContains(this.itemEditorInstance,DisplayObject(event.target)))
         {
            return;
         }
         if(Boolean(this.itemEditorInstance) && (!event.relatedObject || !itemRendererContains(this.itemEditorInstance,event.relatedObject)))
         {
            this.endEdit(ListEventReason.OTHER);
            removeEventListener(FocusEvent.KEY_FOCUS_CHANGE,this.keyFocusChangeHandler);
            removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseFocusChangeHandler);
         }
      }
      
      private function deactivateHandler(event:Event) : void
      {
         if(Boolean(this.itemEditorInstance))
         {
            this.endEdit(ListEventReason.OTHER);
            this.losingFocus = true;
            setFocus();
         }
      }
      
      override protected function keyDownHandler(event:KeyboardEvent) : void
      {
         if(Boolean(this.itemEditorInstance))
         {
            return;
         }
         super.keyDownHandler(event);
      }
      
      private function editorMouseDownHandler(event:Event) : void
      {
         if(event is MouseEvent && itemRendererContains(this.itemEditorInstance,DisplayObject(event.target)))
         {
            return;
         }
         this.endEdit(ListEventReason.OTHER);
         this.losingFocus = true;
         setFocus();
      }
      
      private function editorKeyDownHandler(event:KeyboardEvent) : void
      {
         if(event.keyCode == Keyboard.ESCAPE)
         {
            this.endEdit(ListEventReason.CANCELLED);
         }
         else if(event.ctrlKey && event.charCode == 46)
         {
            this.endEdit(ListEventReason.CANCELLED);
         }
         else if(event.charCode == Keyboard.ENTER && event.keyCode != 229)
         {
            if(this.editorUsesEnterKey)
            {
               return;
            }
            if(this.endEdit(ListEventReason.NEW_ROW) && !this.dontEdit)
            {
               this.findNextEnterItemRenderer(event);
               if(Boolean(focusManager))
               {
                  focusManager.defaultButtonEnabled = false;
               }
            }
         }
      }
      
      private function findNextEnterItemRenderer(event:KeyboardEvent) : void
      {
         if(this._proposedEditedItemPosition !== undefined)
         {
            return;
         }
         this._editedItemPosition = this.lastEditedItemPosition;
         var rowIndex:int = int(this._editedItemPosition.rowIndex);
         var columnIndex:int = int(this._editedItemPosition.columnIndex);
         var newIndex:int = this._editedItemPosition.rowIndex + (event.shiftKey ? -1 : 1);
         if(newIndex < collection.length && newIndex >= 0)
         {
            rowIndex = newIndex;
         }
         var listEvent:ListEvent = new ListEvent(ListEvent.ITEM_EDIT_BEGINNING,false,true);
         listEvent.rowIndex = rowIndex;
         listEvent.columnIndex = 0;
         dispatchEvent(listEvent);
      }
      
      private function mouseFocusChangeHandler(event:MouseEvent) : void
      {
         if(Boolean(this.itemEditorInstance) && Boolean(!event.isDefaultPrevented()) && itemRendererContains(this.itemEditorInstance,DisplayObject(event.target)))
         {
            event.preventDefault();
         }
      }
      
      private function keyFocusChangeHandler(event:FocusEvent) : void
      {
         if(event.keyCode == Keyboard.TAB && !event.isDefaultPrevented() && this.findNextItemRenderer(event.shiftKey))
         {
            event.preventDefault();
         }
      }
      
      private function itemEditorFocusOutHandler(event:FocusEvent) : void
      {
         if(Boolean(event.relatedObject) && Boolean(contains(event.relatedObject)))
         {
            return;
         }
         if(!event.relatedObject)
         {
            return;
         }
         if(Boolean(this.itemEditorInstance))
         {
            this.endEdit(ListEventReason.OTHER);
         }
      }
      
      private function itemEditorItemEditBeginningHandler(event:ListEvent) : void
      {
         if(!event.isDefaultPrevented())
         {
            this.setEditedItemPosition({
               "columnIndex":event.columnIndex,
               "rowIndex":event.rowIndex
            });
         }
         else if(!this.itemEditorInstance)
         {
            this._editedItemPosition = null;
            this.editable = false;
            setFocus();
            this.editable = true;
         }
      }
      
      private function itemEditorItemEditBeginHandler(event:ListEvent) : void
      {
         var fm:IFocusManager = null;
         if(Boolean(root))
         {
            systemManager.addEventListener(Event.DEACTIVATE,this.deactivateHandler,false,0,true);
         }
         if(!event.isDefaultPrevented() && listItems[this.actualRowIndex][this.actualColIndex].data != null)
         {
            this.createItemEditor(event.columnIndex,event.rowIndex);
            if(this.editedItemRenderer is IDropInListItemRenderer && this.itemEditorInstance is IDropInListItemRenderer)
            {
               IDropInListItemRenderer(this.itemEditorInstance).listData = IDropInListItemRenderer(this.editedItemRenderer).listData;
            }
            if(!this.rendererIsEditor)
            {
               this.itemEditorInstance.data = this.editedItemRenderer.data;
            }
            if(this.itemEditorInstance is IInvalidating)
            {
               IInvalidating(this.itemEditorInstance).validateNow();
            }
            if(this.itemEditorInstance is IIMESupport)
            {
               IIMESupport(this.itemEditorInstance).imeMode = this.imeMode;
            }
            fm = focusManager;
            if(this.itemEditorInstance is IFocusManagerComponent)
            {
               fm.setFocus(IFocusManagerComponent(this.itemEditorInstance));
            }
            event = new ListEvent(ListEvent.ITEM_FOCUS_IN);
            event.rowIndex = this._editedItemPosition.rowIndex;
            event.itemRenderer = this.itemEditorInstance;
            dispatchEvent(event);
         }
      }
      
      private function itemEditorItemEditEndHandler(event:ListEvent) : void
      {
         var bChanged:Boolean = false;
         var bFieldChanged:Boolean = false;
         var newData:Object = null;
         var data:Object = null;
         var editCollection:IList = null;
         var listData:BaseListData = null;
         var fm:IFocusManager = null;
         if(!event.isDefaultPrevented())
         {
            bChanged = false;
            bFieldChanged = false;
            newData = this.itemEditorInstance[this.editorDataField];
            data = event.itemRenderer.data;
            if(data is String)
            {
               if(!(newData is String))
               {
                  newData = newData.toString();
               }
            }
            else if(data is uint)
            {
               if(!(newData is uint))
               {
                  newData = uint(newData);
               }
            }
            else if(data is int)
            {
               if(!(newData is int))
               {
                  newData = int(newData);
               }
            }
            else if(data is Number)
            {
               if(!(newData is int))
               {
                  newData = Number(newData);
               }
            }
            else
            {
               bFieldChanged = true;
               try
               {
                  data[labelField] = newData;
                  if(!(data is IPropertyChangeNotifier))
                  {
                     if(Boolean(actualCollection))
                     {
                        actualCollection.itemUpdated(data,labelField);
                     }
                     else
                     {
                        collection.itemUpdated(data,labelField);
                     }
                  }
               }
               catch(e:Error)
               {
                  trace("attempt to write to",labelField,"failed.  You may need a custom ITEM_EDIT_END handler");
               }
            }
            if(!bFieldChanged)
            {
               if(data !== newData)
               {
                  bChanged = true;
                  data = newData;
               }
               if(bChanged)
               {
                  editCollection = Boolean(actualCollection) ? actualCollection as IList : collection as IList;
                  if(Boolean(editCollection))
                  {
                     IList(editCollection).setItemAt(data,event.rowIndex);
                  }
                  else
                  {
                     trace("attempt to update collection failed.  You may need a custom ITEM_EDIT_END handler");
                  }
               }
            }
            if(event.itemRenderer is IDropInListItemRenderer)
            {
               listData = BaseListData(IDropInListItemRenderer(event.itemRenderer).listData);
               listData.label = itemToLabel(data);
               IDropInListItemRenderer(event.itemRenderer).listData = listData;
            }
            delete visibleData[itemToUID(event.itemRenderer.data)];
            event.itemRenderer.data = data;
            visibleData[itemToUID(data)] = event.itemRenderer;
         }
         else if(event.reason != ListEventReason.OTHER)
         {
            if(Boolean(this.itemEditorInstance) && Boolean(this._editedItemPosition))
            {
               if(selectedIndex != this._editedItemPosition.rowIndex)
               {
                  selectedIndex = this._editedItemPosition.rowIndex;
               }
               fm = focusManager;
               if(this.itemEditorInstance is IFocusManagerComponent)
               {
                  fm.setFocus(IFocusManagerComponent(this.itemEditorInstance));
               }
            }
         }
         if(event.reason == ListEventReason.OTHER || !event.isDefaultPrevented())
         {
            this.destroyItemEditor();
         }
      }
      
      override protected function drawHighlightIndicator(indicator:Sprite, x:Number, y:Number, width:Number, height:Number, color:uint, itemRenderer:IListItemRenderer) : void
      {
         super.drawHighlightIndicator(indicator,0,y,unscaledWidth - viewMetrics.left - viewMetrics.right,height,color,itemRenderer);
      }
      
      override protected function drawCaretIndicator(indicator:Sprite, x:Number, y:Number, width:Number, height:Number, color:uint, itemRenderer:IListItemRenderer) : void
      {
         super.drawCaretIndicator(indicator,0,y,unscaledWidth - viewMetrics.left - viewMetrics.right,height,color,itemRenderer);
      }
      
      override protected function drawSelectionIndicator(indicator:Sprite, x:Number, y:Number, width:Number, height:Number, color:uint, itemRenderer:IListItemRenderer) : void
      {
         super.drawSelectionIndicator(indicator,0,y,unscaledWidth - viewMetrics.left - viewMetrics.right,height,color,itemRenderer);
      }
      
      override protected function mouseWheelHandler(event:MouseEvent) : void
      {
         if(Boolean(this.itemEditorInstance))
         {
            this.endEdit(ListEventReason.OTHER);
         }
         super.mouseWheelHandler(event);
      }
      
      override protected function collectionChangeHandler(event:Event) : void
      {
         var ceEvent:CollectionEvent = null;
         if(event is CollectionEvent)
         {
            ceEvent = CollectionEvent(event);
            if(ceEvent.kind == CollectionEventKind.REMOVE)
            {
               if(Boolean(this.editedItemPosition))
               {
                  if(collection.length == 0)
                  {
                     if(Boolean(this.itemEditorInstance))
                     {
                        this.endEdit(ListEventReason.CANCELLED);
                     }
                     this.setEditedItemPosition(null);
                  }
                  else if(ceEvent.location <= this.editedItemPosition.rowIndex)
                  {
                     if(this.inEndEdit)
                     {
                        this._editedItemPosition = {
                           "columnIndex":this.editedItemPosition.columnIndex,
                           "rowIndex":Math.max(0,this.editedItemPosition.rowIndex - ceEvent.items.length)
                        };
                     }
                     else
                     {
                        this.setEditedItemPosition({
                           "columnIndex":this.editedItemPosition.columnIndex,
                           "rowIndex":Math.max(0,this.editedItemPosition.rowIndex - ceEvent.items.length)
                        });
                     }
                  }
               }
            }
         }
         super.collectionChangeHandler(event);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function callSetupRendererFromData(item:IListItemRenderer, data:Object) : void
      {
         this.setupRendererFromData(item,data);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function callMakeListData(data:Object, uid:String, rowNum:int) : BaseListData
      {
         return this.makeListData(data,uid,rowNum);
      }
   }
}

