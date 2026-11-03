package spark.utils
{
   import flash.display.BitmapData;
   import flash.display.DisplayObject;
   import flash.display.IBitmapDrawable;
   import flash.geom.ColorTransform;
   import flash.geom.Matrix;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.core.IUIComponent;
   import mx.utils.MatrixUtil;
   
   public class BitmapUtil
   {
      
      §§namespace("http://www.adobe.com/2006/flex/mx/internal") static const VERSION:String = "4.6.0.23201";
      
      public function BitmapUtil()
      {
         super();
      }
      
      public static function getSnapshotWithPadding(target:IUIComponent, padding:int = 4, propagateColorTransform:Boolean = false, bounds:Rectangle = null) : BitmapData
      {
         var width:Number = Number(target.width);
         var height:Number = Number(target.height);
         var m:Matrix = MatrixUtil.getConcatenatedComputedMatrix(target as DisplayObject,null);
         var position:Point = new Point(-padding,-padding);
         var size:Point = MatrixUtil.transformBounds(width + padding * 2,height + padding * 2,m,position);
         position.x = Math.floor(position.x);
         position.y = Math.floor(position.y);
         m.translate(-position.x,-position.y);
         if(!bounds)
         {
            bounds = new Rectangle();
         }
         bounds.x = position.x;
         bounds.y = position.y;
         bounds.width = Math.ceil(size.x);
         bounds.height = Math.ceil(size.y);
         var bmpData:BitmapData = new BitmapData(bounds.width,bounds.height,true,0);
         bmpData.draw(IBitmapDrawable(target),m,propagateColorTransform ? target.transform.colorTransform : null);
         return bmpData;
      }
      
      public static function getSnapshot(target:IUIComponent, visibleBounds:Rectangle = null, propagateColorTransform:Boolean = false) : BitmapData
      {
         var m:Matrix = MatrixUtil.getConcatenatedComputedMatrix(target as DisplayObject,null);
         var bounds:Rectangle = getRealBounds(DisplayObject(target),m);
         if(visibleBounds != null)
         {
            visibleBounds.x = bounds.x - target.x;
            visibleBounds.y = bounds.y - target.y;
            visibleBounds.width = bounds.width;
            visibleBounds.height = bounds.height;
         }
         if(bounds.width == 0 || bounds.height == 0)
         {
            return null;
         }
         if(Boolean(m))
         {
            m.translate(-Math.floor(bounds.x),-Math.floor(bounds.y));
         }
         var bmData:BitmapData = new BitmapData(bounds.width,bounds.height,true,0);
         bmData.draw(IBitmapDrawable(target),m,propagateColorTransform ? target.transform.colorTransform : null);
         return bmData;
      }
      
      private static function getRealBounds(targ:DisplayObject, m:Matrix = null, padding:int = 10) : Rectangle
      {
         var newPadding:int = 0;
         var bitmap:BitmapData = new BitmapData(targ.width + 2 * padding,targ.height + 2 * padding,true,0);
         if(!m)
         {
            m = new Matrix();
         }
         var tx:Number = m.tx;
         var ty:Number = m.ty;
         m.translate(-tx + padding,-ty + padding);
         var tmpOpaqueBackground:Object = targ.opaqueBackground;
         targ.opaqueBackground = 4294967295;
         bitmap.draw(targ,m);
         m.translate(tx - padding,ty - padding);
         targ.opaqueBackground = tmpOpaqueBackground;
         var actualBounds:Rectangle = bitmap.getColorBoundsRect(4278190080,0,false);
         if(actualBounds.width == 0 || actualBounds.height == 0 || actualBounds.x > 0 && actualBounds.y > 0 && actualBounds.right < bitmap.width && actualBounds.bottom < bitmap.height)
         {
            actualBounds.x = actualBounds.x + tx - padding;
            actualBounds.y = actualBounds.y + ty - padding;
            bitmap.dispose();
            return actualBounds;
         }
         newPadding = padding == 0 ? 10 : int(2 * padding);
         bitmap.dispose();
         return getRealBounds(targ,m,newPadding);
      }
   }
}

