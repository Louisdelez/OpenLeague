package flexlib.mdi.managers
{
   import flash.display.DisplayObject;
   import flash.events.ContextMenuEvent;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import flash.ui.ContextMenu;
   import flash.ui.ContextMenuItem;
   import flash.utils.Dictionary;
   import flexlib.mdi.containers.MDIWindow;
   import flexlib.mdi.effects.IMDIEffectsDescriptor;
   import flexlib.mdi.effects.MDIEffectsDescriptorBase;
   import flexlib.mdi.effects.effectClasses.MDIGroupEffectItem;
   import flexlib.mdi.events.MDIManagerEvent;
   import flexlib.mdi.events.MDIWindowEvent;
   import mx.collections.ArrayCollection;
   import mx.core.Application;
   import mx.core.EventPriority;
   import mx.core.IFlexDisplayObject;
   import mx.core.UIComponent;
   import mx.effects.CompositeEffect;
   import mx.effects.Effect;
   import mx.effects.effectClasses.CompositeEffectInstance;
   import mx.events.EffectEvent;
   import mx.events.PropertyChangeEvent;
   import mx.events.ResizeEvent;
   import mx.managers.PopUpManager;
   import mx.utils.ArrayUtil;
   
   [Event(name="tile",type="flexlib.mdi.events.MDIManagerEvent")]
   [Event(name="cascade",type="flexlib.mdi.events.MDIManagerEvent")]
   [Event(name="windowResizeEnd",type="flexlib.mdi.events.MDIManagerEvent")]
   [Event(name="windowResize",type="flexlib.mdi.events.MDIManagerEvent")]
   [Event(name="windowResizeStart",type="flexlib.mdi.events.MDIManagerEvent")]
   [Event(name="windowDragEnd",type="flexlib.mdi.events.MDIManagerEvent")]
   [Event(name="windowDrag",type="flexlib.mdi.events.MDIManagerEvent")]
   [Event(name="windowDragStart",type="flexlib.mdi.events.MDIManagerEvent")]
   [Event(name="windowFocusEnd",type="flexlib.mdi.events.MDIManagerEvent")]
   [Event(name="windowFocusStart",type="flexlib.mdi.events.MDIManagerEvent")]
   [Event(name="windowClose",type="flexlib.mdi.events.MDIManagerEvent")]
   [Event(name="windowMaximize",type="flexlib.mdi.events.MDIManagerEvent")]
   [Event(name="windowRestore",type="flexlib.mdi.events.MDIManagerEvent")]
   [Event(name="windowMinimize",type="flexlib.mdi.events.MDIManagerEvent")]
   [Event(name="windowAdd",type="flexlib.mdi.events.MDIManagerEvent")]
   public class MDIManager extends EventDispatcher
   {
      
      private static var globalMDIManager:MDIManager;
      
      public static const CONTEXT_MENU_LABEL_TILE:String = "Tile";
      
      public static const CONTEXT_MENU_LABEL_TILE_FILL:String = "Tile + Fill";
      
      public static const CONTEXT_MENU_LABEL_CASCADE:String = "Cascade";
      
      public static const CONTEXT_MENU_LABEL_SHOW_ALL:String = "Show All Windows";
      
      public var effects:IMDIEffectsDescriptor = new MDIEffectsDescriptorBase();
      
      public var tilePadding:Number = 8;
      
      private var _container:UIComponent;
      
      public var showMinimizedTiles:Boolean = false;
      
      private var windowToManagerEventMap:Dictionary;
      
      private var tiledWindows:ArrayCollection;
      
      [Bindable]
      private var _1862305966windowList:Array = new Array();
      
      public var tileMinimizeWidth:int = 200;
      
      public var enforceBoundaries:Boolean = true;
      
      public var minTilePadding:Number = 5;
      
      private var isGlobal:Boolean = false;
      
      public var tileMinimize:Boolean = true;
      
      public function MDIManager(container:UIComponent, effects:IMDIEffectsDescriptor = null)
      {
         super();
         this.container = container;
         if(effects != null)
         {
            this.effects = effects;
         }
         if(tileMinimize)
         {
            tiledWindows = new ArrayCollection();
         }
         this.container.addEventListener(ResizeEvent.RESIZE,containerResizeHandler);
         windowToManagerEventMap = new Dictionary();
         windowToManagerEventMap[MDIWindowEvent.MINIMIZE] = MDIManagerEvent.WINDOW_MINIMIZE;
         windowToManagerEventMap[MDIWindowEvent.RESTORE] = MDIManagerEvent.WINDOW_RESTORE;
         windowToManagerEventMap[MDIWindowEvent.MAXIMIZE] = MDIManagerEvent.WINDOW_MAXIMIZE;
         windowToManagerEventMap[MDIWindowEvent.CLOSE] = MDIManagerEvent.WINDOW_CLOSE;
         windowToManagerEventMap[MDIWindowEvent.FOCUS_START] = MDIManagerEvent.WINDOW_FOCUS_START;
         windowToManagerEventMap[MDIWindowEvent.FOCUS_END] = MDIManagerEvent.WINDOW_FOCUS_END;
         windowToManagerEventMap[MDIWindowEvent.DRAG_START] = MDIManagerEvent.WINDOW_DRAG_START;
         windowToManagerEventMap[MDIWindowEvent.DRAG] = MDIManagerEvent.WINDOW_DRAG;
         windowToManagerEventMap[MDIWindowEvent.DRAG_END] = MDIManagerEvent.WINDOW_DRAG_END;
         windowToManagerEventMap[MDIWindowEvent.RESIZE_START] = MDIManagerEvent.WINDOW_RESIZE_START;
         windowToManagerEventMap[MDIWindowEvent.RESIZE] = MDIManagerEvent.WINDOW_RESIZE;
         windowToManagerEventMap[MDIWindowEvent.RESIZE_END] = MDIManagerEvent.WINDOW_RESIZE_END;
         addEventListener(MDIManagerEvent.WINDOW_ADD,executeDefaultBehavior,false,EventPriority.DEFAULT_HANDLER);
         addEventListener(MDIManagerEvent.WINDOW_MINIMIZE,executeDefaultBehavior,false,EventPriority.DEFAULT_HANDLER);
         addEventListener(MDIManagerEvent.WINDOW_RESTORE,executeDefaultBehavior,false,EventPriority.DEFAULT_HANDLER);
         addEventListener(MDIManagerEvent.WINDOW_MAXIMIZE,executeDefaultBehavior,false,EventPriority.DEFAULT_HANDLER);
         addEventListener(MDIManagerEvent.WINDOW_CLOSE,executeDefaultBehavior,false,EventPriority.DEFAULT_HANDLER);
         addEventListener(MDIManagerEvent.WINDOW_FOCUS_START,executeDefaultBehavior,false,EventPriority.DEFAULT_HANDLER);
         addEventListener(MDIManagerEvent.WINDOW_FOCUS_END,executeDefaultBehavior,false,EventPriority.DEFAULT_HANDLER);
         addEventListener(MDIManagerEvent.WINDOW_DRAG_START,executeDefaultBehavior,false,EventPriority.DEFAULT_HANDLER);
         addEventListener(MDIManagerEvent.WINDOW_DRAG,executeDefaultBehavior,false,EventPriority.DEFAULT_HANDLER);
         addEventListener(MDIManagerEvent.WINDOW_DRAG_END,executeDefaultBehavior,false,EventPriority.DEFAULT_HANDLER);
         addEventListener(MDIManagerEvent.WINDOW_RESIZE_START,executeDefaultBehavior,false,EventPriority.DEFAULT_HANDLER);
         addEventListener(MDIManagerEvent.WINDOW_RESIZE,executeDefaultBehavior,false,EventPriority.DEFAULT_HANDLER);
         addEventListener(MDIManagerEvent.WINDOW_RESIZE_END,executeDefaultBehavior,false,EventPriority.DEFAULT_HANDLER);
         addEventListener(MDIManagerEvent.CASCADE,executeDefaultBehavior,false,EventPriority.DEFAULT_HANDLER);
         addEventListener(MDIManagerEvent.TILE,executeDefaultBehavior,false,EventPriority.DEFAULT_HANDLER);
      }
      
      public static function get global() : MDIManager
      {
         if(MDIManager.globalMDIManager == null)
         {
            globalMDIManager = new MDIManager(Application.application as UIComponent);
            globalMDIManager.isGlobal = true;
         }
         return MDIManager.globalMDIManager;
      }
      
      public function get container() : UIComponent
      {
         return _container;
      }
      
      private function removeTileInstance(window:MDIWindow) : void
      {
         var i:int = 0;
         for(i = 0; i < tiledWindows.length; i++)
         {
            if(tiledWindows.getItemAt(i) == window)
            {
               this.tiledWindows.removeItemAt(i);
               reTileWindows();
            }
         }
      }
      
      public function set container(value:UIComponent) : void
      {
         this._container = value;
      }
      
      private function windowEventProxy(event:Event) : void
      {
         var winEvent:MDIWindowEvent = null;
         var mgrEvent:MDIManagerEvent = null;
         var maxTiles:int = 0;
         var xPos:Number = NaN;
         var yPos:Number = NaN;
         var minimizePoint:Point = null;
         if(event is MDIWindowEvent && !event.isDefaultPrevented())
         {
            winEvent = event as MDIWindowEvent;
            mgrEvent = new MDIManagerEvent(windowToManagerEventMap[winEvent.type],winEvent.window,this);
            switch(winEvent.type)
            {
               case MDIWindowEvent.MINIMIZE:
                  mgrEvent.window.saveStyle();
                  maxTiles = Math.floor(this.container.width / (this.tileMinimizeWidth + this.tilePadding));
                  xPos = getLeftOffsetPosition(this.tiledWindows.length,maxTiles,this.tileMinimizeWidth,this.minTilePadding);
                  yPos = this.container.height - getBottomTilePosition(this.tiledWindows.length,maxTiles,mgrEvent.window.minimizeHeight,this.minTilePadding);
                  minimizePoint = new Point(xPos,yPos);
                  mgrEvent.effect = this.effects.getWindowMinimizeEffect(mgrEvent.window,this,minimizePoint);
                  break;
               case MDIWindowEvent.RESTORE:
                  mgrEvent.window.restoreStyle();
                  mgrEvent.effect = this.effects.getWindowRestoreEffect(winEvent.window,this,winEvent.window.savedWindowRect);
                  break;
               case MDIWindowEvent.MAXIMIZE:
                  mgrEvent.window.restoreStyle();
                  mgrEvent.effect = this.effects.getWindowMaximizeEffect(winEvent.window,this);
                  break;
               case MDIWindowEvent.CLOSE:
                  mgrEvent.effect = this.effects.getWindowCloseEffect(mgrEvent.window,this);
                  break;
               case MDIWindowEvent.FOCUS_START:
                  mgrEvent.effect = this.effects.getWindowFocusStartEffect(winEvent.window,this);
                  break;
               case MDIWindowEvent.FOCUS_END:
                  mgrEvent.effect = this.effects.getWindowFocusEndEffect(winEvent.window,this);
                  break;
               case MDIWindowEvent.DRAG_START:
                  mgrEvent.effect = this.effects.getWindowDragStartEffect(winEvent.window,this);
                  break;
               case MDIWindowEvent.DRAG:
                  mgrEvent.effect = this.effects.getWindowDragEffect(winEvent.window,this);
                  break;
               case MDIWindowEvent.DRAG_END:
                  mgrEvent.effect = this.effects.getWindowDragEndEffect(winEvent.window,this);
                  break;
               case MDIWindowEvent.RESIZE_START:
                  mgrEvent.effect = this.effects.getWindowResizeStartEffect(winEvent.window,this);
                  break;
               case MDIWindowEvent.RESIZE:
                  mgrEvent.effect = this.effects.getWindowResizeEffect(winEvent.window,this);
                  break;
               case MDIWindowEvent.RESIZE_END:
                  mgrEvent.effect = this.effects.getWindowResizeEndEffect(winEvent.window,this);
            }
            dispatchEvent(mgrEvent);
         }
      }
      
      public function absPos(window:MDIWindow, x:int, y:int) : void
      {
         window.x = x;
         window.y = y;
      }
      
      private function removeListeners(window:MDIWindow) : void
      {
         window.removeEventListener(MDIWindowEvent.MINIMIZE,windowEventProxy);
         window.removeEventListener(MDIWindowEvent.RESTORE,windowEventProxy);
         window.removeEventListener(MDIWindowEvent.MAXIMIZE,windowEventProxy);
         window.removeEventListener(MDIWindowEvent.CLOSE,windowEventProxy);
         window.removeEventListener(MDIWindowEvent.FOCUS_START,windowEventProxy);
         window.removeEventListener(MDIWindowEvent.FOCUS_END,windowEventProxy);
         window.removeEventListener(MDIWindowEvent.DRAG_START,windowEventProxy);
         window.removeEventListener(MDIWindowEvent.DRAG,windowEventProxy);
         window.removeEventListener(MDIWindowEvent.DRAG_END,windowEventProxy);
         window.removeEventListener(MDIWindowEvent.RESIZE_START,windowEventProxy);
         window.removeEventListener(MDIWindowEvent.RESIZE,windowEventProxy);
         window.removeEventListener(MDIWindowEvent.RESIZE_END,windowEventProxy);
      }
      
      public function remove(window:MDIWindow) : void
      {
         var index:int = 0;
         var i:int = 0;
         var dObj:DisplayObject = null;
         index = int(ArrayUtil.getItemIndex(window,this.windowList));
         windowList.splice(index,1);
         if(this.isGlobal)
         {
            PopUpManager.removePopUp(window as IFlexDisplayObject);
         }
         else
         {
            container.removeChild(window);
         }
         removeListeners(window);
         for(i = container.numChildren - 1; i > -1; i--)
         {
            dObj = container.getChildAt(i);
            if(dObj is MDIWindow)
            {
               bringToFront(MDIWindow(dObj));
               return;
            }
         }
      }
      
      public function getOpenWindowList() : Array
      {
         var array:Array = null;
         var i:int = 0;
         array = [];
         for(i = 0; i < windowList.length; i++)
         {
            if(!MDIWindow(windowList[i]).minimized)
            {
               array.push(windowList[i]);
            }
         }
         return array;
      }
      
      public function add(window:MDIWindow) : void
      {
         if(windowList.indexOf(window) < 0)
         {
            window.windowManager = this;
            this.addListeners(window);
            this.windowList.push(window);
            this.addContextMenu(window);
            if(this.isGlobal)
            {
               PopUpManager.addPopUp(window,Application.application as DisplayObject);
               this.position(window);
            }
            else if(window.parent == null)
            {
               this.container.addChild(window);
               this.position(window);
            }
            dispatchEvent(new MDIManagerEvent(MDIManagerEvent.WINDOW_ADD,window,this));
            bringToFront(window);
         }
      }
      
      private function addListeners(window:MDIWindow) : void
      {
         window.addEventListener(MDIWindowEvent.MINIMIZE,windowEventProxy,false,EventPriority.DEFAULT_HANDLER);
         window.addEventListener(MDIWindowEvent.RESTORE,windowEventProxy,false,EventPriority.DEFAULT_HANDLER);
         window.addEventListener(MDIWindowEvent.MAXIMIZE,windowEventProxy,false,EventPriority.DEFAULT_HANDLER);
         window.addEventListener(MDIWindowEvent.CLOSE,windowEventProxy,false,EventPriority.DEFAULT_HANDLER);
         window.addEventListener(MDIWindowEvent.FOCUS_START,windowEventProxy,false,EventPriority.DEFAULT_HANDLER);
         window.addEventListener(MDIWindowEvent.FOCUS_END,windowEventProxy,false,EventPriority.DEFAULT_HANDLER);
         window.addEventListener(MDIWindowEvent.DRAG_START,windowEventProxy,false,EventPriority.DEFAULT_HANDLER);
         window.addEventListener(MDIWindowEvent.DRAG,windowEventProxy,false,EventPriority.DEFAULT_HANDLER);
         window.addEventListener(MDIWindowEvent.DRAG_END,windowEventProxy,false,EventPriority.DEFAULT_HANDLER);
         window.addEventListener(MDIWindowEvent.RESIZE_START,windowEventProxy,false,EventPriority.DEFAULT_HANDLER);
         window.addEventListener(MDIWindowEvent.RESIZE,windowEventProxy,false,EventPriority.DEFAULT_HANDLER);
         window.addEventListener(MDIWindowEvent.RESIZE_END,windowEventProxy,false,EventPriority.DEFAULT_HANDLER);
      }
      
      public function position(window:MDIWindow) : void
      {
         window.x = this.windowList.length * 30;
         window.y = this.windowList.length * 30;
         if(window.x + window.width > container.width)
         {
            window.x = 40;
         }
         if(window.y + window.height > container.height)
         {
            window.y = 40;
         }
      }
      
      public function tile(fillAvailableSpace:Boolean = false, gap:Number = 0) : void
      {
         var openWinList:Array = null;
         var numWindows:int = 0;
         var sqrt:int = 0;
         var numCols:int = 0;
         var numRows:int = 0;
         var col:int = 0;
         var row:int = 0;
         var availWidth:Number = NaN;
         var availHeight:Number = NaN;
         var targetWidth:Number = NaN;
         var targetHeight:Number = NaN;
         var effectItems:Array = null;
         var i:int = 0;
         var win:MDIWindow = null;
         var item:MDIGroupEffectItem = null;
         var numOrphans:int = 0;
         var orphanWidth:Number = NaN;
         var orphanCount:int = 0;
         var j:int = 0;
         var orphan:MDIGroupEffectItem = null;
         openWinList = getOpenWindowList();
         numWindows = int(openWinList.length);
         if(numWindows == 1)
         {
            MDIWindow(openWinList[0]).maximizeRestore();
         }
         else if(numWindows > 1)
         {
            sqrt = Math.round(Math.sqrt(numWindows));
            numCols = Math.ceil(numWindows / sqrt);
            numRows = Math.ceil(numWindows / numCols);
            col = 0;
            row = 0;
            availWidth = Number(this.container.width);
            availHeight = Number(this.container.height);
            if(showMinimizedTiles)
            {
               availHeight -= getBottomOffsetHeight(this.tiledWindows.length,openWinList[0].minimizeHeight,this.minTilePadding);
            }
            targetWidth = availWidth / numCols - gap * (numCols - 1) / numCols;
            targetHeight = availHeight / numRows - gap * (numRows - 1) / numRows;
            effectItems = [];
            for(i = 0; i < openWinList.length; i++)
            {
               win = openWinList[i];
               bringToFront(win);
               item = new MDIGroupEffectItem(win);
               item.widthTo = targetWidth;
               item.heightTo = targetHeight;
               if(i % numCols == 0 && i > 0)
               {
                  row++;
                  col = 0;
               }
               else if(i > 0)
               {
                  col++;
               }
               item.moveTo = new Point(col * targetWidth,row * targetHeight);
               if(col > 0)
               {
                  item.moveTo.x += gap * col;
               }
               if(row > 0)
               {
                  item.moveTo.y += gap * row;
               }
               effectItems.push(item);
            }
            if(col < numCols && fillAvailableSpace)
            {
               numOrphans = numWindows % numCols;
               orphanWidth = availWidth / numOrphans - gap * (numOrphans - 1) / numOrphans;
               orphanCount = 0;
               for(j = numWindows - numOrphans; j < numWindows; j++)
               {
                  orphan = effectItems[j];
                  orphan.widthTo = orphanWidth;
                  orphan.moveTo.x = (j - (numWindows - numOrphans)) * orphanWidth;
                  if(orphanCount > 0)
                  {
                     orphan.moveTo.x += gap * orphanCount;
                  }
                  orphanCount++;
               }
            }
            dispatchEvent(new MDIManagerEvent(MDIManagerEvent.TILE,null,this,null,effectItems));
         }
      }
      
      private function onCloseEffectEnd(event:EffectEvent) : void
      {
         remove(event.effectInstance.target as MDIWindow);
      }
      
      public function resize(window:MDIWindow) : void
      {
         var w:int = 0;
         var h:int = 0;
         w = this.container.width * 0.6;
         h = this.container.height * 0.6;
         if(w > window.width)
         {
            window.width = w;
         }
         if(h > window.height)
         {
            window.height = h;
         }
      }
      
      public function bringToFront(window:MDIWindow) : void
      {
         var win:MDIWindow = null;
         if(this.isGlobal)
         {
            PopUpManager.bringToFront(window as IFlexDisplayObject);
         }
         else
         {
            for each(win in windowList)
            {
               if(win != window && win.hasFocus)
               {
                  win.dispatchEvent(new MDIWindowEvent(MDIWindowEvent.FOCUS_END,win));
               }
               if(win == window && !window.hasFocus)
               {
                  win.dispatchEvent(new MDIWindowEvent(MDIWindowEvent.FOCUS_START,win));
               }
            }
         }
      }
      
      private function getLeftOffsetPosition(tileIndex:int, maxTiles:int, minWinWidth:Number, padding:Number) : Number
      {
         var tileModPos:int = 0;
         tileModPos = tileIndex % maxTiles;
         if(tileModPos == 0)
         {
            return padding;
         }
         return tileModPos * minWinWidth + (tileModPos + 1) * padding;
      }
      
      public function cascade() : void
      {
         var effectItems:Array = null;
         var windows:Array = null;
         var xIndex:int = 0;
         var yIndex:int = 0;
         var i:int = 0;
         var window:MDIWindow = null;
         var item:MDIGroupEffectItem = null;
         var destX:int = 0;
         var destY:int = 0;
         effectItems = [];
         windows = getOpenWindowList();
         xIndex = 0;
         yIndex = -1;
         for(i = 0; i < windows.length; i++)
         {
            window = windows[i] as MDIWindow;
            bringToFront(window);
            item = new MDIGroupEffectItem(window);
            item.widthFrom = window.width;
            item.widthTo = container.width * 0.5;
            item.heightFrom = window.height;
            item.heightTo = container.height * 0.5;
            if(yIndex * 40 + item.heightTo + 25 >= container.height)
            {
               yIndex = 0;
               xIndex++;
            }
            else
            {
               yIndex++;
            }
            destX = xIndex * 40 + yIndex * 20;
            destY = yIndex * 40;
            item.moveTo = new Point(destX,destY);
            effectItems.push(item);
         }
         dispatchEvent(new MDIManagerEvent(MDIManagerEvent.CASCADE,null,this,null,effectItems));
      }
      
      private function menuItemSelectHandler(event:ContextMenuEvent) : void
      {
         var win:MDIWindow = null;
         win = event.contextMenuOwner as MDIWindow;
         switch(event.target.caption)
         {
            case CONTEXT_MENU_LABEL_TILE:
               this.tile(false,this.tilePadding);
               break;
            case CONTEXT_MENU_LABEL_TILE_FILL:
               this.tile(true,this.tilePadding);
               break;
            case CONTEXT_MENU_LABEL_CASCADE:
               this.cascade();
               break;
            case CONTEXT_MENU_LABEL_SHOW_ALL:
               this.showAllWindows();
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get windowList() : Array
      {
         return this._1862305966windowList;
      }
      
      private function getBottomTilePosition(tileIndex:int, maxTiles:int, minWindowHeight:Number, padding:Number) : Number
      {
         var numRows:int = 0;
         numRows = Math.floor(tileIndex / maxTiles);
         if(numRows == 0)
         {
            return minWindowHeight + padding;
         }
         return (numRows + 1) * minWindowHeight + (numRows + 1) * padding;
      }
      
      private function reTileWindows() : void
      {
         var maxTiles:int = 0;
         var i:int = 0;
         var openWins:Array = null;
         var winIndex:int = 0;
         var currentWindow:MDIWindow = null;
         var xPos:Number = NaN;
         var yPos:Number = NaN;
         var movePoint:Point = null;
         maxTiles = Math.floor(this.container.width / (this.tileMinimizeWidth + this.tilePadding));
         if(this.tiledWindows.length % maxTiles == 0 || (this.tiledWindows.length - 1) % maxTiles == 0)
         {
            openWins = getOpenWindowList();
            for(winIndex = 0; winIndex < openWins.length; winIndex++)
            {
               if(MDIWindow(openWins[winIndex]).maximized)
               {
                  maximizeWindow(MDIWindow(openWins[winIndex]));
               }
            }
         }
         for(i = 0; i < tiledWindows.length; i++)
         {
            currentWindow = tiledWindows.getItemAt(i) as MDIWindow;
            xPos = getLeftOffsetPosition(i,maxTiles,this.tileMinimizeWidth,this.minTilePadding);
            yPos = this.container.height - getBottomTilePosition(i,maxTiles,currentWindow.minimizeHeight,this.minTilePadding);
            movePoint = new Point(xPos,yPos);
            this.effects.reTileMinWindowsEffect(currentWindow,this,movePoint).play();
         }
      }
      
      public function center(window:MDIWindow) : void
      {
         window.x = this.container.width / 2 - window.width;
         window.y = this.container.height / 2 - window.height;
      }
      
      public function addCenter(window:MDIWindow) : void
      {
         this.add(window);
         this.center(window);
      }
      
      private function getBottomOffsetHeight(maxTiles:int, minWindowHeight:Number, padding:Number) : Number
      {
         var numRows:int = 0;
         numRows = Math.ceil(this.tiledWindows.length / maxTiles);
         if(this.tiledWindows.length != 0)
         {
            return numRows * minWindowHeight + (numRows + 1) * padding;
         }
         return 0;
      }
      
      public function addContextMenu(window:MDIWindow, contextMenu:ContextMenu = null) : void
      {
         var defaultContextMenu:ContextMenu = null;
         var arrangeItem:ContextMenuItem = null;
         var arrangeFillItem:ContextMenuItem = null;
         var cascadeItem:ContextMenuItem = null;
         var showAllItem:ContextMenuItem = null;
         if(contextMenu == null)
         {
            defaultContextMenu = new ContextMenu();
            defaultContextMenu.hideBuiltInItems();
            arrangeItem = new ContextMenuItem(CONTEXT_MENU_LABEL_TILE);
            arrangeItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,menuItemSelectHandler);
            defaultContextMenu.customItems.push(arrangeItem);
            arrangeFillItem = new ContextMenuItem(CONTEXT_MENU_LABEL_TILE_FILL);
            arrangeFillItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,menuItemSelectHandler);
            defaultContextMenu.customItems.push(arrangeFillItem);
            cascadeItem = new ContextMenuItem(CONTEXT_MENU_LABEL_CASCADE);
            cascadeItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,menuItemSelectHandler);
            defaultContextMenu.customItems.push(cascadeItem);
            showAllItem = new ContextMenuItem(CONTEXT_MENU_LABEL_SHOW_ALL);
            showAllItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT,menuItemSelectHandler);
            defaultContextMenu.customItems.push(showAllItem);
            this.container.contextMenu = defaultContextMenu;
         }
         else
         {
            window.contextMenu = contextMenu;
         }
      }
      
      private function maximizeWindow(window:MDIWindow) : void
      {
         var maxTiles:int = 0;
         maxTiles = this.container.width / this.tileMinimizeWidth;
         if(showMinimizedTiles)
         {
            this.effects.getWindowMaximizeEffect(window,this,getBottomOffsetHeight(maxTiles,window.minimizeHeight,this.minTilePadding)).play();
         }
         else
         {
            this.effects.getWindowMaximizeEffect(window,this).play();
         }
      }
      
      public function manage(window:MDIWindow) : void
      {
         if(window != null)
         {
            windowList.push(window);
         }
      }
      
      public function set windowList(value:Array) : void
      {
         var oldValue:Object = null;
         oldValue = this._1862305966windowList;
         if(oldValue !== value)
         {
            this._1862305966windowList = value;
            dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"windowList",oldValue,value));
         }
      }
      
      private function containerResizeHandler(event:ResizeEvent) : void
      {
         reTileWindows();
      }
      
      private function onMinimizeEffectEnd(event:EffectEvent) : void
      {
         var targetWindow:MDIWindow = null;
         var compEffect:CompositeEffect = null;
         targetWindow = event.effectInstance.target as MDIWindow;
         if(targetWindow == null && event.effectInstance is CompositeEffectInstance)
         {
            compEffect = event.effectInstance.effect as CompositeEffect;
            targetWindow = Effect(compEffect.children[0]).target as MDIWindow;
         }
         tiledWindows.addItem(targetWindow);
         reTileWindows();
      }
      
      public function removeAll() : void
      {
         var window:MDIWindow = null;
         for each(window in windowList)
         {
            if(this.isGlobal)
            {
               PopUpManager.removePopUp(window as IFlexDisplayObject);
            }
            else
            {
               container.removeChild(window);
            }
            this.removeListeners(window);
         }
         this.windowList = new Array();
      }
      
      public function executeDefaultBehavior(event:Event) : void
      {
         var mgrEvent:MDIManagerEvent = null;
         if(event is MDIManagerEvent && !event.isDefaultPrevented())
         {
            mgrEvent = event as MDIManagerEvent;
            switch(mgrEvent.type)
            {
               case MDIManagerEvent.WINDOW_ADD:
                  mgrEvent.effect = this.effects.getWindowAddEffect(mgrEvent.window,this);
                  mgrEvent.effect.play();
                  break;
               case MDIManagerEvent.WINDOW_MINIMIZE:
                  mgrEvent.effect.addEventListener(EffectEvent.EFFECT_END,onMinimizeEffectEnd);
                  mgrEvent.effect.play();
                  break;
               case MDIManagerEvent.WINDOW_RESTORE:
                  removeTileInstance(mgrEvent.window);
                  mgrEvent.effect.play();
                  break;
               case MDIManagerEvent.WINDOW_MAXIMIZE:
                  removeTileInstance(mgrEvent.window);
                  maximizeWindow(mgrEvent.window);
                  break;
               case MDIManagerEvent.WINDOW_CLOSE:
                  removeTileInstance(mgrEvent.window);
                  mgrEvent.effect.addEventListener(EffectEvent.EFFECT_END,onCloseEffectEnd);
                  mgrEvent.effect.play();
                  break;
               case MDIManagerEvent.WINDOW_FOCUS_START:
                  mgrEvent.window.hasFocus = true;
                  mgrEvent.window.validateNow();
                  container.setChildIndex(mgrEvent.window,container.numChildren - 1);
                  mgrEvent.effect.play();
                  break;
               case MDIManagerEvent.WINDOW_FOCUS_END:
                  mgrEvent.window.hasFocus = false;
                  mgrEvent.window.validateNow();
                  mgrEvent.effect.play();
                  break;
               case MDIManagerEvent.WINDOW_DRAG_START:
                  mgrEvent.effect.play();
                  break;
               case MDIManagerEvent.WINDOW_DRAG:
                  mgrEvent.effect.play();
                  break;
               case MDIManagerEvent.WINDOW_DRAG_END:
                  mgrEvent.effect.play();
                  break;
               case MDIManagerEvent.WINDOW_RESIZE_START:
                  mgrEvent.effect.play();
                  break;
               case MDIManagerEvent.WINDOW_RESIZE:
                  mgrEvent.effect.play();
                  break;
               case MDIManagerEvent.WINDOW_RESIZE_END:
                  mgrEvent.effect.play();
                  break;
               case MDIManagerEvent.CASCADE:
                  mgrEvent.effect = this.effects.getCascadeEffect(mgrEvent.effectItems,this);
                  mgrEvent.effect.play();
                  break;
               case MDIManagerEvent.TILE:
                  mgrEvent.effect = this.effects.getTileEffect(mgrEvent.effectItems,this);
                  mgrEvent.effect.play();
            }
         }
      }
      
      public function showAllWindows() : void
      {
         var window:MDIWindow = null;
         tiledWindows.removeAll();
         for each(window in windowList)
         {
            if(window.minimized)
            {
               window.unMinimize();
            }
         }
      }
   }
}

