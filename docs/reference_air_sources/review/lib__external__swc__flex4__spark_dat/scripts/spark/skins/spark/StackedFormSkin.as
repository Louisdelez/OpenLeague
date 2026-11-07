package spark.skins.spark
{
   import flash.accessibility.*;
   import flash.debugger.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.geom.*;
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
   import mx.core.DeferredInstanceFromFunction;
   import mx.core.IFlexModuleFactory;
   import mx.core.IStateClient2;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.graphics.SolidColor;
   import mx.states.AddItems;
   import mx.states.SetProperty;
   import mx.states.State;
   import mx.styles.*;
   import spark.components.Form;
   import spark.components.Group;
   import spark.components.Label;
   import spark.components.VGroup;
   import spark.components.supportClasses.Skin;
   import spark.layouts.FormLayout;
   import spark.primitives.Rect;
   
   [States("disabled")]
   [HostComponent("spark.components.Form")]
   public class StackedFormSkin extends Skin implements IBindingClient, IStateClient2
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private var _874840680_StackedFormSkin_Group1:Group;
      
      private var _1332194002background:Rect;
      
      private var _1391998104bgFill:SolidColor;
      
      private var _809612678contentGroup:Group;
      
      private var _66023341errorTextDisplay:Label;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindings:Array;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _watchers:Array;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsByDestination:Object;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsBeginWithWord:Object;
      
      private var _213507019hostComponent:Form;
      
      public function StackedFormSkin()
      {
         var watchers:Array;
         var _StackedFormSkin_Label1_factory:DeferredInstanceFromFunction;
         var i:uint;
         var bindings:Array = null;
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         bindings = this._StackedFormSkin_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_spark_skins_spark_StackedFormSkinWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return StackedFormSkin[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.mxmlContent = [this._StackedFormSkin_Rect1_i(),this._StackedFormSkin_VGroup1_c()];
         this.currentState = "normal";
         _StackedFormSkin_Label1_factory = new DeferredInstanceFromFunction(this._StackedFormSkin_Label1_i);
         states = [new State({
            "name":"normal",
            "overrides":[]
         }),new State({
            "name":"error",
            "overrides":[new AddItems().initializeFromObject({
               "itemsFactory":_StackedFormSkin_Label1_factory,
               "destination":"_StackedFormSkin_Group1",
               "propertyName":"mxmlContent",
               "position":"first"
            })]
         }),new State({
            "name":"disabled",
            "overrides":[new SetProperty().initializeFromObject({
               "name":"alpha",
               "value":0.5
            })]
         })];
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         StackedFormSkin._watcherSetupUtil = param1;
      }
      
      override public function set moduleFactory(param1:IFlexModuleFactory) : void
      {
         super.moduleFactory = param1;
         if(this.__moduleFactoryInitialized)
         {
            return;
         }
         this.__moduleFactoryInitialized = true;
      }
      
      override public function initialize() : void
      {
         super.initialize();
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         if(isNaN(getStyle("backgroundColor")))
         {
            this.background.visible = false;
         }
         else
         {
            this.background.visible = true;
            this.bgFill.color = getStyle("backgroundColor");
            this.bgFill.alpha = getStyle("backgroundAlpha");
         }
         super.updateDisplayList(unscaledWidth,unscaledHeight);
      }
      
      private function _StackedFormSkin_Rect1_i() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.left = 0;
         _loc1_.right = 0;
         _loc1_.top = 0;
         _loc1_.bottom = 0;
         _loc1_.fill = this._StackedFormSkin_SolidColor1_i();
         _loc1_.initialized(this,"background");
         this.background = _loc1_;
         BindingManager.executeBindings(this,"background",this.background);
         return _loc1_;
      }
      
      private function _StackedFormSkin_SolidColor1_i() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         _loc1_.color = 16777215;
         this.bgFill = _loc1_;
         BindingManager.executeBindings(this,"bgFill",this.bgFill);
         return _loc1_;
      }
      
      private function _StackedFormSkin_VGroup1_c() : VGroup
      {
         var _loc1_:VGroup = new VGroup();
         _loc1_.left = 10;
         _loc1_.right = 10;
         _loc1_.top = 10;
         _loc1_.bottom = 10;
         _loc1_.mxmlContent = [this._StackedFormSkin_Group1_i(),this._StackedFormSkin_Group2_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _StackedFormSkin_Group1_i() : Group
      {
         var _loc1_:Group = new Group();
         _loc1_.percentWidth = 100;
         _loc1_.mxmlContent = [];
         _loc1_.id = "_StackedFormSkin_Group1";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._StackedFormSkin_Group1 = _loc1_;
         BindingManager.executeBindings(this,"_StackedFormSkin_Group1",this._StackedFormSkin_Group1);
         return _loc1_;
      }
      
      private function _StackedFormSkin_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.left = 4;
         _loc1_.right = 4;
         _loc1_.top = 4;
         _loc1_.bottom = 4;
         _loc1_.setStyle("color",16646144);
         _loc1_.setStyle("fontStyle","italic");
         _loc1_.id = "errorTextDisplay";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.errorTextDisplay = _loc1_;
         BindingManager.executeBindings(this,"errorTextDisplay",this.errorTextDisplay);
         return _loc1_;
      }
      
      private function _StackedFormSkin_Group2_i() : Group
      {
         var _loc1_:Group = new Group();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.layout = this._StackedFormSkin_FormLayout1_c();
         _loc1_.setStyle("showErrorSkin",true);
         _loc1_.setStyle("showErrorTip",true);
         _loc1_.id = "contentGroup";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.contentGroup = _loc1_;
         BindingManager.executeBindings(this,"contentGroup",this.contentGroup);
         return _loc1_;
      }
      
      private function _StackedFormSkin_FormLayout1_c() : FormLayout
      {
         var _loc1_:FormLayout = new FormLayout();
         _loc1_.gap = 7;
         return _loc1_;
      }
      
      private function _StackedFormSkin_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = hostComponent.errorString;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"errorTextDisplay.text");
         result[1] = new Binding(this,function():Number
         {
            return this.width - 8;
         },null,"errorTextDisplay.maxWidth");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      [Inspectable]
      public function get _StackedFormSkin_Group1() : Group
      {
         return this._874840680_StackedFormSkin_Group1;
      }
      
      public function set _StackedFormSkin_Group1(param1:Group) : void
      {
         var _loc2_:Object = this._874840680_StackedFormSkin_Group1;
         if(_loc2_ !== param1)
         {
            this._874840680_StackedFormSkin_Group1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_StackedFormSkin_Group1",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get background() : Rect
      {
         return this._1332194002background;
      }
      
      public function set background(param1:Rect) : void
      {
         var _loc2_:Object = this._1332194002background;
         if(_loc2_ !== param1)
         {
            this._1332194002background = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"background",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get bgFill() : SolidColor
      {
         return this._1391998104bgFill;
      }
      
      public function set bgFill(param1:SolidColor) : void
      {
         var _loc2_:Object = this._1391998104bgFill;
         if(_loc2_ !== param1)
         {
            this._1391998104bgFill = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bgFill",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get contentGroup() : Group
      {
         return this._809612678contentGroup;
      }
      
      public function set contentGroup(param1:Group) : void
      {
         var _loc2_:Object = this._809612678contentGroup;
         if(_loc2_ !== param1)
         {
            this._809612678contentGroup = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"contentGroup",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get errorTextDisplay() : Label
      {
         return this._66023341errorTextDisplay;
      }
      
      public function set errorTextDisplay(param1:Label) : void
      {
         var _loc2_:Object = this._66023341errorTextDisplay;
         if(_loc2_ !== param1)
         {
            this._66023341errorTextDisplay = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"errorTextDisplay",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get hostComponent() : Form
      {
         return this._213507019hostComponent;
      }
      
      public function set hostComponent(param1:Form) : void
      {
         var _loc2_:Object = this._213507019hostComponent;
         if(_loc2_ !== param1)
         {
            this._213507019hostComponent = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"hostComponent",_loc2_,param1));
            }
         }
      }
   }
}

