package blix.layout.algorithms
{
   import blix.layout.LayoutEntry;
   import blix.layout.data.ISizeLayoutData;
   import blix.layout.util.ElementSizeUtil;
   import blix.layout.util.FitSizesUtil;
   import blix.layout.vo.ElementSize;
   import blix.layout.vo.HorizontalAlign;
   import blix.layout.vo.MinMax;
   import blix.layout.vo.Padding;
   import blix.layout.vo.Size;
   import blix.layout.vo.SizeConstraints;
   import blix.layout.vo.VerticalAlign;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import blix.view.ILayoutElement;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class HorizontalLayout implements ILayoutAlgorithm
   {
      
      protected var _layoutInvalidated:Signal = new Signal();
      
      protected var _gap:Number = 5;
      
      protected var _padding:Padding = new Padding(0);
      
      protected var _verticalAlign:int = 1;
      
      protected var _horizontalAlign:int = 1;
      
      public function HorizontalLayout()
      {
         super();
      }
      
      public function getLayoutInvalidated() : ISignal
      {
         return this._layoutInvalidated;
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
         this._layoutInvalidated.dispatch(this);
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
         this._layoutInvalidated.dispatch(this);
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
         this._layoutInvalidated.dispatch(this);
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
         this._layoutInvalidated.dispatch(this);
      }
      
      public function getSizeConstraints(param1:Number, param2:Number, param3:Vector.<LayoutEntry>) : SizeConstraints
      {
         var _loc9_:ElementSize = null;
         var _loc10_:LayoutEntry = null;
         var _loc4_:uint = param3.length;
         var _loc5_:Number = 0;
         var _loc6_:Number = 0;
         var _loc7_:Number = param1 - this._padding.left - this._padding.right;
         var _loc8_:Number = param2 - this._padding.top - this._padding.bottom;
         if(Boolean(_loc4_))
         {
            for each(_loc10_ in param3)
            {
               _loc9_ = ElementSizeUtil.getElementSize(_loc10_,_loc7_,_loc8_);
               _loc5_ += _loc9_.width.getMin();
               _loc6_ = Math.max(_loc9_.height.getMin(),_loc6_);
            }
            _loc6_ += this._padding.top + this._padding.bottom;
            _loc5_ += this._gap * (_loc4_ - 1) + this._padding.left + this._padding.right;
         }
         return new SizeConstraints(new MinMax(_loc5_,10000),new MinMax(_loc6_,10000));
      }
      
      public function updateLayout(param1:Number, param2:Number, param3:Vector.<LayoutEntry>) : Rectangle
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc7_:ElementSize = null;
         var _loc8_:Size = null;
         var _loc9_:Size = null;
         var _loc10_:LayoutEntry = null;
         var _loc11_:ILayoutElement = null;
         var _loc13_:uint = 0;
         var _loc21_:Number = NaN;
         var _loc22_:uint = 0;
         var _loc23_:ISizeLayoutData = null;
         var _loc6_:Number = 0;
         var _loc12_:uint = param3.length;
         var _loc14_:Rectangle = new Rectangle();
         if(!_loc12_)
         {
            return _loc14_;
         }
         var _loc15_:Vector.<Point> = new Vector.<Point>(_loc12_,true);
         _loc4_ = param1 - this._padding.left - this._padding.right;
         _loc5_ = param2 - this._padding.top - this._padding.bottom;
         if(!isNaN(_loc5_))
         {
            _loc6_ = _loc5_;
         }
         var _loc16_:Vector.<Size> = this.getWidths(param3,_loc4_,_loc5_);
         var _loc17_:Vector.<Size> = new Vector.<Size>();
         var _loc18_:Number = 0;
         _loc13_ = 0;
         while(_loc13_ < _loc12_)
         {
            _loc10_ = param3[_loc13_];
            _loc11_ = _loc10_.element;
            _loc8_ = _loc16_[_loc13_];
            _loc21_ = _loc8_.getIdeal();
            if(isNaN(_loc21_) || !_loc8_.getIsFlexible())
            {
               _loc7_ = ElementSizeUtil.getElementSize(_loc10_,_loc4_,_loc5_);
               _loc9_ = _loc7_.height;
               _loc15_[_loc13_] = _loc11_.setExplicitSize(_loc21_,_loc9_.getIdeal());
               _loc8_.setActual(_loc15_[_loc13_].x);
               _loc9_.setActual(_loc15_[_loc13_].y);
               _loc6_ = Math.max(_loc6_,_loc15_[_loc13_].y);
               _loc18_ += _loc15_[_loc13_].x;
               if(_loc13_ < _loc12_ - 1)
               {
                  _loc18_ += this._gap;
               }
            }
            else
            {
               _loc17_[_loc17_.length] = _loc8_;
            }
            _loc13_++;
         }
         FitSizesUtil.fitSizesToValue(_loc17_,_loc4_ - _loc18_ - (_loc17_.length - 1) * this._gap);
         _loc13_ = 0;
         while(_loc13_ < _loc12_)
         {
            if(_loc15_[_loc13_] == null)
            {
               _loc10_ = param3[_loc13_];
               _loc11_ = _loc10_.element;
               _loc8_ = _loc16_[_loc13_];
               _loc7_ = ElementSizeUtil.getElementSize(_loc10_,_loc4_,_loc5_);
               _loc9_ = _loc7_.height;
               _loc15_[_loc13_] = _loc11_.setExplicitSize(_loc8_.getActual(),_loc9_.getIdeal());
               _loc8_.setActual(_loc15_[_loc13_].x);
               _loc9_.setActual(_loc15_[_loc13_].y);
               _loc6_ = Math.max(_loc6_,_loc15_[_loc13_].y);
               _loc18_ += _loc15_[_loc13_].x;
               if(_loc13_ < _loc12_ - 1)
               {
                  _loc18_ += this._gap;
               }
            }
            _loc13_++;
         }
         _loc14_.height = _loc6_ + this._padding.top + this._padding.bottom;
         _loc14_.width = this._padding.left + _loc18_ + this._padding.right;
         var _loc19_:Number = 0;
         if(!isNaN(param1))
         {
            if(_loc14_.width < param1)
            {
               switch(this._horizontalAlign)
               {
                  case HorizontalAlign.CENTER:
                     _loc19_ = (param1 - _loc18_) / 2;
                     break;
                  case HorizontalAlign.RIGHT:
                     _loc19_ = param1 - _loc18_;
               }
               _loc14_.width = param1;
            }
         }
         var _loc20_:Number = this._padding.left + _loc19_;
         _loc13_ = 0;
         while(_loc13_ < _loc12_)
         {
            _loc10_ = param3[_loc13_];
            _loc11_ = _loc10_.element;
            _loc22_ = uint(this._verticalAlign);
            _loc23_ = _loc10_.data as ISizeLayoutData;
            if(Boolean(_loc23_) && Boolean(_loc23_.getVerticalAlign()))
            {
               _loc22_ = _loc23_.getVerticalAlign();
            }
            switch(_loc22_)
            {
               case VerticalAlign.DEFAULT:
               case VerticalAlign.TOP:
                  _loc11_.setExplicitPosition(_loc20_,this._padding.top);
                  break;
               case VerticalAlign.MIDDLE:
                  _loc11_.setExplicitPosition(_loc20_,this._padding.top + (_loc6_ - _loc15_[_loc13_].y) / 2);
                  break;
               case VerticalAlign.BOTTOM:
                  _loc11_.setExplicitPosition(_loc20_,this._padding.top + (_loc6_ - _loc15_[_loc13_].y));
            }
            _loc20_ += _loc15_[_loc13_].x;
            if(_loc13_ < _loc12_ - 1)
            {
               _loc20_ += this._gap;
            }
            _loc13_++;
         }
         return _loc14_;
      }
      
      protected function getWidths(param1:Vector.<LayoutEntry>, param2:Number, param3:Number) : Vector.<Size>
      {
         var _loc5_:LayoutEntry = null;
         var _loc6_:ElementSize = null;
         var _loc4_:Vector.<Size> = new Vector.<Size>();
         for each(_loc5_ in param1)
         {
            _loc6_ = ElementSizeUtil.getElementSize(_loc5_,param2,param3);
            _loc4_[_loc4_.length] = _loc6_.width;
         }
         return _loc4_;
      }
   }
}

