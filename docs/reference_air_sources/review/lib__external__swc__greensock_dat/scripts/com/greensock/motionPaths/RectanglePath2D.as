package com.greensock.motionPaths
{
   import flash.display.Graphics;
   import flash.events.Event;
   import flash.geom.Matrix;
   
   public class RectanglePath2D extends MotionPath
   {
      
      protected var _centerOrigin:Boolean;
      
      protected var _rawHeight:Number;
      
      protected var _rawWidth:Number;
      
      public function RectanglePath2D(x:Number, y:Number, rawWidth:Number, rawHeight:Number, centerOrigin:Boolean = false)
      {
         super();
         _rawWidth = rawWidth;
         _rawHeight = rawHeight;
         _centerOrigin = centerOrigin;
         super.x = x;
         super.y = y;
      }
      
      public function set rawHeight(value:Number) : void
      {
         _rawHeight = value;
         _redrawLine = true;
         update();
      }
      
      override public function renderObjectAt(target:Object, progress:Number, autoRotate:Boolean = false, rotationOffset:Number = 0) : void
      {
         var length:Number = NaN;
         var xFactor:Number = NaN;
         var yFactor:Number = NaN;
         if(progress > 1)
         {
            progress -= int(progress);
         }
         else if(progress < 0)
         {
            progress -= int(progress) - 1;
         }
         var px:Number = _centerOrigin ? _rawWidth / -2 : 0;
         var py:Number = _centerOrigin ? _rawHeight / -2 : 0;
         if(progress < 0.5)
         {
            length = progress * (_rawWidth + _rawHeight) * 2;
            if(length > _rawWidth)
            {
               px += _rawWidth;
               py += length - _rawWidth;
               xFactor = 0;
               yFactor = _rawHeight;
            }
            else
            {
               px += length;
               xFactor = _rawWidth;
               yFactor = 0;
            }
         }
         else
         {
            length = (progress - 0.5) / 0.5 * (_rawWidth + _rawHeight);
            if(length <= _rawWidth)
            {
               px += _rawWidth - length;
               py += _rawHeight;
               xFactor = -_rawWidth;
               yFactor = 0;
            }
            else
            {
               py += _rawHeight - (length - _rawWidth);
               xFactor = 0;
               yFactor = -_rawHeight;
            }
         }
         var m:Matrix = this.transform.matrix;
         target.x = px * m.a + py * m.c + m.tx;
         target.y = px * m.b + py * m.d + m.ty;
         if(autoRotate)
         {
            target.rotation = Math.atan2(xFactor * m.b + yFactor * m.d,xFactor * m.a + yFactor * m.c) * _RAD2DEG + rotationOffset;
         }
      }
      
      override public function update(event:Event = null) : void
      {
         var length:Number = NaN;
         var px:Number = NaN;
         var py:Number = NaN;
         var xFactor:Number = NaN;
         var yFactor:Number = NaN;
         var g:Graphics = null;
         var xOffset:Number = _centerOrigin ? _rawWidth / -2 : 0;
         var yOffset:Number = _centerOrigin ? _rawHeight / -2 : 0;
         var m:Matrix = this.transform.matrix;
         var a:Number = m.a;
         var b:Number = m.b;
         var c:Number = m.c;
         var d:Number = m.d;
         var tx:Number = m.tx;
         var ty:Number = m.ty;
         var f:PathFollower = _rootFollower;
         while(Boolean(f))
         {
            px = xOffset;
            py = yOffset;
            if(f.cachedProgress < 0.5)
            {
               length = f.cachedProgress * (_rawWidth + _rawHeight) * 2;
               if(length > _rawWidth)
               {
                  px += _rawWidth;
                  py += length - _rawWidth;
                  xFactor = 0;
                  yFactor = _rawHeight;
               }
               else
               {
                  px += length;
                  xFactor = _rawWidth;
                  yFactor = 0;
               }
            }
            else
            {
               length = (f.cachedProgress - 0.5) / 0.5 * (_rawWidth + _rawHeight);
               if(length <= _rawWidth)
               {
                  px += _rawWidth - length;
                  py += _rawHeight;
                  xFactor = -_rawWidth;
                  yFactor = 0;
               }
               else
               {
                  py += _rawHeight - (length - _rawWidth);
                  xFactor = 0;
                  yFactor = -_rawHeight;
               }
            }
            f.target.x = px * a + py * c + tx;
            f.target.y = px * b + py * d + ty;
            if(f.autoRotate)
            {
               f.target.rotation = Math.atan2(xFactor * b + yFactor * d,xFactor * a + yFactor * c) * _RAD2DEG + f.rotationOffset;
            }
            f = f.cachedNext;
         }
         if(_redrawLine)
         {
            g = this.graphics;
            g.clear();
            g.lineStyle(_thickness,_color,_lineAlpha,_pixelHinting,_scaleMode,_caps,_joints,_miterLimit);
            g.drawRect(xOffset,yOffset,_rawWidth,_rawHeight);
            _redrawLine = false;
         }
      }
      
      public function get rawHeight() : Number
      {
         return _rawHeight;
      }
      
      public function set centerOrigin(value:Boolean) : void
      {
         _centerOrigin;
         _redrawLine = true;
         update();
      }
      
      public function get centerOrigin() : Boolean
      {
         return _centerOrigin;
      }
      
      public function set rawWidth(value:Number) : void
      {
         _rawWidth = value;
         _redrawLine = true;
         update();
      }
      
      public function get rawWidth() : Number
      {
         return _rawWidth;
      }
   }
}

