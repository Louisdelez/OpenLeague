package blix.assets.proxy
{
   import blix.context.IContext;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   
   public class BitmapProxy extends DisplayObjectProxy
   {
      
      public function BitmapProxy(param1:IContext, param2:Bitmap = null)
      {
         super(param1,param2);
      }
      
      public function getBitmap() : Bitmap
      {
         return _asset as Bitmap;
      }
      
      public function getPixelSnapping() : String
      {
         return assetProxy.pixelSnapping;
      }
      
      public function setPixelSnapping(param1:String) : void
      {
         assetProxy.pixelSnapping = param1;
      }
      
      public function getSmoothing() : Boolean
      {
         return assetProxy.smoothing;
      }
      
      public function setSmoothing(param1:Boolean) : void
      {
         assetProxy.smoothing = param1;
      }
      
      public function getBitmapData() : BitmapData
      {
         return assetProxy.bitmapData;
      }
      
      public function setBitmapData(param1:BitmapData) : void
      {
         var _loc3_:Boolean = false;
         var _loc4_:String = null;
         var _loc2_:Bitmap = this.getBitmap();
         if(_loc2_ == null)
         {
            _loc2_ = new Bitmap();
            _loc2_.bitmapData = param1;
            setAsset(_loc2_);
         }
         else
         {
            _loc3_ = this.getSmoothing();
            _loc4_ = this.getPixelSnapping();
            _loc2_.bitmapData = param1;
            _loc2_.smoothing = _loc3_;
            _loc2_.pixelSnapping = _loc4_;
         }
         invalidateLayout();
      }
   }
}

