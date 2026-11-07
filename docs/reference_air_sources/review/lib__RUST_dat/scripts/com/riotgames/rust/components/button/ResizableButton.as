package com.riotgames.rust.components.button
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.button.LabelButtonX;
   import blix.context.IContext;
   import blix.layout.vo.HorizontalAlign;
   import blix.view.behaviors.ScalingTransformBehavior;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextFieldAutoSize;
   
   public class ResizableButton extends LabelButtonX
   {
      
      protected var button:SpriteProxy;
      
      protected var _horizontalAlign:uint = 2;
      
      protected var _leftPadding:Number = 5;
      
      protected var _rightPadding:Number = 5;
      
      protected var _minWidth:Number = 20;
      
      public function ResizableButton(param1:IContext)
      {
         super(param1);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         textField.getLayoutInvalidated().add(invalidateLayout);
         textField.setAutoSize(TextFieldAutoSize.LEFT);
         if(!this.button)
         {
            this.button = new SpriteProxy(this);
            setTimelineChildByName("button",this.button);
         }
         this.button.getLayoutInvalidated().add(invalidateLayout);
         this.button.setTransformBehavior(new ScalingTransformBehavior());
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:Point = textField.setExplicitSize(NaN,NaN);
         var _loc4_:Point = this.button.setExplicitSize(Math.max(this._minWidth,_loc3_.x + this._leftPadding + this._rightPadding),NaN);
         switch(this._horizontalAlign)
         {
            case HorizontalAlign.CENTER:
            case HorizontalAlign.DEFAULT:
               textField.setExplicitPosition(_loc4_.x - _loc3_.x >> 1,NaN);
               break;
            case HorizontalAlign.LEFT:
               textField.setExplicitPosition(this.leftPadding,NaN);
               break;
            case HorizontalAlign.RIGHT:
               textField.setExplicitPosition(_loc4_.x - (_loc3_.x + this.rightPadding),NaN);
         }
         if(Boolean(_hitArea))
         {
            _hitArea.setExplicitSize(_loc4_.x,_loc4_.y);
         }
         return super.updateLayout(param1,param2);
      }
      
      public function get horizontalAlign() : uint
      {
         return this._horizontalAlign;
      }
      
      public function set horizontalAlign(param1:uint) : void
      {
         this._horizontalAlign = param1;
         invalidateLayout();
      }
      
      public function get leftPadding() : Number
      {
         return this._leftPadding;
      }
      
      public function set leftPadding(param1:Number) : void
      {
         this._leftPadding = param1;
         invalidateLayout();
      }
      
      public function get rightPadding() : Number
      {
         return this._rightPadding;
      }
      
      public function set rightPadding(param1:Number) : void
      {
         this._rightPadding = param1;
         invalidateLayout();
      }
      
      public function get minWidth() : Number
      {
         return this._minWidth;
      }
      
      public function set minWidth(param1:Number) : void
      {
         this._minWidth = param1;
         invalidateLayout();
      }
   }
}

