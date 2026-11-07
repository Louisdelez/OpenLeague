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
   import mx.containers.utilityClasses.ConstraintColumn;
   import mx.containers.utilityClasses.ConstraintRow;
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
   import spark.components.FormItem;
   import spark.components.Group;
   import spark.components.Image;
   import spark.components.Label;
   import spark.components.supportClasses.Skin;
   import spark.layouts.FormItemLayout;
   import spark.layouts.VerticalLayout;
   import spark.primitives.Rect;
   
   [States("requiredAndError")]
   [HostComponent("spark.components.FormItem")]
   public class StackedFormItemSkin extends Skin implements IBindingClient, IStateClient2
   {
      
      private static var _watcherSetupUtil:IWatcherSetupUtil2;
      
      private var _1533320022_StackedFormItemSkin_Group2:Group;
      
      private var _1084214723_StackedFormItemSkin_SetProperty1:SetProperty;
      
      private var _1084214722_StackedFormItemSkin_SetProperty2:SetProperty;
      
      private var _1332194002background:Rect;
      
      private var _1391998104bgFill:SolidColor;
      
      private var _264525383contentCol:ConstraintColumn;
      
      private var _809612678contentGroup:Group;
      
      private var _805791359helpCol:ConstraintColumn;
      
      private var _205258905helpContentGroup:Group;
      
      private var _1746021453indicatorDisplay:Image;
      
      private var _1184053038labelDisplay:Label;
      
      private var _3506583row1:ConstraintRow;
      
      private var _3506584row2:ConstraintRow;
      
      private var _805245441sequenceCol:ConstraintColumn;
      
      private var _832334223sequenceLabelDisplay:Label;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindings:Array;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _watchers:Array;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsByDestination:Object;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _bindingsBeginWithWord:Object;
      
      private var _213507019hostComponent:FormItem;
      
      public function StackedFormItemSkin()
      {
         var bindings:Array;
         var watchers:Array;
         var _StackedFormItemSkin_Image1_factory:DeferredInstanceFromFunction;
         var i:uint;
         var target:Object = null;
         var watcherSetupUtilClass:Object = null;
         this._bindings = [];
         this._watchers = [];
         this._bindingsByDestination = {};
         this._bindingsBeginWithWord = {};
         super();
         mx_internal::_document = this;
         bindings = this._StackedFormItemSkin_bindingsSetup();
         watchers = [];
         target = this;
         if(_watcherSetupUtil == null)
         {
            watcherSetupUtilClass = getDefinitionByName("_spark_skins_spark_StackedFormItemSkinWatcherSetupUtil");
            watcherSetupUtilClass["init"](null);
         }
         _watcherSetupUtil.setup(this,function(propertyName:String):*
         {
            return target[propertyName];
         },function(param1:String):*
         {
            return StackedFormItemSkin[param1];
         },bindings,watchers);
         mx_internal::_bindings = mx_internal::_bindings.concat(bindings);
         mx_internal::_watchers = mx_internal::_watchers.concat(watchers);
         this.layout = this._StackedFormItemSkin_FormItemLayout1_c();
         this.mxmlContent = [this._StackedFormItemSkin_Rect1_i(),this._StackedFormItemSkin_Label1_i(),this._StackedFormItemSkin_Label2_i(),this._StackedFormItemSkin_Group1_i(),this._StackedFormItemSkin_Group2_i(),this._StackedFormItemSkin_Group3_i()];
         this.currentState = "normal";
         _StackedFormItemSkin_Image1_factory = new DeferredInstanceFromFunction(this._StackedFormItemSkin_Image1_i);
         states = [new State({
            "name":"normal",
            "overrides":[]
         }),new State({
            "name":"disabled",
            "stateGroups":["disabledStates"],
            "overrides":[new SetProperty().initializeFromObject({
               "name":"alpha",
               "value":0.5
            })]
         }),new State({
            "name":"error",
            "stateGroups":["errorStates"],
            "overrides":[new AddItems().initializeFromObject({
               "itemsFactory":_StackedFormItemSkin_Image1_factory,
               "destination":"_StackedFormItemSkin_Group2",
               "propertyName":"mxmlContent",
               "position":"first"
            }),this._StackedFormItemSkin_SetProperty2 = SetProperty(new SetProperty().initializeFromObject({
               "target":"indicatorDisplay",
               "name":"toolTip",
               "value":undefined
            }))]
         }),new State({
            "name":"required",
            "stateGroups":["requiredStates"],
            "overrides":[new AddItems().initializeFromObject({
               "itemsFactory":_StackedFormItemSkin_Image1_factory,
               "destination":"_StackedFormItemSkin_Group2",
               "propertyName":"mxmlContent",
               "position":"first"
            })]
         }),new State({
            "name":"requiredAndDisabled",
            "stateGroups":["disabledStates","requiredStates"],
            "overrides":[new AddItems().initializeFromObject({
               "itemsFactory":_StackedFormItemSkin_Image1_factory,
               "destination":"_StackedFormItemSkin_Group2",
               "propertyName":"mxmlContent",
               "position":"first"
            }),new SetProperty().initializeFromObject({
               "name":"alpha",
               "value":0.5
            })]
         }),new State({
            "name":"requiredAndError",
            "stateGroups":["errorStates","requiredStates"],
            "overrides":[new AddItems().initializeFromObject({
               "itemsFactory":_StackedFormItemSkin_Image1_factory,
               "destination":"_StackedFormItemSkin_Group2",
               "propertyName":"mxmlContent",
               "position":"first"
            }),this._StackedFormItemSkin_SetProperty1 = SetProperty(new SetProperty().initializeFromObject({
               "target":"indicatorDisplay",
               "name":"toolTip",
               "value":undefined
            }))]
         })];
         BindingManager.executeBindings(this,"_StackedFormItemSkin_SetProperty2",this._StackedFormItemSkin_SetProperty2);
         BindingManager.executeBindings(this,"_StackedFormItemSkin_SetProperty1",this._StackedFormItemSkin_SetProperty1);
         i = 0;
         while(i < bindings.length)
         {
            Binding(bindings[i]).execute();
            i++;
         }
      }
      
      public static function set watcherSetupUtil(param1:IWatcherSetupUtil2) : void
      {
         StackedFormItemSkin._watcherSetupUtil = param1;
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
         var indicatorSource:Object = null;
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
         if(currentState == "error" || currentState == "requiredAndError")
         {
            indicatorSource = getStyle("errorIndicatorSource");
         }
         else if(currentState == "required" || Boolean("requiredAndDisabled"))
         {
            indicatorSource = getStyle("requiredIndicatorSource");
         }
         if(Boolean(indicatorSource) && Boolean(this.indicatorDisplay))
         {
            this.indicatorDisplay.source = indicatorSource;
         }
         super.updateDisplayList(unscaledWidth,unscaledHeight);
      }
      
      override public function setCurrentState(stateName:String, playTransition:Boolean = true) : void
      {
         super.setCurrentState(stateName,playTransition);
         invalidateDisplayList();
      }
      
      private function _StackedFormItemSkin_FormItemLayout1_c() : FormItemLayout
      {
         var _loc1_:FormItemLayout = new FormItemLayout();
         _loc1_.constraintColumns = new <ConstraintColumn>[this._StackedFormItemSkin_ConstraintColumn1_i(),this._StackedFormItemSkin_ConstraintColumn2_i(),this._StackedFormItemSkin_ConstraintColumn3_i()];
         _loc1_.constraintRows = new <ConstraintRow>[this._StackedFormItemSkin_ConstraintRow1_i(),this._StackedFormItemSkin_ConstraintRow2_i()];
         return _loc1_;
      }
      
      private function _StackedFormItemSkin_ConstraintColumn1_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         _loc1_.initialized(this,"sequenceCol");
         this.sequenceCol = _loc1_;
         BindingManager.executeBindings(this,"sequenceCol",this.sequenceCol);
         return _loc1_;
      }
      
      private function _StackedFormItemSkin_ConstraintColumn2_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         _loc1_.percentWidth = 100;
         _loc1_.initialized(this,"contentCol");
         this.contentCol = _loc1_;
         BindingManager.executeBindings(this,"contentCol",this.contentCol);
         return _loc1_;
      }
      
      private function _StackedFormItemSkin_ConstraintColumn3_i() : ConstraintColumn
      {
         var _loc1_:ConstraintColumn = new ConstraintColumn();
         _loc1_.maxWidth = 200;
         _loc1_.initialized(this,"helpCol");
         this.helpCol = _loc1_;
         BindingManager.executeBindings(this,"helpCol",this.helpCol);
         return _loc1_;
      }
      
      private function _StackedFormItemSkin_ConstraintRow1_i() : ConstraintRow
      {
         var _loc1_:ConstraintRow = new ConstraintRow();
         _loc1_.baseline = "maxAscent:10";
         _loc1_.initialized(this,"row1");
         this.row1 = _loc1_;
         BindingManager.executeBindings(this,"row1",this.row1);
         return _loc1_;
      }
      
      private function _StackedFormItemSkin_ConstraintRow2_i() : ConstraintRow
      {
         var _loc1_:ConstraintRow = new ConstraintRow();
         _loc1_.percentHeight = 100;
         _loc1_.initialized(this,"row2");
         this.row2 = _loc1_;
         BindingManager.executeBindings(this,"row2",this.row2);
         return _loc1_;
      }
      
      private function _StackedFormItemSkin_Rect1_i() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.left = 0;
         _loc1_.right = 0;
         _loc1_.top = 0;
         _loc1_.bottom = 0;
         _loc1_.fill = this._StackedFormItemSkin_SolidColor1_i();
         _loc1_.initialized(this,"background");
         this.background = _loc1_;
         BindingManager.executeBindings(this,"background",this.background);
         return _loc1_;
      }
      
      private function _StackedFormItemSkin_SolidColor1_i() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         _loc1_.color = 16777215;
         this.bgFill = _loc1_;
         BindingManager.executeBindings(this,"bgFill",this.bgFill);
         return _loc1_;
      }
      
      private function _StackedFormItemSkin_Label1_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.left = "sequenceCol:10";
         _loc1_.right = "sequenceCol:5";
         _loc1_.bottom = "row1:5";
         _loc1_.baseline = "row1:0";
         _loc1_.setStyle("fontWeight","bold");
         _loc1_.id = "sequenceLabelDisplay";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.sequenceLabelDisplay = _loc1_;
         BindingManager.executeBindings(this,"sequenceLabelDisplay",this.sequenceLabelDisplay);
         return _loc1_;
      }
      
      private function _StackedFormItemSkin_Label2_i() : Label
      {
         var _loc1_:Label = new Label();
         _loc1_.left = "contentCol:0";
         _loc1_.right = "contentCol:5";
         _loc1_.bottom = "row1:5";
         _loc1_.baseline = "row1:0";
         _loc1_.setStyle("fontWeight","bold");
         _loc1_.id = "labelDisplay";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.labelDisplay = _loc1_;
         BindingManager.executeBindings(this,"labelDisplay",this.labelDisplay);
         return _loc1_;
      }
      
      private function _StackedFormItemSkin_Group1_i() : Group
      {
         var _loc1_:Group = new Group();
         _loc1_.left = "contentCol:0";
         _loc1_.right = "contentCol:1";
         _loc1_.top = "row2:0";
         _loc1_.bottom = "row2:10";
         _loc1_.baseline = "row2:0";
         _loc1_.layout = this._StackedFormItemSkin_VerticalLayout1_c();
         _loc1_.setStyle("showErrorTip",false);
         _loc1_.setStyle("showErrorSkin",true);
         _loc1_.id = "contentGroup";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.contentGroup = _loc1_;
         BindingManager.executeBindings(this,"contentGroup",this.contentGroup);
         return _loc1_;
      }
      
      private function _StackedFormItemSkin_VerticalLayout1_c() : VerticalLayout
      {
         return new VerticalLayout();
      }
      
      private function _StackedFormItemSkin_Group2_i() : Group
      {
         var _loc1_:Group = new Group();
         _loc1_.includeInLayout = false;
         _loc1_.mxmlContent = [];
         _loc1_.id = "_StackedFormItemSkin_Group2";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this._StackedFormItemSkin_Group2 = _loc1_;
         BindingManager.executeBindings(this,"_StackedFormItemSkin_Group2",this._StackedFormItemSkin_Group2);
         return _loc1_;
      }
      
      private function _StackedFormItemSkin_Image1_i() : Image
      {
         var _loc1_:Image = new Image();
         _loc1_.verticalCenter = 0;
         _loc1_.toolTip = "Required";
         _loc1_.id = "indicatorDisplay";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.indicatorDisplay = _loc1_;
         BindingManager.executeBindings(this,"indicatorDisplay",this.indicatorDisplay);
         return _loc1_;
      }
      
      private function _StackedFormItemSkin_Group3_i() : Group
      {
         var _loc1_:Group = new Group();
         _loc1_.left = "helpCol:27";
         _loc1_.right = "helpCol:10";
         _loc1_.bottom = "row2:10";
         _loc1_.baseline = "row2:0";
         _loc1_.setStyle("fontStyle","italic");
         _loc1_.setStyle("fontWeight","normal");
         _loc1_.setStyle("color",6710886);
         _loc1_.id = "helpContentGroup";
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         this.helpContentGroup = _loc1_;
         BindingManager.executeBindings(this,"helpContentGroup",this.helpContentGroup);
         return _loc1_;
      }
      
      private function _StackedFormItemSkin_bindingsSetup() : Array
      {
         var result:Array = [];
         result[0] = new Binding(this,function():Number
         {
            return contentGroup.x + contentGroup.contentWidth + 4;
         },null,"_StackedFormItemSkin_Group2.x");
         result[1] = new Binding(this,function():Number
         {
            return contentGroup.y;
         },null,"_StackedFormItemSkin_Group2.y");
         result[2] = new Binding(this,function():Number
         {
            return Math.max(indicatorDisplay.height,contentGroup.contentHeight);
         },null,"_StackedFormItemSkin_Group2.height");
         result[3] = new Binding(this,function():*
         {
            return hostComponent.errorString;
         },null,"_StackedFormItemSkin_SetProperty1.value");
         result[4] = new Binding(this,function():*
         {
            return hostComponent.errorString;
         },null,"_StackedFormItemSkin_SetProperty2.value");
         return result;
      }
      
      [Bindable(event="propertyChange")]
      [Inspectable]
      public function get _StackedFormItemSkin_Group2() : Group
      {
         return this._1533320022_StackedFormItemSkin_Group2;
      }
      
      public function set _StackedFormItemSkin_Group2(param1:Group) : void
      {
         var _loc2_:Object = this._1533320022_StackedFormItemSkin_Group2;
         if(_loc2_ !== param1)
         {
            this._1533320022_StackedFormItemSkin_Group2 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_StackedFormItemSkin_Group2",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get _StackedFormItemSkin_SetProperty1() : SetProperty
      {
         return this._1084214723_StackedFormItemSkin_SetProperty1;
      }
      
      public function set _StackedFormItemSkin_SetProperty1(param1:SetProperty) : void
      {
         var _loc2_:Object = this._1084214723_StackedFormItemSkin_SetProperty1;
         if(_loc2_ !== param1)
         {
            this._1084214723_StackedFormItemSkin_SetProperty1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_StackedFormItemSkin_SetProperty1",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get _StackedFormItemSkin_SetProperty2() : SetProperty
      {
         return this._1084214722_StackedFormItemSkin_SetProperty2;
      }
      
      public function set _StackedFormItemSkin_SetProperty2(param1:SetProperty) : void
      {
         var _loc2_:Object = this._1084214722_StackedFormItemSkin_SetProperty2;
         if(_loc2_ !== param1)
         {
            this._1084214722_StackedFormItemSkin_SetProperty2 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_StackedFormItemSkin_SetProperty2",_loc2_,param1));
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
      public function get contentCol() : ConstraintColumn
      {
         return this._264525383contentCol;
      }
      
      public function set contentCol(param1:ConstraintColumn) : void
      {
         var _loc2_:Object = this._264525383contentCol;
         if(_loc2_ !== param1)
         {
            this._264525383contentCol = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"contentCol",_loc2_,param1));
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
      public function get helpCol() : ConstraintColumn
      {
         return this._805791359helpCol;
      }
      
      public function set helpCol(param1:ConstraintColumn) : void
      {
         var _loc2_:Object = this._805791359helpCol;
         if(_loc2_ !== param1)
         {
            this._805791359helpCol = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"helpCol",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get helpContentGroup() : Group
      {
         return this._205258905helpContentGroup;
      }
      
      public function set helpContentGroup(param1:Group) : void
      {
         var _loc2_:Object = this._205258905helpContentGroup;
         if(_loc2_ !== param1)
         {
            this._205258905helpContentGroup = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"helpContentGroup",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get indicatorDisplay() : Image
      {
         return this._1746021453indicatorDisplay;
      }
      
      public function set indicatorDisplay(param1:Image) : void
      {
         var _loc2_:Object = this._1746021453indicatorDisplay;
         if(_loc2_ !== param1)
         {
            this._1746021453indicatorDisplay = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"indicatorDisplay",_loc2_,param1));
            }
         }
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
      public function get row1() : ConstraintRow
      {
         return this._3506583row1;
      }
      
      public function set row1(param1:ConstraintRow) : void
      {
         var _loc2_:Object = this._3506583row1;
         if(_loc2_ !== param1)
         {
            this._3506583row1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"row1",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get row2() : ConstraintRow
      {
         return this._3506584row2;
      }
      
      public function set row2(param1:ConstraintRow) : void
      {
         var _loc2_:Object = this._3506584row2;
         if(_loc2_ !== param1)
         {
            this._3506584row2 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"row2",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get sequenceCol() : ConstraintColumn
      {
         return this._805245441sequenceCol;
      }
      
      public function set sequenceCol(param1:ConstraintColumn) : void
      {
         var _loc2_:Object = this._805245441sequenceCol;
         if(_loc2_ !== param1)
         {
            this._805245441sequenceCol = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"sequenceCol",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get sequenceLabelDisplay() : Label
      {
         return this._832334223sequenceLabelDisplay;
      }
      
      public function set sequenceLabelDisplay(param1:Label) : void
      {
         var _loc2_:Object = this._832334223sequenceLabelDisplay;
         if(_loc2_ !== param1)
         {
            this._832334223sequenceLabelDisplay = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"sequenceLabelDisplay",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get hostComponent() : FormItem
      {
         return this._213507019hostComponent;
      }
      
      public function set hostComponent(param1:FormItem) : void
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

