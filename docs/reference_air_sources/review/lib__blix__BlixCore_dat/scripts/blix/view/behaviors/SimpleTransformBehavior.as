package blix.view.behaviors
{
   import blix.layout.vo.SizeConstraints;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import blix.util.layout.MatrixUtils;
   import blix.view.IView;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class SimpleTransformBehavior implements ITransformBehavior
   {
      
      private var _layoutInvalidated:Signal = new Signal();
      
      public function SimpleTransformBehavior()
      {
         super();
      }
      
      public function getLayoutInvalidated() : ISignal
      {
         return this._layoutInvalidated;
      }
      
      public function invalidateLayout() : void
      {
         this._layoutInvalidated.dispatch(this);
      }
      
      public function getAvailableSizeBeforeTransform(param1:IView, param2:Point, param3:Matrix) : Point
      {
         return param2;
      }
      
      public function getSizeConstraintsAfterTransform(param1:IView, param2:SizeConstraints, param3:Matrix) : SizeConstraints
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
         return false;
      }
      
      public function getUnscaledSizeAfterTransform(param1:IView, param2:Point, param3:Matrix) : Point
      {
         return MatrixUtils.getSizeAfterTransformation(param2.x,param2.y,param3);
      }
      
      public function getUnscaledBoundsAfterTransform(param1:IView, param2:Rectangle, param3:Matrix) : Rectangle
      {
         return MatrixUtils.getBoundsAfterTransformation(param2,param3);
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
         var _loc4_:Boolean = false;
         if(!isNaN(param2.x))
         {
            param3.tx = param2.x;
            _loc4_ = true;
         }
         if(!isNaN(param2.y))
         {
            param3.ty = param2.y;
            _loc4_ = true;
         }
         return _loc4_;
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

