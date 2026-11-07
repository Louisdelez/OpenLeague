package com.riotgames.platform.gameclient.skin
{
   import com.riotgames.platform.common.effect.darronschall.effects.AnimateColor;
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
   import mx.controls.Button;
   import mx.core.UIComponentDescriptor;
   import mx.core.UITextField;
   import mx.core.mx_internal;
   import mx.events.FlexEvent;
   import mx.events.PropertyChangeEvent;
   import mx.states.SetProperty;
   import mx.states.State;
   import mx.states.Transition;
   import mx.styles.*;
   
   public class ButtonSkin extends Canvas implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil;
      
      private var _762020804bevelDown:BevelFilter;
      
      private var _documentDescriptor_:UIComponentDescriptor = new UIComponentDescriptor({"type":Canvas});
      
      private var _3175821glow:GlowFilter;
      
      private var _93630586bevel:BevelFilter;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _watchers:Array = [];
      
      private var _3565174toUp:Transition;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsBeginWithWord:Object = {};
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsByDestination:Object = {};
      
      private var _869004817toOver:Transition;
      
      private var _1840272557textShadow:DropShadowFilter;
      
      public var _ButtonSkin_AnimateColor2:AnimateColor;
      
      public var _ButtonSkin_AnimateColor3:AnimateColor;
      
      private var _1060986931textField:UITextField;
      
      public var _ButtonSkin_SetProperty1:SetProperty;
      
      public var _ButtonSkin_SetProperty2:SetProperty;
      
      public var _ButtonSkin_AnimateColor1:AnimateColor;
      
      public var _ButtonSkin_SetProperty4:SetProperty;
      
      private var _869338691toDown:Transition;
      
      public var _ButtonSkin_SetProperty6:SetProperty;
      
      public var _ButtonSkin_SetProperty3:SetProperty;
      
      public var _ButtonSkin_SetProperty5:SetProperty;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindings:Array = [];
      
      private var _1823111375dropshadow:DropShadowFilter;
      
      public function ButtonSkin()
      {
         super();
         mx_internal::_document = this;
         this.cacheAsBitmap = true;
         this.states = [this._ButtonSkin_State1_c(),this._ButtonSkin_State2_c(),this._ButtonSkin_State3_c()];
         this.transitions = [this._ButtonSkin_Transition1_i(),this._ButtonSkin_Transition2_i(),this._ButtonSkin_Transition3_i()];
         this._ButtonSkin_BevelFilter1_i();
         this._ButtonSkin_BevelFilter2_i();
         this._ButtonSkin_DropShadowFilter1_i();
         this._ButtonSkin_GlowFilter1_i();
         this._ButtonSkin_DropShadowFilter2_i();
         this.addEventListener("creationComplete",this.___ButtonSkin_Canvas1_creationComplete);
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil) : void
      {
         ButtonSkin._watcherSetupUtil = param1;
      }
      
      public function set toOver(param1:Transition) : void
      {
         var _loc2_:Object = this._869004817toOver;
         if(_loc2_ !== param1)
         {
            this._869004817toOver = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"toOver",_loc2_,param1));
         }
      }
      
      private function _ButtonSkin_Transition1_i() : Transition
      {
         var _loc1_:Transition = new Transition();
         this.toOver = _loc1_;
         _loc1_.fromState = "*";
         _loc1_.toState = "over";
         _loc1_.effect = this._ButtonSkin_AnimateColor1_i();
         return _loc1_;
      }
      
      public function set bevel(param1:BevelFilter) : void
      {
         var _loc2_:Object = this._93630586bevel;
         if(_loc2_ !== param1)
         {
            this._93630586bevel = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bevel",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get toOver() : Transition
      {
         return this._869004817toOver;
      }
      
      [Bindable(event="propertyChange")]
      public function get glow() : GlowFilter
      {
         return this._3175821glow;
      }
      
      [Bindable(event="propertyChange")]
      public function get toUp() : Transition
      {
         return this._3565174toUp;
      }
      
      override public function initialize() : void
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:ButtonSkin = null;
         var watcherSetupUtilClass:Object = null;
         mx_internal::setDocumentDescriptor(this._documentDescriptor_);
         bindings = this._ButtonSkin_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_com_riotgames_platform_gameclient_skin_ButtonSkinWatcherSetupUtil");
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
      
      private function _ButtonSkin_SetProperty4_i() : SetProperty
      {
         var _loc1_:SetProperty = new SetProperty();
         this._ButtonSkin_SetProperty4 = _loc1_;
         _loc1_.name = "filters";
         BindingManager.executeBindings(this,"_ButtonSkin_SetProperty4",this._ButtonSkin_SetProperty4);
         return _loc1_;
      }
      
      private function _ButtonSkin_SetProperty1_i() : SetProperty
      {
         var _loc1_:SetProperty = new SetProperty();
         this._ButtonSkin_SetProperty1 = _loc1_;
         _loc1_.name = "filters";
         BindingManager.executeBindings(this,"_ButtonSkin_SetProperty1",this._ButtonSkin_SetProperty1);
         return _loc1_;
      }
      
      private function _ButtonSkin_State2_c() : State
      {
         var _loc1_:State = new State();
         _loc1_.name = "down";
         _loc1_.overrides = [this._ButtonSkin_SetProperty2_i(),this._ButtonSkin_SetProperty3_i(),this._ButtonSkin_SetProperty4_i()];
         return _loc1_;
      }
      
      private function _ButtonSkin_AnimateColor2_i() : AnimateColor
      {
         var _loc1_:AnimateColor = new AnimateColor();
         this._ButtonSkin_AnimateColor2 = _loc1_;
         _loc1_.property = "backgroundColor";
         _loc1_.isStyle = true;
         _loc1_.toValue = 65280;
         _loc1_.duration = 300;
         BindingManager.executeBindings(this,"_ButtonSkin_AnimateColor2",this._ButtonSkin_AnimateColor2);
         return _loc1_;
      }
      
      private function _ButtonSkin_SetProperty5_i() : SetProperty
      {
         var _loc1_:SetProperty = new SetProperty();
         this._ButtonSkin_SetProperty5 = _loc1_;
         _loc1_.name = "filters";
         BindingManager.executeBindings(this,"_ButtonSkin_SetProperty5",this._ButtonSkin_SetProperty5);
         return _loc1_;
      }
      
      public function set glow(param1:GlowFilter) : void
      {
         var _loc2_:Object = this._3175821glow;
         if(_loc2_ !== param1)
         {
            this._3175821glow = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"glow",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get bevel() : BevelFilter
      {
         return this._93630586bevel;
      }
      
      private function _ButtonSkin_Transition2_i() : Transition
      {
         var _loc1_:Transition = new Transition();
         this.toUp = _loc1_;
         _loc1_.fromState = "*";
         _loc1_.toState = "up";
         _loc1_.effect = this._ButtonSkin_AnimateColor2_i();
         return _loc1_;
      }
      
      private function _ButtonSkin_SetProperty3_i() : SetProperty
      {
         var _loc1_:SetProperty = new SetProperty();
         this._ButtonSkin_SetProperty3 = _loc1_;
         _loc1_.name = "color";
         BindingManager.executeBindings(this,"_ButtonSkin_SetProperty3",this._ButtonSkin_SetProperty3);
         return _loc1_;
      }
      
      private function init() : void
      {
         var _loc1_:Button = parent as Button;
         this.textField = _loc1_.getTextField() as UITextField;
         filters = [this.bevel,this.dropshadow];
      }
      
      private function _ButtonSkin_DropShadowFilter2_i() : DropShadowFilter
      {
         var _loc1_:DropShadowFilter = new DropShadowFilter();
         this.textShadow = _loc1_;
         _loc1_.alpha = 0.5;
         _loc1_.quality = 2;
         _loc1_.distance = 2;
         _loc1_.blurX = 2;
         _loc1_.blurY = 2;
         return _loc1_;
      }
      
      private function _ButtonSkin_bindingsSetup() : Array
      {
         var binding:Binding = null;
         var result:Array = [];
         binding = new Binding(this,function():Object
         {
            return textField;
         },function(param1:Object):void
         {
            _ButtonSkin_SetProperty1.target = param1;
         },"_ButtonSkin_SetProperty1.target");
         result[0] = binding;
         binding = new Binding(this,function():*
         {
            return [textShadow];
         },function(param1:*):void
         {
            _ButtonSkin_SetProperty1.value = param1;
         },"_ButtonSkin_SetProperty1.value");
         result[1] = binding;
         binding = new Binding(this,function():Object
         {
            return this;
         },function(param1:Object):void
         {
            _ButtonSkin_SetProperty2.target = param1;
         },"_ButtonSkin_SetProperty2.target");
         result[2] = binding;
         binding = new Binding(this,function():*
         {
            return [bevelDown];
         },function(param1:*):void
         {
            _ButtonSkin_SetProperty2.value = param1;
         },"_ButtonSkin_SetProperty2.value");
         result[3] = binding;
         binding = new Binding(this,function():Object
         {
            return glow;
         },function(param1:Object):void
         {
            _ButtonSkin_SetProperty3.target = param1;
         },"_ButtonSkin_SetProperty3.target");
         result[4] = binding;
         binding = new Binding(this,function():*
         {
            return 15845776;
         },function(param1:*):void
         {
            _ButtonSkin_SetProperty3.value = param1;
         },"_ButtonSkin_SetProperty3.value");
         result[5] = binding;
         binding = new Binding(this,function():Object
         {
            return textField;
         },function(param1:Object):void
         {
            _ButtonSkin_SetProperty4.target = param1;
         },"_ButtonSkin_SetProperty4.target");
         result[6] = binding;
         binding = new Binding(this,function():*
         {
            return [glow];
         },function(param1:*):void
         {
            _ButtonSkin_SetProperty4.value = param1;
         },"_ButtonSkin_SetProperty4.value");
         result[7] = binding;
         binding = new Binding(this,function():Object
         {
            return textField;
         },function(param1:Object):void
         {
            _ButtonSkin_SetProperty5.target = param1;
         },"_ButtonSkin_SetProperty5.target");
         result[8] = binding;
         binding = new Binding(this,function():*
         {
            return [glow];
         },function(param1:*):void
         {
            _ButtonSkin_SetProperty5.value = param1;
         },"_ButtonSkin_SetProperty5.value");
         result[9] = binding;
         binding = new Binding(this,function():Object
         {
            return bevel;
         },function(param1:Object):void
         {
            _ButtonSkin_SetProperty6.target = param1;
         },"_ButtonSkin_SetProperty6.target");
         result[10] = binding;
         binding = new Binding(this,function():Object
         {
            return this;
         },function(param1:Object):void
         {
            _ButtonSkin_AnimateColor1.target = param1;
         },"_ButtonSkin_AnimateColor1.target");
         result[11] = binding;
         binding = new Binding(this,function():Object
         {
            return this;
         },function(param1:Object):void
         {
            _ButtonSkin_AnimateColor2.target = param1;
         },"_ButtonSkin_AnimateColor2.target");
         result[12] = binding;
         binding = new Binding(this,function():Object
         {
            return this;
         },function(param1:Object):void
         {
            _ButtonSkin_AnimateColor3.target = param1;
         },"_ButtonSkin_AnimateColor3.target");
         result[13] = binding;
         return result;
      }
      
      public function set toUp(param1:Transition) : void
      {
         var _loc2_:Object = this._3565174toUp;
         if(_loc2_ !== param1)
         {
            this._3565174toUp = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"toUp",_loc2_,param1));
         }
      }
      
      public function set dropshadow(param1:DropShadowFilter) : void
      {
         var _loc2_:Object = this._1823111375dropshadow;
         if(_loc2_ !== param1)
         {
            this._1823111375dropshadow = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"dropshadow",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get textShadow() : DropShadowFilter
      {
         return this._1840272557textShadow;
      }
      
      private function _ButtonSkin_bindingExprs() : void
      {
         var _loc1_:* = undefined;
         _loc1_ = this.textField;
         _loc1_ = [this.textShadow];
         _loc1_ = this;
         _loc1_ = [this.bevelDown];
         _loc1_ = this.glow;
         _loc1_ = 15845776;
         _loc1_ = this.textField;
         _loc1_ = [this.glow];
         _loc1_ = this.textField;
         _loc1_ = [this.glow];
         _loc1_ = this.bevel;
         _loc1_ = this;
         _loc1_ = this;
         _loc1_ = this;
      }
      
      private function _ButtonSkin_BevelFilter2_i() : BevelFilter
      {
         var _loc1_:BevelFilter = new BevelFilter();
         this.bevelDown = _loc1_;
         _loc1_.type = "inner";
         _loc1_.angle = 245;
         _loc1_.shadowAlpha = 0.4;
         _loc1_.highlightAlpha = 0.4;
         _loc1_.distance = 8;
         _loc1_.blurX = 10;
         _loc1_.blurY = 10;
         _loc1_.quality = 4;
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get toDown() : Transition
      {
         return this._869338691toDown;
      }
      
      [Bindable(event="propertyChange")]
      public function get bevelDown() : BevelFilter
      {
         return this._762020804bevelDown;
      }
      
      private function _ButtonSkin_GlowFilter1_i() : GlowFilter
      {
         var _loc1_:GlowFilter = new GlowFilter();
         this.glow = _loc1_;
         _loc1_.color = 12083475;
         _loc1_.alpha = 0.8;
         return _loc1_;
      }
      
      private function set textField(param1:UITextField) : void
      {
         var _loc2_:Object = this._1060986931textField;
         if(_loc2_ !== param1)
         {
            this._1060986931textField = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"textField",_loc2_,param1));
         }
      }
      
      private function _ButtonSkin_AnimateColor1_i() : AnimateColor
      {
         var _loc1_:AnimateColor = new AnimateColor();
         this._ButtonSkin_AnimateColor1 = _loc1_;
         _loc1_.property = "backgroundColor";
         _loc1_.isStyle = true;
         _loc1_.toValue = 16711680;
         _loc1_.duration = 300;
         BindingManager.executeBindings(this,"_ButtonSkin_AnimateColor1",this._ButtonSkin_AnimateColor1);
         return _loc1_;
      }
      
      private function _ButtonSkin_AnimateColor3_i() : AnimateColor
      {
         var _loc1_:AnimateColor = new AnimateColor();
         this._ButtonSkin_AnimateColor3 = _loc1_;
         _loc1_.property = "backgroundColor";
         _loc1_.isStyle = true;
         _loc1_.toValue = 255;
         _loc1_.duration = 300;
         BindingManager.executeBindings(this,"_ButtonSkin_AnimateColor3",this._ButtonSkin_AnimateColor3);
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      private function get textField() : UITextField
      {
         return this._1060986931textField;
      }
      
      public function set toDown(param1:Transition) : void
      {
         var _loc2_:Object = this._869338691toDown;
         if(_loc2_ !== param1)
         {
            this._869338691toDown = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"toDown",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get dropshadow() : DropShadowFilter
      {
         return this._1823111375dropshadow;
      }
      
      private function _ButtonSkin_State3_c() : State
      {
         var _loc1_:State = new State();
         _loc1_.name = "over";
         _loc1_.overrides = [this._ButtonSkin_SetProperty5_i(),this._ButtonSkin_SetProperty6_i()];
         return _loc1_;
      }
      
      private function _ButtonSkin_SetProperty2_i() : SetProperty
      {
         var _loc1_:SetProperty = new SetProperty();
         this._ButtonSkin_SetProperty2 = _loc1_;
         _loc1_.name = "filters";
         BindingManager.executeBindings(this,"_ButtonSkin_SetProperty2",this._ButtonSkin_SetProperty2);
         return _loc1_;
      }
      
      private function _ButtonSkin_SetProperty6_i() : SetProperty
      {
         var _loc1_:SetProperty = new SetProperty();
         this._ButtonSkin_SetProperty6 = _loc1_;
         _loc1_.name = "highlightAlpha";
         _loc1_.value = 0.8;
         BindingManager.executeBindings(this,"_ButtonSkin_SetProperty6",this._ButtonSkin_SetProperty6);
         return _loc1_;
      }
      
      private function _ButtonSkin_DropShadowFilter1_i() : DropShadowFilter
      {
         var _loc1_:DropShadowFilter = new DropShadowFilter();
         this.dropshadow = _loc1_;
         _loc1_.alpha = 0.5;
         _loc1_.quality = 3;
         _loc1_.blurX = 6;
         _loc1_.blurY = 6;
         return _loc1_;
      }
      
      private function _ButtonSkin_Transition3_i() : Transition
      {
         var _loc1_:Transition = new Transition();
         this.toDown = _loc1_;
         _loc1_.fromState = "*";
         _loc1_.toState = "down";
         _loc1_.effect = this._ButtonSkin_AnimateColor3_i();
         return _loc1_;
      }
      
      public function set textShadow(param1:DropShadowFilter) : void
      {
         var _loc2_:Object = this._1840272557textShadow;
         if(_loc2_ !== param1)
         {
            this._1840272557textShadow = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"textShadow",_loc2_,param1));
         }
      }
      
      private function _ButtonSkin_State1_c() : State
      {
         var _loc1_:State = new State();
         _loc1_.name = "up";
         _loc1_.overrides = [this._ButtonSkin_SetProperty1_i()];
         return _loc1_;
      }
      
      public function set bevelDown(param1:BevelFilter) : void
      {
         var _loc2_:Object = this._762020804bevelDown;
         if(_loc2_ !== param1)
         {
            this._762020804bevelDown = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bevelDown",_loc2_,param1));
         }
      }
      
      private function _ButtonSkin_BevelFilter1_i() : BevelFilter
      {
         var _loc1_:BevelFilter = new BevelFilter();
         this.bevel = _loc1_;
         _loc1_.angle = 90;
         _loc1_.highlightColor = 16777215;
         _loc1_.shadowAlpha = 0;
         _loc1_.strength = 3;
         _loc1_.quality = 3;
         _loc1_.distance = 24;
         _loc1_.highlightAlpha = 0.4;
         return _loc1_;
      }
      
      public function ___ButtonSkin_Canvas1_creationComplete(param1:FlexEvent) : void
      {
         this.init();
      }
   }
}

