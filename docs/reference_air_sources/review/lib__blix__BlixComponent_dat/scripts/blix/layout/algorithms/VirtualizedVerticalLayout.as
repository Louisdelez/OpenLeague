package blix.layout.algorithms
{
   import blix.layout.LayoutEntry;
   import blix.layout.data.ISizeLayoutData;
   import blix.layout.util.ElementSizeUtil;
   import blix.layout.vo.ElementSize;
   import blix.layout.vo.HorizontalAlign;
   import blix.layout.vo.Padding;
   import blix.view.ILayoutElement;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class VirtualizedVerticalLayout extends VirtualizedLayoutBase implements IVirtualizedLayoutAlgorithm
   {
      
      protected var _gap:Number = 0;
      
      protected var _padding:Padding = new Padding(0);
      
      protected var _horizontalAlign:int = 1;
      
      public function VirtualizedVerticalLayout()
      {
         super();
      }
      
      public function getGap() : Number
      {
         return this._gap;
      }
      
      public function setGap(param1:Number) : void
      {
         if(this._gap == param1)
         {
            return;
         }
         this._gap = param1;
         invalidateLayout();
      }
      
      public function getPadding() : Padding
      {
         return this._padding;
      }
      
      public function setPadding(param1:Padding) : void
      {
         if(Boolean(this._padding) && this._padding.equalTo(param1))
         {
            return;
         }
         this._padding = param1;
         invalidateLayout();
      }
      
      public function getHorizontalAlign() : int
      {
         return this._horizontalAlign;
      }
      
      public function setHorizontalAlign(param1:int) : void
      {
         if(param1 == this._horizontalAlign)
         {
            return;
         }
         this._horizontalAlign = param1;
         invalidateLayout();
      }
      
      override public function updateLayoutEntry(param1:Number, param2:Number, param3:LayoutEntry, param4:uint, param5:Number, param6:uint, param7:Rectangle, param8:Boolean) : Rectangle
      {
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:ElementSize = null;
         var _loc12_:Point = null;
         var _loc13_:Point = null;
         var _loc14_:Number = NaN;
         var _loc15_:ILayoutElement = null;
         var _loc17_:Number = NaN;
         var _loc18_:ISizeLayoutData = null;
         _loc9_ = param1 - this._padding.left - this._padding.right;
         _loc10_ = param2 - this._padding.top - this._padding.bottom;
         _loc15_ = param3.element;
         _loc11_ = ElementSizeUtil.getElementSize(param3,_loc9_,_loc10_);
         _loc12_ = _loc15_.setExplicitSize(_loc11_.width.getIdeal(),_loc11_.height.getIdeal());
         _loc11_.width.setActual(_loc12_.x);
         _loc11_.height.setActual(_loc12_.y);
         if(param7 == null)
         {
            _loc17_ = (param4 - param5) * (_loc12_.y + this._gap);
            if(param8)
            {
               _loc14_ = (param2 || 0) - this._padding.bottom + _loc17_ - _loc12_.y;
            }
            else
            {
               _loc14_ = this._padding.top + _loc17_;
            }
         }
         else if(param8)
         {
            _loc14_ = param7.top - this._gap - _loc12_.y;
         }
         else
         {
            _loc14_ = param7.bottom + this._gap;
         }
         var _loc16_:uint = uint(this._horizontalAlign);
         if(isNaN(_loc9_))
         {
            _loc16_ = uint(HorizontalAlign.LEFT);
         }
         else
         {
            _loc18_ = param3.data as ISizeLayoutData;
            if(Boolean(_loc18_) && Boolean(_loc18_.getHorizontalAlign()))
            {
               _loc16_ = _loc18_.getHorizontalAlign();
            }
         }
         switch(_loc16_)
         {
            case HorizontalAlign.DEFAULT:
            case HorizontalAlign.LEFT:
               _loc13_ = _loc15_.setExplicitPosition(this._padding.left,_loc14_);
               break;
            case HorizontalAlign.CENTER:
               _loc13_ = _loc15_.setExplicitPosition(this._padding.left + (_loc9_ - _loc12_.x) / 2,_loc14_);
               break;
            case HorizontalAlign.RIGHT:
               _loc13_ = _loc15_.setExplicitPosition(this._padding.left + (_loc9_ - _loc12_.x),_loc14_);
         }
         return new Rectangle(_loc13_.x,_loc13_.y,_loc12_.x,_loc12_.y);
      }
      
      override public function getOffset(param1:Rectangle, param2:Rectangle, param3:uint, param4:uint, param5:Boolean) : Number
      {
         if(param5)
         {
            return (param1.bottom - this._padding.bottom - param2.bottom) / (param2.height + this._gap);
         }
         return (param2.top - this._padding.top - param1.top) / (param2.height + this._gap);
      }
      
      override public function calculateMeasuredBounds(param1:Vector.<Rectangle>, param2:Boolean, param3:uint) : Rectangle
      {
         var _loc4_:Rectangle = super.calculateMeasuredBounds(param1,param2,param3);
         _loc4_.width += this._padding.left + this._padding.right;
         _loc4_.height += this._padding.top + this._padding.bottom;
         return _loc4_;
      }
      
      override public function getShouldShowRenderer(param1:Rectangle, param2:Number, param3:Number, param4:Boolean) : Boolean
      {
         var _loc5_:Number = param3 * _buffer;
         if(param4 && param1.bottom < -_loc5_ || !param4 && param1.top > param3 + _loc5_)
         {
            return false;
         }
         return true;
      }
   }
}

