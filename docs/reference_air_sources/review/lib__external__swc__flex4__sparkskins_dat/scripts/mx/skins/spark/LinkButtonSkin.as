package mx.skins.spark
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
   import spark.components.supportClasses.Skin;
   import spark.primitives.Rect;
   
   [States("selectedDisabled")]
   public class LinkButtonSkin extends Skin implements IBindingClient, IStateClient2
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      [Inspectable]
      public var _LinkButtonSkin_Rect1:Rect;
      
      private var _1136201745_LinkButtonSkin_SetProperty1:SetProperty;
      
      private var _1136201746_LinkButtonSkin_SetProperty2:SetProperty;
      
      private var _1136201747_LinkButtonSkin_SetProperty3:SetProperty;
      
      private var _1136201748_LinkButtonSkin_SetProperty4:SetProperty;
      
      private var _118072446_LinkButtonSkin_SolidColor1:SolidColor;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindings:Array;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _watchers:Array;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsByDestination:Object;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsBeginWithWord:Object;
      
      public function LinkButtonSkin()
      {
         var bindings:Array;
         var watchers:Array;
         var _LinkButtonSkin_Rect1_factory:DeferredInstanceFromFunction;
         var i:uint;
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         bindings = this._LinkButtonSkin_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_mx_skins_spark_LinkButtonSkinWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return LinkButtonSkin[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.minWidth = 21;
         this.minHeight = 21;
         this.mxmlContent = [];
         this.currentState = "up";
         _LinkButtonSkin_Rect1_factory = new DeferredInstanceFromFunction(this._LinkButtonSkin_Rect1_i);
         states = [new State({
            "name":"up",
            "stateGroups":["upStates"],
            "overrides":[]
         }),new State({
            "name":"over",
            "stateGroups":["overStates"],
            "overrides":[new AddItems().initializeFromObject({
               "itemsFactory":_LinkButtonSkin_Rect1_factory,
               "destination":null,
               "propertyName":"mxmlContent",
               "position":"first"
            }),this._LinkButtonSkin_SetProperty2 = SetProperty(new SetProperty().initializeFromObject({
               "target":"_LinkButtonSkin_SolidColor1",
               "name":"color",
               "value":undefined
            }))]
         }),new State({
            "name":"down",
            "stateGroups":["downStates"],
            "overrides":[new AddItems().initializeFromObject({
               "itemsFactory":_LinkButtonSkin_Rect1_factory,
               "destination":null,
               "propertyName":"mxmlContent",
               "position":"first"
            }),this._LinkButtonSkin_SetProperty4 = SetProperty(new SetProperty().initializeFromObject({
               "target":"_LinkButtonSkin_SolidColor1",
               "name":"color",
               "value":undefined
            }))]
         }),new State({
            "name":"disabled",
            "stateGroups":["disabledStates"],
            "overrides":[new SetProperty().initializeFromObject({
               "name":"alpha",
               "value":0.5
            })]
         }),new State({
            "name":"selectedUp",
            "stateGroups":["upStates"],
            "overrides":[]
         }),new State({
            "name":"selectedOver",
            "stateGroups":["overStates"],
            "overrides":[new AddItems().initializeFromObject({
               "itemsFactory":_LinkButtonSkin_Rect1_factory,
               "destination":null,
               "propertyName":"mxmlContent",
               "position":"first"
            }),this._LinkButtonSkin_SetProperty1 = SetProperty(new SetProperty().initializeFromObject({
               "target":"_LinkButtonSkin_SolidColor1",
               "name":"color",
               "value":undefined
            }))]
         }),new State({
            "name":"selectedDown",
            "stateGroups":["downStates"],
            "overrides":[new AddItems().initializeFromObject({
               "itemsFactory":_LinkButtonSkin_Rect1_factory,
               "destination":null,
               "propertyName":"mxmlContent",
               "position":"first"
            }),this._LinkButtonSkin_SetProperty3 = SetProperty(new SetProperty().initializeFromObject({
               "target":"_LinkButtonSkin_SolidColor1",
               "name":"color",
               "value":undefined
            }))]
         }),new State({
            "name":"selectedDisabled",
            "stateGroups":["disabledStates"],
            "overrides":[new SetProperty().initializeFromObject({
               "name":"alpha",
               "value":0.5
            })]
         })];
         BindingManager.executeBindings(this,"_LinkButtonSkin_SetProperty2",this._LinkButtonSkin_SetProperty2);
         BindingManager.executeBindings(this,"_LinkButtonSkin_SetProperty4",this._LinkButtonSkin_SetProperty4);
         BindingManager.executeBindings(this,"_LinkButtonSkin_SetProperty1",this._LinkButtonSkin_SetProperty1);
         BindingManager.executeBindings(this,"_LinkButtonSkin_SetProperty3",this._LinkButtonSkin_SetProperty3);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         LinkButtonSkin._watcherSetupUtil = param1;
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
      
      private function _LinkButtonSkin_Rect1_i() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.left = 0;
         _loc1_.right = 0;
         _loc1_.top = 0;
         _loc1_.bottom = 0;
         _loc1_.fill = this._LinkButtonSkin_SolidColor1_i();
         _loc1_.initialized(this,"_LinkButtonSkin_Rect1");
         this._LinkButtonSkin_Rect1 = _loc1_;
         BindingManager.executeBindings(this,"_LinkButtonSkin_Rect1",this._LinkButtonSkin_Rect1);
         return _loc1_;
      }
      
      private function _LinkButtonSkin_SolidColor1_i() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         _loc1_.alpha = 1;
         this._LinkButtonSkin_SolidColor1 = _loc1_;
         BindingManager.executeBindings(this,"_LinkButtonSkin_SolidColor1",this._LinkButtonSkin_SolidColor1);
         return _loc1_;
      }
      
      private function _LinkButtonSkin_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():Number
         {
            return getStyle("cornerRadius");
         },null,"_LinkButtonSkin_Rect1.radiusX");
         result[1] = new Binding(this,function():*
         {
            return getStyle("rollOverColor");
         },null,"_LinkButtonSkin_SetProperty1.value");
         result[2] = new Binding(this,function():*
         {
            return getStyle("rollOverColor");
         },null,"_LinkButtonSkin_SetProperty2.value");
         result[3] = new Binding(this,function():*
         {
            return getStyle("selectionColor");
         },null,"_LinkButtonSkin_SetProperty3.value");
         result[4] = new Binding(this,function():*
         {
            return getStyle("selectionColor");
         },null,"_LinkButtonSkin_SetProperty4.value");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get _LinkButtonSkin_SetProperty1() : SetProperty
      {
         return this._1136201745_LinkButtonSkin_SetProperty1;
      }
      
      public function set _LinkButtonSkin_SetProperty1(param1:SetProperty) : void
      {
         var _loc2_:Object = this._1136201745_LinkButtonSkin_SetProperty1;
         if(_loc2_ !== param1)
         {
            this._1136201745_LinkButtonSkin_SetProperty1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_LinkButtonSkin_SetProperty1",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get _LinkButtonSkin_SetProperty2() : SetProperty
      {
         return this._1136201746_LinkButtonSkin_SetProperty2;
      }
      
      public function set _LinkButtonSkin_SetProperty2(param1:SetProperty) : void
      {
         var _loc2_:Object = this._1136201746_LinkButtonSkin_SetProperty2;
         if(_loc2_ !== param1)
         {
            this._1136201746_LinkButtonSkin_SetProperty2 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_LinkButtonSkin_SetProperty2",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get _LinkButtonSkin_SetProperty3() : SetProperty
      {
         return this._1136201747_LinkButtonSkin_SetProperty3;
      }
      
      public function set _LinkButtonSkin_SetProperty3(param1:SetProperty) : void
      {
         var _loc2_:Object = this._1136201747_LinkButtonSkin_SetProperty3;
         if(_loc2_ !== param1)
         {
            this._1136201747_LinkButtonSkin_SetProperty3 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_LinkButtonSkin_SetProperty3",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get _LinkButtonSkin_SetProperty4() : SetProperty
      {
         return this._1136201748_LinkButtonSkin_SetProperty4;
      }
      
      public function set _LinkButtonSkin_SetProperty4(param1:SetProperty) : void
      {
         var _loc2_:Object = this._1136201748_LinkButtonSkin_SetProperty4;
         if(_loc2_ !== param1)
         {
            this._1136201748_LinkButtonSkin_SetProperty4 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_LinkButtonSkin_SetProperty4",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      [Inspectable]
      public function get _LinkButtonSkin_SolidColor1() : SolidColor
      {
         return this._118072446_LinkButtonSkin_SolidColor1;
      }
      
      public function set _LinkButtonSkin_SolidColor1(param1:SolidColor) : void
      {
         var _loc2_:Object = this._118072446_LinkButtonSkin_SolidColor1;
         if(_loc2_ !== param1)
         {
            this._118072446_LinkButtonSkin_SolidColor1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_LinkButtonSkin_SolidColor1",_loc2_,param1));
            }
         }
      }
   }
}

