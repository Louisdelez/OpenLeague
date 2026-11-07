package com.riotgames.pvpnet.endofgamegiftwindow.enums
{
   public class GiftTypes
   {
      
      public static const GIFT_TYPE_SKIN:String = "CHAMPION_SKIN";
      
      public static const GIFT_TYPE_CHAMPION:String = "CHAMPION";
      
      public static const GIFT_TYPE_MYSTERY_SKIN:String = "giftTypeMysterySkin";
      
      public static const GIFT_TYPE_MYSTERY_CHAMPION:String = "giftTypeMysteryChampion";
      
      public static const GIFT_TYPE_MYSTERY:String = "MYSTERY";
      
      public function GiftTypes()
      {
         super();
      }
      
      public static function getGiftType(param1:String) : String
      {
         var _loc2_:String = param1.toLocaleLowerCase();
         if(_loc2_.indexOf("skin") != -1)
         {
            if(_loc2_.indexOf("mystery") != -1)
            {
               return GIFT_TYPE_MYSTERY_SKIN;
            }
            return GIFT_TYPE_SKIN;
         }
         if(_loc2_.indexOf("champion") != -1)
         {
            if(_loc2_.indexOf("mystery") != -1)
            {
               return GIFT_TYPE_MYSTERY_CHAMPION;
            }
            return GIFT_TYPE_CHAMPION;
         }
         return GIFT_TYPE_MYSTERY;
      }
   }
}

