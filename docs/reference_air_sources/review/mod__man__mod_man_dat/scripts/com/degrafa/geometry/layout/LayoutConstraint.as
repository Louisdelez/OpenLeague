package com.degrafa.geometry.layout
{
   import com.degrafa.core.DegrafaObject;
   import flash.display.DisplayObject;
   import flash.geom.Rectangle;
   import mx.events.PropertyChangeEvent;
   
   public class LayoutConstraint extends DegrafaObject implements ILayout
   {
      
      private var _right:Number;
      
      private var _maxWidth:Number;
      
      private var _minX:Number;
      
      private var _minY:Number;
      
      private var _maxHeight:Number;
      
      private var _layoutRectangle:Rectangle = new Rectangle();
      
      private var _maintainAspectRatio:Boolean = false;
      
      private var _height:Number;
      
      private var _maxY:Number;
      
      private var _bottom:Number;
      
      private var _maxX:Number;
      
      private var _percentWidth:Number;
      
      private var container:Rectangle;
      
      private var _verticalCenter:Number;
      
      private var _top:Number;
      
      private var _minHeight:Number;
      
      private var _targetCoordinateSpace:DisplayObject;
      
      private var _width:Number;
      
      private var _invalidated:Boolean;
      
      private var _percentHeight:Number;
      
      private var _left:Number;
      
      private var _minWidth:Number;
      
      private var _horizontalCenter:Number;
      
      private var _x:Number;
      
      private var _y:Number;
      
      public function LayoutConstraint()
      {
         super();
      }
      
      [Bindable(event="propertyChange")]
      public function set y(param1:Number) : void
      {
         var _loc2_:Object = this.y;
         if(_loc2_ !== param1)
         {
            this._121y = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"y",_loc2_,param1));
         }
      }
      
      private function set _3351623minY(param1:Number) : void
      {
         if(_minY != param1)
         {
            _minY = param1;
            invalidated = true;
         }
      }
      
      public function get left() : Number
      {
         if(!_left)
         {
            return NaN;
         }
         return _left;
      }
      
      public function get maintainAspectRatio() : Boolean
      {
         return _maintainAspectRatio;
      }
      
      private function set _3351622minX(param1:Number) : void
      {
         if(_minX != param1)
         {
            _minX = param1;
            invalidated = true;
         }
      }
      
      private function set _3344244maxX(param1:Number) : void
      {
         if(_maxX != param1)
         {
            _maxX = param1;
            invalidated = true;
         }
      }
      
      private function set _120x(param1:Number) : void
      {
         if(_x != param1)
         {
            _x = param1;
            invalidated = true;
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set percentWidth(param1:Number) : void
      {
         var _loc2_:Object = this.percentWidth;
         if(_loc2_ !== param1)
         {
            this._1127236479percentWidth = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"percentWidth",_loc2_,param1));
         }
      }
      
      public function set invalidated(param1:Boolean) : void
      {
         _invalidated = param1;
      }
      
      [Bindable(event="propertyChange")]
      public function set left(param1:Number) : void
      {
         var _loc2_:Object = this.left;
         if(_loc2_ !== param1)
         {
            this._3317767left = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"left",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set maintainAspectRatio(param1:Boolean) : void
      {
         var _loc2_:Object = this.maintainAspectRatio;
         if(_loc2_ !== param1)
         {
            this._574021640maintainAspectRatio = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"maintainAspectRatio",_loc2_,param1));
         }
      }
      
      private function set _3344245maxY(param1:Number) : void
      {
         if(_maxY != param1)
         {
            _maxY = param1;
            invalidated = true;
         }
      }
      
      public function get right() : Number
      {
         if(!_right)
         {
            return NaN;
         }
         return _right;
      }
      
      private function calculateLayoutRectangle() : void
      {
         var _loc1_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc2_:Boolean = isNaN(_left);
         var _loc3_:Boolean = isNaN(_right);
         var _loc4_:Boolean = isNaN(_horizontalCenter);
         var _loc5_:Boolean = !Boolean(_loc2_);
         var _loc6_:Boolean = !Boolean(_loc3_);
         if(container)
         {
            if(!_loc5_ && !_loc6_)
            {
               if(_loc4_)
               {
                  _layoutRectangle.width = isNaN(_percentWidth) ? _width : (_percentWidth > 1 ? _percentWidth / 100 * container.width : _percentWidth * container.width);
                  _layoutRectangle.x = isNaN(_x) ? 0 : _x + container.left;
               }
               else
               {
                  _layoutRectangle.width = isNaN(_percentWidth) ? _width : (_percentWidth > 1 ? _percentWidth / 100 * container.width : _percentWidth * container.width);
                  _layoutRectangle.x = _horizontalCenter - _layoutRectangle.width / 2 + container.left + container.width / 2;
               }
            }
            else if(!_loc6_)
            {
               _layoutRectangle.width = isNaN(_percentWidth) ? _width : (_percentWidth > 1 ? _percentWidth / 100 * container.width : _percentWidth * container.width);
               _layoutRectangle.x = container.left + _left;
            }
            else if(!_loc5_)
            {
               _layoutRectangle.width = isNaN(_percentWidth) ? _width : (_percentWidth > 1 ? _percentWidth / 100 * container.width : _percentWidth * container.width);
               _layoutRectangle.x = container.right - _right - _layoutRectangle.width;
            }
            else
            {
               _layoutRectangle.right = container.right - _right;
               _layoutRectangle.left = container.left + _left;
            }
         }
         if(!isNaN(_minX))
         {
            _loc1_ = container.x + _minX;
            if(_loc1_ > _layoutRectangle.x)
            {
               _layoutRectangle.x = _loc1_;
            }
         }
         if(!isNaN(_maxX))
         {
            _loc1_ = container.x + _maxX;
            if(_loc1_ < _layoutRectangle.x)
            {
               _layoutRectangle.x = _loc1_;
            }
         }
         _loc1_ = 0;
         if(!isNaN(_minWidth) && _minWidth > _layoutRectangle.width)
         {
            _loc1_ = _layoutRectangle.width - _minWidth;
         }
         else if(!isNaN(_maxWidth) && _maxWidth < _layoutRectangle.width)
         {
            _loc1_ = _layoutRectangle.width - _maxWidth;
         }
         if(_loc1_)
         {
            if(!_loc5_)
            {
               if(_loc6_)
               {
                  _layoutRectangle.x += _loc1_;
               }
               else if(!_loc4_)
               {
                  _layoutRectangle.x += _loc1_ / 2;
               }
            }
            else if(_loc5_ && _loc6_)
            {
               _layoutRectangle.x += _loc1_ / 2;
            }
            _layoutRectangle.width -= _loc1_;
         }
         var _loc7_:Boolean = isNaN(_top);
         var _loc8_:Boolean = isNaN(_bottom);
         var _loc9_:Boolean = isNaN(_verticalCenter);
         var _loc10_:Boolean = !Boolean(_loc7_);
         var _loc11_:Boolean = !Boolean(_loc8_);
         if(container)
         {
            if(!_loc10_ && !_loc11_)
            {
               if(_loc9_)
               {
                  _layoutRectangle.height = isNaN(_percentHeight) ? _height : (_percentHeight > 1 ? _percentHeight / 100 * container.height : _percentHeight * container.height);
                  _layoutRectangle.y = isNaN(_y) ? 0 : _y + container.top;
               }
               else
               {
                  _layoutRectangle.height = isNaN(_percentHeight) ? _height : (_percentHeight > 1 ? _percentHeight / 100 * container.height : _percentHeight * container.height);
                  _layoutRectangle.y = _verticalCenter - _layoutRectangle.height / 2 + container.top + container.height / 2;
               }
            }
            else if(!_loc11_)
            {
               _layoutRectangle.height = isNaN(_percentHeight) ? _height : (_percentHeight > 1 ? _percentHeight / 100 * container.height : _percentHeight * container.height);
               _layoutRectangle.y = container.top + _top;
            }
            else if(!_loc10_)
            {
               _layoutRectangle.height = isNaN(_percentHeight) ? _height : (_percentHeight > 1 ? _percentHeight / 100 * container.height : _percentHeight * container.height);
               _layoutRectangle.y = container.bottom - _bottom - _layoutRectangle.height;
            }
            else
            {
               _layoutRectangle.bottom = container.bottom - _bottom;
               _layoutRectangle.top = container.top + _top;
            }
         }
         if(!isNaN(_minY))
         {
            _loc1_ = container.y + _minY;
            if(_loc1_ > _layoutRectangle.y)
            {
               _layoutRectangle.y = _loc1_;
            }
         }
         if(!isNaN(_maxY))
         {
            _loc1_ = container.y + _maxY;
            if(_loc1_ < _layoutRectangle.y)
            {
               _layoutRectangle.y = _loc1_;
            }
         }
         _loc1_ = 0;
         if(!isNaN(_minHeight) && _minHeight > _layoutRectangle.height)
         {
            _loc1_ = _layoutRectangle.height - _minHeight;
         }
         else if(!isNaN(_maxHeight) && _maxHeight < _layoutRectangle.height)
         {
            _loc1_ = _layoutRectangle.height - _maxHeight;
         }
         if(_loc1_)
         {
            if(!_loc10_)
            {
               if(_loc11_)
               {
                  _layoutRectangle.y += _loc1_;
               }
               else if(!_loc9_)
               {
                  _layoutRectangle.y += _loc1_ / 2;
               }
            }
            else if(_loc10_ && _loc11_)
            {
               _layoutRectangle.y += _loc1_ / 2;
            }
            _layoutRectangle.height -= _loc1_;
         }
         if(Boolean(_maintainAspectRatio) && Boolean(_height) && Boolean(_width))
         {
            _loc12_ = _height / _width;
            _loc13_ = _layoutRectangle.height / _layoutRectangle.width;
            if(_loc12_ > _loc13_)
            {
               _loc1_ = _layoutRectangle.height / _loc12_;
               if(!_loc5_)
               {
                  if(_loc6_)
                  {
                     _layoutRectangle.x += _layoutRectangle.width - _loc1_;
                  }
                  else if(!_loc4_)
                  {
                     _layoutRectangle.x += (_layoutRectangle.width - _loc1_) / 2;
                  }
               }
               else if(_loc5_ && _loc6_)
               {
                  _layoutRectangle.x += (_layoutRectangle.width - _loc1_) / 2;
               }
               _layoutRectangle.width = _loc1_;
            }
            else if(_loc12_ < _loc13_)
            {
               _loc1_ = _layoutRectangle.width * _loc12_;
               if(!_loc10_)
               {
                  if(_loc11_)
                  {
                     _layoutRectangle.y += _layoutRectangle.height - _loc1_;
                  }
                  else if(!_loc9_)
                  {
                     _layoutRectangle.y += (_layoutRectangle.height - _loc1_) / 2;
                  }
               }
               else if(_loc10_ && _loc11_)
               {
                  _layoutRectangle.y += (_layoutRectangle.height - _loc1_) / 2;
               }
               _layoutRectangle.height = _loc1_;
            }
         }
      }
      
      public function get minHeight() : Number
      {
         return _minHeight;
      }
      
      private function set _926273685verticalCenter(param1:Number) : void
      {
         if(_verticalCenter != param1)
         {
            _verticalCenter = param1;
            invalidated = true;
         }
      }
      
      private function set _574021640maintainAspectRatio(param1:Boolean) : void
      {
         if(_maintainAspectRatio != param1)
         {
            _maintainAspectRatio = param1;
            invalidated = true;
         }
      }
      
      public function get height() : Number
      {
         return _height;
      }
      
      [Bindable(event="propertyChange")]
      public function set minWidth(param1:Number) : void
      {
         var _loc2_:Object = this.minWidth;
         if(_loc2_ !== param1)
         {
            this._1375815020minWidth = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"minWidth",_loc2_,param1));
         }
      }
      
      public function get bottom() : Number
      {
         if(!_bottom)
         {
            return NaN;
         }
         return _bottom;
      }
      
      public function computeLayoutRectangle(param1:Rectangle, param2:Rectangle) : Rectangle
      {
         if(param2.isEmpty())
         {
            return null;
         }
         _layoutRectangle = param1.clone();
         if(isNaN(_width))
         {
            _width = layoutRectangle.width ? layoutRectangle.width : 1;
         }
         if(isNaN(_height))
         {
            _height = layoutRectangle.height ? layoutRectangle.height : 1;
         }
         if(isNaN(_x))
         {
            _x = layoutRectangle.x ? layoutRectangle.x : 0;
         }
         if(isNaN(_y))
         {
            _y = layoutRectangle.y ? layoutRectangle.y : 0;
         }
         container = param2.clone();
         calculateLayoutRectangle();
         return layoutRectangle;
      }
      
      [Bindable(event="propertyChange")]
      public function set minHeight(param1:Number) : void
      {
         var _loc2_:Object = this.minHeight;
         if(_loc2_ !== param1)
         {
            this._133587431minHeight = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"minHeight",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set right(param1:Number) : void
      {
         var _loc2_:Object = this.right;
         if(_loc2_ !== param1)
         {
            this._108511772right = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"right",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set horizontalCenter(param1:Number) : void
      {
         var _loc2_:Object = this.horizontalCenter;
         if(_loc2_ !== param1)
         {
            this._2016110183horizontalCenter = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"horizontalCenter",_loc2_,param1));
         }
      }
      
      private function set _1854666595targetCoordinateSpace(param1:DisplayObject) : void
      {
         if(_targetCoordinateSpace != param1)
         {
            _targetCoordinateSpace = param1;
            invalidated = true;
         }
      }
      
      private function set _400381634maxWidth(param1:Number) : void
      {
         if(_maxWidth != param1)
         {
            _maxWidth = param1;
            invalidated = true;
         }
      }
      
      public function get minX() : Number
      {
         return _minX;
      }
      
      public function get minY() : Number
      {
         return _minY;
      }
      
      private function set _1383228885bottom(param1:Number) : void
      {
         if(_bottom != param1)
         {
            _bottom = param1;
            invalidated = true;
         }
      }
      
      public function set derive(param1:LayoutConstraint) : void
      {
         if(!_x)
         {
            _x = param1.x;
         }
         if(!_minX)
         {
            _minX = param1.minX;
         }
         if(!_maxX)
         {
            _maxX = param1.maxX;
         }
         if(!_y)
         {
            _y = param1.y;
         }
         if(!_minY)
         {
            _minY = param1.minY;
         }
         if(!_maxY)
         {
            _maxY = param1.maxY;
         }
         if(!_width)
         {
            _width = param1.width;
         }
         if(!_minWidth)
         {
            _minWidth = param1.minWidth;
         }
         if(!_maxWidth)
         {
            _maxWidth = param1.maxWidth;
         }
         if(!_percentWidth)
         {
            _percentWidth = param1.percentWidth;
         }
         if(!_height)
         {
            _height = param1.height;
         }
         if(!_minHeight)
         {
            _minHeight = param1.minHeight;
         }
         if(!_maxHeight)
         {
            _maxHeight = param1.maxHeight;
         }
         if(!_percentHeight)
         {
            _percentHeight = param1.percentHeight;
         }
         if(!_top)
         {
            _top = param1.top;
         }
         if(!_right)
         {
            _right = param1.right;
         }
         if(!_bottom)
         {
            _bottom = param1.bottom;
         }
         if(!_left)
         {
            _left = param1.left;
         }
         if(!_horizontalCenter)
         {
            _horizontalCenter = param1.horizontalCenter;
         }
         if(!_verticalCenter)
         {
            _verticalCenter = param1.verticalCenter;
         }
         if(!_maintainAspectRatio)
         {
            _maintainAspectRatio = param1.maintainAspectRatio;
         }
         if(!_targetCoordinateSpace)
         {
            _targetCoordinateSpace = param1.targetCoordinateSpace;
         }
         invalidated = true;
      }
      
      private function set _121y(param1:Number) : void
      {
         if(_y != param1)
         {
            _y = param1;
            invalidated = true;
         }
      }
      
      private function set _108511772right(param1:Number) : void
      {
         if(_right != param1)
         {
            _right = param1;
            invalidated = true;
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set targetCoordinateSpace(param1:DisplayObject) : void
      {
         var _loc2_:Object = this.targetCoordinateSpace;
         if(_loc2_ !== param1)
         {
            this._1854666595targetCoordinateSpace = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"targetCoordinateSpace",_loc2_,param1));
         }
      }
      
      public function get top() : Number
      {
         if(!_top)
         {
            return NaN;
         }
         return _top;
      }
      
      [Bindable(event="propertyChange")]
      public function set bottom(param1:Number) : void
      {
         var _loc2_:Object = this.bottom;
         if(_loc2_ !== param1)
         {
            this._1383228885bottom = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"bottom",_loc2_,param1));
         }
      }
      
      private function set _1127236479percentWidth(param1:Number) : void
      {
         if(_percentWidth != param1)
         {
            _percentWidth = param1;
            invalidated = true;
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set height(param1:Number) : void
      {
         var _loc2_:Object = this.height;
         if(_loc2_ !== param1)
         {
            this._1221029593height = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"height",_loc2_,param1));
         }
      }
      
      private function set _113126854width(param1:Number) : void
      {
         if(_width != param1)
         {
            _width = param1;
            _percentWidth = NaN;
            invalidated = true;
         }
      }
      
      public function get layoutRectangle() : Rectangle
      {
         return _layoutRectangle.clone();
      }
      
      public function get verticalCenter() : Number
      {
         if(!_verticalCenter)
         {
            return NaN;
         }
         return _verticalCenter;
      }
      
      private function set _2016110183horizontalCenter(param1:Number) : void
      {
         if(_horizontalCenter != param1)
         {
            _horizontalCenter = param1;
            invalidated = true;
         }
      }
      
      private function set _3317767left(param1:Number) : void
      {
         if(_left != param1)
         {
            _left = param1;
            invalidated = true;
         }
      }
      
      public function get maxY() : Number
      {
         return _maxY;
      }
      
      public function get x() : Number
      {
         return _x;
      }
      
      public function get y() : Number
      {
         return _y;
      }
      
      public function get maxX() : Number
      {
         return _maxX;
      }
      
      [Bindable(event="propertyChange")]
      public function set maxHeight(param1:Number) : void
      {
         var _loc2_:Object = this.maxHeight;
         if(_loc2_ !== param1)
         {
            this._906066005maxHeight = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"maxHeight",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set maxWidth(param1:Number) : void
      {
         var _loc2_:Object = this.maxWidth;
         if(_loc2_ !== param1)
         {
            this._400381634maxWidth = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"maxWidth",_loc2_,param1));
         }
      }
      
      public function get percentWidth() : Number
      {
         if(!_percentWidth)
         {
            return NaN;
         }
         return _percentWidth;
      }
      
      public function get invalidated() : Boolean
      {
         return _invalidated;
      }
      
      private function set _1375815020minWidth(param1:Number) : void
      {
         if(_minWidth != param1)
         {
            _minWidth = param1;
            invalidated = true;
         }
      }
      
      private function set _906066005maxHeight(param1:Number) : void
      {
         if(_maxHeight != param1)
         {
            _maxHeight = param1;
            invalidated = true;
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set minY(param1:Number) : void
      {
         var _loc2_:Object = this.minY;
         if(_loc2_ !== param1)
         {
            this._3351623minY = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"minY",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set percentHeight(param1:Number) : void
      {
         var _loc2_:Object = this.percentHeight;
         if(_loc2_ !== param1)
         {
            this._1017587252percentHeight = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"percentHeight",_loc2_,param1));
         }
      }
      
      public function get horizontalCenter() : Number
      {
         if(!_horizontalCenter)
         {
            return NaN;
         }
         return _horizontalCenter;
      }
      
      public function get minWidth() : Number
      {
         return _minWidth;
      }
      
      public function get targetCoordinateSpace() : DisplayObject
      {
         if(!_targetCoordinateSpace)
         {
            return null;
         }
         return _targetCoordinateSpace;
      }
      
      [Bindable(event="propertyChange")]
      public function set width(param1:Number) : void
      {
         var _loc2_:Object = this.width;
         if(_loc2_ !== param1)
         {
            this._113126854width = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"width",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set top(param1:Number) : void
      {
         var _loc2_:Object = this.top;
         if(_loc2_ !== param1)
         {
            this._115029top = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"top",_loc2_,param1));
         }
      }
      
      public function get maxHeight() : Number
      {
         return _maxHeight;
      }
      
      [Bindable(event="propertyChange")]
      public function set minX(param1:Number) : void
      {
         var _loc2_:Object = this.minX;
         if(_loc2_ !== param1)
         {
            this._3351622minX = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"minX",_loc2_,param1));
         }
      }
      
      private function set _115029top(param1:Number) : void
      {
         if(_top != param1)
         {
            _top = param1;
            invalidated = true;
         }
      }
      
      private function set _1221029593height(param1:Number) : void
      {
         if(_height != param1)
         {
            _height = param1;
            _percentHeight = NaN;
            invalidated = true;
         }
      }
      
      public function get maxWidth() : Number
      {
         return _maxWidth;
      }
      
      public function get width() : Number
      {
         return _width;
      }
      
      public function get percentHeight() : Number
      {
         if(!_percentHeight)
         {
            return NaN;
         }
         return _percentHeight;
      }
      
      private function set _133587431minHeight(param1:Number) : void
      {
         if(_minHeight != param1)
         {
            _minHeight = param1;
            invalidated = true;
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set verticalCenter(param1:Number) : void
      {
         var _loc2_:Object = this.verticalCenter;
         if(_loc2_ !== param1)
         {
            this._926273685verticalCenter = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"verticalCenter",_loc2_,param1));
         }
      }
      
      private function set _1017587252percentHeight(param1:Number) : void
      {
         if(_percentHeight != param1)
         {
            _percentHeight = param1;
            invalidated = true;
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set maxX(param1:Number) : void
      {
         var _loc2_:Object = this.maxX;
         if(_loc2_ !== param1)
         {
            this._3344244maxX = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"maxX",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set maxY(param1:Number) : void
      {
         var _loc2_:Object = this.maxY;
         if(_loc2_ !== param1)
         {
            this._3344245maxY = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"maxY",_loc2_,param1));
         }
      }
      
      [Bindable(event="propertyChange")]
      public function set x(param1:Number) : void
      {
         var _loc2_:Object = this.x;
         if(_loc2_ !== param1)
         {
            this._120x = param1;
            this.dispatchEvent(PropertyChangeEvent.createUpdateEvent(this,"x",_loc2_,param1));
         }
      }
   }
}

