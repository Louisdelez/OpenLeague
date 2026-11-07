package
{
   import blix.action.IAction;
   import blix.assets.IAssetsLoader;
   import blix.assets.proxy.DisplayAdapter;
   import blix.assets.proxy.DisplayObjectContainerProxy;
   import blix.layout.LayoutContainer;
   import blix.layout.algorithms.CanvasLayout;
   import com.riotgames.notification.DialogQueue;
   import com.riotgames.notification.DialogQueueProviderProxy;
   import com.riotgames.platform.common.AppConfig;
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.common.event.ShellEvent;
   import com.riotgames.platform.common.provider.IFunctionalTestProvider;
   import com.riotgames.platform.common.resource.FlatFileResourceLoader;
   import com.riotgames.platform.common.services.ServiceProxy;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.common.utils.IErrorHandler;
   import com.riotgames.platform.common.utils.app.ApplicationUtil;
   import com.riotgames.platform.gameclient.FocusHighlight;
   import com.riotgames.platform.gameclient.init.AsyncAlertHandler;
   import com.riotgames.platform.gameclient.init.DragOverlayGlue;
   import com.riotgames.platform.gameclient.init.LolBootstrap;
   import com.riotgames.platform.gameclient.init.PlatformShutdownHandler;
   import com.riotgames.platform.gameclient.init.WindowGlue;
   import com.riotgames.platform.gameclient.kudos.IKudosFactory;
   import com.riotgames.platform.gameclient.kudos.KudosFactoryComposite;
   import com.riotgames.platform.gameclient.kudos.KudosFactoryDisabled;
   import com.riotgames.platform.gameclient.kudos.KudosFactoryEnabled;
   import com.riotgames.platform.gameclient.shell.FrameRateHandler;
   import com.riotgames.platform.gameclient.shell.modules.provider.ScaleFreeProviderImpl;
   import com.riotgames.platform.gameclient.utils.ResourceCopyHelper;
   import com.riotgames.platform.module.RiotModuleInfo;
   import com.riotgames.platform.module.RiotModuleManager;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.chrome.ChromeProviderProxy;
   import com.riotgames.pvpnet.chrome.IWindowControlsProvider;
   import com.riotgames.pvpnet.chrome.WindowControlsProviderImpl;
   import com.riotgames.pvpnet.developerwindow.IDeveloperWindowProvider;
   import com.riotgames.pvpnet.fatal.FatalErrorWindow;
   import com.riotgames.pvpnet.system.config.WindowConstants;
   import com.riotgames.pvpnet.system.maestro.MaestroProviderProxy;
   import com.riotgames.pvpnet.system.messaging.ShellDispatcher;
   import com.riotgames.pvpnet.system.notification.ServerStatusProviderProxy;
   import com.riotgames.pvpnet.system.shell.IScaleFreeProvider;
   import com.riotgames.pvpnet.tips.TipsProviderProxy;
   import com.riotgames.rust.context.RustContext;
   import com.riotgames.rust.focus.RiotFocusManager;
   import com.riotgames.rust.popup.PopUpManager;
   import com.riotgames.rust.popup.PopUpManagerImpl;
   import com.riotgames.rust.resource.IRustResourceLoader;
   import flash.accessibility.*;
   import flash.data.*;
   import flash.debugger.*;
   import flash.desktop.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filesystem.*;
   import flash.filters.*;
   import flash.geom.*;
   import flash.html.*;
   import flash.html.script.*;
   import flash.media.*;
   import flash.net.*;
   import flash.printing.*;
   import flash.profiler.*;
   import flash.system.*;
   import flash.text.*;
   import flash.ui.*;
   import flash.utils.*;
   import flash.xml.*;
   import mx.binding.*;
   import mx.containers.Canvas;
   import mx.core.UIComponent;
   import mx.core.UIComponentDescriptor;
   import mx.core.WindowedApplication;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.events.ResizeEvent;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.managers.CursorManager;
   import mx.managers.ToolTipManager;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class BaseShell extends WindowedApplication implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private static const APPLICATION_CORNER_RADIUS:int = 15;
      
      private var _830994770mainBox:Canvas;
      
      private var _403824400windowControlsParent:UIComponent;
      
      private var _242804617frameParent:UIComponent;
      
      private var popUpLayoutContainer:LayoutContainer;
      
      private var platformShutdownHandler:PlatformShutdownHandler;
      
      private var _developerWindowProvider:IDeveloperWindowProvider;
      
      private var resizeNSCursor:Class;
      
      private var resizeNESWCursor:Class;
      
      private var _bootstrapComplete:Boolean = false;
      
      private var windowGlue:WindowGlue;
      
      private var resizeEWCursor:Class;
      
      mx_internal var _bindingsByDestination:Object;
      
      private var kudosFactory:IKudosFactory;
      
      private var modalBlocker:Sprite;
      
      private var errorHandlers:Vector.<IErrorHandler>;
      
      private var copyHelper:ResourceCopyHelper;
      
      private var shouldHide:Boolean;
      
      mx_internal var _watchers:Array;
      
      private var logger:ILogger;
      
      private var processedOnInvoke:Boolean = false;
      
      private var scaleFreeZone:UIComponent;
      
      private var resizeNWSECursor:Class;
      
      private var windowControls:WindowControlsProviderImpl;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      private var dragOverlayGlue:DragOverlayGlue;
      
      private var scaleFreeProvider:ScaleFreeProviderImpl;
      
      private var asyncAlertHandler:AsyncAlertHandler;
      
      mx_internal var _bindings:Array;
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      private var _frameRateHandler:FrameRateHandler;
      
      public function BaseShell()
      {
         this._documentDescriptor_ = new UIComponentDescriptor({
            "type":WindowedApplication,
            "propertiesFactory":function():Object
            {
               return {
                  "width":1280,
                  "height":800,
                  "childDescriptors":[new UIComponentDescriptor({
                     "type":Canvas,
                     "id":"mainBox",
                     "stylesFactory":function():void
                     {
                        this.backgroundAlpha = 0;
                     },
                     "propertiesFactory":function():Object
                     {
                        return {
                           "percentWidth":100,
                           "percentHeight":100,
                           "horizontalScrollPolicy":"off",
                           "verticalScrollPolicy":"off"
                        };
                     }
                  }),new UIComponentDescriptor({
                     "type":UIComponent,
                     "id":"frameParent",
                     "propertiesFactory":function():Object
                     {
                        return {
                           "width":1280,
                           "height":800
                        };
                     }
                  }),new UIComponentDescriptor({
                     "type":UIComponent,
                     "id":"windowControlsParent",
                     "propertiesFactory":function():Object
                     {
                        return {
                           "width":1280,
                           "height":800
                        };
                     }
                  })]
               };
            }
         });
         this.logger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
         this.errorHandlers = new Vector.<IErrorHandler>();
         this.resizeNESWCursor = BaseShell_resizeNESWCursor;
         this.resizeNWSECursor = BaseShell_resizeNWSECursor;
         this.resizeNSCursor = BaseShell_resizeNSCursor;
         this.resizeEWCursor = BaseShell_resizeEWCursor;
         this.windowGlue = new WindowGlue(ShellDispatcher.instance);
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         if(!this.styleDeclaration)
         {
            this.styleDeclaration = new CSSStyleDeclaration();
         }
         this.styleDeclaration.defaultFactory = function():void
         {
            this.borderStyle = "none";
            this.cornerRadius = 10;
            this.showFlexChrome = false;
         };
         this.width = 1280;
         this.height = 800;
         this.horizontalScrollPolicy = "off";
         this.layout = "absolute";
         this.minHeight = 640;
         this.minWidth = 1024;
         this.verticalScrollPolicy = "off";
         this.mouseEnabled = false;
         this.addEventListener("keyDown",this.___BaseShell_WindowedApplication1_keyDown);
         this.addEventListener("preinitialize",this.___BaseShell_WindowedApplication1_preinitialize);
         this.addEventListener("resize",this.___BaseShell_WindowedApplication1_resize);
         this.addEventListener("applicationComplete",this.___BaseShell_WindowedApplication1_applicationComplete);
         this.addEventListener("invoke",this.___BaseShell_WindowedApplication1_invoke);
         this.addEventListener("displayStateChange",this.___BaseShell_WindowedApplication1_displayStateChange);
         this.addEventListener("activate",this.___BaseShell_WindowedApplication1_activate);
         this.addEventListener("deactivate",this.___BaseShell_WindowedApplication1_deactivate);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         BaseShell._watcherSetupUtil = param1;
      }
      
      private function modalModeChangedHandler() : void
      {
         var _loc1_:Graphics = null;
         if(PopUpManager.instance.getInModalMode())
         {
            if(this.modalBlocker == null)
            {
               this.modalBlocker = new Sprite();
               _loc1_ = this.modalBlocker.graphics;
               _loc1_.beginFill(0,0.6);
               _loc1_.drawRect(0,0,100,100);
               _loc1_.endFill();
            }
            if(Boolean(stage) && stage.numChildren > 0)
            {
               stage.addChildAt(this.modalBlocker,1);
               (ApplicationUtil.application as Sprite).tabChildren = false;
               if(Boolean(NativeApplication.supportsSystemTrayIcon) && !this.visible)
               {
                  if(this.modalBlocker.width == 0 || this.modalBlocker.height == 0)
                  {
                     this.modalBlocker.width = this.nativeWindow.width;
                     this.modalBlocker.height = this.nativeWindow.height;
                  }
               }
               else
               {
                  this.modalBlocker.width = stage.stageWidth;
                  this.modalBlocker.height = stage.stageHeight;
               }
            }
         }
         else
         {
            (ApplicationUtil.application as Sprite).tabChildren = true;
            if(this.modalBlocker.parent)
            {
               this.modalBlocker.parent.removeChild(this.modalBlocker);
            }
         }
      }
      
      protected function windowedapplication_keyDownHandler(param1:KeyboardEvent) : void
      {
         if(param1.altKey && param1.shiftKey && param1.keyCode == 68)
         {
            ProviderLookup.getProvider(IDeveloperWindowProvider,this.onDeveloperWindowProviderLookupSuccess);
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get windowControlsParent() : UIComponent
      {
         return this._403824400windowControlsParent;
      }
      
      public function ___BaseShell_WindowedApplication1_resize(param1:ResizeEvent) : void
      {
         callLater(this.onResize);
      }
      
      private function setupDeveloperWindow() : void
      {
         var _loc1_:RiotModuleInfo = RiotModuleManager.getModuleInfoByUrl("mod/dev/developerWindow.dat");
         if(_loc1_ != null)
         {
            _loc1_.getCompleted().addOnce(this.initializeRiotModules);
            _loc1_.getErred().addOnce(this.initializeRiotModules);
            ProviderLookup.getProvider(IDeveloperWindowProvider,this.onDeveloperWindowProviderLookupSuccess);
         }
         else
         {
            this.initializeRiotModules();
         }
      }
      
      private function restoreWindow() : void
      {
         this.restore();
      }
      
      private function handleRestoreFromSystrayEvent(param1:ShellEvent) : void
      {
         this.visible = true;
         this.shouldHide = false;
         var _loc2_:NativeWindow = NativeApplication.nativeApplication.openedWindows[0];
         _loc2_.activate();
         _loc2_.orderToFront();
         _loc2_.alwaysInFront = true;
         _loc2_.alwaysInFront = false;
      }
      
      public function ___BaseShell_WindowedApplication1_preinitialize(param1:FlexEvent) : void
      {
         this.onPreinitialize();
      }
      
      private function onFunctionalTestProviderLookupSuccess(param1:IFunctionalTestProvider) : void
      {
      }
      
      public function set windowControlsParent(param1:UIComponent) : void
      {
         var _loc2_:Object = this._403824400windowControlsParent;
         if(_loc2_ !== param1)
         {
            this._403824400windowControlsParent = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"windowControlsParent",_loc2_,param1));
         }
      }
      
      final protected function setMainReady() : void
      {
         this.windowGlue.windowSetMainReady();
      }
      
      private function onInvoke(param1:InvokeEvent) : void
      {
         if(!this.processedOnInvoke)
         {
            this.processedOnInvoke = true;
            this.bootstrap(param1.arguments);
         }
      }
      
      private function _BaseShell_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = resourceManager.getString("resources","main_window_title");
      }
      
      private function onTitleBarDoubleClick(param1:MouseEvent) : void
      {
         this.windowControls.setToDefaultSize();
      }
      
      public function ___BaseShell_WindowedApplication1_activate(param1:Event) : void
      {
         this.onActivate(param1);
      }
      
      private function onWindowRestoreRequested() : void
      {
         this.restore();
      }
      
      private function onApplicationComplete(param1:FlexEvent) : void
      {
         this.windowControls.initResizing();
         this.windowGlue.windowInit();
         this.windowGlue.windowCueRequested.add(this.onWindowCueRequested);
         this.windowGlue.windowRestoreRequested.add(this.onWindowRestoreRequested);
      }
      
      [Bindable(event="propertyChange")]
      public function get mainBox() : Canvas
      {
         return this._830994770mainBox;
      }
      
      public function ___BaseShell_WindowedApplication1_applicationComplete(param1:FlexEvent) : void
      {
         this.onApplicationComplete(param1);
      }
      
      public function ___BaseShell_WindowedApplication1_keyDown(param1:KeyboardEvent) : void
      {
         this.windowedapplication_keyDownHandler(param1);
      }
      
      protected function onFatalErrWindowClosed(param1:Event) : void
      {
         NativeApplication.nativeApplication.exit();
      }
      
      protected function fatalError(param1:String) : void
      {
         this.logger.fatal(param1);
         var _loc2_:FatalErrorWindow = new FatalErrorWindow(param1);
         _loc2_.addEventListener(Event.CLOSE,this.onFatalErrWindowClosed);
         _loc2_.activate();
      }
      
      private function initializeFocusManager() : void
      {
         var _loc1_:Sprite = new FocusHighlightAsset();
         stage.addChild(_loc1_);
         var _loc2_:FocusHighlight = new FocusHighlight(null);
         _loc2_.setAsset(_loc1_);
         var _loc3_:RiotFocusManager = new RiotFocusManager(_loc2_);
         _loc3_.watch(this);
      }
      
      private function onTitleBarMouseDown(param1:MouseEvent) : void
      {
         this.windowControls.beginDrag();
      }
      
      private function bootstrap(param1:Array) : void
      {
         ShellDispatcher.instance.addEventListener(ShellEvent.RESTORE,this.handleRestoreFromSystrayEvent);
         ShellDispatcher.instance.addEventListener(ShellEvent.MINIMIZE_TO_TRAY,this.handleMinimizeToSystrayEvent);
         var _loc2_:LolBootstrap = new LolBootstrap(stage.loaderInfo,param1);
         _loc2_.getChromeReadyAction().getCompleted().add(this.showFrame);
         _loc2_.getCompleted().add(this.bootstrapCompleteHandler);
         _loc2_.getErred().add(this.bootstrapErredHandler);
         _loc2_.invoke();
      }
      
      private function showFrame() : void
      {
         ProviderLookup.publishProvider(IWindowControlsProvider,this.windowControls);
         ProviderLookup.publishProvider(IScaleFreeProvider,this.scaleFreeProvider);
         var _loc1_:DisplayAdapter = new DisplayAdapter(this.frameParent);
         ChromeProviderProxy.instance.addFrame(_loc1_);
         var _loc2_:DisplayAdapter = new DisplayAdapter(this.windowControlsParent);
         ChromeProviderProxy.instance.addWindowControls(_loc2_);
         this.scaleFreeProvider.setScaleFreeZone(this.scaleFreeZone);
      }
      
      private function onResize() : void
      {
         this.windowControls.refreshWindowSize();
      }
      
      private function bootstrapErredHandler(param1:IAction) : void
      {
         var _loc2_:String = ":-( You may need to REPAIR your install.\n(Bootstrap Error)\n" + param1.getError().message;
         this.fatalError(_loc2_);
      }
      
      protected function onSecondaryResourcesLoaded() : void
      {
      }
      
      [Bindable(event="propertyChange")]
      public function get frameParent() : UIComponent
      {
         return this._242804617frameParent;
      }
      
      private function handleMinimizeToSystrayEvent(param1:ShellEvent) : void
      {
         this.minimize();
         this.shouldHide = true;
         this.visible = false;
      }
      
      private function bootstrapCompleteHandler() : void
      {
         this._bootstrapComplete = true;
         this.logger.info("Bootstrap process completed successfully.");
         this.asyncAlertHandler = new AsyncAlertHandler(Session.instance,ShellDispatcher.instance,ServerStatusProviderProxy.instance,MaestroProviderProxy.instance,ServiceProxy.instance);
         this.attemptTipsInitialization();
         this.platformShutdownHandler = new PlatformShutdownHandler(ServerStatusProviderProxy.instance);
         this.publishKudosProvider();
         this.setupDeveloperWindow();
      }
      
      private function stageResizeHandler(param1:Event = null) : void
      {
         if(stage)
         {
            this.popUpLayoutContainer.setExplicitSize(stage.stageWidth,stage.stageHeight);
         }
      }
      
      final protected function loadSecondaryResources() : void
      {
         ImagePackLookup.instance.initializeImagePacks(this.onSecondaryResourcesLoaded);
      }
      
      private function onCopySourceDirSelected(param1:Event) : void
      {
         this.copyHelper.copyResources();
         ProviderLookup.getProvider(IDeveloperWindowProvider,this.onDeveloperWindowProviderLookupSuccess);
      }
      
      public function set mainBox(param1:Canvas) : void
      {
         var _loc2_:Object = this._830994770mainBox;
         if(_loc2_ !== param1)
         {
            this._830994770mainBox = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mainBox",_loc2_,param1));
         }
      }
      
      private function addedToStageHandler(param1:Event = null) : void
      {
         var _loc2_:Point = null;
         removeEventListener(Event.ADDED_TO_STAGE,this.addedToStageHandler);
         this.initializePopUpManager();
         this.initializeFocusManager();
         if(WindowConstants.requiresSmallResolutionSupport(nativeWindow))
         {
            _loc2_ = WindowConstants.findSmallDefaultResolution(nativeWindow);
            nativeWindow.bounds = new Rectangle(nativeWindow.bounds.x,nativeWindow.bounds.y,_loc2_.x,_loc2_.y);
            nativeWindow.dispatchEvent(new NativeWindowBoundsEvent(NativeWindowBoundsEvent.RESIZE));
         }
         this.attemptTipsInitialization();
         this.parent.addChildAt(this.scaleFreeZone,0);
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:BaseShell = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._BaseShell_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_BaseShellWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(param1:String):*
         {
            return target[param1];
         },bindings,watchers);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         super.initialize();
      }
      
      private function setWindowDimensionsToDefault() : void
      {
      }
      
      private function onDeactivate(param1:Event) : *
      {
         ShellDispatcher.instance.dispatchEvent(new ShellEvent(ShellEvent.DEACTIVATE));
      }
      
      private function attemptTipsInitialization() : void
      {
         if(this.stage != null && this._bootstrapComplete)
         {
            TipsProviderProxy.instance.registerDeprecatedToolTipManager(this.stage);
         }
      }
      
      private function onDisplayStateChange(param1:NativeWindowDisplayStateEvent) : void
      {
         var _loc2_:String = param1.beforeDisplayState;
         var _loc3_:String = param1.afterDisplayState;
         if(this.stage != null)
         {
            if(this._frameRateHandler == null)
            {
               this._frameRateHandler = new FrameRateHandler(this.stage);
            }
            this._frameRateHandler.minimized = _loc3_ == NativeWindowDisplayState.MINIMIZED;
         }
         if(_loc3_ == NativeWindowDisplayState.MINIMIZED && this.shouldHide)
         {
            visible = false;
            param1.preventDefault();
         }
         this.windowGlue.windowDisplayStateChange(_loc2_,_loc3_);
      }
      
      public function ___BaseShell_WindowedApplication1_deactivate(param1:Event) : void
      {
         this.onDeactivate(param1);
      }
      
      public function ___BaseShell_WindowedApplication1_invoke(param1:InvokeEvent) : void
      {
         this.onInvoke(param1);
      }
      
      private function onWindowCueRequested() : void
      {
         var _loc1_:DockIcon = null;
         if(NativeApplication.supportsDockIcon)
         {
            _loc1_ = NativeApplication.nativeApplication.icon as DockIcon;
            _loc1_.bounce(NotificationType.CRITICAL);
         }
         else if(NativeApplication.supportsSystemTrayIcon)
         {
            this.nativeWindow.notifyUser(NotificationType.INFORMATIONAL);
         }
      }
      
      public function ___BaseShell_WindowedApplication1_displayStateChange(param1:NativeWindowDisplayStateEvent) : void
      {
         this.onDisplayStateChange(param1);
      }
      
      private function _BaseShell_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","main_window_title");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            this.title = param1;
         },"this.title");
         result[0] = binding;
         return result;
      }
      
      protected function initializeRiotModules() : void
      {
         ProviderLookup.getProvider(IFunctionalTestProvider,this.onFunctionalTestProviderLookupSuccess);
      }
      
      private function onResizeHandleMouseOver(param1:MouseEvent, param2:String) : void
      {
         switch(param2)
         {
            case NativeWindowResize.BOTTOM_RIGHT:
               CursorManager.getInstance().setCursor(this.resizeNWSECursor,2,-20,-20);
               break;
            case NativeWindowResize.TOP_LEFT:
               CursorManager.getInstance().setCursor(this.resizeNWSECursor);
               break;
            case NativeWindowResize.TOP_RIGHT:
               CursorManager.getInstance().setCursor(this.resizeNESWCursor,2,-20,20);
               break;
            case NativeWindowResize.BOTTOM_LEFT:
               CursorManager.getInstance().setCursor(this.resizeNESWCursor);
               break;
            case NativeWindowResize.BOTTOM:
               CursorManager.getInstance().setCursor(this.resizeNSCursor,2,0,-20);
               break;
            case NativeWindowResize.TOP:
               CursorManager.getInstance().setCursor(this.resizeNSCursor);
               break;
            case NativeWindowResize.LEFT:
               CursorManager.getInstance().setCursor(this.resizeEWCursor);
               break;
            case NativeWindowResize.RIGHT:
               CursorManager.getInstance().setCursor(this.resizeEWCursor,2,-20,0);
         }
      }
      
      private function publishKudosProvider() : void
      {
         var _loc1_:FlatFileResourceLoader = new FlatFileResourceLoader();
         var _loc2_:Dictionary = new Dictionary();
         _loc2_[IRustResourceLoader] = _loc1_;
         var _loc3_:RustContext = new RustContext(_loc2_);
         _loc3_.enableAutoLocalization("resources");
         var _loc4_:IAssetsLoader = _loc3_.getDependency(IAssetsLoader);
         _loc4_.loadAssets(new URLRequest("/assets/swfs/kudos/kudos.swf"));
         this.kudosFactory = new KudosFactoryComposite(new KudosFactoryEnabled(_loc3_,_loc1_),new KudosFactoryDisabled());
         ProviderLookup.publishProvider(IKudosFactory,this.kudosFactory);
      }
      
      protected function onPreinitialize() : void
      {
         ToolTipManager.showDelay = 0;
         this.windowControls = new WindowControlsProviderImpl(this,this.nativeWindow);
         this.scaleFreeProvider = new ScaleFreeProviderImpl();
         this.scaleFreeZone = new UIComponent();
         this.windowControls.initializeApplicationDimensions();
         addEventListener(Event.ADDED_TO_STAGE,this.addedToStageHandler);
         if(stage != null)
         {
            this.addedToStageHandler();
         }
         AppConfig.instance.sessionStartTime = getTimer();
      }
      
      public function set frameParent(param1:UIComponent) : void
      {
         var _loc2_:Object = this._242804617frameParent;
         if(_loc2_ !== param1)
         {
            this._242804617frameParent = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"frameParent",_loc2_,param1));
         }
      }
      
      private function initializePopUpManager() : void
      {
         AppConfig.instance.legacyPopupSupport = true;
         var _loc1_:Sprite = new Sprite();
         stage.addChild(_loc1_);
         var _loc2_:DisplayObjectContainerProxy = new DisplayObjectContainerProxy(null);
         _loc2_.setAsset(_loc1_);
         this.popUpLayoutContainer = new LayoutContainer();
         this.popUpLayoutContainer.setLayoutAlgorithm(new CanvasLayout());
         stage.addEventListener(Event.RESIZE,this.stageResizeHandler,false,0,true);
         this.stageResizeHandler();
         PopUpManager.instance = new PopUpManagerImpl(_loc2_,this.popUpLayoutContainer);
         PopUpManager.instance.getInModalModeChanged().add(this.modalModeChangedHandler);
         DialogQueueProviderProxy.setInstance(new DialogQueue());
      }
      
      private function onActivate(param1:Event) : *
      {
         ShellDispatcher.instance.dispatchEvent(new ShellEvent(ShellEvent.ACTIVATE));
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         if(this.nativeWindow.closed)
         {
            return;
         }
         super.updateDisplayList(param1,param2);
         var _loc3_:Number = this.nativeWindow.width / WindowConstants.DEFAULT_SCREEN_WIDTH;
         this.scaleX = _loc3_;
         this.scaleY = _loc3_;
         var _loc4_:Event = new Event(Event.RESIZE);
         this.scaleFreeZone.dispatchEvent(_loc4_);
      }
      
      private function onDeveloperWindowProviderLookupSuccess(param1:IDeveloperWindowProvider) : void
      {
         if(this._developerWindowProvider == null)
         {
            this._developerWindowProvider = param1;
            this._developerWindowProvider.addInteractiveObjectToTab("Shell",new DevPanelShell().view);
         }
         this._developerWindowProvider.show();
      }
   }
}

