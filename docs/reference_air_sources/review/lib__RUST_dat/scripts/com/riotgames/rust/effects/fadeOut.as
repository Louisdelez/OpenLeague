package com.riotgames.rust.effects
{
   import blix.util.display.rasterize;
   import com.greensock.TweenLite;
   import com.greensock.easing.Sine;
   import flash.display.DisplayObject;
   
   public function fadeOut(param1:DisplayObject, param2:Number = 0.5, param3:Function = null) : void
   {
      var _loc4_:DisplayObject = null;
      if(param1 != null && param1.parent != null && param1.width > 0 && param1.height > 0)
      {
         if(param3 == null)
         {
            param3 = Sine.easeOut;
         }
         _loc4_ = rasterize(param1);
         if(_loc4_ != null)
         {
            param1.parent.addChild(_loc4_);
            TweenLite.to(_loc4_,param2,{
               "alpha":0,
               "ease":param3,
               "onComplete":param1.parent.removeChild,
               "onCompleteParams":[_loc4_]
            });
         }
      }
   }
}

