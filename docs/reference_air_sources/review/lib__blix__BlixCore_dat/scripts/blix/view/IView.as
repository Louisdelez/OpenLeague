package blix.view
{
   import blix.layout.vo.SizeConstraints;
   import blix.signals.ISignal;
   import flash.geom.Matrix;
   import flash.geom.Matrix3D;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public interface IView extends ILayoutElement
   {
      
      function getScaledSizeConstraints() : SizeConstraints;
      
      function getUnscaledSizeConstraints() : SizeConstraints;
      
      function getScaledBoundsChanged() : ISignal;
      
      function getScaledBounds() : Rectangle;
      
      function getUnscaledBoundsChanged() : ISignal;
      
      function getUnscaledBounds() : Rectangle;
      
      function getActualPositionChanged() : ISignal;
      
      function getActualPosition() : Point;
      
      function getTransformMatrix() : Matrix;
      
      function setTransformMatrix(param1:Matrix) : void;
      
      function getTransformMatrix3d() : Matrix3D;
      
      function setTransformMatrix3d(param1:Matrix3D) : void;
   }
}

