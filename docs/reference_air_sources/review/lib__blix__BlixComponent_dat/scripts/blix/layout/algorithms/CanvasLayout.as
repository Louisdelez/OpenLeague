package blix.layout.algorithms
{
   import blix.layout.LayoutEntry;
   import blix.layout.data.IConstraintLayoutData;
   import blix.layout.data.IPositionLayoutData;
   import blix.layout.util.ElementSizeUtil;
   import blix.layout.vo.ElementSize;
   import blix.layout.vo.MinMax;
   import blix.layout.vo.Size;
   import blix.layout.vo.SizeConstraints;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import blix.view.ILayoutElement;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class CanvasLayout implements ILayoutAlgorithm
   {
      
      protected var _layoutInvalidated:Signal = new Signal();
      
      public function CanvasLayout()
      {
         super();
      }
      
      public function getLayoutInvalidated() : ISignal
      {
         return this._layoutInvalidated;
      }
      
      public function getSizeConstraints(param1:Number, param2:Number, param3:Vector.<LayoutEntry>) : SizeConstraints
      {
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:LayoutEntry = null;
         var _loc9_:ElementSize = null;
         var _loc10_:IPositionLayoutData = null;
         var _loc11_:IConstraintLayoutData = null;
         var _loc12_:Size = null;
         var _loc13_:Size = null;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc4_:Number = 0;
         var _loc5_:Number = 0;
         for each(_loc8_ in param3)
         {
            _loc9_ = ElementSizeUtil.getElementSize(_loc8_,param1,param2);
            _loc6_ = _loc9_.width.getMin();
            _loc4_ = Math.max(_loc4_,_loc6_);
            _loc7_ = _loc9_.height.getMin();
            _loc5_ = Math.max(_loc5_,_loc7_);
            _loc10_ = _loc8_.data as IPositionLayoutData;
            if(Boolean(_loc10_))
            {
               _loc12_ = _loc10_.getXInfo(param1);
               _loc4_ = Math.max(_loc4_,_loc12_.getMin() + _loc6_);
               _loc13_ = _loc10_.getYInfo(param2);
               _loc5_ = Math.max(_loc5_,_loc13_.getMin() + _loc7_);
            }
            _loc11_ = _loc8_.data as IConstraintLayoutData;
            if(Boolean(_loc11_))
            {
               _loc14_ = _loc11_.getLeft();
               _loc15_ = _loc11_.getRight();
               if(!isNaN(_loc14_) || !isNaN(_loc15_))
               {
                  _loc18_ = _loc6_;
                  if(!isNaN(_loc14_))
                  {
                     _loc18_ += _loc14_;
                  }
                  if(!isNaN(_loc15_))
                  {
                     _loc18_ += _loc15_;
                  }
                  _loc4_ = Math.max(_loc4_,_loc18_);
               }
               _loc16_ = _loc11_.getTop();
               _loc17_ = _loc11_.getBottom();
               if(!isNaN(_loc16_) || !isNaN(_loc17_))
               {
                  _loc19_ = _loc7_;
                  if(!isNaN(_loc16_))
                  {
                     _loc19_ += _loc16_;
                  }
                  if(!isNaN(_loc17_))
                  {
                     _loc19_ += _loc17_;
                  }
                  _loc5_ = Math.max(_loc5_,_loc19_);
               }
            }
         }
         return new SizeConstraints(new MinMax(_loc4_,10000),new MinMax(_loc5_,10000));
      }
      
      public function updateLayout(param1:Number, param2:Number, param3:Vector.<LayoutEntry>) : Rectangle
      {
         var _loc7_:Point = null;
         var _loc8_:Point = null;
         var _loc11_:LayoutEntry = null;
         var _loc12_:ILayoutElement = null;
         var _loc13_:ElementSize = null;
         var _loc14_:IPositionLayoutData = null;
         var _loc15_:Size = null;
         var _loc16_:Size = null;
         var _loc4_:Boolean = !isNaN(param1);
         var _loc5_:Boolean = !isNaN(param2);
         var _loc6_:uint = param3.length;
         var _loc9_:Rectangle = new Rectangle();
         if(_loc4_)
         {
            _loc9_.width = param1;
         }
         if(_loc5_)
         {
            _loc9_.height = param2;
         }
         if(!_loc6_)
         {
            return _loc9_;
         }
         var _loc10_:uint = 0;
         while(_loc10_ < _loc6_)
         {
            _loc11_ = param3[_loc10_];
            _loc12_ = _loc11_.element;
            _loc13_ = ElementSizeUtil.getElementSize(_loc11_,param1,param2);
            _loc7_ = _loc12_.setExplicitSize(_loc13_.width.getIdeal(),_loc13_.height.getIdeal());
            _loc13_.width.setActual(_loc7_.x);
            _loc13_.height.setActual(_loc7_.y);
            _loc14_ = _loc11_.data as IPositionLayoutData;
            if(Boolean(_loc14_))
            {
               _loc15_ = _loc14_.getXInfo(param1);
               _loc16_ = _loc14_.getYInfo(param2);
               _loc8_ = _loc12_.setExplicitPosition(_loc15_.getIdeal(),_loc16_.getIdeal());
               _loc15_.setActual(_loc8_.x);
               _loc16_.setActual(_loc8_.y);
            }
            else
            {
               _loc8_ = _loc12_.setExplicitPosition(0,0);
            }
            _loc9_.width = Math.max(_loc8_.x + _loc7_.x,_loc9_.width);
            _loc9_.height = Math.max(_loc8_.y + _loc7_.y,_loc9_.height);
            _loc10_++;
         }
         return _loc9_;
      }
   }
}

