package mx.controls
{
   import flash.display.DisplayObject;
   import flash.events.Event;
   import flash.events.FocusEvent;
   import flash.events.KeyboardEvent;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.ui.Keyboard;
   import flash.xml.XMLNode;
   import mx.collections.ArrayCollection;
   import mx.collections.ICollectionView;
   import mx.collections.IViewCursor;
   import mx.collections.XMLListCollection;
   import mx.collections.errors.ItemPendingError;
   import mx.containers.ApplicationControlBar;
   import mx.controls.menuClasses.IMenuBarItemRenderer;
   import mx.controls.menuClasses.IMenuDataDescriptor;
   import mx.controls.menuClasses.MenuBarItem;
   import mx.controls.treeClasses.DefaultDataDescriptor;
   import mx.core.ClassFactory;
   import mx.core.EventPriority;
   import mx.core.FlexVersion;
   import mx.core.IFactory;
   import mx.core.IFlexDisplayObject;
   import mx.core.IUIComponent;
   import mx.core.UIComponent;
   import mx.core.UIComponentGlobals;
   import mx.core.mx_internal;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.events.FlexEvent;
   import mx.events.InterManagerRequest;
   import mx.events.MenuEvent;
   import mx.managers.IFocusManagerComponent;
   import mx.managers.ISystemManager;
   import mx.managers.PopUpManager;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.ISimpleStyleClient;
   import mx.styles.StyleManager;
   import mx.styles.StyleProxy;
   
   use namespace mx_internal;
   
   [RequiresDataBinding("true")]
   [IconFile("MenuBar.png")]
   [DefaultTriggerEvent("change")]
   [DefaultProperty("dataProvider")]
   [DefaultBindingProperty(destination="dataProvider")]
   [AccessibilityClass(implementation="mx.accessibility.MenuBarAccImpl")]
   [Style(name="selectionColor",type="uint",format="Color",inherit="yes")]
   [Style(name="rollOverColor",type="uint",format="Color",inherit="yes")]
   [Style(name="menuStyleName",type="String",inherit="no")]
   [Style(name="itemDownSkin",type="Class",inherit="no")]
   [Style(name="itemOverSkin",type="Class",inherit="no")]
   [Style(name="itemUpSkin",type="Class",inherit="no")]
   [Style(name="itemSkin",type="Class",inherit="no",states="up, over, down")]
   [Style(name="backgroundSkin",type="Class",inherit="no")]
   [Style(name="backgroundColor",type="uint",format="Color",inherit="no",deprecatedReplacement="menuStyleName",deprecatedSince="3.0")]
   [Style(name="backgroundAlpha",type="Number",inherit="no",deprecatedReplacement="menuStyleName",deprecatedSince="3.0")]
   [Style(name="textIndent",type="Number",format="Length",inherit="yes")]
   [Style(name="textDecoration",type="String",enumeration="none,underline",inherit="yes")]
   [Style(name="textAlign",type="String",enumeration="left,center,right",inherit="yes")]
   [Style(name="letterSpacing",type="Number",inherit="yes")]
   [Style(name="kerning",type="Boolean",inherit="yes")]
   [Style(name="fontWeight",type="String",enumeration="normal,bold",inherit="yes")]
   [Style(name="fontThickness",type="Number",inherit="yes")]
   [Style(name="fontStyle",type="String",enumeration="normal,italic",inherit="yes")]
   [Style(name="fontSize",type="Number",format="Length",inherit="yes")]
   [Style(name="fontSharpness",type="Number",inherit="yes")]
   [Style(name="fontGridFitType",type="String",enumeration="none,pixel,subpixel",inherit="yes")]
   [Style(name="fontFamily",type="String",inherit="yes")]
   [Style(name="fontAntiAliasType",type="String",enumeration="normal,advanced",inherit="yes")]
   [Style(name="disabledColor",type="uint",format="Color",inherit="yes")]
   [Style(name="color",type="uint",format="Color",inherit="yes")]
   [Style(name="highlightAlphas",type="Array",arrayType="Number",inherit="no")]
   [Style(name="fillColors",type="Array",arrayType="uint",format="Color",inherit="no")]
   [Style(name="fillAlphas",type="Array",arrayType="Number",inherit="no")]
   [Style(name="cornerRadius",type="Number",format="Length",inherit="no")]
   [Style(name="borderColor",type="uint",format="Color",inherit="no")]
   [Style(name="leading",type="Number",format="Length",inherit="yes")]
   [Style(name="focusRoundedCorners",type="String",inherit="no")]
   [Style(name="focusAlpha",type="Number",inherit="no")]
   [Event(name="itemRollOver",type="mx.events.MenuEvent")]
   [Event(name="itemRollOut",type="mx.events.MenuEvent")]
   [Event(name="menuShow",type="mx.events.MenuEvent")]
   [Event(name="menuHide",type="mx.events.MenuEvent")]
   [Event(name="itemClick",type="mx.events.MenuEvent")]
   [Event(name="change",type="mx.events.MenuEvent")]
   public class MenuBar extends UIComponent implements IFocusManagerComponent
   {
      
      mx_internal static var createAccessibilityImplementation:Function;
      
      mx_internal static const VERSION:String = "3.5.0.12683";
      
      private static const MARGIN_WIDTH:int = 10;
      
      private static var _menuBarItemStyleFilters:Object = null;
      
      private var dataProviderChanged:Boolean = false;
      
      public var menus:Array = [];
      
      private var _labelField:String = "label";
      
      private var menuBarItemRendererChanged:Boolean = false;
      
      private var _menuBarItemRenderer:IFactory;
      
      private var openMenuIndex:int = -1;
      
      public var menuBarItems:Array = [];
      
      private var _iconField:String = "icon";
      
      private var background:IFlexDisplayObject;
      
      mx_internal var showRootChanged:Boolean = false;
      
      private var inKeyDown:Boolean = false;
      
      private var isInsideACB:Boolean = false;
      
      mx_internal var _hasRoot:Boolean = false;
      
      mx_internal var _showRoot:Boolean = true;
      
      private var supposedToLoseFocus:Boolean = false;
      
      mx_internal var _dataDescriptor:IMenuDataDescriptor = new DefaultDataDescriptor();
      
      mx_internal var _rootModel:ICollectionView;
      
      [Inspectable(category="Data")]
      public var labelFunction:Function;
      
      private var iconFieldChanged:Boolean = false;
      
      private var isDown:Boolean;
      
      public function MenuBar()
      {
         super();
         menuBarItemRenderer = new ClassFactory(MenuBarItem);
         tabChildren = false;
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
      
      [Inspectable(category="Other",defaultValue="icon")]
      [Bindable("iconFieldChanged")]
      public function get iconField() : String
      {
         return _iconField;
      }
      
      [Inspectable(category="General",enumeration="true,false",defaultValue="true")]
      override public function set enabled(value:Boolean) : void
      {
         var n:int = 0;
         var i:int = 0;
         super.enabled = value;
         if(Boolean(menuBarItems))
         {
            n = int(menuBarItems.length);
            for(i = 0; i < n; i++)
            {
               menuBarItems[i].enabled = value;
            }
         }
      }
      
      [Inspectable(category="Data",enumeration="true,false",defaultValue="false")]
      public function get showRoot() : Boolean
      {
         return _showRoot;
      }
      
      override public function set showInAutomationHierarchy(value:Boolean) : void
      {
      }
      
      private function removeAll() : void
      {
         var item:IMenuBarItemRenderer = null;
         if(dataProviderChanged)
         {
            commitProperties();
         }
         while(menuBarItems.length > 0)
         {
            item = menuBarItems[0];
            removeChild(DisplayObject(item));
            menuBarItems.splice(0,1);
         }
         menus = [];
         invalidateSize();
         invalidateDisplayList();
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var item:IMenuBarItemRenderer = null;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var lastX:Number = MARGIN_WIDTH;
         var lastW:Number = 0;
         var len:int = int(menuBarItems.length);
         var clipContent:Boolean = false;
         var hideItems:Boolean = unscaledWidth == 0 || unscaledHeight == 0;
         for(var i:int = 0; i < len; i++)
         {
            item = menuBarItems[i];
            item.setActualSize(item.getExplicitOrMeasuredWidth(),unscaledHeight);
            item.visible = !hideItems;
            lastX = Number(item.x = lastX + lastW);
            lastW = Number(item.width);
            if(!hideItems && (item.getExplicitOrMeasuredHeight() > unscaledHeight || lastX + lastW > unscaledWidth))
            {
               clipContent = true;
            }
         }
         if(Boolean(background))
         {
            background.setActualSize(unscaledWidth,unscaledHeight);
            background.visible = !hideItems;
         }
         scrollRect = clipContent ? new Rectangle(0,0,unscaledWidth,unscaledHeight) : null;
      }
      
      override public function get baselinePosition() : Number
      {
         if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)
         {
            return super.baselinePosition;
         }
         if(!validateBaselinePosition())
         {
            return NaN;
         }
         if(menuBarItems.length == 0)
         {
            return super.baselinePosition;
         }
         var menuBarItem0:IUIComponent = menuBarItems[0] as IUIComponent;
         if(!menuBarItem0)
         {
            return super.baselinePosition;
         }
         validateNow();
         return menuBarItem0.y + menuBarItem0.baselinePosition;
      }
      
      protected function get menuBarItemStyleFilters() : Object
      {
         return _menuBarItemStyleFilters;
      }
      
      public function set iconField(value:String) : void
      {
         if(_iconField != value)
         {
            iconFieldChanged = true;
            _iconField = value;
            invalidateProperties();
            dispatchEvent(new Event("iconFieldChanged"));
         }
      }
      
      public function set menuBarItemRenderer(value:IFactory) : void
      {
         if(_menuBarItemRenderer != value)
         {
            _menuBarItemRenderer = value;
            menuBarItemRendererChanged = true;
            invalidateProperties();
            dispatchEvent(new Event("menuBarItemRendererChanged"));
         }
      }
      
      public function get hasRoot() : Boolean
      {
         return _hasRoot;
      }
      
      override protected function initializeAccessibility() : void
      {
         if(MenuBar.createAccessibilityImplementation != null)
         {
            MenuBar.createAccessibilityImplementation(this);
         }
      }
      
      public function itemToIcon(data:Object) : Class
      {
         var iconClass:Class = null;
         var icon:* = undefined;
         if(data == null)
         {
            return null;
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
      
      private function addMenuAt(index:int, arg1:Object, arg2:Object = null) : void
      {
         var newMenu:Menu = null;
         var mdp:Object = null;
         if(!dataProvider)
         {
            dataProvider = {};
         }
         var newItem:Object = arg1;
         insertMenuBarItem(index,mdp);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         for(var p:Object = parent; Boolean(p); p = p.parent)
         {
            if(p is ApplicationControlBar)
            {
               isInsideACB = true;
               break;
            }
         }
         updateBackground();
      }
      
      override protected function focusOutHandler(event:FocusEvent) : void
      {
         super.focusOutHandler(event);
         if(supposedToLoseFocus)
         {
            getMenuAt(openMenuIndex).hide();
         }
         supposedToLoseFocus = false;
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
         else if(data is String)
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
      
      private function mouseOutHandler(event:MouseEvent) : void
      {
         var menuEvent:MenuEvent = null;
         var item:IMenuBarItemRenderer = IMenuBarItemRenderer(event.target);
         var index:int = item.menuBarItemIndex;
         var m:Menu = getMenuAt(index);
         if(Boolean(item.enabled) && openMenuIndex != index)
         {
            menuBarItems[index].menuBarItemState = "itemUpSkin";
         }
         if(Boolean(item.data) && m.dataDescriptor.getType(item.data) != "separator")
         {
            menuEvent = new MenuEvent(MenuEvent.ITEM_ROLL_OUT);
            menuEvent.index = index;
            menuEvent.menuBar = this;
            menuEvent.label = itemToLabel(item.data);
            menuEvent.item = item.data;
            menuEvent.itemRenderer = item;
            dispatchEvent(menuEvent);
         }
      }
      
      private function collectionChangeHandler(event:Event) : void
      {
         var ce:CollectionEvent = null;
         if(event is CollectionEvent)
         {
            ce = CollectionEvent(event);
            if(ce.kind == CollectionEventKind.ADD)
            {
               dataProviderChanged = true;
               invalidateProperties();
            }
            else if(ce.kind == CollectionEventKind.REMOVE)
            {
               dataProviderChanged = true;
               invalidateProperties();
            }
            else if(ce.kind == CollectionEventKind.REFRESH)
            {
               dataProviderChanged = true;
               dataProvider = dataProvider;
               invalidateProperties();
               invalidateSize();
            }
            else if(ce.kind == CollectionEventKind.RESET)
            {
               dataProviderChanged = true;
               invalidateProperties();
               invalidateSize();
            }
            else if(ce.kind == CollectionEventKind.UPDATE)
            {
               if(openMenuIndex == -1)
               {
                  dataProviderChanged = true;
                  invalidateProperties();
               }
            }
         }
         invalidateDisplayList();
      }
      
      override public function notifyStyleChangeInChildren(styleProp:String, recursive:Boolean) : void
      {
         super.notifyStyleChangeInChildren(styleProp,recursive);
         var n:int = int(menuBarItems.length);
         for(var i:int = 0; i < n; i++)
         {
            getMenuAt(i).notifyStyleChangeInChildren(styleProp,recursive);
         }
      }
      
      private function mouseUpHandler(event:MouseEvent) : void
      {
         var item:IMenuBarItemRenderer = IMenuBarItemRenderer(event.target);
         var index:int = item.menuBarItemIndex;
         if(Boolean(item.enabled) && !isDown)
         {
            getMenuAt(index).hideAllMenus();
            item.menuBarItemState = "itemOverSkin";
         }
      }
      
      private function mouseDownHandler(event:MouseEvent) : void
      {
         var dp:ICollectionView = null;
         var evt:MenuEvent = null;
         var menuEvent:MenuEvent = null;
         var item:IMenuBarItemRenderer = IMenuBarItemRenderer(event.target);
         var index:int = item.menuBarItemIndex;
         var m:Menu = getMenuAt(index);
         if(item.enabled)
         {
            item.menuBarItemState = "itemDownSkin";
            if(!isDown)
            {
               m.supposedToLoseFocus = true;
               dp = ICollectionView(m.dataProvider);
               if(m.dataDescriptor.isBranch(item.data,item.data) && m.dataDescriptor.hasChildren(item.data,item.data))
               {
                  showMenu(index);
               }
               else if(Boolean(m))
               {
                  selectedIndex = index;
                  evt = new MenuEvent(MenuEvent.MENU_SHOW);
                  evt.menuBar = this;
                  evt.menu = m;
                  dispatchEvent(evt);
               }
               isDown = true;
            }
            else
            {
               isDown = false;
            }
            if(m.dataDescriptor.getType(item.data) != "separator")
            {
               menuEvent = new MenuEvent(MenuEvent.CHANGE);
               menuEvent.index = index;
               menuEvent.menuBar = this;
               menuEvent.label = itemToLabel(item.data);
               menuEvent.item = item.data;
               menuEvent.itemRenderer = item;
               dispatchEvent(menuEvent);
            }
         }
      }
      
      [Inspectable(category="Data")]
      public function get dataDescriptor() : IMenuDataDescriptor
      {
         return IMenuDataDescriptor(_dataDescriptor);
      }
      
      [Inspectable(category="Data")]
      [Bindable("collectionChange")]
      public function get dataProvider() : Object
      {
         if(Boolean(_rootModel))
         {
            return _rootModel;
         }
         return null;
      }
      
      private function showMenu(index:Number) : void
      {
         var screen:Rectangle = null;
         var request:InterManagerRequest = null;
         selectedIndex = index;
         var item:IMenuBarItemRenderer = menuBarItems[index];
         var menu:Menu = getMenuAt(index);
         var sm:ISystemManager = systemManager.topLevelSystemManager;
         var sbRoot:DisplayObject = sm.getSandboxRoot();
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
         if(Boolean(menu.parentDisplayObject) && (!menu.parent || !menu.parent.contains(menu.parentDisplayObject)))
         {
            PopUpManager.addPopUp(menu,this,false);
            menu.addEventListener(MenuEvent.MENU_HIDE,menuHideHandler,false,EventPriority.DEFAULT_HANDLER);
         }
         UIComponentGlobals.layoutManager.validateClient(menu,true);
         var pt:Point = new Point(0,0);
         pt = DisplayObject(item).localToGlobal(pt);
         if(pt.y + item.height + 1 + menu.getExplicitOrMeasuredHeight() > screen.height + screen.y)
         {
            pt.y -= menu.getExplicitOrMeasuredHeight();
         }
         else
         {
            pt.y += item.height + 1;
         }
         if(pt.x + menu.getExplicitOrMeasuredWidth() > screen.width + screen.x)
         {
            pt.x = screen.x + screen.width - menu.getExplicitOrMeasuredWidth();
         }
         pt = sbRoot.globalToLocal(pt);
         if(isInsideACB)
         {
            pt.y += 2;
         }
         menu.show(pt.x,pt.y);
      }
      
      [Inspectable(category="Data")]
      [Bindable("menuBarItemRendererChanged")]
      public function get menuBarItemRenderer() : IFactory
      {
         return _menuBarItemRenderer;
      }
      
      public function getMenuAt(index:int) : Menu
      {
         var menuStyleName:Object = null;
         var styleDecl:CSSStyleDeclaration = null;
         if(dataProviderChanged)
         {
            commitProperties();
         }
         var item:IMenuBarItemRenderer = menuBarItems[index];
         var mdp:Object = item.data;
         var menu:Menu = menus[index];
         if(menu == null)
         {
            menu = new Menu();
            menu.showRoot = false;
            if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)
            {
               menu.styleName = this;
            }
            menuStyleName = getStyle("menuStyleName");
            if(Boolean(menuStyleName))
            {
               if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)
               {
                  styleDecl = StyleManager.getStyleDeclaration("." + menuStyleName);
                  if(Boolean(styleDecl))
                  {
                     menu.styleDeclaration = styleDecl;
                  }
               }
               else
               {
                  menu.styleName = menuStyleName;
               }
            }
            menu.sourceMenuBar = this;
            menu.owner = this;
            menu.addEventListener("menuHide",eventHandler);
            menu.addEventListener("itemRollOver",eventHandler);
            menu.addEventListener("itemRollOut",eventHandler);
            menu.addEventListener("menuShow",eventHandler);
            menu.addEventListener("itemClick",eventHandler);
            menu.addEventListener("change",eventHandler);
            menu.iconField = _iconField;
            menu.labelField = _labelField;
            menu.labelFunction = labelFunction;
            menu.dataDescriptor = _dataDescriptor;
            menu.invalidateSize();
            menus[index] = menu;
            menu.sourceMenuBarItem = item;
            Menu.popUpMenu(menu,this,mdp);
         }
         return menu;
      }
      
      public function set labelField(value:String) : void
      {
         if(_labelField != value)
         {
            _labelField = value;
            dispatchEvent(new Event("labelFieldChanged"));
         }
      }
      
      override protected function commitProperties() : void
      {
         var i:int = 0;
         var cursor:IViewCursor = null;
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
            removeAll();
            if(Boolean(_rootModel))
            {
               if(!tmpCollection)
               {
                  tmpCollection = _rootModel;
               }
               tmpCollection.addEventListener(CollectionEvent.COLLECTION_CHANGE,collectionChangeHandler,false,EventPriority.DEFAULT_HANDLER,true);
               if(tmpCollection.length > 0)
               {
                  cursor = tmpCollection.createCursor();
                  i = 0;
                  while(!cursor.afterLast)
                  {
                     try
                     {
                        insertMenuBarItem(i,cursor.current);
                     }
                     catch(e:ItemPendingError)
                     {
                     }
                     cursor.moveNext();
                     i++;
                  }
               }
            }
         }
         if(iconFieldChanged || menuBarItemRendererChanged)
         {
            iconFieldChanged = false;
            menuBarItemRendererChanged = false;
            removeAll();
            if(Boolean(_rootModel))
            {
               if(!tmpCollection)
               {
                  tmpCollection = _rootModel;
               }
               if(tmpCollection.length > 0)
               {
                  cursor = tmpCollection.createCursor();
                  i = 0;
                  while(!cursor.afterLast)
                  {
                     try
                     {
                        insertMenuBarItem(i,cursor.current);
                     }
                     catch(e:ItemPendingError)
                     {
                     }
                     cursor.moveNext();
                     i++;
                  }
               }
            }
         }
         super.commitProperties();
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         var i:int = 0;
         var menuStyleName:String = null;
         var m:Menu = null;
         var styleDecl:CSSStyleDeclaration = null;
         super.styleChanged(styleProp);
         var n:int = int(menuBarItems.length);
         for(i = 0; i < n; i++)
         {
            getMenuAt(i).styleChanged(styleProp);
         }
         if(!styleProp || styleProp == "" || styleProp == "backgroundSkin")
         {
            updateBackground();
         }
         if(styleProp == null || styleProp == "styleName" || styleProp == "menuStyleName")
         {
            menuStyleName = getStyle("menuStyleName");
            if(Boolean(menuStyleName))
            {
               if(FlexVersion.compatibilityVersion < FlexVersion.VERSION_3_0)
               {
                  styleDecl = StyleManager.getStyleDeclaration("." + menuStyleName);
                  if(Boolean(styleDecl))
                  {
                     for(i = 0; i < menus.length; i++)
                     {
                        m = menus[i];
                        m.styleDeclaration = styleDecl;
                        m.regenerateStyleCache(true);
                     }
                  }
               }
               else
               {
                  for(i = 0; i < menus.length; i++)
                  {
                     m = menus[i];
                     m.styleName = menuStyleName;
                  }
               }
            }
         }
      }
      
      private function removeMenuBarItemAt(index:int) : void
      {
         if(dataProviderChanged)
         {
            commitProperties();
         }
         var item:IMenuBarItemRenderer = menuBarItems[index];
         if(Boolean(item))
         {
            removeChild(DisplayObject(item));
            menuBarItems.splice(index,1);
            invalidateSize();
            invalidateDisplayList();
         }
      }
      
      protected function updateBackground() : void
      {
         var backgroundSkinClass:Class = null;
         if(isInsideACB)
         {
            setStyle("translucent",true);
         }
         else
         {
            if(Boolean(background))
            {
               removeChild(DisplayObject(background));
               background = null;
            }
            backgroundSkinClass = getStyle("backgroundSkin");
            background = new backgroundSkinClass();
            if(background is ISimpleStyleClient)
            {
               ISimpleStyleClient(background).styleName = this;
            }
            addChildAt(DisplayObject(background),0);
         }
      }
      
      override protected function measure() : void
      {
         super.measure();
         var len:int = int(menuBarItems.length);
         measuredWidth = 0;
         measuredHeight = DEFAULT_MEASURED_MIN_HEIGHT;
         for(var i:int = 0; i < len; i++)
         {
            measuredWidth += menuBarItems[i].getExplicitOrMeasuredWidth();
            measuredHeight = Math.max(measuredHeight,menuBarItems[i].getExplicitOrMeasuredHeight());
         }
         if(len > 0)
         {
            measuredWidth += 2 * MARGIN_WIDTH;
         }
         else
         {
            measuredWidth = DEFAULT_MEASURED_MIN_WIDTH;
         }
         measuredMinWidth = measuredWidth;
         measuredMinHeight = measuredHeight;
      }
      
      override protected function keyDownHandler(event:KeyboardEvent) : void
      {
         var nextIndex:int = 0;
         var found:Boolean = false;
         var count:int = 0;
         var menu:Menu = null;
         var dp:ICollectionView = null;
         var item:IMenuBarItemRenderer = null;
         var barLen:int = int(menuBarItems.length);
         if(event.keyCode == Keyboard.RIGHT || event.keyCode == Keyboard.LEFT)
         {
            inKeyDown = true;
            nextIndex = openMenuIndex;
            found = false;
            count = 0;
            while(!found && count < barLen)
            {
               count++;
               nextIndex = event.keyCode == Keyboard.RIGHT ? int(nextIndex + 1) : int(nextIndex - 1);
               if(nextIndex >= barLen)
               {
                  nextIndex = 0;
               }
               else if(nextIndex < 0)
               {
                  nextIndex = barLen - 1;
               }
               if(Boolean(menuBarItems[nextIndex].enabled))
               {
                  found = true;
               }
            }
            if(count <= barLen && found)
            {
               menuBarItems[nextIndex].dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER));
            }
            event.stopPropagation();
         }
         if(event.keyCode == Keyboard.DOWN)
         {
            if(openMenuIndex != -1)
            {
               menu = getMenuAt(openMenuIndex);
               menu.selectedIndex = 0;
               supposedToLoseFocus = true;
               dp = ICollectionView(menu.dataProvider);
               item = menu.sourceMenuBarItem;
               if(menu.dataDescriptor.isBranch(item.data,item.data) && menu.dataDescriptor.hasChildren(item.data,item.data))
               {
                  menu.setFocus();
               }
            }
            event.stopPropagation();
         }
         if(event.keyCode == Keyboard.ENTER || event.keyCode == Keyboard.ESCAPE)
         {
            if(openMenuIndex != -1)
            {
               getMenuAt(openMenuIndex).hide();
            }
            event.stopPropagation();
         }
      }
      
      [Inspectable(category="Data",defaultValue="label")]
      [Bindable("labelFieldChanged")]
      public function get labelField() : String
      {
         return _labelField;
      }
      
      public function set selectedIndex(value:int) : void
      {
         openMenuIndex = value;
         dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
      }
      
      private function mouseOverHandler(event:MouseEvent) : void
      {
         var evt:MenuEvent = null;
         var oldIndex:Number = NaN;
         var dp:ICollectionView = null;
         var oldItem:IMenuBarItemRenderer = null;
         var mm:Menu = null;
         var item:IMenuBarItemRenderer = IMenuBarItemRenderer(event.target);
         var index:int = item.menuBarItemIndex;
         var requiresEvent:Boolean = false;
         var m:Menu = getMenuAt(index);
         if(item.enabled)
         {
            if(openMenuIndex != -1 || inKeyDown)
            {
               oldIndex = openMenuIndex;
               if(oldIndex != index)
               {
                  isDown = false;
                  if(oldIndex != -1)
                  {
                     oldItem = menuBarItems[oldIndex];
                     oldItem.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP));
                     oldItem.menuBarItemState = "itemUpSkin";
                     evt = new MenuEvent(MenuEvent.ITEM_ROLL_OUT);
                     evt.menuBar = this;
                     evt.index = oldIndex;
                     evt.label = itemToLabel(oldItem.data);
                     evt.item = oldItem.data;
                     evt.itemRenderer = oldItem;
                     dispatchEvent(evt);
                  }
                  item.menuBarItemState = "itemDownSkin";
                  dp = ICollectionView(m.dataProvider);
                  if(m.dataDescriptor.isBranch(item.data,item.data) && m.dataDescriptor.hasChildren(item.data,item.data))
                  {
                     showMenu(index);
                  }
                  else if(Boolean(m))
                  {
                     selectedIndex = index;
                     evt = new MenuEvent(MenuEvent.MENU_SHOW);
                     evt.menuBar = this;
                     evt.menu = m;
                     dispatchEvent(evt);
                     item.menuBarItemState = "itemOverSkin";
                  }
                  isDown = true;
                  if(m.dataDescriptor.getType(item.data) != "separator")
                  {
                     requiresEvent = true;
                     evt = new MenuEvent(MenuEvent.CHANGE);
                     evt.index = index;
                     evt.menuBar = this;
                     evt.label = itemToLabel(item.data);
                     evt.item = item.data;
                     evt.itemRenderer = item;
                     dispatchEvent(evt);
                  }
               }
               else
               {
                  mm = getMenuAt(index);
                  mm.deleteDependentSubMenus();
                  mm.setFocus();
               }
            }
            else
            {
               item.menuBarItemState = "itemOverSkin";
               isDown = false;
               if(m.dataDescriptor.getType(item.data) != "separator")
               {
                  requiresEvent = true;
               }
            }
            inKeyDown = false;
            if(requiresEvent)
            {
               evt = new MenuEvent(MenuEvent.ITEM_ROLL_OVER);
               evt.index = index;
               evt.menuBar = this;
               evt.label = itemToLabel(item.data);
               evt.item = item.data;
               evt.itemRenderer = item;
               dispatchEvent(evt);
            }
         }
      }
      
      public function set dataDescriptor(value:IMenuDataDescriptor) : void
      {
         _dataDescriptor = value;
         menus = [];
      }
      
      private function insertMenuBarItem(index:int, mdp:Object) : void
      {
         if(dataProviderChanged)
         {
            commitProperties();
            return;
         }
         var item:IMenuBarItemRenderer = menuBarItemRenderer.newInstance();
         item.styleName = new StyleProxy(this,menuBarItemStyleFilters);
         item.visible = false;
         item.enabled = enabled && _dataDescriptor.isEnabled(mdp) != false;
         item.data = mdp;
         item.menuBar = this;
         item.menuBarItemIndex = index;
         addChild(DisplayObject(item));
         menuBarItems.splice(index,0,item);
         invalidateSize();
         invalidateDisplayList();
         item.addEventListener(MouseEvent.MOUSE_OVER,mouseOverHandler);
         item.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
         item.addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
         item.addEventListener(MouseEvent.MOUSE_OUT,mouseOutHandler);
      }
      
      public function set dataProvider(value:Object) : void
      {
         var xl:XMLList = null;
         var tmp:Array = null;
         if(Boolean(_rootModel))
         {
            _rootModel.removeEventListener(CollectionEvent.COLLECTION_CHANGE,collectionChangeHandler);
         }
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
         _rootModel.addEventListener(CollectionEvent.COLLECTION_CHANGE,collectionChangeHandler,false,0,true);
         dataProviderChanged = true;
         invalidateProperties();
         var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
         event.kind = CollectionEventKind.RESET;
         collectionChangeHandler(event);
         dispatchEvent(event);
      }
      
      [Inspectable(category="General",defaultValue="-1")]
      [Bindable("valueCommit")]
      public function get selectedIndex() : int
      {
         return openMenuIndex;
      }
      
      override protected function focusInHandler(event:FocusEvent) : void
      {
         super.focusInHandler(event);
      }
      
      private function eventHandler(event:Event) : void
      {
         var t:String = null;
         if(event is MenuEvent)
         {
            t = event.type;
            if(event.type == MenuEvent.MENU_HIDE && MenuEvent(event).menu == menus[openMenuIndex])
            {
               menuBarItems[openMenuIndex].menuBarItemState = "itemUpSkin";
               openMenuIndex = -1;
               dispatchEvent(event as MenuEvent);
            }
            else
            {
               dispatchEvent(event);
            }
         }
      }
      
      public function set showRoot(value:Boolean) : void
      {
         if(_showRoot != value)
         {
            showRootChanged = true;
            _showRoot = value;
            invalidateProperties();
         }
      }
   }
}

