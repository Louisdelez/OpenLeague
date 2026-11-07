package com.riotgames.platform.gameclient.views.application
{
   import com.riotgames.platform.common.AppConfig;
   import com.riotgames.platform.common.IAppControllerConstants;
   import com.riotgames.platform.common.event.ShellEvent;
   import com.riotgames.platform.gameclient.controllers.game.ArrowedAlertController;
   import com.riotgames.platform.gameclient.controllers.game.ArrowedAlertViewManager;
   import com.riotgames.platform.gameclient.controllers.summoner.ChooseSummonerIconController;
   import com.riotgames.platform.gameclient.views.game.common.ingame.InGameView;
   import com.riotgames.platform.gameclient.views.help.NewbieTipsView;
   import com.riotgames.platform.gameclient.views.lobby.ChooseGameOptionsView;
   import com.riotgames.platform.gameclient.views.lobby.LobbyView;
   import com.riotgames.platform.gameclient.views.summoner.wizard.ChooseSummonerIcon;
   import com.riotgames.platform.gameclient.views.summoner.wizard.EloQuestionaire;
   import com.riotgames.platform.gameclient.views.summoner.wizard.PlayTutorialGame;
   import com.riotgames.platform.gameclient.views.summoner.wizard.SummonerNameView;
   import com.riotgames.pvpnet.accountcreation.AccountCreationProviderProxy;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
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
   
   public class ApplicationContentView extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private static const DEFAULT_LEFT:Number = 32;
      
      private static const DEFAULT_RIGHT:Number = 30;
      
      private static const DEFAULT_TOP:Number = 37;
      
      private static const DEFAULT_BOTTOM:Number = 37;
      
      private var _1241405357eloQuestionaire_c:EloQuestionaire;
      
      mx_internal var _watchers:Array = [];
      
      public var _ApplicationContentView_State10:State;
      
      [Inject]
      public var arrowedAlertController:ArrowedAlertController;
      
      private var _1267650814chooseSummonerIcon_c:ChooseSummonerIcon;
      
      private var _311071075nameSummoner_c:SummonerNameView;
      
      private var _1670753362loginPlaceholder_c:Canvas;
      
      mx_internal var _bindingsBeginWithWord:Object = {};
      
      mx_internal var _bindingsByDestination:Object = {};
      
      public var _ApplicationContentView_State1:State;
      
      public var _ApplicationContentView_State2:State;
      
      public var _ApplicationContentView_State3:State;
      
      public var _ApplicationContentView_State4:State;
      
      public var _ApplicationContentView_State5:State;
      
      public var _ApplicationContentView_State6:State;
      
      public var _ApplicationContentView_State7:State;
      
      public var _ApplicationContentView_State8:State;
      
      private var arrowedAlertViewManager:ArrowedAlertViewManager;
      
      private var _1681472230choose_game:ChooseGameOptionsView;
      
      public var _ApplicationContentView_State9:State;
      
      private var _337529402lobby_c:LobbyView;
      
      [Inject]
      public var chooseSummonerIconController:ChooseSummonerIconController;
      
      mx_internal var _bindings:Array = [];
      
      public var shellDispatcher:ShellDispatcher = ShellDispatcher.instance;
      
      private var _721752869inGame_c:InGameView;
      
      private var _407738200playTutorialGame_c:PlayTutorialGame;
      
      private var _264552515content_vs:ViewStack;
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {"childDescriptors":[new UIComponentDescriptor({
               "type":ViewStack,
               "id":"content_vs",
               "stylesFactory":function():void
               {
                  this.top = "20";
                  this.bottom = "0";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "percentWidth":100,
                     "childDescriptors":[new UIComponentDescriptor({
                        "type":Canvas,
                        "id":"loginPlaceholder_c",
                        "propertiesFactory":function():Object
                        {
                           return {
                              "cacheAsBitmap":true,
                              "percentHeight":100,
                              "percentWidth":100
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":SummonerNameView,
                        "id":"nameSummoner_c",
                        "propertiesFactory":function():Object
                        {
                           return {
                              "percentHeight":100,
                              "percentWidth":100
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":ChooseSummonerIcon,
                        "id":"chooseSummonerIcon_c",
                        "propertiesFactory":function():Object
                        {
                           return {
                              "percentHeight":100,
                              "percentWidth":100
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":EloQuestionaire,
                        "id":"eloQuestionaire_c",
                        "propertiesFactory":function():Object
                        {
                           return {
                              "percentHeight":100,
                              "percentWidth":100
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":PlayTutorialGame,
                        "id":"playTutorialGame_c",
                        "propertiesFactory":function():Object
                        {
                           return {
                              "percentHeight":100,
                              "percentWidth":100
                           };
                        }
                     })]
                  };
               }
            }),new UIComponentDescriptor({
               "type":InGameView,
               "id":"inGame_c",
               "propertiesFactory":function():Object
               {
                  return {
                     "percentHeight":100,
                     "percentWidth":100
                  };
               }
            }),new UIComponentDescriptor({
               "type":LobbyView,
               "id":"lobby_c",
               "propertiesFactory":function():Object
               {
                  return {
                     "percentHeight":100,
                     "percentWidth":100
                  };
               }
            }),new UIComponentDescriptor({
               "type":ChooseGameOptionsView,
               "id":"choose_game",
               "propertiesFactory":function():Object
               {
                  return {
                     "percentWidth":100,
                     "percentHeight":100
                  };
               }
            }),new UIComponentDescriptor({"type":NewbieTipsView})]};
         }
      });
      
      public function ApplicationContentView()
      {
         super();
         mx_internal::_document = this;
         this.cacheAsBitmap = true;
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this.states = [this._ApplicationContentView_State1_i(),this._ApplicationContentView_State2_i(),this._ApplicationContentView_State3_i(),this._ApplicationContentView_State4_i(),this._ApplicationContentView_State5_i(),this._ApplicationContentView_State6_i(),this._ApplicationContentView_State7_i(),this._ApplicationContentView_State8_i(),this._ApplicationContentView_State9_i(),this._ApplicationContentView_State10_i()];
         this.addEventListener("initialize",this.___ApplicationContentView_Canvas1_initialize);
         this.addEventListener("addedToStage",this.___ApplicationContentView_Canvas1_addedToStage);
         this.addEventListener("currentStateChange",this.___ApplicationContentView_Canvas1_currentStateChange);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         ApplicationContentView._watcherSetupUtil = param1;
      }
      
      public function ___ApplicationContentView_Canvas1_currentStateChange(param1:StateChangeEvent) : void
      {
         this.onCurrentStateChange(param1);
      }
      
      private function _ApplicationContentView_State6_i() : State
      {
         var _loc1_:State = new State();
         this._ApplicationContentView_State6 = _loc1_;
         BindingManager.executeBindings(this,"_ApplicationContentView_State6",this._ApplicationContentView_State6);
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get chooseSummonerIcon_c() : ChooseSummonerIcon
      {
         return this._1267650814chooseSummonerIcon_c;
      }
      
      private function _ApplicationContentView_State8_i() : State
      {
         var _loc1_:State = new State();
         this._ApplicationContentView_State8 = _loc1_;
         BindingManager.executeBindings(this,"_ApplicationContentView_State8",this._ApplicationContentView_State8);
         return _loc1_;
      }
      
      private function _ApplicationContentView_State2_i() : State
      {
         var _loc1_:State = new State();
         this._ApplicationContentView_State2 = _loc1_;
         BindingManager.executeBindings(this,"_ApplicationContentView_State2",this._ApplicationContentView_State2);
         return _loc1_;
      }
      
      private function showPartnerBetaBlockedMessage() : void
      {
         var _loc1_:IResourceManager = ResourceManager.getInstance();
         var _loc2_:AlertAction = new AlertAction(_loc1_.getString("resources","partnerBetaBlocked_title"),_loc1_.getString("resources","partnerBetaBlocked_message"));
         _loc2_.getCompleted().addOnce(this.partnerBetaBlockedCloseHandler);
         _loc2_.add();
      }
      
      public function set content_vs(param1:ViewStack) : void
      {
         var _loc2_:Object = this._264552515content_vs;
         if(_loc2_ !== param1)
         {
            this._264552515content_vs = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"content_vs",_loc2_,param1));
         }
      }
      
      public function set eloQuestionaire_c(param1:EloQuestionaire) : void
      {
         var _loc2_:Object = this._1241405357eloQuestionaire_c;
         if(_loc2_ !== param1)
         {
            this._1241405357eloQuestionaire_c = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"eloQuestionaire_c",_loc2_,param1));
         }
      }
      
      private function _ApplicationContentView_State10_i() : State
      {
         var _loc1_:State = new State();
         this._ApplicationContentView_State10 = _loc1_;
         BindingManager.executeBindings(this,"_ApplicationContentView_State10",this._ApplicationContentView_State10);
         return _loc1_;
      }
      
      private function _ApplicationContentView_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = AppConfig.instance.currentAppState;
         _loc1_ = IAppControllerConstants.LOGIN;
         _loc1_ = IAppControllerConstants.CREATE_SUMMONER;
         _loc1_ = IAppControllerConstants.RENAME_SUMMONER;
         _loc1_ = IAppControllerConstants.CHOOSE_SUMMONER_ICON;
         _loc1_ = IAppControllerConstants.ELO_QUESTIONAIRE;
         _loc1_ = IAppControllerConstants.PLAY_TUTORIAL;
         _loc1_ = IAppControllerConstants.LOBBY;
         _loc1_ = IAppControllerConstants.RECONNECT;
         _loc1_ = IAppControllerConstants.PARTNER_BETA_BLOCKED;
         _loc1_ = IAppControllerConstants.CHOOSE_GAME_FLOW;
         _loc1_ = this.currentState != IAppControllerConstants.LOBBY && this.currentState != IAppControllerConstants.RECONNECT;
         _loc1_ = this.currentState == IAppControllerConstants.RECONNECT;
         _loc1_ = this.currentState == IAppControllerConstants.LOBBY;
         _loc1_ = this.currentState == IAppControllerConstants.CHOOSE_GAME_FLOW;
      }
      
      public function set lobby_c(param1:LobbyView) : void
      {
         var _loc2_:Object = this._337529402lobby_c;
         if(_loc2_ !== param1)
         {
            this._337529402lobby_c = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lobby_c",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get playTutorialGame_c() : PlayTutorialGame
      {
         return this._407738200playTutorialGame_c;
      }
      
      public function ___ApplicationContentView_Canvas1_addedToStage(param1:Event) : void
      {
         this.onInjection();
      }
      
      public function set chooseSummonerIcon_c(param1:ChooseSummonerIcon) : void
      {
         var _loc2_:Object = this._1267650814chooseSummonerIcon_c;
         if(_loc2_ !== param1)
         {
            this._1267650814chooseSummonerIcon_c = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"chooseSummonerIcon_c",_loc2_,param1));
         }
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:ApplicationContentView = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._ApplicationContentView_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_application_ApplicationContentViewWatcherSetupUtil");
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
      
      [Bindable(event="propertyChange")]
      public function get choose_game() : ChooseGameOptionsView
      {
         return this._1681472230choose_game;
      }
      
      [Bindable(event="propertyChange")]
      public function get nameSummoner_c() : SummonerNameView
      {
         return this._311071075nameSummoner_c;
      }
      
      private function onCurrentStateChange(param1:StateChangeEvent) : void
      {
         switch(param1.newState)
         {
            case IAppControllerConstants.LOGIN:
               this.content_vs.selectedChild = this.loginPlaceholder_c;
               break;
            case IAppControllerConstants.PARTNER_BETA_BLOCKED:
               this.showPartnerBetaBlockedMessage();
               break;
            case IAppControllerConstants.CREATE_SUMMONER:
               AccountCreationProviderProxy.instance.getSummonerNameModel().createSummonerMode = true;
               this.nameSummoner_c.summonerNameModel = AccountCreationProviderProxy.instance.getSummonerNameModel();
               this.content_vs.selectedChild = this.nameSummoner_c;
               break;
            case IAppControllerConstants.RENAME_SUMMONER:
               AccountCreationProviderProxy.instance.getSummonerNameModel().createSummonerMode = false;
               this.nameSummoner_c.summonerNameModel = AccountCreationProviderProxy.instance.getSummonerNameModel();
               this.content_vs.selectedChild = this.nameSummoner_c;
               break;
            case IAppControllerConstants.PLAY_TUTORIAL:
               this.playTutorialGame_c.playTutorialModel = AccountCreationProviderProxy.instance.getPlayTutorialModel();
               this.content_vs.selectedChild = this.playTutorialGame_c;
               break;
            case IAppControllerConstants.ELO_QUESTIONAIRE:
               this.eloQuestionaire_c.eloQuestionnaireModel = AccountCreationProviderProxy.instance.getEloQuestionnaireModel();
               this.content_vs.selectedChild = this.eloQuestionaire_c;
               break;
            case IAppControllerConstants.CHOOSE_SUMMONER_ICON:
               AccountCreationProviderProxy.instance.getChooseIconModel().continueTutorialSequence = true;
               this.chooseSummonerIcon_c.chooseIconModel = AccountCreationProviderProxy.instance.getChooseIconModel();
               this.content_vs.selectedChild = this.chooseSummonerIcon_c;
         }
      }
      
      public function set inGame_c(param1:InGameView) : void
      {
         var _loc2_:Object = this._721752869inGame_c;
         if(_loc2_ !== param1)
         {
            this._721752869inGame_c = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"inGame_c",_loc2_,param1));
         }
      }
      
      private function onInjection() : void
      {
         this.arrowedAlertViewManager = new ArrowedAlertViewManager(this,this.arrowedAlertController);
         this.arrowedAlertViewManager.activate();
      }
      
      [Bindable(event="propertyChange")]
      public function get loginPlaceholder_c() : Canvas
      {
         return this._1670753362loginPlaceholder_c;
      }
      
      private function _ApplicationContentView_State3_i() : State
      {
         var _loc1_:State = new State();
         this._ApplicationContentView_State3 = _loc1_;
         BindingManager.executeBindings(this,"_ApplicationContentView_State3",this._ApplicationContentView_State3);
         return _loc1_;
      }
      
      public function preloadContent() : void
      {
         if(this.lobby_c)
         {
            this.lobby_c.preloadContent();
         }
      }
      
      private function _ApplicationContentView_State5_i() : State
      {
         var _loc1_:State = new State();
         this._ApplicationContentView_State5 = _loc1_;
         BindingManager.executeBindings(this,"_ApplicationContentView_State5",this._ApplicationContentView_State5);
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get lobby_c() : LobbyView
      {
         return this._337529402lobby_c;
      }
      
      private function _ApplicationContentView_State7_i() : State
      {
         var _loc1_:State = new State();
         this._ApplicationContentView_State7 = _loc1_;
         BindingManager.executeBindings(this,"_ApplicationContentView_State7",this._ApplicationContentView_State7);
         return _loc1_;
      }
      
      private function _ApplicationContentView_State1_i() : State
      {
         var _loc1_:State = new State();
         this._ApplicationContentView_State1 = _loc1_;
         BindingManager.executeBindings(this,"_ApplicationContentView_State1",this._ApplicationContentView_State1);
         return _loc1_;
      }
      
      private function _ApplicationContentView_State9_i() : State
      {
         var _loc1_:State = new State();
         this._ApplicationContentView_State9 = _loc1_;
         BindingManager.executeBindings(this,"_ApplicationContentView_State9",this._ApplicationContentView_State9);
         return _loc1_;
      }
      
      private function partnerBetaBlockedCloseHandler() : void
      {
         this.shellDispatcher.dispatchEvent(new ShellEvent(ShellEvent.EXIT));
      }
      
      public function set nameSummoner_c(param1:SummonerNameView) : void
      {
         var _loc2_:Object = this._311071075nameSummoner_c;
         if(_loc2_ !== param1)
         {
            this._311071075nameSummoner_c = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"nameSummoner_c",_loc2_,param1));
         }
      }
      
      public function ___ApplicationContentView_Canvas1_initialize(param1:FlexEvent) : void
      {
         this.onInitialize();
      }
      
      private function onInitialize() : void
      {
      }
      
      public function set loginPlaceholder_c(param1:Canvas) : void
      {
         var _loc2_:Object = this._1670753362loginPlaceholder_c;
         if(_loc2_ !== param1)
         {
            this._1670753362loginPlaceholder_c = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"loginPlaceholder_c",_loc2_,param1));
         }
      }
      
      public function set playTutorialGame_c(param1:PlayTutorialGame) : void
      {
         var _loc2_:Object = this._407738200playTutorialGame_c;
         if(_loc2_ !== param1)
         {
            this._407738200playTutorialGame_c = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"playTutorialGame_c",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get inGame_c() : InGameView
      {
         return this._721752869inGame_c;
      }
      
      private function _ApplicationContentView_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():String
         {
            var _loc1_:* = AppConfig.instance.currentAppState;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            this.currentState = param1;
         },"this.currentState");
         result[0] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = IAppControllerConstants.LOGIN;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _ApplicationContentView_State1.name = param1;
         },"_ApplicationContentView_State1.name");
         result[1] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = IAppControllerConstants.CREATE_SUMMONER;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _ApplicationContentView_State2.name = param1;
         },"_ApplicationContentView_State2.name");
         result[2] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = IAppControllerConstants.RENAME_SUMMONER;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _ApplicationContentView_State3.name = param1;
         },"_ApplicationContentView_State3.name");
         result[3] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = IAppControllerConstants.CHOOSE_SUMMONER_ICON;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _ApplicationContentView_State4.name = param1;
         },"_ApplicationContentView_State4.name");
         result[4] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = IAppControllerConstants.ELO_QUESTIONAIRE;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _ApplicationContentView_State5.name = param1;
         },"_ApplicationContentView_State5.name");
         result[5] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = IAppControllerConstants.PLAY_TUTORIAL;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _ApplicationContentView_State6.name = param1;
         },"_ApplicationContentView_State6.name");
         result[6] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = IAppControllerConstants.LOBBY;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _ApplicationContentView_State7.name = param1;
         },"_ApplicationContentView_State7.name");
         result[7] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = IAppControllerConstants.RECONNECT;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _ApplicationContentView_State8.name = param1;
         },"_ApplicationContentView_State8.name");
         result[8] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = IAppControllerConstants.PARTNER_BETA_BLOCKED;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _ApplicationContentView_State9.name = param1;
         },"_ApplicationContentView_State9.name");
         result[9] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = IAppControllerConstants.CHOOSE_GAME_FLOW;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _ApplicationContentView_State10.name = param1;
         },"_ApplicationContentView_State10.name");
         result[10] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.currentState != IAppControllerConstants.LOBBY && this.currentState != IAppControllerConstants.RECONNECT;
         },function(param1:Boolean):void
         {
            content_vs.visible = param1;
         },"content_vs.visible");
         result[11] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.currentState == IAppControllerConstants.RECONNECT;
         },function(param1:Boolean):void
         {
            inGame_c.visible = param1;
         },"inGame_c.visible");
         result[12] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.currentState == IAppControllerConstants.LOBBY;
         },function(param1:Boolean):void
         {
            lobby_c.visible = param1;
         },"lobby_c.visible");
         result[13] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.currentState == IAppControllerConstants.CHOOSE_GAME_FLOW;
         },function(param1:Boolean):void
         {
            choose_game.visible = param1;
         },"choose_game.visible");
         result[14] = binding;
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get content_vs() : ViewStack
      {
         return this._264552515content_vs;
      }
      
      [Bindable(event="propertyChange")]
      public function get eloQuestionaire_c() : EloQuestionaire
      {
         return this._1241405357eloQuestionaire_c;
      }
      
      public function set choose_game(param1:ChooseGameOptionsView) : void
      {
         var _loc2_:Object = this._1681472230choose_game;
         if(_loc2_ !== param1)
         {
            this._1681472230choose_game = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"choose_game",_loc2_,param1));
         }
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
      }
      
      private function _ApplicationContentView_State4_i() : State
      {
         var _loc1_:State = new State();
         this._ApplicationContentView_State4 = _loc1_;
         BindingManager.executeBindings(this,"_ApplicationContentView_State4",this._ApplicationContentView_State4);
         return _loc1_;
      }
   }
}

