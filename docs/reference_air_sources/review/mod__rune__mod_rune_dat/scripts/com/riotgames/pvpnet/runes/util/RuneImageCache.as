package com.riotgames.pvpnet.runes.util
{
   import com.riotgames.platform.gameclient.domain.Rune;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.Loader;
   import flash.display.LoaderInfo;
   import flash.events.Event;
   import flash.net.URLRequest;
   import flash.utils.Dictionary;
   
   public class RuneImageCache
   {
      
      private static const RUNE_IMAGES_FOLDER:String = "/assets/images/runes/";
      
      private static const DISABLED_QUINTESSENCE_NAME:String = "runeTargetDisabledLarge";
      
      private var _cachedBitmapsByRunePath:Dictionary;
      
      private var _runeDictionary:Dictionary;
      
      private var pendingLookups:Dictionary;
      
      public function RuneImageCache()
      {
         super();
         this._cachedBitmapsByRunePath = new Dictionary();
         this.pendingLookups = new Dictionary();
      }
      
      public static function getEmptyQuintessenceImage(param1:int) : String
      {
         return RUNE_IMAGES_FOLDER + DISABLED_QUINTESSENCE_NAME + param1 + ".png";
      }
      
      public static function getRuneImagePath(param1:uint, param2:Dictionary) : String
      {
         if(param2[param1] != null)
         {
            return RUNE_IMAGES_FOLDER + param2[param1].imagePath;
         }
         return null;
      }
      
      public function setRuneDictionary(param1:Dictionary) : void
      {
         this._runeDictionary = param1;
      }
      
      public function loadBitmapByRune(param1:Rune, param2:Function) : void
      {
         if(param1 == null || this._runeDictionary == null)
         {
            param2(null);
         }
         var _loc3_:String = getRuneImagePath(param1.itemId,this._runeDictionary);
         var _loc4_:BitmapData = this._cachedBitmapsByRunePath[_loc3_];
         if(_loc4_ != null)
         {
            param2(_loc4_);
         }
         else
         {
            this.getUncachedBitmapData(_loc3_,param2);
         }
      }
      
      private function getUncachedBitmapData(param1:String, param2:Function) : void
      {
         var _loc5_:Vector.<Function> = null;
         if(this.pendingLookups[param1] != null)
         {
            this.pendingLookups[param1].push(param2);
         }
         else
         {
            _loc5_ = new Vector.<Function>();
            _loc5_.push(param2);
            this.pendingLookups[param1] = _loc5_;
         }
         var _loc3_:Loader = new Loader();
         var _loc4_:URLRequest = new URLRequest(param1);
         _loc3_.load(_loc4_);
         _loc3_.contentLoaderInfo.addEventListener(Event.COMPLETE,this.onLoaderComplete);
      }
      
      private function onLoaderComplete(param1:Event) : void
      {
         var _loc5_:Function = null;
         var _loc2_:BitmapData = Bitmap(LoaderInfo(param1.target).content).bitmapData;
         var _loc3_:String = param1.target.url;
         var _loc4_:String = _loc3_.substr(4,_loc3_.length);
         for each(_loc5_ in this.pendingLookups[_loc4_])
         {
            _loc5_(_loc2_);
         }
         this.pendingLookups[_loc4_] = null;
         this._cachedBitmapsByRunePath[_loc4_] = _loc2_;
      }
      
      public function clearCache() : void
      {
         this.pendingLookups = new Dictionary();
         this._cachedBitmapsByRunePath = new Dictionary();
      }
   }
}

