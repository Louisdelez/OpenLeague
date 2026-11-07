package com.riotgames.platform.gameclient.views.game.common.endofgame
{
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.common.event.ShellEvent;
   import com.riotgames.platform.gameclient.components.button.SoundEffectButton;
   import com.riotgames.platform.gameclient.domain.lobby.LobbyViewState;
   import com.riotgames.platform.gameclient.views.lobby.*;
   import com.riotgames.pvpnet.game.controllers.EndOfGameStatsController;
   import com.riotgames.pvpnet.game.controllers.MasterGameController;
   import com.riotgames.pvpnet.game.controllers.lobby.ILobbyViewController;
   import com.riotgames.pvpnet.game.controllers.tutorial.CreateTutorialGameController;
   import com.riotgames.pvpnet.system.config.cdc.DynamicClientConfigManager;
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
   import mx.containers.utilityClasses.ConstraintColumn;
   import mx.controls.Image;
   import mx.controls.Text;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class EndOfTutorialGameView extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      [Inject]
      private var _1685149624createTutorialGameController:CreateTutorialGameController;
      
      private var _1779761307intructionsText:String = "";
      
      [Inject]
      public var lobbyController:ILobbyViewController;
      
      private var _603450141menu_img:Image;
      
      mx_internal var _watchers:Array;
      
      private var _948491687colLeft:ConstraintColumn;
      
      private var _1040321826no_btn:SoundEffectButton;
      
      private var _586857529buttonsCanvas:Canvas;
      
      private var _655867780colRight:ConstraintColumn;
      
      [Inject]
      private var _1164646953endOfGameStatsController:EndOfGameStatsController;
      
      [Inject]
      public var masterGameController:MasterGameController;
      
      private var _1011496546endTutorialInstructions:Text;
      
      private var _701282462playTutorialLabel:Text;
      
      private var _607740351labelText:String = "";
      
      mx_internal var _bindingsByDestination:Object;
      
      mx_internal var _bindingsBeginWithWord:Object;
      
      private var hasRejectedPlayAgainOnce:Boolean = false;
      
      mx_internal var _bindings:Array;
      
      private var _1280527100yes_btn:SoundEffectButton;
      
      private var _documentDescriptor_:UIComponentDescriptor;
      
      private var _1427821874background_img:Image;
      
      public function EndOfTutorialGameView()
      {
         this._documentDescriptor_ = new UIComponentDescriptor({
            "type":Canvas,
            "propertiesFactory":function():Object
            {
               return {"childDescriptors":[new UIComponentDescriptor({
                  "type":Image,
                  "id":"background_img",
                  "propertiesFactory":function():Object
                  {
                     return {
                        "x":0,
                        "y":-50,
                        "source":"/assets/images/championScreens/endOfTutorialBackground.png"
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":Image,
                  "id":"menu_img",
                  "stylesFactory":function():void
                  {
                     this.horizontalCenter = "0";
                     this.verticalCenter = "0";
                  }
               }),new UIComponentDescriptor({
                  "type":Text,
                  "id":"endTutorialInstructions",
                  "stylesFactory":function():void
                  {
                     this.top = "245";
                     this.horizontalCenter = "0";
                     this.textAlign = "center";
                  },
                  "propertiesFactory":function():Object
                  {
                     return {
                        "selectable":false,
                        "styleName":"s1FormMessage"
                     };
                  }
               }),new UIComponentDescriptor({
                  "type":Canvas,
                  "id":"buttonsCanvas",
                  "propertiesFactory":function():Object
                  {
                     return {
                        "cacheAsBitmap":true,
                        "height":230,
                        "constraintColumns":[_EndOfTutorialGameView_ConstraintColumn1_i(),_EndOfTutorialGameView_ConstraintColumn2_i()],
                        "childDescriptors":[new UIComponentDescriptor({
                           "type":Text,
                           "id":"playTutorialLabel",
                           "stylesFactory":function():void
                           {
                              this.top = "14";
                              this.textAlign = "center";
                           },
                           "propertiesFactory":function():Object
                           {
                              return {
                                 "selectable":false,
                                 "styleName":"s1FormMessage"
                              };
                           }
                        }),new UIComponentDescriptor({
                           "type":SoundEffectButton,
                           "id":"yes_btn",
                           "events":{"click":"__yes_btn_click"},
                           "stylesFactory":function():void
                           {
                              this.bottom = "5";
                              this.right = "colLeft:10";
                           },
                           "propertiesFactory":function():Object
                           {
                              return {"styleName":"s1FormButton"};
                           }
                        }),new UIComponentDescriptor({
                           "type":SoundEffectButton,
                           "id":"no_btn",
                           "events":{"click":"__no_btn_click"},
                           "stylesFactory":function():void
                           {
                              this.left = "colRight:10";
                           },
                           "propertiesFactory":function():Object
                           {
                              return {"styleName":"s1FormButton"};
                           }
                        })]
                     };
                  }
               })]};
            }
         });
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
            this.backgroundColor = 0;
         };
         this.cacheAsBitmap = true;
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this.addEventListener("initialize",this.___EndOfTutorialGameView_Canvas1_initialize);
         this.addEventListener("creationComplete",this.___EndOfTutorialGameView_Canvas1_creationComplete);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         EndOfTutorialGameView._watcherSetupUtil = param1;
      }
      
      private function set labelText(param1:String) : void
      {
         var _loc2_:Object = this._607740351labelText;
         if(_loc2_ !== param1)
         {
            this._607740351labelText = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"labelText",_loc2_,param1));
         }
      }
      
      private function noClickHandler() : void
      {
         var _loc1_:Number = Number(DynamicClientConfigManager.getConfiguration(ChooseGameFlowViewLayoutDefinition.DYNAMIC_CONFIG_NEW_PLAYER_ROUTER,"QueueID",ChooseGameViewLayoutPVE.QUEUE_COOP_VS_AI_SR_5v5_EASY).getNumber());
         if(this.createTutorialGameController.isBasicTutorial)
         {
            this.endOfGameStatsController.returnToLobby();
         }
         else if(!this.hasRejectedPlayAgainOnce && Boolean(this.masterGameController.masterGameViewController.gameQueueManager.getQueueForID(_loc1_)))
         {
            this.hasRejectedPlayAgainOnce = true;
            this.intructionsText = resourceManager.getString("resources","endOfGameTutorialInstructions_advanced2");
            this.labelText = resourceManager.getString("resources","endOfGameTutorial_choosePracticeGame_advanced2");
         }
         else
         {
            this.endOfGameStatsController.returnToLobby();
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get yes_btn() : SoundEffectButton
      {
         return this._1280527100yes_btn;
      }
      
      public function set yes_btn(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = this._1280527100yes_btn;
         if(_loc2_ !== param1)
         {
            this._1280527100yes_btn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"yes_btn",_loc2_,param1));
         }
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:EndOfTutorialGameView = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._EndOfTutorialGameView_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_game_common_endofgame_EndOfTutorialGameViewWatcherSetupUtil");
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
      
      public function resetView() : void
      {
      }
      
      private function _EndOfTutorialGameView_ConstraintColumn2_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.colRight = _loc1_;
         _loc1_.percentWidth = 50;
         _loc1_.initialized(this,"colRight");
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get endTutorialInstructions() : Text
      {
         return this._1011496546endTutorialInstructions;
      }
      
      [Bindable(event="propertyChange")]
      public function get colLeft() : ConstraintColumn
      {
         return this._948491687colLeft;
      }
      
      public function set createTutorialGameController(param1:CreateTutorialGameController) : void
      {
         var _loc2_:Object = this._1685149624createTutorialGameController;
         if(_loc2_ !== param1)
         {
            this._1685149624createTutorialGameController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"createTutorialGameController",_loc2_,param1));
         }
      }
      
      public function __yes_btn_click(param1:MouseEvent) : void
      {
         this.yesClickHandler();
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
      
      private function _EndOfTutorialGameView_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = ImagePackLookup.instance.getClassFromSwfRef("e_nameSummoner_menuBg");
         _loc1_ = this.intructionsText;
         _loc1_ = this.width * 0.5;
         _loc1_ = this.width * 0.35;
         _loc1_ = this.width * 0.35;
         _loc1_ = this.endTutorialInstructions.y + this.endTutorialInstructions.height;
         _loc1_ = this.labelText;
         _loc1_ = this.buttonsCanvas.width * 0.98;
         _loc1_ = resourceManager.getString("resources","common_button_yes");
         _loc1_ = resourceManager.getString("resources","common_button_no");
         _loc1_ = this.yes_btn.y;
      }
      
      [Bindable(event="propertyChange")]
      public function get background_img() : Image
      {
         return this._1427821874background_img;
      }
      
      public function ___EndOfTutorialGameView_Canvas1_creationComplete(param1:FlexEvent) : void
      {
         this.initializeEndOfGameTutorialView();
      }
      
      private function set intructionsText(param1:String) : void
      {
         var _loc2_:Object = this._1779761307intructionsText;
         if(_loc2_ !== param1)
         {
            this._1779761307intructionsText = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"intructionsText",_loc2_,param1));
         }
      }
      
      private function yesClickHandler() : void
      {
         var _loc1_:String = null;
         var _loc2_:Number = NaN;
         if(this.hasRejectedPlayAgainOnce)
         {
            this.endOfGameStatsController.returnToLobby();
         }
         else if(Boolean(this.createTutorialGameController.isBasicTutorial) && Boolean(this.createTutorialGameController.isAdvancedTutorialEnabled()))
         {
            this.createTutorialGameController.chooseTutorialType(false);
            this.masterGameController.startTutorialGame();
            this.lobbyController.requestLobbyState(LobbyViewState.PLAY_TUTORIAL_GAME_STATE);
         }
         else
         {
            _loc1_ = DynamicClientConfigManager.getConfiguration(ChooseGameFlowViewLayoutDefinition.DYNAMIC_CONFIG_NEW_PLAYER_ROUTER,"Difficulty","EASY").getString();
            _loc2_ = Number(DynamicClientConfigManager.getConfiguration(ChooseGameFlowViewLayoutDefinition.DYNAMIC_CONFIG_NEW_PLAYER_ROUTER,"QueueID",ChooseGameViewLayoutPVE.QUEUE_COOP_VS_AI_SR_5v5_EASY).getNumber());
            this.masterGameController.gameModel.difficulty = _loc1_;
            this.masterGameController.cleanupAfterGameCompleteOrAborted();
            this.masterGameController.startCoopVsAIGameFlow(true);
            this.masterGameController.masterGameViewController.gameQueueManager.setSelectedQueueId(_loc2_);
            this.masterGameController.masterGameViewController.handleSelectMapContinue();
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get buttonsCanvas() : Canvas
      {
         return this._586857529buttonsCanvas;
      }
      
      public function set endTutorialInstructions(param1:Text) : void
      {
         var _loc2_:Object = this._1011496546endTutorialInstructions;
         if(_loc2_ !== param1)
         {
            this._1011496546endTutorialInstructions = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"endTutorialInstructions",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get intructionsText() : String
      {
         return this._1779761307intructionsText;
      }
      
      public function initializeEndOfGameTutorialView() : void
      {
         var _loc1_:Number = Number(DynamicClientConfigManager.getConfiguration(ChooseGameFlowViewLayoutDefinition.DYNAMIC_CONFIG_NEW_PLAYER_ROUTER,"QueueID",ChooseGameViewLayoutPVE.QUEUE_COOP_VS_AI_SR_5v5_EASY).getNumber());
         if(Boolean(this.createTutorialGameController) && Boolean(this.initialized))
         {
            this.hasRejectedPlayAgainOnce = false;
            if(Boolean(this.createTutorialGameController.isBasicTutorial) && Boolean(this.createTutorialGameController.isAdvancedTutorialEnabled()))
            {
               this.intructionsText = resourceManager.getString("resources","endOfGameTutorialInstructions_basic");
               this.labelText = resourceManager.getString("resources","endOfGameTutorial_choosePracticeGame_basic");
            }
            else if(this.masterGameController.masterGameViewController.gameQueueManager.getQueueForID(_loc1_))
            {
               this.intructionsText = resourceManager.getString("resources","endOfGameTutorialInstructions_advanced");
               this.labelText = resourceManager.getString("resources","endOfGameTutorial_choosePracticeGame_advanced");
            }
            else
            {
               this.endOfGameStatsController.returnToLobby();
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      private function get labelText() : String
      {
         return this._607740351labelText;
      }
      
      public function set no_btn(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = this._1040321826no_btn;
         if(_loc2_ !== param1)
         {
            this._1040321826no_btn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"no_btn",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      [Inject]
      public function get createTutorialGameController() : CreateTutorialGameController
      {
         return this._1685149624createTutorialGameController;
      }
      
      public function set playTutorialLabel(param1:Text) : void
      {
         var _loc2_:Object = this._701282462playTutorialLabel;
         if(_loc2_ !== param1)
         {
            this._701282462playTutorialLabel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"playTutorialLabel",_loc2_,param1));
         }
      }
      
      public function ___EndOfTutorialGameView_Canvas1_initialize(param1:FlexEvent) : void
      {
         this.onInitialize();
      }
      
      public function __no_btn_click(param1:MouseEvent) : void
      {
         this.noClickHandler();
      }
      
      private function onInitialize() : void
      {
         ShellDispatcher.instance.addEventListener(ShellEvent.RESTORE,this.applyRestoreBugFix);
      }
      
      private function _EndOfTutorialGameView_ConstraintColumn1_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.colLeft = _loc1_;
         _loc1_.percentWidth = 50;
         _loc1_.initialized(this,"colLeft");
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      [Inject]
      public function get endOfGameStatsController() : EndOfGameStatsController
      {
         return this._1164646953endOfGameStatsController;
      }
      
      private function _EndOfTutorialGameView_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():Object
         {
            return ImagePackLookup.instance.getClassFromSwfRef("e_nameSummoner_menuBg");
         },function(param1:Object):void
         {
            menu_img.source = param1;
         },"menu_img.source");
         result[0] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.intructionsText;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            endTutorialInstructions.htmlText = param1;
         },"endTutorialInstructions.htmlText");
         result[1] = binding;
         binding = new Binding(this,function():Number
         {
            return this.width * 0.5;
         },function(param1:Number):void
         {
            endTutorialInstructions.width = param1;
         },"endTutorialInstructions.width");
         result[2] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.width * 0.35;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            buttonsCanvas.setStyle("left",param1);
         },"buttonsCanvas.left");
         result[3] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.width * 0.35;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            buttonsCanvas.setStyle("right",param1);
         },"buttonsCanvas.right");
         result[4] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = endTutorialInstructions.y + endTutorialInstructions.height;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            buttonsCanvas.setStyle("top",param1);
         },"buttonsCanvas.top");
         result[5] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.labelText;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            playTutorialLabel.htmlText = param1;
         },"playTutorialLabel.htmlText");
         result[6] = binding;
         binding = new Binding(this,function():Number
         {
            return buttonsCanvas.width * 0.98;
         },function(param1:Number):void
         {
            playTutorialLabel.width = param1;
         },"playTutorialLabel.width");
         result[7] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","common_button_yes");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            yes_btn.label = param1;
         },"yes_btn.label");
         result[8] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","common_button_no");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            no_btn.label = param1;
         },"no_btn.label");
         result[9] = binding;
         binding = new Binding(this,function():Number
         {
            return yes_btn.y;
         },function(param1:Number):void
         {
            no_btn.y = param1;
         },"no_btn.y");
         result[10] = binding;
         return result;
      }
      
      public function set colLeft(param1:ConstraintColumn) : void
      {
         var _loc2_:Object = this._948491687colLeft;
         if(_loc2_ !== param1)
         {
            this._948491687colLeft = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"colLeft",_loc2_,param1));
         }
      }
      
      public function set menu_img(param1:Image) : void
      {
         var _loc2_:Object = this._603450141menu_img;
         if(_loc2_ !== param1)
         {
            this._603450141menu_img = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"menu_img",_loc2_,param1));
         }
      }
      
      private function applyRestoreBugFix(param1:ShellEvent) : void
      {
         if(this.visible)
         {
            this.invalidateDisplayList();
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get playTutorialLabel() : Text
      {
         return this._701282462playTutorialLabel;
      }
      
      [Bindable(event="propertyChange")]
      public function get menu_img() : Image
      {
         return this._603450141menu_img;
      }
      
      public function set background_img(param1:Image) : void
      {
         var _loc2_:Object = this._1427821874background_img;
         if(_loc2_ !== param1)
         {
            this._1427821874background_img = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"background_img",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get no_btn() : SoundEffectButton
      {
         return this._1040321826no_btn;
      }
      
      public function set buttonsCanvas(param1:Canvas) : void
      {
         var _loc2_:Object = this._586857529buttonsCanvas;
         if(_loc2_ !== param1)
         {
            this._586857529buttonsCanvas = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"buttonsCanvas",_loc2_,param1));
         }
      }
      
      public function set colRight(param1:ConstraintColumn) : void
      {
         var _loc2_:Object = this._655867780colRight;
         if(_loc2_ !== param1)
         {
            this._655867780colRight = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"colRight",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get colRight() : ConstraintColumn
      {
         return this._655867780colRight;
      }
   }
}

