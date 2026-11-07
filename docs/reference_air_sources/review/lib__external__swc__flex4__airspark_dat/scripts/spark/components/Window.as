package spark.components
{
   import flash.desktop.NativeApplication;
   import flash.display.DisplayObject;
   import flash.display.NativeWindow;
   import flash.display.NativeWindowDisplayState;
   import flash.display.NativeWindowInitOptions;
   import flash.display.NativeWindowResize;
   import flash.display.NativeWindowSystemChrome;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.events.NativeWindowBoundsEvent;
   import flash.events.NativeWindowDisplayStateEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.controls.FlexNativeMenu;
   import mx.core.FlexGlobals;
   import mx.core.IVisualElement;
   import mx.core.IWindow;
   import mx.core.UIComponent;
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
   import spark.components.supportClasses.TextBase;
   import spark.components.windowClasses.TitleBar;
   
   [ResourceBundle("core")]
   [IconFile("Window.png")]
   [Frame(factoryClass="mx.managers.WindowedSystemManager")]
   [SkinState("disabledAndInactive")]
   [SkinState("normalAndInactive")]
   [Exclude(name="moveEffect",kind="effect")]
   [Effect(name="unminimizeEffect",event="windowUnminimize")]
   [Effect(name="minimizeEffect",event="windowMinimize")]
   [Effect(name="closeEffect",event="windowClose")]
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
   [Style(name="resizeAffordanceWidth",type="Number",format="length",inherit="no")]
   [Style(name="backgroundColor",type="uint",format="Color",inherit="no")]
   [Style(name="backgroundAlpha",type="Number",inherit="no")]
   public class Window extends SkinnableContainer implements IWindow
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static const DEFAULT_WINDOW_HEIGHT:Number = 100;
      
      private static const DEFAULT_WINDOW_WIDTH:Number = 100;
      
      private static var _skinParts:Object = {
         "contentGroup":false,
         "statusBar":false,
         "gripper":false,
         "statusText":false,
         "titleBar":false
      };
      
      private var _nativeWindow:NativeWindow;
      
      private var _nativeWindowVisible:Boolean = true;
      
      private var maximized:Boolean = false;
      
      private var _cursorManager:ICursorManager;
      
      private var toMax:Boolean = false;
      
      private var frameCounter:int = 0;
      
      private var flagForOpen:Boolean = false;
      
      private var openActive:Boolean = true;
      
      private var oldX:Number;
      
      private var oldY:Number;
      
      private var prevX:Number;
      
      private var prevY:Number;
      
      private var resizeWidth:Boolean = true;
      
      private var resizeHeight:Boolean = true;
      
      [SkinPart(required="false")]
      public var gripper:Button;
      
      [SkinPart(required="false")]
      public var statusBar:IVisualElement;
      
      [SkinPart(required="false")]
      public var statusText:TextBase;
      
      [SkinPart(required="false")]
      public var titleBar:TitleBar;
      
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
      
      private var _maximizable:Boolean = true;
      
      private var _menu:FlexNativeMenu;
      
      private var menuChanged:Boolean = false;
      
      private var _minimizable:Boolean = true;
      
      private var _renderMode:String = "auto";
      
      private var _resizable:Boolean = true;
      
      private var _showStatusBar:Boolean = true;
      
      private var showStatusBarChanged:Boolean = true;
      
      private var _status:String = "";
      
      private var statusChanged:Boolean = false;
      
      private var _systemChrome:String = "standard";
      
      private var _title:String = "";
      
      private var titleChanged:Boolean = false;
      
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
         dispatchEvent(new Event("widthChanged"));
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
      }
      
      public function get closed() : Boolean
      {
         return this.nativeWindow.closed;
      }
      
      [Inspectable(enumeration="default,off,on",defaultValue="default")]
      public function get colorCorrection() : String
      {
         var sm:ISystemManager = null;
         try
         {
            sm = systemManager;
            if(Boolean(sm) && Boolean(sm.stage))
            {
               return sm.stage.colorCorrection;
            }
         }
         catch(e:SecurityError)
         {
         }
         return null;
      }
      
      public function set colorCorrection(value:String) : void
      {
         var sm:ISystemManager = systemManager;
         if(Boolean(sm) && Boolean(sm.stage) && Boolean(sm.isTopLevelRoot()))
         {
            sm.stage.colorCorrection = value;
         }
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
      
      [Inspectable(category="General",enumeration="auto,cpu,direct")]
      public function get renderMode() : String
      {
         return this._renderMode;
      }
      
      public function set renderMode(value:String) : void
      {
         if(!this._nativeWindow)
         {
            this._renderMode = value;
            invalidateProperties();
         }
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
         dispatchEvent(new Event("statusChanged"));
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
         invalidateDisplayList();
         dispatchEvent(new Event("titleChanged"));
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
      
      override protected function createChildren() : void
      {
         this.width = this._bounds.width;
         this.height = this._bounds.height;
         super.createChildren();
      }
      
      protected function setupWindowInitOptions() : NativeWindowInitOptions
      {
         var init:NativeWindowInitOptions = new NativeWindowInitOptions();
         init.maximizable = this._maximizable;
         init.minimizable = this._minimizable;
         init.resizable = this._resizable;
         init.type = this._type;
         init.systemChrome = this._systemChrome;
         init.transparent = this._transparent;
         init.renderMode = this._renderMode;
         return init;
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
         if(this.flagForOpen && !this._nativeWindow)
         {
            this.flagForOpen = false;
            if(moduleFactory == null)
            {
               moduleFactory = SystemManagerGlobals.topLevelSystemManagers[0];
            }
            init = this.setupWindowInitOptions();
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
            nativeApplication.addEventListener(Event.NETWORK_CHANGE,dispatchEvent,false,0,true);
            this._nativeWindow.addEventListener(Event.ACTIVATE,this.nativeWindow_activateHandler,false,0,true);
            this._nativeWindow.addEventListener(Event.DEACTIVATE,this.nativeWindow_deactivateHandler,false,0,true);
            addEventListener(Event.ENTER_FRAME,this.enterFrameHandler);
            sm.addWindow(this);
         }
         super.commitProperties();
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
            setActualSize(this._bounds.width,this._bounds.height);
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
         if(this.titleIconChanged)
         {
            if(Boolean(this.titleBar))
            {
               this.titleBar.titleIcon = this._titleIcon;
            }
            this.titleIconChanged = false;
         }
         if(this.titleChanged)
         {
            if(!this.nativeWindow.closed)
            {
               systemManager.stage.nativeWindow.title = this._title;
            }
            if(Boolean(this.titleBar))
            {
               this.titleBar.title = this._title;
            }
            this.titleChanged = false;
         }
         if(this.showStatusBarChanged)
         {
            if(Boolean(this.statusBar))
            {
               this.statusBar.visible = this._showStatusBar;
            }
            this.showStatusBarChanged = false;
         }
         if(this.statusChanged)
         {
            if(Boolean(this.statusText))
            {
               this.statusText.text = this._status;
            }
            this.statusChanged = false;
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
      
      override protected function partAdded(partName:String, instance:Object) : void
      {
         super.partAdded(partName,instance);
         if(instance == this.statusBar)
         {
            this.statusBar.visible = this._showStatusBar;
            this.statusBar.includeInLayout = this._showStatusBar;
            this.showStatusBarChanged = false;
         }
         else if(instance == this.titleBar)
         {
            if(!this.nativeWindow.closed)
            {
               if(this._title == "" && systemManager.stage.nativeWindow.title != null)
               {
                  this._title = systemManager.stage.nativeWindow.title;
               }
               else
               {
                  systemManager.stage.nativeWindow.title = this._title;
               }
            }
            this.titleBar.title = this._title;
            this.titleChanged = false;
         }
         else if(instance == this.statusText)
         {
            this.statusText.text = this.status;
            this.statusChanged = false;
         }
         else if(instance == this.gripper)
         {
            this.gripper.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
         }
      }
      
      override protected function partRemoved(partName:String, instance:Object) : void
      {
         super.partRemoved(partName,instance);
         if(instance == this.gripper)
         {
            this.gripper.removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseDownHandler);
         }
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
      
      override protected function getCurrentSkinState() : String
      {
         if(this.nativeWindow.closed)
         {
            return "disabled";
         }
         if(this.nativeWindow.active)
         {
            return enabled ? "normal" : "disabled";
         }
         return enabled ? "normalAndInactive" : "disabledAndInactive";
      }
      
      private function chromeWidth() : Number
      {
         return this.nativeWindow.width - systemManager.stage.stageWidth;
      }
      
      private function chromeHeight() : Number
      {
         return this.nativeWindow.height - systemManager.stage.stageHeight;
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
         if(event.afterDisplayState == NativeWindowDisplayState.MAXIMIZED || event.afterDisplayState == NativeWindowDisplayState.NORMAL)
         {
            invalidateSize();
            invalidateDisplayList();
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
         if(event.target == this.gripper)
         {
            this.startResize(layoutDirection == "rtl" ? NativeWindowResize.BOTTOM_LEFT : NativeWindowResize.BOTTOM_RIGHT);
            event.stopPropagation();
            return;
         }
         if(systemManager.stage.nativeWindow.systemChrome != "none")
         {
            return;
         }
         var edgeOrCorner:String = this.hitTestResizeEdge(event);
         if(edgeOrCorner != NativeWindowResize.NONE)
         {
            this.startResize(edgeOrCorner);
            event.stopPropagation();
         }
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function hitTestResizeEdge(event:MouseEvent) : String
      {
         var o:DisplayObject = null;
         if(event.target is DisplayObject && event.target != contentGroup)
         {
            o = DisplayObject(event.target);
            while(Boolean(o) && Boolean(o != contentGroup) && o != this)
            {
               o = o.parent;
            }
            if(o == null || o == contentGroup)
            {
               return NativeWindowResize.NONE;
            }
         }
         var hitTestResults:String = NativeWindowResize.NONE;
         var resizeAfforanceWidth:Number = Number(getStyle("resizeAffordanceWidth"));
         var borderWidth:int = resizeAfforanceWidth;
         var cornerSize:int = resizeAfforanceWidth * 2;
         if(event.stageY < borderWidth)
         {
            if(event.stageX < cornerSize)
            {
               hitTestResults = NativeWindowResize.TOP_LEFT;
            }
            else if(event.stageX > this.width - cornerSize)
            {
               hitTestResults = NativeWindowResize.TOP_RIGHT;
            }
            else
            {
               hitTestResults = NativeWindowResize.TOP;
            }
         }
         else if(event.stageY > this.height - borderWidth)
         {
            if(event.stageX < cornerSize)
            {
               hitTestResults = NativeWindowResize.BOTTOM_LEFT;
            }
            else if(event.stageX > this.width - cornerSize)
            {
               hitTestResults = NativeWindowResize.BOTTOM_RIGHT;
            }
            else
            {
               hitTestResults = NativeWindowResize.BOTTOM;
            }
         }
         else if(event.stageX < borderWidth)
         {
            if(event.stageY < cornerSize)
            {
               hitTestResults = NativeWindowResize.TOP_LEFT;
            }
            else if(event.stageY > this.height - cornerSize)
            {
               hitTestResults = NativeWindowResize.BOTTOM_LEFT;
            }
            else
            {
               hitTestResults = NativeWindowResize.LEFT;
            }
         }
         else if(event.stageX > this.width - borderWidth)
         {
            if(event.stageY < cornerSize)
            {
               hitTestResults = NativeWindowResize.TOP_RIGHT;
            }
            else if(event.stageY > this.height - cornerSize)
            {
               hitTestResults = NativeWindowResize.BOTTOM_RIGHT;
            }
            else
            {
               hitTestResults = NativeWindowResize.RIGHT;
            }
         }
         return hitTestResults;
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
         if(stage == null)
         {
            return;
         }
         invalidateDisplayList();
         var dispatchWidthChangeEvent:Boolean = this.bounds.width != stage.stageWidth;
         var dispatchHeightChangeEvent:Boolean = this.bounds.height != stage.stageHeight;
         this.bounds.x = stage.x;
         this.bounds.y = stage.y;
         this.bounds.width = stage.stageWidth;
         this.bounds.height = stage.stageHeight;
         setActualSize(this._bounds.width,this._bounds.height);
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
         invalidateSkinState();
      }
      
      private function nativeWindow_deactivateHandler(event:Event) : void
      {
         dispatchEvent(new AIREvent(AIREvent.WINDOW_DEACTIVATE));
         invalidateSkinState();
      }
   }
}

