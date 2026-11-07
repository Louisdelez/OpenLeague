package spark.skins.spark
{
   import mx.binding.BindingManager;
   import mx.core.DeferredInstanceFromFunction;
   import mx.core.IFlexModuleFactory;
   import mx.core.IStateClient2;
   import mx.events.PropertyChangeEvent;
   import mx.graphics.GradientEntry;
   import mx.graphics.LinearGradient;
   import mx.graphics.LinearGradientStroke;
   import mx.graphics.SolidColor;
   import mx.graphics.SolidColorStroke;
   import mx.states.AddItems;
   import mx.states.SetProperty;
   import mx.states.State;
   import spark.components.Label;
   import spark.primitives.Line;
   import spark.primitives.Path;
   import spark.primitives.Rect;
   import spark.skins.SparkButtonSkin;
   
   [States("disabledAndSelected")]
   [HostComponent("spark.components.ButtonBarButton")]
   public class TabBarButtonSkin extends SparkButtonSkin implements IStateClient2
   {
      
      private static const exclusions:Array = ["labelDisplay"];
      
      private var _746881822_TabBarButtonSkin_GradientEntry1:GradientEntry;
      
      private var _1678499954_TabBarButtonSkin_GradientEntry10:GradientEntry;
      
      private var _1678499953_TabBarButtonSkin_GradientEntry11:GradientEntry;
      
      private var _1678499952_TabBarButtonSkin_GradientEntry12:GradientEntry;
      
      private var _746881821_TabBarButtonSkin_GradientEntry2:GradientEntry;
      
      private var _746881817_TabBarButtonSkin_GradientEntry6:GradientEntry;
      
      private var _746881816_TabBarButtonSkin_GradientEntry7:GradientEntry;
      
      private var _746881814_TabBarButtonSkin_GradientEntry9:GradientEntry;
      
      private var _91032838_TabBarButtonSkin_SolidColor1:SolidColor;
      
      private var _91032839_TabBarButtonSkin_SolidColor2:SolidColor;
      
      private var _1091912174_TabBarButtonSkin_SolidColorStroke1:SolidColorStroke;
      
      private var _1091912175_TabBarButtonSkin_SolidColorStroke2:SolidColorStroke;
      
      private var _904538487borderBottom:Line;
      
      private var _197416329borderTop:Path;
      
      private var _3143043fill:Rect;
      
      private var _681210700highlight:Rect;
      
      private var _1507289076highlightStroke:Rect;
      
      private var _1811511742lowlight:Rect;
      
      private var _576507650selectedHighlightH1:Rect;
      
      private var _576507651selectedHighlightH2:Rect;
      
      private var _397044963selectedHighlightV:Path;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      private var cornerRadius:Number = 4;
      
      public function TabBarButtonSkin()
      {
         super();
         mx_internal::_document = this;
         this.minWidth = 21;
         this.minHeight = 21;
         this.mxmlContent = [this._TabBarButtonSkin_Rect1_i(),this._TabBarButtonSkin_Rect2_i(),this._TabBarButtonSkin_Rect3_i(),this._TabBarButtonSkin_Path1_i(),this._TabBarButtonSkin_Rect5_i(),this._TabBarButtonSkin_Rect6_i(),this._TabBarButtonSkin_Line1_i(),this._TabBarButtonSkin_Path2_i(),this._TabBarButtonSkin_Label1_i()];
         this.currentState = "up";
         var _loc1_:DeferredInstanceFromFunction = new DeferredInstanceFromFunction(this._TabBarButtonSkin_Rect4_i);
         states = [new State({
            "name":"up",
            "overrides":[new AddItems().initializeFromObject({
               "itemsFactory":_loc1_,
               "destination":null,
               "propertyName":"mxmlContent",
               "position":"after",
               "relativeTo":["highlight"]
            })]
         }),new State({
            "name":"over",
            "stateGroups":["overStates"],
            "overrides":[new AddItems().initializeFromObject({
               "itemsFactory":_loc1_,
               "destination":null,
               "propertyName":"mxmlContent",
               "position":"after",
               "relativeTo":["highlight"]
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_GradientEntry1",
               "name":"color",
               "value":12303805
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_GradientEntry2",
               "name":"color",
               "value":10461345
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_GradientEntry6",
               "name":"alpha",
               "value":0.22
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_GradientEntry7",
               "name":"alpha",
               "value":0.22
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_GradientEntry9",
               "name":"alpha",
               "value":0.22
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_GradientEntry10",
               "name":"alpha",
               "value":0.22
            })]
         }),new State({
            "name":"down",
            "stateGroups":["downStates"],
            "overrides":[new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_GradientEntry1",
               "name":"color",
               "value":11184810
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_GradientEntry2",
               "name":"color",
               "value":9606294
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_GradientEntry6",
               "name":"alpha",
               "value":0.12
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_GradientEntry7",
               "name":"alpha",
               "value":0.12
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_SolidColorStroke1",
               "name":"alpha",
               "value":0.15
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_SolidColor1",
               "name":"alpha",
               "value":0.25
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_SolidColor2",
               "name":"alpha",
               "value":0.15
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_SolidColorStroke2",
               "name":"alpha",
               "value":0.85
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_GradientEntry11",
               "name":"alpha",
               "value":0.6375
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_GradientEntry12",
               "name":"alpha",
               "value":0.85
            })]
         }),new State({
            "name":"disabled",
            "stateGroups":["disabledStates"],
            "overrides":[new AddItems().initializeFromObject({
               "itemsFactory":_loc1_,
               "destination":null,
               "propertyName":"mxmlContent",
               "position":"after",
               "relativeTo":["highlight"]
            }),new SetProperty().initializeFromObject({
               "name":"alpha",
               "value":0.5
            })]
         }),new State({
            "name":"upAndSelected",
            "stateGroups":["selectedUpStates","selectedStates"],
            "overrides":[new AddItems().initializeFromObject({
               "itemsFactory":_loc1_,
               "destination":null,
               "propertyName":"mxmlContent",
               "position":"after",
               "relativeTo":["highlight"]
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_GradientEntry1",
               "name":"color",
               "value":12303805
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_GradientEntry2",
               "name":"color",
               "value":10461345
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_GradientEntry6",
               "name":"alpha",
               "value":0.22
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_GradientEntry7",
               "name":"alpha",
               "value":0.22
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_GradientEntry9",
               "name":"alpha",
               "value":0.33
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_GradientEntry10",
               "name":"alpha",
               "value":0.33
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_SolidColorStroke1",
               "name":"alpha",
               "value":0.15
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_SolidColor1",
               "name":"alpha",
               "value":0.25
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_SolidColor2",
               "name":"alpha",
               "value":0.15
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_SolidColorStroke2",
               "name":"color",
               "value":4408131
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_SolidColorStroke2",
               "name":"alpha",
               "value":0.5
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_GradientEntry11",
               "name":"alpha",
               "value":0.6375
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_GradientEntry12",
               "name":"alpha",
               "value":0.85
            })]
         }),new State({
            "name":"overAndSelected",
            "stateGroups":["overStates","selectedStates"],
            "overrides":[new AddItems().initializeFromObject({
               "itemsFactory":_loc1_,
               "destination":null,
               "propertyName":"mxmlContent",
               "position":"after",
               "relativeTo":["highlight"]
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_GradientEntry1",
               "name":"color",
               "value":12303805
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_GradientEntry1",
               "name":"alpha",
               "value":1
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_GradientEntry2",
               "name":"color",
               "value":9342864
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_GradientEntry2",
               "name":"alpha",
               "value":1
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_GradientEntry6",
               "name":"alpha",
               "value":0.22
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_GradientEntry7",
               "name":"alpha",
               "value":0.22
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_GradientEntry9",
               "name":"alpha",
               "value":0.22
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_GradientEntry10",
               "name":"alpha",
               "value":0.22
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_SolidColorStroke1",
               "name":"alpha",
               "value":0.15
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_SolidColor1",
               "name":"alpha",
               "value":0.25
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_SolidColor2",
               "name":"alpha",
               "value":0.15
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_SolidColorStroke2",
               "name":"color",
               "value":4408131
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_SolidColorStroke2",
               "name":"alpha",
               "value":0.5
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_GradientEntry11",
               "name":"alpha",
               "value":0.6375
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_GradientEntry12",
               "name":"alpha",
               "value":0.85
            })]
         }),new State({
            "name":"downAndSelected",
            "stateGroups":["downStates","selectedStates"],
            "overrides":[new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_GradientEntry1",
               "name":"color",
               "value":11184810
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_GradientEntry2",
               "name":"color",
               "value":9606294
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_GradientEntry6",
               "name":"alpha",
               "value":0.12
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_GradientEntry7",
               "name":"alpha",
               "value":0.12
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_SolidColorStroke1",
               "name":"alpha",
               "value":0.15
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_SolidColor1",
               "name":"alpha",
               "value":0.25
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_SolidColor2",
               "name":"alpha",
               "value":0.15
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_SolidColorStroke2",
               "name":"color",
               "value":4408131
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_SolidColorStroke2",
               "name":"alpha",
               "value":0.5
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_GradientEntry11",
               "name":"alpha",
               "value":0.6375
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_GradientEntry12",
               "name":"alpha",
               "value":0.85
            })]
         }),new State({
            "name":"disabledAndSelected",
            "stateGroups":["disabledStates","selectedUpStates","selectedStates"],
            "overrides":[new AddItems().initializeFromObject({
               "itemsFactory":_loc1_,
               "destination":null,
               "propertyName":"mxmlContent",
               "position":"after",
               "relativeTo":["highlight"]
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_GradientEntry1",
               "name":"color",
               "value":12303805
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_GradientEntry2",
               "name":"color",
               "value":10461345
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_GradientEntry6",
               "name":"alpha",
               "value":0.22
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_GradientEntry7",
               "name":"alpha",
               "value":0.22
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_GradientEntry9",
               "name":"alpha",
               "value":0.33
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_GradientEntry10",
               "name":"alpha",
               "value":0.33
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_SolidColorStroke1",
               "name":"alpha",
               "value":0.15
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_SolidColor1",
               "name":"alpha",
               "value":0.25
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_SolidColor2",
               "name":"alpha",
               "value":0.15
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_SolidColorStroke2",
               "name":"color",
               "value":4408131
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_SolidColorStroke2",
               "name":"alpha",
               "value":0.5
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_GradientEntry11",
               "name":"alpha",
               "value":0.6375
            }),new SetProperty().initializeFromObject({
               "target":"_TabBarButtonSkin_GradientEntry12",
               "name":"alpha",
               "value":0.85
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
      
      override protected function initializationComplete() : void
      {
         useChromeColor = true;
         super.initializationComplete();
      }
      
      private function updateBorderTop(width:Number, height:Number) : void
      {
         var path:String = this.createPathData(true);
         this.borderTop.data = path;
         this.borderTop.setLayoutBoundsSize(width,height,false);
         this.borderTop.setLayoutBoundsPosition(0,0,false);
      }
      
      private function updateSelectedHighlight(width:Number, height:Number) : void
      {
         if(!this.selectedHighlightV)
         {
            return;
         }
         var left:Number = 0;
         var right:Number = width;
         var path:String = this.createPathData(false);
         this.selectedHighlightV.data = path;
         this.selectedHighlightV.setLayoutBoundsSize(width - 2,height - 2,false);
         this.selectedHighlightV.setLayoutBoundsPosition(1,1,false);
         this.selectedHighlightH1.setLayoutBoundsSize(width - 2 * this.cornerRadius,1,false);
         this.selectedHighlightH1.setLayoutBoundsPosition(this.cornerRadius,1,false);
         this.selectedHighlightH2.setLayoutBoundsSize(width - 2 * this.cornerRadius,1,false);
         this.selectedHighlightH2.setLayoutBoundsPosition(this.cornerRadius,2,false);
      }
      
      private function createPathData(isBorder:Boolean) : String
      {
         var left:Number = 0;
         var right:Number = width;
         var top:Number = 0.5;
         var bottom:Number = height;
         var a:Number = this.cornerRadius * 0.292893218813453;
         var s:Number = this.cornerRadius * 0.585786437626905;
         var path:String = "";
         path += "M " + left + " " + bottom;
         path += " L " + left + " " + (top + this.cornerRadius);
         path += " Q " + left + " " + (top + s) + " " + (left + a) + " " + (top + a);
         path += " Q " + (left + s) + " " + top + " " + (left + this.cornerRadius) + " " + top;
         if(isBorder)
         {
            path += " L " + (right - this.cornerRadius) + " " + top;
         }
         else
         {
            path += " M " + (right - this.cornerRadius) + " " + top;
         }
         path += " Q " + (right - s) + " " + top + " " + (right - a) + " " + (top + a);
         path += " Q " + right + " " + (top + s) + " " + right + " " + (top + this.cornerRadius);
         return path + (" L " + right + " " + bottom);
      }
      
      private function updateCornerRadius() : void
      {
         var cr:Number = Number(getStyle("cornerRadius"));
         if(this.cornerRadius != cr)
         {
            this.cornerRadius = cr;
            this.fill.topLeftRadiusX = this.cornerRadius;
            this.fill.topRightRadiusX = this.cornerRadius;
            this.lowlight.topLeftRadiusX = this.cornerRadius;
            this.lowlight.topRightRadiusX = this.cornerRadius;
            this.highlight.topLeftRadiusX = this.cornerRadius;
            this.highlight.topRightRadiusX = this.cornerRadius;
            this.highlightStroke.topLeftRadiusX = this.cornerRadius;
            this.highlightStroke.topRightRadiusX = this.cornerRadius;
         }
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaleHeight:Number) : void
      {
         this.updateCornerRadius();
         this.updateSelectedHighlight(unscaledWidth,unscaledHeight);
         this.updateBorderTop(unscaledWidth,unscaledHeight);
         super.updateDisplayList(unscaledWidth,unscaledHeight);
      }
      
      private function _TabBarButtonSkin_Rect1_i() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.left = 1;
         _loc1_.right = 1;
         _loc1_.top = 1;
         _loc1_.bottom = 1;
         _loc1_.topLeftRadiusX = 4;
         _loc1_.topRightRadiusX = 4;
         _loc1_.width = 70;
         _loc1_.height = 22;
         _loc1_.fill = this._TabBarButtonSkin_LinearGradient1_c();
         _loc1_.initialized(this,"fill");
         this.fill = _loc1_;
         BindingManager.executeBindings(this,"fill",this.fill);
         return _loc1_;
      }
      
      private function _TabBarButtonSkin_LinearGradient1_c() : LinearGradient
      {
         var _loc1_:LinearGradient = new LinearGradient();
         _loc1_.rotation = 90;
         _loc1_.entries = [this._TabBarButtonSkin_GradientEntry1_i(),this._TabBarButtonSkin_GradientEntry2_i()];
         return _loc1_;
      }
      
      private function _TabBarButtonSkin_GradientEntry1_i() : GradientEntry
      {
         var _loc1_:GradientEntry = new GradientEntry();
         _loc1_.color = 16777215;
         _loc1_.alpha = 0.85;
         this._TabBarButtonSkin_GradientEntry1 = _loc1_;
         BindingManager.executeBindings(this,"_TabBarButtonSkin_GradientEntry1",this._TabBarButtonSkin_GradientEntry1);
         return _loc1_;
      }
      
      private function _TabBarButtonSkin_GradientEntry2_i() : GradientEntry
      {
         var _loc1_:GradientEntry = new GradientEntry();
         _loc1_.color = 14211288;
         _loc1_.alpha = 0.85;
         this._TabBarButtonSkin_GradientEntry2 = _loc1_;
         BindingManager.executeBindings(this,"_TabBarButtonSkin_GradientEntry2",this._TabBarButtonSkin_GradientEntry2);
         return _loc1_;
      }
      
      private function _TabBarButtonSkin_Rect2_i() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.left = 1;
         _loc1_.right = 1;
         _loc1_.top = 1;
         _loc1_.bottom = 1;
         _loc1_.topLeftRadiusX = 4;
         _loc1_.topRightRadiusX = 4;
         _loc1_.fill = this._TabBarButtonSkin_LinearGradient2_c();
         _loc1_.initialized(this,"lowlight");
         this.lowlight = _loc1_;
         BindingManager.executeBindings(this,"lowlight",this.lowlight);
         return _loc1_;
      }
      
      private function _TabBarButtonSkin_LinearGradient2_c() : LinearGradient
      {
         var _loc1_:LinearGradient = new LinearGradient();
         _loc1_.rotation = 270;
         _loc1_.entries = [this._TabBarButtonSkin_GradientEntry3_c(),this._TabBarButtonSkin_GradientEntry4_c(),this._TabBarButtonSkin_GradientEntry5_c()];
         return _loc1_;
      }
      
      private function _TabBarButtonSkin_GradientEntry3_c() : GradientEntry
      {
         var _loc1_:GradientEntry = new GradientEntry();
         _loc1_.color = 0;
         _loc1_.ratio = 0;
         _loc1_.alpha = 0.0627;
         return _loc1_;
      }
      
      private function _TabBarButtonSkin_GradientEntry4_c() : GradientEntry
      {
         var _loc1_:GradientEntry = new GradientEntry();
         _loc1_.color = 0;
         _loc1_.ratio = 0.48;
         _loc1_.alpha = 0.0099;
         return _loc1_;
      }
      
      private function _TabBarButtonSkin_GradientEntry5_c() : GradientEntry
      {
         var _loc1_:GradientEntry = new GradientEntry();
         _loc1_.color = 0;
         _loc1_.ratio = 0.48001;
         _loc1_.alpha = 0;
         return _loc1_;
      }
      
      private function _TabBarButtonSkin_Rect3_i() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.left = 1;
         _loc1_.right = 1;
         _loc1_.top = 1;
         _loc1_.bottom = 1;
         _loc1_.topLeftRadiusX = 4;
         _loc1_.topRightRadiusX = 4;
         _loc1_.fill = this._TabBarButtonSkin_LinearGradient3_c();
         _loc1_.initialized(this,"highlight");
         this.highlight = _loc1_;
         BindingManager.executeBindings(this,"highlight",this.highlight);
         return _loc1_;
      }
      
      private function _TabBarButtonSkin_LinearGradient3_c() : LinearGradient
      {
         var _loc1_:LinearGradient = new LinearGradient();
         _loc1_.rotation = 90;
         _loc1_.entries = [this._TabBarButtonSkin_GradientEntry6_i(),this._TabBarButtonSkin_GradientEntry7_i(),this._TabBarButtonSkin_GradientEntry8_c()];
         return _loc1_;
      }
      
      private function _TabBarButtonSkin_GradientEntry6_i() : GradientEntry
      {
         var _loc1_:GradientEntry = new GradientEntry();
         _loc1_.color = 16777215;
         _loc1_.ratio = 0;
         _loc1_.alpha = 0.33;
         this._TabBarButtonSkin_GradientEntry6 = _loc1_;
         BindingManager.executeBindings(this,"_TabBarButtonSkin_GradientEntry6",this._TabBarButtonSkin_GradientEntry6);
         return _loc1_;
      }
      
      private function _TabBarButtonSkin_GradientEntry7_i() : GradientEntry
      {
         var _loc1_:GradientEntry = new GradientEntry();
         _loc1_.color = 16777215;
         _loc1_.ratio = 0.48;
         _loc1_.alpha = 0.33;
         this._TabBarButtonSkin_GradientEntry7 = _loc1_;
         BindingManager.executeBindings(this,"_TabBarButtonSkin_GradientEntry7",this._TabBarButtonSkin_GradientEntry7);
         return _loc1_;
      }
      
      private function _TabBarButtonSkin_GradientEntry8_c() : GradientEntry
      {
         var _loc1_:GradientEntry = new GradientEntry();
         _loc1_.color = 16777215;
         _loc1_.ratio = 0.48001;
         _loc1_.alpha = 0;
         return _loc1_;
      }
      
      private function _TabBarButtonSkin_Rect4_i() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.left = 1;
         _loc1_.right = 1;
         _loc1_.top = 1;
         _loc1_.bottom = 1;
         _loc1_.topLeftRadiusX = 4;
         _loc1_.topRightRadiusX = 4;
         _loc1_.stroke = this._TabBarButtonSkin_LinearGradientStroke1_c();
         _loc1_.initialized(this,"highlightStroke");
         this.highlightStroke = _loc1_;
         BindingManager.executeBindings(this,"highlightStroke",this.highlightStroke);
         return _loc1_;
      }
      
      private function _TabBarButtonSkin_LinearGradientStroke1_c() : LinearGradientStroke
      {
         var _loc1_:LinearGradientStroke = new LinearGradientStroke();
         _loc1_.rotation = 90;
         _loc1_.weight = 1;
         _loc1_.entries = [this._TabBarButtonSkin_GradientEntry9_i(),this._TabBarButtonSkin_GradientEntry10_i()];
         return _loc1_;
      }
      
      private function _TabBarButtonSkin_GradientEntry9_i() : GradientEntry
      {
         var _loc1_:GradientEntry = new GradientEntry();
         _loc1_.color = 16777215;
         this._TabBarButtonSkin_GradientEntry9 = _loc1_;
         BindingManager.executeBindings(this,"_TabBarButtonSkin_GradientEntry9",this._TabBarButtonSkin_GradientEntry9);
         return _loc1_;
      }
      
      private function _TabBarButtonSkin_GradientEntry10_i() : GradientEntry
      {
         var _loc1_:GradientEntry = new GradientEntry();
         _loc1_.color = 14211288;
         this._TabBarButtonSkin_GradientEntry10 = _loc1_;
         BindingManager.executeBindings(this,"_TabBarButtonSkin_GradientEntry10",this._TabBarButtonSkin_GradientEntry10);
         return _loc1_;
      }
      
      private function _TabBarButtonSkin_Path1_i() : Path
      {
         var _loc1_:Path = new Path();
         _loc1_.left = 1;
         _loc1_.right = 1;
         _loc1_.top = 1;
         _loc1_.bottom = 1;
         _loc1_.includeInLayout = false;
         _loc1_.stroke = this._TabBarButtonSkin_SolidColorStroke1_i();
         _loc1_.initialized(this,"selectedHighlightV");
         this.selectedHighlightV = _loc1_;
         BindingManager.executeBindings(this,"selectedHighlightV",this.selectedHighlightV);
         return _loc1_;
      }
      
      private function _TabBarButtonSkin_SolidColorStroke1_i() : SolidColorStroke
      {
         var _loc1_:SolidColorStroke = new SolidColorStroke();
         _loc1_.weight = 1;
         _loc1_.color = 0;
         _loc1_.alpha = 0;
         this._TabBarButtonSkin_SolidColorStroke1 = _loc1_;
         BindingManager.executeBindings(this,"_TabBarButtonSkin_SolidColorStroke1",this._TabBarButtonSkin_SolidColorStroke1);
         return _loc1_;
      }
      
      private function _TabBarButtonSkin_Rect5_i() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.top = 1;
         _loc1_.height = 1;
         _loc1_.includeInLayout = false;
         _loc1_.fill = this._TabBarButtonSkin_SolidColor1_i();
         _loc1_.initialized(this,"selectedHighlightH1");
         this.selectedHighlightH1 = _loc1_;
         BindingManager.executeBindings(this,"selectedHighlightH1",this.selectedHighlightH1);
         return _loc1_;
      }
      
      private function _TabBarButtonSkin_SolidColor1_i() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         _loc1_.color = 0;
         _loc1_.alpha = 0;
         this._TabBarButtonSkin_SolidColor1 = _loc1_;
         BindingManager.executeBindings(this,"_TabBarButtonSkin_SolidColor1",this._TabBarButtonSkin_SolidColor1);
         return _loc1_;
      }
      
      private function _TabBarButtonSkin_Rect6_i() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.top = 2;
         _loc1_.height = 1;
         _loc1_.includeInLayout = false;
         _loc1_.fill = this._TabBarButtonSkin_SolidColor2_i();
         _loc1_.initialized(this,"selectedHighlightH2");
         this.selectedHighlightH2 = _loc1_;
         BindingManager.executeBindings(this,"selectedHighlightH2",this.selectedHighlightH2);
         return _loc1_;
      }
      
      private function _TabBarButtonSkin_SolidColor2_i() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         _loc1_.color = 0;
         _loc1_.alpha = 0;
         this._TabBarButtonSkin_SolidColor2 = _loc1_;
         BindingManager.executeBindings(this,"_TabBarButtonSkin_SolidColor2",this._TabBarButtonSkin_SolidColor2);
         return _loc1_;
      }
      
      private function _TabBarButtonSkin_Line1_i() : Line
      {
         var _loc1_:Line = new Line();
         _loc1_.left = 0;
         _loc1_.right = 0;
         _loc1_.bottom = 0;
         _loc1_.stroke = this._TabBarButtonSkin_SolidColorStroke2_i();
         _loc1_.initialized(this,"borderBottom");
         this.borderBottom = _loc1_;
         BindingManager.executeBindings(this,"borderBottom",this.borderBottom);
         return _loc1_;
      }
      
      private function _TabBarButtonSkin_SolidColorStroke2_i() : SolidColorStroke
      {
         var _loc1_:SolidColorStroke = new SolidColorStroke();
         _loc1_.weight = 1;
         _loc1_.color = 0;
         _loc1_.alpha = 0.75;
         this._TabBarButtonSkin_SolidColorStroke2 = _loc1_;
         BindingManager.executeBindings(this,"_TabBarButtonSkin_SolidColorStroke2",this._TabBarButtonSkin_SolidColorStroke2);
         return _loc1_;
      }
      
      private function _TabBarButtonSkin_Path2_i() : Path
      {
         var _loc1_:Path = new Path();
         _loc1_.left = 0;
         _loc1_.right = 0;
         _loc1_.top = 0;
         _loc1_.bottom = 0;
         _loc1_.includeInLayout = false;
         _loc1_.stroke = this._TabBarButtonSkin_LinearGradientStroke2_c();
         _loc1_.initialized(this,"borderTop");
         this.borderTop = _loc1_;
         BindingManager.executeBindings(this,"borderTop",this.borderTop);
         return _loc1_;
      }
      
      private function _TabBarButtonSkin_LinearGradientStroke2_c() : LinearGradientStroke
      {
         var _loc1_:LinearGradientStroke = new LinearGradientStroke();
         _loc1_.rotation = 90;
         _loc1_.weight = 1;
         _loc1_.entries = [this._TabBarButtonSkin_GradientEntry11_i(),this._TabBarButtonSkin_GradientEntry12_i()];
         return _loc1_;
      }
      
      private function _TabBarButtonSkin_GradientEntry11_i() : GradientEntry
      {
         var _loc1_:GradientEntry = new GradientEntry();
         _loc1_.color = 0;
         _loc1_.alpha = 0.5625;
         this._TabBarButtonSkin_GradientEntry11 = _loc1_;
         BindingManager.executeBindings(this,"_TabBarButtonSkin_GradientEntry11",this._TabBarButtonSkin_GradientEntry11);
         return _loc1_;
      }
      
      private function _TabBarButtonSkin_GradientEntry12_i() : GradientEntry
      {
         var _loc1_:GradientEntry = new GradientEntry();
         _loc1_.color = 0;
         _loc1_.alpha = 0.75;
         this._TabBarButtonSkin_GradientEntry12 = _loc1_;
         BindingManager.executeBindings(this,"_TabBarButtonSkin_GradientEntry12",this._TabBarButtonSkin_GradientEntry12);
         return _loc1_;
      }
      
      private function _TabBarButtonSkin_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.maxDisplayedLines = 1;
         _loc1_.horizontalCenter = 0;
         _loc1_.verticalCenter = 1;
         _loc1_.left = 10;
         _loc1_.right = 10;
         _loc1_.top = 2;
         _loc1_.bottom = 2;
         _loc1_.setStyle("textAlign","center");
         _loc1_.setStyle("verticalAlign","middle");
         _loc1_.id = "labelDisplay";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         labelDisplay = _loc1_;
         BindingManager.executeBindings(this,"labelDisplay",labelDisplay);
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      [Inspectable]
      public function get _TabBarButtonSkin_GradientEntry1() : GradientEntry
      {
         return this._746881822_TabBarButtonSkin_GradientEntry1;
      }
      
      public function set _TabBarButtonSkin_GradientEntry1(param1:GradientEntry) : void
      {
         var _loc2_:Object = this._746881822_TabBarButtonSkin_GradientEntry1;
         if(_loc2_ !== param1)
         {
            this._746881822_TabBarButtonSkin_GradientEntry1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_TabBarButtonSkin_GradientEntry1",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      [Inspectable]
      public function get _TabBarButtonSkin_GradientEntry10() : GradientEntry
      {
         return this._1678499954_TabBarButtonSkin_GradientEntry10;
      }
      
      public function set _TabBarButtonSkin_GradientEntry10(param1:GradientEntry) : void
      {
         var _loc2_:Object = this._1678499954_TabBarButtonSkin_GradientEntry10;
         if(_loc2_ !== param1)
         {
            this._1678499954_TabBarButtonSkin_GradientEntry10 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_TabBarButtonSkin_GradientEntry10",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      [Inspectable]
      public function get _TabBarButtonSkin_GradientEntry11() : GradientEntry
      {
         return this._1678499953_TabBarButtonSkin_GradientEntry11;
      }
      
      public function set _TabBarButtonSkin_GradientEntry11(param1:GradientEntry) : void
      {
         var _loc2_:Object = this._1678499953_TabBarButtonSkin_GradientEntry11;
         if(_loc2_ !== param1)
         {
            this._1678499953_TabBarButtonSkin_GradientEntry11 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_TabBarButtonSkin_GradientEntry11",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      [Inspectable]
      public function get _TabBarButtonSkin_GradientEntry12() : GradientEntry
      {
         return this._1678499952_TabBarButtonSkin_GradientEntry12;
      }
      
      public function set _TabBarButtonSkin_GradientEntry12(param1:GradientEntry) : void
      {
         var _loc2_:Object = this._1678499952_TabBarButtonSkin_GradientEntry12;
         if(_loc2_ !== param1)
         {
            this._1678499952_TabBarButtonSkin_GradientEntry12 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_TabBarButtonSkin_GradientEntry12",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      [Inspectable]
      public function get _TabBarButtonSkin_GradientEntry2() : GradientEntry
      {
         return this._746881821_TabBarButtonSkin_GradientEntry2;
      }
      
      public function set _TabBarButtonSkin_GradientEntry2(param1:GradientEntry) : void
      {
         var _loc2_:Object = this._746881821_TabBarButtonSkin_GradientEntry2;
         if(_loc2_ !== param1)
         {
            this._746881821_TabBarButtonSkin_GradientEntry2 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_TabBarButtonSkin_GradientEntry2",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      [Inspectable]
      public function get _TabBarButtonSkin_GradientEntry6() : GradientEntry
      {
         return this._746881817_TabBarButtonSkin_GradientEntry6;
      }
      
      public function set _TabBarButtonSkin_GradientEntry6(param1:GradientEntry) : void
      {
         var _loc2_:Object = this._746881817_TabBarButtonSkin_GradientEntry6;
         if(_loc2_ !== param1)
         {
            this._746881817_TabBarButtonSkin_GradientEntry6 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_TabBarButtonSkin_GradientEntry6",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      [Inspectable]
      public function get _TabBarButtonSkin_GradientEntry7() : GradientEntry
      {
         return this._746881816_TabBarButtonSkin_GradientEntry7;
      }
      
      public function set _TabBarButtonSkin_GradientEntry7(param1:GradientEntry) : void
      {
         var _loc2_:Object = this._746881816_TabBarButtonSkin_GradientEntry7;
         if(_loc2_ !== param1)
         {
            this._746881816_TabBarButtonSkin_GradientEntry7 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_TabBarButtonSkin_GradientEntry7",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      [Inspectable]
      public function get _TabBarButtonSkin_GradientEntry9() : GradientEntry
      {
         return this._746881814_TabBarButtonSkin_GradientEntry9;
      }
      
      public function set _TabBarButtonSkin_GradientEntry9(param1:GradientEntry) : void
      {
         var _loc2_:Object = this._746881814_TabBarButtonSkin_GradientEntry9;
         if(_loc2_ !== param1)
         {
            this._746881814_TabBarButtonSkin_GradientEntry9 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_TabBarButtonSkin_GradientEntry9",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      [Inspectable]
      public function get _TabBarButtonSkin_SolidColor1() : SolidColor
      {
         return this._91032838_TabBarButtonSkin_SolidColor1;
      }
      
      public function set _TabBarButtonSkin_SolidColor1(param1:SolidColor) : void
      {
         var _loc2_:Object = this._91032838_TabBarButtonSkin_SolidColor1;
         if(_loc2_ !== param1)
         {
            this._91032838_TabBarButtonSkin_SolidColor1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_TabBarButtonSkin_SolidColor1",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      [Inspectable]
      public function get _TabBarButtonSkin_SolidColor2() : SolidColor
      {
         return this._91032839_TabBarButtonSkin_SolidColor2;
      }
      
      public function set _TabBarButtonSkin_SolidColor2(param1:SolidColor) : void
      {
         var _loc2_:Object = this._91032839_TabBarButtonSkin_SolidColor2;
         if(_loc2_ !== param1)
         {
            this._91032839_TabBarButtonSkin_SolidColor2 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_TabBarButtonSkin_SolidColor2",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      [Inspectable]
      public function get _TabBarButtonSkin_SolidColorStroke1() : SolidColorStroke
      {
         return this._1091912174_TabBarButtonSkin_SolidColorStroke1;
      }
      
      public function set _TabBarButtonSkin_SolidColorStroke1(param1:SolidColorStroke) : void
      {
         var _loc2_:Object = this._1091912174_TabBarButtonSkin_SolidColorStroke1;
         if(_loc2_ !== param1)
         {
            this._1091912174_TabBarButtonSkin_SolidColorStroke1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_TabBarButtonSkin_SolidColorStroke1",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      [Inspectable]
      public function get _TabBarButtonSkin_SolidColorStroke2() : SolidColorStroke
      {
         return this._1091912175_TabBarButtonSkin_SolidColorStroke2;
      }
      
      public function set _TabBarButtonSkin_SolidColorStroke2(param1:SolidColorStroke) : void
      {
         var _loc2_:Object = this._1091912175_TabBarButtonSkin_SolidColorStroke2;
         if(_loc2_ !== param1)
         {
            this._1091912175_TabBarButtonSkin_SolidColorStroke2 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_TabBarButtonSkin_SolidColorStroke2",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get borderBottom() : Line
      {
         return this._904538487borderBottom;
      }
      
      public function set borderBottom(param1:Line) : void
      {
         var _loc2_:Object = this._904538487borderBottom;
         if(_loc2_ !== param1)
         {
            this._904538487borderBottom = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"borderBottom",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get borderTop() : Path
      {
         return this._197416329borderTop;
      }
      
      public function set borderTop(param1:Path) : void
      {
         var _loc2_:Object = this._197416329borderTop;
         if(_loc2_ !== param1)
         {
            this._197416329borderTop = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"borderTop",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get fill() : Rect
      {
         return this._3143043fill;
      }
      
      public function set fill(param1:Rect) : void
      {
         var _loc2_:Object = this._3143043fill;
         if(_loc2_ !== param1)
         {
            this._3143043fill = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"fill",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get highlight() : Rect
      {
         return this._681210700highlight;
      }
      
      public function set highlight(param1:Rect) : void
      {
         var _loc2_:Object = this._681210700highlight;
         if(_loc2_ !== param1)
         {
            this._681210700highlight = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"highlight",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get highlightStroke() : Rect
      {
         return this._1507289076highlightStroke;
      }
      
      public function set highlightStroke(param1:Rect) : void
      {
         var _loc2_:Object = this._1507289076highlightStroke;
         if(_loc2_ !== param1)
         {
            this._1507289076highlightStroke = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"highlightStroke",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get lowlight() : Rect
      {
         return this._1811511742lowlight;
      }
      
      public function set lowlight(param1:Rect) : void
      {
         var _loc2_:Object = this._1811511742lowlight;
         if(_loc2_ !== param1)
         {
            this._1811511742lowlight = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"lowlight",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get selectedHighlightH1() : Rect
      {
         return this._576507650selectedHighlightH1;
      }
      
      public function set selectedHighlightH1(param1:Rect) : void
      {
         var _loc2_:Object = this._576507650selectedHighlightH1;
         if(_loc2_ !== param1)
         {
            this._576507650selectedHighlightH1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"selectedHighlightH1",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get selectedHighlightH2() : Rect
      {
         return this._576507651selectedHighlightH2;
      }
      
      public function set selectedHighlightH2(param1:Rect) : void
      {
         var _loc2_:Object = this._576507651selectedHighlightH2;
         if(_loc2_ !== param1)
         {
            this._576507651selectedHighlightH2 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"selectedHighlightH2",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get selectedHighlightV() : Path
      {
         return this._397044963selectedHighlightV;
      }
      
      public function set selectedHighlightV(param1:Path) : void
      {
         var _loc2_:Object = this._397044963selectedHighlightV;
         if(_loc2_ !== param1)
         {
            this._397044963selectedHighlightV = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"selectedHighlightV",_loc2_,param1));
            }
         }
      }
   }
}

