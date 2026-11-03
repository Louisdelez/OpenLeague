package com.riotgames.pvpnet.cap.util
{
   public class LcdsProxyMessageActionDataUtil
   {
      
      public function LcdsProxyMessageActionDataUtil()
      {
         super();
         throw new Error("This is a static utility class.  Do not instantiate");
      }
      
      public static function getOptionalValue(param1:Object, param2:String) : *
      {
         return param1.hasOwnProperty(param2) ? param1[param2] : null;
      }
      
      public static function validate(param1:Object, param2:Array) : void
      {
         var _loc3_:String = null;
         for each(_loc3_ in param2)
         {
            if(!param1.hasOwnProperty(_loc3_))
            {
               throw new Error("Invalid message received - no data found for key: " + _loc3_);
            }
         }
      }
   }
}

