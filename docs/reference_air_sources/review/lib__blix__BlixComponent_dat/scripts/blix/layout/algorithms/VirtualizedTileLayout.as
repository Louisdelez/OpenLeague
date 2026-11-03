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
   
   public class VirtualizedTileLayout extends VirtualizedLayoutBase implements IVirtualizedLayoutAlgorithm
   {
      
      protected var _hGap:Number = 5;
      
      protected var _vGap:Number = 5;
      
      protected var _cols:uint = 0;
      
      protected var _rows:uint = 0;
      
      protected var _padding:Padding = new Padding(0);
      
      protected var _horizontalAlign:int = 1;
      
      public function VirtualizedTileLayout()
      {
         super();
      }
      
      public function getHGap() : Number
      {
         return this._hGap;
      }
      
      public function setHGap(param1:Number) : void
      {
         if(this._hGap == param1)
         {
            return;
         }
         this._hGap = param1;
         _layoutInvalidated.dispatch(this);
      }
      
      public function getVGap() : Number
      {
         return this._vGap;
      }
      
      public function setVGap(param1:Number) : void
      {
         if(this._vGap == param1)
         {
            return;
         }
         this._vGap = param1;
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
         _layoutInvalidated.dispatch(this);
      }
      
      public function getCols() : uint
      {
         return this._cols;
      }
      
      public function setCols(param1:uint) : void
      {
         if(param1 == this._cols)
         {
            return;
         }
         this._cols = param1;
         _layoutInvalidated.dispatch(this);
      }
      
      public function getRows() : uint
      {
         return this._rows;
      }
      
      public function setRows(param1:uint) : void
      {
         if(param1 == this._rows)
         {
            return;
         }
         this._rows = param1;
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
         var _loc18_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         var _loc24_:uint = 0;
         var _loc25_:ISizeLayoutData = null;
         _loc9_ = param1 - this._padding.left - this._padding.right;
         _loc10_ = param2 - this._padding.top - this._padding.bottom;
         _loc15_ = param3.element;
         _loc11_ = ElementSizeUtil.getElementSize(param3,_loc9_,_loc10_);
         _loc12_ = _loc15_.setExplicitSize(_loc11_.width.getIdeal(),_loc11_.height.getIdeal());
         _loc11_.width.setActual(_loc12_.x);
         _loc11_.height.setActual(_loc12_.y);
         var _loc16_:uint = this._cols > 0 ? this._cols : uint(Math.max(1,Math.floor(_loc9_ / (_loc12_.x + this._hGap))));
         var _loc17_:Number = _loc9_ / _loc16_;
         if(this._rows > 0)
         {
            _loc18_ = _loc10_ / this._rows;
         }
         else
         {
            _loc18_ = _loc12_.y + this._vGap;
         }
         var _loc19_:uint = param4 % _loc16_;
         if(param7 == null)
         {
            if(param8)
            {
               _loc24_ = param6 % _loc16_ + 1;
               if(_loc24_ != _loc16_ && param5 > param6 - _loc24_)
               {
                  _loc23_ = (param6 - param5) * _loc18_ / _loc24_;
               }
               else
               {
                  _loc22_ = param4 + _loc16_ - param4 % _loc16_ - 1;
                  _loc23_ = (_loc22_ - param5) * _loc18_ / _loc16_;
               }
               _loc14_ = (param2 || 0) - this._padding.bottom + _loc23_ - _loc12_.y;
            }
            else
            {
               _loc22_ = param4 - param4 % _loc16_;
               _loc23_ = (_loc22_ - param5) * _loc18_ / _loc16_;
               _loc14_ = this._padding.top + _loc23_;
            }
         }
         else if(param8)
         {
            if(_loc19_ == _loc16_ - 1)
            {
               _loc14_ = param7.top - _loc18_;
            }
            else
            {
               _loc14_ = param7.top;
            }
         }
         else if(_loc19_ == 0)
         {
            _loc14_ = param7.top + _loc18_;
         }
         else
         {
            _loc14_ = param7.top;
         }
         var _loc20_:uint = uint(this._horizontalAlign);
         if(isNaN(_loc9_))
         {
            _loc20_ = uint(HorizontalAlign.LEFT);
         }
         else
         {
            _loc25_ = param3.data as ISizeLayoutData;
            if(Boolean(_loc25_) && Boolean(_loc25_.getHorizontalAlign()))
            {
               _loc20_ = _loc25_.getHorizontalAlign();
            }
         }
         var _loc21_:Number = this._padding.left + _loc17_ * _loc19_;
         switch(_loc20_)
         {
            case HorizontalAlign.DEFAULT:
            case HorizontalAlign.LEFT:
               _loc13_ = _loc15_.setExplicitPosition(_loc21_,_loc14_);
               break;
            case HorizontalAlign.CENTER:
               _loc13_ = _loc15_.setExplicitPosition(_loc21_ + (_loc17_ - _loc12_.x) / 2,_loc14_);
               break;
            case HorizontalAlign.RIGHT:
               _loc13_ = _loc15_.setExplicitPosition(_loc21_ + (_loc17_ - _loc12_.x),_loc14_);
         }
         return new Rectangle(_loc13_.x,_loc13_.y,_loc12_.x,_loc12_.y);
      }
      
      override public function getOffset(param1:Rectangle, param2:Rectangle, param3:uint, param4:uint, param5:Boolean) : Number
      {
         var _loc6_:Number = NaN;
         var _loc8_:Number = NaN;
         var _loc9_:Number = NaN;
         var _loc10_:Number = NaN;
         var _loc11_:uint = 0;
         if(this._rows > 0)
         {
            _loc6_ = (param1.bottom - this._padding.bottom - this._padding.top) / this._rows;
         }
         else
         {
            _loc6_ = param2.height + this._vGap;
         }
         var _loc7_:uint = this._cols > 0 ? this._cols : uint(Math.max(1,Math.floor((param1.width - this._padding.left - this._padding.right) / (param2.width + this._hGap))));
         if(param5)
         {
            _loc11_ = param4 % _loc7_ + 1;
            if(_loc11_ != _loc7_ && param3 > param4 - _loc11_)
            {
               _loc10_ = (param4 - param3) * _loc6_ / _loc11_;
            }
            else
            {
               _loc9_ = param3 + _loc7_ - param3 % _loc7_ - 1;
               _loc10_ = (_loc9_ - param3) * _loc6_ / _loc7_;
            }
            _loc8_ = (param1.bottom || 0) - this._padding.bottom + _loc10_ - param2.height;
         }
         else
         {
            _loc9_ = param3 - param3 % _loc7_;
            _loc10_ = (_loc9_ - param3) * _loc6_ / _loc7_;
            _loc8_ = this._padding.top + _loc10_ - param1.top;
         }
         return (param2.top - _loc8_) * _loc7_ / _loc6_;
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

