package com.riotgames.platform.common.utils
{
   import flash.display.DisplayObject;
   import flash.display.DisplayObjectContainer;
   
   public class DisplayObjectContainerUtil
   {
      
      public function DisplayObjectContainerUtil()
      {
         super();
      }
      
      public static function traceDisplayList(param1:DisplayObjectContainer, param2:String = "") : void
      {
         var _loc3_:DisplayObject = null;
         var _loc4_:uint = 0;
         while(_loc4_ < param1.numChildren)
         {
            _loc3_ = param1.getChildAt(_loc4_);
            trace(param2,_loc3_,_loc3_.name);
            if(param1.getChildAt(_loc4_) is DisplayObjectContainer)
            {
               traceDisplayList(DisplayObjectContainer(_loc3_),param2 + "    ");
            }
            _loc4_++;
         }
      }
      
      public static function removeAllChildren(param1:DisplayObjectContainer) : void
      {
         if(param1 == null)
         {
            return;
         }
         while(Boolean(param1.numChildren))
         {
            param1.removeChildAt(0);
         }
      }
   }
}

