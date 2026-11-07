package com.riotgames.pvpnet.CLS.localeHelper
{
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   
   public class LocaleHelper implements ILocaleHelper
   {
      
      private static const MODULE_NAME:String = "LeagueSystemIron";
      
      private static const LEAGUE_NAMES:String = "LeagueNames";
      
      public function LocaleHelper()
      {
         super();
      }
      
      public function localeLookup(param1:String, param2:Array = null) : String
      {
         var _loc3_:String = RiotResourceLoader.getResourceString(MODULE_NAME,param1,"**" + param1,param2);
         return _loc3_.split("\\n").join("\n");
      }
      
      public function externalLocaleLookup(param1:String, param2:String, param3:Array = null) : String
      {
         var _loc4_:String = RiotResourceLoader.getResourceString(param1,param2,"**" + param2,param3);
         return _loc4_.split("\\n").join("\n");
      }
      
      public function getLeagueName(param1:String) : String
      {
         var _loc2_:RegExp = /[^A-Za-z]/;
         param1 = param1.split("\'").join("");
         param1 = param1.split(_loc2_).join("");
         var _loc3_:String = RiotResourceLoader.getResourceString(LEAGUE_NAMES,param1,"**" + param1);
         return _loc3_.split("\\n").join("\n");
      }
   }
}

