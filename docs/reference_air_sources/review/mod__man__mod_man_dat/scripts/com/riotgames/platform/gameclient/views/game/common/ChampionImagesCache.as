package com.riotgames.platform.gameclient.views.game.common
{
   import com.riotgames.platform.common.provider.IChampionImagesProvider;
   import flash.display.Bitmap;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.events.Event;
   import flash.events.IOErrorEvent;
   import flash.net.URLRequest;
   import flash.utils.Dictionary;
   
   public class ChampionImagesCache implements IChampionImagesProvider
   {
      
      private static var _instance:IChampionImagesProvider;
      
      protected static var cachedImages:Dictionary = new Dictionary();
      
      public function ChampionImagesCache(param1:SingletonEnforcer)
      {
         super();
      }
      
      public static function get instance() : IChampionImagesProvider
      {
         if(!_instance)
         {
            _instance = new ChampionImagesCache(new SingletonEnforcer());
         }
         return _instance;
      }
      
      private function duplicateBitmap(param1:Bitmap) : Bitmap
      {
         return new Bitmap(param1.bitmapData,"auto",true);
      }
      
      public function getIcon(param1:String, param2:Number, param3:Function) : void
      {
         var key:String = null;
         var path:String = null;
         var loader:Loader = null;
         var onLoadComplete:Function = null;
         var onLoadError:Function = null;
         var championSkinName:String = param1;
         var championSkinIndex:Number = param2;
         var callback:Function = param3;
         key = championSkinName + championSkinIndex;
         if(cachedImages[key] is Bitmap)
         {
            callback(this.duplicateBitmap(cachedImages[key]));
         }
         else if(cachedImages[key] is Object)
         {
            cachedImages[key].callbacks.push(callback);
         }
         else
         {
            path = ChampionImages.getIconPath(championSkinName,championSkinIndex);
            loader = new Loader();
            cachedImages[key] = {
               "loader":loader,
               "callbacks":[callback]
            };
            onLoadComplete = function(param1:Event):void
            {
               var _loc5_:Function = null;
               var _loc2_:LoaderInfo = param1.currentTarget as LoaderInfo;
               var _loc3_:Array = cachedImages[key].callbacks;
               var _loc4_:Bitmap = _loc2_.content as Bitmap;
               cachedImages[key] = _loc4_;
               for each(_loc5_ in _loc3_)
               {
                  _loc5_(duplicateBitmap(_loc4_));
               }
            };
            onLoadError = function(param1:Event):void
            {
               var _loc4_:Function = null;
               var _loc2_:Array = cachedImages[key].callbacks;
               var _loc3_:Bitmap = new Bitmap();
               cachedImages[key] = _loc3_;
               for each(_loc4_ in _loc2_)
               {
                  _loc4_(_loc3_);
               }
            };
            loader.contentLoaderInfo.addEventListener(Event.COMPLETE,onLoadComplete);
            loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR,onLoadError);
            loader.load(new URLRequest(path));
         }
      }
   }
}

class SingletonEnforcer
{
   
   public function SingletonEnforcer()
   {
      super();
   }
}
