package com.greensock.easing
{
   import com.greensock.TweenLite;
   
   public class FastEase
   {
      
      public function FastEase()
      {
         super();
      }
      
      public static function activateEase(ease:Function, type:int, power:uint) : void
      {
         TweenLite.fastEaseLookup[ease] = [type,power];
      }
      
      public static function activate(easeClasses:Array) : void
      {
         var easeClass:Object = null;
         var i:int = int(easeClasses.length);
         while(Boolean(i--))
         {
            easeClass = easeClasses[i];
            if(easeClass.hasOwnProperty("power"))
            {
               activateEase(easeClass.easeIn,1,easeClass.power);
               activateEase(easeClass.easeOut,2,easeClass.power);
               activateEase(easeClass.easeInOut,3,easeClass.power);
               if(easeClass.hasOwnProperty("easeNone"))
               {
                  activateEase(easeClass.easeNone,1,0);
               }
            }
         }
      }
   }
}

