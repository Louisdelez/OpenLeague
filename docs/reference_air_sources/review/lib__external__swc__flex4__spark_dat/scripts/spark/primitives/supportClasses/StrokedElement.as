package spark.primitives.supportClasses
{
   import flash.display.Graphics;
   import flash.display.LineScaleMode;
   import flash.display.Sprite;
   import flash.events.EventDispatcher;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.events.PropertyChangeEvent;
   import mx.graphics.IStroke;
   
   public class StrokedElement extends GraphicElement
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var _stroke:IStroke;
      
      public function StrokedElement()
      {
         super();
      }
      
      [Inspectable(category="General")]
      [Bindable("propertyChange")]
      public function get stroke() : IStroke
      {
         return this._stroke;
      }
      
      public function set stroke(value:IStroke) : void
      {
         var strokeEventDispatcher:EventDispatcher = null;
         var oldValue:IStroke = this._stroke;
         strokeEventDispatcher = this._stroke as EventDispatcher;
         if(Boolean(strokeEventDispatcher))
         {
            strokeEventDispatcher.removeEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.stroke_propertyChangeHandler);
         }
         this._stroke = value;
         strokeEventDispatcher = this._stroke as EventDispatcher;
         if(Boolean(strokeEventDispatcher))
         {
            strokeEventDispatcher.addEventListener(PropertyChangeEvent.PROPERTY_CHANGE,this.stroke_propertyChangeHandler);
         }
         dispatchPropertyChangeEvent("stroke",oldValue,this._stroke);
         invalidateDisplayList();
         invalidateParentSizeAndDisplayList();
      }
      
      override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number) : void
      {
         if(!drawnDisplayObject || !(drawnDisplayObject is Sprite))
         {
            return;
         }
         var g:Graphics = (drawnDisplayObject as Sprite).graphics;
         this.beginDraw(g);
         this.draw(g);
         this.endDraw(g);
      }
      
      protected function beginDraw(g:Graphics) : void
      {
         var strokeBounds:Rectangle = null;
         if(Boolean(this.stroke))
         {
            strokeBounds = this.getStrokeBounds();
            strokeBounds.offset(drawX,drawY);
            this.stroke.apply(g,strokeBounds,new Point(drawX,drawY));
         }
         else
         {
            g.lineStyle();
         }
         g.beginFill(0,0);
      }
      
      protected function draw(g:Graphics) : void
      {
      }
      
      protected function endDraw(g:Graphics) : void
      {
         g.endFill();
      }
      
      protected function getStrokeBounds() : Rectangle
      {
         var strokeBounds:Rectangle = this.getStrokeExtents(false);
         strokeBounds.x += measuredX;
         strokeBounds.width += width;
         strokeBounds.y += measuredY;
         strokeBounds.height += height;
         return strokeBounds;
      }
      
      override protected function getStrokeExtents(postLayoutTransform:Boolean = true) : Rectangle
      {
         if(!this.stroke)
         {
            _strokeExtents.x = 0;
            _strokeExtents.y = 0;
            _strokeExtents.width = 0;
            _strokeExtents.height = 0;
            return _strokeExtents;
         }
         var weight:Number = Number(this.stroke.weight);
         if(weight == 0)
         {
            _strokeExtents.width = 1;
            _strokeExtents.height = 1;
            _strokeExtents.x = -0.5;
            _strokeExtents.y = -0.5;
            return _strokeExtents;
         }
         var scaleMode:String = this.stroke.scaleMode;
         if(!scaleMode || scaleMode == LineScaleMode.NONE || !postLayoutTransform)
         {
            _strokeExtents.width = weight;
            _strokeExtents.height = weight;
            _strokeExtents.x = -weight * 0.5;
            _strokeExtents.y = -weight * 0.5;
            return _strokeExtents;
         }
         var sX:Number = scaleX;
         var sY:Number = scaleY;
         if(scaleMode == LineScaleMode.NORMAL)
         {
            if(sX == sY)
            {
               weight *= sX;
            }
            else
            {
               weight *= Math.sqrt(0.5 * (sX * sX + sY * sY));
            }
            _strokeExtents.width = weight;
            _strokeExtents.height = weight;
            _strokeExtents.x = weight * -0.5;
            _strokeExtents.y = weight * -0.5;
            return _strokeExtents;
         }
         if(scaleMode == LineScaleMode.HORIZONTAL)
         {
            _strokeExtents.width = weight * sX;
            _strokeExtents.height = weight;
            _strokeExtents.x = weight * sX * -0.5;
            _strokeExtents.y = weight * -0.5;
            return _strokeExtents;
         }
         if(scaleMode == LineScaleMode.VERTICAL)
         {
            _strokeExtents.width = weight;
            _strokeExtents.height = weight * sY;
            _strokeExtents.x = weight * -0.5;
            _strokeExtents.y = weight * sY * -0.5;
            return _strokeExtents;
         }
         return null;
      }
      
      protected function stroke_propertyChangeHandler(event:PropertyChangeEvent) : void
      {
         invalidateDisplayList();
         switch(event.property)
         {
            case "weight":
            case "scaleMode":
               invalidateParentSizeAndDisplayList();
         }
      }
   }
}

