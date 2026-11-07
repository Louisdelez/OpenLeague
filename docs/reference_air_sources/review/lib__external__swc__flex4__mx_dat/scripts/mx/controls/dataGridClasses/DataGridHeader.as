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
   import mx.core.IFlexDisplayObject;
   import mx.core.IUIComponent;
   import mx.core.LayoutDirection;
   import mx.core.UIComponent;
   import mx.core.UIComponentGlobals;
   import mx.events.DataGridEvent;
   import mx.events.SandboxMouseEvent;
   import mx.managers.CursorManagerPriority;
   import mx.skins.halo.DataGridColumnDropIndicator;
   import mx.styles.ISimpleStyleClient;
   
   public class DataGridHeader extends DataGridHeaderBase
   {
      
      private var separatorAffordance:Number = 3;
      
      protected var dataGrid:DataGrid;
      
      protected var headerItems:Array = [];
      
      protected var cachedHeaderHeight:Number = 0;
      
      protected var cachedPaddingBottom:Number = 0;
      
      protected var cachedPaddingTop:Number = 0;
      
      public var needRightSeparator:Boolean = false;
      
      public var needRightSeparatorEvents:Boolean = false;
      
      private var resizeCursorID:int = 0;
      
      private var startX:Number;
      
      private var minX:Number;
      
      private var lastPt:Point;
      
      private var separators:Array;
      
      private var resizeGraphic:IFlexDisplayObject;
      
      private var lastItemDown:IListItemRenderer;
      
      private var dropColumnIndex:int = -1;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var columnDropIndicator:IFlexDisplayObject;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var sortArrow:IFlexDisplayObject;
      
      public var leftOffset:Number = 0;
      
      public var topOffset:Number = 0;
      
      public var rightOffset:Number = 0;
      
      public var bottomOffset:Number = 0;
      
      private var allowItemSizeChangeNotification:Boolean = true;
      
      private var headerBGSkinChanged:Boolean = false;
      
      private var headerSepSkinChanged:Boolean = false;
      
      public function DataGridHeader()
      {
         super();
         addEventListener(MouseEvent.MOUSE_OVER,this.mouseOverHandler);
         addEventListener(MouseEvent.MOUSE_OUT,this.mouseOutHandler);
         addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function clearSelectionLayer() : void
      {
         while(selectionLayer.numChildren > 0)
         {
            selectionLayer.removeChildAt(0);
         }
      }
      
      override protected function createChildren() : void
      {
         this.dataGrid = parent as DataGrid;
         selectionLayer = new UIComponent();
         addChild(selectionLayer);
      }
      
      override protected function measure() : void
      {
         super.measure();
         var calculatedHeight:Number = this.dataGrid.calculateHeaderHeight();
         this.cachedHeaderHeight = this.dataGrid._explicitHeaderHeight ? this.dataGrid.headerHeight : calculatedHeight;
         this.cachedPaddingBottom = getStyle("paddingBottom");
         this.cachedPaddingTop = getStyle("paddingTop");
         measuredHeight = this.cachedHeaderHeight;
         var ww:Number = 0;
         var n:int = Boolean(visibleColumns) ? int(visibleColumns.length) : 0;
         for(var i:int = 0; i < n; i++)
         {
            ww += visibleColumns[i].preferredWidth;
         }
         measuredWidth = ww;
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
         this.allowItemSizeChangeNotification = false;
         var cols:Array = visibleColumns;
         if(headerItemsChanged && (Boolean(cols && cols.length > 0) || Boolean(this.dataGrid.headerVisible)))
         {
            headerItemsChanged = false;
            xx = 0;
            yy = 0;
            hh = 0;
            ww = 0;
            colNum = 0;
            maxHeaderHeight = 0;
            oldHeaderItems = this.headerItems.slice();
            while(Boolean(cols) && colNum < cols.length)
            {
               c = cols[colNum];
               item = c.cachedHeaderRenderer;
               if(!item)
               {
                  item = this.dataGrid.createColumnItemRenderer(c,true,c);
                  item.styleName = c;
                  c.cachedHeaderRenderer = item;
               }
               rowData = new DataGridListData(c.headerText != null ? c.headerText : c.dataField,c.dataField,colNum,uid,this.dataGrid,0);
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
               this.headerItems[colNum] = item;
               item.explicitWidth = ww = c.width;
               UIComponentGlobals.layoutManager.validateClient(item,true);
               rh = Number(item.getExplicitOrMeasuredHeight());
               item.setActualSize(ww,this.dataGrid._explicitHeaderHeight ? this.cachedHeaderHeight - this.cachedPaddingTop - this.cachedPaddingBottom : rh);
               item.move(xx,yy + this.cachedPaddingTop);
               xx += ww;
               colNum++;
               hh = Math.ceil(Math.max(hh,this.dataGrid._explicitHeaderHeight ? this.cachedHeaderHeight : rh + this.cachedPaddingBottom + this.cachedPaddingTop));
               maxHeaderHeight = Math.max(maxHeaderHeight,this.dataGrid._explicitHeaderHeight ? this.cachedHeaderHeight - this.cachedPaddingTop - this.cachedPaddingBottom : rh);
            }
            for(i = 0; i < this.headerItems.length; i++)
            {
               this.headerItems[i].setActualSize(this.headerItems[i].width,maxHeaderHeight);
            }
            for(i = 0; i < oldHeaderItems.length; i++)
            {
               item = oldHeaderItems[i];
               if(Boolean(item) && this.headerItems.indexOf(item) == -1)
               {
                  if(item.parent == this)
                  {
                     removeChild(DisplayObject(item));
                  }
               }
            }
            while(this.headerItems.length > colNum)
            {
               extraItem = this.headerItems.pop();
               if(extraItem.parent == this)
               {
                  if(this.headerItems.indexOf(extraItem) == -1)
                  {
                     removeChild(DisplayObject(extraItem));
                  }
               }
            }
         }
         var headerBG:UIComponent = UIComponent(getChildByName("headerBG"));
         if(this.headerBGSkinChanged)
         {
            this.headerBGSkinChanged = false;
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
            headerBGSkinClass = getStyle("headerBackgroundSkin");
            headerBGSkin = new headerBGSkinClass();
            if(headerBGSkin is ISimpleStyleClient)
            {
               ISimpleStyleClient(headerBGSkin).styleName = this;
            }
            headerBG.addChild(DisplayObject(headerBGSkin));
         }
         if(this.dataGrid.headerVisible)
         {
            headerBG.visible = true;
            this.drawHeaderBackgroundSkin(IFlexDisplayObject(headerBG.getChildAt(0)));
            this.dataGrid._drawSeparators();
         }
         else
         {
            headerBG.visible = false;
            this.dataGrid._clearSeparators();
         }
         this.dataGrid._placeSortArrow();
         this.allowItemSizeChangeNotification = true;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function _drawHeaderBackground(headerBG:UIComponent) : void
      {
         this.drawHeaderBackground(headerBG);
      }
      
      protected function drawHeaderBackground(headerBG:UIComponent) : void
      {
         var tot:Number = Number(width);
         var hh:Number = this.cachedHeaderHeight;
         var g:Graphics = headerBG.graphics;
         g.clear();
         var colors:Array = getStyle("headerColors");
         styleManager.getColorNames(colors);
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
      
      private function drawHeaderBackgroundSkin(headerBGSkin:IFlexDisplayObject) : void
      {
         headerBGSkin.setActualSize(unscaledWidth,Math.ceil(this.cachedHeaderHeight));
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function _clearSeparators() : void
      {
         this.clearSeparators();
      }
      
      protected function clearSeparators() : void
      {
         if(!this.separators)
         {
            return;
         }
         var lines:Sprite = Sprite(getChildByName("lines"));
         while(Boolean(lines.numChildren))
         {
            lines.removeChildAt(lines.numChildren - 1);
            this.separators.pop();
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function _drawSeparators() : void
      {
         this.drawSeparators();
      }
      
      protected function drawSeparators() : void
      {
         var sep:UIComponent = null;
         var sepSkin:IFlexDisplayObject = null;
         var cols:Array = null;
         var skinWidth:Number = NaN;
         var headerSeparatorClass:Class = null;
         if(!this.separators)
         {
            this.separators = [];
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
         if(this.headerSepSkinChanged)
         {
            this.headerSepSkinChanged = false;
            this.clearSeparators();
         }
         var n:int = Boolean(visibleColumns) ? int(visibleColumns.length) : 0;
         if(!this.needRightSeparator && n > 0)
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
               this.separators.push(sep);
            }
            if(!(i == visibleColumns.length - 1 && !this.needRightSeparatorEvents))
            {
               DisplayObject(sep).addEventListener(MouseEvent.MOUSE_OVER,this.columnResizeMouseOverHandler);
               DisplayObject(sep).addEventListener(MouseEvent.MOUSE_OUT,this.columnResizeMouseOutHandler);
               DisplayObject(sep).addEventListener(MouseEvent.MOUSE_DOWN,this.columnResizeMouseDownHandler);
            }
            else if(i == visibleColumns.length - 1 && !this.needRightSeparatorEvents)
            {
               DisplayObject(sep).removeEventListener(MouseEvent.MOUSE_OVER,this.columnResizeMouseOverHandler);
               DisplayObject(sep).removeEventListener(MouseEvent.MOUSE_OUT,this.columnResizeMouseOutHandler);
               DisplayObject(sep).removeEventListener(MouseEvent.MOUSE_DOWN,this.columnResizeMouseDownHandler);
            }
            cols = visibleColumns;
            if(!(Boolean(cols) && cols.length > 0 || this.dataGrid.headerVisible))
            {
               sep.visible = false;
            }
            else
            {
               if(sepSkin is IUIComponent)
               {
                  skinWidth = Number(IUIComponent(sepSkin).getExplicitOrMeasuredWidth());
               }
               else
               {
                  skinWidth = Number(sepSkin.measuredWidth);
               }
               sep.visible = true;
               sep.x = this.headerItems[i].x + visibleColumns[i].width - Math.round(skinWidth / 2);
               if(i > 0)
               {
                  sep.x = Math.max(sep.x,this.separators[i - 1].x + Math.round(skinWidth / 2));
               }
               sep.y = 0;
               sepSkin.setActualSize(skinWidth,Math.ceil(this.cachedHeaderHeight));
               sep.graphics.clear();
               sep.graphics.beginFill(16777215,0);
               sep.graphics.drawRect(-this.separatorAffordance,0,sepSkin.measuredWidth + this.separatorAffordance,this.cachedHeaderHeight);
               sep.graphics.endFill();
               sep.mouseEnabled = true;
            }
         }
         while(lines.numChildren > n)
         {
            lines.removeChildAt(lines.numChildren - 1);
            this.separators.pop();
         }
         UIComponentGlobals.layoutManager.validateClient(lines,true);
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
      
      private function columnResizeMouseOverHandler(event:MouseEvent) : void
      {
         if(!enabled || !this.dataGrid.resizableColumns)
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
         this.resizeCursorID = cursorManager.setCursor(stretchCursorClass,CursorManagerPriority.HIGH,0,0);
      }
      
      private function columnResizeMouseOutHandler(event:MouseEvent) : void
      {
         if(!enabled || !this.dataGrid.resizableColumns)
         {
            return;
         }
         var target:DisplayObject = DisplayObject(event.target);
         var index:int = target.parent.getChildIndex(target);
         if(!visibleColumns[index].resizable)
         {
            return;
         }
         cursorManager.removeCursor(this.resizeCursorID);
      }
      
      private function columnResizeMouseDownHandler(event:MouseEvent) : void
      {
         if(!enabled || !this.dataGrid.resizableColumns)
         {
            return;
         }
         var target:DisplayObject = DisplayObject(event.target);
         var index:int = target.parent.getChildIndex(target);
         if(!visibleColumns[index].resizable)
         {
            return;
         }
         this.startX = DisplayObject(event.target).x + x;
         this.lastPt = new Point(event.stageX,event.stageY);
         this.lastPt = this.dataGrid.globalToLocal(this.lastPt);
         var n:int = int(this.separators.length);
         var colIndex:int = 0;
         for(var i:int = 0; i < n; i++)
         {
            if(this.separators[i] == event.target)
            {
               this.resizingColumn = visibleColumns[i];
               colIndex = i;
            }
            else
            {
               this.separators[i].mouseEnabled = false;
            }
         }
         if(!this.resizingColumn)
         {
            return;
         }
         this.minX = this.headerItems[colIndex].x + x + this.resizingColumn.minWidth;
         var sbRoot:DisplayObject = systemManager.getSandboxRoot();
         sbRoot.addEventListener(MouseEvent.MOUSE_MOVE,this.columnResizingHandler,true);
         sbRoot.addEventListener(MouseEvent.MOUSE_UP,this.columnResizeMouseUpHandler,true);
         sbRoot.addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.columnResizeMouseUpHandler);
         systemManager.deployMouseShields(true);
         var resizeSkinClass:Class = getStyle("columnResizeSkin");
         this.resizeGraphic = new resizeSkinClass();
         if(this.resizeGraphic is Sprite)
         {
            Sprite(this.resizeGraphic).mouseEnabled = false;
         }
         this.dataGrid.addChild(DisplayObject(this.resizeGraphic));
         this.resizeGraphic.move(DisplayObject(event.target).x + x,0);
         this.resizeGraphic.setActualSize(this.resizeGraphic.measuredWidth,this.dataGrid.height / this.dataGrid.scaleY);
      }
      
      private function columnResizingHandler(event:MouseEvent) : void
      {
         if(!MouseEvent(event).buttonDown)
         {
            this.columnResizeMouseUpHandler(event);
            return;
         }
         var vsw:int = Boolean(this.dataGrid.vScrollBar) ? int(this.dataGrid.vScrollBar.width) : 0;
         var pt:Point = new Point(event.stageX,event.stageY);
         pt = this.dataGrid.globalToLocal(pt);
         this.lastPt = pt;
         this.resizeGraphic.move(Math.min(Math.max(this.minX,pt.x),this.dataGrid.width / this.dataGrid.scaleX - this.separators[0].width - vsw),0);
      }
      
      private function columnResizeMouseUpHandler(event:Event) : void
      {
         var pt:Point = null;
         if(!enabled || !this.dataGrid.resizableColumns)
         {
            return;
         }
         this.lastItemDown = null;
         var sbRoot:DisplayObject = systemManager.getSandboxRoot();
         sbRoot.removeEventListener(MouseEvent.MOUSE_MOVE,this.columnResizingHandler,true);
         sbRoot.removeEventListener(MouseEvent.MOUSE_UP,this.columnResizeMouseUpHandler,true);
         sbRoot.removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.columnResizeMouseUpHandler);
         systemManager.deployMouseShields(false);
         this.dataGrid.removeChild(DisplayObject(this.resizeGraphic));
         this.resizeGraphic = null;
         cursorManager.removeCursor(this.resizeCursorID);
         var c:DataGridColumn = this.resizingColumn;
         this.resizingColumn = null;
         var vsw:int = Boolean(this.dataGrid.vScrollBar) ? int(this.dataGrid.vScrollBar.width) : 0;
         var mouseEvent:MouseEvent = event as MouseEvent;
         if(Boolean(mouseEvent))
         {
            pt = new Point(mouseEvent.stageX,mouseEvent.stageY);
            pt = this.dataGrid.globalToLocal(pt);
         }
         else
         {
            pt = this.lastPt;
         }
         var widthChange:Number = Math.min(Math.max(this.minX,pt.x),this.dataGrid.width / this.dataGrid.scaleX - this.separators[0].width - vsw) - this.startX;
         this.dataGrid.resizeColumn(c.colNum,Math.floor(c.width + widthChange));
         invalidateDisplayList();
         var dataGridEvent:DataGridEvent = new DataGridEvent(DataGridEvent.COLUMN_STRETCH);
         dataGridEvent.columnIndex = c.colNum;
         dataGridEvent.dataField = c.dataField;
         dataGridEvent.localX = pt.x;
         this.dataGrid.dispatchEvent(dataGridEvent);
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
            this.columnDraggingMouseUpHandler(event);
            return;
         }
         var c:DataGridColumn = this.dataGrid.movingColumn;
         var i:int = 0;
         var n:int = int(this.headerItems.length);
         if(isNaN(this.startX))
         {
            this.startX = event.stageX;
            this.lastItemDown = null;
            vm = this.dataGrid.viewMetrics;
            dgSelectionLayer = new UIComponent();
            dgSelectionLayer.name = "columnDragSelectionLayer";
            dgSelectionLayer.alpha = 0.6;
            this.dataGrid.addChild(dgSelectionLayer);
            dgSelectionLayer.x = vm.left;
            dgSelectionLayer.y = vm.top;
            proxy = this.dataGrid.createColumnItemRenderer(c,true,c);
            proxy.name = "headerDragProxy";
            rowData = new DataGridListData(c.headerText != null ? c.headerText : c.dataField,c.dataField,c.colNum,uid,this.dataGrid,0);
            if(proxy is IDropInListItemRenderer)
            {
               IDropInListItemRenderer(proxy).listData = rowData;
            }
            dgSelectionLayer.addChild(DisplayObject(proxy));
            proxy.data = c;
            proxy.styleName = getStyle("headerDragProxyStyleName");
            UIComponentGlobals.layoutManager.validateClient(proxy,true);
            proxy.setActualSize(c.width,this.dataGrid._explicitHeaderHeight ? this.dataGrid.headerHeight : Number(proxy.getExplicitOrMeasuredHeight()));
            for(i = 0; i < n; i++)
            {
               item = this.headerItems[i];
               if(item.data == this.dataGrid.movingColumn)
               {
                  break;
               }
            }
            proxy.move(item.x + x,item.y);
            s = new FlexSprite();
            s.name = "columnDragOverlay";
            s.alpha = 0.6;
            this.dataGrid.addChild(s);
            if(c.width > 0)
            {
               this.drawColumnDragOverlay(s,item.x + x,0,c.width,this.dataGrid.height / this.dataGrid.scaleY - vm.bottom - s.y,getStyle("disabledColor"),item);
            }
            s = Sprite(selectionLayer.getChildByName("headerSelection"));
            if(Boolean(s))
            {
               s.width = this.dataGrid.movingColumn.width;
               dgSelectionLayer.addChild(s);
               s.x += x;
            }
            dgSelectionLayer.scrollRect = new Rectangle(0,0,this.dataGrid.width / this.dataGrid.scaleX,unscaledHeight);
            return;
         }
         var deltaX:Number = event.stageX - this.startX;
         dgSelectionLayer = Sprite(this.dataGrid.getChildByName("columnDragSelectionLayer"));
         var deltaXInLocalCoordinates:Number = layoutDirection == LayoutDirection.LTR ? deltaX : -deltaX;
         s = Sprite(dgSelectionLayer.getChildByName("headerSelection"));
         if(Boolean(s))
         {
            s.x += deltaXInLocalCoordinates;
         }
         item = IListItemRenderer(dgSelectionLayer.getChildByName("headerDragProxy"));
         if(Boolean(item))
         {
            item.move(item.x + deltaXInLocalCoordinates,item.y);
         }
         this.startX += deltaX;
         var allVisibleColumns:Array = this.dataGrid.getAllVisibleColumns();
         var pt:Point = new Point(event.stageX,event.stageY);
         pt = this.dataGrid.globalToLocal(pt);
         this.lastPt = pt;
         n = int(allVisibleColumns.length);
         var xx:Number = Number(this.dataGrid.viewMetrics.left);
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
               if(this.dropColumnIndex != i)
               {
                  this.dropColumnIndex = i;
                  if(!this.columnDropIndicator)
                  {
                     dropIndicatorClass = getStyle("columnDropIndicatorSkin");
                     if(!dropIndicatorClass)
                     {
                        dropIndicatorClass = DataGridColumnDropIndicator;
                     }
                     this.columnDropIndicator = IFlexDisplayObject(new dropIndicatorClass());
                     if(this.columnDropIndicator is ISimpleStyleClient)
                     {
                        ISimpleStyleClient(this.columnDropIndicator).styleName = this;
                     }
                     this.dataGrid.addChild(DisplayObject(this.columnDropIndicator));
                     m = new Shape();
                     m.graphics.beginFill(16777215);
                     m.graphics.drawRect(0,0,10,10);
                     m.graphics.endFill();
                     this.dataGrid.addChild(m);
                     this.columnDropIndicator.mask = m;
                  }
                  this.dataGrid.setChildIndex(DisplayObject(this.columnDropIndicator),this.dataGrid.numChildren - 1);
                  this.columnDropIndicator.visible = true;
                  m = this.columnDropIndicator.mask as Shape;
                  m.x = this.dataGrid.viewMetrics.left;
                  m.y = this.dataGrid.viewMetrics.top;
                  m.width = this.dataGrid.width / this.dataGrid.scaleX - m.x - this.dataGrid.viewMetrics.right;
                  m.height = this.dataGrid.height / this.dataGrid.scaleY - m.x - this.dataGrid.viewMetrics.bottom;
                  this.columnDropIndicator.setActualSize(3,this.dataGrid.height / this.dataGrid.scaleY);
                  this.columnDropIndicator.x = xx - this.columnDropIndicator.width + (layoutDirection == LayoutDirection.LTR ? 0 : 1);
                  this.columnDropIndicator.y = 0;
               }
               break;
            }
            xx += ww;
         }
      }
      
      private function columnDraggingMouseUpHandler(event:Event) : void
      {
         if(!this.dataGrid.movingColumn)
         {
            return;
         }
         var origIndex:int = this.dataGrid.movingColumn.colNum;
         var allVisibleColumns:Array = this.dataGrid.getAllVisibleColumns();
         if(this.dropColumnIndex >= 0)
         {
            if(this.dropColumnIndex >= allVisibleColumns.length)
            {
               this.dropColumnIndex = allVisibleColumns.length - 1;
            }
            else if(origIndex < allVisibleColumns[this.dropColumnIndex].colNum)
            {
               --this.dropColumnIndex;
            }
            this.dropColumnIndex = allVisibleColumns[this.dropColumnIndex].colNum;
         }
         this.dataGrid.shiftColumns(origIndex,this.dropColumnIndex,event as MouseEvent);
         var sbRoot:DisplayObject = systemManager.getSandboxRoot();
         sbRoot.removeEventListener(MouseEvent.MOUSE_MOVE,this.columnDraggingMouseMoveHandler,true);
         sbRoot.removeEventListener(MouseEvent.MOUSE_UP,this.columnDraggingMouseUpHandler,true);
         sbRoot.removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.columnDraggingMouseUpHandler);
         systemManager.deployMouseShields(false);
         var dgSelectionLayer:Sprite = Sprite(this.dataGrid.getChildByName("columnDragSelectionLayer"));
         if(!dgSelectionLayer)
         {
            this.startX = NaN;
            this.dataGrid.movingColumn = null;
            this.dropColumnIndex = -1;
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
         if(Boolean(this.columnDropIndicator))
         {
            this.columnDropIndicator.visible = false;
         }
         s = Sprite(this.dataGrid.getChildByName("columnDragOverlay"));
         if(Boolean(s))
         {
            this.dataGrid.removeChild(s);
         }
         this.dataGrid.removeChild(dgSelectionLayer);
         this.startX = NaN;
         this.dataGrid.movingColumn = null;
         this.dropColumnIndex = -1;
         invalidateDisplayList();
      }
      
      protected function mouseOverHandler(event:MouseEvent) : void
      {
         var r:IListItemRenderer = null;
         var i:int = 0;
         var n:int = 0;
         var pt:Point = null;
         var s:Sprite = null;
         if(Boolean(this.resizingColumn) || Boolean(this.dataGrid.movingColumn))
         {
            return;
         }
         if(this.dataGrid.enabled && this.dataGrid.sortableColumns && this.dataGrid.headerVisible)
         {
            s = Sprite(getChildByName("sortArrowHitArea"));
            if(event.target == s)
            {
               n = int(visibleColumns.length);
               for(i = 0; i < n; i++)
               {
                  if(visibleColumns[i].colNum == this.dataGrid.sortIndex)
                  {
                     r = this.headerItems[i];
                     break;
                  }
               }
            }
            else
            {
               for(i = 0; i < this.separators.length; i++)
               {
                  if(event.target == this.separators[i] && Boolean(visibleColumns[i].resizable))
                  {
                     return;
                  }
               }
               pt = new Point(event.stageX,event.stageY);
               pt = globalToLocal(pt);
               for(i = 0; i < this.headerItems.length; i++)
               {
                  if(this.headerItems[i].x + this.headerItems[i].width >= pt.x)
                  {
                     r = this.headerItems[i];
                     break;
                  }
               }
               if(i >= this.headerItems.length)
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
               this.drawHeaderIndicator(s,r.x,0,visibleColumns[i].width,this.cachedHeaderHeight - 0.5,getStyle("rollOverColor"),r);
            }
         }
         if(event.buttonDown)
         {
            this.lastItemDown = r;
         }
         else
         {
            this.lastItemDown = null;
         }
      }
      
      protected function mouseOutHandler(event:MouseEvent) : void
      {
         var r:IListItemRenderer = null;
         var i:int = 0;
         var n:int = 0;
         var pt:Point = null;
         var s:Sprite = null;
         if(Boolean(this.resizeGraphic) || Boolean(this.dataGrid.movingColumn))
         {
            return;
         }
         if(this.dataGrid.enabled && this.dataGrid.sortableColumns && this.dataGrid.headerVisible)
         {
            s = Sprite(getChildByName("sortArrowHitArea"));
            if(event.target == s)
            {
               n = int(visibleColumns.length);
               for(i = 0; i < n; i++)
               {
                  if(visibleColumns[i].colNum == this.dataGrid.sortIndex)
                  {
                     r = this.headerItems[i];
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
               for(i = 0; i < this.separators.length; i++)
               {
                  if(event.target == this.separators[i] && Boolean(visibleColumns[i].resizable))
                  {
                     return;
                  }
               }
               pt = new Point(event.stageX,event.stageY);
               pt = globalToLocal(pt);
               for(i = 0; i < this.headerItems.length; i++)
               {
                  if(this.headerItems[i].x + this.headerItems[i].width >= pt.x)
                  {
                     r = this.headerItems[i];
                     break;
                  }
               }
               if(i >= this.headerItems.length)
               {
                  i = this.headerItems.length - 1;
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
            this.lastItemDown = r;
         }
         else
         {
            this.lastItemDown = null;
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
         systemManager.getSandboxRoot().addEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler,true,0,true);
         systemManager.getSandboxRoot().addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.mouseLeaveHandler,false,0,true);
         s = Sprite(getChildByName("sortArrowHitArea"));
         if(event.target == s)
         {
            n = int(visibleColumns.length);
            for(i = 0; i < n; i++)
            {
               if(visibleColumns[i].colNum == this.dataGrid.sortIndex)
               {
                  r = this.headerItems[i];
                  break;
               }
            }
         }
         else
         {
            for(i = 0; i < this.separators.length; i++)
            {
               if(event.target == this.separators[i] && Boolean(visibleColumns[i].resizable))
               {
                  return;
               }
            }
            pt = new Point(event.stageX,event.stageY);
            pt = globalToLocal(pt);
            for(i = 0; i < this.headerItems.length; i++)
            {
               if(this.headerItems[i].x + this.headerItems[i].width >= pt.x)
               {
                  r = this.headerItems[i];
                  break;
               }
            }
            if(i >= this.headerItems.length)
            {
               return;
            }
         }
         if(this.dataGrid.enabled && (this.dataGrid.sortableColumns || this.dataGrid.draggableColumns) && this.dataGrid.headerVisible)
         {
            if(this.dataGrid.sortableColumns && Boolean(visibleColumns[i].sortable))
            {
               this.lastItemDown = r;
               s = Sprite(selectionLayer.getChildByName("headerSelection"));
               if(!s)
               {
                  s = new FlexSprite();
                  s.name = "headerSelection";
                  selectionLayer.addChild(s);
               }
               this.drawSelectionIndicator(s,r.x,0,visibleColumns[i].width,this.cachedHeaderHeight - 0.5,getStyle("selectionColor"),r);
            }
            if(this.dataGrid.draggableColumns && Boolean(visibleColumns[i].draggable))
            {
               this.startX = NaN;
               sbRoot = systemManager.getSandboxRoot();
               sbRoot.addEventListener(MouseEvent.MOUSE_MOVE,this.columnDraggingMouseMoveHandler,true);
               sbRoot.addEventListener(MouseEvent.MOUSE_UP,this.columnDraggingMouseUpHandler,true);
               sbRoot.addEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.columnDraggingMouseUpHandler);
               systemManager.deployMouseShields(true);
               this.dataGrid.movingColumn = visibleColumns[i];
            }
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
         systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler,true);
         systemManager.getSandboxRoot().removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.mouseLeaveHandler);
         s = Sprite(getChildByName("sortArrowHitArea"));
         if(event.target == s)
         {
            n = int(visibleColumns.length);
            for(i = 0; i < n; i++)
            {
               if(visibleColumns[i].colNum == this.dataGrid.sortIndex)
               {
                  r = this.headerItems[i];
                  break;
               }
            }
         }
         else
         {
            for(i = 0; i < this.separators.length; i++)
            {
               if(event.target == this.separators[i] && Boolean(visibleColumns[i].resizable))
               {
                  return;
               }
            }
            pt = new Point(event.stageX,event.stageY);
            pt = globalToLocal(pt);
            for(i = 0; i < this.headerItems.length; i++)
            {
               if(this.headerItems[i].x + this.headerItems[i].width >= pt.x)
               {
                  r = this.headerItems[i];
                  break;
               }
            }
            if(i >= this.headerItems.length)
            {
               return;
            }
         }
         if(Boolean(this.dataGrid.enabled && (this.dataGrid.sortableColumns || this.dataGrid.draggableColumns)) && Boolean(this.dataGrid.dataProvider) && this.dataGrid.headerVisible)
         {
            if(r == this.lastItemDown)
            {
               if(this.dataGrid.sortableColumns && Boolean(visibleColumns[i].sortable))
               {
                  this.lastItemDown = null;
                  dataGridEvent = new DataGridEvent(DataGridEvent.HEADER_RELEASE,false,true);
                  dataGridEvent.columnIndex = visibleColumns[i].colNum;
                  dataGridEvent.dataField = visibleColumns[i].dataField;
                  dataGridEvent.itemRenderer = r;
                  this.dataGrid.dispatchEvent(dataGridEvent);
               }
            }
         }
      }
      
      private function mouseLeaveHandler(event:Event) : void
      {
         systemManager.getSandboxRoot().removeEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler,true);
         systemManager.getSandboxRoot().removeEventListener(SandboxMouseEvent.MOUSE_UP_SOMEWHERE,this.mouseLeaveHandler);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function _placeSortArrow() : void
      {
         this.placeSortArrow();
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
         if(this.dataGrid.sortIndex == -1 && this.dataGrid.lastSortIndex == -1)
         {
            if(Boolean(this.sortArrow))
            {
               this.sortArrow.visible = false;
            }
            if(Boolean(sortArrowHitArea))
            {
               sortArrowHitArea.visible = false;
            }
            return;
         }
         if(!this.dataGrid.headerVisible)
         {
            if(Boolean(this.sortArrow))
            {
               this.sortArrow.visible = false;
            }
            if(Boolean(sortArrowHitArea))
            {
               sortArrowHitArea.visible = false;
            }
            return;
         }
         if(!this.sortArrow)
         {
            sortArrowClass = getStyle("sortArrowSkin");
            this.sortArrow = new sortArrowClass();
            DisplayObject(this.sortArrow).name = enabled ? "sortArrow" : "sortArrowDisabled";
            if(this.sortArrow is ISimpleStyleClient)
            {
               ISimpleStyleClient(this.sortArrow).styleName = this;
            }
            addChild(DisplayObject(this.sortArrow));
         }
         var found:Boolean = false;
         if(Boolean(this.headerItems) && Boolean(this.headerItems.length))
         {
            n = int(this.headerItems.length);
            for(i = 0; i < n; i++)
            {
               if(visibleColumns[i].colNum == this.dataGrid.sortIndex)
               {
                  xx = this.headerItems[i].x + visibleColumns[i].width;
                  this.headerItems[i].setActualSize(visibleColumns[i].width - this.sortArrow.measuredWidth - 8,this.headerItems[i].height);
                  if(!isNaN(this.headerItems[i].explicitWidth))
                  {
                     this.headerItems[i].explicitWidth = this.headerItems[i].width;
                  }
                  UIComponentGlobals.layoutManager.validateClient(this.headerItems[i],true);
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
                  sortArrowHitArea.x = this.headerItems[i].x + this.headerItems[i].width;
                  sortArrowHitArea.y = this.headerItems[i].y;
                  g = sortArrowHitArea.graphics;
                  g.clear();
                  g.beginFill(0,0);
                  g.drawRect(0,0,this.sortArrow.measuredWidth + 8,this.headerItems[i].height);
                  g.endFill();
                  found = true;
                  break;
               }
            }
         }
         if(isNaN(xx))
         {
            this.sortArrow.visible = false;
         }
         else
         {
            this.sortArrow.visible = true;
         }
         if(Boolean(visibleColumns.length) && Boolean(this.dataGrid.lastSortIndex >= 0) && this.dataGrid.lastSortIndex != this.dataGrid.sortIndex)
         {
            if(visibleColumns[0].colNum <= this.dataGrid.lastSortIndex && this.dataGrid.lastSortIndex <= visibleColumns[visibleColumns.length - 1].colNum)
            {
               n = int(this.headerItems.length);
               for(j = 0; j < n; j++)
               {
                  if(visibleColumns[j].colNum == this.dataGrid.lastSortIndex)
                  {
                     this.headerItems[j].setActualSize(visibleColumns[j].width,this.headerItems[j].height);
                     UIComponentGlobals.layoutManager.validateClient(this.headerItems[j],true);
                     break;
                  }
               }
            }
         }
         var d:Boolean = this.dataGrid.sortDirection == "ASC";
         this.sortArrow.width = this.sortArrow.measuredWidth;
         this.sortArrow.height = this.sortArrow.measuredHeight;
         DisplayObject(this.sortArrow).scaleY = d ? -1 : 1;
         this.sortArrow.x = xx - this.sortArrow.measuredWidth - 8;
         var hh:Number = this.cachedHeaderHeight;
         this.sortArrow.y = (hh - this.sortArrow.measuredHeight) / 2 + (d ? this.sortArrow.measuredHeight : 0);
         if(found && this.sortArrow.x < this.headerItems[i].x)
         {
            this.sortArrow.visible = false;
         }
         if(!this.sortArrow.visible && Boolean(sortArrowHitArea))
         {
            sortArrowHitArea.visible = false;
         }
      }
      
      override public function invalidateSize() : void
      {
         if(this.allowItemSizeChangeNotification)
         {
            super.invalidateSize();
         }
      }
      
      override public function set enabled(value:Boolean) : void
      {
         super.enabled = value;
         if(Boolean(this.sortArrow))
         {
            removeChild(DisplayObject(this.sortArrow));
            this.sortArrow = null;
            this.placeSortArrow();
         }
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         super.styleChanged(styleProp);
         if(styleProp == "headerBackgroundSkin")
         {
            this.headerBGSkinChanged = true;
         }
         else if(styleProp == "headerSeparatorSkin")
         {
            this.headerSepSkinChanged = true;
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getSeparators() : Array
      {
         return this.separators;
      }
      
      private function get resizingColumn() : DataGridColumn
      {
         return this.dataGrid.resizingColumn;
      }
      
      private function set resizingColumn(value:DataGridColumn) : void
      {
         this.dataGrid.resizingColumn = value;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get rendererArray() : Array
      {
         return this.headerItems;
      }
   }
}

