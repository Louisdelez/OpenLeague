package flexlib.containers
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flexlib.controls.ScrollableArrowMenu;
   import flexlib.controls.SuperTabBar;
   import flexlib.controls.tabBarClasses.SuperTab;
   import flexlib.events.SuperTabEvent;
   import flexlib.events.TabReorderEvent;
   import flexlib.skins.TabPopUpButtonSkin;
   import mx.collections.ArrayCollection;
   import mx.collections.IList;
   import mx.containers.Box;
   import mx.containers.BoxDirection;
   import mx.containers.Canvas;
   import mx.containers.TabNavigator;
   import mx.containers.ViewStack;
   import mx.controls.Menu;
   import mx.controls.PopUpButton;
   import mx.core.Container;
   import mx.core.EdgeMetrics;
   import mx.core.ScrollPolicy;
   import mx.effects.Tween;
   import mx.events.ChildExistenceChangedEvent;
   import mx.events.IndexChangedEvent;
   import mx.events.MenuEvent;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   
   [Style(name="rightButtonStyleName",type="String",inherit="no")]
   [Style(name="leftButtonStyleName",type="String",inherit="no")]
   [Style(name="popupButtonStyleName",type="String",inherit="no")]
   [Event(name="tabsReordered",type="flexlib.events.TabReorderEvent")]
   [Event(name="tabClose",type="flexlib.events.SuperTabEvent")]
   [IconFile("SuperTabNavigator.png")]
   public class SuperTabNavigator extends TabNavigator
   {
      
      public static var POPUPPOLICY_AUTO:String = "auto";
      
      public static var POPUPPOLICY_ON:String = "on";
      
      public static var POPUPPOLICY_OFF:String = "off";
      
      [Embed(source="../assets/assets.swf",symbol="indicator")]
      private static var DEFAULT_INDICATOR:Class = SuperTabNavigator_DEFAULT_INDICATOR;
      
      [Embed(source="../assets/assets.swf",symbol="firefox_close_up")]
      private static var DEFAULT_CLOSE_UP:Class = SuperTabNavigator_DEFAULT_CLOSE_UP;
      
      [Embed(source="../assets/assets.swf",symbol="firefox_close_over")]
      private static var DEFAULT_CLOSE_OVER:Class = SuperTabNavigator_DEFAULT_CLOSE_OVER;
      
      [Embed(source="../assets/assets.swf",symbol="firefox_close_down")]
      private static var DEFAULT_CLOSE_DOWN:Class = SuperTabNavigator_DEFAULT_CLOSE_DOWN;
      
      [Embed(source="../assets/assets.swf",symbol="firefox_close_disabled")]
      private static var DEFAULT_CLOSE_DISABLED:Class = SuperTabNavigator_DEFAULT_CLOSE_DISABLED;
      
      [Embed(source="../assets/assets.swf",symbol="left_arrow")]
      private static var DEFAULT_LEFT_BUTTON:Class = SuperTabNavigator_DEFAULT_LEFT_BUTTON;
      
      [Embed(source="../assets/assets.swf",symbol="right_arrow")]
      private static var DEFAULT_RIGHT_BUTTON:Class = SuperTabNavigator_DEFAULT_RIGHT_BUTTON;
      
      initializeStyles();
      
      private var _editableTabLabels:Boolean = false;
      
      private var stopIndexChangeEvent:Boolean = false;
      
      private var _stopScrollingEvent:String = MouseEvent.MOUSE_UP;
      
      private var forcedTabWidth:Number = -1;
      
      protected var canvas:ButtonScrollingCanvas;
      
      protected var menu:Menu;
      
      protected var holder:Box;
      
      private var _dragEnabled:Boolean = true;
      
      private var _allowTabSqueezing:Boolean = true;
      
      private var _minTabWidth:Number = 60;
      
      private var originalTabWidthStyle:Number = -1;
      
      protected var popupButton:PopUpButton;
      
      private var _dropEnabled:Boolean = true;
      
      private var _closePolicy:String = SuperTab.CLOSE_ROLLOVER;
      
      private var _popUpButtonPolicy:String;
      
      private var _scrollSpeed:Number = 100;
      
      private var _startScrollingEvent:String = MouseEvent.MOUSE_DOWN;
      
      public function SuperTabNavigator()
      {
         super();
      }
      
      private static function initializeStyles() : void
      {
         var selector:CSSStyleDeclaration = null;
         var popupButtonStyleName:String = null;
         var pSelector:CSSStyleDeclaration = null;
         var tabStyleName:String = null;
         var tSelector:CSSStyleDeclaration = null;
         var tabCloseStyleName:String = null;
         var cSelector:CSSStyleDeclaration = null;
         var leftStyleName:String = null;
         var lSelector:CSSStyleDeclaration = null;
         var rightStyleName:String = null;
         var rSelector:CSSStyleDeclaration = null;
         selector = StyleManager.getStyleDeclaration("SuperTabNavigator");
         if(!selector)
         {
            selector = new CSSStyleDeclaration();
         }
         selector.defaultFactory = function():void
         {
            this.popupButtonStyleName = "popupButton";
            this.tabStyleName = "superTab";
            this.leftButtonStyleName = "leftButton";
            this.rightButtonStyleName = "rightButton";
            this.buttonWidth = 20;
         };
         popupButtonStyleName = selector.getStyle("popupButtonStyleName");
         pSelector = StyleManager.getStyleDeclaration("." + popupButtonStyleName);
         if(!pSelector)
         {
            pSelector = new CSSStyleDeclaration();
         }
         pSelector.defaultFactory = function():void
         {
            this.upSkin = TabPopUpButtonSkin;
            this.popUpDownSkin = TabPopUpButtonSkin;
            this.popUpOverSkin = TabPopUpButtonSkin;
            this.disabledSkin = TabPopUpButtonSkin;
         };
         StyleManager.setStyleDeclaration("." + popupButtonStyleName,pSelector,false);
         tabStyleName = selector.getStyle("tabStyleName");
         tSelector = StyleManager.getStyleDeclaration("." + tabStyleName);
         if(!tSelector)
         {
            tSelector = new CSSStyleDeclaration();
         }
         tSelector.defaultFactory = function():void
         {
            this.textAlign = "left";
            this.indicatorClass = DEFAULT_INDICATOR;
            this.tabCloseButtonStyleName = "tabCloseButton";
         };
         StyleManager.setStyleDeclaration("." + tabStyleName,tSelector,false);
         tabCloseStyleName = tSelector.getStyle("tabCloseButtonStyleName");
         cSelector = StyleManager.getStyleDeclaration("." + tabCloseStyleName);
         if(!cSelector)
         {
            cSelector = new CSSStyleDeclaration();
         }
         cSelector.defaultFactory = function():void
         {
            this.upSkin = DEFAULT_CLOSE_UP;
            this.overSkin = DEFAULT_CLOSE_OVER;
            this.downSkin = DEFAULT_CLOSE_DOWN;
            this.disabledSkin = DEFAULT_CLOSE_DISABLED;
         };
         StyleManager.setStyleDeclaration("." + tabCloseStyleName,cSelector,false);
         leftStyleName = selector.getStyle("leftButtonStyleName");
         lSelector = StyleManager.getStyleDeclaration("." + leftStyleName);
         if(!lSelector)
         {
            lSelector = new CSSStyleDeclaration();
         }
         lSelector.defaultFactory = function():void
         {
            this.icon = DEFAULT_LEFT_BUTTON;
            this.fillAlphas = [1,1,1,1];
            this.cornerRadius = 0;
         };
         StyleManager.setStyleDeclaration("." + leftStyleName,lSelector,false);
         rightStyleName = selector.getStyle("rightButtonStyleName");
         rSelector = StyleManager.getStyleDeclaration("." + rightStyleName);
         if(!rSelector)
         {
            rSelector = new CSSStyleDeclaration();
         }
         rSelector.defaultFactory = function():void
         {
            this.icon = DEFAULT_RIGHT_BUTTON;
            this.fillAlphas = [1,1,1,1];
            this.cornerRadius = 0;
         };
         StyleManager.setStyleDeclaration("." + rightStyleName,rSelector,false);
         StyleManager.setStyleDeclaration("SuperTabNavigator",selector,false);
      }
      
      public function get allowTabSqueezing() : Boolean
      {
         return _allowTabSqueezing;
      }
      
      protected function createTabBar() : SuperTabBar
      {
         return new SuperTabBar();
      }
      
      public function reorderTabList() : void
      {
         var popupMenuDP:ArrayCollection = null;
         var i:int = 0;
         var child:Container = null;
         var obj:Object = null;
         popupMenuDP = new ArrayCollection();
         for(i = 0; i < this.numChildren; i++)
         {
            child = this.getChildAt(i) as Container;
            obj = new Object();
            obj.type = "";
            obj.label = child.label != "" ? child.label : "Untitled Tab";
            obj.icon = child.icon;
            popupMenuDP.addItem(obj);
         }
         menu.iconField = "icon";
         menu.dataProvider = popupMenuDP;
         popupButton.popUp = menu;
      }
      
      public function set stopScrollingEvent(value:String) : void
      {
         _stopScrollingEvent = value;
         canvas.stopScrollingEvent = value;
      }
      
      public function set allowTabSqueezing(value:Boolean) : void
      {
         _allowTabSqueezing = value;
         invalidateDisplayList();
      }
      
      private function tabChangedEvent(event:IndexChangedEvent) : void
      {
         callLater(ensureTabIsVisible);
      }
      
      private function tabsReordered(event:TabReorderEvent) : void
      {
         var clone:Event = null;
         var sourceBar:SuperTabBar = null;
         var droppedTab:SuperTab = null;
         var child:Object = null;
         var curDataProvider:Object = null;
         var lastClosePolicy:String = null;
         var lastStyleName:Object = null;
         var newChild:Canvas = null;
         var devent:IndexChangedEvent = null;
         clone = event.clone();
         dispatchEvent(clone);
         if(clone.isDefaultPrevented())
         {
            return;
         }
         sourceBar = event.relatedObject as SuperTabBar;
         droppedTab = sourceBar.getChildAt(event.oldIndex) as SuperTab;
         curDataProvider = sourceBar.dataProvider;
         lastClosePolicy = sourceBar.getClosePolicyForTab(event.oldIndex);
         lastStyleName = droppedTab.styleName;
         if(sourceBar != tabBar)
         {
            if(curDataProvider is IList)
            {
               child = (curDataProvider as IList).getItemAt(event.oldIndex);
               curDataProvider.removeItemAt(event.oldIndex);
               newChild = new Canvas();
               if(child.hasOwnProperty("label"))
               {
                  newChild.label = child.label;
               }
               else
               {
                  newChild.label = child.toString();
               }
               if(child.hasOwnProperty("icon"))
               {
                  newChild.icon = child.icon;
               }
               child = newChild;
            }
            else if(curDataProvider is ViewStack)
            {
               child = (curDataProvider as ViewStack).getChildAt(event.oldIndex);
               curDataProvider.removeChildAt(event.oldIndex);
            }
            if(child is DisplayObject)
            {
               this.addChildAt(child as DisplayObject,event.newIndex);
            }
            this.setClosePolicyForTab(event.newIndex,lastClosePolicy);
            droppedTab = this.getTabAt(event.newIndex) as SuperTab;
            droppedTab.styleName = lastStyleName;
         }
         else
         {
            if(event.oldIndex < event.newIndex)
            {
               --event.newIndex;
            }
            devent = new IndexChangedEvent(IndexChangedEvent.CHILD_INDEX_CHANGE);
            devent.oldIndex = event.oldIndex;
            devent.newIndex = event.newIndex;
            devent.relatedObject = getChildAt(event.newIndex);
            dispatchEvent(devent);
            stopIndexChangeEvent = true;
            this.setChildIndex(getChildAt(event.oldIndex),event.newIndex);
         }
         this.validateNow();
         this.selectedIndex = event.newIndex;
         reorderTabList();
      }
      
      public function get closePolicy() : String
      {
         return _closePolicy;
      }
      
      public function set startScrollingEvent(value:String) : void
      {
         _startScrollingEvent = value;
         if(Boolean(canvas))
         {
            canvas.startScrollingEvent = value;
         }
      }
      
      private function tabsChanged(event:Event) : void
      {
         callLater(reorderTabList);
      }
      
      public function get scrollSpeed() : Number
      {
         if(Boolean(canvas))
         {
            return canvas.scrollSpeed;
         }
         return _scrollSpeed;
      }
      
      public function get dropEnabled() : Boolean
      {
         if(Boolean(tabBar))
         {
            return (tabBar as SuperTabBar).dropEnabled;
         }
         return _dropEnabled;
      }
      
      public function onTweenEnd(val:Object) : void
      {
         canvas.horizontalScrollPosition = val as Number;
      }
      
      private function handleTabClose(event:SuperTabEvent) : void
      {
         var clone:SuperTabEvent = null;
         clone = event.clone() as SuperTabEvent;
         dispatchEvent(clone);
         if(clone.isDefaultPrevented())
         {
            event.preventDefault();
         }
      }
      
      public function get popUpButtonPolicy() : String
      {
         return _popUpButtonPolicy;
      }
      
      private function indexChangeListener(event:IndexChangedEvent) : void
      {
         if(stopIndexChangeEvent)
         {
            stopIndexChangeEvent = false;
            event.stopImmediatePropagation();
         }
      }
      
      public function get editableTabLabels() : Boolean
      {
         return _editableTabLabels;
      }
      
      public function get stopScrollingEvent() : String
      {
         if(Boolean(canvas))
         {
            return canvas.stopScrollingEvent;
         }
         return _stopScrollingEvent;
      }
      
      public function set closePolicy(value:String) : void
      {
         if(_closePolicy != value)
         {
            _closePolicy = value;
            if(tabBar != null)
            {
               (tabBar as SuperTabBar).closePolicy = value;
            }
            invalidateDisplayList();
         }
      }
      
      public function get startScrollingEvent() : String
      {
         if(Boolean(canvas))
         {
            return canvas.startScrollingEvent;
         }
         return _startScrollingEvent;
      }
      
      public function set dropEnabled(value:Boolean) : void
      {
         _dropEnabled = value;
         if(Boolean(tabBar))
         {
            (tabBar as SuperTabBar).dropEnabled = value;
         }
      }
      
      public function set dragEnabled(value:Boolean) : void
      {
         _dragEnabled = value;
         if(Boolean(tabBar))
         {
            (tabBar as SuperTabBar).dragEnabled = value;
         }
      }
      
      public function set scrollSpeed(value:Number) : void
      {
         if(Boolean(canvas))
         {
            canvas.scrollSpeed = value;
         }
         _scrollSpeed = value;
      }
      
      override protected function createChildren() : void
      {
         if(!tabBar)
         {
            tabBar = createTabBar();
            tabBar.name = "tabBar";
            tabBar.focusEnabled = false;
            tabBar.styleName = this;
            (tabBar as SuperTabBar).dragEnabled = this._dragEnabled;
            (tabBar as SuperTabBar).dropEnabled = this._dropEnabled;
            (tabBar as SuperTabBar).editableTabLabels = this._editableTabLabels;
            (tabBar as SuperTabBar).closePolicy = _closePolicy;
            tabBar.setStyle("borderStyle","none");
            tabBar.setStyle("paddingTop",0);
            tabBar.setStyle("paddingBottom",0);
            tabBar.setStyle("left",NaN);
            tabBar.setStyle("right",NaN);
            tabBar.setStyle("top",NaN);
            tabBar.setStyle("bottom",NaN);
            tabBar.setStyle("horizontalCenter",NaN);
            (tabBar as SuperTabBar).addEventListener(SuperTabEvent.TAB_CLOSE,handleTabClose);
         }
         super.createChildren();
         if(!holder)
         {
            holder = new Box();
            holder.direction = BoxDirection.HORIZONTAL;
            holder.setStyle("horizontalGap",0);
            holder.setStyle("borderStyle","none");
            holder.setStyle("paddingTop",0);
            holder.setStyle("paddingBottom",0);
            holder.horizontalScrollPolicy = "off";
            rawChildren.addChild(holder);
         }
         if(!canvas)
         {
            canvas = new ButtonScrollingCanvas();
            canvas.styleName = this;
            canvas.setStyle("borderStyle","none");
            canvas.setStyle("backgroundAlpha",0);
            canvas.setStyle("paddingTop",0);
            canvas.setStyle("paddingBottom",0);
            canvas.startScrollingEvent = _startScrollingEvent;
            canvas.stopScrollingEvent = _stopScrollingEvent;
            canvas.scrollSpeed = _scrollSpeed;
            canvas.addChild(tabBar);
            holder.addChild(canvas);
         }
         if(!menu)
         {
            menu = new ScrollableArrowMenu();
            menu.setStyle("textAlign","left");
            menu.verticalScrollPolicy = ScrollPolicy.AUTO;
            (menu as ScrollableArrowMenu).arrowScrollPolicy = ScrollPolicy.AUTO;
            menu.addEventListener(MenuEvent.ITEM_CLICK,changeTabs);
         }
         if(!popupButton)
         {
            popupButton = new PopUpButton();
            popupButton.popUp = menu;
            popupButton.width = 18;
            popupButton.styleName = getStyle("popupButtonStyleName");
            holder.addChild(popupButton);
         }
         tabBar.addEventListener(ChildExistenceChangedEvent.CHILD_ADD,tabsChanged);
         tabBar.addEventListener(ChildExistenceChangedEvent.CHILD_REMOVE,tabsChanged);
         SuperTabBar(tabBar).addEventListener(SuperTabEvent.TAB_UPDATED,tabsChanged);
         tabBar.addEventListener(SuperTabBar.TABS_REORDERED,tabsReordered);
         this.addEventListener(IndexChangedEvent.CHANGE,tabChangedEvent);
         invalidateSize();
         this.addEventListener(IndexChangedEvent.CHILD_INDEX_CHANGE,indexChangeListener);
      }
      
      protected function get tabBarHeight() : Number
      {
         var tabHeight:Number = NaN;
         tabHeight = Number(getStyle("tabHeight"));
         if(isNaN(tabHeight))
         {
            tabHeight = Number(tabBar.getExplicitOrMeasuredHeight());
         }
         return tabHeight - 1;
      }
      
      private function ensureTabIsVisible() : void
      {
         var tab:DisplayObject = null;
         var newHorizontalPosition:Number = NaN;
         var tween:Tween = null;
         tab = this.tabBar.getChildAt(this.selectedIndex);
         if(tab.x + tab.width > this.canvas.horizontalScrollPosition + this.canvas.width)
         {
            newHorizontalPosition = tab.x - canvas.width + tab.width + canvas.getStyle("buttonWidth");
         }
         else if(this.canvas.horizontalScrollPosition > tab.x)
         {
            newHorizontalPosition = tab.x - canvas.getStyle("buttonWidth");
         }
         else
         {
            newHorizontalPosition = canvas.horizontalScrollPosition;
         }
         if(Boolean(newHorizontalPosition))
         {
            tween = new Tween(this,canvas.horizontalScrollPosition,newHorizontalPosition,500);
         }
      }
      
      private function changeTabs(event:MenuEvent) : void
      {
         if(this.selectedIndex == event.index)
         {
            ensureTabIsVisible();
         }
         this.selectedIndex = event.index;
      }
      
      public function set minTabWidth(value:Number) : void
      {
         this._minTabWidth = value;
         this.invalidateDisplayList();
      }
      
      public function get dragEnabled() : Boolean
      {
         if(Boolean(tabBar))
         {
            return (tabBar as SuperTabBar).dragEnabled;
         }
         return _dragEnabled;
      }
      
      override public function initialize() : void
      {
         super.initialize();
         SuperTabNavigator.initializeStyles();
      }
      
      public function setClosePolicyForTab(index:int, value:String) : void
      {
         (tabBar as SuperTabBar).setClosePolicyForTab(index,value);
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         super.styleChanged(styleProp);
         if(styleProp == "tabWidth" && forcedTabWidth == -1)
         {
            originalTabWidthStyle = this.getStyle(styleProp);
         }
      }
      
      public function get minTabWidth() : Number
      {
         return _minTabWidth;
      }
      
      public function onTweenUpdate(val:Object) : void
      {
         canvas.horizontalScrollPosition = val as Number;
      }
      
      public function set popUpButtonPolicy(value:String) : void
      {
         var old:String = null;
         old = this._popUpButtonPolicy;
         this._popUpButtonPolicy = value;
         if(old != value)
         {
            this.invalidateDisplayList();
         }
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var vm:EdgeMetrics = null;
         var w:Number = NaN;
         var th:Number = NaN;
         var tabBarSpace:Number = NaN;
         var tempWidth:Number = NaN;
         var pw:Number = NaN;
         var tabBarWidth:Number = NaN;
         var canvasWidth:Number = NaN;
         var measuredTabBarWidth:Number = NaN;
         if(_popUpButtonPolicy == SuperTabNavigator.POPUPPOLICY_AUTO)
         {
            popupButton.includeInLayout = popupButton.visible = this.numChildren > 1;
         }
         else if(_popUpButtonPolicy == SuperTabNavigator.POPUPPOLICY_ON)
         {
            popupButton.includeInLayout = popupButton.visible = true;
         }
         else if(_popUpButtonPolicy == SuperTabNavigator.POPUPPOLICY_OFF)
         {
            popupButton.includeInLayout = popupButton.visible = false;
         }
         vm = viewMetrics;
         w = unscaledWidth - vm.left - vm.right;
         th = tabBarHeight + 1;
         tabBarSpace = w;
         if(popupButton.includeInLayout)
         {
            tabBarSpace -= popupButton.width;
         }
         tempWidth = Number(tabBar.getStyle("tabWidth"));
         tabBar.clearStyle("tabWidth");
         tabBar.setStyle("tabWidth",NaN);
         tabBar.validateNow();
         pw = Math.max(tabBar.getExplicitOrMeasuredWidth(),tabBarSpace);
         tabBar.setStyle("tabWidth",tempWidth);
         tabBarWidth = Number(tabBar.measuredWidth);
         holder.move(0,1);
         holder.setActualSize(unscaledWidth,th);
         canvasWidth = unscaledWidth;
         if(popupButton.includeInLayout)
         {
            canvasWidth -= popupButton.width;
         }
         canvas.width = canvasWidth;
         canvas.height = th;
         canvas.explicitButtonHeight = th - 1;
         canvas.verticalScrollPolicy = ScrollPolicy.OFF;
         if(pw <= canvasWidth)
         {
            canvas.horizontalScrollPosition = 0;
         }
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         if(tabBarWidth >= canvasWidth)
         {
            if(_allowTabSqueezing)
            {
               measuredTabBarWidth = tabBar.numChildren * _minTabWidth + (tabBar.numChildren - 1) * getStyle("horizontalGap");
               tabBar.width = Math.max(canvasWidth,measuredTabBarWidth);
            }
            else
            {
               tabBar.width = tabBarWidth;
            }
         }
         else
         {
            tabBar.width = tabBarWidth;
         }
         if(tabBarWidth < canvasWidth)
         {
            switch(getStyle("horizontalAlign"))
            {
               case "left":
                  tabBar.move(0,tabBar.y);
                  break;
               case "right":
                  tabBar.move(unscaledWidth - tabBar.width,tabBar.y);
                  break;
               case "center":
                  tabBar.move((unscaledWidth - tabBar.width) / 2,tabBar.y);
            }
         }
      }
      
      public function set editableTabLabels(value:Boolean) : void
      {
         this._editableTabLabels = value;
         if(Boolean(tabBar))
         {
            (tabBar as SuperTabBar).editableTabLabels = value;
         }
      }
   }
}

