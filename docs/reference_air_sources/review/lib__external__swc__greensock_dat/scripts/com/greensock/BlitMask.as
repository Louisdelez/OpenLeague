package com.greensock
{
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.Graphics;
   import flash.display.Sprite;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.geom.Transform;
   
   public class BlitMask extends Sprite
   {
      
      public static var version:Number = 0.6;
      
      protected static var _tempContainer:Sprite = new Sprite();
      
      protected static var _sliceRect:Rectangle = new Rectangle();
      
      protected static var _drawRect:Rectangle = new Rectangle();
      
      protected static var _destPoint:Point = new Point();
      
      protected static var _tempMatrix:Matrix = new Matrix();
      
      protected static var _emptyArray:Array = [];
      
      protected static var _colorTransform:ColorTransform = new ColorTransform();
      
      protected static var _mouseEvents:Array = [MouseEvent.CLICK,MouseEvent.DOUBLE_CLICK,MouseEvent.MOUSE_DOWN,MouseEvent.MOUSE_MOVE,MouseEvent.MOUSE_OUT,MouseEvent.MOUSE_OVER,MouseEvent.MOUSE_UP,MouseEvent.MOUSE_WHEEL,MouseEvent.ROLL_OUT,MouseEvent.ROLL_OVER];
      
      protected var _bitmapMode:Boolean;
      
      protected var _columns:int;
      
      protected var _fillColor:uint;
      
      protected var _grid:Array;
      
      protected var _wrap:Boolean;
      
      protected var _target:DisplayObject;
      
      protected var _prevRotation:Number;
      
      protected var _rows:int;
      
      protected var _clipRect:Rectangle;
      
      protected var _wrapOffsetX:Number = 0;
      
      protected var _wrapOffsetY:Number = 0;
      
      protected var _height:Number;
      
      protected var _width:Number;
      
      protected var _gridSize:int = 2879;
      
      protected var _bounds:Rectangle;
      
      protected var _bd:BitmapData;
      
      protected var _scaleX:Number;
      
      protected var _scaleY:Number;
      
      protected var _prevMatrix:Matrix;
      
      protected var _transform:Transform;
      
      protected var _smoothing:Boolean;
      
      protected var _autoUpdate:Boolean;
      
      public function BlitMask(target:DisplayObject, x:Number = 0, y:Number = 0, width:Number = 100, height:Number = 100, smoothing:Boolean = false, autoUpdate:Boolean = false, fillColor:uint = 0, wrap:Boolean = false)
      {
         super();
         if(width < 0 || height < 0)
         {
            throw new Error("A FlexBlitMask cannot have a negative width or height.");
         }
         _width = width;
         _height = height;
         _scaleX = _scaleY = 1;
         _smoothing = smoothing;
         _fillColor = fillColor;
         _autoUpdate = autoUpdate;
         _wrap = wrap;
         _grid = [];
         _bounds = new Rectangle();
         if(_smoothing)
         {
            super.x = x;
            super.y = y;
         }
         else
         {
            super.x = x < 0 ? x - 0.5 >> 0 : x + 0.5 >> 0;
            super.y = y < 0 ? y - 0.5 >> 0 : y + 0.5 >> 0;
         }
         _clipRect = new Rectangle(0,0,_gridSize + 1,_gridSize + 1);
         _bd = new BitmapData(width + 1,height + 1,true,_fillColor);
         _bitmapMode = true;
         this.target = target;
      }
      
      public function disableBitmapMode(event:Event = null) : void
      {
         this.bitmapMode = false;
      }
      
      public function get wrapOffsetX() : Number
      {
         return _wrapOffsetX;
      }
      
      public function setSize(width:Number, height:Number) : void
      {
         if(_width == width && _height == height)
         {
            return;
         }
         if(width < 0 || height < 0)
         {
            throw new Error("A BlitMask cannot have a negative width or height.");
         }
         if(_bd != null)
         {
            _bd.dispose();
         }
         _width = width;
         _height = height;
         _bd = new BitmapData(width + 1,height + 1,true,_fillColor);
         _render();
      }
      
      public function set wrapOffsetY(value:Number) : void
      {
         if(_wrapOffsetY != value)
         {
            _wrapOffsetY = value;
            if(_bitmapMode)
            {
               _render();
            }
         }
      }
      
      override public function set x(value:Number) : void
      {
         if(_smoothing)
         {
            super.x = value;
         }
         else if(value >= 0)
         {
            super.x = value + 0.5 >> 0;
         }
         else
         {
            super.x = value - 0.5 >> 0;
         }
         if(_bitmapMode)
         {
            _render();
         }
      }
      
      override public function set y(value:Number) : void
      {
         if(_smoothing)
         {
            super.y = value;
         }
         else if(value >= 0)
         {
            super.y = value + 0.5 >> 0;
         }
         else
         {
            super.y = value - 0.5 >> 0;
         }
         if(_bitmapMode)
         {
            _render();
         }
      }
      
      public function get wrapOffsetY() : Number
      {
         return _wrapOffsetY;
      }
      
      public function set wrap(value:Boolean) : void
      {
         if(_wrap != value)
         {
            _wrap = value;
            if(_bitmapMode)
            {
               _render();
            }
         }
      }
      
      public function get smoothing() : Boolean
      {
         return _smoothing;
      }
      
      public function get target() : DisplayObject
      {
         return _target;
      }
      
      override public function set width(value:Number) : void
      {
         setSize(value,_height);
      }
      
      override public function set scaleX(value:Number) : void
      {
         var oldScaleX:Number = _scaleX;
         _scaleX = value;
         setSize(_width * (_scaleX / oldScaleX),_height);
      }
      
      public function dispose() : void
      {
         if(_bd == null)
         {
            return;
         }
         _disposeGrid();
         _bd.dispose();
         _bd = null;
         this.bitmapMode = false;
         this.autoUpdate = false;
         if(_target != null)
         {
            _target.mask = null;
         }
         if(this.parent != null)
         {
            this.parent.removeChild(this);
         }
         this.target = null;
      }
      
      public function get fillColor() : uint
      {
         return _fillColor;
      }
      
      override public function get height() : Number
      {
         return _height;
      }
      
      public function get scrollX() : Number
      {
         return (super.x - _bounds.x) / (_bounds.width - _width);
      }
      
      public function get scrollY() : Number
      {
         return (super.y - _bounds.y) / (_bounds.height - _height);
      }
      
      override public function set scaleY(value:Number) : void
      {
         var oldScaleY:Number = _scaleY;
         _scaleY = value;
         setSize(_width,_height * (_scaleY / oldScaleY));
      }
      
      public function set target(value:DisplayObject) : void
      {
         var i:int = 0;
         if(_target != value)
         {
            i = int(_mouseEvents.length);
            if(_target != null)
            {
               while(--i > -1)
               {
                  _target.removeEventListener(_mouseEvents[i],_mouseEventPassthrough);
               }
            }
            _target = value;
            if(_target != null)
            {
               i = int(_mouseEvents.length);
               while(--i > -1)
               {
                  _target.addEventListener(_mouseEvents[i],_mouseEventPassthrough,false,0,true);
               }
               _prevMatrix = null;
               _transform = _target.transform;
               _bitmapMode = !_bitmapMode;
               this.bitmapMode = !_bitmapMode;
            }
            else
            {
               _bounds = new Rectangle();
            }
         }
      }
      
      protected function _render(xOffset:Number = 0, yOffset:Number = 0, clear:Boolean = true, limitRecursion:Boolean = false) : void
      {
         var xDestReset:Number = NaN;
         var xSliceReset:Number = NaN;
         var columnReset:int = 0;
         var bd:BitmapData = null;
         if(clear)
         {
            _sliceRect.x = _sliceRect.y = 0;
            _sliceRect.width = _width + 1;
            _sliceRect.height = _height + 1;
            _bd.fillRect(_sliceRect,_fillColor);
            if(_bitmapMode && _target != null)
            {
               this.filters = _target.filters;
               this.transform.colorTransform = _transform.colorTransform;
            }
            else
            {
               this.filters = _emptyArray;
               this.transform.colorTransform = _colorTransform;
            }
         }
         if(_bd == null)
         {
            return;
         }
         if(_rows == 0)
         {
            _captureTargetBitmap();
         }
         var x:Number = super.x + xOffset;
         var y:Number = super.y + yOffset;
         var wrapWidth:int = _bounds.width + _wrapOffsetX + 0.5 >> 0;
         var wrapHeight:int = _bounds.height + _wrapOffsetY + 0.5 >> 0;
         var g:Graphics = this.graphics;
         if(_bounds.width == 0 || _bounds.height == 0 || _wrap && (wrapWidth == 0 || wrapHeight == 0) || !_wrap && (x + _width < _bounds.x || y + _height < _bounds.y || x > _bounds.right || y > _bounds.bottom))
         {
            g.clear();
            g.beginBitmapFill(_bd);
            g.drawRect(0,0,_width,_height);
            g.endFill();
            return;
         }
         var column:int = int((x - _bounds.x) / _gridSize);
         if(column < 0)
         {
            column = 0;
         }
         var row:int = int((y - _bounds.y) / _gridSize);
         if(row < 0)
         {
            row = 0;
         }
         var maxColumn:int = int((x + _width - _bounds.x) / _gridSize);
         if(maxColumn >= _columns)
         {
            maxColumn = _columns - 1;
         }
         var maxRow:uint = uint(int((y + _height - _bounds.y) / _gridSize));
         if(maxRow >= _rows)
         {
            maxRow = _rows - 1;
         }
         var xNudge:Number = (_bounds.x - x) % 1;
         var yNudge:Number = (_bounds.y - y) % 1;
         if(y <= _bounds.y)
         {
            _destPoint.y = _bounds.y - y >> 0;
            _sliceRect.y = -1;
         }
         else
         {
            _destPoint.y = 0;
            _sliceRect.y = Math.ceil(y - _bounds.y) - row * _gridSize - 1;
            if(clear && yNudge != 0)
            {
               yNudge += 1;
            }
         }
         if(x <= _bounds.x)
         {
            _destPoint.x = _bounds.x - x >> 0;
            _sliceRect.x = -1;
         }
         else
         {
            _destPoint.x = 0;
            _sliceRect.x = Math.ceil(x - _bounds.x) - column * _gridSize - 1;
            if(clear && xNudge != 0)
            {
               xNudge += 1;
            }
         }
         if(_wrap && clear)
         {
            _render(Math.ceil((_bounds.x - x) / wrapWidth) * wrapWidth,Math.ceil((_bounds.y - y) / wrapHeight) * wrapHeight,false,false);
         }
         else if(_rows != 0)
         {
            xDestReset = _destPoint.x;
            xSliceReset = _sliceRect.x;
            columnReset = column;
            while(row <= maxRow)
            {
               bd = _grid[row][0];
               _sliceRect.height = bd.height - _sliceRect.y;
               _destPoint.x = xDestReset;
               _sliceRect.x = xSliceReset;
               column = columnReset;
               while(column <= maxColumn)
               {
                  bd = _grid[row][column];
                  _sliceRect.width = bd.width - _sliceRect.x;
                  _bd.copyPixels(bd,_sliceRect,_destPoint);
                  _destPoint.x += _sliceRect.width - 1;
                  _sliceRect.x = 0;
                  column++;
               }
               _destPoint.y += _sliceRect.height - 1;
               _sliceRect.y = 0;
               row++;
            }
         }
         if(clear)
         {
            _tempMatrix.tx = xNudge - 1;
            _tempMatrix.ty = yNudge - 1;
            g.clear();
            g.beginBitmapFill(_bd,_tempMatrix,false,_smoothing);
            g.drawRect(0,0,_width,_height);
            g.endFill();
         }
         else if(_wrap)
         {
            if(x + _width > _bounds.right)
            {
               _render(xOffset - wrapWidth,yOffset,false,true);
            }
            if(!limitRecursion && y + _height > _bounds.bottom)
            {
               _render(xOffset,yOffset - wrapHeight,false,false);
            }
         }
      }
      
      public function set autoUpdate(value:Boolean) : void
      {
         if(_autoUpdate != value)
         {
            _autoUpdate = value;
            if(_bitmapMode && _autoUpdate)
            {
               this.addEventListener(Event.ENTER_FRAME,update,false,-10,true);
            }
            else
            {
               this.removeEventListener(Event.ENTER_FRAME,update);
            }
         }
      }
      
      public function set fillColor(value:uint) : void
      {
         if(_fillColor != value)
         {
            _fillColor = value;
            if(_bitmapMode)
            {
               _render();
            }
         }
      }
      
      protected function _captureTargetBitmap() : void
      {
         var bd:BitmapData = null;
         var cumulativeWidth:Number = NaN;
         var column:int = 0;
         if(_bd == null || _target == null)
         {
            return;
         }
         _disposeGrid();
         var prevMask:DisplayObject = _target.mask;
         if(prevMask != null)
         {
            _target.mask = null;
         }
         var prevScrollRect:Rectangle = _target.scrollRect;
         if(prevScrollRect != null)
         {
            _target.scrollRect = null;
         }
         var prevFilters:Array = _target.filters;
         if(prevFilters.length != 0)
         {
            _target.filters = _emptyArray;
         }
         _grid = [];
         if(_target.parent == null)
         {
            _tempContainer.addChild(_target);
         }
         _bounds = _target.getBounds(_target.parent);
         var w:Number = 0;
         var h:Number = 0;
         _columns = Math.ceil(_bounds.width / _gridSize);
         _rows = Math.ceil(_bounds.height / _gridSize);
         var cumulativeHeight:Number = 0;
         var matrix:Matrix = _transform.matrix;
         var xOffset:Number = matrix.tx - _bounds.x;
         var yOffset:Number = matrix.ty - _bounds.y;
         if(!_smoothing)
         {
            xOffset = xOffset + 0.5 >> 0;
            yOffset = yOffset + 0.5 >> 0;
         }
         for(var row:int = 0; row < _rows; row++)
         {
            h = _bounds.height - cumulativeHeight > _gridSize ? _gridSize : _bounds.height - cumulativeHeight;
            matrix.ty = -cumulativeHeight + yOffset;
            cumulativeWidth = 0;
            _grid[row] = [];
            for(column = 0; column < _columns; column++)
            {
               w = _bounds.width - cumulativeWidth > _gridSize ? _gridSize : _bounds.width - cumulativeWidth;
               _grid[row][column] = bd = new BitmapData(w + 1,h + 1,true,_fillColor);
               matrix.tx = -cumulativeWidth + xOffset;
               bd.draw(_target,matrix,null,null,_clipRect,_smoothing);
               cumulativeWidth += w;
            }
            cumulativeHeight += h;
         }
         if(_target.parent == _tempContainer)
         {
            _tempContainer.removeChild(_target);
         }
         if(prevMask != null)
         {
            _target.mask = prevMask;
         }
         if(prevScrollRect != null)
         {
            _target.scrollRect = prevScrollRect;
         }
         if(prevFilters.length != 0)
         {
            _target.filters = prevFilters;
         }
      }
      
      override public function get scaleY() : Number
      {
         return 1;
      }
      
      public function update(event:Event = null, forceRecaptureBitmap:Boolean = false) : void
      {
         var m:Matrix = null;
         if(_bd == null)
         {
            return;
         }
         if(_target == null)
         {
            _render();
         }
         else if(Boolean(_target.parent))
         {
            _bounds = _target.getBounds(_target.parent);
            if(this.parent != _target.parent)
            {
               _target.parent.addChildAt(this,_target.parent.getChildIndex(_target));
            }
         }
         if(_bitmapMode || forceRecaptureBitmap)
         {
            m = _transform.matrix;
            if(forceRecaptureBitmap || _prevMatrix == null || m.a != _prevMatrix.a || m.b != _prevMatrix.b || m.c != _prevMatrix.c || m.d != _prevMatrix.d)
            {
               _captureTargetBitmap();
               _render();
            }
            else if(m.tx != _prevMatrix.tx || m.ty != _prevMatrix.ty)
            {
               _render();
            }
            else if(_bitmapMode && _target != null)
            {
               this.filters = _target.filters;
               this.transform.colorTransform = _transform.colorTransform;
            }
            _prevMatrix = m;
         }
      }
      
      public function get wrap() : Boolean
      {
         return _wrap;
      }
      
      protected function _disposeGrid() : void
      {
         var j:int = 0;
         var r:Array = null;
         var i:int = int(_grid.length);
         while(--i > -1)
         {
            r = _grid[i];
            j = int(r.length);
            while(--j > -1)
            {
               BitmapData(r[j]).dispose();
            }
         }
      }
      
      public function normalizePosition() : void
      {
         var wrapWidth:int = 0;
         var wrapHeight:int = 0;
         var offsetX:Number = NaN;
         var offsetY:Number = NaN;
         if(Boolean(_target) && Boolean(_bounds))
         {
            wrapWidth = _bounds.width + _wrapOffsetX + 0.5 >> 0;
            wrapHeight = _bounds.height + _wrapOffsetY + 0.5 >> 0;
            offsetX = (_bounds.x - this.x) % wrapWidth;
            offsetY = (_bounds.y - this.y) % wrapHeight;
            if(offsetX > (_width + _wrapOffsetX) / 2)
            {
               offsetX -= wrapWidth;
            }
            else if(offsetX < (_width + _wrapOffsetX) / -2)
            {
               offsetX += wrapWidth;
            }
            if(offsetY > (_height + _wrapOffsetY) / 2)
            {
               offsetY -= wrapHeight;
            }
            else if(offsetY < (_height + _wrapOffsetY) / -2)
            {
               offsetY += wrapHeight;
            }
            _target.x += this.x + offsetX - _bounds.x;
            _target.y += this.y + offsetY - _bounds.y;
         }
      }
      
      public function get autoUpdate() : Boolean
      {
         return _autoUpdate;
      }
      
      override public function set height(value:Number) : void
      {
         setSize(_width,value);
      }
      
      override public function get width() : Number
      {
         return _width;
      }
      
      public function set scrollY(value:Number) : void
      {
         var dif:Number = NaN;
         if(_target != null && Boolean(_target.parent))
         {
            _bounds = _target.getBounds(_target.parent);
            dif = super.y - (_bounds.height - _height) * value - _bounds.y;
            _target.y += dif;
            _bounds.y += dif;
            if(_bitmapMode)
            {
               _render();
            }
         }
      }
      
      protected function _mouseEventPassthrough(event:MouseEvent) : void
      {
         if(this.mouseEnabled && (!_bitmapMode || this.hitTestPoint(event.stageX,event.stageY,false)))
         {
            dispatchEvent(event);
         }
      }
      
      public function enableBitmapMode(event:Event = null) : void
      {
         this.bitmapMode = true;
      }
      
      public function set scrollX(value:Number) : void
      {
         var dif:Number = NaN;
         if(_target != null && Boolean(_target.parent))
         {
            _bounds = _target.getBounds(_target.parent);
            dif = super.x - (_bounds.width - _width) * value - _bounds.x;
            _target.x += dif;
            _bounds.x += dif;
            if(_bitmapMode)
            {
               _render();
            }
         }
      }
      
      public function set smoothing(value:Boolean) : void
      {
         if(_smoothing != value)
         {
            _smoothing = value;
            _captureTargetBitmap();
            if(_bitmapMode)
            {
               _render();
            }
         }
      }
      
      public function set bitmapMode(value:Boolean) : void
      {
         if(_bitmapMode != value)
         {
            _bitmapMode = value;
            if(_target != null)
            {
               _target.visible = !_bitmapMode;
               update(null);
               if(_bitmapMode)
               {
                  this.filters = _target.filters;
                  this.transform.colorTransform = _transform.colorTransform;
                  this.blendMode = _target.blendMode;
                  _target.mask = null;
               }
               else
               {
                  this.filters = _emptyArray;
                  this.transform.colorTransform = _colorTransform;
                  this.blendMode = "normal";
                  this.cacheAsBitmap = false;
                  _target.mask = this;
                  if(_wrap)
                  {
                     normalizePosition();
                  }
               }
               if(_bitmapMode && _autoUpdate)
               {
                  this.addEventListener(Event.ENTER_FRAME,update,false,-10,true);
               }
               else
               {
                  this.removeEventListener(Event.ENTER_FRAME,update);
               }
            }
         }
      }
      
      public function get bitmapMode() : Boolean
      {
         return _bitmapMode;
      }
      
      public function set wrapOffsetX(value:Number) : void
      {
         if(_wrapOffsetX != value)
         {
            _wrapOffsetX = value;
            if(_bitmapMode)
            {
               _render();
            }
         }
      }
      
      override public function get y() : Number
      {
         return super.y;
      }
      
      override public function get scaleX() : Number
      {
         return 1;
      }
      
      override public function set rotation(value:Number) : void
      {
         if(value != 0)
         {
            throw new Error("Cannot set the rotation of a BlitMask to a non-zero number. BlitMasks should remain unrotated.");
         }
      }
      
      override public function get x() : Number
      {
         return super.x;
      }
   }
}

