package com.degrafa
{
   import com.degrafa.core.collections.FillCollection;
   import com.degrafa.core.collections.StrokeCollection;
   import com.degrafa.geometry.Geometry;
   import flash.display.Graphics;
   import flash.geom.Rectangle;
   import mx.events.PropertyChangeEvent;
   
   public class GeometryComposition extends Geometry implements IGeometry
   {
      
      private var _fills:FillCollection;
      
      private var _bounds:Rectangle;
      
      private var _strokes:StrokeCollection;
      
      public function GeometryComposition()
      {
         super();
      }
      
      public function set fills(param1:Array) : void
      {
         initFillsCollection();
         _fills.items = param1;
      }
      
      public function get fillCollection() : FillCollection
      {
         initFillsCollection();
         return _fills;
      }
      
      override public function preDraw() : void
      {
         calcBounds();
      }
      
      public function get childBounds() : Rectangle
      {
         var _loc1_:Rectangle = null;
         var _loc2_:Geometry = null;
         for each(_loc2_ in geometry)
         {
            if(!_loc1_ || _loc1_.isEmpty())
            {
               _loc1_ = _loc2_.bounds;
            }
            else
            {
               _loc1_ = _loc1_.union(_loc2_.bounds);
            }
         }
         return _loc1_;
      }
      
      public function calcBounds() : void
      {
         if(_layoutConstraint)
         {
            super.calculateLayout();
            _bounds = layoutRectangle;
         }
         else if(Boolean(parent) && parent is Geometry)
         {
            _bounds = Geometry(parent).bounds;
         }
         else if(_currentGraphicsTarget)
         {
            _bounds = _currentGraphicsTarget.getRect(_currentGraphicsTarget);
         }
         else
         {
            _bounds = new Rectangle();
         }
      }
      
      override public function draw(param1:Graphics, param2:Rectangle) : void
      {
         calculateLayout();
         preDraw();
         super.draw(param1,param2 ? param2 : _bounds);
      }
      
      public function get fills() : Array
      {
         initFillsCollection();
         return _fills.items;
      }
      
      override public function get bounds() : Rectangle
      {
         return _bounds;
      }
      
      public function set strokes(param1:Array) : void
      {
         initSrokesCollection();
         _strokes.items = param1;
      }
      
      private function initSrokesCollection() : void
      {
         if(!_strokes)
         {
            _strokes = new StrokeCollection();
            if(enableEvents)
            {
               _strokes.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,propertyChangeHandler);
            }
         }
      }
      
      public function get strokes() : Array
      {
         initSrokesCollection();
         return _strokes.items;
      }
      
      public function get strokeCollection() : StrokeCollection
      {
         initSrokesCollection();
         return _strokes;
      }
      
      private function initFillsCollection() : void
      {
         if(!_fills)
         {
            _fills = new FillCollection();
            if(enableEvents)
            {
               _fills.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,propertyChangeHandler);
            }
         }
      }
      
      override public function calculateLayout(param1:Rectangle = null) : void
      {
         var _loc2_:Rectangle = null;
         if(_layoutConstraint)
         {
            if(_layoutConstraint.invalidated)
            {
               _loc2_ = new Rectangle(0,0,1,1);
               super.calculateLayout(_loc2_);
               _layoutRectangle = _layoutConstraint.layoutRectangle;
            }
         }
      }
   }
}

