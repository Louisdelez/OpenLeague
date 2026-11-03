package mx.controls.dataGridClasses
{
   import flash.display.DisplayObject;
   import flash.display.GradientType;
   import flash.display.Graphics;
   import flash.display.Shape;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.controls.DataGrid;
   import mx.controls.listClasses.IDropInListItemRenderer;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.core.EdgeMetrics;
   import mx.core.FlexSprite;
   import mx.core.FlexVersion;
   import mx.core.IFlexDisplayObject;
   import mx.core.UIComponent;
   import mx.core.UIComponentGlobals;
   import mx.core.mx_internal;
   import mx.events.DataGridEvent;
   import mx.events.SandboxMouseEvent;
   import mx.managers.CursorManagerPriority;
   import mx.skins.halo.DataGridColumnDropIndicator;
   import mx.styles.ISimpleStyleClient;
   import mx.styles.StyleManager;
   
   use namespace mx_internal;
   
   public class DataGridHeader extends DataGridHeaderBase
   {
      
      private var headerBGSkinChanged:Boolean = false;
      
      private var lastItemDown:IListItemRenderer;
      
      protected var dataGrid:DataGrid;
      
      private var resizeGraphic:IFlexDisplayObject;
      
      protected var cachedPaddingBottom:Number = 0;
      
      private var headerSepSkinChanged:Boolean = false;
      
      mx_internal var columnDropIndicator:IFlexDisplayObject;
      
      private var separators:Array;
      
      protected var headerItems:Array = [];
      
      private var startX:Number;
      
      mx_internal var sortArrow:IFlexDisplayObject;
      
      private var dropColumnIndex:int = -1;
      
      private var allowItemSizeChangeNotification:Boolean = true;
      
      public var bottomOffset:Number = 0;
      
      private var lastPt:Point;
      
      private var resizeCursorID:int = 0;
      
      protected var cachedPaddingTop:Number = 0;
      
      public var topOffset:Number = 0;
      
      private var minX:Number;
      
      public var rightOffset:Number = 0;
      
      protected var cachedHeaderHeight:Number = 0;
      
      public var needRightSeparatorEvents:Boolean = false;
      
      public var needRightSeparator:Boolean = false;
      
      private var separatorAffordance:Number = 3;
      
      public var leftOffset:Number = 0;
      
      public function DataGridHeader()
      {
         super();
         addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
         addEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
         addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
         addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
      }
      
      override public function set enabled(value:Boolean) : void
      {
         super.enabled = value;
         if(Boolean(sortArrow))
         {
            removeChild(DisplayObject(sortArrow));
            sortArrow = null;
            placeSortArrow();
         }
      }
      
      protected function mouseUpHandler(event:MouseEvent) : void
      {
         var dataGridEvent:DataGridEvent = null;
         var r:IListItemRenderer = null;
         var s:Sprite = null;
         var n:int = 0;
         var i:int = 0;
         var pt:Point = null;
         s = Sprite(getChildByName("sortArrowHitArea"));
         if(event.target == s)
         {
            n = int(visibleColumns.length);
            for(i = 0; i < n; i++)
            {
               if(visibleColumns[i].colNum == dataGrid.sortIndex)
               {
                  r = headerItems[i];
                  break;
               }
            }
         }
         else
         {
            for(i = 0; i < separators.length; i++)
            {
               if(event.target == separators[i] && Boolean(visibleColumns[i].resizable))
               {
                  return;
               }
            }
            pt = new Point(event.stageX,event.stageY);
            pt = globalToLocal(pt);
            for(i = 0; i < headerItems.length; i++)
            {
               if(headerItems[i].x + headerItems[i].width >= pt.x)
               {
                  r = headerItems[i];
                  break;
               }
            }
            if(i >= headerItems.length)
            {
               return;
            }
         }
         if(Boolean(dataGrid.enabled && (dataGrid.sortableColumns || dataGrid.draggableColumns)) && Boolean(dataGrid.dataProvider) && dataGrid.headerVisible)
         {
            if(r == lastItemDown)
            {
               if(dataGrid.sortableColumns && Boolean(visibleColumns[i].sortable))
               {
                  lastItemDown = null;
                  dataGridEvent = new DataGridEvent(DataGridEvent.HEADER_RELEASE,false,true);
                  dataGridEvent.columnIndex = visibleColumns[i].colNum;
                  dataGridEvent.dataField = visibleColumns[i].dataField;
                  dataGridEvent.itemRenderer = r;
                  dataGrid.dispatchEvent(dataGridEvent);
               }
            }
         }
      }
      
      protected function drawSeparators() : void
      {
         var sep:UIComponent = null;
         var sepSkin:IFlexDisplayObject = null;
         var cols:Array = null;
         var headerSeparatorClass:Class = null;
         if(!separators)
         {
            separators = [];
         }
         var lines:UIComponent = UIComponent(getChildByName("lines"));
         if(!lines)
         {
            lines = new UIComponent();
            lines.name = "lines";
            addChild(lines);
         }
         else
         {
            setChildIndex(lines,numChildren - 1);
         }
         lines.scrollRect = new Rectangle(0,0,unscaledWidth,unscaledHeight + 1);
         if(headerSepSkinChanged)
         {
            headerSepSkinChanged = false;
            clearSeparators();
         }
         var n:int = Boolean(visibleColumns) ? int(visibleColumns.length) : 0;
         if(!needRightSeparator && n > 0)
         {
            n--;
         }
         for(var i:int = 0; i < n; i++)
         {
            if(i < lines.numChildren)
            {
               sep = UIComponent(lines.getChildAt(i));
               sepSkin = IFlexDisplayObject(sep.getChildAt(0));
            }
            else
            {
               headerSeparatorClass = getStyle("headerSeparatorSkin");
               sepSkin = new headerSeparatorClass();
               if(sepSkin is ISimpleStyleClient)
               {
                  ISimpleStyleClient(sepSkin).styleName = this;
               }
               sep = new UIComponent();
               sep.addChild(DisplayObject(sepSkin));
               lines.addChild(sep);
               UIComponentGlobals.layoutManager.validateClient(sep,true);
               separators.push(sep);
            }
            if(!(i == visibleColumns.length - 1 && !needRightSeparatorEvents))
            {
               DisplayObject(sep).addEventListener(MouseEvent.MOUSE_OVER,columnResizeMouseOverHandler);
               DisplayObject(sep).addEventListener(MouseEvent.MOUSE_OUT,columnResizeMouseOutHandler);
               DisplayObject(sep).addEventListener(MouseEvent.MOUSE_DOWN,columnResizeMouseDownHandler);
            }
            else if(i == visibleColumns.length - 1 && !needRightSeparatorEvents)
            {
               DisplayObject(sep).removeEventListener(MouseEvent.MOUSE_OVER,columnResizeMouseOverHandler);
               DisplayObject(sep).removeEventListener(MouseEvent.MOUSE_OUT,columnResizeMouseOutHandler);
               DisplayObject(sep).removeEventListener(MouseEvent.MOUSE_DOWN,columnResizeMouseDownHandler);
            }
            cols = visibleColumns;
            if(!(Boolean(cols) && cols.length > 0 || dataGrid.headerVisible))
            {
               sep.visible = false;
            }
            else
            {
               sep.visible = true;
               sep.x = headerItems[i].x + visibleColumns[i].width - Math.round(sepSkin.measuredWidth / 2);
               if(i > 0)
               {
                  sep.x = Math.max(sep.x,separators[i - 1].x + Math.round(sepSkin.measuredWidth / 2));
               }
               sep.y = 0;
               sepSkin.setActualSize(sepSkin.measuredWidth,Math.ceil(cachedHeaderHeight));
               sep.graphics.clear();
               sep.graphics.beginFill(16777215,0);
               sep.graphics.drawRect(-separatorAffordance,0,sepSkin.measuredWidth + separatorAffordance,cachedHeaderHeight);
               sep.graphics.endFill();
               sep.mouseEnabled = true;
            }
         }
         while(lines.numChildren > n)
         {
            lines.removeChildAt(lines.numChildren - 1);
            separators.pop();
         }
         UIComponentGlobals.layoutManager.validateClient(lines,true);
      }
      
      private function columnResizeMouseOutHandler(event:MouseEvent) : void
      {
         if(!enabled || !dataGrid.resizableColumns)
         {
            return;
         }
         var target:DisplayObject = DisplayObject(event.target);
         var index:int = target.parent.getChildIndex(target);
         if(!visibleColumns[index].resizable)
         {
            return;
         }
         cursorManager.removeCursor(resizeCursorID);
      }
      
      override protected function createChildren() : void
      {
         dataGrid = parent as DataGrid;
         selectionLayer = new UIComponent();
         addChild(selectionLayer);
      }
      
      mx_internal function _clearSeparators() : void
      {
         clearSeparators();
      }
      
      protected function drawHeaderIndicator(indicator:Sprite, x:Number, y:Number, width:Number, height:Number, color:uint, itemRenderer:IListItemRenderer) : void
      {
         var g:Graphics = indicator.graphics;
         g.clear();
         g.beginFill(color);
         g.drawRect(0,0,width,height);
         g.endFill();
         indicator.x = x;
         indicator.y = y;
      }
      
      protected function mouseOutHandler(event:MouseEvent) : void
      {
         var r:IListItemRenderer = null;
         var i:int = 0;
         var n:int = 0;
         var pt:Point = null;
         var s:Sprite = null;
         if(Boolean(resizeGraphic) || Boolean(dataGrid.movingColumn))
         {
            return;
         }
         if(dataGrid.enabled && dataGrid.sortableColumns && dataGrid.headerVisible)
         {
            s = Sprite(getChildByName("sortArrowHitArea"));
            if(event.target == s)
            {
               n = int(visibleColumns.length);
               for(i = 0; i < n; i++)
               {
                  if(visibleColumns[i].colNum == dataGrid.sortIndex)
                  {
                     r = headerItems[i];
                     break;
                  }
               }
               if(i >= visibleColumns.length)
               {
                  return;
               }
            }
            else
            {
               for(i = 0; i < separators.length; i++)
               {
                  if(event.target == separators[i] && Boolean(visibleColumns[i].resizable))
                  {
                     return;
                  }
               }
               pt = new Point(event.stageX,event.stageY);
               pt = globalToLocal(pt);
               for(i = 0; i < headerItems.length; i++)
               {
                  if(headerItems[i].x + headerItems[i].width >= pt.x)
                  {
                     r = headerItems[i];
                     break;
                  }
               }
               if(i >= headerItems.length)
               {
                  i = headerItems.length - 1;
               }
            }
            if(visibleColumns.length > 0 && Boolean(visibleColumns[i].sortable))
            {
               s = Sprite(selectionLayer.getChildByName("headerSelection"));
               if(Boolean(s))
               {
                  selectionLayer.removeChild(s);
               }
            }
         }
         if(event.buttonDown)
         {
            lastItemDown = r;
         }
         else
         {
            lastItemDown = null;
         }
      }
      
      private function drawHeaderBackgroundSkin(headerBGSkin:IFlexDisplayObject) : void
      {
         headerBGSkin.setActualSize(unscaledWidth,Math.ceil(cachedHeaderHeight));
      }
      
      mx_internal function getSeparators() : Array
      {
         return separators;
      }
      
      private function get resizingColumn() : DataGridColumn
      {
         return dataGrid.resizingColumn;
      }
      
      private function columnResizeMouseDownHandler(event:MouseEvent) : void
      {
         if(!enabled || !dataGrid.resizableColumns)
         {
            return;
         }
         var target:DisplayObject = DisplayObject(event.target);
         var index:int = target.parent.getChildIndex(target);
         if(!visibleColumns[index].resizable)
         {
            return;
         }
         startX = DisplayObject(event.target).x + x;
         lastPt = new Point(event.stageX,event.stageY);
         lastPt = dataGrid.globalToLocal(lastPt);
         var n:int = int(separators.length);
         var colIndex:int = 0;
         for(var i:int = 0; i < n; i++)
         {
            if(separators[i] == event.target)
            {
               resizingColumn = visibleColumns[i];
               colIndex = i;
            }
            else
            {
               separators[i].mouseEnabled = false;
            }
         }
         if(!resizingColumn)
         {
            return;
         }
         minX = headerItems[colIndex].x + x + resizingColumn.minWidth;
         var sbRoot:DisplayObject = systemManager.getSandboxRoot();
         sbRoot.addEventListener(MouseEvent.MOUSE_MOVE,columnResizingHandler,true);
         sbRoot.addEventListener(MouseEvent.MOUSE_UP,columnResizeMouseUpHandler,true);
         sbRoot.addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,columnResizeMouseUpHandler);
         systemManager.deployMouseShields(true);
         var resizeSkinClass:Class = getStyle("columnResizeSkin");
         resizeGraphic = new resizeSkinClass();
         if(resizeGraphic is Sprite)
         {
            Sprite(resizeGraphic).mouseEnabled = false;
         }
         dataGrid.addChild(DisplayObject(resizeGraphic));
         resizeGraphic.move(DisplayObject(event.target).x + x,0);
         resizeGraphic.setActualSize(resizeGraphic.measuredWidth,dataGrid.height / dataGrid.scaleY);
      }
      
      private function columnDraggingMouseUpHandler(event:Event) : void
      {
         if(!dataGrid.movingColumn)
         {
            return;
         }
         var origIndex:int = dataGrid.movingColumn.colNum;
         var allVisibleColumns:Array = dataGrid.getAllVisibleColumns();
         if(dropColumnIndex >= 0)
         {
            if(dropColumnIndex >= allVisibleColumns.length)
            {
               dropColumnIndex = allVisibleColumns.length - 1;
            }
            else if(origIndex < allVisibleColumns[dropColumnIndex].colNum)
            {
               --dropColumnIndex;
            }
            dropColumnIndex = allVisibleColumns[dropColumnIndex].colNum;
         }
         dataGrid.shiftColumns(origIndex,dropColumnIndex,event as MouseEvent);
         var sbRoot:DisplayObject = systemManager.getSandboxRoot();
         sbRoot.removeEventListener(MouseEvent.MOUSE_MOVE,columnDraggingMouseMoveHandler,true);
         sbRoot.removeEventListener(MouseEvent.MOUSE_UP,columnDraggingMouseUpHandler,true);
         sbRoot.removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,columnDraggingMouseUpHandler);
         systemManager.deployMouseShields(false);
         var dgSelectionLayer:Sprite = Sprite(dataGrid.getChildByName("columnDragSelectionLayer"));
         if(!dgSelectionLayer)
         {
            startX = NaN;
            dataGrid.movingColumn = null;
            dropColumnIndex = -1;
            return;
         }
         var proxy:IListItemRenderer = IListItemRenderer(getChildByName("headerDragProxy"));
         if(Boolean(proxy))
         {
            dgSelectionLayer.removeChild(DisplayObject(proxy));
         }
         var s:Sprite = Sprite(dgSelectionLayer.getChildByName("headerSelection"));
         if(Boolean(s))
         {
            dgSelectionLayer.removeChild(s);
         }
         if(Boolean(columnDropIndicator))
         {
            columnDropIndicator.visible = false;
         }
         s = Sprite(dataGrid.getChildByName("columnDragOverlay"));
         if(Boolean(s))
         {
            dataGrid.removeChild(s);
         }
         dataGrid.removeChild(dgSelectionLayer);
         startX = NaN;
         dataGrid.movingColumn = null;
         dropColumnIndex = -1;
         invalidateDisplayList();
      }
      
      mx_internal function _drawSeparators() : void
      {
         drawSeparators();
      }
      
      private function columnDraggingMouseMoveHandler(event:MouseEvent) : void
      {
         var item:IListItemRenderer = null;
         var s:Sprite = null;
         var dgSelectionLayer:Sprite = null;
         var ww:Number = NaN;
         var vm:EdgeMetrics = null;
         var proxy:IListItemRenderer = null;
         var rowData:DataGridListData = null;
         var dropIndicatorClass:Class = null;
         var m:Shape = null;
         if(!event.buttonDown)
         {
            columnDraggingMouseUpHandler(event);
            return;
         }
         var c:DataGridColumn = dataGrid.movingColumn;
         var i:int = 0;
         var n:int = int(headerItems.length);
         if(isNaN(startX))
         {
            startX = event.stageX;
            lastItemDown = null;
            vm = dataGrid.viewMetrics;
            dgSelectionLayer = new UIComponent();
            dgSelectionLayer.name = "columnDragSelectionLayer";
            dgSelectionLayer.alpha = 0.6;
            dataGrid.addChild(dgSelectionLayer);
            dgSelectionLayer.x = vm.left;
            dgSelectionLayer.y = vm.top;
            proxy = dataGrid.createColumnItemRenderer(c,true,c);
            proxy.name = "headerDragProxy";
            rowData = new DataGridListData(c.headerText != null ? c.headerText : c.dataField,c.dataField,c.colNum,uid,dataGrid,0);
            if(proxy is IDropInListItemRenderer)
            {
               IDropInListItemRenderer(proxy).listData = rowData;
            }
            dgSelectionLayer.addChild(DisplayObject(proxy));
            proxy.data = c;
            proxy.styleName = getStyle("headerDragProxyStyleName");
            UIComponentGlobals.layoutManager.validateClient(proxy,true);
            proxy.setActualSize(c.width,dataGrid._explicitHeaderHeight ? dataGrid.headerHeight : Number(proxy.getExplicitOrMeasuredHeight()));
            for(i = 0; i < n; i++)
            {
               item = headerItems[i];
               if(item.data == dataGrid.movingColumn)
               {
                  break;
               }
            }
            proxy.move(item.x + x,item.y);
            s = new FlexSprite();
            s.name = "columnDragOverlay";
            s.alpha = 0.6;
            dataGrid.addChild(s);
            if(c.width > 0)
            {
               drawColumnDragOverlay(s,item.x + x,0,c.width,dataGrid.height / dataGrid.scaleY - vm.bottom - s.y,getStyle("disabledColor"),item);
            }
            s = Sprite(selectionLayer.getChildByName("headerSelection"));
            if(Boolean(s))
            {
               s.width = dataGrid.movingColumn.width;
               dgSelectionLayer.addChild(s);
               s.x += x;
            }
            dgSelectionLayer.scrollRect = new Rectangle(0,0,dataGrid.width / dataGrid.scaleX,unscaledHeight);
            return;
         }
         var deltaX:Number = event.stageX - startX;
         dgSelectionLayer = Sprite(dataGrid.getChildByName("columnDragSelectionLayer"));
         s = Sprite(dgSelectionLayer.getChildByName("headerSelection"));
         if(Boolean(s))
         {
            s.x += deltaX;
         }
         item = IListItemRenderer(dgSelectionLayer.getChildByName("headerDragProxy"));
         if(Boolean(item))
         {
            item.move(item.x + deltaX,item.y);
         }
         startX += deltaX;
         var allVisibleColumns:Array = dataGrid.getAllVisibleColumns();
         var pt:Point = new Point(event.stageX,event.stageY);
         pt = dataGrid.globalToLocal(pt);
         lastPt = pt;
         n = int(allVisibleColumns.length);
         var xx:Number = dataGrid.viewMetrics.left;
         for(i = 0; i < n; i++)
         {
            ww = Number(allVisibleColumns[i].width);
            if(pt.x < xx + ww)
            {
               if(pt.x > xx + ww / 2)
               {
                  i++;
                  xx += ww;
               }
               if(dropColumnIndex != i)
               {
                  dropColumnIndex = i;
                  if(!columnDropIndicator)
                  {
                     dropIndicatorClass = getStyle("columnDropIndicatorSkin");
                     if(!dropIndicatorClass)
                     {
                        dropIndicatorClass = DataGridColumnDropIndicator;
                     }
                     columnDropIndicator = IFlexDisplayObject(new dropIndicatorClass());
                     if(columnDropIndicator is ISimpleStyleClient)
                     {
                        ISimpleStyleClient(columnDropIndicator).styleName = this;
                     }
                     dataGrid.addChild(DisplayObject(columnDropIndicator));
                     m = new Shape();
                     m.graphics.beginFill(16777215);
                     m.graphics.drawRect(0,0,10,10);
                     m.graphics.endFill();
                     dataGrid.addChild(m);
                     columnDropIndicator.mask = m;
                  }
                  dataGrid.setChildIndex(DisplayObject(columnDropIndicator),dataGrid.numChildren - 1);
                  columnDropIndicator.visible = true;
                  m = columnDropIndicator.mask as Shape;
                  m.x = dataGrid.viewMetrics.left;
                  m.y = dataGrid.viewMetrics.top;
                  m.width = dataGrid.width / dataGrid.scaleX - m.x - dataGrid.viewMetrics.right;
                  m.height = dataGrid.height / dataGrid.scaleY - m.x - dataGrid.viewMetrics.bottom;
                  columnDropIndicator.x = xx - columnDropIndicator.width;
                  columnDropIndicator.y = 0;
                  columnDropIndicator.setActualSize(3,dataGrid.height / dataGrid.scaleY);
               }
               break;
            }
            xx += ww;
         }
      }
      
      private function columnResizeMouseOverHandler(event:MouseEvent) : void
      {
         if(!enabled || !dataGrid.resizableColumns)
         {
            return;
         }
         var target:DisplayObject = DisplayObject(event.target);
         var index:int = target.parent.getChildIndex(target);
         if(!visibleColumns[index].resizable)
         {
            return;
         }
         var stretchCursorClass:Class = getStyle("stretchCursor");
         resizeCursorID = cursorManager.setCursor(stretchCursorClass,CursorManagerPriority.HIGH,0,0);
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         super.styleChanged(styleProp);
         if(styleProp == "headerBackgroundSkin")
         {
            headerBGSkinChanged = true;
         }
         else if(styleProp == "headerSeparatorSkin")
         {
            headerSepSkinChanged = true;
         }
      }
      
      protected function placeSortArrow() : void
      {
         var xx:Number = NaN;
         var n:int = 0;
         var i:int = 0;
         var sortArrowClass:Class = null;
         var g:Graphics = null;
         var j:int = 0;
         var sortArrowHitArea:Sprite = Sprite(getChildByName("sortArrowHitArea"));
         if(dataGrid.sortIndex == -1 && dataGrid.lastSortIndex == -1)
         {
            if(Boolean(sortArrow))
            {
               sortArrow.visible = false;
            }
            if(Boolean(sortArrowHitArea))
            {
               sortArrowHitArea.visible = false;
            }
            return;
         }
         if(!dataGrid.headerVisible)
         {
            if(Boolean(sortArrow))
            {
               sortArrow.visible = false;
            }
            if(Boolean(sortArrowHitArea))
            {
               sortArrowHitArea.visible = false;
            }
            return;
         }
         if(!sortArrow)
         {
            sortArrowClass = getStyle("sortArrowSkin");
            sortArrow = new sortArrowClass();
            DisplayObject(sortArrow).name = enabled ? "sortArrow" : "sortArrowDisabled";
            if(sortArrow is ISimpleStyleClient)
            {
               ISimpleStyleClient(sortArrow).styleName = this;
            }
            addChild(DisplayObject(sortArrow));
         }
         var found:Boolean = false;
         if(Boolean(headerItems) && Boolean(headerItems.length))
         {
            n = int(headerItems.length);
            for(i = 0; i < n; i++)
            {
               if(visibleColumns[i].colNum == dataGrid.sortIndex)
               {
                  xx = headerItems[i].x + visibleColumns[i].width;
                  headerItems[i].setActualSize(visibleColumns[i].width - sortArrow.measuredWidth - 8,headerItems[i].height);
                  if(!isNaN(headerItems[i].explicitWidth))
                  {
                     headerItems[i].explicitWidth = headerItems[i].width;
                  }
                  UIComponentGlobals.layoutManager.validateClient(headerItems[i],true);
                  if(!sortArrowHitArea)
                  {
                     sortArrowHitArea = new FlexSprite();
                     sortArrowHitArea.name = "sortArrowHitArea";
                     addChild(sortArrowHitArea);
                  }
                  else
                  {
                     sortArrowHitArea.visible = true;
                  }
                  sortArrowHitArea.x = headerItems[i].x + headerItems[i].width;
                  sortArrowHitArea.y = headerItems[i].y;
                  g = sortArrowHitArea.graphics;
                  g.clear();
                  g.beginFill(0,0);
                  g.drawRect(0,0,sortArrow.measuredWidth + 8,headerItems[i].height);
                  g.endFill();
                  found = true;
                  break;
               }
            }
         }
         if(isNaN(xx))
         {
            sortArrow.visible = false;
         }
         else
         {
            sortArrow.visible = true;
         }
         if(Boolean(visibleColumns.length) && Boolean(dataGrid.lastSortIndex >= 0) && dataGrid.lastSortIndex != dataGrid.sortIndex)
         {
            if(visibleColumns[0].colNum <= dataGrid.lastSortIndex && dataGrid.lastSortIndex <= visibleColumns[visibleColumns.length - 1].colNum)
            {
               n = int(headerItems.length);
               for(j = 0; j < n; j++)
               {
                  if(visibleColumns[j].colNum == dataGrid.lastSortIndex)
                  {
                     headerItems[j].setActualSize(visibleColumns[j].width,headerItems[j].height);
                     UIComponentGlobals.layoutManager.validateClient(headerItems[j],true);
                     break;
                  }
               }
            }
         }
         var d:Boolean = dataGrid.sortDirection == "ASC";
         sortArrow.width = sortArrow.measuredWidth;
         sortArrow.height = sortArrow.measuredHeight;
         DisplayObject(sortArrow).scaleY = d ? -1 : 1;
         sortArrow.x = xx - sortArrow.measuredWidth - 8;
         var hh:Number = cachedHeaderHeight;
         sortArrow.y = (hh - sortArrow.measuredHeight) / 2 + (d ? sortArrow.measuredHeight : 0);
         if(found && sortArrow.x < headerItems[i].x)
         {
            sortArrow.visible = false;
         }
         if(!sortArrow.visible && Boolean(sortArrowHitArea))
         {
            sortArrowHitArea.visible = false;
         }
      }
      
      protected function drawSelectionIndicator(indicator:Sprite, x:Number, y:Number, width:Number, height:Number, color:uint, itemRenderer:IListItemRenderer) : void
      {
         var g:Graphics = indicator.graphics;
         g.clear();
         g.beginFill(color);
         g.drawRect(0,0,width,height);
         g.endFill();
         indicator.x = x;
         indicator.y = y;
      }
      
      private function set resizingColumn(value:DataGridColumn) : void
      {
         dataGrid.resizingColumn = value;
      }
      
      override mx_internal function clearSelectionLayer() : void
      {
         while(selectionLayer.numChildren > 0)
         {
            selectionLayer.removeChildAt(0);
         }
      }
      
      private function columnResizeMouseUpHandler(event:Event) : void
      {
         var pt:Point = null;
         if(!enabled || !dataGrid.resizableColumns)
         {
            return;
         }
         lastItemDown = null;
         var sbRoot:DisplayObject = systemManager.getSandboxRoot();
         sbRoot.removeEventListener(MouseEvent.MOUSE_MOVE,columnResizingHandler,true);
         sbRoot.removeEventListener(MouseEvent.MOUSE_UP,columnResizeMouseUpHandler,true);
         sbRoot.removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,columnResizeMouseUpHandler);
         systemManager.deployMouseShields(false);
         dataGrid.removeChild(DisplayObject(resizeGraphic));
         resizeGraphic = null;
         cursorManager.removeCursor(resizeCursorID);
         var c:DataGridColumn = resizingColumn;
         resizingColumn = null;
         var vsw:int = Boolean(dataGrid.vScrollBar) ? int(dataGrid.vScrollBar.width) : 0;
         var mouseEvent:MouseEvent = event as MouseEvent;
         if(Boolean(mouseEvent))
         {
            pt = new Point(mouseEvent.stageX,mouseEvent.stageY);
            pt = dataGrid.globalToLocal(pt);
         }
         else
         {
            pt = lastPt;
         }
         var widthChange:Number = Math.min(Math.max(minX,pt.x),dataGrid.width / dataGrid.scaleX - separators[0].width - vsw) - startX;
         dataGrid.resizeColumn(c.colNum,Math.floor(c.width + widthChange));
         invalidateDisplayList();
         var dataGridEvent:DataGridEvent = new DataGridEvent(DataGridEvent.COLUMN_STRETCH);
         dataGridEvent.columnIndex = c.colNum;
         dataGridEvent.dataField = c.dataField;
         dataGridEvent.localX = pt.x;
         dataGrid.dispatchEvent(dataGridEvent);
      }
      
      protected function clearSeparators() : void
      {
         if(!separators)
         {
            return;
         }
         var lines:Sprite = Sprite(getChildByName("lines"));
         while(Boolean(lines.numChildren))
         {
            lines.removeChildAt(lines.numChildren - 1);
            separators.pop();
         }
      }
      
      mx_internal function get rendererArray() : Array
      {
         return headerItems;
      }
      
      override protected function measure() : void
      {
         super.measure();
         var calculatedHeight:Number = dataGrid.calculateHeaderHeight();
         cachedHeaderHeight = dataGrid._explicitHeaderHeight ? dataGrid.headerHeight : calculatedHeight;
         cachedPaddingBottom = getStyle("paddingBottom");
         cachedPaddingTop = getStyle("paddingTop");
         measuredHeight = cachedHeaderHeight;
      }
      
      protected function drawColumnDragOverlay(indicator:Sprite, x:Number, y:Number, width:Number, height:Number, color:uint, itemRenderer:IListItemRenderer) : void
      {
         var g:Graphics = indicator.graphics;
         g.clear();
         g.beginFill(color);
         g.drawRect(0,0,width,height);
         g.endFill();
         indicator.x = x;
         indicator.y = y;
      }
      
      mx_internal function _placeSortArrow() : void
      {
         placeSortArrow();
      }
      
      mx_internal function _drawHeaderBackground(headerBG:UIComponent) : void
      {
         drawHeaderBackground(headerBG);
      }
      
      private function columnResizingHandler(event:MouseEvent) : void
      {
         if(!MouseEvent(event).buttonDown)
         {
            columnResizeMouseUpHandler(event);
            return;
         }
         var vsw:int = Boolean(dataGrid.vScrollBar) ? int(dataGrid.vScrollBar.width) : 0;
         var pt:Point = new Point(event.stageX,event.stageY);
         pt = dataGrid.globalToLocal(pt);
         lastPt = pt;
         resizeGraphic.move(Math.min(Math.max(minX,pt.x),dataGrid.width / dataGrid.scaleX - separators[0].width - vsw),0);
      }
      
      override public function invalidateSize() : void
      {
         if(allowItemSizeChangeNotification)
         {
            super.invalidateSize();
         }
      }
      
      protected function mouseOverHandler(event:MouseEvent) : void
      {
         var r:IListItemRenderer = null;
         var i:int = 0;
         var n:int = 0;
         var pt:Point = null;
         var s:Sprite = null;
         if(Boolean(resizingColumn) || Boolean(dataGrid.movingColumn))
         {
            return;
         }
         if(dataGrid.enabled && dataGrid.sortableColumns && dataGrid.headerVisible)
         {
            s = Sprite(getChildByName("sortArrowHitArea"));
            if(event.target == s)
            {
               n = int(visibleColumns.length);
               for(i = 0; i < n; i++)
               {
                  if(visibleColumns[i].colNum == dataGrid.sortIndex)
                  {
                     r = headerItems[i];
                     break;
                  }
               }
            }
            else
            {
               for(i = 0; i < separators.length; i++)
               {
                  if(event.target == separators[i] && Boolean(visibleColumns[i].resizable))
                  {
                     return;
                  }
               }
               pt = new Point(event.stageX,event.stageY);
               pt = globalToLocal(pt);
               for(i = 0; i < headerItems.length; i++)
               {
                  if(headerItems[i].x + headerItems[i].width >= pt.x)
                  {
                     r = headerItems[i];
                     break;
                  }
               }
               if(i >= headerItems.length)
               {
                  return;
               }
            }
            s = Sprite(getChildByName("sortArrowHitArea"));
            if(Boolean(visibleColumns[i].sortable))
            {
               s = Sprite(selectionLayer.getChildByName("headerSelection"));
               if(!s)
               {
                  s = new FlexSprite();
                  s.name = "headerSelection";
                  s.mouseEnabled = false;
                  selectionLayer.addChild(s);
               }
               drawHeaderIndicator(s,r.x,0,visibleColumns[i].width,cachedHeaderHeight - 0.5,getStyle("rollOverColor"),r);
            }
         }
         if(event.buttonDown)
         {
            lastItemDown = r;
         }
         else
         {
            lastItemDown = null;
         }
      }
      
      protected function mouseDownHandler(event:MouseEvent) : void
      {
         var r:IListItemRenderer = null;
         var s:Sprite = null;
         var i:int = 0;
         var n:int = 0;
         var pt:Point = null;
         var sbRoot:DisplayObject = null;
         s = Sprite(getChildByName("sortArrowHitArea"));
         if(event.target == s)
         {
            n = int(visibleColumns.length);
            for(i = 0; i < n; i++)
            {
               if(visibleColumns[i].colNum == dataGrid.sortIndex)
               {
                  r = headerItems[i];
                  break;
               }
            }
         }
         else
         {
            for(i = 0; i < separators.length; i++)
            {
               if(event.target == separators[i] && Boolean(visibleColumns[i].resizable))
               {
                  return;
               }
            }
            pt = new Point(event.stageX,event.stageY);
            pt = globalToLocal(pt);
            for(i = 0; i < headerItems.length; i++)
            {
               if(headerItems[i].x + headerItems[i].width >= pt.x)
               {
                  r = headerItems[i];
                  break;
               }
            }
            if(i >= headerItems.length)
            {
               return;
            }
         }
         if(dataGrid.enabled && (dataGrid.sortableColumns || dataGrid.draggableColumns) && dataGrid.headerVisible)
         {
            if(dataGrid.sortableColumns && Boolean(visibleColumns[i].sortable))
            {
               lastItemDown = r;
               s = Sprite(selectionLayer.getChildByName("headerSelection"));
               if(!s)
               {
                  s = new FlexSprite();
                  s.name = "headerSelection";
                  selectionLayer.addChild(s);
               }
               drawSelectionIndicator(s,r.x,0,visibleColumns[i].width,cachedHeaderHeight - 0.5,getStyle("selectionColor"),r);
            }
            if(dataGrid.draggableColumns && Boolean(visibleColumns[i].draggable))
            {
               startX = NaN;
               sbRoot = systemManager.getSandboxRoot();
               sbRoot.addEventListener(MouseEvent.MOUSE_MOVE,columnDraggingMouseMoveHandler,true);
               sbRoot.addEventListener(MouseEvent.MOUSE_UP,columnDraggingMouseUpHandler,true);
               sbRoot.addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,columnDraggingMouseUpHandler);
               systemManager.deployMouseShields(true);
               dataGrid.movingColumn = visibleColumns[i];
            }
         }
      }
      
      override protected function updateDisplayList(w:Number, h:Number) : void
      {
         var xx:Number = NaN;
         var yy:Number = NaN;
         var hh:Number = NaN;
         var ww:Number = NaN;
         var rh:Number = NaN;
         var colNum:int = 0;
         var rowData:DataGridListData = null;
         var item:IListItemRenderer = null;
         var extraItem:IListItemRenderer = null;
         var data:Object = null;
         var uid:String = null;
         var c:DataGridColumn = null;
         var maxHeaderHeight:Number = NaN;
         var oldHeaderItems:Array = null;
         var i:int = 0;
         var headerBGSkinClass:Class = null;
         var headerBGSkin:IFlexDisplayObject = null;
         allowItemSizeChangeNotification = false;
         var cols:Array = visibleColumns;
         if(headerItemsChanged && (Boolean(cols && cols.length > 0) || Boolean(dataGrid.headerVisible)))
         {
            headerItemsChanged = false;
            xx = 0;
            yy = 0;
            hh = 0;
            ww = 0;
            colNum = 0;
            maxHeaderHeight = 0;
            oldHeaderItems = headerItems.slice();
            while(Boolean(cols) && colNum < cols.length)
            {
               c = cols[colNum];
               item = c.cachedHeaderRenderer;
               if(!item)
               {
                  item = dataGrid.createColumnItemRenderer(c,true,c);
                  item.styleName = c;
                  c.cachedHeaderRenderer = item;
               }
               rowData = new DataGridListData(c.headerText != null ? c.headerText : c.dataField,c.dataField,colNum,uid,dataGrid,0);
               if(item is IDropInListItemRenderer)
               {
                  IDropInListItemRenderer(item).listData = rowData;
               }
               item.data = c;
               item.visible = true;
               if(item.parent != this)
               {
                  addChild(DisplayObject(item));
               }
               headerItems[colNum] = item;
               item.explicitWidth = ww = c.width;
               UIComponentGlobals.layoutManager.validateClient(item,true);
               rh = Number(item.getExplicitOrMeasuredHeight());
               item.setActualSize(ww,dataGrid._explicitHeaderHeight ? cachedHeaderHeight - cachedPaddingTop - cachedPaddingBottom : rh);
               item.move(xx,yy + cachedPaddingTop);
               xx += ww;
               colNum++;
               hh = Math.ceil(Math.max(hh,dataGrid._explicitHeaderHeight ? cachedHeaderHeight : rh + cachedPaddingBottom + cachedPaddingTop));
               maxHeaderHeight = Math.max(maxHeaderHeight,dataGrid._explicitHeaderHeight ? cachedHeaderHeight - cachedPaddingTop - cachedPaddingBottom : rh);
            }
            for(i = 0; i < headerItems.length; i++)
            {
               headerItems[i].setActualSize(headerItems[i].width,maxHeaderHeight);
            }
            for(i = 0; i < oldHeaderItems.length; i++)
            {
               item = oldHeaderItems[i];
               if(Boolean(item) && headerItems.indexOf(item) == -1)
               {
                  if(item.parent == this)
                  {
                     removeChild(DisplayObject(item));
                  }
               }
            }
            while(headerItems.length > colNum)
            {
               extraItem = headerItems.pop();
               if(extraItem.parent == this)
               {
                  if(headerItems.indexOf(extraItem) == -1)
                  {
                     removeChild(DisplayObject(extraItem));
                  }
               }
            }
         }
         var headerBG:UIComponent = UIComponent(getChildByName("headerBG"));
         if(headerBGSkinChanged)
         {
            headerBGSkinChanged = false;
            if(Boolean(headerBG))
            {
               removeChild(headerBG);
            }
            headerBG = null;
         }
         if(!headerBG)
         {
            headerBG = new UIComponent();
            headerBG.name = "headerBG";
            addChildAt(DisplayObject(headerBG),0);
            if(FlexVersion.compatibilityVersion >= FlexVersion.VERSION_3_0)
            {
               headerBGSkinClass = getStyle("headerBackgroundSkin");
               headerBGSkin = new headerBGSkinClass();
               if(headerBGSkin is ISimpleStyleClient)
               {
                  ISimpleStyleClient(headerBGSkin).styleName = this;
               }
               headerBG.addChild(DisplayObject(headerBGSkin));
            }
         }
         if(dataGrid.headerVisible)
         {
            headerBG.visible = true;
            if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)
            {
               dataGrid._drawHeaderBackground(headerBG);
            }
            else
            {
               drawHeaderBackgroundSkin(IFlexDisplayObject(headerBG.getChildAt(0)));
            }
            dataGrid._drawSeparators();
         }
         else
         {
            headerBG.visible = false;
            dataGrid._clearSeparators();
         }
         dataGrid._placeSortArrow();
         allowItemSizeChangeNotification = true;
      }
      
      protected function drawHeaderBackground(headerBG:UIComponent) : void
      {
         var tot:Number = width;
         var hh:Number = cachedHeaderHeight;
         var g:Graphics = headerBG.graphics;
         g.clear();
         var colors:Array = getStyle("headerColors");
         StyleManager.getColorNames(colors);
         var matrix:Matrix = new Matrix();
         matrix.createGradientBox(tot,hh + 1,Math.PI / 2,0,0);
         colors = [colors[0],colors[0],colors[1]];
         var ratios:Array = [0,60,255];
         var alphas:Array = [1,1,1];
         g.beginGradientFill(GradientType.LINEAR,colors,alphas,ratios,matrix);
         g.lineStyle(0,0,0);
         g.moveTo(0,0);
         g.lineTo(tot,0);
         g.lineTo(tot,hh - 0.5);
         g.lineStyle(0,getStyle("borderColor"),100);
         g.lineTo(0,hh - 0.5);
         g.lineStyle(0,0,0);
         g.endFill();
      }
   }
}

