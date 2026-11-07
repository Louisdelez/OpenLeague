package com.riotgames.platform.gameclient.views.game.common.endofgame
{
   import com.riotgames.platform.common.IAppController;
   import com.riotgames.platform.gameclient.components.button.SoundEffectButton;
   import com.riotgames.pvpnet.game.controllers.EndOfGameStatsController;
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
   import mx.containers.VBox;
   import mx.containers.ViewStack;
   import mx.controls.Label;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.events.StateChangeEvent;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.states.SetProperty;
   import mx.states.State;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class EndOfGameView extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private var _1881928804selectedEndOfGameViewIndex:int = 0;
      
      [Inject]
      public var applicationController:IAppController;
      
      mx_internal var _watchers:Array = [];
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      private var _1508967674showStats_c:EndOfGameStatsView;
      
      public var _EndOfGameView_SetProperty2:SetProperty;
      
      public var _EndOfGameView_SetProperty3:SetProperty;
      
      public var _EndOfGameView_SetProperty1:SetProperty;
      
      [Inject]
      private var _1164646953endOfGameStatsController:EndOfGameStatsController;
      
      private var isInitialized:Boolean;
      
      mx_internal var _bindingsBeginWithWord:Object = {};
      
      private var _1097794056endOfGame_c:ViewStack;
      
      mx_internal var _bindingsByDestination:Object = {};
      
      public var _EndOfGameView_SoundEffectButton1:SoundEffectButton;
      
      private var _2130420199waitingForStats_c:VBox;
      
      private var _1978517766endOfTutorialGame_c:EndOfTutorialGameView;
      
      mx_internal var _bindings:Array = [];
      
      public var _EndOfGameView_Label1:Label;
      
      public var _EndOfGameView_State1:State;
      
      public var _EndOfGameView_State2:State;
      
      public var _EndOfGameView_State3:State;
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {"childDescriptors":[new UIComponentDescriptor({
               "type":ViewStack,
               "id":"endOfGame_c",
               "propertiesFactory":function():Object
               {
                  return {
                     "percentHeight":100,
                     "percentWidth":100,
                     "x":0,
                     "y":0,
                     "childDescriptors":[new UIComponentDescriptor({
                        "type":VBox,
                        "id":"waitingForStats_c",
                        "stylesFactory":function():void
                        {
                           this.paddingTop = 76;
                           this.horizontalAlign = "center";
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "percentHeight":100,
                              "percentWidth":100,
                              "childDescriptors":[new UIComponentDescriptor({
                                 "type":Label,
                                 "id":"_EndOfGameView_Label1",
                                 "propertiesFactory":function():Object
                                 {
                                    return {"styleName":"formLabel"};
                                 }
                              }),new UIComponentDescriptor({
                                 "type":SoundEffectButton,
                                 "id":"_EndOfGameView_SoundEffectButton1",
                                 "events":{"click":"___EndOfGameView_SoundEffectButton1_click"},
                                 "propertiesFactory":function():Object
                                 {
                                    return {
                                       "useHandCursor":true,
                                       "buttonMode":true
                                    };
                                 }
                              })]
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":EndOfGameStatsView,
                        "id":"showStats_c",
                        "propertiesFactory":function():Object
                        {
                           return {
                              "percentHeight":100,
                              "percentWidth":100,
                              "x":0,
                              "y":0
                           };
                        }
                     }),new UIComponentDescriptor({
                        "type":EndOfTutorialGameView,
                        "id":"endOfTutorialGame_c",
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
            })]};
         }
      });
      
      public function EndOfGameView()
      {
         super();
         mx_internal::_document = this;
         this.cacheAsBitmap = true;
         this.percentWidth = 100;
         this.percentHeight = 100;
         this.states = [this._EndOfGameView_State1_i(),this._EndOfGameView_State2_i(),this._EndOfGameView_State3_i()];
         this.addEventListener("creationComplete",this.___EndOfGameView_Canvas1_creationComplete);
         this.addEventListener("show",this.___EndOfGameView_Canvas1_show);
         this.addEventListener("hide",this.___EndOfGameView_Canvas1_hide);
         this.addEventListener("currentStateChange",this.___EndOfGameView_Canvas1_currentStateChange);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         EndOfGameView._watcherSetupUtil = param1;
      }
      
      public function ___EndOfGameView_Canvas1_hide(param1:FlexEvent) : void
      {
         this.onHide();
      }
      
      private function _EndOfGameView_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.endOfGameStatsController.currentEndOfGameState;
         _loc1_ = EndOfGameStatsController.WAITING_FOR_STATS;
         _loc1_ = this;
         _loc1_ = EndOfGameStatsController.SHOW_STATS;
         _loc1_ = this;
         _loc1_ = EndOfGameStatsController.TUTORIAL_GAME_WRAPUP;
         _loc1_ = this;
         _loc1_ = this.selectedEndOfGameViewIndex;
         _loc1_ = resourceManager.getString("resources","practiceGame_waitingForStats_statusLabel");
         _loc1_ = resourceManager.getString("resources","practiceGame_waitingForStats_playAgainButtonLabel");
         _loc1_ = resourceManager.getString("resources","practiceGame_waitingForStats_playAgainButton_tooltip");
      }
      
      [Bindable(event="propertyChange")]
      public function get endOfGame_c() : ViewStack
      {
         return this._1097794056endOfGame_c;
      }
      
      [Bindable(event="propertyChange")]
      public function get endOfTutorialGame_c() : EndOfTutorialGameView
      {
         return this._1978517766endOfTutorialGame_c;
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:EndOfGameView = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._EndOfGameView_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_game_common_endofgame_EndOfGameViewWatcherSetupUtil");
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
      
      public function set endOfTutorialGame_c(param1:EndOfTutorialGameView) : void
      {
         var _loc2_:Object = this._1978517766endOfTutorialGame_c;
         if(_loc2_ !== param1)
         {
            this._1978517766endOfTutorialGame_c = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"endOfTutorialGame_c",_loc2_,param1));
         }
      }
      
      public function ___EndOfGameView_SoundEffectButton1_click(param1:MouseEvent) : void
      {
         this.onPlayAgainButtonClicked(param1);
      }
      
      private function _EndOfGameView_SetProperty2_i() : SetProperty
      {
         var _loc1_:SetProperty = new SetProperty();
         this._EndOfGameView_SetProperty2 = _loc1_;
         _loc1_.name = "selectedEndOfGameViewIndex";
         _loc1_.value = 1;
         BindingManager.executeBindings(this,"_EndOfGameView_SetProperty2",this._EndOfGameView_SetProperty2);
         return _loc1_;
      }
      
      private function resetView() : void
      {
         if(!this.isInitialized)
         {
            return;
         }
         if(this.showStats_c == null)
         {
            return;
         }
         this.isInitialized = false;
         if(this.applicationController.reportTracker)
         {
            this.applicationController.reportTracker.resetReportedUsers();
         }
      }
      
      private function onCurrentStateChanged(param1:StateChangeEvent) : void
      {
         if(Boolean(this.endOfTutorialGame_c) && Boolean(this.endOfTutorialGame_c.initialized) && EndOfGameStatsController.TUTORIAL_GAME_WRAPUP == param1.newState)
         {
            this.endOfTutorialGame_c.initializeEndOfGameTutorialView();
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get showStats_c() : EndOfGameStatsView
      {
         return this._1508967674showStats_c;
      }
      
      public function set showStats_c(param1:EndOfGameStatsView) : void
      {
         var _loc2_:Object = this._1508967674showStats_c;
         if(_loc2_ !== param1)
         {
            this._1508967674showStats_c = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"showStats_c",_loc2_,param1));
         }
      }
      
      private function _EndOfGameView_State1_i() : State
      {
         var _loc1_:State = new State();
         this._EndOfGameView_State1 = _loc1_;
         _loc1_.overrides = [this._EndOfGameView_SetProperty1_i()];
         BindingManager.executeBindings(this,"_EndOfGameView_State1",this._EndOfGameView_State1);
         return _loc1_;
      }
      
      private function onPlayAgainButtonClicked(param1:MouseEvent) : void
      {
         this.endOfGameStatsController.returnToLobby();
      }
      
      public function set endOfGameStatsController(param1:EndOfGameStatsController) : void
      {
         var _loc2_:Object = this._1164646953endOfGameStatsController;
         if(_loc2_ !== param1)
         {
            this._1164646953endOfGameStatsController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"endOfGameStatsController",_loc2_,param1));
         }
      }
      
      public function set endOfGame_c(param1:ViewStack) : void
      {
         var _loc2_:Object = this._1097794056endOfGame_c;
         if(_loc2_ !== param1)
         {
            this._1097794056endOfGame_c = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"endOfGame_c",_loc2_,param1));
         }
      }
      
      private function onCreationComplete() : void
      {
         this.isInitialized = true;
      }
      
      public function ___EndOfGameView_Canvas1_show(param1:FlexEvent) : void
      {
         this.onShow();
      }
      
      private function _EndOfGameView_State3_i() : State
      {
         var _loc1_:State = new State();
         this._EndOfGameView_State3 = _loc1_;
         _loc1_.overrides = [this._EndOfGameView_SetProperty3_i()];
         BindingManager.executeBindings(this,"_EndOfGameView_State3",this._EndOfGameView_State3);
         return _loc1_;
      }
      
      private function onHide() : void
      {
         this.resetView();
      }
      
      public function set selectedEndOfGameViewIndex(param1:int) : void
      {
         var _loc2_:Object = this._1881928804selectedEndOfGameViewIndex;
         if(_loc2_ !== param1)
         {
            this._1881928804selectedEndOfGameViewIndex = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"selectedEndOfGameViewIndex",_loc2_,param1));
         }
      }
      
      public function set waitingForStats_c(param1:VBox) : void
      {
         var _loc2_:Object = this._2130420199waitingForStats_c;
         if(_loc2_ !== param1)
         {
            this._2130420199waitingForStats_c = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"waitingForStats_c",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      [Inject]
      public function get endOfGameStatsController() : EndOfGameStatsController
      {
         return this._1164646953endOfGameStatsController;
      }
      
      private function _EndOfGameView_SetProperty1_i() : SetProperty
      {
         var _loc1_:SetProperty = new SetProperty();
         this._EndOfGameView_SetProperty1 = _loc1_;
         _loc1_.name = "selectedEndOfGameViewIndex";
         _loc1_.value = 0;
         BindingManager.executeBindings(this,"_EndOfGameView_SetProperty1",this._EndOfGameView_SetProperty1);
         return _loc1_;
      }
      
      private function _EndOfGameView_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.endOfGameStatsController.currentEndOfGameState;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            this.currentState = param1;
         },"this.currentState");
         result[0] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = EndOfGameStatsController.WAITING_FOR_STATS;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _EndOfGameView_State1.name = param1;
         },"_EndOfGameView_State1.name");
         result[1] = binding;
         binding = new Binding(this,function():Object
         {
            return this;
         },function(param1:Object):void
         {
            _EndOfGameView_SetProperty1.target = param1;
         },"_EndOfGameView_SetProperty1.target");
         result[2] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = EndOfGameStatsController.SHOW_STATS;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _EndOfGameView_State2.name = param1;
         },"_EndOfGameView_State2.name");
         result[3] = binding;
         binding = new Binding(this,function():Object
         {
            return this;
         },function(param1:Object):void
         {
            _EndOfGameView_SetProperty2.target = param1;
         },"_EndOfGameView_SetProperty2.target");
         result[4] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = EndOfGameStatsController.TUTORIAL_GAME_WRAPUP;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _EndOfGameView_State3.name = param1;
         },"_EndOfGameView_State3.name");
         result[5] = binding;
         binding = new Binding(this,function():Object
         {
            return this;
         },function(param1:Object):void
         {
            _EndOfGameView_SetProperty3.target = param1;
         },"_EndOfGameView_SetProperty3.target");
         result[6] = binding;
         binding = new Binding(this,function():int
         {
            return this.selectedEndOfGameViewIndex;
         },function(param1:int):void
         {
            endOfGame_c.selectedIndex = param1;
         },"endOfGame_c.selectedIndex");
         result[7] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","practiceGame_waitingForStats_statusLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _EndOfGameView_Label1.htmlText = param1;
         },"_EndOfGameView_Label1.htmlText");
         result[8] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","practiceGame_waitingForStats_playAgainButtonLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _EndOfGameView_SoundEffectButton1.label = param1;
         },"_EndOfGameView_SoundEffectButton1.label");
         result[9] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","practiceGame_waitingForStats_playAgainButton_tooltip");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _EndOfGameView_SoundEffectButton1.toolTip = param1;
         },"_EndOfGameView_SoundEffectButton1.toolTip");
         result[10] = binding;
         return result;
      }
      
      private function _EndOfGameView_SetProperty3_i() : SetProperty
      {
         var _loc1_:SetProperty = new SetProperty();
         this._EndOfGameView_SetProperty3 = _loc1_;
         _loc1_.name = "selectedEndOfGameViewIndex";
         _loc1_.value = 2;
         BindingManager.executeBindings(this,"_EndOfGameView_SetProperty3",this._EndOfGameView_SetProperty3);
         return _loc1_;
      }
      
      public function ___EndOfGameView_Canvas1_currentStateChange(param1:StateChangeEvent) : void
      {
         this.onCurrentStateChanged(param1);
      }
      
      private function _EndOfGameView_State2_i() : State
      {
         var _loc1_:State = new State();
         this._EndOfGameView_State2 = _loc1_;
         _loc1_.overrides = [this._EndOfGameView_SetProperty2_i()];
         BindingManager.executeBindings(this,"_EndOfGameView_State2",this._EndOfGameView_State2);
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get selectedEndOfGameViewIndex() : int
      {
         return this._1881928804selectedEndOfGameViewIndex;
      }
      
      public function ___EndOfGameView_Canvas1_creationComplete(param1:FlexEvent) : void
      {
         this.onCreationComplete();
      }
      
      private function onShow() : void
      {
         this.isInitialized = true;
      }
      
      [Bindable(event="propertyChange")]
      public function get waitingForStats_c() : VBox
      {
         return this._2130420199waitingForStats_c;
      }
   }
}

