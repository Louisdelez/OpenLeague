package com.riotgames.platform.gameclient.views.help
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import com.riotgames.platform.common.ImagePackLookup;
   import com.riotgames.platform.gameclient.components.button.SoundEffectButton;
   import com.riotgames.platform.gameclient.components.list.GradientRollOverList;
   import com.riotgames.platform.gameclient.controllers.help.HelpController;
   import com.riotgames.platform.gameclient.views.game.common.ICancelableDialog;
   import com.riotgames.pvpnet.system.config.ClientConfig;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
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
   import mx.containers.utilityClasses.ConstraintRow;
   import mx.controls.HTML;
   import mx.controls.Image;
   import mx.controls.Label;
   import mx.controls.List;
   import mx.controls.TextArea;
   import mx.core.ClassFactory;
   import mx.core.DeferredInstanceFromFunction;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.effects.Fade;
   import mx.effects.Sequence;
   import mx.effects.SetPropertyAction;
   import mx.events.FlexEvent;
   import mx.events.ListEvent;
   import mx.events.PropertyChangeEvent;
   import mx.resources.ResourceManager;
   import mx.states.AddChild;
   import mx.states.State;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class HelpDialog extends Canvas implements ICancelableDialog, IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      public static const LOADING_SPINNER:Class = HelpDialog_LOADING_SPINNER;
      
      private static const NORMAL_VIEW_STATE:String = "normalViewState";
      
      private static const TENCENT_VIEW_STATE:String = "tencentViewState";
      
      private var _1282133823fadeIn:Sequence;
      
      private var _753137065rightGutter:ConstraintColumn;
      
      public var dialogMode:Boolean = true;
      
      private var _1911380774bottomGutter:ConstraintRow;
      
      private var _567412016topGutter:ConstraintRow;
      
      private var _428154072helpTopics_list:List;
      
      public var _HelpDialog_Canvas2:Canvas;
      
      private var _1895424275clientConfig:ClientConfig = ClientConfig.instance;
      
      private var onClosed:Signal = new Signal();
      
      private var _1775602690leftGutter:ConstraintColumn;
      
      mx_internal var _bindingsByDestination:Object = {};
      
      public var _HelpDialog_State1:State;
      
      public var _HelpDialog_State2:State;
      
      private var _1154751680tencent_help_panel:Canvas;
      
      private var _421888187helpContentText:String;
      
      private var _1855392849bottomRow:ConstraintRow;
      
      private var _162091906helpHeader_wh:Label;
      
      private var _24800538helpSpinnerBackground:Image;
      
      private var _868055995topRow:ConstraintRow;
      
      mx_internal var _watchers:Array = [];
      
      private var _948491687colLeft:ConstraintColumn;
      
      private var _655867780colRight:ConstraintColumn;
      
      private var _758070362helpContinueButton:String;
      
      private var _1588167045windowClose_btn:SoundEffectButton;
      
      private var _1424721680next_btn:SoundEffectButton;
      
      mx_internal var _bindingsBeginWithWord:Object = {};
      
      private var _974194402helpContext_ta:TextArea;
      
      mx_internal var _bindings:Array = [];
      
      private var _1711262760htmlHelpPanel:HTML;
      
      private var _610553411helpController:HelpController;
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({"type":Canvas});
      
      public function HelpDialog()
      {
         super();
         mx_internal::_document = this;
         this.cacheAsBitmap = true;
         this.percentWidth = 100;
         this.percentHeight = 100;
         this.horizontalScrollPolicy = "off";
         this.verticalScrollPolicy = "off";
         this.states = [this._HelpDialog_State1_i(),this._HelpDialog_State2_i()];
         this._HelpDialog_Sequence1_i();
         this.addEventListener("initialize",this.___HelpDialog_Canvas1_initialize);
         this.addEventListener("creationComplete",this.___HelpDialog_Canvas1_creationComplete);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         HelpDialog._watcherSetupUtil = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function get leftGutter() : ConstraintColumn
      {
         return this._1775602690leftGutter;
      }
      
      public function set helpHeader_wh(param1:Label) : void
      {
         var _loc2_:Object = this._162091906helpHeader_wh;
         if(_loc2_ !== param1)
         {
            this._162091906helpHeader_wh = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"helpHeader_wh",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get next_btn() : SoundEffectButton
      {
         return this._1424721680next_btn;
      }
      
      private function _HelpDialog_TextArea1_i() : TextArea
      {
         var _loc1_:TextArea = new TextArea();
         this.helpContext_ta = _loc1_;
         _loc1_.styleName = "helpTextLarge";
         _loc1_.percentHeight = 59;
         _loc1_.verticalScrollPolicy = "auto";
         _loc1_.editable = false;
         _loc1_.setStyle("left","colRight:45");
         _loc1_.addEventListener("link",this.__helpContext_ta_link);
         _loc1_.id = "helpContext_ta";
         BindingManager.executeBindings(this,"helpContext_ta",this.helpContext_ta);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      public function set leftGutter(param1:ConstraintColumn) : void
      {
         var _loc2_:Object = this._1775602690leftGutter;
         if(_loc2_ !== param1)
         {
            this._1775602690leftGutter = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"leftGutter",_loc2_,param1));
         }
      }
      
      private function _HelpDialog_Canvas3_i() : Canvas
      {
         var _loc1_:Canvas = new Canvas();
         this.tencent_help_panel = _loc1_;
         _loc1_.width = 1238;
         _loc1_.height = 638;
         _loc1_.styleName = "blueParchmentTablet";
         _loc1_.setStyle("cornerRadius",5);
         _loc1_.setStyle("borderColor",16777215);
         _loc1_.setStyle("verticalCenter","13");
         _loc1_.setStyle("horizontalCenter","0");
         _loc1_.id = "tencent_help_panel";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         _loc1_.addChild(this._HelpDialog_Image1_i());
         _loc1_.addChild(this._HelpDialog_HTML1_i());
         _loc1_.addChild(this._HelpDialog_SoundEffectButton2_i());
         return _loc1_;
      }
      
      private function _HelpDialog_ConstraintRow4_i() : ConstraintRow
      {
         var _loc1_:ConstraintRow = new ConstraintRow();
         this.bottomGutter = _loc1_;
         _loc1_.height = 100;
         _loc1_.initialized(this,"bottomGutter");
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get helpContext_ta() : TextArea
      {
         return this._974194402helpContext_ta;
      }
      
      private function _HelpDialog_SoundEffectButton1_i() : SoundEffectButton
      {
         var _loc1_:SoundEffectButton = new SoundEffectButton();
         this.next_btn = _loc1_;
         _loc1_.name = "next_btn";
         _loc1_.setStyle("bottom","bottomRow:-20");
         _loc1_.setStyle("right","colRight:30");
         _loc1_.addEventListener("click",this.__next_btn_click);
         _loc1_.id = "next_btn";
         BindingManager.executeBindings(this,"next_btn",this.next_btn);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get bottomGutter() : ConstraintRow
      {
         return this._1911380774bottomGutter;
      }
      
      public function set next_btn(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = this._1424721680next_btn;
         if(_loc2_ !== param1)
         {
            this._1424721680next_btn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"next_btn",_loc2_,param1));
         }
      }
      
      private function _HelpDialog_Fade1_c() : Fade
      {
         var _loc1_:Fade = new Fade();
         _loc1_.duration = 375;
         _loc1_.alphaFrom = 0;
         _loc1_.alphaTo = 1;
         _loc1_.startDelay = 0;
         return _loc1_;
      }
      
      private function onCreationComplete() : void
      {
         if(this.clientConfig.clientMode != ClientConfig.SPECIAL_MODE_TENCENT)
         {
            this.helpController.initializeHelp();
            this.helpContentText = this.helpController.helpTopics[0].content;
            if(this.dialogMode)
            {
               this.helpContinueButton = ResourceManager.getInstance().getString("resources","helpBack_Button");
            }
            else
            {
               this.helpContinueButton = ResourceManager.getInstance().getString("resources","summonerFirstLogin_continue");
            }
            if(this.helpTopics_list != null)
            {
               this.helpTopics_list.selectedIndex = 0;
            }
         }
      }
      
      private function closeOverlay() : void
      {
         if(this.dialogMode)
         {
            this.onClosed.dispatch(this.onClosed);
         }
         else
         {
            this.helpController.saveHelpFlag();
         }
      }
      
      public function set helpContext_ta(param1:TextArea) : void
      {
         var _loc2_:Object = this._974194402helpContext_ta;
         if(_loc2_ !== param1)
         {
            this._974194402helpContext_ta = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"helpContext_ta",_loc2_,param1));
         }
      }
      
      private function _HelpDialog_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         this.helpHeader_wh = _loc1_;
         _loc1_.styleName = "helpTextLarge";
         _loc1_.setStyle("horizontalCenter","0");
         _loc1_.setStyle("top","topRow:0");
         _loc1_.setStyle("fontSize",21);
         _loc1_.id = "helpHeader_wh";
         BindingManager.executeBindings(this,"helpHeader_wh",this.helpHeader_wh);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function onComplete() : void
      {
         if(UserPreferencesManager.globalPrefs.enableAnimations)
         {
            this.fadeIn.play([this.htmlHelpPanel]);
         }
         else
         {
            this.htmlHelpPanel.alpha = 1;
         }
      }
      
      private function _HelpDialog_State2_i() : State
      {
         var _loc1_:State = new State();
         this._HelpDialog_State2 = _loc1_;
         _loc1_.overrides = [this._HelpDialog_AddChild2_c()];
         BindingManager.executeBindings(this,"_HelpDialog_State2",this._HelpDialog_State2);
         return _loc1_;
      }
      
      private function _HelpDialog_Sequence1_i() : Sequence
      {
         var _loc1_:Sequence = new Sequence();
         this.fadeIn = _loc1_;
         _loc1_.children = [this._HelpDialog_SetPropertyAction1_c(),this._HelpDialog_Fade1_c()];
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get topRow() : ConstraintRow
      {
         return this._868055995topRow;
      }
      
      private function _HelpDialog_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():String
         {
            var _loc1_:* = NORMAL_VIEW_STATE;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _HelpDialog_State1.name = param1;
         },"_HelpDialog_State1.name");
         result[0] = binding;
         binding = new Binding(this,function():Object
         {
            return ImagePackLookup.instance.getClassFromSwfRef("e_help_menu");
         },function(param1:Object):void
         {
            _HelpDialog_Canvas2.setStyle("backgroundImage",param1);
         },"_HelpDialog_Canvas2.backgroundImage");
         result[1] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = helpController.helpHeaderText;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            helpHeader_wh.htmlText = param1;
         },"helpHeader_wh.htmlText");
         result[2] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = helpHeader_wh.y + helpHeader_wh.height + 15;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            helpTopics_list.setStyle("top",param1);
         },"helpTopics_list.top");
         result[3] = binding;
         binding = new Binding(this,function():Number
         {
            return colLeft.width;
         },function(param1:Number):void
         {
            helpTopics_list.width = param1;
         },"helpTopics_list.width");
         result[4] = binding;
         binding = new Binding(this,function():Object
         {
            return helpController.helpTopics;
         },function(param1:Object):void
         {
            helpTopics_list.dataProvider = param1;
         },"helpTopics_list.dataProvider");
         result[5] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = helpContentText;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            helpContext_ta.htmlText = param1;
         },"helpContext_ta.htmlText");
         result[6] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = helpHeader_wh.y + helpHeader_wh.height + 15;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            helpContext_ta.setStyle("top",param1);
         },"helpContext_ta.top");
         result[7] = binding;
         binding = new Binding(this,function():Number
         {
            return colRight.width - 60;
         },function(param1:Number):void
         {
            helpContext_ta.width = param1;
         },"helpContext_ta.width");
         result[8] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = helpContinueButton;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            next_btn.label = param1;
         },"next_btn.label");
         result[9] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = TENCENT_VIEW_STATE;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            _HelpDialog_State2.name = param1;
         },"_HelpDialog_State2.name");
         result[10] = binding;
         binding = new Binding(this,function():Object
         {
            return htmlHelpPanel.alpha != 1 ? LOADING_SPINNER : null;
         },function(param1:Object):void
         {
            helpSpinnerBackground.source = param1;
         },"helpSpinnerBackground.source");
         result[11] = binding;
         binding = new Binding(this,function():Boolean
         {
            return htmlHelpPanel.alpha != 1;
         },function(param1:Boolean):void
         {
            helpSpinnerBackground.visible = param1;
         },"helpSpinnerBackground.visible");
         result[12] = binding;
         binding = new Binding(this,function():Number
         {
            return 1 / this.parentApplication.scaleX;
         },function(param1:Number):void
         {
            htmlHelpPanel.scaleX = param1;
         },"htmlHelpPanel.scaleX");
         result[13] = binding;
         binding = new Binding(this,function():Number
         {
            return 1 / this.parentApplication.scaleY;
         },function(param1:Number):void
         {
            htmlHelpPanel.scaleY = param1;
         },"htmlHelpPanel.scaleY");
         result[14] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = clientConfig.helpURL != null ? clientConfig.helpURL : (resourceManager.getString("resources","helpURL") == null ? "about:blank" : resourceManager.getString("resources","helpURL"));
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            htmlHelpPanel.location = param1;
         },"htmlHelpPanel.location");
         result[15] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","errorDialog_closeButtonLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            windowClose_btn.toolTip = param1;
         },"windowClose_btn.toolTip");
         result[16] = binding;
         return result;
      }
      
      private function _HelpDialog_ConstraintColumn1_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.leftGutter = _loc1_;
         _loc1_.width = 102;
         _loc1_.initialized(this,"leftGutter");
         return _loc1_;
      }
      
      public function set bottomGutter(param1:ConstraintRow) : void
      {
         var _loc2_:Object = this._1911380774bottomGutter;
         if(_loc2_ !== param1)
         {
            this._1911380774bottomGutter = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bottomGutter",_loc2_,param1));
         }
      }
      
      private function _HelpDialog_Canvas2_i() : Canvas
      {
         var _loc1_:Canvas = new Canvas();
         this._HelpDialog_Canvas2 = _loc1_;
         _loc1_.cacheAsBitmap = true;
         _loc1_.width = 900;
         _loc1_.height = 550;
         _loc1_.horizontalScrollPolicy = "off";
         _loc1_.verticalScrollPolicy = "off";
         _loc1_.constraintColumns = [this._HelpDialog_ConstraintColumn1_i(),this._HelpDialog_ConstraintColumn2_i(),this._HelpDialog_ConstraintColumn3_i(),this._HelpDialog_ConstraintColumn4_i()];
         _loc1_.constraintRows = [this._HelpDialog_ConstraintRow1_i(),this._HelpDialog_ConstraintRow2_i(),this._HelpDialog_ConstraintRow3_i(),this._HelpDialog_ConstraintRow4_i()];
         _loc1_.setStyle("verticalCenter","0");
         _loc1_.setStyle("horizontalCenter","0");
         _loc1_.id = "_HelpDialog_Canvas2";
         BindingManager.executeBindings(this,"_HelpDialog_Canvas2",this._HelpDialog_Canvas2);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         _loc1_.addChild(this._HelpDialog_Label1_i());
         _loc1_.addChild(this._HelpDialog_List1_i());
         _loc1_.addChild(this._HelpDialog_TextArea1_i());
         _loc1_.addChild(this._HelpDialog_SoundEffectButton1_i());
         return _loc1_;
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
      
      public function set windowClose_btn(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = this._1588167045windowClose_btn;
         if(_loc2_ !== param1)
         {
            this._1588167045windowClose_btn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"windowClose_btn",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get helpContentText() : String
      {
         return this._421888187helpContentText;
      }
      
      [Bindable(event="propertyChange")]
      public function get helpContinueButton() : String
      {
         return this._758070362helpContinueButton;
      }
      
      private function _HelpDialog_ConstraintRow3_i() : ConstraintRow
      {
         var _loc1_:ConstraintRow = new ConstraintRow();
         this.bottomRow = _loc1_;
         _loc1_.percentHeight = 10;
         _loc1_.initialized(this,"bottomRow");
         return _loc1_;
      }
      
      public function set bottomRow(param1:ConstraintRow) : void
      {
         var _loc2_:Object = this._1855392849bottomRow;
         if(_loc2_ !== param1)
         {
            this._1855392849bottomRow = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bottomRow",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get rightGutter() : ConstraintColumn
      {
         return this._753137065rightGutter;
      }
      
      private function _HelpDialog_ClassFactory1_c() : ClassFactory
      {
         var _loc1_:ClassFactory = new ClassFactory();
         _loc1_.generator = GradientRollOverList;
         return _loc1_;
      }
      
      public function __windowClose_btn_click(param1:MouseEvent) : void
      {
         this.closeOverlay();
      }
      
      private function _HelpDialog_ConstraintColumn4_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.rightGutter = _loc1_;
         _loc1_.width = 85;
         _loc1_.initialized(this,"rightGutter");
         return _loc1_;
      }
      
      private function _HelpDialog_Image1_i() : Image
      {
         var _loc1_:Image = new Image();
         this.helpSpinnerBackground = _loc1_;
         _loc1_.setStyle("verticalCenter","0");
         _loc1_.setStyle("horizontalCenter","0");
         _loc1_.id = "helpSpinnerBackground";
         BindingManager.executeBindings(this,"helpSpinnerBackground",this.helpSpinnerBackground);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      public function __next_btn_click(param1:MouseEvent) : void
      {
         this.closeOverlay();
      }
      
      public function cancel() : void
      {
         this.closeOverlay();
      }
      
      [Bindable(event="propertyChange")]
      public function get colRight() : ConstraintColumn
      {
         return this._655867780colRight;
      }
      
      public function set tencent_help_panel(param1:Canvas) : void
      {
         var _loc2_:Object = this._1154751680tencent_help_panel;
         if(_loc2_ !== param1)
         {
            this._1154751680tencent_help_panel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"tencent_help_panel",_loc2_,param1));
         }
      }
      
      private function _HelpDialog_State1_i() : State
      {
         var _loc1_:State = new State();
         this._HelpDialog_State1 = _loc1_;
         _loc1_.overrides = [this._HelpDialog_AddChild1_c()];
         BindingManager.executeBindings(this,"_HelpDialog_State1",this._HelpDialog_State1);
         return _loc1_;
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
      
      private function _HelpDialog_AddChild2_c() : AddChild
      {
         var _loc1_:AddChild = new AddChild();
         _loc1_.targetFactory = new DeferredInstanceFromFunction(this._HelpDialog_Canvas3_i);
         return _loc1_;
      }
      
      public function set topRow(param1:ConstraintRow) : void
      {
         var _loc2_:Object = this._868055995topRow;
         if(_loc2_ !== param1)
         {
            this._868055995topRow = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"topRow",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get windowClose_btn() : SoundEffectButton
      {
         return this._1588167045windowClose_btn;
      }
      
      [Bindable(event="propertyChange")]
      public function get helpHeader_wh() : Label
      {
         return this._162091906helpHeader_wh;
      }
      
      public function set helpController(param1:HelpController) : void
      {
         var _loc2_:Object = this._610553411helpController;
         if(_loc2_ !== param1)
         {
            this._610553411helpController = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"helpController",_loc2_,param1));
         }
      }
      
      public function ___HelpDialog_Canvas1_creationComplete(param1:FlexEvent) : void
      {
         this.onCreationComplete();
      }
      
      private function _HelpDialog_ConstraintRow2_i() : ConstraintRow
      {
         var _loc1_:ConstraintRow = new ConstraintRow();
         this.topRow = _loc1_;
         _loc1_.percentHeight = 90;
         _loc1_.initialized(this,"topRow");
         return _loc1_;
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:HelpDialog = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._HelpDialog_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_help_HelpDialogWatcherSetupUtil");
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
      
      public function set helpContentText(param1:String) : void
      {
         var _loc2_:Object = this._421888187helpContentText;
         if(_loc2_ !== param1)
         {
            this._421888187helpContentText = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"helpContentText",_loc2_,param1));
         }
      }
      
      public function __helpContext_ta_link(param1:TextEvent) : void
      {
         this.linkHandler(param1);
      }
      
      private function _HelpDialog_SetPropertyAction1_c() : SetPropertyAction
      {
         var _loc1_:SetPropertyAction = new SetPropertyAction();
         _loc1_.name = "alpha";
         _loc1_.value = 0;
         return _loc1_;
      }
      
      public function getOnClosed() : ISignal
      {
         return this.onClosed;
      }
      
      public function __htmlHelpPanel_complete(param1:Event) : void
      {
         this.onComplete();
      }
      
      public function ___HelpDialog_Canvas1_initialize(param1:FlexEvent) : void
      {
         this.onInitialize();
      }
      
      [Bindable(event="propertyChange")]
      public function get bottomRow() : ConstraintRow
      {
         return this._1855392849bottomRow;
      }
      
      private function _HelpDialog_ConstraintColumn3_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.colRight = _loc1_;
         _loc1_.percentWidth = 76;
         _loc1_.initialized(this,"colRight");
         return _loc1_;
      }
      
      public function set helpContinueButton(param1:String) : void
      {
         var _loc2_:Object = this._758070362helpContinueButton;
         if(_loc2_ !== param1)
         {
            this._758070362helpContinueButton = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"helpContinueButton",_loc2_,param1));
         }
      }
      
      public function set rightGutter(param1:ConstraintColumn) : void
      {
         var _loc2_:Object = this._753137065rightGutter;
         if(_loc2_ !== param1)
         {
            this._753137065rightGutter = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rightGutter",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get colLeft() : ConstraintColumn
      {
         return this._948491687colLeft;
      }
      
      public function set helpTopics_list(param1:List) : void
      {
         var _loc2_:Object = this._428154072helpTopics_list;
         if(_loc2_ !== param1)
         {
            this._428154072helpTopics_list = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"helpTopics_list",_loc2_,param1));
         }
      }
      
      public function set topGutter(param1:ConstraintRow) : void
      {
         var _loc2_:Object = this._567412016topGutter;
         if(_loc2_ !== param1)
         {
            this._567412016topGutter = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"topGutter",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get helpController() : HelpController
      {
         return this._610553411helpController;
      }
      
      public function set htmlHelpPanel(param1:HTML) : void
      {
         var _loc2_:Object = this._1711262760htmlHelpPanel;
         if(_loc2_ !== param1)
         {
            this._1711262760htmlHelpPanel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"htmlHelpPanel",_loc2_,param1));
         }
      }
      
      private function _HelpDialog_HTML1_i() : HTML
      {
         var _loc1_:HTML = new HTML();
         this.htmlHelpPanel = _loc1_;
         _loc1_.alpha = 0;
         _loc1_.verticalScrollPolicy = "off";
         _loc1_.horizontalScrollPolicy = "off";
         _loc1_.setStyle("bottom","0");
         _loc1_.setStyle("top","0");
         _loc1_.setStyle("left","0");
         _loc1_.setStyle("right","0");
         _loc1_.setStyle("backgroundAlpha",1);
         _loc1_.setStyle("backgroundColor",0);
         _loc1_.addEventListener("complete",this.__htmlHelpPanel_complete);
         _loc1_.id = "htmlHelpPanel";
         BindingManager.executeBindings(this,"htmlHelpPanel",this.htmlHelpPanel);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get fadeIn() : Sequence
      {
         return this._1282133823fadeIn;
      }
      
      private function _HelpDialog_List1_i() : List
      {
         var _loc1_:List = new List();
         this.helpTopics_list = _loc1_;
         _loc1_.styleName = "helpTopicList";
         _loc1_.percentHeight = 61;
         _loc1_.itemRenderer = this._HelpDialog_ClassFactory1_c();
         _loc1_.rowHeight = 20;
         _loc1_.selectedIndex = 0;
         _loc1_.setStyle("left","colLeft:-5");
         _loc1_.addEventListener("change",this.__helpTopics_list_change);
         _loc1_.id = "helpTopics_list";
         BindingManager.executeBindings(this,"helpTopics_list",this.helpTopics_list);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get tencent_help_panel() : Canvas
      {
         return this._1154751680tencent_help_panel;
      }
      
      private function _HelpDialog_AddChild1_c() : AddChild
      {
         var _loc1_:AddChild = new AddChild();
         _loc1_.targetFactory = new DeferredInstanceFromFunction(this._HelpDialog_Canvas2_i);
         return _loc1_;
      }
      
      private function onInitialize() : void
      {
         if(this.clientConfig.clientMode == ClientConfig.SPECIAL_MODE_TENCENT)
         {
            this.currentState = TENCENT_VIEW_STATE;
         }
         else
         {
            this.currentState = NORMAL_VIEW_STATE;
         }
      }
      
      private function _HelpDialog_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = NORMAL_VIEW_STATE;
         _loc1_ = ImagePackLookup.instance.getClassFromSwfRef("e_help_menu");
         _loc1_ = this.helpController.helpHeaderText;
         _loc1_ = this.helpHeader_wh.y + this.helpHeader_wh.height + 15;
         _loc1_ = this.colLeft.width;
         _loc1_ = this.helpController.helpTopics;
         _loc1_ = this.helpContentText;
         _loc1_ = this.helpHeader_wh.y + this.helpHeader_wh.height + 15;
         _loc1_ = this.colRight.width - 60;
         _loc1_ = this.helpContinueButton;
         _loc1_ = TENCENT_VIEW_STATE;
         _loc1_ = this.htmlHelpPanel.alpha != 1 ? LOADING_SPINNER : null;
         _loc1_ = this.htmlHelpPanel.alpha != 1;
         _loc1_ = 1 / this.parentApplication.scaleX;
         _loc1_ = 1 / this.parentApplication.scaleY;
         _loc1_ = this.clientConfig.helpURL != null ? this.clientConfig.helpURL : (resourceManager.getString("resources","helpURL") == null ? "about:blank" : resourceManager.getString("resources","helpURL"));
         _loc1_ = resourceManager.getString("resources","errorDialog_closeButtonLabel");
      }
      
      private function _HelpDialog_ConstraintRow1_i() : ConstraintRow
      {
         var _loc1_:ConstraintRow = new ConstraintRow();
         this.topGutter = _loc1_;
         _loc1_.height = 65;
         _loc1_.initialized(this,"topGutter");
         return _loc1_;
      }
      
      public function __helpTopics_list_change(param1:ListEvent) : void
      {
         this.onHelpTopicChange(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get helpTopics_list() : List
      {
         return this._428154072helpTopics_list;
      }
      
      public function set helpSpinnerBackground(param1:Image) : void
      {
         var _loc2_:Object = this._24800538helpSpinnerBackground;
         if(_loc2_ !== param1)
         {
            this._24800538helpSpinnerBackground = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"helpSpinnerBackground",_loc2_,param1));
         }
      }
      
      private function _HelpDialog_SoundEffectButton2_i() : SoundEffectButton
      {
         var _loc1_:SoundEffectButton = new SoundEffectButton();
         this.windowClose_btn = _loc1_;
         _loc1_.styleName = "chooseGameExitButton";
         _loc1_.buttonMode = true;
         _loc1_.useHandCursor = true;
         _loc1_.setStyle("right","10");
         _loc1_.setStyle("top","10");
         _loc1_.addEventListener("click",this.__windowClose_btn_click);
         _loc1_.id = "windowClose_btn";
         BindingManager.executeBindings(this,"windowClose_btn",this.windowClose_btn);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function onHelpTopicChange(param1:ListEvent) : void
      {
         var _loc2_:Object = List(param1.target).selectedItem;
         this.helpContentText = _loc2_.content;
         this.helpContext_ta.setSelection(0,1);
      }
      
      [Bindable(event="propertyChange")]
      public function get htmlHelpPanel() : HTML
      {
         return this._1711262760htmlHelpPanel;
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
      
      private function _HelpDialog_ConstraintColumn2_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         this.colLeft = _loc1_;
         _loc1_.percentWidth = 24;
         _loc1_.initialized(this,"colLeft");
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get helpSpinnerBackground() : Image
      {
         return this._24800538helpSpinnerBackground;
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
      private function get clientConfig() : ClientConfig
      {
         return this._1895424275clientConfig;
      }
      
      [Bindable(event="propertyChange")]
      public function get topGutter() : ConstraintRow
      {
         return this._567412016topGutter;
      }
      
      public function linkHandler(param1:TextEvent) : void
      {
         this.closeOverlay();
      }
   }
}

