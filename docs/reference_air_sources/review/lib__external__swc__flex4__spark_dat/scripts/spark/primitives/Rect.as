package spark.primitives
{
   import flash.display.Graphics;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.utils.GraphicsUtil;
   import mx.utils.MatrixUtil;
   import spark.primitives.supportClasses.FilledElement;
   
   public class Rect extends FilledElement
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private var _bottomLeftRadiusX:Number;
      
      private var _bottomLeftRadiusY:Number;
      
      private var _bottomRightRadiusX:Number;
      
      private var _bottomRightRadiusY:Number;
      
      private var _radiusX:Number = 0;
      
      private var _radiusY:Number = 0;
      
      private var _topLeftRadiusX:Number;
      
      private var _topLeftRadiusY:Number;
      
      private var _topRightRadiusX:Number;
      
      private var _topRightRadiusY:Number;
      
      public function Rect()
      {
         super();
      }
      
      private static function getRoundRectBoundingBox(width:Number, height:Number, r:Rect, m:Matrix) : Rectangle
      {
         var boundingBox:Rectangle = null;
         var rX:Number = NaN;
         var rY:Number = NaN;
         var radiusValue:Function = function(def:Number, value:Number, max:Number):Number
         {
            var result:Number = isNaN(value) ? def : value;
            return Math.min(result,max);
         };
         var maxRadiusX:Number = width / 2;
         var maxRadiusY:Number = height / 2;
         var radiusX:Number = r.radiusX;
         var radiusY:Number = r.radiusY == 0 ? radiusX : r.radiusY;
         rX = radiusValue(radiusX,r.topLeftRadiusX,maxRadiusX);
         rY = radiusValue(radiusY,r.topLeftRadiusY,maxRadiusY);
         boundingBox = MatrixUtil.getEllipseBoundingBox(rX,rY,rX,rY,m,boundingBox);
         rX = radiusValue(radiusX,r.topRightRadiusX,maxRadiusX);
         rY = radiusValue(radiusY,r.topRightRadiusY,maxRadiusY);
         boundingBox = MatrixUtil.getEllipseBoundingBox(width - rX,rY,rX,rY,m,boundingBox);
         rX = radiusValue(radiusX,r.bottomRightRadiusX,maxRadiusX);
         rY = radiusValue(radiusY,r.bottomRightRadiusY,maxRadiusY);
         boundingBox = MatrixUtil.getEllipseBoundingBox(width - rX,height - rY,rX,rY,m,boundingBox);
         rX = radiusValue(radiusX,r.bottomLeftRadiusX,maxRadiusX);
         rY = radiusValue(radiusY,r.bottomLeftRadiusY,maxRadiusY);
         boundingBox = MatrixUtil.getEllipseBoundingBox(rX,height - rY,rX,rY,m,boundingBox);
         return boundingBox;
      }
      
      [Inspectable(category="General",minValue="0.0")]
      public function get bottomLeftRadiusX() : Number
      {
         return this._bottomLeftRadiusX;
      }
      
      public function set bottomLeftRadiusX(value:Number) : void
      {
         if(value != this._bottomLeftRadiusX)
         {
            this._bottomLeftRadiusX = value;
            invalidateSize();
            invalidateDisplayList();
            invalidateParentSizeAndDisplayList();
         }
      }
      
      [Inspectable(category="General",minValue="0.0")]
      public function get bottomLeftRadiusY() : Number
      {
         return this._bottomLeftRadiusY;
      }
      
      public function set bottomLeftRadiusY(value:Number) : void
      {
         if(value != this._bottomLeftRadiusY)
         {
            this._bottomLeftRadiusY = value;
            invalidateSize();
            invalidateDisplayList();
            invalidateParentSizeAndDisplayList();
         }
      }
      
      [Inspectable(category="General",minValue="0.0")]
      public function get bottomRightRadiusX() : Number
      {
         return this._bottomRightRadiusX;
      }
      
      public function set bottomRightRadiusX(value:Number) : void
      {
         if(value != this.bottomRightRadiusX)
         {
            this._bottomRightRadiusX = value;
            invalidateSize();
            invalidateDisplayList();
            invalidateParentSizeAndDisplayList();
         }
      }
      
      [Inspectable(category="General",minValue="0.0")]
      public function get bottomRightRadiusY() : Number
      {
         return this._bottomRightRadiusY;
      }
      
      public function set bottomRightRadiusY(value:Number) : void
      {
         if(value != this._bottomRightRadiusY)
         {
            this._bottomRightRadiusY = value;
            invalidateSize();
            invalidateDisplayList();
            invalidateParentSizeAndDisplayList();
         }
      }
      
      [Inspectable(category="General",minValue="0.0")]
      public function get radiusX() : Number
      {
         return this._radiusX;
      }
      
      public function set radiusX(value:Number) : void
      {
         if(value != this._radiusX)
         {
            this._radiusX = value;
            invalidateSize();
            invalidateDisplayList();
            invalidateParentSizeAndDisplayList();
         }
      }
      
      [Inspectable(category="General",minValue="0.0")]
      public function get radiusY() : Number
      {
         return this._radiusY;
      }
      
      public function set radiusY(value:Number) : void
      {
         if(value != this._radiusY)
         {
            this._radiusY = value;
            invalidateSize();
            invalidateDisplayList();
            invalidateParentSizeAndDisplayList();
         }
      }
      
      [Inspectable(category="General",minValue="0.0")]
      public function get topLeftRadiusX() : Number
      {
         return this._topLeftRadiusX;
      }
      
      public function set topLeftRadiusX(value:Number) : void
      {
         if(value != this._topLeftRadiusX)
         {
            this._topLeftRadiusX = value;
            invalidateSize();
            invalidateDisplayList();
            invalidateParentSizeAndDisplayList();
         }
      }
      
      [Inspectable(category="General",minValue="0.0")]
      public function get topLeftRadiusY() : Number
      {
         return this._topLeftRadiusY;
      }
      
      public function set topLeftRadiusY(value:Number) : void
      {
         if(value != this._topLeftRadiusY)
         {
            this._topLeftRadiusY = value;
            invalidateSize();
            invalidateDisplayList();
            invalidateParentSizeAndDisplayList();
         }
      }
      
      [Inspectable(category="General",minValue="0.0")]
      public function get topRightRadiusX() : Number
      {
         return this._topRightRadiusX;
      }
      
      public function set topRightRadiusX(value:Number) : void
      {
         if(value != this.topRightRadiusX)
         {
            this._topRightRadiusX = value;
            invalidateSize();
            invalidateDisplayList();
            invalidateParentSizeAndDisplayList();
         }
      }
      
      [Inspectable(category="General",minValue="0.0")]
      public function get topRightRadiusY() : Number
      {
         return this._topRightRadiusY;
      }
      
      public function set topRightRadiusY(value:Number) : void
      {
         if(value != this._topRightRadiusY)
         {
            this._topRightRadiusY = value;
            invalidateSize();
            invalidateDisplayList();
            invalidateParentSizeAndDisplayList();
         }
      }
      
      override protected function draw(g:Graphics) : void
      {
         var rX:Number = NaN;
         var rY:Number = NaN;
         if(!isNaN(this.topLeftRadiusX) || !isNaN(this.topRightRadiusX) || !isNaN(this.bottomLeftRadiusX) || !isNaN(this.bottomRightRadiusX))
         {
            GraphicsUtil.drawRoundRectComplex2(g,drawX,drawY,width,height,this.radiusX,this.radiusY,this.topLeftRadiusX,this.topLeftRadiusY,this.topRightRadiusX,this.topRightRadiusY,this.bottomLeftRadiusX,this.bottomLeftRadiusY,this.bottomRightRadiusX,this.bottomRightRadiusY);
         }
         else if(this.radiusX != 0)
         {
            rX = this.radiusX;
            rY = this.radiusY == 0 ? this.radiusX : this.radiusY;
            g.drawRoundRect(drawX,drawY,width,height,rX * 2,rY * 2);
         }
         else
         {
            g.drawRect(drawX,drawY,width,height);
         }
      }
      
      override protected function transformWidthForLayout(width:Number, height:Number, postLayoutTransform:Boolean = true) : Number
      {
         if(postLayoutTransform && hasComplexLayoutMatrix)
         {
            width = getRoundRectBoundingBox(width,height,this,layoutFeatures.layoutMatrix).width;
         }
         return width + getStrokeExtents(postLayoutTransform).width;
      }
      
      override protected function transformHeightForLayout(width:Number, height:Number, postLayoutTransform:Boolean = true) : Number
      {
         if(postLayoutTransform && hasComplexLayoutMatrix)
         {
            height = getRoundRectBoundingBox(width,height,this,layoutFeatures.layoutMatrix).height;
         }
         return height + getStrokeExtents(postLayoutTransform).height;
      }
      
      override public function getBoundsXAtSize(width:Number, height:Number, postLayoutTransform:Boolean = true) : Number
      {
         var strokeExtents:Rectangle = getStrokeExtents(postLayoutTransform);
         var m:Matrix = getComplexMatrix(postLayoutTransform);
         if(!m)
         {
            return strokeExtents.left + this.x;
         }
         if(!isNaN(width))
         {
            width -= strokeExtents.width;
         }
         if(!isNaN(height))
         {
            height -= strokeExtents.height;
         }
         var newSize:Point = MatrixUtil.fitBounds(width,height,m,explicitWidth,explicitHeight,preferredWidthPreTransform(),preferredHeightPreTransform(),minWidth,minHeight,maxWidth,maxHeight);
         if(!newSize)
         {
            newSize = new Point(minWidth,minHeight);
         }
         return strokeExtents.left + getRoundRectBoundingBox(newSize.x,newSize.y,this,m).x;
      }
      
      override public function getBoundsYAtSize(width:Number, height:Number, postLayoutTransform:Boolean = true) : Number
      {
         var strokeExtents:Rectangle = getStrokeExtents(postLayoutTransform);
         var m:Matrix = getComplexMatrix(postLayoutTransform);
         if(!m)
         {
            return strokeExtents.top + this.y;
         }
         if(!isNaN(width))
         {
            width -= strokeExtents.width;
         }
         if(!isNaN(height))
         {
            height -= strokeExtents.height;
         }
         var newSize:Point = MatrixUtil.fitBounds(width,height,m,explicitWidth,explicitHeight,preferredWidthPreTransform(),preferredHeightPreTransform(),minWidth,minHeight,maxWidth,maxHeight);
         if(!newSize)
         {
            newSize = new Point(minWidth,minHeight);
         }
         return strokeExtents.top + getRoundRectBoundingBox(newSize.x,newSize.y,this,m).y;
      }
      
      override public function getLayoutBoundsX(postLayoutTransform:Boolean = true) : Number
      {
         var stroke:Number = getStrokeExtents(postLayoutTransform).left;
         if(postLayoutTransform && hasComplexLayoutMatrix)
         {
            return stroke + getRoundRectBoundingBox(width,height,this,layoutFeatures.layoutMatrix).x;
         }
         return stroke + this.x;
      }
      
      override public function getLayoutBoundsY(postLayoutTransform:Boolean = true) : Number
      {
         var stroke:Number = getStrokeExtents(postLayoutTransform).top;
         if(postLayoutTransform && hasComplexLayoutMatrix)
         {
            return stroke + getRoundRectBoundingBox(width,height,this,layoutFeatures.layoutMatrix).y;
         }
         return stroke + this.y;
      }
      
      override public function setLayoutBoundsSize(width:Number, height:Number, postLayoutTransform:Boolean = true) : void
      {
         super.setLayoutBoundsSize(width,height,postLayoutTransform);
         var isRounded:Boolean = !isNaN(this.topLeftRadiusX) || !isNaN(this.topRightRadiusX) || !isNaN(this.bottomLeftRadiusX) || !isNaN(this.bottomRightRadiusX) || this.radiusX != 0 || this.radiusY != 0;
         if(!isRounded)
         {
            return;
         }
         var m:Matrix = getComplexMatrix(postLayoutTransform);
         if(!m)
         {
            return;
         }
         this.setLayoutBoundsTransformed(width,height,m);
      }
      
      private function setLayoutBoundsTransformed(width:Number, height:Number, m:Matrix) : void
      {
         var size1:Point = null;
         var size2:Point = null;
         var pickSize1:Boolean = false;
         var strokeExtents:Rectangle = getStrokeExtents(true);
         width -= strokeExtents.width;
         height -= strokeExtents.height;
         var size:Point = this.fitLayoutBoundsIterative(width,height,m);
         if(!size && !isNaN(width) && !isNaN(height))
         {
            size1 = this.fitLayoutBoundsIterative(NaN,height,m);
            size2 = this.fitLayoutBoundsIterative(width,NaN,m);
            if(Boolean(size1) && getRoundRectBoundingBox(size1.x,size1.y,this,m).width > width)
            {
               size1 = null;
            }
            if(Boolean(size2) && getRoundRectBoundingBox(size2.x,size2.y,this,m).height > height)
            {
               size2 = null;
            }
            if(Boolean(size1) && Boolean(size2))
            {
               pickSize1 = size1.x * size1.y > size2.x * size2.y;
               if(pickSize1)
               {
                  size = size1;
               }
               else
               {
                  size = size2;
               }
            }
            else if(Boolean(size1))
            {
               size = size1;
            }
            else
            {
               size = size2;
            }
         }
         if(Boolean(size))
         {
            setActualSize(size.x,size.y);
         }
         else
         {
            setActualSize(minWidth,minHeight);
         }
      }
      
      private function fitLayoutBoundsIterative(width:Number, height:Number, m:Matrix) : Point
      {
         var roundedRectBounds:Rectangle = null;
         var widthDifference:Number = NaN;
         var heightDifference:Number = NaN;
         var newSize:Point = null;
         var newWidth:Number = this.preferredWidthPreTransform();
         var newHeight:Number = this.preferredHeightPreTransform();
         var fitWidth:Number = Number(MatrixUtil.transformBounds(newWidth,newHeight,m).x);
         var fitHeight:Number = Number(MatrixUtil.transformBounds(newWidth,newHeight,m).y);
         if(isNaN(width))
         {
            fitWidth = NaN;
         }
         if(isNaN(height))
         {
            fitHeight = NaN;
         }
         var i:int = 0;
         while(i++ < 150)
         {
            roundedRectBounds = getRoundRectBoundingBox(newWidth,newHeight,this,m);
            widthDifference = isNaN(width) ? 0 : width - roundedRectBounds.width;
            heightDifference = isNaN(height) ? 0 : height - roundedRectBounds.height;
            if(Math.abs(widthDifference) < 0.1 && Math.abs(heightDifference) < 0.1)
            {
               return new Point(newWidth,newHeight);
            }
            fitWidth += widthDifference * 0.5;
            fitHeight += heightDifference * 0.5;
            newSize = MatrixUtil.fitBounds(fitWidth,fitHeight,m,explicitWidth,explicitHeight,preferredWidthPreTransform(),preferredHeightPreTransform(),minWidth,minHeight,maxWidth,maxHeight);
            if(!newSize)
            {
               break;
            }
            newWidth = newSize.x;
            newHeight = newSize.y;
         }
         return null;
      }
   }
}

