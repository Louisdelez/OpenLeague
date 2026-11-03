package com.greensock.plugins
{
   import com.greensock.*;
   import flash.geom.Matrix;
   import flash.geom.Transform;
   
   public class TransformMatrixPlugin extends TweenPlugin
   {
      
      public static const API:Number = 1;
      
      private static const _DEG2RAD:Number = Math.PI / 180;
      
      protected var _dChange:Number;
      
      protected var _txStart:Number;
      
      protected var _cStart:Number;
      
      protected var _matrix:Matrix;
      
      protected var _tyStart:Number;
      
      protected var _aStart:Number;
      
      protected var _angleChange:Number = 0;
      
      protected var _transform:Transform;
      
      protected var _aChange:Number;
      
      protected var _bChange:Number;
      
      protected var _tyChange:Number;
      
      protected var _txChange:Number;
      
      protected var _cChange:Number;
      
      protected var _dStart:Number;
      
      protected var _bStart:Number;
      
      public function TransformMatrixPlugin()
      {
         super();
         this.propName = "transformMatrix";
         this.overwriteProps = ["x","y","scaleX","scaleY","rotation","transformMatrix","transformAroundPoint","transformAroundCenter","shortRotation"];
      }
      
      override public function set changeFactor(n:Number) : void
      {
         var cos:Number = NaN;
         var sin:Number = NaN;
         var a:Number = NaN;
         var c:Number = NaN;
         _matrix.a = _aStart + n * _aChange;
         _matrix.b = _bStart + n * _bChange;
         _matrix.c = _cStart + n * _cChange;
         _matrix.d = _dStart + n * _dChange;
         if(Boolean(_angleChange))
         {
            cos = Math.cos(_angleChange * n);
            sin = Math.sin(_angleChange * n);
            a = _matrix.a;
            c = _matrix.c;
            _matrix.a = a * cos - _matrix.b * sin;
            _matrix.b = a * sin + _matrix.b * cos;
            _matrix.c = c * cos - _matrix.d * sin;
            _matrix.d = c * sin + _matrix.d * cos;
         }
         _matrix.tx = _txStart + n * _txChange;
         _matrix.ty = _tyStart + n * _tyChange;
         _transform.matrix = _matrix;
      }
      
      override public function onInitTween(target:Object, value:*, tween:TweenLite) : Boolean
      {
         var ratioX:Number = NaN;
         var ratioY:Number = NaN;
         var scaleX:Number = NaN;
         var scaleY:Number = NaN;
         var angle:Number = NaN;
         var skewX:Number = NaN;
         var finalAngle:Number = NaN;
         var finalSkewX:Number = NaN;
         var dif:Number = NaN;
         var skewY:Number = NaN;
         _transform = target.transform as Transform;
         _matrix = _transform.matrix;
         var matrix:Matrix = _matrix.clone();
         _txStart = matrix.tx;
         _tyStart = matrix.ty;
         _aStart = matrix.a;
         _bStart = matrix.b;
         _cStart = matrix.c;
         _dStart = matrix.d;
         if("x" in value)
         {
            _txChange = typeof value.x == "number" ? value.x - _txStart : Number(value.x);
         }
         else if("tx" in value)
         {
            _txChange = value.tx - _txStart;
         }
         else
         {
            _txChange = 0;
         }
         if("y" in value)
         {
            _tyChange = typeof value.y == "number" ? value.y - _tyStart : Number(value.y);
         }
         else if("ty" in value)
         {
            _tyChange = value.ty - _tyStart;
         }
         else
         {
            _tyChange = 0;
         }
         _aChange = "a" in value ? value.a - _aStart : 0;
         _bChange = "b" in value ? value.b - _bStart : 0;
         _cChange = "c" in value ? value.c - _cStart : 0;
         _dChange = "d" in value ? value.d - _dStart : 0;
         if("rotation" in value || "shortRotation" in value || "scale" in value && !(value is Matrix) || "scaleX" in value || "scaleY" in value || "skewX" in value || "skewY" in value || "skewX2" in value || "skewY2" in value)
         {
            scaleX = Math.sqrt(matrix.a * matrix.a + matrix.b * matrix.b);
            if(matrix.a < 0 && matrix.d > 0)
            {
               scaleX = -scaleX;
            }
            scaleY = Math.sqrt(matrix.c * matrix.c + matrix.d * matrix.d);
            if(matrix.d < 0 && matrix.a > 0)
            {
               scaleY = -scaleY;
            }
            angle = Math.atan2(matrix.b,matrix.a);
            if(matrix.a < 0 && matrix.d >= 0)
            {
               angle += angle <= 0 ? Math.PI : -Math.PI;
            }
            skewX = Math.atan2(-_matrix.c,_matrix.d) - angle;
            finalAngle = angle;
            if("shortRotation" in value)
            {
               dif = (value.shortRotation * _DEG2RAD - angle) % (Math.PI * 2);
               if(dif > Math.PI)
               {
                  dif -= Math.PI * 2;
               }
               else if(dif < -Math.PI)
               {
                  dif += Math.PI * 2;
               }
               finalAngle += dif;
            }
            else if("rotation" in value)
            {
               finalAngle = typeof value.rotation == "number" ? value.rotation * _DEG2RAD : Number(value.rotation) * _DEG2RAD + angle;
            }
            finalSkewX = "skewX" in value ? (typeof value.skewX == "number" ? Number(value.skewX) * _DEG2RAD : Number(value.skewX) * _DEG2RAD + skewX) : 0;
            if("skewY" in value)
            {
               skewY = typeof value.skewY == "number" ? value.skewY * _DEG2RAD : Number(value.skewY) * _DEG2RAD - skewX;
               finalAngle += skewY + skewX;
               finalSkewX -= skewY;
            }
            if(finalAngle != angle)
            {
               if("rotation" in value || "shortRotation" in value)
               {
                  _angleChange = finalAngle - angle;
                  finalAngle = angle;
               }
               else
               {
                  matrix.rotate(finalAngle - angle);
               }
            }
            if("scale" in value)
            {
               ratioX = Number(value.scale) / scaleX;
               ratioY = Number(value.scale) / scaleY;
               if(typeof value.scale != "number")
               {
                  ratioX += 1;
                  ratioY += 1;
               }
            }
            else
            {
               if("scaleX" in value)
               {
                  ratioX = Number(value.scaleX) / scaleX;
                  if(typeof value.scaleX != "number")
                  {
                     ratioX += 1;
                  }
               }
               if("scaleY" in value)
               {
                  ratioY = Number(value.scaleY) / scaleY;
                  if(typeof value.scaleY != "number")
                  {
                     ratioY += 1;
                  }
               }
            }
            if(finalSkewX != skewX)
            {
               matrix.c = -scaleY * Math.sin(finalSkewX + finalAngle);
               matrix.d = scaleY * Math.cos(finalSkewX + finalAngle);
            }
            if("skewX2" in value)
            {
               if(typeof value.skewX2 == "number")
               {
                  matrix.c = Math.tan(0 - value.skewX2 * _DEG2RAD);
               }
               else
               {
                  matrix.c += Math.tan(0 - Number(value.skewX2) * _DEG2RAD);
               }
            }
            if("skewY2" in value)
            {
               if(typeof value.skewY2 == "number")
               {
                  matrix.b = Math.tan(value.skewY2 * _DEG2RAD);
               }
               else
               {
                  matrix.b += Math.tan(Number(value.skewY2) * _DEG2RAD);
               }
            }
            if(Boolean(ratioX) || ratioX == 0)
            {
               matrix.a *= ratioX;
               matrix.b *= ratioX;
            }
            if(Boolean(ratioY) || ratioY == 0)
            {
               matrix.c *= ratioY;
               matrix.d *= ratioY;
            }
            _aChange = matrix.a - _aStart;
            _bChange = matrix.b - _bStart;
            _cChange = matrix.c - _cStart;
            _dChange = matrix.d - _dStart;
         }
         return true;
      }
   }
}

