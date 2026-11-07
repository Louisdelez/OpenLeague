package mx.skins.spark
{
   import mx.binding.BindingManager;
   import mx.core.IFlexModuleFactory;
   import mx.events.PropertyChangeEvent;
   import mx.graphics.SolidColor;
   import mx.graphics.SolidColorStroke;
   import mx.styles.StyleManager;
   import mx.utils.ColorUtil;
   import spark.components.supportClasses.Skin;
   import spark.primitives.Rect;
   
   public class DateChooserRollOverIndicatorSkin extends Skin
   {
      
      private var _3143043fill:SolidColor;
      
      private var _3496420rect:Rect;
      
      private var _891980232stroke:SolidColorStroke;
      
      private var __moduleFactoryInitialized:Boolean = false;
      
      public function DateChooserRollOverIndicatorSkin()
      {
         super();
         mx_internal::_document = this;
         this.mxmlContent = [this._DateChooserRollOverIndicatorSkin_Rect1_i()];
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
         var rollOverColor:uint = uint(getStyle("rollOverColor"));
         if(rollOverColor != StyleManager.NOT_A_COLOR)
         {
            this.fill.color = rollOverColor;
            this.stroke.color = ColorUtil.adjustBrightness(rollOverColor,-45);
         }
         super.updateDisplayList(unscaledWidth,unscaledHeight);
      }
      
      private function _DateChooserRollOverIndicatorSkin_Rect1_i() : Rect
      {
         var _loc1_:Rect = new Rect();
         _loc1_.left = 0;
         _loc1_.right = 0;
         _loc1_.top = 0;
         _loc1_.bottom = 0;
         _loc1_.fill = this._DateChooserRollOverIndicatorSkin_SolidColor1_i();
         _loc1_.stroke = this._DateChooserRollOverIndicatorSkin_SolidColorStroke1_i();
         _loc1_.initialized(this,"rect");
         this.rect = _loc1_;
         BindingManager.executeBindings(this,"rect",this.rect);
         return _loc1_;
      }
      
      private function _DateChooserRollOverIndicatorSkin_SolidColor1_i() : SolidColor
      {
         var _loc1_:SolidColor = new SolidColor();
         _loc1_.color = 16777215;
         _loc1_.alpha = 1;
         this.fill = _loc1_;
         BindingManager.executeBindings(this,"fill",this.fill);
         return _loc1_;
      }
      
      private function _DateChooserRollOverIndicatorSkin_SolidColorStroke1_i() : SolidColorStroke
      {
         var _loc1_:SolidColorStroke = new SolidColorStroke();
         _loc1_.color = 7179175;
         _loc1_.alpha = 1;
         this.stroke = _loc1_;
         BindingManager.executeBindings(this,"stroke",this.stroke);
         return _loc1_;
      }
      
      [Bindable(event="propertyChange")]
      public function get fill() : SolidColor
      {
         return this._3143043fill;
      }
      
      public function set fill(param1:SolidColor) : void
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
      public function get rect() : Rect
      {
         return this._3496420rect;
      }
      
      public function set rect(param1:Rect) : void
      {
         var _loc2_:Object = this._3496420rect;
         if(_loc2_ !== param1)
         {
            this._3496420rect = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"rect",_loc2_,param1));
            }
         }
      }
      
      [Bindable(event="propertyChange")]
      public function get stroke() : SolidColorStroke
      {
         return this._891980232stroke;
      }
      
      public function set stroke(param1:SolidColorStroke) : void
      {
         var _loc2_:Object = this._891980232stroke;
         if(_loc2_ !== param1)
         {
            this._891980232stroke = param1;
            if(this.hasEventListener("propertyChange"))
            {
               this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"stroke",_loc2_,param1));
            }
         }
      }
   }
}

