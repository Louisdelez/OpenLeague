package com.riotgames.platform.gameclient.views.game.common
{
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.display.PixelSnapping;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.events.SecurityErrorEvent;
   import flash.filesystem.File;
   import flash.geom.Rectangle;
   import flash.net.URLRequest;
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class ImageCacheEntry
   {
      
      private static const CROP_ICON_WIDTH:Number = 120;
      
      private static const CROP_ICON_HEIGHT:Number = 120;
      
      private var _bitmap:Bitmap;
      
      private var _callbacks:Vector.<Function>;
      
      private var _cropToIconAspect:Boolean;
      
      private var _imagePath:String;
      
      private var _isLoaded:Boolean = false;
      
      private var _logger:ILogger;
      
      private var _fileReference:File;
      
      private var _loader:Loader;
      
      public function ImageCacheEntry(param1:String, param2:Boolean = false)
      {
         super();
         this._logger = Log.getLogger("com.riotgames.platform.gameclient.views.game.common.ImageCacheEntry");
         this._imagePath = param1;
         this._callbacks = new Vector.<Function>();
         this._loader = new Loader();
         this._cropToIconAspect = param2;
      }
      
      private function checkFileExistence(param1:String) : String
      {
         this._fileReference = File.applicationDirectory.resolvePath(param1);
         if(!this._fileReference.exists)
         {
            this._logger.error("Unable to verify existence of file in file system with supplied path: " + param1);
            return "";
         }
         return "./" + param1;
      }
      
      public function addCallback(param1:Function) : void
      {
         this._callbacks.push(param1);
      }
      
      private function onSecurityError(param1:SecurityErrorEvent) : void
      {
         this.resolveImageLoadFail(param1.errorID,param1.text);
      }
      
      private function cropAndResizeBitmap() : void
      {
         var _loc1_:Number = CROP_ICON_WIDTH / this._bitmap.width;
         this._bitmap.scaleX = this._bitmap.scaleY = _loc1_;
         var _loc2_:BitmapData = new BitmapData(CROP_ICON_WIDTH,CROP_ICON_HEIGHT,false);
         _loc2_.draw(this._bitmap,this._bitmap.transform.matrix,null,null,new Rectangle(0,0,CROP_ICON_WIDTH,CROP_ICON_HEIGHT),true);
         this._bitmap.bitmapData.dispose();
         this._bitmap = new Bitmap(_loc2_,PixelSnapping.AUTO,true);
      }
      
      public function isLoaded() : Boolean
      {
         return this._isLoaded;
      }
      
      private function resolveImageLoadFail(param1:Number, param2:String) : void
      {
         this.cleanLoadListeners();
         this._logger.error("Unable to load requested image at requested path: " + this._imagePath + ", errorID: " + param1.toString() + ", errorText: " + param2);
         this.sendEmptyBitmap();
      }
      
      private function sendBitmap(param1:Bitmap) : void
      {
         var _loc3_:Function = null;
         var _loc2_:int = 0;
         while(_loc2_ < this._callbacks.length)
         {
            _loc3_ = this._callbacks[_loc2_];
            _loc3_.call(this,param1);
            _loc2_++;
         }
      }
      
      private function onLoadError(param1:IOErrorEvent) : void
      {
         this.resolveImageLoadFail(param1.errorID,param1.text);
      }
      
      public function getBitmap() : Bitmap
      {
         return this._bitmap;
      }
      
      private function sendEmptyBitmap() : void
      {
         this._bitmap = new Bitmap();
         this.sendBitmap(this._bitmap);
      }
      
      public function loadBitmap() : void
      {
         var _loc1_:String = this.checkFileExistence(this._imagePath);
         if(_loc1_ != "")
         {
            this.setupLoadListeners();
            this._loader.load(new URLRequest(_loc1_));
         }
         else
         {
            this.sendEmptyBitmap();
         }
      }
      
      private function cleanLoadListeners() : void
      {
         this._loader.contentLoaderInfo.removeEventListener(Event.COMPLETE,this.onLoadComplete,false);
         this._loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR,this.onLoadError,false);
         this._loader.contentLoaderInfo.removeEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError,false);
      }
      
      private function setupLoadListeners() : void
      {
         this._loader.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoadComplete,false,0,true);
         this._loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,this.onLoadError,false,0,true);
         this._loader.contentLoaderInfo.addEventListener(SecurityErrorEvent.SECURITY_ERROR,this.onSecurityError,false,0,true);
      }
      
      private function onLoadComplete(param1:Event) : void
      {
         this._isLoaded = true;
         this._bitmap = this._loader.contentLoaderInfo.content as Bitmap;
         if(this._cropToIconAspect)
         {
            this.cropAndResizeBitmap();
         }
         this.sendBitmap(this._bitmap);
      }
   }
}

