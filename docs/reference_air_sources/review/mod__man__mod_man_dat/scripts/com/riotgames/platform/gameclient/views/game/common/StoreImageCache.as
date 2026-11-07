package com.riotgames.platform.gameclient.views.game.common
{
   import com.riotgames.platform.common.provider.IStoreImagesProvider;
   import flash.display.Bitmap;
   import flash.display.PixelSnapping;
   import flash.utils.Dictionary;
   
   public class StoreImageCache implements IStoreImagesProvider
   {
      
      private static var _instance:StoreImageCache;
      
      protected static var _imageCache:Dictionary = new Dictionary();
      
      public function StoreImageCache(param1:SingletonEnforcer)
      {
         super();
      }
      
      public static function get instance() : StoreImageCache
      {
         if(_instance == null)
         {
            _instance = new StoreImageCache(new SingletonEnforcer());
         }
         return _instance;
      }
      
      public function getMysteryGiftPortraitAssetPath() : String
      {
         return StoreImages.getGiftPortraitFileName();
      }
      
      public function getChampSkinIcon(param1:Number, param2:Number, param3:Function) : void
      {
         var _loc4_:String = StoreImages.getChampionSkinPortrait(param1,param2);
         this.handleKey(_loc4_,param3,true);
      }
      
      public function getChampClassicPortrait(param1:Number, param2:Function, param3:Boolean = false) : void
      {
         var _loc4_:String = StoreImages.getChampPortraitPath(param1,param3);
         this.handleKey(_loc4_,param2);
      }
      
      private function copyBitmap(param1:Bitmap) : Bitmap
      {
         return new Bitmap(param1.bitmapData,PixelSnapping.AUTO,true);
      }
      
      public function getMysteryGiftPortrait(param1:Function) : void
      {
         this.getGiftPortrait(param1);
      }
      
      private function handleKey(param1:String, param2:Function, param3:Boolean = false) : void
      {
         if(param3)
         {
            this.fetchFabricatedIconCacheEntry(param1,param2);
         }
         else
         {
            this.fetchCacheEntry(param1,param2);
         }
      }
      
      private function fetchFabricatedIconCacheEntry(param1:String, param2:Function) : void
      {
         var _loc4_:ImageCacheEntry = null;
         var _loc5_:Bitmap = null;
         var _loc6_:ImageCacheEntry = null;
         var _loc3_:String = this.iconifySkinPortraitString(param1);
         if(_loc3_ in _imageCache)
         {
            _loc4_ = _imageCache[_loc3_];
            if(_loc4_.isLoaded())
            {
               _loc5_ = this.fetchEntryFromCacheByKey(_loc3_);
               param2(_loc5_);
            }
            else
            {
               _loc4_.addCallback(param2);
            }
         }
         else
         {
            _loc6_ = this.createNewFabricatedEntry(param1,_loc3_);
            this.loadEntry(_loc6_,param2);
         }
      }
      
      public function getChampSkinPortraitAssetNameFromChampIDAndSkinIndex(param1:Number, param2:Number) : String
      {
         return StoreImages.getSkinPortraitFileName(param1,param2);
      }
      
      private function createNewFabricatedEntry(param1:String, param2:String) : ImageCacheEntry
      {
         var _loc3_:ImageCacheEntry = new ImageCacheEntry(param1,true);
         _imageCache[param2] = _loc3_;
         return _imageCache[param2];
      }
      
      public function getChampPortraitAssetNameFromChampID(param1:Number) : String
      {
         return StoreImages.getPortraitFileName(param1);
      }
      
      public function getChampIcon(param1:Number, param2:Function) : void
      {
         var _loc3_:String = StoreImages.getChampIconPath(param1);
         this.handleKey(_loc3_,param2);
      }
      
      public function getGiftPortrait(param1:Function) : void
      {
         var _loc2_:String = StoreImages.getGiftPortrait();
         this.handleKey(_loc2_,param1);
      }
      
      private function fetchCacheEntry(param1:String, param2:Function) : void
      {
         var _loc3_:ImageCacheEntry = null;
         var _loc4_:Bitmap = null;
         var _loc5_:ImageCacheEntry = null;
         if(param1 in _imageCache)
         {
            _loc3_ = _imageCache[param1];
            if(_loc3_.isLoaded())
            {
               _loc4_ = this.fetchEntryFromCacheByKey(param1);
               param2(_loc4_);
            }
            else
            {
               _loc3_.addCallback(param2);
            }
         }
         else
         {
            _loc5_ = this.createNewCacheEntry(param1);
            this.loadEntry(_loc5_,param2);
         }
      }
      
      private function iconifySkinPortraitString(param1:String) : String
      {
         return param1.replace("skin_","skinIcon_");
      }
      
      private function fetchEntryFromCacheByKey(param1:String) : Bitmap
      {
         var _loc2_:ImageCacheEntry = _imageCache[param1];
         return this.copyBitmap(_loc2_.getBitmap());
      }
      
      public function getChampSkinPortrait(param1:Number, param2:Number, param3:Function) : void
      {
         var _loc4_:String = StoreImages.getChampionSkinPortrait(param1,param2);
         this.handleKey(_loc4_,param3);
      }
      
      private function createNewCacheEntry(param1:String) : ImageCacheEntry
      {
         var _loc2_:ImageCacheEntry = new ImageCacheEntry(param1);
         _imageCache[param1] = _loc2_;
         return _imageCache[param1];
      }
      
      public function getMysteryGiftIcon(param1:Function) : void
      {
         this.handleKey("",param1);
      }
      
      private function loadEntry(param1:ImageCacheEntry, param2:Function) : void
      {
         param1.addCallback(param2);
         param1.loadBitmap();
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
