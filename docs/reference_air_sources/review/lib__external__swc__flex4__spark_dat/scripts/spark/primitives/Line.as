package spark.primitives
{
   import flash.display.Graphics;
   import flash.display.GraphicsStroke;
   import flash.display.IGraphicsData;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import spark.primitives.supportClasses.StrokedElement;
   
   public class Line extends StrokedElement
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var _xFrom:Number = 0;
      
      private var _xTo:Number = 0;
      
      private var _yFrom:Number = 0;
      
      private var _yTo:Number = 0;
      
      public function Line()
      {
         super();
      }
      
      [Inspectable(category="General")]
      public function get xFrom() : Number
      {
         return this._xFrom;
      }
      
      public function set xFrom(value:Number) : void
      {
         if(value != this._xFrom)
         {
            this._xFrom = value;
            invalidateSize();
            invalidateDisplayList();
         }
      }
      
      [Inspectable(category="General")]
      public function get xTo() : Number
      {
         return this._xTo;
      }
      
      public function set xTo(value:Number) : void
      {
         if(value != this._xTo)
         {
            this._xTo = value;
            invalidateSize();
            invalidateDisplayList();
         }
      }
      
      [Inspectable(category="General")]
      public function get yFrom() : Number
      {
         return this._yFrom;
      }
      
      public function set yFrom(value:Number) : void
      {
         if(value != this._yFrom)
         {
            this._yFrom = value;
            invalidateSize();
            invalidateDisplayList();
         }
      }
      
      [Inspectable(category="General")]
      public function get yTo() : Number
      {
         return this._yTo;
      }
      
      public function set yTo(value:Number) : void
      {
         if(value != this._yTo)
         {
            this._yTo = value;
            invalidateSize();
            invalidateDisplayList();
         }
      }
      
      override protected function canSkipMeasurement() : Boolean
      {
         return false;
      }
      
      override protected function measure() : void
      {
         measuredWidth = Math.abs(this.xFrom - this.xTo);
         measuredHeight = Math.abs(this.yFrom - this.yTo);
         measuredX = Math.min(this.xFrom,this.xTo);
         measuredY = Math.min(this.yFrom,this.yTo);
      }
      
      override protected function beginDraw(g:Graphics) : void
      {
         var graphicsStroke:GraphicsStroke = null;
         if(Boolean(stroke))
         {
            graphicsStroke = GraphicsStroke(stroke.createGraphicsStroke(new Rectangle(drawX + measuredX,drawY + measuredY,Math.max(width,stroke.weight),Math.max(height,stroke.weight)),new Point(drawX + measuredX,drawY + measuredY)));
         }
         if(Boolean(graphicsStroke))
         {
            g.drawGraphicsData(new <IGraphicsData>[graphicsStroke]);
         }
         else
         {
            super.beginDraw(g);
         }
      }
      
      override protected function draw(g:Graphics) : void
      {
         var x1:Number = measuredX + drawX;
         var y1:Number = measuredY + drawY;
         var x2:Number = measuredX + drawX + width;
         var y2:Number = measuredY + drawY + height;
         if(this.xFrom <= this.xTo == this.yFrom <= this.yTo)
         {
            g.moveTo(x1,y1);
            g.lineTo(x2,y2);
         }
         else
         {
            g.moveTo(x1,y2);
            g.lineTo(x2,y1);
         }
      }
   }
}

