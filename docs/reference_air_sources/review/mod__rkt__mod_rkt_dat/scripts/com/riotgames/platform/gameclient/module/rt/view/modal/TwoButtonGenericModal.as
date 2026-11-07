package com.riotgames.platform.gameclient.module.rt.view.modal
{
   import com.riotgames.platform.common.components.MessagePopupTemplate;
   import com.riotgames.platform.gameclient.components.button.SoundEffectButton;
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
   import mx.controls.Text;
   import mx.core.UIComponentDescriptor;
   import mx.core.mx_internal;
   import mx.events.PropertyChangeEvent;
   import mx.managers.PopUpManager;
   import mx.styles.*;
   
   public class TwoButtonGenericModal extends MessagePopupTemplate implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private var _911992679messageBodyTxt:Text;
      
      private var _458736106parameters:TwoButtonGenericModalData;
      
      private var _205980803btnLeft:SoundEffectButton;
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({"type":MessagePopupTemplate});
      
      private var _2096098592btnRight:SoundEffectButton;
      
      public function TwoButtonGenericModal()
      {
         super();
         mx_internal::_document = this;
         this.useCustomStyles = true;
         this.contentRow = this._TwoButtonGenericModal_Text1_i();
         this.buttonRow = [this._TwoButtonGenericModal_SoundEffectButton1_i(),this._TwoButtonGenericModal_SoundEffectButton2_i()];
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         TwoButtonGenericModal._watcherSetupUtil = param1;
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
      
      [Bindable(event="propertyChange")]
      public function get btnLeft() : SoundEffectButton
      {
         return this._205980803btnLeft;
      }
      
      private function _TwoButtonGenericModal_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.parameters.title;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            this.headerText = param1;
         },"this.headerText");
         result[0] = binding;
         binding = new Binding(this,function():Number
         {
            return this.width * 0.7;
         },function(param1:Number):void
         {
            messageBodyTxt.width = param1;
         },"messageBodyTxt.width");
         result[1] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.parameters.message;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            messageBodyTxt.htmlText = param1;
         },"messageBodyTxt.htmlText");
         result[2] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.parameters.leftButtonLabel;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            btnLeft.label = param1;
         },"btnLeft.label");
         result[3] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.parameters.leftButtonLabel != "";
         },function(param1:Boolean):void
         {
            btnLeft.visible = param1;
         },"btnLeft.visible");
         result[4] = binding;
         binding = new Binding(this,function():String
         {
            var _loc1_:* = this.parameters.rightButtonLabel;
            return _loc1_ == undefined ? null : String(_loc1_);
         },function(param1:String):void
         {
            btnRight.label = param1;
         },"btnRight.label");
         result[5] = binding;
         binding = new Binding(this,function():Boolean
         {
            return this.parameters.rightButtonLabel != "";
         },function(param1:Boolean):void
         {
            btnRight.visible = param1;
         },"btnRight.visible");
         result[6] = binding;
         return result;
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
         if(this.parameters != null && this.parameters.rightButtonCallback != null)
         {
            if(this.parameters.callbackProperty != null)
            {
               this.parameters.rightButtonCallback(this.parameters.callbackProperty);
            }
            else
            {
               this.parameters.rightButtonCallback();
            }
         }
         this.close();
      }
      
      public function __btnRight_click(param1:MouseEvent) : void
      {
         this.onRightBtnClicked(param1);
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:TwoButtonGenericModal = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._TwoButtonGenericModal_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_module_rt_view_modal_TwoButtonGenericModalWatcherSetupUtil");
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
         if(this.parameters != null && this.parameters.leftButtonCallback != null)
         {
            if(this.parameters.callbackProperty != null)
            {
               this.parameters.leftButtonCallback(this.parameters.callbackProperty);
            }
            else
            {
               this.parameters.leftButtonCallback();
            }
         }
         this.close();
      }
      
      public function set parameters(param1:TwoButtonGenericModalData) : void
      {
         var _loc2_:Object = this._458736106parameters;
         if(_loc2_ !== param1)
         {
            this._458736106parameters = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"parameters",_loc2_,param1));
         }
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
      
      [Bindable(event="propertyChange")]
      public function get btnRight() : SoundEffectButton
      {
         return this._2096098592btnRight;
      }
      
      private function _TwoButtonGenericModal_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.parameters.title;
         _loc1_ = this.width * 0.7;
         _loc1_ = this.parameters.message;
         _loc1_ = this.parameters.leftButtonLabel;
         _loc1_ = this.parameters.leftButtonLabel != "";
         _loc1_ = this.parameters.rightButtonLabel;
         _loc1_ = this.parameters.rightButtonLabel != "";
      }
      
      private function _TwoButtonGenericModal_Text1_i() : Text
      {
         var _loc1_:Text = new Text();
         this.messageBodyTxt = _loc1_;
         _loc1_.styleName = "popupMessageBody";
         _loc1_.percentHeight = 70;
         _loc1_.selectable = false;
         _loc1_.setStyle("paddingLeft",10);
         _loc1_.setStyle("paddingRight",10);
         _loc1_.id = "messageBodyTxt";
         BindingManager.executeBindings(this,"messageBodyTxt",this.messageBodyTxt);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get messageBodyTxt() : Text
      {
         return this._911992679messageBodyTxt;
      }
      
      [Bindable(event="propertyChange")]
      public function get parameters() : TwoButtonGenericModalData
      {
         return this._458736106parameters;
      }
      
      private function _TwoButtonGenericModal_SoundEffectButton2_i() : SoundEffectButton
      {
         var _loc1_:SoundEffectButton = new SoundEffectButton();
         this.btnRight = _loc1_;
         _loc1_.styleName = "smallButtonOrange";
         _loc1_.buttonMode = true;
         _loc1_.addEventListener("click",this.__btnRight_click);
         _loc1_.id = "btnRight";
         BindingManager.executeBindings(this,"btnRight",this.btnRight);
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function close() : void
      {
         PopUpManager.removePopUp(this);
      }
      
      private function _TwoButtonGenericModal_SoundEffectButton1_i() : SoundEffectButton
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
   }
}

