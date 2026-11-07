package blix.components.scroll
{
   import blix.context.Context;
   import blix.layout.vo.MinMax;
   import blix.layout.vo.SizeConstraints;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class HScrollBarX extends ScrollBarBase
   {
      
      public function HScrollBarX(param1:Context, param2:Sprite = null)
      {
         super(param1,param2);
      }
      
      override protected function getPageSize() : Number
      {
         var _loc1_:Number = Number(Number(stepDownButton.getWidth()) || 0);
         var _loc2_:Number = Number(Number(stepDownButton.getWidth()) || 0);
         return (_unscaledBounds.width - _loc1_ - _loc2_) / modelToPixels;
      }
      
      override protected function trackMouseDownHandler(param1:MouseEvent) : void
      {
         var _loc2_:Rectangle = thumbButton.getScaledBounds();
         var _loc3_:Number = Number(getMouseX());
         if(_loc3_ > _loc2_.left && _loc3_ < _loc2_.right)
         {
            return;
         }
         var _loc4_:Number = _loc2_.x + _loc2_.width / 2;
         var _loc5_:Number = this.getPageSize();
         if(_loc3_ < _loc4_)
         {
            _loc5_ = -_loc5_;
         }
         _scrollModel.setValue(_scrollModel.clampValue(_scrollModel.getValue() + _loc5_));
      }
      
      override protected function getDragBounds() : Rectangle
      {
         validate();
         return new Rectangle(this.getMinX(),thumbButton.getY(),this.getMaxX(_unscaledBounds.width) - thumbButton.getWidth() - this.getMinX(),0);
      }
      
      override protected function updateScrollModelValue() : void
      {
         var _loc1_:Number = this.getMinX();
         var _loc2_:Number = this.getMaxX(_unscaledBounds.width);
         var _loc3_:Number = (thumbButton.getX() - _loc1_) / (_loc2_ - _loc1_ - thumbButton.getWidth());
         if(_loc3_ > 0.99)
         {
            _loc3_ = 1;
         }
         if(_loc3_ < 0.01)
         {
            _loc3_ = 0;
         }
         var _loc4_:Number = _loc3_ * (_scrollModel.getMax() - _scrollModel.getMin()) + _scrollModel.getMin();
         _scrollModel.setValue(_loc4_);
      }
      
      override public function updateSizeConstraints(param1:Number, param2:Number) : SizeConstraints
      {
         return new SizeConstraints(new MinMax(stepUpButton.getWidth() + stepDownButton.getWidth(),10000),new MinMax(stepUpButton.getHeight(),stepUpButton.getHeight()));
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc5_:Number = NaN;
         var _loc10_:Point = null;
         super.updateLayout(param1,param2);
         var _loc3_:Number = isNaN(param1) ? defaultBounds.width : param1;
         var _loc4_:Number = _scrollModel.getMax() - _scrollModel.getMin();
         if(_loc4_ <= 0.000001)
         {
            _loc5_ = 0;
         }
         else
         {
            _loc5_ = (_scrollModel.getClampedValue() - _scrollModel.getMin()) / _loc4_;
         }
         var _loc6_:Number = this.getMinX();
         var _loc7_:Number = this.getMaxX(_loc3_);
         var _loc8_:Number = Math.round(_loc7_ - _loc6_ + 0.000001);
         var _loc9_:Number = _loc8_ * _loc8_ / (_loc8_ + _loc4_ * modelToPixels);
         stepDownButton.setExplicitPosition(0,0);
         stepUpButton.setExplicitPosition(_loc7_,0);
         if(!_isDragging)
         {
            _loc10_ = thumbButton.setExplicitSize(_loc9_,NaN);
            thumbButton.setVisible(thumbButton.getEnabled() && Math.round(_loc10_.x) < _loc8_);
            thumbButton.setExplicitPosition(_loc5_ * (_loc8_ - thumbButton.getWidth()) + _loc6_,0);
         }
         track.setExplicitSize(_loc3_,NaN);
         track.setExplicitPosition(0,0);
         return new Rectangle(0,0,_loc3_,getHeight());
      }
      
      protected function getMinX() : Number
      {
         return Number(stepDownButton.getWidth()) || 0;
      }
      
      protected function getMaxX(param1:Number) : Number
      {
         return param1 - (stepUpButton.getWidth() || 0);
      }
   }
}

