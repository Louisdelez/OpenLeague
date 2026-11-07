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
   import mx.core.IFactory;
   import mx.core.IFlexDisplayObject;
   import mx.core.IUIComponent;
   import mx.core.LayoutDirection;
   import mx.core.UIComponent;
   import mx.core.UIComponentGlobals;
   import mx.events.CollectionEvent;
   import mx.events.CollectionEventKind;
   import mx.events.FlexEvent;
   import mx.events.MenuEvent;
   import mx.managers.IFocusManagerComponent;
   import mx.managers.ISystemManager;
   import mx.managers.PopUpManager;
   import mx.styles.ISimpleStyleClient;
   import mx.styles.StyleProxy;
   
   [RequiresDataBinding("true")]
   [IconFile("MenuBar.png")]
   [DefaultTriggerEvent("change")]
   [DefaultProperty("dataProvider")]
   [DefaultBindingProperty(destination="dataProvider")]
   [AccessibilityClass(implementation="mx.accessibility.MenuBarAccImpl")]
   [Style(name="symbolColor",type="uint",format="Color",inherit="yes",theme="spark")]
   [Style(name="selectionColor",type="uint",format="Color",inherit="yes")]
   [Style(name="rollOverColor",type="uint",format="Color",inherit="yes")]
   [Style(name="menuStyleName",type="String",inherit="no")]
   [Style(name="itemDownSkin",type="Class",inherit="no")]
   [Style(name="itemOverSkin",type="Class",inherit="no")]
   [Style(name="itemUpSkin",type="Class",inherit="no")]
   [Style(name="itemSkin",type="Class",inherit="no",states="up, over, down")]
   [Style(name="backgroundSkin",type="Class",inherit="no")]
   [Style(name="textIndent",type="Number",format="Length",inherit="yes")]
   [Style(name="textFieldClass",type="Class",inherit="no")]
   [Style(name="textDecoration",type="String",enumeration="none,underline",inherit="yes")]
   [Style(name="textAlign",type="String",enumeration="left,center,right",inherit="yes")]
   [Style(name="locale",type="String",inherit="yes")]
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
   [Style(name="direction",type="String",enumeration="ltr,rtl,inherit",inherit="yes")]
   [Style(name="color",type="uint",format="Color",inherit="yes")]
   [Style(name="highlightAlphas",type="Array",arrayType="Number",inherit="no",theme="halo")]
   [Style(name="fillColors",type="Array",arrayType="uint",format="Color",inherit="no",theme="halo")]
   [Style(name="fillAlphas",type="Array",arrayType="Number",inherit="no",theme="halo")]
   [Style(name="cornerRadius",type="Number",format="Length",inherit="no",theme="halo, spark")]
   [Style(name="borderColor",type="uint",format="Color",inherit="no",theme="halo")]
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
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static var createAccessibilityImplementation:Function;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static const MARGIN_WIDTH:int = 10;
      
      private static var _menuBarItemStyleFilters:Object = null;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _rootModel:ICollectionView;
      
      private var isDown:Boolean;
      
      private var inKeyDown:Boolean = false;
      
      private var background:IFlexDisplayObject;
      
      private var isInsideACB:Boolean = false;
      
      private var supposedToLoseFocus:Boolean = false;
      
      private var dataProviderChanged:Boolean = false;
      
      private var iconFieldChanged:Boolean = false;
      
      private var menuBarItemRendererChanged:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _dataDescriptor:IMenuDataDescriptor = new DefaultDataDescriptor();
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _hasRoot:Boolean = false;
      
      private var _iconField:String = "icon";
      
      private var _labelField:String = "label";
      
      [Inspectable(category="Data")]
      public var labelFunction:Function;
      
      private var _menuBarItemRenderer:IFactory;
      
      public var menuBarItems:Array = [];
      
      public var menus:Array = [];
      
      private var openMenuIndex:int = -1;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _showRoot:Boolean = true;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var showRootChanged:Boolean = false;
      
      public function MenuBar()
      {
         super();
         this.menuBarItemRenderer = new ClassFactory(MenuBarItem);
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
      
      override public function get baselinePosition() : Number
      {
         if(!validateBaselinePosition())
         {
            return NaN;
         }
         if(this.menuBarItems.length == 0)
         {
            return super.baselinePosition;
         }
         var menuBarItem0:IUIComponent = this.menuBarItems[0] as IUIComponent;
         if(!menuBarItem0)
         {
            return super.baselinePosition;
         }
         validateNow();
         return menuBarItem0.y + menuBarItem0.baselinePosition;
      }
      
      [Inspectable(category="General",enumeration="true,false",defaultValue="true")]
      override public function set enabled(value:Boolean) : void
      {
         var n:int = 0;
         var i:int = 0;
         super.enabled = value;
         if(Boolean(this.menuBarItems))
         {
            n = int(this.menuBarItems.length);
            for(i = 0; i < n; i++)
            {
               this.menuBarItems[i].enabled = value;
            }
         }
      }
      
      override public function set showInAutomationHierarchy(value:Boolean) : void
      {
      }
      
      [Inspectable(category="Data")]
      public function get dataDescriptor() : IMenuDataDescriptor
      {
         return IMenuDataDescriptor(this._dataDescriptor);
      }
      
      public function set dataDescriptor(value:IMenuDataDescriptor) : void
      {
         this._dataDescriptor = value;
         this.menus = [];
      }
      
      [Inspectable(category="Data")]
      [Bindable("collectionChange")]
      public function get dataProvider() : Object
      {
         if(Boolean(this._rootModel))
         {
            return this._rootModel;
         }
         return null;
      }
      
      public function set dataProvider(value:Object) : void
      {
         var xl:XMLList = null;
         var tmp:Array = null;
         if(Boolean(this._rootModel))
         {
            this._rootModel.removeEventListener(CollectionEvent.COLLECTION_CHANGE,this.collectionChangeHandler);
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
         this._rootModel.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.collectionChangeHandler,false,0,true);
         this.dataProviderChanged = true;
         invalidateProperties();
         var event:CollectionEvent = new CollectionEvent(CollectionEvent.COLLECTION_CHANGE);
         event.kind = CollectionEventKind.RESET;
         this.collectionChangeHandler(event);
         dispatchEvent(event);
      }
      
      public function get hasRoot() : Boolean
      {
         return this._hasRoot;
      }
      
      [Inspectable(category="Other",defaultValue="icon")]
      [Bindable("iconFieldChanged")]
      public function get iconField() : String
      {
         return this._iconField;
      }
      
      public function set iconField(value:String) : void
      {
         if(this._iconField != value)
         {
            this.iconFieldChanged = true;
            this._iconField = value;
            invalidateProperties();
            dispatchEvent(new Event("iconFieldChanged"));
         }
      }
      
      [Inspectable(category="Data",defaultValue="label")]
      [Bindable("labelFieldChanged")]
      public function get labelField() : String
      {
         return this._labelField;
      }
      
      public function set labelField(value:String) : void
      {
         if(this._labelField != value)
         {
            this._labelField = value;
            dispatchEvent(new Event("labelFieldChanged"));
         }
      }
      
      [Inspectable(category="Data")]
      [Bindable("menuBarItemRendererChanged")]
      public function get menuBarItemRenderer() : IFactory
      {
         return this._menuBarItemRenderer;
      }
      
      public function set menuBarItemRenderer(value:IFactory) : void
      {
         if(this._menuBarItemRenderer != value)
         {
            this._menuBarItemRenderer = value;
            this.menuBarItemRendererChanged = true;
            invalidateProperties();
            dispatchEvent(new Event("menuBarItemRendererChanged"));
         }
      }
      
      protected function get menuBarItemStyleFilters() : Object
      {
         return _menuBarItemStyleFilters;
      }
      
      [Inspectable(category="General",defaultValue="-1")]
      [Bindable("valueCommit")]
      public function get selectedIndex() : int
      {
         return this.openMenuIndex;
      }
      
      public function set selectedIndex(value:int) : void
      {
         this.openMenuIndex = value;
         dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
      }
      
      [Inspectable(category="Data",enumeration="true,false",defaultValue="false")]
      public function get showRoot() : Boolean
      {
         return this._showRoot;
      }
      
      public function set showRoot(value:Boolean) : void
      {
         if(this._showRoot != value)
         {
            this.showRootChanged = true;
            this._showRoot = value;
            invalidateProperties();
         }
      }
      
      override protected function initializeAccessibility() : void
      {
         if(MenuBar.createAccessibilityImplementation != null)
         {
            MenuBar.createAccessibilityImplementation(this);
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         for(var p:Object = parent; Boolean(p); p = p.parent)
         {
            if(p is ApplicationControlBar)
            {
               this.isInsideACB = true;
               break;
            }
         }
         this.updateBackground();
      }
      
      protected function updateBackground() : void
      {
         var backgroundSkinClass:Class = null;
         if(this.isInsideACB)
         {
            setStyle("translucent",true);
         }
         else
         {
            if(Boolean(this.background))
            {
               removeChild(DisplayObject(this.background));
               this.background = null;
            }
            backgroundSkinClass = getStyle("backgroundSkin");
            if(Boolean(backgroundSkinClass))
            {
               this.background = new backgroundSkinClass();
               if(this.background is ISimpleStyleClient)
               {
                  ISimpleStyleClient(this.background).styleName = this;
               }
               addChildAt(DisplayObject(this.background),0);
            }
         }
      }
      
      override protected function commitProperties() : void
      {
         var i:int = 0;
         var cursor:IViewCursor = null;
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
            this.removeAll();
            if(Boolean(this._rootModel))
            {
               if(!tmpCollection)
               {
                  tmpCollection = this._rootModel;
               }
               tmpCollection.addEventListener(CollectionEvent.COLLECTION_CHANGE,this.collectionChangeHandler,false,EventPriority.DEFAULT_HANDLER,true);
               if(tmpCollection.length > 0)
               {
                  cursor = tmpCollection.createCursor();
                  i = 0;
                  while(!cursor.afterLast)
                  {
                     try
                     {
                        this.insertMenuBarItem(i,cursor.current);
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
         if(this.iconFieldChanged || this.menuBarItemRendererChanged)
         {
            this.iconFieldChanged = false;
            this.menuBarItemRendererChanged = false;
            this.removeAll();
            if(Boolean(this._rootModel))
            {
               if(!tmpCollection)
               {
                  tmpCollection = this._rootModel;
               }
               if(tmpCollection.length > 0)
               {
                  cursor = tmpCollection.createCursor();
                  i = 0;
                  while(!cursor.afterLast)
                  {
                     try
                     {
                        this.insertMenuBarItem(i,cursor.current);
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
      
      override protected function measure() : void
      {
         super.measure();
         var len:int = int(this.menuBarItems.length);
         measuredWidth = 0;
         measuredHeight = DEFAULT_MEASURED_MIN_HEIGHT;
         for(var i:int = 0; i < len; i++)
         {
            measuredWidth += this.menuBarItems[i].getExplicitOrMeasuredWidth();
            measuredHeight = Math.max(measuredHeight,this.menuBarItems[i].getExplicitOrMeasuredHeight());
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
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var item:IMenuBarItemRenderer = null;
         super.updateDisplayList(unscaledWidth,unscaledHeight);
         var lastX:Number = MARGIN_WIDTH;
         var lastW:Number = 0;
         var len:int = int(this.menuBarItems.length);
         var clipContent:Boolean = false;
         var hideItems:Boolean = unscaledWidth == 0 || unscaledHeight == 0;
         for(var i:int = 0; i < len; i++)
         {
            item = this.menuBarItems[i];
            item.setActualSize(item.getExplicitOrMeasuredWidth(),unscaledHeight);
            item.visible = !hideItems;
            lastX = Number(item.x = lastX + lastW);
            lastW = Number(item.width);
            if(!hideItems && (item.getExplicitOrMeasuredHeight() > unscaledHeight || lastX + lastW > unscaledWidth))
            {
               clipContent = true;
            }
         }
         if(Boolean(this.background))
         {
            this.background.setActualSize(unscaledWidth,unscaledHeight);
            this.background.visible = !hideItems;
         }
         scrollRect = clipContent ? new Rectangle(0,0,unscaledWidth,unscaledHeight) : null;
      }
      
      override protected function focusInHandler(event:FocusEvent) : void
      {
         super.focusInHandler(event);
      }
      
      override protected function focusOutHandler(event:FocusEvent) : void
      {
         super.focusOutHandler(event);
         if(this.supposedToLoseFocus)
         {
            this.getMenuAt(this.openMenuIndex).hide();
         }
         this.supposedToLoseFocus = false;
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         var i:int = 0;
         var menuStyleName:String = null;
         var m:Menu = null;
         super.styleChanged(styleProp);
         var n:int = int(this.menuBarItems.length);
         for(i = 0; i < n; i++)
         {
            this.getMenuAt(i).styleChanged(styleProp);
         }
         if(!styleProp || styleProp == "" || styleProp == "backgroundSkin")
         {
            this.updateBackground();
         }
         if(styleProp == null || styleProp == "styleName" || styleProp == "menuStyleName")
         {
            menuStyleName = getStyle("menuStyleName");
            if(Boolean(menuStyleName))
            {
               for(i = 0; i < this.menus.length; i++)
               {
                  m = this.menus[i];
                  m.styleName = menuStyleName;
               }
            }
         }
      }
      
      override public function notifyStyleChangeInChildren(styleProp:String, recursive:Boolean) : void
      {
         super.notifyStyleChangeInChildren(styleProp,recursive);
         var n:int = int(this.menuBarItems.length);
         for(var i:int = 0; i < n; i++)
         {
            this.getMenuAt(i).notifyStyleChangeInChildren(styleProp,recursive);
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
               this.dataProviderChanged = true;
               invalidateProperties();
            }
            else if(ce.kind == CollectionEventKind.REMOVE)
            {
               this.dataProviderChanged = true;
               invalidateProperties();
            }
            else if(ce.kind == CollectionEventKind.REFRESH)
            {
               this.dataProviderChanged = true;
               this.dataProvider = this.dataProvider;
               invalidateProperties();
               invalidateSize();
            }
            else if(ce.kind == CollectionEventKind.RESET)
            {
               this.dataProviderChanged = true;
               invalidateProperties();
               invalidateSize();
            }
            else if(ce.kind == CollectionEventKind.UPDATE)
            {
               if(this.openMenuIndex == -1)
               {
                  this.dataProviderChanged = true;
                  invalidateProperties();
               }
            }
         }
         invalidateDisplayList();
      }
      
      private function eventHandler(event:Event) : void
      {
         var t:String = null;
         if(event is MenuEvent)
         {
            t = event.type;
            if(event.type == MenuEvent.MENU_HIDE && MenuEvent(event).menu == this.menus[this.openMenuIndex])
            {
               this.menuBarItems[this.openMenuIndex].menuBarItemState = "itemUpSkin";
               this.openMenuIndex = -1;
               dispatchEvent(event as MenuEvent);
            }
            else
            {
               dispatchEvent(event);
            }
         }
      }
      
      private function addMenuAt(index:int, arg1:Object, arg2:Object = null) : void
      {
         var newMenu:Menu = null;
         var mdp:Object = null;
         if(!this.dataProvider)
         {
            this.dataProvider = {};
         }
         var newItem:Object = arg1;
         this.insertMenuBarItem(index,mdp);
      }
      
      public function itemToLabel(data:Object) : String
      {
         if(data == null)
         {
            return " ";
         }
         if(this.labelFunction != null)
         {
            return this.labelFunction(data);
         }
         if(data is XML)
         {
            try
            {
               if(data[this.labelField].length() != 0)
               {
                  data = data[this.labelField];
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
               if(data[this.labelField] != null)
               {
                  data = data[this.labelField];
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
               if(data[this.iconField].length() != 0)
               {
                  icon = String(data[this.iconField]);
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
               if(data[this.iconField] != null)
               {
                  if(data[this.iconField] is Class)
                  {
                     return data[this.iconField];
                  }
                  if(data[this.iconField] is String)
                  {
                     iconClass = Class(systemManager.getDefinitionByName(data[this.iconField]));
                     if(Boolean(iconClass))
                     {
                        return iconClass;
                     }
                     return document[data[this.iconField]];
                  }
               }
            }
            catch(e:Error)
            {
            }
         }
         return null;
      }
      
      private function insertMenuBarItem(index:int, mdp:Object) : void
      {
         if(this.dataProviderChanged)
         {
            this.commitProperties();
            return;
         }
         var item:IMenuBarItemRenderer = this.menuBarItemRenderer.newInstance();
         item.styleName = new StyleProxy(this,this.menuBarItemStyleFilters);
         item.visible = false;
         item.enabled = enabled && this._dataDescriptor.isEnabled(mdp) != false;
         item.data = mdp;
         item.menuBar = this;
         item.menuBarItemIndex = index;
         addChild(DisplayObject(item));
         this.menuBarItems.splice(index,0,item);
         invalidateSize();
         invalidateDisplayList();
         item.addEventListener(MouseEvent.MOUSE_OVER,this.mouseOverHandler);
         item.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
         item.addEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
         item.addEventListener(MouseEvent.MOUSE_OUT,this.mouseOutHandler);
      }
      
      public function getMenuAt(index:int) : Menu
      {
         var menuStyleName:Object = null;
         if(this.dataProviderChanged)
         {
            this.commitProperties();
         }
         var item:IMenuBarItemRenderer = this.menuBarItems[index];
         var mdp:Object = item.data;
         var menu:Menu = this.menus[index];
         if(menu == null)
         {
            menu = new Menu();
            menu.showRoot = false;
            menuStyleName = getStyle("menuStyleName");
            if(Boolean(menuStyleName))
            {
               menu.styleName = menuStyleName;
            }
            menu.sourceMenuBar = this;
            menu.owner = this;
            menu.addEventListener("menuHide",this.eventHandler);
            menu.addEventListener("itemRollOver",this.eventHandler);
            menu.addEventListener("itemRollOut",this.eventHandler);
            menu.addEventListener("menuShow",this.eventHandler);
            menu.addEventListener("itemClick",this.eventHandler);
            menu.addEventListener("change",this.eventHandler);
            menu.iconField = this._iconField;
            menu.labelField = this._labelField;
            menu.labelFunction = this.labelFunction;
            menu.dataDescriptor = this._dataDescriptor;
            menu.invalidateSize();
            this.menus[index] = menu;
            menu.sourceMenuBarItem = item;
            Menu.popUpMenu(menu,this,mdp);
         }
         return menu;
      }
      
      private function showMenu(index:Number) : void
      {
         this.selectedIndex = index;
         var item:IMenuBarItemRenderer = this.menuBarItems[index];
         var menu:Menu = this.getMenuAt(index);
         var sm:ISystemManager = systemManager.topLevelSystemManager;
         var screen:Rectangle = sm.getVisibleApplicationRect(null,true);
         if(Boolean(menu.parentDisplayObject) && (!menu.parent || !menu.parent.contains(menu.parentDisplayObject)))
         {
            PopUpManager.addPopUp(menu,this,false);
            menu.addEventListener(MenuEvent.MENU_HIDE,menuHideHandler,false,EventPriority.DEFAULT_HANDLER);
         }
         if(Boolean(menu.parentDisplayObject) && (!menu.parent || !menu.parent.contains(menu.parentDisplayObject)))
         {
            PopUpManager.addPopUp(menu,this,false);
            menu.addEventListener(MenuEvent.MENU_HIDE,menuHideHandler,false,EventPriority.DEFAULT_HANDLER);
         }
         UIComponentGlobals.layoutManager.validateClient(menu,true);
         var pt:Point = new Point(0,0);
         pt = DisplayObject(item).localToGlobal(pt);
         if(layoutDirection == LayoutDirection.RTL)
         {
            pt.x -= menu.getExplicitOrMeasuredWidth();
         }
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
         pt.x = Math.max(screen.x,pt.x);
         pt = sm.getSandboxRoot().globalToLocal(pt);
         if(this.isInsideACB)
         {
            pt.y += 2;
         }
         menu.show(pt.x,pt.y);
      }
      
      private function removeMenuBarItemAt(index:int) : void
      {
         if(this.dataProviderChanged)
         {
            this.commitProperties();
         }
         var item:IMenuBarItemRenderer = this.menuBarItems[index];
         if(Boolean(item))
         {
            removeChild(DisplayObject(item));
            this.menuBarItems.splice(index,1);
            invalidateSize();
            invalidateDisplayList();
         }
      }
      
      private function removeAll() : void
      {
         var item:IMenuBarItemRenderer = null;
         if(this.dataProviderChanged)
         {
            this.commitProperties();
         }
         while(this.menuBarItems.length > 0)
         {
            item = this.menuBarItems[0];
            removeChild(DisplayObject(item));
            this.menuBarItems.splice(0,1);
         }
         this.menus = [];
         invalidateSize();
         invalidateDisplayList();
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
         var m:Menu = this.getMenuAt(index);
         if(item.enabled)
         {
            if(this.openMenuIndex != -1 || this.inKeyDown)
            {
               oldIndex = this.openMenuIndex;
               if(oldIndex != index)
               {
                  this.isDown = false;
                  if(oldIndex != -1)
                  {
                     oldItem = this.menuBarItems[oldIndex];
                     oldItem.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP));
                     oldItem.menuBarItemState = "itemUpSkin";
                     evt = new MenuEvent(MenuEvent.ITEM_ROLL_OUT);
                     evt.menuBar = this;
                     evt.index = oldIndex;
                     evt.label = this.itemToLabel(oldItem.data);
                     evt.item = oldItem.data;
                     evt.itemRenderer = oldItem;
                     dispatchEvent(evt);
                  }
                  item.menuBarItemState = "itemDownSkin";
                  dp = ICollectionView(m.dataProvider);
                  if(Boolean(m.dataDescriptor.isBranch(item.data,item.data)) && Boolean(m.dataDescriptor.hasChildren(item.data,item.data)))
                  {
                     this.showMenu(index);
                  }
                  else if(Boolean(m))
                  {
                     this.selectedIndex = index;
                     evt = new MenuEvent(MenuEvent.MENU_SHOW);
                     evt.menuBar = this;
                     evt.menu = m;
                     dispatchEvent(evt);
                     item.menuBarItemState = "itemOverSkin";
                  }
                  this.isDown = true;
                  if(m.dataDescriptor.getType(item.data) != "separator")
                  {
                     requiresEvent = true;
                     evt = new MenuEvent(MenuEvent.CHANGE);
                     evt.index = index;
                     evt.menuBar = this;
                     evt.label = this.itemToLabel(item.data);
                     evt.item = item.data;
                     evt.itemRenderer = item;
                     dispatchEvent(evt);
                  }
               }
               else
               {
                  mm = this.getMenuAt(index);
                  mm.deleteDependentSubMenus();
                  mm.setFocus();
               }
            }
            else
            {
               item.menuBarItemState = "itemOverSkin";
               this.isDown = false;
               if(m.dataDescriptor.getType(item.data) != "separator")
               {
                  requiresEvent = true;
               }
            }
            this.inKeyDown = false;
            if(requiresEvent)
            {
               evt = new MenuEvent(MenuEvent.ITEM_ROLL_OVER);
               evt.index = index;
               evt.menuBar = this;
               evt.label = this.itemToLabel(item.data);
               evt.item = item.data;
               evt.itemRenderer = item;
               dispatchEvent(evt);
            }
         }
      }
      
      private function mouseDownHandler(event:MouseEvent) : void
      {
         var dp:ICollectionView = null;
         var evt:MenuEvent = null;
         var menuEvent:MenuEvent = null;
         var item:IMenuBarItemRenderer = IMenuBarItemRenderer(event.target);
         var index:int = item.menuBarItemIndex;
         var m:Menu = this.getMenuAt(index);
         if(item.enabled)
         {
            item.menuBarItemState = "itemDownSkin";
            if(!this.isDown)
            {
               m.supposedToLoseFocus = true;
               dp = ICollectionView(m.dataProvider);
               if(Boolean(m.dataDescriptor.isBranch(item.data,item.data)) && Boolean(m.dataDescriptor.hasChildren(item.data,item.data)))
               {
                  this.showMenu(index);
               }
               else if(Boolean(m))
               {
                  this.selectedIndex = index;
                  evt = new MenuEvent(MenuEvent.MENU_SHOW);
                  evt.menuBar = this;
                  evt.menu = m;
                  dispatchEvent(evt);
               }
               this.isDown = true;
            }
            else
            {
               this.isDown = false;
            }
            if(m.dataDescriptor.getType(item.data) != "separator")
            {
               menuEvent = new MenuEvent(MenuEvent.CHANGE);
               menuEvent.index = index;
               menuEvent.menuBar = this;
               menuEvent.label = this.itemToLabel(item.data);
               menuEvent.item = item.data;
               menuEvent.itemRenderer = item;
               dispatchEvent(menuEvent);
            }
         }
      }
      
      private function mouseUpHandler(event:MouseEvent) : void
      {
         var item:IMenuBarItemRenderer = IMenuBarItemRenderer(event.target);
         var index:int = item.menuBarItemIndex;
         if(Boolean(item.enabled) && !this.isDown)
         {
            this.getMenuAt(index).hideAllMenus();
            item.menuBarItemState = "itemOverSkin";
         }
      }
      
      private function mouseOutHandler(event:MouseEvent) : void
      {
         var menuEvent:MenuEvent = null;
         var item:IMenuBarItemRenderer = IMenuBarItemRenderer(event.target);
         var index:int = item.menuBarItemIndex;
         var m:Menu = this.getMenuAt(index);
         if(Boolean(item.enabled) && this.openMenuIndex != index)
         {
            this.menuBarItems[index].menuBarItemState = "itemUpSkin";
         }
         if(Boolean(item.data) && m.dataDescriptor.getType(item.data) != "separator")
         {
            menuEvent = new MenuEvent(MenuEvent.ITEM_ROLL_OUT);
            menuEvent.index = index;
            menuEvent.menuBar = this;
            menuEvent.label = this.itemToLabel(item.data);
            menuEvent.item = item.data;
            menuEvent.itemRenderer = item;
            dispatchEvent(menuEvent);
         }
      }
      
      override protected function keyDownHandler(event:KeyboardEvent) : void
      {
         var nextIndex:int = 0;
         var found:Boolean = false;
         var count:int = 0;
         var keyCode:uint = 0;
         var menu:Menu = null;
         var dp:ICollectionView = null;
         var item:IMenuBarItemRenderer = null;
         var barLen:int = int(this.menuBarItems.length);
         if(event.keyCode == Keyboard.RIGHT || event.keyCode == Keyboard.LEFT)
         {
            this.inKeyDown = true;
            nextIndex = this.openMenuIndex;
            found = false;
            count = 0;
            keyCode = uint(mapKeycodeForLayoutDirection(event));
            while(!found && count < barLen)
            {
               count++;
               nextIndex = keyCode == Keyboard.RIGHT ? int(nextIndex + 1) : int(nextIndex - 1);
               if(nextIndex >= barLen)
               {
                  nextIndex = 0;
               }
               else if(nextIndex < 0)
               {
                  nextIndex = barLen - 1;
               }
               if(Boolean(this.menuBarItems[nextIndex].enabled))
               {
                  found = true;
               }
            }
            if(count <= barLen && found)
            {
               this.menuBarItems[nextIndex].dispatchEvent(new MouseEvent(MouseEvent.MOUSE_OVER));
            }
            event.stopPropagation();
         }
         if(keyCode == Keyboard.DOWN)
         {
            if(this.openMenuIndex != -1)
            {
               menu = this.getMenuAt(this.openMenuIndex);
               menu.selectedIndex = 0;
               this.supposedToLoseFocus = true;
               dp = ICollectionView(menu.dataProvider);
               item = menu.sourceMenuBarItem;
               if(Boolean(menu.dataDescriptor.isBranch(item.data,item.data)) && Boolean(menu.dataDescriptor.hasChildren(item.data,item.data)))
               {
                  menu.setFocus();
               }
            }
            event.stopPropagation();
         }
         if(keyCode == Keyboard.ENTER || keyCode == Keyboard.ESCAPE)
         {
            if(this.openMenuIndex != -1)
            {
               this.getMenuAt(this.openMenuIndex).hide();
            }
            event.stopPropagation();
         }
      }
   }
}

