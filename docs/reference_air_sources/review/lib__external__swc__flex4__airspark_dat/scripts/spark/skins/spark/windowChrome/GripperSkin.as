package spark.skins.spark.windowChrome
{
   import flash.accessibility.*;
   import flash.data.*;
   import flash.debugger.*;
   import flash.desktop.*;
   import flash.display.*;
   import flash.errors.*;
   import flash.events.*;
   import flash.external.*;
   import flash.filesystem.*;
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
   import mx.core.IFlexModuleFactory;
   import mx.core.IStateClient2;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.graphics.SolidColor;
   import mx.states.State;
   import mx.styles.*;
   import spark.components.Button;
   import spark.components.supportClasses.Skin;
   import spark.primitives.BitmapImage;
   import spark.primitives.Rect;
   
   [States("disabled")]
   [HostComponent("spark.components.Button")]
   public class GripperSkin extends Skin implements IBindingClient, IStateClient2
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      public var _GripperSkin_BitmapImage1:BitmapImage;
      
      private var _1427430450backgroundRect:Rect;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var _embed_mxml________________assets_gripper_up_png_1919884316:Class;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindings:Array;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _watchers:Array;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsByDestination:Object;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsBeginWithWord:Object;
      
      private var _213507019hostComponent:Button;
      
      public function GripperSkin()
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._embed_mxml________________assets_gripper_up_png_1919884316 = GripperSkin__embed_mxml________________assets_gripper_up_png_1919884316;
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         bindings = this._GripperSkin_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_spark_skins_spark_windowChrome_GripperSkinWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return GripperSkin[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.minWidth = 7;
         this.minHeight = 9;
         this.mxmlContent = [this._GripperSkin_Rect1_i(),this._GripperSkin_BitmapImage1_i()];
         this.currentState = "up";
         states = [new State({
            "name":"up",
            "overrides":[]
         }),new State({
            "name":"over",
            "overrides":[]
         }),new State({
            "name":"down",
            "overrides":[]
         }),new State({
            "name":"disabled",
            "overrides":[]
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
         GripperSkin._watcherSetupUtil = param1;
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
      
      private function _GripperSkin_Rect1_i() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.left = 0;
         _loc1_.right = 0;
         _loc1_.top = 0;
         _loc1_.bottom = 0;
         _loc1_.fill = this._GripperSkin_SolidColor1_c();
         _loc1_.initialized(this,"backgroundRect");
         this.backgroundRect = _loc1_;
         BindingManager.executeBindings(this,"backgroundRect",this.backgroundRect);
         return _loc1_;
      }
      
      private function _GripperSkin_SolidColor1_c() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         _loc1_.color = 0;
         _loc1_.alpha = 0.0001;
         return _loc1_;
      }
      
      private function _GripperSkin_BitmapImage1_i() : BitmapImage
      {
         var _loc1_:BitmapImage = new BitmapImage();
         _loc1_.source = this._embed_mxml________________assets_gripper_up_png_1919884316;
         _loc1_.right = 0;
         _loc1_.bottom = 0;
         _loc1_.verticalCenter = 0;
         _loc1_.fillMode = "clip";
         _loc1_.initialized(this,"_GripperSkin_BitmapImage1");
         this._GripperSkin_BitmapImage1 = _loc1_;
         BindingManager.executeBindings(this,"_GripperSkin_BitmapImage1",this._GripperSkin_BitmapImage1);
         return _loc1_;
      }
      
      private function _GripperSkin_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():String
         {
            var _loc1_:* = null;
            return _loc1_ == undefined ? null : String(_loc1_);
         },null,"_GripperSkin_BitmapImage1.layoutDirection");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      public function get backgroundRect() : Rect
      {
         return this._1427430450backgroundRect;
      }
      
      public function set backgroundRect(param1:Rect) : void
      {
         var _loc2_:Object = this._1427430450backgroundRect;
         if(_loc2_ !== param1)
         {
            this._1427430450backgroundRect = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"backgroundRect",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get hostComponent() : Button
      {
         return this._213507019hostComponent;
      }
      
      public function set hostComponent(param1:Button) : void
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

