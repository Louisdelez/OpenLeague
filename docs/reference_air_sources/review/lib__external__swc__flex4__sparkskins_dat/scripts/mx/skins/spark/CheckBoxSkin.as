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
   import mx.graphics.GradientEntry;
   import mx.graphics.LinearGradient;
   import mx.graphics.LinearGradientStroke;
   import mx.graphics.SolidColor;
   import mx.states.AddItems;
   import mx.states.SetProperty;
   import mx.states.State;
   import mx.styles.*;
   import spark.components.Group;
   import spark.primitives.Path;
   import spark.primitives.Rect;
   
   [States("selectedDisabled")]
   public class CheckBoxSkin extends SparkSkinForHalo implements IStateClient2
   {
      
      private static const exclusions:Array = ["check"];
      
      private static const symbols:Array = ["checkMarkFill"];
      
      private static const borderItem:Array = ["borderEntry1","borderEntry2"];
      
      private var _1574189039_CheckBoxSkin_GradientEntry1:GradientEntry;
      
      private var _1574189040_CheckBoxSkin_GradientEntry2:GradientEntry;
      
      private var _1574189041_CheckBoxSkin_GradientEntry3:GradientEntry;
      
      private var _1574189042_CheckBoxSkin_GradientEntry4:GradientEntry;
      
      private var _1574189043_CheckBoxSkin_GradientEntry5:GradientEntry;
      
      private var _1574189044_CheckBoxSkin_GradientEntry6:GradientEntry;
      
      private var _1997401138_CheckBoxSkin_Group1:Group;
      
      [Inspectable]
      public var _CheckBoxSkin_Rect3:Rect;
      
      [Inspectable]
      public var _CheckBoxSkin_Rect4:Rect;
      
      [Inspectable]
      public var _CheckBoxSkin_Rect5:Rect;
      
      [Inspectable]
      public var _CheckBoxSkin_Rect6:Rect;
      
      [Inspectable]
      public var _CheckBoxSkin_Rect7:Rect;
      
      [Inspectable]
      public var _CheckBoxSkin_Rect8:Rect;
      
      [Inspectable]
      public var _CheckBoxSkin_Rect9:Rect;
      
      private var _584316185_CheckBoxSkin_SolidColor1:SolidColor;
      
      private var _989500747borderEntry1:GradientEntry;
      
      private var _989500748borderEntry2:GradientEntry;
      
      private var _94627080check:Path;
      
      private var _1634270440checkMarkFill:SolidColor;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      public function CheckBoxSkin()
      {
         var _loc1_:DeferredInstanceFromFunction = null;
         super();
         mx_internal::_document = this;
         this.mxmlContent = [this._CheckBoxSkin_Group1_i()];
         this.currentState = "up";
         _loc1_ = new DeferredInstanceFromFunction(this._CheckBoxSkin_Path1_i);
         var _loc2_:DeferredInstanceFromFunction = new DeferredInstanceFromFunction(this._CheckBoxSkin_Rect4_i);
         var _loc3_:DeferredInstanceFromFunction = new DeferredInstanceFromFunction(this._CheckBoxSkin_Rect5_i);
         var _loc4_:DeferredInstanceFromFunction = new DeferredInstanceFromFunction(this._CheckBoxSkin_Rect6_i);
         var _loc5_:DeferredInstanceFromFunction = new DeferredInstanceFromFunction(this._CheckBoxSkin_Rect7_i);
         var _loc6_:DeferredInstanceFromFunction = new DeferredInstanceFromFunction(this._CheckBoxSkin_Rect8_i);
         states = [new State({
            "name":"up",
            "overrides":[new AddItems().initializeFromObject({
               "itemsFactory":_loc2_,
               "destination":"_CheckBoxSkin_Group1",
               "propertyName":"mxmlContent",
               "position":"after",
               "relativeTo":["_CheckBoxSkin_Rect3"]
            })]
         }),new State({
            "name":"over",
            "stateGroups":["overStates"],
            "overrides":[new AddItems().initializeFromObject({
               "itemsFactory":_loc2_,
               "destination":"_CheckBoxSkin_Group1",
               "propertyName":"mxmlContent",
               "position":"after",
               "relativeTo":["_CheckBoxSkin_Rect3"]
            }),new SetProperty().initializeFromObject({
               "target":"_CheckBoxSkin_GradientEntry3",
               "name":"color",
               "value":12303805
            }),new SetProperty().initializeFromObject({
               "target":"_CheckBoxSkin_GradientEntry4",
               "name":"color",
               "value":10461345
            }),new SetProperty().initializeFromObject({
               "target":"_CheckBoxSkin_GradientEntry5",
               "name":"alpha",
               "value":0.33
            }),new SetProperty().initializeFromObject({
               "target":"_CheckBoxSkin_GradientEntry6",
               "name":"alpha",
               "value":0.0396
            })]
         }),new State({
            "name":"down",
            "stateGroups":["downStates"],
            "overrides":[new AddItems().initializeFromObject({
               "itemsFactory":_loc6_,
               "destination":"_CheckBoxSkin_Group1",
               "propertyName":"mxmlContent",
               "position":"after",
               "relativeTo":["_CheckBoxSkin_Rect3"]
            }),new AddItems().initializeFromObject({
               "itemsFactory":_loc5_,
               "destination":"_CheckBoxSkin_Group1",
               "propertyName":"mxmlContent",
               "position":"after",
               "relativeTo":["_CheckBoxSkin_Rect3"]
            }),new AddItems().initializeFromObject({
               "itemsFactory":_loc4_,
               "destination":"_CheckBoxSkin_Group1",
               "propertyName":"mxmlContent",
               "position":"after",
               "relativeTo":["_CheckBoxSkin_Rect3"]
            }),new AddItems().initializeFromObject({
               "itemsFactory":_loc3_,
               "destination":"_CheckBoxSkin_Group1",
               "propertyName":"mxmlContent",
               "position":"after",
               "relativeTo":["_CheckBoxSkin_Rect3"]
            }),new SetProperty().initializeFromObject({
               "target":"_CheckBoxSkin_GradientEntry1",
               "name":"color",
               "value":16777215
            }),new SetProperty().initializeFromObject({
               "target":"_CheckBoxSkin_GradientEntry1",
               "name":"alpha",
               "value":0
            }),new SetProperty().initializeFromObject({
               "target":"_CheckBoxSkin_GradientEntry2",
               "name":"color",
               "value":16777215
            }),new SetProperty().initializeFromObject({
               "target":"_CheckBoxSkin_GradientEntry2",
               "name":"alpha",
               "value":0.57
            }),new SetProperty().initializeFromObject({
               "target":"_CheckBoxSkin_GradientEntry3",
               "name":"color",
               "value":11184810
            }),new SetProperty().initializeFromObject({
               "target":"_CheckBoxSkin_GradientEntry4",
               "name":"color",
               "value":9606294
            }),new SetProperty().initializeFromObject({
               "target":"_CheckBoxSkin_SolidColor1",
               "name":"alpha",
               "value":0
            }),new SetProperty().initializeFromObject({
               "target":"borderEntry1",
               "name":"alpha",
               "value":0.6375
            }),new SetProperty().initializeFromObject({
               "target":"borderEntry2",
               "name":"alpha",
               "value":0.85
            })]
         }),new State({
            "name":"disabled",
            "stateGroups":["disabledStates"],
            "overrides":[new AddItems().initializeFromObject({
               "itemsFactory":_loc2_,
               "destination":"_CheckBoxSkin_Group1",
               "propertyName":"mxmlContent",
               "position":"after",
               "relativeTo":["_CheckBoxSkin_Rect3"]
            })]
         }),new State({
            "name":"selectedUp",
            "stateGroups":["selectedStates"],
            "overrides":[new AddItems().initializeFromObject({
               "itemsFactory":_loc1_,
               "destination":"_CheckBoxSkin_Group1",
               "propertyName":"mxmlContent",
               "position":"after",
               "relativeTo":["_CheckBoxSkin_Rect9"]
            }),new AddItems().initializeFromObject({
               "itemsFactory":_loc2_,
               "destination":"_CheckBoxSkin_Group1",
               "propertyName":"mxmlContent",
               "position":"after",
               "relativeTo":["_CheckBoxSkin_Rect3"]
            })]
         }),new State({
            "name":"selectedOver",
            "stateGroups":["overStates","selectedStates"],
            "overrides":[new AddItems().initializeFromObject({
               "itemsFactory":_loc1_,
               "destination":"_CheckBoxSkin_Group1",
               "propertyName":"mxmlContent",
               "position":"after",
               "relativeTo":["_CheckBoxSkin_Rect9"]
            }),new AddItems().initializeFromObject({
               "itemsFactory":_loc2_,
               "destination":"_CheckBoxSkin_Group1",
               "propertyName":"mxmlContent",
               "position":"after",
               "relativeTo":["_CheckBoxSkin_Rect3"]
            }),new SetProperty().initializeFromObject({
               "target":"_CheckBoxSkin_GradientEntry3",
               "name":"color",
               "value":12303805
            }),new SetProperty().initializeFromObject({
               "target":"_CheckBoxSkin_GradientEntry4",
               "name":"color",
               "value":10461345
            }),new SetProperty().initializeFromObject({
               "target":"_CheckBoxSkin_GradientEntry5",
               "name":"alpha",
               "value":0.33
            }),new SetProperty().initializeFromObject({
               "target":"_CheckBoxSkin_GradientEntry6",
               "name":"alpha",
               "value":0.0396
            })]
         }),new State({
            "name":"selectedDown",
            "stateGroups":["downStates","selectedStates"],
            "overrides":[new AddItems().initializeFromObject({
               "itemsFactory":_loc1_,
               "destination":"_CheckBoxSkin_Group1",
               "propertyName":"mxmlContent",
               "position":"after",
               "relativeTo":["_CheckBoxSkin_Rect9"]
            }),new AddItems().initializeFromObject({
               "itemsFactory":_loc6_,
               "destination":"_CheckBoxSkin_Group1",
               "propertyName":"mxmlContent",
               "position":"after",
               "relativeTo":["_CheckBoxSkin_Rect3"]
            }),new AddItems().initializeFromObject({
               "itemsFactory":_loc5_,
               "destination":"_CheckBoxSkin_Group1",
               "propertyName":"mxmlContent",
               "position":"after",
               "relativeTo":["_CheckBoxSkin_Rect3"]
            }),new AddItems().initializeFromObject({
               "itemsFactory":_loc4_,
               "destination":"_CheckBoxSkin_Group1",
               "propertyName":"mxmlContent",
               "position":"after",
               "relativeTo":["_CheckBoxSkin_Rect3"]
            }),new AddItems().initializeFromObject({
               "itemsFactory":_loc3_,
               "destination":"_CheckBoxSkin_Group1",
               "propertyName":"mxmlContent",
               "position":"after",
               "relativeTo":["_CheckBoxSkin_Rect3"]
            }),new SetProperty().initializeFromObject({
               "target":"_CheckBoxSkin_GradientEntry1",
               "name":"color",
               "value":16777215
            }),new SetProperty().initializeFromObject({
               "target":"_CheckBoxSkin_GradientEntry1",
               "name":"alpha",
               "value":0
            }),new SetProperty().initializeFromObject({
               "target":"_CheckBoxSkin_GradientEntry2",
               "name":"color",
               "value":16777215
            }),new SetProperty().initializeFromObject({
               "target":"_CheckBoxSkin_GradientEntry2",
               "name":"alpha",
               "value":0.57
            }),new SetProperty().initializeFromObject({
               "target":"_CheckBoxSkin_GradientEntry3",
               "name":"color",
               "value":11184810
            }),new SetProperty().initializeFromObject({
               "target":"_CheckBoxSkin_GradientEntry4",
               "name":"color",
               "value":9606294
            }),new SetProperty().initializeFromObject({
               "target":"_CheckBoxSkin_SolidColor1",
               "name":"alpha",
               "value":0
            }),new SetProperty().initializeFromObject({
               "target":"borderEntry1",
               "name":"alpha",
               "value":0.6375
            }),new SetProperty().initializeFromObject({
               "target":"borderEntry2",
               "name":"alpha",
               "value":0.85
            })]
         }),new State({
            "name":"selectedDisabled",
            "stateGroups":["disabledStates","selectedStates"],
            "overrides":[new AddItems().initializeFromObject({
               "itemsFactory":_loc1_,
               "destination":"_CheckBoxSkin_Group1",
               "propertyName":"mxmlContent",
               "position":"after",
               "relativeTo":["_CheckBoxSkin_Rect9"]
            }),new AddItems().initializeFromObject({
               "itemsFactory":_loc2_,
               "destination":"_CheckBoxSkin_Group1",
               "propertyName":"mxmlContent",
               "position":"after",
               "relativeTo":["_CheckBoxSkin_Rect3"]
            })]
         })];
         _loc1_.getInstance();
      }
      
      override public function set moduleFactory(param1:IFlexModuleFactory) : void
      {
         var factory:IFlexModuleFactory = param1;
         super.moduleFactory = factory;
         if(this.__moduleFactoryInitialized)
         {
            return;
         }
         this.__moduleFactoryInitialized = true;
         if(!this.styleDeclaration)
         {
            this.styleDeclaration = new CSSStyleDeclaration(null,styleManager);
         }
         this.styleDeclaration.defaultFactory = function():void
         {
            this.disabledAlpha = 0.5;
         };
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
      
      override protected function get borderItems() : Array
      {
         return borderItem;
      }
      
      override protected function initializationComplete() : void
      {
         useChromeColor = true;
         super.initializationComplete();
      }
      
      private function _CheckBoxSkin_Group1_i() : Group
      {
         var _loc1_:Group = new Group();
         _loc1_.width = 13;
         _loc1_.height = 13;
         _loc1_.layoutDirection = "ltr";
         _loc1_.mxmlContent = [this._CheckBoxSkin_Rect1_c(),this._CheckBoxSkin_Rect2_c(),this._CheckBoxSkin_Rect3_i(),this._CheckBoxSkin_Rect9_i()];
         _loc1_.id = "_CheckBoxSkin_Group1";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._CheckBoxSkin_Group1 = _loc1_;
         BindingManager.executeBindings(this,"_CheckBoxSkin_Group1",this._CheckBoxSkin_Group1);
         return _loc1_;
      }
      
      private function _CheckBoxSkin_Rect1_c() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.left = -1;
         _loc1_.top = -1;
         _loc1_.right = -1;
         _loc1_.bottom = -1;
         _loc1_.stroke = this._CheckBoxSkin_LinearGradientStroke1_c();
         _loc1_.initialized(this,null);
         return _loc1_;
      }
      
      private function _CheckBoxSkin_LinearGradientStroke1_c() : LinearGradientStroke
      {
         var _loc1_:LinearGradientStroke = new LinearGradientStroke();
         _loc1_.rotation = 90;
         _loc1_.weight = 1;
         _loc1_.entries = [this._CheckBoxSkin_GradientEntry1_i(),this._CheckBoxSkin_GradientEntry2_i()];
         return _loc1_;
      }
      
      private function _CheckBoxSkin_GradientEntry1_i() : GradientEntry
      {
         var _loc1_:GradientEntry = new GradientEntry();
         _loc1_.color = 0;
         _loc1_.alpha = 0.011;
         this._CheckBoxSkin_GradientEntry1 = _loc1_;
         BindingManager.executeBindings(this,"_CheckBoxSkin_GradientEntry1",this._CheckBoxSkin_GradientEntry1);
         return _loc1_;
      }
      
      private function _CheckBoxSkin_GradientEntry2_i() : GradientEntry
      {
         var _loc1_:GradientEntry = new GradientEntry();
         _loc1_.color = 0;
         _loc1_.alpha = 0.121;
         this._CheckBoxSkin_GradientEntry2 = _loc1_;
         BindingManager.executeBindings(this,"_CheckBoxSkin_GradientEntry2",this._CheckBoxSkin_GradientEntry2);
         return _loc1_;
      }
      
      private function _CheckBoxSkin_Rect2_c() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.left = 1;
         _loc1_.top = 1;
         _loc1_.right = 1;
         _loc1_.bottom = 1;
         _loc1_.fill = this._CheckBoxSkin_LinearGradient1_c();
         _loc1_.initialized(this,null);
         return _loc1_;
      }
      
      private function _CheckBoxSkin_LinearGradient1_c() : LinearGradient
      {
         var _loc1_:LinearGradient = new LinearGradient();
         _loc1_.rotation = 90;
         _loc1_.entries = [this._CheckBoxSkin_GradientEntry3_i(),this._CheckBoxSkin_GradientEntry4_i()];
         return _loc1_;
      }
      
      private function _CheckBoxSkin_GradientEntry3_i() : GradientEntry
      {
         var _loc1_:GradientEntry = new GradientEntry();
         _loc1_.color = 16777215;
         _loc1_.alpha = 0.85;
         this._CheckBoxSkin_GradientEntry3 = _loc1_;
         BindingManager.executeBindings(this,"_CheckBoxSkin_GradientEntry3",this._CheckBoxSkin_GradientEntry3);
         return _loc1_;
      }
      
      private function _CheckBoxSkin_GradientEntry4_i() : GradientEntry
      {
         var _loc1_:GradientEntry = new GradientEntry();
         _loc1_.color = 14211288;
         _loc1_.alpha = 0.85;
         this._CheckBoxSkin_GradientEntry4 = _loc1_;
         BindingManager.executeBindings(this,"_CheckBoxSkin_GradientEntry4",this._CheckBoxSkin_GradientEntry4);
         return _loc1_;
      }
      
      private function _CheckBoxSkin_Rect3_i() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.left = 1;
         _loc1_.right = 1;
         _loc1_.top = 1;
         _loc1_.height = 5;
         _loc1_.fill = this._CheckBoxSkin_SolidColor1_i();
         _loc1_.initialized(this,"_CheckBoxSkin_Rect3");
         this._CheckBoxSkin_Rect3 = _loc1_;
         BindingManager.executeBindings(this,"_CheckBoxSkin_Rect3",this._CheckBoxSkin_Rect3);
         return _loc1_;
      }
      
      private function _CheckBoxSkin_SolidColor1_i() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         _loc1_.color = 16777215;
         _loc1_.alpha = 0.33;
         this._CheckBoxSkin_SolidColor1 = _loc1_;
         BindingManager.executeBindings(this,"_CheckBoxSkin_SolidColor1",this._CheckBoxSkin_SolidColor1);
         return _loc1_;
      }
      
      private function _CheckBoxSkin_Rect4_i() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.left = 1;
         _loc1_.right = 1;
         _loc1_.top = 1;
         _loc1_.bottom = 1;
         _loc1_.stroke = this._CheckBoxSkin_LinearGradientStroke2_c();
         _loc1_.initialized(this,"_CheckBoxSkin_Rect4");
         this._CheckBoxSkin_Rect4 = _loc1_;
         BindingManager.executeBindings(this,"_CheckBoxSkin_Rect4",this._CheckBoxSkin_Rect4);
         return _loc1_;
      }
      
      private function _CheckBoxSkin_LinearGradientStroke2_c() : LinearGradientStroke
      {
         var _loc1_:LinearGradientStroke = new LinearGradientStroke();
         _loc1_.rotation = 90;
         _loc1_.weight = 1;
         _loc1_.entries = [this._CheckBoxSkin_GradientEntry5_i(),this._CheckBoxSkin_GradientEntry6_i()];
         return _loc1_;
      }
      
      private function _CheckBoxSkin_GradientEntry5_i() : GradientEntry
      {
         var _loc1_:GradientEntry = new GradientEntry();
         _loc1_.color = 16777215;
         this._CheckBoxSkin_GradientEntry5 = _loc1_;
         BindingManager.executeBindings(this,"_CheckBoxSkin_GradientEntry5",this._CheckBoxSkin_GradientEntry5);
         return _loc1_;
      }
      
      private function _CheckBoxSkin_GradientEntry6_i() : GradientEntry
      {
         var _loc1_:GradientEntry = new GradientEntry();
         _loc1_.color = 16777215;
         _loc1_.alpha = 0.12;
         this._CheckBoxSkin_GradientEntry6 = _loc1_;
         BindingManager.executeBindings(this,"_CheckBoxSkin_GradientEntry6",this._CheckBoxSkin_GradientEntry6);
         return _loc1_;
      }
      
      private function _CheckBoxSkin_Rect5_i() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.left = 1;
         _loc1_.top = 1;
         _loc1_.bottom = 1;
         _loc1_.width = 1;
         _loc1_.fill = this._CheckBoxSkin_SolidColor2_c();
         _loc1_.initialized(this,"_CheckBoxSkin_Rect5");
         this._CheckBoxSkin_Rect5 = _loc1_;
         BindingManager.executeBindings(this,"_CheckBoxSkin_Rect5",this._CheckBoxSkin_Rect5);
         return _loc1_;
      }
      
      private function _CheckBoxSkin_SolidColor2_c() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         _loc1_.color = 0;
         _loc1_.alpha = 0.07;
         return _loc1_;
      }
      
      private function _CheckBoxSkin_Rect6_i() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.right = 1;
         _loc1_.top = 1;
         _loc1_.bottom = 1;
         _loc1_.width = 1;
         _loc1_.fill = this._CheckBoxSkin_SolidColor3_c();
         _loc1_.initialized(this,"_CheckBoxSkin_Rect6");
         this._CheckBoxSkin_Rect6 = _loc1_;
         BindingManager.executeBindings(this,"_CheckBoxSkin_Rect6",this._CheckBoxSkin_Rect6);
         return _loc1_;
      }
      
      private function _CheckBoxSkin_SolidColor3_c() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         _loc1_.color = 0;
         _loc1_.alpha = 0.07;
         return _loc1_;
      }
      
      private function _CheckBoxSkin_Rect7_i() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.left = 1;
         _loc1_.top = 1;
         _loc1_.right = 1;
         _loc1_.height = 1;
         _loc1_.fill = this._CheckBoxSkin_SolidColor4_c();
         _loc1_.initialized(this,"_CheckBoxSkin_Rect7");
         this._CheckBoxSkin_Rect7 = _loc1_;
         BindingManager.executeBindings(this,"_CheckBoxSkin_Rect7",this._CheckBoxSkin_Rect7);
         return _loc1_;
      }
      
      private function _CheckBoxSkin_SolidColor4_c() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         _loc1_.color = 0;
         _loc1_.alpha = 0.25;
         return _loc1_;
      }
      
      private function _CheckBoxSkin_Rect8_i() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.left = 1;
         _loc1_.top = 2;
         _loc1_.right = 1;
         _loc1_.height = 1;
         _loc1_.fill = this._CheckBoxSkin_SolidColor5_c();
         _loc1_.initialized(this,"_CheckBoxSkin_Rect8");
         this._CheckBoxSkin_Rect8 = _loc1_;
         BindingManager.executeBindings(this,"_CheckBoxSkin_Rect8",this._CheckBoxSkin_Rect8);
         return _loc1_;
      }
      
      private function _CheckBoxSkin_SolidColor5_c() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         _loc1_.color = 0;
         _loc1_.alpha = 0.09;
         return _loc1_;
      }
      
      private function _CheckBoxSkin_Rect9_i() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.left = 0;
         _loc1_.top = 0;
         _loc1_.right = 0;
         _loc1_.bottom = 0;
         _loc1_.stroke = this._CheckBoxSkin_LinearGradientStroke3_c();
         _loc1_.initialized(this,"_CheckBoxSkin_Rect9");
         this._CheckBoxSkin_Rect9 = _loc1_;
         BindingManager.executeBindings(this,"_CheckBoxSkin_Rect9",this._CheckBoxSkin_Rect9);
         return _loc1_;
      }
      
      private function _CheckBoxSkin_LinearGradientStroke3_c() : LinearGradientStroke
      {
         var _loc1_:LinearGradientStroke = new LinearGradientStroke();
         _loc1_.rotation = 90;
         _loc1_.weight = 1;
         _loc1_.entries = [this._CheckBoxSkin_GradientEntry7_i(),this._CheckBoxSkin_GradientEntry8_i()];
         return _loc1_;
      }
      
      private function _CheckBoxSkin_GradientEntry7_i() : GradientEntry
      {
         var _loc1_:GradientEntry = new GradientEntry();
         _loc1_.alpha = 0.5625;
         this.borderEntry1 = _loc1_;
         BindingManager.executeBindings(this,"borderEntry1",this.borderEntry1);
         return _loc1_;
      }
      
      private function _CheckBoxSkin_GradientEntry8_i() : GradientEntry
      {
         var _loc1_:GradientEntry = new GradientEntry();
         _loc1_.alpha = 0.75;
         this.borderEntry2 = _loc1_;
         BindingManager.executeBindings(this,"borderEntry2",this.borderEntry2);
         return _loc1_;
      }
      
      private function _CheckBoxSkin_Path1_i() : Path
      {
         var _loc1_:Path = new Path();
         _loc1_.left = 2;
         _loc1_.top = 0;
         _loc1_.data = "M 9.2 0.1 L 4.05 6.55 L 3.15 5.0 L 0.05 5.0 L 4.6 9.7 L 12.05 0.1 L 9.2 0.1";
         _loc1_.fill = this._CheckBoxSkin_SolidColor6_i();
         _loc1_.initialized(this,"check");
         this.check = _loc1_;
         BindingManager.executeBindings(this,"check",this.check);
         return _loc1_;
      }
      
      private function _CheckBoxSkin_SolidColor6_i() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         _loc1_.color = 0;
         _loc1_.alpha = 0.8;
         this.checkMarkFill = _loc1_;
         BindingManager.executeBindings(this,"checkMarkFill",this.checkMarkFill);
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      [Inspectable]
      public function get _CheckBoxSkin_GradientEntry1() : GradientEntry
      {
         return this._1574189039_CheckBoxSkin_GradientEntry1;
      }
      
      public function set _CheckBoxSkin_GradientEntry1(param1:GradientEntry) : void
      {
         var _loc2_:Object = this._1574189039_CheckBoxSkin_GradientEntry1;
         if(_loc2_ !== param1)
         {
            this._1574189039_CheckBoxSkin_GradientEntry1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_CheckBoxSkin_GradientEntry1",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      [Inspectable]
      public function get _CheckBoxSkin_GradientEntry2() : GradientEntry
      {
         return this._1574189040_CheckBoxSkin_GradientEntry2;
      }
      
      public function set _CheckBoxSkin_GradientEntry2(param1:GradientEntry) : void
      {
         var _loc2_:Object = this._1574189040_CheckBoxSkin_GradientEntry2;
         if(_loc2_ !== param1)
         {
            this._1574189040_CheckBoxSkin_GradientEntry2 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_CheckBoxSkin_GradientEntry2",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      [Inspectable]
      public function get _CheckBoxSkin_GradientEntry3() : GradientEntry
      {
         return this._1574189041_CheckBoxSkin_GradientEntry3;
      }
      
      public function set _CheckBoxSkin_GradientEntry3(param1:GradientEntry) : void
      {
         var _loc2_:Object = this._1574189041_CheckBoxSkin_GradientEntry3;
         if(_loc2_ !== param1)
         {
            this._1574189041_CheckBoxSkin_GradientEntry3 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_CheckBoxSkin_GradientEntry3",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      [Inspectable]
      public function get _CheckBoxSkin_GradientEntry4() : GradientEntry
      {
         return this._1574189042_CheckBoxSkin_GradientEntry4;
      }
      
      public function set _CheckBoxSkin_GradientEntry4(param1:GradientEntry) : void
      {
         var _loc2_:Object = this._1574189042_CheckBoxSkin_GradientEntry4;
         if(_loc2_ !== param1)
         {
            this._1574189042_CheckBoxSkin_GradientEntry4 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_CheckBoxSkin_GradientEntry4",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      [Inspectable]
      public function get _CheckBoxSkin_GradientEntry5() : GradientEntry
      {
         return this._1574189043_CheckBoxSkin_GradientEntry5;
      }
      
      public function set _CheckBoxSkin_GradientEntry5(param1:GradientEntry) : void
      {
         var _loc2_:Object = this._1574189043_CheckBoxSkin_GradientEntry5;
         if(_loc2_ !== param1)
         {
            this._1574189043_CheckBoxSkin_GradientEntry5 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_CheckBoxSkin_GradientEntry5",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      [Inspectable]
      public function get _CheckBoxSkin_GradientEntry6() : GradientEntry
      {
         return this._1574189044_CheckBoxSkin_GradientEntry6;
      }
      
      public function set _CheckBoxSkin_GradientEntry6(param1:GradientEntry) : void
      {
         var _loc2_:Object = this._1574189044_CheckBoxSkin_GradientEntry6;
         if(_loc2_ !== param1)
         {
            this._1574189044_CheckBoxSkin_GradientEntry6 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_CheckBoxSkin_GradientEntry6",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      [Inspectable]
      public function get _CheckBoxSkin_Group1() : Group
      {
         return this._1997401138_CheckBoxSkin_Group1;
      }
      
      public function set _CheckBoxSkin_Group1(param1:Group) : void
      {
         var _loc2_:Object = this._1997401138_CheckBoxSkin_Group1;
         if(_loc2_ !== param1)
         {
            this._1997401138_CheckBoxSkin_Group1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_CheckBoxSkin_Group1",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      [Inspectable]
      public function get _CheckBoxSkin_SolidColor1() : SolidColor
      {
         return this._584316185_CheckBoxSkin_SolidColor1;
      }
      
      public function set _CheckBoxSkin_SolidColor1(param1:SolidColor) : void
      {
         var _loc2_:Object = this._584316185_CheckBoxSkin_SolidColor1;
         if(_loc2_ !== param1)
         {
            this._584316185_CheckBoxSkin_SolidColor1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_CheckBoxSkin_SolidColor1",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get borderEntry1() : GradientEntry
      {
         return this._989500747borderEntry1;
      }
      
      public function set borderEntry1(param1:GradientEntry) : void
      {
         var _loc2_:Object = this._989500747borderEntry1;
         if(_loc2_ !== param1)
         {
            this._989500747borderEntry1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"borderEntry1",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get borderEntry2() : GradientEntry
      {
         return this._989500748borderEntry2;
      }
      
      public function set borderEntry2(param1:GradientEntry) : void
      {
         var _loc2_:Object = this._989500748borderEntry2;
         if(_loc2_ !== param1)
         {
            this._989500748borderEntry2 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"borderEntry2",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get check() : Path
      {
         return this._94627080check;
      }
      
      public function set check(param1:Path) : void
      {
         var _loc2_:Object = this._94627080check;
         if(_loc2_ !== param1)
         {
            this._94627080check = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"check",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get checkMarkFill() : SolidColor
      {
         return this._1634270440checkMarkFill;
      }
      
      public function set checkMarkFill(param1:SolidColor) : void
      {
         var _loc2_:Object = this._1634270440checkMarkFill;
         if(_loc2_ !== param1)
         {
            this._1634270440checkMarkFill = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"checkMarkFill",_loc2_,param1));
            }
         }
      }
   }
}

