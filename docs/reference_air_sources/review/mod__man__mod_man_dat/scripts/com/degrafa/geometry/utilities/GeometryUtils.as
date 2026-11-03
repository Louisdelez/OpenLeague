package com.degrafa.geometry.utilities
{
   import com.degrafa.geometry.command.CommandStack;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class GeometryUtils
   {
      
      private static var returnResult:Array;
      
      private static var m3:Number;
      
      private static var dx:Number;
      
      private static var dy:Number;
      
      private static var dx2:Number;
      
      private static var m1:Number;
      
      private static var sx:Number;
      
      private static var m2:Number;
      
      private static var sy:Number;
      
      private static var dx1:Number;
      
      private static var half:Number = 0.5;
      
      private static var bezBoundsRect:Rectangle = new Rectangle();
      
      public function GeometryUtils()
      {
         super();
      }
      
      public static function cubicToQuadratic(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number, param8:Number, param9:Number, param10:CommandStack) : void
      {
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc15_:Number = NaN;
         var _loc16_:Number = NaN;
         var _loc17_:Number = NaN;
         var _loc18_:Number = NaN;
         var _loc19_:Number = NaN;
         var _loc20_:Number = NaN;
         var _loc21_:Number = NaN;
         var _loc22_:Number = NaN;
         var _loc23_:Number = NaN;
         dx1 = param3 - param1;
         dx2 = param5 - param7;
         if((dx1 < 0 ? -dx1 : dx1) < 0.00001)
         {
            dx1 = 0;
         }
         if((dx2 < 0 ? -dx2 : dx2) < 0.00001)
         {
            dx2 = 0;
         }
         if(param2 == param8 && param4 == param2 && param6 == param8)
         {
            param10.addLineTo(param7,param8);
            return;
         }
         if(!dx1 && !dx2)
         {
            _loc11_ = param1 - param7;
            if(_loc11_ < 0)
            {
               _loc11_ = -_loc11_;
            }
            if(!_loc11_ || _loc11_ < 0.00001)
            {
               param10.addLineTo(param7,param8);
               return;
            }
            dy = param2 - param4;
            if(dy < 0)
            {
               dy = -dy;
            }
            if(!dy || dy < 0.00001)
            {
               dy = param8 - param6;
               if(dy < 0)
               {
                  dy = -dy;
               }
               if(!dy || dy < 0.00001)
               {
                  param10.addLineTo(param7,param8);
                  return;
               }
               sx = param5;
               sy = param6;
            }
            else
            {
               dy = param8 - param6;
               if(dy < 0)
               {
                  dy = -dy;
               }
               if(!dy || dy < 0.00001)
               {
                  sx = param3;
                  sy = param4;
               }
               else if(param4 < param2 && param6 < param8 || param4 > param2 && param6 > param8)
               {
                  sx = (param3 + param5) / 2;
                  sy = (param4 + param6) / 2;
               }
               else
               {
                  dx = param9;
                  dy = param9;
               }
            }
            if(!dx)
            {
               dx = (param1 + param7 + sx * 4 - (param3 + param5) * 3) * 0.125;
               dy = (param2 + param8 + sy * 4 - (param4 + param6) * 3) * 0.125;
            }
         }
         else if(!dx1)
         {
            sx = param1;
            sy = (param6 - param8) / dx2 * (param1 - param7) + param8;
            dx = (param1 + param7 + sx * 4 - (param3 + param5) * 3) * 0.125;
            dy = (param2 + param8 + sy * 4 - (param4 + param6) * 3) * 0.125;
         }
         else if(!dx2)
         {
            sx = param7;
            sy = (param4 - param2) / dx1 * (param7 - param1) + param2;
            dx = (param1 + param7 + sx * 4 - (param3 + param5) * 3) * 0.125;
            dy = (param2 + param8 + sy * 4 - (param4 + param6) * 3) * 0.125;
         }
         else
         {
            m1 = (param4 - param2) / dx1;
            m2 = (param6 - param8) / dx2;
            if((m1 < 0 ? -m1 : m1) == (m2 < 0 ? -m2 : m2))
            {
               m3 = (param8 - param2) / (param7 - param1);
               if(m1 == m2 && m3 == m1)
               {
                  param10.addLineTo(param7,param8);
                  return;
               }
               if(m1 > m3 && m2 < m3 || m1 < m3 && m2 > m3)
               {
                  sx = (param3 + param5) / 2;
                  sy = (param4 + param6) / 2;
                  dx = (param1 + param7 + sx * 4 - (param3 + param5) * 3) * 0.125;
                  dy = (param2 + param8 + sy * 4 - (param4 + param6) * 3) * 0.125;
               }
               else
               {
                  dx = param9;
                  dy = param9;
               }
            }
            else
            {
               sx = (-m2 * param7 + param8 + m1 * param1 - param2) / (m1 - m2);
               sy = m1 * (sx - param1) + param2;
               dx = (param1 + param7 + sx * 4 - (param3 + param5) * 3) * 0.125;
               dy = (param2 + param8 + sy * 4 - (param4 + param6) * 3) * 0.125;
            }
         }
         if(dx * dx + dy * dy > param9)
         {
            _loc12_ = (param1 + param3) * 0.5;
            _loc13_ = (param2 + param4) * 0.5;
            _loc14_ = (param3 + param5) * 0.5;
            _loc15_ = (param4 + param6) * 0.5;
            _loc16_ = (param5 + param7) * 0.5;
            _loc17_ = (param6 + param8) * 0.5;
            _loc18_ = (_loc12_ + _loc14_) * 0.5;
            _loc19_ = (_loc13_ + _loc15_) * 0.5;
            _loc20_ = (_loc14_ + _loc16_) * 0.5;
            _loc21_ = (_loc15_ + _loc17_) * 0.5;
            _loc22_ = (_loc18_ + _loc20_) * 0.5;
            _loc23_ = (_loc19_ + _loc21_) * 0.5;
            cubicToQuadratic(param1,param2,_loc12_,_loc13_,_loc18_,_loc19_,_loc22_,_loc23_,param9,param10);
            cubicToQuadratic(_loc22_,_loc23_,_loc20_,_loc21_,_loc16_,_loc17_,param7,param8,param9,param10);
         }
         else
         {
            param10.addCurveTo(sx,sy,param7,param8);
         }
      }
      
      public static function lineIntersects(param1:Point, param2:Point, param3:Point, param4:Point) : Point
      {
         var _loc5_:Number = param1.x;
         var _loc6_:Number = param1.y;
         var _loc7_:Number = param4.x;
         var _loc8_:Number = param4.y;
         var _loc9_:Number = param2.x - _loc5_;
         var _loc10_:Number = param3.x - _loc7_;
         var _loc11_:Point = new Point();
         if(!(Boolean(_loc9_) || Boolean(_loc10_)))
         {
            _loc11_.x = 0;
            _loc11_.y = 0;
         }
         var _loc12_:Number = (param2.y - _loc6_) / _loc9_;
         var _loc13_:Number = (param3.y - _loc8_) / _loc10_;
         if(!_loc9_)
         {
            _loc11_.x = _loc5_;
            _loc11_.y = _loc13_ * (_loc5_ - _loc7_) + _loc8_;
            return _loc11_;
         }
         if(!_loc10_)
         {
            _loc11_.x = _loc7_;
            _loc11_.y = _loc12_ * (_loc7_ - _loc5_) + _loc6_;
            return _loc11_;
         }
         var _loc14_:Number = (-_loc13_ * _loc7_ + _loc8_ + _loc12_ * _loc5_ - _loc6_) / (_loc12_ - _loc13_);
         var _loc15_:Number = _loc12_ * (_loc14_ - _loc5_) + _loc6_;
         _loc11_.x = _loc14_;
         _loc11_.y = _loc15_;
         return _loc11_;
      }
      
      public static function splitBezier(param1:Point, param2:Point, param3:Point, param4:Point) : Object
      {
         var _loc5_:Point = midPoint(param1,param2);
         var _loc6_:Point = midPoint(param2,param3);
         var _loc7_:Point = midPoint(param3,param4);
         var _loc8_:Point = midPoint(_loc5_,_loc6_);
         var _loc9_:Point = midPoint(_loc6_,_loc7_);
         var _loc10_:Point = midPoint(_loc8_,_loc9_);
         return {
            "b0":{
               "p1":param1,
               "c1":_loc5_,
               "c2":_loc8_,
               "p2":_loc10_
            },
            "b1":{
               "p1":_loc10_,
               "c1":_loc9_,
               "c2":_loc7_,
               "p2":param4
            }
         };
      }
      
      public static function barycenter(param1:Number, param2:Number, param3:Number, param4:Number) : Number
      {
         return (1 - param4) * (1 - param4) * param1 + 2 * (1 - param4) * param4 * param2 + param4 * param4 * param3;
      }
      
      public static function perimeter(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : Number
      {
         var _loc10_:Number = NaN;
         var _loc11_:Number = NaN;
         var _loc12_:Number = NaN;
         var _loc13_:Number = NaN;
         var _loc14_:Number = NaN;
         var _loc7_:Number = param1;
         var _loc8_:Number = param2;
         var _loc9_:Number = 0;
         var _loc15_:Number = 0;
         while(_loc15_ <= 1)
         {
            _loc10_ = barycenter(param1,param3,param5,_loc15_);
            _loc11_ = barycenter(param2,param4,param6,_loc15_);
            _loc12_ = Math.abs(_loc10_ - _loc7_);
            _loc13_ = Math.abs(_loc11_ - _loc8_);
            _loc14_ = Math.sqrt(_loc12_ * _loc12_ + _loc13_ * _loc13_);
            _loc9_ += _loc14_;
            _loc7_ = _loc10_;
            _loc8_ = _loc11_;
            _loc15_ += 0.001;
         }
         return _loc9_;
      }
      
      public static function rotatePointOnCenterPoint(param1:Point, param2:Point, param3:Number) : Point
      {
         var _loc4_:Point = new Point();
         var _loc5_:Number = param3 / 180 * Math.PI;
         _loc4_.x = param2.x + (Math.cos(_loc5_) * (param1.x - param2.x) - Math.sin(_loc5_) * (param1.y - param2.y));
         _loc4_.y = param2.y + (Math.sin(_loc5_) * (param1.x - param2.x) + Math.cos(_loc5_) * (param1.y - param2.y));
         return _loc4_;
      }
      
      public static function midPoint(param1:Point, param2:Point) : Point
      {
         return new Point((param1.x + param2.x) * half,(param1.y + param2.y) * half);
      }
      
      public static function roundTo(param1:Number, param2:Number) : Number
      {
         return Math.round(param1 * Math.pow(10,param2)) / Math.pow(10,param2);
      }
      
      public static function radiusToDegress(param1:Number) : Number
      {
         return param1 * (180 / Math.PI);
      }
      
      public static function pointOnQuadraticCurve(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number, param7:Number) : Object
      {
         var _loc8_:Number = param1 / 100;
         return {
            "x":param2 + _loc8_ * (2 * (1 - _loc8_) * (param4 - param2) + _loc8_ * (param6 - param2)),
            "y":param3 + _loc8_ * (2 * (1 - _loc8_) * (param5 - param3) + _loc8_ * (param7 - param3))
         };
      }
      
      public static function degressToRadius(param1:Number) : Number
      {
         return param1 * (Math.PI / 180);
      }
      
      public static function bezierBounds(param1:Number, param2:Number, param3:Number, param4:Number, param5:Number, param6:Number) : Rectangle
      {
         var _loc7_:Number = NaN;
         if(param1 == param3 && param3 == param5)
         {
            bezBoundsRect.x = param1;
            bezBoundsRect.y = Math.min(param2,param6);
            bezBoundsRect.width = 0.0001;
            bezBoundsRect.height = Math.abs(param6 - param2);
            return bezBoundsRect;
         }
         if(param2 == param4 && param4 == param6)
         {
            bezBoundsRect.x = Math.min(param1,param5);
            bezBoundsRect.y = param2;
            bezBoundsRect.width = Math.abs(param5 - param1);
            bezBoundsRect.height = 0.0001;
            return bezBoundsRect;
         }
         if(param2 > param6)
         {
            if(param4 > param6)
            {
               bezBoundsRect.y = param6;
            }
            else
            {
               _loc7_ = -(param4 - param2) / (param6 - 2 * param4 + param2);
               bezBoundsRect.y = (1 - _loc7_) * (1 - _loc7_) * param2 + 2 * _loc7_ * (1 - _loc7_) * param4 + _loc7_ * _loc7_ * param6;
            }
         }
         else if(param4 > param2)
         {
            bezBoundsRect.y = param2;
         }
         else
         {
            _loc7_ = -(param4 - param2) / (param6 - 2 * param4 + param2);
            bezBoundsRect.y = (1 - _loc7_) * (1 - _loc7_) * param2 + 2 * _loc7_ * (1 - _loc7_) * param4 + _loc7_ * _loc7_ * param6;
         }
         if(param2 > param6)
         {
            if(param4 < param2)
            {
               bezBoundsRect.bottom = param2;
            }
            else
            {
               _loc7_ = -(param4 - param2) / (param6 - 2 * param4 + param2);
               bezBoundsRect.bottom = (1 - _loc7_) * (1 - _loc7_) * param2 + 2 * _loc7_ * (1 - _loc7_) * param4 + _loc7_ * _loc7_ * param6;
            }
         }
         else if(param6 > param4)
         {
            bezBoundsRect.bottom = param6;
         }
         else
         {
            _loc7_ = -(param4 - param2) / (param6 - 2 * param4 + param2);
            bezBoundsRect.bottom = (1 - _loc7_) * (1 - _loc7_) * param2 + 2 * _loc7_ * (1 - _loc7_) * param4 + _loc7_ * _loc7_ * param6;
         }
         if(param1 > param5)
         {
            if(param3 > param5)
            {
               bezBoundsRect.x = param5;
            }
            else
            {
               _loc7_ = -(param3 - param1) / (param5 - 2 * param3 + param1);
               bezBoundsRect.x = (1 - _loc7_) * (1 - _loc7_) * param1 + 2 * _loc7_ * (1 - _loc7_) * param3 + _loc7_ * _loc7_ * param5;
            }
         }
         else if(param3 > param1)
         {
            bezBoundsRect.x = param1;
         }
         else
         {
            _loc7_ = -(param3 - param1) / (param5 - 2 * param3 + param1);
            bezBoundsRect.x = (1 - _loc7_) * (1 - _loc7_) * param1 + 2 * _loc7_ * (1 - _loc7_) * param3 + _loc7_ * _loc7_ * param5;
         }
         if(param1 > param5)
         {
            if(param3 < param1)
            {
               bezBoundsRect.right = param1;
            }
            else
            {
               _loc7_ = -(param3 - param1) / (param5 - 2 * param3 + param1);
               bezBoundsRect.right = (1 - _loc7_) * (1 - _loc7_) * param1 + 2 * _loc7_ * (1 - _loc7_) * param3 + _loc7_ * _loc7_ * param5;
            }
         }
         else if(param3 < param5)
         {
            bezBoundsRect.right = param5;
         }
         else
         {
            _loc7_ = -(param3 - param1) / (param5 - 2 * param3 + param1);
            bezBoundsRect.right = (1 - _loc7_) * (1 - _loc7_) * param1 + 2 * _loc7_ * (1 - _loc7_) * param3 + _loc7_ * _loc7_ * param5;
         }
         return bezBoundsRect;
      }
      
      public static function rotatePoint(param1:Point, param2:Number) : Point
      {
         var _loc3_:Number = Math.sqrt(Math.pow(param1.x,2) + Math.pow(param1.y,2));
         param2 = Math.atan2(param1.y,param1.x) + degressToRadius(param2);
         return new Point(roundTo(_loc3_ * Math.cos(param2),3),roundTo(_loc3_ * Math.sin(param2),3));
      }
   }
}

