package blix.layout.algorithms
{
   import blix.layout.LayoutEntry;
   import blix.signals.ISignal;
   import flash.geom.Rectangle;
   
   public interface IVirtualizedLayoutAlgorithm
   {
      
      function getLayoutInvalidated() : ISignal;
      
      function getShouldShowRenderer(param1:Rectangle, param2:Number, param3:Number, param4:Boolean) : Boolean;
      
      function getOffset(param1:Rectangle, param2:Rectangle, param3:uint, param4:uint, param5:Boolean) : Number;
      
      function calculateMeasuredBounds(param1:Vector.<Rectangle>, param2:Boolean, param3:uint) : Rectangle;
      
      function updateLayoutEntry(param1:Number, param2:Number, param3:LayoutEntry, param4:uint, param5:Number, param6:uint, param7:Rectangle, param8:Boolean) : Rectangle;
   }
}

