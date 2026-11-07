package mx.core
{
   import flash.desktop.DockIcon;
   import flash.desktop.NativeApplication;
   import flash.desktop.SystemTrayIcon;
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.NativeWindow;
   import flash.display.NativeWindowDisplayState;
   import flash.display.NativeWindowResize;
   import flash.display.NativeWindowSystemChrome;
   import flash.display.NativeWindowType;
   import flash.display.Screen;
   import flash.display.Sprite;
   import flash.display.StageDisplayState;
   import flash.events.Event;
   import flash.events.FullScreenEvent;
   import flash.events.InvokeEvent;
   import flash.events.MouseEvent;
   import flash.events.NativeWindowBoundsEvent;
   import flash.events.NativeWindowDisplayStateEvent;
   import flash.filesystem.File;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.system.Capabilities;
   import mx.controls.Alert;
   import mx.controls.Button;
   import mx.controls.FlexNativeMenu;
   import mx.controls.HTML;
   import mx.core.windowClasses.StatusBar;
   import mx.core.windowClasses.TitleBar;
   import mx.events.AIREvent;
   import mx.events.EffectEvent;
   import mx.events.FlexEvent;
   import mx.events.FlexNativeWindowBoundsEvent;
   import mx.managers.DragManager;
   import mx.managers.NativeDragManagerImpl;
   import mx.styles.CSSStyleDeclaration;
   import mx.styles.StyleManager;
   import mx.styles.StyleProxy;
   
   [ResourceBundle("core")]
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
   [Style(name="statusBarBackgroundColor",type="uint",format="Color",inherit="yes")]
   [Style(name="statusBarBackgroundSkin",type="Class",inherit="yes")]
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
   [Event(name="invoke",type="flash.events.InvokeEvent")]
   [Event(name="displayStateChanging",type="flash.events.NativeWindowDisplayStateEvent")]
   [Event(name="displayStateChange",type="flash.events.NativeWindowDisplayStateEvent")]
   [Event(name="closing",type="flash.events.Event")]
   [Event(name="close",type="flash.events.Event")]
   [Event(name="windowDeactivate",type="mx.events.AIREvent")]
   [Event(name="windowActivate",type="mx.events.AIREvent")]
   [Event(name="applicationDeactivate",type="mx.events.AIREvent")]
   [Event(name="applicationActivate",type="mx.events.AIREvent")]
   public class WindowedApplication extends Application implements IWindow
   {
      
      private static var _forceLinkNDMI:NativeDragManagerImpl;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "3.6.0.12937";
      
      private static const HEADER_PADDING:Number = 4;
      
      private static const MOUSE_SLACK:Number = 5;
      
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
      
      private var showGripperChanged:Boolean = true;
      
      private var shouldShowTitleBar:Boolean;
      
      private var invokesPending:Boolean = true;
      
      private var _maxWidth:Number = 0;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var titleBarBackground:IFlexDisplayObject;
      
      private var _maxHeight:Number = 0;
      
      private var windowBoundsChanged:Boolean = true;
      
      private var _menu:FlexNativeMenu;
      
      private var boundsChanged:Boolean = false;
      
      private var _showStatusBar:Boolean = true;
      
      private var minHeightChanged:Boolean = false;
      
      private var menuChanged:Boolean = false;
      
      private var statusChanged:Boolean = false;
      
      private var titleIconChanged:Boolean = false;
      
      private var prevX:Number;
      
      private var prevY:Number;
      
      private var maxHeightChanged:Boolean = false;
      
      private var gripper:Button;
      
      private var _showTitleBar:Boolean = true;
      
      private var _minHeight:Number = 0;
      
      private var lastDisplayState:String = "normal";
      
      private var _dockIconMenu:FlexNativeMenu;
      
      private var _nativeWindow:NativeWindow;
      
      private var _nativeWindowVisible:Boolean = true;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var statusBarBackground:IFlexDisplayObject;
      
      private var showTitleBarChanged:Boolean = true;
      
      private var toMax:Boolean = false;
      
      private var _alwaysInFront:Boolean = false;
      
      private var gripperHit:Sprite;
      
      private var _showGripper:Boolean = true;
      
      private var oldX:Number;
      
      private var oldY:Number;
      
      private var initialInvokes:Array;
      
      private var _status:String = "";
      
      private var ucCount:Number = 0;
      
      private var _gripperPadding:Number = 3;
      
      private var _systemTrayIconMenu:FlexNativeMenu;
      
      private var _statusBar:UIComponent;
      
      private var titleChanged:Boolean = false;
      
      private var _title:String = "";
      
      private var _statusBarFactory:IFactory = new ClassFactory(StatusBar);
      
      private var statusBarFactoryChanged:Boolean = false;
      
      private var _titleIcon:Class;
      
      private var appViewMetrics:EdgeMetrics;
      
      private var minWidthChanged:Boolean = false;
      
      private var maxWidthChanged:Boolean = false;
      
      private var activateOnOpen:Boolean = true;
      
      private var _titleBarFactory:IFactory = new ClassFactory(TitleBar);
      
      private var titleBarFactoryChanged:Boolean = false;
      
      private var showStatusBarChanged:Boolean = true;
      
      private var _bounds:Rectangle = new Rectangle(0,0,0,0);
      
      private var _minWidth:Number = 0;
      
      private var _titleBar:UIComponent;
      
      public function WindowedApplication()
      {
         super();
         addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
         addEventListener(FlexEvent.PREINITIALIZE,preinitializeHandler);
         addEventListener(FlexEvent.UPDATE_COMPLETE,updateComplete_handler);
         addEventListener(FlexEvent.CREATION_COMPLETE,creationCompleteHandler);
         var nativeApplication:NativeApplication = NativeApplication.nativeApplication;
         nativeApplication.addEventListener(Event.ACTIVATE,nativeApplication_activateHandler);
         nativeApplication.addEventListener(Event.DEACTIVATE,nativeApplication_deactivateHandler);
         nativeApplication.addEventListener(Event.NETWORK_CHANGE,nativeApplication_networkChangeHandler);
         nativeApplication.addEventListener(InvokeEvent.INVOKE,nativeApplication_invokeHandler);
         initialInvokes = new Array();
         DragManager.isDragging;
      }
      
      public function orderInBackOf(window:IWindow) : Boolean
      {
         if(Boolean(nativeWindow) && !nativeWindow.closed)
         {
            return nativeWindow.orderInBackOf(window.nativeWindow);
         }
         return false;
      }
      
      public function set statusBarFactory(value:IFactory) : void
      {
         _statusBarFactory = value;
         statusBarFactoryChanged = true;
         invalidateProperties();
         dispatchEvent(new Event("statusBarFactoryChanged"));
      }
      
      private function enterFrameHandler(e:Event) : void
      {
         removeEventListener(Event.ENTER_FRAME,enterFrameHandler);
         if(stage.nativeWindow.closed)
         {
            return;
         }
         stage.nativeWindow.visible = _nativeWindowVisible;
         dispatchEvent(new AIREvent(AIREvent.WINDOW_COMPLETE));
         dispatchPendingInvokes();
         if(_nativeWindowVisible && activateOnOpen)
         {
            stage.nativeWindow.activate();
         }
         stage.nativeWindow.alwaysInFront = _alwaysInFront;
      }
      
      [Bindable("windowComplete")]
      [Bindable("minHeightChanged")]
      override public function get minHeight() : Number
      {
         if(Boolean(nativeWindow) && !minHeightChanged)
         {
            return nativeWindow.minSize.y - chromeHeight();
         }
         return _minHeight;
      }
      
      private function window_closeHandler(event:Event) : void
      {
         dispatchEvent(new Event("close"));
      }
      
      private function nativeApplication_deactivateHandler(event:Event) : void
      {
         dispatchEvent(new AIREvent(AIREvent.APPLICATION_DEACTIVATE));
      }
      
      override public function set minHeight(value:Number) : void
      {
         _minHeight = value;
         minHeightChanged = true;
         invalidateProperties();
      }
      
      private function chromeHeight() : Number
      {
         return nativeWindow.height - systemManager.stage.stageHeight;
      }
      
      public function get showStatusBar() : Boolean
      {
         return _showStatusBar;
      }
      
      override public function set height(value:Number) : void
      {
         if(value < minHeight)
         {
            value = minHeight;
         }
         else if(value > maxHeight)
         {
            value = maxHeight;
         }
         _bounds.height = value;
         boundsChanged = true;
         invalidateProperties();
         invalidateSize();
         invalidateViewMetricsAndPadding();
      }
      
      private function mouseMoveHandler(event:MouseEvent) : void
      {
         stage.nativeWindow.x += event.stageX - prevX;
         stage.nativeWindow.y += event.stageY - prevY;
      }
      
      [Bindable("titleChanged")]
      public function get title() : String
      {
         return _title;
      }
      
      protected function mouseDownHandler(event:MouseEvent) : void
      {
         var dragWidth:int = 0;
         var cornerSize:int = 0;
         if(systemManager.stage.nativeWindow.systemChrome != "none")
         {
            return;
         }
         if(event.target == gripperHit)
         {
            startResize(NativeWindowResize.BOTTOM_RIGHT);
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
                  startResize(NativeWindowResize.TOP_LEFT);
               }
               else if(event.stageX > width - cornerSize)
               {
                  startResize(NativeWindowResize.TOP_RIGHT);
               }
               else
               {
                  startResize(NativeWindowResize.TOP);
               }
            }
            else if(event.stageY > height - dragWidth)
            {
               if(event.stageX < cornerSize)
               {
                  startResize(NativeWindowResize.BOTTOM_LEFT);
               }
               else if(event.stageX > width - cornerSize)
               {
                  startResize(NativeWindowResize.BOTTOM_RIGHT);
               }
               else
               {
                  startResize(NativeWindowResize.BOTTOM);
               }
            }
            else if(event.stageX < dragWidth)
            {
               if(event.stageY < cornerSize)
               {
                  startResize(NativeWindowResize.TOP_LEFT);
               }
               else if(event.stageY > height - cornerSize)
               {
                  startResize(NativeWindowResize.BOTTOM_LEFT);
               }
               else
               {
                  startResize(NativeWindowResize.LEFT);
               }
               event.stopPropagation();
            }
            else if(event.stageX > width - dragWidth)
            {
               if(event.stageY < cornerSize)
               {
                  startResize(NativeWindowResize.TOP_RIGHT);
               }
               else if(event.stageY > height - cornerSize)
               {
                  startResize(NativeWindowResize.BOTTOM_RIGHT);
               }
               else
               {
                  startResize(NativeWindowResize.RIGHT);
               }
            }
         }
      }
      
      override public function get viewMetrics() : EdgeMetrics
      {
         var hHeight:Number = NaN;
         var sHeight:Number = NaN;
         var bm:EdgeMetrics = super.viewMetrics;
         var vm:EdgeMetrics = new EdgeMetrics(bm.left,bm.top,bm.right,bm.bottom);
         if(showTitleBar)
         {
            hHeight = getHeaderHeight();
            if(!isNaN(hHeight))
            {
               vm.top += hHeight;
            }
         }
         if(_showStatusBar)
         {
            sHeight = getStatusBarHeight();
            if(!isNaN(sHeight))
            {
               vm.bottom += sHeight;
            }
         }
         return vm;
      }
      
      private function window_moveHandler(event:NativeWindowBoundsEvent) : void
      {
         dispatchEvent(new FlexNativeWindowBoundsEvent(FlexNativeWindowBoundsEvent.WINDOW_MOVE,event.bubbles,event.cancelable,event.beforeBounds,event.afterBounds));
      }
      
      public function get applicationID() : String
      {
         return nativeApplication.applicationID;
      }
      
      protected function get statusBarStyleFilters() : Object
      {
         return _statusBarStyleFilters;
      }
      
      [Bindable("windowComplete")]
      [Bindable("show")]
      [Bindable("hide")]
      override public function get visible() : Boolean
      {
         if(Boolean(nativeWindow) && Boolean(nativeWindow.closed))
         {
            return false;
         }
         if(Boolean(nativeWindow))
         {
            return nativeWindow.visible;
         }
         return _nativeWindowVisible;
      }
      
      public function get minimizable() : Boolean
      {
         if(!nativeWindow.closed)
         {
            return nativeWindow.minimizable;
         }
         return false;
      }
      
      private function dispatchPendingInvokes() : void
      {
         var event:InvokeEvent = null;
         invokesPending = false;
         for each(event in initialInvokes)
         {
            dispatchEvent(event);
         }
         initialInvokes = null;
      }
      
      public function restore() : void
      {
         var e:NativeWindowDisplayStateEvent = null;
         if(!nativeWindow.closed)
         {
            if(stage.nativeWindow.displayState == NativeWindowDisplayState.MAXIMIZED)
            {
               e = new NativeWindowDisplayStateEvent(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGING,false,true,NativeWindowDisplayState.MAXIMIZED,NativeWindowDisplayState.NORMAL);
               stage.nativeWindow.dispatchEvent(e);
               if(!e.isDefaultPrevented())
               {
                  nativeWindow.restore();
               }
            }
            else if(stage.nativeWindow.displayState == NativeWindowDisplayState.MINIMIZED)
            {
               e = new NativeWindowDisplayStateEvent(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGING,false,true,NativeWindowDisplayState.MINIMIZED,NativeWindowDisplayState.NORMAL);
               stage.nativeWindow.dispatchEvent(e);
               if(!e.isDefaultPrevented())
               {
                  nativeWindow.restore();
               }
            }
         }
      }
      
      public function set showStatusBar(value:Boolean) : void
      {
         if(_showStatusBar == value)
         {
            return;
         }
         _showStatusBar = value;
         showStatusBarChanged = true;
         invalidateProperties();
         invalidateDisplayList();
      }
      
      private function getHeaderHeight() : Number
      {
         if(!nativeWindow.closed)
         {
            if(getStyle("headerHeight") != null)
            {
               return getStyle("headerHeight");
            }
            if(systemManager.stage.nativeWindow.systemChrome != "none")
            {
               return 0;
            }
            if(Boolean(titleBar))
            {
               return titleBar.getExplicitOrMeasuredHeight();
            }
         }
         return 0;
      }
      
      [Bindable("windowComplete")]
      [Bindable("minWidthChanged")]
      override public function get minWidth() : Number
      {
         if(Boolean(nativeWindow) && !minWidthChanged)
         {
            return nativeWindow.minSize.x - chromeWidth();
         }
         return _minWidth;
      }
      
      public function get systemTrayIconMenu() : FlexNativeMenu
      {
         return _systemTrayIconMenu;
      }
      
      public function minimize() : void
      {
         var e:NativeWindowDisplayStateEvent = null;
         if(!nativeWindow.closed)
         {
            e = new NativeWindowDisplayStateEvent(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGING,false,true,nativeWindow.displayState,NativeWindowDisplayState.MINIMIZED);
            stage.nativeWindow.dispatchEvent(e);
            if(!e.isDefaultPrevented())
            {
               stage.nativeWindow.minimize();
            }
         }
      }
      
      public function get titleBar() : UIComponent
      {
         return _titleBar;
      }
      
      public function get resizable() : Boolean
      {
         if(nativeWindow.closed)
         {
            return false;
         }
         return nativeWindow.resizable;
      }
      
      private function nativeApplication_invokeHandler(event:InvokeEvent) : void
      {
         if(invokesPending)
         {
            initialInvokes.push(event);
         }
         else
         {
            dispatchEvent(event);
         }
      }
      
      protected function get bounds() : Rectangle
      {
         return nativeWindow.bounds;
      }
      
      public function set title(value:String) : void
      {
         _title = value;
         titleChanged = true;
         invalidateProperties();
         invalidateSize();
         invalidateViewMetricsAndPadding();
         invalidateDisplayList();
         dispatchEvent(new Event("titleChanged"));
      }
      
      public function get showTitleBar() : Boolean
      {
         return _showTitleBar;
      }
      
      public function get nativeApplication() : NativeApplication
      {
         return NativeApplication.nativeApplication;
      }
      
      override protected function menuItemSelectHandler(event:Event) : void
      {
         var screenRect:Rectangle = null;
         var screenWidth:int = 0;
         var screenHeight:int = 0;
         var minDim:Number = NaN;
         var winWidth:int = 0;
         var winHeight:int = 0;
         var winX:int = 0;
         var winY:int = 0;
         var html:HTML = null;
         var win:Window = null;
         var vsLoc:File = File.applicationDirectory.resolvePath(viewSourceURL);
         if(vsLoc.exists)
         {
            screenRect = Screen.mainScreen.visibleBounds;
            screenWidth = screenRect.width;
            screenHeight = screenRect.height;
            minDim = Math.min(screenWidth,screenHeight);
            winWidth = minDim * 0.9;
            winHeight = winWidth * 0.618;
            winX = (screenWidth - winWidth) / 2;
            winY = (screenHeight - winHeight) / 2;
            html = new HTML();
            html.width = winWidth;
            html.height = winHeight;
            html.location = vsLoc.url;
            win = new Window();
            win.type = NativeWindowType.UTILITY;
            win.systemChrome = NativeWindowSystemChrome.STANDARD;
            win.title = resourceManager.getString("core","viewSource");
            win.width = winWidth;
            win.height = winHeight;
            win.addChild(html);
            win.addEventListener(FlexNativeWindowBoundsEvent.WINDOW_RESIZE,viewSourceResizeHandler(html),false,0,true);
            html.htmlLoader.navigateInSystemBrowser = true;
            addEventListener(Event.CLOSING,viewSourceCloseHandler(win),false,0,true);
            win.open();
            win.move(winX,winY);
         }
         else
         {
            Alert.show(resourceManager.getString("core","badFile"));
         }
      }
      
      private function viewSourceResizeHandler(html:HTML) : Function
      {
         return function(e:FlexNativeWindowBoundsEvent):void
         {
            var win:* = e.target;
            html.width = win.width;
            html.height = win.height;
         };
      }
      
      public function set menu(value:FlexNativeMenu) : void
      {
         _menu = value;
         menuChanged = true;
      }
      
      public function get statusBar() : UIComponent
      {
         return _statusBar;
      }
      
      [Bindable("windowComplete")]
      [Bindable("maxWidthChanged")]
      override public function get maxWidth() : Number
      {
         if(Boolean(nativeWindow) && !maxWidthChanged)
         {
            return nativeWindow.maxSize.x - chromeWidth();
         }
         return _maxWidth;
      }
      
      private function windowMinimizeHandler(event:Event) : void
      {
         if(!nativeWindow.closed)
         {
            stage.nativeWindow.minimize();
         }
         removeEventListener(EffectEvent.EFFECT_END,windowMinimizeHandler);
      }
      
      public function get dockIconMenu() : FlexNativeMenu
      {
         return _dockIconMenu;
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
            if(newBounds.width < nativeWindow.minSize.x)
            {
               cancel = true;
               if(newBounds.x != event.beforeBounds.x && !isNaN(oldX))
               {
                  newBounds.x = oldX;
               }
               newBounds.width = nativeWindow.minSize.x;
            }
            else if(newBounds.width > nativeWindow.maxSize.x)
            {
               cancel = true;
               if(newBounds.x != event.beforeBounds.x && !isNaN(oldX))
               {
                  newBounds.x = oldX;
               }
               newBounds.width = nativeWindow.maxSize.x;
            }
            if(newBounds.height < nativeWindow.minSize.y)
            {
               cancel = true;
               if(event.afterBounds.y != event.beforeBounds.y && !isNaN(oldY))
               {
                  newBounds.y = oldY;
               }
               newBounds.height = nativeWindow.minSize.y;
            }
            else if(newBounds.height > nativeWindow.maxSize.y)
            {
               cancel = true;
               if(event.afterBounds.y != event.beforeBounds.y && !isNaN(oldY))
               {
                  newBounds.y = oldY;
               }
               newBounds.height = nativeWindow.maxSize.y;
            }
            if(cancel)
            {
               event.preventDefault();
               stage.nativeWindow.bounds = newBounds;
               windowBoundsChanged = true;
               invalidateProperties();
            }
         }
         oldX = newBounds.x;
         oldY = newBounds.y;
      }
      
      public function get showGripper() : Boolean
      {
         return _showGripper;
      }
      
      public function maximize() : void
      {
         var f:NativeWindowDisplayStateEvent = null;
         if(!nativeWindow || !nativeWindow.maximizable || Boolean(nativeWindow.closed))
         {
            return;
         }
         if(systemManager.stage.nativeWindow.displayState != NativeWindowDisplayState.MAXIMIZED)
         {
            f = new NativeWindowDisplayStateEvent(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGING,false,true,systemManager.stage.nativeWindow.displayState,NativeWindowDisplayState.MAXIMIZED);
            systemManager.stage.nativeWindow.dispatchEvent(f);
            if(!f.isDefaultPrevented())
            {
               invalidateProperties();
               invalidateSize();
               invalidateDisplayList();
               toMax = true;
            }
         }
      }
      
      private function windowMaximizeHandler(event:Event) : void
      {
         removeEventListener(EffectEvent.EFFECT_END,windowMaximizeHandler);
         if(!nativeWindow.closed)
         {
            stage.nativeWindow.maximize();
         }
      }
      
      public function set autoExit(value:Boolean) : void
      {
         nativeApplication.autoExit = value;
      }
      
      private function nativeWindow_deactivateHandler(event:Event) : void
      {
         dispatchEvent(new AIREvent(AIREvent.WINDOW_DEACTIVATE));
      }
      
      public function get nativeWindow() : NativeWindow
      {
         if(systemManager != null && systemManager.stage != null)
         {
            return systemManager.stage.nativeWindow;
         }
         return null;
      }
      
      override public function set visible(value:Boolean) : void
      {
         setVisible(value);
      }
      
      public function orderToBack() : Boolean
      {
         if(Boolean(nativeWindow) && !nativeWindow.closed)
         {
            return nativeWindow.orderToBack();
         }
         return false;
      }
      
      [Bindable("titleIconChanged")]
      public function get titleIcon() : Class
      {
         return _titleIcon;
      }
      
      private function creationCompleteHandler(event:Event) : void
      {
         addEventListener(Event.ENTER_FRAME,enterFrameHandler);
         _nativeWindow = systemManager.stage.nativeWindow;
      }
      
      public function activate() : void
      {
         if(!systemManager.stage.nativeWindow.closed)
         {
            systemManager.stage.nativeWindow.activate();
         }
      }
      
      public function get alwaysInFront() : Boolean
      {
         if(Boolean(_nativeWindow) && !_nativeWindow.closed)
         {
            return nativeWindow.alwaysInFront;
         }
         return _alwaysInFront;
      }
      
      private function windowUnminimizeHandler(event:Event) : void
      {
         removeEventListener(EffectEvent.EFFECT_END,windowUnminimizeHandler);
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
            addEventListener(EffectEvent.EFFECT_END,window_closeEffectEndHandler);
            dispatchEvent(new Event("windowClose"));
            event.preventDefault();
         }
      }
      
      [Bindable("statusBarFactoryChanged")]
      public function get statusBarFactory() : IFactory
      {
         return _statusBarFactory;
      }
      
      private function windowUnmaximizeHandler(event:Event) : void
      {
         removeEventListener(EffectEvent.EFFECT_END,windowUnmaximizeHandler);
         if(!nativeWindow.closed)
         {
            stage.nativeWindow.restore();
         }
      }
      
      override protected function createChildren() : void
      {
         var gripSkin:String = null;
         var tmp:CSSStyleDeclaration = null;
         super.createChildren();
         if(getStyle("showFlexChrome") == false || getStyle("showFlexChrome") == "false")
         {
            setStyle("borderStyle","none");
            setStyle("backgroundAlpha",0);
            return;
         }
         if(!_statusBar)
         {
            _statusBar = statusBarFactory.newInstance();
            _statusBar.styleName = new StyleProxy(this,statusBarStyleFilters);
            rawChildren.addChild(DisplayObject(_statusBar));
            showStatusBarChanged = true;
            statusBarFactoryChanged = false;
         }
         if(systemManager.stage.nativeWindow.systemChrome != "none")
         {
            setStyle("borderStyle","none");
            return;
         }
         if(!_titleBar)
         {
            _titleBar = titleBarFactory.newInstance();
            _titleBar.styleName = new StyleProxy(this,titleBarStyleFilters);
            rawChildren.addChild(DisplayObject(titleBar));
            showTitleBarChanged = true;
            titleBarFactoryChanged = false;
         }
         if(!gripper)
         {
            gripper = new Button();
            gripSkin = getStyle("gripperStyleName");
            if(Boolean(gripSkin))
            {
               tmp = StyleManager.getStyleDeclaration("." + gripSkin);
               gripper.styleName = gripSkin;
            }
            rawChildren.addChild(gripper);
            gripperHit = new Sprite();
            gripperHit.addEventListener(MouseEvent.MOUSE_DOWN,mouseDownHandler);
            rawChildren.addChild(gripperHit);
         }
      }
      
      public function exit() : void
      {
         nativeApplication.exit();
      }
      
      private function mouseUpHandler(event:MouseEvent) : void
      {
         removeEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
         removeEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
      }
      
      [PercentProxy("percentHeight")]
      [Inspectable(category="General")]
      [Bindable("heightChanged")]
      override public function get height() : Number
      {
         return _bounds.height;
      }
      
      override public function set minWidth(value:Number) : void
      {
         _minWidth = value;
         minWidthChanged = true;
         invalidateProperties();
      }
      
      public function getStatusBarHeight() : Number
      {
         if(Boolean(_statusBar))
         {
            return _statusBar.getExplicitOrMeasuredHeight();
         }
         return 0;
      }
      
      private function updateComplete_handler(event:FlexEvent) : void
      {
         if(ucCount == 1)
         {
            dispatchEvent(new Event("initialLayoutComplete"));
            removeEventListener(FlexEvent.UPDATE_COMPLETE,updateComplete_handler);
         }
         else
         {
            ++ucCount;
         }
      }
      
      public function set systemTrayIconMenu(value:FlexNativeMenu) : void
      {
         _systemTrayIconMenu = value;
         if(NativeApplication.supportsSystemTrayIcon)
         {
            if(nativeApplication.icon is SystemTrayIcon)
            {
               SystemTrayIcon(nativeApplication.icon).menu = value.nativeMenu;
            }
         }
      }
      
      public function orderToFront() : Boolean
      {
         if(Boolean(nativeWindow) && !nativeWindow.closed)
         {
            return nativeWindow.orderToFront();
         }
         return false;
      }
      
      public function get type() : String
      {
         if(nativeWindow.closed)
         {
            return "standard";
         }
         return nativeWindow.type;
      }
      
      protected function get titleBarStyleFilters() : Object
      {
         return _titleBarStyleFilters;
      }
      
      private function window_displayStateChangeHandler(event:NativeWindowDisplayStateEvent) : void
      {
         dispatchEvent(event);
         height = systemManager.stage.stageHeight;
         width = systemManager.stage.stageWidth;
      }
      
      public function orderInFrontOf(window:IWindow) : Boolean
      {
         if(Boolean(nativeWindow) && !nativeWindow.closed)
         {
            return nativeWindow.orderInFrontOf(window.nativeWindow);
         }
         return false;
      }
      
      private function nativeApplication_activateHandler(event:Event) : void
      {
         dispatchEvent(new AIREvent(AIREvent.APPLICATION_ACTIVATE));
      }
      
      public function get transparent() : Boolean
      {
         if(nativeWindow.closed)
         {
            return false;
         }
         return nativeWindow.transparent;
      }
      
      private function startMove(event:MouseEvent) : void
      {
         addEventListener(MouseEvent.MOUSE_MOVE,mouseMoveHandler);
         addEventListener(MouseEvent.MOUSE_UP,mouseUpHandler);
         prevX = event.stageX;
         prevY = event.stageY;
      }
      
      override public function set maxHeight(value:Number) : void
      {
         _maxHeight = value;
         maxHeightChanged = true;
         invalidateProperties();
      }
      
      private function preinitializeHandler(event:Event = null) : void
      {
         systemManager.stage.nativeWindow.addEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGING,window_displayStateChangingHandler);
         systemManager.stage.nativeWindow.addEventListener(NativeWindowDisplayStateEvent.DISPLAY_STATE_CHANGE,window_displayStateChangeHandler);
         systemManager.stage.nativeWindow.addEventListener("closing",window_closingHandler);
         systemManager.stage.nativeWindow.addEventListener("close",window_closeHandler,false,0,true);
         if(systemManager.stage.nativeWindow.active)
         {
            dispatchEvent(new AIREvent(AIREvent.WINDOW_ACTIVATE));
         }
         systemManager.stage.nativeWindow.addEventListener("activate",nativeWindow_activateHandler,false,0,true);
         systemManager.stage.nativeWindow.addEventListener("deactivate",nativeWindow_deactivateHandler,false,0,true);
         systemManager.stage.nativeWindow.addEventListener(NativeWindowBoundsEvent.MOVING,window_boundsHandler);
         systemManager.stage.nativeWindow.addEventListener(NativeWindowBoundsEvent.MOVE,window_moveHandler);
         systemManager.stage.nativeWindow.addEventListener(NativeWindowBoundsEvent.RESIZING,window_boundsHandler);
         systemManager.stage.nativeWindow.addEventListener(NativeWindowBoundsEvent.RESIZE,window_resizeHandler);
         systemManager.stage.addEventListener(FullScreenEvent.FULL_SCREEN,stage_fullScreenHandler);
      }
      
      public function get menu() : FlexNativeMenu
      {
         return _menu;
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
               addEventListener(EffectEvent.EFFECT_END,windowMinimizeHandler);
               dispatchEvent(new Event("windowMinimize"));
            }
         }
         else if(event.beforeDisplayState == NativeWindowDisplayState.MINIMIZED)
         {
            addEventListener(EffectEvent.EFFECT_END,windowUnminimizeHandler);
            dispatchEvent(new Event("windowUnminimize"));
         }
      }
      
      private function window_closeEffectEndHandler(event:Event) : void
      {
         removeEventListener(EffectEvent.EFFECT_END,window_closeEffectEndHandler);
         if(!nativeWindow.closed)
         {
            stage.nativeWindow.close();
         }
      }
      
      protected function set bounds(value:Rectangle) : void
      {
         nativeWindow.bounds = value;
         boundsChanged = true;
         invalidateProperties();
         invalidateSize();
         invalidateViewMetricsAndPadding();
      }
      
      public function get closed() : Boolean
      {
         return nativeWindow.closed;
      }
      
      public function get autoExit() : Boolean
      {
         return nativeApplication.autoExit;
      }
      
      public function set showTitleBar(value:Boolean) : void
      {
         if(_showTitleBar == value)
         {
            return;
         }
         _showTitleBar = value;
         showTitleBarChanged = true;
         invalidateProperties();
         invalidateDisplayList();
      }
      
      private function chromeWidth() : Number
      {
         return nativeWindow.width - systemManager.stage.stageWidth;
      }
      
      private function closeButton_clickHandler(event:Event) : void
      {
         stage.nativeWindow.close();
      }
      
      private function viewSourceCloseHandler(win:Window) : Function
      {
         return function():void
         {
            win.close();
         };
      }
      
      private function nativeWindow_activateHandler(event:Event) : void
      {
         dispatchEvent(new AIREvent(AIREvent.WINDOW_ACTIVATE));
      }
      
      override public function set maxWidth(value:Number) : void
      {
         _maxWidth = value;
         maxWidthChanged = true;
         invalidateProperties();
      }
      
      public function get systemChrome() : String
      {
         if(nativeWindow.closed)
         {
            return "";
         }
         return nativeWindow.systemChrome;
      }
      
      override public function validateDisplayList() : void
      {
         var g:Graphics = null;
         super.validateDisplayList();
         if(!nativeWindow.closed)
         {
            if(Capabilities.os.substring(0,3) == "Mac" && systemChrome == "standard")
            {
               if((Boolean(horizontalScrollBar || verticalScrollBar)) && Boolean(!(Boolean(horizontalScrollBar) && Boolean(verticalScrollBar))) && !showStatusBar)
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
            else if(Boolean(gripper) && Boolean(showGripper) && !showStatusBar)
            {
               if(Boolean(whiteBox))
               {
                  whiteBox.visible = false;
                  if(gripperHit.height > whiteBox.height)
                  {
                     verticalScrollBar.setActualSize(verticalScrollBar.width,verticalScrollBar.height - (gripperHit.height - whiteBox.height));
                  }
                  if(gripperHit.width > whiteBox.width)
                  {
                     horizontalScrollBar.setActualSize(horizontalScrollBar.width - (gripperHit.width - whiteBox.height),horizontalScrollBar.height);
                  }
               }
               else if(Boolean(horizontalScrollBar))
               {
                  horizontalScrollBar.setActualSize(horizontalScrollBar.width - gripperHit.width,horizontalScrollBar.height);
               }
               else if(Boolean(verticalScrollBar))
               {
                  verticalScrollBar.setActualSize(verticalScrollBar.width,verticalScrollBar.height - gripperHit.height);
               }
            }
            else if(Boolean(whiteBox))
            {
               whiteBox.visible = true;
            }
         }
      }
      
      override public function set width(value:Number) : void
      {
         if(value < minWidth)
         {
            value = minWidth;
         }
         else if(value > maxWidth)
         {
            value = maxWidth;
         }
         _bounds.width = value;
         boundsChanged = true;
         invalidateProperties();
         invalidateSize();
         invalidateViewMetricsAndPadding();
      }
      
      public function set dockIconMenu(value:FlexNativeMenu) : void
      {
         _dockIconMenu = value;
         if(NativeApplication.supportsDockIcon)
         {
            if(nativeApplication.icon is DockIcon)
            {
               DockIcon(nativeApplication.icon).menu = value.nativeMenu;
            }
         }
      }
      
      public function get maximizable() : Boolean
      {
         if(!nativeWindow.closed)
         {
            return nativeWindow.maximizable;
         }
         return false;
      }
      
      public function set showGripper(value:Boolean) : void
      {
         if(_showGripper == value)
         {
            return;
         }
         _showGripper = value;
         showGripperChanged = true;
         invalidateProperties();
         invalidateDisplayList();
      }
      
      [Bindable("windowComplete")]
      [Bindable("maxHeightChanged")]
      override public function get maxHeight() : Number
      {
         if(Boolean(nativeWindow) && !maxHeightChanged)
         {
            return nativeWindow.maxSize.y - chromeHeight();
         }
         return _maxHeight;
      }
      
      protected function startResize(start:String) : void
      {
         if(!nativeWindow.closed)
         {
            if(nativeWindow.resizable)
            {
               stage.nativeWindow.startResize(start);
            }
         }
      }
      
      override public function setVisible(value:Boolean, noEvent:Boolean = false) : void
      {
         if(!_nativeWindow)
         {
            _nativeWindowVisible = value;
            invalidateProperties();
         }
         else if(!_nativeWindow.closed)
         {
            if(value)
            {
               _nativeWindow.visible = value;
            }
            else if(Boolean(getStyle("hideEffect")) && Boolean(initialized) && $visible != value)
            {
               addEventListener(EffectEvent.EFFECT_END,hideEffectEndHandler);
            }
            else
            {
               _nativeWindow.visible = value;
            }
         }
         super.setVisible(value,noEvent);
      }
      
      private function nativeApplication_networkChangeHandler(event:Event) : void
      {
         dispatchEvent(event);
      }
      
      private function hideEffectEndHandler(event:Event) : void
      {
         if(!_nativeWindow.closed)
         {
            _nativeWindow.visible = false;
         }
         removeEventListener(EffectEvent.EFFECT_END,hideEffectEndHandler);
      }
      
      override public function styleChanged(styleProp:String) : void
      {
         super.styleChanged(styleProp);
         if(!nativeWindow.closed)
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
      
      [PercentProxy("percentWidth")]
      [Inspectable(category="General")]
      [Bindable("widthChanged")]
      override public function get width() : Number
      {
         return _bounds.width;
      }
      
      override protected function commitProperties() : void
      {
         var newMinWidth:Number = NaN;
         var newMinHeight:Number = NaN;
         var newMaxWidth:Number = NaN;
         var newMaxHeight:Number = NaN;
         var gripperIndex:int = 0;
         super.commitProperties();
         if(minWidthChanged || minHeightChanged)
         {
            newMinWidth = minWidthChanged ? _minWidth + chromeWidth() : Number(nativeWindow.minSize.x);
            newMinHeight = minHeightChanged ? _minHeight + chromeHeight() : Number(nativeWindow.minSize.y);
            nativeWindow.minSize = new Point(newMinWidth,newMinHeight);
            if(minWidthChanged)
            {
               minWidthChanged = false;
               if(width < minWidth)
               {
                  width = minWidth;
               }
               dispatchEvent(new Event("minWidthChanged"));
            }
            if(minHeightChanged)
            {
               minHeightChanged = false;
               if(height < minHeight)
               {
                  height = minHeight;
               }
               dispatchEvent(new Event("minHeightChanged"));
            }
         }
         if(maxWidthChanged || maxHeightChanged)
         {
            newMaxWidth = maxWidthChanged ? _maxWidth + chromeWidth() : Number(nativeWindow.maxSize.x);
            newMaxHeight = maxHeightChanged ? _maxHeight + chromeHeight() : Number(nativeWindow.maxSize.y);
            nativeWindow.maxSize = new Point(newMaxWidth,newMaxHeight);
            if(maxWidthChanged)
            {
               maxWidthChanged = false;
               if(width > maxWidth)
               {
                  width = maxWidth;
               }
               dispatchEvent(new Event("maxWidthChanged"));
            }
            if(maxHeightChanged)
            {
               maxHeightChanged = false;
               if(height > maxHeight)
               {
                  height = maxHeight;
               }
               dispatchEvent(new Event("maxHeightChanged"));
            }
         }
         if(boundsChanged)
         {
            systemManager.stage.stageWidth = _width = _bounds.width;
            systemManager.stage.stageHeight = _height = _bounds.height;
            boundsChanged = false;
            dispatchEvent(new Event("widthChanged"));
            dispatchEvent(new Event("heightChanged"));
         }
         if(windowBoundsChanged)
         {
            _bounds.width = _width = systemManager.stage.stageWidth;
            _bounds.height = _height = systemManager.stage.stageHeight;
            windowBoundsChanged = false;
            dispatchEvent(new Event("widthChanged"));
            dispatchEvent(new Event("heightChanged"));
         }
         if(menuChanged && !nativeWindow.closed)
         {
            menuChanged = false;
            if(menu == null)
            {
               if(NativeApplication.supportsMenu)
               {
                  nativeApplication.menu = null;
               }
               else if(NativeWindow.supportsMenu)
               {
                  nativeWindow.menu = null;
               }
            }
            else if(Boolean(menu.nativeMenu))
            {
               if(NativeApplication.supportsMenu)
               {
                  nativeApplication.menu = menu.nativeMenu;
               }
               else if(NativeWindow.supportsMenu)
               {
                  nativeWindow.menu = menu.nativeMenu;
               }
            }
         }
         if(titleBarFactoryChanged)
         {
            if(Boolean(_titleBar))
            {
               rawChildren.removeChild(DisplayObject(titleBar));
               _titleBar = null;
            }
            _titleBar = titleBarFactory.newInstance();
            _titleBar.styleName = new StyleProxy(this,titleBarStyleFilters);
            rawChildren.addChild(DisplayObject(titleBar));
            titleBarFactoryChanged = false;
            invalidateDisplayList();
         }
         if(showTitleBarChanged)
         {
            if(Boolean(titleBar))
            {
               titleBar.visible = _showTitleBar;
            }
            showTitleBarChanged = false;
         }
         if(titleIconChanged)
         {
            if(Boolean(_titleBar) && "titleIcon" in _titleBar)
            {
               _titleBar["titleIcon"] = _titleIcon;
            }
            titleIconChanged = false;
         }
         if(titleChanged)
         {
            if(!nativeWindow.closed)
            {
               systemManager.stage.nativeWindow.title = _title;
            }
            if(Boolean(_titleBar) && "title" in _titleBar)
            {
               _titleBar["title"] = _title;
            }
            titleChanged = false;
         }
         if(statusBarFactoryChanged)
         {
            if(Boolean(_statusBar))
            {
               rawChildren.removeChild(DisplayObject(_statusBar));
               _statusBar = null;
            }
            _statusBar = statusBarFactory.newInstance();
            _statusBar.styleName = new StyleProxy(this,statusBarStyleFilters);
            rawChildren.addChild(DisplayObject(_statusBar));
            if(Boolean(gripper))
            {
               gripperIndex = int(rawChildren.getChildIndex(DisplayObject(gripper)));
               rawChildren.setChildIndex(DisplayObject(_statusBar),gripperIndex);
            }
            statusBarFactoryChanged = false;
            showStatusBarChanged = true;
            statusChanged = true;
            invalidateDisplayList();
         }
         if(showStatusBarChanged)
         {
            if(Boolean(_statusBar))
            {
               _statusBar.visible = _showStatusBar;
            }
            showStatusBarChanged = false;
         }
         if(statusChanged)
         {
            if(Boolean(_statusBar) && "status" in _statusBar)
            {
               _statusBar["status"] = _status;
            }
            statusChanged = false;
         }
         if(showGripperChanged)
         {
            if(Boolean(gripper))
            {
               gripper.visible = _showGripper;
               gripperHit.visible = _showGripper;
            }
            showGripperChanged = false;
         }
         if(toMax)
         {
            toMax = false;
            if(!nativeWindow.closed)
            {
               nativeWindow.maximize();
            }
         }
      }
      
      override public function move(x:Number, y:Number) : void
      {
         var tmp:Rectangle = null;
         if(Boolean(nativeWindow) && !nativeWindow.closed)
         {
            tmp = nativeWindow.bounds;
            tmp.x = x;
            tmp.y = y;
            nativeWindow.bounds = tmp;
         }
      }
      
      public function set titleBarFactory(value:IFactory) : void
      {
         _titleBarFactory = value;
         titleBarFactoryChanged = true;
         invalidateProperties();
         dispatchEvent(new Event("titleBarFactoryChanged"));
      }
      
      private function window_resizeHandler(event:NativeWindowBoundsEvent) : void
      {
         if(!windowBoundsChanged)
         {
            windowBoundsChanged = true;
            invalidateProperties();
            invalidateViewMetricsAndPadding();
            invalidateDisplayList();
            validateNow();
         }
         var e:FlexNativeWindowBoundsEvent = new FlexNativeWindowBoundsEvent(FlexNativeWindowBoundsEvent.WINDOW_RESIZE,event.bubbles,event.cancelable,event.beforeBounds,event.afterBounds);
         dispatchEvent(e);
      }
      
      public function set titleIcon(value:Class) : void
      {
         _titleIcon = value;
         titleIconChanged = true;
         invalidateProperties();
         invalidateSize();
         invalidateViewMetricsAndPadding();
         invalidateDisplayList();
         dispatchEvent(new Event("titleIconChanged"));
      }
      
      public function set alwaysInFront(value:Boolean) : void
      {
         _alwaysInFront = value;
         if(Boolean(_nativeWindow) && !_nativeWindow.closed)
         {
            nativeWindow.alwaysInFront = value;
         }
      }
      
      public function set status(value:String) : void
      {
         _status = value;
         statusChanged = true;
         invalidateProperties();
         invalidateSize();
         invalidateViewMetricsAndPadding();
         dispatchEvent(new Event("statusChanged"));
      }
      
      private function stage_fullScreenHandler(event:FullScreenEvent) : void
      {
         if(stage.displayState != lastDisplayState)
         {
            lastDisplayState = stage.displayState;
            if(stage.displayState == StageDisplayState.FULL_SCREEN || stage.displayState == StageDisplayState.FULL_SCREEN_INTERACTIVE)
            {
               shouldShowTitleBar = showTitleBar;
               showTitleBar = false;
            }
            else
            {
               showTitleBar = shouldShowTitleBar;
            }
         }
      }
      
      [Bindable("titleBarFactoryChanged")]
      public function get titleBarFactory() : IFactory
      {
         return _titleBarFactory;
      }
      
      [Bindable("statusChanged")]
      public function get status() : String
      {
         return _status;
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         var bm:EdgeMetrics = null;
         var leftOffset:Number = NaN;
         var rightOffset:Number = NaN;
         var buttonAlign:String = null;
         if(!nativeWindow.closed)
         {
            super.updateDisplayList(unscaledWidth,unscaledHeight);
            bm = borderMetrics;
            leftOffset = 10;
            rightOffset = 10;
            if(Boolean(_statusBar))
            {
               _statusBar.move(bm.left,unscaledHeight - bm.bottom - getStatusBarHeight());
               _statusBar.setActualSize(unscaledWidth - bm.left - bm.right,getStatusBarHeight());
            }
            if(systemManager.stage.nativeWindow.systemChrome != "none" || Boolean(systemManager.stage.nativeWindow.closed))
            {
               return;
            }
            buttonAlign = String(getStyle("buttonAlignment"));
            if(Boolean(titleBar))
            {
               titleBar.move(bm.left,bm.top);
               titleBar.setActualSize(unscaledWidth - bm.left - bm.right,getHeaderHeight());
            }
            if(Boolean(titleBar) && Boolean(controlBar))
            {
               controlBar.move(0,titleBar.height);
            }
            if(Boolean(gripper) && showGripper)
            {
               _gripperPadding = getStyle("gripperPadding");
               gripper.setActualSize(gripper.measuredWidth,gripper.measuredHeight);
               gripperHit.graphics.beginFill(16777215,0.0001);
               gripperHit.graphics.drawRect(0,0,gripper.width + 2 * _gripperPadding,gripper.height + 2 * _gripperPadding);
               gripper.move(unscaledWidth - gripper.measuredWidth - _gripperPadding,unscaledHeight - gripper.measuredHeight - _gripperPadding);
               gripperHit.x = gripper.x - _gripperPadding;
               gripperHit.y = gripper.y - _gripperPadding;
            }
         }
      }
      
      public function close() : void
      {
         var e:Event = null;
         if(!nativeWindow.closed)
         {
            e = new Event("closing",true,true);
            stage.nativeWindow.dispatchEvent(e);
            if(!e.isDefaultPrevented())
            {
               stage.nativeWindow.close();
            }
         }
      }
   }
}

