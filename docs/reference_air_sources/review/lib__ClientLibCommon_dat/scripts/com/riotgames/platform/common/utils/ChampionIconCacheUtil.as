package com.riotgames.platform.common.utils
{
   import blix.action.LoaderAction;
   import com.riotgames.platform.gameclient.domain.Champion;
   import flash.display.Bitmap;
   import flash.display.BitmapData;
   import flash.display.LoaderInfo;
   import flash.geom.Point;
   import flash.net.URLRequest;
   import flash.utils.Dictionary;
   
   public class ChampionIconCacheUtil
   {
      
      private static var _instance:ChampionIconCacheUtil;
      
      private const ICON_CHAMPION_SKIN_INDEX:int = 0;
      
      private const IMAGE_DEFAULT_COLOR:uint = 4278190080;
      
      private const BASE_ASSET_PATH:String = "/assets/images/champions/";
      
      private const ICON_SIZE:Point = new Point(120,120);
      
      private const RANDOM_ICON_FILE_SUFFIX:String = "_" + this.ICON_CHAMPION_SKIN_INDEX + ".jpg";
      
      private const ICON_FILE_SUFFIX:String = "_Square_" + this.ICON_CHAMPION_SKIN_INDEX + ".png";
      
      private var _cachedBitmapDataBySkinName:Dictionary = new Dictionary();
      
      public function ChampionIconCacheUtil()
      {
         super();
      }
      
      public static function get instance() : ChampionIconCacheUtil
      {
         if(!_instance)
         {
            _instance = new ChampionIconCacheUtil();
         }
         return _instance;
      }
      
      private function onIconLoadErred(param1:ChampionIconLoaderAction) : void
      {
         var _loc2_:Function = param1.getCallback();
         if(_loc2_ != null)
         {
            _loc2_(null);
         }
      }
      
      public function getIcon(param1:String) : BitmapData
      {
         var _loc2_:BitmapData = null;
         var _loc3_:String = null;
         var _loc4_:LoaderAction = null;
         if(Boolean(this._cachedBitmapDataBySkinName[param1]))
         {
            _loc2_ = this._cachedBitmapDataBySkinName[param1];
         }
         else
         {
            _loc2_ = new BitmapData(this.ICON_SIZE.x,this.ICON_SIZE.y,true,this.IMAGE_DEFAULT_COLOR);
            this._cachedBitmapDataBySkinName[param1] = _loc2_;
            _loc3_ = this.getIconPath(param1);
            if(_loc3_ != null)
            {
               _loc4_ = new ChampionIconLoaderAction(new URLRequest(_loc3_),param1);
               _loc4_.getCompleted().addOnce(this.onIconLoaded);
               _loc4_.invoke();
            }
         }
         return _loc2_;
      }
      
      public function getIconWithCallback(param1:String, param2:Function) : void
      {
         var _loc3_:String = null;
         var _loc4_:LoaderAction = null;
         if(Boolean(this._cachedBitmapDataBySkinName[param1]))
         {
            param2(this._cachedBitmapDataBySkinName[param1]);
         }
         else
         {
            this._cachedBitmapDataBySkinName[param1] = new BitmapData(this.ICON_SIZE.x,this.ICON_SIZE.y,true,this.IMAGE_DEFAULT_COLOR);
            _loc3_ = this.getIconPath(param1);
            if(_loc3_ != null)
            {
               _loc4_ = new ChampionIconLoaderAction(new URLRequest(_loc3_),param1,param2);
               _loc4_.getCompleted().addOnce(this.onIconLoaded);
               _loc4_.getErred().addOnce(this.onIconLoadErred);
               _loc4_.invoke();
            }
         }
      }
      
      public function getIconPath(param1:String) : String
      {
         var _loc2_:String = this.BASE_ASSET_PATH + param1;
         if(param1 == Champion.RANDOM_SKIN_NAME)
         {
            _loc2_ += this.RANDOM_ICON_FILE_SUFFIX;
         }
         else
         {
            _loc2_ += this.ICON_FILE_SUFFIX;
         }
         return _loc2_;
      }
      
      private function onIconLoaded(param1:ChampionIconLoaderAction) : void
      {
         var _loc3_:BitmapData = null;
         var _loc2_:LoaderInfo = param1.loader.contentLoaderInfo;
         var _loc4_:BitmapData = this._cachedBitmapDataBySkinName[param1.getSkinName()] as BitmapData;
         if(_loc2_.loader.content is Bitmap)
         {
            _loc3_ = (_loc2_.loader.content as Bitmap).bitmapData;
            _loc4_.copyPixels(_loc3_,_loc3_.rect,new Point());
            _loc3_.dispose();
         }
         var _loc5_:Function = param1.getCallback();
         if(_loc5_ != null)
         {
            _loc5_(_loc4_);
         }
      }
   }
}

