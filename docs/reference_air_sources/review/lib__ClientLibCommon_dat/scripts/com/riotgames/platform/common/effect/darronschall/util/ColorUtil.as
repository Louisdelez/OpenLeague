package com.riotgames.platform.common.effect.darronschall.util
{
   public final class ColorUtil
   {
      
      public function ColorUtil()
      {
         super();
      }
      
      public static function intToRgb(param1:int) : Object
      {
         var _loc2_:int = (param1 & 0xFF0000) >> 16;
         var _loc3_:int = (param1 & 0xFF00) >> 8;
         var _loc4_:int = param1 & 0xFF;
         return {
            "r":_loc2_,
            "g":_loc3_,
            "b":_loc4_
         };
      }
   }
}

