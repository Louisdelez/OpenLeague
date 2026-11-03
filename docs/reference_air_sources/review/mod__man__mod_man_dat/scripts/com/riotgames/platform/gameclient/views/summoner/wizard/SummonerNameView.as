package com.riotgames.platform.gameclient.views.summoner.wizard
{
   import com.riotgames.platform.common.AppConfig;
   import com.riotgames.platform.common.components.MessagePopupTemplate;
   import com.riotgames.platform.common.components.controls.TextInput;
   import com.riotgames.platform.gameclient.components.button.SoundEffectButton;
   import com.riotgames.platform.gameclient.utils.AnimationHelper;
   import com.riotgames.pvpnet.accountcreation.model.SummonerNameModel;
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
   import mx.controls.TextArea;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.managers.CursorManager;
   import mx.styles.*;
   
   use namespace mx_internal;
   
   public class SummonerNameView extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private static const NAME_INVALIATION_SUBMIT_COOLDOWN:int = 750;
      
      private var _734251455rootContainer:MessagePopupTemplate;
      
      mx_internal var _watchers:Array = [];
      
      private var _245624368createDefaultSummoner_btn:SoundEffectButton;
      
      private var lastNameInvalidationTime:Number = 0;
      
      public var summonerNameModel:SummonerNameModel;
      
      mx_internal var _bindingsByDestination:Object = {};
      
      private var _872769992message_txt:TextArea;
      
      mx_internal var _bindingsBeginWithWord:Object = {};
      
      private var _1025128577summonerName_txti:TextInput;
      
      private var _1180619197isBusy:Boolean = false;
      
      mx_internal var _bindings:Array = [];
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({
         "type":Canvas,
         "propertiesFactory":function():Object
         {
            return {"childDescriptors":[new UIComponentDescriptor({
               "type":MessagePopupTemplate,
               "id":"rootContainer",
               "stylesFactory":function():void
               {
                  this.horizontalCenter = "0";
                  this.verticalCenter = "-10";
               },
               "propertiesFactory":function():Object
               {
                  return {
                     "cacheAsBitmap":true,
                     "width":550,
                     "height":440,
                     "contentRow":_SummonerNameView_VBox1_c(),
                     "buttonRow":[_SummonerNameView_SoundEffectButton1_i()]
                  };
               }
            })]};
         }
      });
      
      public function SummonerNameView()
      {
         super();
         mx_internal::_document = this;
         this.cacheAsBitmap = true;
         this.percentWidth = 100;
         this.percentHeight = 100;
         this.addEventListener("initialize",this.___SummonerNameView_Canvas1_initialize);
         this.addEventListener("show",this.___SummonerNameView_Canvas1_show);
         this.addEventListener("hide",this.___SummonerNameView_Canvas1_hide);
         this.addEventListener("keyDown",this.___SummonerNameView_Canvas1_keyDown);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         SummonerNameView._watcherSetupUtil = param1;
      }
      
      public function set summonerName_txti(param1:TextInput) : void
      {
         var _loc2_:Object = this._1025128577summonerName_txti;
         if(_loc2_ !== param1)
         {
            this._1025128577summonerName_txti = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"summonerName_txti",_loc2_,param1));
         }
      }
      
      public function set isBusy(param1:Boolean) : void
      {
         var _loc2_:Object = this._1180619197isBusy;
         if(_loc2_ !== param1)
         {
            this._1180619197isBusy = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"isBusy",_loc2_,param1));
         }
      }
      
      private function validateNameLength() : void
      {
         var _loc4_:String = null;
         var _loc5_:Number = NaN;
         var _loc6_:Boolean = false;
         var _loc7_:Boolean = false;
         var _loc1_:int = 0;
         var _loc2_:String = this.summonerName_txti.text;
         var _loc3_:int = 0;
         while(_loc3_ < _loc2_.length)
         {
            _loc4_ = _loc2_.charAt(_loc3_);
            _loc5_ = _loc4_.charCodeAt(0);
            _loc6_ = _loc5_ >= 1024 && _loc5_ <= 1279 || _loc5_ >= 1280 && _loc5_ <= 1327 || _loc5_ >= 11744 && _loc5_ <= 11775 || _loc5_ >= 42560 && _loc5_ <= 42655 || _loc5_ == 7467 && _loc5_ == 7544;
            _loc7_ = _loc4_.match(/[^\s\w\-\.\[\]=$&{}\xc0-\xff]/) != null;
            if(!_loc6_ && _loc7_)
            {
               _loc1_++;
            }
            _loc3_++;
         }
         this.summonerName_txti.maxChars = 16 - _loc1_;
         if(this.summonerName_txti.text.length > this.summonerName_txti.maxChars)
         {
            this.summonerName_txti.text = this.summonerName_txti.text.substr(0,this.summonerName_txti.text.length - 1);
            this.validateNameLength();
            this.lastNameInvalidationTime = getTimer();
         }
      }
      
      private function onNameYourSummonerButtonClicked(param1:MouseEvent) : void
      {
         this.validateNameLength();
         var _loc2_:Number = getTimer();
         if(_loc2_ - this.lastNameInvalidationTime < NAME_INVALIATION_SUBMIT_COOLDOWN)
         {
            return;
         }
         this.isBusy = true;
         CursorManager.getInstance().setBusyCursor();
         this.summonerNameModel.getSummonerRenamed().removeAll();
         this.summonerNameModel.getSummonerRenamed().add(this.onSummonerRenamed);
         this.summonerNameModel.newSummonerName = this.summonerName_txti.text;
         this.checkEnableButtonConditionMet(null);
      }
      
      private function _SummonerNameView_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","summoner_wizard_nameYourSummonerTitle");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            rootContainer.headerText = param1;
         },"rootContainer.headerText");
         result[0] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","summoner_wizard_nameYourSummonerMessage");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            message_txt.htmlText = param1;
         },"message_txt.htmlText");
         result[1] = binding;
         binding = new Binding(this,function():Boolean
         {
            return !isBusy;
         },function(param1:Boolean):void
         {
            summonerName_txti.enabled = param1;
         },"summonerName_txti.enabled");
         result[2] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = resourceManager.getString("resources","summoner_wizard_nameYourSummonerButtonLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            createDefaultSummoner_btn.label = param1;
         },"createDefaultSummoner_btn.label");
         result[3] = binding;
         return result;
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:SummonerNameView = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._SummonerNameView_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_views_summoner_wizard_SummonerNameViewWatcherSetupUtil");
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
      
      private function _SummonerNameView_VBox1_c() : VBox
      {
         var _loc1_:VBox = new VBox();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.setStyle("top","20");
         _loc1_.setStyle("horizontalAlign","center");
         _loc1_.setStyle("verticalGap",0);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         _loc1_.addChild(this._SummonerNameView_TextArea1_i());
         _loc1_.addChild(this._SummonerNameView_TextInput1_i());
         return _loc1_;
      }
      
      private function _SummonerNameView_TextInput1_i() : TextInput
      {
         var _loc1_:TextInput = new TextInput();
         this.summonerName_txti = _loc1_;
         _loc1_.styleName = "standard";
         _loc1_.width = 308;
         _loc1_.height = 31;
         _loc1_.maxChars = 16;
         _loc1_.setStyle("color",0);
         _loc1_.setStyle("backgroundColor",16777215);
         _loc1_.addEventListener("change",this.__summonerName_txti_change);
         _loc1_.addEventListener("creationComplete",this.__summonerName_txti_creationComplete);
         _loc1_.id = "summonerName_txti";
         BindingManager.executeBindings(this,"summonerName_txti",this.summonerName_txti);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function checkEnableButtonConditionMet(param1:Event) : void
      {
         if(!this.isBusy && this.summonerName_txti.text.length >= 3)
         {
            this.createDefaultSummoner_btn.enabled = true;
         }
         else
         {
            this.createDefaultSummoner_btn.enabled = false;
         }
      }
      
      public function ___SummonerNameView_Canvas1_hide(param1:FlexEvent) : void
      {
         AnimationHelper.playFadeOutEffect(this);
      }
      
      private function _SummonerNameView_SoundEffectButton1_i() : SoundEffectButton
      {
         var _loc1_:SoundEffectButton = new SoundEffectButton();
         this.createDefaultSummoner_btn = _loc1_;
         _loc1_.styleName = "s1FormButton";
         _loc1_.buttonMode = true;
         _loc1_.enabled = false;
         _loc1_.addEventListener("click",this.__createDefaultSummoner_btn_click);
         _loc1_.id = "createDefaultSummoner_btn";
         BindingManager.executeBindings(this,"createDefaultSummoner_btn",this.createDefaultSummoner_btn);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _SummonerNameView_TextArea1_i() : TextArea
      {
         var _loc1_:TextArea = new TextArea();
         this.message_txt = _loc1_;
         _loc1_.width = 450;
         _loc1_.height = 235;
         _loc1_.styleName = "s1FormMessage";
         _loc1_.selectable = false;
         _loc1_.mouseEnabled = false;
         _loc1_.mouseChildren = false;
         _loc1_.editable = false;
         _loc1_.setStyle("horizontalCenter","0");
         _loc1_.setStyle("textAlign","left");
         _loc1_.setStyle("fontSize",16);
         _loc1_.id = "message_txt";
         BindingManager.executeBindings(this,"message_txt",this.message_txt);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get createDefaultSummoner_btn() : SoundEffectButton
      {
         return this._245624368createDefaultSummoner_btn;
      }
      
      [Bindable(event="propertyChange")]
      public function get message_txt() : TextArea
      {
         return this._872769992message_txt;
      }
      
      public function ___SummonerNameView_Canvas1_keyDown(param1:KeyboardEvent) : void
      {
         this.onKeyDown(param1);
      }
      
      [Bindable(event="propertyChange")]
      public function get rootContainer() : MessagePopupTemplate
      {
         return this._734251455rootContainer;
      }
      
      private function onKeyDown(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ENTER && Boolean(this.createDefaultSummoner_btn.enabled) && !this.summonerNameModel.errorAlertShown)
         {
            this.createDefaultSummoner_btn.dispatchEvent(new MouseEvent(MouseEvent.CLICK));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get isBusy() : Boolean
      {
         return this._1180619197isBusy;
      }
      
      private function summonerNameTextCreated() : void
      {
         this.callLater(this.summonerName_txti.setFocus);
         this.summonerName_txti.addEventListener(Event.CHANGE,this.checkEnableButtonConditionMet);
      }
      
      private function onInitialize() : void
      {
         AppConfig.instance.isNavigatorVisible = false;
      }
      
      public function __summonerName_txti_change(param1:Event) : void
      {
         this.onNameFieldTextInput();
      }
      
      public function __summonerName_txti_creationComplete(param1:FlexEvent) : void
      {
         this.summonerNameTextCreated();
      }
      
      private function onSummonerRenamed() : void
      {
         this.isBusy = false;
         CursorManager.getInstance().removeBusyCursor();
      }
      
      private function _SummonerNameView_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = resourceManager.getString("resources","summoner_wizard_nameYourSummonerTitle");
         _loc1_ = resourceManager.getString("resources","summoner_wizard_nameYourSummonerMessage");
         _loc1_ = !this.isBusy;
         _loc1_ = resourceManager.getString("resources","summoner_wizard_nameYourSummonerButtonLabel");
      }
      
      public function ___SummonerNameView_Canvas1_show(param1:FlexEvent) : void
      {
         AnimationHelper.playFadeInEffect(this);
      }
      
      public function __createDefaultSummoner_btn_click(param1:MouseEvent) : void
      {
         this.onNameYourSummonerButtonClicked(param1);
      }
      
      private function onNameFieldTextInput() : void
      {
         this.validateNameLength();
      }
      
      public function set createDefaultSummoner_btn(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = this._245624368createDefaultSummoner_btn;
         if(_loc2_ !== param1)
         {
            this._245624368createDefaultSummoner_btn = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"createDefaultSummoner_btn",_loc2_,param1));
         }
      }
      
      public function set message_txt(param1:TextArea) : void
      {
         var _loc2_:Object = this._872769992message_txt;
         if(_loc2_ !== param1)
         {
            this._872769992message_txt = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"message_txt",_loc2_,param1));
         }
      }
      
      public function ___SummonerNameView_Canvas1_initialize(param1:FlexEvent) : void
      {
         this.onInitialize();
      }
      
      public function set rootContainer(param1:MessagePopupTemplate) : void
      {
         var _loc2_:Object = this._734251455rootContainer;
         if(_loc2_ !== param1)
         {
            this._734251455rootContainer = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rootContainer",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get summonerName_txti() : TextInput
      {
         return this._1025128577summonerName_txti;
      }
   }
}

