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
   import mx.core.Application;
   import mx.core.ClassFactory;
   import mx.core.EdgeMetrics;
   import mx.core.EventPriority;
   import mx.core.ScrollPolicy;
   import mx.core.UIComponent;
   import mx.core.UIComponentGlobals;
   import mx.core.mx_internal;
   import mx.effects.Tween;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.events.FlexEvent;
   import mx.events.InterManagerRequest;
   import mx.events.ListEvent;
   import mx.events.MenuEvent;
   import mx.events.SandboxMouseEvent;
   import mx.managers.IFocusManagerContainer;
   import mx.managers.ISystemManager;
   import mx.managers.PopUpManager;
   
   use namespace mx_internal;
   
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
      
      mx_internal static var createAccessibilityImplementation:Function;
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      mx_internal var parentDisplayObject:DisplayObject;
      
      private var isDirectionLeft:Boolean = false;
      
      mx_internal var popupTween:Tween;
      
      mx_internal var closeTimer:int = 0;
      
      mx_internal var openSubMenuTimer:int = 0;
      
      mx_internal var showRootChanged:Boolean = false;
      
      mx_internal var sourceMenuBarItem:IMenuBarItemRenderer;
      
      mx_internal var _hasRoot:Boolean = false;
      
      mx_internal var dataProviderChanged:Boolean = false;
      
      private var maxMeasuredTypeIconWidth:Number = 0;
      
      mx_internal var sourceMenuBar:MenuBar;
      
      private var maxMeasuredBranchIconWidth:Number = 0;
      
      private var maxMeasuredIconWidth:Number = 0;
      
      private var subMenu:Menu;
      
      mx_internal var _parentMenu:Menu;
      
      mx_internal var _dataDescriptor:IMenuDataDescriptor = new DefaultDataDescriptor();
      
      private var hiddenItem:IListItemRenderer;
      
      mx_internal var _showRoot:Boolean = true;
      
      private var useTwoColumns:Boolean = false;
      
      mx_internal var supposedToLoseFocus:Boolean = false;
      
      private var anchorRow:IListItemRenderer;
      
      mx_internal var _rootModel:ICollectionView;
      
      mx_internal var _listDataProvider:ICollectionView;
      
      public function Menu()
      {
         super();
         itemRenderer = new ClassFactory(MenuItemRenderer);
         setRowHeight(19);
         iconField = "icon";
         visible = false;
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
      
      public static function popUpMenu(menu:Menu, parent:DisplayObjectContainer, mdp:Object) : void
      {
         menu.parentDisplayObject = Boolean(parent) ? parent : DisplayObject(Application.application);
         if(!mdp)
         {
            mdp = new XML();
         }
         menu.supposedToLoseFocus = true;
         menu.dataProvider = mdp;
      }
      
      public static function createMenu(parent:DisplayObjectContainer, mdp:Object, showRoot:Boolean = true) : Menu
      {
         var menu:Menu = null;
         menu = new Menu();
         menu.tabEnabled = false;
         menu.owner = DisplayObjectContainer(Application.application);
         menu.showRoot = showRoot;
         popUpMenu(menu,parent,mdp);
         return menu;
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
            if(!(Boolean(item.data) && (_dataDescriptor.getType(item.data) == "separator" || !_dataDescriptor.isEnabled(item.data))))
            {
               if(selectedIndex != -1)
               {
                  oldItem = listItems[selectedIndex][0];
                  menuEvent = new MenuEvent(MenuEvent.ITEM_ROLL_OUT);
                  menuEvent.menu = this;
                  menuEvent.index = this.selectedIndex;
                  menuEvent.menuBar = sourceMenuBar;
                  menuEvent.label = itemToLabel(oldItem.data);
                  menuEvent.item = oldItem.data;
                  menuEvent.itemRenderer = IListItemRenderer(oldItem);
                  getRootMenu().dispatchEvent(menuEvent);
               }
               if(Boolean(item.data))
               {
                  selectItem(listItems[newIndex - verticalScrollPosition][0],false,false);
                  menuEvent = new MenuEvent(MenuEvent.ITEM_ROLL_OVER);
                  menuEvent.menu = this;
                  menuEvent.index = this.selectedIndex;
                  menuEvent.menuBar = sourceMenuBar;
                  menuEvent.label = itemToLabel(item.data);
                  menuEvent.item = item.data;
                  menuEvent.itemRenderer = IListItemRenderer(item);
                  getRootMenu().dispatchEvent(menuEvent);
               }
               return;
            }
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
         var minimumLeftMargin:Number = getStyle("leftIconGap");
         var minimumRightMargin:Number = getStyle("rightIconGap");
         maxMeasuredIconWidth = 0;
         maxMeasuredTypeIconWidth = 0;
         maxMeasuredBranchIconWidth = 0;
         useTwoColumns = false;
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
                  item = hiddenItem = getMeasuringRenderer(data);
                  item.explicitWidth = NaN;
                  setupRendererFromData(item,data);
                  w = Math.max(item.getExplicitOrMeasuredWidth(),w);
                  if(item is IMenuItemRenderer)
                  {
                     menuItemRenderer = IMenuItemRenderer(item);
                     if(menuItemRenderer.measuredIconWidth > maxMeasuredIconWidth)
                     {
                        maxMeasuredIconWidth = menuItemRenderer.measuredIconWidth;
                        valuesChanged = true;
                     }
                     if(menuItemRenderer.measuredTypeIconWidth > maxMeasuredTypeIconWidth)
                     {
                        maxMeasuredTypeIconWidth = menuItemRenderer.measuredTypeIconWidth;
                        valuesChanged = true;
                     }
                     if(menuItemRenderer.measuredBranchIconWidth > maxMeasuredBranchIconWidth)
                     {
                        maxMeasuredBranchIconWidth = menuItemRenderer.measuredBranchIconWidth;
                        valuesChanged = true;
                     }
                     if(menuItemRenderer.measuredIconWidth > 0 && Boolean(menuItemRenderer.measuredTypeIconWidth))
                     {
                        useTwoColumns = true;
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
                  if(!(valuesChanged && (maxMeasuredIconWidth + maxMeasuredTypeIconWidth > minimumLeftMargin || maxMeasuredBranchIconWidth > minimumRightMargin)))
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
         var row:IListItemRenderer = mouseEventToItemRenderer(event);
         if(Boolean(row) && Boolean(row.data))
         {
            item = row.data;
         }
         if(item != null && _dataDescriptor.isEnabled(item) && !_dataDescriptor.isBranch(item))
         {
            toggleItem = _dataDescriptor.getType(item) != "radio" || !_dataDescriptor.isToggled(item);
            if(toggleItem)
            {
               setMenuItemToggled(item,!_dataDescriptor.isToggled(item));
            }
            menuEvent = new MenuEvent(MenuEvent.ITEM_CLICK);
            menuEvent.menu = this;
            menuEvent.index = this.selectedIndex;
            menuEvent.menuBar = sourceMenuBar;
            menuEvent.label = itemToLabel(item);
            menuEvent.item = item;
            menuEvent.itemRenderer = row;
            getRootMenu().dispatchEvent(menuEvent);
            if(toggleItem)
            {
               menuEvent = new MenuEvent(MenuEvent.CHANGE);
               menuEvent.menu = this;
               menuEvent.index = this.selectedIndex;
               menuEvent.menuBar = sourceMenuBar;
               menuEvent.label = itemToLabel(item);
               menuEvent.item = item;
               menuEvent.itemRenderer = row;
               getRootMenu().dispatchEvent(menuEvent);
            }
            hideAllMenus();
         }
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
      
      override protected function focusOutHandler(event:FocusEvent) : void
      {
         super.focusOutHandler(event);
         if(!supposedToLoseFocus)
         {
            hideAllMenus();
         }
         supposedToLoseFocus = false;
      }
      
      mx_internal function openSubMenu(row:IListItemRenderer) : void
      {
         var menu:Menu = null;
         var showX:Number = NaN;
         var shiftForParent:Number = NaN;
         supposedToLoseFocus = true;
         var r:Menu = getRootMenu();
         if(!IMenuItemRenderer(row).menu)
         {
            menu = new Menu();
            menu.parentMenu = this;
            menu.owner = this;
            menu.showRoot = showRoot;
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
            if(Boolean(row.data) && Boolean(_dataDescriptor.isBranch(row.data)) && _dataDescriptor.hasChildren(row.data))
            {
               menu.dataProvider = _dataDescriptor.getChildren(row.data);
            }
            menu.sourceMenuBar = sourceMenuBar;
            menu.sourceMenuBarItem = sourceMenuBarItem;
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
         var showY:Number = sandBoxRootPoint.y;
         if(!isDirectionLeft)
         {
            showX = sandBoxRootPoint.x + row.width;
         }
         else
         {
            showX = sandBoxRootPoint.x - menu.getExplicitOrMeasuredWidth();
         }
         var screen:Rectangle = systemManager.getVisibleApplicationRect();
         var sbRoot:DisplayObject = systemManager.getSandboxRoot();
         var screenPoint:Point = sbRoot.localToGlobal(new Point(showX,showY));
         var shift:Number = screenPoint.x + menu.getExplicitOrMeasuredWidth() - screen.right;
         if(shift > 0 || screenPoint.x < screen.x)
         {
            shiftForParent = getExplicitOrMeasuredWidth() + menu.getExplicitOrMeasuredWidth();
            if(isDirectionLeft)
            {
               shiftForParent *= -1;
            }
            showX = Math.max(showX - shiftForParent,0);
            screenPoint = new Point(showX,showY);
            screenPoint = sbRoot.localToGlobal(screenPoint);
            shift = Math.max(0,screenPoint.x + width - screen.right);
            showX = Math.max(showX - shift,0);
         }
         menu.isDirectionLeft = this.x > showX;
         shift = screenPoint.y + height - screen.bottom;
         if(shift > 0 || screenPoint.y < screen.y)
         {
            showY = Math.max(showY - shift,0);
         }
         menu.show(showX,showY);
         subMenu = menu;
         clearInterval(openSubMenuTimer);
         openSubMenuTimer = 0;
      }
      
      public function get parentMenu() : Menu
      {
         return _parentMenu;
      }
      
      private function parentRowHeightHandler(event:Event) : void
      {
         rowHeight = parentMenu.rowHeight;
      }
      
      mx_internal function hideAllMenus() : void
      {
         getRootMenu().hide();
         getRootMenu().deleteDependentSubMenus();
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
      
      mx_internal function deleteDependentSubMenus() : void
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
      
      public function hide() : void
      {
         var sbRoot:DisplayObject = null;
         var menuEvent:MenuEvent = null;
         if(visible)
         {
            if(Boolean(popupTween))
            {
               popupTween.endTween();
            }
            clearSelected();
            if(Boolean(anchorRow))
            {
               drawItem(anchorRow,false,false);
               anchorRow = null;
            }
            visible = false;
            sbRoot = systemManager.getSandboxRoot();
            sbRoot.removeEventListener(MouseEvent.MOUSE_DOWN,mouseDownOutsideHandler);
            removeEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE,mouseDownOutsideHandler);
            menuEvent = new MenuEvent(MenuEvent.MENU_HIDE);
            menuEvent.menu = this;
            menuEvent.menuBar = sourceMenuBar;
            getRootMenu().dispatchEvent(menuEvent);
         }
      }
      
      override public function set horizontalScrollPolicy(value:String) : void
      {
      }
      
      public function set parentMenu(value:Menu) : void
      {
         _parentMenu = value;
         value.addEventListener(FlexEvent.HIDE,parentHideHandler,false,0,true);
         value.addEventListener("rowHeightChanged",parentRowHeightHandler,false,0,true);
         value.addEventListener("iconFieldChanged",parentIconFieldHandler,false,0,true);
         value.addEventListener("iconFunctionChanged",parentIconFunctionHandler,false,0,true);
         value.addEventListener("labelFieldChanged",parentLabelFieldHandler,false,0,true);
         value.addEventListener("labelFunctionChanged",parentLabelFunctionHandler,false,0,true);
         value.addEventListener("itemRendererChanged",parentItemRendererHandler,false,0,true);
      }
      
      protected function setMenuItemToggled(item:Object, toggle:Boolean) : void
      {
         var groupName:String = null;
         var i:int = 0;
         var row:IListItemRenderer = null;
         var rowItem:Object = null;
         itemsSizeChanged = true;
         invalidateDisplayList();
         if(_dataDescriptor.getType(item) == "radio")
         {
            groupName = _dataDescriptor.getGroupName(item);
            for(i = 0; i < listItems.length; i++)
            {
               row = listItems[i][0];
               rowItem = row.data;
               if(_dataDescriptor.getType(rowItem) == "radio" && _dataDescriptor.getGroupName(rowItem) == groupName)
               {
                  _dataDescriptor.setToggled(rowItem,rowItem == item);
               }
            }
         }
         if(toggle != _dataDescriptor.isToggled(item))
         {
            _dataDescriptor.setToggled(item,toggle);
         }
      }
      
      override protected function measure() : void
      {
         var vm:EdgeMetrics = null;
         var requiredHeight:int = 0;
         super.measure();
         if(!dataProvider || dataProvider.length == 0)
         {
            measuredWidth = 0;
            measuredHeight = 0;
         }
         else
         {
            vm = viewMetrics;
            measuredMinWidth = measuredWidth = measureWidthOfItems(0,dataProvider.length);
            if(variableRowHeight)
            {
               requiredHeight = measureHeightOfItems(0,dataProvider.length);
            }
            else
            {
               requiredHeight = dataProvider.length * rowHeight;
            }
            measuredMinHeight = measuredHeight = requiredHeight + vm.top + vm.bottom;
         }
      }
      
      override protected function mouseDownHandler(event:MouseEvent) : void
      {
         var item:Object = null;
         var row:IListItemRenderer = mouseEventToItemRenderer(event);
         if(Boolean(row) && Boolean(row.data))
         {
            item = row.data;
         }
         if(Boolean(item) && Boolean(_dataDescriptor.isEnabled(item)) && !_dataDescriptor.isBranch(item))
         {
            super.mouseDownHandler(event);
         }
      }
      
      override protected function mouseEventToItemRenderer(event:MouseEvent) : IListItemRenderer
      {
         var row:IListItemRenderer = super.mouseEventToItemRenderer(event);
         if(Boolean(row) && Boolean(row.data) && _dataDescriptor.getType(row.data) == "separator")
         {
            return null;
         }
         return row;
      }
      
      override protected function keyDownHandler(event:KeyboardEvent) : void
      {
         var menuEvent:MenuEvent = null;
         var row:IListItemRenderer = selectedIndex == -1 ? null : listItems[selectedIndex - verticalScrollPosition][0];
         var rowData:Object = Boolean(row) ? row.data : null;
         var menu:Menu = Boolean(row) ? IMenuItemRenderer(row).menu : null;
         if(event.keyCode == Keyboard.UP)
         {
            if(Boolean(rowData && _dataDescriptor.isBranch(rowData)) && Boolean(menu) && menu.visible)
            {
               supposedToLoseFocus = true;
               menu.setFocus();
               menu.moveSelBy(menu.dataProvider.length,-1);
            }
            else
            {
               moveSelBy(selectedIndex,-1);
            }
            event.stopPropagation();
         }
         else if(event.keyCode == Keyboard.DOWN)
         {
            if(Boolean(rowData && _dataDescriptor.isBranch(rowData)) && Boolean(menu) && menu.visible)
            {
               supposedToLoseFocus = true;
               menu.setFocus();
               menu.moveSelBy(-1,1);
            }
            else
            {
               moveSelBy(selectedIndex,1);
            }
            event.stopPropagation();
         }
         else if(event.keyCode == Keyboard.RIGHT)
         {
            if(Boolean(rowData) && _dataDescriptor.isBranch(rowData))
            {
               openSubMenu(row);
               menu = IMenuItemRenderer(row).menu;
               supposedToLoseFocus = true;
               menu.setFocus();
               menu.moveSelBy(-1,1);
            }
            else if(Boolean(sourceMenuBar))
            {
               supposedToLoseFocus = true;
               sourceMenuBar.setFocus();
               sourceMenuBar.dispatchEvent(event);
            }
            event.stopPropagation();
         }
         else if(event.keyCode == Keyboard.LEFT)
         {
            if(Boolean(_parentMenu))
            {
               supposedToLoseFocus = true;
               hide();
               _parentMenu.setFocus();
            }
            else if(Boolean(sourceMenuBar))
            {
               supposedToLoseFocus = true;
               sourceMenuBar.setFocus();
               sourceMenuBar.dispatchEvent(event);
            }
            event.stopPropagation();
         }
         else if(event.keyCode == Keyboard.ENTER || event.keyCode == Keyboard.SPACE)
         {
            if(Boolean(rowData) && _dataDescriptor.isBranch(rowData))
            {
               openSubMenu(row);
               menu = IMenuItemRenderer(row).menu;
               supposedToLoseFocus = true;
               menu.setFocus();
               menu.moveSelBy(-1,1);
            }
            else if(Boolean(rowData))
            {
               setMenuItemToggled(rowData,!_dataDescriptor.isToggled(rowData));
               menuEvent = new MenuEvent(MenuEvent.ITEM_CLICK);
               menuEvent.menu = this;
               menuEvent.index = this.selectedIndex;
               menuEvent.menuBar = sourceMenuBar;
               menuEvent.label = itemToLabel(rowData);
               menuEvent.item = rowData;
               menuEvent.itemRenderer = row;
               getRootMenu().dispatchEvent(menuEvent);
               menuEvent = new MenuEvent(MenuEvent.CHANGE);
               menuEvent.menu = this;
               menuEvent.index = this.selectedIndex;
               menuEvent.menuBar = sourceMenuBar;
               menuEvent.label = itemToLabel(rowData);
               menuEvent.item = rowData;
               menuEvent.itemRenderer = row;
               getRootMenu().dispatchEvent(menuEvent);
               hideAllMenus();
            }
            event.stopPropagation();
         }
         else if(event.keyCode == Keyboard.TAB)
         {
            menuEvent = new MenuEvent(MenuEvent.MENU_HIDE);
            menuEvent.menu = getRootMenu();
            menuEvent.menuBar = sourceMenuBar;
            getRootMenu().dispatchEvent(menuEvent);
            hideAllMenus();
            event.stopPropagation();
         }
         else if(event.keyCode == Keyboard.ESCAPE)
         {
            if(Boolean(_parentMenu))
            {
               supposedToLoseFocus = true;
               hide();
               _parentMenu.setFocus();
            }
            else
            {
               menuEvent = new MenuEvent(MenuEvent.MENU_HIDE);
               menuEvent.menu = getRootMenu();
               menuEvent.menuBar = sourceMenuBar;
               getRootMenu().dispatchEvent(menuEvent);
               hideAllMenus();
               event.stopPropagation();
            }
         }
      }
      
      private function parentItemRendererHandler(event:Event) : void
      {
         itemRenderer = parentMenu.itemRenderer;
      }
      
      mx_internal function onTweenEnd(value:Object) : void
      {
         UIComponent.resumeBackgroundProcessing();
         scrollRect = null;
         popupTween = null;
      }
      
      public function set dataDescriptor(value:IMenuDataDescriptor) : void
      {
         _dataDescriptor = value;
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
            _hasRoot = true;
            xl = new XMLList();
            xl += value;
            _rootModel = new XMLListCollection(xl);
         }
         else if(value is ICollectionView)
         {
            _rootModel = ICollectionView(value);
            if(_rootModel.length == 1)
            {
               _hasRoot = true;
            }
         }
         else if(value is Array)
         {
            _rootModel = new ArrayCollection(value as Array);
         }
         else if(value is Object)
         {
            _hasRoot = true;
            tmp = [];
            tmp.push(value);
            _rootModel = new ArrayCollection(tmp);
         }
         else
         {
            _rootModel = new ArrayCollection();
         }
         dataProviderChanged = true;
         invalidateProperties();
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
      
      private function parentLabelFieldHandler(event:Event) : void
      {
         labelField = parentMenu.labelField;
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
               dataProviderChanged = true;
               invalidateProperties();
               invalidateSize();
               UIComponentGlobals.layoutManager.validateClient(this);
               setActualSize(getExplicitOrMeasuredWidth(),getExplicitOrMeasuredHeight());
            }
            else if(ce.kind == CollectionEventKind.REMOVE)
            {
               super.collectionChangeHandler(event);
               dataProviderChanged = true;
               invalidateProperties();
               invalidateSize();
               UIComponentGlobals.layoutManager.validateClient(this);
               setActualSize(getExplicitOrMeasuredWidth(),getExplicitOrMeasuredHeight());
            }
            else if(ce.kind == CollectionEventKind.REFRESH)
            {
               dataProviderChanged = true;
               invalidateProperties();
               invalidateSize();
            }
            else if(ce.kind == CollectionEventKind.RESET)
            {
               dataProviderChanged = true;
               invalidateProperties();
               invalidateSize();
            }
         }
         itemsSizeChanged = true;
         invalidateDisplayList();
      }
      
      override protected function makeListData(data:Object, uid:String, rowNum:int) : BaseListData
      {
         var menuListData:MenuListData = new MenuListData(itemToLabel(data),itemToIcon(data),labelField,uid,this,rowNum);
         menuListData.maxMeasuredIconWidth = maxMeasuredIconWidth;
         menuListData.maxMeasuredTypeIconWidth = maxMeasuredTypeIconWidth;
         menuListData.maxMeasuredBranchIconWidth = maxMeasuredBranchIconWidth;
         menuListData.useTwoColumns = useTwoColumns;
         return menuListData;
      }
      
      public function get showRoot() : Boolean
      {
         return _showRoot;
      }
      
      private function parentLabelFunctionHandler(event:Event) : void
      {
         labelFunction = parentMenu.labelFunction;
      }
      
      private function getRowIndex(row:IListItemRenderer) : int
      {
         var item:IListItemRenderer = null;
         for(var i:int = 0; i < listItems.length; i++)
         {
            item = listItems[i][0];
            if(Boolean(item) && Boolean(item.data) && _dataDescriptor.getType(item.data) != "separator")
            {
               if(item == row)
               {
                  return i;
               }
            }
         }
         return -1;
      }
      
      private function parentIconFunctionHandler(event:Event) : void
      {
         iconFunction = parentMenu.iconFunction;
      }
      
      mx_internal function get subMenus() : Array
      {
         var arr:Array = [];
         for(var i:int = 0; i < listItems.length; i++)
         {
            arr.push(listItems[i][0].menu);
         }
         return arr;
      }
      
      override public function setFocus() : void
      {
         super.setFocus();
      }
      
      public function get hasRoot() : Boolean
      {
         return _hasRoot;
      }
      
      private function parentHideHandler(event:FlexEvent) : void
      {
         visible = false;
      }
      
      override protected function initializeAccessibility() : void
      {
         if(createAccessibilityImplementation != null)
         {
            createAccessibilityImplementation(this);
         }
      }
      
      private function closeSubMenu(menu:Menu) : void
      {
         menu.hide();
         clearInterval(menu.closeTimer);
         menu.closeTimer = 0;
      }
      
      override protected function mouseOutHandler(event:MouseEvent) : void
      {
         var item:Object = null;
         if(!enabled || !selectable || !visible)
         {
            return;
         }
         systemManager.removeEventListener(MouseEvent.MOUSE_UP,mouseUpHandler,true);
         var row:IListItemRenderer = mouseEventToItemRenderer(event);
         if(!row)
         {
            return;
         }
         if(Boolean(row) && Boolean(row.data))
         {
            item = row.data;
         }
         if(Boolean(openSubMenuTimer))
         {
            clearInterval(openSubMenuTimer);
            openSubMenuTimer = 0;
         }
         if(itemRendererContains(row,event.relatedObject) || itemRendererContains(row,DisplayObject(event.target)) || event.relatedObject == highlightIndicator || event.relatedObject == listContent || !highlightItemRenderer)
         {
            return;
         }
         if(Boolean(getStyle("useRollOver")) && Boolean(item))
         {
            clearHighlight(row);
         }
      }
      
      [Inspectable(environment="none")]
      override public function get horizontalScrollPolicy() : String
      {
         return ScrollPolicy.OFF;
      }
      
      private function mouseDownOutsideHandler(event:Event) : void
      {
         var mouseEvent:MouseEvent = null;
         if(event is MouseEvent)
         {
            mouseEvent = MouseEvent(event);
            if(!isMouseOverMenu(mouseEvent) && !isMouseOverMenuBarItem(mouseEvent))
            {
               hideAllMenus();
            }
         }
         else if(event is SandboxMouseEvent)
         {
            hideAllMenus();
         }
      }
      
      override protected function configureScrollBars() : void
      {
      }
      
      public function get dataDescriptor() : IMenuDataDescriptor
      {
         return IMenuDataDescriptor(_dataDescriptor);
      }
      
      override public function get dataProvider() : Object
      {
         var model:* = super.dataProvider;
         if(model == null)
         {
            if(_rootModel != null)
            {
               return _rootModel;
            }
            return null;
         }
         return model;
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         super.styleChanged(styleProp);
         deleteDependentSubMenus();
      }
      
      mx_internal function onTweenUpdate(value:Object) : void
      {
         scrollRect = new Rectangle(0,0,value[0],value[1]);
      }
      
      override protected function commitProperties() : void
      {
         var tmpCollection:ICollectionView = null;
         var rootItem:* = undefined;
         if(showRootChanged)
         {
            if(!_hasRoot)
            {
               showRootChanged = false;
            }
         }
         if(dataProviderChanged || showRootChanged)
         {
            dataProviderChanged = false;
            showRootChanged = false;
            if(Boolean(_rootModel) && Boolean(!_showRoot) && _hasRoot)
            {
               rootItem = _rootModel.createCursor().current;
               if(rootItem != null && _dataDescriptor.isBranch(rootItem,_rootModel) && _dataDescriptor.hasChildren(rootItem,_rootModel))
               {
                  tmpCollection = _dataDescriptor.getChildren(rootItem,_rootModel);
               }
            }
            if(Boolean(_listDataProvider))
            {
               _listDataProvider.removeEventListener(CollectionEvent.COLLECTION_CHANGE,collectionChangeHandler,false);
            }
            if(Boolean(_rootModel))
            {
               if(!tmpCollection)
               {
                  tmpCollection = _rootModel;
               }
               _listDataProvider = tmpCollection;
               super.dataProvider = tmpCollection;
               _listDataProvider.addEventListener(CollectionEvent.COLLECTION_CHANGE,collectionChangeHandler,false,EventPriority.DEFAULT_HANDLER,true);
            }
            else
            {
               _listDataProvider = null;
               super.dataProvider = null;
            }
         }
         super.commitProperties();
      }
      
      private function parentIconFieldHandler(event:Event) : void
      {
         iconField = parentMenu.iconField;
      }
      
      mx_internal function getRootMenu() : Menu
      {
         var target:Menu = this;
         while(Boolean(target.parentMenu))
         {
            target = target.parentMenu;
         }
         return target;
      }
      
      override protected function mouseClickHandler(event:MouseEvent) : void
      {
      }
      
      override public function set verticalScrollPolicy(value:String) : void
      {
      }
      
      override mx_internal function clearHighlight(item:IListItemRenderer) : void
      {
         var menuEvent:MenuEvent = null;
         var uid:String = itemToUID(item.data);
         drawItem(visibleData[uid],isItemSelected(item.data),false,uid == caretUID);
         var pt:Point = itemRendererToIndices(item);
         if(Boolean(pt))
         {
            menuEvent = new MenuEvent(MenuEvent.ITEM_ROLL_OUT);
            menuEvent.menu = this;
            menuEvent.index = getRowIndex(item);
            menuEvent.menuBar = sourceMenuBar;
            menuEvent.label = itemToLabel(item.data);
            menuEvent.item = item.data;
            menuEvent.itemRenderer = item;
            getRootMenu().dispatchEvent(menuEvent);
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
         systemManager.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler,true,0,true);
         row = mouseEventToItemRenderer(event);
         if(!row)
         {
            return;
         }
         if(Boolean(row) && Boolean(row.data))
         {
            item = row.data;
         }
         isPressed = event.buttonDown;
         if(Boolean(row) && row != anchorRow)
         {
            if(Boolean(anchorRow))
            {
               drawItem(anchorRow,false,false);
            }
            if(Boolean(subMenu))
            {
               subMenu.supposedToLoseFocus = true;
               subMenu.closeTimer = setTimeout(closeSubMenu,250,subMenu);
            }
            subMenu = null;
            anchorRow = null;
         }
         else if(Boolean(subMenu) && Boolean(subMenu.subMenu))
         {
            subMenu.subMenu.hide();
         }
         if(_dataDescriptor.isBranch(item) && _dataDescriptor.isEnabled(item))
         {
            anchorRow = row;
            if(Boolean(subMenu) && Boolean(subMenu.closeTimer))
            {
               clearInterval(subMenu.closeTimer);
               subMenu.closeTimer = 0;
            }
            if(!subMenu || !subMenu.visible)
            {
               if(Boolean(openSubMenuTimer))
               {
                  clearInterval(openSubMenuTimer);
               }
               openSubMenuTimer = setTimeout(function(row:IListItemRenderer):void
               {
                  openSubMenu(row);
               },250,row);
            }
         }
         if(Boolean(item) && _dataDescriptor.isEnabled(item))
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
            drawItem(row,false,Boolean(item && _dataDescriptor.isEnabled(item)));
            if(isPressed)
            {
               if(Boolean(item) && _dataDescriptor.isEnabled(item))
               {
                  if(!_dataDescriptor.isBranch(item))
                  {
                     selectItem(row,event.shiftKey,event.ctrlKey);
                  }
                  else
                  {
                     clearSelected();
                  }
               }
            }
            if(Boolean(item) && _dataDescriptor.isEnabled(item))
            {
               menuEvent = new MenuEvent(MenuEvent.ITEM_ROLL_OVER);
               menuEvent.menu = this;
               menuEvent.index = getRowIndex(row);
               menuEvent.menuBar = sourceMenuBar;
               menuEvent.label = itemToLabel(item);
               menuEvent.item = item;
               menuEvent.itemRenderer = row;
               getRootMenu().dispatchEvent(menuEvent);
            }
         }
      }
      
      [Inspectable(environment="none")]
      override public function get verticalScrollPolicy() : String
      {
         return ScrollPolicy.OFF;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         border.move(0,0);
         border.visible = dataProvider != null && dataProvider.length > 0;
         if(Boolean(hiddenItem))
         {
            hiddenItem.setActualSize(unscaledWidth,hiddenItem.getExplicitOrMeasuredHeight());
         }
      }
      
      private function isMouseOverMenuBarItem(event:MouseEvent) : Boolean
      {
         if(!sourceMenuBarItem)
         {
            return false;
         }
         var target:DisplayObject = DisplayObject(event.target);
         while(Boolean(target))
         {
            if(target == sourceMenuBarItem)
            {
               return true;
            }
            target = target.parent;
         }
         return false;
      }
      
      public function show(xShow:Object = null, yShow:Object = null) : void
      {
         var screen:Rectangle = null;
         var pt:Point = null;
         var shift:Number = NaN;
         var request:InterManagerRequest = null;
         if(Boolean(collection) && collection.length == 0)
         {
            return;
         }
         if(Boolean(parentMenu) && !parentMenu.visible)
         {
            return;
         }
         if(visible)
         {
            return;
         }
         if(Boolean(parentDisplayObject) && (!parent || !parent.contains(parentDisplayObject)))
         {
            PopUpManager.addPopUp(this,parentDisplayObject,false);
            addEventListener(MenuEvent.MENU_HIDE,menuHideHandler,false,EventPriority.DEFAULT_HANDLER);
         }
         var menuEvent:MenuEvent = new MenuEvent(MenuEvent.MENU_SHOW);
         menuEvent.menu = this;
         menuEvent.menuBar = sourceMenuBar;
         getRootMenu().dispatchEvent(menuEvent);
         systemManager.activate(this);
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
         if(this != getRootMenu())
         {
            pt = new Point(x,y);
            pt = sbRoot.localToGlobal(pt);
            if(sm != sbRoot)
            {
               request = new InterManagerRequest(InterManagerRequest.SYSTEM_MANAGER_REQUEST,false,false,"getVisibleApplicationRect");
               sbRoot.dispatchEvent(request);
               screen = Rectangle(request.value);
            }
            else
            {
               screen = sm.getVisibleApplicationRect();
            }
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
         var duration:Number = getStyle("openDuration");
         if(duration != 0)
         {
            scrollRect = new Rectangle(0,0,unscaledWidth,0);
            visible = true;
            UIComponentGlobals.layoutManager.validateNow();
            UIComponent.suspendBackgroundProcessing();
            popupTween = new Tween(this,[0,0],[unscaledWidth,unscaledHeight],duration);
         }
         else
         {
            UIComponentGlobals.layoutManager.validateNow();
            visible = true;
         }
         focusManager.setFocus(this);
         supposedToLoseFocus = true;
         sbRoot.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownOutsideHandler,false,0,true);
         addEventListener(SandboxMouseEvent.MOUSE_DOWN_SOMEWHERE,mouseDownOutsideHandler,false,0,true);
      }
      
      public function set showRoot(value:Boolean) : void
      {
         if(_showRoot != value)
         {
            _showRoot = value;
            showRootChanged = true;
            invalidateProperties();
         }
      }
   }
}

