package mx.skins.spark
{
   import mx.binding.BindingManager;
   import mx.core.DeferredInstanceFromFunction;
   import mx.core.IFlexModuleFactory;
   import mx.core.IStateClient2;
   import mx.events.PropertyChangeEvent;
   import mx.graphics.GradientEntry;
   import mx.graphics.LinearGradient;
   import mx.graphics.LinearGradientStroke;
   import mx.graphics.RadialGradient;
   import mx.graphics.SolidColor;
   import mx.graphics.SolidColorStroke;
   import mx.states.AddItems;
   import mx.states.SetProperty;
   import mx.states.State;
   import spark.components.Group;
   import spark.primitives.Path;
   import spark.primitives.Rect;
   import spark.skins.SparkSkin;
   
   [States("disabled")]
   public class ColorPickerSkin extends SparkSkin implements IStateClient2
   {
      
      private static const exclusions:Array = ["arrow"];
      
      private static const symbols:Array = ["arrowFill1","arrowFill2"];
      
      private var _1136555233_ColorPickerSkin_GradientEntry1:GradientEntry;
      
      private var _873473807_ColorPickerSkin_GradientEntry10:GradientEntry;
      
      private var _1136555232_ColorPickerSkin_GradientEntry2:GradientEntry;
      
      private var _1136555231_ColorPickerSkin_GradientEntry3:GradientEntry;
      
      private var _1136555230_ColorPickerSkin_GradientEntry4:GradientEntry;
      
      private var _1136555229_ColorPickerSkin_GradientEntry5:GradientEntry;
      
      private var _1136555228_ColorPickerSkin_GradientEntry6:GradientEntry;
      
      private var _1136555227_ColorPickerSkin_GradientEntry7:GradientEntry;
      
      private var _1136555226_ColorPickerSkin_GradientEntry8:GradientEntry;
      
      private var _1136555225_ColorPickerSkin_GradientEntry9:GradientEntry;
      
      private var _19304606_ColorPickerSkin_Group1:Group;
      
      [Inspectable]
      public var _ColorPickerSkin_Rect15:Rect;
      
      [Inspectable]
      public var _ColorPickerSkin_Rect16:Rect;
      
      [Inspectable]
      public var _ColorPickerSkin_Rect17:Rect;
      
      [Inspectable]
      public var _ColorPickerSkin_Rect18:Rect;
      
      [Inspectable]
      public var _ColorPickerSkin_Rect20:Rect;
      
      private var _1632964630_ColorPickerSkin_SolidColor2:SolidColor;
      
      private var _1632964629_ColorPickerSkin_SolidColor3:SolidColor;
      
      private var _93090825arrow:Path;
      
      private var _1752992635arrowFill1:GradientEntry;
      
      private var _1752992634arrowFill2:GradientEntry;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      public function ColorPickerSkin()
      {
         super();
         mx_internal::_document = this;
         this.mxmlContent = [this._ColorPickerSkin_Rect1_c(),this._ColorPickerSkin_Rect2_c(),this._ColorPickerSkin_Group1_i()];
         this.currentState = "up";
         var _loc1_:DeferredInstanceFromFunction = new DeferredInstanceFromFunction(this._ColorPickerSkin_Rect16_i);
         var _loc2_:DeferredInstanceFromFunction = new DeferredInstanceFromFunction(this._ColorPickerSkin_Rect17_i);
         var _loc3_:DeferredInstanceFromFunction = new DeferredInstanceFromFunction(this._ColorPickerSkin_Rect18_i);
         var _loc4_:DeferredInstanceFromFunction = new DeferredInstanceFromFunction(this._ColorPickerSkin_Rect20_i);
         states = [new State({
            "name":"up",
            "overrides":[]
         }),new State({
            "name":"over",
            "overrides":[]
         }),new State({
            "name":"down",
            "overrides":[new AddItems().initializeFromObject({
               "itemsFactory":_loc3_,
               "destination":"_ColorPickerSkin_Group1",
               "propertyName":"mxmlContent",
               "position":"after",
               "relativeTo":["_ColorPickerSkin_Rect15"]
            }),new AddItems().initializeFromObject({
               "itemsFactory":_loc2_,
               "destination":"_ColorPickerSkin_Group1",
               "propertyName":"mxmlContent",
               "position":"after",
               "relativeTo":["_ColorPickerSkin_Rect15"]
            }),new AddItems().initializeFromObject({
               "itemsFactory":_loc1_,
               "destination":"_ColorPickerSkin_Group1",
               "propertyName":"mxmlContent",
               "position":"after",
               "relativeTo":["_ColorPickerSkin_Rect15"]
            }),new SetProperty().initializeFromObject({
               "target":"_ColorPickerSkin_GradientEntry1",
               "name":"color",
               "value":16777215
            }),new SetProperty().initializeFromObject({
               "target":"_ColorPickerSkin_GradientEntry1",
               "name":"alpha",
               "value":0
            }),new SetProperty().initializeFromObject({
               "target":"_ColorPickerSkin_GradientEntry2",
               "name":"color",
               "value":16777215
            }),new SetProperty().initializeFromObject({
               "target":"_ColorPickerSkin_GradientEntry2",
               "name":"alpha",
               "value":0.5
            }),new SetProperty().initializeFromObject({
               "target":"_ColorPickerSkin_GradientEntry3",
               "name":"alpha",
               "value":0.6375
            }),new SetProperty().initializeFromObject({
               "target":"_ColorPickerSkin_GradientEntry4",
               "name":"alpha",
               "value":0.85
            }),new SetProperty().initializeFromObject({
               "target":"_ColorPickerSkin_GradientEntry5",
               "name":"color",
               "value":13290186
            }),new SetProperty().initializeFromObject({
               "target":"_ColorPickerSkin_GradientEntry6",
               "name":"color",
               "value":8882055
            }),new SetProperty().initializeFromObject({
               "target":"_ColorPickerSkin_GradientEntry7",
               "name":"color",
               "value":13290186
            }),new SetProperty().initializeFromObject({
               "target":"_ColorPickerSkin_GradientEntry8",
               "name":"color",
               "value":8882055
            }),new SetProperty().initializeFromObject({
               "target":"_ColorPickerSkin_SolidColor2",
               "name":"color",
               "value":13290186
            }),new SetProperty().initializeFromObject({
               "target":"_ColorPickerSkin_SolidColor3",
               "name":"color",
               "value":8882055
            }),new SetProperty().initializeFromObject({
               "target":"_ColorPickerSkin_GradientEntry9",
               "name":"color",
               "value":11119017
            }),new SetProperty().initializeFromObject({
               "target":"_ColorPickerSkin_GradientEntry10",
               "name":"color",
               "value":10263708
            })]
         }),new State({
            "name":"disabled",
            "overrides":[new AddItems().initializeFromObject({
               "itemsFactory":_loc4_,
               "destination":null,
               "propertyName":"mxmlContent",
               "position":"after",
               "relativeTo":["_ColorPickerSkin_Group1"]
            })]
         })];
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
      
      override public function get symbolItems() : Array
      {
         return symbols;
      }
      
      override protected function initializationComplete() : void
      {
         useChromeColor = true;
         super.initializationComplete();
      }
      
      private function _ColorPickerSkin_Rect1_c() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.left = 0;
         _loc1_.right = 0;
         _loc1_.top = 0;
         _loc1_.bottom = 0;
         _loc1_.stroke = this._ColorPickerSkin_SolidColorStroke1_c();
         _loc1_.initialized(this,null);
         return _loc1_;
      }
      
      private function _ColorPickerSkin_SolidColorStroke1_c() : SolidColorStroke
      {
         var _loc1_:SolidColorStroke = new SolidColorStroke();
         _loc1_.color = 16777215;
         _loc1_.weight = 2;
         return _loc1_;
      }
      
      private function _ColorPickerSkin_Rect2_c() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.right = 2;
         _loc1_.bottom = 2;
         _loc1_.width = 7;
         _loc1_.height = 5;
         _loc1_.fill = this._ColorPickerSkin_SolidColor1_c();
         _loc1_.initialized(this,null);
         return _loc1_;
      }
      
      private function _ColorPickerSkin_SolidColor1_c() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         _loc1_.color = 16777215;
         return _loc1_;
      }
      
      private function _ColorPickerSkin_Group1_i() : Group
      {
         var _loc1_:Group = new Group();
         _loc1_.left = 0;
         _loc1_.right = 0;
         _loc1_.top = 0;
         _loc1_.bottom = 0;
         _loc1_.mxmlContent = [this._ColorPickerSkin_Rect3_c(),this._ColorPickerSkin_Rect4_c(),this._ColorPickerSkin_Rect5_c(),this._ColorPickerSkin_Rect6_c(),this._ColorPickerSkin_Rect7_c(),this._ColorPickerSkin_Rect8_c(),this._ColorPickerSkin_Rect9_c(),this._ColorPickerSkin_Rect10_c(),this._ColorPickerSkin_Rect11_c(),this._ColorPickerSkin_Rect12_c(),this._ColorPickerSkin_Rect13_c(),this._ColorPickerSkin_Rect14_c(),this._ColorPickerSkin_Rect15_i(),this._ColorPickerSkin_Rect19_c(),this._ColorPickerSkin_Path1_i()];
         _loc1_.id = "_ColorPickerSkin_Group1";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._ColorPickerSkin_Group1 = _loc1_;
         BindingManager.executeBindings(this,"_ColorPickerSkin_Group1",this._ColorPickerSkin_Group1);
         return _loc1_;
      }
      
      private function _ColorPickerSkin_Rect3_c() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.left = -1;
         _loc1_.right = -1;
         _loc1_.top = -1;
         _loc1_.bottom = -1;
         _loc1_.stroke = this._ColorPickerSkin_LinearGradientStroke1_c();
         _loc1_.initialized(this,null);
         return _loc1_;
      }
      
      private function _ColorPickerSkin_LinearGradientStroke1_c() : LinearGradientStroke
      {
         var _loc1_:LinearGradientStroke = new LinearGradientStroke();
         _loc1_.rotation = 90;
         _loc1_.entries = [this._ColorPickerSkin_GradientEntry1_i(),this._ColorPickerSkin_GradientEntry2_i()];
         return _loc1_;
      }
      
      private function _ColorPickerSkin_GradientEntry1_i() : GradientEntry
      {
         var _loc1_:GradientEntry = new GradientEntry();
         _loc1_.color = 0;
         _loc1_.alpha = 0.02;
         this._ColorPickerSkin_GradientEntry1 = _loc1_;
         BindingManager.executeBindings(this,"_ColorPickerSkin_GradientEntry1",this._ColorPickerSkin_GradientEntry1);
         return _loc1_;
      }
      
      private function _ColorPickerSkin_GradientEntry2_i() : GradientEntry
      {
         var _loc1_:GradientEntry = new GradientEntry();
         _loc1_.color = 0;
         _loc1_.alpha = 0.22;
         this._ColorPickerSkin_GradientEntry2 = _loc1_;
         BindingManager.executeBindings(this,"_ColorPickerSkin_GradientEntry2",this._ColorPickerSkin_GradientEntry2);
         return _loc1_;
      }
      
      private function _ColorPickerSkin_Rect4_c() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.left = 0;
         _loc1_.right = 0;
         _loc1_.top = 0;
         _loc1_.bottom = 0;
         _loc1_.stroke = this._ColorPickerSkin_LinearGradientStroke2_c();
         _loc1_.initialized(this,null);
         return _loc1_;
      }
      
      private function _ColorPickerSkin_LinearGradientStroke2_c() : LinearGradientStroke
      {
         var _loc1_:LinearGradientStroke = new LinearGradientStroke();
         _loc1_.rotation = 90;
         _loc1_.entries = [this._ColorPickerSkin_GradientEntry3_i(),this._ColorPickerSkin_GradientEntry4_i()];
         return _loc1_;
      }
      
      private function _ColorPickerSkin_GradientEntry3_i() : GradientEntry
      {
         var _loc1_:GradientEntry = new GradientEntry();
         _loc1_.color = 0;
         _loc1_.alpha = 0.75;
         this._ColorPickerSkin_GradientEntry3 = _loc1_;
         BindingManager.executeBindings(this,"_ColorPickerSkin_GradientEntry3",this._ColorPickerSkin_GradientEntry3);
         return _loc1_;
      }
      
      private function _ColorPickerSkin_GradientEntry4_i() : GradientEntry
      {
         var _loc1_:GradientEntry = new GradientEntry();
         _loc1_.color = 1513239;
         _loc1_.alpha = 1;
         this._ColorPickerSkin_GradientEntry4 = _loc1_;
         BindingManager.executeBindings(this,"_ColorPickerSkin_GradientEntry4",this._ColorPickerSkin_GradientEntry4);
         return _loc1_;
      }
      
      private function _ColorPickerSkin_Rect5_c() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.left = 1;
         _loc1_.top = 1;
         _loc1_.bottom = 1;
         _loc1_.width = 2;
         _loc1_.fill = this._ColorPickerSkin_LinearGradient1_c();
         _loc1_.initialized(this,null);
         return _loc1_;
      }
      
      private function _ColorPickerSkin_LinearGradient1_c() : LinearGradient
      {
         var _loc1_:LinearGradient = new LinearGradient();
         _loc1_.rotation = 90;
         _loc1_.entries = [this._ColorPickerSkin_GradientEntry5_i(),this._ColorPickerSkin_GradientEntry6_i()];
         return _loc1_;
      }
      
      private function _ColorPickerSkin_GradientEntry5_i() : GradientEntry
      {
         var _loc1_:GradientEntry = new GradientEntry();
         _loc1_.color = 16777215;
         _loc1_.alpha = 1;
         this._ColorPickerSkin_GradientEntry5 = _loc1_;
         BindingManager.executeBindings(this,"_ColorPickerSkin_GradientEntry5",this._ColorPickerSkin_GradientEntry5);
         return _loc1_;
      }
      
      private function _ColorPickerSkin_GradientEntry6_i() : GradientEntry
      {
         var _loc1_:GradientEntry = new GradientEntry();
         _loc1_.color = 14211288;
         _loc1_.alpha = 1;
         this._ColorPickerSkin_GradientEntry6 = _loc1_;
         BindingManager.executeBindings(this,"_ColorPickerSkin_GradientEntry6",this._ColorPickerSkin_GradientEntry6);
         return _loc1_;
      }
      
      private function _ColorPickerSkin_Rect6_c() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.right = 1;
         _loc1_.top = 1;
         _loc1_.bottom = 1;
         _loc1_.width = 2;
         _loc1_.fill = this._ColorPickerSkin_LinearGradient2_c();
         _loc1_.initialized(this,null);
         return _loc1_;
      }
      
      private function _ColorPickerSkin_LinearGradient2_c() : LinearGradient
      {
         var _loc1_:LinearGradient = new LinearGradient();
         _loc1_.rotation = 90;
         _loc1_.entries = [this._ColorPickerSkin_GradientEntry7_i(),this._ColorPickerSkin_GradientEntry8_i()];
         return _loc1_;
      }
      
      private function _ColorPickerSkin_GradientEntry7_i() : GradientEntry
      {
         var _loc1_:GradientEntry = new GradientEntry();
         _loc1_.color = 16777215;
         _loc1_.alpha = 1;
         this._ColorPickerSkin_GradientEntry7 = _loc1_;
         BindingManager.executeBindings(this,"_ColorPickerSkin_GradientEntry7",this._ColorPickerSkin_GradientEntry7);
         return _loc1_;
      }
      
      private function _ColorPickerSkin_GradientEntry8_i() : GradientEntry
      {
         var _loc1_:GradientEntry = new GradientEntry();
         _loc1_.color = 14211288;
         _loc1_.alpha = 1;
         this._ColorPickerSkin_GradientEntry8 = _loc1_;
         BindingManager.executeBindings(this,"_ColorPickerSkin_GradientEntry8",this._ColorPickerSkin_GradientEntry8);
         return _loc1_;
      }
      
      private function _ColorPickerSkin_Rect7_c() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.left = 3;
         _loc1_.top = 1;
         _loc1_.right = 3;
         _loc1_.height = 2;
         _loc1_.fill = this._ColorPickerSkin_SolidColor2_i();
         _loc1_.initialized(this,null);
         return _loc1_;
      }
      
      private function _ColorPickerSkin_SolidColor2_i() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         _loc1_.color = 16777215;
         _loc1_.alpha = 1;
         this._ColorPickerSkin_SolidColor2 = _loc1_;
         BindingManager.executeBindings(this,"_ColorPickerSkin_SolidColor2",this._ColorPickerSkin_SolidColor2);
         return _loc1_;
      }
      
      private function _ColorPickerSkin_Rect8_c() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.left = 3;
         _loc1_.bottom = 1;
         _loc1_.right = 3;
         _loc1_.height = 2;
         _loc1_.fill = this._ColorPickerSkin_SolidColor3_i();
         _loc1_.initialized(this,null);
         return _loc1_;
      }
      
      private function _ColorPickerSkin_SolidColor3_i() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         _loc1_.color = 14211288;
         _loc1_.alpha = 1;
         this._ColorPickerSkin_SolidColor3 = _loc1_;
         BindingManager.executeBindings(this,"_ColorPickerSkin_SolidColor3",this._ColorPickerSkin_SolidColor3);
         return _loc1_;
      }
      
      private function _ColorPickerSkin_Rect9_c() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.right = 3;
         _loc1_.bottom = 3;
         _loc1_.height = 5;
         _loc1_.width = 7;
         _loc1_.fill = this._ColorPickerSkin_LinearGradient3_c();
         _loc1_.initialized(this,null);
         return _loc1_;
      }
      
      private function _ColorPickerSkin_LinearGradient3_c() : LinearGradient
      {
         var _loc1_:LinearGradient = new LinearGradient();
         _loc1_.rotation = 90;
         _loc1_.entries = [this._ColorPickerSkin_GradientEntry9_i(),this._ColorPickerSkin_GradientEntry10_i()];
         return _loc1_;
      }
      
      private function _ColorPickerSkin_GradientEntry9_i() : GradientEntry
      {
         var _loc1_:GradientEntry = new GradientEntry();
         _loc1_.color = 15658734;
         _loc1_.alpha = 1;
         this._ColorPickerSkin_GradientEntry9 = _loc1_;
         BindingManager.executeBindings(this,"_ColorPickerSkin_GradientEntry9",this._ColorPickerSkin_GradientEntry9);
         return _loc1_;
      }
      
      private function _ColorPickerSkin_GradientEntry10_i() : GradientEntry
      {
         var _loc1_:GradientEntry = new GradientEntry();
         _loc1_.color = 14211288;
         _loc1_.alpha = 1;
         this._ColorPickerSkin_GradientEntry10 = _loc1_;
         BindingManager.executeBindings(this,"_ColorPickerSkin_GradientEntry10",this._ColorPickerSkin_GradientEntry10);
         return _loc1_;
      }
      
      private function _ColorPickerSkin_Rect10_c() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.left = 3;
         _loc1_.width = 1;
         _loc1_.top = 3;
         _loc1_.bottom = 3;
         _loc1_.fill = this._ColorPickerSkin_SolidColor4_c();
         _loc1_.initialized(this,null);
         return _loc1_;
      }
      
      private function _ColorPickerSkin_SolidColor4_c() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         _loc1_.color = 0;
         _loc1_.alpha = 0.33;
         return _loc1_;
      }
      
      private function _ColorPickerSkin_Rect11_c() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.width = 1;
         _loc1_.right = 3;
         _loc1_.top = 3;
         _loc1_.bottom = 8;
         _loc1_.fill = this._ColorPickerSkin_SolidColor5_c();
         _loc1_.initialized(this,null);
         return _loc1_;
      }
      
      private function _ColorPickerSkin_SolidColor5_c() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         _loc1_.color = 0;
         _loc1_.alpha = 0.33;
         return _loc1_;
      }
      
      private function _ColorPickerSkin_Rect12_c() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.left = 4;
         _loc1_.right = 4;
         _loc1_.top = 3;
         _loc1_.height = 1;
         _loc1_.fill = this._ColorPickerSkin_SolidColor6_c();
         _loc1_.initialized(this,null);
         return _loc1_;
      }
      
      private function _ColorPickerSkin_SolidColor6_c() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         _loc1_.color = 0;
         _loc1_.alpha = 0.33;
         return _loc1_;
      }
      
      private function _ColorPickerSkin_Rect13_c() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.left = 4;
         _loc1_.right = 10;
         _loc1_.bottom = 3;
         _loc1_.height = 1;
         _loc1_.fill = this._ColorPickerSkin_SolidColor7_c();
         _loc1_.initialized(this,null);
         return _loc1_;
      }
      
      private function _ColorPickerSkin_SolidColor7_c() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         _loc1_.color = 0;
         _loc1_.alpha = 0.33;
         return _loc1_;
      }
      
      private function _ColorPickerSkin_Rect14_c() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.width = 7;
         _loc1_.right = 4;
         _loc1_.bottom = 8;
         _loc1_.height = 1;
         _loc1_.fill = this._ColorPickerSkin_SolidColor8_c();
         _loc1_.initialized(this,null);
         return _loc1_;
      }
      
      private function _ColorPickerSkin_SolidColor8_c() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         _loc1_.color = 0;
         _loc1_.alpha = 0.33;
         return _loc1_;
      }
      
      private function _ColorPickerSkin_Rect15_i() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.right = 10;
         _loc1_.width = 1;
         _loc1_.height = 4;
         _loc1_.bottom = 4;
         _loc1_.fill = this._ColorPickerSkin_SolidColor9_c();
         _loc1_.initialized(this,"_ColorPickerSkin_Rect15");
         this._ColorPickerSkin_Rect15 = _loc1_;
         BindingManager.executeBindings(this,"_ColorPickerSkin_Rect15",this._ColorPickerSkin_Rect15);
         return _loc1_;
      }
      
      private function _ColorPickerSkin_SolidColor9_c() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         _loc1_.color = 0;
         _loc1_.alpha = 0.33;
         return _loc1_;
      }
      
      private function _ColorPickerSkin_Rect16_i() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.left = 1;
         _loc1_.width = 1;
         _loc1_.top = 1;
         _loc1_.bottom = 1;
         _loc1_.fill = this._ColorPickerSkin_SolidColor10_c();
         _loc1_.initialized(this,"_ColorPickerSkin_Rect16");
         this._ColorPickerSkin_Rect16 = _loc1_;
         BindingManager.executeBindings(this,"_ColorPickerSkin_Rect16",this._ColorPickerSkin_Rect16);
         return _loc1_;
      }
      
      private function _ColorPickerSkin_SolidColor10_c() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         _loc1_.color = 0;
         _loc1_.alpha = 0.12;
         return _loc1_;
      }
      
      private function _ColorPickerSkin_Rect17_i() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.width = 1;
         _loc1_.right = 1;
         _loc1_.top = 1;
         _loc1_.bottom = 1;
         _loc1_.fill = this._ColorPickerSkin_SolidColor11_c();
         _loc1_.initialized(this,"_ColorPickerSkin_Rect17");
         this._ColorPickerSkin_Rect17 = _loc1_;
         BindingManager.executeBindings(this,"_ColorPickerSkin_Rect17",this._ColorPickerSkin_Rect17);
         return _loc1_;
      }
      
      private function _ColorPickerSkin_SolidColor11_c() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         _loc1_.color = 0;
         _loc1_.alpha = 0.12;
         return _loc1_;
      }
      
      private function _ColorPickerSkin_Rect18_i() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.left = 2;
         _loc1_.right = 2;
         _loc1_.top = 1;
         _loc1_.height = 1;
         _loc1_.fill = this._ColorPickerSkin_SolidColor12_c();
         _loc1_.initialized(this,"_ColorPickerSkin_Rect18");
         this._ColorPickerSkin_Rect18 = _loc1_;
         BindingManager.executeBindings(this,"_ColorPickerSkin_Rect18",this._ColorPickerSkin_Rect18);
         return _loc1_;
      }
      
      private function _ColorPickerSkin_SolidColor12_c() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         _loc1_.color = 0;
         _loc1_.alpha = 0.12;
         return _loc1_;
      }
      
      private function _ColorPickerSkin_Rect19_c() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.left = 1;
         _loc1_.right = 1;
         _loc1_.top = 1;
         _loc1_.bottom = 1;
         _loc1_.fill = this._ColorPickerSkin_SolidColor13_c();
         _loc1_.initialized(this,null);
         return _loc1_;
      }
      
      private function _ColorPickerSkin_SolidColor13_c() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         _loc1_.color = 0;
         _loc1_.alpha = 0;
         return _loc1_;
      }
      
      private function _ColorPickerSkin_Path1_i() : Path
      {
         var _loc1_:Path = new Path();
         _loc1_.bottom = 3;
         _loc1_.right = 3;
         _loc1_.data = "M 0 0 L 0 1 L 1 1 L 1 2 L 2 2 L 2 3 L 3 3 L 3 2 L 4 2 L 4 1 L 5 1 L 5 0 L 0 0 Z ";
         _loc1_.fill = this._ColorPickerSkin_RadialGradient1_c();
         _loc1_.initialized(this,"arrow");
         this.arrow = _loc1_;
         BindingManager.executeBindings(this,"arrow",this.arrow);
         return _loc1_;
      }
      
      private function _ColorPickerSkin_RadialGradient1_c() : RadialGradient
      {
         var _loc1_:RadialGradient = new RadialGradient();
         _loc1_.rotation = 90;
         _loc1_.focalPointRatio = 1;
         _loc1_.entries = [this._ColorPickerSkin_GradientEntry11_i(),this._ColorPickerSkin_GradientEntry12_i()];
         return _loc1_;
      }
      
      private function _ColorPickerSkin_GradientEntry11_i() : GradientEntry
      {
         var _loc1_:GradientEntry = new GradientEntry();
         _loc1_.color = 0;
         _loc1_.alpha = 0.6;
         this.arrowFill1 = _loc1_;
         BindingManager.executeBindings(this,"arrowFill1",this.arrowFill1);
         return _loc1_;
      }
      
      private function _ColorPickerSkin_GradientEntry12_i() : GradientEntry
      {
         var _loc1_:GradientEntry = new GradientEntry();
         _loc1_.color = 0;
         _loc1_.alpha = 0.8;
         this.arrowFill2 = _loc1_;
         BindingManager.executeBindings(this,"arrowFill2",this.arrowFill2);
         return _loc1_;
      }
      
      private function _ColorPickerSkin_Rect20_i() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.left = 0;
         _loc1_.top = 0;
         _loc1_.right = 0;
         _loc1_.bottom = 0;
         _loc1_.fill = this._ColorPickerSkin_SolidColor14_c();
         _loc1_.initialized(this,"_ColorPickerSkin_Rect20");
         this._ColorPickerSkin_Rect20 = _loc1_;
         BindingManager.executeBindings(this,"_ColorPickerSkin_Rect20",this._ColorPickerSkin_Rect20);
         return _loc1_;
      }
      
      private function _ColorPickerSkin_SolidColor14_c() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         _loc1_.color = 16777215;
         _loc1_.alpha = 0.5;
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      [Inspectable]
      public function get _ColorPickerSkin_GradientEntry1() : GradientEntry
      {
         return this._1136555233_ColorPickerSkin_GradientEntry1;
      }
      
      public function set _ColorPickerSkin_GradientEntry1(param1:GradientEntry) : void
      {
         var _loc2_:Object = this._1136555233_ColorPickerSkin_GradientEntry1;
         if(_loc2_ !== param1)
         {
            this._1136555233_ColorPickerSkin_GradientEntry1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_ColorPickerSkin_GradientEntry1",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      [Inspectable]
      public function get _ColorPickerSkin_GradientEntry10() : GradientEntry
      {
         return this._873473807_ColorPickerSkin_GradientEntry10;
      }
      
      public function set _ColorPickerSkin_GradientEntry10(param1:GradientEntry) : void
      {
         var _loc2_:Object = this._873473807_ColorPickerSkin_GradientEntry10;
         if(_loc2_ !== param1)
         {
            this._873473807_ColorPickerSkin_GradientEntry10 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_ColorPickerSkin_GradientEntry10",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      [Inspectable]
      public function get _ColorPickerSkin_GradientEntry2() : GradientEntry
      {
         return this._1136555232_ColorPickerSkin_GradientEntry2;
      }
      
      public function set _ColorPickerSkin_GradientEntry2(param1:GradientEntry) : void
      {
         var _loc2_:Object = this._1136555232_ColorPickerSkin_GradientEntry2;
         if(_loc2_ !== param1)
         {
            this._1136555232_ColorPickerSkin_GradientEntry2 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_ColorPickerSkin_GradientEntry2",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      [Inspectable]
      public function get _ColorPickerSkin_GradientEntry3() : GradientEntry
      {
         return this._1136555231_ColorPickerSkin_GradientEntry3;
      }
      
      public function set _ColorPickerSkin_GradientEntry3(param1:GradientEntry) : void
      {
         var _loc2_:Object = this._1136555231_ColorPickerSkin_GradientEntry3;
         if(_loc2_ !== param1)
         {
            this._1136555231_ColorPickerSkin_GradientEntry3 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_ColorPickerSkin_GradientEntry3",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      [Inspectable]
      public function get _ColorPickerSkin_GradientEntry4() : GradientEntry
      {
         return this._1136555230_ColorPickerSkin_GradientEntry4;
      }
      
      public function set _ColorPickerSkin_GradientEntry4(param1:GradientEntry) : void
      {
         var _loc2_:Object = this._1136555230_ColorPickerSkin_GradientEntry4;
         if(_loc2_ !== param1)
         {
            this._1136555230_ColorPickerSkin_GradientEntry4 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_ColorPickerSkin_GradientEntry4",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      [Inspectable]
      public function get _ColorPickerSkin_GradientEntry5() : GradientEntry
      {
         return this._1136555229_ColorPickerSkin_GradientEntry5;
      }
      
      public function set _ColorPickerSkin_GradientEntry5(param1:GradientEntry) : void
      {
         var _loc2_:Object = this._1136555229_ColorPickerSkin_GradientEntry5;
         if(_loc2_ !== param1)
         {
            this._1136555229_ColorPickerSkin_GradientEntry5 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_ColorPickerSkin_GradientEntry5",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      [Inspectable]
      public function get _ColorPickerSkin_GradientEntry6() : GradientEntry
      {
         return this._1136555228_ColorPickerSkin_GradientEntry6;
      }
      
      public function set _ColorPickerSkin_GradientEntry6(param1:GradientEntry) : void
      {
         var _loc2_:Object = this._1136555228_ColorPickerSkin_GradientEntry6;
         if(_loc2_ !== param1)
         {
            this._1136555228_ColorPickerSkin_GradientEntry6 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_ColorPickerSkin_GradientEntry6",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      [Inspectable]
      public function get _ColorPickerSkin_GradientEntry7() : GradientEntry
      {
         return this._1136555227_ColorPickerSkin_GradientEntry7;
      }
      
      public function set _ColorPickerSkin_GradientEntry7(param1:GradientEntry) : void
      {
         var _loc2_:Object = this._1136555227_ColorPickerSkin_GradientEntry7;
         if(_loc2_ !== param1)
         {
            this._1136555227_ColorPickerSkin_GradientEntry7 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_ColorPickerSkin_GradientEntry7",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      [Inspectable]
      public function get _ColorPickerSkin_GradientEntry8() : GradientEntry
      {
         return this._1136555226_ColorPickerSkin_GradientEntry8;
      }
      
      public function set _ColorPickerSkin_GradientEntry8(param1:GradientEntry) : void
      {
         var _loc2_:Object = this._1136555226_ColorPickerSkin_GradientEntry8;
         if(_loc2_ !== param1)
         {
            this._1136555226_ColorPickerSkin_GradientEntry8 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_ColorPickerSkin_GradientEntry8",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      [Inspectable]
      public function get _ColorPickerSkin_GradientEntry9() : GradientEntry
      {
         return this._1136555225_ColorPickerSkin_GradientEntry9;
      }
      
      public function set _ColorPickerSkin_GradientEntry9(param1:GradientEntry) : void
      {
         var _loc2_:Object = this._1136555225_ColorPickerSkin_GradientEntry9;
         if(_loc2_ !== param1)
         {
            this._1136555225_ColorPickerSkin_GradientEntry9 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_ColorPickerSkin_GradientEntry9",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      [Inspectable]
      public function get _ColorPickerSkin_Group1() : Group
      {
         return this._19304606_ColorPickerSkin_Group1;
      }
      
      public function set _ColorPickerSkin_Group1(param1:Group) : void
      {
         var _loc2_:Object = this._19304606_ColorPickerSkin_Group1;
         if(_loc2_ !== param1)
         {
            this._19304606_ColorPickerSkin_Group1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_ColorPickerSkin_Group1",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      [Inspectable]
      public function get _ColorPickerSkin_SolidColor2() : SolidColor
      {
         return this._1632964630_ColorPickerSkin_SolidColor2;
      }
      
      public function set _ColorPickerSkin_SolidColor2(param1:SolidColor) : void
      {
         var _loc2_:Object = this._1632964630_ColorPickerSkin_SolidColor2;
         if(_loc2_ !== param1)
         {
            this._1632964630_ColorPickerSkin_SolidColor2 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_ColorPickerSkin_SolidColor2",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      [Inspectable]
      public function get _ColorPickerSkin_SolidColor3() : SolidColor
      {
         return this._1632964629_ColorPickerSkin_SolidColor3;
      }
      
      public function set _ColorPickerSkin_SolidColor3(param1:SolidColor) : void
      {
         var _loc2_:Object = this._1632964629_ColorPickerSkin_SolidColor3;
         if(_loc2_ !== param1)
         {
            this._1632964629_ColorPickerSkin_SolidColor3 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_ColorPickerSkin_SolidColor3",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get arrow() : Path
      {
         return this._93090825arrow;
      }
      
      public function set arrow(param1:Path) : void
      {
         var _loc2_:Object = this._93090825arrow;
         if(_loc2_ !== param1)
         {
            this._93090825arrow = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"arrow",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get arrowFill1() : GradientEntry
      {
         return this._1752992635arrowFill1;
      }
      
      public function set arrowFill1(param1:GradientEntry) : void
      {
         var _loc2_:Object = this._1752992635arrowFill1;
         if(_loc2_ !== param1)
         {
            this._1752992635arrowFill1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"arrowFill1",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get arrowFill2() : GradientEntry
      {
         return this._1752992634arrowFill2;
      }
      
      public function set arrowFill2(param1:GradientEntry) : void
      {
         var _loc2_:Object = this._1752992634arrowFill2;
         if(_loc2_ !== param1)
         {
            this._1752992634arrowFill2 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"arrowFill2",_loc2_,param1));
            }
         }
      }
   }
}

