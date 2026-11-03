package com.riotgames.platform.gameclient.views.lobby.landing
{
   import blix.assets.proxy.DisplayAdapter;
   import com.riotgames.landing.ILobbyLandingPage;
   import com.riotgames.landing.LobbyLandingPageProxy;
   import com.riotgames.platform.common.module.championdetail.ChampionDetailContext;
   import com.riotgames.platform.common.provider.IInventory;
   import com.riotgames.platform.common.provider.IInventoryProvider;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.gameclient.chat.views.ChatViewMediator;
   import com.riotgames.platform.gameclient.controllers.store.StoreController;
   import com.riotgames.platform.provider.ProviderLookup;
   import com.riotgames.pvpnet.clientfeaturedcontent.IClientFeaturedContentProvider;
   import com.riotgames.pvpnet.game.controllers.SpectatorController;
   import com.riotgames.pvpnet.game.controllers.lobby.ILobbyViewController;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import com.riotgames.pvpnet.system.cursor.CursorManager;
   import com.riotgames.pvpnet.system.cursor.ICursorManager;
   import com.riotgames.pvpnet.system.shell.IScaleFreeProvider;
   import com.riotgames.pvpnet.tracking.ICrossModuleTrackerProvider;
   import com.riotgames.pvpnet.tracking.trackers.client.IClientBehaviorTracker;
   import com.riotgames.util.json.jsonDecode;
   import com.riotgames.util.json.jsonEncode;
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
   import mx.containers.utilityClasses.ConstraintColumn;
   import mx.controls.HTML;
   import mx.controls.Image;
   import mx.core.DeferredInstanceFromFunction;
   import mx.core.UIComponent;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.effects.Fade;
   import mx.effects.Sequence;
   import mx.effects.SetPropertyAction;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.states.AddChild;
   import mx.states.State;
   import mx.styles.*;
   import mx.utils.URLUtil;
   
   use namespace mx_internal;
   
   public class LobbyLanding extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      public static const LOADING_SPINNER:Class = LobbyLanding_LOADING_SPINNER;
      
      private var _1282133823fadeIn:Sequence;
      
      private var _1599266847swfContainer:UIComponent;
      
      private var _1395123346mainSpinnerBackground:Image;
      
      private var _lobbyLandingUrl:String;
      
      [Inject]
      private var _349030418lobbyController:ILobbyViewController;
      
      private var _1091436750fadeOut:Sequence;
      
      private var landingPageConfigured:Boolean = false;
      
      private var _1895424275clientConfig:ClientConfig;
      
      [Inject]
      public var chatViewMediator:ChatViewMediator;
      
      private var _landingPageDisplay:DisplayAdapter;
      
      protected var _clientBehaviorTracker:IClientBehaviorTracker;
      
      private var _featuredContentProvider:IClientFeaturedContentProvider;
      
      mx_internal var _bindingsByDestination:Object;
      
      private var _55416825leftCol:ConstraintColumn;
      
      [Inject]
      public var storeController:StoreController;
      
      private var _championsDataJson:Object;
      
      private var _htmlFrontpageLoader:HTMLLoader;
      
      private var _1120565339landingIsLoading:Boolean = true;
      
      mx_internal var _watchers:Array;
      
      private var _scaleFreeZone:DisplayObjectContainer;
      
      private var _978073224htmlLandingPanel:HTML;
      
      private var _821648263htmlFrontPageMarker:Canvas;
      
      [Inject]
      private var _1019249940chatController:ChatController;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      public var _inventory:IInventory;
      
      private var _359435839buttonsCol:ConstraintColumn;
      
      [Inject]
      public var spectatorController:SpectatorController;
      
      mx_internal var _bindings:Array;
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      public function LobbyLanding()
      {
         this._documentDescriptor_ = new UIComponentDescriptor({
            "type":Canvas,
            "propertiesFactory":function():Object
            {
               return {"childDescriptors":[new UIComponentDescriptor({
                  "type":Image,
                  "id":"mainSpinnerBackground",
                  "stylesFactory":function():void
                  {
                     this.verticalCenter = "0";
                     this.horizontalCenter = "0";
                  }
               })]};
            }
         });
         this._1895424275clientConfig = ClientConfig.instance;
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
         this.cacheAsBitmap = true;
         this.percentWidth = 100;
         this.percentHeight = 100;
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this.states = [this._LobbyLanding_State1_c(),this._LobbyLanding_State2_c(),this._LobbyLanding_State3_c()];
         this.constraintColumns = [this._LobbyLanding_ConstraintColumn1_i(),this._LobbyLanding_ConstraintColumn2_i()];
         this._LobbyLanding_Sequence1_i();
         this._LobbyLanding_Sequence2_i();
         this.addEventListener("initialize",this.___LobbyLanding_Canvas1_initialize);
         this.addEventListener("creationComplete",this.___LobbyLanding_Canvas1_creationComplete);
         this.addEventListener("show",this.___LobbyLanding_Canvas1_show);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         LobbyLanding._watcherSetupUtil = param1;
      }
      
      private function _LobbyLanding_Canvas2_i() : Canvas
      {
         var _loc1_:Canvas = new Canvas();
         this.htmlFrontPageMarker = _loc1_;
         _loc1_.percentHeight = 100;
         _loc1_.percentWidth = 100;
         _loc1_.visible = false;
         _loc1_.setStyle("top","0");
         _loc1_.setStyle("left","0");
         _loc1_.setStyle("backgroundAlpha",0);
         _loc1_.setStyle("backgroundColor",0);
         _loc1_.setStyle("borderStyle","none");
         _loc1_.addEventListener("addedToStage",this.__htmlFrontPageMarker_addedToStage);
         _loc1_.addEventListener("removedFromStage",this.__htmlFrontPageMarker_removedFromStage);
         _loc1_.addEventListener("creationComplete",this.__htmlFrontPageMarker_creationComplete);
         _loc1_.id = "htmlFrontPageMarker";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function positionFrontpageLoader() : void
      {
         var _loc1_:Rectangle = this.htmlFrontPageMarker.getRect(stage);
         this._htmlFrontpageLoader.x = _loc1_.x;
         this._htmlFrontpageLoader.y = _loc1_.y;
         this._htmlFrontpageLoader.width = _loc1_.width;
         this._htmlFrontpageLoader.height = _loc1_.height;
      }
      
      private function resourceManagerChangeHandler(param1:Event) : void
      {
         this.refreshLobbyLandingUrl();
      }
      
      public function set leftCol(param1:ConstraintColumn) : void
      {
         var _loc2_:Object = this._55416825leftCol;
         if(_loc2_ !== param1)
         {
            this._55416825leftCol = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"leftCol",_loc2_,param1));
         }
      }
      
      public function set htmlFrontPageMarker(param1:Canvas) : void
      {
         var _loc2_:Object = this._821648263htmlFrontPageMarker;
         if(_loc2_ !== param1)
         {
            this._821648263htmlFrontPageMarker = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"htmlFrontPageMarker",_loc2_,param1));
         }
      }
      
      private function getChampionsDataAsJson() : Object
      {
         var _loc2_:Object = null;
         var _loc1_:Object = {};
         if(!this._championsDataJson && this._inventory != null && this._inventory.championDataDictionary != null)
         {
            for each(_loc2_ in this._inventory.championDataDictionary)
            {
               _loc1_[_loc2_.championId] = {
                  "id":_loc2_.championId,
                  "skinName":_loc2_.skinName,
                  "path":"/images/champions/" + _loc2_.skinName + "_Square_0.png"
               };
            }
            this._championsDataJson = jsonEncode(_loc1_);
         }
         return this._championsDataJson;
      }
      
      [Bindable(event="propertyChange")]
      [Inject]
      public function get lobbyController() : ILobbyViewController
      {
         return this._349030418lobbyController;
      }
      
      [Bindable(event="propertyChange")]
      [Inject]
      public function get chatController() : ChatController
      {
         return this._1019249940chatController;
      }
      
      private function _LobbyLanding_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.htmlLandingPanel.scaleX == 1 ? "off" : "auto";
         _loc1_ = this.htmlLandingPanel.scaleY == 1 ? "off" : "auto";
         _loc1_ = this.lobbyLandingURL;
         _loc1_ = this.htmlLandingPanel.scaleX == 1 ? 800 : 0;
         _loc1_ = 1 / this.parentApplication.scaleX;
         _loc1_ = 1 / this.parentApplication.scaleY;
         _loc1_ = this.landingIsLoading ? LOADING_SPINNER : null;
         _loc1_ = this.landingIsLoading;
      }
      
      public function ___LobbyLanding_Canvas1_show(param1:FlexEvent) : void
      {
         this.onShow();
      }
      
      private function hideFrontpage() : void
      {
         this.landingIsLoading = true;
         if(UserPreferencesManager.globalPrefs.enableAnimations)
         {
            this.fadeOut.play([this._htmlFrontpageLoader]);
         }
         else
         {
            this._htmlFrontpageLoader.alpha = 0;
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get swfContainer() : UIComponent
      {
         return this._1599266847swfContainer;
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
      
      public function set lobbyController(param1:ILobbyViewController) : void
      {
         var _loc2_:Object = this._349030418lobbyController;
         if(_loc2_ !== param1)
         {
            this._349030418lobbyController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lobbyController",_loc2_,param1));
         }
      }
      
      private function onChampionDataDictionaryChanged() : void
      {
         this.configureLandingPage();
      }
      
      private function onFrontpageRemovedFromStage(param1:Event) : void
      {
         this.updateFrontpageDisplay(param1);
         this.dispatchFrontpageEvent("client.blur");
      }
      
      private function _LobbyLanding_UIComponent1_i() : UIComponent
      {
         var _loc1_:UIComponent = new UIComponent();
         this.swfContainer = _loc1_;
         _loc1_.addEventListener("preinitialize",this.__swfContainer_preinitialize);
         _loc1_.id = "swfContainer";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get fadeOut() : Sequence
      {
         return this._1091436750fadeOut;
      }
      
      private function onGetCrossModuleTrackerProvider(param1:ICrossModuleTrackerProvider) : void
      {
         this._clientBehaviorTracker = param1.getClientBehaviorTracker();
         this.configureLandingPage();
      }
      
      private function onCreationComplete() : void
      {
         this.initializeView();
         this.startLobbyLandingWatch();
      }
      
      private function injectFrontpageProperties(param1:Object) : void
      {
         param1.parentInterface.airHostNavigate = this.lobbyNavigateCallback;
         param1.parentInterface.spectateFeaturedGame = this.SpectateFeaturedGameCallback;
         param1.parentInterface.championsData = this.getChampionsDataAsJson();
         param1.parentInterface.showFrontpage = this.showFrontpage;
         param1.parentInterface.hideFrontpage = this.hideFrontpage;
         param1.parentInterface.locale = this.clientConfig.locale;
         param1.parentInterface.region = this.clientConfig.regionTag;
         param1.parentInterface.featuredGamesURL = this.clientConfig.featuredGamesURL;
         param1.parentInterface.getSummonerInfo = this.getSummonerInfo;
      }
      
      private function SpectateFeaturedGameCallback(param1:String) : void
      {
         var _loc2_:Object = jsonDecode(param1);
         this.spectateFeaturedGame(_loc2_);
      }
      
      [Bindable(event="propertyChange")]
      public function get buttonsCol() : ConstraintColumn
      {
         return this._359435839buttonsCol;
      }
      
      public function __htmlLandingPanel_complete(param1:Event) : void
      {
         this.onHtmlLandingPanelComplete();
      }
      
      private function _LobbyLanding_AddChild2_c() : AddChild
      {
         var _loc1_:AddChild = new AddChild();
         _loc1_.targetFactory = new DeferredInstanceFromFunction(this._LobbyLanding_Canvas2_i);
         return _loc1_;
      }
      
      private function _LobbyLanding_State3_c() : State
      {
         var _loc1_:State = new State();
         _loc1_.name = "swfLanding";
         _loc1_.overrides = [this._LobbyLanding_AddChild3_c()];
         return _loc1_;
      }
      
      private function setupFrontpage(param1:Event) : void
      {
         var _loc2_:URLRequest = new URLRequest("app:/assets/htmlTemplates/frontpageFrame.html");
         this._htmlFrontpageLoader = new HTMLLoader();
         this._htmlFrontpageLoader.alpha = 1;
         this._htmlFrontpageLoader.paintsDefaultBackground = false;
         this._htmlFrontpageLoader.scaleX = 1;
         this._htmlFrontpageLoader.scaleY = 1;
         this._htmlFrontpageLoader.addEventListener("htmlDOMInitialize",this.frontpageDOMInitializeHandler);
         this.positionFrontpageLoader();
         this._scaleFreeZone.addChild(this._htmlFrontpageLoader);
         this._scaleFreeZone.addEventListener(Event.RESIZE,this.updateFrontpageDisplay);
         this._htmlFrontpageLoader.addEventListener(MouseEvent.MOUSE_OUT,this.resetCursor);
         this._htmlFrontpageLoader.load(_loc2_);
      }
      
      public function __swfContainer_preinitialize(param1:FlexEvent) : void
      {
         this.swfContainer_preinitializeHandler(param1);
      }
      
      public function set swfContainer(param1:UIComponent) : void
      {
         var _loc2_:Object = this._1599266847swfContainer;
         if(_loc2_ !== param1)
         {
            this._1599266847swfContainer = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"swfContainer",_loc2_,param1));
         }
      }
      
      private function onInventoryProvider(param1:IInventoryProvider) : void
      {
         this._inventory = param1.getInventory();
         this._inventory.championDataDictionaryChanged.add(this.onChampionDataDictionaryChanged);
         this.configureLandingPage();
      }
      
      private function updateFrontpageDisplay(param1:Event) : void
      {
         if(this._htmlFrontpageLoader == null || this.htmlFrontPageMarker.stage == null)
         {
            return;
         }
         if(param1.type == Event.ADDED_TO_STAGE || param1.type == Event.RESIZE)
         {
            this.positionFrontpageLoader();
            this._htmlFrontpageLoader.alpha = 1;
            this._htmlFrontpageLoader.visible = true;
         }
         else
         {
            this._htmlFrontpageLoader.alpha = 0;
            this._htmlFrontpageLoader.visible = false;
         }
      }
      
      [Bindable("lobbyLandingUrlChange")]
      public function get lobbyLandingURL() : String
      {
         return this._lobbyLandingUrl;
      }
      
      [Bindable(event="propertyChange")]
      private function get landingIsLoading() : Boolean
      {
         return this._1120565339landingIsLoading;
      }
      
      private function dispatchFrontpageEvent(param1:String) : void
      {
         this._htmlFrontpageLoader.window.dispatchFrontpageEvent(param1);
      }
      
      public function initializeView() : void
      {
         if(this.clientConfig.clientMode == ClientConfig.SPECIAL_MODE_TENCENT)
         {
            this.chatViewMediator.openBuddyList();
         }
      }
      
      public function set fadeOut(param1:Sequence) : void
      {
         var _loc2_:Object = this._1091436750fadeOut;
         if(_loc2_ !== param1)
         {
            this._1091436750fadeOut = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"fadeOut",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get mainSpinnerBackground() : Image
      {
         return this._1395123346mainSpinnerBackground;
      }
      
      public function __htmlLandingPanel_mouseOut(param1:MouseEvent) : void
      {
         this.resetCursor(param1);
      }
      
      private function _LobbyLanding_HTML1_i() : HTML
      {
         var _loc1_:HTML = new HTML();
         this.htmlLandingPanel = _loc1_;
         _loc1_.alpha = 0;
         _loc1_.setStyle("bottom","0");
         _loc1_.setStyle("top","0");
         _loc1_.setStyle("left","0");
         _loc1_.setStyle("right","0");
         _loc1_.setStyle("verticalScrollBarStyleName","chatScroll");
         _loc1_.setStyle("horizontalScrollBarStyleName","chatScroll");
         _loc1_.setStyle("backgroundAlpha",1);
         _loc1_.setStyle("backgroundColor",0);
         _loc1_.addEventListener("complete",this.__htmlLandingPanel_complete);
         _loc1_.addEventListener("mouseOut",this.__htmlLandingPanel_mouseOut);
         _loc1_.id = "htmlLandingPanel";
         BindingManager.executeBindings(this,"htmlLandingPanel",this.htmlLandingPanel);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      protected function swfContainer_preinitializeHandler(param1:FlexEvent) : void
      {
         this.configureLandingPage();
      }
      
      private function _LobbyLanding_AddChild1_c() : AddChild
      {
         var _loc1_:AddChild = new AddChild();
         _loc1_.targetFactory = new DeferredInstanceFromFunction(this._LobbyLanding_HTML1_i);
         return _loc1_;
      }
      
      private function onShow() : void
      {
         this.initializeView();
      }
      
      public function set buttonsCol(param1:ConstraintColumn) : void
      {
         var _loc2_:Object = this._359435839buttonsCol;
         if(_loc2_ !== param1)
         {
            this._359435839buttonsCol = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"buttonsCol",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get htmlLandingPanel() : HTML
      {
         return this._978073224htmlLandingPanel;
      }
      
      private function configureLandingPage() : void
      {
         var _loc1_:Object = null;
         var _loc2_:Object = null;
         var _loc3_:Object = null;
         var _loc4_:ILobbyLandingPage = null;
         if(!this.landingPageConfigured && this._inventory != null && this._inventory.championDataDictionary != null && this.swfContainer != null)
         {
            this.landingPageConfigured = true;
            this._landingPageDisplay = new DisplayAdapter(this.swfContainer);
            _loc1_ = {};
            for each(_loc2_ in this._inventory.championDataDictionary)
            {
               _loc1_[_loc2_.championId] = {
                  "id":_loc2_.championId,
                  "skinName":_loc2_.skinName
               };
            }
            _loc1_ = jsonEncode(_loc1_);
            _loc3_ = {};
            _loc3_.localeChain = this.resourceManager.localeChain.join(",");
            _loc3_.regionTag = this.clientConfig.regionTag;
            _loc3_.championsObject = _loc1_;
            _loc3_.observerModeEnabled = this.clientConfig.observerModeEnabled;
            if(this.clientConfig.featuredGamesURL)
            {
               _loc3_.featuredGamesURL = this.clientConfig.featuredGamesURL;
            }
            _loc4_ = LobbyLandingPageProxy.instance;
            _loc4_.configureLandingPage(_loc3_);
            _loc4_.showLandingPage(this._landingPageDisplay);
            _loc4_.getJsonNavigate().add(this.lobbyNavigateCallback);
            _loc4_.getReady().addOnce(this.swfReadyHandler);
            _loc4_.getSpectateFeaturedGame().add(this.spectateFeaturedGame);
         }
      }
      
      public function set fadeIn(param1:Sequence) : void
      {
         var _loc2_:Object = this._1282133823fadeIn;
         if(_loc2_ !== param1)
         {
            this._1282133823fadeIn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"fadeIn",_loc2_,param1));
         }
      }
      
      private function _LobbyLanding_State2_c() : State
      {
         var _loc1_:State = new State();
         _loc1_.name = "htmlFrontpage";
         _loc1_.overrides = [this._LobbyLanding_AddChild2_c()];
         return _loc1_;
      }
      
      private function resetCursor(param1:Event) : void
      {
         var _loc2_:ICursorManager = CursorManager.getInstance();
         var _loc3_:String = _loc2_.getCurrentCursorId();
         _loc2_.addCursor("auto");
      }
      
      [Bindable(event="propertyChange")]
      public function get htmlFrontPageMarker() : Canvas
      {
         return this._821648263htmlFrontPageMarker;
      }
      
      private function onClientFeaturedContentProvider(param1:IClientFeaturedContentProvider) : void
      {
         this._featuredContentProvider = param1;
         this.configureLandingPage();
      }
      
      public function __htmlFrontPageMarker_removedFromStage(param1:Event) : void
      {
         this.onFrontpageRemovedFromStage(param1);
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:LobbyLanding = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._LobbyLanding_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_lobby_landing_LobbyLandingWatcherSetupUtil");
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
      
      private function getSummonerInfo() : Object
      {
         var _loc1_:* = new Object();
         _loc1_.summonerLevel = Session.instance.summonerLevel;
         return _loc1_;
      }
      
      private function _LobbyLanding_Fade2_c() : Fade
      {
         var _loc1_:Fade = new Fade();
         _loc1_.duration = 375;
         _loc1_.alphaFrom = 1;
         _loc1_.alphaTo = 0;
         _loc1_.startDelay = 0;
         return _loc1_;
      }
      
      private function injectProperties() : void
      {
         this.htmlLandingPanel.domWindow.airHostNavigate = this.lobbyNavigateCallback;
         this.htmlLandingPanel.domWindow.spectateFeaturedGame = this.SpectateFeaturedGameCallback;
      }
      
      private function _LobbyLanding_SetPropertyAction2_c() : SetPropertyAction
      {
         var _loc1_:SetPropertyAction = new SetPropertyAction();
         _loc1_.name = "alpha";
         _loc1_.value = 1;
         return _loc1_;
      }
      
      private function getOriginFromUrl(param1:String) : String
      {
         var _loc2_:String = null;
         var _loc3_:String = null;
         _loc3_ = URLUtil.getServerNameWithPort(param1);
         _loc2_ = URLUtil.getProtocol(param1);
         return _loc2_ + "://" + _loc3_;
      }
      
      private function _LobbyLanding_ConstraintColumn2_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.buttonsCol = _loc1_;
         _loc1_.width = 301;
         _loc1_.initialized(this,"buttonsCol");
         return _loc1_;
      }
      
      private function startLobbyLandingWatch() : void
      {
         this.clientConfig.getLobbyLandingURLChanged().add(this.lobbyLandingUrlChangedHandler);
         this.resourceManager.addEventListener(Event.CHANGE,this.resourceManagerChangeHandler);
         this.refreshLobbyLandingUrl();
      }
      
      private function set landingIsLoading(param1:Boolean) : void
      {
         var _loc2_:Object = this._1120565339landingIsLoading;
         if(_loc2_ !== param1)
         {
            this._1120565339landingIsLoading = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"landingIsLoading",_loc2_,param1));
         }
      }
      
      public function spectateFeaturedGame(param1:Object) : void
      {
         this.spectatorController.featuredGameObject = {
            "gameId":param1.gameId,
            "platformId":param1.platformId,
            "encryptionKey":param1.encryptionKey,
            "mapId":param1.mapId,
            "gameType":param1.gameType
         };
         this.spectatorController.spectateFeaturedGame(param1.gameId,param1.platformId,param1.encryptionKey,param1.mapId,param1.gameType);
      }
      
      private function _LobbyLanding_Sequence2_i() : Sequence
      {
         var _loc1_:Sequence = new Sequence();
         this.fadeOut = _loc1_;
         _loc1_.children = [this._LobbyLanding_SetPropertyAction2_c(),this._LobbyLanding_Fade2_c()];
         return _loc1_;
      }
      
      private function showFrontpage() : void
      {
         this.landingIsLoading = false;
         if(UserPreferencesManager.globalPrefs.enableAnimations)
         {
            this.fadeIn.play([this._htmlFrontpageLoader]);
         }
         else
         {
            this._htmlFrontpageLoader.alpha = 1;
         }
      }
      
      private function isHtmlFrontpage(param1:String) : Boolean
      {
         var _loc2_:RegExp = /frontpage[.]([^.]+[.])?leagueoflegends[.]com$/;
         var _loc3_:* = URLUtil.getServerName(param1);
         return _loc3_.match(_loc2_) !== null ? true : false;
      }
      
      private function onScaleFreeProvider(param1:IScaleFreeProvider) : void
      {
         this._scaleFreeZone = param1.getScaleFreeZone();
      }
      
      private function _LobbyLanding_State1_c() : State
      {
         var _loc1_:State = new State();
         _loc1_.name = "htmlLanding";
         _loc1_.overrides = [this._LobbyLanding_AddChild1_c()];
         return _loc1_;
      }
      
      private function lobbyNavigateCallback(param1:String) : void
      {
         var state:String = param1;
         var params:Object = null;
         try
         {
            params = jsonDecode(state);
         }
         catch(e:Error)
         {
            trace(e.getStackTrace());
         }
         if(params != null)
         {
            switch(params.type)
            {
               case "queue":
               case "invite":
                  this.lobbyController.navigateToQueue(params.queueid,params.solo,params.gameMap,params.difficulty);
                  break;
               case "gameFlow":
                  this.lobbyController.navigateToGameFlow(params.flowOptions);
                  break;
               case "gameFlowCommand":
                  this.lobbyController.issueGameFlowCommand(params.command);
                  break;
               case "store":
                  if(this.clientConfig.storeEnabled)
                  {
                     this.lobbyController.showStoreView(params.relativeUrl,params.queryString);
                  }
                  break;
               case "inventory":
                  this.storeController.openInventoryBrowser(params.fullItemId,params.skinId,ChampionDetailContext.LANDING_PAGE);
                  break;
               case "lolclient.featuredContentPopup":
                  if(this._featuredContentProvider != null)
                  {
                     if(params.resourceID != null)
                     {
                        this._featuredContentProvider.displayPopup(params.resourceID);
                     }
                     else
                     {
                        this._featuredContentProvider.displayPopup();
                     }
                  }
                  break;
               default:
                  throw new Error("unknown navigation type: " + params.type);
            }
         }
      }
      
      private function onInitialize() : void
      {
         ProviderLookup.getProvider(IInventoryProvider,this.onInventoryProvider);
         ProviderLookup.getProvider(ICrossModuleTrackerProvider,this.onGetCrossModuleTrackerProvider);
         ProviderLookup.getProvider(IClientFeaturedContentProvider,this.onClientFeaturedContentProvider);
         ProviderLookup.getProvider(IScaleFreeProvider,this.onScaleFreeProvider);
      }
      
      private function onHtmlLandingPanelComplete() : void
      {
         this.landingIsLoading = false;
         this.htmlLandingPanel.htmlLoader.navigateInSystemBrowser = true;
         if(UserPreferencesManager.globalPrefs.enableAnimations)
         {
            this.fadeIn.play([this.htmlLandingPanel]);
         }
         else
         {
            this.htmlLandingPanel.alpha = 1;
         }
         this.injectProperties();
      }
      
      public function __htmlFrontPageMarker_addedToStage(param1:Event) : void
      {
         this.updateFrontpageDisplay(param1);
      }
      
      private function frontpageDOMInitializeHandler(param1:Event) : void
      {
         var parentInterface:Object = null;
         var locationOrigin:String = null;
         var event:Event = param1;
         locationOrigin = this.getOriginFromUrl(this.lobbyLandingURL);
         this._htmlFrontpageLoader.navigateInSystemBrowser = true;
         this._htmlFrontpageLoader.window.onload = function():void
         {
            injectFrontpageProperties(_htmlFrontpageLoader.window);
            _htmlFrontpageLoader.window.initializeFrontpage(locationOrigin,lobbyLandingURL);
         };
      }
      
      [Bindable(event="propertyChange")]
      public function get fadeIn() : Sequence
      {
         return this._1282133823fadeIn;
      }
      
      private function _LobbyLanding_Fade1_c() : Fade
      {
         var _loc1_:Fade = new Fade();
         _loc1_.duration = 375;
         _loc1_.alphaFrom = 0;
         _loc1_.alphaTo = 1;
         _loc1_.startDelay = 0;
         return _loc1_;
      }
      
      public function set mainSpinnerBackground(param1:Image) : void
      {
         var _loc2_:Object = this._1395123346mainSpinnerBackground;
         if(_loc2_ !== param1)
         {
            this._1395123346mainSpinnerBackground = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"mainSpinnerBackground",_loc2_,param1));
         }
      }
      
      private function swfReadyHandler() : void
      {
         this.landingIsLoading = false;
      }
      
      private function lobbyLandingUrlChangedHandler(param1:String, param2:String) : void
      {
         this.refreshLobbyLandingUrl();
      }
      
      private function _LobbyLanding_SetPropertyAction1_c() : SetPropertyAction
      {
         var _loc1_:SetPropertyAction = new SetPropertyAction();
         _loc1_.name = "alpha";
         _loc1_.value = 0;
         return _loc1_;
      }
      
      public function __htmlFrontPageMarker_creationComplete(param1:FlexEvent) : void
      {
         this.setupFrontpage(param1);
      }
      
      private function _LobbyLanding_ConstraintColumn1_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.leftCol = _loc1_;
         _loc1_.width = 872;
         _loc1_.initialized(this,"leftCol");
         return _loc1_;
      }
      
      private function _LobbyLanding_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.htmlLandingPanel.scaleX == 1 ? "off" : "auto";
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            htmlLandingPanel.horizontalScrollPolicy = param1;
         },"htmlLandingPanel.horizontalScrollPolicy");
         result[0] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.htmlLandingPanel.scaleY == 1 ? "off" : "auto";
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            htmlLandingPanel.verticalScrollPolicy = param1;
         },"htmlLandingPanel.verticalScrollPolicy");
         result[1] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = lobbyLandingURL;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            htmlLandingPanel.location = param1;
         },"htmlLandingPanel.location");
         result[2] = binding;
         binding = new Binding(this,function():Number
         {
            return this.htmlLandingPanel.scaleX == 1 ? 800 : 0;
         },function(param1:Number):void
         {
            htmlLandingPanel.minHeight = param1;
         },"htmlLandingPanel.minHeight");
         result[3] = binding;
         binding = new Binding(this,function():Number
         {
            return 1 / this.parentApplication.scaleX;
         },function(param1:Number):void
         {
            htmlLandingPanel.scaleX = param1;
         },"htmlLandingPanel.scaleX");
         result[4] = binding;
         binding = new Binding(this,function():Number
         {
            return 1 / this.parentApplication.scaleY;
         },function(param1:Number):void
         {
            htmlLandingPanel.scaleY = param1;
         },"htmlLandingPanel.scaleY");
         result[5] = binding;
         binding = new Binding(this,function():Object
         {
            return landingIsLoading ? LOADING_SPINNER : null;
         },function(param1:Object):void
         {
            mainSpinnerBackground.source = param1;
         },"mainSpinnerBackground.source");
         result[6] = binding;
         binding = new Binding(this,function():Boolean
         {
            return landingIsLoading;
         },function(param1:Boolean):void
         {
            mainSpinnerBackground.visible = param1;
         },"mainSpinnerBackground.visible");
         result[7] = binding;
         return result;
      }
      
      private function refreshLobbyLandingUrl() : void
      {
         var _loc1_:String = null;
         var _loc2_:Boolean = false;
         var _loc3_:Boolean = false;
         var _loc4_:Boolean = false;
         this._lobbyLandingUrl = this.clientConfig.lobbyLandingURL != null ? this.clientConfig.lobbyLandingURL : this.resourceManager.getString("resources","lobbyLandingURL");
         if(this._lobbyLandingUrl != null)
         {
            if(this._lobbyLandingUrl != null && this._lobbyLandingUrl.indexOf("$localeCode") > -1)
            {
               this._lobbyLandingUrl = this._lobbyLandingUrl.split("$localeCode").join(ClientConfig.instance.locale);
            }
            _loc1_ = this._lobbyLandingUrl.toLowerCase();
            _loc2_ = _loc1_.indexOf("blank.org") == -1;
            if(_loc2_)
            {
               _loc3_ = _loc1_.indexOf(".swf") != -1;
               _loc4_ = this.isHtmlFrontpage(_loc1_);
               if(!this._lobbyLandingUrl || _loc3_ && !_loc4_)
               {
                  currentState = "swfLanding";
               }
               else if(_loc4_)
               {
                  currentState = "htmlFrontpage";
               }
               else
               {
                  currentState = "htmlLanding";
               }
               dispatchEvent(new Event("lobbyLandingUrlChange"));
               if(this._lobbyLandingUrl.indexOf("http://www.leagueoflegends.") != 0)
               {
                  switch(this._lobbyLandingUrl)
                  {
                     case "http://d2q6fdmnncz9b0.cloudfront.net/landingPage.swf":
                     case "http://main1replay.riotgames.com/landing/landingPage.swf":
                     case "http://landing.leagueoflegends.com/spectator_swf/landingPage.swf":
                     case "http://store-swfs.s3.amazonaws.com/landingPage.swf":
                        break;
                     default:
                        this._clientBehaviorTracker.recordLandingPageURL(this._lobbyLandingUrl,"UNKNOWN");
                  }
               }
            }
            else
            {
               this._clientBehaviorTracker.recordLandingPageURL(this._lobbyLandingUrl,"BAD");
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get clientConfig() : ClientConfig
      {
         return this._1895424275clientConfig;
      }
      
      public function ___LobbyLanding_Canvas1_initialize(param1:FlexEvent) : void
      {
         this.onInitialize();
      }
      
      public function set htmlLandingPanel(param1:HTML) : void
      {
         var _loc2_:Object = this._978073224htmlLandingPanel;
         if(_loc2_ !== param1)
         {
            this._978073224htmlLandingPanel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"htmlLandingPanel",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get leftCol() : ConstraintColumn
      {
         return this._55416825leftCol;
      }
      
      private function _LobbyLanding_Sequence1_i() : Sequence
      {
         var _loc1_:Sequence = new Sequence();
         this.fadeIn = _loc1_;
         _loc1_.children = [this._LobbyLanding_SetPropertyAction1_c(),this._LobbyLanding_Fade1_c()];
         return _loc1_;
      }
      
      private function set clientConfig(param1:ClientConfig) : void
      {
         var _loc2_:Object = this._1895424275clientConfig;
         if(_loc2_ !== param1)
         {
            this._1895424275clientConfig = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"clientConfig",_loc2_,param1));
         }
      }
      
      private function _LobbyLanding_AddChild3_c() : AddChild
      {
         var _loc1_:AddChild = new AddChild();
         _loc1_.targetFactory = new DeferredInstanceFromFunction(this._LobbyLanding_UIComponent1_i);
         return _loc1_;
      }
      
      public function ___LobbyLanding_Canvas1_creationComplete(param1:FlexEvent) : void
      {
         this.onCreationComplete();
      }
   }
}

