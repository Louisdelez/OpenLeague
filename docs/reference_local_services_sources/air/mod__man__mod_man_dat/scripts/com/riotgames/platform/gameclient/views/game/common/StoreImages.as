package com.riotgames.platform.gameclient.views.game.common
{
   import mx.logging.ILogger;
   import mx.logging.Log;
   
   public class StoreImages
   {
      
      private static var logger:ILogger = Log.getLogger("com.riotgames.pvpnet.endofgamegiftwindow.views.StoreImages");
      
      public static const BASE_ASSET_PATH:String = "assets/storeImages/content/";
      
      private static const CHAMP_PORTRAITS_LARGE:String = "champion_portraits/";
      
      private static const CHAMP_PORTRAITS:String = "champion_portraits_cards/";
      
      private static const CHAMP_ICONS:String = "champions/";
      
      private static const CHAMP_SKINS:String = "skins/";
      
      private static const GIFT_ICON:String = "";
      
      private static const GIFT_PORTRAIT:String = "mystery/";
      
      public function StoreImages()
      {
         super();
      }
      
      public static function getChampPortraitPath(param1:Number, param2:Boolean = false) : String
      {
         var _loc3_:String = BASE_ASSET_PATH;
         if(param2)
         {
            _loc3_ += CHAMP_PORTRAITS_LARGE;
         }
         else
         {
            _loc3_ += CHAMP_PORTRAITS;
         }
         return _loc3_ + getPortraitFileName(param1);
      }
      
      public static function getPortraitFileName(param1:Number) : String
      {
         return param1.toString() + "_Web_0.jpg";
      }
      
      public static function getChampIconPath(param1:Number) : String
      {
         return BASE_ASSET_PATH + CHAMP_ICONS + getPortraitFileName(param1);
      }
      
      public static function getGiftPortraitFileName() : String
      {
         return "g-m.jpg";
      }
      
      public static function getGiftPortrait() : String
      {
         return BASE_ASSET_PATH + GIFT_PORTRAIT + getGiftPortraitFileName();
      }
      
      public static function getSkinPortraitFileName(param1:Number, param2:Number) : String
      {
         return "championsskin_" + param1.toString() + "00" + param2.toString() + ".jpg";
      }
      
      public static function getChampionSkinPortrait(param1:Number, param2:Number) : String
      {
         return BASE_ASSET_PATH + CHAMP_SKINS + getSkinPortraitFileName(param1,param2);
      }
   }
}

