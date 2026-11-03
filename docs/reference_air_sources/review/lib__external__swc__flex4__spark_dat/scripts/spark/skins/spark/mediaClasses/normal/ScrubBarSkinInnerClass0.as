package spark.skins.spark.mediaClasses.normal
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
   import mx.core.IFlexModuleFactory;
   import mx.events.PropertyChangeEvent;
   import mx.filters.*;
   import mx.graphics.SolidColor;
   import mx.styles.*;
   import spark.components.DataRenderer;
   import spark.components.Label;
   import spark.primitives.Rect;
   import spark.primitives.RectangularDropShadow;
   
   [ExcludeClass]
   public class ScrubBarSkinInnerClass0 extends DataRenderer implements IBindingClient
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private var _1184053038labelDisplay:Label;
      
      private var _88844982outerDocument:ScrubBarSkin;
      
      private var _903579360shadow:RectangularDropShadow;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindings:Array;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _watchers:Array;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsByDestination:Object;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsBeginWithWord:Object;
      
      public function ScrubBarSkinInnerClass0()
      {
         var bindings:Array;
         var watchers:Array;
         var i:uint;
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         bindings = this._ScrubBarSkinInnerClass0_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_spark_skins_spark_mediaClasses_normal_ScrubBarSkinInnerClass0WatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return ScrubBarSkinInnerClass0[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.minHeight = 24;
         this.minWidth = 40;
         this.y = -34;
         this.mxmlContent = [this._ScrubBarSkinInnerClass0_RectangularDropShadow1_i(),this._ScrubBarSkinInnerClass0_Rect1_c(),this._ScrubBarSkinInnerClass0_Label1_i()];
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         ScrubBarSkinInnerClass0._watcherSetupUtil = param1;
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
      
      private function _ScrubBarSkinInnerClass0_RectangularDropShadow1_i() : RectangularDropShadow
      {
         var _loc1_:RectangularDropShadow = new RectangularDropShadow();
         _loc1_.distance = 3;
         _loc1_.angle = 90;
         _loc1_.color = 10066329;
         _loc1_.left = 0;
         _loc1_.top = 0;
         _loc1_.right = 0;
         _loc1_.bottom = 0;
         _loc1_.id = "shadow";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.shadow = _loc1_;
         BindingManager.executeBindings(this,"shadow",this.shadow);
         return _loc1_;
      }
      
      private function _ScrubBarSkinInnerClass0_Rect1_c() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.top = 0;
         _loc1_.left = 0;
         _loc1_.right = 0;
         _loc1_.bottom = 0;
         _loc1_.fill = this._ScrubBarSkinInnerClass0_SolidColor1_c();
         _loc1_.initialized(this,null);
         return _loc1_;
      }
      
      private function _ScrubBarSkinInnerClass0_SolidColor1_c() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         _loc1_.color = 0;
         _loc1_.alpha = 0.9;
         return _loc1_;
      }
      
      private function _ScrubBarSkinInnerClass0_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.horizontalCenter = 0;
         _loc1_.verticalCenter = 1;
         _loc1_.left = 5;
         _loc1_.right = 5;
         _loc1_.top = 5;
         _loc1_.bottom = 5;
         _loc1_.setStyle("textAlign","center");
         _loc1_.setStyle("verticalAlign","middle");
         _loc1_.setStyle("fontWeight","normal");
         _loc1_.setStyle("color",16777215);
         _loc1_.setStyle("fontSize",11);
         _loc1_.id = "labelDisplay";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.labelDisplay = _loc1_;
         BindingManager.executeBindings(this,"labelDisplay",this.labelDisplay);
         return _loc1_;
      }
      
      private function _ScrubBarSkinInnerClass0_bindingsSetup() : Array
      {
         var _loc1_:Array = [];
         _loc1_[0] = new Binding(this,null,null,"labelDisplay.text","data");
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get labelDisplay() : Label
      {
         return this._1184053038labelDisplay;
      }
      
      public function set labelDisplay(param1:Label) : void
      {
         var _loc2_:Object = this._1184053038labelDisplay;
         if(_loc2_ !== param1)
         {
            this._1184053038labelDisplay = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"labelDisplay",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get outerDocument() : ScrubBarSkin
      {
         return this._88844982outerDocument;
      }
      
      public function set outerDocument(param1:ScrubBarSkin) : void
      {
         var _loc2_:Object = this._88844982outerDocument;
         if(_loc2_ !== param1)
         {
            this._88844982outerDocument = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"outerDocument",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get shadow() : RectangularDropShadow
      {
         return this._903579360shadow;
      }
      
      public function set shadow(param1:RectangularDropShadow) : void
      {
         var _loc2_:Object = this._903579360shadow;
         if(_loc2_ !== param1)
         {
            this._903579360shadow = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"shadow",_loc2_,param1));
            }
         }
      }
   }
}

