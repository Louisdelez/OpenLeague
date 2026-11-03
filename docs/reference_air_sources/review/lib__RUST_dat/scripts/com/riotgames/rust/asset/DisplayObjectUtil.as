package com.riotgames.rust.asset
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   
   public class DisplayObjectUtil
   {
      
      public function DisplayObjectUtil()
      {
         super();
      }
      
      public static function replaceAsset(param1:DisplayObject, param2:DisplayObject) : void
      {
         var _loc4_:int = 0;
         param2.scaleX = param1.scaleX;
         param2.scaleY = param1.scaleY;
         param2.rotation = param1.rotation;
         param2.x = param1.x;
         param2.y = param1.y;
         var _loc3_:DisplayObjectContainer = param1.parent;
         if(Boolean(_loc3_))
         {
            _loc4_ = _loc3_.getChildIndex(param1);
            _loc3_.removeChildAt(_loc4_);
            _loc3_.addChildAt(param2,_loc4_);
         }
      }
   }
}

