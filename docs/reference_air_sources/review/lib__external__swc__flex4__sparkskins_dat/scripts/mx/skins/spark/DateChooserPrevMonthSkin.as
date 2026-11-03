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
   import spark.primitives.Ellipse;
   import spark.primitives.Path;
   import spark.skins.SparkSkin;
   
   [States("disabled")]
   public class DateChooserPrevMonthSkin extends SparkSkin implements IStateClient2
   {
      
      private static const exclusions:Array = ["arrow","arrowHighlight"];
      
      private static const symbols:Array = ["arrowFill1","arrowFill2","arrowFill3"];
      
      private var _644971050_DateChooserPrevMonthSkin_SolidColor1:SolidColor;
      
      private var _93090825arrow:Path;
      
      private var _1752992635arrowFill1:GradientEntry;
      
      private var _1752992634arrowFill2:GradientEntry;
      
      private var _1752992633arrowFill3:GradientEntry;
      
      private var _1532841301arrowHighlight:Path;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      public function DateChooserPrevMonthSkin()
      {
         super();
         mx_internal::_document = this;
         this.minWidth = 21;
         this.minHeight = 9;
         this.mxmlContent = [this._DateChooserPrevMonthSkin_Ellipse1_c(),this._DateChooserPrevMonthSkin_Path1_i(),this._DateChooserPrevMonthSkin_Path2_i()];
         this.currentState = "up";
         states = [new State({
            "name":"up",
            "overrides":[]
         }),new State({
            "name":"over",
            "overrides":[new SetProperty().initializeFromObject({
               "target":"_DateChooserPrevMonthSkin_SolidColor1",
               "name":"alpha",
               "value":0.12
            })]
         }),new State({
            "name":"down",
            "overrides":[new SetProperty().initializeFromObject({
               "target":"_DateChooserPrevMonthSkin_SolidColor1",
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
      
      private function _DateChooserPrevMonthSkin_Ellipse1_c() : Ellipse
      {
         var _loc1_:Ellipse = new Ellipse();
         _loc1_.left = -1;
         _loc1_.right = 5;
         _loc1_.top = -4;
         _loc1_.bottom = -3;
         _loc1_.fill = this._DateChooserPrevMonthSkin_SolidColor1_i();
         _loc1_.initialized(this,null);
         return _loc1_;
      }
      
      private function _DateChooserPrevMonthSkin_SolidColor1_i() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         _loc1_.color = 0;
         _loc1_.alpha = 0;
         this._DateChooserPrevMonthSkin_SolidColor1 = _loc1_;
         BindingManager.executeBindings(this,"_DateChooserPrevMonthSkin_SolidColor1",this._DateChooserPrevMonthSkin_SolidColor1);
         return _loc1_;
      }
      
      private function _DateChooserPrevMonthSkin_Path1_i() : Path
      {
         var _loc1_:Path = new Path();
         _loc1_.left = 4;
         _loc1_.verticalCenter = -1;
         _loc1_.data = "M 0 4 L 1 4 L 1 3 L 2 3 L 2 2 L 3 2 L 3 1 L 4 1 L 4 0 L 5 0 L 5 9 L 4 9 L 4 8 L 3 8 L 3 7 L 2 7 L 2 6 L 1 6 L 1 5 L 0 5 L 0 4 Z";
         _loc1_.fill = this._DateChooserPrevMonthSkin_RadialGradient1_c();
         _loc1_.initialized(this,"arrow");
         this.arrow = _loc1_;
         BindingManager.executeBindings(this,"arrow",this.arrow);
         return _loc1_;
      }
      
      private function _DateChooserPrevMonthSkin_RadialGradient1_c() : RadialGradient
      {
         var _loc1_:RadialGradient = new RadialGradient();
         _loc1_.rotation = 45;
         _loc1_.focalPointRatio = -0.4;
         _loc1_.x = 4;
         _loc1_.y = 5;
         _loc1_.scaleX = 7;
         _loc1_.entries = [this._DateChooserPrevMonthSkin_GradientEntry1_i(),this._DateChooserPrevMonthSkin_GradientEntry2_i(),this._DateChooserPrevMonthSkin_GradientEntry3_i()];
         return _loc1_;
      }
      
      private function _DateChooserPrevMonthSkin_GradientEntry1_i() : GradientEntry
      {
         var _loc1_:GradientEntry = new GradientEntry();
         _loc1_.color = 0;
         _loc1_.alpha = 0.45;
         _loc1_.ratio = 0;
         this.arrowFill1 = _loc1_;
         BindingManager.executeBindings(this,"arrowFill1",this.arrowFill1);
         return _loc1_;
      }
      
      private function _DateChooserPrevMonthSkin_GradientEntry2_i() : GradientEntry
      {
         var _loc1_:GradientEntry = new GradientEntry();
         _loc1_.color = 0;
         _loc1_.alpha = 0.55;
         _loc1_.ratio = 0.9;
         this.arrowFill2 = _loc1_;
         BindingManager.executeBindings(this,"arrowFill2",this.arrowFill2);
         return _loc1_;
      }
      
      private function _DateChooserPrevMonthSkin_GradientEntry3_i() : GradientEntry
      {
         var _loc1_:GradientEntry = new GradientEntry();
         _loc1_.color = 0;
         _loc1_.alpha = 0.75;
         _loc1_.ratio = 1;
         this.arrowFill3 = _loc1_;
         BindingManager.executeBindings(this,"arrowFill3",this.arrowFill3);
         return _loc1_;
      }
      
      private function _DateChooserPrevMonthSkin_Path2_i() : Path
      {
         var _loc1_:Path = new Path();
         _loc1_.left = 4;
         _loc1_.verticalCenter = 2;
         _loc1_.data = "M 0 5 L 1 5 L 1 6 L 2 6 L 2 7 L 3 7 L 3 8 L 4 8 L 4 9 L 5 9 L 5 10";
         _loc1_.fill = this._DateChooserPrevMonthSkin_SolidColor2_c();
         _loc1_.initialized(this,"arrowHighlight");
         this.arrowHighlight = _loc1_;
         BindingManager.executeBindings(this,"arrowHighlight",this.arrowHighlight);
         return _loc1_;
      }
      
      private function _DateChooserPrevMonthSkin_SolidColor2_c() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         _loc1_.color = 16777215;
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      [Inspectable]
      public function get _DateChooserPrevMonthSkin_SolidColor1() : SolidColor
      {
         return this._644971050_DateChooserPrevMonthSkin_SolidColor1;
      }
      
      public function set _DateChooserPrevMonthSkin_SolidColor1(param1:SolidColor) : void
      {
         var _loc2_:Object = this._644971050_DateChooserPrevMonthSkin_SolidColor1;
         if(_loc2_ !== param1)
         {
            this._644971050_DateChooserPrevMonthSkin_SolidColor1 = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"_DateChooserPrevMonthSkin_SolidColor1",_loc2_,param1));
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
      public function get arrowHighlight() : Path
      {
         return this._1532841301arrowHighlight;
      }
      
      public function set arrowHighlight(param1:Path) : void
      {
         var _loc2_:Object = this._1532841301arrowHighlight;
         if(_loc2_ !== param1)
         {
            this._1532841301arrowHighlight = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"arrowHighlight",_loc2_,param1));
            }
         }
      }
   }
}

