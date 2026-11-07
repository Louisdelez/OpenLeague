package com.riotgames.pvpnet.seasonrewards.helpers
{
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   
   public class LocaleHelper implements ILocaleHelper
   {
      
      private static const MODULE_NAME:String = "SeasonRewards";
      
      public function LocaleHelper()
      {
         super();
      }
      
      public function localeLookup(param1:String, param2:Array = null) : String
      {
         return RiotResourceLoader.getResourceString(MODULE_NAME,param1,"**" + param1,param2);
      }
   }
}

