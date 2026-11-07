package blix.layout.algorithms
{
   import blix.layout.LayoutEntry;
   import blix.layout.util.ElementSizeUtil;
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
   
   public class FlowLayout implements ILayoutAlgorithm
   {
      
      protected var _layoutInvalidated:Signal = new Signal();
      
      protected var _horizontalGap:Number = 5;
      
      protected var _verticalGap:Number = 5;
      
      protected var _padding:Padding = new Padding(0);
      
      protected var _horizontalAlign:int = 1;
      
      protected var _verticalAlign:int = 1;
      
      public function FlowLayout()
      {
         super();
      }
      
      public function getLayoutInvalidated() : ISignal
      {
         return this._layoutInvalidated;
      }
      
      public function getHorizontalGap() : Number
      {
         return this._horizontalGap;
      }
      
      public function setHorizontalGap(param1:Number) : void
      {
         if(this._horizontalGap == param1)
         {
            return;
         }
         this._horizontalGap = param1;
         this._layoutInvalidated.dispatch(this);
      }
      
      public function getVerticalGap() : Number
      {
         return this._verticalGap;
      }
      
      public function setVerticalGap(param1:Number) : void
      {
         if(this._verticalGap == param1)
         {
            return;
         }
         this._verticalGap = param1;
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
         var _loc9_:LayoutEntry = null;
         var _loc10_:ElementSize = null;
         var _loc4_:uint = param3.length;
         var _loc5_:Number = 0;
         var _loc6_:Number = 0;
         var _loc7_:Number = param1 - this._padding.left - this._padding.right;
         var _loc8_:Number = param2 - this._padding.top - this._padding.bottom;
         if(Boolean(_loc4_))
         {
            for each(_loc9_ in param3)
            {
               _loc10_ = ElementSizeUtil.getElementSize(_loc9_,_loc7_,_loc8_);
               _loc5_ = Math.max(_loc5_,_loc10_.width.getMin());
               _loc6_ = Math.max(_loc6_,_loc10_.height.getMin());
            }
            _loc5_ += this._padding.left + this._padding.right;
            _loc6_ += this._padding.top + this._padding.bottom;
         }
         return new SizeConstraints(new MinMax(_loc5_,10000),new MinMax(_loc6_,10000));
      }
      
      public function updateLayout(param1:Number, param2:Number, param3:Vector.<LayoutEntry>) : Rectangle
      {
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Size = null;
         var _loc9_:Size = null;
         var _loc10_:uint = 0;
         var _loc11_:ILayoutElement = null;
         var _loc12_:LayoutEntry = null;
         var _loc13_:Point = null;
         var _loc16_:Boolean = false;
         var _loc32_:ElementSize = null;
         var _loc33_:uint = 0;
         var _loc34_:Number = NaN;
         var _loc35_:Number = NaN;
         var _loc4_:Boolean = !isNaN(param1);
         var _loc5_:Boolean = !isNaN(param2);
         var _loc14_:uint = param3.length;
         var _loc15_:Rectangle = new Rectangle();
         if(_loc4_)
         {
            _loc15_.width = param1;
         }
         if(_loc5_)
         {
            _loc15_.height = param2;
         }
         if(!_loc14_)
         {
            return _loc15_;
         }
         if(_loc4_)
         {
            _loc6_ = param1 - this._padding.left - this._padding.right;
         }
         if(_loc5_)
         {
            _loc7_ = param2 - this._padding.top - this._padding.bottom;
         }
         var _loc17_:Vector.<Point> = new Vector.<Point>(_loc14_,true);
         var _loc18_:Vector.<int> = new Vector.<int>();
         var _loc19_:Vector.<Number> = new Vector.<Number>();
         var _loc20_:Vector.<Number> = new Vector.<Number>();
         var _loc21_:Number = 0;
         var _loc22_:Number = 0;
         var _loc23_:Number = 0;
         var _loc24_:Number = 0;
         var _loc25_:uint = 0;
         _loc10_ = 0;
         while(_loc10_ < _loc14_)
         {
            _loc16_ = _loc10_ == _loc14_ - 1;
            _loc12_ = param3[_loc10_];
            _loc11_ = _loc12_.element;
            _loc32_ = ElementSizeUtil.getElementSize(_loc12_,_loc6_,_loc7_);
            _loc8_ = _loc32_.width;
            _loc9_ = _loc32_.height;
            _loc13_ = _loc11_.setExplicitSize(_loc8_.getIdeal(),_loc9_.getIdeal());
            _loc8_.setActual(_loc13_.x);
            _loc9_.setActual(_loc13_.y);
            _loc17_[_loc10_] = _loc13_;
            if(_loc4_ && _loc10_ != 0 && _loc21_ + _loc13_.x > _loc6_)
            {
               _loc23_ = Math.max(_loc23_,_loc21_);
               _loc18_[_loc25_] = _loc10_;
               _loc19_[_loc25_] = _loc21_;
               _loc20_[_loc25_] = _loc22_;
               _loc24_ += _loc22_;
               if(!_loc16_)
               {
                  _loc24_ += this._verticalGap;
               }
               _loc21_ = 0;
               _loc22_ = 0;
               _loc25_++;
            }
            _loc21_ += _loc13_.x;
            if(!_loc16_)
            {
               _loc21_ += this._horizontalGap;
            }
            _loc22_ = Math.max(_loc22_,_loc13_.y);
            _loc10_++;
         }
         _loc23_ = Math.max(_loc23_,_loc21_);
         _loc18_[_loc25_] = _loc10_;
         _loc19_[_loc25_] = _loc21_;
         _loc20_[_loc25_] = _loc22_;
         _loc24_ += _loc22_;
         _loc25_++;
         var _loc26_:Number = _loc4_ ? Math.max(_loc23_,param1) : _loc23_;
         var _loc27_:Number = _loc5_ ? Math.max(_loc24_,param2) : _loc24_;
         var _loc28_:uint = 0;
         var _loc29_:Number = 0;
         if(_loc5_)
         {
            switch(this._verticalAlign)
            {
               case VerticalAlign.MIDDLE:
                  _loc29_ = (_loc27_ - _loc24_) / 2;
                  break;
               case VerticalAlign.BOTTOM:
                  _loc29_ = _loc27_ - _loc24_;
            }
         }
         var _loc30_:Number = this._padding.top + _loc29_;
         var _loc31_:int = 0;
         while(_loc31_ < _loc25_)
         {
            _loc33_ = uint(_loc18_[_loc31_]);
            _loc21_ = _loc19_[_loc31_];
            _loc22_ = _loc20_[_loc31_];
            _loc34_ = 0;
            switch(this._horizontalAlign)
            {
               case HorizontalAlign.CENTER:
                  _loc34_ = (_loc26_ - _loc21_) / 2;
                  break;
               case HorizontalAlign.RIGHT:
                  _loc34_ = _loc26_ - _loc21_;
            }
            _loc35_ = this._padding.left + _loc34_;
            _loc10_ = _loc28_;
            while(_loc10_ < _loc33_)
            {
               _loc12_ = param3[_loc10_];
               _loc13_ = _loc17_[_loc10_];
               _loc12_.element.setExplicitPosition(_loc35_,_loc30_);
               _loc35_ += _loc13_.x + this._horizontalGap;
               _loc10_++;
            }
            _loc30_ += _loc22_ + this._verticalGap;
            _loc28_ = _loc33_;
            _loc31_++;
         }
         if(_loc4_)
         {
            _loc15_.width = Math.max(_loc15_.width,this._padding.left + _loc26_ + this._padding.right);
         }
         else
         {
            _loc15_.width = this._padding.left + _loc26_ + this._padding.right;
         }
         if(_loc5_)
         {
            _loc15_.height = Math.max(_loc15_.height,this._padding.top + _loc27_ + this._padding.bottom);
         }
         else
         {
            _loc15_.height = this._padding.top + _loc27_ + this._padding.bottom;
         }
         return _loc15_;
      }
   }
}

