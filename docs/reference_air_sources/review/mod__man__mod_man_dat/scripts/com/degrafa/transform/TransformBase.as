package com.degrafa.transform
{
   import com.degrafa.IGeometryComposition;
   import com.degrafa.core.DegrafaObject;
   import com.degrafa.geometry.Geometry;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class TransformBase extends DegrafaObject implements ITransform
   {
      
      private static var identity:Matrix = new Matrix();
      
      public var invalidated:Boolean;
      
      protected var _transformMatrix:Matrix = new Matrix();
      
      protected var _skewX:Number = 0;
      
      private var _data:String;
      
      protected var _skewY:Number = 0;
      
      protected var _tx:Number = 0;
      
      protected var _ty:Number = 0;
      
      protected var _angle:Number = 0;
      
      protected var _registrationPoint:String;
      
      protected var _centerX:Number = NaN;
      
      protected var _centerY:Number = NaN;
      
      protected var _scaleX:Number = 1;
      
      protected var _scaleY:Number = 1;
      
      public function TransformBase()
      {
         super();
      }
      
      public static function getRenderedBounds(param1:IGeometryComposition) : Rectangle
      {
         var _loc3_:Matrix = null;
         var _loc2_:Geometry = param1 as Geometry;
         if(_loc2_.transform)
         {
            return (_loc2_.transform as TransformBase).getTransformedBoundsFor(param1);
         }
         _loc3_ = _loc2_.transformContext;
         if(!_loc3_)
         {
            while(_loc2_.parent)
            {
               _loc2_ = _loc2_.parent as Geometry;
               if(_loc2_.transform)
               {
                  _loc3_ = _loc2_.transform.getTransformFor(_loc2_);
                  break;
               }
            }
         }
         if(_loc3_)
         {
            return transformBounds(_loc2_.bounds,_loc3_);
         }
         return _loc2_.bounds.clone();
      }
      
      public static function transformBounds(param1:Rectangle, param2:Matrix) : Rectangle
      {
         var _loc6_:Point = null;
         var _loc7_:Point = null;
         var _loc9_:Point = null;
         var _loc3_:Rectangle = param1.clone();
         var _loc4_:Point = _loc3_.topLeft;
         var _loc5_:Point = _loc3_.bottomRight;
         _loc6_ = _loc4_.clone();
         _loc6_.offset(_loc5_.x - _loc4_.x,0);
         _loc7_ = _loc4_.clone();
         _loc7_.offset(0,_loc5_.y - _loc4_.y);
         var _loc8_:Array = [param2.transformPoint(_loc4_),param2.transformPoint(_loc5_),param2.transformPoint(_loc6_),param2.transformPoint(_loc7_)];
         _loc3_.setEmpty();
         _loc3_.topLeft = param2.transformPoint(_loc4_);
         for each(_loc9_ in _loc8_)
         {
            if(_loc3_.right < _loc9_.x)
            {
               _loc3_.right = _loc9_.x;
            }
            if(_loc3_.top > _loc9_.y)
            {
               _loc3_.top = _loc9_.y;
            }
            if(_loc3_.left > _loc9_.x)
            {
               _loc3_.left = _loc9_.x;
            }
            if(_loc3_.bottom < _loc9_.y)
            {
               _loc3_.bottom = _loc9_.y;
            }
         }
         return _loc3_;
      }
      
      public function hasExplicitSetting() : Boolean
      {
         return Boolean(_registrationPoint) || !(isNaN(_centerX) || isNaN(_centerY));
      }
      
      public function get isIdentity() : Boolean
      {
         var _loc1_:Matrix = null;
         if(invalidated)
         {
            _loc1_ = transformMatrix;
         }
         return _transformMatrix.a == 1 && !_transformMatrix.b && !_transformMatrix.c && _transformMatrix.d == 1 && !_transformMatrix.tx && !_transformMatrix.ty;
      }
      
      public function get skewX() : Number
      {
         return _skewX;
      }
      
      public function get skewY() : Number
      {
         return _skewY;
      }
      
      public function getRegPointForRectangle(param1:Rectangle) : Point
      {
         var _loc2_:Point = null;
         if(_registrationPoint)
         {
            _loc2_ = getRegistrationPoint(null,param1);
         }
         else
         {
            _loc2_ = new Point(param1.x + param1.width / 2 + centerX,param1.y + param1.height / 2 + centerY);
         }
         return _loc2_;
      }
      
      public function set transformMatrix(param1:Matrix) : void
      {
         _transformMatrix = param1;
      }
      
      protected function getRegistrationPoint(param1:IGeometryComposition, param2:Rectangle = null) : Point
      {
         var _loc3_:Point = null;
         if(param1)
         {
            param2 = (param1 as Geometry).hasLayout ? Geometry(param1).layoutRectangle : Geometry(param1).bounds;
         }
         switch(_registrationPoint)
         {
            case "topLeft":
               _loc3_ = param2.topLeft;
               break;
            case "centerLeft":
               _loc3_ = new Point(param2.left,param2.y + param2.height / 2);
               break;
            case "bottomLeft":
               _loc3_ = new Point(param2.left,param2.bottom);
               break;
            case "centerTop":
               _loc3_ = new Point(param2.x + param2.width / 2,param2.y);
               break;
            case "center":
               _loc3_ = new Point(param2.x + param2.width / 2,param2.y + param2.height / 2);
               break;
            case "centerBottom":
               _loc3_ = new Point(param2.x + param2.width / 2,param2.bottom);
               break;
            case "topRight":
               _loc3_ = new Point(param2.right,param2.top);
               break;
            case "centerRight":
               _loc3_ = new Point(param2.right,param2.y + param2.height / 2);
               break;
            case "bottomRight":
               _loc3_ = param2.bottomRight;
         }
         return _loc3_;
      }
      
      public function get data() : String
      {
         return _data;
      }
      
      public function get centerX() : Number
      {
         return isNaN(_centerX) ? 0 : _centerX;
      }
      
      public function get centerY() : Number
      {
         return isNaN(_centerY) ? 0 : _centerY;
      }
      
      public function set registrationPoint(param1:String) : void
      {
         var _loc2_:String = null;
         if(_registrationPoint != param1)
         {
            _loc2_ = _registrationPoint;
            _registrationPoint = param1;
         }
      }
      
      public function getTransformFor(param1:IGeometryComposition) : Matrix
      {
         var _loc2_:Point = _registrationPoint ? getRegistrationPoint(param1) : new Point(centerX,centerY);
         var _loc3_:Geometry = param1 as Geometry;
         var _loc4_:Matrix = _loc3_.transformContext;
         if(!_loc4_)
         {
            while(_loc3_.parent)
            {
               _loc3_ = _loc3_.parent as Geometry;
               if(_loc3_.transform)
               {
                  _loc4_ = _loc3_.transform.getTransformFor(_loc3_);
                  break;
               }
            }
         }
         var _loc5_:Matrix = new Matrix();
         _loc5_.translate(-_loc2_.x,-_loc2_.y);
         _loc5_.concat(transformMatrix);
         _loc5_.translate(_loc2_.x,_loc2_.y);
         if(_loc4_)
         {
            _loc5_.concat(_loc4_);
         }
         return _loc5_;
      }
      
      public function set centerY(param1:Number) : void
      {
         if(_centerY != param1)
         {
            _centerY = param1;
            invalidated = true;
         }
      }
      
      public function get transformMatrix() : Matrix
      {
         var _loc1_:Matrix = null;
         if(!invalidated)
         {
            return _transformMatrix;
         }
         _transformMatrix.identity();
         if(_scaleX != 1 || _scaleY != 1)
         {
            _transformMatrix.scale(_scaleX,_scaleY);
         }
         if(Boolean(_skewX) || Boolean(_skewY))
         {
            _loc1_ = new Matrix();
            _loc1_.a = Math.cos(_skewY * Math.PI / 180);
            _loc1_.b = Math.sin(_skewY * Math.PI / 180);
            _loc1_.c = -Math.sin(_skewX * Math.PI / 180);
            _loc1_.d = Math.cos(_skewX * Math.PI / 180);
            _transformMatrix.concat(_loc1_);
         }
         if(_angle)
         {
            _transformMatrix.rotate(_angle * Math.PI / 180);
         }
         if(Boolean(_tx) || Boolean(_ty))
         {
            _transformMatrix.translate(_tx,_ty);
         }
         invalidated = false;
         return _transformMatrix;
      }
      
      public function get scaleX() : Number
      {
         return _scaleX;
      }
      
      public function getRegPoint(param1:IGeometryComposition) : Point
      {
         if(_registrationPoint)
         {
            return getRegistrationPoint(param1);
         }
         return new Point(centerX,centerY);
      }
      
      public function get angle() : Number
      {
         return _angle;
      }
      
      public function set centerX(param1:Number) : void
      {
         if(_centerX != param1)
         {
            _centerX = param1;
            invalidated = true;
         }
      }
      
      public function get scaleY() : Number
      {
         return _scaleY;
      }
      
      public function set data(param1:String) : void
      {
         _data = param1;
      }
      
      public function get registrationPoint() : String
      {
         return _registrationPoint;
      }
      
      public function get x() : Number
      {
         return _tx;
      }
      
      public function get y() : Number
      {
         return _ty;
      }
      
      public function getTransformedBoundsFor(param1:IGeometryComposition) : Rectangle
      {
         var _loc2_:Geometry = param1 as Geometry;
         var _loc3_:Matrix = getTransformFor(param1);
         return transformBounds(_loc2_.bounds,_loc3_);
      }
   }
}

