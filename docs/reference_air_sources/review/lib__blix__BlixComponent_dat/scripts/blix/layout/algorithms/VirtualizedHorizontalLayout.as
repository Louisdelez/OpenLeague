package blix.layout.algorithms
{
   import blix.layout.LayoutEntry;
   import blix.layout.data.ISizeLayoutData;
   import blix.layout.util.ElementSizeUtil;
   import blix.layout.vo.ElementSize;
   import blix.layout.vo.Padding;
   import blix.layout.vo.VerticalAlign;
   import blix.view.ILayoutElement;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class VirtualizedHorizontalLayout extends VirtualizedLayoutBase implements IVirtualizedLayoutAlgorithm
   {
      
      protected var _gap:Number = 0;
      
      protected var _padding:Padding = new Padding(0);
      
      protected var _verticalAlign:int = 1;
      
      public function VirtualizedHorizontalLayout()
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
         _layoutInvalidated.dispatch(this);
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
         _layoutInvalidated.dispatch(this);
      }
      
      public function getVerticalAlign() : int
      {
         return this._verticalAlign;
      }
      
      public function setVerticalAlign(param1:int) : void
      {
         if(param1 == this._verticalAlign)
         {
            return;
         }
         this._verticalAlign = param1;
         _layoutInvalidated.dispatch(this);
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
         _loc10_ = param1 - this._padding.left - this._padding.right;
         _loc9_ = param2 - this._padding.top - this._padding.bottom;
         _loc15_ = param3.element;
         _loc11_ = ElementSizeUtil.getElementSize(param3,_loc10_,_loc9_);
         _loc12_ = _loc15_.setExplicitSize(_loc11_.width.getIdeal(),_loc11_.height.getIdeal());
         _loc11_.width.setActual(_loc12_.x);
         _loc11_.height.setActual(_loc12_.y);
         if(param7 == null)
         {
            _loc17_ = (param4 - param5) * (_loc12_.x + this._gap);
            if(param8)
            {
               _loc14_ = (param1 || 0) - this._padding.right + _loc17_ - _loc12_.x;
            }
            else
            {
               _loc14_ = this._padding.left + _loc17_;
            }
         }
         else if(param8)
         {
            _loc14_ = param7.left - this._gap - _loc12_.x;
         }
         else
         {
            _loc14_ = param7.right + this._gap;
         }
         var _loc16_:uint = uint(this._verticalAlign);
         if(isNaN(_loc9_))
         {
            _loc16_ = uint(VerticalAlign.TOP);
         }
         else
         {
            _loc18_ = param3.data as ISizeLayoutData;
            if(Boolean(_loc18_) && Boolean(_loc18_.getVerticalAlign()))
            {
               _loc16_ = _loc18_.getVerticalAlign();
            }
         }
         switch(_loc16_)
         {
            case VerticalAlign.DEFAULT:
            case VerticalAlign.TOP:
               _loc13_ = _loc15_.setExplicitPosition(_loc14_,this._padding.top);
               break;
            case VerticalAlign.MIDDLE:
               _loc13_ = _loc15_.setExplicitPosition(_loc14_,this._padding.top + (_loc9_ - _loc12_.y) / 2);
               break;
            case VerticalAlign.BOTTOM:
               _loc13_ = _loc15_.setExplicitPosition(_loc14_,this._padding.top + (_loc9_ - _loc12_.y));
         }
         return new Rectangle(_loc13_.x,_loc13_.y,_loc12_.x,_loc12_.y);
      }
      
      override public function getOffset(param1:Rectangle, param2:Rectangle, param3:uint, param4:uint, param5:Boolean) : Number
      {
         if(param5)
         {
            return (param1.bottom - this._padding.right - param2.right) / (param2.width + this._gap);
         }
         return (param2.left - this._padding.left - param1.left) / (param2.width + this._gap);
      }
      
      override public function getShouldShowRenderer(param1:Rectangle, param2:Number, param3:Number, param4:Boolean) : Boolean
      {
         var _loc5_:Number = param2 * _buffer;
         if(param4 && param1.right < -_loc5_ || !param4 && param1.left > param2 + _loc5_)
         {
            return false;
         }
         return true;
      }
   }
}

