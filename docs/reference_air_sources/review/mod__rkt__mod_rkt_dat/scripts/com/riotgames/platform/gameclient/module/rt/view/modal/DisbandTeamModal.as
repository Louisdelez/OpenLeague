package com.riotgames.platform.gameclient.module.rt.view.modal
{
   import com.riotgames.platform.common.components.MessagePopupTemplate;
   import com.riotgames.platform.common.components.controls.TextInput;
   import com.riotgames.platform.gameclient.components.button.SoundEffectButton;
   import com.riotgames.platform.gameclient.module.rt.resource.RTResource;
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
   import mx.containers.VBox;
   import mx.controls.Text;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.managers.PopUpManager;
   import mx.resources.ResourceManager;
   import mx.styles.*;
   
   public class DisbandTeamModal extends MessagePopupTemplate implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private var _1484699079disbandInput:TextInput;
      
      private var _911992679messageBodyTxt:Text;
      
      public var _DisbandTeamModal_VBox1:VBox;
      
      private var _1668760952teamName:String;
      
      private var _205980803btnLeft:SoundEffectButton;
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({"type":MessagePopupTemplate});
      
      private var _2096098592btnRight:SoundEffectButton;
      
      public var callbackSuccess:Function = null;
      
      public function DisbandTeamModal()
      {
         super();
         mx_internal::_document = this;
         this.useCustomStyles = true;
         this.contentRow = this._DisbandTeamModal_VBox1_i();
         this.buttonRow = [this._DisbandTeamModal_SoundEffectButton1_i(),this._DisbandTeamModal_SoundEffectButton2_i()];
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         DisbandTeamModal._watcherSetupUtil = param1;
      }
      
      public function set btnRight(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = this._2096098592btnRight;
         if(_loc2_ !== param1)
         {
            this._2096098592btnRight = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"btnRight",_loc2_,param1));
         }
      }
      
      private function _DisbandTeamModal_SoundEffectButton1_i() : SoundEffectButton
      {
         var _loc1_:SoundEffectButton = new SoundEffectButton();
         this.btnLeft = _loc1_;
         _loc1_.styleName = "s1FormButton";
         _loc1_.buttonMode = true;
         _loc1_.addEventListener("click",this.__btnLeft_click);
         _loc1_.id = "btnLeft";
         BindingManager.executeBindings(this,"btnLeft",this.btnLeft);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      public function __btnLeft_click(param1:MouseEvent) : void
      {
         this.onLeftBtnClicked(param1);
      }
      
      public function set btnLeft(param1:SoundEffectButton) : void
      {
         var _loc2_:Object = this._205980803btnLeft;
         if(_loc2_ !== param1)
         {
            this._205980803btnLeft = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"btnLeft",_loc2_,param1));
         }
      }
      
      private function onRightBtnClicked(param1:Event) : void
      {
         if(this.callbackSuccess != null)
         {
            this.callbackSuccess();
         }
         this.close();
      }
      
      private function onTextInputCreated() : void
      {
         this.disbandInput.setFocus();
      }
      
      private function _DisbandTeamModal_SoundEffectButton2_i() : SoundEffectButton
      {
         var _loc1_:SoundEffectButton = new SoundEffectButton();
         this.btnRight = _loc1_;
         _loc1_.styleName = "smallButtonOrange";
         _loc1_.buttonMode = true;
         _loc1_.enabled = false;
         _loc1_.addEventListener("click",this.__btnRight_click);
         _loc1_.id = "btnRight";
         BindingManager.executeBindings(this,"btnRight",this.btnRight);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      public function __disbandInput_change(param1:Event) : void
      {
         this.onTextInputchanged();
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:DisbandTeamModal = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._DisbandTeamModal_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_module_rt_view_modal_DisbandTeamModalWatcherSetupUtil");
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
      
      private function onLeftBtnClicked(param1:Event) : void
      {
         this.close();
      }
      
      public function set disbandInput(param1:TextInput) : void
      {
         var _loc2_:Object = this._1484699079disbandInput;
         if(_loc2_ !== param1)
         {
            this._1484699079disbandInput = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"disbandInput",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get disbandInput() : TextInput
      {
         return this._1484699079disbandInput;
      }
      
      private function _DisbandTeamModal_TextInput1_i() : TextInput
      {
         var _loc1_:TextInput = new TextInput();
         this.disbandInput = _loc1_;
         _loc1_.width = 250;
         _loc1_.styleName = "standard";
         _loc1_.setStyle("horizontalCenter","0");
         _loc1_.setStyle("bottom","0");
         _loc1_.addEventListener("creationComplete",this.__disbandInput_creationComplete);
         _loc1_.addEventListener("change",this.__disbandInput_change);
         _loc1_.id = "disbandInput";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _DisbandTeamModal_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = RTResource.getString("disbandTeam");
         _loc1_ = this.width * 0.8;
         _loc1_ = this.width * 0.8;
         _loc1_ = RTResource.getString("disbandInstructionsText",[this.teamName,RTResource.getString("disbandRequiredInput")]);
         _loc1_ = ResourceManager.getInstance().getString("resources","common_button_cancel");
         _loc1_ = RTResource.getString("disbandButtonLabel");
      }
      
      [Bindable(event="propertyChange")]
      public function get btnLeft() : SoundEffectButton
      {
         return this._205980803btnLeft;
      }
      
      private function _DisbandTeamModal_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RTResource.getString("disbandTeam");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            this.headerText = param1;
         },"this.headerText");
         result[0] = binding;
         binding = new Binding(this,function():Number
         {
            return this.width * 0.8;
         },function(param1:Number):void
         {
            _DisbandTeamModal_VBox1.width = param1;
         },"_DisbandTeamModal_VBox1.width");
         result[1] = binding;
         binding = new Binding(this,function():Number
         {
            return this.width * 0.8;
         },function(param1:Number):void
         {
            messageBodyTxt.width = param1;
         },"messageBodyTxt.width");
         result[2] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RTResource.getString("disbandInstructionsText",[this.teamName,RTResource.getString("disbandRequiredInput")]);
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            messageBodyTxt.htmlText = param1;
         },"messageBodyTxt.htmlText");
         result[3] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = ResourceManager.getInstance().getString("resources","common_button_cancel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            btnLeft.label = param1;
         },"btnLeft.label");
         result[4] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = RTResource.getString("disbandButtonLabel");
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            btnRight.label = param1;
         },"btnRight.label");
         result[5] = binding;
         return result;
      }
      
      public function set messageBodyTxt(param1:Text) : void
      {
         var _loc2_:Object = this._911992679messageBodyTxt;
         if(_loc2_ !== param1)
         {
            this._911992679messageBodyTxt = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"messageBodyTxt",_loc2_,param1));
         }
      }
      
      public function __disbandInput_creationComplete(param1:FlexEvent) : void
      {
         this.onTextInputCreated();
      }
      
      [Bindable(event="propertyChange")]
      public function get btnRight() : SoundEffectButton
      {
         return this._2096098592btnRight;
      }
      
      [Bindable(event="propertyChange")]
      public function get messageBodyTxt() : Text
      {
         return this._911992679messageBodyTxt;
      }
      
      public function set teamName(param1:String) : void
      {
         var _loc2_:Object = this._1668760952teamName;
         if(_loc2_ !== param1)
         {
            this._1668760952teamName = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"teamName",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get teamName() : String
      {
         return this._1668760952teamName;
      }
      
      public function __btnRight_click(param1:MouseEvent) : void
      {
         this.onRightBtnClicked(param1);
      }
      
      private function _DisbandTeamModal_VBox1_i() : VBox
      {
         var _loc1_:VBox = new VBox();
         this._DisbandTeamModal_VBox1 = _loc1_;
         _loc1_.setStyle("top","-10");
         _loc1_.setStyle("left","10");
         _loc1_.setStyle("verticalGap",12);
         _loc1_.setStyle("horizontalAlign","center");
         _loc1_.id = "_DisbandTeamModal_VBox1";
         BindingManager.executeBindings(this,"_DisbandTeamModal_VBox1",this._DisbandTeamModal_VBox1);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         _loc1_.addChild(this._DisbandTeamModal_Text1_i());
         _loc1_.addChild(this._DisbandTeamModal_TextInput1_i());
         return _loc1_;
      }
      
      private function close() : void
      {
         PopUpManager.removePopUp(this);
      }
      
      private function _DisbandTeamModal_Text1_i() : Text
      {
         var _loc1_:Text = new Text();
         this.messageBodyTxt = _loc1_;
         _loc1_.styleName = "popupMessageBody";
         _loc1_.selectable = false;
         _loc1_.id = "messageBodyTxt";
         BindingManager.executeBindings(this,"messageBodyTxt",this.messageBodyTxt);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function onTextInputchanged() : void
      {
         if(!this.disbandInput || !this.btnRight)
         {
            return;
         }
         this.btnRight.enabled = this.disbandInput.text == RTResource.getString("disbandRequiredInput");
      }
   }
}

