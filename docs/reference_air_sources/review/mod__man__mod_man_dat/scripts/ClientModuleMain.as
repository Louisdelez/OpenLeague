package
{
   import blix.assets.proxy.DisplayAdapter;
   import com.riotgames.platform.common.AppConfig;
   import com.riotgames.platform.common.IAppController;
   import com.riotgames.platform.common.IAppControllerConstants;
   import com.riotgames.platform.common.event.ShellEvent;
   import com.riotgames.platform.common.provider.IChampionImagesProvider;
   import com.riotgames.platform.common.provider.IMainProvider;
   import com.riotgames.platform.common.provider.IStoreImagesProvider;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.gameclient.chat.views.docked.DockedChatViewWrapper;
   import com.riotgames.platform.gameclient.contextAlert.view.GlowComponentViewManager;
   import com.riotgames.platform.gameclient.controllers.game.GlowComponentController;
   import com.riotgames.platform.gameclient.domain.partner.AntiIndulgenceMessage;
   import com.riotgames.platform.gameclient.init.ChatPinger;
   import com.riotgames.platform.gameclient.init.LogoutConfirmer;
   import com.riotgames.platform.gameclient.popup.PopupProvider;
   import com.riotgames.platform.gameclient.popup.ShowInternalBrowserPopupAction;
   import com.riotgames.platform.gameclient.views.PreloadMediator;
   import com.riotgames.platform.gameclient.views.ViewMediator;
   import com.riotgames.platform.gameclient.views.application.ApplicationContentView;
   import com.riotgames.platform.gameclient.views.game.common.ChampionImagesCache;
   import com.riotgames.platform.gameclient.views.game.common.StoreImageCache;
   import com.riotgames.platform.gameclient.views.partner.AntiIndulgenceWarningView;
   import com.riotgames.platform.provider.IProviderModule;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.platform.provider.ProviderModuleInfo;
   import com.riotgames.pvpnet.chrome.ChromeProviderProxy;
   import com.riotgames.pvpnet.chrome.IChromePopupsProvider;
   import com.riotgames.pvpnet.game.controllers.MasterGameController;
   import com.riotgames.pvpnet.game.controllers.MasterGameViewController;
   import com.riotgames.pvpnet.system.alerter.AlerterProviderProxy;
   import com.riotgames.pvpnet.system.alerter.IAlerterProvider;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.logging.LogManager;
   import com.riotgames.pvpnet.system.messaging.ShellDispatcher;
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
   import mx.binding.utils.ChangeWatcher;
   import mx.containers.Canvas;
   import mx.core.UIComponent;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.effects.Fade;
   import mx.effects.easing.Linear;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.modules.Module;
   import mx.styles.*;
   import org.swizframework.core.ISwizConfig;
   import org.swizframework.core.SwizConfig;
   import org.swizframework.core.mxml.Swiz;
   
   use namespace mx_internal;
   
   public class ClientModuleMain extends Module implements IMainProvider, IProviderModule, IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      mx_internal static var _ClientModuleMain_StylesInit_done:Boolean = false;
      
      [Inject]
      private var _2070536460applicationController:IAppController;
      
      private var logoutConfirmer:LogoutConfirmer;
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      private var _242804617frameParent:UIComponent;
      
      private var _1793359906antiIndulgence_c:AntiIndulgenceWarningView;
      
      public var alerter:IAlerterProvider;
      
      private var applicationControllerStateWatcher:ChangeWatcher;
      
      [Inject]
      public var preloadMediator:PreloadMediator;
      
      private var chatPinger:ChatPinger;
      
      private var _1895424275clientConfig:ClientConfig;
      
      private var _1595090826fadeInInstance:Fade;
      
      [Inject]
      public var masterGameController:MasterGameController;
      
      private var _2100189721fadeOutInstance:Fade;
      
      mx_internal var _bindingsByDestination:Object;
      
      private var dockedChatViewWrapper:DockedChatViewWrapper;
      
      private var viewReadyCallback:Function;
      
      private var _529608174dockedChat_c:Canvas;
      
      mx_internal var _watchers:Array;
      
      private var glowComponentManager:GlowComponentViewManager;
      
      private var logger:ILogger;
      
      private var _1053615443applicationContent_c:ApplicationContentView;
      
      [Inject]
      public var glowComponentController:GlowComponentController;
      
      [Inject]
      public var masterGameViewController:MasterGameViewController;
      
      [Inject]
      public var viewMediator:ViewMediator;
      
      public var logManager:LogManager;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      private var _3543701swiz:Swiz;
      
      private var _226132425swizConfig:SwizConfig;
      
      [Inject]
      private var _1019249940chatController:ChatController;
      
      mx_internal var _bindings:Array;
      
      public var shellDispatcher:ShellDispatcher;
      
      public function ClientModuleMain()
      {
         this._documentDescriptor_ = new UIComponentDescriptor({
            "type":Module,
            "propertiesFactory":function():Object
            {
               return {"childDescriptors":[new UIComponentDescriptor({
                  "type":ApplicationContentView,
                  "id":"applicationContent_c",
                  "stylesFactory":function():void
                  {
                     this.left = "8";
                     this.right = "8";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {"height":773};
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
                  "type":Canvas,
                  "id":"dockedChat_c",
                  "stylesFactory":function():void
                  {
                     this.bottom = "8";
                     this.left = "7";
                     this.right = "7";
                     this.top = "86";
                  }
               }),new UIComponentDescriptor({
                  "type":AntiIndulgenceWarningView,
                  "id":"antiIndulgence_c",
                  "stylesFactory":function():void
                  {
                     this.horizontalCenter = "0";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {"percentWidth":100};
                  }
               })]};
            }
         });
         this.shellDispatcher = ShellDispatcher.instance;
         this.alerter = AlerterProviderProxy.instance;
         this._1895424275clientConfig = ClientConfig.instance;
         this.logManager = LogManager.instance;
         this.logger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
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
         };
         mx_internal::_ClientModuleMain_StylesInit();
         this.layout = "absolute";
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this._ClientModuleMain_Fade1_i();
         this._ClientModuleMain_Fade2_i();
         this._ClientModuleMain_Swiz1_i();
         this._ClientModuleMain_SwizConfig1_i();
         this.addEventListener("initialize",this.___ClientModuleMain_Module1_initialize);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         ClientModuleMain._watcherSetupUtil = param1;
      }
      
      [Bindable(event="propertyChange")]
      [Inject]
      public function get applicationController() : IAppController
      {
         return this._2070536460applicationController;
      }
      
      [Bindable(event="propertyChange")]
      [Inject]
      public function get chatController() : ChatController
      {
         return this._1019249940chatController;
      }
      
      private function onCloseRequested() : void
      {
         this.onClosing(true);
      }
      
      public function set applicationController(param1:IAppController) : void
      {
         var _loc2_:Object = this._2070536460applicationController;
         if(_loc2_ !== param1)
         {
            this._2070536460applicationController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"applicationController",_loc2_,param1));
         }
      }
      
      public function ___ClientModuleMain_Module1_initialize(param1:FlexEvent) : void
      {
         this.onInitialize();
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.createNewChrome();
         this.createNewDockChatView();
         this.updateAppControllerNavigatorVisible(AppConfig.instance.isNavigatorVisible);
      }
      
      [Bindable(event="propertyChange")]
      public function get antiIndulgence_c() : AntiIndulgenceWarningView
      {
         return this._1793359906antiIndulgence_c;
      }
      
      public function initializeModule(param1:ProviderModuleInfo) : void
      {
         ProviderLookup.publishProvider(IMainProvider,this);
      }
      
      public function onExiting(param1:Event) : void
      {
         this.viewMediator.shutdownClient(param1);
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
      
      public function set chatController(param1:ChatController) : void
      {
         var _loc2_:Object = this._1019249940chatController;
         if(_loc2_ !== param1)
         {
            this._1019249940chatController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"chatController",_loc2_,param1));
         }
      }
      
      public function set swiz(param1:Swiz) : void
      {
         var _loc2_:Object = this._3543701swiz;
         if(_loc2_ !== param1)
         {
            this._3543701swiz = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"swiz",_loc2_,param1));
         }
      }
      
      private function _ClientModuleMain_Fade2_i() : Fade
      {
         var _loc1_:Fade = new Fade();
         this.fadeOutInstance = _loc1_;
         _loc1_.alphaFrom = 1;
         _loc1_.alphaTo = 0;
         _loc1_.duration = 400;
         BindingManager.executeBindings(this,"fadeOutInstance",this.fadeOutInstance);
         return _loc1_;
      }
      
      public function showMainView(param1:DisplayObjectContainer, param2:Function) : void
      {
         this.viewReadyCallback = param2;
         if(this.initialized)
         {
            param1.addChild(this);
            this.viewReadyCallback();
         }
         else
         {
            this.addEventListener(FlexEvent.UPDATE_COMPLETE,this.handleMainViewReady,false,0,true);
            param1.addChild(this);
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get swizConfig() : SwizConfig
      {
         return this._226132425swizConfig;
      }
      
      private function _ClientModuleMain_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():Function
         {
            return Linear.easeOut;
         },function(param1:Function):void
         {
            fadeInInstance.easingFunction = param1;
         },"fadeInInstance.easingFunction");
         result[0] = binding;
         binding = new Binding(this,function():Function
         {
            return Linear.easeOut;
         },function(param1:Function):void
         {
            fadeOutInstance.easingFunction = param1;
         },"fadeOutInstance.easingFunction");
         result[1] = binding;
         binding = new Binding(this,function():IEventDispatcher
         {
            return this;
         },function(param1:IEventDispatcher):void
         {
            swiz.dispatcher = param1;
         },"swiz.dispatcher");
         result[2] = binding;
         binding = new Binding(this,function():ISwizConfig
         {
            return swizConfig;
         },function(param1:ISwizConfig):void
         {
            swiz.config = param1;
         },"swiz.config");
         result[3] = binding;
         binding = new Binding(this,function():Array
         {
            return [LolClientBeans];
         },function(param1:Array):void
         {
            swiz.beanProviders = param1;
         },"swiz.beanProviders");
         result[4] = binding;
         binding = new Binding(this,function():Number
         {
            return applicationContent_c.y + 10;
         },function(param1:Number):void
         {
            antiIndulgence_c.y = param1;
         },"antiIndulgence_c.y");
         result[5] = binding;
         binding = new Binding(this,function():AntiIndulgenceMessage
         {
            return AppConfig.instance.antiIndulgenceMessage;
         },function(param1:AntiIndulgenceMessage):void
         {
            antiIndulgence_c.antiIndulgenceMessage = param1;
         },"antiIndulgence_c.antiIndulgenceMessage");
         result[6] = binding;
         return result;
      }
      
      private function shouldChatBeVisibleWithAppState(param1:String) : Boolean
      {
         return param1 == IAppControllerConstants.LOBBY || param1 == IAppControllerConstants.CHOOSE_GAME_FLOW || param1 == IAppControllerConstants.RECONNECT;
      }
      
      private function handleCurrentAppStateChanged(param1:String, param2:String) : void
      {
         this.dockedChat_c.setVisible(this.shouldChatBeVisibleWithAppState(param2));
      }
      
      public function set antiIndulgence_c(param1:AntiIndulgenceWarningView) : void
      {
         var _loc2_:Object = this._1793359906antiIndulgence_c;
         if(_loc2_ !== param1)
         {
            this._1793359906antiIndulgence_c = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"antiIndulgence_c",_loc2_,param1));
         }
      }
      
      public function set applicationContent_c(param1:ApplicationContentView) : void
      {
         var _loc2_:Object = this._1053615443applicationContent_c;
         if(_loc2_ !== param1)
         {
            this._1053615443applicationContent_c = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"applicationContent_c",_loc2_,param1));
         }
      }
      
      private function showTopContentArea() : void
      {
         this.applicationContent_c.height = 673;
         this.applicationContent_c.y = 85;
         this.shellDispatcher.dispatchEvent(new ShellEvent(ShellEvent.SMALL_TITLE));
      }
      
      private function _ClientModuleMain_Fade1_i() : Fade
      {
         var _loc1_:Fade = new Fade();
         this.fadeInInstance = _loc1_;
         _loc1_.alphaFrom = 0;
         _loc1_.alphaTo = 1;
         _loc1_.duration = 200;
         BindingManager.executeBindings(this,"fadeInInstance",this.fadeInInstance);
         return _loc1_;
      }
      
      public function set swizConfig(param1:SwizConfig) : void
      {
         var _loc2_:Object = this._226132425swizConfig;
         if(_loc2_ !== param1)
         {
            this._226132425swizConfig = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"swizConfig",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get fadeInInstance() : Fade
      {
         return this._1595090826fadeInInstance;
      }
      
      [Bindable(event="propertyChange")]
      public function get frameParent() : UIComponent
      {
         return this._242804617frameParent;
      }
      
      mx_internal function _ClientModuleMain_StylesInit() : void
      {
         var _loc1_:CSSStyleDeclaration = null;
         var _loc2_:Array = null;
         if(mx_internal::_ClientModuleMain_StylesInit_done)
         {
            return;
         }
         mx_internal::_ClientModuleMain_StylesInit_done = true;
         StyleManager.mx_internal::initProtoChainRoots();
      }
      
      private function updateAppControllerNavigatorVisible(param1:Boolean) : void
      {
         if(param1)
         {
            this.showTopContentArea();
         }
         else
         {
            this.hideTopContentArea();
         }
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:ClientModuleMain = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._ClientModuleMain_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_ClientModuleMainWatcherSetupUtil");
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
      
      private function createNewDockChatView() : void
      {
         this.dockedChatViewWrapper = new DockedChatViewWrapper();
         this.dockedChatViewWrapper.percentWidth = 100;
         this.dockedChatViewWrapper.percentHeight = 100;
         this.dockedChat_c.addChild(this.dockedChatViewWrapper);
      }
      
      [Bindable(event="propertyChange")]
      public function get swiz() : Swiz
      {
         return this._3543701swiz;
      }
      
      private function createNewChrome() : void
      {
         var _loc1_:DisplayAdapter = new DisplayAdapter(this.frameParent);
         ChromeProviderProxy.instance.addFrame(_loc1_);
         ChromeProviderProxy.instance.registerCloseRequestedResponder(this.onCloseRequested);
         ProviderLookup.publishProvider(IChromePopupsProvider,new PopupProvider());
      }
      
      [Bindable(event="propertyChange")]
      public function get applicationContent_c() : ApplicationContentView
      {
         return this._1053615443applicationContent_c;
      }
      
      public function onRestore() : void
      {
         this.viewMediator.maximizeClient();
      }
      
      private function _ClientModuleMain_Swiz1_i() : Swiz
      {
         var _loc1_:Swiz = new Swiz();
         this.swiz = _loc1_;
         BindingManager.executeBindings(this,"swiz",this.swiz);
         _loc1_.initialized(this,"swiz");
         return _loc1_;
      }
      
      public function set fadeOutInstance(param1:Fade) : void
      {
         var _loc2_:Object = this._2100189721fadeOutInstance;
         if(_loc2_ !== param1)
         {
            this._2100189721fadeOutInstance = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"fadeOutInstance",_loc2_,param1));
         }
      }
      
      private function onInitialize() : void
      {
         this.glowComponentManager = new GlowComponentViewManager(this.glowComponentController);
         this.glowComponentManager.activate();
         AppConfig.instance.internalBrowserAction = new ShowInternalBrowserPopupAction();
         this.initializeAppController();
         ProviderLookup.publishProvider(IChampionImagesProvider,ChampionImagesCache.instance);
         ProviderLookup.publishProvider(IStoreImagesProvider,StoreImageCache.instance);
      }
      
      private function _ClientModuleMain_SwizConfig1_i() : SwizConfig
      {
         var _loc1_:SwizConfig = new SwizConfig();
         this.swizConfig = _loc1_;
         _loc1_.strict = true;
         _loc1_.viewPackages = ["com.riotgames.platform.common.*","com.riotgames.platform.gameclient.*"];
         return _loc1_;
      }
      
      public function onClosing(param1:Boolean) : void
      {
         if(this.logoutConfirmer != null)
         {
            this.logoutConfirmer.confirmClosing(Session.instance);
         }
      }
      
      public function set dockedChat_c(param1:Canvas) : void
      {
         var _loc2_:Object = this._529608174dockedChat_c;
         if(_loc2_ !== param1)
         {
            this._529608174dockedChat_c = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"dockedChat_c",_loc2_,param1));
         }
      }
      
      public function set clientConfig(param1:ClientConfig) : void
      {
         var _loc2_:Object = this._1895424275clientConfig;
         if(_loc2_ !== param1)
         {
            this._1895424275clientConfig = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"clientConfig",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get fadeOutInstance() : Fade
      {
         return this._2100189721fadeOutInstance;
      }
      
      private function _ClientModuleMain_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = Linear.easeOut;
         _loc1_ = Linear.easeOut;
         _loc1_ = this;
         _loc1_ = this.swizConfig;
         _loc1_ = [LolClientBeans];
         _loc1_ = this.applicationContent_c.y + 10;
         _loc1_ = AppConfig.instance.antiIndulgenceMessage;
      }
      
      private function initializeAppController() : void
      {
         this.chatPinger = new ChatPinger(this.chatController,this.shellDispatcher);
         this.logoutConfirmer = new LogoutConfirmer(this.applicationController,this.masterGameController);
         AppConfig.instance.isNavigatorVisibleChanged.add(this.updateAppControllerNavigatorVisible);
         this.updateAppControllerNavigatorVisible(AppConfig.instance.isNavigatorVisible);
         AppConfig.instance.currentAppStateChanged.add(this.handleCurrentAppStateChanged);
         this.applicationController.initializeAppController();
      }
      
      [Bindable(event="propertyChange")]
      public function get dockedChat_c() : Canvas
      {
         return this._529608174dockedChat_c;
      }
      
      private function hideTopContentArea() : void
      {
         this.applicationContent_c.height = 733;
         this.applicationContent_c.y = 25;
         this.shellDispatcher.dispatchEvent(new ShellEvent(ShellEvent.LARGE_TITLE));
      }
      
      public function set fadeInInstance(param1:Fade) : void
      {
         var _loc2_:Object = this._1595090826fadeInInstance;
         if(_loc2_ !== param1)
         {
            this._1595090826fadeInInstance = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"fadeInInstance",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get clientConfig() : ClientConfig
      {
         return this._1895424275clientConfig;
      }
      
      private function handleMainViewReady(param1:FlexEvent) : void
      {
         this.removeEventListener(FlexEvent.UPDATE_COMPLETE,this.handleMainViewReady);
         this.viewReadyCallback();
      }
   }
}

