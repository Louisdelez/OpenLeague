package spark.primitives
{
   import flash.display.Graphics;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.utils.MatrixUtil;
   import spark.primitives.supportClasses.FilledElement;
   
   public class Ellipse extends FilledElement
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function Ellipse()
      {
         super();
      }
      
      override protected function draw(g:Graphics) : void
      {
         g.drawEllipse(drawX,drawY,width,height);
      }
      
      override protected function transformWidthForLayout(width:Number, height:Number, postLayoutTransform:Boolean = true) : Number
      {
         if(postLayoutTransform && hasComplexLayoutMatrix)
         {
            width = Number(MatrixUtil.getEllipseBoundingBox(width / 2,height / 2,width / 2,height / 2,layoutFeatures.layoutMatrix).width);
         }
         return width + getStrokeExtents(postLayoutTransform).width;
      }
      
      override protected function transformHeightForLayout(width:Number, height:Number, postLayoutTransform:Boolean = true) : Number
      {
         if(postLayoutTransform && hasComplexLayoutMatrix)
         {
            height = Number(MatrixUtil.getEllipseBoundingBox(width / 2,height / 2,width / 2,height / 2,layoutFeatures.layoutMatrix).height);
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
         return strokeExtents.left + MatrixUtil.getEllipseBoundingBox(newSize.x / 2,newSize.y / 2,newSize.x / 2,newSize.y / 2,m).x;
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
         return strokeExtents.top + MatrixUtil.getEllipseBoundingBox(newSize.x / 2,newSize.y / 2,newSize.x / 2,newSize.y / 2,m).y;
      }
      
      override public function getLayoutBoundsX(postLayoutTransform:Boolean = true) : Number
      {
         var stroke:Number = getStrokeExtents(postLayoutTransform).left;
         if(postLayoutTransform && hasComplexLayoutMatrix)
         {
            return stroke + MatrixUtil.getEllipseBoundingBox(width / 2,height / 2,width / 2,height / 2,layoutFeatures.layoutMatrix).x;
         }
         return stroke + this.x;
      }
      
      override public function getLayoutBoundsY(postLayoutTransform:Boolean = true) : Number
      {
         var stroke:Number = getStrokeExtents(postLayoutTransform).top;
         if(postLayoutTransform && hasComplexLayoutMatrix)
         {
            return stroke + MatrixUtil.getEllipseBoundingBox(width / 2,height / 2,width / 2,height / 2,layoutFeatures.layoutMatrix).y;
         }
         return stroke + this.y;
      }
      
      private function getBoundingBox(width:Number, height:Number, m:Matrix) : Rectangle
      {
         return MatrixUtil.getEllipseBoundingBox(0,0,width / 2,height / 2,m);
      }
      
      override public function setLayoutBoundsSize(width:Number, height:Number, postLayoutTransform:Boolean = true) : void
      {
         var m:Matrix = getComplexMatrix(postLayoutTransform);
         if(!m)
         {
            super.setLayoutBoundsSize(width,height,postLayoutTransform);
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
            if(Boolean(size1) && this.getBoundingBox(size1.x,size1.y,m).width > width)
            {
               size1 = null;
            }
            if(Boolean(size2) && this.getBoundingBox(size2.x,size2.y,m).height > height)
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
         var postTransformBounds:Rectangle = null;
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
            postTransformBounds = this.getBoundingBox(newWidth,newHeight,m);
            widthDifference = isNaN(width) ? 0 : width - postTransformBounds.width;
            heightDifference = isNaN(height) ? 0 : height - postTransformBounds.height;
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

