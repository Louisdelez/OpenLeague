package spark.primitives
{
   import flash.display.Graphics;
   import flash.display.GraphicsPath;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.events.PropertyChangeEvent;
   import mx.graphics.IStroke;
   import mx.utils.MatrixUtil;
   import spark.primitives.supportClasses.FilledElement;
   
   public class Path extends FilledElement
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      private static var tangent:Point = new Point();
      
      private var graphicsPathChanged:Boolean = true;
      
      private var segments:PathSegmentsCollection;
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") var graphicsPath:GraphicsPath = new GraphicsPath(new Vector.<int>(),new Vector.<Number>());
      
      private var _data:String;
      
      private var _winding:String = "evenOdd";
      
      private var _boundingBoxCached:Rectangle;
      
      private var _boundingBoxMatrixCached:Matrix;
      
      private var _boundingBoxWidthParamCached:Number;
      
      private var _boundingBoxHeightParamCached:Number;
      
      private var _boundingBoxX:Number;
      
      private var _boundingBoxY:Number;
      
      private var _drawBounds:Rectangle = new Rectangle();
      
      public function Path()
      {
         super();
      }
      
      [Inspectable(category="General")]
      public function set data(value:String) : void
      {
         if(this._data == value)
         {
            return;
         }
         this.segments = new PathSegmentsCollection(value);
         this.graphicsPathChanged = true;
         this.clearCachedBoundingBoxWithStroke();
         invalidateSize();
         invalidateDisplayList();
         this._data = value;
      }
      
      public function get data() : String
      {
         return this._data;
      }
      
      public function set winding(value:String) : void
      {
         if(this._winding != value)
         {
            this._winding = value;
            this.graphicsPathChanged = true;
            invalidateDisplayList();
         }
      }
      
      public function get winding() : String
      {
         return this._winding;
      }
      
      private function getBounds() : Rectangle
      {
         return Boolean(this.segments) ? this.segments.getBounds() : new Rectangle();
      }
      
      override protected function measure() : void
      {
         var bounds:Rectangle = null;
         bounds = this.getBounds();
         measuredWidth = bounds.width;
         measuredHeight = bounds.height;
         measuredX = bounds.left;
         measuredY = bounds.top;
      }
      
      private function getBoundingBoxWithStroke(width:Number, height:Number, m:Matrix) : Rectangle
      {
         if(Boolean(this._boundingBoxCached) && Boolean(this._boundingBoxWidthParamCached == width) && this._boundingBoxHeightParamCached == height)
         {
            if(!m && !this._boundingBoxMatrixCached)
            {
               this._boundingBoxCached.x = this._boundingBoxX;
               this._boundingBoxCached.y = this._boundingBoxY;
               return this._boundingBoxCached;
            }
            if(Boolean(m && this._boundingBoxMatrixCached && m.a == this._boundingBoxMatrixCached.a && m.b == this._boundingBoxMatrixCached.b) && Boolean(m.c == this._boundingBoxMatrixCached.c) && m.d == this._boundingBoxMatrixCached.d)
            {
               this._boundingBoxCached.x = this._boundingBoxX + m.tx;
               this._boundingBoxCached.y = this._boundingBoxY + m.ty;
               return this._boundingBoxCached;
            }
         }
         if(Boolean(m))
         {
            this._boundingBoxMatrixCached = m.clone();
            this._boundingBoxMatrixCached.tx = 0;
            this._boundingBoxMatrixCached.ty = 0;
         }
         else
         {
            this._boundingBoxMatrixCached = null;
         }
         this._boundingBoxWidthParamCached = width;
         this._boundingBoxHeightParamCached = height;
         this._boundingBoxCached = this.computeBoundsWithStroke(this._boundingBoxWidthParamCached,this._boundingBoxHeightParamCached,m);
         this._boundingBoxX = this._boundingBoxCached.x - (Boolean(m) ? m.tx : 0);
         this._boundingBoxY = this._boundingBoxCached.y - (Boolean(m) ? m.ty : 0);
         return this._boundingBoxCached;
      }
      
      private function tangentIsValid(prevSegment:PathSegment, curSegment:PathSegment, sx:Number, sy:Number, m:Matrix) : Boolean
      {
         curSegment.getTangent(prevSegment,true,sx,sy,m,tangent);
         return tangent.x != 0 || tangent.y != 0;
      }
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") function computeBoundsWithStroke(width:Number, height:Number, m:Matrix) : Rectangle
      {
         var pathBBox:Rectangle = null;
         var end:int = 0;
         var startSegment:PathSegment = null;
         var endSegment:PathSegment = null;
         var prevSegment:PathSegment = null;
         var naturalBounds:Rectangle = this.getBounds();
         var sx:Number = naturalBounds.width == 0 ? 1 : width / naturalBounds.width;
         var sy:Number = naturalBounds.height == 0 ? 1 : height / naturalBounds.height;
         if(!m || Boolean(MatrixUtil.isDeltaIdentity(m)) || !this.segments)
         {
            pathBBox = new Rectangle(naturalBounds.x * sx,naturalBounds.y * sy,naturalBounds.width * sx,naturalBounds.height * sy);
            if(Boolean(m))
            {
               pathBBox.offset(m.tx,m.ty);
            }
         }
         else
         {
            pathBBox = this.segments.getBoundingBox(width,height,m);
         }
         var strokeSettings:IStroke = this.stroke;
         if(!strokeSettings || !this.segments)
         {
            return pathBBox;
         }
         var strokeExtents:Rectangle = getStrokeExtents();
         pathBBox.inflate(strokeExtents.right,strokeExtents.bottom);
         var seg:Vector.<PathSegment> = this.segments.data;
         if(strokeSettings.joints != "miter" || seg.length < 2)
         {
            return pathBBox;
         }
         var halfWeight:Number = strokeExtents.width / 2;
         var miterLimit:Number = Math.max(1,strokeSettings.miterLimit);
         var count:int = int(seg.length);
         var start:int = 0;
         var lastMoveX:Number = 0;
         var lastMoveY:Number = 0;
         var lastOpenSegment:int = 0;
         while(true)
         {
            while(start < count && !(seg[start] is MoveSegment))
            {
               prevSegment = start > 0 ? seg[start - 1] : null;
               if(this.tangentIsValid(prevSegment,seg[start],sx,sy,m))
               {
                  break;
               }
               start++;
            }
            if(start >= count)
            {
               break;
            }
            startSegment = seg[start];
            if(startSegment is MoveSegment)
            {
               lastOpenSegment = start + 1;
               lastMoveX = startSegment.x;
               lastMoveY = startSegment.y;
               start++;
            }
            else
            {
               if((start == count - 1 || seg[start + 1] is MoveSegment) && startSegment.x == lastMoveX && startSegment.y == lastMoveY)
               {
                  end = lastOpenSegment;
               }
               else
               {
                  end = start + 1;
               }
               while(end < count && !(seg[end] is MoveSegment))
               {
                  if(this.tangentIsValid(startSegment,seg[end],sx,sy,m))
                  {
                     break;
                  }
                  end++;
               }
               if(end >= count)
               {
                  break;
               }
               endSegment = seg[end];
               if(!(endSegment is MoveSegment))
               {
                  this.addMiterLimitStrokeToBounds(start > 0 ? seg[start - 1] : null,startSegment,endSegment,miterLimit,halfWeight,sx,sy,m,pathBBox);
               }
               start = start > end ? int(start + 1) : end;
            }
         }
         return pathBBox;
      }
      
      override protected function getStrokeBounds() : Rectangle
      {
         return this.getBoundingBoxWithStroke(width,height,null);
      }
      
      override protected function get needsDisplayObject() : Boolean
      {
         return super.needsDisplayObject || Boolean(stroke) && stroke.joints == "miter";
      }
      
      private function addMiterLimitStrokeToBounds(segment0:PathSegment, segment1:PathSegment, segment2:PathSegment, miterLimit:Number, weight:Number, sx:Number, sy:Number, m:Matrix, result:Rectangle) : void
      {
         var pt:Point = null;
         var bisectLength:Number = NaN;
         var pt0:Point = null;
         var pt1:Point = null;
         var strokeTip:Point = null;
         pt = MatrixUtil.transformPoint(segment1.x * sx,segment1.y * sy,m).clone();
         var jointX:Number = pt.x;
         var jointY:Number = pt.y;
         var t0:Point = new Point();
         segment1.getTangent(segment0,false,sx,sy,m,t0);
         var t1:Point = new Point();
         segment2.getTangent(segment1,true,sx,sy,m,t1);
         if(t0.length == 0 || t1.length == 0)
         {
            return;
         }
         t0.normalize(1);
         t0.x = -t0.x;
         t0.y = -t0.y;
         t1.normalize(1);
         var halfT0T1:Point = new Point((t1.x - t0.x) * 0.5,(t1.y - t0.y) * 0.5);
         var sinHalfAlpha:Number = halfT0T1.length;
         if(Math.abs(sinHalfAlpha) < 1e-9)
         {
            return;
         }
         var bisect:Point = new Point(-0.5 * (t0.x + t1.x),-0.5 * (t0.y + t1.y));
         if(bisect.length == 0)
         {
            return;
         }
         if(sinHalfAlpha == 0 || miterLimit < 1 / sinHalfAlpha)
         {
            bisectLength = bisect.length;
            bisect.normalize(1);
            halfT0T1.normalize((weight - miterLimit * weight * sinHalfAlpha) / bisectLength);
            pt0 = new Point(jointX + miterLimit * weight * bisect.x + halfT0T1.x,jointY + miterLimit * weight * bisect.y + halfT0T1.y);
            pt1 = new Point(jointX + miterLimit * weight * bisect.x - halfT0T1.x,jointY + miterLimit * weight * bisect.y - halfT0T1.y);
            MatrixUtil.rectUnion(pt0.x,pt0.y,pt0.x,pt0.y,result);
            MatrixUtil.rectUnion(pt1.x,pt1.y,pt1.x,pt1.y,result);
         }
         else
         {
            bisect.normalize(1);
            strokeTip = new Point(jointX + bisect.x * weight / sinHalfAlpha,jointY + bisect.y * weight / sinHalfAlpha);
            MatrixUtil.rectUnion(strokeTip.x,strokeTip.y,strokeTip.x,strokeTip.y,result);
         }
      }
      
      override protected function transformWidthForLayout(width:Number, height:Number, postLayoutTransform:Boolean = true) : Number
      {
         var m:Matrix = getComplexMatrix(postLayoutTransform);
         if(!m && !stroke)
         {
            return width;
         }
         return this.getBoundingBoxWithStroke(width,height,m).width;
      }
      
      override protected function transformHeightForLayout(width:Number, height:Number, postLayoutTransform:Boolean = true) : Number
      {
         var m:Matrix = getComplexMatrix(postLayoutTransform);
         if(!m && !stroke)
         {
            return height;
         }
         return this.getBoundingBoxWithStroke(width,height,m).height;
      }
      
      private function getBoundsAtSize(width:Number, height:Number, m:Matrix) : Rectangle
      {
         var newSize:Point = null;
         var strokeExtents:Rectangle = null;
         if(!isNaN(width))
         {
            strokeExtents = getStrokeExtents(true);
            width -= strokeExtents.width;
         }
         if(!isNaN(height))
         {
            if(!strokeExtents)
            {
               strokeExtents = getStrokeExtents(true);
            }
            height -= strokeExtents.height;
         }
         var newWidth:Number = preferredWidthPreTransform();
         var newHeight:Number = preferredHeightPreTransform();
         if(Boolean(m))
         {
            newSize = MatrixUtil.fitBounds(width,height,m,explicitWidth,explicitHeight,newWidth,newHeight,minWidth,minHeight,maxWidth,maxHeight);
            if(Boolean(newSize))
            {
               newWidth = newSize.x;
               newHeight = newSize.y;
            }
            else
            {
               newWidth = minWidth;
               newHeight = minHeight;
            }
         }
         return this.getBoundingBoxWithStroke(newWidth,newHeight,m);
      }
      
      override public function getBoundsXAtSize(width:Number, height:Number, postLayoutTransform:Boolean = true) : Number
      {
         var m:Matrix = getComplexMatrix(postLayoutTransform);
         return this.getBoundsAtSize(width,height,m).x + (Boolean(m) ? 0 : this.x);
      }
      
      override public function getBoundsYAtSize(width:Number, height:Number, postLayoutTransform:Boolean = true) : Number
      {
         var m:Matrix = getComplexMatrix(postLayoutTransform);
         return this.getBoundsAtSize(width,height,m).y + (Boolean(m) ? 0 : this.y);
      }
      
      override public function getLayoutBoundsX(postLayoutTransform:Boolean = true) : Number
      {
         var naturalBounds:Rectangle = null;
         var sx:Number = NaN;
         var m:Matrix = getComplexMatrix(postLayoutTransform);
         if(!m && !stroke)
         {
            if(measuredX == 0)
            {
               return this.x;
            }
            naturalBounds = this.getBounds();
            sx = naturalBounds.width == 0 || _width == 0 ? 1 : _width / naturalBounds.width;
            return this.x + measuredX * sx;
         }
         return this.getBoundingBoxWithStroke(_width,_height,m).x + (Boolean(m) ? 0 : this.x);
      }
      
      override public function getLayoutBoundsY(postLayoutTransform:Boolean = true) : Number
      {
         var naturalBounds:Rectangle = null;
         var sy:Number = NaN;
         var m:Matrix = getComplexMatrix(postLayoutTransform);
         if(!m && !stroke)
         {
            if(measuredY == 0)
            {
               return this.y;
            }
            naturalBounds = this.getBounds();
            sy = naturalBounds.height == 0 || _height == 0 ? 1 : _height / naturalBounds.height;
            return this.y + measuredY * sy;
         }
         return this.getBoundingBoxWithStroke(_width,_height,m).y + (Boolean(m) ? 0 : this.y);
      }
      
      private function setLayoutBoundsTransformed(width:Number, height:Number, m:Matrix) : void
      {
         var size1:Point = null;
         var size2:Point = null;
         var n:Point = null;
         var pickSize1:Boolean = false;
         var size:Point = this.fitLayoutBoundsIterative(width,height,m);
         if(!size && !isNaN(width) && !isNaN(height))
         {
            size1 = this.fitLayoutBoundsIterative(NaN,height,m);
            size2 = this.fitLayoutBoundsIterative(width,NaN,m);
            if(Boolean(size1) && this.getBoundingBoxWithStroke(size1.x,size1.y,m).width > width)
            {
               size1 = null;
            }
            if(Boolean(size2) && this.getBoundingBoxWithStroke(size2.x,size2.y,m).height > height)
            {
               size2 = null;
            }
            if(Boolean(size1) && Boolean(size2))
            {
               n = this.getBounds().size;
               pickSize1 = Math.abs(n.x * size1.y - n.y * size1.x) * size2.y < Math.abs(n.x * size2.y - n.y * size2.x) * size1.y;
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
         var transformedBounds:Rectangle = null;
         var widthDistance:Number = NaN;
         var heightDistance:Number = NaN;
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
            transformedBounds = this.getBoundingBoxWithStroke(newWidth,newHeight,m);
            widthDistance = isNaN(width) ? 0 : width - transformedBounds.width;
            heightDistance = isNaN(height) ? 0 : height - transformedBounds.height;
            if(Math.abs(widthDistance) < 0.1 && Math.abs(heightDistance) < 0.1)
            {
               return new Point(newWidth,newHeight);
            }
            fitWidth += widthDistance * 0.5;
            fitHeight += heightDistance * 0.5;
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
      
      override public function setLayoutBoundsSize(width:Number, height:Number, postLayoutTransform:Boolean = true) : void
      {
         var bestWidth:Number = NaN;
         var bestHeight:Number = NaN;
         var bestScore:Number = NaN;
         var size:Point = null;
         var boundsWithStroke:Rectangle = null;
         var widthProximity:Number = NaN;
         var heightProximity:Number = NaN;
         var boundsWithoutStroke:Rectangle = null;
         var strokeWidth:Number = NaN;
         var strokeHeight:Number = NaN;
         var score:Number = NaN;
         if(isNaN(width) && isNaN(height))
         {
            super.setLayoutBoundsSize(width,height,postLayoutTransform);
            return;
         }
         var m:Matrix = getComplexMatrix(postLayoutTransform);
         if(Boolean(m))
         {
            this.setLayoutBoundsTransformed(width,height,m);
            return;
         }
         if(!stroke || stroke.joints != "miter")
         {
            super.setLayoutBoundsSize(width,height,postLayoutTransform);
            return;
         }
         var newWidth:Number = preferredWidthPreTransform();
         var newHeight:Number = preferredHeightPreTransform();
         if(!isNaN(width) && !isNaN(height))
         {
            size = this.fitLayoutBoundsIterative(width,height,new Matrix());
            if(Boolean(size))
            {
               setActualSize(size.x,size.y);
               return;
            }
            newWidth = this.getBounds().width;
            newHeight = this.getBounds().height;
            bestWidth = this.minWidth;
            bestHeight = this.minHeight;
            bestScore = (width - bestWidth) * (width - bestWidth) + (height - bestHeight) * (height - bestHeight);
         }
         var i:int = 0;
         while(i++ < 150)
         {
            boundsWithStroke = this.getBoundingBoxWithStroke(newWidth,newHeight,null);
            widthProximity = 0;
            heightProximity = 0;
            if(!isNaN(width))
            {
               widthProximity = Math.abs(width - boundsWithStroke.width);
            }
            if(!isNaN(height))
            {
               heightProximity = Math.abs(height - boundsWithStroke.height);
            }
            if(!isNaN(width) && !isNaN(height))
            {
               score = (width - boundsWithStroke.width) * (width - boundsWithStroke.width) + (height - boundsWithStroke.height) * (height - boundsWithStroke.height);
               if(!isNaN(score) && score < bestScore && boundsWithStroke.width <= width && boundsWithStroke.height <= height)
               {
                  bestScore = score;
                  bestWidth = newWidth;
                  bestHeight = newHeight;
               }
            }
            if(widthProximity < 0.00001 && heightProximity < 0.00001)
            {
               setActualSize(newWidth,newHeight);
               return;
            }
            boundsWithoutStroke = this.segments.getBoundingBox(newWidth,newHeight,null);
            strokeWidth = boundsWithStroke.width - boundsWithoutStroke.width;
            strokeHeight = boundsWithStroke.height - boundsWithoutStroke.height;
            if(!isNaN(width))
            {
               newWidth = width - strokeWidth;
            }
            if(!isNaN(height))
            {
               newHeight = height - strokeHeight;
            }
         }
         setActualSize(bestWidth,bestHeight);
      }
      
      override protected function beginDraw(g:Graphics) : void
      {
         var strokeBounds:Rectangle = null;
         var naturalBounds:Rectangle = this.getBounds();
         var sx:Number = naturalBounds.width == 0 ? 1 : width / naturalBounds.width;
         var sy:Number = naturalBounds.height == 0 ? 1 : height / naturalBounds.height;
         var origin:Point = new Point(drawX,drawY);
         var bounds:Rectangle = new Rectangle(drawX + measuredX * sx,drawY + measuredY * sy,width,height);
         if(Boolean(stroke))
         {
            strokeBounds = this.getStrokeBounds();
            strokeBounds.offsetPoint(origin);
            stroke.apply(g,strokeBounds,origin);
         }
         else
         {
            g.lineStyle();
         }
         if(Boolean(fill))
         {
            fill.begin(g,bounds,origin);
         }
      }
      
      override protected function draw(g:Graphics) : void
      {
         var rcBounds:Rectangle = null;
         var sx:Number = NaN;
         var sy:Number = NaN;
         if(drawX != this._drawBounds.x || drawY != this._drawBounds.y || width != this._drawBounds.width || height != this._drawBounds.height)
         {
            this.graphicsPathChanged = true;
            this._drawBounds.x = drawX;
            this._drawBounds.y = drawY;
            this._drawBounds.width = width;
            this._drawBounds.height = height;
         }
         if(this.graphicsPathChanged)
         {
            rcBounds = this.getBounds();
            sx = rcBounds.width == 0 ? 1 : width / rcBounds.width;
            sy = rcBounds.height == 0 ? 1 : height / rcBounds.height;
            if(Boolean(this.segments))
            {
               this.segments.generateGraphicsPath(this.graphicsPath,drawX,drawY,sx,sy);
            }
            this.graphicsPathChanged = false;
         }
         g.drawPath(this.graphicsPath.commands,this.graphicsPath.data,this.winding);
      }
      
      override protected function endDraw(g:Graphics) : void
      {
         g.lineStyle();
         super.endDraw(g);
      }
      
      override protected function invalidateDisplayObjectSharing() : void
      {
         this.graphicsPathChanged = true;
         super.invalidateDisplayObjectSharing();
      }
      
      private function clearCachedBoundingBoxWithStroke() : void
      {
         this._boundingBoxCached = null;
         this._boundingBoxMatrixCached = null;
      }
      
      override protected function stroke_propertyChangeHandler(event:PropertyChangeEvent) : void
      {
         super.stroke_propertyChangeHandler(event);
         switch(event.property)
         {
            case "weight":
            case "scaleMode":
            case "joints":
            case "miterLimit":
               this.clearCachedBoundingBoxWithStroke();
               invalidateParentSizeAndDisplayList();
         }
      }
      
      override public function set stroke(value:IStroke) : void
      {
         super.stroke = value;
         this.clearCachedBoundingBoxWithStroke();
      }
   }
}

import flash.display.GraphicsPath;
import flash.geom.Matrix;
import flash.geom.Point;
import flash.geom.Rectangle;
import mx.utils.MatrixUtil;

class PathSegmentsCollection
{
   
   private var _segments:Vector.<PathSegment>;
   
   private var _bounds:Rectangle;
   
   private var _charPos:int = 0;
   
   private var _dataLength:int = 0;
   
   public function PathSegmentsCollection(value:String)
   {
      var newSegments:Vector.<PathSegment> = null;
      var c:Number = NaN;
      var useRelative:Boolean = false;
      var x:Number = NaN;
      var y:Number = NaN;
      var controlX:Number = NaN;
      var controlY:Number = NaN;
      var control2X:Number = NaN;
      var control2Y:Number = NaN;
      var curSegmentIndex:int = 0;
      super();
      if(!value)
      {
         this._segments = new Vector.<PathSegment>();
         return;
      }
      newSegments = new Vector.<PathSegment>();
      var charCount:int = value.length;
      var prevIdentifier:Number = 0;
      var prevX:Number = 0;
      var prevY:Number = 0;
      var lastMoveX:Number = 0;
      var lastMoveY:Number = 0;
      var lastMoveSegmentIndex:int = -1;
      this._dataLength = charCount;
      this._charPos = 0;
      while(true)
      {
         this.skipWhiteSpace(value);
         if(this._charPos >= charCount)
         {
            break;
         }
         c = value.charCodeAt(this._charPos++);
         if(c >= 48 && c < 58 || (c == 43 || c == 45) || c == 46)
         {
            c = prevIdentifier;
            --this._charPos;
         }
         else if(c >= 65 && c <= 86)
         {
            useRelative = false;
         }
         else if(c >= 97 && c <= 122)
         {
            useRelative = true;
         }
         switch(c)
         {
            case 99:
            case 67:
               controlX = Number(this.getNumber(useRelative,prevX,value));
               controlY = Number(this.getNumber(useRelative,prevY,value));
               control2X = Number(this.getNumber(useRelative,prevX,value));
               control2Y = Number(this.getNumber(useRelative,prevY,value));
               x = Number(this.getNumber(useRelative,prevX,value));
               y = Number(this.getNumber(useRelative,prevY,value));
               newSegments.push(new CubicBezierSegment(controlX,controlY,control2X,control2Y,x,y));
               prevX = x;
               prevY = y;
               prevIdentifier = 99;
               break;
            case 109:
            case 77:
               x = Number(this.getNumber(useRelative,prevX,value));
               y = Number(this.getNumber(useRelative,prevY,value));
               newSegments.push(new MoveSegment(x,y));
               prevX = x;
               prevY = y;
               prevIdentifier = c == 109 ? 108 : 76;
               curSegmentIndex = newSegments.length - 1;
               if(lastMoveSegmentIndex + 2 == curSegmentIndex && newSegments[lastMoveSegmentIndex + 1] is QuadraticBezierSegment)
               {
                  newSegments.splice(lastMoveSegmentIndex + 1,0,new LineSegment(lastMoveX,lastMoveY));
                  curSegmentIndex++;
               }
               lastMoveSegmentIndex = curSegmentIndex;
               lastMoveX = x;
               lastMoveY = y;
               break;
            case 108:
            case 76:
               x = Number(this.getNumber(useRelative,prevX,value));
               y = Number(this.getNumber(useRelative,prevY,value));
               newSegments.push(new LineSegment(x,y));
               prevX = x;
               prevY = y;
               prevIdentifier = 108;
               break;
            case 104:
            case 72:
               x = Number(this.getNumber(useRelative,prevX,value));
               y = prevY;
               newSegments.push(new LineSegment(x,y));
               prevX = x;
               prevY = y;
               prevIdentifier = 104;
               break;
            case 118:
            case 86:
               x = prevX;
               y = Number(this.getNumber(useRelative,prevY,value));
               newSegments.push(new LineSegment(x,y));
               prevX = x;
               prevY = y;
               prevIdentifier = 118;
               break;
            case 113:
            case 81:
               controlX = Number(this.getNumber(useRelative,prevX,value));
               controlY = Number(this.getNumber(useRelative,prevY,value));
               x = Number(this.getNumber(useRelative,prevX,value));
               y = Number(this.getNumber(useRelative,prevY,value));
               newSegments.push(new QuadraticBezierSegment(controlX,controlY,x,y));
               prevX = x;
               prevY = y;
               prevIdentifier = 113;
               break;
            case 116:
            case 84:
               if(prevIdentifier == 116 || prevIdentifier == 113)
               {
                  controlX = prevX + (prevX - controlX);
                  controlY = prevY + (prevY - controlY);
               }
               else
               {
                  controlX = prevX;
                  controlY = prevY;
               }
               x = Number(this.getNumber(useRelative,prevX,value));
               y = Number(this.getNumber(useRelative,prevY,value));
               newSegments.push(new QuadraticBezierSegment(controlX,controlY,x,y));
               prevX = x;
               prevY = y;
               prevIdentifier = 116;
               break;
            case 115:
            case 83:
               if(prevIdentifier == 115 || prevIdentifier == 99)
               {
                  controlX = prevX + (prevX - control2X);
                  controlY = prevY + (prevY - control2Y);
               }
               else
               {
                  controlX = prevX;
                  controlY = prevY;
               }
               control2X = Number(this.getNumber(useRelative,prevX,value));
               control2Y = Number(this.getNumber(useRelative,prevY,value));
               x = Number(this.getNumber(useRelative,prevX,value));
               y = Number(this.getNumber(useRelative,prevY,value));
               newSegments.push(new CubicBezierSegment(controlX,controlY,control2X,control2Y,x,y));
               prevX = x;
               prevY = y;
               prevIdentifier = 115;
               break;
            case 122:
            case 90:
               x = lastMoveX;
               y = lastMoveY;
               newSegments.push(new LineSegment(x,y));
               prevX = x;
               prevY = y;
               prevIdentifier = 122;
               break;
            default:
               this._segments = new Vector.<PathSegment>();
               return;
         }
      }
      curSegmentIndex = int(newSegments.length);
      if(lastMoveSegmentIndex + 2 == curSegmentIndex && newSegments[lastMoveSegmentIndex + 1] is QuadraticBezierSegment)
      {
         newSegments.splice(lastMoveSegmentIndex + 1,0,new LineSegment(lastMoveX,lastMoveY));
         curSegmentIndex++;
      }
      this._segments = newSegments;
   }
   
   public function get data() : Vector.<PathSegment>
   {
      return this._segments;
   }
   
   public function getBounds() : Rectangle
   {
      if(Boolean(this._bounds))
      {
         return this._bounds;
      }
      this._bounds = new Rectangle(0,0,1,1);
      this._bounds = this.getBoundingBox(1,1,null);
      return this._bounds;
   }
   
   public function getBoundingBox(width:Number, height:Number, m:Matrix) : Rectangle
   {
      var prevSegment:PathSegment = null;
      var pathBBox:Rectangle = null;
      var segment:PathSegment = null;
      var x:Number = NaN;
      var y:Number = NaN;
      var naturalBounds:Rectangle = this.getBounds();
      var sx:Number = naturalBounds.width == 0 ? 1 : width / naturalBounds.width;
      var sy:Number = naturalBounds.height == 0 ? 1 : height / naturalBounds.height;
      var count:int = int(this._segments.length);
      for(var i:int = 0; i < count; i++)
      {
         segment = this._segments[i];
         pathBBox = segment.getBoundingBox(prevSegment,sx,sy,m,pathBBox);
         prevSegment = segment;
      }
      if(!pathBBox)
      {
         x = Boolean(m) ? m.tx : 0;
         y = Boolean(m) ? m.ty : 0;
         pathBBox = new Rectangle(x,y);
      }
      return pathBBox;
   }
   
   public function generateGraphicsPath(graphicsPath:GraphicsPath, tx:Number, ty:Number, sx:Number, sy:Number) : void
   {
      var curSegment:PathSegment = null;
      var prevSegment:PathSegment = null;
      graphicsPath.commands = null;
      graphicsPath.data = null;
      graphicsPath.moveTo(tx,ty);
      var count:int = int(this._segments.length);
      for(var i:int = 0; i < count; i++)
      {
         prevSegment = curSegment;
         curSegment = this._segments[i];
         curSegment.draw(graphicsPath,tx,ty,sx,sy,prevSegment);
      }
   }
   
   private function skipWhiteSpace(data:String) : void
   {
      var c:Number = NaN;
      while(this._charPos < this._dataLength)
      {
         c = data.charCodeAt(this._charPos);
         if(c != 32 && c != 44 && c != 13 && c != 9 && c != 10)
         {
            break;
         }
         ++this._charPos;
      }
   }
   
   private function getNumber(useRelative:Boolean, offset:Number, value:String) : Number
   {
      var digitStart:int = 0;
      this.skipWhiteSpace(value);
      if(this._charPos >= this._dataLength)
      {
         return NaN;
      }
      var numberStart:int = int(this._charPos);
      var hasSignCharacter:Boolean = false;
      var hasDigits:Boolean = false;
      var c:Number = value.charCodeAt(this._charPos);
      if(c == 43 || c == 45)
      {
         hasSignCharacter = true;
         ++this._charPos;
      }
      var dotIndex:int = -1;
      while(this._charPos < this._dataLength)
      {
         c = value.charCodeAt(this._charPos);
         if(c >= 48 && c < 58)
         {
            hasDigits = true;
         }
         else
         {
            if(!(c == 46 && dotIndex == -1))
            {
               break;
            }
            dotIndex = int(this._charPos);
         }
         ++this._charPos;
      }
      if(!hasDigits)
      {
         this._charPos = this._dataLength;
         return NaN;
      }
      if(c == 46)
      {
         --this._charPos;
      }
      var numberEnd:int = int(this._charPos);
      if(c == 69 || c == 101)
      {
         ++this._charPos;
         if(this._charPos < this._dataLength)
         {
            c = value.charCodeAt(this._charPos);
            if(c == 43 || c == 45)
            {
               ++this._charPos;
            }
         }
         digitStart = int(this._charPos);
         while(this._charPos < this._dataLength)
         {
            c = value.charCodeAt(this._charPos);
            if(!(c >= 48 && c < 58))
            {
               break;
            }
            ++this._charPos;
         }
         if(digitStart < this._charPos)
         {
            numberEnd = int(this._charPos);
         }
         else
         {
            this._charPos = numberEnd;
         }
      }
      var subString:String = value.substr(numberStart,numberEnd - numberStart);
      var result:Number = parseFloat(subString);
      if(isNaN(result))
      {
         this._charPos = this._dataLength;
         return NaN;
      }
      this._charPos = numberEnd;
      return useRelative ? result + offset : result;
   }
}

class PathSegment
{
   
   public var x:Number = 0;
   
   public var y:Number = 0;
   
   public function PathSegment(_x:Number = 0, _y:Number = 0)
   {
      super();
      this.x = _x;
      this.y = _y;
   }
   
   public function draw(graphicsPath:GraphicsPath, dx:Number, dy:Number, sx:Number, sy:Number, prev:PathSegment) : void
   {
   }
   
   public function getBoundingBox(prev:PathSegment, sx:Number, sy:Number, m:Matrix, rect:Rectangle) : Rectangle
   {
      return rect;
   }
   
   public function getTangent(prev:PathSegment, start:Boolean, sx:Number, sy:Number, m:Matrix, result:Point) : void
   {
      result.x = 0;
      result.y = 0;
   }
}

class LineSegment extends PathSegment
{
   
   public function LineSegment(x:Number = 0, y:Number = 0)
   {
      super(x,y);
   }
   
   override public function draw(graphicsPath:GraphicsPath, dx:Number, dy:Number, sx:Number, sy:Number, prev:PathSegment) : void
   {
      graphicsPath.lineTo(dx + x * sx,dy + y * sy);
   }
   
   override public function getBoundingBox(prev:PathSegment, sx:Number, sy:Number, m:Matrix, rect:Rectangle) : Rectangle
   {
      var pt:Point = null;
      pt = MatrixUtil.transformPoint(x * sx,y * sy,m);
      var x1:Number = pt.x;
      var y1:Number = pt.y;
      if(prev != null && !(prev is MoveSegment))
      {
         return MatrixUtil.rectUnion(x1,y1,x1,y1,rect);
      }
      pt = MatrixUtil.transformPoint(Boolean(prev) ? prev.x * sx : 0,Boolean(prev) ? prev.y * sy : 0,m);
      var x2:Number = pt.x;
      var y2:Number = pt.y;
      return MatrixUtil.rectUnion(Math.min(x1,x2),Math.min(y1,y2),Math.max(x1,x2),Math.max(y1,y2),rect);
   }
   
   override public function getTangent(prev:PathSegment, start:Boolean, sx:Number, sy:Number, m:Matrix, result:Point) : void
   {
      var pt0:Point = MatrixUtil.transformPoint(Boolean(prev) ? prev.x * sx : 0,Boolean(prev) ? prev.y * sy : 0,m).clone();
      var pt1:Point = MatrixUtil.transformPoint(x * sx,y * sy,m);
      result.x = pt1.x - pt0.x;
      result.y = pt1.y - pt0.y;
   }
}

class MoveSegment extends PathSegment
{
   
   public function MoveSegment(x:Number = 0, y:Number = 0)
   {
      super(x,y);
   }
   
   override public function draw(graphicsPath:GraphicsPath, dx:Number, dy:Number, sx:Number, sy:Number, prev:PathSegment) : void
   {
      graphicsPath.moveTo(dx + x * sx,dy + y * sy);
   }
}

class CubicBezierSegment extends PathSegment
{
   
   private var _qPts:QuadraticPoints;
   
   public var control1X:Number = 0;
   
   public var control1Y:Number = 0;
   
   public var control2X:Number = 0;
   
   public var control2Y:Number = 0;
   
   public function CubicBezierSegment(_control1X:Number = 0, _control1Y:Number = 0, _control2X:Number = 0, _control2Y:Number = 0, x:Number = 0, y:Number = 0)
   {
      super(x,y);
      this.control1X = _control1X;
      this.control1Y = _control1Y;
      this.control2X = _control2X;
      this.control2Y = _control2Y;
   }
   
   override public function draw(graphicsPath:GraphicsPath, dx:Number, dy:Number, sx:Number, sy:Number, prev:PathSegment) : void
   {
      var qPts:QuadraticPoints = this.getQuadraticPoints(prev);
      graphicsPath.curveTo(dx + qPts.control1.x * sx,dy + qPts.control1.y * sy,dx + qPts.anchor1.x * sx,dy + qPts.anchor1.y * sy);
      graphicsPath.curveTo(dx + qPts.control2.x * sx,dy + qPts.control2.y * sy,dx + qPts.anchor2.x * sx,dy + qPts.anchor2.y * sy);
      graphicsPath.curveTo(dx + qPts.control3.x * sx,dy + qPts.control3.y * sy,dx + qPts.anchor3.x * sx,dy + qPts.anchor3.y * sy);
      graphicsPath.curveTo(dx + qPts.control4.x * sx,dy + qPts.control4.y * sy,dx + qPts.anchor4.x * sx,dy + qPts.anchor4.y * sy);
   }
   
   override public function getBoundingBox(prev:PathSegment, sx:Number, sy:Number, m:Matrix, rect:Rectangle) : Rectangle
   {
      var qPts:QuadraticPoints = this.getQuadraticPoints(prev);
      rect = MatrixUtil.getQBezierSegmentBBox(Boolean(prev) ? prev.x : 0,Boolean(prev) ? prev.y : 0,qPts.control1.x,qPts.control1.y,qPts.anchor1.x,qPts.anchor1.y,sx,sy,m,rect);
      rect = MatrixUtil.getQBezierSegmentBBox(qPts.anchor1.x,qPts.anchor1.y,qPts.control2.x,qPts.control2.y,qPts.anchor2.x,qPts.anchor2.y,sx,sy,m,rect);
      rect = MatrixUtil.getQBezierSegmentBBox(qPts.anchor2.x,qPts.anchor2.y,qPts.control3.x,qPts.control3.y,qPts.anchor3.x,qPts.anchor3.y,sx,sy,m,rect);
      return MatrixUtil.getQBezierSegmentBBox(qPts.anchor3.x,qPts.anchor3.y,qPts.control4.x,qPts.control4.y,qPts.anchor4.x,qPts.anchor4.y,sx,sy,m,rect);
   }
   
   override public function getTangent(prev:PathSegment, start:Boolean, sx:Number, sy:Number, m:Matrix, result:Point) : void
   {
      var qPts:QuadraticPoints = this.getQuadraticPoints(prev);
      var pt0:Point = MatrixUtil.transformPoint(Boolean(prev) ? prev.x * sx : 0,Boolean(prev) ? prev.y * sy : 0,m).clone();
      var pt1:Point = MatrixUtil.transformPoint(qPts.control1.x * sx,qPts.control1.y * sy,m).clone();
      var pt2:Point = MatrixUtil.transformPoint(qPts.anchor1.x * sx,qPts.anchor1.y * sy,m).clone();
      var pt3:Point = MatrixUtil.transformPoint(qPts.control2.x * sx,qPts.control2.y * sy,m).clone();
      var pt4:Point = MatrixUtil.transformPoint(qPts.anchor2.x * sx,qPts.anchor2.y * sy,m).clone();
      var pt5:Point = MatrixUtil.transformPoint(qPts.control3.x * sx,qPts.control3.y * sy,m).clone();
      var pt6:Point = MatrixUtil.transformPoint(qPts.anchor3.x * sx,qPts.anchor3.y * sy,m).clone();
      var pt7:Point = MatrixUtil.transformPoint(qPts.control4.x * sx,qPts.control4.y * sy,m).clone();
      var pt8:Point = MatrixUtil.transformPoint(qPts.anchor4.x * sx,qPts.anchor4.y * sy,m).clone();
      if(start)
      {
         QuadraticBezierSegment.getQTangent(pt0.x,pt0.y,pt1.x,pt1.y,pt2.x,pt2.y,start,result);
         if(result.x == 0 && result.y == 0)
         {
            QuadraticBezierSegment.getQTangent(pt0.x,pt0.y,pt3.x,pt3.y,pt4.x,pt4.y,start,result);
            if(result.x == 0 && result.y == 0)
            {
               QuadraticBezierSegment.getQTangent(pt0.x,pt0.y,pt5.x,pt5.y,pt6.x,pt6.y,start,result);
               if(result.x == 0 && result.y == 0)
               {
                  QuadraticBezierSegment.getQTangent(pt0.x,pt0.y,pt7.x,pt7.y,pt8.x,pt8.y,start,result);
               }
            }
         }
      }
      else
      {
         QuadraticBezierSegment.getQTangent(pt6.x,pt6.y,pt7.x,pt7.y,pt8.x,pt8.y,start,result);
         if(result.x == 0 && result.y == 0)
         {
            QuadraticBezierSegment.getQTangent(pt4.x,pt4.y,pt5.x,pt5.y,pt8.x,pt8.y,start,result);
            if(result.x == 0 && result.y == 0)
            {
               QuadraticBezierSegment.getQTangent(pt2.x,pt2.y,pt3.x,pt3.y,pt8.x,pt8.y,start,result);
               if(result.x == 0 && result.y == 0)
               {
                  QuadraticBezierSegment.getQTangent(pt0.x,pt0.y,pt1.x,pt1.y,pt8.x,pt8.y,start,result);
               }
            }
         }
      }
   }
   
   private function getQuadraticPoints(prev:PathSegment) : QuadraticPoints
   {
      if(Boolean(this._qPts))
      {
         return this._qPts;
      }
      var p1:Point = new Point(Boolean(prev) ? prev.x : 0,Boolean(prev) ? prev.y : 0);
      var p2:Point = new Point(x,y);
      var c1:Point = new Point(this.control1X,this.control1Y);
      var c2:Point = new Point(this.control2X,this.control2Y);
      var PA:Point = Point.interpolate(c1,p1,3 / 4);
      var PB:Point = Point.interpolate(c2,p2,3 / 4);
      var dx:Number = (p2.x - p1.x) / 16;
      var dy:Number = (p2.y - p1.y) / 16;
      this._qPts = new QuadraticPoints();
      this._qPts.control1 = Point.interpolate(c1,p1,3 / 8);
      this._qPts.control2 = Point.interpolate(PB,PA,3 / 8);
      this._qPts.control2.x -= dx;
      this._qPts.control2.y -= dy;
      this._qPts.control3 = Point.interpolate(PA,PB,3 / 8);
      this._qPts.control3.x += dx;
      this._qPts.control3.y += dy;
      this._qPts.control4 = Point.interpolate(c2,p2,3 / 8);
      this._qPts.anchor1 = Point.interpolate(this._qPts.control1,this._qPts.control2,0.5);
      this._qPts.anchor2 = Point.interpolate(PA,PB,0.5);
      this._qPts.anchor3 = Point.interpolate(this._qPts.control3,this._qPts.control4,0.5);
      this._qPts.anchor4 = p2;
      return this._qPts;
   }
}

class QuadraticPoints
{
   
   public var control1:Point;
   
   public var anchor1:Point;
   
   public var control2:Point;
   
   public var anchor2:Point;
   
   public var control3:Point;
   
   public var anchor3:Point;
   
   public var control4:Point;
   
   public var anchor4:Point;
   
   public function QuadraticPoints()
   {
      super();
   }
}

class QuadraticBezierSegment extends PathSegment
{
   
   public var control1X:Number = 0;
   
   public var control1Y:Number = 0;
   
   public function QuadraticBezierSegment(_control1X:Number = 0, _control1Y:Number = 0, x:Number = 0, y:Number = 0)
   {
      super(x,y);
      this.control1X = _control1X;
      this.control1Y = _control1Y;
   }
   
   public static function getQTangent(x0:Number, y0:Number, x1:Number, y1:Number, x2:Number, y2:Number, start:Boolean, result:Point) : void
   {
      if(start)
      {
         if(x0 == x1 && y0 == y1)
         {
            result.x = x2 - x0;
            result.y = y2 - y0;
         }
         else
         {
            result.x = x1 - x0;
            result.y = y1 - y0;
         }
      }
      else if(x2 == x1 && y2 == y1)
      {
         result.x = x2 - x0;
         result.y = y2 - y0;
      }
      else
      {
         result.x = x2 - x1;
         result.y = y2 - y1;
      }
   }
   
   override public function draw(graphicsPath:GraphicsPath, dx:Number, dy:Number, sx:Number, sy:Number, prev:PathSegment) : void
   {
      graphicsPath.curveTo(dx + this.control1X * sx,dy + this.control1Y * sy,dx + x * sx,dy + y * sy);
   }
   
   override public function getTangent(prev:PathSegment, start:Boolean, sx:Number, sy:Number, m:Matrix, result:Point) : void
   {
      var pt0:Point = MatrixUtil.transformPoint(Boolean(prev) ? prev.x * sx : 0,Boolean(prev) ? prev.y * sy : 0,m).clone();
      var pt1:Point = MatrixUtil.transformPoint(this.control1X * sx,this.control1Y * sy,m).clone();
      var pt2:Point = MatrixUtil.transformPoint(x * sx,y * sy,m).clone();
      getQTangent(pt0.x,pt0.y,pt1.x,pt1.y,pt2.x,pt2.y,start,result);
   }
   
   override public function getBoundingBox(prev:PathSegment, sx:Number, sy:Number, m:Matrix, rect:Rectangle) : Rectangle
   {
      return MatrixUtil.getQBezierSegmentBBox(Boolean(prev) ? prev.x : 0,Boolean(prev) ? prev.y : 0,this.control1X,this.control1Y,x,y,sx,sy,m,rect);
   }
}
