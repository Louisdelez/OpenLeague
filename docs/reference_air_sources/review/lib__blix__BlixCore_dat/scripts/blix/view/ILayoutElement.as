package blix.view
{
   import blix.layout.vo.SizeConstraints;
   import blix.signals.ISignal;
   import flash.geom.Point;
   
   public interface ILayoutElement
   {
      
      function getLayoutInvalidated() : ISignal;
      
      function invalidateLayout() : void;
      
      function getIncludeInLayout() : Boolean;
      
      function setIncludeInLayout(param1:Boolean) : void;
      
      function setAvailableSize(param1:Number, param2:Number) : SizeConstraints;
      
      function getExplicitSize() : Point;
      
      function setExplicitSize(param1:Number, param2:Number) : Point;
      
      function getExplicitPosition() : Point;
      
      function setExplicitPosition(param1:Number, param2:Number) : Point;
   }
}

