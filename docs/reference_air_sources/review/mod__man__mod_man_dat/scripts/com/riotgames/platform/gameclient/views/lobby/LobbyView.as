package com.riotgames.platform.gameclient.views.lobby
{
   import blix.assets.proxy.DisplayAdapter;
   import com.riotgames.platform.common.provider.CapProviderProxy;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.gameclient.components.containers.LazyViewstack;
   import com.riotgames.platform.gameclient.controllers.lobby.event.StoreNavigationEvent;
   import com.riotgames.platform.gameclient.domain.lobby.LobbyViewState;
   import com.riotgames.platform.gameclient.views.ViewMediator;
   import com.riotgames.platform.gameclient.views.game.NewGameViews;
   import com.riotgames.platform.gameclient.views.game.normal.CreateNormalArrangedGame;
   import com.riotgames.platform.gameclient.views.lobby.landing.LobbyLanding;
   import com.riotgames.platform.gameclient.views.lobby.landing.StoryView;
   import com.riotgames.platform.gameclient.views.profile.ProfileView;
   import com.riotgames.platform.gameclient.views.store.StoreView;
   import com.riotgames.pvpnet.game.controllers.MasterGameController;
   import com.riotgames.pvpnet.game.controllers.MasterGameViewController;
   import com.riotgames.pvpnet.game.controllers.lobby.ILobbyViewController;
   import com.riotgames.pvpnet.game.controllers.lobby.LobbyConfig;
   import com.riotgames.pvpnet.summonerprofile.SummonerProfileProviderContainerProxy;
   import com.riotgames.pvpnet.system.alerter.AlertWaitAction;
   import com.riotgames.pvpnet.system.alerter.AlerterProviderProxy;
   import com.riotgames.pvpnet.system.alerter.IAlerterProvider;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.maestro.IMaestroProvider;
   import com.riotgames.pvpnet.system.maestro.MaestroProviderProxy;
   import com.riotgames.pvpnet.watch.IWatchTabProvider;
   import com.riotgames.pvpnet.watch.WatchTabProviderProxy;
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
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.events.StateChangeEvent;
   import mx.managers.CursorManager;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.states.State;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class LobbyView extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private static const LOBBY_MAIN_GAME_MENU:String = "lobbyCancelWaitMatchmakingState";
      
      [Inject]
      private var _269543472masterGameController:MasterGameController;
      
      public var alerter:IAlerterProvider = AlerterProviderProxy.instance;
      
      [Inject]
      private var _349030418lobbyController:ILobbyViewController;
      
      public var _LobbyView_State10:State;
      
      public var _LobbyView_State11:State;
      
      public var _LobbyView_State12:State;
      
      public var _LobbyView_State13:State;
      
      public var _LobbyView_State14:State;
      
      public var _LobbyView_State15:State;
      
      [Inject]
      public var chatController:ChatController;
      
      private var _createNormalGameQueue_c:CreateNormalArrangedGame;
      
      private var waitAction:AlertWaitAction;
      
      private var _profileViewAdapter:DisplayAdapter;
      
      private var _1895424275clientConfig:ClientConfig = ClientConfig.instance;
      
      private var _lobbyLanding_c:Canvas;
      
      private var _1984987798session:Session = Session.instance;
      
      private var _profileView:UIComponent;
      
      mx_internal var _bindingsByDestination:Object = {};
      
      private var _watchTabHolder_c:UIComponent;
      
      private var _viewStore_c:StoreView;
      
      private var isBusyChangeWatcher:ChangeWatcher;
      
      private var _viewStory_c:StoryView;
      
      private var _1732210219maestroController:IMaestroProvider = MaestroProviderProxy.instance;
      
      public var _LobbyView_State1:State;
      
      public var _LobbyView_State2:State;
      
      public var _LobbyView_State3:State;
      
      public var _LobbyView_State4:State;
      
      public var _LobbyView_State5:State;
      
      public var _LobbyView_State6:State;
      
      public var _LobbyView_State7:State;
      
      public var _LobbyView_State8:State;
      
      public var _LobbyView_State9:State;
      
      mx_internal var _watchers:Array = [];
      
      private var capView:UIComponent = new UIComponent();
      
      private var joinQueueWatcher:ChangeWatcher;
      
      [Inject]
      public var viewMediator:ViewMediator;
      
      private var _gameViews_c:NewGameViews;
      
      private var _407108067content_c:LazyViewstack;
      
      mx_internal var _bindingsBeginWithWord:Object = {};
      
      public var capProvider:CapProviderProxy = new CapProviderProxy();
      
      mx_internal var _bindings:Array = [];
      
      [Inject]
      private var _1450947915masterGameViewController:MasterGameViewController;
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {"childDescriptors":[new UIComponentDescriptor({
               "type":LazyViewstack,
               "id":"content_c",
               "events":{"creationComplete":"__content_c_creationComplete"},
               "stylesFactory":function():void
               {
                  this.left = "0";
                  this.right = "0";
                  this.top = "0";
                  this.bottom = "0";
               },
               "propertiesFactory":function():Object
               {
                  return {"clipContent":false};
               }
            })]};
         }
      });
      
      public function LobbyView()
      {
         super();
         mx_internal::_document = this;
         this.cacheAsBitmap = true;
         this.percentWidth = 100;
         this.percentHeight = 100;
         this.verticalScrollPolicy = "off";
         this.horizontalScrollPolicy = "off";
         this.states = [this._LobbyView_State1_i(),this._LobbyView_State2_i(),this._LobbyView_State3_i(),this._LobbyView_State4_i(),this._LobbyView_State5_i(),this._LobbyView_State6_i(),this._LobbyView_State7_i(),this._LobbyView_State8_i(),this._LobbyView_State9_i(),this._LobbyView_State10_i(),this._LobbyView_State11_i(),this._LobbyView_State12_i(),this._LobbyView_State13_i(),this._LobbyView_State14_i(),this._LobbyView_State15_i()];
         this.addEventListener("initialize",this.___LobbyView_Canvas1_initialize);
         this.addEventListener("creationComplete",this.___LobbyView_Canvas1_creationComplete);
         this.addEventListener("show",this.___LobbyView_Canvas1_show);
         this.addEventListener("hide",this.___LobbyView_Canvas1_hide);
         this.addEventListener("currentStateChange",this.___LobbyView_Canvas1_currentStateChange);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         LobbyView._watcherSetupUtil = param1;
      }
      
      private function _LobbyView_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = LobbyConfig.instance.currentLobbyState;
         _loc1_ = LobbyViewState.LOGIN_VIEW_STATE;
         _loc1_ = LobbyViewState.LOBBY_LANDING_STATE;
         _loc1_ = LobbyViewState.PLAY_PRACTICE_GAME_STATE;
         _loc1_ = LobbyViewState.PLAY_TUTORIAL_GAME_STATE;
         _loc1_ = LobbyViewState.PLAY_GAME_STATE;
         _loc1_ = LobbyViewState.SUMMONER_INFO_STATE;
         _loc1_ = LobbyViewState.SUMMONER_TALENTTREE_STATE;
         _loc1_ = LobbyViewState.SUMMONER_SPELLBOOK_STATE;
         _loc1_ = LobbyViewState.SUMMONER_GRABBAG_STATE;
         _loc1_ = LobbyViewState.SUMMONER_RUNECOMBINER_STATE;
         _loc1_ = LobbyViewState.STORE_VIEW_STATE;
         _loc1_ = LobbyViewState.STORY_VIEW_STATE;
         _loc1_ = LobbyViewState.CREATE_ARRANGED_TEAM_STATE;
         _loc1_ = LobbyViewState.WATCH_TAB_STATE;
         _loc1_ = LobbyViewState.CAP_STATE;
      }
      
      private function get lobbyLanding_c() : Canvas
      {
         if(!this._lobbyLanding_c)
         {
            this._lobbyLanding_c = new LobbyLanding();
            this._lobbyLanding_c.visible = false;
         }
         return this._lobbyLanding_c;
      }
      
      [Bindable(event="propertyChange")]
      public function get clientConfig() : ClientConfig
      {
         return this._1895424275clientConfig;
      }
      
      public function preloadContent() : void
      {
      }
      
      public function ___LobbyView_Canvas1_initialize(param1:FlexEvent) : void
      {
         this.onInitialize();
      }
      
      [Bindable(event="propertyChange")]
      public function get maestroController() : IMaestroProvider
      {
         return this._1732210219maestroController;
      }
      
      [Bindable(event="propertyChange")]
      public function get content_c() : LazyViewstack
      {
         return this._407108067content_c;
      }
      
      private function _LobbyView_State3_i() : State
      {
         var _loc1_:State = new State();
         this._LobbyView_State3 = _loc1_;
         BindingManager.executeBindings(this,"_LobbyView_State3",this._LobbyView_State3);
         return _loc1_;
      }
      
      private function onCreationComplete() : void
      {
         this.lobbyController.storeNavigated.add(this.storeNavigateHandler);
         this.lobbyController.storeRefreshed.add(this.storeRefreshHandler);
      }
      
      private function get viewStore_c() : StoreView
      {
         if(!this._viewStore_c)
         {
            this._viewStore_c = new StoreView();
            this._viewStore_c.visible = false;
         }
         return this._viewStore_c;
      }
      
      private function _LobbyView_State12_i() : State
      {
         var _loc1_:State = new State();
         this._LobbyView_State12 = _loc1_;
         BindingManager.executeBindings(this,"_LobbyView_State12",this._LobbyView_State12);
         return _loc1_;
      }
      
      private function _LobbyView_State7_i() : State
      {
         var _loc1_:State = new State();
         this._LobbyView_State7 = _loc1_;
         BindingManager.executeBindings(this,"_LobbyView_State7",this._LobbyView_State7);
         return _loc1_;
      }
      
      private function get viewStory_c() : StoryView
      {
         if(!this._viewStory_c)
         {
            this._viewStory_c = new StoryView();
            this._viewStory_c.clientConfig = this.clientConfig;
            this._viewStory_c.visible = false;
         }
         return this._viewStory_c;
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
      
      private function storeRefreshHandler(param1:StoreNavigationEvent) : void
      {
         if(LobbyConfig.instance.currentLobbyState == LobbyViewState.STORE_VIEW_STATE)
         {
            this.viewStore_c.refreshStore(param1.storeRelativeUrl,true);
         }
         else
         {
            this.viewStore_c.setPageDirty(true);
         }
      }
      
      public function set content_c(param1:LazyViewstack) : void
      {
         var _loc2_:Object = this._407108067content_c;
         if(_loc2_ !== param1)
         {
            this._407108067content_c = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"content_c",_loc2_,param1));
         }
      }
      
      public function set session(param1:Session) : void
      {
         var _loc2_:Object = this._1984987798session;
         if(_loc2_ !== param1)
         {
            this._1984987798session = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"session",_loc2_,param1));
         }
      }
      
      public function ___LobbyView_Canvas1_show(param1:FlexEvent) : void
      {
         this.onShow();
      }
      
      public function ___LobbyView_Canvas1_creationComplete(param1:FlexEvent) : void
      {
         this.onCreationComplete();
      }
      
      [Bindable(event="propertyChange")]
      [Inject]
      public function get lobbyController() : ILobbyViewController
      {
         return this._349030418lobbyController;
      }
      
      public function __content_c_creationComplete(param1:FlexEvent) : void
      {
         this.viewStackReady();
      }
      
      public function set maestroController(param1:IMaestroProvider) : void
      {
         var _loc2_:Object = this._1732210219maestroController;
         if(_loc2_ !== param1)
         {
            this._1732210219maestroController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"maestroController",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      [Inject]
      public function get masterGameController() : MasterGameController
      {
         return this._269543472masterGameController;
      }
      
      private function get createNormalGameQueue_c() : CreateNormalArrangedGame
      {
         if(!this._createNormalGameQueue_c)
         {
            this._createNormalGameQueue_c = new CreateNormalArrangedGame();
            this._createNormalGameQueue_c.visible = false;
         }
         return this._createNormalGameQueue_c;
      }
      
      public function set masterGameController(param1:MasterGameController) : void
      {
         var _loc2_:Object = this._269543472masterGameController;
         if(_loc2_ !== param1)
         {
            this._269543472masterGameController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"masterGameController",_loc2_,param1));
         }
      }
      
      private function _LobbyView_State2_i() : State
      {
         var _loc1_:State = new State();
         this._LobbyView_State2 = _loc1_;
         BindingManager.executeBindings(this,"_LobbyView_State2",this._LobbyView_State2);
         return _loc1_;
      }
      
      public function set masterGameViewController(param1:MasterGameViewController) : void
      {
         var _loc2_:Object = this._1450947915masterGameViewController;
         if(_loc2_ !== param1)
         {
            this._1450947915masterGameViewController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"masterGameViewController",_loc2_,param1));
         }
      }
      
      private function _LobbyView_State6_i() : State
      {
         var _loc1_:State = new State();
         this._LobbyView_State6 = _loc1_;
         BindingManager.executeBindings(this,"_LobbyView_State6",this._LobbyView_State6);
         return _loc1_;
      }
      
      private function updateViewstackState() : void
      {
         switch(this.currentState)
         {
            case LobbyViewState.LOBBY_LANDING_STATE:
               this.content_c.content = this.lobbyLanding_c;
               break;
            case LobbyViewState.PLAY_PRACTICE_GAME_STATE:
               this.content_c.content = this.gameViews_c;
               break;
            case LobbyViewState.PLAY_TUTORIAL_GAME_STATE:
               this.content_c.content = this.gameViews_c;
               break;
            case LobbyViewState.PLAY_GAME_STATE:
               this.content_c.content = this.gameViews_c;
               break;
            case LobbyViewState.SUMMONER_INFO_STATE:
               this.content_c.content = this.profileView;
               break;
            case LobbyViewState.STORE_VIEW_STATE:
               this.content_c.content = this.viewStore_c;
               break;
            case LobbyViewState.STORY_VIEW_STATE:
               this.content_c.content = this.viewStory_c;
               break;
            case LobbyViewState.CREATE_ARRANGED_TEAM_STATE:
               this.content_c.content = this.createNormalGameQueue_c;
               break;
            case LobbyViewState.WATCH_TAB_STATE:
               this.content_c.content = this.watchTabHolder_c;
               break;
            case LobbyViewState.CAP_STATE:
               this.content_c.content = this.capView;
         }
      }
      
      private function storeNavigateHandler(param1:StoreNavigationEvent) : void
      {
         this.viewStore_c.showStoreRelativeUrl(param1.storeRelativeUrl,param1.storeQueryString);
      }
      
      private function onShow() : void
      {
         if(this.isBusyChangeWatcher == null)
         {
            this.isBusyChangeWatcher = ChangeWatcher.watch(LobbyConfig.instance,"isLobbyBusy",this.onLobbyBusyChanged);
         }
         if(this.joinQueueWatcher == null)
         {
            this.joinQueueWatcher = ChangeWatcher.watch(this.masterGameViewController,"isJoiningMatch",this.onJoiningQueueChanged);
         }
      }
      
      private function _LobbyView_State11_i() : State
      {
         var _loc1_:State = new State();
         this._LobbyView_State11 = _loc1_;
         BindingManager.executeBindings(this,"_LobbyView_State11",this._LobbyView_State11);
         return _loc1_;
      }
      
      private function get gameViews_c() : NewGameViews
      {
         if(!this._gameViews_c)
         {
            this._gameViews_c = new NewGameViews();
            this._gameViews_c.visible = false;
         }
         return this._gameViews_c;
      }
      
      private function _LobbyView_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():String
         {
            var _loc1_:* = LobbyConfig.instance.currentLobbyState;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            this.currentState = param1;
         },"this.currentState");
         result[0] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = LobbyViewState.LOGIN_VIEW_STATE;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _LobbyView_State1.name = param1;
         },"_LobbyView_State1.name");
         result[1] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = LobbyViewState.LOBBY_LANDING_STATE;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _LobbyView_State2.name = param1;
         },"_LobbyView_State2.name");
         result[2] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = LobbyViewState.PLAY_PRACTICE_GAME_STATE;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _LobbyView_State3.name = param1;
         },"_LobbyView_State3.name");
         result[3] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = LobbyViewState.PLAY_TUTORIAL_GAME_STATE;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _LobbyView_State4.name = param1;
         },"_LobbyView_State4.name");
         result[4] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = LobbyViewState.PLAY_GAME_STATE;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _LobbyView_State5.name = param1;
         },"_LobbyView_State5.name");
         result[5] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = LobbyViewState.SUMMONER_INFO_STATE;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _LobbyView_State6.name = param1;
         },"_LobbyView_State6.name");
         result[6] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = LobbyViewState.SUMMONER_TALENTTREE_STATE;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _LobbyView_State7.name = param1;
         },"_LobbyView_State7.name");
         result[7] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = LobbyViewState.SUMMONER_SPELLBOOK_STATE;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _LobbyView_State8.name = param1;
         },"_LobbyView_State8.name");
         result[8] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = LobbyViewState.SUMMONER_GRABBAG_STATE;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _LobbyView_State9.name = param1;
         },"_LobbyView_State9.name");
         result[9] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = LobbyViewState.SUMMONER_RUNECOMBINER_STATE;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _LobbyView_State10.name = param1;
         },"_LobbyView_State10.name");
         result[10] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = LobbyViewState.STORE_VIEW_STATE;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _LobbyView_State11.name = param1;
         },"_LobbyView_State11.name");
         result[11] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = LobbyViewState.STORY_VIEW_STATE;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _LobbyView_State12.name = param1;
         },"_LobbyView_State12.name");
         result[12] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = LobbyViewState.CREATE_ARRANGED_TEAM_STATE;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _LobbyView_State13.name = param1;
         },"_LobbyView_State13.name");
         result[13] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = LobbyViewState.WATCH_TAB_STATE;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _LobbyView_State14.name = param1;
         },"_LobbyView_State14.name");
         result[14] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = LobbyViewState.CAP_STATE;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _LobbyView_State15.name = param1;
         },"_LobbyView_State15.name");
         result[15] = binding;
         return result;
      }
      
      private function viewStackReady() : void
      {
         this.updateViewstackState();
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:LobbyView = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._LobbyView_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_lobby_LobbyViewWatcherSetupUtil");
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
      
      private function _LobbyView_State15_i() : State
      {
         var _loc1_:State = new State();
         this._LobbyView_State15 = _loc1_;
         BindingManager.executeBindings(this,"_LobbyView_State15",this._LobbyView_State15);
         return _loc1_;
      }
      
      public function ___LobbyView_Canvas1_hide(param1:FlexEvent) : void
      {
         this.onHide();
      }
      
      private function onJoiningQueueChanged(param1:PropertyChangeEvent) : void
      {
         var _loc2_:IResourceManager = null;
         if(param1.newValue)
         {
            _loc2_ = ResourceManager.getInstance();
            this.waitAction = new AlertWaitAction(_loc2_.getString("resources","serverWait_retrievingDataMessage"),_loc2_.getString("resources","serverWait_loadingMessage"));
            this.waitAction.add();
         }
         else if(this.waitAction)
         {
            this.waitAction.complete();
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get session() : Session
      {
         return this._1984987798session;
      }
      
      private function onCurrentStateChange(param1:StateChangeEvent) : void
      {
         var _loc2_:String = param1.newState;
         if(!this.content_c)
         {
            return;
         }
         this.updateViewstackState();
      }
      
      private function _LobbyView_State1_i() : State
      {
         var _loc1_:State = new State();
         this._LobbyView_State1 = _loc1_;
         BindingManager.executeBindings(this,"_LobbyView_State1",this._LobbyView_State1);
         return _loc1_;
      }
      
      private function setViewState(param1:String) : void
      {
         this.lobbyController.requestLobbyState(param1);
      }
      
      private function _LobbyView_State10_i() : State
      {
         var _loc1_:State = new State();
         this._LobbyView_State10 = _loc1_;
         BindingManager.executeBindings(this,"_LobbyView_State10",this._LobbyView_State10);
         return _loc1_;
      }
      
      private function _LobbyView_State14_i() : State
      {
         var _loc1_:State = new State();
         this._LobbyView_State14 = _loc1_;
         BindingManager.executeBindings(this,"_LobbyView_State14",this._LobbyView_State14);
         return _loc1_;
      }
      
      private function _LobbyView_State9_i() : State
      {
         var _loc1_:State = new State();
         this._LobbyView_State9 = _loc1_;
         BindingManager.executeBindings(this,"_LobbyView_State9",this._LobbyView_State9);
         return _loc1_;
      }
      
      private function _LobbyView_State5_i() : State
      {
         var _loc1_:State = new State();
         this._LobbyView_State5 = _loc1_;
         BindingManager.executeBindings(this,"_LobbyView_State5",this._LobbyView_State5);
         return _loc1_;
      }
      
      private function onLobbyBusyChanged(param1:PropertyChangeEvent) : void
      {
         if(param1.newValue)
         {
            CursorManager.getInstance().setBusyCursor();
         }
         else
         {
            CursorManager.getInstance().removeBusyCursor();
         }
      }
      
      private function onHide() : void
      {
         if(this.isBusyChangeWatcher != null)
         {
            this.isBusyChangeWatcher.unwatch();
         }
         if(this.joinQueueWatcher != null)
         {
            this.joinQueueWatcher.unwatch();
         }
      }
      
      [Bindable(event="propertyChange")]
      [Inject]
      public function get masterGameViewController() : MasterGameViewController
      {
         return this._1450947915masterGameViewController;
      }
      
      private function onInitialize() : void
      {
         this.capProvider.contentHolder = this.capView;
      }
      
      private function profileViewAddedToStageHandler(param1:Event) : void
      {
         SummonerProfileProviderContainerProxy.instance.showProfileContainer(this._profileViewAdapter);
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
      
      private function profileViewRemovedFromStageHandler(param1:Event) : void
      {
         SummonerProfileProviderContainerProxy.instance.hideProfileContainer(this._profileViewAdapter);
      }
      
      private function get profileView() : UIComponent
      {
         if(!this._profileView)
         {
            if(ClientConfig.instance.useOldProfileContainer)
            {
               this._profileView = new ProfileView();
            }
            else
            {
               this._profileView = new UIComponent();
               this._profileView.addEventListener(Event.ADDED_TO_STAGE,this.profileViewAddedToStageHandler);
               this._profileView.addEventListener(Event.REMOVED_FROM_STAGE,this.profileViewRemovedFromStageHandler);
               this._profileViewAdapter = new DisplayAdapter(this._profileView);
            }
            this._profileView.visible = false;
         }
         return this._profileView;
      }
      
      private function _LobbyView_State4_i() : State
      {
         var _loc1_:State = new State();
         this._LobbyView_State4 = _loc1_;
         BindingManager.executeBindings(this,"_LobbyView_State4",this._LobbyView_State4);
         return _loc1_;
      }
      
      public function ___LobbyView_Canvas1_currentStateChange(param1:StateChangeEvent) : void
      {
         this.onCurrentStateChange(param1);
      }
      
      private function _LobbyView_State8_i() : State
      {
         var _loc1_:State = new State();
         this._LobbyView_State8 = _loc1_;
         BindingManager.executeBindings(this,"_LobbyView_State8",this._LobbyView_State8);
         return _loc1_;
      }
      
      private function _LobbyView_State13_i() : State
      {
         var _loc1_:State = new State();
         this._LobbyView_State13 = _loc1_;
         BindingManager.executeBindings(this,"_LobbyView_State13",this._LobbyView_State13);
         return _loc1_;
      }
      
      private function get watchTabHolder_c() : UIComponent
      {
         var _loc1_:IWatchTabProvider = null;
         if(!this._watchTabHolder_c)
         {
            this._watchTabHolder_c = new UIComponent();
            this._watchTabHolder_c.visible = false;
            _loc1_ = WatchTabProviderProxy.instance;
            _loc1_.setContentHolder(this._watchTabHolder_c);
         }
         return this._watchTabHolder_c;
      }
   }
}

