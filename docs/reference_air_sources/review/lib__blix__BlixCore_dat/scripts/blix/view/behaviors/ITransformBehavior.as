package blix.view.behaviors
{
   import blix.layout.vo.SizeConstraints;
   import blix.signals.ISignal;
   import blix.view.IView;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public interface ITransformBehavior
   {
      
      function getLayoutInvalidated() : ISignal;
      
      function getAvailableSizeBeforeTransform(param1:IView, param2:Point, param3:Matrix) : Point;
      
      function getSizeConstraintsAfterTransform(param1:IView, param2:SizeConstraints, param3:Matrix) : SizeConstraints;
      
      function getExplicitSizeBeforeTransform(param1:IView, param2:Point, param3:Matrix) : Point;
      
      function updateTransformation(param1:IView, param2:Rectangle, param3:Matrix) : Boolean;
      
      function getUnscaledSizeAfterTransform(param1:IView, param2:Point, param3:Matrix) : Point;
      
      function getUnscaledBoundsAfterTransform(param1:IView, param2:Rectangle, param3:Matrix) : Rectangle;
      
      function getExplicitPositionBeforeTransform(param1:IView, param2:Point, param3:Matrix) : Point;
      
      function updateTranslation(param1:IView, param2:Point, param3:Matrix) : Boolean;
      
      function getActualPositionAfterTransform(param1:IView, param2:Point, param3:Matrix) : Point;
   }
}

