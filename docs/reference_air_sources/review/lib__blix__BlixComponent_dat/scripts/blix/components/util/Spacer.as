package blix.components.util
{
   import blix.layout.vo.SizeConstraints;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import blix.view.ILayoutElement;
   import flash.geom.Point;
   
   public class Spacer implements ILayoutElement
   {
      
      private var _explicitPosition:Point;
      
      private var _explicitSize:Point;
      
      private var _includeInLayout:Boolean = true;
      
      private var _layoutInvalidated:Signal = new Signal();
      
      public function Spacer()
      {
         super();
      }
      
      public function getLayoutInvalidated() : ISignal
      {
         return this._layoutInvalidated;
      }
      
      public function invalidateLayout() : void
      {
         this._layoutInvalidated.dispatch();
      }
      
      public function getIncludeInLayout() : Boolean
      {
         return this._includeInLayout;
      }
      
      public function setIncludeInLayout(param1:Boolean) : void
      {
         this._includeInLayout = param1;
      }
      
      public function setAvailableSize(param1:Number, param2:Number) : SizeConstraints
      {
         return new SizeConstraints();
      }
      
      public function getExplicitSize() : Point
      {
         return this._explicitSize;
      }
      
      public function setExplicitSize(param1:Number, param2:Number) : Point
      {
         this._explicitSize = new Point(param1 || 0,param2 || 0);
         return this._explicitSize;
      }
      
      public function getExplicitPosition() : Point
      {
         return this._explicitPosition;
      }
      
      public function setExplicitPosition(param1:Number, param2:Number) : Point
      {
         this._explicitPosition = new Point(param1,param2);
         return this._explicitPosition;
      }
   }
}

