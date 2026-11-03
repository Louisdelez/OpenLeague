package com.riotgames.platform.gameclient.utils
{
   import mx.effects.Fade;
   
   public class AnimationHelper
   {
      
      public static var animate:Boolean = true;
      
      public function AnimationHelper()
      {
         super();
      }
      
      public static function playFadeInEffect(param1:*, param2:Number = 600, param3:Number = 0) : void
      {
         var _loc4_:Fade = null;
         animate = false;
         if(animate)
         {
            param1.visible = true;
            _loc4_ = new Fade();
            _loc4_.target = param1;
            _loc4_.duration = param2;
            _loc4_.alphaFrom = 0;
            _loc4_.alphaTo = 1;
            _loc4_.startDelay = param3;
            _loc4_.end();
            _loc4_.play();
         }
      }
      
      public static function playFadeOutEffect(param1:*, param2:Number = 1000, param3:Number = 0) : void
      {
         var _loc4_:Fade = null;
         animate = false;
         if(animate)
         {
            _loc4_ = new Fade();
            _loc4_.target = param1;
            _loc4_.duration = param2;
            _loc4_.alphaFrom = 1;
            _loc4_.alphaTo = 0;
            _loc4_.startDelay = param3;
            _loc4_.end();
            _loc4_.play();
         }
      }
   }
}

