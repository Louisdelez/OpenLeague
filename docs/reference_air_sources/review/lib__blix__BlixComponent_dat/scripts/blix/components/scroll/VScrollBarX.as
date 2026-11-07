package blix.components.scroll
{
   import blix.context.Context;
   import blix.layout.vo.MinMax;
   import blix.layout.vo.SizeConstraints;
   import flash.display.Sprite;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class VScrollBarX extends ScrollBarBase
   {
      
      public function VScrollBarX(param1:Context, param2:Sprite = null)
      {
         super(param1,param2);
      }
      
      override protected function getPageSize() : Number
      {
         var _loc1_:Number = Number(Number(stepDownButton.getHeight()) || 0);
         var _loc2_:Number = Number(Number(stepDownButton.getHeight()) || 0);
         return (_unscaledBounds.height - _loc1_ - _loc2_) / modelToPixels;
      }
      
      override protected function trackMouseDownHandler(param1:MouseEvent) : void
      {
         var _loc2_:Rectangle = thumbButton.getScaledBounds();
         var _loc3_:Number = Number(getMouseY());
         if(_loc3_ > _loc2_.top && _loc3_ < _loc2_.bottom)
         {
            return;
         }
         var _loc4_:Number = _loc2_.y + _loc2_.height / 2;
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
         return new Rectangle(thumbButton.getX(),this.getMinY(),0,this.getMaxY(_unscaledBounds.height) - thumbButton.getHeight() - this.getMinY());
      }
      
      override protected function updateScrollModelValue() : void
      {
         var _loc1_:Number = this.getMinY();
         var _loc2_:Number = this.getMaxY(_unscaledBounds.height);
         var _loc3_:Number = (thumbButton.getY() - _loc1_) / (_loc2_ - _loc1_ - thumbButton.getHeight());
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
         return new SizeConstraints(new MinMax(stepUpButton.getWidth(),stepUpButton.getWidth()),new MinMax(stepUpButton.getHeight() + stepDownButton.getHeight(),10000));
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc5_:Number = NaN;
         var _loc10_:Point = null;
         super.updateLayout(param1,param2);
         var _loc3_:Number = isNaN(param2) ? defaultBounds.height : param2;
         var _loc4_:Number = _scrollModel.getMax() - _scrollModel.getMin();
         if(_loc4_ <= 0.000001)
         {
            _loc5_ = 0;
         }
         else
         {
            _loc5_ = (_scrollModel.getClampedValue() - _scrollModel.getMin()) / _loc4_;
         }
         var _loc6_:Number = this.getMinY();
         var _loc7_:Number = this.getMaxY(_loc3_);
         var _loc8_:Number = Math.round(_loc7_ - _loc6_ + 0.000001);
         var _loc9_:Number = _loc8_ * _loc8_ / (_loc8_ + _loc4_ * modelToPixels);
         stepDownButton.setExplicitPosition(0,0);
         stepUpButton.setExplicitPosition(0,_loc7_);
         if(!_isDragging)
         {
            _loc10_ = thumbButton.setExplicitSize(NaN,_loc9_);
            thumbButton.setVisible(thumbButton.getEnabled() && Math.round(_loc10_.y) < _loc8_);
            thumbButton.setExplicitPosition(0,_loc5_ * (_loc8_ - thumbButton.getHeight()) + _loc6_);
         }
         track.setExplicitSize(NaN,_loc3_);
         track.setExplicitPosition(0,0);
         return new Rectangle(0,0,getWidth(),_loc3_);
      }
      
      protected function getMinY() : Number
      {
         return Number(stepDownButton.getHeight()) || 0;
      }
      
      protected function getMaxY(param1:Number) : Number
      {
         return param1 - (stepUpButton.getHeight() || 0);
      }
   }
}

