package blix.layout.data
{
   import blix.layout.vo.Size;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   
   public class CanvasLayoutData implements ISizeLayoutData, IPositionLayoutData, IConstraintLayoutData
   {
      
      protected var _changed:Signal = new Signal();
      
      protected var _x:Number;
      
      protected var _xPercent:Number;
      
      protected var _xMin:Number = -10000;
      
      protected var _xMax:Number = 10000;
      
      protected var _y:Number;
      
      protected var _yPercent:Number;
      
      protected var _yMin:Number = -10000;
      
      protected var _yMax:Number = 10000;
      
      protected var _top:Number;
      
      protected var _right:Number;
      
      protected var _bottom:Number;
      
      protected var _left:Number;
      
      protected var _horizontalCenter:Number;
      
      protected var _verticalCenter:Number;
      
      protected var _width:Number;
      
      protected var _widthPercent:Number;
      
      protected var _widthMin:Number = 0;
      
      protected var _widthMax:Number = 10000;
      
      protected var _widthMaxPercent:Number;
      
      protected var _widthMinPercent:Number;
      
      protected var _height:Number;
      
      protected var _heightPercent:Number;
      
      protected var _heightMin:Number = 0;
      
      protected var _heightMinPercent:Number;
      
      protected var _heightMax:Number = 10000;
      
      protected var _heightMaxPercent:Number;
      
      protected var xInfo:Size = new Size();
      
      protected var yInfo:Size = new Size();
      
      protected var widthInfo:Size = new Size();
      
      protected var heightInfo:Size = new Size();
      
      protected var _horizontalAlign:uint;
      
      protected var _verticalAlign:uint;
      
      public function CanvasLayoutData()
      {
         super();
      }
      
      public function getLayoutDataChanged() : ISignal
      {
         return this._changed;
      }
      
      public function getTop() : Number
      {
         return this._top;
      }
      
      public function setTop(param1:Number) : void
      {
         if(this._top == param1)
         {
            return;
         }
         this._top = param1;
         this._y = NaN;
         this._changed.dispatch(this);
      }
      
      public function getRight() : Number
      {
         return this._right;
      }
      
      public function setRight(param1:Number) : void
      {
         if(this._right == param1)
         {
            return;
         }
         this._right = param1;
         this._changed.dispatch(this);
      }
      
      public function getBottom() : Number
      {
         return this._bottom;
      }
      
      public function setBottom(param1:Number) : void
      {
         if(this._bottom == param1)
         {
            return;
         }
         this._bottom = param1;
         this._changed.dispatch(this);
      }
      
      public function getLeft() : Number
      {
         return this._left;
      }
      
      public function setLeft(param1:Number) : void
      {
         if(this._left == param1)
         {
            return;
         }
         this._left = param1;
         this._x = NaN;
         this._changed.dispatch(this);
      }
      
      public function getHorizontalCenter() : Number
      {
         return this._horizontalCenter;
      }
      
      public function setHorizontalCenter(param1:Number) : void
      {
         if(this._horizontalCenter == param1)
         {
            return;
         }
         this._horizontalCenter = param1;
         this._changed.dispatch(this);
      }
      
      public function getVerticalCenter() : Number
      {
         return this._verticalCenter;
      }
      
      public function setVerticalCenter(param1:Number) : void
      {
         if(this._verticalCenter == param1)
         {
            return;
         }
         this._verticalCenter = param1;
         this._changed.dispatch(this);
      }
      
      public function getX() : Number
      {
         return this._x;
      }
      
      public function setX(param1:Number) : void
      {
         if(this._x == param1)
         {
            return;
         }
         this._x = param1;
         this._xPercent = NaN;
         this._changed.dispatch(this);
      }
      
      public function getXPercent() : Number
      {
         return this._xPercent;
      }
      
      public function setXPercent(param1:Number) : void
      {
         if(this._xPercent == param1)
         {
            return;
         }
         this._xPercent = param1;
         this._x = NaN;
         this._changed.dispatch(this);
      }
      
      public function getXMin() : Number
      {
         return this._xMin;
      }
      
      public function setXMin(param1:Number) : void
      {
         if(this._xMin == param1)
         {
            return;
         }
         this._xMin = param1;
         this._changed.dispatch(this);
      }
      
      public function getXMax() : Number
      {
         return this._xMax;
      }
      
      public function setXMax(param1:Number) : void
      {
         if(this._xMax == param1)
         {
            return;
         }
         this._xMax = param1;
         this._changed.dispatch(this);
      }
      
      public function getY() : Number
      {
         return this._y;
      }
      
      public function setY(param1:Number) : void
      {
         if(this._y == param1)
         {
            return;
         }
         this._y = param1;
         this._yPercent = NaN;
         this._changed.dispatch(this);
      }
      
      public function getYPercent() : Number
      {
         return this._yPercent;
      }
      
      public function setYPercent(param1:Number) : void
      {
         if(this._yPercent == param1)
         {
            return;
         }
         this._yPercent = param1;
         this._y = NaN;
         this._changed.dispatch(this);
      }
      
      public function getYMin() : Number
      {
         return this._yMin;
      }
      
      public function setYMin(param1:Number) : void
      {
         if(this._yMin == param1)
         {
            return;
         }
         this._yMin = param1;
         this._changed.dispatch(this);
      }
      
      public function getYMax() : Number
      {
         return this._yMax;
      }
      
      public function setYMax(param1:Number) : void
      {
         if(this._yMax == param1)
         {
            return;
         }
         this._yMax = param1;
         this._changed.dispatch(this);
      }
      
      public function getWidth() : Number
      {
         return this._width;
      }
      
      public function setWidth(param1:Number) : void
      {
         if(this._width == param1)
         {
            return;
         }
         this._width = param1;
         this._widthPercent = NaN;
         if(!isNaN(param1))
         {
            this.widthInfo.setIsFlexible(false);
         }
         this._changed.dispatch(this);
      }
      
      public function getWidthPercent() : Number
      {
         return this._widthPercent;
      }
      
      public function setWidthPercent(param1:Number) : void
      {
         if(param1 == this._widthPercent)
         {
            return;
         }
         this._widthPercent = param1;
         this._width = NaN;
         if(!isNaN(param1))
         {
            this.widthInfo.setIsFlexible(true);
         }
         this._changed.dispatch(this);
      }
      
      public function setWidthMin(param1:Number) : void
      {
         if(param1 == this._widthMin)
         {
            return;
         }
         this._widthMin = param1;
         this._widthMinPercent = NaN;
         this._changed.dispatch(this);
      }
      
      public function getWidthMin() : Number
      {
         return this._widthMin;
      }
      
      public function getWidthMinPercent() : Number
      {
         return this._widthMinPercent;
      }
      
      public function setWidthMinPercent(param1:Number) : void
      {
         if(param1 == this._widthMinPercent)
         {
            return;
         }
         this._widthMinPercent = param1;
         this._widthMin = NaN;
         this._changed.dispatch(this);
      }
      
      public function getWidthMax() : Number
      {
         return this._widthMax;
      }
      
      public function setWidthMax(param1:Number) : void
      {
         if(this._widthMax == param1)
         {
            return;
         }
         this._widthMax = param1;
         this._widthMaxPercent = NaN;
         this._changed.dispatch(this);
      }
      
      public function getWidthMaxPercent() : Number
      {
         return this._widthMaxPercent;
      }
      
      public function setWidthMaxPercent(param1:Number) : void
      {
         if(this._widthMaxPercent == param1)
         {
            return;
         }
         this._widthMaxPercent = param1;
         this._widthMax = NaN;
         this._changed.dispatch(this);
      }
      
      public function getHeight() : Number
      {
         return this._height;
      }
      
      public function setHeight(param1:Number) : void
      {
         if(this._height == param1)
         {
            return;
         }
         this._height = param1;
         this._heightPercent = NaN;
         this.heightInfo.setIsFlexible(false);
         this._changed.dispatch(this);
      }
      
      public function getHeightPercent() : Number
      {
         return this._heightPercent;
      }
      
      public function setHeightPercent(param1:Number) : void
      {
         if(this._heightPercent == param1)
         {
            return;
         }
         this._heightPercent = param1;
         this._height = NaN;
         this.heightInfo.setIsFlexible(true);
         this._changed.dispatch(this);
      }
      
      public function getHeightMin() : Number
      {
         return this._heightMin;
      }
      
      public function setHeightMin(param1:Number) : void
      {
         if(param1 == this._heightMin)
         {
            return;
         }
         this._heightMin = param1;
         this._heightMinPercent = NaN;
         this._changed.dispatch(this);
      }
      
      public function getHeightMinPercent() : Number
      {
         return this._heightMinPercent;
      }
      
      public function setHeightMinPercent(param1:Number) : void
      {
         if(this._heightMinPercent == param1)
         {
            return;
         }
         this._heightMinPercent = param1;
         this._heightMin = NaN;
         this._changed.dispatch(this);
      }
      
      public function getHeightMax() : Number
      {
         return this._heightMax;
      }
      
      public function setHeightMax(param1:Number) : void
      {
         this._heightMax = param1;
         this._widthMaxPercent = NaN;
         this._changed.dispatch(this);
      }
      
      public function getHeightMaxPercent() : Number
      {
         return this._heightMaxPercent;
      }
      
      public function setHeightMaxPercent(param1:Number) : void
      {
         this._heightMaxPercent = param1;
         this._heightMax = NaN;
         this._changed.dispatch(this);
      }
      
      public function getHorizontalAlign() : uint
      {
         return this._horizontalAlign;
      }
      
      public function setHorizontalAlign(param1:uint) : void
      {
         if(this._horizontalAlign == param1)
         {
            return;
         }
         this._horizontalAlign = param1;
         this._changed.dispatch(this);
      }
      
      public function getVerticalAlign() : uint
      {
         return this._verticalAlign;
      }
      
      public function setVerticalAlign(param1:uint) : void
      {
         if(this._verticalAlign == param1)
         {
            return;
         }
         this._verticalAlign = param1;
         this._changed.dispatch(this);
      }
      
      public function getWidthInfo(param1:Number) : Size
      {
         if(!isNaN(this._left) && !isNaN(this._right))
         {
            this.widthInfo.setValue(param1 - this._left - this._right);
         }
         else if(!isNaN(this._widthPercent))
         {
            this.widthInfo.setValue(param1 * this._widthPercent);
         }
         else
         {
            this.widthInfo.setValue(this._width);
         }
         if(isNaN(this._widthMinPercent))
         {
            this.widthInfo.setMin(this._widthMin);
         }
         else
         {
            this.widthInfo.setMin(param1 * this._widthMinPercent);
         }
         if(isNaN(this._widthMaxPercent))
         {
            this.widthInfo.setMax(this._widthMax);
         }
         else
         {
            this.widthInfo.setMax(param1 * this._widthMaxPercent);
         }
         return this.widthInfo;
      }
      
      public function getHeightInfo(param1:Number) : Size
      {
         if(!isNaN(this._top) && !isNaN(this._bottom))
         {
            this.heightInfo.setValue(param1 - this._top - this._bottom);
         }
         else if(!isNaN(this._heightPercent))
         {
            this.heightInfo.setValue(param1 * this._heightPercent);
         }
         else
         {
            this.heightInfo.setValue(this._height);
         }
         if(isNaN(this._heightMinPercent))
         {
            this.heightInfo.setMin(this._heightMin);
         }
         else
         {
            this.heightInfo.setMin(param1 * this._heightMinPercent);
         }
         if(isNaN(this._heightMaxPercent))
         {
            this.heightInfo.setMax(this._heightMax);
         }
         else
         {
            this.heightInfo.setMax(param1 * this._heightMaxPercent);
         }
         return this.heightInfo;
      }
      
      public function getXInfo(param1:Number) : Size
      {
         var _loc2_:Number = NaN;
         var _loc3_:Size = null;
         var _loc4_:Number = NaN;
         if(!isNaN(this._xPercent))
         {
            this.xInfo.setValue(param1 * this._xPercent);
            this.xInfo.setMin(this._xMin);
            this.xInfo.setMax(this._xMax);
         }
         else if(!isNaN(this._left))
         {
            this.xInfo.setValue(this._left);
            this.xInfo.setMin(this._left);
            this.xInfo.setMax(this._left);
         }
         else if(!isNaN(this._horizontalCenter))
         {
            _loc2_ = isNaN(param1) ? 0 : param1;
            _loc3_ = this.getWidthInfo(param1);
            this.xInfo.setValue((_loc2_ - _loc3_.getActual() >> 1) + this._horizontalCenter);
            this.xInfo.setMax(10000);
            this.xInfo.setMin(-10000);
         }
         else if(!isNaN(this._right))
         {
            _loc2_ = isNaN(param1) ? 0 : param1;
            _loc3_ = this.getWidthInfo(param1);
            _loc4_ = _loc2_ - this._right;
            this.xInfo.setValue(_loc4_ - _loc3_.getActual());
            this.xInfo.setMax(_loc4_ - _loc3_.getMin());
            this.xInfo.setMin(_loc4_ - _loc3_.getMax());
         }
         else
         {
            this.xInfo.setValue(this._x || 0);
            this.xInfo.setMin(this._xMin);
            this.xInfo.setMax(this._xMax);
         }
         return this.xInfo;
      }
      
      public function getYInfo(param1:Number) : Size
      {
         var _loc2_:Number = NaN;
         var _loc3_:Size = null;
         var _loc4_:Number = NaN;
         if(!isNaN(this._yPercent))
         {
            this.yInfo.setValue(param1 * this._yPercent);
            this.yInfo.setMin(this._yMin);
            this.yInfo.setMax(this._yMax);
         }
         else if(!isNaN(this._top))
         {
            this.yInfo.setValue(this._top);
            this.yInfo.setMin(this._top);
            this.yInfo.setMax(this._top);
         }
         else if(!isNaN(this._verticalCenter))
         {
            _loc2_ = isNaN(param1) ? 0 : param1;
            _loc3_ = this.getHeightInfo(param1);
            this.yInfo.setValue((_loc2_ - _loc3_.getActual() >> 1) + this._verticalCenter);
            this.yInfo.setMax(10000);
            this.yInfo.setMin(-10000);
         }
         else if(!isNaN(this._bottom))
         {
            _loc2_ = isNaN(param1) ? 0 : param1;
            _loc3_ = this.getHeightInfo(param1);
            _loc4_ = _loc2_ - this._bottom;
            this.yInfo.setValue(_loc4_ - _loc3_.getActual());
            this.yInfo.setMax(_loc4_ - _loc3_.getMin());
            this.yInfo.setMin(_loc4_ - _loc3_.getMax());
         }
         else
         {
            this.yInfo.setValue(this._y || 0);
            this.yInfo.setMin(this._yMin);
            this.yInfo.setMax(this._yMax);
         }
         return this.yInfo;
      }
   }
}

