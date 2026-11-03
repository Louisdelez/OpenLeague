package com.riotgames.platform.gameclient.components
{
   import flash.display.GradientType;
   import flash.geom.Matrix;
   import flash.text.TextField;
   import flash.text.TextFormat;
   import mx.core.UIComponent;
   
   public class GradientTextField extends UIComponent
   {
      
      public static const BRONZE_COLORS:Array = [16312016,11765595];
      
      public static const SILVER_COLORS:Array = [16250871,11711154];
      
      public static const GOLD_COLORS:Array = [16447452,16772442];
      
      public static const PLATINUM_COLORS:Array = [16251386,11919359];
      
      public static const GREEN_COLORS:Array = [9887912,55552];
      
      public static const RED_COLORS:Array = [16774902,14942210];
      
      public static const BLUE_COLORS:Array = [13297663,40191];
      
      public static const PURPLE_COLORS:Array = [15583999,11403519];
      
      protected var textChanged:Boolean = false;
      
      protected var embedFontsChanged:Boolean = false;
      
      protected var _embedFonts:Boolean = true;
      
      protected var _text:String;
      
      protected var textField:TextField;
      
      protected var _textAlign:String = "left";
      
      protected var textAlignChanged:Boolean = false;
      
      public function GradientTextField()
      {
         super();
         super.cacheAsBitmap = true;
      }
      
      override public function styleChanged(param1:String) : void
      {
         super.styleChanged(param1);
         this.updateTextFieldStyles(this.textField);
      }
      
      override public function set cacheAsBitmap(param1:Boolean) : void
      {
      }
      
      override protected function commitProperties() : void
      {
         super.commitProperties();
         if(this.textChanged && Boolean(this.textField))
         {
            this.textField.text = this.text;
            this.textChanged = false;
         }
         if(this.embedFontsChanged && Boolean(this.textField))
         {
            this.textField.embedFonts = this.embedFonts;
            this.embedFontsChanged = false;
         }
         if(this.textAlignChanged && Boolean(this.textField))
         {
            this.textField.autoSize = this.textAlign;
            this.textAlignChanged = false;
         }
      }
      
      protected function drawBackground(param1:Number, param2:Number) : void
      {
         var _loc3_:Array = [0,0];
         if(getStyle("fillColors"))
         {
            _loc3_ = getStyle("fillColors");
         }
         var _loc4_:Matrix = new Matrix();
         _loc4_.createGradientBox(param1,param2,Math.PI / 2);
         var _loc5_:Array = [1,1];
         var _loc6_:Array = [0,190];
         graphics.clear();
         graphics.beginGradientFill(GradientType.LINEAR,_loc3_,_loc5_,_loc6_,_loc4_);
         graphics.drawRect(0,0,param1,param2);
         graphics.endFill();
      }
      
      public function set embedFonts(param1:Boolean) : void
      {
         this._embedFonts = param1;
         this.embedFontsChanged = true;
         invalidateProperties();
      }
      
      public function get textAlign() : String
      {
         return this._textAlign;
      }
      
      public function set text(param1:String) : void
      {
         this._text = param1;
         this.textChanged = true;
         invalidateProperties();
         invalidateSize();
      }
      
      override protected function measure() : void
      {
         super.measure();
         if(this.textField)
         {
            measuredWidth = this.textField.width;
            measuredHeight = this.textField.height;
         }
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.textField = this.createTextField();
         if(this.textField)
         {
            addChild(this.textField);
            this.mask = this.textField;
         }
      }
      
      protected function updateTextFieldStyles(param1:TextField) : void
      {
         var _loc2_:String = null;
         var _loc3_:Object = null;
         var _loc4_:String = null;
         var _loc5_:TextFormat = null;
         if(param1)
         {
            _loc2_ = getStyle("fontFamily");
            _loc3_ = getStyle("fontSize");
            _loc4_ = getStyle("fontAntiAliasType");
            _loc5_ = new TextFormat(_loc2_,_loc3_);
            param1.defaultTextFormat = _loc5_;
            param1.setTextFormat(param1.defaultTextFormat);
            param1.antiAliasType = _loc4_;
         }
      }
      
      override protected function childrenCreated() : void
      {
         super.childrenCreated();
         if(this.textField)
         {
            this.textField.cacheAsBitmap = true;
            this.textField.autoSize = this._textAlign;
            this.textField.embedFonts = this._embedFonts;
            this.updateTextFieldStyles(this.textField);
         }
      }
      
      public function get embedFonts() : Boolean
      {
         return this._embedFonts;
      }
      
      public function get text() : String
      {
         return this._text;
      }
      
      public function set textAlign(param1:String) : void
      {
         this._textAlign = param1;
         this.textAlignChanged = true;
         invalidateProperties();
      }
      
      protected function createTextField() : TextField
      {
         return new TextField();
      }
      
      override protected function updateDisplayList(param1:Number, param2:Number) : void
      {
         super.updateDisplayList(param1,param2);
         this.drawBackground(param1,param2);
         if(this.textField)
         {
            this.textField.x = 0;
            this.textField.y = 0;
            this.textField.width = param1;
            this.textField.height = param2;
         }
      }
   }
}

