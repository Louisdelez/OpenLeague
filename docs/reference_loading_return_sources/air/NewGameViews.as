package com.riotgames.platform.gameclient.views.game
{
   import com.riotgames.platform.common.IAppController;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.common.utils.MessageDictionary;
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.gameclient.domain.game.GameViewState;
   import com.riotgames.platform.gameclient.views.game.common.endofgame.EndOfGameView;
   import com.riotgames.platform.gameclient.views.game.common.ingame.InGameView;
   import com.riotgames.platform.gameclient.views.game.practice.create.CreatePracticeGameView;
   import com.riotgames.platform.gameclient.views.game.practice.join.JoinGamePanel;
   import com.riotgames.platform.gameclient.views.game.practice.teamselection.TeamSelectionView2;
   import com.riotgames.pvpnet.game.controllers.MasterGameController;
   import com.riotgames.pvpnet.game.event.UnexpectedGameErrorEvent;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.pvpnet.system.alerter.AlerterProviderProxy;
   import com.riotgames.pvpnet.system.alerter.IAlerterProvider;
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
   import mx.containers.Canvas;
   import mx.containers.Panel;
   import mx.containers.ViewStack;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.events.StateChangeEvent;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.states.State;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class NewGameViews extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      [Inject]
      private var _269543472masterGameController:MasterGameController;
      
      private var panel:Panel;
      
      public var alerter:IAlerterProvider = AlerterProviderProxy.instance;
      
      private var _635413901noScreen:Canvas;
      
      [Inject]
      public var applicationController:IAppController;
      
      private var stateChangeOnInject:Boolean = false;
      
      [Inject]
      public var chatController:ChatController;
      
      private var _352222253teamSelection_c:TeamSelectionView2;
      
      private var _1278638812playingGame_c:InGameView;
      
      mx_internal var _bindingsByDestination:Object = {};
      
      private var _729296837joinPracticeGame_c:JoinGamePanel;
      
      private var _1181187213createPracticeGame_c:CreatePracticeGameView;
      
      private var _beforeHideState:String = "";
      
      public var session:Session = Session.instance;
      
      private var _495403591championSelection_c:Canvas;
      
      mx_internal var _watchers:Array = [];
      
      public var _NewGameViews_State1:State;
      
      public var _NewGameViews_State2:State;
      
      public var _NewGameViews_State3:State;
      
      public var _NewGameViews_State4:State;
      
      public var _NewGameViews_State5:State;
      
      public var _NewGameViews_State6:State;
      
      public var _NewGameViews_State7:State;
      
      public var _NewGameViews_State8:State;
      
      public var _NewGameViews_State9:State;
      
      private var _1097794056endOfGame_c:EndOfGameView;
      
      private var _407108067content_c:ViewStack;
      
      mx_internal var _bindingsBeginWithWord:Object = {};
      
      public var _NewGameViews_State10:State;
      
      public var _NewGameViews_State11:State;
      
      public var _NewGameViews_State12:State;
      
      mx_internal var _bindings:Array = [];
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {"childDescriptors":[new UIComponentDescriptor({
               "type":ViewStack,
               "id":"content_c",
               "propertiesFactory":function():Object
               {
                  return {
                     "percentWidth":100,
                     "percentHeight":100,
                     "x":0,
                     "y":0,
                     "clipContent":false,
                     "childDescriptors":[new UIComponentDescriptor({
                        "type":Canvas,
                        "id":"noScreen",
                        "propertiesFactory":function():Object
                        {
                           return {"cacheAsBitmap":true};
                        }
                     }),new UIComponentDescriptor({
                        "type":CreatePracticeGameView,
                        "id":"createPracticeGame_c"
                     }),new UIComponentDescriptor({
                        "type":JoinGamePanel,
                        "id":"joinPracticeGame_c"
                     }),new UIComponentDescriptor({
                        "type":TeamSelectionView2,
                        "id":"teamSelection_c"
                     }),new UIComponentDescriptor({
                        "type":Canvas,
                        "id":"championSelection_c",
                        "propertiesFactory":function():Object
                        {
                           return {
                              "percentWidth":100,
                              "percentHeight":100
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":InGameView,
                        "id":"playingGame_c",
                        "propertiesFactory":function():Object
                        {
                           return {
                              "percentHeight":100,
                              "percentWidth":100
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":EndOfGameView,
                        "id":"endOfGame_c",
                        "propertiesFactory":function():Object
                        {
                           return {
                              "x":0,
                              "y":0,
                              "percentHeight":100,
                              "percentWidth":100
                           };
                        }
                     })]
                  };
               }
            })]};
         }
      });
      
      public var shellDispatcher:ShellDispatcher = ShellDispatcher.instance;
      
      public function NewGameViews()
      {
         super();
         mx_internal::_document = this;
         this.cacheAsBitmap = true;
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this.percentWidth = 100;
         this.percentHeight = 100;
         this.states = [this._NewGameViews_State1_i(),this._NewGameViews_State2_i(),this._NewGameViews_State3_i(),this._NewGameViews_State4_i(),this._NewGameViews_State5_i(),this._NewGameViews_State6_i(),this._NewGameViews_State7_i(),this._NewGameViews_State8_i(),this._NewGameViews_State9_i(),this._NewGameViews_State10_i(),this._NewGameViews_State11_i(),this._NewGameViews_State12_i()];
         this.addEventListener("initialize",this.___NewGameViews_Canvas1_initialize);
         this.addEventListener("show",this.___NewGameViews_Canvas1_show);
         this.addEventListener("hide",this.___NewGameViews_Canvas1_hide);
         this.addEventListener("currentStateChange",this.___NewGameViews_Canvas1_currentStateChange);
         this.addEventListener("addedToStage",this.___NewGameViews_Canvas1_addedToStage);
         this.addEventListener("creationComplete",this.___NewGameViews_Canvas1_creationComplete);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         NewGameViews._watcherSetupUtil = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function get endOfGame_c() : EndOfGameView
      {
         return this._1097794056endOfGame_c;
      }
      
      public function set endOfGame_c(param1:EndOfGameView) : void
      {
         var _loc2_:Object = this._1097794056endOfGame_c;
         if(_loc2_ !== param1)
         {
            this._1097794056endOfGame_c = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"endOfGame_c",_loc2_,param1));
         }
      }
      
      public function set createPracticeGame_c(param1:CreatePracticeGameView) : void
      {
         var _loc2_:Object = this._1181187213createPracticeGame_c;
         if(_loc2_ !== param1)
         {
            this._1181187213createPracticeGame_c = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"createPracticeGame_c",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get content_c() : ViewStack
      {
         return this._407108067content_c;
      }
      
      public function set noScreen(param1:Canvas) : void
      {
         var _loc2_:Object = this._635413901noScreen;
         if(_loc2_ !== param1)
         {
            this._635413901noScreen = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"noScreen",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get playingGame_c() : InGameView
      {
         return this._1278638812playingGame_c;
      }
      
      private function _NewGameViews_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():String
         {
            var _loc1_:* = masterGameController.currentState;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            this.currentState = param1;
         },"this.currentState");
         result[0] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = GameViewState.TUTORIAL_GAME;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _NewGameViews_State1.name = param1;
         },"_NewGameViews_State1.name");
         result[1] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = GameViewState.CREATE_GAME;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _NewGameViews_State2.name = param1;
         },"_NewGameViews_State2.name");
         result[2] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = GameViewState.JOIN_GAME;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _NewGameViews_State3.name = param1;
         },"_NewGameViews_State3.name");
         result[3] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = GameViewState.TEAM_SELECTION;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _NewGameViews_State4.name = param1;
         },"_NewGameViews_State4.name");
         result[4] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = GameViewState.CHAMPION_SELECTION;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _NewGameViews_State5.name = param1;
         },"_NewGameViews_State5.name");
         result[5] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = GameViewState.START_REQUESTED;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _NewGameViews_State6.name = param1;
         },"_NewGameViews_State6.name");
         result[6] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = GameViewState.IN_PROGRESS;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _NewGameViews_State7.name = param1;
         },"_NewGameViews_State7.name");
         result[7] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = GameViewState.PLAYING_GAME;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _NewGameViews_State8.name = param1;
         },"_NewGameViews_State8.name");
         result[8] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = GameViewState.GAME_OVER;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _NewGameViews_State9.name = param1;
         },"_NewGameViews_State9.name");
         result[9] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = GameViewState.JOIN_QUEUE;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _NewGameViews_State10.name = param1;
         },"_NewGameViews_State10.name");
         result[10] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = GameViewState.WAIT_FOR_GAME;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _NewGameViews_State11.name = param1;
         },"_NewGameViews_State11.name");
         result[11] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = GameViewState.WAIT_FOR_GAME_AFTER_MATCH;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _NewGameViews_State12.name = param1;
         },"_NewGameViews_State12.name");
         result[12] = binding;
         return result;
      }
      
      private function _NewGameViews_State3_i() : State
      {
         var _loc1_:State = new State();
         this._NewGameViews_State3 = _loc1_;
         BindingManager.executeBindings(this,"_NewGameViews_State3",this._NewGameViews_State3);
         return _loc1_;
      }
      
      private function _NewGameViews_State7_i() : State
      {
         var _loc1_:State = new State();
         this._NewGameViews_State7 = _loc1_;
         BindingManager.executeBindings(this,"_NewGameViews_State7",this._NewGameViews_State7);
         return _loc1_;
      }
      
      private function onCreationComplete() : void
      {
         if(this.masterGameController)
         {
            this.masterGameController.FIXMEChampionSelectionDisplay = this.championSelection_c;
         }
      }
      
      public function set content_c(param1:ViewStack) : void
      {
         var _loc2_:Object = this._407108067content_c;
         if(_loc2_ !== param1)
         {
            this._407108067content_c = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"content_c",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      [Inject]
      public function get masterGameController() : MasterGameController
      {
         return this._269543472masterGameController;
      }
      
      [Bindable(event="propertyChange")]
      public function get joinPracticeGame_c() : JoinGamePanel
      {
         return this._729296837joinPracticeGame_c;
      }
      
      [Bindable(event="propertyChange")]
      public function get championSelection_c() : Canvas
      {
         return this._495403591championSelection_c;
      }
      
      public function set playingGame_c(param1:InGameView) : void
      {
         var _loc2_:Object = this._1278638812playingGame_c;
         if(_loc2_ !== param1)
         {
            this._1278638812playingGame_c = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"playingGame_c",_loc2_,param1));
         }
      }
      
      private function initializeView() : void
      {
         if(this.content_c.selectedChild != null)
         {
            this.content_c.selectedChild.dispatchEvent(new FlexEvent(FlexEvent.SHOW));
         }
      }
      
      private function _NewGameViews_State12_i() : State
      {
         var _loc1_:State = new State();
         this._NewGameViews_State12 = _loc1_;
         BindingManager.executeBindings(this,"_NewGameViews_State12",this._NewGameViews_State12);
         return _loc1_;
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
      
      private function _NewGameViews_State2_i() : State
      {
         var _loc1_:State = new State();
         this._NewGameViews_State2 = _loc1_;
         BindingManager.executeBindings(this,"_NewGameViews_State2",this._NewGameViews_State2);
         return _loc1_;
      }
      
      public function ___NewGameViews_Canvas1_currentStateChange(param1:StateChangeEvent) : void
      {
         this.onCurrentStateChange(param1);
      }
      
      private function _NewGameViews_State6_i() : State
      {
         var _loc1_:State = new State();
         this._NewGameViews_State6 = _loc1_;
         BindingManager.executeBindings(this,"_NewGameViews_State6",this._NewGameViews_State6);
         return _loc1_;
      }
      
      public function set joinPracticeGame_c(param1:JoinGamePanel) : void
      {
         var _loc2_:Object = this._729296837joinPracticeGame_c;
         if(_loc2_ !== param1)
         {
            this._729296837joinPracticeGame_c = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"joinPracticeGame_c",_loc2_,param1));
         }
      }
      
      private function onShow() : void
      {
         var _loc1_:StateChangeEvent = null;
         if(currentState == this._beforeHideState)
         {
            _loc1_ = new StateChangeEvent("currentStateChanged");
            _loc1_.newState = this.currentState;
            this.onCurrentStateChange(_loc1_);
         }
         else
         {
            this.initializeView();
         }
      }
      
      private function _NewGameViews_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.masterGameController.currentState;
         _loc1_ = GameViewState.TUTORIAL_GAME;
         _loc1_ = GameViewState.CREATE_GAME;
         _loc1_ = GameViewState.JOIN_GAME;
         _loc1_ = GameViewState.TEAM_SELECTION;
         _loc1_ = GameViewState.CHAMPION_SELECTION;
         _loc1_ = GameViewState.START_REQUESTED;
         _loc1_ = GameViewState.IN_PROGRESS;
         _loc1_ = GameViewState.PLAYING_GAME;
         _loc1_ = GameViewState.GAME_OVER;
         _loc1_ = GameViewState.JOIN_QUEUE;
         _loc1_ = GameViewState.WAIT_FOR_GAME;
         _loc1_ = GameViewState.WAIT_FOR_GAME_AFTER_MATCH;
      }
      
      public function ___NewGameViews_Canvas1_show(param1:FlexEvent) : void
      {
         this.onShow();
      }
      
      [Bindable(event="propertyChange")]
      public function get createPracticeGame_c() : CreatePracticeGameView
      {
         return this._1181187213createPracticeGame_c;
      }
      
      public function set championSelection_c(param1:Canvas) : void
      {
         var _loc2_:Object = this._495403591championSelection_c;
         if(_loc2_ !== param1)
         {
            this._495403591championSelection_c = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"championSelection_c",_loc2_,param1));
         }
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:NewGameViews = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._NewGameViews_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_game_NewGameViewsWatcherSetupUtil");
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
      
      private function resetView() : void
      {
         if(this.content_c.selectedChild != null)
         {
            this.content_c.selectedChild.dispatchEvent(new FlexEvent(FlexEvent.HIDE));
            this.content_c.selectedChild = this.noScreen;
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get noScreen() : Canvas
      {
         return this._635413901noScreen;
      }
      
      private function _NewGameViews_State11_i() : State
      {
         var _loc1_:State = new State();
         this._NewGameViews_State11 = _loc1_;
         BindingManager.executeBindings(this,"_NewGameViews_State11",this._NewGameViews_State11);
         return _loc1_;
      }
      
      public function ___NewGameViews_Canvas1_initialize(param1:FlexEvent) : void
      {
         this.onInitialize();
      }
      
      public function set teamSelection_c(param1:TeamSelectionView2) : void
      {
         var _loc2_:Object = this._352222253teamSelection_c;
         if(_loc2_ !== param1)
         {
            this._352222253teamSelection_c = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"teamSelection_c",_loc2_,param1));
         }
      }
      
      private function onCurrentStateChange(param1:StateChangeEvent) : void
      {
         if(this.applicationController == null || this.content_c == null)
         {
            this.stateChangeOnInject = true;
            return;
         }
         switch(param1.newState)
         {
            case GameViewState.JOIN_GAME:
               this.content_c.selectedChild = this.joinPracticeGame_c;
               break;
            case GameViewState.CREATE_GAME:
               this.content_c.selectedChild = this.createPracticeGame_c;
               break;
            case GameViewState.TEAM_SELECTION:
               this.content_c.selectedChild = this.teamSelection_c;
               break;
            case GameViewState.START_REQUESTED:
            case GameViewState.TUTORIAL_GAME:
            case GameViewState.CHAMPION_SELECTION:
            case GameViewState.IN_PROGRESS:
               if(this.masterGameController)
               {
                  this.masterGameController.FIXMEChampionSelectionDisplay = this.championSelection_c;
               }
               this.content_c.selectedChild = this.championSelection_c;
               break;
            case GameViewState.PLAYING_GAME:
               this.content_c.selectedChild = this.playingGame_c;
               break;
            case GameViewState.GAME_OVER:
               this.content_c.selectedChild = this.endOfGame_c;
         }
      }
      
      private function onCurrentStateChangeX(param1:String, param2:String) : void
      {
         var _loc3_:StateChangeEvent = null;
         if(param2 != GameViewState.CREATE_GAME)
         {
            _loc3_ = new StateChangeEvent("",false,false,param1,param2);
            this.onCurrentStateChange(_loc3_);
         }
      }
      
      public function ___NewGameViews_Canvas1_addedToStage(param1:Event) : void
      {
         this.onInjected();
      }
      
      private function _NewGameViews_State1_i() : State
      {
         var _loc1_:State = new State();
         this._NewGameViews_State1 = _loc1_;
         BindingManager.executeBindings(this,"_NewGameViews_State1",this._NewGameViews_State1);
         return _loc1_;
      }
      
      private function _NewGameViews_State5_i() : State
      {
         var _loc1_:State = new State();
         this._NewGameViews_State5 = _loc1_;
         BindingManager.executeBindings(this,"_NewGameViews_State5",this._NewGameViews_State5);
         return _loc1_;
      }
      
      private function _NewGameViews_State9_i() : State
      {
         var _loc1_:State = new State();
         this._NewGameViews_State9 = _loc1_;
         BindingManager.executeBindings(this,"_NewGameViews_State9",this._NewGameViews_State9);
         return _loc1_;
      }
      
      private function onHide() : void
      {
         this._beforeHideState = currentState;
         this.resetView();
      }
      
      public function ___NewGameViews_Canvas1_creationComplete(param1:FlexEvent) : void
      {
         this.onCreationComplete();
      }
      
      private function onInitialize() : void
      {
         this.shellDispatcher.addEventListener(UnexpectedGameErrorEvent.GAME_FAILED_TO_START,this.practiceGameFailedToStart);
         if(this.masterGameController)
         {
            this.masterGameController.getGameStateChanged().add(this.onCurrentStateChangeX);
         }
      }
      
      public function ___NewGameViews_Canvas1_hide(param1:FlexEvent) : void
      {
         this.onHide();
      }
      
      private function _NewGameViews_State10_i() : State
      {
         var _loc1_:State = new State();
         this._NewGameViews_State10 = _loc1_;
         BindingManager.executeBindings(this,"_NewGameViews_State10",this._NewGameViews_State10);
         return _loc1_;
      }
      
      private function practiceGameFailedToStart(param1:UnexpectedGameErrorEvent) : void
      {
         var _loc2_:IResourceManager = ResourceManager.getInstance();
         var _loc3_:AlertAction = new AlertAction(_loc2_.getString("resources","general_generalAlertErrorTitle"),_loc2_.getString("resources",MessageDictionary.GAME_FAILED_TO_START,[this.masterGameController.currentGame.name]));
         _loc3_.add();
      }
      
      [Bindable(event="propertyChange")]
      public function get teamSelection_c() : TeamSelectionView2
      {
         return this._352222253teamSelection_c;
      }
      
      private function onInjected() : void
      {
         var _loc1_:StateChangeEvent = null;
         if(this.stateChangeOnInject)
         {
            this.stateChangeOnInject = false;
            _loc1_ = new StateChangeEvent("currentStateChanged");
            _loc1_.newState = this.currentState;
            this.onCurrentStateChange(_loc1_);
         }
      }
      
      private function _NewGameViews_State4_i() : State
      {
         var _loc1_:State = new State();
         this._NewGameViews_State4 = _loc1_;
         BindingManager.executeBindings(this,"_NewGameViews_State4",this._NewGameViews_State4);
         return _loc1_;
      }
      
      private function _NewGameViews_State8_i() : State
      {
         var _loc1_:State = new State();
         this._NewGameViews_State8 = _loc1_;
         BindingManager.executeBindings(this,"_NewGameViews_State8",this._NewGameViews_State8);
         return _loc1_;
      }
   }
}

