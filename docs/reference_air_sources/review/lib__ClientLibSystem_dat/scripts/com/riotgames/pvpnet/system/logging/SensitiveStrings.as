package com.riotgames.pvpnet.system.logging
{
   import flash.utils.Dictionary;
   
   public class SensitiveStrings
   {
      
      public static var sensitiveStrings:Dictionary = new Dictionary(true);
      
      public static var mute:int = 0;
      
      public function SensitiveStrings()
      {
         super();
      }
      
      public static function registerPrivateString(param1:Object, param2:Array) : void
      {
         sensitiveStrings[param1] = param2;
      }
   }
}

