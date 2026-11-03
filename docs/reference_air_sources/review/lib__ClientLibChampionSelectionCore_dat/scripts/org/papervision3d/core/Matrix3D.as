package org.papervision3d.core
{
   public class Matrix3D
   {
      
      private static var toDEGREES:Number = 180 / Math.PI;
      
      private static var toRADIANS:Number = Math.PI / 180;
      
      public var n31:Number;
      
      public var n32:Number;
      
      public var n11:Number;
      
      public var n13:Number;
      
      public var n14:Number;
      
      public var n33:Number;
      
      public var n12:Number;
      
      public var n21:Number;
      
      public var n22:Number;
      
      public var n23:Number;
      
      public var n24:Number;
      
      public var n34:Number;
      
      public function Matrix3D(args:Array = null)
      {
         super();
         if(!args || args.length < 12)
         {
            n11 = n22 = n33 = 1;
            n12 = n13 = n14 = n21 = n23 = n24 = n31 = n32 = n34 = 0;
         }
         else
         {
            n11 = args[0];
            n12 = args[1];
            n13 = args[2];
            n14 = args[3];
            n21 = args[4];
            n22 = args[5];
            n23 = args[6];
            n24 = args[7];
            n31 = args[8];
            n32 = args[9];
            n33 = args[10];
            n34 = args[11];
         }
      }
      
      public static function rotationMatrixWithReference(axis:Number3D, rad:Number, ref:Number3D) : Matrix3D
      {
         var m:Matrix3D = null;
         m = Matrix3D.translationMatrix(ref.x,-ref.y,ref.z);
         m.calculateMultiply(m,Matrix3D.rotationMatrix(axis.x,axis.y,axis.z,rad));
         m.calculateMultiply(m,Matrix3D.translationMatrix(-ref.x,ref.y,-ref.z));
         return m;
      }
      
      public static function multiplyVector3x3(m:Matrix3D, v:Number3D) : void
      {
         var vx:Number = NaN;
         var vy:Number = NaN;
         var vz:Number = NaN;
         vx = v.x;
         vy = v.y;
         vz = v.z;
         v.x = vx * m.n11 + vy * m.n12 + vz * m.n13;
         v.y = vx * m.n21 + vy * m.n22 + vz * m.n23;
         v.z = vx * m.n31 + vy * m.n32 + vz * m.n33;
      }
      
      public static function multiply3x3(a:Matrix3D, b:Matrix3D) : Matrix3D
      {
         var m:Matrix3D = null;
         m = new Matrix3D();
         m.calculateMultiply3x3(a,b);
         return m;
      }
      
      public static function normalizeQuaternion(q:Object) : Object
      {
         var mag:Number = NaN;
         mag = magnitudeQuaternion(q);
         q.x /= mag;
         q.y /= mag;
         q.z /= mag;
         q.w /= mag;
         return q;
      }
      
      public static function multiplyVector(m:Matrix3D, v:Number3D) : void
      {
         var vx:Number = NaN;
         var vy:Number = NaN;
         var vz:Number = NaN;
         vx = v.x;
         vy = v.y;
         vz = v.z;
         v.x = vx * m.n11 + vy * m.n12 + vz * m.n13 + m.n14;
         v.y = vx * m.n21 + vy * m.n22 + vz * m.n23 + m.n24;
         v.z = vx * m.n31 + vy * m.n32 + vz * m.n33 + m.n34;
      }
      
      public static function axis2quaternion(x:Number, y:Number, z:Number, angle:Number) : Object
      {
         var sin:Number = NaN;
         var cos:Number = NaN;
         var q:Object = null;
         sin = Math.sin(angle / 2);
         cos = Math.cos(angle / 2);
         q = new Object();
         q.x = x * sin;
         q.y = y * sin;
         q.z = z * sin;
         q.w = cos;
         return normalizeQuaternion(q);
      }
      
      public static function translationMatrix(x:Number, y:Number, z:Number) : Matrix3D
      {
         var m:Matrix3D = null;
         m = IDENTITY;
         m.n14 = x;
         m.n24 = y;
         m.n34 = z;
         return m;
      }
      
      public static function magnitudeQuaternion(q:Object) : Number
      {
         return Math.sqrt(q.w * q.w + q.x * q.x + q.y * q.y + q.z * q.z);
      }
      
      public static function euler2quaternion(ax:Number, ay:Number, az:Number) : Object
      {
         var fSinPitch:Number = NaN;
         var fCosPitch:Number = NaN;
         var fSinYaw:Number = NaN;
         var fCosYaw:Number = NaN;
         var fSinRoll:Number = NaN;
         var fCosRoll:Number = NaN;
         var fCosPitchCosYaw:Number = NaN;
         var fSinPitchSinYaw:Number = NaN;
         var q:Object = null;
         fSinPitch = Math.sin(ax * 0.5);
         fCosPitch = Math.cos(ax * 0.5);
         fSinYaw = Math.sin(ay * 0.5);
         fCosYaw = Math.cos(ay * 0.5);
         fSinRoll = Math.sin(az * 0.5);
         fCosRoll = Math.cos(az * 0.5);
         fCosPitchCosYaw = fCosPitch * fCosYaw;
         fSinPitchSinYaw = fSinPitch * fSinYaw;
         q = new Object();
         q.x = fSinRoll * fCosPitchCosYaw - fCosRoll * fSinPitchSinYaw;
         q.y = fCosRoll * fSinPitch * fCosYaw + fSinRoll * fCosPitch * fSinYaw;
         q.z = fCosRoll * fCosPitch * fSinYaw - fSinRoll * fSinPitch * fCosYaw;
         q.w = fCosRoll * fCosPitchCosYaw + fSinRoll * fSinPitchSinYaw;
         return q;
      }
      
      public static function rotationX(rad:Number) : Matrix3D
      {
         var m:Matrix3D = null;
         var c:Number = NaN;
         var s:Number = NaN;
         m = IDENTITY;
         c = Math.cos(rad);
         s = Math.sin(rad);
         m.n22 = c;
         m.n23 = -s;
         m.n32 = s;
         m.n33 = c;
         return m;
      }
      
      public static function rotationY(rad:Number) : Matrix3D
      {
         var m:Matrix3D = null;
         var c:Number = NaN;
         var s:Number = NaN;
         m = IDENTITY;
         c = Math.cos(rad);
         s = Math.sin(rad);
         m.n11 = c;
         m.n13 = -s;
         m.n31 = s;
         m.n33 = c;
         return m;
      }
      
      public static function rotationZ(rad:Number) : Matrix3D
      {
         var m:Matrix3D = null;
         var c:Number = NaN;
         var s:Number = NaN;
         m = IDENTITY;
         c = Math.cos(rad);
         s = Math.sin(rad);
         m.n11 = c;
         m.n12 = -s;
         m.n21 = s;
         m.n22 = c;
         return m;
      }
      
      public static function clone(m:Matrix3D) : Matrix3D
      {
         return new Matrix3D([m.n11,m.n12,m.n13,m.n14,m.n21,m.n22,m.n23,m.n24,m.n31,m.n32,m.n33,m.n34]);
      }
      
      public static function rotationMatrix(x:Number, y:Number, z:Number, rad:Number) : Matrix3D
      {
         var m:Matrix3D = null;
         var nCos:Number = NaN;
         var nSin:Number = NaN;
         var scos:Number = NaN;
         var sxy:Number = NaN;
         var syz:Number = NaN;
         var sxz:Number = NaN;
         var sz:Number = NaN;
         var sy:Number = NaN;
         var sx:Number = NaN;
         m = IDENTITY;
         nCos = Math.cos(rad);
         nSin = Math.sin(rad);
         scos = 1 - nCos;
         sxy = x * y * scos;
         syz = y * z * scos;
         sxz = x * z * scos;
         sz = nSin * z;
         sy = nSin * y;
         sx = nSin * x;
         m.n11 = nCos + x * x * scos;
         m.n12 = -sz + sxy;
         m.n13 = sy + sxz;
         m.n21 = sz + sxy;
         m.n22 = nCos + y * y * scos;
         m.n23 = -sx + syz;
         m.n31 = -sy + sxz;
         m.n32 = sx + syz;
         m.n33 = nCos + z * z * scos;
         return m;
      }
      
      public static function add(a:Matrix3D, b:Matrix3D) : Matrix3D
      {
         var m:Matrix3D = null;
         m = new Matrix3D();
         m.calculateAdd(a,b);
         return m;
      }
      
      public static function rotateAxis(m:Matrix3D, v:Number3D) : void
      {
         var vx:Number = NaN;
         var vy:Number = NaN;
         var vz:Number = NaN;
         vx = v.x;
         vy = v.y;
         vz = v.z;
         v.x = vx * m.n11 + vy * m.n12 + vz * m.n13;
         v.y = vx * m.n21 + vy * m.n22 + vz * m.n23;
         v.z = vx * m.n31 + vy * m.n32 + vz * m.n33;
         v.normalize();
      }
      
      public static function multiply(a:Matrix3D, b:Matrix3D) : Matrix3D
      {
         var m:Matrix3D = null;
         m = new Matrix3D();
         m.calculateMultiply(a,b);
         return m;
      }
      
      public static function multiplyQuaternion(a:Object, b:Object) : Object
      {
         var ax:Number = NaN;
         var ay:Number = NaN;
         var az:Number = NaN;
         var aw:Number = NaN;
         var bx:Number = NaN;
         var by:Number = NaN;
         var bz:Number = NaN;
         var bw:Number = NaN;
         var q:Object = null;
         ax = Number(a.x);
         ay = Number(a.y);
         az = Number(a.z);
         aw = Number(a.w);
         bx = Number(b.x);
         by = Number(b.y);
         bz = Number(b.z);
         bw = Number(b.w);
         q = new Object();
         q.x = aw * bx + ax * bw + ay * bz - az * by;
         q.y = aw * by + ay * bw + az * bx - ax * bz;
         q.z = aw * bz + az * bw + ax * by - ay * bx;
         q.w = aw * bw - ax * bx - ay * by - az * bz;
         return q;
      }
      
      public static function euler2matrix(deg:Number3D) : Matrix3D
      {
         var m:Matrix3D = null;
         var ax:Number = NaN;
         var ay:Number = NaN;
         var az:Number = NaN;
         var a:Number = NaN;
         var b:Number = NaN;
         var c:Number = NaN;
         var d:Number = NaN;
         var e:Number = NaN;
         var f:Number = NaN;
         var ad:Number = NaN;
         var bd:Number = NaN;
         m = IDENTITY;
         ax = deg.x * toRADIANS;
         ay = deg.y * toRADIANS;
         az = deg.z * toRADIANS;
         a = Math.cos(ax);
         b = Math.sin(ax);
         c = Math.cos(ay);
         d = Math.sin(ay);
         e = Math.cos(az);
         f = Math.sin(az);
         ad = a * d;
         bd = b * d;
         m.n11 = c * e;
         m.n12 = -c * f;
         m.n13 = d;
         m.n21 = bd * e + a * f;
         m.n22 = -bd * f + a * e;
         m.n23 = -b * c;
         m.n31 = -ad * e + b * f;
         m.n32 = ad * f + b * e;
         m.n33 = a * c;
         return m;
      }
      
      public static function scaleMatrix(x:Number, y:Number, z:Number) : Matrix3D
      {
         var m:Matrix3D = null;
         m = IDENTITY;
         m.n11 = x;
         m.n22 = y;
         m.n33 = z;
         return m;
      }
      
      public static function quaternion2matrix(x:Number, y:Number, z:Number, w:Number) : Matrix3D
      {
         var xx:Number = NaN;
         var xy:Number = NaN;
         var xz:Number = NaN;
         var xw:Number = NaN;
         var yy:Number = NaN;
         var yz:Number = NaN;
         var yw:Number = NaN;
         var zz:Number = NaN;
         var zw:Number = NaN;
         var m:Matrix3D = null;
         xx = x * x;
         xy = x * y;
         xz = x * z;
         xw = x * w;
         yy = y * y;
         yz = y * z;
         yw = y * w;
         zz = z * z;
         zw = z * w;
         m = IDENTITY;
         m.n11 = 1 - 2 * (yy + zz);
         m.n12 = 2 * (xy - zw);
         m.n13 = 2 * (xz + yw);
         m.n21 = 2 * (xy + zw);
         m.n22 = 1 - 2 * (xx + zz);
         m.n23 = 2 * (yz - xw);
         m.n31 = 2 * (xz - yw);
         m.n32 = 2 * (yz + xw);
         m.n33 = 1 - 2 * (xx + yy);
         return m;
      }
      
      public static function inverse(m:Matrix3D) : Matrix3D
      {
         var inv:Matrix3D = null;
         inv = new Matrix3D();
         inv.calculateInverse(m);
         return inv;
      }
      
      public static function matrix2euler(t:Matrix3D) : Number3D
      {
         var rot:Number3D = null;
         var i:Number3D = null;
         var j:Number3D = null;
         var k:Number3D = null;
         var m:Matrix3D = null;
         var rx:Matrix3D = null;
         var n:Matrix3D = null;
         var cy:Number = NaN;
         rot = new Number3D();
         i = new Number3D(t.n11,t.n21,t.n31);
         j = new Number3D(t.n12,t.n22,t.n32);
         k = new Number3D(t.n13,t.n23,t.n33);
         i.normalize();
         j.normalize();
         k.normalize();
         m = new Matrix3D([i.x,j.x,k.x,0,i.y,j.y,k.y,0,i.z,j.z,k.z,0]);
         rot.x = Math.atan2(m.n23,m.n33);
         rx = Matrix3D.rotationX(-rot.x);
         n = Matrix3D.multiply(rx,m);
         cy = Math.sqrt(n.n11 * n.n11 + n.n21 * n.n21);
         rot.y = Math.atan2(-n.n31,cy);
         rot.z = Math.atan2(-n.n12,n.n11);
         if(rot.x == Math.PI)
         {
            if(rot.y > 0)
            {
               rot.y -= Math.PI;
            }
            else
            {
               rot.y += Math.PI;
            }
            rot.x = 0;
            rot.z += Math.PI;
         }
         rot.x *= toDEGREES;
         rot.y *= toDEGREES;
         rot.z *= toDEGREES;
         return rot;
      }
      
      public static function get IDENTITY() : Matrix3D
      {
         return new Matrix3D([1,0,0,0,0,1,0,0,0,0,1,0]);
      }
      
      public function calculateMultiply3x3(a:Matrix3D, b:Matrix3D) : void
      {
         var a11:Number = NaN;
         var b11:Number = NaN;
         var a21:Number = NaN;
         var b21:Number = NaN;
         var a31:Number = NaN;
         var b31:Number = NaN;
         var a12:Number = NaN;
         var b12:Number = NaN;
         var a22:Number = NaN;
         var b22:Number = NaN;
         var a32:Number = NaN;
         var b32:Number = NaN;
         var a13:Number = NaN;
         var b13:Number = NaN;
         var a23:Number = NaN;
         var b23:Number = NaN;
         var a33:Number = NaN;
         var b33:Number = NaN;
         a11 = a.n11;
         b11 = b.n11;
         a21 = a.n21;
         b21 = b.n21;
         a31 = a.n31;
         b31 = b.n31;
         a12 = a.n12;
         b12 = b.n12;
         a22 = a.n22;
         b22 = b.n22;
         a32 = a.n32;
         b32 = b.n32;
         a13 = a.n13;
         b13 = b.n13;
         a23 = a.n23;
         b23 = b.n23;
         a33 = a.n33;
         b33 = b.n33;
         this.n11 = a11 * b11 + a12 * b21 + a13 * b31;
         this.n12 = a11 * b12 + a12 * b22 + a13 * b32;
         this.n13 = a11 * b13 + a12 * b23 + a13 * b33;
         this.n21 = a21 * b11 + a22 * b21 + a23 * b31;
         this.n22 = a21 * b12 + a22 * b22 + a23 * b32;
         this.n23 = a21 * b13 + a22 * b23 + a23 * b33;
         this.n31 = a31 * b11 + a32 * b21 + a33 * b31;
         this.n32 = a31 * b12 + a32 * b22 + a33 * b32;
         this.n33 = a31 * b13 + a32 * b23 + a33 * b33;
      }
      
      public function get trace() : Number
      {
         return this.n11 + this.n22 + this.n33 + 1;
      }
      
      public function get det() : Number
      {
         return (this.n11 * this.n22 - this.n21 * this.n12) * this.n33 - (this.n11 * this.n32 - this.n31 * this.n12) * this.n23 + (this.n21 * this.n32 - this.n31 * this.n22) * this.n13;
      }
      
      public function copy3x3(m:Matrix3D) : Matrix3D
      {
         this.n11 = m.n11;
         this.n12 = m.n12;
         this.n13 = m.n13;
         this.n21 = m.n21;
         this.n22 = m.n22;
         this.n23 = m.n23;
         this.n31 = m.n31;
         this.n32 = m.n32;
         this.n33 = m.n33;
         return this;
      }
      
      public function calculateAdd(a:Matrix3D, b:Matrix3D) : void
      {
         this.n11 = a.n11 + b.n11;
         this.n12 = a.n12 + b.n12;
         this.n13 = a.n13 + b.n13;
         this.n14 = a.n14 + b.n14;
         this.n21 = a.n21 + b.n21;
         this.n22 = a.n22 + b.n22;
         this.n23 = a.n23 + b.n23;
         this.n24 = a.n24 + b.n24;
         this.n31 = a.n31 + b.n31;
         this.n32 = a.n32 + b.n32;
         this.n33 = a.n33 + b.n33;
         this.n34 = a.n34 + b.n34;
      }
      
      public function calculateMultiply(a:Matrix3D, b:Matrix3D) : void
      {
         var a11:Number = NaN;
         var b11:Number = NaN;
         var a21:Number = NaN;
         var b21:Number = NaN;
         var a31:Number = NaN;
         var b31:Number = NaN;
         var a12:Number = NaN;
         var b12:Number = NaN;
         var a22:Number = NaN;
         var b22:Number = NaN;
         var a32:Number = NaN;
         var b32:Number = NaN;
         var a13:Number = NaN;
         var b13:Number = NaN;
         var a23:Number = NaN;
         var b23:Number = NaN;
         var a33:Number = NaN;
         var b33:Number = NaN;
         var a14:Number = NaN;
         var b14:Number = NaN;
         var a24:Number = NaN;
         var b24:Number = NaN;
         var a34:Number = NaN;
         var b34:Number = NaN;
         a11 = a.n11;
         b11 = b.n11;
         a21 = a.n21;
         b21 = b.n21;
         a31 = a.n31;
         b31 = b.n31;
         a12 = a.n12;
         b12 = b.n12;
         a22 = a.n22;
         b22 = b.n22;
         a32 = a.n32;
         b32 = b.n32;
         a13 = a.n13;
         b13 = b.n13;
         a23 = a.n23;
         b23 = b.n23;
         a33 = a.n33;
         b33 = b.n33;
         a14 = a.n14;
         b14 = b.n14;
         a24 = a.n24;
         b24 = b.n24;
         a34 = a.n34;
         b34 = b.n34;
         this.n11 = a11 * b11 + a12 * b21 + a13 * b31;
         this.n12 = a11 * b12 + a12 * b22 + a13 * b32;
         this.n13 = a11 * b13 + a12 * b23 + a13 * b33;
         this.n14 = a11 * b14 + a12 * b24 + a13 * b34 + a14;
         this.n21 = a21 * b11 + a22 * b21 + a23 * b31;
         this.n22 = a21 * b12 + a22 * b22 + a23 * b32;
         this.n23 = a21 * b13 + a22 * b23 + a23 * b33;
         this.n24 = a21 * b14 + a22 * b24 + a23 * b34 + a24;
         this.n31 = a31 * b11 + a32 * b21 + a33 * b31;
         this.n32 = a31 * b12 + a32 * b22 + a33 * b32;
         this.n33 = a31 * b13 + a32 * b23 + a33 * b33;
         this.n34 = a31 * b14 + a32 * b24 + a33 * b34 + a34;
      }
      
      public function toString() : String
      {
         var s:String = null;
         s = "";
         s += int(n11 * 1000) / 1000 + "\t\t" + int(n12 * 1000) / 1000 + "\t\t" + int(n13 * 1000) / 1000 + "\t\t" + int(n14 * 1000) / 1000 + "\n";
         s += int(n21 * 1000) / 1000 + "\t\t" + int(n22 * 1000) / 1000 + "\t\t" + int(n23 * 1000) / 1000 + "\t\t" + int(n24 * 1000) / 1000 + "\n";
         return s + (int(n31 * 1000) / 1000 + "\t\t" + int(n32 * 1000) / 1000 + "\t\t" + int(n33 * 1000) / 1000 + "\t\t" + int(n34 * 1000) / 1000 + "\n");
      }
      
      public function copy(m:Matrix3D) : Matrix3D
      {
         this.n11 = m.n11;
         this.n12 = m.n12;
         this.n13 = m.n13;
         this.n14 = m.n14;
         this.n21 = m.n21;
         this.n22 = m.n22;
         this.n23 = m.n23;
         this.n24 = m.n24;
         this.n31 = m.n31;
         this.n32 = m.n32;
         this.n33 = m.n33;
         this.n34 = m.n34;
         return this;
      }
      
      public function calculateInverse(m:Matrix3D) : void
      {
         var d:Number = NaN;
         var m11:Number = NaN;
         var m21:Number = NaN;
         var m31:Number = NaN;
         var m12:Number = NaN;
         var m22:Number = NaN;
         var m32:Number = NaN;
         var m13:Number = NaN;
         var m23:Number = NaN;
         var m33:Number = NaN;
         var m14:Number = NaN;
         var m24:Number = NaN;
         var m34:Number = NaN;
         d = m.det;
         if(Math.abs(d) > 0.001)
         {
            d = 1 / d;
            m11 = m.n11;
            m21 = m.n21;
            m31 = m.n31;
            m12 = m.n12;
            m22 = m.n22;
            m32 = m.n32;
            m13 = m.n13;
            m23 = m.n23;
            m33 = m.n33;
            m14 = m.n14;
            m24 = m.n24;
            m34 = m.n34;
            this.n11 = d * (m22 * m33 - m32 * m23);
            this.n12 = -d * (m12 * m33 - m32 * m13);
            this.n13 = d * (m12 * m23 - m22 * m13);
            this.n14 = -d * (m12 * (m23 * m34 - m33 * m24) - m22 * (m13 * m34 - m33 * m14) + m32 * (m13 * m24 - m23 * m14));
            this.n21 = -d * (m21 * m33 - m31 * m23);
            this.n22 = d * (m11 * m33 - m31 * m13);
            this.n23 = -d * (m11 * m23 - m21 * m13);
            this.n24 = d * (m11 * (m23 * m34 - m33 * m24) - m21 * (m13 * m34 - m33 * m14) + m31 * (m13 * m24 - m23 * m14));
            this.n31 = d * (m21 * m32 - m31 * m22);
            this.n32 = -d * (m11 * m32 - m31 * m12);
            this.n33 = d * (m11 * m22 - m21 * m12);
            this.n34 = -d * (m11 * (m22 * m34 - m32 * m24) - m21 * (m12 * m34 - m32 * m14) + m31 * (m12 * m24 - m22 * m14));
         }
      }
   }
}

