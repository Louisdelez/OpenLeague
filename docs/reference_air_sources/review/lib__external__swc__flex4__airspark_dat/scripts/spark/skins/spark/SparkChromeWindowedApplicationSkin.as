package spark.skins.spark
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
   import mx.graphics.GradientEntry;
   import mx.graphics.LinearGradient;
   import mx.graphics.LinearGradientStroke;
   import mx.graphics.SolidColor;
   import mx.graphics.SolidColorStroke;
   import mx.states.SetProperty;
   import mx.states.State;
   import mx.styles.*;
   import spark.components.Button;
   import spark.components.Group;
   import spark.components.Label;
   import spark.components.windowClasses.TitleBar;
   import spark.layouts.VerticalLayout;
   import spark.primitives.Rect;
   import spark.skins.SparkSkin;
   import spark.skins.spark.windowChrome.GripperSkin;
   
   [States("disabledAndInactive")]
   [HostComponent("Object")]
   public class SparkChromeWindowedApplicationSkin extends SparkSkin implements IBindingClient, IStateClient2
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private static const exclusions:Array = ["backgroundRect","contentGroup","titleBar","titleBarBackgroundRect","statusText","borderBgFill"];
      
      private var _971275177_SparkChromeWindowedApplicationSkin_SolidColorStroke2:SolidColorStroke;
      
      private var _1427077073backgroundFill:SolidColor;
      
      private var _1427430450backgroundRect:Rect;
      
      private var _895769268borderBgFill:Group;
      
      private var _809612678contentGroup:Group;
      
      private var _287739019gripper:Button;
      
      private var _2070227263statusBar:Group;
      
      private var _248004671statusText:Label;
      
      private var _1870028133titleBar:TitleBar;
      
      private var _952426579titleBarBackgroundRect:Rect;
      
      private var _1964685795titleBarBgFill:SolidColor;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindings:Array;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _watchers:Array;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsByDestination:Object;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsBeginWithWord:Object;
      
      private var _213507019hostComponent:Object;
      
      public function SparkChromeWindowedApplicationSkin()
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
         bindings = this._SparkChromeWindowedApplicationSkin_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_spark_skins_spark_SparkChromeWindowedApplicationSkinWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return SparkChromeWindowedApplicationSkin[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.mxmlContent = [this._SparkChromeWindowedApplicationSkin_Rect1_i(),this._SparkChromeWindowedApplicationSkin_Rect2_i(),this._SparkChromeWindowedApplicationSkin_Group1_c(),this._SparkChromeWindowedApplicationSkin_Button1_i(),this._SparkChromeWindowedApplicationSkin_Group4_i(),this._SparkChromeWindowedApplicationSkin_Rect6_c()];
         this.currentState = "normal";
         states = [new State({
            "name":"normal",
            "overrides":[]
         }),new State({
            "name":"disabled",
            "stateGroups":["disabledGroup"],
            "overrides":[new SetProperty().initializeFromObject({
               "name":"alpha",
               "value":0.5
            })]
         }),new State({
            "name":"normalAndInactive",
            "stateGroups":["inactiveGroup"],
            "overrides":[new SetProperty().initializeFromObject({
               "target":"titleBar",
               "name":"alpha",
               "value":0.5
            }),new SetProperty().initializeFromObject({
               "target":"_SparkChromeWindowedApplicationSkin_SolidColorStroke2",
               "name":"alpha",
               "value":0.5
            })]
         }),new State({
            "name":"disabledAndInactive",
            "stateGroups":["inactiveGroup","disabledGroup"],
            "overrides":[new SetProperty().initializeFromObject({
               "name":"alpha",
               "value":0.5
            }),new SetProperty().initializeFromObject({
               "target":"titleBar",
               "name":"alpha",
               "value":0.5
            }),new SetProperty().initializeFromObject({
               "target":"_SparkChromeWindowedApplicationSkin_SolidColorStroke2",
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
         SparkChromeWindowedApplicationSkin._watcherSetupUtil = param1;
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
      
      override public function get colorizeExclusions() : Array
      {
         return exclusions;
      }
      
      override protected function initializationComplete() : void
      {
         useChromeColor = true;
         super.initializationComplete();
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         this.backgroundFill.color = getStyle("backgroundColor");
         this.backgroundFill.alpha = getStyle("backgroundAlpha");
         super.updateDisplayList(unscaledWidth,unscaledHeight);
      }
      
      private function _SparkChromeWindowedApplicationSkin_Rect1_i() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.left = 1;
         _loc1_.right = 1;
         _loc1_.top = 1;
         _loc1_.bottom = 1;
         _loc1_.fill = this._SparkChromeWindowedApplicationSkin_SolidColor1_i();
         _loc1_.initialized(this,"backgroundRect");
         this.backgroundRect = _loc1_;
         BindingManager.executeBindings(this,"backgroundRect",this.backgroundRect);
         return _loc1_;
      }
      
      private function _SparkChromeWindowedApplicationSkin_SolidColor1_i() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         this.backgroundFill = _loc1_;
         BindingManager.executeBindings(this,"backgroundFill",this.backgroundFill);
         return _loc1_;
      }
      
      private function _SparkChromeWindowedApplicationSkin_Rect2_i() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.left = 0;
         _loc1_.right = 0;
         _loc1_.top = 0;
         _loc1_.height = 24;
         _loc1_.fill = this._SparkChromeWindowedApplicationSkin_SolidColor2_i();
         _loc1_.initialized(this,"titleBarBackgroundRect");
         this.titleBarBackgroundRect = _loc1_;
         BindingManager.executeBindings(this,"titleBarBackgroundRect",this.titleBarBackgroundRect);
         return _loc1_;
      }
      
      private function _SparkChromeWindowedApplicationSkin_SolidColor2_i() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         _loc1_.color = 16777215;
         this.titleBarBgFill = _loc1_;
         BindingManager.executeBindings(this,"titleBarBgFill",this.titleBarBgFill);
         return _loc1_;
      }
      
      private function _SparkChromeWindowedApplicationSkin_Group1_c() : Group
      {
         var _loc1_:Group = new Group();
         _loc1_.left = 1;
         _loc1_.right = 1;
         _loc1_.top = 1;
         _loc1_.bottom = 1;
         _loc1_.minHeight = 24;
         _loc1_.minWidth = 0;
         _loc1_.layout = this._SparkChromeWindowedApplicationSkin_VerticalLayout1_c();
         _loc1_.mxmlContent = [this._SparkChromeWindowedApplicationSkin_TitleBar1_i(),this._SparkChromeWindowedApplicationSkin_Group2_i(),this._SparkChromeWindowedApplicationSkin_Group3_i()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _SparkChromeWindowedApplicationSkin_VerticalLayout1_c() : VerticalLayout
      {
         var _loc1_:VerticalLayout = new VerticalLayout();
         _loc1_.gap = 0;
         return _loc1_;
      }
      
      private function _SparkChromeWindowedApplicationSkin_TitleBar1_i() : TitleBar
      {
         var _loc1_:TitleBar = new TitleBar();
         _loc1_.percentWidth = 100;
         _loc1_.minHeight = 24;
         _loc1_.id = "titleBar";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.titleBar = _loc1_;
         BindingManager.executeBindings(this,"titleBar",this.titleBar);
         return _loc1_;
      }
      
      private function _SparkChromeWindowedApplicationSkin_Group2_i() : Group
      {
         var _loc1_:Group = new Group();
         _loc1_.percentWidth = 100;
         _loc1_.percentHeight = 100;
         _loc1_.minHeight = 0;
         _loc1_.minWidth = 0;
         _loc1_.id = "contentGroup";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.contentGroup = _loc1_;
         BindingManager.executeBindings(this,"contentGroup",this.contentGroup);
         return _loc1_;
      }
      
      private function _SparkChromeWindowedApplicationSkin_Group3_i() : Group
      {
         var _loc1_:Group = new Group();
         _loc1_.percentWidth = 100;
         _loc1_.minHeight = 24;
         _loc1_.mxmlContent = [this._SparkChromeWindowedApplicationSkin_Rect3_c(),this._SparkChromeWindowedApplicationSkin_Rect4_c(),this._SparkChromeWindowedApplicationSkin_Label1_i()];
         _loc1_.id = "statusBar";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.statusBar = _loc1_;
         BindingManager.executeBindings(this,"statusBar",this.statusBar);
         return _loc1_;
      }
      
      private function _SparkChromeWindowedApplicationSkin_Rect3_c() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.left = 0;
         _loc1_.right = 0;
         _loc1_.top = 0;
         _loc1_.bottom = 0;
         _loc1_.fill = this._SparkChromeWindowedApplicationSkin_LinearGradient1_c();
         _loc1_.initialized(this,null);
         return _loc1_;
      }
      
      private function _SparkChromeWindowedApplicationSkin_LinearGradient1_c() : LinearGradient
      {
         var _loc1_:LinearGradient = new LinearGradient();
         _loc1_.rotation = 90;
         _loc1_.entries = [this._SparkChromeWindowedApplicationSkin_GradientEntry1_c(),this._SparkChromeWindowedApplicationSkin_GradientEntry2_c()];
         return _loc1_;
      }
      
      private function _SparkChromeWindowedApplicationSkin_GradientEntry1_c() : GradientEntry
      {
         var _loc1_:GradientEntry = new GradientEntry();
         _loc1_.color = 14869218;
         return _loc1_;
      }
      
      private function _SparkChromeWindowedApplicationSkin_GradientEntry2_c() : GradientEntry
      {
         var _loc1_:GradientEntry = new GradientEntry();
         _loc1_.color = 14277081;
         return _loc1_;
      }
      
      private function _SparkChromeWindowedApplicationSkin_Rect4_c() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.left = 1;
         _loc1_.right = 1;
         _loc1_.top = 1;
         _loc1_.bottom = 0;
         _loc1_.stroke = this._SparkChromeWindowedApplicationSkin_LinearGradientStroke1_c();
         _loc1_.initialized(this,null);
         return _loc1_;
      }
      
      private function _SparkChromeWindowedApplicationSkin_LinearGradientStroke1_c() : LinearGradientStroke
      {
         var _loc1_:LinearGradientStroke = new LinearGradientStroke();
         _loc1_.rotation = 90;
         _loc1_.weight = 1;
         _loc1_.entries = [this._SparkChromeWindowedApplicationSkin_GradientEntry3_c(),this._SparkChromeWindowedApplicationSkin_GradientEntry4_c()];
         return _loc1_;
      }
      
      private function _SparkChromeWindowedApplicationSkin_GradientEntry3_c() : GradientEntry
      {
         var _loc1_:GradientEntry = new GradientEntry();
         _loc1_.color = 15395562;
         return _loc1_;
      }
      
      private function _SparkChromeWindowedApplicationSkin_GradientEntry4_c() : GradientEntry
      {
         var _loc1_:GradientEntry = new GradientEntry();
         _loc1_.color = 12500670;
         return _loc1_;
      }
      
      private function _SparkChromeWindowedApplicationSkin_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.top = 2;
         _loc1_.bottom = 2;
         _loc1_.left = 10;
         _loc1_.right = 10;
         _loc1_.percentWidth = 100;
         _loc1_.maxDisplayedLines = 1;
         _loc1_.setStyle("verticalAlign","middle");
         _loc1_.setStyle("fontSize",10);
         _loc1_.setStyle("color",5789784);
         _loc1_.id = "statusText";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.statusText = _loc1_;
         BindingManager.executeBindings(this,"statusText",this.statusText);
         return _loc1_;
      }
      
      private function _SparkChromeWindowedApplicationSkin_Button1_i() : Button
      {
         var _loc1_:Button = new Button();
         _loc1_.right = 3;
         _loc1_.bottom = 3;
         _loc1_.tabEnabled = false;
         _loc1_.setStyle("skinClass",GripperSkin);
         _loc1_.id = "gripper";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.gripper = _loc1_;
         BindingManager.executeBindings(this,"gripper",this.gripper);
         return _loc1_;
      }
      
      private function _SparkChromeWindowedApplicationSkin_Group4_i() : Group
      {
         var _loc1_:Group = new Group();
         _loc1_.left = 0;
         _loc1_.right = 0;
         _loc1_.top = 0;
         _loc1_.bottom = 0;
         _loc1_.mxmlContent = [this._SparkChromeWindowedApplicationSkin_Rect5_c()];
         _loc1_.id = "borderBgFill";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.borderBgFill = _loc1_;
         BindingManager.executeBindings(this,"borderBgFill",this.borderBgFill);
         return _loc1_;
      }
      
      private function _SparkChromeWindowedApplicationSkin_Rect5_c() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.left = 0;
         _loc1_.right = 0;
         _loc1_.top = 0;
         _loc1_.bottom = 0;
         _loc1_.stroke = this._SparkChromeWindowedApplicationSkin_SolidColorStroke1_c();
         _loc1_.initialized(this,null);
         return _loc1_;
      }
      
      private function _SparkChromeWindowedApplicationSkin_SolidColorStroke1_c() : SolidColorStroke
      {
         var _loc1_:SolidColorStroke = new SolidColorStroke();
         _loc1_.weight = 1;
         _loc1_.color = 16777215;
         return _loc1_;
      }
      
      private function _SparkChromeWindowedApplicationSkin_Rect6_c() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.left = 0;
         _loc1_.right = 0;
         _loc1_.top = 0;
         _loc1_.bottom = 0;
         _loc1_.stroke = this._SparkChromeWindowedApplicationSkin_SolidColorStroke2_i();
         _loc1_.initialized(this,null);
         return _loc1_;
      }
      
      private function _SparkChromeWindowedApplicationSkin_SolidColorStroke2_i() : SolidColorStroke
      {
         var _loc1_:SolidColorStroke = new SolidColorStroke();
         _loc1_.weight = 1;
         _loc1_.color = 10921638;
         this._SparkChromeWindowedApplicationSkin_SolidColorStroke2 = _loc1_;
         BindingManager.executeBindings(this,"_SparkChromeWindowedApplicationSkin_SolidColorStroke2",this._SparkChromeWindowedApplicationSkin_SolidColorStroke2);
         return _loc1_;
      }
      
      private function _SparkChromeWindowedApplicationSkin_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():Boolean
         {
            return titleBar.visible;
         },null,"titleBarBackgroundRect.visible");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      [Inspectable]
      public function get _SparkChromeWindowedApplicationSkin_SolidColorStroke2() : SolidColorStroke
      {
         return this._971275177_SparkChromeWindowedApplicationSkin_SolidColorStroke2;
      }
      
      public function set _SparkChromeWindowedApplicationSkin_SolidColorStroke2(param1:SolidColorStroke) : void
      {
         var _loc2_:Object = this._971275177_SparkChromeWindowedApplicationSkin_SolidColorStroke2;
         if(_loc2_ !== param1)
         {
            this._971275177_SparkChromeWindowedApplicationSkin_SolidColorStroke2 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_SparkChromeWindowedApplicationSkin_SolidColorStroke2",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get backgroundFill() : SolidColor
      {
         return this._1427077073backgroundFill;
      }
      
      public function set backgroundFill(param1:SolidColor) : void
      {
         var _loc2_:Object = this._1427077073backgroundFill;
         if(_loc2_ !== param1)
         {
            this._1427077073backgroundFill = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"backgroundFill",_loc2_,param1));
            }
         }
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
      public function get borderBgFill() : Group
      {
         return this._895769268borderBgFill;
      }
      
      public function set borderBgFill(param1:Group) : void
      {
         var _loc2_:Object = this._895769268borderBgFill;
         if(_loc2_ !== param1)
         {
            this._895769268borderBgFill = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"borderBgFill",_loc2_,param1));
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
      public function get gripper() : Button
      {
         return this._287739019gripper;
      }
      
      public function set gripper(param1:Button) : void
      {
         var _loc2_:Object = this._287739019gripper;
         if(_loc2_ !== param1)
         {
            this._287739019gripper = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"gripper",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get statusBar() : Group
      {
         return this._2070227263statusBar;
      }
      
      public function set statusBar(param1:Group) : void
      {
         var _loc2_:Object = this._2070227263statusBar;
         if(_loc2_ !== param1)
         {
            this._2070227263statusBar = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"statusBar",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get statusText() : Label
      {
         return this._248004671statusText;
      }
      
      public function set statusText(param1:Label) : void
      {
         var _loc2_:Object = this._248004671statusText;
         if(_loc2_ !== param1)
         {
            this._248004671statusText = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"statusText",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get titleBar() : TitleBar
      {
         return this._1870028133titleBar;
      }
      
      public function set titleBar(param1:TitleBar) : void
      {
         var _loc2_:Object = this._1870028133titleBar;
         if(_loc2_ !== param1)
         {
            this._1870028133titleBar = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"titleBar",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get titleBarBackgroundRect() : Rect
      {
         return this._952426579titleBarBackgroundRect;
      }
      
      public function set titleBarBackgroundRect(param1:Rect) : void
      {
         var _loc2_:Object = this._952426579titleBarBackgroundRect;
         if(_loc2_ !== param1)
         {
            this._952426579titleBarBackgroundRect = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"titleBarBackgroundRect",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get titleBarBgFill() : SolidColor
      {
         return this._1964685795titleBarBgFill;
      }
      
      public function set titleBarBgFill(param1:SolidColor) : void
      {
         var _loc2_:Object = this._1964685795titleBarBgFill;
         if(_loc2_ !== param1)
         {
            this._1964685795titleBarBgFill = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"titleBarBgFill",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get hostComponent() : Object
      {
         return this._213507019hostComponent;
      }
      
      public function set hostComponent(param1:Object) : void
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

