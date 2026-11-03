package mx.controls.dataGridClasses
{
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import flash.utils.Dictionary;
   import flash.utils.setInterval;
   import mx.collections.CursorBookmark;
   import mx.collections.IViewCursor;
   import mx.collections.ItemResponder;
   import mx.collections.errors.ItemPendingError;
   import mx.controls.listClasses.BaseListData;
   import mx.controls.listClasses.IDropInListItemRenderer;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.controls.listClasses.ListBase;
   import mx.controls.listClasses.ListBaseContentHolder;
   import mx.controls.listClasses.ListBaseSeekPending;
   import mx.controls.listClasses.ListRowInfo;
   import mx.core.EdgeMetrics;
   import mx.core.IFactory;
   import mx.core.IFlexDisplayObject;
   import mx.core.IFlexModuleFactory;
   import mx.core.IFontContextComponent;
   import mx.core.IInvalidating;
   import mx.core.ILayoutDirectionElement;
   import mx.core.IUIComponent;
   import mx.core.IUITextField;
   import mx.core.SpriteAsset;
   import mx.core.UIComponentGlobals;
   import mx.events.DragEvent;
   import mx.events.ListEvent;
   import mx.events.ScrollEvent;
   import mx.events.ScrollEventDetail;
   import mx.events.ScrollEventDirection;
   import mx.events.TweenEvent;
   import mx.skins.halo.ListDropIndicator;
   
   public class DataGridBase extends ListBase implements IFontContextComponent
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      protected var columnMap:Object;
      
      protected var freeItemRenderersTable:Dictionary;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var visibleColumns:Array;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var visibleLockedColumns:Array;
      
      protected var header:DataGridHeaderBase;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var headerClass:Class = DataGridHeader;
      
      protected var headerMask:Shape;
      
      protected var lockedColumnHeader:DataGridHeaderBase;
      
      private var lockedColumnHeaderMask:Shape;
      
      protected var lockedRowContent:DataGridLockedRowContentHolder;
      
      private var lockedRowMask:Shape;
      
      protected var lockedColumnAndRowContent:DataGridLockedRowContentHolder;
      
      private var lockedColumnAndRowMask:Shape;
      
      protected var lockedColumnContent:ListBaseContentHolder;
      
      private var lockedColumnMask:Shape;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var columnsInvalid:Boolean = true;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var fontContextChanged:Boolean = true;
      
      private var bShiftKey:Boolean = false;
      
      private var bCtrlKey:Boolean = false;
      
      private var lastKey:uint = 0;
      
      private var bSelectItem:Boolean = false;
      
      private var inSelectItem:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _headerHeight:Number = 22;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _explicitHeaderHeight:Boolean;
      
      private var lockedColumnCountChanged:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _lockedColumnCount:int = 0;
      
      private var lockedRowCountChanged:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _lockedRowCount:int = 0;
      
      private var _showHeaders:Boolean = true;
      
      protected var columnHighlightIndicator:Sprite;
      
      protected var columnCaretIndicator:Sprite;
      
      private var indicatorDictionary:Dictionary = new Dictionary(true);
      
      public function DataGridBase()
      {
         super();
         listType = "vertical";
         defaultRowCount = 7;
         this.columnMap = {};
         this.freeItemRenderersTable = new Dictionary(false);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get dataGridHeader() : DataGridHeaderBase
      {
         return this.header;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get dataGridLockedColumnHeader() : DataGridHeaderBase
      {
         return this.lockedColumnHeader;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get dataGridLockedColumnAndRows() : ListBaseContentHolder
      {
         return this.lockedColumnAndRowContent;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get dataGridLockedRows() : ListBaseContentHolder
      {
         return this.lockedRowContent;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get dataGridLockedColumns() : ListBaseContentHolder
      {
         return this.lockedColumnContent;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function columnRendererChanged(c:DataGridColumn) : void
      {
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function resizeColumn(col:int, w:Number) : void
      {
      }
      
      public function get columns() : Array
      {
         return null;
      }
      
      public function set columns(value:Array) : void
      {
      }
      
      public function get fontContext() : IFlexModuleFactory
      {
         return moduleFactory;
      }
      
      public function set fontContext(moduleFactory:IFlexModuleFactory) : void
      {
         this.moduleFactory = moduleFactory;
      }
      
      [Inspectable(category="General",defaultValue="22")]
      [Bindable("resize")]
      public function get headerHeight() : Number
      {
         return this._headerHeight;
      }
      
      public function set headerHeight(value:Number) : void
      {
         this._headerHeight = value;
         this._explicitHeaderHeight = true;
         itemsSizeChanged = true;
         invalidateDisplayList();
      }
      
      [Inspectable(defaultValue="0")]
      public function get lockedColumnCount() : int
      {
         return this._lockedColumnCount;
      }
      
      public function set lockedColumnCount(value:int) : void
      {
         this._lockedColumnCount = value;
         this.lockedColumnCountChanged = true;
         itemsSizeChanged = true;
         this.columnsInvalid = true;
         invalidateDisplayList();
      }
      
      [Inspectable(defaultValue="0")]
      public function get lockedRowCount() : int
      {
         return this._lockedRowCount;
      }
      
      public function set lockedRowCount(value:int) : void
      {
         this._lockedRowCount = value;
         this.lockedRowCountChanged = true;
         itemsSizeChanged = true;
         invalidateDisplayList();
      }
      
      [Inspectable(category="General",defaultValue="true")]
      [Bindable("showHeadersChanged")]
      public function get showHeaders() : Boolean
      {
         return this._showHeaders;
      }
      
      public function set showHeaders(value:Boolean) : void
      {
         if(value == this._showHeaders)
         {
            return;
         }
         this._showHeaders = value;
         itemsSizeChanged = true;
         invalidateDisplayList();
         dispatchEvent(new Event("showHeadersChanged"));
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get headerVisible() : Boolean
      {
         return this.showHeaders && this.headerHeight > 0;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var ci:int = 0;
         var lcri:int = 0;
         if(Boolean(this.header))
         {
            this.header.visibleColumns = this.visibleColumns;
            this.header.headerItemsChanged = true;
            this.header.invalidateSize();
            this.header.validateNow();
         }
         if(this.lockedColumnCountChanged)
         {
            this.lockedColumnCountChanged = false;
            if(this.lockedColumnCount > 0)
            {
               if(!this.lockedColumnContent)
               {
                  this.lockedColumnHeader = new this.headerClass();
                  this.lockedColumnHeader.styleName = this;
                  addChild(this.lockedColumnHeader);
                  this.lockedColumnAndRowContent = new DataGridLockedRowContentHolder(this);
                  this.lockedColumnAndRowContent.styleName = this;
                  addChild(this.lockedColumnAndRowContent);
                  this.lockedColumnContent = new ListBaseContentHolder(this);
                  this.lockedColumnContent.styleName = this;
                  addChild(this.lockedColumnContent);
               }
               this.lockedColumnHeader.visible = true;
               this.lockedColumnAndRowContent.visible = this.lockedRowCount > 0;
               this.lockedColumnContent.visible = true;
            }
            else if(Boolean(this.lockedColumnContent))
            {
               this.lockedColumnHeader.visible = false;
               this.lockedColumnAndRowContent.visible = false;
               this.lockedColumnContent.visible = false;
            }
         }
         if(this.lockedRowCountChanged && Boolean(iterator))
         {
            this.lockedRowCountChanged = false;
            if(this.lockedRowCount > 0)
            {
               if(!this.lockedRowContent)
               {
                  this.lockedRowContent = new DataGridLockedRowContentHolder(this);
                  this.lockedRowContent.styleName = this;
                  addChild(this.lockedRowContent);
               }
               this.lockedRowContent.visible = true;
            }
            else if(Boolean(this.lockedRowContent))
            {
               this.lockedRowContent.visible = false;
            }
            if(Boolean(this.lockedColumnAndRowContent))
            {
               this.lockedColumnAndRowContent.visible = this.lockedRowCount > 0 && this.lockedColumnCount > 0;
            }
            seekPositionSafely(this.lockedRowCount + verticalScrollPosition);
         }
         if(Boolean(this.lockedRowContent) && Boolean(this.lockedColumnAndRowContent))
         {
            lcri = int(getChildIndex(this.lockedColumnAndRowContent));
            ci = int(getChildIndex(this.lockedRowContent));
            if(lcri < ci)
            {
               setChildIndex(this.lockedRowContent,lcri);
            }
         }
         if(Boolean(this.lockedColumnContent) && Boolean(this.lockedColumnAndRowContent))
         {
            lcri = int(getChildIndex(this.lockedColumnAndRowContent));
            ci = int(getChildIndex(this.lockedColumnContent));
            if(lcri < ci)
            {
               setChildIndex(this.lockedColumnContent,lcri);
            }
         }
         if(this.headerVisible && Boolean(this.lockedColumnHeader))
         {
            this.lockedColumnHeader.visibleColumns = this.visibleLockedColumns;
            this.lockedColumnHeader.headerItemsChanged = true;
            this.lockedColumnHeader.invalidateSize();
            this.lockedColumnHeader.validateNow();
         }
         super.updateDisplayList(unscaledWidth,unscaledHeight);
      }
      
      override protected function makeRowsAndColumns(left:Number, top:Number, right:Number, bottom:Number, firstCol:int, firstRow:int, byCount:Boolean = false, rowsNeeded:uint = 0) : Point
      {
         return this.makeRows(listContent,left,top,right,bottom,firstCol,firstRow,byCount,rowsNeeded);
      }
      
      protected function makeRows(contentHolder:ListBaseContentHolder, left:Number, top:Number, right:Number, bottom:Number, firstCol:int, firstRow:int, byCount:Boolean = false, rowsNeeded:uint = 0, alwaysCleanup:Boolean = false) : Point
      {
         var more:Boolean;
         var valid:Boolean;
         var xx:Number = NaN;
         var yy:Number = NaN;
         var hh:Number = NaN;
         var i:int = 0;
         var j:int = 0;
         var n:int = 0;
         var item:IListItemRenderer = null;
         var data:Object = null;
         var uid:String = null;
         var bSelected:Boolean = false;
         var bHighlight:Boolean = false;
         var bCaret:Boolean = false;
         var colNum:int = 0;
         var rowNum:int = 0;
         var rowsMade:int = 0;
         var listItems:Array = contentHolder.listItems;
         var iterator:IViewCursor = contentHolder.iterator;
         var visibleData:Object = contentHolder.visibleData;
         var rowInfo:Object = contentHolder.rowInfo;
         if((!this.visibleColumns || this.visibleColumns.length == 0) && this.lockedColumnCount == 0)
         {
            while(Boolean(listItems.length))
            {
               rowNum = listItems.length - 1;
               while(Boolean(listItems[rowNum].length))
               {
                  item = listItems[rowNum].pop();
                  this.addToFreeItemRenderers(item);
               }
               listItems.pop();
            }
            contentHolder.visibleData = {};
            return new Point(0,0);
         }
         invalidateSizeFlag = true;
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
            data = more ? iterator.current : null;
            if(Boolean(iterator) && more)
            {
               try
               {
                  more = Boolean(iterator.moveNext());
               }
               catch(e:ItemPendingError)
               {
                  more = false;
                  iteratorValid = false;
               }
            }
            hh = 0;
            uid = null;
            this.prepareRowArray(contentHolder,rowNum);
            if(valid)
            {
               uid = itemToUID(data);
               hh = this.makeRow(contentHolder,rowNum,left,right,yy,data,uid);
            }
            else
            {
               hh = rowNum > 1 ? Number(rowInfo[rowNum - 1].height) : rowHeight;
            }
            if(valid && variableRowHeight)
            {
               hh = Math.ceil(this.calculateRowHeight(data,hh,true));
            }
            if(valid)
            {
               this.adjustRow(contentHolder,rowNum,yy,hh);
            }
            else
            {
               this.clearRow(contentHolder,rowNum);
            }
            bSelected = isItemSelectable(data) && isItemSelected(uid);
            bHighlight = highlightUID == uid;
            bCaret = caretUID == uid;
            this.setRowInfo(contentHolder,rowNum,yy,hh,uid);
            if(valid)
            {
               this.drawVisibleItem(uid,bSelected,bHighlight,bCaret);
            }
            if(hh == 0)
            {
               hh = rowHeight;
            }
            yy += hh;
            rowNum++;
            rowsMade++;
         }
         if(!byCount || alwaysCleanup)
         {
            while(rowNum < listItems.length)
            {
               this.removeExtraRow(contentHolder);
            }
         }
         invalidateSizeFlag = false;
         return new Point(colNum,rowsMade);
      }
      
      protected function prepareRowArray(contentHolder:ListBaseContentHolder, rowNum:int) : void
      {
         var columnContent:ListBaseContentHolder = null;
         var listItems:Array = contentHolder.listItems;
         if(this.lockedColumnCount > 0)
         {
            if(contentHolder == this.lockedRowContent)
            {
               columnContent = this.lockedColumnAndRowContent;
            }
            else
            {
               columnContent = this.lockedColumnContent;
            }
         }
         else
         {
            columnContent = null;
         }
         if(!listItems[rowNum])
         {
            listItems[rowNum] = [];
         }
         if(Boolean(columnContent))
         {
            if(!columnContent.listItems[rowNum])
            {
               columnContent.listItems[rowNum] = [];
            }
         }
      }
      
      protected function makeRow(contentHolder:ListBaseContentHolder, rowNum:int, left:Number, right:Number, yy:Number, data:Object, uid:String) : Number
      {
         var columnContent:ListBaseContentHolder = null;
         var item:IListItemRenderer = null;
         var extraItem:IListItemRenderer = null;
         var c:DataGridColumn = null;
         var itemSize:Point = null;
         var listItems:Array = contentHolder.listItems;
         if(this.lockedColumnCount > 0)
         {
            if(contentHolder == this.lockedRowContent)
            {
               columnContent = this.lockedColumnAndRowContent;
            }
            else
            {
               columnContent = this.lockedColumnContent;
            }
         }
         else
         {
            columnContent = null;
         }
         var colNum:int = 0;
         var xx:Number = left;
         var hh:Number = 0;
         while(colNum < this.visibleLockedColumns.length)
         {
            c = this.visibleLockedColumns[colNum];
            item = this.setupColumnItemRenderer(c,columnContent,rowNum,colNum,data,uid);
            itemSize = this.layoutColumnItemRenderer(c,item,xx,yy);
            xx += itemSize.x;
            colNum++;
            hh = Math.ceil(Math.max(hh,variableRowHeight ? itemSize.y + cachedPaddingTop + cachedPaddingBottom : rowHeight));
         }
         if(Boolean(this.visibleLockedColumns.length))
         {
            while(columnContent.listItems[rowNum].length > colNum)
            {
               extraItem = columnContent.listItems[rowNum].pop();
               this.addToFreeItemRenderers(extraItem);
            }
         }
         colNum = 0;
         xx = left;
         while(xx < right && colNum < this.visibleColumns.length)
         {
            c = this.visibleColumns[colNum];
            item = this.setupColumnItemRenderer(c,contentHolder,rowNum,colNum,data,uid);
            itemSize = this.layoutColumnItemRenderer(c,item,xx,yy);
            xx += itemSize.x;
            colNum++;
            hh = Math.ceil(Math.max(hh,variableRowHeight ? itemSize.y + cachedPaddingTop + cachedPaddingBottom : rowHeight));
         }
         while(listItems[rowNum].length > colNum)
         {
            extraItem = listItems[rowNum].pop();
            this.addToFreeItemRenderers(extraItem);
         }
         return hh;
      }
      
      protected function clearRow(contentHolder:ListBaseContentHolder, rowNum:int) : void
      {
         var columnContent:ListBaseContentHolder = null;
         var extraItem:IListItemRenderer = null;
         var listItems:Array = contentHolder.listItems;
         if(this.lockedColumnCount > 0)
         {
            if(contentHolder == this.lockedRowContent)
            {
               columnContent = this.lockedColumnAndRowContent;
            }
            else
            {
               columnContent = this.lockedColumnContent;
            }
         }
         else
         {
            columnContent = null;
         }
         while(Boolean(listItems[rowNum].length))
         {
            extraItem = listItems[rowNum].pop();
            this.addToFreeItemRenderers(extraItem);
         }
         if(Boolean(columnContent))
         {
            while(Boolean(columnContent.listItems[rowNum].length))
            {
               extraItem = columnContent.listItems[rowNum].pop();
               this.addToFreeItemRenderers(extraItem);
            }
         }
      }
      
      protected function adjustRow(contentHolder:ListBaseContentHolder, rowNum:int, yy:Number, hh:Number) : void
      {
         var columnContent:ListBaseContentHolder = null;
         var i:int = 0;
         var j:int = 0;
         var n:int = 0;
         var colNum:int = 0;
         var item:IListItemRenderer = null;
         var listItems:Array = contentHolder.listItems;
         if(this.lockedColumnCount > 0)
         {
            if(contentHolder == this.lockedRowContent)
            {
               columnContent = this.lockedColumnAndRowContent;
            }
            else
            {
               columnContent = this.lockedColumnContent;
            }
         }
         else
         {
            columnContent = null;
         }
         if(Boolean(listItems[rowNum]))
         {
            if(Boolean(columnContent))
            {
               n = int(columnContent.listItems[rowNum].length);
               for(j = 0; j < n; j++)
               {
                  columnContent.listItems[rowNum][j].setActualSize(columnContent.listItems[rowNum][j].width,hh - cachedPaddingTop - cachedPaddingBottom);
               }
            }
            n = int(listItems[rowNum].length);
            for(j = 0; j < n; j++)
            {
               listItems[rowNum][j].setActualSize(listItems[rowNum][j].width,hh - cachedPaddingTop - cachedPaddingBottom);
            }
         }
         if(cachedVerticalAlign != "top")
         {
            if(cachedVerticalAlign == "bottom")
            {
               colNum = int(listItems[rowNum].length);
               for(j = 0; j < colNum; j++)
               {
                  item = listItems[rowNum][j];
                  item.move(item.x,yy + hh - cachedPaddingBottom - item.getExplicitOrMeasuredHeight());
               }
               if(Boolean(columnContent))
               {
                  n = int(columnContent.listItems[rowNum].length);
                  for(j = 0; j < n; j++)
                  {
                     item = columnContent.listItems[rowNum][j];
                     item.move(item.x,yy + hh - cachedPaddingBottom - item.getExplicitOrMeasuredHeight());
                  }
               }
            }
            else
            {
               colNum = int(listItems[rowNum].length);
               for(j = 0; j < colNum; j++)
               {
                  item = listItems[rowNum][j];
                  item.move(item.x,yy + cachedPaddingTop + (hh - cachedPaddingBottom - cachedPaddingTop - item.getExplicitOrMeasuredHeight()) / 2);
               }
               if(Boolean(columnContent))
               {
                  n = int(columnContent.listItems[rowNum].length);
                  for(j = 0; j < n; j++)
                  {
                     item = columnContent.listItems[rowNum][j];
                     item.move(item.x,yy + cachedPaddingTop + (hh - cachedPaddingBottom - cachedPaddingTop - item.getExplicitOrMeasuredHeight()) / 2);
                  }
               }
            }
         }
      }
      
      protected function setRowInfo(contentHolder:ListBaseContentHolder, rowNum:int, yy:Number, hh:Number, uid:String) : void
      {
         var columnContent:ListBaseContentHolder = null;
         var listItems:Array = contentHolder.listItems;
         var rowInfo:Object = contentHolder.rowInfo;
         if(this.lockedColumnCount > 0)
         {
            if(contentHolder == this.lockedRowContent)
            {
               columnContent = this.lockedColumnAndRowContent;
            }
            else
            {
               columnContent = this.lockedColumnContent;
            }
         }
         else
         {
            columnContent = null;
         }
         rowInfo[rowNum] = new ListRowInfo(yy,hh,uid);
         if(Boolean(columnContent))
         {
            columnContent.rowInfo[rowNum] = rowInfo[rowNum];
         }
      }
      
      protected function removeExtraRow(contentHolder:ListBaseContentHolder) : void
      {
         var item:IListItemRenderer = null;
         var columnContent:ListBaseContentHolder = null;
         var listItems:Array = contentHolder.listItems;
         var rowInfo:Object = contentHolder.rowInfo;
         if(contentHolder == this.lockedRowContent)
         {
            columnContent = this.lockedColumnAndRowContent;
         }
         else
         {
            columnContent = this.lockedColumnContent;
         }
         var rr:Array = listItems.pop();
         rowInfo.pop();
         while(Boolean(rr.length))
         {
            item = rr.pop();
            this.addToFreeItemRenderers(item);
         }
         if(Boolean(columnContent))
         {
            columnContent.rowInfo.pop();
            rr = columnContent.listItems.pop();
            while(Boolean(rr) && Boolean(rr.length))
            {
               item = rr.pop();
               this.addToFreeItemRenderers(item);
            }
         }
      }
      
      protected function setupColumnItemRenderer(c:DataGridColumn, contentHolder:ListBaseContentHolder, rowNum:int, colNum:int, data:Object, uid:String) : IListItemRenderer
      {
         var item:IListItemRenderer = null;
         var rowData:DataGridListData = null;
         var listItems:Array = contentHolder.listItems;
         item = listItems[rowNum][colNum];
         if(!item || itemToUID(item.data) != uid || this.columnMap[item.name] != c)
         {
            item = this.createColumnItemRenderer(c,false,data);
            if(item == null)
            {
               return null;
            }
            if(item.parent != contentHolder)
            {
               contentHolder.addChild(DisplayObject(item));
            }
            this.columnMap[item.name] = c;
            if(Boolean(listItems[rowNum][colNum]))
            {
               this.addToFreeItemRenderers(listItems[rowNum][colNum]);
            }
            listItems[rowNum][colNum] = item;
         }
         rowData = DataGridListData(this.makeListData(data,uid,rowNum,c.colNum,c));
         rowMap[item.name] = rowData;
         if(item is IDropInListItemRenderer)
         {
            IDropInListItemRenderer(item).listData = Boolean(data) ? rowData : null;
         }
         item.data = data;
         item.visible = true;
         if(Boolean(uid) && colNum == 0)
         {
            contentHolder.visibleData[uid] = item;
         }
         return item;
      }
      
      protected function layoutColumnItemRenderer(c:DataGridColumn, item:IListItemRenderer, xx:Number, yy:Number) : Point
      {
         var ww:Number = 0;
         var rh:Number = 0;
         if(Boolean(item))
         {
            item.explicitWidth = ww = this.getWidthOfItem(item,c);
            UIComponentGlobals.layoutManager.validateClient(item,true);
            rh = Number(item.getExplicitOrMeasuredHeight());
            item.setActualSize(ww,variableRowHeight ? Number(item.getExplicitOrMeasuredHeight()) : rowHeight - cachedPaddingTop - cachedPaddingBottom);
            item.move(xx,yy + cachedPaddingTop);
         }
         return new Point(ww,rh);
      }
      
      protected function drawVisibleItem(uid:String, selected:Boolean = false, highlighted:Boolean = false, caret:Boolean = false, transition:Boolean = false) : void
      {
         if(Boolean(visibleData[uid]))
         {
            this.drawItem(visibleData[uid],selected,highlighted,caret,transition);
         }
         if(Boolean(this.lockedRowCount) && Boolean(this.lockedRowContent) && Boolean(this.lockedRowContent.visibleData[uid]))
         {
            this.drawItem(this.lockedRowContent.visibleData[uid],selected,highlighted,caret,transition);
         }
      }
      
      override protected function drawItem(item:IListItemRenderer, selected:Boolean = false, highlighted:Boolean = false, caret:Boolean = false, transition:Boolean = false) : void
      {
         var i:int = 0;
         var r:IListItemRenderer = null;
         var columnContents:ListBaseContentHolder = null;
         if(!item)
         {
            return;
         }
         super.drawItem(item,selected,highlighted,caret,transition);
         var rowIndex:int = int(rowMap[item.name].rowIndex);
         for(i = 0; i < this.visibleColumns.length; i++)
         {
            r = (item.parent as ListBaseContentHolder).listItems[rowIndex][i];
            this.updateRendererDisplayList(r);
         }
         if(Boolean(this.lockedColumnCount))
         {
            if(item.parent == listContent || item.parent == this.lockedColumnContent)
            {
               columnContents = this.lockedColumnContent;
            }
            else
            {
               columnContents = this.lockedColumnAndRowContent;
            }
            for(i = 0; i < this.visibleLockedColumns.length; i++)
            {
               r = columnContents.listItems[rowIndex][i];
               this.updateRendererDisplayList(r);
            }
         }
      }
      
      protected function updateRendererDisplayList(r:IListItemRenderer) : void
      {
         var ui:IInvalidating = null;
         if(r is IInvalidating)
         {
            ui = IInvalidating(r);
            ui.invalidateDisplayList();
            ui.validateNow();
         }
      }
      
      override protected function addToFreeItemRenderers(item:IListItemRenderer) : void
      {
         var c:DataGridColumn = null;
         DisplayObject(item).visible = false;
         delete rowMap[item.name];
         var factory:IFactory = factoryMap[item];
         var UID:String = itemToUID(item.data);
         var visibleData:Object = ListBaseContentHolder(item.parent).visibleData;
         if(visibleData[UID] == item)
         {
            delete visibleData[UID];
         }
         if(Boolean(this.columnMap[item.name]))
         {
            c = this.columnMap[item.name];
            if(factory == c.itemRenderer)
            {
               if(this.freeItemRenderersTable[c] == undefined)
               {
                  this.freeItemRenderersTable[c] = [];
               }
               this.freeItemRenderersTable[c].push(item);
            }
            if(!c.freeItemRenderersByFactory)
            {
               c.freeItemRenderersByFactory = new Dictionary(true);
            }
            if(c.freeItemRenderersByFactory[factory] == undefined)
            {
               c.freeItemRenderersByFactory[factory] = new Dictionary(true);
            }
            c.freeItemRenderersByFactory[factory][item] = 1;
            delete this.columnMap[item.name];
         }
      }
      
      override protected function purgeItemRenderers() : void
      {
         var listItems:Array = null;
         var row:Array = null;
         var item:IListItemRenderer = null;
         if(Boolean(this.lockedRowContent))
         {
            listItems = this.lockedRowContent.listItems;
            while(Boolean(listItems.length))
            {
               row = listItems.pop();
               while(Boolean(row.length))
               {
                  item = IListItemRenderer(row.pop());
                  if(Boolean(item))
                  {
                     this.lockedRowContent.removeChild(DisplayObject(item));
                     delete this.lockedRowContent.visibleData[itemToUID(item.data)];
                  }
               }
            }
         }
         if(Boolean(this.lockedColumnContent))
         {
            listItems = this.lockedColumnContent.listItems;
            while(Boolean(listItems.length))
            {
               row = listItems.pop();
               while(Boolean(row.length))
               {
                  item = IListItemRenderer(row.pop());
                  if(Boolean(item))
                  {
                     this.lockedColumnContent.removeChild(DisplayObject(item));
                     delete this.lockedColumnContent.visibleData[itemToUID(item.data)];
                  }
               }
            }
         }
         if(Boolean(this.lockedColumnAndRowContent))
         {
            listItems = this.lockedColumnAndRowContent.listItems;
            while(Boolean(listItems.length))
            {
               row = listItems.pop();
               while(Boolean(row.length))
               {
                  item = IListItemRenderer(row.pop());
                  if(Boolean(item))
                  {
                     this.lockedColumnAndRowContent.removeChild(DisplayObject(item));
                     delete this.lockedColumnAndRowContent.visibleData[itemToUID(item.data)];
                  }
               }
            }
         }
         super.purgeItemRenderers();
      }
      
      override public function indicesToIndex(rowIndex:int, colIndex:int) : int
      {
         if(this.inSelectItem)
         {
            return 0;
         }
         return rowIndex;
      }
      
      protected function makeListData(data:Object, uid:String, rowNum:int, columnNum:int, column:DataGridColumn) : BaseListData
      {
         if(data is DataGridColumn)
         {
            return new DataGridListData(column.headerText != null ? column.headerText : column.dataField,column.dataField,columnNum,uid,this,rowNum);
         }
         return new DataGridListData(column.itemToLabel(data),column.dataField,columnNum,uid,this,rowNum);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getWidthOfItem(item:IListItemRenderer, col:DataGridColumn) : Number
      {
         return col.width;
      }
      
      protected function calculateRowHeight(data:Object, hh:Number, skipVisible:Boolean = false) : Number
      {
         return NaN;
      }
      
      public function createColumnItemRenderer(c:DataGridColumn, forHeader:Boolean, data:Object) : IListItemRenderer
      {
         var factory:IFactory = null;
         var renderer:IListItemRenderer = null;
         var d:Dictionary = null;
         var p:* = undefined;
         factory = c.getItemRendererFactory(forHeader,data);
         if(!factory)
         {
            if(!data)
            {
               factory = nullItemRenderer;
            }
            if(!factory)
            {
               factory = itemRenderer;
            }
         }
         if(factory == c.itemRenderer)
         {
            if(Boolean(this.freeItemRenderersTable[c]) && Boolean(this.freeItemRenderersTable[c].length))
            {
               renderer = this.freeItemRenderersTable[c].pop();
               delete c.freeItemRenderersByFactory[factory][renderer];
            }
         }
         else if(Boolean(c.freeItemRenderersByFactory))
         {
            d = c.freeItemRenderersByFactory[factory];
            if(Boolean(d))
            {
               var _loc8_:int = 0;
               var _loc9_:* = d;
               for(p in _loc9_)
               {
                  renderer = IListItemRenderer(p);
                  delete d[p];
               }
            }
         }
         if(!renderer)
         {
            renderer = factory.newInstance();
            if(Boolean(renderer))
            {
               renderer.styleName = c;
               factoryMap[renderer] = factory;
            }
         }
         if(Boolean(renderer))
         {
            renderer.owner = this;
         }
         return renderer;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function columnHeaderWordWrap(c:DataGridColumn) : Boolean
      {
         if(c.headerWordWrap == true)
         {
            return true;
         }
         if(c.headerWordWrap == false)
         {
            return false;
         }
         return wordWrap;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function columnWordWrap(c:DataGridColumn) : Boolean
      {
         if(c.wordWrap == true)
         {
            return true;
         }
         if(c.wordWrap == false)
         {
            return false;
         }
         return wordWrap;
      }
      
      override protected function clearIndicators() : void
      {
         super.clearIndicators();
         if(Boolean(this.lockedColumnCount) && Boolean(this.lockedColumnContent))
         {
            while(this.lockedColumnContent.selectionLayer.numChildren > 0)
            {
               this.lockedColumnContent.selectionLayer.removeChildAt(0);
            }
         }
         if(Boolean(this.lockedRowCount) && Boolean(this.lockedRowContent))
         {
            while(this.lockedRowContent.selectionLayer.numChildren > 0)
            {
               this.lockedRowContent.selectionLayer.removeChildAt(0);
            }
            if(Boolean(this.lockedColumnCount) && Boolean(this.lockedColumnAndRowContent))
            {
               while(this.lockedColumnAndRowContent.selectionLayer.numChildren > 0)
               {
                  this.lockedColumnAndRowContent.selectionLayer.removeChildAt(0);
               }
            }
         }
         if(Boolean(this.header))
         {
            this.header.clearSelectionLayer();
         }
         if(Boolean(this.lockedColumnHeader))
         {
            this.lockedColumnHeader.clearSelectionLayer();
         }
      }
      
      override protected function drawHighlightIndicator(indicator:Sprite, x:Number, y:Number, width:Number, height:Number, color:uint, itemRenderer:IListItemRenderer) : void
      {
         var columnContents:ListBaseContentHolder = null;
         var selectionLayer:Sprite = null;
         super.drawHighlightIndicator(indicator,x,y,unscaledWidth - viewMetrics.left - viewMetrics.right,height,color,itemRenderer);
         if(Boolean(this.lockedColumnCount))
         {
            if(itemRenderer.parent == listContent)
            {
               columnContents = this.lockedColumnContent;
            }
            else
            {
               columnContents = this.lockedColumnAndRowContent;
            }
            selectionLayer = columnContents.selectionLayer;
            if(!this.columnHighlightIndicator)
            {
               this.columnHighlightIndicator = new SpriteAsset();
               columnContents.selectionLayer.addChild(DisplayObject(this.columnHighlightIndicator));
            }
            else if(this.columnHighlightIndicator.parent != selectionLayer)
            {
               selectionLayer.addChild(this.columnHighlightIndicator);
            }
            else
            {
               selectionLayer.setChildIndex(DisplayObject(this.columnHighlightIndicator),selectionLayer.numChildren - 1);
            }
            if(this.columnHighlightIndicator is ILayoutDirectionElement)
            {
               ILayoutDirectionElement(this.columnHighlightIndicator).layoutDirection = null;
            }
            super.drawHighlightIndicator(this.columnHighlightIndicator,x,y,columnContents.width,height,color,itemRenderer);
         }
      }
      
      override protected function clearHighlightIndicator(indicator:Sprite, itemRenderer:IListItemRenderer) : void
      {
         super.clearHighlightIndicator(indicator,itemRenderer);
         if(Boolean(this.lockedColumnCount))
         {
            if(Boolean(this.columnHighlightIndicator))
            {
               Sprite(this.columnHighlightIndicator).graphics.clear();
            }
         }
      }
      
      override protected function drawCaretIndicator(indicator:Sprite, x:Number, y:Number, width:Number, height:Number, color:uint, itemRenderer:IListItemRenderer) : void
      {
         var columnContents:ListBaseContentHolder = null;
         var selectionLayer:Sprite = null;
         super.drawCaretIndicator(indicator,x,y,unscaledWidth - viewMetrics.left - viewMetrics.right,height,color,itemRenderer);
         if(Boolean(this.lockedColumnCount))
         {
            if(itemRenderer.parent == listContent)
            {
               columnContents = this.lockedColumnContent;
            }
            else
            {
               columnContents = this.lockedColumnAndRowContent;
            }
            selectionLayer = columnContents.selectionLayer;
            if(!this.columnCaretIndicator)
            {
               this.columnCaretIndicator = new SpriteAsset();
               columnContents.selectionLayer.addChild(DisplayObject(this.columnCaretIndicator));
            }
            else if(this.columnCaretIndicator.parent != selectionLayer)
            {
               selectionLayer.addChild(this.columnCaretIndicator);
            }
            else
            {
               selectionLayer.setChildIndex(DisplayObject(this.columnCaretIndicator),selectionLayer.numChildren - 1);
            }
            if(this.columnCaretIndicator is ILayoutDirectionElement)
            {
               ILayoutDirectionElement(this.columnCaretIndicator).layoutDirection = null;
            }
            super.drawCaretIndicator(this.columnCaretIndicator,x,y,columnContents.width,height,color,itemRenderer);
         }
      }
      
      override protected function clearCaretIndicator(indicator:Sprite, itemRenderer:IListItemRenderer) : void
      {
         super.clearCaretIndicator(indicator,itemRenderer);
         if(Boolean(this.lockedColumnCount))
         {
            if(Boolean(this.columnCaretIndicator))
            {
               Sprite(this.columnCaretIndicator).graphics.clear();
            }
         }
      }
      
      override protected function drawSelectionIndicator(indicator:Sprite, x:Number, y:Number, width:Number, height:Number, color:uint, itemRenderer:IListItemRenderer) : void
      {
         var columnContents:ListBaseContentHolder = null;
         var selectionLayer:Sprite = null;
         var columnIndicator:Sprite = null;
         super.drawSelectionIndicator(indicator,x,y,unscaledWidth - viewMetrics.left - viewMetrics.right,height,color,itemRenderer);
         if(Boolean(this.lockedColumnCount))
         {
            if(itemRenderer.parent == listContent)
            {
               columnContents = this.lockedColumnContent;
            }
            else
            {
               columnContents = this.lockedColumnAndRowContent;
            }
            selectionLayer = columnContents.selectionLayer;
            columnIndicator = this.indicatorDictionary[indicator] as Sprite;
            if(!columnIndicator)
            {
               columnIndicator = new SpriteAsset();
               columnIndicator.mouseEnabled = false;
               selectionLayer.addChild(DisplayObject(columnIndicator));
               indicator.parent.addEventListener(Event.REMOVED,this.selectionRemovedListener);
               this.indicatorDictionary[indicator] = columnIndicator;
            }
            if(columnIndicator is ILayoutDirectionElement)
            {
               ILayoutDirectionElement(columnIndicator).layoutDirection = null;
            }
            super.drawSelectionIndicator(columnIndicator,x,y,columnContents.width,height,color,itemRenderer);
         }
      }
      
      private function selectionRemovedListener(event:Event) : void
      {
         if(!this.lockedColumnCount)
         {
            return;
         }
         var columnIndicator:Sprite = this.indicatorDictionary[event.target] as Sprite;
         if(Boolean(columnIndicator))
         {
            columnIndicator.parent.removeChild(columnIndicator);
         }
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function mouseEventToItemRendererOrEditor(event:MouseEvent) : IListItemRenderer
      {
         var currentContent:ListBaseContentHolder = null;
         var listItems:Array = null;
         var rowInfo:Array = null;
         var pt:Point = null;
         var yy:Number = NaN;
         var n:int = 0;
         var i:int = 0;
         var xx:Number = NaN;
         var m:int = 0;
         var j:int = 0;
         var isHighlight:Boolean = false;
         var target:DisplayObject = DisplayObject(event.target);
         var visibleColumns:Array = this.visibleColumns;
         if(event.target == listContent)
         {
            currentContent = listContent;
         }
         else if(event.target == this.lockedColumnContent)
         {
            currentContent = this.lockedColumnContent;
            visibleColumns = this.visibleLockedColumns;
         }
         else if(event.target == this.lockedRowContent)
         {
            currentContent = this.lockedRowContent;
         }
         else if(event.target == this.lockedColumnAndRowContent)
         {
            currentContent = this.lockedColumnAndRowContent;
            visibleColumns = this.visibleLockedColumns;
         }
         else if(event.target == highlightIndicator)
         {
            currentContent = highlightIndicator.parent.parent as ListBaseContentHolder;
            visibleColumns = this.visibleColumns;
            if(currentContent == this.lockedColumnContent || currentContent == this.lockedColumnAndRowContent)
            {
               visibleColumns = this.visibleLockedColumns;
            }
            isHighlight = true;
         }
         else if(event.target == this.columnHighlightIndicator)
         {
            currentContent = this.columnHighlightIndicator.parent.parent as ListBaseContentHolder;
            visibleColumns = this.visibleColumns;
            if(currentContent == this.lockedColumnContent || currentContent == this.lockedColumnAndRowContent)
            {
               visibleColumns = this.visibleLockedColumns;
            }
            isHighlight = true;
         }
         if(isHighlight || target == currentContent)
         {
            listItems = currentContent.listItems;
            rowInfo = currentContent.rowInfo;
            pt = new Point(event.stageX,event.stageY);
            pt = currentContent.globalToLocal(pt);
            yy = 0;
            n = int(listItems.length);
            for(i = 0; i < n; yy += rowInfo[i].height,i++)
            {
               if(Boolean(listItems[i].length))
               {
                  if(pt.y < yy + rowInfo[i].height)
                  {
                     xx = 0;
                     m = int(visibleColumns.length);
                     j = 0;
                     while(j < m)
                     {
                        if(pt.x < xx + visibleColumns[j].width)
                        {
                           return listItems[i][j];
                        }
                        xx += visibleColumns[j].width;
                        j++;
                     }
                  }
               }
            }
         }
         while(Boolean(target) && target != this)
         {
            if(Boolean(target is IListItemRenderer && target.parent) && Boolean(target.parent.parent == this) && target.parent is ListBaseContentHolder)
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
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getAllVisibleColumns() : Array
      {
         var temp:Array = [];
         if(Boolean(this.lockedColumnCount))
         {
            temp = temp.concat(this.visibleLockedColumns);
         }
         return temp.concat(this.visibleColumns);
      }
      
      override protected function UIDToItemRenderer(uid:String) : IListItemRenderer
      {
         var r:IListItemRenderer = visibleData[uid];
         if(!r)
         {
            if(Boolean(this.lockedRowContent))
            {
               r = this.lockedRowContent.visibleData[uid];
            }
         }
         if(!r)
         {
            if(Boolean(this.lockedColumnContent))
            {
               r = this.lockedColumnContent.visibleData[uid];
            }
         }
         if(!r)
         {
            if(Boolean(this.lockedColumnAndRowContent))
            {
               r = this.lockedColumnAndRowContent.visibleData[uid];
            }
         }
         return r;
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function addClipMask(layoutChanged:Boolean) : void
      {
         var g:Graphics = null;
         var item:DisplayObject = null;
         var yOffset:Number = NaN;
         if(layoutChanged)
         {
            if(Boolean(horizontalScrollBar && horizontalScrollBar.visible || hasOnlyTextRenderers() || listContent.bottomOffset != 0 || listContent.topOffset != 0) || Boolean(listContent.leftOffset != 0) || listContent.rightOffset != 0)
            {
               listContent.mask = maskShape;
               selectionLayer.mask = null;
               if(!this.headerMask)
               {
                  this.headerMask = new Shape();
                  addChild(this.headerMask);
                  g = this.headerMask.graphics;
                  g.beginFill(16777215);
                  g.drawRect(0,0,10,10);
                  g.endFill();
                  this.headerMask.visible = false;
               }
               this.header.mask = this.headerMask;
               this.header.selectionLayer.mask = null;
               this.headerMask.width = maskShape.width;
               this.headerMask.height = maskShape.height;
               this.headerMask.x = maskShape.x;
               this.headerMask.y = maskShape.y;
               if(verticalScrollBar != null && Boolean(verticalScrollBar.visible) && (horizontalScrollBar == null || !horizontalScrollBar.visible) && this.headerVisible)
               {
                  this.headerMask.width += verticalScrollBar.getExplicitOrMeasuredWidth();
               }
               if(Boolean(this.lockedRowContent))
               {
                  if(!this.lockedRowMask)
                  {
                     this.lockedRowMask = new Shape();
                     addChild(this.lockedRowMask);
                     g = this.lockedRowMask.graphics;
                     g.beginFill(16777215);
                     g.drawRect(0,0,10,10);
                     g.endFill();
                     this.lockedRowMask.visible = false;
                  }
                  this.lockedRowContent.mask = this.lockedRowMask;
                  this.lockedRowContent.selectionLayer.mask = null;
                  this.lockedRowMask.width = maskShape.width;
                  this.lockedRowMask.height = maskShape.height;
                  this.lockedRowMask.x = maskShape.x;
                  this.lockedRowMask.y = maskShape.y;
               }
               if(Boolean(this.lockedColumnContent))
               {
                  if(!this.lockedColumnMask)
                  {
                     this.lockedColumnMask = new Shape();
                     addChild(this.lockedColumnMask);
                     g = this.lockedColumnMask.graphics;
                     g.beginFill(16777215);
                     g.drawRect(0,0,10,10);
                     g.endFill();
                     this.lockedColumnMask.visible = false;
                  }
                  this.lockedColumnContent.mask = this.lockedColumnMask;
                  this.lockedColumnContent.selectionLayer.mask = null;
                  this.lockedColumnMask.width = maskShape.width;
                  this.lockedColumnMask.height = maskShape.height;
                  this.lockedColumnMask.x = maskShape.x;
                  this.lockedColumnMask.y = maskShape.y;
               }
               if(Boolean(this.lockedColumnAndRowContent))
               {
                  if(!this.lockedColumnAndRowMask)
                  {
                     this.lockedColumnAndRowMask = new Shape();
                     addChild(this.lockedColumnAndRowMask);
                     g = this.lockedColumnAndRowMask.graphics;
                     g.beginFill(16777215);
                     g.drawRect(0,0,10,10);
                     g.endFill();
                     this.lockedColumnAndRowMask.visible = false;
                  }
                  this.lockedColumnAndRowContent.mask = this.lockedColumnAndRowMask;
                  this.lockedColumnAndRowContent.selectionLayer.mask = null;
                  this.lockedColumnAndRowMask.width = maskShape.width;
                  this.lockedColumnAndRowMask.height = maskShape.height;
                  this.lockedColumnAndRowMask.x = maskShape.x;
                  this.lockedColumnAndRowMask.y = maskShape.y;
               }
               if(Boolean(this.lockedColumnHeader))
               {
                  if(!this.lockedColumnHeaderMask)
                  {
                     this.lockedColumnHeaderMask = new Shape();
                     addChild(this.lockedColumnHeaderMask);
                     g = this.lockedColumnHeaderMask.graphics;
                     g.beginFill(16777215);
                     g.drawRect(0,0,10,10);
                     g.endFill();
                     this.lockedColumnHeaderMask.visible = false;
                  }
                  this.lockedColumnHeader.mask = this.lockedColumnHeaderMask;
                  this.lockedColumnHeader.selectionLayer.mask = null;
                  this.lockedColumnHeaderMask.width = maskShape.width;
                  this.lockedColumnHeaderMask.height = maskShape.height;
                  this.lockedColumnHeaderMask.x = maskShape.x;
                  this.lockedColumnHeaderMask.y = maskShape.y;
               }
            }
            else
            {
               listContent.mask = null;
               selectionLayer.mask = maskShape;
               if(!this.headerMask)
               {
                  this.headerMask = new Shape();
                  addChild(this.headerMask);
                  g = this.headerMask.graphics;
                  g.beginFill(16777215);
                  g.drawRect(0,0,10,10);
                  g.endFill();
                  this.headerMask.visible = false;
               }
               this.header.mask = null;
               this.header.selectionLayer.mask = this.headerMask;
               this.headerMask.width = maskShape.width;
               this.headerMask.height = maskShape.height;
               this.headerMask.x = maskShape.x;
               this.headerMask.y = maskShape.y;
               if(verticalScrollBar != null && Boolean(verticalScrollBar.visible) && (horizontalScrollBar == null || !horizontalScrollBar.visible) && this.headerVisible)
               {
                  this.headerMask.width += verticalScrollBar.getExplicitOrMeasuredWidth();
               }
               if(Boolean(this.lockedRowContent))
               {
                  if(!this.lockedRowMask)
                  {
                     this.lockedRowMask = new Shape();
                     addChild(this.lockedRowMask);
                     g = this.lockedRowMask.graphics;
                     g.beginFill(16777215);
                     g.drawRect(0,0,10,10);
                     g.endFill();
                     this.lockedRowMask.visible = false;
                  }
                  this.lockedRowContent.mask = null;
                  this.lockedRowContent.selectionLayer.mask = this.lockedRowMask;
                  this.lockedRowMask.width = maskShape.width;
                  this.lockedRowMask.height = maskShape.height;
                  this.lockedRowMask.x = maskShape.x;
                  this.lockedRowMask.y = maskShape.y;
               }
               if(Boolean(this.lockedColumnContent))
               {
                  if(!this.lockedColumnMask)
                  {
                     this.lockedColumnMask = new Shape();
                     addChild(this.lockedColumnMask);
                     g = this.lockedColumnMask.graphics;
                     g.beginFill(16777215);
                     g.drawRect(0,0,10,10);
                     g.endFill();
                     this.lockedColumnMask.visible = false;
                  }
                  this.lockedColumnContent.mask = null;
                  this.lockedColumnContent.selectionLayer.mask = this.lockedColumnMask;
                  this.lockedColumnMask.width = maskShape.width;
                  this.lockedColumnMask.height = maskShape.height;
                  this.lockedColumnMask.x = maskShape.x;
                  this.lockedColumnMask.y = maskShape.y;
               }
               if(Boolean(this.lockedColumnAndRowContent))
               {
                  if(!this.lockedColumnAndRowMask)
                  {
                     this.lockedColumnAndRowMask = new Shape();
                     addChild(this.lockedColumnAndRowMask);
                     g = this.lockedColumnAndRowMask.graphics;
                     g.beginFill(16777215);
                     g.drawRect(0,0,10,10);
                     g.endFill();
                     this.lockedColumnAndRowMask.visible = false;
                  }
                  this.lockedColumnAndRowContent.mask = null;
                  this.lockedColumnAndRowContent.selectionLayer.mask = this.lockedColumnAndRowMask;
                  this.lockedColumnAndRowMask.width = maskShape.width;
                  this.lockedColumnAndRowMask.height = maskShape.height;
                  this.lockedColumnAndRowMask.x = maskShape.x;
                  this.lockedColumnAndRowMask.y = maskShape.y;
               }
               if(Boolean(this.lockedColumnHeader))
               {
                  if(!this.lockedColumnHeaderMask)
                  {
                     this.lockedColumnHeaderMask = new Shape();
                     addChild(this.lockedColumnHeaderMask);
                     g = this.lockedColumnHeaderMask.graphics;
                     g.beginFill(16777215);
                     g.drawRect(0,0,10,10);
                     g.endFill();
                     this.lockedColumnHeaderMask.visible = false;
                  }
                  this.lockedColumnHeader.mask = null;
                  this.lockedColumnHeader.selectionLayer.mask = this.lockedColumnHeaderMask;
                  this.lockedColumnHeaderMask.width = maskShape.width;
                  this.lockedColumnHeaderMask.height = maskShape.height;
                  this.lockedColumnHeaderMask.x = maskShape.x;
                  this.lockedColumnHeaderMask.y = maskShape.y;
               }
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
         var rowY:Number = lastRowInfo.y;
         var rowWidth:Number = Number(listContent.width);
         var rowHeight:Number = listContent.height - lastRowInfo.y;
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
               item.mask = createItemMask(0,rowY + yOffset,rowWidth,Math.max(rowHeight - yOffset,0));
            }
         }
         if(Boolean(this.lockedColumnContent))
         {
            lastRowItems = this.lockedColumnContent.listItems[lastRowIndex];
            numColumns = int(lastRowItems.length);
            rowWidth = Number(this.lockedColumnContent.width);
            for(i = 0; i < numColumns; i++)
            {
               item = lastRowItems[i];
               yOffset = item.y - rowY;
               if(item is IUITextField && !IUITextField(item).embedFonts)
               {
                  item.height = Math.max(rowHeight - yOffset,0);
               }
               else
               {
                  item.mask = createItemMask(0,rowY + yOffset,rowWidth,Math.max(rowHeight - yOffset,0),this.lockedColumnContent);
               }
            }
         }
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function removeClipMask() : void
      {
         var numColumns:int = 0;
         var i:int = 0;
         var item:DisplayObject = null;
         super.removeClipMask();
         if(!this.lockedColumnContent)
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
         var lastRowItems:Array = this.lockedColumnContent.listItems[lastRowIndex];
         if(Boolean(lastRowItems))
         {
            numColumns = int(lastRowItems.length);
            for(i = 0; i < numColumns; i++)
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
                  itemMaskFreeList.push(item.mask);
                  item.mask = null;
               }
            }
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get gridColumnMap() : Object
      {
         return this.columnMap;
      }
      
      override public function itemRendererToIndex(itemRenderer:IListItemRenderer) : int
      {
         var index:int = 0;
         if(itemRenderer.name in rowMap)
         {
            index = int(rowMap[itemRenderer.name].rowIndex);
            if(itemRenderer.parent is DataGridLockedRowContentHolder)
            {
               return index;
            }
            return index + this.lockedRowCount + verticalScrollPosition - offscreenExtraRowsTop;
         }
         return int.MIN_VALUE;
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function selectionTween_updateHandler(event:TweenEvent) : void
      {
         var s:Sprite = null;
         super.selectionTween_updateHandler(event);
         if(Boolean(this.lockedColumnCount))
         {
            s = Sprite(event.target.listener);
            s = this.indicatorDictionary[s] as Sprite;
            s.alpha = Number(event.value);
         }
      }
      
      override protected function destroyRow(i:int, numCols:int) : void
      {
         var listItems:Array = null;
         var rowInfo:Array = null;
         var visibleData:Object = null;
         var r:IListItemRenderer = null;
         var uid:String = null;
         var j:int = 0;
         super.destroyRow(i,numCols);
         if(Boolean(this.lockedColumnCount))
         {
            listItems = this.lockedColumnContent.listItems;
            numCols = int(listItems[i].length);
            rowInfo = this.lockedColumnContent.rowInfo;
            visibleData = this.lockedColumnContent.visibleData;
            uid = rowInfo[i].uid;
            removeIndicators(uid);
            for(j = 0; j < numCols; j++)
            {
               r = listItems[i][j];
               if(Boolean(r.data))
               {
                  delete visibleData[uid];
               }
               this.addToFreeItemRenderers(r);
            }
         }
      }
      
      override protected function moveRowVertically(i:int, numCols:int, moveBlockDistance:Number) : void
      {
         var listItems:Array = null;
         var rowInfo:Array = null;
         var r:IListItemRenderer = null;
         var j:int = 0;
         super.moveRowVertically(i,numCols,moveBlockDistance);
         if(Boolean(this.lockedColumnCount))
         {
            listItems = this.lockedColumnContent.listItems;
            numCols = int(listItems[i].length);
            rowInfo = this.lockedColumnContent.rowInfo;
            for(j = 0; j < numCols; j++)
            {
               r = listItems[i][j];
               r.move(r.x,r.y + moveBlockDistance);
            }
         }
      }
      
      override protected function shiftRow(oldIndex:int, newIndex:int, numCols:int, shiftItems:Boolean) : void
      {
         var listItems:Array = null;
         var r:IListItemRenderer = null;
         var j:int = 0;
         super.shiftRow(oldIndex,newIndex,numCols,shiftItems);
         if(Boolean(this.lockedColumnCount))
         {
            listItems = this.lockedColumnContent.listItems;
            numCols = int(listItems[oldIndex].length);
            for(j = 0; j < numCols; j++)
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
            if(shiftItems)
            {
               this.lockedColumnContent.rowInfo[newIndex] = this.lockedColumnContent.rowInfo[oldIndex];
            }
         }
      }
      
      override protected function moveIndicatorsVertically(uid:String, moveBlockDistance:Number) : void
      {
         super.moveIndicatorsVertically(uid,moveBlockDistance);
         if(Boolean(this.lockedColumnCount))
         {
            if(Boolean(uid))
            {
               if(Boolean(selectionIndicators[uid]))
               {
                  Sprite(this.indicatorDictionary[selectionIndicators[uid]]).y = Sprite(this.indicatorDictionary[selectionIndicators[uid]]).y + moveBlockDistance;
               }
               if(highlightUID == uid)
               {
                  this.columnHighlightIndicator.y += moveBlockDistance;
               }
               if(caretUID == uid)
               {
                  this.columnCaretIndicator.y += moveBlockDistance;
               }
            }
         }
      }
      
      override protected function truncateRowArrays(numRows:int) : void
      {
         super.truncateRowArrays(numRows);
         if(Boolean(this.lockedColumnCount))
         {
            this.lockedColumnContent.listItems.splice(numRows);
            this.lockedColumnContent.rowInfo.splice(numRows);
         }
      }
      
      override protected function addToRowArrays() : void
      {
         super.addToRowArrays();
         if(Boolean(this.lockedColumnCount))
         {
            this.lockedColumnContent.listItems.splice(0,0,null);
            this.lockedColumnContent.rowInfo.splice(0,0,null);
         }
      }
      
      override protected function restoreRowArrays(modDeltaPos:int) : void
      {
         super.restoreRowArrays(modDeltaPos);
         if(Boolean(this.lockedColumnCount))
         {
            this.lockedColumnContent.listItems.splice(0,modDeltaPos);
            this.lockedColumnContent.rowInfo.splice(0,modDeltaPos);
         }
      }
      
      override protected function removeFromRowArrays(i:int) : void
      {
         super.removeFromRowArrays(i);
         if(Boolean(this.lockedColumnCount))
         {
            this.lockedColumnContent.listItems.splice(i,1);
            this.lockedColumnContent.rowInfo.splice(i,1);
         }
      }
      
      override protected function clearVisibleData() : void
      {
         if(Boolean(this.lockedColumnContent))
         {
            this.lockedColumnContent.visibleData = {};
         }
         if(Boolean(this.lockedRowContent))
         {
            this.lockedRowContent.visibleData = {};
         }
         if(Boolean(this.lockedColumnAndRowContent))
         {
            this.lockedColumnAndRowContent.visibleData = {};
         }
         super.clearVisibleData();
      }
      
      override protected function set allowItemSizeChangeNotification(value:Boolean) : void
      {
         if(Boolean(this.lockedColumnContent))
         {
            this.lockedColumnContent.allowItemSizeChangeNotification = value;
         }
         if(Boolean(this.lockedRowContent))
         {
            this.lockedRowContent.allowItemSizeChangeNotification = value;
         }
         if(Boolean(this.lockedColumnAndRowContent))
         {
            this.lockedColumnAndRowContent.allowItemSizeChangeNotification = value;
         }
         super.allowItemSizeChangeNotification = value;
      }
      
      override protected function indexToRow(index:int) : int
      {
         if(index < this.lockedRowCount)
         {
            return -1;
         }
         return index - this.lockedRowCount;
      }
      
      override protected function moveSelectionVertically(code:uint, shiftKey:Boolean, ctrlKey:Boolean) : void
      {
         var newVerticalScrollPosition:Number = NaN;
         var listItem:IListItemRenderer = null;
         var uid:String = null;
         var len:int = 0;
         var se:ScrollEvent = null;
         var bSelChanged:Boolean = false;
         showCaret = true;
         var rowCount:int = int(listItems.length);
         var onscreenRowCount:int = listItems.length - offscreenExtraRowsTop - offscreenExtraRowsBottom;
         var partialRow:int = rowInfo[rowCount - offscreenExtraRowsBottom - 1].y + rowInfo[rowCount - offscreenExtraRowsBottom - 1].height > listContent.heightExcludingOffsets - listContent.topOffset ? 1 : 0;
         var bUpdateVerticalScrollPosition:Boolean = false;
         this.bSelectItem = false;
         switch(code)
         {
            case Keyboard.UP:
               if(caretIndex > 0)
               {
                  --caretIndex;
                  this.bSelectItem = true;
                  if(caretIndex >= this.lockedRowCount)
                  {
                     bUpdateVerticalScrollPosition = true;
                  }
               }
               break;
            case Keyboard.DOWN:
               if(caretIndex >= this.lockedRowCount - 1)
               {
                  if(caretIndex < collection.length - 1)
                  {
                     ++caretIndex;
                     bUpdateVerticalScrollPosition = true;
                     this.bSelectItem = true;
                  }
                  else if(caretIndex == collection.length - 1 && Boolean(partialRow))
                  {
                     if(verticalScrollPosition < maxVerticalScrollPosition)
                     {
                        newVerticalScrollPosition = verticalScrollPosition + 1;
                     }
                  }
               }
               else if(caretIndex < collection.length - 1)
               {
                  ++caretIndex;
                  this.bSelectItem = true;
               }
               break;
            case Keyboard.PAGE_UP:
               if(caretIndex > this.lockedRowCount)
               {
                  if(caretIndex > verticalScrollPosition + this.lockedRowCount && caretIndex < verticalScrollPosition + this.lockedRowCount + onscreenRowCount)
                  {
                     caretIndex = verticalScrollPosition + this.lockedRowCount;
                  }
                  else
                  {
                     caretIndex = Math.max(caretIndex - Math.max(onscreenRowCount - partialRow,1),this.lockedRowCount);
                     newVerticalScrollPosition = Math.max(caretIndex,this.lockedRowCount) - this.lockedRowCount;
                  }
                  this.bSelectItem = true;
               }
               else
               {
                  caretIndex = 0;
                  this.bSelectItem = true;
               }
               break;
            case Keyboard.PAGE_DOWN:
               if(!(caretIndex >= verticalScrollPosition + this.lockedRowCount && caretIndex < verticalScrollPosition + this.lockedRowCount + onscreenRowCount - partialRow - 1))
               {
                  if(caretIndex - this.lockedRowCount == verticalScrollPosition && onscreenRowCount - partialRow <= 1)
                  {
                     ++caretIndex;
                  }
                  newVerticalScrollPosition = Math.min(Math.max(caretIndex - this.lockedRowCount,0),maxVerticalScrollPosition);
               }
               this.bSelectItem = true;
               break;
            case Keyboard.HOME:
               if(caretIndex > 0)
               {
                  caretIndex = 0;
                  this.bSelectItem = true;
                  newVerticalScrollPosition = 0;
               }
               break;
            case Keyboard.END:
               if(this.lockedRowCount >= collection.length)
               {
                  caretIndex = collection.length - 1;
                  this.bSelectItem = true;
               }
               else if(caretIndex < collection.length - 1)
               {
                  caretIndex = collection.length - 1;
                  this.bSelectItem = true;
                  newVerticalScrollPosition = maxVerticalScrollPosition;
               }
               break;
            case Keyboard.SPACE:
               bUpdateVerticalScrollPosition = true;
               this.bSelectItem = true;
         }
         if(bUpdateVerticalScrollPosition)
         {
            if(caretIndex >= verticalScrollPosition + this.lockedRowCount + onscreenRowCount - partialRow)
            {
               if(onscreenRowCount - partialRow == 0)
               {
                  newVerticalScrollPosition = Math.min(maxVerticalScrollPosition,Math.max(caretIndex - this.lockedRowCount,0));
               }
               else
               {
                  newVerticalScrollPosition = Math.min(maxVerticalScrollPosition,caretIndex - this.lockedRowCount - onscreenRowCount + partialRow + 1);
               }
            }
            else if(caretIndex < verticalScrollPosition + this.lockedRowCount)
            {
               newVerticalScrollPosition = Math.max(caretIndex - this.lockedRowCount,0);
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
         this.bShiftKey = shiftKey;
         this.bCtrlKey = ctrlKey;
         this.lastKey = code;
         this.finishKeySelection();
      }
      
      override protected function finishKeySelection() : void
      {
         var uid:String = null;
         var listItem:IListItemRenderer = null;
         var pt:Point = null;
         var evt:ListEvent = null;
         var rowCount:int = int(listItems.length);
         var onscreenRowCount:int = listItems.length - offscreenExtraRowsTop - offscreenExtraRowsBottom;
         var partialRow:int = rowInfo[rowCount - offscreenExtraRowsBottom - 1].y + rowInfo[rowCount - offscreenExtraRowsBottom - 1].height > listContent.heightExcludingOffsets - listContent.topOffset ? 1 : 0;
         if(this.lastKey == Keyboard.PAGE_DOWN)
         {
            if(onscreenRowCount - partialRow == 0)
            {
               caretIndex = Math.min(verticalScrollPosition + this.lockedRowCount + onscreenRowCount - partialRow,collection.length - 1);
            }
            else
            {
               caretIndex = Math.min(verticalScrollPosition + this.lockedRowCount + onscreenRowCount - partialRow - 1,collection.length - 1);
            }
         }
         var bSelChanged:Boolean = false;
         if(this.bSelectItem && (caretIndex - verticalScrollPosition >= 0 || caretIndex < this.lockedRowCount))
         {
            if(caretIndex - this.lockedRowCount - verticalScrollPosition > Math.max(onscreenRowCount - partialRow - 1,0))
            {
               if(this.lastKey == Keyboard.END && maxVerticalScrollPosition > verticalScrollPosition)
               {
                  caretIndex -= 1;
                  this.moveSelectionVertically(this.lastKey,this.bShiftKey,this.bCtrlKey);
                  return;
               }
               caretIndex = this.lockedRowCount + onscreenRowCount - partialRow - 1 + verticalScrollPosition;
            }
            if(caretIndex < this.lockedRowCount)
            {
               listItem = this.lockedRowContent.listItems[caretIndex][0];
            }
            else
            {
               listItem = listItems[caretIndex - this.lockedRowCount - verticalScrollPosition + offscreenExtraRowsTop][0];
            }
            if(Boolean(listItem))
            {
               uid = itemToUID(listItem.data);
               listItem = this.UIDToItemRenderer(uid);
               if(!this.bCtrlKey || this.lastKey == Keyboard.SPACE)
               {
                  this.selectItem(listItem,this.bShiftKey,this.bCtrlKey);
                  bSelChanged = true;
               }
               if(this.bCtrlKey)
               {
                  this.drawItem(listItem,selectedData[uid] != null,uid == highlightUID,true);
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
      
      override protected function itemRendererToIndices(item:IListItemRenderer) : Point
      {
         if(!item || !(item.name in rowMap))
         {
            return null;
         }
         var content:ListBaseContentHolder = item.parent as ListBaseContentHolder;
         var found:Boolean = false;
         var index:int = int(rowMap[item.name].rowIndex);
         var len:int = int(content.listItems[index].length);
         for(var i:int = 0; i < len; i++)
         {
            if(content.listItems[index][i] == item)
            {
               found = true;
               break;
            }
         }
         if(!found)
         {
            return null;
         }
         if(this.lockedRowContent == content)
         {
            return new Point(i + horizontalScrollPosition + this.lockedColumnCount,index + offscreenExtraRowsTop);
         }
         if(this.lockedColumnAndRowContent == content)
         {
            return new Point(i,index + offscreenExtraRowsTop);
         }
         if(this.lockedColumnContent == content)
         {
            return new Point(i,index + verticalScrollPosition + this.lockedRowCount + offscreenExtraRowsTop);
         }
         return new Point(i + horizontalScrollPosition + this.lockedColumnCount,index + verticalScrollPosition + this.lockedRowCount + offscreenExtraRowsTop);
      }
      
      override protected function selectItem(item:IListItemRenderer, shiftKey:Boolean, ctrlKey:Boolean, transition:Boolean = true) : Boolean
      {
         var bookmark:CursorBookmark = iterator.bookmark;
         if(Boolean(this.lockedRowCount))
         {
            this.inSelectItem = true;
            iterator.seek(CursorBookmark.FIRST,0);
         }
         var retval:Boolean = super.selectItem(item,shiftKey,ctrlKey,transition);
         if(Boolean(this.lockedRowCount))
         {
            iterator.seek(bookmark,0);
            this.inSelectItem = false;
         }
         return retval;
      }
      
      override public function showDropFeedback(event:DragEvent) : void
      {
         var dropIndicatorClass:Class = null;
         var vm:EdgeMetrics = null;
         var rowCount:int = 0;
         var partialRow:int = 0;
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
               dragScrollingInterval = setInterval(dragScroll,15);
            }
         }
         var rowNum:Number = calculateDropIndex(event);
         if(Boolean(this.lockedRowCount) && rowNum < this.lockedRowCount)
         {
            if(dropIndicator.parent != this.lockedRowContent)
            {
               this.lockedRowContent.addChild(DisplayObject(dropIndicator));
            }
            dropIndicator.y = this.lockedRowContent.listItems[rowNum][0].y - 1;
         }
         else
         {
            rowCount = int(listItems.length);
            partialRow = rowCount > 0 && rowInfo[rowCount - offscreenExtraRowsBottom - 1].y + rowInfo[rowCount - offscreenExtraRowsBottom - 1].height > listContent.heightExcludingOffsets - listContent.topOffset ? 1 : 0;
            rowNum -= verticalScrollPosition + this.lockedRowCount;
            if(rowNum >= rowCount)
            {
               if(Boolean(partialRow))
               {
                  rowNum = rowCount - 1;
               }
               else
               {
                  rowNum = rowCount;
               }
            }
            if(rowNum < 0)
            {
               rowNum = 0;
            }
            if(dropIndicator.parent != listContent)
            {
               listContent.addChild(DisplayObject(dropIndicator));
            }
            dropIndicator.y = calculateDropIndicatorY(rowCount,rowNum + offscreenExtraRowsTop);
         }
      }
      
      override protected function adjustAfterAdd(items:Array, location:int) : Boolean
      {
         var retval:Boolean = super.adjustAfterAdd(items,location);
         if(Boolean(this.lockedRowCount))
         {
            if(verticalScrollPosition > 0 && verticalScrollPosition >= location && location <= this.lockedRowCount)
            {
               if(verticalScrollPosition + this.lockedRowCount >= collection.length)
               {
                  super.verticalScrollPosition = verticalScrollPosition - items.length;
               }
            }
            if(collection.length - items.length <= this.lockedRowCount && collection.length >= this.lockedRowCount || location <= this.lockedRowCount || location == this.lockedRowCount + verticalScrollPosition)
            {
               try
               {
                  iterator.seek(CursorBookmark.FIRST,this.lockedRowCount + verticalScrollPosition);
                  if(!iteratorValid)
                  {
                     iteratorValid = true;
                     lastSeekPending = null;
                  }
               }
               catch(e:ItemPendingError)
               {
                  lastSeekPending = new ListBaseSeekPending(CursorBookmark.FIRST,lockedRowCount + verticalScrollPosition);
                  e.addResponder(new ItemResponder(seekPendingResultHandler,seekPendingFailureHandler,lastSeekPending));
                  iteratorValid = false;
               }
            }
         }
         return retval;
      }
      
      override protected function adjustAfterRemove(items:Array, location:int, requiresValueCommit:Boolean) : Boolean
      {
         var retval:Boolean;
         var firstUID:String = null;
         var i:int = 0;
         var uid:String = null;
         var adjustIterator:Boolean = false;
         if(Boolean(this.lockedRowCount) && Boolean(listItems.length) && Boolean(listItems[0].length))
         {
            if(location <= this.lockedRowCount + verticalScrollPosition)
            {
               adjustIterator = true;
            }
            else
            {
               firstUID = rowMap[listItems[0][0].name].uid;
               for(i = 0; i < items.length; i++)
               {
                  uid = itemToUID(items[i]);
                  if(uid == firstUID && verticalScrollPosition == 0)
                  {
                     adjustIterator = true;
                     break;
                  }
               }
            }
         }
         retval = super.adjustAfterRemove(items,location,requiresValueCommit);
         if(Boolean(this.lockedRowCount))
         {
            if(verticalScrollPosition > 0 && location > this.lockedRowCount && verticalScrollPosition <= this.lockedRowCount && verticalScrollPosition == maxVerticalScrollPosition)
            {
               super.verticalScrollPosition = verticalScrollPosition - items.length;
               adjustIterator = true;
            }
            if(adjustIterator)
            {
               try
               {
                  iterator.seek(CursorBookmark.FIRST,this.lockedRowCount + verticalScrollPosition);
                  if(!iteratorValid)
                  {
                     iteratorValid = true;
                     lastSeekPending = null;
                  }
               }
               catch(e:ItemPendingError)
               {
                  lastSeekPending = new ListBaseSeekPending(CursorBookmark.FIRST,lockedRowCount + verticalScrollPosition);
                  e.addResponder(new ItemResponder(seekPendingResultHandler,seekPendingFailureHandler,lastSeekPending));
                  iteratorValid = false;
               }
            }
         }
         return retval;
      }
   }
}

