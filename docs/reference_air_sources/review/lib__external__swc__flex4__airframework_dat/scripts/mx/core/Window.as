package mx.core
{
   import flash.desktop.NativeApplication;
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.NativeWindow;
   import flash.display.NativeWindowDisplayState;
   import flash.display.NativeWindowInitOptions;
   import flash.display.NativeWindowResize;
   import flash.display.NativeWindowSystemChrome;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.NativeWindowBoundsEvent;
   import flash.events.NativeWindowDisplayStateEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.system.Capabilities;
   import mx.controls.Button;
   import mx.controls.FlexNativeMenu;
   import mx.core.windowClasses.StatusBar;
   import mx.core.windowClasses.TitleBar;
   import mx.events.AIREvent;
   import mx.events.EffectEvent;
   import mx.events.FlexEvent;
   import mx.events.FlexNativeWindowBoundsEvent;
   import mx.events.WindowExistenceEvent;
   import mx.managers.CursorManagerImpl;
   import mx.managers.FocusManager;
   import mx.managers.IActiveWindowManager;
   import mx.managers.ICursorManager;
   import mx.managers.ISystemManager;
   import mx.managers.SystemManagerGlobals;
   import mx.managers.WindowedSystemManager;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleProxy;
   
   [Alternative(replacement="spark.components.Window",since="4.0")]
   [ResourceBundle("core")]
   [IconFile("Window.png")]
   [Frame(factoryClass="mx.managers.WindowedSystemManager")]
   [Exclude(name="moveEffect",kind="effect")]
   [Effect(name="unminimizeEffect",event="windowUnminimize")]
   [Effect(name="minimizeEffect",event="windowMinimize")]
   [Effect(name="closeEffect",event="windowClose")]
   [Style(name="titleTextStyleName",type="String",inherit="yes")]
   [Style(name="titleBarColors",type="Array",arrayType="uint",format="Color",inherit="yes")]
   [Style(name="titleBarButtonPadding",type="Number",inherit="true")]
   [Style(name="titleBarBackgroundSkin",type="Class",inherit="yes")]
   [Style(name="titleAlignment",type="String",enumeration="left,center,auto",inherit="yes")]
   [Style(name="statusTextStyleName",type="String",inherit="yes")]
   [Style(name="statusBarBackgroundSkin",type="Class",inherit="yes")]
   [Style(name="statusBarBackgroundColor",type="uint",format="Color",inherit="yes")]
   [Style(name="showFlexChrome",type="Boolean",inherit="no")]
   [Style(name="restoreButtonSkin",type="Class",inherit="no",states="up, over, down, disabled")]
   [Style(name="minimizeButtonSkin",type="Class",inherit="no",states="up, over, down, disabled")]
   [Style(name="maximizeButtonSkin",type="Class",inherit="no",states="up, over, down, disabled")]
   [Style(name="headerHeight",type="Number",format="Length",inherit="no")]
   [Style(name="gripperStyleName",type="String",inherit="no")]
   [Style(name="gripperPadding",type="Number",format="Length",inherit="no")]
   [Style(name="closeButtonSkin",type="Class",inherit="no",states="up, over, down, disabled")]
   [Style(name="buttonPadding",type="Number",inherit="yes")]
   [Style(name="buttonAlignment",type="String",enumeration="left,right,auto",inherit="yes")]
   [Event(name="windowResize",type="mx.events.FlexNativeWindowBoundsEvent")]
   [Event(name="windowMove",type="mx.events.FlexNativeWindowBoundsEvent")]
   [Event(name="windowComplete",type="mx.events.AIREvent")]
   [Event(name="resizing",type="flash.events.NativeWindowBoundsEvent")]
   [Event(name="networkChange",type="flash.events.Event")]
   [Event(name="moving",type="flash.events.NativeWindowBoundsEvent")]
   [Event(name="displayStateChanging",type="flash.events.NativeWindowDisplayStateEvent")]
   [Event(name="displayStateChange",type="flash.events.NativeWindowDisplayStateEvent")]
   [Event(name="closing",type="flash.events.Event")]
   [Event(name="close",type="flash.events.Event")]
   [Event(name="windowDeactivate",type="mx.events.AIREvent")]
   [Event(name="windowActivate",type="mx.events.AIREvent")]
   [Event(name="applicationDeactivate",type="mx.events.AIREvent")]
   [Event(name="applicationActivate",type="mx.events.AIREvent")]
   public class Window extends LayoutContainer implements IWindow
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static const HEADER_PADDING:Number = 4;
      
      private static const MOUSE_SLACK:Number = 5;
      
      private static const DEFAULT_WINDOW_HEIGHT:Number = 100;
      
      private static const DEFAULT_WINDOW_WIDTH:Number = 100;
      
      private static var _statusBarStyleFilters:Object = {
         "statusBarBackgroundColor":"statusBarBackgroundColor",
         "statusBarBackgroundSkin":"statusBarBackgroundSkin",
         "statusTextStyleName":"statusTextStyleName"
      };
      
      private static var _titleBarStyleFilters:Object = {
         "buttonAlignment":"buttonAlignment",
         "buttonPadding":"buttonPadding",
         "closeButtonSkin":"closeButtonSkin",
         "cornerRadius":"cornerRadius",
         "headerHeight":"headerHeight",
         "maximizeButtonSkin":"maximizeButtonSkin",
         "minimizeButtonSkin":"minimizeButtonSkin",
         "restoreButtonSkin":"restoreButtonSkin",
         "titleAlignment":"titleAlignment",
         "titleBarBackgroundSkin":"titleBarBackgroundSkin",
         "titleBarButtonPadding":"titleBarButtonPadding",
         "titleBarColors":"titleBarColors",
         "titleTextStyleName":"titleTextStyleName"
      };
      
      private var _nativeWindow:NativeWindow;
      
      private var _nativeWindowVisible:Boolean = true;
      
      private var maximized:Boolean = false;
      
      private var _cursorManager:ICursorManager;
      
      private var toMax:Boolean = false;
      
      private var appViewMetrics:EdgeMetrics;
      
      private var frameCounter:int = 0;
      
      private var gripper:Button;
      
      private var gripperHit:Sprite;
      
      private var flagForOpen:Boolean = false;
      
      private var openActive:Boolean = true;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var titleBarBackground:IFlexDisplayObject;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var statusBarBackground:IFlexDisplayObject;
      
      private var oldX:Number;
      
      private var oldY:Number;
      
      private var prevX:Number;
      
      private var prevY:Number;
      
      private var resizeHandlerAdded:Boolean = false;
      
      private var resizeWidth:Boolean = true;
      
      private var resizeHeight:Boolean = true;
      
      private var _maxHeight:Number = 2880;
      
      private var maxHeightChanged:Boolean = false;
      
      private var _maxWidth:Number = 2880;
      
      private var maxWidthChanged:Boolean = false;
      
      private var _minHeight:Number = 0;
      
      private var minHeightChanged:Boolean = false;
      
      private var _minWidth:Number = 0;
      
      private var minWidthChanged:Boolean = false;
      
      private var _alwaysInFront:Boolean = false;
      
      private var _bounds:Rectangle = new Rectangle(0,0,DEFAULT_WINDOW_WIDTH,DEFAULT_WINDOW_HEIGHT);
      
      private var boundsChanged:Boolean = false;
      
      public var controlBar:IUIComponent;
      
      private var _maximizable:Boolean = true;
      
      private var _menu:FlexNativeMenu;
      
      private var menuChanged:Boolean = false;
      
      private var _minimizable:Boolean = true;
      
      private var _resizable:Boolean = true;
      
      private var _showGripper:Boolean = true;
      
      private var showGripperChanged:Boolean = true;
      
      private var _showStatusBar:Boolean = true;
      
      private var showStatusBarChanged:Boolean = true;
      
      private var _showTitleBar:Boolean = true;
      
      private var showTitleBarChanged:Boolean = true;
      
      private var _status:String = "";
      
      private var statusChanged:Boolean = false;
      
      private var _statusBar:UIComponent;
      
      private var _statusBarFactory:IFactory = new ClassFactory(StatusBar);
      
      private var statusBarFactoryChanged:Boolean = false;
      
      private var _systemChrome:String = "standard";
      
      private var _title:String = "";
      
      private var titleChanged:Boolean = false;
      
      private var _titleBar:UIComponent;
      
      private var _titleBarFactory:IFactory = new ClassFactory(TitleBar);
      
      private var titleBarFactoryChanged:Boolean = false;
      
      private var _titleIcon:Class;
      
      private var titleIconChanged:Boolean = false;
      
      private var _transparent:Boolean = false;
      
      private var _type:String = "normal";
      
      public function Window()
      {
         super();
         addEventListener(FlexEvent.CREATION_COMPLETE,this.creationCompleteHandler);
         addEventListener(FlexEvent.PREINITIALIZE,this.preinitializeHandler);
         invalidateProperties();
      }
      
      private static function weakDependency() : void
      {
      }
      
      public static function getWindow(component:UIComponent) : IWindow
      {
         if(component.systemManager is WindowedSystemManager)
         {
            return WindowedSystemManager(component.systemManager).window;
         }
         return null;
      }
      
      [PercentProxy("percentHeight")]
      [Inspectable(category="General")]
      [Bindable("heightChanged")]
      override public function get height() : Number
      {
         return this._bounds.height;
      }
      
      override public function set height(value:Number) : void
      {
         if(value < this.minHeight)
         {
            value = this.minHeight;
         }
         else if(value > this.maxHeight)
         {
            value = this.maxHeight;
         }
         this._bounds.height = value;
         this.boundsChanged = true;
         invalidateProperties();
         invalidateSize();
         invalidateViewMetricsAndPadding();
         dispatchEvent(new Event("heightChanged"));
      }
      
      [Bindable("windowComplete")]
      [Bindable("maxHeightChanged")]
      override public function get maxHeight() : Number
      {
         if(Boolean(this.nativeWindow) && !this.maxHeightChanged)
         {
            return this.nativeWindow.maxSize.y - this.chromeHeight();
         }
         return this._maxHeight;
      }
      
      override public function set maxHeight(value:Number) : void
      {
         this._maxHeight = value;
         this.maxHeightChanged = true;
         invalidateProperties();
      }
      
      [Bindable("windowComplete")]
      [Bindable("maxWidthChanged")]
      override public function get maxWidth() : Number
      {
         if(Boolean(this.nativeWindow) && !this.maxWidthChanged)
         {
            return this.nativeWindow.maxSize.x - this.chromeWidth();
         }
         return this._maxWidth;
      }
      
      override public function set maxWidth(value:Number) : void
      {
         this._maxWidth = value;
         this.maxWidthChanged = true;
         invalidateProperties();
      }
      
      [Bindable("windowComplete")]
      [Bindable("minHeightChanged")]
      override public function get minHeight() : Number
      {
         if(Boolean(this.nativeWindow) && !this.minHeightChanged)
         {
            return this.nativeWindow.minSize.y - this.chromeHeight();
         }
         return this._minHeight;
      }
      
      override public function set minHeight(value:Number) : void
      {
         this._minHeight = value;
         this.minHeightChanged = true;
         invalidateProperties();
      }
      
      [Bindable("windowComplete")]
      [Bindable("minWidthChanged")]
      override public function get minWidth() : Number
      {
         if(Boolean(this.nativeWindow) && !this.minWidthChanged)
         {
            return this.nativeWindow.minSize.x - this.chromeWidth();
         }
         return this._minWidth;
      }
      
      override public function set minWidth(value:Number) : void
      {
         this._minWidth = value;
         this.minWidthChanged = true;
         invalidateProperties();
      }
      
      [Bindable("windowComplete")]
      [Bindable("show")]
      [Bindable("hide")]
      override public function get visible() : Boolean
      {
         if(Boolean(this.nativeWindow) && Boolean(this.nativeWindow.closed))
         {
            return false;
         }
         if(Boolean(this.nativeWindow))
         {
            return this.nativeWindow.visible;
         }
         return this._nativeWindowVisible;
      }
      
      override public function set visible(value:Boolean) : void
      {
         this.setVisible(value);
      }
      
      override public function setVisible(value:Boolean, noEvent:Boolean = false) : void
      {
         if(!this._nativeWindow)
         {
            this._nativeWindowVisible = value;
            invalidateProperties();
         }
         else if(!this._nativeWindow.closed)
         {
            if(value)
            {
               this._nativeWindow.visible = value;
            }
            else if(Boolean(getStyle("hideEffect")) && Boolean(initialized) && $visible != value)
            {
               addEventListener(EffectEvent.EFFECT_END,this.hideEffectEndHandler);
            }
            else
            {
               this._nativeWindow.visible = value;
            }
         }
         super.setVisible(value,noEvent);
      }
      
      [PercentProxy("percentWidth")]
      [Inspectable(category="General")]
      [Bindable("widthChanged")]
      override public function get width() : Number
      {
         return this._bounds.width;
      }
      
      override public function set width(value:Number) : void
      {
         if(value < this.minWidth)
         {
            value = this.minWidth;
         }
         else if(value > this.maxWidth)
         {
            value = this.maxWidth;
         }
         this._bounds.width = value;
         this.boundsChanged = true;
         invalidateProperties();
         invalidateSize();
         invalidateViewMetricsAndPadding();
         dispatchEvent(new Event("widthChanged"));
      }
      
      override public function get viewMetrics() : EdgeMetrics
      {
         var hHeight:Number = NaN;
         var sHeight:Number = NaN;
         var bm:EdgeMetrics = super.viewMetrics;
         var vm:EdgeMetrics = new EdgeMetrics(bm.left,bm.top,bm.right,bm.bottom);
         if(this.showTitleBar)
         {
            hHeight = this.getHeaderHeight();
            if(!isNaN(hHeight))
            {
               vm.top += hHeight;
            }
         }
         if(this.showStatusBar)
         {
            sHeight = this.getStatusBarHeight();
            if(!isNaN(sHeight))
            {
               vm.bottom += sHeight;
            }
         }
         if(Boolean(this.controlBar) && Boolean(this.controlBar.includeInLayout))
         {
            vm.top += this.controlBar.getExplicitOrMeasuredHeight();
         }
         return vm;
      }
      
      public function get alwaysInFront() : Boolean
      {
         if(Boolean(this._nativeWindow) && !this._nativeWindow.closed)
         {
            return this.nativeWindow.alwaysInFront;
         }
         return this._alwaysInFront;
      }
      
      public function set alwaysInFront(value:Boolean) : void
      {
         this._alwaysInFront = value;
         if(Boolean(this._nativeWindow) && !this._nativeWindow.closed)
         {
            this.nativeWindow.alwaysInFront = value;
         }
      }
      
      protected function get bounds() : Rectangle
      {
         return this._bounds;
      }
      
      protected function set bounds(value:Rectangle) : void
      {
         this._bounds = value;
         this.boundsChanged = true;
         invalidateProperties();
         invalidateSize();
         invalidateViewMetricsAndPadding();
      }
      
      public function get closed() : Boolean
      {
         return this.nativeWindow.closed;
      }
      
      public function get maximizable() : Boolean
      {
         return this._maximizable;
      }
      
      public function set maximizable(value:Boolean) : void
      {
         if(!this._nativeWindow)
         {
            this._maximizable = value;
            invalidateProperties();
         }
      }
      
      override public function get cursorManager() : ICursorManager
      {
         return this._cursorManager;
      }
      
      public function get menu() : FlexNativeMenu
      {
         return this._menu;
      }
      
      public function set menu(value:FlexNativeMenu) : void
      {
         if(Boolean(this._menu))
         {
            this._menu.automationParent = null;
            this._menu.automationOwner = null;
         }
         this._menu = value;
         this.menuChanged = true;
         if(Boolean(this._menu))
         {
            this.menu.automationParent = this;
            this.menu.automationOwner = this;
         }
      }
      
      public function get minimizable() : Boolean
      {
         return this._minimizable;
      }
      
      public function set minimizable(value:Boolean) : void
      {
         if(!this._nativeWindow)
         {
            this._minimizable = value;
            invalidateProperties();
         }
      }
      
      public function get nativeWindow() : NativeWindow
      {
         if(Boolean(systemManager) && Boolean(systemManager.stage))
         {
            return systemManager.stage.nativeWindow;
         }
         return null;
      }
      
      public function get resizable() : Boolean
      {
         return this._resizable;
      }
      
      public function set resizable(value:Boolean) : void
      {
         if(!this._nativeWindow)
         {
            this._resizable = value;
            invalidateProperties();
         }
      }
      
      public function get showGripper() : Boolean
      {
         return this._showGripper;
      }
      
      public function set showGripper(value:Boolean) : void
      {
         if(this._showGripper == value)
         {
            return;
         }
         this._showGripper = value;
         this.showGripperChanged = true;
         invalidateProperties();
         invalidateDisplayList();
      }
      
      public function get showStatusBar() : Boolean
      {
         return this._showStatusBar;
      }
      
      public function set showStatusBar(value:Boolean) : void
      {
         if(this._showStatusBar == value)
         {
            return;
         }
         this._showStatusBar = value;
         this.showStatusBarChanged = true;
         invalidateProperties();
         invalidateDisplayList();
      }
      
      public function get showTitleBar() : Boolean
      {
         return this._showTitleBar;
      }
      
      public function set showTitleBar(value:Boolean) : void
      {
         if(this._showTitleBar == value)
         {
            return;
         }
         this._showTitleBar = value;
         this.showTitleBarChanged = true;
         invalidateProperties();
         invalidateDisplayList();
      }
      
      [Bindable("statusChanged")]
      public function get status() : String
      {
         return this._status;
      }
      
      public function set status(value:String) : void
      {
         this._status = value;
         this.statusChanged = true;
         invalidateProperties();
         invalidateSize();
         invalidateViewMetricsAndPadding();
         dispatchEvent(new Event("statusChanged"));
      }
      
      public function get statusBar() : UIComponent
      {
         return this._statusBar;
      }
      
      [Bindable("statusBarFactoryChanged")]
      public function get statusBarFactory() : IFactory
      {
         return this._statusBarFactory;
      }
      
      public function set statusBarFactory(value:IFactory) : void
      {
         this._statusBarFactory = value;
         this.statusBarFactoryChanged = true;
         invalidateProperties();
         dispatchEvent(new Event("statusBarFactoryChanged"));
      }
      
      protected function get statusBarStyleFilters() : Object
      {
         return _statusBarStyleFilters;
      }
      
      [Inspectable(enumeration="none,standard",defaultValue="standard")]
      public function get systemChrome() : String
      {
         return this._systemChrome;
      }
      
      public function set systemChrome(value:String) : void
      {
         if(!this._nativeWindow)
         {
            this._systemChrome = value;
            invalidateProperties();
         }
      }
      
      [Bindable("titleChanged")]
      public function get title() : String
      {
         return this._title;
      }
      
      public function set title(value:String) : void
      {
         this.titleChanged = true;
         this._title = value;
         invalidateProperties();
         invalidateSize();
         invalidateViewMetricsAndPadding();
         invalidateDisplayList();
         dispatchEvent(new Event("titleChanged"));
      }
      
      public function get titleBar() : UIComponent
      {
         return this._titleBar;
      }
      
      [Bindable("titleBarFactoryChanged")]
      public function get titleBarFactory() : IFactory
      {
         return this._titleBarFactory;
      }
      
      public function set titleBarFactory(value:IFactory) : void
      {
         this._titleBarFactory = value;
         this.titleBarFactoryChanged = true;
         invalidateProperties();
         dispatchEvent(new Event("titleBarFactoryChanged"));
      }
      
      protected function get titleBarStyleFilters() : Object
      {
         return _titleBarStyleFilters;
      }
      
      [Bindable("titleIconChanged")]
      public function get titleIcon() : Class
      {
         return this._titleIcon;
      }
      
      public function set titleIcon(value:Class) : void
      {
         this._titleIcon = value;
         this.titleIconChanged = true;
         invalidateProperties();
         invalidateSize();
         invalidateViewMetricsAndPadding();
         invalidateDisplayList();
         dispatchEvent(new Event("titleIconChanged"));
      }
      
      public function get transparent() : Boolean
      {
         return this._transparent;
      }
      
      public function set transparent(value:Boolean) : void
      {
         if(!this._nativeWindow)
         {
            this._transparent = value;
            invalidateProperties();
         }
      }
      
      public function get type() : String
      {
         return this._type;
      }
      
      public function set type(value:String) : void
      {
         if(!this._nativeWindow)
         {
            this._type = value;
            invalidateProperties();
         }
      }
      
      override public function initialize() : void
      {
         var properties:Object = null;
         var sm:ISystemManager = systemManager;
         if(Boolean(documentDescriptor))
         {
            creationPolicy = documentDescriptor.properties.creationPolicy;
            if(creationPolicy == null || creationPolicy.length == 0)
            {
               creationPolicy = ContainerCreationPolicy.AUTO;
            }
            properties = documentDescriptor.properties;
            if(properties.width != null)
            {
               this.width = properties.width;
               delete properties.width;
            }
            if(properties.height != null)
            {
               this.height = properties.height;
               delete properties.height;
            }
            documentDescriptor.events = null;
         }
         super.initialize();
      }
      
      override protected function createChildren() : void
      {
         var gripSkin:String = null;
         var tmp:CSSStyleDeclaration = null;
         this.width = this._bounds.width;
         this.height = this._bounds.height;
         super.createChildren();
         if(getStyle("showFlexChrome") == false || getStyle("showFlexChrome") == "false")
         {
            setStyle("borderStyle","none");
            setStyle("backgroundAlpha",0);
            return;
         }
         if(systemManager.stage.nativeWindow.type != "utility")
         {
            if(!this._statusBar)
            {
               this._statusBar = this.statusBarFactory.newInstance();
               this._statusBar.styleName = new StyleProxy(this,this.statusBarStyleFilters);
               rawChildren.addChild(DisplayObject(this._statusBar));
               this.showStatusBarChanged = true;
               this.statusBarFactoryChanged = false;
            }
         }
         if(!this.gripper)
         {
            this.gripper = new Button();
            gripSkin = getStyle("gripperStyleName");
            if(Boolean(gripSkin))
            {
               tmp = styleManager.getStyleDeclaration("." + gripSkin);
               this.gripper.styleName = gripSkin;
            }
            this.gripper.tabEnabled = false;
            this.gripper.tabFocusEnabled = false;
            this.gripper.skinLayoutDirection = undefined;
            rawChildren.addChild(this.gripper);
            this.gripperHit = new Sprite();
            rawChildren.addChild(this.gripperHit);
            this.gripperHit.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
         }
         if(systemManager.stage.nativeWindow.systemChrome != "none")
         {
            setStyle("borderStyle","none");
            return;
         }
         if(!this._titleBar)
         {
            this._titleBar = this.titleBarFactory.newInstance();
            this._titleBar.styleName = new StyleProxy(this,this.titleBarStyleFilters);
            rawChildren.addChild(DisplayObject(this.titleBar));
            this.showTitleBarChanged = true;
         }
      }
      
      override protected function commitProperties() : void
      {
         var init:NativeWindowInitOptions = null;
         var sm:WindowedSystemManager = null;
         var nativeApplication:NativeApplication = null;
         var minSize:Point = null;
         var maxSize:Point = null;
         var newMinWidth:Number = NaN;
         var newMinHeight:Number = NaN;
         var newMaxWidth:Number = NaN;
         var newMaxHeight:Number = NaN;
         var newWidth:Number = NaN;
         var newHeight:Number = NaN;
         var gripperIndex:int = 0;
         super.commitProperties();
         if(this.flagForOpen && !this._nativeWindow)
         {
            this.flagForOpen = false;
            if(moduleFactory == null)
            {
               moduleFactory = SystemManagerGlobals.topLevelSystemManagers[0];
            }
            init = new NativeWindowInitOptions();
            init.maximizable = this._maximizable;
            init.minimizable = this._minimizable;
            init.resizable = this._resizable;
            init.type = this._type;
            init.systemChrome = this._systemChrome;
            init.transparent = this._transparent;
            this._nativeWindow = new NativeWindow(init);
            sm = new WindowedSystemManager(this);
            this._nativeWindow.stage.addChild(sm);
            systemManager = sm;
            sm.window = this;
            this._nativeWindow.alwaysInFront = this._alwaysInFront;
            this.initManagers(sm);
            addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
            nativeApplication = NativeApplication.nativeApplication;
            nativeApplication.addEventListener(Event.ACTIVATE,this.nativeApplication_activateHandler,false,0,true);
            nativeApplication.addEventListener(Event.DEACTIVATE,this.nativeApplication_deactivateHandler,false,0,true);
            nativeApplication.addEventListener(Event.NETWORK_CHANGE,this.nativeApplication_networkChangeHandler,false,0,true);
            this._nativeWindow.addEventListener(Event.ACTIVATE,this.nativeWindow_activateHandler,false,0,true);
            this._nativeWindow.addEventListener(Event.DEACTIVATE,this.nativeWindow_deactivateHandler,false,0,true);
            addEventListener(Event.ENTER_FRAME,this.enterFrameHandler);
            sm.addWindow(this);
         }
         if(this.minWidthChanged || this.minHeightChanged || this.maxWidthChanged || this.maxHeightChanged)
         {
            minSize = this.nativeWindow.minSize;
            maxSize = this.nativeWindow.maxSize;
            newMinWidth = this.minWidthChanged ? this._minWidth + this.chromeWidth() : minSize.x;
            newMinHeight = this.minHeightChanged ? this._minHeight + this.chromeHeight() : minSize.y;
            newMaxWidth = this.maxWidthChanged ? this._maxWidth + this.chromeWidth() : maxSize.x;
            newMaxHeight = this.maxHeightChanged ? this._maxHeight + this.chromeHeight() : maxSize.y;
            if(this.minWidthChanged || this.minHeightChanged)
            {
               if(this.maxWidthChanged && newMinWidth > minSize.x || this.maxHeightChanged && newMinHeight > minSize.y)
               {
                  this.nativeWindow.maxSize = new Point(newMaxWidth,newMaxHeight);
               }
               this.nativeWindow.minSize = new Point(newMinWidth,newMinHeight);
            }
            if(newMaxWidth != maxSize.x || newMaxHeight != maxSize.y)
            {
               this.nativeWindow.maxSize = new Point(newMaxWidth,newMaxHeight);
            }
         }
         if(this.minWidthChanged || this.minHeightChanged)
         {
            if(this.minWidthChanged)
            {
               this.minWidthChanged = false;
               if(this.width < this.minWidth)
               {
                  this.width = this.minWidth;
               }
               dispatchEvent(new Event("minWidthChanged"));
            }
            if(this.minHeightChanged)
            {
               this.minHeightChanged = false;
               if(this.height < this.minHeight)
               {
                  this.height = this.minHeight;
               }
               dispatchEvent(new Event("minHeightChanged"));
            }
         }
         if(this.maxWidthChanged || this.maxHeightChanged)
         {
            if(this.maxWidthChanged)
            {
               this.maxWidthChanged = false;
               if(this.width > this.maxWidth)
               {
                  this.width = this.maxWidth;
               }
               dispatchEvent(new Event("maxWidthChanged"));
            }
            if(this.maxHeightChanged)
            {
               this.maxHeightChanged = false;
               if(this.height > this.maxHeight)
               {
                  this.height = this.maxHeight;
               }
               dispatchEvent(new Event("maxHeightChanged"));
            }
         }
         if(this.boundsChanged)
         {
            if(this._bounds.height == 0 && this.nativeWindow.displayState != NativeWindowDisplayState.MINIMIZED && this.systemChrome == NativeWindowSystemChrome.STANDARD)
            {
               this.nativeWindow.height = this.chromeHeight() + this._bounds.height;
            }
            newWidth = this._bounds.width;
            newHeight = this._bounds.height;
            systemManager.stage.stageWidth = newWidth;
            systemManager.stage.stageHeight = newHeight;
            this.boundsChanged = false;
         }
         if(this.menuChanged && !this.nativeWindow.closed)
         {
            this.menuChanged = false;
            if(this.menu == null)
            {
               if(NativeWindow.supportsMenu)
               {
                  this.nativeWindow.menu = null;
               }
            }
            else if(Boolean(this.menu.nativeMenu))
            {
               if(NativeWindow.supportsMenu)
               {
                  this.nativeWindow.menu = this.menu.nativeMenu;
               }
            }
            dispatchEvent(new Event("menuChanged"));
         }
         if(this.titleBarFactoryChanged)
         {
            if(Boolean(this._titleBar))
            {
               rawChildren.removeChild(DisplayObject(this.titleBar));
               this._titleBar = null;
            }
            this._titleBar = this.titleBarFactory.newInstance();
            this._titleBar.styleName = new StyleProxy(this,this.titleBarStyleFilters);
            rawChildren.addChild(DisplayObject(this.titleBar));
            this.titleBarFactoryChanged = false;
            invalidateDisplayList();
         }
         if(this.showTitleBarChanged)
         {
            if(Boolean(this._titleBar))
            {
               this._titleBar.visible = this._showTitleBar;
            }
            this.showTitleBarChanged = false;
         }
         if(this.titleIconChanged)
         {
            if(Boolean(this._titleBar) && "titleIcon" in this._titleBar)
            {
               this._titleBar["titleIcon"] = this._titleIcon;
            }
            this.titleIconChanged = false;
         }
         if(this.titleChanged)
         {
            if(!this.nativeWindow.closed)
            {
               systemManager.stage.nativeWindow.title = this._title;
            }
            if(Boolean(this._titleBar) && "title" in this._titleBar)
            {
               this._titleBar["title"] = this._title;
            }
            this.titleChanged = false;
         }
         if(this.statusBarFactoryChanged)
         {
            if(Boolean(this._statusBar))
            {
               rawChildren.removeChild(DisplayObject(this._statusBar));
               this._statusBar = null;
            }
            this._statusBar = this.statusBarFactory.newInstance();
            this._statusBar.styleName = new StyleProxy(this,this.statusBarStyleFilters);
            rawChildren.addChild(DisplayObject(this._statusBar));
            if(Boolean(this.gripper))
            {
               gripperIndex = int(rawChildren.getChildIndex(DisplayObject(this.gripper)));
               rawChildren.setChildIndex(DisplayObject(this._statusBar),gripperIndex);
            }
            this.statusBarFactoryChanged = false;
            this.showStatusBarChanged = true;
            this.statusChanged = true;
            invalidateDisplayList();
         }
         if(this.showStatusBarChanged)
         {
            if(Boolean(this._statusBar))
            {
               this._statusBar.visible = this._showStatusBar;
            }
            this.showStatusBarChanged = false;
         }
         if(this.statusChanged)
         {
            if(Boolean(this._statusBar) && "status" in this._statusBar)
            {
               this._statusBar["status"] = this._status;
            }
            this.statusChanged = false;
         }
         if(this.showGripperChanged)
         {
            if(Boolean(this.gripper))
            {
               this.gripper.visible = this._showGripper;
               this.gripperHit.visible = this._showGripper;
            }
            this.showGripperChanged = false;
         }
         if(this.toMax)
         {
            this.toMax = false;
            if(!this.nativeWindow.closed)
            {
               this.nativeWindow.maximize();
            }
         }
      }
      
      override protected function measure() : void
      {
         if(this.maximized)
         {
            this.maximized = false;
            if(!this.nativeWindow.closed)
            {
               systemManager.stage.nativeWindow.maximize();
            }
         }
         super.measure();
      }
      
      override public function validateDisplayList() : void
      {
         var g:Graphics = null;
         super.validateDisplayList();
         if(Capabilities.os.substring(0,3) == "Mac" && this.systemChrome == "standard")
         {
            if((Boolean(horizontalScrollBar || verticalScrollBar)) && Boolean(!(Boolean(horizontalScrollBar) && Boolean(verticalScrollBar))) && !this.showStatusBar)
            {
               if(!whiteBox)
               {
                  whiteBox = new FlexShape();
                  whiteBox.name = "whiteBox";
                  g = whiteBox.graphics;
                  g.beginFill(16777215);
                  g.drawRect(0,0,Boolean(verticalScrollBar) ? Number(verticalScrollBar.minWidth) : 15,Boolean(horizontalScrollBar) ? Number(horizontalScrollBar.minHeight) : 15);
                  g.endFill();
                  rawChildren.addChild(whiteBox);
               }
               whiteBox.visible = true;
               if(Boolean(horizontalScrollBar))
               {
                  horizontalScrollBar.setActualSize(horizontalScrollBar.width - whiteBox.width,horizontalScrollBar.height);
               }
               if(Boolean(verticalScrollBar))
               {
                  verticalScrollBar.setActualSize(verticalScrollBar.width,verticalScrollBar.height - whiteBox.height);
               }
               whiteBox.x = systemManager.stage.stageWidth - whiteBox.width;
               whiteBox.y = systemManager.stage.stageHeight - whiteBox.height;
            }
            else if(!(Boolean(horizontalScrollBar) && Boolean(verticalScrollBar)))
            {
               if(Boolean(whiteBox))
               {
                  rawChildren.removeChild(whiteBox);
                  whiteBox = null;
               }
            }
         }
         else if(Boolean(this.gripper) && Boolean(this.showGripper) && !this.showStatusBar)
         {
            if(Boolean(whiteBox))
            {
               whiteBox.visible = false;
               if(this.gripperHit.height > whiteBox.height)
               {
                  verticalScrollBar.setActualSize(verticalScrollBar.width,verticalScrollBar.height - (this.gripperHit.height - whiteBox.height));
               }
               if(this.gripperHit.width > whiteBox.width)
               {
                  horizontalScrollBar.setActualSize(horizontalScrollBar.width - (this.gripperHit.width - whiteBox.height),horizontalScrollBar.height);
               }
            }
            else if(Boolean(horizontalScrollBar))
            {
               horizontalScrollBar.setActualSize(horizontalScrollBar.width - this.gripperHit.width,horizontalScrollBar.height);
            }
            else if(Boolean(verticalScrollBar))
            {
               verticalScrollBar.setActualSize(verticalScrollBar.width,verticalScrollBar.height - this.gripperHit.height);
            }
         }
         else if(Boolean(whiteBox))
         {
            whiteBox.visible = true;
         }
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var bm:EdgeMetrics = null;
         var leftOffset:Number = NaN;
         var rightOffset:Number = NaN;
         var buttonAlign:String = null;
         var gripperPadding:Number = NaN;
         if(!this.nativeWindow.closed)
         {
            super.updateDisplayList(unscaledWidth,unscaledHeight);
            this.resizeWidth = isNaN(explicitWidth);
            this.resizeHeight = isNaN(explicitHeight);
            if(this.resizeWidth || this.resizeHeight)
            {
               this.resizeHandler(new Event(Event.RESIZE));
               validateMatrix();
               if(!this.resizeHandlerAdded)
               {
                  systemManager.addEventListener(Event.RESIZE,this.resizeHandler,false,0,true);
                  this.resizeHandlerAdded = true;
               }
            }
            else if(this.resizeHandlerAdded)
            {
               systemManager.removeEventListener(Event.RESIZE,this.resizeHandler);
               this.resizeHandlerAdded = false;
            }
            createBorder();
            bm = borderMetrics;
            leftOffset = 10;
            rightOffset = 10;
            if(Boolean(this._statusBar))
            {
               this._statusBar.move(bm.left,unscaledHeight - bm.bottom - this.getStatusBarHeight());
               this._statusBar.setActualSize(unscaledWidth - bm.left - bm.right,this.getStatusBarHeight());
            }
            if(systemManager.stage.nativeWindow.systemChrome != "none")
            {
               return;
            }
            buttonAlign = String(getStyle("buttonAlignment"));
            if(Boolean(this.titleBar))
            {
               this.titleBar.move(bm.left,bm.top);
               this.titleBar.setActualSize(unscaledWidth - bm.left - bm.right,this.getHeaderHeight());
            }
            if(Boolean(this.titleBar) && Boolean(this.controlBar))
            {
               this.controlBar.move(0,this.titleBar.height);
            }
            if(Boolean(this.gripper) && this.showGripper)
            {
               gripperPadding = Number(getStyle("gripperPadding"));
               this.gripper.setActualSize(this.gripper.measuredWidth,this.gripper.measuredHeight);
               this.gripperHit.graphics.beginFill(16777215,0.0001);
               this.gripperHit.graphics.drawRect(0,0,this.gripper.width + 2 * gripperPadding,this.gripper.height + 2 * gripperPadding);
               this.gripper.move(unscaledWidth - this.gripper.measuredWidth - gripperPadding,unscaledHeight - this.gripper.measuredHeight - gripperPadding);
               this.gripperHit.x = this.gripper.x - gripperPadding;
               this.gripperHit.y = this.gripper.y - gripperPadding;
            }
         }
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         super.styleChanged(styleProp);
         if(!this.nativeWindow.closed)
         {
            if(!(getStyle("showFlexChrome") == "false" || getStyle("showFlexChrome") == false))
            {
               if(styleProp == null || styleProp == "headerHeight" || styleProp == "gripperPadding")
               {
                  invalidateViewMetricsAndPadding();
                  invalidateDisplayList();
                  invalidateSize();
               }
            }
         }
      }
      
      override public function move(x:Number, y:Number) : void
      {
         var tmp:Rectangle = null;
         if(Boolean(this.nativeWindow) && !this.nativeWindow.closed)
         {
            tmp = this.nativeWindow.bounds;
            tmp.x = x;
            tmp.y = y;
            this.nativeWindow.bounds = tmp;
         }
      }
      
      override §§namespace("http://www.adobe.com/2006/flex/mx/internal") function initThemeColor() : Boolean
      {
         var tc:Object = null;
         var rc:Number = NaN;
         var sc:Number = NaN;
         var globalSelector:CSSStyleDeclaration = null;
         var result:Boolean = super.initThemeColor();
         if(!result)
         {
            globalSelector = styleManager.getStyleDeclaration("global");
            if(Boolean(globalSelector))
            {
               tc = globalSelector.getStyle("themeColor");
               rc = Number(globalSelector.getStyle("rollOverColor"));
               sc = Number(globalSelector.getStyle("selectionColor"));
            }
            if(Boolean(tc) && Boolean(isNaN(rc)) && isNaN(sc))
            {
               setThemeColor(tc);
            }
            result = true;
         }
         return result;
      }
      
      public function close() : void
      {
         var e:Event = null;
         if(Boolean(this._nativeWindow) && !this.nativeWindow.closed)
         {
            e = new Event("closing",false,true);
            stage.nativeWindow.dispatchEvent(e);
            if(!e.isDefaultPrevented())
            {
               removeEventListener(Event.ENTER_FRAME,this.enterFrameHandler);
               stage.nativeWindow.close();
               this._nativeWindow = null;
               systemManager.removeChild(this);
            }
         }
      }
      
      private function getHeaderHeight() : Number
      {
         if(!this.nativeWindow.closed)
         {
            if(getStyle("headerHeight") != null)
            {
               return getStyle("headerHeight");
            }
            if(!systemManager.stage)
            {
               return 0;
            }
            if(systemManager.stage.nativeWindow.systemChrome != "none")
            {
               return 0;
            }
            if(Boolean(this.titleBar))
            {
               return this.titleBar.getExplicitOrMeasuredHeight();
            }
         }
         return 0;
      }
      
      public function getStatusBarHeight() : Number
      {
         if(Boolean(this._statusBar))
         {
            return this._statusBar.getExplicitOrMeasuredHeight();
         }
         return 0;
      }
      
      private function initManagers(sm:ISystemManager) : void
      {
         var awm:IActiveWindowManager = null;
         if(sm.isTopLevel())
         {
            focusManager = new FocusManager(this);
            awm = IActiveWindowManager(sm.getImplementation("mx.managers::IActiveWindowManager"));
            if(Boolean(awm))
            {
               awm.activate(this);
            }
            else
            {
               focusManager.activate();
            }
            this._cursorManager = new CursorManagerImpl(sm);
         }
      }
      
      public function maximize() : void
      {
         var f:NativeWindowDisplayStateEvent = null;
         if(!this.nativeWindow || !this.nativeWindow.maximizable || Boolean(this.nativeWindow.closed))
         {
            return;
         }
         if(stage.nativeWindow.displayState != NativeWindowDisplayState.MAXIMIZED)
         {
            f = new NativeWindowDisplayStateEvent(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGING,false,true,stage.nativeWindow.displayState,NativeWindowDisplayState.MAXIMIZED);
            stage.nativeWindow.dispatchEvent(f);
            if(!f.isDefaultPrevented())
            {
               this.toMax = true;
               invalidateProperties();
               invalidateSize();
            }
         }
      }
      
      public function minimize() : void
      {
         var e:NativeWindowDisplayStateEvent = null;
         if(!this.minimizable)
         {
            return;
         }
         if(!this.nativeWindow.closed)
         {
            e = new NativeWindowDisplayStateEvent(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGING,false,true,this.nativeWindow.displayState,NativeWindowDisplayState.MINIMIZED);
            stage.nativeWindow.dispatchEvent(e);
            if(!e.isDefaultPrevented())
            {
               stage.nativeWindow.minimize();
            }
         }
      }
      
      public function restore() : void
      {
         var e:NativeWindowDisplayStateEvent = null;
         if(!this.nativeWindow.closed)
         {
            if(stage.nativeWindow.displayState == NativeWindowDisplayState.MAXIMIZED)
            {
               e = new NativeWindowDisplayStateEvent(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGING,false,true,NativeWindowDisplayState.MAXIMIZED,NativeWindowDisplayState.NORMAL);
               stage.nativeWindow.dispatchEvent(e);
               if(!e.isDefaultPrevented())
               {
                  this.nativeWindow.restore();
               }
            }
            else if(stage.nativeWindow.displayState == NativeWindowDisplayState.MINIMIZED)
            {
               e = new NativeWindowDisplayStateEvent(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGING,false,true,NativeWindowDisplayState.MINIMIZED,NativeWindowDisplayState.NORMAL);
               stage.nativeWindow.dispatchEvent(e);
               if(!e.isDefaultPrevented())
               {
                  this.nativeWindow.restore();
               }
            }
         }
      }
      
      public function activate() : void
      {
         if(!this.nativeWindow.closed)
         {
            this._nativeWindow.activate();
            this.visible = true;
         }
      }
      
      public function open(openWindowActive:Boolean = true) : void
      {
         if(Boolean(FlexGlobals.topLevelApplication))
         {
            FlexGlobals.topLevelApplication.dispatchEvent(new WindowExistenceEvent(WindowExistenceEvent.WINDOW_CREATING,false,false,this));
         }
         this.flagForOpen = true;
         this.openActive = openWindowActive;
         this.commitProperties();
      }
      
      public function orderInBackOf(window:IWindow) : Boolean
      {
         if(Boolean(this.nativeWindow) && !this.nativeWindow.closed)
         {
            return this.nativeWindow.orderInBackOf(window.nativeWindow);
         }
         return false;
      }
      
      public function orderInFrontOf(window:IWindow) : Boolean
      {
         if(Boolean(this.nativeWindow) && !this.nativeWindow.closed)
         {
            return this.nativeWindow.orderInFrontOf(window.nativeWindow);
         }
         return false;
      }
      
      public function orderToBack() : Boolean
      {
         if(Boolean(this.nativeWindow) && !this.nativeWindow.closed)
         {
            return this.nativeWindow.orderToBack();
         }
         return false;
      }
      
      public function orderToFront() : Boolean
      {
         if(Boolean(this.nativeWindow) && !this.nativeWindow.closed)
         {
            return this.nativeWindow.orderToFront();
         }
         return false;
      }
      
      private function chromeWidth() : Number
      {
         return this.nativeWindow.width - systemManager.stage.stageWidth;
      }
      
      private function chromeHeight() : Number
      {
         return this.nativeWindow.height - systemManager.stage.stageHeight;
      }
      
      private function startMove(event:MouseEvent) : void
      {
         addEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
         addEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
         this.prevX = event.stageX;
         this.prevY = event.stageY;
      }
      
      private function startResize(start:String) : void
      {
         if(this.resizable && !this.nativeWindow.closed)
         {
            stage.nativeWindow.startResize(start);
         }
      }
      
      private function enterFrameHandler(e:Event) : void
      {
         if(this.frameCounter == 2)
         {
            removeEventListener(Event.ENTER_FRAME,this.enterFrameHandler);
            this._nativeWindow.visible = this._nativeWindowVisible;
            dispatchEvent(new AIREvent(AIREvent.WINDOW_COMPLETE));
            if(Boolean(FlexGlobals.topLevelApplication))
            {
               FlexGlobals.topLevelApplication.dispatchEvent(new WindowExistenceEvent(WindowExistenceEvent.WINDOW_CREATE,false,false,this));
            }
            if(this._nativeWindow.visible)
            {
               if(this.openActive)
               {
                  this._nativeWindow.activate();
               }
            }
         }
         ++this.frameCounter;
      }
      
      private function hideEffectEndHandler(event:Event) : void
      {
         if(!this._nativeWindow.closed)
         {
            this._nativeWindow.visible = false;
         }
         removeEventListener(EffectEvent.EFFECT_END,this.hideEffectEndHandler);
      }
      
      private function windowMinimizeHandler(event:Event) : void
      {
         if(!this.nativeWindow.closed)
         {
            stage.nativeWindow.minimize();
         }
         removeEventListener(EffectEvent.EFFECT_END,this.windowMinimizeHandler);
      }
      
      private function windowUnminimizeHandler(event:Event) : void
      {
         removeEventListener(EffectEvent.EFFECT_END,this.windowUnminimizeHandler);
      }
      
      private function window_moveHandler(event:NativeWindowBoundsEvent) : void
      {
         var newEvent:FlexNativeWindowBoundsEvent = new FlexNativeWindowBoundsEvent(FlexNativeWindowBoundsEvent.WINDOW_MOVE,event.bubbles,event.cancelable,event.beforeBounds,event.afterBounds);
         dispatchEvent(newEvent);
      }
      
      private function window_displayStateChangeHandler(event:NativeWindowDisplayStateEvent) : void
      {
         dispatchEvent(event);
         this.height = stage.stageHeight;
         this.width = stage.stageWidth;
         if(event.beforeDisplayState == NativeWindowDisplayState.MINIMIZED)
         {
            addEventListener(EffectEvent.EFFECT_END,this.windowUnminimizeHandler);
            dispatchEvent(new Event("windowUnminimize"));
         }
      }
      
      private function window_displayStateChangingHandler(event:NativeWindowDisplayStateEvent) : void
      {
         dispatchEvent(event);
         if(event.isDefaultPrevented())
         {
            return;
         }
         if(event.afterDisplayState == NativeWindowDisplayState.MINIMIZED)
         {
            if(Boolean(getStyle("minimizeEffect")))
            {
               event.preventDefault();
               addEventListener(EffectEvent.EFFECT_END,this.windowMinimizeHandler);
               dispatchEvent(new Event("windowMinimize"));
            }
         }
      }
      
      protected function mouseDownHandler(event:MouseEvent) : void
      {
         var dragWidth:int = 0;
         var cornerSize:int = 0;
         if(systemManager.stage.nativeWindow.systemChrome != "none")
         {
            return;
         }
         if(event.target == this.gripperHit)
         {
            this.startResize(layoutDirection == "rtl" ? NativeWindowResize.BOTTOM_LEFT : NativeWindowResize.BOTTOM_RIGHT);
            event.stopPropagation();
         }
         else
         {
            dragWidth = Number(getStyle("borderThickness")) + 6;
            cornerSize = 12;
            if(event.stageY < Number(getStyle("borderThickness")))
            {
               if(event.stageX < cornerSize)
               {
                  this.startResize(NativeWindowResize.TOP_LEFT);
               }
               else if(event.stageX > this.width - cornerSize)
               {
                  this.startResize(NativeWindowResize.TOP_RIGHT);
               }
               else
               {
                  this.startResize(NativeWindowResize.TOP);
               }
            }
            else if(event.stageY > this.height - dragWidth)
            {
               if(event.stageX < cornerSize)
               {
                  this.startResize(NativeWindowResize.BOTTOM_LEFT);
               }
               else if(event.stageX > this.width - cornerSize)
               {
                  this.startResize(NativeWindowResize.BOTTOM_RIGHT);
               }
               else
               {
                  this.startResize(NativeWindowResize.BOTTOM);
               }
            }
            else if(event.stageX < dragWidth)
            {
               if(event.stageY < cornerSize)
               {
                  this.startResize(NativeWindowResize.TOP_LEFT);
               }
               else if(event.stageY > this.height - cornerSize)
               {
                  this.startResize(NativeWindowResize.BOTTOM_LEFT);
               }
               else
               {
                  this.startResize(NativeWindowResize.LEFT);
               }
               event.stopPropagation();
            }
            else if(event.stageX > this.width - dragWidth)
            {
               if(event.stageY < cornerSize)
               {
                  this.startResize(NativeWindowResize.TOP_RIGHT);
               }
               else if(event.stageY > this.height - cornerSize)
               {
                  this.startResize(NativeWindowResize.BOTTOM_RIGHT);
               }
               else
               {
                  this.startResize(NativeWindowResize.RIGHT);
               }
            }
         }
      }
      
      private function closeButton_clickHandler(event:Event) : void
      {
         if(!this.nativeWindow.closed)
         {
            stage.nativeWindow.close();
         }
      }
      
      private function resizeHandler(event:Event) : void
      {
         var w:Number = NaN;
         var h:Number = NaN;
         if(this.resizeWidth)
         {
            if(isNaN(percentWidth))
            {
               w = DisplayObject(systemManager).width;
            }
            else
            {
               super.percentWidth = Math.max(percentWidth,0);
               super.percentWidth = Math.min(percentWidth,100);
               w = percentWidth * screen.width / 100;
            }
            if(!isNaN(explicitMaxWidth))
            {
               w = Math.min(w,explicitMaxWidth);
            }
            if(!isNaN(explicitMinWidth))
            {
               w = Math.max(w,explicitMinWidth);
            }
         }
         else
         {
            w = this.width;
         }
         if(this.resizeHeight)
         {
            if(isNaN(percentHeight))
            {
               h = DisplayObject(systemManager).height;
            }
            else
            {
               super.percentHeight = Math.max(percentHeight,0);
               super.percentHeight = Math.min(percentHeight,100);
               h = percentHeight * screen.height / 100;
            }
            if(!isNaN(explicitMaxHeight))
            {
               h = Math.min(h,explicitMaxHeight);
            }
            if(!isNaN(explicitMinHeight))
            {
               h = Math.max(h,explicitMinHeight);
            }
         }
         else
         {
            h = this.height;
         }
         if(w != this.width || h != this.height)
         {
            invalidateProperties();
            invalidateSize();
         }
         setActualSize(w,h);
         invalidateDisplayList();
      }
      
      private function creationCompleteHandler(event:Event = null) : void
      {
         systemManager.stage.nativeWindow.addEventListener("closing",this.window_closingHandler);
         systemManager.stage.nativeWindow.addEventListener("close",this.window_closeHandler,false,0,true);
         systemManager.stage.nativeWindow.addEventListener(NativeWindowBoundsEvent.MOVING,this.window_boundsHandler);
         systemManager.stage.nativeWindow.addEventListener(NativeWindowBoundsEvent.MOVE,this.window_moveHandler);
         systemManager.stage.nativeWindow.addEventListener(NativeWindowBoundsEvent.RESIZING,this.window_boundsHandler);
         systemManager.stage.nativeWindow.addEventListener(NativeWindowBoundsEvent.RESIZE,this.window_resizeHandler);
      }
      
      private function preinitializeHandler(event:FlexEvent) : void
      {
         systemManager.stage.nativeWindow.addEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGING,this.window_displayStateChangingHandler);
         systemManager.stage.nativeWindow.addEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGE,this.window_displayStateChangeHandler);
      }
      
      private function mouseMoveHandler(event:MouseEvent) : void
      {
         stage.nativeWindow.x += event.stageX - this.prevX;
         stage.nativeWindow.y += event.stageY - this.prevY;
      }
      
      private function mouseUpHandler(event:MouseEvent) : void
      {
         removeEventListener(MouseEvent.MOUSE_MOVE,this.mouseMoveHandler);
         removeEventListener(MouseEvent.MOUSE_UP,this.mouseUpHandler);
      }
      
      private function window_boundsHandler(event:NativeWindowBoundsEvent) : void
      {
         var r:Rectangle = null;
         var cancel:Boolean = false;
         var newBounds:Rectangle = event.afterBounds;
         if(event.type == NativeWindowBoundsEvent.MOVING)
         {
            dispatchEvent(event);
            if(event.isDefaultPrevented())
            {
               return;
            }
         }
         else
         {
            dispatchEvent(event);
            if(event.isDefaultPrevented())
            {
               return;
            }
            cancel = false;
            if(newBounds.width < this.nativeWindow.minSize.x)
            {
               cancel = true;
               if(newBounds.x != event.beforeBounds.x && !isNaN(this.oldX))
               {
                  newBounds.x = this.oldX;
               }
               newBounds.width = this.nativeWindow.minSize.x;
            }
            else if(newBounds.width > this.nativeWindow.maxSize.x)
            {
               cancel = true;
               if(newBounds.x != event.beforeBounds.x && !isNaN(this.oldX))
               {
                  newBounds.x = this.oldX;
               }
               newBounds.width = this.nativeWindow.maxSize.x;
            }
            if(newBounds.height < this.nativeWindow.minSize.y)
            {
               cancel = true;
               if(event.afterBounds.y != event.beforeBounds.y && !isNaN(this.oldY))
               {
                  newBounds.y = this.oldY;
               }
               newBounds.height = this.nativeWindow.minSize.y;
            }
            else if(newBounds.height > this.nativeWindow.maxSize.y)
            {
               cancel = true;
               if(event.afterBounds.y != event.beforeBounds.y && !isNaN(this.oldY))
               {
                  newBounds.y = this.oldY;
               }
               newBounds.height = this.nativeWindow.maxSize.y;
            }
            if(cancel)
            {
               event.preventDefault();
               stage.nativeWindow.bounds = newBounds;
            }
         }
         this.oldX = newBounds.x;
         this.oldY = newBounds.y;
      }
      
      private function window_closeEffectEndHandler(event:Event) : void
      {
         removeEventListener(EffectEvent.EFFECT_END,this.window_closeEffectEndHandler);
         if(!this.nativeWindow.closed)
         {
            stage.nativeWindow.close();
         }
      }
      
      private function window_closingHandler(event:Event) : void
      {
         var e:Event = new Event("closing",true,true);
         dispatchEvent(e);
         if(e.isDefaultPrevented())
         {
            event.preventDefault();
         }
         else if(Boolean(getStyle("closeEffect")) && stage.nativeWindow.transparent == true)
         {
            addEventListener(EffectEvent.EFFECT_END,this.window_closeEffectEndHandler);
            dispatchEvent(new Event("windowClose"));
            event.preventDefault();
         }
      }
      
      private function window_closeHandler(event:Event) : void
      {
         dispatchEvent(new Event("close"));
         if(Boolean(FlexGlobals.topLevelApplication))
         {
            FlexGlobals.topLevelApplication.dispatchEvent(new WindowExistenceEvent(WindowExistenceEvent.WINDOW_CLOSE,false,false,this));
         }
      }
      
      private function window_resizeHandler(event:NativeWindowBoundsEvent) : void
      {
         invalidateViewMetricsAndPadding();
         invalidateDisplayList();
         var dispatchWidthChangeEvent:Boolean = this.bounds.width != stage.stageWidth;
         var dispatchHeightChangeEvent:Boolean = this.bounds.height != stage.stageHeight;
         this.bounds.x = stage.x;
         this.bounds.y = stage.y;
         this.bounds.width = stage.stageWidth;
         this.bounds.height = stage.stageHeight;
         validateNow();
         var e:FlexNativeWindowBoundsEvent = new FlexNativeWindowBoundsEvent(FlexNativeWindowBoundsEvent.WINDOW_RESIZE,event.bubbles,event.cancelable,event.beforeBounds,event.afterBounds);
         dispatchEvent(e);
         if(dispatchWidthChangeEvent)
         {
            dispatchEvent(new Event("widthChanged"));
         }
         if(dispatchHeightChangeEvent)
         {
            dispatchEvent(new Event("heightChanged"));
         }
      }
      
      private function nativeApplication_activateHandler(event:Event) : void
      {
         dispatchEvent(new AIREvent(AIREvent.APPLICATION_ACTIVATE));
      }
      
      private function nativeApplication_deactivateHandler(event:Event) : void
      {
         dispatchEvent(new AIREvent(AIREvent.APPLICATION_DEACTIVATE));
      }
      
      private function nativeWindow_activateHandler(event:Event) : void
      {
         dispatchEvent(new AIREvent(AIREvent.WINDOW_ACTIVATE));
      }
      
      private function nativeWindow_deactivateHandler(event:Event) : void
      {
         dispatchEvent(new AIREvent(AIREvent.WINDOW_DEACTIVATE));
      }
      
      private function nativeApplication_networkChangeHandler(event:Event) : void
      {
         dispatchEvent(event);
      }
   }
}

