package mx.controls
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.ui.Keyboard;
   import flash.utils.clearInterval;
   import flash.utils.setTimeout;
   import flash.xml.XMLNode;
   import mx.collections.ArrayCollection;
   import mx.collections.CursorBookmark;
   import mx.collections.ICollectionView;
   import mx.collections.XMLListCollection;
   import mx.controls.listClasses.BaseListData;
   import mx.controls.listClasses.IListItemRenderer;
   import mx.controls.menuClasses.IMenuBarItemRenderer;
   import mx.controls.menuClasses.IMenuDataDescriptor;
   import mx.controls.menuClasses.IMenuItemRenderer;
   import mx.controls.menuClasses.MenuItemRenderer;
   import mx.controls.menuClasses.MenuListData;
   import mx.controls.treeClasses.DefaultDataDescriptor;
   import mx.core.ClassFactory;
   import mx.core.EdgeMetrics;
   import mx.core.EventPriority;
   import mx.core.FlexGlobals;
   import mx.core.IFlexDisplayObject;
   import mx.core.LayoutDirection;
   import mx.core.ScrollPolicy;
   import mx.core.UIComponent;
   import mx.core.UIComponentGlobals;
   import mx.effects.Tween;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.events.FlexEvent;
   import mx.events.ListEvent;
   import mx.events.MenuEvent;
   import mx.events.SandboxMouseEvent;
   import mx.managers.IActiveWindowManager;
   import mx.managers.IFocusManagerContainer;
   import mx.managers.ISystemManager;
   import mx.managers.PopUpManager;
   
   [RequiresDataBinding("true")]
   [IconFile("Menu.png")]
   [DefaultTriggerEvent("change")]
   [DefaultBindingProperty(destination="dataProvider")]
   [AccessibilityClass(implementation="mx.accessibility.MenuAccImpl")]
   [Exclude(name="verticalScrollPosition",kind="property")]
   [Exclude(name="verticalScrollPolicy",kind="property")]
   [Exclude(name="verticalScrollBarStyleName",kind="property")]
   [Exclude(name="showScrollTips",kind="property")]
   [Exclude(name="scrollTipFunction",kind="property")]
   [Exclude(name="maxVerticalScrollPosition",kind="property")]
   [Exclude(name="maxHorizontalScrollPosition",kind="property")]
   [Exclude(name="liveScrolling",kind="property")]
   [Exclude(name="horizontalScrollPosition",kind="property")]
   [Exclude(name="horizontalScrollPolicy",kind="property")]
   [Exclude(name="horizontalScrollBarStyleName",kind="property")]
   [Exclude(name="allowMultipleSelection",kind="property")]
   [Style(name="separatorSkin",type="Class",inherit="no")]
   [Style(name="radioDisabledIcon",type="Class",inherit="no")]
   [Style(name="radioIcon",type="Class",inherit="no")]
   [Style(name="checkDisabledIcon",type="Class",inherit="no")]
   [Style(name="checkIcon",type="Class",inherit="no")]
   [Style(name="branchDisabledIcon",type="Class",inherit="no")]
   [Style(name="branchIcon",type="Class",inherit="no")]
   [Style(name="textSelectedColor",type="uint",format="Color",inherit="yes")]
   [Style(name="textRollOverColor",type="uint",format="Color",inherit="yes")]
   [Style(name="textIndent",type="Number",format="Length",inherit="yes")]
   [Style(name="selectionEasingFunction",type="Function",inherit="no")]
   [Style(name="selectionColor",type="uint",format="Color",inherit="yes")]
   [Style(name="rollOverColor",type="uint",format="Color",inherit="yes")]
   [Style(name="openDuration",type="Number",format="Time",inherit="no")]
   [Style(name="rightIconGap",type="Number",format="Length",inherit="no")]
   [Style(name="leftIconGap",type="Number",format="Length",inherit="no")]
   [Style(name="horizontalGap",type="Number",format="Length",inherit="no")]
   [Style(name="alternatingItemColors",type="Array",arrayType="uint",format="Color",inherit="yes")]
   [Event(name="itemRollOver",type="mx.events.MenuEvent")]
   [Event(name="itemRollOut",type="mx.events.MenuEvent")]
   [Event(name="menuShow",type="mx.events.MenuEvent")]
   [Event(name="menuHide",type="mx.events.MenuEvent")]
   [Event(name="itemClick",type="mx.events.MenuEvent")]
   [Event(name="change",type="mx.events.MenuEvent")]
   public class Menu extends List implements IFocusManagerContainer
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static var createAccessibilityImplementation:Function;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var hiddenItem:IListItemRenderer;
      
      private var maxMeasuredIconWidth:Number = 0;
      
      private var maxMeasuredTypeIconWidth:Number = 0;
      
      private var maxMeasuredBranchIconWidth:Number = 0;
      
      private var useTwoColumns:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var sourceMenuBar:MenuBar;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var sourceMenuBarItem:IMenuBarItemRenderer;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var parentDisplayObject:DisplayObject;
      
      private var isDirectionLeft:Boolean = false;
      
      private var anchorRow:IListItemRenderer;
      
      private var subMenu:Menu;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var popupTween:Tween;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var supposedToLoseFocus:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var openSubMenuTimer:int = 0;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var closeTimer:int = 0;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _rootModel:ICollectionView;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _listDataProvider:ICollectionView;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _parentMenu:Menu;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _dataDescriptor:IMenuDataDescriptor = new DefaultDataDescriptor();
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var dataProviderChanged:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _showRoot:Boolean = true;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var showRootChanged:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _hasRoot:Boolean = false;
      
      public function Menu()
      {
         super();
         itemRenderer = new ClassFactory(MenuItemRenderer);
         setRowHeight(19);
         iconField = "icon";
         visible = false;
      }
      
      public static function createMenu(parent:DisplayObjectContainer, mdp:Object, showRoot:Boolean = true) : Menu
      {
         var menu:Menu = null;
         menu = new Menu();
         menu.tabEnabled = false;
         menu.tabFocusEnabled = false;
         menu.owner = DisplayObjectContainer(FlexGlobals.topLevelApplication);
         menu.showRoot = showRoot;
         popUpMenu(menu,parent,mdp);
         return menu;
      }
      
      public static function popUpMenu(menu:Menu, parent:DisplayObjectContainer, mdp:Object) : void
      {
         menu.parentDisplayObject = Boolean(parent) ? parent : DisplayObject(FlexGlobals.topLevelApplication);
         if(!mdp)
         {
            mdp = new XML();
         }
         menu.supposedToLoseFocus = true;
         menu.dataProvider = mdp;
      }
      
      private static function menuHideHandler(event:MenuEvent) : void
      {
         var menu:Menu = Menu(event.target);
         if(!event.isDefaultPrevented() && event.menu == menu)
         {
            menu.supposedToLoseFocus = true;
            PopUpManager.removePopUp(menu);
            menu.removeEventListener(MenuEvent.MENU_HIDE,menuHideHandler);
         }
      }
      
      public function get parentMenu() : Menu
      {
         return this._parentMenu;
      }
      
      public function set parentMenu(value:Menu) : void
      {
         this._parentMenu = value;
         value.addEventListener(FlexEvent.HIDE,this.parentHideHandler,false,0,true);
         value.addEventListener("rowHeightChanged",this.parentRowHeightHandler,false,0,true);
         value.addEventListener("iconFieldChanged",this.parentIconFieldHandler,false,0,true);
         value.addEventListener("iconFunctionChanged",this.parentIconFunctionHandler,false,0,true);
         value.addEventListener("labelFieldChanged",this.parentLabelFieldHandler,false,0,true);
         value.addEventListener("labelFunctionChanged",this.parentLabelFunctionHandler,false,0,true);
         value.addEventListener("itemRendererChanged",this.parentItemRendererHandler,false,0,true);
      }
      
      public function get dataDescriptor() : IMenuDataDescriptor
      {
         return IMenuDataDescriptor(this._dataDescriptor);
      }
      
      public function set dataDescriptor(value:IMenuDataDescriptor) : void
      {
         this._dataDescriptor = value;
      }
      
      override public function set dataProvider(value:Object) : void
      {
         var xl:XMLList = null;
         var tmp:Array = null;
         if(typeof value == "string")
         {
            value = new XML(value);
         }
         else if(value is XMLNode)
         {
            value = new XML(XMLNode(value).toString());
         }
         else if(value is XMLList)
         {
            value = new XMLListCollection(value as XMLList);
         }
         if(value is XML)
         {
            this._hasRoot = true;
            xl = new XMLList();
            xl += value;
            this._rootModel = new XMLListCollection(xl);
         }
         else if(value is ICollectionView)
         {
            this._rootModel = ICollectionView(value);
            if(this._rootModel.length == 1)
            {
               this._hasRoot = true;
            }
         }
         else if(value is Array)
         {
            this._rootModel = new ArrayCollection(value as Array);
         }
         else if(value is Object)
         {
            this._hasRoot = true;
            tmp = [];
            tmp.push(value);
            this._rootModel = new ArrayCollection(tmp);
         }
         else
         {
            this._rootModel = new ArrayCollection();
         }
         this.dataProviderChanged = true;
         invalidateProperties();
      }
      
      override public function get dataProvider() : Object
      {
         var model:* = super.dataProvider;
         if(model == null)
         {
            if(this._rootModel != null)
            {
               return this._rootModel;
            }
            return null;
         }
         return model;
      }
      
      public function get showRoot() : Boolean
      {
         return this._showRoot;
      }
      
      public function set showRoot(value:Boolean) : void
      {
         if(this._showRoot != value)
         {
            this._showRoot = value;
            this.showRootChanged = true;
            invalidateProperties();
         }
      }
      
      public function get hasRoot() : Boolean
      {
         return this._hasRoot;
      }
      
      public function get defaultButton() : IFlexDisplayObject
      {
         return null;
      }
      
      public function set defaultButton(value:IFlexDisplayObject) : void
      {
      }
      
      private function parentHideHandler(event:FlexEvent) : void
      {
         visible = false;
      }
      
      private function parentRowHeightHandler(event:Event) : void
      {
         rowHeight = this.parentMenu.rowHeight;
      }
      
      private function parentIconFieldHandler(event:Event) : void
      {
         iconField = this.parentMenu.iconField;
      }
      
      private function parentIconFunctionHandler(event:Event) : void
      {
         iconFunction = this.parentMenu.iconFunction;
      }
      
      private function parentLabelFieldHandler(event:Event) : void
      {
         labelField = this.parentMenu.labelField;
      }
      
      private function parentLabelFunctionHandler(event:Event) : void
      {
         labelFunction = this.parentMenu.labelFunction;
      }
      
      private function parentItemRendererHandler(event:Event) : void
      {
         itemRenderer = this.parentMenu.itemRenderer;
      }
      
      [Inspectable(environment="none")]
      override public function get horizontalScrollPolicy() : String
      {
         return ScrollPolicy.OFF;
      }
      
      override public function set horizontalScrollPolicy(value:String) : void
      {
      }
      
      [Inspectable(environment="none")]
      override public function get verticalScrollPolicy() : String
      {
         return ScrollPolicy.OFF;
      }
      
      override public function set verticalScrollPolicy(value:String) : void
      {
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
         var tmpCollection:ICollectionView = null;
         var rootItem:* = undefined;
         if(this.showRootChanged)
         {
            if(!this._hasRoot)
            {
               this.showRootChanged = false;
            }
         }
         if(this.dataProviderChanged || this.showRootChanged)
         {
            this.dataProviderChanged = false;
            this.showRootChanged = false;
            if(Boolean(this._rootModel) && Boolean(!this._showRoot) && this._hasRoot)
            {
               rootItem = this._rootModel.createCursor().current;
               if(rootItem != null && Boolean(this._dataDescriptor.isBranch(rootItem,this._rootModel)) && Boolean(this._dataDescriptor.hasChildren(rootItem,this._rootModel)))
               {
                  tmpCollection = this._dataDescriptor.getChildren(rootItem,this._rootModel);
               }
            }
            if(Boolean(this._listDataProvider))
            {
               this._listDataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.collectionChangeHandler,false);
            }
            if(Boolean(this._rootModel))
            {
               if(!tmpCollection)
               {
                  tmpCollection = this._rootModel;
               }
               this._listDataProvider = tmpCollection;
               super.dataProvider = tmpCollection;
               this._listDataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.collectionChangeHandler,false,EventPriority.DEFAULT_HANDLER,true);
            }
            else
            {
               this._listDataProvider = null;
               super.dataProvider = null;
            }
         }
         super.commitProperties();
      }
      
      override protected function measure() : void
      {
         var vm:EdgeMetrics = null;
         var requiredHeight:int = 0;
         super.measure();
         if(!this.dataProvider || this.dataProvider.length == 0)
         {
            measuredWidth = 0;
            measuredHeight = 0;
         }
         else
         {
            vm = viewMetrics;
            measuredMinWidth = measuredWidth = this.measureWidthOfItems(0,this.dataProvider.length);
            if(variableRowHeight)
            {
               requiredHeight = measureHeightOfItems(0,this.dataProvider.length);
            }
            else
            {
               requiredHeight = this.dataProvider.length * rowHeight;
            }
            measuredMinHeight = measuredHeight = requiredHeight + vm.top + vm.bottom;
         }
      }
      
      override public function measureWidthOfItems(index:int = -1, count:int = 0) : Number
      {
         var placeHolder:CursorBookmark = null;
         var previousCount:int = 0;
         var i:int = 0;
         var valuesChanged:Boolean = false;
         var data:Object = null;
         var menuListData:MenuListData = null;
         var item:IListItemRenderer = null;
         var menuItemRenderer:IMenuItemRenderer = null;
         var w:Number = 0;
         var minimumLeftMargin:Number = Number(getStyle("leftIconGap"));
         var minimumRightMargin:Number = Number(getStyle("rightIconGap"));
         this.maxMeasuredIconWidth = 0;
         this.maxMeasuredTypeIconWidth = 0;
         this.maxMeasuredBranchIconWidth = 0;
         this.useTwoColumns = false;
         if(Boolean(collection) && Boolean(collection.length))
         {
            placeHolder = iterator.bookmark;
            previousCount = count;
            for(i = 0; i < 2; i++)
            {
               iterator.seek(CursorBookmark.FIRST,index);
               count = previousCount;
               valuesChanged = false;
               while(Boolean(count))
               {
                  data = iterator.current;
                  item = this.hiddenItem = getMeasuringRenderer(data);
                  item.explicitWidth = NaN;
                  setupRendererFromData(item,data);
                  w = Math.max(item.getExplicitOrMeasuredWidth(),w);
                  if(item is IMenuItemRenderer)
                  {
                     menuItemRenderer = IMenuItemRenderer(item);
                     if(menuItemRenderer.measuredIconWidth > this.maxMeasuredIconWidth)
                     {
                        this.maxMeasuredIconWidth = menuItemRenderer.measuredIconWidth;
                        valuesChanged = true;
                     }
                     if(menuItemRenderer.measuredTypeIconWidth > this.maxMeasuredTypeIconWidth)
                     {
                        this.maxMeasuredTypeIconWidth = menuItemRenderer.measuredTypeIconWidth;
                        valuesChanged = true;
                     }
                     if(menuItemRenderer.measuredBranchIconWidth > this.maxMeasuredBranchIconWidth)
                     {
                        this.maxMeasuredBranchIconWidth = menuItemRenderer.measuredBranchIconWidth;
                        valuesChanged = true;
                     }
                     if(menuItemRenderer.measuredIconWidth > 0 && Boolean(menuItemRenderer.measuredTypeIconWidth))
                     {
                        this.useTwoColumns = true;
                        valuesChanged = true;
                     }
                  }
                  count--;
                  if(!iterator.moveNext())
                  {
                     break;
                  }
               }
               if(i == 0)
               {
                  if(!(valuesChanged && (this.maxMeasuredIconWidth + this.maxMeasuredTypeIconWidth > minimumLeftMargin || this.maxMeasuredBranchIconWidth > minimumRightMargin)))
                  {
                     break;
                  }
               }
            }
            iterator.seek(placeHolder,0);
         }
         if(!w)
         {
            w = 200;
         }
         return w + (getStyle("paddingLeft") + getStyle("paddingRight"));
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         border.move(0,0);
         border.visible = this.dataProvider != null && this.dataProvider.length > 0;
         if(Boolean(this.hiddenItem))
         {
            this.hiddenItem.setActualSize(unscaledWidth,this.hiddenItem.getExplicitOrMeasuredHeight());
         }
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         super.styleChanged(styleProp);
         this.deleteDependentSubMenus();
      }
      
      override protected function drawItem(item:IListItemRenderer, selected:Boolean = false, highlighted:Boolean = false, caret:Boolean = false, transition:Boolean = false) : void
      {
         if(!getStyle("useRollOver"))
         {
            super.drawItem(item,selected,false,false,transition);
         }
         else
         {
            super.drawItem(item,selected,highlighted,caret,transition);
         }
      }
      
      override protected function configureScrollBars() : void
      {
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function clearHighlight(item:IListItemRenderer) : void
      {
         var menuEvent:MenuEvent = null;
         var uid:String = itemToUID(item.data);
         this.drawItem(visibleData[uid],isItemSelected(item.data),false,uid == caretUID);
         var pt:Point = itemRendererToIndices(item);
         if(Boolean(pt))
         {
            menuEvent = new MenuEvent(MenuEvent.ITEM_ROLL_OUT);
            menuEvent.menu = this;
            menuEvent.index = this.getRowIndex(item);
            menuEvent.menuBar = this.sourceMenuBar;
            menuEvent.label = itemToLabel(item.data);
            menuEvent.item = item.data;
            menuEvent.itemRenderer = item;
            this.getRootMenu().dispatchEvent(menuEvent);
         }
      }
      
      override protected function mouseEventToItemRenderer(event:MouseEvent) : IListItemRenderer
      {
         var row:IListItemRenderer = super.mouseEventToItemRenderer(event);
         if(Boolean(row) && Boolean(row.data) && this._dataDescriptor.getType(row.data) == "separator")
         {
            return null;
         }
         return row;
      }
      
      override public function setFocus() : void
      {
         super.setFocus();
      }
      
      override protected function focusOutHandler(event:FocusEvent) : void
      {
         super.focusOutHandler(event);
         if(!this.supposedToLoseFocus)
         {
            this.hideAllMenus();
         }
         this.supposedToLoseFocus = false;
      }
      
      override public function dispatchEvent(event:Event) : Boolean
      {
         var me:MenuEvent = null;
         if(!(event is MenuEvent) && event is ListEvent && (event.type == ListEvent.ITEM_ROLL_OUT || event.type == ListEvent.ITEM_ROLL_OVER || event.type == ListEvent.CHANGE))
         {
            event.stopImmediatePropagation();
         }
         if(!(event is MenuEvent) && event is ListEvent && event.type == ListEvent.ITEM_CLICK)
         {
            me = new MenuEvent(event.type,event.bubbles,event.cancelable);
            me.item = ListEvent(event).itemRenderer.data;
            me.label = itemToLabel(ListEvent(event).itemRenderer);
            return super.dispatchEvent(me);
         }
         return super.dispatchEvent(event);
      }
      
      protected function setMenuItemToggled(item:Object, toggle:Boolean) : void
      {
         var groupName:String = null;
         var i:int = 0;
         var row:IListItemRenderer = null;
         var rowItem:Object = null;
         itemsSizeChanged = true;
         invalidateDisplayList();
         if(this._dataDescriptor.getType(item) == "radio")
         {
            groupName = this._dataDescriptor.getGroupName(item);
            for(i = 0; i < listItems.length; i++)
            {
               row = listItems[i][0];
               rowItem = row.data;
               if(this._dataDescriptor.getType(rowItem) == "radio" && this._dataDescriptor.getGroupName(rowItem) == groupName)
               {
                  this._dataDescriptor.setToggled(rowItem,rowItem == item);
               }
            }
         }
         if(toggle != this._dataDescriptor.isToggled(item))
         {
            this._dataDescriptor.setToggled(item,toggle);
         }
      }
      
      override protected function makeListData(data:Object, uid:String, rowNum:int) : BaseListData
      {
         var menuListData:MenuListData = new MenuListData(itemToLabel(data),itemToIcon(data),labelField,uid,this,rowNum);
         menuListData.maxMeasuredIconWidth = this.maxMeasuredIconWidth;
         menuListData.maxMeasuredTypeIconWidth = this.maxMeasuredTypeIconWidth;
         menuListData.maxMeasuredBranchIconWidth = this.maxMeasuredBranchIconWidth;
         menuListData.useTwoColumns = this.useTwoColumns;
         return menuListData;
      }
      
      public function show(xShow:Object = null, yShow:Object = null) : void
      {
         var screen:Rectangle = null;
         var pt:Point = null;
         var shift:Number = NaN;
         if(Boolean(collection) && collection.length == 0)
         {
            return;
         }
         if(Boolean(this.parentMenu) && !this.parentMenu.visible)
         {
            return;
         }
         if(visible)
         {
            return;
         }
         if(Boolean(this.parentDisplayObject) && (!parent || !parent.contains(this.parentDisplayObject)))
         {
            PopUpManager.addPopUp(this,this.parentDisplayObject,false);
            addEventListener(MenuEvent.MENU_HIDE,menuHideHandler,false,EventPriority.DEFAULT_HANDLER);
         }
         var menuEvent:MenuEvent = new MenuEvent(MenuEvent.MENU_SHOW);
         menuEvent.menu = this;
         menuEvent.menuBar = this.sourceMenuBar;
         this.getRootMenu().dispatchEvent(menuEvent);
         var awm:IActiveWindowManager = IActiveWindowManager(systemManager.getImplementation("mx.managers::IActiveWindowManager"));
         awm.activate(this);
         if(xShow !== null && !isNaN(Number(xShow)))
         {
            x = Number(xShow);
         }
         if(yShow !== null && !isNaN(Number(yShow)))
         {
            y = Number(yShow);
         }
         var sm:ISystemManager = systemManager.topLevelSystemManager;
         var sbRoot:DisplayObject = sm.getSandboxRoot();
         if(this != this.getRootMenu())
         {
            pt = new Point(x,y);
            pt = sbRoot.localToGlobal(pt);
            screen = sm.getVisibleApplicationRect(null,true);
            shift = pt.x + width - screen.right;
            if(shift > 0)
            {
               x = Math.max(x - shift,0);
            }
            shift = pt.y + height - screen.bottom;
            if(shift > 0)
            {
               y = Math.max(y - shift,0);
            }
         }
         UIComponentGlobals.layoutManager.validateClient(this,true);
         setActualSize(getExplicitOrMeasuredWidth(),getExplicitOrMeasuredHeight());
         cacheAsBitmap = true;
         var duration:Number = Number(getStyle("openDuration"));
         if(duration != 0)
         {
            scrollRect = new Rectangle(0,0,unscaledWidth,0);
            visible = true;
            UIComponentGlobals.layoutManager.validateNow();
            UIComponent.suspendBackgroundProcessing();
            this.popupTween = new Tween(this,[0,0],[unscaledWidth,unscaledHeight],duration);
         }
         else
         {
            UIComponentGlobals.layoutManager.validateNow();
            visible = true;
         }
         focusManager.setFocus(this);
         this.supposedToLoseFocus = true;
         sbRoot.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownOutsideHandler,false,0,true);
         addEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE,this.mouseDownOutsideHandler,false,0,true);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function onTweenUpdate(value:Object) : void
      {
         scrollRect = new Rectangle(0,0,value[0],value[1]);
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function onTweenEnd(value:Object) : void
      {
         UIComponent.resumeBackgroundProcessing();
         scrollRect = null;
         this.popupTween = null;
      }
      
      public function hide() : void
      {
         var sbRoot:DisplayObject = null;
         var menuEvent:MenuEvent = null;
         if(visible)
         {
            if(Boolean(this.popupTween))
            {
               this.popupTween.endTween();
            }
            clearSelected();
            if(Boolean(this.anchorRow))
            {
               this.drawItem(this.anchorRow,false,false);
               this.anchorRow = null;
            }
            visible = false;
            sbRoot = systemManager.getSandboxRoot();
            sbRoot.removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownOutsideHandler);
            removeEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE,this.mouseDownOutsideHandler);
            menuEvent = new MenuEvent(MenuEvent.MENU_HIDE);
            menuEvent.menu = this;
            menuEvent.menuBar = this.sourceMenuBar;
            this.getRootMenu().dispatchEvent(menuEvent);
         }
      }
      
      override protected function collectionChangeHandler(event:Event) : void
      {
         var ce:CollectionEvent = null;
         if(event is CollectionEvent)
         {
            ce = CollectionEvent(event);
            if(ce.kind == CollectionEventKind.ADD)
            {
               super.collectionChangeHandler(event);
               this.dataProviderChanged = true;
               invalidateProperties();
               invalidateSize();
               UIComponentGlobals.layoutManager.validateClient(this);
               setActualSize(getExplicitOrMeasuredWidth(),getExplicitOrMeasuredHeight());
            }
            else if(ce.kind == CollectionEventKind.REMOVE)
            {
               super.collectionChangeHandler(event);
               this.dataProviderChanged = true;
               invalidateProperties();
               invalidateSize();
               UIComponentGlobals.layoutManager.validateClient(this);
               setActualSize(getExplicitOrMeasuredWidth(),getExplicitOrMeasuredHeight());
            }
            else if(ce.kind == CollectionEventKind.REFRESH)
            {
               this.dataProviderChanged = true;
               invalidateProperties();
               invalidateSize();
            }
            else if(ce.kind == CollectionEventKind.RESET)
            {
               this.dataProviderChanged = true;
               invalidateProperties();
               invalidateSize();
            }
         }
         itemsSizeChanged = true;
         invalidateDisplayList();
      }
      
      private function mouseDownOutsideHandler(event:Event) : void
      {
         var mouseEvent:MouseEvent = null;
         if(event is MouseEvent)
         {
            mouseEvent = MouseEvent(event);
            if(!this.isMouseOverMenu(mouseEvent) && !this.isMouseOverMenuBarItem(mouseEvent))
            {
               this.hideAllMenus();
            }
         }
         else if(event is SandboxMouseEvent)
         {
            this.hideAllMenus();
         }
      }
      
      override protected function mouseUpHandler(event:MouseEvent) : void
      {
         var menuEvent:MenuEvent = null;
         var item:Object = null;
         var toggleItem:Boolean = false;
         if(!enabled || !selectable || !visible)
         {
            return;
         }
         super.mouseUpHandler(event);
         var row:IListItemRenderer = this.mouseEventToItemRenderer(event);
         if(Boolean(row) && Boolean(row.data))
         {
            item = row.data;
         }
         if(item != null && Boolean(this._dataDescriptor.isEnabled(item)) && !this._dataDescriptor.isBranch(item))
         {
            toggleItem = this._dataDescriptor.getType(item) != "radio" || !this._dataDescriptor.isToggled(item);
            if(toggleItem)
            {
               this.setMenuItemToggled(item,!this._dataDescriptor.isToggled(item));
            }
            menuEvent = new MenuEvent(MenuEvent.ITEM_CLICK);
            menuEvent.menu = this;
            menuEvent.index = this.selectedIndex;
            menuEvent.menuBar = this.sourceMenuBar;
            menuEvent.label = itemToLabel(item);
            menuEvent.item = item;
            menuEvent.itemRenderer = row;
            this.getRootMenu().dispatchEvent(menuEvent);
            if(toggleItem)
            {
               menuEvent = new MenuEvent(MenuEvent.CHANGE);
               menuEvent.menu = this;
               menuEvent.index = this.selectedIndex;
               menuEvent.menuBar = this.sourceMenuBar;
               menuEvent.label = itemToLabel(item);
               menuEvent.item = item;
               menuEvent.itemRenderer = row;
               this.getRootMenu().dispatchEvent(menuEvent);
            }
            this.hideAllMenus();
         }
      }
      
      override protected function mouseDownHandler(event:MouseEvent) : void
      {
         var item:Object = null;
         var row:IListItemRenderer = this.mouseEventToItemRenderer(event);
         if(Boolean(row) && Boolean(row.data))
         {
            item = row.data;
         }
         if(Boolean(item) && Boolean(this._dataDescriptor.isEnabled(item)) && !this._dataDescriptor.isBranch(item))
         {
            super.mouseDownHandler(event);
         }
      }
      
      override protected function mouseOutHandler(event:MouseEvent) : void
      {
         var item:Object = null;
         if(!enabled || !selectable || !visible)
         {
            return;
         }
         systemManager.removeEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler,true);
         var row:IListItemRenderer = this.mouseEventToItemRenderer(event);
         if(!row)
         {
            return;
         }
         if(Boolean(row) && Boolean(row.data))
         {
            item = row.data;
         }
         if(Boolean(this.openSubMenuTimer))
         {
            clearInterval(this.openSubMenuTimer);
            this.openSubMenuTimer = 0;
         }
         if(itemRendererContains(row,event.relatedObject) || itemRendererContains(row,DisplayObject(event.target)) || event.relatedObject == highlightIndicator || event.relatedObject == listContent || !highlightItemRenderer)
         {
            return;
         }
         if(Boolean(getStyle("useRollOver")) && Boolean(item))
         {
            this.clearHighlight(row);
         }
      }
      
      override protected function mouseOverHandler(event:MouseEvent) : void
      {
         var row:IListItemRenderer;
         var item:Object = null;
         var menuEvent:MenuEvent = null;
         if(!enabled || !selectable || !visible)
         {
            return;
         }
         systemManager.addEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler,true,0,true);
         row = this.mouseEventToItemRenderer(event);
         if(!row)
         {
            return;
         }
         if(Boolean(row) && Boolean(row.data))
         {
            item = row.data;
         }
         isPressed = event.buttonDown;
         if(Boolean(row) && row != this.anchorRow)
         {
            if(Boolean(this.anchorRow))
            {
               this.drawItem(this.anchorRow,false,false);
            }
            if(Boolean(this.subMenu))
            {
               this.subMenu.supposedToLoseFocus = true;
               this.subMenu.closeTimer = setTimeout(this.closeSubMenu,250,this.subMenu);
            }
            this.subMenu = null;
            this.anchorRow = null;
         }
         else if(Boolean(this.subMenu) && Boolean(this.subMenu.subMenu))
         {
            this.subMenu.subMenu.hide();
         }
         if(Boolean(this._dataDescriptor.isBranch(item)) && Boolean(this._dataDescriptor.isEnabled(item)))
         {
            this.anchorRow = row;
            if(Boolean(this.subMenu) && Boolean(this.subMenu.closeTimer))
            {
               clearInterval(this.subMenu.closeTimer);
               this.subMenu.closeTimer = 0;
            }
            if(!this.subMenu || !this.subMenu.visible)
            {
               if(Boolean(this.openSubMenuTimer))
               {
                  clearInterval(this.openSubMenuTimer);
               }
               this.openSubMenuTimer = setTimeout(function(row:IListItemRenderer):void
               {
                  openSubMenu(row);
               },250,row);
            }
         }
         if(Boolean(item) && Boolean(this._dataDescriptor.isEnabled(item)))
         {
            if(Boolean(event.relatedObject))
            {
               if(itemRendererContains(row,event.relatedObject) || row == lastHighlightItemRenderer || event.relatedObject == highlightIndicator)
               {
                  return;
               }
            }
         }
         if(Boolean(row))
         {
            this.drawItem(row,false,Boolean(item && this._dataDescriptor.isEnabled(item)));
            if(isPressed)
            {
               if(Boolean(item) && Boolean(this._dataDescriptor.isEnabled(item)))
               {
                  if(!this._dataDescriptor.isBranch(item))
                  {
                     selectItem(row,event.shiftKey,event.ctrlKey);
                  }
                  else
                  {
                     clearSelected();
                  }
               }
            }
            if(Boolean(item) && Boolean(this._dataDescriptor.isEnabled(item)))
            {
               menuEvent = new MenuEvent(MenuEvent.ITEM_ROLL_OVER);
               menuEvent.menu = this;
               menuEvent.index = this.getRowIndex(row);
               menuEvent.menuBar = this.sourceMenuBar;
               menuEvent.label = itemToLabel(item);
               menuEvent.item = item;
               menuEvent.itemRenderer = row;
               this.getRootMenu().dispatchEvent(menuEvent);
            }
         }
      }
      
      override protected function mouseClickHandler(event:MouseEvent) : void
      {
      }
      
      override protected function keyDownHandler(event:KeyboardEvent) : void
      {
         var menuEvent:MenuEvent = null;
         var row:IListItemRenderer = selectedIndex == -1 ? null : listItems[selectedIndex - verticalScrollPosition][0];
         var rowData:Object = Boolean(row) ? row.data : null;
         var menu:Menu = Boolean(row) ? IMenuItemRenderer(row).menu : null;
         var keyCode:uint = uint(mapKeycodeForLayoutDirection(event));
         if(keyCode == Keyboard.UP)
         {
            if(Boolean(rowData && this._dataDescriptor.isBranch(rowData)) && Boolean(menu) && Boolean(menu.visible))
            {
               this.supposedToLoseFocus = true;
               menu.setFocus();
               menu.moveSelBy(menu.dataProvider.length,-1);
            }
            else
            {
               this.moveSelBy(selectedIndex,-1);
            }
            event.stopPropagation();
         }
         else if(keyCode == Keyboard.DOWN)
         {
            if(Boolean(rowData && this._dataDescriptor.isBranch(rowData)) && Boolean(menu) && Boolean(menu.visible))
            {
               this.supposedToLoseFocus = true;
               menu.setFocus();
               menu.moveSelBy(-1,1);
            }
            else
            {
               this.moveSelBy(selectedIndex,1);
            }
            event.stopPropagation();
         }
         else if(keyCode == Keyboard.RIGHT)
         {
            if(Boolean(rowData) && Boolean(this._dataDescriptor.isBranch(rowData)))
            {
               this.openSubMenu(row);
               menu = IMenuItemRenderer(row).menu;
               this.supposedToLoseFocus = true;
               menu.setFocus();
               menu.moveSelBy(-1,1);
            }
            else if(Boolean(this.sourceMenuBar))
            {
               this.supposedToLoseFocus = true;
               this.sourceMenuBar.setFocus();
               this.sourceMenuBar.dispatchEvent(event);
            }
            event.stopPropagation();
         }
         else if(keyCode == Keyboard.LEFT)
         {
            if(Boolean(this._parentMenu))
            {
               this.supposedToLoseFocus = true;
               this.hide();
               this._parentMenu.setFocus();
            }
            else if(Boolean(this.sourceMenuBar))
            {
               this.supposedToLoseFocus = true;
               this.sourceMenuBar.setFocus();
               this.sourceMenuBar.dispatchEvent(event);
            }
            event.stopPropagation();
         }
         else if(keyCode == Keyboard.ENTER || keyCode == Keyboard.SPACE)
         {
            if(Boolean(rowData) && Boolean(this._dataDescriptor.isBranch(rowData)))
            {
               this.openSubMenu(row);
               menu = IMenuItemRenderer(row).menu;
               this.supposedToLoseFocus = true;
               menu.setFocus();
               menu.moveSelBy(-1,1);
            }
            else if(Boolean(rowData))
            {
               this.setMenuItemToggled(rowData,!this._dataDescriptor.isToggled(rowData));
               menuEvent = new MenuEvent(MenuEvent.ITEM_CLICK);
               menuEvent.menu = this;
               menuEvent.index = this.selectedIndex;
               menuEvent.menuBar = this.sourceMenuBar;
               menuEvent.label = itemToLabel(rowData);
               menuEvent.item = rowData;
               menuEvent.itemRenderer = row;
               this.getRootMenu().dispatchEvent(menuEvent);
               menuEvent = new MenuEvent(MenuEvent.CHANGE);
               menuEvent.menu = this;
               menuEvent.index = this.selectedIndex;
               menuEvent.menuBar = this.sourceMenuBar;
               menuEvent.label = itemToLabel(rowData);
               menuEvent.item = rowData;
               menuEvent.itemRenderer = row;
               this.getRootMenu().dispatchEvent(menuEvent);
               this.hideAllMenus();
            }
            event.stopPropagation();
         }
         else if(keyCode == Keyboard.TAB)
         {
            menuEvent = new MenuEvent(MenuEvent.MENU_HIDE);
            menuEvent.menu = this.getRootMenu();
            menuEvent.menuBar = this.sourceMenuBar;
            this.getRootMenu().dispatchEvent(menuEvent);
            this.hideAllMenus();
            event.stopPropagation();
         }
         else if(keyCode == Keyboard.ESCAPE)
         {
            if(Boolean(this._parentMenu))
            {
               this.supposedToLoseFocus = true;
               this.hide();
               this._parentMenu.setFocus();
            }
            else
            {
               menuEvent = new MenuEvent(MenuEvent.MENU_HIDE);
               menuEvent.menu = this.getRootMenu();
               menuEvent.menuBar = this.sourceMenuBar;
               this.getRootMenu().dispatchEvent(menuEvent);
               this.hideAllMenus();
               event.stopPropagation();
            }
         }
      }
      
      private function moveSelBy(oldIndex:Number, incr:Number) : void
      {
         var item:Object = null;
         var menuEvent:MenuEvent = null;
         var oldItem:Object = null;
         var curIndex:Number = oldIndex;
         if(isNaN(curIndex))
         {
            curIndex = -1;
         }
         var limit:Number = Math.max(0,Math.min(rowCount,collection.length) - 1);
         var newIndex:Number = curIndex;
         var curItem:int = 0;
         while(true)
         {
            newIndex += incr;
            if(curItem > limit)
            {
               break;
            }
            curItem++;
            if(newIndex > limit)
            {
               newIndex = 0;
            }
            else if(newIndex < 0)
            {
               newIndex = limit;
            }
            item = listItems[newIndex][0];
            if(!(Boolean(item.data) && (this._dataDescriptor.getType(item.data) == "separator" || !this._dataDescriptor.isEnabled(item.data))))
            {
               if(selectedIndex != -1)
               {
                  oldItem = listItems[selectedIndex][0];
                  menuEvent = new MenuEvent(MenuEvent.ITEM_ROLL_OUT);
                  menuEvent.menu = this;
                  menuEvent.index = this.selectedIndex;
                  menuEvent.menuBar = this.sourceMenuBar;
                  menuEvent.label = itemToLabel(oldItem.data);
                  menuEvent.item = oldItem.data;
                  menuEvent.itemRenderer = IListItemRenderer(oldItem);
                  this.getRootMenu().dispatchEvent(menuEvent);
               }
               if(Boolean(item.data))
               {
                  selectItem(listItems[newIndex - verticalScrollPosition][0],false,false);
                  menuEvent = new MenuEvent(MenuEvent.ITEM_ROLL_OVER);
                  menuEvent.menu = this;
                  menuEvent.index = this.selectedIndex;
                  menuEvent.menuBar = this.sourceMenuBar;
                  menuEvent.label = itemToLabel(item.data);
                  menuEvent.item = item.data;
                  menuEvent.itemRenderer = IListItemRenderer(item);
                  this.getRootMenu().dispatchEvent(menuEvent);
               }
               return;
            }
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function openSubMenu(row:IListItemRenderer) : void
      {
         var menu:Menu = null;
         var showX:Number = NaN;
         var shiftForParent:Number = NaN;
         this.supposedToLoseFocus = true;
         var r:Menu = this.getRootMenu();
         if(!IMenuItemRenderer(row).menu)
         {
            menu = new Menu();
            menu.parentMenu = this;
            menu.owner = this;
            menu.showRoot = this.showRoot;
            menu.dataDescriptor = r.dataDescriptor;
            menu.styleName = r;
            menu.labelField = r.labelField;
            menu.labelFunction = r.labelFunction;
            menu.iconField = r.iconField;
            menu.iconFunction = r.iconFunction;
            menu.itemRenderer = r.itemRenderer;
            menu.rowHeight = r.rowHeight;
            menu.scaleY = r.scaleY;
            menu.scaleX = r.scaleX;
            if(Boolean(row.data) && Boolean(this._dataDescriptor.isBranch(row.data)) && Boolean(this._dataDescriptor.hasChildren(row.data)))
            {
               menu.dataProvider = this._dataDescriptor.getChildren(row.data);
            }
            menu.sourceMenuBar = this.sourceMenuBar;
            menu.sourceMenuBarItem = this.sourceMenuBarItem;
            IMenuItemRenderer(row).menu = menu;
            PopUpManager.addPopUp(menu,r,false);
         }
         else
         {
            menu = IMenuItemRenderer(row).menu;
         }
         var _do:DisplayObject = DisplayObject(row);
         var sandBoxRootPoint:Point = new Point(0,0);
         sandBoxRootPoint = _do.localToGlobal(sandBoxRootPoint);
         if(Boolean(_do.root))
         {
            sandBoxRootPoint = _do.root.globalToLocal(sandBoxRootPoint);
         }
         var isLayoutMirrored:Boolean = layoutDirection == LayoutDirection.RTL;
         var menuWidth:Number = Number(menu.getExplicitOrMeasuredWidth());
         var menuItemWidth:Number = Number(row.width);
         var showY:Number = sandBoxRootPoint.y;
         if(!this.isDirectionLeft)
         {
            showX = sandBoxRootPoint.x + (isLayoutMirrored ? -menuItemWidth : menuItemWidth);
         }
         else
         {
            showX = sandBoxRootPoint.x + (isLayoutMirrored ? menuWidth : -menuWidth);
         }
         if(isLayoutMirrored)
         {
            showX -= menuWidth;
         }
         var screen:Rectangle = systemManager.getVisibleApplicationRect(null,true);
         var sbRoot:DisplayObject = systemManager.getSandboxRoot();
         var screenPoint:Point = sbRoot.localToGlobal(new Point(showX,showY));
         var shift:Number = screenPoint.x + menuWidth - screen.right;
         if(shift > 0 || screenPoint.x < screen.x)
         {
            shiftForParent = getExplicitOrMeasuredWidth() + menu.getExplicitOrMeasuredWidth();
            if(this.isDirectionLeft)
            {
               shiftForParent *= -1;
            }
            showX = Math.max(showX - shiftForParent,0);
            screenPoint = new Point(showX,showY);
            screenPoint = sbRoot.localToGlobal(screenPoint);
            shift = Math.max(0,screenPoint.x + width - screen.right);
            showX = Math.max(showX - shift,0);
         }
         menu.isDirectionLeft = isLayoutMirrored ? this.x <= showX : this.x > showX;
         shift = screenPoint.y + menu.getExplicitOrMeasuredHeight() - screen.bottom;
         if(shift > 0 || screenPoint.y < screen.y)
         {
            showY = Math.max(showY - shift,0);
         }
         menu.show(showX,showY);
         this.subMenu = menu;
         clearInterval(this.openSubMenuTimer);
         this.openSubMenuTimer = 0;
      }
      
      private function closeSubMenu(menu:Menu) : void
      {
         menu.hide();
         clearInterval(menu.closeTimer);
         menu.closeTimer = 0;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function deleteDependentSubMenus() : void
      {
         var subMenu:Menu = null;
         var n:int = int(listItems.length);
         for(var i:int = 0; i < n; i++)
         {
            if(Boolean(listItems[i][0]))
            {
               subMenu = IMenuItemRenderer(listItems[i][0]).menu;
               if(Boolean(subMenu))
               {
                  subMenu.deleteDependentSubMenus();
                  PopUpManager.removePopUp(subMenu);
                  IMenuItemRenderer(listItems[i][0]).menu = null;
               }
            }
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function hideAllMenus() : void
      {
         this.getRootMenu().hide();
         this.getRootMenu().deleteDependentSubMenus();
      }
      
      private function isMouseOverMenu(event:MouseEvent) : Boolean
      {
         var target:DisplayObject = DisplayObject(event.target);
         while(Boolean(target))
         {
            if(target is Menu)
            {
               return true;
            }
            target = target.parent;
         }
         return false;
      }
      
      private function isMouseOverMenuBarItem(event:MouseEvent) : Boolean
      {
         if(!this.sourceMenuBarItem)
         {
            return false;
         }
         var target:DisplayObject = DisplayObject(event.target);
         while(Boolean(target))
         {
            if(target == this.sourceMenuBarItem)
            {
               return true;
            }
            target = target.parent;
         }
         return false;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function getRootMenu() : Menu
      {
         var target:Menu = this;
         while(Boolean(target.parentMenu))
         {
            target = target.parentMenu;
         }
         return target;
      }
      
      private function getRowIndex(row:IListItemRenderer) : int
      {
         var item:IListItemRenderer = null;
         for(var i:int = 0; i < listItems.length; i++)
         {
            item = listItems[i][0];
            if(Boolean(item) && Boolean(item.data) && this._dataDescriptor.getType(item.data) != "separator")
            {
               if(item == row)
               {
                  return i;
               }
            }
         }
         return -1;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function get subMenus() : Array
      {
         var arr:Array = [];
         for(var i:int = 0; i < listItems.length; i++)
         {
            arr.push(listItems[i][0].menu);
         }
         return arr;
      }
   }
}

