package blix.layout.algorithms
{
   import blix.layout.LayoutEntry;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import blix.util.geom.mergeRect;
   import flash.errors.IllegalOperationError;
   import flash.geom.Rectangle;
   
   public class VirtualizedLayoutBase implements IVirtualizedLayoutAlgorithm
   {
      
      protected var _layoutInvalidated:Signal = new Signal();
      
      protected var _buffer:Number = 0.15;
      
      public function VirtualizedLayoutBase()
      {
         super();
      }
      
      public function getLayoutInvalidated() : ISignal
      {
         return this._layoutInvalidated;
      }
      
      public function getBuffer() : Number
      {
         return this._buffer;
      }
      
      public function setBuffer(param1:Number) : void
      {
         if(this._buffer == param1)
         {
            return;
         }
         this._buffer = param1;
         this.invalidateLayout();
      }
      
      public function invalidateLayout() : void
      {
         this._layoutInvalidated.dispatch(this);
      }
      
      public function calculateMeasuredBounds(param1:Vector.<Rectangle>, param2:Boolean, param3:uint) : Rectangle
      {
         var _loc5_:Rectangle = null;
         var _loc4_:Rectangle = new Rectangle();
         for each(_loc5_ in param1)
         {
            _loc4_ = mergeRect(_loc4_,_loc5_);
         }
         return _loc4_;
      }
      
      public function getShouldShowRenderer(param1:Rectangle, param2:Number, param3:Number, param4:Boolean) : Boolean
      {
         var _loc5_:Number = param2 * this._buffer;
         var _loc6_:Number = param3 * this._buffer;
         if(param1.bottom < -_loc6_ || param1.top > param3 + _loc6_ || param1.right < -_loc5_ || param1.left > param2 + _loc5_)
         {
            return false;
         }
         return true;
      }
      
      public function updateLayoutEntry(param1:Number, param2:Number, param3:LayoutEntry, param4:uint, param5:Number, param6:uint, param7:Rectangle, param8:Boolean) : Rectangle
      {
         throw new IllegalOperationError("updateLayoutEntry is an abstract function. It must be overridden.");
      }
      
      public function getOffset(param1:Rectangle, param2:Rectangle, param3:uint, param4:uint, param5:Boolean) : Number
      {
         throw new IllegalOperationError("getOffset is an abstract function. It must be overridden.");
      }
   }
}

