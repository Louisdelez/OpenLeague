package mx.skins.spark
{
   import mx.binding.BindingManager;
   import mx.core.IFlexModuleFactory;
   import mx.core.IStateClient2;
   import mx.events.PropertyChangeEvent;
   import mx.graphics.GradientEntry;
   import mx.graphics.RadialGradient;
   import mx.graphics.SolidColor;
   import mx.states.SetProperty;
   import mx.states.State;
   import spark.components.Group;
   import spark.primitives.Ellipse;
   import spark.primitives.Path;
   import spark.primitives.Rect;
   import spark.skins.SparkSkin;
   
   [States("disabled")]
   public class DateChooserPrevYearSkin extends SparkSkin implements IStateClient2
   {
      
      private static const exclusions:Array = ["arrow","arrowHighlight1","arrowHighlight2"];
      
      private static const symbols:Array = ["arrowFill1","arrowFill2","arrowFill3"];
      
      private var _1323687179_DateChooserPrevYearSkin_SolidColor1:SolidColor;
      
      private var _93090825arrow:Path;
      
      private var _1752992635arrowFill1:GradientEntry;
      
      private var _1752992634arrowFill2:GradientEntry;
      
      private var _1752992633arrowFill3:GradientEntry;
      
      private var _273440026arrowHighlight1:Path;
      
      private var _273440025arrowHighlight2:Path;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      public function DateChooserPrevYearSkin()
      {
         super();
         mx_internal::_document = this;
         this.minWidth = 7;
         this.minHeight = 6;
         this.mxmlContent = [this._DateChooserPrevYearSkin_Ellipse1_c(),this._DateChooserPrevYearSkin_Path1_i(),this._DateChooserPrevYearSkin_Path2_i(),this._DateChooserPrevYearSkin_Path3_i()];
         this.currentState = "up";
         states = [new State({
            "name":"up",
            "overrides":[]
         }),new State({
            "name":"over",
            "overrides":[new SetProperty().initializeFromObject({
               "target":"_DateChooserPrevYearSkin_SolidColor1",
               "name":"alpha",
               "value":0.12
            })]
         }),new State({
            "name":"down",
            "overrides":[new SetProperty().initializeFromObject({
               "target":"_DateChooserPrevYearSkin_SolidColor1",
               "name":"alpha",
               "value":0.22
            })]
         }),new State({
            "name":"disabled",
            "overrides":[new SetProperty().initializeFromObject({
               "name":"alpha",
               "value":0.5
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
      
      private function _DateChooserPrevYearSkin_Ellipse1_c() : Ellipse
      {
         var _loc1_:Ellipse = new Ellipse();
         _loc1_.left = -5;
         _loc1_.right = -5;
         _loc1_.top = -9;
         _loc1_.bottom = -3;
         _loc1_.fill = this._DateChooserPrevYearSkin_SolidColor1_i();
         _loc1_.mask = this._DateChooserPrevYearSkin_Group1_c();
         _loc1_.initialized(this,null);
         return _loc1_;
      }
      
      private function _DateChooserPrevYearSkin_SolidColor1_i() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         _loc1_.color = 0;
         _loc1_.alpha = 0;
         this._DateChooserPrevYearSkin_SolidColor1 = _loc1_;
         BindingManager.executeBindings(this,"_DateChooserPrevYearSkin_SolidColor1",this._DateChooserPrevYearSkin_SolidColor1);
         return _loc1_;
      }
      
      private function _DateChooserPrevYearSkin_Group1_c() : Group
      {
         var _loc1_:Group = new Group();
         _loc1_.left = 0;
         _loc1_.right = 0;
         _loc1_.top = 0;
         _loc1_.bottom = 0;
         _loc1_.mxmlContent = [this._DateChooserPrevYearSkin_Rect1_c()];
         if(!_loc1_.document)
         {
            _loc1_.document = this;
         }
         return _loc1_;
      }
      
      private function _DateChooserPrevYearSkin_Rect1_c() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.left = 0;
         _loc1_.right = -20;
         _loc1_.top = 8;
         _loc1_.bottom = -18;
         _loc1_.fill = this._DateChooserPrevYearSkin_SolidColor2_c();
         _loc1_.initialized(this,null);
         return _loc1_;
      }
      
      private function _DateChooserPrevYearSkin_SolidColor2_c() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         _loc1_.alpha = 0;
         return _loc1_;
      }
      
      private function _DateChooserPrevYearSkin_Path1_i() : Path
      {
         var _loc1_:Path = new Path();
         _loc1_.top = 1;
         _loc1_.left = 1;
         _loc1_.data = "M 0 0 L 0 1 L 1 1 L 1 2 L 2 2 L 2 3 L 3 3 L 3 2 L 4 2 L 4 1 L 5 1 L 5 0 L 0 0 Z";
         _loc1_.fill = this._DateChooserPrevYearSkin_RadialGradient1_c();
         _loc1_.initialized(this,"arrow");
         this.arrow = _loc1_;
         BindingManager.executeBindings(this,"arrow",this.arrow);
         return _loc1_;
      }
      
      private function _DateChooserPrevYearSkin_RadialGradient1_c() : RadialGradient
      {
         var _loc1_:RadialGradient = new RadialGradient();
         _loc1_.x = 2;
         _loc1_.y = 1.5;
         _loc1_.entries = [this._DateChooserPrevYearSkin_GradientEntry1_i(),this._DateChooserPrevYearSkin_GradientEntry2_i(),this._DateChooserPrevYearSkin_GradientEntry3_i()];
         return _loc1_;
      }
      
      private function _DateChooserPrevYearSkin_GradientEntry1_i() : GradientEntry
      {
         var _loc1_:GradientEntry = new GradientEntry();
         _loc1_.color = 0;
         _loc1_.alpha = 0.45;
         _loc1_.ratio = 0;
         this.arrowFill1 = _loc1_;
         BindingManager.executeBindings(this,"arrowFill1",this.arrowFill1);
         return _loc1_;
      }
      
      private function _DateChooserPrevYearSkin_GradientEntry2_i() : GradientEntry
      {
         var _loc1_:GradientEntry = new GradientEntry();
         _loc1_.color = 0;
         _loc1_.alpha = 0.7;
         _loc1_.ratio = 0.75;
         this.arrowFill2 = _loc1_;
         BindingManager.executeBindings(this,"arrowFill2",this.arrowFill2);
         return _loc1_;
      }
      
      private function _DateChooserPrevYearSkin_GradientEntry3_i() : GradientEntry
      {
         var _loc1_:GradientEntry = new GradientEntry();
         _loc1_.color = 0;
         _loc1_.alpha = 0.8;
         _loc1_.ratio = 1;
         this.arrowFill3 = _loc1_;
         BindingManager.executeBindings(this,"arrowFill3",this.arrowFill3);
         return _loc1_;
      }
      
      private function _DateChooserPrevYearSkin_Path2_i() : Path
      {
         var _loc1_:Path = new Path();
         _loc1_.top = 2;
         _loc1_.left = 1;
         _loc1_.data = "M 0 1 L 0 2 L 1 2 L 1 3 L 2 3 L 2 4 L 3 4 L 3 3 Z";
         _loc1_.fill = this._DateChooserPrevYearSkin_SolidColor3_c();
         _loc1_.initialized(this,"arrowHighlight1");
         this.arrowHighlight1 = _loc1_;
         BindingManager.executeBindings(this,"arrowHighlight1",this.arrowHighlight1);
         return _loc1_;
      }
      
      private function _DateChooserPrevYearSkin_SolidColor3_c() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         _loc1_.color = 16777215;
         return _loc1_;
      }
      
      private function _DateChooserPrevYearSkin_Path3_i() : Path
      {
         var _loc1_:Path = new Path();
         _loc1_.top = 2;
         _loc1_.left = 3;
         _loc1_.data = "M 2 3.5 L 3 4 L 3 3 L 4 3 L 4 2 L 5 2 L 5 1 Z";
         _loc1_.fill = this._DateChooserPrevYearSkin_SolidColor4_c();
         _loc1_.initialized(this,"arrowHighlight2");
         this.arrowHighlight2 = _loc1_;
         BindingManager.executeBindings(this,"arrowHighlight2",this.arrowHighlight2);
         return _loc1_;
      }
      
      private function _DateChooserPrevYearSkin_SolidColor4_c() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         _loc1_.color = 16777215;
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      [Inspectable]
      public function get _DateChooserPrevYearSkin_SolidColor1() : SolidColor
      {
         return this._1323687179_DateChooserPrevYearSkin_SolidColor1;
      }
      
      public function set _DateChooserPrevYearSkin_SolidColor1(param1:SolidColor) : void
      {
         var _loc2_:Object = this._1323687179_DateChooserPrevYearSkin_SolidColor1;
         if(_loc2_ !== param1)
         {
            this._1323687179_DateChooserPrevYearSkin_SolidColor1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_DateChooserPrevYearSkin_SolidColor1",_loc2_,param1));
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
      
      [Bindable(event="propertyChange")]
      public function get arrowFill3() : GradientEntry
      {
         return this._1752992633arrowFill3;
      }
      
      public function set arrowFill3(param1:GradientEntry) : void
      {
         var _loc2_:Object = this._1752992633arrowFill3;
         if(_loc2_ !== param1)
         {
            this._1752992633arrowFill3 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"arrowFill3",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get arrowHighlight1() : Path
      {
         return this._273440026arrowHighlight1;
      }
      
      public function set arrowHighlight1(param1:Path) : void
      {
         var _loc2_:Object = this._273440026arrowHighlight1;
         if(_loc2_ !== param1)
         {
            this._273440026arrowHighlight1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"arrowHighlight1",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get arrowHighlight2() : Path
      {
         return this._273440025arrowHighlight2;
      }
      
      public function set arrowHighlight2(param1:Path) : void
      {
         var _loc2_:Object = this._273440025arrowHighlight2;
         if(_loc2_ !== param1)
         {
            this._273440025arrowHighlight2 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"arrowHighlight2",_loc2_,param1));
            }
         }
      }
   }
}

