package com.riotgames.pvpnet.endofgamegiftwindow.enums
{
   public class ImageTypes
   {
      
      public static const IMAGE_SIZE_LARGE:String = "large";
      
      public static const IMAGE_SIZE_REGULAR:String = "regs";
      
      public static const IMAGE_SIZE_ICON:String = "icon";
      
      public static const IMAGE_TYPE_CHAMP_PORTRAIT_LARGE:String = "champPortraitLarge";
      
      public static const IMAGE_TYPE_CHAMP_PORTRAIT_REG:String = "champPortraitReg";
      
      public static const IMAGE_TYPE_CHAMP_ICON:String = "champIcon";
      
      public static const IMAGE_TYPE_CHAMP_SKIN:String = "champSkin";
      
      public static const IMAGE_TYPE_CHAMP_SKIN_ICON:String = "champSkinIcon";
      
      public static const IMAGE_TYPE_MYSTERY_PORTRAIT:String = "giftPortrait";
      
      public static const IMAGE_TYPE_MYSTERY_ICON:String = "giftIcon";
      
      private static const UNDERSCORE_DELIMITER:String = "_";
      
      private static const PERIOD_DELIMITER:String = ".";
      
      public function ImageTypes()
      {
         super();
      }
      
      public static function getImageTypeFromInventoryType(param1:String, param2:String) : String
      {
         switch(param1)
         {
            case GiftTypes.GIFT_TYPE_CHAMPION:
               return getChampImageBySize(param2);
            case GiftTypes.GIFT_TYPE_SKIN:
               return getSkinImageBySize(param2);
            case GiftTypes.GIFT_TYPE_MYSTERY:
            case GiftTypes.GIFT_TYPE_MYSTERY_CHAMPION:
            case GiftTypes.GIFT_TYPE_MYSTERY_SKIN:
         }
         return getMysteryImageTypeBySize(param2);
      }
      
      public static function getChampIDFromTypeAndFilename(param1:String, param2:String) : Number
      {
         switch(param1)
         {
            case IMAGE_TYPE_CHAMP_SKIN:
            case IMAGE_TYPE_CHAMP_SKIN_ICON:
               return getSkinChampID(param2);
            case IMAGE_TYPE_CHAMP_ICON:
            case IMAGE_TYPE_CHAMP_PORTRAIT_LARGE:
            case IMAGE_TYPE_CHAMP_PORTRAIT_REG:
         }
         return getNormalChampID(param2);
      }
      
      public static function getChampIDFromItemID(param1:Number) : Number
      {
         return int(param1 / 1000);
      }
      
      public static function getSkinIndexFromItemID(param1:Number) : Number
      {
         return int(param1 % 100);
      }
      
      public static function getSkinIndexFromFileName(param1:String) : Number
      {
         var _loc2_:Number = getItemIDFromFilename(param1);
         return getSkinIndexFromItemID(_loc2_);
      }
      
      private static function getNormalChampID(param1:String) : Number
      {
         var _loc2_:String = param1.slice(0,param1.indexOf(UNDERSCORE_DELIMITER));
         return parseInt(_loc2_);
      }
      
      private static function getSkinChampID(param1:String) : Number
      {
         var _loc2_:Number = getItemIDFromFilename(param1);
         return getChampIDFromItemID(_loc2_);
      }
      
      private static function getItemIDFromFilename(param1:String) : Number
      {
         var _loc2_:String = param1.substring(param1.indexOf(UNDERSCORE_DELIMITER) + 1,param1.lastIndexOf(PERIOD_DELIMITER));
         return parseInt(_loc2_);
      }
      
      private static function getChampImageBySize(param1:String) : String
      {
         switch(param1)
         {
            case IMAGE_SIZE_ICON:
               return IMAGE_TYPE_CHAMP_ICON;
            case IMAGE_SIZE_LARGE:
               return IMAGE_TYPE_CHAMP_PORTRAIT_LARGE;
            case IMAGE_SIZE_REGULAR:
         }
         return IMAGE_TYPE_CHAMP_PORTRAIT_REG;
      }
      
      private static function getSkinImageBySize(param1:String) : String
      {
         switch(param1)
         {
            case IMAGE_SIZE_ICON:
               return IMAGE_TYPE_CHAMP_SKIN_ICON;
            case IMAGE_SIZE_REGULAR:
         }
         return IMAGE_TYPE_CHAMP_SKIN;
      }
      
      private static function getMysteryImageTypeBySize(param1:String) : String
      {
         switch(param1)
         {
            case IMAGE_SIZE_ICON:
               return IMAGE_TYPE_MYSTERY_ICON;
            case IMAGE_SIZE_REGULAR:
            case IMAGE_SIZE_LARGE:
         }
         return IMAGE_TYPE_MYSTERY_PORTRAIT;
      }
   }
}

