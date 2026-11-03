package com.riotgames.platform.common
{
   import com.riotgames.platform.common.utils.LoaderUtilImagePacks;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.GameItem;
   import com.riotgames.platform.gameclient.domain.Spell;
   import com.riotgames.platform.gameclient.domain.game.GameMap;
   import com.riotgames.platform.gameclient.masteries.Talent;
   import com.riotgames.util.logging.getLogger;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.utils.Dictionary;
   import mx.core.BitmapAsset;
   
   public class ImagePackLookup
   {
      
      private static var _instance:ImagePackLookup;
      
      private static const prefix:String = "e_";
      
      private var _masterClassMap:Dictionary = new Dictionary();
      
      private var _imagePackLoader:LoaderUtilImagePacks;
      
      private var _loadCallback:Function;
      
      public function ImagePackLookup(param1:SingletonEnforcer)
      {
         super();
      }
      
      public static function get instance() : ImagePackLookup
      {
         if(!_instance)
         {
            _instance = new ImagePackLookup(new SingletonEnforcer());
         }
         return _instance;
      }
      
      public function getSpellBitmap(param1:Spell) : Bitmap
      {
         return new Bitmap(this.getBitmapData(ImagePackLookup.prefix + "Spell_" + param1.name),"auto",true);
      }
      
      public function getMapSource(param1:GameMap) : *
      {
         return param1 == null ? null : this.getClassFromSwfRef(ImagePackLookup.prefix + "map_" + param1.mapId.toString());
      }
      
      public function getItemSource(param1:GameItem) : *
      {
         return this.getClassFromSwfRef(ImagePackLookup.prefix + param1.iconName);
      }
      
      public function getSpellSource(param1:Spell) : *
      {
         var _loc2_:* = this.getClassFromSwfRef(ImagePackLookup.prefix + "Spell_" + param1.name);
         if(_loc2_ == null)
         {
            _loc2_ = this.getClassFromSwfRef(ImagePackLookup.prefix + "Spell_None");
         }
         return _loc2_;
      }
      
      public function initializeImagePacks(param1:Function) : void
      {
         this._loadCallback = param1;
         this._imagePackLoader = new LoaderUtilImagePacks();
         this._imagePackLoader.imagePacksLoaded.addOnce(this.onImagePacksLoaded);
         this._imagePackLoader.loadImagePacks();
      }
      
      public function getMinimapSource(param1:GameMap) : *
      {
         return this.getClassFromSwfRef(ImagePackLookup.prefix + "minimap_" + param1.mapId.toString());
      }
      
      private function onImagePacksLoaded(param1:Dictionary) : void
      {
         this._masterClassMap = param1;
         if(this._loadCallback != null)
         {
            this._loadCallback.apply();
            this._loadCallback = null;
         }
         this._imagePackLoader = null;
      }
      
      public function getSpellScreenshotSource(param1:Spell) : *
      {
         var _loc2_:* = this.getClassFromSwfRef(ImagePackLookup.prefix + param1.name);
         if(_loc2_ == null)
         {
            _loc2_ = this.getClassFromSwfRef(ImagePackLookup.prefix + "SummonerNone");
         }
         return _loc2_;
      }
      
      public function getProfileIconData(param1:int, param2:String = "") : BitmapData
      {
         return this.getBitmapData(ImagePackLookup.prefix + "profileIcon" + param2 + param1.toString());
      }
      
      public function getMasteryBitmap(param1:Talent) : Bitmap
      {
         return new Bitmap(this.getBitmapData(ImagePackLookup.prefix + param1.tltId),"auto",true);
      }
      
      public function getClassFromSwfRef(param1:String) : *
      {
         var _loc2_:String = null;
         if(param1 != null && param1.length > 0)
         {
            _loc2_ = param1.toUpperCase();
            _loc2_ = _loc2_.replace(/-/g,"_");
            return this._masterClassMap[_loc2_];
         }
         return null;
      }
      
      public function getBitmapData(param1:String, param2:Boolean = true) : BitmapData
      {
         var _loc4_:BitmapAsset = null;
         var _loc3_:Class = this.getClassFromSwfRef(param1);
         if(_loc3_ != null)
         {
            _loc4_ = new _loc3_() as BitmapAsset;
            if(_loc4_ != null)
            {
               return _loc4_.bitmapData;
            }
         }
         if(param2)
         {
            getLogger(this).warn("Asset named: " + param1 + " missing.");
         }
         return null;
      }
      
      public function getChampionListItemBitmap(param1:Champion) : Bitmap
      {
         var _loc2_:Bitmap = null;
         var _loc3_:BitmapData = this.getBitmapData(ImagePackLookup.prefix + param1.skinName + "_lrgportrait");
         if(_loc3_ != null)
         {
            _loc2_ = new Bitmap(_loc3_);
         }
         return _loc2_;
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
