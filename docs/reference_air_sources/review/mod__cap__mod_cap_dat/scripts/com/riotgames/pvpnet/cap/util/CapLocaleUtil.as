package com.riotgames.pvpnet.cap.util
{
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.pvpnet.cap.ClientModuleCap;
   
   public class CapLocaleUtil
   {
      
      public function CapLocaleUtil()
      {
         super();
         throw new Error("This is a static utility class.  Do not instantiate");
      }
      
      public static function getResourceString(param1:String, param2:String, param3:Array = null) : String
      {
         var _loc4_:String = "**" + param2;
         return RiotResourceLoader.getResourceString(ClientModuleCap.MODULE_RESOURCE_BUNDLE_NAME,param1,_loc4_,param3);
      }
   }
}

