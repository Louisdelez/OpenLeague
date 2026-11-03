package blix.util.layout
{
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.assets.proxy.IDisplayChild;
   import flash.display.DisplayObject;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public final class MatrixUtils
   {
      
      public function MatrixUtils()
      {
         super();
      }
      
      public static function getBoundsAfterTransformation(param1:Rectangle, param2:Matrix) : Rectangle
      {
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         if(param2 == null)
         {
            return param1.clone();
         }
         var _loc3_:Number = param2.a;
         var _loc4_:Number = param2.b;
         var _loc5_:Number = param2.c;
         var _loc6_:Number = param2.d;
         if(_loc3_ == 1 && _loc4_ == 0 && _loc5_ == 0 && _loc6_ == 1)
         {
            return new Rectangle(param2.tx + param1.x,param2.ty + param1.y,param1.width,param1.height);
         }
         if(_loc3_ > 0)
         {
            if(_loc5_ > 0)
            {
               _loc7_ = param1.left * _loc3_ + param1.top * _loc5_;
            }
            else
            {
               _loc7_ = param1.left * _loc3_ + param1.bottom * _loc5_;
            }
         }
         else if(_loc5_ > 0)
         {
            _loc7_ = param1.right * _loc3_ + param1.top * _loc5_;
         }
         else
         {
            _loc7_ = param1.right * _loc3_ + param1.bottom * _loc5_;
         }
         if(_loc4_ > 0)
         {
            if(_loc6_ > 0)
            {
               _loc8_ = param1.left * _loc4_ + param1.top * _loc6_;
            }
            else
            {
               _loc8_ = param1.left * _loc4_ + param1.bottom * _loc6_;
            }
         }
         else if(_loc6_ > 0)
         {
            _loc8_ = param1.right * _loc4_ + param1.top * _loc6_;
         }
         else
         {
            _loc8_ = param1.right * _loc4_ + param1.bottom * _loc6_;
         }
         var _loc9_:Number = Math.abs(_loc3_ * param1.width) + Math.abs(_loc5_ * param1.height);
         var _loc10_:Number = Math.abs(_loc4_ * param1.width) + Math.abs(_loc6_ * param1.height);
         return new Rectangle(_loc7_ + param2.tx,_loc8_ + param2.ty,_loc9_,_loc10_);
      }
      
      public static function getSizeAfterTransformation(param1:Number, param2:Number, param3:Matrix) : Point
      {
         var _loc4_:Number = Math.abs(param3.a * param1) + Math.abs(param3.c * param2);
         var _loc5_:Number = Math.abs(param3.b * param1) + Math.abs(param3.d * param2);
         return new Point(_loc4_,_loc5_);
      }
      
      public static function getSizeBeforeTransformation(param1:Number, param2:Number, param3:Matrix) : Point
      {
         var _loc5_:Number = NaN;
         var _loc6_:Number = NaN;
         var _loc7_:Number = NaN;
         var _loc8_:Number = NaN;
         if(param3 == null || isNaN(param1) && isNaN(param2))
         {
            return new Point(param1,param2);
         }
         param3 = param3.clone();
         param3.invert();
         var _loc4_:Point = new Point(NaN,NaN);
         if(isNaN(param2))
         {
            _loc4_.x = param1 * param3.a;
         }
         else if(isNaN(param1))
         {
            _loc4_.y = param2 * param3.d;
         }
         else
         {
            _loc5_ = param1 * param3.a;
            _loc6_ = param2 * param3.c;
            _loc7_ = param2 * param3.d;
            _loc8_ = param1 * param3.b;
            _loc4_.x = Math.sqrt(_loc5_ * _loc5_ + _loc6_ * _loc6_);
            _loc4_.y = Math.sqrt(_loc7_ * _loc7_ + _loc8_ * _loc8_);
         }
         return _loc4_;
      }
      
      public static function createConversionMatrix(param1:DisplayObject, param2:DisplayObject) : Matrix
      {
         if(param2 == param1 || param2 == null || param1 == null)
         {
            return new Matrix();
         }
         var _loc3_:Matrix = param2.transform.concatenatedMatrix;
         var _loc4_:Matrix = param1.transform.concatenatedMatrix;
         if(_loc3_ == null || _loc4_ == null)
         {
            return new Matrix();
         }
         _loc4_.invert();
         _loc3_.concat(_loc4_);
         return _loc3_;
      }
      
      public static function createConversionMatrix2(param1:IDisplayChild, param2:IDisplayChild) : Matrix
      {
         return createConversionMatrix(param1.getAsset(),param2.getAsset());
      }
      
      public static function getTranslatedBounds(param1:DisplayObjectProxy, param2:DisplayObjectProxy) : Rectangle
      {
         var _loc3_:Matrix = createConversionMatrix(param2.getAsset(),param1.getAsset());
         return MatrixUtils.getBoundsAfterTransformation(param1.getUnscaledBounds(),_loc3_);
      }
      
      public static function convertPoint(param1:Point, param2:DisplayObject, param3:DisplayObject) : Point
      {
         if(param2 == null || param3 == null)
         {
            return param1.clone();
         }
         param1 = param2.localToGlobal(param1);
         return param3.globalToLocal(param1);
      }
   }
}

