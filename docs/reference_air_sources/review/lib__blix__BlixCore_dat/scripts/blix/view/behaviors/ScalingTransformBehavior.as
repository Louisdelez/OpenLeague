package blix.view.behaviors
{
   import blix.layout.vo.HorizontalAlign;
   import blix.layout.vo.MinMax;
   import blix.layout.vo.SizeConstraints;
   import blix.layout.vo.VerticalAlign;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import blix.util.layout.MatrixUtils;
   import blix.view.IView;
   import fl.motion.MatrixTransformer;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class ScalingTransformBehavior implements ITransformBehavior
   {
      
      protected var _layoutInvalidated:Signal = new Signal();
      
      protected var _scaledSizeConstraints:SizeConstraints;
      
      protected var _scalePercentConstraints:SizeConstraints = new SizeConstraints(new MinMax(0.001,10000),new MinMax(0.001,10000));
      
      protected var _maintainAspectRatio:Boolean = false;
      
      protected var _horizontalAlign:uint = 1;
      
      protected var _verticalAlign:uint = 1;
      
      public function ScalingTransformBehavior()
      {
         super();
      }
      
      public function getScaledSizeConstraints() : SizeConstraints
      {
         return this._scaledSizeConstraints;
      }
      
      public function setScaledSizeConstraints(param1:SizeConstraints) : void
      {
         this._scaledSizeConstraints = param1;
         this.invalidateLayout();
      }
      
      public function getScalePercentConstraints() : SizeConstraints
      {
         return this._scalePercentConstraints;
      }
      
      public function setScalePercentConstraints(param1:SizeConstraints) : void
      {
         if(param1 == null)
         {
            param1 = new SizeConstraints(new MinMax(0.001,10000),new MinMax(0.001,10000));
         }
         this._scalePercentConstraints = param1;
         this.invalidateLayout();
      }
      
      public function getMaintainAspectRatio() : Boolean
      {
         return this._maintainAspectRatio;
      }
      
      public function setMaintainAspectRatio(param1:Boolean) : void
      {
         if(this._maintainAspectRatio == param1)
         {
            return;
         }
         this._maintainAspectRatio = param1;
         this.invalidateLayout();
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
         this.invalidateLayout();
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
         this.invalidateLayout();
      }
      
      public function getLayoutInvalidated() : ISignal
      {
         return this._layoutInvalidated;
      }
      
      public function invalidateLayout() : void
      {
         this._layoutInvalidated.dispatch(this);
      }
      
      public function getSizeConstraintsAfterTransform(param1:IView, param2:SizeConstraints, param3:Matrix) : SizeConstraints
      {
         var _loc4_:SizeConstraints = new SizeConstraints();
         _loc4_.width.min = param2.width.min * this._scalePercentConstraints.width.min;
         _loc4_.width.max = param2.width.max * this._scalePercentConstraints.width.max;
         _loc4_.height.min = param2.height.min * this._scalePercentConstraints.height.min;
         _loc4_.height.max = param2.height.max * this._scalePercentConstraints.height.max;
         return _loc4_;
      }
      
      public function getAvailableSizeBeforeTransform(param1:IView, param2:Point, param3:Matrix) : Point
      {
         return param2;
      }
      
      public function getExplicitSizeBeforeTransform(param1:IView, param2:Point, param3:Matrix) : Point
      {
         var _loc4_:SizeConstraints = param1.getUnscaledSizeConstraints();
         var _loc5_:Number = _loc4_.width.clampValue(param2.x);
         var _loc6_:Number = _loc4_.height.clampValue(param2.y);
         return new Point(_loc5_,_loc6_);
      }
      
      public function updateTransformation(param1:IView, param2:Rectangle, param3:Matrix) : Boolean
      {
         var _loc14_:Number = NaN;
         if(param2.isEmpty())
         {
            return false;
         }
         var _loc4_:Point = MatrixUtils.getSizeAfterTransformation(param2.width,param2.height,param3);
         var _loc5_:Point = param1.getExplicitSize();
         var _loc6_:Number = _loc5_.x;
         var _loc7_:Number = _loc5_.y;
         if(Boolean(this._scaledSizeConstraints))
         {
            _loc6_ = this._scaledSizeConstraints.width.clampValue(_loc6_);
            _loc7_ = this._scaledSizeConstraints.height.clampValue(_loc7_);
         }
         var _loc8_:Number = param3.tx;
         var _loc9_:Number = param3.ty;
         var _loc10_:Number = 1;
         var _loc11_:Number = 1;
         if(!isNaN(_loc6_))
         {
            _loc10_ = _loc6_ / _loc4_.x;
            if(_loc10_ == 0)
            {
               _loc10_ = 0.0001;
            }
         }
         if(!isNaN(_loc7_))
         {
            _loc11_ = _loc7_ / _loc4_.y;
            if(_loc11_ == 0)
            {
               _loc11_ = 0.0001;
            }
         }
         if(_loc10_ != 1 || _loc11_ != 1)
         {
            param3.scale(_loc10_,_loc11_);
         }
         var _loc12_:Number = MatrixTransformer.getScaleX(param3);
         var _loc13_:Number = MatrixTransformer.getScaleY(param3);
         _loc12_ = this._scalePercentConstraints.width.clampValue(_loc12_);
         _loc13_ = this._scalePercentConstraints.height.clampValue(_loc13_);
         if(this._maintainAspectRatio)
         {
            _loc14_ = Math.min(_loc12_,_loc13_);
            _loc12_ = _loc14_;
            _loc13_ = _loc14_;
         }
         MatrixTransformer.setScaleX(param3,_loc12_);
         MatrixTransformer.setScaleY(param3,_loc13_);
         param3.tx = _loc8_;
         param3.ty = _loc9_;
         if(param3.a > 0.999 && param3.a < 1.001)
         {
            param3.a = 1;
         }
         if(param3.b > 0.999 && param3.b < 1.001)
         {
            param3.b = 1;
         }
         if(param3.c > 0.999 && param3.c < 1.001)
         {
            param3.c = 1;
         }
         if(param3.d > 0.999 && param3.d < 1.001)
         {
            param3.d = 1;
         }
         return true;
      }
      
      public function getUnscaledSizeAfterTransform(param1:IView, param2:Point, param3:Matrix) : Point
      {
         var _loc4_:Point = param1.getExplicitSize();
         var _loc5_:Point = MatrixUtils.getSizeAfterTransformation(param2.x,param2.y,param3);
         _loc5_.x = Math.max(_loc5_.x,_loc4_.x || 0);
         _loc5_.y = Math.max(_loc5_.y,_loc4_.y || 0);
         return _loc5_;
      }
      
      public function getUnscaledBoundsAfterTransform(param1:IView, param2:Rectangle, param3:Matrix) : Rectangle
      {
         var _loc4_:Point = param1.getExplicitSize();
         var _loc5_:Rectangle = MatrixUtils.getBoundsAfterTransformation(param2,param3);
         _loc5_.width = Math.max(_loc5_.width,_loc4_.x || 0);
         _loc5_.height = Math.max(_loc5_.height,_loc4_.y || 0);
         return _loc5_;
      }
      
      public function getExplicitPositionBeforeTransform(param1:IView, param2:Point, param3:Matrix) : Point
      {
         var _loc4_:Rectangle = this.getUnscaledBoundsAfterTransform(param1,param1.getUnscaledBounds(),param3);
         var _loc5_:Point = _loc4_.topLeft;
         _loc5_.x -= param3.tx;
         _loc5_.y -= param3.ty;
         return new Point(param2.x - _loc5_.x,param2.y - _loc5_.y);
      }
      
      public function updateTranslation(param1:IView, param2:Point, param3:Matrix) : Boolean
      {
         var _loc4_:Point = param1.getExplicitSize();
         var _loc5_:Rectangle = param1.getUnscaledBounds();
         var _loc6_:Rectangle = MatrixUtils.getBoundsAfterTransformation(_loc5_,param3);
         var _loc7_:Number = Math.max(_loc6_.width,_loc4_.x || 0);
         var _loc8_:Number = Math.max(_loc6_.height,_loc4_.y || 0);
         var _loc9_:int = 0;
         var _loc10_:int = 0;
         var _loc11_:Boolean = false;
         if(!isNaN(param2.x))
         {
            if(this._maintainAspectRatio)
            {
               switch(this._horizontalAlign)
               {
                  case HorizontalAlign.LEFT || isNaN(_loc7_):
                     _loc9_ = 0;
                     break;
                  case HorizontalAlign.CENTER:
                     _loc9_ = _loc7_ - _loc6_.width >> 1;
                     break;
                  case HorizontalAlign.RIGHT:
                     _loc9_ = _loc7_ - _loc6_.width;
               }
            }
            param3.tx = param2.x + _loc9_;
            _loc11_ = true;
         }
         if(!isNaN(param2.y))
         {
            if(this._maintainAspectRatio)
            {
               var _loc12_:uint = this._verticalAlign;
               switch(_loc12_)
               {
                  case VerticalAlign.DEFAULT:
               }
               _loc10_ = 0;
            }
            param3.ty = param2.y + _loc10_;
            _loc11_ = true;
         }
         return _loc11_;
      }
      
      public function getActualPositionAfterTransform(param1:IView, param2:Point, param3:Matrix) : Point
      {
         var _loc4_:Rectangle = this.getUnscaledBoundsAfterTransform(param1,param1.getUnscaledBounds(),param3);
         var _loc5_:Point = _loc4_.topLeft;
         _loc5_.x -= param3.tx;
         _loc5_.y -= param3.ty;
         return new Point(param2.x + _loc5_.x,param2.y + _loc5_.y);
      }
   }
}

