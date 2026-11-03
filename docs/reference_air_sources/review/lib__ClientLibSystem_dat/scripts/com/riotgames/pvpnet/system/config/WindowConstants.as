package com.riotgames.pvpnet.system.config
{
   import flash.display.NativeWindow;
   import flash.display.Screen;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   
   public class WindowConstants
   {
      
      public static const DEFAULT_SCREEN_WIDTH:Number = 1280;
      
      public static const DEFAULT_SCREEN_HEIGHT:Number = 800;
      
      public static const MINIMUM_SCREEN_WIDTH:Number = 1024;
      
      public static const MINIMUM_SCREEN_HEIGHT:Number = 640;
      
      private static const DEGRADING_RESOLUTIONS:Array = [new Point(DEFAULT_SCREEN_WIDTH,DEFAULT_SCREEN_HEIGHT),new Point(1152,720),new Point(MINIMUM_SCREEN_WIDTH,MINIMUM_SCREEN_HEIGHT)];
      
      public static const ENFORCED_ASPECT_RATIO:Number = 1.6;
      
      public function WindowConstants()
      {
         super();
      }
      
      public static function requiresSmallResolutionSupport(param1:NativeWindow) : Boolean
      {
         var _loc2_:Screen = getScreenForWindow(param1);
         var _loc3_:Rectangle = _loc2_.visibleBounds;
         if(_loc3_ != null && _loc3_.width > 0 && _loc3_.height > 0)
         {
            if(_loc3_.width <= DEFAULT_SCREEN_WIDTH || _loc3_.height <= DEFAULT_SCREEN_HEIGHT)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function findSmallDefaultResolution(param1:NativeWindow) : Point
      {
         var _loc4_:Point = null;
         var _loc2_:Screen = getScreenForWindow(param1);
         var _loc3_:Rectangle = _loc2_.visibleBounds;
         if(_loc3_ != null && _loc3_.width > 0 && _loc3_.height > 0)
         {
            for each(_loc4_ in DEGRADING_RESOLUTIONS)
            {
               if(_loc3_.width >= _loc4_.x && _loc3_.height >= _loc4_.y)
               {
                  return _loc4_;
               }
            }
         }
         return new Point(MINIMUM_SCREEN_WIDTH,MINIMUM_SCREEN_HEIGHT);
      }
      
      public static function getCurrentScreenVisibleBounds(param1:NativeWindow) : Rectangle
      {
         var _loc2_:Screen = getScreenForWindow(param1);
         return _loc2_.visibleBounds;
      }
      
      public static function getScreenForWindow(param1:NativeWindow) : Screen
      {
         var _loc3_:Screen = null;
         var _loc5_:Screen = null;
         var _loc6_:Number = NaN;
         var _loc2_:Array = Screen.getScreensForRectangle(new Rectangle(param1.x,param1.y,param1.width,param1.height));
         var _loc4_:Number = 0;
         if(_loc2_ != null && _loc2_.length > 0)
         {
            for each(_loc5_ in _loc2_)
            {
               if(_loc3_ == null)
               {
                  _loc3_ = _loc5_;
                  _loc4_ = Number(_loc3_.visibleBounds.intersection(param1.bounds).size.length);
               }
               else
               {
                  _loc6_ = Number(_loc5_.visibleBounds.intersection(param1.bounds).size.length);
                  if(_loc4_ < _loc6_)
                  {
                     _loc3_ = _loc5_;
                     _loc4_ = _loc6_;
                  }
               }
            }
         }
         else
         {
            _loc3_ = Screen.mainScreen;
         }
         return _loc3_;
      }
   }
}

