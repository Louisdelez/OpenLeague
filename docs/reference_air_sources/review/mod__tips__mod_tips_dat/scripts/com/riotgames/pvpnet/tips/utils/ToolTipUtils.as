package com.riotgames.pvpnet.tips.utils
{
   import flash.display.Screen;
   import flash.geom.Rectangle;
   
   public class ToolTipUtils
   {
      
      public function ToolTipUtils()
      {
         super();
      }
      
      public static function getVisibleScreenBounds(param1:Number, param2:Number) : Rectangle
      {
         var _loc4_:Screen = null;
         var _loc3_:Array = Screen.getScreensForRectangle(new Rectangle(param1,param2,1,1));
         if(Boolean(_loc3_) && _loc3_.length > 0)
         {
            _loc4_ = _loc3_[0];
         }
         else
         {
            _loc4_ = Screen.mainScreen;
         }
         return _loc4_.visibleBounds;
      }
   }
}

