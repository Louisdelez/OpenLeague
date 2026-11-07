package com.riotgames.platform.gameclient.views.game.common.ingame
{
   import com.riotgames.platform.common.AppConfig;
   import com.riotgames.platform.common.IAppController;
   import com.riotgames.platform.common.error.ServerError;
   import com.riotgames.platform.common.event.ShellEvent;
   import com.riotgames.platform.common.utils.MessageDictionary;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.components.button.SoundEffectButton;
   import com.riotgames.pvpnet.game.controllers.InGameController;
   import com.riotgames.pvpnet.game.controllers.MasterGameController;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.pvpnet.system.alerter.AlerterProviderProxy;
   import com.riotgames.pvpnet.system.alerter.IAlerterProvider;
   import com.riotgames.pvpnet.system.maestro.MaestroController;
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
   import mx.controls.Image;
   import mx.controls.Text;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.events.StateChangeEvent;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.resources.IResourceManager;
   import mx.resources.ResourceManager;
   import mx.states.State;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class InGameView extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      public var _InGameView_Text1:Text;
      
      [Inject]
      private var _269543472masterGameController:MasterGameController;
      
      public var alerter:IAlerterProvider = AlerterProviderProxy.instance;
      
      [Inject]
      private var _2070536460applicationController:IAppController;
      
      private var _348843226showReconnect:Boolean = true;
      
      private var _139485677bodyText_c:Text;
      
      private var _537486115allowCancel:Boolean = false;
      
      mx_internal var _bindingsByDestination:Object = {};
      
      private var _1702646255bodyText:String;
      
      private var _1977519450headerText:String;
      
      mx_internal var _watchers:Array = [];
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      public var _InGameView_SoundEffectButton1:SoundEffectButton;
      
      public var _InGameView_SoundEffectButton2:SoundEffectButton;
      
      public var _InGameView_SoundEffectButton3:SoundEffectButton;
      
      private var _407108067content_c:Canvas;
      
      mx_internal var _bindingsBeginWithWord:Object = {};
      
      [Inject]
      private var _957204045inGameController:InGameController;
      
      private var _embed_mxml________ClientAssets_imageEmbeds_backgrounds_alertFlat_jpg_1941930142:Class = InGameView__embed_mxml________ClientAssets_imageEmbeds_backgrounds_alertFlat_jpg_1941930142;
      
      public var _InGameView_State1:State;
      
      public var _InGameView_State2:State;
      
      public var _InGameView_State3:State;
      
      public var _InGameView_State4:State;
      
      mx_internal var _bindings:Array = [];
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {"childDescriptors":[new UIComponentDescriptor({
               "type":Canvas,
               "id":"content_c",
               "stylesFactory":function():void
               {
                  this.left = "0";
                  this.right = "0";
                  this.top = "0";
                  this.bottom = "0";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "cacheAsBitmap":true,
                     "childDescriptors":[new UIComponentDescriptor({
                        "type":Canvas,
                        "stylesFactory":function():void
                        {
                           this.backgroundColor = 131586;
                           this.backgroundAlpha = 1;
                        },
                        "propertiesFactory":function():Object
                        {
                           return {
                              "cacheAsBitmap":true,
                              "visible":true,
                              "x":0,
                              "y":0,
                              "percentWidth":100,
                              "percentHeight":100,
                              "horizontalScrollPolicy":"off",
                              "verticalScrollPolicy":"off",
                              "childDescriptors":[new UIComponentDescriptor({
                                 "type":Image,
                                 "stylesFactory":function():void
                                 {
                                    this.left = "-4";
                                    this.right = "-4";
                                    this.verticalCenter = "0";
                                 },
                                 "propertiesFactory":function():Object
                                 {
                                    return {"source":_embed_mxml________ClientAssets_imageEmbeds_backgrounds_alertFlat_jpg_1941930142};
                                 }
                              }),new UIComponentDescriptor({
                                 "type":Canvas,
                                 "stylesFactory":function():void
                                 {
                                    this.left = "450";
                                    this.right = "450";
                                    this.top = "265";
                                    this.bottom = "265";
                                 },
                                 "propertiesFactory":function():Object
                                 {
                                    return {"childDescriptors":[new UIComponentDescriptor({
                                       "type":Text,
                                       "id":"_InGameView_Text1",
                                       "stylesFactory":function():void
                                       {
                                          this.left = "20";
                                          this.top = "8";
                                          this.fontSize = 15;
                                          this.textAlign = "center";
                                       },
                                       "propertiesFactory":function():Object
                                       {
                                          return {
                                             "styleName":"playGameText",
                                             "selectable":false
                                          };
                                       }
                                    }),new UIComponentDescriptor({
                                       "type":Text,
                                       "id":"bodyText_c",
                                       "stylesFactory":function():void
                                       {
                                          this.horizontalCenter = "0";
                                          this.verticalCenter = "-8";
                                          this.fontSize = 16;
                                          this.textAlign = "center";
                                       },
                                       "propertiesFactory":function():Object
                                       {
                                          return {
                                             "width":300,
                                             "selectable":false,
                                             "styleName":"playGameText",
                                             "height":80
                                          };
                                       }
                                    }),new UIComponentDescriptor({
                                       "type":SoundEffectButton,
                                       "id":"_InGameView_SoundEffectButton1",
                                       "events":{"click":"___InGameView_SoundEffectButton1_click"},
                                       "stylesFactory":function():void
                                       {
                                          this.horizontalCenter = "0";
                                          this.bottom = "18";
                                       },
                                       "propertiesFactory":function():Object
                                       {
                                          return {"styleName":"longButtonOrange2"};
                                       }
                                    }),new UIComponentDescriptor({
                                       "type":SoundEffectButton,
                                       "id":"_InGameView_SoundEffectButton2",
                                       "events":{"click":"___InGameView_SoundEffectButton2_click"},
                                       "stylesFactory":function():void
                                       {
                                          this.left = "30";
                                          this.bottom = "18";
                                       },
                                       "propertiesFactory":function():Object
                                       {
                                          return {"styleName":"smallButtonOrange"};
                                       }
                                    }),new UIComponentDescriptor({
                                       "type":SoundEffectButton,
                                       "id":"_InGameView_SoundEffectButton3",
                                       "events":{"click":"___InGameView_SoundEffectButton3_click"},
                                       "stylesFactory":function():void
                                       {
                                          this.right = "30";
                                          this.bottom = "18";
                                       },
                                       "propertiesFactory":function():Object
                                       {
                                          return {"styleName":"genericButton"};
                                       }
                                    })]};
                                 }
                              })]
                           };
                        }
                     })]
                  };
               }
            })]};
         }
      });
      
      public var shellDispatcher:ShellDispatcher = ShellDispatcher.instance;
      
      private var isBusyWatcher:ChangeWatcher;
      
      public function InGameView()
      {
         super();
         mx_internal::_document = this;
         this.cacheAsBitmap = true;
         this.percentWidth = 100;
         this.percentHeight = 100;
         this.states = [this._InGameView_State1_i(),this._InGameView_State2_i(),this._InGameView_State3_i(),this._InGameView_State4_i()];
         this.addEventListener("initialize",this.___InGameView_Canvas1_initialize);
         this.addEventListener("show",this.___InGameView_Canvas1_show);
         this.addEventListener("hide",this.___InGameView_Canvas1_hide);
         this.addEventListener("currentStateChanging",this.___InGameView_Canvas1_currentStateChanging);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         InGameView._watcherSetupUtil = param1;
      }
      
      private function onReconnectAlertDismissed() : void
      {
         this.inGameController.cancelGameFlow();
      }
      
      private function _InGameView_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.inGameController.currentState;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            this.currentState = param1;
         },"this.currentState");
         result[0] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = InGameController.PLAYING_CONNECTED;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _InGameView_State1.name = param1;
         },"_InGameView_State1.name");
         result[1] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = InGameController.PLAYING_DISCONNECTED;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _InGameView_State2.name = param1;
         },"_InGameView_State2.name");
         result[2] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = InGameController.PLAYING_CRASHED;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _InGameView_State3.name = param1;
         },"_InGameView_State3.name");
         result[3] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = InGameController.PLAYING_SPECTATOR_DISCONNECT;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _InGameView_State4.name = param1;
         },"_InGameView_State4.name");
         result[4] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = headerText;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _InGameView_Text1.text = param1;
         },"_InGameView_Text1.text");
         result[5] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = bodyText;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            bodyText_c.text = param1;
         },"bodyText_c.text");
         result[6] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = AppConfig.instance.otherGameInProgress ? resourceManager.getString("resources","practiceGame_inGame_otherAccount_reconnectButtonLabel") : resourceManager.getString("resources","practiceGame_inGame_reconnectButtonLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _InGameView_SoundEffectButton1.label = param1;
         },"_InGameView_SoundEffectButton1.label");
         result[7] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = AppConfig.instance.otherGameInProgress ? resourceManager.getString("resources","practiceGame_inGame_otherAccount_reconnectButton_tooltip") : resourceManager.getString("resources","practiceGame_inGame_reconnectButton_tooltip");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _InGameView_SoundEffectButton1.toolTip = param1;
         },"_InGameView_SoundEffectButton1.toolTip");
         result[8] = binding;
         binding = new Binding(this,function():Boolean
         {
            return !this.inGameController.isBusy;
         },function(param1:Boolean):void
         {
            _InGameView_SoundEffectButton1.enabled = param1;
         },"_InGameView_SoundEffectButton1.enabled");
         result[9] = binding;
         binding = new Binding(this,function():Boolean
         {
            return showReconnect && !allowCancel;
         },function(param1:Boolean):void
         {
            _InGameView_SoundEffectButton1.visible = param1;
         },"_InGameView_SoundEffectButton1.visible");
         result[10] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = AppConfig.instance.otherGameInProgress ? resourceManager.getString("resources","practiceGame_inGame_otherAccount_reconnectButtonLabel") : resourceManager.getString("resources","practiceGame_inGame_reconnectButtonLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _InGameView_SoundEffectButton2.label = param1;
         },"_InGameView_SoundEffectButton2.label");
         result[11] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = AppConfig.instance.otherGameInProgress ? resourceManager.getString("resources","practiceGame_inGame_otherAccount_reconnectButton_tooltip") : resourceManager.getString("resources","practiceGame_inGame_reconnectButton_tooltip");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _InGameView_SoundEffectButton2.toolTip = param1;
         },"_InGameView_SoundEffectButton2.toolTip");
         result[12] = binding;
         binding = new Binding(this,function():Boolean
         {
            return !this.inGameController.isBusy;
         },function(param1:Boolean):void
         {
            _InGameView_SoundEffectButton2.enabled = param1;
         },"_InGameView_SoundEffectButton2.enabled");
         result[13] = binding;
         binding = new Binding(this,function():Boolean
         {
            return allowCancel;
         },function(param1:Boolean):void
         {
            _InGameView_SoundEffectButton2.visible = param1;
         },"_InGameView_SoundEffectButton2.visible");
         result[14] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","practiceGame_inGame_reconnectCancelButtonLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _InGameView_SoundEffectButton3.label = param1;
         },"_InGameView_SoundEffectButton3.label");
         result[15] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","practiceGame_inGame_reconnectCancelButtonTooltip");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _InGameView_SoundEffectButton3.toolTip = param1;
         },"_InGameView_SoundEffectButton3.toolTip");
         result[16] = binding;
         binding = new Binding(this,function():Boolean
         {
            return allowCancel;
         },function(param1:Boolean):void
         {
            _InGameView_SoundEffectButton3.visible = param1;
         },"_InGameView_SoundEffectButton3.visible");
         result[17] = binding;
         return result;
      }
      
      [Bindable(event="propertyChange")]
      [Inject]
      public function get applicationController() : IAppController
      {
         return this._2070536460applicationController;
      }
      
      private function _InGameView_State4_i() : State
      {
         var _loc1_:State = new State();
         this._InGameView_State4 = _loc1_;
         BindingManager.executeBindings(this,"_InGameView_State4",this._InGameView_State4);
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get bodyText_c() : Text
      {
         return this._139485677bodyText_c;
      }
      
      [Bindable(event="propertyChange")]
      public function get content_c() : Canvas
      {
         return this._407108067content_c;
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
      
      public function set bodyText_c(param1:Text) : void
      {
         var _loc2_:Object = this._139485677bodyText_c;
         if(_loc2_ !== param1)
         {
            this._139485677bodyText_c = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bodyText_c",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get allowCancel() : Boolean
      {
         return this._537486115allowCancel;
      }
      
      public function ___InGameView_SoundEffectButton2_click(param1:MouseEvent) : void
      {
         this.onReconnectButtonClicked(param1);
      }
      
      [Bindable(event="propertyChange")]
      [Inject]
      public function get masterGameController() : MasterGameController
      {
         return this._269543472masterGameController;
      }
      
      public function set content_c(param1:Canvas) : void
      {
         var _loc2_:Object = this._407108067content_c;
         if(_loc2_ !== param1)
         {
            this._407108067content_c = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"content_c",_loc2_,param1));
         }
      }
      
      private function onReconnectButtonClicked(param1:Event) : void
      {
         if(AppConfig.instance.otherGameInProgress)
         {
            this.applicationController.logout(false);
         }
         else
         {
            this.inGameController.reconnectToGame(this.onReconnectFailed);
         }
      }
      
      private function onIsBusyChanged(param1:PropertyChangeEvent) : void
      {
      }
      
      public function initializeView() : void
      {
         this.isBusyWatcher = ChangeWatcher.watch(this.inGameController,"isBusy",this.onIsBusyChanged);
         this.shellDispatcher.addEventListener(ShellEvent.RESTORE,this.onShellMaximize);
      }
      
      private function _InGameView_State3_i() : State
      {
         var _loc1_:State = new State();
         this._InGameView_State3 = _loc1_;
         BindingManager.executeBindings(this,"_InGameView_State3",this._InGameView_State3);
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      private function get headerText() : String
      {
         return this._1977519450headerText;
      }
      
      private function set allowCancel(param1:Boolean) : void
      {
         var _loc2_:Object = this._537486115allowCancel;
         if(_loc2_ !== param1)
         {
            this._537486115allowCancel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"allowCancel",_loc2_,param1));
         }
      }
      
      public function set inGameController(param1:InGameController) : void
      {
         var _loc2_:Object = this._957204045inGameController;
         if(_loc2_ !== param1)
         {
            this._957204045inGameController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"inGameController",_loc2_,param1));
         }
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
      
      public function ___InGameView_SoundEffectButton3_click(param1:MouseEvent) : void
      {
         this.onCancelClicked();
      }
      
      private function onShow() : void
      {
         this.initializeView();
      }
      
      private function onShellMaximize(param1:ShellEvent) : void
      {
         this.onApplicationRestored();
      }
      
      private function _InGameView_State2_i() : State
      {
         var _loc1_:State = new State();
         this._InGameView_State2 = _loc1_;
         BindingManager.executeBindings(this,"_InGameView_State2",this._InGameView_State2);
         return _loc1_;
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:InGameView = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._InGameView_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_game_common_ingame_InGameViewWatcherSetupUtil");
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
      
      private function onReconnectFailed(param1:ServerError) : void
      {
         var _loc2_:IResourceManager = ResourceManager.getInstance();
         var _loc3_:AlertAction = new AlertAction(_loc2_.getString("resources","alert_title"),_loc2_.getString("resources",param1.errorCode,param1.messageArguments));
         if(param1.errorCode == MessageDictionary.GAME_NO_LONGER_IN_PROGRESS)
         {
            _loc3_.getCompleted().add(this.onReconnectAlertDismissed);
         }
         _loc3_.add();
      }
      
      public function resetView() : void
      {
         if(this.content_c)
         {
            this.content_c.clearStyle("backgroundImage");
         }
         if(this.isBusyWatcher != null)
         {
            this.isBusyWatcher.unwatch();
            this.isBusyWatcher = null;
         }
         this.shellDispatcher.removeEventListener(MaestroController.GAME_COMPLETED,this.onGameCompleted);
         this.shellDispatcher.removeEventListener(ShellEvent.RESTORE,this.onShellMaximize);
      }
      
      private function _InGameView_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.inGameController.currentState;
         _loc1_ = InGameController.PLAYING_CONNECTED;
         _loc1_ = InGameController.PLAYING_DISCONNECTED;
         _loc1_ = InGameController.PLAYING_CRASHED;
         _loc1_ = InGameController.PLAYING_SPECTATOR_DISCONNECT;
         _loc1_ = this.headerText;
         _loc1_ = this.bodyText;
         _loc1_ = AppConfig.instance.otherGameInProgress ? resourceManager.getString("resources","practiceGame_inGame_otherAccount_reconnectButtonLabel") : resourceManager.getString("resources","practiceGame_inGame_reconnectButtonLabel");
         _loc1_ = AppConfig.instance.otherGameInProgress ? resourceManager.getString("resources","practiceGame_inGame_otherAccount_reconnectButton_tooltip") : resourceManager.getString("resources","practiceGame_inGame_reconnectButton_tooltip");
         _loc1_ = !this.inGameController.isBusy;
         _loc1_ = this.showReconnect && !this.allowCancel;
         _loc1_ = AppConfig.instance.otherGameInProgress ? resourceManager.getString("resources","practiceGame_inGame_otherAccount_reconnectButtonLabel") : resourceManager.getString("resources","practiceGame_inGame_reconnectButtonLabel");
         _loc1_ = AppConfig.instance.otherGameInProgress ? resourceManager.getString("resources","practiceGame_inGame_otherAccount_reconnectButton_tooltip") : resourceManager.getString("resources","practiceGame_inGame_reconnectButton_tooltip");
         _loc1_ = !this.inGameController.isBusy;
         _loc1_ = this.allowCancel;
         _loc1_ = resourceManager.getString("resources","practiceGame_inGame_reconnectCancelButtonLabel");
         _loc1_ = resourceManager.getString("resources","practiceGame_inGame_reconnectCancelButtonTooltip");
         _loc1_ = this.allowCancel;
      }
      
      private function onCurrentStateChanging(param1:StateChangeEvent) : void
      {
         invalidateProperties();
      }
      
      private function onApplicationRestored() : void
      {
         this.bodyText_c.invalidateSize();
         this.bodyText_c.validateNow();
      }
      
      private function onCancelClicked() : void
      {
         this.inGameController.stopSpectating();
      }
      
      [Bindable(event="propertyChange")]
      [Inject]
      public function get inGameController() : InGameController
      {
         return this._957204045inGameController;
      }
      
      private function set headerText(param1:String) : void
      {
         var _loc2_:Object = this._1977519450headerText;
         if(_loc2_ !== param1)
         {
            this._1977519450headerText = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"headerText",_loc2_,param1));
         }
      }
      
      public function ___InGameView_Canvas1_show(param1:FlexEvent) : void
      {
         this.onShow();
      }
      
      public function ___InGameView_Canvas1_initialize(param1:FlexEvent) : void
      {
         this.onInitialize();
      }
      
      private function set showReconnect(param1:Boolean) : void
      {
         var _loc2_:Object = this._348843226showReconnect;
         if(_loc2_ !== param1)
         {
            this._348843226showReconnect = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"showReconnect",_loc2_,param1));
         }
      }
      
      private function onHide() : void
      {
         this.resetView();
      }
      
      private function onInitialize() : void
      {
      }
      
      private function _InGameView_State1_i() : State
      {
         var _loc1_:State = new State();
         this._InGameView_State1 = _loc1_;
         BindingManager.executeBindings(this,"_InGameView_State1",this._InGameView_State1);
         return _loc1_;
      }
      
      public function ___InGameView_Canvas1_currentStateChanging(param1:StateChangeEvent) : void
      {
         this.onCurrentStateChanging(param1);
      }
      
      override protected function commitProperties() : void
      {
         if(!this.applicationController || !this.shellDispatcher)
         {
            return;
         }
         this.showReconnect = true;
         if(currentState == InGameController.PLAYING_CONNECTED)
         {
            this.shellDispatcher.removeEventListener(MaestroController.GAME_COMPLETED,this.onGameCompleted);
            this.headerText = RiotResourceLoader.getString("practiceGame_inGame_statusTitle");
            if(AppConfig.instance.otherGameInProgress)
            {
               this.bodyText = RiotResourceLoader.getString("practiceGame_inGame_otherAccount_statusLabel",null,[AppConfig.instance.otherAccountGameInProgressSummonerName]);
               this.allowCancel = false;
               this.showReconnect = true;
            }
            else
            {
               this.bodyText = RiotResourceLoader.getString("practiceGame_inGame_statusLabel");
               this.allowCancel = false;
               this.showReconnect = false;
            }
         }
         else if(currentState == InGameController.PLAYING_DISCONNECTED)
         {
            this.shellDispatcher.addEventListener(MaestroController.GAME_COMPLETED,this.onGameCompleted);
            this.headerText = RiotResourceLoader.getString("maestro_GameAbandonedTitle");
            this.bodyText = RiotResourceLoader.getString("maestro_GameAbandonedMessage");
            this.allowCancel = false;
            this.showReconnect = true;
         }
         else if(currentState == InGameController.PLAYING_CRASHED)
         {
            this.shellDispatcher.addEventListener(MaestroController.GAME_COMPLETED,this.onGameCompleted);
            this.headerText = RiotResourceLoader.getString("maestro_GameCrashedTitle");
            this.bodyText = RiotResourceLoader.getString("maestro_GameCrashedMessage");
            this.allowCancel = false;
            this.showReconnect = true;
         }
         else if(currentState == InGameController.PLAYING_SPECTATOR_DISCONNECT)
         {
            this.shellDispatcher.removeEventListener(MaestroController.GAME_COMPLETED,this.onGameCompleted);
            this.headerText = RiotResourceLoader.getString("maestro_GameAbandonedTitleSpectator");
            this.bodyText = RiotResourceLoader.getString("maestro_GameAbandonedMessageSpectator");
            this.allowCancel = true;
            this.showReconnect = true;
         }
      }
      
      private function onGameCompleted(param1:Event) : void
      {
         var _loc2_:IResourceManager = null;
         var _loc3_:AlertAction = null;
         if(this.currentState == InGameController.PLAYING_DISCONNECTED)
         {
            _loc2_ = ResourceManager.getInstance();
            _loc3_ = new AlertAction(_loc2_.getString("resources","alert_title"),_loc2_.getString("resources",MessageDictionary.GAME_NO_LONGER_IN_PROGRESS));
            _loc3_.add();
         }
      }
      
      private function set bodyText(param1:String) : void
      {
         var _loc2_:Object = this._1702646255bodyText;
         if(_loc2_ !== param1)
         {
            this._1702646255bodyText = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bodyText",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get showReconnect() : Boolean
      {
         return this._348843226showReconnect;
      }
      
      [Bindable(event="propertyChange")]
      private function get bodyText() : String
      {
         return this._1702646255bodyText;
      }
      
      public function ___InGameView_Canvas1_hide(param1:FlexEvent) : void
      {
         this.onHide();
      }
      
      public function ___InGameView_SoundEffectButton1_click(param1:MouseEvent) : void
      {
         this.onReconnectButtonClicked(param1);
      }
   }
}

